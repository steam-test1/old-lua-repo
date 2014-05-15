DynamicResourceManager = DynamicResourceManager or class()
DynamicResourceManager.DYN_RESOURCES_PACKAGE = "packages/dyn_resources"
function DynamicResourceManager:init()
	self._dyn_resources = Global.dyn_resource_manager_data or {}
	Global.dyn_resource_manager_data = self._dyn_resources
	self._to_unload = nil
end

function DynamicResourceManager:update()
