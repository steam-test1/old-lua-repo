VehicleDrivingExt = VehicleDrivingExt or class()
VehicleDrivingExt.SEAT_PREFIX = "v_"
VehicleDrivingExt.INTERACTION_PREFIX = "interact_"
VehicleDrivingExt.EXIT_PREFIX = "v_exit_"
VehicleDrivingExt.THIRD_PREFIX = "v_third_"
VehicleDrivingExt.LOOT_PREFIX = "v_"
VehicleDrivingExt.INTERACT_INVALID = -1
VehicleDrivingExt.INTERACT_ENTER = 0
VehicleDrivingExt.INTERACT_LOOT = 1
VehicleDrivingExt.INTERACT_REPAIR = 2
VehicleDrivingExt.STATE_INVALID = -1
VehicleDrivingExt.STATE_INACTIVE = 0
VehicleDrivingExt.STATE_PARKED = 1
VehicleDrivingExt.STATE_DRIVING = 2
VehicleDrivingExt.STATE_BROKEN = 3
VehicleDrivingExt.STATE_LOCKED = 4
VehicleDrivingExt.STATE_SECURED = 5
VehicleDrivingExt.TIME_ENTER = 1
VehicleDrivingExt.TIME_REPAIR = 10
VehicleDrivingExt._state = VehicleDrivingExt.STATE_INACTIVE
VehicleDrivingExt.INTERACT_ENTRY_ENABLED = "state_vis_icon_entry_enabled"
VehicleDrivingExt.INTERACT_ENTRY_DISABLED = "state_vis_icon_entry_disabled"
VehicleDrivingExt.INTERACT_LOOT_ENABLED = "state_vis_icon_loot_enabled"
VehicleDrivingExt.INTERACT_LOOT_DISABLED = "state_vis_icon_loot_disabled"
VehicleDrivingExt.INTERACT_REPAIR_ENABLED = "state_vis_icon_repair_enabled"
VehicleDrivingExt.INTERACT_REPAIR_DISABLED = "state_vis_icon_repair_disabled"
VehicleDrivingExt.INTERACT_INTERACTION_ENABLED = "state_interaction_enabled"
VehicleDrivingExt.INTERACT_INTERACTION_DISABLED = "state_interaction_disabled"
function VehicleDrivingExt:init(unit)
	self._unit = unit
	self._unit:set_extension_update_enabled(Idstring("vehicle_driving"), true)
	self._vehicle = self._unit:vehicle()
	if self._vehicle == nil then
		print("[DRIVING] unit doesn't contain a vehicle")
	end
	self._vehicle_view = self._unit:get_object(Idstring("v_driver"))
	if self._vehicle_view == nil then
		print("[DRIVING] vehicle doesn't contain driver view point")
	end
	self._drop_time_delay = nil
	self._last_synced_position = Vector3(0, 0, 0)
	self._pos_reservation_id = nil
	self._pos_reservation = nil
	self.inertia_modifier = self.inertia_modifier or 1
	self._old_speed = Vector3(0, 0, 0)
	managers.vehicle:add_vehicle(self._unit)
	self._unit:set_body_collision_callback(callback(self, self, "collision_callback"))
	self:set_tweak_data(tweak_data.vehicle[self.tweak_data])
	self:set_state(VehicleDrivingExt.STATE_INACTIVE)
	self._unit:damage():run_sequence_simple(VehicleDrivingExt.INTERACT_LOOT_DISABLED)
	self._playing_slip_sound_dt = 0
	self._playing_engine_sound = false
	self._hit_soundsource = SoundDevice:create_source("vehicle_hit")
	self._slip_soundsource = SoundDevice:create_source("vehicle_slip")
	self._slip_soundsource:link(self._unit:get_object(Idstring("anim_tire_front_left")))
	self._bump_soundsource = SoundDevice:create_source("vehicle_bump")
	self._bump_soundsource:link(self._unit:get_object(Idstring("anim_tire_front_left")))
	self._door_soundsource = SoundDevice:create_source("vehicle_door")
	self._door_soundsource:link(self._unit:get_object(Idstring("v_driver")))
	self._engine_soundsource = nil
	local snd_engine = self._unit:get_object(Idstring("snd_engine"))
	if snd_engine then
		self._engine_soundsource = SoundDevice:create_source("vehicle_engine")
		self._engine_soundsource:link(snd_engine)
	end
	self._wheel_jounce = {}
end

function VehicleDrivingExt:set_tweak_data(data)
	self._tweak_data = data
	self._seats = deep_clone(self._tweak_data.seats)
	self._loot_points = deep_clone(self._tweak_data.loot_points)
	for _, seat in pairs(self._seats) do
		seat.occupant = nil
		seat.object = self._unit:get_object(Idstring(VehicleDrivingExt.SEAT_PREFIX .. seat.name))
		seat.third_object = self._unit:get_object(Idstring(VehicleDrivingExt.THIRD_PREFIX .. seat.name))
		seat.SO_object = self._unit:get_object(Idstring(VehicleDrivingExt.EXIT_PREFIX .. seat.name))
	end
	for _, loot_point in pairs(self._loot_points) do
		loot_point.object = self._unit:get_object(Idstring(VehicleDrivingExt.LOOT_PREFIX .. loot_point.name))
	end
	if self._unit:character_damage() then
		self._unit:character_damage():set_tweak_data(data)
	end
	self._last_drop_position = self._unit:get_object(Idstring(self._tweak_data.loot_drop_point)):position()
