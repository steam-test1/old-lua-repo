core:module("CoreAiLayer")
core:import("CoreStaticLayer")
core:import("CoreTable")
core:import("CoreEws")
require("core/lib/units/data/CoreAiEditorData")
AiLayer = AiLayer or class(CoreStaticLayer.StaticLayer)
function AiLayer:init(owner)
	AiLayer.super.init(self, owner, "ai", {"ai"}, "ai_layer")
	self._brush = Draw:brush()
	self._graph_types = {surface = "surface"}
	self._unit_graph_types = {}
	self._unit_graph_types.surface = Idstring("core/units/nav_surface/nav_surface")
	self._nav_surface_unit = Idstring("core/units/nav_surface/nav_surface")
	self._patrol_point_unit = Idstring("core/units/patrol_point/patrol_point")
	self:_init_ai_settings()
	self._patrol_path_brush = Draw:brush()
	self._only_draw_selected_patrol_path = false
	self._default_values = {}
	self._default_values.all_visible = true
end

function AiLayer:load(world_holder, offset)
	AiLayer.super.load(self, world_holder, offset)
	local ai_settings = world_holder:create_world("world", "ai_settings", offset)
	for name, value in pairs(ai_settings or {}) do
		self._ai_settings[name] = value
	end
	managers.ai_data:load_units(self._created_units)
	self:_update_patrol_paths_list()
	self:_update_motion_paths_list()
	self:_update_settings()
end

function AiLayer:save(save_params)
	AiLayer.super.save(self, save_params)
	local file_name = "nav_manager_data"
	local path = save_params.dir .. "\\" .. file_name .. ".nav_data"
	local file = managers.editor:_open_file(path, nil, true)
	file:puts(managers.navigation:get_save_data())
	SystemFS:close(file)
	local t = {
		entry = "ai_nav_graphs",
		single_data_block = true,
		data = {file = file_name}
	}
	managers.editor:add_save_data(t)
	local t = {
		entry = "ai_settings",
		single_data_block = true,
		data = {
			ai_settings = self._ai_settings,
			ai_data = managers.ai_data:save_data()
		}
	}
	managers.editor:add_save_data(t)
	if managers.motion_path:paths_exist() then
		local mop_filename = "mop_manager_data"
		local mop_path = save_params.dir .. "\\" .. mop_filename .. ".mop_data"
		local mop_file = managers.editor:_open_file(mop_path, nil, true)
		mop_file:puts(managers.motion_path:get_save_data())
		SystemFS:close(mop_file)
		local t = {
			entry = "ai_mop_graphs",
			single_data_block = true,
			data = {file = mop_filename}
		}
		managers.editor:add_save_data(t)
	end
end

function AiLayer:_add_project_unit_save_data(unit, data)
	if unit:name() == self._nav_surface_unit then
		data.ai_editor_data = unit:ai_editor_data()
	end
end

function AiLayer:update(t, dt)
	AiLayer.super.update(self, t, dt)
	if managers.navigation:is_data_ready() ~= self._graph_status then
		self._graph_status = managers.navigation:is_data_ready()
		local text = self._graph_status and "Graph is correct" or "Graph is incomplete"
		local color = self._graph_status and Vector3(0, 200, 0) or Vector3(200, 0, 0)
		self._status_text:change_value("")
		self._status_text:set_default_style_colour(color)
		self._status_text:append(text)
	end
	self:_draw(t, dt)
end

function AiLayer:external_draw(t, dt)
	self:_draw(t, dt)
end

function AiLayer:_draw(t, dt)
	for _, unit in ipairs(self._created_units) do
		local selected = unit == self._selected_unit
		if unit:name() == self._nav_surface_unit then
			local a = selected and 0.75 or 0.5
			local r = selected and 0 or 1
			local g = selected and 1 or 1
			local b = selected and 0 or 1
			self._brush:set_color(Color(a, r, g, b))
			self:_draw_surface(unit, t, dt, a, r, g, b)
			if selected then
				for id, _ in pairs(unit:ai_editor_data().visibilty_exlude_filter) do
					for _, to_unit in ipairs(self._created_units) do
						if to_unit:unit_data().unit_id == id then
							Application:draw_link({
								from_unit = unit,
								to_unit = to_unit,
								r = 1,
								g = 0,
								b = 0
							})
						end
					end
				end
				for id, _ in pairs(unit:ai_editor_data().visibilty_include_filter) do
					for _, to_unit in ipairs(self._created_units) do
						if to_unit:unit_data().unit_id == id then
							Application:draw_link({
								from_unit = unit,
								to_unit = to_unit,
								r = 0,
								g = 1,
								b = 0
							})
						end
					end
				end
			end
		elseif unit:name() == self._patrol_point_unit then
		end
	end
	self:_draw_patrol_paths(t, dt)
end

