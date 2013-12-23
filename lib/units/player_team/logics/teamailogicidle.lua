-- Decompiled using luadec 2.0.1 by sztupy (http://winmo.sztupy.hu)
-- Command line was: F:\SteamLibrary\SteamApps\common\PAYDAY 2\lua\lib\units\player_team\logics\teamailogicidle.luac 

require("lib/units/enemies/cop/logics/CopLogicIdle")
require("lib/units/enemies/cop/logics/CopLogicTravel")
local tmp_vec1 = Vector3()
local tmp_vec2 = Vector3()
local tmp_vec3 = Vector3()
if not TeamAILogicIdle then
  TeamAILogicIdle = class(TeamAILogicBase)
end
TeamAILogicIdle.enter = function(l_1_0, l_1_1, l_1_2)
  TeamAILogicBase.enter(l_1_0, l_1_1, l_1_2)
  local my_data = {unit = l_1_0.unit}
  my_data.detection = l_1_0.char_tweak.detection.idle
  my_data.enemy_detect_slotmask = managers.slot:get_mask("enemies")
  my_data.rsrv_pos = {}
  local old_internal_data = l_1_0.internal_data
  if old_internal_data then
    if not old_internal_data.rsrv_pos then
      my_data.rsrv_pos = my_data.rsrv_pos
    end
    if old_internal_data.best_cover then
      my_data.best_cover = old_internal_data.best_cover
      managers.navigation:reserve_cover(my_data.best_cover[1], l_1_0.pos_rsrv_id)
    end
    if old_internal_data.nearest_cover then
      my_data.nearest_cover = old_internal_data.nearest_cover
      managers.navigation:reserve_cover(my_data.nearest_cover[1], l_1_0.pos_rsrv_id)
    end
  end
  l_1_0.internal_data = my_data
  local key_str = tostring(l_1_0.key)
  my_data.detection_task_key = "TeamAILogicIdle._upd_enemy_detection" .. key_str
  CopLogicBase.queue_task(my_data, my_data.detection_task_key, TeamAILogicIdle._upd_enemy_detection, l_1_0, l_1_0.t)
  if my_data.nearest_cover or my_data.best_cover then
    my_data.cover_update_task_key = "CopLogicIdle._update_cover" .. key_str
    CopLogicBase.add_delayed_clbk(my_data, my_data.cover_update_task_key, callback(CopLogicTravel, CopLogicTravel, "_update_cover", l_1_0), l_1_0.t + 1)
  end
  my_data.stare_path_search_id = "stare" .. key_str
  my_data.relocate_chk_t = 0
  CopLogicBase._reset_attention(l_1_0)
  if l_1_0.unit:movement():stance_name() == "cbt" then
    l_1_0.unit:movement():set_stance("hos")
  end
  l_1_0.unit:movement():set_allow_fire(false)
  local objective = l_1_0.objective
  if l_1_2 then
    local entry_action = l_1_2.action
  end
  if objective then
    if objective.type == "revive" then
      if objective.action_start_clbk then
        objective.action_start_clbk(l_1_0.unit)
      end
      local success = nil
      local revive_unit = objective.follow_unit
      if revive_unit:interaction() and revive_unit:interaction():active() and l_1_0.unit:brain():action_request(objective.action) then
        revive_unit:interaction():interact_start(l_1_0.unit)
        success = true
        do return end
        if revive_unit:character_damage():arrested() and l_1_0.unit:brain():action_request(objective.action) then
          revive_unit:character_damage():pause_arrested_timer()
          success = true
          do return end
          if revive_unit:character_damage():need_revive() and l_1_0.unit:brain():action_request(objective.action) then
            revive_unit:character_damage():pause_downed_timer()
            success = true
          end
        end
      end
      if success then
        my_data.performing_act_objective = objective
        my_data.reviving = revive_unit
        my_data.acting = true
        my_data.revive_complete_clbk_id = "TeamAILogicIdle_revive" .. tostring(l_1_0.key)
        local revive_t = TimerManager:game():time() + (objective.action_duration or 0)
        CopLogicBase.add_delayed_clbk(my_data, my_data.revive_complete_clbk_id, callback(TeamAILogicIdle, TeamAILogicIdle, "clbk_revive_complete", l_1_0), revive_t)
        if not revive_unit:character_damage():arrested() then
          local suffix = "a"
          local downed_time = revive_unit:character_damage():down_time()
          if downed_time <= tweak_data.player.damage.DOWNED_TIME_MIN then
            suffix = "c"
          else
            if downed_time <= tweak_data.player.damage.DOWNED_TIME / 2 + tweak_data.player.damage.DOWNED_TIME_DEC then
              suffix = "b"
            end
          end
          l_1_0.unit:sound():say("s09" .. suffix, true)
        else
          l_1_0.unit:brain():set_objective()
          return 
        end
      elseif objective.action_duration then
        my_data.action_timeout_clbk_id = "TeamAILogicIdle_action_timeout" .. key_str
        local action_timeout_t = l_1_0.t + objective.action_duration
        CopLogicBase.add_delayed_clbk(my_data, my_data.action_timeout_clbk_id, callback(CopLogicIdle, CopLogicIdle, "clbk_action_timeout", l_1_0), action_timeout_t)
      end
      if objective.type == "act" then
        if l_1_0.unit:brain():action_request(objective.action) then
          my_data.acting = true
        end
        my_data.performing_act_objective = objective
        if objective.action_start_clbk then
          objective.action_start_clbk(l_1_0.unit)
        end
      end
    end
  end
  if objective.scan then
    my_data.scan = true
    if not my_data.acting then
      my_data.wall_stare_task_key = "CopLogicIdle._chk_stare_into_wall" .. tostring(l_1_0.key)
      CopLogicBase.queue_task(my_data, my_data.wall_stare_task_key, CopLogicIdle._chk_stare_into_wall_1, l_1_0, l_1_0.t)
    end
  end
end
end

TeamAILogicIdle.exit = function(l_2_0, l_2_1, l_2_2)
  TeamAILogicBase.exit(l_2_0, l_2_1, l_2_2)
  local my_data = l_2_0.internal_data
  if my_data.delayed_clbks and my_data.delayed_clbks[my_data.revive_complete_clbk_id] then
    local revive_unit = my_data.reviving
    if alive(revive_unit) then
      if revive_unit:interaction() then
        revive_unit:interaction():interact_interupt(l_2_0.unit)
      else
        if revive_unit:character_damage():arrested() then
          revive_unit:character_damage():unpause_arrested_timer()
        else
          if revive_unit:character_damage():need_revive() then
            revive_unit:character_damage():unpause_downed_timer()
          end
        end
      end
    end
    my_data.performing_act_objective = nil
    local crouch_action = {type = "act", body_part = 1, variant = "crouch", blocks = {action = -1, walk = -1, hurt = -1, heavy_hurt = -1, aim = -1}}
    l_2_0.unit:movement():action_request(crouch_action)
  end
  l_2_0.unit:brain():cancel_all_pathing_searches()
  CopLogicBase.cancel_queued_tasks(my_data)
  CopLogicBase.cancel_delayed_clbks(my_data)
  if my_data.best_cover then
    managers.navigation:release_cover(my_data.best_cover[1])
  end
  if my_data.nearest_cover then
    managers.navigation:release_cover(my_data.nearest_cover[1])
  end
  local rsrv_pos = my_data.rsrv_pos
  if rsrv_pos.path then
    managers.navigation:unreserve_pos(rsrv_pos.path)
    rsrv_pos.path = nil
  end
  if rsrv_pos.move_dest then
    managers.navigation:unreserve_pos(rsrv_pos.move_dest)
    rsrv_pos.move_dest = nil
  end
end

TeamAILogicIdle.update = function(l_3_0)
  local my_data = l_3_0.internal_data
  CopLogicIdle._upd_pathing(l_3_0, my_data)
  CopLogicIdle._upd_scan(l_3_0, my_data)
  local objective = l_3_0.objective
   -- DECOMPILER ERROR: unhandled construct in 'if'

  if objective and not my_data.acting and objective.type == "follow" and TeamAILogicIdle._check_should_relocate(l_3_0, my_data, objective) and not l_3_0.unit:movement():chk_action_forbidden("walk") then
    objective.in_place = nil
    TeamAILogicBase._exit(l_3_0.unit, "travel")
    do return end
    if objective.type == "revive" then
      objective.in_place = nil
      TeamAILogicBase._exit(l_3_0.unit, "travel")
      do return end
      if not l_3_0.path_fail_t or l_3_0.t - l_3_0.path_fail_t > 6 then
        managers.groupai:state():on_criminal_jobless(l_3_0.unit)
      end
    end
  end
end

TeamAILogicIdle.on_detected_enemy_destroyed = function(l_4_0, l_4_1)
end

TeamAILogicIdle.on_cop_neutralized = function(l_5_0, l_5_1)
end

TeamAILogicIdle.damage_clbk = function(l_6_0, l_6_1)
  local attacker_unit = l_6_1.attacker_unit
  if attacker_unit and attacker_unit:in_slot(l_6_0.enemy_slotmask) then
    local my_data = l_6_0.internal_data
    local attacker_key = attacker_unit:key()
    local enemy_data = l_6_0.detected_attention_objects[attacker_key]
    local t = TimerManager:game():time()
    if enemy_data then
      enemy_data.verified_t = t
      enemy_data.verified = true
      mvector3.set(enemy_data.verified_pos, attacker_unit:movement():m_stand_pos())
      enemy_data.verified_dis = mvector3.distance(enemy_data.verified_pos, l_6_0.unit:movement():m_stand_pos())
      enemy_data.dmg_t = t
      enemy_data.alert_t = t
      enemy_data.notice_delay = nil
      if not enemy_data.identified then
        enemy_data.identified = true
        enemy_data.identified_t = t
        enemy_data.notice_progress = nil
        enemy_data.prev_notice_chk_t = nil
        if enemy_data.settings.notice_clbk then
          enemy_data.settings.notice_clbk(l_6_0.unit, true)
        else
          local attention_info = managers.groupai:state():get_AI_attention_objects_by_filter(l_6_0.SO_access_str)[attacker_key]
          if attention_info then
            local settings = attention_info.handler:get_attention(l_6_0.SO_access, nil, nil)
            if settings then
              enemy_data = CopLogicBase._create_detected_attention_object_data(l_6_0, my_data, attacker_key, attention_info, settings)
              enemy_data.verified_t = t
              enemy_data.verified = true
              enemy_data.dmg_t = t
              enemy_data.alert_t = t
              enemy_data.notice_progress = nil
              enemy_data.prev_notice_chk_t = nil
              enemy_data.identified = true
              enemy_data.identified_t = t
              if enemy_data.settings.notice_clbk then
                enemy_data.settings.notice_clbk(l_6_0.unit, true)
              end
              l_6_0.detected_attention_objects[attacker_key] = enemy_data
            end
          end
        end
      end
    end
  end
  if (l_6_1.result.type == "bleedout" or l_6_1.variant == "tase") and l_6_0.name ~= "disabled" then
    CopLogicBase._exit(l_6_0.unit, "disabled")
  end
end

TeamAILogicIdle.on_objective_unit_damaged = function(l_7_0, l_7_1, l_7_2)
  if l_7_2 ~= nil then
    TeamAILogicIdle.on_alert(l_7_0, {"aggression", (l_7_2:movement():m_pos()), nil, nil, l_7_2})
  end
end

TeamAILogicIdle.on_alert = function(l_8_0, l_8_1)
  local alert_type = l_8_1[1]
  local alert_unit = l_8_1[5]
  if alert_unit:in_slot(l_8_0.enemy_slotmask) then
    local att_obj_data, is_new = CopLogicBase.identify_attention_obj_instant(l_8_0, alert_unit:key())
    if att_obj_data and (alert_type == "bullet" or alert_type == "aggression") then
      att_obj_data.alert_t = TimerManager:game():time()
    end
  end
end

TeamAILogicIdle.on_long_dis_interacted = function(l_9_0, l_9_1)
  local objective_type, objective_action, interrupt = nil, nil, nil
  if l_9_1:base().is_local_player then
    if l_9_1:character_damage():need_revive() then
      objective_type = "revive"
      objective_action = "revive"
    else
      if l_9_1:character_damage():arrested() then
        objective_type = "revive"
        objective_action = "untie"
      else
        objective_type = "follow"
      end
    else
      if l_9_1:movement():need_revive() then
        objective_type = "revive"
        if l_9_1:movement():current_state_name() == "arrested" then
          objective_action = "untie"
        else
          objective_action = "revive"
        end
      else
        objective_type = "follow"
      end
    end
  end
  local objective = nil
  if objective_type == "follow" then
    objective = {type = objective_type, follow_unit = l_9_1, called = true, destroy_clbk_key = false, scan = true}
    l_9_0.unit:sound():say("r01x_sin", true)
  else
    local followup_objective = {type = "act", scan = true, action = {type = "act", body_part = 1, variant = "crouch", blocks = {action = -1, walk = -1, hurt = -1, heavy_hurt = -1, aim = -1}}}
    {type = "revive", follow_unit = l_9_1}.called = true
     -- DECOMPILER ERROR: Confused about usage of registers!

    {type = "revive", follow_unit = l_9_1}.destroy_clbk_key = false
     -- DECOMPILER ERROR: Confused about usage of registers!

    {type = "revive", follow_unit = l_9_1}.nav_seg = l_9_1:movement():nav_tracker():nav_segment()
     -- DECOMPILER ERROR: Confused about usage of registers!

    {type = "revive", follow_unit = l_9_1}.scan = true
     -- DECOMPILER ERROR: Confused about usage of registers!

    {type = "revive", follow_unit = l_9_1}.action = {type = "act", variant = objective_action, body_part = 1, blocks = {action = -1, walk = -1, hurt = -1, light_hurt = -1, heavy_hurt = -1, aim = -1}, align_sync = true}
     -- DECOMPILER ERROR: Confused about usage of registers!

    {type = "revive", follow_unit = l_9_1}.action_duration = tweak_data.interaction[objective_action == "untie" and "free" or objective_action].timer
     -- DECOMPILER ERROR: Confused about usage of registers!

    {type = "revive", follow_unit = l_9_1}.followup_objective = followup_objective
     -- DECOMPILER ERROR: Confused about usage of registers!

    objective = {type = "revive", follow_unit = l_9_1}
    l_9_0.unit:sound():say("r02a_sin", true)
  end
  l_9_0.unit:brain():set_objective(objective)
end

TeamAILogicIdle.on_new_objective = function(l_10_0, l_10_1)
  local new_objective = l_10_0.objective
  TeamAILogicBase.on_new_objective(l_10_0, l_10_1)
  local my_data = l_10_0.internal_data
  if not my_data.exiting then
    if new_objective then
      if (new_objective.nav_seg or new_objective.follow_unit) and not new_objective.in_place then
        CopLogicBase._exit(l_10_0.unit, "travel")
      else
        CopLogicBase._exit(l_10_0.unit, "idle")
      end
    else
      CopLogicBase._exit(l_10_0.unit, "idle")
    end
  else
    if not l_10_1 or new_objective then
      debug_pause("[TeamAILogicIdle.on_new_objective] Already exiting", l_10_0.name, l_10_0.unit, inspect(l_10_1), inspect(new_objective))
    end
  end
  if new_objective and new_objective.stance then
    if new_objective.stance == "ntl" then
      l_10_0.unit:movement():set_cool(true)
    else
      l_10_0.unit:movement():set_cool(false)
    end
  end
  if l_10_1 and l_10_1.fail_clbk then
    l_10_1.fail_clbk(l_10_0.unit)
  end
end

TeamAILogicIdle._upd_enemy_detection = function(l_11_0)
  managers.groupai:state():on_unit_detection_updated(l_11_0.unit)
  l_11_0.t = TimerManager:game():time()
  local my_data = l_11_0.internal_data
  local max_reaction = nil
  if l_11_0.cool then
    max_reaction = AIAttentionObject.REACT_SURPRISED
  end
  local delay = CopLogicBase._upd_attention_obj_detection(l_11_0, nil, max_reaction)
  local new_attention, new_prio_slot, new_reaction = TeamAILogicIdle._get_priority_attention(l_11_0, l_11_0.detected_attention_objects, nil)
  if (not my_data._intimidate_t or my_data._intimidate_t + 2 < l_11_0.t) and not l_11_0.cool and not my_data._turning_to_intimidate and not my_data.acting and (not new_attention or AIAttentionObject.REACT_SCARED > new_reaction) then
    local can_turn = not l_11_0.unit:movement():chk_action_forbidden("walk")
    local civ = TeamAILogicIdle.find_civilian_to_intimidate(l_11_0.unit, can_turn and 180 or 90, 1200)
    if civ then
      my_data._intimidate_t = l_11_0.t
      new_reaction, new_prio_slot, new_attention = nil
      if can_turn and CopLogicAttack._chk_request_action_turn_to_enemy(l_11_0, my_data, l_11_0.m_pos, civ:movement():m_pos()) then
        my_data._turning_to_intimidate = true
        my_data._primary_intimidation_target = civ
      else
        TeamAILogicIdle.intimidate_civilians(l_11_0, l_11_0.unit, true, true)
      end
    end
  end
  TeamAILogicBase._set_attention_obj(l_11_0, new_attention, new_reaction)
  if new_reaction and AIAttentionObject.REACT_SCARED <= new_reaction then
    local objective = l_11_0.objective
    local wanted_state = nil
    local allow_trans, obj_failed = CopLogicBase.is_obstructed(l_11_0, objective, nil, new_attention)
    if allow_trans then
      wanted_state = TeamAILogicBase._get_logic_state_from_reaction(l_11_0, new_reaction)
      local objective = l_11_0.objective
      if objective and objective.type == "revive" then
        local revive_unit = objective.follow_unit
        local timer = nil
        if revive_unit:base().is_local_player then
          timer = revive_unit:character_damage()._downed_timer
        else
          if revive_unit:interaction().get_waypoint_time then
            timer = revive_unit:interaction():get_waypoint_time()
          end
        end
        if timer and timer <= 10 then
          wanted_state = nil
        end
      end
    end
    if wanted_state and wanted_state ~= l_11_0.name then
      if obj_failed then
        managers.groupai:state():on_criminal_objective_failed(l_11_0.unit, l_11_0.objective)
      end
      if my_data == l_11_0.internal_data then
        CopLogicBase._exit(l_11_0.unit, wanted_state)
      end
      return 
    end
  end
  CopLogicBase.queue_task(my_data, my_data.detection_task_key, TeamAILogicIdle._upd_enemy_detection, l_11_0, l_11_0.t + delay)
end

TeamAILogicIdle.find_civilian_to_intimidate = function(l_12_0, l_12_1, l_12_2)
  local best_civ = TeamAILogicIdle._find_intimidateable_civilians(l_12_0, false, l_12_1, l_12_2)
  return best_civ
end

TeamAILogicIdle._find_intimidateable_civilians = function(l_13_0, l_13_1, l_13_2, l_13_3)
  local head_pos = l_13_0:movement():m_head_pos()
  local look_vec = l_13_0:movement():m_rot():y()
  local close_dis = 400
  local intimidateable_civilians = {}
  local best_civ = nil
  local best_civ_wgt = false
  local best_civ_angle = nil
  local highest_wgt = 1
  local my_tracker = l_13_0:movement():nav_tracker()
  local chk_vis_func = my_tracker.check_visibility
  for key,unit in pairs(managers.groupai:state():fleeing_civilians()) do
    if chk_vis_func(my_tracker, unit:movement():nav_tracker()) and tweak_data.character[unit:base()._tweak_table].intimidateable and not unit:base().unintimidateable and not unit:anim_data().unintimidateable then
      local u_head_pos = unit:movement():m_head_pos() + math.UP * 30
      local vec = u_head_pos - head_pos
      local dis = mvector3.normalize(vec)
      local angle = vec:angle(look_vec)
      if l_13_1 then
        l_13_2 = math.max(8, math.lerp(90, 30, dis / 1200))
        l_13_3 = 1200
      end
      if dis < close_dis or dis < l_13_3 and angle < l_13_2 then
        local slotmask = managers.slot:get_mask("AI_visibility")
        local ray = World:raycast("ray", head_pos, u_head_pos, "slot_mask", slotmask, "ray_type", "ai_vision")
        if not ray then
          local inv_wgt = dis * dis * (1 - vec:dot(look_vec))
          table.insert(intimidateable_civilians, {unit = unit, key = key, inv_wgt = inv_wgt})
          if not best_civ_wgt or inv_wgt < best_civ_wgt then
            best_civ_wgt = inv_wgt
            best_civ = unit
            best_civ_angle = angle
          end
          if highest_wgt < inv_wgt then
            highest_wgt = inv_wgt
          end
        end
      end
    end
  end
  return best_civ, highest_wgt, intimidateable_civilians
end

TeamAILogicIdle.intimidate_civilians = function(l_14_0, l_14_1, l_14_2, l_14_3, l_14_4)
  local best_civ, highest_wgt, intimidateable_civilians = TeamAILogicIdle._find_intimidateable_civilians(l_14_1, true)
  local plural = false
  if #intimidateable_civilians > 1 then
    plural = true
  elseif #intimidateable_civilians <= 0 then
    return false
  end
  local act_name, sound_name = nil, nil
  local sound_suffix = plural and "plu" or "sin"
  if best_civ:anim_data().move then
    act_name = "gesture_stop"
    sound_name = "f02x_" .. sound_suffix
  else
    act_name = "arrest"
    sound_name = "f02x_" .. sound_suffix
  end
  if l_14_2 then
    l_14_1:sound():say(sound_name, true)
  end
  if l_14_3 and not l_14_1:movement():chk_action_forbidden("action") then
    local new_action = {type = "act", variant = act_name, body_part = 3, align_sync = true}
    if l_14_1:brain():action_request(new_action) then
      l_14_0.internal_data.gesture_arrest = true
    end
  end
  local intimidated_primary_target = false
  for _,civ in ipairs(intimidateable_civilians) do
    local amount = civ.inv_wgt / highest_wgt
    if best_civ == civ.unit then
      amount = 1
    end
    if l_14_4 == civ.unit then
      intimidated_primary_target = true
      amount = 1
    end
    civ.unit:brain():on_intimidated(amount, l_14_1)
  end
  if not intimidated_primary_target and l_14_4 then
    l_14_4:brain():on_intimidated(1, l_14_1)
  end
  if not managers.groupai:state():enemy_weapons_hot() then
    local alert = {"vo_intimidate", l_14_0.m_pos, 800, l_14_0.SO_access, l_14_0.unit}
    managers.groupai:state():propagate_alert(alert)
  end
  return l_14_4 or best_civ
end

TeamAILogicIdle.action_complete_clbk = function(l_15_0, l_15_1)
  local my_data = l_15_0.internal_data
  local action_type = l_15_1:type()
  if action_type == "turn" then
    l_15_0.internal_data.turning = nil
    if my_data._turning_to_intimidate then
      my_data._turning_to_intimidate = nil
      TeamAILogicIdle.intimidate_civilians(l_15_0, l_15_0.unit, true, true, my_data._primary_intimidation_target)
      my_data._primary_intimidation_target = nil
    elseif action_type == "act" then
      my_data.acting = nil
      if my_data.scan and not my_data.exiting and (not my_data.queued_tasks or not my_data.queued_tasks[my_data.wall_stare_task_key]) and not my_data.stare_path_pos then
        my_data.wall_stare_task_key = "CopLogicIdle._chk_stare_into_wall" .. tostring(l_15_0.key)
        CopLogicBase.queue_task(my_data, my_data.wall_stare_task_key, CopLogicIdle._chk_stare_into_wall_1, l_15_0, l_15_0.t)
      end
      if my_data.performing_act_objective then
        local old_objective = my_data.performing_act_objective
        my_data.performing_act_objective = nil
        if l_15_1:expired() and not my_data.action_timeout_clbk_id then
          managers.groupai:state():on_objective_complete(l_15_0.unit, old_objective)
          do return end
          managers.groupai:state():on_objective_failed(l_15_0.unit, old_objective)
        end
        if my_data.delayed_clbks and my_data.delayed_clbks[my_data.revive_complete_clbk_id] then
          CopLogicBase.cancel_delayed_clbk(my_data, my_data.revive_complete_clbk_id)
          my_data.revive_complete_clbk_id = nil
          local revive_unit = my_data.reviving
          if revive_unit:interaction() and revive_unit:interaction():active() then
            revive_unit:interaction():interact_interupt(l_15_0.unit)
            do return end
            if revive_unit:character_damage():arrested() then
              revive_unit:character_damage():unpause_arrested_timer()
            else
              if revive_unit:character_damage():need_revive() then
                revive_unit:character_damage():unpause_downed_timer()
              end
            end
          end
          my_data.reviving = nil
          managers.groupai:state():on_criminal_objective_failed(l_15_0.unit, old_objective)
        else
          if l_15_1:expired() and not my_data.action_timeout_clbk_id then
            managers.groupai:state():on_criminal_objective_complete(l_15_0.unit, old_objective)
            do return end
            managers.groupai:state():on_criminal_objective_failed(l_15_0.unit, old_objective)
          end
        end
      end
    end
  end
end

TeamAILogicIdle.is_available_for_assignment = function(l_16_0, l_16_1)
  if l_16_0.internal_data.exiting then
    return 
  elseif l_16_0.path_fail_t and l_16_0.t < l_16_0.path_fail_t + 6 then
    return 
  elseif l_16_0.objective then
    if l_16_0.internal_data.performing_act_objective and not l_16_0.unit:anim_data().act_idle then
      return 
    end
    if l_16_1 and CopLogicBase.is_obstructed(l_16_0, l_16_1, 0.20000000298023) then
      return 
    end
    do
      local old_objective_type = l_16_0.objective.type
  end
   -- DECOMPILER ERROR: Confused while interpreting a jump as a 'while'

end
end
return true
end

TeamAILogicIdle.clbk_heat = function(l_17_0)
  local inventory = l_17_0.unit:inventory()
  if inventory:is_selection_available(2) and inventory:equipped_selection() ~= 2 then
    inventory:equip_selection(2)
  end
end

TeamAILogicIdle.clbk_revive_complete = function(l_18_0, l_18_1)
  local my_data = l_18_1.internal_data
  CopLogicBase.on_delayed_clbk(my_data, my_data.revive_complete_clbk_id)
  my_data.revive_complete_clbk_id = nil
  local revive_unit = my_data.reviving
  my_data.reviving = nil
  if alive(revive_unit) then
    managers.groupai:state():on_criminal_objective_complete(l_18_1.unit, my_data.performing_act_objective)
    if revive_unit:interaction() and revive_unit:interaction():active() then
      revive_unit:interaction():interact(l_18_1.unit)
      do return end
      if not revive_unit:character_damage():need_revive() or not 2 then
        local hint = not revive_unit:character_damage() or (not revive_unit:character_damage():need_revive() and not revive_unit:character_damage():arrested()) or 3
      end
      managers.network:session():send_to_peers_synched("sync_teammate_helped_hint", hint, revive_unit, l_18_1.unit)
      revive_unit:character_damage():revive(l_18_1.unit)
    else
      print("[TeamAILogicIdle.clbk_revive_complete] Revive unit dead.", revive_unit, l_18_1.unit)
      managers.groupai:state():on_criminal_objective_failed(l_18_1.unit, my_data.performing_act_objective)
    end
  end
end

TeamAILogicIdle.clbk_action_timeout = function(l_19_0, l_19_1)
  local my_data = l_19_1.internal_data
  CopLogicBase.on_delayed_clbk(my_data, my_data.action_timeout_clbk_id)
  my_data.action_timeout_clbk_id = nil
  local old_objective = l_19_1.objective
  if my_data.performing_act_objective then
    my_data.performing_act_objective = nil
    my_data.acting = nil
  end
  if not old_objective then
    debug_pause_unit(l_19_1.unit, "[TeamAILogicIdle.clbk_action_timeout] missing objective")
    return 
  end
  managers.groupai:state():on_criminal_objective_complete(l_19_1.unit, old_objective)
end

TeamAILogicIdle._check_should_relocate = function(l_20_0, l_20_1, l_20_2)
  local follow_unit = l_20_2.follow_unit
  local my_nav_seg_id = l_20_0.unit:movement():nav_tracker():nav_segment()
  local my_areas = managers.groupai:state():get_areas_from_nav_seg_id(my_nav_seg_id)
  local follow_unit_nav_seg_id = follow_unit:movement():nav_tracker():nav_segment()
  for _,area in ipairs(my_areas) do
    if area.nav_segs[follow_unit_nav_seg_id] then
      return 
    end
  end
  local is_my_area_dangerous, is_follow_unit_area_dangerous = nil, nil
  for _,area in ipairs(my_areas) do
    if area.nav_segs[follow_unit_nav_seg_id] then
      is_my_area_dangerous = true
  else
    end
  end
  local follow_unit_areas = managers.groupai:state():get_areas_from_nav_seg_id(follow_unit_nav_seg_id)
  for _,area in ipairs(follow_unit_areas) do
    if next(area.police.units) then
      is_follow_unit_area_dangerous = true
  else
    end
  end
  if is_my_area_dangerous and not is_follow_unit_area_dangerous then
    return true
  end
  local max_allowed_dis_xy = 500
  local max_allowed_dis_z = 250
  mvector3.set(tmp_vec1, follow_unit:movement():m_pos())
  mvector3.subtract(tmp_vec1, l_20_0.m_pos)
  local too_far = nil
  if max_allowed_dis_z < math.abs(mvector3.z(tmp_vec1)) then
    too_far = true
  else
    mvector3.set_z(tmp_vec1, 0)
    if max_allowed_dis_xy < mvector3.length(tmp_vec1) then
      too_far = true
    end
  end
  if too_far then
    return true
  end
end

TeamAILogicIdle._get_priority_attention = function(l_21_0, l_21_1, l_21_2)
  if not l_21_2 then
    l_21_2 = TeamAILogicBase._chk_reaction_to_attention_object
  end
  do
    local best_target, best_target_priority_slot, best_target_priority, best_target_reaction = nil, nil, nil, nil
    for u_key,attention_data in pairs(l_21_1) do
      local att_unit = attention_data.unit
      local crim_record = attention_data.criminal_record
      if not attention_data.identified then
        for (for control),u_key in (for generator) do
        end
         -- DECOMPILER ERROR: unhandled construct in 'if'

        if attention_data.pause_expire_t and attention_data.pause_expire_t < l_21_0.t then
          attention_data.pause_expire_t = nil
          for (for control),u_key in (for generator) do
            if attention_data.stare_expire_t and attention_data.stare_expire_t < l_21_0.t and attention_data.settings.pause then
              attention_data.stare_expire_t = nil
              attention_data.pause_expire_t = l_21_0.t + math.lerp(attention_data.settings.pause[1], attention_data.settings.pause[2], math.random())
              for (for control),u_key in (for generator) do
                local distance = mvector3.distance(l_21_0.m_pos, attention_data.m_pos)
                local reaction = l_21_2(l_21_0, attention_data, not CopLogicAttack._can_move(l_21_0))
                local aimed_at = TeamAILogicIdle.chk_am_i_aimed_at(l_21_0, attention_data, attention_data.aimed_at and 0.94999998807907 or 0.98500001430511)
                attention_data.aimed_at = aimed_at
                local reaction_too_mild = nil
                if not reaction or best_target_reaction and reaction < best_target_reaction then
                  reaction_too_mild = true
                elseif distance < 150 and reaction <= AIAttentionObject.REACT_SURPRISED then
                  reaction_too_mild = true
                end
                if not attention_data.alert_t or not l_21_0.t - attention_data.alert_t then
                  local alert_dt = reaction_too_mild or 10000
                end
                local dmg_dt = attention_data.dmg_t and l_21_0.t - attention_data.dmg_t or 10000
                local mark_dt = attention_data.mark_t and l_21_0.t - attention_data.mark_t or 10000
                local near_threshold = 800
                if l_21_0.attention_obj and l_21_0.attention_obj.u_key == u_key then
                  alert_dt = alert_dt * 0.80000001192093
                  dmg_dt = dmg_dt * 0.80000001192093
                  mark_dt = mark_dt * 0.80000001192093
                  distance = distance * 0.80000001192093
                end
                local visible = attention_data.verified
                local near = distance < near_threshold
                local has_alerted = alert_dt < 5
                local has_damaged = dmg_dt < 2
                local been_marked = mark_dt < 8
                local dangerous_special = attention_data.is_very_dangerous
                local target_priority = distance
                local target_priority_slot = 0
                if visible and (dangerous_special or been_marked) and distance < 1600 then
                  target_priority_slot = 1
                elseif (has_alerted and has_damaged) or been_marked then
                  target_priority_slot = 2
                elseif visible and near and has_alerted then
                  target_priority_slot = 3
                elseif visible and has_alerted then
                  target_priority_slot = 4
                elseif visible then
                  target_priority_slot = 5
                elseif has_alerted then
                  target_priority_slot = 6
                else
                  target_priority_slot = 7
                end
                if reaction < AIAttentionObject.REACT_COMBAT then
                  target_priority_slot = 10 + target_priority_slot + math.max(0, AIAttentionObject.REACT_COMBAT - reaction)
                end
                if target_priority_slot ~= 0 then
                  local best = false
                  if not best_target then
                    best = true
                  elseif target_priority_slot < best_target_priority_slot then
                    best = true
                  elseif target_priority_slot == best_target_priority_slot and target_priority < best_target_priority then
                    best = true
                  end
                  if best then
                    best_target = attention_data
                    best_target_priority_slot = target_priority_slot
                    best_target_priority = target_priority
                    best_target_reaction = reaction
                  end
                end
              end
            end
          end
          return best_target, best_target_priority_slot, best_target_reaction
        end
         -- Warning: missing end command somewhere! Added here
      end
       -- Warning: missing end command somewhere! Added here
    end
     -- Warning: missing end command somewhere! Added here
  end
end


