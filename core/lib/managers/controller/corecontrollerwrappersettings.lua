-- Decompiled using luadec 2.0.1 by sztupy (http://winmo.sztupy.hu)
-- Command line was: F:\SteamLibrary\SteamApps\common\PAYDAY 2\lua\core\lib\managers\controller\corecontrollerwrappersettings.luac 

core:module("CoreControllerWrapperSettings")
if not ControllerWrapperSettings then
  ControllerWrapperSettings = class()
end
ControllerWrapperSettings.init = function(l_1_0, l_1_1, l_1_2, l_1_3, l_1_4)
  l_1_0._wrapper_type = l_1_1
  l_1_0._connection_map = {}
  l_1_0._editable_connection_map = {}
  l_1_0._unselectable_input_map = {}
  if l_1_2 then
    for _,setting_node in ipairs(l_1_2) do
      local element_name = setting_node._meta
      if element_name == "connections" then
        for _,connection_node in ipairs(setting_node) do
          local element_name = connection_node._meta
          local name = connection_node.name
          if not name then
            Application:error(l_1_0:get_origin(l_1_4) .. " controller \"" .. tostring(element_name) .. "\" input had no name attribute.")
            for (for control),_ in (for generator) do
            end
            if element_name == "button" then
              if l_1_0._connection_map[name] then
                Application:error(l_1_0:get_origin(l_1_4) .. " Duplicate controller button connection (name: \"" .. tostring(name) .. "\"). Overwriting existing one.")
              end
              l_1_0:set_connection(name, ControllerWrapperButton:new(connection_node))
              for (for control),_ in (for generator) do
              end
              if element_name == "axis" then
                if l_1_0._connection_map[name] then
                  Application:error(l_1_0:get_origin(l_1_4) .. " Duplicate controller axis connection (name: \"" .. tostring(name) .. "\"). Overwriting existing one.")
                end
                l_1_0:set_connection(name, ControllerWrapperAxis:new(connection_node))
                for (for control),_ in (for generator) do
                end
                Application:error(l_1_0:get_origin(l_1_4) .. " Invalid element \"" .. tostring(element_name) .. "\" inside \"connections\" element.")
              end
              for (for control),_ in (for generator) do
              end
              if element_name == "editable" then
                for _,editable_node in ipairs(setting_node) do
                  local element_name = editable_node._meta
                  do
                    if element_name == ControllerWrapperEditable.TYPE then
                      local name = editable_node.name
                      if not name then
                        Application:error(l_1_0:get_origin(l_1_4) .. " Editable input element had no name attribute.")
                        for (for control),_ in (for generator) do
                        end
                        if l_1_0._editable_connection_map[name] then
                          Application:error(l_1_0:get_origin(l_1_4) .. " Duplicate controller editable connection (name: \"" .. tostring(name) .. "\"). Overwriting existing one.")
                        end
                        l_1_0:set_editable_connection(name, ControllerWrapperEditable:new(editable_node))
                      end
                      for (for control),_ in (for generator) do
                      end
                      Application:error(l_1_0:get_origin(l_1_4) .. " Invalid element \"" .. tostring(element_name) .. "\" inside \"editable\" element.")
                    end
                    for (for control),_ in (for generator) do
                    end
                    if element_name == "unselectable" then
                      for _,unselectable_node in ipairs(setting_node) do
                        local element_name = unselectable_node._meta
                        do
                          if element_name == ControllerWrapperUnselectable.TYPE then
                            local input_name = unselectable_node.name
                            if not input_name then
                              Application:error(l_1_0:get_origin(l_1_4) .. " Unselectable input element had no name attribute.")
                              for (for control),_ in (for generator) do
                              end
                              if l_1_0._unselectable_input_map[input_name] then
                                Application:error(l_1_0:get_origin(l_1_4) .. " Duplicate controller unselectable connection (name: \"" .. tostring(input_name) .. "\"). Overwriting existing one.")
                              end
                              l_1_0:set_unselectable_input(input_name, ControllerWrapperUnselectable:new(unselectable_node))
                            end
                            for (for control),_ in (for generator) do
                            end
                            Application:error(l_1_0:get_origin(l_1_4) .. " Invalid element \"" .. tostring(element_name) .. "\" inside \"unselectable\" element.")
                          end
                          for (for control),_ in (for generator) do
                          end
                          Application:error(l_1_0:get_origin(l_1_4) .. " Invalid element \"" .. tostring(name) .. "\" inside \"" .. tostring(l_1_0._wrapper_type) .. "\" element.")
                        end
                      end
                      if l_1_3 then
                        l_1_0:merge(l_1_3, false)
                      end
                      l_1_0:validate()
                       -- Warning: missing end command somewhere! Added here
                    end
                     -- Warning: missing end command somewhere! Added here
                  end
                   -- Warning: missing end command somewhere! Added here
                end
                 -- Warning: missing end command somewhere! Added here
              end
               -- Warning: missing end command somewhere! Added here
            end
             -- Warning: missing end command somewhere! Added here
          end
           -- Warning: missing end command somewhere! Added here
        end
         -- Warning: missing end command somewhere! Added here
      end
       -- Warning: missing end command somewhere! Added here
    end
     -- Warning: missing end command somewhere! Added here
  end
end

ControllerWrapperSettings.merge = function(l_2_0, l_2_1, l_2_2)
  for name,connection in pairs(l_2_1:get_connection_map()) do
    if l_2_2 or not l_2_0._connection_map[name] then
      l_2_0._connection_map[name] = connection
    end
  end
  for name,editable_connection in pairs(l_2_1:get_editable_connection_map()) do
    if l_2_2 or not l_2_0._editable_connection_map[name] then
      l_2_0._editable_connection_map[name] = editable_connection
    end
  end
  for name,unselectable_input in pairs(l_2_1:get_unselectable_input_map()) do
    if l_2_2 or not l_2_0._unselectable_input_map[name] then
      l_2_0._unselectable_input_map[name] = unselectable_input
    end
  end
end

ControllerWrapperSettings.validate = function(l_3_0)
  for connection_name,editable_connection in pairs(l_3_0._editable_connection_map) do
    local connection = l_3_0._connection_map[connection_name]
    if not connection then
      l_3_0._editable_connection_map[connection_name] = nil
      Application:error(tostring(editable_connection) .. " Connection \"" .. tostring(connection_name) .. "\" that was supposed to be editable did not exist. It is no longer editable.")
      for (for control),connection_name in (for generator) do
      end
      local input_name_list = connection:get_input_name_list()
      for _,input_name in ipairs(input_name_list) do
        local unselectable_input = l_3_0._unselectable_input_map[input_name]
        if unselectable_input then
          local invalid = nil
          if #input_name_list > 1 and not connection:get_any_input() then
            invalid = unselectable_input:get_multi()
          else
            invalid = unselectable_input:get_single()
          end
          if invalid then
            l_3_0._editable_connection_map[connection_name] = nil
            Application:error(tostring(unselectable_input) .. " Connection \"" .. tostring(connection_name) .. "\" was editable but its input \"" .. tostring(input_name) .. "\" is unselectable. It is no longer editable.")
          end
        end
      end
    end
     -- Warning: missing end command somewhere! Added here
  end
end

ControllerWrapperSettings.populate_data = function(l_4_0, l_4_1)
  local sub_data = {}
  local connection_list = nil
  for _,connection in pairs(l_4_0._connection_map) do
    if not connection_list then
      connection_list = {_meta = "connections"}
      table.insert(sub_data, connection_list)
    end
    connection:populate_data(connection_list)
  end
  local editable_list = nil
  for _,editable in pairs(l_4_0._editable_connection_map) do
    if not editable_list then
      editable_list = {_meta = "editable"}
      table.insert(sub_data, editable_list)
    end
    editable:populate_data(editable_list)
  end
  local unselectable_list = nil
  for _,unselectable in pairs(l_4_0._unselectable_input_map) do
    if not unselectable_list then
      unselectable_list = {_meta = "unselectable"}
      table.insert(sub_data, unselectable_list)
    end
    unselectable:populate_data(unselectable_list)
  end
  l_4_1[l_4_0._wrapper_type] = sub_data
end

ControllerWrapperSettings.wrapper_type = function(l_5_0)
  return l_5_0._wrapper_type
end

ControllerWrapperSettings.get_connection_map = function(l_6_0)
  return l_6_0._connection_map
end

ControllerWrapperSettings.get_connection = function(l_7_0, l_7_1)
  return l_7_0._connection_map[l_7_1]
end

ControllerWrapperSettings.set_connection = function(l_8_0, l_8_1, l_8_2)
  l_8_0._connection_map[l_8_1] = l_8_2
end

ControllerWrapperSettings.get_editable_connection_map = function(l_9_0)
  return l_9_0._editable_connection_map
end

ControllerWrapperSettings.get_editable_connection = function(l_10_0, l_10_1)
  return l_10_0._editable_connection_map[l_10_1]
end

ControllerWrapperSettings.set_editable_connection = function(l_11_0, l_11_1, l_11_2)
  l_11_0._editable_connection_map[l_11_1] = l_11_2
end

ControllerWrapperSettings.get_unselectable_input_map = function(l_12_0)
  return l_12_0._unselectable_input_map
end

ControllerWrapperSettings.get_unselectable_input = function(l_13_0, l_13_1)
  return l_13_0._unselectable_input_map[l_13_1]
end

ControllerWrapperSettings.set_unselectable_input = function(l_14_0, l_14_1, l_14_2)
  l_14_0._unselectable_input_map[l_14_1] = l_14_2
end

ControllerWrapperSettings.get_origin = function(l_15_0, l_15_1)
  if l_15_1 then
    return string.format("[Controller][File: %s]", tostring(l_15_1))
  else
    return "[Controller]"
  end
end

if not ControllerWrapperConnection then
  ControllerWrapperConnection = class()
end
ControllerWrapperConnection.TYPE = "generic"
ControllerWrapperConnection.DEFAULT_MIN_SRC_RANGE = 0
ControllerWrapperConnection.DEFAULT_MAX_SRC_RANGE = 1
ControllerWrapperConnection.DEFAULT_MIN_DEST_RANGE = 0
ControllerWrapperConnection.DEFAULT_MAX_DEST_RANGE = 1
ControllerWrapperConnection.DEFAULT_CONNECT_SRC_TYPE = "button"
ControllerWrapperConnection.DEFAULT_CONNECT_DEST_TYPE = "button"
ControllerWrapperConnection.init = function(l_16_0, l_16_1)
  if l_16_1 then
    l_16_0._name = l_16_1.name
    local input_name = nil
    local attribute = "input"
    local count = 1
    repeat
      input_name = l_16_1[attribute]
      if input_name then
        if not l_16_0._input_name_list then
          l_16_0._input_name_list = {}
        end
        table.insert(l_16_0._input_name_list, input_name)
        count = count + 1
        attribute = "input" .. count
      end
    until not input_name
    l_16_0._controller_id = l_16_1.controller
    if l_16_1.debug == true then
      l_16_0._debug = true
    end
    if l_16_1.enabled == false then
      l_16_0._disabled = true
    end
    if l_16_1.any_input == false then
      l_16_0._single_input = true
    end
    l_16_0._delay = tonumber(l_16_1.delay)
    l_16_0._min_src_range = tonumber(l_16_1.min_src_range)
    l_16_0._max_src_range = tonumber(l_16_1.max_src_range)
    l_16_0._min_dest_range = tonumber(l_16_1.min_dest_range)
    l_16_0._max_dest_range = tonumber(l_16_1.max_dest_range)
    for _,child in ipairs(l_16_1) do
      local child_name = child._meta
      if child_name == ControllerWrapperDelayConnection.TYPE then
        local delay_connection = ControllerWrapperDelayConnection:new(child)
        if not l_16_0._delay_connection_list then
          l_16_0._delay_connection_list = {}
        end
        table.insert(l_16_0._delay_connection_list, delay_connection)
      end
    end
  end
end

ControllerWrapperConnection.set_name = function(l_17_0, l_17_1)
  l_17_0._name = l_17_1
end

ControllerWrapperConnection.get_name = function(l_18_0)
  return l_18_0._name
end

ControllerWrapperConnection.set_input_name_list = function(l_19_0, l_19_1)
  if l_19_0._input_name_list and next(l_19_0._input_name_list) then
    l_19_0._input_name_list = l_19_1
  else
    l_19_0._input_name_list = nil
  end
end

ControllerWrapperConnection.get_input_name_list = function(l_20_0)
  if not l_20_0._input_name_list then
    return {}
  end
end

ControllerWrapperConnection.get_controller_id = function(l_21_0)
  return l_21_0._controller_id
end

ControllerWrapperConnection.set_controller_id = function(l_22_0, l_22_1)
  l_22_0._controller_id = l_22_1
end

ControllerWrapperConnection.set_debug = function(l_23_0, l_23_1)
  if l_23_1 then
    l_23_0._debug = true
  else
    l_23_0._debug = nil
  end
end

ControllerWrapperConnection.get_debug = function(l_24_0)
  return l_24_0._debug
end

ControllerWrapperConnection.set_enabled = function(l_25_0, l_25_1)
  if not l_25_1 then
    l_25_0._disabled = true
  else
    l_25_0._disabled = nil
  end
end

ControllerWrapperConnection.get_enabled = function(l_26_0)
  return not l_26_0._disabled
end

ControllerWrapperConnection.set_any_input = function(l_27_0, l_27_1)
  if not l_27_1 then
    l_27_0._single_input = true
  else
    l_27_0._single_input = nil
  end
end

ControllerWrapperConnection.get_any_input = function(l_28_0)
  return not l_28_0._single_input
end

ControllerWrapperConnection.set_delay = function(l_29_0, l_29_1)
  if l_29_0._delay ~= 0 then
    l_29_0._delay = l_29_1
  else
    l_29_0._delay = nil
  end
end

ControllerWrapperConnection.get_delay = function(l_30_0)
  return l_30_0._delay or 0
end

ControllerWrapperConnection.set_delay_connection_list = function(l_31_0, l_31_1)
  if l_31_0._delay_connection_list and next(l_31_0._delay_connection_list) then
    l_31_0._delay_connection_list = l_31_1
  else
    l_31_0._delay_connection_list = nil
  end
end

ControllerWrapperConnection.get_delay_connection_list = function(l_32_0)
  if not l_32_0._delay_connection_list then
    return {}
  end
end

ControllerWrapperConnection.set_range = function(l_33_0, l_33_1, l_33_2, l_33_3, l_33_4)
  if l_33_1 ~= l_33_0.DEFAULT_MIN_SRC_RANGE then
    l_33_0._min_src_range = l_33_1
  else
    l_33_0._min_src_range = nil
  end
  if l_33_2 ~= l_33_0.DEFAULT_MAX_SRC_RANGE then
    l_33_0._max_src_range = l_33_2
  else
    l_33_0._max_src_range = nil
  end
  if l_33_3 ~= l_33_0.DEFAULT_MIN_DEST_RANGE then
    l_33_0._min_dest_range = l_33_3
  else
    l_33_0._min_dest_range = nil
  end
  if l_33_4 ~= l_33_0.DEFAULT_MAX_DEST_RANGE then
    l_33_0._max_dest_range = l_33_4
  else
    l_33_0._max_dest_range = nil
  end
end

ControllerWrapperConnection.get_range = function(l_34_0)
  if ((not l_34_0._min_src_range and l_34_0._max_src_range) or not l_34_0._min_dest_range and not l_34_0._max_dest_range) then
    return l_34_0.DEFAULT_MIN_SRC_RANGE, l_34_0.DEFAULT_MAX_SRC_RANGE, l_34_0.DEFAULT_MIN_DEST_RANGE, l_34_0.DEFAULT_MAX_DEST_RANGE
  end
end

ControllerWrapperConnection.set_connect_src_type = function(l_35_0, l_35_1)
  if l_35_0._connect_src_type ~= l_35_0.DEFAULT_CONNECT_SRC_TYPE then
    l_35_0._connect_src_type = l_35_1
  else
    l_35_0._connect_src_type = nil
  end
end

ControllerWrapperConnection.get_connect_src_type = function(l_36_0)
  if not l_36_0._connect_src_type then
    return l_36_0.DEFAULT_CONNECT_SRC_TYPE
  end
end

ControllerWrapperConnection.set_connect_dest_type = function(l_37_0, l_37_1)
  if l_37_0._connect_dest_type ~= l_37_0.DEFAULT_CONNECT_DEST_TYPE then
    l_37_0._connect_dest_type = l_37_1
  else
    l_37_0._connect_dest_type = nil
  end
end

ControllerWrapperConnection.get_connect_dest_type = function(l_38_0)
  if not l_38_0._connect_dest_type then
    return l_38_0.DEFAULT_CONNECT_DEST_TYPE
  end
end

ControllerWrapperConnection.populate_data = function(l_39_0, l_39_1)
  local sub_data = {_meta = l_39_0.TYPE}
  l_39_0:populate_data_attributes(sub_data)
  if l_39_0._delay_connection_list then
    for _,delay_connection in ipairs(l_39_0._delay_connection_list) do
      delay_connection:populate_data(sub_data)
    end
  end
  table.insert(l_39_1, sub_data)
end

ControllerWrapperConnection.populate_data_attributes = function(l_40_0, l_40_1)
  l_40_1.name = l_40_0._name
  l_40_1.controller = l_40_0._controller_id
  l_40_1.delay = l_40_0._delay
  l_40_1.min_src_range = l_40_0._min_src_range
  l_40_1.max_src_range = l_40_0._max_src_range
  l_40_1.min_dest_range = l_40_0._min_dest_range
  l_40_1.max_dest_range = l_40_0._max_dest_range
  l_40_1.connect_src_type = l_40_0._connect_src_type
  l_40_1.connect_dest_type = l_40_0._connect_dest_type
  if l_40_0._debug then
    l_40_1.debug = true
  end
  if l_40_0._disabled then
    l_40_1.enabled = false
  end
  if l_40_0._single_input then
    l_40_1.any_input = false
  end
  if l_40_0._input_name_list then
    for index,input_name in ipairs(l_40_0._input_name_list) do
      local attribute = "input"
      if index > 1 then
        attribute = attribute .. index
      end
      l_40_1[attribute] = input_name
    end
  end
end

ControllerWrapperConnection.__tostring = function(l_41_0, l_41_1)
  return string.format("[Controller][Connection][Type: %s, Name: %s, Input: %s, Controller: %s, Debug: %s, Enabled: %s, Any input: %s, Delay: %s%s]", tostring(l_41_0.TYPE), tostring(l_41_0._name), l_41_0._input_name_list and table.concat_map(l_41_0._input_name_list, true, "N/A") or "", tostring(l_41_0._controller_id), tostring(l_41_0._debug), tostring(not l_41_0._disabled), tostring(not l_41_0._single_input), tostring(l_41_0._delay), tostring(l_41_1 or ""))
end

if not ControllerWrapperButton then
  ControllerWrapperButton = class(ControllerWrapperConnection)
end
ControllerWrapperButton.TYPE = "button"
ControllerWrapperButton.init = function(l_42_0, l_42_1)
  ControllerWrapperButton.super.init(l_42_0, l_42_1)
end

ControllerWrapperButton.__tostring = function(l_43_0, l_43_1)
  return ControllerWrapperConnection.__tostring(l_43_0, l_43_1)
end

if not ControllerWrapperAxis then
  ControllerWrapperAxis = class(ControllerWrapperConnection)
end
ControllerWrapperAxis.TYPE = "axis"
ControllerWrapperAxis.IS_AXIS = true
ControllerWrapperAxis.DEFAULT_MIN_SRC_RANGE = -1
ControllerWrapperAxis.DEFAULT_MAX_SRC_RANGE = 1
ControllerWrapperAxis.DEFAULT_MIN_DEST_RANGE = -1
ControllerWrapperAxis.DEFAULT_MAX_DEST_RANGE = 1
ControllerWrapperAxis.DEFAULT_CONNECT_SRC_TYPE = "axis"
ControllerWrapperAxis.DEFAULT_CONNECT_DEST_TYPE = "axis"
ControllerWrapperAxis.ONE_VECTOR = Vector3(1, 1, 1)
ControllerWrapperAxis.init = function(l_44_0, l_44_1)
  ControllerWrapperAxis.super.init(l_44_0, l_44_1)
  l_44_0._multiplier = l_44_0.ONE_VECTOR
  l_44_0._inversion = l_44_0.ONE_VECTOR
  l_44_0._inversion_unmodified = l_44_0.ONE_VECTOR
  l_44_0._INVERSION_MODIFIER = l_44_0.ONE_VECTOR
  if l_44_1 then
    local multiplier = l_44_1.multiplier
    if multiplier and multiplier.type_name == Vector3.type_name then
      l_44_0:set_multiplier(multiplier)
    end
    l_44_0:set_lerp(tonumber(l_44_1.lerp))
    local init_lerp_axis = l_44_1.init_lerp_axis
    if init_lerp_axis and init_lerp_axis.type_name == Vector3.type_name then
      l_44_0:set_init_lerp_axis(init_lerp_axis)
    end
    l_44_0:set_pad_bottom(tonumber(l_44_1.pad_bottom))
    l_44_0:set_pad_top(tonumber(l_44_1.pad_top))
    l_44_0:set_soft_top(tonumber(l_44_1.soft_top))
    if l_44_1.no_limit == true then
      l_44_0._no_limit = true
    end
    local inversion_modifier = l_44_1.inversion_modifier
    if inversion_modifier and inversion_modifier.type_name == Vector3.type_name then
      l_44_0._INVERSION_MODIFIER = inversion_modifier
      l_44_0:set_inversion()
    end
    local inversion = l_44_1.inversion
    if inversion and inversion.type_name == Vector3.type_name then
      l_44_0:set_inversion(inversion)
    end
  end
  if l_44_1 then
    l_44_0._btn_connections = {}
    l_44_0:read_axis_btns(l_44_1)
  end
end

ControllerWrapperAxis.read_axis_btns = function(l_45_0, l_45_1)
  for _,child in ipairs(l_45_1) do
    local child_name = child._meta
    if (child_name == "button" or child_name == "axis") and child.name and child.input then
      l_45_0._btn_connections[child.name] = {type = child_name, name = child.input}
      if child.dir then
        l_45_0._btn_connections[child.name].dir = child.dir
      end
      if child.range1 then
        l_45_0._btn_connections[child.name].range1 = child.range1
      end
      if child.range2 then
        l_45_0._btn_connections[child.name].range2 = child.range2
      end
    end
  end
end

ControllerWrapperAxis.print_output = function(l_46_0, l_46_1, l_46_2)
  l_46_1:print(string.rep("\t", l_46_2) .. "<" .. l_46_0.TYPE .. l_46_0:get_output_attributes() .. "")
  if l_46_0:has_children() then
    l_46_1:puts(">")
    l_46_0:print_output_children(l_46_1, l_46_2 + 1)
    l_46_1:puts(string.rep("\t", l_46_2) .. "</" .. l_46_0.TYPE .. ">")
  elseif l_46_0._btn_connections then
    l_46_1:puts(">")
    l_46_0:print_output_axis_btns(l_46_1, l_46_2 + 1)
    l_46_1:puts(string.rep("\t", l_46_2) .. "</" .. l_46_0.TYPE .. ">")
  else
    l_46_1:puts("/>")
  end
end

ControllerWrapperAxis.print_output_axis_btns = function(l_47_0, l_47_1, l_47_2)
  for btn,con in pairs(l_47_0._btn_connections) do
    if con.type == "button" then
      l_47_1:puts(string.rep("\t", l_47_2) .. string.format("<%s name=\"%s\" input=\"%s\"/>", con.type, btn, con.name))
      for (for control),btn in (for generator) do
      end
      if con.type == "axis" then
        l_47_1:puts(string.rep("\t", l_47_2) .. string.format("<%s name=\"%s\" input=\"%s\" dir=\"%s\" range1=\"%s\" range2=\"%s\"/>", con.type, btn, con.name, con.dir, con.range1, con.range2))
      end
    end
     -- Warning: missing end command somewhere! Added here
  end
end

ControllerWrapperAxis.set_multiplier = function(l_48_0, l_48_1)
  if not l_48_1 then
    l_48_0._multiplier = l_48_0.ONE_VECTOR
  end
end

ControllerWrapperAxis.get_multiplier = function(l_49_0)
  return l_49_0._multiplier
end

ControllerWrapperAxis.set_lerp = function(l_50_0, l_50_1)
  if l_50_1 then
    l_50_0._lerp = math.clamp(l_50_1, 0, 1)
  end
end

ControllerWrapperAxis.get_lerp = function(l_51_0)
  return l_51_0._lerp
end

ControllerWrapperAxis.set_init_lerp_axis = function(l_52_0, l_52_1)
  l_52_0._init_lerp_axis = l_52_1
end

ControllerWrapperAxis.get_init_lerp_axis = function(l_53_0)
  return l_53_0._init_lerp_axis
end

ControllerWrapperAxis.set_pad_bottom = function(l_54_0, l_54_1)
  if l_54_1 then
    l_54_0._pad_bottom = math.clamp(l_54_1, 0, 1)
  end
end

ControllerWrapperAxis.get_pad_bottom = function(l_55_0)
  return l_55_0._pad_bottom
end

ControllerWrapperAxis.set_pad_top = function(l_56_0, l_56_1)
  if l_56_1 then
    l_56_0._pad_top = math.clamp(l_56_1, 0, 1)
  end
end

ControllerWrapperAxis.get_pad_top = function(l_57_0)
  return l_57_0._pad_top
end

ControllerWrapperAxis.set_soft_top = function(l_58_0, l_58_1)
  if l_58_1 then
    l_58_0._soft_top = math.clamp(l_58_1, 0, 1)
  end
end

ControllerWrapperAxis.get_soft_top = function(l_59_0)
  return l_59_0._soft_top
end

ControllerWrapperAxis.set_no_limit = function(l_60_0, l_60_1)
  if l_60_1 then
    l_60_0._no_limit = true
  else
    l_60_0._no_limit = nil
  end
end

ControllerWrapperAxis.get_no_limit = function(l_61_0)
  return l_61_0._no_limit
end

ControllerWrapperAxis.set_inversion = function(l_62_0, l_62_1)
  if not l_62_1 then
    l_62_0._inversion_unmodified = l_62_0.ONE_VECTOR
  end
  l_62_0._inversion = Vector3(l_62_0._inversion_unmodified.x * l_62_0._INVERSION_MODIFIER.x, l_62_0._inversion_unmodified.y * l_62_0._INVERSION_MODIFIER.y, l_62_0._inversion_unmodified.z * l_62_0._INVERSION_MODIFIER.z)
end

ControllerWrapperAxis.get_inversion_unmodified = function(l_63_0)
  return l_63_0._inversion_unmodified
end

ControllerWrapperAxis.get_inversion = function(l_64_0)
  return l_64_0._inversion
end

ControllerWrapperAxis.get_output_attributes = function(l_65_0)
  local additional_attributes = ""
  if l_65_0._multiplier and (l_65_0._multiplier.x ~= 1 or l_65_0._multiplier.y ~= 1 or l_65_0._multiplier.z ~= 1) then
    additional_attributes = additional_attributes .. string.format(" multiplier=\"%g %g %g\"", l_65_0._multiplier.x, l_65_0._multiplier.y, l_65_0._multiplier.z)
  end
  if l_65_0._lerp then
    additional_attributes = additional_attributes .. string.format(" lerp=\"%g\"", l_65_0._lerp)
    if l_65_0._init_lerp_axis and (l_65_0._init_lerp_axis.x ~= 1 or l_65_0._init_lerp_axis.y ~= 1 or l_65_0._init_lerp_axis.z ~= 1) then
      additional_attributes = additional_attributes .. string.format(" init_lerp_axis=\"%g %g %g\"", l_65_0._init_lerp_axis.x, l_65_0._init_lerp_axis.y, l_65_0._init_lerp_axis.z)
    end
  end
  if l_65_0._pad_bottom and l_65_0._pad_bottom ~= 0 then
    additional_attributes = additional_attributes .. string.format(" pad_bottom=\"%g\"", l_65_0._pad_bottom)
  end
  if l_65_0._pad_top and l_65_0._pad_top ~= 0 then
    additional_attributes = additional_attributes .. string.format(" pad_top=\"%g\"", l_65_0._pad_top)
  end
  if l_65_0._soft_top and l_65_0._soft_top ~= 0 then
    additional_attributes = additional_attributes .. string.format(" soft_top=\"%g\"", l_65_0._soft_top)
  end
  if l_65_0._no_limit then
    additional_attributes = additional_attributes .. string.format(" no_limit=\"%s\"", tostring(not not l_65_0._no_limit))
  end
  if l_65_0._inversion and (l_65_0._inversion.x ~= 1 or l_65_0._inversion.y ~= 1 or l_65_0._inversion.z ~= 1) then
    additional_attributes = additional_attributes .. string.format(" inversion=\"%g %g %g\"", l_65_0._inversion.x, l_65_0._inversion.y, l_65_0._inversion.z)
  end
  return ControllerWrapperConnection.get_output_attributes(l_65_0) .. additional_attributes
end

ControllerWrapperAxis.__tostring = function(l_66_0, l_66_1)
  return ControllerWrapperConnection.__tostring(l_66_0, tostring(l_66_1 or "") .. ", Multiplier: " .. tostring(l_66_0._multiplier) .. ", Lerp: " .. tostring(l_66_0._lerp) .. ", Initial lerp axis: " .. tostring(l_66_0._init_lerp_axis) .. ", Pad bottom: " .. tostring(l_66_0._pad_bottom) .. ", Pad top: " .. tostring(l_66_0._pad_top) .. ", Soft top: " .. tostring(l_66_0._soft_top) .. ", No limit: " .. tostring(l_66_0._no_limit) .. ", Inversion: " .. tostring(l_66_0._inversion))
end

if not ControllerWrapperDelayConnection then
  ControllerWrapperDelayConnection = class()
end
ControllerWrapperDelayConnection.TYPE = "delay"
ControllerWrapperDelayConnection.init = function(l_67_0, l_67_1)
  if l_67_1 then
    l_67_0._name = l_67_1.name
  end
end

ControllerWrapperDelayConnection.set_name = function(l_68_0, l_68_1)
  l_68_0._name = l_68_1
end

ControllerWrapperDelayConnection.get_name = function(l_69_0)
  return l_69_0._name
end

ControllerWrapperDelayConnection.populate_data = function(l_70_0, l_70_1)
  local list = l_70_1.connections
  local sub_data = {_meta = l_70_0.TYPE}
  if not list then
    list = {}
    l_70_1.connections = list
  end
  sub_data.name = l_70_0._name
  table.insert(list, sub_data)
end

ControllerWrapperDelayConnection.__tostring = function(l_71_0, l_71_1)
  return string.format("[Controller][DelayConnection][Name: %s%s]", tostring(l_71_0._name), tostring(l_71_1))
end

if not ControllerWrapperEditable then
  ControllerWrapperEditable = class()
end
ControllerWrapperEditable.TYPE = "connection"
ControllerWrapperEditable.init = function(l_72_0, l_72_1)
  l_72_0._connection_name = l_72_1.name
  if not l_72_1.caption then
    l_72_0._caption = l_72_0._connection_name
  end
  l_72_0._locale_id = l_72_1.locale_id
end

ControllerWrapperEditable.get_connection_name = function(l_73_0)
  return l_73_0._connection_name
end

ControllerWrapperEditable.set_connection_name = function(l_74_0, l_74_1)
  l_74_0._connection_name = l_74_1
end

ControllerWrapperEditable.get_caption = function(l_75_0)
  return l_75_0._caption
end

ControllerWrapperEditable.set_caption = function(l_76_0, l_76_1)
  if not l_76_1 then
    l_76_0._caption = l_76_0._connection_name
  end
end

ControllerWrapperEditable.get_locale_id = function(l_77_0)
  return l_77_0._locale_id
end

ControllerWrapperEditable.set_locale_id = function(l_78_0, l_78_1)
  l_78_0._locale_id = l_78_1
end

ControllerWrapperEditable.populate_data = function(l_79_0, l_79_1)
  local sub_data = {_meta = l_79_0.TYPE}
  sub_data.name = l_79_0._connection_name
  sub_data.caption = l_79_0._caption
  sub_data.locale_id = l_79_0._locale_id
  table.insert(l_79_1, sub_data)
end

ControllerWrapperEditable.__tostring = function(l_80_0, l_80_1)
  return string.format("[Editable connection name: %s, Caption: %s, Locale id: %s]", tostring(l_80_0._connection_name), tostring(l_80_0._caption), tostring(l_80_0._locale_id))
end

if not ControllerWrapperUnselectable then
  ControllerWrapperUnselectable = class()
end
ControllerWrapperUnselectable.TYPE = "input"
ControllerWrapperUnselectable.init = function(l_81_0, l_81_1)
  l_81_0._input_name = l_81_1.name
  if l_81_1.single ~= false then
    l_81_0._single = true
  end
  if l_81_1.multi ~= false then
    l_81_0._multi = true
  end
end

ControllerWrapperUnselectable.get_input_name = function(l_82_0)
  return l_82_0._input_name
end

ControllerWrapperUnselectable.set_input_name = function(l_83_0, l_83_1)
  l_83_0._input_name = l_83_1
end

ControllerWrapperUnselectable.get_single = function(l_84_0)
  return l_84_0._single
end

ControllerWrapperUnselectable.set_single = function(l_85_0, l_85_1)
  if l_85_1 then
    l_85_0._single = true
  else
    l_85_0._single = nil
  end
end

ControllerWrapperUnselectable.get_multi = function(l_86_0)
  return l_86_0._multi
end

ControllerWrapperUnselectable.set_multi = function(l_87_0, l_87_1)
  if l_87_1 then
    l_87_0._multi = true
  else
    l_87_0._multi = nil
  end
end

ControllerWrapperUnselectable.populate_data = function(l_88_0, l_88_1)
  local sub_data = {_meta = l_88_0.TYPE}
  sub_data.name = l_88_0._input_name
  if not l_88_0._single then
    sub_data.single = not not l_88_0._single
  end
  if not l_88_0._multi then
    sub_data.multi = not not l_88_0._sing_multile
  end
  table.insert(l_88_1, sub_data)
end

ControllerWrapperUnselectable.__tostring = function(l_89_0, l_89_1)
  return string.format("[Unselectable input name: \"%s\"]", tostring(l_89_0._input_name))
end


