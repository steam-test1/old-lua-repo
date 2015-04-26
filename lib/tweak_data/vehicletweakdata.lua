VehicleTweakData = VehicleTweakData or class()
function VehicleTweakData:init(tweak_data)
	self:_init_data_falcogini()
	self:_init_data_escape_van()
	self:_init_data_muscle()
end

function VehicleTweakData:_init_data_falcogini()
	self.falcogini = {}
	self.falcogini.name = "Falcogini"
	self.falcogini.hud_label_offset = 140
	self.falcogini.animations = {
		vehicle_id = "falcogini",
		driver = "drive_falcogini_driver",
		passenger_front = "drive_falcogini_passanger"
	}
	self.falcogini.sound = {
		bump_treshold = 5,
		lateral_slip_treshold = 0.25,
		longitudal_slip_treshold = 0.8,
		engine_sound_event = "falcogini",
		engine_start = "falcogini_engine_start",
		door_close = "car_door_open",
		slip = "car_skid_01",
		slip_stop = "car_skid_stop_01",
		bump = "car_bumper_01",
		bump_rtpc = "car_bump_vel",
		hit = "car_hit_gen_01",
		hit_rtpc = "car_hit_vel",
		engine_speed_rtpc = "car_falcogini_speed",
		engine_rpm_rtpc = "car_falcogini_rpm"
	}
	self.falcogini.seats = {
		driver = {name = "driver", driving = true},
		passenger_front = {
			name = "passenger_front",
			driving = false,
			allow_shooting = false,
			has_shooting_mode = true,
			shooting_pos = Vector3(50, -20, 50)
		}
	}
	self.falcogini.loot_points = {
		loot_left = {name = "loot_left"},
		loot_right = {name = "loot_right"}
	}
	self.falcogini.damage = {max_health = 250}
	self.falcogini.max_speed = 200
	self.falcogini.max_rpm = 9000
	self.falcogini.loot_drop_point = "v_repair_engine"
	self.falcogini.max_loot_bags = 2
	self.falcogini.driver_camera_offset = Vector3(0, 0, 2.5)
	self.falcogini.fov = 80
end

function VehicleTweakData:_init_data_escape_van()
	self.escape_van = {}
	self.escape_van.name = "Van"
	self.escape_van.hud_label_offset = 220
	self.escape_van.animations = {
		vehicle_id = "escape_van",
		driver = "drive_escape_van_driver",
		passenger_front = "drive_escape_van_passanger",
		passenger_back_left = "drive_escape_van_kneel",
		passenger_back_right = "drive_escape_van_kneel"
	}
	self.escape_van.sound = {
		bump_treshold = 5,
		lateral_slip_treshold = 0.25,
		longitudal_slip_treshold = 0.8,
		engine_sound_event = "falcogini",
		engine_start = "falcogini_engine_start",
		door_close = "car_door_open",
		slip = "car_skid_01",
		slip_stop = "car_skid_stop_01",
		bump = "car_bumper_01",
		bump_rtpc = "car_bump_vel",
		hit = "car_hit_gen_01",
		hit_rtpc = "car_hit_vel",
		engine_speed_rtpc = "car_falcogini_speed",
		engine_rpm_rtpc = "car_falcogini_rpm"
	}
	self.escape_van.seats = {
		driver = {name = "driver", driving = true},
		passenger_front = {
			name = "passenger_front",
			driving = false,
			allow_shooting = false,
			has_shooting_mode = true,
			shooting_pos = Vector3(50, -20, 50)
		},
		passenger_back_left = {
			name = "passenger_back_left",
			driving = false,
			allow_shooting = false,
			has_shooting_mode = true,
			shooting_pos = Vector3(50, -20, 50)
		},
		passenger_back_right = {
			name = "passenger_back_right",
			driving = false,
			allow_shooting = false,
			has_shooting_mode = true,
			shooting_pos = Vector3(50, -20, 50)
		}
	}
	self.escape_van.loot_points = {
		loot_left = {name = "loot_left"},
		loot_right = {name = "loot_right"}
	}
	self.escape_van.damage = {max_health = 250}
	self.escape_van.max_speed = 100
	self.escape_van.max_rpm = 5000
	self.escape_van.loot_drop_point = "v_exit_passenger_back_left"
	self.escape_van.max_loot_bags = 10
	self.escape_van.driver_camera_offset = Vector3(0, 0, 2.5)
	self.escape_van.fov = 80
end

function VehicleTweakData:_init_data_muscle()
	self.muscle = {}
	self.muscle.name = "Stallion"
	self.muscle.hud_label_offset = 150
	self.muscle.animations = {
		vehicle_id = "muscle",
		driver = "drive_muscle_driver",
		passenger_front = "drive_muscle_passanger",
		passenger_back_left = "drive_muscle_back_left",
		passenger_back_right = "drive_muscle_back_right"
	}
	self.muscle.sound = {
		bump_treshold = 8,
		lateral_slip_treshold = 0.35,
		longitudal_slip_treshold = 0.8,
		engine_sound_event = "muscle",
		engine_start = "falcogini_engine_start",
		door_close = "car_door_open",
		slip = "car_skid_01",
		slip_stop = "car_skid_stop_01",
		bump = "car_bumper_01",
		bump_rtpc = "car_bump_vel",
		hit = "car_hit_gen_01",
		hit_rtpc = "car_hit_vel",
		engine_speed_rtpc = "car_falcogini_speed",
		engine_rpm_rtpc = "car_falcogini_rpm"
	}
	self.muscle.seats = {
		driver = {name = "driver", driving = true},
		passenger_front = {
			name = "passenger_front",
			driving = false,
			allow_shooting = true,
			has_shooting_mode = true,
			shooting_pos = Vector3(50, -20, 50)
		},
		passenger_back_left = {
			name = "passenger_back_left",
			driving = false,
			allow_shooting = false,
			has_shooting_mode = true,
			shooting_pos = Vector3(-50, -20, 50)
		},
		passenger_back_right = {
			name = "passenger_back_right",
			driving = false,
			allow_shooting = false,
			has_shooting_mode = true,
			shooting_pos = Vector3(50, -20, 50)
		}
	}
	self.muscle.loot_points = {
		loot_left = {name = "loot_left"},
		loot_right = {name = "loot_right"}
	}
	self.muscle.damage = {max_health = 300}
	self.muscle.max_speed = 160
	self.muscle.max_rpm = 8000
	self.muscle.loot_drop_point = "v_repair_engine"
	self.muscle.max_loot_bags = 4
	self.muscle.driver_camera_offset = Vector3(0, 0.2, 2.5)
	self.muscle.fov = 80
end

