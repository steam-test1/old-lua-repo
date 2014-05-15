core:import("CoreMissionScriptElement")
ElementCharacterOutline = ElementCharacterOutline or class(CoreMissionScriptElement.MissionScriptElement)
function ElementCharacterOutline:init(...)
	ElementCharacterOutline.super.init(self, ...)
end

function ElementCharacterOutline:client_on_executed(...)
	self:on_executed(...)
end

function ElementCharacterOutline:on_executed(instigator)
	if not self._values.enabled then
		return
	end

	local all_civilians = managers.enemy:all_civilians()
	do
		local (for generator), (for state), (for control) = pairs(all_civilians)
		do
			do break end
			local data = u_data.unit:brain()._logic_data
			if data and not data.been_outlined and data.char_tweak.outline_on_discover then
				CivilianLogicIdle._enable_outline(data)
			end

		end

	end

	(for control) = nil and u_data.unit
	ElementCharacterOutline.super.on_executed(self, instigator)
end

