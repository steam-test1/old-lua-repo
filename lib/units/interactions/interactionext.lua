BaseInteractionExt = BaseInteractionExt or class()
BaseInteractionExt.SKILL_IDS = {}
BaseInteractionExt.SKILL_IDS.none = 1
BaseInteractionExt.SKILL_IDS.basic = 2
BaseInteractionExt.SKILL_IDS.aced = 3
BaseInteractionExt.INFO_IDS = {
	1,
	2,
	4,
	8,
	16,
	32,
	64,
	128
}
function BaseInteractionExt:init(unit)
	self._unit = unit
	self._unit:set_extension_update_enabled(Idstring("interaction"), false)
	self:refresh_material()
	self:set_tweak_data(self.tweak_data)
	self:set_active(self._tweak_data.start_active or self._tweak_data.start_active == nil and true)
	self:_upd_interaction_topology()
end

local ids_material = Idstring("material")
function BaseInteractionExt:refresh_material()
	self._materials = {}
	local all_materials = self._unit:get_objects_by_type(ids_material)
	local (for generator), (for state), (for control) = ipairs(all_materials)
	do
		do break end
		if m:variable_exists(Idstring("contour_color")) then
			table.insert(self._materials, m)
		end

	end

end

function BaseInteractionExt:external_upd_interaction_topology()
	self:_upd_interaction_topology()
end

function BaseInteractionExt:_upd_interaction_topology()
	if self._tweak_data.interaction_obj then
		self._interact_obj = self._unit:get_object(self._tweak_data.interaction_obj)
	else
		self._interact_obj = self._interact_object and self._unit:get_object(Idstring(self._interact_object))
	end

	self._interact_position = self._interact_obj and self._interact_obj:position() or self._unit:position()
	local rotation = self._interact_obj and self._interact_obj:rotation() or self._unit:rotation()
	self._interact_axis = self._tweak_data.axis and rotation[self._tweak_data.axis](rotation) or nil
	self:_update_interact_position()
	self:_setup_ray_objects()
end

function BaseInteractionExt:set_tweak_data(id)
	local contour_id = self._contour_id
	local selected_contour_id = self._selected_contour_id
	if contour_id then
		self._unit:contour():remove_by_id(contour_id)
		self._contour_id = nil
	end

	if selected_contour_id then
		self._unit:contour():remove_by_id(selected_contour_id)
		self._selected_contour_id = nil
	end

	self.tweak_data = id
	self._tweak_data = tweak_data.interaction[id]
	if self._active and self._tweak_data.contour_preset then
		self._contour_id = self._unit:contour():add(self._tweak_data.contour_preset)
	end

	if self._active and self._is_selected and self._tweak_data.contour_preset_selected then
		self._selected_contour_id = self._unit:contour():add(self._tweak_data.contour_preset_selected)
	end

	self:_upd_interaction_topology()
	if alive(managers.interaction:active_object()) and self._unit == managers.interaction:active_object() then
		self:set_dirty(true)
	end

end

function BaseInteractionExt:set_dirty(dirty)
	self._dirty = dirty
end

function BaseInteractionExt:dirty()
	return self._dirty
end

function BaseInteractionExt:interact_position()
	self:_update_interact_position()
	return self._interact_position
end

function BaseInteractionExt:interact_axis()
	self:_update_interact_axis()
	return self._interact_axis
end

function BaseInteractionExt:_setup_ray_objects()
	if self._ray_object_names then
		self._ray_objects = {
			self._interact_obj or self._unit:orientation_object()
		}
		local (for generator), (for state), (for control) = ipairs(self._ray_object_names)
		do
			do break end
			table.insert(self._ray_objects, self._unit:get_object(Idstring(object_name)))
		end

	end

end

function BaseInteractionExt:ray_objects()
	return self._ray_objects
end

