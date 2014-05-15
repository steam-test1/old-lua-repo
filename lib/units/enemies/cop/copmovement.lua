require("lib/units/enemies/cop/actions/lower_body/CopActionIdle")
require("lib/units/enemies/cop/actions/lower_body/CopActionWalk")
require("lib/units/enemies/cop/actions/full_body/CopActionAct")
require("lib/units/enemies/cop/actions/lower_body/CopActionTurn")
require("lib/units/enemies/cop/actions/full_body/CopActionHurt")
require("lib/units/enemies/cop/actions/lower_body/CopActionStand")
require("lib/units/enemies/cop/actions/lower_body/CopActionCrouch")
require("lib/units/enemies/cop/actions/upper_body/CopActionShoot")
require("lib/units/enemies/cop/actions/upper_body/CopActionReload")
require("lib/units/enemies/cop/actions/upper_body/CopActionTase")
require("lib/units/enemies/cop/actions/full_body/CopActionDodge")
require("lib/units/enemies/spooc/actions/lower_body/ActionSpooc")
require("lib/units/civilians/actions/lower_body/CivilianActionWalk")
require("lib/units/civilians/actions/lower_body/EscortWithSuitcaseActionWalk")
require("lib/units/enemies/tank/actions/lower_body/TankCopActionWalk")
require("lib/units/player_team/actions/lower_body/CriminalActionWalk")
local ids_movement = Idstring("movement")
local mvec3_set = mvector3.set
local mvec3_set_z = mvector3.set_z
local mvec3_lerp = mvector3.lerp
local mrot_set = mrotation.set_yaw_pitch_roll
local temp_vec1 = Vector3()
local temp_vec2 = Vector3()
local temp_vec3 = Vector3()
local stance_ctl_pts = {
	0,
	0,
	1,
	1
}
CopMovement = CopMovement or class()
CopMovement._gadgets = {
	aligns = {
		hand_l = Idstring("a_weapon_left_front"),
		hand_r = Idstring("a_weapon_right_front"),
		head = Idstring("Head")
	},
	cigarette = {
		Idstring("units/world/props/cigarette/cigarette")
	},
	briefcase = {
		Idstring("units/equipment/escort_suitcase/escort_suitcase_contour")
	},
	briefcase2 = {
		Idstring("units/equipment/escort_suitcase/escort_suitcase")
	},
	iphone = {
		Idstring("units/world/props/iphone/iphone")
	},
	baton = {
		Idstring("units/payday2/characters/ene_acc_baton/ene_acc_baton")
	},
	needle = {
		Idstring("units/payday2/characters/npc_acc_syringe/npc_acc_syringe")
	},
	pencil = {
		Idstring("units/world/brushes/desk_pencil/desk_pencil")
	},
	bbq_fork = {
		Idstring("units/world/props/barbecue/bbq_fork")
	},
	money_bag = {
		Idstring("units/world/architecture/secret_stash/luggage_bag/secret_stash_luggage_bag")
	},
	newspaper = {
		Idstring("units/world/props/suburbia_newspaper/suburbia_newspaper")
	},
	vail = {
		Idstring("units/world/props/hospital_veil_interaction/hospital_veil_full")
	},
	ivstand = {
		Idstring("units/world/architecture/hospital/props/iv_pole/iv_pole")
	},
	clipboard_paper = {
		Idstring("units/world/architecture/hospital/props/clipboard01/clipboard_paper")
	}
}
local action_variants = {
	security = {
		idle = CopActionIdle,
		act = CopActionAct,
		walk = CopActionWalk,
		turn = CopActionTurn,
		hurt = CopActionHurt,
		stand = CopActionStand,
		crouch = CopActionCrouch,
		shoot = CopActionShoot,
		reload = CopActionReload,
		spooc = ActionSpooc,
		tase = CopActionTase,
		dodge = CopActionDodge
	}
}
local security_variant = action_variants.security
action_variants.gensec = security_variant
action_variants.cop = security_variant
action_variants.fbi = security_variant
action_variants.swat = security_variant
action_variants.heavy_swat = security_variant
action_variants.fbi_swat = security_variant
action_variants.fbi_heavy_swat = security_variant
action_variants.nathan = security_variant
action_variants.sniper = security_variant
action_variants.gangster = security_variant
action_variants.dealer = security_variant
action_variants.biker_escape = security_variant
action_variants.city_swat = security_variant
action_variants.shield = clone(security_variant)
action_variants.shield.hurt = ShieldActionHurt
action_variants.tank = clone(security_variant)
action_variants.tank.walk = TankCopActionWalk
action_variants.spooc = security_variant
action_variants.taser = security_variant
action_variants.civilian = {
	idle = CopActionIdle,
	act = CopActionAct,
	walk = CivilianActionWalk,
	turn = CopActionTurn,
	hurt = CopActionHurt
}
action_variants.civilian_female = action_variants.civilian
action_variants.bank_manager = action_variants.civilian
action_variants.escort = action_variants.civilian
action_variants.escort_suitcase = clone(action_variants.civilian)
action_variants.escort_suitcase.walk = EscortWithSuitcaseActionWalk
action_variants.escort_prisoner = clone(action_variants.civilian)
action_variants.escort_prisoner.walk = EscortPrisonerActionWalk
action_variants.escort_cfo = action_variants.civilian
action_variants.escort_ralph = action_variants.civilian
action_variants.escort_undercover = clone(action_variants.civilian)
action_variants.escort_undercover.walk = EscortWithSuitcaseActionWalk
action_variants.russian = clone(security_variant)
action_variants.russian.walk = CriminalActionWalk
action_variants.german = action_variants.russian
action_variants.spanish = action_variants.russian
action_variants.american = action_variants.russian
security_variant = nil
CopMovement._action_variants = action_variants
action_variants = nil
CopMovement._stance = {}
CopMovement._stance.names = {
	"ntl",
	"hos",
	"cbt",
	"wnd"
}
CopMovement._stance.blend = {
	0.8,
	0.5,
	0.3,
	0.4
}
function CopMovement:init(unit)
	self._unit = unit
	self._machine = self._unit:anim_state_machine()
	self._nav_tracker_id = self._unit:key()
	self._nav_tracker = nil
	self._root_blend_ref = 0
	self._m_pos = unit:position()
	self._m_stand_pos = mvector3.copy(self._m_pos)
	mvec3_set_z(self._m_stand_pos, self._m_pos.z + 160)
	self._m_com = math.lerp(self._m_pos, self._m_stand_pos, 0.5)
	self._obj_head = unit:get_object(Idstring("Head"))
	self._m_head_rot = self._obj_head:rotation()
	self._m_head_pos = self._obj_head:position()
	self._obj_spine = unit:get_object(Idstring("Spine1"))
	self._m_rot = unit:rotation()
	self._footstep_style = nil
	self._footstep_event = ""
	self._obj_com = unit:get_object(Idstring("Hips"))
	self._slotmask_gnd_ray = managers.slot:get_mask("AI_graph_obstacle_check")
	self._actions = self._action_variants[self._unit:base()._tweak_table]
	self._active_actions = {
		false,
		false,
		false,
		false
	}
	self._need_upd = true
	self._cool = true
	self._suppression = {value = 0}
