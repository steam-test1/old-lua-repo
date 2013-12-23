-- Decompiled using luadec 2.0.1 by sztupy (http://winmo.sztupy.hu)
-- Command line was: F:\SteamLibrary\SteamApps\common\PAYDAY 2\lua\core\lib\managers\session\game_state\state\coregamestateineditorstopsimulation.luac 

core:module("CoreGameStateInEditorStopSimulation")
core:import("CoreGameStateInEditor")
if not StopSimulation then
  StopSimulation = class()
end
StopSimulation.init = function(l_1_0)
  l_1_0.game_state._front_end_requester:task_started()
end

StopSimulation.destroy = function(l_2_0)
  l_2_0.game_state._front_end_requester:task_completed()
end

StopSimulation.transition = function(l_3_0)
  return CoreGameStateInEditor.InEditor
end


