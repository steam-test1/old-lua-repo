-- Decompiled using luadec 2.0.1 by sztupy (http://winmo.sztupy.hu)
-- Command line was: F:\SteamLibrary\SteamApps\common\PAYDAY 2\lua\lib\managers\dialogs\ps3deletefiledialog.luac 

core:module("SystemMenuManager")
require("lib/managers/dialogs/DeleteFileDialog")
if not PS3DeleteFileDialog then
  PS3DeleteFileDialog = class(DeleteFileDialog)
end
PS3DeleteFileDialog.show = function(l_1_0)
  l_1_0._manager:event_dialog_shown(l_1_0)
  l_1_0:done_callback(true)
  return true
end


