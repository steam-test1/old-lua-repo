-- Decompiled using luadec 2.0.1 by sztupy (http://winmo.sztupy.hu)
-- Command line was: F:\SteamLibrary\SteamApps\common\PAYDAY 2\lua\lib\states\victorystate.luac 

require("lib/states/GameState")
if not VictoryState then
  VictoryState = class(MissionEndState)
end
VictoryState.init = function(l_1_0, l_1_1, l_1_2)
  VictoryState.super.init(l_1_0, "victoryscreen", l_1_1, l_1_2)
  l_1_0._type = "victory"
end

VictoryState.at_enter = function(l_2_0, ...)
  l_2_0._success = true
  VictoryState.super.at_enter(l_2_0, ...)
   -- DECOMPILER ERROR: Confused about usage of registers for local variables.

end

VictoryState.at_exit = function(l_3_0, ...)
  if l_3_0._post_event then
    l_3_0._post_event:stop()
  end
  VictoryState.super.at_exit(l_3_0, ...)
   -- DECOMPILER ERROR: Confused about usage of registers for local variables.

end

VictoryState._shut_down_network = function(l_4_0)
  if managers.dlc:is_trial() then
    VictoryState.super._shut_down_network(l_4_0)
  end
end

VictoryState._load_start_menu = function(l_5_0)
  if managers.dlc:is_trial() then
    Global.open_trial_buy = true
    setup:load_start_menu()
  end
end

VictoryState._set_continue_button_text = function(l_6_0)
  if not Network:is_server() then
    local is_server_or_trial = managers.dlc:is_trial()
  end
  local text_id = ((is_server_or_trial or not "victory_client_waiting_for_server") and (l_6_0._completion_bonus_done ~= false or not "menu_es_calculating_experience") and (managers.job:on_last_stage() and "menu_victory_goto_payday")) or "menu_victory_goto_next_stage"
  local text = utf8.to_upper(managers.localization:text(text_id, {CONTINUE = managers.localization:btn_macro("continue")}))
  managers.menu_component:set_endscreen_continue_button_text(text, (is_server_or_trial and not l_6_0._completion_bonus_done))
end

VictoryState._continue = function(l_7_0)
  if Network:is_server() or managers.dlc:is_trial() then
    l_7_0:continue()
  end
end

VictoryState.continue = function(l_8_0)
  if l_8_0:_continue_blocked() then
    return 
  end
  if Network:is_server() and not managers.dlc:is_trial() then
    managers.network:session():send_to_peers_loaded("enter_ingame_lobby_menu")
  end
  if managers.dlc:is_trial() then
    l_8_0:gsm():change_state_by_name("empty")
    return 
  end
  if l_8_0._old_state then
    l_8_0:_clear_controller()
    managers.menu_component:close_stage_endscreen_gui()
    l_8_0:gsm():change_state_by_name("ingame_lobby_menu")
  else
    Application:error("Trying to continue from victory screen, but I have no state to goto")
  end
end


