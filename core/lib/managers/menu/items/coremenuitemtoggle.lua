-- Decompiled using luadec 2.0.1 by sztupy (http://winmo.sztupy.hu)
-- Command line was: F:\SteamLibrary\SteamApps\common\PAYDAY 2\lua\core\lib\managers\menu\items\coremenuitemtoggle.luac 

core:module("CoreMenuItemToggle")
core:import("CoreMenuItem")
core:import("CoreMenuItemOption")
if not ItemToggle then
  ItemToggle = class(CoreMenuItem.Item)
end
ItemToggle.TYPE = "toggle"
ItemToggle.init = function(l_1_0, l_1_1, l_1_2)
  CoreMenuItem.Item.init(l_1_0, l_1_1, l_1_2)
  l_1_0._type = "toggle"
  local params = l_1_0._parameters
  l_1_0.options = {}
  l_1_0.selected = 1
  if l_1_1 then
    for _,c in ipairs(l_1_1) do
      local type = c._meta
      if type == "option" then
        local option = CoreMenuItemOption.ItemOption:new(c)
        l_1_0:add_option(option)
      end
    end
  end
end

ItemToggle.add_option = function(l_2_0, l_2_1)
  table.insert(l_2_0.options, l_2_1)
end

ItemToggle.toggle = function(l_3_0)
  if not l_3_0._enabled then
    return 
  end
  l_3_0.selected = l_3_0.selected + 1
  if #l_3_0.options < l_3_0.selected then
    l_3_0.selected = 1
  end
  l_3_0:dirty()
end

ItemToggle.toggle_back = function(l_4_0)
  if not l_4_0._enabled then
    return 
  end
  l_4_0.selected = l_4_0.selected - 1
  if l_4_0.selected <= 0 then
    l_4_0.selected = #l_4_0.options
  end
  l_4_0:dirty()
end

ItemToggle.selected_option = function(l_5_0)
  return l_5_0.options[l_5_0.selected]
end

ItemToggle.value = function(l_6_0)
  local value = ""
  local selected_option = l_6_0:selected_option()
  if selected_option then
    value = selected_option:parameters().value
  end
  return value
end

ItemToggle.set_value = function(l_7_0, l_7_1)
  for i,option in ipairs(l_7_0.options) do
    if option:parameters().value == l_7_1 then
      l_7_0.selected = i
  else
    end
  end
  l_7_0:dirty()
end

ItemToggle.setup_gui = function(l_8_0, l_8_1, l_8_2)
  l_8_2.gui_panel = l_8_1.item_panel:panel({w = l_8_1.item_panel:w()})
  l_8_2.gui_text = l_8_1._text_item_part(l_8_1, l_8_2, l_8_2.gui_panel, l_8_1._right_align(l_8_1))
  if not l_8_2.to_upper or not utf8.to_upper(l_8_2.text) then
    l_8_2.gui_text:set_text(l_8_2.text)
  end
  if l_8_0:parameter("title_id") then
    l_8_2.gui_title = l_8_1._text_item_part(l_8_1, l_8_2, l_8_2.gui_panel, l_8_1._right_align(l_8_1), "right")
    l_8_2.gui_title:set_text(managers.localization:text(l_8_0:parameter("title_id")))
  end
  if not l_8_0:enabled() then
    l_8_2.color = _G.tweak_data.menu.default_disabled_text_color
    l_8_2.row_item_color = l_8_2.color
    l_8_2.gui_text:set_color(l_8_2.color)
  end
  if l_8_0:selected_option():parameters().text_id then
    l_8_2.gui_option = l_8_1._text_item_part(l_8_1, l_8_2, l_8_2.gui_panel, l_8_1._left_align(l_8_1))
    l_8_2.gui_option:set_align(l_8_2.align)
  end
  if l_8_0:selected_option():parameters().icon then
    l_8_2.gui_icon = l_8_2.gui_panel:bitmap({layer = l_8_1.layers.items, x = 0, y = 0, texture_rect = {0, 0, 24, 24}, texture = l_8_0:selected_option():parameters().icon})
    l_8_2.gui_icon:set_color(_G.tweak_data.menu.default_disabled_text_color)
  end
   -- DECOMPILER ERROR: unhandled construct in 'if'

  if not l_8_2.help_text or l_8_0:info_panel() == "lobby_campaign" then
    l_8_1._set_lobby_campaign(l_8_1, l_8_2)
  end
  return true
end

local xl_pad = 64
ItemToggle.reload = function(l_9_0, l_9_1, l_9_2)
  local safe_rect = managers.gui_data:scaled_size()
  l_9_1.gui_text:set_font_size(l_9_2.font_size)
  local x, y, w, h = l_9_1.gui_text:text_rect()
  l_9_1.gui_text:set_height(h)
  l_9_1.gui_panel:set_height(h)
  l_9_1.gui_panel:set_width(safe_rect.width - l_9_2._mid_align(l_9_2))
  l_9_1.gui_panel:set_x(l_9_2._mid_align(l_9_2))
  if l_9_1.gui_option then
    l_9_1.gui_option:set_font_size(l_9_2.font_size)
    l_9_1.gui_option:set_width(l_9_2._left_align(l_9_2) - l_9_1.gui_panel:x())
    l_9_1.gui_option:set_right(l_9_2._left_align(l_9_2) - l_9_1.gui_panel:x())
    l_9_1.gui_option:set_height(h)
  end
  l_9_1.gui_text:set_width(safe_rect.width / 2)
  if l_9_1.align == "right" then
    l_9_1.gui_text:set_right(l_9_1.gui_panel:w())
  else
    l_9_1.gui_text:set_left(l_9_2._right_align(l_9_2) - l_9_1.gui_panel:x() + (l_9_0:parameters().expand_value or 0))
  end
  if l_9_1.gui_icon then
    l_9_1.gui_icon:set_w(h)
    l_9_1.gui_icon:set_h(h)
    if not l_9_0:parameters().expand_value then
      l_9_1.gui_icon:set_left(l_9_2._right_align(l_9_2) - l_9_1.gui_panel:x() + (l_9_1.align ~= "right" or 0))
    end
    do return end
    l_9_1.gui_icon:set_right(l_9_1.gui_panel:w())
  end
  if l_9_1.gui_title then
    l_9_1.gui_title:set_font_size(l_9_2.font_size)
    l_9_1.gui_title:set_height(h)
    if l_9_1.gui_icon then
      l_9_1.gui_title:set_right(l_9_1.gui_icon:left() - l_9_2._align_line_padding * 2)
    else
      l_9_1.gui_title:set_right(l_9_2._left_align(l_9_2))
    end
  end
  if l_9_1.gui_info_panel then
    if l_9_0:info_panel() == "lobby_campaign" then
      l_9_2._align_lobby_campaign(l_9_2, l_9_1)
    else
      l_9_2._align_info_panel(l_9_2, l_9_1)
    end
  end
  if l_9_1.gui_option then
    if l_9_2.localize_strings and l_9_0:selected_option():parameters().localize ~= false then
      l_9_1.option_text = managers.localization:text(l_9_0:selected_option():parameters().text_id)
    else
      l_9_1.option_text = l_9_0:selected_option():parameters().text_id
    end
    l_9_1.gui_option:set_text(l_9_1.option_text)
  end
  l_9_0:_set_toggle_item_image(l_9_1)
  if l_9_0:info_panel() == "lobby_campaign" then
    l_9_2._reload_lobby_campaign(l_9_2, l_9_1)
  end
  return true
end

ItemToggle._set_toggle_item_image = function(l_10_0, l_10_1)
  if l_10_0:selected_option():parameters().icon then
    if l_10_1.highlighted and l_10_0:selected_option():parameters().s_icon then
      local x = l_10_0:selected_option():parameters().s_x
      local y = l_10_0:selected_option():parameters().s_y
      local w = l_10_0:selected_option():parameters().s_w
      local h = l_10_0:selected_option():parameters().s_h
      l_10_1.gui_icon:set_image(l_10_0:selected_option():parameters().s_icon, x, y, w, h)
    else
      local x = l_10_0:selected_option():parameters().x
      local y = l_10_0:selected_option():parameters().y
      local w = l_10_0:selected_option():parameters().w
      local h = l_10_0:selected_option():parameters().h
      l_10_1.gui_icon:set_image(l_10_0:selected_option():parameters().icon, x, y, w, h)
    end
    if l_10_0:enabled() then
      l_10_1.gui_icon:set_color(Color.white)
    else
      l_10_1.gui_icon:set_color(_G.tweak_data.menu.default_disabled_text_color)
    end
  end
end

ItemToggle.highlight_row_item = function(l_11_0, l_11_1, l_11_2, l_11_3)
  l_11_2.gui_text:set_color(l_11_2.color)
  if not l_11_2.font or not Idstring(l_11_2.font) then
    l_11_2.gui_text:set_font(_G.tweak_data.menu.default_font_no_outline_id)
  end
  l_11_2.highlighted = true
  l_11_0:_set_toggle_item_image(l_11_2)
  if l_11_2.gui_option then
    l_11_2.gui_option:set_color(l_11_2.color)
  end
  if l_11_2.gui_info_panel then
    l_11_2.gui_info_panel:set_visible(true)
  end
  if l_11_0:info_panel() == "lobby_campaign" then
    l_11_1._highlight_lobby_campaign(l_11_1, l_11_2)
  end
  return true
end

ItemToggle.fade_row_item = function(l_12_0, l_12_1, l_12_2)
  l_12_2.gui_text:set_color(l_12_2.color)
  if not l_12_2.font or not Idstring(l_12_2.font) then
    l_12_2.gui_text:set_font(_G.tweak_data.menu.default_font_id)
  end
  l_12_2.highlighted = nil
  l_12_0:_set_toggle_item_image(l_12_2)
  if l_12_2.gui_option then
    l_12_2.gui_option:set_color(l_12_2.color)
  end
  if l_12_2.gui_info_panel then
    l_12_2.gui_info_panel:set_visible(false)
  end
  if l_12_0:info_panel() == "lobby_campaign" then
    l_12_1._fade_lobby_campaign(l_12_1, l_12_2)
  end
  return true
end


