require("lib/units/enemies/cop/logics/CopLogicBase")
require("lib/units/enemies/cop/logics/CopLogicTravel")
require("lib/units/enemies/cop/logics/CopLogicAttack")
TeamAILogicTravel = class(TeamAILogicBase)
TeamAILogicTravel.damage_clbk = TeamAILogicIdle.damage_clbk
TeamAILogicTravel.on_cop_neutralized = TeamAILogicIdle.on_cop_neutralized
TeamAILogicTravel.on_objective_unit_damaged = TeamAILogicIdle.on_objective_unit_damaged
TeamAILogicTravel.on_alert = TeamAILogicIdle.on_alert
TeamAILogicTravel.on_long_dis_interacted = TeamAILogicIdle.on_long_dis_interacted
TeamAILogicTravel.on_new_objective = TeamAILogicIdle.on_new_objective
TeamAILogicTravel.clbk_heat = TeamAILogicIdle.clbk_heat
TeamAILogicTravel._upd_pathing = CopLogicTravel._upd_pathing
TeamAILogicTravel._get_exact_move_pos = CopLogicTravel._get_exact_move_pos
TeamAILogicTravel._determine_destination_occupation = CopLogicTravel._determine_destination_occupation
TeamAILogicTravel.chk_should_turn = CopLogicTravel.chk_should_turn
TeamAILogicTravel._get_all_paths = CopLogicTravel._get_all_paths
TeamAILogicTravel._set_verified_paths = CopLogicTravel._set_verified_paths
TeamAILogicTravel.get_pathing_prio = CopLogicTravel.get_pathing_prio
TeamAILogicTravel.action_complete_clbk = CopLogicTravel.action_complete_clbk
TeamAILogicTravel.on_intimidated = TeamAILogicIdle.on_intimidated
function TeamAILogicTravel.enter(data, new_logic_name, enter_params)
	CopLogicBase.enter(data, new_logic_name, enter_params)
	data.unit:brain():cancel_all_pathing_searches()
	local old_internal_data = data.internal_data
	local my_data = {
		unit = data.unit
	}
	my_data.detection = data.char_tweak.detection.recon
	if old_internal_data then
		my_data.attention_unit = old_internal_data.attention_unit
		if old_internal_data.nearest_cover then
			my_data.nearest_cover = old_internal_data.nearest_cover
			managers.navigation:reserve_cover(my_data.nearest_cover[1], data.pos_rsrv_id)
		end
		if old_internal_data.best_cover then
			my_data.best_cover = old_internal_data.best_cover
			managers.navigation:reserve_cover(my_data.best_cover[1], data.pos_rsrv_id)
		end
	end
	data.internal_data = my_data
	local key_str = tostring(data.key)
	if not data.unit:movement():cool() then
		my_data.detection_task_key = "TeamAILogicTravel._upd_enemy_detection" .. key_str
		CopLogicBase.queue_task(my_data, my_data.detection_task_key, TeamAILogicTravel._upd_enemy_detection, data, data.t)
	end
	my_data.cover_update_task_key = "TeamAILogicTravel._update_cover" .. key_str
	if my_data.nearest_cover or my_data.best_cover then
		CopLogicBase.add_delayed_clbk(my_data, my_data.cover_update_task_key, callback(CopLogicTravel, CopLogicTravel, "_update_cover", data), data.t + 1)
	end
	my_data.advance_path_search_id = "TeamAILogicTravel_detailed" .. tostring(data.key)
	my_data.coarse_path_search_id = "TeamAILogicTravel_coarse" .. tostring(data.key)
	my_data.path_ahead = data.team.id == tweak_data.levels:get_default_team_ID("player")
	if data.objective then
		data.objective.called = false
		my_data.called = true
		if data.objective.follow_unit then
			my_data.cover_wait_t = {0, 0}
		end
	end
	data.unit:movement():set_allow_fire(false)
	my_data.weapon_range = data.char_tweak.weapon[data.unit:inventory():equipped_unit():base():weapon_tweak_data().usage].range
	if not data.unit:movement():chk_action_forbidden("walk") or data.unit:anim_data().act_idle then
		local new_action = {type = "idle", body_part = 2}
		data.unit:brain():action_request(new_action)
	end
	if Application:production_build() then
		my_data.pathing_debug = {
			from_pos = Vector3(),
			to_pos = Vector3()
		}
	end
