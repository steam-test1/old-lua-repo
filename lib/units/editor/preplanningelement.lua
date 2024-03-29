PrePlanningUnitElement = PrePlanningUnitElement or class(MissionElement)
function PrePlanningUnitElement:init(unit)
	PrePlanningUnitElement.super.init(self, unit)
	self._hed.allowed_types = {}
	self._hed.disables_types = {}
	self._hed.location_group = tweak_data.preplanning.location_groups[1]
	self._hed.upgrade_lock = "none"
	self._hed.dlc_lock = "none"
	table.insert(self._save_values, "allowed_types")
	table.insert(self._save_values, "disables_types")
	table.insert(self._save_values, "location_group")
	table.insert(self._save_values, "upgrade_lock")
	table.insert(self._save_values, "dlc_lock")
end

function PrePlanningUnitElement:_create_dynamic_on_executed_alternatives()
	PrePlanningUnitElement.ON_EXECUTED_ALTERNATIVES = {"any"}
	for _, type in ipairs(managers.preplanning:types()) do
		table.insert(PrePlanningUnitElement.ON_EXECUTED_ALTERNATIVES, type)
	end
end

function PrePlanningUnitElement:_data_updated(value_type, value)
	self._hed[value_type] = value
end

function PrePlanningUnitElement:_build_panel(panel, panel_sizer)
	self:_create_panel()
	panel = panel or self._panel
	panel_sizer = panel_sizer or self._panel_sizer
	self:_build_value_combobox(panel, panel_sizer, "upgrade_lock", tweak_data.preplanning.upgrade_locks, "Select a upgrade lock from the combobox")
	self:_build_value_combobox(panel, panel_sizer, "dlc_lock", tweak_data.preplanning.dlc_locks, "Select a DLC lock from the combobox")
	self:_build_value_combobox(panel, panel_sizer, "location_group", tweak_data.preplanning.location_groups, "Select a location group from the combobox")
	local allowed_params = {
		name = "Allowed Types:",
		panel = panel,
		sizer = panel_sizer,
		options = managers.preplanning:types(),
		value = self._hed.allowed_types,
		tooltip = "Select allowed preplanning types for this point",
		updated_callback = callback(self, self, "_data_updated", "allowed_types")
	}
	CoreEws.list_selector(allowed_params)
	local disables_params = {
		name = "Disables Types:",
		panel = panel,
		sizer = panel_sizer,
		options = managers.preplanning:types(),
		value = self._hed.disables_types,
		tooltip = "Select preplanning types that are disabled if point is used",
		updated_callback = callback(self, self, "_data_updated", "disables_types")
	}
	CoreEws.list_selector(disables_params)
end

