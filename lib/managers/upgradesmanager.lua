UpgradesManager = UpgradesManager or class()
function UpgradesManager:init()
	self:_setup()
end

function UpgradesManager:_setup()
	if not Global.upgrades_manager then
		Global.upgrades_manager = {}
		Global.upgrades_manager.aquired = {}
		Global.upgrades_manager.automanage = false
		Global.upgrades_manager.progress = {
			0,
			0,
			0,
			0
		}
		Global.upgrades_manager.target_tree = self:_autochange_tree()
		Global.upgrades_manager.disabled_visual_upgrades = {}
	end

	self._global = Global.upgrades_manager
end

function UpgradesManager:setup_current_weapon()
end

function UpgradesManager:visual_weapon_upgrade_active(upgrade)
	return not self._global.disabled_visual_upgrades[upgrade]
end

function UpgradesManager:toggle_visual_weapon_upgrade(upgrade)
	if self._global.disabled_visual_upgrades[upgrade] then
		self._global.disabled_visual_upgrades[upgrade] = nil
	else
		self._global.disabled_visual_upgrades[upgrade] = true
	end

end

function UpgradesManager:set_target_tree(tree)
	local level = managers.experience:current_level()
	local step = self._global.progress[tree]
	local cap = tweak_data.upgrades.tree_caps[self._global.progress[tree] + 1]
	if cap and level < cap then
		return
	end

	self:_set_target_tree(tree)
end

function UpgradesManager:_set_target_tree(tree)
	local i = self._global.progress[tree] + 1
	local upgrade = tweak_data.upgrades.definitions[tweak_data.upgrades.progress[tree][i]]
	self._global.target_tree = tree
end

function UpgradesManager:current_tree_name()
	return self:tree_name(self._global.target_tree)
end

function UpgradesManager:tree_name(tree)
	return managers.localization:text(tweak_data.upgrades.trees[tree].name_id)
end

function UpgradesManager:tree_allowed(tree, level)
	level = level or managers.experience:current_level()
	local cap = tweak_data.upgrades.tree_caps[self._global.progress[tree] + 1]
	return not cap or not (level < cap), cap
end

function UpgradesManager:current_tree()
	return self._global.target_tree
end

function UpgradesManager:next_upgrade(tree)
end

function UpgradesManager:level_up()
	local level = managers.experience:current_level()
	print("UpgradesManager:level_up()", level)
	self:aquire_from_level_tree(level, false)
end

function UpgradesManager:aquire_from_level_tree(level, loading)
	local tree_data = tweak_data.upgrades.level_tree[level]
	if not tree_data then
		return
	end

	local (for generator), (for state), (for control) = ipairs(tree_data.upgrades)
	do
		do break end
		self:aquire(upgrade, loading)
	end

end

function UpgradesManager:_next_tree()
	local tree
	if self._global.automanage then
		tree = self:_autochange_tree()
	end

	local level = managers.experience:current_level() + 1
	local cap = tweak_data.upgrades.tree_caps[self._global.progress[self._global.target_tree] + 1]
	if cap and level < cap then
		tree = self:_autochange_tree(self._global.target_tree)
	end

	return tree or self._global.target_tree
end

function UpgradesManager:num_trees()
	return managers.dlc:has_preorder() and 4 or 3
end

function UpgradesManager:_autochange_tree(exlude_tree)
	local progress = clone(Global.upgrades_manager.progress)
	if exlude_tree then
		progress[exlude_tree] = nil
	end

	if not managers.dlc:has_preorder() then
		progress[4] = nil
	end

	local n_tree = 0
	local n_v = 100
	do
		local (for generator), (for state), (for control) = pairs(progress)
		do
			do break end
			if v < n_v then
				n_tree = tree
				n_v = v
			end

		end

	end

end

function UpgradesManager:aquired(id)
	if self._global.aquired[id] then
		return true
	end

end

function UpgradesManager:aquire_default(id)
	if not tweak_data.upgrades.definitions[id] then
		Application:error("Tried to aquire an upgrade that doesn't exist: " .. id .. "")
		return
	end

	if self._global.aquired[id] then
		return
	end

	self._global.aquired[id] = true
	local upgrade = tweak_data.upgrades.definitions[id]
	self:_aquire_upgrade(upgrade, id, true)
end

