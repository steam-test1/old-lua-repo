require("core/lib/utils/dev/ews/sequencer/CoreCutsceneSequencerPanel")
require("core/lib/utils/dev/tools/cutscene_editor/CoreCutsceneSettingsDialog")
require("core/lib/utils/dev/tools/cutscene_editor/CoreCutsceneFrameExporterDialog")
require("core/lib/utils/dev/tools/cutscene_editor/CoreCutsceneBatchOptimizerDialog")
require("core/lib/utils/dev/tools/cutscene_editor/CoreCutsceneFootage")
require("core/lib/utils/dev/tools/cutscene_editor/CoreCutsceneEditorProject")
require("core/lib/utils/dev/tools/cutscene_editor/CoreCutsceneOptimizer")
require("core/lib/utils/dev/tools/cutscene_editor/CoreCutsceneMayaExporter")
require("core/lib/utils/dev/tools/cutscene_editor/CoreCutsceneFrameExporter")
require("core/lib/managers/cutscene/CoreCutsceneKeys")
require("core/lib/managers/cutscene/CoreCutsceneKeyCollection")
require("core/lib/managers/cutscene/CoreCutsceneCast")
CoreCutsceneEditor = CoreCutsceneEditor or class()
mixin(CoreCutsceneEditor, CoreCutsceneKeyCollection)
CoreCutsceneEditor.EDITOR_TITLE = "Cutscene Editor"
CoreCutsceneEditor.DEFAULT_CAMERA_FAR_RANGE = 50000
function CoreCutsceneEditor:_all_keys_sorted_by_time()
	local cutscene_keys = table.collect(self._sequencer:key_track():clips(), function(sequencer_key)
		return sequencer_key:metadata()
	end
)
	table.sort(cutscene_keys, function(a, b)
		return a:frame() < b:frame()
	end
)
	return cutscene_keys
end

