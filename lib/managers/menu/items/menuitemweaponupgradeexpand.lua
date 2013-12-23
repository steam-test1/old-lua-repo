-- Decompiled using luadec 2.0.1 by sztupy (http://winmo.sztupy.hu)
-- Command line was: F:\SteamLibrary\SteamApps\common\PAYDAY 2\lua\lib\managers\menu\items\menuitemweaponupgradeexpand.luac 

core:import("CoreMenuItem")
core:import("CoreMenuItemOption")
if not MenuItemWeaponUpgradeExpand then
  MenuItemWeaponUpgradeExpand = class(MenuItemExpand)
end
MenuItemWeaponUpgradeExpand.TYPE = "weapon_upgrade_expand"
MenuItemWeaponUpgradeExpand.init = function(l_1_0, l_1_1, l_1_2)
  MenuItemWeaponUpgradeExpand.super.init(l_1_0, l_1_1, l_1_2)
  l_1_0._type = MenuItemWeaponUpgradeExpand.TYPE
  {type = "MenuItemWeaponUpgradeAction", name = l_1_0._parameters.weapon_id .. "buy1"}.text_id = "menu_buy"
   -- DECOMPILER ERROR: Confused about usage of registers!

  {type = "MenuItemWeaponUpgradeAction", name = l_1_0._parameters.weapon_id .. "buy1"}.action_type = "buy_upgrade"
   -- DECOMPILER ERROR: Confused about usage of registers!

  {type = "MenuItemWeaponUpgradeAction", name = l_1_0._parameters.weapon_id .. "buy1"}.callback = "buy_weapon_upgrade"
   -- DECOMPILER ERROR: Confused about usage of registers!

  {type = "MenuItemWeaponUpgradeAction", name = l_1_0._parameters.weapon_id .. "buy1"}.visible_callback = "can_buy_weapon_upgrade"
   -- DECOMPILER ERROR: Confused about usage of registers!

  {type = "MenuItemWeaponUpgradeAction", name = l_1_0._parameters.weapon_id .. "buy1"}.weapon_id = l_1_0._parameters.weapon_id
   -- DECOMPILER ERROR: Confused about usage of registers!

  {type = "MenuItemWeaponUpgradeAction", name = l_1_0._parameters.weapon_id .. "buy1"}.weapon_upgrade = l_1_0._parameters.weapon_upgrade
   -- DECOMPILER ERROR: Confused about usage of registers!

  {type = "MenuItemWeaponUpgradeAction", name = l_1_0._parameters.weapon_id .. "buy1"}.upgrade_type = l_1_0._parameters.upgrade_type
   -- DECOMPILER ERROR: Confused at declaration of local variable

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused at declaration of local variable

  l_1_0:add_item(CoreMenuNode.MenuNode.create_item(l_1_0, {type = "MenuItemWeaponUpgradeAction", name = l_1_0._parameters.weapon_id .. "buy1"}))
  {type = "MenuItemWeaponUpgradeAction", name = l_1_0._parameters.weapon_id .. "attach"}.text_id = "menu_attach"
   -- DECOMPILER ERROR: Confused about usage of registers!

  {type = "MenuItemWeaponUpgradeAction", name = l_1_0._parameters.weapon_id .. "attach"}.action_type = "attach_upgrade"
   -- DECOMPILER ERROR: Confused about usage of registers!

  {type = "MenuItemWeaponUpgradeAction", name = l_1_0._parameters.weapon_id .. "attach"}.callback = "attach_weapon_upgrade"
   -- DECOMPILER ERROR: Confused about usage of registers!

  {type = "MenuItemWeaponUpgradeAction", name = l_1_0._parameters.weapon_id .. "attach"}.visible_callback = "owns_weapon_upgrade"
   -- DECOMPILER ERROR: Confused about usage of registers!

  {type = "MenuItemWeaponUpgradeAction", name = l_1_0._parameters.weapon_id .. "attach"}.weapon_id = l_1_0._parameters.weapon_id
   -- DECOMPILER ERROR: Confused about usage of registers!

  {type = "MenuItemWeaponUpgradeAction", name = l_1_0._parameters.weapon_id .. "attach"}.weapon_upgrade = l_1_0._parameters.weapon_upgrade
   -- DECOMPILER ERROR: Confused about usage of registers!

  {type = "MenuItemWeaponUpgradeAction", name = l_1_0._parameters.weapon_id .. "attach"}.upgrade_type = l_1_0._parameters.upgrade_type
   -- DECOMPILER ERROR: Confused at declaration of local variable

   -- DECOMPILER ERROR: Confused about usage of registers!

  do
     -- DECOMPILER ERROR: Confused at declaration of local variable

    l_1_0:add_item(CoreMenuNode.MenuNode.create_item(l_1_0, {type = "MenuItemWeaponUpgradeAction", name = l_1_0._parameters.weapon_id .. "attach"}))
  end
   -- DECOMPILER ERROR: Confused about usage of registers for local variables.

end

MenuItemWeaponUpgradeExpand.expand_value = function(l_2_0)
  return 0
end

MenuItemWeaponUpgradeExpand.can_expand = function(l_3_0)
  return l_3_0:parameter("unlocked")
end

MenuItemWeaponUpgradeExpand.setup_gui = function(l_4_0, l_4_1, l_4_2)
  local scaled_size = managers.gui_data:scaled_size()
  l_4_2.gui_panel = l_4_1.item_panel:panel({w = l_4_1.item_panel:w()})
  l_4_2.upgrade_name = l_4_1._text_item_part(l_4_1, l_4_2, l_4_2.gui_panel, l_4_1.align_line_padding(l_4_1))
  l_4_2.upgrade_name:set_font_size(22)
  local _, _, w, h = l_4_2.upgrade_name:text_rect()
  l_4_2.upgrade_name:set_h(h)
  l_4_2.gui_panel:set_left(l_4_1._mid_align(l_4_1) + l_4_0._parameters.expand_value)
  l_4_2.gui_panel:set_w(scaled_size.width - l_4_2.gui_panel:left())
  l_4_2.gui_panel:set_h(h)
  local texture, rect = tweak_data.hud_icons:get_icon_data(tweak_data.weapon[l_4_0._parameters.weapon_id].hud_icon)
  l_4_2.weapon_icon = l_4_2.gui_panel:bitmap({texture = texture, texture_rect = rect, layer = l_4_1.layers.items})
  l_4_2.weapon_icon:set_size(h, h)
  l_4_2.upgrade_name:set_left(h + 4)
  local texture, rect = tweak_data.hud_icons:get_icon_data("icon_equipped")
  l_4_2.attached_icon = l_4_2.gui_panel:parent():bitmap({visible = l_4_0._parameters.attached, texture = texture, texture_rect = rect, layer = l_4_1.layers.items})
  l_4_2.attached_icon:set_center(h / 2, l_4_2.gui_panel:y() + h / 2)
  l_4_2.attached_icon:set_right(l_4_2.gui_panel:x())
  local texture, rect = tweak_data.hud_icons:get_icon_data("icon_locked")
  l_4_2.locked_icon = l_4_2.gui_panel:bitmap({visible = not l_4_0._parameters.unlocked, texture = texture, texture_rect = rect, layer = l_4_1.layers.items})
  l_4_2.locked_icon:set_center(h / 2, h / 2)
  l_4_2.locked_icon:set_right(l_4_2.locked_icon:parent():w() - 4)
  l_4_2.expanded_indicator = l_4_2.gui_panel:parent():bitmap({visible = false, texture = "guis/textures/menu_selected", x = 0, y = 0, layer = 0})
  l_4_2.expanded_indicator:set_w(l_4_2.gui_panel:w())
  l_4_2.expanded_indicator:set_height(64 * l_4_2.gui_panel:height() / 32)
  l_4_2.expanded_indicator:set_rotation(180)
  l_4_2.bottom_line = l_4_2.gui_panel:parent():bitmap({texture = "guis/textures/headershadow", rotation = 180, layer = l_4_1.layers.items + 1, color = Color.white, w = l_4_2.gui_panel:w(), y = 100})
end

MenuItemWeaponUpgradeExpand.on_item_position = function(l_5_0, l_5_1, l_5_2)
  l_5_1.expanded_indicator:set_position(l_5_1.gui_panel:position())
  l_5_1.expanded_indicator:set_center_y(l_5_1.gui_panel:center_y())
  l_5_1.attached_icon:set_center_y(l_5_1.gui_panel:center_y())
  l_5_1.expand_line:set_lefttop(l_5_1.gui_panel:leftbottom())
  l_5_1.expand_line:set_left(l_5_1.expand_line:left())
end

MenuItemWeaponUpgradeExpand.on_item_positions_done = function(l_6_0, l_6_1, l_6_2)
  if l_6_0:expanded() then
    local child = l_6_0._items[#l_6_0._items]
    local row_child = l_6_2.row_item(l_6_2, child)
    if row_child then
      l_6_1.bottom_line:set_lefttop(row_child.gui_panel:leftbottom())
      l_6_1.bottom_line:set_top(l_6_1.bottom_line:top() - 1)
    end
  end
end

MenuItemWeaponUpgradeExpand.on_buy = function(l_7_0, l_7_1)
  l_7_0:update_expanded_items(l_7_1)
end

MenuItemWeaponUpgradeExpand.on_attach_upgrade = function(l_8_0, l_8_1)
  for _,item in ipairs(l_8_0:parameters().parent_item:items()) do
    local row_item = l_8_1:row_item(item)
    item:reload(row_item, l_8_1)
  end
end

MenuItemWeaponUpgradeExpand.reload = function(l_9_0, l_9_1, l_9_2)
  MenuItemWeaponUpgradeExpand.super.reload(l_9_0, l_9_1, l_9_2)
  l_9_1.expanded_indicator:set_position(l_9_1.gui_panel:position())
  l_9_1.expanded_indicator:set_center_y(l_9_1.gui_panel:center_y())
  l_9_1.expanded_indicator:set_visible(l_9_0:expanded())
  l_9_1.expand_line:set_w(l_9_1.gui_panel:w())
  if l_9_0:expanded() then
    l_9_1.bottom_line:set_visible(l_9_0:parameter("unlocked"))
  end
  local upgrades = Global.blackmarket_manager.weapon_upgrades[l_9_0:parameter("weapon_id")]
  l_9_0._parameters.attached = upgrades and upgrades[l_9_0:parameter("weapon_upgrade")].attached or false
  l_9_1.attached_icon:set_visible(l_9_0._parameters.attached)
  if l_9_0:expanded() then
    l_9_1.expanded_indicator:set_color(Color.white)
    l_9_1.menu_unselected:set_color(Color(1, 0.5, 0))
  else
    l_9_1.menu_unselected:set_color(Color(0.5, 0.5, 0.5))
  end
  l_9_0:_set_row_item_state(l_9_2, l_9_1)
end

MenuItemWeaponUpgradeExpand.highlight_row_item = function(l_10_0, l_10_1, l_10_2, l_10_3)
  l_10_0:_set_row_item_state(l_10_1, l_10_2)
end

MenuItemWeaponUpgradeExpand.fade_row_item = function(l_11_0, l_11_1, l_11_2, l_11_3)
  l_11_0:_set_row_item_state(l_11_1, l_11_2)
end

MenuItemWeaponUpgradeExpand._set_row_item_state = function(l_12_0, l_12_1, l_12_2)
  if l_12_0:expanded() or l_12_2.highlighted then
    l_12_2.upgrade_name:set_color(Color.black)
    l_12_2.upgrade_name:set_font(tweak_data.menu.default_font_no_outline_id)
  else
    if not l_12_0:parameter("owned") or not l_12_0:parameter("unlocked") or not l_12_2.color then
      l_12_2.upgrade_name:set_color(Color(1, 0.5, 0.5, 0.5))
    end
    l_12_2.upgrade_name:set_font(tweak_data.menu.default_font_id)
  end
end

MenuItemWeaponUpgradeExpand.on_delete_row_item = function(l_13_0, l_13_1, ...)
  MenuItemWeaponUpgradeExpand.super.on_delete_row_item(l_13_0, l_13_1, ...)
  l_13_1.gui_panel:parent():remove(l_13_1.attached_icon)
  l_13_1.gui_panel:parent():remove(l_13_1.bottom_line)
   -- DECOMPILER ERROR: Confused about usage of registers for local variables.

end

MenuItemWeaponUpgradeExpand._max_condition = function(l_14_0)
  return 16
end

MenuItemWeaponUpgradeExpand._at_max_condition = function(l_15_0)
  return l_15_0._parameters.condition == l_15_0:_max_condition()
end

if not MenuItemWeaponUpgradeAction then
  MenuItemWeaponUpgradeAction = class(MenuItemExpandAction)
end
MenuItemWeaponUpgradeAction.init = function(l_16_0, l_16_1, l_16_2)
  MenuItemWeaponUpgradeAction.super.init(l_16_0, l_16_1, l_16_2)
end


