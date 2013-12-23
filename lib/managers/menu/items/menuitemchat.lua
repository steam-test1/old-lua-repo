-- Decompiled using luadec 2.0.1 by sztupy (http://winmo.sztupy.hu)
-- Command line was: F:\SteamLibrary\SteamApps\common\PAYDAY 2\lua\lib\managers\menu\items\menuitemchat.luac 

core:import("CoreMenuItem")
if not MenuItemChat then
  MenuItemChat = class(CoreMenuItem.Item)
end
MenuItemChat.TYPE = "chat"
MenuItemChat.init = function(l_1_0, l_1_1, l_1_2)
  CoreMenuItem.Item.init(l_1_0, l_1_1, l_1_2)
  l_1_0._type = MenuItemChat.TYPE
end