end

function TeamAILogicTravel.exit(data, new_logic_name, enter_params)
	TeamAILogicBase.exit(data, new_logic_name, enter_params)
	local my_data = data.internal_data
	data.unit:brain():cancel_all_pathing_searches()
	CopLogicBase.cancel_queued_tasks(my_data)
	CopLogicBase.cancel_delayed_clbks(my_data)
	if my_data.moving_to_cover then
		managers.navigation:release_cover(my_data.moving_to_cover[1])
	end
	if my_data.nearest_cover then
		managers.navigation:release_cover(my_data.nearest_cover[1])
	end
	if my_data.best_cover then
		managers.navigation:release_cover(my_data.best_cover[1])
	end
	data.brain:rem_pos_rsrv("path")
end

function TeamAILogicTravel.update(data)
	return CopLogicTravel.upd_advance(data)
end

function TeamAILogicTravel._upd_enemy_detection(data)
	data.t = TimerManager:game():time()
	local my_data = data.internal_data
	local max_reaction
	if data.cool then
		max_reaction = AIAttentionObject.REACT_SURPRISED
	end
	local delay = CopLogicBase._upd_attention_obj_detection(data, AIAttentionObject.REACT_CURIOUS, max_reaction)
	local new_attention, new_prio_slot, new_reaction = TeamAILogicIdle._get_priority_attention(data, data.detected_attention_objects, nil)
	TeamAILogicBase._set_attention_obj(data, new_attention, new_reaction)
	if new_attention then
		local objective = data.objective
		local allow_trans, obj_failed
		local dont_exit = false
		if data.unit:movement():chk_action_forbidden("walk") and not data.unit:anim_data().act_idle then
			dont_exit = true
		else
			allow_trans, obj_failed = CopLogicBase.is_obstructed(data, objective, nil, new_attention)
		end
		if obj_failed and not dont_exit then
			if objective.type == "follow" then
				debug_pause_unit(data.unit, "failing follow", allow_trans, obj_failed, inspect(objective))
			end
			data.objective_failed_clbk(data.unit, data.objective)
			return
		end
	end
	CopLogicAttack._upd_aim(data, my_data)
	if not my_data._intimidate_t or my_data._intimidate_t + 2 < data.t then
		local civ = TeamAILogicIdle.intimidate_civilians(data, data.unit, true, false)
		if civ then
			my_data._intimidate_t = data.t
			if not data.attention_obj then
				CopLogicBase._set_attention_on_unit(data, civ)
				local key = "RemoveAttentionOnUnit" .. tostring(data.key)
				CopLogicBase.queue_task(my_data, key, TeamAILogicTravel._remove_enemy_attention, {
					data = data,
					target_key = civ:key()
				}, data.t + 1.5)
			end
		end
	end
	TeamAILogicAssault._chk_request_combat_chatter(data, my_data)
	TeamAILogicIdle._upd_sneak_spotting(data, my_data)
	CopLogicBase.queue_task(my_data, my_data.detection_task_key, TeamAILogicTravel._upd_enemy_detection, data, data.t + delay)
end

function TeamAILogicTravel._remove_enemy_attention(param)
	local data = param.data
	if not data.attention_obj or data.attention_obj.u_key ~= param.target_key then
		return
	end
	CopLogicBase._reset_attention(data)
end

function TeamAILogicTravel.is_available_for_assignment(data, new_objective)
	if new_objective and new_objective.forced then
		return true
	elseif data.objective and data.objective.type == "act" then
		if (not new_objective or new_objective and new_objective.type == "free") and data.objective.interrupt_dis == -1 then
			return true
		end
		return
	else
		return TeamAILogicAssault.is_available_for_assignment(data, new_objective)
	end
end

