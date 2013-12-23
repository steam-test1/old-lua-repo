-- Decompiled using luadec 2.0.1 by sztupy (http://winmo.sztupy.hu)
-- Command line was: F:\SteamLibrary\SteamApps\common\PAYDAY 2\lua\lib\managers\menu\items\menuitemkitslot.luac 

core:import("CoreMenuItem")
if not MenuItemKitSlot then
  MenuItemKitSlot = class(CoreMenuItem.Item)
end
MenuItemKitSlot.TYPE = "kitslot"
MenuItemKitSlot.init = function(l_1_0, l_1_1, l_1_2)
  CoreMenuItem.Item.init(l_1_0, l_1_1, l_1_2)
  l_1_0._type = MenuItemKitSlot.TYPE
  l_1_0._options = {}
  l_1_0._current_index = 1
  if l_1_0._parameters.category == "weapon" then
    l_1_0._options = managers.player:availible_weapons(l_1_0._parameters.slot)
    local selected_weapon = managers.player:weapon_in_slot(l_1_0._parameters.slot)
    for i,option in ipairs(l_1_0._options) do
      if option == selected_weapon then
        l_1_0._current_index = i
    else
      end
    end
  else
    if l_1_0._parameters.category == "equipment" then
      l_1_0._options = managers.player:availible_equipment(l_1_0._parameters.slot)
      local selected = managers.player:equipment_in_slot(l_1_0._parameters.slot)
      for i,option in ipairs(l_1_0._options) do
        if option == selected then
          l_1_0._current_index = i
      else
        end
      end
    end
  end
end

MenuItemKitSlot.next = function(l_2_0)
  if not l_2_0._enabled then
    return 
  end
  if #l_2_0._options < 2 then
    return 
  end
  if l_2_0._current_index == #l_2_0._options then
    return 
  end
  if l_2_0._current_index ~= #l_2_0._options or not 1 then
    l_2_0._current_index = l_2_0._current_index + 1
  end
  if l_2_0._parameters.category == "weapon" then
    Global.player_manager.kit.weapon_slots[l_2_0._parameters.slot] = l_2_0._options[l_2_0._current_index]
  end
  if l_2_0._parameters.category == "equipment" then
    Global.player_manager.kit.equipment_slots[l_2_0._parameters.slot] = l_2_0._options[l_2_0._current_index]
  end
  if not managers.network:session() then
    return 
  end
  local peer_id = managers.network:session():local_peer():id()
  managers.menu:get_menu("kit_menu").renderer:set_kit_selection(peer_id, l_2_0._parameters.category, l_2_0._options[l_2_0._current_index], l_2_0._parameters.slot)
  return true
end

MenuItemKitSlot.previous = function(l_3_0)
  if not l_3_0._enabled then
    return 
  end
  if #l_3_0._options < 2 then
    return 
  end
  if l_3_0._current_index == 1 then
    return 
  end
  if l_3_0._current_index ~= 1 or not #l_3_0._options then
    l_3_0._current_index = l_3_0._current_index - 1
  end
  if l_3_0._parameters.category == "weapon" then
    Global.player_manager.kit.weapon_slots[l_3_0._parameters.slot] = l_3_0._options[l_3_0._current_index]
  end
  if l_3_0._parameters.category == "equipment" then
    Global.player_manager.kit.equipment_slots[l_3_0._parameters.slot] = l_3_0._options[l_3_0._current_index]
  end
  if not managers.network:session() then
    return 
  end
  local peer_id = managers.network:session():local_peer():id()
  managers.menu:get_menu("kit_menu").renderer:set_kit_selection(peer_id, l_3_0._parameters.category, l_3_0._options[l_3_0._current_index], l_3_0._parameters.slot)
  return true
end

MenuItemKitSlot.left_arrow_visible = function(l_4_0)
  return (l_4_0._current_index > 1 and l_4_0._enabled)
end

MenuItemKitSlot.right_arrow_visible = function(l_5_0)
  return (l_5_0._current_index < #l_5_0._options and l_5_0._enabled)
end

MenuItemKitSlot.arrow_visible = function(l_6_0)
  return #l_6_0._options > 0
end

MenuItemKitSlot.text = function(l_7_0)
  if #l_7_0._options == 0 then
    return managers.localization:text("menu_kit_locked")
  end
  if l_7_0._parameters.category == "weapon" then
    local id = l_7_0._options[l_7_0._current_index]
    local name_id = tweak_data.weapon[id].name_id
    return managers.localization:text(name_id)
  else
    if l_7_0._parameters.category == "equipment" then
      local id = l_7_0._options[l_7_0._current_index]
      local equipment_id = tweak_data.upgrades.definitions[id].equipment_id
      if not tweak_data.equipments.specials[equipment_id] then
        local name_id = tweak_data.equipments[equipment_id].text_id
      end
      return managers.localization:text(name_id)
    end
  end
end

MenuItemKitSlot.icon_and_description = function(l_8_0)
  if #l_8_0._options == 0 then
    return "locked", managers.localization:text("des_locked")
  end
  if l_8_0._parameters.category == "weapon" then
    local id = l_8_0._options[l_8_0._current_index]
    local hud_icon = tweak_data.weapon[id].hud_icon
    local description_id = tweak_data.weapon[id].description_id
    local name_id = tweak_data.weapon[id].name_id
    return hud_icon, managers.localization:text(description_id)
  else
    if l_8_0._parameters.category == "equipment" then
      local id = l_8_0._options[l_8_0._current_index]
      local equipment_id = tweak_data.upgrades.definitions[id].equipment_id
      if not tweak_data.equipments.specials[equipment_id] then
        local tweak_data = tweak_data.equipments[equipment_id]
      end
      local description_id = tweak_data.description_id
      local hud_icon = tweak_data.icon
      return hud_icon, description_id and managers.localization:text(description_id) or "NO DESCRIPTION"
    end
  end
end

MenuItemKitSlot.upgrade_progress = function(l_9_0)
  if #l_9_0._options == 0 then
    return 0, 0
  end
  if l_9_0._parameters.category == "weapon" then
    local id = l_9_0._options[l_9_0._current_index]
    return managers.player:weapon_upgrade_progress(id)
  else
    if l_9_0._parameters.category == "equipment" then
      local id = l_9_0._options[l_9_0._current_index]
      local equipment_id = tweak_data.upgrades.definitions[id].equipment_id
      return managers.player:equipment_upgrade_progress(equipment_id)
    end
  end
  return 0, 0
end

MenuItemKitSlot.percentage = function(l_10_0)
  return 66
end

MenuItemKitSlot.clbk_msg_set_kit_selection = function(l_11_0, l_11_1, l_11_2, l_11_3, l_11_4, l_11_5, l_11_6)
  if l_11_1 then
    local category_data = l_11_0.categories[l_11_4]
    if not category_data then
      category_data = {}
      l_11_0.categories[l_11_4] = category_data
    end
    local item_index = category_data[l_11_6]
    if item_index then
      l_11_1[item_index] = {l_11_2, l_11_3, l_11_4, l_11_5, l_11_6}
    else
      table.insert(l_11_1, {l_11_2, l_11_3, l_11_4, l_11_5, l_11_6})
      category_data[l_11_6] = #l_11_1
    end
  else
    for cat_name,cat_data in pairs(l_11_0.categories) do
      for _slot,_ in pairs(cat_data) do
        cat_data[_slot] = nil
      end
    end
  end
end
end

MenuItemKitSlot.setup_gui = function(l_12_0, l_12_1, l_12_2)
  local category = l_12_0:parameters().category
  local slot = l_12_0:parameters().slot
  l_12_2.gui_panel = l_12_1.item_panel:panel({w = l_12_1.item_panel:w()})
  l_12_2.gui_text = l_12_1._text_item_part(l_12_1, l_12_2, l_12_2.gui_panel, l_12_1._right_align(l_12_1), "right")
  l_12_2.gui_text:set_wrap(true)
  l_12_2.gui_text:set_word_wrap(true)
  l_12_2.choice_panel = l_12_2.gui_panel:panel({w = l_12_1.item_panel:w()})
   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused while interpreting a jump as a 'while'

end
l_12_2.choice_text, {font_size = l_12_1.font_size, x = l_12_1._right_align(l_12_1), y = 0, align = "left", halign = "center", vertical = "center"}.render_template, {font_size = l_12_1.font_size, x = l_12_1._right_align(l_12_1), y = 0, align = "left", halign = "center", vertical = "center"}.text, {font_size = l_12_1.font_size, x = l_12_1._right_align(l_12_1), y = 0, align = "left", halign = "center", vertical = "center"}.layer, {font_size = l_12_1.font_size, x = l_12_1._right_align(l_12_1), y = 0, align = "left", halign = "center", vertical = "center"}.color, {font_size = l_12_1.font_size, x = l_12_1._right_align(l_12_1), y = 0, align = "left", halign = "center", vertical = "center"}.font = l_12_2.choice_panel:text({font_size = l_12_1.font_size, x = l_12_1._right_align(l_12_1), y = 0, align = "left", halign = "center", vertical = "center"}), Idstring("VertexColorTextured"), string.upper(l_12_0:text()), l_12_1.layers.items, tweak_data.menu.default_disabled_text_color, l_12_2.font
local w = 20
local h = 20
local base = 20
local height = 15
l_12_2.arrow_left = l_12_2.gui_panel:bitmap({texture = "guis/textures/menu_arrows", texture_rect = {0, 0, 24, 24}, color = Color(0.5, 0.5, 0.5), visible = l_12_0:arrow_visible(), x = 0, y = 0, layer = l_12_1.layers.items})
l_12_2.arrow_right = l_12_2.gui_panel:bitmap({rotation = 180, texture = "guis/textures/menu_arrows", texture_rect = {0, 0, 24, 24}, color = Color(0.5, 0.5, 0.5), visible = l_12_0:arrow_visible(), x = 0, y = 0, layer = l_12_1.layers.items})
l_12_2.description_panel = l_12_1.safe_rect_panel:panel({w = l_12_1.item_panel:w() / 2, h = 112, visible = false})
l_12_2.description_panel:set_left(l_12_2.choice_panel:left())
l_12_2.description_panel_bg = l_12_2.description_panel:rect({color = Color.black:with_alpha(0.5)})
local icon, texture_rect = tweak_data.hud_icons:get_icon_data("fallback")
l_12_2.description_icon = l_12_2.description_panel:bitmap({name = "description_icon", texture = icon, layer = l_12_1.layers.items, texture_rect = texture_rect, x = 0, y = 0, w = 48, h = 48})
 -- DECOMPILER ERROR: Confused about usage of registers!

 -- DECOMPILER ERROR: Confused about usage of registers!

 -- DECOMPILER ERROR: Confused about usage of registers!

l_12_2.description_progress_text, {font_size = l_12_1.font_size, x = 0, y = 0, align = "left", halign = "left", vertical = "bottom", font = l_12_2.font, color = l_12_2.color, layer = l_12_1.layers.items, text = managers.localization:text("menu_upgrade_progress")}.render_template, {font_size = l_12_1.font_size, x = 0, y = 0, align = "left", halign = "left", vertical = "bottom", font = l_12_2.font, color = l_12_2.color, layer = l_12_1.layers.items, text = managers.localization:text("menu_upgrade_progress")}.word_wrap, {font_size = l_12_1.font_size, x = 0, y = 0, align = "left", halign = "left", vertical = "bottom", font = l_12_2.font, color = l_12_2.color, layer = l_12_1.layers.items, text = managers.localization:text("menu_upgrade_progress")}.wrap = l_12_2.description_panel:text({font_size = l_12_1.font_size, x = 0, y = 0, align = "left", halign = "left", vertical = "bottom", font = l_12_2.font, color = l_12_2.color, layer = l_12_1.layers.items, text = managers.localization:text("menu_upgrade_progress")}), Idstring("VertexColorTextured"), false, false
do
  local _, _, w, h = l_12_2.description_progress_text:text_rect()
   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

  l_12_2.progress_bg, {x = 52 + w + 4, y = 0}.layer, {x = 52 + w + 4, y = 0}.color, {x = 52 + w + 4, y = 0}.vertical, {x = 52 + w + 4, y = 0}.halign, {x = 52 + w + 4, y = 0}.align, {x = 52 + w + 4, y = 0}.h, {x = 52 + w + 4, y = 0}.w = l_12_2.description_panel:rect({x = 52 + w + 4, y = 0}), l_12_1.layers.items - 1, Color.black:with_alpha(0.5), "center", "center", "center", 22, 256
   -- DECOMPILER ERROR: Overwrote pending register.

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Overwrote pending register.

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

  l_12_0:_layout(l_12_1, l_12_2)
  return true
end
 -- Warning: undefined locals caused missing assignments!
end

MenuItemKitSlot.reload = function(l_13_0, l_13_1, l_13_2)
  local icon_id, description = l_13_0:icon_and_description()
  if icon_id then
    local icon, texture_rect = tweak_data.hud_icons:get_icon_data(icon_id)
    l_13_1.description_icon:set_image(icon, texture_rect[1], texture_rect[2], texture_rect[3], texture_rect[4])
    l_13_1.description_text:set_text(string.upper(description))
  end
  l_13_1.choice_text:set_text(string.upper(l_13_0:text()))
  local current, total = l_13_0:upgrade_progress()
  local value = total ~= 0 and current / total or 0
  l_13_1.progress_bar:set_w((l_13_1.progress_bg:w() - 4) * value)
  l_13_1.progress_text:set_text(current .. "/" .. total)
  if not l_13_0:left_arrow_visible() or not tweak_data.menu.arrow_available then
    l_13_1.arrow_left:set_color(tweak_data.menu.arrow_unavailable)
  end
  if not l_13_0:right_arrow_visible() or not tweak_data.menu.arrow_available then
    l_13_1.arrow_right:set_color(tweak_data.menu.arrow_unavailable)
  end
  return true
end

MenuItemKitSlot.highlight_row_item = function(l_14_0, l_14_1, l_14_2, l_14_3)
  l_14_2.description_panel:set_visible(false)
  l_14_2.choice_text:set_color(l_14_2.color)
  l_14_2.choice_text:set_font(tweak_data.menu.default_font_no_outline_id)
  l_14_2.arrow_left:set_image("guis/textures/menu_arrows", 24, 0, 24, 24)
  l_14_2.arrow_right:set_image("guis/textures/menu_arrows", 24, 0, 24, 24)
  if not l_14_0:left_arrow_visible() or not tweak_data.menu.arrow_available then
    l_14_2.arrow_left:set_color(tweak_data.menu.arrow_unavailable)
  end
  if not l_14_0:right_arrow_visible() or not tweak_data.menu.arrow_available then
    l_14_2.arrow_right:set_color(tweak_data.menu.arrow_unavailable)
  end
  return true
end

MenuItemKitSlot.fade_row_item = function(l_15_0, l_15_1, l_15_2, l_15_3)
  l_15_2.description_panel:set_visible(false)
  if not l_15_0:arrow_visible() or not tweak_data.menu.default_changeable_text_color then
    l_15_2.choice_text:set_color(tweak_data.menu.default_disabled_text_color)
  end
  l_15_2.choice_text:set_font(tweak_data.menu.default_font_id)
  l_15_2.arrow_left:set_image("guis/textures/menu_arrows", 0, 0, 24, 24)
  l_15_2.arrow_right:set_image("guis/textures/menu_arrows", 0, 0, 24, 24)
  if not l_15_0:left_arrow_visible() or not tweak_data.menu.arrow_available then
    l_15_2.arrow_left:set_color(tweak_data.menu.arrow_unavailable)
  end
  if not l_15_0:right_arrow_visible() or not tweak_data.menu.arrow_available then
    l_15_2.arrow_right:set_color(tweak_data.menu.arrow_unavailable)
  end
  return true
end

MenuItemKitSlot._layout = function(l_16_0, l_16_1, l_16_2)
  local safe_rect = managers.gui_data:scaled_size()
  local xl_pad = 64
  l_16_2.gui_text:set_font_size(l_16_1.font_size)
  l_16_2.choice_text:set_font_size(l_16_1.font_size)
  l_16_2.gui_panel:set_width(safe_rect.width / 2 + xl_pad)
  l_16_2.gui_panel:set_x(safe_rect.width / 2 - xl_pad)
  l_16_2.arrow_right:set_size(24 * tweak_data.scale.multichoice_arrow_multiplier, 24 * tweak_data.scale.multichoice_arrow_multiplier)
  l_16_2.arrow_right:set_right(l_16_1._left_align(l_16_1) - l_16_2.gui_panel:x())
  l_16_2.arrow_left:set_size(24 * tweak_data.scale.multichoice_arrow_multiplier, 24 * tweak_data.scale.multichoice_arrow_multiplier)
  l_16_2.arrow_left:set_right(l_16_2.arrow_right:left() + 2 * (1 - tweak_data.scale.multichoice_arrow_multiplier))
  l_16_2.gui_text:set_width(l_16_2.arrow_left:left() - l_16_1._align_line_padding * 2)
  local x, y, w, h = l_16_2.gui_text:text_rect()
  l_16_2.gui_text:set_h(h)
  l_16_2.choice_panel:set_w(safe_rect.width - l_16_1._right_align(l_16_1))
  l_16_2.choice_panel:set_h(h)
  l_16_2.choice_panel:set_left(l_16_1._right_align(l_16_1) - l_16_2.gui_panel:x())
  l_16_2.choice_text:set_w(l_16_2.choice_panel:w())
  l_16_2.choice_text:set_h(h)
  l_16_2.choice_text:set_left(0)
  l_16_2.arrow_right:set_center_y(l_16_2.choice_panel:center_y())
  l_16_2.arrow_left:set_center_y(l_16_2.choice_panel:center_y())
  l_16_2.gui_text:set_left(0)
  l_16_2.gui_text:set_height(h)
  l_16_2.gui_panel:set_height(h)
  l_16_2.description_panel:set_h(126 * tweak_data.scale.kit_menu_description_h_scale)
  l_16_2.description_panel:set_w(safe_rect.width / 2)
  l_16_2.description_panel:set_right(safe_rect.width)
  l_16_2.description_panel:set_bottom(safe_rect.height - tweak_data.menu.upper_saferect_border - tweak_data.menu.border_pad)
  l_16_2.description_panel_bg:set_size(l_16_2.description_panel:size())
  local pad = 4 * tweak_data.scale.kit_menu_bar_scale
  l_16_2.description_icon:set_size(48 * tweak_data.scale.kit_menu_bar_scale, 48 * tweak_data.scale.kit_menu_bar_scale)
  l_16_2.description_icon:set_position(pad, pad)
  l_16_2.description_text:set_font_size(tweak_data.menu.kit_description_font_size)
  l_16_2.description_text:set_h(l_16_2.description_panel:h())
  l_16_2.description_text:set_w(safe_rect.width / 2 - (l_16_2.description_icon:right() + 4) - pad)
  l_16_2.description_text:set_y(pad)
  l_16_2.description_text:set_left(l_16_2.description_icon:right() + 4)
  l_16_2.description_progress_text:set_font_size(l_16_1.font_size)
  l_16_2.description_progress_text:set_left(pad)
  local _, _, w, h = l_16_2.description_progress_text:text_rect()
  l_16_2.description_progress_text:set_w(w)
  l_16_2.description_progress_text:set_bottom(l_16_2.description_panel:h() - pad)
  l_16_2.progress_bg:set_h(22 * tweak_data.scale.kit_menu_bar_scale)
  l_16_2.progress_bg:set_bottom(l_16_2.description_panel_bg:h() - pad)
  l_16_2.progress_bg:set_left(l_16_2.description_progress_text:right() + 8)
  l_16_2.progress_bg:set_w(l_16_2.description_panel:w() - l_16_2.progress_bg:left() - pad)
  local current, total = l_16_0:upgrade_progress()
  local value = total ~= 0 and current / total or 0
  l_16_2.progress_bar:set_h(l_16_2.progress_bg:h() - 4)
  l_16_2.progress_bar:set_w((l_16_2.progress_bg:w() - 4) * value)
  l_16_2.progress_bar:set_position(l_16_2.progress_bg:x() + 2, l_16_2.progress_bg:y() + 2)
  l_16_2.progress_text:set_font_size(tweak_data.menu.stats_font_size)
  l_16_2.progress_text:set_size(l_16_2.progress_bg:size())
  l_16_2.progress_text:set_position(l_16_2.progress_bg:x(), l_16_2.progress_bg:y())
end


