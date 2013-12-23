-- Decompiled using luadec 2.0.1 by sztupy (http://winmo.sztupy.hu)
-- Command line was: F:\SteamLibrary\SteamApps\common\PAYDAY 2\lua\lib\managers\mission\elementjobstagealternative.luac 

core:import("CoreMissionScriptElement")
if not ElementJobStageAlternative then
  ElementJobStageAlternative = class(CoreMissionScriptElement.MissionScriptElement)
end
ElementJobStageAlternative.init = function(l_1_0, ...)
  ElementJobStageAlternative.super.init(l_1_0, ...)
   -- DECOMPILER ERROR: Confused about usage of registers for local variables.

end

ElementJobStageAlternative.on_executed = function(l_2_0, l_2_1)
  if not l_2_0._values.enabled then
    return 
  end
  print("ElementJobStageAlternative:on_executed", l_2_0._values.alternative, l_2_0._values.interupt)
  if l_2_0._values.interupt and l_2_0._values.interupt ~= "none" then
    managers.job:set_next_interupt_stage(l_2_0._values.interupt)
  else
    managers.job:set_next_alternative_stage(l_2_0._values.alternative)
  end
  ElementJobStageAlternative.super.on_executed(l_2_0, l_2_0._unit or l_2_1)
end


