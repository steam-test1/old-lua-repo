-- Decompiled using luadec 2.0.1 by sztupy (http://winmo.sztupy.hu)
-- Command line was: F:\SteamLibrary\SteamApps\common\PAYDAY 2\lua\lib\states\menutitlescreenstate.luac 

require("lib/states/GameState")
if not MenuTitlescreenState then
  MenuTitlescreenState = class(GameState)
end
MenuTitlescreenState.init = function(l_1_0, l_1_1, l_1_2)
  GameState.init(l_1_0, "menu_titlescreen", l_1_1)
  if l_1_2 then
    l_1_0:setup()
  end
end

local is_ps3 = SystemInfo:platform() == Idstring("PS3")
local is_x360 = SystemInfo:platform() == Idstring("X360")
local is_win32 = SystemInfo:platform() == Idstring("WIN32")
MenuTitlescreenState.setup = function(l_2_0)
  local res = RenderSettings.resolution
  local gui = Overlay:gui()
  l_2_0._workspace = managers.gui_data:create_saferect_workspace()
  l_2_0._workspace:hide()
  managers.gui_data:layout_workspace(l_2_0._workspace)
  l_2_0._full_workspace = gui:create_screen_workspace()
  l_2_0._full_workspace:hide()
  l_2_0._back_drop_gui = MenuBackdropGUI:new()
  l_2_0._back_drop_gui:hide()
  local bitmap = l_2_0._workspace:panel():bitmap({texture = "guis/textures/menu_title_screen", layer = 1})
  bitmap:set_center(l_2_0._workspace:panel():w() / 2, l_2_0._workspace:panel():h() / 2)
  l_2_0._full_workspace:panel():rect({visible = false, color = Color.black, layer = 0})
  local text_id = (is_ps3 or is_x360) and "menu_press_start" or "menu_visit_forum3"
   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

  local text = l_2_0._workspace:panel():text({text = managers.localization:text(text_id), font = tweak_data.menu.pd2_large_font})
  text:set_bottom(l_2_0._workspace:panel():h() / 1.25)
  {text = managers.localization:text(text_id), font = tweak_data.menu.pd2_large_font}.layer, {text = managers.localization:text(text_id), font = tweak_data.menu.pd2_large_font}.h, {text = managers.localization:text(text_id), font = tweak_data.menu.pd2_large_font}.w, {text = managers.localization:text(text_id), font = tweak_data.menu.pd2_large_font}.vertical, {text = managers.localization:text(text_id), font = tweak_data.menu.pd2_large_font}.align, {text = managers.localization:text(text_id), font = tweak_data.menu.pd2_large_font}.color, {text = managers.localization:text(text_id), font = tweak_data.menu.pd2_large_font}.font_size = 2, l_2_0._workspace:panel():h(), l_2_0._workspace:panel():w(), "bottom", "center", Color.white, tweak_data.menu.topic_font_size
  l_2_0._controller_list = {}
  for index = 1, managers.controller:get_wrapper_count() do
    l_2_0._controller_list[index] = managers.controller:create_controller("title_" .. index, index, false)
    if is_win32 and l_2_0._controller_list[index]:get_type() == "xbox360" then
      l_2_0._controller_list[index]:add_connect_changed_callback(callback(l_2_0, l_2_0, "_update_pc_xbox_controller_connection", {text_gui = text, text_id = text_id}))
    end
  end
  if is_win32 then
    l_2_0:_update_pc_xbox_controller_connection({text_gui = text, text_id = text_id})
  end
  l_2_0:reset_attract_video()
end

MenuTitlescreenState._update_pc_xbox_controller_connection = function(l_3_0, l_3_1)
  local text_string = (managers.localization:to_upper_text(l_3_1.text_id))
  local added_text = nil
  for _,controller in pairs(l_3_0._controller_list) do
    if controller:get_type() == "xbox360" and controller:connected() then
      text_string = text_string .. "\n" .. managers.localization:to_upper_text("menu_or_press_any_xbox_button")
  else
    end
  end
  l_3_1.text_gui:set_text(text_string)
end

MenuTitlescreenState.at_enter = function(l_4_0)
  if not l_4_0._controller_list then
    l_4_0:setup()
    Application:stack_dump_error("Shouldn't enter title more than once. Except when toggling freeflight.")
  end
  managers.music:post_event("menu_music")
  managers.menu:input_enabled(false)
  for index,controller in ipairs(l_4_0._controller_list) do
    controller:enable()
  end
  managers.overlay_effect:play_effect({color = Color.black, fade_in = 0, sustain = 0.10000000149012, fade_out = 0.40000000596046, blend_mode = "normal"})
  managers.menu_scene:setup_camera()
  managers.menu_scene:set_scene_template("lobby")
  l_4_0._workspace:show()
  l_4_0._full_workspace:show()
  managers.user:set_index(nil)
  managers.controller:set_default_wrapper_index(nil)
  l_4_0._clbk_game_has_music_control_callback = callback(l_4_0, l_4_0, "clbk_game_has_music_control")
  managers.platform:add_event_callback("media_player_control", l_4_0._clbk_game_has_music_control_callback)
  l_4_0:reset_attract_video()
end

MenuTitlescreenState.clbk_game_has_music_control = function(l_5_0, l_5_1)
  l_5_0._attract_video_gui:set_volume_gain(not alive(l_5_0._attract_video_gui) or (l_5_1 and 1) or 0)
end

MenuTitlescreenState.update = function(l_6_0, l_6_1, l_6_2)
  if l_6_0._waiting_for_loaded_savegames and not managers.savefile:is_in_loading_sequence() and not l_6_0._user_has_changed then
    l_6_0:_load_savegames_done()
  end
  return 
  l_6_0:check_confirm_pressed()
  if managers.system_menu:is_active() then
    l_6_0:reset_attract_video()
  else
    l_6_0._controller_index = l_6_0:get_start_pressed_controller_index()
    if l_6_0._controller_index then
      managers.controller:set_default_wrapper_index(l_6_0._controller_index)
      managers.user:set_index(l_6_0._controller_index)
      managers.user:check_user(callback(l_6_0, l_6_0, "check_user_callback"), true)
      if managers.dlc:has_corrupt_data() and not Global.corrupt_dlc_msg_shown then
        Global.corrupt_dlc_msg_shown = true
        print("[MenuTitlescreenState:update] showing corrupt_DLC")
        managers.menu:show_corrupt_dlc()
      else
        if not l_6_0:check_attract_video() and l_6_0:is_attract_video_delay_done() then
          l_6_0:play_attract_video()
        end
      end
    end
  end
end

MenuTitlescreenState.get_start_pressed_controller_index = function(l_7_0)
  for index,controller in ipairs(l_7_0._controller_list) do
    if (is_ps3 or is_x360) and controller:get_input_pressed("start") then
      return index
      for (for control),index in (for generator) do
        if controller:get_any_input_pressed() then
          return index
        end
        if controller._default_controller_id == "keyboard" and (#Input:keyboard():pressed_list() > 0 or #Input:mouse():pressed_list() > 0) then
          return index
        end
      end
    end
    return nil
     -- Warning: missing end command somewhere! Added here
  end
end

MenuTitlescreenState.check_confirm_pressed = function(l_8_0)
  for index,controller in ipairs(l_8_0._controller_list) do
    if controller:get_input_pressed("confirm") then
      print("check_confirm_pressed")
      local active, dialog = managers.system_menu:is_active_by_id("invite_join_message")
      if active then
        print("close")
        dialog:button_pressed_callback()
      end
      local active, dialog = managers.system_menu:is_active_by_id("user_changed")
      if active then
        print("close user_changed")
        dialog:button_pressed_callback()
      end
      local active, dialog = managers.system_menu:is_active_by_id("inactive_user_accepted_invite")
      if active then
        print("close inactive_user_accepted_invite")
        dialog:button_pressed_callback()
      end
    end
  end
end

MenuTitlescreenState.check_user_callback = function(l_9_0, l_9_1)
  managers.dlc:on_signin_complete()
  if l_9_1 then
    managers.user:check_storage(callback(l_9_0, l_9_0, "check_storage_callback"), true)
  else
    local dialog_data = {}
    dialog_data.title = managers.localization:text("dialog_warning_title")
    dialog_data.text = managers.localization:text("dialog_skip_signin_warning")
    local yes_button = {}
    yes_button.text = managers.localization:text("dialog_yes")
    yes_button.callback_func = callback(l_9_0, l_9_0, "continue_without_saving_yes_callback")
    local no_button = {}
    no_button.text = managers.localization:text("dialog_no")
    no_button.callback_func = callback(l_9_0, l_9_0, "continue_without_saving_no_callback")
    dialog_data.button_list = {yes_button, no_button}
    managers.system_menu:show(dialog_data)
  end
end

MenuTitlescreenState.check_storage_callback = function(l_10_0, l_10_1)
  if l_10_1 then
    l_10_0._waiting_for_loaded_savegames = true
  else
    local dialog_data = {}
    dialog_data.title = managers.localization:text("dialog_warning_title")
    dialog_data.text = managers.localization:text("dialog_skip_storage_warning")
    local yes_button = {}
    yes_button.text = managers.localization:text("dialog_yes")
    yes_button.callback_func = callback(l_10_0, l_10_0, "continue_without_saving_yes_callback")
    local no_button = {}
    no_button.text = managers.localization:text("dialog_no")
    no_button.callback_func = callback(l_10_0, l_10_0, "continue_without_saving_no_callback")
    dialog_data.button_list = {yes_button, no_button}
    managers.system_menu:show(dialog_data)
  end
end

MenuTitlescreenState._load_savegames_done = function(l_11_0)
  local sound_source = SoundDevice:create_source("MenuTitleScreen")
  sound_source:post_event("menu_start")
  l_11_0:gsm():change_state_by_name("menu_main")
end

MenuTitlescreenState.continue_without_saving_yes_callback = function(l_12_0)
  l_12_0:gsm():change_state_by_name("menu_main")
end

MenuTitlescreenState.continue_without_saving_no_callback = function(l_13_0)
  managers.user:set_index(nil)
  managers.controller:set_default_wrapper_index(nil)
end

MenuTitlescreenState.check_attract_video = function(l_14_0)
  if alive(l_14_0._attract_video_gui) then
    if l_14_0._attract_video_gui:loop_count() > 0 or l_14_0:is_any_input_pressed() then
      l_14_0:reset_attract_video()
    else
      return true
    end
  else
    if l_14_0:is_any_input_pressed() then
      l_14_0:reset_attract_video()
    end
  end
  return false
end

MenuTitlescreenState.is_any_input_pressed = function(l_15_0)
  for _,controller in ipairs(l_15_0._controller_list) do
    if controller:get_any_input_pressed() then
      return true
    end
  end
  return false
end

MenuTitlescreenState.reset_attract_video = function(l_16_0)
  l_16_0._attract_video_time = TimerManager:main():time()
  if alive(l_16_0._attract_video_gui) then
    l_16_0._attract_video_gui:stop()
    l_16_0._full_workspace:panel():remove(l_16_0._attract_video_gui)
    l_16_0._attract_video_gui = nil
  end
end

MenuTitlescreenState.is_attract_video_delay_done = function(l_17_0)
  return l_17_0._attract_video_time + _G.tweak_data.states.title.ATTRACT_VIDEO_DELAY < TimerManager:main():time()
end

MenuTitlescreenState.play_attract_video = function(l_18_0)
  l_18_0:reset_attract_video()
  local res = RenderSettings.resolution
  local src_width, src_height = 1280, 720
  local dest_width, dest_height = nil, nil
  if res.x / res.y < src_width / src_height then
    dest_width = res.x
    dest_height = src_height * dest_width / src_width
  else
    dest_height = res.y
    dest_width = src_width * dest_height / src_height
  end
  local x = (res.x - dest_width) / 2
  local y = (res.y - dest_height) / 2
  l_18_0._attract_video_gui = l_18_0._full_workspace:panel():video({video = "movies/attract", x = x, y = y, width = dest_width, height = dest_height, layer = tweak_data.gui.ATTRACT_SCREEN_LAYER})
  l_18_0._attract_video_gui:play()
  l_18_0._attract_video_gui:set_volume_gain(managers.music:has_music_control() and 1 or 0)
end

MenuTitlescreenState.at_exit = function(l_19_0)
  managers.platform:remove_event_callback("media_player_control", l_19_0._clbk_game_has_music_control_callback)
  if alive(l_19_0._workspace) then
    Overlay:gui():destroy_workspace(l_19_0._workspace)
    l_19_0._workspace = nil
  end
  if alive(l_19_0._full_workspace) then
    Overlay:gui():destroy_workspace(l_19_0._full_workspace)
    l_19_0._full_workspace = nil
  end
  l_19_0._back_drop_gui:destroy()
  if l_19_0._controller_list then
    for _,controller in ipairs(l_19_0._controller_list) do
      controller:destroy()
    end
    l_19_0._controller_list = nil
  end
  managers.menu_component:test_camera_shutter_tech()
  managers.menu:input_enabled(true)
  managers.user:set_active_user_state_change_quit(true)
  managers.system_menu:init_finalize()
end

MenuTitlescreenState.on_user_changed = function(l_20_0, l_20_1, l_20_2)
  print("MenuTitlescreenState:on_user_changed")
  if l_20_1 and l_20_1.signin_state ~= "not_signed_in" and l_20_0._waiting_for_loaded_savegames then
    l_20_0._user_has_changed = true
  end
end

MenuTitlescreenState.on_storage_changed = function(l_21_0, l_21_1, l_21_2)
  print("MenuTitlescreenState:on_storage_changed")
  if l_21_0._waiting_for_loaded_savegames then
    l_21_0._waiting_for_loaded_savegames = nil
  end
end


