-- Decompiled using luadec 2.0.1 by sztupy (http://winmo.sztupy.hu)
-- Command line was: F:\SteamLibrary\SteamApps\common\PAYDAY 2\lua\lib\units\player_team\logics\teamailogictravel.luac 

require("lib/units/enemies/cop/logics/CopLogicBase")
require("lib/units/enemies/cop/logics/CopLogicTravel")
require("lib/units/enemies/cop/logics/CopLogicAttack")
TeamAILogicTravel = class(TeamAILogicBase)
TeamAILogicTravel.damage_clbk = TeamAILogicIdle.damage_clbk
TeamAILogicTravel.on_cop_neutralized = TeamAILogicIdle.on_cop_neutralized
TeamAILogicTravel.on_objective_unit_damaged = TeamAILogicIdle.on_objective_unit_damaged
TeamAILogicTravel.on_alert = TeamAILogicIdle.on_alert
TeamAILogicTravel.is_available_for_assignment = TeamAILogicIdle.is_available_for_assignment
TeamAILogicTravel.on_long_dis_interacted = TeamAILogicIdle.on_long_dis_interacted
TeamAILogicTravel.on_new_objective = TeamAILogicIdle.on_new_objective
TeamAILogicTravel.clbk_heat = TeamAILogicIdle.clbk_heat
TeamAILogicTravel.chk_should_turn = function(l_1_0, l_1_1)
  CopLogicAttack.chk_should_turn(l_1_0, l_1_1)
end

TeamAILogicTravel.enter = function(l_2_0, l_2_1, l_2_2)
  CopLogicBase.enter(l_2_0, l_2_1, l_2_2)
  l_2_0.unit:brain():cancel_all_pathing_searches()
  local old_internal_data = l_2_0.internal_data
  local my_data = {unit = l_2_0.unit}
  my_data.detection = l_2_0.char_tweak.detection.recon
  my_data.rsrv_pos = {}
  if old_internal_data then
    if not old_internal_data.rsrv_pos then
      my_data.rsrv_pos = my_data.rsrv_pos
    end
    my_data.attention_unit = old_internal_data.attention_unit
    if old_internal_data.nearest_cover then
      my_data.nearest_cover = old_internal_data.nearest_cover
      managers.navigation:reserve_cover(my_data.nearest_cover[1], l_2_0.pos_rsrv_id)
    end
    if old_internal_data.best_cover then
      my_data.best_cover = old_internal_data.best_cover
      managers.navigation:reserve_cover(my_data.best_cover[1], l_2_0.pos_rsrv_id)
    end
  end
  l_2_0.internal_data = my_data
  local key_str = tostring(l_2_0.key)
  if not l_2_0.unit:movement():cool() then
    my_data.detection_task_key = "TeamAILogicTravel._upd_enemy_detection" .. key_str
    CopLogicBase.queue_task(my_data, my_data.detection_task_key, TeamAILogicTravel._upd_enemy_detection, l_2_0, l_2_0.t)
  end
  my_data.cover_update_task_key = "CopLogicTravel._update_cover" .. key_str
  if my_data.nearest_cover or my_data.best_cover then
    CopLogicBase.add_delayed_clbk(my_data, my_data.cover_update_task_key, callback(CopLogicTravel, CopLogicTravel, "_update_cover", l_2_0), l_2_0.t + 1)
  end
  if l_2_0.objective then
    l_2_0.objective.called = false
    my_data.called = true
    if l_2_0.objective.follow_unit then
      my_data.cover_wait_t = {0, 0}
    end
  end
  l_2_0.unit:movement():set_allow_fire(false)
  my_data.weapon_range = l_2_0.char_tweak.weapon[l_2_0.unit:inventory():equipped_unit():base():weapon_tweak_data().usage].range
  if not l_2_0.unit:movement():chk_action_forbidden("walk") or l_2_0.unit:anim_data().act_idle then
    local new_action = {type = "idle", body_part = 2}
    l_2_0.unit:brain():action_request(new_action)
  end
end

TeamAILogicTravel.exit = function(l_3_0, l_3_1, l_3_2)
  TeamAILogicBase.exit(l_3_0, l_3_1, l_3_2)
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
end

TeamAILogicTravel.update = function(l_4_0)
  local unit = l_4_0.unit
  local objective = l_4_0.objective
  if not objective then
    TeamAILogicIdle.on_new_objective(l_4_0, nil)
    return 
  end
  local my_data = l_4_0.internal_data
  local t = l_4_0.t
  if my_data.processing_advance_path or my_data.processing_coarse_path then
    TeamAILogicTravel._upd_pathing(l_4_0, my_data)
    if my_data ~= l_4_0.internal_data then
      return 
     -- DECOMPILER ERROR: unhandled construct in 'if'

    elseif my_data.advancing and l_4_0.objective.type == "follow" and (not unit:movement():chk_action_forbidden("walk") or unit:anim_data().act_idle) then
      local follow_unit_nav_seg = l_4_0.objective.follow_unit:movement():nav_tracker():nav_segment()
      do
        if follow_unit_nav_seg ~= my_data.coarse_path[my_data.coarse_path_index + 1][1] or my_data.coarse_path_index ~= #my_data.coarse_path - 1 then
          local my_nav_seg = l_4_0.unit:movement():nav_tracker():nav_segment()
          if follow_unit_nav_seg == my_nav_seg then
            objective.in_place = true
            TeamAILogicTravel.on_new_objective(l_4_0)
            return 
          end
          do return end
          if my_data.cover_leave_t and not my_data.turning and (not unit:movement():chk_action_forbidden("walk") or not not unit:anim_data().act_idle) then
            if my_data.cover_leave_t < t then
              my_data.cover_leave_t = nil
            do
              elseif my_data.best_cover then
                local action_taken = nil
                if not unit:movement():attention() then
                  action_taken = CopLogicTravel._chk_request_action_turn_to_cover(l_4_0, my_data)
                end
                if not action_taken and not my_data.best_cover[4] and not unit:anim_data().crouch and not l_4_0.unit:movement():cool() then
                  CopLogicAttack._chk_request_action_crouch(l_4_0)
                end
                do return end
                do
                  if my_data.advance_path and (not unit:movement():chk_action_forbidden("walk") or unit:anim_data().act_idle) then
                    local haste, no_strafe = nil, nil
                    if objective and objective.haste then
                      haste = objective.haste
                    else
                      if unit:movement():cool() then
                        haste = "walk"
                      else
                        haste = "run"
                      end
                    end
                    if objective then
                      CopLogicTravel._chk_request_action_walk_to_advance_pos(l_4_0, my_data, haste, objective.rot, no_strafe)
                    end
                    if my_data.advancing then
                      TeamAILogicTravel._check_start_path_ahead(l_4_0)
                    end
                    do return end
                    if objective then
                      if my_data.coarse_path then
                        local coarse_path = my_data.coarse_path
                        local cur_index = my_data.coarse_path_index
                        local total_nav_points = #coarse_path
                        if cur_index == total_nav_points then
                          objective.in_place = true
                          if (objective.type == "investigate_area" or objective.type == "free") and not objective.action_duration then
                            managers.groupai:state():on_criminal_objective_complete(unit, objective)
                            return 
                          end
                          TeamAILogicTravel.on_new_objective(l_4_0)
                          return 
                        else
                          local to_pos = TeamAILogicTravel._get_exact_move_pos(l_4_0, cur_index + 1)
                          my_data.advance_path_search_id = tostring(l_4_0.key) .. "advance"
                          my_data.processing_advance_path = true
                          local prio = nil
                          if objective and objective.follow_unit then
                            prio = 5
                          end
                          local nav_segs = CopLogicTravel._get_allowed_travel_nav_segs(l_4_0, my_data, to_pos)
                          unit:brain():search_for_path(my_data.advance_path_search_id, to_pos, prio, nil, nav_segs)
                        else
                          local search_id = tostring(unit:key()) .. "coarse"
                          local nav_seg = nil
                          if objective.follow_unit then
                            nav_seg = objective.follow_unit:movement():nav_tracker():nav_segment()
                          else
                            nav_seg = objective.nav_seg
                          end
                          if unit:brain():search_for_coarse_path(search_id, nav_seg) then
                            my_data.coarse_path_search_id = search_id
                            my_data.processing_coarse_path = true
                          else
                            CopLogicBase._exit(l_4_0.unit, "idle", {scan = true})
                            return 
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
    if l_4_0.unit:movement():chk_action_forbidden("walk") then
      local action_taken = not unit:anim_data().act_idle
    end
    local want_to_take_cover = TeamAILogicTravel._chk_wants_to_take_cover(l_4_0, my_data)
    if not action_taken and (want_to_take_cover or l_4_0.char_tweak.no_stand) and not unit:anim_data().crouch then
      action_taken = CopLogicAttack._chk_request_action_crouch(l_4_0)
      do return end
      if unit:anim_data().crouch and not l_4_0.char_tweak.allow_crouch then
        action_taken = CopLogicAttack._chk_request_action_stand(l_4_0)
      end
    end
     -- Warning: missing end command somewhere! Added here
  end
end

TeamAILogicTravel._upd_pathing = function(l_5_0, l_5_1)
  local pathing_results = l_5_0.pathing_results
  if pathing_results then
    l_5_0.pathing_results = nil
    if l_5_1.processing_advance_path then
      local path = pathing_results[l_5_1.advance_path_search_id]
      if path then
        l_5_1.processing_advance_path = nil
        l_5_1.advance_path_search_id = nil
        if path ~= "failed" then
          l_5_1.advance_path = path
        else
          print("[TeamAILogicTravel:_upd_pathing] advance_path failed!", l_5_0.unit, inspect(l_5_1.coarse_path), l_5_1.coarse_path_index)
          l_5_0.path_fail_t = l_5_0.t
          managers.groupai:state():on_criminal_objective_failed(l_5_0.unit, l_5_0.objective)
          return 
        end
      end
    end
    if l_5_1.processing_coarse_path then
      local path = pathing_results[l_5_1.coarse_path_search_id]
      if path then
        l_5_1.processing_coarse_path = nil
        l_5_1.coarse_path_search_id = nil
        if path ~= "failed" then
          managers.groupai:state():trim_coarse_path_to_areas(path)
          l_5_1.coarse_path = path
          l_5_1.coarse_path_index = 1
        else
          print("[TeamAILogicTravel:_upd_pathing] coarse_path failed!")
          l_5_0.path_fail_t = l_5_0.t
          managers.groupai:state():on_criminal_objective_failed(l_5_0.unit, l_5_0.objective)
          return 
        end
      end
    end
  end
end

TeamAILogicTravel.action_complete_clbk = function(l_6_0, l_6_1)
  CopLogicTravel.action_complete_clbk(l_6_0, l_6_1)
  local my_data = l_6_0.internal_data
  local action_type = l_6_1:type()
  if action_type == "walk" and not l_6_1:expired() then
    if my_data.processing_advance_path then
      local pathing_results = l_6_0.pathing_results
      if pathing_results and pathing_results[my_data.advance_path_search_id] then
        l_6_0.pathing_results[my_data.advance_path_search_id] = nil
        my_data.advance_path_search_id = nil
        my_data.processing_advance_path = nil
      elseif my_data.advance_path then
        my_data.advance_path = nil
      end
    end
  end
end

TeamAILogicTravel.on_intimidated = function(l_7_0, l_7_1, l_7_2)
  local surrender = TeamAILogicIdle.on_intimidated(l_7_0, l_7_1, l_7_2)
  if surrender and l_7_0.objective then
    managers.groupai:state():on_criminal_objective_failed(l_7_0.unit, l_7_0.objective)
  end
end

TeamAILogicTravel._determine_destination_occupation = function(l_8_0, l_8_1)
  local occupation = nil
  if l_8_1.type == "investigate_area" then
    if l_8_1.guard_obj then
      if not managers.groupai:state():verify_occupation_in_area(l_8_1) then
        occupation = l_8_1.guard_obj
      end
      occupation.type = "guard"
    else
      occupation = managers.groupai:state():find_occupation_in_area(l_8_1.nav_seg)
    end
  elseif l_8_1.type == "defend_area" then
    if l_8_1.cover then
      occupation = {type = "defend", seg = l_8_1.nav_seg, cover = l_8_1.cover, radius = l_8_1.radius}
    elseif not l_8_1.pos and (not l_8_1.area or not l_8_1.area.pos) then
      local pos = managers.navigation._nav_segments[l_8_1.nav_seg].pos
    end
    if not l_8_1.area or not l_8_1.area.nav_segs then
      local cover = (managers.navigation:find_cover_in_nav_seg_1(managers.navigation, l_8_1.nav_seg))
    end
    local cover_entry = nil
    if cover then
      local cover_entry = {cover}
      occupation = {type = "defend", cover = cover_entry}
    else
      occupation = {type = "defend", seg = l_8_1.nav_seg, pos = l_8_1.pos, radius = l_8_1.radius}
    end
  elseif l_8_1.type == "act" then
    occupation = {type = "act", seg = l_8_1.nav_seg, pos = l_8_1.pos}
  elseif l_8_1.type == "follow" then
    local my_data = l_8_0.internal_data
    local follow_tracker = l_8_1.follow_unit:movement():nav_tracker()
    local dest_nav_seg_id = my_data.coarse_path[#my_data.coarse_path][1]
    local dest_area = managers.groupai:state():get_area_from_nav_seg_id(dest_nav_seg_id)
    local follow_pos = (follow_tracker:field_position())
    local threat_pos = nil
    if l_8_0.attention_obj and l_8_0.attention_obj.nav_tracker and AIAttentionObject.REACT_COMBAT <= l_8_0.attention_obj.reaction then
      threat_pos = l_8_0.attention_obj.nav_tracker:field_position()
    end
    local cover = managers.navigation:find_cover_in_nav_seg_3(managers.navigation, dest_area.nav_segs, nil, follow_pos, threat_pos)
    if cover then
      local cover_entry = {cover}
      occupation = {type = "defend", cover = cover_entry}
    else
      local max_dist = nil
      if l_8_1.called then
        max_dist = 600
      end
      local to_pos = CopLogicTravel._get_pos_on_wall(dest_area.pos, max_dist)
      occupation = {type = "defend", pos = to_pos}
    elseif l_8_1.type == "revive" then
      local is_local_player = l_8_1.follow_unit:base().is_local_player
      local revive_u_mv = l_8_1.follow_unit:movement()
      local revive_u_tracker = revive_u_mv:nav_tracker()
      if not is_local_player or not Rotation(0, 0, 0) then
        local revive_u_rot = revive_u_mv:m_rot()
      end
      local revive_u_fwd = revive_u_rot:y()
      local revive_u_right = revive_u_rot:x()
      if not revive_u_tracker:lost() or not revive_u_tracker:field_position() then
        local revive_u_pos = revive_u_mv:m_pos()
      end
      local ray_params = {tracker_from = revive_u_tracker, trace = true}
      if revive_u_tracker:lost() then
        ray_params.pos_from = revive_u_pos
      end
      local stand_dis = nil
      if is_local_player or l_8_1.follow_unit:base().is_husk_player then
        stand_dis = 120
      else
        stand_dis = 90
        local mid_pos = mvector3.copy(revive_u_fwd)
        mvector3.multiply(mid_pos, -20)
        mvector3.add(mid_pos, revive_u_pos)
        ray_params.pos_to = mid_pos
        local ray_res = managers.navigation:raycast(ray_params)
        revive_u_pos = ray_params.trace[1]
      end
      local rand_side_mul = math.random() > 0.5 and 1 or -1
      local revive_pos = mvector3.copy(revive_u_right)
      mvector3.multiply(revive_pos, rand_side_mul * stand_dis)
      mvector3.add(revive_pos, revive_u_pos)
      ray_params.pos_to = revive_pos
      local ray_res = managers.navigation:raycast(ray_params)
      if ray_res then
        local opposite_pos = mvector3.copy(revive_u_right)
        mvector3.multiply(opposite_pos, -rand_side_mul * stand_dis)
        mvector3.add(opposite_pos, revive_u_pos)
        ray_params.pos_to = opposite_pos
        local old_trace = ray_params.trace[1]
        local opposite_ray_res = managers.navigation:raycast(ray_params)
        if opposite_ray_res then
          if mvector3.distance(revive_pos, revive_u_pos) < mvector3.distance(ray_params.trace[1], revive_u_pos) then
            revive_pos = ray_params.trace[1]
          else
            revive_pos = old_trace
          end
        else
          revive_pos = ray_params.trace[1]
        end
      else
        revive_pos = ray_params.trace[1]
      end
      local revive_rot = revive_u_pos - revive_pos
      local revive_rot = Rotation(revive_rot, math.UP)
      occupation = {type = "revive", pos = revive_pos, rot = revive_rot}
    else
      occupation = {seg = l_8_1.nav_seg, pos = l_8_1.pos}
    end
  end
  return occupation
end

TeamAILogicTravel._upd_enemy_detection = function(l_9_0)
  l_9_0.t = TimerManager:game():time()
  local my_data = l_9_0.internal_data
  local max_reaction = nil
  if l_9_0.cool then
    max_reaction = AIAttentionObject.REACT_SURPRISED
  end
  local delay = CopLogicBase._upd_attention_obj_detection(l_9_0, AIAttentionObject.REACT_CURIOUS, max_reaction)
  local new_attention, new_prio_slot, new_reaction = TeamAILogicIdle._get_priority_attention(l_9_0, l_9_0.detected_attention_objects, nil)
  TeamAILogicBase._set_attention_obj(l_9_0, new_attention, new_reaction)
  if new_attention then
    local objective = l_9_0.objective
    local allow_trans, obj_failed = nil, nil
    local dont_exit = false
    if l_9_0.unit:movement():chk_action_forbidden("walk") and not l_9_0.unit:anim_data().act_idle then
      dont_exit = true
    else
      allow_trans, obj_failed = CopLogicBase.is_obstructed(l_9_0, objective, nil, new_attention)
    end
    if obj_failed and not dont_exit then
      if objective.type == "follow" then
        debug_pause_unit(l_9_0.unit, "failing follow", allow_trans, obj_failed, inspect(objective))
      end
      managers.groupai:state():on_criminal_objective_failed(l_9_0.unit, l_9_0.objective)
      return 
    end
  end
  CopLogicAttack._upd_aim(l_9_0, my_data)
  if not my_data._intimidate_t or my_data._intimidate_t + 2 < l_9_0.t then
    local civ = TeamAILogicIdle.intimidate_civilians(l_9_0, l_9_0.unit, true, false)
    if civ then
      my_data._intimidate_t = l_9_0.t
      if not l_9_0.attention_obj then
        CopLogicBase._set_attention_on_unit(l_9_0, civ)
        local key = "RemoveAttentionOnUnit" .. tostring(l_9_0.key)
        CopLogicBase.queue_task(my_data, key, TeamAILogicTravel._remove_enemy_attention, l_9_0, l_9_0.t + 1.5)
      end
    end
  end
  TeamAILogicAssault._chk_request_combat_chatter(l_9_0, my_data)
  CopLogicBase.queue_task(my_data, my_data.detection_task_key, TeamAILogicTravel._upd_enemy_detection, l_9_0, l_9_0.t + delay)
end

TeamAILogicTravel._remove_enemy_attention = function(l_10_0)
  CopLogicBase._reset_attention(l_10_0)
end

TeamAILogicTravel._get_exact_move_pos = function(l_11_0, l_11_1)
  local my_data = l_11_0.internal_data
  local objective = l_11_0.objective
  local to_pos = nil
  local coarse_path = my_data.coarse_path
  local total_nav_points = #coarse_path
  do
    local reservation, wants_reservation = nil, nil
    if total_nav_points <= l_11_1 then
      local new_occupation = TeamAILogicTravel._determine_destination_occupation(l_11_0, objective)
      if new_occupation then
        if new_occupation.type == "guard" then
          local guard_door = new_occupation.door
          local guard_pos = CopLogicTravel._get_pos_accross_door(guard_door, objective.nav_seg)
          if guard_pos then
            reservation = CopLogicTravel._reserve_pos_along_vec(guard_door.center, guard_pos)
            if reservation then
              local guard_object = {type = "door", door = guard_door, from_seg = new_occupation.from_seg}
              objective.guard_obj = guard_object
              to_pos = reservation.pos
            elseif new_occupation.type == "defend" then
              if new_occupation.cover then
                to_pos = new_occupation.cover[1][1]
                local new_cover = new_occupation.cover
                managers.navigation:reserve_cover(new_cover[1], l_11_0.pos_rsrv_id)
                my_data.moving_to_cover = new_cover
              elseif new_occupation.pos then
                to_pos = new_occupation.pos
              end
              wants_reservation = true
            elseif new_occupation.type == "act" then
              to_pos = new_occupation.pos
              wants_reservation = true
            elseif new_occupation.type == "revive" then
              to_pos = new_occupation.pos
              objective.rot = new_occupation.rot
              wants_reservation = true
            else
              to_pos = new_occupation.pos
              wants_reservation = true
            end
          end
        end
        if not to_pos then
          to_pos = managers.navigation:find_random_position_in_segment(objective.nav_seg)
          to_pos = CopLogicTravel._get_pos_on_wall(to_pos)
          wants_reservation = true
        else
          local nav_seg = coarse_path[l_11_1][1]
          local area = managers.groupai:state():get_area_from_nav_seg_id(nav_seg)
          local cover = managers.navigation:find_cover_in_nav_seg_1(managers.navigation, area.nav_segs)
          if cover then
            managers.navigation:reserve_cover(cover, l_11_0.pos_rsrv_id)
            my_data.moving_to_cover = {cover}
            to_pos = cover[1]
          else
            to_pos = coarse_path[l_11_1][2]
            my_data.moving_to_cover = nil
          end
        end
        if not reservation and wants_reservation then
          reservation = {position = mvector3.copy(to_pos), radius = 60, filter = l_11_0.pos_rsrv_id}
          managers.navigation:add_pos_reservation(reservation)
        end
        if my_data.rsrv_pos.path then
          managers.navigation:unreserve_pos(my_data.rsrv_pos.path)
        end
        my_data.rsrv_pos.path = reservation
        return to_pos
      end
       -- Warning: missing end command somewhere! Added here
    end
     -- Warning: missing end command somewhere! Added here
  end
end

TeamAILogicTravel._check_start_path_ahead = function(l_12_0)
  local my_data = l_12_0.internal_data
  if my_data.processing_advance_path then
    return 
  end
  local objective = l_12_0.objective
  local coarse_path = my_data.coarse_path
  local next_index = my_data.coarse_path_index + 2
  local total_nav_points = #coarse_path
  if total_nav_points < next_index then
    return 
  end
  local to_pos = TeamAILogicTravel._get_exact_move_pos(l_12_0, next_index)
  my_data.advance_path_search_id = tostring(l_12_0.key) .. "advance"
  my_data.processing_advance_path = true
  local prio = nil
  if objective and objective.follow_unit then
    prio = 5
  end
  local from_pos = my_data.rsrv_pos.move_dest.position
  local nav_segs = CopLogicTravel._get_allowed_travel_nav_segs(l_12_0, my_data, to_pos)
  l_12_0.unit:brain():search_for_path_from_pos(my_data.advance_path_search_id, from_pos, to_pos, prio, nil, nav_segs)
end

TeamAILogicTravel._get_all_paths = function(l_13_0)
  return {advance_path = l_13_0.internal_data.advance_path}
end

TeamAILogicTravel._set_verified_paths = function(l_14_0, l_14_1)
  l_14_0.internal_data.advance_path = l_14_1.advance_path
end

TeamAILogicTravel._chk_wants_to_take_cover = function(l_15_0, l_15_1)
  if not l_15_0.attention_obj or l_15_0.attention_obj.reaction < AIAttentionObject.REACT_COMBAT then
    return 
  end
  if l_15_0.is_suppressed or l_15_0.unit:anim_data().reload then
    return true
  end
  local last_sup_t = l_15_0.unit:character_damage():last_suppression_t()
   -- DECOMPILER ERROR: unhandled construct in 'if'

   -- DECOMPILER ERROR: unhandled construct in 'if'

  if last_sup_t and l_15_1.attitude == "engage" and l_15_0.t - last_sup_t < 2 then
    return true
    do return end
    if l_15_0.t - last_sup_t < 3 then
      return true
    end
  end
  local ammo_max, ammo = l_15_0.unit:inventory():equipped_unit():base():ammo_info()
  if ammo / ammo_max < 0.20000000298023 then
    return true
  end
end


