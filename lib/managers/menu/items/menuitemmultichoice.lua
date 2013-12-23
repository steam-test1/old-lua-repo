-- Decompiled using luadec 2.0.1 by sztupy (http://winmo.sztupy.hu)
-- Command line was: F:\SteamLibrary\SteamApps\common\PAYDAY 2\lua\lib\managers\menu\items\menuitemmultichoice.luac 

core:import("CoreMenuItem")
core:import("CoreMenuItemOption")
if not MenuItemMultiChoice then
  MenuItemMultiChoice = class(CoreMenuItem.Item)
end
MenuItemMultiChoice.TYPE = "multi_choice"
MenuItemMultiChoice.init = function(l_1_0, l_1_1, l_1_2)
  CoreMenuItem.Item.init(l_1_0, l_1_1, l_1_2)
  l_1_0._type = MenuItemMultiChoice.TYPE
  l_1_0._options = {}
  l_1_0._current_index = 1
  l_1_0._all_options = {}
  if l_1_1 then
    for _,c in ipairs(l_1_1) do
      local type = c._meta
      if type == "option" then
        local option = CoreMenuItemOption.ItemOption:new(c)
        l_1_0:add_option(option)
        local visible_callback = c.visible_callback
        if visible_callback then
          option.visible_callback_names = string.split(visible_callback, " ")
        end
      end
    end
  end
  l_1_0._enabled = true
  l_1_0:_show_options(nil)
end

MenuItemMultiChoice.set_enabled = function(l_2_0, l_2_1)
  l_2_0._enabled = l_2_1
  l_2_0:dirty()
end

MenuItemMultiChoice.set_callback_handler = function(l_3_0, l_3_1)
  MenuItemMultiChoice.super.set_callback_handler(l_3_0, l_3_1)
end

MenuItemMultiChoice.visible = function(l_4_0, ...)
  l_4_0:_show_options(l_4_0._callback_handler)
  return MenuItemMultiChoice.super.visible(l_4_0, ...)
   -- DECOMPILER ERROR: Confused about usage of registers for local variables.

end

MenuItemMultiChoice._show_options = function(l_5_0, l_5_1)
  if l_5_0:selected_option() then
    local selected_value = l_5_0:selected_option():value()
  end
  l_5_0._options = {}
  for _,option in ipairs(l_5_0._all_options) do
    local show = true
    if l_5_1 and option.visible_callback_names then
      for _,id in ipairs(option.visible_callback_names) do
        if not l_5_1[id](l_5_1, option) then
          show = false
      else
        end
      end
      if show then
        table.insert(l_5_0._options, option)
      end
    end
    if selected_value then
      l_5_0:set_current_index(1)
      l_5_0:set_value(selected_value)
    end
     -- Warning: missing end command somewhere! Added here
  end
end

MenuItemMultiChoice.add_option = function(l_6_0, l_6_1)
  table.insert(l_6_0._all_options, l_6_1)
end

MenuItemMultiChoice.options = function(l_7_0)
  return l_7_0._options
end

MenuItemMultiChoice.selected_option = function(l_8_0)
  return l_8_0._options[l_8_0._current_index]
end

MenuItemMultiChoice.current_index = function(l_9_0)
  return l_9_0._current_index
end

MenuItemMultiChoice.set_current_index = function(l_10_0, l_10_1)
  l_10_0._current_index = l_10_1
  l_10_0:dirty()
end

MenuItemMultiChoice.set_value = function(l_11_0, l_11_1)
  for i,option in ipairs(l_11_0._options) do
    if option:parameters().value == l_11_1 then
      l_11_0._current_index = i
  else
    end
  end
  l_11_0:dirty()
end

MenuItemMultiChoice.value = function(l_12_0)
  local value = ""
  local selected_option = l_12_0:selected_option()
  if selected_option then
    value = selected_option:parameters().value
  end
  return value
end

MenuItemMultiChoice._highest_option_index = function(l_13_0)
  local index = 1
  for i,option in ipairs(l_13_0._options) do
    if not option:parameters().exclude then
      index = i
    end
  end
  return index
end

MenuItemMultiChoice._lowest_option_index = function(l_14_0)
  for i,option in ipairs(l_14_0._options) do
    if not option:parameters().exclude then
      return i
    end
  end
end

MenuItemMultiChoice.next = function(l_15_0)
  if not l_15_0._enabled then
    return 
  end
  if #l_15_0._options < 2 then
    return 
  end
  if l_15_0._current_index == l_15_0:_highest_option_index() then
    return 
  end
  repeat
    if l_15_0._current_index ~= #l_15_0._options or not 1 then
      l_15_0._current_index = l_15_0._current_index + 1
    end
  until not l_15_0._options[l_15_0._current_index]:parameters().exclude
  return true
end

MenuItemMultiChoice.previous = function(l_16_0)
  if not l_16_0._enabled then
    return 
  end
  if #l_16_0._options < 2 then
    return 
  end
  if l_16_0._current_index == l_16_0:_lowest_option_index() then
    return 
  end
  repeat
    if l_16_0._current_index ~= 1 or not #l_16_0._options then
      l_16_0._current_index = l_16_0._current_index - 1
    end
  until not l_16_0._options[l_16_0._current_index]:parameters().exclude
  return true
end

MenuItemMultiChoice.left_arrow_visible = function(l_17_0)
  return (l_17_0:_lowest_option_index() < l_17_0._current_index and l_17_0._enabled)
end

MenuItemMultiChoice.right_arrow_visible = function(l_18_0)
  return (l_18_0._current_index < l_18_0:_highest_option_index() and l_18_0._enabled)
end

MenuItemMultiChoice.arrow_visible = function(l_19_0)
  return #l_19_0._options > 1
end

MenuItemMultiChoice.setup_gui = function(l_20_0, l_20_1, l_20_2)
  local right_align = l_20_1._right_align(l_20_1)
  l_20_2.gui_panel = l_20_1.item_panel:panel({w = l_20_1.item_panel:w()})
  l_20_2.gui_text = l_20_1._text_item_part(l_20_1, l_20_2, l_20_2.gui_panel, right_align, l_20_2.align)
  l_20_2.gui_text:set_wrap(true)
  l_20_2.gui_text:set_word_wrap(true)
  if (l_20_2.align ~= "left" or not "right") and (l_20_2.align ~= "right" or not "left") then
    local choice_text_align = l_20_2.align
  end
  l_20_2.choice_panel = l_20_2.gui_panel:panel({w = l_20_1.item_panel:w()})
   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

  l_20_2.choice_text, {font_size = l_20_2.font_size, x = 0, y = 0, align = "center", vertical = "center", font = l_20_2.font}.render_template, {font_size = l_20_2.font_size, x = 0, y = 0, align = "center", vertical = "center", font = l_20_2.font}.text, {font_size = l_20_2.font_size, x = 0, y = 0, align = "center", vertical = "center", font = l_20_2.font}.blend_mode, {font_size = l_20_2.font_size, x = 0, y = 0, align = "center", vertical = "center", font = l_20_2.font}.layer, {font_size = l_20_2.font_size, x = 0, y = 0, align = "center", vertical = "center", font = l_20_2.font}.color = l_20_2.choice_panel:text({font_size = l_20_2.font_size, x = 0, y = 0, align = "center", vertical = "center", font = l_20_2.font}), Idstring("VertexColorTextured"), utf8.to_upper(""), l_20_1.row_item_blend_mode, l_20_1.layers.items, l_20_1.row_item_hightlight_color
  local w = 20
  local h = 20
  local base = 20
  local height = 15
  l_20_2.arrow_left = l_20_2.gui_panel:bitmap({texture = "guis/textures/menu_arrows", texture_rect = {0, 0, 24, 24}, color = Color(0.5, 0.5, 0.5), visible = l_20_0:arrow_visible(), x = 0, y = 0, layer = l_20_1.layers.items})
  l_20_2.arrow_right = l_20_2.gui_panel:bitmap({texture = "guis/textures/menu_arrows", texture_rect = {24, 0, -24, 24}, color = Color(0.5, 0.5, 0.5), visible = l_20_0:arrow_visible(), x = 0, y = 0, layer = l_20_1.layers.items})
  if l_20_0:info_panel() == "lobby_campaign" then
    l_20_1._create_lobby_campaign(l_20_1, l_20_2)
  else
    if l_20_0:info_panel() == "lobby_difficulty" then
      l_20_1._create_lobby_difficulty(l_20_1, l_20_2)
  if l_20_2.help_text then
    end
  end
  l_20_0:_layout(l_20_1, l_20_2)
  return true
end

MenuItemMultiChoice.reload = function(l_21_0, l_21_1, l_21_2)
  if not l_21_1 then
    return 
  end
  if l_21_2.localize_strings and l_21_0:selected_option():parameters().localize ~= false then
    l_21_1.option_text = managers.localization:text(l_21_0:selected_option():parameters().text_id)
  else
    l_21_1.option_text = l_21_0:selected_option():parameters().text_id
  end
  l_21_1.choice_text:set_text(utf8.to_upper(l_21_1.option_text))
  if l_21_0:selected_option():parameters().stencil_image then
    managers.menu:active_menu().renderer:set_stencil_image(l_21_0:selected_option():parameters().stencil_image)
  end
  if l_21_0:selected_option():parameters().stencil_align then
    managers.menu:active_menu().renderer:set_stencil_align(l_21_0:selected_option():parameters().stencil_align, l_21_0:selected_option():parameters().stencil_align_percent)
  end
  l_21_1.arrow_left:set_visible(l_21_0:arrow_visible())
  l_21_1.arrow_right:set_visible(l_21_0:arrow_visible())
  if not l_21_0:left_arrow_visible() or not tweak_data.screen_color_blue then
    l_21_1.arrow_left:set_color(tweak_data.screen_color_blue:with_alpha(0.5))
  end
  if not l_21_0:right_arrow_visible() or not tweak_data.screen_color_blue then
    l_21_1.arrow_right:set_color(tweak_data.screen_color_blue:with_alpha(0.5))
  end
  if l_21_0:info_panel() == "lobby_campaign" then
    l_21_2._reload_lobby_campaign(l_21_2, l_21_1)
  else
    if l_21_0:info_panel() == "lobby_difficulty" then
      l_21_2._reload_lobby_difficulty(l_21_2, l_21_1)
    end
  end
  return true
end

MenuItemMultiChoice.highlight_row_item = function(l_22_0, l_22_1, l_22_2, l_22_3)
  l_22_2.gui_text:set_color(l_22_2.color)
  l_22_2.arrow_left:set_image("guis/textures/menu_arrows", 24, 0, 24, 24)
  l_22_2.arrow_right:set_image("guis/textures/menu_arrows", 48, 0, -24, 24)
  if not l_22_0:left_arrow_visible() or not tweak_data.screen_color_blue then
    l_22_2.arrow_left:set_color(tweak_data.screen_color_blue:with_alpha(0.5))
  end
  if not l_22_0:right_arrow_visible() or not tweak_data.screen_color_blue then
    l_22_2.arrow_right:set_color(tweak_data.screen_color_blue:with_alpha(0.5))
  end
  if l_22_0:info_panel() == "lobby_campaign" then
    l_22_1._highlight_lobby_campaign(l_22_1, l_22_2)
  else
    if l_22_0:info_panel() == "lobby_difficulty" then
      l_22_1._highlight_lobby_difficulty(l_22_1, l_22_2)
    elseif l_22_2.gui_info_panel then
      l_22_2.gui_info_panel:set_visible(true)
    end
  end
  return true
end

MenuItemMultiChoice.fade_row_item = function(l_23_0, l_23_1, l_23_2, l_23_3)
  l_23_2.gui_text:set_color(l_23_1.row_item_color)
  l_23_2.arrow_left:set_image("guis/textures/menu_arrows", 0, 0, 24, 24)
  l_23_2.arrow_right:set_image("guis/textures/menu_arrows", 24, 0, -24, 24)
  if not l_23_0:left_arrow_visible() or not tweak_data.screen_color_blue then
    l_23_2.arrow_left:set_color(tweak_data.screen_color_blue:with_alpha(0.5))
  end
  if not l_23_0:right_arrow_visible() or not tweak_data.screen_color_blue then
    l_23_2.arrow_right:set_color(tweak_data.screen_color_blue:with_alpha(0.5))
  end
  if l_23_0:info_panel() == "lobby_campaign" then
    l_23_1._fade_lobby_campaign(l_23_1, l_23_2)
  else
    if l_23_0:info_panel() == "lobby_difficulty" then
      l_23_1._fade_lobby_difficulty(l_23_1, l_23_2)
    elseif l_23_2.gui_info_panel then
      l_23_2.gui_info_panel:set_visible(false)
    end
  end
  return true
end

local xl_pad = 64
MenuItemMultiChoice._layout = function(l_24_0, l_24_1, l_24_2)
  local safe_rect = managers.gui_data:scaled_size()
  local right_align = l_24_1._right_align(l_24_1)
  local left_align = l_24_1._left_align(l_24_1)
   -- DECOMPILER ERROR: Confused while interpreting a jump as a 'while'

end
l_24_2.gui_panel:set_width(safe_rect.width - l_24_1._mid_align(l_24_1))
l_24_2.gui_panel:set_x(l_24_1._mid_align(l_24_1))
l_24_2.arrow_right:set_size(24 * tweak_data.scale.multichoice_arrow_multiplier, 24 * tweak_data.scale.multichoice_arrow_multiplier)
l_24_2.arrow_left:set_size(24 * tweak_data.scale.multichoice_arrow_multiplier, 24 * tweak_data.scale.multichoice_arrow_multiplier)
if not l_24_0:parameters().expand_value then
  l_24_2.arrow_left:set_left(right_align - l_24_2.gui_panel:x() + (l_24_2.align ~= "right" or 0))
end
l_24_2.arrow_right:set_left(l_24_2.arrow_left:right() + 2 * (1 - tweak_data.scale.multichoice_arrow_multiplier))

local x, y, w, h = l_24_2.gui_text:text_rect()
l_24_2.gui_text:set_h(h)
l_24_2.gui_text:set_width(w + 5)
l_24_2.choice_panel:set_w(l_24_2.gui_panel:width() * 0.40000000596046)
l_24_2.choice_panel:set_h(h)
if l_24_2.align == "right" then
  l_24_2.choice_panel:set_left(l_24_2.arrow_left:right() + l_24_1._align_line_padding)
  l_24_2.arrow_right:set_left(l_24_2.choice_panel:right())
else
  l_24_2.choice_panel:set_right(l_24_2.arrow_right:left() - l_24_1._align_line_padding)
  l_24_2.arrow_left:set_right(l_24_2.choice_panel:left())
end
l_24_2.choice_text:set_w(l_24_2.choice_panel:w())
l_24_2.choice_text:set_h(h)
l_24_2.choice_text:set_left(0)
l_24_2.arrow_right:set_center_y(l_24_2.choice_panel:center_y())
l_24_2.arrow_left:set_center_y(l_24_2.choice_panel:center_y())
if l_24_2.align == "right" then
  l_24_2.gui_text:set_right(l_24_2.gui_panel:w())
else
  l_24_2.gui_text:set_left(l_24_1._right_align(l_24_1) - l_24_2.gui_panel:x() + (l_24_0:parameters().expand_value or 0))
end
l_24_2.gui_text:set_height(h)
l_24_2.gui_panel:set_height(h)
if l_24_2.gui_info_panel then
  l_24_1._align_item_gui_info_panel(l_24_1, l_24_2.gui_info_panel)
  if l_24_0:info_panel() == "lobby_campaign" then
    l_24_1._align_lobby_campaign(l_24_1, l_24_2)
  else
    if l_24_0:info_panel() == "lobby_difficulty" then
      l_24_1._align_lobby_difficulty(l_24_1, l_24_2)
    else
      l_24_1._align_info_panel(l_24_1, l_24_2)
    end
  end
end
return true
end


