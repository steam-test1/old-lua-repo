-- Decompiled using luadec 2.0.1 by sztupy (http://winmo.sztupy.hu)
-- Command line was: F:\SteamLibrary\SteamApps\common\PAYDAY 2\lua\core\lib\utils\coretable.luac 

core:module("CoreTable")
core:import("CoreClass")
core:import("CoreDebug")
clone = function(l_1_0)
  local res = {}
  for k,v in pairs(l_1_0) do
    res[k] = v
  end
  setmetatable(res, getmetatable(l_1_0))
  return res
end

deep_clone = function(l_2_0)
  if type(l_2_0) == "userdata" then
    return l_2_0
  end
  do
    local res = {}
    setmetatable(res, getmetatable(l_2_0))
    for k,v in pairs(l_2_0) do
      if type(v) == "table" then
        res[k] = deep_clone(v)
        for (for control),k in (for generator) do
        end
        res[k] = v
      end
      return res
    end
     -- Warning: missing end command somewhere! Added here
  end
end

dpairs = function(l_3_0)
  if type(table) ~= "table" then
    error("Expected table got", type(l_3_0))
  end
  local t = l_3_0
  local i = 0
  local last_size = #t
  return function()
    if last_size == #t then
      upvalue_1024 = i + 1
    end
    local v = t[i]
    if v then
      last_size = #t
      return i, v
    end
   end
end

table.tuple_iterator = function(l_4_0, l_4_1)
  local index = 1 - l_4_1
  local count = #l_4_0
  return function()
    index = index + n
    if index <= count then
      return unpack(v, index, index + n - 1)
    end
   end
end

table.sorted_map_iterator = function(l_5_0, l_5_1)
  local sorted_keys = table.map_keys(l_5_0)
  local index = 0
  local count = #sorted_keys
  table.sort(sorted_keys, l_5_1)
  return function()
    index = index + 1
    if index <= count then
      local key = sorted_keys[index]
      return key, map[key]
    end
   end
end

table.map_copy = function(l_6_0)
  local copy = {}
  for k,v in pairs(l_6_0) do
    copy[k] = v
  end
  return copy
end

table.list_copy = function(l_7_0)
  local copy = {}
  for k,v in ipairs(l_7_0) do
    copy[k] = v
  end
  return copy
end

table.get_vector_index = function(l_8_0, l_8_1)
  for index,value in ipairs(l_8_0) do
    if value == l_8_1 then
      return index
    end
  end
end

table.delete = function(l_9_0, l_9_1)
  local index = table.get_vector_index(l_9_0, l_9_1)
  if index then
    table.remove(l_9_0, index)
  end
end

table.exclude = function(l_10_0, l_10_1)
  local filtered = {}
  for _,v in ipairs(l_10_0) do
    if v ~= l_10_1 then
      table.insert(filtered, v)
    end
  end
  return filtered
end

table.equals = function(l_11_0, l_11_1, l_11_2)
  if not l_11_2 then
    l_11_2 = function(l_1_0, l_1_1)
    return l_1_0 == l_1_1
   end
  end
  local size_a = 0
  for k,v in pairs(l_11_0) do
    size_a = size_a + 1
    if l_11_2(v, l_11_1[k]) == false then
      return false
    end
  end
  return size_a == table.size(l_11_1)
end

table.contains = function(l_12_0, l_12_1)
  for _,value in pairs(l_12_0) do
    if value == l_12_1 then
      return true
    end
  end
  return false
end

table.index_of = function(l_13_0, l_13_1)
  for index,value in ipairs(l_13_0) do
    if value == l_13_1 then
      return index
    end
  end
  return -1
end

table.get_key = function(l_14_0, l_14_1)
  for key,value in pairs(l_14_0) do
    if value == l_14_1 then
      return key
    end
  end
  return nil
end

table.has = function(l_15_0, l_15_1)
  for key,_ in pairs(l_15_0) do
    if key == l_15_1 then
      return true
    end
  end
  return false
end

table.size = function(l_16_0)
  local i = 0
  for _,_ in pairs(l_16_0) do
    i = i + 1
  end
  return i
end

table.empty = function(l_17_0)
  return not next(l_17_0)
end

table.random = function(l_18_0)
  return l_18_0[math.random(#l_18_0)]
end

table.concat_map = function(l_19_0, l_19_1, l_19_2, l_19_3, l_19_4, l_19_5)
  local count = 0
  local func = function()
    return none_string
   end
  if not l_19_3 then
    l_19_3 = "\""
  end
  if not l_19_4 then
    l_19_4 = ", "
  end
  if not l_19_5 then
    l_19_5 = " and "
  end
  for key,value in pairs(l_19_0) do
    local last_func = func
    do
      local append_string = nil
      if l_19_1 then
        append_string = tostring(value)
      else
        append_string = tostring(key)
      end
      func = function(l_2_0, l_2_1)
        if l_2_0 == 1 then
          return wrap .. append_string .. wrap
        elseif l_2_1 then
          return last_func(l_2_0 - 1, false) .. last_sep .. wrap .. append_string .. wrap
        else
          return last_func(l_2_0 - 1, false) .. sep .. wrap .. append_string .. wrap
        end
         end
      count = count + 1
    end
  end
  return func(count, true)
end

table.ordering = function(l_20_0)
  return function(l_1_0, l_1_1)
    local a_index = table.get_vector_index(prioritized_order_list, l_1_0)
    local b_index = table.get_vector_index(prioritized_order_list, l_1_1)
    if l_1_0 >= l_1_1 then
      return a_index ~= nil or b_index ~= nil
    end
    do return end
    if b_index ~= nil then
      return not a_index and not b_index
    end
    do return end
    return a_index < b_index
   end
end

table.sorted_copy = function(l_21_0, l_21_1)
  local sorted_copy = {}
  for _,value in ipairs(l_21_0) do
    table.insert(sorted_copy, value)
  end
  table.sort(sorted_copy, l_21_1)
  return sorted_copy
end

table.find_value = function(l_22_0, l_22_1)
  for _,value in ipairs(l_22_0) do
    if l_22_1(value) then
      return value
    end
  end
end

table.find_all_values = function(l_23_0, l_23_1)
  local matches = {}
  for _,value in ipairs(l_23_0) do
    if l_23_1(value) then
      table.insert(matches, value)
    end
  end
  return matches
end

table.true_for_all = function(l_24_0, l_24_1)
  for key,value in pairs(l_24_0) do
    if not l_24_1(value, key) then
      return false
    end
  end
  return true
end

table.collect = function(l_25_0, l_25_1)
  local result = {}
  for key,value in pairs(l_25_0) do
    result[key] = l_25_1(value)
  end
  return result
end

table.inject = function(l_26_0, l_26_1, l_26_2)
  local result = l_26_1
  for _,value in ipairs(l_26_0) do
    result = l_26_2(result, value)
  end
  return result
end

table.insert_sorted = function(l_27_0, l_27_1, l_27_2)
  if l_27_1 == nil then
    return 
  end
  if not l_27_2 then
    l_27_2 = function(l_1_0, l_1_1)
    return l_1_0 < l_1_1
   end
  end
  local index = 1
  do
    local examined_item = l_27_0[index]
    repeat
      if examined_item and l_27_2(examined_item, l_27_1) then
        index = index + 1
        examined_item = l_27_0[index]
      else
        table.insert(l_27_0, index, l_27_1)
      end
       -- Warning: missing end command somewhere! Added here
    end
     -- Warning: missing end command somewhere! Added here
  end
end

table.for_each_value = function(l_28_0, l_28_1)
  for _,value in ipairs(l_28_0) do
    l_28_1(value)
  end
end

table.range = function(l_29_0, l_29_1)
  local range = {}
  for i = l_29_0, l_29_1 do
    table.insert(range, i)
  end
  return range
end

table.unpack_sparse = function(l_30_0)
  if not table.__unpack_sparse_implementations then
    table.__unpack_sparse_implementations = {}
  end
  local count = 0
  for index,_ in pairs(l_30_0) do
    count = math.max(count, index)
  end
  local func = table.__unpack_sparse_implementations[count]
  if func == nil then
    local return_values = table.collect(table.range(1, count), function(l_1_0)
    return "__list__[" .. l_1_0 .. "]"
   end)
    local return_value_string = table.concat(return_values, ", ")
    local code = "return function( __list__ ) return " .. return_value_string .. " end"
    func = assert(loadstring(code))()
    table.__unpack_sparse_implementations[count] = func
  end
  return func(l_30_0)
end

table.unpack_map = function(l_31_0)
  return unpack(table.map_to_list(l_31_0))
end

table.map_to_list = function(l_32_0)
  local list = {}
  for k,v in pairs(l_32_0) do
    table.insert(list, k)
    table.insert(list, v)
  end
  return list
end

table.map_keys = function(l_33_0, l_33_1)
  local keys = {}
  for key,_ in pairs(l_33_0) do
    table.insert(keys, key)
  end
  table.sort(keys, l_33_1)
  return keys
end

table.map_values = function(l_34_0, l_34_1)
  local values = {}
  for _,value in pairs(l_34_0) do
    table.insert(values, value)
  end
  if l_34_1 ~= nil then
    table.sort(values, l_34_1)
  end
  return values
end

table.remap = function(l_35_0, l_35_1)
  local result = {}
  for k,v in pairs(l_35_0) do
    result_k, result_v = l_35_1(k, v), k
    result[result_k] = result_v
  end
  return result
end

table.list_add = function(...)
  do
    local result = {}
    for _,list_table in ipairs({...}) do
      for _,value in ipairs(list_table) do
        table.insert(result, value)
      end
    end
    return result
  end
   -- DECOMPILER ERROR: Confused about usage of registers for local variables.

end

table.list_union = function(...)
  local unique = {}
  for _,list_table in ipairs({...}) do
    for _,value in ipairs(list_table) do
      unique[value] = true
    end
  end
  do
    local result = {}
    for key,_ in pairs(unique) do
      table.insert(result, key)
    end
    return result
  end
   -- DECOMPILER ERROR: Confused about usage of registers for local variables.

end

table.print_data = function(l_38_0, l_38_1)
  if type(l_38_0) == "table" then
    if not l_38_1 then
      l_38_1 = ""
    end
    for k,v in pairs(l_38_0) do
      if type(v) ~= "userdata" then
        CoreDebug.cat_debug("debug", l_38_1 .. tostring(k) .. "=" .. tostring(v))
      else
        CoreDebug.cat_debug("debug", l_38_1 .. tostring(k) .. "=" .. CoreClass.type_name(v))
      end
      if type(v) == "table" then
        table.print_data(v, l_38_1 .. "\t")
      end
    end
  else
    CoreDebug.cat_debug("debug", CoreClass.type_name(l_38_0), tostring(l_38_0))
  end
end

if Application:ews_enabled() then
  local __lua_representation, __write_lua_representation_to_file = nil, nil
  do
    __lua_representation = function(l_39_0)
      local t = type(l_39_0)
      if t == "string" then
        return string.format("%q", l_39_0)
      elseif t == "number" or t == "boolean" then
        return tostring(l_39_0)
      else
        error("Unable to generate Lua representation of type \"" .. t .. "\".")
      end
      end
    __write_lua_representation_to_file = function(l_40_0, l_40_1, l_40_2)
      if not l_40_2 then
        l_40_2 = 1
      end
      local t = type(l_40_0)
      if t == "table" then
        local indent = string.rep("\t", l_40_2)
        l_40_1:write("{\n")
        for key,value in pairs(l_40_0) do
          assert(type(key) ~= "table", "Using a table for a key is unsupported.")
          l_40_1:write(indent .. "[" .. __lua_representation(key) .. "] = ")
          __write_lua_representation_to_file(value, l_40_1, l_40_2 + 1)
          l_40_1:write(";\n")
        end
        l_40_1:write(string.rep("\t", l_40_2 - 1) .. "}")
      elseif t == "string" or t == "number" or t == "boolean" then
        l_40_1:write(__lua_representation(l_40_0))
      else
        error("Unable to generate Lua representation of type \"" .. t .. "\".")
      end
      end
    write_lua_representation_to_path = function(l_41_0, l_41_1)
      assert(type(l_41_1) == "string", "Invalid path argument. Expected string.")
      local file = io.open(l_41_1, "w")
      file:write("return ")
      __write_lua_representation_to_file(l_41_0, file)
      file:close()
      end
    read_lua_representation_from_path = function(l_42_0)
      assert(type(l_42_0) == "string", "Invalid path argument. Expected string.")
      local file = io.open(l_42_0, "r")
      if file then
        local script = file:read("*a")
      end
      file:close()
      if not script or not loadstring(script)() then
        return {}
      end
      end
  end
end

