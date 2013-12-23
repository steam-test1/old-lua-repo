-- Decompiled using luadec 2.0.1 by sztupy (http://winmo.sztupy.hu)
-- Command line was: F:\SteamLibrary\SteamApps\common\PAYDAY 2\lua\core\lib\managers\session\game_state\state\coregamestateineditor.luac 

core:module("CoreGameStateInEditor")
core:import("CoreGameStateInEditorPrepareStartSimulation")
if not InEditor then
  InEditor = class()
end
InEditor.init = function(l_1_0)
  l_1_0.game_state._is_in_editor = true
  EventManager:trigger_event((Idstring("game_state_editor")), nil)
end

InEditor.destroy = function(l_2_0)
  l_2_0.game_state._is_in_editor = false
end

InEditor.transition = function(l_3_0)
  if not l_3_0.game_state._game_requester:is_requested() then
    return 
  end
  if l_3_0.game_state._session_manager:_main_systems_are_stable_for_loading() then
    return CoreGameStateInEditorPrepareStartSimulation.PrepareStartSimulation
  end
end


