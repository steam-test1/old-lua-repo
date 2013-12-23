-- Decompiled using luadec 2.0.1 by sztupy (http://winmo.sztupy.hu)
-- Command line was: F:\SteamLibrary\SteamApps\common\PAYDAY 2\lua\lib\managers\mission\elementscenarioevent.luac 

core:import("CoreMissionScriptElement")
if not ElementScenarioEvent then
  ElementScenarioEvent = class(CoreMissionScriptElement.MissionScriptElement)
end
ElementScenarioEvent.init = function(l_1_0, ...)
  ElementScenarioEvent.super.init(l_1_0, ...)
  l_1_0._network_execute = true
   -- DECOMPILER ERROR: Confused about usage of registers for local variables.

end

ElementScenarioEvent.client_on_executed = function(l_2_0, ...)
   -- DECOMPILER ERROR: Confused about usage of registers for local variables.

end

ElementScenarioEvent.on_executed = function(l_3_0, l_3_1)
  if not l_3_0._values.enabled then
    return 
  end
  ElementScenarioEvent.super.on_executed(l_3_0, l_3_1)
end

ElementScenarioEvent.operation_add = function(l_4_0)
  local event_decriptor = {amount = l_4_0._values.amount, task_type = l_4_0._values.task, element = l_4_0, pos = l_4_0._values.position, rot = l_4_0._values.rotation, base_chance = l_4_0._values.base_chance or 1, chance_inc = l_4_0._values.chance_inc or 0}
  managers.groupai:state():add_spawn_event(l_4_0._id, event_decriptor)
end

ElementScenarioEvent.operation_remove = function(l_5_0)
  managers.groupai:state():remove_spawn_event(l_5_0._id)
end


