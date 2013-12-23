-- Decompiled using luadec 2.0.1 by sztupy (http://winmo.sztupy.hu)
-- Command line was: F:\SteamLibrary\SteamApps\common\PAYDAY 2\lua\lib\utils\dev\freeflight.luac 

core:module("FreeFlight")
core:import("CoreFreeFlight")
core:import("CoreClass")
if not FreeFlight then
  FreeFlight = class(CoreFreeFlight.FreeFlight)
end
FreeFlight.enable = function(l_1_0, ...)
  FreeFlight.super.enable(l_1_0, ...)
  if managers.hud then
    managers.hud:set_freeflight_disabled()
     -- DECOMPILER ERROR: Confused about usage of registers for local variables.

  end
end

FreeFlight.disable = function(l_2_0, ...)
  FreeFlight.super.disable(l_2_0, ...)
  if managers.hud then
    managers.hud:set_freeflight_enabled()
     -- DECOMPILER ERROR: Confused about usage of registers for local variables.

  end
end

FreeFlight._pause = function(l_3_0)
  Application:set_pause(true)
end

FreeFlight._unpause = function(l_4_0)
  Application:set_pause(false)
end

CoreClass.override_class(CoreFreeFlight.FreeFlight, FreeFlight)