local commands = CoreCommandRegistry:new()
commands:add({
	id = "NEW_PROJECT",
	label = "&New Project",
	key = "Ctrl+N",
	help = "Closes the currently open cutscene project so you can start with a blank slate"
})
commands:add({
	id = "OPEN_PROJECT",
	label = "&Open Project...",
	key = "Ctrl+O",
	help = "Opens an existing cutscene project from the database"
})
commands:add({
	id = "SAVE_PROJECT",
	label = "&Save Project",
	key = "Ctrl+S",
	help = "Saves the current project to the database"
})
commands:add({
	id = "SAVE_PROJECT_AS",
	label = "Save Project &As...",
	help = "Saves the current project to the database under a new name"
})
commands:add({
	id = "SHOW_PROJECT_SETTINGS",
	label = "&Project Settings...",
	help = "Displays the Project Settings dialog"
})
commands:add({
	id = "EXPORT_TO_GAME",
	label = "&Export Cutscene to Game...",
	help = "Exports an optimized version of the cutscene that can be used within the game"
})
commands:add({
	id = "EXPORT_TO_MAYA",
	label = "Export Cutscene to &Maya...",
	help = "Exports edited animations for all actors, cameras and locators as a Maya scene"
})
commands:add({
	id = "EXPORT_PLAYBLAST",
	label = "Export &Playblast...",
	help = "Exports a low-quality render of each frame in the cutscene as an image file for use as a reference"
})
commands:add({
	id = "SHOW_BATCH_OPTIMIZER",
	label = "&Batch Export to Game...",
	help = "Displays the Batch Export dialog"
})
commands:add({
	id = "EXIT",
	label = "E&xit",
	help = "Closes the " .. CoreCutsceneEditor.EDITOR_TITLE .. " window"
})
commands:add({
	id = "CUT",
	label = "Cut",
	key = "Ctrl+X",
	help = "Place selected clips on the clipboard. When pasted, the clips will be moved"
})
commands:add({
	id = "COPY",
	label = "Copy",
	key = "Ctrl+C",
	help = "Place selected clips on the clipboard. When pasted, the clips will be duplicated"
})
commands:add({
	id = "PASTE",
	label = "Paste",
	key = "Ctrl+V",
	help = "Paste clipboard contents into the current film track at the playhead position"
})
commands:add({
	id = "DELETE",
	label = "Delete",
	key = "Del",
	help = "Removes selected clips from the sequencer timeline"
})
commands:add({
	id = "SELECT_ALL",
	label = "Select &All",
	key = "Ctrl+A",
	help = "Select all clips and all keys in the sequencer timeline"
})
commands:add({
	id = "SELECT_ALL_ON_CURRENT_TRACK",
	label = "Select All on Current &Track",
	key = "Ctrl+Shift+A",
	help = "Select all clips on the current film track"
})
commands:add({
	id = "DESELECT",
	label = "&Deselect",
	key = "Ctrl+D",
	help = "Deselect all clips and all keys in the sequencer timeline"
})
commands:add({
	id = "CLEANUP_ZOOM_KEYS",
	label = "Cleanup &Zoom Keys",
	help = "Remove all Camera Zoom keys that have no effect from the script track"
})
commands:add({
	id = "CUTSCENE_CAMERA_TOGGLE",
	label = "Use &Cutscene Camera",
	help = "Check to view the scene though the directed cutscene camera"
})
commands:add({
	id = "WIDESCREEN_TOGGLE",
	label = "&Widescreen Aspect Ratio",
	key = "Ctrl+R",
	help = "Check to use 16:9 letterbox format for the directed cutscene camera"
})
commands:add({
	id = "CAST_FINDER_TOGGLE",
	label = "Cast &Finder",
	help = "Visualize cast member positions using debug lines"
})
commands:add({
	id = "CAMERAS_TOGGLE",
	label = "&Cameras",
	help = "Visualize cameras using debug lines"
})
commands:add({
	id = "FOCUS_PLANE_TOGGLE",
	label = "&Focus Planes",
	key = "Ctrl+F",
	help = "Visualize depth of field effects with focus planes"
})
commands:add({
	id = "HIERARCHIES_TOGGLE",
	label = "&Hierarchies",
	help = "Visualize bone hierarchies using debug lines"
})
commands:add({
	id = "PLAY_EVERY_FRAME_TOGGLE",
	label = "Play &Every Frame",
	help = "Check to advance the playhead by exactly one frame instead of the elapsed time since the last update during playback"
})
commands:add({
	id = "INSERT_CLIPS_FROM_SELECTED_FOOTAGE",
	label = "Clips from &Selected Footage",
	help = "Inserts clips from the selected footage track at the current playhead position"
})
commands:add({
	id = "INSERT_AUDIO_FILE",
	label = "&Audio File...",
	help = "Browse for an audio file to insert into the voice-over track at the current playhead position"
})
commands:add({
	id = "LOOP_TOGGLE",
	label = "&Loop Playback",
	key = "Ctrl+L",
	help = "Toggle playback looping",
	image = "sequencer\\loop_16x16.png"
})
commands:add({
	id = "PLAY_TOGGLE",
	label = "&Play / Pause",
	key = "Ctrl+Space",
	help = "Start or pause playback from the current playhead position",
	image = "sequencer\\play_16x16.png"
})
commands:add({
	id = "PLAY_FROM_START",
	label = "Play from Start",
	key = "Ctrl+Shift+Space",
	help = "Start playback from the start of the selected region or cutscene",
	image = "sequencer\\play_from_start_16x16.png"
})
commands:add({
	id = "PLAY",
	label = "Play",
	key = "Ctrl+Space",
	help = "Start playback from the current playhead position",
	image = "sequencer\\play_16x16.png"
})
commands:add({
	id = "PAUSE",
	label = "Pause",
	key = "Ctrl+Space",
	help = "Pause playback at the current playhead position",
	image = "sequencer\\pause_16x16.png"
})
commands:add({
	id = "STOP",
	label = "&Stop",
	key = "Escape",
	help = "Stop playback and return to the start of the selected region or cutscene",
	image = "sequencer\\stop_16x16.png"
})
commands:add({
	id = "GO_TO_START",
	label = "Go to &Start",
	key = "Ctrl+Up",
	help = "Go to the start of the selection or cutscene",
	image = "sequencer\\go_to_start_16x16.png"
})
commands:add({
	id = "GO_TO_END",
	label = "Go to &End",
	key = "Ctrl+Down",
	help = "Go to the end of the selection or cutscene",
	image = "sequencer\\go_to_end_16x16.png"
})
commands:add({
	id = "GO_TO_NEXT_FRAME",
	label = "Go to &Next Frame",
	key = "Ctrl+Right",
	help = "Go to the previous frame"
})
commands:add({
	id = "GO_TO_PREVIOUS_FRAME",
	label = "Go to &Previous Frame",
	key = "Ctrl+Left",
	help = "Go to the next frame"
})
commands:add({
	id = "ZOOM_IN",
	label = "Zoom &In",
	key = "Ctrl++",
	help = "Increase sequencer track zoom level",
	image = "sequencer\\zoom_in_16x16.png"
})
commands:add({
	id = "ZOOM_OUT",
	label = "Zoom &Out",
	key = "Ctrl+-",
	help = "Decrease sequencer track zoom level",
	image = "sequencer\\zoom_out_16x16.png"
})
local cutscene_key_insertion_commands = {}
local skipped_key_types = {change_camera = true}
do
	local (for generator), (for state), (for control) = ipairs(CoreCutsceneKey:types())
	do
		do break end
		if not skipped_key_types[key_type.ELEMENT_NAME] then
			local key = "INSERT_" .. string.gsub(string.upper(key_type.NAME), " ", "_") .. "_KEY"
			commands:add({
				id = key,
				label = key_type.NAME .. " Key",
				help = "Inserts a " .. string.lower(key_type.NAME) .. " key at the current playhead position"
			})
			cutscene_key_insertion_commands[key] = key_type
		end

	end

