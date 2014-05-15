core:import("CoreSequenceManager")
CoreUnitDamage = CoreUnitDamage or class()
UnitDamage = UnitDamage or class(CoreUnitDamage)
local ids_damage = Idstring("damage")
function CoreUnitDamage:init(unit, default_body_extension_class, body_extension_class_map, ignore_body_collisions, ignore_mover_collisions, mover_collision_ignore_duration)
	self._unit = unit
	self._unit_element = managers.sequence:get(unit:name(), false, true)
	self._damage = 0
	if self._unit_element._set_variables and next(self._unit_element._set_variables) then
		self._variables = clone(self._unit_element._set_variables)
	end

	self._unit:set_extension_update_enabled(ids_damage, self._update_func_map ~= nil)
	do
		local (for generator), (for state), (for control) = pairs(self._unit_element:get_proximity_element_map())
		do
			do break end
			local data = {}
			data.name = name
			data.enabled = element:get_enabled()
			data.ref_object = element:get_ref_object() and self._unit:get_object(Idstring(element:get_ref_object()))
			data.interval = element:get_interval()
			data.quick = element:is_quick()
			data.is_within = element:get_start_within()
			data.slotmask = element:get_slotmask()
			data.last_check_time = TimerManager:game():time() + math.rand(math.min(data.interval, 0))
			self:populate_proximity_range_data(data, "within_data", element:get_within_element())
			self:populate_proximity_range_data(data, "outside_data", element:get_outside_element())
			self._proximity_map = self._proximity_map or {}
			self._proximity_map[name] = data
			self._proximity_count = (self._proximity_count or 0) + 1
			if data.enabled then
				if not self._proximity_enabled_count then
					self._proximity_enabled_count = 0
					self:set_update_callback("update_proximity_list", true)
				end

				self._proximity_enabled_count = self._proximity_enabled_count + 1
			end

		end

	end

	(for control) = self._unit_element:get_proximity_element_map() and {}
	do
		local (for generator), (for state), (for control) = pairs(self._unit_element:get_trigger_name_map())
		do
			do break end
			self._trigger_func_list = self._trigger_func_list or {}
			self._trigger_func_list[trigger_name] = {}
		end

	end

	self._mover_collision_ignore_duration = mover_collision_ignore_duration
	(for control) = self._unit_element:get_trigger_name_map() and self._trigger_func_list
	body_extension_class_map = body_extension_class_map or {}
	default_body_extension_class = default_body_extension_class or CoreBodyDamage
	local inflict_updator_damage_type_map = get_core_or_local("InflictUpdator").INFLICT_UPDATOR_DAMAGE_TYPE_MAP
	local unit_key = self._unit:key()
	do
		local (for generator), (for state), (for control) = pairs(self._unit_element._bodies)
		do
			do break end
			local body = self._unit:body(body_element._name)
			if body then
				body:set_extension(body:extension() or {})
				local body_ext = body_extension_class_map[body_element._name] or default_body_extension_class:new(self._unit, self, body, body_element)
				body:extension().damage = body_ext
				local body_key
				local (for generator), (for state), (for control) = pairs(body_ext:get_endurance_map())
				do
					do break end
					if inflict_updator_damage_type_map[damage_type] then
						body_key = body_key or body:key()
						self._added_inflict_updator_damage_type_map = self._added_inflict_updator_damage_type_map or {}
						self._added_inflict_updator_damage_type_map[damage_type] = {}
						self._added_inflict_updator_damage_type_map[damage_type][body_key] = body_ext
						managers.sequence:add_inflict_updator_body(damage_type, unit_key, body_key, body_ext)
					end

				end

			else
				(for control) = body_ext:get_endurance_map() and inflict_updator_damage_type_map[damage_type]
				Application:throw_exception("Unit \"" .. self._unit:name():t() .. "\" doesn't have the body \"" .. body_element._name .. "\" that was loaded into the SequenceManager.")
			end

		end

	end

	do break end
	self._unit:set_body_collision_callback(callback(self, self, "body_collision_callback"))
	if self._unit:mover() and not ignore_mover_collisions then
		self._unit:set_mover_collision_callback(callback(self, self, "mover_collision_callback"))
	end

	self._water_check_element_map = self._unit_element:get_water_element_map()
	if self._water_check_element_map then
		local (for generator), (for state), (for control) = pairs(self._water_check_element_map)
		do
			do break end
			self:set_water_check(name, water_element:get_enabled(), water_element:get_interval(), water_element:get_ref_object(), water_element:get_ref_body(), water_element:get_body_depth(), water_element:get_physic_effect())
		end

	end

	(for control) = callback(self, self, "mover_collision_callback") and self.set_water_check
	self._startup_sequence_map = self._unit_element:get_startup_sequence_map(self._unit, self)
	if self._startup_sequence_map then
		self._startup_sequence_callback_id = managers.sequence:add_time_callback(callback(self, self, "run_startup_sequences"))
	end

	if Application:editor() then
		self._editor_startup_sequence_map = self._unit_element:get_editor_startup_sequence_map(self._unit, self)
		if self._editor_startup_sequence_map then
			self._editor_startup_sequence_callback_id = managers.sequence:add_time_callback(callback(self, self, "run_editor_startup_sequences"))
		end

	end

