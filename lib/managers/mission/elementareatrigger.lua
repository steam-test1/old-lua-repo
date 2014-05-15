core:import("CoreElementArea")
core:import("CoreClass")
ElementAreaTrigger = ElementAreaTrigger or class(CoreElementArea.ElementAreaTrigger)
function ElementAreaTrigger:init(...)
	ElementAreaTrigger.super.init(self, ...)
end

function ElementAreaTrigger:project_instigators()
	local instigators = {}
	if Network:is_client() then
		if self._values.instigator == "player" or self._values.instigator == "local_criminals" then
			table.insert(instigators, managers.player:player_unit())
		end

		return instigators
	end

	if self._values.instigator == "player" then
		table.insert(instigators, managers.player:player_unit())
	elseif self._values.instigator == "enemies" then
		if managers.groupai:state():police_hostage_count() <= 0 then
			local (for generator), (for state), (for control) = pairs(managers.enemy:all_enemies())
			do
				do break end
				table.insert(instigators, data.unit)
			end

		else
			(for control) = managers.enemy:all_enemies() and table
			local (for generator), (for state), (for control) = pairs(managers.enemy:all_enemies())
			do
				do break end
				if not data.unit:anim_data().surrender then
					table.insert(instigators, data.unit)
				end

			end

		end

	else
		(for control) = managers.enemy:all_enemies() and data.unit
		if self._values.instigator == "civilians" then
			local (for generator), (for state), (for control) = pairs(managers.enemy:all_civilians())
			do
				do break end
				table.insert(instigators, data.unit)
			end

		else
			(for control) = managers.enemy:all_civilians() and table
			if self._values.instigator == "escorts" then
				local (for generator), (for state), (for control) = pairs(managers.enemy:all_civilians())
				do
					do break end
					if tweak_data.character[data.unit:base()._tweak_table].is_escort then
						table.insert(instigators, data.unit)
					end

				end

			else
				(for control) = managers.enemy:all_civilians() and tweak_data
				if self._values.instigator == "criminals" then
					local (for generator), (for state), (for control) = pairs(managers.groupai:state():all_char_criminals())
					do
						do break end
						table.insert(instigators, data.unit)
					end

				else
					(for control) = managers.groupai:state():all_char_criminals() and table
					if self._values.instigator == "local_criminals" then
						table.insert(instigators, managers.player:player_unit())
						local (for generator), (for state), (for control) = pairs(managers.groupai:state():all_AI_criminals())
						do
							do break end
							table.insert(instigators, data.unit)
						end

					else
						(for control) = managers.groupai:state():all_AI_criminals() and table
						if self._values.instigator == "ai_teammates" then
							local (for generator), (for state), (for control) = pairs(managers.groupai:state():all_AI_criminals())
							do
								do break end
								table.insert(instigators, data.unit)
							end

						else
							(for control) = managers.groupai:state():all_AI_criminals() and table
							if self._values.instigator == "loot" or self._values.instigator == "unique_loot" then
								local all_found = World:find_units_quick("all", 14)
								local filter_func
								if self._values.instigator == "loot" then
									function filter_func(carry_data)
										local carry_id = carry_data:carry_id()
										if carry_id == "gold" or carry_id == "money" or carry_id == "diamonds" or carry_id == "coke" or carry_id == "weapon" or carry_id == "painting" or carry_id == "circuit" or carry_id == "diamonds" or carry_id == "engine_01" or carry_id == "engine_02" or carry_id == "engine_03" or carry_id == "engine_04" or carry_id == "engine_05" or carry_id == "engine_06" or carry_id == "engine_07" or carry_id == "engine_08" or carry_id == "engine_09" or carry_id == "engine_10" or carry_id == "engine_11" or carry_id == "engine_12" or carry_id == "meth" or carry_id == "lance_bag" or carry_id == "lance_bag_large" or carry_id == "grenades" or carry_id == "ammo" or carry_id == "cage_bag" or carry_id == "turret" then
											return true
										end

									end

								else
									function filter_func(carry_data)
										local carry_id = carry_data:carry_id()
										if tweak_data.carry[carry_id].is_unique_loot then
											return true
										end

									end

								end

								local (for generator), (for state), (for control) = ipairs(all_found)
								do
									do break end
									local carry_data = unit:carry_data()
									if carry_data and filter_func(carry_data) then
										table.insert(instigators, unit)
									end

								end

							end

						end

					end

				end

			end

		end

	end

end

function ElementAreaTrigger:project_amount_all()
	if self._values.instigator == "criminals" or self._values.instigator == "local_criminals" then
		local i = 0
		do
			local (for generator), (for state), (for control) = pairs(managers.groupai:state():all_char_criminals())
			do
				do break end
				i = i + 1
			end

		end

		do return i end
		(for control) = managers.groupai:state():all_char_criminals() and i + 1
	elseif self._values.instigator == "ai_teammates" then
		local i = 0
		do
			local (for generator), (for state), (for control) = pairs(managers.groupai:state():all_AI_criminals())
			do
				do break end
				i = i + 1
			end

		end

		return i
	end

	(for control) = managers.groupai:state():all_AI_criminals() and i + 1
	return managers.network:game():amount_of_alive_players()
end

CoreClass.override_class(CoreElementArea.ElementAreaTrigger, ElementAreaTrigger)
