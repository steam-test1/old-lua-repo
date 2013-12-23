-- Decompiled using luadec 2.0.1 by sztupy (http://winmo.sztupy.hu)
-- Command line was: F:\SteamLibrary\SteamApps\common\PAYDAY 2\lua\core\lib\managers\mission\coreelementunitsequencetrigger.luac 

core:module("CoreElementUnitSequenceTrigger")
core:import("CoreMissionScriptElement")
core:import("CoreCode")
if not ElementUnitSequenceTrigger then
  ElementUnitSequenceTrigger = class(CoreMissionScriptElement.MissionScriptElement)
end
ElementUnitSequenceTrigger.init = function(l_1_0, ...)
  ElementUnitSequenceTrigger.super.init(l_1_0, ...)
  if not l_1_0._values.sequence_list and l_1_0._values.sequence then
    l_1_0._values.sequence_list = {{unit_id = l_1_0._values.unit_id, sequence = l_1_0._values.sequence}}
     -- DECOMPILER ERROR: Confused about usage of registers for local variables.

  end
end

ElementUnitSequenceTrigger.on_script_activated = function(l_2_0)
  if Network:is_client() then
    do return end
  end
  l_2_0._mission_script:add_save_state_cb(l_2_0._id)
  for _,data in pairs(l_2_0._values.sequence_list) do
    managers.mission:add_runned_unit_sequence_trigger(data.unit_id, data.sequence, callback(l_2_0, l_2_0, "on_executed"))
  end
  l_2_0._has_active_callback = true
end

ElementUnitSequenceTrigger.send_to_host = function(l_3_0, l_3_1)
  if alive(l_3_1) then
    managers.network:session():send_to_host("to_server_mission_element_trigger", l_3_0._id, l_3_1)
  end
end

ElementUnitSequenceTrigger.on_executed = function(l_4_0, l_4_1)
  if not l_4_0._values.enabled then
    return 
  end
  ElementUnitSequenceTrigger.super.on_executed(l_4_0, l_4_1)
end

ElementUnitSequenceTrigger.save = function(l_5_0, l_5_1)
  l_5_1.save_me = true
end

ElementUnitSequenceTrigger.load = function(l_6_0, l_6_1)
  if not l_6_0._has_active_callback then
    l_6_0:on_script_activated()
  end
end


