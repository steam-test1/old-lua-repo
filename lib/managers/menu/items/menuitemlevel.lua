-- Decompiled using luadec 2.0.1 by sztupy (http://winmo.sztupy.hu)
-- Command line was: F:\SteamLibrary\SteamApps\common\PAYDAY 2\lua\lib\managers\menu\items\menuitemlevel.luac 

core:import("CoreMenuItem")
if not MenuItemLevel then
  MenuItemLevel = class(CoreMenuItem.Item)
end
MenuItemLevel.TYPE = "level"
MenuItemLevel.init = function(l_1_0, l_1_1, l_1_2)
  CoreMenuItem.Item.init(l_1_0, l_1_1, l_1_2)
  l_1_0._type = MenuItemLevel.TYPE
end


