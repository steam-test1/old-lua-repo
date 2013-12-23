-- Decompiled using luadec 2.0.1 by sztupy (http://winmo.sztupy.hu)
-- Command line was: F:\SteamLibrary\SteamApps\common\PAYDAY 2\lua\core\lib\managers\input\coreinputcontextstack.luac 

core:module("CoreInputContextStack")
core:import("CoreStack")
if not Stack then
  Stack = class()
end
Stack.init = function(l_1_0, l_1_1)
  l_1_0._device_type = l_1_1
  l_1_0._active_input_context = CoreStack.Stack:new()
end

Stack.destroy = function(l_2_0)
  l_2_0._active_input_context:destroy()
end

Stack.active_device_layout = function(l_3_0)
  local target_context = l_3_0._active_input_context:top()
  return target_context:device_layout(l_3_0._device_type)
end

Stack.active_context = function(l_4_0)
  if l_4_0._active_input_context:is_empty() then
    return 
  end
  return l_4_0._active_input_context:top()
end

Stack.pop_input_context = function(l_5_0, l_5_1)
  assert(l_5_0._active_input_context:top() == l_5_1)
  l_5_0._active_input_context:pop()
end

Stack.push_input_context = function(l_6_0, l_6_1)
  l_6_0._active_input_context:push(l_6_1)
end