end

function CoreUnitDamage:get_sound_source(object)
	self._sound_sources = self._sound_sources or {}
	local sound_source = self._sound_sources[object]
	if not sound_source then
		sound_source = SoundDevice:create_source(object)
		local obj = self._unit:get_object(Idstring(object))
		if obj then
			sound_source:link(obj)
		else
			return
		end

		self._sound_sources[object] = sound_source
	end

	return sound_source
end

function CoreUnitDamage:destroy()
	if self._added_inflict_updator_damage_type_map then
		local unit_key = self._unit:key()
		local (for generator), (for state), (for control) = pairs(self._added_inflict_updator_damage_type_map)
		do
			do break end
			local (for generator), (for state), (for control) = pairs(body_map)
			do
				do break end
				managers.sequence:remove_inflict_updator_body(damage_type, unit_key, body_key)
			end

		end

		(for control) = nil and managers
	end

	(for control) = nil and pairs
	if self._water_check_map then
		local (for generator), (for state), (for control) = pairs(self._water_check_map)
		do
			do break end
			self:set_water_check_active(name, false)
		end

	end

	(for control) = pairs(self._added_inflict_updator_damage_type_map) and self.set_water_check_active
	if self._inherit_destroy_unit_list then
		local (for generator), (for state), (for control) = ipairs(self._inherit_destroy_unit_list)
		do
			do break end
			if alive(unit) then
				unit:set_slot(0)
			end

		end

	end

end

function CoreUnitDamage:update(unit, t, dt)
	if self._update_func_map then
		local (for generator), (for state), (for control) = pairs(self._update_func_map)
		do
			do break end
			self[func_name](self, unit, t, dt, data)
		end

	else
		(for control) = nil and self[func_name]
		Application:error("Some scripter tried to enable the damage extension on unit \"" .. tostring(unit:name()) .. "\" or an artist have specified more than one damage-extension in the unit xml. This would have resulted in a crash, so fix it!")
		self._unit:set_extension_update_enabled(ids_damage, false)
	end

end

function CoreUnitDamage:set_update_callback(func_name, data)
	if data then
		self._update_func_map = self._update_func_map or {}
		if not self._update_func_map[func_name] then
			if not self._update_func_count then
				self._update_func_count = 0
				self._unit:set_extension_update_enabled(ids_damage, true)
			end

			self._update_func_count = self._update_func_count + 1
		end

		self._update_func_map[func_name] = data
	elseif self._update_func_map and self._update_func_map[func_name] then
		self._update_func_count = self._update_func_count - 1
		self._update_func_map[func_name] = nil
		if self._update_func_count == 0 then
			self._unit:set_extension_update_enabled(ids_damage, false)
			self._update_func_map = nil
			self._update_func_count = nil
		end

	end

end

function CoreUnitDamage:populate_proximity_range_data(data, sub_data_name, element)
	if element then
		data[sub_data_name] = {}
		data[sub_data_name].element = element
		data[sub_data_name].activation_count = 0
		data[sub_data_name].max_activation_count = element:get_max_activation_count()
		data[sub_data_name].delay = element:get_delay()
		data[sub_data_name].last_check_time = TimerManager:game():time() + math.rand(math.min(data[sub_data_name].delay, 0))
		data[sub_data_name].range = element:get_range()
		data[sub_data_name].count = element:get_count()
		data[sub_data_name].is_within = sub_data_name == "within_data"
	end

end

function CoreUnitDamage:set_proximity_enabled(name, enabled)
	local data = self._proximity_map and self._proximity_map[name]
	if data and not data.enabled ~= not enabled then
		data.enabled = enabled
		if enabled then
			if not self._proximity_enabled_count then
				self:set_update_callback("update_proximity_list", true)
				self._proximity_enabled_count = 0
			end

			self._proximity_enabled_count = self._proximity_enabled_count + 1
		else
			self._proximity_enabled_count = self._proximity_enabled_count - 1
			if self._proximity_enabled_count <= 0 then
				self._proximity_enabled_count = nil
				self:set_update_callback("update_proximity_list", nil)
			end

		end

	end

end