end

function VehicleDrivingExt:get_interaction()
	if not self._interaction then
		self._interaction = self._unit:interaction()
	end
	return self._interaction
end

function VehicleDrivingExt:get_view()
	return self._vehicle_view
end

function VehicleDrivingExt:update(unit, t, dt)
	self:_manage_position_reservation()
	if Network:is_server() then
		if self._vehicle:is_active() then
			self:drop_loot()
		end
		self:_catch_loot()
	end
	if self._state ~= VehicleDrivingExt.STATE_INACTIVE then
		self:_wake_nearby_dynamics()
		self:_detect_npc_collisions()
		self:_detect_collisions(t, dt)
		self:_detect_invalid_possition(t, dt)
		self:_play_sound_events(t, dt)
		self:_move_team_ai()
	end
end

function VehicleDrivingExt:_move_team_ai()
	for _, seat in pairs(self._seats) do
		if alive(seat.occupant) and seat.occupant:brain() ~= nil then
			seat.occupant:movement():set_position(seat.occupant:position())
		end
	end
end

function VehicleDrivingExt:_create_position_reservation()
	self._pos_reservation_id = managers.navigation:get_pos_reservation_id()
	if self._pos_reservation_id then
		self._pos_reservation = {
			position = self._unit:position(),
			radius = 500,
			filter = self._pos_reservation_id
		}
		managers.navigation:add_pos_reservation(self._pos_reservation)
	end
end

function VehicleDrivingExt:_manage_position_reservation()
	if not self._pos_reservation_id and managers.navigation and managers.navigation:is_data_ready() then
		self:_create_position_reservation()
		return
	end
	if self._pos_reservation then
		local pos = self._unit:position()
		local distance = mvector3.distance(pos, self._pos_reservation.position)
		if distance > 100 then
			self._pos_reservation.position = pos
			managers.navigation:move_pos_rsrv(self._pos_reservation)
		end
	end
end

function VehicleDrivingExt:get_action_for_interaction(pos)
	local action = VehicleDrivingExt.INTERACT_INVALID
	if self._state == VehicleDrivingExt.STATE_BROKEN then
		action = VehicleDrivingExt.INTERACT_REPAIR
	else
		local seat, seat_distance = self:get_available_seat(pos)
		if seat then
			action = VehicleDrivingExt.INTERACT_ENTER
		end
	end
	return action
end

