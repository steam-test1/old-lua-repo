-- Decompiled using luadec 2.0.1 by sztupy (http://winmo.sztupy.hu)
-- Command line was: F:\SteamLibrary\SteamApps\common\PAYDAY 2\lua\lib\states\serverleftstate.luac 

require("lib/states/GameState")
if not ServerLeftState then
  ServerLeftState = class(MissionEndState)
end
ServerLeftState.init = function(l_1_0, l_1_1, l_1_2)
  ServerLeftState.super.init(l_1_0, "server_left", l_1_1, l_1_2)
end

ServerLeftState.at_enter = function(l_2_0, ...)
  l_2_0._success = false
  l_2_0._server_left = true
  l_2_0._completion_bonus_done = true
  ServerLeftState.super.at_enter(l_2_0, ...)
  if Network:multiplayer() then
    l_2_0:_shut_down_network()
  end
  l_2_0:_create_server_left_dialog()
   -- DECOMPILER ERROR: Confused about usage of registers for local variables.

end

ServerLeftState.on_server_left = function(l_3_0)
end

ServerLeftState._create_server_left_dialog = function(l_4_0)
  MenuMainState._create_server_left_dialog(l_4_0)
end

ServerLeftState._load_start_menu = function(l_5_0)
  if not managers.job:stage_success() or not managers.job:on_last_stage() then
    setup:load_start_menu()
  end
end

ServerLeftState.on_server_left_ok_pressed = function(l_6_0)
  l_6_0._completion_bonus_done = true
  l_6_0:_set_continue_button_text()
end


