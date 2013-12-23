-- Decompiled using luadec 2.0.1 by sztupy (http://winmo.sztupy.hu)
-- Command line was: F:\SteamLibrary\SteamApps\common\PAYDAY 2\lua\core\lib\managers\controller\corecontrollermanager.luac 

core:module("CoreControllerManager")
core:import("CoreControllerWrapperSettings")
core:import("CoreControllerWrapperGamepad")
core:import("CoreControllerWrapperPC")
core:import("CoreControllerWrapperXbox360")
core:import("CoreControllerWrapperPS3")
core:import("CoreControllerWrapperDebug")
core:import("CoreManagerBase")
core:import("CoreEvent")
if not ControllerManager then
  ControllerManager = class(CoreManagerBase.ManagerBase)
end
ControllerManager.CONTROLLER_SETTINGS_TYPE = ControllerManager.CONTROLLER_SETTINGS_TYPE or "controller_settings"
ControllerManager.CORE_CONTROLLER_SETTINGS_PATH = ControllerManager.CORE_CONTROLLER_SETTINGS_PATH or "core/settings/core_controller_settings"
ControllerManager.init = function(l_1_0, l_1_1, l_1_2)
  ControllerManager.super.init(l_1_0, "controller")
  if not Global.controller_manager then
    Global.controller_manager = {default_controller_connected = nil}
  end
  l_1_0._skip_controller_map = {}
  if SystemInfo:platform() ~= Idstring("WIN32") then
    l_1_0._skip_controller_map.win32_keyboard = true
    l_1_0._skip_controller_map.win32_mouse = true
  end
  l_1_0._controller_to_wrapper_list = {}
  l_1_0._wrapper_to_controller_list = {}
  l_1_0._wrapper_class_map = {}
  l_1_0._wrapper_count = 0
  l_1_0:create_virtual_pad()
  l_1_0._last_default_wrapper_index_change_callback_id = 0
  l_1_0._default_wrapper_index_change_callback_map = {}
  l_1_0._controller_wrapper_list = {}
  l_1_0._controller_wrapper_map = {}
  l_1_0._next_controller_wrapper_id = 1
  l_1_0._supported_wrapper_types = {}
  if SystemInfo:platform() == Idstring("WIN32") then
    l_1_0._supported_wrapper_types[CoreControllerWrapperPC.ControllerWrapperPC.TYPE] = CoreControllerWrapperPC.ControllerWrapperPC
    l_1_0._supported_wrapper_types[CoreControllerWrapperXbox360.ControllerWrapperXbox360.TYPE] = CoreControllerWrapperXbox360.ControllerWrapperXbox360
  else
    if SystemInfo:platform() == Idstring("PS3") then
      l_1_0._supported_wrapper_types[CoreControllerWrapperPS3.ControllerWrapperPS3.TYPE] = CoreControllerWrapperPS3.ControllerWrapperPS3
    else
      if SystemInfo:platform() == Idstring("X360") then
        l_1_0._supported_wrapper_types[CoreControllerWrapperXbox360.ControllerWrapperXbox360.TYPE] = CoreControllerWrapperXbox360.ControllerWrapperXbox360
      end
    end
  end
  l_1_0._supported_controller_type_map = {}
  for wrapper_type,wrapper in pairs(l_1_0._supported_wrapper_types) do
    for _,controller_type in ipairs(wrapper.CONTROLLER_TYPE_LIST) do
      l_1_0._supported_controller_type_map[controller_type] = wrapper_type
    end
  end
  l_1_0._last_version = nil
  l_1_0._last_core_version = nil
  l_1_0._default_settings_path = l_1_2
  l_1_0._controller_setup = {}
  l_1_0._core_controller_setup = {}
  l_1_0._settings_file_changed_callback_list = {}
  l_1_0._last_settings_file_changed_callback_id = 0
  l_1_0._settings_path = l_1_1
  l_1_0:load_core_settings(false)
  l_1_0._default_controller_connect_change_callback_handler = CoreEvent.CallbackEventHandler:new()
  l_1_0:update_controller_wrapper_mappings()
  l_1_0:setup_default_controller_list()
end

ControllerManager.setup_default_controller_list = function(l_2_0)
  if Global.controller_manager.default_wrapper_index then
    local controller_index_list = l_2_0._wrapper_to_controller_list[Global.controller_manager.default_wrapper_index]
    l_2_0._default_controller_list = {}
    for _,controller_index in ipairs(controller_index_list) do
      table.insert(l_2_0._default_controller_list, Input:controller(controller_index))
    end
  end
end

ControllerManager.update = function(l_3_0, l_3_1, l_3_2)
  for id,controller_wrapper in pairs(l_3_0._controller_wrapper_list) do
    if controller_wrapper:enabled() then
      controller_wrapper:update(l_3_1, l_3_2)
    end
  end
  l_3_0:check_connect_change()
end

ControllerManager.paused_update = function(l_4_0, l_4_1, l_4_2)
  for id,controller_wrapper in pairs(l_4_0._controller_wrapper_list) do
    if controller_wrapper:enabled() then
      controller_wrapper:paused_update(l_4_1, l_4_2)
    end
  end
  l_4_0:check_connect_change()
end

ControllerManager.check_connect_change = function(l_5_0)
  if l_5_0._default_controller_list then
    local connected = nil
    for _,controller in ipairs(l_5_0._default_controller_list) do
      connected = controller:connected()
      if not connected then
        do return end
      end
    end
    if not Global.controller_manager.default_controller_connected ~= not connected then
      l_5_0:default_controller_connect_change(connected)
      Global.controller_manager.default_controller_connected = connected
    end
  end
end

ControllerManager.default_controller_connect_change = function(l_6_0, l_6_1)
  l_6_0._default_controller_connect_change_callback_handler:dispatch(l_6_1)
end

ControllerManager.add_settings_file_changed_callback = function(l_7_0, l_7_1)
  l_7_0._last_settings_file_changed_callback_id = l_7_0._last_settings_file_changed_callback_id + 1
  l_7_0._settings_file_changed_callback_list[l_7_0._last_settings_file_changed_callback_id] = l_7_1
  return l_7_0._last_settings_file_changed_callback_id
end

ControllerManager.remove_settings_file_changed_callback = function(l_8_0, l_8_1)
  l_8_0._settings_file_changed_callback_list[l_8_1] = nil
end

ControllerManager.add_default_controller_connect_change_callback = function(l_9_0, l_9_1)
  l_9_0._default_controller_connect_change_callback_handler:add(l_9_1)
end

ControllerManager.remove_default_controller_connect_change_callback = function(l_10_0, l_10_1)
  l_10_0._default_controller_connect_change_callback_handler:remove(l_10_1)
end

ControllerManager.create_controller = function(l_11_0, l_11_1, l_11_2, l_11_3, l_11_4)
  local controller_wrapper = nil
  l_11_0:update_controller_wrapper_mappings()
  if l_11_3 then
    local wrapper_list = {}
    local default_wrapper = nil
    for wrapper_index,wrapper_class in pairs(l_11_0._wrapper_class_map) do
      local controller_index = l_11_0._wrapper_to_controller_list[wrapper_index][1]
      local controller = Input:controller(controller_index)
      local wrapper = wrapper_class:new(l_11_0, l_11_0._next_controller_wrapper_id, l_11_1, controller, l_11_0._controller_setup[wrapper_class.TYPE], l_11_3, false, l_11_0._virtual_game_pad)
      if not l_11_4 then
        l_11_0:_add_accessobj(wrapper, CoreManagerBase.PRIO_DEFAULT)
      end
      if not default_wrapper then
        default_wrapper = wrapper
      end
      table.insert(wrapper_list, wrapper)
    end
    controller_wrapper = CoreControllerWrapperDebug.ControllerWrapperDebug:new(wrapper_list, l_11_0, l_11_0._next_controller_wrapper_id, l_11_1, default_wrapper, CoreControllerWrapperSettings.ControllerWrapperSettings:new(CoreControllerWrapperDebug.ControllerWrapperDebug.TYPE, nil, nil, nil))
  elseif not l_11_2 and not Global.controller_manager.default_wrapper_index then
    l_11_2 = l_11_0:get_preferred_default_wrapper_index()
  end
  local wrapper_class = l_11_0._wrapper_class_map[l_11_2]
  if not wrapper_class then
    error("Tried to create a controller with non-existing index \"" .. tostring(l_11_2) .. "\" (default index: " .. tostring(Global.controller_manager.default_wrapper_index) .. ", name: \"" .. tostring(l_11_1) .. "\").")
  end
  local controller_index = l_11_0._wrapper_to_controller_list[l_11_2][1]
  do
    local controller = Input:controller(controller_index)
    controller_wrapper = wrapper_class:new(l_11_0, l_11_0._next_controller_wrapper_id, l_11_1, controller, l_11_0._controller_setup[wrapper_class.TYPE], l_11_3, false, l_11_0._virtual_game_pad)
  end
  if l_11_1 then
    if l_11_0._controller_wrapper_map[l_11_1] then
      controller_wrapper:destroy()
      error("Tried to create a controller with a name \"" .. tostring(l_11_1) .. "\" that already exists.")
    end
    l_11_0._controller_wrapper_map[l_11_1] = controller_wrapper
  end
  cat_print("controller_manager", "[ControllerManager] Created new controller. Name: " .. tostring(l_11_1) .. ", Index: " .. tostring(l_11_2) .. ", Debug: " .. tostring(l_11_3) .. ", Id: " .. tostring(l_11_0._next_controller_wrapper_id))
  controller_wrapper:add_destroy_callback(callback(l_11_0, l_11_0, "controller_wrapper_destroy_callback"))
  l_11_0._controller_wrapper_list[l_11_0._next_controller_wrapper_id] = controller_wrapper
  l_11_0._next_controller_wrapper_id = l_11_0._next_controller_wrapper_id + 1
  if not l_11_4 then
    l_11_0:_add_accessobj(controller_wrapper, CoreManagerBase.PRIO_DEFAULT)
    return controller_wrapper
  end
end

ControllerManager.get_controller_by_name = function(l_12_0, l_12_1)
  if l_12_1 and l_12_0._controller_wrapper_map[l_12_1] then
    return l_12_0._controller_wrapper_map[l_12_1]
  end
end

ControllerManager.get_preferred_default_wrapper_index = function(l_13_0)
  l_13_0:update_controller_wrapper_mappings()
  for wrapper_index,wrapper_class in ipairs(l_13_0._wrapper_class_map) do
    if Input:controller(wrapper_index):connected() and wrapper_class.TYPE ~= "pc" then
      return wrapper_index
    end
  end
  return 1
end

ControllerManager.get_default_wrapper_type = function(l_14_0)
  if not Global.controller_manager.default_wrapper_index then
    local index = l_14_0:get_preferred_default_wrapper_index()
  end
  local wrapper_class = l_14_0._wrapper_class_map[index]
  return wrapper_class.TYPE
end

ControllerManager.update_controller_wrapper_mappings = function(l_15_0)
  local controller_count = Input:num_real_controllers()
  local controller_type_to_old_wrapper_map = {}
  local next_wrapper_index = 1
  for controller_index = 0, controller_count do
    if not l_15_0._controller_to_wrapper_list[controller_index] then
      local controller = Input:controller(controller_index)
      local controller_type = controller:type()
      local wrapper_type = l_15_0._supported_controller_type_map[controller_type]
      if wrapper_type and not l_15_0._skip_controller_map[controller_type] then
        local old_wrapper_index = controller_type_to_old_wrapper_map[controller_type]
        local wrapper_index = nil
        local wrapper_class = l_15_0._supported_wrapper_types[wrapper_type]
        if old_wrapper_index then
          wrapper_index = old_wrapper_index
          controller_type_to_old_wrapper_map[controller_type] = nil
        else
          wrapper_index = next_wrapper_index
          l_15_0._wrapper_count = next_wrapper_index
          l_15_0._wrapper_class_map[wrapper_index] = wrapper_class
          for _,next_controller_type in ipairs(wrapper_class.CONTROLLER_TYPE_LIST) do
            if controller_type ~= next_controller_type then
              controller_type_to_old_wrapper_map[next_controller_type] = wrapper_index
            end
          end
          next_wrapper_index = next_wrapper_index + 1
        end
        l_15_0._controller_to_wrapper_list[controller_index] = wrapper_index
        if not l_15_0._wrapper_to_controller_list[wrapper_index] then
          l_15_0._wrapper_to_controller_list[wrapper_index] = {}
        end
        if controller_type == wrapper_class.CONTROLLER_TYPE_LIST[1] then
          table.insert(l_15_0._wrapper_to_controller_list[wrapper_index], 1, controller_index)
        else
          table.insert(l_15_0._wrapper_to_controller_list[wrapper_index], controller_index)
        end
      end
    end
  end
end

ControllerManager.get_controller_index_list = function(l_16_0, l_16_1)
  return l_16_0._wrapper_to_controller_list[l_16_1]
end

ControllerManager.get_wrapper_index = function(l_17_0, l_17_1)
  return l_17_0._controller_to_wrapper_list[l_17_1]
end

ControllerManager.get_real_controller_count = function(l_18_0)
  return Input:num_real_controllers()
end

ControllerManager.get_wrapper_count = function(l_19_0)
  l_19_0:update_controller_wrapper_mappings()
  return l_19_0._wrapper_count
end

ControllerManager.add_default_wrapper_index_change_callback = function(l_20_0, l_20_1)
  l_20_0._last_default_wrapper_index_change_callback_id = l_20_0._last_default_wrapper_index_change_callback_id + 1
  l_20_0._default_wrapper_index_change_callback_map[l_20_0._last_default_wrapper_index_change_callback_id] = l_20_1
  return l_20_0._last_default_wrapper_index_change_callback_id
end

ControllerManager.remove_default_wrapper_index_change_callback = function(l_21_0, l_21_1)
  l_21_0._default_wrapper_index_change_callback_map[l_21_1] = nil
end

ControllerManager.set_default_wrapper_index = function(l_22_0, l_22_1)
  if Global.controller_manager.default_wrapper_index ~= l_22_1 then
    if l_22_1 then
      local controller_index_list = l_22_0._wrapper_to_controller_list[l_22_1]
    end
    if not l_22_1 or controller_index_list then
      cat_print("controller_manager", "[ControllerManager] Changed default controller index from " .. tostring(Global.controller_manager.default_wrapper_index) .. " to " .. tostring(l_22_1) .. ".")
      Global.controller_manager.default_wrapper_index = l_22_1
      if not Global.controller_manager.default_wrapper_index then
        l_22_0:_close_controller_changed_dialog()
      end
      local remove_safe_list = {}
      for _,func in pairs(l_22_0._default_wrapper_index_change_callback_map) do
        table.insert(remove_safe_list, func)
      end
      for _,func in ipairs(remove_safe_list) do
        func(l_22_1)
      end
      l_22_0:setup_default_controller_list()
    else
      Application:error("Invalid default controller index.")
    end
  end
end

ControllerManager.get_default_wrapper_index = function(l_23_0)
  return Global.controller_manager.default_wrapper_index
end

ControllerManager.controller_wrapper_destroy_callback = function(l_24_0, l_24_1)
  l_24_0:_del_accessobj(l_24_1)
  local id = l_24_1:get_id()
  local name = l_24_1:get_name()
  cat_print("controller_manager", "[ControllerManager] Destroyed controller. Name: " .. tostring(name) .. ", Id: " .. tostring(id))
  l_24_0._controller_wrapper_list[id] = nil
  if name then
    l_24_0._controller_wrapper_map[name] = nil
  end
end

ControllerManager.load_core_settings = function(l_25_0)
  local result = nil
  if PackageManager:has(l_25_0.CONTROLLER_SETTINGS_TYPE:id(), l_25_0.CORE_CONTROLLER_SETTINGS_PATH:id()) then
    local node = PackageManager:script_data(l_25_0.CONTROLLER_SETTINGS_TYPE:id(), l_25_0.CORE_CONTROLLER_SETTINGS_PATH:id())
    local parsed_controller_setup_map = {}
    for _,child in ipairs(node) do
      local wrapper_type = child._meta
      if l_25_0._core_controller_setup[wrapper_type] then
        Application:error("Duplicate core controller settings for \"" .. tostring(wrapper_type) .. "\" found in \"" .. tostring(l_25_0.CORE_CONTROLLER_SETTINGS_PATH) .. "." .. tostring(l_25_0.CONTROLLER_SETTINGS_TYPE) .. "\". Overwrites existing one.")
      end
      local setup = CoreControllerWrapperSettings.ControllerWrapperSettings:new(wrapper_type, child, nil, l_25_0.CORE_CONTROLLER_SETTINGS_PATH .. "." .. l_25_0.CONTROLLER_SETTINGS_TYPE)
      parsed_controller_setup_map[wrapper_type] = setup
    end
    if l_25_0:verify_parsed_controller_setup_map(parsed_controller_setup_map, l_25_0.CORE_CONTROLLER_SETTINGS_PATH) then
      l_25_0._last_core_version = tonumber(node.core_version)
      l_25_0._core_controller_setup = parsed_controller_setup_map
      l_25_0._controller_setup = parsed_controller_setup_map
    end
    result = true
  end
  if l_25_0._settings_path then
    l_25_0:load_settings(l_25_0._settings_path)
  end
  return result
end

ControllerManager.load_settings = function(l_26_0, l_26_1)
  local result = false
  if l_26_0._default_settings_path and (not l_26_1 or not PackageManager:has(l_26_0.CONTROLLER_SETTINGS_TYPE:id(), l_26_1:id())) and l_26_1 then
    Application:error("Invalid path \"" .. tostring(l_26_1) .. "." .. tostring(l_26_0.CONTROLLER_SETTINGS_TYPE) .. "\", defaults to \"" .. tostring(l_26_0._default_settings_path) .. "." .. tostring(l_26_0.CONTROLLER_SETTINGS_TYPE) .. "\".")
  end
  l_26_1 = l_26_0._default_settings_path
  if l_26_1 and PackageManager:has(l_26_0.CONTROLLER_SETTINGS_TYPE:id(), l_26_1:id()) then
    local node = PackageManager:script_data(l_26_0.CONTROLLER_SETTINGS_TYPE:id(), l_26_1:id())
    local version = tonumber(node.version)
    local core_version = tonumber(node.core_version)
    local valid_version = not l_26_0._last_version or not version or l_26_0._last_version <= version
    local valid_core_version = l_26_1 == l_26_0._default_settings_path or not l_26_0._last_core_version or not core_version or l_26_0._last_core_version <= core_version
    if valid_version and valid_core_version then
      local parsed_controller_setup_map = {}
      for _,child in ipairs(node) do
        local wrapper_type = child._meta
        if parsed_controller_setup_map[wrapper_type] then
          Application:error("Duplicate controller settings for \"" .. tostring(wrapper_type) .. "\" found in \"" .. tostring(l_26_1) .. "." .. tostring(l_26_0.CONTROLLER_SETTINGS_TYPE) .. "\". Overwrites existing one.")
        end
        local setup = CoreControllerWrapperSettings.ControllerWrapperSettings:new(wrapper_type, child, l_26_0._core_controller_setup[wrapper_type], tostring(l_26_1) .. "." .. tostring(l_26_0.CONTROLLER_SETTINGS_TYPE))
        parsed_controller_setup_map[wrapper_type] = setup
      end
      if l_26_0:verify_parsed_controller_setup_map(parsed_controller_setup_map, l_26_1) then
        result = true
        for _,controller_wrapper in pairs(l_26_0._controller_wrapper_list) do
          controller_wrapper:clear_connections(false)
        end
        l_26_0._controller_setup = parsed_controller_setup_map
        l_26_0._last_version = version
        l_26_0._settings_path = l_26_1
      else
        Application:error("Ignores invalid controller setting file \"" .. tostring(l_26_1) .. "." .. tostring(l_26_0.CONTROLLER_SETTINGS_TYPE) .. "\".")
      end
    else
      local error_msg = "Old controller settings file \"" .. tostring(l_26_1) .. "." .. tostring(l_26_0.CONTROLLER_SETTINGS_TYPE) .. "\" detected (version: \"" .. tostring(version) .. "\", core version: \"" .. tostring(core_version) .. "\", latest version: \"" .. tostring(l_26_0._last_version) .. "\", latest core version: \"" .. tostring(l_26_0._last_core_version) .. "\"."
      local load_default = nil
      if l_26_1 ~= l_26_0._default_settings_path then
        error_msg = error_msg .. " Loads the default path \"" .. tostring(l_26_0._default_settings_path) .. "." .. tostring(l_26_0.CONTROLLER_SETTINGS_TYPE) .. "\" instead."
      end
      Application:error(error_msg)
      if l_26_1 ~= l_26_0._default_settings_path then
        l_26_0:load_settings(l_26_0._default_settings_path)
      else
        Application:error("No controller settings file were found at path \"" .. tostring(l_26_1) .. "." .. tostring(l_26_0.CONTROLLER_SETTINGS_TYPE) .. "\".")
      end
    end
  end
  for wrapper_type,_ in pairs(l_26_0._supported_wrapper_types) do
    if not l_26_0._controller_setup[wrapper_type] then
      l_26_0._controller_setup[wrapper_type] = CoreControllerWrapperSettings.ControllerWrapperSettings:new(wrapper_type, nil, l_26_0._core_controller_setup[wrapper_type], nil)
    end
  end
  l_26_0:rebind_connections()
  for id,func in pairs(l_26_0._settings_file_changed_callback_list) do
    func(id)
  end
  return result
end

ControllerManager.save_settings = function(l_27_0, l_27_1)
  if not rawget(_G, "SystemFS") then
    Application:error("Unable to save controller settings. Not supported on this platform.")
  elseif l_27_0._last_version and l_27_1 then
    local file = SystemFS:open("./" .. tostring(l_27_1), "w")
    local data = {_meta = "controller_settings", core_version = l_27_0._last_core_version, version = l_27_0._last_version}
    for wrapper_type,setting in pairs(l_27_0._controller_setup) do
      setting:populate_data(data)
    end
    file:print(ScriptSerializer:to_custom_xml(data))
    SystemFS:close(file)
    l_27_0._settings_path = l_27_1
  else
    Application:error("Unable to save controller settings. No settings to save.")
  end
end

ControllerManager.rebind_connections = function(l_28_0)
  for _,controller_wrapper in pairs(l_28_0._controller_wrapper_list) do
    controller_wrapper:rebind_connections(l_28_0._controller_setup[controller_wrapper:get_type()], l_28_0._controller_setup)
  end
end

ControllerManager.get_settings_map = function(l_29_0)
  return l_29_0._controller_setup
end

ControllerManager.get_settings = function(l_30_0, l_30_1)
  return l_30_0._controller_setup[l_30_1]
end

ControllerManager.get_default_settings_path = function(l_31_0)
  return l_31_0._default_settings_path
end

ControllerManager.set_default_settings_path = function(l_32_0, l_32_1)
  l_32_0._default_settings_path = l_32_1
end

ControllerManager.get_settings_path = function(l_33_0)
  return l_33_0._default_settings_path
end

ControllerManager.set_settings_path = function(l_34_0, l_34_1)
  l_34_0._settings_path = l_34_1
end

ControllerManager.create_virtual_pad = function(l_35_0)
  if not l_35_0._virtual_game_pad then
    l_35_0._virtual_game_pad = Input:create_virtual_controller("all_gamepads")
  end
  l_35_0._virtual_game_pad:clear_connections()
  local game_pad_num = 0
  local step = 0
  local num = Input:num_real_controllers()
  repeat
    if step < num then
      local controller = Input:controller(step)
      if controller and controller:type() == "win32_game_controller" and controller:connected() then
        game_pad_num = game_pad_num + 1
        for i = 0, controller:num_buttons() - 1 do
          l_35_0._virtual_game_pad:connect(controller, controller:button_name(i), Idstring("gamepad" .. tostring(game_pad_num) .. "_B" .. tostring(i)))
        end
        for i = 0, controller:num_axes() - 1 do
          l_35_0._virtual_game_pad:connect(controller, controller:axis_name(i), Idstring("gamepad" .. tostring(game_pad_num) .. "_A" .. tostring(i)))
        end
      end
      step = step + 1
    do
      else
        local controller = Input:mouse()
        for i = 0, controller:num_buttons() - 1 do
          l_35_0._virtual_game_pad:connect(controller, controller:button_name(i), Idstring("mouse " .. tostring(i)))
        end
      end
       -- Warning: missing end command somewhere! Added here
    end
     -- Warning: missing end command somewhere! Added here
  end
end

ControllerManager.verify_parsed_controller_setup_map = function(l_36_0, l_36_1, l_36_2)
  local result = true
  local connection_map = {}
  do
    local last_wrapper_type = nil
    for wrapper_type,setup in pairs(l_36_1) do
      local current_connection_map = setup:get_connection_map()
      for connection_name in pairs(current_connection_map) do
        if not last_wrapper_type then
          connection_map[connection_name] = wrapper_type
          for (for control) in (for generator) do
          end
          if not connection_map[connection_name] then
            Application:error("Controller settings for \"" .. tostring(last_wrapper_type) .. "\" doesn't have a connection called \"" .. tostring(connection_name) .. "\" in \"" .. tostring(l_36_2) .. "." .. tostring(l_36_0.CONTROLLER_SETTINGS_TYPE) .. "\". It was last specified in \"" .. tostring(wrapper_type) .. "\".")
            connection_map[connection_name] = wrapper_type
            result = false
          end
        end
        if last_wrapper_type then
          for connection_name,found_wrapper_type in pairs(connection_map) do
            if not current_connection_map[connection_name] then
              Application:error("Controller settings for \"" .. tostring(wrapper_type) .. "\" doesn't have a connection called \"" .. tostring(connection_name) .. "\" in \"" .. tostring(l_36_2) .. "." .. tostring(l_36_0.CONTROLLER_SETTINGS_TYPE) .. "\". It was last specified in \"" .. tostring(found_wrapper_type) .. "\".")
              result = false
            end
          end
        end
        if not last_wrapper_type then
          last_wrapper_type = wrapper_type
        end
      end
      return result
    end
     -- Warning: missing end command somewhere! Added here
  end
end