end

CoreCutsceneEditor.init, (for control) = function(self)
	self._cast = core_or_local("CutsceneCast")
	self:_create_viewport()
	self:_create_window():set_visible(true)
	self._project_settings_dialog = core_or_local("CutsceneSettingsDialog", self._window)
end
, CoreCutsceneKey:types() and key_type.ELEMENT_NAME
function CoreCutsceneEditor:_create_viewport()
	assert(self._viewport == nil)
	assert(self._camera == nil)
	assert(self._camera_controller == nil)
	self._viewport = managers.viewport:new_vp(0, 0, 1, 1)
	self._camera = World:create_camera()
	self._camera:set_fov(CoreZoomCameraCutsceneKey.DEFAULT_CAMERA_FOV)
	self._camera:set_near_range(7.5)
	self._camera:set_far_range(self.DEFAULT_CAMERA_FAR_RANGE)
	self._camera:set_width_multiplier(1)
	self._viewport:set_camera(self._camera)
	self._camera_controller = self._viewport:director():make_camera(self._camera, "cutscene_camera")
	self._camera_controller:set_timer(TimerManager:game_animation())
	self._viewport:director():set_camera(self._camera_controller)
end

function CoreCutsceneEditor:camera_attributes()
	if self._player then
		return self._player:camera_attributes()
	else
		local attributes = {}
		attributes.aspect_ratio = self._camera:aspect_ratio()
		attributes.fov = self._camera:fov()
		attributes.near_range = self._camera:near_range()
		attributes.far_range = self._camera:far_range()
		return attributes
	end

end

