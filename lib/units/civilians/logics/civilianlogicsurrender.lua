-- Decompiled using luadec 2.0.1 by sztupy (http://winmo.sztupy.hu)
-- Command line was: F:\SteamLibrary\SteamApps\common\PAYDAY 2\lua\lib\units\civilians\logics\civilianlogicsurrender.luac 

local tmp_vec1 = Vector3()
CivilianLogicSurrender = class(CopLogicBase)
CivilianLogicSurrender.wants_rescue = CivilianLogicFlee.wants_rescue
CivilianLogicSurrender.enter = function(l_1_0, l_1_1, l_1_2)
  CopLogicBase.enter(l_1_0, l_1_1, l_1_2)
  l_1_0.unit:brain():cancel_all_pathing_searches()
  local old_internal_data = l_1_0.internal_data
  local my_data = {unit = l_1_0.unit}
  l_1_0.internal_data = my_data
  my_data.rsrv_pos = {}
  if old_internal_data and not old_internal_data.rsrv_pos then
    my_data.rsrv_pos = my_data.rsrv_pos
  end
  if l_1_0.unit:anim_data().tied then
    managers.groupai:state():on_hostage_state(true, l_1_0.key)
    my_data.is_hostage = true
  end
  if l_1_0.unit:anim_data().drop and not l_1_0.unit:anim_data().tied then
    l_1_0.unit:interaction():set_active(true, true)
    my_data.interaction_active = true
  end
  my_data.state_enter_t = TimerManager:game():time()
  if not l_1_0.unit:anim_data().move and managers.groupai:state():rescue_state() and managers.groupai:state():is_nav_seg_safe(l_1_0.unit:movement():nav_tracker():nav_segment()) then
    CivilianLogicFlee._add_delayed_rescue_SO(l_1_0, my_data)
  end
  local scare_max = l_1_0.char_tweak.scare_max
  my_data.scare_max = math.lerp(scare_max[1], scare_max[2], math.random())
  local submission_max = l_1_0.char_tweak.submission_max
  my_data.submission_max = math.lerp(submission_max[1], submission_max[2], math.random())
  my_data.scare_meter = 0
  my_data.submission_meter = 0
  my_data.last_upd_t = l_1_0.t
  my_data.nr_random_screams = 0
  if not my_data.rsrv_pos.stand then
    local pos_rsrv = {position = mvector3.copy(l_1_0.m_pos), radius = 60, filter = l_1_0.pos_rsrv_id}
    my_data.rsrv_pos.stand = pos_rsrv
    managers.navigation:add_pos_reservation(pos_rsrv)
  end
  l_1_0.run_away_next_chk_t = nil
  l_1_0.unit:brain():set_update_enabled_state(false)
  l_1_0.unit:movement():set_allow_fire(false)
  managers.groupai:state():add_to_surrendered(l_1_0.unit, callback(CivilianLogicSurrender, CivilianLogicSurrender, "queued_update", l_1_0))
  my_data.surrender_clbk_registered = true
  l_1_0.unit:movement():set_stance("hos")
  l_1_0.unit:movement():set_cool(false)
  if my_data ~= l_1_0.internal_data then
    return 
  end
  local attention_settings = nil
  if not managers.groupai:state():enemy_weapons_hot() then
    attention_settings = {"civ_enemy_cbt", "civ_civ_cbt"}
    my_data.enemy_weapons_hot_listen_id = "CivilianLogicSurrender" .. tostring(l_1_0.key)
    managers.groupai:state():add_listener(my_data.enemy_weapons_hot_listen_id, {"enemy_weapons_hot"}, callback(CivilianLogicIdle, CivilianLogicIdle, "clbk_enemy_weapons_hot", l_1_0))
  end
  l_1_0.unit:brain():set_attention_settings(attention_settings)
  if not l_1_0.been_outlined and l_1_0.char_tweak.outline_on_discover then
    my_data.outline_detection_task_key = "CivilianLogicIdle._upd_outline_detection" .. tostring(l_1_0.key)
    CopLogicBase.queue_task(my_data, my_data.outline_detection_task_key, CivilianLogicIdle._upd_outline_detection, l_1_0, l_1_0.t + 2)
  end
  if l_1_0.objective and l_1_0.objective.aggressor_unit then
    if not l_1_0.objective.initial_act then
      CivilianLogicSurrender.on_intimidated(l_1_0, l_1_0.objective.amount, l_1_0.objective.aggressor_unit, true)
    else
      if l_1_0.objective.initial_act == "halt" then
        managers.groupai:state():register_fleeing_civilian(l_1_0.key, l_1_0.unit)
      end
      CivilianLogicSurrender._do_initial_act(l_1_0, l_1_0.objective.amount, l_1_0.objective.aggressor_unit, l_1_0.objective.initial_act)
    end
  end
end

CivilianLogicSurrender.exit = function(l_2_0, l_2_1, l_2_2)
  CopLogicBase.exit(l_2_0, l_2_1, l_2_2)
  local my_data = l_2_0.internal_data
  if l_2_0.unit:anim_data().tied and l_2_1 ~= "trade" and l_2_1 ~= "inactive" and (not l_2_0.objective or not l_2_0.objective.forced) then
    debug_pause_unit(l_2_0.unit, "[CivilianLogicSurrender.exit] tied civilian!!!", l_2_0.unit, "new_logic_name", l_2_1)
  end
  CivilianLogicFlee._unregister_rescue_SO(l_2_0, my_data)
  managers.groupai:state():unregister_fleeing_civilian(l_2_0.key)
  if l_2_1 ~= "inactive" then
    l_2_0.unit:base():set_slot(l_2_0.unit, 21)
  end
  CopLogicBase.cancel_delayed_clbks(my_data)
  if l_2_1 ~= "trade" and my_data.interaction_active then
    l_2_0.unit:interaction():set_active(false, true)
    my_data.interaction_active = nil
    if l_2_0.has_outline then
      l_2_0.unit:base():set_contour(true)
    end
  end
  if my_data.surrender_clbk_registered then
    managers.groupai:state():remove_from_surrendered(l_2_0.unit)
  end
  CopLogicBase.cancel_queued_tasks(my_data)
  if my_data.is_hostage then
    managers.groupai:state():on_hostage_state(false, l_2_0.key)
    my_data.is_hostage = nil
  end
  CopLogicBase._reset_attention(l_2_0)
  if my_data.enemy_weapons_hot_listen_id then
    managers.groupai:state():remove_listener(my_data.enemy_weapons_hot_listen_id)
  end
end

CivilianLogicSurrender.queued_update = function(l_3_0, l_3_1)
  local my_data = l_3_1.internal_data
  CivilianLogicSurrender._update_enemy_detection(l_3_1, my_data)
  if my_data.submission_meter == 0 and not l_3_1.unit:anim_data().tied and (not l_3_1.unit:anim_data().react_enter or not not l_3_1.unit:anim_data().idle) then
    if l_3_1.unit:anim_data().drop then
      local new_action = {type = "act", variant = "stand", body_part = 1}
      l_3_1.unit:brain():action_request(new_action)
    end
    my_data.surrender_clbk_registered = false
    l_3_1.unit:brain():set_objective({type = "free", is_default = true})
    return 
  else
    CivilianLogicFlee._chk_add_delayed_rescue_SO(l_3_1, my_data)
    managers.groupai:state():add_to_surrendered(l_3_1.unit, callback(CivilianLogicSurrender, CivilianLogicSurrender, "queued_update", l_3_1))
  end
  if l_3_1.unit:anim_data().act and my_data.rsrv_pos.stand then
    my_data.rsrv_pos.stand.position = mvector3.copy(l_3_1.m_pos)
    managers.navigation:move_pos_rsrv(my_data.rsrv_pos.stand)
  end
end

CivilianLogicSurrender.on_tied = function(l_4_0, l_4_1, l_4_2)
  local my_data = l_4_0.internal_data
  if my_data.is_hostage then
    return 
  end
  if l_4_2 then
    if l_4_0.has_outline then
      l_4_0.unit:base():set_contour(false)
      l_4_0.has_outline = nil
    end
    l_4_0.unit:inventory():destroy_all_items()
    if my_data.interaction_active then
      l_4_0.unit:interaction():set_active(false, true)
      my_data.interaction_active = nil
    end
    l_4_0.unit:character_damage():drop_pickup()
    l_4_0.unit:character_damage():set_pickup(nil)
  else
    local action_data = {type = "act", body_part = 1, variant = "tied", blocks = {light_hurt = -1, hurt = -1, heavy_hurt = -1, hurt_sick = -1, walk = -1}}
    local action_res = l_4_0.unit:brain():action_request(action_data)
    if action_res then
      managers.groupai:state():on_hostage_state(true, l_4_0.key)
      my_data.is_hostage = true
      if l_4_0.has_outline then
        l_4_0.unit:base():set_contour(false)
        l_4_0.has_outline = nil
      end
      l_4_0.unit:inventory():destroy_all_items()
      managers.groupai:state():on_civilian_tied(l_4_0.unit:key())
      l_4_0.unit:base():set_slot(l_4_0.unit, 22)
      if l_4_0.unit:movement() then
        l_4_0.unit:movement():remove_giveaway()
      end
      if my_data.interaction_active then
        l_4_0.unit:interaction():set_active(false, true)
        my_data.interaction_active = nil
      end
      l_4_0.unit:character_damage():drop_pickup()
      l_4_0.unit:character_damage():set_pickup(nil)
      CivilianLogicFlee._chk_add_delayed_rescue_SO(l_4_0, my_data)
      if l_4_1 == managers.player:player_unit() then
        managers.statistics:tied({name = l_4_0.unit:base()._tweak_table})
      else
        l_4_1:network():send_to_unit({"statistics_tied", l_4_0.unit:base()._tweak_table})
      end
    end
  end
end

CivilianLogicSurrender._do_initial_act = function(l_5_0, l_5_1, l_5_2, l_5_3)
  local my_data = l_5_0.internal_data
  local adj_sumbission = l_5_1 * l_5_0.char_tweak.submission_intimidate
  my_data.submission_meter = math.min(my_data.submission_max, my_data.submission_meter + adj_sumbission)
  local adj_scare = l_5_1 * l_5_0.char_tweak.scare_intimidate
  my_data.scare_meter = math.max(0, my_data.scare_meter + adj_scare)
  local action_data = {type = "act", body_part = 1, variant = l_5_3, clamp_to_graph = true}
  l_5_0.unit:brain():action_request(action_data)
end

CivilianLogicSurrender.action_complete_clbk = function(l_6_0, l_6_1)
  local my_data = l_6_0.internal_data
  local action_type = l_6_1:type()
  if action_type == "walk" then
    if l_6_1:expired() then
      my_data.rsrv_pos.stand = my_data.rsrv_pos.move_dest
      my_data.rsrv_pos.move_dest = nil
    else
      if my_data.rsrv_pos.move_dest then
        if not my_data.rsrv_pos.stand then
          my_data.rsrv_pos.stand = managers.navigation:add_pos_reservation({position = mvector3.copy(l_6_0.m_pos), radius = 45, filter = l_6_0.pos_rsrv_id})
        end
        managers.navigation:unreserve_pos(my_data.rsrv_pos.move_dest)
        my_data.rsrv_pos.move_dest = nil
      elseif action_type == "act" and my_data.interaction_active then
        l_6_0.unit:interaction():set_active(false, true)
        my_data.interaction_active = nil
      end
    end
  end
end

CivilianLogicSurrender.on_intimidated = function(l_7_0, l_7_1, l_7_2, l_7_3)
  if l_7_0.unit:anim_data().tied then
    return 
  end
  if not tweak_data.character[l_7_0.unit:base()._tweak_table].intimidateable or l_7_0.unit:base().unintimidateable or l_7_0.unit:anim_data().unintimidateable then
    return 
  end
  local my_data = l_7_0.internal_data
  if not my_data.delayed_intimidate_id or not my_data.delayed_clbks or not my_data.delayed_clbks[my_data.delayed_intimidate_id] then
    if l_7_3 then
      CivilianLogicSurrender._delayed_intimidate_clbk(nil, {l_7_0, l_7_1, l_7_2})
    else
      my_data.delayed_intimidate_id = "intimidate" .. tostring(l_7_0.unit:key())
      local delay = math.max(0, 1 - l_7_1) + math.random() * 0.20000000298023
      CopLogicBase.add_delayed_clbk(my_data, my_data.delayed_intimidate_id, callback(CivilianLogicSurrender, CivilianLogicSurrender, "_delayed_intimidate_clbk", {l_7_0, l_7_1, l_7_2}), TimerManager:game():time() + delay)
    end
  end
end

CivilianLogicSurrender._delayed_intimidate_clbk = function(l_8_0, l_8_1)
  local data = l_8_1[1]
  local my_data = data.internal_data
  if my_data.delayed_intimidate_id then
    CopLogicBase.on_delayed_clbk(my_data, my_data.delayed_intimidate_id)
    my_data.delayed_intimidate_id = nil
  end
  if data.unit:movement():chk_action_forbidden("walk") then
    return 
  end
  local amount = l_8_1[2]
  local anim_data = data.unit:anim_data()
  local adj_sumbission = amount * data.char_tweak.submission_intimidate
  my_data.submission_meter = math.min(my_data.submission_max, my_data.submission_meter + adj_sumbission)
  local adj_scare = amount * data.char_tweak.scare_intimidate
  my_data.scare_meter = math.max(0, my_data.scare_meter + adj_scare)
  if not anim_data.drop then
    if anim_data.react_enter and not anim_data.idle then
      do return end
    end
    if not anim_data.move or not "halt" then
      local action_data = {type = "act", body_part = 1, clamp_to_graph = true, variant = not anim_data.react and not anim_data.panic and not anim_data.halt or "drop"}
    end
    do
      local action_res = data.unit:brain():action_request(action_data)
      if action_res and action_data.variant == "drop" then
        managers.groupai:state():unregister_fleeing_civilian(data.key)
        data.unit:interaction():set_active(true, true)
        my_data.interaction_active = true
      end
      do return end
      local action_data = {type = "act", body_part = 1, variant = "panic", clamp_to_graph = true}
      data.unit:brain():action_request(action_data)
      data.unit:sound():say("a02x_any", true)
      if data.unit:unit_data().mission_element then
        data.unit:unit_data().mission_element:event("panic", data.unit)
      end
      if not managers.groupai:state():enemy_weapons_hot() then
        local alert = {"vo_distress", data.unit:movement():m_head_pos(), 200, data.SO_access, data.unit}
        managers.groupai:state():propagate_alert(alert)
      end
    end
  end
end

CivilianLogicSurrender.on_alert = function(l_9_0, l_9_1)
  local alert_type = l_9_1[1]
  if alert_type ~= "aggression" and alert_type ~= "bullet" then
    return 
  end
  local anim_data = l_9_0.unit:anim_data()
  if anim_data.tied then
    return 
  end
  if CopLogicBase.is_alert_aggressive(l_9_1[1]) then
    local aggressor = l_9_1[5]
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
        l_9_0.unit:brain():on_intimidated(1, aggressor)
        return 
      end
    end
  end
  l_9_0.t = TimerManager:game():time()
  if not CopLogicBase.is_alert_dangerous(l_9_1[1]) then
    return 
  end
  local my_data = l_9_0.internal_data
  local scare_modifier = l_9_0.char_tweak.scare_shot
  if anim_data.halt or anim_data.react then
    scare_modifier = scare_modifier * 4
  end
  my_data.scare_meter = math.min(my_data.scare_max, my_data.scare_meter + scare_modifier)
  if my_data.scare_meter == my_data.scare_max and l_9_0.t - my_data.state_enter_t > 5 then
    l_9_0.unit:sound():say("a01x_any", true)
    if not my_data.inside_intimidate_aura then
      l_9_0.unit:brain():set_objective({type = "free", is_default = true, alert_data = clone(l_9_1)})
    else
      if not l_9_0.unit:sound():speaking(TimerManager:game():time()) then
        local rand = math.random()
        local alert_dis_sq = mvector3.distance_sq(l_9_0.m_pos, l_9_1[2])
        local max_scare_dis_sq = 4000000
        if alert_dis_sq < max_scare_dis_sq then
          rand = math.lerp(rand, rand * 2, math.min(alert_dis_sq) / 4000000)
          local scare_mul = (max_scare_dis_sq - alert_dis_sq) / max_scare_dis_sq
          local max_nr_random_screams = 8
          scare_mul = scare_mul * math.lerp(1, 0.30000001192093, my_data.nr_random_screams / max_nr_random_screams)
          local chance_voice_1 = 0.30000001192093 * (scare_mul)
          local chance_voice_2 = 0.30000001192093 * (scare_mul)
          if l_9_0.char_tweak.female then
            chance_voice_1 = chance_voice_1 * 1.2000000476837
            chance_voice_2 = chance_voice_2 * 1.2000000476837
          end
          if rand < chance_voice_1 then
            l_9_0.unit:sound():say("a01x_any", true)
            my_data.nr_random_screams = math.min(my_data.nr_random_screams + 1, max_nr_random_screams)
          elseif rand < chance_voice_1 + chance_voice_2 then
            l_9_0.unit:sound():say("a02x_any", true)
            my_data.nr_random_screams = math.min(my_data.nr_random_screams + 1, max_nr_random_screams)
          end
        end
      end
    end
  end
end

CivilianLogicSurrender._update_enemy_detection = function(l_10_0, l_10_1)
  managers.groupai:state():on_unit_detection_updated(l_10_0.unit)
  local t = TimerManager:game():time()
  local delta_t = t - l_10_1.last_upd_t
  local my_pos = l_10_0.unit:movement():m_head_pos()
  local enemies = (managers.groupai:state():all_criminals())
  local visible, closest_dis, closest_enemy = nil, nil, nil
  l_10_1.inside_intimidate_aura = nil
  local my_tracker = l_10_0.unit:movement():nav_tracker()
  local chk_vis_func = my_tracker.check_visibility
  for e_key,u_data in pairs(enemies) do
    if not u_data.is_deployable and chk_vis_func(my_tracker, u_data.tracker) then
      local enemy_unit = u_data.unit
      local enemy_pos = u_data.m_det_pos
      local my_vec = tmp_vec1
      local dis = (mvector3.direction(my_vec, enemy_pos, my_pos))
      local inside_aura = nil
      if u_data.unit:base().is_local_player and managers.player:has_category_upgrade("player", "intimidate_aura") and dis < managers.player:upgrade_value("player", "intimidate_aura", 0) then
        inside_aura = true
        do return end
        if u_data.unit:base().is_husk_player and u_data.unit:base():upgrade_value("player", "intimidate_aura") and dis < u_data.unit:base():upgrade_value("player", "intimidate_aura") then
          inside_aura = true
        end
      end
      if (inside_aura or dis < 700) and (not closest_dis or dis < closest_dis) then
        closest_dis = dis
        closest_enemy = enemy_unit
      end
      if inside_aura then
        l_10_1.inside_intimidate_aura = true
        for (for control),e_key in (for generator) do
        end
        if dis < 700 then
          local look_dir = enemy_unit:movement():m_head_rot():y()
          if mvector3.dot(my_vec, look_dir) > 0.64999997615814 then
            visible = true
          end
        end
      end
    end
    local attention = l_10_0.unit:movement():attention()
    do
      local attention_unit = attention and attention.unit or nil
      if not attention_unit and closest_enemy and closest_dis < 700 and l_10_0.unit:anim_data().ik_type then
        CopLogicBase._set_attention_on_unit(l_10_0, closest_enemy)
        do return end
        if mvector3.distance(my_pos, attention_unit:movement():m_head_pos()) > 900 or not l_10_0.unit:anim_data().ik_type then
          CopLogicBase._reset_attention(l_10_0)
        end
      end
      if l_10_1.inside_intimidate_aura then
        l_10_1.submission_meter = l_10_1.submission_max
      elseif visible then
        l_10_1.submission_meter = math.min(l_10_1.submission_max, l_10_1.submission_meter + delta_t)
      else
        l_10_1.submission_meter = math.max(0, l_10_1.submission_meter - delta_t)
      end
      if managers.groupai:state():rescue_state() and managers.groupai:state():is_nav_seg_safe(l_10_0.unit:movement():nav_tracker():nav_segment()) and not l_10_1.rescue_active then
        CivilianLogicFlee._add_delayed_rescue_SO(l_10_0, l_10_1)
        do return end
        if l_10_1.rescue_active then
          CivilianLogicFlee._unregister_rescue_SO(l_10_0, l_10_1)
        end
      end
      l_10_1.scare_meter = math.max(0, l_10_1.scare_meter - delta_t)
      l_10_1.last_upd_t = t
    end
     -- Warning: missing end command somewhere! Added here
  end
end

CivilianLogicSurrender.is_available_for_assignment = function(l_11_0, l_11_1)
  if l_11_1 and l_11_1.forced then
    return true
  end
  return (not l_11_0.unit:anim_data().tied and (l_11_1 and l_11_1.type == "revive") or (l_11_0.t - l_11_0.internal_data.state_enter_t > 5 and l_11_0.internal_data.submission_meter / l_11_0.internal_data.submission_max < 0.94999998807907))
end

CivilianLogicSurrender.on_new_objective = function(l_12_0, l_12_1)
  CivilianLogicIdle.on_new_objective(l_12_0, l_12_1)
end

CivilianLogicSurrender.on_rescue_allowed_state = function(l_13_0, l_13_1)
  CivilianLogicFlee.on_rescue_allowed_state(l_13_0, l_13_1)
end


