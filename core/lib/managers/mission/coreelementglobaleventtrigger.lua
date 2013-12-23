-- Decompiled using luadec 2.0.1 by sztupy (http://winmo.sztupy.hu)
-- Command line was: F:\SteamLibrary\SteamApps\common\PAYDAY 2\lua\core\lib\managers\mission\coreelementglobaleventtrigger.luac 

core:module("CoreElementGlobalEventTrigger")
core:import("CoreMissionScriptElement")
core:import("CoreCode")
if not ElementGlobalEventTrigger then
  ElementGlobalEventTrigger = class(CoreMissionScriptElement.MissionScriptElement)
end
ElementGlobalEventTrigger.init = function(l_1_0, ...)
  ElementGlobalEventTrigger.super.init(l_1_0, ...)
   -- DECOMPILER ERROR: Confused about usage of registers for local variables.

end

ElementGlobalEventTrigger.on_script_activated = function(l_2_0)
  managers.mission:add_global_event_listener(l_2_0._id, {l_2_0._values.global_event}, callback(l_2_0, l_2_0, Network:is_client() and "send_to_host" or "on_executed"))
end

ElementGlobalEventTrigger.send_to_host = function(l_3_0, l_3_1)
  if l_3_1 then
    managers.network:session():send_to_host("to_server_mission_element_trigger", l_3_0._id, l_3_1)
  end
end

ElementGlobalEventTrigger.on_executed = function(l_4_0, l_4_1)
  if not l_4_0._values.enabled then
    return 
  end
  ElementGlobalEventTrigger.super.on_executed(l_4_0, l_4_1)
end


