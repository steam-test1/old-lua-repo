-- Decompiled using luadec 2.0.1 by sztupy (http://winmo.sztupy.hu)
-- Command line was: F:\SteamLibrary\SteamApps\common\PAYDAY 2\lua\core\lib\managers\menu\coremenulogic.luac 

core:module("CoreMenuLogic")
if not Logic then
  Logic = class()
end
Logic.init = function(l_1_0, l_1_1)
  l_1_0._data = l_1_1
  l_1_0._node_stack = {}
  l_1_0._callback_map = {}
  l_1_0._callback_map.renderer_show_node = nil
  l_1_0._callback_map.renderer_refresh_node = nil
  l_1_0._callback_map.renderer_update_node = nil
  l_1_0._callback_map.renderer_select_item = nil
  l_1_0._callback_map.renderer_deselect_item = nil
  l_1_0._callback_map.renderer_trigger_item = nil
  l_1_0._callback_map.renderer_navigate_back = nil
  l_1_0._callback_map.renderer_node_item_dirty = nil
  l_1_0._callback_map.input_accept_input = nil
  l_1_0._callback_map.menu_manager_menu_closed = nil
  l_1_0._callback_map.menu_manager_select_node = nil
  l_1_0._action_queue = {}
  l_1_0._action_callback_map = {}
  l_1_0._action_callback_map.select_node = callback(l_1_0, l_1_0, "_select_node")
  l_1_0._action_callback_map.navigate_back = callback(l_1_0, l_1_0, "_navigate_back")
  l_1_0._action_callback_map.select_item = callback(l_1_0, l_1_0, "_select_item")
  l_1_0._action_callback_map.trigger_item = callback(l_1_0, l_1_0, "_trigger_item")
  l_1_0._action_callback_map.refresh_node = callback(l_1_0, l_1_0, "_refresh_node")
  l_1_0._action_callback_map.update_node = callback(l_1_0, l_1_0, "_update_node")
end

Logic.open = function(l_2_0, ...)
  l_2_0._accept_input = not managers.system_menu:is_active()
  l_2_0:select_node(nil, true)
   -- DECOMPILER ERROR: Confused about usage of registers for local variables.

end

Logic._queue_action = function(l_3_0, l_3_1, ...)
  table.insert(l_3_0._action_queue, {action_name = l_3_1, parameters = {...}})
   -- DECOMPILER ERROR: Confused about usage of registers for local variables.

end

Logic._execute_action_queue = function(l_4_0)
  repeat
    if l_4_0._accept_input and #l_4_0._action_queue > 0 then
      local action = l_4_0._action_queue[1]
      if l_4_0._action_callback_map[action.action_name] then
        l_4_0._action_callback_map[action.action_name](unpack(action.parameters))
      end
      table.remove(l_4_0._action_queue, 1)
    else
       -- Warning: missing end command somewhere! Added here
    end
     -- Warning: missing end command somewhere! Added here
  end
end

Logic.update = function(l_5_0, l_5_1, l_5_2)
  if l_5_0:selected_node() then
    l_5_0:selected_node():update(l_5_1, l_5_2)
  end
  l_5_0:_execute_action_queue()
end

Logic.select_node = function(l_6_0, l_6_1, l_6_2, ...)
  if l_6_0._accept_input or l_6_2 then
    l_6_0:_queue_action("select_node", l_6_1, ...)
     -- DECOMPILER ERROR: Confused about usage of registers for local variables.

  end
end

Logic._select_node = function(l_7_0, l_7_1, ...)
  local node = l_7_0:get_node(l_7_1, ...)
   -- DECOMPILER ERROR: Confused while interpreting a jump as a 'while'

end
local has_active_menu = true
do
  if has_active_menu and node then
    local selected_node = l_7_0:selected_node()
    if selected_node then
      selected_node:trigger_focus_changed(false)
    end
    node:trigger_focus_changed(true, ...)
    if node:parameters().menu_components then
      managers.menu_component:set_active_components(node:parameters().menu_components, node)
    end
    table.insert(l_7_0._node_stack, node)
    l_7_0:_call_callback("renderer_show_node", node)
    node:select_item()
    l_7_0:_call_callback("renderer_select_item", node:selected_item())
    l_7_0:_call_callback("menu_manager_select_node", node)
  end
   -- DECOMPILER ERROR: Confused about usage of registers for local variables.

end
end

Logic.refresh_node = function(l_8_0, l_8_1, l_8_2, ...)
  l_8_0:_queue_action("refresh_node", l_8_1, ...)
   -- DECOMPILER ERROR: Confused about usage of registers for local variables.

end

Logic._refresh_node = function(l_9_0, l_9_1, ...)
  local node = l_9_0:selected_node()
  if node:parameters().refresh then
    for _,refresh_func in ipairs(node:parameters().refresh) do
      node = refresh_func(node, ...)
    end
  end
  if node then
    l_9_0:_call_callback("renderer_refresh_node", node)
    do
      local selected_item = node:selected_item()
      if selected_item then
        node:select_item(selected_item:name())
      end
      l_9_0:_call_callback("renderer_select_item", node:selected_item())
    end
     -- DECOMPILER ERROR: Confused about usage of registers for local variables.

  end
end

Logic.update_node = function(l_10_0, l_10_1, l_10_2, ...)
  l_10_0:_queue_action("update_node", l_10_1, ...)
   -- DECOMPILER ERROR: Confused about usage of registers for local variables.

end

Logic._update_node = function(l_11_0, l_11_1, ...)
  do
    local node = l_11_0:selected_node()
    if node and node:parameters().update then
      for _,update_func in ipairs(node:parameters().update) do
        node = update_func(node, ...)
      end
      do return end
      Application:error("[CoreLogic:_update_node] Trying to update selected node, but none is selected!")
    end
     -- DECOMPILER ERROR: Confused about usage of registers for local variables.

  end
end

Logic.navigate_back = function(l_12_0, l_12_1, l_12_2)
  if l_12_0._accept_input or l_12_1 then
    l_12_0:_queue_action("navigate_back", l_12_2)
  end
end

Logic._navigate_back = function(l_13_0, l_13_1)
  local node = l_13_0._node_stack[#l_13_0._node_stack]
  if node then
    if node:trigger_back() then
      return 
    end
    node:trigger_focus_changed(false)
  end
  if type(l_13_1) ~= "number" or not l_13_1 then
    l_13_1 = 0
  end
  if 1 + l_13_1 < #l_13_0._node_stack then
    for i = 1, 1 + l_13_1 do
      table.remove(l_13_0._node_stack, #l_13_0._node_stack)
      l_13_0:_call_callback("renderer_navigate_back")
    end
    node = l_13_0._node_stack[#l_13_0._node_stack]
    if node then
      node:trigger_focus_changed(true)
      if node:parameters().menu_components then
        managers.menu_component:set_active_components(node:parameters().menu_components, node)
      end
    end
  end
  l_13_0:_call_callback("menu_manager_select_node", node)
end

Logic.soft_open = function(l_14_0)
  local node = l_14_0._node_stack[#l_14_0._node_stack]
  if node then
    if node:parameters().menu_components then
      managers.menu_component:set_active_components(node:parameters().menu_components, node)
    end
    l_14_0:_call_callback("menu_manager_select_node", node)
  end
end

Logic.selected_node = function(l_15_0)
  return l_15_0._node_stack[#l_15_0._node_stack]
end

Logic.selected_node_name = function(l_16_0)
  return l_16_0:selected_node():parameters().name
end

Logic.select_item = function(l_17_0, l_17_1, l_17_2)
  if l_17_0._accept_input or l_17_2 then
    l_17_0:_queue_action("select_item", l_17_1)
  end
end

Logic.mouse_over_select_item = function(l_18_0, l_18_1, l_18_2)
  if l_18_0._accept_input or l_18_2 then
    l_18_0:_queue_action("select_item", l_18_1, true)
  end
end

Logic._select_item = function(l_19_0, l_19_1, l_19_2)
  local current_node = l_19_0:selected_node()
  if current_node then
    local current_item = current_node:selected_item()
    if current_item then
      l_19_0:_call_callback("renderer_deselect_item", current_item)
    end
    current_node:select_item(l_19_1)
    l_19_0:_call_callback("renderer_select_item", current_node:selected_item(), l_19_2)
  end
end

Logic.trigger_item = function(l_20_0, l_20_1, l_20_2)
  if l_20_0._accept_input or l_20_1 then
    l_20_0:_queue_action("trigger_item", l_20_2)
  end
end

Logic._trigger_item = function(l_21_0, l_21_1)
  if not l_21_1 then
    l_21_1 = l_21_0:selected_item()
  end
  if l_21_1 then
    l_21_1:trigger()
    l_21_0:_call_callback("renderer_trigger_item", l_21_1)
  end
end

Logic.selected_item = function(l_22_0)
  local item = nil
  local node = l_22_0:selected_node()
  if node then
    item = node:selected_item()
  end
  return item
end

Logic.get_item = function(l_23_0, l_23_1)
  local item = nil
  local node = l_23_0:selected_node()
  if node then
    item = node:item(l_23_1)
  end
  return item
end

Logic.get_node = function(l_24_0, l_24_1, ...)
  do
    local node = l_24_0._data:get_node(l_24_1, ...)
    if node and not node.dirty_callback then
      node.dirty_callback = callback(l_24_0, l_24_0, "node_item_dirty")
    end
    return node
  end
   -- DECOMPILER ERROR: Confused about usage of registers for local variables.

end

Logic.accept_input = function(l_25_0, l_25_1)
  l_25_0._accept_input = l_25_1
  l_25_0:_call_callback("input_accept_input", l_25_1)
end

Logic.register_callback = function(l_26_0, l_26_1, l_26_2)
  l_26_0._callback_map[l_26_1] = l_26_2
end

Logic._call_callback = function(l_27_0, l_27_1, ...)
  if l_27_0._callback_map[l_27_1] then
    l_27_0._callback_map[l_27_1](...)
  else
    Application:error("Logic:_call_callback: Callback " .. l_27_1 .. " not found.")
     -- DECOMPILER ERROR: Confused about usage of registers for local variables.

  end
end

Logic.node_item_dirty = function(l_28_0, l_28_1, l_28_2)
  l_28_0:_call_callback("renderer_node_item_dirty", l_28_1, l_28_2)
end

Logic.renderer_closed = function(l_29_0)
  l_29_0:_call_callback("menu_manager_menu_closed")
end

Logic.close = function(l_30_0, l_30_1)
  local selected_node = l_30_0:selected_node()
  managers.menu_component:set_active_components({})
  for index = #l_30_0._node_stack, 1, -1 do
    local node = l_30_0._node_stack[index]
    if not l_30_1 and node then
      node:trigger_back()
    end
  end
  l_30_0._node_stack = {}
  l_30_0:_call_callback("menu_manager_select_node", false)
end


