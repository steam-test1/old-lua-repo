-- Decompiled using luadec 2.0.1 by sztupy (http://winmo.sztupy.hu)
-- Command line was: F:\SteamLibrary\SteamApps\common\PAYDAY 2\lua\lib\units\enemies\spooc\logics\spooclogicattack.luac 

SpoocLogicAttack = class(CopLogicAttack)
SpoocLogicAttack.enter = function(l_1_0, l_1_1, l_1_2)
  CopLogicBase.enter(l_1_0, l_1_1, l_1_2)
  l_1_0.unit:brain():cancel_all_pathing_searches()
  local old_internal_data = l_1_0.internal_data
  local my_data = {unit = l_1_0.unit}
  l_1_0.internal_data = my_data
  my_data.detection = l_1_0.char_tweak.detection.combat
  my_data.rsrv_pos = {}
  if old_internal_data then
    if not old_internal_data.rsrv_pos then
      my_data.rsrv_pos = my_data.rsrv_pos
    end
    CopLogicAttack._set_best_cover(l_1_0, my_data, old_internal_data.best_cover)
    CopLogicAttack._set_nearest_cover(my_data, old_internal_data.nearest_cover)
  end
  local key_str = tostring(l_1_0.key)
  my_data.update_queue_id = "SpoocLogicAttack.queued_update" .. key_str
  CopLogicBase.queue_task(my_data, my_data.update_queue_id, SpoocLogicAttack.queued_update, l_1_0, l_1_0.t)
  my_data.detection_task_key = "CopLogicAttack._upd_enemy_detection" .. key_str
  CopLogicBase.queue_task(my_data, my_data.detection_task_key, CopLogicAttack._upd_enemy_detection, l_1_0, l_1_0.t)
  l_1_0.unit:brain():set_update_enabled_state(false)
  CopLogicTravel.reset_actions(l_1_0, my_data, old_internal_data, CopLogicTravel.allowed_transitional_actions)
  local objective = l_1_0.objective
  my_data.attitude = not objective or l_1_0.objective.attitude or "avoid"
  my_data.weapon_range = l_1_0.char_tweak.weapon[l_1_0.unit:inventory():equipped_unit():base():weapon_tweak_data().usage].range
  local upper_body_action = l_1_0.unit:movement()._active_actions[3]
  if not upper_body_action or upper_body_action:type() ~= "shoot" then
    l_1_0.unit:movement():set_stance("hos")
  end
  l_1_0.unit:movement():set_cool(false)
  if my_data ~= l_1_0.internal_data then
    return 
  end
  my_data.cover_test_step = 1
  l_1_0.unit:brain():set_attention_settings({cbt = true})
end

SpoocLogicAttack.exit = function(l_2_0, l_2_1, l_2_2)
  CopLogicBase.exit(l_2_0, l_2_1, l_2_2)
  local my_data = l_2_0.internal_data
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
  l_2_0.unit:brain():set_update_enabled_state(true)
end

SpoocLogicAttack.queued_update = function(l_3_0)
  if CopLogicIdle._chk_relocate(l_3_0) then
    return 
  end
  local t = TimerManager:game():time()
  l_3_0.t = t
  local unit = l_3_0.unit
  local my_data = l_3_0.internal_data
  if my_data.spooc_attack then
    CopLogicBase._report_detections(l_3_0.detected_attention_objects)
    SpoocLogicAttack.queue_update(l_3_0, my_data)
    return 
  end
  if my_data.wants_stop_old_walk_action then
    if not l_3_0.unit:movement():chk_action_forbidden("walk") then
      l_3_0.unit:movement():action_request({type = "idle", body_part = 2})
      my_data.wants_stop_old_walk_action = nil
    end
    SpoocLogicAttack.queue_update(l_3_0, my_data)
    return 
  end
  CopLogicAttack._process_pathing_results(l_3_0, my_data)
  if not l_3_0.attention_obj or l_3_0.attention_obj.reaction < AIAttentionObject.REACT_AIM then
    CopLogicAttack._upd_enemy_detection(l_3_0, true)
    if my_data ~= l_3_0.internal_data or not l_3_0.attention_obj then
      return 
    end
  end
  SpoocLogicAttack._upd_spooc_attack(l_3_0, my_data)
  if my_data.spooc_attack then
    SpoocLogicAttack.queue_update(l_3_0, my_data)
    return 
  end
  if AIAttentionObject.REACT_COMBAT <= l_3_0.attention_obj.reaction then
    my_data.want_to_take_cover = CopLogicAttack._chk_wants_to_take_cover(l_3_0, my_data)
    CopLogicAttack._update_cover(l_3_0)
    CopLogicAttack._upd_combat_movement(l_3_0)
  end
  SpoocLogicAttack.queue_update(l_3_0, my_data)
  CopLogicBase._report_detections(l_3_0.detected_attention_objects)
end

SpoocLogicAttack.action_complete_clbk = function(l_4_0, l_4_1)
  local action_type = l_4_1:type()
  local my_data = l_4_0.internal_data
  if action_type == "walk" then
    if my_data.moving_to_cover then
      if l_4_1:expired() then
        my_data.in_cover = my_data.moving_to_cover
        CopLogicAttack._set_nearest_cover(my_data, my_data.in_cover)
        my_data.cover_enter_t = l_4_0.t
        my_data.cover_sideways_chk = nil
      end
      my_data.moving_to_cover = nil
    elseif my_data.walking_to_cover_shoot_pos then
      my_data.walking_to_cover_shoot_pos = nil
    elseif action_type == "shoot" then
      my_data.shooting = nil
    elseif action_type == "turn" then
      my_data.turning = nil
    elseif action_type == "spooc" and my_data.spooc_attack then
      my_data.spooc_attack = nil
    end
  end
end

SpoocLogicAttack._cancel_spooc_attempt = function(l_5_0, l_5_1)
  if l_5_1.spooc_attack then
    local new_action = {type = "idle", body_part = 2}
    l_5_0.unit:brain():action_request(new_action)
  end
end

SpoocLogicAttack._upd_spooc_attack = function(l_6_0, l_6_1)
  local focus_enemy = l_6_0.attention_obj
  if (l_6_1.attitude == "engage" and not l_6_0.is_suppressed and 1500) or focus_enemy.verified_dis < not focus_enemy.nav_tracker or not focus_enemy.is_person or not focus_enemy.criminal_record or focus_enemy.criminal_record.status or l_6_1.spooc_attack or not focus_enemy.verified or 900 and not l_6_0.unit:movement():chk_action_forbidden("walk") and (not l_6_1.last_dmg_t or l_6_0.t - l_6_1.last_dmg_t > 0.60000002384186) then
    local enemy_tracker = focus_enemy.nav_tracker
    local ray_params = {tracker_from = l_6_0.unit:movement():nav_tracker(), tracker_to = enemy_tracker, trace = true}
    if enemy_tracker:lost() then
      ray_params.pos_to = enemy_tracker:field_position()
    end
    local col_ray = managers.navigation:raycast(ray_params)
    if not col_ray then
      local z_diff_abs = math.abs(ray_params.trace[1].z - focus_enemy.m_pos.z)
      if z_diff_abs < 200 and SpoocLogicAttack._chk_request_action_spooc_attack(l_6_0, l_6_1) then
        l_6_1.spooc_attack = {start_t = l_6_0.t, target_u_data = focus_enemy}
        return true
      end
    end
  end
end

SpoocLogicAttack._chk_request_action_spooc_attack = function(l_7_0, l_7_1)
  if l_7_0.unit:anim_data().crouch then
    CopLogicAttack._chk_request_action_stand(l_7_0)
  end
  local new_action = {type = "idle", body_part = 3}
  l_7_0.unit:brain():action_request(new_action)
  local new_action_data = {type = "spooc", body_part = 1}
  if l_7_0.unit:brain():action_request(new_action_data) then
    if l_7_1.rsrv_pos.stand then
      managers.navigation:unreserve_pos(l_7_1.rsrv_pos.stand)
      l_7_1.rsrv_pos.stand = nil
    end
    return true
  end
end

SpoocLogicAttack.on_criminal_neutralized = function(l_8_0, l_8_1)
  CopLogicAttack.on_criminal_neutralized(l_8_0, l_8_1)
end

SpoocLogicAttack.on_detected_enemy_destroyed = function(l_9_0, l_9_1)
  CopLogicAttack.on_detected_enemy_destroyed(l_9_0, l_9_1)
end

SpoocLogicAttack.damage_clbk = function(l_10_0, l_10_1)
  l_10_0.internal_data.last_dmg_t = TimerManager:game():time()
  CopLogicIdle.damage_clbk(l_10_0, l_10_1)
end

SpoocLogicAttack.is_available_for_assignment = function(l_11_0)
  if l_11_0.internal_data.spooc_attack then
    return 
  end
  return CopLogicAttack.is_available_for_assignment(l_11_0)
end

SpoocLogicAttack.action_taken = function(l_12_0, l_12_1)
  if not CopLogicAttack.action_taken(l_12_0, l_12_1) then
    return l_12_1.spooc_attack
  end
end


