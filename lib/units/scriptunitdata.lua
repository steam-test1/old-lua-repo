-- Decompiled using luadec 2.0.1 by sztupy (http://winmo.sztupy.hu)
-- Command line was: F:\SteamLibrary\SteamApps\common\PAYDAY 2\lua\lib\units\scriptunitdata.luac 

if not ScriptUnitData then
  ScriptUnitData = class(CoreScriptUnitData)
end
ScriptUnitData.init = function(l_1_0, l_1_1)
  CoreScriptUnitData.init(l_1_0)
  if managers.occlusion and l_1_0.skip_occlusion then
    managers.occlusion:remove_occlusion(l_1_1)
  end
end

ScriptUnitData.destroy = function(l_2_0, l_2_1)
  if managers.occlusion and l_2_0.skip_occlusion then
    managers.occlusion:add_occlusion(l_2_1)
  end
end


