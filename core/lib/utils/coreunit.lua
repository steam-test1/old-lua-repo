-- Decompiled using luadec 2.0.1 by sztupy (http://winmo.sztupy.hu)
-- Command line was: F:\SteamLibrary\SteamApps\common\PAYDAY 2\lua\core\lib\utils\coreunit.luac 

core:module("CoreUnit")
core:import("CoreEngineAccess")
core:import("CoreCode")
table.get_ray_ignore_args = function(...)
  do
    local arg_list = {}
    for _,unit in pairs({...}) do
      if CoreCode.alive(unit) then
        table.insert(arg_list, "ignore_unit")
        table.insert(arg_list, unit)
      end
    end
    return unpack(arg_list)
  end
   -- DECOMPILER ERROR: Confused about usage of registers for local variables.

end

get_distance_to_body = function(l_2_0, l_2_1)
  local root_obj = l_2_0:root_object()
  local min_dist = root_obj:distance_to_bounding_volume(l_2_1)
  local child_obj_list = root_obj:children()
  for _,child_obj in ipairs(child_obj_list) do
    local dist = child_obj:distance_to_bounding_volume(l_2_1)
    if dist < min_dist then
      min_dist = dist
    end
  end
  return min_dist
end

reload_units = function(l_3_0)
  local units = World:find_units_quick("all")
  local num_reloads = 0
  PackageManager:reload(Idstring("unit"), l_3_0:id())
  managers.sequence:reload(l_3_0, true)
  if units then
    local reloaded_units = {}
    for i,unit in ipairs(units) do
      if unit:name():id() == l_3_0:id() then
        if not reloaded_units[l_3_0] then
          Application:reload_material_config(unit:material_config():id())
        end
        local pos = unit:position()
        local rot = unit:rotation()
        unit:set_slot(0)
        World:spawn_unit(l_3_0:id(), pos, rot)
        reloaded_units[l_3_0] = true
        num_reloads = num_reloads + 1
      end
    end
  end
  return num_reloads
end

set_unit_and_children_visible = function(l_4_0, l_4_1, l_4_2)
  if l_4_2 == nil or l_4_2(l_4_0) then
    l_4_0:set_visible(l_4_1)
  end
  for _,child in ipairs(l_4_0:children()) do
    set_unit_and_children_visible(child, l_4_1, l_4_2)
  end
end

editor_load_unit = function(l_5_0)
  if Application:editor() then
    CoreEngineAccess._editor_load(Idstring("unit"), l_5_0:id())
    if not managers.sequence:has(l_5_0) then
      managers.sequence:_add_sequences_from_unit_data(CoreEngineAccess._editor_unit_data(l_5_0:id()))
    end
  end
end

safe_spawn_unit = function(l_6_0, ...)
  editor_load_unit(l_6_0)
  return World:spawn_unit(l_6_0:id(), ...)
   -- DECOMPILER ERROR: Confused about usage of registers for local variables.

end

safe_spawn_unit_without_extensions = function(l_7_0, ...)
  editor_load_unit(l_7_0)
  return World:spawn_unit_without_extensions(l_7_0:id(), ...)
   -- DECOMPILER ERROR: Confused about usage of registers for local variables.

end


