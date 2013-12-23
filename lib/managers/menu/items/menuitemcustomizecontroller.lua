-- Decompiled using luadec 2.0.1 by sztupy (http://winmo.sztupy.hu)
-- Command line was: F:\SteamLibrary\SteamApps\common\PAYDAY 2\lua\lib\managers\menu\items\menuitemcustomizecontroller.luac 

core:import("CoreMenuItem")
if not MenuItemCustomizeController then
  MenuItemCustomizeController = class(CoreMenuItem.Item)
end
MenuItemCustomizeController.TYPE = "customize_controller"
MenuItemCustomizeController.init = function(l_1_0, l_1_1, l_1_2)
  CoreMenuItem.Item.init(l_1_0, l_1_1, l_1_2)
  l_1_0._type = MenuItemCustomizeController.TYPE
end

MenuItemCustomizeController.setup_gui = function(l_2_0, l_2_1, l_2_2)
  l_2_2.gui_panel = l_2_1.item_panel:panel({w = l_2_1.item_panel:w()})
  l_2_2.controller_name = l_2_1._text_item_part(l_2_1, l_2_2, l_2_2.gui_panel, l_2_1._left_align(l_2_1))
  l_2_2.controller_name:set_align("right")
  l_2_2.controller_binding = l_2_1._text_item_part(l_2_1, l_2_2, l_2_2.gui_panel, l_2_1._left_align(l_2_1), "left")
  l_2_2.controller_binding:set_align("left")
  l_2_2.controller_binding:set_text(string.upper(l_2_2.item:parameters().binding))
  l_2_2.controller_binding:set_color(tweak_data.menu.default_changeable_text_color)
  l_2_0:_layout(l_2_1, l_2_2)
  return true
end

MenuItemCustomizeController.reload = function(l_3_0, l_3_1, l_3_2)
  if l_3_0:parameters().axis then
    l_3_1.controller_binding:set_text(string.upper(l_3_0:parameters().binding))
  else
    l_3_1.controller_binding:set_text(string.upper(l_3_0:parameters().binding))
  end
  return true
end

MenuItemCustomizeController.highlight_row_item = function(l_4_0, l_4_1, l_4_2, l_4_3)
  l_4_2.controller_binding:set_color(l_4_2.color)
  if not l_4_2.font or not Idstring(l_4_2.font) then
    l_4_2.controller_binding:set_font(tweak_data.menu.default_font_no_outline_id)
  end
  l_4_2.controller_name:set_color(l_4_2.color)
  if not l_4_2.font or not Idstring(l_4_2.font) then
    l_4_2.controller_name:set_font(tweak_data.menu.default_font_no_outline_id)
  end
  return true
end

MenuItemCustomizeController.fade_row_item = function(l_5_0, l_5_1, l_5_2)
  l_5_2.controller_name:set_color(l_5_2.color)
  if not l_5_2.font or not Idstring(l_5_2.font) then
    l_5_2.controller_name:set_font(tweak_data.menu.default_font_id)
  end
  l_5_2.controller_binding:set_color(tweak_data.menu.default_changeable_text_color)
  if not l_5_2.font or not Idstring(l_5_2.font) then
    l_5_2.controller_binding:set_font(tweak_data.menu.default_font_id)
  end
  return true
end

MenuItemCustomizeController._layout = function(l_6_0, l_6_1, l_6_2)
  local safe_rect = managers.gui_data:scaled_size()
  l_6_2.controller_name:set_font_size(tweak_data.menu.customize_controller_size)
  local x, y, w, h = l_6_2.controller_name:text_rect()
  l_6_2.controller_name:set_height(h)
  l_6_2.controller_name:set_right(l_6_2.gui_panel:w() - l_6_1.align_line_padding(l_6_1))
  l_6_2.gui_panel:set_height(h)
  l_6_2.controller_binding:set_font_size(tweak_data.menu.customize_controller_size)
  l_6_2.controller_binding:set_height(h)
  l_6_2.controller_binding:set_left(l_6_1._right_align(l_6_1))
end


