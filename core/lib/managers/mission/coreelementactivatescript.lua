-- Decompiled using luadec 2.0.1 by sztupy (http://winmo.sztupy.hu)
-- Command line was: F:\SteamLibrary\SteamApps\common\PAYDAY 2\lua\core\lib\managers\mission\coreelementactivatescript.luac 

core:module("CoreElementActivateScript")
core:import("CoreMissionScriptElement")
if not ElementActivateScript then
  ElementActivateScript = class(CoreMissionScriptElement.MissionScriptElement)
end
ElementActivateScript.init = function(l_1_0, ...)
  ElementActivateScript.super.init(l_1_0, ...)
   -- DECOMPILER ERROR: Confused about usage of registers for local variables.

end

ElementActivateScript.client_on_executed = function(l_2_0, ...)
  l_2_0:on_executed(...)
   -- DECOMPILER ERROR: Confused about usage of registers for local variables.

end

ElementActivateScript.on_executed = function(l_3_0, l_3_1)
  if not l_3_0._values.enabled then
    return 
  end
  if l_3_0._values.activate_script ~= "none" then
    managers.mission:activate_script(l_3_0._values.activate_script, l_3_1)
  else
    if Application:editor() then
      managers.editor:output_error("Cant activate script named \"none\" [" .. l_3_0._editor_name .. "]")
    end
  end
  ElementActivateScript.super.on_executed(l_3_0, l_3_1)
end


