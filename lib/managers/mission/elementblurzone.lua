-- Decompiled using luadec 2.0.1 by sztupy (http://winmo.sztupy.hu)
-- Command line was: F:\SteamLibrary\SteamApps\common\PAYDAY 2\lua\lib\managers\mission\elementblurzone.luac 

core:import("CoreMissionScriptElement")
if not ElementBlurZone then
  ElementBlurZone = class(CoreMissionScriptElement.MissionScriptElement)
end
ElementBlurZone.init = function(l_1_0, ...)
  ElementBlurZone.super.init(l_1_0, ...)
   -- DECOMPILER ERROR: Confused about usage of registers for local variables.

end

ElementBlurZone.client_on_executed = function(l_2_0, ...)
  l_2_0:on_executed(...)
   -- DECOMPILER ERROR: Confused about usage of registers for local variables.

end

ElementBlurZone.on_executed = function(l_3_0, l_3_1)
  if not l_3_0._values.enabled then
    return 
  end
  if l_3_0._values.mode == 0 then
    managers.environment_controller:set_blurzone(l_3_0._values.mode)
  else
    managers.environment_controller:set_blurzone(l_3_0._values.mode, l_3_0._values.position, l_3_0._values.radius, l_3_0._values.height)
  end
  ElementBlurZone.super.on_executed(l_3_0, l_3_1)
end


