BaseVehicleState = BaseVehicleState or class()
function BaseVehicleState:init(unit)
	self._unit = unit
end

function BaseVehicleState:update(t, dt)
	self._unit:vehicle_driving():_wake_nearby_dynamics()
	self._unit:vehicle_driving():_detect_npc_collisions()
	self._unit:vehicle_driving():_detect_collisions(t, dt)
	self._unit:vehicle_driving():_detect_invalid_possition(t, dt)
	self._unit:vehicle_driving():_play_sound_events(t, dt)
	self._unit:vehicle_driving():_move_team_ai()
end

function BaseVehicleState:enter(state_data, enter_data)
end

function BaseVehicleState:exit(state_data)
end

function BaseVehicleState:get_action_for_interaction(pos)
	local action = VehicleDrivingExt.INTERACT_INVALID
	local seat, seat_distance = self._unit:vehicle_driving():get_available_seat(pos)
	local loot_point, loot_point_distance = self._unit:vehicle_driving():get_nearest_loot_point(pos)
	if seat and loot_point then
		if seat_distance >= loot_point_distance and not managers.player:is_carrying() then
			action = VehicleDrivingExt.INTERACT_LOOT
		else
			action = VehicleDrivingExt.INTERACT_ENTER
		end
	elseif seat then
		action = VehicleDrivingExt.INTERACT_ENTER
	elseif loot_point and not managers.player:is_carrying() then
		action = VehicleDrivingExt.INTERACT_LOOT
	end
	if action == VehicleDrivingExt.INTERACT_ENTER and seat.driving then
		action = VehicleDrivingExt.INTERACT_DRIVE
	end
	return action
end

function BaseVehicleState:adjust_interactions()
	if not self._unit:vehicle_driving():is_interaction_allowed() then
		self:disable_interactions()
	end
end

function BaseVehicleState:disable_interactions()
	if self._unit:damage() and self._unit:damage():has_sequence(VehicleDrivingExt.INTERACT_ENTRY_ENABLED) then
		self._unit:damage():run_sequence_simple(VehicleDrivingExt.INTERACT_ENTRY_DISABLED)
		self._unit:damage():run_sequence_simple(VehicleDrivingExt.INTERACT_LOOT_DISABLED)
		self._unit:damage():run_sequence_simple(VehicleDrivingExt.INTERACT_REPAIR_DISABLED)
		self._unit:damage():run_sequence_simple(VehicleDrivingExt.INTERACT_INTERACTION_DISABLED)
		self._unit:vehicle_driving()._interaction_enter_vehicle = false
		self._unit:vehicle_driving()._interaction_loot = false
		self._unit:vehicle_driving()._interaction_repair = false
	end
end

function BaseVehicleState:allow_exit()
	return true
end

function BaseVehicleState:is_vulnerable()
	return false
end

function BaseVehicleState:stop_vehicle()
	return false
end

