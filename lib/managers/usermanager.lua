-- Decompiled using luadec 2.0.1 by sztupy (http://winmo.sztupy.hu)
-- Command line was: F:\SteamLibrary\SteamApps\common\PAYDAY 2\lua\lib\managers\usermanager.luac 

core:module("UserManager")
core:import("CoreEvent")
core:import("CoreTable")
if not UserManager then
  UserManager = class()
end
UserManager.PLATFORM_CLASS_MAP = {}
UserManager.new = function(l_1_0, ...)
  do
    local platform = SystemInfo:platform()
    return l_1_0.PLATFORM_CLASS_MAP[platform:key()] or GenericUserManager:new(...)
  end
   -- DECOMPILER ERROR: Confused about usage of registers for local variables.

end

if not GenericUserManager then
  GenericUserManager = class()
end
GenericUserManager.STORE_SETTINGS_ON_PROFILE = false
GenericUserManager.CAN_SELECT_USER = false
GenericUserManager.CAN_SELECT_STORAGE = false
GenericUserManager.NOT_SIGNED_IN_STATE = nil
GenericUserManager.CAN_CHANGE_STORAGE_ONLY_ONCE = true
GenericUserManager.init = function(l_2_0)
  l_2_0._setting_changed_callback_handler_map = {}
  l_2_0._user_state_changed_callback_handler = CoreEvent.CallbackEventHandler:new()
  l_2_0._active_user_state_changed_callback_handler = CoreEvent.CallbackEventHandler:new()
  l_2_0._storage_changed_callback_handler = CoreEvent.CallbackEventHandler:new()
  if not l_2_0:is_global_initialized() then
    Global.user_manager = {setting_map = {}, setting_data_map = {}, setting_data_id_to_name_map = {}, user_map = {}, user_index = nil, active_user_state_change_quit = nil, initializing = true, storage_changed = nil}
    l_2_0:setup_setting_map()
    l_2_0:update_all_users()
    Global.user_manager.initializing = nil
  end
end

GenericUserManager.init_finalize = function(l_3_0)
end

GenericUserManager.is_global_initialized = function(l_4_0)
  if Global.user_manager then
    return not Global.user_manager.initializing
  end
end

local is_ps3 = SystemInfo:platform() == Idstring("PS3")
local is_x360 = SystemInfo:platform() == Idstring("X360")
GenericUserManager.setup_setting_map = function(l_5_0)
  l_5_0:setup_setting(1, "invert_camera_x", false)
  l_5_0:setup_setting(2, "invert_camera_y", false)
  l_5_0:setup_setting(3, "camera_sensitivity", 1)
  l_5_0:setup_setting(4, "rumble", true)
  l_5_0:setup_setting(5, "music_volume", 100)
  l_5_0:setup_setting(6, "sfx_volume", 100)
  l_5_0:setup_setting(7, "subtitle", true)
  l_5_0:setup_setting(8, "brightness", 1)
  l_5_0:setup_setting(9, "hold_to_steelsight", true)
  l_5_0:setup_setting(10, "hold_to_run", (not is_ps3 and not is_x360 and true))
  l_5_0:setup_setting(11, "voice_volume", 100)
  l_5_0:setup_setting(12, "controller_mod", {})
  l_5_0:setup_setting(13, "alienware_mask", true)
  l_5_0:setup_setting(14, "developer_mask", true)
  l_5_0:setup_setting(15, "voice_chat", true)
  l_5_0:setup_setting(16, "push_to_talk", true)
  l_5_0:setup_setting(17, "hold_to_duck", false)
  l_5_0:setup_setting(18, "video_color_grading", "color_off")
  l_5_0:setup_setting(19, "video_anti_alias", "AA")
  l_5_0:setup_setting(20, "video_animation_lod", 2)
  l_5_0:setup_setting(21, "video_streaks", true)
  l_5_0:setup_setting(22, "mask_set", "clowns")
  l_5_0:setup_setting(23, "use_lightfx", false)
  l_5_0:setup_setting(24, "fov_standard", 75)
  l_5_0:setup_setting(25, "fov_zoom", 75)
  l_5_0:setup_setting(26, "camera_zoom_sensitivity", 1)
  l_5_0:setup_setting(27, "enable_camera_zoom_sensitivity", false)
  l_5_0:setup_setting(28, "light_adaption", true)
  l_5_0:setup_setting(29, "menu_theme", "fire")
  l_5_0:setup_setting(30, "newest_theme", "fire")
  l_5_0:setup_setting(31, "hit_indicator", true)
  l_5_0:setup_setting(32, "aim_assist", true)
  l_5_0:setup_setting(33, "controller_mod_type", "pc")
  l_5_0:setup_setting(34, "objective_reminder", true)
  l_5_0:setup_setting(35, "effect_quality", _G.tweak_data.EFFECT_QUALITY)
  l_5_0:setup_setting(36, "fov_multiplier", 1)
  l_5_0:setup_setting(37, "southpaw", false)
  l_5_0:setup_setting(38, "dof_setting", "standard")
  l_5_0:setup_setting(39, "fps_cap", 135)
end

GenericUserManager.setup_setting = function(l_6_0, l_6_1, l_6_2, l_6_3)
  assert(not Global.user_manager.setting_data_map[l_6_2], "[UserManager] Setting name \"" .. tostring(l_6_2) .. "\" already exists.")
  assert(not Global.user_manager.setting_data_id_to_name_map[l_6_1], "[UserManager] Setting id \"" .. tostring(l_6_1) .. "\" already exists.")
  local setting_data = {id = l_6_1, default_value = l_6_0:get_clone_value(l_6_3)}
  Global.user_manager.setting_data_map[l_6_2] = setting_data
  Global.user_manager.setting_data_id_to_name_map[l_6_1] = l_6_2
  Global.user_manager.setting_map[l_6_1] = l_6_0:get_default_setting(l_6_2)
end

GenericUserManager.reset_setting_map = function(l_7_0)
  for name in pairs(Global.user_manager.setting_data_map) do
    l_7_0:set_setting(name, l_7_0:get_default_setting(name))
  end
end

GenericUserManager.get_clone_value = function(l_8_0, l_8_1)
  if type(l_8_1) == "table" then
    return CoreTable.deep_clone(l_8_1)
  else
    return l_8_1
  end
end

GenericUserManager.get_setting = function(l_9_0, l_9_1)
  local setting_data = Global.user_manager.setting_data_map[l_9_1]
  assert(setting_data, "[UserManager] Tried to get non-existing setting \"" .. tostring(l_9_1) .. "\".")
  return Global.user_manager.setting_map[setting_data.id]
end

GenericUserManager.get_default_setting = function(l_10_0, l_10_1)
  local setting_data = Global.user_manager.setting_data_map[l_10_1]
  assert(setting_data, "[UserManager] Tried to get non-existing default setting \"" .. tostring(l_10_1) .. "\".")
  return l_10_0:get_clone_value(setting_data.default_value)
end

GenericUserManager.set_setting = function(l_11_0, l_11_1, l_11_2, l_11_3)
  local setting_data = Global.user_manager.setting_data_map[l_11_1]
  if not setting_data then
    Application:error("[UserManager] Tried to set non-existing default setting \"" .. tostring(l_11_1) .. "\".")
    return 
  end
  local old_value = Global.user_manager.setting_map[setting_data.id]
  Global.user_manager.setting_map[setting_data.id] = l_11_2
  if l_11_0:has_setting_changed(old_value, l_11_2) or l_11_3 then
    managers.savefile:setting_changed()
    local callback_handler = l_11_0._setting_changed_callback_handler_map[l_11_1]
    if callback_handler then
      callback_handler:dispatch(l_11_1, old_value, l_11_2)
    end
  end
end

GenericUserManager.add_setting_changed_callback = function(l_12_0, l_12_1, l_12_2, l_12_3)
  assert(Global.user_manager.setting_data_map[l_12_1], "[UserManager] Tried to add setting changed callback for non-existing setting \"" .. tostring(l_12_1) .. "\".")
  if not l_12_0._setting_changed_callback_handler_map[l_12_1] then
    local callback_handler = CoreEvent.CallbackEventHandler:new()
  end
  l_12_0._setting_changed_callback_handler_map[l_12_1] = callback_handler
  callback_handler:add(l_12_2)
  if l_12_3 then
    local value = l_12_0:get_setting(l_12_1)
    local default_value = l_12_0:get_default_setting(l_12_1)
    if l_12_0:has_setting_changed(default_value, value) then
      l_12_2(l_12_1, default_value, value)
    end
  end
end

GenericUserManager.remove_setting_changed_callback = function(l_13_0, l_13_1, l_13_2)
  local callback_handler = l_13_0._setting_changed_callback_handler_map[l_13_1]
  assert(Global.user_manager.setting_data_map[name], "[UserManager] Tried to remove setting changed callback for non-existing setting \"" .. tostring(l_13_1) .. "\".")
  assert(callback_handler, "[UserManager] Tried to remove non-existing setting changed callback for setting \"" .. tostring(l_13_1) .. "\".")
  callback_handler:remove(l_13_2)
end

GenericUserManager.has_setting_changed = function(l_14_0, l_14_1, l_14_2)
  if type(l_14_1) == "table" and type(l_14_2) == "table" then
    for k,old_sub_value in pairs(l_14_1) do
      if l_14_0:has_setting_changed(l_14_2[k], old_sub_value) then
        return true
      end
    end
    for k,new_sub_value in pairs(l_14_2) do
      if l_14_0:has_setting_changed(new_sub_value, l_14_1[k]) then
        return true
      end
    end
    return false
  elseif l_14_1 == l_14_2 then
     -- DECOMPILER ERROR: Attempted to build a boolean expression without a pending context

    return error_maybe_false
  end
end

GenericUserManager.update_all_users = function(l_15_0)
end

GenericUserManager.update_user = function(l_16_0, l_16_1, l_16_2)
end

GenericUserManager.add_user_state_changed_callback = function(l_17_0, l_17_1)
  l_17_0._user_state_changed_callback_handler:add(l_17_1)
end

GenericUserManager.remove_user_state_changed_callback = function(l_18_0, l_18_1)
  l_18_0._user_state_changed_callback_handler:remove(l_18_1)
end

GenericUserManager.add_active_user_state_changed_callback = function(l_19_0, l_19_1)
  l_19_0._active_user_state_changed_callback_handler:add(l_19_1)
end

GenericUserManager.remove_active_user_state_changed_callback = function(l_20_0, l_20_1)
  l_20_0._active_user_state_changed_callback_handler:remove(l_20_1)
end

GenericUserManager.add_storage_changed_callback = function(l_21_0, l_21_1)
  l_21_0._storage_changed_callback_handler:add(l_21_1)
end

GenericUserManager.remove_storage_changed_callback = function(l_22_0, l_22_1)
  l_22_0._storage_changed_callback_handler:remove(l_22_1)
end

GenericUserManager.set_user_soft = function(l_23_0, l_23_1, l_23_2, l_23_3, l_23_4, l_23_5, l_23_6)
  local old_user_data = l_23_0:_get_user_data(l_23_1)
  local user_data = {user_index = l_23_1, platform_id = l_23_2, storage_id = l_23_3, username = l_23_4, signin_state = l_23_5}
  Global.user_manager.user_map[l_23_1] = user_data
end

GenericUserManager.set_user = function(l_24_0, l_24_1, l_24_2, l_24_3, l_24_4, l_24_5, l_24_6)
  local old_user_data = l_24_0:_get_user_data(l_24_1)
  local user_data = {user_index = l_24_1, platform_id = l_24_2, storage_id = l_24_3, username = l_24_4, signin_state = l_24_5}
  Global.user_manager.user_map[l_24_1] = user_data
  l_24_0:check_user_state_change(old_user_data, user_data, l_24_6)
end

GenericUserManager.check_user_state_change = function(l_25_0, l_25_1, l_25_2, l_25_3)
  if l_25_2 then
    local username = l_25_2.username
  end
  if not l_25_2 or not l_25_2.signin_state then
    local signin_state = l_25_0.NOT_SIGNED_IN_STATE
  end
  if not l_25_1 or not l_25_1.signin_state then
    local old_signin_state = l_25_0.NOT_SIGNED_IN_STATE
  end
  if l_25_1 then
    local old_username = l_25_1.username
  end
  if l_25_1 then
    local old_user_has_signed_out = l_25_1.has_signed_out
  end
  local user_changed, active_user_changed = nil, nil
  local was_signed_in = old_signin_state ~= l_25_0.NOT_SIGNED_IN_STATE
  local is_signed_in = signin_state ~= l_25_0.NOT_SIGNED_IN_STATE
  if was_signed_in == is_signed_in and ((not l_25_3 and old_username ~= username) or old_user_has_signed_out) then
    if (not l_25_2 or not l_25_2.user_index) and l_25_1 then
      local user_index = l_25_1.user_index
    end
    if user_index == l_25_0:get_index() then
      active_user_changed = true
    end
    if Global.category_print.user_manager then
      if active_user_changed then
        cat_print("user_manager", "[UserManager] Active user changed.")
      else
        cat_print("user_manager", "[UserManager] User index changed.")
      end
      cat_print("user_manager", "[UserManager] Old user: " .. l_25_0:get_user_data_string(l_25_1) .. ".")
      cat_print("user_manager", "[UserManager] New user: " .. l_25_0:get_user_data_string(l_25_2) .. ".")
    end
    user_changed = true
  end
  if user_changed then
    if active_user_changed then
      l_25_0:active_user_change_state(l_25_1, l_25_2)
    end
    l_25_0._user_state_changed_callback_handler:dispatch(l_25_1, l_25_2)
  end
  if l_25_2 then
    local storage_id = l_25_2.storage_id
  end
  if l_25_1 then
    local old_storage_id = l_25_1.storage_id
  end
  if l_25_0.CAN_CHANGE_STORAGE_ONLY_ONCE then
    local ignore_storage_change = Global.user_manager.storage_changed
  end
  if not ignore_storage_change and (active_user_changed or storage_id ~= old_storage_id) then
    l_25_0:storage_changed(l_25_1, l_25_2)
    Global.user_manager.storage_changed = true
  end
end

GenericUserManager.active_user_change_state = function(l_26_0, l_26_1, l_26_2)
  if l_26_0:get_active_user_state_change_quit() or is_x360 and managers.savefile:is_in_loading_sequence() then
    print("-- Cause loading", l_26_0:get_active_user_state_change_quit(), managers.savefile:is_in_loading_sequence())
    local dialog_data = {}
    dialog_data.title = managers.localization:text("dialog_signin_change_title")
    dialog_data.text = managers.localization:text("dialog_signin_change")
    dialog_data.id = "user_changed"
    local ok_button = {}
    ok_button.text = managers.localization:text("dialog_ok")
    dialog_data.button_list = {ok_button}
    managers.system_menu:add_init_show(dialog_data)
    l_26_0:perform_load_start_menu()
  end
  l_26_0._active_user_state_changed_callback_handler:dispatch(l_26_1, l_26_2)
end

GenericUserManager.perform_load_start_menu = function(l_27_0)
  managers.system_menu:force_close_all()
  managers.menu:on_user_sign_out()
  _G.setup:load_start_menu()
  _G.game_state_machine:set_boot_from_sign_out(true)
  l_27_0:set_active_user_state_change_quit(false)
end

GenericUserManager.storage_changed = function(l_28_0, l_28_1, l_28_2)
  managers.savefile:storage_changed()
  l_28_0._storage_changed_callback_handler:dispatch(l_28_1, l_28_2)
end

GenericUserManager.load_platform_setting_map = function(l_29_0, l_29_1)
  if l_29_1 then
    l_29_1(nil)
  end
end

GenericUserManager.get_user_string = function(l_30_0, l_30_1)
  local user_data = l_30_0:_get_user_data(l_30_1)
  return l_30_0:get_user_data_string(user_data)
end

GenericUserManager.get_user_data_string = function(l_31_0, l_31_1)
  if l_31_1 then
    local user_index = tostring(l_31_1.user_index)
    local signin_state = tostring(l_31_1.signin_state)
    local username = tostring(l_31_1.username)
    local platform_id = tostring(l_31_1.platform_id)
    local storage_id = tostring(l_31_1.storage_id)
    return string.format("User index: %s, Platform id: %s, Storage id: %s, Signin state: %s, Username: %s", user_index, platform_id, storage_id, signin_state, username)
  else
    return "nil"
  end
end

GenericUserManager.get_index = function(l_32_0)
  return Global.user_manager.user_index
end

GenericUserManager.set_index = function(l_33_0, l_33_1)
  if Global.user_manager.user_index ~= l_33_1 then
    local old_user_index = Global.user_manager.user_index
    cat_print("user_manager", "[UserManager] Changed user index from " .. tostring(old_user_index) .. " to " .. tostring(l_33_1) .. ".")
    Global.user_manager.user_index = l_33_1
    if old_user_index then
      local old_user_data = l_33_0:_get_user_data(old_user_index)
    end
    if not l_33_1 and old_user_data then
      old_user_data.storage_id = nil
    end
    if not l_33_1 then
      for _,data in pairs(Global.user_manager.user_map) do
        data.storage_id = nil
      end
    end
    local user_data = l_33_0:_get_user_data(l_33_1)
    l_33_0:check_user_state_change(old_user_data, user_data, false)
  end
end

GenericUserManager.get_active_user_state_change_quit = function(l_34_0)
  return Global.user_manager.active_user_state_change_quit
end

GenericUserManager.set_active_user_state_change_quit = function(l_35_0, l_35_1)
  if not Global.user_manager.active_user_state_change_quit ~= not l_35_1 then
    cat_print("user_manager", "[UserManager] User state change quits to title screen: " .. tostring(not not l_35_1))
    Global.user_manager.active_user_state_change_quit = l_35_1
  end
end

GenericUserManager.get_platform_id = function(l_36_0, l_36_1)
  local user_data = l_36_0:_get_user_data(l_36_1)
  if user_data then
    return user_data.platform_id
  end
end

GenericUserManager.is_signed_in = function(l_37_0, l_37_1)
  local user_data = l_37_0:_get_user_data(l_37_1)
  return not user_data or user_data.signin_state ~= l_37_0.NOT_SIGNED_IN_STATE
end

GenericUserManager.signed_in_state = function(l_38_0, l_38_1)
  local user_data = l_38_0:_get_user_data(l_38_1)
  if user_data then
    return user_data.signin_state
  end
end

GenericUserManager.get_storage_id = function(l_39_0, l_39_1)
  local user_data = l_39_0:_get_user_data(l_39_1)
  if user_data then
    return user_data.storage_id
  end
end

GenericUserManager.is_storage_selected = function(l_40_0, l_40_1)
  if l_40_0.CAN_SELECT_STORAGE then
    local user_data = l_40_0:_get_user_data(l_40_1)
    if user_data then
      return not not user_data.storage_id
  else
    end
    return true
  end
end

GenericUserManager._get_user_data = function(l_41_0, l_41_1)
  if not l_41_1 then
    local user_index = l_41_0:get_index()
  end
  if user_index then
    return Global.user_manager.user_map[user_index]
  end
end

GenericUserManager.check_user = function(l_42_0, l_42_1, l_42_2)
  if (not l_42_0.CAN_SELECT_USER or l_42_0:is_signed_in(nil)) and l_42_1 then
    l_42_1(true)
    do return end
    local confirm_callback = callback(l_42_0, l_42_0, "confirm_select_user_callback", l_42_1)
    if l_42_2 then
      l_42_0._active_check_user_callback_func = l_42_1
      local dialog_data = {}
      dialog_data.id = "show_select_user_question_dialog"
      dialog_data.title = managers.localization:text("dialog_signin_title")
      dialog_data.text = managers.localization:text("dialog_signin_question")
      dialog_data.focus_button = 1
      local yes_button = {}
      yes_button.text = managers.localization:text("dialog_yes")
      yes_button.callback_func = callback(l_42_0, l_42_0, "_success_callback", confirm_callback)
      local no_button = {}
      no_button.text = managers.localization:text("dialog_no")
      no_button.callback_func = callback(l_42_0, l_42_0, "_fail_callback", confirm_callback)
      dialog_data.button_list = {yes_button, no_button}
      managers.system_menu:show(dialog_data)
    else
      confirm_callback(true)
    end
  end
end

GenericUserManager._success_callback = function(l_43_0, l_43_1)
  if l_43_1 then
    l_43_1(true)
  end
end

GenericUserManager._fail_callback = function(l_44_0, l_44_1)
  if l_44_1 then
    l_44_1(false)
  end
end

GenericUserManager.confirm_select_user_callback = function(l_45_0, l_45_1, l_45_2)
  l_45_0._active_check_user_callback_func = nil
  if l_45_2 then
    managers.system_menu:show_select_user({count = 1, callback_func = callback(l_45_0, l_45_0, "select_user_callback", l_45_1)})
  elseif l_45_1 then
    l_45_1(false)
  end
end

GenericUserManager.select_user_callback = function(l_46_0, l_46_1)
  l_46_0:update_all_users()
  if l_46_1 then
    l_46_0._active_check_user_callback_func = nil
    l_46_1(l_46_0:is_signed_in(nil))
  end
end

GenericUserManager.check_storage = function(l_47_0, l_47_1, l_47_2)
  if (not l_47_0.CAN_SELECT_STORAGE or l_47_0:get_storage_id(nil)) and l_47_1 then
    l_47_1(true)
    do return end
    local wrapped_callback_func = function(l_1_0, l_1_1, ...)
      if l_1_0 then
        self:update_all_users()
      end
      if callback_func then
        callback_func(l_1_0, l_1_1, ...)
         -- DECOMPILER ERROR: Confused about usage of registers for local variables.

      end
      end
    managers.system_menu:show_select_storage({min_bytes = managers.savefile.RESERVED_BYTES, count = 1, callback_func = wrapped_callback_func, auto_select = l_47_2})
  end
end

GenericUserManager.get_setting_map = function(l_48_0)
  return CoreTable.deep_clone(Global.user_manager.setting_map)
end

GenericUserManager.set_setting_map = function(l_49_0, l_49_1)
  for id,value in pairs(l_49_1) do
    local name = Global.user_manager.setting_data_id_to_name_map[id]
    l_49_0:set_setting(name, value)
  end
end

GenericUserManager.save_setting_map = function(l_50_0, l_50_1, l_50_2)
  if l_50_2 then
    Appliction:error("[UserManager] Setting map cannot be saved on this platform.")
    l_50_2(false)
  end
end

GenericUserManager.save = function(l_51_0, l_51_1)
  local state = l_51_0:get_setting_map()
  l_51_1.UserManager = state
  if Global.DEBUG_MENU_ON then
    l_51_1.debug_post_effects_enabled = Global.debug_post_effects_enabled
  end
end

GenericUserManager.load = function(l_52_0, l_52_1, l_52_2)
  if l_52_2 == 0 then
    l_52_0:set_setting_map(l_52_1)
  else
    l_52_0:set_setting_map(l_52_1.UserManager)
  end
  if SystemInfo:platform() ~= Idstring("PS3") then
    local NEWEST_THEME = "zombie"
    if l_52_0:get_setting("newest_theme") ~= NEWEST_THEME then
      l_52_0:set_setting("newest_theme", NEWEST_THEME)
      l_52_0:set_setting("menu_theme", NEWEST_THEME)
    end
  end
  if l_52_1.debug_post_effects_enabled == false then
    Global.debug_post_effects_enabled = not Global.DEBUG_MENU_ON
    do return end
    Global.debug_post_effects_enabled = true
     -- Warning: missing end command somewhere! Added here
  end
end

if not Xbox360UserManager then
  Xbox360UserManager = class(GenericUserManager)
end
Xbox360UserManager.NOT_SIGNED_IN_STATE = "not_signed_in"
Xbox360UserManager.STORE_SETTINGS_ON_PROFILE = true
Xbox360UserManager.CAN_SELECT_USER = true
Xbox360UserManager.CAN_SELECT_STORAGE = true
Xbox360UserManager.CUSTOM_PROFILE_VARIABLE_COUNT = 3
Xbox360UserManager.CUSTOM_PROFILE_VARIABLE_CHAR_COUNT = 999
Xbox360UserManager.CAN_CHANGE_STORAGE_ONLY_ONCE = false
UserManager.PLATFORM_CLASS_MAP[Idstring("X360"):key()] = Xbox360UserManager
Xbox360UserManager.init = function(l_53_0)
  l_53_0._platform_setting_conversion_func_map = {gamer_control_sensitivity = callback(l_53_0, l_53_0, "convert_gamer_control_sensitivity")}
  GenericUserManager.init(l_53_0)
  managers.platform:add_event_callback("signin_changed", callback(l_53_0, l_53_0, "signin_changed_callback"))
  managers.platform:add_event_callback("profile_setting_changed", callback(l_53_0, l_53_0, "profile_setting_changed_callback"))
  managers.platform:add_event_callback("storage_devices_changed", callback(l_53_0, l_53_0, "storage_devices_changed_callback"))
  managers.platform:add_event_callback("disconnect", callback(l_53_0, l_53_0, "disconnect_callback"))
  managers.platform:add_event_callback("connect", callback(l_53_0, l_53_0, "connect_callback"))
  l_53_0._setting_map_save_counter = 0
end

Xbox360UserManager.disconnect_callback = function(l_54_0, l_54_1)
  print("  Xbox360UserManager:disconnect_callback", l_54_1, XboxLive:signin_state(0))
  if Global.game_settings.single_player then
    return 
  end
  if managers.network:session() and managers.network:session():_local_peer_in_lobby() then
    managers.menu:xbox_disconnected()
  elseif l_54_0._in_online_menu then
    print("leave crimenet")
    managers.menu:xbox_disconnected()
  else
    if managers.network:game() then
      managers.network:game():xbox_disconnected()
    end
  end
end

Xbox360UserManager.connect_callback = function(l_55_0)
end

Xbox360UserManager.on_entered_online_menus = function(l_56_0)
  l_56_0._in_online_menu = true
end

Xbox360UserManager.on_exit_online_menus = function(l_57_0)
  l_57_0._in_online_menu = false
end

Xbox360UserManager.setup_setting_map = function(l_58_0)
  local platform_default_type_map = {}
  platform_default_type_map.invert_camera_y = "gamer_yaxis_inversion"
  platform_default_type_map.camera_sensitivity = "gamer_control_sensitivity"
  Global.user_manager.platform_setting_map = nil
  Global.user_manager.platform_default_type_map = platform_default_type_map
  GenericUserManager.setup_setting_map(l_58_0)
end

Xbox360UserManager.convert_gamer_control_sensitivity = function(l_59_0, l_59_1)
  if l_59_1 == "low" then
    return 0.5
  elseif l_59_1 == "medium" then
    return 1
  else
    return 1.5
  end
end

Xbox360UserManager.get_default_setting = function(l_60_0, l_60_1)
  if Global.user_manager.platform_setting_map then
    local platform_default_type = Global.user_manager.platform_default_type_map[l_60_1]
    if platform_default_type then
      local platform_default = Global.user_manager.platform_setting_map[platform_default_type]
      local conversion_func = l_60_0._platform_setting_conversion_func_map[platform_default_type]
      if conversion_func then
        return conversion_func(platform_default)
      else
        return platform_default
      end
    end
  end
  return GenericUserManager.get_default_setting(l_60_0, l_60_1)
end

Xbox360UserManager.active_user_change_state = function(l_61_0, l_61_1, l_61_2)
  Global.user_manager.platform_setting_map = nil
  managers.savefile:active_user_changed()
  GenericUserManager.active_user_change_state(l_61_0, l_61_1, l_61_2)
end

Xbox360UserManager.load_platform_setting_map = function(l_62_0, l_62_1)
  cat_print("user_manager", "[UserManager] Loading platform setting map.")
  XboxLive:read_profile_settings(l_62_0:get_platform_id(nil), callback(l_62_0, l_62_0, "_load_platform_setting_map_callback", l_62_1))
end

Xbox360UserManager._load_platform_setting_map_callback = function(l_63_0, l_63_1, l_63_2)
  cat_print("user_manager", "[UserManager] Done loading platform setting map. Success: " .. tostring(not not l_63_2))
  Global.user_manager.platform_setting_map = l_63_2
  l_63_0:reset_setting_map()
  if l_63_1 then
    l_63_1(l_63_2)
  end
end

Xbox360UserManager.save_platform_setting = function(l_64_0, l_64_1, l_64_2, l_64_3)
  cat_print("user_manager", "[UserManager] Saving platform setting \"" .. tostring(l_64_1) .. "\": " .. tostring(l_64_2))
  XboxLive:write_profile_setting(l_64_0:get_platform_id(nil), l_64_1, l_64_2, callback(l_64_0, l_64_0, "_save_platform_setting_callback", l_64_3))
end

Xbox360UserManager._save_platform_setting_callback = function(l_65_0, l_65_1, l_65_2)
  cat_print("user_manager", "[UserManager] Done saving platform setting \"" .. tostring("Dont get setting name in callback") .. "\". Success: " .. tostring(l_65_2))
  if l_65_1 then
    l_65_1(l_65_2)
  end
end

Xbox360UserManager.get_setting_map = function(l_66_0)
  local platform_setting_map = Global.user_manager.platform_setting_map
  local setting_map = nil
  if platform_setting_map then
    local packed_string_value = ""
    for i = 1, l_66_0.CUSTOM_PROFILE_VARIABLE_COUNT do
      local setting_name = "title_specific" .. i
      packed_string_value = packed_string_value .. (platform_setting_map[setting_name] or "")
    end
    if not Utility:unpack(packed_string_value) then
      setting_map = {}
    end
  end
  return setting_map
end

Xbox360UserManager.save_setting_map = function(l_67_0, l_67_1)
  if l_67_0._setting_map_save_counter > 0 then
    Appliction:error("[UserManager] Tried to set setting map again before it was done with previous set.")
    if l_67_1 then
      l_67_1(false)
      return 
    end
  end
  local complete_setting_value = Utility:pack(Global.user_manager.setting_map)
  local current_char = 1
  local char_count = #complete_setting_value
  local setting_count = 1
  local max_char_count = l_67_0.CUSTOM_PROFILE_VARIABLE_COUNT * l_67_0.CUSTOM_PROFILE_VARIABLE_CHAR_COUNT
  if max_char_count < char_count then
    Application:stack_dump_error("[UserManager] Exceeded (" .. char_count .. ") maximum character count that can be stored in the profile (" .. max_char_count .. ").")
    l_67_1(false)
    return 
  end
  l_67_0._setting_map_save_success = true
  repeat
    local setting_name = "title_specific" .. setting_count
    local end_char = math.min(current_char + l_67_0.CUSTOM_PROFILE_VARIABLE_CHAR_COUNT - 1, char_count)
    local setting_value = string.sub(complete_setting_value, current_char, end_char)
    cat_print("save_manager", "[UserManager] Saving profile setting \"" .. setting_name .. "\" (" .. current_char .. " to " .. end_char .. " of " .. char_count .. " characters).")
    Global.user_manager.platform_setting_map[setting_name] = setting_value
    l_67_0._setting_map_save_counter = l_67_0._setting_map_save_counter + 1
    l_67_0:save_platform_setting(setting_name, setting_value, callback(l_67_0, l_67_0, "_save_setting_map_callback", l_67_1))
    current_char = end_char + 1
    setting_count = setting_count + 1
  until char_count <= current_char
end

Xbox360UserManager._save_setting_map_callback = function(l_68_0, l_68_1, l_68_2)
  l_68_0._setting_map_save_success = not l_68_0._setting_map_save_success or l_68_2
  l_68_0._setting_map_save_counter = l_68_0._setting_map_save_counter - 1
  if l_68_1 and l_68_0._setting_map_save_counter == 0 then
    l_68_1(l_68_0._setting_map_save_success)
  end
end

Xbox360UserManager.signin_changed_callback = function(l_69_0, ...)
  for user_index,signed_in in ipairs({...}) do
    local was_signed_in = l_69_0:is_signed_in(user_index)
    if was_signed_in then
      Global.user_manager.user_map[user_index].has_signed_out = not signed_in
    end
    if Global.user_manager.user_index == user_index and not was_signed_in and signed_in and l_69_0._active_check_user_callback_func then
      print("RUN ACTIVE USER CALLBACK FUNC")
      managers.system_menu:close("show_select_user_question_dialog")
      l_69_0._active_check_user_callback_func(true)
      l_69_0._active_check_user_callback_func = nil
    end
    if not signed_in ~= not was_signed_in then
      l_69_0:update_user(user_index, false)
      for (for control),user_index in (for generator) do
      end
      local platform_id = user_index - 1
      local signin_state = XboxLive:signin_state(platform_id)
      local old_signin_state = Global.user_manager.user_map[user_index].signin_state
      if old_signin_state ~= signin_state then
        Global.user_manager.user_map[user_index].signin_state = signin_state
      end
    end
     -- DECOMPILER ERROR: Confused about usage of registers for local variables.

     -- Warning: missing end command somewhere! Added here
  end
end

Xbox360UserManager.profile_setting_changed_callback = function(l_70_0, ...)
   -- DECOMPILER ERROR: Confused about usage of registers for local variables.

end

Xbox360UserManager.update_all_users = function(l_71_0)
  for user_index = 1, 4 do
    l_71_0:update_user(user_index, false)
  end
end

Xbox360UserManager.update_user = function(l_72_0, l_72_1, l_72_2)
  local platform_id = l_72_1 - 1
  local signin_state = XboxLive:signin_state(platform_id)
  local is_signed_in = signin_state ~= l_72_0.NOT_SIGNED_IN_STATE
  local storage_id, username = nil, nil
  if is_signed_in then
    username = XboxLive:name(platform_id)
    storage_id = Application:current_storage_device_id(platform_id)
    if storage_id == 0 then
      storage_id = nil
    end
  end
  l_72_0:set_user(l_72_1, platform_id, storage_id, username, signin_state, l_72_2)
end

Xbox360UserManager.storage_devices_changed_callback = function(l_73_0)
  l_73_0:update_all_users()
end

Xbox360UserManager.check_privilege = function(l_74_0, l_74_1, l_74_2)
  local platform_id = l_74_0:get_platform_id(l_74_1)
  return XboxLive:check_privilege(platform_id, l_74_2)
end

Xbox360UserManager.get_xuid = function(l_75_0, l_75_1)
  local platform_id = l_75_0:get_platform_id(l_75_1)
  return XboxLive:xuid(platform_id)
end

Xbox360UserManager.invite_accepted_by_inactive_user = function(l_76_0)
  managers.platform:set_rich_presence("Idle")
  l_76_0:perform_load_start_menu()
  managers.menu:reset_all_loaded_data()
end

if not PS3UserManager then
  PS3UserManager = class(GenericUserManager)
end
UserManager.PLATFORM_CLASS_MAP[Idstring("PS3"):key()] = PS3UserManager
PS3UserManager.init = function(l_77_0)
  l_77_0._init_finalize_index = not l_77_0:is_global_initialized()
  GenericUserManager.init(l_77_0)
end

PS3UserManager.init_finalize = function(l_78_0)
  if l_78_0._init_finalize_index then
    l_78_0:set_user(1, nil, true, nil, true, false)
    l_78_0._init_finalize_index = nil
  end
end

PS3UserManager.set_index = function(l_79_0, l_79_1)
  if l_79_1 then
    l_79_0:set_user_soft(l_79_1, nil, true, nil, true, false)
  end
  GenericUserManager.set_index(l_79_0, l_79_1)
end

if not WinUserManager then
  WinUserManager = class(GenericUserManager)
end
UserManager.PLATFORM_CLASS_MAP[Idstring("WIN32"):key()] = WinUserManager
WinUserManager.init = function(l_80_0)
  l_80_0._init_finalize_index = not l_80_0:is_global_initialized()
  GenericUserManager.init(l_80_0)
end

WinUserManager.init_finalize = function(l_81_0)
  if l_81_0._init_finalize_index then
    l_81_0:set_user(1, nil, true, nil, true, false)
    l_81_0._init_finalize_index = nil
  end
end

WinUserManager.set_index = function(l_82_0, l_82_1)
  if l_82_1 then
    l_82_0:set_user_soft(l_82_1, nil, true, nil, true, false)
  end
  GenericUserManager.set_index(l_82_0, l_82_1)
end