end

function CopMovement:post_init()
	local unit = self._unit
	self._ext_brain = unit:brain()
	self._ext_network = unit:network()
	self._ext_anim = unit:anim_data()
	self._ext_base = unit:base()
	self._ext_damage = unit:character_damage()
	self._ext_inventory = unit:inventory()
	self._tweak_data = tweak_data.character[self._ext_base._tweak_table]
	tweak_data:add_reload_callback(self, self.tweak_data_clbk_reload)
	self._machine = self._unit:anim_state_machine()
	self._machine:set_callback_object(self)
	self._stance = {
		code = 1,
		name = "ntl",
		values = {
			1,
			0,
			0,
			0
		}
	}
	if managers.navigation:is_data_ready() then
		self._nav_tracker = managers.navigation:create_nav_tracker(self._m_pos)
		self._pos_rsrv_id = managers.navigation:get_pos_reservation_id()
	else
		Application:error("[CopMovement:post_init] Spawned AI unit with incomplete navigation data.")
		self._unit:set_extension_update(ids_movement, false)
	end

	self._unit:kill_mover()
	self._unit:set_driving("script")
	self._unit:unit_data().has_alarm_pager = self._tweak_data.has_alarm_pager
	self._unit:character_damage():add_listener("movement", {
		"bleedout",
		"light_hurt",
		"heavy_hurt",
		"expl_hurt",
		"hurt",
		"hurt_sick",
		"shield_knock",
		"counter_tased",
		"death",
		"fatal"
	}, callback(self, self, "damage_clbk"))
	self._unit:inventory():add_listener("movement", {"equip", "unequip"}, callback(self, self, "clbk_inventory"))
	local prim_weap_name = self._ext_base:default_weapon_name("primary")
	local sec_weap_name = self._ext_base:default_weapon_name("secondary")
	if prim_weap_name then
		self._unit:inventory():add_unit_by_name(prim_weap_name)
	end

	if sec_weap_name and sec_weap_name ~= prim_weap_name then
		self._unit:inventory():add_unit_by_name(sec_weap_name)
	end

	if self._unit:inventory():is_selection_available(2) then
		if managers.groupai:state():enemy_weapons_hot() or not self._unit:inventory():is_selection_available(1) then
			self._unit:inventory():equip_selection(2, true)
		else
			self._unit:inventory():equip_selection(1, true)
		end

	elseif self._unit:inventory():is_selection_available(1) then
		self._unit:inventory():equip_selection(1, true)
	end

	local weap_name = self._ext_base:default_weapon_name(managers.groupai:state():enemy_weapons_hot() and "primary" or "secondary")
	local fwd = self._m_rot:y()
	self._action_common_data = {
		stance = self._stance,
		pos = self._m_pos,
		rot = self._m_rot,
		fwd = fwd,
		right = self._m_rot:x(),
		unit = unit,
		machine = self._machine,
		ext_movement = self,
		ext_brain = self._ext_brain,
		ext_anim = self._ext_anim,
		ext_inventory = self._ext_inventory,
		ext_base = self._ext_base,
		ext_network = self._ext_network,
		ext_damage = self._ext_damage,
		char_tweak = self._tweak_data,
		nav_tracker = self._nav_tracker,
		active_actions = self._active_actions,
		queued_actions = self._queued_actions,
		look_vec = mvector3.copy(fwd)
	}
	self:upd_ground_ray()
	if self._gnd_ray then
		self:set_position(self._gnd_ray.position)
	end

	self:_post_init()
