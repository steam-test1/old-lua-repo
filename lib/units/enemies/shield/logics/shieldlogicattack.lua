-- Decompiled using luadec 2.0.1 by sztupy (http://winmo.sztupy.hu)
-- Command line was: F:\SteamLibrary\SteamApps\common\PAYDAY 2\lua\lib\units\enemies\shield\logics\shieldlogicattack.luac 

ShieldLogicAttack = class(TankCopLogicAttack)
ShieldLogicAttack.enter = function(l_1_0, l_1_1, l_1_2)
  local old_internal_data = l_1_0.internal_data
  local my_data = {unit = l_1_0.unit}
  l_1_0.internal_data = my_data
  my_data.detection = l_1_0.char_tweak.detection.combat
  my_data.rsrv_pos = {}
  my_data.tmp_vec1 = Vector3()
  if old_internal_data and not old_internal_data.rsrv_pos then
    my_data.rsrv_pos = my_data.rsrv_pos
  end
  local key_str = tostring(l_1_0.key)
  CopLogicTravel.reset_actions(l_1_0, my_data, old_internal_data, CopLogicTravel.allowed_transitional_actions)
  my_data.attitude = l_1_0.objective and l_1_0.objective.attitude or "avoid"
  l_1_0.unit:brain():set_update_enabled_state(false)
  if not l_1_0.attack_sound_t or l_1_0.t - l_1_0.attack_sound_t > 40 then
    l_1_0.attack_sound_t = l_1_0.t
    l_1_0.unit:sound():play("shield_identification", nil, true)
  end
  l_1_0.unit:movement():set_cool(false)
  if my_data ~= l_1_0.internal_data then
    return 
  end
  l_1_0.unit:brain():set_attention_settings({cbt = true})
  my_data.weapon_range = l_1_0.char_tweak.weapon[l_1_0.unit:inventory():equipped_unit():base():weapon_tweak_data().usage].range
  my_data.update_queue_id = "ShieldLogicAttack.queued_update" .. key_str
  ShieldLogicAttack.queue_update(l_1_0, my_data)
end

ShieldLogicAttack.exit = function(l_2_0, l_2_1, l_2_2)
  CopLogicBase.exit(l_2_0, l_2_1, l_2_2)
  local my_data = l_2_0.internal_data
  l_2_0.unit:brain():cancel_all_pathing_searches()
  CopLogicBase.cancel_queued_tasks(my_data)
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

ShieldLogicAttack.queued_update = function(l_3_0)
  local t = TimerManager:game():time()
  l_3_0.t = t
  local unit = l_3_0.unit
  local my_data = l_3_0.internal_data
  ShieldLogicAttack._upd_enemy_detection(l_3_0)
  if my_data ~= l_3_0.internal_data then
    return 
  end
  if not l_3_0.attention_obj or l_3_0.attention_obj.reaction < AIAttentionObject.REACT_AIM then
    ShieldLogicAttack.queue_update(l_3_0, my_data)
    return 
  end
  local focus_enemy = l_3_0.attention_obj
  if not my_data.turning and not l_3_0.unit:movement():chk_action_forbidden("walk") then
    local action_taken = my_data.walking_to_shoot_pos
  end
  if not action_taken and unit:anim_data().stand then
    action_taken = CopLogicAttack._chk_request_action_crouch(l_3_0)
  end
  ShieldLogicAttack._process_pathing_results(l_3_0, my_data)
  local enemy_visible = focus_enemy.verified
  local engage = my_data.attitude == "engage"
  if not my_data.turning and not l_3_0.unit:movement():chk_action_forbidden("walk") then
    local action_taken = my_data.walking_to_optimal_pos
  end
  if not action_taken then
    if unit:anim_data().stand then
      action_taken = CopLogicAttack._chk_request_action_crouch(l_3_0)
    end
    if not action_taken then
      if my_data.pathing_to_optimal_pos then
        do return end
      end
      if my_data.optimal_path then
        ShieldLogicAttack._chk_request_action_walk_to_optimal_pos(l_3_0, my_data)
      elseif my_data.optimal_pos and focus_enemy.nav_tracker then
        local to_pos = my_data.optimal_pos
        my_data.optimal_pos = nil
        local ray_params = {tracker_from = unit:movement():nav_tracker(), pos_to = to_pos, trace = true}
        local ray_res = managers.navigation:raycast(ray_params)
        to_pos = ray_params.trace[1]
        if ray_res then
          local vec = l_3_0.m_pos - to_pos
          mvector3.normalize(vec)
          local fwd = unit:movement():m_fwd()
          local fwd_dot = fwd:dot(vec)
          if fwd_dot > 0 then
            local enemy_tracker = focus_enemy.nav_tracker
            if enemy_tracker:lost() then
              ray_params.tracker_from = nil
              ray_params.pos_from = enemy_tracker:field_position()
            else
              ray_params.tracker_from = enemy_tracker
            end
            ray_res = managers.navigation:raycast(ray_params)
            to_pos = ray_params.trace[1]
          end
        end
        local fwd_bump = nil
        to_pos, fwd_bump = ShieldLogicAttack.chk_wall_distance(l_3_0, my_data, to_pos)
        local do_move = mvector3.distance_sq(to_pos, l_3_0.m_pos) > 10000
        if not do_move then
          local to_pos_current, fwd_bump_current = ShieldLogicAttack.chk_wall_distance(l_3_0, my_data, l_3_0.m_pos)
          if fwd_bump_current then
            do_move = true
          end
        end
        if do_move then
          if my_data.rsrv_pos.path then
            managers.navigation:unreserve_pos(my_data.rsrv_pos.path)
          end
          my_data.pathing_to_optimal_pos = true
          my_data.optimal_path_search_id = tostring(unit:key()) .. "optimal"
          local reservation = managers.navigation:reserve_pos(nil, nil, to_pos, callback(ShieldLogicAttack, ShieldLogicAttack, "_reserve_pos_step_clbk", {unit_pos = l_3_0.m_pos}), 70, l_3_0.pos_rsrv_id)
          if reservation then
            to_pos = reservation.position
          else
            reservation = {position = mvector3.copy(to_pos), radius = 70, filter = l_3_0.pos_rsrv_id}
            managers.navigation:add_pos_reservation(reservation)
          end
          my_data.rsrv_pos.path = reservation
          unit:brain():search_for_path(my_data.optimal_path_search_id, to_pos)
        end
      end
    end
  end
  ShieldLogicAttack.queue_update(l_3_0, my_data)
  CopLogicBase._report_detections(l_3_0.detected_attention_objects)
end

ShieldLogicAttack._reserve_pos_step_clbk = function(l_4_0, l_4_1, l_4_2)
  if not l_4_1.step_vector then
    l_4_1.step_vector = mvector3.copy(l_4_1.unit_pos)
    mvector3.subtract(l_4_1.step_vector, l_4_2)
    l_4_1.distance = mvector3.normalize(l_4_1.step_vector)
    mvector3.set_length(l_4_1.step_vector, 25)
    l_4_1.num_steps = 0
  end
  local step_length = mvector3.length(l_4_1.step_vector)
  if l_4_1.distance < step_length or l_4_1.num_steps > 4 then
    return false
  end
  mvector3.add(l_4_2, l_4_1.step_vector)
  l_4_1.distance = l_4_1.distance - step_length
  mvector3.set_length(l_4_1.step_vector, step_length * 2)
  l_4_1.num_steps = l_4_1.num_steps + 1
  return true
end

ShieldLogicAttack._process_pathing_results = function(l_5_0, l_5_1)
  if l_5_0.pathing_results then
    local pathing_results = l_5_0.pathing_results
    l_5_0.pathing_results = nil
    local path = pathing_results[l_5_1.optimal_path_search_id]
    if path then
      if path ~= "failed" then
        l_5_1.optimal_path = path
      else
        print("[ShieldLogicAttack._process_pathing_results] optimal path failed")
      end
      l_5_1.pathing_to_optimal_pos = nil
      l_5_1.optimal_path_search_id = nil
    end
  end
end

ShieldLogicAttack._chk_request_action_walk_to_optimal_pos = function(l_6_0, l_6_1, l_6_2)
  if not l_6_0.unit:movement():chk_action_forbidden("walk") then
    local new_action_data = {type = "walk", nav_path = l_6_1.optimal_path, variant = "walk", body_part = 2, end_rot = l_6_2}
    l_6_1.optimal_path = nil
    l_6_1.walking_to_optimal_pos = l_6_0.unit:brain():action_request(new_action_data)
    if l_6_1.walking_to_optimal_pos then
      l_6_1.rsrv_pos.move_dest = l_6_1.rsrv_pos.path
      l_6_1.rsrv_pos.path = nil
      if l_6_1.rsrv_pos.stand then
        managers.navigation:unreserve_pos(l_6_1.rsrv_pos.stand)
        l_6_1.rsrv_pos.stand = nil
      end
      if l_6_0.group and l_6_0.group.leader_key == l_6_0.key and l_6_0.char_tweak.chatter.follow_me and mvector3.distance(new_action_data.nav_path[#new_action_data.nav_path], l_6_0.m_pos) > 800 and not l_6_0.unit:sound():speaking(l_6_0.t) then
        managers.groupai:state():chk_say_enemy_chatter(l_6_0.unit, l_6_0.m_pos, "follow_me")
      end
    end
  end
end

ShieldLogicAttack._cancel_optimal_attempt = function(l_7_0, l_7_1)
  if l_7_1.optimal_path then
    l_7_1.optimal_path = nil
  elseif l_7_1.walking_to_optimal_pos then
    local new_action = {type = "idle", body_part = 2}
    l_7_0.unit:brain():action_request(new_action)
  elseif l_7_1.pathing_to_optimal_pos then
    if l_7_1.rsrv_pos.path then
      managers.navigation:unreserve_pos(l_7_1.rsrv_pos.path)
      l_7_1.rsrv_pos.path = nil
    end
    if l_7_0.active_searches[l_7_1.optimal_path_search_id] then
      managers.navigation:cancel_pathing_search(l_7_1.optimal_path_search_id)
      l_7_0.active_searches[l_7_1.optimal_path_search_id] = nil
    elseif l_7_0.pathing_results then
      l_7_0.pathing_results[l_7_1.optimal_path_search_id] = nil
    end
    l_7_1.optimal_path_search_id = nil
    l_7_1.pathing_to_optimal_pos = nil
    l_7_0.unit:brain():cancel_all_pathing_searches()
  end
end

ShieldLogicAttack.queue_update = function(l_8_0, l_8_1)
  CopLogicBase.queue_task(l_8_1, l_8_1.update_queue_id, ShieldLogicAttack.queued_update, l_8_0, l_8_0.t + (l_8_0.important and 0.5 or 1.5), not l_8_0.important or true)
end

ShieldLogicAttack._upd_enemy_detection = function(l_9_0)
  managers.groupai:state():on_unit_detection_updated(l_9_0.unit)
  l_9_0.t = TimerManager:game():time()
  local my_data = l_9_0.internal_data
  local min_reaction = AIAttentionObject.REACT_AIM
  local delay = (CopLogicBase._upd_attention_obj_detection(l_9_0, min_reaction, nil))
  local focus_enemy, focus_enemy_angle, focus_enemy_reaction = nil, nil, nil
  local detected_enemies = l_9_0.detected_attention_objects
  local enemies = {}
  local enemies_cpy = {}
  local passive_enemies = {}
  local threat_epicenter, threats = nil, nil
  local nr_threats = 0
  local verified_chk_t = l_9_0.t - 8
  for key,enemy_data in pairs(detected_enemies) do
    if AIAttentionObject.REACT_SCARED <= enemy_data.reaction and enemy_data.identified and enemy_data.verified_t and verified_chk_t < enemy_data.verified_t then
      enemies[key] = enemy_data
      enemies_cpy[key] = enemy_data
    end
  end
  for key,enemy_data in pairs(enemies) do
    if not threat_epicenter then
      threat_epicenter = Vector3()
    end
    mvector3.add(threat_epicenter, enemy_data.m_pos)
    nr_threats = nr_threats + 1
  end
  if threat_epicenter then
    mvector3.divide(threat_epicenter, nr_threats)
    local from_threat = mvector3.copy(threat_epicenter)
    mvector3.subtract(from_threat, l_9_0.m_pos)
    mvector3.normalize(from_threat)
    local furthest_pt_dist = 0
    local furthest_line = nil
    if not my_data.threat_epicenter or mvector3.distance(threat_epicenter, my_data.threat_epicenter) > 100 then
      my_data.threat_epicenter = mvector3.copy(threat_epicenter)
      for key1,enemy_data1 in pairs(enemies) do
        enemies_cpy[key1] = nil
        for key2,enemy_data2 in pairs(enemies_cpy) do
          if nr_threats == 2 then
            local AB = mvector3.copy(enemy_data1.m_pos)
            mvector3.subtract(AB, enemy_data2.m_pos)
            mvector3.normalize(AB)
            local PA = mvector3.copy(l_9_0.m_pos)
            mvector3.subtract(PA, enemy_data1.m_pos)
            mvector3.normalize(PA)
            local PB = mvector3.copy(l_9_0.m_pos)
            mvector3.subtract(PB, enemy_data2.m_pos)
            mvector3.normalize(PB)
            local dot1 = mvector3.dot(AB, PA)
            local dot2 = mvector3.dot(AB, PB)
            if dot1 >= 0 or dot2 >= 0 then
              if dot1 > 0 and dot2 > 0 then
                for (for control),key1 in (for generator) do
                else
                  furthest_line = {enemy_data1.m_pos, enemy_data2.m_pos}
                  for (for control),key1 in (for generator) do
                  end
                  local pt = math.line_intersection(enemy_data1.m_pos, enemy_data2.m_pos, threat_epicenter, l_9_0.m_pos)
                  local to_pt = mvector3.copy(threat_epicenter)
                  mvector3.subtract(to_pt, pt)
                  mvector3.normalize(to_pt)
                  if mvector3.dot(from_threat, to_pt) > 0 then
                    local line = mvector3.copy(enemy_data2.m_pos)
                    mvector3.subtract(line, enemy_data1.m_pos)
                    local line_len = mvector3.normalize(line)
                    local pt_line = mvector3.copy(pt)
                    mvector3.subtract(pt_line, enemy_data1.m_pos)
                    local dot = mvector3.dot(line, pt_line)
                    if dot < line_len and dot > 0 then
                      local dist = mvector3.distance(pt, threat_epicenter)
                      if furthest_pt_dist < dist then
                        furthest_pt_dist = dist
                        furthest_line = {enemy_data1.m_pos, enemy_data2.m_pos}
                      end
                    end
                  end
                end
              end
            end
          end
          local optimal_direction = nil
          if furthest_line then
            local BA = mvector3.copy(furthest_line[2])
            mvector3.subtract(BA, furthest_line[1])
            local PA = mvector3.copy(furthest_line[1])
            mvector3.subtract(PA, l_9_0.m_pos)
            local out = nil
            if nr_threats == 2 then
              mvector3.normalize(BA)
              local len = mvector3.dot(BA, PA)
              local x = mvector3.copy(furthest_line[1])
              mvector3.multiply(BA, len)
              mvector3.subtract(x, BA)
              out = mvector3.copy(l_9_0.m_pos)
              mvector3.subtract(out, x)
            else
              local EA = mvector3.copy(threat_epicenter)
              mvector3.subtract(EA, furthest_line[1])
              local rot_axis = Vector3()
              mvector3.cross(rot_axis, BA, EA)
              mvector3.set_static(rot_axis, 0, 0, rot_axis.z)
              out = Vector3()
              mvector3.cross(out, BA, rot_axis)
            end
            mvector3.normalize(out)
            optimal_direction = mvector3.copy(out)
            mvector3.multiply(optimal_direction, -1)
            mvector3.multiply(out, mvector3.dot(out, PA) + 600)
            my_data.optimal_pos = mvector3.copy(l_9_0.m_pos)
            mvector3.add(my_data.optimal_pos, out)
          else
            optimal_direction = mvector3.copy(threat_epicenter)
            mvector3.subtract(optimal_direction, l_9_0.m_pos)
            mvector3.normalize(optimal_direction)
            local optimal_length = 0
            for _,enemy in pairs(enemies) do
              local enemy_dir = mvector3.copy(threat_epicenter)
              mvector3.subtract(enemy_dir, enemy.m_pos)
              local len = mvector3.dot(enemy_dir, optimal_direction)
              optimal_length = math.max(len, optimal_length)
            end
            local optimal_pos = mvector3.copy(optimal_direction)
            mvector3.multiply(optimal_pos, -(optimal_length + 600))
            mvector3.add(optimal_pos, threat_epicenter)
            my_data.optimal_pos = optimal_pos
          end
          for key,enemy_data in pairs(enemies) do
            local reaction = CopLogicSniper._chk_reaction_to_attention_object(l_9_0, enemy_data, true)
            if not focus_enemy_reaction or focus_enemy_reaction <= reaction then
              local enemy_dir = my_data.tmp_vec1
              mvector3.direction(enemy_dir, l_9_0.m_pos, enemy_data.m_pos)
              local angle = mvector3.dot(optimal_direction, enemy_dir)
              if l_9_0.attention_obj and key == l_9_0.attention_obj.u_key then
                angle = angle + 0.15000000596046
              end
              if focus_enemy and ((enemy_data.verified and not focus_enemy.verified) or enemy_data.verified or not focus_enemy.verified and focus_enemy_angle < angle) then
                focus_enemy = enemy_data
                focus_enemy_angle = angle
                focus_enemy_reaction = reaction
              end
            end
          end
          CopLogicBase._set_attention_obj(l_9_0, focus_enemy, focus_enemy_reaction)
        else
          local new_attention, new_prio_slot, new_reaction = CopLogicIdle._get_priority_attention(l_9_0, l_9_0.detected_attention_objects, nil)
          local old_att_obj = l_9_0.attention_obj
          CopLogicBase._set_attention_obj(l_9_0, new_attention, new_reaction)
          if new_attention then
            if old_att_obj and old_att_obj.u_key ~= new_attention.u_key then
              CopLogicAttack._cancel_charge(l_9_0, my_data)
              if not l_9_0.unit:movement():chk_action_forbidden("walk") then
                ShieldLogicAttack._cancel_optimal_attempt(l_9_0, my_data)
              end
            end
            if AIAttentionObject.REACT_COMBAT <= new_reaction and new_attention.nav_tracker then
              my_data.optimal_pos = CopLogicAttack._find_flank_pos(l_9_0, my_data, new_attention.nav_tracker)
            elseif old_att_obj and not l_9_0.unit:movement():chk_action_forbidden("walk") then
              ShieldLogicAttack._cancel_optimal_attempt(l_9_0, my_data)
            end
          end
        end
        if l_9_0.attention_obj then
          CopLogicAttack._chk_exit_attack_logic(l_9_0, l_9_0.attention_obj.reaction)
        end
        if my_data ~= l_9_0.internal_data then
          return 
        end
        ShieldLogicAttack._upd_aim(l_9_0, my_data)
        if my_data.optimal_pos and focus_enemy then
          mvector3.set_z(my_data.optimal_pos, focus_enemy.m_pos.z)
        end
         -- Warning: missing end command somewhere! Added here
      end
       -- Warning: missing end command somewhere! Added here
    end
     -- Warning: missing end command somewhere! Added here
  end
end

ShieldLogicAttack.action_complete_clbk = function(l_10_0, l_10_1)
  local my_data = l_10_0.internal_data
  local action_type = l_10_1:type()
  if action_type == "walk" then
    if my_data.rsrv_pos.stand then
      managers.navigation:unreserve_pos(my_data.rsrv_pos.stand)
      my_data.rsrv_pos.stand = nil
    end
    if l_10_1:expired() then
      my_data.rsrv_pos.stand = my_data.rsrv_pos.move_dest
      my_data.rsrv_pos.move_dest = nil
    else
      if my_data.rsrv_pos.move_dest then
        managers.navigation:unreserve_pos(my_data.rsrv_pos.move_dest)
        my_data.rsrv_pos.move_dest = nil
      end
      local reservation = {position = mvector3.copy(l_10_0.m_pos), radius = 70, filter = l_10_0.pos_rsrv_id}
      managers.navigation:add_pos_reservation(reservation)
      my_data.rsrv_pos.stand = reservation
    end
    if my_data.walking_to_optimal_pos then
      my_data.walking_to_optimal_pos = nil
    elseif action_type == "shoot" then
      my_data.shooting = nil
    elseif action_type == "turn" then
      my_data.turning = nil
    elseif action_type == "hurt" and l_10_1:expired() then
      ShieldLogicAttack._upd_aim(l_10_0, my_data)
    end
  end
end

ShieldLogicAttack.is_advancing = function(l_11_0)
  if l_11_0.internal_data.walking_to_optimal_pos then
    return l_11_0.internal_data.rsrv_pos.move_dest.position
  end
end

ShieldLogicAttack._get_all_paths = function(l_12_0)
  return {optimal_path = l_12_0.internal_data.optimal_path}
end

ShieldLogicAttack._set_verified_paths = function(l_13_0, l_13_1)
  l_13_0.internal_data.optimal_path = l_13_1.optimal_path
end

ShieldLogicAttack.chk_wall_distance = function(l_14_0, l_14_1, l_14_2, l_14_3)
  if not l_14_0.char_tweak.wall_fwd_offset then
    return l_14_2
  end
  local my_tracker = managers.navigation:create_nav_tracker(l_14_2)
  local tracker_lost = my_tracker:lost()
  local my_fwd = l_14_0.unit:movement():m_fwd()
  local ray_params = {tracker_from = not tracker_lost and my_tracker or nil, pos_from = tracker_lost and my_tracker:field_position() or nil, pos_to = l_14_2 + my_fwd * l_14_0.char_tweak.wall_fwd_offset, trace = true}
  if not managers.navigation:raycast(ray_params) then
    managers.navigation:destroy_nav_tracker(my_tracker)
    return l_14_2
  end
  local col_pos = ray_params.trace[1]
  local col_side = ray_params.trace[2]
  local correction_vec = ray_params.pos_to - col_pos
  mvector3.multiply(correction_vec, 1.0499999523163)
  local correction_vec_proj = nil
  if col_side == "x_pos" then
    correction_vec_proj = math.X * -mvector3.dot(correction_vec, math.X)
  elseif col_side == "x_neg" then
    correction_vec_proj = math.X * -mvector3.dot(correction_vec, math.X)
  elseif col_side == "y_pos" then
    correction_vec_proj = math.Y * -mvector3.dot(correction_vec, math.Y)
  elseif col_side == "y_neg" then
    correction_vec_proj = math.Y * -mvector3.dot(correction_vec, math.Y)
  end
  local walk_to_pos = l_14_2 + correction_vec_proj
  ray_params.pos_to = walk_to_pos
  if managers.navigation:raycast(ray_params) then
    walk_to_pos = ray_params.trace[1]
  end
  managers.navigation:destroy_nav_tracker(my_tracker)
  if l_14_3 then
    return walk_to_pos, true
  else
    local walk_to_pos2, bump2 = ShieldLogicAttack.chk_wall_distance(l_14_0, l_14_1, walk_to_pos, true)
    return bump2 and walk_to_pos2 or walk_to_pos, true
  end
end


