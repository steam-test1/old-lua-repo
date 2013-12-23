-- Decompiled using luadec 2.0.1 by sztupy (http://winmo.sztupy.hu)
-- Command line was: F:\SteamLibrary\SteamApps\common\PAYDAY 2\lua\lib\managers\dialogs\xbox360selectstoragedialog.luac 

core:module("SystemMenuManager")
require("lib/managers/dialogs/SelectStorageDialog")
if not Xbox360SelectStorageDialog then
  Xbox360SelectStorageDialog = class(SelectStorageDialog)
end
Xbox360SelectStorageDialog.show = function(l_1_0)
  local success = Application:display_device_selection_dialog(l_1_0:get_platform_id(), l_1_0:content_type(), not l_1_0:auto_select(), callback(l_1_0, l_1_0, "done_callback"), l_1_0:min_bytes(), false)
  if success then
    l_1_0._manager:event_dialog_shown(l_1_0)
  end
  return success
end


