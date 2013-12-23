-- Decompiled using luadec 2.0.1 by sztupy (http://winmo.sztupy.hu)
-- Command line was: F:\SteamLibrary\SteamApps\common\PAYDAY 2\lua\lib\managers\menu\menupauserenderer.luac 

core:import("CoreMenuNodeGui")
if not MenuPauseRenderer then
  MenuPauseRenderer = class(MenuRenderer)
end
MenuPauseRenderer.init = function(l_1_0, l_1_1)
  MenuRenderer.init(l_1_0, l_1_1)
end

MenuPauseRenderer._setup_bg = function(l_2_0)
end

MenuPauseRenderer.show_node = function(l_3_0, l_3_1)
  local gui_class = MenuNodeGui
  if l_3_1:parameters().gui_class then
    gui_class = CoreSerialize.string_to_classtable(l_3_1:parameters().gui_class)
  end
  if not managers.menu:active_menu() then
    Application:error("now everything is broken")
  end
  {font = tweak_data.menu.pd2_medium_font, row_item_color = tweak_data.screen_colors.button_stage_3, row_item_hightlight_color = tweak_data.screen_colors.button_stage_2, row_item_blend_mode = "add", font_size = tweak_data.menu.pd2_medium_font_size, node_gui_class = gui_class}.spacing = l_3_1:parameters().spacing
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

    MenuPauseRenderer.super.super.show_node(l_3_0, l_3_1, {font = tweak_data.menu.pd2_medium_font, row_item_color = tweak_data.screen_colors.button_stage_3, row_item_hightlight_color = tweak_data.screen_colors.button_stage_2, row_item_blend_mode = "add", font_size = tweak_data.menu.pd2_medium_font_size, node_gui_class = gui_class})
  end
   -- DECOMPILER ERROR: Confused about usage of registers for local variables.

end

MenuPauseRenderer.open = function(l_4_0, ...)
  MenuPauseRenderer.super.super.open(l_4_0, ...)
   -- DECOMPILER ERROR: Overwrote pending register.

   -- DECOMPILER ERROR: Overwrote pending register.

   -- DECOMPILER ERROR: Overwrote pending register.

  MenuRenderer._create_framing(l_4_0)
   -- DECOMPILER ERROR: Confused about usage of registers for local variables.

   -- Warning: undefined locals caused missing assignments!
end

MenuPauseRenderer._layout_menu_bg = function(l_5_0)
end

MenuPauseRenderer.update = function(l_6_0, l_6_1, l_6_2)
  MenuPauseRenderer.super.update(l_6_0, l_6_1, l_6_2)
  do
    local x, y = managers.mouse_pointer:modified_mouse_pos()
    y = math.clamp(y, 0, managers.gui_data:scaled_size().height)
    y = y / managers.gui_data:scaled_size().height
    l_6_0._menu_bg:set_gradient_points({})
  end
   -- Warning: undefined locals caused missing assignments!
end

MenuPauseRenderer.resolution_changed = function(l_7_0, ...)
  MenuPauseRenderer.super.resolution_changed(l_7_0, ...)
   -- DECOMPILER ERROR: Confused about usage of registers for local variables.

end

MenuPauseRenderer.set_bg_visible = function(l_8_0, l_8_1)
  l_8_0._menu_bg:set_visible(l_8_1)
  l_8_0._blur_bg:set_visible(l_8_1)
end

MenuPauseRenderer.set_bg_area = function(l_9_0, l_9_1)
  if l_9_0._menu_bg then
    if l_9_1 == "full" then
      l_9_0._menu_bg:set_size(l_9_0._menu_bg:parent():size())
      l_9_0._menu_bg:set_position(0, 0)
    elseif l_9_1 == "half" then
      l_9_0._menu_bg:set_size(l_9_0._menu_bg:parent():w() * 0.5, l_9_0._menu_bg:parent():h())
      l_9_0._menu_bg:set_top(0)
      l_9_0._menu_bg:set_right(l_9_0._menu_bg:parent():w())
    else
      l_9_0._menu_bg:set_size(l_9_0._menu_bg:parent():size())
      l_9_0._menu_bg:set_position(0, 0)
    end
    if l_9_0._blur_bg then
      l_9_0._blur_bg:set_shape(l_9_0._menu_bg:shape())
    end
  end
end

MenuPauseRenderer.close = function(l_10_0, ...)
  MenuPauseRenderer.super.close(l_10_0, ...)
   -- DECOMPILER ERROR: Confused about usage of registers for local variables.

end


