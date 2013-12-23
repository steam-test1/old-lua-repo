-- Decompiled using luadec 2.0.1 by sztupy (http://winmo.sztupy.hu)
-- Command line was: F:\SteamLibrary\SteamApps\common\PAYDAY 2\lua\core\lib\managers\cutscene\keys\coreunitcallbackcutscenekey.luac 

require("core/lib/managers/cutscene/keys/CoreCutsceneKeyBase")
if not CoreUnitCallbackCutsceneKey then
  CoreUnitCallbackCutsceneKey = class(CoreCutsceneKeyBase)
end
CoreUnitCallbackCutsceneKey.ELEMENT_NAME = "unit_callback"
CoreUnitCallbackCutsceneKey.NAME = "Unit Callback"
CoreUnitCallbackCutsceneKey:register_serialized_attribute("unit_name", "")
CoreUnitCallbackCutsceneKey:register_serialized_attribute("extension", "")
CoreUnitCallbackCutsceneKey:register_serialized_attribute("method", "")
CoreUnitCallbackCutsceneKey:register_serialized_attribute("enabled", true, toboolean)
CoreUnitCallbackCutsceneKey:register_serialized_attribute("arguments")
CoreUnitCallbackCutsceneKey:attribute_affects("unit_name", "extension")
CoreUnitCallbackCutsceneKey:attribute_affects("extension", "method")
CoreUnitCallbackCutsceneKey:attribute_affects("method", "arguments")
CoreUnitCallbackCutsceneKey.control_for_unit_name = CoreCutsceneKeyBase.standard_combo_box_control
CoreUnitCallbackCutsceneKey.control_for_extension = CoreCutsceneKeyBase.standard_combo_box_control
CoreUnitCallbackCutsceneKey.control_for_method = CoreCutsceneKeyBase.standard_combo_box_control
CoreUnitCallbackCutsceneKey.__tostring = function(l_1_0)
  return "Call " .. l_1_0:unit_name() .. ":" .. l_1_0:extension() .. "():" .. l_1_0:method() .. "(" .. l_1_0:arguments_string() .. ")"
end

CoreUnitCallbackCutsceneKey.arguments_string = function(l_2_0)
  if not l_2_0._method_params or not l_2_0._method_params[l_2_0:method()] then
    return string.join(", ", table.collect({}, function(l_1_0)
    return l_1_0:inspect()
   end))
     -- Warning: missing end command somewhere! Added here
  end
end

CoreUnitCallbackCutsceneKey.load = function(l_3_0, l_3_1, l_3_2)
  l_3_0.super.load(l_3_0, l_3_1, l_3_2)
  l_3_0._method_params = {}
  local params = {}
  for param_node in l_3_1:children() do
    local param = CoreUnitCallbackCutsceneKeyParam:new()
    param:load(param_node)
    table.insert(params, param)
  end
  if l_3_0:is_valid_method(l_3_0:method()) then
    l_3_0._method_params[l_3_0:method()] = params
  end
end

CoreUnitCallbackCutsceneKey._save_under = function(l_4_0, l_4_1)
  local key_node = l_4_0.super._save_under(l_4_0, l_4_1)
  if not l_4_0._method_params or not l_4_0._method_params[l_4_0:method()] then
    for _,param in ipairs({}) do
    end
    if not param:is_nil() then
      param:_save_under(key_node)
    end
  end
  return key_node
end

CoreUnitCallbackCutsceneKey.play = function(l_5_0, l_5_1, l_5_2, l_5_3)
  if l_5_0:enabled() then
    if not l_5_2 or not "undo_" .. l_5_0:method() then
      local method_name = l_5_0:method()
    end
    l_5_0:_invoke_if_exists(method_name, l_5_1)
  end
end

CoreUnitCallbackCutsceneKey.skip = function(l_6_0, l_6_1)
  if l_6_0:enabled() then
    l_6_0:_invoke_if_exists("skip_" .. l_6_0:method(), l_6_1)
  end
end

CoreUnitCallbackCutsceneKey.is_valid_unit_name = function(l_7_0, l_7_1)
  if l_7_0.super.is_valid_unit_name(l_7_0, l_7_1) then
    return not table.empty(l_7_0:_unit_extension_info(l_7_1))
  end
end

CoreUnitCallbackCutsceneKey.is_valid_extension = function(l_8_0, l_8_1)
  local methods = l_8_0:_unit_extension_info(l_8_0:unit_name())[l_8_1]
  if methods then
    return not table.empty(methods)
  end
end

CoreUnitCallbackCutsceneKey.is_valid_method = function(l_9_0, l_9_1)
  return (l_9_1 ~= nil and not string.begins(l_9_1, "undo_") and not string.begins(l_9_1, "skip_"))
end

CoreUnitCallbackCutsceneKey.refresh_control_for_extension = function(l_10_0, l_10_1)
  l_10_1:freeze()
  l_10_1:clear()
  local unit_extensions = table.find_all_values(table.map_keys(l_10_0:_unit_extension_info(l_10_0:unit_name())), function(l_1_0)
    return self:is_valid_extension(l_1_0)
   end)
  if not table.empty(unit_extensions) then
    l_10_1:set_enabled(true)
    local value = l_10_0:extension()
    for _,extension in ipairs(unit_extensions) do
      l_10_1:append(extension)
      if extension == value then
        l_10_1:set_value(value)
      end
    end
  else
    l_10_1:set_enabled(false)
  end
  l_10_1:thaw()
end

CoreUnitCallbackCutsceneKey.refresh_control_for_method = function(l_11_0, l_11_1)
  l_11_1:freeze()
  l_11_1:clear()
  local methods = l_11_0:_unit_extension_info(l_11_0:unit_name())[l_11_0:extension()]
  if methods then
    l_11_1:set_enabled(true)
    local value = l_11_0:method()
    for _,method in ipairs(table.map_keys(methods)) do
      l_11_1:append(method)
      if method == value then
        l_11_1:set_value(value)
      end
    end
  else
    l_11_1:set_enabled(false)
  end
  l_11_1:thaw()
end

CoreUnitCallbackCutsceneKey.refresh_control_for_arguments = function(l_12_0, l_12_1)
  l_12_1:freeze()
  l_12_1:destroy_children()
  local panel_sizer = EWS:BoxSizer("VERTICAL")
  local methods = l_12_0:_unit_extension_info(l_12_0:unit_name())[l_12_0:extension()]
  if not methods or not methods[l_12_0:method()] then
    local method_arguments = {}
  end
  if #method_arguments > 0 then
    local headline = EWS:StaticText(l_12_1, "Method Arguments")
    headline:set_font_size(10)
    panel_sizer:add(EWS:StaticLine(l_12_1), 0, 10, "TOP,EXPAND")
    panel_sizer:add(headline, 0, 5, "ALL,EXPAND")
    panel_sizer:add(EWS:StaticLine(l_12_1), 0, 0, "EXPAND")
    for _,argument_name in ipairs(method_arguments) do
      local param = l_12_0:_param_with_name(argument_name)
      do
        local value_field = EWS:TextCtrl(l_12_1, "")
        value_field:set_min_size(value_field:get_min_size():with_x(0))
        value_field:connect("EVT_COMMAND_TEXT_UPDATED", function()
          param.string_value = value_field:get_value()
            end)
        value_field:set_value(param.string_value)
        value_field:set_enabled(param.value_type ~= "nil")
        local type_options = {"nil", "string", "number", "bool", "unit"}
        local type_selector = EWS:ComboBox(l_12_1, "", "", "CB_DROPDOWN,CB_READONLY")
        type_selector:connect("EVT_COMMAND_COMBOBOX_SELECTED", function()
          param.value_type = type_selector:get_value()
          value_field:set_enabled(param.value_type ~= "nil")
            end)
        for _,option in ipairs(type_options) do
          type_selector:append(option)
          if param.value_type == option then
            type_selector:set_value(option)
          end
        end
        local type_and_value_sizer = EWS:BoxSizer("HORIZONTAL")
        type_and_value_sizer:add(type_selector, 0, 5, "RIGHT,EXPAND")
        type_and_value_sizer:add(value_field, 1, 0, "EXPAND")
        panel_sizer:add(EWS:StaticText(l_12_1, string.pretty(param.name, true) .. ":"), 0, 5, "TOP,LEFT,RIGHT")
        panel_sizer:add(type_and_value_sizer, 0, 5, "ALL,EXPAND")
      end
    end
  end
  l_12_1:set_sizer(panel_sizer)
  l_12_1:thaw()
end

CoreUnitCallbackCutsceneKey.control_for_arguments = function(l_13_0, l_13_1, l_13_2)
  local panel = EWS:Panel(l_13_1)
  return panel
end

CoreUnitCallbackCutsceneKey._invoke_if_exists = function(l_14_0, l_14_1, l_14_2)
  local extension = l_14_0:_unit_extension(l_14_0:unit_name(), l_14_0:extension(), true)
  if not extension then
    Application:error("Unit \"" .. l_14_0:unit_name() .. "\" does not have the extension \"" .. l_14_0:extension() .. "\".")
    return 
  end
  local func = extension[l_14_1]
  if not func then
    Application:error(string.pretty(l_14_0:extension(), true) .. " extension on unit \"" .. l_14_0:unit_name() .. "\" does not support the call \"" .. l_14_1 .. "\".")
    return 
  end
  if not l_14_0._method_params or not l_14_0._method_params[l_14_0:method()] then
    local params = {}
  end
  do
    local param_values = {}
    for index,param in ipairs(params) do
      local value = param:value(l_14_0, l_14_2)
      do
        if value == nil and not param:is_nil() then
          local parameter_names = string.join(", ", table.collect(params, function(l_1_0)
      return l_1_0.name
      end))
          Application:error(string.format("Bad argument %s in call to %s:%s():%s(%s)", param:__tostring(), l_14_0:unit_name(), l_14_0:extension(), l_14_1, parameter_names))
          return 
        end
        for (for control),index in (for generator) do
        end
        param_values[index] = value
      end
      func(extension, table.unpack_sparse(param_values))
    end
     -- Warning: missing end command somewhere! Added here
  end
end

CoreUnitCallbackCutsceneKey._param_with_name = function(l_15_0, l_15_1)
  assert(l_15_0:is_valid_method(l_15_0:method()), "Method \"" .. l_15_0:method() .. "\" is invalid.")
  if l_15_0._method_params then
    local params = l_15_0._method_params[l_15_0:method()]
  end
  if params == nil then
    params = {}
    if not l_15_0._method_params then
      l_15_0._method_params = {}
    end
    l_15_0._method_params[l_15_0:method()] = params
  end
  local param = table.find_value(params, function(l_1_0)
    return l_1_0.name == param_name
   end)
  if param == nil then
    param = CoreUnitCallbackCutsceneKeyParam.new()
    param.name = l_15_1
    table.insert(params, param)
  end
  return param
end

if not CoreUnitCallbackCutsceneKeyParam then
  CoreUnitCallbackCutsceneKeyParam = class()
end
CoreUnitCallbackCutsceneKeyParam.__tostring = function(l_16_0)
  return tostring(l_16_0.name) .. "=" .. tostring(l_16_0:inspect())
end

CoreUnitCallbackCutsceneKeyParam.init = function(l_17_0)
  l_17_0.value_type = "nil"
  l_17_0.name = "nil"
  l_17_0.string_value = ""
end

CoreUnitCallbackCutsceneKeyParam.load = function(l_18_0, l_18_1)
  l_18_0.value_type = l_18_1:name()
  l_18_0.name = l_18_1:parameter("name")
  l_18_0.string_value = l_18_1:parameter("value")
end

CoreUnitCallbackCutsceneKeyParam.value = function(l_19_0, l_19_1)
  if not l_19_0:is_nil() then
    if l_19_0.value_type == "string" then
      return l_19_0.string_value
    elseif l_19_0.value_type == "number" then
      return tonumber(l_19_0.string_value)
    elseif l_19_0.value_type == "boolean" then
      return toboolean(l_19_0.string_value)
    elseif l_19_0.value_type == "unit" then
      if l_19_1 then
        return l_19_1:_unit(l_19_0.string_value, true)
      end
    end
  end
  return nil
end

CoreUnitCallbackCutsceneKeyParam.is_nil = function(l_20_0)
  return l_20_0.value_type == "nil"
end

CoreUnitCallbackCutsceneKeyParam.inspect = function(l_21_0)
  return l_21_0.string_value
end

CoreUnitCallbackCutsceneKeyParam._save_under = function(l_22_0, l_22_1)
  local param_node = l_22_1:make_child(l_22_0.value_type)
  param_node:set_parameter("name", tostring(l_22_0.name))
  param_node:set_parameter("value", l_22_0.string_value)
  return param_node
end


