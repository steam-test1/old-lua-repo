require("lib/units/props/AIAttentionObject")
CharacterAttentionObject = CharacterAttentionObject or class(AIAttentionObject)
function CharacterAttentionObject:init(unit)
	CharacterAttentionObject.super.init(self, unit, true)
end

function CharacterAttentionObject:setup_attention_positions(m_head_pos, m_pos)
	self._m_head_pos = m_head_pos or self._unit:movement():m_head_pos()
	self._m_pos = m_pos or self._unit:movement():m_pos()
end

function CharacterAttentionObject:chk_settings_diff(settings_set)
	local attention_data = self._attention_data
	local changes
	if settings_set then
		local (for generator), (for state), (for control) = ipairs(settings_set)
		do
			do break end
			if not attention_data or not attention_data[id] then
				changes = changes or {}
				changes.added = changes.added or {}
				table.insert(changes.added, id)
			elseif attention_data then
				changes = changes or {}
				changes.maintained = changes.maintained or {}
				table.insert(changes.maintained, id)
			end

		end

	end

	if attention_data then
		local (for generator), (for state), (for control) = pairs(attention_data)
		do
			do break end
			local found
			if settings_set then
				local (for generator), (for state), (for control) = ipairs(settings_set)
				do
					do break end
					if old_id == new_id then
						found = true
				end

				else
				end

			end

			if not found then
				changes = changes or {}
				changes.removed = changes.removed or {}
				table.insert(changes.removed, old_id)
			end

		end

	end

	return changes
end

function CharacterAttentionObject:set_settings_set(settings_set)
	local attention_data = self._attention_data
	local changed, register, unregister
	if attention_data then
		if not settings_set or not next(settings_set) then
			settings_set = nil
			unregister = true
		else
			do
				local (for generator), (for state), (for control) = pairs(attention_data)
				do
					do break end
					if not settings_set[id] then
						changed = true
				end

				else
				end

			end

			if not changed then
				local (for generator), (for state), (for control) = pairs(settings_set)
				do
					do break end
					if not attention_data[id] then
						changed = true
				end

				else
				end

			end

		end

	elseif settings_set and next(settings_set) then
		register = true
	end

	if self._overrides then
		if settings_set then
			do
				local (for generator), (for state), (for control) = pairs(self._overrides)
				do
					do break end
					if settings_set[id] then
						self._override_restore = self._override_restore or {}
						self._override_restore[id] = settings_set[id]
						settings_set[id] = overrride_setting
					end

				end

			end

			if attention_data and self._override_restore then
				do
					local (for generator), (for state), (for control) = pairs(attention_data)
					do
						do break end
						if not settings_set[id] then
							self._override_restore[id] = nil
						end

					end

				end

				if not next(self._override_restore) then
					self._override_restore = nil
				end

			end

		else
			self._override_restore = nil
		end

	end

	self._attention_data = settings_set
	if register then
		self:_register()
	elseif unregister then
		managers.groupai:state():unregister_AI_attention_object(self._parent_unit or self._unit:key())
	end

	if changed or unregister then
		self:_call_listeners()
	end

end

function CharacterAttentionObject:get_attention_m_pos(settings)
	return self._m_head_pos
end

function CharacterAttentionObject:get_detection_m_pos()
	return self._m_head_pos
end

function CharacterAttentionObject:get_ground_m_pos()
	return self._m_pos
end

function CharacterAttentionObject:_register()
	managers.groupai:state():register_AI_attention_object(self._parent_unit or self._unit, self, self._unit:movement() and self._unit:movement():nav_tracker())
end

