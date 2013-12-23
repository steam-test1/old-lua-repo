-- Decompiled using luadec 2.0.1 by sztupy (http://winmo.sztupy.hu)
-- Command line was: F:\SteamLibrary\SteamApps\common\PAYDAY 2\lua\lib\managers\mission\elementspecialobjectivetrigger.luac 

core:import("CoreMissionScriptElement")
if not ElementSpecialObjectiveTrigger then
  ElementSpecialObjectiveTrigger = class(CoreMissionScriptElement.MissionScriptElement)
end
ElementSpecialObjectiveTrigger.init = function(l_1_0, ...)
  ElementSpecialObjectiveTrigger.super.init(l_1_0, ...)
   -- DECOMPILER ERROR: Confused about usage of registers for local variables.

end

ElementSpecialObjectiveTrigger.on_script_activated = function(l_2_0)
  for _,id in ipairs(l_2_0._values.elements) do
    local element = l_2_0:get_mission_element(id)
    element:add_event_callback(l_2_0._values.event, callback(l_2_0, l_2_0, "on_executed"))
  end
end

ElementSpecialObjectiveTrigger.on_executed = function(l_3_0, l_3_1)
  if not l_3_0._values.enabled then
    return 
  end
  ElementSpecialObjectiveTrigger.super.on_executed(l_3_0, l_3_1)
end


