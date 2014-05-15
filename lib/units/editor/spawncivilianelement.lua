core:import("CoreEditorUtils")
core:import("CoreUnit")
SpawnCivilianUnitElement = SpawnCivilianUnitElement or class(MissionElement)
SpawnCivilianUnitElement.USES_POINT_ORIENTATION = true
SpawnCivilianUnitElement._options = {
	"units/payday2/characters/civ_female_bank_1/civ_female_bank_1",
	"units/payday2/characters/civ_female_bank_manager_1/civ_female_bank_manager_1",
	"units/payday2/characters/civ_female_bikini_1/civ_female_bikini_1",
	"units/payday2/characters/civ_female_bikini_2/civ_female_bikini_2",
	"units/payday2/characters/civ_female_casual_1/civ_female_casual_1",
	"units/payday2/characters/civ_female_casual_2/civ_female_casual_2",
	"units/payday2/characters/civ_female_casual_3/civ_female_casual_3",
	"units/payday2/characters/civ_female_casual_4/civ_female_casual_4",
	"units/payday2/characters/civ_female_casual_5/civ_female_casual_5",
	"units/payday2/characters/civ_female_casual_6/civ_female_casual_6",
	"units/payday2/characters/civ_female_casual_7/civ_female_casual_7",
	"units/payday2/characters/civ_female_crackwhore_1/civ_female_crackwhore_1",
	"units/payday2/characters/civ_female_hostess_apron_1/civ_female_hostess_apron_1",
	"units/payday2/characters/civ_female_hostess_jacket_1/civ_female_hostess_jacket_1",
	"units/payday2/characters/civ_female_hostess_shirt_1/civ_female_hostess_shirt_1",
	"units/payday2/characters/civ_female_party_1/civ_female_party_1",
	"units/payday2/characters/civ_female_party_2/civ_female_party_2",
	"units/payday2/characters/civ_female_party_3/civ_female_party_3",
	"units/payday2/characters/civ_female_party_4/civ_female_party_4",
	"units/payday2/characters/civ_female_wife_trophy_1/civ_female_wife_trophy_1",
	"units/payday2/characters/civ_female_wife_trophy_2/civ_female_wife_trophy_2",
	"units/payday2/characters/civ_male_bank_1/civ_male_bank_1",
	"units/payday2/characters/civ_male_bank_2/civ_male_bank_2",
	"units/payday2/characters/civ_male_bank_manager_1/civ_male_bank_manager_1",
	"units/payday2/characters/civ_male_bank_manager_3/civ_male_bank_manager_3",
	"units/payday2/characters/civ_male_bank_manager_4/civ_male_bank_manager_4",
	"units/payday2/characters/civ_male_business_1/civ_male_business_1",
	"units/payday2/characters/civ_male_business_2/civ_male_business_2",
	"units/payday2/characters/civ_male_casual_1/civ_male_casual_1",
	"units/payday2/characters/civ_male_casual_2/civ_male_casual_2",
	"units/payday2/characters/civ_male_casual_3/civ_male_casual_3",
	"units/payday2/characters/civ_male_casual_4/civ_male_casual_4",
	"units/payday2/characters/civ_male_casual_5/civ_male_casual_5",
	"units/payday2/characters/civ_male_casual_6/civ_male_casual_6",
	"units/payday2/characters/civ_male_casual_7/civ_male_casual_7",
	"units/payday2/characters/civ_male_casual_8/civ_male_casual_8",
	"units/payday2/characters/civ_male_casual_9/civ_male_casual_9",
	"units/payday2/characters/civ_male_dj_1/civ_male_dj_1",
	"units/payday2/characters/civ_male_italian_robe_1/civ_male_italian_robe_1",
	"units/payday2/characters/civ_male_janitor_1/civ_male_janitor_1",
	"units/payday2/characters/civ_male_meth_cook_1/civ_male_meth_cook_1",
	"units/payday2/characters/civ_male_party_1/civ_male_party_1",
	"units/payday2/characters/civ_male_party_2/civ_male_party_2",
	"units/payday2/characters/civ_male_party_3/civ_male_party_3",
	"units/payday2/characters/civ_male_scientist_1/civ_male_scientist_1",
	"units/payday2/characters/civ_male_trucker_1/civ_male_trucker_1",
	"units/payday2/characters/civ_male_worker_docks_1/civ_male_worker_docks_1",
	"units/payday2/characters/civ_male_worker_docks_2/civ_male_worker_docks_2",
	"units/payday2/characters/civ_male_worker_docks_3/civ_male_worker_docks_3",
	"units/payday2/characters/civ_male_worker_1/civ_male_worker_1",
	"units/payday2/characters/civ_male_worker_2/civ_male_worker_2",
	"units/payday2/characters/civ_male_worker_3/civ_male_worker_3",
	"units/payday2/characters/npc_getaway_driver_1/npc_getaway_driver_1",
	"units/pd2_dlc1/characters/civ_male_paramedic_1/civ_male_paramedic_1",
	"units/pd2_dlc1/characters/civ_male_paramedic_2/civ_male_paramedic_2",
	"units/pd2_dlc1/characters/civ_male_firefighter_1/civ_male_firefighter_1",
	"units/pd2_dlc1/characters/civ_male_casual_10/civ_male_casual_10",
	"units/pd2_dlc1/characters/civ_male_casual_11/civ_male_casual_11",
	"units/pd2_dlc1/characters/civ_male_bank_manager_2/civ_male_bank_manager_2",
	"units/pd2_dlc2/characters/civ_female_bank_assistant_1/civ_female_bank_assistant_1",
	"units/pd2_dlc2/characters/civ_female_bank_assistant_2/civ_female_bank_assistant_2",
	"units/pd2_dlc3/characters/civ_female_casino_1/civ_female_casino_1",
	"units/pd2_dlc3/characters/civ_female_casino_2/civ_female_casino_2",
	"units/pd2_dlc3/characters/civ_female_casino_3/civ_female_casino_3"
}
function SpawnCivilianUnitElement:init(unit)
	SpawnCivilianUnitElement.super.init(self, unit)
	self._enemies = {}
	self._states = CopActionAct._act_redirects.civilian_spawn
	self._hed.state = "none"
	self._hed.enemy = "units/payday2/characters/civ_male_casual_1/civ_male_casual_1"
	self._hed.force_pickup = "none"
	table.insert(self._save_values, "enemy")
	table.insert(self._save_values, "state")
	table.insert(self._save_values, "force_pickup")
