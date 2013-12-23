-- Decompiled using luadec 2.0.1 by sztupy (http://winmo.sztupy.hu)
-- Command line was: F:\SteamLibrary\SteamApps\common\PAYDAY 2\lua\lib\units\enemies\cop\logics\coplogicflee.luac 

CopLogicFlee = class(CopLogicBase)
CopLogicFlee.enter = function(l_1_0, l_1_1, l_1_2)
  CopLogicBase.enter(l_1_0, l_1_1, l_1_2)
  l_1_0.unit:brain():cancel_all_pathing_searches()
  local old_internal_data = l_1_0.internal_data
  local my_data = {unit = l_1_0.unit}
  my_data.detection = l_1_0.char_tweak.detection.combat
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
  end
  l_1_0.internal_data = my_data
  if l_1_0.unit:movement():chk_action_forbidden("walk") and l_1_0.unit:movement()._active_actions[2] then
    my_data.wants_stop_old_walk_action = true
  end
  local key_str = tostring(l_1_0.key)
  my_data.detection_task_key = "CopLogicFlee._update_enemy_detection" .. key_str
  CopLogicBase.queue_task(my_data, my_data.detection_task_key, CopLogicFlee._update_enemy_detection, l_1_0)
  my_data.cover_update_task_key = "CopLogicFlee._update_cover" .. key_str
  CopLogicBase.queue_task(my_data, my_data.cover_update_task_key, CopLogicFlee._update_cover, l_1_0, l_1_0.t + 1)
  my_data.cover_path_search_id = key_str .. "cover"
  if l_1_0.attention_obj and AIAttentionObject.REACT_COMBAT <= l_1_0.attention_obj.reaction then
    my_data.want_cover = true
  end
  CopLogicBase._reset_attention(l_1_0)
  l_1_0.unit:movement():set_stance("wnd")
  l_1_0.unit:movement():set_cool(false)
  if my_data ~= l_1_0.internal_data then
    return 
  end
  l_1_0.unit:brain():set_attention_settings({cbt = true})
end

CopLogicFlee.exit = function(l_2_0, l_2_1, l_2_2)
  CopLogicBase.exit(l_2_0, l_2_1, l_2_2)
  local my_data = l_2_0.internal_data
  l_2_0.unit:brain():cancel_all_pathing_searches()
  CopLogicBase.cancel_queued_tasks(my_data)
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
end

CopLogicFlee.update = function(l_3_0)
  local exit_state = nil
  local unit = l_3_0.unit
  local my_data = l_3_0.internal_data
  local objective = l_3_0.objective
  local t = l_3_0.t
  if my_data.wants_stop_old_walk_action and not l_3_0.unit:movement():chk_action_forbidden("walk") then
    l_3_0.unit:movement():action_request({type = "idle", body_part = 2})
    my_data.wants_stop_old_walk_action = nil
  end
  return 
  if l_3_0.attention_obj and AIAttentionObject.REACT_COMBAT <= l_3_0.attention_obj.reaction then
    CopLogicFlee._cancel_flee_pathing(l_3_0, my_data)
    CopLogicFlee._update_cover_pathing(l_3_0, my_data)
    if my_data.cover_pathing then
      do return end
    end
    if my_data.moving_to_cover then
      do return end
    end
    if my_data.cover_path and not my_data.turning and not unit:movement():chk_action_forbidden("walk") then
      CopLogicAttack._correct_path_start_pos(l_3_0, my_data.cover_path)
      do
        local new_action_data = {type = "walk", nav_path = my_data.cover_path, variant = "run", body_part = 2}
        my_data.cover_path = nil
        if unit:brain():action_request(new_action_data) then
          my_data.moving_to_cover = my_data.best_cover
          my_data.in_cover = nil
          if my_data.rsrv_pos.stand then
            managers.navigation:unreserve_pos(my_data.rsrv_pos.stand)
            my_data.rsrv_pos.stand = nil
          end
          do return end
          if my_data.best_cover and my_data.best_cover ~= my_data.in_cover then
            my_data.cover_pathing = true
            unit:brain():search_for_path(my_data.cover_path_search_id, my_data.best_cover[1][1])
          else
            CopLogicFlee._cancel_cover_pathing(l_3_0, my_data)
            if my_data.advancing and not unit:anim_data().crouch then
              CopLogicAttack._chk_request_action_crouch(l_3_0)
              do return end
              if my_data.processing_flee_path or my_data.processing_coarse_path then
                CopLogicFlee._update_pathing(l_3_0, my_data)
              elseif my_data.cover_leave_t and not my_data.turning and not unit:movement():chk_action_forbidden("walk") then
                if my_data.cover_leave_t < t then
                  my_data.cover_leave_t = nil
                elseif my_data.best_cover and not CopLogicTravel._chk_request_action_turn_to_cover(l_3_0, my_data) and not unit:anim_data().crouch then
                  CopLogicAttack._chk_request_action_crouch(l_3_0)
                  do return end
                  do
                     -- DECOMPILER ERROR: unhandled construct in 'if'

                    if my_data.flee_path and my_data.path_blocked == false and not unit:movement():chk_action_forbidden("walk") then
                      local new_action_data = {type = "walk", nav_path = my_data.flee_path, path_simplified = true, variant = "run", body_part = 2}
                      my_data.flee_path = nil
                      my_data.advancing = unit:brain():action_request(new_action_data)
                      if my_data.advancing then
                        my_data.rsrv_pos.move_dest = my_data.rsrv_pos.path
                        my_data.rsrv_pos.path = nil
                        my_data.in_cover = nil
                        if my_data.rsrv_pos.stand then
                          managers.navigation:unreserve_pos(my_data.rsrv_pos.stand)
                          my_data.rsrv_pos.stand = nil
                        end
                        if my_data.cover_pathing then
                          managers.navigation:cancel_pathing_search(my_data.cover_path_search_id)
                          my_data.cover_pathing = nil
                        end
                        do return end
                        if my_data.flee_target then
                          if my_data.coarse_path then
                            local coarse_path = my_data.coarse_path
                            local cur_index = my_data.coarse_path_index
                            local total_nav_points = #coarse_path
                            if cur_index == total_nav_points then
                              l_3_0.unit:base():set_slot(unit, 0)
                            elseif not my_data.processing_flee_path then
                              my_data.rsrv_pos.path = nil
                              local to_pos = nil
                              if cur_index == total_nav_points - 1 then
                                to_pos = my_data.flee_target.pos
                              else
                                local end_pos = coarse_path[cur_index + 1][2]
                                local my_pos = l_3_0.m_pos
                                local walk_dir = end_pos - my_pos
                                local walk_dis = mvector3.normalize(walk_dir)
                                local cover_range = math.min(700, math.max(0, walk_dis - 100))
                                local cover = managers.navigation:find_cover_near_pos_1(managers.navigation, end_pos, end_pos + walk_dir * 700, cover_range, cover_range)
                                if cover then
                                  if my_data.best_cover then
                                    managers.navigation:release_cover(my_data.best_cover[1])
                                  end
                                  managers.navigation:reserve_cover(cover, l_3_0.pos_rsrv_id)
                                  my_data.moving_to_cover = {cover}
                                  my_data.best_cover = my_data.moving_to_cover
                                  to_pos = cover[1]
                                else
                                  to_pos = end_pos
                                end
                              end
                              my_data.flee_path_search_id = tostring(unit:key()) .. "flee"
                              my_data.processing_flee_path = true
                              my_data.path_blocked = nil
                              unit:brain():search_for_path(my_data.flee_path_search_id, to_pos)
                            else
                              local search_id = tostring(unit:key()) .. "coarseflee"
                              local verify_clbk = nil
                              if not my_data.coarse_search_failed then
                                verify_clbk = callback(CopLogicFlee, CopLogicFlee, "_flee_coarse_path_verify_clbk")
                              end
                              if unit:brain():search_for_coarse_path(search_id, my_data.flee_target.nav_seg, verify_clbk) then
                                my_data.coarse_path_search_id = search_id
                                my_data.processing_coarse_path = true
                              else
                                local flee_pos = managers.groupai:state():flee_point(l_3_0.unit:movement():nav_tracker():nav_segment())
                                if flee_pos then
                                  local nav_seg = managers.navigation:get_nav_seg_from_pos(flee_pos)
                                  my_data.flee_target = {nav_seg = nav_seg, pos = flee_pos}
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
    end
  end
end

CopLogicFlee._update_enemy_detection = function(l_4_0)
  managers.groupai:state():on_unit_detection_updated(l_4_0.unit)
  l_4_0.t = TimerManager:game():time()
  local my_data = l_4_0.internal_data
  local min_reaction = AIAttentionObject.REACT_COMBAT
  local delay = CopLogicBase._upd_attention_obj_detection(l_4_0, min_reaction, nil)
  local new_attention, new_prio_slot, new_reaction = CopLogicIdle._get_priority_attention(l_4_0, l_4_0.detected_attention_objects, CopLogicFlee._chk_reaction_to_attention_object)
  local old_att_obj = l_4_0.attention_obj
  CopLogicBase._set_attention_obj(l_4_0, new_attention, new_reaction)
  my_data.advance_blocked = nil
  my_data.path_blocked = false
  if new_attention then
    my_data.want_cover = true
    CopLogicFlee._upd_shoot(l_4_0, my_data)
  elseif my_data.attention_unit then
    CopLogicBase._reset_attention(l_4_0)
    my_data.attention_unit = nil
  end
  if my_data.shooting then
    local new_action = {type = "idle", body_part = 3}
    l_4_0.unit:brain():action_request(new_action)
    l_4_0.unit:movement():set_allow_fire(false)
  end
  my_data.want_cover = nil
  if l_4_0.important then
    delay = 0
  else
    delay = 0.5 + delay * 1.5
  end
  CopLogicBase.queue_task(my_data, my_data.detection_task_key, CopLogicFlee._update_enemy_detection, l_4_0, l_4_0.t + (delay))
  CopLogicBase._report_detections(l_4_0.detected_attention_objects)
end

CopLogicFlee._upd_shoot = function(l_5_0, l_5_1)
  local shoot = nil
  local focus_enemy = l_5_0.attention_obj
  if not l_5_0.unit:movement():chk_action_forbidden("walk") and not l_5_1.turning then
    local action_taken = l_5_1.moving_to_cover
  end
  if not action_taken then
    if l_5_1.advance_blocked and l_5_0.unit:anim_data().move then
      local new_action = {type = "idle", body_part = 2}
      l_5_0.unit:brain():action_request(new_action)
    else
      if not CopLogicAttack._chk_request_action_turn_to_enemy(l_5_0, l_5_1, l_5_0.m_pos, focus_enemy.m_pos) and not l_5_0.unit:anim_data().crouch then
        CopLogicAttack._chk_request_action_crouch(l_5_0)
      end
    end
  end
  if not l_5_1.shooting and not l_5_0.unit:anim_data().reload and not l_5_0.unit:movement():chk_action_forbidden("action") then
    CopLogicBase._set_attention(l_5_0, focus_enemy)
    l_5_1.attention_unit = focus_enemy.u_key
    local shoot_action = {}
    shoot_action.type = "shoot"
    shoot_action.body_part = 3
    if l_5_0.unit:brain():action_request(shoot_action) then
      l_5_1.shooting = true
    else
      if l_5_1.attention_unit ~= focus_enemy.u_key then
        CopLogicBase._set_attention(l_5_0, focus_enemy)
        l_5_1.attention_unit = focus_enemy.u_key
      end
    end
  end
   -- DECOMPILER ERROR: Confused while interpreting a jump as a 'while'

end
l_5_0.unit:movement():set_allow_fire(true)
end

CopLogicFlee._update_pathing = function(l_6_0, l_6_1)
  if l_6_0.pathing_results then
    if l_6_1.flee_path_search_id then
      local path = l_6_0.pathing_results[l_6_1.flee_path_search_id]
    end
    if path then
      if path ~= "failed" then
        l_6_1.flee_path = path
      else
        cat_print("george", "CopLogicFlee:_update_pathing() flee_path failed!")
      end
      l_6_0.pathing_results[l_6_1.flee_path_search_id] = nil
      l_6_1.processing_flee_path = nil
      l_6_1.flee_path_search_id = nil
    end
    path = l_6_0.pathing_results[l_6_1.coarse_path_search_id]
    if path then
      if path ~= "failed" then
        l_6_1.coarse_path = path
        l_6_1.coarse_path_index = 1
      elseif l_6_1.coarse_search_failed then
        cat_print("george", "CopLogicFlee:_update_pathing() coarse_path failed unsafe!")
        l_6_1.flee_target = nil
      end
      l_6_1.coarse_search_failed = true
      l_6_0.pathing_results[l_6_1.coarse_path_search_id] = nil
      l_6_1.processing_coarse_path = nil
      l_6_1.coarse_path_search_id = nil
    end
    l_6_0.pathing_results = nil
    l_6_1.cover_pathing = nil
  end
end

CopLogicFlee._update_cover_pathing = function(l_7_0, l_7_1)
  if l_7_0.pathing_results then
    local path = l_7_0.pathing_results[l_7_1.cover_path_search_id]
    if path then
      if path ~= "failed" then
        l_7_1.cover_path = path
      else
        cat_print("george", "CopLogicFlee:_update_cover_pathing() cover pathing failed!")
        l_7_1.cover_pathing = nil
      end
      l_7_0.pathing_results = nil
      l_7_1.processing_flee_path = nil
      l_7_1.flee_path_search_id = nil
      l_7_1.processing_coarse_path = nil
      l_7_1.coarse_path_search_id = nil
    end
     -- Warning: missing end command somewhere! Added here
  end
end

CopLogicFlee._chk_reaction_to_attention_object = function(l_8_0, l_8_1, l_8_2)
  local record = l_8_1.criminal_record
  if not record or not l_8_1.is_person then
    return l_8_1.settings.reaction
  end
  local att_unit = l_8_1.unit
  local assault_mode = managers.groupai:state():get_assault_mode()
   -- DECOMPILER ERROR: unhandled construct in 'if'

  if record.status == "disabled" and (not record.assault_t or record.assault_t - record.disabled_t > 0.60000002384186) and (record.engaged_force < 5 or not l_8_1.is_human_player or CopLogicIdle._am_i_important_to_player(record, l_8_0.key)) then
    return math.min(l_8_1.reaction, AIAttentionObject.REACT_COMBAT)
    do return end
    if not record.being_arrested then
      local my_vec = l_8_0.m_pos - l_8_1.m_pos
      local dis = mvector3.normalize(my_vec)
      if dis < 500 then
        return math.min(l_8_1.settings.reaction, AIAttentionObject.REACT_COMBAT)
      elseif dis < 3000 then
        local criminal_fwd = att_unit:movement():m_head_rot():y()
        local criminal_look_dot = mvector3.dot(my_vec, criminal_fwd)
        if criminal_look_dot > 0.89999997615814 then
          if record.assault_t then
            local aggression_age = l_8_0.t - record.assault_t
          end
          if aggression_age and aggression_age < 2 then
            return math.min(l_8_1.settings.reaction, AIAttentionObject.REACT_COMBAT)
          end
        end
        if record.engaged_force == 0 or record.engaged_force == 1 and record.engaged[l_8_0.unit:key()] then
          return math.min(l_8_1.settings.reaction, AIAttentionObject.REACT_COMBAT)
        end
        local my_data = l_8_0.internal_data
        if my_data.flee_path then
          local walk_to_pos = CopLogicIdle._nav_point_pos(my_data.flee_path[2])
          local move_dir = walk_to_pos - l_8_0.m_pos
          mvector3.normalize(move_dir)
          local move_dot = mvector3.dot(my_vec, move_dir)
          if move_dot < -0.5 then
            my_data.path_blocked = true
            return math.min(l_8_1.settings.reaction, AIAttentionObject.REACT_COMBAT)
          else
            my_data.path_blocked = false
          end
        end
      end
    end
  end
  return AIAttentionObject.REACT_IDLE
end

CopLogicFlee.action_complete_clbk = function(l_9_0, l_9_1)
  local action_type = l_9_1:type()
  if action_type == "walk" then
    local my_data = l_9_0.internal_data
    my_data.rsrv_pos.stand = my_data.rsrv_pos.move_dest
    my_data.rsrv_pos.move_dest = nil
    if my_data.moving_to_cover then
      if l_9_1:expired() then
        if my_data.best_cover then
          managers.navigation:release_cover(my_data.best_cover[1])
        end
        my_data.best_cover = my_data.moving_to_cover
        managers.navigation:reserve_cover(my_data.best_cover[1], l_9_0.pos_rsrv_id)
        my_data.in_cover = my_data.best_cover
        if my_data.advancing then
          my_data.cover_leave_t = l_9_0.t + math.random(2, 4)
        end
      end
      my_data.moving_to_cover = nil
    elseif my_data.best_cover then
      local dis = mvector3.distance(my_data.best_cover[1][1], l_9_0.unit:movement():m_pos())
      if dis > 100 then
        managers.navigation:release_cover(my_data.best_cover[1])
        my_data.best_cover = nil
      end
    end
    if my_data.advancing then
      if l_9_1:expired() then
        my_data.coarse_path_index = my_data.coarse_path_index + 1
      end
      my_data.advancing = nil
    elseif action_type == "turn" then
      l_9_0.internal_data.turning = nil
    elseif action_type == "shoot" then
      l_9_0.internal_data.shooting = nil
    elseif action_type == "hurt" and l_9_1:expired() then
      local action_data = CopLogicBase.chk_start_action_dodge(l_9_0, "hit")
      do
        local my_data = l_9_0.internal_data
        if action_data then
          CopLogicFlee._cancel_cover_pathing(l_9_0, my_data)
          CopLogicFlee._cancel_flee_pathing(l_9_0, my_data)
        end
        do return end
        if action_type == "dodge" then
          local my_data = l_9_0.internal_data
          CopLogicFlee._cancel_cover_pathing(l_9_0, my_data)
          CopLogicFlee._cancel_flee_pathing(l_9_0, my_data)
        end
      end
    end
  end
end

CopLogicFlee._update_cover = function(l_10_0)
  local my_data = l_10_0.internal_data
  local cover_release_dis = 100
  local best_cover = my_data.best_cover
  local nearest_cover = my_data.nearest_cover
  local want_cover = my_data.want_cover
  if want_cover and l_10_0.attention_obj then
    local threat_pos = l_10_0.attention_obj.verified_pos
    local min_threat_dis = 700
    if not my_data.moving_to_cover and (not best_cover or not CopLogicAttack._verify_cover(best_cover[1], threat_pos, min_threat_dis) or min_threat_dis >= mvector3.distance(best_cover[1][1], threat_pos)) then
      local better_cover = nil
      if nearest_cover and CopLogicAttack._verify_cover(nearest_cover[1], threat_pos, min_threat_dis) then
        better_cover = nearest_cover
      end
      if not better_cover then
        local max_near_dis = 1000
        local found_cover = managers.navigation:find_cover_near_pos_1(managers.navigation, l_10_0.m_pos, threat_pos, max_near_dis, min_threat_dis)
        if found_cover then
          better_cover = {found_cover}
        end
      end
      if better_cover then
        if best_cover then
          managers.navigation:release_cover(best_cover[1])
          CopLogicFlee._cancel_cover_pathing(l_10_0, my_data)
        end
        my_data.best_cover = better_cover
        managers.navigation:reserve_cover(better_cover[1], l_10_0.pos_rsrv_id)
      elseif nearest_cover and cover_release_dis < mvector3.distance(nearest_cover[1][1], l_10_0.m_pos) then
        managers.navigation:release_cover(nearest_cover[1])
        my_data.nearest_cover = nil
      end
      if best_cover and cover_release_dis < mvector3.distance(best_cover[1][1], l_10_0.m_pos) then
        managers.navigation:release_cover(best_cover[1])
        my_data.best_cover = nil
      end
    end
  end
  local delay = want_cover and 2 or 3
  CopLogicBase.queue_task(my_data, my_data.cover_update_task_key, CopLogicFlee._update_cover, l_10_0, l_10_0.t + delay)
end

CopLogicFlee._cancel_cover_pathing = function(l_11_0, l_11_1)
  if l_11_1.cover_pathing then
    if l_11_0.active_searches[l_11_1.cover_path_search_id] then
      managers.navigation:cancel_pathing_search(l_11_1.cover_path_search_id)
      l_11_0.active_searches[l_11_1.cover_path_search_id] = nil
    elseif l_11_0.pathing_results then
      l_11_0.pathing_results[l_11_1.cover_path_search_id] = nil
    end
    l_11_1.cover_pathing = nil
  end
  l_11_1.cover_path = nil
end

CopLogicFlee._cancel_flee_pathing = function(l_12_0, l_12_1)
  if l_12_1.flee_path_search_id then
    if l_12_0.active_searches[l_12_1.flee_path_search_id] then
      managers.navigation:cancel_pathing_search(l_12_1.flee_path_search_id)
    elseif l_12_0.pathing_results then
      l_12_0.pathing_results[l_12_1.flee_path_search_id] = nil
    end
    l_12_1.processing_flee_path = nil
    l_12_1.flee_path_search_id = nil
  end
  if l_12_1.coarse_path_search_id then
    if l_12_0.active_searches[l_12_1.coarse_path_search_id] then
      managers.navigation:cancel_coarse_search(l_12_1.coarse_path_search_id)
    elseif l_12_0.pathing_results then
      l_12_0.pathing_results[l_12_1.coarse_path_search_id] = nil
    end
    l_12_1.processing_coarse_path = nil
    l_12_1.coarse_path_search_id = nil
  end
end

CopLogicFlee.damage_clbk = function(l_13_0, l_13_1)
  CopLogicIdle.damage_clbk(l_13_0, l_13_1)
end

CopLogicFlee.death_clbk = function(l_14_0, l_14_1)
  CopLogicAttack.death_clbk(l_14_0, l_14_1)
end

CopLogicFlee.on_detected_enemy_destroyed = function(l_15_0, l_15_1)
  CopLogicAttack.on_detected_enemy_destroyed(l_15_0, l_15_1)
end

CopLogicFlee.on_criminal_neutralized = function(l_16_0, l_16_1)
  CopLogicAttack.on_criminal_neutralized(l_16_0, l_16_1)
end

CopLogicFlee.is_available_for_assignment = function(l_17_0, l_17_1)
  if l_17_1 and l_17_1.forced then
    return true
  end
  return false
end

CopLogicFlee.on_alert = function(...)
  CopLogicIdle.on_alert(...)
   -- DECOMPILER ERROR: Confused about usage of registers for local variables.

end

CopLogicFlee._flee_coarse_path_verify_clbk = function(l_19_0, l_19_1)
  return managers.groupai:state():is_nav_seg_safe(l_19_1)
end

CopLogicFlee.on_intimidated = function(l_20_0, l_20_1, l_20_2)
  CopLogicIdle._surrender(l_20_0, l_20_1)
end

CopLogicFlee._get_all_paths = function(l_21_0)
  return {flee_path = l_21_0.internal_data.flee_path}
end

CopLogicFlee._set_verified_paths = function(l_22_0, l_22_1)
  l_22_0.internal_data.flee_path = l_22_1.flee_path
end