function CoreCutsceneEditor:_create_window()
	self._window = EWS:Frame(CoreCutsceneEditor.EDITOR_TITLE, Vector3(100, 500, 0), Vector3(800, 800, 0), "DEFAULT_FRAME_STYLE,FRAME_FLOAT_ON_PARENT", Global.frame)
	self._window:connect("", "EVT_CLOSE_WINDOW", callback(self, self, "_on_exit"), "")
	self._window:connect("", "EVT_ACTIVATE", callback(self, self, "_on_activate"), "")
	self._window:set_icon(CoreEWS.image_path("film_reel_16x16.png"))
	self._window:set_min_size(Vector3(400, 321, 0))
	local function connect_command(command_id, callback_name, callback_data)
		callback_name = callback_name or "_on_" .. string.lower(command_id)
		callback_data = callback_data or ""
		self._window:connect(commands:id(command_id), "EVT_COMMAND_MENU_SELECTED", callback(self, self, callback_name), callback_data)
	end

	connect_command("NEW_PROJECT")
	connect_command("OPEN_PROJECT")
	connect_command("SAVE_PROJECT")
	connect_command("SAVE_PROJECT_AS")
	connect_command("SHOW_PROJECT_SETTINGS")
	connect_command("EXPORT_TO_GAME")
	connect_command("EXPORT_TO_MAYA")
	connect_command("EXPORT_PLAYBLAST")
	connect_command("SHOW_BATCH_OPTIMIZER")
	connect_command("EXIT")
	connect_command("CUT")
	connect_command("COPY")
	connect_command("PASTE")
	connect_command("DELETE")
	connect_command("SELECT_ALL")
	connect_command("SELECT_ALL_ON_CURRENT_TRACK")
	connect_command("DESELECT")
	connect_command("CLEANUP_ZOOM_KEYS")
	connect_command("CUTSCENE_CAMERA_TOGGLE")
	connect_command("WIDESCREEN_TOGGLE")
	connect_command("PLAY_EVERY_FRAME_TOGGLE")
	connect_command("INSERT_CLIPS_FROM_SELECTED_FOOTAGE")
	connect_command("ZOOM_IN")
	connect_command("ZOOM_OUT")
	connect_command("PLAY")
	connect_command("PLAY_TOGGLE")
	connect_command("PLAY_FROM_START")
	connect_command("PAUSE")
	connect_command("STOP")
	connect_command("GO_TO_START")
	connect_command("GO_TO_END")
	connect_command("GO_TO_PREVIOUS_FRAME")
	connect_command("GO_TO_NEXT_FRAME")
	do
		local (for generator), (for state), (for control) = pairs(cutscene_key_insertion_commands)
		do
			do break end
			connect_command(command, "_on_insert_cutscene_key", key_type.ELEMENT_NAME)
		end

	end

	(for control) = Vector3(400, 321, 0) and connect_command
	local main_box = EWS:BoxSizer("VERTICAL")
	self._window:set_sizer(main_box)
	self._window:set_menu_bar(self:_create_menu_bar())
	self._window:set_tool_bar(self:_create_tool_bar(self._window))
	self._window:set_status_bar(EWS:StatusBar(self._window))
	self._window:set_status_bar_pane(0)
	local tool_bar_divider_line = EWS:StaticLine(self._window)
	main_box:add(tool_bar_divider_line, 0, 0, "EXPAND")
	local main_area_top_bottom_splitter = EWS:SplitterWindow(self._window)
	self._top_area_splitter = EWS:SplitterWindow(main_area_top_bottom_splitter)
	local bottom_area_left_right_splitter = EWS:SplitterWindow(main_area_top_bottom_splitter)
	local bottom_left_area_top_bottom_splitter = EWS:SplitterWindow(bottom_area_left_right_splitter)
	self:_create_sequencer(self._top_area_splitter)
	self:_create_attribute_panel(self._top_area_splitter)
	local selected_footage_track = self:_create_selected_footage_track(bottom_left_area_top_bottom_splitter)
	local camera_list = self:_create_camera_list(bottom_area_left_right_splitter)
	local footage_list = self:_create_footage_list(bottom_left_area_top_bottom_splitter)
	main_area_top_bottom_splitter:set_minimum_pane_size(143)
	main_area_top_bottom_splitter:set_sash_gravity(1)
	self._top_area_splitter:set_minimum_pane_size(160)
	self._top_area_splitter:set_sash_gravity(1)
	bottom_area_left_right_splitter:set_minimum_pane_size(160)
	bottom_area_left_right_splitter:set_sash_gravity(1)
	bottom_left_area_top_bottom_splitter:connect("EVT_COMMAND_SPLITTER_SASH_POS_CHANGING", function(_, event)
		event:veto()
	end
, "")
	main_area_top_bottom_splitter:split_horizontally(self._top_area_splitter, bottom_area_left_right_splitter, 400)
	self._top_area_splitter:split_vertically(self._sequencer_panel, self._attribute_panel, self._window:get_size().x - 190)
	bottom_area_left_right_splitter:split_vertically(bottom_left_area_top_bottom_splitter, camera_list, self._window:get_size().x - 190)
	bottom_left_area_top_bottom_splitter:split_horizontally(selected_footage_track, footage_list, 73)
	main_box:add(main_area_top_bottom_splitter, 1, 0, "EXPAND")
	self:_refresh_attribute_panel()
	return self._window
end

