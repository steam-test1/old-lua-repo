-- Decompiled using luadec 2.0.1 by sztupy (http://winmo.sztupy.hu)
-- Command line was: F:\SteamLibrary\SteamApps\common\PAYDAY 2\lua\lib\units\enemies\cop\logics\coplogictravel.luac 

local tmp_vec1 = Vector3()
local tmp_vec2 = Vector3()
CopLogicTravel = class(CopLogicBase)
CopLogicTravel.allowed_transitional_actions = {{"idle", "hurt", "dodge"}, {"idle", "turn"}, {"idle", "shoot", "reload"}, {"hurt", "stand", "crouch"}}
CopLogicTravel.allowed_transitional_actions_nav_link = {{"idle", "hurt", "dodge"}, {"idle", "turn", "walk"}, {"idle", "shoot", "reload"}, {"hurt", "stand", "crouch"}}
CopLogicTravel.damage_clbk = CopLogicIdle.damage_clbk
CopLogicTravel.death_clbk = CopLogicAttack.death_clbk
CopLogicTravel.on_detected_enemy_destroyed = CopLogicAttack.on_detected_enemy_destroyed
CopLogicTravel.on_criminal_neutralized = CopLogicAttack.on_criminal_neutralized
CopLogicTravel.on_alert = CopLogicIdle.on_alert
CopLogicTravel.on_new_objective = CopLogicIdle.on_new_objective
CopLogicTravel.enter = function(l_1_0, l_1_1, l_1_2)
  CopLogicBase.enter(l_1_0, l_1_1, l_1_2)
  l_1_0.unit:brain():cancel_all_pathing_searches()
  local old_internal_data = l_1_0.internal_data
  local my_data = {unit = l_1_0.unit}
  local is_cool = l_1_0.unit:movement():cool()
  if is_cool then
    my_data.detection = l_1_0.char_tweak.detection.ntl
  else
    my_data.detection = l_1_0.char_tweak.detection.recon
  end
  my_data.rsrv_pos = {}
  if old_internal_data then
    if not old_internal_data.rsrv_pos then
      my_data.rsrv_pos = my_data.rsrv_pos
    end
    if old_internal_data.nearest_cover then
      my_data.nearest_cover = old_internal_data.nearest_cover
      managers.navigation:reserve_cover(my_data.nearest_cover[1], l_1_0.pos_rsrv_id)
    end
    if old_internal_data.best_cover then
      my_data.best_cover = old_internal_data.best_cover
      managers.navigation:reserve_cover(my_data.best_cover[1], l_1_0.pos_rsrv_id)
    end
    my_data.attention_unit = old_internal_data.attention_unit
  end
  if l_1_0.char_tweak.announce_incomming then
    my_data.announce_t = l_1_0.t + 2
  end
  l_1_0.internal_data = my_data
  local key_str = tostring(l_1_0.unit:key())
  my_data.upd_task_key = "CopLogicTravel.queued_update" .. key_str
  CopLogicTravel.queue_update(l_1_0, my_data)
  my_data.cover_update_task_key = "CopLogicTravel._update_cover" .. key_str
  if my_data.nearest_cover or my_data.best_cover then
    CopLogicBase.add_delayed_clbk(my_data, my_data.cover_update_task_key, callback(CopLogicTravel, CopLogicTravel, "_update_cover", l_1_0), l_1_0.t + 1)
  end
  local allowed_actions = nil
  if l_1_0.unit:movement():chk_action_forbidden("walk") and l_1_0.unit:movement()._active_actions[2] then
    allowed_actions = CopLogicTravel.allowed_transitional_actions_nav_link
    my_data.wants_stop_old_walk_action = true
  else
    allowed_actions = CopLogicTravel.allowed_transitional_actions
  end
  CopLogicTravel.reset_actions(l_1_0, my_data, old_internal_data, allowed_actions)
  if l_1_0.char_tweak.no_stand and l_1_0.unit:anim_data().stand then
    CopLogicAttack._chk_request_action_crouch(l_1_0)
  end
  local objective = l_1_0.objective
   -- DECOMPILER ERROR: unhandled construct in 'if'

  if objective.pose and l_1_0.objective.pose == "crouch" and l_1_0.char_tweak.allow_crouch and not l_1_0.unit:anim_data().crouch and not l_1_0.unit:anim_data().crouching then
    CopLogicAttack._chk_request_action_crouch(l_1_0)
    do return end
    if not l_1_0.char_tweak.no_stand and not l_1_0.is_suppressed then
      CopLogicAttack._chk_request_action_stand(l_1_0)
    end
  end
  local path_data = objective.path_data
  if path_data then
    local path_style = objective.path_style
     -- DECOMPILER ERROR: No list found. Setlist fails

    if path_style == "precise" then
      local path = {}
       -- DECOMPILER ERROR: Overwrote pending register.

      for _,point in mvector3.copy(l_1_0.m_pos)(path_data.points) do
        table.insert(path, mvector3.copy(point.position))
      end
      my_data.advance_path = path
      my_data.coarse_path_index = 1
      local start_seg = l_1_0.unit:movement():nav_tracker():nav_segment()
      local end_pos = mvector3.copy(path[#path])
      local end_seg = managers.navigation:get_nav_seg_from_pos(end_pos)
      my_data.coarse_path = {{start_seg}, {end_seg, end_pos}}
      my_data.path_is_precise = true
    elseif path_style == "coarse" then
      local nav_manager = managers.navigation
      local f_get_nav_seg = nav_manager.get_nav_seg_from_pos
      local start_seg = l_1_0.unit:movement():nav_tracker():nav_segment()
      local path = {{start_seg}}
      for _,point in ipairs(path_data.points) do
        local pos = mvector3.copy(point.position)
        local nav_seg = f_get_nav_seg(nav_manager, pos)
        table.insert(path, {nav_seg, pos})
      end
      my_data.coarse_path = path
      my_data.coarse_path_index = CopLogicTravel.complete_coarse_path(l_1_0, my_data, path)
    elseif path_style == "coarse_complete" then
      my_data.coarse_path_index = 1
      my_data.coarse_path = deep_clone(objective.path_data)
      my_data.coarse_path_index = CopLogicTravel.complete_coarse_path(l_1_0, my_data, my_data.coarse_path)
    end
  end
  if objective.stance then
    local upper_body_action = l_1_0.unit:movement()._active_actions[3]
    if not upper_body_action or upper_body_action:type() ~= "shoot" then
      l_1_0.unit:movement():set_stance(objective.stance)
    end
  end
  if l_1_0.attention_obj and AIAttentionObject.REACT_AIM < l_1_0.attention_obj.reaction then
    l_1_0.unit:movement():set_cool(false, managers.groupai:state().analyse_giveaway(l_1_0.unit:base()._tweak_table, l_1_0.attention_obj.unit))
  end
  if is_cool then
    l_1_0.unit:brain():set_attention_settings({peaceful = true})
  else
    l_1_0.unit:brain():set_attention_settings({cbt = true})
  end
  my_data.weapon_range = l_1_0.char_tweak.weapon[l_1_0.unit:inventory():equipped_unit():base():weapon_tweak_data().usage].range
  l_1_0.unit:brain():set_update_enabled_state(false)
end

CopLogicTravel.reset_actions = function(l_2_0, l_2_1, l_2_2, l_2_3)
  local busy_body_parts = {false, false, false, false}
  local active_actions = {}
  for body_part = 1, 4 do
    local active_action = l_2_0.unit:movement()._active_actions[body_part]
    if active_action then
      local aa_type = active_action:type()
      for _,allowed_action in ipairs(l_2_3[body_part]) do
        if aa_type == allowed_action then
          busy_body_parts[body_part] = true
          table.insert(active_actions, aa_type)
      else
        end
      end
    end
    local shoot_interrupted = true
    for _,active_action in ipairs(active_actions) do
      if active_action == "shoot" then
        l_2_1.shooting = l_2_2.shooting
        l_2_1.firing = l_2_2.firing
        shoot_interrupted = false
        for (for control),_ in (for generator) do
        end
        if active_action == "turn" then
          l_2_1.turning = l_2_2.turning
        end
      end
      if shoot_interrupted then
        l_2_0.unit:movement():set_allow_fire(false)
        CopLogicBase._reset_attention(l_2_0)
        l_2_1.attention_unit = nil
      end
      do
        local idle_body_part = nil
        if busy_body_parts[1] or busy_body_parts[2] and busy_body_parts[3] then
          idle_body_part = 0
        elseif busy_body_parts[2] then
          idle_body_part = 3
        elseif busy_body_parts[3] then
          idle_body_part = 2
        else
          idle_body_part = 1
        end
        if idle_body_part > 0 then
          local new_action = {type = "idle", body_part = idle_body_part, sync = true}
          l_2_0.unit:brain():action_request(new_action)
        end
        return idle_body_part
      end
       -- Warning: missing end command somewhere! Added here
    end
     -- Warning: missing end command somewhere! Added here
  end
end

CopLogicTravel.exit = function(l_3_0, l_3_1, l_3_2)
  CopLogicBase.exit(l_3_0, l_3_1, l_3_2)
  local my_data = l_3_0.internal_data
  l_3_0.unit:brain():cancel_all_pathing_searches()
  CopLogicBase.cancel_queued_tasks(my_data)
  CopLogicBase.cancel_delayed_clbks(my_data)
  if my_data.moving_to_cover then
    managers.navigation:release_cover(my_data.moving_to_cover[1])
  end
  if my_data.nearest_cover then
    managers.navigation:release_cover(my_data.nearest_cover[1])
  end
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
  l_3_0.unit:brain():set_update_enabled_state(true)
end

CopLogicTravel.queued_update = function(l_4_0)
  local unit = l_4_0.unit
  local my_data = l_4_0.internal_data
  local objective = l_4_0.objective
  local t = TimerManager:game():time()
  l_4_0.t = t
  do
    local delay = CopLogicTravel._upd_enemy_detection(l_4_0)
    if l_4_0.internal_data ~= my_data then
      return 
    end
    if my_data.wants_stop_old_walk_action and not l_4_0.unit:movement():chk_action_forbidden("walk") then
      l_4_0.unit:movement():action_request({type = "idle", body_part = 2})
      my_data.wants_stop_old_walk_action = nil
      do return end
      if my_data.advancing and my_data.announce_t and my_data.announce_t < t then
        CopLogicTravel._try_anounce(l_4_0, my_data)
        do return end
        if not my_data.processing_advance_path and not my_data.processing_coarse_path and not my_data.cover_leave_t then
          if my_data.advance_path then
            do return end
          end
          if objective and (objective.nav_seg or objective.type == "follow") then
            if my_data.coarse_path then
              local coarse_path = my_data.coarse_path
              local cur_index = my_data.coarse_path_index
              local total_nav_points = #coarse_path
              if cur_index == total_nav_points then
                objective.in_place = true
                if (objective.type == "investigate_area" or objective.type == "free") and not objective.action_duration then
                  managers.groupai:state():on_objective_complete(unit, objective)
                  return 
                  do return end
                  if objective.type == "defend_area" then
                    if objective.grp_objective and objective.grp_objective.type == "retire" then
                      l_4_0.unit:brain():set_active(false)
                      l_4_0.unit:base():set_slot(l_4_0.unit, 0)
                      return 
                    else
                      managers.groupai:state():on_defend_travel_end(unit, objective)
                    end
                  end
                end
                CopLogicTravel.on_new_objective(l_4_0)
                return 
              else
                local start_pathing = CopLogicTravel.chk_group_ready_to_move(l_4_0, my_data)
                if start_pathing then
                  local to_pos = nil
                  if cur_index == total_nav_points - 1 then
                    local new_occupation = CopLogicTravel._determine_destination_occupation(l_4_0, objective)
                    if new_occupation then
                      if new_occupation.type == "guard" then
                        local guard_door = new_occupation.door
                        local guard_pos = CopLogicTravel._get_pos_accross_door(guard_door, objective.nav_seg)
                        if guard_pos then
                          local reservation = CopLogicTravel._reserve_pos_along_vec(guard_door.center, guard_pos)
                          if reservation then
                            if my_data.rsrv_pos.path then
                              managers.navigation:unreserve_pos(my_data.rsrv_pos.path)
                            end
                            my_data.rsrv_pos.path = reservation
                            local guard_object = {type = "door", door = guard_door, from_seg = new_occupation.from_seg}
                            objective.guard_obj = guard_object
                            to_pos = reservation.pos
                          elseif new_occupation.type == "defend" then
                            if new_occupation.cover then
                              to_pos = new_occupation.cover[1][1]
                              if l_4_0.char_tweak.wall_fwd_offset then
                                to_pos = CopLogicTravel.apply_wall_offset_to_cover(l_4_0, my_data, new_occupation.cover[1], l_4_0.char_tweak.wall_fwd_offset)
                              end
                              managers.navigation:reserve_cover(new_occupation.cover[1], l_4_0.pos_rsrv_id)
                              my_data.moving_to_cover = new_occupation.cover
                            elseif new_occupation.pos then
                              to_pos = new_occupation.pos
                              local reservation = {position = mvector3.copy(to_pos), radius = 60, filter = l_4_0.pos_rsrv_id}
                              managers.navigation:add_pos_reservation(reservation)
                              if my_data.rsrv_pos.path then
                                managers.navigation:unreserve_pos(reservation)
                              end
                              my_data.rsrv_pos.path = reservation
                            else
                              to_pos = new_occupation.pos
                              if to_pos then
                                local reservation = {position = mvector3.copy(to_pos), radius = 60, filter = l_4_0.pos_rsrv_id}
                                managers.navigation:add_pos_reservation(reservation)
                                if my_data.rsrv_pos.path then
                                  managers.navigation:unreserve_pos(my_data.rsrv_pos.path)
                                end
                                my_data.rsrv_pos.path = reservation
                              end
                            end
                          end
                        end
                      end
                    end
                    if not to_pos then
                      to_pos = managers.navigation:find_random_position_in_segment(objective.nav_seg)
                      to_pos = CopLogicTravel._get_pos_on_wall(to_pos)
                      local reservation = {position = mvector3.copy(to_pos), radius = 60, filter = l_4_0.pos_rsrv_id}
                      managers.navigation:add_pos_reservation(reservation)
                      if my_data.rsrv_pos.path then
                        managers.navigation:unreserve_pos(my_data.rsrv_pos.path)
                      end
                      my_data.rsrv_pos.path = reservation
                    else
                      local end_pos = coarse_path[cur_index + 1][2]
                      local cover = CopLogicTravel._find_cover(l_4_0, coarse_path[cur_index + 1][1])
                      if cover then
                        managers.navigation:reserve_cover(cover, l_4_0.pos_rsrv_id)
                        my_data.moving_to_cover = {cover}
                        to_pos = cover[1]
                      else
                        to_pos = managers.navigation:find_random_position_in_segment(coarse_path[cur_index + 1][1])
                        my_data.moving_to_cover = nil
                      end
                    end
                    my_data.advance_path_search_id = tostring(unit:key()) .. "advance"
                    my_data.processing_advance_path = true
                    local nav_segs = CopLogicTravel._get_allowed_travel_nav_segs(l_4_0, my_data, to_pos)
                    unit:brain():search_for_path(my_data.advance_path_search_id, to_pos, nil, nil, nav_segs)
                  else
                    local search_id = tostring(unit:key()) .. "coarse"
                    local verify_clbk = nil
                    if not my_data.coarse_search_failed then
                      verify_clbk = callback(CopLogicTravel, CopLogicTravel, "_investigate_coarse_path_verify_clbk")
                    end
                    local nav_seg = nil
                    if objective.follow_unit then
                      nav_seg = objective.follow_unit:movement():nav_tracker():nav_segment()
                    else
                      nav_seg = objective.nav_seg
                    end
                    if unit:brain():search_for_coarse_path(search_id, nav_seg, verify_clbk) then
                      my_data.coarse_path_search_id = search_id
                      my_data.processing_coarse_path = true
                    else
                      CopLogicBase._exit(l_4_0.unit, "idle")
                      return 
                    end
                  end
                end
              end
            end
          end
        end
        if my_data.processing_advance_path or my_data.processing_coarse_path then
          CopLogicTravel._upd_pathing(l_4_0, my_data)
          if l_4_0.internal_data ~= my_data then
            return 
          end
        end
        if my_data.advancing then
          do return end
        end
        if my_data.cover_leave_t and not my_data.turning and not unit:movement():chk_action_forbidden("walk") and not l_4_0.unit:anim_data().reload then
          if my_data.cover_leave_t < t then
            my_data.cover_leave_t = nil
          elseif l_4_0.attention_obj and AIAttentionObject.REACT_SCARED <= l_4_0.attention_obj.reaction and not CopLogicTravel._chk_request_action_turn_to_cover(l_4_0, my_data) and (not my_data.best_cover or not my_data.best_cover[4]) and not unit:anim_data().crouch and l_4_0.char_tweak.allow_crouch then
            CopLogicAttack._chk_request_action_crouch(l_4_0)
            do return end
            if my_data.advance_path and not l_4_0.unit:movement():chk_action_forbidden("walk") then
              local haste = nil
              if objective and objective.haste then
                haste = objective.haste
              else
                if l_4_0.unit:movement():cool() then
                  haste = "walk"
                else
                  haste = "run"
                end
              end
              local pose = nil
              if not l_4_0.char_tweak.crouch_move then
                pose = "stand"
              else
                if l_4_0.char_tweak.no_stand then
                  pose = "crouch"
                elseif (not l_4_0.is_suppressed or not "crouch") and (not objective or not objective.pose) then
                   -- DECOMPILER ERROR: Attempted to build a boolean expression without a pending context

                  pose = "stand"
                end
              end
              if not unit:anim_data()[pose] then
                CopLogicAttack._chk_request_action_" .. pos(l_4_0)
              end
              local end_rot = nil
              if my_data.coarse_path_index == #my_data.coarse_path - 1 and objective then
                end_rot = objective.rot
              end
              local no_strafe = nil
              CopLogicTravel._chk_request_action_walk_to_advance_pos(l_4_0, my_data, haste, end_rot, no_strafe)
            end
          end
        end
        CopLogicTravel.queue_update(l_4_0, my_data, delay)
      end
       -- Warning: missing end command somewhere! Added here
    end
     -- Warning: missing end command somewhere! Added here
  end
end

CopLogicTravel._upd_enemy_detection = function(l_5_0)
  managers.groupai:state():on_unit_detection_updated(l_5_0.unit)
  local my_data = l_5_0.internal_data
  local delay = CopLogicBase._upd_attention_obj_detection(l_5_0, nil, nil)
  local new_attention, new_prio_slot, new_reaction = CopLogicIdle._get_priority_attention(l_5_0, l_5_0.detected_attention_objects, nil)
  local old_att_obj = l_5_0.attention_obj
  CopLogicBase._set_attention_obj(l_5_0, new_attention, new_reaction)
  local objective = l_5_0.objective
  local allow_trans, obj_failed = CopLogicBase.is_obstructed(l_5_0, objective, nil, new_attention)
  if allow_trans and (obj_failed or not objective or objective.type ~= "follow") then
    local wanted_state = CopLogicBase._get_logic_state_from_reaction(l_5_0)
    if wanted_state and wanted_state ~= l_5_0.name then
      if obj_failed then
        managers.groupai:state():on_objective_failed(l_5_0.unit, l_5_0.objective)
      end
      if my_data == l_5_0.internal_data and not objective.is_default then
        debug_pause_unit(l_5_0.unit, "[CopLogicTravel._upd_enemy_detection] exiting without discarding objective", l_5_0.unit, inspect(objective))
        CopLogicBase._exit(l_5_0.unit, wanted_state)
      end
      CopLogicBase._report_detections(l_5_0.detected_attention_objects)
      return 
    end
  end
  if my_data == l_5_0.internal_data then
    if new_reaction == AIAttentionObject.REACT_SUSPICIOUS and CopLogicBase._upd_suspicion(l_5_0, my_data, new_attention) then
      CopLogicBase._report_detections(l_5_0.detected_attention_objects)
      return 
    elseif new_reaction and new_reaction <= AIAttentionObject.REACT_SCARED then
      local set_attention = l_5_0.unit:movement():attention()
      if not set_attention or set_attention.u_key ~= new_attention.u_key then
        CopLogicBase._set_attention(l_5_0, new_attention, nil)
      end
    end
    CopLogicAttack._upd_aim(l_5_0, my_data)
  end
  CopLogicBase._report_detections(l_5_0.detected_attention_objects)
  if new_attention and l_5_0.char_tweak.chatter.entrance and not l_5_0.entrance and new_attention.criminal_record and new_attention.verified and AIAttentionObject.REACT_SCARED <= new_reaction and math.abs(l_5_0.m_pos.z - new_attention.m_pos.z) < 4000 then
    l_5_0.unit:sound():say("entrance", true, nil)
    l_5_0.entrance = true
  end
  return delay
end

CopLogicTravel._upd_pathing = function(l_6_0, l_6_1)
  if l_6_0.pathing_results then
    local pathing_results = l_6_0.pathing_results
    l_6_0.pathing_results = nil
    local path = pathing_results[l_6_1.advance_path_search_id]
    if path then
      l_6_1.processing_advance_path = nil
      l_6_1.advance_path_search_id = nil
      if path ~= "failed" then
        l_6_1.advance_path = path
      else
        print("[CopLogicTravel:_upd_pathing] advance_path failed", l_6_0.unit, l_6_1.coarse_path_index, inspect(l_6_1.coarse_path))
        managers.groupai:state():on_objective_failed(l_6_0.unit, l_6_0.objective)
        return 
      end
    end
    path = pathing_results[l_6_1.coarse_path_search_id]
    if path then
      l_6_1.processing_coarse_path = nil
      l_6_1.coarse_path_search_id = nil
      if path ~= "failed" then
        l_6_1.coarse_path = path
        l_6_1.coarse_path_index = 1
      elseif l_6_1.coarse_search_failed then
        print("[CopLogicTravel:_upd_pathing] coarse_path failed unsafe", l_6_0.unit, l_6_1.coarse_path_index, inspect(l_6_1.coarse_path))
        l_6_0.path_fail_t = l_6_0.t
        managers.groupai:state():on_objective_failed(l_6_0.unit, l_6_0.objective)
        return 
      else
        l_6_1.coarse_search_failed = true
      end
    end
  end
end

CopLogicTravel._update_cover = function(l_7_0, l_7_1)
  local my_data = l_7_1.internal_data
  CopLogicBase.on_delayed_clbk(my_data, my_data.cover_update_task_key)
  local cover_release_dis = 100
  local nearest_cover = my_data.nearest_cover
  local best_cover = my_data.best_cover
  local m_pos = l_7_1.m_pos
  if not my_data.in_cover and nearest_cover and cover_release_dis < mvector3.distance(nearest_cover[1][1], m_pos) then
    managers.navigation:release_cover(nearest_cover[1])
    my_data.nearest_cover = nil
    nearest_cover = nil
  end
  if best_cover and cover_release_dis < mvector3.distance(best_cover[1][1], m_pos) then
    managers.navigation:release_cover(best_cover[1])
    my_data.best_cover = nil
    best_cover = nil
  end
  if nearest_cover or best_cover then
    CopLogicBase.add_delayed_clbk(my_data, my_data.cover_update_task_key, callback(CopLogicTravel, CopLogicTravel, "_update_cover", l_7_1), l_7_1.t + 1)
  end
end

CopLogicTravel._chk_request_action_turn_to_cover = function(l_8_0, l_8_1)
  local fwd = l_8_0.unit:movement():m_rot():y()
  mvector3.set(tmp_vec1, l_8_1.best_cover[1][2])
  mvector3.negate(tmp_vec1)
  local error_spin = tmp_vec1:to_polar_with_reference(fwd, math.UP).spin
  if math.abs(error_spin) > 25 then
    local new_action_data = {}
    new_action_data.type = "turn"
    new_action_data.body_part = 2
    new_action_data.angle = error_spin
    if l_8_0.unit:brain():action_request(new_action_data) then
      l_8_1.turning = new_action_data.angle
      return true
    end
  end
end

CopLogicTravel._chk_cover_height = function(l_9_0, l_9_1, l_9_2)
  local ray_from = tmp_vec1
  mvector3.set(ray_from, math.UP)
  mvector3.multiply(ray_from, 110)
  mvector3.add(ray_from, l_9_1[1])
  local ray_to = tmp_vec2
  mvector3.set(ray_to, l_9_1[2])
  mvector3.multiply(ray_to, 200)
  mvector3.add(ray_to, ray_from)
  local ray = World:raycast("ray", ray_from, ray_to, "slot_mask", l_9_2, "ray_type", "ai_vision", "report")
  return ray
end

CopLogicTravel.action_complete_clbk = function(l_10_0, l_10_1)
  local my_data = l_10_0.internal_data
  local action_type = l_10_1:type()
  if action_type == "walk" then
    my_data.advancing = nil
    my_data.rsrv_pos.stand = my_data.rsrv_pos.move_dest
    my_data.rsrv_pos.move_dest = nil
    if l_10_1:expired() and not my_data.starting_advance_action and my_data.coarse_path_index then
      my_data.coarse_path_index = my_data.coarse_path_index + 1
    end
    if my_data.moving_to_cover then
      if l_10_1:expired() then
        if my_data.best_cover then
          managers.navigation:release_cover(my_data.best_cover[1])
        end
        my_data.best_cover = my_data.moving_to_cover
        CopLogicBase.chk_cancel_delayed_clbk(my_data, my_data.cover_update_task_key)
        local high_ray = CopLogicTravel._chk_cover_height(l_10_0, my_data.best_cover[1], l_10_0.visibility_slotmask)
        my_data.best_cover[4] = high_ray
        my_data.in_cover = true
        if not my_data.cover_wait_t then
          local cover_wait_t = {0.69999998807907, 0.80000001192093}
        end
        my_data.cover_leave_t = l_10_0.t + cover_wait_t[1] + cover_wait_t[2] * math.random()
      else
        managers.navigation:release_cover(my_data.moving_to_cover[1])
        if my_data.best_cover then
          local dis = mvector3.distance(my_data.best_cover[1][1], l_10_0.unit:movement():m_pos())
          if dis > 100 then
            managers.navigation:release_cover(my_data.best_cover[1])
            my_data.best_cover = nil
          end
        end
      end
      my_data.moving_to_cover = nil
    elseif my_data.best_cover then
      local dis = mvector3.distance(my_data.best_cover[1][1], l_10_0.unit:movement():m_pos())
      if dis > 100 then
        managers.navigation:release_cover(my_data.best_cover[1])
        my_data.best_cover = nil
      elseif action_type == "turn" then
        l_10_0.internal_data.turning = nil
      elseif action_type == "shoot" then
        l_10_0.internal_data.shooting = nil
      elseif action_type == "dodge" then
        local objective = l_10_0.objective
        local allow_trans, obj_failed = CopLogicBase.is_obstructed(l_10_0, objective, nil, nil)
        if allow_trans then
          local wanted_state = l_10_0.logic._get_logic_state_from_reaction(l_10_0)
          if wanted_state and wanted_state ~= l_10_0.name and obj_failed then
            if l_10_0.unit:in_slot(managers.slot:get_mask("enemies")) or l_10_0.unit:in_slot(17) then
              managers.groupai:state():on_objective_failed(l_10_0.unit, l_10_0.objective)
            else
              if l_10_0.unit:in_slot(managers.slot:get_mask("criminals")) then
                managers.groupai:state():on_criminal_objective_failed(l_10_0.unit, l_10_0.objective, false)
              end
            end
            if my_data == l_10_0.internal_data then
              debug_pause_unit(l_10_0.unit, "[CopLogicTravel.action_complete_clbk] exiting without discarding objective", l_10_0.unit, inspect(l_10_0.objective))
              CopLogicBase._exit(l_10_0.unit, wanted_state)
            end
          end
        end
      end
    end
  end
end

CopLogicTravel._get_pos_accross_door = function(l_11_0, l_11_1)
  local rooms = l_11_0.rooms
  local room_1_seg = l_11_0.low_seg
  local accross_vec = l_11_0.high_pos - l_11_0.low_pos
  local rot_angle = 90
   -- DECOMPILER ERROR: unhandled construct in 'if'

  if room_1_seg == l_11_1 and l_11_0.low_pos.y == l_11_0.high_pos.y then
    rot_angle = rot_angle * -1
    do return end
    if l_11_0.low_pos.x == l_11_0.high_pos.x then
      rot_angle = rot_angle * -1
    end
  end
  mvector3.rotate_with(accross_vec, Rotation(rot_angle))
  local max_dis = 1500
  mvector3.set_length(accross_vec, 1500)
  local door_pos = l_11_0.center
  local door_tracker = managers.navigation:create_nav_tracker(mvector3.copy(door_pos))
  do
    local accross_positions = managers.navigation:find_walls_accross_tracker(door_tracker, accross_vec)
    if accross_positions then
      local optimal_dis = (math.lerp(max_dis * 0.60000002384186, max_dis, math.random()))
      local best_error_dis, best_pos, best_is_hit, best_is_miss, best_has_too_much_error = nil, nil, nil, nil, nil
      for _,accross_pos in ipairs(accross_positions) do
        local error_dis = math.abs(mvector3.distance(accross_pos[1], door_pos) - optimal_dis)
        local too_much_error = error_dis / optimal_dis > 0.30000001192093
        local is_hit = accross_pos[2]
         -- DECOMPILER ERROR: unhandled construct in 'if'

        if best_is_hit and is_hit and error_dis < best_error_dis then
          best_pos = accross_pos[1]
          best_error_dis = error_dis
          best_has_too_much_error = too_much_error
          for (for control),_ in (for generator) do
            if best_has_too_much_error then
              best_pos = accross_pos[1]
              best_error_dis = error_dis
              best_is_miss = true
              best_is_hit = nil
              for (for control),_ in (for generator) do
                if best_is_miss and not too_much_error then
                  best_pos = accross_pos[1]
                  best_error_dis = error_dis
                  best_has_too_much_error = nil
                  best_is_miss = nil
                  best_is_hit = true
                  for (for control),_ in (for generator) do
                    best_pos = accross_pos[1]
                    best_is_hit = is_hit
                    best_is_miss = not is_hit
                    best_has_too_much_error = too_much_error
                    best_error_dis = error_dis
                  end
                end
              end
            end
            managers.navigation:destroy_nav_tracker(door_tracker)
            return best_pos
          end
          managers.navigation:destroy_nav_tracker(door_tracker)
        end
         -- Warning: missing end command somewhere! Added here
      end
       -- Warning: missing end command somewhere! Added here
    end
     -- Warning: missing end command somewhere! Added here
  end
end

CopLogicTravel.is_available_for_assignment = function(l_12_0, l_12_1)
  if l_12_1 and l_12_1.forced then
    return true
  elseif l_12_0.objective and l_12_0.objective.type == "act" then
    return 
  else
    return CopLogicAttack.is_available_for_assignment(l_12_0, l_12_1)
  end
end

CopLogicTravel.is_advancing = function(l_13_0)
  if l_13_0.internal_data.advancing then
    return l_13_0.internal_data.rsrv_pos.move_dest.position
  end
end

CopLogicTravel._reserve_pos_along_vec = function(l_14_0, l_14_1)
  local step_vec = l_14_0 - l_14_1
  local max_pos_mul = math.floor(mvector3.length(step_vec) / 65)
  mvector3.set_length(step_vec, 65)
  local data = {start_pos = l_14_1, step_vec = step_vec, step_mul = max_pos_mul > 0 and 1 or -1, block = max_pos_mul == 0, max_pos_mul = max_pos_mul}
  local step_clbk = callback(CopLogicTravel, CopLogicTravel, "_rsrv_pos_along_vec_step_clbk", data)
  local res_data = managers.navigation:reserve_pos(nil, nil, l_14_1, step_clbk, 40, data.pos_rsrv_id)
  return res_data
end

CopLogicTravel._rsrv_pos_along_vec_step_clbk = function(l_15_0, l_15_1, l_15_2)
  local step_mul = l_15_1.step_mul
  local nav_manager = managers.navigation
  local step_vec = l_15_1.step_vec
  mvector3.set(l_15_2, step_vec)
  mvector3.multiply(l_15_2, step_mul)
  mvector3.add(l_15_2, l_15_1.start_pos)
  local params = {pos_from = l_15_1.start_pos, pos_to = l_15_2, allow_entry = false}
  local blocked = nav_manager:raycast(params)
  if blocked then
    if l_15_1.block then
      return false
    end
    l_15_1.block = true
    if step_mul > 0 then
      l_15_1.step_mul = -step_mul
    else
      l_15_1.step_mul = -step_mul + 1
      if l_15_1.max_pos_mul < l_15_1.step_mul then
        return 
      end
    end
    return CopLogicTravel._rsrv_pos_along_vec_step_clbk(l_15_0, l_15_1, l_15_2)
  elseif l_15_1.block then
    l_15_1.step_mul = step_mul + math.sign(step_mul)
    if l_15_1.max_pos_mul < l_15_1.step_mul then
      return 
    elseif step_mul > 0 then
      l_15_1.step_mul = -step_mul
    else
      l_15_1.step_mul = -step_mul + 1
      if l_15_1.max_pos_mul < l_15_1.step_mul then
        l_15_1.block = true
        l_15_1.step_mul = -l_15_1.step_mul
      end
    end
  end
  return true
end

CopLogicTravel._investigate_coarse_path_verify_clbk = function(l_16_0, l_16_1)
  return managers.groupai:state():is_nav_seg_safe(l_16_1)
end

CopLogicTravel.on_intimidated = function(l_17_0, l_17_1, l_17_2)
  local surrender = CopLogicIdle.on_intimidated(l_17_0, l_17_1, l_17_2)
  if surrender and l_17_0.objective then
    managers.groupai:state():on_objective_failed(l_17_0.unit, l_17_0.objective)
  end
end

CopLogicTravel._chk_request_action_walk_to_advance_pos = function(l_18_0, l_18_1, l_18_2, l_18_3, l_18_4)
  if not l_18_0.unit:movement():chk_action_forbidden("walk") or l_18_0.unit:anim_data().act_idle then
    CopLogicAttack._correct_path_start_pos(l_18_0, l_18_1.advance_path)
    local path = l_18_1.advance_path
    local new_action_data = {type = "walk", nav_path = path, variant = l_18_2 or "run", body_part = 2, end_rot = l_18_3, path_simplified = l_18_1.path_is_precise, no_strafe = l_18_4}
    l_18_1.advance_path = nil
    l_18_1.starting_advance_action = true
    l_18_1.advancing = l_18_0.unit:brain():action_request(new_action_data)
    l_18_1.starting_advance_action = false
    if l_18_1.advancing then
      if l_18_1.rsrv_pos.path then
        l_18_1.rsrv_pos.move_dest = l_18_1.rsrv_pos.path
        l_18_1.rsrv_pos.path = nil
      else
        local end_pos = mvector3.copy(path[#path])
        local rsrv_desc = {filter = l_18_0.pos_rsrv_id, position = end_pos, radius = 30}
        managers.navigation:add_pos_reservation(rsrv_desc)
        l_18_1.rsrv_pos.move_dest = rsrv_desc
      end
      if l_18_1.rsrv_pos.stand then
        managers.navigation:unreserve_pos(l_18_1.rsrv_pos.stand)
        l_18_1.rsrv_pos.stand = nil
      end
      if l_18_1.nearest_cover and (not l_18_1.delayed_clbks or not l_18_1.delayed_clbks[l_18_1.cover_update_task_key]) then
        CopLogicBase.add_delayed_clbk(l_18_1, l_18_1.cover_update_task_key, callback(CopLogicTravel, CopLogicTravel, "_update_cover", l_18_0), l_18_0.t + 1)
      end
    end
  end
end

CopLogicTravel._determine_destination_occupation = function(l_19_0, l_19_1)
  local occupation = nil
  if l_19_1.type == "investigate_area" then
    if l_19_1.guard_obj then
      if not managers.groupai:state():verify_occupation_in_area(l_19_1) then
        occupation = l_19_1.guard_obj
      end
      occupation.type = "guard"
    else
      occupation = managers.groupai:state():find_occupation_in_area(l_19_1.nav_seg)
    end
  elseif l_19_1.type == "defend_area" then
    if l_19_1.cover then
      occupation = {type = "defend", seg = l_19_1.nav_seg, cover = l_19_1.cover, radius = l_19_1.radius}
    elseif l_19_1.pos then
      occupation = {type = "defend", seg = l_19_1.nav_seg, pos = l_19_1.pos, radius = l_19_1.radius}
    elseif l_19_1.follow_unit then
      local near_pos = l_19_1.follow_unit:movement():nav_tracker():field_position()
    end
    local cover = CopLogicTravel._find_cover(l_19_0, l_19_1.nav_seg, near_pos)
    if cover then
      local cover_entry = {cover}
      occupation = {type = "defend", seg = l_19_1.nav_seg, cover = cover_entry, radius = l_19_1.radius}
    else
      near_pos = CopLogicTravel._get_pos_on_wall(managers.navigation._nav_segments[l_19_1.nav_seg].pos, 700)
      occupation = {type = "defend", seg = l_19_1.nav_seg, pos = near_pos, radius = l_19_1.radius}
    end
  elseif l_19_1.type == "act" then
    occupation = {type = "act", seg = l_19_1.nav_seg, pos = l_19_1.pos}
  elseif l_19_1.type == "follow" then
    local follow_pos, follow_nav_seg = nil, nil
    if l_19_1.follow_unit:brain() then
      local follow_unit_objective = l_19_1.follow_unit:brain():objective()
    end
    if not follow_unit_objective or follow_unit_objective.in_place or not follow_unit_objective.nav_seg then
      follow_pos = l_19_1.follow_unit:movement():m_pos()
      follow_nav_seg = l_19_1.follow_unit:movement():nav_tracker():nav_segment()
    elseif not follow_unit_objective.pos then
      follow_pos = l_19_1.follow_unit:movement():m_pos()
    end
    follow_nav_seg = follow_unit_objective.nav_seg
    local distance = l_19_1.distance and math.lerp(l_19_1.distance * 0.5, l_19_1.distance, math.random()) or 700
    local to_pos = CopLogicTravel._get_pos_on_wall(follow_pos, distance)
    occupation = {type = "defend", nav_seg = follow_nav_seg, pos = to_pos}
  else
    occupation = {seg = l_19_1.nav_seg, pos = l_19_1.pos}
  end
end
return occupation
end

CopLogicTravel._get_pos_on_wall = function(l_20_0, l_20_1, l_20_2, l_20_3)
  local nav_manager = managers.navigation
  local nr_rays = 7
  local ray_dis = l_20_1 or 1000
  local step = 360 / nr_rays
  if not l_20_2 then
    local offset = math.random(360)
  end
  local step_rot = Rotation(step)
  local offset_rot = Rotation(offset)
  local offset_vec = Vector3(ray_dis, 0, 0)
  mvector3.rotate_with(offset_vec, offset_rot)
  local to_pos = mvector3.copy(l_20_0)
  mvector3.add(to_pos, offset_vec)
  local from_tracker = nav_manager:create_nav_tracker(l_20_0)
  local ray_params = {tracker_from = from_tracker, allow_entry = false, pos_to = to_pos, trace = true}
  local rsrv_desc = {false, 60}
  local fail_position = nil
  repeat
    to_pos = mvector3.copy(l_20_0)
    mvector3.add(to_pos, offset_vec)
    ray_params.pos_to = to_pos
    do
      local ray_res = nav_manager:raycast(ray_params)
      if ray_res then
        rsrv_desc.position = ray_params.trace[1]
        local is_free = nav_manager:is_pos_free(rsrv_desc)
        if is_free then
          managers.navigation:destroy_nav_tracker(from_tracker)
          return ray_params.trace[1]
          do return end
        elseif not fail_position then
          rsrv_desc.position = ray_params.trace[1]
          local is_free = nav_manager:is_pos_free(rsrv_desc)
          if is_free then
            fail_position = to_pos
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
  if not l_20_3 then
    return CopLogicTravel._get_pos_on_wall(l_20_0, ray_dis * 0.5, offset + step * 0.5, true)
  end
  return l_20_0
end

CopLogicTravel.queue_update = function(l_21_0, l_21_1, l_21_2)
  if l_21_0.important then
    l_21_2 = 0
  elseif not l_21_2 then
    l_21_2 = 0.30000001192093
  end
  CopLogicBase.queue_task(l_21_1, l_21_1.upd_task_key, CopLogicTravel.queued_update, l_21_0, l_21_0.t + l_21_2, not l_21_0.important or true)
end

CopLogicTravel._try_anounce = function(l_22_0, l_22_1)
  local my_pos = l_22_0.m_pos
  local max_dis_sq = 250000
  local my_key = l_22_0.key
  local announce_type = l_22_0.char_tweak.announce_incomming
  for u_key,u_data in pairs(managers.enemy:all_enemies()) do
    if u_key ~= my_key and tweak_data.character[u_data.unit:base()._tweak_table].chatter[announce_type] and mvector3.distance_sq(my_pos, u_data.m_pos) < max_dis_sq and not u_data.unit:sound():speaking(l_22_0.t) and (u_data.unit:anim_data().idle or u_data.unit:anim_data().move) then
      managers.groupai:state():chk_say_enemy_chatter(u_data.unit, u_data.m_pos, announce_type)
      l_22_1.announce_t = l_22_0.t + 15
  else
    end
  end
end

CopLogicTravel._get_all_paths = function(l_23_0)
  return {advance_path = l_23_0.internal_data.advance_path}
end

CopLogicTravel._set_verified_paths = function(l_24_0, l_24_1)
  l_24_0.internal_data.advance_path = l_24_1.advance_path
end

CopLogicTravel.chk_should_turn = function(l_25_0, l_25_1)
  return (not l_25_1.advancing and not l_25_1.turning and not l_25_0.unit:movement():chk_action_forbidden("walk"))
end

CopLogicTravel.complete_coarse_path = function(l_26_0, l_26_1, l_26_2)
  local first_seg_id = l_26_2[1][1]
  local current_seg_id = l_26_0.unit:movement():nav_tracker():nav_segment()
  local all_nav_segs = managers.navigation._nav_segments
  local i_nav_point = 1
  repeat
    if i_nav_point < #l_26_2 then
      local nav_seg_id = l_26_2[i_nav_point][1]
      local next_nav_seg_id = l_26_2[i_nav_point + 1][1]
      local nav_seg = all_nav_segs[nav_seg_id]
      if not nav_seg.neighbours[next_nav_seg_id] then
        local search_params = {from_seg = nav_seg_id, to_seg = next_nav_seg_id, id = "CopLogicTravel_complete_coarse_path", access_pos = "cop"}
        local ins_coarse_path = managers.navigation:search_coarse(search_params)
        if not ins_coarse_path then
          l_26_1.coarse_path = nil
          return 
        end
        local i_insert = #ins_coarse_path - 1
        repeat
          if i_insert > 1 then
            table.insert(l_26_2, i_nav_point + 1, ins_coarse_path[i_insert])
            i_insert = i_insert - 1
        end
        i_nav_point = i_nav_point + 1
      else
        local start_index = nil
        for i,nav_point in ipairs(l_26_2) do
          if current_seg_id == nav_point[1] then
            start_index = i
          end
        end
        if start_index then
          start_index = math.min(start_index, #l_26_2 - 1)
          return start_index
        end
        local to_search_segs = {current_seg_id}
        do
          local found_segs = {current_seg_id = "init"}
          repeat
            local search_seg_id = table.remove(to_search_segs, 1)
            do
              local search_seg = all_nav_segs[search_seg_id]
              for other_seg_id,door_list in pairs(search_seg.neighbours) do
                local other_seg = all_nav_segs[other_seg_id]
                if not other_seg.disabled and not found_segs[other_seg_id] then
                  found_segs[other_seg_id] = search_seg_id
                  do
                    if other_seg_id == first_seg_id then
                      local last_added_seg_id = other_seg_id
                      repeat
                        if found_segs[last_added_seg_id] ~= "init" then
                          last_added_seg_id = found_segs[last_added_seg_id]
                          table.insert(l_26_2, 1, {last_added_seg_id, all_nav_segs[last_added_seg_id].pos})
                        else
                          return 1
                        end
                        for (for control),other_seg_id in (for generator) do
                        end
                        table.insert(to_search_segs, other_seg_id)
                      end
                    end
                  until #to_search_segs == 0
                end
                return 1
              end
               -- Warning: missing end command somewhere! Added here
            end
             -- Warning: missing end command somewhere! Added here
          end
           -- Warning: missing end command somewhere! Added here
        end
         -- Warning: missing end command somewhere! Added here
      end
       -- Warning: missing end command somewhere! Added here
    end
     -- Warning: missing end command somewhere! Added here
  end
end

CopLogicTravel.chk_group_ready_to_move = function(l_27_0, l_27_1)
  local my_objective = l_27_0.objective
  if not my_objective.grp_objective then
    return true
  end
  local my_dis = mvector3.distance_sq(my_objective.area.pos, l_27_0.m_pos)
  if my_dis > 4000000 then
    return true
  end
  my_dis = my_dis * 1.1499999761581 * 1.1499999761581
  for u_key,u_data in pairs(l_27_0.group.units) do
    if u_key ~= l_27_0.key then
      local his_objective = u_data.unit:brain():objective()
      if his_objective and his_objective.grp_objective == my_objective.grp_objective and not his_objective.in_place then
        local his_dis = mvector3.distance_sq(his_objective.area.pos, u_data.m_pos)
        if my_dis < his_dis then
          return false
        end
      end
    end
  end
  return true
end

CopLogicTravel.apply_wall_offset_to_cover = function(l_28_0, l_28_1, l_28_2, l_28_3)
  local to_pos_fwd = tmp_vec1
  mvector3.set(to_pos_fwd, l_28_2[2])
  mvector3.multiply(to_pos_fwd, l_28_3)
  mvector3.add(to_pos_fwd, l_28_2[1])
  local ray_params = {tracker_from = l_28_2[3], pos_to = to_pos_fwd, trace = true}
  local collision = managers.navigation:raycast(ray_params)
  if not collision then
    return l_28_2[1]
  end
  local col_pos_fwd = ray_params.trace[1]
  local space_needed = mvector3.distance(col_pos_fwd, to_pos_fwd) + l_28_3 * 1.0499999523163
  local to_pos_bwd = tmp_vec2
  mvector3.set(to_pos_bwd, l_28_2[2])
  mvector3.multiply(to_pos_bwd, -space_needed)
  mvector3.add(to_pos_bwd, l_28_2[1])
  local ray_params = {tracker_from = l_28_2[3], pos_to = to_pos_bwd, trace = true}
  local collision = managers.navigation:raycast(ray_params)
  if not collision or not ray_params.trace[1] then
    return mvector3.copy(to_pos_bwd)
  end
end

CopLogicTravel._find_cover = function(l_29_0, l_29_1, l_29_2)
  local cover = nil
  do
    local search_area = managers.groupai:state():get_area_from_nav_seg_id(l_29_1)
    if l_29_0.unit:movement():cool() then
      cover = managers.navigation:find_cover_in_nav_seg_1(managers.navigation, search_area.nav_segs)
    else
      local optimal_threat_dis, threat_pos = nil, nil
      if l_29_0.objective.attitude == "engage" then
        optimal_threat_dis = l_29_0.internal_data.weapon_range.optimal
      else
        optimal_threat_dis = l_29_0.internal_data.weapon_range.far
      end
      if not l_29_2 then
        l_29_2 = search_area.pos
      end
      local all_criminals = (managers.groupai:state():all_char_criminals())
      local closest_crim_u_data, closest_crim_dis = nil, nil
      for u_key,u_data in pairs(all_criminals) do
        local crim_area = managers.groupai:state():get_area_from_nav_seg_id(u_data.tracker:nav_segment())
        if crim_area == search_area then
          threat_pos = u_data.m_pos
          do return end
          for (for control),u_key in (for generator) do
          end
          local crim_dis = mvector3.distance_sq(l_29_2, u_data.m_pos)
          if not closest_crim_dis or crim_dis < closest_crim_dis then
            threat_pos = u_data.m_pos
            closest_crim_dis = crim_dis
          end
        end
        cover = managers.navigation:find_cover_from_threat(search_area.nav_segs, optimal_threat_dis, l_29_2, threat_pos)
      end
      return cover
    end
     -- Warning: missing end command somewhere! Added here
  end
end

CopLogicTravel._get_allowed_travel_nav_segs = function(l_30_0, l_30_1, l_30_2)
  local nav_segs = {}
  local added_segs = {}
  for _,nav_point in ipairs(l_30_1.coarse_path) do
    local area = managers.groupai:state():get_area_from_nav_seg_id(nav_point[1])
    for nav_seg_id,_ in pairs(area.nav_segs) do
      if not added_segs[nav_seg_id] then
        added_segs[nav_seg_id] = true
        table.insert(nav_segs, nav_seg_id)
      end
    end
  end
  local end_nav_seg = managers.navigation:get_nav_seg_from_pos(l_30_2, true)
  local end_area = managers.groupai:state():get_area_from_nav_seg_id(end_nav_seg)
  for nav_seg_id,_ in pairs(end_area.nav_segs) do
    if not added_segs[nav_seg_id] then
      added_segs[nav_seg_id] = true
      table.insert(nav_segs, nav_seg_id)
    end
  end
  local standing_nav_seg = l_30_0.unit:movement():nav_tracker():nav_segment()
  if not added_segs[standing_nav_seg] then
    table.insert(nav_segs, standing_nav_seg)
    added_segs[standing_nav_seg] = true
  end
  return nav_segs
end


