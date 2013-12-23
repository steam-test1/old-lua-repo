-- Decompiled using luadec 2.0.1 by sztupy (http://winmo.sztupy.hu)
-- Command line was: F:\SteamLibrary\SteamApps\common\PAYDAY 2\lua\core\lib\utils\corestring.luac 

core:module("CoreString")
utf8.find_char = function(l_1_0, l_1_1)
  for i,c in ipairs(utf8.characters(l_1_0)) do
    if c == l_1_1 then
      return i
    end
  end
end

string.begins = function(l_2_0, l_2_1)
  if l_2_0:sub(1, #l_2_1) ~= l_2_1 then
    return not l_2_0 or not l_2_1
  end
  return false
end

string.ends = function(l_3_0, l_3_1)
  if #l_3_1 ~= 0 and l_3_0:sub(-#l_3_1) ~= l_3_1 then
    return not l_3_0 or not l_3_1
  end
  return false
end

string.case_insensitive_compare = function(l_4_0, l_4_1)
  return string.lower(l_4_0) < string.lower(l_4_1)
end

string.split = function(l_5_0, l_5_1, l_5_2, l_5_3)
  local result = {}
  local pattern = "(.-)" .. l_5_1 .. "()"
  local count = 0
  local final_match_end_index = 0
  for part,end_index in string.gmatch(l_5_0, pattern) do
    final_match_end_index = end_index
    if l_5_2 or part ~= "" then
      count = count + 1
      result[count] = part
  else
    if count == l_5_3 then
      end
    end
    do
      local remainder = string.sub(l_5_0, final_match_end_index)
      result[count + 1] = (l_5_2 or remainder ~= "") and remainder or nil
      return result
    end
     -- Warning: missing end command somewhere! Added here
  end
end

string.join = function(l_6_0, l_6_1, l_6_2)
  local strings = table.collect(l_6_1, function(l_1_0)
    local as_string = tostring(l_1_0)
    if as_string ~= "" or keep_empty then
      return as_string
    end
   end)
  return table.concat(strings, l_6_0)
end

string.trim = function(l_7_0, l_7_1)
  if not l_7_1 then
    l_7_1 = "%s*"
  end
  return string.match(l_7_0, "^" .. l_7_1 .. "(.-)" .. l_7_1 .. "$")
end

string.capitalize = function(l_8_0)
  return string.gsub(l_8_0, "(%w)(%w*)", function(l_1_0, l_1_1)
    return string.upper(l_1_0) .. string.lower(l_1_1)
   end)
end

string.pretty = function(l_9_0, l_9_1)
  local pretty = string.gsub(l_9_0, "%W", " ")
  return l_9_1 and string.capitalize(pretty) or pretty
end

string.rep = function(l_10_0, l_10_1)
  local out = ""
  for i = 1, l_10_1 do
    out = out .. l_10_0
  end
  return out
end

string.left = function(l_11_0, l_11_1)
  return l_11_0 .. " ":rep(l_11_1 - l_11_0:len())
end


