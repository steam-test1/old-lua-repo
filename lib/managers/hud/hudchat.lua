-- Decompiled using luadec 2.0.1 by sztupy (http://winmo.sztupy.hu)
-- Command line was: F:\SteamLibrary\SteamApps\common\PAYDAY 2\lua\lib\managers\hud\hudchat.luac 

if not HUDChat then
  HUDChat = class()
end
HUDChat.init = function(l_1_0, l_1_1, l_1_2)
  l_1_0._ws = l_1_1
  l_1_0._hud_panel = l_1_2.panel
  l_1_0:set_channel_id(ChatManager.GAME)
  l_1_0._output_width = 300
  l_1_0._panel_width = 500
  l_1_0._lines = {}
  l_1_0._esc_callback = callback(l_1_0, l_1_0, "esc_key_callback")
  l_1_0._enter_callback = callback(l_1_0, l_1_0, "enter_key_callback")
  l_1_0._typing_callback = 0
  l_1_0._skip_first = false
  l_1_0._panel = l_1_0._hud_panel:panel({name = "chat_panel", x = 0, h = 500, w = l_1_0._panel_width, valign = "bottom"})
  l_1_0._panel:set_bottom(l_1_0._panel:parent():h() - 112)
  do
    local output_panel = l_1_0._panel:panel({name = "output_panel", x = 0, h = 10, w = l_1_0._output_width, layer = 1})
    output_panel:gradient({name = "output_bg", gradient_points = {}, layer = -1, valign = "grow", blend_mode = "sub"})
    l_1_0:_create_input_panel()
    l_1_0:_layout_input_panel()
    l_1_0:_layout_output_panel()
  end
   -- Warning: undefined locals caused missing assignments!
end

HUDChat.set_layer = function(l_2_0, l_2_1)
  l_2_0._panel:set_layer(l_2_1)
end

HUDChat.set_channel_id = function(l_3_0, l_3_1)
  managers.chat:unregister_receiver(l_3_0._channel_id, l_3_0)
  l_3_0._channel_id = l_3_1
  managers.chat:register_receiver(l_3_0._channel_id, l_3_0)
end

HUDChat.esc_key_callback = function(l_4_0)
  managers.hud:set_chat_focus(false)
end

HUDChat.enter_key_callback = function(l_5_0)
  local text = l_5_0._input_panel:child("input_text")
  local message = text:text()
  if string.len(message) > 0 then
    local u_name = managers.network.account:username()
    managers.chat:send_message(l_5_0._channel_id, u_name or "Offline", message)
  end
  text:set_text("")
  text:set_selection(0, 0)
  managers.hud:set_chat_focus(false)
end

HUDChat._create_input_panel = function(l_6_0)
  l_6_0._input_panel = l_6_0._panel:panel({alpha = 0, name = "input_panel", x = 0, h = 24, w = l_6_0._panel_width, layer = 1})
  l_6_0._input_panel:rect({name = "focus_indicator", visible = false, color = Color.white:with_alpha(0.20000000298023), layer = 0})
   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

  local say = l_6_0._input_panel:text({name = "say", text = utf8.to_upper(managers.localization:text("debug_chat_say")), font = tweak_data.menu.small_font, font_size = tweak_data.menu.small_font_size, x = 0, y = 0, align = "left", halign = "left", vertical = "center", hvertical = "center"})
  local _, _, w, h = say:text_rect()
  say:set_size(w, l_6_0._input_panel:h())
  {name = "say", text = utf8.to_upper(managers.localization:text("debug_chat_say")), font = tweak_data.menu.small_font, font_size = tweak_data.menu.small_font_size, x = 0, y = 0, align = "left", halign = "left", vertical = "center", hvertical = "center"}.layer, {name = "say", text = utf8.to_upper(managers.localization:text("debug_chat_say")), font = tweak_data.menu.small_font, font_size = tweak_data.menu.small_font_size, x = 0, y = 0, align = "left", halign = "left", vertical = "center", hvertical = "center"}.color, {name = "say", text = utf8.to_upper(managers.localization:text("debug_chat_say")), font = tweak_data.menu.small_font, font_size = tweak_data.menu.small_font_size, x = 0, y = 0, align = "left", halign = "left", vertical = "center", hvertical = "center"}.blend_mode = 1, Color.white, "normal"
   -- DECOMPILER ERROR: Confused about usage of registers!

  local input_text = l_6_0._input_panel:text({name = "input_text", text = "", font = tweak_data.menu.small_font_noshadow, font_size = tweak_data.menu.small_font_size, x = 0, y = 0, align = "left", halign = "left", vertical = "center", hvertical = "center", blend_mode = "normal", color = Color.white, layer = 1, wrap = true})
  do
    local caret = l_6_0._input_panel:rect({name = "caret", layer = 2, x = 0, y = 0, w = 0, h = 0, color = Color(0.050000000745058, 1, 1, 1)})
     -- DECOMPILER ERROR: Overwrote pending register.

    l_6_0._input_panel:gradient({name = "input_bg", gradient_points = {}, layer = -1, valign = "grow", blend_mode = "sub", h = l_6_0._input_panel:h()})
  end
   -- Warning: undefined locals caused missing assignments!
end

HUDChat._layout_output_panel = function(l_7_0)
  local output_panel = l_7_0._panel:child("output_panel")
  output_panel:set_w(l_7_0._output_width)
  local lines = 0
  for i = #l_7_0._lines, 1, -1 do
    local line = l_7_0._lines[i]
    line:set_w(output_panel:w())
    local _, _, w, h = line:text_rect()
    line:set_h(h)
    lines = lines + line:number_of_lines()
  end
  output_panel:set_h(21 * math.min(10, lines))
  local y = 0
  for i = #l_7_0._lines, 1, -1 do
    local line = l_7_0._lines[i]
    local _, _, w, h = line:text_rect()
    line:set_bottom(output_panel:h() - y)
    y = y + h
  end
  output_panel:set_bottom(l_7_0._input_panel:top())
end

HUDChat._layout_input_panel = function(l_8_0)
  l_8_0._input_panel:set_w(l_8_0._panel_width)
  local say = l_8_0._input_panel:child("say")
  local input_text = l_8_0._input_panel:child("input_text")
  input_text:set_left(say:right() + 4)
  input_text:set_w(l_8_0._input_panel:w() - input_text:left())
  local focus_indicator = l_8_0._input_panel:child("focus_indicator")
  focus_indicator:set_shape(input_text:shape())
  l_8_0._input_panel:set_y(l_8_0._input_panel:parent():h() - l_8_0._input_panel:h())
end

HUDChat.input_focus = function(l_9_0)
  return l_9_0._focus
end

HUDChat.set_skip_first = function(l_10_0, l_10_1)
  l_10_0._skip_first = l_10_1
end

HUDChat._on_focus = function(l_11_0)
  if l_11_0._focus then
    return 
  end
  local output_panel = l_11_0._panel:child("output_panel")
  output_panel:stop()
  output_panel:animate(callback(l_11_0, l_11_0, "_animate_show_component"), output_panel:alpha())
  l_11_0._input_panel:stop()
  l_11_0._input_panel:animate(callback(l_11_0, l_11_0, "_animate_show_component"))
  l_11_0._focus = true
  l_11_0._input_panel:child("focus_indicator"):set_color(Color(0.80000001192093, 1, 0.80000001192093):with_alpha(0.20000000298023))
  l_11_0._ws:connect_keyboard(Input:keyboard())
  l_11_0._input_panel:key_press(callback(l_11_0, l_11_0, "key_press"))
  l_11_0._input_panel:key_release(callback(l_11_0, l_11_0, "key_release"))
  l_11_0._enter_text_set = false
  l_11_0._input_panel:child("input_bg"):animate(callback(l_11_0, l_11_0, "_animate_input_bg"))
  l_11_0:set_layer(2000)
  l_11_0:update_caret()
end

HUDChat._loose_focus = function(l_12_0)
  if not l_12_0._focus then
    return 
  end
  l_12_0._focus = false
  l_12_0._input_panel:child("focus_indicator"):set_color(Color.white:with_alpha(0.20000000298023))
  l_12_0._ws:disconnect_keyboard()
  l_12_0._input_panel:key_press(nil)
  l_12_0._input_panel:enter_text(nil)
  l_12_0._input_panel:key_release(nil)
  l_12_0._panel:child("output_panel"):stop()
  l_12_0._panel:child("output_panel"):animate(callback(l_12_0, l_12_0, "_animate_fade_output"))
  l_12_0._input_panel:stop()
  l_12_0._input_panel:animate(callback(l_12_0, l_12_0, "_animate_hide_input"))
  local text = l_12_0._input_panel:child("input_text")
  text:stop()
  l_12_0._input_panel:child("input_bg"):stop()
  l_12_0:set_layer(0)
  l_12_0:update_caret()
end

HUDChat._shift = function(l_13_0)
  local k = Input:keyboard()
  if not k:down("left shift") and not k:down("right shift") and k:has_button("shift") then
    return k:down("shift")
  end
end

HUDChat.blink = function(l_14_0)
  repeat
    l_14_0:set_color(Color(0, 1, 1, 1))
    wait(0.30000001192093)
    l_14_0:set_color(Color.white)
    wait(0.30000001192093)
    do return end
     -- Warning: missing end command somewhere! Added here
  end
end

HUDChat.set_blinking = function(l_15_0, l_15_1)
  local caret = l_15_0._input_panel:child("caret")
  if l_15_1 == l_15_0._blinking then
    return 
  end
  if l_15_1 then
    caret:animate(l_15_0.blink)
  else
    caret:stop()
  end
  l_15_0._blinking = l_15_1
  if not l_15_0._blinking then
    caret:set_color(Color.white)
  end
end

HUDChat.update_caret = function(l_16_0)
  local text = l_16_0._input_panel:child("input_text")
  local caret = l_16_0._input_panel:child("caret")
  local s, e = text:selection()
  local x, y, w, h = text:selection_rect()
  if s == 0 and e == 0 then
    if text:align() == "center" then
      x = text:world_x() + text:w() / 2
    else
      x = text:world_x()
    end
    y = text:world_y()
  end
  h = text:h()
  if w < 3 then
    w = 3
  end
  if not l_16_0._focus then
    w = 0
    h = 0
  end
  caret:set_world_shape(x, y + 2, w, h - 4)
  l_16_0:set_blinking((s == e and l_16_0._focus))
  do
    local mid = x / l_16_0._input_panel:child("input_bg"):w()
    l_16_0._input_panel:child("input_bg"):set_gradient_points({})
  end
   -- Warning: undefined locals caused missing assignments!
end

HUDChat.enter_text = function(l_17_0, l_17_1, l_17_2)
  if managers.hud and managers.hud:showing_stats_screen() then
    return 
  end
  if l_17_0._skip_first then
    l_17_0._skip_first = false
    return 
  end
  local text = l_17_0._input_panel:child("input_text")
  if type(l_17_0._typing_callback) ~= "number" then
    l_17_0._typing_callback()
  end
  text:replace_text(l_17_2)
  local lbs = text:line_breaks()
  if #lbs > 1 then
    local s = lbs[2]
    local e = utf8.len(text:text())
    text:set_selection(s, e)
    text:replace_text("")
  end
  l_17_0:update_caret()
end

HUDChat.update_key_down = function(l_18_0, l_18_1, l_18_2)
  wait(0.60000002384186)
  local text = l_18_0._input_panel:child("input_text")
  repeat
    if l_18_0._key_pressed == l_18_2 then
      local s, e = text:selection()
      local n = utf8.len(text:text())
      local d = math.abs(e - s)
      if l_18_0._key_pressed == Idstring("backspace") then
        if s == e and s > 0 then
          text:set_selection(s - 1, e)
        end
        text:replace_text("")
      else
        if utf8.len(text:text()) < 1 and type(l_18_0._esc_callback) ~= "number" then
          if l_18_0._key_pressed == Idstring("delete") then
            if s == e and s < n then
              text:set_selection(s, e + 1)
            end
            text:replace_text("")
          else
            if utf8.len(text:text()) < 1 and type(l_18_0._esc_callback) ~= "number" then
              if l_18_0._key_pressed == Idstring("left") then
                if s < e then
                  text:set_selection(s, s)
                elseif s > 0 then
                  text:set_selection(s - 1, s - 1)
                else
                  if l_18_0._key_pressed == Idstring("right") then
                    if s < e then
                      text:set_selection(e, e)
                    elseif s < n then
                      text:set_selection(s + 1, s + 1)
                    else
                      l_18_0._key_pressed = false
                    end
                  end
                end
              end
            end
          end
        end
      end
      l_18_0:update_caret()
      wait(0.029999999329448)
    else
       -- Warning: missing end command somewhere! Added here
    end
     -- Warning: missing end command somewhere! Added here
  end
end

HUDChat.key_release = function(l_19_0, l_19_1, l_19_2)
  if l_19_0._key_pressed == l_19_2 then
    l_19_0._key_pressed = false
  end
end

HUDChat.key_press = function(l_20_0, l_20_1, l_20_2)
  if l_20_0._skip_first then
    l_20_0._skip_first = false
    return 
  end
  if not l_20_0._enter_text_set then
    l_20_0._input_panel:enter_text(callback(l_20_0, l_20_0, "enter_text"))
    l_20_0._enter_text_set = true
  end
  local text = l_20_0._input_panel:child("input_text")
  local s, e = text:selection()
  local n = utf8.len(text:text())
  local d = math.abs(e - s)
  l_20_0._key_pressed = l_20_2
  text:stop()
  text:animate(callback(l_20_0, l_20_0, "update_key_down"), l_20_2)
  if l_20_2 == Idstring("backspace") then
    if s == e and s > 0 then
      text:set_selection(s - 1, e)
    end
    text:replace_text("")
  else
    if utf8.len(text:text()) < 1 and type(l_20_0._esc_callback) ~= "number" then
      if l_20_2 == Idstring("delete") then
        if s == e and s < n then
          text:set_selection(s, e + 1)
        end
        text:replace_text("")
      else
        if utf8.len(text:text()) < 1 and type(l_20_0._esc_callback) ~= "number" then
          if l_20_2 == Idstring("left") then
            if s < e then
              text:set_selection(s, s)
            elseif s > 0 then
              text:set_selection(s - 1, s - 1)
            else
              if l_20_2 == Idstring("right") then
                if s < e then
                  text:set_selection(e, e)
                elseif s < n then
                  text:set_selection(s + 1, s + 1)
                else
                  if l_20_0._key_pressed == Idstring("end") then
                    text:set_selection(n, n)
                  else
                    if l_20_0._key_pressed == Idstring("home") then
                      text:set_selection(0, 0)
                    else
                       -- DECOMPILER ERROR: unhandled construct in 'if'

                      if l_20_2 == Idstring("enter") and type(l_20_0._enter_callback) ~= "number" then
                        l_20_0._enter_callback()
                        do return end
                        if l_20_2 == Idstring("esc") and type(l_20_0._esc_callback) ~= "number" then
                          text:set_text("")
                          text:set_selection(0, 0)
                          l_20_0._esc_callback()
                        end
                      end
                    end
                  end
                end
              end
            end
          end
        end
      end
    end
  end
  l_20_0:update_caret()
end

HUDChat.send_message = function(l_21_0, l_21_1, l_21_2)
end

HUDChat.receive_message = function(l_22_0, l_22_1, l_22_2, l_22_3)
  local output_panel = l_22_0._panel:child("output_panel")
  local len = utf8.len(l_22_1) + 1
   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

  local line = output_panel:text({text = l_22_1 .. ": " .. l_22_2, font = tweak_data.menu.small_font, font_size = tweak_data.menu.small_font_size, x = 0, y = 0, align = "left", halign = "left", vertical = "top", hvertical = "top", blend_mode = "normal", wrap = true, word_wrap = true})
  local total_len = utf8.len(line:text())
  line:set_range_color(0, len, l_22_3)
  {text = l_22_1 .. ": " .. l_22_2, font = tweak_data.menu.small_font, font_size = tweak_data.menu.small_font_size, x = 0, y = 0, align = "left", halign = "left", vertical = "top", hvertical = "top", blend_mode = "normal", wrap = true, word_wrap = true}.layer, {text = l_22_1 .. ": " .. l_22_2, font = tweak_data.menu.small_font, font_size = tweak_data.menu.small_font_size, x = 0, y = 0, align = "left", halign = "left", vertical = "top", hvertical = "top", blend_mode = "normal", wrap = true, word_wrap = true}.color = 0, l_22_3
  line:set_range_color(len, total_len, Color.white)
  local _, _, w, h = line:text_rect()
  line:set_h(h)
  table.insert(l_22_0._lines, line)
  l_22_0:_layout_output_panel()
  if not l_22_0._focus then
    local output_panel = l_22_0._panel:child("output_panel")
    output_panel:stop()
    output_panel:animate(callback(l_22_0, l_22_0, "_animate_show_component"), output_panel:alpha())
    output_panel:animate(callback(l_22_0, l_22_0, "_animate_fade_output"))
  end
end

HUDChat._animate_fade_output = function(l_23_0)
  local wait_t = 10
  local fade_t = 1
  local t = 0
  repeat
    if t < wait_t then
      local dt = coroutine.yield()
      t = t + dt
    do
      else
        local t = 0
        repeat
          if t < fade_t then
            local dt = coroutine.yield()
            t = t + dt
            l_23_0:set_output_alpha(1 - (t) / fade_t)
          else
            l_23_0:set_output_alpha(0)
          end
           -- Warning: missing end command somewhere! Added here
        end
         -- Warning: missing end command somewhere! Added here
      end
       -- Warning: missing end command somewhere! Added here
    end
     -- Warning: missing end command somewhere! Added here
  end
end

HUDChat._animate_show_component = function(l_24_0, l_24_1, l_24_2)
  local TOTAL_T = 0.25
  do
    local t = 0
    if not l_24_2 then
      l_24_2 = 0
    end
    repeat
      if t < TOTAL_T then
        local dt = coroutine.yield()
        t = t + dt
        l_24_1:set_alpha(l_24_2 + (t) / TOTAL_T * (1 - l_24_2))
      else
        l_24_1:set_alpha(1)
      end
       -- Warning: missing end command somewhere! Added here
    end
     -- Warning: missing end command somewhere! Added here
  end
end

HUDChat._animate_hide_input = function(l_25_0, l_25_1)
  local TOTAL_T = 0.25
  do
    local t = 0
    repeat
      if t < TOTAL_T then
        local dt = coroutine.yield()
        t = t + dt
        l_25_1:set_alpha(1 - (t) / TOTAL_T)
      else
        l_25_1:set_alpha(0)
      end
       -- Warning: missing end command somewhere! Added here
    end
     -- Warning: missing end command somewhere! Added here
  end
end

HUDChat._animate_input_bg = function(l_26_0, l_26_1)
  do
    local t = 0
    repeat
      local dt = coroutine.yield()
      t = t + dt
      do
        local a = 0.75 + (1 + math.sin((t) * 200)) / 8
        l_26_1:set_alpha(a)
      end
      do return end
    end
     -- Warning: missing end command somewhere! Added here
  end
end

HUDChat.set_output_alpha = function(l_27_0, l_27_1)
  l_27_0._panel:child("output_panel"):set_alpha(l_27_1)
end

HUDChat.remove = function(l_28_0)
  l_28_0._panel:child("output_panel"):stop()
  l_28_0._input_panel:stop()
  l_28_0._hud_panel:remove(l_28_0._panel)
  managers.chat:unregister_receiver(l_28_0._channel_id, l_28_0)
end