function UpgradesManager:enable_weapon(id)
	if not tweak_data.upgrades.definitions[id] then
		Application:error("Tried to aquire an upgrade that doesn't exist: " .. (id or "nil") .. "")
		return
	end

	if self._global.aquired[id] then
		Application:error("Tried to aquire an upgrade that has allready been aquired: " .. id .. "")
		return
	end

	local upgrade = tweak_data.upgrades.definitions[id]
	if upgrade.dlc and (tweak_data.dlc[upgrade.dlc] and tweak_data.dlc[upgrade.dlc].free or not managers.dlc:has_dlc(upgrade.dlc)) then
		Application:error("Tried to aquire an upgrade locked to a dlc you do not have: " .. id .. " DLC: ", upgrade.dlc)
		return
	end

	self._global.aquired[id] = true
	managers.player:aquire_weapon(upgrade, id)
end

function UpgradesManager:aquire(id, loading)
	if not tweak_data.upgrades.definitions[id] then
		Application:error("Tried to aquire an upgrade that doesn't exist: " .. (id or "nil") .. "")
		return
	end

	if self._global.aquired[id] then
		Application:error("Tried to aquire an upgrade that has allready been aquired: " .. id .. "")
		return
	end

	local upgrade = tweak_data.upgrades.definitions[id]
	if upgrade.dlc and (tweak_data.dlc[upgrade.dlc] and tweak_data.dlc[upgrade.dlc].free or not managers.dlc:has_dlc(upgrade.dlc)) then
		Application:error("Tried to aquire an upgrade locked to a dlc you do not have: " .. id .. " DLC: ", upgrade.dlc)
		return
	end

	local level = managers.experience:current_level() + 1
	self._global.aquired[id] = true
	self:_aquire_upgrade(upgrade, id, loading)
	self:setup_current_weapon()
end

function UpgradesManager:unaquire(id)
	if not tweak_data.upgrades.definitions[id] then
		Application:error("Tried to unaquire an upgrade that doesn't exist: " .. (id or "nil") .. "")
		return
	end

	if not self._global.aquired[id] then
		Application:error("Tried to unaquire an upgrade that hasn't benn aquired: " .. id .. "")
		return
	end

	self._global.aquired[id] = nil
	local upgrade = tweak_data.upgrades.definitions[id]
	self:_unaquire_upgrade(upgrade, id)
end

function UpgradesManager:_aquire_upgrade(upgrade, id, loading)
	if upgrade.category == "weapon" then
		self:_aquire_weapon(upgrade, id, loading)
	elseif upgrade.category == "feature" then
		self:_aquire_feature(upgrade, id, loading)
	elseif upgrade.category == "equipment" then
		self:_aquire_equipment(upgrade, id, loading)
	elseif upgrade.category == "equipment_upgrade" then
		self:_aquire_equipment_upgrade(upgrade, id, loading)
	elseif upgrade.category == "temporary" then
		self:_aquire_temporary(upgrade, id, loading)
	elseif upgrade.category == "team" then
		self:_aquire_team(upgrade, id, loading)
	elseif upgrade.category == "armor" then
		self:_aquire_armor(upgrade, id, loading)
	elseif upgrade.category == "rep_upgrade" then
		self:_aquire_rep_upgrade(upgrade, id, loading)
	elseif upgrade.category == "melee_weapon" then
		self:_aquire_melee_weapon(upgrade, id, loading)
	end

end

function UpgradesManager:_unaquire_upgrade(upgrade, id)
	if upgrade.category == "weapon" then
		self:_unaquire_weapon(upgrade, id)
	elseif upgrade.category == "feature" then
		self:_unaquire_feature(upgrade, id)
	elseif upgrade.category == "equipment" then
		self:_unaquire_equipment(upgrade, id)
	elseif upgrade.category == "equipment_upgrade" then
		self:_unaquire_equipment_upgrade(upgrade, id)
	elseif upgrade.category == "temporary" then
		self:_unaquire_temporary(upgrade, id)
	elseif upgrade.category == "team" then
		self:_unaquire_team(upgrade, id)
	elseif upgrade.category == "armor" then
		self:_unaquire_armor(upgrade, id)
	elseif upgrade.category == "melee_weapon" then
		self:_unaquire_melee_weapon(upgrade, id)
	end

end

function UpgradesManager:_aquire_weapon(upgrade, id, loading)
	managers.player:aquire_weapon(upgrade, id)
	managers.blackmarket:on_aquired_weapon_platform(upgrade, id, loading)
end

function UpgradesManager:_unaquire_weapon(upgrade, id)
	managers.player:unaquire_weapon(upgrade, id)
	managers.blackmarket:on_unaquired_weapon_platform(upgrade, id)
end

function UpgradesManager:_aquire_melee_weapon(upgrade, id, loading)
	managers.player:aquire_melee_weapon(upgrade, id)
	managers.blackmarket:on_aquired_melee_weapon(upgrade, id, loading)
end

