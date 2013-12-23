-- Decompiled using luadec 2.0.1 by sztupy (http://winmo.sztupy.hu)
-- Command line was: F:\SteamLibrary\SteamApps\common\PAYDAY 2\lua\lib\managers\mission\elementfadetoblack.luac 

core:import("CoreMissionScriptElement")
if not ElementFadeToBlack then
  ElementFadeToBlack = class(CoreMissionScriptElement.MissionScriptElement)
end
ElementFadeToBlack.init = function(l_1_0, ...)
  ElementFadeToBlack.super.init(l_1_0, ...)
   -- DECOMPILER ERROR: Confused about usage of registers for local variables.

end

ElementFadeToBlack.client_on_executed = function(l_2_0, ...)
  l_2_0:on_executed(...)
   -- DECOMPILER ERROR: Confused about usage of registers for local variables.

end

ElementFadeToBlack.on_executed = function(l_3_0, l_3_1)
  if not l_3_0._values.enabled then
    return 
  end
  if not l_3_0._values.state or not tweak_data.overlay_effects.element_fade_in then
    managers.overlay_effect:play_effect(tweak_data.overlay_effects.element_fade_out)
  end
  ElementFadeToBlack.super.on_executed(l_3_0, l_3_1)
end