function VehicleDrivingExt:set_state(state)
	if state == self._state then
		return
	end
	if self._state == VehicleDrivingExt.STATE_SECURED then
		return
	end
	local interaction = self:get_interaction()
	self._state = state
	if state == VehicleDrivingExt.STATE_PARKED then
		self:_start_engine_sound()
		self._interaction:set_override_timer_value(VehicleDrivingExt.TIME_ENTER)
		if self._unit:damage() and self._unit:damage():has_sequence(VehicleDrivingExt.INTERACT_ENTRY_ENABLED) then
			self._unit:damage():run_sequence_simple(VehicleDrivingExt.INTERACT_INTERACTION_ENABLED)
			self._unit:damage():run_sequence_simple(VehicleDrivingExt.INTERACT_ENTRY_ENABLED)
			self._unit:damage():run_sequence_simple(VehicleDrivingExt.INTERACT_LOOT_ENABLED)
			self._unit:damage():run_sequence_simple(VehicleDrivingExt.INTERACT_REPAIR_DISABLED)
		end
		self:set_input(0, 0, 1, 1, false, false, 2)
	elseif state == VehicleDrivingExt.STATE_BROKEN then
		self:_stop_engine_sound()
		self._interaction:set_override_timer_value(VehicleDrivingExt.TIME_REPAIR)
		if self._unit:damage() and self._unit:damage():has_sequence(VehicleDrivingExt.INTERACT_ENTRY_ENABLED) then
			self._unit:damage():run_sequence_simple(VehicleDrivingExt.INTERACT_INTERACTION_ENABLED)
			self._unit:damage():run_sequence_simple(VehicleDrivingExt.INTERACT_ENTRY_DISABLED)
			self._unit:damage():run_sequence_simple(VehicleDrivingExt.INTERACT_LOOT_DISABLED)
			self._unit:damage():run_sequence_simple(VehicleDrivingExt.INTERACT_REPAIR_ENABLED)
		end
		self:set_input(0, 0, 1, 1, false, false, 2)
	elseif state == VehicleDrivingExt.STATE_DRIVING then
		self:_start_engine_sound()
		self._interaction:set_override_timer_value(VehicleDrivingExt.TIME_ENTER)
		if self._unit:damage() and self._unit:damage():has_sequence(VehicleDrivingExt.INTERACT_ENTRY_ENABLED) then
			self._unit:damage():run_sequence_simple(VehicleDrivingExt.INTERACT_INTERACTION_ENABLED)
			self._unit:damage():run_sequence_simple(VehicleDrivingExt.INTERACT_ENTRY_ENABLED)
			self._unit:damage():run_sequence_simple(VehicleDrivingExt.INTERACT_LOOT_ENABLED)
			self._unit:damage():run_sequence_simple(VehicleDrivingExt.INTERACT_REPAIR_DISABLED)
		end
	elseif state == VehicleDrivingExt.STATE_INACTIVE then
		self:_stop_engine_sound()
		self._interaction:set_override_timer_value(VehicleDrivingExt.TIME_ENTER)
		if self._unit:damage() and self._unit:damage():has_sequence(VehicleDrivingExt.INTERACT_ENTRY_ENABLED) then
			self._unit:damage():run_sequence_simple(VehicleDrivingExt.INTERACT_INTERACTION_ENABLED)
			self._unit:damage():run_sequence_simple(VehicleDrivingExt.INTERACT_ENTRY_ENABLED)
			self._unit:damage():run_sequence_simple(VehicleDrivingExt.INTERACT_LOOT_ENABLED)
			self._unit:damage():run_sequence_simple(VehicleDrivingExt.INTERACT_REPAIR_DISABLED)
		end
	elseif state == VehicleDrivingExt.STATE_LOCKED then
		self:_stop_engine_sound()
		self._interaction:set_override_timer_value(VehicleDrivingExt.TIME_ENTER)
		if self._unit:damage() and self._unit:damage():has_sequence(VehicleDrivingExt.INTERACT_ENTRY_ENABLED) then
			self._unit:damage():run_sequence_simple(VehicleDrivingExt.INTERACT_ENTRY_DISABLED)
			self._unit:damage():run_sequence_simple(VehicleDrivingExt.INTERACT_LOOT_DISABLED)
			self._unit:damage():run_sequence_simple(VehicleDrivingExt.INTERACT_REPAIR_DISABLED)
			self._unit:damage():run_sequence_simple(VehicleDrivingExt.INTERACT_INTERACTION_DISABLED)
		end
		self:set_input(0, 0, 1, 1, false, false, 2)
	elseif state == VehicleDrivingExt.STATE_SECURED then
		self:_stop_engine_sound()
		self._interaction:set_override_timer_value(VehicleDrivingExt.TIME_ENTER)
		if self._unit:damage() and self._unit:damage():has_sequence(VehicleDrivingExt.INTERACT_ENTRY_ENABLED) then
			self._unit:damage():run_sequence_simple(VehicleDrivingExt.INTERACT_ENTRY_DISABLED)
			self._unit:damage():run_sequence_simple(VehicleDrivingExt.INTERACT_LOOT_DISABLED)
			self._unit:damage():run_sequence_simple(VehicleDrivingExt.INTERACT_REPAIR_DISABLED)
			self._unit:damage():run_sequence_simple(VehicleDrivingExt.INTERACT_INTERACTION_DISABLED)
		end
		self:set_input(0, 0, 1, 1, false, false, 2)
	else
		self:_stop_engine_sound()
		self._state = VehicleDrivingExt.STATE_PARKED
		Application:error("[VehicleDrivingExt]  set_state - invalid state (" .. self._state .. "), forcing STATE_PARKED")
		self._interaction:set_override_timer_value(VehicleDrivingExt.TIME_ENTER)
	end
	self._unit:damage():run_sequence_simple(VehicleDrivingExt.INTERACT_LOOT_DISABLED)
end

function VehicleDrivingExt:lock()
	self:set_state(VehicleDrivingExt.STATE_LOCKED)
end

function VehicleDrivingExt:unlock()
	if not self._vehicle:is_active() then
		self:set_state(VehicleDrivingExt.STATE_INACTIVE)
	else
		self:set_state(VehicleDrivingExt.STATE_PARKED)
	end
end

function VehicleDrivingExt:secure()
	local carry_ext = self._unit:carry_data()
	if Network:is_server() then
		local silent = false
		local carry_id = carry_ext:carry_id()
		local multiplier = carry_ext:multiplier()
		managers.loot:secure(carry_id, multiplier, silent)
	end
	self:set_state(VehicleDrivingExt.STATE_SECURED)
end

function VehicleDrivingExt:give_loot_to_player(player, peer_id)
	local loot = managers.loot:get_secured_random()
	if loot then
		managers.player:set_carry(loot.carry_id, loot.multiplier, true, false, 1)
		managers.player:register_carry(peer_id, loot.carry_id)
	end
end

function VehicleDrivingExt:drop_loot()
	if not self:_should_drop_loot() then
		return
	end
	local loot = managers.loot:get_secured_random()
	if loot then
		local pos = self._unit:get_object(Idstring(self._tweak_data.loot_drop_point)):position()
		local velocity = self._vehicle:velocity()
		mvector3.normalize(velocity)
		mvector3.multiply(velocity, -300)
		local drop_point = pos + velocity
		Application:debug("dropping loot    " .. inspect(self._unit:position()) .. "      " .. inspect(drop_point))
		local rot = self._unit:rotation()
		local dir = Vector3(0, 0, 0)
		local unit = managers.player:server_drop_carry(loot.carry_id, loot.multiplier, true, false, 1, drop_point, rot, dir, 0, nil, 0)
	end
end

function VehicleDrivingExt:_should_drop_loot()
	return false
end

function VehicleDrivingExt:_store_loot(unit)
	local carry_ext = unit:carry_data()
	carry_ext:disarm()
	if Network:is_server() then
		local silent = false
		local carry_id = carry_ext:carry_id()
		local multiplier = carry_ext:multiplier()
		managers.loot:secure(carry_id, multiplier, silent)
		unit:set_slot(0)
	end
	carry_ext:set_value(0)
	if unit:damage():has_sequence("secured") then
		unit:damage():run_sequence_simple("secured")
	end
