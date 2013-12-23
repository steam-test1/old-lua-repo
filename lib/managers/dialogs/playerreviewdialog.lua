-- Decompiled using luadec 2.0.1 by sztupy (http://winmo.sztupy.hu)
-- Command line was: F:\SteamLibrary\SteamApps\common\PAYDAY 2\lua\lib\managers\dialogs\playerreviewdialog.luac 

core:module("SystemMenuManager")
require("lib/managers/dialogs/Dialog")
if not PlayerReviewDialog then
  PlayerReviewDialog = class(BaseDialog)
end
PlayerReviewDialog.done_callback = function(l_1_0)
  if l_1_0._data.callback_func then
    l_1_0._data.callback_func()
  end
  l_1_0:fade_out_close()
end

PlayerReviewDialog.player_id = function(l_2_0)
  return l_2_0._data.player_id
end

PlayerReviewDialog.to_string = function(l_3_0)
  return string.format("%s, Player id: %s", tostring(BaseDialog.to_string(l_3_0)), tostring(l_3_0._data.player_id))
end