end

function CopMovement:_post_init()
	self:set_character_anim_variables()
	if managers.groupai:state():enemy_weapons_hot() then
		self:set_cool(false)
	else
		self:set_cool(true)
	end

	self._unit:brain():on_cool_state_changed(self._cool)
end

function CopMovement:set_character_anim_variables()
	if self._anim_global then
		self._machine:set_global(self._anim_global, 1)
	end

	if self._tweak_data.female then
		self._machine:set_global("female", 1)
	end

	if self._tweak_data.allowed_stances and not self._tweak_data.allowed_stances.ntl then
		if self._tweak_data.allowed_stances.hos then
			self:_change_stance(2)
		else
			self:_change_stance(3)
		end

	end

	if self._tweak_data.allowed_poses and not self._tweak_data.allowed_poses.stand then
		self:play_redirect("crouch")
	end

end

function CopMovement:nav_tracker()
	return self._nav_tracker
end

function CopMovement:warp_to(pos, rot)
	self._unit:warp_to(rot, pos)
end

function CopMovement:update(unit, t, dt)
	self._gnd_ray = nil
	local old_need_upd = self._need_upd
	self._need_upd = false
	self:_upd_actions(t)
	if self._need_upd ~= old_need_upd then
		unit:set_extension_update_enabled(ids_movement, self._need_upd)
	end

	if self._force_head_upd then
		self._force_head_upd = nil
		self:upd_m_head_pos()
	end

end

function CopMovement:_upd_actions(t)
-- fail 7
null
6
	local a_actions = self._active_actions
	local has_no_action = true
	do
		local (for generator), (for state), (for control) = ipairs(a_actions)
		do
			do break end
			if action then
				if action.update then
					action:update(t)
				end

				if not self._need_upd and action.need_upd then
					self._need_upd = action:need_upd()
				end

				if action.expired and action:expired() then
					a_actions[i_action] = false
					if action.on_exit then
						action:on_exit()
					end

					self._ext_brain:action_complete_clbk(action)
					self._ext_base:chk_freeze_anims()
					local (for generator), (for state), (for control) = ipairs(a_actions)
					do
						do break end
						if action then
							has_no_action = nil
					end

					else
					end

				else
					has_no_action = nil and nil
				end

			end

		end

	end

	do break end
	if not self._queued_actions or not next(self._queued_actions) then
		self:action_request({type = "idle", body_part = 1})
	end

	if not a_actions[1] and not a_actions[2] and (not self._queued_actions or not next(self._queued_actions)) and not self:chk_action_forbidden("action") then
		if a_actions[3] then
			self:action_request({type = "idle", body_part = 2})
		else
			self:action_request({type = "idle", body_part = 1})
		end

	end

	self:_upd_stance(t)
	if not self._need_upd and (self._ext_anim.base_need_upd or self._ext_anim.upper_need_upd or self._stance.transition or self._suppression.transition) then
		self._need_upd = true
	end

end

function CopMovement:_upd_stance(t)
-- fail 50
null
8
	if self._stance.transition then
		local stance = self._stance
		local transition = stance.transition
		if t > transition.next_upd_t then
			local values = stance.values
			local prog = (t - transition.start_t) / transition.duration
			if prog < 1 then
				local prog_smooth = math.clamp(math.bezier(stance_ctl_pts, prog), 0, 1)
				local v_start = transition.start_values
				local v_end = transition.end_values
				local mlerp = math.lerp
				do
					local (for generator), (for state), (for control) = ipairs(v_start)
					do
						do break end
						values[i] = mlerp(v, v_end[i], prog_smooth)
					end

				end

				transition.next_upd_t = nil and t + 0.033
			else
				do
					local (for generator), (for state), (for control) = ipairs(transition.end_values)
					do
						do break end
						values[i] = v
					end

				end

				stance.transition = nil
			end

			local names = CopMovement._stance.names
			local (for generator), (for state), (for control) = ipairs(values)
			do
				do break end
				self._machine:set_global(names[i], v)
			end

		end

	end

	(for control) = t + 0.033 and self._machine
	if self._suppression.transition then
		local suppression = self._suppression
		local transition = suppression.transition
		if t > transition.next_upd_t then
			local prog = (t - transition.start_t) / transition.duration
			if prog < 1 then
				local prog_smooth = math.clamp(math.bezier(stance_ctl_pts, prog), 0, 1)
				local val = math.lerp(transition.start_val, transition.end_val, prog_smooth)
				suppression.value = val
				self._machine:set_global("sup", val)
				transition.next_upd_t = t + 0.033
			else
				self._machine:set_global("sup", transition.end_val)
				suppression.value = transition.end_val
				suppression.transition = nil
			end

		end

	end

end

function CopMovement:on_anim_freeze(state)
	self._frozen = state
end

function CopMovement:upd_m_head_pos()
	self._obj_head:m_position(self._m_head_pos)
	self._obj_spine:m_position(self._m_com)
end

function CopMovement:set_position(pos)
	mvec3_set(self._m_pos, pos)
	mvec3_set(self._m_stand_pos, pos)
	mvec3_set_z(self._m_stand_pos, pos.z + 160)
	self._obj_head:m_position(self._m_head_pos)
	self._obj_spine:m_position(self._m_com)
	self._nav_tracker:move(pos)
	self._unit:set_position(pos)
