-- Decompiled using luadec 2.0.1 by sztupy (http://winmo.sztupy.hu)
-- Command line was: F:\SteamLibrary\SteamApps\common\PAYDAY 2\lua\lib\managers\mission\elementwhisperstate.luac 

core:import("CoreMissionScriptElement")
if not ElementWhisperState then
  ElementWhisperState = class(CoreMissionScriptElement.MissionScriptElement)
end
ElementWhisperState.init = function(l_1_0, ...)
  ElementWhisperState.super.init(l_1_0, ...)
   -- DECOMPILER ERROR: Confused about usage of registers for local variables.

end

ElementWhisperState.client_on_executed = function(l_2_0, ...)
  l_2_0:on_executed(...)
   -- DECOMPILER ERROR: Confused about usage of registers for local variables.

end

ElementWhisperState.on_executed = function(l_3_0, l_3_1)
  if not l_3_0._values.enabled then
    return 
  end
  managers.groupai:state():set_whisper_mode(l_3_0._values.state)
  ElementWhisperState.super.on_executed(l_3_0, l_3_1)
end


