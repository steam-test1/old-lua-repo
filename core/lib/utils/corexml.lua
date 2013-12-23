-- Decompiled using luadec 2.0.1 by sztupy (http://winmo.sztupy.hu)
-- Command line was: F:\SteamLibrary\SteamApps\common\PAYDAY 2\lua\core\lib\utils\corexml.luac 

core:module("CoreXml")
core:import("CoreClass")
core:import("CoreMath")
simple_value_string = function(l_1_0, l_1_1, l_1_2)
  if not l_1_2 then
    l_1_2 = ""
  end
  local string = l_1_2
  local type = CoreClass.type_name(l_1_1)
  local v = tostring(l_1_1)
  if type == "Vector3" then
    v = CoreMath.vector_to_string(l_1_1, "%.4f")
  elseif type == "Rotation" then
    v = CoreMath.rotation_to_string(l_1_1, "%.4f")
  elseif type == "table" then
    string = string .. "<value name=\"" .. l_1_0 .. "\" type=\"" .. type .. "\">\n"
    string = string .. save_table_value_string(l_1_1, "", l_1_2)
    string = string .. l_1_2 .. "</value>"
    return string
  end
  string = string .. "<value name=\"" .. l_1_0 .. "\" value=\"" .. v .. "\" type=\"" .. type .. "\"/>"
  return string
end

save_value_string = function(l_2_0, l_2_1, l_2_2, l_2_3)
  if not l_2_2 then
    l_2_2 = ""
  end
  local string = l_2_2
  if l_2_1 == "unit:position" then
    l_2_1 = "position"
    l_2_0[l_2_1] = l_2_3:position()
  end
  if l_2_1 == "unit:rotation" then
    l_2_1 = "rotation"
    l_2_0[l_2_1] = l_2_3:rotation()
  end
  local type = CoreClass.type_name(l_2_0[l_2_1])
  local v = tostring(l_2_0[l_2_1])
  if type == "Vector3" then
    v = CoreMath.vector_to_string(l_2_0[l_2_1], "%.4f")
  elseif type == "Rotation" then
    v = CoreMath.rotation_to_string(l_2_0[l_2_1], "%.4f")
  elseif type == "table" then
    string = string .. "<value name=\"" .. l_2_1 .. "\" type=\"" .. type .. "\">\n"
    string = string .. save_table_value_string(l_2_0[l_2_1], "", l_2_2)
    string = string .. l_2_2 .. "</value>"
    return string
  end
  string = string .. "<value name=\"" .. l_2_1 .. "\" value=\"" .. v .. "\" type=\"" .. type .. "\"/>"
  return string
end

save_table_value_string = function(l_3_0, l_3_1, l_3_2)
  l_3_2 = l_3_2 .. "\t"
  for i,value in pairs(l_3_0) do
    local type = CoreClass.type_name(value)
    local v = tostring(value)
    if type == "table" then
      l_3_1 = l_3_1 .. l_3_2 .. "<value name=\"" .. i .. "\" type=\"" .. type .. "\">\n"
      l_3_1 = l_3_1 .. save_table_value_string(value, "", l_3_2)
      l_3_1 = l_3_1 .. l_3_2 .. "</value>\n"
      for (for control),i in (for generator) do
      end
      if type == "Vector3" then
        v = CoreMath.vector_to_string(value, "%.4f")
      elseif type == "Rotation" then
        v = CoreMath.rotation_to_string(value, "%.4f")
      end
      l_3_1 = l_3_1 .. l_3_2 .. "<value name=\"" .. i .. "\" value=\"" .. v .. "\" type=\"" .. type .. "\"/>\n"
    end
    return l_3_1
     -- Warning: missing end command somewhere! Added here
  end
end

parse_values_node = function(l_4_0)
  local t = {}
  for node_value in l_4_0:children() do
    local name, value = parse_value_node(node_value)
    t[name] = value
  end
  return t
end

parse_value_node = function(l_5_0)
  local value_name = l_5_0:parameter("name")
  local type = l_5_0:parameter("type")
  if type == "table" then
    local t = {}
    for table_node in l_5_0:children() do
      local name = table_node:parameter("name")
       -- DECOMPILER ERROR: Confused while interpreting a jump as a 'while'

    end
    local _, value = parse_value_node(table_node)
    t[name] = value
  end
  return value_name, t
end
local val = l_5_0:parameter("value")
return value_name, CoreMath.string_to_value(type, val)
end


