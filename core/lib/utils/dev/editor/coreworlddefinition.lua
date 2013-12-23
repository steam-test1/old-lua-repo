-- Decompiled using luadec 2.0.1 by sztupy (http://winmo.sztupy.hu)
-- Command line was: F:\SteamLibrary\SteamApps\common\PAYDAY 2\lua\core\lib\utils\dev\editor\coreworlddefinition.luac 

core:module("CoreWorldDefinition")
core:import("CoreUnit")
core:import("CoreMath")
core:import("CoreEditorUtils")
core:import("CoreEngineAccess")
if not WorldDefinition then
  WorldDefinition = class()
end
WorldDefinition.init = function(l_1_0, l_1_1)
  managers.worlddefinition = l_1_0
  l_1_0._world_dir = l_1_1.world_dir
  l_1_0._cube_lights_path = l_1_1.cube_lights_path
  l_1_0:_load_world_package()
  managers.sequence:preload()
  l_1_0._definition = l_1_0:_serialize_to_script(l_1_1.file_type, l_1_1.file_path)
  l_1_0._continent_definitions = {}
  l_1_0._continents = {}
  l_1_0._portal_slot_mask = World:make_slot_mask(1)
  l_1_0._massunit_replace_names = {}
  l_1_0._replace_names = {}
  l_1_0._replace_units_path = "assets/lib/utils/dev/editor/xml/replace_units"
  l_1_0:_parse_replace_unit()
  l_1_0._ignore_spawn_list = {}
  l_1_0._excluded_continents = {}
  l_1_0:_parse_world_setting(l_1_1.world_setting)
  l_1_0:parse_continents()
  l_1_0._all_units = {}
  l_1_0._trigger_units = {}
  l_1_0._use_unit_callbacks = {}
  l_1_0._mission_element_units = {}
  l_1_0._termination_counter = 0
end

WorldDefinition._serialize_to_script = function(l_2_0, l_2_1, l_2_2)
  if Application:editor() then
    return PackageManager:editor_load_script_data(l_2_1:id(), l_2_2:id())
  else
    if not PackageManager:has(l_2_1:id(), l_2_2:id()) then
      Application:throw_exception("Script data file " .. l_2_2 .. " of type " .. l_2_1 .. " has not been loaded. Could be that old world format is being loaded. Try resaving the level.")
    end
    return PackageManager:script_data(l_2_1:id(), l_2_2:id())
  end
end

WorldDefinition.get_max_id = function(l_3_0)
  return l_3_0._definition.world_data.max_id
end

WorldDefinition._parse_replace_unit = function(l_4_0)
  local is_editor = Application:editor()
  if DB:has("xml", l_4_0._replace_units_path) then
    local node = DB:load_node("xml", l_4_0._replace_units_path)
    for unit in node:children() do
      local old_name = unit:name()
      local replace_with = unit:parameter("replace_with")
      l_4_0._replace_names[old_name] = replace_with
      if is_editor then
        managers.editor:output_info("Unit " .. old_name .. " will be replaced with " .. replace_with)
      end
    end
  end
end

WorldDefinition.world_dir = function(l_5_0)
  return l_5_0._world_dir
end

WorldDefinition.continent_excluded = function(l_6_0, l_6_1)
  return l_6_0._excluded_continents[l_6_1]
end

WorldDefinition._load_world_package = function(l_7_0)
  if Application:editor() then
    return 
  end
  local package = l_7_0._world_dir .. "world"
  if not DB:has("package", package) then
    Application:throw_exception("No world.package file found in " .. l_7_0._world_dir .. ", please resave level")
    return 
  end
  if not PackageManager:loaded(package) then
    PackageManager:load(package)
    l_7_0._current_world_package = package
  end
  local package = l_7_0._world_dir .. "world_init"
  if not DB:has("package", package) then
    Application:throw_exception("No world_init.package file found in " .. l_7_0._world_dir .. ", please resave level")
    return 
  end
  if not PackageManager:loaded(package) then
    PackageManager:load(package)
    l_7_0._current_world_init_package = package
  end
  l_7_0:_load_sound_package()
end

WorldDefinition._load_sound_package = function(l_8_0)
  local package = l_8_0._world_dir .. "world_sounds"
  if not DB:has("package", package) then
    Application:error("No world_sounds.package file found in " .. l_8_0._world_dir .. ", emitters and ambiences won't work (resave level)")
    return 
  end
  if not PackageManager:loaded(package) then
    PackageManager:load(package)
    l_8_0._current_sound_package = package
  end
end

WorldDefinition._load_continent_init_package = function(l_9_0, l_9_1)
  if Application:editor() then
    return 
  end
  if not DB:has("package", l_9_1) then
    Application:error("Missing init package for a continent(" .. l_9_1 .. "), resave level " .. l_9_0._world_dir .. ".")
    return 
  end
  if not l_9_0._continent_init_packages then
    l_9_0._continent_init_packages = {}
  end
  if not PackageManager:loaded(l_9_1) then
    PackageManager:load(l_9_1)
    table.insert(l_9_0._continent_init_packages, l_9_1)
  end
end

WorldDefinition._load_continent_package = function(l_10_0, l_10_1)
  if Application:editor() then
    return 
  end
  if not DB:has("package", l_10_1) then
    Application:error("Missing package for a continent(" .. l_10_1 .. "), resave level " .. l_10_0._world_dir .. ".")
    return 
  end
  if not l_10_0._continent_packages then
    l_10_0._continent_packages = {}
  end
  if not PackageManager:loaded(l_10_1) then
    PackageManager:load(l_10_1)
    table.insert(l_10_0._continent_packages, l_10_1)
    managers.sequence:preload()
  end
end

WorldDefinition.unload_packages = function(l_11_0)
  l_11_0:_unload_package(l_11_0._current_world_package)
  l_11_0:_unload_package(l_11_0._current_sound_package)
  for _,package in ipairs(l_11_0._continent_packages) do
    l_11_0:_unload_package(package)
  end
end

WorldDefinition._unload_package = function(l_12_0, l_12_1)
  if not l_12_1 then
    return 
  end
  if PackageManager:loaded(l_12_1) then
    PackageManager:unload(l_12_1)
  end
end

WorldDefinition._parse_world_setting = function(l_13_0, l_13_1)
  if not l_13_1 then
    return 
  end
  local path = l_13_0:world_dir() .. l_13_1
  if not DB:has("world_setting", path) then
    Application:error("There is no world_setting file " .. l_13_1 .. " at path " .. path)
    return 
  end
  local t = l_13_0:_serialize_to_script("world_setting", path)
  if t._meta then
    Application:throw_exception("Loading old world setting file (" .. path .. "), resave it!")
  end
  for name,bool in pairs(t) do
    l_13_0._excluded_continents[name] = bool
  end
end

WorldDefinition.parse_continents = function(l_14_0, l_14_1, l_14_2)
  do
    local path = l_14_0:world_dir() .. l_14_0._definition.world_data.continents_file
    if not DB:has("continents", path) then
      Application:error("Continent file didn't exist " .. path .. ").")
      return 
    end
    l_14_0._continents = l_14_0:_serialize_to_script("continents", path)
    l_14_0._continents._meta = nil
    for name,data in pairs(l_14_0._continents) do
      if not l_14_0:_continent_editor_only(data) and not l_14_0._excluded_continents[name] then
        local init_path = l_14_0:world_dir() .. name .. "/" .. name .. "_init"
        l_14_0:_load_continent_init_package(init_path)
        do
          local path = l_14_0:world_dir() .. name .. "/" .. name
          l_14_0:_load_continent_package(path)
          if DB:has("continent", path) then
            l_14_0._continent_definitions[name] = l_14_0:_serialize_to_script("continent", path)
            if Application:editor() then
              local path = l_14_0:world_dir() .. name .. "/mission"
              do
                if DB:has("continent", path) then
                  local mission_data = l_14_0:_serialize_to_script("continent", path)
                  for mission_data_name,mission_data_block in pairs(mission_data) do
                    l_14_0._continent_definitions[name][mission_data_name] = mission_data_block
                  end
                end
                for (for control),name in (for generator) do
                end
                Application:error("Continent file " .. path .. ".continent doesnt exist.")
              end
              for (for control),name in (for generator) do
                l_14_0._excluded_continents[name] = true
              end
            end
          end
        end
      end
       -- Warning: missing end command somewhere! Added here
    end
     -- Warning: missing end command somewhere! Added here
  end
end

WorldDefinition._continent_editor_only = function(l_15_0, l_15_1)
  return (not Application:editor() and l_15_1.editor_only)
end

WorldDefinition.init_done = function(l_16_0)
  if l_16_0._continent_init_packages then
    for _,package in ipairs(l_16_0._continent_init_packages) do
      l_16_0:_unload_package(package)
    end
  end
  l_16_0:_unload_package(l_16_0._current_world_init_package)
  l_16_0._continent_definitions = nil
  l_16_0._definition = nil
end

WorldDefinition.create = function(l_17_0, l_17_1, l_17_2)
  Application:check_termination()
  if not l_17_2 then
    l_17_2 = Vector3()
  end
  local return_data = {}
  if (l_17_1 == "level_settings" or l_17_1 == "all") and l_17_0._definition.level_settings then
    l_17_0:_load_level_settings(l_17_0._definition.level_settings.settings, l_17_2)
    return_data = l_17_0._definition.level_settings.settings
  end
  if l_17_1 == "markers" then
    return_data = l_17_0._definition.world_data.markers
  end
  if l_17_1 == "values" then
    local t = {}
    for name,continent in pairs(l_17_0._continent_definitions) do
      t[name] = continent.values
    end
    return_data = t
  end
  if l_17_1 == "editor_groups" then
    return_data = l_17_0:_create_editor_groups()
  end
  if l_17_1 == "continents" then
    return_data = l_17_0._continents
  end
  if l_17_1 == "ai" and l_17_0._definition.ai then
    for _,values in ipairs(l_17_0._definition.ai) do
      local unit = l_17_0:_create_ai_editor_unit(values, l_17_2)
      if unit then
        table.insert(return_data, unit)
      end
    end
  end
  if (l_17_1 == "ai" or l_17_1 == "all") and l_17_0._definition.ai_nav_graphs then
    l_17_0:_load_ai_nav_graphs(l_17_0._definition.ai_nav_graphs, l_17_2)
    Application:cleanup_thread_garbage()
  end
  Application:check_termination()
  if (l_17_1 == "ai_settings" or l_17_1 == "all") and l_17_0._definition.ai_settings then
    return_data = l_17_0:_load_ai_settings(l_17_0._definition.ai_settings, l_17_2)
  end
  Application:check_termination()
  if (l_17_1 == "portal" or l_17_1 == "all") and l_17_0._definition.portal then
    l_17_0:_create_portal(l_17_0._definition.portal, l_17_2)
    return_data = l_17_0._definition.portal
  end
  Application:check_termination()
  if l_17_1 == "sounds" or l_17_1 == "all" then
    return_data = l_17_0:_create_sounds(l_17_0._definition.sounds)
  end
  Application:check_termination()
  if l_17_1 == "mission_scripts" then
    if not return_data.scripts then
      return_data.scripts = {}
    end
    if l_17_0._definition.mission_scripts then
      for _,values in ipairs(l_17_0._definition.mission_scripts) do
        for name,script in pairs(values) do
          return_data.scripts[name] = script
        end
      end
    end
    for name,continent in pairs(l_17_0._continent_definitions) do
      if continent.mission_scripts then
        for _,values in ipairs(continent.mission_scripts) do
          for name,script in pairs(values) do
            return_data.scripts[name] = script
          end
        end
      end
    end
  end
  if l_17_1 == "mission" then
    if l_17_0._definition.mission then
      for _,values in ipairs(l_17_0._definition.mission) do
        table.insert(return_data, l_17_0:_create_mission_unit(values, l_17_2))
      end
    end
    for name,continent in pairs(l_17_0._continent_definitions) do
      if continent.mission then
        for _,values in ipairs(continent.mission) do
          table.insert(return_data, l_17_0:_create_mission_unit(values, l_17_2))
        end
      end
    end
  end
  if (l_17_1 == "brush" or l_17_1 == "all") and l_17_0._definition.brush then
    l_17_0:_create_massunit(l_17_0._definition.brush, l_17_2)
  end
  Application:check_termination()
  if l_17_1 == "environment" or l_17_1 == "all" then
    local environment = l_17_0._definition.environment
    l_17_0:_create_environment(environment, l_17_2)
    return_data = environment
  end
  if l_17_1 == "world_camera" or l_17_1 == "all" then
    l_17_0:_create_world_cameras(l_17_0._definition.world_camera)
  end
  if (l_17_1 == "wires" or l_17_1 == "all") and l_17_0._definition.wires then
    for _,values in ipairs(l_17_0._definition.wires) do
      table.insert(return_data, l_17_0:_create_wires_unit(values, l_17_2))
    end
  end
  if l_17_1 == "statics" or l_17_1 == "all" then
    if l_17_0._definition.statics then
      for _,values in ipairs(l_17_0._definition.statics) do
        local unit = l_17_0:_create_statics_unit(values, l_17_2)
        if unit then
          table.insert(return_data, unit)
        end
      end
    end
    for name,continent in pairs(l_17_0._continent_definitions) do
      if continent.statics then
        for _,values in ipairs(continent.statics) do
          local unit = l_17_0:_create_statics_unit(values, l_17_2)
          if unit then
            table.insert(return_data, unit)
          end
        end
      end
    end
  end
  if l_17_1 == "dynamics" or l_17_1 == "all" then
    if l_17_0._definition.dynamics then
      for _,values in ipairs(l_17_0._definition.dynamics) do
        table.insert(return_data, l_17_0:_create_dynamics_unit(values, l_17_2))
      end
    end
    for name,continent in pairs(l_17_0._continent_definitions) do
      if continent.dynamics then
        for _,values in ipairs(continent.dynamics) do
          table.insert(return_data, l_17_0:_create_dynamics_unit(values, l_17_2))
        end
      end
    end
  end
  return return_data
end

WorldDefinition._load_level_settings = function(l_18_0, l_18_1, l_18_2)
end

WorldDefinition._load_ai_nav_graphs = function(l_19_0, l_19_1, l_19_2)
  local path = l_19_0:world_dir() .. l_19_1.file
  if not DB:has("nav_data", path) then
    Application:error("The specified nav data file '" .. path .. ".nav_data' was not found for this level! ", path, "Navigation graph will not be loaded!")
    return 
  end
  local values = l_19_0:_serialize_to_script("nav_data", path)
  Application:check_termination()
  managers.navigation:set_load_data(values)
  values = nil
end

WorldDefinition._load_ai_settings = function(l_20_0, l_20_1, l_20_2)
  managers.groupai:set_state(l_20_1.ai_settings.group_state)
  managers.ai_data:load_data(l_20_1.ai_data)
  return l_20_1.ai_settings
end

WorldDefinition._create_portal = function(l_21_0, l_21_1, l_21_2)
  if not Application:editor() then
    for _,portal in ipairs(l_21_1.portals) do
      local t = {}
      for _,point in ipairs(portal.points) do
        table.insert(t, point.position + l_21_2)
      end
      local top = portal.top
      local bottom = portal.bottom
      if top == 0 and bottom == 0 then
        bottom, top = nil
      end
      managers.portal:add_portal(t, bottom, top)
    end
  end
  l_21_1.unit_groups._meta = nil
  for name,data in pairs(l_21_1.unit_groups) do
    local group = managers.portal:add_unit_group(name)
    local shapes = data.shapes or data
    for _,shape in ipairs(shapes) do
      group:add_shape(shape)
    end
    group:set_ids(data.ids)
  end
end

WorldDefinition._create_editor_groups = function(l_22_0)
  local groups = {}
  local group_names = {}
  if l_22_0._definition.editor_groups then
    for _,values in ipairs(l_22_0._definition.editor_groups) do
      if not groups[values.name] then
        groups[values.name] = values
        table.insert(group_names, values.name)
      end
    end
  end
  for name,continent in pairs(l_22_0._continent_definitions) do
    if continent.editor_groups then
      for _,values in ipairs(continent.editor_groups) do
        if not groups[values.name] then
          groups[values.name] = values
          table.insert(group_names, values.name)
        end
      end
    end
  end
  return {groups = groups, group_names = group_names}
end

WorldDefinition._create_sounds = function(l_23_0, l_23_1)
  local path = l_23_0:world_dir() .. l_23_1.file
  if not DB:has("world_sounds", path) then
    Application:error("The specified sound file '" .. path .. ".world_sounds' was not found for this level! ", path, "No sound will be loaded!")
    return 
  end
  local values = l_23_0:_serialize_to_script("world_sounds", path)
  managers.sound_environment:set_default_environment(values.default_environment)
  managers.sound_environment:set_default_ambience(values.default_ambience)
  managers.sound_environment:set_ambience_enabled(values.ambience_enabled)
  managers.sound_environment:set_default_occasional(values.default_occasional)
  for _,sound_environment in ipairs(values.sound_environments) do
    managers.sound_environment:add_area(sound_environment)
  end
  for _,sound_emitter in ipairs(values.sound_emitters) do
    managers.sound_environment:add_emitter(sound_emitter)
  end
  for _,sound_area_emitter in ipairs(values.sound_area_emitters) do
    managers.sound_environment:add_area_emitter(sound_area_emitter)
  end
end

WorldDefinition._create_massunit = function(l_24_0, l_24_1, l_24_2)
  do
    local path = l_24_0:world_dir() .. l_24_1.file
    if Application:editor() then
      CoreEngineAccess._editor_load(Idstring("massunit"), path:id())
      local l = MassUnitManager:list(path:id())
      for _,name in ipairs(l) do
        if DB:has(Idstring("unit"), name:id()) then
          CoreEngineAccess._editor_load(Idstring("unit"), name:id())
          for (for control),_ in (for generator) do
          end
          if not table.has(l_24_0._massunit_replace_names, name:s()) then
            managers.editor:output("Unit " .. name:s() .. " does not exist")
            local old_name = name:s()
            name = managers.editor:show_replace_massunit()
            if name and DB:has(Idstring("unit"), name:id()) then
              CoreEngineAccess._editor_load(Idstring("unit"), name:id())
            end
            l_24_0._massunit_replace_names[old_name] = name or ""
            managers.editor:output("Unit " .. old_name .. " changed to " .. tostring(name))
          end
        end
      end
      MassUnitManager:delete_all_units()
      MassUnitManager:load(path:id(), l_24_2, l_24_0._massunit_replace_names)
    end
     -- Warning: missing end command somewhere! Added here
  end
end

WorldDefinition.sky_rotation_modifier = function(l_25_0, l_25_1)
  return l_25_0._environment.sky_rot
end

WorldDefinition._set_environment = function(l_26_0, l_26_1)
  do
    if Global.game_settings.level_id then
      local env_params = _G.tweak_data.levels[Global.game_settings.level_id].env_params
  end
  if not env_params or not env_params.environment then
    end
  end
  if l_26_1 ~= "none" then
    managers.viewport:preload_environment(l_26_1)
    managers.environment_area:set_default_environment(l_26_1)
  end
end

WorldDefinition._set_default_color_grading = function(l_27_0, l_27_1)
  do
    if Global.game_settings.level_id then
      local env_params = _G.tweak_data.levels[Global.game_settings.level_id].env_params
  end
  if not env_params or not env_params.color_grading then
    end
  end
  managers.environment_controller:set_default_color_grading(l_27_1)
  managers.environment_controller:refresh_render_settings()
end

WorldDefinition._create_environment = function(l_28_0, l_28_1, l_28_2)
  l_28_0:_set_environment(l_28_1.environment_values.environment)
  l_28_0:_set_default_color_grading(l_28_1.environment_values.color_grading)
  if not Application:editor() and not l_28_0._environment_modifier_id then
    l_28_0._environment_modifier_id = managers.viewport:viewports()[1]:create_environment_modifier(false, function(l_1_0)
    return self:sky_rotation_modifier(l_1_0)
   end, "sky_orientation")
  end
  l_28_0._environment = {sky_rot = l_28_1.environment_values.sky_rot}
  local wind = l_28_1.wind
  Wind:set_direction(wind.angle, wind.angle_var, 5)
  Wind:set_tilt(wind.tile, wind.tilt_var, 5)
  Wind:set_speed_m_s(wind.speed or 6, wind.speed_variation or 1, 5)
  Wind:set_enabled(true)
  if not Application:editor() then
    for _,unit_effect in ipairs(l_28_1.effects) do
      local name = Idstring(unit_effect.name)
      if DB:has("effect", name) then
        managers.portal:add_effect({effect = name, position = unit_effect.position, rotation = unit_effect.rotation})
      end
    end
  end
  for _,environment_area in ipairs(l_28_1.environment_areas) do
    managers.environment_area:add_area(environment_area)
  end
  if Application:editor() then
    local units = {}
    for _,gizmo in ipairs(l_28_1.cubemap_gizmos) do
      local unit = l_28_0:make_unit(gizmo, l_28_2)
      table.insert(units, unit)
    end
    l_28_1.units = units
  end
  if l_28_1.dome_occ_shapes then
    local shape_data = l_28_1.dome_occ_shapes[1]
    if shape_data then
      local corner = shape_data.position
      local size = Vector3(shape_data.depth, shape_data.width, shape_data.height)
      local texture_name = l_28_0:world_dir() .. "cube_lights/" .. "dome_occlusion"
      if not DB:has(Idstring("texture"), Idstring(texture_name)) then
        Application:error("Dome occlusion texture doesn't exists, probably needs to be generated", texture_name)
      else
        managers.environment_controller:set_dome_occ_params(corner, size, texture_name)
      end
    end
  end
end

WorldDefinition._create_world_cameras = function(l_29_0, l_29_1)
  local path = l_29_0:world_dir() .. l_29_1.file
  if not DB:has("world_cameras", path) then
    Application:error("No world_camera file found! (" .. path .. ")")
    return 
  end
  local values = l_29_0:_serialize_to_script("world_cameras", path)
  managers.worldcamera:load(values)
end

WorldDefinition._create_mission_unit = function(l_30_0, l_30_1, l_30_2)
  l_30_0:preload_unit(l_30_1.unit_data.name)
  local unit = l_30_0:make_unit(l_30_1.unit_data, l_30_2)
  if unit then
    unit:mission_element_data().script = l_30_1.script
    l_30_0:add_mission_element_unit(unit)
    for name,value in pairs(l_30_1.script_data) do
      unit:mission_element_data()[name] = value
    end
    unit:mission_element():post_init()
  end
  return unit
end

WorldDefinition._create_wires_unit = function(l_31_0, l_31_1, l_31_2)
  l_31_0:preload_unit(l_31_1.unit_data.name)
  local unit = l_31_0:make_unit(l_31_1.unit_data, l_31_2)
  if unit then
    unit:wire_data().slack = l_31_1.wire_data.slack
    local target = unit:get_object(Idstring("a_target"))
    target:set_position(l_31_1.wire_data.target_pos)
    target:set_rotation(l_31_1.wire_data.target_rot)
    CoreMath.wire_set_midpoint(unit, unit:orientation_object():name(), Idstring("a_target"), Idstring("a_bender"))
    unit:set_moving()
  end
  return unit
end

WorldDefinition._create_statics_unit = function(l_32_0, l_32_1, l_32_2)
  l_32_0:preload_unit(l_32_1.unit_data.name)
  return l_32_0:make_unit(l_32_1.unit_data, l_32_2)
end

WorldDefinition._create_dynamics_unit = function(l_33_0, l_33_1, l_33_2)
  l_33_0:preload_unit(l_33_1.unit_data.name)
  return l_33_0:make_unit(l_33_1.unit_data, l_33_2)
end

WorldDefinition._create_ai_editor_unit = function(l_34_0, l_34_1, l_34_2)
  local unit = l_34_0:_create_statics_unit(l_34_1, l_34_2)
  if l_34_1.ai_editor_data then
    for name,value in pairs(l_34_1.ai_editor_data) do
      unit:ai_editor_data()[name] = value
    end
  end
  return unit
end

WorldDefinition.preload_unit = function(l_35_0, l_35_1)
  local is_editor = Application:editor()
  if table.has(l_35_0._replace_names, l_35_1) then
    l_35_1 = l_35_0._replace_names[l_35_1]
  elseif is_editor and (not DB:has(Idstring("unit"), l_35_1:id()) or CoreEngineAccess._editor_unit_data(l_35_1:id()):type():id() == Idstring("deleteme")) then
    if not DB:has(Idstring("unit"), l_35_1:id()) then
      managers.editor:output_info("Unit " .. l_35_1 .. " does not exist")
    else
      managers.editor:output_info("Unit " .. l_35_1 .. " is of type " .. CoreEngineAccess._editor_unit_data(l_35_1:id()):type():t())
    end
    local old_name = l_35_1
    l_35_1 = managers.editor:show_replace_unit()
    l_35_0._replace_names[old_name] = l_35_1
    managers.editor:output_info("Unit " .. old_name .. " changed to " .. tostring(l_35_1))
  end
  if is_editor and l_35_1 then
    CoreEngineAccess._editor_load(Idstring("unit"), l_35_1:id())
  end
end

local is_editor = Application:editor()
WorldDefinition.make_unit = function(l_36_0, l_36_1, l_36_2)
  local name = l_36_1.name
  if l_36_0._ignore_spawn_list[Idstring(name):key()] then
    return nil
  end
  if table.has(l_36_0._replace_names, name) then
    name = l_36_0._replace_names[name]
  end
  if not name then
    return nil
  end
  if not is_editor and not Network:is_server() then
    local network_sync = PackageManager:unit_data(name:id()):network_sync()
    if network_sync ~= "none" and network_sync ~= "client" then
      return 
    end
  end
  local unit = nil
  if MassUnitManager:can_spawn_unit(Idstring(name)) and not is_editor then
    unit = MassUnitManager:spawn_unit(Idstring(name), l_36_1.position + l_36_2, l_36_1.rotation)
  else
    unit = CoreUnit.safe_spawn_unit(name, l_36_1.position, l_36_1.rotation)
  end
  if unit then
    l_36_0:assign_unit_data(unit, l_36_1)
  elseif is_editor then
    local s = "Failed creating unit " .. tostring(name)
    Application:throw_exception(s)
  end
  if l_36_0._termination_counter == 0 then
    Application:check_termination()
  end
  l_36_0._termination_counter = (l_36_0._termination_counter + 1) % 100
  return unit
end

local is_editor = Application:editor()
WorldDefinition.assign_unit_data = function(l_37_0, l_37_1, l_37_2)
  if not l_37_1:unit_data() then
    Application:error("The unit " .. l_37_1:name():s() .. " (" .. l_37_1:author() .. ") does not have the required extension unit_data (ScriptUnitData)")
  end
  if l_37_1:unit_data().only_exists_in_editor and not is_editor then
    l_37_0._ignore_spawn_list[l_37_1:name():key()] = true
    l_37_1:set_slot(0)
    return 
  end
  l_37_0:_setup_unit_id(l_37_1, l_37_2)
  l_37_0:_setup_editor_unit_data(l_37_1, l_37_2)
  if l_37_1:unit_data().helper_type and l_37_1:unit_data().helper_type ~= "none" then
    managers.helper_unit:add_unit(l_37_1, l_37_1:unit_data().helper_type)
  end
  if l_37_2.continent and is_editor then
    managers.editor:add_unit_to_continent(l_37_2.continent, l_37_1)
  end
  l_37_0:_setup_lights(l_37_1, l_37_2)
  l_37_0:_setup_variations(l_37_1, l_37_2)
  l_37_0:_setup_editable_gui(l_37_1, l_37_2)
  l_37_0:add_trigger_sequence(l_37_1, l_37_2.triggers)
  l_37_0:_set_only_visible_in_editor(l_37_1, l_37_2)
  l_37_0:_setup_cutscene_actor(l_37_1, l_37_2)
  l_37_0:_setup_disable_shadow(l_37_1, l_37_2)
  l_37_0:_setup_hide_on_projection_light(l_37_1, l_37_2)
  l_37_0:_setup_disable_on_ai_graph(l_37_1, l_37_2)
  l_37_0:_add_to_portal(l_37_1, l_37_2)
  l_37_0:_setup_projection_light(l_37_1, l_37_2)
  l_37_0:_project_assign_unit_data(l_37_1, l_37_2)
end

WorldDefinition._setup_unit_id = function(l_38_0, l_38_1, l_38_2)
  l_38_1:unit_data().unit_id = l_38_2.unit_id
  l_38_1:set_editor_id(l_38_1:unit_data().unit_id)
  l_38_0._all_units[l_38_1:unit_data().unit_id] = l_38_1
  l_38_0:use_me(l_38_1, Application:editor())
end

WorldDefinition._setup_editor_unit_data = function(l_39_0, l_39_1, l_39_2)
  if not Application:editor() then
    return 
  end
  l_39_1:unit_data().name_id = l_39_2.name_id
  l_39_1:unit_data().world_pos = l_39_1:position()
  l_39_1:unit_data().projection_lights = l_39_2.projection_lights
end

WorldDefinition._setup_lights = function(l_40_0, l_40_1, l_40_2)
  if not l_40_2.lights then
    return 
  end
  for _,l in ipairs(l_40_2.lights) do
    local light = l_40_1:get_object(l.name:id())
    if light then
      light:set_enable(l.enabled)
      light:set_far_range(l.far_range)
      if not l.near_range then
        light:set_near_range(light:near_range())
      end
      light:set_color(l.color)
      light:set_spot_angle_start(l.spot_angle_start)
      light:set_spot_angle_end(l.spot_angle_end)
      if l.multiplier_nr then
        light:set_multiplier(l.multiplier_nr)
      end
      if l.specular_multiplier_nr then
        light:set_specular_multiplier(l.specular_multiplier_nr)
      end
      if l.multiplier then
        l.multiplier = l.multiplier:id()
        light:set_multiplier(LightIntensityDB:lookup(l.multiplier))
        light:set_specular_multiplier(LightIntensityDB:lookup_specular_multiplier(l.multiplier))
      end
      light:set_falloff_exponent(l.falloff_exponent)
      if l.clipping_values then
        light:set_clipping_values(l.clipping_values)
      end
    end
  end
end

WorldDefinition.setup_lights = function(l_41_0, ...)
  l_41_0:_setup_lights(...)
   -- DECOMPILER ERROR: Confused about usage of registers for local variables.

end

WorldDefinition._setup_variations = function(l_42_0, l_42_1, l_42_2)
  if l_42_2.mesh_variation and l_42_2.mesh_variation ~= "default" then
    l_42_1:unit_data().mesh_variation = l_42_2.mesh_variation
    managers.sequence:run_sequence_simple2(managers.sequence, l_42_1:unit_data().mesh_variation, "change_state", l_42_1)
  end
  if l_42_2.material_variation and l_42_2.material_variation ~= "default" then
    l_42_1:unit_data().material = l_42_2.material_variation
    l_42_1:set_material_config(Idstring(l_42_1:unit_data().material), true)
  end
end

WorldDefinition._setup_editable_gui = function(l_43_0, l_43_1, l_43_2)
  if not l_43_2.editable_gui then
    return 
  end
  if not l_43_1:editable_gui() then
    Application:error("Unit has editable gui data saved but no editable gui extesnion. No text will be loaded. (probably cause the unit should no longer have editable text)")
    return 
  end
  l_43_1:editable_gui():set_text(l_43_2.editable_gui.text)
  l_43_1:editable_gui():set_font_color(l_43_2.editable_gui.font_color)
  l_43_1:editable_gui():set_font_size(l_43_2.editable_gui.font_size)
  if not Application:editor() then
    l_43_1:editable_gui():lock_gui()
  end
end

WorldDefinition.external_set_only_visible_in_editor = function(l_44_0, l_44_1)
  l_44_0:_set_only_visible_in_editor(l_44_1, nil)
end

WorldDefinition._set_only_visible_in_editor = function(l_45_0, l_45_1, l_45_2)
  if Application:editor() then
    return 
  end
  if l_45_1:unit_data().only_visible_in_editor then
    l_45_1:set_visible(false)
  end
end

WorldDefinition._setup_cutscene_actor = function(l_46_0, l_46_1, l_46_2)
  if not l_46_2.cutscene_actor then
    return 
  end
  l_46_1:unit_data().cutscene_actor = l_46_2.cutscene_actor
  managers.cutscene:register_cutscene_actor(l_46_1)
end

WorldDefinition._setup_disable_shadow = function(l_47_0, l_47_1, l_47_2)
  if not l_47_2.disable_shadows then
    return 
  end
  if Application:editor() then
    l_47_1:unit_data().disable_shadows = l_47_2.disable_shadows
  end
  l_47_1:set_shadows_disabled(l_47_2.disable_shadows)
end

WorldDefinition._setup_hide_on_projection_light = function(l_48_0, l_48_1, l_48_2)
  if not l_48_2.hide_on_projection_light then
    return 
  end
  if Application:editor() then
    l_48_1:unit_data().hide_on_projection_light = l_48_2.hide_on_projection_light
  end
end

WorldDefinition._setup_disable_on_ai_graph = function(l_49_0, l_49_1, l_49_2)
  if not l_49_2.disable_on_ai_graph then
    return 
  end
  if Application:editor() then
    l_49_1:unit_data().disable_on_ai_graph = l_49_2.disable_on_ai_graph
  end
end

WorldDefinition._add_to_portal = function(l_50_0, l_50_1, l_50_2)
  if Application:editor() or not l_50_0._portal_slot_mask then
    return 
  end
  if l_50_1:in_slot(l_50_0._portal_slot_mask) and not l_50_1:unit_data().only_visible_in_editor then
    managers.portal:add_unit(l_50_1)
  end
end

WorldDefinition._setup_projection_light = function(l_51_0, l_51_1, l_51_2)
  if not l_51_2.projection_light then
    return 
  end
  l_51_1:unit_data().projection_textures = l_51_2.projection_textures
  l_51_1:unit_data().projection_light = l_51_2.projection_light
  local light = (l_51_1:get_object(Idstring(l_51_2.projection_light)))
  local texture_name = nil
  if l_51_1:unit_data().projection_textures then
    texture_name = l_51_1:unit_data().projection_textures[l_51_2.projection_light]
    if not DB:has(Idstring("texture"), Idstring(texture_name)) then
      Application:error("Projection light texture doesn't exists,", texture_name)
      return 
    elseif not l_51_0._cube_lights_path then
      texture_name = l_51_0:world_dir() .. "cube_lights/" .. l_51_1:unit_data().unit_id
      if not DB:has(Idstring("texture"), Idstring(texture_name)) then
        Application:error("Cube light texture doesn't exists, probably needs to be generated", texture_name)
        return 
      end
    end
     -- DECOMPILER ERROR: Confused while interpreting a jump as a 'while'

  end
  local omni = true
  if Application:editor() then
    light:set_projection_texture(texture_name, omni)
  elseif not l_51_0._requested_light_textures then
    l_51_0._requested_light_textures = {}
  end
  l_51_0._requested_light_textures[texture_name] = Idstring(texture_name)
  TextureCache:request(texture_name, omni and "CUBEMAP" or "NORMAL", callback(l_51_0, l_51_0, "_light_loaded_cbk", {light = light, omni = omni, texture_name = texture_name}))
end

WorldDefinition._light_loaded_cbk = function(l_52_0, l_52_1, l_52_2)
  l_52_1.light:set_projection_texture(l_52_1.texture_name, l_52_1.omni)
  if l_52_0._requested_light_textures[l_52_1.texture_name] then
    TextureCache:unretrieve(l_52_0._requested_light_textures[l_52_1.texture_name])
    l_52_0._requested_light_textures[l_52_1.texture_name] = nil
  end
end

WorldDefinition.flush_remaining_lights_textures = function(l_53_0)
  if l_53_0._requested_light_textures then
    for name,texture_name in pairs(l_53_0._requested_light_textures) do
      TextureCache:unretrieve(texture_name)
    end
  end
end

WorldDefinition.setup_projection_light = function(l_54_0, ...)
  l_54_0:_setup_projection_light(...)
   -- DECOMPILER ERROR: Confused about usage of registers for local variables.

end

WorldDefinition._project_assign_unit_data = function(l_55_0, ...)
   -- DECOMPILER ERROR: Confused about usage of registers for local variables.

end

WorldDefinition.add_trigger_sequence = function(l_56_0, l_56_1, l_56_2)
  do
    local is_editor = Application:editor()
    if not l_56_2 then
      return 
    end
    for _,trigger in ipairs(l_56_2) do
      do
        if is_editor and Global.running_simulation then
          local notify_unit = managers.editor:unit_with_id(trigger.notify_unit_id)
          l_56_1:damage():add_trigger_sequence(trigger.name, trigger.notify_unit_sequence, notify_unit, trigger.time, nil, nil, is_editor)
        end
        for (for control),_ in (for generator) do
        end
        if l_56_0._all_units[trigger.notify_unit_id] then
          l_56_1:damage():add_trigger_sequence(trigger.name, trigger.notify_unit_sequence, l_56_0._all_units[trigger.notify_unit_id], trigger.time, nil, nil, is_editor)
          for (for control),_ in (for generator) do
          end
          if l_56_0._trigger_units[trigger.notify_unit_id] then
            table.insert(l_56_0._trigger_units[trigger.notify_unit_id], {unit = l_56_1, trigger = trigger})
            for (for control),_ in (for generator) do
            end
            l_56_0._trigger_units[trigger.notify_unit_id] = {{unit = l_56_1, trigger = trigger}}
          end
        end
         -- Warning: missing end command somewhere! Added here
      end
       -- Warning: missing end command somewhere! Added here
    end
     -- Warning: missing end command somewhere! Added here
  end
end

WorldDefinition.use_me = function(l_57_0, l_57_1, l_57_2)
  local id = l_57_1:unit_data().unit_id
  if id == 0 or not id then
    id = l_57_1:editor_id()
  end
  l_57_0._all_units[id] = l_57_0._all_units[id] or l_57_1
  if l_57_0._trigger_units[id] then
    for _,t in ipairs(l_57_0._trigger_units[id]) do
      t.unit:damage():add_trigger_sequence(t.trigger.name, t.trigger.notify_unit_sequence, l_57_1, t.trigger.time, nil, nil, l_57_2)
    end
    l_57_0._trigger_units[id] = nil
  end
  if l_57_0._use_unit_callbacks[id] then
    for _,call in ipairs(l_57_0._use_unit_callbacks[id]) do
      call(l_57_1)
    end
    l_57_0._use_unit_callbacks[id] = nil
  end
end

WorldDefinition.get_unit_on_load = function(l_58_0, l_58_1, l_58_2)
  if l_58_0._all_units[l_58_1] then
    return l_58_0._all_units[l_58_1]
  end
  if l_58_0._use_unit_callbacks[l_58_1] then
    table.insert(l_58_0._use_unit_callbacks[l_58_1], l_58_2)
  else
    l_58_0._use_unit_callbacks[l_58_1] = {l_58_2}
  end
  return nil
end

WorldDefinition.get_unit = function(l_59_0, l_59_1)
  return l_59_0._all_units[l_59_1]
end

WorldDefinition.add_mission_element_unit = function(l_60_0, l_60_1)
  l_60_0._mission_element_units[l_60_1:unit_data().unit_id] = l_60_1
end

WorldDefinition.get_mission_element_unit = function(l_61_0, l_61_1)
  return l_61_0._mission_element_units[l_61_1]
end


