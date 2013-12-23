-- Decompiled using luadec 2.0.1 by sztupy (http://winmo.sztupy.hu)
-- Command line was: F:\SteamLibrary\SteamApps\common\PAYDAY 2\lua\lib\managers\mission\elementbainstate.luac 

core:import("CoreMissionScriptElement")
if not ElementBainState then
  ElementBainState = class(CoreMissionScriptElement.MissionScriptElement)
end
ElementBainState.init = function(l_1_0, ...)
  ElementBainState.super.init(l_1_0, ...)
   -- DECOMPILER ERROR: Confused about usage of registers for local variables.

end

ElementBainState.client_on_executed = function(l_2_0, ...)
  l_2_0:on_executed(...)
   -- DECOMPILER ERROR: Confused about usage of registers for local variables.

end

ElementBainState.on_executed = function(l_3_0, l_3_1)
  if not l_3_0._values.enabled then
    return 
  end
  managers.groupai:state():set_bain_state(l_3_0._values.state)
  ElementBainState.super.on_executed(l_3_0, l_3_1)
end


