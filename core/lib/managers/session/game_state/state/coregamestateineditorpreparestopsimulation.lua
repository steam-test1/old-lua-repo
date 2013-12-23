-- Decompiled using luadec 2.0.1 by sztupy (http://winmo.sztupy.hu)
-- Command line was: F:\SteamLibrary\SteamApps\common\PAYDAY 2\lua\core\lib\managers\session\game_state\state\coregamestateineditorpreparestopsimulation.luac 

core:module("CoreGameStateInEditorPrepareStopSimulation")
core:import("CoreGameStateInEditorStopSimulation")
if not PrepareStopSimulation then
  PrepareStopSimulation = class()
end
PrepareStopSimulation.init = function(l_1_0, l_1_1)
  l_1_0._level_handler = l_1_1
end

PrepareStopSimulation.destroy = function(l_2_0)
  local local_user_manager = l_2_0.game_state._session_manager._local_user_manager
  l_2_0.game_state:player_slots():leave_level_handler(l_2_0._level_handler)
  local_user_manager:leave_level_handler(l_2_0._level_handler)
  l_2_0._level_handler:destroy()
end

PrepareStopSimulation.transition = function(l_3_0)
  if l_3_0.game_state._session_manager:all_systems_are_stable_for_loading() then
    return CoreGameStateInEditorStopSimulation.StopSimulation
  end
end


