-- Decompiled using luadec 2.0.1 by sztupy (http://winmo.sztupy.hu)
-- Command line was: F:\SteamLibrary\SteamApps\common\PAYDAY 2\lua\lib\managers\overlayeffectmanager.luac 

core:import("CoreOverlayEffectManager")
if not OverlayEffectManager then
  OverlayEffectManager = class(CoreOverlayEffectManager.OverlayEffectManager)
end
OverlayEffectManager.init = function(l_1_0)
  OverlayEffectManager.super.init(l_1_0)
  for name,setting in pairs(tweak_data.overlay_effects) do
    l_1_0:add_preset(name, setting)
  end
end

CoreClass.override_class(CoreOverlayEffectManager.OverlayEffectManager, OverlayEffectManager)

