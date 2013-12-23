-- Decompiled using luadec 2.0.1 by sztupy (http://winmo.sztupy.hu)
-- Command line was: F:\SteamLibrary\SteamApps\common\PAYDAY 2\lua\core\lib\managers\session\avatar\coreavatar.luac 

core:module("CoreAvatar")
if not Avatar then
  Avatar = class()
end
Avatar.init = function(l_1_0, l_1_1)
  l_1_0._avatar_handler = l_1_1
end

Avatar.destroy = function(l_2_0)
  if l_2_0._input_input_provider then
    l_2_0:release_input()
  end
  l_2_0._avatar_handler:destroy()
end

Avatar.set_input = function(l_3_0, l_3_1)
  l_3_0._avatar_handler:enable_input(l_3_1)
  l_3_0._input_input_provider = l_3_1
end

Avatar.release_input = function(l_4_0)
  l_4_0._avatar_handler:disable_input()
  l_4_0._input_input_provider = nil
end

Avatar.avatar_handler = function(l_5_0)
  return l_5_0._avatar_handler
end


