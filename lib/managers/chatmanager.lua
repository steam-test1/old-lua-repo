-- Decompiled using luadec 2.0.1 by sztupy (http://winmo.sztupy.hu)
-- Command line was: F:\SteamLibrary\SteamApps\common\PAYDAY 2\lua\lib\managers\chatmanager.luac 

if not ChatManager then
  ChatManager = class()
end
ChatManager.GAME = 1
ChatManager.CREW = 2
ChatManager.GLOBAL = 3
ChatManager.init = function(l_1_0)
  l_1_0:_setup()
end

ChatManager._setup = function(l_2_0)
  l_2_0._chatlog = {}
  l_2_0._receivers = {}
end

ChatManager.register_receiver = function(l_3_0, l_3_1, l_3_2)
  if not l_3_0._receivers[l_3_1] then
    l_3_0._receivers[l_3_1] = {}
  end
  table.insert(l_3_0._receivers[l_3_1], l_3_2)
end

ChatManager.unregister_receiver = function(l_4_0, l_4_1, l_4_2)
  if not l_4_0._receivers[l_4_1] then
    return 
  end
  for i,rec in ipairs(l_4_0._receivers[l_4_1]) do
    if rec == l_4_2 then
      table.remove(l_4_0._receivers[l_4_1], i)
  else
    end
  end
end

ChatManager.send_message = function(l_5_0, l_5_1, l_5_2, l_5_3)
  if managers.network:session() then
    l_5_2 = managers.network:session():local_peer()
    managers.network:session():send_to_peers_ip_verified("send_chat_message", l_5_1, l_5_3)
    l_5_0:receive_message_by_peer(l_5_1, l_5_2, l_5_3)
  else
    l_5_0:receive_message_by_name(l_5_1, l_5_2, l_5_3)
  end
end

ChatManager.receive_message_by_peer = function(l_6_0, l_6_1, l_6_2, l_6_3)
  local color_id = l_6_2:id()
  local color = tweak_data.chat_colors[color_id]
  l_6_0:_receive_message(l_6_1, l_6_2:name(), l_6_3, tweak_data.chat_colors[color_id])
end

ChatManager.receive_message_by_name = function(l_7_0, l_7_1, l_7_2, l_7_3)
  l_7_0:_receive_message(l_7_1, l_7_2, l_7_3, tweak_data.chat_colors[1])
end

ChatManager._receive_message = function(l_8_0, l_8_1, l_8_2, l_8_3, l_8_4)
  if not l_8_0._receivers[l_8_1] then
    return 
  end
  for i,receiver in ipairs(l_8_0._receivers[l_8_1]) do
    receiver:receive_message(l_8_2, l_8_3, l_8_4)
  end
end

ChatManager.save = function(l_9_0, l_9_1)
end

ChatManager.load = function(l_10_0, l_10_1)
end

if not ChatBase then
  ChatBase = class()
end
ChatBase.init = function(l_11_0)
end

ChatBase.receive_message = function(l_12_0, l_12_1, l_12_2, l_12_3)
end

if not ChatGui then
  ChatGui = class(ChatBase)
end
ChatGui.init = function(l_13_0, l_13_1)
  l_13_0._ws = l_13_1
  l_13_0._hud_panel = l_13_1:panel()
  l_13_0:set_channel_id(ChatManager.GAME)
  l_13_0._output_width = l_13_0._hud_panel:w() * 0.5 - 10
  l_13_0._panel_width = l_13_0._hud_panel:w() * 0.5 - 10
  l_13_0._panel_height = 500
  l_13_0._max_lines = 15
  l_13_0._lines = {}
  l_13_0._esc_callback = callback(l_13_0, l_13_0, "esc_key_callback")
  l_13_0._enter_callback = callback(l_13_0, l_13_0, "enter_key_callback")
  l_13_0._typing_callback = 0
  l_13_0._skip_first = false
  l_13_0._panel = l_13_0._hud_panel:panel({name = "chat_panel", x = 0, h = l_13_0._panel_height, w = l_13_0._panel_width, valign = "bottom"})
  l_13_0:set_leftbottom(0, 70)
  l_13_0._panel:set_layer(20)
  local output_panel = l_13_0._panel:panel({name = "output_panel", x = 20, h = 10, w = l_13_0._output_width - 20, layer = 1})
  local scroll_panel = output_panel:panel({name = "scroll_panel", x = 0, h = 10, w = l_13_0._output_width})
  l_13_0._scroll_indicator_box_class = BoxGuiObject:new(output_panel, {sides = {0, 0, 0, 0}})
  local scroll_up_indicator_shade = output_panel:bitmap({name = "scroll_up_indicator_shade", texture = "guis/textures/headershadow", rotation = 180, layer = 2, color = Color.white, w = output_panel:w()})
  local texture, rect = tweak_data.hud_icons:get_icon_data("scroll_up")
  local scroll_up_indicator_arrow = l_13_0._panel:bitmap({name = "scroll_up_indicator_arrow", texture = texture, texture_rect = rect, layer = 2, color = Color.white})
  local scroll_down_indicator_shade = output_panel:bitmap({name = "scroll_down_indicator_shade", texture = "guis/textures/headershadow", layer = 2, color = Color.white, w = output_panel:w()})
  local texture, rect = tweak_data.hud_icons:get_icon_data("scroll_dn")
  local scroll_down_indicator_arrow = l_13_0._panel:bitmap({name = "scroll_down_indicator_arrow", texture = texture, texture_rect = rect, layer = 2, color = Color.white})
  local bar_h = scroll_down_indicator_arrow:top() - scroll_up_indicator_arrow:bottom()
  local texture, rect = tweak_data.hud_icons:get_icon_data("scrollbar")
  local scroll_bar = l_13_0._panel:panel({name = "scroll_bar", layer = 2, h = bar_h, w = 15})
  local scroll_bar_box_panel = scroll_bar:panel({name = "scroll_bar_box_panel", w = 4, x = 5, halign = "scale", valign = "scale"})
  l_13_0._scroll_bar_box_class = BoxGuiObject:new(scroll_bar_box_panel, {sides = {2, 2, 0, 0}})
  l_13_0._enabled = true
  output_panel:set_x(scroll_down_indicator_arrow:w() + 4)
  l_13_0:_create_input_panel()
  l_13_0:_layout_input_panel()
  l_13_0:_layout_output_panel()
end

ChatGui.set_leftbottom = function(l_14_0, l_14_1, l_14_2)
  l_14_0._panel:set_left(l_14_1)
  l_14_0._panel:set_bottom(l_14_0._panel:parent():h() - l_14_2)
end

ChatGui.set_max_lines = function(l_15_0, l_15_1)
  l_15_0._max_lines = l_15_1
  l_15_0:_layout_output_panel()
end

ChatGui.set_params = function(l_16_0, l_16_1)
  if l_16_1.max_lines then
    l_16_0:set_max_lines(l_16_1.max_lines)
  end
  if l_16_1.left and l_16_1.bottom then
    l_16_0:set_leftbottom(l_16_1.left, l_16_1.bottom)
  end
end

ChatGui.enabled = function(l_17_0)
  return l_17_0._enabled
end

ChatGui.set_enabled = function(l_18_0, l_18_1)
  if not l_18_1 then
    l_18_0:_loose_focus()
  end
  l_18_0._enabled = l_18_1
end

ChatGui.hide = function(l_19_0)
  l_19_0._panel:hide()
  l_19_0:set_enabled(false)
  local text = l_19_0._input_panel:child("input_text")
  text:set_text("")
  text:set_selection(0, 0)
end

ChatGui.show = function(l_20_0)
  l_20_0._panel:show()
  l_20_0:set_enabled(true)
end

ChatGui.set_layer = function(l_21_0, l_21_1)
  l_21_0._panel:set_layer(l_21_1)
end

ChatGui.set_channel_id = function(l_22_0, l_22_1)
  managers.chat:unregister_receiver(l_22_0._channel_id, l_22_0)
  l_22_0._channel_id = l_22_1
  managers.chat:register_receiver(l_22_0._channel_id, l_22_0)
end

ChatGui.esc_key_callback = function(l_23_0)
  if not l_23_0._enabled then
    return 
  end
  l_23_0._esc_focus_delay = true
  l_23_0:_loose_focus()
end

ChatGui.enter_key_callback = function(l_24_0)
  if not l_24_0._enabled then
    return 
  end
  local text = l_24_0._input_panel:child("input_text")
  local message = text:text()
  if Idstring(message) == Idstring("/ready") then
    managers.menu_component:on_ready_pressed_mission_briefing_gui()
  else
    if string.len(message) > 0 then
      local u_name = managers.network.account:username()
      managers.chat:send_message(l_24_0._channel_id, u_name or "Offline", message)
    else
      l_24_0._enter_loose_focus_delay = true
      l_24_0:_loose_focus()
    end
  end
  text:set_text("")
  text:set_selection(0, 0)
end

ChatGui._create_input_panel = function(l_25_0)
  l_25_0._input_panel = l_25_0._panel:panel({alpha = 0, name = "input_panel", x = 0, h = 24, w = l_25_0._panel_width, layer = 1})
  l_25_0._input_panel:rect({name = "focus_indicator", visible = false, color = Color.black:with_alpha(0.20000000298023), layer = 0})
   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

  local say = l_25_0._input_panel:text({name = "say", text = utf8.to_upper(managers.localization:text("debug_chat_say")), font = tweak_data.menu.pd2_small_font, font_size = tweak_data.menu.pd2_small_font_size, x = 0, y = 0, align = "left", halign = "left", vertical = "center", hvertical = "center"})
  local _, _, w, h = say:text_rect()
  say:set_size(w, l_25_0._input_panel:h())
  {name = "say", text = utf8.to_upper(managers.localization:text("debug_chat_say")), font = tweak_data.menu.pd2_small_font, font_size = tweak_data.menu.pd2_small_font_size, x = 0, y = 0, align = "left", halign = "left", vertical = "center", hvertical = "center"}.layer, {name = "say", text = utf8.to_upper(managers.localization:text("debug_chat_say")), font = tweak_data.menu.pd2_small_font, font_size = tweak_data.menu.pd2_small_font_size, x = 0, y = 0, align = "left", halign = "left", vertical = "center", hvertical = "center"}.color, {name = "say", text = utf8.to_upper(managers.localization:text("debug_chat_say")), font = tweak_data.menu.pd2_small_font, font_size = tweak_data.menu.pd2_small_font_size, x = 0, y = 0, align = "left", halign = "left", vertical = "center", hvertical = "center"}.blend_mode = 1, Color.white, "normal"
   -- DECOMPILER ERROR: Confused about usage of registers!

  local input_text = l_25_0._input_panel:text({name = "input_text", text = "", font = tweak_data.menu.pd2_small_font, font_size = tweak_data.menu.pd2_small_font_size, x = 0, y = 0, align = "left", halign = "left", vertical = "center", hvertical = "center", blend_mode = "normal", color = Color.white, layer = 1, wrap = true})
  local caret = l_25_0._input_panel:rect({name = "caret", layer = 2, x = 0, y = 0, w = 0, h = 0, color = Color(0.050000000745058, 1, 1, 1)})
  l_25_0._input_panel:rect({name = "input_bg", color = Color.black:with_alpha(0.5), layer = -1, valign = "grow", h = l_25_0._input_panel:h()})
  {name = "input_text", text = "", font = tweak_data.menu.pd2_small_font, font_size = tweak_data.menu.pd2_small_font_size, x = 0, y = 0, align = "left", halign = "left", vertical = "center", hvertical = "center", blend_mode = "normal", color = Color.white, layer = 1, wrap = true}.word_wrap = false
  l_25_0._input_panel:child("input_bg"):set_w(l_25_0._input_panel:w() - w)
  l_25_0._input_panel:child("input_bg"):set_x(w)
  l_25_0._input_panel:stop()
  l_25_0._input_panel:animate(callback(l_25_0, l_25_0, "_animate_hide_input"))
end

ChatGui._layout_output_panel = function(l_26_0)
  local output_panel = l_26_0._panel:child("output_panel")
  local scroll_panel = output_panel:child("scroll_panel")
  scroll_panel:set_w(l_26_0._output_width)
  output_panel:set_w(l_26_0._output_width)
  local lines = 0
  for i = #l_26_0._lines, 1, -1 do
    local line = l_26_0._lines[i][1]
    local line_bg = l_26_0._lines[i][2]
    line:set_w(output_panel:w())
    local _, _, w, h = line:text_rect()
    line:set_h(h)
    line_bg:set_w(w + 2)
    line_bg:set_h(h)
    lines = lines + line:number_of_lines()
  end
  local line_height = 22
  local max_lines = l_26_0._max_lines
  local scroll_at_bottom = scroll_panel:bottom() == output_panel:h()
  output_panel:set_h(math.round(line_height * math.min(max_lines, lines)))
  scroll_panel:set_h(math.round(line_height * (lines)))
  local y = 0
  for i = #l_26_0._lines, 1, -1 do
    local line = l_26_0._lines[i][1]
    local line_bg = l_26_0._lines[i][2]
    local _, _, w, h = line:text_rect()
    line:set_bottom(scroll_panel:h() - y)
    line_bg:set_bottom(line:bottom())
    line:set_left(line:left())
    y = y + h
  end
  output_panel:set_bottom(math.round(l_26_0._input_panel:top()))
  if lines <= max_lines or scroll_at_bottom then
    scroll_panel:set_bottom(output_panel:h())
  end
  l_26_0:set_scroll_indicators()
end

ChatGui._layout_input_panel = function(l_27_0)
  l_27_0._input_panel:set_w(l_27_0._panel_width - l_27_0._input_panel:x())
  local say = l_27_0._input_panel:child("say")
  local input_text = l_27_0._input_panel:child("input_text")
  input_text:set_left(say:right() + 4)
  input_text:set_w(l_27_0._input_panel:w() - input_text:left())
  l_27_0._input_panel:child("input_bg"):set_w(input_text:w())
  l_27_0._input_panel:child("input_bg"):set_x(input_text:x())
  local focus_indicator = l_27_0._input_panel:child("focus_indicator")
  focus_indicator:set_shape(input_text:shape())
  l_27_0._input_panel:set_y(l_27_0._input_panel:parent():h() - l_27_0._input_panel:h())
  l_27_0._input_panel:set_x(l_27_0._panel:child("output_panel"):x())
end

ChatGui.set_scroll_indicators = function(l_28_0)
  local output_panel = l_28_0._panel:child("output_panel")
  local scroll_panel = output_panel:child("scroll_panel")
  local scroll_up_indicator_shade = output_panel:child("scroll_up_indicator_shade")
  local scroll_up_indicator_arrow = l_28_0._panel:child("scroll_up_indicator_arrow")
  local scroll_down_indicator_shade = output_panel:child("scroll_down_indicator_shade")
  local scroll_down_indicator_arrow = l_28_0._panel:child("scroll_down_indicator_arrow")
  local scroll_bar = l_28_0._panel:child("scroll_bar")
  scroll_up_indicator_shade:set_top(0)
  scroll_down_indicator_shade:set_bottom(output_panel:h())
  scroll_up_indicator_arrow:set_righttop(output_panel:left() - 2, output_panel:top() + 2)
  scroll_down_indicator_arrow:set_rightbottom(output_panel:left() - 2, output_panel:bottom() - 2)
  local bar_h = scroll_down_indicator_arrow:top() - scroll_up_indicator_arrow:bottom()
  if scroll_panel:h() ~= 0 then
    local old_h = scroll_bar:h()
    scroll_bar:set_h(bar_h * output_panel:h() / scroll_panel:h())
    if old_h ~= scroll_bar:h() then
      l_28_0._scroll_bar_box_class:create_sides(scroll_bar:child("scroll_bar_box_panel"), {sides = {2, 2, 0, 0}})
    end
  end
  local sh = scroll_panel:h() ~= 0 and scroll_panel:h() or 1
  scroll_bar:set_y(scroll_up_indicator_arrow:bottom() - scroll_panel:y() * (output_panel:h() - scroll_up_indicator_arrow:h() * 2) / sh)
  scroll_bar:set_center_x(scroll_up_indicator_arrow:center_x())
  local visible = output_panel:h() < scroll_panel:h()
  local scroll_up_visible = not visible or scroll_panel:top() < 0
  local scroll_dn_visible = not visible or output_panel:h() < scroll_panel:bottom()
  l_28_0:_layout_input_panel()
  scroll_bar:set_visible(visible)
  local update_scroll_indicator_box = false
  if scroll_up_indicator_arrow:visible() ~= scroll_up_visible then
    scroll_up_indicator_shade:set_visible(false)
    scroll_up_indicator_arrow:set_visible(scroll_up_visible)
    update_scroll_indicator_box = true
  end
  if scroll_down_indicator_arrow:visible() ~= scroll_dn_visible then
    scroll_down_indicator_shade:set_visible(false)
    scroll_down_indicator_arrow:set_visible(scroll_dn_visible)
    update_scroll_indicator_box = true
  end
  l_28_0._scroll_indicator_box_class:create_sides(output_panel, {sides = {0, 0, not update_scroll_indicator_box or 0, ((not scroll_up_visible or scroll_dn_visible) and scroll_dn_visible and 2) or 0}})
end

ChatGui.set_size = function(l_29_0, l_29_1, l_29_2)
  ChatGui.super.set_size(l_29_0, l_29_1, l_29_2)
  l_29_0:_layout_output_panel()
  l_29_0:_layout_input_panel()
end

ChatGui.input_focus = function(l_30_0)
  if l_30_0._esc_focus_delay then
    l_30_0._esc_focus_delay = nil
    return 1
  end
  if l_30_0._enter_loose_focus_delay then
    l_30_0._enter_loose_focus_delay = nil
    return true
  end
  return l_30_0._focus
end

ChatGui.mouse_moved = function(l_31_0, l_31_1, l_31_2)
  if not l_31_0._enabled then
    return 
  end
  local inside = l_31_0._input_panel:inside(l_31_1, l_31_2)
  if not inside then
    l_31_0._input_panel:child("focus_indicator"):set_visible(l_31_0._focus)
  end
  if l_31_0:moved_scroll_bar(l_31_1, l_31_2) then
    return true, "grab"
  else
    if (((l_31_0._panel:child("scroll_bar"):visible() and l_31_0._panel:child("scroll_bar"):inside(l_31_1, l_31_2)) or not l_31_0._panel:child("scroll_down_indicator_arrow"):visible() or l_31_0._panel:child("scroll_down_indicator_arrow"):inside(l_31_1, l_31_2) or l_31_0._panel:child("scroll_up_indicator_arrow"):visible() and l_31_0._panel:child("scroll_up_indicator_arrow"):inside(l_31_1, l_31_2))) then
      return false, "hand"
    end
  end
  return false, not inside or "arrow"
end

ChatGui.moved_scroll_bar = function(l_32_0, l_32_1, l_32_2)
  if l_32_0._grabbed_scroll_bar then
    l_32_0._current_y = l_32_0:scroll_with_bar(l_32_2, l_32_0._current_y)
    return true
  end
  return false
end

ChatGui.scroll_with_bar = function(l_33_0, l_33_1, l_33_2)
  local line_height = 22
  local diff = l_33_2 - l_33_1
  if diff == 0 then
    return l_33_2
  end
  do
    local dir = diff / math.abs(diff)
    repeat
      repeat
        repeat
          if line_height <= math.abs(l_33_2 - l_33_1) then
            l_33_2 = l_33_2 - line_height * dir
            if dir > 0 then
              l_33_0:scroll_up()
              l_33_0:set_scroll_indicators()
          until dir < 0
          else
            l_33_0:scroll_down()
            l_33_0:set_scroll_indicators()
          end
        else
          return l_33_2
        end
         -- Warning: missing end command somewhere! Added here
      end
       -- Warning: missing end command somewhere! Added here
    end
     -- Warning: missing end command somewhere! Added here
  end
end

ChatGui.mouse_released = function(l_34_0, l_34_1, l_34_2, l_34_3, l_34_4)
  if not l_34_0._enabled then
    return 
  end
  l_34_0:release_scroll_bar()
end

ChatGui.mouse_pressed = function(l_35_0, l_35_1, l_35_2, l_35_3)
  if not l_35_0._enabled then
    return 
  end
  local inside = l_35_0._input_panel:inside(l_35_2, l_35_3)
  if inside then
    l_35_0:_on_focus()
    return true
  end
  if l_35_0._panel:child("output_panel"):inside(l_35_2, l_35_3) then
    if l_35_1 == Idstring("mouse wheel down") and l_35_0:mouse_wheel_down(l_35_2, l_35_3) then
      l_35_0:_on_focus()
      do return end
      if l_35_1 == Idstring("mouse wheel up") and l_35_0:mouse_wheel_up(l_35_2, l_35_3) then
        l_35_0:_on_focus()
        do return end
        if l_35_1 == Idstring("0") and l_35_0:check_grab_scroll_panel(l_35_2, l_35_3) then
          l_35_0:_on_focus()
        end
      end
    end
    l_35_0:set_scroll_indicators()
    return true
  else
    if l_35_1 == Idstring("0") and l_35_0:check_grab_scroll_bar(l_35_2, l_35_3) then
      l_35_0:set_scroll_indicators()
      l_35_0:_on_focus()
      return true
    end
  end
  l_35_0:_loose_focus()
end

ChatGui.check_grab_scroll_panel = function(l_36_0, l_36_1, l_36_2)
  return false
end

ChatGui.check_grab_scroll_bar = function(l_37_0, l_37_1, l_37_2)
  local scroll_bar = l_37_0._panel:child("scroll_bar")
  if scroll_bar:visible() and scroll_bar:inside(l_37_1, l_37_2) then
    l_37_0._grabbed_scroll_bar = true
    l_37_0._current_y = l_37_2
    return true
  end
  if l_37_0._panel:child("scroll_up_indicator_arrow"):visible() and l_37_0._panel:child("scroll_up_indicator_arrow"):inside(l_37_1, l_37_2) then
    l_37_0:scroll_up(l_37_1, l_37_2)
    l_37_0._pressing_arrow_up = true
    return true
  end
  if l_37_0._panel:child("scroll_down_indicator_arrow"):visible() and l_37_0._panel:child("scroll_down_indicator_arrow"):inside(l_37_1, l_37_2) then
    l_37_0:scroll_down(l_37_1, l_37_2)
    l_37_0._pressing_arrow_down = true
    return true
  end
  return false
end

ChatGui.release_scroll_bar = function(l_38_0)
  l_38_0._pressing_arrow_up = nil
  l_38_0._pressing_arrow_down = nil
  if l_38_0._grabbed_scroll_bar then
    l_38_0._grabbed_scroll_bar = nil
    return true
  end
  return false
end

ChatGui.scroll_up = function(l_39_0)
  local output_panel = l_39_0._panel:child("output_panel")
  local scroll_panel = output_panel:child("scroll_panel")
  if output_panel:h() < scroll_panel:h() then
    if scroll_panel:top() == 0 then
      l_39_0._one_scroll_dn_delay = true
    end
    scroll_panel:set_top(math.min(0, scroll_panel:top() + 22))
    return true
  end
end

ChatGui.scroll_down = function(l_40_0)
  local output_panel = l_40_0._panel:child("output_panel")
  local scroll_panel = output_panel:child("scroll_panel")
  if output_panel:h() < scroll_panel:h() then
    if scroll_panel:bottom() == output_panel:h() then
      l_40_0._one_scroll_up_delay = true
    end
    scroll_panel:set_bottom(math.max(scroll_panel:bottom() - 22, output_panel:h()))
    return true
  end
end

ChatGui.mouse_wheel_up = function(l_41_0, l_41_1, l_41_2)
  if not l_41_0._enabled then
    return 
  end
  local output_panel = l_41_0._panel:child("output_panel")
  local scroll_panel = output_panel:child("scroll_panel")
  if l_41_0._one_scroll_up_delay then
    l_41_0._one_scroll_up_delay = nil
    return true
  end
  return l_41_0:scroll_up()
end

ChatGui.mouse_wheel_down = function(l_42_0, l_42_1, l_42_2)
  if not l_42_0._enabled then
    return 
  end
  local output_panel = l_42_0._panel:child("output_panel")
  local scroll_panel = output_panel:child("scroll_panel")
  if l_42_0._one_scroll_dn_delay then
    l_42_0._one_scroll_dn_delay = nil
    return true
  end
  return l_42_0:scroll_down()
end

ChatGui.open_page = function(l_43_0)
  l_43_0:_on_focus()
end

ChatGui.close_page = function(l_44_0)
  l_44_0:_loose_focus()
end

ChatGui._on_focus = function(l_45_0)
  if not l_45_0._enabled then
    return 
  end
  if l_45_0._focus then
    return 
  end
  local output_panel = l_45_0._panel:child("output_panel")
  output_panel:stop()
  output_panel:animate(callback(l_45_0, l_45_0, "_animate_show_component"), output_panel:alpha())
  l_45_0._input_panel:stop()
  l_45_0._input_panel:animate(callback(l_45_0, l_45_0, "_animate_show_input"))
  l_45_0._focus = true
  l_45_0._input_panel:child("focus_indicator"):set_color(Color(0, 0, 0):with_alpha(0.20000000298023))
  l_45_0._ws:connect_keyboard(Input:keyboard())
  l_45_0._input_panel:key_press(callback(l_45_0, l_45_0, "key_press"))
  l_45_0._input_panel:key_release(callback(l_45_0, l_45_0, "key_release"))
  l_45_0._enter_text_set = false
  l_45_0._input_panel:child("input_bg"):animate(callback(l_45_0, l_45_0, "_animate_input_bg"))
  l_45_0:set_layer(2000)
  l_45_0:update_caret()
end

ChatGui._loose_focus = function(l_46_0)
  if not l_46_0._focus then
    return 
  end
  l_46_0._one_scroll_up_delay = nil
  l_46_0._one_scroll_dn_delay = nil
  l_46_0._focus = false
  l_46_0._input_panel:child("focus_indicator"):set_color(Color.black:with_alpha(0.20000000298023))
  l_46_0._ws:disconnect_keyboard()
  l_46_0._input_panel:key_press(nil)
  l_46_0._input_panel:enter_text(nil)
  l_46_0._input_panel:key_release(nil)
  l_46_0._panel:child("output_panel"):stop()
  l_46_0._panel:child("output_panel"):animate(callback(l_46_0, l_46_0, "_animate_fade_output"))
  l_46_0._input_panel:stop()
  l_46_0._input_panel:animate(callback(l_46_0, l_46_0, "_animate_hide_input"))
  local text = l_46_0._input_panel:child("input_text")
  text:stop()
  l_46_0._input_panel:child("input_bg"):stop()
  l_46_0:set_layer(20)
  l_46_0:update_caret()
end

ChatGui._shift = function(l_47_0)
  local k = Input:keyboard()
  if not k:down("left shift") and not k:down("right shift") and k:has_button("shift") then
    return k:down("shift")
  end
end

ChatGui.blink = function(l_48_0)
  repeat
    l_48_0:set_color(Color(0, 1, 1, 1))
    wait(0.30000001192093)
    l_48_0:set_color(Color.white)
    wait(0.30000001192093)
    do return end
     -- Warning: missing end command somewhere! Added here
  end
end

ChatGui.set_blinking = function(l_49_0, l_49_1)
  local caret = l_49_0._input_panel:child("caret")
  if l_49_1 == l_49_0._blinking then
    return 
  end
  if l_49_1 then
    caret:animate(l_49_0.blink)
  else
    caret:stop()
  end
  l_49_0._blinking = l_49_1
  if not l_49_0._blinking then
    caret:set_color(Color.white)
  end
end

ChatGui.update_caret = function(l_50_0)
  local text = l_50_0._input_panel:child("input_text")
  local caret = l_50_0._input_panel:child("caret")
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
  if not l_50_0._focus then
    w = 0
    h = 0
  end
  caret:set_world_shape(x, y + 2, w, h - 4)
  l_50_0:set_blinking((s == e and l_50_0._focus))
  local mid = x / l_50_0._input_panel:child("input_bg"):w()
  l_50_0._input_panel:child("input_bg"):set_color(Color.black:with_alpha(0.40000000596046))
end

ChatGui.enter_text = function(l_51_0, l_51_1, l_51_2)
  if managers.hud and managers.hud:showing_stats_screen() then
    return 
  end
  if l_51_0._skip_first then
    l_51_0._skip_first = false
    return 
  end
  local text = l_51_0._input_panel:child("input_text")
  if type(l_51_0._typing_callback) ~= "number" then
    l_51_0._typing_callback()
  end
  text:replace_text(l_51_2)
  local lbs = text:line_breaks()
  if #lbs > 1 then
    local s = lbs[2]
    local e = utf8.len(text:text())
    text:set_selection(s, e)
    text:replace_text("")
  end
  l_51_0:update_caret()
end

ChatGui.update_key_down = function(l_52_0, l_52_1, l_52_2)
  wait(0.60000002384186)
  local text = l_52_0._input_panel:child("input_text")
  repeat
    if l_52_0._key_pressed == l_52_2 then
      local s, e = text:selection()
      local n = utf8.len(text:text())
      local d = math.abs(e - s)
      if l_52_0._key_pressed == Idstring("backspace") then
        if s == e and s > 0 then
          text:set_selection(s - 1, e)
        end
        text:replace_text("")
      else
        if utf8.len(text:text()) < 1 and type(l_52_0._esc_callback) ~= "number" then
          if l_52_0._key_pressed == Idstring("delete") then
            if s == e and s < n then
              text:set_selection(s, e + 1)
            end
            text:replace_text("")
          else
            if utf8.len(text:text()) < 1 and type(l_52_0._esc_callback) ~= "number" then
              if l_52_0._key_pressed == Idstring("left") then
                if s < e then
                  text:set_selection(s, s)
                elseif s > 0 then
                  text:set_selection(s - 1, s - 1)
                else
                  if l_52_0._key_pressed == Idstring("right") then
                    if s < e then
                      text:set_selection(e, e)
                    elseif s < n then
                      text:set_selection(s + 1, s + 1)
                    else
                      l_52_0._key_pressed = false
                    end
                  end
                end
              end
            end
          end
        end
      end
      l_52_0:update_caret()
      wait(0.029999999329448)
    else
       -- Warning: missing end command somewhere! Added here
    end
     -- Warning: missing end command somewhere! Added here
  end
end

ChatGui.key_release = function(l_53_0, l_53_1, l_53_2)
  if l_53_0._key_pressed == l_53_2 then
    l_53_0._key_pressed = false
  end
end

ChatGui.key_press = function(l_54_0, l_54_1, l_54_2)
   -- DECOMPILER ERROR: unhandled construct in 'if'

  if l_54_0._skip_first and l_54_2 == Idstring("enter") then
    l_54_0._skip_first = false
  end
  return 
  if not l_54_0._enter_text_set then
    l_54_0._input_panel:enter_text(callback(l_54_0, l_54_0, "enter_text"))
    l_54_0._enter_text_set = true
  end
  local text = l_54_0._input_panel:child("input_text")
  local s, e = text:selection()
  local n = utf8.len(text:text())
  local d = math.abs(e - s)
  l_54_0._key_pressed = l_54_2
  text:stop()
  text:animate(callback(l_54_0, l_54_0, "update_key_down"), l_54_2)
  if l_54_2 == Idstring("backspace") then
    if s == e and s > 0 then
      text:set_selection(s - 1, e)
    end
    text:replace_text("")
  else
    if utf8.len(text:text()) < 1 and type(l_54_0._esc_callback) ~= "number" then
      if l_54_2 == Idstring("delete") then
        if s == e and s < n then
          text:set_selection(s, e + 1)
        end
        text:replace_text("")
      else
        if utf8.len(text:text()) < 1 and type(l_54_0._esc_callback) ~= "number" then
          if l_54_2 == Idstring("left") then
            if s < e then
              text:set_selection(s, s)
            elseif s > 0 then
              text:set_selection(s - 1, s - 1)
            else
              if l_54_2 == Idstring("right") then
                if s < e then
                  text:set_selection(e, e)
                elseif s < n then
                  text:set_selection(s + 1, s + 1)
                else
                  if l_54_0._key_pressed == Idstring("end") then
                    text:set_selection(n, n)
                  else
                    if l_54_0._key_pressed == Idstring("home") then
                      text:set_selection(0, 0)
                    else
                       -- DECOMPILER ERROR: unhandled construct in 'if'

                      if l_54_2 == Idstring("enter") and type(l_54_0._enter_callback) ~= "number" then
                        l_54_0._enter_callback()
                        do return end
                        if l_54_2 == Idstring("esc") and type(l_54_0._esc_callback) ~= "number" then
                          text:set_text("")
                          text:set_selection(0, 0)
                          l_54_0._esc_callback()
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
  l_54_0:update_caret()
end

ChatGui.send_message = function(l_55_0, l_55_1, l_55_2)
end

ChatGui.receive_message = function(l_56_0, l_56_1, l_56_2, l_56_3)
  if not alive(l_56_0._panel) then
    return 
  end
  local output_panel = l_56_0._panel:child("output_panel")
  local scroll_panel = output_panel:child("scroll_panel")
  local len = utf8.len(l_56_1) + 1
   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

  local line = scroll_panel:text({text = l_56_1 .. ": " .. l_56_2, font = tweak_data.menu.pd2_small_font, font_size = tweak_data.menu.pd2_small_font_size, x = 0, y = 0, align = "left", halign = "left", vertical = "top", hvertical = "top", blend_mode = "normal", wrap = true, word_wrap = true})
  local total_len = utf8.len(line:text())
  line:set_range_color(0, len, l_56_3)
  {text = l_56_1 .. ": " .. l_56_2, font = tweak_data.menu.pd2_small_font, font_size = tweak_data.menu.pd2_small_font_size, x = 0, y = 0, align = "left", halign = "left", vertical = "top", hvertical = "top", blend_mode = "normal", wrap = true, word_wrap = true}.layer, {text = l_56_1 .. ": " .. l_56_2, font = tweak_data.menu.pd2_small_font, font_size = tweak_data.menu.pd2_small_font_size, x = 0, y = 0, align = "left", halign = "left", vertical = "top", hvertical = "top", blend_mode = "normal", wrap = true, word_wrap = true}.color = 0, l_56_3
  line:set_range_color(len, total_len, Color.white)
  local _, _, w, h = line:text_rect()
  line:set_h(h)
  local line_bg = scroll_panel:rect({color = Color.black:with_alpha(0.5), layer = -1, halign = "left", hvertical = "top"})
  line_bg:set_h(h)
  table.insert(l_56_0._lines, {line, line_bg})
  l_56_0:_layout_output_panel()
  if not l_56_0._focus then
    output_panel:stop()
    output_panel:animate(callback(l_56_0, l_56_0, "_animate_show_component"), output_panel:alpha())
    output_panel:animate(callback(l_56_0, l_56_0, "_animate_fade_output"))
  end
end

ChatGui._animate_fade_output = function(l_57_0)
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
            l_57_0:set_output_alpha(1 - (t) / fade_t)
          else
            l_57_0:set_output_alpha(0)
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

ChatGui._animate_show_component = function(l_58_0, l_58_1, l_58_2)
  local TOTAL_T = 0.25
  do
    local t = 0
    if not l_58_2 then
      l_58_2 = 0
    end
    repeat
      if t < TOTAL_T then
        local dt = coroutine.yield()
        t = t + dt
        l_58_1:set_alpha(l_58_2 + (t) / TOTAL_T * (1 - l_58_2))
      else
        l_58_1:set_alpha(1)
      end
       -- Warning: missing end command somewhere! Added here
    end
     -- Warning: missing end command somewhere! Added here
  end
end

ChatGui._animate_show_input = function(l_59_0, l_59_1)
  local TOTAL_T = 0.20000000298023
  local start_alpha = l_59_1:alpha()
  local end_alpha = 1
  over(TOTAL_T, function(l_1_0)
    input_panel:set_alpha(math.lerp(start_alpha, end_alpha, l_1_0))
   end)
end

ChatGui._animate_hide_input = function(l_60_0, l_60_1)
  local TOTAL_T = 0.20000000298023
  local start_alpha = l_60_1:alpha()
  local end_alpha = 0.69999998807907
  over(TOTAL_T, function(l_1_0)
    input_panel:set_alpha(math.lerp(start_alpha, end_alpha, l_1_0))
   end)
end

ChatGui._animate_input_bg = function(l_61_0, l_61_1)
  do
    local t = 0
    repeat
      local dt = coroutine.yield()
      t = t + dt
      do
        local a = 0.75 + (1 + math.sin((t) * 200)) / 8
        l_61_1:set_alpha(a)
      end
      do return end
    end
     -- Warning: missing end command somewhere! Added here
  end
end

ChatGui.set_output_alpha = function(l_62_0, l_62_1)
  l_62_0._panel:child("output_panel"):set_alpha(l_62_1)
end

ChatGui.close = function(l_63_0, ...)
  l_63_0._panel:child("output_panel"):stop()
  l_63_0._input_panel:stop()
  l_63_0._hud_panel:remove(l_63_0._panel)
  managers.chat:unregister_receiver(l_63_0._channel_id, l_63_0)
   -- DECOMPILER ERROR: Confused about usage of registers for local variables.

end


