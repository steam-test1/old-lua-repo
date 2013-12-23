-- Decompiled using luadec 2.0.1 by sztupy (http://winmo.sztupy.hu)
-- Command line was: F:\SteamLibrary\SteamApps\common\PAYDAY 2\lua\lib\utils\dev\editor\worlddefinition.luac 

core:import("CoreWorldDefinition")
if not WorldDefinition then
  WorldDefinition = class(CoreWorldDefinition.WorldDefinition)
end
WorldDefinition.init = function(l_1_0, ...)
  WorldDefinition.super.init(l_1_0, ...)
   -- DECOMPILER ERROR: Confused about usage of registers for local variables.

end

WorldDefinition._project_assign_unit_data = function(l_2_0, l_2_1, l_2_2)
  if not Application:editor() and l_2_1:unit_data().secret_assignment_id then
    managers.secret_assignment:register_unit(l_2_1)
  end
end

WorldDefinition.get_cover_data = function(l_3_0)
  local path = l_3_0:world_dir() .. "cover_data"
  if not DB:has("cover_data", path) then
    return false
  end
  return l_3_0:_serialize_to_script("cover_data", path)
end

CoreClass.override_class(CoreWorldDefinition.WorldDefinition, WorldDefinition)