end

function VehicleDrivingExt:_loot_filter_func(carry_data)
	local carry_id = carry_data:carry_id()
	if carry_id == "gold" or carry_id == "money" or carry_id == "diamonds" or carry_id == "coke" or carry_id == "weapon" or carry_id == "painting" or carry_id == "circuit" or carry_id == "diamonds" or carry_id == "engine_01" or carry_id == "engine_02" or carry_id == "engine_03" or carry_id == "engine_04" or carry_id == "engine_05" or carry_id == "engine_06" or carry_id == "engine_07" or carry_id == "engine_08" or carry_id == "engine_09" or carry_id == "engine_10" or carry_id == "engine_11" or carry_id == "engine_12" or carry_id == "meth" or carry_id == "lance_bag" or carry_id == "lance_bag_large" or carry_id == "grenades" or carry_id == "ammo" or carry_id == "cage_bag" or carry_id == "turret" or carry_id == "artifact_statue" or carry_id == "samurai_suit" or carry_id == "equipment_bag" or carry_id == "cro_loot1" or carry_id == "cro_loot2" or carry_id == "ladder_bag" then
		return true
	elseif tweak_data.carry[carry_data:carry_id()].is_unique_loot then
		return true
	end
	return false
end

function VehicleDrivingExt:_catch_loot()
end

function VehicleDrivingExt:get_nearest_loot_point(pos)
	local nearest_loot_point
	local min_distance = 1.0E20
	for name, loot_point in pairs(self._loot_points) do
		if loot_point.object ~= nil then
			local loot_point_pos = loot_point.object:position()
			local distance = mvector3.distance(loot_point_pos, pos)
			if min_distance > distance then
				min_distance = distance
				nearest_loot_point = loot_point
			end
		end
	end
	return nearest_loot_point, min_distance
end

function VehicleDrivingExt:enter_vehicle(player)
	local seat = self:find_seat_for_player(player)
	if seat == nil then
		return
	end
end

function VehicleDrivingExt:reserve_seat(player, position)
	local seat = self:get_available_seat(position)
	if seat == nil then
		return nil
	end
	if alive(seat.occupant) and seat.occupant:brain() then
		self:_evacuate_seat(seat)
	end
	seat.occupant = player
	if seat.drive_SO_data then
		local SO_data = seat.drive_SO_data
		seat.drive_SO_data = nil
		if SO_data.SO_registered then
			managers.groupai:state():remove_special_objective(SO_data.SO_id)
		end
		if alive(SO_data.unit) then
			SO_data.unit:brain():set_objective(nil)
		end
	end
	return seat
end

function VehicleDrivingExt:place_player_on_seat(player, seat_name)
	for _, seat in pairs(self._seats) do
		if seat.name == seat_name then
			seat.occupant = player
			self._door_soundsource:set_position(seat.object:position())
			self._door_soundsource:post_event("car_door_open")
			local count = self:_number_in_the_vehicle()
			if count == 1 then
				self:_chk_register_drive_SO()
			end
			if alive(self._seats.driver.occupant) and (self._state == VehicleDrivingExt.STATE_INACTIVE or self._state == VehicleDrivingExt.STATE_PARKED) then
				self:set_state(VehicleDrivingExt.STATE_DRIVING)
			end
			if count == 1 and self._state ~= VehicleDrivingExt.STATE_BROKEN then
				self:start(player)
			end
		end
	end
end

function VehicleDrivingExt:exit_vehicle(player)
	local seat = self:find_seat_for_player(player)
	if seat == nil then
		return
	end
	seat.occupant = nil
	local count = self:_number_in_the_vehicle()
	self:_unregister_drive_SO()
	if not alive(self._seats.driver.occupant) then
		self:set_state(VehicleDrivingExt.STATE_PARKED)
	end
	if count == 0 then
		self:_evacuate_vehicle()
	end
end

function VehicleDrivingExt:_evacuate_vehicle()
	for _, seat in pairs(self._seats) do
		if alive(seat.occupant) and seat.occupant:brain() then
			self:_evacuate_seat(seat)
		end
	end
	self:_unregister_drive_SO()
end

function VehicleDrivingExt:_evacuate_seat(seat)
	seat.occupant:unlink()
	local rot = seat.SO_object:rotation()
	local pos = seat.SO_object:position()
	seat.occupant:set_rotation(rot)
	seat.occupant:set_position(pos)
	seat.occupant:set_m_rot(rot)
	seat.occupant:set_m_pos(pos)
	if Network:is_server() then
		seat.occupant:brain():set_active(true)
	end
	seat.occupant = nil
end

