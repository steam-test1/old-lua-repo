-- Decompiled using luadec 2.0.1 by sztupy (http://winmo.sztupy.hu)
-- Command line was: F:\SteamLibrary\SteamApps\common\PAYDAY 2\lua\core\lib\managers\session\coresessionmanager.luac 

core:module("CoreSessionManager")
core:import("CoreMenuState")
core:import("CoreGameState")
core:import("CoreDialogState")
core:import("CoreFreezeState")
core:import("CorePlayerSlots")
core:import("CoreLocalUserManager")
core:import("CoreSessionState")
core:import("CoreSessionDebug")
core:import("CoreDebug")
if not SessionManager then
  SessionManager = class()
end
SessionManager.init = function(l_1_0, l_1_1, l_1_2)
  if not l_1_1 then
    return 
  end
  assert(l_1_1 ~= nil, "SessionManager must have a valid session_factory to work")
  l_1_0._factory = l_1_1
  local settings_handler = l_1_0._factory:create_profile_settings_handler()
  local progress_handler = l_1_0._factory:create_profile_progress_handler()
  l_1_0._local_user_manager = CoreLocalUserManager.Manager:new(l_1_0._factory, settings_handler, progress_handler, l_1_2)
  l_1_0._player_slots = CorePlayerSlots.PlayerSlots:new(l_1_0._local_user_manager, l_1_0._factory)
  l_1_0._player_slots:add_player_slot()
  local game_state = CoreGameState.GameState:new(l_1_0._player_slots, l_1_0)
  local menu_handler = l_1_0._factory:create_menu_handler()
  local menu_state = CoreMenuState.MenuState:new(game_state, menu_handler, l_1_0._player_slots)
  local dialog_state = CoreDialogState.DialogState:new()
  local freeze_state = CoreFreezeState.FreezeState:new()
  l_1_0._session_state = CoreSessionState.SessionState:new(l_1_0._factory, l_1_0._player_slots, game_state)
  l_1_0._factory.session_establisher = l_1_0._session_state
  l_1_0._state_machines = {game_state, menu_state, dialog_state, freeze_state, l_1_0._player_slots, l_1_0._local_user_manager, l_1_0._session_state}
  l_1_0._state_machines_except_menu_and_game = {dialog_state, freeze_state, l_1_0._player_slots, l_1_0._local_user_manager, l_1_0._session_state}
  l_1_0._debug = CoreSessionDebug.SessionDebug:new(l_1_0._session_state)
end

SessionManager.destroy = function(l_2_0)
end

SessionManager._main_systems_are_stable_for_loading = function(l_3_0)
  return l_3_0:_check_if_stable_for_loading(l_3_0._state_machines_except_menu_and_game)
end

SessionManager.all_systems_are_stable_for_loading = function(l_4_0)
  return l_4_0:_check_if_stable_for_loading(l_4_0._state_machines)
end

SessionManager._check_if_stable_for_loading = function(l_5_0, l_5_1)
  for _,state in pairs(l_5_1) do
    if not state:is_stable_for_loading() then
      cat_print("debug", CoreDebug.full_class_name(state) .. " is not ready....")
      return false
    end
  end
  return true
end

SessionManager._update = function(l_6_0, l_6_1, l_6_2)
  if not l_6_0._factory then
    return 
  end
  l_6_0._local_user_manager:update(l_6_1, l_6_2)
  l_6_0._debug_timer = (l_6_0._debug_timer or 0) + l_6_2
  for _,state in pairs(l_6_0._state_machines) do
    if state.update then
      state:update(l_6_1, l_6_2)
    end
    state:transition()
  end
end

SessionManager.end_update = function(l_7_0, l_7_1, l_7_2)
  if not l_7_0._factory then
    return 
  end
  for _,state in pairs(l_7_0._state_machines) do
    if state.end_update then
      state:end_update(l_7_1, l_7_2)
    end
  end
end

SessionManager.update = function(l_8_0, l_8_1, l_8_2)
  l_8_0:_update(l_8_1, l_8_2)
end

SessionManager.paused_update = function(l_9_0, l_9_1, l_9_2)
  l_9_0:_update(l_9_1, l_9_2)
end

SessionManager.player_slots = function(l_10_0)
  return l_10_0._player_slots
end

SessionManager.session = function(l_11_0)
  return l_11_0._session_state
end

SessionManager._debug_time = function(l_12_0)
  return l_12_0._debug_timer
end


