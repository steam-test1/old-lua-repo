-- Decompiled using luadec 2.0.1 by sztupy (http://winmo.sztupy.hu)
-- Command line was: F:\SteamLibrary\SteamApps\common\PAYDAY 2\lua\lib\managers\mission\elementfleepoint.luac 

core:import("CoreMissionScriptElement")
if not ElementFleePoint then
  ElementFleePoint = class(CoreMissionScriptElement.MissionScriptElement)
end
ElementFleePoint.init = function(l_1_0, ...)
  ElementFleePoint.super.init(l_1_0, ...)
   -- DECOMPILER ERROR: Confused about usage of registers for local variables.

end

ElementFleePoint.on_executed = function(l_2_0, l_2_1)
  if not l_2_0._values.enabled then
    return 
  end
  l_2_0:operation_add()
  ElementFleePoint.super.on_executed(l_2_0, l_2_1)
end

ElementFleePoint.operation_add = function(l_3_0)
  if l_3_0._values.functionality == "loot_drop" then
    managers.groupai:state():add_enemy_loot_drop_point(l_3_0._id, l_3_0._values.position)
  else
    managers.groupai:state():add_flee_point(l_3_0._id, l_3_0._values.position)
  end
end

ElementFleePoint.operation_remove = function(l_4_0)
  if l_4_0._values.functionality == "loot_drop" then
    managers.groupai:state():remove_enemy_loot_drop_point(l_4_0._id)
  else
    managers.groupai:state():remove_flee_point(l_4_0._id)
  end
end


