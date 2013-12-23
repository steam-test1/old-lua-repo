-- Decompiled using luadec 2.0.1 by sztupy (http://winmo.sztupy.hu)
-- Command line was: F:\SteamLibrary\SteamApps\common\PAYDAY 2\lua\core\lib\managers\session\menu_state\state\coremenustateloadingfrontend.luac 

core:module("CoreMenuStateLoadingFrontEnd")
core:import("CoreMenuStateFrontEnd")
core:import("CoreMenuStateStopLoadingFrontEnd")
if not LoadingFrontEnd then
  LoadingFrontEnd = class()
end
LoadingFrontEnd.init = function(l_1_0)
  l_1_0.menu_state:_set_stable_for_loading()
  local menu_handler = l_1_0.menu_state._menu_handler
  menu_handler:start_loading_front_end_environment()
end

LoadingFrontEnd.destroy = function(l_2_0)
  l_2_0.menu_state:_not_stable_for_loading()
end

LoadingFrontEnd.transition = function(l_3_0)
  local game_state = l_3_0.menu_state._game_state
  if game_state:is_in_front_end() or game_state:is_in_pre_front_end() then
    return CoreMenuStateStopLoadingFrontEnd.StopLoadingFrontEnd
  end
end