function UpgradesManager:_unaquire_melee_weapon(upgrade, id)
	managers.player:unaquire_melee_weapon(upgrade, id)
	managers.blackmarket:on_unaquired_melee_weapon(upgrade, id)
end

function UpgradesManager:_aquire_feature(feature)
	if feature.incremental then
		managers.player:aquire_incremental_upgrade(feature.upgrade)
	else
		managers.player:aquire_upgrade(feature.upgrade)
	end

end

function UpgradesManager:_unaquire_feature(feature)
	if feature.incremental then
		managers.player:unaquire_incremental_upgrade(feature.upgrade)
	else
		managers.player:unaquire_upgrade(feature.upgrade)
	end

end

function UpgradesManager:_aquire_equipment(equipment, id)
	managers.player:aquire_equipment(equipment, id)
end

function UpgradesManager:_unaquire_equipment(equipment, id)
	managers.player:unaquire_equipment(equipment, id)
end

function UpgradesManager:_aquire_equipment_upgrade(equipment_upgrade)
	managers.player:aquire_upgrade(equipment_upgrade.upgrade)
end

function UpgradesManager:_unaquire_equipment_upgrade(equipment_upgrade)
	managers.player:unaquire_upgrade(equipment_upgrade.upgrade)
end

function UpgradesManager:_aquire_temporary(temporary, id)
	if temporary.incremental then
		managers.player:aquire_incremental_upgrade(temporary.upgrade)
	else
		managers.player:aquire_upgrade(temporary.upgrade, id)
	end

end

function UpgradesManager:_unaquire_temporary(temporary, id)
	if temporary.incremental then
		managers.player:unaquire_incremental_upgrade(temporary.upgrade)
	else
		managers.player:unaquire_upgrade(temporary.upgrade)
	end

end

function UpgradesManager:_aquire_team(team, id)
	managers.player:aquire_team_upgrade(team.upgrade, id)
end

function UpgradesManager:_unaquire_team(team, id)
	managers.player:unaquire_team_upgrade(team.upgrade, id)
end

function UpgradesManager:_aquire_armor(upgrade, id, loading)
	managers.blackmarket:on_aquired_armor(upgrade, id, loading)
end

function UpgradesManager:_unaquire_armor(upgrade, id)
	managers.blackmarket:on_unaquired_armor(upgrade, id)
end

function UpgradesManager:_aquire_rep_upgrade(upgrade, id)
	managers.skilltree:rep_upgrade(upgrade, id)
end

function UpgradesManager:get_value(upgrade_id, ...)
	local upgrade = tweak_data.upgrades.definitions[upgrade_id]
	local u = upgrade.upgrade
	if upgrade.category == "feature" then
		return tweak_data.upgrades.values[u.category][u.upgrade][u.value]
	elseif upgrade.category == "equipment" then
		return upgrade.equipment_id
	elseif upgrade.category == "equipment_upgrade" then
		return tweak_data.upgrades.values[u.category][u.upgrade][u.value]
	elseif upgrade.category == "temporary" then
		local temporary = tweak_data.upgrades.values[u.category][u.upgrade][u.value]
		return "Value: " .. tostring(temporary[1]) .. " Time: " .. temporary[2]
	elseif upgrade.category == "team" then
		local value = tweak_data.upgrades.values.team[u.category][u.upgrade][u.value]
		return value
	elseif upgrade.category == "weapon" then
		local default_weapons = {"glock_17", "amcar"}
		local weapon_id = upgrade.weapon_id
		local is_default_weapon = table.contains(default_weapons, weapon_id) and true or false
		local weapon_level = 0
		local new_weapon_id = tweak_data.weapon[weapon_id] and tweak_data.weapon[weapon_id].parent_weapon_id or weapon_id
		do
			local (for generator), (for state), (for control) = pairs(tweak_data.upgrades.level_tree)
			do
				do break end
				local upgrades = data.upgrades
				if upgrades and table.contains(upgrades, new_weapon_id) then
					weapon_level = level
			end

			else
			end

		end

		(for control) = nil and data.upgrades
		return is_default_weapon, weapon_level, weapon_id ~= new_weapon_id
	elseif upgrade.category == "melee_weapon" then
		local params = {
			...
		}
		local default_id = params[1] or managers.blackmarket and managers.blackmarket:get_category_default("melee_weapon") or "weapon"
		local melee_weapon_id = upgrade_id
		local is_default_weapon = melee_weapon_id == default_id
		local melee_weapon_level = 0
		do
			local (for generator), (for state), (for control) = pairs(tweak_data.upgrades.level_tree)
			do
				do break end
				local upgrades = data.upgrades
				if upgrades and table.contains(upgrades, melee_weapon_id) then
					melee_weapon_level = level
			end

			else
			end

		end

		(for control) = ... and data.upgrades
		return is_default_weapon, melee_weapon_level
	end

	print("no value for", upgrade_id, upgrade.category)
