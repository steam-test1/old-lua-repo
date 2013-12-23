-- Decompiled using luadec 2.0.1 by sztupy (http://winmo.sztupy.hu)
-- Command line was: F:\SteamLibrary\SteamApps\common\PAYDAY 2\lua\core\lib\managers\session\game_state\state\coregamestateprepareloadinggame.luac 

core:module("CoreGameStatePrepareLoadingGame")
core:import("CoreGameStateLoadingGame")
if not PrepareLoadingGame then
  PrepareLoadingGame = class()
end
PrepareLoadingGame.init = function(l_1_0)
  l_1_0.game_state._game_requester:task_started()
  l_1_0.game_state._is_preparing_for_loading_game = true
  l_1_0.game_state:_set_stable_for_loading()
end

PrepareLoadingGame.destroy = function(l_2_0)
  l_2_0.game_state._game_requester:task_completed()
  l_2_0.game_state._is_preparing_for_loading_game = false
end

PrepareLoadingGame.transition = function(l_3_0)
  if l_3_0.game_state._session_manager:all_systems_are_stable_for_loading() then
    return CoreGameStateLoadingGame.LoadingGame
  end
end


