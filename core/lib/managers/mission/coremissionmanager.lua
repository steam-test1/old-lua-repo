core:module("CoreMissionManager")
core:import("CoreMissionScriptElement")
core:import("CoreEvent")
core:import("CoreClass")
core:import("CoreDebug")
core:import("CoreCode")
require("core/lib/managers/mission/CoreElementDebug")
MissionManager = MissionManager or CoreClass.class(CoreEvent.CallbackHandler)
function MissionManager:init()
	MissionManager.super.init(self)
	self._runned_unit_sequences_callbacks = {}
	self._scripts = {}
	self._active_scripts = {}
	self._area_instigator_categories = {}
	self:add_area_instigator_categories("none")
	self:set_default_area_instigator("none")
	self._workspace = Overlay:newgui():create_screen_workspace()
	self._workspace:set_timer(TimerManager:main())
	self._fading_debug_output = self._workspace:panel():gui(Idstring("core/guis/core_fading_debug_output"))
	self._fading_debug_output:set_leftbottom(0, self._workspace:height() / 3)
	self._fading_debug_output:script().configure({font_size = 20, max_rows = 20})
	self._persistent_debug_output = self._workspace:panel():gui(Idstring("core/guis/core_persistent_debug_output"))
	self._persistent_debug_output:set_righttop(self._workspace:width(), 0)
	self:set_persistent_debug_enabled(false)
	self:set_fading_debug_enabled(true)
	self._global_event_listener = rawget(_G, "EventListenerHolder"):new()
	self._global_event_list = {}
end

function MissionManager:parse(params, stage_name, offset, file_type)
	local file_path, activate_mission
	if CoreClass.type_name(params) == "table" then
		file_path = params.file_path
		file_type = params.file_type or "mission"
		activate_mission = params.activate_mission
		offset = params.offset
	else
		file_path = params
		file_type = file_type or "mission"
	end

	CoreDebug.cat_debug("gaspode", "MissionManager", file_path, file_type, activate_mission)
	if not DB:has(file_type, file_path) then
		Application:error("Couldn't find", file_path, "(", file_type, ")")
		return false
	end

	local reverse = string.reverse(file_path)
	local i = string.find(reverse, "/")
	local file_dir = string.reverse(string.sub(reverse, i))
	local continent_files = self:_serialize_to_script(file_type, file_path)
	continent_files._meta = nil
	do
		local (for generator), (for state), (for control) = pairs(continent_files)
		do
			do break end
			if not managers.worlddefinition:continent_excluded(name) then
				self:_load_mission_file(file_dir, data)
			end

		end

	end

	(for control) = string.sub(reverse, i) and managers
	self:_activate_mission(activate_mission)
	return true
end

function MissionManager:_serialize_to_script(type, name)
	if Application:editor() then
		return PackageManager:editor_load_script_data(type:id(), name:id())
	else
		if not PackageManager:has(type:id(), name:id()) then
			Application:throw_exception("Script data file " .. name .. " of type " .. type .. " has not been loaded. Could be that old mission format is being loaded. Try resaving the level.")
		end

		return PackageManager:script_data(type:id(), name:id())
	end

end

function MissionManager:_load_mission_file(file_dir, data)
	local file_path = file_dir .. data.file
	local scripts = self:_serialize_to_script("mission", file_path)
	scripts._meta = nil
	local (for generator), (for state), (for control) = pairs(scripts)
	do
		do break end
		data.name = name
		self:_add_script(data)
	end

end

function MissionManager:_add_script(data)
	self._scripts[data.name] = MissionScript:new(data)
end

function MissionManager:scripts()
	return self._scripts
end

function MissionManager:script(name)
	return self._scripts[name]
end

function MissionManager:_activate_mission(name)
	CoreDebug.cat_debug("gaspode", "MissionManager:_activate_mission", name)
	if name then
		if self:script(name) then
			self:activate_script(name)
		else
			Application:throw_exception("There was no mission named " .. name .. " availible to activate!")
		end

	else
		local (for generator), (for state), (for control) = pairs(self._scripts)
		do
			do break end
			if script:activate_on_parsed() then
				self:activate_script(script:name())
			end

		end

	end

end

function MissionManager:activate_script(name, ...)
	CoreDebug.cat_debug("gaspode", "MissionManager:activate_script", name)
	if not self._scripts[name] then
		if Global.running_simulation then
			managers.editor:output_error("Can't activate mission script " .. name .. ". It doesn't exist.")
			return
		else
			Application:throw_exception("Can't activate mission script " .. name .. ". It doesn't exist.")
		end

	end

	self._scripts[name]:activate(...)
end

function MissionManager:update(t, dt)
	local (for generator), (for state), (for control) = pairs(self._scripts)
	do
		do break end
		script:update(t, dt)
	end

end

