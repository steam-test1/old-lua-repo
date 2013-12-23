-- Decompiled using luadec 2.0.1 by sztupy (http://winmo.sztupy.hu)
-- Command line was: F:\SteamLibrary\SteamApps\common\PAYDAY 2\lua\lib\managers\dialogs\xbox360playerreviewdialog.luac 

core:module("SystemMenuManager")
require("lib/managers/dialogs/PlayerReviewDialog")
if not Xbox360PlayerReviewDialog then
  Xbox360PlayerReviewDialog = class(PlayerReviewDialog)
end
Xbox360PlayerReviewDialog.init = function(l_1_0, l_1_1, l_1_2)
  PlayerReviewDialog.init(l_1_0, l_1_1, l_1_2)
end

Xbox360PlayerReviewDialog.show = function(l_2_0)
  l_2_0._manager:event_dialog_shown(l_2_0)
  local player_id = l_2_0:player_id()
  if player_id then
    XboxLive:show_player_review_ui(l_2_0:get_platform_id(), l_2_0:player_id())
  else
    Application:error("[SystemMenuManager] Unable to display player review dialog since no player id was specified.")
  end
  l_2_0._show_time = TimerManager:main():time()
  return true
end

Xbox360PlayerReviewDialog.update = function(l_3_0, l_3_1, l_3_2)
  if l_3_0._show_time and l_3_0._show_time ~= l_3_1 and not Application:is_showing_system_dialog() then
    l_3_0:done_callback()
  end
end

Xbox360PlayerReviewDialog.done_callback = function(l_4_0)
  l_4_0._show_time = nil
  PlayerReviewDialog.done_callback(l_4_0)
end


