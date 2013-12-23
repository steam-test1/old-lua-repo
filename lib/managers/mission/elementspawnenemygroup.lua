-- Decompiled using luadec 2.0.1 by sztupy (http://winmo.sztupy.hu)
-- Command line was: F:\SteamLibrary\SteamApps\common\PAYDAY 2\lua\lib\managers\mission\elementspawnenemygroup.luac 

core:import("CoreMissionScriptElement")
if not ElementSpawnEnemyGroup then
  ElementSpawnEnemyGroup = class(CoreMissionScriptElement.MissionScriptElement)
end
ElementSpawnEnemyGroup.init = function(l_1_0, ...)
  ElementSpawnEnemyGroup.super.init(l_1_0, ...)
  l_1_0._group_data = {}
  l_1_0._group_data.amount = l_1_0._values.amount
  l_1_0._group_data.random = l_1_0._values.random
  l_1_0._group_data.ignore_disabled = l_1_0._values.ignore_disabled
  l_1_0._group_data.spawn_points = {}
  l_1_0._unused_randoms = {}
   -- DECOMPILER ERROR: Confused about usage of registers for local variables.

end

ElementSpawnEnemyGroup.on_script_activated = function(l_2_0)
  for i,id in ipairs(l_2_0._values.elements) do
    local element = l_2_0:get_mission_element(id)
    table.insert(l_2_0._unused_randoms, i)
    table.insert(l_2_0._group_data.spawn_points, element)
  end
end

ElementSpawnEnemyGroup.add_event_callback = function(l_3_0, l_3_1, l_3_2)
  for _,id in ipairs(l_3_0._values.elements) do
    local element = l_3_0:get_mission_element(id)
    element:add_event_callback(l_3_1, l_3_2)
  end
end

ElementSpawnEnemyGroup._check_spawn_points = function(l_4_0)
  l_4_0._spawn_points = {}
  if not l_4_0._group_data.ignore_disabled then
    l_4_0._spawn_points = l_4_0._group_data.spawn_points
    return 
  end
  l_4_0._unused_randoms = {}
  local i = 1
  for _,element in pairs(l_4_0._group_data.spawn_points) do
    if element:enabled() then
      table.insert(l_4_0._unused_randoms, i)
      table.insert(l_4_0._spawn_points, element)
      i = i + 1
    end
  end
end

ElementSpawnEnemyGroup.on_executed = function(l_5_0, l_5_1)
  if not l_5_0._values.enabled then
    return 
  end
  l_5_0:_check_spawn_points()
  if #l_5_0._spawn_points > 0 then
    for i = 1, l_5_0._group_data.amount do
      local element = l_5_0._spawn_points[l_5_0:_get_spawn_point(i)]
      element:produce()
    end
  end
  ElementSpawnEnemyGroup.super.on_executed(l_5_0, l_5_1)
end

ElementSpawnEnemyGroup._get_spawn_point = function(l_6_0, l_6_1)
  if l_6_0._group_data.random then
    if #l_6_0._unused_randoms == 0 then
      for i = 1, #l_6_0._spawn_points do
        table.insert(l_6_0._unused_randoms, i)
      end
    end
    local rand = math.random(#l_6_0._unused_randoms)
    return table.remove(l_6_0._unused_randoms, rand)
  end
  return 1 + math.mod(l_6_1, #l_6_0._spawn_points)
end

ElementSpawnEnemyGroup.units = function(l_7_0)
  local all_units = {}
  for _,element in ipairs(l_7_0._group_data.spawn_points) do
    local element_units = element:units()
    for _,unit in ipairs(element_units) do
      table.insert(all_units, unit)
    end
  end
  return all_units
end

ElementSpawnEnemyGroup.unspawn_all_units = function(l_8_0)
  for _,element in ipairs(l_8_0._group_data.spawn_points) do
    element:unspawn_all_units()
  end
end

ElementSpawnEnemyGroup.kill_all_units = function(l_9_0)
  for _,element in ipairs(l_9_0._group_data.spawn_points) do
    element:kill_all_units()
  end
end

ElementSpawnEnemyGroup.execute_on_all_units = function(l_10_0, l_10_1)
  for _,element in ipairs(l_10_0._group_data.spawn_points) do
    element:execute_on_all_units(l_10_1)
  end
end

ElementSpawnEnemyGroup.spawn_points = function(l_11_0)
  return l_11_0._group_data.spawn_points
end

ElementSpawnEnemyGroup.spawn_groups = function(l_12_0)
  return l_12_0._values.preferred_spawn_groups
end


