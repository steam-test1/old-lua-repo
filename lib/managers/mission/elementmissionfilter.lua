-- Decompiled using luadec 2.0.1 by sztupy (http://winmo.sztupy.hu)
-- Command line was: F:\SteamLibrary\SteamApps\common\PAYDAY 2\lua\lib\managers\mission\elementmissionfilter.luac 

core:import("CoreMissionScriptElement")
if not ElementMissionFilter then
  ElementMissionFilter = class(CoreMissionScriptElement.MissionScriptElement)
end
ElementMissionFilter.init = function(l_1_0, ...)
  ElementMissionFilter.super.init(l_1_0, ...)
   -- DECOMPILER ERROR: Confused about usage of registers for local variables.

end

ElementMissionFilter.client_on_executed = function(l_2_0, ...)
  l_2_0:on_executed(...)
   -- DECOMPILER ERROR: Confused about usage of registers for local variables.

end

ElementMissionFilter.on_executed = function(l_3_0, l_3_1)
  if not l_3_0._values.enabled then
    return 
  end
  if not l_3_0:_check_mission_filters() then
    return 
  end
  ElementMissionFilter.super.on_executed(l_3_0, l_3_1)
end

ElementMissionFilter._check_mission_filters = function(l_4_0)
  if l_4_0._values[1] and managers.mission:check_mission_filter(1) then
    return true
  end
  if l_4_0._values[2] and managers.mission:check_mission_filter(2) then
    return true
  end
  if l_4_0._values[3] and managers.mission:check_mission_filter(3) then
    return true
  end
  if l_4_0._values[4] and managers.mission:check_mission_filter(4) then
    return true
  end
  if l_4_0._values[5] and managers.mission:check_mission_filter(5) then
    return true
  end
  return false
end


