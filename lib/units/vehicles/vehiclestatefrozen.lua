VehicleStateFrozen = VehicleStateFrozen or class(BaseVehicleState)
function VehicleStateFrozen:init(unit)
	BaseVehicleState.init(self, unit)
end

function VehicleStateFrozen:enter(state_data, enter_data)
	self._unit:vehicle_driving():_stop_engine_sound()
	self._unit:interaction():set_override_timer_value(VehicleDrivingExt.TIME_ENTER)
	self:disable_interactions()
	self._unit:vehicle_driving():set_input(0, 0, 1, 1, false, false, 2)
end

function VehicleStateFrozen:allow_exit()
	return false
end

function VehicleStateFrozen:stop_vehicle()
	return true
end

function VehicleStateFrozen:is_vulnerable()
	return false
end

