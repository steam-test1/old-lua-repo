-- Decompiled using luadec 2.0.1 by sztupy (http://winmo.sztupy.hu)
-- Command line was: F:\SteamLibrary\SteamApps\common\PAYDAY 2\lua\lib\managers\menu\items\menuitemfriend.luac 

core:import("CoreMenuItem")
if not MenuItemFriend then
  MenuItemFriend = class(CoreMenuItem.Item)
end
MenuItemFriend.TYPE = "friend"
MenuItemFriend.init = function(l_1_0, l_1_1, l_1_2)
  CoreMenuItem.Item.init(l_1_0, l_1_1, l_1_2)
  l_1_0._type = MenuItemFriend.TYPE
end