function CoreUnitDamage:update_proximity_list(unit, t, dt)
	if managers.sequence:is_proximity_enabled() then
		local (for generator), (for state), (for control) = pairs(self._proximity_map)
		do
			do break end
			if data.enabled and t >= data.last_check_time + data.interval then
				local range_data, reversed, range_data_string
				if data.is_within then
					range_data = data.outside_data
					range_data_string = "outside_data"
					if not range_data then
						range_data = data.within_data
						range_data_string = "within_data"
						reversed = true
					else
						reversed = false
					end

				else
					range_data = data.within_data
					range_data_string = "within_data"
					if not range_data then
						range_data = data.outside_data
						range_data_string = "outside_data"
						reversed = true
					else
						reversed = false
					end

				end

				data.last_check_time = t
				if self:check_proximity_activation_count(data) and t >= range_data.last_check_time + range_data.delay and self:update_proximity(unit, t, dt, data, range_data) ~= reversed then
					range_data.last_check_time = t
					data.is_within = not data.is_within
					if not reversed and self:is_proximity_range_active(range_data) then
						range_data.activation_count = range_data.activation_count + 1
						self:_do_proximity_activation(range_data)
						self:_check_send_sync_proximity_activation(name, range_data_string)
						self:check_proximity_activation_count(data)
					end

				end

			end

		end

	end

end

function CoreUnitDamage:_do_proximity_activation(range_data)
	self._proximity_env = self._proximity_env or CoreSequenceManager.SequenceEnvironment:new("proximity", self._unit, self._unit, nil, Vector3(0, 0, 0), Vector3(0, 0, 0), Vector3(0, 0, 0), 0, Vector3(0, 0, 0), nil, self._unit_element)
	range_data.element:activate_elements(self._proximity_env)
end

function CoreUnitDamage:_check_send_sync_proximity_activation(name, range_data_string)
	if not Network:is_server() or self._unit:id() == -1 then
		return
	end

	managers.network:session():send_to_peers_synched("sync_proximity_activation", self._unit, name, range_data_string)
end

function CoreUnitDamage:sync_proximity_activation(name, range_data_string)
	local data = self._proximity_map[name]
	local range_data = data[range_data_string]
	self:_do_proximity_activation(range_data)
end

function CoreUnitDamage:is_proximity_range_active(range_data)
	return range_data and (range_data.max_activation_count < 0 or range_data.activation_count < range_data.max_activation_count)
end

function CoreUnitDamage:check_proximity_activation_count(data)
	if not self:is_proximity_range_active(data.within_data) and not self:is_proximity_range_active(data.outside_data) then
		self:set_proximity_enabled(data.name, false)
		return false
	else
		return true
	end

end

function CoreUnitDamage:update_proximity(unit, t, dt, data, range_data)
	local pos
	if data.ref_object then
		pos = data.ref_object:position()
	else
		pos = self._unit:position()
	end

	local unit_list = {}
	local units = self._unit:find_units_quick("all", data.slotmask)
	do
		local (for generator), (for state), (for control) = ipairs(units)
		do
			do break end
			if mvector3.distance(pos, unit:movement():m_newest_pos()) < range_data.range then
				table.insert(unit_list, unit)
			end

		end

	end

	(for control) = nil and mvector3
	if data.is_within and range_data.is_within ~= data.is_within or not data.is_within and range_data.is_within == data.is_within then
		return #unit_list <= range_data.count
	else
		return #unit_list >= range_data.count
	end

end

function CoreUnitDamage:get_proximity_map()
	return self._proximity_map or {}
end

function CoreUnitDamage:set_proximity_slotmask(name, slotmask)
	self._proximity_map[name].slotmask = slotmask
end

function CoreUnitDamage:set_proximity_ref_obj_name(name, ref_obj_name)
	self._proximity_map[name].ref_object = ref_obj_name and self._unit:get_object(Idstring(ref_obj_name))
end

function CoreUnitDamage:set_proximity_interval(name, interval)
	self._proximity_map[name].interval = interval
end

function CoreUnitDamage:set_proximity_is_within(name, is_within)
	self._proximity_map[name].is_within = is_within
end

function CoreUnitDamage:set_proximity_within_activations(name, activations)
	local data = self._proximity_map[name]
	local within_data = data.within_data
	if within_data then
		within_data.activations = activations
		return self:check_proximity_activation_count(data)
	end

end

function CoreUnitDamage:set_proximity_within_max_activations(name, max_activations)
	local data = self._proximity_map[name]
	local within_data = data.within_data
	if within_data then
		within_data.max_activations = max_activations
		return self:check_proximity_activation_count(data)
	end

end

function CoreUnitDamage:set_proximity_within_delay(name, delay)
	local within_data = self._proximity_map[name].within_data
	if within_data then
		within_data.delay = delay
	end

end

function CoreUnitDamage:set_proximity_within_range(name, range)
	local within_data = self._proximity_map[name].within_data
	if within_data then
		within_data.range = range
	end

end

function CoreUnitDamage:set_proximity_inside_count(name, count)
	local within_data = self._proximity_map[name].within_data
	if within_data then
		within_data.count = count
	end

end

function CoreUnitDamage:set_proximity_outside_activations(name, activations)
	local data = self._proximity_map[name]
	local outside_data = data.outside_data
	if outside_data then
		outside_data.activations = activations
		return self:check_proximity_activation_count(data)
	end

end

