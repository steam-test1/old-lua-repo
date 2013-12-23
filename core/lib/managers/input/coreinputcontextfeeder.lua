-- Decompiled using luadec 2.0.1 by sztupy (http://winmo.sztupy.hu)
-- Command line was: F:\SteamLibrary\SteamApps\common\PAYDAY 2\lua\core\lib\managers\input\coreinputcontextfeeder.luac 

core:module("CoreInputContextFeeder")
core:import("CoreInputProvider")
if not Feeder then
  Feeder = class()
end
Feeder.init = function(l_1_0, l_1_1, l_1_2)
  l_1_0._engine_controller = l_1_1
  l_1_0._device_type = l_1_0._engine_controller:type()
  l_1_0._input_provider = CoreInputProvider.Provider:new(l_1_2)
  l_1_0._previous_state = {}
end

Feeder.input_provider = function(l_2_0)
  return l_2_0._input_provider
end

Feeder.update = function(l_3_0, l_3_1, l_3_2)
  local target_input_context = l_3_0._input_provider:context()
  if not target_input_context then
    return 
  end
  local context_description = target_input_context:_context_description()
  local device_layout_description = context_description:device_layout_description(l_3_0._device_type)
  if device_layout_description == nil then
    return 
  end
  local binds = device_layout_description:binds()
  local input_data = target_input_context:input()
  local controller = l_3_0._engine_controller
  for hardware_name,bind in pairs(binds) do
    local input_data_name = bind.input_target_description:target_name()
    local control_type = bind.type_name
    local data = nil
    if control_type == "axis" then
      assert(controller:has_axis(Idstring(hardware_name)), "Binding '" .. hardware_name .. "'")
      data = controller:axis(Idstring(hardware_name))
    elseif control_type == "button" then
      assert(controller:has_button(Idstring(hardware_name)), "Binding '" .. hardware_name .. "'")
      data = controller:pressed(Idstring(hardware_name))
    else
      error("Bad!")
    end
    input_data[input_data_name] = data
  end
end