end

function CopMovement:set_m_pos(pos)
	mvec3_set(self._m_pos, pos)
	mvec3_set(self._m_stand_pos, pos)
	mvec3_set_z(self._m_stand_pos, pos.z + 160)
	self._obj_head:m_position(self._m_head_pos)
	self._nav_tracker:move(pos)
	self._obj_spine:m_position(self._m_com)
end

function CopMovement:set_m_rot(rot)
	mrot_set(self._m_rot, rot:yaw(), 0, 0)
	self._action_common_data.fwd = rot:y()
	self._action_common_data.right = rot:x()
end

function CopMovement:set_rotation(rot)
	mrot_set(self._m_rot, rot:yaw(), 0, 0)
	self._action_common_data.fwd = rot:y()
	self._action_common_data.right = rot:x()
	self._unit:set_rotation(rot)
end

function CopMovement:m_pos()
	return self._m_pos
end

function CopMovement:m_stand_pos()
	return self._m_stand_pos
end

function CopMovement:m_com()
	return self._m_com
end

function CopMovement:m_head_pos()
	return self._m_head_pos
end

function CopMovement:m_head_rot()
	return self._obj_head:rotation()
end

function CopMovement:m_fwd()
	return self._action_common_data.fwd
end

function CopMovement:m_rot()
	return self._m_rot
end

function CopMovement:get_object(object_name)
	return self._unit:get_object(object_name)
end

function CopMovement:set_m_host_stop_pos(pos)
	mvec3_set(self._m_host_stop_pos, pos)
end

function CopMovement:m_host_stop_pos()
	return self._m_host_stop_pos
end

function CopMovement:play_redirect(redirect_name, at_time)
	local result = self._unit:play_redirect(Idstring(redirect_name), at_time)
	return result ~= Idstring("") and result
end

function CopMovement:play_state(state_name, at_time)
	local result = self._unit:play_state(Idstring(state_name), at_time)
	return result ~= Idstring("") and result
end

function CopMovement:play_state_idstr(state_name, at_time)
	local result = self._unit:play_state(state_name, at_time)
	return result ~= Idstring("") and result
end

function CopMovement:set_root_blend(state)
	if state then
		if self._root_blend_ref == 1 then
			self._machine:set_root_blending(true)
		end

		self._root_blend_ref = self._root_blend_ref - 1
	else
		if self._root_blend_ref == 0 then
			self._machine:set_root_blending(false)
		end

		self._root_blend_ref = self._root_blend_ref + 1
	end

end

function CopMovement:chk_action_forbidden(action_type)
	local t = TimerManager:game():time()
	local (for generator), (for state), (for control) = ipairs(self._active_actions)
	do
		do break end
		if action and action.chk_block and action:chk_block(action_type, t) then
			return true
		end

	end

end

function CopMovement:action_request(action_desc)
	if Network:is_server() and self._active_actions[1] and self._active_actions[1]:type() == "hurt" and self._active_actions[1]:hurt_type() == "death" then
		debug_pause_unit(self._unit, "[CopMovement:action_request] Dead man walking!!!", self._unit, inspect(action_desc))
	end

	self.has_no_action = nil
	local body_part = action_desc.body_part
	local active_actions = self._active_actions
	local interrupted_actions
	local function _interrupt_action(body_part)
		local old_action = active_actions[body_part]
		if old_action then
			active_actions[body_part] = false
			if old_action.on_exit then
				old_action:on_exit()
			end

			interrupted_actions = interrupted_actions or {}
			interrupted_actions[body_part] = old_action
		end

	end

	_interrupt_action(body_part)
	if body_part == 1 then
		_interrupt_action(2)
		_interrupt_action(3)
	elseif body_part == 2 or body_part == 3 then
		_interrupt_action(1)
	end

	if not self._actions[action_desc.type] then
		debug_pause("[CopMovement:action_request] invalid action started", inspect(self._actions), inspect(action_desc))
		return
	end

	local action, success = self._actions[action_desc.type]:new(action_desc, self._action_common_data)
	if success and (not action.expired or not action:expired()) then
		active_actions[body_part] = action
	end

	if interrupted_actions then
		local (for generator), (for state), (for control) = pairs(interrupted_actions)
		do
			do break end
			self._ext_brain:action_complete_clbk(interrupted_action)
		end

	end

	(for control) = inspect(action_desc) and self._ext_brain
	self._ext_base:chk_freeze_anims()
	return success and action
end

function CopMovement:get_action(body_part)
	return self._active_actions[body_part]
end

