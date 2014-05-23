MimicManager = MimicManager or class()
function MimicManager:init()
	self._mimic_map = {}
	self._mimic_map.interaction = {}
	self._mimic_map.ranged = {}
	self._mimic_map.attack = {}
	self._unit_map = {}
	self._mission_map = {}
	self._call_to_arms_list = {}
end

function MimicManager:add_mimic_unit(unit, type_list)
	local unit_key = unit:key()
	self._unit_map[unit_key] = unit
	local (for generator), (for state), (for control) = ipairs(type_list)
	do
		do break end
		assert(self._mimic_map[key], "No mimic type with name " .. tostring(key) .. " in MimicManager.")
		self._mimic_map[key][unit_key] = unit
	end

end

function MimicManager:activate_all()
	do
		local (for generator), (for state), (for control) = pairs(self._mimic_map.interaction)
		do
			do break end
			v:mimic():activate_mimic("interaction")
		end

	end

	(for control) = nil and v.mimic
	do
		local (for generator), (for state), (for control) = pairs(self._mimic_map.ranged)
		do
			do break end
			v:mimic():activate_mimic("ranged")
		end

	end

	(for control) = nil and v.mimic
	local (for generator), (for state), (for control) = pairs(self._mimic_map.attack)
	do
		do break end
		v:mimic():activate_mimic("attack")
	end

end

function MimicManager:request_npcs(unit, num)
	table.insert(self._call_to_arms_list, {unit, num})
end

function MimicManager:get_mimic_map(mimic_map)
	return self._mimic_map[mimic_map]
end

function MimicManager:receive_mimic_types(unit_key)
	if self._unit_map[unit_key] then
		return self._unit_map[unit_key]:mimic():receive_mimic_types()
	end

	return nil
end

function MimicManager:register_mission_callback(mission_condition, clbk, unit_key, mimic_type)
end

function MimicManager:update(t, dt)
-- fail 10
null
6
	if #self._call_to_arms_list > 0 then
		local all_called = true
		do
			local (for generator), (for state), (for control) = ipairs(self._call_to_arms_list)
			do
				do break end
				if params then
					local unit = params[1]
					local num = params[2]
					local units = unit:find_units_quick("sphere", unit:position(), 12000, 12)
					local return_list = {}
					for i = 1, math.min(num, #units) do
						if alive(units[i]) and units[i]:mimic_data() then
							table.insert(return_list, units[i])
						end

					end

					unit:mimic():return_requested_npcs(return_list)
					self._call_to_arms_list[k] = false
					all_called = false
			end

			else
			end

		end

		do break end
		self._call_to_arms_list = {}
	end

end

