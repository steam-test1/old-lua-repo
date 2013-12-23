-- Decompiled using luadec 2.0.1 by sztupy (http://winmo.sztupy.hu)
-- Command line was: F:\SteamLibrary\SteamApps\common\PAYDAY 2\lua\core\lib\managers\session\menu_state\state\coremenustatestoploadinggame.luac 

core:module("CoreMenuStateStopLoadingGame")
core:import("CoreSessionResponse")
core:import("CoreMenuStatePreFrontEnd")
core:import("CoreMenuStateInGame")
if not StopLoadingGame then
  StopLoadingGame = class()
end
StopLoadingGame.init = function(l_1_0)
  local menu_handler = l_1_0.menu_state._menu_handler
  l_1_0._response = CoreSessionResponse.Done:new()
  menu_handler:stop_loading_game_environment(l_1_0._response)
end

StopLoadingGame.destroy = function(l_2_0)
  l_2_0._response:destroy()
end

StopLoadingGame.transition = function(l_3_0)
  if not l_3_0._response:is_done() then
    return 
  end
  return CoreMenuStateInGame.InGame
end