function BaseInteractionExt:_update_interact_position()
	if self._unit:moving() or self._tweak_data.force_update_position then
		self._interact_position = self._interact_obj and self._interact_obj:position() or self._unit:position()
	end

end

function BaseInteractionExt:_update_interact_axis()
	if self._tweak_data.axis and self._unit:moving() then
		local rotation = self._interact_obj and self._interact_obj:rotation() or self._unit:rotation()
		self._interact_axis = self._tweak_data.axis and rotation[self._tweak_data.axis](rotation) or nil
	end

end

function BaseInteractionExt:interact_distance()
	return self._tweak_data.interact_distance or tweak_data.interaction.INTERACT_DISTANCE
end

function BaseInteractionExt:update(distance_to_player)
end

local is_PS3 = SystemInfo:platform() == Idstring("PS3")
function BaseInteractionExt:_btn_interact()
	if not managers.menu:is_pc_controller() then
		return nil
	end

	local type = managers.controller:get_default_wrapper_type()
	return "[" .. managers.controller:get_settings(type):get_connection("interact"):get_input_name_list()[1] .. "]"
end

function BaseInteractionExt:can_select(player)
	if not self:_has_required_upgrade() then
		return false
	end

	if not self:_has_required_deployable() then
		return false
	end

	if not self:_is_in_required_state() then
		return false
	end

	if self._tweak_data.special_equipment_block and managers.player:has_special_equipment(self._tweak_data.special_equipment_block) then
		return false
	end

	return true
end

function BaseInteractionExt:selected(player)
	if not self:can_select(player) then
		return
	end

	self._is_selected = true
	local string_macros = {}
	self:_add_string_macros(string_macros)
	local text_id = not self._tweak_data.text_id and alive(self._unit) and self._unit:base().interaction_text_id and self._unit:base():interaction_text_id()
	local text = managers.localization:text(text_id, string_macros)
	local icon = self._tweak_data.icon
	if self._tweak_data.special_equipment and not managers.player:has_special_equipment(self._tweak_data.special_equipment) then
		text = managers.localization:text(self._tweak_data.equipment_text_id, string_macros)
		icon = self.no_equipment_icon or self._tweak_data.no_equipment_icon or icon
	end

	if self._tweak_data.contour_preset or self._tweak_data.contour_preset_selected then
		if not self._selected_contour_id and self._tweak_data.contour_preset_selected and self._tweak_data.contour_preset ~= self._tweak_data.contour_preset_selected then
			self._selected_contour_id = self._unit:contour():add(self._tweak_data.contour_preset_selected)
		end

	else
		self:set_contour("selected_color")
	end

	managers.hud:show_interact({text = text, icon = icon})
	return true
end

function BaseInteractionExt:_add_string_macros(macros)
	macros.BTN_INTERACT = self:_btn_interact()
end

function BaseInteractionExt:unselect()
	self._is_selected = nil
	if self._tweak_data.contour_preset or self._tweak_data.contour_preset_selected then
		if self._selected_contour_id then
			self._unit:contour():remove_by_id(self._selected_contour_id)
		end

		self._selected_contour_id = nil
	else
		self:set_contour("standard_color")
	end

end

function BaseInteractionExt:_has_required_upgrade()
	if self._tweak_data.requires_upgrade then
		local category = self._tweak_data.requires_upgrade.category
		local upgrade = self._tweak_data.requires_upgrade.upgrade
		return managers.player:has_category_upgrade(category, upgrade)
	end

	return true
end

function BaseInteractionExt:_has_required_deployable()
	if self._tweak_data.required_deployable then
		return managers.player:has_deployable_left(self._tweak_data.required_deployable)
	end

	return true
end

function BaseInteractionExt:_is_in_required_state()
	return true
end

function BaseInteractionExt:_interact_say(data)
	local player = data[1]
	local say_line = data[2]
	self._interact_say_clbk = nil
	player:sound():say(say_line, true)
end