function CoreCutsceneEditor:_create_menu_bar()
	local file_menu = commands:wrap_menu(EWS:Menu(""))
	file_menu:append_command("NEW_PROJECT")
	file_menu:append_command("OPEN_PROJECT")
	file_menu:append_command("SAVE_PROJECT")
	file_menu:append_command("SAVE_PROJECT_AS")
	file_menu:append_separator()
	file_menu:append_command("SHOW_PROJECT_SETTINGS")
	file_menu:append_separator()
	file_menu:append_command("EXPORT_TO_GAME")
	file_menu:append_command("EXPORT_TO_MAYA")
	file_menu:append_command("EXPORT_PLAYBLAST")
	file_menu:append_separator()
	file_menu:append_command("SHOW_BATCH_OPTIMIZER")
	file_menu:append_separator()
	file_menu:append_command("EXIT")
	self._edit_menu = commands:wrap_menu(EWS:Menu(""))
	self._edit_menu:append_command("CUT")
	self._edit_menu:set_enabled("CUT", false)
	self._edit_menu:append_command("COPY")
	self._edit_menu:set_enabled("COPY", false)
	self._edit_menu:append_command("PASTE")
	self._edit_menu:set_enabled("PASTE", false)
	self._edit_menu:append_command("DELETE")
	self._edit_menu:append_separator()
	self._edit_menu:append_command("SELECT_ALL")
	self._edit_menu:append_command("SELECT_ALL_ON_CURRENT_TRACK")
	self._edit_menu:append_command("DESELECT")
	self._edit_menu:append_separator()
	self._edit_menu:append_command("CLEANUP_ZOOM_KEYS")
	self._view_menu = commands:wrap_menu(EWS:Menu(""))
	self._view_menu:append_check_command("CUTSCENE_CAMERA_TOGGLE")
	self._view_menu:append_check_command("WIDESCREEN_TOGGLE")
	self._view_menu:set_checked("WIDESCREEN_TOGGLE", true)
	self._view_menu:append_separator()
	self._view_menu:append_command("ZOOM_IN")
	self._view_menu:append_command("ZOOM_OUT")
	self._view_menu:append_separator()
	self._view_menu:append_check_command("CAST_FINDER_TOGGLE")
	self._view_menu:append_check_command("CAMERAS_TOGGLE")
	self._view_menu:append_check_command("FOCUS_PLANE_TOGGLE")
	self._view_menu:append_check_command("HIERARCHIES_TOGGLE")
	self._transport_menu = commands:wrap_menu(EWS:Menu(""))
	self._transport_menu:append_command("PLAY_TOGGLE")
	self._transport_menu:append_command("PLAY_FROM_START")
	self._transport_menu:append_command("STOP")
	self._transport_menu:append_separator()
	self._transport_menu:append_check_command("LOOP_TOGGLE")
	self._transport_menu:set_enabled("LOOP_TOGGLE", false)
	self._transport_menu:append_check_command("PLAY_EVERY_FRAME_TOGGLE")
	self._transport_menu:append_separator()
	self._transport_menu:append_command("GO_TO_START")
	self._transport_menu:append_command("GO_TO_END")
	self._transport_menu:append_command("GO_TO_NEXT_FRAME")
	self._transport_menu:append_command("GO_TO_PREVIOUS_FRAME")
	self._insert_menu = commands:wrap_menu(EWS:Menu(""))
	self._insert_menu:append_command("INSERT_CLIPS_FROM_SELECTED_FOOTAGE")
	self._insert_menu:set_enabled("INSERT_CLIPS_FROM_SELECTED_FOOTAGE", false)
	self._insert_menu:append_command("INSERT_AUDIO_FILE")
	self._insert_menu:set_enabled("INSERT_AUDIO_FILE", false)
	self._insert_menu:append_separator()
	do
		local (for generator), (for state), (for control) = table.sorted_map_iterator(table.remap(cutscene_key_insertion_commands, function(command, key_type)
			return key_type.NAME, command
		end
))
		do
			do break end
			self._insert_menu:append_command(command)
		end

	end

	(for control) = table.remap(cutscene_key_insertion_commands, function(command, key_type)
		return key_type.NAME, command
	end
) and self._insert_menu
	local menu_bar = EWS:MenuBar()
	menu_bar:append(file_menu:wrapped_object(), "&File")
	menu_bar:append(self._edit_menu:wrapped_object(), "&Edit")
	menu_bar:append(self._view_menu:wrapped_object(), "&View")
	menu_bar:append(self._transport_menu:wrapped_object(), "&Transport")
	menu_bar:append(self._insert_menu:wrapped_object(), "&Insert")
	return menu_bar
end

