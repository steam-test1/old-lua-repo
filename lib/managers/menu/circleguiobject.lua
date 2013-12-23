-- Decompiled using luadec 2.0.1 by sztupy (http://winmo.sztupy.hu)
-- Command line was: F:\SteamLibrary\SteamApps\common\PAYDAY 2\lua\lib\managers\menu\circleguiobject.luac 

if not CircleGuiObject then
  CircleGuiObject = class()
end
CircleGuiObject.init = function(l_1_0, l_1_1, l_1_2)
  l_1_0._panel = l_1_1
  l_1_0._radius = l_1_2.radius or 20
  l_1_0._sides = l_1_2.sides or 10
  l_1_0._total = l_1_2.total or 1
  l_1_2.triangles = l_1_0:_create_triangles(l_1_2)
  l_1_2.w = l_1_0._radius * 2
  l_1_2.h = l_1_0._radius * 2
  l_1_0._circle = l_1_0._panel:polygon(l_1_2)
end

CircleGuiObject._create_triangles = function(l_2_0, l_2_1)
  local amount = 360 * (l_2_1.current or 1) / (l_2_1.total or 1)
  local s = l_2_0._radius
  local triangles = {}
  local step = 360 / l_2_0._sides
  for i = step, amount, step do
    local mid = Vector3(l_2_0._radius, l_2_0._radius, 0)
    table.insert(triangles, mid)
    table.insert(triangles, mid + Vector3(math.sin(i) * l_2_0._radius, -math.cos(i) * l_2_0._radius, 0))
    table.insert(triangles, mid + Vector3(math.sin(i - step) * l_2_0._radius, -math.cos(i - step) * l_2_0._radius, 0))
  end
  return triangles
end

CircleGuiObject.set_current = function(l_3_0, l_3_1)
  local triangles = l_3_0:_create_triangles({current = l_3_1, total = l_3_0._total})
  l_3_0._circle:clear()
  l_3_0._circle:add_triangles(triangles)
end

CircleGuiObject.set_position = function(l_4_0, l_4_1, l_4_2)
  l_4_0._circle:set_position(l_4_1, l_4_2)
end

CircleGuiObject.set_layer = function(l_5_0, l_5_1)
  l_5_0._circle:set_layer(l_5_1)
end

CircleGuiObject.layer = function(l_6_0)
  return l_6_0._circle:layer()
end

CircleGuiObject.remove = function(l_7_0)
  l_7_0._panel:remove(l_7_0._circle)
end

if not CircleBitmapGuiObject then
  CircleBitmapGuiObject = class()
end
CircleBitmapGuiObject.init = function(l_8_0, l_8_1, l_8_2)
  l_8_0._panel = l_8_1
  l_8_0._radius = l_8_2.radius or 20
  l_8_0._sides = l_8_2.sides or 64
  l_8_0._total = l_8_2.total or 1
  l_8_0._size = 128
  l_8_2.texture_rect = nil
  l_8_2.texture = l_8_2.image or "guis/textures/pd2/hud_progress_active"
  l_8_2.w = l_8_0._radius * 2
  l_8_2.h = l_8_0._radius * 2
  l_8_0._circle = l_8_0._panel:bitmap(l_8_2)
  l_8_0._circle:set_render_template(Idstring("VertexColorTexturedRadial"))
  l_8_0._alpha = l_8_0._circle:color().alpha
  l_8_0._circle:set_color(l_8_0._circle:color():with_red(0))
  if l_8_2.use_bg then
    local bg_config = deep_clone(l_8_2)
    bg_config.texture = "guis/textures/pd2/hud_progress_bg"
    bg_config.layer = bg_config.layer - 1
    bg_config.blend_mode = "normal"
    l_8_0._bg_circle = l_8_0._panel:bitmap(bg_config)
  end
end

CircleBitmapGuiObject.radius = function(l_9_0)
  return l_9_0._radius
end

CircleBitmapGuiObject.set_current = function(l_10_0, l_10_1)
  local j = math.mod(math.floor(l_10_1), 8)
  local i = math.floor(l_10_1 / 8)
  l_10_0._circle:set_color(Color(l_10_0._alpha, l_10_1, l_10_0._circle:color().blue, l_10_0._circle:color().green))
end

CircleBitmapGuiObject.position = function(l_11_0)
  return l_11_0._circle:position()
end

CircleBitmapGuiObject.set_position = function(l_12_0, l_12_1, l_12_2)
  l_12_0._circle:set_position(l_12_1, l_12_2)
  if l_12_0._bg_circle then
    l_12_0._bg_circle:set_position(l_12_1, l_12_2)
  end
end

CircleBitmapGuiObject.set_visible = function(l_13_0, l_13_1)
  l_13_0._circle:set_visible(l_13_1)
  if l_13_0._bg_circle then
    l_13_0._bg_circle:set_visible(l_13_1)
  end
end

CircleBitmapGuiObject.visible = function(l_14_0)
  return l_14_0._circle:visible()
end

CircleBitmapGuiObject.set_alpha = function(l_15_0, l_15_1)
  l_15_0._circle:set_alpha(l_15_1)
end

CircleBitmapGuiObject.alpha = function(l_16_0)
  l_16_0._circle:alpha()
end

CircleBitmapGuiObject.set_color = function(l_17_0, l_17_1)
  l_17_0._circle:set_color(l_17_1)
end

CircleBitmapGuiObject.color = function(l_18_0)
  return l_18_0._circle:color()
end

CircleBitmapGuiObject.size = function(l_19_0)
  return l_19_0._circle:size()
end

CircleBitmapGuiObject.set_image = function(l_20_0, l_20_1)
  l_20_0._circle:set_image(l_20_1)
end

CircleBitmapGuiObject.set_layer = function(l_21_0, l_21_1)
  l_21_0._circle:set_layer(l_21_1)
  if l_21_0._bg_circle then
    l_21_0._bg_circle:set_layer(l_21_1 - 1)
  end
end

CircleBitmapGuiObject.layer = function(l_22_0)
  return l_22_0._circle:layer()
end

CircleBitmapGuiObject.remove = function(l_23_0)
  l_23_0._panel:remove(l_23_0._circle)
  if l_23_0._bg_circle then
    l_23_0._panel:remove(l_23_0._bg_circle)
  end
  l_23_0._panel = nil
end


