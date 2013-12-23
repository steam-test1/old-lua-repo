-- Decompiled using luadec 2.0.1 by sztupy (http://winmo.sztupy.hu)
-- Command line was: F:\SteamLibrary\SteamApps\common\PAYDAY 2\lua\core\lib\managers\corelistenermanager.luac 

core:module("CoreListenerManager")
core:import("CoreLinkedStackMap")
if not ListenerManager then
  ListenerManager = class()
end
ListenerManager.init = function(l_1_0)
  l_1_0._set_map = {}
  l_1_0._category_map = {}
  l_1_0._listener_map = {}
  l_1_0._active_category_map = {}
  l_1_0._active_set_count_map = {}
  l_1_0._active_set_stack_map = {}
  l_1_0._activation_map = {}
  l_1_0._stack_activation_map = {}
  l_1_0._set_activation_map = {}
  l_1_0._last_activation_id = 0
  l_1_0._enabled = true
  l_1_0:add_stack("main")
end

ListenerManager.active_listener_obj = function(l_2_0)
  for id,listener_data in pairs(l_2_0._listener_map) do
    if listener_data.active then
      return listener_data.distance_obj
    end
  end
end

ListenerManager.get_closest_listener_position = function(l_3_0, l_3_1)
  Application:error("ListenerManager:get_closest_listener_position dont function in wwise yet")
  return 
  local closest_position, closest_distance = nil, nil
  l_3_0:callback_on_all_active_listeners(function(l_1_0)
    local distance_obj = Sound:listener(l_1_0)
    if alive(distance_obj) then
      local obj_position = distance_obj:position()
      local obj_distance = obj_position - position:length()
      if not closest_distance or obj_distance < closest_distance then
        upvalue_1024 = obj_position
        upvalue_512 = obj_distance
      end
    end
   end)
  return closest_position, closest_distance
end

ListenerManager.set_enabled = function(l_4_0, l_4_1)
  l_4_1 = not not l_4_1
  if l_4_0._enabled ~= l_4_1 then
    l_4_0:callback_on_all_active_listeners(function(l_1_0)
    self._listener_map[l_1_0].listener:activate(enabled)
   end)
    l_4_0._enabled = l_4_1
  end
end

ListenerManager.callback_on_all_active_listeners = function(l_5_0, l_5_1)
  local done_set_map = {}
  local done_category_map = {}
  for stack_id,stack in pairs(l_5_0._active_set_stack_map) do
    local set_id = stack:top()
    if set_id and not done_set_map[set_id] then
      for category_id,category_map in pairs(l_5_0._set_map[set_id]) do
        if not done_category_map[category_id] then
          for listener_id,listener in pairs(category_map) do
            l_5_1(listener_id)
          end
          done_category_map[category_id] = true
        end
      end
      done_set_map[set_id] = true
    end
  end
end

ListenerManager.has_stack = function(l_6_0, l_6_1)
  return l_6_0._active_set_stack_map[l_6_1] ~= nil
end

ListenerManager.has_set = function(l_7_0, l_7_1)
  return l_7_0._set_map[l_7_1] ~= nil
end

ListenerManager.has_category = function(l_8_0, l_8_1)
  return l_8_0._category_map[l_8_1] ~= nil
end

ListenerManager.add_stack = function(l_9_0, l_9_1)
  if not l_9_0._active_set_stack_map[l_9_1] then
    l_9_0._active_set_stack_map[l_9_1] = CoreLinkedStackMap.LinkedStackMap:new()
    l_9_0._stack_activation_map[l_9_1] = {}
  else
    Application:stack_dump_error("Stack id \"" .. tostring(l_9_1) .. "\" already exists.")
  end
end

ListenerManager.remove_stack = function(l_10_0, l_10_1)
  local active_set_stack = l_10_0._active_set_stack_map[l_10_1]
  if active_set_stack then
    l_10_0._active_set_stack_map[l_10_1] = nil
    for activation_id in pairs(l_10_0._stack_activation_map[l_10_1]) do
      l_10_0:deactivate_set(activation_id)
    end
    l_10_0._stack_activation_map[l_10_1] = nil
  else
    Application:stack_dump_error("Stack id \"" .. tostring(l_10_1) .. "\" doesn't exists.")
  end
end

ListenerManager.add_set = function(l_11_0, l_11_1, l_11_2)
  if not l_11_0._set_map[l_11_1] then
    l_11_0._set_map[l_11_1] = {}
    l_11_0._set_activation_map[l_11_1] = {}
    if l_11_2 then
      for _,category_id in ipairs(l_11_2) do
        l_11_0:add_set_category(l_11_1, category_id)
      end
    else
      Application:stack_dump_error("Unable to add an already set id \"" .. tostring(l_11_1) .. "\"")
    end
  end
end

ListenerManager.remove_set = function(l_12_0, l_12_1)
  local category_map = l_12_0._set_map[l_12_1]
  if category_map then
    for category_id in pairs(category_map) do
      l_12_0:remove_set_category(l_12_1, category_id)
    end
    for activation_id in pairs(l_12_0._set_activation_map[l_12_1]) do
      l_12_0:deactivate_set(activation_id)
    end
    l_12_0._set_map[l_12_1] = nil
    l_12_0._set_activation_map[l_12_1] = nil
  else
    Application:stack_dump_error("Unable to remove non-existing set id \"" .. tostring(l_12_1) .. "\"")
  end
end

ListenerManager.add_set_category = function(l_13_0, l_13_1, l_13_2)
  local category_map = l_13_0._set_map[l_13_1]
  if category_map then
    local listener_map = l_13_0._category_map[l_13_2]
    if not listener_map then
      listener_map = {}
      l_13_0._category_map[l_13_2] = listener_map
      l_13_0._active_category_map[l_13_2] = false
    end
    category_map[l_13_2] = listener_map
  else
    Application:stack_dump_error("Unable to add a category id \"" .. tostring(l_13_2) .. "\" on non-existing set id \"" .. tostring(l_13_1) .. "\"")
  end
end

ListenerManager.remove_set_category = function(l_14_0, l_14_1, l_14_2)
  local category_map = l_14_0._set_map[l_14_1]
  if category_map then
    if category_map[l_14_2] then
      category_map[l_14_2] = nil
    else
      Application:stack_dump_error("Unable to remove non-existing category id \"" .. tostring(l_14_2) .. "\" on set id \"" .. tostring(l_14_1) .. "\"")
    end
  else
    Application:stack_dump_error("Unable to remove a category id \"" .. tostring(l_14_2) .. "\" on non-existing set id \"" .. tostring(l_14_1) .. "\"")
  end
end

ListenerManager.add_category = function(l_15_0, l_15_1)
  if not l_15_0._category_map[l_15_1] then
    l_15_0._category_map[l_15_1] = {}
    l_15_0._active_category_map[l_15_1] = false
  else
    Application:stack_dump_error("Unable to add already existing category id \"" .. tostring(l_15_1) .. "\"")
  end
end

ListenerManager.remove_category = function(l_16_0, l_16_1)
  if l_16_0._category_map[l_16_1] then
    for set_id,category_map in pairs(l_16_0._set_map) do
      if category_map[l_16_1] then
        l_16_0:remove_set_category(set_id, l_16_1)
      end
    end
    l_16_0._category_map[l_16_1] = nil
    l_16_0._active_category_map[l_16_1] = nil
  else
    Application:stack_dump_error("Unable to remove non-existing category id \"" .. tostring(l_16_1) .. "\"")
  end
end

ListenerManager.add_listener = function(l_17_0, l_17_1, l_17_2, l_17_3, l_17_4, l_17_5)
  if not l_17_0._category_map[l_17_1] then
    l_17_0:add_category(l_17_1)
  end
  local listener_map = l_17_0._category_map[l_17_1]
  local listener = SoundDevice:create_listener(l_17_1)
  listener:link_position(l_17_2)
  if l_17_3 then
    listener:link_orientation(l_17_3)
  end
  if l_17_4 then
    listener:link_occlusion(l_17_4)
  end
  local listener_data = {listener = listener, category_id = l_17_1, enabled = not l_17_5, distance_obj = l_17_2, orientation_obj = l_17_3, occlusion_obj = l_17_4}
  local key = listener:key()
  l_17_0._listener_map[key] = listener_data
  listener_map[key] = listener_data
  if not l_17_0._enabled or l_17_5 or not l_17_0._active_category_map[l_17_1] then
    listener:activate(false)
  end
  return key
end

ListenerManager.remove_listener = function(l_18_0, l_18_1)
  local listener = l_18_0._listener_map[l_18_1]
  if listener then
    local category_id = listener.category_id
    local listener_map = l_18_0._category_map[category_id]
    if listener_map then
      if listener_map[l_18_1] then
        listener_map[l_18_1].listener = nil
        listener_map[l_18_1] = nil
        l_18_0._listener_map[l_18_1] = nil
      else
        Application:stack_dump_error("Unable to remove non-existing listener id \"" .. tostring(l_18_1) .. "\" in category id \"" .. tostring(category_id) .. "\".")
      end
    else
      Application:stack_dump_error("Unable to remove listener id \"" .. tostring(l_18_1) .. "\" in non-existing category id \"" .. tostring(category_id) .. "\".")
    end
  else
    Application:stack_dump_error("Unable to remove non-existing listener id \"" .. tostring(l_18_1) .. "\".")
  end
end

ListenerManager.set_listener = function(l_19_0, l_19_1, l_19_2, l_19_3, l_19_4)
  local listener = l_19_0._listener_map[l_19_1]
  if listener then
    local category_id = listener.category_id
    local listener_map = l_19_0._category_map[category_id]
    if listener_map then
      if listener_map[l_19_1] then
        local listener = listener_map[l_19_1]
        listener:link_position(l_19_2)
        if l_19_3 then
          listener:link_orientation(l_19_3)
        end
        if l_19_4 then
          listener:link_occlusion(l_19_4)
        else
          Application:stack_dump_error("Unable to set non-existing listener id \"" .. tostring(l_19_1) .. "\" in category id \"" .. tostring(category_id) .. "\".")
        end
      else
        Application:stack_dump_error("Unable to set listener id \"" .. tostring(l_19_1) .. "\" in non-existing category id \"" .. tostring(category_id) .. "\".")
      end
    else
      Application:stack_dump_error("Unable to set non-existing listener id \"" .. tostring(l_19_1) .. "\".")
    end
  end
end

ListenerManager.set_listener_enabled = function(l_20_0, l_20_1, l_20_2)
  local data = l_20_0._listener_map[l_20_1]
  if data then
    data.enabled = l_20_2
    if l_20_0._enabled then
      data.listener:activate(not l_20_0._active_category_map[data.category_id] or l_20_2)
  else
    end
    Application:stack_dump_error("Unable to set non-existing listener id \"" .. tostring(l_20_1) .. "\".")
  end
end

ListenerManager.get_listener_enabled = function(l_21_0, l_21_1)
  local listener = l_21_0._listener_map[l_21_1]
  if listener then
    return listener.enabled
  else
    Application:stack_dump_error("Unable to get non-existing listener id \"" .. tostring(l_21_1) .. "\".")
    return nil
  end
end

ListenerManager.activate_set = function(l_22_0, l_22_1, l_22_2)
  local active_set_stack = l_22_0._active_set_stack_map[l_22_1]
  if active_set_stack then
    if l_22_0._set_map[l_22_2] then
      local active_set_id = active_set_stack:top()
      if active_set_id ~= l_22_2 then
        if active_set_id and l_22_0._active_set_count_map[active_set_id] == 1 then
          l_22_0:_deactivate_set(active_set_id)
        end
        l_22_0:_activate_set(l_22_2)
      end
      local link_id = active_set_stack:add(l_22_2)
      local activation_id = l_22_0._last_activation_id + 1
      l_22_0._activation_map[activation_id] = {stack_id = l_22_1, set_id = l_22_2, link_id = link_id}
      l_22_0._stack_activation_map[l_22_1][activation_id] = true
      l_22_0._set_activation_map[l_22_2][activation_id] = true
      l_22_0._last_activation_id = activation_id
      return activation_id
    else
      Application:stack_dump_error("Unable to activate non-existing set id \"" .. tostring(l_22_2) .. "\" on stack id \"" .. l_22_1 .. "\".")
    end
  else
    Application:stack_dump_error("Unable to activate set id \"" .. tostring(l_22_2) .. "\" on non-existing stack id \"" .. l_22_1 .. "\".")
  end
  return -1
end

ListenerManager.deactivate_set = function(l_23_0, l_23_1)
  local activation = l_23_0._activation_map[l_23_1]
  if activation then
    local stack_id = activation.stack_id
    local set_id = activation.set_id
    local active_set_stack = l_23_0._active_set_stack_map[stack_id]
    local top_set_id = active_set_stack:top()
    active_set_stack:remove(activation.link_id)
    local next_active_set_id = active_set_stack:top()
    if set_id == top_set_id and set_id ~= next_active_set_id then
      if next_active_set_id and not l_23_0._active_set_count_map[next_active_set_id] then
        l_23_0:_activate_set(next_active_set_id)
      end
      l_23_0:_deactivate_set(set_id)
    end
    l_23_0._activation_map[l_23_1] = nil
    l_23_0._stack_activation_map[stack_id][l_23_1] = nil
    l_23_0._set_activation_map[set_id][l_23_1] = nil
  else
    Application:stack_dump_error("Unable to deactivate non-existing activation id \"" .. tostring(l_23_1) .. "\".")
  end
end

ListenerManager._activate_set = function(l_24_0, l_24_1)
  local active_set_count = l_24_0._active_set_count_map[l_24_1]
  if not active_set_count then
    l_24_0:_set_listener_set_active(l_24_1, true)
  end
  if not active_set_count then
    active_set_count = 0
  end
  l_24_0._active_set_count_map[l_24_1] = active_set_count + 1
end

ListenerManager._deactivate_set = function(l_25_0, l_25_1)
  local active_set_count = l_25_0._active_set_count_map[l_25_1]
  active_set_count = active_set_count - 1
  if active_set_count <= 0 then
    active_set_count = nil
    l_25_0:_set_listener_set_active(l_25_1, false)
  end
  l_25_0._active_set_count_map[l_25_1] = active_set_count
end

ListenerManager._set_listener_set_active = function(l_26_0, l_26_1, l_26_2)
  for category_id,listener_map in pairs(l_26_0._set_map[l_26_1]) do
    l_26_0._active_category_map[category_id] = l_26_2
    for _,data in pairs(listener_map) do
      data.listener:activate(not l_26_0._enabled or not data.enabled or l_26_2)
      data.active = l_26_2
    end
  end
end

ListenerManager.debug_print = function(l_27_0)
  for stack_id,stack in pairs(l_27_0._active_set_stack_map) do
    cat_debug("debug", tostring(stack_id) .. ": " .. tostring(stack:to_string()))
  end
end


