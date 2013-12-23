-- Decompiled using luadec 2.0.1 by sztupy (http://winmo.sztupy.hu)
-- Command line was: F:\SteamLibrary\SteamApps\common\PAYDAY 2\lua\core\lib\managers\session\menu_state\state\coremenustatefrontend.luac 

core:module("CoreMenuStateFrontEnd")
core:import("CoreMenuStatePrepareLoadingGame")
core:import("CoreMenuStatePreFrontEnd")
if not FrontEnd then
  FrontEnd = class()
end
FrontEnd.init = function(l_1_0)
  local menu_handler = l_1_0.menu_state._menu_handler
  menu_handler:front_end()
end

FrontEnd.transition = function(l_2_0)
  local game_state = l_2_0.menu_state._game_state
  if game_state:is_preparing_for_loading_game() then
    return CoreMenuStatePrepareLoadingGame.PrepareLoadingGame
  else
    if game_state:is_in_pre_front_end() then
      return CoreMenuStatePreFrontEnd.PreFrontEnd
    end
  end
end