function AiLayer:_draw_surface(unit, t, dt, a, r, g, b)
	local rot1 = Rotation(math.sin(t * 10) * 180, 0, 0)
	local rot2 = rot1 * Rotation(90, 0, 0)
	local pos1 = unit:position() - rot1:y() * 100
	local pos2 = unit:position() - rot2:y() * 100
	Application:draw_line(pos1, pos1 + rot1:y() * 200, r, g, b)
	Application:draw_line(pos2, pos2 + rot2:y() * 200, r, g, b)
	self._brush:quad(pos1, pos2, pos1 + rot1:y() * 200, pos2 + rot2:y() * 200)
end

function AiLayer:_draw_patrol_paths(t, dt)
	if self._only_draw_selected_patrol_path and self._current_patrol_path then
		self:_draw_patrol_path(self._current_patrol_path, managers.ai_data:all_patrol_paths()[self._current_patrol_path], t, dt)
	else
		for name, path in pairs(managers.ai_data:all_patrol_paths()) do
			self:_draw_patrol_path(name, path, t, dt)
		end
	end
end

function AiLayer:_draw_patrol_path(name, path, t, dt)
	local selected_path = name == self._current_patrol_path
	if #path.points > 0 then
		for i, point in ipairs(path.points) do
			local to_unit
			if i == #path.points then
				to_unit = path.points[1].unit
			else
				to_unit = path.points[i + 1].unit
			end
			self._patrol_path_brush:set_color(Color.white:with_alpha(selected_path and 1 or 0.25))
			Application:draw_link({
				from_unit = point.unit,
				to_unit = to_unit,
				r = 1,
				g = 1,
				b = 1,
				thick = true,
				circle_multiplier = selected_path and 0.5 or 0.25,
				height_offset = 0
			})
			self:_draw_patrol_point(point.unit, i == 1, i == #path.points, selected_path, t, dt)
			if point.unit == self._selected_unit then
				local dir = to_unit:position() - point.unit:position()
				self._mid_pos = point.unit:position() + dir / 2
				Application:draw_sphere(self._mid_pos, 10, 0, 0, 1)
			end
		end
	end
end

function AiLayer:_draw_patrol_point(unit, first, last, selected_path, t, dt)
	local selected = unit == self._selected_unit
	local r = selected and 0 or first and 0.5 or last and 1 or 0.65
	local g = selected and 1 or first and 1 or last and 0.5 or 0.65
	local b = selected and 0 or first and 0.5 or last and 0.5 or 0.65
	self._patrol_path_brush:set_color(Color(r, g, b):with_alpha(selected_path and 1 or 0.25))
	self._patrol_path_brush:sphere(unit:position(), selected_path and (first and 20 or 20) or first and 10 or 10)
end

function AiLayer:draw_patrol_path_externaly(name)
	self:_draw_patrol_path(name, managers.ai_data:patrol_path(name))
end

function AiLayer:build_panel(notebook)
	AiLayer.super.build_panel(self, notebook)
	local ai_sizer = EWS:BoxSizer("VERTICAL")
	local graphs_sizer = EWS:StaticBoxSizer(self._ews_panel, "VERTICAL", "Graphs")
	local graphs = EWS:ListBox(self._ews_panel, "", "LB_EXTENDED,LB_HSCROLL,LB_NEEDED_SB,LB_SORT")
	for name, _ in pairs(self._graph_types) do
		graphs:append(name)
	end
	for i = 0, graphs:nr_items() - 1 do
		graphs:select_index(i)
	end
	graphs_sizer:add(graphs, 1, 0, "EXPAND")
	local button_sizer1 = EWS:StaticBoxSizer(self._ews_panel, "HORIZONTAL", "Calculate")
	local calc_btn = EWS:Button(self._ews_panel, "All", "", "BU_EXACTFIT,NO_BORDER")
	button_sizer1:add(calc_btn, 0, 5, "RIGHT")
	calc_btn:connect("EVT_COMMAND_BUTTON_CLICKED", callback(self, self, "_calc_graphs"), {build_type = "all", vis_graph = true})
	local calc_selected_btn = EWS:Button(self._ews_panel, "Selected", "", "BU_EXACTFIT,NO_BORDER")
	button_sizer1:add(calc_selected_btn, 0, 5, "RIGHT")
	calc_selected_btn:connect("EVT_COMMAND_BUTTON_CLICKED", callback(self, self, "_calc_graphs"), {build_type = "selected", vis_graph = true})
	local calc_ground_btn = EWS:Button(self._ews_panel, "Ground All", "", "BU_EXACTFIT,NO_BORDER")
	button_sizer1:add(calc_ground_btn, 0, 5, "RIGHT")
	calc_ground_btn:connect("EVT_COMMAND_BUTTON_CLICKED", callback(self, self, "_calc_graphs"), {build_type = "all", vis_graph = false})
	local calc_ground_selected_btn = EWS:Button(self._ews_panel, "Ground Selected", "", "BU_EXACTFIT,NO_BORDER")
	button_sizer1:add(calc_ground_selected_btn, 0, 5, "RIGHT")
	calc_ground_selected_btn:connect("EVT_COMMAND_BUTTON_CLICKED", callback(self, self, "_calc_graphs"), {build_type = "selected", vis_graph = false})
	local calc_vis_graph_btn = EWS:Button(self._ews_panel, "Visibility", "", "BU_EXACTFIT,NO_BORDER")
	button_sizer1:add(calc_vis_graph_btn, 0, 5, "RIGHT")
	calc_vis_graph_btn:connect("EVT_COMMAND_BUTTON_CLICKED", callback(self, self, "_build_visibility_graph"), nil)
	graphs_sizer:add(button_sizer1, 0, 0, "EXPAND")
	local button_sizer2 = EWS:BoxSizer("HORIZONTAL")
	local clear_btn = EWS:Button(self._ews_panel, "Clear All", "", "BU_EXACTFIT,NO_BORDER")
	button_sizer2:add(clear_btn, 0, 5, "RIGHT")
	clear_btn:connect("EVT_COMMAND_BUTTON_CLICKED", callback(self, self, "_clear_graphs"), nil)
	local clear_selected_btn = EWS:Button(self._ews_panel, "Clear Selected", "", "BU_EXACTFIT,NO_BORDER")
	button_sizer2:add(clear_selected_btn, 0, 5, "RIGHT")
	clear_selected_btn:connect("EVT_COMMAND_BUTTON_CLICKED", callback(self, self, "_clear_selected_nav_segment"), nil)
	graphs_sizer:add(button_sizer2, 0, 0, "EXPAND")
	local build_settings = EWS:StaticBoxSizer(self._ews_panel, "VERTICAL", "Build Settings")
	self._all_visible = EWS:CheckBox(self._ews_panel, "All visible", "", "ALIGN_LEFT")
	self._all_visible:set_value(self._default_values.all_visible)
	build_settings:add(self._all_visible, 0, 0, "EXPAND")
	self._ray_length_params = {
		name = "Ray length [cm]:",
		panel = self._ews_panel,
		sizer = build_settings,
		value = 150,
		floats = 0,
		tooltip = "Specifies the visible graph ray lenght in centimeter",
		min = 1,
		name_proportions = 1,
		ctrlr_proportions = 1
	}
	CoreEws.number_controller(self._ray_length_params)
	graphs_sizer:add(build_settings, 0, 0, "EXPAND")
	local visualize_sizer = EWS:StaticBoxSizer(self._ews_panel, "VERTICAL", "Visualize")
	self._debug_draw = EWS:CheckBox(self._ews_panel, "Debug draw", "", "ALIGN_LEFT")
	visualize_sizer:add(self._debug_draw, 0, 0, "EXPAND")
	self._debug_draw:connect("EVT_COMMAND_CHECKBOX_CLICKED", callback(self, self, "_toggle_debug_draw"), self._debug_draw)
	self._debug_buttons = {}
	self._debug_buttons.doors = EWS:RadioButton(self._ews_panel, "Doors", "draw_debug", "")
	self._debug_buttons.vis_graph = EWS:RadioButton(self._ews_panel, "Vis graph", "draw_debug", "")
	self._debug_buttons.coarse_graph = EWS:RadioButton(self._ews_panel, "Coarse graph", "draw_debug", "")
	self._debug_buttons.blockers = EWS:RadioButton(self._ews_panel, "Blockers", "draw_debug", "")
	self._debug_buttons.doors:set_value(true)
	for _, ctrlr in pairs(self._debug_buttons) do
		visualize_sizer:add(ctrlr, 0, 0, "")
	end
	self._ews_panel:connect("draw_debug", "EVT_COMMAND_RADIOBUTTON_SELECTED", callback(self, self, "_set_debug_options"), nil)
	graphs_sizer:add(visualize_sizer, 0, 0, "EXPAND")
	self._status_text = EWS:TextCtrl(self._ews_panel, "", 0, "TE_NOHIDESEL,TE_RICH2,TE_DONTWRAP,TE_READONLY,TE_CENTRE")
	graphs_sizer:add(self._status_text, 0, 0, "EXPAND,ALIGN_CENTER")
	ai_sizer:add(graphs_sizer, 0, 0, "EXPAND")
	ai_sizer:add(self:_build_ai_settings(), 0, 0, "EXPAND")
	ai_sizer:add(self:_build_ai_unit_settings(), 0, 0, "EXPAND")
	ai_sizer:add(self:_build_ai_data(), 1, 0, "EXPAND")
	ai_sizer:add(self:_build_motion_path_section(), 1, 0, "EXPAND")
	self._sizer:add(ai_sizer, 4, 0, "EXPAND")
	self._graphs = graphs
	return self._ews_panel
end

function AiLayer:_build_ai_settings()
	local graphs_sizer = EWS:StaticBoxSizer(self._ews_panel, "VERTICAL", "Settings")
	local group_state = {
		name = "Group state:",
		panel = self._ews_panel,
		sizer = graphs_sizer,
		options = managers.groupai:state_names(),
		value = self._ai_settings.group_state,
		tooltip = "Select a group state from the combo box",
		name_proportions = 1,
		ctrlr_proportions = 2,
		sorted = true
	}
	local state = CoreEws.combobox(group_state)
	state:connect("EVT_COMMAND_COMBOBOX_SELECTED", callback(self, self, "_set_group_state"), nil)
	self._ai_settings_guis = {}
	self._ai_settings_guis.group_state = group_state
	return graphs_sizer
end

function AiLayer:_build_ai_unit_settings()
	local options = {}
	for _, id_string in ipairs(managers.localization:ids("strings/atmospheric_text")) do
		local s = id_string:s()
		if string.find(s, "location_") then
			table.insert(options, s)
		end
	end
	local sizer = EWS:StaticBoxSizer(self._ews_panel, "VERTICAL", "Unit settings")
	local locations = {
		name = "Location id:",
		panel = self._ews_panel,
		sizer = sizer,
		options = options,
		value = "location_unknown",
		tooltip = "Select a location id to be associated with this navigation point",
		name_proportions = 1,
		ctrlr_proportions = 2,
		sorted = true
	}
	local locations_ctrlr = CoreEws.combobox(locations)
	locations_ctrlr:connect("EVT_COMMAND_COMBOBOX_SELECTED", callback(self, self, "_set_location"), nil)
	local text_sizer = EWS:BoxSizer("HORIZONTAL")
	text_sizer:add(EWS:StaticText(self._ews_panel, "Text: ", "", ""), 1, 2, "ALIGN_CENTER_VERTICAL,RIGHT,EXPAND")
	local text = EWS:StaticText(self._ews_panel, managers.localization:text("location_unknown"), "", "")
	text_sizer:add(text, 2, 2, "RIGHT,TOP,EXPAND")
	sizer:add(text_sizer, 1, 0, "EXPAND")
	local suspicion_multiplier = {
		name = "Suspicion Multiplier:",
		panel = self._ews_panel,
		sizer = sizer,
		value = 1,
		floats = 1,
		tooltip = "multiplier applied to suspicion buildup rate",
		min = 1,
		name_proportions = 1,
		ctrlr_proportions = 2
	}
	local suspicion_multiplier_ctrlr = CoreEws.number_controller(suspicion_multiplier)
	suspicion_multiplier_ctrlr:connect("EVT_COMMAND_TEXT_ENTER", callback(self, self, "_set_suspicion_mul"), nil)
	suspicion_multiplier_ctrlr:connect("EVT_KILL_FOCUS", callback(self, self, "_set_suspicion_mul"), nil)
	local detection_multiplier = {
		name = "Detection Multiplier:",
		panel = self._ews_panel,
		sizer = sizer,
		value = 1,
		floats = 2,
		tooltip = "multiplier applied to AI detection speed. min is 0.01",
		min = 0.01,
		name_proportions = 1,
		ctrlr_proportions = 2
	}
	local detection_multiplier_ctrlr = CoreEws.number_controller(detection_multiplier)
	detection_multiplier_ctrlr:connect("EVT_COMMAND_TEXT_ENTER", callback(self, self, "_set_detection_mul"), nil)
	detection_multiplier_ctrlr:connect("EVT_KILL_FOCUS", callback(self, self, "_set_detection_mul"), nil)
	self._ai_unit_settings_guis = {}
	self._ai_unit_settings_guis.locations = locations
	self._ai_unit_settings_guis.text = text
	self._ai_unit_settings_guis.suspicion_multiplier = suspicion_multiplier
	self._ai_unit_settings_guis.detection_multiplier = detection_multiplier
	return sizer
end

function AiLayer:_build_ai_data()
	local ai_data_sizer = EWS:StaticBoxSizer(self._ews_panel, "VERTICAL", "Ai Data")
	local patrol_paths_sizer = EWS:StaticBoxSizer(self._ews_panel, "HORIZONTAL", "Patrol paths")
	local patrol_path_toolbar = EWS:ToolBar(self._ews_panel, "", "TB_FLAT,TB_VERTICAL,TB_NODIVIDER")
	patrol_path_toolbar:add_tool("GT_CREATE_NEW", "Create New", CoreEws.image_path("toolbar\\new_16x16.png"), "Create a new patrol path")
	patrol_path_toolbar:connect("GT_CREATE_NEW", "EVT_COMMAND_MENU_SELECTED", callback(self, self, "_create_new_patrol_path"), nil)
	patrol_path_toolbar:add_tool("GT_DELETE", "Delete", CoreEws.image_path("toolbar\\delete_16x16.png"), "Delete a patrol path")
	patrol_path_toolbar:connect("GT_DELETE", "EVT_COMMAND_MENU_SELECTED", callback(self, self, "_delete_patrol_path"), nil)
	patrol_path_toolbar:add_check_tool("ONLY_DRAW_SELECTED_PATH", "Toggles draw on selected path", CoreEws.image_path("lock_16x16.png"), "Toggles draw on selected path")
	patrol_path_toolbar:set_tool_state("ONLY_DRAW_SELECTED_PATH", self._only_draw_selected_patrol_path)
	patrol_path_toolbar:connect("ONLY_DRAW_SELECTED_PATH", "EVT_COMMAND_MENU_SELECTED", callback(self, self, "_toggle_only_draw_selected_patrol_path"), patrol_path_toolbar)
	patrol_path_toolbar:realize()
	patrol_paths_sizer:add(patrol_path_toolbar, 0, 0, "EXPAND")
	self._patrol_paths_list = EWS:ListBox(self._ews_panel, "", "LB_SINGLE,LB_HSCROLL,LB_NEEDED_SB,LB_SORT")
	self._patrol_paths_list:connect("EVT_COMMAND_LISTBOX_SELECTED", callback(self, self, "_select_patrol_path"), nil)
	patrol_paths_sizer:add(self._patrol_paths_list, 1, 0, "EXPAND")
	ai_data_sizer:add(patrol_paths_sizer, 1, 0, "EXPAND")
	return ai_data_sizer
end

function AiLayer:_build_motion_path_section()
	local motion_paths_sizer = EWS:StaticBoxSizer(self._ews_panel, "VERTICAL", "Motion Paths (Work In Progress)")
	local create_paths_btn = EWS:Button(self._ews_panel, "Recreate Paths", "", "BU_EXACTFIT,NO_BORDER")
	motion_paths_sizer:add(create_paths_btn, 0, 5, "RIGHT")
	create_paths_btn:connect("EVT_COMMAND_BUTTON_CLICKED", callback(self, self, "_create_motion_paths"), nil)
	local motion_paths_list_sizer = EWS:StaticBoxSizer(self._ews_panel, "HORIZONTAL", "Generated motion paths list")
	local motion_path_toolbar = EWS:ToolBar(self._ews_panel, "", "TB_FLAT,TB_VERTICAL,TB_NODIVIDER")
	motion_path_toolbar:add_tool("GT_DELETE", "Delete", CoreEws.image_path("toolbar\\delete_16x16.png"), "Delete selected motion path and its markers.")
	motion_path_toolbar:connect("GT_DELETE", "EVT_COMMAND_MENU_SELECTED", callback(self, self, "_delete_motion_path"), nil)
	motion_path_toolbar:add_check_tool("ONLY_DRAW_SELECTED_MOTION_PATH", "Toggle draw on selected motion path.", CoreEws.image_path("lock_16x16.png"), "Toggle draw on selected motion path.")
	motion_path_toolbar:set_tool_state("ONLY_DRAW_SELECTED_MOTION_PATH", self._only_draw_selected_motion_path)
	motion_path_toolbar:connect("ONLY_DRAW_SELECTED_MOTION_PATH", "EVT_COMMAND_MENU_SELECTED", callback(self, self, "_toggle_only_draw_selected_motion_path"), motion_path_toolbar)
	motion_path_toolbar:realize()
	motion_paths_list_sizer:add(motion_path_toolbar, 0, 0, "EXPAND")
	self._motion_paths_list = EWS:ListBox(self._ews_panel, "", "LB_SINGLE,LB_HSCROLL,LB_NEEDED_SB,LB_SORT")
	self._motion_paths_list:connect("EVT_COMMAND_LISTBOX_SELECTED", callback(self, self, "_select_motion_path"), nil)
	motion_paths_list_sizer:add(self._motion_paths_list, 1, 0, "EXPAND")
	motion_paths_sizer:add(motion_paths_list_sizer, 1, 0, "EXPAND")
	return motion_paths_sizer
end

function AiLayer:_delete_motion_path()
	Application:debug("AiLayer:_delete_motion_path()")
end

function AiLayer:_toggle_only_draw_selected_motion_path(motion_path_toolbar)
	self._only_draw_selected_motion_path = motion_path_toolbar:tool_state("ONLY_DRAW_SELECTED_MOTION_PATH")
end

function AiLayer:_update_motion_paths_list()
	self._motion_paths_list:clear()
	for _, path in ipairs(managers.motion_path:get_all_paths()) do
		self._motion_paths_list:append(path.name)
	end
end

function AiLayer:_create_motion_paths()
	Application:debug("AiLayer:_create_motion_paths()")
	managers.motion_path:recreate_paths()
	self:_update_motion_paths_list()
end

function AiLayer:_select_motion_path()
	Application:debug("AiLayer:_select_motion_path()")
	local motion_path_name = self:_selected_motion_path()
	print("AiLayer:_select_motion_path() selected: ", motion_path_name)
	managers.motion_path:select_path(motion_path_name)
end

function AiLayer:_selected_motion_path()
	Application:debug("AiLayer:_selected_motion_path()")
	local index = self._motion_paths_list:selected_index()
	if index ~= -1 then
		return self._motion_paths_list:get_string(index)
	end
	return nil
end

function AiLayer:_toggle_only_draw_selected_patrol_path(patrol_path_toolbar)
	self._only_draw_selected_patrol_path = patrol_path_toolbar:tool_state("ONLY_DRAW_SELECTED_PATH")
end

function AiLayer:_calc_graphs(params)
	local build_type = params.build_type
	if build_type == "all" then
		local confirm = EWS:message_box(Global.frame_panel, "Are you sure?", "AI", "YES_NO,ICON_QUESTION", Vector3(-1, -1, 0))
		if confirm == "NO" then
			return
		end
	end
	local selected = self._graphs:selected_indices()
	if build_type == "all" then
		managers.navigation:clear()
	end
	for _, i in ipairs(selected) do
		local selection = self._graphs:get_string(i)
		local type = self._graph_types[selection]
		if type then
			local settings = self:_get_build_settings(type, build_type)
			if #settings > 0 then
				self._saved_disabled_units = {}
				for name, layer in pairs(managers.editor:layers()) do
					for _, unit in ipairs(layer:created_units()) do
						if unit:unit_data().disable_on_ai_graph then
							unit:set_enabled(false)
							table.insert(self._saved_disabled_units, unit)
						end
					end
				end
				managers.editor:output("Make graph " .. type .. "_" .. self._graphs:get_string(i))
				managers.navigation:build_nav_segments(settings, callback(self, self, "_graphs_done", params.vis_graph))
			end
		else
			Application:error("Invalid selection \"" .. tostring(selection) .. "\".")
		end
	end
end

function AiLayer:_graphs_done(vis_graph)
	managers.editor:output("Navigation seqments calculated")
	for _, unit in ipairs(self._saved_disabled_units) do
		unit:set_enabled(true)
	end
	if vis_graph then
		self:_build_visibility_graph()
	end
end

function AiLayer:_build_visibility_graph()
	local all_visible = self._all_visible:get_value() and true
	local exclude, include
	if not all_visible then
		exclude = {}
		include = {}
		for _, unit in ipairs(self._created_units) do
			if unit:name() == self._nav_surface_unit then
				exclude[unit:unit_data().unit_id] = unit:ai_editor_data().visibilty_exlude_filter
				include[unit:unit_data().unit_id] = unit:ai_editor_data().visibilty_include_filter
			end
		end
	end
	local ray_lenght = self._ray_length_params.value
	managers.navigation:build_visibility_graph(callback(self, self, "_visibility_graph_done"), all_visible, exclude, include, ray_lenght)
end

function AiLayer:_visibility_graph_done()
	managers.editor:output("Visibility graph calculated")
end

function AiLayer:_get_build_settings(type, build_type)
	local settings = {}
	local units = self:_get_units(type, build_type)
	for _, unit in ipairs(units) do
		local ray = managers.editor:unit_by_raycast({
			mask = managers.slot:get_mask("all"),
			from = unit:position() + Vector3(0, 0, 50),
			to = unit:position() - Vector3(0, 0, 150),
			sample = true
		})
		if ray and ray.position then
			table.insert(settings, {
				position = unit:position(),
				id = unit:unit_data().unit_id,
				color = Color(),
				location_id = unit:ai_editor_data().location_id
			})
		end
	end
	return settings
end

function AiLayer:_get_units(type, build_type)
	local unit_name = self._unit_graph_types[type]
	local units = {}
	for _, unit in ipairs(build_type == "selected" and self._selected_units or self._created_units) do
		if unit:name() == unit_name then
			table.insert(units, unit)
		end
	end
	return units
end

function AiLayer:_toggle_debug_draw(debug)
	local show = debug:get_value()
	if not show then
		managers.navigation:set_debug_draw_state(false)
		return
	end
	self:_set_debug_options()
end

function AiLayer:_set_debug_options()
	if not self._debug_draw:get_value() then
		return
	end
	local options = {quads = true}
	for name, ctrl in pairs(self._debug_buttons) do
		options[name] = ctrl:get_value()
	end
	managers.navigation:set_debug_draw_state(options)
end

function AiLayer:_set_location()
	self._selected_unit:ai_editor_data().location_id = self._ai_unit_settings_guis.locations.value
	self._ai_unit_settings_guis.text:set_value(managers.localization:text(self._selected_unit:ai_editor_data().location_id))
	managers.navigation:set_location_ID(self._selected_unit:unit_data().unit_id, self._ai_unit_settings_guis.locations.value)
end

function AiLayer:_set_group_state()
	self._ai_settings.group_state = self._ai_settings_guis.group_state.value
	managers.groupai:set_state(self._ai_settings.group_state)
end

function AiLayer:_update_settings()
	for name, value in pairs(self._ai_settings) do
		if self._ai_settings_guis[name] then
			CoreEws.change_combobox_value(self._ai_settings_guis[name], value)
		end
	end
end

function AiLayer:_clear_graphs()
	managers.navigation:clear()
end

function AiLayer:_clear_selected_nav_segment()
	print("[AiLayer:_clear_selected_nav_segment]")
	local selected = self._graphs:selected_indices()
	local units = self:_get_units("surface", "selected")
	for _, unit in ipairs(units) do
		print("deleting", unit:unit_data().unit_id)
		managers.navigation:delete_nav_segment(unit:unit_data().unit_id)
	end
end

function AiLayer:set_select_unit(unit)
	self._ai_unit_settings_guis.locations.ctrlr:set_enabled(false)
	if alive(unit) then
		if unit:name() == self._patrol_point_unit then
			local name, _ = managers.ai_data:patrol_path_by_unit(unit)
			self:_set_selection_patrol_paths_listbox(name)
		elseif unit:name() == self._nav_surface_unit then
			self._ai_unit_settings_guis.locations.ctrlr:set_enabled(true)
			CoreEws.change_combobox_value(self._ai_unit_settings_guis.locations, unit:ai_editor_data().location_id)
			self._ai_unit_settings_guis.text:set_value(managers.localization:text(unit:ai_editor_data().location_id))
			CoreEws.change_entered_number(self._ai_unit_settings_guis.suspicion_multiplier, unit:ai_editor_data().suspicion_mul)
			CoreEws.change_entered_number(self._ai_unit_settings_guis.detection_multiplier, unit:ai_editor_data().detection_mul)
		end
	end
	if not self:_add_to_visible_exlude_filter(unit) then
		AiLayer.super.set_select_unit(self, unit)
		if not alive(unit) or unit:name() == self._nav_surface_unit then
			managers.navigation:set_selected_segment(unit)
		end
	end
end

function AiLayer:_add_to_visible_exlude_filter(unit)
	if not alive(unit) then
		return false
	end
	if unit:name() ~= self._nav_surface_unit then
		return false
	end
	if self._selected_unit and self._editor_data.virtual_controller:down(Idstring("visible_exlude_filter")) and unit ~= self._selected_unit then
		if self._selected_unit:ai_editor_data().visibilty_exlude_filter[unit:unit_data().unit_id] then
			self._selected_unit:ai_editor_data().visibilty_exlude_filter[unit:unit_data().unit_id] = nil
			unit:ai_editor_data().visibilty_exlude_filter[self._selected_unit:unit_data().unit_id] = nil
		else
			self._selected_unit:ai_editor_data().visibilty_include_filter[unit:unit_data().unit_id] = nil
			unit:ai_editor_data().visibilty_include_filter[self._selected_unit:unit_data().unit_id] = nil
			self._selected_unit:ai_editor_data().visibilty_exlude_filter[unit:unit_data().unit_id] = true
			unit:ai_editor_data().visibilty_exlude_filter[self._selected_unit:unit_data().unit_id] = true
		end
		return true
	end
	if self._selected_unit and self._editor_data.virtual_controller:down(Idstring("visible_include_filter")) and unit ~= self._selected_unit then
		if self._selected_unit:ai_editor_data().visibilty_include_filter[unit:unit_data().unit_id] then
			self._selected_unit:ai_editor_data().visibilty_include_filter[unit:unit_data().unit_id] = nil
			unit:ai_editor_data().visibilty_include_filter[self._selected_unit:unit_data().unit_id] = nil
		else
			self._selected_unit:ai_editor_data().visibilty_exlude_filter[unit:unit_data().unit_id] = nil
			unit:ai_editor_data().visibilty_exlude_filter[self._selected_unit:unit_data().unit_id] = nil
			self._selected_unit:ai_editor_data().visibilty_include_filter[unit:unit_data().unit_id] = true
			unit:ai_editor_data().visibilty_include_filter[self._selected_unit:unit_data().unit_id] = true
		end
		return true
	end
	return false
end

function AiLayer:_set_selection_patrol_paths_listbox(name)
	for i = 0, self._patrol_paths_list:nr_items() - 1 do
		if self._patrol_paths_list:get_string(i) == name then
			self._patrol_paths_list:select_index(i)
		end
	end
	self:_select_patrol_path()
end

function AiLayer:_create_new_patrol_path()
	local name = EWS:get_text_from_user(Global.frame_panel, "Enter name for the new patrol path:", "Create patrol path", "new_patrol_path", Vector3(-1, -1, 0), true)
	if name and name ~= "" then
		if not managers.ai_data:add_patrol_path(name) then
			self:_create_new_patrol_path()
		else
			self:_update_patrol_paths_list()
			for i = 0, self._patrol_paths_list:nr_items() - 1 do
				if self._patrol_paths_list:get_string(i) == name then
					self._patrol_paths_list:select_index(i)
				end
			end
			self:_select_patrol_path()
		end
	end
end

function AiLayer:_current_patrol_units(name)
	local t = {}
	local path = managers.ai_data:patrol_path(name)
	for _, point in ipairs(path.points) do
		table.insert(t, point.unit)
	end
	return t
end

function AiLayer:_delete_patrol_path()
	local name = self:_selected_patrol_path()
	if name then
		local confirm = EWS:message_box(Global.frame_panel, "Delete patrol path " .. name .. "?", "AI", "YES_NO,ICON_QUESTION", Vector3(-1, -1, 0))
		if confirm == "NO" then
			return
		end
		local to_delete = self:_current_patrol_units(name)
		for _, unit in ipairs(to_delete) do
			self:delete_unit(unit)
		end
		managers.ai_data:remove_patrol_path(name)
		self:_update_patrol_paths_list()
		self._current_patrol_path = nil
	end
end

function AiLayer:_update_patrol_paths_list()
	self._patrol_paths_list:clear()
	for name, _ in pairs(managers.ai_data:all_patrol_paths()) do
		self._patrol_paths_list:append(name)
	end
end

function AiLayer:_selected_patrol_path()
	local index = self._patrol_paths_list:selected_index()
	if index ~= -1 then
		return self._patrol_paths_list:get_string(index)
	end
	return nil
end

function AiLayer:_select_patrol_path()
	local name = self:_selected_patrol_path()
	if name and self._current_patrol_path ~= name then
		self._current_patrol_path = name
		self:clear_selected_units()
	elseif not name then
		self._current_patrol_path = nil
	end
end

function AiLayer:do_spawn_unit(name, pos, rot)
	if Idstring(name) == self._patrol_point_unit and not self._current_patrol_path then
		managers.editor:output("Create or select a patrol path first!")
		return
	end
	local unit = AiLayer.super.do_spawn_unit(self, name, pos, rot)
	if alive(unit) and unit:name() == self._patrol_point_unit then
		self:_add_patrol_point(unit, pos)
	end
	return unit
end

function AiLayer:_add_patrol_point(unit)
	local name = self:_selected_patrol_path()
	if not name then
		return
	end
	managers.ai_data:add_patrol_point(name, unit)
end

function AiLayer:_insert()
	if not alive(self._selected_unit) or self._selected_unit:name() ~= self._patrol_point_unit then
		return
	end
	local _, path = managers.ai_data:patrol_path_by_unit(self._selected_unit)
	local i, _ = managers.ai_data:patrol_point_index_by_unit(self._selected_unit)
	self:do_spawn_unit(self._patrol_point_unit:s(), self._mid_pos)
	local point = table.remove(path.points)
	table.insert(path.points, i + 1, point)
end

function AiLayer:delete_unit(unit)
	for _, u in ipairs(self._created_units) do
		if u:name() == self._nav_surface_unit and u ~= unit then
			u:ai_editor_data().visibilty_exlude_filter[unit:unit_data().unit_id] = nil
			u:ai_editor_data().visibilty_include_filter[unit:unit_data().unit_id] = nil
		end
	end
	if unit:name() == self._nav_surface_unit then
		managers.navigation:delete_nav_segment(unit:unit_data().unit_id)
		self._ai_unit_settings_guis.locations.ctrlr:set_enabled(false)
	elseif unit:name() == self._patrol_point_unit then
		managers.ai_data:delete_point_by_unit(unit)
	end
	AiLayer.super.delete_unit(self, unit)
end

function AiLayer:update_unit_settings()
	AiLayer.super.update_unit_settings(self)
end

function AiLayer:_init_ai_settings()
	self._ai_settings = {}
	self._ai_settings.group_state = "besiege"
	managers.groupai:set_state(self._ai_settings.group_state)
end

function AiLayer:clear()
	AiLayer.super.clear(self)
	self:_init_ai_settings()
	self:_update_settings()
	managers.ai_data:clear()
	self:_update_patrol_paths_list()
	self:_update_motion_paths_list()
	self:_select_patrol_path()
	managers.navigation:clear()
	managers.motion_path:delete_paths()
	self._ai_unit_settings_guis.locations.ctrlr:set_enabled(false)
end

function AiLayer:add_triggers()
	AiLayer.super.add_triggers(self)
	local vc = self._editor_data.virtual_controller
	vc:add_trigger(Idstring("enter"), callback(self, self, "_insert"))
end

function AiLayer:_set_suspicion_mul()
	self._selected_unit:ai_editor_data().suspicion_mul = self._ai_unit_settings_guis.suspicion_multiplier.value
	managers.navigation:set_suspicion_multiplier(self._selected_unit:unit_data().unit_id, self._ai_unit_settings_guis.suspicion_multiplier.value)
end

function AiLayer:_set_detection_mul()
	self._selected_unit:ai_editor_data().detection_mul = self._ai_unit_settings_guis.detection_multiplier.value
	managers.navigation:set_detection_multiplier(self._selected_unit:unit_data().unit_id, self._ai_unit_settings_guis.detection_multiplier.value)
end

