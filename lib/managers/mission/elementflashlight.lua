-- Decompiled using luadec 2.0.1 by sztupy (http://winmo.sztupy.hu)
-- Command line was: F:\SteamLibrary\SteamApps\common\PAYDAY 2\lua\lib\managers\mission\elementflashlight.luac 

core:import("CoreMissionScriptElement")
if not ElementFlashlight then
  ElementFlashlight = class(CoreMissionScriptElement.MissionScriptElement)
end
ElementFlashlight.init = function(l_1_0, ...)
  ElementFlashlight.super.init(l_1_0, ...)
   -- DECOMPILER ERROR: Confused about usage of registers for local variables.

end

ElementFlashlight.client_on_executed = function(l_2_0, ...)
  l_2_0:on_executed(...)
   -- DECOMPILER ERROR: Confused about usage of registers for local variables.

end

ElementFlashlight.on_executed = function(l_3_0, l_3_1)
  if not l_3_0._values.enabled then
    return 
  end
  if l_3_0._values.on_player then
    managers.game_play_central:set_flashlights_on_player_on(l_3_0._values.state)
  end
  managers.game_play_central:set_flashlights_on(l_3_0._values.state)
  ElementFlashlight.super.on_executed(l_3_0, l_3_1)
end


