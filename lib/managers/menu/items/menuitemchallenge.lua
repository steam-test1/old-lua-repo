-- Decompiled using luadec 2.0.1 by sztupy (http://winmo.sztupy.hu)
-- Command line was: F:\SteamLibrary\SteamApps\common\PAYDAY 2\lua\lib\managers\menu\items\menuitemchallenge.luac 

core:import("CoreMenuItem")
if not MenuItemChallenge then
  MenuItemChallenge = class(CoreMenuItem.Item)
end
MenuItemChallenge.TYPE = "challenge"
MenuItemChallenge.init = function(l_1_0, l_1_1, l_1_2)
  CoreMenuItem.Item.init(l_1_0, l_1_1, l_1_2)
  l_1_0._parameters.description = l_1_2.description_text
  l_1_0._parameters.challenge = l_1_2.challenge
  l_1_0._type = MenuItemChallenge.TYPE
end

MenuItemChallenge.setup_gui = function(l_2_0, l_2_1, l_2_2)
  local safe_rect = managers.gui_data:scaled_size()
  local challenge_data = managers.challenges:challenge(l_2_0:parameter("challenge"))
  local progress_data = managers.challenges:active_challenge(l_2_0:parameter("challenge"))
  if not progress_data then
    progress_data = {amount = challenge_data.count}
  end
  if not l_2_0:parameter("awarded") or not tweak_data.menu.awarded_challenge_color then
    local chl_color = l_2_2.color
  end
  l_2_2.gui_panel = l_2_1.item_panel:panel({w = l_2_1.item_panel:w()})
  l_2_2.challenge_name = l_2_1._text_item_part(l_2_1, l_2_2, l_2_2.gui_panel, l_2_1._right_align(l_2_1))
  l_2_2.challenge_name:set_layer(l_2_1.layers.items + 1)
  l_2_2.challenge_name:set_font_size(tweak_data.menu.challenges_font_size)
  l_2_2.challenge_name:set_kern(tweak_data.scale.upgrade_menu_kern)
  l_2_2.challenge_name:set_color(chl_color)
  l_2_2.gui_info_panel = l_2_1.safe_rect_panel:panel({visible = false, layer = l_2_1.layers.items, x = 0, y = 0, w = l_2_1._left_align(l_2_1), h = l_2_1._item_panel_parent:h()})
  l_2_2.description_text = l_2_2.gui_info_panel:text({text = l_2_0:parameter("description"), font = tweak_data.menu.small_font, font_size = tweak_data.menu.small_font_size, color = l_2_2.color, align = "left", vertical = "top", wrap = true, word_wrap = true})
   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

  l_2_2.challenge_hl, {text = l_2_2.text, layer = l_2_1.layers.items}.word_wrap, {text = l_2_2.text, layer = l_2_1.layers.items}.wrap, {text = l_2_2.text, layer = l_2_1.layers.items}.vertical, {text = l_2_2.text, layer = l_2_1.layers.items}.align, {text = l_2_2.text, layer = l_2_1.layers.items}.color, {text = l_2_2.text, layer = l_2_1.layers.items}.font_size, {text = l_2_2.text, layer = l_2_1.layers.items}.font = l_2_2.gui_info_panel:text({text = l_2_2.text, layer = l_2_1.layers.items}), true, true, "left", "left", l_2_2.color, tweak_data.menu.challenges_font_size, l_2_1.font
  l_2_2.reward_panel = l_2_2.gui_info_panel:panel({visible = true, layer = l_2_1.layers.items, x = 0, y = 0, w = l_2_1._left_align(l_2_1), h = l_2_1._item_panel_parent:h()})
  local text = managers.localization:text("menu_reward_xp", {XP = managers.experience:cash_string(challenge_data.xp)})
  l_2_2.reward_text = l_2_2.reward_panel:text({text = text, layer = l_2_1.layers.items, font = l_2_1.font, font_size = tweak_data.menu.challenges_font_size, color = l_2_2.color, align = "left", vertical = "left"})
  local _, _, w, h = l_2_2.challenge_name:text_rect()
  l_2_2.gui_panel:set_h(h)
  do
    local bar_w = l_2_1._left_align(l_2_1) - safe_rect.width / 2
     -- DECOMPILER ERROR: Confused about usage of registers!

     -- DECOMPILER ERROR: Confused about usage of registers!

     -- DECOMPILER ERROR: Confused about usage of registers!

     -- DECOMPILER ERROR: Confused about usage of registers!

     -- DECOMPILER ERROR: Confused about usage of registers!

     -- DECOMPILER ERROR: Confused about usage of registers!

    if challenge_data.count and challenge_data.count > 1 then
      local bg_bar = l_2_2.gui_panel:rect({x = l_2_1._left_align(l_2_1) - bar_w, y = h / 2 - 11, w = bar_w, h = 22})
      l_2_2.bg_bar, {x = l_2_1._left_align(l_2_1) - bar_w, y = h / 2 - 11, w = bar_w, h = 22}.visible, {x = l_2_1._left_align(l_2_1) - bar_w, y = h / 2 - 11, w = bar_w, h = 22}.layer, {x = l_2_1._left_align(l_2_1) - bar_w, y = h / 2 - 11, w = bar_w, h = 22}.color, {x = l_2_1._left_align(l_2_1) - bar_w, y = h / 2 - 11, w = bar_w, h = 22}.vertical, {x = l_2_1._left_align(l_2_1) - bar_w, y = h / 2 - 11, w = bar_w, h = 22}.halign, {x = l_2_1._left_align(l_2_1) - bar_w, y = h / 2 - 11, w = bar_w, h = 22}.align = bg_bar, false, l_2_1.layers.items - 1, Color.black:with_alpha(0.5), "center", "center", "center"
       -- DECOMPILER ERROR: Overwrote pending register.

       -- DECOMPILER ERROR: Overwrote pending register.

       -- DECOMPILER ERROR: Confused about usage of registers!

       -- DECOMPILER ERROR: Confused about usage of registers!

       -- DECOMPILER ERROR: Confused about usage of registers!

       -- DECOMPILER ERROR: Confused about usage of registers!

       -- DECOMPILER ERROR: Confused about usage of registers!

      local bar = l_2_2.gui_panel:gradient({orientation = "vertical", gradient_points = {}, x = l_2_1._left_align(0) - bar_w + 2, y = bg_bar:y() + 2, w = (safe_rect.width - l_2_1._mid_align(tweak_data.screen_color_blue:with_alpha(0.5)) - 0) * (progress_data.amount / challenge_data.count), h = bg_bar:h() - 4})
       -- DECOMPILER ERROR: Overwrote pending register.

       -- DECOMPILER ERROR: Confused about usage of registers!

       -- DECOMPILER ERROR: Confused about usage of registers!

      local progress_text = l_2_2.gui_panel:text({font_size = tweak_data.menu.challenges_font_size, x = l_2_1._left_align(l_2_1) - bar_w, y = 0, h = h, w = bg_bar:w(), align = "right", halign = "right", vertical = "center", valign = "center", font = l_2_1.font, color = l_2_1.color, layer = l_2_1.layers.items + 1})
    end
    l_2_0:_layout(l_2_1, l_2_2)
    return true
  end
   -- Warning: undefined locals caused missing assignments!
end

MenuItemChallenge.highlight_row_item = function(l_3_0, l_3_1, l_3_2, l_3_3)
  l_3_2.gui_info_panel:set_visible(true)
  l_3_2.challenge_name:set_color(l_3_2.color)
  if not l_3_2.font or not Idstring(l_3_2.font) then
    l_3_2.challenge_name:set_font(tweak_data.menu.default_font_no_outline_id)
  end
  if l_3_2.bar then
    l_3_2.progress_text:set_color(l_3_2.color)
    if not l_3_2.font or not Idstring(l_3_2.font) then
      l_3_2.progress_text:set_font(tweak_data.menu.default_font_no_outline_id)
    end
    l_3_2.bar:set_gradient_points({})
  end
  return true
   -- Warning: undefined locals caused missing assignments!
end

MenuItemChallenge.fade_row_item = function(l_4_0, l_4_1, l_4_2)
  do
    if not l_4_0:parameter("awarded") or not tweak_data.menu.awarded_challenge_color then
      local chl_color = l_4_2.color
    end
    l_4_2.gui_info_panel:set_visible(false)
    l_4_2.challenge_name:set_color(chl_color)
    if not l_4_2.font or not Idstring(l_4_2.font) then
      l_4_2.challenge_name:set_font(tweak_data.menu.default_font_id)
    end
    if l_4_2.bar then
      l_4_2.progress_text:set_color(chl_color)
      if not l_4_2.font or not Idstring(l_4_2.font) then
        l_4_2.progress_text:set_font(tweak_data.menu.default_font_id)
      end
      l_4_2.bar:set_gradient_points({})
    end
    return true
  end
   -- Warning: undefined locals caused missing assignments!
end

local xl_pad = 64
MenuItemChallenge._layout = function(l_5_0, l_5_1, l_5_2)
  local safe_rect = managers.gui_data:scaled_size()
  l_5_2.gui_panel:set_width(safe_rect.width / 2 + xl_pad)
  l_5_2.gui_panel:set_x(safe_rect.width / 2 - xl_pad)
  local x, y, w, h = l_5_2.challenge_name:text_rect()
  l_5_2.challenge_name:set_height(h)
  l_5_2.challenge_name:set_left(l_5_1._right_align(l_5_1) - l_5_2.gui_panel:x())
  l_5_2.gui_panel:set_height(h)
  local sh = math.min(h, 22)
  if l_5_2.bg_bar then
    l_5_2.bg_bar:set_x(xl_pad)
    l_5_2.bg_bar:set_h(sh)
    l_5_2.bg_bar:set_center_y(l_5_2.gui_panel:h() / 2)
    l_5_2.bar:set_h(sh - 4)
    l_5_2.bar:set_h(l_5_2.gui_panel:h() - 1)
    l_5_2.bar:set_left(l_5_1._mid_align(l_5_1) - l_5_2.gui_panel:x() + 0)
    l_5_2.bar:set_y(1)
    l_5_2.progress_text:set_right(l_5_2.gui_panel:w() - l_5_1._align_line_padding)
  end
  l_5_1._align_item_gui_info_panel(l_5_1, l_5_2.gui_info_panel)
  l_5_1._align_item_gui_info_panel(l_5_1, l_5_2.gui_info_panel)
  l_5_2.challenge_hl:set_w(l_5_2.gui_info_panel:w())
  local _, _, w, h = l_5_2.challenge_hl:text_rect()
  l_5_2.challenge_hl:set_h(h)
  l_5_2.challenge_hl:set_x(0)
  l_5_2.challenge_hl:set_y(0)
  local _, _, w, h = l_5_2.reward_text:text_rect()
  l_5_2.reward_panel:set_h(h)
  l_5_2.reward_panel:set_w(l_5_2.gui_info_panel:w())
  l_5_2.reward_text:set_size(w, h)
  l_5_2.reward_panel:set_x(0)
  l_5_2.reward_panel:set_top(l_5_2.challenge_hl:bottom() + tweak_data.menu.info_padding)
  l_5_2.description_text:set_w(l_5_2.gui_info_panel:w())
  local _, _, w, h = l_5_2.description_text:text_rect()
  l_5_2.description_text:set_h(h)
  l_5_2.description_text:set_x(0)
  l_5_2.description_text:set_top(l_5_2.reward_panel:bottom() + tweak_data.menu.info_padding)
end


