-- Decompiled using luadec 2.0.1 by sztupy (http://winmo.sztupy.hu)
-- Command line was: F:\SteamLibrary\SteamApps\common\PAYDAY 2\lua\lib\managers\menu\nodes\menunodetable.luac 

core:import("CoreMenuNode")
core:import("CoreSerialize")
core:import("CoreMenuItem")
core:import("CoreMenuItemToggle")
if not MenuNodeTable then
  MenuNodeTable = class(CoreMenuNode.MenuNode)
end
MenuNodeTable.init = function(l_1_0, l_1_1)
  MenuNodeTable.super.init(l_1_0, l_1_1)
  l_1_0._columns = {}
  l_1_0:_setup_columns()
  l_1_0._parameters.total_proportions = 0
  for _,data in ipairs(l_1_0._columns) do
    l_1_0._parameters.total_proportions = l_1_0._parameters.total_proportions + data.proportions
  end
end

MenuNodeTable._setup_columns = function(l_2_0)
end

MenuNodeTable._add_column = function(l_3_0, l_3_1)
  table.insert(l_3_0._columns, l_3_1)
end

MenuNodeTable.columns = function(l_4_0)
  return l_4_0._columns
end


