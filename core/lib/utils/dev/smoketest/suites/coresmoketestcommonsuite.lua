-- Decompiled using luadec 2.0.1 by sztupy (http://winmo.sztupy.hu)
-- Command line was: F:\SteamLibrary\SteamApps\common\PAYDAY 2\lua\core\lib\utils\dev\smoketest\suites\coresmoketestcommonsuite.luac 

core:module("CoreSmoketestCommonSuite")
core:import("CoreClass")
core:import("CoreSmoketestSuite")
if not Substep then
  Substep = CoreClass.class()
end
Substep.init = function(l_1_0, l_1_1, l_1_2)
  l_1_0._suite = l_1_1
  l_1_0._step_arguments = l_1_2
  l_1_0:start()
end

Substep.has_failed = function(l_2_0)
  return l_2_0._fail == true
end

Substep.is_done = function(l_3_0)
  return l_3_0._done
end

Substep._set_done = function(l_4_0)
  l_4_0._done = true
  l_4_0._fail = false
end

Substep._set_fail = function(l_5_0)
  l_5_0._fail = true
end

Substep.start = function(l_6_0)
  assert(false, "Not implemented")
end

Substep.update = function(l_7_0, l_7_1, l_7_2)
end

if not CallAndDoneSubstep then
  CallAndDoneSubstep = CoreClass.class(Substep)
end
CallAndDoneSubstep.step_arguments = function(l_8_0)
  local step_arguments = {}
  step_arguments.callback = l_8_0
  return step_arguments
end

CallAndDoneSubstep.start = function(l_9_0)
  l_9_0._step_arguments.callback()
  l_9_0:_set_done()
end

if not WaitEventSubstep then
  WaitEventSubstep = CoreClass.class(Substep)
end
WaitEventSubstep.step_arguments = function(l_10_0)
  local step_arguments = {}
  step_arguments.event_id = l_10_0
  return step_arguments
end

WaitEventSubstep.start = function(l_11_0)
  l_11_0._event_listener = EventManager:register_listener(l_11_0._step_arguments.event_id, function()
    self:_set_done()
   end, nil)
end

WaitEventSubstep.destroy = function(l_12_0)
  EventManager:unregister_listener(l_12_0._event_listener)
end

if not CallAndWaitEventSubstep then
  CallAndWaitEventSubstep = CoreClass.class(Substep)
end
CallAndWaitEventSubstep.step_arguments = function(l_13_0, l_13_1)
  local step_arguments = {}
  step_arguments.callback = l_13_0
  step_arguments.event_id = l_13_1
  return step_arguments
end

CallAndWaitEventSubstep.start = function(l_14_0)
  l_14_0._event_listener = EventManager:register_listener(l_14_0._step_arguments.event_id, function()
    self:_set_done()
   end, nil)
  l_14_0._step_arguments.callback()
end

CallAndWaitEventSubstep.destroy = function(l_15_0)
  EventManager:unregister_listener(l_15_0._event_listener)
end

if not DelaySubstep then
  DelaySubstep = CoreClass.class(Substep)
end
DelaySubstep.step_arguments = function(l_16_0)
  local step_arguments = {}
  step_arguments.seconds = l_16_0
  return step_arguments
end

DelaySubstep.start = function(l_17_0)
  l_17_0._seconds_left = l_17_0._step_arguments.seconds
end

DelaySubstep.update = function(l_18_0, l_18_1, l_18_2)
  l_18_0._seconds_left = l_18_0._seconds_left - l_18_2
  if l_18_0._seconds_left <= 0 then
    l_18_0:_set_done()
  end
end

if not CommonSuite then
  CommonSuite = CoreClass.class(CoreSmoketestSuite.Suite)
end
CommonSuite.init = function(l_19_0)
  l_19_0._step_list = {}
end

CommonSuite.add_step = function(l_20_0, l_20_1, l_20_2, l_20_3)
  local step_entry = {}
  step_entry.name = l_20_1
  step_entry.class = l_20_2
  step_entry.params = l_20_3
  table.insert(l_20_0._step_list, step_entry)
end

CommonSuite.start = function(l_21_0, l_21_1, l_21_2, l_21_3)
  l_21_0._suite_arguments = l_21_3
  l_21_0._session_state = l_21_1
  l_21_0._reporter = l_21_2
  l_21_0._is_done = false
  l_21_0._current_step_id = 0
  l_21_0:next_step()
end

CommonSuite.is_done = function(l_22_0)
  return l_22_0._is_done
end

CommonSuite.update = function(l_23_0, l_23_1, l_23_2)
  if l_23_0._current_step then
    l_23_0._current_step:update(l_23_1, l_23_2)
    if l_23_0._current_step:is_done() then
      if l_23_0._current_step:has_failed() then
        l_23_0._reporter:fail_substep(l_23_0._step_list[l_23_0._current_step_id].name)
      else
        l_23_0._reporter:end_substep(l_23_0._step_list[l_23_0._current_step_id].name)
      end
      if not l_23_0:next_step() then
        l_23_0._is_done = true
      end
    end
  end
end

CommonSuite.next_step = function(l_24_0)
  if l_24_0._current_step and l_24_0._current_step.destroy then
    l_24_0._current_step:destroy()
  end
  l_24_0._current_step = nil
  l_24_0._current_step_id = l_24_0._current_step_id + 1
  if l_24_0._current_step_id <= #l_24_0._step_list then
    local step_entry = l_24_0._step_list[l_24_0._current_step_id]
    l_24_0._reporter:begin_substep(step_entry.name)
    l_24_0._current_step = step_entry.class:new(l_24_0, step_entry.params)
    return true
  else
    return false
  end
end

CommonSuite.get_argument = function(l_25_0, l_25_1)
  assert(l_25_0._suite_arguments[l_25_1], "Suite argument '" .. l_25_1 .. "' was not defined")
  return l_25_0._suite_arguments[l_25_1]
end


