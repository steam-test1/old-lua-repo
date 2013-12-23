-- Decompiled using luadec 2.0.1 by sztupy (http://winmo.sztupy.hu)
-- Command line was: F:\SteamLibrary\SteamApps\common\PAYDAY 2\lua\lib\managers\dialogs\selectstoragedialog.luac 

core:module("SystemMenuManager")
require("lib/managers/dialogs/BaseDialog")
if not SelectStorageDialog then
  SelectStorageDialog = class(BaseDialog)
end
SelectStorageDialog.content_type = function(l_1_0)
  return l_1_0._data.content_type or 1
end

SelectStorageDialog.min_bytes = function(l_2_0)
  return l_2_0._data.min_bytes or 0
end

SelectStorageDialog.auto_select = function(l_3_0)
  return l_3_0._data.auto_select
end

SelectStorageDialog.done_callback = function(l_4_0, l_4_1, l_4_2)
  if l_4_0._data.callback_func then
    l_4_0._data.callback_func(l_4_1, l_4_2)
  end
  l_4_0:fade_out_close()
end

SelectStorageDialog.to_string = function(l_5_0)
  return string.format("%s, Content type: %s, Min bytes: %s, Auto select: %s", tostring(BaseDialog.to_string(l_5_0)), tostring(l_5_0._data.content_type), tostring(l_5_0._data.min_bytes), tostring(l_5_0._data.auto_select))
end


