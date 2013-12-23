-- Decompiled using luadec 2.0.1 by sztupy (http://winmo.sztupy.hu)
-- Command line was: F:\SteamLibrary\SteamApps\common\PAYDAY 2\lua\lib\managers\mission\elementgamedirection.luac 

core:import("CoreMissionScriptElement")
if not ElementGameDirection then
  ElementGameDirection = class(CoreMissionScriptElement.MissionScriptElement)
end
ElementGameDirection.init = function(l_1_0, ...)
  ElementGameDirection.super.init(l_1_0, ...)
   -- DECOMPILER ERROR: Confused about usage of registers for local variables.

end

ElementGameDirection.on_executed = function(l_2_0, l_2_1)
  if not l_2_0._values.enabled then
    return 
  end
  managers.groupai:state():set_mission_fwd_vector(l_2_0._values.rotation:y(), l_2_0._values.position)
  ElementGameDirection.super.on_executed(l_2_0, l_2_1)
end