function CopMovement:set_attention(attention)
	if self._attention and self._attention.destroy_listener_key then
		if alive(self._attention.unit) and self._attention.unit:base() then
			self._attention.unit:base():remove_destroy_listener(self._attention.destroy_listener_key)
			self._attention.destroy_listener_key = nil
		else
			debug_pause_unit(self._unit, "[CopMovement:set_attention] could not remove destroy listener. self._attention.unit", self._attention.unit, "base", alive(self._attention.unit) and self._attention.unit:base())
		end

	end

	if attention then
		if attention.unit then
			if attention.handler then
				local attention_unit = attention.handler:unit()
				if attention_unit:id() ~= -1 then
					self._ext_network:send("set_attention", attention_unit, attention.reaction)
				else
					self._ext_network:send("cop_set_attention_pos", mvector3.copy(attention.handler:get_attention_m_pos()))
				end

			else
				local attention_unit = attention.unit
				if self._ext_network and attention_unit:id() ~= -1 then
					self._ext_network:send("cop_set_attention_unit", attention_unit)
				end

			end

			if attention.unit:base() and attention.unit:base().add_destroy_listener then
				local attention_unit = attention.unit
				local listener_key = "CopMovement" .. tostring(self._unit:key())
				attention.destroy_listener_key = listener_key
				attention_unit:base():add_destroy_listener(listener_key, callback(self, self, "attention_unit_destroy_clbk"))
			end

		elseif self._ext_network then
			self._ext_network:send("cop_set_attention_pos", attention.pos)
		end

	elseif self._attention and Network:is_server() and self._unit:id() ~= -1 then
		self._ext_network:send("cop_reset_attention")
	end

	local old_attention = self._attention
	self._attention = attention
	self._action_common_data.attention = attention
	local (for generator), (for state), (for control) = ipairs(self._active_actions)
	do
		do break end
		if action and action.on_attention then
			action:on_attention(attention, old_attention)
		end

	end

end

function CopMovement:set_stance(new_stance_name, instant, execute_queued)
	local (for generator), (for state), (for control) = ipairs(CopMovement._stance.names)
	do
		do break end
		if stance_name == new_stance_name then
			self:set_stance_by_code(i_stance, instant, execute_queued)
	end

	else
	end

end

function CopMovement:set_stance_by_code(new_stance_code, instant, execute_queued)
	if self._stance.code ~= new_stance_code then
		self._ext_network:send("set_stance", new_stance_code, instant, execute_queued)
		self:_change_stance(new_stance_code, instant)
	end

end

function CopMovement:_change_stance(stance_code, instant)
-- fail 84
null
7
	if self._tweak_data.allowed_stances then
		if stance_code == 1 and not self._tweak_data.allowed_stances.ntl then
			return
		elseif stance_code == 2 and not self._tweak_data.allowed_stances.hos then
			return
		elseif stance_code == 3 and not self._tweak_data.allowed_stances.cbt then
			return
		end

	end

	local stance = self._stance
	if instant then
		if stance.transition or stance.code ~= stance_code then
			stance.transition = nil
			stance.code = stance_code
			stance.name = CopMovement._stance.names[stance_code]
			for i = 1, 3 do
				stance.values[i] = 0
			end

			stance.values[stance_code] = 1
			local (for generator), (for state), (for control) = ipairs(stance.values)
			do
				do break end
				self._machine:set_global(CopMovement._stance.names[i], v)
			end

		end

	else
		local end_values = nil and {}
		if stance_code == 4 then
			if stance.transition then
				end_values = stance.transition.end_values
			else
				local (for generator), (for state), (for control) = ipairs(stance.values)
				do
					do break end
					end_values[i] = value
				end

			end

		elseif stance.transition then
			end_values = {
				0,
				0,
				0,
				stance.transition.end_values[4]
			}
		else
			end_values = {
				0,
				0,
				0,
				stance.values[4]
			}
		end

		end_values[stance_code] = 1
		if stance_code ~= 4 then
			stance.code = stance_code
			stance.name = CopMovement._stance.names[stance_code]
		end

		local delay
		local vis_state = self._ext_base:lod_stage()
		if vis_state then
			delay = CopMovement._stance.blend[stance_code]
			if vis_state > 2 then
				delay = delay * 0.5
			end

		else
			stance.transition = nil
			if stance_code ~= 1 then
				self:_chk_play_equip_weapon()
			end

			local names = CopMovement._stance.names
			do
				local (for generator), (for state), (for control) = ipairs(end_values)
				do
					do break end
					if v ~= stance.values[i] then
						stance.values[i] = v
						self._machine:set_global(names[i], v)
					end

				end

			end

			return
		end

		local start_values = CopMovement._stance.names[i] and {}
		do
			local (for generator), (for state), (for control) = ipairs(stance.values)
			do
				do break end
				table.insert(start_values, value)
			end

		end

		(for control) = CopMovement._stance.names[i] and table
		local t = TimerManager:game():time()
		local transition = {
			end_values = end_values,
			start_values = start_values,
			duration = delay,
			start_t = t,
			next_upd_t = t + 0.07
		}
		stance.transition = transition
	end

	if stance_code ~= 1 then
		self:_chk_play_equip_weapon()
	end

	self:enable_update()
end

function CopMovement:sync_stance(i_stance, instant, execute_queued)
	if execute_queued and (self._active_actions[1] and self._active_actions[1]:type() ~= "idle" or self._active_actions[2] and self._active_actions[2]:type() ~= "idle") then
		table.insert(self._queued_actions, {
			type = "stance",
			code = i_stance,
			instant = instant,
			block_type = "walk"
		})
		return
	end

	self:_change_stance(i_stance, instant)
	if i_stance == 1 then
		self:set_cool(true)
	else
		self:set_cool(false)
	end

end

function CopMovement:stance_name()
	return self._stance.name
end

function CopMovement:stance_code()
	return self._stance.code
end

