local mvec3_dot = mvector3.dot
local mvec3_set = mvector3.set
local mvec3_sub = mvector3.subtract
local mvec3_dis_sq = mvector3.distance_sq
local mvec3_dir = mvector3.direction
local mvec3_l_sq = mvector3.length_sq
local tmp_vec1 = Vector3()
local tmp_vec2 = Vector3()
GroupAIStateBase = GroupAIStateBase or class()
GroupAIStateBase._nr_important_cops = 3
GroupAIStateBase.BLAME_SYNC = {
	"empty",
	"met_criminal",
	"mot_criminal",
	"gls_alarm",
	"sys_blackmailer",
	"sys_gensec",
	"sys_police_alerted",
	"sys_csgo_gunfire",
	"alarm_pager_bluff_failed",
	"alarm_pager_not_answered",
	"alarm_pager_hang_up",
	"civ_alarm",
	"cop_alarm",
	"gan_alarm",
	"gan_crate_open",
	"cam_criminal",
	"cam_gunfire",
	"cam_dead_body",
	"cam_body_bag",
	"cam_hostage",
	"cam_drill",
	"cam_saw",
	"cam_sentry_gun",
	"cam_trip_mine",
	"cam_ecm_jammer",
	"cam_c4",
	"cam_computer",
	"cam_broken_cam",
	"cam_vault",
	"cam_fire",
	"cam_voting",
	"cam_glass",
	"cam_breaking_entering",
	"cam_crate_open",
	"cam_distress",
	"civ_criminal",
	"civ_gunfire",
	"civ_dead_body",
	"civ_body_bag",
	"civ_hostage",
	"civ_drill",
	"civ_saw",
	"civ_sentry_gun",
	"civ_trip_mine",
	"civ_ecm_jammer",
	"civ_c4",
	"civ_broken_cam",
	"civ_vault",
	"civ_fire",
	"civ_voting",
	"civ_glass",
	"civ_breaking_entering",
	"civ_crate_open",
	"civ_computer",
	"civ_distress",
	"cop_criminal",
	"cop_gunfire",
	"cop_dead_body",
	"cop_body_bag",
	"cop_hostage",
	"cop_drill",
	"cop_saw",
	"cop_sentry_gun",
	"cop_trip_mine",
	"cop_ecm_jammer",
	"cop_c4",
	"cop_broken_cam",
	"cop_vault",
	"cop_fire",
	"cop_voting",
	"cop_glass",
	"cop_breaking_entering",
	"cop_crate_open",
	"cop_computer",
	"cop_distress",
	"sys_explosion",
	"civ_explosion",
	"cop_explosion",
	"gan_explosion",
	"cam_explosion",
	"default"
}
function GroupAIStateBase.chk_all_blame_synced()
-- fail 7
null
3
-- fail 30
null
3
	local all_fine = true
	do
		local (for generator), (for state), (for control) = pairs(tweak_data.blame)
		do
			do break end
			if blame ~= "empty" and not table.contains(GroupAIStateBase.BLAME_SYNC, blame) then
				Application:error("[GroupAIStateBase.chk_all_blame_synced] Blame not synced!", blame)
				all_fine = false
			end

		end

	end

	do
		local (for generator), (for state), (for control) = ipairs(GroupAIStateBase.BLAME_SYNC)
		do
			do break end
			if blame ~= "empty" and not tweak_data.blame[blame] then
				Application:error("[GroupAIStateBase.chk_all_blame_synced] Blame not in tweak_data!", blame)
				all_fine = false
			end

		end

	end

	do break end
	Application:debug("[GroupAIStateBase.chk_all_blame_synced] PASSED CHECK")
end

GroupAIStateBase.EVENT_SYNC = {
	"police_called",
	"enemy_weapons_hot",
	"cloaker_spawned"
}
function GroupAIStateBase:init()
	self:_init_misc_data()
end

