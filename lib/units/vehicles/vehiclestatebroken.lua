VehicleStateBroken = VehicleStateBroken or class(BaseVehicleState)
function VehicleStateBroken:init(unit)
	BaseVehicleState.init(self, unit)
end

function VehicleStateBroken:enter(state_data, enter_data)
	self._unit:vehicle_driving():_stop_engine_sound()
	self._unit:interaction():set_override_timer_value(VehicleDrivingExt.TIME_REPAIR)
	self:adjust_interactions()
	self._unit:vehicle_driving():set_input(0, 0, 1, 1, false, false, 2)
	local player_vehicle = managers.player:get_vehicle()
	Application:debug(player_vehicle, ":", self._unit)
	if player_vehicle and player_vehicle.vehicle_unit == self._unit then
		managers.hud:show_hint({
			text = managers.localization:text("hud_vehicle_broken"),
			time = 4
		})
	end
end

function VehicleStateBroken:adjust_interactions()
	VehicleStateBroken.super.adjust_interactions(self)
	if self._unit:vehicle_driving():is_interaction_allowed() and self._unit:damage() and self._unit:damage():has_sequence(VehicleDrivingExt.INTERACT_ENTRY_ENABLED) then
		self._unit:damage():run_sequence_simple(VehicleDrivingExt.INTERACT_INTERACTION_ENABLED)
		self._unit:damage():run_sequence_simple(VehicleDrivingExt.INTERACT_ENTRY_DISABLED)
		self._unit:damage():run_sequence_simple(VehicleDrivingExt.INTERACT_LOOT_DISABLED)
		self._unit:damage():run_sequence_simple(VehicleDrivingExt.INTERACT_REPAIR_ENABLED)
		self._unit:vehicle_driving()._interaction_enter_vehicle = false
		self._unit:vehicle_driving()._interaction_loot = false
		self._unit:vehicle_driving()._interaction_repair = true
	end
end

function VehicleStateBroken:get_action_for_interaction(pos)
	return VehicleDrivingExt.INTERACT_REPAIR
end

function VehicleStateBroken:stop_vehicle()
	return true
end