function CoreUnitDamage:set_proximity_outside_max_activations(name, max_activations)
	local data = self._proximity_map[name]
	local outside_data = data.outside_data
	if outside_data then
		outside_data.max_activations = max_activations
		return self:check_proximity_activation_count(data)
	end

end

function CoreUnitDamage:set_proximity_outside_delay(name, delay)
	local outside_data = self._proximity_map[name].outside_data
	if outside_data then
		outside_data.delay = delay
	end

end

function CoreUnitDamage:set_proximity_outside_range(name, range)
	local outside_data = self._proximity_map[name].outside_data
	if outside_data then
		outside_data.range = range
	end

end

function CoreUnitDamage:set_proximity_outside_range(name, range)
	local outside_data = self._proximity_map[name].outside_data
	if outside_data then
		outside_data.range = count
	end

end

function CoreUnitDamage:get_water_check_map()
	return self._water_check_map
end

function CoreUnitDamage:set_water_check(name, enabled, interval, ref_object_name, ref_body_name, body_depth, physic_effect)
	self._water_check_map = self._water_check_map or {}
	local water_check = self._water_check_map[name]
	local ref_object = ref_object_name and self._unit:get_object(Idstring(ref_object_name))
	local ref_body = ref_body_name and self._unit:body(ref_body_name)
	if not water_check then
		water_check = CoreDamageWaterCheck:new(self._unit, self, name, interval, ref_object, ref_body, body_depth, physic_effect)
		self._water_check_map[name] = water_check
	else
		water_check:set_interval(interval)
		water_check:set_body_depth(body_depth)
		if ref_object then
			water_check:set_ref_object(ref_object)
		elseif ref_body then
			water_check:set_ref_body(ref_body)
		end

	end

	self:set_water_check_active(name, enabled)
	if not water_check:is_valid() then
		Application:error("Invalid water check \"" .. tostring(name) .. "\" in unit \"" .. tostring(self._unit:name()) .. "\". Neither ref_body nor ref_object is speicified in it.")
		self:remove_water_check(name)
	end

end

function CoreUnitDamage:remove_water_check(name)
	if self._water_check_map then
		local water_check = self._water_check_map[name]
		if water_check then
			self:set_water_check_active(name, false)
			self._water_check_map[name] = nil
		end

	end

end

function CoreUnitDamage:exists_water_check(name)
	return self._water_check_map and self._water_check_map[name] ~= nil
end

function CoreUnitDamage:is_water_check_active(name)
	return self._active_water_check_map and self._active_water_check_map[name] ~= nil
end

function CoreUnitDamage:set_water_check_active(name, active)
	local water_check = self._water_check_map and self._water_check_map[name]
	if water_check then
		if active then
			if not self._active_water_check_map or not self._active_water_check_map[name] then
				self._active_water_check_map = self._active_water_check_map or {}
				self._active_water_check_map[name] = water_check
				self._active_water_check_count = (self._active_water_check_count or 0) + 1
				if self._active_water_check_count == 1 then
					self._water_check_func_id = managers.sequence:add_callback(callback(self, self, "update_water_checks"))
				end

			end

		else
			water_check:set_activation_callbacks_enabled(false)
			if self._active_water_check_map and self._active_water_check_map[name] then
				self._active_water_check_map[name] = nil
				self._active_water_check_count = self._active_water_check_count - 1
				if self._active_water_check_count == 0 then
					managers.sequence:remove_callback(self._water_check_func_id)
					self._water_check_func_id = nil
					self._active_water_check_map = nil
					self._active_water_check_count = nil
				end

			end

		end

	end

end

function CoreUnitDamage:update_water_checks(t, dt)
	local (for generator), (for state), (for control) = pairs(self._active_water_check_map)
	do
		do break end
		water_check:update(t, dt)
	end

end

function CoreUnitDamage:water_check_enter(name, water_check, src_unit, body, normal, position, direction, damage, velocity, water_depth)
	local element = self._water_check_element_map[name]
	if element then
		local env = CoreSequenceManager.SequenceEnvironment:new("water", src_unit, self._unit, body, normal, position, direction, damage, velocity, {water_depth = water_depth}, self._unit_element)
		element:activate_enter(env)
	end

end

function CoreUnitDamage:water_check_exit(name, water_check, src_unit, body, normal, position, direction, damage, velocity, water_depth)
	local element = self._water_check_element_map[name]
	if element then
		local env = CoreSequenceManager.SequenceEnvironment:new("water", src_unit, self._unit, body, normal, position, direction, damage, velocity, {water_depth = water_depth}, self._unit_element)
		element:activate_exit(env)
	end

end

