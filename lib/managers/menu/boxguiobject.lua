-- Decompiled using luadec 2.0.1 by sztupy (http://winmo.sztupy.hu)
-- Command line was: F:\SteamLibrary\SteamApps\common\PAYDAY 2\lua\lib\managers\menu\boxguiobject.luac 

if not BoxGuiObject then
  BoxGuiObject = class()
end
local mvector_tl = Vector3()
local mvector_tr = Vector3()
local mvector_bl = Vector3()
local mvector_br = Vector3()
BoxGuiObject.init = function(l_1_0, l_1_1, l_1_2)
  l_1_0:create_sides(l_1_1, l_1_2)
end

BoxGuiObject.create_sides = function(l_2_0, l_2_1, l_2_2)
  if alive(l_2_0._panel) then
    l_2_0._panel:parent():remove(l_2_0._panel)
    l_2_0._panel = nil
  end
  l_2_0._panel = l_2_1:panel({halign = "grow", valign = "grow", layer = 1})
  l_2_0._color = Color.white
  local left_side = (l_2_2.sides and l_2_2.sides[1]) or l_2_2.left or 0
  local right_side = (l_2_2.sides and l_2_2.sides[2]) or l_2_2.right or 0
  local top_side = (l_2_2.sides and l_2_2.sides[3]) or l_2_2.top or 0
  local bottom_side = (l_2_2.sides and l_2_2.sides[4]) or l_2_2.bottom or 0
  l_2_0:_create_side(l_2_0._panel, "left", left_side)
  l_2_0:_create_side(l_2_0._panel, "right", right_side)
  l_2_0:_create_side(l_2_0._panel, "top", top_side)
  l_2_0:_create_side(l_2_0._panel, "bottom", bottom_side)
end

BoxGuiObject._create_side = function(l_3_0, l_3_1, l_3_2, l_3_3)
  local ids_side = Idstring(l_3_2)
  local ids_left = Idstring("left")
  local ids_right = Idstring("right")
  local ids_top = Idstring("top")
  local ids_bottom = Idstring("bottom")
  local left_or_right = false
  local w, h = nil, nil
  if ids_side == ids_left or ids_side == ids_right then
    left_or_right = true
    w = 2
    h = l_3_1:h()
  else
    w = l_3_1:w()
    h = 2
  end
  local side_panel = l_3_1:panel({name = l_3_2, w = w, h = h, halign = "grow", valign = "grow"})
  if l_3_3 == 0 then
    return 
  elseif l_3_3 == 1 then
    local one = side_panel:bitmap({texture = "guis/textures/pd2/shared_lines", halign = "grow", valign = "grow", wrap_mode = "wrap"})
    local two = side_panel:bitmap({texture = "guis/textures/pd2/shared_lines", halign = "grow", valign = "grow", wrap_mode = "wrap"})
    local x = math.random(1, 255)
    local y = math.random(0, one:texture_height() / 2 - 1) * 2
    local tw = math.min(10, w)
    local th = math.min(10, h)
    if left_or_right then
      mvector3.set_static(mvector_tl, x, y + tw, 0)
      mvector3.set_static(mvector_tr, x, y, 0)
      mvector3.set_static(mvector_bl, x + th, y + tw, 0)
      mvector3.set_static(mvector_br, x + th, y, 0)
      one:set_texture_coordinates(mvector_tl, mvector_tr, mvector_bl, mvector_br)
      x = math.random(1, 255)
      y = math.random(0, math.round(one:texture_height() / 2 - 1)) * 2
      mvector3.set_static(mvector_tl, x, y + tw, 0)
      mvector3.set_static(mvector_tr, x, y, 0)
      mvector3.set_static(mvector_bl, x + th, y + tw, 0)
      mvector3.set_static(mvector_br, x + th, y, 0)
      one:set_texture_coordinates(mvector_tl, mvector_tr, mvector_bl, mvector_br)
      one:set_size(2, th)
      two:set_size(2, th)
      two:set_bottom(h)
    else
      mvector3.set_static(mvector_tl, x, y, 0)
      mvector3.set_static(mvector_tr, x + tw, y, 0)
      mvector3.set_static(mvector_bl, x, y + th, 0)
      mvector3.set_static(mvector_br, x + tw, y + th, 0)
      one:set_texture_coordinates(mvector_tl, mvector_tr, mvector_bl, mvector_br)
      x = math.random(1, 255)
      y = math.random(0, math.round(one:texture_height() / 2 - 1)) * 2
      mvector3.set_static(mvector_tl, x, y, 0)
      mvector3.set_static(mvector_tr, x + tw, y, 0)
      mvector3.set_static(mvector_bl, x, y + th, 0)
      mvector3.set_static(mvector_br, x + tw, y + th, 0)
      one:set_texture_coordinates(mvector_tl, mvector_tr, mvector_bl, mvector_br)
      one:set_size(tw, 2)
      two:set_size(tw, 2)
      two:set_right(w)
    end
  elseif l_3_3 == 2 then
    local full = side_panel:bitmap({texture = "guis/textures/pd2/shared_lines", halign = "grow", valign = "grow", wrap_mode = "wrap", w = side_panel:w(), h = side_panel:h()})
    local x = math.random(1, 255)
    local y = math.random(0, math.round(full:texture_height() / 2 - 1)) * 2
    if left_or_right then
      mvector3.set_static(mvector_tl, x, y + w, 0)
      mvector3.set_static(mvector_tr, x, y, 0)
      mvector3.set_static(mvector_bl, x + h, y + w, 0)
      mvector3.set_static(mvector_br, x + h, y, 0)
      full:set_texture_coordinates(mvector_tl, mvector_tr, mvector_bl, mvector_br)
    else
      mvector3.set_static(mvector_tl, x, y, 0)
      mvector3.set_static(mvector_tr, x + w, y, 0)
      mvector3.set_static(mvector_bl, x, y + h, 0)
      mvector3.set_static(mvector_br, x + w, y + h, 0)
      full:set_texture_coordinates(mvector_tl, mvector_tr, mvector_bl, mvector_br)
    end
  else
    Application:error("[BoxGuiObject] Type", l_3_3, "is not supported")
    Application:stack_dump()
    return 
  end
end
end
side_panel:set_position(0, 0)
if ids_side == ids_right then
side_panel:set_right(l_3_1:w())
elseif ids_side == ids_bottom then
side_panel:set_bottom(l_3_1:h())
end
return side_panel
end

BoxGuiObject.hide = function(l_4_0)
  l_4_0._panel:hide()
end

BoxGuiObject.show = function(l_5_0)
  l_5_0._panel:show()
end

BoxGuiObject.set_visible = function(l_6_0, l_6_1)
  l_6_0._panel:set_visible(l_6_1)
end

BoxGuiObject.set_layer = function(l_7_0, l_7_1)
  l_7_0._panel:set_layer(l_7_1)
end

BoxGuiObject.size = function(l_8_0)
  return l_8_0._panel:size()
end

BoxGuiObject.set_clipping = function(l_9_0, l_9_1, l_9_2)
  if not l_9_2 or not l_9_2:children() then
    for i,d in pairs(l_9_0._panel:children()) do
    end
    if not l_9_1 or not 0 then
      d:set_rotation(not d.set_rotation or 360)
      for (for control),i in (for generator) do
      end
      l_9_0:set_clipping(l_9_1, d)
    end
     -- Warning: missing end command somewhere! Added here
  end
end

BoxGuiObject.color = function(l_10_0)
  return l_10_0._color
end

BoxGuiObject.set_color = function(l_11_0, l_11_1, l_11_2)
  l_11_0._color = l_11_1
  if not l_11_2 or not l_11_2:children() then
    for i,d in pairs(l_11_0._panel:children()) do
    end
    if d.set_color then
      d:set_color(l_11_1)
      for (for control),i in (for generator) do
      end
      l_11_0:set_color(l_11_1, d)
    end
     -- Warning: missing end command somewhere! Added here
  end
end

BoxGuiObject.close = function(l_12_0)
  if alive(l_12_0._panel) and alive(l_12_0._panel:parent()) then
    l_12_0._panel:parent():remove(l_12_0._panel)
  end
end


