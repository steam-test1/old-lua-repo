-- Decompiled using luadec 2.0.1 by sztupy (http://winmo.sztupy.hu)
-- Command line was: F:\SteamLibrary\SteamApps\common\PAYDAY 2\lua\core\lib\managers\coreaidatamanager.luac 

core:module("CoreAiDataManager")
core:import("CoreTable")
if not AiDataManager then
  AiDataManager = class()
end
AiDataManager.init = function(l_1_0)
  l_1_0:_setup()
end

AiDataManager._setup = function(l_2_0)
  l_2_0._data = {}
  l_2_0._data.patrol_paths = {}
end

AiDataManager.add_patrol_path = function(l_3_0, l_3_1)
  if l_3_0._data.patrol_paths[l_3_1] then
    Application:error("Patrol path with name " .. l_3_1 .. " allready exists!")
    return false
  end
  l_3_0._data.patrol_paths[l_3_1] = {points = {}}
  return true
end

AiDataManager.remove_patrol_path = function(l_4_0, l_4_1)
  if not l_4_0._data.patrol_paths[l_4_1] then
    Application:error("Patrol path with name " .. l_4_1 .. " doesnt exists!")
    return false
  end
  l_4_0._data.patrol_paths[l_4_1] = nil
  return true
end

AiDataManager.add_patrol_point = function(l_5_0, l_5_1, l_5_2)
  if not l_5_0._data.patrol_paths[l_5_1] then
    Application:error("Patrol path with name " .. l_5_1 .. " doesn't exist exists!")
    return 
  end
  local t = {position = l_5_2:position(), rotation = l_5_2:rotation(), unit = l_5_2, unit_id = l_5_2:unit_data().unit_id}
  table.insert(l_5_0._data.patrol_paths[l_5_1].points, t)
end

AiDataManager.delete_point_by_unit = function(l_6_0, l_6_1)
  for name,path in pairs(l_6_0._data.patrol_paths) do
    for i,point in ipairs(path.points) do
      if point.unit == l_6_1 then
        table.remove(path.points, i)
        return 
      end
    end
  end
end

AiDataManager.patrol_path_by_unit = function(l_7_0, l_7_1)
  for name,path in pairs(l_7_0._data.patrol_paths) do
    for i,point in ipairs(path.points) do
      if point.unit == l_7_1 then
        return name, path
      end
    end
  end
end

AiDataManager.patrol_point_index_by_unit = function(l_8_0, l_8_1)
  for name,path in pairs(l_8_0._data.patrol_paths) do
    for i,point in ipairs(path.points) do
      if point.unit == l_8_1 then
        return i, point
      end
    end
  end
end

AiDataManager.patrol_path = function(l_9_0, l_9_1)
  return l_9_0._data.patrol_paths[l_9_1]
end

AiDataManager.all_patrol_paths = function(l_10_0)
  return l_10_0._data.patrol_paths
end

AiDataManager.patrol_path_names = function(l_11_0)
  local t = {}
  for name,path in pairs(l_11_0._data.patrol_paths) do
    table.insert(t, name)
  end
  table.sort(t)
  return t
end

AiDataManager.destination_path = function(l_12_0, l_12_1, l_12_2)
  return {points = {{position = l_12_1, rotation = l_12_2}}}
end

AiDataManager.clear = function(l_13_0)
  l_13_0:_setup()
end

AiDataManager.save_data = function(l_14_0)
  local t = CoreTable.deep_clone(l_14_0._data)
  for name,path in pairs(t.patrol_paths) do
    for i,point in ipairs(path.points) do
      point.position = point.unit:position()
      point.rotation = point.unit:rotation()
      point.unit = nil
    end
  end
  return t
end

AiDataManager.load_data = function(l_15_0, l_15_1)
  if not l_15_1 then
    return 
  end
  l_15_0._data = l_15_1
end

AiDataManager.load_units = function(l_16_0, l_16_1)
  for _,unit in ipairs(l_16_1) do
    for name,path in pairs(l_16_0._data.patrol_paths) do
      for i,point in ipairs(path.points) do
        if point.unit_id == unit:unit_data().unit_id then
          point.unit = unit
        end
      end
    end
  end
end


