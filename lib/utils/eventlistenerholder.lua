EventListenerHolder = EventListenerHolder or class()
function EventListenerHolder:add(key, event_types, clbk)
	if self._calling then
		self:_set_new(key, event_types, clbk)
	else
		self:_add(key, event_types, clbk)
	end

end

function EventListenerHolder:remove(key)
	if self._calling then
		self:_set_trash(key)
	else
		self:_remove(key)
	end

end

function EventListenerHolder:call(event, ...)
	if self._listeners then
		local event_listeners = self._listeners[event]
		if event_listeners then
			self._calling = true
			do
				local (for generator), (for state), (for control) = pairs(event_listeners)
				do
					do break end
					if self:_not_trash(key) then
						clbk(...)
					end

				end

			end

			self._calling = nil
			self:_append_new_additions()
			self:_dispose_trash()
		end

	end

end

function EventListenerHolder:_remove(key)
	local listeners = self._listeners
	do
		local (for generator), (for state), (for control) = pairs(self._listener_keys[key])
		do
			do break end
			listeners[event][key] = nil
			if not next(listeners[event]) then
				listeners[event] = nil
			end

		end

	end

	if next(listeners) then
		self._listener_keys[key] = nil
	else
		self._listeners = nil
		self._listener_keys = nil
	end

end

function EventListenerHolder:_add(key, event_types, clbk)
	if self._listener_keys and self._listener_keys[key] then
		debug_pause("[EventListenerHolder:_add] duplicate", key, inspect(event_types), clbk)
		return
	end

	local listeners = self._listeners
	if not listeners then
		self._listeners = {}
		self._listener_keys = {}
		listeners = self._listeners
	end

	do
		local (for generator), (for state), (for control) = pairs(event_types)
		do
			do break end
			listeners[event] = listeners[event] or {}
			listeners[event][key] = clbk
		end

	end

	self._listener_keys[key] = event_types
end

function EventListenerHolder:_set_trash(key)
	self._trash = self._trash or {}
	self._trash[key] = true
	if self._additions then
		self._additions[key] = nil
	end

end

function EventListenerHolder:_set_new(key, event_types, clbk)
	if self._additions and self._additions[key] then
		debug_pause("[EventListenerHolder:_set_new] duplicate", key, inspect(event_types), clbk)
		return
	end

	self._additions = self._additions or {}
	self._additions[key] = {clbk, event_types}
	if self._trash then
		self._trash[key] = nil
	end

end

function EventListenerHolder:_append_new_additions()
	if self._additions then
		local listeners = self._listeners
		if not listeners then
			self._listeners = {}
			self._listener_keys = {}
			listeners = self._listeners
		end

		do
			local (for generator), (for state), (for control) = pairs(self._additions)
			do
				do break end
				do
					local (for generator), (for state), (for control) = ipairs(new_entry[2])
					do
						do break end
						listeners[event] = listeners[event] or {}
						listeners[event][key] = new_entry[1]
					end

				end

				self._listener_keys[key] = new_entry[2]
			end

		end

		self._additions = nil
	end

end

function EventListenerHolder:_dispose_trash()
	if self._trash then
		do
			local (for generator), (for state), (for control) = pairs(self._trash)
			do
				do break end
				self:_remove(key)
			end

		end

		self._trash = nil
	end

end

function EventListenerHolder:_not_trash(key)
	return not self._trash or not self._trash[key]
end

function EventListenerHolder:has_listeners_for_event(event)
	return self._listeners and self._listeners[event]
end

