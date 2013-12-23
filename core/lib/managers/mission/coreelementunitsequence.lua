-- Decompiled using luadec 2.0.1 by sztupy (http://winmo.sztupy.hu)
-- Command line was: F:\SteamLibrary\SteamApps\common\PAYDAY 2\lua\core\lib\managers\mission\coreelementunitsequence.luac 

core:module("CoreElementUnitSequence")
core:import("CoreMissionScriptElement")
core:import("CoreCode")
core:import("CoreUnit")
if not ElementUnitSequence then
  ElementUnitSequence = class(CoreMissionScriptElement.MissionScriptElement)
end
ElementUnitSequence.init = function(l_1_0, ...)
  ElementUnitSequence.super.init(l_1_0, ...)
  l_1_0._unit = CoreUnit.safe_spawn_unit("core/units/run_sequence_dummy/run_sequence_dummy", l_1_0._values.position)
  managers.worlddefinition:add_trigger_sequence(l_1_0._unit, l_1_0._values.trigger_list)
   -- DECOMPILER ERROR: Confused about usage of registers for local variables.

end

ElementUnitSequence.on_script_activated = function(l_2_0)
  l_2_0._mission_script:add_save_state_cb(l_2_0._id)
end

ElementUnitSequence.client_on_executed = function(l_3_0, ...)
  l_3_0:on_executed(...)
   -- DECOMPILER ERROR: Confused about usage of registers for local variables.

end

ElementUnitSequence.on_executed = function(l_4_0, l_4_1)
  if not l_4_0._values.enabled then
    return 
  end
  l_4_0._unit:damage():run_sequence_simple("run_sequence")
  ElementUnitSequence.super.on_executed(l_4_0, l_4_1)
end

ElementUnitSequence.save = function(l_5_0, l_5_1)
  l_5_1.enabled = l_5_0._values.enabled
end

ElementUnitSequence.load = function(l_6_0, l_6_1)
  l_6_0:set_enabled(l_6_1.enabled)
end