function CoreUnitDamage:save(data)
-- fail 142
null
16
-- fail 97
null
11
	local state = {}
	local changed = false
	if self._runned_sequences then
		local (for generator), (for state), (for control) = pairs(self._runned_sequences)
		do
			do break end
			state.runned_sequences = table.map_copy(self._runned_sequences)
			changed = true
			break
		end

	end

	(for control) = nil and table
	if self._state then
		local (for generator), (for state), (for control) = pairs(self._state)
		do
			do break end
			state.state = deep_clone(self._state)
			changed = true
			break
		end

	end

	(for control) = nil and deep_clone
	if self._damage ~= 0 then
		state.damage = self._damage
		changed = true
	end

	if self._variables then
		local (for generator), (for state), (for control) = pairs(self._variables)
		do
			do break end
			if (self._unit_element._set_variables == nil or self._unit_element._set_variables[k] ~= v) and (k ~= "damage" or v ~= self._damage) then
				state.variables = table.map_copy(self._variables)
				changed = true
		end

		else
		end

	end

	(for control) = nil and self._unit_element
	if self._proximity_count then
		changed = true
		state.proximity_count = self._proximity_count
		state.proximity_enabled_count = self._proximity_enabled_count
		local (for generator), (for state), (for control) = pairs(self._proximity_map or {})
		do
			do break end
			state.proximity_map = state.proximity_map or {}
			state.proximity_map[name] = {}
			local (for generator), (for state), (for control) = pairs(data)
			do
				do break end
				if attribute_name == "ref_object" then
					state.proximity_map[name][attribute_name] = attribute_value and attribute_value:name()
				elseif attribute_name == "slotmask" then
					state.proximity_map[name][attribute_name] = managers.slot:get_mask_name(attribute_value)
				elseif attribute_name == "last_check_time" then
					state.proximity_map[name][attribute_name] = TimerManager:game():time() - attribute_value
				elseif attribute_name == "within_data" or attribute_name == "outside_data" then
					state.proximity_map[name][attribute_name] = {}
					local (for generator), (for state), (for control) = pairs(attribute_value)
					do
						do break end
						if range_attribute_name ~= "element" then
							state.proximity_map[name][attribute_name][range_attribute_name] = range_attribute_value
						end

					end

				else
					state.proximity_map[name][attribute_name] = attribute_value
				end

			end

		end

	end

	(for control) = nil and state.proximity_map
	do
		local (for generator), (for state), (for control) = ipairs(self._unit:anim_groups())
		do
			do break end
			state.anim = state.anim or {}
			local anim_time = self._unit:anim_time(anim_name)
			table.insert(state.anim, {name = anim_name, time = anim_time})
			changed = true
		end

	end

	(for control) = self._unit:anim_groups() and state.anim
	if not self._skip_save_anim_state_machine then
		local state_machine = self._unit:anim_state_machine()
		if state_machine then
			state.state_machine = state.state_machine or {}
			local (for generator), (for state), (for control) = ipairs(state_machine:config():segments())
			do
				do break end
				local anim_state = state_machine:segment_state(segment)
				if anim_state ~= Idstring("") then
					local anim_time = state_machine:segment_real_time(segment)
					table.insert(state.state_machine, {anim_state = anim_state, anim_time = anim_time})
				end

			end

		end

	end

	(for control) = state_machine:config():segments() and state_machine.segment_state
	changed = self._unit_element:save_by_unit(self._unit, state) or changed
	if changed then
		data.CoreUnitDamage = state
	end

end

function CoreUnitDamage:get_unit_element()
	return self._unit_element
end

function CoreUnitDamage:load(data)
-- fail 127
null
15
-- fail 84
null
10
	local state = data.CoreUnitDamage
	if self._unit:name() == Idstring("units/payday2/vehicles/air_vehicle_blackhawk/helicopter_cops_ref") then
		print("[CoreUnitDamage:load]", self._unit)
	end

	if self._startup_sequence_callback_id then
		managers.sequence:remove_time_callback(self._startup_sequence_callback_id)
		self:run_startup_sequences()
	end

	if self._editor_startup_sequence_callback_id then
		managers.sequence:remove_time_callback(self._editor_startup_sequence_callback_id)
		self:run_editor_startup_sequences()
	end

	if state then
		if state.runned_sequences then
			self._runned_sequences = table.map_copy(state.runned_sequences)
		end

		if state.state then
			self._state = deep_clone(state.state)
		end

		self._damage = state.damage or self._damage
		if state.variables then
			self._variables = table.map_copy(state.variables)
		end

		if state.proximity_map then
			self._proximity_count = state.proximity_count
			self._proximity_enabled_count = state.proximity_enabled_count
			do
				local (for generator), (for state), (for control) = pairs(state.proximity_map)
				do
					do break end
					self._proximity_map = self._proximity_map or {}
					local (for generator), (for state), (for control) = pairs(data)
					do
						do break end
						if attribute_name == "ref_object" then
							self._proximity_map[name][attribute_name] = attribute_value and self._unit:get_object(attribute_value)
						elseif attribute_name == "slotmask" then
							self._proximity_map[name][attribute_name] = managers.slot:get_mask(attribute_value)
						elseif attribute_name == "last_check_time" then
							self._proximity_map[name][attribute_name] = TimerManager:game():time() - attribute_value
						elseif attribute_name == "within_data" or attribute_name == "outside_data" then
							local (for generator), (for state), (for control) = pairs(attribute_value)
							do
								do break end
								if range_attribute_name ~= "last_check_time" then
									self._proximity_map[name][attribute_name][range_attribute_name] = range_attribute_value
								end

							end

						else
							self._proximity_map[name][attribute_name] = attribute_value
						end

					end

				end

			end

			(for control) = nil and self._proximity_map
			if self._proximity_enabled_count then
				self:set_update_callback("update_proximity_list", true)
			end

		end

		if state.anim then
			local (for generator), (for state), (for control) = ipairs(state.anim)
			do
				do break end
				self._unit:anim_set_time(anim_data.name, anim_data.time)
			end

		end

		(for control) = true and self._unit
		if state.state_machine then
			local (for generator), (for state), (for control) = ipairs(state.state_machine)
			do
				do break end
				self._unit:play_state(anim_data.anim_state, anim_data.anim_time)
			end

		end

		(for control) = true and self._unit
		if self._state then
			local (for generator), (for state), (for control) = pairs(self._state)
			do
				do break end
				managers.sequence:load_element_data(self._unit, element_name, data)
			end

		end

		(for control) = true and managers
		self._unit_element:load_by_unit(self._unit, state)
	end

	managers.worlddefinition:use_me(self._unit)
	managers.worlddefinition:external_set_only_visible_in_editor(self._unit)
