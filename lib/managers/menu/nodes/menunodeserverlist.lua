-- Decompiled using luadec 2.0.1 by sztupy (http://winmo.sztupy.hu)
-- Command line was: F:\SteamLibrary\SteamApps\common\PAYDAY 2\lua\lib\managers\menu\nodes\menunodeserverlist.luac 

core:import("CoreMenuNode")
core:import("CoreSerialize")
core:import("CoreMenuItem")
core:import("CoreMenuItemToggle")
if not MenuNodeServerList then
  MenuNodeServerList = class(MenuNodeTable)
end
MenuNodeServerList.init = function(l_1_0, l_1_1)
  MenuNodeServerList.super.init(l_1_0, l_1_1)
end

MenuNodeServerList.update = function(l_2_0, l_2_1, l_2_2)
  MenuNodeServerList.super.update(l_2_0, l_2_1, l_2_2)
end

MenuNodeServerList._setup_columns = function(l_3_0)
  l_3_0:_add_column({text = string.upper(""), proportions = 1.8999999761581, align = "left"})
  l_3_0:_add_column({text = string.upper(""), proportions = 1.7000000476837, align = "right"})
  l_3_0:_add_column({text = string.upper(""), proportions = 1, align = "right"})
  l_3_0:_add_column({text = string.upper(""), proportions = 0.22499999403954, align = "right"})
end


