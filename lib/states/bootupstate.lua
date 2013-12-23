-- Decompiled using luadec 2.0.1 by sztupy (http://winmo.sztupy.hu)
-- Command line was: F:\SteamLibrary\SteamApps\common\PAYDAY 2\lua\lib\states\bootupstate.luac 

require("lib/states/GameState")
if not BootupState then
  BootupState = class(GameState)
end
BootupState.init = function(l_1_0, l_1_1, l_1_2)
  GameState.init(l_1_0, "bootup", l_1_1)
  if l_1_2 then
    l_1_0:setup()
  end
end

BootupState.old = function(l_2_0)
  {visible = show_esrb, layer = 1}.texture = "guis/textures/esrb_rating"
   -- DECOMPILER ERROR: Confused about usage of registers!

  {visible = show_esrb, layer = 1}.width = esrb_y * 2
   -- DECOMPILER ERROR: Confused about usage of registers!

  {visible = show_esrb, layer = 1}.height = esrb_y
   -- DECOMPILER ERROR: Confused about usage of registers!

  {visible = show_esrb, layer = 1}.can_skip = has_full_game
   -- DECOMPILER ERROR: Confused about usage of registers!

  {visible = show_esrb, layer = 1}.fade_in = 1.25
   -- DECOMPILER ERROR: Confused about usage of registers!

  {visible = show_esrb, layer = 1}.duration = show_esrb and 6.5 or 0
   -- DECOMPILER ERROR: Confused about usage of registers!

  {visible = show_esrb, layer = 1}.fade_out = 1.25
  {layer = 1, texture = "guis/textures/soe_logo"}.width = 256
   -- DECOMPILER ERROR: Confused about usage of registers!

  {layer = 1, texture = "guis/textures/soe_logo"}.height = 256
   -- DECOMPILER ERROR: Confused about usage of registers!

  {layer = 1, texture = "guis/textures/soe_logo"}.padding = 200
   -- DECOMPILER ERROR: Confused about usage of registers!

  {layer = 1, texture = "guis/textures/soe_logo"}.can_skip = can_skip
   -- DECOMPILER ERROR: Confused about usage of registers!

  {layer = 1, texture = "guis/textures/soe_logo"}.fade_in = 1.25
   -- DECOMPILER ERROR: Confused about usage of registers!

  {layer = 1, texture = "guis/textures/soe_logo"}.duration = 6
   -- DECOMPILER ERROR: Confused about usage of registers!

  {layer = 1, texture = "guis/textures/soe_logo"}.fade_out = 1.25
  {layer = 1, text = legal_text, font = tweak_data.menu.default_font, font_size = 24, wrap = true, word_wrap = true, vertical = "center", width = safe_rect_pixels.width, height = safe_rect_pixels.height, padding = 200, can_skip = can_skip, fade_in = 1.25}.duration = 6
   -- DECOMPILER ERROR: Confused about usage of registers!

  {layer = 1, text = legal_text, font = tweak_data.menu.default_font, font_size = 24, wrap = true, word_wrap = true, vertical = "center", width = safe_rect_pixels.width, height = safe_rect_pixels.height, padding = 200, can_skip = can_skip, fade_in = 1.25}.fade_out = 1.25
   -- DECOMPILER ERROR: Unhandled construct in list

   -- DECOMPILER ERROR: Unhandled construct in table

   -- Warning: undefined locals caused missing assignments!
end

BootupState.setup = function(l_3_0)
  local res = RenderSettings.resolution
  local safe_rect_pixels = managers.gui_data:scaled_size()
  local gui = Overlay:gui()
  local is_win32 = SystemInfo:platform() == Idstring("WIN32")
  local is_x360 = SystemInfo:platform() == Idstring("X360")
  local show_esrb = false
  l_3_0._full_workspace = gui:create_screen_workspace()
  l_3_0._workspace = managers.gui_data:create_saferect_workspace()
  l_3_0._back_drop_gui = MenuBackdropGUI:new()
  l_3_0._back_drop_gui:hide()
  l_3_0._workspace:hide()
  l_3_0._full_workspace:hide()
  managers.gui_data:layout_workspace(l_3_0._workspace)
  local esrb_y = safe_rect_pixels.height / 1.8999999761581
  local can_skip = true
  local has_full_game = managers.dlc:has_full_game()
  local legal_text = managers.localization:text("legal_text")
  local item_layer = l_3_0._back_drop_gui:background_layers()
  {visible = not is_win32, layer = item_layer}.gui = Idstring("guis/autosave_warning")
   -- DECOMPILER ERROR: Confused about usage of registers!

  {visible = not is_win32, layer = item_layer}.width = 600
   -- DECOMPILER ERROR: Confused about usage of registers!

  {visible = not is_win32, layer = item_layer}.height = 200
   -- DECOMPILER ERROR: Confused about usage of registers!

  {visible = not is_win32, layer = item_layer}.can_skip = false
   -- DECOMPILER ERROR: Confused about usage of registers!

  {visible = not is_win32, layer = item_layer}.fade_in = 1.25
   -- DECOMPILER ERROR: Confused about usage of registers!

  {visible = not is_win32, layer = item_layer}.duration = is_win32 and 0 or 6
   -- DECOMPILER ERROR: Confused about usage of registers!

  {visible = not is_win32, layer = item_layer}.fade_out = 1.25
  {visible = show_esrb, layer = item_layer}.texture = "guis/textures/esrb_rating"
   -- DECOMPILER ERROR: Confused about usage of registers!

  {visible = show_esrb, layer = item_layer}.width = esrb_y * 2
   -- DECOMPILER ERROR: Confused about usage of registers!

  {visible = show_esrb, layer = item_layer}.height = esrb_y
   -- DECOMPILER ERROR: Confused about usage of registers!

  {visible = show_esrb, layer = item_layer}.can_skip = has_full_game
   -- DECOMPILER ERROR: Confused about usage of registers!

  {visible = show_esrb, layer = item_layer}.fade_in = 1.25
   -- DECOMPILER ERROR: Confused about usage of registers!

  {visible = show_esrb, layer = item_layer}.duration = show_esrb and 6.5 or 0
   -- DECOMPILER ERROR: Confused about usage of registers!

  {visible = show_esrb, layer = item_layer}.fade_out = 1.25
  {layer = item_layer, text = legal_text, font = tweak_data.menu.pd2_medium_font, font_size = 24, wrap = true, word_wrap = true, vertical = "center", width = safe_rect_pixels.width, height = safe_rect_pixels.height, padding = 200, can_skip = can_skip, fade_in = 1.25}.duration = 6
   -- DECOMPILER ERROR: Confused about usage of registers!

  {layer = item_layer, text = legal_text, font = tweak_data.menu.pd2_medium_font, font_size = 24, wrap = true, word_wrap = true, vertical = "center", width = safe_rect_pixels.width, height = safe_rect_pixels.height, padding = 200, can_skip = can_skip, fade_in = 1.25}.fade_out = 1.25
   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

  l_3_0._play_data_list = {{visible = not is_win32, layer = item_layer}, {visible = show_esrb, layer = item_layer}, {layer = item_layer, text = legal_text, font = tweak_data.menu.pd2_medium_font, font_size = 24, wrap = true, word_wrap = true, vertical = "center", width = safe_rect_pixels.width, height = safe_rect_pixels.height, padding = 200, can_skip = can_skip, fade_in = 1.25}, {layer = item_layer, video = "movies/game_intro", width = res.x, height = res.y, padding = 200, can_skip = true}}
  l_3_0._full_panel = l_3_0._full_workspace:panel()
  l_3_0._panel = l_3_0._workspace:panel()
  l_3_0._full_panel:rect({visible = false, color = Color.red, layer = 0})
  l_3_0._controller_list = {}
  for index = 1, managers.controller:get_wrapper_count() do
    local con = managers.controller:create_controller("boot_" .. index, index, false)
    con:enable()
    l_3_0._controller_list[index] = con
  end
end

BootupState.at_enter = function(l_4_0)
  managers.menu:input_enabled(false)
  if not l_4_0._controller_list then
    l_4_0:setup()
    Application:stack_dump_error("Shouldn't enter boot state more than once. Except when toggling freeflight.")
  end
  l_4_0._sound_listener = SoundDevice:create_listener("main_menu")
  l_4_0._sound_listener:activate(true)
  l_4_0._workspace:show()
  l_4_0._full_workspace:show()
  l_4_0._back_drop_gui:show()
  l_4_0._clbk_game_has_music_control_callback = callback(l_4_0, l_4_0, "clbk_game_has_music_control")
  managers.platform:add_event_callback("media_player_control", l_4_0._clbk_game_has_music_control_callback)
  l_4_0:play_next()
end

BootupState.clbk_game_has_music_control = function(l_5_0, l_5_1)
  l_5_0._gui_obj:set_volume_gain(not l_5_0._play_data or not l_5_0._play_data.video or (l_5_1 and 1) or 0)
end

BootupState.update = function(l_6_0, l_6_1, l_6_2)
  l_6_0:check_confirm_pressed()
  if (not l_6_0:is_playing() or (not l_6_0._play_data.can_skip and not Global.override_bootup_can_skip) or l_6_0:is_skipped()) then
    l_6_0:play_next()
  else
    l_6_0:update_fades()
  end
end

BootupState.check_confirm_pressed = function(l_7_0)
  for index,controller in ipairs(l_7_0._controller_list) do
    if controller:get_input_pressed("confirm") then
      print("check_confirm_pressed")
      local active, dialog = managers.system_menu:is_active_by_id("invite_join_message")
      if active then
        print("close")
        dialog:button_pressed_callback()
      end
    end
  end
end

BootupState.update_fades = function(l_8_0)
  local time, duration = nil, nil
  if l_8_0._play_data.video then
    duration = l_8_0._gui_obj:length()
    local frames = l_8_0._gui_obj:frames()
    if frames > 0 then
      time = l_8_0._gui_obj:frame_num() / frames * duration
    else
      time = 0
    end
  else
    time = TimerManager:game():time() - l_8_0._play_time
    duration = l_8_0._play_data.duration
  end
  local old_fade = l_8_0._fade
  if l_8_0._play_data.fade_in and time < l_8_0._play_data.fade_in then
    if l_8_0._play_data.fade_in > 0 then
      l_8_0._fade = (time) / l_8_0._play_data.fade_in
    else
      l_8_0._fade = 1
    end
  else
    if l_8_0._play_data.fade_in and duration - (time) < l_8_0._play_data.fade_out then
      if l_8_0._play_data.fade_out > 0 then
        l_8_0._fade = (duration - (time)) / l_8_0._play_data.fade_out
      else
        l_8_0._fade = 0
      end
    else
      l_8_0._fade = 1
    end
  end
  if l_8_0._fade ~= old_fade then
    l_8_0:apply_fade()
  end
end

BootupState.apply_fade = function(l_9_0)
  if l_9_0._play_data.gui then
    if l_9_0._gui_obj.script then
      local script = l_9_0._gui_obj:script()
    end
    if script.set_fade then
      script:set_fade(l_9_0._fade)
    else
      Application:error("GUI \"" .. tostring(l_9_0._play_data.gui) .. "\" lacks a function set_fade( o, fade ).")
    end
  else
    l_9_0._gui_obj:set_color(l_9_0._gui_obj:color():with_alpha(l_9_0._fade))
  end
end

BootupState.is_skipped = function(l_10_0)
  for _,controller in ipairs(l_10_0._controller_list) do
    if controller:get_any_input_pressed() then
      return true
    end
  end
  return false
end

BootupState.is_playing = function(l_11_0)
  if l_11_0._gui_obj.loop_count then
    if l_11_0._gui_obj:loop_count() >= 1 then
      return not alive(l_11_0._gui_obj)
    end
  else
    return TimerManager:game():time() < l_11_0._play_time + l_11_0._play_data.duration
    do return end
    return false
  end
end

BootupState.play_next = function(l_12_0)
  l_12_0._play_time = TimerManager:game():time()
  l_12_0._play_index = (l_12_0._play_index or 0) + 1
  l_12_0._play_data = l_12_0._play_data_list[l_12_0._play_index]
  if not l_12_0._play_data.fade_in or not 0 then
    l_12_0._fade = not l_12_0._play_data or 1
  end
  if alive(l_12_0._gui_obj) then
    l_12_0._panel:remove(l_12_0._gui_obj)
    if alive(l_12_0._gui_obj) then
      l_12_0._full_panel:remove(l_12_0._gui_obj)
    end
    l_12_0._gui_obj = nil
  end
  local res = RenderSettings.resolution
  local width, height = nil, nil
  local padding = l_12_0._play_data.padding or 0
  if l_12_0._play_data.gui then
    if res.x / res.y < l_12_0._play_data.width / l_12_0._play_data.height then
      width = res.x - padding * 2
      height = l_12_0._play_data.height * (width) / l_12_0._play_data.width
    else
      height = l_12_0._play_data.height
      width = l_12_0._play_data.width
    end
  else
    height = l_12_0._play_data.height
    width = l_12_0._play_data.width
  end
end
local x = (l_12_0._panel:w() - width) / 2
local y = (l_12_0._panel:h() - height) / 2
do
  local gui_config = {x = x, y = y, width = width, height = height, layer = tweak_data.gui.BOOT_SCREEN_LAYER}
  if l_12_0._play_data.video then
    gui_config.video = l_12_0._play_data.video
    l_12_0._gui_obj = l_12_0._full_panel:video(gui_config)
    if not managers.music:has_music_control() then
      l_12_0._gui_obj:set_volume_gain(0)
    end
    local w = l_12_0._gui_obj:video_width()
    local h = l_12_0._gui_obj:video_height()
    local m = h / w
    l_12_0._gui_obj:set_size(res.x, res.x * m)
    l_12_0._gui_obj:set_center(res.x / 2, res.y / 2)
    l_12_0._gui_obj:play()
  else
    if l_12_0._play_data.texture then
      gui_config.texture = l_12_0._play_data.texture
      l_12_0._gui_obj = l_12_0._panel:bitmap(gui_config)
    else
      if l_12_0._play_data.text then
        gui_config.text = l_12_0._play_data.text
        gui_config.font = l_12_0._play_data.font
        gui_config.font_size = l_12_0._play_data.font_size
        gui_config.wrap = l_12_0._play_data.wrap
        gui_config.word_wrap = l_12_0._play_data.word_wrap
        gui_config.vertical = l_12_0._play_data.vertical
        l_12_0._gui_obj = l_12_0._panel:text(gui_config)
      else
        if l_12_0._play_data.gui then
          l_12_0._gui_obj = l_12_0._panel:gui(l_12_0._play_data.gui)
          l_12_0._gui_obj:set_shape(x, y, width, height)
          local script = l_12_0._gui_obj:script()
          if script.setup then
            script:setup()
          end
        end
      end
    end
  end
  l_12_0:apply_fade()
end

end

BootupState.at_exit = function(l_13_0)
  managers.platform:remove_event_callback("media_player_control", l_13_0._clbk_game_has_music_control_callback)
  if alive(l_13_0._workspace) then
    Overlay:gui():destroy_workspace(l_13_0._workspace)
    l_13_0._workspace = nil
    l_13_0._gui_obj = nil
  end
  if alive(l_13_0._full_workspace) then
    Overlay:gui():destroy_workspace(l_13_0._full_workspace)
    l_13_0._full_workspace = nil
  end
  l_13_0._back_drop_gui:destroy()
  if l_13_0._controller_list then
    for _,controller in ipairs(l_13_0._controller_list) do
      controller:destroy()
    end
    l_13_0._controller_list = nil
  end
  if l_13_0._sound_listener then
    l_13_0._sound_listener:delete()
    l_13_0._sound_listener = nil
  end
  l_13_0._play_data_list = nil
  l_13_0._play_index = nil
  l_13_0._play_data = nil
  managers.menu:input_enabled(true)
  if PackageManager:loaded("packages/boot_screen") then
    PackageManager:unload("packages/boot_screen")
  end
end


