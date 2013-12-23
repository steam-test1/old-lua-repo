-- Decompiled using luadec 2.0.1 by sztupy (http://winmo.sztupy.hu)
-- Command line was: F:\SteamLibrary\SteamApps\common\PAYDAY 2\lua\lib\managers\dialogs\selectuserdialog.luac 

core:module("SystemMenuManager")
require("lib/managers/dialogs/BaseDialog")
if not SelectUserDialog then
  SelectUserDialog = class(BaseDialog)
end
SelectUserDialog.count = function(l_1_0)
  return l_1_0._data.count or 1
end

SelectUserDialog.done_callback = function(l_2_0)
  if l_2_0._data.callback_func then
    l_2_0._data.callback_func()
  end
  l_2_0:fade_out_close()
end

SelectUserDialog.to_string = function(l_3_0)
  return string.format("%s, Count: %s", tostring(BaseDialog.to_string(l_3_0)), tostring(l_3_0._data.count))
end


