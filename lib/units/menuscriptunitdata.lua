-- Decompiled using luadec 2.0.1 by sztupy (http://winmo.sztupy.hu)
-- Command line was: F:\SteamLibrary\SteamApps\common\PAYDAY 2\lua\lib\units\menuscriptunitdata.luac 

if not ScriptUnitData then
  ScriptUnitData = class()
end
if not UnitBase then
  UnitBase = class()
end
UnitBase.init = function(l_1_0, l_1_1, l_1_2)
  l_1_0._unit = l_1_1
  if not l_1_2 then
    l_1_1:set_extension_update_enabled(Idstring("base"), false)
  end
end

UnitBase.pre_destroy = function(l_2_0, l_2_1)
  l_2_0._destroying = true
end


