-- Decompiled using luadec 2.0.1 by sztupy (http://winmo.sztupy.hu)
-- Command line was: F:\SteamLibrary\SteamApps\common\PAYDAY 2\lua\lib\managers\spawnmanager.luac 

if not SpawnManager then
  SpawnManager = class()
end
SpawnManager.init = function(l_1_0)
  l_1_0._spawn_requests = {}
end

SpawnManager.spawn_enemy_group_in_vis_group = function(l_2_0, l_2_1, l_2_2)
  do
    local spawn_request = {}
    spawn_request.groups = {}
    for unit_name,unit_data in pairs(l_2_1.groups) do
      spawn_request.groups[unit_name] = {amount = unit_data.amount}
    end
    spawn_request.ai = l_2_1.ai
    for unit_name,unit_data in pairs(spawn_request.groups) do
      local spawn_positions = {}
      local i = 1
      repeat
        if i <= unit_data.amount then
          local new_pos = managers.navigation:find_random_position_in_visibility_group(l_2_2)
          table.insert(spawn_positions, new_pos)
          i = i + 1
        else
          unit_data.positions = spawn_positions
        end
        if not l_2_0._spawn_requests then
          l_2_0._spawn_requests = {}
        end
        table.insert(l_2_0._spawn_requests, spawn_request)
        return l_2_0:_spawn_units()
      end
       -- Warning: missing end command somewhere! Added here
    end
     -- Warning: missing end command somewhere! Added here
  end
end

SpawnManager.spawn_enemy_group = function(l_3_0, l_3_1)
  local spawn_request = {}
  spawn_request.groups = {}
  for unit_name,unit_data in pairs(l_3_1.groups) do
    spawn_request.groups[unit_name] = {amount = unit_data.amount}
  end
  spawn_request.ai = l_3_1.ai
  do
    local criminals = World:find_units_quick("all", managers.slot:get_mask("players"))
    if #criminals > 0 then
      local hide_from_trackers = {}
      for _,criminal_unit in ipairs(criminals) do
        table.insert(hide_from_trackers, criminal_unit:movement():nav_tracker())
      end
      local vis_group_pos, i_vis_group = managers.navigation:find_hide_position({trackers = hide_from_trackers})
      if i_vis_group then
        for unit_name,unit_data in pairs(spawn_request.groups) do
          local spawn_positions = {}
          local i = 1
          repeat
            if i <= unit_data.amount then
              local new_pos = managers.navigation:find_random_position_in_visibility_group(i_vis_group)
              table.insert(spawn_positions, new_pos)
              i = i + 1
            else
              unit_data.positions = spawn_positions
            end
          end
        else
          print("SpawnManager:spawn_enemy_group() Could not find a hidden position. Cancelling spawn")
          return 
        end
      else
        local new_pos, i_vis_group = managers.navigation:find_random_position()
        for unit_name,unit_data in pairs(spawn_request.groups) do
          local spawn_positions = {}
          local i = 1
          repeat
            if i <= unit_data.amount then
              local new_pos = managers.navigation:find_random_position_in_visibility_group(i_vis_group)
              table.insert(spawn_positions, new_pos)
              i = i + 1
            else
              unit_data.positions = spawn_positions
            end
          end
        end
        if not l_3_0._spawn_requests then
          l_3_0._spawn_requests = {}
        end
        table.insert(l_3_0._spawn_requests, spawn_request)
        return l_3_0:_spawn_units()
      end
       -- Warning: missing end command somewhere! Added here
    end
     -- Warning: missing end command somewhere! Added here
  end
end

SpawnManager.update = function(l_4_0, l_4_1, l_4_2, l_4_3)
end

SpawnManager._spawn_units = function(l_5_0)
  if l_5_0._spawn_requests then
    local units_spawned = {}
    local trash_requests = nil
    for request_id,spawn_request in pairs(l_5_0._spawn_requests) do
      local trash_groups = nil
      for unit_name,unit_data in pairs(spawn_request.groups) do
        if unit_data.amount == 1 then
          if not trash_groups then
            trash_groups = {}
          end
          trash_groups[unit_name] = true
        else
          unit_data.amount = unit_data.amount - 1
        end
        local new_unit = World:spawn_unit(Idstring(unit_name), unit_data.positions[#unit_data.positions], Rotation(math.UP, math.random() * 360))
        if spawn_request.ai then
          local ai_instance = {}
          for k,v in pairs(spawn_request.ai) do
            ai_instance[k] = v
          end
          new_unit:brain():set_spawn_ai(ai_instance)
        end
        table.remove(unit_data.positions)
        table.insert(units_spawned, new_unit)
      end
      if trash_groups then
        for unit_name,_ in pairs(trash_groups) do
          spawn_request.groups[unit_name] = nil
        end
      end
      if not next(spawn_request.groups) and not trash_requests then
        trash_requests = {}
      end
      trash_requests[request_id] = true
    end
    if trash_requests then
      for request_id,_ in pairs(trash_requests) do
        l_5_0._spawn_requests[request_id] = nil
      end
    end
    if not next(l_5_0._spawn_requests) then
      l_5_0._spawn_requests = nil
    end
    return units_spawned
  end
end


