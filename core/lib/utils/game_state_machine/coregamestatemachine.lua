-- Decompiled using luadec 2.0.1 by sztupy (http://winmo.sztupy.hu)
-- Command line was: F:\SteamLibrary\SteamApps\common\PAYDAY 2\lua\core\lib\utils\game_state_machine\coregamestatemachine.luac 

core:module("CoreGameStateMachine")
core:import("CoreInitState")
if not GameStateMachine then
  GameStateMachine = class()
end
GameStateMachine.init = function(l_1_0, l_1_1)
  l_1_0._states = {}
  l_1_0._transitions = {}
  local init = CoreInitState._InitState:new(l_1_0)
  l_1_0._states[init:name()] = init
  if not l_1_0._transitions[init] then
    l_1_0._transitions[init] = {}
  end
  l_1_0._transitions[init][l_1_1] = init.default_transition
  l_1_0._current_state = init
  l_1_0._queued_transitions = {{l_1_1}}
  l_1_0:_do_state_change()
end

GameStateMachine.destroy = function(l_2_0)
  for _,state in pairs(l_2_0._states) do
    state:destroy()
  end
  l_2_0._states = {}
  l_2_0._transitions = {}
end

GameStateMachine.add_transition = function(l_3_0, l_3_1, l_3_2, l_3_3)
  l_3_0._states[l_3_1:name()] = l_3_1
  l_3_0._states[l_3_2:name()] = l_3_2
  if not l_3_0._transitions[l_3_1] then
    l_3_0._transitions[l_3_1] = {}
  end
  l_3_0._transitions[l_3_1][l_3_2] = l_3_3
end

GameStateMachine.current_state = function(l_4_0)
  return l_4_0._current_state
end

GameStateMachine.can_change_state = function(l_5_0, l_5_1)
  if not l_5_0._queued_transitions or not l_5_0._queued_transitions[#l_5_0._queued_transitions][1] then
    local state_from = l_5_0._current_state
  end
  local valid_transitions = l_5_0._transitions[state_from]
  return not valid_transitions or valid_transitions[l_5_1] ~= nil
end

GameStateMachine.change_state = function(l_6_0, l_6_1, l_6_2)
  if l_6_0._doing_state_change then
    Application:error("[GameStateMachine:change_state] State change during transition!")
    Application:stack_dump()
  end
  local transition_debug_string = string.format("'%s' --> '%s'", tostring(l_6_0:last_queued_state_name()), tostring(l_6_1:name()))
  cat_print("game_state_machine", "[GameStateMachine] Requested state change " .. transition_debug_string)
  if not l_6_0:can_change_state(l_6_1) and Application:production_build() then
    Application:set_pause(true)
    print("[GameStateMachine] Requesting invalid transition " .. transition_debug_string)
    Application:stack_dump()
    do return end
    if not l_6_0._queued_transitions then
      l_6_0._queued_transitions = {}
    end
    table.insert(l_6_0._queued_transitions, {l_6_1, l_6_2})
  end
end

GameStateMachine.current_state_name = function(l_7_0)
  return l_7_0._current_state:name()
end

GameStateMachine.can_change_state_by_name = function(l_8_0, l_8_1)
  local state = assert(l_8_0._states[l_8_1], "[GameStateMachine] Name '" .. tostring(l_8_1) .. "' does not correspond to a valid state.")
  return l_8_0:can_change_state(state)
end

GameStateMachine.change_state_by_name = function(l_9_0, l_9_1, l_9_2)
  local state = assert(l_9_0._states[l_9_1], "[GameStateMachine] Name '" .. tostring(l_9_1) .. "' does not correspond to a valid state.")
  l_9_0:change_state(state, l_9_2)
end

GameStateMachine.update = function(l_10_0, l_10_1, l_10_2)
  if l_10_0._current_state.update then
    l_10_0._current_state:update(l_10_1, l_10_2)
  end
end

GameStateMachine.paused_update = function(l_11_0, l_11_1, l_11_2)
  if l_11_0._current_state.paused_update then
    l_11_0._current_state:paused_update(l_11_1, l_11_2)
  end
end

GameStateMachine.end_update = function(l_12_0, l_12_1, l_12_2)
  if l_12_0._queued_transitions then
    l_12_0:_do_state_change()
  end
end

GameStateMachine._do_state_change = function(l_13_0)
  if not l_13_0._queued_transitions then
    return 
  end
  l_13_0._doing_state_change = true
  for i_transition,transition in ipairs(l_13_0._queued_transitions) do
    local new_state = transition[1]
    local params = transition[2]
    local old_state = l_13_0._current_state
    local trans_func = l_13_0._transitions[old_state][new_state]
    cat_print("game_state_machine", "[GameStateMachine] Executing state change '" .. tostring(old_state:name()) .. "' --> '" .. tostring(new_state:name()) .. "'")
    l_13_0._current_state = new_state
    trans_func(old_state, new_state, params)
  end
  l_13_0._queued_transitions = nil
  l_13_0._doing_state_change = false
end

GameStateMachine.last_queued_state_name = function(l_14_0)
  if l_14_0._queued_transitions then
    return l_14_0._queued_transitions[#l_14_0._queued_transitions][1]:name()
  else
    return l_14_0:current_state_name()
  end
end


