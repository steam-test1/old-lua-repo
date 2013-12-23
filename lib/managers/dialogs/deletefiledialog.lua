-- Decompiled using luadec 2.0.1 by sztupy (http://winmo.sztupy.hu)
-- Command line was: F:\SteamLibrary\SteamApps\common\PAYDAY 2\lua\lib\managers\dialogs\deletefiledialog.luac 

core:module("SystemMenuManager")
require("lib/managers/dialogs/BaseDialog")
if not DeleteFileDialog then
  DeleteFileDialog = class(BaseDialog)
end
DeleteFileDialog.done_callback = function(l_1_0, l_1_1)
  if l_1_0._data.callback_func then
    l_1_0._data.callback_func(l_1_1)
  end
  l_1_0:fade_out_close()
end