function CopMovement:_chk_play_equip_weapon()
	if self._stance.values[1] == 1 and not self._ext_anim.equip and not self._tweak_data.no_equip_anim and not self:chk_action_forbidden("action") then
		local redir_res = self:play_redirect("equip")
		if redir_res then
			local weapon_unit = self._ext_inventory:equipped_unit()
			if weapon_unit then
				local weap_tweak = weapon_unit:base():weapon_tweak_data()
				local weapon_hold = weap_tweak.hold
				self._machine:set_parameter(redir_res, "to_" .. weapon_hold, 1)
			end

		end

	end

end

function CopMovement:set_cool(state, giveaway)
	state = state and true or false
	if not state and not managers.groupai:state():enemy_weapons_hot() then
		self._coolness_giveaway = managers.groupai:state():fetch_highest_giveaway(self._coolness_giveaway, giveaway)
	end

	if state == self._cool then
		return
	end

	local old_state = self._cool
	self._cool = state
	self._action_common_data.is_cool = state
	if not state and old_state then
		self._not_cool_t = TimerManager:game():time()
		if self._unit:unit_data().mission_element and not self._unit:unit_data().alerted_event_called then
			self._unit:unit_data().alerted_event_called = true
			self._unit:unit_data().mission_element:event("alerted", self._unit)
		end

		if Network:is_server() and not managers.groupai:state():all_criminals()[self._unit:key()] then
			managers.groupai:state():on_criminal_suspicion_progress(nil, self._unit, true)
		end

	end

	self._unit:brain():on_cool_state_changed(state)
	if not state and old_state and self._unit:unit_data().mission_element then
		self._unit:unit_data().mission_element:event("weapons_hot", self._unit)
	end

end

function CopMovement:cool()
	return self._cool
end

function CopMovement:coolness_giveaway()
	return self._coolness_giveaway
end

function CopMovement:set_giveaway(giveaway)
	self._coolness_giveaway = giveaway
end

function CopMovement:remove_giveaway()
	self._coolness_giveaway = false
end

function CopMovement:not_cool_t()
	return self._not_cool_t
end

function CopMovement:synch_attention(attention)
	if self._attention and self._attention.destroy_listener_key then
		self._attention.unit:base():remove_destroy_listener(self._attention.destroy_listener_key)
		self._attention.destroy_listener_key = nil
	end

	if attention and attention.unit and attention.unit:base() and attention.unit:base().add_destroy_listener then
		local listener_key = "CopMovement" .. tostring(self._unit:key())
		attention.destroy_listener_key = listener_key
		attention.unit:base():add_destroy_listener(listener_key, callback(self, self, "attention_unit_destroy_clbk"))
		attention.debug_unit_name = attention.unit:name()
	end

	self._attention = attention
	self._action_common_data.attention = attention
	local (for generator), (for state), (for control) = ipairs(self._active_actions)
	do
		do break end
		if action and action.on_attention then
			action:on_attention(attention)
		end

	end

end

function CopMovement:attention()
	return self._attention
end

function CopMovement:attention_unit_destroy_clbk(unit)
	if Network:is_server() then
		self:set_attention()
	else
		self:synch_attention()
	end

end

function CopMovement:set_allow_fire_on_client(state, unit)
	if Network:is_server() then
		unit:network():send_to_unit({
			state and "cop_allow_fire" or "cop_forbid_fire",
			self._unit
		})
	end

end

function CopMovement:set_allow_fire(state)
	if self._allow_fire == state then
		return
	end

	self:synch_allow_fire(state)
	if Network:is_server() then
		self._ext_network:send(state and "cop_allow_fire" or "cop_forbid_fire")
	end

	self:enable_update()
end

function CopMovement:synch_allow_fire(state)
-- fail 5
null
4
	do
		local (for generator), (for state), (for control) = pairs(self._active_actions)
		do
			do break end
			if action and action.allow_fire_clbk then
				action:allow_fire_clbk(state)
			end

		end

	end

	self._allow_fire = state
	self._action_common_data.allow_fire = state
end

function CopMovement:linked(state, physical, parent_unit)
	if state then
		self._link_data = {physical = physical, parent = parent_unit}
		parent_unit:base():add_destroy_listener("CopMovement" .. tostring(self._unit:key()), callback(self, self, "parent_clbk_unit_destroyed"))
	else
		parent_unit:base():remove_destroy_listener("CopMovement" .. tostring(self._unit:key()))
		self._link_data = nil
	end

end

function CopMovement:parent_clbk_unit_destroyed(parent_unit, key)
	self._link_data = nil
	parent_unit:base():remove_destroy_listener("CopMovement" .. tostring(self._unit:key()))
end

function CopMovement:is_physically_linked()
	return self._link_data and self._link_data.physical
end

function CopMovement:move_vec()
	return self._move_dir
end