end

function SpawnCivilianUnitElement:post_init(...)
	SpawnCivilianUnitElement.super.post_init(self, ...)
	self:_load_pickup()
end

function SpawnCivilianUnitElement:test_element()
	SpawnEnemyUnitElement.test_element(self)
end

function SpawnCivilianUnitElement:get_spawn_anim()
	return self._hed.state
end

function SpawnCivilianUnitElement:stop_test_element()
	do
		local (for generator), (for state), (for control) = ipairs(self._enemies)
		do
			do break end
			if enemy:base() and enemy:base().set_slot then
				enemy:base():set_slot(enemy, 0)
			else
				enemy:set_slot(0)
			end

		end

	end

	self._enemies = nil and {}
end

function SpawnCivilianUnitElement:select_civilian_btn()
	local dialog = SelectNameModal:new("Select unit", self._options)
	if dialog:cancelled() then
		return
	end

	local (for generator), (for state), (for control) = ipairs(dialog:_selected_item_assets())
	do
		do break end
		self._hed.enemy = unit
		CoreEws.change_combobox_value(self._enemies_params, self._hed.enemy)
	end

end

function SpawnCivilianUnitElement:select_state_btn()
	local dialog = SelectNameModal:new("Select state", self._states)
	if dialog:cancelled() then
		return
	end

	local (for generator), (for state), (for control) = ipairs(dialog:_selected_item_assets())
	do
		do break end
		self._hed.state = state
		CoreEws.change_combobox_value(self._states_params, self._hed.state)
	end

end

