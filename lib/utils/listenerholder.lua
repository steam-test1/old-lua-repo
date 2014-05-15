ListenerHolder = ListenerHolder or class()
function ListenerHolder:add(key, clbk)
	if self._calling then
		self:_set_new(key, clbk)
	else
		self:_add(key, clbk)
	end

end

function ListenerHolder:remove(key)
	if self._calling then
		self:_set_trash(key)
	else
		self:_remove(key)
	end

end

function ListenerHolder:call(...)
	if self._listeners then
		self._calling = true
		do
			local (for generator), (for state), (for control) = pairs(self._listeners)
			do
				do break end
				if self:_not_trash(key) then
					clbk(...)
				end

			end

		end

		self._calling = nil
		(for control) = nil and self._not_trash
		self:_append_new_additions()
		self:_dispose_trash()
	end

end

function ListenerHolder:_remove(key)
	self._listeners[key] = nil
	if not next(self._listeners) then
		self._listeners = nil
	end

end

function ListenerHolder:_add(key, clbk)
	self._listeners = self._listeners or {}
	self._listeners[key] = clbk
end

function ListenerHolder:_set_trash(key)
	self._trash = self._trash or {}
	self._trash[key] = true
	if self._additions then
		self._additions[key] = nil
	end

end

function ListenerHolder:_set_new(key, clbk)
	self._additions = self._additions or {}
	self._additions[key] = clbk
	if self._trash then
		self._trash[key] = nil
	end

end

function ListenerHolder:_append_new_additions()