function CopMovement:upd_ground_ray(from_pos)
	local ground_z = self._nav_tracker:field_z()
	local safe_pos = temp_vec1
	mvec3_set(temp_vec1, from_pos or self._m_pos)
	mvec3_set_z(temp_vec1, ground_z + 100)
	local down_pos = temp_vec2
	mvec3_set(temp_vec2, safe_pos)
	mvec3_set_z(temp_vec2, ground_z - 140)
	local old_pos = self._m_pos
	local new_pos = from_pos or self._m_pos
	local hit_ray
	if old_pos.z == new_pos.z then
		local gnd_ray_1 = World:raycast("ray", temp_vec1, temp_vec2, "slot_mask", self._slotmask_gnd_ray, "ray_type", "walk")
		if gnd_ray_1 then
			ground_z = math.lerp(gnd_ray_1.position.z, self._m_pos.z, 0.5)
			hit_ray = gnd_ray_1
		end

	else
		local gnd_ray_1 = World:raycast("ray", temp_vec1, temp_vec2, "slot_mask", self._slotmask_gnd_ray, "ray_type", "walk")
		local move_vec = temp_vec3
		mvec3_set(move_vec, new_pos)
		mvector3.subtract(move_vec, old_pos)
		mvec3_set_z(move_vec, 0)
		local move_vec_len = mvector3.normalize(move_vec)
		mvector3.multiply(move_vec, math.min(move_vec_len, 20))
		mvector3.add(temp_vec1, move_vec)
		mvector3.add(temp_vec2, move_vec)
		if gnd_ray_1 then
			hit_ray = gnd_ray_1
			local gnd_ray_2 = World:raycast("ray", temp_vec1, temp_vec2, "slot_mask", self._slotmask_gnd_ray, "ray_type", "walk")
			if gnd_ray_2 then
				ground_z = math.lerp(gnd_ray_1.position.z, gnd_ray_2.position.z, 0.5)
			else
				ground_z = math.lerp(gnd_ray_1.position.z, self._m_pos.z, 0.5)
			end

		else
			local gnd_ray_2 = World:raycast("ray", temp_vec1, temp_vec2, "slot_mask", self._slotmask_gnd_ray, "ray_type", "walk")
			if gnd_ray_2 then
				hit_ray = gnd_ray_2
				ground_z = math.lerp(gnd_ray_2.position.z, self._m_pos.z, 0.5)
			end

		end

	end

	local fake_ray = {
		position = new_pos:with_z(ground_z),
		ray = math.DOWN,
		unit = hit_ray and hit_ray.unit
	}
	self._action_common_data.gnd_ray = fake_ray
	self._gnd_ray = fake_ray
end

function CopMovement:on_suppressed(state)
	local suppression = self._suppression
	local end_value = state and 1 or 0
	local vis_state = self._ext_base:lod_stage()
	if vis_state and end_value ~= suppression.value then
		local t = TimerManager:game():time()
		local duration = 0.5 * math.abs(end_value - suppression.value)
		suppression.transition = {
			end_val = end_value,
			start_val = suppression.value,
			duration = duration,
			start_t = t,
			next_upd_t = t + 0.07
		}
	else
		suppression.transition = nil
		suppression.value = end_value
		self._machine:set_global("sup", end_value)
	end

	self._action_common_data.is_suppressed = state or nil
	if Network:is_server() and state and (not self._tweak_data.allowed_poses or self._tweak_data.allowed_poses.crouch) and (not self._tweak_data.allowed_poses or self._tweak_data.allowed_poses.stand) and not self:chk_action_forbidden("walk") then
		if self._ext_anim.idle and (not self._active_actions[2] or self._active_actions[2]:type() == "idle") then
			local action_desc = {
				type = "act",
				body_part = 1,
				variant = "suppressed_reaction",
				blocks = {walk = -1}
			}
			self:action_request(action_desc)
		elseif not self._ext_anim.crouch and self._tweak_data.crouch_move and (not self._tweak_data.allowed_poses or self._tweak_data.allowed_poses.crouch) then
			local action_desc = {type = "crouch", body_part = 4}
			self:action_request(action_desc)
		end

	end

	self:enable_update()
	if Network:is_server() then
		managers.network:session():send_to_peers_synched("suppressed_state", self._unit, state and true or false)
	end

end

function CopMovement:damage_clbk(my_unit, damage_info)
-- fail 49
null
6
	local hurt_type = damage_info.result.type
	if hurt_type == "death" and self._queued_actions then
		self._queued_actions = {}
	end

	if not hurt_type or Network:is_server() and self:chk_action_forbidden(hurt_type) then
		if hurt_type == "death" then
			debug_pause_unit(self._unit, "[CopMovement:damage_clbk] Death action skipped!!!", self._unit)
			Application:draw_cylinder(self._m_pos, self._m_pos + math.UP * 5000, 30, 1, 0, 0)
			print("active_actions")
			local (for generator), (for state), (for control) = ipairs(self._active_actions)
			do
				do break end
				if action then
					print(body_part, action:type(), inspect(action._blocks))
				end

			end

		end

		return
	end

	if hurt_type == "death" and self._rope then
		self._rope:base():retract()
		self._rope = nil
	end

	local attack_dir = damage_info.col_ray and damage_info.col_ray.ray or damage_info.attack_dir
	local hit_pos = damage_info.col_ray and damage_info.col_ray.position or damage_info.pos
	local lgt_hurt = hurt_type == "light_hurt"
	local body_part = lgt_hurt and 4 or 1
	local blocks
	if not lgt_hurt then
		blocks = {
			walk = -1,
			action = -1,
			act = -1,
			aim = -1,
			tase = -1
		}
		if hurt_type == "bleedout" then
			blocks.bleedout = -1
			blocks.hurt = -1
			blocks.heavy_hurt = -1
			blocks.hurt_sick = -1
		end

	end

	local block_type
	if damage_info.variant == "tase" then
		block_type = "bleedout"
	else
		block_type = hurt_type
	end

	local client_interrupt
	if Network:is_client() and (hurt_type == "light_hurt" or hurt_type == "hurt" and damage_info.variant ~= "tase" or hurt_type == "heavy_hurt" or hurt_type == "expl_hurt" or hurt_type == "shield_knock" or hurt_type == "counter_tased" or hurt_type == "death" or hurt_type == "hurt_sick") then
		client_interrupt = true
	end

	local tweak = self._tweak_data
	local action_data = {
		type = "hurt",
		block_type = block_type,
		hurt_type = hurt_type,
		variant = damage_info.variant,
		direction_vec = attack_dir,
		hit_pos = hit_pos,
		body_part = body_part,
		blocks = blocks,
		client_interrupt = client_interrupt,
		attacker_unit = damage_info.attacker_unit,
		death_type = tweak.damage.death_severity and (damage_info.damage / tweak.HEALTH_INIT > tweak.damage.death_severity and "heavy" or "normal") or "normal"
	}
	if Network:is_server() or not self:chk_action_forbidden(action_data) then
		self:action_request(action_data)
		if hurt_type == "death" and self._queued_actions then
			self._queued_actions = {}
		end

	end