function CoreCutsceneEditor:_create_tool_bar(parent_frame)
	local tool_bar = commands:wrap_tool_bar(EWS:ToolBar(parent_frame, "", "TB_HORIZONTAL,TB_FLAT,TB_NOALIGN"))
	local function add_labelled_field(label, field_text)
		local label = EWS:StaticText(tool_bar:wrapped_object(), label)
		label:set_font_size(6)
		label:set_size(label:get_size():with_y(30):with_x(label:get_size().x + 3))
		tool_bar:add_control(label)
		local field = EWS:StaticText(tool_bar:wrapped_object(), field_text)
		field:set_font_size(12)
		tool_bar:add_control(field)
		return field
	end

	tool_bar:add_separator()
	tool_bar:add_command("PLAY_FROM_START")
	tool_bar:add_command("PLAY")
	tool_bar:add_command("PAUSE")
	tool_bar:add_command("STOP")
	tool_bar:add_separator()
	tool_bar:add_command("GO_TO_START")
	tool_bar:add_command("GO_TO_END")
	tool_bar:add_separator()
	tool_bar:add_command("ZOOM_IN")
	tool_bar:add_command("ZOOM_OUT")
	tool_bar:add_separator()
	self._frame_label = add_labelled_field("FRAME", self:_frame_string_for_frame(0))
	tool_bar:add_separator()
	self._time_code_label = add_labelled_field("TIME", self:_time_code_string_for_frame(0))
	tool_bar:add_separator()
	tool_bar:realize()
	return tool_bar:wrapped_object()
end

function CoreCutsceneEditor:_frame_string_for_frame(frame)
	return string.format("%05i", frame)
end

function CoreCutsceneEditor:_time_code_string_for_frame(frame)
	local function consume_frames(frames_per_unit)
		local whole_units = math.floor(frame / frames_per_unit)
		frame = frame - whole_units * frames_per_unit
		return whole_units
	end

	local hour = consume_frames(3600 * self:frames_per_second())
	local minute = consume_frames(60 * self:frames_per_second())
	local second = consume_frames(self:frames_per_second())
	return string.format("%02i:%02i:%02i:%02i", hour, minute, second, frame)
end

function CoreCutsceneEditor:_create_sequencer(parent_frame)
	self._sequencer_panel = EWS:Panel(parent_frame)
	local panel_sizer = EWS:BoxSizer("VERTICAL")
	self._sequencer_panel:set_background_colour(EWS:get_system_colour("3DSHADOW") * 255:unpack())
	self._sequencer_panel:set_sizer(panel_sizer)
	self._sequencer = CoreCutsceneSequencerPanel:new(self._sequencer_panel)
	self._sequencer:connect("EVT_TRACK_MOUSEWHEEL", callback(self, self, "_on_sequencer_track_mousewheel"), self._sequencer)
	self._sequencer:connect("EVT_SELECTION_CHANGED", callback(self, self, "_on_sequencer_selection_changed"), self._sequencer)
	self._sequencer:connect("EVT_REMOVE_ITEM", callback(self, self, "_on_sequencer_remove_item"), self._sequencer)
	self._sequencer:connect("EVT_DRAG_ITEM", callback(self, self, "_on_sequencer_drag_item"), self._sequencer)
	self._sequencer:connect("EVT_EVALUATE_FRAME_AT_PLAYHEAD", callback(self, self, "_on_sequencer_evaluate_frame_at_playhead"), self._sequencer)
	panel_sizer:add(self._sequencer:panel(), 1, 1, "LEFT,RIGHT,BOTTOM,EXPAND")
end

function CoreCutsceneEditor:_create_attribute_panel(parent_frame)
	self._attribute_panel = EWS:Panel(parent_frame)
	local panel_sizer = EWS:BoxSizer("VERTICAL")
	self._attribute_panel:set_background_colour(EWS:get_system_colour("3DSHADOW") * 255:unpack())
	self._attribute_panel:set_sizer(panel_sizer)
	self._attribute_panel_area = EWS:ScrolledWindow(self._attribute_panel, "", "")
	self._attribute_panel_area:set_background_colour(EWS:get_system_colour("3DFACE") * 255:unpack())
	self:_refresh_attribute_panel()
	panel_sizer:add(self._attribute_panel_area, 1, 1, "LEFT,BOTTOM,EXPAND")
end

function CoreCutsceneEditor:_refresh_attribute_panel()
	self._attribute_panel_area:freeze()
	self._attribute_panel_area:destroy_children()
	local new_sizer = self:_sizer_with_editable_attributes_for_current_context(self._attribute_panel_area)
	if new_sizer then
		if not self._top_area_splitter:is_split() then
			self._top_area_splitter:split_vertically(self._sequencer_panel, self._attribute_panel, self._window:get_size().x - 190)
		end

		self._attribute_panel_area:set_sizer(new_sizer)
		self._attribute_panel_area:fit_inside()
		self._attribute_panel_area:set_scrollbars(Vector3(8, 8, 1), Vector3(1, 1, 1), Vector3(0, 0, 0), false)
	elseif self._top_area_splitter:is_split() then
		self._top_area_splitter:unsplit(self._attribute_panel)
	end

	self._attribute_panel_area:thaw()
