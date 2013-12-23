-- Decompiled using luadec 2.0.1 by sztupy (http://winmo.sztupy.hu)
-- Command line was: F:\SteamLibrary\SteamApps\common\PAYDAY 2\lua\core\lib\utils\dev\editor\worldholder.luac 

core:import("CoreWorldDefinition")
core:import("CoreEditorUtils")
core:import("CoreEngineAccess")
core:import("CoreUnit")
if not CoreOldWorldDefinition then
  CoreOldWorldDefinition = class()
end
if not CoreMissionElementUnit then
  CoreMissionElementUnit = class()
end
if not WorldHolder then
  WorldHolder = class()
end
WorldHolder.get_world_file = function(l_1_0)
  Application:error("FIXME: Either unused or broken.")
  return nil
end

WorldHolder.init = function(l_2_0, l_2_1)
  if type_name(l_2_1) ~= "table" then
    Application:throw_exception("WorldHolder:init needs a table as param (was of type " .. type_name(l_2_1) .. "). Check wiki for documentation.")
    return 
  end
  local file_path = l_2_1.file_path
  local file_type = l_2_1.file_type
  l_2_0._worlds = {}
  if file_path then
    l_2_0._worldfile_generation = l_2_0:_worldfile_generation(file_type, file_path)
    if l_2_0._worldfile_generation == "level" then
      Application:throw_exception("Level format no longer supported, use type world with resaved data. (" .. file_path .. ")")
      return 
    end
    local reverse = string.reverse(file_path)
    local i = string.find(reverse, "/")
    l_2_0._world_dir = string.reverse(string.sub(reverse, i))
    assert(DB:has(file_type, file_path), file_path .. "." .. file_type .. " is not in the database!")
    if l_2_0._worldfile_generation == "new" then
      l_2_1.world_dir = l_2_0._world_dir
      l_2_0._definition = CoreWorldDefinition.WorldDefinition:new(l_2_1)
    elseif l_2_0._worldfile_generation == "old" then
      l_2_0:_error("World " .. file_path .. "." .. file_type .. " is old format! Will soon result in crash, please resave.")
      local t = {world_dir = l_2_0._world_dir, world_setting = l_2_1.world_setting}
      if not rawget(_G, "WorldDefinition") then
        local WorldDefinitionClass = rawget(_G, "CoreOldWorldDefinition")
      end
      local path = managers.database:entry_expanded_path(file_type, file_path)
      local node = SystemFS:parse_xml(path)
      for world in node:children() do
        if world:name() == "world" then
          t.node = world
          l_2_0._worlds[world:parameter("name")] = WorldDefinitionClass:new(t)
        end
      end
    end
  end
end

WorldHolder._error = function(l_3_0, l_3_1)
  if Application:editor() then
    managers.editor:output_error(l_3_1)
  end
  Application:error(l_3_1)
end

WorldHolder._worldfile_generation = function(l_4_0, l_4_1, l_4_2)
  if l_4_1 == "level" then
    return "level"
  end
  if not Application:editor() then
    return "new"
  end
  local path = managers.database:entry_expanded_path(l_4_1, l_4_2)
  local node = SystemFS:parse_xml(path)
  if node:name() == "worlds" then
    return "old"
  end
  if node:name() == "generic_scriptdata" then
    return "new"
  end
  return "unknown"
end

WorldHolder.is_ok = function(l_5_0)
  if l_5_0._worldfile_generation == "new" then
    return true
  end
  return (table.size(l_5_0._worlds) > 0 and l_5_0._worlds.world)
end

WorldHolder.create_world = function(l_6_0, l_6_1, l_6_2, l_6_3)
  if l_6_0._definition then
    local return_data = l_6_0._definition:create(l_6_2, l_6_3)
    if not Application:editor() and (l_6_2 == "statics" or l_6_2 == "all") and not Global.running_slave then
      World:occlusion_manager():merge_occluders(5)
    end
    return return_data
  end
  local c_world = l_6_0._worlds[l_6_1]
  if c_world then
    local return_data = c_world:create(l_6_2, l_6_3)
    if not Application:editor() and (l_6_2 == "statics" or l_6_2 == "all") and not Global.running_slave then
      World:culling_octree():build_tree()
      World:occlusion_manager():merge_occluders(5)
    end
    if not Application:editor() and l_6_2 == "all" then
      c_world:clear_definitions()
    end
    return return_data
  else
    Application:error("WorldHolder:create_world :: Could not create world", l_6_1, "for layer", l_6_2)
  end
end

WorldHolder.get_player_data = function(l_7_0, l_7_1, l_7_2, l_7_3)
  local c_world = l_7_0._worlds[l_7_1]
  if c_world then
    return c_world:get_player_data(l_7_3)
  else
    Application:error("WorldHolder:create_world :: Could not create world", l_7_1, "for layer", l_7_2)
  end
end

WorldHolder.get_max_id = function(l_8_0, l_8_1)
  if l_8_0._definition then
    return l_8_0._definition:get_max_id()
  end
  local c_world = l_8_0._worlds[l_8_1]
  if c_world then
    return c_world:get_max_id()
  else
    Application:error("WorldHolder:create_world :: Could not return max id", l_8_1)
  end
end

WorldHolder.get_level_name = function(l_9_0, l_9_1)
  local c_world = l_9_0._worlds[l_9_1]
  if c_world then
    return c_world:get_level_name()
  else
    Application:error("WorldHolder:create_world :: Could not return level name", l_9_1)
  end
end

CoreOldWorldDefinition.init = function(l_10_0, l_10_1)
  managers.worlddefinition = l_10_0
  l_10_0._max_id = 0
  l_10_0._level_name = "none"
  l_10_0._definitions = {}
  l_10_0._world_dir = l_10_1.world_dir
  l_10_0:_load_world_package()
  managers.sequence:preload()
  l_10_0._old_groups = {}
  l_10_0._old_groups.groups = {}
  l_10_0._old_groups.group_names = {}
  l_10_0._portal_slot_mask = World:make_slot_mask(1)
  l_10_0._massunit_replace_names = {}
  l_10_0._replace_names = {}
  l_10_0._replace_units_path = "assets/lib/utils/dev/editor/xml/replace_units"
  l_10_0:parse_replace_unit()
  l_10_0._excluded_continents = {}
  l_10_0:_parse_world_setting(l_10_1.world_setting)
  local node = l_10_1.node
  local level = l_10_1.level
  if node then
    if node:has_parameter("max_id") then
      l_10_0._max_id = tonumber(node:parameter("max_id"))
    end
    if node:has_parameter("level_name") then
      l_10_0._level_name = node:parameter("level_name")
    end
    l_10_0:parse_definitions(node)
  elseif level then
    l_10_0._level_file = level
    l_10_0._max_id = l_10_0._level_file:data(Idstring("world")).max_id
    l_10_0._level_name = l_10_0._level_file:data(Idstring("world")).level_name
  end
  if not l_10_0._definitions.editor_groups then
    l_10_0._definitions.editor_groups = {groups = l_10_0._old_groups.groups, group_names = l_10_0._old_groups.group_names}
  end
  l_10_0._all_units = {}
  l_10_0._stage_depended_units = {}
  l_10_0._trigger_units = {}
  l_10_0._use_unit_callbacks = {}
  l_10_0._mission_element_units = {}
end

CoreOldWorldDefinition._load_node = function(l_11_0, l_11_1, l_11_2)
  local path = managers.database:entry_expanded_path(l_11_1, l_11_2)
  return SystemFS:parse_xml(path)
end

CoreOldWorldDefinition._load_world_package = function(l_12_0)
  if Application:editor() then
    return 
  end
  local package = l_12_0._world_dir .. "world"
  if not DB:has("package", package) then
    Application:throw_exception("No world.package file found in " .. l_12_0._world_dir .. ", please resave level")
    return 
  end
  if not PackageManager:loaded(package) then
    PackageManager:load(package)
    l_12_0._current_world_package = package
  end
end

CoreOldWorldDefinition._load_continent_package = function(l_13_0, l_13_1)
  if Application:editor() then
    return 
  end
  if not DB:has("package", l_13_1) then
    Application:error("Missing package for a continent(" .. l_13_1 .. "), resave level " .. l_13_0._world_dir .. ".")
    return 
  end
  if not l_13_0._continent_packages then
    l_13_0._continent_packages = {}
  end
  if not PackageManager:loaded(l_13_1) then
    PackageManager:load(l_13_1)
    table.insert(l_13_0._continent_packages, l_13_1)
    managers.sequence:preload()
  end
end

CoreOldWorldDefinition.unload_packages = function(l_14_0)
  if l_14_0._current_world_package and PackageManager:loaded(l_14_0._current_world_package) then
    PackageManager:unload(l_14_0._current_world_package)
  end
  for _,package in ipairs(l_14_0._continent_packages) do
    PackageManager:unload(package)
  end
end

CoreOldWorldDefinition.nice_path = function(l_15_0, l_15_1)
  l_15_1 = string.match(string.gsub(l_15_1, ".*assets[/\\]", ""), "([^.]*)")
  l_15_1 = string.gsub(l_15_1, "\\", "/")
  return l_15_1
end

CoreOldWorldDefinition._parse_world_setting = function(l_16_0, l_16_1)
  if not l_16_1 then
    return 
  end
  local path = l_16_0:world_dir() .. l_16_1
  if not DB:has("world_setting", path) then
    Application:error("There is no world_setting file " .. l_16_1 .. " at path " .. path)
    return 
  end
  local settings = DB:load_node("world_setting", path)
  for continent in settings:children() do
    l_16_0._excluded_continents[continent:parameter("name")] = toboolean(continent:parameter("exclude"))
  end
end

CoreOldWorldDefinition.parse_definitions = function(l_17_0, l_17_1)
  local num_children = l_17_1:num_children()
  do
    local num_progress = 0
    for type in l_17_1:children() do
      local name = type:name()
      if not l_17_0._definitions[name] then
        l_17_0._definitions[name] = {}
      end
      if managers.editor then
        num_progress = num_progress + 50 / num_children
        managers.editor:update_load_progress(num_progress, "Parse layer: " .. name)
      end
      if l_17_0.parse_" .. nam then
        l_17_0.parse_" .. nam(l_17_0, type, l_17_0._definitions[name])
        for (for control) in (for generator) do
        end
        Application:error("CoreOldWorldDefinition:No parse function for type/layer", name)
      end
    end
     -- Warning: missing end command somewhere! Added here
  end
end

CoreOldWorldDefinition.world_dir = function(l_18_0)
  return l_18_0._world_dir
end

CoreOldWorldDefinition.get_max_id = function(l_19_0)
  return l_19_0._max_id
end

CoreOldWorldDefinition.get_level_name = function(l_20_0)
  return l_20_0._level_name
end

CoreOldWorldDefinition.parse_continents = function(l_21_0, l_21_1, l_21_2)
  local path = l_21_1:parameter("file")
  if not DB:has("continents", path) then
    path = l_21_0:world_dir() .. path
  end
  if not DB:has("continents", path) then
    Application:error("Continent file didn't exist " .. path .. ").")
    return 
  end
  do
    local continents = l_21_0:_load_node("continents", path)
    for continent in continents:children() do
      local data = parse_values_node(continent)
      if not data._values then
        data = {}
      end
      if not l_21_0:_continent_editor_only(data) then
        local name = continent:parameter("name")
        if not l_21_0._excluded_continents[name] then
          local path = l_21_0:world_dir() .. name .. "/" .. name
          l_21_0:_load_continent_package(path)
          if not data.base_id then
            data.base_id = tonumber(continent:parameter("base_id"))
          end
          do
            if DB:has("continent", path) then
              local node = l_21_0:_load_node("continent", path)
              for world in node:children() do
                data.level_name = world:parameter("level_name")
                l_21_2[name] = data
                l_21_0:parse_definitions(world)
              end
            end
            for (for control) in (for generator) do
            end
            Application:error("Continent file " .. path .. ".continent doesnt exist.")
          end
        end
      end
    end
     -- Warning: missing end command somewhere! Added here
  end
end

CoreOldWorldDefinition._continent_editor_only = function(l_22_0, l_22_1)
  return (not Application:editor() and l_22_1.editor_only)
end

CoreOldWorldDefinition.parse_values = function(l_23_0, l_23_1, l_23_2)
  for child in l_23_1:children() do
    local name, value = parse_value_node(child)
    l_23_2[name] = value
  end
end

CoreOldWorldDefinition.parse_markers = function(l_24_0, l_24_1, l_24_2)
  for child in l_24_1:children() do
    table.insert(l_24_2, LoadedMarker:new(child))
  end
end

CoreOldWorldDefinition.parse_groups = function(l_25_0, l_25_1, l_25_2)
  for child in l_25_1:children() do
    local name = child:parameter("name")
    local reference = tonumber(child:parameter("reference_unit_id"))
    if reference ~= 0 then
      l_25_0:add_editor_group(name, reference)
      for (for control) in (for generator) do
      end
      cat_error("Removed empty group", name, "when converting from old GroupHandler to new.")
    end
     -- Warning: missing end command somewhere! Added here
  end
end

CoreOldWorldDefinition.parse_editor_groups = function(l_26_0, l_26_1, l_26_2)
  local groups = l_26_0._old_groups.groups
  local group_names = l_26_0._old_groups.group_names
  for group in l_26_1:children() do
    local name = group:parameter("name")
    if not groups[name] then
      local reference = (tonumber(group:parameter("reference_id")))
      local continent = nil
      if group:has_parameter("continent") and group:parameter("continent") ~= "nil" then
        continent = group:parameter("continent")
      end
      local units = {}
      for unit in group:children() do
        table.insert(units, tonumber(unit:parameter("id")))
      end
      groups[name] = {}
      groups[name].reference = reference
      groups[name].continent = continent
      groups[name].units = units
      table.insert(group_names, name)
    end
  end
  l_26_2.groups = groups
  l_26_2.group_names = group_names
end

CoreOldWorldDefinition.add_editor_group = function(l_27_0, l_27_1, l_27_2)
  table.insert(l_27_0._old_groups.group_names, l_27_1)
  l_27_0._old_groups.groups[l_27_1] = {}
  l_27_0._old_groups.groups[l_27_1].reference = l_27_2
  if not l_27_0._old_groups.groups[l_27_1].units then
    l_27_0._old_groups.groups[l_27_1].units = {}
  end
end

CoreOldWorldDefinition.add_editor_group_unit = function(l_28_0, l_28_1, l_28_2)
  if not l_28_0._old_groups.groups[l_28_1].units then
    l_28_0._old_groups.groups[l_28_1].units = {}
  end
  table.insert(l_28_0._old_groups.groups[l_28_1].units, l_28_2)
end

CoreOldWorldDefinition.parse_brush = function(l_29_0, l_29_1)
  if l_29_1:has_parameter("path") then
    l_29_0._massunit_path = l_29_1:parameter("path")
  else
    if l_29_1:has_parameter("file") then
      l_29_0._massunit_path = l_29_1:parameter("file")
      if not DB:has("massunit", l_29_0._massunit_path) then
        l_29_0._massunit_path = l_29_0:world_dir() .. l_29_0._massunit_path
      end
    end
  end
end

CoreOldWorldDefinition.parse_sounds = function(l_30_0, l_30_1, l_30_2)
  local path = nil
  if l_30_1:has_parameter("path") then
    path = l_30_1:parameter("path")
  else
    if l_30_1:has_parameter("file") then
      path = l_30_1:parameter("file")
      if not DB:has("world_sounds", path) then
        path = l_30_0:world_dir() .. path
      end
    end
  end
  if not DB:has("world_sounds", path) then
    Application:error("The specified sound file '" .. path .. ".world_sounds' was not found for this level! ", path, "No sound will be loaded!")
    return 
  end
  local node = l_30_0:_load_node("world_sounds", path)
  l_30_0._sounds = CoreWDSoundEnvironment:new(node)
end

CoreOldWorldDefinition.parse_mission_scripts = function(l_31_0, l_31_1, l_31_2)
  if not Application:editor() then
    return 
  end
  if not l_31_2.scripts then
    l_31_2.scripts = {}
  end
  local values = parse_values_node(l_31_1)
  for name,data in pairs(values._scripts) do
    l_31_2.scripts[name] = data
  end
end

CoreOldWorldDefinition.parse_mission = function(l_32_0, l_32_1, l_32_2)
  if Application:editor() then
    if not rawget(_G, "MissionElementUnit") then
      local MissionClass = rawget(_G, "CoreMissionElementUnit")
    end
    for child in l_32_1:children() do
      table.insert(l_32_2, MissionClass:new(child))
    end
  end
end

CoreOldWorldDefinition.parse_environment = function(l_33_0, l_33_1)
  l_33_0._environment = CoreEnvironment:new(l_33_1)
end

CoreOldWorldDefinition.parse_world_camera = function(l_34_0, l_34_1)
  if l_34_1:has_parameter("path") then
    l_34_0._world_camera_path = l_34_1:parameter("path")
  else
    if l_34_1:has_parameter("file") then
      l_34_0._world_camera_path = l_34_1:parameter("file")
      if not DB:has("world_cameras", l_34_0._world_camera_path) then
        l_34_0._world_camera_path = l_34_0:world_dir() .. l_34_0._world_camera_path
      end
    end
  end
end

CoreOldWorldDefinition.parse_portal = function(l_35_0, l_35_1)
  l_35_0._portal = CorePortal:new(l_35_1)
end

CoreOldWorldDefinition.parse_wires = function(l_36_0, l_36_1, l_36_2)
  for child in l_36_1:children() do
    table.insert(l_36_2, CoreWire:new(child))
  end
end

CoreOldWorldDefinition.parse_statics = function(l_37_0, l_37_1, l_37_2)
  for child in l_37_1:children() do
    table.insert(l_37_2, CoreStaticUnit:new(child))
  end
end

CoreOldWorldDefinition.parse_dynamics = function(l_38_0, l_38_1, l_38_2)
  for child in l_38_1:children() do
    table.insert(l_38_2, CoreDynamicUnit:new(child))
  end
end

CoreOldWorldDefinition.release_sky_orientation_modifier = function(l_39_0)
  if l_39_0._environment then
    l_39_0._environment:release_sky_orientation_modifier()
  end
end

CoreOldWorldDefinition.clear_definitions = function(l_40_0)
  l_40_0._definitions = nil
end

CoreOldWorldDefinition.create = function(l_41_0, l_41_1, l_41_2)
  if l_41_0._level_file then
    l_41_0:create_from_level_file({layer = l_41_1, level_file = l_41_0._level_file, offset = l_41_2})
    l_41_0:_create_continent_level(l_41_1, l_41_2)
    l_41_0._level_file:destroy()
    return true
  else
    return l_41_0:create_units(l_41_1, l_41_2)
  end
end

CoreOldWorldDefinition._create_continent_level = function(l_42_0, l_42_1, l_42_2)
  if not l_42_0._level_file:data(Idstring("continents")) then
    Application:error("No continent data saved to level file, please resave.")
    return 
  end
  local path = l_42_0:world_dir() .. l_42_0._level_file:data(Idstring("continents")).file
  if not DB:has("continents", path) then
    Application:error("Continent file didn't exist " .. path .. ").")
    return 
  end
  do
    local continents = DB:load_node("continents", path)
    for continent in continents:children() do
      local data = parse_values_node(continent)
      if not data._values then
        data = {}
      end
      if not l_42_0:_continent_editor_only(data) then
        local name = continent:parameter("name")
        if not l_42_0._excluded_continents[name] then
          local path = l_42_0:world_dir() .. name .. "/" .. name
          l_42_0:_load_continent_package(path)
          do
            if DB:has("level", path) then
              local level_file = Level:load(path)
              l_42_0:create_from_level_file({layer = l_42_1, level_file = level_file, offset = l_42_2})
              level_file:destroy()
            end
            for (for control) in (for generator) do
            end
            Application:error("Continent file " .. path .. ".continent doesnt exist.")
          end
        end
      end
    end
     -- Warning: missing end command somewhere! Added here
  end
end

CoreOldWorldDefinition.create_units = function(l_43_0, l_43_1, l_43_2)
  if l_43_1 ~= "all" and not l_43_0._definitions[l_43_1] then
    return {}
  end
  local return_data = {}
  if l_43_1 == "markers" then
    return_data = l_43_0._definitions.markers
  end
  if l_43_1 == "values" then
    return_data = l_43_0._definitions.values
  end
  if l_43_1 == "editor_groups" then
    return_data = l_43_0._definitions.editor_groups
  end
  if l_43_1 == "continents" then
    return_data = l_43_0._definitions.continents
  end
  if (l_43_1 == "portal" or l_43_1 == "all") and l_43_0._portal then
    l_43_0._portal:create(l_43_2)
    return_data = l_43_0._portal
  end
  if (l_43_1 == "sounds" or l_43_1 == "all") and l_43_0._sounds then
    l_43_0._sounds:create()
    return_data = l_43_0._sounds
  end
  if l_43_1 == "mission_scripts" then
    return_data = l_43_0._definitions.mission_scripts
  end
  if l_43_1 == "mission" then
    for _,unit in ipairs(l_43_0._definitions.mission) do
      table.insert(return_data, unit:create_unit(l_43_2))
    end
  end
  if (l_43_1 == "brush" or l_43_1 == "all") and l_43_0._massunit_path then
    l_43_0:load_massunit(l_43_0._massunit_path, l_43_2)
  end
  if (l_43_1 == "environment" or l_43_1 == "all") and l_43_0._environment then
    l_43_0._environment:create(l_43_2)
    return_data = l_43_0._environment
  end
  if (l_43_1 == "world_camera" or l_43_1 == "all") and l_43_0._world_camera_path then
    managers.worldcamera:load(l_43_0._world_camera_path, l_43_2)
  end
  if (l_43_1 == "wires" or l_43_1 == "all") and l_43_0._definitions.wires then
    for _,unit in ipairs(l_43_0._definitions.wires) do
      table.insert(return_data, unit:create_unit(l_43_2))
    end
  end
  if l_43_1 == "statics" or l_43_1 == "all" then
    for _,unit in ipairs(l_43_0._definitions.statics) do
      table.insert(return_data, unit:create_unit(l_43_2))
    end
  end
  if l_43_1 == "dynamics" or l_43_1 == "all" then
    for _,unit in ipairs(l_43_0._definitions.dynamics) do
      table.insert(return_data, unit:create_unit(l_43_2))
    end
  end
  return return_data
end

CoreOldWorldDefinition.create_from_level_file = function(l_44_0, l_44_1)
  local layer = l_44_1.layer
  local offset = l_44_1.offset
  local level_file = l_44_1.level_file
  if (layer == "portal" or layer == "all") and not Application:editor() and level_file:data(Idstring("portal")) then
    l_44_0:create_portals(level_file:data(Idstring("portal")).portals, offset)
    l_44_0:create_portal_unit_groups(level_file:data(Idstring("portal")).unit_groups, offset)
  end
  if (layer == "sounds" or layer == "all") and level_file:data(Idstring("sounds")) then
    if level_file:data(Idstring("sounds")).path then
      l_44_0:create_sounds(level_file:data(Idstring("sounds")).path, offset)
    else
      if level_file:data(Idstring("sounds")).file then
        l_44_0:create_sounds(l_44_0:world_dir() .. level_file:data(Idstring("sounds")).file, offset)
      end
    end
  end
  if (layer == "brush" or layer == "all") and level_file:data(Idstring("brush")) then
    if level_file:data(Idstring("brush")).path then
      l_44_0:load_massunit(level_file:data(Idstring("brush")).path, offset)
    else
      if level_file:data(Idstring("brush")).file then
        l_44_0:load_massunit(l_44_0:world_dir() .. level_file:data(Idstring("brush")).file, offset)
      end
    end
  end
  if (layer == "environment" or layer == "all") and level_file:data(Idstring("environment")) then
    l_44_0:create_environment(level_file:data(Idstring("environment")), offset)
  end
  if (layer == "world_camera" or layer == "all") and level_file:data(Idstring("world_camera")) then
    if level_file:data(Idstring("world_camera")).path then
      managers.worldcamera:load(level_file:data(Idstring("world_camera")).path, offset)
    else
      if level_file:data(Idstring("world_camera")).file then
        managers.worldcamera:load(l_44_0:world_dir() .. level_file:data(Idstring("world_camera")).file, offset)
      end
    end
  end
  if layer == "wires" or layer == "all" then
    local t = l_44_0:create_level_units({layer = "wires", offset = offset, level_file = level_file})
    for _,d in ipairs(t) do
      local unit = d[1]
      local data = d[2]
      local wire = data.wire
      unit:wire_data().slack = wire.slack
      local target = unit:get_object(Idstring("a_target"))
      target:set_position(wire.target_pos)
      target:set_rotation(wire.target_rot)
      wire_set_midpoint(unit, Idstring("rp"), Idstring("a_target"), Idstring("a_bender"))
      unit:set_moving()
    end
  end
  if layer == "statics" or layer == "all" then
    l_44_0:create_level_units({layer = "statics", offset = offset, level_file = level_file})
  end
  if layer == "dynamics" or layer == "all" then
    l_44_0:create_level_units({layer = "dynamics", offset = offset, level_file = level_file})
  end
end

CoreOldWorldDefinition.create_level_units = function(l_45_0, l_45_1)
  local layer = l_45_1.layer
  local offset = l_45_1.offset
  local level_file = l_45_1.level_file
  local t = level_file:create(layer)
  for _,d in ipairs(t) do
    local unit = d[1]
    local data = d[2]
    local generic_data = l_45_0:make_generic_data(data)
    l_45_0:assign_unit_data(unit, generic_data)
  end
  return t
end

CoreOldWorldDefinition.create_portals = function(l_46_0, l_46_1, l_46_2)
  for _,portal in ipairs(l_46_1) do
    local t = {}
    for _,point in ipairs(portal.points) do
      table.insert(t, point.position + l_46_2)
    end
    local top = portal.top
    local bottom = portal.bottom
    if top == 0 and bottom == 0 then
      bottom, top = nil
    end
    managers.portal:add_portal(t, bottom, top)
  end
end

CoreOldWorldDefinition.create_portal_unit_groups = function(l_47_0, l_47_1, l_47_2)
  if not l_47_1 then
    return 
  end
  for name,shapes in pairs(l_47_1) do
    local group = managers.portal:add_unit_group(name)
    for _,shape in ipairs(shapes) do
      group:add_shape(shape)
    end
  end
end

CoreOldWorldDefinition.create_sounds = function(l_48_0, l_48_1)
  local sounds_level = Level:load(l_48_1)
  local sounds = sounds_level:data(Idstring("sounds"))
  managers.sound_environment:set_default_environment(sounds.environment)
  managers.sound_environment:set_default_ambience(sounds.ambience, sounds.ambience_soundbank)
  managers.sound_environment:set_ambience_enabled(sounds.ambience_enabled)
  for _,sound_environment in ipairs(sounds.sound_environments) do
    managers.sound_environment:add_area(sound_environment)
  end
  for _,sound_emitter in ipairs(sounds.sound_emitters) do
    managers.sound_environment:add_emitter(sound_emitter)
  end
  if sounds.sound_area_emitters then
    for _,sound_area_emitter in ipairs(sounds.sound_area_emitters) do
      managers.sound_environment:add_area_emitter(sound_area_emitter)
    end
  end
  sounds_level:destroy()
end

CoreOldWorldDefinition.create_environment = function(l_49_0, l_49_1, l_49_2)
  managers.environment_area:set_default_environment(l_49_1.environment, nil)
  l_49_0._environment_modifier_id = managers.viewport:viewports()[1]:create_environment_modifier(false, function()
    return data.sky_rot
   end, "sky_orientation")
  local wind = l_49_1.wind
  Wind:set_direction(wind.angle, wind.angle_var, 5)
  Wind:set_tilt(wind.tilt, wind.tilt_var, 5)
  Wind:set_speed_m_s(wind.speed or 6, wind.speed_variation or 1, 5)
  Wind:set_enabled(true)
  if not Application:editor() then
    for _,effect in ipairs(l_49_1.effects) do
      local name = Idstring(effect.name)
      if DB:has("effect", name) then
        managers.portal:add_effect({effect = name, position = effect.position, rotation = effect.rotation})
      end
    end
  end
  for _,environment_area in ipairs(l_49_1.environment_areas) do
    managers.environment_area:add_area(environment_area)
  end
end

CoreOldWorldDefinition.load_massunit = function(l_50_0, l_50_1, l_50_2)
  if Application:editor() then
    local l = MassUnitManager:list(l_50_1:id())
    for _,name in ipairs(l) do
      if DB:has(Idstring("unit"), name:id()) then
        CoreUnit.editor_load_unit(name)
        for (for control),_ in (for generator) do
        end
        if not table.has(l_50_0._massunit_replace_names, name:s()) then
          managers.editor:output("Unit " .. name:s() .. " does not exist")
          local old_name = name:s()
          name = managers.editor:show_replace_massunit()
          if name and DB:has(Idstring("unit"), name:id()) then
            CoreUnit.editor_load_unit(name)
          end
          l_50_0._massunit_replace_names[old_name] = name or ""
          managers.editor:output("Unit " .. old_name .. " changed to " .. tostring(name))
        end
      end
    end
    MassUnitManager:delete_all_units()
    MassUnitManager:load(l_50_1:id(), l_50_2, l_50_0._massunit_replace_names)
     -- Warning: missing end command somewhere! Added here
  end
end

CoreOldWorldDefinition.parse_replace_unit = function(l_51_0)
  local is_editor = Application:editor()
  if DB:has("xml", l_51_0._replace_units_path) then
    local node = DB:load_node("xml", l_51_0._replace_units_path)
    for unit in node:children() do
      local old_name = unit:name()
      local replace_with = unit:parameter("replace_with")
      l_51_0._replace_names[old_name] = replace_with
      if is_editor then
        managers.editor:output_info("Unit " .. old_name .. " will be replaced with " .. replace_with)
      end
    end
  end
end

CoreOldWorldDefinition.preload_unit = function(l_52_0, l_52_1)
  local is_editor = Application:editor()
  if table.has(l_52_0._replace_names, l_52_1) then
    l_52_1 = l_52_0._replace_names[l_52_1]
  elseif is_editor and (not DB:has(Idstring("unit"), l_52_1:id()) or CoreEngineAccess._editor_unit_data(l_52_1:id()):type():id() == Idstring("deleteme")) then
    if not DB:has(Idstring("unit"), l_52_1:id()) then
      managers.editor:output_info("Unit " .. l_52_1 .. " does not exist")
    else
      managers.editor:output_info("Unit " .. l_52_1 .. " is of type " .. CoreEngineAccess._editor_unit_data(l_52_1:id()):type():t())
    end
    local old_name = l_52_1
    l_52_1 = managers.editor:show_replace_unit()
    l_52_0._replace_names[old_name] = l_52_1
    managers.editor:output_info("Unit " .. old_name .. " changed to " .. tostring(l_52_1))
  end
  if is_editor and l_52_1 then
    CoreUnit.editor_load_unit(l_52_1)
  end
end

CoreOldWorldDefinition.make_unit = function(l_53_0, l_53_1, l_53_2, l_53_3)
  local is_editor = Application:editor()
  if table.has(l_53_0._replace_names, l_53_1) then
    l_53_1 = l_53_0._replace_names[l_53_1]
  end
  local unit = nil
  if l_53_1 then
    if MassUnitManager:can_spawn_unit(Idstring(l_53_1)) and not is_editor then
      unit = MassUnitManager:spawn_unit(Idstring(l_53_1), l_53_2._position + l_53_3, l_53_2._rotation)
    else
      unit = safe_spawn_unit(l_53_1, l_53_2._position + l_53_3, l_53_2._rotation)
    end
    if unit then
      l_53_0:assign_unit_data(unit, l_53_2)
    elseif is_editor then
      local s = "Failed creating unit " .. tostring(l_53_1)
      Application:throw_exception(s)
    end
  end
  return unit
end

CoreOldWorldDefinition.assign_unit_data = function(l_54_0, l_54_1, l_54_2)
  local is_editor = Application:editor()
  if not l_54_1:unit_data() then
    Application:error("The unit " .. l_54_1:name() .. " (" .. l_54_1:author() .. ") does not have the required extension unit_data (ScriptUnitData)")
  end
  if l_54_1:unit_data().only_exists_in_editor and not is_editor then
    l_54_1:set_slot(0)
    return 
  end
  if l_54_2._unit_id then
    l_54_1:unit_data().unit_id = l_54_2._unit_id
    l_54_1:set_editor_id(l_54_1:unit_data().unit_id)
    l_54_0._all_units[l_54_1:unit_data().unit_id] = l_54_1
    l_54_0:use_me(l_54_1, is_editor)
  end
  if is_editor then
    l_54_1:unit_data().name_id = l_54_2._name_id
    l_54_1:unit_data().world_pos = l_54_1:position()
  end
  if l_54_2._group_name and is_editor and not l_54_0._level_file and l_54_2._group_name ~= "none" then
    l_54_0:add_editor_group_unit(l_54_2._group_name, l_54_1:unit_data().unit_id)
  end
  if l_54_2._continent and is_editor then
    managers.editor:add_unit_to_continent(l_54_2._continent, l_54_1)
  end
  for _,l in ipairs(l_54_2._lights) do
    local light = l_54_1:get_object(Idstring(l.name))
    if light then
      light:set_enable(l.enable)
      light:set_far_range(l.far_range)
      light:set_color(l.color)
      if l.angle_start then
        light:set_spot_angle_start(l.angle_start)
        light:set_spot_angle_end(l.angle_end)
      end
      if l.multiplier then
        if tonumber(l.multiplier) then
          l.multiplier = CoreEditorUtils.get_intensity_preset(tonumber(l.multiplier))
        end
        if type_name(l.multiplier) == "string" then
          l.multiplier = Idstring(l.multiplier)
        end
        light:set_multiplier(LightIntensityDB:lookup(l.multiplier))
        light:set_specular_multiplier(LightIntensityDB:lookup_specular_multiplier(l.multiplier))
      end
      if l.falloff_exponent then
        light:set_falloff_exponent(l.falloff_exponent)
      end
    end
  end
  if l_54_2._variation and l_54_2._variation ~= "default" then
    l_54_1:unit_data().mesh_variation = l_54_2._variation
    managers.sequence:run_sequence_simple2(managers.sequence, l_54_1:unit_data().mesh_variation, "change_state", l_54_1)
  end
  if l_54_2._material_variation and l_54_2._material_variation ~= "default" then
    l_54_1:unit_data().material = l_54_2._material_variation
    l_54_1:set_material_config(l_54_1:unit_data().material, true)
  end
  if l_54_2._editable_gui then
    l_54_1:editable_gui():set_text(l_54_2._editable_gui.text)
    l_54_1:editable_gui():set_font_color(l_54_2._editable_gui.font_color)
    l_54_1:editable_gui():set_font_size(l_54_2._editable_gui.font_size)
    if not is_editor then
      l_54_1:editable_gui():lock_gui()
    end
  end
  l_54_0:add_trigger_sequence(l_54_1, l_54_2._triggers)
  if not table.empty(l_54_2._exists_in_stages) then
    local t = clone(CoreScriptUnitData.exists_in_stages)
    for i,value in pairs(l_54_2._exists_in_stages) do
      t[i] = value
    end
    l_54_1:unit_data().exists_in_stages = t
    table.insert(l_54_0._stage_depended_units, l_54_1)
  end
  if l_54_1:unit_data().only_visible_in_editor and not is_editor then
    l_54_1:set_visible(false)
  end
  if l_54_2.cutscene_actor then
    l_54_1:unit_data().cutscene_actor = l_54_2.cutscene_actor
    managers.cutscene:register_cutscene_actor(l_54_1)
  end
  if l_54_2.disable_shadows then
    if is_editor then
      l_54_1:unit_data().disable_shadows = l_54_2.disable_shadows
    end
    l_54_1:set_shadows_disabled(l_54_2.disable_shadows)
  end
  if not is_editor and l_54_0._portal_slot_mask and l_54_1:in_slot(l_54_0._portal_slot_mask) and not l_54_1:unit_data().only_visible_in_editor then
    managers.portal:add_unit(l_54_1)
  end
end

CoreOldWorldDefinition.add_trigger_sequence = function(l_55_0, l_55_1, l_55_2)
  do
    local is_editor = Application:editor()
    for _,trigger in ipairs(l_55_2) do
      do
        if is_editor and Global.running_simulation then
          local notify_unit = managers.editor:unit_with_id(trigger.notify_unit_id)
          l_55_1:damage():add_trigger_sequence(trigger.name, trigger.notify_unit_sequence, notify_unit, trigger.time, nil, nil, is_editor)
        end
        for (for control),_ in (for generator) do
        end
        if l_55_0._all_units[trigger.notify_unit_id] then
          l_55_1:damage():add_trigger_sequence(trigger.name, trigger.notify_unit_sequence, l_55_0._all_units[trigger.notify_unit_id], trigger.time, nil, nil, is_editor)
          for (for control),_ in (for generator) do
          end
          if l_55_0._trigger_units[trigger.notify_unit_id] then
            table.insert(l_55_0._trigger_units[trigger.notify_unit_id], {unit = l_55_1, trigger = trigger})
            for (for control),_ in (for generator) do
            end
            l_55_0._trigger_units[trigger.notify_unit_id] = {{unit = l_55_1, trigger = trigger}}
          end
        end
         -- Warning: missing end command somewhere! Added here
      end
       -- Warning: missing end command somewhere! Added here
    end
     -- Warning: missing end command somewhere! Added here
  end
end

CoreOldWorldDefinition.use_me = function(l_56_0, l_56_1, l_56_2)
  local id = l_56_1:unit_data().unit_id
  if l_56_0._trigger_units[id] then
    for _,t in ipairs(l_56_0._trigger_units[id]) do
      t.unit:damage():add_trigger_sequence(t.trigger.name, t.trigger.notify_unit_sequence, l_56_1, t.trigger.time, nil, nil, l_56_2)
    end
  end
  if l_56_0._use_unit_callbacks[id] then
    for _,call in ipairs(l_56_0._use_unit_callbacks[id]) do
      call(l_56_1)
    end
  end
end

CoreOldWorldDefinition.get_unit_on_load = function(l_57_0, l_57_1, l_57_2)
  if l_57_0._all_units[l_57_1] then
    return l_57_0._all_units[l_57_1]
  end
  if l_57_0._use_unit_callbacks[l_57_1] then
    table.insert(l_57_0._use_unit_callbacks[l_57_1], l_57_2)
  else
    l_57_0._use_unit_callbacks[l_57_1] = {l_57_2}
  end
  return nil
end

CoreOldWorldDefinition.check_stage_depended_units = function(l_58_0, l_58_1)
  for _,unit in ipairs(l_58_0._stage_depended_units) do
    for i,value in ipairs(unit:unit_data().exists_in_stages) do
      if l_58_1 == "stage" .. i and not value then
        World:delete_unit(unit)
      end
    end
  end
end

CoreOldWorldDefinition.get_unit = function(l_59_0, l_59_1)
  return l_59_0._all_units[l_59_1]
end

CoreOldWorldDefinition.add_mission_element_unit = function(l_60_0, l_60_1)
  l_60_0._mission_element_units[l_60_1:unit_data().unit_id] = l_60_1
end

CoreOldWorldDefinition.get_mission_element_unit = function(l_61_0, l_61_1)
  return l_61_0._mission_element_units[l_61_1]
end

CoreOldWorldDefinition.get_hub_element_unit = function(l_62_0, l_62_1)
  Application:stack_dump_error("CoreOldWorldDefinition:get_hub_element_unit is deprecated, use CoreOldWorldDefinition:get_mission_element_unit instead.")
  return l_62_0._mission_element_units[l_62_1]
end

CoreOldWorldDefinition.get_soundbank = function(l_63_0)
  return l_63_0._soundbank
end

if not LoadedMarker then
  LoadedMarker = class()
end
LoadedMarker.init = function(l_64_0, l_64_1)
  l_64_0._name = l_64_1:parameter("name")
  l_64_0._pos = math.string_to_vector(l_64_1:parameter("pos"))
  l_64_0._rot = math.string_to_vector(l_64_1:parameter("rot"))
  l_64_0._rot = Rotation(l_64_0._rot.x, l_64_0._rot.y, l_64_0._rot.z)
end

if not CoreWDSoundEnvironment then
  CoreWDSoundEnvironment = class()
end
CoreWDSoundEnvironment.init = function(l_65_0, l_65_1)
  l_65_0._sound_environments = {}
  l_65_0._sound_emitters = {}
  l_65_0._sound_area_emitters = {}
  l_65_1:for_each("default", callback(l_65_0, l_65_0, "parse_default"))
  l_65_1:for_each("ambience", callback(l_65_0, l_65_0, "parse_ambience"))
  l_65_1:for_each("sound_environment", callback(l_65_0, l_65_0, "parse_sound_environment"))
  l_65_1:for_each("sound_emitter", callback(l_65_0, l_65_0, "parse_sound_emitter"))
  l_65_1:for_each("sound_area_emitter", callback(l_65_0, l_65_0, "parse_sound_area_emitter"))
end

CoreWDSoundEnvironment.parse_default = function(l_66_0, l_66_1)
  l_66_0._default_ambience_soundbank = l_66_1:parameter("ambience_soundbank")
  l_66_0._default_environment = l_66_1:parameter("environment")
  l_66_0._default_ambience = l_66_1:parameter("ambience")
end

CoreWDSoundEnvironment.parse_ambience = function(l_67_0, l_67_1)
  l_67_0._ambience_enabled = toboolean(l_67_1:parameter("enabled"))
end

CoreWDSoundEnvironment.parse_sound_environment = function(l_68_0, l_68_1)
  local t = {}
  t.environment = l_68_1:parameter("environment")
  t.ambience_event = l_68_1:parameter("ambience_event")
  t.ambience_soundbank = l_68_1:parameter("ambience_soundbank")
  t.position = math.string_to_vector(l_68_1:parameter("position"))
  t.rotation = math.string_to_rotation(l_68_1:parameter("rotation"))
  t.width = tonumber(l_68_1:parameter("width"))
  t.depth = tonumber(l_68_1:parameter("depth"))
  t.height = tonumber(l_68_1:parameter("height"))
  t.name = l_68_1:parameter("name")
  table.insert(l_68_0._sound_environments, t)
end

CoreWDSoundEnvironment.parse_sound_emitter = function(l_69_0, l_69_1)
  for emitter in l_69_1:children() do
    table.insert(l_69_0._sound_emitters, parse_values_node(emitter))
  end
end

CoreWDSoundEnvironment.parse_sound_area_emitter = function(l_70_0, l_70_1)
  local t = {}
  for shape in l_70_1:children() do
    for value in shape:children() do
      local name, vt = parse_value_node(value)
      t = vt
    end
    t.position = math.string_to_vector(shape:parameter("position"))
    t.rotation = math.string_to_rotation(shape:parameter("rotation"))
  end
  table.insert(l_70_0._sound_area_emitters, t)
end

CoreWDSoundEnvironment.create = function(l_71_0)
  managers.sound_environment:set_default_environment(l_71_0._default_environment)
  managers.sound_environment:set_default_ambience(l_71_0._default_ambience, l_71_0._default_ambience_soundbank)
  managers.sound_environment:set_ambience_enabled(l_71_0._ambience_enabled)
  for _,sound_environment in ipairs(l_71_0._sound_environments) do
    managers.sound_environment:add_area(sound_environment)
  end
  for _,sound_emitter in ipairs(l_71_0._sound_emitters) do
    managers.sound_environment:add_emitter(sound_emitter)
  end
  for _,sound_area_emitter in ipairs(l_71_0._sound_area_emitters) do
    managers.sound_environment:add_area_emitter(sound_area_emitter)
  end
end

if not CoreEnvironment then
  CoreEnvironment = class()
end
CoreEnvironment.init = function(l_72_0, l_72_1)
  l_72_0._values = {}
  if l_72_1:has_parameter("environment") then
    l_72_0._values.environment = l_72_1:parameter("environment")
  end
  if l_72_1:has_parameter("sky_rot") then
    l_72_0._values.sky_rot = tonumber(l_72_1:parameter("sky_rot"))
  end
  l_72_1:for_each("value", callback(l_72_0, l_72_0, "parse_value"))
  l_72_1:for_each("wind", callback(l_72_0, l_72_0, "parse_wind"))
  l_72_0._unit_effects = {}
  l_72_1:for_each("unit_effect", callback(l_72_0, l_72_0, "parse_unit_effect"))
  l_72_0._environment_areas = {}
  l_72_1:for_each("environment_area", callback(l_72_0, l_72_0, "parse_environment_area"))
  l_72_0._units_data = {}
  l_72_0._units = {}
  l_72_1:for_each("unit", callback(l_72_0, l_72_0, "parse_unit"))
end

CoreEnvironment.release_sky_orientation_modifier = function(l_73_0)
  if l_73_0._environment_modifier_id then
    managers.viewport:viewports()[1]:destroy_environment_modifier(l_73_0._environment_modifier_id)
    l_73_0._environment_modifier_id = nil
  end
end

CoreEnvironment.parse_value = function(l_74_0, l_74_1)
  l_74_0._values[l_74_1:parameter("name")] = string_to_value(l_74_1:parameter("type"), l_74_1:parameter("value"))
end

CoreEnvironment.parse_wind = function(l_75_0, l_75_1)
  l_75_0._wind = {}
  l_75_0._wind.wind_angle = tonumber(l_75_1:parameter("angle"))
  l_75_0._wind.wind_dir_var = tonumber(l_75_1:parameter("angle_var"))
  l_75_0._wind.wind_tilt = tonumber(l_75_1:parameter("tilt"))
  l_75_0._wind.wind_tilt_var = tonumber(l_75_1:parameter("tilt_var"))
  if l_75_1:has_parameter("speed") then
    l_75_0._wind.wind_speed = tonumber(l_75_1:parameter("speed"))
  end
  if l_75_1:has_parameter("speed_variation") then
    l_75_0._wind.wind_speed_variation = tonumber(l_75_1:parameter("speed_variation"))
  end
end

CoreEnvironment.parse_unit_effect = function(l_76_0, l_76_1)
  local pos, rot = nil, nil
  for o in l_76_1:children() do
    pos = math.string_to_vector(o:parameter("pos"))
    rot = math.string_to_rotation(o:parameter("rot"))
  end
  local name = l_76_1:parameter("name")
  local t = {pos = pos, rot = rot, name = name}
  table.insert(l_76_0._unit_effects, t)
end

CoreEnvironment.parse_environment_area = function(l_77_0, l_77_1)
  local t = {}
  for shape in l_77_1:children() do
    t = managers.shape:parse(shape)
  end
  table.insert(l_77_0._environment_areas, t)
end

CoreEnvironment.parse_unit = function(l_78_0, l_78_1)
  if not Application:editor() then
    return 
  end
  local t = {}
  t.name = l_78_1:parameter("name")
  t.generic = Generic:new(l_78_1)
  table.insert(l_78_0._units_data, t)
end

CoreEnvironment.sky_rotation_modifier = function(l_79_0, l_79_1)
  return l_79_0._values.sky_rot
end

CoreEnvironment.create = function(l_80_0, l_80_1)
  if l_80_0._values.environment ~= "none" then
    managers.environment_area:set_default_environment(l_80_0._values.environment)
  end
  if not Application:editor() and not l_80_0._environment_modifier_id then
    l_80_0._environment_modifier_id = managers.viewport:viewports()[1]:create_environment_modifier(false, function(l_1_0)
    return self:sky_rotation_modifier(l_1_0)
   end, "sky_orientation")
  end
  if l_80_0._wind then
    Wind:set_direction(l_80_0._wind.wind_angle, l_80_0._wind.wind_dir_var, 5)
    Wind:set_tilt(l_80_0._wind.wind_tilt, l_80_0._wind.wind_tilt_var, 5)
    Wind:set_speed_m_s(l_80_0._wind.wind_speed or 6, l_80_0._wind.wind_speed_variation or 1, 5)
    Wind:set_enabled(true)
  end
  if not Application:editor() then
    for _,unit_effect in ipairs(l_80_0._unit_effects) do
      local name = Idstring(unit_effect.name)
      if DB:has("effect", name) then
        managers.portal:add_effect({effect = name, position = unit_effect.pos, rotation = unit_effect.rot})
      end
    end
  end
  for _,environment_area in ipairs(l_80_0._environment_areas) do
    managers.environment_area:add_area(environment_area)
  end
  for _,data in ipairs(l_80_0._units_data) do
    local unit = managers.worlddefinition:make_unit(data.name, data.generic, l_80_1)
    table.insert(l_80_0._units, unit)
  end
end

if not CorePortal then
  CorePortal = class()
end
CorePortal.init = function(l_81_0, l_81_1)
  managers.worlddefinition:preload_unit("core/units/portal_point/portal_point")
  l_81_0._portal_shapes = {}
  l_81_0._unit_groups = {}
  l_81_1:for_each("portal_list", callback(l_81_0, l_81_0, "parse_portal_list"))
  l_81_1:for_each("unit_group", callback(l_81_0, l_81_0, "parse_unit_group"))
end

CorePortal.parse_portal_list = function(l_82_0, l_82_1)
  local name = l_82_1:parameter("name")
  local top = tonumber(l_82_1:parameter("top")) or 0
  local bottom = tonumber(l_82_1:parameter("bottom")) or 0
  local draw_base = tonumber(l_82_1:parameter("draw_base")) or 0
  l_82_0._portal_shapes[name] = {portal = {}, top = top, bottom = bottom, draw_base = draw_base}
  local portal = l_82_0._portal_shapes[name].portal
  for o in l_82_1:children() do
    local p = math.string_to_vector(o:parameter("pos"))
    table.insert(portal, {pos = p})
  end
end

CorePortal.parse_unit_group = function(l_83_0, l_83_1)
  local name = l_83_1:parameter("name")
  local shapes = {}
  for shape in l_83_1:children() do
    table.insert(shapes, managers.shape:parse(shape))
  end
  l_83_0._unit_groups[name] = shapes
end

CorePortal.create = function(l_84_0, l_84_1)
  if not Application:editor() then
    for name,portal in pairs(l_84_0._portal_shapes) do
      local t = {}
      for _,data in ipairs(portal.portal) do
        table.insert(t, data.pos + l_84_1)
      end
      local top = portal.top
      local bottom = portal.bottom
      if top == 0 and bottom == 0 then
        bottom, top = nil
      end
      managers.portal:add_portal(t, bottom, top)
    end
  end
  for name,shapes in pairs(l_84_0._unit_groups) do
    local group = managers.portal:add_unit_group(name)
    for _,shape in ipairs(shapes) do
      group:add_shape(shape)
    end
  end
end

if not CoreWire then
  CoreWire = class()
end
CoreWire.init = function(l_85_0, l_85_1)
  l_85_0._unit_name = l_85_1:parameter("name")
  managers.worlddefinition:preload_unit(l_85_0._unit_name)
  l_85_0._generic = Generic:new(l_85_1)
  l_85_1:for_each("wire", callback(l_85_0, l_85_0, "parse_wire"))
end

CoreWire.parse_wire = function(l_86_0, l_86_1)
  l_86_0._target_pos = math.string_to_vector(l_86_1:parameter("target_pos"))
  local rot = math.string_to_vector(l_86_1:parameter("target_rot"))
  l_86_0._target_rot = Rotation(rot.x, rot.y, rot.z)
  l_86_0._slack = tonumber(l_86_1:parameter("slack"))
end

CoreWire.create_unit = function(l_87_0, l_87_1)
  l_87_0._unit = managers.worlddefinition:make_unit(l_87_0._unit_name, l_87_0._generic, l_87_1)
  if l_87_0._unit then
    l_87_0._unit:wire_data().slack = l_87_0._slack
    local target = l_87_0._unit:get_object(Idstring("a_target"))
    target:set_position(l_87_0._target_pos)
    target:set_rotation(l_87_0._target_rot)
    wire_set_midpoint(l_87_0._unit, l_87_0._unit:orientation_object():name(), Idstring("a_target"), Idstring("a_bender"))
    l_87_0._unit:set_moving()
  end
  return l_87_0._unit
end

if not CoreStaticUnit then
  CoreStaticUnit = class()
end
CoreStaticUnit.init = function(l_88_0, l_88_1)
  l_88_0._unit_name = l_88_1:parameter("name")
  managers.worlddefinition:preload_unit(l_88_0._unit_name)
  l_88_0._generic = Generic:new(l_88_1)
  l_88_0._generic:continent_upgrade_nil_to_world()
end

CoreStaticUnit.create_unit = function(l_89_0, l_89_1)
  l_89_0._unit = managers.worlddefinition:make_unit(l_89_0._unit_name, l_89_0._generic, l_89_1)
  return l_89_0._unit
end

if not CoreDynamicUnit then
  CoreDynamicUnit = class()
end
CoreDynamicUnit.init = function(l_90_0, l_90_1)
  l_90_0._unit_name = l_90_1:parameter("name")
  managers.worlddefinition:preload_unit(l_90_0._unit_name)
  l_90_0._generic = Generic:new(l_90_1)
  l_90_0._generic:continent_upgrade_nil_to_world()
end

CoreDynamicUnit.create_unit = function(l_91_0, l_91_1)
  l_91_0._unit = managers.worlddefinition:make_unit(l_91_0._unit_name, l_91_0._generic, l_91_1)
  return l_91_0._unit
end

CoreMissionElementUnit.init = function(l_92_0, l_92_1)
  l_92_0._unit_name = l_92_1:parameter("name")
  managers.worlddefinition:preload_unit(l_92_0._unit_name)
  if l_92_1:has_parameter("script") then
    l_92_0._script = l_92_1:parameter("script")
  end
  l_92_0._generic = Generic:new(l_92_1)
  l_92_0._generic:continent_upgrade_nil_to_world()
  l_92_1:for_each("values", callback(l_92_0, l_92_0, "parse_values"))
end

CoreMissionElementUnit.parse_values = function(l_93_0, l_93_1)
  l_93_0._values = MissionElementValues:new(l_93_1)
end

CoreMissionElementUnit.create_unit = function(l_94_0, l_94_1)
  l_94_0._unit = managers.worlddefinition:make_unit(l_94_0._unit_name, l_94_0._generic, l_94_1)
  if l_94_0._unit then
    l_94_0._unit:mission_element_data().script = l_94_0._script
    managers.worlddefinition:add_mission_element_unit(l_94_0._unit)
    if l_94_0._type then
      l_94_0._type:make_unit(l_94_0._unit)
    end
    if l_94_0._values then
      l_94_0._values:set_values(l_94_0._unit)
    end
  end
  return l_94_0._unit
end

if not MissionElementValues then
  MissionElementValues = class()
end
MissionElementValues.init = function(l_95_0, l_95_1)
  l_95_0._values = parse_values_node(l_95_1)
end

MissionElementValues.set_values = function(l_96_0, l_96_1)
  for name,value in pairs(l_96_0._values) do
    l_96_1:mission_element_data()[name] = value
  end
end

CoreOldWorldDefinition.make_generic_data = function(l_97_0, l_97_1)
  local data = {}
  data._name_id = "none"
  data._lights = {}
  data._triggers = {}
  data._exists_in_stages = {}
  local generic = l_97_1.generic
  local lights = l_97_1.lights
  local variation = l_97_1.variation
  local material_variation = l_97_1.material_variation
  local triggers = l_97_1.triggers
  local cutscene_actor = l_97_1.cutscene_actor
  local disable_shadows = l_97_1.disable_shadows
  if generic then
    data._unit_id = generic.unit_id
    data._name_id = generic.name_id
    data._group_name = generic.group_name
  end
  for _,light in ipairs(lights) do
    table.insert(data._lights, light)
  end
  if variation then
    data._variation = variation.value
  end
  if material_variation then
    data._material_variation = material_variation.value
  end
  if triggers then
    for _,trigger in ipairs(triggers) do
      table.insert(data._triggers, trigger)
    end
  end
  if cutscene_actor then
    data.cutscene_actor = cutscene_actor.name
  end
  if disable_shadows then
    data.disable_shadows = disable_shadows.value
  end
  data._editable_gui = l_97_1.editable_gui
  return data
end

if not Generic then
  Generic = class()
end
Generic.init = function(l_98_0, l_98_1)
  l_98_0._name_id = "none"
  l_98_0._lights = {}
  l_98_0._triggers = {}
  l_98_0._exists_in_stages = {}
  l_98_1:for_each("generic", callback(l_98_0, l_98_0, "parse_generic"))
  l_98_1:for_each("orientation", callback(l_98_0, l_98_0, "parse_orientation"))
  l_98_1:for_each("light", callback(l_98_0, l_98_0, "parse_light"))
  l_98_1:for_each("variation", callback(l_98_0, l_98_0, "parse_variation"))
  l_98_1:for_each("material_variation", callback(l_98_0, l_98_0, "parse_material_variation"))
  l_98_1:for_each("trigger", callback(l_98_0, l_98_0, "parse_trigger"))
  l_98_1:for_each("editable_gui", callback(l_98_0, l_98_0, "parse_editable_gui"))
  l_98_1:for_each("settings", callback(l_98_0, l_98_0, "parse_settings"))
  l_98_1:for_each("legend_settings", callback(l_98_0, l_98_0, "parse_legend_settings"))
  l_98_1:for_each("exists_in_stage", callback(l_98_0, l_98_0, "parse_exists_in_stage"))
  l_98_1:for_each("cutscene_actor", callback(l_98_0, l_98_0, "cutscene_actor_settings"))
  l_98_1:for_each("disable_shadows", callback(l_98_0, l_98_0, "parse_disable_shadows"))
end

Generic.parse_orientation = function(l_99_0, l_99_1)
  l_99_0._position = math.string_to_vector(l_99_1:parameter("pos"))
  local rot = math.string_to_vector(l_99_1:parameter("rot"))
  l_99_0._rotation = Rotation(rot.x, rot.y, rot.z)
end

Generic.parse_generic = function(l_100_0, l_100_1)
  if l_100_1:has_parameter("unit_id") then
    l_100_0._unit_id = tonumber(l_100_1:parameter("unit_id"))
  end
  if l_100_1:has_parameter("name_id") then
    l_100_0._name_id = l_100_1:parameter("name_id")
  end
  if l_100_1:has_parameter("group_name") then
    l_100_0._group_name = l_100_1:parameter("group_name")
  end
  if l_100_1:has_parameter("continent") then
    local c = l_100_1:parameter("continent")
    if c ~= "nil" then
      l_100_0._continent = c
    end
  end
end

Generic.continent_upgrade_nil_to_world = function(l_101_0)
  if not l_101_0._continent then
    l_101_0._continent = "world"
  end
end

Generic.parse_light = function(l_102_0, l_102_1)
  local name = l_102_1:parameter("name")
  local far_range = tonumber(l_102_1:parameter("far_range"))
  local enable = toboolean(l_102_1:parameter("enabled"))
  local color = (math.string_to_vector(l_102_1:parameter("color")))
  local angle_start, angle_end, multiplier, falloff_exponent = nil, nil, nil, nil
  if l_102_1:has_parameter("angle_start") then
    angle_start = tonumber(l_102_1:parameter("angle_start"))
    angle_end = tonumber(l_102_1:parameter("angle_end"))
  end
  if l_102_1:has_parameter("multiplier") then
    multiplier = l_102_1:parameter("multiplier")
  end
  if l_102_1:has_parameter("falloff_exponent") then
    falloff_exponent = tonumber(l_102_1:parameter("falloff_exponent"))
  end
  table.insert(l_102_0._lights, {name = name, far_range = far_range, enable = enable, color = color, angle_start = angle_start, angle_end = angle_end, multiplier = multiplier, falloff_exponent = falloff_exponent})
end

Generic.parse_variation = function(l_103_0, l_103_1)
  l_103_0._variation = l_103_1:parameter("value")
end

Generic.parse_material_variation = function(l_104_0, l_104_1)
  l_104_0._material_variation = l_104_1:parameter("value")
end

Generic.parse_settings = function(l_105_0, l_105_1)
  l_105_0._unique_item = toboolean(l_105_1:parameter("unique_item"))
end

Generic.parse_legend_settings = function(l_106_0, l_106_1)
  l_106_0._legend_name = l_106_1:parameter("legend_name")
end

Generic.cutscene_actor_settings = function(l_107_0, l_107_1)
  l_107_0.cutscene_actor = l_107_1:parameter("name")
end

Generic.parse_disable_shadows = function(l_108_0, l_108_1)
  l_108_0.disable_shadows = toboolean(l_108_1:parameter("value"))
end

Generic.parse_exists_in_stage = function(l_109_0, l_109_1)
  l_109_0._exists_in_stages[tonumber(l_109_1:parameter("stage"))] = toboolean(l_109_1:parameter("value"))
end

Generic.parse_trigger = function(l_110_0, l_110_1)
  local trigger = {}
  trigger.name = l_110_1:parameter("name")
  trigger.id = tonumber(l_110_1:parameter("id"))
  trigger.notify_unit_id = tonumber(l_110_1:parameter("notify_unit_id"))
  trigger.time = tonumber(l_110_1:parameter("time"))
  trigger.notify_unit_sequence = l_110_1:parameter("notify_unit_sequence")
  table.insert(l_110_0._triggers, trigger)
end

Generic.parse_editable_gui = function(l_111_0, l_111_1)
  local text = l_111_1:parameter("text")
  local font_color = math.string_to_vector(l_111_1:parameter("font_color"))
  local font_size = tonumber(l_111_1:parameter("font_size"))
  l_111_0._editable_gui = {text = text, font_color = font_color, font_size = font_size}
end


