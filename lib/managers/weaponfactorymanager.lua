local ids_unit = Idstring("unit")
WeaponFactoryManager = WeaponFactoryManager or class()
WeaponFactoryManager._uses_tasks = false
WeaponFactoryManager._uses_streaming = true
function WeaponFactoryManager:init()
	self:_setup()
	self._tasks = {}
end

function WeaponFactoryManager:_setup()
	if not Global.weapon_factory then
		Global.weapon_factory = {}
	end

	self._global = Global.weapon_factory
	Global.weapon_factory.loaded_packages = Global.weapon_factory.loaded_packages or {}
	self._loaded_packages = Global.weapon_factory.loaded_packages
	self:_read_factory_data()
end

function WeaponFactoryManager:update(t, dt)
	if self._active_task then
		if self:_update_task(self._active_task) then
			self._active_task = nil
			self:_check_task()
		end

	elseif next(self._tasks) then
		self:_check_task()
	end

end

function WeaponFactoryManager:_read_factory_data()
	self._parts_by_type = {}
	local weapon_data = tweak_data.weapon
	do
		local (for generator), (for state), (for control) = pairs(tweak_data.weapon.factory.parts)
		do
			do break end
			self._parts_by_type[data.type] = self._parts_by_type[data.type] or {}
			self._parts_by_type[data.type][id] = true
		end

	end

	self._parts_by_weapon = {}
	self._part_used_by_weapons = {}
	local (for generator), (for state), (for control) = pairs(tweak_data.weapon.factory)
	do
		do break end
		if factory_id ~= "parts" then
			self._parts_by_weapon[factory_id] = self._parts_by_weapon[factory_id] or {}
			local (for generator), (for state), (for control) = ipairs(data.uses_parts)
			do
				do break end
				local type = tweak_data.weapon.factory.parts[part_id].type
				self._parts_by_weapon[factory_id][type] = self._parts_by_weapon[factory_id][type] or {}
				table.insert(self._parts_by_weapon[factory_id][type], part_id)
				if not string.match(factory_id, "_npc") and weapon_data[self:get_weapon_id_by_factory_id(factory_id)] then
					self._part_used_by_weapons[part_id] = self._part_used_by_weapons[part_id] or {}
					table.insert(self._part_used_by_weapons[part_id], factory_id)
				end

			end

		end

	end

end

function WeaponFactoryManager:get_all_weapon_categories()
	local weapon_categories = {}
	local weapon_data = tweak_data.weapon
	local category
	do
		local (for generator), (for state), (for control) = pairs(tweak_data.weapon.factory)
		do
			do break end
			if factory_id ~= "parts" and not string.match(factory_id, "_npc") and weapon_data[self:get_weapon_id_by_factory_id(factory_id)] then
				category = weapon_data[self:get_weapon_id_by_factory_id(factory_id)].category
				weapon_categories[category] = weapon_categories[category] or {}
				table.insert(weapon_categories[category], factory_id)
			end

		end

	end

	return weapon_categories
end

function WeaponFactoryManager:get_all_weapon_families()
	local weapon_families = {}
	local weapon_data = tweak_data.weapon
	do
		local (for generator), (for state), (for control) = pairs(tweak_data.weapon.factory)
		do
			do break end
			if factory_id ~= "parts" and not string.match(factory_id, "_npc") and weapon_data[self:get_weapon_id_by_factory_id(factory_id)] and data.family then
				weapon_families[data.family] = weapon_families[data.family] or {}
				table.insert(weapon_families[data.family], factory_id)
			else
			end

		end

	end

	return weapon_families
end

function WeaponFactoryManager:get_weapons_uses_part(part_id)
	return self._part_used_by_weapons[part_id]
end

function WeaponFactoryManager:get_weapon_id_by_factory_id(factory_id)
	local upgrade = managers.upgrades:weapon_upgrade_by_factory_id(factory_id)
	if not upgrade then
		Application:error("[WeaponFactoryManager:get_weapon_id_by_factory_id] Found no upgrade for factory id", factory_id)
		return
	end

	return upgrade.weapon_id
end

function WeaponFactoryManager:get_weapon_name_by_weapon_id(weapon_id)
	if not tweak_data.weapon[weapon_id] then
		return
	end

	return managers.localization:text(tweak_data.weapon[weapon_id].name_id)
end

function WeaponFactoryManager:get_weapon_name_by_factory_id(factory_id)
	local upgrade = managers.upgrades:weapon_upgrade_by_factory_id(factory_id)
	if not upgrade then
		Application:error("[WeaponFactoryManager:get_weapon_name_by_factory_id] Found no upgrade for factory id", factory_id)
		return
	end

	local weapon_id = upgrade.weapon_id
	return managers.localization:text(tweak_data.weapon[weapon_id].name_id)
end

function WeaponFactoryManager:get_factory_id_by_weapon_id(weapon_id)
	local upgrade = managers.upgrades:weapon_upgrade_by_weapon_id(weapon_id)
	if not upgrade then
		Application:error("[WeaponFactoryManager:get_factory_id_by_weapon_id] Found no upgrade for factory id", weapon_id)
		return
	end

	return upgrade.factory_id
