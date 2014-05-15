CoreCutsceneCast = CoreCutsceneCast or class()
function CoreCutsceneCast:prime(cutscene)
	assert(cutscene and cutscene:is_valid(), "Attempting to prime invalid cutscene.")
	local preload = true
	self:_actor_units_in_cutscene(cutscene)
	self:_animation_blob_controller(cutscene, preload)
end

function CoreCutsceneCast:unload()
-- fail 8
null
3
	do
		local (for generator), (for state), (for control) = pairs(self._animation_blob_controllers or {})
		do
			do break end
			if blob_controller ~= false and alive(blob_controller) then
				if blob_controller:is_playing() then
					blob_controller:stop()
				end

				blob_controller:destroy()
			end

		end

	end

	self._animation_blob_controllers = nil
	do
		local (for generator), (for state), (for control) = pairs(self._spawned_units or {})
		do
			do break end
			if alive(unit) then
				local unit_type = unit:name()
				World:delete_unit(unit)
			end

		end

	end

	self._spawned_units = nil
	(for control) = nil and alive
	if alive(self.__root_unit) then
		World:delete_unit(self.__root_unit)
	end

	self.__root_unit = nil
end

function CoreCutsceneCast:is_ready(cutscene)
	local blob_controller = cutscene and self:_animation_blob_controller(cutscene)
	return blob_controller == nil or blob_controller:ready()
end

function CoreCutsceneCast:set_timer(timer)
	local (for generator), (for state), (for control) = pairs(self._spawned_units or {})
	do
		do break end
		if alive(unit) then
			unit:set_timer(timer)
			unit:set_animation_timer(timer)
		end

	end

end

function CoreCutsceneCast:set_cutscene_visible(cutscene, visible)
	local (for generator), (for state), (for control) = pairs(self._spawned_units or {})
	do
		do break end
		if cutscene:has_unit(unit_name, true) then
			self:_set_unit_and_children_visible(unit, visible and self:unit_visible(unit_name))
		end

	end

end

function CoreCutsceneCast:set_unit_visible(unit_name, visible)
	visible = not not visible
	self._hidden_units = self._hidden_units or {}
	local current_visibility = not self._hidden_units[unit_name]
	if visible ~= current_visibility then
		self._hidden_units[unit_name] = not visible or nil
		local unit = self:unit(unit_name)
		if unit then
			self:_set_unit_and_children_visible(unit, visible)
		end

	end

end

function CoreCutsceneCast:unit_visible(unit_name)
	return (self._hidden_units and self._hidden_units[unit_name]) == nil
end

function CoreCutsceneCast:unit(unit_name)
	return self._spawned_units and self._spawned_units[unit_name]
end

function CoreCutsceneCast:actor_unit(unit_name, cutscene)
	local unit = self:unit(unit_name)
	if unit and cutscene:has_unit(unit_name) then
		return unit
	else
		return self:_actor_units_in_cutscene(cutscene)[unit_name]
	end

end

function CoreCutsceneCast:unit_names()
	return self._spawned_units and table.map_keys(self._spawned_units) or {}
end

function CoreCutsceneCast:evaluate_cutscene_at_time(cutscene, time)
