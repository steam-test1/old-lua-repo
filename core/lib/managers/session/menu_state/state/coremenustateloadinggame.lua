-- Decompiled using luadec 2.0.1 by sztupy (http://winmo.sztupy.hu)
-- Command line was: F:\SteamLibrary\SteamApps\common\PAYDAY 2\lua\core\lib\managers\session\menu_state\state\coremenustateloadinggame.luac 

core:module("CoreMenuStateLoadingGame")
core:import("CoreMenuStateInGame")
core:import("CoreMenuStateStopLoadingGame")
if not LoadingGame then
  LoadingGame = class()
end
LoadingGame.init = function(l_1_0)
  l_1_0.menu_state:_set_stable_for_loading()
  local menu_handler = l_1_0.menu_state._menu_handler
  menu_handler:start_loading_game_environment()
end

LoadingGame.destroy = function(l_2_0)
  l_2_0.menu_state:_not_stable_for_loading()
end

LoadingGame.transition = function(l_3_0)
  local game_state = l_3_0.menu_state._game_state
  if game_state:is_in_game() then
    return CoreMenuStateStopLoadingGame.StopLoadingGame
  end
end