function MissionManager:stop_simulation(...)
	self:pre_destroy()
	do
		local (for generator), (for state), (for control) = pairs(self._scripts)
		do
			do break end
			script:stop_simulation(...)
		end

	end

	self._scripts = nil and {}
	self._runned_unit_sequences_callbacks = {}
	self._global_event_listener = rawget(_G, "EventListenerHolder"):new()
end

function MissionManager:add_runned_unit_sequence_trigger(id, sequence, callback)
	if self._runned_unit_sequences_callbacks[id] then
		if self._runned_unit_sequences_callbacks[id][sequence] then
			table.insert(self._runned_unit_sequences_callbacks[id][sequence], callback)
		else
			self._runned_unit_sequences_callbacks[id][sequence] = {callback}
		end

	else
		local t = {}
		t[sequence] = {callback}
		self._runned_unit_sequences_callbacks[id] = t
	end

end

function MissionManager:runned_unit_sequence(unit, sequence, params)
	if alive(unit) and unit:unit_data() then
		local id = unit:unit_data().unit_id
		if id == 0 or not id then
			id = unit:editor_id()
		end

		if self._runned_unit_sequences_callbacks[id] and self._runned_unit_sequences_callbacks[id][sequence] then
			local (for generator), (for state), (for control) = ipairs(self._runned_unit_sequences_callbacks[id][sequence])
			do
				do break end
				call(params and params.unit)
			end

		end

	end

end

function MissionManager:add_area_instigator_categories(category)
	table.insert(self._area_instigator_categories, category)
end

function MissionManager:area_instigator_categories()
	return self._area_instigator_categories
end

function MissionManager:set_default_area_instigator(default)
	self._default_area_instigator = default
end

function MissionManager:default_area_instigator()
	return self._default_area_instigator
end

function MissionManager:default_instigator()
	return nil
end

function MissionManager:persistent_debug_enabled()
	return self._persistent_debug_enabled
end

function MissionManager:set_persistent_debug_enabled(enabled)
	self._persistent_debug_enabled = enabled
	if enabled then
		self._persistent_debug_output:show()
	else
		self._persistent_debug_output:hide()
	end

end

function MissionManager:add_persistent_debug_output(debug, color)
	if not self._persistent_debug_enabled then
		return
	end

	self._persistent_debug_output:script().log(debug, color)
end

function MissionManager:set_fading_debug_enabled(enabled)
	self._fading_debug_enabled = enabled
	if enabled then
		self._fading_debug_output:show()
	else
		self._fading_debug_output:hide()
	end

end

function MissionManager:add_fading_debug_output(debug, color, as_subtitle)
	if not Application:production_build() then
		return
	end

	if not self._fading_debug_enabled then
		return
	end

	if as_subtitle then
		self:_show_debug_subtitle(debug, color)
	else
		local stuff = {
			" -",
			" \\",
			" |",
			" /"
		}
		self._fade_index = (self._fade_index or 0) + 1
		self._fade_index = self._fade_index > #stuff and self._fade_index and 1 or self._fade_index
		self._fading_debug_output:script().log(stuff[self._fade_index] .. " " .. debug, color, nil)
	end

end

function MissionManager:_show_debug_subtitle(debug, color)
	self._debug_subtitle_text = self._debug_subtitle_text or self._workspace:panel():text({
		font = "core/fonts/diesel",
		font_size = 24,
		text = debug,
		word_wrap = true,
		wrap = true,
		align = "center",
		halign = "center",
		valign = "center",
		color = color or Color.white
	})
	self._debug_subtitle_text:set_size(self._workspace:panel():w() / 2, 24)
	self._debug_subtitle_text:set_text(debug)
	local subtitle_time = math.max(4, utf8.len(debug) * 0.04)
	local _, _, w, h = self._debug_subtitle_text:text_rect()
	self._debug_subtitle_text:set_size(w, h)
	self._debug_subtitle_text:set_center_x(self._workspace:panel():w() / 2)
	self._debug_subtitle_text:set_bottom(self._workspace:panel():h() / 1.4)
	self._debug_subtitle_text:set_color(color or Color.white)
	self._debug_subtitle_text:set_alpha(1)
	self._debug_subtitle_text:stop()
	self._debug_subtitle_text:animate(function(o)
		_G.wait(subtitle_time)
		self._debug_subtitle_text:set_alpha(0)
	end
)
end

function MissionManager:get_element_by_id(id)
	local (for generator), (for state), (for control) = pairs(self._scripts)
	do
		do break end
		if script:element(id) then
			return script:element(id)
		end

	end

end

function MissionManager:add_global_event_listener(key, events, clbk)
	self._global_event_listener:add(key, events, clbk)
end

function MissionManager:remove_global_event_listener(key)
	self._global_event_listener:remove(key)
end

function MissionManager:call_global_event(event, ...)
	self._global_event_listener:call(event, ...)
end

function MissionManager:set_global_event_list(list)
	self._global_event_list = list
end

function MissionManager:get_global_event_list()
	return self._global_event_list
end

function MissionManager:save(data)