function SpawnCivilianUnitElement:_build_panel(panel, panel_sizer)
	self:_create_panel()
	panel = panel or self._panel
	panel_sizer = panel_sizer or self._panel_sizer
	local enemy_sizer = EWS:BoxSizer("HORIZONTAL")
	panel_sizer:add(enemy_sizer, 0, 1, "EXPAND,LEFT")
	local enemies_params = {
		name = "Enemy:",
		panel = panel,
		sizer = enemy_sizer,
		options = self._options,
		value = self._hed.enemy,
		tooltip = "Select an enemy from the combobox",
		name_proportions = 1,
		ctrlr_proportions = 2,
		sizer_proportions = 1,
		sorted = true
	}
	local enemies = CoreEWS.combobox(enemies_params)
	enemies:connect("EVT_COMMAND_COMBOBOX_SELECTED", callback(self, self, "set_element_data"), {ctrlr = enemies, value = "enemy"})
	self._enemies_params = enemies_params
	local toolbar = EWS:ToolBar(panel, "", "TB_FLAT,TB_NODIVIDER")
	toolbar:add_tool("SELECT", "Select unit", CoreEws.image_path("world_editor\\unit_by_name_list.png"), nil)
	toolbar:connect("SELECT", "EVT_COMMAND_MENU_SELECTED", callback(self, self, "select_civilian_btn"), nil)
	toolbar:realize()
	enemy_sizer:add(toolbar, 0, 1, "EXPAND,LEFT")
	local state_sizer = EWS:BoxSizer("HORIZONTAL")
	panel_sizer:add(state_sizer, 0, 1, "EXPAND,LEFT")
	local states_params = {
		name = "State:",
		panel = panel,
		sizer = state_sizer,
		options = self._states,
		value = self._hed.state,
		default = "none",
		tooltip = "Select a state from the combobox",
		name_proportions = 1,
		ctrlr_proportions = 2,
		sizer_proportions = 1,
		sorted = true
	}
	local states = CoreEWS.combobox(states_params)
	states:connect("EVT_COMMAND_COMBOBOX_SELECTED", callback(self, self, "set_element_data"), {ctrlr = states, value = "state"})
	self._states_params = states_params
	local toolbar = EWS:ToolBar(panel, "", "TB_FLAT,TB_NODIVIDER")
	toolbar:add_tool("SELECT", "Select state", CoreEws.image_path("world_editor\\unit_by_name_list.png"), nil)
	toolbar:connect("SELECT", "EVT_COMMAND_MENU_SELECTED", callback(self, self, "select_state_btn"), nil)
	toolbar:realize()
	state_sizer:add(toolbar, 0, 1, "EXPAND,LEFT")
	local pickups = {}
	do
		local (for generator), (for state), (for control) = pairs(tweak_data.pickups)
		do
			do break end
			table.insert(pickups, name)
		end

	end

	(for control) = 1 and table
	local pickup_params = {
		name = "Force Pickup:",
		panel = panel,
		sizer = panel_sizer,
		options = pickups,
		value = self._hed.force_pickup,
		default = "none",
		tooltip = "Select a pickup to be forced spawned when characters from this element dies.",
		name_proportions = 1,
		ctrlr_proportions = 2,
		sorted = true
	}
	local force_pickup = CoreEWS.combobox(pickup_params)
	force_pickup:connect("EVT_COMMAND_COMBOBOX_SELECTED", callback(self, self, "set_element_data"), {
		ctrlr = force_pickup,
		value = "force_pickup"
	})
	force_pickup:connect("EVT_COMMAND_COMBOBOX_SELECTED", callback(self, self, "_load_pickup"), nil)
end

function SpawnCivilianUnitElement:_load_pickup()
	if self._hed.force_pickup ~= "none" then
		local unit_name = tweak_data.pickups[self._hed.force_pickup].unit
		CoreUnit.editor_load_unit(unit_name)
	end

end

function SpawnCivilianUnitElement:add_to_mission_package()
	if self._hed.force_pickup ~= "none" then
		local unit_name = tweak_data.pickups[self._hed.force_pickup].unit
		managers.editor:add_to_world_package({
			category = "units",
			name = unit_name:s(),
			continent = self._unit:unit_data().continent
		})
		local sequence_files = {}
		CoreEditorUtils.get_sequence_files_by_unit_name(unit_name, sequence_files)
		local (for generator), (for state), (for control) = ipairs(sequence_files)
		do
			do break end
			managers.editor:add_to_world_package({
				category = "script_data",
				name = file:s() .. ".sequence_manager",
				continent = self._unit:unit_data().continent,
				init = true
			})
		end

	end

end

function SpawnCivilianUnitElement:destroy(...)
	SpawnCivilianUnitElement.super.destroy(self, ...)
	self:stop_test_element()
end
