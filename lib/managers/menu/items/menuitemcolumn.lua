-- Decompiled using luadec 2.0.1 by sztupy (http://winmo.sztupy.hu)
-- Command line was: F:\SteamLibrary\SteamApps\common\PAYDAY 2\lua\lib\managers\menu\items\menuitemcolumn.luac 

core:import("CoreMenuItem")
if not ItemColumn then
  ItemColumn = class(CoreMenuItem.Item)
end
ItemColumn.TYPE = "column"
ItemColumn.init = function(l_1_0, l_1_1, l_1_2)
  CoreMenuItem.Item.init(l_1_0, l_1_1, l_1_2)
  l_1_0._type = ItemColumn.TYPE
end

if not ItemServerColumn then
  ItemServerColumn = class(ItemColumn)
end
ItemServerColumn.TYPE = "server_column"
ItemServerColumn.init = function(l_2_0, l_2_1, l_2_2)
  ItemServerColumn.super.init(l_2_0, l_2_1, l_2_2)
  l_2_0._type = ItemServerColumn.TYPE
end


