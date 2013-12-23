-- Decompiled using luadec 2.0.1 by sztupy (http://winmo.sztupy.hu)
-- Command line was: F:\SteamLibrary\SteamApps\common\PAYDAY 2\lua\lib\managers\mission\missionscriptelement.luac 

core:import("CoreMissionScriptElement")
core:import("CoreClass")
if not MissionScriptElement then
  MissionScriptElement = class(CoreMissionScriptElement.MissionScriptElement)
end
MissionScriptElement.init = function(l_1_0, ...)
  MissionScriptElement.super.init(l_1_0, ...)
   -- DECOMPILER ERROR: Confused about usage of registers for local variables.

end

MissionScriptElement.client_on_executed = function(l_2_0)
end

MissionScriptElement.on_executed = function(l_3_0, ...)
  if Network:is_client() then
    return 
  end
  MissionScriptElement.super.on_executed(l_3_0, ...)
   -- DECOMPILER ERROR: Confused about usage of registers for local variables.

end

CoreClass.override_class(CoreMissionScriptElement.MissionScriptElement, MissionScriptElement)

