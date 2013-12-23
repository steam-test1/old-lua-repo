-- Decompiled using luadec 2.0.1 by sztupy (http://winmo.sztupy.hu)
-- Command line was: F:\SteamLibrary\SteamApps\common\PAYDAY 2\lua\lib\managers\menu\renderers\menunodebuttonlayoutgui.luac 

if not MenuNodeButtonLayoutGui then
  MenuNodeButtonLayoutGui = class(MenuNodeGui)
end
MenuNodeButtonLayoutGui.init = function(l_1_0, l_1_1, l_1_2, l_1_3)
  MenuNodeButtonLayoutGui.super.init(l_1_0, l_1_1, l_1_2, l_1_3)
  l_1_0:_setup(l_1_1)
end

MenuNodeButtonLayoutGui._setup_panels = function(l_2_0, l_2_1)
  MenuNodeButtonLayoutGui.super._setup_panels(l_2_0, l_2_1)
  local safe_rect_pixels = managers.viewport:get_safe_rect_pixels()
end

MenuNodeButtonLayoutGui._setup = function(l_3_0)
  if not tweak_data:get_controller_help_coords() then
    l_3_0._coords = {}
  end
  for id,data in pairs(l_3_0._coords) do
    data.text = l_3_0.ws:panel():text({text = managers.localization:to_upper_text(id), font_size = l_3_0.font_size, font = l_3_0.font, layer = l_3_0.layers.items, align = data.align, vertical = data.vertical, halign = "center", valign = "center"})
  end
  l_3_0._blur = managers.menu_component._fullscreen_ws:panel():bitmap({texture = "guis/textures/test_blur_df", w = managers.menu_component._fullscreen_ws:panel():w(), h = managers.menu_component._fullscreen_ws:panel():h(), render_template = "VertexColorTexturedBlur3D", layer = l_3_0.layers.background})
  local func = function(l_1_0)
    local start_blur = 0
    over(0.60000002384186, function(l_1_0)
      o:set_alpha(math.lerp(start_blur, 1, l_1_0))
      end)
   end
  l_3_0._blur:animate(func)
  l_3_0._bg = l_3_0.ws:panel():rect({visible = false, color = Color(1, 0.10000000149012, 0.10000000149012, 0.10000000149012), layer = l_3_0.layers.background})
  l_3_0._controller = l_3_0.ws:panel():bitmap({texture = "guis/textures/controller", layer = l_3_0.layers.items, w = 512, h = 256})
  l_3_0:_layout()
end

MenuNodeButtonLayoutGui._layout = function(l_4_0)
  local safe_rect_pixels = managers.viewport:get_safe_rect_pixels()
  local res = RenderSettings.resolution
  do
    local scale = tweak_data.scale.button_layout_multiplier
    l_4_0._bg:set_h(res.y - (tweak_data.menu.upper_saferect_border + safe_rect_pixels.y) * 2 + 2)
    l_4_0._bg:set_center_y(res.y / 2)
    l_4_0._blur:set_size(managers.menu_component._fullscreen_ws:panel():w(), managers.menu_component._fullscreen_ws:panel():h())
    l_4_0._controller:set_size(l_4_0._controller:w() * scale, l_4_0._controller:h() * scale)
    l_4_0._controller:set_center(l_4_0.ws:panel():w() / 2, l_4_0.ws:panel():h() / 2)
    for id,data in pairs(l_4_0._coords) do
      local _, _, w, h = data.text:text_rect()
      data.text:set_size(w, h)
      if data.x then
        local x = l_4_0._controller:x() + data.x * scale
        local y = l_4_0._controller:y() + data.y * scale
        if data.align == "left" then
          data.text:set_left(x)
        elseif data.align == "right" then
          data.text:set_right(x)
        elseif data.align == "center" then
          data.text:set_center_x(x)
        end
        if data.vertical == "top" then
          data.text:set_top(y)
          for (for control),id in (for generator) do
          end
          if data.vertical == "bottom" then
            data.text:set_bottom(y)
            for (for control),id in (for generator) do
            end
            data.text:set_center_y(y)
          end
        end
      end
       -- Warning: missing end command somewhere! Added here
    end
     -- Warning: missing end command somewhere! Added here
  end
end

MenuNodeButtonLayoutGui._create_menu_item = function(l_5_0, l_5_1)
  MenuNodeButtonLayoutGui.super._create_menu_item(l_5_0, l_5_1)
end

MenuNodeButtonLayoutGui._setup_item_panel_parent = function(l_6_0, l_6_1)
  MenuNodeButtonLayoutGui.super._setup_item_panel_parent(l_6_0, l_6_1)
end

MenuNodeButtonLayoutGui._setup_item_panel = function(l_7_0, l_7_1, l_7_2)
  MenuNodeButtonLayoutGui.super._setup_item_panel(l_7_0, l_7_1, l_7_2)
end

MenuNodeButtonLayoutGui.resolution_changed = function(l_8_0)
  MenuNodeButtonLayoutGui.super.resolution_changed(l_8_0)
  l_8_0:_layout()
end

MenuNodeButtonLayoutGui.close = function(l_9_0, ...)
  l_9_0._bg:parent():remove(l_9_0._bg)
  l_9_0._blur:parent():remove(l_9_0._blur)
  MenuNodeButtonLayoutGui.super.close(l_9_0, ...)
   -- DECOMPILER ERROR: Confused about usage of registers for local variables.

end


