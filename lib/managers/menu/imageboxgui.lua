-- Decompiled using luadec 2.0.1 by sztupy (http://winmo.sztupy.hu)
-- Command line was: F:\SteamLibrary\SteamApps\common\PAYDAY 2\lua\lib\managers\menu\imageboxgui.luac 

if not ImageBoxGui then
  ImageBoxGui = class(TextBoxGui)
end
ImageBoxGui.init = function(l_1_0, ...)
  ImageBoxGui.super.init(l_1_0, ...)
   -- DECOMPILER ERROR: Confused about usage of registers for local variables.

end

ImageBoxGui.update = function(l_2_0, l_2_1, l_2_2)
end

ImageBoxGui._create_text_box = function(l_3_0, l_3_1, l_3_2, l_3_3, l_3_4, l_3_5, l_3_6)
  ImageBoxGui.super._create_text_box(l_3_0, l_3_1, l_3_2, l_3_3, l_3_4, l_3_5)
  l_3_0:_create_image_box(l_3_6)
end

ImageBoxGui._create_image_box = function(l_4_0, l_4_1)
  if not l_4_1 then
    l_4_1 = {}
  end
  if not l_4_1.shapes then
    local image_shapes = {}
  end
  local image_texture = l_4_1.texture or nil
  local keep_texure_ratio = l_4_1.keep_ratio or false
  local image_render_template = l_4_1.render_template
  local image_width = l_4_1.w or l_4_1.width or 0
  local image_height = l_4_1.h or l_4_1.height or 0
  local image_padding = l_4_1.padding or 0
  local image_halign = Idstring(l_4_1.halign or l_4_1.align or "left")
  local image_valign = Idstring(l_4_1.valign or l_4_1.vertical or "center")
  local image_layer = l_4_1.layer or 0
  local main = l_4_0._panel
  local title = main:child("title")
  local info_area = main:child("info_area")
  local buttons_panel = info_area:child("buttons_panel")
  local scroll_panel = info_area:child("scroll_panel")
  local grow_w, grow_h = 0, 0
  if image_halign ~= Idstring("center") then
    grow_w = image_width + image_padding * 2
  end
  if image_valign ~= Idstring("center") then
    grow_h = image_height + image_padding * 2
  end
  main:grow(grow_w, grow_h)
  info_area:set_size(main:size())
  local move_x, move_y = 0, 0
  if image_halign == Idstring("left") then
    move_x = grow_w
  end
  if image_valign ~= Idstring("top") then
    move_y = grow_h
  end
  title:move(move_x, move_y)
  buttons_panel:move(move_x, move_y)
  scroll_panel:move(move_x, move_y)
  l_4_0._panel_w = main:w()
  l_4_0._panel_h = main:h()
  local image_panel = main:panel({name = "image_panel", w = image_width, h = image_height, layer = image_layer})
  if image_halign == Idstring("center") then
    image_panel:set_center_x(l_4_0._panel_w / 2)
  else
    if image_halign == Idstring("right") then
      image_panel:set_right(l_4_0._panel_w - 10)
    else
      image_panel:set_left(10)
    end
  end
  if image_valign == Idstring("center") then
    image_panel:set_center_y(l_4_0._panel_h / 2)
  else
    if image_valign == Idstring("bottom") then
      image_panel:set_bottom(l_4_0._panel_h - 10)
    else
      image_panel:set_top(10)
    end
  end
  if image_texture then
    local image = image_panel:bitmap({texture = image_texture, w = image_width, h = image_height})
    if image_render_template then
      image:set_render_template(image_render_template)
    end
    if keep_texure_ratio then
      local texture_width, texture_height = image:texture_width(), image:texture_height()
      local image_aspect = math.max(image_width, 1) / math.max(image_height, 1)
      local texture_aspect = math.max(texture_width, 1) / math.max(texture_height, 1)
      local aspect = texture_aspect / image_aspect
      local sw = math.min(image_width, image_width * aspect)
      local sh = math.min(image_height, image_height / aspect)
      image:set_size(sw, sh)
      image:set_center(image_panel:w() / 2, image_panel:h() / 2)
    end
  end
  if image_shapes then
    for _,shape in pairs(image_shapes) do
      local type = shape.type or rect
      local new_shape = nil
      new_shape = image_panel:rect({color = Color.white, w = type ~= "rect" or 0, h = (shape.color or not shape.width) and shape.height or shape.height or shape.h or 0, layer = shape.layer or 0})
      do return end
      new_shape = image_panel:bitmap({texture = shape.texture, color = Color.white, w = type ~= "bitmap" or 0, h = (shape.color or not shape.width) and shape.height or shape.height or shape.h or 0, layer = shape.layer or 0})
      new_shape:set_center(shape.x * image_panel:w(), shape.y * image_panel:h())
      new_shape:set_position(math.round(new_shape:x()), math.round(new_shape:y()))
    end
  end
  l_4_0._info_box:create_sides(info_area, {sides = {1, 1, 1, 1}})
  Global.info_area = info_area
  l_4_0:_set_scroll_indicator()
  main:set_center(main:parent():w() / 2, main:parent():h() / 2)
end

ImageBoxGui.mouse_moved = function(l_5_0, l_5_1, l_5_2)
end

ImageBoxGui.mouse_pressed = function(l_6_0, l_6_1, l_6_2, l_6_3)
end

ImageBoxGui.close = function(l_7_0)
  if alive(l_7_0._panel) then
    l_7_0._ws:panel():remove(l_7_0._panel)
  end
end


