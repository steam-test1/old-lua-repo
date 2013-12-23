-- Decompiled using luadec 2.0.1 by sztupy (http://winmo.sztupy.hu)
-- Command line was: F:\SteamLibrary\SteamApps\common\PAYDAY 2\lua\lib\managers\mission\elementdifficulty.luac 

core:import("CoreMissionScriptElement")
if not ElementDifficulty then
  ElementDifficulty = class(CoreMissionScriptElement.MissionScriptElement)
end
ElementDifficulty.init = function(l_1_0, ...)
  ElementDifficulty.super.init(l_1_0, ...)
   -- DECOMPILER ERROR: Confused about usage of registers for local variables.

end

ElementDifficulty.client_on_executed = function(l_2_0, ...)
   -- DECOMPILER ERROR: Confused about usage of registers for local variables.

end

ElementDifficulty.on_executed = function(l_3_0, l_3_1)
  if not l_3_0._values.enabled then
    return 
  end
  managers.groupai:state():set_difficulty(l_3_0._values.difficulty)
  ElementDifficulty.super.on_executed(l_3_0, l_3_1)
end


