core:import("CoreMissionScriptElement")
ElementAIRemove = ElementAIRemove or class(CoreMissionScriptElement.MissionScriptElement)
function ElementAIRemove:init(...)
	ElementAIRemove.super.init(self, ...)
end

function ElementAIRemove:on_executed(instigator)
	if not self._values.enabled then
		return
	end

	if self._values.use_instigator then
		if self._values.true_death then
			instigator:character_damage():damage_mission({
				damage = 1000,
				col_ray = {}
			})
		else
			instigator:brain():set_active(false)
			instigator:base():set_slot(instigator, 0)
		end

	else
		local (for generator), (for state), (for control) = ipairs(self._values.elements)
		do
			do break end
			local element = self:get_mission_element(id)
			if self._values.true_death then
				element:kill_all_units()
			else
				element:unspawn_all_units()
			end

		end

	end

	ElementAIRemove.super.on_executed(self, instigator)
end

