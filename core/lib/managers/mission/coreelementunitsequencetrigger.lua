core:module("CoreElementUnitSequenceTrigger")
core:import("CoreMissionScriptElement")
core:import("CoreCode")
ElementUnitSequenceTrigger = ElementUnitSequenceTrigger or class(CoreMissionScriptElement.MissionScriptElement)
function ElementUnitSequenceTrigger:init(...)
	ElementUnitSequenceTrigger.super.init(self, ...)
	if not self._values.sequence_list and self._values.sequence then
		self._values.sequence_list = {
			{
				unit_id = self._values.unit_id,
				sequence = self._values.sequence
			}
		}
	end

end

function ElementUnitSequenceTrigger:on_script_activated()
