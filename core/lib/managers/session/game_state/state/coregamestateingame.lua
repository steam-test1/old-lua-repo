-- Decompiled using luadec 2.0.1 by sztupy (http://winmo.sztupy.hu)
-- Command line was: F:\SteamLibrary\SteamApps\common\PAYDAY 2\lua\core\lib\managers\session\game_state\state\coregamestateingame.luac 

core:module("CoreGameStateInGame")
core:import("CoreGameStatePrepareLoadingFrontEnd")
if not InGame then
  InGame = class()
end
InGame.init = function(l_1_0, l_1_1)
  l_1_0._level_handler = l_1_1
  l_1_0.game_state._is_in_game = true
  EventManager:trigger_event((Idstring("game_state_ingame")), nil)
end

InGame.destroy = function(l_2_0)
  l_2_0.game_state._is_in_game = nil
end

InGame.transition = function(l_3_0)
  if not l_3_0.game_state._front_end_requester:is_requested() then
    return 
  end
  if l_3_0.game_state._session_manager:_main_systems_are_stable_for_loading() then
    return CoreGameStatePrepareLoadingFrontEnd.PrepareLoadingFrontEnd, l_3_0._level_handler
  end
end

InGame.end_update = function(l_4_0, l_4_1, l_4_2)
  l_4_0._level_handler:end_update(l_4_1, l_4_2)
end


