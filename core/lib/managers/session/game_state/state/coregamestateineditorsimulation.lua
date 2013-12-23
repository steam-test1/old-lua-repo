-- Decompiled using luadec 2.0.1 by sztupy (http://winmo.sztupy.hu)
-- Command line was: F:\SteamLibrary\SteamApps\common\PAYDAY 2\lua\core\lib\managers\session\game_state\state\coregamestateineditorsimulation.luac 

core:module("CoreGameStateInEditorSimulation")
core:import("CoreGameStatePrepareLoadingFrontEnd")
core:import("CoreGameStateInGame")
core:import("CoreGameStateInEditorPrepareStopSimulation")
if not Simulation then
  Simulation = class(CoreGameStateInGame.InGame)
end
Simulation.transition = function(l_1_0)
  if not l_1_0.game_state._front_end_requester:is_requested() then
    return 
  end
  if l_1_0.game_state._session_manager:_main_systems_are_stable_for_loading() then
    return CoreGameStateInEditorPrepareStopSimulation.PrepareStopSimulation, l_1_0._level_handler
  end
end


