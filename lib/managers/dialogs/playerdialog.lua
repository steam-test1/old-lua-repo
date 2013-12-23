-- Decompiled using luadec 2.0.1 by sztupy (http://winmo.sztupy.hu)
-- Command line was: F:\SteamLibrary\SteamApps\common\PAYDAY 2\lua\lib\managers\dialogs\playerdialog.luac 

core:module("SystemMenuManager")
require("lib/managers/dialogs/BaseDialog")
if not PlayerDialog then
  PlayerDialog = class(BaseDialog)
end
PlayerDialog.done_callback = function(l_1_0)
  if l_1_0._data.callback_func then
    l_1_0._data.callback_func()
  end
  l_1_0:fade_out_close()
end

PlayerDialog.player_id = function(l_2_0)
  return l_2_0._data.player_id
end

PlayerDialog.to_string = function(l_3_0)
  return string.format("%s, Player id: %s", tostring(BaseDialog.to_string(l_3_0)), tostring(l_3_0._data.player_id))
end