function VehicleDrivingExt:find_exit_position(player)
	local seat = self:find_seat_for_player(player)
	local exit_position = self._unit:get_object(Idstring(VehicleDrivingExt.EXIT_PREFIX .. seat.name))
	local found_exit = true
	local z_offset = Vector3(0, 0, 100)
	local slot_mask = World:make_slot_mask(1, 11)
	local ray = World:raycast("ray_type", "body bag mover", "ray", player:position(), exit_position:position() + z_offset, "sphere_cast_radius", 35, "slot_mask", slot_mask)
	if ray and ray.unit then
		found_exit = false
		for _, seat in pairs(self._tweak_data.seats) do
			exit_position = self._unit:get_object(Idstring(VehicleDrivingExt.EXIT_PREFIX .. seat.name))
			ray = World:raycast("ray_type", "body bag mover", "ray", player:position(), exit_position:position() + z_offset, "sphere_cast_radius", 35, "slot_mask", slot_mask)
			if not ray or not ray.unit then
				found_exit = true
			else
			end
		end
		if not found_exit then
			local i_alt = 1
			exit_position = self._unit:get_object(Idstring("v_exit_alternate_" .. i_alt))
			while exit_position do
				ray = World:raycast("ray_type", "body bag mover", "ray", player:position(), exit_position:position() + z_offset, "sphere_cast_radius", 35, "slot_mask", slot_mask)
				if not ray or not ray.unit then
					found_exit = true
					break
				end
				i_alt = i_alt + 1
				exit_position = self._unit:get_object(Idstring("v_exit_alternate_" .. i_alt))
			end
		end
	end
	if not found_exit then
		Application:trace("[VehicleDrivingExt]  find_exit_position - no exit position")
		exit_position = nil
	end
	return exit_position
end

function VehicleDrivingExt:get_object_placement(player)
	local seat = self:find_seat_for_player(player)
	if seat then
		local obj_pos = self._vehicle:object_position(seat.object)
		local obj_rot = self._vehicle:object_rotation(seat.object)
		return obj_pos, obj_rot
	end
	print("[VehicleDrivingExt:get_object_placement] Seat not found for player!")
	return nil, nil
end

function VehicleDrivingExt:get_available_seat(position)
	local nearest_seat
	local min_distance = 1.0E20
	for name, seat in pairs(self._seats) do
		if not alive(seat.occupant) or seat.occupant:brain() then
			local object = self._unit:get_object(Idstring(VehicleDrivingExt.INTERACTION_PREFIX .. seat.name))
			if object ~= nil then
				local seat_pos = object:position()
				local distance = mvector3.distance(seat_pos, position)
				if min_distance > distance then
					min_distance = distance
					nearest_seat = seat
				end
			end
		end
	end
	return nearest_seat, min_distance
end

function VehicleDrivingExt:find_seat_for_player(player)
	for _, seat in pairs(self._seats) do
		if alive(seat.occupant) and seat.occupant == player then
			return seat
		end
	end
	return nil
end

function VehicleDrivingExt:on_team_ai_enter(ai_unit)
	ai_unit:movement().vehicle_unit:link(Idstring(VehicleDrivingExt.THIRD_PREFIX .. ai_unit:movement().vehicle_seat.name), ai_unit, Idstring("root_point"))
	ai_unit:movement().vehicle_seat.occupant = ai_unit
	Application:debug("VehicleDrivingExt:sync_ai_vehicle_action")
	self._door_soundsource:set_position(ai_unit:movement().vehicle_seat.object:position())
	self._door_soundsource:post_event("car_door_open")
end

function VehicleDrivingExt:on_vehicle_death()
	if not Network:is_server() then
		return
	end
	self:set_state(VehicleDrivingExt.STATE_BROKEN)
end

function VehicleDrivingExt:repair_vehicle()
	self:set_state(VehicleDrivingExt.STATE_PARKED)
	self._unit:character_damage():revive()
end

function VehicleDrivingExt:is_vulnerable()
	return false
end

function VehicleDrivingExt:start(player)
	self:_start(player)
	if managers.network:session() then
		managers.network:session():send_to_peers_synched("sync_vehicle_driving", "start", self._unit, player)
	end
end

function VehicleDrivingExt:sync_start(player)
	self:_start(player)
end

function VehicleDrivingExt:_start(player)
	local seat = self:find_seat_for_player(player)
	if seat == nil then
		return
	end
	if not self._vehicle:is_active() then
		self._unit:damage():run_sequence_simple("driving")
		self._vehicle:set_active(true)
		self:set_state(VehicleDrivingExt.STATE_DRIVING)
	end
	self._last_drop_position = self._unit:get_object(Idstring(self._tweak_data.loot_drop_point)):position()
	self._drop_time_delay = TimerManager:main():time()
end

function VehicleDrivingExt:stop()
	self:_stop()
	if managers.network:session() then
		managers.network:session():send_to_peers_synched("sync_vehicle_driving", "stop", self._unit, nil)
	end
end

function VehicleDrivingExt:sync_stop()
	self:_stop()
end

function VehicleDrivingExt:_stop()
	print("[DRIVING] VehicleDrivingExt: _stop()")
	self:stop_all_sound_events()
	self._unit:damage():run_sequence_simple("not_driving")
	self._vehicle:set_active(false)
	self._drop_time_delay = nil
	self:set_state(VehicleDrivingExt.STATE_INACTIVE)
end

