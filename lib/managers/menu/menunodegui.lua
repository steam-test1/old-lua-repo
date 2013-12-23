-- Decompiled using luadec 2.0.1 by sztupy (http://winmo.sztupy.hu)
-- Command line was: F:\SteamLibrary\SteamApps\common\PAYDAY 2\lua\lib\managers\menu\menunodegui.luac 

core:import("CoreMenuNodeGui")
if not MenuNodeGui then
  MenuNodeGui = class(CoreMenuNodeGui.NodeGui)
end
MenuNodeGui.init = function(l_1_0, l_1_1, l_1_2, l_1_3)
  local name = l_1_1:parameters().name
  local lang_mods = {}
  lang_mods[Idstring("german"):key()] = ((name ~= "kit" or not 0.94999998807907) and (name ~= "challenges_active" or not 0.875) and (name == "challenges_awarded" and 0.875)) or 0.89999997615814
  lang_mods[Idstring("french"):key()] = (((name ~= "kit" or not 0.97500002384186) and (name ~= "challenges_active" or not 0.8740000128746) and (name ~= "challenges_awarded" or not 0.8740000128746) and (name == "upgrades_support" and 0.875))) or 0.89999997615814
  lang_mods[Idstring("italian"):key()] = ((name ~= "kit" or not 0.97500002384186) and (name ~= "challenges_active" or not 0.875) and (name == "challenges_awarded" and 0.875)) or 0.94999998807907
  lang_mods[Idstring("spanish"):key()] = (((name ~= "kit" or not 1) and ((name == "upgrades_assault" or name == "upgrades_sharpshooter" or name == "upgrades_support") and 0.97500002384186))) or 0.92500001192093
  lang_mods[Idstring("english"):key()] = (name == "challenges_active" and 0.92500001192093) or (name == "challenges_awarded" and 0.92500001192093) or 1
  local mod = lang_mods[SystemInfo:language():key()] or 1
  l_1_0._align_line_proportions = l_1_1:parameters().align_line_proportions or 0.64999997615814
  l_1_0._align_line_padding = 10 * tweak_data.scale.align_line_padding_multiplier
  l_1_0._use_info_rect = not l_1_1:parameters().use_info_rect and ((l_1_1:parameters().use_info_rect == nil and true))
  l_1_0._stencil_align = l_1_1:parameters().stencil_align or "right"
  l_1_0._stencil_align_percent = l_1_1:parameters().stencil_align_percent or 0
  l_1_0._stencil_image = l_1_1:parameters().stencil_image
  l_1_0._scene_state = l_1_1:parameters().scene_state
  l_1_0._no_menu_wrapper = true
  l_1_0._is_loadout = l_1_1:parameters().is_loadout
  l_1_0._align = l_1_1:parameters().align or "mid"
  l_1_0._bg_visible = l_1_1:parameters().hide_bg
  l_1_0._bg_visible = l_1_0._bg_visible == nil
  l_1_0._bg_area = l_1_1:parameters().area_bg
  if l_1_0._bg_area or not "full" then
    l_1_0._bg_area = l_1_0._bg_area
  end
  l_1_0.row_item_color = tweak_data.screen_color_blue:with_alpha(0.5)
  l_1_0.row_item_hightlight_color = tweak_data.screen_color_blue
  MenuNodeGui.super.init(l_1_0, l_1_1, l_1_2, l_1_3)
  if l_1_1:parameters().no_item_parent then
    l_1_0._item_panel_parent:set_visible(false)
  end
end

MenuNodeGui.align_line_padding = function(l_2_0)
  return l_2_0._align_line_padding
end

MenuNodeGui._mid_align = function(l_3_0)
  local safe_rect = l_3_0:_scaled_size()
  return safe_rect.width * l_3_0._align_line_proportions
end

MenuNodeGui._right_align = function(l_4_0, l_4_1)
  local safe_rect = l_4_0:_scaled_size()
   -- DECOMPILER ERROR: Confused while interpreting a jump as a 'while'

end
return safe_rect.width * l_4_0._align_line_proportions + l_4_0._align_line_padding
end

MenuNodeGui._left_align = function(l_5_0, l_5_1)
  local safe_rect = l_5_0:_scaled_size()
   -- DECOMPILER ERROR: Confused while interpreting a jump as a 'while'

end
return safe_rect.width * l_5_0._align_line_proportions - l_5_0._align_line_padding
end

MenuNodeGui._world_right_align = function(l_6_0)
  local safe_rect = l_6_0:_scaled_size()
  return safe_rect.x + safe_rect.width * l_6_0._align_line_proportions + l_6_0._align_line_padding
end

MenuNodeGui._world_left_align = function(l_7_0)
  local safe_rect = l_7_0:_scaled_size()
  return safe_rect.x + safe_rect.width * l_7_0._align_line_proportions - l_7_0._align_line_padding
end

MenuNodeGui._setup_panels = function(l_8_0, l_8_1)
  MenuNodeGui.super._setup_panels(l_8_0, l_8_1)
  local safe_rect_pixels = l_8_0:_scaled_size()
  local res = RenderSettings.resolution
  l_8_0._topic_panel2 = l_8_0.ws:panel():panel({visible = not l_8_0._no_menu_wrapper, x = safe_rect_pixels.x, y = safe_rect_pixels.y, w = safe_rect_pixels.width, h = tweak_data.load_level.upper_saferect_border})
  l_8_0._topic_line = l_8_0._topic_panel2:bitmap({texture = "guis/textures/headershadow", layer = l_8_0.layers.items, color = Color.white, w = safe_rect_pixels.width - l_8_0:_mid_align(), y = 0})
   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

  l_8_0._topic_text2, {text = l_8_1:parameters().topic_id and managers.localization:text(l_8_1:parameters().topic_id) or "Topic", x = 0, y = 0, w = safe_rect_pixels.width, font_size = tweak_data.menu.topic_font_size, align = "right", halign = "right", vertical = "bottom"}.layer, {text = l_8_1:parameters().topic_id and managers.localization:text(l_8_1:parameters().topic_id) or "Topic", x = 0, y = 0, w = safe_rect_pixels.width, font_size = tweak_data.menu.topic_font_size, align = "right", halign = "right", vertical = "bottom"}.color, {text = l_8_1:parameters().topic_id and managers.localization:text(l_8_1:parameters().topic_id) or "Topic", x = 0, y = 0, w = safe_rect_pixels.width, font_size = tweak_data.menu.topic_font_size, align = "right", halign = "right", vertical = "bottom"}.font, {text = l_8_1:parameters().topic_id and managers.localization:text(l_8_1:parameters().topic_id) or "Topic", x = 0, y = 0, w = safe_rect_pixels.width, font_size = tweak_data.menu.topic_font_size, align = "right", halign = "right", vertical = "bottom"}.valign = l_8_0._topic_panel2:text({text = l_8_1:parameters().topic_id and managers.localization:text(l_8_1:parameters().topic_id) or "Topic", x = 0, y = 0, w = safe_rect_pixels.width, font_size = tweak_data.menu.topic_font_size, align = "right", halign = "right", vertical = "bottom"}), l_8_0.layers.items + 1, l_8_0.row_item_color, l_8_0.font, "bottom"
  local _, _, w, h = l_8_0._topic_text2:text_rect()
  l_8_0._topic_text2:set_h(h)
  l_8_0._items_bottom_line = l_8_0._item_panel_parent:bitmap({visible = not l_8_0._no_menu_wrapper, texture = "guis/textures/headershadowdown", layer = l_8_0.layers.items, color = Color.white, w = safe_rect_pixels.width - l_8_0:_mid_align(), y = 0})
  l_8_0:_create_align(l_8_1)
  l_8_0:_create_marker(l_8_1)
  local w = 200
  local h = 20
  local base = 20
  local height = 15
  l_8_0._list_arrows = {}
  local aw = safe_rect_pixels.width - l_8_0:_mid_align()
  l_8_0._list_arrows.up = l_8_0.ws:panel():bitmap({texture = "guis/textures/scroll_up", visible = false, x = l_8_0:_mid_align(), y = 0, w = aw, layer = l_8_0.layers.items + 2, color = l_8_0.row_item_color:with_alpha(1)})
  l_8_0._list_arrows.down = l_8_0.ws:panel():bitmap({texture = "guis/textures/scroll_down", visible = false, x = l_8_0:_mid_align(), y = 0, w = aw, layer = l_8_0.layers.items + 2, color = l_8_0.row_item_color:with_alpha(1)})
  l_8_0._info_bg_rect = l_8_0.safe_rect_panel:rect({visible = false, x = 0, y = tweak_data.load_level.upper_saferect_border, w = safe_rect_pixels.width * 0.40999999642372, h = safe_rect_pixels.height - tweak_data.load_level.upper_saferect_border * 2, layer = l_8_0.layers.first, color = Color(0.5, 0, 0, 0)})
  l_8_0:_create_legends(l_8_1)
  local active_menu = managers.menu:active_menu()
  if active_menu then
    active_menu.renderer:set_stencil_image(l_8_0._stencil_image)
    active_menu.renderer:set_stencil_align(l_8_0._stencil_align, l_8_0._stencil_align_percent)
    active_menu.renderer:set_bg_visible(l_8_0._bg_visible)
    active_menu.renderer:set_bg_area(l_8_0._bg_area)
  end
  if l_8_0._scene_state then
    managers.menu_scene:set_scene_template(l_8_0._scene_state)
  end
  local mini_info = l_8_0.safe_rect_panel:panel({x = 0, y = 0, w = 0, h = 0})
   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

  local mini_text = mini_info:text({x = 0, y = 0, align = "left", halign = "top", vertical = "top", font = tweak_data.menu.pd2_small_font, font_size = tweak_data.menu.pd2_small_font_size, color = Color.white})
  mini_info:set_width((l_8_0._info_bg_rect:w() - tweak_data.menu.info_padding * 2) * 2)
  {x = 0, y = 0, align = "left", halign = "top", vertical = "top", font = tweak_data.menu.pd2_small_font, font_size = tweak_data.menu.pd2_small_font_size, color = Color.white}.word_wrap, {x = 0, y = 0, align = "left", halign = "top", vertical = "top", font = tweak_data.menu.pd2_small_font, font_size = tweak_data.menu.pd2_small_font_size, color = Color.white}.wrap, {x = 0, y = 0, align = "left", halign = "top", vertical = "top", font = tweak_data.menu.pd2_small_font, font_size = tweak_data.menu.pd2_small_font_size, color = Color.white}.text, {x = 0, y = 0, align = "left", halign = "top", vertical = "top", font = tweak_data.menu.pd2_small_font, font_size = tweak_data.menu.pd2_small_font_size, color = Color.white}.layer = true, true, "", l_8_0.layers.items
  mini_text:set_width(mini_info:w())
  mini_info:set_height(100)
  mini_text:set_height(100)
  mini_info:set_top(l_8_0._info_bg_rect:bottom() + tweak_data.menu.info_padding)
  mini_text:set_top(0)
  mini_info:set_left(tweak_data.menu.info_padding)
  mini_text:set_left(0)
  l_8_0._mini_info_text = mini_text
  if l_8_1.mini_info then
    l_8_0:set_mini_info(l_8_1.mini_info)
  end
end

MenuNodeGui.set_mini_info = function(l_9_0, l_9_1)
  l_9_0._mini_info_text:set_text(l_9_1)
end

MenuNodeGui._create_legends = function(l_10_0, l_10_1)
  local safe_rect_pixels = l_10_0:_scaled_size()
  local res = RenderSettings.resolution
  local visible = not managers.menu:is_pc_controller()
  local is_pc = managers.menu:is_pc_controller()
  l_10_0._legends_panel = l_10_0.ws:panel():panel({visible = visible, x = safe_rect_pixels.x, y = safe_rect_pixels.y, w = safe_rect_pixels.width, h = safe_rect_pixels.height})
  local t_text = ""
  local has_pc_legend = false
  for i,legend in ipairs(l_10_1:legends()) do
    if not is_pc or legend.pc then
      if not has_pc_legend then
        has_pc_legend = legend.pc
      end
      local spacing = i > 1 and "  |  " or ""
      t_text = t_text .. spacing .. utf8.to_upper(managers.localization:text(legend.string_id, {BTN_UPDATE = managers.localization:btn_macro("menu_update"), BTN_BACK = managers.localization:btn_macro("back")}))
    end
  end
  if is_pc then
    l_10_0._legends_panel:set_visible(has_pc_legend)
  end
  local text = l_10_0._legends_panel:text({text = t_text, font = l_10_0.font, font_size = l_10_0.font_size, color = l_10_0.color, layer = l_10_0.layers.items})
  local _, _, w, h = text:text_rect()
  text:set_size(w, h)
  l_10_0:_layout_legends()
end

MenuNodeGui._create_align = function(l_11_0, l_11_1)
  l_11_0._align_data = {}
  l_11_0._align_data.panel = l_11_0._item_panel_parent:panel({x = l_11_0:_left_align(), y = 0, w = l_11_0._align_line_padding * 2, h = l_11_0._item_panel_parent:h(), layer = l_11_0.layers.marker})
end

MenuNodeGui._create_marker = function(l_12_0, l_12_1)
  l_12_0._marker_data = {}
  l_12_0._marker_data.marker = l_12_0.item_panel:panel({x = 0, y = 0, w = 1280, h = 10, layer = l_12_0.layers.marker})
  l_12_0._marker_data.gradient = l_12_0._marker_data.marker:bitmap({texture = "guis/textures/menu_selected", x = 0, y = 0, layer = 0, blend_mode = "add", alpha = l_12_0.marker_alpha or 0.60000002384186})
  if l_12_0.marker_color then
    l_12_0._marker_data.gradient:set_color(l_12_0.marker_color)
  end
end

MenuNodeGui._setup_item_rows = function(l_13_0, l_13_1)
  MenuNodeGui.super._setup_item_rows(l_13_0, l_13_1)
end

MenuNodeGui._setup_item_panel_parent = function(l_14_0, l_14_1, l_14_2)
  local res = RenderSettings.resolution
  if not l_14_2 then
    l_14_2 = {}
  end
  if not l_14_2.x then
    local x = l_14_1.x
  end
  if not l_14_2.y then
    local y = l_14_1.y + CoreMenuRenderer.Renderer.border_height
  end
  if not l_14_2.w then
    local w = l_14_1.width
  end
  if not l_14_2.h then
    local h = l_14_1.height - CoreMenuRenderer.Renderer.border_height * 2
  end
  l_14_0._item_panel_parent:set_shape(x, y, w, h)
  l_14_0._align_data.panel:set_h(l_14_0._item_panel_parent:h())
  l_14_0._list_arrows.up:set_h(48 * tweak_data.scale.menu_arrow_padding_multiplier)
  l_14_0._list_arrows.up:set_lefttop(l_14_0._align_data.panel:world_center(), l_14_0._align_data.panel:world_top())
  l_14_0._list_arrows.down:set_h(48 * tweak_data.scale.menu_arrow_padding_multiplier)
  l_14_0._list_arrows.down:set_leftbottom(l_14_0._align_data.panel:world_center(), l_14_0._align_data.panel:world_bottom())
  l_14_0._legends_panel:set_bottom(l_14_0.ws:panel():bottom())
  l_14_0._item_panel_parent:set_y(l_14_0._item_panel_parent:y() + 0 * tweak_data.scale.menu_arrow_padding_multiplier + (l_14_0._is_loadout and 300 or 0))
  l_14_0._item_panel_parent:set_h(l_14_0._item_panel_parent:h() - 0 * tweak_data.scale.menu_arrow_padding_multiplier)
end

MenuNodeGui._setup_item_panel = function(l_15_0, l_15_1, l_15_2)
  if l_15_0._align == "mid" then
    do return end
    if not l_15_0._item_panel_y then
      l_15_0._item_panel_y = {first = l_15_0._item_panel_parent:h() / 2, current = l_15_0._item_panel_parent:h() / 2}
    end
    if l_15_0:_item_panel_height() < l_15_0._item_panel_parent:h() then
      l_15_0._item_panel_y.target = l_15_0._item_panel_parent:h() / 2
    else
      l_15_0.item_panel:set_shape(0, l_15_0.item_panel:y(), l_15_1.width, l_15_0:_item_panel_height())
      if not l_15_0._item_panel_y then
        l_15_0.item_panel:set_center_y(l_15_0._item_panel_parent:h() / 2)
      else
        if l_15_0._item_panel_y.first then
          l_15_0.item_panel:set_center_y(l_15_0._item_panel_parent:h() / 2)
          l_15_0._item_panel_y.first = nil
        else
          if l_15_0:_item_panel_height() >= l_15_0._item_panel_parent:h() or not 0 then
            local y = l_15_0.item_panel:y()
          end
          l_15_0.item_panel:set_shape(0, y, l_15_1.width, l_15_0:_item_panel_height())
        end
      end
    end
    l_15_0.item_panel:set_w(l_15_1.width)
    l_15_0:_set_topic_position()
    if l_15_0._item_panel_parent:h() < l_15_0.item_panel:h() then
      l_15_0._list_arrows.up:set_visible(true)
      l_15_0._list_arrows.down:set_visible(true)
      l_15_0._list_arrows.up:set_color(l_15_0._list_arrows.up:color():with_alpha(0.5))
    end
     -- Warning: missing end command somewhere! Added here
  end
end

MenuNodeGui._set_topic_position = function(l_16_0)
  l_16_0._topic_panel2:set_right(l_16_0.item_panel:right())
  local bottom = l_16_0.item_panel:top() + l_16_0._item_panel_parent:y()
   -- DECOMPILER ERROR: Confused while interpreting a jump as a 'while'

end
l_16_0._topic_panel2:set_bottom(bottom)
l_16_0._topic_text2:set_rightbottom(l_16_0._topic_panel2:size())
l_16_0._topic_line:set_rightbottom(l_16_0._topic_panel2:size())
l_16_0._items_bottom_line:set_y(l_16_0.item_panel:bottom())
l_16_0._items_bottom_line:set_right(l_16_0.item_panel:right())
end

MenuNodeGui._create_menu_item = function(l_17_0, l_17_1)
  local safe_rect = l_17_0:_scaled_size()
  local align_x = safe_rect.width * l_17_0._align_line_proportions
  if l_17_1.gui_panel then
    l_17_0.item_panel:remove(l_17_1.gui_panel)
  end
  if alive(l_17_1.gui_pd2_panel) then
    l_17_1.gui_pd2_panel:parent():remove(l_17_1.gui_pd2_panel)
  end
  if l_17_1.item:parameters().back then
    l_17_1.item:parameters().back = false
    l_17_1.item:parameters().pd2_corner = true
  end
  if l_17_1.item:parameters().back then
    l_17_1.gui_panel = l_17_0._item_panel_parent:panel({layer = l_17_0.layers.items, w = 30, h = 30})
     -- DECOMPILER ERROR: Confused about usage of registers!

     -- DECOMPILER ERROR: Confused about usage of registers!

     -- DECOMPILER ERROR: Confused about usage of registers!

     -- DECOMPILER ERROR: Confused about usage of registers!

     -- DECOMPILER ERROR: Confused about usage of registers!

     -- DECOMPILER ERROR: Confused about usage of registers!

     -- DECOMPILER ERROR: Confused about usage of registers!

    l_17_1.unselected, {visible = false, texture = "guis/textures/menu_unselected"}.layer, {visible = false, texture = "guis/textures/menu_unselected"}.w, {visible = false, texture = "guis/textures/menu_unselected"}.h, {visible = false, texture = "guis/textures/menu_unselected"}.halign, {visible = false, texture = "guis/textures/menu_unselected"}.valign, {visible = false, texture = "guis/textures/menu_unselected"}.y, {visible = false, texture = "guis/textures/menu_unselected"}.x = l_17_1.gui_panel:bitmap({visible = false, texture = "guis/textures/menu_unselected"}), -1, l_17_1.gui_panel:w(), l_17_1.gui_panel:h(), nil, nil, 0, 0
     -- DECOMPILER ERROR: Confused about usage of registers!

     -- DECOMPILER ERROR: Confused about usage of registers!

     -- DECOMPILER ERROR: Confused about usage of registers!

     -- DECOMPILER ERROR: Confused about usage of registers!

     -- DECOMPILER ERROR: Confused about usage of registers!

     -- DECOMPILER ERROR: Confused about usage of registers!

     -- DECOMPILER ERROR: Confused about usage of registers!

    l_17_1.selected, {visible = false, texture = "guis/textures/menu_selected"}.layer, {visible = false, texture = "guis/textures/menu_selected"}.w, {visible = false, texture = "guis/textures/menu_selected"}.h, {visible = false, texture = "guis/textures/menu_selected"}.halign, {visible = false, texture = "guis/textures/menu_selected"}.valign, {visible = false, texture = "guis/textures/menu_selected"}.y, {visible = false, texture = "guis/textures/menu_selected"}.x = l_17_1.gui_panel:bitmap({visible = false, texture = "guis/textures/menu_selected"}), 0, l_17_1.gui_panel:w(), l_17_1.gui_panel:h(), nil, nil, 0, 0
    l_17_1.shadow = l_17_1.gui_panel:bitmap({visible = false, texture = "guis/textures/headershadowdown", layer = l_17_0.layers.items})
    l_17_1.shadow_bottom = l_17_1.gui_panel:bitmap({visible = false, texture = "guis/textures/headershadowdown", rotation = 180, layer = l_17_0.layers.items})
     -- DECOMPILER ERROR: Confused about usage of registers!

     -- DECOMPILER ERROR: Confused about usage of registers!

     -- DECOMPILER ERROR: Confused about usage of registers!

     -- DECOMPILER ERROR: Confused about usage of registers!

     -- DECOMPILER ERROR: Confused about usage of registers!

    l_17_1.arrow_selected, {blend_mode = "add", visible = false, texture = "guis/textures/menu_arrows", texture_rect = {0, 0, 24, 24}, x = 0, y = 0}.layer, {blend_mode = "add", visible = false, texture = "guis/textures/menu_arrows", texture_rect = {0, 0, 24, 24}, x = 0, y = 0}.w, {blend_mode = "add", visible = false, texture = "guis/textures/menu_arrows", texture_rect = {0, 0, 24, 24}, x = 0, y = 0}.h, {blend_mode = "add", visible = false, texture = "guis/textures/menu_arrows", texture_rect = {0, 0, 24, 24}, x = 0, y = 0}.halign, {blend_mode = "add", visible = false, texture = "guis/textures/menu_arrows", texture_rect = {0, 0, 24, 24}, x = 0, y = 0}.valign = l_17_1.gui_panel:bitmap({blend_mode = "add", visible = false, texture = "guis/textures/menu_arrows", texture_rect = {0, 0, 24, 24}, x = 0, y = 0}), l_17_0.layers.items, l_17_1.gui_panel:w(), l_17_1.gui_panel:w()
     -- DECOMPILER ERROR: Confused about usage of registers!

     -- DECOMPILER ERROR: Confused about usage of registers!

     -- DECOMPILER ERROR: Confused about usage of registers!

     -- DECOMPILER ERROR: Confused about usage of registers!

     -- DECOMPILER ERROR: Confused about usage of registers!

    l_17_1.arrow_unselected, {blend_mode = "add", visible = true, texture = "guis/textures/menu_arrows", texture_rect = {24, 0, 24, 24}, x = 0, y = 0}.layer, {blend_mode = "add", visible = true, texture = "guis/textures/menu_arrows", texture_rect = {24, 0, 24, 24}, x = 0, y = 0}.w, {blend_mode = "add", visible = true, texture = "guis/textures/menu_arrows", texture_rect = {24, 0, 24, 24}, x = 0, y = 0}.h, {blend_mode = "add", visible = true, texture = "guis/textures/menu_arrows", texture_rect = {24, 0, 24, 24}, x = 0, y = 0}.halign, {blend_mode = "add", visible = true, texture = "guis/textures/menu_arrows", texture_rect = {24, 0, 24, 24}, x = 0, y = 0}.valign = l_17_1.gui_panel:bitmap({blend_mode = "add", visible = true, texture = "guis/textures/menu_arrows", texture_rect = {24, 0, 24, 24}, x = 0, y = 0}), l_17_0.layers.items, l_17_1.gui_panel:w(), l_17_1.gui_panel:w()
  else
    if l_17_1.item:parameters().pd2_corner then
      l_17_1.gui_panel = l_17_0._item_panel_parent:panel({layer = l_17_0.layers.items, w = 3, h = 3})
      l_17_1.gui_pd2_panel = l_17_0.ws:panel():panel({layer = l_17_0.layers.items})
      if not managers.menu:is_pc_controller() or not l_17_1.gui_pd2_panel then
        local row_item_panel = l_17_1.gui_panel
      end
       -- DECOMPILER ERROR: Confused about usage of registers!

       -- DECOMPILER ERROR: Confused about usage of registers!

       -- DECOMPILER ERROR: Confused about usage of registers!

       -- DECOMPILER ERROR: Confused about usage of registers!

       -- DECOMPILER ERROR: Confused about usage of registers!

      l_17_1.gui_text, {font_size = tweak_data.menu.pd2_large_font_size, x = 0, y = 0, align = "right", vertical = "bottom", font = tweak_data.menu.pd2_large_font}.render_template, {font_size = tweak_data.menu.pd2_large_font_size, x = 0, y = 0, align = "right", vertical = "bottom", font = tweak_data.menu.pd2_large_font}.blend_mode, {font_size = tweak_data.menu.pd2_large_font_size, x = 0, y = 0, align = "right", vertical = "bottom", font = tweak_data.menu.pd2_large_font}.text, {font_size = tweak_data.menu.pd2_large_font_size, x = 0, y = 0, align = "right", vertical = "bottom", font = tweak_data.menu.pd2_large_font}.layer, {font_size = tweak_data.menu.pd2_large_font_size, x = 0, y = 0, align = "right", vertical = "bottom", font = tweak_data.menu.pd2_large_font}.color = row_item_panel:text({font_size = tweak_data.menu.pd2_large_font_size, x = 0, y = 0, align = "right", vertical = "bottom", font = tweak_data.menu.pd2_large_font}), Idstring("VertexColorTextured"), "add", utf8.to_upper(l_17_1.text), 0, tweak_data.screen_colors.button_stage_3
      local _, _, w, h = l_17_1.gui_text:text_rect()
      l_17_1.gui_text:set_size(math.round(w), math.round(h))
      if managers.menu:is_pc_controller() then
        l_17_1.gui_text:set_rightbottom(l_17_1.gui_pd2_panel:w(), l_17_1.gui_pd2_panel:h())
      else
        l_17_1.gui_text:set_rotation(360)
        l_17_1.gui_text:set_right(l_17_1.gui_pd2_panel:w())
      end
       -- DECOMPILER ERROR: Confused about usage of registers!

       -- DECOMPILER ERROR: Confused about usage of registers!

       -- DECOMPILER ERROR: Confused about usage of registers!

       -- DECOMPILER ERROR: Confused about usage of registers!

       -- DECOMPILER ERROR: Confused about usage of registers!

       -- DECOMPILER ERROR: Confused about usage of registers!

      if MenuBackdropGUI and managers.menu:is_pc_controller() then
        local bg_text = l_17_1.gui_pd2_panel:text({text = utf8.to_upper(l_17_1.text), h = 90, align = "right", vertical = "bottom"})
        bg_text:set_right(l_17_1.gui_text:right())
        {text = utf8.to_upper(l_17_1.text), h = 90, align = "right", vertical = "bottom"}.rotation, {text = utf8.to_upper(l_17_1.text), h = 90, align = "right", vertical = "bottom"}.layer, {text = utf8.to_upper(l_17_1.text), h = 90, align = "right", vertical = "bottom"}.alpha, {text = utf8.to_upper(l_17_1.text), h = 90, align = "right", vertical = "bottom"}.color, {text = utf8.to_upper(l_17_1.text), h = 90, align = "right", vertical = "bottom"}.font, {text = utf8.to_upper(l_17_1.text), h = 90, align = "right", vertical = "bottom"}.font_size = 360, -1, 0.40000000596046, tweak_data.screen_colors.button_stage_3, tweak_data.menu.pd2_massive_font, tweak_data.menu.pd2_massive_font_size
        bg_text:set_center_y(l_17_1.gui_text:center_y())
        bg_text:move(13, -9)
        MenuBackdropGUI.animate_bg_text(l_17_0, bg_text)
      elseif l_17_1.type == "level" then
        l_17_1.gui_panel = l_17_0:_text_item_part(l_17_1, l_17_0.item_panel, l_17_0:_right_align())
        l_17_1.gui_panel:set_text(utf8.to_upper(l_17_1.gui_panel:text()))
        l_17_1.gui_level_panel = l_17_0._item_panel_parent:panel({visible = false, layer = l_17_0.layers.items, x = 0, y = 0, w = l_17_0:_left_align(), h = l_17_0._item_panel_parent:h()})
        local level_data = l_17_1.item:parameters().level_id
        level_data = tweak_data.levels[level_data]
        local description = level_data and level_data.briefing_id and managers.localization:text(level_data.briefing_id) or "Missing description text"
        local image = level_data and level_data.loading_image or "guis/textures/menu/missing_level"
         -- DECOMPILER ERROR: Confused about usage of registers!

         -- DECOMPILER ERROR: Confused about usage of registers!

         -- DECOMPILER ERROR: Confused about usage of registers!

         -- DECOMPILER ERROR: Confused about usage of registers!

         -- DECOMPILER ERROR: Confused about usage of registers!

        l_17_1.level_title, {layer = 1, text = utf8.to_upper(l_17_1.gui_panel:text()), font = l_17_0.font, font_size = l_17_0.font_size, color = l_17_1.color, align = "left"}.h, {layer = 1, text = utf8.to_upper(l_17_1.gui_panel:text()), font = l_17_0.font, font_size = l_17_0.font_size, color = l_17_1.color, align = "left"}.w, {layer = 1, text = utf8.to_upper(l_17_1.gui_panel:text()), font = l_17_0.font, font_size = l_17_0.font_size, color = l_17_1.color, align = "left"}.word_wrap, {layer = 1, text = utf8.to_upper(l_17_1.gui_panel:text()), font = l_17_0.font, font_size = l_17_0.font_size, color = l_17_1.color, align = "left"}.wrap, {layer = 1, text = utf8.to_upper(l_17_1.gui_panel:text()), font = l_17_0.font, font_size = l_17_0.font_size, color = l_17_1.color, align = "left"}.vertical = l_17_1.gui_level_panel:text({layer = 1, text = utf8.to_upper(l_17_1.gui_panel:text()), font = l_17_0.font, font_size = l_17_0.font_size, color = l_17_1.color, align = "left"}), 128, 50, false, false, "top"
         -- DECOMPILER ERROR: Confused about usage of registers!

         -- DECOMPILER ERROR: Confused about usage of registers!

         -- DECOMPILER ERROR: Confused about usage of registers!

         -- DECOMPILER ERROR: Confused about usage of registers!

         -- DECOMPILER ERROR: Confused about usage of registers!

        l_17_1.level_text, {layer = 1, text = utf8.to_upper(description), font = tweak_data.menu.small_font, font_size = tweak_data.menu.small_font_size, color = l_17_1.color, align = "left"}.h, {layer = 1, text = utf8.to_upper(description), font = tweak_data.menu.small_font, font_size = tweak_data.menu.small_font_size, color = l_17_1.color, align = "left"}.w, {layer = 1, text = utf8.to_upper(description), font = tweak_data.menu.small_font, font_size = tweak_data.menu.small_font_size, color = l_17_1.color, align = "left"}.word_wrap, {layer = 1, text = utf8.to_upper(description), font = tweak_data.menu.small_font, font_size = tweak_data.menu.small_font_size, color = l_17_1.color, align = "left"}.wrap, {layer = 1, text = utf8.to_upper(description), font = tweak_data.menu.small_font, font_size = tweak_data.menu.small_font_size, color = l_17_1.color, align = "left"}.vertical = l_17_1.gui_level_panel:text({layer = 1, text = utf8.to_upper(description), font = tweak_data.menu.small_font, font_size = tweak_data.menu.small_font_size, color = l_17_1.color, align = "left"}), 128, 50, true, true, "top"
        l_17_0:_align_normal(l_17_1)
      elseif l_17_1.type == "chat" then
        l_17_1.gui_panel = l_17_0.item_panel:panel({w = l_17_0.item_panel:w(), h = 100})
        l_17_1.chat_output = l_17_1.gui_panel:gui(Idstring("guis/chat/textscroll"), {layer = l_17_0.layers.items, h = 120, w = 500, valign = "grow", halign = "grow"})
        l_17_1.chat_input = l_17_1.gui_panel:gui(Idstring("guis/chat/chat_input"), {h = 25, w = 500, layer = l_17_0.layers.items, valign = "bottom", halign = "grow", y = 125})
        l_17_1.chat_input:script().enter_callback = callback(l_17_0, l_17_0, "_cb_chat", l_17_1)
        l_17_1.chat_input:script().esc_callback = callback(l_17_0, l_17_0, "_cb_unlock", l_17_1)
        l_17_1.chat_input:script().typing_callback = callback(l_17_0, l_17_0, "_cb_lock", l_17_1)
        l_17_1.border = l_17_1.gui_panel:rect({visible = false, layer = l_17_0.layers.items, color = tweak_data.hud.prime_color, w = 800, h = 2})
        l_17_0:_align_chat(l_17_1)
      elseif l_17_1.type == "friend" then
        if (l_17_1.align ~= "right" or not "left") and (l_17_1.align ~= "left" or not "right") then
          local cot_align = l_17_1.align
        end
        l_17_1.gui_panel = l_17_0.item_panel:panel({w = l_17_0.item_panel:w()})
        l_17_1.color_mod = (l_17_1.item:parameters().signin_status == "uninvitable" or l_17_1.item:parameters().signin_status == "not_signed_in") and 0.75 or 1
        l_17_1.friend_name = l_17_0:_text_item_part(l_17_1, l_17_1.gui_panel, l_17_0:_right_align())
        l_17_1.friend_name:set_color(l_17_1.friend_name:color() * l_17_1.color_mod)
        l_17_1.signin_status = l_17_0:_text_item_part(l_17_1, l_17_1.gui_panel, l_17_0:_left_align())
        l_17_1.signin_status:set_align(cot_align)
        l_17_1.signin_status:set_color(l_17_1.signin_status:color() * l_17_1.color_mod)
        local status_text = managers.localization:text("menu_friends_" .. l_17_1.item:parameters().signin_status)
        l_17_1.signin_status:set_text(utf8.to_upper(status_text))
        l_17_0:_align_friend(l_17_1)
      elseif l_17_1.type == "weapon_expand" or l_17_1.type == "weapon_upgrade_expand" then
        l_17_1.item:setup_gui(l_17_0, l_17_1)
      else
        if not l_17_1.item:setup_gui(l_17_0, l_17_1) then
          if (l_17_1.align ~= "right" or not "left") and (l_17_1.align ~= "left" or not "right") then
            local cot_align = l_17_1.align
          end
          l_17_1.gui_panel = l_17_0:_text_item_part(l_17_1, l_17_0.item_panel, l_17_0:_right_align() + (l_17_1.is_expanded and 20 or 0))
          l_17_1.current_of_total = l_17_0:_text_item_part(l_17_1, l_17_0.item_panel, l_17_0:_right_align(), cot_align)
          l_17_1.current_of_total:set_font_size(20)
          l_17_1.current_of_total:set_visible(false)
          if l_17_1.item:parameters().current then
            l_17_1.current_of_total:set_visible(true)
            l_17_1.current_of_total:set_color(l_17_1.color)
            l_17_1.current_of_total:set_text("(" .. l_17_1.item:parameters().current .. "/" .. l_17_1.item:parameters().total .. ")")
          end
          if not l_17_1.help_text or l_17_1.item:parameters().trial_buy then
            l_17_0:_setup_trial_buy(l_17_1)
          end
          if l_17_1.item:parameters().fake_disabled then
            l_17_0:_setup_fake_disabled(l_17_1)
          end
           -- DECOMPILER ERROR: Confused while interpreting a jump as a 'while'

        end
        l_17_1.icon = l_17_0.item_panel:bitmap({texture = l_17_1.item:parameters().icon, rotation = not l_17_1.item:parameters().icon or 360, visible = l_17_1.item:icon_visible(), layer = l_17_0.layers.items + 1})
        l_17_0:_align_normal(l_17_1)
      end
    end
  end
end
if l_17_1.item:menu_unselected_visible(l_17_0, l_17_1) then
  local visible = not l_17_1.item:parameters().back
end
l_17_1.menu_unselected = l_17_0.item_panel:bitmap({visible = false, texture = "guis/textures/menu_unselected", x = 0, y = 0, layer = l_17_0.layers.items - 2})
if not l_17_1.item:parameters().is_expanded or not Color(0.5, 0.5, 0.5) then
  l_17_1.menu_unselected:set_color(Color.white)
end
end

MenuNodeGui._setup_trial_buy = function(l_18_0, l_18_1)
  local font_size = SystemInfo:language() == Idstring("italian") and 25 or 28
  l_18_1.row_item_color = Color(1, 1, 0.65882354974747, 0)
  l_18_1.font_size = font_size * tweak_data.scale.default_font_multiplier
  l_18_1.gui_panel:set_color(l_18_1.row_item_color)
  l_18_1.gui_panel:set_font_size(l_18_1.font_size)
end

MenuNodeGui._setup_fake_disabled = function(l_19_0, l_19_1)
  l_19_1.row_item_color = tweak_data.menu.default_disabled_text_color
  l_19_1.gui_panel:set_color(l_19_1.row_item_color)
end

MenuNodeGui._create_info_panel = function(l_20_0, l_20_1)
  l_20_1.gui_info_panel = l_20_0.safe_rect_panel:panel({visible = false, layer = l_20_0.layers.first, x = 0, y = 0, w = l_20_0:_left_align(), h = l_20_0._item_panel_parent:h()})
   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

  l_20_1.help_title, {x = 0, y = 0, align = "left", halign = "top"}.text, {x = 0, y = 0, align = "left", halign = "top"}.layer, {x = 0, y = 0, align = "left", halign = "top"}.color, {x = 0, y = 0, align = "left", halign = "top"}.font, {x = 0, y = 0, align = "left", halign = "top"}.font_size, {x = 0, y = 0, align = "left", halign = "top"}.vertical = l_20_1.gui_info_panel:text({x = 0, y = 0, align = "left", halign = "top"}), utf8.to_upper(l_20_1.text), l_20_0.layers.items, Color.white, l_20_1.font, l_20_0.font_size, "top"
   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

  l_20_1.help_text, {x = 0, y = 0, align = "left", halign = "top", vertical = "top", font = tweak_data.menu.pd2_small_font, font_size = tweak_data.menu.pd2_small_font_size, color = Color.white}.word_wrap, {x = 0, y = 0, align = "left", halign = "top", vertical = "top", font = tweak_data.menu.pd2_small_font, font_size = tweak_data.menu.pd2_small_font_size, color = Color.white}.wrap, {x = 0, y = 0, align = "left", halign = "top", vertical = "top", font = tweak_data.menu.pd2_small_font, font_size = tweak_data.menu.pd2_small_font_size, color = Color.white}.text, {x = 0, y = 0, align = "left", halign = "top", vertical = "top", font = tweak_data.menu.pd2_small_font, font_size = tweak_data.menu.pd2_small_font_size, color = Color.white}.layer = l_20_1.gui_info_panel:text({x = 0, y = 0, align = "left", halign = "top", vertical = "top", font = tweak_data.menu.pd2_small_font, font_size = tweak_data.menu.pd2_small_font_size, color = Color.white}), true, true, utf8.to_upper(l_20_1.help_text), l_20_0.layers.items
end

MenuNodeGui._set_lobby_campaign = function(l_21_0, l_21_1)
  if not MenuNodeGui.lobby_campaign then
    l_21_0:_create_lobby_campaign(l_21_1)
  else
    l_21_1.level_id = MenuNodeGui.lobby_campaign.level_id
    l_21_1.gui_info_panel = MenuNodeGui.lobby_campaign.gui_info_panel
    l_21_1.level_title = MenuNodeGui.lobby_campaign.level_title
    l_21_1.level_briefing = MenuNodeGui.lobby_campaign.level_briefing
  end
end

MenuNodeGui._create_lobby_campaign = function(l_22_0, l_22_1)
  l_22_1.gui_info_panel = l_22_0.safe_rect_panel:panel({visible = false, layer = l_22_0.layers.items, x = 0, y = 0, w = l_22_0:_left_align(), h = l_22_0._item_panel_parent:h()})
  l_22_1.level_id = Global.game_settings.level_id
   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

  l_22_1.level_title, {x = 0, y = 0, align = "left", halign = "top"}.text, {x = 0, y = 0, align = "left", halign = "top"}.layer, {x = 0, y = 0, align = "left", halign = "top"}.color, {x = 0, y = 0, align = "left", halign = "top"}.font, {x = 0, y = 0, align = "left", halign = "top"}.font_size, {x = 0, y = 0, align = "left", halign = "top"}.vertical = l_22_1.gui_info_panel:text({x = 0, y = 0, align = "left", halign = "top"}), string.upper(managers.localization:text(tweak_data.levels[l_22_1.level_id].name_id)), l_22_0.layers.items, Color.white, l_22_1.font, l_22_0.font_size, "top"
  local briefing_text = string.upper(managers.localization:text(tweak_data.levels[l_22_1.level_id].briefing_id))
   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

  l_22_1.level_briefing, {x = 0, y = 0, align = "left", halign = "top", vertical = "top", font = tweak_data.menu.pd2_small_font, font_size = tweak_data.menu.pd2_small_font_size, color = Color.white}.word_wrap, {x = 0, y = 0, align = "left", halign = "top", vertical = "top", font = tweak_data.menu.pd2_small_font, font_size = tweak_data.menu.pd2_small_font_size, color = Color.white}.wrap, {x = 0, y = 0, align = "left", halign = "top", vertical = "top", font = tweak_data.menu.pd2_small_font, font_size = tweak_data.menu.pd2_small_font_size, color = Color.white}.text, {x = 0, y = 0, align = "left", halign = "top", vertical = "top", font = tweak_data.menu.pd2_small_font, font_size = tweak_data.menu.pd2_small_font_size, color = Color.white}.layer = l_22_1.gui_info_panel:text({x = 0, y = 0, align = "left", halign = "top", vertical = "top", font = tweak_data.menu.pd2_small_font, font_size = tweak_data.menu.pd2_small_font_size, color = Color.white}), true, true, briefing_text, l_22_0.layers.items
  MenuNodeGui.lobby_campaign = {level_id = Global.game_settings.level_id, gui_info_panel = l_22_1.gui_info_panel, level_movie = l_22_1.level_movie, level_title = l_22_1.level_title, level_briefing = l_22_1.level_briefing}
end

MenuNodeGui._align_lobby_campaign = function(l_23_0, l_23_1)
  l_23_0:_align_item_gui_info_panel(l_23_1.gui_info_panel)
  local w = l_23_1.gui_info_panel:w()
  local _, _, _, h = l_23_1.level_title:text_rect()
  l_23_1.level_title:set_size(w, h)
  l_23_1.level_title:set_position(0, (l_23_1.level_movie and l_23_1.level_movie:bottom() or 0) + tweak_data.menu.info_padding)
  l_23_1.level_briefing:set_w(w)
  l_23_1.level_briefing:set_shape(l_23_1.level_briefing:text_rect())
  l_23_1.level_briefing:set_x(0)
  l_23_1.level_briefing:set_top(l_23_1.level_title:bottom() + tweak_data.menu.info_padding)
end

MenuNodeGui._highlight_lobby_campaign = function(l_24_0, l_24_1)
  if l_24_1.level_id ~= Global.game_settings.level_id then
    l_24_0:_reload_lobby_campaign(l_24_1)
  end
  l_24_1.gui_info_panel:set_visible(true)
end

MenuNodeGui._fade_lobby_campaign = function(l_25_0, l_25_1)
  l_25_1.gui_info_panel:set_visible(false)
end

MenuNodeGui._reload_lobby_campaign = function(l_26_0, l_26_1)
  if MenuNodeGui.lobby_campaign.level_id == Global.game_settings.level_id then
    return 
  end
  if l_26_1.level_id ~= MenuNodeGui.lobby_campaign.level_id then
    l_26_1.level_id = MenuNodeGui.lobby_campaign.level_id
    l_26_1.gui_info_panel = MenuNodeGui.lobby_campaign.gui_info_panel
    l_26_1.level_title = MenuNodeGui.lobby_campaign.level_title
    l_26_1.level_briefing = MenuNodeGui.lobby_campaign.level_briefing
    return 
  end
  l_26_1.level_id = Global.game_settings.level_id
  local text = string.upper(managers.localization:text(tweak_data.levels[l_26_1.level_id].name_id))
  l_26_1.level_title:set_text(text)
  local briefing_text = string.upper(managers.localization:text(tweak_data.levels[l_26_1.level_id].briefing_id))
  l_26_1.level_briefing:set_text(briefing_text)
  local _, _, _, h = l_26_1.level_briefing:text_rect()
  l_26_1.level_briefing:set_h(h)
  MenuNodeGui.lobby_campaign = {level_id = Global.game_settings.level_id, gui_info_panel = l_26_1.gui_info_panel, level_movie = l_26_1.level_movie, level_title = l_26_1.level_title, level_briefing = l_26_1.level_briefing}
end

MenuNodeGui._create_lobby_difficulty = function(l_27_0, l_27_1)
  l_27_1.gui_info_panel = l_27_0.safe_rect_panel:panel({visible = false, layer = l_27_0.layers.items, x = 0, y = 0, w = l_27_0:_left_align(), h = l_27_0._item_panel_parent:h()})
   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

  l_27_1.difficulty_title, {x = 0, y = 0, align = "left", halign = "top"}.text, {x = 0, y = 0, align = "left", halign = "top"}.layer, {x = 0, y = 0, align = "left", halign = "top"}.color, {x = 0, y = 0, align = "left", halign = "top"}.font, {x = 0, y = 0, align = "left", halign = "top"}.font_size, {x = 0, y = 0, align = "left", halign = "top"}.vertical = l_27_1.gui_info_panel:text({x = 0, y = 0, align = "left", halign = "top"}), utf8.to_upper(l_27_1.text), l_27_0.layers.items, Color.white, l_27_1.font, l_27_0.font_size, "top"
   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

  l_27_1.help_text, {x = 0, y = 0, align = "left", halign = "top", vertical = "top", font = tweak_data.menu.pd2_small_font, font_size = tweak_data.menu.pd2_small_font_size, color = Color.white}.word_wrap, {x = 0, y = 0, align = "left", halign = "top", vertical = "top", font = tweak_data.menu.pd2_small_font, font_size = tweak_data.menu.pd2_small_font_size, color = Color.white}.wrap, {x = 0, y = 0, align = "left", halign = "top", vertical = "top", font = tweak_data.menu.pd2_small_font, font_size = tweak_data.menu.pd2_small_font_size, color = Color.white}.text, {x = 0, y = 0, align = "left", halign = "top", vertical = "top", font = tweak_data.menu.pd2_small_font, font_size = tweak_data.menu.pd2_small_font_size, color = Color.white}.layer = l_27_1.gui_info_panel:text({x = 0, y = 0, align = "left", halign = "top", vertical = "top", font = tweak_data.menu.pd2_small_font, font_size = tweak_data.menu.pd2_small_font_size, color = Color.white}), true, true, utf8.to_upper(managers.localization:text("menu_difficulty_help")), l_27_0.layers.items
   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

  l_27_1.difficulty_help_text, {x = 0, y = 0, align = "left", halign = "top", vertical = "top", font = tweak_data.menu.small_font, font_size = tweak_data.menu.small_font_size, color = Color.white}.word_wrap, {x = 0, y = 0, align = "left", halign = "top", vertical = "top", font = tweak_data.menu.small_font, font_size = tweak_data.menu.small_font_size, color = Color.white}.wrap, {x = 0, y = 0, align = "left", halign = "top", vertical = "top", font = tweak_data.menu.small_font, font_size = tweak_data.menu.small_font_size, color = Color.white}.text, {x = 0, y = 0, align = "left", halign = "top", vertical = "top", font = tweak_data.menu.small_font, font_size = tweak_data.menu.small_font_size, color = Color.white}.layer = l_27_1.gui_info_panel:text({x = 0, y = 0, align = "left", halign = "top", vertical = "top", font = tweak_data.menu.small_font, font_size = tweak_data.menu.small_font_size, color = Color.white}), true, true, ut8f.to_upper("sdsd"), l_27_0.layers.items
end

MenuNodeGui._align_lobby_difficulty = function(l_28_0, l_28_1)
  local w = l_28_1.gui_info_panel:w()
  l_28_1.difficulty_title:set_shape(l_28_1.difficulty_title:text_rect())
  l_28_1.difficulty_title:set_position(0, 0)
  l_28_1.help_text:set_w(w)
  l_28_1.help_text:set_shape(l_28_1.help_text:text_rect())
  l_28_1.help_text:set_x(0)
  l_28_1.help_text:set_top(l_28_1.difficulty_title:bottom() + tweak_data.menu.info_padding)
  l_28_0:_align_lobby_difficulty_help_text(l_28_1)
end

MenuNodeGui._align_lobby_difficulty_help_text = function(l_29_0, l_29_1)
  local w = l_29_1.gui_info_panel:w()
  l_29_1.difficulty_help_text:set_w(w)
  local _, _, tw, th = l_29_1.difficulty_help_text:text_rect()
  l_29_1.difficulty_help_text:set_h(th)
  l_29_1.difficulty_help_text:set_x(0)
  l_29_1.difficulty_help_text:set_top(l_29_1.help_text:bottom() + tweak_data.menu.info_padding * 2)
end

MenuNodeGui._highlight_lobby_difficulty = function(l_30_0, l_30_1)
  l_30_1.gui_info_panel:set_visible(true)
end

MenuNodeGui._fade_lobby_difficulty = function(l_31_0, l_31_1)
  l_31_1.gui_info_panel:set_visible(false)
end

MenuNodeGui._reload_lobby_difficulty = function(l_32_0, l_32_1)
  l_32_1.difficulty_help_text:set_text(utf8.to_upper(managers.localization:text("menu_difficulty_" .. Global.game_settings.difficulty .. "_help")))
  l_32_0:_align_lobby_difficulty_help_text(l_32_1)
end

MenuNodeGui._align_friend = function(l_33_0, l_33_1)
  local safe_rect = l_33_0:_scaled_size()
  l_33_1.friend_name:set_font_size(l_33_0.font_size)
  local x, y, w, h = l_33_1.friend_name:text_rect()
  l_33_1.friend_name:set_height(h)
  l_33_1.friend_name:set_right(l_33_1.friend_name:parent():w())
  l_33_1.gui_panel:set_height(h)
  if l_33_1.icon then
    l_33_1.icon:set_left(l_33_1.gui_panel:right())
    l_33_1.icon:set_center_y(l_33_1.gui_panel:center_y())
    l_33_1.icon:set_color(l_33_1.gui_panel:color())
  end
  l_33_1.signin_status:set_font_size(l_33_0.font_size)
  l_33_1.signin_status:set_height(h)
  if l_33_1.align == "right" then
    l_33_1.signin_status:set_left(l_33_0:_right_align() - l_33_1.gui_panel:x() - 100)
  elseif l_33_1.align == "left" then
    l_33_1.signin_status:set_right(l_33_0:_left_align())
  else
    l_33_1.signin_status:set_right(l_33_0:_left_align())
  end
end

MenuNodeGui.activate_customize_controller = function(l_34_0, l_34_1)
  local row_item = l_34_0:row_item(l_34_1)
  l_34_0.ws:connect_keyboard(Input:keyboard())
  l_34_0.ws:connect_mouse(Input:mouse())
  l_34_0._listening_to_input = true
  l_34_0._skip_first_mouse_0 = true
  local f = function(l_1_0, l_1_1)
    self:_key_press(l_1_0, l_1_1, "keyboard", item)
   end
  row_item.controller_binding:set_text("_")
  row_item.controller_binding:key_press(f)
  local f = function(l_2_0, l_2_1)
    self:_key_press(l_2_0, l_2_1, "mouse", item)
   end
  row_item.controller_binding:mouse_click(f)
  local f = function(l_3_0, l_3_1)
    self:_key_press(row_item.controller_binding, l_3_1, "mouse", item, true)
   end
  l_34_0._mouse_wheel_up_trigger = Input:mouse():add_trigger(Input:mouse():button_index(Idstring("mouse wheel up")), f)
  l_34_0._mouse_wheel_down_trigger = Input:mouse():add_trigger(Input:mouse():button_index(Idstring("mouse wheel down")), f)
end

MenuNodeGui._key_press = function(l_35_0, l_35_1, l_35_2, l_35_3, l_35_4, l_35_5)
  if managers.system_menu:is_active() then
    return 
  end
  if l_35_0._skip_first_mouse_0 then
    l_35_0._skip_first_mouse_0 = false
    if l_35_3 == "mouse" and l_35_2 == Idstring("0") then
      return 
    end
  end
  local row_item = l_35_0:row_item(l_35_4)
  if l_35_2 == Idstring("esc") then
    l_35_0:_end_customize_controller(l_35_1, l_35_4)
    return 
  end
  if l_35_3 ~= "mouse" or not Input:mouse():button_name_str(l_35_2) then
    local key_name = "" .. Input:keyboard():button_name_str(l_35_2)
  end
   -- DECOMPILER ERROR: Confused while interpreting a jump as a 'while'

end
local forbidden_btns = {"esc", "tab", "num abnt c1", "num abnt c2", "@", "ax", "convert", "kana", "kanji", "no convert", "oem 102", "stop", "unlabeled", "yen", "mouse 8", "mouse 9", ""}
for _,btn in ipairs(forbidden_btns) do
  if Idstring(btn) == l_35_2 then
    managers.menu:show_key_binding_forbidden({KEY = key_name})
    l_35_0:_end_customize_controller(l_35_1, l_35_4)
    return 
  end
end
local connections = managers.controller:get_settings(managers.controller:get_default_wrapper_type()):get_connection_map()
for _,name in ipairs(MenuCustomizeControllerCreator.CONTROLS) do
  local connection = connections[name]
  if connection._btn_connections then
    for name,btn_connection in pairs(connection._btn_connections) do
      if btn_connection.name == key_name and l_35_4:parameters().binding ~= btn_connection.name then
        managers.menu:show_key_binding_collision({KEY = key_name, MAPPED = managers.localization:text(MenuCustomizeControllerCreator.CONTROLS_INFO[name].text_id)})
        l_35_0:_end_customize_controller(l_35_1, l_35_4)
        return 
      end
    end
    for (for control),_ in (for generator) do
    end
    for _,b_name in ipairs(connection:get_input_name_list()) do
      if tostring(b_name) == key_name and l_35_4:parameters().binding ~= b_name then
        managers.menu:show_key_binding_collision({KEY = key_name, MAPPED = managers.localization:text(MenuCustomizeControllerCreator.CONTROLS_INFO[name].text_id)})
        l_35_0:_end_customize_controller(l_35_1, l_35_4)
        return 
      end
    end
  end
  if l_35_4:parameters().axis then
    connections[l_35_4:parameters().axis]._btn_connections[l_35_4:parameters().button].name = key_name
    managers.controller:set_user_mod(l_35_4:parameters().connection_name, {axis = l_35_4:parameters().axis, button = l_35_4:parameters().button, connection = key_name})
    l_35_4:parameters().binding = key_name
  else
    connections[l_35_4:parameters().button]:set_controller_id(l_35_3)
    connections[l_35_4:parameters().button]:set_input_name_list({key_name})
    managers.controller:set_user_mod(l_35_4:parameters().connection_name, {button = l_35_4:parameters().button, connection = key_name, controller_id = l_35_3})
    l_35_4:parameters().binding = key_name
  end
  managers.controller:rebind_connections()
  l_35_0:_end_customize_controller(l_35_1, l_35_4)
end

MenuNodeGui._end_customize_controller = function(l_36_0, l_36_1, l_36_2)
  l_36_0.ws:disconnect_keyboard()
  l_36_0.ws:disconnect_mouse()
  l_36_1:key_press(nil)
  l_36_1:mouse_click(nil)
  l_36_1:mouse_release(nil)
  Input:mouse():remove_trigger(l_36_0._mouse_wheel_up_trigger)
  Input:mouse():remove_trigger(l_36_0._mouse_wheel_down_trigger)
  setup:add_end_frame_clbk(function()
    self._listening_to_input = false
   end)
  l_36_2:dirty()
end

MenuNodeGui._cb_chat = function(l_37_0, l_37_1)
  local chat_text = l_37_1.chat_input:child("text"):text()
  if chat_text and tostring(chat_text) ~= "" then
    local name = managers.network:session():local_peer():name()
    local say = name .. ": " .. tostring(chat_text)
    l_37_0:_say(say, l_37_1, managers.network:session():local_peer():id())
    managers.network:session():send_to_peers("sync_chat_message", say)
  end
  l_37_0._chatbox_typing = false
  l_37_1.chat_input:child("text"):set_text("")
  l_37_1.chat_input:child("text"):set_selection(0, 0)
end

MenuNodeGui.sync_say = function(l_38_0, l_38_1, l_38_2, l_38_3)
  l_38_0:_say(l_38_1, l_38_2, l_38_3)
end

MenuNodeGui._say = function(l_39_0, l_39_1, l_39_2, l_39_3)
  if managers.menu:active_menu() then
    managers.menu:active_menu().renderer:post_event("prompt_exit")
  end
  local s = l_39_2.chat_output:script()
  local i = utf8.find_char(l_39_1, ":")
  s.box_print(l_39_1, tweak_data.chat_colors[l_39_3], i)
end

MenuNodeGui._cb_unlock = function(l_40_0)
end

MenuNodeGui._cb_lock = function(l_41_0)
end

MenuNodeGui._text_item_part = function(l_42_0, l_42_1, l_42_2, l_42_3, l_42_4)
   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused while interpreting a jump as a 'while'

end
return l_42_2:text({font_size = l_42_0.font_size, x = l_42_3, y = 0, align = l_42_4 or l_42_1.align or "left", halign = "left", vertical = "center", font = l_42_1.font, color = l_42_1.color})
{font_size = l_42_0.font_size, x = l_42_3, y = 0, align = l_42_4 or l_42_1.align or "left", halign = "left", vertical = "center", font = l_42_1.font, color = l_42_1.color}.render_template, {font_size = l_42_0.font_size, x = l_42_3, y = 0, align = l_42_4 or l_42_1.align or "left", halign = "left", vertical = "center", font = l_42_1.font, color = l_42_1.color}.text, {font_size = l_42_0.font_size, x = l_42_3, y = 0, align = l_42_4 or l_42_1.align or "left", halign = "left", vertical = "center", font = l_42_1.font, color = l_42_1.color}.blend_mode, {font_size = l_42_0.font_size, x = l_42_3, y = 0, align = l_42_4 or l_42_1.align or "left", halign = "left", vertical = "center", font = l_42_1.font, color = l_42_1.color}.layer = Idstring("VertexColorTextured"), l_42_1.text, l_42_0.row_item_blend_mode or "normal", l_42_0.layers.items
end

MenuNodeGui.scroll_update = function(l_43_0, l_43_1)
  local scrolled = MenuNodeGui.super.scroll_update(l_43_0, l_43_1)
  if math.round(l_43_0.item_panel:world_y()) - math.round(l_43_0._item_panel_parent:world_y()) < 0 then
    l_43_0._list_arrows.up:set_color(l_43_0._list_arrows.up:color():with_alpha(1))
  else
    l_43_0._list_arrows.up:set_color(l_43_0._list_arrows.up:color():with_alpha(0))
  end
  if math.round(l_43_0.item_panel:world_bottom()) - l_43_0._item_panel_parent:world_bottom() < 4 then
    l_43_0._list_arrows.down:set_color(l_43_0._list_arrows.down:color():with_alpha(0))
  else
    l_43_0._list_arrows.down:set_color(l_43_0._list_arrows.down:color():with_alpha(1))
  end
  return scrolled
end

MenuNodeGui.reload_item = function(l_44_0, l_44_1)
  local type = l_44_1:type()
  if not l_44_1:reload(l_44_0:row_item(l_44_1), l_44_0) then
    if type == "weapon_expand" or type == "weapon_upgrade_expand" then
      l_44_0:_reload_expand(l_44_1)
    elseif type == "expand" then
      l_44_0:_reload_expand(l_44_1)
    elseif type == "friend" then
      l_44_0:_reload_friend(l_44_1)
    else
      MenuNodeGui.super.reload_item(l_44_0, l_44_1)
    end
  end
  if l_44_0._highlighted_item and l_44_0._highlighted_item == l_44_1 then
    local row_item = l_44_0:row_item(l_44_1)
    if row_item then
      l_44_0:_align_marker(row_item)
    end
  end
end

MenuNodeGui._collaps_others = function(l_45_0, l_45_1)
  for _,row_item in ipairs(l_45_0.row_items) do
    local item = row_item.item
    local type = item:type()
    if l_45_1 ~= item and (type == "expand" or type == "weapon_expand" or type == "weapon_upgrade_expand") and not item:is_parent_to_item(l_45_1) and item:expanded() then
      item:toggle()
      l_45_0:_reload_expand(item)
    end
  end
end

MenuNodeGui._reload_expand = function(l_46_0, l_46_1)
  local row_item = l_46_0:row_item(l_46_1)
  l_46_1:reload(row_item, l_46_0)
  if l_46_1:expanded() then
    l_46_0:_collaps_others(l_46_1)
  end
  local need_repos = false
  if l_46_1:can_expand() then
    if l_46_1:expanded() then
      need_repos = l_46_1:expand(l_46_0, row_item)
    else
      need_repos = l_46_1:collaps(l_46_0, row_item)
    end
  end
  if need_repos then
    l_46_0:need_repositioning()
    row_item.node:select_item(l_46_1:name())
    l_46_0:_reposition_items(row_item)
  end
end

MenuNodeGui._delete_row_item = function(l_47_0, l_47_1)
  for i,row_item in ipairs(l_47_0.row_items) do
    if row_item.item == l_47_1 and alive(row_item.gui_pd2_panel) then
      row_item.gui_pd2_panel:parent():remove(row_item.gui_pd2_panel)
      do return end
    end
  end
  MenuNodeGui.super._delete_row_item(l_47_0, l_47_1)
end

MenuNodeGui._clear_gui = function(l_48_0)
  for i,row_item in ipairs(l_48_0.row_items) do
    if alive(row_item.gui_pd2_panel) then
      row_item.gui_pd2_panel:parent():remove(row_item.gui_pd2_panel)
    end
  end
  MenuNodeGui.super._clear_gui(l_48_0)
end

MenuNodeGui.need_repositioning = function(l_49_0)
  l_49_0:_setup_size()
  l_49_0:scroll_setup()
  l_49_0:_set_item_positions()
end

MenuNodeGui.update_item_icon_visibility = function(l_50_0)
  for _,row_item in pairs(l_50_0.row_items) do
    if alive(row_item.icon) then
      row_item.icon:set_visible(row_item.item:icon_visible())
    end
  end
end

MenuNodeGui._reload_friend = function(l_51_0, l_51_1)
  local row_item = l_51_0:row_item(l_51_1)
  local status_text = managers.localization:text("menu_friends_" .. row_item.item:parameters().signin_status)
  row_item.signin_status:set_text(utf8.to_upper(status_text))
end

MenuNodeGui._setup_item_size = function(l_52_0, l_52_1)
  local type = l_52_1.item:type()
  if type == "level" then
    l_52_0:_setup_level_size(l_52_1)
  end
end

MenuNodeGui._setup_level_size = function(l_53_0, l_53_1)
  local padding = 24
  l_53_1.gui_level_panel:set_shape(0, 0, l_53_0:_left_align(), l_53_0._item_panel_parent:h())
  local w = l_53_1.gui_level_panel:w() - padding * 2
  l_53_1.level_title:set_shape(padding, 24, w, l_53_1.gui_level_panel:w())
  l_53_1.level_text:set_shape(padding, 66, w, l_53_1.gui_level_panel:w())
end

MenuNodeGui._highlight_row_item = function(l_54_0, l_54_1, l_54_2)
  if l_54_1 then
    l_54_1.highlighted = true
    local active_menu = managers.menu:active_menu()
    if active_menu then
      active_menu.renderer:set_bottom_text(l_54_1.item:parameters().help_id)
    end
    l_54_0:_align_marker(l_54_1)
    l_54_1.color = l_54_0.row_item_hightlight_color
    if l_54_1.type == "NOTHING" then
      do return end
    end
    if l_54_1.type == "column" then
      for _,gui in ipairs(l_54_1.gui_columns) do
        gui:set_color(l_54_1.color)
        gui:set_font(tweak_data.menu.pd2_medium_font_id)
      end
    elseif l_54_1.type == "server_column" then
      for _,gui in ipairs(l_54_1.gui_columns) do
        gui:set_color(l_54_1.color)
        gui:set_font(tweak_data.menu.pd2_medium_font_id)
      end
      l_54_1.gui_info_panel:set_visible(true)
    elseif l_54_1.type == "level" then
      l_54_1.gui_level_panel:set_visible(true)
      MenuNodeGui.super._highlight_row_item(l_54_0, l_54_1)
    elseif l_54_1.type == "friend" then
      l_54_1.friend_name:set_color(l_54_1.color * l_54_1.color_mod)
      if not l_54_1.font or not Idstring(l_54_1.font) then
        l_54_1.friend_name:set_font(tweak_data.menu.default_font_no_outline_id)
      end
      l_54_1.signin_status:set_color(l_54_1.color * l_54_1.color_mod)
      if not l_54_1.font or not Idstring(l_54_1.font) then
        l_54_1.signin_status:set_font(tweak_data.menu.default_font_no_outline_id)
    else
      end
      if l_54_1.type == "chat" then
        l_54_0.ws:connect_keyboard(Input:keyboard())
        l_54_1.border:set_visible(true)
        if not l_54_2 then
          l_54_1.chat_input:script().set_focus(true)
        elseif l_54_1.type == "weapon_expand" or l_54_1.type == "weapon_upgrade_expand" then
          l_54_1.item:highlight_row_item(l_54_0, l_54_1, l_54_2)
        else
          if l_54_1.item:parameters().back then
            l_54_1.arrow_selected:set_visible(true)
            l_54_1.arrow_unselected:set_visible(false)
          else
            if l_54_1.item:parameters().pd2_corner then
              l_54_1.gui_text:set_color(tweak_data.screen_colors.button_stage_2)
            else
              if not l_54_1.item:highlight_row_item(l_54_0, l_54_1, l_54_2) then
                if l_54_1.gui_panel.set_text and (not l_54_1.font or not Idstring(l_54_1.font)) then
                  l_54_1.gui_panel:set_font(tweak_data.menu.pd2_medium_font_id)
                end
                if l_54_1.gui_info_panel then
                  l_54_1.gui_info_panel:set_visible(true)
                end
                MenuNodeGui.super._highlight_row_item(l_54_0, l_54_1)
                if l_54_1.icon then
                  l_54_1.icon:set_left(l_54_1.gui_panel:right())
                  l_54_1.icon:set_center_y(l_54_1.gui_panel:center_y())
                  l_54_1.icon:set_color(l_54_1.gui_panel:color())
                end
              end
            end
          end
        end
      end
    end
    local active_menu = managers.menu:active_menu()
    if active_menu then
      if l_54_1.item:parameters().stencil_image then
        active_menu.renderer:set_stencil_image(l_54_1.item:parameters().stencil_image)
      else
        active_menu.renderer:set_stencil_image(l_54_0._stencil_image)
      end
    end
  end
end

MenuNodeGui._align_marker = function(l_55_0, l_55_1)
  if l_55_1.item:parameters().pd2_corner then
    l_55_0._marker_data.marker:set_visible(true)
    l_55_0._marker_data.gradient:set_visible(true)
    l_55_0._marker_data.gradient:set_rotation(360)
    l_55_0._marker_data.marker:set_height(64 * l_55_1.gui_text:height() / 32)
    l_55_0._marker_data.gradient:set_height(64 * l_55_1.gui_text:height() / 32)
    l_55_0._marker_data.marker:set_w(l_55_0:_scaled_size().width - l_55_1.menu_unselected:x())
    l_55_0._marker_data.gradient:set_w(l_55_0._marker_data.marker:w())
    l_55_0._marker_data.marker:set_world_right(l_55_1.gui_text:world_right())
    l_55_0._marker_data.marker:set_world_center_y(l_55_1.gui_text:world_center_y() - 2)
    return 
  end
  l_55_0._marker_data.marker:show()
  l_55_0._marker_data.gradient:set_rotation(0)
  l_55_0._marker_data.marker:set_height(64 * l_55_1.gui_panel:height() / 32)
  l_55_0._marker_data.gradient:set_height(64 * l_55_1.gui_panel:height() / 32)
  l_55_0._marker_data.marker:set_left(l_55_1.menu_unselected:x())
  l_55_0._marker_data.marker:set_center_y(l_55_1.gui_panel:center_y() - 2)
  local item_enabled = l_55_1.item:enabled()
  if not item_enabled or l_55_1.item:parameters().back then
    l_55_0._marker_data.marker:set_visible(false)
  else
    l_55_0._marker_data.marker:set_visible(true)
    if l_55_0._marker_data.back_marker then
      l_55_0._marker_data.back_marker:set_visible(false)
    end
  end
  if l_55_1.type == "upgrade" then
    l_55_0._marker_data.marker:set_left(l_55_0:_mid_align())
  elseif l_55_1.type == "friend" then
    if l_55_1.align == "right" then
      l_55_0._marker_data.marker:move(-100, 0)
    else
      local _, _, w, _ = l_55_1.signin_status:text_rect()
      l_55_0._marker_data.marker:set_left(l_55_0:_left_align() - w - l_55_0._align_line_padding)
    end
  elseif l_55_1.type == "server_column" then
    l_55_0._marker_data.marker:set_left(l_55_1.gui_panel:x())
  elseif l_55_1.type == "customize_controller" then
    do return end
  end
  if l_55_1.type == "nothing" then
    if l_55_1.type == "slider" then
      l_55_0._marker_data.marker:set_left(l_55_0:_left_align() - l_55_1.gui_slider:width())
    elseif (l_55_1.type == "kitslot" or l_55_1.type == "multi_choice") and l_55_1.choice_panel then
      l_55_0._marker_data.marker:set_left(l_55_1.arrow_left:left() - l_55_0._align_line_padding + l_55_1.gui_panel:x())
      do return end
      if l_55_1.type == "toggle" then
        if l_55_1.gui_option then
          local x, y, w, h = l_55_1.gui_option:text_rect()
          l_55_0._marker_data.marker:set_left(l_55_0:_left_align() - w - l_55_0._align_line_padding + l_55_1.gui_panel:x())
        else
          l_55_0._marker_data.marker:set_left(l_55_1.gui_icon:x() - l_55_0._align_line_padding + l_55_1.gui_panel:x())
        end
    end
  end
end
l_55_0._marker_data.marker:set_w(l_55_0:_scaled_size().width - l_55_0._marker_data.marker:left())
l_55_0._marker_data.gradient:set_w(l_55_0._marker_data.marker:w())
l_55_0._marker_data.gradient:set_visible(true)
if l_55_1.type == "chat" then
  l_55_0._marker_data.gradient:set_visible(false)
end
end

MenuNodeGui._fade_row_item = function(l_56_0, l_56_1)
  if l_56_1 then
    l_56_1.highlighted = false
    if not l_56_1.item:enabled() or not l_56_0.row_item_color then
      l_56_1.color = tweak_data.menu.default_disabled_text_color
    end
    if l_56_1.type == "NOTHING" then
      do return end
    end
    if l_56_1.type == "column" then
      for _,gui in ipairs(l_56_1.gui_columns) do
        gui:set_color(l_56_1.color)
        gui:set_font(tweak_data.menu.pd2_medium_font_id)
      end
    elseif l_56_1.type == "server_column" then
      for _,gui in ipairs(l_56_1.gui_columns) do
        gui:set_color(l_56_1.color)
        gui:set_font(tweak_data.menu.pd2_medium_font_id)
      end
      l_56_1.gui_info_panel:set_visible(false)
    elseif l_56_1.type == "level" then
      l_56_1.gui_level_panel:set_visible(false)
      MenuNodeGui.super._fade_row_item(l_56_0, l_56_1)
    elseif l_56_1.type == "friend" then
      l_56_1.friend_name:set_color(l_56_1.color * l_56_1.color_mod)
      if not l_56_1.font or not Idstring(l_56_1.font) then
        l_56_1.friend_name:set_font(tweak_data.menu.pd2_medium_font_id)
      end
      l_56_1.signin_status:set_color(l_56_1.color * l_56_1.color_mod)
      if not l_56_1.font or not Idstring(l_56_1.font) then
        l_56_1.signin_status:set_font(tweak_data.menu.pd2_medium_font_id)
    else
      end
      if l_56_1.type == "chat" then
        l_56_1.border:set_visible(false)
        l_56_1.chat_input:script().set_focus(false)
        l_56_0.ws:disconnect_keyboard()
      elseif l_56_1.type == "weapon_expand" or l_56_1.type == "weapon_upgrade_expand" then
        l_56_1.item:fade_row_item(l_56_0, l_56_1)
      else
        if l_56_1.item:parameters().back then
          l_56_1.arrow_selected:set_visible(false)
          l_56_1.arrow_unselected:set_visible(true)
        else
          if l_56_1.item:parameters().pd2_corner then
            l_56_1.gui_text:set_color(tweak_data.screen_colors.button_stage_3)
          else
            if not l_56_1.item:fade_row_item(l_56_0, l_56_1) then
              if l_56_1.gui_panel.set_text and (not l_56_1.font or not Idstring(l_56_1.font)) then
                l_56_1.gui_panel:set_font(tweak_data.menu.pd2_medium_font_id)
              end
              if l_56_1.gui_info_panel then
                l_56_1.gui_info_panel:set_visible(false)
              end
              MenuNodeGui.super._fade_row_item(l_56_0, l_56_1)
              if l_56_1.icon then
                l_56_1.icon:set_left(l_56_1.gui_panel:right())
                l_56_1.icon:set_center_y(l_56_1.gui_panel:center_y())
                l_56_1.icon:set_color(l_56_1.gui_panel:color())
              end
            end
          end
        end
      end
    end
  end
end

MenuNodeGui._align_item_gui_info_panel = function(l_57_0, l_57_1)
  l_57_1:set_shape(l_57_0._info_bg_rect:x() + tweak_data.menu.info_padding, l_57_0._info_bg_rect:y() + tweak_data.menu.info_padding, l_57_0._info_bg_rect:w() - tweak_data.menu.info_padding * 2, l_57_0._info_bg_rect:h() - tweak_data.menu.info_padding * 2)
end

local xl_pad = 64
MenuNodeGui._align_info_panel = function(l_58_0, l_58_1)
  l_58_0:_align_item_gui_info_panel(l_58_1.gui_info_panel)
  l_58_1.help_title:set_font_size(l_58_0.font_size)
  l_58_1.help_title:set_shape(l_58_1.help_title:text_rect())
  l_58_1.help_title:set_position(0, 0)
  l_58_1.help_text:set_font_size(tweak_data.menu.pd2_small_font)
  l_58_1.help_text:set_w(l_58_1.gui_info_panel:w())
  l_58_1.help_text:set_shape(l_58_1.help_text:text_rect())
  l_58_1.help_text:set_x(0)
  l_58_1.help_text:set_top(l_58_1.help_title:bottom() + tweak_data.menu.info_padding)
end

MenuNodeGui._align_normal = function(l_59_0, l_59_1)
  local safe_rect = l_59_0:_scaled_size()
  if not l_59_1.font_size then
    l_59_1.gui_panel:set_font_size(l_59_0.font_size)
  end
  local x, y, w, h = l_59_1.gui_panel:text_rect()
  l_59_1.gui_panel:set_height(h)
  l_59_1.gui_panel:set_left(l_59_0:_right_align() + (l_59_1.item:parameters().expand_value or 0))
  l_59_1.gui_panel:set_w(safe_rect.width - l_59_1.gui_panel:left())
  if l_59_1.icon then
    l_59_1.icon:set_left(l_59_1.gui_panel:right())
    l_59_1.icon:set_center_y(l_59_1.gui_panel:center_y())
    l_59_1.icon:set_color(l_59_1.gui_panel:color())
  end
  if l_59_1.gui_info_panel then
    l_59_0:_align_info_panel(l_59_1)
  end
end

MenuNodeGui._align_chat = function(l_60_0, l_60_1)
  local safe_rect = l_60_0:_scaled_size()
  l_60_1.chat_input:script().text:set_font_size(tweak_data.hud.chatinput_size)
  l_60_1.chat_input:set_h(25 * tweak_data.scale.chat_multiplier)
  l_60_1.chat_output:script().scrollus:set_font_size(tweak_data.hud.chatoutput_size)
  l_60_1.gui_panel:set_w(safe_rect.width / 2)
  l_60_1.gui_panel:set_right(safe_rect.width)
  l_60_1.gui_panel:set_h(118 * tweak_data.scale.chat_menu_h_multiplier + 25 * tweak_data.scale.chat_multiplier + 2)
  l_60_1.chat_input:set_w(l_60_1.gui_panel:w())
  l_60_1.chat_input:set_bottom(l_60_1.gui_panel:h())
  l_60_1.chat_input:set_right(l_60_1.gui_panel:w())
  l_60_1.border:set_w(l_60_1.chat_input:w())
  l_60_1.border:set_bottom(l_60_1.chat_input:top())
  local h = l_60_1.gui_panel:h() - l_60_1.chat_input:h() - 2
  l_60_1.chat_output:set_h(h)
  l_60_1.chat_output:set_w(l_60_1.gui_panel:w())
  l_60_1.chat_output:set_bottom(h)
  l_60_1.chat_output:set_right(l_60_1.gui_panel:w())
  if l_60_1.icon then
    l_60_1.icon:set_left(l_60_1.gui_panel:right())
    l_60_1.icon:set_center_y(l_60_1.gui_panel:center_y())
    l_60_1.icon:set_color(l_60_1.gui_panel:color())
  end
end

MenuNodeGui._update_scaled_values = function(l_61_0)
  if not l_61_0.font_size then
    l_61_0.font_size = tweak_data.menu.pd2_medium_font_size
  end
  if not l_61_0.font then
    l_61_0.font = tweak_data.menu.pd2_medium_font
  end
  l_61_0._align_line_padding = 10 * tweak_data.scale.align_line_padding_multiplier
end

MenuNodeGui.resolution_changed = function(l_62_0)
  l_62_0:_update_scaled_values()
  local safe_rect = l_62_0:_scaled_size()
  do
    local res = RenderSettings.resolution
    l_62_0._info_bg_rect:set_shape(0, tweak_data.load_level.upper_saferect_border, safe_rect.width * 0.40999999642372, safe_rect.height - tweak_data.load_level.upper_saferect_border * 2)
    for _,row_item in pairs(l_62_0.row_items) do
      if row_item.item:parameters().trial_buy then
        l_62_0:_setup_trial_buy(row_item)
      end
      if row_item.item:parameters().fake_disabled then
        l_62_0:_setup_fake_disabled(row_item)
      end
      if not row_item.item:reload(row_item, l_62_0) then
        if row_item.item:parameters().back then
          for (for control),_ in (for generator) do
          end
          if row_item.item:parameters().pd2_corner then
            for (for control),_ in (for generator) do
            end
            if row_item.type == "chat" then
              l_62_0:_align_chat(row_item)
              for (for control),_ in (for generator) do
              end
              if row_item.type ~= "kitslot" and row_item.type ~= "server_column" then
                l_62_0:_align_normal(row_item)
              end
            end
          end
          MenuNodeGui.super.resolution_changed(l_62_0)
          l_62_0._align_data.panel:set_center_x(l_62_0:_mid_align())
          l_62_0._list_arrows.up:set_left(l_62_0._align_data.panel:world_center())
          l_62_0._list_arrows.down:set_left(l_62_0._align_data.panel:world_center())
          l_62_0._legends_panel:set_shape(safe_rect.x, safe_rect.y, safe_rect.width, safe_rect.height)
          l_62_0:_layout_legends()
        end
         -- Warning: missing end command somewhere! Added here
      end
       -- Warning: missing end command somewhere! Added here
    end
     -- Warning: missing end command somewhere! Added here
  end
end

MenuNodeGui._layout_legends = function(l_63_0)
  local safe_rect = l_63_0:_scaled_size()
  local res = RenderSettings.resolution
  local text = l_63_0._legends_panel:child(0)
  local _, _, w, h = text:text_rect()
  l_63_0._legends_panel:set_h(h)
  local is_pc = managers.menu:is_pc_controller()
  if is_pc then
    text:set_center_x(l_63_0._legends_panel:w() / 2)
  else
    text:set_right(l_63_0._legends_panel:w())
  end
  text:set_bottom(l_63_0._legends_panel:h() - 2)
  l_63_0._legends_panel:set_bottom(l_63_0.ws:panel():bottom())
end

MenuNodeGui.set_visible = function(l_64_0, l_64_1)
  MenuNodeGui.super.set_visible(l_64_0, l_64_1)
  if l_64_1 then
    local active_menu = managers.menu:active_menu()
    if active_menu then
      active_menu.renderer:set_stencil_image(l_64_0._stencil_image)
      active_menu.renderer:set_stencil_align(l_64_0._stencil_align, l_64_0._stencil_align_percent)
      active_menu.renderer:set_stencil_image(l_64_0._stencil_image)
      active_menu.renderer:set_bg_visible(l_64_0._bg_visible)
      active_menu.renderer:set_bg_area(l_64_0._bg_area)
    end
    if l_64_0._scene_state then
      managers.menu_scene:set_scene_template(l_64_0._scene_state)
    end
  end
  local active_menu = managers.menu:active_menu()
  if active_menu then
    if l_64_1 and l_64_0.row_items and #l_64_0.row_items > 0 then
      for _,row_item in ipairs(l_64_0.row_items) do
        if row_item.highlighted then
          active_menu.renderer:set_bottom_text(row_item.item:parameters().help_id)
      else
        end
      end
    else
      active_menu.renderer:set_bottom_text(nil)
    end
  end
end
end

MenuNodeGui.close = function(l_65_0, ...)
  for _,row_item in ipairs(l_65_0.row_items) do
    local item = row_item.item
    local type = item:type()
    if (type == "expand" or type == "weapon_expand" or type == "weapon_upgrade_expand") and item:expanded() then
      item:toggle()
      l_65_0:_reload_expand(item)
    end
  end
  MenuNodeGui.super.close(l_65_0, ...)
   -- DECOMPILER ERROR: Confused about usage of registers for local variables.

end


