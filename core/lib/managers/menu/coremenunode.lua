core:module("CoreMenuNode")
core:import("CoreSerialize")
core:import("CoreMenuItem")
core:import("CoreMenuItemToggle")
MenuNode = MenuNode or class()
function MenuNode:init(data_node)
-- fail 6
null
5
	local parameters = {}
	do
		local (for generator), (for state), (for control) = pairs(data_node)
		do
			do break end
			if key ~= "_meta" and type(value) ~= "table" then
				parameters[key] = value
			end

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

	self:set_parameters(parameters)
	self:_parse_items(data_node)
	self._selected_item = nil
end

function MenuNode:_parse_items(data_node)
	self._items = {}
	self._legends = {}
	local (for generator), (for state), (for control) = ipairs(data_node)
	do
		do break end
		local type = c._meta
		if type == "item" then
			local item = self:create_item(c)
			self:add_item(item)
		elseif type == "default_item" then
			self._default_item_name = c.name
		elseif type == "legend" then
			table.insert(self._legends, {
				string_id = c.name,
				pc = c.pc
			})
		end

	end

end

function MenuNode:update(t, dt)
end

function MenuNode:clean_items()
	self._items = {}
end

function MenuNode:create_item(data_node, parameters)
	local item = CoreMenuItem.Item
	if data_node then
		local type = data_node.type
		if type then
			item_type = type
			item = CoreSerialize.string_to_classtable(item_type)
		end

	end

	item = item:new(data_node, parameters)
	return item
end

function MenuNode:default_item_name()
	return self._default_item_name
end

function MenuNode:set_default_item_name(default_item_name)
	self._default_item_name = default_item_name
end

function MenuNode:parameters()
	return self._parameters
end

function MenuNode:set_parameters(parameters)
	self._parameters = parameters
end

function MenuNode:add_item(item)
	item.dirty_callback = callback(self, self, "item_dirty")
	if self.callback_handler then
		item:set_callback_handler(self.callback_handler)
	end

	local last = self._items[#self._items]
	local is_back = last and (last:parameters().back or last:parameters().last_item)
	if is_back then
		table.insert(self._items, #self._items, item)
	else
		table.insert(self._items, item)
	end

end

function MenuNode:insert_item(item, i)
	item.dirty_callback = callback(self, self, "item_dirty")
	if self.callback_handler then
		item:set_callback_handler(self.callback_handler)
	end

	table.insert(self._items, i, item)
end

function MenuNode:delete_item(item_name)
	local (for generator), (for state), (for control) = ipairs(self:items())
	do
		do break end
		if item:parameters().name == item_name then
			if item == self:selected_item() then
				self._selected_item = nil
			end

			local del_item = table.remove(self._items, i)
			del_item:on_delete_item()
			return del_item
		end

	end

end

function MenuNode:item(item_name)
	item_name = item_name or self._default_item_name
	local item
	do
		local (for generator), (for state), (for control) = ipairs(self:items())
		do
			do break end
			if not item_name and i:visible() or i:parameters().name == item_name then
				item = i
		end

		else
		end

	end

end

function MenuNode:items()
	return self._items
end

function MenuNode:set_items(items)
	self._items = items
end

function MenuNode:selected_item()
	return self._selected_item
end

function MenuNode:select_item(item_name)
	if not item_name and self:item() and not self:item():visible() then
		local (for generator), (for state), (for control) = ipairs(self:items())
		do
			do break end
			if item:visible() then
				self._default_item_name = item:name()
		end

		else
		end

	end

	(for control) = self:items() and item.visible
	self._selected_item = self:item(item_name)
end

function MenuNode:set_callback_handler(callback_handler)
	self.callback_handler = callback_handler
	do
		local (for generator), (for state), (for control) = pairs(self._parameters.back_callback_name)
		do
			do break end
			table.insert(self._parameters.back_callback, callback(callback_handler, callback_handler, callback_name))
		end

	end

	(for control) = nil and table
	do
		local (for generator), (for state), (for control) = pairs(self._parameters.focus_changed_callback_name)
		do
			do break end
			table.insert(self._parameters.focus_changed_callback, callback(callback_handler, callback_handler, callback_name))
		end

	end

	(for control) = nil and table
	local (for generator), (for state), (for control) = ipairs(self._items)
	do
		do break end
		item:set_callback_handler(callback_handler)
	end

end

function MenuNode:trigger_back()
	if self:parameters().block_back then
		return true
	end

	local block_back
	do
		local (for generator), (for state), (for control) = pairs(self:parameters().back_callback)
		do
			do break end
			block_back = block_back or callback(self)
		end

	end

end

function MenuNode:trigger_focus_changed(in_focus, ...)
	local (for generator), (for state), (for control) = pairs(self:parameters().focus_changed_callback)
	do
		do break end
		callback(self, in_focus, ...)
	end

end

function MenuNode:item_dirty(item)
	if self.dirty_callback then
		self.dirty_callback(self, item)
	end

end

function MenuNode:legends()
	return self._legends
end

