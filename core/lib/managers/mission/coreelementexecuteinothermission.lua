-- Decompiled using luadec 2.0.1 by sztupy (http://winmo.sztupy.hu)
-- Command line was: F:\SteamLibrary\SteamApps\common\PAYDAY 2\lua\core\lib\managers\mission\coreelementexecuteinothermission.luac 

core:module("CoreElementExecuteInOtherMission")
core:import("CoreMissionScriptElement")
if not ElementExecuteInOtherMission then
  ElementExecuteInOtherMission = class(CoreMissionScriptElement.MissionScriptElement)
end
ElementExecuteInOtherMission.init = function(l_1_0, ...)
  ElementExecuteInOtherMission.super.init(l_1_0, ...)
   -- DECOMPILER ERROR: Confused about usage of registers for local variables.

end

ElementExecuteInOtherMission.client_on_executed = function(l_2_0, ...)
  l_2_0:on_executed(...)
   -- DECOMPILER ERROR: Confused about usage of registers for local variables.

end

ElementExecuteInOtherMission.get_mission_element = function(l_3_0, l_3_1)
  for name,script in pairs(managers.mission:scripts()) do
    if script:element(l_3_1) then
      print("found in", name, l_3_1)
      return script:element(l_3_1)
    end
  end
end


