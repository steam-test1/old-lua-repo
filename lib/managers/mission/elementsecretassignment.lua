-- Decompiled using luadec 2.0.1 by sztupy (http://winmo.sztupy.hu)
-- Command line was: F:\SteamLibrary\SteamApps\common\PAYDAY 2\lua\lib\managers\mission\elementsecretassignment.luac 

core:import("CoreMissionScriptElement")
if not ElementSecretAssignment then
  ElementSecretAssignment = class(CoreMissionScriptElement.MissionScriptElement)
end
ElementSecretAssignment.init = function(l_1_0, ...)
  ElementSecretAssignment.super.init(l_1_0, ...)
   -- DECOMPILER ERROR: Confused about usage of registers for local variables.

end

ElementSecretAssignment.client_on_executed = function(l_2_0, ...)
  l_2_0:on_executed(...)
   -- DECOMPILER ERROR: Confused about usage of registers for local variables.

end

ElementSecretAssignment.on_executed = function(l_3_0, l_3_1)
  if not l_3_0._values.enabled then
    return 
  end
  if l_3_0._values.assignment ~= "none" then
    managers.secret_assignment:set_assignment_enabled(l_3_0._values.assignment, l_3_0._values.set_enabled)
  else
    if Application:editor() then
      managers.editor:output_error("Cant set enabled state on assignment " .. l_3_0._values.assignment .. " in element " .. l_3_0._editor_name .. ".")
    end
  end
  ElementSecretAssignment.super.on_executed(l_3_0, l_3_1)
end


