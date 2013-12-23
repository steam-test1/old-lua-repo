-- Decompiled using luadec 2.0.1 by sztupy (http://winmo.sztupy.hu)
-- Command line was: F:\SteamLibrary\SteamApps\common\PAYDAY 2\lua\core\lib\managers\mission\coreelementdebug.luac 

core:module("CoreElementDebug")
core:import("CoreMissionScriptElement")
if not ElementDebug then
  ElementDebug = class(CoreMissionScriptElement.MissionScriptElement)
end
ElementDebug.init = function(l_1_0, ...)
  ElementDebug.super.init(l_1_0, ...)
   -- DECOMPILER ERROR: Confused about usage of registers for local variables.

end

ElementDebug.client_on_executed = function(l_2_0, ...)
  l_2_0:on_executed(...)
   -- DECOMPILER ERROR: Confused about usage of registers for local variables.

end

ElementDebug.on_executed = function(l_3_0, l_3_1)
  if not l_3_0._values.enabled then
    return 
  end
  local prefix = "<debug>    "
  managers.mission:add_fading_debug_output(prefix .. l_3_0._values.debug_string)
  ElementDebug.super.on_executed(l_3_0, l_3_1)
end