function VehicleDrivingExt:set_input(accelerate, steer, brake, handbrake, gear_up, gear_down, forced_gear)
	if self._state == VehicleDrivingExt.STATE_BROKEN or self._state == VehicleDrivingExt.STATE_PARKED or self._state == VehicleDrivingExt.STATE_SECURED then
		accelerate = 0
		steer = 0
		gear_up = false
		gear_down = false
		brake = 1
	end
	self:_set_input(accelerate, steer, brake, handbrake, gear_up, gear_down, forced_gear)
	if managers.network:session() then
		local pos = self._vehicle:position()
		managers.network:session():send_to_peers_synched("sync_vehicle_set_input", self._unit, accelerate, steer, brake, handbrake, gear_up, gear_down, forced_gear)
		local distance = mvector3.distance(self._last_synced_position, pos)
		if distance > 1 then
			managers.network:session():send_to_peers_synched("sync_vehicle_state", self._unit, self._vehicle:position(), self._vehicle:rotation(), self._vehicle:velocity())
			self._last_synced_position = pos
		end
	end
end

function VehicleDrivingExt:sync_set_input(accelerate, steer, brake, handbrake, gear_up, gear_down, forced_gear)
	self:_set_input(accelerate, steer, brake, handbrake, gear_up, gear_down, forced_gear)
end

function VehicleDrivingExt:sync_state(position, rotation, velocity)
	self._vehicle:adjust_vehicle_state(position, rotation, velocity)
end

function VehicleDrivingExt:_set_input(accelerate, steer, brake, handbrake, gear_up, gear_down, forced_gear)
	local gear_shift = 0
	if gear_up then
		gear_shift = 1
	end
	if gear_down then
		gear_shift = -1
	end
	self._vehicle:set_input(accelerate, steer, brake, handbrake, gear_shift, forced_gear)
end

function VehicleDrivingExt:_wake_nearby_dynamics()
	local slotmask = World:make_slot_mask(1)
	local units = World:find_units_quick("sphere", self._vehicle:position(), 500, slotmask)
	for _, unit in pairs(units) do
		if unit:damage() and unit:damage():has_sequence("car_destructable") then
			unit:damage():run_sequence_simple("car_destructable")
		end
	end
end

function VehicleDrivingExt:_should_push(unit)
	for _, seat in pairs(self._seats) do
		if seat.occupant == unit or seat.drive_SO_data and seat.drive_SO_data.unit == unit then
			return false
		end
	end
	return true
end

function VehicleDrivingExt:_detect_npc_collisions()
	local vel = self._vehicle:velocity()
	if vel:length() < 150 then
		return
	end
	local oobb = self._unit:oobb()
	local slotmask = managers.slot:get_mask("flesh")
	local units = World:find_units("intersect", "obb", oobb:center(), oobb:x(), oobb:y(), oobb:z(), slotmask)
	for _, unit in pairs(units) do
		local unit_is_criminal = unit:in_slot(managers.slot:get_mask("all_criminals"))
		if unit_is_criminal then
		elseif unit:character_damage() and not unit:character_damage():dead() then
			self._hit_soundsource:set_position(unit:position())
			self._hit_soundsource:set_rtpc("car_hit_vel", math.clamp(vel:length() / 100 * 2, 0, 100))
			self._hit_soundsource:post_event("car_hit_body_01")
			local damage_ext = unit:character_damage()
			damage_ext:damage_mission({
				damage = damage_ext._HEALTH_INIT or 1000,
				variant = "explosion"
			})
			if unit:movement()._active_actions[1] and unit:movement()._active_actions[1]:type() == "hurt" then
				unit:movement()._active_actions[1]:force_ragdoll()
			end
			local nr_u_bodies = unit:num_bodies()
			local i_u_body = 0
			while nr_u_bodies > i_u_body do
				local u_body = unit:body(i_u_body)
				if u_body:enabled() and u_body:dynamic() then
					local body_mass = u_body:mass()
					u_body:push_at(body_mass / math.random(2), vel * 2.5, u_body:position())
				end
				i_u_body = i_u_body + 1
			end
		end
	end
end

function VehicleDrivingExt:_detect_collisions(t, dt)
	local current_speed = self._vehicle:velocity()
	if dt ~= 0 and self._vehicle:is_active() then
		local dv = self._old_speed - current_speed
		local gforce = math.abs(dv:length() / 100 / dt) / 9.81
		if gforce > 15 then
			local ray_from = self._seats.driver.object:position() + Vector3(0, 0, 100)
			local distance = mvector3.copy(self._old_speed)
			mvector3.normalize(distance)
			mvector3.multiply(distance, 300)
			local ray = World:raycast("ray", ray_from, ray_from + distance, "sphere_cast_radius", 75, "slot_mask", managers.slot:get_mask("world_geometry"))
			if ray and ray.unit then
				self:on_impact(ray, gforce, self._old_speed)
			else
				ray_from = self._seats.passenger_front.object:position() + Vector3(0, 0, 100)
				ray = World:raycast("ray", ray_from, ray_from + distance, "sphere_cast_radius", 75, "slot_mask", managers.slot:get_mask("world_geometry"))
				if ray and ray.unit then
					self:on_impact(ray, gforce, self._old_speed)
				else
					self:on_impact(nil, gforce, self._old_speed)
				end
			end
		end
	end
	self._old_speed = current_speed
end

