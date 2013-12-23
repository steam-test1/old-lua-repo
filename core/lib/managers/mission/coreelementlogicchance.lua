-- Decompiled using luadec 2.0.1 by sztupy (http://winmo.sztupy.hu)
-- Command line was: F:\SteamLibrary\SteamApps\common\PAYDAY 2\lua\core\lib\managers\mission\coreelementlogicchance.luac 

core:module("CoreElementLogicChance")
core:import("CoreMissionScriptElement")
if not ElementLogicChance then
  ElementLogicChance = class(CoreMissionScriptElement.MissionScriptElement)
end
ElementLogicChance.init = function(l_1_0, ...)
  ElementLogicChance.super.init(l_1_0, ...)
  l_1_0._chance = l_1_0._values.chance
  l_1_0._triggers = {}
   -- DECOMPILER ERROR: Confused about usage of registers for local variables.

end

ElementLogicChance.client_on_executed = function(l_2_0, ...)
   -- DECOMPILER ERROR: Confused about usage of registers for local variables.

end

ElementLogicChance.on_executed = function(l_3_0, l_3_1)
  if not l_3_0._values.enabled then
    return 
  end
  local roll = math.random(100)
  if l_3_0._chance < roll then
    l_3_0:_trigger_outcome("fail")
    return 
  end
  l_3_0:_trigger_outcome("success")
  ElementLogicChance.super.on_executed(l_3_0, l_3_1)
end

ElementLogicChance.chance_operation_add_chance = function(l_4_0, l_4_1)
  l_4_0._chance = l_4_0._chance + l_4_1
end

ElementLogicChance.chance_operation_subtract_chance = function(l_5_0, l_5_1)
  l_5_0._chance = l_5_0._chance - l_5_1
end

ElementLogicChance.chance_operation_reset = function(l_6_0)
  l_6_0._chance = l_6_0._values.chance
end

ElementLogicChance.chance_operation_set_chance = function(l_7_0, l_7_1)
  l_7_0._chance = l_7_1
end

ElementLogicChance.add_trigger = function(l_8_0, l_8_1, l_8_2, l_8_3)
  l_8_0._triggers[l_8_1] = {outcome = l_8_2, callback = l_8_3}
end

ElementLogicChance.remove_trigger = function(l_9_0, l_9_1)
  l_9_0._triggers[l_9_1] = nil
end

ElementLogicChance._trigger_outcome = function(l_10_0, l_10_1)
  for _,data in pairs(l_10_0._triggers) do
    if data.outcome == l_10_1 then
      data.callback()
    end
  end
end

if not ElementLogicChanceOperator then
  ElementLogicChanceOperator = class(CoreMissionScriptElement.MissionScriptElement)
end
ElementLogicChanceOperator.init = function(l_11_0, ...)
  ElementLogicChanceOperator.super.init(l_11_0, ...)
   -- DECOMPILER ERROR: Confused about usage of registers for local variables.

end

ElementLogicChanceOperator.client_on_executed = function(l_12_0, ...)
   -- DECOMPILER ERROR: Confused about usage of registers for local variables.

end

ElementLogicChanceOperator.on_executed = function(l_13_0, l_13_1)
  if not l_13_0._values.enabled then
    return 
  end
  for _,id in ipairs(l_13_0._values.elements) do
    local element = l_13_0:get_mission_element(id)
    if element then
      if l_13_0._values.operation == "add_chance" then
        element:chance_operation_add_chance(l_13_0._values.chance)
        for (for control),_ in (for generator) do
        end
        if l_13_0._values.operation == "subtract_chance" then
          element:chance_operation_subtract_chance(l_13_0._values.chance)
          for (for control),_ in (for generator) do
          end
          if l_13_0._values.operation == "reset" then
            element:chance_operation_reset()
            for (for control),_ in (for generator) do
            end
            if l_13_0._values.operation == "set_chance" then
              element:chance_operation_set_chance(l_13_0._values.chance)
            end
          end
        end
        ElementLogicChanceOperator.super.on_executed(l_13_0, l_13_1)
         -- Warning: missing end command somewhere! Added here
      end
       -- Warning: missing end command somewhere! Added here
    end
     -- Warning: missing end command somewhere! Added here
  end
end

if not ElementLogicChanceTrigger then
  ElementLogicChanceTrigger = class(CoreMissionScriptElement.MissionScriptElement)
end
ElementLogicChanceTrigger.init = function(l_14_0, ...)
  ElementLogicChanceTrigger.super.init(l_14_0, ...)
   -- DECOMPILER ERROR: Confused about usage of registers for local variables.

end

ElementLogicChanceTrigger.on_script_activated = function(l_15_0)
  for _,id in ipairs(l_15_0._values.elements) do
    local element = l_15_0:get_mission_element(id)
    element:add_trigger(l_15_0._id, l_15_0._values.outcome, callback(l_15_0, l_15_0, "on_executed"))
  end
end

ElementLogicChanceTrigger.client_on_executed = function(l_16_0, ...)
   -- DECOMPILER ERROR: Confused about usage of registers for local variables.

end

ElementLogicChanceTrigger.on_executed = function(l_17_0, l_17_1)
  if not l_17_0._values.enabled then
    return 
  end
  ElementLogicChanceTrigger.super.on_executed(l_17_0, l_17_1)
end


