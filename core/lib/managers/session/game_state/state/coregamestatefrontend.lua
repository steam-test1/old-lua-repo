-- Decompiled using luadec 2.0.1 by sztupy (http://winmo.sztupy.hu)
-- Command line was: F:\SteamLibrary\SteamApps\common\PAYDAY 2\lua\core\lib\managers\session\game_state\state\coregamestatefrontend.luac 

core:module("CoreGameStateFrontEnd")
core:import("CoreGameStatePrepareLoadingGame")
if not FrontEnd then
  FrontEnd = class()
end
FrontEnd.init = function(l_1_0)
  l_1_0.game_state._is_in_front_end = true
end

FrontEnd.destroy = function(l_2_0)
  l_2_0.game_state._is_in_front_end = false
end

FrontEnd.transition = function(l_3_0)
  if not l_3_0.game_state._game_requester:is_requested() then
    return 
  end
  if l_3_0.game_state._session_manager:_main_systems_are_stable_for_loading() then
    return CoreGameStatePrepareLoadingGame.PrepareLoadingGame
  end
end


