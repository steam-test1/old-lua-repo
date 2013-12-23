-- Decompiled using luadec 2.0.1 by sztupy (http://winmo.sztupy.hu)
-- Command line was: F:\SteamLibrary\SteamApps\common\PAYDAY 2\lua\lib\managers\mission\elementaiarea.luac 

core:import("CoreMissionScriptElement")
if not ElementAIArea then
  ElementAIArea = class(CoreMissionScriptElement.MissionScriptElement)
end
ElementAIArea.on_executed = function(l_1_0, l_1_1)
  if not l_1_0._values.enabled or Network:is_client() or not managers.groupai:state():is_AI_enabled() or not l_1_0._values.nav_segs or #l_1_0._values.nav_segs == 0 then
    return 
  end
  managers.groupai:state():add_area(l_1_0._id, l_1_0._values.nav_segs, l_1_0._values.position)
  ElementAIArea.super.on_executed(l_1_0, l_1_1)
end


