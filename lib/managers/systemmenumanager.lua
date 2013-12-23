-- Decompiled using luadec 2.0.1 by sztupy (http://winmo.sztupy.hu)
-- Command line was: F:\SteamLibrary\SteamApps\common\PAYDAY 2\lua\lib\managers\systemmenumanager.luac 

core:module("SystemMenuManager")
core:import("CoreEvent")
core:import("CoreClass")
require("lib/managers/dialogs/GenericDialog")
require("lib/managers/dialogs/Xbox360Dialog")
require("lib/managers/dialogs/PS3Dialog")
require("lib/managers/dialogs/Xbox360SelectStorageDialog")
require("lib/managers/dialogs/PS3DeleteFileDialog")
require("lib/managers/dialogs/Xbox360KeyboardInputDialog")
require("lib/managers/dialogs/PS3KeyboardInputDialog")
require("lib/managers/dialogs/Xbox360SelectUserDialog")
require("lib/managers/dialogs/Xbox360AchievementsDialog")
require("lib/managers/dialogs/Xbox360FriendsDialog")
require("lib/managers/dialogs/Xbox360PlayerReviewDialog")
require("lib/managers/dialogs/Xbox360PlayerDialog")
require("lib/managers/dialogs/Xbox360MarketplaceDialog")
require("lib/managers/dialogs/NewUnlockDialog")
if not SystemMenuManager then
  SystemMenuManager = class()
end
SystemMenuManager.PLATFORM_CLASS_MAP = {}
SystemMenuManager.new = function(l_1_0, ...)
  do
    local platform = SystemInfo:platform()
    return l_1_0.PLATFORM_CLASS_MAP[platform:key()] or GenericSystemMenuManager:new(...)
  end
   -- DECOMPILER ERROR: Confused about usage of registers for local variables.

end

if not GenericSystemMenuManager then
  GenericSystemMenuManager = class()
end
GenericSystemMenuManager.DIALOG_CLASS = GenericDialog
GenericSystemMenuManager.GENERIC_DIALOG_CLASS = GenericDialog
GenericSystemMenuManager.PLATFORM_DIALOG_CLASS = GenericDialog
GenericSystemMenuManager.NEW_UNLOCK_CLASS = NewUnlockDialog
GenericSystemMenuManager.GENERIC_NEW_UNLOCK_CLASS = NewUnlockDialog
GenericSystemMenuManager.init = function(l_2_0)
  if not Global.dialog_manager then
    Global.dialog_manager = {init_show_data_list = nil}
  end
  l_2_0._dialog_shown_callback_handler = CoreEvent.CallbackEventHandler:new()
  l_2_0._dialog_hidden_callback_handler = CoreEvent.CallbackEventHandler:new()
  l_2_0._dialog_closed_callback_handler = CoreEvent.CallbackEventHandler:new()
  l_2_0._active_changed_callback_handler = CoreEvent.CallbackEventHandler:new()
  l_2_0._controller = managers.controller:create_controller("dialog", nil, false)
  managers.controller:add_default_wrapper_index_change_callback(callback(l_2_0, l_2_0, "changed_controller_index"))
  l_2_0._resolution_changed_callback_id = managers.viewport:add_resolution_changed_func(callback(l_2_0, l_2_0, "resolution_changed"))
end

GenericSystemMenuManager.init_finalize = function(l_3_0)
  local gui = Overlay:gui()
  l_3_0._ws = Overlay:gui():create_screen_workspace()
  managers.gui_data:layout_fullscreen_workspace(l_3_0._ws)
  l_3_0._ws:hide()
  if Global.dialog_manager.init_show_data_list then
    local init_show_data_list = Global.dialog_manager.init_show_data_list
    Global.dialog_manager.init_show_data_list = nil
    for index,data in ipairs(init_show_data_list) do
      cat_print("dialog_manager", "[SystemMenuManager] Processing init dialog. Index: " .. tostring(index) .. "/" .. tostring(#init_show_data_list))
      l_3_0:show(data)
    end
  end
end

GenericSystemMenuManager.resolution_changed = function(l_4_0)
  managers.gui_data:layout_fullscreen_workspace(l_4_0._ws)
end

GenericSystemMenuManager.add_init_show = function(l_5_0, l_5_1)
  local init_show_data_list = Global.dialog_manager.init_show_data_list
  local priority = l_5_1.priority or 0
  cat_print("dialog_manager", "[SystemMenuManager] Adding an init dialog with priority \"" .. tostring(priority) .. "\".")
  if init_show_data_list then
    for index = #init_show_data_list, 1, -1 do
      local next_data = init_show_data_list[index]
      local next_priority = next_data.priority or 0
      if priority < next_priority then
        cat_print("dialog_manager", "[SystemMenuManager] Ignoring request to show init dialog since it had lower priority than the existing priority \"" .. tostring(next_priority) .. "\". Index: " .. tostring(index) .. "/" .. tostring(#init_show_data_list))
        return false
      elseif next_priority < priority then
        cat_print("dialog_manager", "[SystemMenuManager] Removed an already added init dialog with the lower priority of \"" .. tostring(next_priority) .. "\". Index: " .. tostring(index) .. "/" .. tostring(#init_show_data_list))
        table.remove(init_show_data_list, index)
      end
    end
  else
    init_show_data_list = {}
  end
  table.insert(init_show_data_list, l_5_1)
  Global.dialog_manager.init_show_data_list = init_show_data_list
end

GenericSystemMenuManager.destroy = function(l_6_0)
  if alive(l_6_0._ws) then
    Overlay:gui():destroy_workspace(l_6_0._ws)
    l_6_0._ws = nil
  end
  if l_6_0._controller then
    l_6_0._controller:destroy()
    l_6_0._controller = nil
  end
end

GenericSystemMenuManager.changed_controller_index = function(l_7_0, l_7_1)
  local was_enabled = l_7_0._controller:enabled()
  l_7_0._controller:destroy()
  l_7_0._controller = managers.controller:create_controller("dialog", nil, false)
  l_7_0._controller:set_enabled(was_enabled)
end

GenericSystemMenuManager.update = function(l_8_0, l_8_1, l_8_2)
  if l_8_0._active_dialog and l_8_0._active_dialog.update then
    l_8_0._active_dialog:update(l_8_1, l_8_2)
  end
  l_8_0:update_queue()
  l_8_0:check_active_state()
end

GenericSystemMenuManager.paused_update = function(l_9_0, l_9_1, l_9_2)
  l_9_0:update(l_9_1, l_9_2)
end

GenericSystemMenuManager.update_queue = function(l_10_0)
  if not l_10_0:is_active(true) and l_10_0._dialog_queue then
    local dialog, index = nil, nil
    for next_index,next_dialog in ipairs(l_10_0._dialog_queue) do
      if not dialog or dialog:priority() < next_dialog:priority() then
        index = next_index
        dialog = next_dialog
      end
    end
    table.remove(l_10_0._dialog_queue, index)
    if not next(l_10_0._dialog_queue) then
      l_10_0._dialog_queue = nil
    end
    if dialog then
      l_10_0:_show_instance(dialog, true)
    end
  end
end

GenericSystemMenuManager.check_active_state = function(l_11_0)
  local active = l_11_0:is_active(true)
  if not l_11_0._old_active_state ~= not active then
    l_11_0:event_active_changed(active)
    l_11_0._old_active_state = active
  end
end

GenericSystemMenuManager.block_exec = function(l_12_0)
  return l_12_0:is_active()
end

GenericSystemMenuManager.is_active = function(l_13_0)
  return l_13_0._active_dialog ~= nil
end

GenericSystemMenuManager.is_closing = function(l_14_0)
  return l_14_0._active_dialog and l_14_0._active_dialog:is_closing() or false
end

GenericSystemMenuManager.force_close_all = function(l_15_0)
  if l_15_0._active_dialog and l_15_0._active_dialog:blocks_exec() then
    l_15_0._active_dialog:fade_out_close()
  end
  l_15_0._dialog_queue = nil
end

GenericSystemMenuManager.get_dialog = function(l_16_0, l_16_1)
  if not l_16_1 then
    return 
  end
  if l_16_0._active_dialog and l_16_0._active_dialog:id() == l_16_1 then
    return l_16_0._active_dialog
  end
end

GenericSystemMenuManager.close = function(l_17_0, l_17_1)
  if not l_17_1 then
    return 
  end
  if l_17_0._active_dialog then
    print("close active dialog", l_17_0._active_dialog:id(), l_17_1)
  end
  if l_17_0._active_dialog and l_17_0._active_dialog:id() == l_17_1 then
    l_17_0._active_dialog:fade_out_close()
    return 
  end
  if not l_17_0._dialog_queue then
    return 
  end
  for i,dialog in ipairs(l_17_0._dialog_queue) do
    if dialog:id() == l_17_1 then
      print("remove from queue", l_17_1)
      table.remove(l_17_0._dialog_queue, i)
    end
  end
end

GenericSystemMenuManager.is_active_by_id = function(l_18_0, l_18_1)
  if not l_18_0._active_dialog or not l_18_1 then
    return false
  end
  if l_18_0._active_dialog:id() == l_18_1 then
    return true, l_18_0._active_dialog
  end
  if not l_18_0._dialog_queue then
    return false
  end
  for i,dialog in ipairs(l_18_0._dialog_queue) do
    if dialog:id() == l_18_1 then
      return true, dialog
    end
  end
  return false
end

GenericSystemMenuManager._show_result = function(l_19_0, l_19_1, l_19_2)
  if not l_19_2.focus_button then
    local default_button_index = l_19_1 or not l_19_2 or 1
  end
  local button_list = l_19_2.button_list
  if l_19_2.button_list then
    local button_data = l_19_2.button_list[default_button_index]
    if button_data then
      local callback_func = button_data.callback_func
      if callback_func then
        callback_func(default_button_index, button_data)
      end
    end
  end
  if l_19_2.callback_func then
    l_19_2.callback_func(default_button_index, l_19_2)
  end
end

GenericSystemMenuManager.show = function(l_20_0, l_20_1)
  local success = l_20_0:_show_class(l_20_1, l_20_0.GENERIC_DIALOG_CLASS, l_20_0.DIALOG_CLASS, l_20_1.force)
  l_20_0:_show_result(success, l_20_1)
end

GenericSystemMenuManager.show_platform = function(l_21_0, l_21_1)
  local success = l_21_0:_show_class(l_21_1, l_21_0.GENERIC_DIALOG_CLASS, l_21_0.PLATFORM_DIALOG_CLASS, l_21_1.force)
  l_21_0:_show_result(success, l_21_1)
end

GenericSystemMenuManager.show_select_storage = function(l_22_0, l_22_1)
  l_22_0:_show_class(l_22_1, l_22_0.GENERIC_SELECT_STORAGE_DIALOG_CLASS, l_22_0.SELECT_STORAGE_DIALOG_CLASS, false)
end

GenericSystemMenuManager.show_delete_file = function(l_23_0, l_23_1)
  l_23_0:_show_class(l_23_1, l_23_0.GENERIC_DELETE_FILE_DIALOG_CLASS, l_23_0.DELETE_FILE_DIALOG_CLASS, false)
end

GenericSystemMenuManager.show_keyboard_input = function(l_24_0, l_24_1)
  l_24_0:_show_class(l_24_1, l_24_0.GENERIC_KEYBOARD_INPUT_DIALOG, l_24_0.KEYBOARD_INPUT_DIALOG, false)
end

GenericSystemMenuManager.show_select_user = function(l_25_0, l_25_1)
  l_25_0:_show_class(l_25_1, l_25_0.GENERIC_SELECT_USER_DIALOG, l_25_0.SELECT_USER_DIALOG, false)
end

GenericSystemMenuManager.show_achievements = function(l_26_0, l_26_1)
  l_26_0:_show_class(l_26_1, l_26_0.GENERIC_ACHIEVEMENTS_DIALOG, l_26_0.ACHIEVEMENTS_DIALOG, false)
end

GenericSystemMenuManager.show_friends = function(l_27_0, l_27_1)
  l_27_0:_show_class(l_27_1, l_27_0.GENERIC_FRIENDS_DIALOG, l_27_0.FRIENDS_DIALOG, false)
end

GenericSystemMenuManager.show_player_review = function(l_28_0, l_28_1)
  l_28_0:_show_class(l_28_1, l_28_0.GENERIC_PLAYER_REVIEW_DIALOG, l_28_0.PLAYER_REVIEW_DIALOG, false)
end

GenericSystemMenuManager.show_player = function(l_29_0, l_29_1)
  l_29_0:_show_class(l_29_1, l_29_0.GENERIC_PLAYER_DIALOG, l_29_0.PLAYER_DIALOG, false)
end

GenericSystemMenuManager.show_marketplace = function(l_30_0, l_30_1)
  l_30_0:_show_class(l_30_1, l_30_0.GENERIC_MARKETPLACE_DIALOG, l_30_0.MARKETPLACE_DIALOG, false)
end

GenericSystemMenuManager.show_new_unlock = function(l_31_0, l_31_1)
  local success = l_31_0:_show_class(l_31_1, l_31_0.GENERIC_NEW_UNLOCK_CLASS, l_31_0.NEW_UNLOCK_CLASS, l_31_1.force)
  l_31_0:_show_result(success, l_31_1)
end

GenericSystemMenuManager._show_class = function(l_32_0, l_32_1, l_32_2, l_32_3, l_32_4)
  local dialog_class = l_32_1 and l_32_1.is_generic and l_32_2 or l_32_3
  if dialog_class then
    local dialog = dialog_class:new(l_32_0, l_32_1)
    l_32_0:_show_instance(dialog, l_32_4)
    return true
  elseif l_32_1 then
    local callback_func = l_32_1.callback_func
    if callback_func then
      callback_func()
    end
  end
  return false
end

GenericSystemMenuManager._show_instance = function(l_33_0, l_33_1, l_33_2)
  local is_active = l_33_0:is_active(true)
  if is_active and l_33_2 then
    l_33_0:hide_active_dialog()
  end
  local queue = true
  if not is_active then
    queue = not l_33_1:show()
  end
  l_33_0:queue_dialog(l_33_1, not queue or (l_33_2 and 1) or nil)
end

GenericSystemMenuManager.hide_active_dialog = function(l_34_0)
  if l_34_0._active_dialog and not l_34_0._active_dialog:is_closing() and l_34_0._active_dialog.hide then
    l_34_0:queue_dialog(l_34_0._active_dialog, 1)
    l_34_0._active_dialog:hide()
  end
end

GenericSystemMenuManager.queue_dialog = function(l_35_0, l_35_1, l_35_2)
  if Global.category_print.dialog_manager then
     -- DECOMPILER ERROR: Confused while interpreting a jump as a 'while'

  end
  cat_print("dialog_manager", "[SystemMenuManager] [Queue dialog (index: " .. tostring(l_35_2) .. "/" .. tostring(#l_35_0._dialog_queue) .. ")] " .. tostring(l_35_1:to_string()))
end
if not l_35_0._dialog_queue then
  l_35_0._dialog_queue = {}
end
if l_35_2 then
  table.insert(l_35_0._dialog_queue, l_35_2, l_35_1)
else
  table.insert(l_35_0._dialog_queue, l_35_1)
end
end

GenericSystemMenuManager.set_active_dialog = function(l_36_0, l_36_1)
  l_36_0._active_dialog = l_36_1
  local is_ws_visible = not l_36_1 or not l_36_1._get_ws or l_36_1:_get_ws() == l_36_0._ws
  if not l_36_0._is_ws_visible ~= not is_ws_visible then
    if is_ws_visible then
      l_36_0._ws:show()
    else
      l_36_0._ws:hide()
      l_36_0._is_ws_visible = is_ws_visible
    end
    local is_controller_enabled = not l_36_1 or l_36_1:_get_controller() == l_36_0._controller
    if not l_36_0._controller:enabled() ~= not is_controller_enabled then
      l_36_0._controller:set_enabled(is_controller_enabled)
    end
     -- Warning: missing end command somewhere! Added here
  end
end

GenericSystemMenuManager._is_engine_delaying_signin_change = function(l_37_0)
  if l_37_0._is_engine_delaying_signin_change_delay then
    l_37_0._is_engine_delaying_signin_change_delay = l_37_0._is_engine_delaying_signin_change_delay - TimerManager:main():delta_time()
    if l_37_0._is_engine_delaying_signin_change_delay <= 0 then
      l_37_0._is_engine_delaying_signin_change_delay = nil
      return false
    else
      l_37_0._is_engine_delaying_signin_change_delay = 1.2000000476837
    end
  end
  return true
end

GenericSystemMenuManager._get_ws = function(l_38_0)
  return l_38_0._ws
end

GenericSystemMenuManager._get_controller = function(l_39_0)
  return l_39_0._controller
end

GenericSystemMenuManager.add_dialog_shown_callback = function(l_40_0, l_40_1)
  l_40_0._dialog_shown_callback_handler:add(l_40_1)
end

GenericSystemMenuManager.remove_dialog_shown_callback = function(l_41_0, l_41_1)
  l_41_0._dialog_shown_callback_handler:remove(l_41_1)
end

GenericSystemMenuManager.add_dialog_hidden_callback = function(l_42_0, l_42_1)
  l_42_0._dialog_hidden_callback_handler:add(l_42_1)
end

GenericSystemMenuManager.remove_dialog_hidden_callback = function(l_43_0, l_43_1)
  l_43_0._dialog_hidden_callback_handler:remove(l_43_1)
end

GenericSystemMenuManager.add_dialog_closed_callback = function(l_44_0, l_44_1)
  l_44_0._dialog_closed_callback_handler:add(l_44_1)
end

GenericSystemMenuManager.remove_dialog_closed_callback = function(l_45_0, l_45_1)
  l_45_0._dialog_closed_callback_handler:remove(l_45_1)
end

GenericSystemMenuManager.add_active_changed_callback = function(l_46_0, l_46_1)
  l_46_0._active_changed_callback_handler:add(l_46_1)
end

GenericSystemMenuManager.remove_active_changed_callback = function(l_47_0, l_47_1)
  l_47_0._active_changed_callback_handler:remove(l_47_1)
end

GenericSystemMenuManager.event_dialog_shown = function(l_48_0, l_48_1)
  if Global.category_print.dialog_manager then
    cat_print("dialog_manager", "[SystemMenuManager] [Show dialog] " .. tostring(l_48_1:to_string()))
  end
  if l_48_1.fade_in then
    l_48_1:fade_in()
  end
  l_48_0:set_active_dialog(l_48_1)
  l_48_0._dialog_shown_callback_handler:dispatch(l_48_1)
end

GenericSystemMenuManager.event_dialog_hidden = function(l_49_0, l_49_1)
  if Global.category_print.dialog_manager then
    cat_print("dialog_manager", "[SystemMenuManager] [Hide dialog] " .. tostring(l_49_1:to_string()))
  end
  l_49_0:set_active_dialog(nil)
  l_49_0._dialog_hidden_callback_handler:dispatch(l_49_1)
end

GenericSystemMenuManager.event_dialog_closed = function(l_50_0, l_50_1)
  if Global.category_print.dialog_manager then
    cat_print("dialog_manager", "[SystemMenuManager] [Close dialog] " .. tostring(l_50_1:to_string()))
  end
  l_50_0:set_active_dialog(nil)
  l_50_0._dialog_closed_callback_handler:dispatch(l_50_1)
end

GenericSystemMenuManager.event_active_changed = function(l_51_0, l_51_1)
  if Global.category_print.dialog_manager then
    cat_print("dialog_manager", "[SystemMenuManager] [Active changed] Active: " .. tostring(not not l_51_1))
  end
  print("dispacth from system menus", l_51_1)
  l_51_0._active_changed_callback_handler:dispatch(l_51_1)
end

if not WinSystemMenuManager then
  WinSystemMenuManager = class(GenericSystemMenuManager)
end
local l_0_0 = SystemMenuManager.PLATFORM_CLASS_MAP
local l_0_1 = Idstring("win32"):key()
l_0_0[l_0_1] = WinSystemMenuManager
l_0_0 = Xbox360SystemMenuManager
if not l_0_0 then
  l_0_0 = class
  l_0_1 = GenericSystemMenuManager
  l_0_0 = l_0_0(l_0_1)
end
Xbox360SystemMenuManager = l_0_0
l_0_0 = Xbox360SystemMenuManager
l_0_1 = Xbox360Dialog
l_0_0.PLATFORM_DIALOG_CLASS = l_0_1
l_0_0 = Xbox360SystemMenuManager
l_0_1 = Xbox360SelectStorageDialog
l_0_0.SELECT_STORAGE_DIALOG_CLASS = l_0_1
l_0_0 = Xbox360SystemMenuManager
l_0_1 = Xbox360SelectStorageDialog
l_0_0.GENERIC_SELECT_STORAGE_DIALOG_CLASS = l_0_1
l_0_0 = Xbox360SystemMenuManager
l_0_1 = Xbox360KeyboardInputDialog
l_0_0.KEYBOARD_INPUT_DIALOG = l_0_1
l_0_0 = Xbox360SystemMenuManager
l_0_1 = Xbox360KeyboardInputDialog
l_0_0.GENERIC_KEYBOARD_INPUT_DIALOG = l_0_1
l_0_0 = Xbox360SystemMenuManager
l_0_1 = Xbox360SelectUserDialog
l_0_0.GENERIC_SELECT_USER_DIALOG = l_0_1
l_0_0 = Xbox360SystemMenuManager
l_0_1 = Xbox360SelectUserDialog
l_0_0.SELECT_USER_DIALOG = l_0_1
l_0_0 = Xbox360SystemMenuManager
l_0_1 = Xbox360AchievementsDialog
l_0_0.GENERIC_ACHIEVEMENTS_DIALOG = l_0_1
l_0_0 = Xbox360SystemMenuManager
l_0_1 = Xbox360AchievementsDialog
l_0_0.ACHIEVEMENTS_DIALOG = l_0_1
l_0_0 = Xbox360SystemMenuManager
l_0_1 = Xbox360FriendsDialog
l_0_0.GENERIC_FRIENDS_DIALOG = l_0_1
l_0_0 = Xbox360SystemMenuManager
l_0_1 = Xbox360FriendsDialog
l_0_0.FRIENDS_DIALOG = l_0_1
l_0_0 = Xbox360SystemMenuManager
l_0_1 = Xbox360PlayerReviewDialog
l_0_0.GENERIC_PLAYER_REVIEW_DIALOG = l_0_1
l_0_0 = Xbox360SystemMenuManager
l_0_1 = Xbox360PlayerReviewDialog
l_0_0.PLAYER_REVIEW_DIALOG = l_0_1
l_0_0 = Xbox360SystemMenuManager
l_0_1 = Xbox360PlayerDialog
l_0_0.GENERIC_PLAYER_DIALOG = l_0_1
l_0_0 = Xbox360SystemMenuManager
l_0_1 = Xbox360PlayerDialog
l_0_0.PLAYER_DIALOG = l_0_1
l_0_0 = Xbox360SystemMenuManager
l_0_1 = Xbox360MarketplaceDialog
l_0_0.GENERIC_MARKETPLACE_DIALOG = l_0_1
l_0_0 = Xbox360SystemMenuManager
l_0_1 = Xbox360MarketplaceDialog
l_0_0.MARKETPLACE_DIALOG = l_0_1
l_0_0 = SystemMenuManager
l_0_0 = l_0_0.PLATFORM_CLASS_MAP
l_0_1 = Idstring
l_0_1 = l_0_1("X360")
 -- DECOMPILER ERROR: Overwrote pending register.

l_0_1 = l_0_1:key
l_0_0[l_0_1] = Xbox360SystemMenuManager
l_0_0 = Xbox360SystemMenuManager
l_0_1 = function(l_52_0, l_52_1)
  if l_52_0._active_dialog and not l_52_1 then
    local dialog_block = l_52_0._active_dialog:blocks_exec()
  end
  if dialog_block and not GenericSystemMenuManager.is_active(l_52_0) then
    return Application:is_showing_system_dialog()
  end
end

l_0_0.is_active = l_0_1
l_0_0 = PS3SystemMenuManager
if not l_0_0 then
  l_0_0 = class
  l_0_1 = GenericSystemMenuManager
  l_0_0 = l_0_0(l_0_1)
end
PS3SystemMenuManager = l_0_0
l_0_0 = PS3SystemMenuManager
l_0_1 = PS3DeleteFileDialog
l_0_0.DELETE_FILE_DIALOG_CLASS = l_0_1
l_0_0 = PS3SystemMenuManager
l_0_1 = PS3DeleteFileDialog
l_0_0.GENERIC_DELETE_FILE_DIALOG_CLASS = l_0_1
l_0_0 = PS3SystemMenuManager
l_0_1 = PS3KeyboardInputDialog
l_0_0.KEYBOARD_INPUT_DIALOG = l_0_1
l_0_0 = PS3SystemMenuManager
l_0_1 = PS3KeyboardInputDialog
l_0_0.GENERIC_KEYBOARD_INPUT_DIALOG = l_0_1
l_0_0 = SystemMenuManager
l_0_0 = l_0_0.PLATFORM_CLASS_MAP
l_0_1 = Idstring
l_0_1 = l_0_1("PS3")
 -- DECOMPILER ERROR: Overwrote pending register.

l_0_1 = l_0_1:key
l_0_0[l_0_1] = PS3SystemMenuManager
l_0_0 = PS3SystemMenuManager
l_0_1 = function(l_53_0)
  GenericSystemMenuManager.init(l_53_0)
  l_53_0._is_ps_button_menu_visible = false
  PS3:set_ps_button_callback(callback(l_53_0, l_53_0, "ps_button_menu_callback"))
end

l_0_0.init = l_0_1
l_0_0 = PS3SystemMenuManager
l_0_1 = function(l_54_0, l_54_1)
  l_54_0._is_ps_button_menu_visible = l_54_1
end

l_0_0.ps_button_menu_callback = l_0_1
l_0_0 = PS3SystemMenuManager
l_0_1 = function(l_55_0)
  if not GenericSystemMenuManager.is_active(l_55_0) then
    return PS3:is_displaying_box()
  end
end

l_0_0.block_exec = l_0_1
l_0_0 = PS3SystemMenuManager
l_0_1 = function(l_56_0)
  if not GenericSystemMenuManager.is_active(l_56_0) and not PS3:is_displaying_box() then
    return l_56_0._is_ps_button_menu_visible
  end
end

l_0_0.is_active = l_0_1

