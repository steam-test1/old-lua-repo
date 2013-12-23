-- Decompiled using luadec 2.0.1 by sztupy (http://winmo.sztupy.hu)
-- Command line was: F:\SteamLibrary\SteamApps\common\PAYDAY 2\lua\core\lib\managers\input\coreinputsettingsreader.luac 

core:module("CoreInputSettingsReader")
core:import("CoreInputLayerDescription")
core:import("CoreInputContextDescription")
core:import("CoreInputLayoutDescription")
core:import("CoreInputDeviceLayoutDescription")
core:import("CoreInputTargetDescription")
if not SettingsReader then
  SettingsReader = class()
end
SettingsReader.db_type = "input_settings"
SettingsReader.db_path = "settings/input"
SettingsReader.init = function(l_1_0)
  l_1_0._layer_descriptions = {}
  l_1_0:_read_settings()
end

SettingsReader.layer_descriptions = function(l_2_0)
  return l_2_0._layer_descriptions
end

SettingsReader._read_settings = function(l_3_0)
  if not DB:has(SettingsReader.db_type, SettingsReader.db_path) then
    return 
  end
  local xml_node = DB:load_node(SettingsReader.db_type, SettingsReader.db_path)
  local xml_node_children = xml_node:children()
  l_3_0:_read_children(xml_node_children)
end

SettingsReader._read_children = function(l_4_0, l_4_1)
  l_4_0._layer_descriptions = {}
  local layer_description_priority = 1
  for node in l_4_1 do
    assert(node:name() == "layer")
    local layer_description = CoreInputLayerDescription.LayerDescription:new(node:parameter("name"), layer_description_priority)
    l_4_0:_read_layer_description_children(node:children(), layer_description)
    l_4_0._layer_descriptions[layer_description:layer_description_name()] = layer_description
    layer_description_priority = layer_description_priority + 1
  end
end

SettingsReader._read_layer_description_children = function(l_5_0, l_5_1, l_5_2)
  for node in l_5_1 do
    assert(node:name() == "context")
    local context_description = CoreInputContextDescription.ContextDescription:new(node:parameter("name"))
    l_5_2:set_context_description(context_description)
    l_5_0:_read_context_description_children(node:children(), context_description)
  end
end

SettingsReader._read_context_description_children = function(l_6_0, l_6_1, l_6_2)
  for node in l_6_1 do
    if node:name() == "input" then
      l_6_0:_read_input(node, l_6_2)
      for (for control) in (for generator) do
      end
      if node:name() == "layouts" then
        l_6_0:_read_layout_descriptions_children(node:children(), l_6_2)
        for (for control) in (for generator) do
        end
        if node:name() == "context" then
          local new_context_description = CoreInputContextDescription.ContextDescription:new(node:parameter("name"))
          l_6_2:add_context_description(new_context_description)
          l_6_0:_read_context_description_children(node:children(), new_context_description)
        end
      end
       -- Warning: missing end command somewhere! Added here
    end
     -- Warning: missing end command somewhere! Added here
  end
end

SettingsReader._read_input = function(l_7_0, l_7_1, l_7_2)
  local type_name = l_7_1:parameter("type")
  local name = l_7_1:parameter("name")
  local input_target_description = CoreInputTargetDescription.TargetDescription:new(name, type_name)
  l_7_2:add_input_target_description(input_target_description)
end

SettingsReader._read_layout_descriptions_children = function(l_8_0, l_8_1, l_8_2)
  for node in l_8_1 do
    assert(node:name() == "layout")
    local layout_description = CoreInputLayoutDescription.LayoutDescription:new(node:parameter("name"))
    l_8_0:_read_layout_description_children(node:children(), l_8_2, layout_description)
    l_8_2:add_layout_description(layout_description)
  end
end

SettingsReader._read_layout_description_children = function(l_9_0, l_9_1, l_9_2, l_9_3)
  for node in l_9_1 do
    assert(node:name() == "device", "Only <device> is allowed as children to <layout>. Encountered '" .. node:name() .. "'")
    local device_layout_description = CoreInputDeviceLayoutDescription.DeviceLayoutDescription:new(node:parameter("type"))
    l_9_0:_read_device_layout_description_children(node:children(), l_9_2, device_layout_description)
    l_9_3:add_device_layout_description(device_layout_description)
  end
end

SettingsReader._read_device_layout_description_children = function(l_10_0, l_10_1, l_10_2, l_10_3)
  for node in l_10_1 do
    assert(node:name() == "bind")
    l_10_0:_read_bind(node, l_10_2, l_10_3)
  end
end

SettingsReader._read_bind = function(l_11_0, l_11_1, l_11_2, l_11_3)
  local axis_name = l_11_1:parameter("axis")
  local input_name = l_11_1:parameter("input")
  local input_target_description = l_11_2:input_target_description(input_name)
  assert(input_target_description, "Illegal input target name:'" .. input_name .. "'")
  if axis_name then
    l_11_3:add_bind_axis(axis_name, input_target_description)
  else
    local button_name = l_11_1:parameter("button")
    if button_name then
      l_11_3:add_bind_button(button_name, input_target_description)
    else
      assert(false, "Unknown source, must be button or axis")
    end
  end
end


