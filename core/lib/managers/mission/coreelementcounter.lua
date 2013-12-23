-- Decompiled using luadec 2.0.1 by sztupy (http://winmo.sztupy.hu)
-- Command line was: F:\SteamLibrary\SteamApps\common\PAYDAY 2\lua\core\lib\managers\mission\coreelementcounter.luac 

core:module("CoreElementCounter")
core:import("CoreMissionScriptElement")
core:import("CoreClass")
if not ElementCounter then
  ElementCounter = class(CoreMissionScriptElement.MissionScriptElement)
end
ElementCounter.init = function(l_1_0, ...)
  ElementCounter.super.init(l_1_0, ...)
  l_1_0._original_value = l_1_0._values.counter_target
  l_1_0._triggers = {}
   -- DECOMPILER ERROR: Confused about usage of registers for local variables.

end

ElementCounter.on_executed = function(l_2_0, l_2_1)
  if not l_2_0._values.enabled then
    return 
  end
  if l_2_0._values.counter_target > 0 then
    l_2_0._values.counter_target = l_2_0._values.counter_target - 1
    if l_2_0:is_debug() then
      l_2_0._mission_script:debug_output("Counter " .. l_2_0._editor_name .. ": " .. l_2_0._values.counter_target .. " Previous value: " .. l_2_0._values.counter_target + 1, Color(1, 0, 0.75, 0))
    end
    if l_2_0._values.counter_target == 0 then
      ElementCounter.super.on_executed(l_2_0, l_2_1)
    else
      if l_2_0:is_debug() then
        l_2_0._mission_script:debug_output("Counter " .. l_2_0._editor_name .. ": already exhausted!", Color(1, 0, 0.75, 0))
      end
    end
  end
end

ElementCounter.reset_counter_target = function(l_3_0, l_3_1)
  l_3_0._values.counter_target = l_3_1
end

ElementCounter.counter_operation_add = function(l_4_0, l_4_1)
  l_4_0._values.counter_target = l_4_0._values.counter_target + l_4_1
  l_4_0:_check_triggers("add")
  l_4_0:_check_triggers("value")
end

ElementCounter.counter_operation_subtract = function(l_5_0, l_5_1)
  l_5_0._values.counter_target = l_5_0._values.counter_target - l_5_1
  l_5_0:_check_triggers("subtract")
  l_5_0:_check_triggers("value")
end

ElementCounter.counter_operation_reset = function(l_6_0, l_6_1)
  l_6_0._values.counter_target = l_6_0._original_value
  l_6_0:_check_triggers("reset")
  l_6_0:_check_triggers("value")
end

ElementCounter.counter_operation_set = function(l_7_0, l_7_1)
  l_7_0._values.counter_target = l_7_1
  l_7_0:_check_triggers("set")
  l_7_0:_check_triggers("value")
end

ElementCounter.apply_job_value = function(l_8_0, l_8_1)
  local type = CoreClass.type_name(l_8_1)
  if type ~= "number" then
    Application:error("[ElementCounter:apply_job_value] " .. l_8_0._id .. "(" .. l_8_0._editor_name .. ") Can't apply job value of type " .. type)
    return 
  end
  l_8_0:counter_operation_set(l_8_1)
end

ElementCounter.add_trigger = function(l_9_0, l_9_1, l_9_2, l_9_3, l_9_4)
  if not l_9_0._triggers[l_9_2] then
    l_9_0._triggers[l_9_2] = {}
  end
  l_9_0._triggers[l_9_2][l_9_1] = {amount = l_9_3, callback = l_9_4}
end

ElementCounter.counter_value = function(l_10_0)
  return l_10_0._values.counter_target
end

ElementCounter._check_triggers = function(l_11_0, l_11_1)
  if not l_11_0._triggers[l_11_1] then
    return 
  end
  for id,cb_data in pairs(l_11_0._triggers[l_11_1]) do
    if l_11_1 ~= "value" or cb_data.amount == l_11_0._values.counter_target then
      cb_data.callback()
    end
  end
end

if not ElementCounterReset then
  ElementCounterReset = class(CoreMissionScriptElement.MissionScriptElement)
end
ElementCounterReset.init = function(l_12_0, ...)
  ElementCounterReset.super.init(l_12_0, ...)
   -- DECOMPILER ERROR: Confused about usage of registers for local variables.

end

ElementCounterReset.on_executed = function(l_13_0, l_13_1)
  if not l_13_0._values.enabled then
    return 
  end
  for _,id in ipairs(l_13_0._values.elements) do
    local element = l_13_0:get_mission_element(id)
    if element then
      if l_13_0:is_debug() then
        l_13_0._mission_script:debug_output("Counter reset " .. element:editor_name() .. " to: " .. l_13_0._values.counter_target, Color(1, 0, 0.75, 0))
      end
      element:reset_counter_target(l_13_0._values.counter_target)
    end
  end
  ElementCounterReset.super.on_executed(l_13_0, l_13_1)
end

if not ElementCounterOperator then
  ElementCounterOperator = class(CoreMissionScriptElement.MissionScriptElement)
end
ElementCounterOperator.init = function(l_14_0, ...)
  ElementCounterOperator.super.init(l_14_0, ...)
   -- DECOMPILER ERROR: Confused about usage of registers for local variables.

end

ElementCounterOperator.client_on_executed = function(l_15_0, ...)
   -- DECOMPILER ERROR: Confused about usage of registers for local variables.

end

ElementCounterOperator.on_executed = function(l_16_0, l_16_1)
  if not l_16_0._values.enabled then
    return 
  end
  for _,id in ipairs(l_16_0._values.elements) do
    local element = l_16_0:get_mission_element(id)
    if element then
      if l_16_0._values.operation == "add" then
        element:counter_operation_add(l_16_0._values.amount)
        for (for control),_ in (for generator) do
        end
        if l_16_0._values.operation == "subtract" then
          element:counter_operation_subtract(l_16_0._values.amount)
          for (for control),_ in (for generator) do
          end
          if l_16_0._values.operation == "reset" then
            element:counter_operation_reset(l_16_0._values.amount)
            for (for control),_ in (for generator) do
            end
            if l_16_0._values.operation == "set" then
              element:counter_operation_set(l_16_0._values.amount)
            end
          end
        end
        ElementCounterOperator.super.on_executed(l_16_0, l_16_1)
         -- Warning: missing end command somewhere! Added here
      end
       -- Warning: missing end command somewhere! Added here
    end
     -- Warning: missing end command somewhere! Added here
  end
end

if not ElementCounterTrigger then
  ElementCounterTrigger = class(CoreMissionScriptElement.MissionScriptElement)
end
ElementCounterTrigger.init = function(l_17_0, ...)
  ElementCounterTrigger.super.init(l_17_0, ...)
   -- DECOMPILER ERROR: Confused about usage of registers for local variables.

end

ElementCounterTrigger.on_script_activated = function(l_18_0)
  for _,id in ipairs(l_18_0._values.elements) do
    local element = l_18_0:get_mission_element(id)
    element:add_trigger(l_18_0._id, l_18_0._values.trigger_type, l_18_0._values.amount, callback(l_18_0, l_18_0, "on_executed"))
  end
end

ElementCounterTrigger.client_on_executed = function(l_19_0, ...)
   -- DECOMPILER ERROR: Confused about usage of registers for local variables.

end

ElementCounterTrigger.on_executed = function(l_20_0, l_20_1)
  if not l_20_0._values.enabled then
    return 
  end
  ElementCounterTrigger.super.on_executed(l_20_0, l_20_1)
end

if not ElementCounterFilter then
  ElementCounterFilter = class(CoreMissionScriptElement.MissionScriptElement)
end
ElementCounterFilter.init = function(l_21_0, ...)
  ElementCounterFilter.super.init(l_21_0, ...)
   -- DECOMPILER ERROR: Confused about usage of registers for local variables.

end

ElementCounterFilter.on_script_activated = function(l_22_0)
end

ElementCounterFilter.client_on_executed = function(l_23_0, ...)
   -- DECOMPILER ERROR: Confused about usage of registers for local variables.

end

ElementCounterFilter.on_executed = function(l_24_0, l_24_1)
  if not l_24_0._values.enabled then
    return 
  end
  if not l_24_0:_values_ok() then
    return 
  end
  ElementCounterFilter.super.on_executed(l_24_0, l_24_1)
end

ElementCounterFilter._values_ok = function(l_25_0)
  if l_25_0._values.check_type == "counters_equal" then
    local test_value = nil
    for _,id in ipairs(l_25_0._values.elements) do
      local element = l_25_0:get_mission_element(id)
      if not test_value then
        test_value = element:counter_value()
      end
      if test_value ~= element:counter_value() then
        return false
      end
    end
    return true
  end
  if l_25_0._values.needed_to_execute == "all" then
    return l_25_0:_all_counters_ok()
  end
  if l_25_0._values.needed_to_execute == "any" then
    return l_25_0:_any_counters_ok()
  end
end

ElementCounterFilter._all_counters_ok = function(l_26_0)
  for _,id in ipairs(l_26_0._values.elements) do
    if not l_26_0:_check_type(l_26_0:get_mission_element(id)) then
      return false
    end
  end
  return true
end

ElementCounterFilter._any_counters_ok = function(l_27_0)
  for _,id in ipairs(l_27_0._values.elements) do
    if l_27_0:_check_type(l_27_0:get_mission_element(id)) then
      return true
    end
  end
  return false
end

ElementCounterFilter._check_type = function(l_28_0, l_28_1)
  if l_28_1:counter_value() ~= l_28_0._values.value then
    return l_28_0._values.check_type and l_28_0._values.check_type ~= "equal"
  end
  if l_28_1:counter_value() > l_28_0._values.value then
    return l_28_0._values.check_type ~= "less_or_equal"
  end
  if l_28_0._values.value > l_28_1:counter_value() then
    return l_28_0._values.check_type ~= "greater_or_equal"
  end
  if l_28_1:counter_value() >= l_28_0._values.value then
    return l_28_0._values.check_type ~= "less_than"
  end
  if l_28_0._values.value >= l_28_1:counter_value() then
    return l_28_0._values.check_type ~= "greater_than"
  end
end


