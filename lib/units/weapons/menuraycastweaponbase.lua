NewRaycastWeaponBase = NewRaycastWeaponBase or class()
function NewRaycastWeaponBase:init(unit)
	self._unit = unit
end

function NewRaycastWeaponBase:set_factory_data(factory_id)
	self._factory_id = factory_id
end

function NewRaycastWeaponBase:set_texture_switches(texture_switches)
	self._texture_switches = texture_switches
end

function NewRaycastWeaponBase:set_npc(npc)
	self._npc = npc
end

function NewRaycastWeaponBase:is_npc()
	return self._npc or false
end

function NewRaycastWeaponBase:assemble(factory_id, skip_queue)
	local third_person = self:is_npc()
	self._parts, self._blueprint = managers.weapon_factory:assemble_default(factory_id, self._unit, third_person, callback(self, self, "_assemble_completed", function()
	end
), skip_queue)
	self:_update_stats_values()
	do return end
	local third_person = self:is_npc()
	self._parts, self._blueprint = managers.weapon_factory:assemble_default(factory_id, self._unit, third_person)
	self:_update_fire_object()
	self:_update_stats_values()
end

function NewRaycastWeaponBase:assemble_from_blueprint(factory_id, blueprint, skip_queue, clbk)
	local third_person = self:is_npc()
	self._parts, self._blueprint = managers.weapon_factory:assemble_from_blueprint(factory_id, self._unit, blueprint, third_person, callback(self, self, "_assemble_completed", clbk or function()
	end
), skip_queue)
	self:_update_stats_values()
	do return end
	local third_person = self:is_npc()
	self._parts, self._blueprint = managers.weapon_factory:assemble_from_blueprint(factory_id, self._unit, blueprint, third_person)
	self:_update_fire_object()
	self:_update_stats_values()
end

function NewRaycastWeaponBase:_assemble_completed(clbk, parts, blueprint)
	self._parts = parts
	self._blueprint = blueprint
	self:apply_texture_switches()
	self:_update_fire_object()
	self:_update_stats_values()
	if clbk then
		clbk()
	end

end

function NewRaycastWeaponBase:apply_texture_switches()
	local parts_tweak = tweak_data.weapon.factory.parts
	self._parts_texture_switches = self._parts_texture_switches or {}
	if self._texture_switches then
		local texture_switch, part_data, unit, material_ids, material_config, switch_material
		local (for generator), (for state), (for control) = pairs(self._texture_switches)
		do
			do break end
			if self._parts_texture_switches[part_id] ~= texture_data then
				switch_material = nil
				texture_switch = parts_tweak[part_id] and parts_tweak[part_id].texture_switch
				part_data = self._parts and self._parts[part_id]
				if texture_switch and part_data then
					unit = part_data.unit
					material_ids = Idstring(texture_switch.material)
					material_config = unit:get_objects_by_type(Idstring("material"))
					do
						local (for generator), (for state), (for control) = ipairs(material_config)
						do
							do break end
							print(material:name())
							if material:name() == material_ids then
								switch_material = material
						end

						else
						end

					end

					Application:debug(switch_material)
					if switch_material then
						local texture_id = managers.blackmarket:get_texture_switch_from_data(texture_data, part_id)
						if texture_id and DB:has(Idstring("texture"), texture_id) then
							local retrieved_texture = TextureCache:retrieve(texture_id, "normal")
							switch_material:set_texture(texture_switch.channel, retrieved_texture)
							if self._parts_texture_switches[part_id] then
								TextureCache:unretrieve(Idstring(self._parts_texture_switches[part_id]))
							end

							self._parts_texture_switches[part_id] = Idstring(texture_id)
						else
							Application:error("[NewRaycastWeaponBase:apply_texture_switches] Switch texture do not exists", texture_id)
						end

					end

				end

			end

		end

	end

end

function NewRaycastWeaponBase:check_npc()
end

function NewRaycastWeaponBase:change_part(part_id)
	self._parts = managers.weapon_factory:change_part(self._unit, self._factory_id, part_id or "wpn_fps_m4_uupg_b_sd", self._parts, self._blueprint)
	self:_update_fire_object()
	self:_update_stats_values()
end

function NewRaycastWeaponBase:remove_part(part_id)
	self._parts = managers.weapon_factory:remove_part(self._unit, self._factory_id, part_id, self._parts, self._blueprint)
	self:_update_fire_object()
	self:_update_stats_values()
end

function NewRaycastWeaponBase:remove_part_by_type(type)
	self._parts = managers.weapon_factory:remove_part_by_type(self._unit, self._factory_id, type, self._parts, self._blueprint)
	self:_update_fire_object()
	self:_update_stats_values()
end

