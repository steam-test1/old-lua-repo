-- Decompiled using luadec 2.0.1 by sztupy (http://winmo.sztupy.hu)
-- Command line was: F:\SteamLibrary\SteamApps\common\PAYDAY 2\lua\lib\managers\dialogs\marketplacedialog.luac 

core:module("SystemMenuManager")
require("lib/managers/dialogs/BaseDialog")
if not MarketplaceDialog then
  MarketplaceDialog = class(BaseDialog)
end
MarketplaceDialog.done_callback = function(l_1_0)
  if l_1_0._data.callback_func then
    l_1_0._data.callback_func()
  end
  l_1_0:fade_out_close()
end

MarketplaceDialog.item_type = function(l_2_0)
  return l_2_0._data.item_type
end

MarketplaceDialog.item_id = function(l_3_0)
  return l_3_0._data.item_id
end

MarketplaceDialog.to_string = function(l_4_0)
  return string.format("%s, Item type: %s, Item id: %s", tostring(BaseDialog.to_string(l_4_0)), tostring(l_4_0._data.item_type), tostring(l_4_0._data.item_id))
end


