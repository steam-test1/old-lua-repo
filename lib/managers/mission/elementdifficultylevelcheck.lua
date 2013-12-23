-- Decompiled using luadec 2.0.1 by sztupy (http://winmo.sztupy.hu)
-- Command line was: F:\SteamLibrary\SteamApps\common\PAYDAY 2\lua\lib\managers\mission\elementdifficultylevelcheck.luac 

core:import("CoreMissionScriptElement")
if not ElementDifficultyLevelCheck then
  ElementDifficultyLevelCheck = class(CoreMissionScriptElement.MissionScriptElement)
end
ElementDifficultyLevelCheck.init = function(l_1_0, ...)
  ElementDifficultyLevelCheck.super.init(l_1_0, ...)
   -- DECOMPILER ERROR: Confused about usage of registers for local variables.

end

ElementDifficultyLevelCheck.client_on_executed = function(l_2_0, ...)
  l_2_0:on_executed(...)
   -- DECOMPILER ERROR: Confused about usage of registers for local variables.

end

ElementDifficultyLevelCheck.on_executed = function(l_3_0, l_3_1)
  if not l_3_0._values.enabled then
    return 
  end
  local diff = Global.game_settings and Global.game_settings.difficulty or "hard"
  if l_3_0._values.difficulty == "overkill" and diff == "overkill_145" then
    do return end
  end
  if l_3_0._values.difficulty ~= diff then
    return 
  end
  ElementDifficultyLevelCheck.super.on_executed(l_3_0, l_3_1)
end


