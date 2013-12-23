-- Decompiled using luadec 2.0.1 by sztupy (http://winmo.sztupy.hu)
-- Command line was: F:\SteamLibrary\SteamApps\common\PAYDAY 2\lua\lib\managers\menu\renderers\menunodecrimenetgui.luac 

if not MenuNodeCrimenetGui then
  MenuNodeCrimenetGui = class(MenuNodeGui)
end
MenuNodeCrimenetGui.init = function(l_1_0, l_1_1, l_1_2, l_1_3)
  l_1_3.font = tweak_data.menu.pd2_small_font
  l_1_3.font_size = tweak_data.menu.pd2_small_font_size
  l_1_3.align = "left"
  l_1_3.row_item_blend_mode = "add"
  l_1_3.row_item_color = tweak_data.screen_colors.button_stage_3
  l_1_3.row_item_hightlight_color = tweak_data.screen_colors.button_stage_2
  l_1_3.marker_alpha = 1
  l_1_3.to_upper = true
  MenuNodeCrimenetGui.super.init(l_1_0, l_1_1, l_1_2, l_1_3)
end

MenuNodeCrimenetGui._setup_item_panel = function(l_2_0, l_2_1, l_2_2)
  MenuNodeHiddenGui.super._setup_item_panel(l_2_0, l_2_1, l_2_2)
  local width = 760
  local height = 540
  if SystemInfo:platform() ~= Idstring("WIN32") then
    width = 800
    height = 500
  end
  l_2_0.item_panel:set_rightbottom(l_2_0.item_panel:parent():w() * 0.5 + width / 2 - 10, l_2_0.item_panel:parent():h() * 0.5 + height / 2 - 10)
  l_2_0:_set_topic_position()
end

if not MenuNodeCrimenetFiltersGui then
  MenuNodeCrimenetFiltersGui = class(MenuNodeGui)
end
MenuNodeCrimenetFiltersGui.init = function(l_3_0, l_3_1, l_3_2, l_3_3)
  l_3_3.font = tweak_data.menu.pd2_small_font
  l_3_3.font_size = tweak_data.menu.pd2_small_font_size
  l_3_3.align = "left"
  l_3_3.row_item_blend_mode = "add"
  l_3_3.row_item_color = tweak_data.screen_colors.button_stage_3
  l_3_3.row_item_hightlight_color = tweak_data.screen_colors.button_stage_2
  l_3_3.marker_alpha = 1
  l_3_3.to_upper = true
  MenuNodeCrimenetFiltersGui.super.init(l_3_0, l_3_1, l_3_2, l_3_3)
end

MenuNodeCrimenetFiltersGui.close = function(l_4_0, ...)
  MenuNodeCrimenetFiltersGui.super.close(l_4_0, ...)
   -- DECOMPILER ERROR: Confused about usage of registers for local variables.

end

MenuNodeCrimenetFiltersGui._setup_item_panel = function(l_5_0, l_5_1, l_5_2)
  MenuNodeCrimenetFiltersGui.super._setup_item_panel(l_5_0, l_5_1, l_5_2)
  l_5_0:_set_topic_position()
  local max_layer = 10000
  local min_layer = 0
  local child_layer = 0
  for _,child in ipairs(l_5_0.item_panel:children()) do
    child:set_halign("right")
    child_layer = child:layer()
    if child_layer > 0 then
      min_layer = math.min(min_layer, child_layer)
    end
    max_layer = math.max(max_layer, child_layer)
  end
  for _,child in ipairs(l_5_0.item_panel:children()) do
  end
  l_5_0.item_panel:set_w(l_5_1.width * (1 - l_5_0._align_line_proportions))
  l_5_0.item_panel:set_center(l_5_0.item_panel:parent():w() / 2, l_5_0.item_panel:parent():h() / 2)
  l_5_0.box_panel = l_5_0.item_panel:parent():panel()
  l_5_0.box_panel:set_shape(l_5_0.item_panel:shape())
  l_5_0.box_panel:set_layer(51)
  l_5_0.box_panel:grow(20, 20)
  l_5_0.box_panel:move(-10, -10)
  l_5_0.boxgui = BoxGuiObject:new(l_5_0.box_panel, {sides = {1, 1, 1, 1}})
  l_5_0.box_panel:rect({color = Color.black, alpha = 0.60000002384186})
end

MenuNodeCrimenetFiltersGui.reload_item = function(l_6_0, l_6_1)
  MenuNodeCrimenetFiltersGui.super.reload_item(l_6_0, l_6_1)
  local row_item = l_6_0:row_item(l_6_1)
  row_item.gui_panel:set_right(l_6_0.item_panel:w())
end

MenuNodeCrimenetFiltersGui._align_marker = function(l_7_0, l_7_1)
  MenuNodeCrimenetFiltersGui.super._align_marker(l_7_0, l_7_1)
  l_7_0._marker_data.marker:set_world_right(l_7_0.item_panel:world_right())
end


