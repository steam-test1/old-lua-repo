-- Decompiled using luadec 2.0.1 by sztupy (http://winmo.sztupy.hu)
-- Command line was: F:\SteamLibrary\SteamApps\common\PAYDAY 2\lua\lib\managers\menu\bookboxgui.luac 

if not BookBoxGui then
  BookBoxGui = class(TextBoxGui)
end
BookBoxGui.init = function(l_1_0, l_1_1, l_1_2, l_1_3)
  if not l_1_3 then
    l_1_3 = {}
  end
  l_1_3.h = l_1_3.h or 310
  l_1_3.w = l_1_3.w or 360
  local x, y = l_1_1:size()
  if not l_1_3.x then
    l_1_3.x = x - l_1_3.w
  end
  if not l_1_3.y then
    l_1_3.y = y - l_1_3.h - CoreMenuRenderer.Renderer.border_height
  end
  l_1_0._header_type = l_1_3.header_type or "event"
  BookBoxGui.super.init(l_1_0, l_1_1, l_1_2, nil, nil, l_1_3)
  l_1_0._pages = {}
  l_1_0._page_panels = {}
end

BookBoxGui.add_page = function(l_2_0, l_2_1, l_2_2, l_2_3)
  local panel = l_2_0._panel:panel({name = l_2_1, x = 0, h = 20, w = 40, layer = 10})
  panel:rect({name = "bg_rect", color = Color(1, 0.5, 0.5, 0.5), layer = 0})
   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

  panel:text({name = "name_text", text = string.upper(l_2_1), font = tweak_data.menu.pd2_medium_font, font_size = tweak_data.menu.pd2_medium_font_size, x = 0, y = 0})
  {name = "name_text", text = string.upper(l_2_1), font = tweak_data.menu.pd2_medium_font, font_size = tweak_data.menu.pd2_medium_font_size, x = 0, y = 0}.layer, {name = "name_text", text = string.upper(l_2_1), font = tweak_data.menu.pd2_medium_font, font_size = tweak_data.menu.pd2_medium_font_size, x = 0, y = 0}.hvertical, {name = "name_text", text = string.upper(l_2_1), font = tweak_data.menu.pd2_medium_font, font_size = tweak_data.menu.pd2_medium_font_size, x = 0, y = 0}.vertical, {name = "name_text", text = string.upper(l_2_1), font = tweak_data.menu.pd2_medium_font, font_size = tweak_data.menu.pd2_medium_font_size, x = 0, y = 0}.halign, {name = "name_text", text = string.upper(l_2_1), font = tweak_data.menu.pd2_medium_font, font_size = tweak_data.menu.pd2_medium_font_size, x = 0, y = 0}.align = 1, "center", "center", "center", "center"
  l_2_2:set_visible(not l_2_0._visible or l_2_3 or false)
  l_2_2:set_position(l_2_0:position())
  l_2_2:set_size(l_2_0:size())
  l_2_2:set_title(nil)
  l_2_2._panel:child("bottom_line"):set_visible(false)
  l_2_2._panel:child("top_line"):set_visible(false)
  table.insert(l_2_0._page_panels, panel)
  l_2_0:_layout_page_panels()
  l_2_0._pages[l_2_1] = {box_gui = l_2_2, panel = panel}
  if l_2_3 then
    l_2_0:set_page(l_2_1)
  end
end

BookBoxGui.has_page = function(l_3_0, l_3_1)
  return l_3_0._pages[l_3_1]
end

BookBoxGui._layout_page_panels = function(l_4_0)
  local total_w = 0
  for _,p in ipairs(l_4_0._page_panels) do
    local name_text = p:child("name_text")
    local _, _, wt, ht = name_text:text_rect()
    total_w = total_w + wt + 1
  end
  local w = 0
  for _,p in ipairs(l_4_0._page_panels) do
    local name_text = p:child("name_text")
    local _, _, wt, ht = name_text:text_rect()
    local ws = math.ceil(wt / (total_w) * l_4_0._panel:w())
    if l_4_0._header_type == "fit" then
      ws = wt + 10
    end
    p:set_size(ws, ht)
    name_text:set_size(ws, ht)
    name_text:set_center(p:w() / 2, p:h() / 2)
    p:child("bg_rect"):set_size(ws, ht)
    p:set_x(math.ceil(w))
    w = w + math.ceil(p:w()) + 2
  end
end

BookBoxGui.remove_page = function(l_5_0, l_5_1)
  print("BookBoxGui:remove_page( name )", l_5_1)
  local page = l_5_0._pages[l_5_1]
  print("page", page)
  if not page then
    return 
  end
  page.box_gui:close()
  l_5_0._pages[l_5_1] = nil
  print(":remove_page(", l_5_0._active_page_name, l_5_1)
  if l_5_0._active_page_name == l_5_1 then
    l_5_0._active_page_name = nil
    local n, _ = next(l_5_0._pages)
    print("change to", n)
    l_5_0:set_page(n)
  end
  for i,panel in ipairs(l_5_0._page_panels) do
    if panel:name() == l_5_1 then
      table.remove(l_5_0._page_panels, i)
      l_5_0._panel:remove(panel)
    end
  end
  l_5_0:_layout_page_panels()
end

BookBoxGui.set_size = function(l_6_0, l_6_1, l_6_2)
  BookBoxGui.super.set_size(l_6_0, l_6_1, l_6_2)
  for name,page in pairs(l_6_0._pages) do
    page.box_gui:set_size(l_6_1, l_6_2)
  end
end

BookBoxGui.set_centered = function(l_7_0)
  BookBoxGui.super.set_centered(l_7_0)
  for name,page in pairs(l_7_0._pages) do
    page.box_gui:set_position(l_7_0._panel:x(), l_7_0._panel:y())
  end
end

BookBoxGui.set_position = function(l_8_0, l_8_1, l_8_2)
  BookBoxGui.super.set_position(l_8_0, l_8_1, l_8_2)
  for name,page in pairs(l_8_0._pages) do
    page.box_gui:set_position(l_8_1, l_8_2)
  end
end

BookBoxGui.set_visible = function(l_9_0, l_9_1)
  BookBoxGui.super.set_visible(l_9_0, l_9_1)
  for name,page in pairs(l_9_0._pages) do
    page.box_gui:set_visible(not l_9_1 or name == l_9_0._active_page_name)
  end
end

BookBoxGui.set_enabled = function(l_10_0, l_10_1)
  BookBoxGui.super.set_enabled(l_10_0, l_10_1)
  for name,page in pairs(l_10_0._pages) do
    page.box_gui:set_enabled(l_10_1)
  end
end

BookBoxGui.set_layer = function(l_11_0, l_11_1)
  BookBoxGui.super.set_layer(l_11_0, l_11_1)
  for name,page in pairs(l_11_0._pages) do
    page.box_gui:set_layer(l_11_1)
  end
end

BookBoxGui.close = function(l_12_0)
  BookBoxGui.super.close(l_12_0)
  for name,page in pairs(l_12_0._pages) do
    if page.box_gui then
      page.box_gui:close()
    end
  end
end

BookBoxGui.set_page = function(l_13_0, l_13_1)
  if l_13_0._active_page_name == l_13_1 then
    return 
  end
  if l_13_0._active_page_name and l_13_0._active_page_name ~= l_13_1 then
    l_13_0._pages[l_13_0._active_page_name].box_gui:close_page()
  end
  for page_name,page in pairs(l_13_0._pages) do
    page.box_gui:set_visible(not l_13_0._visible or page_name == l_13_1)
    if page_name ~= l_13_1 or not Color(0.5, 1, 1, 1) then
      page.panel:child("bg_rect"):set_color(Color(0.5, 0.5, 0.5, 0.5))
    end
  end
  l_13_0._active_page_name = l_13_1
  l_13_0._pages[l_13_0._active_page_name].box_gui:open_page()
end

BookBoxGui.input_focus = function(l_14_0)
  if not l_14_0._active_page_name then
    return false
  end
  if l_14_0._pages[l_14_0._active_page_name].box_gui:input_focus() then
    return true
  end
end

BookBoxGui.mouse_pressed = function(l_15_0, l_15_1, l_15_2, l_15_3)
  if not l_15_0:can_take_input() then
    return 
  end
  if l_15_1 == Idstring("0") then
    for name,page in pairs(l_15_0._pages) do
      if page.panel:inside(l_15_2, l_15_3) then
        l_15_0:set_page(name)
        return true
      end
    end
  end
  if not l_15_0._active_page_name then
    return false
  end
  if l_15_0._pages[l_15_0._active_page_name].box_gui:mouse_pressed(l_15_1, l_15_2, l_15_3) then
    return true
  end
end

BookBoxGui.check_grab_scroll_bar = function(l_16_0, l_16_1, l_16_2)
  if not l_16_0:can_take_input() then
    return false
  end
  if l_16_0._text_box:inside(l_16_1, l_16_2) and l_16_0._text_box:child("top_line"):inside(l_16_1, l_16_2) then
    l_16_0._grabbed_title = true
    l_16_0._grabbed_offset_x = l_16_0:x() - l_16_1
    l_16_0._grabbed_offset_y = l_16_0:y() - l_16_2
    return true
  end
  if not l_16_0._active_page_name then
    return false
  end
  if l_16_0._pages[l_16_0._active_page_name].box_gui:check_grab_scroll_bar(l_16_1, l_16_2) then
    return true
  end
end

BookBoxGui.release_scroll_bar = function(l_17_0)
  local used, pointer = BookBoxGui.super.release_scroll_bar(l_17_0)
  if used then
    return true, pointer
  end
  if not l_17_0._active_page_name then
    return false
  end
  if l_17_0._pages[l_17_0._active_page_name].box_gui:release_scroll_bar() then
    return true
  end
end

BookBoxGui.mouse_wheel_down = function(l_18_0, l_18_1, l_18_2)
  if not l_18_0._visible then
    return 
  end
  if not l_18_0._active_page_name then
    return false
  end
  if l_18_0._pages[l_18_0._active_page_name].box_gui:mouse_wheel_down(l_18_1, l_18_2) then
    return true
  end
end

BookBoxGui.mouse_wheel_up = function(l_19_0, l_19_1, l_19_2)
  if not l_19_0._visible then
    return 
  end
  if not l_19_0._active_page_name then
    return false
  end
  if l_19_0._pages[l_19_0._active_page_name].box_gui:mouse_wheel_up(l_19_1, l_19_2) then
    return true
  end
end

BookBoxGui.moved_scroll_bar = function(l_20_0, l_20_1, l_20_2)
  local used, pointer = BookBoxGui.super.moved_scroll_bar(l_20_0, l_20_1, l_20_2)
  if used then
    return true, pointer
  end
  if not l_20_0._active_page_name then
    return false
  end
  if l_20_0._pages[l_20_0._active_page_name].box_gui:moved_scroll_bar(l_20_1, l_20_2) then
    return true
  end
end

BookBoxGui.mouse_moved = function(l_21_0, l_21_1, l_21_2)
  local pointer = nil
  if not l_21_0:can_take_input() then
    return false, pointer
  end
  if not l_21_0._active_page_name then
    return false, pointer
  end
  local used, wpointer = l_21_0._pages[l_21_0._active_page_name].box_gui:mouse_moved(l_21_1, l_21_2)
  if wpointer or used then
    return true, pointer
  end
  if l_21_0:_mouse_over_page_panel(l_21_1, l_21_2) then
    pointer = "arrow"
  else
    if l_21_0._text_box:inside(l_21_1, l_21_2) and l_21_0._text_box:child("top_line"):inside(l_21_1, l_21_2) then
      pointer = "hand"
    end
  end
  return false, pointer
end

BookBoxGui._mouse_over_page_panel = function(l_22_0, l_22_1, l_22_2)
  for _,panel in ipairs(l_22_0._page_panels) do
    if panel:inside(l_22_1, l_22_2) then
      return panel
    end
  end
  return nil
end


