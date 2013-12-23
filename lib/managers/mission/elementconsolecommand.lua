-- Decompiled using luadec 2.0.1 by sztupy (http://winmo.sztupy.hu)
-- Command line was: F:\SteamLibrary\SteamApps\common\PAYDAY 2\lua\lib\managers\mission\elementconsolecommand.luac 

core:import("CoreMissionScriptElement")
if not ElementConsoleCommand then
  ElementConsoleCommand = class(CoreMissionScriptElement.MissionScriptElement)
end
ElementConsoleCommand.init = function(l_1_0, ...)
  ElementConsoleCommand.super.init(l_1_0, ...)
   -- DECOMPILER ERROR: Confused about usage of registers for local variables.

end

ElementConsoleCommand.on_executed = function(l_2_0, l_2_1)
  if not l_2_0._values.enabled then
    return 
  end
  Application:console_command("s " .. l_2_0._values.cmd)
  ElementConsoleCommand.super.on_executed(l_2_0, l_2_1)
end


