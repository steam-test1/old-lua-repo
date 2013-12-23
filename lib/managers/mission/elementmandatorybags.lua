-- Decompiled using luadec 2.0.1 by sztupy (http://winmo.sztupy.hu)
-- Command line was: F:\SteamLibrary\SteamApps\common\PAYDAY 2\lua\lib\managers\mission\elementmandatorybags.luac 

core:import("CoreMissionScriptElement")
if not ElementMandatoryBags then
  ElementMandatoryBags = class(CoreMissionScriptElement.MissionScriptElement)
end
ElementMandatoryBags.init = function(l_1_0, ...)
  ElementMandatoryBags.super.init(l_1_0, ...)
   -- DECOMPILER ERROR: Confused about usage of registers for local variables.

end

ElementMandatoryBags.client_on_executed = function(l_2_0, ...)
  l_2_0:on_executed(...)
   -- DECOMPILER ERROR: Confused about usage of registers for local variables.

end

ElementMandatoryBags.on_executed = function(l_3_0, l_3_1)
  if not l_3_0._values.enabled then
    return 
  end
  print("ElementMandatoryBags:on_executed", l_3_0._values.carry_id, l_3_0._values.amount)
  managers.loot:set_mandatory_bags_data(l_3_0._values.carry_id, l_3_0._values.amount)
  ElementMandatoryBags.super.on_executed(l_3_0, l_3_1)
end