function NewRaycastWeaponBase:change_blueprint(blueprint)
	self._blueprint = blueprint
	self._parts = managers.weapon_factory:change_blueprint(self._unit, self._factory_id, self._parts, blueprint)
	self:_update_fire_object()
	self:_update_stats_values()
end

function NewRaycastWeaponBase:blueprint_to_string()
	local s = managers.weapon_factory:blueprint_to_string(self._factory_id, self._blueprint)
	return s
end

function NewRaycastWeaponBase:_update_fire_object()
	if not managers.weapon_factory:get_part_from_weapon_by_type("barrel_ext", self._parts) and not managers.weapon_factory:get_part_from_weapon_by_type("slide", self._parts) then
		local fire = managers.weapon_factory:get_part_from_weapon_by_type("barrel", self._parts)
	end

end

function NewRaycastWeaponBase:_update_stats_values()
	do return end
	local base_stats = self:weapon_tweak_data().stats
	if not base_stats then
		return
	end

	local parts_stats = managers.weapon_factory:get_stats(self._factory_id, self._blueprint)
	self._silencer = managers.weapon_factory:has_perk("silencer", self._factory_id, self._blueprint)
	local stats = deep_clone(base_stats)
	local tweak_data = tweak_data.weapon.stats
	local modifier_stats = self:weapon_tweak_data().stats_modifiers
	if stats.zoom then
		stats.zoom = math.min(stats.zoom + managers.player:upgrade_value(self:weapon_tweak_data().category, "zoom_increase", 0), #tweak_data.zoom)
	end

	do
		local (for generator), (for state), (for control) = pairs(stats)
		do
			do break end
			if parts_stats[stat] then
				stats[stat] = math_clamp(stats[stat] + parts_stats[stat], 1, #tweak_data[stat])
			end

			stats[stat] = math_clamp(stats[stat], 1, #tweak_data[stat])
		end

	end

	self._current_stats = {}
	do
		local (for generator), (for state), (for control) = pairs(stats)
		do
			do break end
			self._current_stats[stat] = tweak_data[stat][i]
			if modifier_stats and modifier_stats[stat] then
				self._current_stats[stat] = self._current_stats[stat] * modifier_stats[stat]
			end

		end

	end

	self._alert_size = self._current_stats.alert_size or self._alert_size
	self._suppression = self._current_stats.suppression or self._suppression
	self._zoom = self._current_stats.zoom or self._zoom
	self._spread = self._current_stats.spread or self._spread
	self._recoil = self._current_stats.recoil or self._recoil
	self._spread_moving = self._current_stats.spread_moving or self._spread_moving
end

function NewRaycastWeaponBase:stance_id()
	return "new_m4"
end

function NewRaycastWeaponBase:weapon_hold()
	return self:weapon_tweak_data().weapon_hold
end

function NewRaycastWeaponBase:stance_mod()
	if not self._parts then
		return nil
	end

	local factory = tweak_data.weapon.factory
	do
		local (for generator), (for state), (for control) = pairs(self._parts)
		do
			do break end
			if factory.parts[part_id].stance_mod and factory.parts[part_id].stance_mod[self._factory_id] then
				return {
					translation = factory.parts[part_id].stance_mod[self._factory_id].translation
				}
			end

		end

	end

	return nil
end

function NewRaycastWeaponBase:tweak_data_anim_play(anim, speed_multiplier)
	local data = tweak_data.weapon.factory[self._factory_id]
	if data.animations and data.animations[anim] then
		local anim_name = data.animations[anim]
		local length = self._unit:anim_length(Idstring(anim_name))
		speed_multiplier = speed_multiplier or 1
		self._unit:anim_stop(Idstring(anim_name))
		self._unit:anim_play_to(Idstring(anim_name), length, speed_multiplier)
	end

	do
		local (for generator), (for state), (for control) = pairs(self._parts)
		do
			do break end
			if data.animations and data.animations[anim] then
				local anim_name = data.animations[anim]
				local length = data.unit:anim_length(Idstring(anim_name))
				speed_multiplier = speed_multiplier or 1
				data.unit:anim_stop(Idstring(anim_name))
				data.unit:anim_play_to(Idstring(anim_name), length, speed_multiplier)
			end

		end

	end

	return true
end

function NewRaycastWeaponBase:tweak_data_anim_stop(anim)
	local data = tweak_data.weapon.factory[self._factory_id]
	if data.animations and data.animations[anim] then
		local anim_name = data.animations[anim]
		self._unit:anim_stop(Idstring(anim_name))
	end

	local (for generator), (for state), (for control) = pairs(self._parts)
	do
		do break end
		if data.animations and data.animations[anim] then
			local anim_name = data.animations[anim]
			data.unit:anim_stop(Idstring(anim_name))
		end

	end

end

function NewRaycastWeaponBase:_set_parts_enabled(enabled)
	if self._parts then
		local (for generator), (for state), (for control) = pairs(self._parts)
		do
			do break end
			if alive(data.unit) then
				data.unit:set_enabled(enabled)
			end

		end

	end

end

function NewRaycastWeaponBase:on_enabled(...)
	NewRaycastWeaponBase.super.on_enabled(self, ...)
	self:_set_parts_enabled(true)
end

function NewRaycastWeaponBase:on_disabled(...)
	self:gadget_off()
	self:_set_parts_enabled(false)
end

function NewRaycastWeaponBase:has_gadget()
	return managers.weapon_factory:get_part_from_weapon_by_type("gadget", self._parts) and true or false
end

function NewRaycastWeaponBase:gadget_on()
	self._gadget_on = true
	local gadget = managers.weapon_factory:get_part_from_weapon_by_type("gadget", self._parts)
	if gadget then
		gadget.unit:base():set_state(self._gadget_on)
	end

end

function NewRaycastWeaponBase:gadget_off()
	self._gadget_on = false
	local gadget = managers.weapon_factory:get_part_from_weapon_by_type("gadget", self._parts)
	if gadget then
		gadget.unit:base():set_state(self._gadget_on)
	end

end

function NewRaycastWeaponBase:toggle_gadget()
	self._gadget_on = not self._gadget_on
	local gadget = managers.weapon_factory:get_part_from_weapon_by_type("gadget", self._parts)
	if gadget then
		gadget.unit:base():set_state(self._gadget_on)
	end

end

function NewRaycastWeaponBase:toggle_firemode()
end

function NewRaycastWeaponBase:check_stats()
	local base_stats = self:weapon_tweak_data().stats
	if not base_stats then
		print("no stats")
		return
	end

	local parts_stats = managers.weapon_factory:get_stats(self._factory_id, self._blueprint)
	local stats = deep_clone(base_stats)
	local tweak_data = tweak_data.weapon.stats
	local modifier_stats = self:weapon_tweak_data().stats_modifiers
	stats.zoom = math.min(stats.zoom + managers.player:upgrade_value(self:weapon_tweak_data().category, "zoom_increase", 0), #tweak_data.zoom)
	do
		local (for generator), (for state), (for control) = pairs(stats)
		do
			do break end
			if parts_stats[stat] then
				stats[stat] = math_clamp(stats[stat] + parts_stats[stat], 1, #tweak_data[stat])
			end

		end

	end

	self._current_stats = {}
	do
		local (for generator), (for state), (for control) = pairs(stats)
		do
			do break end
			self._current_stats[stat] = tweak_data[stat][i]
			if modifier_stats and modifier_stats[stat] then
				self._current_stats[stat] = self._current_stats[stat] * modifier_stats[stat]
			end

		end

	end

	self._current_stats.alert_size = tweak_data.alert_size[math_clamp(stats.alert_size, 1, #tweak_data.alert_size)]
	if modifier_stats and modifier_stats.alert_size then
		self._current_stats.alert_size = self._current_stats.alert_size * modifier_stats.alert_size
	end

	return stats
end

function NewRaycastWeaponBase:spread_multiplier()
	local multiplier = NewRaycastWeaponBase.super.spread_multiplier(self)
	if self._silencer then
		multiplier = multiplier * managers.player:upgrade_value("weapon", "silencer_spread_multiplier", 1)
		multiplier = multiplier * managers.player:upgrade_value(self:weapon_tweak_data().category, "silencer_spread_multiplier", 1)
	end

	return multiplier
end

function NewRaycastWeaponBase:recoil_multiplier()
	local multiplier = NewRaycastWeaponBase.super.recoil_multiplier(self)
	multiplier = multiplier * managers.player:upgrade_value("weapon", "passive_recoil_multiplier", 1)
	if self._silencer then
		multiplier = multiplier * managers.player:upgrade_value("weapon", "silencer_recoil_multiplier", 1)
		multiplier = multiplier * managers.player:upgrade_value(self:weapon_tweak_data().category, "silencer_recoil_multiplier", 1)
	end

	return multiplier
end

function NewRaycastWeaponBase:enter_steelsight_speed_multiplier()
	local multiplier = NewRaycastWeaponBase.super.enter_steelsight_speed_multiplier(self)
	if self._silencer then
		multiplier = multiplier * managers.player:upgrade_value("weapon", "silencer_enter_steelsight_speed_multiplier", 1)
		multiplier = multiplier * managers.player:upgrade_value(self:weapon_tweak_data().category, "silencer_enter_steelsight_speed_multiplier", 1)
	end

	return multiplier
end

function NewRaycastWeaponBase:destroy(unit)
	if self._parts_texture_switches then
		local (for generator), (for state), (for control) = pairs(self._parts_texture_switches)
		do
			do break end
			TextureCache:unretrieve(texture_ids)
		end

	end

	managers.weapon_factory:disassemble(self._parts)
end

