-- Decompiled using luadec 2.0.1 by sztupy (http://winmo.sztupy.hu)
-- Command line was: F:\SteamLibrary\SteamApps\common\PAYDAY 2\lua\lib\managers\menu\items\menuitemweaponexpand.luac 

core:import("CoreMenuItem")
core:import("CoreMenuItemOption")
if not MenuItemWeaponExpand then
  MenuItemWeaponExpand = class(MenuItemExpand)
end
MenuItemWeaponExpand.TYPE = "weapon_expand"
MenuItemWeaponExpand.init = function(l_1_0, l_1_1, l_1_2)
  MenuItemWeaponExpand.super.init(l_1_0, l_1_1, l_1_2)
  l_1_0._type = MenuItemWeaponExpand.TYPE
  local data_node = {type = "MenuItemWeaponAction", name = l_1_0._parameters.weapon_id .. "buy", text_id = "menu_buy", action_type = "buy", callback = "buy_weapon", visible_callback = "can_buy_weapon", weapon_id = l_1_0._parameters.weapon_id}
  local item = CoreMenuNode.MenuNode.create_item(l_1_0, data_node)
  l_1_0:add_item(item)
  local data_node = {type = "MenuItemWeaponAction", name = l_1_0._parameters.weapon_id .. "equip", text_id = "menu_equip", action_type = "equip", callback = "equip_weapon", visible_callback = "owns_weapon", weapon_id = l_1_0._parameters.weapon_id, weapon_slot = l_1_0._parameters.weapon_slot}
  local item = CoreMenuNode.MenuNode.create_item(l_1_0, data_node)
  l_1_0:add_item(item)
  local data_node = {type = "MenuItemWeaponAction", name = l_1_0._parameters.weapon_id .. "repair", text_id = "menu_repair", action_type = "repair", callback = "repair_weapon", visible_callback = "owns_weapon", weapon_id = l_1_0._parameters.weapon_id, weapon_slot = l_1_0._parameters.weapon_slot}
  local item = CoreMenuNode.MenuNode.create_item(l_1_0, data_node)
  l_1_0:add_item(item)
  {type = "MenuItemWeaponAction", name = l_1_0._parameters.weapon_id .. "buy_upgrades"}.text_id = "menu_buy_upgrades"
   -- DECOMPILER ERROR: Confused about usage of registers!

  {type = "MenuItemWeaponAction", name = l_1_0._parameters.weapon_id .. "buy_upgrades"}.action_type = "buy_upgrades"
   -- DECOMPILER ERROR: Confused about usage of registers!

  {type = "MenuItemWeaponAction", name = l_1_0._parameters.weapon_id .. "buy_upgrades"}.callback = "buy_weapon_upgrades"
   -- DECOMPILER ERROR: Confused about usage of registers!

  {type = "MenuItemWeaponAction", name = l_1_0._parameters.weapon_id .. "buy_upgrades"}.visible_callback = "owns_weapon"
   -- DECOMPILER ERROR: Confused about usage of registers!

  {type = "MenuItemWeaponAction", name = l_1_0._parameters.weapon_id .. "buy_upgrades"}.weapon_id = l_1_0._parameters.weapon_id
   -- DECOMPILER ERROR: Confused about usage of registers!

  {type = "MenuItemWeaponAction", name = l_1_0._parameters.weapon_id .. "buy_upgrades"}.weapon_slot = l_1_0._parameters.weapon_slot
   -- DECOMPILER ERROR: Confused about usage of registers!

  {type = "MenuItemWeaponAction", name = l_1_0._parameters.weapon_id .. "buy_upgrades"}.next_node = "buy_upgrades"
   -- DECOMPILER ERROR: Confused at declaration of local variable

   -- DECOMPILER ERROR: Confused at declaration of local variable

   -- DECOMPILER ERROR: Confused about usage of registers!

  do
     -- DECOMPILER ERROR: Confused at declaration of local variable

    l_1_0:add_item(CoreMenuNode.MenuNode.create_item(l_1_0, {type = "MenuItemWeaponAction", name = l_1_0._parameters.weapon_id .. "buy_upgrades"}, {next_node_parameters = {l_1_0._parameters.weapon_id}}))
    l_1_0:_show_items(nil)
  end
   -- DECOMPILER ERROR: Confused about usage of registers for local variables.

end

MenuItemWeaponExpand.expand_value = function(l_2_0)
  return 0
end

MenuItemWeaponExpand.toggle = function(l_3_0, ...)
   -- DECOMPILER ERROR: Confused while interpreting a jump as a 'while'

end
MenuItemWeaponExpand.super.toggle(l_3_0, ...)
 -- DECOMPILER ERROR: Confused about usage of registers for local variables.

end

MenuItemWeaponExpand.can_expand = function(l_4_0)
  return l_4_0:parameter("unlocked")
end

MenuItemWeaponExpand.setup_gui = function(l_5_0, l_5_1, l_5_2)
  local scaled_size = managers.gui_data:scaled_size()
  l_5_2.gui_panel = l_5_1.item_panel:panel({w = l_5_1.item_panel:w()})
  l_5_2.weapon_name = l_5_1._text_item_part(l_5_1, l_5_2, l_5_2.gui_panel, l_5_1.align_line_padding(l_5_1))
  l_5_2.weapon_name:set_font_size(22)
  local _, _, w, h = l_5_2.weapon_name:text_rect()
  l_5_2.weapon_name:set_h(h)
  l_5_2.gui_panel:set_left(l_5_1._mid_align(l_5_1) + l_5_0._parameters.expand_value)
  l_5_2.gui_panel:set_w(scaled_size.width - l_5_2.gui_panel:left())
  l_5_2.gui_panel:set_h(h)
  local texture, rect = tweak_data.hud_icons:get_icon_data(tweak_data.weapon[l_5_0._parameters.weapon_id].hud_icon)
  l_5_2.weapon_icon = l_5_2.gui_panel:bitmap({texture = texture, texture_rect = rect, layer = l_5_1.layers.items})
  l_5_2.weapon_icon:set_size(h, h)
  l_5_2.weapon_name:set_left(h + 4)
  local texture, rect = tweak_data.hud_icons:get_icon_data("icon_equipped")
  l_5_2.equipped_icon = l_5_2.gui_panel:parent():bitmap({visible = l_5_0._parameters.equipped, texture = texture, texture_rect = rect, layer = l_5_1.layers.items})
  l_5_2.equipped_icon:set_center(h / 2, l_5_2.gui_panel:y() + h / 2)
  l_5_2.equipped_icon:set_right(l_5_2.gui_panel:x())
  local texture, rect = tweak_data.hud_icons:get_icon_data("icon_locked")
  l_5_2.locked_icon = l_5_2.gui_panel:bitmap({visible = not l_5_0._parameters.unlocked, texture = texture, texture_rect = rect, layer = l_5_1.layers.items})
  l_5_2.locked_icon:set_center(h / 2, h / 2)
  l_5_2.locked_icon:set_right(l_5_2.locked_icon:parent():w() - 4)
  local texture, rect = tweak_data.hud_icons:get_icon_data("icon_circlebg")
   -- DECOMPILER ERROR: Confused while interpreting a jump as a 'while'

end
l_5_2.circlefill = l_5_2.gui_panel:bitmap({visible = l_5_0._parameters.owned, texture = texture, texture_rect = rect, layer = l_5_1.layers.items})
l_5_2.circlefill:set_position(l_5_2.locked_icon:position())
local texture, rect = tweak_data.hud_icons:get_icon_data("icon_circlefill" .. l_5_0._parameters.condition)
 -- DECOMPILER ERROR: Confused while interpreting a jump as a 'while'

end
l_5_2.repair_circle = l_5_2.gui_panel:bitmap({visible = l_5_0._parameters.owned, texture = texture, texture_rect = rect, layer = l_5_1.layers.items + 1, color = l_5_0:_repair_circle_color(l_5_0._parameters.condition)})
l_5_2.repair_circle:set_position(l_5_2.circlefill:position())
l_5_2.expanded_indicator = l_5_2.gui_panel:parent():bitmap({visible = false, color = Color.red, texture = "guis/textures/menu_selected", x = 0, y = 0, layer = l_5_1.layers.items - 1})
l_5_2.expanded_indicator:set_w(l_5_2.gui_panel:w())
l_5_2.expanded_indicator:set_height(64 * l_5_2.gui_panel:height() / 32)
l_5_2.bottom_line = l_5_2.gui_panel:parent():bitmap({texture = "guis/textures/headershadowdown", layer = l_5_1.layers.items + 1, color = Color.white, w = l_5_2.gui_panel:w(), y = 100})
end

MenuItemWeaponExpand.on_item_position = function(l_6_0, l_6_1, l_6_2)
  l_6_1.expanded_indicator:set_position(l_6_1.gui_panel:position())
  l_6_1.expanded_indicator:set_center_y(l_6_1.gui_panel:center_y())
  l_6_1.equipped_icon:set_center_y(l_6_1.gui_panel:center_y())
  l_6_1.expand_line:set_lefttop(l_6_1.gui_panel:leftbottom())
  l_6_1.expand_line:set_left(l_6_1.expand_line:left())
end

MenuItemWeaponExpand.on_item_positions_done = function(l_7_0, l_7_1, l_7_2)
  if l_7_0:expanded() then
    local child = l_7_0._items[#l_7_0._items]
    local row_child = l_7_2.row_item(l_7_2, child)
    if row_child then
      l_7_1.bottom_line:set_lefttop(row_child.gui_panel:leftbottom())
      l_7_1.bottom_line:set_top(l_7_1.bottom_line:top() - 1)
    end
  end
end

MenuItemWeaponExpand.on_buy = function(l_8_0, l_8_1)
  local row_item = l_8_1:row_item(l_8_0)
  l_8_0:collaps(l_8_1, row_item)
  l_8_0:_show_items(l_8_0._callback_handler)
  l_8_0:expand(l_8_1, row_item)
  l_8_1:need_repositioning()
  row_item.node:select_item(l_8_0:name())
  l_8_1:highlight_item(l_8_0, false)
end

MenuItemWeaponExpand.on_equip = function(l_9_0, l_9_1)
  for _,item in ipairs(l_9_0:parameters().parent_item:items()) do
    local row_item = l_9_1:row_item(item)
    item:reload(row_item, l_9_1)
  end
end

MenuItemWeaponExpand.on_repair = function(l_10_0, l_10_1)
  local row_item = l_10_1:row_item(l_10_0)
  l_10_0._parameters.condition = Global.blackmarket_manager.weapons[l_10_0._parameters.weapon_id].condition
  local texture, rect = tweak_data.hud_icons:get_icon_data("icon_circlefill" .. l_10_0._parameters.condition)
  row_item.repair_circle:set_texture_rect(rect[1], rect[2], rect[3], rect[4])
  row_item.repair_circle:set_size(rect[3], rect[4])
  row_item.repair_circle:set_color(l_10_0:_repair_circle_color(l_10_0._parameters.condition))
end

MenuItemWeaponExpand._repair_circle_color = function(l_11_0, l_11_1)
  if l_11_1 >= 4 or not Color(1, 0.5, 0) then
    return Color.white
  end
end

MenuItemWeaponExpand.reload = function(l_12_0, l_12_1, l_12_2)
  MenuItemWeaponExpand.super.reload(l_12_0, l_12_1, l_12_2)
  l_12_1.expanded_indicator:set_position(l_12_1.gui_panel:position())
  l_12_1.expanded_indicator:set_center_y(l_12_1.gui_panel:center_y())
  l_12_1.expanded_indicator:set_visible(l_12_0:expanded())
  l_12_1.expand_line:set_w(l_12_1.gui_panel:w())
  if l_12_0:expanded() then
    l_12_1.bottom_line:set_visible(l_12_0:parameter("unlocked"))
  end
  l_12_1.circlefill:set_visible(((l_12_0:expanded() or l_12_0:parameter("unlocked")) and l_12_0:parameter("owned")))
  l_12_1.repair_circle:set_visible(((l_12_0:expanded() or l_12_0:parameter("unlocked")) and l_12_0:parameter("owned")))
  l_12_0._parameters.equipped = Global.blackmarket_manager.weapons[l_12_0:parameter("weapon_id")].equipped
  l_12_1.equipped_icon:set_visible(l_12_0._parameters.equipped)
  if l_12_0:expanded() then
    l_12_1.expanded_indicator:set_color(Color.white)
    l_12_1.menu_unselected:set_color(Color(1, 0.5, 0))
  else
    l_12_1.menu_unselected:set_color(Color(0.5, 0.5, 0.5))
  end
  l_12_0:_set_row_item_state(l_12_2, l_12_1)
end

MenuItemWeaponExpand.highlight_row_item = function(l_13_0, l_13_1, l_13_2, l_13_3)
  l_13_0:_set_row_item_state(l_13_1, l_13_2)
end

MenuItemWeaponExpand.fade_row_item = function(l_14_0, l_14_1, l_14_2, l_14_3)
  l_14_0:_set_row_item_state(l_14_1, l_14_2)
end

MenuItemWeaponExpand._set_row_item_state = function(l_15_0, l_15_1, l_15_2)
  if l_15_0:expanded() or l_15_2.highlighted then
    l_15_2.weapon_name:set_color(Color.black)
    l_15_2.weapon_name:set_font(tweak_data.menu.default_font_no_outline_id)
  else
    if not l_15_0:parameter("owned") or not l_15_0:parameter("unlocked") or not l_15_2.color then
      l_15_2.weapon_name:set_color(Color(1, 0.5, 0.5, 0.5))
    end
    l_15_2.weapon_name:set_font(tweak_data.menu.default_font_id)
  end
end

MenuItemWeaponExpand.on_delete_row_item = function(l_16_0, l_16_1, ...)
  MenuItemWeaponExpand.super.on_delete_row_item(l_16_0, l_16_1, ...)
  l_16_1.gui_panel:parent():remove(l_16_1.equipped_icon)
  l_16_1.gui_panel:parent():remove(l_16_1.bottom_line)
   -- DECOMPILER ERROR: Confused about usage of registers for local variables.

end

MenuItemWeaponExpand.condition = function(l_17_0)
  return l_17_0:parameter("condition")
end

MenuItemWeaponExpand._max_condition = function(l_18_0)
  return 16
end

MenuItemWeaponExpand._at_max_condition = function(l_19_0)
  return l_19_0._parameters.condition == l_19_0:_max_condition()
end

if not MenuItemWeaponAction then
  MenuItemWeaponAction = class(MenuItemExpandAction)
end
MenuItemWeaponAction.init = function(l_20_0, l_20_1, l_20_2)
  MenuItemWeaponAction.super.init(l_20_0, l_20_1, l_20_2)
end


