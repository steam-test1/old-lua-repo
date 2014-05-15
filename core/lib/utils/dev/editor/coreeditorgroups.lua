core:import("CoreEditorUtils")
CoreEditorGroups = CoreEditorGroups or class()
function CoreEditorGroups:init()
	self._groups = {}
	self._group_names = {}
end

function CoreEditorGroups:groups()
	return self._groups
end

function CoreEditorGroups:group_names()
	return self._group_names
end

function CoreEditorGroups:update(t, dt)
	local (for generator), (for state), (for control) = pairs(self._groups)
	do
		do break end
		group:draw(t, dt)
	end

end

function CoreEditorGroups:create(name, reference, units)
	if not table.contains(self._group_names, name) then
		table.insert(self._group_names, name)
	end

	local group = CoreEditorGroup:new(name, reference, units)
	self._groups[name] = group
	return group
end

function CoreEditorGroups:add(name, units)
	local group = self._groups[name]
	group:add(units)
end

function CoreEditorGroups:remove(name)
	table.delete(self._group_names, name)
	self._groups[name]:remove()
	self._groups[name] = nil
end

function CoreEditorGroups:clear()
end

function CoreEditorGroups:group_name()
	local name = EWS:get_text_from_user(Global.frame_panel, "Enter name for the new group:", "Create Group", self:new_group_name(), Vector3(-1, -1, 0), true)
	if name and name ~= "" then
		if self._groups[name] then
			self:group_name()
		else
			return name
		end

	end

	return nil
end

function CoreEditorGroups:new_group_name()
	local s = "Group0"
	local i = 1
	while self._groups[s .. i] do
		i = i + 1
		if i > 9 then
			s = "Group"
		end

	end

	return s .. i
end

function CoreEditorGroups:save()
	local (for generator), (for state), (for control) = ipairs(self._group_names)
	do
		do break end
		local group = self._groups[name]
		if group then
			local units = {}
			do
				local (for generator), (for state), (for control) = ipairs(group:units())
				do
					do break end
					table.insert(units, unit:unit_data().unit_id)
				end

			end

			(for control) = group:units() and table
			local t = {
				entry = "editor_groups",
				continent = group:continent() and group:continent_name(),
				data = {
					name = group:name(),
					reference = group:reference():unit_data().unit_id,
					continent = group:continent() and group:continent_name(),
					units = units
				}
			}
			managers.editor:add_save_data(t)
		end

	end

end

function CoreEditorGroups:load(world_holder, offset)
	local load_data = world_holder:create_world("world", "editor_groups", offset)
	local group_names = load_data.group_names
	local groups = {}
	do
		local (for generator), (for state), (for control) = pairs(load_data.groups)
		do
			do break end
			if #data.units > 0 then
				local reference = managers.worlddefinition:get_unit(data.reference)
				local units = {}
				do
					local (for generator), (for state), (for control) = ipairs(data.units)
					do
						do break end
						table.insert(units, managers.worlddefinition:get_unit(unit))
					end

				end

				local continent
				(for control) = nil and table
				if data.continent then
					continent = managers.editor:continent(data.continent)
				end

				if not table.contains(units, reference) then
					reference = units[1]
					cat_error("editor", "Changed reference for group,", name, ".")
				end

				groups[name] = {}
				groups[name].reference = reference
				groups[name].units = units
				groups[name].continent = continent
			else
				table.delete(group_names, name)
				cat_error("editor", "Removed old group", name, "since it didnt contain any units.")
			end

		end

	end

	(for control) = nil and data.units
	local (for generator), (for state), (for control) = ipairs(group_names)
	do
		do break end
		if not groups[name].reference then
			managers.editor:output_error("Reference unit is nil since there are no units left in group. Will remove, " .. name .. ".")
		else
			local group = self:create(name, groups[name].reference, groups[name].units)
			group:set_continent(groups[name].continent)
		end

	end

end

function CoreEditorGroups:load_group()
	local path = managers.database:open_file_dialog(Global.frame, "XML-file (*.xml)|*.xml")
	if path then
		self:load_group_file(path)
	end

end

function CoreEditorGroups:load_group_file(path)
	local name = self:group_name()
	local node = SystemFS:parse_xml(path)
	local layer_name = "Statics"
	if node:has_parameter("layer") then
		layer_name = node:parameter("layer")
	end

	local layer = managers.editor:layer(layer_name)
	local pos = managers.editor:current_layer():current_pos()
	managers.editor:change_layer_notebook(layer_name)
	local reference
	local units = {}
	if pos then
		do
			local (for generator), (for state), (for control) = node:children()
			do
				do break end
				local rot, new_unit
				if unit:name() == "ref_unit" then
					reference = layer:do_spawn_unit(unit:parameter("name"), pos)
					new_unit = reference
				else
					local pos = pos + math.string_to_vector(unit:parameter("local_pos"))
					local rot = math.string_to_rotation(unit:parameter("local_rot"))
					new_unit = layer:do_spawn_unit(unit:parameter("name"), pos, rot)
				end

				do
					local (for generator), (for state), (for control) = unit:children()
					do
						do break end
						if setting:name() == "light" then
							self:parse_light(new_unit, setting)
						elseif setting:name() == "variation" then
							self:parse_variation(new_unit, setting)
						elseif setting:name() == "material_variation" then
							self:parse_material_variation(new_unit, setting)
						elseif setting:name() == "editable_gui" then
							self:parse_editable_gui(new_unit, setting)
						end

					end

				end

				(for control) = layer and setting.name
				table.insert(units, new_unit)
			end

		end

		(for control) = nil and nil
		self:create(name, reference, units)
		layer:select_group(self._groups[name])
	end

end

function CoreEditorGroups:parse_light(unit, node)
	local light = unit:get_object(Idstring(node:parameter("name")))
	if not light then
		return
	end

	light:set_enable(toboolean(node:parameter("enabled")))
	light:set_far_range(tonumber(node:parameter("far_range")))
	light:set_color(math.string_to_vector(node:parameter("color")))
	light:set_spot_angle_start(tonumber(node:parameter("angle_start")))
	light:set_spot_angle_end(tonumber(node:parameter("angle_end")))
	light:set_multiplier(LightIntensityDB:lookup(Idstring(node:parameter("multiplier"))))
	if node:has_parameter("falloff_exponent") then
		light:set_falloff_exponent(tonumber(node:parameter("falloff_exponent")))
	end

end

function CoreEditorGroups:parse_variation(unit, node)
	local variation = node:parameter("value")
	if variation ~= "default" then
		unit:unit_data().mesh_variation = variation
		managers.sequence:run_sequence_simple2(unit:unit_data().mesh_variation, "change_state", unit)
	end

end

function CoreEditorGroups:parse_material_variation(unit, node)
	local material_variation = node:parameter("value")
	if material_variation ~= "default" then
		unit:unit_data().material = material_variation
		unit:set_material_config(unit:unit_data().material, true)
	end

end

function CoreEditorGroups:parse_editable_gui(unit, node)
	unit:editable_gui():set_text(node:parameter("text"))
	unit:editable_gui():set_font_color(math.string_to_vector(node:parameter("font_color")))
	unit:editable_gui():set_font_size(tonumber(node:parameter("font_size")))
end

CoreEditorGroup = CoreEditorGroup or class()
function CoreEditorGroup:init(name, reference, units)
