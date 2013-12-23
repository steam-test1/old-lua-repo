-- Decompiled using luadec 2.0.1 by sztupy (http://winmo.sztupy.hu)
-- Command line was: F:\SteamLibrary\SteamApps\common\PAYDAY 2\lua\lib\managers\dialogs\xbox360playerdialog.luac 

core:module("SystemMenuManager")
require("lib/managers/dialogs/PlayerDialog")
if not Xbox360PlayerDialog then
  Xbox360PlayerDialog = class(PlayerDialog)
end
Xbox360PlayerDialog.init = function(l_1_0, l_1_1, l_1_2)
  PlayerDialog.init(l_1_0, l_1_1, l_1_2)
end

Xbox360PlayerDialog.show = function(l_2_0)
  l_2_0._manager:event_dialog_shown(l_2_0)
  local player_id = l_2_0:player_id()
  if player_id then
    XboxLive:show_gamer_card_ui(l_2_0:get_platform_id(), l_2_0:player_id())
  else
    Application:error("[SystemMenuManager] Unable to display player dialog since no player id was specified.")
  end
  l_2_0._show_time = TimerManager:main():time()
  return true
end

Xbox360PlayerDialog.update = function(l_3_0, l_3_1, l_3_2)
  if l_3_0._show_time and l_3_0._show_time ~= l_3_1 and not Application:is_showing_system_dialog() then
    l_3_0:done_callback()
  end
end

Xbox360PlayerDialog.done_callback = function(l_4_0)
  l_4_0._show_time = nil
  PlayerDialog.done_callback(l_4_0)
end


