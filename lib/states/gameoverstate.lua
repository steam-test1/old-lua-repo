-- Decompiled using luadec 2.0.1 by sztupy (http://winmo.sztupy.hu)
-- Command line was: F:\SteamLibrary\SteamApps\common\PAYDAY 2\lua\lib\states\gameoverstate.luac 

require("lib/states/GameState")
if not GameOverState then
  GameOverState = class(MissionEndState)
end
GameOverState.init = function(l_1_0, l_1_1, l_1_2)
  GameOverState.super.init(l_1_0, "gameoverscreen", l_1_1, l_1_2)
  l_1_0._type = "gameover"
end

GameOverState.at_enter = function(l_2_0, ...)
  l_2_0._success = false
  GameOverState.super.at_enter(l_2_0, ...)
   -- DECOMPILER ERROR: Confused about usage of registers for local variables.

end

GameOverState._shut_down_network = function(l_3_0, ...)
  if managers.dlc:is_trial() then
    GameOverState.super._shut_down_network(l_3_0)
  end
  if managers.job:is_current_job_professional() and Global.game_settings.single_player then
    GameOverState.super._shut_down_network(l_3_0, ...)
     -- DECOMPILER ERROR: Confused about usage of registers for local variables.

  end
end

GameOverState._load_start_menu = function(l_4_0, ...)
  if managers.dlc:is_trial() then
    Global.open_trial_buy = true
    setup:load_start_menu()
  end
  if managers.job:is_current_job_professional() and Global.game_settings.single_player then
    GameOverState.super._load_start_menu(l_4_0, ...)
     -- DECOMPILER ERROR: Confused about usage of registers for local variables.

  end
end

GameOverState._set_continue_button_text = function(l_5_0)
  local text_id = (((not l_5_0._continue_block_timer or Application:time() >= l_5_0._continue_block_timer or not "menu_es_calculating_experience") and ((Network:is_server() or managers.dlc:is_trial()) and managers.job:is_current_job_professional() and (Global.game_settings.single_player and "failed_disconnected_continue") or "debug_mission_end_continue" or "menu_victory_retry_stage"))) or "victory_client_waiting_for_server"
  local text = utf8.to_upper(managers.localization:text(text_id, {CONTINUE = managers.localization:btn_macro("continue")}))
  managers.menu_component:set_endscreen_continue_button_text(text, text_id ~= "failed_disconnected_continue" and text_id ~= "debug_mission_end_continue" and text_id ~= "menu_victory_retry_stage")
end

GameOverState._continue = function(l_6_0)
  if Network:is_server() or managers.dlc:is_trial() then
    l_6_0:continue()
  end
end

GameOverState.continue = function(l_7_0)
  if l_7_0:_continue_blocked() then
    return 
  end
  if Network:is_server() and not managers.dlc:is_trial() then
    managers.network:session():send_to_peers_loaded("enter_ingame_lobby_menu")
  end
  if managers.dlc:is_trial() then
    l_7_0:gsm():change_state_by_name("empty")
    return 
  end
  if managers.job:is_current_job_professional() and Global.game_settings.single_player then
    l_7_0:gsm():change_state_by_name("empty")
    return 
  end
  if l_7_0._old_state then
    l_7_0:_clear_controller()
    managers.menu_component:close_stage_endscreen_gui()
    l_7_0:gsm():change_state_by_name("ingame_lobby_menu")
  else
    Application:error("Trying to continue from game over screen, but I have no state to goto")
  end
end


