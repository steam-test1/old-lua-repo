-- Decompiled using luadec 2.0.1 by sztupy (http://winmo.sztupy.hu)
-- Command line was: F:\SteamLibrary\SteamApps\common\PAYDAY 2\lua\core\lib\utils\coremath.luac 

if core then
  core:module("CoreMath")
  core:import("CoreClass")
end
nice = math.nice
rgb_to_hsv = function(l_1_0, l_1_1, l_1_2)
  local max = math.max(l_1_0, l_1_1, l_1_2)
  local min = math.min(l_1_0, l_1_1, l_1_2)
  local hue = 0
  if max == min then
    hue = 0
  elseif max == l_1_0 and l_1_2 <= l_1_1 then
    hue = 60 * (l_1_1 - l_1_2) / (max - min)
  elseif max == l_1_0 and l_1_1 < l_1_2 then
    hue = 60 * (l_1_1 - l_1_2) / (max - min) + 360
  elseif max == l_1_1 then
    hue = 60 * (l_1_2 - l_1_0) / (max - min) + 120
  elseif max == l_1_2 then
    hue = 60 * (l_1_0 - l_1_1) / (max - min) + 240
  end
  hue = math.fmod(hue, 360)
  if max ~= 0 or not 0 then
    local saturation = 1 - min / max
  end
  local value = max
  return hue, saturation, value
end

hsv_to_rgb = function(l_2_0, l_2_1, l_2_2)
  local c = math.floor(l_2_0 / 60)
  local f = l_2_0 / 60 - c
  local p = l_2_2 * (1 - l_2_1)
  local q = l_2_2 * (1 - f * l_2_1)
  local t = l_2_2 * (1 - (1 - f) * l_2_1)
  local cases = {0 = {l_2_2, t, p}, 1 = {q, l_2_2, p}, 2 = {p, l_2_2, t}, 3 = {p, q, l_2_2}, 4 = {t, p, l_2_2}, 5 = {l_2_2, p, q}}
  return unpack(cases[math.fmod(c, 6)])
end

string_to_value = function(l_3_0, l_3_1)
  if l_3_0 == "number" then
    return tonumber(l_3_1)
  elseif l_3_0 == "boolean" then
    return toboolean(l_3_1)
  elseif l_3_0 == "Vector3" then
    return math.string_to_vector(l_3_1)
  elseif l_3_0 == "Rotation" then
    return math.string_to_rotation(l_3_1)
  elseif l_3_0 == "table" then
    return {}
  elseif l_3_0 == "nil" then
    return nil
  end
  return l_3_1
end

vector_to_string = function(l_4_0, l_4_1)
  if l_4_1 then
    local x = string.format(l_4_1, l_4_0.x)
    local y = string.format(l_4_1, l_4_0.y)
    local z = string.format(l_4_1, l_4_0.z)
    return x .. " " .. y .. " " .. z
  end
  return l_4_0.x .. " " .. l_4_0.y .. " " .. l_4_0.z
end

rotation_to_string = function(l_5_0, l_5_1)
  if l_5_1 then
    local x = string.format(l_5_1, l_5_0:yaw())
    local y = string.format(l_5_1, l_5_0:pitch())
    local z = string.format(l_5_1, l_5_0:roll())
    return x .. " " .. y .. " " .. z
  end
  return l_5_0:yaw() .. " " .. l_5_0:pitch() .. " " .. l_5_0:roll()
end

width_mul = function(l_6_0)
  return 0.75 * l_6_0
end

wire_set_midpoint = function(l_7_0, l_7_1, l_7_2, l_7_3)
  local s_pos = l_7_0:get_object(l_7_1):position()
  local e_pos = l_7_0:get_object(l_7_2):position()
  local n = e_pos - s_pos:normalized():cross(Vector3(0, 0, 1))
  local dir = e_pos - s_pos:normalized():cross(n)
  local m_point = s_pos + (e_pos - s_pos) * 0.5
  l_7_0:get_object(l_7_3):set_position(m_point + dir * l_7_0:wire_data().slack)
  local co = l_7_0:get_object(Idstring("co_cable"))
  if co then
    co:set_rotation(Rotation:look_at(e_pos - s_pos:normalized(), math.UP))
  end
end

probability = function(l_8_0, l_8_1)
  local random = math.random(100)
  local total_chance = 0
  local choice = #l_8_0
  for id,chance in ipairs(l_8_0) do
    total_chance = total_chance + chance
    if random <= total_chance then
      choice = id
  else
    end
  end
  if l_8_1 then
    return l_8_1[choice]
  end
  return choice
end

get_fit_size = function(l_9_0, l_9_1, l_9_2, l_9_3)
  local bounding_aspect = l_9_2 / l_9_3
  local aspect = l_9_0 / l_9_1
  if aspect <= bounding_aspect then
    return l_9_2 * aspect / bounding_aspect, l_9_3
  else
    return l_9_2, l_9_3 * bounding_aspect / aspect
  end
end

os.get_oldest_date = function(l_10_0, l_10_1)
  if l_10_1.year < l_10_0.year then
    return l_10_0
  else
    if l_10_0.year < l_10_1.year then
      return l_10_1
    else
      if l_10_1.yday < l_10_0.yday then
        return l_10_0
      else
        if l_10_0.yday < l_10_1.yday then
          return l_10_1
        else
          if l_10_1.hour < l_10_0.hour then
            return l_10_0
          else
            if l_10_0.hour < l_10_1.hour then
              return l_10_1
            else
              if l_10_1.min < l_10_0.min then
                return l_10_0
              else
                if l_10_0.min < l_10_1.min then
                  return l_10_1
                else
                  if l_10_1.sec < l_10_0.sec then
                    return l_10_0
                  else
                    if l_10_0.sec < l_10_1.sec then
                      return l_10_1
                    else
                      return nil
                    end
                  end
                end
              end
            end
          end
        end
      end
    end
  end
end

math.UP = Vector3(0, 0, 1)
math.DOWN = Vector3(0, 0, -1)
math.Z = math.UP
math.X = Vector3(1, 0, 0)
math.Y = Vector3(0, 1, 0)
math.rand = function(l_11_0, l_11_1)
  if l_11_1 then
    return math.random() * (l_11_1 - l_11_0) + l_11_0
  else
    return math.random() * l_11_0
  end
end

math.round = function(l_12_0, l_12_1)
  if not l_12_1 then
    l_12_1 = 1
  end
  return math.floor((l_12_0 + l_12_1 / 2) / l_12_1) * l_12_1
end

math.min_max = function(l_13_0, l_13_1)
  if l_13_0 < l_13_1 then
    return l_13_0, l_13_1
  else
    return l_13_1, l_13_0
  end
end

math.vector_min_max = function(l_14_0, l_14_1)
  local min_x, max_x = math.min_max(l_14_0.x, l_14_1.x)
  local min_y, max_y = math.min_max(l_14_0.y, l_14_1.y)
  local min_z, max_z = math.min_max(l_14_0.z, l_14_1.z)
  local min_vector = Vector3(min_x, min_y, min_z)
  local max_vector = Vector3(max_x, max_y, max_z)
  return min_vector, max_vector
end

math.vector_clamp = function(l_15_0, l_15_1, l_15_2)
  if CoreClass.type_name(l_15_1) ~= "Vector3" then
    l_15_1 = Vector3(l_15_1, l_15_1, l_15_1)
  end
  if CoreClass.type_name(l_15_2) ~= "Vector3" then
    l_15_2 = Vector3(l_15_2, l_15_2, l_15_2)
  end
  return Vector3(math.clamp(l_15_0.x, l_15_1.x, l_15_2.x), math.clamp(l_15_0.y, l_15_1.y, l_15_2.y), math.clamp(l_15_0.z, l_15_1.z, l_15_2.z))
end

math.lerp = function(l_16_0, l_16_1, l_16_2)
  return l_16_0 * (1 - l_16_2) + l_16_1 * l_16_2
end

math.string_to_rotation = function(l_17_0)
  local r = math.string_to_vector(l_17_0)
  return Rotation(r.x, r.y, r.z)
end

math.vector_to_string = function(l_18_0)
  return tostring(l_18_0.x) .. " " .. tostring(l_18_0.y) .. " " .. tostring(l_18_0.z)
end

math.spline = function(l_19_0, l_19_1)
  local mu = l_19_1 * l_19_1
  local a0 = l_19_0[4] - l_19_0[3] - l_19_0[1] + l_19_0[2]
  local a1 = l_19_0[1] - l_19_0[2] - a0
  local a2 = l_19_0[3] - l_19_0[1]
  local a3 = l_19_0[2]
  return a0 * l_19_1 * mu + a1 * mu + a2 * l_19_1 + a3
end

math.spline_len = function(l_20_0, l_20_1)
  local len = 0
  local old_p = l_20_0[1]
  for i = 1, l_20_1 do
    local p = math.spline(l_20_0, i / l_20_1)
    len = len + p - old_p:length()
    old_p = p
  end
  return len
end

math.bezier = function(l_21_0, l_21_1)
  local p1 = l_21_0[1]
  local p2 = l_21_0[2]
  local p3 = l_21_0[3]
  local p4 = l_21_0[4]
  local t_squared = l_21_1 * l_21_1
  local t_cubed = t_squared * l_21_1
  local a1 = p1 * ((1 - l_21_1) * (1 - l_21_1) * (1 - l_21_1))
  local a2 = 3 * p2 * l_21_1 * (1 - l_21_1) * (1 - l_21_1)
  local a3 = 3 * p3 * t_squared * (1 - l_21_1)
  local a4 = p4 * t_cubed
  return a1 + a2 + a3 + a4
end

math.linear_bezier = function(l_22_0, l_22_1)
  local p1 = l_22_0[1]
  local p2 = l_22_0[2]
  return p1 * (1 - l_22_1) + p2 * l_22_1
end

math.quadratic_bezier = function(l_23_0, l_23_1)
  local p1 = l_23_0[1]
  local p2 = l_23_0[2]
  local p3 = l_23_0[3]
  return p1 * ((1 - l_23_1) * (1 - l_23_1)) + p2 * (2 * l_23_1 * (1 - l_23_1)) + p3 * (l_23_1 * l_23_1)
end

math.bezier_len = function(l_24_0, l_24_1)
  local len = 0
  local old_p = l_24_0[1]
  for i = 1, l_24_1 do
    local p = math.bezier(l_24_0, i / l_24_1)
    len = len + p - old_p:length()
    old_p = p
  end
  return len
end

math.point_on_line = function(l_25_0, l_25_1, l_25_2)
  local u = (l_25_2.x - l_25_0.x) * (l_25_1.x - l_25_0.x) + (l_25_2.y - l_25_0.y) * (l_25_1.y - l_25_0.y) + (l_25_2.z - l_25_0.z) * (l_25_1.z - l_25_0.z)
  local u = math.clamp(u / math.pow(l_25_1 - l_25_0:length(), 2), 0, 1)
  local x = l_25_0.x + u * (l_25_1.x - l_25_0.x)
  local y = l_25_0.y + u * (l_25_1.y - l_25_0.y)
  local z = l_25_0.z + u * (l_25_1.z - l_25_0.z)
  return Vector3(x, y, z)
end

math.distance_to_line = function(l_26_0, l_26_1, l_26_2)
  local closest_point = math.point_on_line(l_26_0, l_26_1, l_26_2)
  return closest_point - l_26_2:length(), closest_point
end

math.limitangle = function(l_27_0)
  local newangle = math.fmod(l_27_0, 360)
  if newangle < 0 then
    newangle = newangle + 360
  end
  return newangle
end

math.world_to_obj = function(l_28_0, l_28_1)
  if l_28_0 == nil then
    return l_28_1
  end
  local vec = l_28_1 - l_28_0:position()
  return vec:rotate_with(l_28_0:rotation():inverse())
end

math.obj_to_world = function(l_29_0, l_29_1)
  if l_29_0 == nil then
    return l_29_1
  end
  local vec = l_29_1:rotate_with(l_29_0:rotation())
  return vec + l_29_0:position()
end

math.within = function(l_30_0, l_30_1, l_30_2)
  return l_30_1 <= l_30_0 and l_30_0 <= l_30_2
end


