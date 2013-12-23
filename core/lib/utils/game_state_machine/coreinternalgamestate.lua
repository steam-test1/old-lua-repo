-- Decompiled using luadec 2.0.1 by sztupy (http://winmo.sztupy.hu)
-- Command line was: F:\SteamLibrary\SteamApps\common\PAYDAY 2\lua\core\lib\utils\game_state_machine\coreinternalgamestate.luac 

core:module("CoreInternalGameState")
if not GameState then
  GameState = class()
end
GameState.init = function(l_1_0, l_1_1, l_1_2)
  l_1_0._name = l_1_1
  l_1_0._gsm = l_1_2
end

GameState.destroy = function(l_2_0)
end

GameState.name = function(l_3_0)
  return l_3_0._name
end

GameState.gsm = function(l_4_0)
  return l_4_0._gsm
end

GameState.at_enter = function(l_5_0, l_5_1)
end

GameState.at_exit = function(l_6_0, l_6_1)
end

GameState.default_transition = function(l_7_0, l_7_1)
  l_7_0:at_exit(l_7_1)
  l_7_1:at_enter(l_7_0)
end

GameState.force_editor_state = function(l_8_0)
  l_8_0._gsm:change_state_by_name("editor")
end

GameState.allow_world_camera_sequence = function(l_9_0)
  return false
end

GameState.play_world_camera_sequence = function(l_10_0, l_10_1, l_10_2)
  error("NotImplemented")
end

GameState.allow_freeflight = function(l_11_0)
  return true
end

GameState.freeflight_drop_player = function(l_12_0, l_12_1, l_12_2)
  Application:error("[FreeFlight] Drop player not implemented for state '" .. l_12_0:name() .. "'")
end