end

function CoreCutsceneEditor:_refresh_selected_footage_track()
	local selected_footage = self:_selected_footage()
	self:_display_footage_in_selected_footage_track(selected_footage)
	local selected_clips = self._sequencer:selected_film_clips()
	local clip = #selected_clips == 1 and selected_clips[1] or nil
	if clip and clip.start_time_in_source and clip.end_time_in_source and clip:end_time_in_source() > clip:start_time_in_source() then
		self._selected_footage_track_region:set_range(clip:start_time_in_source(), clip:end_time_in_source())
		self._selected_footage_track_region:set_visible(true)
	else
		self._selected_footage_track_region:set_visible(false)
	end

	local camera_index = clip and clip:metadata().camera_index and clip:metadata():camera_index() or nil
	if camera_index then
		self._camera_list_ctrl:set_item_selected(camera_index - 1, true)
	else
		local (for generator), (for state), (for control) = ipairs(self._camera_list_ctrl:selected_items())
		do
			do break end
			self._camera_list_ctrl:set_item_selected(item, false)
		end

	end

end

function CoreCutsceneEditor:_selected_footage()
	local selected_clips = self._sequencer:selected_film_clips()
	if not table.empty(selected_clips) then
		local selected_clip_footages = table.list_union(table.collect(selected_clips, function(clip)
			return clip:metadata() and clip:metadata().footage and clip:metadata():footage() or nil
		end
))
		return #selected_clip_footages == 1 and selected_clip_footages[1] or nil
	else
		local selected_item_index = self._footage_list_ctrl:selected_item()
		return selected_item_index >= 0 and self._footage_list_ctrl:get_item_data(selected_item_index)
	end

end

function CoreCutsceneEditor:_display_footage_in_selected_footage_track(footage)
	if footage ~= self._selected_footage_track_displayed_footage then
		self._selected_footage_track:remove_all_clips()
		self._camera_list_ctrl:delete_all_items()
		if footage and footage.add_clips_to_track and footage.add_cameras_to_list_ctrl then
			footage:add_clips_to_track(self._selected_footage_track)
			footage:add_cameras_to_list_ctrl(self._camera_list_ctrl)
		end

		self._selected_footage_track_displayed_footage = footage
	end

end

function CoreCutsceneEditor:_sizer_with_editable_attributes_for_current_context(parent_frame)
	local selected_keys = self._sequencer:selected_keys()
	if #selected_keys ~= 1 or not selected_keys[1] then
	end

	local displayed_item = responder(nil):metadata()
	if displayed_item and displayed_item.populate_sizer_with_editable_attributes then
		local sizer = EWS:BoxSizer("VERTICAL")
		local headline = EWS:StaticText(parent_frame, displayed_item:type_name())
		headline:set_font_size(10)
		sizer:add(headline, 0, 5, "ALL,EXPAND")
		local line = EWS:StaticLine(parent_frame)
		sizer:add(line, 0, 0, "EXPAND")
		displayed_item:populate_sizer_with_editable_attributes(sizer, parent_frame)
		return sizer
	end

end

