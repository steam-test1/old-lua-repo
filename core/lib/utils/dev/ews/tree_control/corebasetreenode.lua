CoreBaseTreeNode = CoreBaseTreeNode or class()
function CoreBaseTreeNode:path(separator)
	separator = separator or "/"
	local parent = self:parent()
	if parent then
		return parent:path() .. separator .. self:text()
	end

	return self:text()
end

function CoreBaseTreeNode:has_children()
	return table.getn(self:children()) > 0
end

function CoreBaseTreeNode:child(text, separator)
	local (for generator), (for state), (for control) = ipairs(self:children())
	do
		do break end
		if child:text() == text then
			return child
		end

	end

end

function CoreBaseTreeNode:child_at_path(path, separator)
	separator = separator or "/"
	local first_path_component, remaining_path = string.split(path, separator, false, 1)
	local child = self:child(first_path_component)
	if child and remaining_path then
		return child:child_at_path(remaining_path, separator)
	end

	return child
end

function CoreBaseTreeNode:append_path(path, separator)
	separator = separator or "/"
	local first_path_component, remaining_path = unpack(string.split(path, separator, false, 1))
	local node = self:child(first_path_component) or self:append(first_path_component)
	if remaining_path then
		return node:append_path(remaining_path, separator)
	end

	return node
end

function CoreBaseTreeNode:append_copy_of_node(node, recurse)
	local new_node = self:append(node:text())
	if recurse then
		local (for generator), (for state), (for control) = ipairs(node:children())
		do
			do break end
			new_node:append_copy_of_node(child, true)
		end

	end

end

function CoreBaseTreeNode:for_each_child(func, recurse)
	local (for generator), (for state), (for control) = ipairs(table.list_copy(self:children()))
	do
		do break end
		if not func(child) then
		elseif recurse then
			child:for_each_child(func, true)
		end

	end

end

function CoreBaseTreeNode:remove_children()
	local (for generator), (for state), (for control) = ipairs(table.list_copy(self:children()))
	do
		do break end
		child:remove()
	end

end