function BaseInteractionExt:interact_start(player)
	local blocked, skip_hint, custom_hint = self:_interact_blocked(player)
	if blocked then
		if not skip_hint and (custom_hint or self._tweak_data.blocked_hint) then
			managers.hint:show_hint(custom_hint or self._tweak_data.blocked_hint)
		end

		return false
	end

	local has_equipment = not self._tweak_data.special_equipment and true or managers.player:has_special_equipment(self._tweak_data.special_equipment)
	local sound = has_equipment and (self._tweak_data.say_waiting or "") or self.say_waiting
	if sound and sound ~= "" then
		local delay = (self._tweak_data.timer or 0) * managers.player:toolset_value()
		delay = delay / 3 + math.random() * delay / 3
		local say_t = Application:time() + delay
		self._interact_say_clbk = "interact_say_waiting"
		managers.enemy:add_delayed_clbk(self._interact_say_clbk, callback(self, self, "_interact_say", {player, sound}), say_t)
	end

	if self._tweak_data.timer then
		if not self:can_interact(player) then
			if self._tweak_data.blocked_hint then
				managers.hint:show_hint(self._tweak_data.blocked_hint)
			end

			return false
		end

		local timer = self:_get_timer()
		if timer ~= 0 then
			self:_post_event(player, "sound_start")
			self:_at_interact_start(player, timer)
			return false, timer
		end

	end

	return self:interact(player)
end

function BaseInteractionExt:_get_timer()
	local modified_timer = self:_get_modified_timer()
	if modified_timer then
		return modified_timer
	end

	local multiplier = 1
	if self._tweak_data.upgrade_timer_multiplier then
		multiplier = managers.player:upgrade_value(self._tweak_data.upgrade_timer_multiplier.category, self._tweak_data.upgrade_timer_multiplier.upgrade, 1)
	end

	if managers.player:has_category_upgrade("player", "level_interaction_timer_multiplier") then
		local data = managers.player:upgrade_value("player", "level_interaction_timer_multiplier") or {}
		local player_level = managers.experience:current_level() or 0
		multiplier = multiplier * (1 - (data[1] or 0) * math.ceil(player_level / (data[2] or 1)))
	end

	return self._tweak_data.timer * multiplier * managers.player:toolset_value()
end

function BaseInteractionExt:_get_modified_timer()
	return nil
end

function BaseInteractionExt:check_interupt()
	return false
end

function BaseInteractionExt:interact_interupt(player, complete)
	local tweak_data_id = self._tweak_data_at_interact_start ~= self.tweak_data and self._tweak_data_at_interact_start
	self:_post_event(player, "sound_interupt", tweak_data_id)
	if self._interact_say_clbk then
		managers.enemy:remove_delayed_clbk(self._interact_say_clbk)
		self._interact_say_clbk = nil
	end

	self:_at_interact_interupt(player, complete)
end

function BaseInteractionExt:_post_event(player, sound_type, tweak_data_id)
	if not alive(player) then
		return
	end

	if player ~= managers.player:player_unit() then
		return
	end

	local tweak_data_table = self._tweak_data
	if tweak_data_id then
		tweak_data_table = tweak_data.interaction[tweak_data_id]
	end

	if tweak_data_table[sound_type] then
		player:sound():play(tweak_data_table[sound_type])
	end

end

function BaseInteractionExt:_at_interact_start()
	self._tweak_data_at_interact_start = self.tweak_data
end

function BaseInteractionExt:_at_interact_interupt(player, complete)
	self._tweak_data_at_interact_start = nil
end

function BaseInteractionExt:interact(player)
	self._tweak_data_at_interact_start = nil
	self:_post_event(player, "sound_done")
end

function BaseInteractionExt:can_interact(player)
	if not self:_has_required_upgrade() then
		return false
	end

	if not self:_has_required_deployable() then
		return false
	end

	if self._tweak_data.special_equipment_block and managers.player:has_special_equipment(self._tweak_data.special_equipment_block) then
		return false
	end

	if not self._tweak_data.special_equipment or self._tweak_data.dont_need_equipment then
		return true
	end

	return managers.player:has_special_equipment(self._tweak_data.special_equipment)
