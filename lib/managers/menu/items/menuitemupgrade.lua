-- Decompiled using luadec 2.0.1 by sztupy (http://winmo.sztupy.hu)
-- Command line was: F:\SteamLibrary\SteamApps\common\PAYDAY 2\lua\lib\managers\menu\items\menuitemupgrade.luac 

core:import("CoreMenuItem")
if not MenuItemUpgrade then
  MenuItemUpgrade = class(CoreMenuItem.Item)
end
MenuItemUpgrade.TYPE = "upgrade"
MenuItemUpgrade.init = function(l_1_0, l_1_1, l_1_2)
  CoreMenuItem.Item.init(l_1_0, l_1_1, l_1_2)
  l_1_0._parameters.upgrade_id = l_1_2.upgrade_id
  l_1_0._parameters.topic_text = l_1_2.topic_text
  l_1_0._type = MenuItemUpgrade.TYPE
end

MenuItemUpgrade.setup_gui = function(l_2_0, l_2_1, l_2_2)
  local upgrade_id = l_2_0:parameters().upgrade_id
  l_2_2.gui_panel = l_2_1.item_panel:panel({w = l_2_1.item_panel:w()})
  l_2_2.upgrade_name = l_2_1._text_item_part(l_2_1, l_2_2, l_2_2.gui_panel, l_2_1._right_align(l_2_1))
  l_2_2.upgrade_name:set_font_size(tweak_data.menu.upgrades_font_size)
  if l_2_0:parameters().topic_text then
    l_2_2.topic_text = l_2_1._text_item_part(l_2_1, l_2_2, l_2_2.gui_panel, l_2_1._left_align(l_2_1))
    l_2_2.topic_text:set_align("right")
    l_2_2.topic_text:set_font_size(tweak_data.menu.upgrades_font_size)
    l_2_2.topic_text:set_text(l_2_0:parameters().topic_text)
  end
  if l_2_0:name() == "upgrade_lock" then
    l_2_2.not_aquired = true
    l_2_2.locked = true
  else
    l_2_2.not_aquired = managers.upgrades:progress_by_tree(l_2_0:parameters().tree) < l_2_0:parameters().step
    l_2_2.locked = managers.upgrades:is_locked(l_2_0:parameters().step)
  end
  if (not l_2_2.locked or not tweak_data.menu.upgrade_locked_color) and (not l_2_2.not_aquired or not tweak_data.menu.upgrade_not_aquired_color) then
    local upg_color = l_2_2.color
  end
  if managers.upgrades:aquired(upgrade_id) then
    upg_color = l_2_2.color
  end
  l_2_2.upgrade_name:set_color(upg_color)
  if l_2_2.topic_text then
    l_2_2.topic_text:set_color(upg_color)
  end
  if l_2_0:name() ~= "upgrade_lock" then
    l_2_2.gui_info_panel = l_2_1.safe_rect_panel:panel({visible = false, layer = l_2_1.layers.items, x = 0, y = 0, w = l_2_1._left_align(l_2_1), h = l_2_1._item_panel_parent:h()})
    local image, rect = managers.upgrades:image(upgrade_id)
    l_2_2.upgrade_info_image_rect = rect
    l_2_2.upgrade_info_image = l_2_2.gui_info_panel:bitmap({texture = image, texture_rect = rect, visible = true, x = 0, y = 0, w = 340, h = 150})
     -- DECOMPILER ERROR: Confused about usage of registers!

     -- DECOMPILER ERROR: Confused about usage of registers!

     -- DECOMPILER ERROR: Confused about usage of registers!

     -- DECOMPILER ERROR: Confused about usage of registers!

    l_2_2.upgrade_info_title, {x = 0, y = 0, align = "left", halign = "top", vertical = "top", font_size = l_2_1.font_size, font = l_2_2.font, color = Color.white}.text, {x = 0, y = 0, align = "left", halign = "top", vertical = "top", font_size = l_2_1.font_size, font = l_2_2.font, color = Color.white}.layer, {x = 0, y = 0, align = "left", halign = "top", vertical = "top", font_size = l_2_1.font_size, font = l_2_2.font, color = Color.white}.word_wrap, {x = 0, y = 0, align = "left", halign = "top", vertical = "top", font_size = l_2_1.font_size, font = l_2_2.font, color = Color.white}.wrap = l_2_2.gui_info_panel:text({x = 0, y = 0, align = "left", halign = "top", vertical = "top", font_size = l_2_1.font_size, font = l_2_2.font, color = Color.white}), string.upper(managers.upgrades:complete_title(upgrade_id, " > ")), l_2_1.layers.items, true, true
     -- DECOMPILER ERROR: Confused about usage of registers!

     -- DECOMPILER ERROR: Confused about usage of registers!

     -- DECOMPILER ERROR: Confused about usage of registers!

     -- DECOMPILER ERROR: Confused about usage of registers!

    l_2_2.upgrade_info_text, {x = 0, y = 0, align = "left", halign = "top", vertical = "top", font = tweak_data.menu.small_font, font_size = tweak_data.menu.small_font_size, color = Color.white}.word_wrap, {x = 0, y = 0, align = "left", halign = "top", vertical = "top", font = tweak_data.menu.small_font, font_size = tweak_data.menu.small_font_size, color = Color.white}.wrap, {x = 0, y = 0, align = "left", halign = "top", vertical = "top", font = tweak_data.menu.small_font, font_size = tweak_data.menu.small_font_size, color = Color.white}.text, {x = 0, y = 0, align = "left", halign = "top", vertical = "top", font = tweak_data.menu.small_font, font_size = tweak_data.menu.small_font_size, color = Color.white}.layer = l_2_2.gui_info_panel:text({x = 0, y = 0, align = "left", halign = "top", vertical = "top", font = tweak_data.menu.small_font, font_size = tweak_data.menu.small_font_size, color = Color.white}), true, true, string.upper(managers.upgrades:description(upgrade_id)), l_2_1.layers.items
    if tweak_data.upgrades.visual.upgrade[upgrade_id] and not tweak_data.upgrades.visual.upgrade[upgrade_id].base then
      l_2_2.upgrade_icon = l_2_2.gui_panel:bitmap({texture = "guis/textures/icon_star", texture_rect = {0, 0, 32, 32}, layer = l_2_1.layers.items, color = upg_color})
       -- DECOMPILER ERROR: Confused about usage of registers!

       -- DECOMPILER ERROR: Confused about usage of registers!

       -- DECOMPILER ERROR: Confused about usage of registers!

       -- DECOMPILER ERROR: Confused about usage of registers!

      if managers.upgrades:aquired(upgrade_id) then
        l_2_2.toggle_text, {x = 0, y = 0, align = "left", halign = "top", vertical = "top", font = tweak_data.menu.small_font, font_size = tweak_data.menu.small_font_size, color = Color.white}.word_wrap, {x = 0, y = 0, align = "left", halign = "top", vertical = "top", font = tweak_data.menu.small_font, font_size = tweak_data.menu.small_font_size, color = Color.white}.wrap, {x = 0, y = 0, align = "left", halign = "top", vertical = "top", font = tweak_data.menu.small_font, font_size = tweak_data.menu.small_font_size, color = Color.white}.text, {x = 0, y = 0, align = "left", halign = "top", vertical = "top", font = tweak_data.menu.small_font, font_size = tweak_data.menu.small_font_size, color = Color.white}.layer = l_2_2.gui_info_panel:text({x = 0, y = 0, align = "left", halign = "top", vertical = "top", font = tweak_data.menu.small_font, font_size = tweak_data.menu.small_font_size, color = Color.white}), true, true, "", l_2_1.layers.items
        l_2_0:reload(l_2_2, l_2_1)
      end
    end
  end
  l_2_0:_layout(l_2_1, l_2_2)
  return true
end

MenuItemUpgrade.reload = function(l_3_0, l_3_1, l_3_2)
  local upgrade_id = l_3_0:parameters().upgrade_id
  if l_3_1.toggle_text then
    local text = nil
    if not managers.upgrades:visual_weapon_upgrade_active(upgrade_id) then
      text = managers.localization:text("menu_show_upgrade_info", {UPGRADE = managers.localization:text("menu_" .. upgrade_id .. "_info")})
    else
      text = managers.localization:text("menu_hide_upgrade_info", {UPGRADE = managers.localization:text("menu_" .. upgrade_id .. "_info")})
    end
    l_3_1.toggle_text:set_text(string.upper(text))
  end
  return true
end

MenuItemUpgrade.highlight_row_item = function(l_4_0, l_4_1, l_4_2, l_4_3)
  if l_4_2.gui_info_panel then
    l_4_2.gui_info_panel:set_visible(true)
  end
  l_4_2.upgrade_name:set_color(l_4_2.color)
  l_4_2.upgrade_name:set_font(tweak_data.menu.default_font_no_outline_id)
  if l_4_2.topic_text then
    l_4_2.topic_text:set_color(l_4_2.color)
    l_4_2.topic_text:set_font(tweak_data.menu.default_font_no_outline_id)
  end
  if l_4_2.upgrade_icon then
    l_4_2.upgrade_icon:set_image("guis/textures/icon_star", 32, 0, 32, 32)
  end
  return true
end

MenuItemUpgrade.fade_row_item = function(l_5_0, l_5_1, l_5_2)
  if l_5_2.gui_info_panel then
    l_5_2.gui_info_panel:set_visible(false)
  end
  if (not l_5_2.locked or not tweak_data.menu.upgrade_locked_color) and (not l_5_2.not_aquired or not tweak_data.menu.upgrade_not_aquired_color) then
    local upg_color = l_5_2.color
  end
  if managers.upgrades:aquired(l_5_0:parameters().upgrade_id) then
    upg_color = l_5_2.color
  end
  l_5_2.upgrade_name:set_color(upg_color)
  l_5_2.upgrade_name:set_font(tweak_data.menu.default_font_id)
  if l_5_2.topic_text then
    l_5_2.topic_text:set_color(upg_color)
    l_5_2.topic_text:set_font(tweak_data.menu.default_font_id)
  end
  if l_5_2.upgrade_icon then
    l_5_2.upgrade_icon:set_image("guis/textures/icon_star", 0, 0, 32, 32)
  end
  return true
end

local xl_pad = 64
MenuItemUpgrade._layout = function(l_6_0, l_6_1, l_6_2)
  local safe_rect = managers.gui_data:scaled_size()
  l_6_2.gui_panel:set_width(safe_rect.width / 2 + xl_pad * 1.5)
  l_6_2.gui_panel:set_x(safe_rect.width / 2 - xl_pad * 1.5)
  local x, y, w, h = l_6_2.upgrade_name:text_rect()
  l_6_2.upgrade_name:set_height(h)
  l_6_2.upgrade_name:set_left(l_6_1._right_align(l_6_1) - l_6_2.gui_panel:x())
  l_6_2.gui_panel:set_height(h)
  if l_6_2.topic_text then
    l_6_2.topic_text:set_height(h)
    l_6_2.topic_text:set_right(l_6_2.gui_panel:w())
  end
  if l_6_2.upgrade_icon then
    local s = math.min(32, h * 1.75)
    l_6_2.upgrade_icon:set_size(s, s)
    l_6_2.upgrade_icon:set_left(l_6_1._right_align(l_6_1) - l_6_2.gui_panel:x() + w + l_6_1._align_line_padding)
    l_6_2.upgrade_icon:set_center_y(h / 2)
  end
  if l_6_2.gui_info_panel then
    l_6_1._align_item_gui_info_panel(l_6_1, l_6_2.gui_info_panel)
    local w = l_6_2.gui_info_panel:w()
    local m = l_6_2.upgrade_info_image_rect[3] / l_6_2.upgrade_info_image_rect[4]
    l_6_2.upgrade_info_image:set_size(w, w / m)
    l_6_2.upgrade_info_image:set_y(0)
    l_6_2.upgrade_info_image:set_center_x(l_6_2.gui_info_panel:w() / 2)
    l_6_2.upgrade_info_title:set_width(w)
    local _, _, _, h = l_6_2.upgrade_info_title:text_rect()
    l_6_2.upgrade_info_title:set_height(h)
    l_6_2.upgrade_info_title:set_top(l_6_2.upgrade_info_image:bottom() + tweak_data.menu.info_padding)
    l_6_2.upgrade_info_text:set_top(l_6_2.upgrade_info_image:bottom() + h + tweak_data.menu.info_padding * 2)
    l_6_2.upgrade_info_text:set_width(w)
    local _, _, _, h = l_6_2.upgrade_info_text:text_rect()
    l_6_2.upgrade_info_text:set_height(h)
    if l_6_2.toggle_text then
      l_6_2.toggle_text:set_width(l_6_2.gui_info_panel:w())
      local _, _, _, h = l_6_2.toggle_text:text_rect()
      l_6_2.toggle_text:set_height(h)
      l_6_2.toggle_text:set_bottom(l_6_2.gui_info_panel:height())
      l_6_2.toggle_text:set_left(0)
    end
  end
end


