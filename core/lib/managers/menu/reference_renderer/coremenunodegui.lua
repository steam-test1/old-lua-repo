-- Decompiled using luadec 2.0.1 by sztupy (http://winmo.sztupy.hu)
-- Command line was: F:\SteamLibrary\SteamApps\common\PAYDAY 2\lua\core\lib\managers\menu\reference_renderer\coremenunodegui.luac 

core:module("CoreMenuNodeGui")
core:import("CoreUnit")
if not NodeGui then
  NodeGui = class()
end
NodeGui.init = function(l_1_0, l_1_1, l_1_2, l_1_3)
  l_1_0.node = l_1_1
  l_1_0.name = l_1_1:parameters().name
  l_1_0.font = "core/fonts/diesel"
  l_1_0.font_size = 28
  l_1_0.topic_font_size = 48
  l_1_0.spacing = 0
  local safe_rect_pixels = managers.viewport:get_safe_rect_pixels()
  l_1_0.ws = managers.gui_data:create_saferect_workspace()
  l_1_0._item_panel_parent = l_1_0.ws:panel():panel({name = "item_panel_parent"})
  l_1_0.item_panel = l_1_0._item_panel_parent:panel({name = "item_panel"})
  l_1_0.safe_rect_panel = l_1_0.ws:panel():panel({name = "safe_rect_panel"})
  l_1_0.ws:show()
  l_1_0.layers = {}
  l_1_0.layers.first = l_1_2
  l_1_0.layers.background = l_1_2
  l_1_0.layers.marker = l_1_2 + 1
  l_1_0.layers.items = l_1_2 + 2
  l_1_0.layers.last = l_1_0.layers.items
  l_1_0.localize_strings = true
  l_1_0.row_item_color = Color(1, 0.55294120311737, 0.69019609689713, 0.82745099067688)
  l_1_0.row_item_hightlight_color = Color(1, 0.55294120311737, 0.69019609689713, 0.82745099067688)
  if l_1_3 then
    for param_name,param_value in pairs(l_1_3) do
      l_1_0[param_name] = param_value
    end
  end
  if l_1_0.texture then
    l_1_0.texture.layer = l_1_0.layers.background
    l_1_0.texture = l_1_0.ws:panel():bitmap(l_1_0.texture)
    l_1_0.texture:set_visible(true)
  end
  l_1_0:_setup_panels(l_1_1)
  l_1_0.row_items = {}
  l_1_0:_setup_item_rows(l_1_1)
end

NodeGui.item_panel_parent = function(l_2_0)
  return l_2_0._item_panel_parent
end

NodeGui._setup_panels = function(l_3_0, l_3_1)
end

NodeGui._setup_item_rows = function(l_4_0, l_4_1)
  local items = l_4_1:items()
  local i = 0
  for _,item in pairs(items) do
    if item:visible() then
      item:parameters().gui_node = l_4_0
      local item_name = item:parameters().name
      local item_text = "menu item missing 'text_id'"
      if item:parameters().no_text then
        item_text = nil
      end
      local help_text = nil
      local params = item:parameters()
      if params.text_id and l_4_0.localize_strings and params.localize ~= "false" then
        item_text = managers.localization:text(params.text_id)
      else
        item_text = params.text_id
      end
      if params.help_id then
        help_text = managers.localization:text(params.help_id)
      end
      local row_item = {}
      table.insert(l_4_0.row_items, row_item)
      row_item.item = item
      row_item.node = l_4_1
      row_item.node_gui = l_4_0
      row_item.type = item._type
      row_item.name = item_name
      row_item.position = {x = 0, y = l_4_0.font_size * i + l_4_0.spacing * (i - 1)}
      row_item.color = l_4_0.row_item_color
      row_item.font = l_4_0.font
      row_item.font_size = l_4_0.font_size
      row_item.text = item_text
      row_item.help_text = help_text
      row_item.align = params.align or l_4_0.align or "left"
      row_item.halign = params.halign or l_4_0.halign or "left"
      row_item.vertical = params.vertical or l_4_0.vertical or "center"
      row_item.to_upper = (params.to_upper == nil and l_4_0.to_upper) or params.to_upper or false
      l_4_0:_create_menu_item(row_item)
      l_4_0:reload_item(item)
      i = i + 1
    end
  end
  l_4_0:_setup_size()
  l_4_0:scroll_setup()
  l_4_0:_set_item_positions()
  l_4_0._highlighted_item = nil
end

NodeGui._insert_row_item = function(l_5_0, l_5_1, l_5_2, l_5_3)
  if l_5_1:visible() then
    l_5_1:parameters().gui_node = l_5_0
    local item_name = l_5_1:parameters().name
    local item_text = "menu item missing 'text_id'"
    local help_text = nil
    local params = l_5_1:parameters()
    if params.text_id and l_5_0.localize_strings and params.localize ~= "false" then
      item_text = managers.localization:text(params.text_id)
    else
      item_text = params.text_id
    end
    if params.help_id then
      help_text = managers.localization:text(params.help_id)
    end
    local row_item = {}
    table.insert(l_5_0.row_items, l_5_3, row_item)
    row_item.item = l_5_1
    row_item.node = l_5_2
    row_item.type = l_5_1._type
    row_item.name = item_name
    row_item.position = {x = 0, y = l_5_0.font_size * l_5_3 + l_5_0.spacing * (l_5_3 - 1)}
    row_item.color = l_5_0.row_item_color
    row_item.font = l_5_0.font
    row_item.text = item_text
    row_item.help_text = help_text
    row_item.align = params.align or l_5_0.align or "left"
    row_item.halign = params.halign or l_5_0.halign or "left"
    row_item.vertical = params.vertical or l_5_0.vertical or "center"
    row_item.to_upper = params.to_upper or false
    l_5_0:_create_menu_item(row_item)
    l_5_0:reload_item(l_5_1)
  end
end

NodeGui._delete_row_item = function(l_6_0, l_6_1)
  for i,row_item in ipairs(l_6_0.row_items) do
    if row_item.item == l_6_1 then
      local delete_row_item = table.remove(l_6_0.row_items, i)
      if alive(row_item.gui_panel) then
        l_6_1:on_delete_row_item(row_item)
        l_6_0.item_panel:remove(row_item.gui_panel)
        l_6_0.item_panel:remove(row_item.menu_unselected)
      end
      return 
    end
  end
end

NodeGui.refresh_gui = function(l_7_0, l_7_1)
  l_7_0:_clear_gui()
  l_7_0:_setup_item_rows(l_7_1)
end

NodeGui._clear_gui = function(l_8_0)
  local to = #l_8_0.row_items
  for i = 1, to do
    local row_item = l_8_0.row_items[i]
    if alive(row_item.gui_panel) then
      row_item.gui_panel:parent():remove(row_item.gui_panel)
      row_item.gui_panel = nil
      if alive(row_item.menu_unselected) then
        row_item.menu_unselected:parent():remove(row_item.menu_unselected)
        row_item.menu_unselected = nil
      end
    end
    if alive(row_item.gui_info_panel) then
      l_8_0.safe_rect_panel:remove(row_item.gui_info_panel)
    end
    if alive(row_item.icon) then
      row_item.icon:parent():remove(row_item.icon)
    end
    l_8_0.row_items[i] = nil
  end
  l_8_0.row_items = {}
end

NodeGui.close = function(l_9_0)
  Overlay:gui():destroy_workspace(l_9_0.ws)
  l_9_0.ws = nil
end

NodeGui.layer = function(l_10_0)
  return l_10_0.layers.last
end

NodeGui.set_visible = function(l_11_0, l_11_1)
  if l_11_1 then
    l_11_0.ws:show()
  else
    l_11_0.ws:hide()
  end
end

NodeGui.reload_item = function(l_12_0, l_12_1)
  do
    local type = l_12_1:type()
    if type == "" then
      l_12_0:_reload_item(l_12_1)
    end
  end
  if type ~= "toggle" or type == "slider" then
     -- Warning: missing end command somewhere! Added here
  end
end

NodeGui._reload_item = function(l_13_0, l_13_1)
  local row_item = l_13_0:row_item(l_13_1)
  local params = l_13_1:parameters()
  if params.text_id then
    if l_13_0.localize_strings and params.localize ~= "false" then
      item_text = managers.localization:text(params.text_id)
    else
      item_text = params.text_id
    end
  end
  if row_item then
    row_item.text = item_text
    if row_item.gui_panel.set_text and (not row_item.to_upper or not utf8.to_upper(row_item.text)) then
      row_item.gui_panel:set_text(row_item.text)
    end
  end
end

NodeGui._create_menu_item = function(l_14_0, l_14_1)
end

NodeGui._reposition_items = function(l_15_0, l_15_1)
  local safe_rect = managers.viewport:get_safe_rect_pixels()
  local dy = 0
  if l_15_1 then
    if l_15_1.item:parameters().back then
      return 
    end
    local first = l_15_0.row_items[1].gui_panel == l_15_1.gui_panel
    if not l_15_0.row_items[#l_15_0.row_items].item:parameters().back or not l_15_0.row_items[#l_15_0.row_items - 1] then
      local last = l_15_0.row_items[#l_15_0.row_items]
    end
    last = last.gui_panel == l_15_1.gui_panel
    if not l_15_1.item:get_h(l_15_1, l_15_0) then
      local h = l_15_1.gui_panel:h()
    end
    local offset = (first or last) and 0 or h
    if l_15_1.gui_panel:world_y() - offset < l_15_0._item_panel_parent:world_y() then
      dy = -(l_15_1.gui_panel:world_y() - l_15_0._item_panel_parent:world_y() - offset)
    else
      if l_15_0._item_panel_parent:world_y() + l_15_0._item_panel_parent:h() < l_15_1.gui_panel:world_y() + l_15_1.gui_panel:h() + offset then
        dy = -(l_15_1.gui_panel:world_y() + l_15_1.gui_panel:h() - (l_15_0._item_panel_parent:world_y() + l_15_0._item_panel_parent:h()) + offset)
      end
    end
    local old_dy = l_15_0._scroll_data.dy_left
    local is_same_dir = math.abs(old_dy) > 0 and math.sign(dy) == math.sign(old_dy) or dy == 0
    if is_same_dir then
      local within_view = math.within(l_15_1.gui_panel:world_y(), l_15_0._item_panel_parent:world_y(), l_15_0._item_panel_parent:world_y() + l_15_0._item_panel_parent:h())
      if within_view then
        dy = math.max(math.abs(old_dy), math.abs(dy)) * math.sign(old_dy)
      end
    end
  end
  l_15_0:scroll_start(dy)
end

NodeGui.scroll_setup = function(l_16_0)
  l_16_0._scroll_data = {}
  l_16_0._scroll_data.max_scroll_duration = 0.5
  l_16_0._scroll_data.scroll_speed = (l_16_0.font_size + l_16_0.spacing * 2) / 0.10000000149012
  l_16_0._scroll_data.dy_total = 0
  l_16_0._scroll_data.dy_left = 0
end

NodeGui.scroll_start = function(l_17_0, l_17_1)
  local speed = l_17_0._scroll_data.scroll_speed
  if speed > 0 and l_17_0._scroll_data.max_scroll_duration < math.abs(l_17_1 / speed) then
    speed = math.abs(l_17_1) / l_17_0._scroll_data.max_scroll_duration
  end
  l_17_0._scroll_data.speed = speed
  l_17_0._scroll_data.dy_total = l_17_1
  l_17_0._scroll_data.dy_left = l_17_1
  l_17_0:scroll_update(TimerManager:main():delta_time())
end

NodeGui.scroll_update = function(l_18_0, l_18_1)
  local dy_left = l_18_0._scroll_data.dy_left
  if dy_left ~= 0 then
    local speed = l_18_0._scroll_data.speed
    local dy = nil
    if speed <= 0 then
      dy = dy_left
    else
      dy = math.lerp(0, dy_left, math.clamp(math.sign(dy_left) * speed * l_18_1 / dy_left, 0, 1))
    end
    l_18_0._scroll_data.dy_left = l_18_0._scroll_data.dy_left - dy
    if l_18_0._item_panel_y and l_18_0._item_panel_y.target then
      l_18_0._item_panel_y.target = l_18_0._item_panel_y.target + dy
      l_18_0.item_panel:move(0, dy)
    else
      l_18_0.item_panel:move(0, dy)
    end
    return true
  end
end

NodeGui.wheel_scroll_start = function(l_19_0, l_19_1)
  local speed = 30
  if l_19_1 > 0 then
    local dist = l_19_0.item_panel:world_y() - l_19_0._item_panel_parent:world_y()
    if math.round(l_19_0.item_panel:world_y()) - l_19_0._item_panel_parent:world_y() >= 0 then
      return 
    end
    speed = math.min(speed, math.abs(dist))
  else
    local dist = l_19_0.item_panel:world_bottom() - l_19_0._item_panel_parent:world_bottom()
    if math.round(l_19_0.item_panel:world_bottom()) - l_19_0._item_panel_parent:world_bottom() < 4 then
      return 
    end
    speed = math.min(speed, math.abs(dist))
  end
  l_19_0:scroll_start(speed * l_19_1)
end

NodeGui.highlight_item = function(l_20_0, l_20_1, l_20_2)
  if not l_20_1 then
    return 
  end
  local item_name = l_20_1:parameters().name
  local row_item = l_20_0:row_item(l_20_1)
  l_20_0:_highlight_row_item(row_item, l_20_2)
  l_20_0:_reposition_items(row_item)
  l_20_0._highlighted_item = l_20_1
end

NodeGui._highlight_row_item = function(l_21_0, l_21_1, l_21_2)
  if l_21_1 then
    if not row_item_hightlight_color then
      l_21_1.color = l_21_0.row_item_hightlight_color
    end
    l_21_1.gui_panel:set_color(l_21_1.color)
  end
end

NodeGui.fade_item = function(l_22_0, l_22_1)
  local item_name = l_22_1:parameters().name
  local row_item = l_22_0:row_item(l_22_1)
  l_22_0:_fade_row_item(row_item)
end

NodeGui._fade_row_item = function(l_23_0, l_23_1)
  if l_23_1 then
    if not l_23_1.row_item_color then
      l_23_1.color = l_23_0.row_item_color
    end
    l_23_1.gui_panel:set_color(l_23_1.color)
  end
end

NodeGui.row_item = function(l_24_0, l_24_1)
  local item_name = l_24_1:parameters().name
  for _,row_item in ipairs(l_24_0.row_items) do
    if row_item.name == item_name then
      return row_item
    end
  end
  return nil
end

NodeGui.row_item_by_name = function(l_25_0, l_25_1)
  for _,row_item in ipairs(l_25_0.row_items) do
    if row_item.name == l_25_1 then
      return row_item
    end
  end
  return nil
end

NodeGui.update = function(l_26_0, l_26_1, l_26_2)
  local scrolled = l_26_0:scroll_update(l_26_2)
  if l_26_0._item_panel_y and not scrolled and l_26_0._item_panel_y.target and l_26_0.item_panel:center_y() ~= l_26_0._item_panel_y.target then
    l_26_0._item_panel_y.current = math.lerp(l_26_0.item_panel:center_y(), l_26_0._item_panel_y.target, l_26_2 * 10)
    l_26_0.item_panel:set_center_y(l_26_0._item_panel_y.current)
    l_26_0:_set_topic_position()
    do return end
    if scrolled and l_26_0._item_panel_y then
      if l_26_0._item_panel_y.target and l_26_0.item_panel:center_y() ~= l_26_0._item_panel_y.target then
        l_26_0._item_panel_y.current = math.lerp(l_26_0.item_panel:center_y(), l_26_0._item_panel_y.target, l_26_2 * 10)
      end
      l_26_0:_set_topic_position()
    end
  end
end

NodeGui._item_panel_height = function(l_27_0)
  local height = 0
  for _,row_item in pairs(l_27_0.row_items) do
    if not row_item.item:parameters().back then
      local x, y, w, h = row_item.gui_panel:shape()
      height = height + h + l_27_0.spacing
    end
  end
  return height
end

NodeGui._set_item_positions = function(l_28_0)
  local total_height = l_28_0:_item_panel_height()
  local current_y = 0
  local current_item_height = 0
  local scaled_size = managers.gui_data:scaled_size()
  for _,row_item in pairs(l_28_0.row_items) do
    if not row_item.item:parameters().back then
      row_item.position.y = current_y
      row_item.gui_panel:set_y(row_item.position.y)
      row_item.menu_unselected:set_left(l_28_0:_mid_align() + (row_item.item:parameters().expand_value or 0))
      row_item.menu_unselected:set_h(64 * row_item.gui_panel:h() / 32)
      row_item.menu_unselected:set_center_y(row_item.gui_panel:center_y())
      row_item.menu_unselected:set_w(scaled_size.width - row_item.menu_unselected:x())
      if row_item.current_of_total then
        row_item.current_of_total:set_w(200)
        row_item.current_of_total:set_center_y(row_item.menu_unselected:center_y())
        row_item.current_of_total:set_right(row_item.menu_unselected:right() - l_28_0._align_line_padding)
      end
      row_item.item:on_item_position(row_item, l_28_0)
      if alive(row_item.icon) then
        row_item.icon:set_left(row_item.gui_panel:right())
        row_item.icon:set_center_y(row_item.gui_panel:center_y())
        row_item.icon:set_color(row_item.gui_panel:color())
      end
      local x, y, w, h = row_item.gui_panel:shape()
      current_item_height = h + l_28_0.spacing
      current_y = current_y + (current_item_height)
    end
  end
  for _,row_item in pairs(l_28_0.row_items) do
    if not row_item.item:parameters().back then
      row_item.item:on_item_positions_done(row_item, l_28_0)
    end
  end
end

NodeGui.resolution_changed = function(l_29_0)
  l_29_0:_setup_size()
  l_29_0:_set_item_positions()
  l_29_0:highlight_item(l_29_0._highlighted_item)
end

NodeGui._setup_item_panel_parent = function(l_30_0, l_30_1)
  l_30_0._item_panel_parent:set_shape(l_30_1.x, l_30_1.y, l_30_1.width, l_30_1.height)
end

NodeGui._set_width_and_height = function(l_31_0, l_31_1)
  l_31_0.width = l_31_1.width
  l_31_0.height = l_31_1.height
end

NodeGui._setup_item_panel = function(l_32_0, l_32_1, l_32_2)
  local item_panel_offset = l_32_1.height * 0.5 - #l_32_0.row_items * 0.5 * (l_32_0.font_size + l_32_0.spacing)
  if item_panel_offset < 0 then
    item_panel_offset = 0
  end
  l_32_0.item_panel:set_shape(0, 0 + item_panel_offset, l_32_1.width, l_32_0:_item_panel_height())
  l_32_0.item_panel:set_w(l_32_1.width)
end

NodeGui._scaled_size = function(l_33_0)
  return managers.gui_data:scaled_size()
end

NodeGui._setup_size = function(l_34_0)
  local safe_rect = managers.viewport:get_safe_rect_pixels()
  local scaled_size = managers.gui_data:scaled_size()
  local res = RenderSettings.resolution
  managers.gui_data:layout_workspace(l_34_0.ws)
  l_34_0:_setup_item_panel_parent(scaled_size)
  l_34_0:_set_width_and_height(scaled_size)
  l_34_0:_setup_item_panel(scaled_size, res)
  if l_34_0.texture then
    l_34_0.texture:set_width(res.x)
    l_34_0.texture:set_height(res.x / 2)
    l_34_0.texture:set_center_x(safe_rect.x + safe_rect.width / 2)
    l_34_0.texture:set_center_y(safe_rect.y + safe_rect.height / 2)
  end
  l_34_0.safe_rect_panel:set_shape(scaled_size.x, scaled_size.y, scaled_size.width, scaled_size.height)
  for _,row_item in pairs(l_34_0.row_items) do
    if row_item.item:parameters().back then
      row_item.gui_panel:set_w(24)
      row_item.gui_panel:set_h(24)
      row_item.gui_panel:set_right(l_34_0:_mid_align())
      row_item.unselected:set_h(64 * row_item.gui_panel:h() / 32)
      row_item.unselected:set_center_y(row_item.gui_panel:h() / 2)
      row_item.selected:set_shape(row_item.unselected:shape())
      row_item.shadow:set_w(row_item.gui_panel:w())
      row_item.shadow_bottom:set_bottom(row_item.gui_panel:h())
      row_item.shadow_bottom:set_w(row_item.gui_panel:w())
      row_item.arrow_selected:set_size(row_item.gui_panel:w(), row_item.gui_panel:h())
      row_item.arrow_unselected:set_size(row_item.gui_panel:w(), row_item.gui_panel:h())
    else
      l_34_0:_setup_item_size(row_item)
    end
  end
end

NodeGui._setup_item_size = function(l_35_0, l_35_1)
end

NodeGui.mouse_pressed = function(l_36_0, l_36_1, l_36_2, l_36_3)
  if l_36_0.item_panel:inside(l_36_2, l_36_3) and l_36_0._item_panel_parent:inside(l_36_2, l_36_3) and l_36_0:_mid_align() < l_36_2 then
    if l_36_1 == Idstring("mouse wheel down") then
      l_36_0:wheel_scroll_start(-1)
      return true
    else
      if l_36_1 == Idstring("mouse wheel up") then
        l_36_0:wheel_scroll_start(1)
        return true
      end
    end
  end
end


