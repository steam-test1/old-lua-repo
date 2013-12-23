-- Decompiled using luadec 2.0.1 by sztupy (http://winmo.sztupy.hu)
-- Command line was: F:\SteamLibrary\SteamApps\common\PAYDAY 2\lua\core\lib\managers\corehelperunitmanager.luac 

core:module("CoreHelperUnitManager")
core:import("CoreClass")
if not HelperUnitManager then
  HelperUnitManager = CoreClass.class()
end
HelperUnitManager.init = function(l_1_0)
  l_1_0:_setup()
end

HelperUnitManager.clear = function(l_2_0)
  l_2_0:_setup()
end

HelperUnitManager._setup = function(l_3_0)
  l_3_0._types = {}
end

HelperUnitManager.add_unit = function(l_4_0, l_4_1, l_4_2)
  if not l_4_0._types[l_4_2] then
    l_4_0._types[l_4_2] = {}
  end
  table.insert(l_4_0._types[l_4_2], l_4_1)
end

HelperUnitManager.get_units_by_type = function(l_5_0, l_5_1)
  if not l_5_0._types[l_5_1] then
    return {}
  end
end


