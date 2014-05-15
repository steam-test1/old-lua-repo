core:module("DebugManager")
core:import("CoreDebugManager")
core:import("CoreClass")
DebugManager = DebugManager or class(CoreDebugManager.DebugManager)
function DebugManager:qa_debug(username)
	self:set_qa_debug_enabled(username, true)
end

function DebugManager:get_qa_debug_enabled()
	return self._qa_debug_enabled
end

function DebugManager:set_qa_debug_enabled(username, enabled)
