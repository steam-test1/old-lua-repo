-- Decompiled using luadec 2.0.1 by sztupy (http://winmo.sztupy.hu)
-- Command line was: F:\SteamLibrary\SteamApps\common\PAYDAY 2\lua\lib\managers\mission\elementlootsecuredtrigger.luac 

core:import("CoreMissionScriptElement")
if not ElementLootSecuredTrigger then
  ElementLootSecuredTrigger = class(CoreMissionScriptElement.MissionScriptElement)
end
ElementLootSecuredTrigger.init = function(l_1_0, ...)
  ElementLootSecuredTrigger.super.init(l_1_0, ...)
   -- DECOMPILER ERROR: Confused about usage of registers for local variables.

end

ElementLootSecuredTrigger.client_on_executed = function(l_2_0, ...)
   -- DECOMPILER ERROR: Confused about usage of registers for local variables.

end

ElementLootSecuredTrigger.on_script_activated = function(l_3_0)
  if l_3_0._values.report_only then
    managers.loot:add_trigger(l_3_0._id, "report_only", l_3_0._values.amount, callback(l_3_0, l_3_0, "on_executed"))
  else
    managers.loot:add_trigger(l_3_0._id, l_3_0._values.include_instant_cash and "total_amount" or "amount", l_3_0._values.amount, callback(l_3_0, l_3_0, "on_executed"))
  end
end

ElementLootSecuredTrigger.on_executed = function(l_4_0, l_4_1)
  if not l_4_0._values.enabled then
    return 
  end
  ElementLootSecuredTrigger.super.on_executed(l_4_0, l_4_1)
end


