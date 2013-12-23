-- Decompiled using luadec 2.0.1 by sztupy (http://winmo.sztupy.hu)
-- Command line was: F:\SteamLibrary\SteamApps\common\PAYDAY 2\lua\lib\managers\menu\items\menuitemexpand.luac 

core:import("CoreMenuItem")
core:import("CoreMenuItemOption")
if not MenuItemExpand then
  MenuItemExpand = class(CoreMenuItem.Item)
end
MenuItemExpand.TYPE = "expand"
MenuItemExpand.init = function(l_1_0, l_1_1, l_1_2)
  CoreMenuItem.Item.init(l_1_0, l_1_1, l_1_2)
  l_1_0._type = MenuItemExpand.TYPE
  l_1_0._expanded = false
  l_1_0._items = {}
  l_1_0._current_index = 1
  l_1_0._all_items = {}
  if l_1_1 then
    for _,c in ipairs(l_1_1) do
      local type = c._meta
      if type == "item" then
        local item = CoreMenuNode.MenuNode.create_item(l_1_0, c)
        l_1_0:add_item(item)
        local visible_callback = c.visible_callback
        if visible_callback then
          item.visible_callback_names = string.split(visible_callback, " ")
        end
      end
    end
  end
  l_1_0._enabled = true
  l_1_0:_show_items(nil)
end

MenuItemExpand.set_enabled = function(l_2_0, l_2_1)
  l_2_0._enabled = l_2_1
  l_2_0:dirty()
end

MenuItemExpand.set_callback_handler = function(l_3_0, l_3_1)
  MenuItemExpand.super.set_callback_handler(l_3_0, l_3_1)
  l_3_0:_show_items(l_3_1)
end

MenuItemExpand._show_items = function(l_4_0, l_4_1)
  l_4_0._items = {}
  for _,item in ipairs(l_4_0._all_items) do
    local show = true
    if l_4_1 and item._visible_callback_name_list then
      for _,id in ipairs(item._visible_callback_name_list) do
        if not l_4_1[id](l_4_1, item) then
          show = false
      else
        end
      end
      if show then
        table.insert(l_4_0._items, item)
      end
    end
     -- Warning: missing end command somewhere! Added here
  end
end

MenuItemExpand.add_item = function(l_5_0, l_5_1)
  l_5_1:parameters().parent_item = l_5_0
  table.insert(l_5_0._all_items, l_5_1)
end

MenuItemExpand.get_item = function(l_6_0, l_6_1)
  for _,item in ipairs(l_6_0._all_items) do
    if item:parameters().name == l_6_1 then
      return item
    end
  end
  return nil
end

MenuItemExpand.visible_items = function(l_7_0)
  for _,item in ipairs(l_7_0._items) do
  end
  return l_7_0._items
end

MenuItemExpand.items = function(l_8_0)
  return l_8_0._items
end

MenuItemExpand.expand_value = function(l_9_0)
  return 20
end

MenuItemExpand.update_expanded_items = function(l_10_0, l_10_1)
  local row_item = l_10_1:row_item(l_10_0)
  l_10_0:collaps(l_10_1, row_item)
  l_10_0:_show_items(l_10_0._callback_handler)
  l_10_0:expand(l_10_1, row_item)
  l_10_1:need_repositioning()
  row_item.node:select_item(l_10_0:name())
  l_10_1:highlight_item(l_10_0, false)
end

MenuItemExpand.expand = function(l_11_0, l_11_1, l_11_2)
  local need_repos = false
  for i,eitem in ipairs(l_11_0._items) do
    eitem:parameters().is_expanded = true
    eitem:parameters().expand_value = l_11_0:expand_value() + (l_11_0:parameters().is_expanded and l_11_0:parameters().expand_value or 0)
    need_repos = true
    for j,nitem in pairs(l_11_2.node._items) do
      if nitem == l_11_0 then
        l_11_2.node:insert_item(eitem, j + i)
    else
      end
    end
    for j,ritem in pairs(l_11_1.row_items) do
      if ritem == l_11_2 then
        l_11_1:_insert_row_item(eitem, l_11_2.node, j + i)
      end
    end
  end
  return need_repos
end

MenuItemExpand.collaps = function(l_12_0, l_12_1, l_12_2)
  local need_repos = false
  for i,eitem in ipairs(l_12_0._items) do
    local type = eitem:type()
    if (type == "expand" or type == "weapon_expand" or type == "weapon_upgrade_expand") and eitem:expanded() then
      eitem:toggle()
      l_12_1:_reload_expand(eitem)
    end
    if l_12_2.node:delete_item(eitem:name()) then
      need_repos = true
    end
    l_12_1:_delete_row_item(eitem)
  end
  return need_repos
end

MenuItemExpand.get_h = function(l_13_0, l_13_1, l_13_2)
  local h = l_13_1.gui_panel:h()
  if l_13_0:expanded() then
    for _,item in ipairs(l_13_0:items()) do
      local child_row_item = l_13_2:row_item(item)
      if child_row_item then
        h = h + child_row_item.gui_panel:h()
      end
    end
  end
  return nil
end

MenuItemExpand.on_item_position = function(l_14_0, l_14_1, l_14_2)
  l_14_1.expanded_indicator:set_position(l_14_1.gui_panel:position())
  l_14_1.expanded_indicator:set_left(l_14_1.expanded_indicator:left() - l_14_2.align_line_padding(l_14_2))
  l_14_1.expanded_indicator:set_center_y(l_14_1.gui_panel:center_y())
  l_14_1.expand_line:set_lefttop(l_14_1.gui_panel:leftbottom())
  l_14_1.expand_line:set_left(l_14_1.expand_line:left() - l_14_2.align_line_padding(l_14_2))
end

MenuItemExpand._create_indicator = function(l_15_0, l_15_1, l_15_2)
  l_15_1.expanded_indicator = l_15_1.gui_panel:parent():bitmap({visible = false, texture = "guis/textures/menu_selected", x = 0, y = 0, layer = l_15_2.layers.items - 1})
  l_15_1.expanded_indicator:set_w(l_15_1.gui_panel:w() + l_15_2.align_line_padding(l_15_2))
  l_15_1.expanded_indicator:set_height(64 * l_15_1.gui_panel:height() / 32)
end

MenuItemExpand.reload = function(l_16_0, l_16_1, l_16_2)
  if not l_16_1.expanded_indicator then
    l_16_0:_create_indicator(l_16_1, l_16_2)
  end
  if not l_16_1.expand_line then
    l_16_1.expand_line = l_16_1.gui_panel:parent():bitmap({texture = "guis/textures/headershadowdown", texture_rect = {0, 4, 256, 60}, layer = l_16_2.layers.items + 1, color = Color.white, w = l_16_1.gui_panel:w() + l_16_2.align_line_padding(l_16_2), y = 100})
  end
  l_16_1.expanded_indicator:set_visible(l_16_0:expanded())
  l_16_1.expand_line:set_visible(l_16_0:expanded())
  if l_16_0:expanded() then
    l_16_1.expanded_indicator:set_color(l_16_2.row_item_color)
    l_16_1.menu_unselected:set_color(l_16_2.row_item_color)
  else
    l_16_1.expanded_indicator:set_color(l_16_2.row_item_hightlight_color)
    l_16_1.menu_unselected:set_color(l_16_2.row_item_hightlight_color)
  end
  l_16_0:_set_row_item_state(l_16_2, l_16_1)
end

MenuItemExpand._set_row_item_state = function(l_17_0, l_17_1, l_17_2)
  if l_17_0:expanded() or l_17_2.highlighted then
    l_17_2.gui_panel:set_color(l_17_1.row_item_hightlight_color)
    if not l_17_2.font or not Idstring(l_17_2.font) then
      l_17_2.gui_panel:set_font(tweak_data.menu.default_font_no_outline_id)
    end
    if not l_17_0:expanded() or not l_17_2.color then
      l_17_2.current_of_total:set_color(l_17_1.row_item_hightlight_color)
    end
    if not l_17_2.font or not Idstring(l_17_2.font) then
      l_17_2.current_of_total:set_font(tweak_data.menu.default_font_no_outline_id)
  else
    end
    l_17_2.gui_panel:set_color(l_17_2.color)
    if not l_17_2.font or not Idstring(l_17_2.font) then
      l_17_2.gui_panel:set_font(tweak_data.menu.default_font_id)
    end
    l_17_2.current_of_total:set_color(l_17_2.color)
    if not l_17_2.font or not Idstring(l_17_2.font) then
      l_17_2.current_of_total:set_font(tweak_data.menu.default_font_id)
    end
  end
end

MenuItemExpand.highlight_row_item = function(l_18_0, l_18_1, l_18_2, l_18_3)
  l_18_0:_set_row_item_state(l_18_1, l_18_2)
  return true
end

MenuItemExpand.fade_row_item = function(l_19_0, l_19_1, l_19_2, l_19_3)
  l_19_0:_set_row_item_state(l_19_1, l_19_2)
  return true
end

MenuItemExpand.on_delete_row_item = function(l_20_0, l_20_1, ...)
  MenuItemExpand.super.on_delete_row_item(l_20_0, l_20_1, ...)
  l_20_1.gui_panel:parent():remove(l_20_1.expand_line)
   -- DECOMPILER ERROR: Confused about usage of registers for local variables.

end

MenuItemExpand.selected_item = function(l_21_0)
  return l_21_0._items[l_21_0._current_index]
end

MenuItemExpand.current_index = function(l_22_0)
  return l_22_0._current_index
end

MenuItemExpand.set_current_index = function(l_23_0, l_23_1)
  l_23_0._current_index = l_23_1
  l_23_0:dirty()
end

MenuItemExpand.set_value = function(l_24_0, l_24_1)
  for i,item in ipairs(l_24_0._items) do
    if item:parameters().value == l_24_1 then
      l_24_0._current_index = i
  else
    end
  end
  l_24_0:dirty()
end

MenuItemExpand.value = function(l_25_0)
  local value = ""
  local selected_item = l_25_0:selected_item()
  if selected_item then
    value = selected_item:parameters().value
  end
  return value
end

MenuItemExpand._highest_item_index = function(l_26_0)
  local index = 1
  for i,item in ipairs(l_26_0._items) do
    if not item:parameters().exclude then
      index = i
    end
  end
  return index
end

MenuItemExpand._lowest_item_index = function(l_27_0)
  for i,item in ipairs(l_27_0._items) do
    if not item:parameters().exclude then
      return i
    end
  end
end

MenuItemExpand.expanded = function(l_28_0)
  return l_28_0._expanded
end

MenuItemExpand.can_expand = function(l_29_0)
  return true
end

MenuItemExpand.toggle = function(l_30_0)
  l_30_0._expanded = not l_30_0._expanded
end

MenuItemExpand.is_parent_to_item = function(l_31_0, l_31_1)
  for i,item in ipairs(l_31_0._items) do
    if l_31_1 == item then
      return true
    end
  end
  return false
end

if not MenuItemExpandAction then
  MenuItemExpandAction = class(CoreMenuItem.Item)
end
MenuItemExpandAction.init = function(l_32_0, l_32_1, l_32_2)
  MenuItemExpandAction.super.init(l_32_0, l_32_1, l_32_2)
end

MenuItemExpandAction.setup_gui = function(l_33_0, l_33_1, l_33_2)
  local scaled_size = managers.gui_data:scaled_size()
  l_33_2.gui_panel = l_33_1.item_panel:panel({w = l_33_1.item_panel:w()})
  l_33_2.action_name = l_33_1._text_item_part(l_33_1, l_33_2, l_33_2.gui_panel, l_33_1.align_line_padding(l_33_1))
  l_33_2.action_name:set_font_size(22)
  local _, _, w, h = l_33_2.action_name:text_rect()
  l_33_2.action_name:set_h(h)
  if l_33_2.align == "right" then
    l_33_2.gui_panel:set_right(l_33_1._mid_align(l_33_1) + l_33_0._parameters.expand_value)
  else
    l_33_2.gui_panel:set_left(l_33_1._mid_align(l_33_1) + l_33_0._parameters.expand_value)
  end
  l_33_2.gui_panel:set_w(scaled_size.width - l_33_2.gui_panel:left())
  l_33_2.gui_panel:set_h(h)
  local texture, rect = tweak_data.hud_icons:get_icon_data((((l_33_0._parameters.action_type ~= "attach_upgrade" or not "icon_equipped") and l_33_0._parameters.action_type == "buy_upgrade" and "icon_buy")))
  l_33_2.action_icon = l_33_2.gui_panel:bitmap({texture = texture, texture_rect = rect, layer = l_33_1.layers.items})
  l_33_2.action_icon:set_center(h / 2, h / 2)
  if l_33_2.align == "right" then
    l_33_2.action_name:set_right(l_33_2.gui_panel:w() - 10 - l_33_0._parameters.expand_value)
  else
    l_33_2.action_name:set_left(h + 4)
  end
  if l_33_0._parameters.action_type == "repair" then
    local texture, rect = tweak_data.hud_icons:get_icon_data("icon_circlebg")
    l_33_2.circlefill = l_33_2.gui_panel:bitmap({visible = true, texture = texture, texture_rect = rect, layer = l_33_1.layers.items})
    l_33_2.circlefill:set_center(h / 2, h / 2)
    l_33_2.circlefill:set_right(l_33_2.circlefill:parent():w() - 4)
    local texture, rect = tweak_data.hud_icons:get_icon_data("icon_circlefill" .. l_33_0._parameters.parent_item:condition())
    l_33_2.repair_circle = l_33_2.gui_panel:bitmap({visible = l_33_0._parameters.unlocked, texture = texture, texture_rect = rect, layer = l_33_1.layers.items + 1, color = l_33_0:_repair_circle_color(l_33_0._parameters.parent_item:condition())})
    l_33_2.repair_circle:set_position(l_33_2.circlefill:position())
  end
  return true
end

MenuItemExpandAction.reload = function(l_34_0, l_34_1, l_34_2)
  MenuItemExpandAction.super.reload(l_34_0, l_34_1, l_34_2)
  l_34_1.menu_unselected:set_color(l_34_2.row_item_hightlight_color)
  if l_34_0._parameters.action_type == "equip" then
    l_34_0:parameters().parent_item:on_equip(l_34_2)
  else
    if l_34_0._parameters.action_type == "repair" then
      l_34_0:parameters().parent_item:on_repair(l_34_2)
      local texture, rect = tweak_data.hud_icons:get_icon_data("icon_circlefill" .. l_34_0._parameters.parent_item:condition())
      l_34_1.repair_circle:set_texture_rect(rect[1], rect[2], rect[3], rect[4])
      l_34_1.repair_circle:set_size(rect[3], rect[4])
      l_34_1.repair_circle:set_color(l_34_0:_repair_circle_color(l_34_0._parameters.parent_item:condition()))
    else
      if l_34_0._parameters.action_type == "buy" then
        do return end
      end
      if l_34_0._parameters.action_type == "attach_upgrade" then
        l_34_0:parameters().parent_item:on_attach_upgrade(l_34_2)
      end
    end
  end
  l_34_0:_set_row_item_state(l_34_2, l_34_1)
  return true
end

MenuItemExpandAction._set_row_item_state = function(l_35_0, l_35_1, l_35_2)
  if l_35_2.highlighted then
    l_35_2.action_name:set_color(l_35_2.color)
    if not l_35_2.font or not Idstring(l_35_2.font) then
      l_35_2.action_name:set_font(tweak_data.menu.default_font_no_outline_id)
  else
    end
    if l_35_0._parameters.action_type == "repair" and l_35_0:_at_max_condition() then
      l_35_2.action_name:set_color(l_35_1.row_item_hightlight_color)
    else
      l_35_2.action_name:set_color(l_35_2.color)
    end
    if not l_35_2.font or not Idstring(l_35_2.font) then
      l_35_2.action_name:set_font(tweak_data.menu.default_font_id)
    end
  end
end

MenuItemExpandAction.highlight_row_item = function(l_36_0, l_36_1, l_36_2, l_36_3)
  l_36_0:_set_row_item_state(l_36_1, l_36_2)
  return true
end

MenuItemExpandAction.fade_row_item = function(l_37_0, l_37_1, l_37_2)
  l_37_0:_set_row_item_state(l_37_1, l_37_2)
  return true
end

MenuItemExpandAction._max_condition = function(l_38_0)
  return l_38_0:parameters().parent_item:_max_condition()
end

MenuItemExpandAction._at_max_condition = function(l_39_0)
  return l_39_0:parameters().parent_item:_at_max_condition()
end

MenuItemExpandAction._repair_circle_color = function(l_40_0, ...)
  return l_40_0:parameters().parent_item:_repair_circle_color(...)
   -- DECOMPILER ERROR: Confused about usage of registers for local variables.

end


