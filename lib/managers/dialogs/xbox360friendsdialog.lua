-- Decompiled using luadec 2.0.1 by sztupy (http://winmo.sztupy.hu)
-- Command line was: F:\SteamLibrary\SteamApps\common\PAYDAY 2\lua\lib\managers\dialogs\xbox360friendsdialog.luac 

core:module("SystemMenuManager")
require("lib/managers/dialogs/FriendsDialog")
if not Xbox360FriendsDialog then
  Xbox360FriendsDialog = class(FriendsDialog)
end
Xbox360FriendsDialog.init = function(l_1_0, l_1_1, l_1_2)
  FriendsDialog.init(l_1_0, l_1_1, l_1_2)
end

Xbox360FriendsDialog.show = function(l_2_0)
  l_2_0._manager:event_dialog_shown(l_2_0)
  XboxLive:show_friends_ui(l_2_0:get_platform_id())
  l_2_0._show_time = TimerManager:main():time()
  return true
end

Xbox360FriendsDialog.update = function(l_3_0, l_3_1, l_3_2)
  if l_3_0._show_time and l_3_0._show_time ~= l_3_1 and not Application:is_showing_system_dialog() then
    l_3_0:done_callback()
  end
end

Xbox360FriendsDialog.done_callback = function(l_4_0)
  l_4_0._show_time = nil
  FriendsDialog.done_callback(l_4_0)
end


