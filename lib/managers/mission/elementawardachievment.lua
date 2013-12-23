-- Decompiled using luadec 2.0.1 by sztupy (http://winmo.sztupy.hu)
-- Command line was: F:\SteamLibrary\SteamApps\common\PAYDAY 2\lua\lib\managers\mission\elementawardachievment.luac 

core:import("CoreMissionScriptElement")
if not ElementAwardAchievment then
  ElementAwardAchievment = class(CoreMissionScriptElement.MissionScriptElement)
end
ElementAwardAchievment.init = function(l_1_0, ...)
  ElementAwardAchievment.super.init(l_1_0, ...)
   -- DECOMPILER ERROR: Confused about usage of registers for local variables.

end

ElementAwardAchievment.client_on_executed_end_screen = function(l_2_0, ...)
  l_2_0:on_executed(...)
   -- DECOMPILER ERROR: Confused about usage of registers for local variables.

end

ElementAwardAchievment.client_on_executed = function(l_3_0, ...)
  l_3_0:on_executed(...)
   -- DECOMPILER ERROR: Confused about usage of registers for local variables.

end

ElementAwardAchievment.on_executed = function(l_4_0, l_4_1)
  if not l_4_0._values.enabled then
    return 
  end
  managers.achievment:award(l_4_0._values.achievment)
  ElementAwardAchievment.super.on_executed(l_4_0, l_4_1)
end


