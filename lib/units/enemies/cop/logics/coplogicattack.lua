-- Decompiled using luadec 2.0.1 by sztupy (http://winmo.sztupy.hu)
-- Command line was: F:\SteamLibrary\SteamApps\common\PAYDAY 2\lua\lib\units\enemies\cop\logics\coplogicattack.luac 

local mvec3_set = mvector3.set
local mvec3_set_z = mvector3.set_z
local mvec3_sub = mvector3.subtract
local mvec3_dir = mvector3.direction
local mvec3_dot = mvector3.dot
local mvec3_dis = mvector3.distance
local mvec3_dis_sq = mvector3.distance_sq
local mvec3_lerp = mvector3.lerp
local temp_vec1 = Vector3()
local temp_vec2 = Vector3()
local temp_vec3 = Vector3()
CopLogicAttack = class(CopLogicBase)
CopLogicAttack.on_alert = CopLogicIdle.on_alert
CopLogicAttack.on_intimidated = CopLogicIdle.on_intimidated
CopLogicAttack.enter = function(l_1_0, l_1_1, l_1_2)
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
    my_data.attention_unit = old_internal_data.attention_unit
    CopLogicAttack._set_best_cover(l_1_0, my_data, old_internal_data.best_cover)
  end
  my_data.cover_test_step = 1
  local key_str = tostring(l_1_0.key)
  my_data.detection_task_key = "CopLogicAttack._upd_enemy_detection" .. key_str
  CopLogicBase.queue_task(my_data, my_data.detection_task_key, CopLogicAttack._upd_enemy_detection, l_1_0, l_1_0.t)
  local allowed_actions = nil
  if l_1_0.unit:movement():chk_action_forbidden("walk") and l_1_0.unit:movement()._active_actions[2] then
    allowed_actions = CopLogicTravel.allowed_transitional_actions_nav_link
    my_data.wants_stop_old_walk_action = true
  else
    allowed_actions = CopLogicTravel.allowed_transitional_actions
  end
  local idle_body_part = CopLogicTravel.reset_actions(l_1_0, my_data, old_internal_data, allowed_actions)
  local upper_body_action = l_1_0.unit:movement()._active_actions[3]
  if (not upper_body_action or upper_body_action:type() ~= "shoot") and idle_body_part == 1 then
    l_1_0.unit:movement():set_stance("hos")
  end
  if l_1_0.unit:anim_data().stand and (l_1_0.char_tweak.no_stand or not l_1_0.objective or l_1_0.objective.attitude ~= "engage") then
    CopLogicAttack._chk_request_action_crouch(l_1_0)
  end
  my_data.attitude = l_1_0.objective and l_1_0.objective.attitude or "avoid"
  my_data.weapon_range = l_1_0.char_tweak.weapon[l_1_0.unit:inventory():equipped_unit():base():weapon_tweak_data().usage].range
  l_1_0.unit:brain():set_update_enabled_state(true)
  l_1_0.unit:movement():set_cool(false)
  if my_data ~= l_1_0.internal_data then
    return 
  end
  l_1_0.unit:brain():set_attention_settings({cbt = true})
end

CopLogicAttack.exit = function(l_2_0, l_2_1, l_2_2)
  CopLogicBase.exit(l_2_0, l_2_1, l_2_2)
  local my_data = l_2_0.internal_data
  l_2_0.unit:brain():cancel_all_pathing_searches()
  CopLogicBase.cancel_queued_tasks(my_data)
  CopLogicBase.cancel_delayed_clbks(my_data)
  if my_data.best_cover then
    managers.navigation:release_cover(my_data.best_cover[1])
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

CopLogicAttack.update = function(l_3_0)
  local my_data = l_3_0.internal_data
  if my_data.wants_stop_old_walk_action and not l_3_0.unit:movement():chk_action_forbidden("walk") then
    l_3_0.unit:movement():action_request({type = "idle", body_part = 2})
    my_data.wants_stop_old_walk_action = nil
  end
  return 
  if CopLogicIdle._chk_relocate(l_3_0) then
    return 
  end
  CopLogicAttack._process_pathing_results(l_3_0, my_data)
  if not l_3_0.attention_obj or l_3_0.attention_obj.reaction < AIAttentionObject.REACT_AIM then
    CopLogicAttack._upd_enemy_detection(l_3_0, true)
    if my_data ~= l_3_0.internal_data or not l_3_0.attention_obj then
      return 
    end
  end
  if AIAttentionObject.REACT_COMBAT <= l_3_0.attention_obj.reaction then
    my_data.want_to_take_cover = CopLogicAttack._chk_wants_to_take_cover(l_3_0, my_data)
    CopLogicAttack._update_cover(l_3_0)
    CopLogicAttack._upd_combat_movement(l_3_0)
  end
  if l_3_0.is_converted and (not l_3_0.objective or l_3_0.objective.type == "free") and (not l_3_0.path_fail_t or l_3_0.t - l_3_0.path_fail_t > 6) then
    managers.groupai:state():on_criminal_jobless(l_3_0.unit)
    if my_data ~= l_3_0.internal_data then
      return 
    end
  end
  if not my_data.update_queue_id then
    l_3_0.unit:brain():set_update_enabled_state(false)
    my_data.update_queue_id = "CopLogicAttack.queued_update" .. tostring(l_3_0.key)
    CopLogicAttack.queue_update(l_3_0, my_data)
  end
end

CopLogicAttack._upd_combat_movement = function(l_4_0)
  local my_data = l_4_0.internal_data
  local t = l_4_0.t
  local unit = l_4_0.unit
  local focus_enemy = l_4_0.attention_obj
  local in_cover = my_data.in_cover
  local best_cover = my_data.best_cover
  local enemy_visible = focus_enemy.verified
  local enemy_visible_soft = not focus_enemy.verified_t or t - focus_enemy.verified_t < 2
  local enemy_visible_softer = not focus_enemy.verified_t or t - focus_enemy.verified_t < 15
  local alert_soft = l_4_0.is_suppressed
  local action_taken = l_4_0.logic.action_taken(l_4_0, my_data)
  local want_to_take_cover = my_data.want_to_take_cover
  if ((want_to_take_cover and not in_cover) or not in_cover[4] or l_4_0.char_tweak.no_stand and not unit:anim_data().crouch) then
    action_taken = CopLogicAttack._chk_request_action_crouch(l_4_0)
    do return end
    if unit:anim_data().crouch and (not l_4_0.char_tweak.allow_crouch or my_data.cover_test_step > 2) then
      action_taken = CopLogicAttack._chk_request_action_stand(l_4_0)
    end
  end
  local move_to_cover, want_flank_cover = nil, nil
  if my_data.cover_test_step ~= 1 and not enemy_visible_softer and (action_taken or want_to_take_cover or not in_cover) then
    my_data.cover_test_step = 1
  end
  if my_data.stay_out_time and (enemy_visible_soft or not my_data.at_cover_shoot_pos or action_taken or want_to_take_cover) then
    my_data.stay_out_time = nil
  elseif my_data.attitude == "engage" and not my_data.stay_out_time and not enemy_visible_soft and my_data.at_cover_shoot_pos and not action_taken and not want_to_take_cover then
    my_data.stay_out_time = t + 7
  end
  if action_taken then
    do return end
  end
  if want_to_take_cover then
    move_to_cover = true
  elseif not enemy_visible_soft then
    if l_4_0.tactics and l_4_0.tactics.charge and l_4_0.objective and l_4_0.objective.grp_objective and l_4_0.objective.grp_objective.charge and (not my_data.charge_path_failed_t or l_4_0.t - my_data.charge_path_failed_t > 6) then
      if my_data.charge_path then
        local path = my_data.charge_path
        my_data.charge_path = nil
        action_taken = CopLogicAttack._chk_request_action_walk_to_cover_shoot_pos(l_4_0, my_data, path)
      elseif not my_data.charge_path_search_id and l_4_0.attention_obj.nav_tracker then
        my_data.charge_pos = CopLogicTravel._get_pos_on_wall(l_4_0.attention_obj.nav_tracker:field_position(), my_data.weapon_range.optimal, 45, nil)
        if my_data.charge_pos then
          my_data.charge_path_search_id = "charge" .. tostring(l_4_0.key)
          unit:brain():search_for_path(my_data.charge_path_search_id, my_data.charge_pos, nil, nil, nil)
        else
          debug_pause_unit(l_4_0.unit, "failed to find charge_pos", l_4_0.unit)
          my_data.charge_path_failed_t = TimerManager:game():time()
        end
      elseif in_cover then
        if my_data.cover_test_step <= 2 then
          local height = nil
          if in_cover[4] then
            height = 150
          else
            height = 80
          end
          local my_tracker = unit:movement():nav_tracker()
          local shoot_from_pos = CopLogicAttack._peek_for_pos_sideways(l_4_0, my_data, my_tracker, focus_enemy.m_head_pos, height)
          if shoot_from_pos then
            local path = {my_tracker:position(), shoot_from_pos}
            action_taken = CopLogicAttack._chk_request_action_walk_to_cover_shoot_pos(l_4_0, my_data, path, math.random() < 0.5 and "run" or "walk")
          else
            my_data.cover_test_step = my_data.cover_test_step + 1
          end
        elseif not enemy_visible_softer and math.random() < 0.050000000745058 then
          move_to_cover = true
          want_flank_cover = true
        elseif my_data.walking_to_cover_shoot_pos then
          do return end
        end
         -- DECOMPILER ERROR: unhandled construct in 'if'

        if my_data.at_cover_shoot_pos and my_data.stay_out_time < t then
          move_to_cover = true
          do return end
          move_to_cover = true
        end
      end
    end
  end
end
if not my_data.processing_cover_path and not my_data.cover_path and not my_data.charge_path_search_id and not action_taken and best_cover and (not in_cover or best_cover[1] ~= in_cover[1]) and (not my_data.cover_path_failed_t or l_4_0.t - my_data.cover_path_failed_t > 5) then
  CopLogicAttack._cancel_cover_pathing(l_4_0, my_data)
  local search_id = tostring(unit:key()) .. "cover"
  if l_4_0.unit:brain():search_for_path_to_cover(search_id, best_cover[1], best_cover[5]) then
    my_data.cover_path_search_id = search_id
    my_data.processing_cover_path = best_cover
  end
end
if not action_taken and move_to_cover and my_data.cover_path then
  action_taken = CopLogicAttack._chk_request_action_walk_to_cover(l_4_0, my_data)
end
if math.random() >= 0.5 or not -1 then
  local sign = not want_flank_cover or my_data.flank_cover or 1
end
do
  local step = 30
  my_data.flank_cover = {step = step, angle = step * sign, sign = sign}
end

if not my_data.turning and not l_4_0.unit:movement():chk_action_forbidden("walk") and l_4_0.attention_obj.verified and (not in_cover or not in_cover[4]) then
  if l_4_0.is_suppressed and l_4_0.t - l_4_0.unit:character_damage():last_suppression_t() < 0.69999998807907 then
    action_taken = CopLogicBase.chk_start_action_dodge(l_4_0, "scared")
  end
  if (l_4_0.group and l_4_0.group.size > 1) or math.random() < 0.5 then
    local dodge = nil
    if focus_enemy.is_local_player then
      local e_movement_state = focus_enemy.unit:movement():current_state()
      if not e_movement_state:_is_reloading() and not e_movement_state:_interacting() and not e_movement_state:is_equipping() then
        dodge = true
      else
        local e_anim_data = focus_enemy.unit:anim_data()
        if (e_anim_data.move or e_anim_data.idle) and not e_anim_data.reload then
          dodge = true
        end
      end
    end
    if dodge and focus_enemy.aimed_at then
      action_taken = CopLogicBase.chk_start_action_dodge(l_4_0, "preemptive")
    end
  end
end
if not action_taken and want_to_take_cover and not best_cover then
  action_taken = CopLogicAttack._chk_start_action_move_back(l_4_0, my_data, focus_enemy, false)
end
if not action_taken then
  action_taken = CopLogicAttack._chk_start_action_move_out_of_the_way(l_4_0, my_data)
end
end

CopLogicAttack._chk_start_action_move_back = function(l_5_0, l_5_1, l_5_2, l_5_3)
  if l_5_2 and l_5_2.nav_tracker and l_5_2.verified and l_5_2.dis < 250 then
    local from_pos = mvector3.copy(l_5_0.m_pos)
    local threat_tracker = l_5_2.nav_tracker
    local threat_head_pos = l_5_2.m_head_pos
    local max_walk_dis = 400
    local vis_required = l_5_3
    local retreat_to = CopLogicAttack._find_retreat_position(from_pos, l_5_2.m_pos, threat_head_pos, threat_tracker, max_walk_dis, vis_required)
    if retreat_to then
      CopLogicAttack._cancel_cover_pathing(l_5_0, l_5_1)
      local new_action_data = {type = "walk", nav_path = {from_pos, retreat_to}, variant = "walk", body_part = 2}
      if l_5_0.unit:brain():action_request(new_action_data) then
        l_5_1.surprised = true
        local reservation = {position = retreat_to, radius = 60, filter = l_5_0.pos_rsrv_id}
        managers.navigation:add_pos_reservation(reservation)
        l_5_1.rsrv_pos.move_dest = reservation
        if l_5_1.rsrv_pos.stand then
          managers.navigation:unreserve_pos(l_5_1.rsrv_pos.stand)
          l_5_1.rsrv_pos.stand = nil
        end
        return true
      end
    end
  end
end

CopLogicAttack._chk_start_action_move_out_of_the_way = function(l_6_0, l_6_1)
  local my_tracker = l_6_0.unit:movement():nav_tracker()
  local reservation = {position = l_6_0.m_pos, radius = 30, filter = l_6_0.pos_rsrv_id}
  if not managers.navigation:is_pos_free(reservation) then
    local to_pos = CopLogicTravel._get_pos_on_wall(l_6_0.m_pos, 500)
    if to_pos then
      local rsrv_pos = l_6_1.rsrv_pos
      if rsrv_pos.stand then
        managers.navigation:unreserve_pos(rsrv_pos.stand)
        rsrv_pos.stand = nil
      end
      if rsrv_pos.move_dest then
        managers.navigation:unreserve_pos(rsrv_pos.move_dest)
        rsrv_pos.move_dest = nil
      end
      if rsrv_pos.path then
        managers.navigation:unreserve_pos(rsrv_pos.path)
      end
      local reservation = {position = to_pos, radius = 60, filter = l_6_0.pos_rsrv_id}
      managers.navigation:add_pos_reservation(reservation)
      rsrv_pos.path = reservation
      local path = {my_tracker:position(), to_pos}
      CopLogicAttack._chk_request_action_walk_to_cover_shoot_pos(l_6_0, l_6_1, path, "run")
    end
  end
end

CopLogicAttack.queued_update = function(l_7_0)
  local my_data = l_7_0.internal_data
  l_7_0.t = TimerManager:game():time()
  CopLogicAttack.update(l_7_0)
  if l_7_0.internal_data == my_data then
    CopLogicAttack.queue_update(l_7_0, l_7_0.internal_data)
  end
end

CopLogicAttack._peek_for_pos_sideways = function(l_8_0, l_8_1, l_8_2, l_8_3, l_8_4)
  local unit = l_8_0.unit
  local my_tracker = l_8_2
  local enemy_pos = l_8_3
  local my_pos = unit:movement():m_pos()
  local back_vec = my_pos - enemy_pos
  mvector3.set_z(back_vec, 0)
  mvector3.set_length(back_vec, 75)
  local back_pos = my_pos + back_vec
  local ray_params = {tracker_from = my_tracker, allow_entry = true, pos_to = back_pos, trace = true}
  local ray_res = managers.navigation:raycast(ray_params)
  back_pos = ray_params.trace[1]
  local back_polar = back_pos - my_pos:to_polar()
  local right_polar = back_polar:with_spin(back_polar.spin + 90):with_r(100 + 80 * l_8_1.cover_test_step)
  local right_vec = right_polar:to_vector()
  local right_pos = back_pos + right_vec
  ray_params.pos_to = right_pos
  local ray_res = (managers.navigation:raycast(ray_params))
  local shoot_from_pos, found_shoot_from_pos = nil, nil
  local ray_softness = 150
  local stand_ray = World:raycast("ray", ray_params.trace[1] + math.UP * l_8_4, enemy_pos, "slot_mask", l_8_0.visibility_slotmask, "ray_type", "ai_vision")
  if not stand_ray or mvector3.distance(stand_ray.position, enemy_pos) < ray_softness then
    shoot_from_pos = ray_params.trace[1]
    found_shoot_from_pos = true
  end
  if not found_shoot_from_pos then
    local left_pos = back_pos - right_vec
    ray_params.pos_to = left_pos
    local ray_res = managers.navigation:raycast(ray_params)
    local stand_ray = World:raycast("ray", ray_params.trace[1] + math.UP * l_8_4, enemy_pos, "slot_mask", l_8_0.visibility_slotmask, "ray_type", "ai_vision")
    if not stand_ray or mvector3.distance(stand_ray.position, enemy_pos) < ray_softness then
      shoot_from_pos = ray_params.trace[1]
      found_shoot_from_pos = true
    end
  end
  return shoot_from_pos
end

CopLogicAttack._cancel_cover_pathing = function(l_9_0, l_9_1)
  if l_9_1.processing_cover_path then
    if l_9_0.active_searches[l_9_1.cover_path_search_id] then
      managers.navigation:cancel_pathing_search(l_9_1.cover_path_search_id)
      l_9_0.active_searches[l_9_1.cover_path_search_id] = nil
    elseif l_9_0.pathing_results then
      l_9_0.pathing_results[l_9_1.cover_path_search_id] = nil
    end
    l_9_1.processing_cover_path = nil
    l_9_1.cover_path_search_id = nil
  end
  l_9_1.cover_path = nil
end

CopLogicAttack._cancel_charge = function(l_10_0, l_10_1)
  l_10_1.charge_pos = nil
  l_10_1.charge_path = nil
  if l_10_1.charge_path_search_id then
    if l_10_0.active_searches[l_10_1.charge_path_search_id] then
      managers.navigation:cancel_pathing_search(l_10_1.charge_path_search_id)
      l_10_0.active_searches[l_10_1.charge_path_search_id] = nil
    elseif l_10_0.pathing_results then
      l_10_0.pathing_results[l_10_1.charge_path_search_id] = nil
    end
    l_10_1.charge_path_search_id = nil
  end
end

CopLogicAttack._cancel_expected_pos_path = function(l_11_0, l_11_1)
  l_11_1.expected_pos_path = nil
  if l_11_1.expected_pos_path_search_id then
    if l_11_0.active_searches[l_11_1.expected_pos_path_search_id] then
      managers.navigation:cancel_pathing_search(l_11_1.expected_pos_path_search_id)
      l_11_0.active_searches[l_11_1.expected_pos_path_search_id] = nil
    elseif l_11_0.pathing_results then
      l_11_0.pathing_results[l_11_1.expected_pos_path_search_id] = nil
    end
    l_11_1.expected_pos_path_search_id = nil
  end
end

CopLogicAttack._chk_request_action_turn_to_enemy = function(l_12_0, l_12_1, l_12_2, l_12_3)
  local fwd = l_12_0.unit:movement():m_rot():y()
  local target_vec = l_12_3 - l_12_2
  local error_spin = target_vec:to_polar_with_reference(fwd, math.UP).spin
  if math.abs(error_spin) > 27 then
    local new_action_data = {}
    new_action_data.type = "turn"
    new_action_data.body_part = 2
    new_action_data.angle = error_spin
    if l_12_0.unit:brain():action_request(new_action_data) then
      l_12_1.turning = new_action_data.angle
      return true
    end
  end
end

CopLogicAttack._cancel_walking_to_cover = function(l_13_0, l_13_1, l_13_2)
  l_13_1.cover_path = nil
  do
    if l_13_1.moving_to_cover and not l_13_2 then
      local new_action = {type = "idle", body_part = 2}
      l_13_0.unit:brain():action_request(new_action)
    end
    do return end
    if l_13_1.processing_cover_path then
      if l_13_1.rsrv_pos.path then
        managers.navigation:unreserve_pos(l_13_1.rsrv_pos.path)
        l_13_1.rsrv_pos.path = nil
      end
      l_13_0.unit:brain():cancel_all_pathing_searches()
      l_13_1.cover_path_search_id = nil
      l_13_1.processing_cover_path = nil
    end
  end
end

CopLogicAttack._chk_request_action_walk_to_cover = function(l_14_0, l_14_1)
  CopLogicAttack._correct_path_start_pos(l_14_0, l_14_1.cover_path)
  local haste = nil
  if (not l_14_0.attention_obj or l_14_0.attention_obj.reaction < AIAttentionObject.REACT_COMBAT or l_14_0.attention_obj.dis > 500) and mvector3.distance_sq(l_14_1.cover_path[#l_14_1.cover_path], l_14_0.m_pos) < 90000 then
    haste = "run"
  elseif l_14_0.attention_obj and AIAttentionObject.REACT_COMBAT <= l_14_0.attention_obj.reaction and math.lerp(l_14_1.weapon_range.optimal, l_14_1.weapon_range.far, 0.75) < l_14_0.attention_obj.dis then
    haste = "run"
  else
    haste = "walk"
  end
  local new_action_data = {type = "walk", nav_path = l_14_1.cover_path, variant = haste, body_part = 2}
  l_14_1.cover_path = nil
  if l_14_0.unit:brain():action_request(new_action_data) then
    l_14_1.moving_to_cover = l_14_1.best_cover
    l_14_1.at_cover_shoot_pos = nil
    l_14_1.in_cover = nil
    l_14_1.rsrv_pos.move_dest = l_14_1.rsrv_pos.path
    l_14_1.rsrv_pos.path = nil
    if l_14_1.rsrv_pos.stand then
      managers.navigation:unreserve_pos(l_14_1.rsrv_pos.stand)
      l_14_1.rsrv_pos.stand = nil
    end
  end
end

CopLogicAttack._correct_path_start_pos = function(l_15_0, l_15_1)
  local first_nav_point = l_15_1[1]
  local my_pos = l_15_0.m_pos
  if first_nav_point.x ~= my_pos.x or first_nav_point.y ~= my_pos.y then
    table.insert(l_15_1, 1, mvector3.copy(my_pos))
  end
end

CopLogicAttack._chk_request_action_walk_to_cover_shoot_pos = function(l_16_0, l_16_1, l_16_2, l_16_3)
  CopLogicAttack._cancel_cover_pathing(l_16_0, l_16_1)
  CopLogicAttack._cancel_charge(l_16_0, l_16_1)
  CopLogicAttack._correct_path_start_pos(l_16_0, l_16_2)
  local new_action_data = {type = "walk", nav_path = l_16_2, variant = l_16_3 or "walk", body_part = 2}
  l_16_1.cover_path = nil
  local res = l_16_0.unit:brain():action_request(new_action_data)
  if res then
    l_16_1.walking_to_cover_shoot_pos = res
    l_16_1.at_cover_shoot_pos = nil
    l_16_1.in_cover = nil
    l_16_1.rsrv_pos.move_dest = l_16_1.rsrv_pos.path
    l_16_1.rsrv_pos.path = nil
    if l_16_1.rsrv_pos.stand then
      managers.navigation:unreserve_pos(l_16_1.rsrv_pos.stand)
      l_16_1.rsrv_pos.stand = nil
    end
  end
end

CopLogicAttack._chk_request_action_crouch = function(l_17_0)
  if l_17_0.unit:movement():chk_action_forbidden("crouch") then
    return 
  end
  local new_action_data = {type = "crouch", body_part = 4}
  local res = l_17_0.unit:brain():action_request(new_action_data)
  return res
end

CopLogicAttack._chk_request_action_stand = function(l_18_0)
  if l_18_0.unit:movement():chk_action_forbidden("stand") then
    return 
  end
  local new_action_data = {type = "stand", body_part = 4}
  local res = l_18_0.unit:brain():action_request(new_action_data)
  return res
end

CopLogicAttack._update_cover = function(l_19_0)
  local my_data = l_19_0.internal_data
  local cover_release_dis_sq = 10000
  local best_cover = my_data.best_cover
  local satisfied = true
  local my_pos = l_19_0.m_pos
  local find_new = (not my_data.moving_to_cover and not my_data.walking_to_cover_shoot_pos and not my_data.surprised)
  if find_new then
    local enemy_tracker = l_19_0.attention_obj.nav_tracker
    local threat_pos = enemy_tracker:field_position()
    if l_19_0.objective and l_19_0.objective.type == "follow" then
      local near_pos = l_19_0.objective.follow_unit:movement():m_pos()
      if (not best_cover or not CopLogicAttack._verify_follow_cover(best_cover[1], near_pos, threat_pos, 200, 1000)) and not my_data.processing_cover_path and not my_data.charge_path_search_id then
        local follow_unit_area = managers.groupai:state():get_area_from_nav_seg_id(l_19_0.objective.follow_unit:movement():nav_tracker():nav_segment())
        local found_cover = managers.navigation:find_cover_in_nav_seg_3(managers.navigation, follow_unit_area.nav_segs, l_19_0.objective.distance and l_19_0.objective.distance * 0.89999997615814 or nil, near_pos, threat_pos)
        if found_cover then
          if not follow_unit_area.nav_segs[found_cover[3]:nav_segment()] then
            debug_pause_unit(l_19_0.unit, "cover in wrong area")
          end
          satisfied = true
          local better_cover = {found_cover}
          CopLogicAttack._set_best_cover(l_19_0, my_data, better_cover)
          local offset_pos, yaw = CopLogicAttack._get_cover_offset_pos(l_19_0, better_cover, threat_pos)
          if offset_pos then
            better_cover[5] = offset_pos
            better_cover[6] = yaw
          else
            local want_to_take_cover = my_data.want_to_take_cover
            local flank_cover = my_data.flank_cover
            local min_dis, max_dis = nil, nil
            if want_to_take_cover then
              min_dis = math.max(l_19_0.attention_obj.dis * 0.89999997615814, l_19_0.attention_obj.dis - 200)
            end
            if not my_data.processing_cover_path and not my_data.charge_path_search_id and (not best_cover or flank_cover or not CopLogicAttack._verify_cover(best_cover[1], threat_pos, min_dis, max_dis)) then
              satisfied = false
              local my_vec = my_pos - threat_pos
              if flank_cover then
                mvector3.rotate_with(my_vec, Rotation(flank_cover.angle))
              end
              local optimal_dis = (my_vec:length())
              local max_dis = nil
              if want_to_take_cover then
                if optimal_dis < my_data.weapon_range.far then
                  optimal_dis = optimal_dis + 400
                  mvector3.set_length(my_vec, optimal_dis)
                end
                max_dis = math.max(optimal_dis + 800, my_data.weapon_range.far)
              else
                if my_data.weapon_range.optimal * 1.2000000476837 < optimal_dis then
                  optimal_dis = my_data.weapon_range.optimal
                  mvector3.set_length(my_vec, optimal_dis)
                  max_dis = my_data.weapon_range.far
                end
              end
              local my_side_pos = threat_pos + my_vec
              mvector3.set_length(my_vec, max_dis)
              local furthest_side_pos = threat_pos + my_vec
              if flank_cover then
                local angle = flank_cover.angle
                local sign = flank_cover.sign
                if math.sign(angle) ~= sign then
                  angle = -angle + flank_cover.step * sign
                  if math.abs(angle) > 90 then
                    flank_cover.failed = true
                  else
                    flank_cover.angle = angle
                  end
                else
                  flank_cover.angle = -(angle)
                end
              end
              local min_threat_dis, cone_angle = nil, nil
              if flank_cover then
                cone_angle = flank_cover.step
              else
                cone_angle = math.lerp(90, 60, math.min(1, optimal_dis / 3000))
              end
              local search_nav_seg = nil
              if l_19_0.objective and l_19_0.objective.type == "defend_area" and (not l_19_0.objective.area or not l_19_0.objective.area.nav_segs) then
                search_nav_seg = l_19_0.objective.nav_seg
              end
              local found_cover = managers.navigation:find_cover_in_cone_from_threat_pos_1(managers.navigation, threat_pos, furthest_side_pos, my_side_pos, nil, cone_angle, min_threat_dis, search_nav_seg, nil, l_19_0.pos_rsrv_id)
              if found_cover and (not best_cover or CopLogicAttack._verify_cover(found_cover, threat_pos, min_dis, max_dis)) then
                satisfied = true
                local better_cover = {found_cover}
                CopLogicAttack._set_best_cover(l_19_0, my_data, better_cover)
                local offset_pos, yaw = CopLogicAttack._get_cover_offset_pos(l_19_0, better_cover, threat_pos)
                if offset_pos then
                  better_cover[5] = offset_pos
                  better_cover[6] = yaw
                end
              end
            end
          end
        end
      end
    end
  end
  local in_cover = my_data.in_cover
  do
    if in_cover then
      local threat_pos = l_19_0.attention_obj.verified_pos
      in_cover[3], in_cover[4] = CopLogicAttack._chk_covered(l_19_0, my_pos, threat_pos, l_19_0.visibility_slotmask), l_19_0
    end
    do return end
    if best_cover and cover_release_dis_sq < mvector3.distance_sq(best_cover[1][1], my_pos) then
      CopLogicAttack._set_best_cover(l_19_0, my_data, nil)
    end
  end
end

CopLogicAttack._verify_cover = function(l_20_0, l_20_1, l_20_2, l_20_3)
  local threat_dis = mvector3.direction(temp_vec1, l_20_0[1], l_20_1)
  if (l_20_2 and threat_dis < l_20_2) or l_20_3 and l_20_3 < threat_dis then
    return 
  end
  local cover_dot = mvector3.dot(temp_vec1, l_20_0[2])
  if cover_dot < 0.6700000166893 then
    return 
  end
  return true
end

CopLogicAttack._verify_follow_cover = function(l_21_0, l_21_1, l_21_2, l_21_3, l_21_4)
  if CopLogicAttack._verify_cover(l_21_0, l_21_2, l_21_3, l_21_4) and mvector3.distance(l_21_1, l_21_0[1]) < 600 then
    return true
  end
end

CopLogicAttack._chk_covered = function(l_22_0, l_22_1, l_22_2, l_22_3)
  local ray_from = temp_vec1
  mvec3_set(ray_from, math.UP)
  mvector3.multiply(ray_from, 80)
  mvector3.add(ray_from, l_22_1)
  local ray_to_pos = temp_vec2
  mvector3.step(ray_to_pos, ray_from, l_22_2, 300)
  local low_ray = (World:raycast("ray", ray_from, ray_to_pos, "slot_mask", l_22_3))
  local high_ray = nil
  if low_ray then
    mvector3.set_z(ray_from, ray_from.z + 60)
    mvector3.step(ray_to_pos, ray_from, l_22_2, 300)
    high_ray = World:raycast("ray", ray_from, ray_to_pos, "slot_mask", l_22_3)
  end
  return low_ray, high_ray
end

CopLogicAttack._process_pathing_results = function(l_23_0, l_23_1)
  if not l_23_0.pathing_results then
    return 
  end
  local pathing_results = l_23_0.pathing_results
  l_23_0.pathing_results = nil
  local path = pathing_results[l_23_1.cover_path_search_id]
  if path then
    if path ~= "failed" then
      l_23_1.cover_path = path
    else
      print(l_23_0.unit, "[CopLogicAttack._process_pathing_results] cover path failed", l_23_0.unit)
      CopLogicAttack._set_best_cover(l_23_0, l_23_1, nil)
      l_23_1.cover_path_failed_t = TimerManager:game():time()
    end
    l_23_1.processing_cover_path = nil
    l_23_1.cover_path_search_id = nil
  end
  path = pathing_results[l_23_1.charge_path_search_id]
  if path then
    if path ~= "failed" then
      l_23_1.charge_path = path
    else
      print("[CopLogicAttack._process_pathing_results] charge path failed", l_23_0.unit)
    end
    l_23_1.charge_path_search_id = nil
    l_23_1.charge_path_failed_t = TimerManager:game():time()
  end
  path = pathing_results[l_23_1.expected_pos_path_search_id]
   -- DECOMPILER ERROR: unhandled construct in 'if'

  if path and path ~= "failed" then
    l_23_1.expected_pos_path = path
  end
  l_23_1.expected_pos_path_search_id = nil
end

CopLogicAttack._upd_enemy_detection = function(l_24_0, l_24_1)
  managers.groupai:state():on_unit_detection_updated(l_24_0.unit)
  l_24_0.t = TimerManager:game():time()
  local my_data = l_24_0.internal_data
  local delay = CopLogicBase._upd_attention_obj_detection(l_24_0, nil, nil)
  local new_attention, new_prio_slot, new_reaction = CopLogicIdle._get_priority_attention(l_24_0, l_24_0.detected_attention_objects, nil)
  local old_att_obj = l_24_0.attention_obj
  CopLogicBase._set_attention_obj(l_24_0, new_attention, new_reaction)
  CopLogicAttack._chk_exit_attack_logic(l_24_0, new_reaction)
  if my_data ~= l_24_0.internal_data then
    return 
  end
  if new_attention and old_att_obj and old_att_obj.u_key ~= new_attention.u_key then
    CopLogicAttack._cancel_charge(l_24_0, my_data)
    my_data.flank_cover = nil
    if not l_24_0.unit:movement():chk_action_forbidden("walk") then
      CopLogicAttack._cancel_walking_to_cover(l_24_0, my_data)
    end
    CopLogicAttack._set_best_cover(l_24_0, my_data, nil)
    do return end
    if old_att_obj then
      CopLogicAttack._cancel_charge(l_24_0, my_data)
      my_data.flank_cover = nil
    end
  end
  CopLogicBase._chk_call_the_police(l_24_0)
  if my_data ~= l_24_0.internal_data then
    return 
  end
  CopLogicAttack._upd_aim(l_24_0, my_data)
  CopLogicBase.queue_task(my_data, my_data.detection_task_key, CopLogicAttack._upd_enemy_detection, l_24_0, l_24_0.t + delay, l_24_1 or (delay and not l_24_0.important) or true)
  CopLogicBase._report_detections(l_24_0.detected_attention_objects)
end

CopLogicAttack._confirm_retreat_position = function(l_25_0, l_25_1, l_25_2, l_25_3)
  local ray_params = {pos_from = l_25_0, tracker_to = l_25_3, trace = true}
  local walk_ray_res = managers.navigation:raycast(ray_params)
  if not walk_ray_res then
    return ray_params.trace[1]
  end
  local retreat_head_pos = mvector3.copy(l_25_0)
  mvector3.add(retreat_head_pos, Vector3(0, 0, 150))
  local slotmask = managers.slot:get_mask("AI_visibility")
  local ray_res = World:raycast("ray", retreat_head_pos, l_25_2, "slot_mask", slotmask, "ray_type", "ai_vision")
  if not ray_res and not walk_ray_res then
    return ray_params.trace[1]
  end
  return false
end

CopLogicAttack._find_retreat_position = function(l_26_0, l_26_1, l_26_2, l_26_3, l_26_4, l_26_5)
  local nav_manager = managers.navigation
  local nr_rays = 5
  local ray_dis = l_26_4 or 1000
  local step = 180 / nr_rays
  local offset = math.random(step)
  local dir = math.random() < 0.5 and -1 or 1
  step = step * dir
  local step_rot = Rotation(step)
  local offset_rot = Rotation(offset)
  local offset_vec = mvector3.copy(l_26_1)
  mvector3.subtract(offset_vec, l_26_0)
  mvector3.normalize(offset_vec)
  mvector3.multiply(offset_vec, ray_dis)
  mvector3.rotate_with(offset_vec, Rotation((90 + offset) * dir))
  local to_pos = nil
  local from_tracker = nav_manager:create_nav_tracker(l_26_0)
  local ray_params = {tracker_from = from_tracker, trace = true}
  local rsrv_desc = {radius = 60}
  local fail_position = nil
  repeat
    to_pos = mvector3.copy(l_26_0)
    mvector3.add(to_pos, offset_vec)
    ray_params.pos_to = to_pos
    do
      local ray_res = nav_manager:raycast(ray_params)
      if ray_res then
        rsrv_desc.position = ray_params.trace[1]
        local is_free = nav_manager:is_pos_free(rsrv_desc)
        if is_free and (not l_26_5 or CopLogicAttack._confirm_retreat_position(ray_params.trace[1], l_26_1, l_26_2, l_26_3)) then
          managers.navigation:destroy_nav_tracker(from_tracker)
          return ray_params.trace[1]
          do return end
        elseif not fail_position then
          rsrv_desc.position = ray_params.trace[1]
          local is_free = nav_manager:is_pos_free(rsrv_desc)
          if is_free then
            fail_position = ray_params.trace[1]
          end
        end
      end
      mvector3.rotate_with(offset_vec, step_rot)
      nr_rays = nr_rays - 1
    until nr_rays == 0
  end
  managers.navigation:destroy_nav_tracker(from_tracker)
  if fail_position then
    return fail_position
  end
  return nil
end

CopLogicAttack.action_complete_clbk = function(l_27_0, l_27_1)
  local my_data = l_27_0.internal_data
  local action_type = l_27_1:type()
  if action_type == "walk" then
    CopLogicAttack._cancel_cover_pathing(l_27_0, my_data)
    CopLogicAttack._cancel_charge(l_27_0, my_data)
    if l_27_1:expired() then
      my_data.rsrv_pos.stand = my_data.rsrv_pos.move_dest
    else
      local reservation = managers.navigation:reserve_pos(l_27_0.t, nil, l_27_0.m_pos, nil, 60, l_27_0.pos_rsrv_id)
      my_data.rsrv_pos.stand = reservation
      if my_data.rsrv_pos.move_dest then
        managers.navigation:unreserve_pos(my_data.rsrv_pos.move_dest)
      end
    end
    my_data.rsrv_pos.move_dest = nil
    if my_data.surprised then
      my_data.surprised = false
    elseif my_data.moving_to_cover then
      if l_27_1:expired() then
        my_data.in_cover = my_data.moving_to_cover
        my_data.cover_enter_t = l_27_0.t
      end
      my_data.moving_to_cover = nil
    elseif my_data.walking_to_cover_shoot_pos then
      my_data.walking_to_cover_shoot_pos = nil
      my_data.at_cover_shoot_pos = true
    elseif action_type == "shoot" then
      my_data.shooting = nil
    elseif action_type == "turn" then
      my_data.turning = nil
    elseif action_type == "hurt" then
      CopLogicAttack._cancel_cover_pathing(l_27_0, my_data)
      if l_27_1:expired() and not CopLogicBase.chk_start_action_dodge(l_27_0, "hit") then
        CopLogicAttack._upd_aim(l_27_0, my_data)
      elseif action_type == "dodge" then
        local timeout = l_27_1:timeout()
        if timeout then
          l_27_0.dodge_timeout_t = TimerManager:game():time() + math.lerp(timeout[1], timeout[2], math.random())
        end
        CopLogicAttack._cancel_cover_pathing(l_27_0, my_data)
        if my_data.rsrv_pos.stand then
          managers.navigation:unreserve_pos(my_data.rsrv_pos.stand)
        end
        local reservation = managers.navigation:reserve_pos(l_27_0.t, nil, l_27_0.m_pos, nil, 60, l_27_0.pos_rsrv_id)
        my_data.rsrv_pos.stand = reservation
      end
    end
  end
end

CopLogicAttack._upd_aim = function(l_28_0, l_28_1)
  local shoot, aim, expected_pos = nil, nil, nil
  local focus_enemy = l_28_0.attention_obj
  if focus_enemy and AIAttentionObject.REACT_AIM <= focus_enemy.reaction then
    local last_sup_t = l_28_0.unit:character_damage():last_suppression_t()
    if focus_enemy.verified or focus_enemy.nearly_visible then
      if l_28_0.unit:anim_data().run and math.lerp(l_28_1.weapon_range.close, l_28_1.weapon_range.optimal, 0) < focus_enemy.dis then
        local walk_to_pos = l_28_0.unit:movement():get_walk_to_pos()
        if walk_to_pos then
          mvector3.direction(temp_vec1, l_28_0.m_pos, walk_to_pos)
          mvector3.direction(temp_vec2, l_28_0.m_pos, focus_enemy.m_pos)
          local dot = mvector3.dot(temp_vec1, temp_vec2)
          if dot < 0.60000002384186 and dot > -0.60000002384186 then
            shoot = false
            aim = false
          end
        end
      end
      if aim == nil then
        aim = true
        if AIAttentionObject.REACT_SHOOT <= focus_enemy.reaction then
          if focus_enemy.verified then
            if focus_enemy.aimed_at and (focus_enemy.verified_dis < l_28_0.internal_data.weapon_range.close or focus_enemy.verified_dis >= l_28_0.internal_data.weapon_range.optimal or not l_28_0.unit:anim_data().run) then
              shoot = true
            elseif last_sup_t and l_28_0.t - last_sup_t < 7 then
              shoot = true
            else
              if focus_enemy.reaction == AIAttentionObject.REACT_SHOOT then
                shoot = true
               -- DECOMPILER ERROR: unhandled construct in 'if'

              elseif l_28_1.attitude == "engage" and focus_enemy.verified_dis < l_28_0.internal_data.weapon_range.far then
                shoot = true
                do return end
                if focus_enemy.verified_dis < l_28_0.internal_data.weapon_range.close then
                  shoot = true
                elseif last_sup_t and l_28_0.t - last_sup_t < 20 and focus_enemy.verified_dis < l_28_0.internal_data.weapon_range.far then
                  shoot = true
                elseif last_sup_t and l_28_0.t - last_sup_t < 3 and l_28_0.unit:anim_data().still then
                  shoot = true
                elseif focus_enemy.verified_t then
                  if l_28_0.t - focus_enemy.verified_t < l_28_0.name == "travel" and 1.5 or 4 and focus_enemy.verified_dis < l_28_0.internal_data.weapon_range.optimal and math.abs(focus_enemy.verified_pos.z - l_28_0.m_pos.z) < 250 then
                    aim = true
                    if AIAttentionObject.REACT_SHOOT <= focus_enemy.reaction and l_28_1.shooting and l_28_0.t - focus_enemy.verified_t < 3 then
                      shoot = true
                    else
                      expected_pos = CopLogicAttack._get_expected_attention_position(l_28_0, l_28_1)
                      if expected_pos then
                        aim = true
                      else
                        if l_28_0.t - focus_enemy.verified_t < 20 or focus_enemy.verified_dis < 1000 then
                          aim = true
                          if l_28_1.shooting and l_28_1.firing and last_sup_t and l_28_0.t - last_sup_t < 7 and AIAttentionObject.REACT_SHOOT <= focus_enemy.reaction and l_28_1.shooting and l_28_0.t - focus_enemy.verified_t < 3 then
                            shoot = true
                          else
                            expected_pos = CopLogicAttack._get_expected_attention_position(l_28_0, l_28_1)
                            if expected_pos then
                              aim = true
                            end
                          end
                        end
                      end
                    end
                  end
                end
              end
            end
          end
        end
      end
    end
  end
  if l_28_0.logic.chk_should_turn(l_28_0, l_28_1) and (focus_enemy or expected_pos) then
    if (not focus_enemy.verified and not focus_enemy.nearly_visible) or not focus_enemy.m_pos then
      local enemy_pos = focus_enemy.verified_pos
    end
    CopLogicAttack._chk_request_action_turn_to_enemy(l_28_0, l_28_1, l_28_0.m_pos, enemy_pos)
  end
  if aim or shoot then
     -- DECOMPILER ERROR: unhandled construct in 'if'

    if expected_pos and l_28_1.attention_unit ~= expected_pos then
      CopLogicBase._set_attention_on_pos(l_28_0, mvector3.copy(expected_pos))
      l_28_1.attention_unit = mvector3.copy(expected_pos)
      do return end
       -- DECOMPILER ERROR: unhandled construct in 'if'

      if (focus_enemy.verified or focus_enemy.nearly_visible) and l_28_1.attention_unit ~= focus_enemy.u_key then
        CopLogicBase._set_attention(l_28_0, focus_enemy)
        l_28_1.attention_unit = focus_enemy.u_key
        do return end
        if not focus_enemy.last_verified_pos then
          local look_pos = focus_enemy.verified_pos
        end
        if l_28_1.attention_unit ~= look_pos then
          CopLogicBase._set_attention_on_pos(l_28_0, mvector3.copy(look_pos))
          l_28_1.attention_unit = mvector3.copy(look_pos)
        end
      end
    end
    if not l_28_1.shooting and not l_28_0.unit:anim_data().reload and not l_28_0.unit:movement():chk_action_forbidden("action") then
      local shoot_action = {type = "shoot", body_part = 3}
      if l_28_0.unit:brain():action_request(shoot_action) then
        l_28_1.shooting = true
      elseif l_28_1.shooting then
        local new_action = nil
        if l_28_0.unit:anim_data().reload then
          new_action = {type = "reload", body_part = 3}
        else
          new_action = {type = "idle", body_part = 3}
        end
        l_28_0.unit:brain():action_request(new_action)
      end
      if l_28_1.attention_unit then
        CopLogicBase._reset_attention(l_28_0)
        l_28_1.attention_unit = nil
      end
    end
  end
  CopLogicAttack.aim_allow_fire(shoot, aim, l_28_0, l_28_1)
end

CopLogicAttack.aim_allow_fire = function(l_29_0, l_29_1, l_29_2, l_29_3)
  local focus_enemy = l_29_2.attention_obj
  if l_29_0 and not l_29_3.firing then
    l_29_2.unit:movement():set_allow_fire(true)
    l_29_3.firing = true
    if not l_29_2.unit:in_slot(16) then
      managers.groupai:state():chk_say_enemy_chatter(l_29_2.unit, l_29_2.m_pos, "aggressive")
      do return end
      if l_29_3.firing then
        l_29_2.unit:movement():set_allow_fire(false)
        l_29_3.firing = nil
      end
    end
  end
end

CopLogicAttack.chk_should_turn = function(l_30_0, l_30_1)
  return (not l_30_1.turning and not l_30_0.unit:movement():chk_action_forbidden("walk") and not l_30_1.moving_to_cover and not l_30_1.walking_to_cover_shoot_pos and not l_30_1.surprised)
end

CopLogicAttack._get_cover_offset_pos = function(l_31_0, l_31_1, l_31_2)
  local threat_vec = l_31_2 - l_31_1[1][1]
  mvector3.set_z(threat_vec, 0)
  local threat_polar = threat_vec:to_polar_with_reference(l_31_1[1][2], math.UP)
  local threat_spin = threat_polar.spin
  local rot = nil
  if threat_spin < -20 then
    rot = Rotation(90)
  elseif threat_spin > 20 then
    rot = Rotation(-90)
  else
    rot = Rotation(180)
  end
  local offset_pos = mvector3.copy(l_31_1[1][2])
  mvector3.rotate_with(offset_pos, rot)
  mvector3.set_length(offset_pos, 25)
  mvector3.add(offset_pos, l_31_1[1][1])
  local ray_params = {tracker_from = l_31_1[1][3], pos_to = offset_pos, trace = true}
  managers.navigation:raycast(ray_params)
  return ray_params.trace[1]
end

CopLogicAttack._find_flank_pos = function(l_32_0, l_32_1, l_32_2, l_32_3)
  local pos = l_32_2:position()
  local vec_to_pos = pos - l_32_0.m_pos
  mvector3.set_z(vec_to_pos, 0)
  local max_dis = l_32_3 or 1500
  mvector3.set_length(vec_to_pos, max_dis)
  local accross_positions = managers.navigation:find_walls_accross_tracker(l_32_2, vec_to_pos, 160, 5)
  if accross_positions then
    local optimal_dis = max_dis
    local best_error_dis, best_pos, best_is_hit, best_is_miss, best_has_too_much_error = nil, nil, nil, nil, nil
    for _,accross_pos in ipairs(accross_positions) do
      local error_dis = math.abs(mvector3.distance(accross_pos[1], pos) - optimal_dis)
      local too_much_error = error_dis / optimal_dis > 0.20000000298023
      local is_hit = accross_pos[2]
      do
         -- DECOMPILER ERROR: unhandled construct in 'if'

        if best_is_hit and is_hit and error_dis < best_error_dis then
          local reservation = {position = accross_pos[1], radius = 30, filter = l_32_0.pos_rsrv_id}
          if managers.navigation:is_pos_free(reservation) then
            best_pos = accross_pos[1]
            best_error_dis = error_dis
            best_has_too_much_error = too_much_error
          end
          for (for control),_ in (for generator) do
            do
              if best_has_too_much_error then
                local reservation = {position = accross_pos[1], radius = 30, filter = l_32_0.pos_rsrv_id}
                if managers.navigation:is_pos_free(reservation) then
                  best_pos = accross_pos[1]
                  best_error_dis = error_dis
                  best_is_miss = true
                  best_is_hit = nil
                end
                for (for control),_ in (for generator) do
                  do
                    if best_is_miss and not too_much_error then
                      local reservation = {position = accross_pos[1], radius = 30, filter = l_32_0.pos_rsrv_id}
                      if managers.navigation:is_pos_free(reservation) then
                        best_pos = accross_pos[1]
                        best_error_dis = error_dis
                        best_has_too_much_error = nil
                        best_is_miss = nil
                        best_is_hit = true
                      end
                      for (for control),_ in (for generator) do
                        local reservation = {position = accross_pos[1], radius = 30, filter = l_32_0.pos_rsrv_id}
                        if managers.navigation:is_pos_free(reservation) then
                          best_pos = accross_pos[1]
                          best_is_hit = is_hit
                          best_is_miss = not is_hit
                          best_has_too_much_error = too_much_error
                          best_error_dis = error_dis
                        end
                      end
                    end
                  end
                end
              end
            end
          end
          return best_pos
        end
         -- Warning: missing end command somewhere! Added here
      end
       -- Warning: missing end command somewhere! Added here
    end
     -- Warning: missing end command somewhere! Added here
  end
end

CopLogicAttack.damage_clbk = function(l_33_0, l_33_1)
  CopLogicIdle.damage_clbk(l_33_0, l_33_1)
end

CopLogicAttack.is_available_for_assignment = function(l_34_0, l_34_1)
  local my_data = l_34_0.internal_data
  if my_data.exiting then
    return 
  end
  if l_34_1 and l_34_1.forced then
    return true
  end
  if l_34_0.unit:movement():chk_action_forbidden("walk") then
    return 
  end
  if l_34_0.path_fail_t and l_34_0.t < l_34_0.path_fail_t + 6 then
    return 
  end
  if l_34_0.is_suppressed then
    return 
  end
  local att_obj = l_34_0.attention_obj
  if not att_obj or att_obj.reaction < AIAttentionObject.REACT_AIM then
    return true
  end
  if not l_34_1 or l_34_1.type == "free" then
    return true
  end
  if l_34_1 then
    local allow_trans, obj_fail = CopLogicBase.is_obstructed(l_34_0, l_34_1, 0.20000000298023)
    if obj_fail then
      return 
    end
  end
  return true
end

CopLogicAttack._chk_wants_to_take_cover = function(l_35_0, l_35_1)
  if not l_35_0.attention_obj or l_35_0.attention_obj.reaction < AIAttentionObject.REACT_COMBAT then
    return 
  end
  if l_35_1.moving_to_cover or l_35_0.is_suppressed or l_35_1.attitude ~= "engage" or l_35_0.unit:anim_data().reload then
    return true
  end
  local ammo_max, ammo = l_35_0.unit:inventory():equipped_unit():base():ammo_info()
  if ammo / ammo_max < 0.20000000298023 then
    return true
  end
end

CopLogicAttack._set_best_cover = function(l_36_0, l_36_1, l_36_2)
  local best_cover = l_36_1.best_cover
  if best_cover then
    managers.navigation:release_cover(best_cover[1])
    CopLogicAttack._cancel_cover_pathing(l_36_0, l_36_1)
  end
  if l_36_2 then
    managers.navigation:reserve_cover(l_36_2[1], l_36_0.pos_rsrv_id)
    l_36_1.best_cover = l_36_2
    if not l_36_1.in_cover and not l_36_1.walking_to_cover_shoot_pos and not l_36_1.moving_to_cover and mvec3_dis_sq(l_36_2[1][1], l_36_0.m_pos) < 100 then
      l_36_1.in_cover = l_36_1.best_cover
      l_36_1.cover_enter_t = l_36_0.t
    else
      l_36_1.best_cover = nil
      l_36_1.flank_cover = nil
    end
     -- Warning: missing end command somewhere! Added here
  end
end

CopLogicAttack._set_nearest_cover = function(l_37_0, l_37_1)
  local nearest_cover = l_37_0.nearest_cover
  if nearest_cover then
    managers.navigation:release_cover(nearest_cover[1])
  end
  if l_37_1 then
    local pos_rsrv_id = l_37_0.unit:movement():pos_rsrv_id()
    managers.navigation:reserve_cover(l_37_1[1], pos_rsrv_id)
    l_37_0.nearest_cover = l_37_1
  else
    l_37_0.nearest_cover = nil
  end
end

CopLogicAttack._can_move = function(l_38_0)
  return (l_38_0.objective and l_38_0.objective.pos and not l_38_0.objective.in_place)
end

CopLogicAttack.on_new_objective = function(l_39_0, l_39_1)
  CopLogicIdle.on_new_objective(l_39_0, l_39_1)
end

CopLogicAttack.queue_update = function(l_40_0, l_40_1)
  CopLogicBase.queue_task(l_40_1, l_40_1.update_queue_id, l_40_0.logic.queued_update, l_40_0, l_40_0.t + (l_40_0.important and 0.5 or 2), true)
end

CopLogicAttack._get_expected_attention_position = function(l_41_0, l_41_1)
  local main_enemy = l_41_0.attention_obj
  local e_nav_tracker = main_enemy.nav_tracker
  if not e_nav_tracker then
    return 
  end
  local my_nav_seg = l_41_0.unit:movement():nav_tracker():nav_segment()
  local e_pos = main_enemy.m_pos
  local e_nav_seg = e_nav_tracker:nav_segment()
  if e_nav_seg == my_nav_seg then
    mvec3_set(temp_vec1, e_pos)
    mvec3_set_z(temp_vec1, temp_vec1.z + 140)
    return temp_vec1
  end
  local expected_path = l_41_1.expected_pos_path
  local from_nav_seg, to_nav_seg = nil, nil
  if expected_path then
    local i_from_seg = nil
    for i,k in ipairs(expected_path) do
      if k[1] == my_nav_seg then
        i_from_seg = i
    else
      end
    end
    if i_from_seg then
      local _find_aim_pos = function(l_1_0, l_1_1)
      local closest_dis = 1000000000
      local closest_door = nil
      local min_point_dis_sq = 10000
      local found_doors = managers.navigation:find_segment_doors(l_1_0, callback(CopLogicAttack, CopLogicAttack, "_chk_is_right_segment", l_1_1))
      for _,door in pairs(found_doors) do
        mvec3_set(temp_vec1, door.center)
        local dis = mvec3_dis_sq(e_pos, temp_vec1)
        if dis < closest_dis then
          closest_dis = dis
          closest_door = door
        end
      end
      if closest_door then
        mvec3_set(temp_vec1, closest_door.center)
        mvec3_sub(temp_vec1, data.m_pos)
        mvec3_set_z(temp_vec1, 0)
        if min_point_dis_sq < mvector3.length_sq(temp_vec1) then
          mvec3_set(temp_vec1, closest_door.center)
          mvec3_set_z(temp_vec1, temp_vec1.z + 140)
          return temp_vec1
        else
          return false, true
        end
      end
      end
      local i = #expected_path
      repeat
        if i > 0 then
          if expected_path[i][1] == e_nav_seg then
            to_nav_seg = expected_path[math.clamp(i, i_from_seg - 1, i_from_seg + 1)][1]
            local aim_pos, too_close = _find_aim_pos(my_nav_seg, to_nav_seg)
            if aim_pos then
              return aim_pos
            elseif too_close then
              local next_nav_seg = expected_path[math.clamp(i, i_from_seg - 2, i_from_seg + 2)][1]
              if next_nav_seg ~= to_nav_seg then
                local from_nav_seg = to_nav_seg
                to_nav_seg = next_nav_seg
                aim_pos = _find_aim_pos(from_nav_seg, to_nav_seg)
              end
              return aim_pos
            else
              i = i - 1
            end
        end
      end
      if not i_from_seg or not to_nav_seg then
        expected_path = nil
        l_41_1.expected_pos_path = nil
      end
    end
    if not expected_path and not l_41_1.expected_pos_path_search_id then
      l_41_1.expected_pos_path_search_id = "ExpectedPos" .. tostring(l_41_0.key)
      l_41_0.unit:brain():search_for_coarse_path(l_41_1.expected_pos_path_search_id, e_nav_seg)
    end
     -- Warning: missing end command somewhere! Added here
  end
end

CopLogicAttack._chk_is_right_segment = function(l_42_0, l_42_1, l_42_2)
  return l_42_1 == l_42_2
end

CopLogicAttack.is_advancing = function(l_43_0)
  if l_43_0.internal_data.moving_to_cover then
    return l_43_0.internal_data.moving_to_cover[1][1]
  end
  if l_43_0.internal_data.walking_to_cover_shoot_pos then
    return l_43_0.internal_data.walking_to_cover_shoot_pos._last_pos
  end
end

CopLogicAttack._get_all_paths = function(l_44_0)
  return {cover_path = l_44_0.internal_data.cover_path, flank_path = l_44_0.internal_data.flank_path}
end

CopLogicAttack._set_verified_paths = function(l_45_0, l_45_1)
  l_45_0.internal_data.cover_path = l_45_1.cover_path
  l_45_0.internal_data.flank_path = l_45_1.flank_path
end

CopLogicAttack._chk_exit_attack_logic = function(l_46_0, l_46_1)
  if not l_46_0.unit:movement():chk_action_forbidden("walk") then
    local wanted_state = CopLogicBase._get_logic_state_from_reaction(l_46_0, l_46_1)
    if wanted_state ~= l_46_0.name then
      local allow_trans, obj_failed = CopLogicBase.is_obstructed(l_46_0, l_46_0.objective, nil, nil)
      if allow_trans then
        if obj_failed then
          managers.groupai:state():on_objective_failed(l_46_0.unit, l_46_0.objective)
        elseif wanted_state ~= "idle" or not managers.groupai:state():on_cop_jobless(l_46_0.unit) then
          CopLogicBase._exit(l_46_0.unit, wanted_state)
        end
        CopLogicBase._report_detections(l_46_0.detected_attention_objects)
      end
    end
  end
end

CopLogicAttack.action_taken = function(l_47_0, l_47_1)
  if not l_47_1.turning and not l_47_1.moving_to_cover and not l_47_1.walking_to_cover_shoot_pos and not l_47_1.surprised then
    return l_47_0.unit:movement():chk_action_forbidden("walk")
  end
end