end

function CoreUnitDamage:run_startup_sequences()
	local nil_vector = Vector3(0, 0, 0)
	self._startup_sequence_callback_id = nil
	local (for generator), (for state), (for control) = pairs(self._startup_sequence_map)
	do
		do break end
		if alive(self._unit) then
			managers.sequence:run_sequence(name, "startup", self._unit, self._unit, nil, nil_vector, nil_vector, nil_vector, 0, nil_vector)
			do break end
			break
		end

	end

end

function CoreUnitDamage:run_editor_startup_sequences()
	local nil_vector = Vector3(0, 0, 0)
	self._editor_startup_sequence_callback_id = nil
	local (for generator), (for state), (for control) = pairs(self._editor_startup_sequence_map)
	do
		do break end
		if alive(self._unit) then
			managers.sequence:run_sequence(name, "editor_startup", self._unit, self._unit, nil, nil_vector, nil_vector, nil_vector, 0, nil_vector)
			do break end
			break
		end

	end

end

function CoreUnitDamage:remove_trigger_func(trigger_name, id, is_editor)
	if self:verify_trigger_name(trigger_name) then
		self._trigger_func_list[trigger_name][id] = nil
		if is_editor then
			local (for generator), (for state), (for control) = ipairs(self._editor_trigger_data)
			do
				do break end
				if data.id == id then
					table.remove(self._editor_trigger_data, index)
			end

			else
			end

		end

	end

end

function CoreUnitDamage:clear_trigger_func_list(trigger_name, is_editor)
	if trigger_name and self._trigger_func_list then
		self._trigger_func_list[trigger_name] = {}
		if self._editor_trigger_data then
			for i = #self._editor_trigger_data, 1 do
				local data = self._editor_trigger_data[i]
				if data.trigger_name == trigger_name then
					table.remove(self._editor_trigger_data, i)
				end

			end

		end

	else
		self._editor_trigger_data = nil
	end

end

function CoreUnitDamage:add_trigger_sequence(trigger_name, notify_unit_sequence, notify_unit, time, repeat_nr, params, is_editor)
	self._last_trigger_id = (self._last_trigger_id or 0) + 1
	return self:set_trigger_sequence(self._last_trigger_id, trigger_name, notify_unit_sequence, notify_unit, time, repeat_nr, params, is_editor)
end

function CoreUnitDamage:set_trigger_sequence_name(id, trigger_name, notify_unit_sequence)
	if self._trigger_func_list and self._trigger_func_list[trigger_name][id] then
		local (for generator), (for state), (for control) = ipairs(self._editor_trigger_data)
		do
			do break end
			if data.id == id then
				return self:set_trigger_sequence(id, trigger_name, notify_unit_sequence, data.notify_unit, data.time, data.repeat_nr, data.params, true)
			end

		end

	end

	(for control) = nil and data.id
end

function CoreUnitDamage:set_trigger_sequence_unit(id, trigger_name, notify_unit)
	if self._trigger_func_list and self._trigger_func_list[trigger_name][id] then
		local (for generator), (for state), (for control) = ipairs(self._editor_trigger_data)
		do
			do break end
			if data.id == id then
				return self:set_trigger_sequence(id, trigger_name, data.notify_unit_sequence, notify_unit, data.time, data.repeat_nr, data.params, true)
			end

		end

	end

	(for control) = nil and data.id
end

