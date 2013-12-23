-- Decompiled using luadec 2.0.1 by sztupy (http://winmo.sztupy.hu)
-- Command line was: F:\SteamLibrary\SteamApps\common\PAYDAY 2\lua\lib\managers\mission\elementplayerstyle.luac 

core:import("CoreMissionScriptElement")
if not ElementPlayerStyle then
  ElementPlayerStyle = class(CoreMissionScriptElement.MissionScriptElement)
end
ElementPlayerStyle.init = function(l_1_0, ...)
  ElementPlayerStyle.super.init(l_1_0, ...)
   -- DECOMPILER ERROR: Confused about usage of registers for local variables.

end

ElementPlayerStyle.client_on_executed = function(l_2_0, ...)
  l_2_0:on_executed(...)
   -- DECOMPILER ERROR: Confused about usage of registers for local variables.

end

ElementPlayerStyle.on_executed = function(l_3_0, l_3_1)
  if not l_3_0._values.enabled then
    return 
  end
  managers.player:change_player_look(l_3_0._values.style)
  ElementPlayerStyle.super.on_executed(l_3_0, l_3_1)
end


