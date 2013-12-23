-- Decompiled using luadec 2.0.1 by sztupy (http://winmo.sztupy.hu)
-- Command line was: F:\SteamLibrary\SteamApps\common\PAYDAY 2\lua\lib\states\disconnectedstate.luac 

require("lib/states/GameState")
if not DisconnectedState then
  DisconnectedState = class(MissionEndState)
end
DisconnectedState.init = function(l_1_0, l_1_1, l_1_2)
  DisconnectedState.super.init(l_1_0, "disconnected", l_1_1, l_1_2)
end

DisconnectedState.at_enter = function(l_2_0, ...)
  l_2_0._success = false
  l_2_0._completion_bonus_done = true
  DisconnectedState.super.at_enter(l_2_0, ...)
  managers.network.voice_chat:destroy_voice(true)
  l_2_0:_create_disconnected_dialog()
   -- DECOMPILER ERROR: Confused about usage of registers for local variables.

end

DisconnectedState._create_disconnected_dialog = function(l_3_0)
  MenuMainState._create_disconnected_dialog(l_3_0)
end

DisconnectedState.on_server_left_ok_pressed = function(l_4_0)
end

DisconnectedState.on_disconnected = function(l_5_0)
  l_5_0._completion_bonus_done = true
  l_5_0:_set_continue_button_text()
end

DisconnectedState.on_server_left = function(l_6_0)
  l_6_0._completion_bonus_done = true
  l_6_0:_set_continue_button_text()
end

DisconnectedState._load_start_menu = function(l_7_0)
  if not managers.job:stage_success() or not managers.job:on_last_stage() then
    setup:load_start_menu()
  end
end