function GroupAIStateBase:update(t, dt)
	self._t = t
	self:_upd_criminal_suspicion_progress()
	if self._draw_drama then
		self:_debug_draw_drama(t)
	end

	self:_upd_debug_draw_attentions()
end

function GroupAIStateBase:paused_update(t, dt)
	if self._draw_drama then
		self:_debug_draw_drama(self._t)
	end

end

function GroupAIStateBase:get_assault_mode()
	return self._assault_mode
end

function GroupAIStateBase:get_hunt_mode()
	return self._hunt_mode
end

function GroupAIStateBase:is_AI_enabled()
	return self._ai_enabled
end

function GroupAIStateBase:set_AI_enabled(state)
	self._ai_enabled = state
	self._forbid_drop_in = state
	if Network:is_server() then
		do
			local (for generator), (for state), (for control) = pairs(managers.enemy:all_enemies())
			do
				do break end
				local is_active = u_data.unit:brain():is_active()
				if state and not is_active or not state and is_active then
					u_data.unit:brain():set_active(state)
				end

			end

		end

		(for control) = managers.enemy:all_enemies() and u_data.unit
		do
			local (for generator), (for state), (for control) = pairs(self._criminals)
			do
				do break end
				if u_data.ai then
					local is_active = u_data.unit:brain():is_active()
					if state and not is_active or not state and is_active then
						u_data.unit:brain():set_active(state)
					end

				end

			end

		end

		(for control) = managers.enemy:all_enemies() and u_data.ai
		local (for generator), (for state), (for control) = pairs(managers.enemy:all_civilians())
		do
			do break end
			local is_active = u_data.unit:brain():is_active()
			if state and not is_active or not state and is_active then
				u_data.unit:brain():set_active(state)
			end

		end

	end

	(for control) = managers.enemy:all_civilians() and u_data.unit
	managers.enemy:dispose_all_corpses()
	if not state then
		do
			local (for generator), (for state), (for control) = pairs(self._security_cameras)
			do
				do break end
				unit:base():set_detection_enabled(false)
			end

		end

		(for control) = managers.enemy:all_civilians() and unit.base
		do
			local (for generator), (for state), (for control) = pairs(managers.enemy:all_enemies())
			do
				do break end
				Network:detach_unit(u_data.unit)
				World:delete_unit(u_data.unit)
			end

		end

		(for control) = managers.enemy:all_enemies() and Network
		do
			local (for generator), (for state), (for control) = pairs(self._criminals)
			do
				do break end
				if u_data.ai then
					Network:detach_unit(u_data.unit)
					World:delete_unit(u_data.unit)
				elseif u_data.is_deployable then
					World:delete_unit(u_data.unit)
				end

			end

		end

		(for control) = managers.enemy:all_enemies() and u_data.ai
		do
			local (for generator), (for state), (for control) = pairs(managers.enemy:all_civilians())
			do
				do break end
				Network:detach_unit(u_data.unit)
				World:delete_unit(u_data.unit)
			end

		end

		(for control) = managers.enemy:all_civilians() and Network
		local (for generator), (for state), (for control) = ipairs(managers.criminals:characters())
		do
			do break end
			if char.ai == false and alive(char.unit) then
				Network:detach_unit(char.unit)
				unit:set_extension_update_enabled(Idstring("movement"), false)
			end

		end

	end

	do break end
	if Application:editor() then
		self._editor_sim_rem_units = {}
		do break end
		if self._editor_sim_rem_units then
			do
				local (for generator), (for state), (for control) = pairs(self._editor_sim_rem_units)
				do
					do break end
					if alive(unit) then
						World:delete_unit(unit)
					end

				end

			end

			self._editor_sim_rem_units = nil
		end

	end

	(for control) = managers.criminals:characters() and alive
	if not state then
		local all_deployed_equipment = World:find_units_quick("all", 14)
		local (for generator), (for state), (for control) = ipairs(all_deployed_equipment)
		do
			do break end
			if alive(unit) then
				World:delete_unit(unit)
			end

		end

	end

end

