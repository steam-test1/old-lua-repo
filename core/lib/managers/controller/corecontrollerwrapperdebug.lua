-- Decompiled using luadec 2.0.1 by sztupy (http://winmo.sztupy.hu)
-- Command line was: F:\SteamLibrary\SteamApps\common\PAYDAY 2\lua\core\lib\managers\controller\corecontrollerwrapperdebug.luac 

core:module("CoreControllerWrapperDebug")
core:import("CoreControllerWrapper")
if not ControllerWrapperDebug then
  ControllerWrapperDebug = class(CoreControllerWrapper.ControllerWrapper)
end
ControllerWrapperDebug.TYPE = "debug"
ControllerWrapperDebug.init = function(l_1_0, l_1_1, l_1_2, l_1_3, l_1_4, l_1_5, l_1_6)
  l_1_0._controller_wrapper_list = l_1_1
  l_1_0._default_controller_wrapper = l_1_5
   -- DECOMPILER ERROR: Confused while interpreting a jump as a 'while'

end
ControllerWrapperDebug.super.init(l_1_0, l_1_2, l_1_3, l_1_4, {}, l_1_5:get_default_controller_id(), l_1_6, true, true)
for _,controller_wrapper in ipairs(l_1_1) do
  for controller_id,controller in pairs(controller_wrapper:get_controller_map()) do
    l_1_0._controller_map[controller_id] = controller
  end
end
end

ControllerWrapperDebug.destroy = function(l_2_0)
  ControllerWrapperDebug.super.destroy(l_2_0)
  for _,controller_wrapper in ipairs(l_2_0._controller_wrapper_list) do
    controller_wrapper:destroy()
  end
end

ControllerWrapperDebug.update = function(l_3_0, l_3_1, l_3_2)
  ControllerWrapperDebug.super.update(l_3_0, l_3_1, l_3_2)
  for _,controller_wrapper in ipairs(l_3_0._controller_wrapper_list) do
    controller_wrapper:update(l_3_1, l_3_2)
  end
end

ControllerWrapperDebug.paused_update = function(l_4_0, l_4_1, l_4_2)
  ControllerWrapperDebug.super.paused_update(l_4_0, l_4_1, l_4_2)
  for _,controller_wrapper in ipairs(l_4_0._controller_wrapper_list) do
    controller_wrapper:paused_update(l_4_1, l_4_2)
  end
end

ControllerWrapperDebug.connected = function(l_5_0, ...)
  for _,controller_wrapper in ipairs(l_5_0._controller_wrapper_list) do
    if controller_wrapper:connected(...) then
      return true
    end
  end
  return false
   -- DECOMPILER ERROR: Confused about usage of registers for local variables.

end

ControllerWrapperDebug.rebind_connections = function(l_6_0, l_6_1, l_6_2)
  ControllerWrapperDebug.super.rebind_connections(l_6_0)
  for _,controller_wrapper in ipairs(l_6_0._controller_wrapper_list) do
    controller_wrapper:rebind_connections(l_6_2[controller_wrapper:get_type()], l_6_2)
  end
end

ControllerWrapperDebug.setup = function(l_7_0, ...)
   -- DECOMPILER ERROR: Confused about usage of registers for local variables.

end

ControllerWrapperDebug.get_any_input = function(l_8_0, ...)
  for _,controller_wrapper in ipairs(l_8_0._controller_wrapper_list) do
    if controller_wrapper:get_any_input(...) then
      return true
    end
  end
  return false
   -- DECOMPILER ERROR: Confused about usage of registers for local variables.

end

ControllerWrapperDebug.get_any_input_pressed = function(l_9_0, ...)
  for _,controller_wrapper in ipairs(l_9_0._controller_wrapper_list) do
    if controller_wrapper:get_any_input_pressed(...) then
      return true
    end
  end
  return false
   -- DECOMPILER ERROR: Confused about usage of registers for local variables.

end

ControllerWrapperDebug.get_input_pressed = function(l_10_0, ...)
  for _,controller_wrapper in ipairs(l_10_0._controller_wrapper_list) do
    if controller_wrapper:connection_exist(...) and controller_wrapper:get_input_pressed(...) then
      return true
    end
  end
  return false
   -- DECOMPILER ERROR: Confused about usage of registers for local variables.

end

ControllerWrapperDebug.get_input_bool = function(l_11_0, ...)
  for _,controller_wrapper in ipairs(l_11_0._controller_wrapper_list) do
    if controller_wrapper:connection_exist(...) and controller_wrapper:get_input_bool(...) then
      return true
    end
  end
  return false
   -- DECOMPILER ERROR: Confused about usage of registers for local variables.

end

ControllerWrapperDebug.get_input_float = function(l_12_0, ...)
  do
    local input_float = 0
    for _,controller_wrapper in ipairs(l_12_0._controller_wrapper_list) do
      if controller_wrapper:connection_exist(...) then
        input_float = math.max(input_float, controller_wrapper:get_input_float(...))
      end
    end
    return input_float
  end
   -- DECOMPILER ERROR: Confused about usage of registers for local variables.

end

ControllerWrapperDebug.get_input_axis = function(l_13_0, ...)
  do
    local input_axis = Vector3(0, 0, 0)
    for _,controller_wrapper in ipairs(l_13_0._controller_wrapper_list) do
      if controller_wrapper:connection_exist(...) then
        local next_input_axis = controller_wrapper:get_input_axis(...)
        if input_axis:length() < next_input_axis:length() then
          input_axis = next_input_axis
        end
      end
    end
    return input_axis
  end
   -- DECOMPILER ERROR: Confused about usage of registers for local variables.

end

ControllerWrapperDebug.get_connection_map = function(l_14_0, ...)
  do
    local map = {}
    for _,controller_wrapper in ipairs(l_14_0._controller_wrapper_list) do
      local sub_map = controller_wrapper:get_connection_map(...)
      for k,v in pairs(sub_map) do
        map[k] = v
      end
    end
    return map
  end
   -- DECOMPILER ERROR: Confused about usage of registers for local variables.

end

ControllerWrapperDebug.connection_exist = function(l_15_0, ...)
  for _,controller_wrapper in ipairs(l_15_0._controller_wrapper_list) do
    if controller_wrapper:connection_exist(...) then
      return true
    end
  end
  return false
   -- DECOMPILER ERROR: Confused about usage of registers for local variables.

end

ControllerWrapperDebug.set_enabled = function(l_16_0, ...)
  for _,controller_wrapper in ipairs(l_16_0._controller_wrapper_list) do
    controller_wrapper:set_enabled(...)
  end
   -- DECOMPILER ERROR: Confused about usage of registers for local variables.

end

ControllerWrapperDebug.enable = function(l_17_0, ...)
  for _,controller_wrapper in ipairs(l_17_0._controller_wrapper_list) do
    controller_wrapper:enable(...)
  end
  l_17_0._enabled = true
   -- DECOMPILER ERROR: Confused about usage of registers for local variables.

end

ControllerWrapperDebug.disable = function(l_18_0, ...)
  for _,controller_wrapper in ipairs(l_18_0._controller_wrapper_list) do
    controller_wrapper:disable(...)
  end
  l_18_0._enabled = false
   -- DECOMPILER ERROR: Confused about usage of registers for local variables.

end

ControllerWrapperDebug.add_trigger = function(l_19_0, ...)
  for _,controller_wrapper in ipairs(l_19_0._controller_wrapper_list) do
    if controller_wrapper:connection_exist(...) then
      controller_wrapper:add_trigger(...)
    end
  end
   -- DECOMPILER ERROR: Confused about usage of registers for local variables.

end

ControllerWrapperDebug.add_release_trigger = function(l_20_0, ...)
  for _,controller_wrapper in ipairs(l_20_0._controller_wrapper_list) do
    if controller_wrapper:connection_exist(...) then
      controller_wrapper:add_release_trigger(...)
    end
  end
   -- DECOMPILER ERROR: Confused about usage of registers for local variables.

end

ControllerWrapperDebug.remove_trigger = function(l_21_0, ...)
  for _,controller_wrapper in ipairs(l_21_0._controller_wrapper_list) do
    if controller_wrapper:connection_exist(...) then
      controller_wrapper:remove_trigger(...)
    end
  end
   -- DECOMPILER ERROR: Confused about usage of registers for local variables.

end

ControllerWrapperDebug.clear_triggers = function(l_22_0, ...)
  for _,controller_wrapper in ipairs(l_22_0._controller_wrapper_list) do
    controller_wrapper:clear_triggers(...)
  end
   -- DECOMPILER ERROR: Confused about usage of registers for local variables.

end

ControllerWrapperDebug.reset_cache = function(l_23_0, ...)
  for _,controller_wrapper in ipairs(l_23_0._controller_wrapper_list) do
    controller_wrapper:reset_cache(...)
  end
   -- DECOMPILER ERROR: Confused about usage of registers for local variables.

end

ControllerWrapperDebug.restore_triggers = function(l_24_0, ...)
  for _,controller_wrapper in ipairs(l_24_0._controller_wrapper_list) do
    controller_wrapper:restore_triggers(...)
  end
   -- DECOMPILER ERROR: Confused about usage of registers for local variables.

end

ControllerWrapperDebug.clear_connections = function(l_25_0, ...)
  for _,controller_wrapper in ipairs(l_25_0._controller_wrapper_list) do
    controller_wrapper:clear_connections(...)
  end
   -- DECOMPILER ERROR: Confused about usage of registers for local variables.

end

ControllerWrapperDebug.get_setup = function(l_26_0, ...)
  if l_26_0._default_controller_wrapper then
    return l_26_0._default_controller_wrapper:get_setup(...)
     -- DECOMPILER ERROR: Confused about usage of registers for local variables.

  end
end

ControllerWrapperDebug.get_connection_settings = function(l_27_0, ...)
  if l_27_0._default_controller_wrapper then
    return l_27_0._default_controller_wrapper:get_connection_settings(...)
     -- DECOMPILER ERROR: Confused about usage of registers for local variables.

  end
end

ControllerWrapperDebug.get_connection_enabled = function(l_28_0, ...)
  for _,controller_wrapper in ipairs(l_28_0._controller_wrapper_list) do
    if controller_wrapper:get_connection_enabled(...) then
      return true
    end
  end
  return false
   -- DECOMPILER ERROR: Confused about usage of registers for local variables.

end

ControllerWrapperDebug.set_connection_enabled = function(l_29_0, ...)
  for _,controller_wrapper in ipairs(l_29_0._controller_wrapper_list) do
    controller_wrapper:set_connection_enabled(...)
  end
   -- DECOMPILER ERROR: Confused about usage of registers for local variables.

end


