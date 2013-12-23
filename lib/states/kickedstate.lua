-- Decompiled using luadec 2.0.1 by sztupy (http://winmo.sztupy.hu)
-- Command line was: F:\SteamLibrary\SteamApps\common\PAYDAY 2\lua\lib\states\kickedstate.luac 

require("lib/states/GameState")
if not KickedState then
  KickedState = class(MissionEndState)
end
KickedState.init = function(l_1_0, l_1_1, l_1_2)
  KickedState.super.init(l_1_0, "kicked", l_1_1, l_1_2)
end

KickedState.at_enter = function(l_2_0, ...)
  l_2_0._success = false
  l_2_0._completion_bonus_done = true
  KickedState.super.at_enter(l_2_0, ...)
  if Network:multiplayer() then
    l_2_0:_shut_down_network()
  end
  l_2_0:_create_kicked_dialog()
   -- DECOMPILER ERROR: Confused about usage of registers for local variables.

end

KickedState._create_kicked_dialog = function(l_3_0)
  managers.menu:show_peer_kicked_dialog()
end

KickedState.on_kicked_ok_pressed = function(l_4_0)
  l_4_0._completion_bonus_done = true
  l_4_0:_set_continue_button_text()
end

KickedState._load_start_menu = function(l_5_0)
  if not managers.job:stage_success() or not managers.job:on_last_stage() then
    setup:load_start_menu()
  end
end


