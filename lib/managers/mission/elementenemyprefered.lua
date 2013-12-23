-- Decompiled using luadec 2.0.1 by sztupy (http://winmo.sztupy.hu)
-- Command line was: F:\SteamLibrary\SteamApps\common\PAYDAY 2\lua\lib\managers\mission\elementenemyprefered.luac 

core:import("CoreMissionScriptElement")
if not ElementEnemyPreferedAdd then
  ElementEnemyPreferedAdd = class(CoreMissionScriptElement.MissionScriptElement)
end
ElementEnemyPreferedAdd.init = function(l_1_0, ...)
  ElementEnemyPreferedAdd.super.init(l_1_0, ...)
   -- DECOMPILER ERROR: Confused about usage of registers for local variables.

end

ElementEnemyPreferedAdd.on_script_activated = function(l_2_0)
  if not l_2_0._values.spawn_points then
    l_2_0._values.spawn_points = l_2_0._values.elements
  end
  if not l_2_0._values.spawn_points and not l_2_0._values.spawn_groups then
    return 
  end
  l_2_0._group_data = {}
  if l_2_0._values.spawn_points then
    l_2_0._group_data.spawn_points = {}
    for _,id in ipairs(l_2_0._values.spawn_points) do
      local element = l_2_0:get_mission_element(id)
      table.insert(l_2_0._group_data.spawn_points, element)
    end
  end
  if l_2_0._values.spawn_groups then
    l_2_0._group_data.spawn_groups = {}
    for _,id in ipairs(l_2_0._values.spawn_groups) do
      local element = l_2_0:get_mission_element(id)
      table.insert(l_2_0._group_data.spawn_groups, element)
    end
  end
end

ElementEnemyPreferedAdd.add = function(l_3_0)
  if not l_3_0._group_data then
    return 
  end
  if l_3_0._group_data.spawn_points then
    managers.groupai:state():add_preferred_spawn_points(l_3_0._id, l_3_0._group_data.spawn_points)
  end
  if l_3_0._group_data.spawn_groups then
    managers.groupai:state():add_preferred_spawn_groups(l_3_0._id, l_3_0._group_data.spawn_groups)
  end
end

ElementEnemyPreferedAdd.remove = function(l_4_0)
  managers.groupai:state():remove_preferred_spawn_points(l_4_0._id)
end

ElementEnemyPreferedAdd.on_executed = function(l_5_0, l_5_1)
  if not l_5_0._values.enabled then
    return 
  end
  l_5_0:add()
  ElementEnemyPreferedAdd.super.on_executed(l_5_0, l_5_1)
end

if not ElementEnemyPreferedRemove then
  ElementEnemyPreferedRemove = class(CoreMissionScriptElement.MissionScriptElement)
end
ElementEnemyPreferedRemove.init = function(l_6_0, ...)
  ElementEnemyPreferedRemove.super.init(l_6_0, ...)
   -- DECOMPILER ERROR: Confused about usage of registers for local variables.

end

ElementEnemyPreferedRemove.on_executed = function(l_7_0, l_7_1)
  if not l_7_0._values.enabled then
    return 
  end
  for _,id in ipairs(l_7_0._values.elements) do
    local element = l_7_0:get_mission_element(id)
    if element then
      element:remove()
    end
  end
  ElementEnemyPreferedRemove.super.on_executed(l_7_0, l_7_1)
end


