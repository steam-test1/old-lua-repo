-- Decompiled using luadec 2.0.1 by sztupy (http://winmo.sztupy.hu)
-- Command line was: F:\SteamLibrary\SteamApps\common\PAYDAY 2\lua\lib\units\civilians\logics\civilianlogicidle.luac 

local tmp_vec1 = Vector3()
CivilianLogicIdle = class(CopLogicBase)
CivilianLogicIdle.enter = function(l_1_0, l_1_1, l_1_2)
  CopLogicBase.enter(l_1_0, l_1_1, l_1_2)
  local my_data = {unit = l_1_0.unit}
  if not l_1_0.char_tweak.detection then
    debug_pause_unit(l_1_0.unit, "missing detection tweak_data", l_1_0.unit)
  end
  local is_cool = l_1_0.unit:movement():cool()
  if is_cool then
    my_data.detection = l_1_0.char_tweak.detection.ntl
  else
    my_data.detection = l_1_0.char_tweak.detection.cbt
  end
  my_data.rsrv_pos = {}
  local old_internal_data = l_1_0.internal_data
  if old_internal_data and not old_internal_data.rsrv_pos then
    my_data.rsrv_pos = my_data.rsrv_pos
  end
  l_1_0.internal_data = my_data
  if not my_data.rsrv_pos.stand then
    local pos_rsrv = {position = mvector3.copy(l_1_0.m_pos), radius = 45, filter = l_1_0.pos_rsrv_id}
    my_data.rsrv_pos.stand = pos_rsrv
    managers.navigation:add_pos_reservation(pos_rsrv)
  end
  CopLogicBase._reset_attention(l_1_0)
  l_1_0.unit:brain():set_update_enabled_state(false)
  local key_str = tostring(l_1_0.key)
  local objective = l_1_0.objective
  if objective then
    if objective.action and l_1_0.unit:brain():action_request(objective.action) and objective.action.type == "act" then
      my_data.acting = true
      if objective.action_start_clbk then
        objective.action_start_clbk(l_1_0.unit)
        if my_data ~= l_1_0.internal_data then
          return 
        end
      end
    end
    if objective.action_duration then
      my_data.action_timeout_clbk_id = "CivilianLogicIdle_action_timeout" .. key_str
      local action_timeout_t = l_1_0.t + objective.action_duration
      CopLogicBase.add_delayed_clbk(my_data, my_data.action_timeout_clbk_id, callback(CivilianLogicIdle, CivilianLogicIdle, "clbk_action_timeout", l_1_0), action_timeout_t)
    end
  end
  my_data.tmp_vec3 = Vector3()
  my_data.detection_task_key = "CivilianLogicIdle._upd_detection" .. key_str
  CopLogicBase.queue_task(my_data, my_data.detection_task_key, CivilianLogicIdle._upd_detection, l_1_0, l_1_0.t + 1)
  if not l_1_0.been_outlined and l_1_0.char_tweak.outline_on_discover then
    my_data.outline_detection_task_key = "CivilianLogicIdle._upd_outline_detection" .. tostring(l_1_0.key)
    CopLogicBase.queue_task(my_data, my_data.outline_detection_task_key, CivilianLogicIdle._upd_outline_detection, l_1_0, l_1_0.t + 2)
  end
  if not l_1_0.unit:movement():cool() then
    my_data.registered_as_fleeing = true
    managers.groupai:state():register_fleeing_civilian(l_1_0.key, l_1_0.unit)
  end
  if objective and objective.stance then
    l_1_0.unit:movement():set_stance(objective.stance)
  end
  local attention_settings = nil
  if is_cool then
    attention_settings = {"civ_all_peaceful"}
  else
    if not managers.groupai:state():enemy_weapons_hot() then
      attention_settings = {"civ_enemy_cbt", "civ_civ_cbt"}
      my_data.enemy_weapons_hot_listen_id = "CivilianLogicIdle" .. tostring(l_1_0.key)
      managers.groupai:state():add_listener(my_data.enemy_weapons_hot_listen_id, {"enemy_weapons_hot"}, callback(CivilianLogicIdle, CivilianLogicIdle, "clbk_enemy_weapons_hot", l_1_0))
    end
  end
  l_1_0.unit:brain():set_attention_settings(attention_settings)
end

CivilianLogicIdle.exit = function(l_2_0, l_2_1, l_2_2)
  CopLogicBase.exit(l_2_0, l_2_1, l_2_2)
  local my_data = l_2_0.internal_data
  if my_data.idle_attention and alive(my_data.idle_attention.unit) then
    CopLogicBase._reset_attention(l_2_0)
  end
  if my_data.enemy_weapons_hot_listen_id then
    managers.groupai:state():remove_listener(my_data.enemy_weapons_hot_listen_id)
  end
  CopLogicBase.cancel_delayed_clbks(my_data)
  CopLogicBase.cancel_queued_tasks(my_data)
  if my_data.registered_as_fleeing then
    managers.groupai:state():unregister_fleeing_civilian(l_2_0.key)
  end
end

CivilianLogicIdle._upd_outline_detection = function(l_3_0)
  local my_data = l_3_0.internal_data
  if l_3_0.been_outlined or l_3_0.has_outline then
    return 
  end
  local t = TimerManager:game():time()
  local visibility_slotmask = managers.slot:get_mask("AI_visibility")
  local seen = false
  local seeing_unit = nil
  local my_tracker = l_3_0.unit:movement():nav_tracker()
  local chk_vis_func = my_tracker.check_visibility
  for e_key,record in pairs(managers.groupai:state():all_criminals()) do
    if chk_vis_func(my_tracker, record.tracker) then
      local enemy_pos = record.m_det_pos
      local my_pos = l_3_0.unit:movement():m_head_pos()
      if mvector3.distance_sq(enemy_pos, my_pos) < 1440000 then
        local not_hit = World:raycast("ray", my_pos, enemy_pos, "slot_mask", visibility_slotmask, "ray_type", "ai_vision", "report")
        if not not_hit then
          seen = true
          seeing_unit = record.unit
      end
    end
  end
  if seen then
    CivilianLogicIdle._enable_outline(l_3_0)
  else
    CopLogicBase.queue_task(my_data, my_data.outline_detection_task_key, CivilianLogicIdle._upd_outline_detection, l_3_0, t + 0.33000001311302)
  end
end

CivilianLogicIdle._enable_outline = function(l_4_0)
  local my_data = l_4_0.internal_data
  l_4_0.unit:base():set_contour(true)
  l_4_0.has_outline = true
  l_4_0.been_outlined = true
  my_data.outline_detection_task_key = nil
end

CivilianLogicIdle.on_alert = function(l_5_0, l_5_1)
  local my_data = l_5_0.internal_data
  local my_dis, alert_delay = nil, nil
  local my_listen_pos = l_5_0.unit:movement():m_head_pos()
  local alert_epicenter = l_5_1[2]
  if CopLogicBase._chk_alert_obstructed(l_5_0.unit:movement():m_head_pos(), l_5_1) then
    return 
  end
  if CopLogicBase.is_alert_aggressive(l_5_1[1]) then
    if not l_5_0.unit:movement():cool() then
      local aggressor = l_5_1[5]
      if aggressor and aggressor:base() then
        local is_intimidation = nil
        if aggressor:base().is_local_player and managers.player:has_category_upgrade("player", "civ_calming_alerts") then
          is_intimidation = true
          do return end
          if aggressor:base().is_husk_player and aggressor:base():upgrade_value("player", "civ_calming_alerts") then
            is_intimidation = true
          end
        end
        if is_intimidation then
          l_5_0.unit:brain():on_intimidated(1, aggressor)
          return 
        end
      end
    end
    l_5_0.unit:movement():set_cool(false, managers.groupai:state().analyse_giveaway(l_5_0.unit:base()._tweak_table, l_5_1[5], l_5_1))
    l_5_0.unit:movement():set_stance("hos")
  end
  if l_5_1[5] then
    local att_obj_data, is_new = CopLogicBase.identify_attention_obj_instant(l_5_0, l_5_1[5]:key())
  end
  my_dis = my_dis or (alert_epicenter and mvector3.distance(my_listen_pos, alert_epicenter)) or 3000
  alert_delay = math.lerp(1, 4, math.min(1, (my_dis) / 2000)) * math.random()
  if not my_data.delayed_alert_id then
    my_data.delayed_alert_id = "alert" .. tostring(l_5_0.key)
    CopLogicBase.add_delayed_clbk(my_data, my_data.delayed_alert_id, callback(CivilianLogicIdle, CivilianLogicIdle, "_delayed_alert_clbk", {data = l_5_0, alert_data = clone(l_5_1)}), TimerManager:game():time() + alert_delay)
  end
end

CivilianLogicIdle._delayed_alert_clbk = function(l_6_0, l_6_1)
  local data = l_6_1.data
  local alert_data = l_6_1.alert_data
  local my_data = data.internal_data
  CopLogicBase.on_delayed_clbk(my_data, my_data.delayed_alert_id)
  my_data.delayed_alert_id = nil
  local alerting_unit = alert_data[5]
  if not alive(alerting_unit) or not CivilianLogicIdle.is_obstructed(data, alerting_unit) then
    my_data.delayed_alert_id = "alert" .. tostring(data.key)
    CopLogicBase.add_delayed_clbk(my_data, my_data.delayed_alert_id, callback(CivilianLogicIdle, CivilianLogicIdle, "_delayed_alert_clbk", {data = data, alert_data = clone(alert_data)}), TimerManager:game():time() + 1)
    return 
  end
  alert_data[5] = alerting_unit
  if not data.call_police_delay_t then
    data.call_police_delay_t = TimerManager:game():time() + 20 + 10 * math.random()
  end
  data.unit:brain():set_objective({type = "free", alert_data = alert_data, is_default = true})
end

CivilianLogicIdle.on_intimidated = function(l_7_0, l_7_1, l_7_2)
  l_7_0.unit:movement():set_cool(false, managers.groupai:state().analyse_giveaway(l_7_0.unit:base()._tweak_table, l_7_2))
  l_7_0.unit:movement():set_stance("hos")
  local att_obj_data, is_new = CopLogicBase.identify_attention_obj_instant(l_7_0, l_7_2:key())
  if not l_7_0.char_tweak.intimidateable or l_7_0.unit:base().unintimidateable or l_7_0.unit:anim_data().unintimidateable then
    return 
  end
  if not CivilianLogicIdle.is_obstructed(l_7_0, l_7_2) then
    return 
  end
  l_7_0.unit:brain():set_objective({type = "surrender", amount = l_7_1, aggressor_unit = l_7_2})
end

CivilianLogicIdle.damage_clbk = function(l_8_0, l_8_1)
  l_8_0.unit:movement():set_cool(false, managers.groupai:state().analyse_giveaway(l_8_0.unit:base()._tweak_table, l_8_1.attacker_unit))
  l_8_0.unit:movement():set_stance("hos")
  if not CivilianLogicIdle.is_obstructed(l_8_0, l_8_1.attacker_unit) then
    return 
  end
  l_8_0.unit:brain():set_objective({type = "free", is_default = true, dmg_info = l_8_1})
end

CivilianLogicIdle.on_new_objective = function(l_9_0, l_9_1)
  local new_objective = l_9_0.objective
  local my_data = l_9_0.internal_data
  if new_objective then
    if new_objective.type == "escort" then
      CopLogicBase._exit(l_9_0.unit, "escort")
    elseif new_objective.nav_seg and not new_objective.in_place then
      CopLogicBase._exit(l_9_0.unit, "travel")
    elseif new_objective.type == "act" then
      CopLogicBase._exit(l_9_0.unit, "idle")
    elseif new_objective.type == "free" then
      if l_9_0.unit:movement():cool() or not new_objective.is_default then
        CopLogicBase._exit(l_9_0.unit, "idle")
      else
        CopLogicBase._exit(l_9_0.unit, "flee")
      end
    elseif new_objective.type == "surrender" then
      CopLogicBase._exit(l_9_0.unit, "surrender")
    else
      if l_9_0.unit:movement():cool() then
        CopLogicBase._exit(l_9_0.unit, "idle")
      else
        CopLogicBase._exit(l_9_0.unit, "flee")
      end
    end
  end
  if new_objective and new_objective.stance then
    if new_objective.stance == "ntl" then
      l_9_0.unit:movement():set_cool(true)
      l_9_0.unit:movement():set_stance("ntl")
    else
      l_9_0.unit:movement():set_cool(false)
      l_9_0.unit:movement():set_stance("hos")
    end
  end
  if l_9_1 and l_9_1.fail_clbk then
    l_9_1.fail_clbk(l_9_0.unit)
  end
end

CivilianLogicIdle.action_complete_clbk = function(l_10_0, l_10_1)
  local my_data = l_10_0.internal_data
  if l_10_1:type() == "turn" then
    my_data.turning = nil
  else
    if l_10_1:type() == "act" and my_data.acting and l_10_0.objective then
      my_data.acting = nil
      if l_10_1:expired() and not my_data.action_timeout_clbk_id then
        managers.groupai:state():on_civilian_objective_complete(l_10_0.unit, l_10_0.objective)
        do return end
        managers.groupai:state():on_civilian_objective_failed(l_10_0.unit, l_10_0.objective)
      end
    end
  end
end

CivilianLogicIdle._upd_detection = function(l_11_0)
  managers.groupai:state():on_unit_detection_updated(l_11_0.unit)
  l_11_0.t = TimerManager:game():time()
  local my_data = l_11_0.internal_data
  local delay = CopLogicBase._upd_attention_obj_detection(l_11_0, nil, nil)
  local new_attention, new_reaction = CivilianLogicIdle._get_priority_attention(l_11_0, l_11_0.detected_attention_objects)
  CivilianLogicIdle._set_attention_obj(l_11_0, new_attention, new_reaction)
  if new_reaction and AIAttentionObject.REACT_SCARED <= new_reaction then
    local objective = l_11_0.objective
    local allow_trans, obj_failed = CopLogicBase.is_obstructed(l_11_0, objective, nil, new_attention)
    if allow_trans then
      local alert = {"vo_cbt", new_attention.m_head_pos, nil, nil, new_attention.unit}
      CivilianLogicIdle.on_alert(l_11_0, alert)
      if my_data ~= l_11_0.internal_data then
        return 
      else
        CopLogicIdle._chk_focus_on_attention_object(l_11_0, my_data)
      end
    end
  end
  if not l_11_0.unit:movement():cool() and (not my_data.acting or not not l_11_0.unit:anim_data().act_idle) then
    local objective = l_11_0.objective
    if not objective or objective.interrupt_dis == -1 or objective.is_default then
      local alert = {"vo_cbt", l_11_0.m_pos, nil, nil, nil}
      CivilianLogicIdle.on_alert(l_11_0, alert)
      if my_data ~= l_11_0.internal_data then
        return 
      end
    end
  end
  CopLogicBase.queue_task(my_data, my_data.detection_task_key, CivilianLogicIdle._upd_detection, l_11_0, l_11_0.t + delay)
end

CivilianLogicIdle.is_available_for_assignment = function(l_12_0, l_12_1)
  if l_12_1 and l_12_1.forced then
    return true
  end
  local my_data = l_12_0.internal_data
  return (((not my_data.acting or l_12_0.unit:anim_data().act_idle) and not my_data.exiting and not my_data.delayed_alert_id))
end

CivilianLogicIdle.anim_clbk = function(l_13_0, l_13_1)
  if l_13_1 == "reset_attention" and l_13_0.internal_data.idle_attention then
    l_13_0.internal_data.idle_attention = nil
    CopLogicBase._reset_attention(l_13_0)
  end
end

CivilianLogicIdle.clbk_action_timeout = function(l_14_0, l_14_1)
  local my_data = l_14_1.internal_data
  CopLogicBase.on_delayed_clbk(my_data, my_data.action_timeout_clbk_id)
  my_data.action_timeout_clbk_id = nil
  local old_objective = l_14_1.objective
  if not old_objective then
    debug_pause_unit(l_14_1.unit, "[CivilianLogicIdle.clbk_action_timeout] missing objective")
    return 
  end
  if my_data.delayed_alert_id then
    managers.enemy:force_delayed_clbk(my_data.delayed_alert_id)
  end
  if l_14_1.objective == old_objective then
    managers.groupai:state():on_civilian_objective_complete(l_14_1.unit, old_objective)
  end
end

CivilianLogicIdle.clbk_enemy_weapons_hot = function(l_15_0, l_15_1)
  local my_data = l_15_1.internal_data
  if not my_data.enemy_weapons_hot_listen_id then
    debug_pause_unit(l_15_1.unit, "[CivilianLogicIdle.clbk_enemy_weapons_hot] no key!", l_15_1.unit, inspect(l_15_1), inspect(my_data))
    l_15_1.unit:brain():set_attention_settings()
    return 
  end
  managers.groupai:state():remove_listener(my_data.enemy_weapons_hot_listen_id)
  my_data.enemy_weapons_hot_listen_id = nil
  l_15_1.unit:brain():set_attention_settings()
end

CivilianLogicIdle.is_obstructed = function(l_16_0, l_16_1)
  if l_16_0.unit:movement():chk_action_forbidden("walk") then
    return 
  end
  local objective = l_16_0.objective
  if (not objective or objective.is_default or (not objective.in_place and objective.nav_seg) or objective.action or not objective.action_duration) then
    return true
  end
  if objective.interrupt_dis == -1 then
    return true
  end
  if l_16_1 and l_16_1:movement() and objective.interrupt_dis and mvector3.distance_sq(l_16_0.m_pos, l_16_1:movement():m_pos()) < objective.interrupt_dis * objective.interrupt_dis then
    return true
  end
  if objective.interrupt_health then
    local health_ratio = l_16_0.unit:character_damage():health_ratio()
    if health_ratio < 1 and health_ratio < objective.interrupt_health then
      return true
    end
  end
end

CivilianLogicIdle._get_priority_attention = function(l_17_0, l_17_1)
  local best_target, best_target_priority, best_target_reaction = nil, nil, nil
  for u_key,attention_data in pairs(l_17_1) do
    local att_unit = attention_data.unit
    if not attention_data.identified then
      for (for control),u_key in (for generator) do
      end
       -- DECOMPILER ERROR: unhandled construct in 'if'

      if attention_data.pause_expire_t and attention_data.pause_expire_t < l_17_0.t then
        if not attention_data.settings.attract_chance or math.random() < attention_data.settings.attract_chance then
          attention_data.pause_expire_t = nil
          for (for control),u_key in (for generator) do
          end
          attention_data.pause_expire_t = l_17_0.t + math.lerp(attention_data.settings.pause[1], attention_data.settings.pause[2], math.random())
          for (for control),u_key in (for generator) do
            if attention_data.stare_expire_t and attention_data.stare_expire_t < l_17_0.t and attention_data.settings.pause then
              attention_data.stare_expire_t = nil
              attention_data.pause_expire_t = l_17_0.t + math.lerp(attention_data.settings.pause[1], attention_data.settings.pause[2], math.random())
              for (for control),u_key in (for generator) do
                local distance = attention_data.dis
                local reaction = attention_data.settings.reaction
                local reaction_too_mild = nil
                if not reaction or best_target_reaction and reaction < best_target_reaction then
                  reaction_too_mild = true
                elseif distance < 150 and reaction == AIAttentionObject.REACT_IDLE then
                  reaction_too_mild = true
                end
                if not reaction_too_mild then
                  if l_17_0.current_attention and l_17_0.current_attention.u_key == u_key then
                    distance = distance * 0.80000001192093
                  end
                  local target_priority = distance
                  if not best_target_priority or target_priority < best_target_priority then
                    best_target = attention_data
                    best_target_reaction = reaction
                    best_target_priority = target_priority
                  end
                end
              end
            end
          end
          return best_target, best_target_reaction
           -- Warning: missing end command somewhere! Added here
        end
         -- Warning: missing end command somewhere! Added here
      end
       -- Warning: missing end command somewhere! Added here
    end
     -- Warning: missing end command somewhere! Added here
  end
end

CivilianLogicIdle._set_attention_obj = function(l_18_0, l_18_1, l_18_2)
  local old_att_obj = l_18_0.attention_obj
  l_18_0.attention_obj = l_18_1
  if l_18_1 then
    if not l_18_2 then
      l_18_2 = l_18_1.settings.reaction
    end
    l_18_1.reaction = l_18_2
    local is_same_obj = nil
    if old_att_obj and old_att_obj.u_key == l_18_1.u_key then
      is_same_obj = true
      if l_18_1.stare_expire_t and l_18_1.stare_expire_t < l_18_0.t and l_18_1.settings.pause then
        l_18_1.stare_expire_t = nil
        l_18_1.pause_expire_t = l_18_0.t + math.lerp(l_18_1.settings.pause[1], l_18_1.settings.pause[2], math.random())
        do return end
        if l_18_1.pause_expire_t and l_18_1.pause_expire_t < l_18_0.t then
          if not l_18_1.settings.attract_chance or math.random() < l_18_1.settings.attract_chance then
            l_18_1.pause_expire_t = nil
            l_18_1.stare_expire_t = l_18_0.t + math.lerp(l_18_1.settings.duration[1], l_18_1.settings.duration[2], math.random())
          else
            debug_pause_unit(l_18_0.unit, "[CivilianLogicIdle._set_attention_obj] skipping attraction")
            l_18_1.pause_expire_t = l_18_0.t + math.lerp(l_18_1.settings.pause[1], l_18_1.settings.pause[2], math.random())
          end
        end
      end
    end
    if not is_same_obj and l_18_1.settings.duration then
      l_18_1.stare_expire_t = l_18_0.t + math.lerp(l_18_1.settings.duration[1], l_18_1.settings.duration[2], math.random())
      l_18_1.pause_expire_t = nil
    end
  end
end