function CoreUnitDamage:set_trigger_sequence_time(id, trigger_name, time)
	if self._trigger_func_list and self._trigger_func_list[trigger_name][id] then
		local (for generator), (for state), (for control) = ipairs(self._editor_trigger_data)
		do
			do break end
			if data.id == id then
				return self:set_trigger_sequence(id, trigger_name, data.notify_unit_sequence, data.notify_unit, time, data.repeat_nr, data.params, true)
			end

		end

	end

	(for control) = nil and data.id
end

function CoreUnitDamage:set_trigger_sequence_repeat_nr(id, trigger_name, repeat_nr)
	if self._trigger_func_list and self._trigger_func_list[trigger_name][id] then
		local (for generator), (for state), (for control) = ipairs(self._editor_trigger_data)
		do
			do break end
			if data.id == id then
				return self:set_trigger_sequence(id, trigger_name, data.notify_unit_sequence, data.notify_unit, data.time, repeat_nr, data.params, true)
			end

		end

	end

	(for control) = nil and data.id
end

function CoreUnitDamage:set_trigger_sequence_params(id, trigger_name, params)
	if self._trigger_func_list and self._trigger_func_list[trigger_name][id] then
		local (for generator), (for state), (for control) = ipairs(self._editor_trigger_data)
		do
			do break end
			if data.id == id then
				return self:set_trigger_sequence(id, trigger_name, data.notify_unit_sequence, data.notify_unit, data.time, data.repeat_nr, params, true)
			end

		end

	end

	(for control) = nil and data.id
end

function CoreUnitDamage:set_trigger_sequence(id, trigger_name, notify_unit_sequence, notify_unit, time, repeat_nr, params, is_editor)
	local function func(params2)
		if params2 then
			if params and getmetatable(params2) ~= CoreSequenceManager.SequenceEnvironment then
				if getmetatable(params) == CoreSequenceManager.SequenceEnvironment then
					local (for generator), (for state), (for control) = pairs(params2)
					do
						do break end
						params.params[k] = v
					end

				else
					(for control) = nil and params
					local (for generator), (for state), (for control) = pairs(params2)
					do
						do break end
						params[k] = v
					end

				end

			else
				params = nil and params2
			end

		end

		if getmetatable(params) == CoreSequenceManager.SequenceEnvironment then
			managers.sequence:run_sequence(notify_unit_sequence, "trigger", self._unit, notify_unit, nil, params.dest_normal, params.pos, params.dir, params.damage, params.velocity, params.params)
		else
			managers.sequence:run_sequence_simple3(notify_unit_sequence, "trigger", self._unit, notify_unit, params)
		end

	end

	if is_editor then
		local data
		self._editor_trigger_data = self._editor_trigger_data or {}
		if self._trigger_func_list and self._trigger_func_list[trigger_name] and self._trigger_func_list[trigger_name][id] then
			local (for generator), (for state), (for control) = ipairs(self._editor_trigger_data)
			do
				do break end
				if data2.id == id then
					data = data2
			end

			else
			end

		end

		do break end
		data = {}
		table.insert(self._editor_trigger_data, data)
		data.id = id
		data.trigger_name = trigger_name
		data.notify_unit_sequence = notify_unit_sequence
		data.notify_unit = notify_unit
		data.time = time
		data.repeat_nr = repeat_nr
		data.params = params
	end

	return self:set_trigger_func(id, trigger_name, func, time, repeat_nr, is_editor)
end

function CoreUnitDamage:get_editor_trigger_data()
	if self._editor_trigger_data then
		for i = #self._editor_trigger_data, 1, -1 do
			local data = self._editor_trigger_data[i]
			if not alive(data.notify_unit) then
				self:remove_trigger_func(data.trigger_name, data.id, true)
			end

		end

	end

	return self._editor_trigger_data
end

function CoreUnitDamage:add_trigger_func(trigger_name, func, time, repeat_nr, is_editor)
	self._last_trigger_id = (self._last_trigger_id or 0) + 1
	return self:set_trigger_func(self._last_trigger_id, trigger_name, func, time, repeat_nr, is_editor)
end

function CoreUnitDamage:set_trigger_func(id, trigger_name, func, time, repeat_nr, is_editor)
	if self:verify_trigger_name(trigger_name) then
		local trigger_func
		if time then
			function trigger_func(params2)
				managers.sequence:add_time_callback(func, time, repeat_nr, params2)
			end

		elseif repeat_nr and repeat_nr > 1 then
			function trigger_func(params2)
				for i = 1, repeat_nr do
					func(params2)
				end

			end

		else
			trigger_func = func
		end

		self._trigger_func_list[trigger_name][id] = trigger_func
		return id
	end

	return nil
end

function CoreUnitDamage:activate_trigger(trigger_name, params2)
	if self:verify_trigger_name(trigger_name) then
		local (for generator), (for state), (for control) = pairs(self._trigger_func_list[trigger_name])
		do
			do break end
			func(params2)
		end

	end

end

