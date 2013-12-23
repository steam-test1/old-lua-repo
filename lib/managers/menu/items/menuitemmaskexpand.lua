-- Decompiled using luadec 2.0.1 by sztupy (http://winmo.sztupy.hu)
-- Command line was: F:\SteamLibrary\SteamApps\common\PAYDAY 2\lua\lib\managers\menu\items\menuitemmaskexpand.luac 

core:import("CoreMenuItem")
core:import("CoreMenuItemOption")
if not MenuItemMaskExpand then
  MenuItemMaskExpand = class(MenuItemExpand)
end
MenuItemMaskExpand.TYPE = "weapon_expand"
MenuItemMaskExpand.init = function(l_1_0, l_1_1, l_1_2)
  MenuItemMaskExpand.super.init(l_1_0, l_1_1, l_1_2)
  l_1_0._type = MenuItemMaskExpand.TYPE
  local data_node = {type = "MenuItemMaskAction", name = l_1_0._parameters.mask_id .. "buy", text_id = "menu_buy", action_type = "buy", callback = "buy_mask", visible_callback = "can_buy_mask", mask_id = l_1_0._parameters.mask_id}
  local item = CoreMenuNode.MenuNode.create_item(l_1_0, data_node)
  l_1_0:add_item(item)
  local data_node = {type = "MenuItemMaskAction", name = l_1_0._parameters.mask_id .. "equip", text_id = "menu_equip", action_type = "equip", callback = "equip_mask", visible_callback = "owns_mask", mask_id = l_1_0._parameters.mask_id}
  local item = CoreMenuNode.MenuNode.create_item(l_1_0, data_node)
  l_1_0:add_item(item)
end

MenuItemMaskExpand.expand_value = function(l_2_0)
  return 0
end

MenuItemMaskExpand.toggle = function(l_3_0, ...)
   -- DECOMPILER ERROR: Confused while interpreting a jump as a 'while'

end
MenuItemMaskExpand.super.toggle(l_3_0, ...)
 -- DECOMPILER ERROR: Confused about usage of registers for local variables.

end

MenuItemMaskExpand.can_expand = function(l_4_0)
  return l_4_0:parameter("unlocked")
end

MenuItemMaskExpand.setup_gui = function(l_5_0, l_5_1, l_5_2)
  local scaled_size = managers.gui_data:scaled_size()
  l_5_2.gui_panel = l_5_1.item_panel:panel({w = l_5_1.item_panel:w()})
  l_5_2.mask_name = l_5_1._text_item_part(l_5_1, l_5_2, l_5_2.gui_panel, l_5_1.align_line_padding(l_5_1))
  l_5_2.mask_name:set_font_size(22)
  local _, _, w, h = l_5_2.mask_name:text_rect()
  l_5_2.mask_name:set_h(h)
  l_5_2.gui_panel:set_left(l_5_1._mid_align(l_5_1) + l_5_0._parameters.expand_value)
  l_5_2.gui_panel:set_w(scaled_size.width - l_5_2.gui_panel:left())
  l_5_2.gui_panel:set_h(h)
  local texture, rect = tweak_data.hud_icons:get_icon_data("icon_equipped")
  l_5_2.equipped_icon = l_5_2.gui_panel:parent():bitmap({visible = l_5_0._parameters.equipped, texture = texture, texture_rect = rect, layer = l_5_1.layers.items})
  l_5_2.equipped_icon:set_center(h / 2, l_5_2.gui_panel:y() + h / 2)
  l_5_2.equipped_icon:set_right(l_5_2.gui_panel:x())
  local texture, rect = tweak_data.hud_icons:get_icon_data("icon_locked")
  l_5_2.locked_icon = l_5_2.gui_panel:bitmap({visible = not l_5_0._parameters.unlocked, texture = texture, texture_rect = rect, layer = l_5_1.layers.items})
  l_5_2.locked_icon:set_center(h / 2, h / 2)
  l_5_2.locked_icon:set_right(l_5_2.locked_icon:parent():w() - 4)
  if l_5_2.align == "right" then
    l_5_2.mask_name:set_right(l_5_2.locked_icon:left() - 10)
  end
  l_5_2.expanded_indicator = l_5_2.gui_panel:parent():bitmap({visible = false, texture = "guis/textures/menu_selected", x = 0, y = 0, layer = l_5_1.layers.items - 1})
  l_5_2.expanded_indicator:set_w(l_5_2.gui_panel:w())
  l_5_2.expanded_indicator:set_height(64 * l_5_2.gui_panel:height() / 32)
  l_5_2.bottom_line = l_5_2.gui_panel:parent():bitmap({texture = "guis/textures/headershadowdown", layer = l_5_1.layers.items + 1, color = Color.white, w = l_5_2.gui_panel:w(), y = 100})
end

MenuItemMaskExpand.on_item_position = function(l_6_0, l_6_1, l_6_2)
  l_6_1.expanded_indicator:set_position(l_6_1.gui_panel:position())
  l_6_1.expanded_indicator:set_center_y(l_6_1.gui_panel:center_y())
  l_6_1.equipped_icon:set_center_y(l_6_1.gui_panel:center_y())
  l_6_1.expand_line:set_lefttop(l_6_1.gui_panel:leftbottom())
  l_6_1.expand_line:set_left(l_6_1.expand_line:left())
end

MenuItemMaskExpand.on_item_positions_done = function(l_7_0, l_7_1, l_7_2)
  if l_7_0:expanded() then
    local child = l_7_0._items[#l_7_0._items]
    local row_child = l_7_2.row_item(l_7_2, child)
    if row_child then
      l_7_1.bottom_line:set_lefttop(row_child.gui_panel:leftbottom())
      l_7_1.bottom_line:set_top(l_7_1.bottom_line:top() - 1)
    end
  end
end

MenuItemMaskExpand.on_buy = function(l_8_0, l_8_1)
  l_8_0:update_expanded_items(l_8_1)
end

MenuItemMaskExpand.on_equip = function(l_9_0, l_9_1)
  for _,item in ipairs(l_9_0:parameters().parent_item:items()) do
    local row_item = l_9_1:row_item(item)
    item:reload(row_item, l_9_1)
  end
end

MenuItemMaskExpand.on_repair = function(l_10_0, l_10_1, l_10_2)
  local row_item = l_10_1:row_item(l_10_0)
  l_10_0._parameters.condition = l_10_2
end

MenuItemMaskExpand._repair_circle_color = function(l_11_0, l_11_1)
  if l_11_1 >= 4 or not Color(1, 0.5, 0) then
    return Color.white
  end
end

MenuItemMaskExpand.get_h = function(l_12_0, l_12_1, l_12_2)
  local h = l_12_1.gui_panel:h()
  if l_12_0:expanded() then
    print(#l_12_0:items())
    for _,item in ipairs(l_12_0:items()) do
      local child_row_item = l_12_2:row_item(item)
      if child_row_item then
        h = h + child_row_item.gui_panel:h()
      end
    end
  end
  return h
end

MenuItemMaskExpand.reload = function(l_13_0, l_13_1, l_13_2)
  MenuItemMaskExpand.super.reload(l_13_0, l_13_1, l_13_2)
  l_13_1.expanded_indicator:set_position(l_13_1.gui_panel:position())
  l_13_1.expanded_indicator:set_center_y(l_13_1.gui_panel:center_y())
  l_13_1.expanded_indicator:set_visible(l_13_0:expanded())
  l_13_1.expand_line:set_w(l_13_1.gui_panel:w())
  if l_13_0:expanded() then
    l_13_1.bottom_line:set_visible(l_13_0:parameter("unlocked"))
  end
  l_13_0._parameters.equipped = Global.blackmarket_manager.masks[l_13_0:parameter("mask_id")].equipped
  l_13_1.equipped_icon:set_visible(l_13_0._parameters.equipped)
  if l_13_0:expanded() then
    l_13_1.expanded_indicator:set_color(l_13_2.row_item_color)
    l_13_1.menu_unselected:set_color(l_13_2.row_item_hightlight_color)
  else
    l_13_1.menu_unselected:set_color(l_13_2.row_item_color)
  end
  l_13_0:_set_row_item_state(l_13_2, l_13_1)
end

MenuItemMaskExpand.highlight_row_item = function(l_14_0, l_14_1, l_14_2, l_14_3)
  l_14_0:_set_row_item_state(l_14_1, l_14_2)
  l_14_2.mask_name:set_color(l_14_2.color)
  l_14_2.mask_name:set_font(tweak_data.menu.default_font_no_outline_id)
end

MenuItemMaskExpand.fade_row_item = function(l_15_0, l_15_1, l_15_2, l_15_3)
  l_15_0:_set_row_item_state(l_15_1, l_15_2)
end

MenuItemMaskExpand._set_row_item_state = function(l_16_0, l_16_1, l_16_2)
  if l_16_0:expanded() or l_16_2.highlighted then
    l_16_2.mask_name:set_color(l_16_1.row_item_hightlight_color)
    l_16_2.mask_name:set_font(tweak_data.menu.default_font_no_outline_id)
  else
    if not l_16_0:parameter("owned") or not l_16_0:parameter("unlocked") or not l_16_2.color then
      l_16_2.mask_name:set_color(l_16_1.row_item_color)
    end
    l_16_2.mask_name:set_font(tweak_data.menu.default_font_id)
  end
end

MenuItemMaskExpand.on_delete_row_item = function(l_17_0, l_17_1, ...)
  MenuItemMaskExpand.super.on_delete_row_item(l_17_0, l_17_1, ...)
  l_17_1.gui_panel:parent():remove(l_17_1.equipped_icon)
  l_17_1.gui_panel:parent():remove(l_17_1.bottom_line)
   -- DECOMPILER ERROR: Confused about usage of registers for local variables.

end

if not MenuItemMaskAction then
  MenuItemMaskAction = class(MenuItemExpandAction)
end

