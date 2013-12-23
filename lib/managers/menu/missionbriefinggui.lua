-- Decompiled using luadec 2.0.1 by sztupy (http://winmo.sztupy.hu)
-- Command line was: F:\SteamLibrary\SteamApps\common\PAYDAY 2\lua\lib\managers\menu\missionbriefinggui.luac 

require("lib/managers/menu/WalletGuiObject")
if not MissionBriefingTabItem then
  MissionBriefingTabItem = class()
end
MissionBriefingTabItem.init = function(l_1_0, l_1_1, l_1_2, l_1_3)
  l_1_0._main_panel = l_1_1
  l_1_0._panel = l_1_0._main_panel:panel({})
  l_1_0._index = l_1_3
  local prev_item_title_text = l_1_0._main_panel:child("tab_text_" .. tostring(l_1_3 - 1))
  local offset = prev_item_title_text and prev_item_title_text:right() + 5 or 0
   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

  l_1_0._tab_text, {name = "tab_text_" .. tostring(l_1_0._index), text = l_1_2, h = 32, x = offset, align = "center", vertical = "center"}.blend_mode, {name = "tab_text_" .. tostring(l_1_0._index), text = l_1_2, h = 32, x = offset, align = "center", vertical = "center"}.layer, {name = "tab_text_" .. tostring(l_1_0._index), text = l_1_2, h = 32, x = offset, align = "center", vertical = "center"}.color, {name = "tab_text_" .. tostring(l_1_0._index), text = l_1_2, h = 32, x = offset, align = "center", vertical = "center"}.font, {name = "tab_text_" .. tostring(l_1_0._index), text = l_1_2, h = 32, x = offset, align = "center", vertical = "center"}.font_size = l_1_0._main_panel:text({name = "tab_text_" .. tostring(l_1_0._index), text = l_1_2, h = 32, x = offset, align = "center", vertical = "center"}), "add", 1, tweak_data.screen_colors.button_stage_3, tweak_data.menu.pd2_medium_font, tweak_data.menu.pd2_medium_font_size
  local _, _, tw, th = l_1_0._tab_text:text_rect()
  l_1_0._tab_text:set_size(tw + 15, th + 10)
  l_1_0._tab_select_rect = l_1_0._main_panel:bitmap({name = "tab_select_rect_" .. tostring(l_1_0._index), texture = "guis/textures/pd2/shared_tab_box", layer = 0, color = tweak_data.screen_colors.text, visible = false})
  l_1_0._tab_select_rect:set_shape(l_1_0._tab_text:shape())
  l_1_0._panel:set_top(l_1_0._tab_text:bottom() - 3)
  l_1_0._panel:grow(0, -(l_1_0._panel:top() + 70 + tweak_data.menu.pd2_small_font_size * 4 + 35))
  l_1_0._selected = true
  l_1_0:deselect()
end

MissionBriefingTabItem.reduce_to_small_font = function(l_2_0)
  l_2_0._tab_text:set_font(tweak_data.menu.pd2_small_font_id)
  l_2_0._tab_text:set_font_size(tweak_data.menu.pd2_small_font_size)
  local prev_item_title_text = l_2_0._main_panel:child("tab_text_" .. tostring(l_2_0._index - 1))
  local offset = prev_item_title_text and prev_item_title_text:right() or 0
  local x, y, w, h = l_2_0._tab_text:text_rect()
  l_2_0._tab_text:set_size(w + 15, h + 10)
  l_2_0._tab_text:set_x(offset + 5)
  l_2_0._tab_select_rect:set_shape(l_2_0._tab_text:shape())
  l_2_0._panel:set_top(l_2_0._tab_text:bottom() - 3)
  l_2_0._panel:set_h(l_2_0._main_panel:h())
  l_2_0._panel:grow(0, -(l_2_0._panel:top() + 70 + tweak_data.menu.pd2_small_font_size * 4 + 35))
end

MissionBriefingTabItem.show = function(l_3_0)
  l_3_0._panel:show()
end

MissionBriefingTabItem.hide = function(l_4_0)
  l_4_0._panel:hide()
end

MissionBriefingTabItem.panel = function(l_5_0)
  return l_5_0._panel
end

MissionBriefingTabItem.index = function(l_6_0)
  return l_6_0._index
end

MissionBriefingTabItem.select = function(l_7_0, l_7_1)
  if l_7_0._selected then
    return 
  end
  l_7_0:show()
  if l_7_0._tab_text and alive(l_7_0._tab_text) then
    l_7_0._tab_text:set_color(tweak_data.screen_colors.button_stage_1)
    l_7_0._tab_text:set_blend_mode("normal")
    l_7_0._tab_select_rect:show()
  end
  l_7_0._selected = true
  if l_7_1 then
    return 
  end
  managers.menu_component:post_event("highlight")
end

MissionBriefingTabItem.deselect = function(l_8_0)
  if not l_8_0._selected then
    return 
  end
  l_8_0:hide()
  if l_8_0._tab_text and alive(l_8_0._tab_text) then
    l_8_0._tab_text:set_color(tweak_data.screen_colors.button_stage_3)
    l_8_0._tab_text:set_blend_mode("add")
    l_8_0._tab_select_rect:hide()
  end
  l_8_0._selected = false
end

MissionBriefingTabItem.mouse_moved = function(l_9_0, l_9_1, l_9_2)
  if not l_9_0._selected and l_9_0._tab_text:inside(l_9_1, l_9_2) and not l_9_0._highlighted then
    l_9_0._highlighted = true
    l_9_0._tab_text:set_color(tweak_data.screen_colors.button_stage_2)
    managers.menu_component:post_event("highlight")
    do return end
    if l_9_0._highlighted then
      l_9_0._tab_text:set_color(tweak_data.screen_colors.button_stage_3)
      l_9_0._highlighted = false
    end
  end
  if l_9_0._panel:inside(l_9_1, l_9_2) then
    return l_9_0._selected
  end
end

MissionBriefingTabItem.mouse_pressed = function(l_10_0, l_10_1, l_10_2, l_10_3)
  if l_10_1 ~= Idstring("0") then
    return false
  end
  if not l_10_0._selected and l_10_0._tab_text:inside(l_10_2, l_10_3) then
    return true
  end
  return l_10_0._selected
end

MissionBriefingTabItem.move_left = function(l_11_0)
end

MissionBriefingTabItem.move_right = function(l_12_0)
end

MissionBriefingTabItem.move_up = function(l_13_0)
end

MissionBriefingTabItem.move_down = function(l_14_0)
end

MissionBriefingTabItem.update = function(l_15_0, l_15_1, l_15_2)
end

MissionBriefingTabItem.confirm_pressed = function(l_16_0)
end

MissionBriefingTabItem.something_selected = function(l_17_0)
  return false
end

MissionBriefingTabItem.destroy = function(l_18_0)
  l_18_0._main_panel:remove(l_18_0._panel)
  l_18_0._main_panel:remove(l_18_0._tab_text)
  l_18_0._main_panel:remove(l_18_0._tab_select_rect)
  l_18_0._panel = nil
  l_18_0._tab_text = nil
  l_18_0._tab_select_rect = nil
end

MissionBriefingTabItem.animate_select = function(l_19_0, l_19_1, l_19_2)
  l_19_0:set_layer(2)
  local size = l_19_0:h()
  if size == 100 then
    return 
  end
  managers.menu_component:post_event("highlight")
  local center_x, center_y = l_19_0:center()
  if alive(l_19_1) then
    local center_x, center_y = l_19_1:center()
  end
  local aspect = l_19_0:texture_width() / math.max(1, l_19_0:texture_height())
  if l_19_2 then
    local s = math.lerp(size, 100, 1)
    l_19_0:set_size(s * aspect, s)
    l_19_0:set_center(center_x, center_y)
    return 
  end
  over(math.abs(100 - size) / 100, function(l_1_0)
    local s = math.lerp(size, 100, l_1_0)
    if alive(center_helper) then
      upvalue_1024, upvalue_1536 = center_helper:center(), center_helper
    end
    o:set_size(s * aspect, s)
    o:set_center(center_x, center_y)
   end)
end

MissionBriefingTabItem.animate_deselect = function(l_20_0, l_20_1)
  l_20_0:set_layer(1)
  local size = l_20_0:h()
  if size == 65 then
    return 
  end
  local center_x, center_y = l_20_0:center()
  if alive(l_20_1) then
    local center_x, center_y = l_20_1:center()
  end
  local aspect = l_20_0:texture_width() / math.max(1, l_20_0:texture_height())
  over(math.abs(65 - size) / 100, function(l_1_0)
    local s = math.lerp(size, 65, l_1_0)
    if alive(center_helper) then
      upvalue_1024, upvalue_1536 = center_helper:center(), center_helper
    end
    o:set_size(s * aspect, s)
    o:set_center(center_x, center_y)
   end)
end

if not DescriptionItem then
  DescriptionItem = class(MissionBriefingTabItem)
end
DescriptionItem.init = function(l_21_0, l_21_1, l_21_2, l_21_3, l_21_4)
  DescriptionItem.super.init(l_21_0, l_21_1, l_21_2, l_21_3)
  if not managers.job:has_active_job() then
    return 
  end
  local stage_data = managers.job:current_stage_data()
  local level_data = managers.job:current_level_data()
  if not stage_data.name_id then
    local name_id = level_data.name_id
  end
  if not stage_data.briefing_id then
    local briefing_id = level_data.briefing_id
  end
  local title_text = l_21_0._panel:text({name = "title_text", text = managers.localization:to_upper_text(name_id), font_size = tweak_data.menu.pd2_medium_font_size, font = tweak_data.menu.pd2_medium_font, y = 10, x = 10, color = tweak_data.screen_colors.text})
  local x, y, w, h = title_text:text_rect()
  title_text:set_size(w, h)
  title_text:set_position(math.round(title_text:x()), math.round(title_text:y()))
  l_21_0._scroll_panel = l_21_0._panel:panel({x = 10, y = title_text:bottom()})
  l_21_0._scroll_panel:grow(-l_21_0._scroll_panel:x() - 10, -l_21_0._scroll_panel:y())
  local desc_text = l_21_0._scroll_panel:text({name = "description_text", text = managers.localization:text(briefing_id), font_size = tweak_data.menu.pd2_small_font_size, font = tweak_data.menu.pd2_small_font, wrap = true, word_wrap = true, color = tweak_data.screen_colors.text})
  local _, _, _, h = desc_text:text_rect()
  desc_text:set_h(h)
  if l_21_0._scroll_panel:h() < desc_text:h() then
    l_21_0._scrolling = true
    l_21_0._scroll_box = BoxGuiObject:new(l_21_0._scroll_panel, {sides = {0, 0, 0, 0}})
    l_21_0._show_scroll_line_top = false
    l_21_0._show_scroll_line_bottom = false
    local show_scroll_line_top = desc_text:top() < 0
    local show_scroll_line_bottom = l_21_0._scroll_panel:h() < desc_text:bottom()
    if not show_scroll_line_bottom or not 2 then
      l_21_0._scroll_box:create_sides(l_21_0._scroll_panel, {sides = {0, 0, show_scroll_line_top == l_21_0._show_scroll_line_top and show_scroll_line_bottom == l_21_0._show_scroll_line_bottom or 0, 0}})
      l_21_0._show_scroll_line_top = show_scroll_line_top
      l_21_0._show_scroll_line_bottom = show_scroll_line_bottom
      if not managers.menu:is_pc_controller() then
        local legends = {"menu_legend_preview_move"}
        local t_text = ""
        for i,string_id in ipairs(legends) do
          local spacing = i > 1 and "  |  " or ""
          t_text = t_text .. spacing .. utf8.to_upper(managers.localization:text(string_id, {BTN_UPDATE = managers.localization:btn_macro("menu_update"), BTN_BACK = managers.localization:btn_macro("back")}))
        end
        local legend_text = l_21_0._panel:text({font = tweak_data.menu.pd2_small_font, font_size = tweak_data.menu.pd2_small_font_size, text = t_text, halign = "right", valign = "top"})
        local _, _, lw, lh = legend_text:text_rect()
        legend_text:set_size(lw, lh)
        legend_text:set_righttop(l_21_0._panel:w() - 5, 10)
      end
    end
    if l_21_4 then
      local text = ""
      for i,text_id in ipairs(l_21_4) do
        text = text .. managers.localization:text(text_id) .. "\n"
      end
      desc_text:set_text(text)
    end
     -- Warning: missing end command somewhere! Added here
  end
end

DescriptionItem.set_title_text = function(l_22_0, l_22_1)
  l_22_0._panel:child("title_text"):set_text(l_22_1)
end

DescriptionItem.add_description_text = function(l_23_0, l_23_1)
  l_23_0._panel:child("description_text"):set_text(l_23_0._panel:child("description_text"):text() .. "\n" .. l_23_1)
end

DescriptionItem.set_description_text = function(l_24_0, l_24_1)
  l_24_0._panel:child("description_text"):set_text(l_24_1)
end

DescriptionItem.move_up = function(l_25_0)
  if not managers.job:has_active_job() or not l_25_0._scrolling then
    return 
  end
  local desc_text = l_25_0._scroll_panel:child("description_text")
  if desc_text:top() < 0 then
    l_25_0._scroll_speed = 2
  end
end

DescriptionItem.move_down = function(l_26_0)
  if not managers.job:has_active_job() or not l_26_0._scrolling then
    return 
  end
  local desc_text = l_26_0._scroll_panel:child("description_text")
  if l_26_0._scroll_panel:h() < desc_text:bottom() then
    l_26_0._scroll_speed = -2
  end
end

DescriptionItem.update = function(l_27_0, l_27_1, l_27_2)
  if not managers.job:has_active_job() or not l_27_0._scrolling then
    return 
  end
  local desc_text = l_27_0._scroll_panel:child("description_text")
  if l_27_0._scroll_panel:h() < desc_text:h() and l_27_0._scroll_speed then
    l_27_0._scroll_speed = math.step(l_27_0._scroll_speed, 0, l_27_2 * 4)
    desc_text:move(0, math.clamp(l_27_0._scroll_speed, -1, 1) * 100 * l_27_2)
    if desc_text:top() > 0 then
      desc_text:set_top(0)
      l_27_0._scroll_speed = nil
    else
      if desc_text:bottom() < l_27_0._scroll_panel:h() then
        desc_text:set_bottom(l_27_0._scroll_panel:h())
        l_27_0._scroll_speed = nil
      end
    end
    if l_27_0._scroll_speed == 0 then
      l_27_0._scroll_speed = nil
    end
    local show_scroll_line_top = desc_text:top() < 0
    local show_scroll_line_bottom = l_27_0._scroll_panel:h() < desc_text:bottom()
    if not show_scroll_line_bottom or not 2 then
      l_27_0._scroll_box:create_sides(l_27_0._scroll_panel, {sides = {0, 0, show_scroll_line_top == l_27_0._show_scroll_line_top and show_scroll_line_bottom == l_27_0._show_scroll_line_bottom or 0, 0}})
      l_27_0._show_scroll_line_top = show_scroll_line_top
      l_27_0._show_scroll_line_bottom = show_scroll_line_bottom
    end
     -- Warning: missing end command somewhere! Added here
  end
end

DescriptionItem.select = function(l_28_0, l_28_1)
  DescriptionItem.super.select(l_28_0, l_28_1)
end

DescriptionItem.deselect = function(l_29_0)
  DescriptionItem.super.deselect(l_29_0)
end

DescriptionItem.mouse_moved = function(l_30_0, l_30_1, l_30_2)
  DescriptionItem.super.mouse_moved(l_30_0, l_30_1, l_30_2)
end

DescriptionItem.mouse_pressed = function(l_31_0, l_31_1, l_31_2, l_31_3)
  local inside = DescriptionItem.super.mouse_pressed(l_31_0, l_31_1, l_31_2, l_31_3)
  if inside == false then
    return false
  end
  return inside
end

if not AssetsItem then
  AssetsItem = class(MissionBriefingTabItem)
end
AssetsItem.init = function(l_32_0, l_32_1, l_32_2, l_32_3, l_32_4, l_32_5, l_32_6)
  AssetsItem.super.init(l_32_0, l_32_1, l_32_2, l_32_3)
  l_32_0._my_menu_component_data = l_32_6
  l_32_0:create_assets(l_32_4, l_32_5)
end

AssetsItem.post_init = function(l_33_0)
  l_33_0:select_asset(l_33_0._my_menu_component_data.selected or 1, true)
  for i = 1, #l_33_0._assets_names do
    l_33_0._panel:child("asset_" .. tostring(i)):set_rotation(0)
  end
end

AssetsItem.select = function(l_34_0, l_34_1)
  AssetsItem.super.select(l_34_0, l_34_1)
end

AssetsItem.deselect = function(l_35_0)
  AssetsItem.super.deselect(l_35_0)
end

AssetsItem.get_asset_id = function(l_36_0, l_36_1)
  return l_36_0._assets_names[l_36_1][4]
end

AssetsItem.create_assets = function(l_37_0, l_37_1, l_37_2)
  l_37_0._panel:clear()
  l_37_0._asset_locked = {}
  l_37_0._assets_list = {}
  l_37_0._assets_names = l_37_1
  l_37_0._unlock_cost = l_37_1[3] or false
  local center_y = math.round(l_37_0._panel:h() / 2) - tweak_data.menu.pd2_small_font_size
  local rect = nil
  local w = l_37_0._panel:w() / (l_37_2 or 6)
  for i = 1, #l_37_1 do
    local center_x = i * w - w * 0.5
    rect = l_37_0._panel:rect({name = "bg_rect_" .. tostring(i), w = 85, h = 85})
    rect:set_center(center_x, center_y)
    rect:set_position(math.round(rect:x()), math.round(rect:y()))
    rect:hide()
    if i <= #l_37_1 then
      local asset = l_37_0._panel:bitmap({name = "asset_" .. tostring(i), texture = l_37_1[i][1], w = 65, h = 65, rotation = math.random(2) - 1.5, layer = 1, valign = "top"})
      local aspect = asset:texture_width() / math.max(1, asset:texture_height())
      asset:set_w(asset:h() * aspect)
      rect:set_w(rect:h() * aspect)
      rect:set_center(center_x, center_y)
      rect:set_position(math.round(rect:x()), math.round(rect:y()))
      asset:set_center(rect:center())
      asset:set_position(math.round(asset:x()), math.round(asset:y()))
      asset:set_rotation(0.5)
      do
         -- DECOMPILER ERROR: Confused while interpreting a jump as a 'while'

      end
      local lock = l_37_0._panel:bitmap({name = "asset_lock_" .. tostring(i), texture = l_37_1[i][3] or "guis/textures/pd2/skilltree/padlock", color = tweak_data.screen_colors.item_stage_1, layer = 3})
      lock:set_center(rect:center())
      asset:set_color(Color.black:with_alpha(0.60000002384186))
      l_37_0._asset_locked[i] = true
    end
    table.insert(l_37_0._assets_list, asset)
  end
end
l_37_0._text_strings_localized = false
 -- DECOMPILER ERROR: Confused about usage of registers!

 -- DECOMPILER ERROR: Confused about usage of registers!

 -- DECOMPILER ERROR: Confused about usage of registers!

 -- DECOMPILER ERROR: Confused about usage of registers!

 -- DECOMPILER ERROR: Confused about usage of registers!

 -- DECOMPILER ERROR: Confused about usage of registers!

 -- DECOMPILER ERROR: Confused about usage of registers!

if rect then
  l_37_0._asset_text, {name = "asset_text", text = ""}.color, {name = "asset_text", text = ""}.layer, {name = "asset_text", text = ""}.font, {name = "asset_text", text = ""}.font_size, {name = "asset_text", text = ""}.vertical, {name = "asset_text", text = ""}.align, {name = "asset_text", text = ""}.h = l_37_0._panel:text({name = "asset_text", text = ""}), tweak_data.screen_colors.text, 4, tweak_data.menu.pd2_small_font, tweak_data.menu.pd2_small_font_size, "top", "center", 64
  l_37_0._asset_text:set_top(rect:bottom() + tweak_data.menu.pd2_small_font_size * 0.5 - 6)
end
l_37_0._my_asset_space = w
l_37_0._my_left_i = l_37_0._my_menu_component_data.my_left_i or 1
if #l_37_0._assets_list > 6 then
  l_37_0._move_left_rect = l_37_0._panel:bitmap({texture = "guis/textures/pd2/hud_arrow", color = tweak_data.screen_colors.button_stage_3, rotation = 360, w = 32, h = 32, blend_mode = "add", layer = 3})
  l_37_0._move_left_rect:set_center(0, l_37_0._panel:h() / 2)
  l_37_0._move_left_rect:set_position(math.round(l_37_0._move_left_rect:x()), math.round(l_37_0._move_left_rect:y()))
  l_37_0._move_right_rect = l_37_0._panel:bitmap({texture = "guis/textures/pd2/hud_arrow", color = tweak_data.screen_colors.button_stage_3, rotation = 180, w = 32, h = 32, blend_mode = "add", layer = 3})
  l_37_0._move_right_rect:set_center(l_37_0._panel:w(), l_37_0._panel:h() / 2)
  l_37_0._move_right_rect:set_position(math.round(l_37_0._move_right_rect:x()), math.round(l_37_0._move_right_rect:y()))
end
if not managers.menu:is_pc_controller() then
  local legends = {"menu_legend_preview_move", "menu_legend_select"}
  local t_text = ""
  for i,string_id in ipairs(legends) do
    local spacing = i > 1 and "  |  " or ""
    t_text = t_text .. spacing .. utf8.to_upper(managers.localization:text(string_id, {BTN_UPDATE = managers.localization:btn_macro("menu_update"), BTN_BACK = managers.localization:btn_macro("back")}))
  end
  local legend_text = l_37_0._panel:text({font = tweak_data.menu.pd2_small_font, font_size = tweak_data.menu.pd2_small_font_size, text = t_text})
  local _, _, lw, lh = legend_text:text_rect()
  legend_text:set_size(lw, lh)
  legend_text:set_righttop(l_37_0._panel:w() - 5, 10)
end
local first_rect = l_37_0._panel:child("bg_rect_1")
if first_rect then
  l_37_0._select_box_panel = l_37_0._panel:panel({layer = -3, visible = false})
  l_37_0._select_box_panel:set_shape(first_rect:shape())
  l_37_0._select_box = BoxGuiObject:new(l_37_0._select_box_panel, {sides = {2, 2, 2, 2}})
end
l_37_0:post_init()
end

AssetsItem.unlock_asset_by_id = function(l_38_0, l_38_1)
  for i,asset_data in ipairs(l_38_0._assets_names) do
    if Idstring(asset_data[4]) == Idstring(l_38_1) then
      l_38_0._asset_locked[i] = false
      l_38_0._assets_list[i]:set_color(Color.white)
      local lock = l_38_0._panel:child("asset_lock_" .. tostring(i))
      if lock then
        l_38_0._panel:remove(lock)
      end
    end
  end
  l_38_0:select_asset(l_38_0._asset_selected, true)
end

AssetsItem.move_assets_left = function(l_39_0)
  l_39_0._my_left_i = math.max(l_39_0._my_left_i - 1, 1)
  l_39_0:update_asset_positions_and_text()
  managers.menu_component:post_event("menu_enter")
end

AssetsItem.move_assets_right = function(l_40_0)
  l_40_0._my_left_i = math.min(l_40_0._my_left_i + 1, #l_40_0._assets_list - 5)
  l_40_0:update_asset_positions_and_text()
  managers.menu_component:post_event("menu_enter")
end

AssetsItem.update_asset_positions_and_text = function(l_41_0)
  l_41_0:update_asset_positions()
  local bg = l_41_0._panel:child("bg_rect_" .. tostring(l_41_0._asset_selected))
  if alive(bg) then
    local _, _, w, _ = l_41_0._asset_text:text_rect()
    l_41_0._asset_text:set_w(w)
    l_41_0._asset_text:set_center_x(bg:center_x())
    if l_41_0._asset_text:left() < 10 then
      l_41_0._asset_text:set_left(10)
    else
      if l_41_0._panel:w() - 10 < l_41_0._asset_text:right() then
        l_41_0._asset_text:set_right(l_41_0._panel:w() - 10)
      end
    end
  end
end

AssetsItem.update_asset_positions = function(l_42_0)
  l_42_0._my_menu_component_data.my_left_i = l_42_0._my_left_i
  local w = l_42_0._my_asset_space
  for i,asset in pairs(l_42_0._assets_list) do
    local cx = (i - (l_42_0._my_left_i - 1)) * w - w / 2
    local lock = l_42_0._panel:child("asset_lock_" .. tostring(i))
    if alive(lock) then
      lock:set_center_x(cx)
    end
    l_42_0._panel:child("bg_rect_" .. tostring(i)):set_center_x(cx)
    l_42_0._panel:child("bg_rect_" .. tostring(i)):set_left(math.round(l_42_0._panel:child("bg_rect_" .. tostring(i)):left()))
    asset:set_center_x(cx)
    asset:set_left(math.round(asset:left()))
  end
  l_42_0._move_left_rect:set_visible(l_42_0._my_left_i ~= 1)
  l_42_0._move_right_rect:set_visible(l_42_0._my_left_i + 5 ~= #l_42_0._assets_list)
end

AssetsItem.select_asset = function(l_43_0, l_43_1, l_43_2)
  if #l_43_0._assets_list > 6 then
    if l_43_1 then
      if l_43_1 < l_43_0._my_left_i then
        l_43_0._my_left_i = l_43_1
      else
        if l_43_0._my_left_i + 5 < l_43_1 then
          l_43_0._my_left_i = l_43_1 - 5
        end
      end
    end
    l_43_0:update_asset_positions()
  end
  if not l_43_1 then
    return 
  end
  local bg = l_43_0._panel:child("bg_rect_" .. tostring(l_43_1))
  if not l_43_0._assets_names[l_43_1] then
    return 
  end
  local text_string = l_43_0._assets_names[l_43_1][2]
  local extra_string = ""
  local extra_color = nil
  if not l_43_0._text_strings_localized then
    text_string = managers.localization:text(text_string)
  end
  text_string = text_string .. "\n"
  if l_43_0._asset_selected == l_43_1 and not l_43_2 then
    return 
  end
  local is_init = l_43_0._asset_selected == nil
  l_43_0:check_deselect_item()
  l_43_0._asset_selected = l_43_1
  l_43_0._my_menu_component_data.selected = l_43_0._asset_selected
  local rect = l_43_0._panel:child("bg_rect_" .. tostring(l_43_1))
  if rect then
    l_43_0._select_box_panel:set_shape(rect:shape())
    l_43_0._select_box:create_sides(l_43_0._select_box_panel, {sides = {2, 2, 2, 2}})
  end
  if l_43_0._asset_locked[l_43_1] then
    if not Network:is_server() then
      local is_server = managers.assets.ALLOW_CLIENTS_UNLOCK
    end
    local can_unlock = l_43_0._assets_names[l_43_1][5]
    if not l_43_0._assets_names[l_43_1][6] or not text_string then
      text_string = ""
    end
    if is_server and can_unlock then
      extra_string = extra_string .. managers.localization:text("st_menu_cost") .. " " .. managers.experience:cash_string(managers.money:get_mission_asset_cost_by_id(l_43_0._assets_names[l_43_1][4])) .. "\n"
      if not managers.money:can_afford_mission_asset(l_43_0._assets_names[l_43_1][4]) then
        extra_string = extra_string .. managers.localization:text("bm_menu_not_enough_cash")
        extra_color = tweak_data.screen_colors.important_1
      else
        if is_server or not "menu_briefing_asset_server_locked" then
          extra_string = extra_string .. managers.localization:text(managers.assets:get_asset_unlock_text_by_id(l_43_0._assets_names[l_43_1][4]))
        end
      end
      if not extra_color and (not can_unlock or not tweak_data.screen_colors.text) then
        extra_color = tweak_data.screen_colors.important_1
      end
    end
    if not extra_color then
      extra_color = tweak_data.screen_colors.text
    end
    l_43_0._asset_text:set_text(text_string .. extra_string)
    l_43_0._asset_text:set_selection(utf8.len(text_string), utf8.len(l_43_0._asset_text:text()))
    l_43_0._asset_text:set_color(tweak_data.screen_colors.text)
    l_43_0._asset_text:set_selection_color(extra_color)
    l_43_0._assets_list[l_43_1]:stop()
    l_43_0._assets_list[l_43_1]:animate(l_43_0.animate_select, l_43_0._panel:child("bg_rect_" .. tostring(l_43_1)), l_43_2)
    if alive(bg) then
      local _, _, w, _ = l_43_0._asset_text:text_rect()
      l_43_0._asset_text:set_w(w)
      l_43_0._asset_text:set_center_x(bg:center_x())
      if l_43_0._asset_text:left() < 10 then
        l_43_0._asset_text:set_left(10)
        local len_to_left = math.abs(l_43_0._assets_list[l_43_1]:center_x() - l_43_0._asset_text:left())
        local len_to_center = math.abs(l_43_0._assets_list[l_43_1]:center_x() - l_43_0._asset_text:center_x())
        l_43_0._asset_text:set_align(len_to_left < len_to_center and "left" or "center")
      else
        if l_43_0._panel:w() - 10 < l_43_0._asset_text:right() then
          l_43_0._asset_text:set_right(l_43_0._panel:w() - 10)
          local len_to_right = math.abs(l_43_0._assets_list[l_43_1]:center_x() - l_43_0._asset_text:right())
          local len_to_center = math.abs(l_43_0._assets_list[l_43_1]:center_x() - l_43_0._asset_text:center_x())
          l_43_0._asset_text:set_align(len_to_right < len_to_center and "right" or "center")
        else
          l_43_0._asset_text:set_align("center")
        end
      end
    end
     -- Warning: missing end command somewhere! Added here
  end
end

AssetsItem.check_deselect_item = function(l_44_0)
  if l_44_0._asset_selected and l_44_0._assets_list[l_44_0._asset_selected] then
    l_44_0._assets_list[l_44_0._asset_selected]:stop()
    l_44_0._assets_list[l_44_0._asset_selected]:animate(l_44_0.animate_deselect, l_44_0._panel:child("bg_rect_" .. tostring(l_44_0._asset_selected)))
    l_44_0._asset_text:set_text("")
  end
  l_44_0._asset_selected = nil
end

AssetsItem.mouse_moved = function(l_45_0, l_45_1, l_45_2)
  if alive(l_45_0._move_left_rect) and alive(l_45_0._move_right_rect) then
    if l_45_0._move_left_rect:visible() and l_45_0._move_left_rect:inside(l_45_1, l_45_2) then
      if not l_45_0._move_left_highlighted then
        l_45_0._move_left_highlighted = true
        l_45_0._move_left_rect:set_color(tweak_data.screen_colors.button_stage_2)
        managers.menu_component:post_event("highlight")
        l_45_0:check_deselect_item()
      end
      l_45_0._asset_text:set_text("")
      return 
    elseif l_45_0._move_left_highlighted then
      l_45_0._move_left_rect:set_color(tweak_data.screen_colors.button_stage_3)
      l_45_0._move_left_highlighted = false
    end
    if l_45_0._move_right_rect:visible() and l_45_0._move_right_rect:inside(l_45_1, l_45_2) then
      if not l_45_0._move_right_highlighted then
        l_45_0._move_right_highlighted = true
        l_45_0._move_right_rect:set_color(tweak_data.screen_colors.button_stage_2)
        managers.menu_component:post_event("highlight")
        l_45_0:check_deselect_item()
      end
      l_45_0._asset_text:set_text("")
      return 
    elseif l_45_0._move_right_highlighted then
      l_45_0._move_right_rect:set_color(tweak_data.screen_colors.button_stage_3)
      l_45_0._move_right_highlighted = false
    end
  end
  if AssetsItem.super.mouse_moved(l_45_0, l_45_1, l_45_2) == false then
    l_45_0:check_deselect_item()
    return 
  end
  if not l_45_0._assets_list then
    l_45_0._assets_list = {}
  end
  local update_select = false
  if not l_45_0._asset_selected then
    update_select = true
  else
    if l_45_0._assets_list[l_45_0._asset_selected] and not l_45_0._panel:child("bg_rect_" .. tostring(l_45_0._asset_selected)):inside(l_45_1, l_45_2) and l_45_0._assets_list[l_45_0._asset_selected]:visible() then
      update_select = true
    end
  end
  if update_select then
    for i,asset in ipairs(l_45_0._assets_list) do
      if l_45_0._panel:child("bg_rect_" .. tostring(i)):inside(l_45_1, l_45_2) and asset:visible() then
        l_45_0:select_asset(i)
    else
      end
    end
     -- Warning: missing end command somewhere! Added here
  end
end

AssetsItem.mouse_pressed = function(l_46_0, l_46_1, l_46_2, l_46_3)
  local inside = AssetsItem.super.mouse_pressed(l_46_0, l_46_1, l_46_2, l_46_3)
  if inside == false then
    return false
  end
  if alive(l_46_0._move_left_rect) and alive(l_46_0._move_right_rect) then
    if l_46_0._move_left_rect:visible() and l_46_0._move_left_rect:inside(l_46_2, l_46_3) then
      l_46_0:move_assets_left()
      return 
    end
    if l_46_0._move_right_rect:visible() and l_46_0._move_right_rect:inside(l_46_2, l_46_3) then
      l_46_0:move_assets_right()
      return 
    end
  end
  if l_46_0._asset_selected and l_46_0._panel:child("bg_rect_" .. tostring(l_46_0._asset_selected)):inside(l_46_2, l_46_3) then
    return l_46_0:_return_asset_info(l_46_0._asset_selected)
  end
  return inside
end

AssetsItem.move_left = function(l_47_0)
  if #l_47_0._assets_list == 0 then
    return 
  end
  l_47_0._asset_selected = l_47_0._asset_selected or 0
  local new_selected = math.max(l_47_0._asset_selected - 1, 1)
  l_47_0:select_asset(new_selected)
  return 
end

AssetsItem.move_right = function(l_48_0)
  if #l_48_0._assets_list == 0 then
    return 
  end
  l_48_0._asset_selected = l_48_0._asset_selected or 0
  local new_selected = math.min(l_48_0._asset_selected + 1, #l_48_0._assets_list)
  l_48_0:select_asset(new_selected)
  return 
end

AssetsItem.confirm_pressed = function(l_49_0)
  return l_49_0:_return_asset_info(l_49_0._asset_selected)
end

AssetsItem.something_selected = function(l_50_0)
   -- DECOMPILER ERROR: Confused while interpreting a jump as a 'while'

end
return true
end

AssetsItem._return_asset_info = function(l_51_0, l_51_1)
  local asset_cost = nil
  if l_51_0._asset_locked[l_51_1] then
    if l_51_0._assets_names[l_51_1][5] then
      local can_unlock = managers.money:can_afford_mission_asset(l_51_0._assets_names[l_51_1][4])
    end
    if (Network:is_server() or managers.assets.ALLOW_CLIENTS_UNLOCK) and can_unlock then
      asset_cost = managers.money:get_mission_asset_cost_by_id(l_51_0._assets_names[l_51_1][4])
    else
      asset_cost = true
    end
  end
  return l_51_1, asset_cost
end

if not LoadoutItem then
  LoadoutItem = class(AssetsItem)
end
LoadoutItem.init = function(l_52_0, l_52_1, l_52_2, l_52_3, l_52_4, l_52_5)
  LoadoutItem.super.init(l_52_0, l_52_1, l_52_2, l_52_3, l_52_4, 4, l_52_5, true)
  l_52_0._text_strings_localized = true
  local got_deployables = managers.player:availible_equipment(1)
  got_deployables = not got_deployables or #got_deployables > 0
  if (not got_deployables and not l_52_0._assets_list[4]) or not managers.blackmarket:get_crafted_category("primaries") then
    local primaries = {}
  end
  local got_primary = false
  for _,d in pairs(primaries) do
    got_primary = true
    do return end
  end
   -- DECOMPILER ERROR: Confused while interpreting a jump as a 'while'

end
for i = 1, 2 do
  local weapon_data = l_52_4[i]
  local perks = weapon_data[4]
  if table.size(perks) > 0 then
    local perk_index = 1
    for perk in pairs(perks) do
      local perk_object = l_52_0._panel:bitmap({texture = "guis/textures/pd2/blackmarket/inv_mod_" .. perk, w = 16, h = 16, rotation = math.random(2) - 1.5, alpha = 0.80000001192093, layer = 2})
      perk_object:set_rightbottom(math.round(l_52_0._assets_list[i]:right() - perk_index * 16), math.round(l_52_0._assets_list[i]:bottom() - 5))
      perk_index = perk_index + 1
    end
  end
end
l_52_0:select_asset(l_52_0._my_menu_component_data.selected or 1, true)
end

LoadoutItem.post_init = function(l_53_0)
  if Application:production_build() then
    l_53_0._panel:set_debug(false)
  end
end

LoadoutItem.select = function(l_54_0, l_54_1)
  LoadoutItem.super.select(l_54_0, l_54_1)
end

LoadoutItem.deselect = function(l_55_0)
  LoadoutItem.super.deselect(l_55_0)
end

LoadoutItem.mouse_moved = function(l_56_0, l_56_1, l_56_2)
  LoadoutItem.super.mouse_moved(l_56_0, l_56_1, l_56_2)
end

LoadoutItem.open_node = function(l_57_0, l_57_1)
  l_57_0._my_menu_component_data.changing_loadout = nil
  l_57_0._my_menu_component_data.current_slot = nil
  if l_57_1 == 1 then
    l_57_0._my_menu_component_data.changing_loadout = "primary"
    l_57_0._my_menu_component_data.current_slot = managers.blackmarket:equipped_weapon_slot("primaries")
    managers.menu_component:post_event("menu_enter")
     -- DECOMPILER ERROR: No list found. Setlist fails

    managers.menu:open_node("loadout", {})
  elseif l_57_1 == 2 then
    managers.menu_component:post_event("menu_enter")
     -- DECOMPILER ERROR: Overwrote pending register.

     -- DECOMPILER ERROR: No list found. Setlist fails

    managers.menu:open_node("loadout", {})
  elseif l_57_1 == 3 then
    managers.menu_component:post_event("menu_enter")
     -- DECOMPILER ERROR: Overwrote pending register.

     -- DECOMPILER ERROR: No list found. Setlist fails

    managers.menu:open_node("loadout", {})
  elseif l_57_1 == 4 then
    managers.menu_component:post_event("menu_enter")
     -- DECOMPILER ERROR: Overwrote pending register.

     -- DECOMPILER ERROR: No list found. Setlist fails

    managers.menu:open_node("loadout", {})
  end
  managers.menu_component:on_ready_pressed_mission_briefing_gui(false)
   -- Warning: undefined locals caused missing assignments!
end

LoadoutItem.confirm_pressed = function(l_58_0)
  if l_58_0._asset_selected then
    l_58_0:open_node(l_58_0._asset_selected)
    return true
  end
end

LoadoutItem.mouse_pressed = function(l_59_0, l_59_1, l_59_2, l_59_3)
  local inside = LoadoutItem.super.mouse_pressed(l_59_0, l_59_1, l_59_2, l_59_3)
  if inside == false then
    return false
  end
  l_59_0:open_node(inside)
  return not inside or true
end

LoadoutItem.populate_category = function(l_60_0, l_60_1, l_60_2)
  if not managers.blackmarket:get_crafted_category(l_60_1) then
    local crafted_category = {}
  end
  local new_data = {}
  local index = 0
  for i,crafted in pairs(crafted_category) do
    new_data = {}
    new_data.name = crafted.weapon_id
    new_data.name_localized = managers.weapon_factory:get_weapon_name_by_factory_id(crafted.factory_id)
    new_data.category = l_60_1
    new_data.slot = i
    new_data.unlocked = managers.blackmarket:weapon_unlocked(crafted.weapon_id)
    new_data.lock_texture = (not new_data.unlocked and "guis/textures/pd2/lock_level")
    new_data.equipped = crafted.equipped
    new_data.level = (not new_data.unlocked and 0)
    new_data.skill_name = (new_data.level == 0 and "bm_menu_skill_locked_" .. new_data.name)
    new_data.bitmap_texture = "guis/textures/pd2/blackmarket/icons/weapons/" .. tostring(crafted.weapon_id)
    new_data.comparision_data = managers.blackmarket:get_weapon_stats(l_60_1, i)
    new_data.stream = false
    if new_data.comparision_data and new_data.comparision_data.alert_size then
      new_data.comparision_data.alert_size = #tweak_data.weapon.stats.alert_size - new_data.comparision_data.alert_size
    end
    if not new_data.equipped and new_data.unlocked then
      table.insert(new_data, "lo_w_equip")
    end
    local perks = managers.blackmarket:get_perks_from_weapon_blueprint(crafted.factory_id, crafted.blueprint)
    if table.size(perks) > 0 then
      new_data.mini_icons = {}
      local perk_index = 1
      for perk in pairs(perks) do
        table.insert(new_data.mini_icons, {texture = "guis/textures/pd2/blackmarket/inv_mod_" .. perk, right = (perk_index - 1) * 18, bottom = 0, layer = 1, w = 16, h = 16, stream = false})
        perk_index = perk_index + 1
      end
    end
    l_60_2[i] = new_data
    index = i
  end
  for i = 1, 9 do
    if not l_60_2[i] then
      new_data = {}
      new_data.name = "empty_slot"
      new_data.name_localized = managers.localization:text("bm_menu_empty_weapon_slot")
      new_data.name_localized_selected = new_data.name_localized
      new_data.is_loadout = true
      new_data.category = l_60_1
      new_data.empty_slot = true
      new_data.slot = i
      new_data.unlocked = true
      new_data.equipped = false
      l_60_2[i] = new_data
    end
  end
end

LoadoutItem.populate_primaries = function(l_61_0, l_61_1)
  l_61_0:populate_category("primaries", l_61_1)
end

LoadoutItem.populate_secondaries = function(l_62_0, l_62_1)
  l_62_0:populate_category("secondaries", l_62_1)
end

LoadoutItem.populate_armors = function(l_63_0, l_63_1)
  local new_data = {}
  local index = 0
  for armor_id,armor_data in pairs(tweak_data.blackmarket.armors) do
    local bm_data = Global.blackmarket_manager.armors[armor_id]
    if bm_data.owned then
      index = index + 1
      new_data = {}
      new_data.name = tweak_data.blackmarket.armors[armor_id].name_id
      new_data.category = "armors"
      new_data.slot = index
      new_data.unlocked = bm_data.unlocked
      new_data.lock_texture = (not new_data.unlocked and "guis/textures/pd2/lock_level")
      new_data.equipped = bm_data.equipped
      new_data.bitmap_texture = "guis/textures/pd2/blackmarket/icons/armors/" .. armor_id
      if not new_data.equipped then
        table.insert(new_data, "a_equip")
      end
      l_63_1[index] = new_data
    end
  end
  for i = 1, 9 do
    if not l_63_1[i] then
      new_data = {}
      new_data.name = "empty"
      new_data.name_localized = ""
      new_data.category = "armors"
      new_data.slot = i
      new_data.unlocked = true
      new_data.equipped = false
      l_63_1[i] = new_data
    end
  end
end

LoadoutItem.populate_deployables = function(l_64_0, l_64_1)
  if not managers.player:availible_equipment(1) then
    local deployables = {}
  end
  local new_data = {}
  local index = 0
  for i,deployable in ipairs(deployables) do
    new_data = {}
    new_data.name = deployable
    new_data.name_localized = managers.localization:text(tweak_data.upgrades.definitions[deployable].name_id)
    new_data.category = "deployables"
    new_data.bitmap_texture = "guis/textures/pd2/blackmarket/icons/deployables/" .. tostring(deployable)
    new_data.slot = i
    new_data.unlocked = true
    new_data.equipped = managers.player:equipment_in_slot(1) == deployable
    new_data.stream = false
    if not new_data.equipped then
      table.insert(new_data, "lo_d_equip")
    end
    l_64_1[i] = new_data
    index = i
  end
  for i = 1, 9 do
    if not l_64_1[i] then
      new_data = {}
      new_data.name = "empty"
      new_data.name_localized = ""
      new_data.category = "deployables"
      new_data.slot = i
      new_data.unlocked = true
      new_data.equipped = false
      l_64_1[i] = new_data
    end
  end
end

LoadoutItem.create_primaries_loadout = function(l_65_0)
  local data = {}
  table.insert(data, {name = "bm_menu_primaries", category = "primaries", on_create_func = callback(l_65_0, l_65_0, "populate_primaries"), identifier = Idstring("weapon")})
  data.topic_id = "menu_loadout_blackmarket"
  data.topic_params = {category = managers.localization:text("bm_menu_primaries")}
  return data
end

LoadoutItem.create_secondaries_loadout = function(l_66_0)
  local data = {}
  table.insert(data, {name = "bm_menu_secondaries", category = "secondaries", on_create_func = callback(l_66_0, l_66_0, "populate_secondaries"), identifier = Idstring("weapon")})
  data.topic_id = "menu_loadout_blackmarket"
  data.topic_params = {category = managers.localization:text("bm_menu_secondaries")}
  return data
end

LoadoutItem.create_deployable_loadout = function(l_67_0)
  local data = {}
  table.insert(data, {name = "bm_menu_deployables", category = "deployables", on_create_func_name = "populate_deployables", identifier = Idstring("deployable")})
  data.topic_id = "menu_loadout_blackmarket"
  data.topic_params = {category = managers.localization:text("bm_menu_deployables")}
  return data
end

LoadoutItem.create_armor_loadout = function(l_68_0)
  local data = {}
  table.insert(data, {name = "bm_menu_armors", category = "armors", on_create_func_name = "populate_armors", override_slots = {4, 2}, identifier = Idstring("armor")})
  data.topic_id = "menu_loadout_blackmarket"
  data.topic_params = {category = managers.localization:text("bm_menu_armors")}
  return data
end

LoadoutItem.animate_select = function(l_69_0, l_69_1, l_69_2)
  LoadoutItem.super.animate_select(l_69_0, l_69_1, l_69_2)
end

LoadoutItem.animate_deselect = function(l_70_0, l_70_1, l_70_2)
  LoadoutItem.super.animate_deselect(l_70_0, l_70_1, l_70_2)
end

if not TeamLoadoutItem then
  TeamLoadoutItem = class(MissionBriefingTabItem)
end
TeamLoadoutItem.init = function(l_71_0, l_71_1, l_71_2, l_71_3)
  TeamLoadoutItem.super.init(l_71_0, l_71_1, l_71_2, l_71_3)
  l_71_0._player_slots = {}
  local quarter_width = l_71_0._panel:w() / 4
  local slot_panel = nil
  for i = 1, 4 do
    local old_right = slot_panel and slot_panel:right() or 0
    slot_panel = l_71_0._panel:panel({x = old_right, y = 0, w = quarter_width, h = l_71_0._panel:h(), valign = "grow"})
    l_71_0._player_slots[i] = {}
    l_71_0._player_slots[i].panel = slot_panel
    l_71_0._player_slots[i].outfit = {}
    local kit_menu = managers.menu:get_menu("kit_menu")
    if kit_menu then
      local kit_slot = kit_menu.renderer:get_player_slot_by_peer_id(i)
      if kit_slot then
        local outfit = kit_slot.outfit
        if kit_slot.params then
          local character = kit_slot.params.character
        end
        if outfit and character then
          l_71_0:set_slot_outfit(i, character, outfit)
        end
      end
    end
  end
end

TeamLoadoutItem.reduce_to_small_font = function(l_72_0)
  TeamLoadoutItem.super.reduce_to_small_font(l_72_0)
  for i = 1, 4 do
    if l_72_0._player_slots[i].box then
      l_72_0._player_slots[i].box:create_sides(l_72_0._player_slots[i].panel, {sides = {1, 1, 1, 1}})
    end
  end
end

TeamLoadoutItem.set_slot_outfit = function(l_73_0, l_73_1, l_73_2, l_73_3)
  local player_slot = l_73_0._player_slots[l_73_1]
  if not player_slot then
    return 
  end
  player_slot.panel:clear()
  if not l_73_3 then
    return 
  end
  local slot_h = (player_slot.panel:h())
  local aspect = nil
  local x = player_slot.panel:w() / 2
  local y = player_slot.panel:h() / 14
  local w = slot_h / 5 * 1.1499999761581
  local h = w
  local slot_color = tweak_data.chat_colors[l_73_1]
  local criminal_text = player_slot.panel:text({font_size = tweak_data.menu.pd2_small_font_size, font = tweak_data.menu.pd2_small_font, color = slot_color, x = 10, y = 10, text = utf8.to_upper(CriminalsManager.convert_old_to_new_character_workname(l_73_2) or l_73_2)})
  if l_73_3.primary.factory_id then
    local primary_id = managers.weapon_factory:get_weapon_id_by_factory_id(l_73_3.primary.factory_id)
    local primary_bitmap = player_slot.panel:bitmap({texture = "guis/textures/pd2/blackmarket/icons/weapons/" .. primary_id, w = w, h = h, rotation = math.random(2) - 1.5, alpha = 0.80000001192093})
    aspect = primary_bitmap:texture_width() / math.max(1, primary_bitmap:texture_height())
    primary_bitmap:set_w(primary_bitmap:h() * (aspect))
    primary_bitmap:set_center_x(x)
    primary_bitmap:set_center_y(y * 3)
    local perks = managers.blackmarket:get_perks_from_weapon_blueprint(l_73_3.primary.factory_id, l_73_3.primary.blueprint)
    if table.size(perks) > 0 then
      local perk_index = 0
      for perk in pairs(perks) do
        local perk_object = player_slot.panel:bitmap({texture = "guis/textures/pd2/blackmarket/inv_mod_" .. perk, w = 16, h = 16, rotation = math.random(2) - 1.5, alpha = 0.80000001192093})
        perk_object:set_rightbottom(math.round(primary_bitmap:right() - perk_index * 16), math.round(primary_bitmap:bottom() - 5))
        perk_index = perk_index + 1
      end
    end
  end
  if l_73_3.secondary.factory_id then
    local secondary_id = managers.weapon_factory:get_weapon_id_by_factory_id(l_73_3.secondary.factory_id)
    local secondary_bitmap = player_slot.panel:bitmap({texture = "guis/textures/pd2/blackmarket/icons/weapons/" .. secondary_id, w = w, h = h, rotation = math.random(2) - 1.5, alpha = 0.80000001192093})
    aspect = secondary_bitmap:texture_width() / math.max(1, secondary_bitmap:texture_height())
    secondary_bitmap:set_w(secondary_bitmap:h() * (aspect))
    secondary_bitmap:set_center_x(x)
    secondary_bitmap:set_center_y(y * 6)
    local perks = managers.blackmarket:get_perks_from_weapon_blueprint(l_73_3.secondary.factory_id, l_73_3.secondary.blueprint)
    if table.size(perks) > 0 then
      local perk_index = 0
      for perk in pairs(perks) do
        local perk_object = player_slot.panel:bitmap({texture = "guis/textures/pd2/blackmarket/inv_mod_" .. perk, w = 16, h = 16, rotation = math.random(2) - 1.5, alpha = 0.80000001192093})
        perk_object:set_rightbottom(secondary_bitmap:right() - perk_index * 16, secondary_bitmap:bottom() - 5)
        perk_index = perk_index + 1
      end
    end
  end
  if l_73_3.armor then
    local armor_bitmap = player_slot.panel:bitmap({texture = "guis/textures/pd2/blackmarket/icons/armors/" .. l_73_3.armor, w = w, h = h, rotation = math.random(2) - 1.5, alpha = 0.80000001192093})
    aspect = armor_bitmap:texture_width() / math.max(1, armor_bitmap:texture_height())
    armor_bitmap:set_w(armor_bitmap:h() * (aspect))
    armor_bitmap:set_center_x(x)
    armor_bitmap:set_center_y(y * 9)
  end
  if l_73_3.deployable and l_73_3.deployable ~= "nil" then
    local deployable_bitmap = player_slot.panel:bitmap({texture = "guis/textures/pd2/blackmarket/icons/deployables/" .. l_73_3.deployable, w = w, h = h, rotation = math.random(2) - 1.5, alpha = 0.80000001192093})
    aspect = deployable_bitmap:texture_width() / math.max(1, deployable_bitmap:texture_height())
    deployable_bitmap:set_w(deployable_bitmap:h() * (aspect))
    deployable_bitmap:set_center_x(x)
    deployable_bitmap:set_center_y(y * 12)
  end
  player_slot.box = BoxGuiObject:new(player_slot.panel, {sides = {1, 1, 1, 1}})
end

if not MissionBriefingGui then
  MissionBriefingGui = class()
end
MissionBriefingGui.init = function(l_74_0, l_74_1, l_74_2, l_74_3)
  l_74_0._safe_workspace = l_74_1
  l_74_0._full_workspace = l_74_2
  l_74_0._node = l_74_3
  l_74_0._fullscreen_panel = l_74_0._full_workspace:panel():panel()
  l_74_0._panel = l_74_0._safe_workspace:panel():panel({w = l_74_0._safe_workspace:panel():w() / 2, layer = 6})
  l_74_0._panel:set_right(l_74_0._safe_workspace:panel():w())
  l_74_0._panel:set_top(185 + tweak_data.menu.pd2_medium_font_size)
  l_74_0._panel:grow(0, -l_74_0._panel:top())
  l_74_0._ready = managers.network:session():local_peer():waiting_for_player_ready()
  local ready_text = l_74_0:ready_text()
   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

  l_74_0._ready_button, {name = "ready_button", text = ready_text}.blend_mode, {name = "ready_button", text = ready_text}.layer, {name = "ready_button", text = ready_text}.color, {name = "ready_button", text = ready_text}.font, {name = "ready_button", text = ready_text}.font_size, {name = "ready_button", text = ready_text}.vertical, {name = "ready_button", text = ready_text}.align = l_74_0._panel:text({name = "ready_button", text = ready_text}), "add", 1, tweak_data.screen_colors.button_stage_3, tweak_data.menu.pd2_large_font, tweak_data.menu.pd2_large_font_size, "center", "right"
  local _, _, w, h = l_74_0._ready_button:text_rect()
  l_74_0._ready_button:set_size(w, h)
   -- DECOMPILER ERROR: Confused while interpreting a jump as a 'while'

end
l_74_0._ready_tick_box = l_74_0._panel:bitmap({name = "ready_tickbox", texture = "guis/textures/pd2/mission_briefing/gui_tickbox", layer = 1})
l_74_0._ready_tick_box:set_rightbottom(l_74_0._panel:w(), l_74_0._panel:h())
l_74_0._ready_tick_box:set_image(l_74_0._ready and "guis/textures/pd2/mission_briefing/gui_tickbox_ready" or "guis/textures/pd2/mission_briefing/gui_tickbox")
l_74_0._ready_button:set_center_y(l_74_0._ready_tick_box:center_y())
l_74_0._ready_button:set_right(l_74_0._ready_tick_box:left() - 5)
 -- DECOMPILER ERROR: Confused about usage of registers!

 -- DECOMPILER ERROR: Confused about usage of registers!

 -- DECOMPILER ERROR: Confused about usage of registers!

 -- DECOMPILER ERROR: Confused about usage of registers!

 -- DECOMPILER ERROR: Confused about usage of registers!

 -- DECOMPILER ERROR: Confused about usage of registers!

 -- DECOMPILER ERROR: Confused about usage of registers!

local big_text = l_74_0._fullscreen_panel:text({name = "ready_big_text", text = ready_text})
local _, _, w, h = big_text:text_rect()
big_text:set_size(w, h)
{name = "ready_big_text", text = ready_text}.alpha, {name = "ready_big_text", text = ready_text}.color, {name = "ready_big_text", text = ready_text}.font, {name = "ready_big_text", text = ready_text}.font_size, {name = "ready_big_text", text = ready_text}.vertical, {name = "ready_big_text", text = ready_text}.align, {name = "ready_big_text", text = ready_text}.h = 0.40000000596046, tweak_data.screen_colors.button_stage_3, tweak_data.menu.pd2_massive_font, tweak_data.menu.pd2_massive_font_size, "bottom", "right", 90
local x, y = managers.gui_data:safe_to_full_16_9(managers.gui_data, l_74_0._ready_button:world_right(), l_74_0._ready_button:world_center_y())
big_text:set_world_right(x)
big_text:set_world_center_y(y)
big_text:move(13, -3)
big_text:set_layer(l_74_0._ready_button:layer() - 1)
if MenuBackdropGUI then
  MenuBackdropGUI.animate_bg_text(l_74_0, big_text)
end
WalletGuiObject.set_wallet(l_74_0._safe_workspace:panel(), 10)
local primary_texture = "guis/textures/pd2/endscreen/what_is_this"
local secondary_texture = "guis/textures/pd2/endscreen/what_is_this"
local deployable_texture = "guis/textures/pd2/endscreen/what_is_this"
local armor_texture = "guis/textures/pd2/endscreen/what_is_this"
local empty_string = managers.localization:to_upper_text("menu_loadout_empty")
local primary_string = empty_string
local secondary_string = empty_string
local deployable_string = empty_string
local armor_string = empty_string
local primary_perks = {}
local secondary_perks = {}
local primary = managers.blackmarket:equipped_primary()
local secondary = managers.blackmarket:equipped_secondary()
local deployable = managers.player:equipment_in_slot(1)
local armor = managers.blackmarket:equipped_armor()
if primary then
  primary_texture = "guis/textures/pd2/blackmarket/icons/weapons/" .. tostring(primary.weapon_id)
  primary_string = managers.weapon_factory:get_weapon_name_by_factory_id(primary.factory_id)
  primary_perks = managers.blackmarket:get_perks_from_weapon_blueprint(primary.factory_id, primary.blueprint)
end
if secondary then
  secondary_texture = "guis/textures/pd2/blackmarket/icons/weapons/" .. tostring(secondary.weapon_id)
  secondary_string = managers.weapon_factory:get_weapon_name_by_factory_id(secondary.factory_id)
  secondary_perks = managers.blackmarket:get_perks_from_weapon_blueprint(secondary.factory_id, secondary.blueprint)
end
if deployable then
  deployable_texture = "guis/textures/pd2/blackmarket/icons/deployables/" .. tostring(deployable)
  deployable_string = managers.localization:text(tweak_data.upgrades.definitions[deployable].name_id)
end
if armor then
  armor_texture = "guis/textures/pd2/blackmarket/icons/armors/" .. tostring(armor)
  armor_string = managers.localization:text(tweak_data.blackmarket.armors[armor].name_id)
end
local loadout = {{primary_texture, primary_string, true, primary_perks}, {secondary_texture, secondary_string, true, secondary_perks}, {armor_texture, armor_string, true}, {deployable_texture, deployable_string, true}}
if not l_74_0._node:parameters().menu_component_data then
  l_74_0._node:parameters().menu_component_data = {}
end
if not l_74_0._node:parameters().menu_component_data.asset then
  l_74_0._node:parameters().menu_component_data.asset = {}
end
if not l_74_0._node:parameters().menu_component_data.loadout then
  l_74_0._node:parameters().menu_component_data.loadout = {}
end
local asset_data = l_74_0._node:parameters().menu_component_data.asset
local loadout_data = l_74_0._node:parameters().menu_component_data.loadout
 -- DECOMPILER ERROR: Confused about usage of registers!

 -- DECOMPILER ERROR: Confused about usage of registers!

 -- DECOMPILER ERROR: Confused about usage of registers!

 -- DECOMPILER ERROR: Confused about usage of registers!

 -- DECOMPILER ERROR: Confused about usage of registers!

 -- DECOMPILER ERROR: Confused about usage of registers!

 -- DECOMPILER ERROR: Confused about usage of registers!

if not managers.menu:is_pc_controller() then
  local prev_page = l_74_0._panel:text({name = "tab_text_0", y = 0})
  local _, _, w, h = prev_page:text_rect()
  prev_page:set_size(w, h + 10)
  {name = "tab_text_0", y = 0}.vertical, {name = "tab_text_0", y = 0}.text, {name = "tab_text_0", y = 0}.layer, {name = "tab_text_0", y = 0}.font, {name = "tab_text_0", y = 0}.font_size, {name = "tab_text_0", y = 0}.h, {name = "tab_text_0", y = 0}.w = "top", managers.localization:get_default_macro("BTN_BOTTOM_L"), 2, tweak_data.menu.pd2_medium_font, tweak_data.menu.pd2_medium_font_size, tweak_data.menu.pd2_medium_font_size, 0
  prev_page:set_left(0)
  l_74_0._prev_page = prev_page
end
l_74_0._items = {}
l_74_0._description_item = DescriptionItem:new(l_74_0._panel, utf8.to_upper(managers.localization:text("menu_description")), 1, l_74_0._node:parameters().menu_component_data.saved_descriptions)
table.insert(l_74_0._items, l_74_0._description_item)
l_74_0._assets_item = AssetsItem:new(l_74_0._panel, utf8.to_upper(managers.localization:text("menu_assets")), 2, {}, nil, asset_data)
table.insert(l_74_0._items, l_74_0._assets_item)
l_74_0._loadout_item = LoadoutItem:new(l_74_0._panel, utf8.to_upper(managers.localization:text("menu_loadout")), 3, loadout, loadout_data)
table.insert(l_74_0._items, l_74_0._loadout_item)
if not Global.game_settings.single_player then
  l_74_0._team_loadout_item = TeamLoadoutItem:new(l_74_0._panel, utf8.to_upper(managers.localization:text("menu_team_loadout")), 4)
  table.insert(l_74_0._items, l_74_0._team_loadout_item)
end
local max_x = l_74_0._panel:w()
 -- DECOMPILER ERROR: Confused about usage of registers!

 -- DECOMPILER ERROR: Confused about usage of registers!

 -- DECOMPILER ERROR: Confused about usage of registers!

 -- DECOMPILER ERROR: Confused about usage of registers!

 -- DECOMPILER ERROR: Confused about usage of registers!

 -- DECOMPILER ERROR: Confused about usage of registers!

 -- DECOMPILER ERROR: Confused about usage of registers!

if not managers.menu:is_pc_controller() then
  local next_page = l_74_0._panel:text({name = "tab_text_" .. tostring(#l_74_0._items + 1), y = 0})
  local _, _, w, h = next_page:text_rect()
  next_page:set_size(w, h + 10)
  {name = "tab_text_" .. tostring(#l_74_0._items + 1), y = 0}.vertical, {name = "tab_text_" .. tostring(#l_74_0._items + 1), y = 0}.text, {name = "tab_text_" .. tostring(#l_74_0._items + 1), y = 0}.layer, {name = "tab_text_" .. tostring(#l_74_0._items + 1), y = 0}.font, {name = "tab_text_" .. tostring(#l_74_0._items + 1), y = 0}.font_size, {name = "tab_text_" .. tostring(#l_74_0._items + 1), y = 0}.h, {name = "tab_text_" .. tostring(#l_74_0._items + 1), y = 0}.w = "top", managers.localization:get_default_macro("BTN_BOTTOM_R"), 2, tweak_data.menu.pd2_medium_font, tweak_data.menu.pd2_medium_font_size, tweak_data.menu.pd2_medium_font_size, 0
  next_page:set_right(l_74_0._panel:w())
  l_74_0._next_page = next_page
  max_x = next_page:left() - 5
end
if max_x < l_74_0._items[#l_74_0._items]._tab_text:right() then
  for i,tab in ipairs(l_74_0._items) do
    tab:reduce_to_small_font()
  end
end
l_74_0._selected_item = 0
l_74_0:set_tab(l_74_0._node:parameters().menu_component_data.selected_tab, true)
local box_panel = l_74_0._panel:panel()
box_panel:set_shape(l_74_0._items[l_74_0._selected_item]:panel():shape())
BoxGuiObject:new(box_panel, {sides = {1, 1, 2, 1}})
if managers.assets:is_all_textures_loaded() then
  l_74_0:create_asset_tab()
end
l_74_0._items[l_74_0._selected_item]:select(true)
l_74_0._enabled = true
l_74_0:flash_ready()
end

MissionBriefingGui.update = function(l_75_0, l_75_1, l_75_2)
  if not alive(l_75_0._panel) or not alive(l_75_0._fullscreen_panel) or not l_75_0._enabled then
    return 
  end
  if l_75_0._displaying_asset then
    return 
  end
  if game_state_machine:current_state().blackscreen_started and game_state_machine:current_state():blackscreen_started() then
    return 
  end
  if l_75_0._items[l_75_0._selected_item] then
    l_75_0._items[l_75_0._selected_item]:update(l_75_1, l_75_2)
  end
end

MissionBriefingGui.ready_text = function(l_76_0)
  local legend = not managers.menu:is_pc_controller() and managers.localization:get_default_macro("BTN_Y") or ""
  return legend .. utf8.to_upper(managers.localization:text("menu_waiting_is_ready"))
end

MissionBriefingGui.flash_ready = function(l_77_0)
  if l_77_0._ready then
    return 
  end
  l_77_0._next_ready_flash = l_77_0._next_ready_flash or 0
  if TimerManager:main():time() < l_77_0._next_ready_flash then
    return 
  end
  l_77_0._next_ready_flash = TimerManager:main():time() + 3
  local animate_flash_ready = function(l_1_0)
    local center_x, center_y = l_1_0:center()
    local font_size = l_1_0:font_size()
    local color = l_1_0:color()
    over(0.14000000059605, function(l_1_0)
      o:set_color(math.lerp(color, tweak_data.screen_colors.important_1, l_1_0))
      o:set_font_size(font_size + 1 * l_1_0)
      o:set_rotation(math.sin(l_1_0 * 360) * 0.20000000298023)
      if o:rotation() == 0 then
        o:set_rotation(0.10000000149012)
      end
      end)
    wait(0.0099999997764826)
    over(0.14000000059605, function(l_2_0)
      o:set_color(math.lerp(tweak_data.screen_colors.important_1, color, l_2_0))
      o:set_font_size(font_size + 1 * (1 - l_2_0))
      o:set_rotation(math.sin((1 - l_2_0) * 360) * 0.20000000298023)
      if o:rotation() == 0 then
        o:set_rotation(0.0099999997764826)
      end
      end)
    l_1_0:set_color(color)
    l_1_0:set_font_size(font_size)
    l_1_0:set_rotation(0)
   end
  l_77_0._ready_button:animate(animate_flash_ready)
end

MissionBriefingGui.open_asset_buy = function(l_78_0, l_78_1, l_78_2)
  local params = {}
  params.asset_id = l_78_2
  params.yes_func = callback(l_78_0, l_78_0, "_buy_asset_callback", l_78_2)
  managers.menu:show_confirm_mission_asset_buy(params)
end

MissionBriefingGui._buy_asset_callback = function(l_79_0, l_79_1)
  managers.assets:unlock_asset(l_79_1)
end

MissionBriefingGui.unlock_asset = function(l_80_0, l_80_1)
  l_80_0._assets_item:unlock_asset_by_id(l_80_1)
end

MissionBriefingGui.create_asset_tab = function(l_81_0)
  local asset_ids = managers.assets:get_all_asset_ids(true)
  local assets_names = {}
  if #asset_ids > 0 then
    l_81_0._fullscreen_asset_background_h = l_81_0._fullscreen_panel:gradient({name = "asset_background_h", layer = 99, orientation = "horizontal", color = Color.black:with_alpha(0.10000000149012)})
    l_81_0._fullscreen_asset_background_h:add_gradient_point(0.25, Color.black:with_alpha(0.5))
    l_81_0._fullscreen_asset_background_h:add_gradient_point(0.75, Color.black:with_alpha(0.5))
    l_81_0._fullscreen_asset_background_h:add_gradient_point(0.5, Color.black:with_alpha(0.75))
    l_81_0._fullscreen_asset_background_v = l_81_0._fullscreen_panel:gradient({name = "asset_background_v", layer = 99, orientation = "vertical", color = Color.black:with_alpha(0.10000000149012)})
    l_81_0._fullscreen_asset_background_v:add_gradient_point(0.25, Color.black:with_alpha(0.5))
    l_81_0._fullscreen_asset_background_v:add_gradient_point(0.75, Color.black:with_alpha(0.5))
    l_81_0._fullscreen_asset_background_v:add_gradient_point(0.5, Color.black:with_alpha(0.75))
    l_81_0._fullscreen_asset_background_v:hide()
    l_81_0._fullscreen_asset_background_h:hide()
    l_81_0._fullscreen_assets_list = {}
    for i,asset_id in ipairs(asset_ids) do
      local asset_tweak_data = managers.assets:get_asset_tweak_data_by_id(asset_id)
       -- DECOMPILER ERROR: Overwrote pending register.

       -- DECOMPILER ERROR: Overwrote pending register.

       -- DECOMPILER ERROR: Overwrote pending register.

       -- DECOMPILER ERROR: Overwrote pending register.

      local asset = l_81_0._fullscreen_panel:bitmap({name = managers.assets:get_asset_unlocked_by_id(asset_id) .. asset_id(managers.assets:get_asset_can_unlock_by_id(asset_id)), texture = assets_names[i][1], w = 512, h = 512, layer = 100})
      local aspect = asset:texture_width() / math.max(asset:texture_height(), 1)
      local size = math.max(asset:texture_height(), l_81_0._panel:h())
       -- DECOMPILER ERROR: Overwrote pending register.

      asset:set_size(size * aspect, managers.assets:get_asset_no_mystery_by_id(asset_id))
      assets_names[i] = {}
      asset:set_center(l_81_0._fullscreen_panel:w() / 2, l_81_0._fullscreen_panel:h() / 2)
      asset:hide()
      table.insert(l_81_0._fullscreen_assets_list, asset)
    end
    l_81_0._assets_item:create_assets(assets_names)
  end
end

MissionBriefingGui.open_asset = function(l_82_0, l_82_1)
  l_82_0._displaying_asset = l_82_1
  local fullscreen_asset = l_82_0._fullscreen_assets_list[l_82_0._displaying_asset]
  if fullscreen_asset and alive(fullscreen_asset) then
    local animate_show = function(l_1_0)
    local start_alpha = l_1_0:alpha()
    over(0.10000000149012, function(l_1_0)
      o:set_alpha(math.lerp(start_alpha, 1, l_1_0))
      end)
   end
    fullscreen_asset:show()
    fullscreen_asset:stop()
    fullscreen_asset:animate(animate_show)
    l_82_0._fullscreen_asset_zoom = 1
    local cx, cy = fullscreen_asset:center()
    l_82_0._fullscreen_asset_background_v:show()
    l_82_0._fullscreen_asset_background_v:stop()
    l_82_0._fullscreen_asset_background_v:animate(animate_show)
    l_82_0._fullscreen_asset_background_h:show()
    l_82_0._fullscreen_asset_background_h:stop()
    l_82_0._fullscreen_asset_background_h:animate(animate_show)
    managers.menu_component:post_event("menu_enter")
  else
    l_82_0._displaying_asset = nil
  end
end

MissionBriefingGui.close_asset = function(l_83_0)
  if not l_83_0._fullscreen_assets_list then
    return 
  end
  local fullscreen_asset = l_83_0._fullscreen_assets_list[l_83_0._displaying_asset]
  if fullscreen_asset and alive(fullscreen_asset) then
    local animate_hide = function(l_1_0)
    local start_alpha = l_1_0:alpha()
    over(0.050000000745058, function(l_1_0)
      o:set_alpha(math.lerp(start_alpha, 0, l_1_0))
      end)
    l_1_0:hide()
   end
    fullscreen_asset:stop()
    fullscreen_asset:animate(animate_hide)
    l_83_0._fullscreen_asset_background_v:stop()
    l_83_0._fullscreen_asset_background_v:animate(animate_hide)
    l_83_0._fullscreen_asset_background_h:stop()
    l_83_0._fullscreen_asset_background_h:animate(animate_hide)
  end
  l_83_0._displaying_asset = nil
end

MissionBriefingGui.zoom_asset = function(l_84_0, l_84_1)
  local fullscreen_asset = l_84_0._fullscreen_assets_list[l_84_0._displaying_asset]
  if not fullscreen_asset or not alive(fullscreen_asset) then
    return 
  end
  if l_84_1 == "in" then
    l_84_0._fullscreen_asset_zoom = math.min(l_84_0._fullscreen_asset_zoom + 0.10000000149012, 1.5)
  elseif l_84_1 == "out" then
    l_84_0._fullscreen_asset_zoom = math.max(l_84_0._fullscreen_asset_zoom - 0.10000000149012, 0.5)
  end
  local cx, cy = fullscreen_asset:center()
end

MissionBriefingGui.next_tab = function(l_85_0, l_85_1)
  local new_selected_item = l_85_0._selected_item + 1
  return l_85_0:set_tab(new_selected_item, l_85_1)
end

MissionBriefingGui.prev_tab = function(l_86_0, l_86_1)
  local new_selected_item = l_86_0._selected_item - 1
  return l_86_0:set_tab(new_selected_item, l_86_1)
end

MissionBriefingGui.set_tab = function(l_87_0, l_87_1, l_87_2)
  if l_87_0._selected_item == l_87_1 then
    return 
  end
  l_87_1 = math.clamp(l_87_1, 1, #l_87_0._items)
  if l_87_0._selected_item ~= l_87_1 then
    if l_87_0._items[l_87_0._selected_item] then
      l_87_0._items[l_87_0._selected_item]:deselect()
    end
    l_87_0._selected_item = l_87_1
    l_87_0._items[l_87_0._selected_item]:select(l_87_2)
    l_87_0._node:parameters().menu_component_data.selected_tab = l_87_0._selected_item
    if l_87_0._selected_item <= 1 then
      l_87_0._prev_page:set_visible(not l_87_0._prev_page)
    end
    if l_87_0._selected_item >= #l_87_0._items then
      l_87_0._next_page:set_visible(not l_87_0._next_page)
    end
  end
  return l_87_0._selected_item
end

MissionBriefingGui.mouse_pressed = function(l_88_0, l_88_1, l_88_2, l_88_3)
  if not alive(l_88_0._panel) or not alive(l_88_0._fullscreen_panel) or not l_88_0._enabled then
    return 
  end
  if game_state_machine:current_state().blackscreen_started and game_state_machine:current_state():blackscreen_started() then
    return 
  end
  if l_88_0._displaying_asset then
    if l_88_1 == Idstring("mouse wheel down") then
      l_88_0:zoom_asset("out")
      return 
    else
      if l_88_1 == Idstring("mouse wheel up") then
        l_88_0:zoom_asset("in")
        return 
      end
    end
    l_88_0:close_asset()
    return 
  end
  if l_88_1 == Idstring("mouse wheel down") then
    l_88_0:next_tab(true)
    return 
  else
    if l_88_1 == Idstring("mouse wheel up") then
      l_88_0:prev_tab(true)
      return 
    end
  end
  if l_88_1 ~= Idstring("0") then
    return 
  end
  for index,tab in ipairs(l_88_0._items) do
    local pressed, cost = tab:mouse_pressed(l_88_1, l_88_2, l_88_3)
    if pressed == true then
      l_88_0:set_tab(index)
      for (for control),index in (for generator) do
      end
       -- DECOMPILER ERROR: unhandled construct in 'if'

      if type(pressed) == "number" and cost and type(cost) == "number" then
        l_88_0:open_asset_buy(pressed, tab:get_asset_id(pressed))
        for (for control),index in (for generator) do
          l_88_0:open_asset(pressed)
        end
      end
      if l_88_0._ready_button:inside(l_88_2, l_88_3) or l_88_0._ready_tick_box:inside(l_88_2, l_88_3) then
        l_88_0:on_ready_pressed()
      end
      return l_88_0._selected_item
       -- Warning: missing end command somewhere! Added here
    end
     -- Warning: missing end command somewhere! Added here
  end
end

MissionBriefingGui.mouse_moved = function(l_89_0, l_89_1, l_89_2)
  if not alive(l_89_0._panel) or not alive(l_89_0._fullscreen_panel) or not l_89_0._enabled then
    return 
  end
  if l_89_0._displaying_asset then
    return 
  end
  if game_state_machine:current_state().blackscreen_started and game_state_machine:current_state():blackscreen_started() then
    return 
  end
  for _,tab in ipairs(l_89_0._items) do
    tab:mouse_moved(l_89_1, l_89_2)
  end
  if (l_89_0._ready_button:inside(l_89_1, l_89_2) or l_89_0._ready_tick_box:inside(l_89_1, l_89_2)) and not l_89_0._ready_highlighted then
    l_89_0._ready_highlighted = true
    l_89_0._ready_button:set_color(tweak_data.screen_colors.button_stage_2)
    managers.menu_component:post_event("highlight")
    do return end
    if l_89_0._ready_highlighted then
      l_89_0._ready_button:set_color(tweak_data.screen_colors.button_stage_3)
      l_89_0._ready_highlighted = false
    end
  end
  if managers.hud._hud_mission_briefing and managers.hud._hud_mission_briefing._backdrop then
    managers.hud._hud_mission_briefing._backdrop:mouse_moved(l_89_1, l_89_2)
  end
end

MissionBriefingGui.set_description_text_id = function(l_90_0, l_90_1)
  if not l_90_0._node:parameters().menu_component_data.saved_descriptions then
    l_90_0._node:parameters().menu_component_data.saved_descriptions = {}
  end
  table.insert(l_90_0._node:parameters().menu_component_data.saved_descriptions, l_90_1)
  l_90_0:add_description_text(managers.localization:text(l_90_1))
end

MissionBriefingGui.add_description_text = function(l_91_0, l_91_1)
  l_91_0._description_item:add_description_text(l_91_1)
end

MissionBriefingGui.set_description_text = function(l_92_0, l_92_1)
  l_92_0._description_item:set_description_text(l_92_1)
end

MissionBriefingGui.set_slot_outfit = function(l_93_0, l_93_1, l_93_2, l_93_3)
  if l_93_0._team_loadout_item then
    l_93_0._team_loadout_item:set_slot_outfit(l_93_1, l_93_2, l_93_3)
  end
end

MissionBriefingGui.on_ready_pressed = function(l_94_0, l_94_1)
  if not managers.network:session() then
    return 
  end
  if l_94_1 ~= nil then
    l_94_0._ready = l_94_1
  else
    l_94_0._ready = not l_94_0._ready
  end
  managers.network:session():local_peer():set_waiting_for_player_ready(l_94_0._ready)
  managers.network:session():chk_send_local_player_ready()
  managers.network:game():on_set_member_ready(managers.network:session():local_peer():id(), l_94_0._ready)
  local ready_text = l_94_0:ready_text()
  l_94_0._ready_button:set_text(ready_text)
  l_94_0._fullscreen_panel:child("ready_big_text"):set_text(ready_text)
  l_94_0._ready_tick_box:set_image(l_94_0._ready and "guis/textures/pd2/mission_briefing/gui_tickbox_ready" or "guis/textures/pd2/mission_briefing/gui_tickbox")
  if l_94_0._ready then
    managers.menu_component:post_event("box_tick")
  else
    managers.menu_component:post_event("box_untick")
  end
end

MissionBriefingGui.input_focus = function(l_95_0)
  if not l_95_0._displaying_asset or not 1 then
    return l_95_0._enabled
  end
end

MissionBriefingGui.scroll_up = function(l_96_0)
  print("MissionBriefingGui:scroll_up")
  if not alive(l_96_0._panel) or not alive(l_96_0._fullscreen_panel) or not l_96_0._enabled then
    return 
  end
  if l_96_0._displaying_asset then
    return 
  end
  if l_96_0._items[l_96_0._selected_item] then
    l_96_0._items[l_96_0._selected_item]:move_right()
  end
end

MissionBriefingGui.scroll_down = function(l_97_0)
  print("MissionBriefingGui:scroll_down")
  if not alive(l_97_0._panel) or not alive(l_97_0._fullscreen_panel) or not l_97_0._enabled then
    return 
  end
  if l_97_0._displaying_asset then
    return 
  end
  if l_97_0._items[l_97_0._selected_item] then
    l_97_0._items[l_97_0._selected_item]:move_left()
  end
end

MissionBriefingGui.move_up = function(l_98_0)
  if not alive(l_98_0._panel) or not alive(l_98_0._fullscreen_panel) or not l_98_0._enabled then
    return 
  end
  if l_98_0._displaying_asset then
    return 
  end
  if game_state_machine:current_state().blackscreen_started and game_state_machine:current_state():blackscreen_started() then
    return 
  end
  if l_98_0._items[l_98_0._selected_item] then
    l_98_0._items[l_98_0._selected_item]:move_up()
  end
end

MissionBriefingGui.move_down = function(l_99_0)
  if not alive(l_99_0._panel) or not alive(l_99_0._fullscreen_panel) or not l_99_0._enabled then
    return 
  end
  if l_99_0._displaying_asset then
    return 
  end
  if game_state_machine:current_state().blackscreen_started and game_state_machine:current_state():blackscreen_started() then
    return 
  end
  if l_99_0._items[l_99_0._selected_item] then
    l_99_0._items[l_99_0._selected_item]:move_down()
  end
end

MissionBriefingGui.move_left = function(l_100_0)
  if not alive(l_100_0._panel) or not alive(l_100_0._fullscreen_panel) or not l_100_0._enabled then
    return 
  end
  if l_100_0._displaying_asset then
    return 
  end
  if game_state_machine:current_state().blackscreen_started and game_state_machine:current_state():blackscreen_started() then
    return 
  end
  if l_100_0._items[l_100_0._selected_item] then
    l_100_0._items[l_100_0._selected_item]:move_left()
  end
end

MissionBriefingGui.move_right = function(l_101_0)
  if not alive(l_101_0._panel) or not alive(l_101_0._fullscreen_panel) or not l_101_0._enabled then
    return 
  end
  if l_101_0._displaying_asset then
    return 
  end
  if game_state_machine:current_state().blackscreen_started and game_state_machine:current_state():blackscreen_started() then
    return 
  end
  if l_101_0._items[l_101_0._selected_item] then
    l_101_0._items[l_101_0._selected_item]:move_right()
  end
end

MissionBriefingGui.confirm_pressed = function(l_102_0)
  if not alive(l_102_0._panel) or not alive(l_102_0._fullscreen_panel) or not l_102_0._enabled then
    return false
  end
  if l_102_0._displaying_asset then
    l_102_0:close_asset()
    return true
  end
  if game_state_machine:current_state().blackscreen_started and game_state_machine:current_state():blackscreen_started() then
    return false
  end
  if l_102_0._items[l_102_0._selected_item] then
    local selected, cost = l_102_0._items[l_102_0._selected_item]:confirm_pressed()
     -- DECOMPILER ERROR: unhandled construct in 'if'

    if selected and type(selected) == "number" and cost and type(cost) == "number" then
      l_102_0:open_asset_buy(selected, l_102_0._items[l_102_0._selected_item]:get_asset_id(selected))
      return true
      do return end
      l_102_0:open_asset(selected)
      return true
      do return end
      if selected then
        return false
      end
    end
  end
  if managers.menu:is_pc_controller() then
    l_102_0:on_ready_pressed()
    return true
  end
  return false
end

MissionBriefingGui.back_pressed = function(l_103_0)
  if not alive(l_103_0._panel) or not alive(l_103_0._fullscreen_panel) or not l_103_0._enabled then
    return false
  end
  if game_state_machine:current_state().blackscreen_started and game_state_machine:current_state():blackscreen_started() then
    return false
  end
  if l_103_0._displaying_asset then
    l_103_0:close_asset()
    return true
  end
  return false
end

MissionBriefingGui.special_btn_pressed = function(l_104_0, l_104_1)
  if not alive(l_104_0._panel) or not alive(l_104_0._fullscreen_panel) or not l_104_0._enabled then
    return false
  end
  if l_104_0._displaying_asset then
    l_104_0:close_asset()
    return false
  end
  if game_state_machine:current_state().blackscreen_started and game_state_machine:current_state():blackscreen_started() then
    return false
  end
  if l_104_1 == Idstring("menu_toggle_ready") then
    l_104_0:on_ready_pressed()
    return true
  end
  return false
end

MissionBriefingGui.accept_input = function(l_105_0, l_105_1)
  print("MissionBriefingGui:accept_input", l_105_1)
end

MissionBriefingGui.next_page = function(l_106_0)
  if not alive(l_106_0._panel) or not alive(l_106_0._fullscreen_panel) or not l_106_0._enabled then
    return 
  end
  if l_106_0._displaying_asset then
    return 
  end
  if game_state_machine:current_state().blackscreen_started and game_state_machine:current_state():blackscreen_started() then
    return 
  end
  l_106_0:next_tab(false)
end

MissionBriefingGui.previous_page = function(l_107_0)
  if not alive(l_107_0._panel) or not alive(l_107_0._fullscreen_panel) or not l_107_0._enabled then
    return 
  end
  if l_107_0._displaying_asset then
    return 
  end
  if game_state_machine:current_state().blackscreen_started and game_state_machine:current_state():blackscreen_started() then
    return 
  end
  l_107_0:prev_tab(false)
end

MissionBriefingGui.hide = function(l_108_0)
  l_108_0._enabled = false
  l_108_0:close_asset()
  l_108_0._panel:set_alpha(0.5)
  l_108_0._fullscreen_panel:set_alpha(0.5)
end

MissionBriefingGui.show = function(l_109_0)
  l_109_0._enabled = true
  l_109_0._panel:set_alpha(1)
  l_109_0._fullscreen_panel:set_alpha(1)
end

MissionBriefingGui.close = function(l_110_0)
  WalletGuiObject.close_wallet(l_110_0._safe_workspace:panel())
  if l_110_0._panel and alive(l_110_0._panel) then
    l_110_0._panel:parent():remove(l_110_0._panel)
  end
  if l_110_0._fullscreen_panel and alive(l_110_0._fullscreen_panel) then
    l_110_0._fullscreen_panel:parent():remove(l_110_0._fullscreen_panel)
  end
end

MissionBriefingGui.reload_loadout = function(l_111_0)
  local primary_texture = "guis/textures/pd2/endscreen/what_is_this"
  local secondary_texture = "guis/textures/pd2/endscreen/what_is_this"
  local deployable_texture = "guis/textures/pd2/endscreen/what_is_this"
  local armor_texture = "guis/textures/pd2/endscreen/what_is_this"
  local empty_string = managers.localization:to_upper_text("menu_loadout_empty")
  local primary_string = empty_string
  local secondary_string = empty_string
  local deployable_string = empty_string
  local armor_string = empty_string
  local primary_perks = {}
  local secondary_perks = {}
  local primary = managers.blackmarket:equipped_primary()
  local secondary = managers.blackmarket:equipped_secondary()
  local deployable = managers.player:equipment_in_slot(1)
  local armor = managers.blackmarket:equipped_armor()
  if primary then
    primary_texture = "guis/textures/pd2/blackmarket/icons/weapons/" .. tostring(primary.weapon_id)
    primary_string = managers.weapon_factory:get_weapon_name_by_factory_id(primary.factory_id)
    primary_perks = managers.blackmarket:get_perks_from_weapon_blueprint(primary.factory_id, primary.blueprint)
  end
  if secondary then
    secondary_texture = "guis/textures/pd2/blackmarket/icons/weapons/" .. tostring(secondary.weapon_id)
    secondary_string = managers.weapon_factory:get_weapon_name_by_factory_id(secondary.factory_id)
    secondary_perks = managers.blackmarket:get_perks_from_weapon_blueprint(secondary.factory_id, secondary.blueprint)
  end
  if deployable then
    deployable_texture = "guis/textures/pd2/blackmarket/icons/deployables/" .. tostring(deployable)
    deployable_string = managers.localization:text(tweak_data.upgrades.definitions[deployable].name_id)
  end
  if armor then
    armor_texture = "guis/textures/pd2/blackmarket/icons/armors/" .. tostring(armor)
    armor_string = managers.localization:text(tweak_data.blackmarket.armors[armor].name_id)
  end
  local loadout = {{primary_texture, primary_string, true, primary_perks}, {secondary_texture, secondary_string, true, secondary_perks}, {armor_texture, armor_string, true}, {deployable_texture, deployable_string, true}}
  if not l_111_0._node:parameters().menu_component_data then
    l_111_0._node:parameters().menu_component_data = {}
  end
  if not l_111_0._node:parameters().menu_component_data.loadout then
    l_111_0._node:parameters().menu_component_data.loadout = {}
  end
  local loadout_data = l_111_0._node:parameters().menu_component_data.loadout
  if SystemInfo:platform() == Idstring("X360") then
    if loadout_data.changing_loadout == "primary" and loadout_data.current_slot ~= managers.blackmarket:equipped_weapon_slot("primaries") then
      managers.blackmarket:preload_primary_weapon()
    elseif loadout_data.changing_loadout == "secondary" and loadout_data.current_slot ~= managers.blackmarket:equipped_weapon_slot("secondaries") then
      managers.blackmarket:preload_secondary_weapon()
    end
  end
  loadout_data.changing_loadout = nil
  loadout_data.current_slot = nil
  l_111_0._loadout_item:destroy()
  l_111_0._loadout_item = nil
  l_111_0._items[3] = nil
  l_111_0._loadout_item = LoadoutItem:new(l_111_0._panel, utf8.to_upper(managers.localization:text("menu_loadout")), 3, loadout, loadout_data)
  l_111_0._items[3] = l_111_0._loadout_item
  l_111_0:set_tab(l_111_0._node:parameters().menu_component_data.selected_tab, true)
  l_111_0._items[l_111_0._selected_item]:select(true)
  WalletGuiObject.set_wallet(l_111_0._safe_workspace:panel(), 10)
end

MissionBriefingGui.reload = function(l_112_0)
  l_112_0:close()
  MissionBriefingGui.init(l_112_0, l_112_0._safe_workspace, l_112_0._full_workspace, l_112_0._node)
end


