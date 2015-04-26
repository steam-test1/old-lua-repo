VehicleStateDriving = VehicleStateDriving or class(BaseVehicleState)
function VehicleStateDriving:init(unit)
	BaseVehicleState.init(self, unit)
end

function VehicleStateDriving:enter(state_data, enter_data)
	self._unit:vehicle_driving():_start_engine_sound()
	self._unit:interaction():set_override_timer_value(VehicleDrivingExt.TIME_ENTER)
	self:adjust_interactions()
end

function VehicleStateDriving:adjust_interactions()
	VehicleStateDriving.super.adjust_interactions(self)
	if self._unit:vehicle_driving():is_interaction_allowed() and self._unit:damage() and self._unit:damage():has_sequence(VehicleDrivingExt.INTERACT_ENTRY_ENABLED) then
		self._unit:damage():run_sequence_simple(VehicleDrivingExt.INTERACT_INTERACTION_ENABLED)
		self._unit:damage():run_sequence_simple(VehicleDrivingExt.INTERACT_ENTRY_ENABLED)
		self._unit:damage():run_sequence_simple(VehicleDrivingExt.INTERACT_LOOT_ENABLED)
		self._unit:damage():run_sequence_simple(VehicleDrivingExt.INTERACT_REPAIR_DISABLED)
		self._unit:vehicle_driving()._interaction_enter_vehicle = true
		self._unit:vehicle_driving()._interaction_loot = true
		self._unit:vehicle_driving()._interaction_repair = false
	end
end

function VehicleStateDriving:is_vulnerable()
	return true
end

