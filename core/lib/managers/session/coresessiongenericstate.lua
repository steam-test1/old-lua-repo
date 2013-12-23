-- Decompiled using luadec 2.0.1 by sztupy (http://winmo.sztupy.hu)
-- Command line was: F:\SteamLibrary\SteamApps\common\PAYDAY 2\lua\core\lib\managers\session\coresessiongenericstate.luac 

core:module("CoreSessionGenericState")
if not State then
  State = class()
end
State.init = function(l_1_0)
end

State._set_stable_for_loading = function(l_2_0)
  l_2_0._is_stable_for_loading = true
end

State._not_stable_for_loading = function(l_3_0)
  l_3_0._is_stable_for_loading = nil
end

State.is_stable_for_loading = function(l_4_0)
  return l_4_0._is_stable_for_loading ~= nil
end

State.transition = function(l_5_0)
  assert(false, "you must override transition()")
end


