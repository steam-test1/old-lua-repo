-- Decompiled using luadec 2.0.1 by sztupy (http://winmo.sztupy.hu)
-- Command line was: F:\SteamLibrary\SteamApps\common\PAYDAY 2\lua\lib\managers\menu\menurenderer.luac 

core:import("CoreMenuRenderer")
require("lib/managers/menu/MenuNodeGui")
require("lib/managers/menu/renderers/MenuNodeTableGui")
require("lib/managers/menu/renderers/MenuNodeStatsGui")
require("lib/managers/menu/renderers/MenuNodeCreditsGui")
require("lib/managers/menu/renderers/MenuNodeButtonLayoutGui")
require("lib/managers/menu/renderers/MenuNodeHiddenGui")
require("lib/managers/menu/renderers/MenuNodeCrimenetGui")
if not MenuRenderer then
  MenuRenderer = class(CoreMenuRenderer.Renderer)
end
MenuRenderer.init = function(l_1_0, l_1_1, ...)
  MenuRenderer.super.init(l_1_0, l_1_1, ...)
  l_1_0._sound_source = SoundDevice:create_source("MenuRenderer")
   -- DECOMPILER ERROR: Confused about usage of registers for local variables.

end

MenuRenderer.show_node = function(l_2_0, l_2_1)
  local gui_class = MenuNodeGui
  if l_2_1:parameters().gui_class then
    gui_class = CoreSerialize.string_to_classtable(l_2_1:parameters().gui_class)
  end
  {font = tweak_data.menu.pd2_medium_font, row_item_color = tweak_data.screen_colors.button_stage_3, row_item_hightlight_color = tweak_data.screen_colors.button_stage_2, row_item_blend_mode = "add", font_size = tweak_data.menu.pd2_medium_font_size, node_gui_class = gui_class}.spacing = l_2_1:parameters().spacing
   -- DECOMPILER ERROR: Confused about usage of registers!

  {font = tweak_data.menu.pd2_medium_font, row_item_color = tweak_data.screen_colors.button_stage_3, row_item_hightlight_color = tweak_data.screen_colors.button_stage_2, row_item_blend_mode = "add", font_size = tweak_data.menu.pd2_medium_font_size, node_gui_class = gui_class}.marker_alpha = 0.60000002384186
   -- DECOMPILER ERROR: Confused about usage of registers!

  {font = tweak_data.menu.pd2_medium_font, row_item_color = tweak_data.screen_colors.button_stage_3, row_item_hightlight_color = tweak_data.screen_colors.button_stage_2, row_item_blend_mode = "add", font_size = tweak_data.menu.pd2_medium_font_size, node_gui_class = gui_class}.marker_color = tweak_data.screen_colors.button_stage_3:with_alpha(0.20000000298023)
   -- DECOMPILER ERROR: Confused about usage of registers!

  {font = tweak_data.menu.pd2_medium_font, row_item_color = tweak_data.screen_colors.button_stage_3, row_item_hightlight_color = tweak_data.screen_colors.button_stage_2, row_item_blend_mode = "add", font_size = tweak_data.menu.pd2_medium_font_size, node_gui_class = gui_class}.align = "right"
   -- DECOMPILER ERROR: Confused about usage of registers!

  {font = tweak_data.menu.pd2_medium_font, row_item_color = tweak_data.screen_colors.button_stage_3, row_item_hightlight_color = tweak_data.screen_colors.button_stage_2, row_item_blend_mode = "add", font_size = tweak_data.menu.pd2_medium_font_size, node_gui_class = gui_class}.to_upper = true
  do
     -- DECOMPILER ERROR: Confused at declaration of local variable

     -- DECOMPILER ERROR: Confused about usage of registers!

    MenuRenderer.super.show_node(l_2_0, l_2_1, {font = tweak_data.menu.pd2_medium_font, row_item_color = tweak_data.screen_colors.button_stage_3, row_item_hightlight_color = tweak_data.screen_colors.button_stage_2, row_item_blend_mode = "add", font_size = tweak_data.menu.pd2_medium_font_size, node_gui_class = gui_class})
  end
   -- DECOMPILER ERROR: Confused about usage of registers for local variables.

end

MenuRenderer.open = function(l_3_0, ...)
  MenuRenderer.super.open(l_3_0, ...)
  l_3_0:_create_framing()
  l_3_0._menu_stencil_align = "left"
  l_3_0._menu_stencil_default_image = "guis/textures/empty"
  l_3_0._menu_stencil_image = l_3_0._menu_stencil_default_image
  l_3_0:_layout_menu_bg()
   -- DECOMPILER ERROR: Confused about usage of registers for local variables.

end

MenuRenderer._create_framing = function(l_4_0)
  local bh = CoreMenuRenderer.Renderer.border_height
  local scaled_size = managers.gui_data:scaled_size()
  l_4_0._bottom_line = l_4_0._main_panel:bitmap({texture = "guis/textures/headershadow", rotation = 180, layer = 1, color = Color.white:with_alpha(0), alpha = 0, w = scaled_size.width, y = scaled_size.height - bh, blend_mode = "add"})
  l_4_0._bottom_line:hide()
  MenuRenderer._create_bottom_text(l_4_0)
end

MenuRenderer._create_bottom_text = function(l_5_0)
  local scaled_size = managers.gui_data:scaled_size()
   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

  l_5_0._bottom_text, {text = "", wrap = true, word_wrap = true, font_size = tweak_data.menu.pd2_small_font_size, align = "right", halign = "right"}.layer, {text = "", wrap = true, word_wrap = true, font_size = tweak_data.menu.pd2_small_font_size, align = "right", halign = "right"}.w, {text = "", wrap = true, word_wrap = true, font_size = tweak_data.menu.pd2_small_font_size, align = "right", halign = "right"}.font, {text = "", wrap = true, word_wrap = true, font_size = tweak_data.menu.pd2_small_font_size, align = "right", halign = "right"}.hvertical, {text = "", wrap = true, word_wrap = true, font_size = tweak_data.menu.pd2_small_font_size, align = "right", halign = "right"}.vertical = l_5_0._main_panel:text({text = "", wrap = true, word_wrap = true, font_size = tweak_data.menu.pd2_small_font_size, align = "right", halign = "right"}), 2, scaled_size.width * 0.66000002622604, tweak_data.menu.pd2_small_font, "top", "top"
  l_5_0._bottom_text:set_right(l_5_0._bottom_text:parent():w())
end

MenuRenderer.set_bottom_text = function(l_6_0, l_6_1)
  if not alive(l_6_0._bottom_text) then
    return 
  end
  if not l_6_1 then
    l_6_0._bottom_text:set_text("")
    return 
  end
  l_6_0._bottom_text:set_text(utf8.to_upper(managers.localization:text(l_6_1)))
  local _, _, _, h = l_6_0._bottom_text:text_rect()
  l_6_0._bottom_text:set_h(h)
end

MenuRenderer.close = function(l_7_0, ...)
  MenuRenderer.super.close(l_7_0, ...)
  managers.menu_component:close_newsfeed_gui()
   -- DECOMPILER ERROR: Confused about usage of registers for local variables.

end

MenuRenderer._layout_menu_bg = function(l_8_0)
  local res = RenderSettings.resolution
  local safe_rect_pixels = managers.gui_data:scaled_size()
  l_8_0:set_stencil_align(l_8_0._menu_stencil_align, l_8_0._menu_stencil_align_percent)
end

MenuRenderer.update = function(l_9_0, l_9_1, l_9_2)
  MenuRenderer.super.update(l_9_0, l_9_1, l_9_2)
end

local mugshot_stencil = {random = {"bg_lobby_fullteam", 65}, undecided = {"bg_lobby_fullteam", 65}, american = {"bg_hoxton", 65}, german = {"bg_wolf", 55}, russian = {"bg_dallas", 65}, spanish = {"bg_chains", 60}}
MenuRenderer.highlight_item = function(l_10_0, l_10_1, ...)
  MenuRenderer.super.highlight_item(l_10_0, l_10_1, ...)
  if l_10_0:active_node_gui().name == "play_single_player" then
    local character = managers.network:session():local_peer():character()
    managers.menu:active_menu().renderer:set_stencil_image(mugshot_stencil[character][1])
    managers.menu:active_menu().renderer:set_stencil_align("manual", mugshot_stencil[character][2])
  end
  l_10_0:post_event("highlight")
   -- DECOMPILER ERROR: Confused about usage of registers for local variables.

end

MenuRenderer.trigger_item = function(l_11_0, l_11_1)
  MenuRenderer.super.trigger_item(l_11_0, l_11_1)
  if l_11_1 and l_11_1:visible() and l_11_1:parameters().sound ~= "false" then
    local item_type = l_11_1:type()
    if item_type == "" then
      l_11_0:post_event("menu_enter")
    elseif item_type == "toggle" then
      if l_11_1:value() == "on" then
        l_11_0:post_event("box_tick")
      else
        l_11_0:post_event("box_untick")
      end
    do
      elseif item_type == "slider" then
        local percentage = l_11_1:percentage()
  end
  if percentage <= 0 or percentage >= 100 or item_type == "multi_choice" then
    end
  end
end

MenuRenderer.post_event = function(l_12_0, l_12_1)
  l_12_0._sound_source:post_event(l_12_1)
end

MenuRenderer.navigate_back = function(l_13_0)
  MenuRenderer.super.navigate_back(l_13_0)
  l_13_0:active_node_gui():update_item_icon_visibility()
  l_13_0:post_event("menu_exit")
end

MenuRenderer.resolution_changed = function(l_14_0, ...)
  MenuRenderer.super.resolution_changed(l_14_0, ...)
  l_14_0:_layout_menu_bg()
  l_14_0:active_node_gui():update_item_icon_visibility()
   -- DECOMPILER ERROR: Confused about usage of registers for local variables.

end

MenuRenderer.set_bg_visible = function(l_15_0, l_15_1)
end

MenuRenderer.set_bg_area = function(l_16_0, l_16_1)
end

MenuRenderer.set_stencil_image = function(l_17_0, l_17_1)
  if not l_17_0._menu_stencil then
    return 
  end
  l_17_0._menu_stencil_image_name = l_17_1
  l_17_1 = tweak_data.menu_themes[managers.user:get_setting("menu_theme")][l_17_1]
  if l_17_0._menu_stencil_image == l_17_1 then
    return 
  end
  if not l_17_1 then
    l_17_0._menu_stencil_image = l_17_0._menu_stencil_default_image
  end
  l_17_0._menu_stencil:set_image(l_17_0._menu_stencil_image)
  l_17_0:set_stencil_align(l_17_0._menu_stencil_align, l_17_0._menu_stencil_align_percent)
end

MenuRenderer.refresh_theme = function(l_18_0)
  l_18_0:set_stencil_image(l_18_0._menu_stencil_image_name)
end

MenuRenderer.set_stencil_align = function(l_19_0, l_19_1, l_19_2)
  if not l_19_0._menu_stencil then
    return 
  end
  l_19_0._menu_stencil_align = l_19_1
  l_19_0._menu_stencil_align_percent = l_19_2
  local res = RenderSettings.resolution
  local safe_rect_pixels = managers.gui_data:scaled_size()
  local y = safe_rect_pixels.height - tweak_data.load_level.upper_saferect_border * 2 + 2
  local m = l_19_0._menu_stencil:texture_width() / l_19_0._menu_stencil:texture_height()
  l_19_0._menu_stencil:set_size(y * m, y)
  l_19_0._menu_stencil:set_center_y(res.y / 2)
  local w = l_19_0._menu_stencil:texture_width()
  local h = l_19_0._menu_stencil:texture_height()
  if l_19_1 == "right" then
    l_19_0._menu_stencil:set_texture_rect(0, 0, w, h)
    l_19_0._menu_stencil:set_right(res.x)
  elseif l_19_1 == "left" then
    l_19_0._menu_stencil:set_texture_rect(0, 0, w, h)
    l_19_0._menu_stencil:set_left(0)
  elseif l_19_1 == "center" then
    l_19_0._menu_stencil:set_texture_rect(0, 0, w, h)
    l_19_0._menu_stencil:set_center_x(res.x / 2)
  elseif l_19_1 == "center-right" then
    l_19_0._menu_stencil:set_texture_rect(0, 0, w, h)
    l_19_0._menu_stencil:set_center_x(res.x * 0.66000002622604)
  elseif l_19_1 == "center-left" then
    l_19_0._menu_stencil:set_texture_rect(0, 0, w, h)
    l_19_0._menu_stencil:set_center_x(res.x * 0.33000001311302)
  elseif l_19_1 == "manual" then
    l_19_0._menu_stencil:set_texture_rect(0, 0, w, h)
    l_19_2 = l_19_2 / 100
    l_19_0._menu_stencil:set_left(res.x * (l_19_2) - y * m * (l_19_2))
  end
end

MenuRenderer.current_menu_text = function(l_20_0, l_20_1)
  local ids = {}
  for i,node_gui in ipairs(l_20_0._node_gui_stack) do
    table.insert(ids, node_gui.node:parameters().topic_id)
  end
  table.insert(ids, l_20_1)
  local s = ""
  for i,id in ipairs(ids) do
    s = s .. managers.localization:text(id)
    s = s .. (i < #ids and " > " or "")
  end
  return s
end

MenuRenderer.accept_input = function(l_21_0, l_21_1)
  managers.menu_component:accept_input(l_21_1)
end

MenuRenderer.input_focus = function(l_22_0)
  return managers.menu_component:input_focus()
end

MenuRenderer.mouse_pressed = function(l_23_0, l_23_1, l_23_2, l_23_3, l_23_4)
  if l_23_0:active_node_gui() and l_23_0:active_node_gui():mouse_pressed(l_23_2, l_23_3, l_23_4) then
    return true
  end
  if managers.menu_component:mouse_pressed(l_23_1, l_23_2, l_23_3, l_23_4) then
    return true
  end
  if managers.menu_scene and managers.menu_scene:mouse_pressed(l_23_1, l_23_2, l_23_3, l_23_4) then
    return true
  end
end

MenuRenderer.mouse_released = function(l_24_0, l_24_1, l_24_2, l_24_3, l_24_4)
  if managers.menu_component:mouse_released(l_24_1, l_24_2, l_24_3, l_24_4) then
    return true
  end
  if managers.menu_scene and managers.menu_scene:mouse_released(l_24_1, l_24_2, l_24_3, l_24_4) then
    return true
  end
  return false
end

MenuRenderer.mouse_clicked = function(l_25_0, l_25_1, l_25_2, l_25_3, l_25_4)
  if managers.menu_component:mouse_clicked(l_25_1, l_25_2, l_25_3, l_25_4) then
    return true
  end
  return false
end

MenuRenderer.mouse_double_click = function(l_26_0, l_26_1, l_26_2, l_26_3, l_26_4)
  if managers.menu_component:mouse_double_click(l_26_1, l_26_2, l_26_3, l_26_4) then
    return true
  end
  return false
end

MenuRenderer.mouse_moved = function(l_27_0, l_27_1, l_27_2, l_27_3)
  local wanted_pointer = "arrow"
  local used, pointer = managers.menu_component:mouse_moved(l_27_1, l_27_2, l_27_3)
  if pointer or used then
    return true, wanted_pointer
  end
  if managers.menu_scene then
    local used, pointer = managers.menu_scene:mouse_moved(l_27_1, l_27_2, l_27_3)
    if pointer or used then
      return true, wanted_pointer
    end
  end
  return false, wanted_pointer
end

MenuRenderer.scroll_up = function(l_28_0)
  return managers.menu_component:scroll_up()
end

MenuRenderer.scroll_down = function(l_29_0)
  return managers.menu_component:scroll_down()
end

MenuRenderer.move_up = function(l_30_0)
  return managers.menu_component:move_up()
end

MenuRenderer.move_down = function(l_31_0)
  return managers.menu_component:move_down()
end

MenuRenderer.move_left = function(l_32_0)
  return managers.menu_component:move_left()
end

MenuRenderer.move_right = function(l_33_0)
  return managers.menu_component:move_right()
end

MenuRenderer.next_page = function(l_34_0)
  return managers.menu_component:next_page()
end

MenuRenderer.previous_page = function(l_35_0)
  return managers.menu_component:previous_page()
end

MenuRenderer.confirm_pressed = function(l_36_0)
  return managers.menu_component:confirm_pressed()
end

MenuRenderer.back_pressed = function(l_37_0)
  return managers.menu_component:back_pressed()
end

MenuRenderer.special_btn_pressed = function(l_38_0, ...)
  return managers.menu_component:special_btn_pressed(...)
   -- DECOMPILER ERROR: Confused about usage of registers for local variables.

end

MenuRenderer.ws_test = function(l_39_0)
  if alive(l_39_0._test_safe) then
    Overlay:gui():destroy_workspace(l_39_0._test_safe)
  end
  if alive(l_39_0._test_full) then
    Overlay:gui():destroy_workspace(l_39_0._test_full)
  end
  l_39_0._test_safe = Overlay:gui():create_screen_workspace()
  managers.gui_data:layout_workspace(l_39_0._test_safe)
  l_39_0._test_full = Overlay:gui():create_screen_workspace()
  managers.gui_data:layout_fullscreen_workspace(l_39_0._test_full)
  local x = 150
  local y = 200
  local fx, fy = managers.gui_data:safe_to_full(x, y)
  local safe = l_39_0._test_safe:panel():rect({x = x, y = y, h = 48, w = 48, layer = 0, orientation = "vertical", color = Color.green})
  local full = l_39_0._test_full:panel():rect({x = fx, y = fy, h = 48, w = 48, layer = 0, orientation = "vertical", color = Color.red})
end


