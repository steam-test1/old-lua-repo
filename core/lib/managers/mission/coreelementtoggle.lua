core:module("CoreElementToggle")
core:import("CoreMissionScriptElement")
ElementToggle = ElementToggle or class(CoreMissionScriptElement.MissionScriptElement)
function ElementToggle:init(...)
	ElementToggle.super.init(self, ...)
end

function ElementToggle:client_on_executed(...)
	self:on_executed(...)
end

function ElementToggle:on_executed(instigator)
	if not self._values.enabled then
		return
	end

	do
		local (for generator), (for state), (for control) = ipairs(self._values.elements)
		do
			do break end
			local element = self:get_mission_element(id)
			if element then
				if self._values.toggle == "on" then
					element:set_enabled(true)
					if self._values.set_trigger_times and self._values.set_trigger_times > -1 then
						element:set_trigger_times(self._values.set_trigger_times)
					end

				elseif self._values.toggle == "off" then
					element:set_enabled(false)
				else
					element:set_enabled(not element:value("enabled"))
				end

				element:on_toggle(element:value("enabled"))
			end

		end

	end

	(for control) = nil and self.get_mission_element
	ElementToggle.super.on_executed(self, instigator)
end

