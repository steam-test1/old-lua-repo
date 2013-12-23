-- Decompiled using luadec 2.0.1 by sztupy (http://winmo.sztupy.hu)
-- Command line was: F:\SteamLibrary\SteamApps\common\PAYDAY 2\lua\core\lib\managers\menu\coremenunode.luac 

core:module("CoreMenuNode")
core:import("CoreSerialize")
core:import("CoreMenuItem")
core:import("CoreMenuItemToggle")
if not MenuNode then
  MenuNode = class()
end
MenuNode.init = function(l_1_0, l_1_1)
  local parameters = {}
  for key,value in pairs(l_1_1) do
    if key ~= "_meta" and type(value) ~= "table" then
      parameters[key] = value
    end
  end
  if parameters.modifier then
    local modifier_names = string.split(parameters.modifier, " ")
    parameters.modifier = {}
    for i = 1, #modifier_names do
      local modifier_instance = loadstring("return " .. modifier_names[i] .. ":new()")()
      parameters.modifier[i] = callback(modifier_instance, modifier_instance, "modify_node")
    end
  end
  if parameters.refresh then
    local refresh_names = string.split(parameters.refresh, " ")
    parameters.refresh = {}
    for i = 1, #refresh_names do
      local refresh_instance = loadstring("return " .. refresh_names[i] .. ":new()")()
      parameters.refresh[i] = callback(refresh_instance, refresh_instance, "refresh_node")
    end
  end
  if parameters.update then
    local update_names = string.split(parameters.update, " ")
    parameters.update = {}
    for i = 1, #update_names do
      local update_instance = loadstring("return " .. update_names[i] .. ":new()")()
      parameters.update[i] = callback(update_instance, update_instance, "update_node")
    end
  end
  if parameters.back_callback then
    parameters.back_callback = string.split(parameters.back_callback, " ")
  else
    parameters.back_callback = {}
  end
  if parameters.back_callback then
    parameters.back_callback_name = parameters.back_callback
    parameters.back_callback = {}
  end
  if parameters.focus_changed_callback then
    parameters.focus_changed_callback = string.split(parameters.focus_changed_callback, " ")
  else
    parameters.focus_changed_callback = {}
  end
  if parameters.focus_changed_callback then
    parameters.focus_changed_callback_name = parameters.focus_changed_callback
    parameters.focus_changed_callback = {}
  end
  if parameters.menu_components then
    parameters.menu_components = string.split(parameters.menu_components, " ")
  end
  l_1_0:set_parameters(parameters)
  l_1_0:_parse_items(l_1_1)
  l_1_0._selected_item = nil
end

MenuNode._parse_items = function(l_2_0, l_2_1)
  l_2_0._items = {}
  l_2_0._legends = {}
  for _,c in ipairs(l_2_1) do
    local type = c._meta
    do
      if type == "item" then
        local item = l_2_0:create_item(c)
        l_2_0:add_item(item)
      end
      for (for control),_ in (for generator) do
      end
      if type == "default_item" then
        l_2_0._default_item_name = c.name
        for (for control),_ in (for generator) do
        end
        if type == "legend" then
          table.insert(l_2_0._legends, {string_id = c.name, pc = c.pc})
        end
      end
       -- Warning: missing end command somewhere! Added here
    end
     -- Warning: missing end command somewhere! Added here
  end
end

MenuNode.update = function(l_3_0, l_3_1, l_3_2)
end

MenuNode.clean_items = function(l_4_0)
  l_4_0._items = {}
end

MenuNode.create_item = function(l_5_0, l_5_1, l_5_2)
  local item = CoreMenuItem.Item
  if l_5_1 then
    local type = l_5_1.type
    if type then
      item_type = type
      item = CoreSerialize.string_to_classtable(item_type)
    end
  end
  item = item:new(l_5_1, l_5_2)
  return item
end

MenuNode.default_item_name = function(l_6_0)
  return l_6_0._default_item_name
end

MenuNode.set_default_item_name = function(l_7_0, l_7_1)
  l_7_0._default_item_name = l_7_1
end

MenuNode.parameters = function(l_8_0)
  return l_8_0._parameters
end

MenuNode.set_parameters = function(l_9_0, l_9_1)
  l_9_0._parameters = l_9_1
end

MenuNode.add_item = function(l_10_0, l_10_1)
  l_10_1.dirty_callback = callback(l_10_0, l_10_0, "item_dirty")
  if l_10_0.callback_handler then
    l_10_1:set_callback_handler(l_10_0.callback_handler)
  end
  local last = l_10_0._items[#l_10_0._items]
  if last then
    local is_back = last:parameters().back
  end
  if is_back then
    table.insert(l_10_0._items, #l_10_0._items, l_10_1)
  else
    table.insert(l_10_0._items, l_10_1)
  end
end

MenuNode.insert_item = function(l_11_0, l_11_1, l_11_2)
  l_11_1.dirty_callback = callback(l_11_0, l_11_0, "item_dirty")
  if l_11_0.callback_handler then
    l_11_1:set_callback_handler(l_11_0.callback_handler)
  end
  table.insert(l_11_0._items, l_11_2, l_11_1)
end

MenuNode.delete_item = function(l_12_0, l_12_1)
  for i,item in ipairs(l_12_0:items()) do
    if item:parameters().name == l_12_1 then
      if item == l_12_0:selected_item() then
        l_12_0._selected_item = nil
      end
      local del_item = table.remove(l_12_0._items, i)
      del_item:on_delete_item()
      return del_item
    end
  end
end

MenuNode.item = function(l_13_0, l_13_1)
  if not l_13_1 then
    l_13_1 = l_13_0._default_item_name
  end
  local item = nil
  for _,i in ipairs(l_13_0:items()) do
    if (not l_13_1 and i:visible()) or i:parameters().name == l_13_1 then
      item = i
  else
    end
  end
  return item
end

MenuNode.items = function(l_14_0)
  return l_14_0._items
end

MenuNode.set_items = function(l_15_0, l_15_1)
  l_15_0._items = l_15_1
end

MenuNode.selected_item = function(l_16_0)
  return l_16_0._selected_item
end

MenuNode.select_item = function(l_17_0, l_17_1)
  if not l_17_1 and l_17_0:item() and not l_17_0:item():visible() then
    for i,item in ipairs(l_17_0:items()) do
      if item:visible() then
        l_17_0._default_item_name = item:name()
    else
      end
    end
    l_17_0._selected_item = l_17_0:item(l_17_1)
     -- Warning: missing end command somewhere! Added here
  end
end

MenuNode.set_callback_handler = function(l_18_0, l_18_1)
  l_18_0.callback_handler = l_18_1
  for _,callback_name in pairs(l_18_0._parameters.back_callback_name) do
    table.insert(l_18_0._parameters.back_callback, callback(l_18_1, l_18_1, callback_name))
  end
  for _,callback_name in pairs(l_18_0._parameters.focus_changed_callback_name) do
    table.insert(l_18_0._parameters.focus_changed_callback, callback(l_18_1, l_18_1, callback_name))
  end
  for _,item in ipairs(l_18_0._items) do
    item:set_callback_handler(l_18_1)
  end
end

MenuNode.trigger_back = function(l_19_0)
  if l_19_0:parameters().block_back then
    return true
  end
  local block_back = nil
  for _,callback in pairs(l_19_0:parameters().back_callback) do
    if not block_back then
      block_back = callback(l_19_0)
    end
  end
  return block_back
end

MenuNode.trigger_focus_changed = function(l_20_0, l_20_1, ...)
  for _,callback in pairs(l_20_0:parameters().focus_changed_callback) do
    callback(l_20_0, l_20_1, ...)
  end
   -- DECOMPILER ERROR: Confused about usage of registers for local variables.

end

MenuNode.item_dirty = function(l_21_0, l_21_1)
  if l_21_0.dirty_callback then
    l_21_0.dirty_callback(l_21_0, l_21_1)
  end
end

MenuNode.legends = function(l_22_0)
  return l_22_0._legends
end


