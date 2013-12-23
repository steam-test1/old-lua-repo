-- Decompiled using luadec 2.0.1 by sztupy (http://winmo.sztupy.hu)
-- Command line was: F:\SteamLibrary\SteamApps\common\PAYDAY 2\lua\lib\managers\mission\elementareaminpoliceforce.luac 

core:import("CoreMissionScriptElement")
if not ElementAreaMinPoliceForce then
  ElementAreaMinPoliceForce = class(CoreMissionScriptElement.MissionScriptElement)
end
ElementAreaMinPoliceForce.init = function(l_1_0, ...)
  ElementAreaMinPoliceForce.super.init(l_1_0, ...)
  l_1_0._network_execute = true
   -- DECOMPILER ERROR: Confused about usage of registers for local variables.

end

ElementAreaMinPoliceForce.on_executed = function(l_2_0, l_2_1)
  if not l_2_0._values.enabled then
    return 
  end
  l_2_0:operation_add()
  ElementAreaMinPoliceForce.super.on_executed(l_2_0, l_2_1)
end

ElementAreaMinPoliceForce.operation_add = function(l_3_0)
  managers.groupai:state():set_area_min_police_force(l_3_0._id, l_3_0._values.amount, l_3_0._values.position)
end

ElementAreaMinPoliceForce.operation_remove = function(l_4_0)
  managers.groupai:state():set_area_min_police_force(l_4_0._id)
end


