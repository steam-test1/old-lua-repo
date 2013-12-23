-- Decompiled using luadec 2.0.1 by sztupy (http://winmo.sztupy.hu)
-- Command line was: F:\SteamLibrary\SteamApps\common\PAYDAY 2\lua\core\lib\system\corepatchengine.luac 

Idstring.id = function(l_1_0)
  return l_1_0
end

string.id = function(l_2_0)
  return Idstring(l_2_0)
end

string.t = function(l_3_0)
  return Idstring(l_3_0):t()
end

string.s = function(l_4_0)
  return l_4_0
end

string.key = function(l_5_0)
  return Idstring(l_5_0):key()
end

string.raw = function(l_6_0)
  return Idstring(l_6_0):raw()
end

if Vector3 then
  Vector3.__concat = function(l_7_0, l_7_1)
  return tostring(l_7_0) .. tostring(l_7_1)
end

  Vector3.flat = function(l_8_0, l_8_1)
    return math.cross(math.cross(l_8_1, l_8_0), l_8_1)
   end
  Vector3.orthogonal = function(l_9_0, l_9_1)
    return l_9_0:orthogonal_func()(l_9_1)
   end
  Vector3.orthogonal_func = function(l_10_0, l_10_1)
    if not l_10_1 then
      local rot = Rotation(l_10_0, Vector3(0, 0, -1))
    end
    return function(l_1_0)
        return -rot:z() * math.cos(180 + 360 * l_1_0) + rot:x() * math.cos(90 + 360 * l_1_0):normalized()
         end
   end
  Vector3.unpack = function(l_11_0)
    return l_11_0.x, l_11_0.y, l_11_0.z
   end
end
if Color then
  Color.unpack = function(l_12_0)
  return l_12_0.r, l_12_0.g, l_12_0.b
end

end
local AppClass = getmetatable(Application)
if AppClass then
  AppClass.draw_box = function(l_13_0, l_13_1, l_13_2, l_13_3, l_13_4, l_13_5)
  Application:draw_line(l_13_1, Vector3(l_13_2.x, l_13_1.y, l_13_1.z), l_13_3, l_13_4, l_13_5)
  Application:draw_line(l_13_1, Vector3(l_13_1.x, l_13_2.y, l_13_1.z), l_13_3, l_13_4, l_13_5)
  Application:draw_line(Vector3(l_13_2.x, l_13_2.y, l_13_1.z), Vector3(l_13_1.x, l_13_2.y, l_13_1.z), l_13_3, l_13_4, l_13_5)
  Application:draw_line(Vector3(l_13_2.x, l_13_2.y, l_13_1.z), Vector3(l_13_2.x, l_13_1.y, l_13_1.z), l_13_3, l_13_4, l_13_5)
  Application:draw_line(l_13_1, Vector3(l_13_1.x, l_13_1.y, l_13_2.z), l_13_3, l_13_4, l_13_5)
  Application:draw_line(Vector3(l_13_1.x, l_13_2.y, l_13_1.z), Vector3(l_13_1.x, l_13_2.y, l_13_2.z), l_13_3, l_13_4, l_13_5)
  Application:draw_line(Vector3(l_13_2.x, l_13_1.y, l_13_1.z), Vector3(l_13_2.x, l_13_1.y, l_13_2.z), l_13_3, l_13_4, l_13_5)
  Application:draw_line(Vector3(l_13_2.x, l_13_2.y, l_13_1.z), Vector3(l_13_2.x, l_13_2.y, l_13_2.z), l_13_3, l_13_4, l_13_5)
  Application:draw_line(Vector3(l_13_1.x, l_13_1.y, l_13_2.z), Vector3(l_13_2.x, l_13_1.y, l_13_2.z), l_13_3, l_13_4, l_13_5)
  Application:draw_line(Vector3(l_13_1.x, l_13_1.y, l_13_2.z), Vector3(l_13_1.x, l_13_2.y, l_13_2.z), l_13_3, l_13_4, l_13_5)
  Application:draw_line(Vector3(l_13_2.x, l_13_2.y, l_13_2.z), Vector3(l_13_1.x, l_13_2.y, l_13_2.z), l_13_3, l_13_4, l_13_5)
  Application:draw_line(Vector3(l_13_2.x, l_13_2.y, l_13_2.z), Vector3(l_13_2.x, l_13_1.y, l_13_2.z), l_13_3, l_13_4, l_13_5)
end

  AppClass.draw_box_rotation = function(l_14_0, l_14_1, l_14_2, l_14_3, l_14_4, l_14_5, l_14_6, l_14_7, l_14_8)
    local c1 = l_14_1
    local c2 = l_14_1 + l_14_2:x() * l_14_3
    local c3 = l_14_1 + l_14_2:y() * l_14_4
    local c4 = l_14_1 + l_14_2:x() * l_14_3 + l_14_2:y() * l_14_4
    local c5 = c1 + l_14_2:z() * l_14_5
    local c6 = c2 + l_14_2:z() * l_14_5
    local c7 = c3 + l_14_2:z() * l_14_5
    local c8 = c4 + l_14_2:z() * l_14_5
    Application:draw_line(c1, c2, l_14_6, l_14_7, l_14_8)
    Application:draw_line(c1, c3, l_14_6, l_14_7, l_14_8)
    Application:draw_line(c2, c4, l_14_6, l_14_7, l_14_8)
    Application:draw_line(c3, c4, l_14_6, l_14_7, l_14_8)
    Application:draw_line(c1, c5, l_14_6, l_14_7, l_14_8)
    Application:draw_line(c2, c6, l_14_6, l_14_7, l_14_8)
    Application:draw_line(c3, c7, l_14_6, l_14_7, l_14_8)
    Application:draw_line(c4, c8, l_14_6, l_14_7, l_14_8)
    Application:draw_line(c5, c6, l_14_6, l_14_7, l_14_8)
    Application:draw_line(c5, c7, l_14_6, l_14_7, l_14_8)
    Application:draw_line(c6, c8, l_14_6, l_14_7, l_14_8)
    Application:draw_line(c7, c8, l_14_6, l_14_7, l_14_8)
   end
  AppClass.draw_rotation_size = function(l_15_0, l_15_1, l_15_2, l_15_3)
    Application:draw_line(l_15_1, l_15_1 + l_15_2:x() * l_15_3, 1, 0, 0)
    Application:draw_line(l_15_1, l_15_1 + l_15_2:y() * l_15_3, 0, 1, 0)
    Application:draw_line(l_15_1, l_15_1 + l_15_2:z() * l_15_3, 0, 0, 1)
   end
  AppClass.draw_arrow = function(l_16_0, l_16_1, l_16_2, l_16_3, l_16_4, l_16_5, l_16_6)
    if not l_16_6 then
      l_16_6 = 1
    end
    local len = l_16_2 - l_16_1:length()
    local dir = l_16_2 - l_16_1:normalized()
    local arrow_end_pos = l_16_1 + dir * (len - 100 * l_16_6)
    Application:draw_cylinder(l_16_1, arrow_end_pos, 10 * l_16_6, l_16_3, l_16_4, l_16_5)
    Application:draw_cone(l_16_2, arrow_end_pos, 40 * l_16_6, l_16_3, l_16_4, l_16_5)
   end
  AppClass.stack_dump_error = function(l_17_0, ...)
    Application:error(...)
    Application:stack_dump()
     -- DECOMPILER ERROR: Confused about usage of registers for local variables.

   end
end
if Draw then
  Draw:pen()
  Pen.arrow = function(l_18_0, l_18_1, l_18_2, l_18_3)
    if not l_18_3 then
      l_18_3 = 1
    end
    local len = l_18_2 - l_18_1:length()
    local dir = l_18_2 - l_18_1:normalized()
    local arrow_end_pos = l_18_1 + dir * (len - 100 * l_18_3)
    l_18_0:cylinder(l_18_1, arrow_end_pos, 10 * l_18_3)
    l_18_0:cone(l_18_2, arrow_end_pos, 40 * l_18_3)
   end
end