function CoreUnitDamage:verify_trigger_name(trigger_name)
	if trigger_name and self._trigger_func_list and self._trigger_func_list[trigger_name] then
		return true
	else
		Application:error("Trigger \"" .. tostring(trigger_name) .. "\" doesn't exist. Only the following triggers are available: " .. managers.sequence:get_keys_as_string(self._unit_element:get_trigger_name_map(), "[None]", true))
		return false
	end

end

function CoreUnitDamage:inflict_damage(damage_type, src_body, source_body, normal, position, direction, velocity)
	local damage
	local body_ext = source_body:extension()
	local damage_ext
	if body_ext then
		damage_ext = body_ext.damage
		if damage_ext then
			return damage_ext:inflict_damage(damage_type, self._unit, src_body, normal, position, direction)
		end

	end

	return nil, false
end

function CoreUnitDamage:damage_damage(attack_unit, dest_body, normal, position, direction, damage, unevadable)
	return self:add_damage("damage", attack_unit, dest_body, normal, position, direction, damage, Vector3(0, 0, 0), unevadable)
end

function CoreUnitDamage:damage_bullet(attack_unit, dest_body, normal, position, direction, damage, unevadable)
	return self:add_damage("bullet", attack_unit, dest_body, normal, position, direction, damage, Vector3(0, 0, 0), unevadable)
end

function CoreUnitDamage:damage_lock(attack_unit, dest_body, normal, position, direction, damage, unevadable)
	return self:add_damage("lock", attack_unit, dest_body, normal, position, direction, damage, Vector3(0, 0, 0), unevadable)
end

function CoreUnitDamage:damage_explosion(attack_unit, dest_body, normal, position, direction, damage)
	return self:add_damage("explosion", attack_unit, dest_body, normal, position, direction, damage, Vector3(0, 0, 0))
end

function CoreUnitDamage:damage_collision(attack_unit, dest_body, normal, position, direction, damage, velocity)
	return self:add_damage("collision", attack_unit, dest_body, normal, position, direction, damage, velocity)
end

function CoreUnitDamage:damage_melee(attack_unit, dest_body, normal, position, direction, damage)
	return self:add_damage("melee", attack_unit, dest_body, normal, position, direction, damage, Vector3(0, 0, 0))
end

function CoreUnitDamage:damage_electricity(attack_unit, dest_body, normal, position, direction, damage)
	return self:add_damage("electricity", attack_unit, dest_body, normal, position, direction, damage, Vector3(0, 0, 0))
end

function CoreUnitDamage:damage_fire(attack_unit, dest_body, normal, position, direction, damage, velocity)
	return self:add_damage("fire", attack_unit, dest_body, normal, position, direction, damage, velocity)
end

function CoreUnitDamage:damage_by_area(endurance_type, attack_unit, dest_body, normal, position, direction, damage, velocity)
	local damage_func = self["damage_" .. endurance_type]
	if damage_func then
		return damage_func(self, attack_unit, dest_body, normal, position, direction, damage, velocity)
	else
		Application:error("Unit \"" .. tostring(self._unit:name()) .. "\" doesn't have a \"damage_" .. tostring(endurance_type) .. "\"-function on its unit damage extension.")
		return false, nil
	end

end

function CoreUnitDamage:add_damage(endurance_type, attack_unit, dest_body, normal, position, direction, damage, velocity)
	if self._unit_element then
		self._damage = self._damage + damage
		if self._damage >= self._unit_element:get_endurance() then
			return true, damage
		else
			return false, damage
		end

	else
		return false, 0
	end

end

function CoreUnitDamage:damage_effect(effect_type, attack_unit, dest_body, normal, position, direction, velocity, params)
end

function CoreUnitDamage:run_sequence_simple(name, params)
	self:run_sequence_simple2(name, "", params)
end

function CoreUnitDamage:run_sequence_simple2(name, endurance_type, params)
	self:run_sequence_simple3(name, endurance_type, self._unit, params)
end

function CoreUnitDamage:run_sequence_simple3(name, endurance_type, source_unit, params)
	self:run_sequence(name, endurance_type, source_unit, nil, Vector3(0, 0, 1), self._unit:position(), Vector3(0, 0, -1), 0, Vector3(0, 0, 0), params)
end

function CoreUnitDamage:run_sequence(name, endurance_type, source_unit, dest_body, normal, position, direction, damage, velocity, params)
	self._unit_element:run_sequence(name, endurance_type, source_unit, self._unit, dest_body, normal, position, direction, damage, velocity, params)
end

function CoreUnitDamage:get_damage()
	return self._damage
end

function CoreUnitDamage:get_endurance()
	if self._unit_element then
		return self._unit_element:get_endurance()
	else
		return 0
	end

end

function CoreUnitDamage:get_damage_ratio()
	if self._unit_element and self._unit_element:get_endurance() > 0 then
		return self._damage / self._unit_element:get_endurance()
	else
		return 0
	end

end

function CoreUnitDamage:update_inflict_damage(t, dt)
