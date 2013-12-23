-- Decompiled using luadec 2.0.1 by sztupy (http://winmo.sztupy.hu)
-- Command line was: F:\SteamLibrary\SteamApps\common\PAYDAY 2\lua\core\lib\managers\menu\items\coremenuitemslider.luac 

core:module("CoreMenuItemSlider")
core:import("CoreMenuItem")
if not ItemSlider then
  ItemSlider = class(CoreMenuItem.Item)
end
ItemSlider.TYPE = "slider"
ItemSlider.init = function(l_1_0, l_1_1, l_1_2)
  CoreMenuItem.Item.init(l_1_0, l_1_1, l_1_2)
  l_1_0._type = "slider"
  l_1_0._min = 0
  l_1_0._max = 1
  l_1_0._step = 0.10000000149012
  l_1_0._show_value = false
  if l_1_1 then
    if not l_1_1.min then
      l_1_0._min = l_1_0._min
    end
    if not l_1_1.max then
      l_1_0._max = l_1_0._max
    end
    if not l_1_1.step then
      l_1_0._step = l_1_0._step
    end
    l_1_0._show_value = l_1_1.show_value
  end
  l_1_0._min = tonumber(l_1_0._min)
  l_1_0._max = tonumber(l_1_0._max)
  l_1_0._step = tonumber(l_1_0._step)
  l_1_0._value = l_1_0._min
end

ItemSlider.value = function(l_2_0)
  return l_2_0._value
end

ItemSlider.show_value = function(l_3_0)
  return l_3_0._show_value
end

ItemSlider.set_value = function(l_4_0, l_4_1)
  l_4_0._value = math.min(math.max(l_4_0._min, l_4_1), l_4_0._max)
  l_4_0:dirty()
end

ItemSlider.set_value_by_percentage = function(l_5_0, l_5_1)
  l_5_0:set_value(l_5_0._min + (l_5_0._max - l_5_0._min) * (l_5_1 / 100))
end

ItemSlider.set_min = function(l_6_0, l_6_1)
  l_6_0._min = l_6_1
end

ItemSlider.set_max = function(l_7_0, l_7_1)
  l_7_0._max = l_7_1
end

ItemSlider.set_step = function(l_8_0, l_8_1)
  l_8_0._step = l_8_1
end

ItemSlider.increase = function(l_9_0)
  l_9_0:set_value(l_9_0._value + l_9_0._step)
end

ItemSlider.decrease = function(l_10_0)
  l_10_0:set_value(l_10_0._value - l_10_0._step)
end

ItemSlider.percentage = function(l_11_0)
  return (l_11_0._value - l_11_0._min) / (l_11_0._max - l_11_0._min) * 100
end

ItemSlider.setup_gui = function(l_12_0, l_12_1, l_12_2)
  l_12_2.gui_panel = l_12_1.item_panel:panel({w = l_12_1.item_panel:w()})
  l_12_2.gui_text = l_12_1._text_item_part(l_12_1, l_12_2, l_12_2.gui_panel, l_12_1._right_align(l_12_1))
  l_12_2.gui_text:set_layer(l_12_1.layers.items + 1)
  local _, _, w, h = l_12_2.gui_text:text_rect()
  l_12_2.gui_panel:set_h(h)
  local bar_w = 192
   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

  l_12_2.gui_slider_bg, {visible = false, x = l_12_1._left_align(l_12_1) - bar_w, y = h / 2 - 11, w = bar_w}.layer, {visible = false, x = l_12_1._left_align(l_12_1) - bar_w, y = h / 2 - 11, w = bar_w}.color, {visible = false, x = l_12_1._left_align(l_12_1) - bar_w, y = h / 2 - 11, w = bar_w}.vertical, {visible = false, x = l_12_1._left_align(l_12_1) - bar_w, y = h / 2 - 11, w = bar_w}.halign, {visible = false, x = l_12_1._left_align(l_12_1) - bar_w, y = h / 2 - 11, w = bar_w}.align, {visible = false, x = l_12_1._left_align(l_12_1) - bar_w, y = h / 2 - 11, w = bar_w}.h = l_12_2.gui_panel:rect({visible = false, x = l_12_1._left_align(l_12_1) - bar_w, y = h / 2 - 11, w = bar_w}), l_12_1.layers.items - 1, Color.black:with_alpha(0.5), "center", "center", "center", 22
   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

  l_12_2.gui_slider_gfx, {orientation = "vertical", gradient_points = {0, _G.tweak_data.screen_colors.button_stage_3, 1, _G.tweak_data.screen_colors.button_stage_3}, x = l_12_1._left_align(l_12_1) - bar_w + 2, y = l_12_2.gui_slider_bg:y() + 2, w = (l_12_2.gui_slider_bg:w() - 4) * 0.23000000417233, h = l_12_2.gui_slider_bg:h() - 4, align = "center", halign = "center"}.layer, {orientation = "vertical", gradient_points = {0, _G.tweak_data.screen_colors.button_stage_3, 1, _G.tweak_data.screen_colors.button_stage_3}, x = l_12_1._left_align(l_12_1) - bar_w + 2, y = l_12_2.gui_slider_bg:y() + 2, w = (l_12_2.gui_slider_bg:w() - 4) * 0.23000000417233, h = l_12_2.gui_slider_bg:h() - 4, align = "center", halign = "center"}.color, {orientation = "vertical", gradient_points = {0, _G.tweak_data.screen_colors.button_stage_3, 1, _G.tweak_data.screen_colors.button_stage_3}, x = l_12_1._left_align(l_12_1) - bar_w + 2, y = l_12_2.gui_slider_bg:y() + 2, w = (l_12_2.gui_slider_bg:w() - 4) * 0.23000000417233, h = l_12_2.gui_slider_bg:h() - 4, align = "center", halign = "center"}.blend_mode, {orientation = "vertical", gradient_points = {0, _G.tweak_data.screen_colors.button_stage_3, 1, _G.tweak_data.screen_colors.button_stage_3}, x = l_12_1._left_align(l_12_1) - bar_w + 2, y = l_12_2.gui_slider_bg:y() + 2, w = (l_12_2.gui_slider_bg:w() - 4) * 0.23000000417233, h = l_12_2.gui_slider_bg:h() - 4, align = "center", halign = "center"}.vertical = l_12_2.gui_panel:gradient({orientation = "vertical", gradient_points = {0, _G.tweak_data.screen_colors.button_stage_3, 1, _G.tweak_data.screen_colors.button_stage_3}, x = l_12_1._left_align(l_12_1) - bar_w + 2, y = l_12_2.gui_slider_bg:y() + 2, w = (l_12_2.gui_slider_bg:w() - 4) * 0.23000000417233, h = l_12_2.gui_slider_bg:h() - 4, align = "center", halign = "center"}), l_12_1.layers.items, l_12_2.color, l_12_1.row_item_blend_mode or "normal", "center"
  l_12_2.gui_slider = l_12_2.gui_panel:rect({color = l_12_2.color:with_alpha(0), layer = l_12_1.layers.items, w = 100, h = l_12_2.gui_slider_bg:h() - 4})
  l_12_2.gui_slider_marker = l_12_2.gui_panel:bitmap({visible = false, texture = "guis/textures/menu_icons", texture_rect = {0, 0, 24, 28}, layer = l_12_1.layers.items + 2})
  if (l_12_2.align ~= "left" or not "right") and (l_12_2.align ~= "right" or not "left") then
    local slider_text_align = l_12_2.align
  end
  if (l_12_2.slider_text_halign ~= "left" or not "right") and (l_12_2.slider_text_halign ~= "right" or not "left") then
    local slider_text_halign = l_12_2.slider_text_halign
  end
  if (l_12_2.vertical ~= "top" or not "bottom") and (l_12_2.vertical ~= "bottom" or not "top") then
    local slider_text_vertical = l_12_2.vertical
  end
   -- DECOMPILER ERROR: Confused about usage of registers!

  l_12_2.gui_slider_text, {font_size = _G.tweak_data.menu.stats_font_size, x = l_12_1._right_align(l_12_1), y = 0, h = h, w = l_12_2.gui_slider_bg:w(), align = slider_text_align, halign = slider_text_halign, vertical = slider_text_vertical, valign = slider_text_vertical, font = l_12_1.font, color = l_12_2.color, layer = l_12_1.layers.items + 1, text = "" .. math.floor(0) .. "%", blend_mode = not l_12_2.font_size and l_12_1.row_item_blend_mode or "normal"}.render_template = l_12_2.gui_panel:text({font_size = _G.tweak_data.menu.stats_font_size, x = l_12_1._right_align(l_12_1), y = 0, h = h, w = l_12_2.gui_slider_bg:w(), align = slider_text_align, halign = slider_text_halign, vertical = slider_text_vertical, valign = slider_text_vertical, font = l_12_1.font, color = l_12_2.color, layer = l_12_1.layers.items + 1, text = "" .. math.floor(0) .. "%", blend_mode = not l_12_2.font_size and l_12_1.row_item_blend_mode or "normal"}), Idstring("VertexColorTextured")
   -- DECOMPILER ERROR: Confused while interpreting a jump as a 'while'

end
l_12_0:_layout(l_12_1, l_12_2)
return true
end

ItemSlider.reload = function(l_13_0, l_13_1, l_13_2)
  if not l_13_0:show_value() or not string.format("%.0f", l_13_0:value()) then
    local value = string.format("%.0f", l_13_0:percentage()) .. "%"
  end
  l_13_1.gui_slider_text:set_text(value)
  local where = l_13_1.gui_slider:left() + l_13_1.gui_slider:w() * (l_13_0:percentage() / 100)
  l_13_1.gui_slider_marker:set_center_x(where)
  l_13_1.gui_slider_gfx:set_w(l_13_1.gui_slider:w() * (l_13_0:percentage() / 100))
  return true
end

ItemSlider.highlight_row_item = function(l_14_0, l_14_1, l_14_2, l_14_3)
  l_14_2.gui_text:set_color(l_14_2.color)
  if not l_14_2.font or not Idstring(l_14_2.font) then
    l_14_2.gui_text:set_font(_G.tweak_data.menu.default_font_no_outline_id)
  end
  l_14_2.gui_slider_text:set_color(l_14_2.color)
  if not l_14_2.font or not Idstring(l_14_2.font) then
    l_14_2.gui_slider_text:set_font(_G.tweak_data.menu.default_font_no_outline_id)
  end
  l_14_2.gui_slider_gfx:set_gradient_points({0, _G.tweak_data.screen_colors.button_stage_2, 1, _G.tweak_data.screen_colors.button_stage_2})
  if l_14_2.gui_info_panel then
    l_14_2.gui_info_panel:set_visible(true)
  end
  return true
end

ItemSlider.fade_row_item = function(l_15_0, l_15_1, l_15_2)
  l_15_2.gui_text:set_color(l_15_2.color)
  if not l_15_2.font or not Idstring(l_15_2.font) then
    l_15_2.gui_text:set_font(_G.tweak_data.menu.default_font_id)
  end
  l_15_2.gui_slider_text:set_color(l_15_2.color)
  if not l_15_2.font or not Idstring(l_15_2.font) then
    l_15_2.gui_slider_text:set_font(_G.tweak_data.menu.default_font_id)
  end
  l_15_2.gui_slider_gfx:set_gradient_points({0, _G.tweak_data.screen_colors.button_stage_3, 1, _G.tweak_data.screen_colors.button_stage_3})
  if l_15_2.gui_info_panel then
    l_15_2.gui_info_panel:set_visible(false)
  end
  return true
end

ItemSlider._layout = function(l_16_0, l_16_1, l_16_2)
  local safe_rect = managers.gui_data:scaled_size()
  l_16_2.gui_text:set_font_size(l_16_1.font_size)
  local x, y, w, h = l_16_2.gui_text:text_rect()
  local bg_pad = 8
  local xl_pad = 64
  l_16_2.gui_panel:set_height(h)
  l_16_2.gui_panel:set_width(safe_rect.width - l_16_1._mid_align(l_16_1))
  l_16_2.gui_panel:set_x(l_16_1._mid_align(l_16_1))
  local sh = h - 2
  l_16_2.gui_slider_bg:set_h(sh)
  l_16_2.gui_slider_bg:set_w(l_16_2.gui_panel:w())
  l_16_2.gui_slider_bg:set_x(0)
  l_16_2.gui_slider_bg:set_center_y(h / 2)
  if not l_16_2.font or not Idstring(l_16_2.font) then
    l_16_2.gui_slider_text:set_font_size(_G.tweak_data.menu.stats_font_size)
  end
  l_16_2.gui_slider_text:set_size(l_16_2.gui_slider_bg:size())
  l_16_2.gui_slider_text:set_position(l_16_2.gui_slider_bg:position())
  l_16_2.gui_slider_text:set_y(l_16_2.gui_slider_text:y())
  if l_16_2.align == "right" then
    l_16_2.gui_slider_text:set_left(l_16_1._right_align(l_16_1) - l_16_2.gui_panel:x())
  else
    l_16_2.gui_slider_text:set_x(l_16_2.gui_slider_text:x() - l_16_1.align_line_padding(l_16_1))
  end
  l_16_2.gui_slider_gfx:set_h(sh)
  l_16_2.gui_slider_gfx:set_x(l_16_2.gui_slider_bg:x())
  l_16_2.gui_slider_gfx:set_y(l_16_2.gui_slider_bg:y())
  l_16_2.gui_slider:set_x(l_16_2.gui_slider_bg:x())
  l_16_2.gui_slider:set_y(l_16_2.gui_slider_bg:y())
  l_16_2.gui_slider:set_w(l_16_2.gui_slider_bg:w())
  l_16_2.gui_slider_marker:set_center_y(h / 2)
  l_16_2.gui_text:set_width(safe_rect.width / 2)
  if l_16_2.align == "right" then
    l_16_2.gui_text:set_right(l_16_2.gui_panel:w())
  else
    l_16_2.gui_text:set_left(l_16_1._right_align(l_16_1) - l_16_2.gui_panel:x())
  end
  l_16_2.gui_text:set_height(h)
end