function VehicleDrivingExt:_detect_invalid_possition(t, dt)
	local rot = self._vehicle:rotation()
	if rot:z().z < 0.2 and not self._invalid_position_since then
		self._invalid_position_since = t
	elseif rot:z().z >= 0.2 and self._invalid_position_since then
		self._invalid_position_since = nil
	end
	local velocity = self._vehicle:velocity():length()
	if velocity < 100 and not self._stopped_since then
		self._stopped_since = t
	end
	if self._stopped_since and t - self._stopped_since > 5 and self._invalid_position_since and t - self._invalid_position_since > 5 then
		self._stopped_since = nil
		self._invalid_position_since = nil
		local up = Vector3(0, 0, 1)
		local axis = up:cross(rot:y())
		local flip = Rotation(axis, 0)
		self._vehicle:set_rotation(flip)
	end
end

function VehicleDrivingExt:_play_sound_events(t, dt)
	local state = self._vehicle:get_state()
	local slip = false
	local bump = false
	local speed = state:get_speed() * 3.6
	for id, wheel_state in pairs(state:wheel_states()) do
		local current_jounce = wheel_state:jounce()
		local last_frame_jounce = self._wheel_jounce[id]
		if last_frame_jounce == nil then
			last_frame_jounce = 0
		end
		local dj = current_jounce - last_frame_jounce
		local jerk = dj / dt
		if jerk > self._tweak_data.sound.bump_treshold then
			bump = true
		end
		self._wheel_jounce[id] = current_jounce
		if math.abs(wheel_state:lat_slip()) > self._tweak_data.sound.lateral_slip_treshold then
			slip = true
		elseif math.abs(wheel_state:long_slip()) > self._tweak_data.sound.longitudal_slip_treshold and state:get_rpm() > 500 then
			slip = true
		end
	end
	if slip then
		if self._playing_slip_sound_dt == 0 then
			self._slip_soundsource:post_event("car_skid_01")
			self._playing_slip_sound_dt = self._playing_slip_sound_dt + dt
		end
	elseif self._playing_slip_sound_dt > 0.1 then
		self._slip_soundsource:stop()
		self._slip_soundsource:post_event("car_skid_stop_01")
		self._playing_slip_sound_dt = 0
	end
	if 0 < self._playing_slip_sound_dt then
		self._playing_slip_sound_dt = self._playing_slip_sound_dt + dt
	end
	if bump then
		self._bump_soundsource:set_rtpc("car_bump_vel", 2 * math.clamp(speed, 0, 100))
		self._bump_soundsource:post_event("car_bumper_01")
	end
	self:_play_engine_sound(state)
end

function VehicleDrivingExt:_start_engine_sound()
	if not self._playing_engine_sound and self._engine_soundsource then
		self._playing_engine_sound = true
		self._engine_soundsource:post_event(self._tweak_data.sound.engine_start)
		self._engine_soundsource:post_event(self._tweak_data.sound.engine_sound_event)
		self._playing_engine_sound = true
	end
end

function VehicleDrivingExt:_stop_engine_sound()
	if self._playing_engine_sound and self._engine_soundsource then
		self._engine_soundsource:stop()
		self._playing_engine_sound = false
	end
end

function VehicleDrivingExt:_play_engine_sound(state)
	if self._engine_soundsource == nil then
		return
	end
	local speed = state:get_speed() * 3.6
	local rpm = state:get_rpm()
	local max_speed = self._tweak_data.max_speed
	local max_rpm = self._vehicle:get_max_rpm()
	if not self._playing_engine_sound then
		return
	end
	local relative_speed = speed / max_speed
	if relative_speed > 1 then
		relative_speed = 1
	end
	local relative_rpm = rpm / max_rpm
	if relative_rpm > 1 then
		relative_rpm = 1
	end
	local rpm_rtpc = math.round(relative_rpm * 100)
	local speed_rtpc = math.round(relative_speed * 100)
	self._engine_soundsource:set_rtpc(self._tweak_data.sound.engine_rpm_rtpc, rpm_rtpc)
	self._engine_soundsource:set_rtpc(self._tweak_data.sound.engine_speed_rtpc, speed_rtpc)
end

function VehicleDrivingExt:stop_all_sound_events()
	self._hit_soundsource:stop()
	self._slip_soundsource:stop()
	self._bump_soundsource:stop()
	if self._engine_soundsource then
		self._engine_soundsource:stop()
	end
	self._playing_slip_sound_dt = 0
end

function VehicleDrivingExt:_unregister_drive_SO()
	for _, seat in pairs(self._seats) do
		if seat.drive_SO_data then
			local SO_data = seat.drive_SO_data
			seat.drive_SO_data = nil
			if SO_data.SO_registered then
				managers.groupai:state():remove_special_objective(SO_data.SO_id)
			end
			if alive(SO_data.unit) then
				SO_data.unit:brain():set_objective(nil)
			end
		end
	end
end

function VehicleDrivingExt:_chk_register_drive_SO()
	if not Network:is_server() or not managers.navigation:is_data_ready() then
		return
	end
	for _, seat in pairs(self._seats) do
		if seat.drive_SO_data then
			debug_pause("[VehicleDrivingExt:_chk_register_drive_SO] Seat already has a SO!!!!", seat.name)
		elseif not seat.driving and not alive(seat.occupant) then
			self:_cereate_seat_SO(seat)
		end
	end
end

