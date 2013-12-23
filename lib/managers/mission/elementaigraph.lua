-- Decompiled using luadec 2.0.1 by sztupy (http://winmo.sztupy.hu)
-- Command line was: F:\SteamLibrary\SteamApps\common\PAYDAY 2\lua\lib\managers\mission\elementaigraph.luac 

core:import("CoreMissionScriptElement")
if not ElementAIGraph then
  ElementAIGraph = class(CoreMissionScriptElement.MissionScriptElement)
end
ElementAIGraph.init = function(l_1_0, ...)
  ElementAIGraph.super.init(l_1_0, ...)
   -- DECOMPILER ERROR: Confused about usage of registers for local variables.

end

ElementAIGraph.on_script_activated = function(l_2_0)
end

ElementAIGraph.client_on_executed = function(l_3_0, ...)
  l_3_0:on_executed(...)
   -- DECOMPILER ERROR: Confused about usage of registers for local variables.

end

ElementAIGraph.on_executed = function(l_4_0, l_4_1)
  if not l_4_0._values.enabled then
    return 
  end
  for _,id in ipairs(l_4_0._values.graph_ids) do
    managers.navigation:set_nav_segment_state(id, l_4_0._values.operation)
  end
  ElementAIGraph.super.on_executed(l_4_0, l_4_1)
end


