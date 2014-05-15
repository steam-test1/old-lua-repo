MissionDoor = MissionDoor or class(UnitBase)
function MissionDoor:init(unit)
	MissionDoor.super.init(self, unit, false)
	self._unit = unit
	self._devices = {}
	self._powered = true
end

function MissionDoor:update(unit, t, dt)
	if self._explode_t and t > self._explode_t then
		self:_c4_sequence_done()
	end

end

function MissionDoor:activate()
	if Network:is_client() then
		return
	end

	if self._active then
		Application:error("[MissionDoor:activate()] allready active", self._unit)
		return
	end

	self._active = true
	CoreDebug.cat_debug("gaspode", "MissionDoor:activate", self.tweak_data)
	local devices_data = tweak_data.mission_door[self.tweak_data].devices
	local (for generator), (for state), (for control) = pairs(devices_data)
	do
		do break end
		local amount = #device_data
		self._devices[type] = {
			units = {},
			placed = false,
			completed = false,
			amount = amount,
			placed_counter = 0,
			completed_counter = 0
		}
		local (for generator), (for state), (for control) = ipairs(device_data)
		do
			do break end
			local a_obj = self._unit:get_object(Idstring(unit_data.align))
			local position = a_obj:position()
			local rotation = a_obj:rotation()
			local unit = World:spawn_unit(unit_data.unit, position, rotation)
			unit:mission_door_device():set_parent_data(self._unit, type)
			if unit_data.can_jam ~= nil then
				unit:timer_gui():set_can_jam(unit_data.can_jam)
			end

			if unit_data.timer then
				unit:timer_gui():set_override_timer(unit_data.timer)
			end

			MissionDoor.run_mission_door_device_sequence(unit, "activate")
			if managers.network:session() then
				managers.network:session():send_to_peers_synched("run_mission_door_device_sequence", unit, "activate")
			end

			table.insert(self._devices[type].units, {
				unit = unit,
				placed = false,
				completed = false
			})
		end

	end

end

function MissionDoor.run_mission_door_device_sequence(unit, sequence_name)
	if unit:damage():has_sequence(sequence_name) then
		unit:damage():run_sequence_simple(sequence_name)
	end

end

function MissionDoor:deactivate()
	CoreDebug.cat_debug("gaspode", "MissionDoor:deactivate")
	self._active = nil
	self:_destroy_devices()
end

function MissionDoor.set_mission_door_device_powered(unit, powered, enabled_interaction)
	unit:timer_gui():set_powered(powered, enabled_interaction)
end

function MissionDoor:set_powered(powered)
	self._powered = powered
	local drills = self._devices.drill
	if drills then
		local (for generator), (for state), (for control) = ipairs(drills.units)
		do
			do break end
			if unit_data.placed and alive(unit_data.unit) then
				unit_data.unit:timer_gui():set_powered(powered)
				if managers.network:session() then
					managers.network:session():send_to_peers_synched("set_mission_door_device_powered", unit_data.unit, powered, false)
				end

			end

		end

	end

end

function MissionDoor:set_on(state)
	local drills = self._devices.drill
	if drills then
		local (for generator), (for state), (for control) = ipairs(drills.units)
		do
			do break end
			if unit_data.placed and alive(unit_data.unit) then
				unit_data.unit:timer_gui():set_powered(state, true)
				if managers.network:session() then
					managers.network:session():send_to_peers_synched("set_mission_door_device_powered", unit_data.unit, state, true)
				end

			end

		end

	end

end

function MissionDoor:_get_device_unit_data(unit, type)
	local (for generator), (for state), (for control) = ipairs(self._devices[type].units)
	do
		do break end
		if unit_data.unit == unit then
			return unit_data
		end

	end

end

function MissionDoor:device_placed(unit, type)
	local device_unit_data = self:_get_device_unit_data(unit, type)
	if device_unit_data.placed then
		CoreDebug.cat_debug("gaspode", "MissionDoor:device_placed", "Allready placed")
		return
	end

	self._devices[type].placed_counter = self._devices[type].placed_counter + 1
	device_unit_data.placed = true
	self:trigger_sequence(type .. "_placed")
	self:_check_placed_counter(type)
end

function MissionDoor:device_completed(type)
	self._devices[type].completed = true
	self._devices[type].completed_counter = self._devices[type].completed_counter + 1
	self:trigger_sequence(type .. "_completed")
	self:_check_completed_counter(type)
end

function MissionDoor:device_jammed(type)
	self:trigger_sequence(type .. "_jammed")
end

function MissionDoor:device_resumed(type)
	self:trigger_sequence(type .. "_resumed")
end

function MissionDoor:_check_placed_counter(type)
