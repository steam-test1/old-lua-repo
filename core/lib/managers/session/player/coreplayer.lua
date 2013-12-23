-- Decompiled using luadec 2.0.1 by sztupy (http://winmo.sztupy.hu)
-- Command line was: F:\SteamLibrary\SteamApps\common\PAYDAY 2\lua\core\lib\managers\session\player\coreplayer.luac 

core:module("CorePlayer")
core:import("CoreAvatar")
if not Player then
  Player = class()
end
Player.init = function(l_1_0, l_1_1, l_1_2)
  l_1_0._player_slot = l_1_1
  l_1_0._player_handler = l_1_2
  assert(l_1_0._player_handler)
  l_1_0._player_handler._core_player = l_1_0
end

Player.destroy = function(l_2_0)
  if l_2_0._level_handler then
    l_2_0:leave_level(l_2_0._level_handler)
  end
  if l_2_0._avatar then
    l_2_0:_destroy_avatar()
  end
  l_2_0._player_handler:destroy()
  l_2_0._player_handler = nil
end

Player.avatar = function(l_3_0)
  return l_3_0._avatar
end

Player.has_avatar = function(l_4_0)
  return l_4_0._avatar ~= nil
end

Player.is_alive = function(l_5_0)
  return l_5_0._player_handler ~= nil
end

Player._destroy_avatar = function(l_6_0)
  l_6_0._player_handler:release_avatar()
  l_6_0._avatar:destroy()
  l_6_0._avatar = nil
end

Player.avatar_handler = function(l_7_0)
  return l_7_0._avatar_handler
end

Player.enter_level = function(l_8_0, l_8_1)
  l_8_0._player_handler:enter_level(l_8_1)
  local avatar_handler = l_8_0._player_handler:spawn_avatar()
  l_8_0._avatar = CoreAvatar.Avatar:new(avatar_handler)
  avatar_handler._core_avatar = l_8_0._avatar
  l_8_0._player_handler:set_avatar(avatar_handler)
  l_8_0._level_handler = l_8_1
end

Player.leave_level = function(l_9_0, l_9_1)
  if l_9_0._avatar then
    l_9_0:_destroy_avatar()
  end
  l_9_0._player_handler:leave_level(l_9_1)
  l_9_0._level_handler = nil
end

Player.player_slot = function(l_10_0)
  return l_10_0._player_slot
end

Player.set_leaderboard_position = function(l_11_0, l_11_1)
  l_11_0._leaderboard_position = l_11_1
end

Player.set_team = function(l_12_0, l_12_1)
  l_12_0._team = l_12_1
end