function VehicleDrivingExt:_cereate_seat_SO(seat)
	if seat.drive_SO_data then
		return
	end
	local SO_filter = managers.groupai:state():get_unit_type_filter("criminal")
	local tracker_align = managers.navigation:create_nav_tracker(seat.SO_object:position(), false)
	local align_nav_seg = tracker_align:nav_segment()
	local align_pos = seat.SO_object:position()
	local align_rot = seat.SO_object:rotation()
	local align_area = managers.groupai:state():get_area_from_nav_seg_id(align_nav_seg)
	managers.navigation:destroy_nav_tracker(tracker_align)
	local team_ai_animation = self._tweak_data.animations[seat.name]
	local ride_objective = {
		type = "act",
		haste = "run",
		pose = "stand",
		destroy_clbk_key = false,
		nav_seg = align_nav_seg,
		area = align_area,
		pos = align_pos,
		rot = align_rot,
		fail_clbk = callback(self, self, "on_drive_SO_failed", seat),
		action = {
			type = "act",
			variant = team_ai_animation,
			body_part = 1,
			align_sync = false
		}
	}
	local SO_descriptor = {
		objective = ride_objective,
		base_chance = 1,
		chance_inc = 0,
		interval = 0,
		search_pos = ride_objective.pos,
		usage_amount = 1,
		AI_group = "friendlies",
		admin_clbk = callback(self, self, "on_drive_SO_administered", seat)
	}
	local SO_id = "ride_" .. tostring(self._unit:key()) .. seat.name
	seat.drive_SO_data = {
		SO_id = SO_id,
		SO_registered = true,
		align_area = align_area,
		ride_objective = ride_objective
	}
	managers.groupai:state():add_special_objective(SO_id, SO_descriptor)
end

function VehicleDrivingExt:clbk_drive_SO_verification(candidate_unit)
	return true
end

function VehicleDrivingExt:on_drive_SO_administered(seat, unit)
	if seat.drive_SO_data.unit then
		debug_pause("[VehicleDrivingExt:on_drive_SO_administered] Already had a unit!!!!", seat.name, unit, seat.drive_SO_data.unit)
	end
	seat.drive_SO_data.unit = unit
	seat.drive_SO_data.SO_registered = false
	unit:movement().vehicle_unit = self._unit
	unit:movement().vehicle_seat = seat
	managers.network:session():send_to_peers_synched("sync_ai_vehicle_action", "enter", self._unit, seat.name, unit)
end

function VehicleDrivingExt:on_drive_SO_started(seat, unit)
	local rot = seat.third_object:rotation()
	local pos = seat.third_object:position()
	if managers.network:session() then
	end
end

function VehicleDrivingExt:on_drive_SO_completed(seat, unit)
	Application:debug("[VehicleDrivingExt:on_drive_SO_completed]", seat.name)
	local rot = seat.third_object:rotation()
	local pos = seat.third_object:position()
	unit:set_rotation(rot)
	unit:set_position(pos)
	seat.occupant = unit
	self._unit:link(Idstring(VehicleDrivingExt.THIRD_PREFIX .. seat.name), unit)
	if managers.network:session() then
	end
	unit:brain():set_active(false)
end

function VehicleDrivingExt:on_drive_SO_failed(seat, unit)
	if not seat.drive_SO_data then
		return
	end
	if unit ~= seat.drive_SO_data.unit then
		debug_pause_unit(unit, "[VehicleDrivingExt:on_drive_SO_failed] idiot thinks he is riding", unit)
		return
	end
	seat.drive_SO_data = nil
	self:_cereate_seat_SO(seat)
end

function VehicleDrivingExt:sync_ai_vehicle_action(action, seat_name, unit)
	if action == "enter" then
		for _, seat in pairs(self._seats) do
			if seat.name == seat_name then
				local rot = seat.third_object:rotation()
				local pos = seat.third_object:position()
				unit:movement().vehicle_unit = self._unit
				unit:movement().vehicle_seat = seat
				self._door_soundsource:post_event("car_door_open")
			end
		end
	elseif action == "exit" then
	else
		debug_pause("[VehicleDrivingExt:sync_ai_vehicle_action] Unknown value for parameter action!", "action", action)
	end
end

function VehicleDrivingExt:collision_callback(tag, unit, body, other_unit, other_body, position, normal, velocity, ...)
	Application:debug("Collision detected!")
end

function VehicleDrivingExt:on_impact(ray, gforce, velocity)
	if ray then
		self._hit_soundsource:set_position(ray.hit_position)
	else
		self._hit_soundsource:set_position(self._unit:position())
	end
	self._hit_soundsource:set_rtpc("car_hit_vel", math.clamp(gforce / 2.5, 0, 100))
	self._hit_soundsource:post_event("car_hit_gen_01")
	if ray then
		local body = ray.body
		if ray.unit and ray.unit:damage() and ray.body and ray.body:extension() then
			local damage = gforce
			ray.body:extension().damage:damage_collision(self._unit, ray.normal, ray.position, velocity, damage, velocity)
		end
	end
	for _, seat in pairs(self._seats) do
		if alive(seat.occupant) and seat.occupant:camera() then
			seat.occupant:camera():play_shaker("player_land", gforce / 500)
		end
	end
end

function VehicleDrivingExt:_number_in_the_vehicle()
	local count = 0
	for _, seat in pairs(self._seats) do
		if alive(seat.occupant) and seat.occupant:brain() == nil then
			count = count + 1
		end
	end
	return count
end