function CoreCutsceneEditor:_create_selected_footage_track(parent_frame)
	local panel = EWS:Panel(parent_frame)
	local panel_sizer = EWS:BoxSizer("VERTICAL")
	panel:set_background_colour(EWS:get_system_colour("3DSHADOW") * 255:unpack())
	panel:set_sizer(panel_sizer)
	self._selected_footage_track_scrolled_area = EWS:ScrolledWindow(panel, "", "HSCROLL,NO_BORDER,ALWAYS_SHOW_SB")
	local scrolled_area_sizer = EWS:BoxSizer("VERTICAL")
	self._selected_footage_track = EWS:SequencerTrack(self._selected_footage_track_scrolled_area)
	self._selected_footage_track_region = self._selected_footage_track:add_ornament(EWS:SequencerRangeOrnament())
	self._selected_footage_track_region:set_visible(false)
	self._selected_footage_track_region:set_colour(EWS:get_system_colour("HIGHLIGHT"):unpack())
	self._selected_footage_track_region:set_fill_style("FDIAGONAL_HATCH")
	panel_sizer:add(self._selected_footage_track_scrolled_area, 1, 1, "ALL,EXPAND")
	self._selected_footage_track_scrolled_area:set_sizer(scrolled_area_sizer)
	self._selected_footage_track_scrolled_area:set_scrollbars(Vector3(1, 1, 1), Vector3(1, 1, 1), Vector3(0, 0, 0), false)
	self._selected_footage_track:set_units(100, 500)
	self._selected_footage_track:set_background_colour(self._sequencer:_track_background_colour(false):unpack())
	self._selected_footage_track:set_icon_bitmap(CoreEWS.image_path("sequencer\\track_icon_selected.bmp"), 11)
	self._selected_footage_track:connect("EVT_LEFT_UP", callback(self, self, "_on_selected_footage_track_mouse_left_up"), self._selected_footage_track)
	self._selected_footage_track:connect("EVT_MOUSEWHEEL", callback(self, self, "_on_track_mousewheel"), self._selected_footage_track)
	scrolled_area_sizer:add(self._selected_footage_track, 0, 0, "EXPAND")
	return panel
end

function CoreCutsceneEditor:_create_footage_list(parent_frame)
	self._footage_list_ctrl = EWS:ListCtrl(parent_frame, "", "LC_LIST")
	local image_list = EWS:ImageList(16, 16)
	self._reel_icon = image_list:add(CoreEWS.image_path("film_reel_16x16.png"))
	self._optimized_reel_icon = image_list:add(CoreEWS.image_path("film_reel_bw_16x16.png"))
	self._footage_list_ctrl:set_image_list(image_list)
	self:_refresh_footage_list()
	self._footage_list_ctrl:connect("EVT_COMMAND_LIST_ITEM_SELECTED", callback(self, self, "_on_footage_selection_changed"), self._footage_list_ctrl)
	self._footage_list_ctrl:connect("EVT_COMMAND_LIST_ITEM_DESELECTED", callback(self, self, "_on_footage_selection_changed"), self._footage_list_ctrl)
	return self._footage_list_ctrl
end

function CoreCutsceneEditor:_refresh_footage_list()
	self._footage_list_ctrl:freeze()
	self._footage_list_ctrl:clear_all()
	local cutscene_names = managers.cutscene:get_cutscene_names()
	local optimized_cutscene_names = table.find_all_values(cutscene_names, function(name)
		return managers.cutscene:get_cutscene(name):is_optimized()
	end
)
	local unoptimized_cutscene_names = table.find_all_values(cutscene_names, function(name)
		return not managers.cutscene:get_cutscene(name):is_optimized()
	end
)
	table.sort(unoptimized_cutscene_names)
	table.sort(optimized_cutscene_names)
	local function add_cutscene_footage(name, icon_id)
		local cutscene = managers.cutscene:get_cutscene(name)
		if cutscene:is_valid() then
			local item = self._footage_list_ctrl:append_item(name)
			self._footage_list_ctrl:set_item_image(item, icon_id)
			self._footage_list_ctrl:set_item_data(item, core_or_local("CutsceneFootage", cutscene))
		end

	end

	do
		local (for generator), (for state), (for control) = ipairs(optimized_cutscene_names)
		do
			do break end
			add_cutscene_footage(name, self._optimized_reel_icon)
		end

	end

	(for control) = nil and add_cutscene_footage
	do
		local (for generator), (for state), (for control) = ipairs(unoptimized_cutscene_names)
		do
			do break end
			add_cutscene_footage(name, self._reel_icon)
		end

	end

	(for control) = nil and add_cutscene_footage
	self._footage_list_ctrl:thaw()
end

function CoreCutsceneEditor:_evaluated_track()
	return self._sequencer:active_film_track()
end

function CoreCutsceneEditor:_evaluate_current_frame()
	local frame = self:playhead_position()
	self._frame_label:set_label(self:_frame_string_for_frame(frame))
	self._time_code_label:set_label(self:_time_code_string_for_frame(frame))
	if self:_evaluated_track() then
		local clip = self:_evaluated_track():clip_at_time(frame)
		self:_evaluate_clip_at_frame(clip, frame)
	end

	self:_evaluate_editor_cutscene_keys_for_frame(frame)
end

function CoreCutsceneEditor:_evaluate_editor_cutscene_keys_for_frame(frame)
