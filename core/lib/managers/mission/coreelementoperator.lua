-- Decompiled using luadec 2.0.1 by sztupy (http://winmo.sztupy.hu)
-- Command line was: F:\SteamLibrary\SteamApps\common\PAYDAY 2\lua\core\lib\managers\mission\coreelementoperator.luac 

core:module("CoreElementOperator")
core:import("CoreMissionScriptElement")
if not ElementOperator then
  ElementOperator = class(CoreMissionScriptElement.MissionScriptElement)
end
ElementOperator.init = function(l_1_0, ...)
  ElementOperator.super.init(l_1_0, ...)
   -- DECOMPILER ERROR: Confused about usage of registers for local variables.

end

ElementOperator.client_on_executed = function(l_2_0, ...)
  l_2_0:on_executed(...)
   -- DECOMPILER ERROR: Confused about usage of registers for local variables.

end

ElementOperator.on_executed = function(l_3_0, l_3_1)
  if not l_3_0._values.enabled then
    return 
  end
  for _,id in ipairs(l_3_0._values.elements) do
    local element = l_3_0:get_mission_element(id)
    if element then
      if l_3_0._values.operation == "add" then
        element:operation_add()
        for (for control),_ in (for generator) do
        end
        if l_3_0._values.operation == "remove" then
          element:operation_remove()
        end
      end
    end
    ElementOperator.super.on_executed(l_3_0, l_3_1)
     -- Warning: missing end command somewhere! Added here
  end
end


