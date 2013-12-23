-- Decompiled using luadec 2.0.1 by sztupy (http://winmo.sztupy.hu)
-- Command line was: F:\SteamLibrary\SteamApps\common\PAYDAY 2\lua\lib\managers\mission\elementdropinstate.luac 

core:import("CoreMissionScriptElement")
if not ElementDropinState then
  ElementDropinState = class(CoreMissionScriptElement.MissionScriptElement)
end
ElementDropinState.init = function(l_1_0, ...)
  ElementDropinState.super.init(l_1_0, ...)
   -- DECOMPILER ERROR: Confused about usage of registers for local variables.

end

ElementDropinState.client_on_executed = function(l_2_0, ...)
  l_2_0:on_executed(...)
   -- DECOMPILER ERROR: Confused about usage of registers for local variables.

end

ElementDropinState.on_executed = function(l_3_0, l_3_1)
  if not l_3_0._values.enabled then
    return 
  end
  managers.groupai:state():set_allow_dropin(l_3_0._values.state)
  ElementDropinState.super.on_executed(l_3_0, l_3_1)
end


