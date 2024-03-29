VehicleTweakData = VehicleTweakData or class()
function VehicleTweakData:init(tweak_data)
	self:_init_data_falcogini()
	self:_init_data_muscle()
	self:_init_data_forklift()
	self:_init_data_forklift_2()
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
		broken_engine = "falcogini_engine_broken_loop",
		fix_engine_loop = "falcogini_engine_fix_loop",
		fix_engine_stop = "falcogini_engine_fix_stop",
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
	self.falcogini.damage = {max_health = 100000}
	self.falcogini.max_speed = 200
	self.falcogini.max_rpm = 9000
	self.falcogini.loot_drop_point = "v_repair_engine"
	self.falcogini.max_loot_bags = 2
	self.falcogini.interact_distance = 350
	self.falcogini.driver_camera_offset = Vector3(0, 0, 2.5)
	self.falcogini.fov = 75
end

function VehicleTweakData:_init_data_muscle()
	self.muscle = {}
	self.muscle.name = "Longfellow"
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
		broken_engine = "falcogini_engine_broken_loop",
		engine_start = "muscle_engine_start",
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
			allow_shooting = false,
			has_shooting_mode = true,
			shooting_pos = Vector3(50, -20, 50)
		},
		passenger_back_left = {
			name = "passenger_back_left",
			driving = false,
			allow_shooting = false,
			has_shooting_mode = true
		},
		passenger_back_right = {
			name = "passenger_back_right",
			driving = false,
			allow_shooting = false,
			has_shooting_mode = true
		}
	}
	self.muscle.loot_points = {
		loot_left = {name = "loot_left"},
		loot_right = {name = "loot_right"}
	}
	self.muscle.damage = {max_health = 100000}
	self.muscle.max_speed = 160
	self.muscle.max_rpm = 8000
	self.muscle.loot_drop_point = "v_repair_engine"
	self.muscle.max_loot_bags = 4
	self.muscle.interact_distance = 350
	self.muscle.driver_camera_offset = Vector3(0, 0.2, 2.5)
	self.muscle.fov = 75
end

function VehicleTweakData:_init_data_forklift()
	self.forklift = {}
	self.forklift.name = "Forklift"
	self.forklift.hud_label_offset = 220
	self.forklift.animations = {
		vehicle_id = "forklift",
		driver = "drive_forklift_driver",
		passenger_front = "drive_forklift_passanger"
	}
	self.forklift.sound = {
		bump_treshold = 5,
		lateral_slip_treshold = 10,
		longitudal_slip_treshold = 10,
		engine_sound_event = "forklift",
		engine_start = "forklift_start",
		door_close = "sit_down_in_forklift",
		going_reverse = "forklift_reverse_warning",
		going_reverse_stop = "forklift_reverse_warning_stop",
		slip = "car_skid_01",
		slip_stop = "car_skid_stop_01",
		bump = "car_bumper_01",
		bump_rtpc = "car_bump_vel",
		hit = "car_hit_gen_01",
		hit_rtpc = "car_hit_vel",
		engine_speed_rtpc = "car_falcogini_speed",
		engine_rpm_rtpc = "car_falcogini_rpm"
	}
	self.forklift.seats = {
		driver = {name = "driver", driving = true},
		passenger_front = {
			name = "passenger_front",
			driving = false,
			allow_shooting = true,
			has_shooting_mode = false
		}
	}
	self.forklift.loot_points = {
		loot_left = {name = "loot"}
	}
	self.forklift.damage = {max_health = 100000}
	self.forklift.max_speed = 20
	self.forklift.max_rpm = 1600
	self.forklift.loot_drop_point = "v_repair_engine"
	self.forklift.max_loot_bags = 3
	self.forklift.interact_distance = 350
	self.forklift.driver_camera_offset = Vector3(0, 0, 7.5)
	self.forklift.fov = 70
end

function VehicleTweakData:_init_data_forklift_2()
	self.forklift_2 = {}
	self.forklift_2.name = "Forklift"
	self.forklift_2.hud_label_offset = 220
	self.forklift_2.animations = {
		vehicle_id = "forklift",
		driver = "drive_forklift_driver"
	}
	self.forklift_2.sound = {
		bump_treshold = 5,
		lateral_slip_treshold = 10,
		longitudal_slip_treshold = 10,
		engine_sound_event = "forklift",
		engine_start = "forklift_start",
		door_close = "sit_down_in_forklift",
		going_reverse = "forklift_reverse_warning",
		going_reverse_stop = "forklift_reverse_warning_stop",
		slip = "car_skid_01",
		slip_stop = "car_skid_stop_01",
		bump = "car_bumper_01",
		bump_rtpc = "car_bump_vel",
		hit = "car_hit_gen_01",
		hit_rtpc = "car_hit_vel",
		engine_speed_rtpc = "car_falcogini_speed",
		engine_rpm_rtpc = "car_falcogini_rpm"
	}
	self.forklift_2.seats = {
		driver = {name = "driver", driving = true}
	}
	self.forklift_2.loot_points = {
		loot_left = {name = "loot"}
	}
	self.forklift_2.damage = {max_health = 100000}
	self.forklift_2.max_speed = 20
	self.forklift_2.max_rpm = 1600
	self.forklift_2.loot_drop_point = "v_repair_engine"
	self.forklift_2.max_loot_bags = 0
	self.forklift_2.interact_distance = 350
	self.forklift_2.driver_camera_offset = Vector3(0, 0, 7.5)
	self.forklift_2.fov = 70
end