end

function UpgradesManager:get_category(upgrade_id)
	local upgrade = tweak_data.upgrades.definitions[upgrade_id]
	return upgrade.category
end

function UpgradesManager:get_upgrade_upgrade(upgrade_id)
	local upgrade = tweak_data.upgrades.definitions[upgrade_id]
	return upgrade.upgrade
end

function UpgradesManager:get_upgrade_locks(upgrade_id)
	local upgrade = tweak_data.upgrades.definitions[upgrade_id]
	return {
		dlc = upgrade.dlc
	}
end

function UpgradesManager:is_upgrade_locked(upgrade_id)
-- fail 8
null
5
	local locks = self:get_upgrade_locks(upgrade_id)
	do
		local (for generator), (for state), (for control) = pairs(locks)
		do
			do break end
			if category == "dlc" and not managers.dlc:is_dlc_unlocked(id) then
				return true
			else
			end

		end

	end

end

function UpgradesManager:is_locked(step)
	local level = managers.experience:current_level()
	do
		local (for generator), (for state), (for control) = ipairs(tweak_data.upgrades.itree_caps)
		do
			do break end
			if level < d.level then
				return step >= d.step
			end

		end

	end

	(for control) = nil and d.level
end

function UpgradesManager:get_level_from_step(step)
	do
		local (for generator), (for state), (for control) = ipairs(tweak_data.upgrades.itree_caps)
		do
			do break end
			if step == d.step then
				return d.level
			end

		end

	end

	(for control) = nil and d.step
end

function UpgradesManager:progress()
	if managers.dlc:has_preorder() then
		return {
			self._global.progress[1],
			self._global.progress[2],
			self._global.progress[3],
			self._global.progress[4]
		}
	end

	return {
		self._global.progress[1],
		self._global.progress[2],
		self._global.progress[3]
	}
end

function UpgradesManager:progress_by_tree(tree)
	return self._global.progress[tree]
end

function UpgradesManager:name(id)
	if not tweak_data.upgrades.definitions[id] then
		Application:error("Tried to get name from an upgrade that doesn't exist: " .. id .. "")
		return
	end

	local upgrade = tweak_data.upgrades.definitions[id]
	return managers.localization:text(upgrade.name_id)
end

function UpgradesManager:title(id)
	if not tweak_data.upgrades.definitions[id] then
		Application:error("Tried to get title from an upgrade that doesn't exist: " .. id .. "")
		return
	end

	local upgrade = tweak_data.upgrades.definitions[id]
	return upgrade.title_id and managers.localization:text(upgrade.title_id) or nil
end

function UpgradesManager:subtitle(id)
	if not tweak_data.upgrades.definitions[id] then
		Application:error("Tried to get subtitle from an upgrade that doesn't exist: " .. id .. "")
		return
	end

	local upgrade = tweak_data.upgrades.definitions[id]
	return upgrade.subtitle_id and managers.localization:text(upgrade.subtitle_id) or nil
end

function UpgradesManager:complete_title(id, type)
	local title = self:title(id)
	if not title then
		return nil
	end

	local subtitle = self:subtitle(id)
	if not subtitle then
		return title
	end

	if type then
		if type == "single" then
			return title .. " " .. subtitle
		else
			return title .. type .. subtitle
		end

	end

	return title .. "\n" .. subtitle
end

function UpgradesManager:description(id)
	if not tweak_data.upgrades.definitions[id] then
		Application:error("Tried to get description from an upgrade that doesn't exist: " .. id .. "")
		return
	end

	local upgrade = tweak_data.upgrades.definitions[id]
	if upgrade.subtitle_id then
	else
	end

	return managers.localization:text(upgrade.description_text_id or id) or nil
end

function UpgradesManager:image(id)
	local image = tweak_data.upgrades.definitions[id].image
	if not image then
		return nil, nil
	end

	return tweak_data.hud_icons:get_icon_data(image)
end

function UpgradesManager:image_slice(id)
	local image_slice = tweak_data.upgrades.definitions[id].image_slice
	if not image_slice then
		return nil, nil
	end

	return tweak_data.hud_icons:get_icon_data(image_slice)
end

function UpgradesManager:icon(id)
	if not tweak_data.upgrades.definitions[id] then
		Application:error("Tried to aquire an upgrade that doesn't exist: " .. id .. "")
		return
	end

	return tweak_data.upgrades.definitions[id].icon
end

