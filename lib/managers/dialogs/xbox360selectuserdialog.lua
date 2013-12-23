-- Decompiled using luadec 2.0.1 by sztupy (http://winmo.sztupy.hu)
-- Command line was: F:\SteamLibrary\SteamApps\common\PAYDAY 2\lua\lib\managers\dialogs\xbox360selectuserdialog.luac 

core:module("SystemMenuManager")
require("lib/managers/dialogs/SelectUserDialog")
if not Xbox360SelectUserDialog then
  Xbox360SelectUserDialog = class(SelectUserDialog)
end
Xbox360SelectUserDialog.init = function(l_1_0, l_1_1, l_1_2)
  SelectUserDialog.init(l_1_0, l_1_1, l_1_2)
  local count = l_1_0._data.count
  if count and count ~= 1 and count ~= 2 and count ~= 4 then
    if count > 2 then
      l_1_0._data.count = 4
    else
      l_1_0._data.count = 1
    end
  end
end

Xbox360SelectUserDialog.show = function(l_2_0)
  l_2_0._manager:event_dialog_shown(l_2_0)
  XboxLive:show_signin_ui(l_2_0:count())
  l_2_0._show_time = TimerManager:main():time()
  return true
end

Xbox360SelectUserDialog.update = function(l_3_0, l_3_1, l_3_2)
  if l_3_0._show_time and l_3_0._show_time ~= l_3_1 and not Application:is_showing_system_dialog() and not l_3_0._manager:_is_engine_delaying_signin_change() then
    l_3_0:done_callback()
  end
end

Xbox360SelectUserDialog.done_callback = function(l_4_0)
  l_4_0._show_time = nil
  SelectUserDialog.done_callback(l_4_0)
end