end

function WeaponFactoryManager:get_default_blueprint_by_factory_id(factory_id)
	return tweak_data.weapon.factory[factory_id] and tweak_data.weapon.factory[factory_id].default_blueprint or {}
end

function WeaponFactoryManager:create_limited_blueprints(factory_id)
	local i_table = self:_indexed_parts(factory_id)
	local all_parts_used_once = {}
	for j = 1, #i_table do
		for k = j == 1 and 1 or 2, #i_table[j].parts do
			local perm = {}
			local part = i_table[j].parts[k]
			if part ~= "" then
				table.insert(perm, i_table[j].parts[k])
			end

			for l = 1, #i_table do
				if j ~= l then
					local part = i_table[l].parts[1]
					if part ~= "" then
						table.insert(perm, i_table[l].parts[1])
					end

				end

			end

			table.insert(all_parts_used_once, perm)
		end

	end

	print("Limited", #all_parts_used_once)
	return all_parts_used_once
end

function WeaponFactoryManager:create_blueprints(factory_id)
	local i_table = self:_indexed_parts(factory_id)
	local function dump(i_category, result, new_combination_in)
		local (for generator), (for state), (for control) = ipairs(i_table[i_category].parts)
		do
			do break end
			local new_combination = clone(new_combination_in)
			if pryl_name ~= "" then
				table.insert(new_combination, pryl_name)
			end

			if i_category == #i_table then
				table.insert(result, new_combination)
			else
				dump(i_category + 1, result, new_combination)
			end

		end

	end

	local result = {}
	dump(1, result, {})
	print("Combinations", #result)
	return result
end

function WeaponFactoryManager:_indexed_parts(factory_id)
	local i_table = {}
	local all_parts = self._parts_by_weapon[factory_id]
	local optional_types = tweak_data.weapon.factory[factory_id].optional_types or {}
	local num_variations = 1
	local tot_parts = 0
	do
		local (for generator), (for state), (for control) = pairs(all_parts)
		do
			do break end
			print(type, parts)
			if type ~= "foregrip_ext" and type ~= "stock_adapter" and type ~= "sight_special" and type ~= "extra" then
				parts = clone(parts)
				if table.contains(optional_types, type) then
					table.insert(parts, "")
				end

				table.insert(i_table, {
					parts = parts,
					i = 1,
					amount = #parts
				})
				num_variations = num_variations * #parts
				tot_parts = tot_parts + #parts
			end

		end

	end

	print("num_variations", num_variations, "tot_parts", tot_parts)
	return i_table
end

function WeaponFactoryManager:_check_task()
	if not self._active_task and #self._tasks > 0 then
		self._active_task = table.remove(self._tasks, 1)
		if not alive(self._active_task.p_unit) then
			self._active_task = nil
			self:_check_task()
		end

	end

end

function WeaponFactoryManager:preload_blueprint(factory_id, blueprint, third_person, done_cb, only_record)
	return self:_preload_blueprint(factory_id, blueprint, third_person, done_cb, only_record)
end

function WeaponFactoryManager:_preload_blueprint(factory_id, blueprint, third_person, done_cb, only_record)
	if not done_cb then
		Application:error("[WeaponFactoryManager] _preload_blueprint(): No done_cb!", "factory_id: " .. factory_id, "blueprint: " .. inspect(blueprint))
		Application:stack_dump()
	end

	local factory = tweak_data.weapon.factory
	local factory_weapon = factory[factory_id]
	local forbidden = self:_get_forbidden_parts(factory_id, blueprint)
	return self:_preload_parts(factory_id, factory_weapon, blueprint, forbidden, third_person, done_cb, only_record)
end

function WeaponFactoryManager:_preload_parts(factory_id, factory_weapon, blueprint, forbidden, third_person, done_cb, only_record)
	local parts = {}
	local need_parent = {}
	local override = self:_get_override_parts(factory_id, blueprint)
	local async_task_data
	if not only_record and self._uses_streaming then
		async_task_data = {
			third_person = third_person,
			parts = parts,
			done_cb = done_cb,
			blueprint = blueprint,
			spawn = false
		}
		self._async_load_tasks = self._async_load_tasks or {}
		self._async_load_tasks[async_task_data] = true
	end

	do
		local (for generator), (for state), (for control) = ipairs(blueprint)
		do
			do break end
			self:_preload_part(factory_id, part_id, forbidden, override, parts, third_person, need_parent, done_cb, async_task_data, only_record)
		end

	end

	do
		local (for generator), (for state), (for control) = ipairs(need_parent)
		do
			do break end
			self:_preload_part(factory_id, part_id, forbidden, override, parts, third_person, need_parent, done_cb, async_task_data, only_record)
		end

	end

	if async_task_data then
		async_task_data.all_requests_sent = true
		self:clbk_part_unit_loaded(async_task_data, false, Idstring(), Idstring())
	else
		done_cb(parts, blueprint)
	end

	return parts, blueprint
end

function WeaponFactoryManager:get_assembled_blueprint(factory_id, blueprint)
	local assembled_blueprint = {}
	local factory = tweak_data.weapon.factory
	local forbidden = self:_get_forbidden_parts(factory_id, blueprint)
	local override = self:_get_override_parts(factory_id, blueprint)
	do
		local (for generator), (for state), (for control) = ipairs(blueprint)
		do
			do break end
			if not forbidden[part_id] then
				local part = self:_part_data(part_id, factory_id, override)
				local original_part = factory.parts[part_id] or part
				if factory[factory_id].adds and factory[factory_id].adds[part_id] then
					local add_blueprint = self:get_assembled_blueprint(factory_id, factory[factory_id].adds[part_id]) or {}
					local (for generator), (for state), (for control) = ipairs(add_blueprint)
					do
						do break end
						table.insert(assembled_blueprint, d)
					end

				end

				if part.adds_type then
					local (for generator), (for state), (for control) = ipairs(part.adds_type)
					do
						do break end
						local add_id = factory[factory_id][add_type]
						table.insert(assembled_blueprint, add_id)
					end

				end

				if part.adds then
					local (for generator), (for state), (for control) = ipairs(part.adds)
					do
						do break end
						table.insert(assembled_blueprint, add_id)
					end

				end

				table.insert(assembled_blueprint, part_id)
			end

		end

	end

	return assembled_blueprint
end

function WeaponFactoryManager:_preload_part(factory_id, part_id, forbidden, override, parts, third_person, need_parent, done_cb, async_task_data, only_record)
	if forbidden[part_id] then
		return
	end

	local factory = tweak_data.weapon.factory
	local part = self:_part_data(part_id, factory_id, override)
	local original_part = factory.parts[part_id] or part
	if factory[factory_id].adds and factory[factory_id].adds[part_id] then
		local (for generator), (for state), (for control) = ipairs(factory[factory_id].adds[part_id])
		do
			do break end
			self:_preload_part(factory_id, add_id, forbidden, override, parts, third_person, need_parent, done_cb, async_task_data, only_record)
		end

	end

	if part.adds_type then
		local (for generator), (for state), (for control) = ipairs(part.adds_type)
		do
			do break end
			local add_id = factory[factory_id][add_type]
			self:_preload_part(factory_id, add_id, forbidden, override, parts, third_person, need_parent, done_cb, async_task_data, only_record)
		end

	end

	if part.adds then
		local (for generator), (for state), (for control) = ipairs(part.adds)
		do
			do break end
			self:_preload_part(factory_id, add_id, forbidden, override, parts, third_person, need_parent, done_cb, async_task_data, only_record)
		end

	end

	if parts[part_id] then
		return
	end

	if part.parent and not async_task_data and not self:get_part_from_weapon_by_type(part.parent, parts) then
		table.insert(need_parent, part_id)
		return
	end

	local unit_name = third_person and part.third_unit or part.unit
	local ids_unit_name = Idstring(unit_name)
	local original_unit_name = third_person and original_part.third_unit or original_part.unit
	local ids_orig_unit_name = Idstring(original_unit_name)
	local package
	if not third_person and ids_unit_name == ids_orig_unit_name and not self._uses_streaming then
		package = "packages/fps_weapon_parts/" .. part_id
		if DB:has(Idstring("package"), Idstring(package)) then
			parts[part_id] = {package = package}
			self:load_package(parts[part_id].package)
		else
			print("[WeaponFactoryManager] Expected weapon part packages for", part_id)
			package = nil
		end

	end

	if not package then
		parts[part_id] = {
			name = ids_unit_name,
			is_streaming = async_task_data and true or nil
		}
		if not only_record then
			if async_task_data then
				managers.dyn_resource:load(ids_unit, ids_unit_name, managers.dyn_resource.DYN_RESOURCES_PACKAGE, callback(self, self, "clbk_part_unit_loaded", async_task_data))
			else
				managers.dyn_resource:load(unpack(parts[part_id]))
			end

		end

	end

end

function WeaponFactoryManager:assemble_default(factory_id, p_unit, third_person, done_cb, skip_queue)
	local blueprint = clone(tweak_data.weapon.factory[factory_id].default_blueprint)
	return self:_assemble(factory_id, p_unit, blueprint, third_person, done_cb, skip_queue), blueprint
end

function WeaponFactoryManager:assemble_from_blueprint(factory_id, p_unit, blueprint, third_person, done_cb, skip_queue)
	return self:_assemble(factory_id, p_unit, blueprint, third_person, done_cb, skip_queue)
end

function WeaponFactoryManager:_assemble(factory_id, p_unit, blueprint, third_person, done_cb, skip_queue)
	if not done_cb then
		Application:error("-----------------------------")
		Application:stack_dump()
	end

	local factory = tweak_data.weapon.factory
	local factory_weapon = factory[factory_id]
	local forbidden = self:_get_forbidden_parts(factory_id, blueprint)
	return self:_add_parts(p_unit, factory_id, factory_weapon, blueprint, forbidden, third_person, done_cb, skip_queue)
end

function WeaponFactoryManager:_get_forbidden_parts(factory_id, blueprint)
	local factory = tweak_data.weapon.factory
	local forbidden = {}
	local override = self:_get_override_parts(factory_id, blueprint)
	do
		local (for generator), (for state), (for control) = ipairs(blueprint)
		do
			do break end
			local part = self:_part_data(part_id, factory_id, override)
			if part.forbids then
				local (for generator), (for state), (for control) = ipairs(part.forbids)
				do
					do break end
					forbidden[forbidden_id] = part_id
				end

			end

			if part.adds then
				local add_forbidden = self:_get_forbidden_parts(factory_id, part.adds)
				local (for generator), (for state), (for control) = pairs(add_forbidden)
				do
					do break end
					forbidden[forbidden_id] = part_id
				end

			end

		end

	end

	return forbidden
end

function WeaponFactoryManager:_get_override_parts(factory_id, blueprint)
	local factory = tweak_data.weapon.factory
	local overridden = {}
	do
		local (for generator), (for state), (for control) = ipairs(blueprint)
		do
			do break end
			local part = self:_part_data(part_id, factory_id)
			if part.override then
				local (for generator), (for state), (for control) = pairs(part.override)
				do
					do break end
					overridden[override_id] = override_data
				end

			end

		end

	end

	return overridden
end

function WeaponFactoryManager:_update_task(task)
	if not alive(task.p_unit) then
		return true
	end

	if task.blueprint_i <= #task.blueprint then
		local part_id = task.blueprint[task.blueprint_i]
		self:_add_part(task.p_unit, task.factory_id, part_id, task.forbidden, task.override, task.parts, task.third_person, task.need_parent)
		task.blueprint_i = task.blueprint_i + 1
		return
	end

	if task.need_parent_i <= #task.need_parent then
		local part_id = task.need_parent[task.need_parent_i]
		self:_add_part(task.p_unit, task.factory_id, part_id, task.forbidden, task.override, task.parts, task.third_person, task.need_parent)
		task.need_parent_i = task.need_parent_i + 1
		return
	end

	print("WeaponFactoryManager:_update_task done")
	task.done_cb(task.parts, task.blueprint)
	return true
end

function WeaponFactoryManager:_add_parts(p_unit, factory_id, factory_weapon, blueprint, forbidden, third_person, done_cb, skip_queue)
	self._tasks = self._tasks or {}
	local parts = {}
	local need_parent = {}
	local override = self:_get_override_parts(factory_id, blueprint)
	if self._uses_tasks and not skip_queue then
		table.insert(self._tasks, {
			done_cb = done_cb,
			p_unit = p_unit,
			factory_id = factory_id,
			blueprint = blueprint,
			blueprint_i = 1,
			forbidden = forbidden,
			third_person = third_person,
			parts = parts,
			need_parent = need_parent,
			need_parent_i = 1,
			override = override
		})
	else
		local async_task_data
		if self._uses_streaming then
			async_task_data = {
				third_person = third_person,
				parts = parts,
				done_cb = done_cb,
				blueprint = blueprint,
				spawn = true
			}
			self._async_load_tasks = self._async_load_tasks or {}
			self._async_load_tasks[async_task_data] = true
		end

		do
			local (for generator), (for state), (for control) = ipairs(blueprint)
			do
				do break end
				self:_add_part(p_unit, factory_id, part_id, forbidden, override, parts, third_person, need_parent, async_task_data)
			end

		end

		do
			local (for generator), (for state), (for control) = ipairs(need_parent)
			do
				do break end
				self:_add_part(p_unit, factory_id, part_id, forbidden, override, parts, third_person, need_parent, async_task_data)
			end

		end

		if async_task_data then
			async_task_data.all_requests_sent = true
			self:clbk_part_unit_loaded(async_task_data, false, Idstring(), Idstring())
		else
			done_cb(parts, blueprint)
		end

	end

	return parts, blueprint
end

function WeaponFactoryManager:_part_data(part_id, factory_id, override)
	local factory = tweak_data.weapon.factory
	local part = deep_clone(factory.parts[part_id])
	if factory[factory_id].override and factory[factory_id].override[part_id] then
		local (for generator), (for state), (for control) = pairs(factory[factory_id].override[part_id])
		do
			do break end
			part[d] = v
		end

	end

	if override and override[part_id] then
		local (for generator), (for state), (for control) = pairs(override[part_id])
		do
			do break end
			part[d] = v
		end

	end

	return part
end

function WeaponFactoryManager:_add_part(p_unit, factory_id, part_id, forbidden, override, parts, third_person, need_parent, async_task_data)
	if forbidden[part_id] then
		return
	end

	local factory = tweak_data.weapon.factory
	local part = self:_part_data(part_id, factory_id, override)
	if factory[factory_id].adds and factory[factory_id].adds[part_id] then
		local (for generator), (for state), (for control) = ipairs(factory[factory_id].adds[part_id])
		do
			do break end
			self:_add_part(p_unit, factory_id, add_id, forbidden, override, parts, third_person, need_parent, async_task_data)
		end

	end

	if part.adds_type then
		local (for generator), (for state), (for control) = ipairs(part.adds_type)
		do
			do break end
			local add_id = factory[factory_id][add_type]
			self:_add_part(p_unit, factory_id, add_id, forbidden, override, parts, third_person, need_parent, async_task_data)
		end

	end

	if part.adds then
		local (for generator), (for state), (for control) = ipairs(part.adds)
		do
			do break end
			self:_add_part(p_unit, factory_id, add_id, forbidden, override, parts, third_person, need_parent, async_task_data)
		end

	end

	if parts[part_id] then
		return
	end

	local link_to_unit = p_unit
	if async_task_data then
		if part.parent then
			link_to_unit = nil
		end

	elseif part.parent then
		local parent_part = self:get_part_from_weapon_by_type(part.parent, parts)
		if parent_part then
			link_to_unit = parent_part.unit
		else
			table.insert(need_parent, part_id)
			return
		end

	end

	local unit_name = third_person and part.third_unit or part.unit
	local ids_unit_name = Idstring(unit_name)
	local package
	if not third_person and not async_task_data then
		local tweak_unit_name = tweak_data:get_raw_value("weapon", "factory", "parts", part_id, "unit")
		local ids_tweak_unit_name = tweak_unit_name and Idstring(tweak_unit_name)
		if ids_tweak_unit_name and ids_tweak_unit_name == ids_unit_name then
			package = "packages/fps_weapon_parts/" .. part_id
			if DB:has(Idstring("package"), Idstring(package)) then
				print("HAS PART AS PACKAGE")
				self:load_package(package)
			else
				print("[WeaponFactoryManager] Expected weapon part packages for", part_id)
				package = nil
			end

		end

	end

	if async_task_data then
		parts[part_id] = {
			animations = part.animations,
			name = ids_unit_name,
			is_streaming = true,
			link_to_unit = link_to_unit,
			a_obj = Idstring(part.a_obj),
			parent = part.parent
		}
		managers.dyn_resource:load(ids_unit, ids_unit_name, "packages/dyn_resources", callback(self, self, "clbk_part_unit_loaded", async_task_data))
	else
		if not package then
			managers.dyn_resource:load(ids_unit, ids_unit_name, "packages/dyn_resources", false)
		end

		local unit = self:_spawn_and_link_unit(ids_unit_name, Idstring(part.a_obj), third_person, link_to_unit)
		parts[part_id] = {
			unit = unit,
			animations = part.animations,
			name = ids_unit_name,
			package = package
		}
	end

end

function WeaponFactoryManager:clbk_part_unit_loaded(task_data, status, u_type, u_name)
	if not self._async_load_tasks[task_data] then
		return
	end

	local function _spawn(part)
		local unit = self:_spawn_and_link_unit(part.name, part.a_obj, task_data.third_person, part.link_to_unit)
		unit:set_enabled(false)
		part.unit = unit
		part.a_obj = nil
		part.link_to_unit = nil
	end

	do
		local (for generator), (for state), (for control) = pairs(task_data.parts)
		do
			do break end
			if part.name == u_name and part.is_streaming then
				part.is_streaming = nil
				if part.link_to_unit then
					_spawn(part)
				else
					local parent_part = self:get_part_from_weapon_by_type(part.parent, task_data.parts)
					if parent_part and parent_part.unit then
						part.link_to_unit = parent_part.unit
						_spawn(part)
					end

				end

			end

		end

	end

	repeat
		local re_iterate
		do
			local (for generator), (for state), (for control) = pairs(task_data.parts)
			do
				do break end
				if not part.unit and not part.is_streaming then
					local parent_part = self:get_part_from_weapon_by_type(part.parent, task_data.parts)
					if parent_part and parent_part.unit then
						part.link_to_unit = parent_part.unit
						_spawn(part)
						re_iterate = true
					end

				end

			end

		end

	until not re_iterate
	if not task_data.all_requests_sent then
		return
	end

	do
		local (for generator), (for state), (for control) = pairs(task_data.parts)
		do
			do break end
			if part.is_streaming or not part.unit then
				return
			end

		end

	end

	do
		local (for generator), (for state), (for control) = pairs(task_data.parts)
		do
			do break end
			if alive(part.unit) then
				part.unit:set_enabled(true)
			end

		end

	end

	self._async_load_tasks[task_data] = nil
	if not task_data.done_cb then
		return
	end

	task_data.done_cb(task_data.parts, task_data.blueprint)
end

function WeaponFactoryManager:_spawn_and_link_unit(u_name, a_obj, third_person, link_to_unit)
	local unit = World:spawn_unit(u_name, Vector3(), Rotation())
	local res = link_to_unit:link(a_obj, unit, unit:orientation_object():name())
	if managers.occlusion and not third_person then
		managers.occlusion:remove_occlusion(unit)
	end

	return unit
end

function WeaponFactoryManager:load_package(package)
	print("WeaponFactoryManager:_load_package", package)
	if not self._loaded_packages[package] then
		print("  Load for real", package)
		PackageManager:load(package)
		self._loaded_packages[package] = 1
	else
		self._loaded_packages[package] = self._loaded_packages[package] + 1
	end

end

function WeaponFactoryManager:unload_package(package)
	print("WeaponFactoryManager:_unload_package", package)
	if not self._loaded_packages[package] then
		Application:error("Trying to unload package that wasn't loaded")
		return
	end

	self._loaded_packages[package] = self._loaded_packages[package] - 1
	if self._loaded_packages[package] <= 0 then
		print("  Unload for real", package)
		PackageManager:unload(package)
		self._loaded_packages[package] = nil
	end

end

function WeaponFactoryManager:get_parts_from_weapon_by_type_or_perk(type_or_perk, factory_id, blueprint)
	local factory = tweak_data.weapon.factory
	local type_parts = {}
	do
		local (for generator), (for state), (for control) = ipairs(self:get_assembled_blueprint(factory_id, blueprint))
		do
			do break end
			local part = self:_part_data(id, factory_id)
			if part.type == type_or_perk or part.perks and table.contains(part.perks, type_or_perk) then
				table.insert(type_parts, id)
			end

		end

	end

	return type_parts
end

function WeaponFactoryManager:get_parts_from_weapon_by_perk(perk, parts)
	local factory = tweak_data.weapon.factory
	local type_parts = {}
	do
		local (for generator), (for state), (for control) = pairs(parts)
		do
			do break end
			local perks = factory.parts[id].perks
			if perks and table.contains(perks, perk) then
				table.insert(type_parts, parts[id])
			end

		end

	end

	return type_parts
end

function WeaponFactoryManager:get_custom_stats_from_part_id(part_id)
	local factory = tweak_data.weapon.factory.parts
	return factory[part_id] and factory[part_id].custom_stats or false
end

function WeaponFactoryManager:get_ammo_data_from_weapon(factory_id, blueprint)
	local factory = tweak_data.weapon.factory
	local t = {}
	do
		local (for generator), (for state), (for control) = ipairs(self:get_assembled_blueprint(factory_id, blueprint))
		do
			do break end
			if factory.parts[id].type == "ammo" then
				local part = self:_part_data(id, factory_id)
				t = part.custom_stats
			end

		end

	end

	return t
end

function WeaponFactoryManager:get_part_id_from_weapon_by_type(type, blueprint)
	local factory = tweak_data.weapon.factory
	do
		local (for generator), (for state), (for control) = pairs(blueprint)
		do
			do break end
			if factory.parts[part_id].type == type then
				return part_id
			end

		end

	end

	return false
end

function WeaponFactoryManager:get_part_from_weapon_by_type(type, parts)
	local factory = tweak_data.weapon.factory
	do
		local (for generator), (for state), (for control) = pairs(parts)
		do
			do break end
			if factory.parts[id].type == type then
				return parts[id]
			end

		end

	end

	return false
end

function WeaponFactoryManager:get_part_data_type_from_weapon_by_type(type, data_type, parts)
	local factory = tweak_data.weapon.factory
	do
		local (for generator), (for state), (for control) = pairs(parts)
		do
			do break end
			if factory.parts[id].type == type then
				return factory.parts[id][data_type]
			end

		end

	end

	return false
end

function WeaponFactoryManager:has_weapon_more_than_default_parts(factory_id)
	local weapon_tweak = tweak_data.weapon.factory[factory_id]
	return #weapon_tweak.uses_parts > #weapon_tweak.default_blueprint
end

function WeaponFactoryManager:get_parts_from_factory_id(factory_id)
	return self._parts_by_weapon[factory_id]
end

function WeaponFactoryManager:get_parts_from_weapon_id(weapon_id)
	local factory_id = self:get_factory_id_by_weapon_id(weapon_id)
	return self._parts_by_weapon[factory_id]
end

function WeaponFactoryManager:get_part_name_by_part_id(part_id)
	local part_tweak_data = tweak_data.weapon.factory.parts[part_id]
	if not part_tweak_data then
		Application:error("[WeaponFactoryManager:get_part_name_by_part_id] Found no part with part id", part_id)
		return
	end

	return managers.localization:text(part_tweak_data.name_id)
end

function WeaponFactoryManager:change_part(p_unit, factory_id, part_id, parts, blueprint)
	local factory = tweak_data.weapon.factory
	local part = factory.parts[part_id]
	if not part then
		Application:error("WeaponFactoryManager:change_part Part", part_id, "doesn't exist!")
		return parts
	end

	local type = part.type
	if self._parts_by_weapon[factory_id][type] then
		if table.contains(self._parts_by_weapon[factory_id][type], part_id) then
			do
				local (for generator), (for state), (for control) = pairs(parts)
				do
					do break end
					if factory.parts[rem_id].type == type then
						table.delete(blueprint, rem_id)
				end

				else
				end

			end

			table.insert(blueprint, part_id)
			self:disassemble(parts)
			return self:assemble_from_blueprint(factory_id, p_unit, blueprint)
		else
			Application:error("WeaponFactoryManager:change_part Part", part_id, "not allowed for weapon", factory_id, "!")
		end

	else
		Application:error("WeaponFactoryManager:change_part Part", part_id, "not allowed for weapon", factory_id, "!")
	end

	return parts
end

function WeaponFactoryManager:remove_part_from_blueprint(part_id, blueprint)
	local factory = tweak_data.weapon.factory
	local part = factory.parts[part_id]
	if not part then
		Application:error("WeaponFactoryManager:remove_part_from_blueprint Part", part_id, "doesn't exist!")
		return
	end

	table.delete(blueprint, part_id)
end

function WeaponFactoryManager:change_part_blueprint_only(factory_id, part_id, blueprint, remove_part)
	local factory = tweak_data.weapon.factory
	local part = factory.parts[part_id]
	if not part then
		Application:error("WeaponFactoryManager:change_part Part", part_id, " doesn't exist!")
		return false
	end

	local type = part.type
	if remove_part then
		table.delete(blueprint, part_id)
	elseif self._parts_by_weapon[factory_id][type] then
		if table.contains(self._parts_by_weapon[factory_id][type], part_id) then
			do
				local (for generator), (for state), (for control) = ipairs(blueprint)
				do
					do break end
					if factory.parts[rem_id].type == type then
						table.delete(blueprint, rem_id)
				end

				else
				end

			end

			table.insert(blueprint, part_id)
			local forbidden = WeaponFactoryManager:_get_forbidden_parts(factory_id, blueprint) or {}
			do
				local (for generator), (for state), (for control) = ipairs(blueprint)
				do
					do break end
					if forbidden[rem_id] then
						table.delete(blueprint, rem_id)
					end

				end

			end

			return true
		else
			Application:error("WeaponFactoryManager:change_part Part", part_id, "not allowed for weapon", factory_id, "!")
		end

	else
		Application:error("WeaponFactoryManager:change_part Part", part_id, "not allowed for weapon", factory_id, "!")
	end

	return false
end

function WeaponFactoryManager:get_replaces_parts(factory_id, part_id, blueprint, remove_part)
	local factory = tweak_data.weapon.factory
	local part = factory.parts[part_id]
	if not part then
		Application:error("WeaponFactoryManager:change_part Part", part_id, " doesn't exist!")
		return nil
	end

	local replaces = {}
	local type = part.type
	if self._parts_by_weapon[factory_id][type] then
		if table.contains(self._parts_by_weapon[factory_id][type], part_id) then
			local (for generator), (for state), (for control) = ipairs(blueprint)
			do
				do break end
				if factory.parts[rep_id].type == type then
					table.insert(replaces, rep_id)
			end

			else
			end

		else
			Application:error("WeaponFactoryManager:check_replaces_part Part", part_id, "not allowed for weapon", factory_id, "!")
		end

	else
		Application:error("WeaponFactoryManager:check_replaces_part Part", part_id, "not allowed for weapon", factory_id, "!")
	end

	return replaces
end

function WeaponFactoryManager:get_removes_parts(factory_id, part_id, blueprint, remove_part)
	local factory = tweak_data.weapon.factory
	local part = factory.parts[part_id]
	if not part then
		Application:error("WeaponFactoryManager:get_removes_parts Part", part_id, " doesn't exist!")
		return nil
	end

	local removes = {}
	local new_blueprint = deep_clone(blueprint)
	self:change_part_blueprint_only(factory_id, part_id, new_blueprint, remove_part)
	do
		local (for generator), (for state), (for control) = ipairs(blueprint)
		do
			do break end
			if not table.contains(new_blueprint, b_id) then
				local b_part = factory.parts[b_id]
				if b_part and part and b_part.type ~= part.type then
					table.insert(removes, b_id)
				end

			end

		end

	end

	return removes
end

function WeaponFactoryManager:can_add_part(factory_id, part_id, blueprint)
	local forbidden = self:_get_forbidden_parts(factory_id, blueprint)
	do
		local (for generator), (for state), (for control) = pairs(forbidden)
		do
			do break end
			if forbid_part_id == part_id then
				return forbidder_part_id
			end

		end

	end

	return nil
end

function WeaponFactoryManager:remove_part(p_unit, factory_id, part_id, parts, blueprint)
	local factory = tweak_data.weapon.factory
	local part = factory.parts[part_id]
	if not part then
		Application:error("WeaponFactoryManager:remove_part Part", part_id, "doesn't exist!")
		return parts
	end

	table.delete(blueprint, part_id)
	self:disassemble(parts)
	return self:assemble_from_blueprint(factory_id, p_unit, blueprint)
end

function WeaponFactoryManager:remove_part_by_type(p_unit, factory_id, type, parts, blueprint)
	local factory = tweak_data.weapon.factory
	do
		local (for generator), (for state), (for control) = pairs(parts)
		do
			do break end
			if factory.parts[part_id].type == type then
				table.delete(blueprint, part_id)
		end

		else
		end

	end

	self:disassemble(parts)
	return self:assemble_from_blueprint(factory_id, p_unit, blueprint)
end

function WeaponFactoryManager:change_blueprint(p_unit, factory_id, parts, blueprint)
	self:disassemble(parts)
	return self:assemble_from_blueprint(factory_id, p_unit, blueprint)
end

function WeaponFactoryManager:blueprint_to_string(factory_id, blueprint)
	local factory = tweak_data.weapon.factory
	local index_table = {}
	do
		local (for generator), (for state), (for control) = ipairs(factory[factory_id].uses_parts)
		do
			do break end
			index_table[part_id] = i
		end

	end

	local s = ""
	do
		local (for generator), (for state), (for control) = ipairs(blueprint)
		do
			do break end
			s = s .. index_table[part_id] .. " "
		end

	end

	return s
end

function WeaponFactoryManager:unpack_blueprint_from_string(factory_id, blueprint_string)
	local factory = tweak_data.weapon.factory
	local index_table = string.split(blueprint_string, " ")
	local blueprint = {}
	do
		local (for generator), (for state), (for control) = ipairs(index_table)
		do
			do break end
			table.insert(blueprint, factory[factory_id].uses_parts[tonumber(part_index)])
		end

	end

	return blueprint
end

function WeaponFactoryManager:get_stats(factory_id, blueprint)
	local factory = tweak_data.weapon.factory
	local forbidden = self:_get_forbidden_parts(factory_id, blueprint)
	local override = self:_get_override_parts(factory_id, blueprint)
	local stats = {}
	do
		local (for generator), (for state), (for control) = ipairs(blueprint)
		do
			do break end
			if not forbidden[part_id] and factory.parts[part_id].stats then
				local part = self:_part_data(part_id, factory_id)
				local (for generator), (for state), (for control) = pairs(part.stats)
				do
					do break end
					stats[stat_type] = stats[stat_type] or 0
					stats[stat_type] = stats[stat_type] + value
				end

			end

		end

	end

	return stats
end

function WeaponFactoryManager:has_perk(perk_name, factory_id, blueprint)
	local factory = tweak_data.weapon.factory
	local forbidden = self:_get_forbidden_parts(factory_id, blueprint)
	do
		local (for generator), (for state), (for control) = ipairs(blueprint)
		do
			do break end
			if not forbidden[part_id] and factory.parts[part_id].perks then
				local (for generator), (for state), (for control) = ipairs(factory.parts[part_id].perks)
				do
					do break end
					if perk == perk_name then
						return true
					end

				end

			end

		end

	end

	return false
end

function WeaponFactoryManager:get_perks_from_part_id(part_id)
	local factory = tweak_data.weapon.factory
	if not factory.parts[part_id] then
		return {}
	end

	local perks = {}
	if factory.parts[part_id].perks then
		local (for generator), (for state), (for control) = ipairs(factory.parts[part_id].perks)
		do
			do break end
			perks[perk] = true
		end

	end

	return perks
end

function WeaponFactoryManager:get_perks(factory_id, blueprint)
	local factory = tweak_data.weapon.factory
	local forbidden = self:_get_forbidden_parts(factory_id, blueprint)
	local perks = {}
	do
		local (for generator), (for state), (for control) = ipairs(blueprint)
		do
			do break end
			if not forbidden[part_id] and factory.parts[part_id].perks then
				local (for generator), (for state), (for control) = ipairs(factory.parts[part_id].perks)
				do
					do break end
					perks[perk] = true
				end

			end

		end

	end

	return perks
end

function WeaponFactoryManager:get_sound_switch(switch_group, factory_id, blueprint)
	local factory = tweak_data.weapon.factory
	local forbidden = self:_get_forbidden_parts(factory_id, blueprint)
	do
		local (for generator), (for state), (for control) = ipairs(blueprint)
		do
			do break end
			if not forbidden[part_id] and factory.parts[part_id].sound_switch and factory.parts[part_id].sound_switch[switch_group] then
				return factory.parts[part_id].sound_switch[switch_group]
			end

		end

	end

	return nil
end

function WeaponFactoryManager:disassemble(parts)
	do
		local (for generator), (for state), (for control) = pairs(self._async_load_tasks)
		do
			do break end
			if task_data.parts == parts then
				self._async_load_tasks[task_data] = nil
		end

		else
		end

	end

	local names = {}
	if parts then
		local (for generator), (for state), (for control) = pairs(parts)
		do
			do break end
			if data.package then
				self:unload_package(data.package)
			else
				table.insert(names, data.name)
			end

			if alive(data.unit) then
				World:delete_unit(data.unit)
			end

		end

	end

	parts = {}
	local (for generator), (for state), (for control) = pairs(names)
	do
		do break end
		managers.dyn_resource:unload(ids_unit, name, "packages/dyn_resources", false)
	end

end

function WeaponFactoryManager:save(data)
	data.weapon_factory = self._global
end

function WeaponFactoryManager:load(data)
	self._global = data.weapon_factory
end

function WeaponFactoryManager:debug_get_stats(factory_id, blueprint)
	local factory = tweak_data.weapon.factory
	local forbidden = self:_get_forbidden_parts(factory_id, blueprint)
	local stats = {}
	do
		local (for generator), (for state), (for control) = ipairs(blueprint)
		do
			do break end
			if not forbidden[part_id] then
				stats[part_id] = factory.parts[part_id].stats
			end

		end

	end

	return stats
end

