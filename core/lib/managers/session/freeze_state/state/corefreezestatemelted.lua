-- Decompiled using luadec 2.0.1 by sztupy (http://winmo.sztupy.hu)
-- Command line was: F:\SteamLibrary\SteamApps\common\PAYDAY 2\lua\core\lib\managers\session\freeze_state\state\corefreezestatemelted.luac 

core:module("CoreFreezeStateMelted")
if not Melted then
  Melted = class()
end
Melted.init = function(l_1_0)
  l_1_0.freeze_state:_set_stable_for_loading()
end

Melted.destroy = function(l_2_0)
  l_2_0.freeze_state:_not_stable_for_loading()
end

Melted.transition = function(l_3_0)
end


