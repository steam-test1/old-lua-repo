-- Decompiled using luadec 2.0.1 by sztupy (http://winmo.sztupy.hu)
-- Command line was: F:\SteamLibrary\SteamApps\common\PAYDAY 2\lua\core\lib\managers\session\game_state\state\coregamestateprepareloadingfrontend.luac 

core:module("CoreGameStatePrepareLoadingFrontEnd")
core:import("CoreGameStateLoadingFrontEnd")
if not PrepareLoadingFrontEnd then
  PrepareLoadingFrontEnd = class()
end
PrepareLoadingFrontEnd.init = function(l_1_0, l_1_1)
  l_1_0.game_state._is_preparing_for_loading_front_end = true
  l_1_0.game_state._front_end_requester:task_started()
  l_1_0.game_state:_set_stable_for_loading()
  l_1_0._level_handler = l_1_1
end

PrepareLoadingFrontEnd.destroy = function(l_2_0)
  l_2_0.game_state._front_end_requester:task_completed()
  l_2_0.game_state._is_preparing_for_loading_front_end = false
  local local_user_manager = l_2_0.game_state._session_manager._local_user_manager
  l_2_0.game_state:player_slots():leave_level_handler(l_2_0._level_handler)
  local_user_manager:leave_level_handler(l_2_0._level_handler)
  l_2_0._level_handler:destroy()
end

PrepareLoadingFrontEnd.transition = function(l_3_0)
  if l_3_0.game_state._session_manager:all_systems_are_stable_for_loading() then
    return CoreGameStateLoadingFrontEnd.LoadingFrontEnd
  end
end