end

function CopMovement:anim_clbk_footstep(unit)
	managers.game_play_central:request_play_footstep(unit, self._m_pos)
end

function CopMovement:get_footstep_event()
	local event_name
	if self._footstep_style and self._unit:anim_data()[self._footstep_style] then
		event_name = self._footstep_event
	else
		self._footstep_style = self._unit:anim_data().run and "run" or "walk"
		event_name = "footstep_npc_" .. self._footwear .. "_" .. self._footstep_style
		self._footstep_event = event_name
	end

	return event_name
end

function CopMovement:get_walk_to_pos()
	local leg_action = self._active_actions[1] or self._active_actions[2]
	if leg_action and leg_action.get_walk_to_pos then
		return leg_action:get_walk_to_pos()
	end

end

function CopMovement:anim_clbk_death_drop(...)
	local (for generator), (for state), (for control) = ipairs(self._active_actions)
	do
		do break end
		if action and action.on_death_drop then
			action:on_death_drop(...)
		end

	end

end

function CopMovement:on_death_exit()
	local (for generator), (for state), (for control) = ipairs(self._active_actions)
	do
		do break end
		if action and action.on_death_exit then
			action:on_death_exit()
		end

	end

end

function CopMovement:anim_clbk_reload_exit()
	if self._ext_inventory:equipped_unit() then
		self._ext_inventory:equipped_unit():base():on_reload()
	end

end

function CopMovement:anim_clbk_force_ragdoll()
	local (for generator), (for state), (for control) = ipairs(self._active_actions)
	do
		do break end
		if action and action.force_ragdoll then
			action:force_ragdoll()
		end

	end

end

function CopMovement:anim_clbk_rope(unit, state)
	if state == "on" then
		if self._rope then
			self._rope:base():retract()
		end

		local hips_obj = self._unit:get_object(Idstring("Hips"))
		self._rope = World:spawn_unit(Idstring("units/payday2/characters/ene_acc_rope/ene_acc_rope"), hips_obj:position(), Rotation())
		self._rope:base():setup(hips_obj)
	elseif self._rope then
		self._rope:base():retract()
		self._rope = nil
	end

end

function CopMovement:pos_rsrv_id()
	return self._pos_rsrv_id
end

function CopMovement:anim_clbk_melee_strike(unit)
	local (for generator), (for state), (for control) = pairs(self._active_actions)
	do
		do break end
		if action and action.anim_clbk_melee_strike then
			action:anim_clbk_melee_strike()
		end

	end

end

function CopMovement:anim_clbk_wanted_item(unit, item_type, align_place, droppable)
	self._wanted_items = self._wanted_items or {}
	table.insert(self._wanted_items, {
		item_type,
		align_place,
		droppable
	})
end

function CopMovement:anim_clbk_block_info(unit, preset_name, block_state)
	local state_bool = block_state == "true" and true or false
	local (for generator), (for state), (for control) = pairs(self._active_actions)
	do
		do break end
		if action and action.set_blocks then
			action:set_blocks(preset_name, state_bool)
		end

	end

end

function CopMovement:anim_clbk_ik_change(unit)
	local preset_name = self._ext_anim.base_aim_ik
	local (for generator), (for state), (for control) = pairs(self._active_actions)
	do
		do break end
		if action and action.set_ik_preset then
			action:set_ik_preset(preset_name)
		end

	end

end

function CopMovement:anim_clbk_police_called(unit)
	if Network:is_server() then
		if not managers.groupai:state():is_ecm_jammer_active("call") then
			local group_state = managers.groupai:state()
			local cop_type = tostring(group_state.blame_triggers[self._ext_base._tweak_table])
			managers.groupai:state():on_criminal_suspicion_progress(nil, self._unit, "called")
			if cop_type == "civ" then
				group_state:on_police_called(self:coolness_giveaway())
			else
				group_state:on_police_called(self:coolness_giveaway())
			end

		else
			managers.groupai:state():on_criminal_suspicion_progress(nil, self._unit, "call_interrupted")
		end

	end

end

function CopMovement:anim_clbk_stance(unit, stance_name, instant)
	self:set_stance(stance_name, instant)
end

function CopMovement:spawn_wanted_items()