function GroupAIStateBase:_init_misc_data()
	self._t = TimerManager:game():time()
	self:_parse_teammate_comments()
	self._is_server = Network:is_server()
	self._player_weapons_hot = nil
	self._enemy_weapons_hot = nil
	self._police_called = nil
	self._spawn_points = {}
	self._spawn_groups = {}
	self._spawning_groups = {}
	self._groups = {}
	self._flee_points = {}
	self._hostage_data = {}
	self._spawn_events = {}
	self._special_objectives = {}
	self._occasional_events = {}
	self._attention_objects = {
		all = {}
	}
	self._nav_seg_to_area_map = {}
	self._security_cameras = {}
	self._ecm_jammers = {}
	self._suspicion_hud_data = {}
	self._nr_successful_alarm_pager_bluffs = 0
	self._enemy_loot_drop_points = {}
	local drama_tweak = tweak_data.drama
	self._drama_data = {
		decay_period = tweak_data.drama.decay_period,
		last_calculate_t = 0,
		amount = 0,
		zone = "low",
		low_p = drama_tweak.low,
		high_p = drama_tweak.peak,
		actions = drama_tweak.drama_actions,
		max_dis = drama_tweak.max_dis,
		dis_mul = drama_tweak.max_dis_mul
	}
	self._ai_enabled = true
	self._downs_during_assault = 0
	self._hostage_headcount = 0
	self._police_hostage_headcount = 0
	self:sync_assault_mode(false)
	self._fake_assault_mode = false
	self._whisper_mode = false
	self:set_bain_state(true)
	self._allow_dropin = true
	self._police = managers.enemy:all_enemies()
	self._converted_police = {}
	self._char_criminals = {}
	self._criminals = {}
	self._ai_criminals = {}
	self._player_criminals = {}
	self._special_units = {}
	self._special_unit_types = {
		tank = true,
		spooc = true,
		shield = true,
		taser = true
	}
	self._anticipated_police_force = 0
	self._police_force = table.size(self._police)
	self._fleeing_civilians = {}
	self._hostage_keys = {}
	self._enemy_chatter = {}
	self._teamAI_last_combat_chatter_t = 0
	self:set_difficulty(0)
	self:_set_rescue_state(true)
	self._criminal_AI_respawn_clbks = {}
	self._listener_holder = EventListenerHolder:new()
	self:set_drama_draw_state(Global.drama_draw_state)
	self._alert_listeners = {}
	self:_init_unit_type_filters()
end

function GroupAIStateBase:add_alert_listener(id, clbk, filter_num, types, m_pos)
	local listener_data = {
		clbk = clbk,
		filter = filter_num,
		types = types,
		m_pos = m_pos
	}
	local all_listeners = self._alert_listeners
	local (for generator), (for state), (for control) = pairs(types)
	do
		do break end
		local listeners_by_type = all_listeners[alert_type]
		if not listeners_by_type then
			listeners_by_type = {}
			all_listeners[alert_type] = listeners_by_type
		end

		local filter_str = managers.navigation:convert_access_filter_to_string(filter_num)
		local listeners_by_type_and_filter = listeners_by_type[filter_str]
		if not listeners_by_type_and_filter then
			listeners_by_type_and_filter = {}
			listeners_by_type[filter_str] = listeners_by_type_and_filter
		end

		listeners_by_type_and_filter[id] = listener_data
	end

end

function GroupAIStateBase:remove_alert_listener(id)
-- fail 9
null
9
	local (for generator), (for state), (for control) = pairs(self._alert_listeners)
	do
		do break end
		do
			local (for generator), (for state), (for control) = pairs(listeners_by_type)
			do
				do break end
				listeners_by_type_and_filter[id] = nil
				if not next(listeners_by_type_and_filter) then
					listeners_by_type[filter] = nil
				end

			end

		end

		if not next(listeners_by_type) then
			self._alert_listeners[alert_type] = nil
		end

	end

end

function GroupAIStateBase:propagate_alert(alert_data)
