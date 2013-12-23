-- Decompiled using luadec 2.0.1 by sztupy (http://winmo.sztupy.hu)
-- Command line was: F:\SteamLibrary\SteamApps\common\PAYDAY 2\lua\core\lib\managers\session\game_state\state\coregamestateineditorpreparestartsimulation.luac 

core:module("CoreGameStateInEditorPrepareStartSimulation")
core:import("CoreGameStateInEditorSimulation")
core:import("CoreGameStatePrepareLoadingGame")
if not PrepareStartSimulation then
  PrepareStartSimulation = class(CoreGameStatePrepareLoadingGame.PrepareLoadingGame)
end
PrepareStartSimulation.init = function(l_1_0)
  PrepareStartSimulation.super.init(l_1_0)
  local factory = l_1_0.game_state._session_manager._factory
  l_1_0._level_handler = factory:create_level_handler()
  l_1_0.game_state:player_slots():enter_level_handler(l_1_0._level_handler)
  local local_user_manager = l_1_0.game_state._session_manager._local_user_manager
  local_user_manager:enter_level_handler(l_1_0._level_handler)
  l_1_0._level_handler:set_player_slots(l_1_0.game_state:player_slots())
end

PrepareStartSimulation.transition = function(l_2_0)
  if l_2_0.game_state._session_manager:all_systems_are_stable_for_loading() then
    return CoreGameStateInEditorSimulation.Simulation, l_2_0._level_handler
  end
end


