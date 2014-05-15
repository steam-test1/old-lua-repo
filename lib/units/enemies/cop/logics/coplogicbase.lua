local mvec3_set = mvector3.set
local mvec3_set_z = mvector3.set_z
local mvec3_sub = mvector3.subtract
local mvec3_dir = mvector3.direction
local mvec3_dot = mvector3.dot
local mvec3_dis = mvector3.distance
local mvec3_dis_sq = mvector3.distance_sq
local tmp_vec1 = Vector3()
local tmp_vec2 = Vector3()
CopLogicBase = class()
CopLogicBase._AGGRESSIVE_ALERT_TYPES = {
	footstep = true,
	bullet = true,
	vo_cbt = true,
	vo_intimidate = true,
	vo_distress = true,
	aggression = true,
	explosion = true
}
CopLogicBase._DANGEROUS_ALERT_TYPES = {
	bullet = true,
	aggression = true,
	explosion = true
}
function CopLogicBase.enter(data, new_logic_name, enter_params)
end

function CopLogicBase.exit(data, new_logic_name, enter_params)
	if data.internal_data then
		data.internal_data.exiting = true
	end

end

function CopLogicBase.action_data(data)
	return data.action_data
end

function CopLogicBase.can_activate(data)
	return true
end

function CopLogicBase.on_intimidated(data, amount, aggressor_unit)
end

function CopLogicBase.on_tied(data, aggressor_unit)
end

function CopLogicBase.on_criminal_neutralized(data, criminal_key)
end

function CopLogicBase._set_attention_on_unit(data, attention_unit)
	local attention_data = {unit = attention_unit}
	data.unit:movement():set_attention(attention_data)
end

function CopLogicBase._set_attention(data, attention_info, reaction)
	local attention_data = {
		unit = attention_info.unit,
		u_key = attention_info.u_key,
		handler = attention_info.handler,
		reaction = reaction or attention_info.reaction
	}
	data.unit:movement():set_attention(attention_data)
end

function CopLogicBase._set_attention_on_pos(data, pos)
	local attention_data = {pos = pos}
	data.unit:movement():set_attention(attention_data)
end

function CopLogicBase._reset_attention(data)
	data.unit:movement():set_attention()
end

function CopLogicBase.is_available_for_assignment(data)
	return true
end

function CopLogicBase.action_complete_clbk(data, action)
end

function CopLogicBase.damage_clbk(data, result, attack_unit)
end

function CopLogicBase.death_clbk(data, damage_info)
end

function CopLogicBase.on_alert(data, alert_data)
end

function CopLogicBase.on_area_safety(data, nav_seg, safe)
end

function CopLogicBase.draw_reserved_positions(data)
	local my_pos = data.m_pos
	local my_data = data.internal_data
	local rsrv_pos = data.pos_rsrv
	if rsrv_pos.path then
		Application:draw_cylinder(rsrv_pos.path.pos, my_pos, 6, 0, 0.3, 0.3)
	end

	if rsrv_pos.move_dest then
		Application:draw_cylinder(rsrv_pos.move_dest.pos, my_pos, 6, 0.3, 0.3, 0)
	end

	if rsrv_pos.stand then
		Application:draw_cylinder(rsrv_pos.stand.pos, my_pos, 6, 0.3, 0, 0.3)
	end

	if my_data.best_cover then
		local cover_pos = my_data.best_cover[1][5].pos
		Application:draw_cylinder(cover_pos, my_pos, 2, 0.2, 0.3, 0.6)
		Application:draw_sphere(cover_pos, 10, 0.2, 0.3, 0.6)
	end

	if my_data.nearest_cover then
		local cover_pos = my_data.nearest_cover[1][5].pos
		Application:draw_cylinder(cover_pos, my_pos, 2, 0.2, 0.6, 0.3)
		Application:draw_sphere(cover_pos, 8, 0.2, 0.6, 0.3)
	end

	if my_data.moving_to_cover then
		local cover_pos = my_data.moving_to_cover[1][5].pos
		Application:draw_cylinder(cover_pos, my_pos, 2, 0.3, 0.6, 0.2)
		Application:draw_sphere(cover_pos, 8, 0.3, 0.6, 0.2)
	end

end

function CopLogicBase.draw_reserved_covers(data)
	local my_pos = data.m_pos
	local my_data = data.internal_data
	if my_data.best_cover then
		local cover_pos = my_data.best_cover[1][5].pos
		Application:draw_cylinder(cover_pos, my_pos, 2, 0.2, 0.3, 0.6)
		Application:draw_sphere(cover_pos, 10, 0.2, 0.3, 0.6)
	end

	if my_data.nearest_cover then
		local cover_pos = my_data.nearest_cover[1][5].pos
		Application:draw_cylinder(cover_pos, my_pos, 2, 0.2, 0.6, 0.3)
		Application:draw_sphere(cover_pos, 8, 0.2, 0.6, 0.3)
	end

	if my_data.moving_to_cover then
		local cover_pos = my_data.moving_to_cover[1][5].pos
		Application:draw_cylinder(cover_pos, my_pos, 2, 0.3, 0.6, 0.2)
		Application:draw_sphere(cover_pos, 8, 0.3, 0.6, 0.2)
	end

end

function CopLogicBase._exit(unit, state_name, params)
	unit:brain():set_logic(state_name, params)
end

function CopLogicBase.on_detected_enemy_destroyed(data, enemy_unit)
end

function CopLogicBase._can_move(data)
	return true
end

function CopLogicBase._report_detections(enemies)
	local group = managers.groupai:state()
	local (for generator), (for state), (for control) = pairs(enemies)
	do
		do break end
		if data.verified and data.criminal_record then
			group:criminal_spotted(data.unit)
		end

	end

end

function CopLogicBase.on_importance(data)
end

function CopLogicBase.queue_task(internal_data, id, func, data, exec_t, asap)
	if internal_data.unit and internal_data ~= internal_data.unit:brain()._logic_data.internal_data then
		debug_pause("[CopLogicBase.queue_task] Task queued from the wrong logic", internal_data.unit, id, func, data, exec_t, asap)
	end

	local qd_tasks = internal_data.queued_tasks
	if qd_tasks then
		if qd_tasks[id] then
			debug_pause("[CopLogicBase.queue_task] Task queued twice", internal_data.unit, id, func, data, exec_t, asap)
		end

		qd_tasks[id] = true
	else
		internal_data.queued_tasks = {
			[id] = true
		}
	end

	managers.enemy:queue_task(id, func, data, exec_t, callback(CopLogicBase, CopLogicBase, "on_queued_task", internal_data), asap)
end

function CopLogicBase.cancel_queued_tasks(internal_data)
