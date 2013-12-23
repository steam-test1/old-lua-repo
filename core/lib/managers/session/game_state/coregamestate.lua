-- Decompiled using luadec 2.0.1 by sztupy (http://winmo.sztupy.hu)
-- Command line was: F:\SteamLibrary\SteamApps\common\PAYDAY 2\lua\core\lib\managers\session\game_state\coregamestate.luac 

core:module("CoreGameState")
core:import("CoreFiniteStateMachine")
core:import("CoreGameStateInit")
core:import("CoreSessionGenericState")
core:import("CoreRequester")
if not GameState then
  GameState = class(CoreSessionGenericState.State)
end
GameState.init = function(l_1_0, l_1_1, l_1_2)
  l_1_0._player_slots = l_1_1
  l_1_0._session_manager = l_1_2
  l_1_0._game_requester = CoreRequester.Requester:new()
  l_1_0._front_end_requester = CoreRequester.Requester:new()
  assert(l_1_0._session_manager)
  l_1_0._state = CoreFiniteStateMachine.FiniteStateMachine:new(CoreGameStateInit.Init, "game_state", l_1_0)
end

GameState.set_debug = function(l_2_0, l_2_1)
  l_2_0._state:set_debug(l_2_1)
end

GameState.default_data = function(l_3_0)
  l_3_0.start_state = "GameStateInit"
end

GameState.save = function(l_4_0, l_4_1)
  l_4_0._state:save(l_4_1.start_state)
end

GameState.update = function(l_5_0, l_5_1, l_5_2)
  if l_5_0._state:state().update then
    l_5_0._state:update(l_5_1, l_5_2)
  end
end

GameState.end_update = function(l_6_0, l_6_1, l_6_2)
  if l_6_0._state:state().end_update then
    l_6_0._state:state():end_update(l_6_1, l_6_2)
  end
end

GameState.transition = function(l_7_0)
  l_7_0._state:transition()
end

GameState.player_slots = function(l_8_0)
  return l_8_0._player_slots
end

GameState.is_in_pre_front_end = function(l_9_0)
  return l_9_0._is_in_pre_front_end
end

GameState.is_in_front_end = function(l_10_0)
  return l_10_0._is_in_front_end
end

GameState.is_in_init = function(l_11_0)
  return l_11_0._is_in_init
end

GameState.is_in_editor = function(l_12_0)
  return l_12_0._is_in_editor
end

GameState.is_in_game = function(l_13_0)
  return l_13_0._is_in_game
end

GameState.is_preparing_for_loading_game = function(l_14_0)
  return l_14_0._is_preparing_for_loading_game
end

GameState.is_preparing_for_loading_front_end = function(l_15_0)
  return l_15_0._is_preparing_for_loading_front_end
end

GameState._session_info = function(l_16_0)
  return l_16_0._session_manager:session():session_info()
end

GameState.request_game = function(l_17_0)
  l_17_0._game_requester:request()
end

GameState.request_front_end = function(l_18_0)
  l_18_0._front_end_requester:request()
end