end

function BaseInteractionExt:_interact_blocked(player)
	return false
end

function BaseInteractionExt:active()
	return self._active
end

function BaseInteractionExt:set_active(active, sync)
	if not active and self._active then
		managers.interaction:remove_object(self._unit)
		if self._tweak_data.contour_preset or self._tweak_data.contour_preset_selected then
			if self._contour_id and self._unit:contour() then
				self._unit:contour():remove_by_id(self._contour_id)
			end

			self._contour_id = nil
			if self._selected_contour_id and self._unit:contour() then
				self._unit:contour():remove_by_id(self._selected_contour_id)
			end

			self._selected_contour_id = nil
		elseif not self._tweak_data.no_contour then
			managers.occlusion:add_occlusion(self._unit)
		end

		self._is_selected = nil
	elseif active and not self._active then
		managers.interaction:add_object(self._unit)
		if self._tweak_data.contour_preset then
			if not self._contour_id then
				self._contour_id = self._unit:contour():add(self._tweak_data.contour_preset)
			end

		elseif not self._tweak_data.no_contour then
			managers.occlusion:remove_occlusion(self._unit)
		end

	end

	self._active = active
	if not self._tweak_data.contour_preset then
		self:set_contour("standard_color")
	end

	if sync and managers.network:session() then
		local u_id = self._unit:id()
		if u_id == -1 then
			local u_data = managers.enemy:get_corpse_unit_data_from_key(self._unit:key())
			if u_data then
				u_id = u_data.u_id
			else
				debug_pause_unit(self._unit, "[BaseInteractionExt:set_active] could not sync interaction state.", self._unit)
				return
			end

		end

		managers.network:session():send_to_peers_synched("interaction_set_active", self._unit, u_id, active, self.tweak_data, self._unit:contour() and self._unit:contour():is_flashing() or false)
	end

end

function BaseInteractionExt:set_outline_flash_state(state, sync)
	if self._contour_id then
		self._unit:contour():flash(self._contour_id, state and self._tweak_data.contour_flash_interval or nil)
		self:set_active(self._active, sync)
	end

end

function BaseInteractionExt:set_assignment(name)
	self._assignment = name
end

local ids_contour_color = Idstring("contour_color")
local ids_contour_opacity = Idstring("contour_opacity")
function BaseInteractionExt:set_contour(color, opacity)
	if self._tweak_data.no_contour or self._contour_override then
		return
	end

	local (for generator), (for state), (for control) = ipairs(self._materials)
	do
		do break end
		m:set_variable(ids_contour_color, tweak_data.contour[self._tweak_data.contour or "interactable"][color])
		m:set_variable(ids_contour_opacity, opacity or self._active and 1 or 0)
	end

end

function BaseInteractionExt:set_contour_override(state)
	self._contour_override = state
end

function BaseInteractionExt:save(data)
	local state = {}
	state.active = self._active
	if self.drop_in_sync_tweak_data then
		state.tweak_data = self.tweak_data
	end

	if self._unit:contour() and self._unit:contour():is_flashing() then
		state.is_flashing = true
	end

	data.InteractionExt = state
end

function BaseInteractionExt:load(data)
	local state = data.InteractionExt
	if state then
		self:set_active(state.active)
		if state.tweak_data then
			self:set_tweak_data(state.tweak_data)
		end

		if state.is_flashing and self._contour_id then
			self._unit:contour():flash(self._contour_id, self._tweak_data.contour_flash_interval)
		end

	end

end

function BaseInteractionExt:remove_interact()
	if not managers.interaction:active_object() or self._unit == managers.interaction:active_object() then
		managers.hud:remove_interact()
	end

end

function BaseInteractionExt:destroy()
