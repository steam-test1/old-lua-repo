-- Decompiled using luadec 2.0.1 by sztupy (http://winmo.sztupy.hu)
-- Command line was: F:\SteamLibrary\SteamApps\common\PAYDAY 2\lua\lib\managers\menu\debugstringsboxgui.luac 

if not DebugStringsBoxGui then
  DebugStringsBoxGui = class(TextBoxGui)
end
DebugStringsBoxGui.init = function(l_1_0, l_1_1, l_1_2, l_1_3, l_1_4, l_1_5, l_1_6)
  l_1_0._file = l_1_6
  if not l_1_5 then
    l_1_5 = {}
  end
  l_1_5.h = 300
  l_1_5.w = 300
  local x, y = l_1_1:size()
  l_1_5.x = x - l_1_5.w
  l_1_5.y = y - l_1_5.h - CoreMenuRenderer.Renderer.border_height + 10
  l_1_5.no_close_legend = true
  l_1_5.no_scroll_legend = true
  l_1_0._default_font_size = tweak_data.menu.default_font_size
  l_1_0._topic_state_font_size = 22
  DebugStringsBoxGui.super.init(l_1_0, l_1_1, l_1_2, l_1_3, l_1_4, l_1_5)
  l_1_0:set_layer(10)
end

DebugStringsBoxGui.set_layer = function(l_2_0, l_2_1)
  DebugStringsBoxGui.super.set_layer(l_2_0, l_2_1)
end

DebugStringsBoxGui._create_text_box = function(l_3_0, l_3_1, l_3_2, l_3_3, l_3_4, l_3_5)
  DebugStringsBoxGui.super._create_text_box(l_3_0, l_3_1, l_3_2, l_3_3, l_3_4, l_3_5)
  if l_3_0._info_box then
    l_3_0._info_box:close()
    l_3_0._info_box = nil
  end
  local strings_panel = l_3_0._scroll_panel:panel({name = "strings_panel", x = 0, h = 600, layer = 1})
  local y = 0
  local i = 0
  local ids = managers.localization:debug_file(l_3_0._file)
  local sorted = {}
  for id,_ in pairs(ids) do
    table.insert(sorted, id)
  end
  table.sort(sorted)
  for _,id in pairs(sorted) do
    local localized = ids[id]
    local even = math.mod(i, 2) == 0
    local string_panel = strings_panel:panel({name = id, y = y, w = 528})
     -- DECOMPILER ERROR: Confused while interpreting a jump as a 'while'

  end
  string_panel:rect({name = "bg", color = Color.white / 2:with_alpha(0.25), halign = "grow", layer = 1})
   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

  local text_id = string_panel:text({name = "id", text = id, font = tweak_data.menu.pd2_small_font, font_size = tweak_data.menu.pd2_small_font_size, y = 0, x = 16})
   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

  local text = string_panel:text({name = "text", text = localized, font = tweak_data.menu.pd2_small_font, font_size = tweak_data.menu.pd2_small_font_size, y = 0, x = string_panel:w() / 2, align = "left", vertical = "top"})
  local _, _, tw, th = text_id:text_rect()
  local _, _, tw2, th2 = text:text_rect()
  text_id:set_size(tw, th)
  {name = "text", text = localized, font = tweak_data.menu.pd2_small_font, font_size = tweak_data.menu.pd2_small_font_size, y = 0, x = string_panel:w() / 2, align = "left", vertical = "top"}.word_wrap, {name = "text", text = localized, font = tweak_data.menu.pd2_small_font, font_size = tweak_data.menu.pd2_small_font_size, y = 0, x = string_panel:w() / 2, align = "left", vertical = "top"}.wrap, {name = "text", text = localized, font = tweak_data.menu.pd2_small_font, font_size = tweak_data.menu.pd2_small_font_size, y = 0, x = string_panel:w() / 2, align = "left", vertical = "top"}.layer, {name = "text", text = localized, font = tweak_data.menu.pd2_small_font, font_size = tweak_data.menu.pd2_small_font_size, y = 0, x = string_panel:w() / 2, align = "left", vertical = "top"}.color, {name = "id", text = id, font = tweak_data.menu.pd2_small_font, font_size = tweak_data.menu.pd2_small_font_size, y = 0, x = 16}.layer, {name = "id", text = id, font = tweak_data.menu.pd2_small_font, font_size = tweak_data.menu.pd2_small_font_size, y = 0, x = 16}.color, {name = "id", text = id, font = tweak_data.menu.pd2_small_font, font_size = tweak_data.menu.pd2_small_font_size, y = 0, x = 16}.vertical, {name = "id", text = id, font = tweak_data.menu.pd2_small_font, font_size = tweak_data.menu.pd2_small_font_size, y = 0, x = 16}.halign, {name = "id", text = id, font = tweak_data.menu.pd2_small_font, font_size = tweak_data.menu.pd2_small_font_size, y = 0, x = 16}.align = true, true, 2, Color.white, 2, Color.white, "center", "left", "left"
  text:set_size(tw2, th2)
  string_panel:set_h(math.max(text_id:h(), text:h()) + 4)
  y = y + string_panel:h()
  i = i + 1
end
strings_panel:set_h(y + 14)
l_3_0._scroll_panel:set_h(math.max(l_3_0._scroll_panel:h(), strings_panel:h()))
l_3_0:_set_scroll_indicator()
end

DebugStringsBoxGui.mouse_moved = function(l_4_0, l_4_1, l_4_2)
end

DebugStringsBoxGui._check_scroll_indicator_states = function(l_5_0)
  DebugStringsBoxGui.super._check_scroll_indicator_states(l_5_0)
end

DebugStringsBoxGui.set_size = function(l_6_0, l_6_1, l_6_2)
  DebugStringsBoxGui.super.set_size(l_6_0, l_6_1, l_6_2)
  local strings_panel = l_6_0._scroll_panel:child("strings_panel")
  strings_panel:set_w(l_6_0._scroll_panel:w())
  local hy = 0
  for _,child in ipairs(strings_panel:children()) do
    child:set_w(strings_panel:w())
    child:set_y(hy)
    local text_id = child:child("id")
    local text = child:child("text")
    text:set_x(child:w() / 2)
    text:set_w(child:w() / 2 - 16)
    text:set_shape(text:text_rect())
    text:set_x(child:w() / 2)
    text:set_y(0)
    local _, _, tw2, th2 = text:text_rect()
    local _, _, tw, th = text_id:text_rect()
    text_id:set_h(th)
    child:set_h(math.max(text_id:h(), text:h()) + 4)
    hy = hy + child:h()
  end
end

DebugStringsBoxGui.set_visible = function(l_7_0, l_7_1)
  DebugStringsBoxGui.super.set_visible(l_7_0, l_7_1)
end

DebugStringsBoxGui.close = function(l_8_0)
  print("DebugStringsBoxGui:close()")
  DebugStringsBoxGui.super.close(l_8_0)
end