function UpgradesManager:aquired_by_category(category)
	local t = {}
	do
		local (for generator), (for state), (for control) = pairs(self._global.aquired)
		do
			do break end
			if tweak_data.upgrades.definitions[name].category == category then
				table.insert(t, name)
			end

		end

	end

end

function UpgradesManager:aquired_features()
	return self:aquired_by_category("feature")
end

function UpgradesManager:aquired_weapons()
	return self:aquired_by_category("weapon")
end

function UpgradesManager:all_weapon_upgrades()
	local (for generator), (for state), (for control) = pairs(tweak_data.upgrades.definitions)
	do
		do break end
		if data.category == "weapon" then
			print(id)
		end

	end

end

function UpgradesManager:weapon_upgrade_by_weapon_id(weapon_id)
	local (for generator), (for state), (for control) = pairs(tweak_data.upgrades.definitions)
	do
		do break end
		if data.category == "weapon" and data.weapon_id == weapon_id then
			return data
		end

	end

end

function UpgradesManager:weapon_upgrade_by_factory_id(factory_id)
	local (for generator), (for state), (for control) = pairs(tweak_data.upgrades.definitions)
	do
		do break end
		if data.category == "weapon" and data.factory_id == factory_id then
			return data
		end

	end

end

function UpgradesManager:print_aquired_tree()
	local tree = {}
	do
		local (for generator), (for state), (for control) = pairs(self._global.aquired)
		do
			do break end
			tree[data.level] = {name = name}
		end

	end

	(for control) = nil and data.level
	local (for generator), (for state), (for control) = pairs(tree)
	do
		do break end
		print(self:name(data.name))
	end

end

function UpgradesManager:analyze()
-- fail 47
null
17
	local not_placed = {}
	local placed = {}
	local features = {}
	local amount = 0
	do
		local (for generator), (for state), (for control) = pairs(tweak_data.upgrades.levels)
		do
			do break end
			print("Upgrades at level " .. lvl .. ":")
			local (for generator), (for state), (for control) = ipairs(upgrades)
			do
				do break end
				print("\t" .. upgrade)
			end

		end

		(for control) = ":" and print
	end

	(for control) = nil and print
	do
		local (for generator), (for state), (for control) = pairs(tweak_data.upgrades.definitions)
		do
			do break end
			amount = amount + 1
			do
				local (for generator), (for state), (for control) = pairs(tweak_data.upgrades.levels)
				do
					do break end
					local (for generator), (for state), (for control) = ipairs(upgrades)
					do
						do break end
						if upgrade == name then
							if placed[name] then
								print("ERROR: Upgrade " .. name .. " is already placed in level " .. placed[name] .. "!")
							else
								placed[name] = lvl
							end

							if data.category == "feature" then
								features[data.upgrade.category] = features[data.upgrade.category] or {}
								table.insert(features[data.upgrade.category], {level = lvl, name = name})
							end

						end

					end

				end

			end

			(for control) = ":" and ipairs
			if not placed[name] then
				not_placed[name] = true
			end

		end

	end

	(for control) = nil and amount + 1
	do
		local (for generator), (for state), (for control) = pairs(placed)
		do
			do break end
			print("Upgrade " .. name .. " is placed in level\t\t " .. lvl .. ".")
		end

	end

	(for control) = nil and print
	do
		local (for generator), (for state), (for control) = pairs(not_placed)
		do
			do break end
			print("Upgrade " .. name .. " is not placed any level!")
		end

	end

	(for control) = nil and print
	print("")
	do
		local (for generator), (for state), (for control) = pairs(features)
		do
			do break end
			print("Upgrades for category " .. category .. " is recieved at:")
			local (for generator), (for state), (for control) = ipairs(upgrades)
			do
				do break end
				print("  Level: " .. upgrade.level .. ", " .. upgrade.name .. "")
			end

		end

		(for control) = " is recieved at:" and print
	end

	(for control) = nil and print
	print([[

Total upgrades ]] .. amount .. ".")
end

function UpgradesManager:tree_stats()
	local t = {
		{
			u = {},
			a = 0
		},
		{
			u = {},
			a = 0
		},
		{
			u = {},
			a = 0
		}
	}
	do
		local (for generator), (for state), (for control) = pairs(tweak_data.upgrades.definitions)
		do
			do break end
			if d.tree then
				t[d.tree].a = t[d.tree].a + 1
				table.insert(t[d.tree].u, name)
			end

		end

	end

	(for control) = {} and d.tree
	local (for generator), (for state), (for control) = ipairs(t)
	do
		do break end
		print(inspect(d.u))
		print(d.a)
	end

end

function UpgradesManager:save(data)
