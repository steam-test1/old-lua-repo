-- Decompiled using luadec 2.0.1 by sztupy (http://winmo.sztupy.hu)
-- Command line was: F:\SteamLibrary\SteamApps\common\PAYDAY 2\lua\core\lib\utils\corefinitestatemachine.luac 

core:module("CoreFiniteStateMachine")
core:import("CoreDebug")
if not FiniteStateMachine then
  FiniteStateMachine = class()
end
FiniteStateMachine.init = function(l_1_0, l_1_1, l_1_2, l_1_3)
  l_1_0._object = l_1_3
  l_1_0._object_name = l_1_2
  if l_1_1 then
    l_1_0:_set_state(l_1_1)
  end
  l_1_0._debug = true
end

FiniteStateMachine.load = function(l_2_0, l_2_1)
  local class = _G[l_2_1.class_name]
  l_2_0._set_state(class)
end

FiniteStateMachine.save = function(l_3_0, l_3_1)
  l_3_1.class_name = class_name(l_3_0._state_class)
end

FiniteStateMachine.set_debug = function(l_4_0, l_4_1)
  l_4_0._debug = l_4_1
end

FiniteStateMachine.destroy = function(l_5_0)
  l_5_0:_destroy_current_state()
end

FiniteStateMachine.transition = function(l_6_0)
  assert(l_6_0._state)
  assert(l_6_0._state.transition, "You must at least have a transition method")
  local new_state_class, arg = l_6_0._state:transition()
  if new_state_class then
    l_6_0:_set_state(new_state_class, arg)
  end
end

FiniteStateMachine.state = function(l_7_0)
  assert(l_7_0._state)
  return l_7_0._state
end

FiniteStateMachine._class_name = function(l_8_0, l_8_1)
  return CoreDebug.full_class_name(l_8_1)
end

FiniteStateMachine._destroy_current_state = function(l_9_0)
  if l_9_0._state and l_9_0._state.destroy then
    l_9_0._state:destroy()
    l_9_0._state = nil
  end
end

FiniteStateMachine._set_state = function(l_10_0, l_10_1, ...)
  if l_10_0._debug then
    cat_print("debug", "transitions from '" .. l_10_0:_class_name(l_10_0._state_class) .. "' to '" .. l_10_0:_class_name(l_10_1) .. "'")
  end
  l_10_0:_destroy_current_state()
  do
    local init_function = l_10_1.init
    l_10_1.init = function()
   end
    l_10_0._state = l_10_1:new()
    assert(l_10_0._state ~= nil)
    l_10_1.init = init_function
    l_10_0._state[l_10_0._object_name] = l_10_0._object
    l_10_0._state_class = l_10_1
    if init_function then
      l_10_0._state:init(...)
    end
     -- DECOMPILER ERROR: Confused about usage of registers for local variables.

  end
end


