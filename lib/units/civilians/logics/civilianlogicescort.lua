-- Decompiled using luadec 2.0.1 by sztupy (http://winmo.sztupy.hu)
-- Command line was: F:\SteamLibrary\SteamApps\common\PAYDAY 2\lua\lib\units\civilians\logics\civilianlogicescort.luac 

CivilianLogicEscort = class(CopLogicBase)
CivilianLogicEscort.enter = function(l_1_0, l_1_1, l_1_2)
  CopLogicBase.enter(l_1_0, l_1_1, l_1_2)
  l_1_0.unit:brain():cancel_all_pathing_searches()
  local old_internal_data = l_1_0.internal_data
  local my_data = {unit = l_1_0.unit}
  my_data.rsrv_pos = {}
  if old_internal_data and not old_internal_data.rsrv_pos then
    my_data.rsrv_pos = my_data.rsrv_pos
  end
  l_1_0.unit:brain():set_update_enabled_state(true)
  if l_1_0.char_tweak.escort_idle_talk then
    my_data._say_random_t = Application:time() + 45
  end
  CivilianLogicEscort._get_objective_path_data(l_1_0, my_data)
  l_1_0.internal_data = my_data
  l_1_0.unit:base():set_contour(true)
  l_1_0.unit:movement():set_cool(false, "escort")
  l_1_0.unit:movement():set_stance("hos")
  if l_1_0.unit:anim_data().tied then
    local action_data = {type = "act", body_part = 1, variant = "panic", clamp_to_graph = true}
    l_1_0.unit:brain():action_request(action_data)
  end
  if not l_1_0.been_outlined and l_1_0.char_tweak.outline_on_discover then
    my_data.outline_detection_task_key = "CivilianLogicIdle._upd_outline_detection" .. tostring(l_1_0.key)
    CopLogicBase.queue_task(my_data, my_data.outline_detection_task_key, CivilianLogicIdle._upd_outline_detection, l_1_0, l_1_0.t + 2)
  end
end

CivilianLogicEscort.exit = function(l_2_0, l_2_1, l_2_2)
  CopLogicBase.exit(l_2_0, l_2_1, l_2_2)
  local my_data = l_2_0.internal_data
  l_2_0.unit:brain():cancel_all_pathing_searches()
  CopLogicBase.cancel_queued_tasks(my_data)
  l_2_0.unit:base():set_contour(false)
  if l_2_1 ~= "inactive" then
    l_2_0.unit:brain():set_update_enabled_state(true)
  end
end

CivilianLogicEscort.update = function(l_3_0)
  local my_data = l_3_0.internal_data
  local unit = l_3_0.unit
  local objective = l_3_0.objective
  local t = l_3_0.t
  if my_data._say_random_t and my_data._say_random_t < t then
    l_3_0.unit:sound():say("a02", true)
    my_data._say_random_t = t + math.random(30, 60)
  end
  if CivilianLogicEscort.too_scared_to_move(l_3_0) and not l_3_0.unit:anim_data().panic then
    my_data.commanded_to_move = nil
    l_3_0.unit:movement():action_request({type = "act", body_part = 1, variant = "panic", clamp_to_graph = true})
  end
  if my_data.processing_advance_path or my_data.processing_coarse_path then
    CivilianLogicEscort._upd_pathing(l_3_0, my_data)
  elseif not my_data.advancing then
    if my_data.getting_up then
      do return end
    end
    if my_data.advance_path and my_data.commanded_to_move then
      if l_3_0.unit:anim_data().standing_hesitant then
        CivilianLogicEscort._begin_advance_action(l_3_0, my_data)
      else
        CivilianLogicEscort._begin_stand_hesitant_action(l_3_0, my_data)
        do return end
        if objective then
          if my_data.coarse_path then
            local coarse_path = my_data.coarse_path
            local cur_index = my_data.coarse_path_index
            local total_nav_points = #coarse_path
            if cur_index == total_nav_points then
              objective.in_place = true
              managers.groupai:state():on_civilian_objective_complete(unit, objective)
              return 
            else
              my_data.rsrv_pos.path = nil
              local to_pos = coarse_path[cur_index + 1][2]
              my_data.advance_path_search_id = tostring(unit:key()) .. "advance"
              my_data.processing_advance_path = true
              unit:brain():search_for_path(my_data.advance_path_search_id, to_pos)
            end
          else
            local search_id = tostring(unit:key()) .. "coarse"
            if unit:brain():search_for_coarse_path(search_id, objective.nav_seg) then
              my_data.coarse_path_search_id = search_id
              my_data.processing_coarse_path = true
            else
              CopLogicBase._exit(l_3_0.unit, "idle")
            end
          end
        end
      end
    end
  end
end
end

CivilianLogicEscort.on_intimidated = function(l_4_0, l_4_1, l_4_2)
  local scared_reason = CivilianLogicEscort.too_scared_to_move(l_4_0)
  if scared_reason then
    l_4_0.unit:sound():say("a01", true)
  else
    l_4_0.internal_data.commanded_to_move = true
  end
end

CivilianLogicEscort.action_complete_clbk = function(l_5_0, l_5_1)
  CopLogicTravel.action_complete_clbk(l_5_0, l_5_1)
  local my_data = l_5_0.internal_data
  local action_type = l_5_1:type()
  if action_type == "walk" then
    my_data.advancing = nil
  elseif action_type == "act" and my_data.getting_up then
    my_data.getting_up = nil
  end
end

CivilianLogicEscort._upd_pathing = function(l_6_0, l_6_1)
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
        print("[CivilianLogicEscort:_upd_pathing] advance_path failed")
        managers.groupai:state():on_civilian_objective_failed(l_6_0.unit, l_6_0.objective)
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
      else
        managers.groupai:state():on_civilian_objective_failed(l_6_0.unit, l_6_0.objective)
        return 
      end
    end
     -- Warning: missing end command somewhere! Added here
  end
end

CivilianLogicEscort.on_new_objective = function(l_7_0, l_7_1)
  CivilianLogicIdle.on_new_objective(l_7_0, l_7_1)
end

CivilianLogicEscort.damage_clbk = function(l_8_0, l_8_1)
end

CivilianLogicEscort._get_objective_path_data = function(l_9_0, l_9_1)
  local objective = l_9_0.objective
  local path_data = objective.path_data
  local path_style = objective.path_style
   -- DECOMPILER ERROR: No list found. Setlist fails

  if path_data then
    if path_style == "precise" then
      local path = {}
       -- DECOMPILER ERROR: Overwrote pending register.

      for _,point in mvector3.copy(l_9_0.m_pos)(path_data.points) do
        table.insert(path, point.position)
      end
      l_9_1.advance_path = path
      l_9_1.coarse_path_index = 1
      local start_seg = l_9_0.unit:movement():nav_tracker():nav_segment()
      local end_pos = mvector3.copy(path[#path])
      local end_seg = managers.navigation:get_nav_seg_from_pos(end_pos)
      l_9_1.coarse_path = {{start_seg}, {end_seg, end_pos}}
    elseif path_style == "coarse" then
      local t_ins = table.insert
      l_9_1.coarse_path_index = 1
      local start_seg = l_9_0.unit:movement():nav_tracker():nav_segment()
      l_9_1.coarse_path = {{start_seg}}
      local coarse_path = l_9_1.coarse_path
      local points = path_data.points
      local i_point = 1
      repeat
        if i_point <= #path_data.points then
          local next_pos = points[i_point].position
          do
            local next_seg = managers.navigation:get_nav_seg_from_pos(next_pos)
            t_ins(coarse_path, {})
          end
          do return end
        elseif path_style == "destination" then
          local start_seg = l_9_0.unit:movement():nav_tracker():nav_segment()
          local end_pos = mvector3.copy(path_data.points[#path_data.points].position)
           -- DECOMPILER ERROR: Overwrote pending register.

          local end_seg = managers.navigation:get_nav_seg_from_pos(i_point)
        end
      end
    end
     -- Warning: undefined locals caused missing assignments!
     -- Warning: missing end command somewhere! Added here
  end
end

CivilianLogicEscort.too_scared_to_move = function(l_10_0)
  local my_data = l_10_0.internal_data
  local nobody_close = true
  local min_dis_sq = 1000000
  for c_key,c_data in pairs(managers.groupai:state():all_criminals()) do
    if mvector3.distance_sq(c_data.m_pos, l_10_0.m_pos) < min_dis_sq then
      nobody_close = nil
  else
    end
  end
  if nobody_close then
    return "abandoned"
  end
  local nobody_close = true
  local min_dis_sq = tweak_data.character[l_10_0.unit:base()._tweak_table].escort_scared_dist
  min_dis_sq = min_dis_sq * min_dis_sq
  for c_key,c_data in pairs(managers.enemy:all_enemies()) do
    if not c_data.unit:anim_data().surrender and c_data.unit:brain()._current_logic_name ~= "trade" and mvector3.distance_sq(c_data.m_pos, l_10_0.m_pos) < min_dis_sq and math.abs(c_data.m_pos.z - l_10_0.m_pos.z) < 250 then
      nobody_close = nil
  else
    end
  end
  if not nobody_close then
    return "pigs"
  end
  return 
end

CivilianLogicEscort._begin_advance_action = function(l_11_0, l_11_1)
  CopLogicAttack._correct_path_start_pos(l_11_0, l_11_1.advance_path)
  local objective = l_11_0.objective
  local haste = objective and objective.haste or "run"
  local new_action_data = {type = "walk", nav_path = l_11_1.advance_path, variant = haste, body_part = 2}
  l_11_1.advancing = l_11_0.unit:brain():action_request(new_action_data)
  if l_11_1.advancing then
    l_11_1.advance_path = nil
    l_11_1.rsrv_pos.move_dest = l_11_1.rsrv_pos.path
    l_11_1.rsrv_pos.path = nil
    if l_11_1.rsrv_pos.stand then
      managers.navigation:unreserve_pos(l_11_1.rsrv_pos.stand)
      l_11_1.rsrv_pos.stand = nil
    else
      debug_pause("[CivilianLogicEscort._begin_advance_action] failed to start")
    end
  end
end

CivilianLogicEscort._begin_stand_hesitant_action = function(l_12_0, l_12_1)
  local action = {type = "act", variant = "so_escort_get_up_hesitant", body_part = 1, clamp_to_graph = true, blocks = {action = -1, walk = -1, hurt = -1, heavy_hurt = -1}}
  l_12_1.getting_up = l_12_0.unit:movement():action_request(action)
end

CivilianLogicEscort._get_all_paths = function(l_13_0)
  return {advance_path = l_13_0.internal_data.advance_path}
end

CivilianLogicEscort._set_verified_paths = function(l_14_0, l_14_1)
  l_14_0.internal_data.stare_path = l_14_1.stare_path
end


