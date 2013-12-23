-- Decompiled using luadec 2.0.1 by sztupy (http://winmo.sztupy.hu)
-- Command line was: F:\SteamLibrary\SteamApps\common\PAYDAY 2\lua\core\lib\utils\corecode.luac 

core:module("CoreCode")
core:import("CoreTable")
core:import("CoreDebug")
core:import("CoreClass")
core:import("CoreApp")
local open_lua_source_file = function(l_1_0)
  if DB:is_bundled() then
    return "[N/A in bundle]"
  end
  local entry_type = Idstring("lua_source")
  local entry_name = l_1_0:match("([^.]*)"):lower()
  return DB:has(entry_type, entry_name:id()) and DB:open(entry_type, entry_name:id()) or nil
end

get_prototype = function(l_2_0)
  if l_2_0.source == "=[C]" then
    return "(C++ method)"
  end
  local prototype = l_2_0.source
  local source_file = open_lua_source_file(l_2_0.source)
  if source_file then
    for i = 1, l_2_0.linedefined do
      prototype = source_file:gets()
    end
    source_file:close()
  end
  return prototype
end

get_source = function(l_3_0)
  if l_3_0.source == "=[C]" then
    return "(C++ method)"
  end
  local source_file = open_lua_source_file(l_3_0.source)
  local lines = {}
  for i = 1, l_3_0.linedefined - 1 do
    local line = source_file:gets()
    if line:match("^%s*%-%-") then
      table.insert(lines, line)
    else
      lines = {}
    end
  end
  for i = l_3_0.linedefined, l_3_0.lastlinedefined do
    table.insert(lines, source_file:gets())
  end
  source_file:close()
  return table.concat(lines, "\n")
end

traceback = function(l_4_0)
  if not l_4_0 then
    l_4_0 = 2
  end
  local level = 2
  repeat
    local info = debug.getinfo(level, "Sl")
    if info then
      if l_4_0 + 2 <= level then
        do return end
      end
      if info.what == "C" then
        CoreDebug.cat_print("debug", level, "C function")
      else
        CoreDebug.cat_print("debug", string.format("[%s]:%d", info.source, info.currentline))
      end
      level = level + 1
    else
       -- Warning: missing end command somewhere! Added here
    end
     -- Warning: missing end command somewhere! Added here
  end
end

alive = function(l_5_0)
  if l_5_0 and l_5_0:alive() then
    return true
  end
  return false
end

deprecation_warning = function(l_6_0, l_6_1)
  CoreDebug.cat_print("debug", string.format("DEPRECATION WARNING: %s will be removed in %s", l_6_0, l_6_1 or "a future release"))
end

local sort_iterator = function(l_7_0, l_7_1)
  local sorted = {}
  for k,v in pairs(l_7_0) do
    sorted[#sorted + 1] = k
  end
  table.sort(sorted, function(l_1_0, l_1_1)
    if type(l_1_1) == "number" then
      if l_1_0 >= l_1_1 then
        return type(l_1_0) ~= "number"
      end
    else
      return true
      do return end
      if type(l_1_1) == "number" then
        return false
      end
    end
    return tostring(l_1_0) < tostring(l_1_1)
   end)
  local index = 0
  return function()
    index = index + 1
    local k = sorted[index]
    if raw then
      return k, rawget(t, k)
    else
      return k, t[k]
    end
   end
end

line_representation = function(l_8_0, l_8_1, l_8_2)
  if DB:is_bundled() then
    return "[N/A in bundle]"
  end
  local w = 60
  if type(l_8_0) == "userdata" then
    return tostring(l_8_0)
  else
    if type(l_8_0) == "table" then
      if not l_8_1 then
        l_8_1 = {}
      end
      if l_8_1[l_8_0] then
        return "..."
      end
      l_8_1[l_8_0] = true
      local r = "{"
      for k,v in sort_iterator(l_8_0, l_8_2) do
        r = r .. line_representation(k, l_8_1, l_8_2) .. "=" .. line_representation(v, l_8_1, l_8_2) .. ", "
        if w < r:len() then
          r = r:sub(1, w)
          r = r .. "..."
      else
        end
      end
      r = r .. "}"
      return r
    else
      if type(l_8_0) == "string" then
        l_8_0 = string.gsub(l_8_0, "\n", "\\n")
        l_8_0 = string.gsub(l_8_0, "\r", "\\r")
        l_8_0 = string.gsub(l_8_0, "\t", "\\t")
        if w < l_8_0:len() then
          l_8_0 = l_8_0:sub(1, w) .. "..."
        end
        return l_8_0
      else
        if type(l_8_0) == "function" then
          local info = debug.getinfo(l_8_0)
          if info.source == "=[C]" then
            return "(C++ method)"
          else
            return line_representation((get_prototype(info)), nil, l_8_2)
          end
        else
          return tostring(l_8_0)
        end
      end
    end
  end
end

full_representation = function(l_9_0, l_9_1)
  if DB:is_bundled() then
    return "[N/A in bundle]"
  end
  if type(l_9_0) == "function" then
    local info = debug.getinfo(l_9_0)
    return get_source(info)
  else
    if type(l_9_0) == "table" then
      return ascii_table(l_9_0, true)
    else
      return tostring(l_9_0)
    end
     -- Warning: missing end command somewhere! Added here
  end
end

inspect = full_representation
properties = function(l_10_0)
  local t = {}
  for i,p in ipairs(l_10_0.__properties) do
    t[p] = l_10_0[p](l_10_0)
  end
  CoreDebug.cat_print("debug", ascii_table(t))
end

help = function(l_11_0)
  local methods = {}
  local add_methods = function(l_1_0)
    if type(l_1_0) == "table" then
      for k,v in pairs(l_1_0) do
        if type(v) == "function" then
          local info = debug.getinfo(v, "S")
          if info.source ~= "=[C]" then
            local h = get_prototype(info)
            local name = k
            k = nil
            if h:match("= function") then
              k = name
            end
            if not k then
              k = h:match(":(.*)")
            end
            if not k then
              k = h:match("%.(.*)")
            end
            if not k then
              k = h
            end
          end
          k = k .. string.rep(" ", 40 - #k)
          if info.what == "Lua" then
            k = k .. "(" .. info.source .. ":" .. info.linedefined .. ")"
          else
            k = k .. "(C++ function)"
          end
          methods[k] = true
        end
      end
    end
    if getmetatable(l_1_0) then
      add_methods(getmetatable(l_1_0))
    end
   end
  add_methods(l_11_0)
  local sorted_methods = {}
  for k,v in pairs(methods) do
    table.insert(sorted_methods, k)
  end
  table.sort(sorted_methods)
  for i,name in ipairs(sorted_methods) do
    CoreDebug.cat_print("debug", name)
  end
end

ascii_table = function(l_12_0, l_12_1)
  local out = ""
  local klen = 20
  local vlen = 20
  for k,v in pairs(l_12_0) do
    local kl = line_representation(k, nil, l_12_1):len() + 2
    local vl = line_representation(v, nil, l_12_1):len() + 2
    if klen < kl then
      klen = kl
    end
    if vlen < vl then
      vlen = vl
    end
  end
  out = out .. "-":rep(klen + vlen + 5) .. "\n"
  for k,v in sort_iterator(l_12_0, l_12_1) do
    out = out .. "| " .. line_representation(k, nil, l_12_1):left(klen) .. "| " .. line_representation(v, nil, l_12_1):left(vlen) .. "|\n"
  end
  out = out .. "-":rep(klen + vlen + 5) .. "\n"
  return out
end

memory_report = function(l_13_0)
  local seen = {}
  local count = {}
  local name = {_G = _G}
  for k,v in pairs(_G) do
    if type(v) ~= "userdata" or not v:key() then
      name[(type(v) ~= "userdata" or not v.key) and type(v) == "userdata" or v] = k
    end
  end
  local simple = function(l_1_0)
    local t = type(l_1_0)
    if t == "table" then
      return false
    end
    if t == "userdata" then
      return getmetatable(t)
    end
    return true
   end
  local recurse = function(l_2_0, l_2_1, l_2_2)
    local index = type(l_2_0) == "userdata" and l_2_0:key() or l_2_0
    if seen[index] then
      return 
    end
    seen[index] = true
    if not name[index] and not name[getmetatable(l_2_0)] then
      local t = l_2_1 .. "/" .. l_2_2
    end
    count[t] = (count[t] or 0) + 1
    if type(l_2_0) == "table" then
      for k,v in pairs(l_2_0) do
        count[t .. "/*"] = (count[t .. "/*"] or 0) + 1
        if not simple(v) and not seen[v] then
          recurse(v, t, tostring(k))
        end
      end
    end
    if CoreClass.type_name(l_2_0) == "Unit" then
      for _,e in ipairs(l_2_0:extensions()) do
        recurse(l_2_0[e](l_2_0), t, e)
      end
    end
    if getmetatable(l_2_0) and not seen[getmetatable(l_2_0)] then
      recurse(getmetatable(l_2_0), t, "metatable")
    end
   end
  recurse(_G, nil, nil)
  local units = World:unit_manager():get_units()
  local is_windows = SystemInfo:platform() == Idstring("win32")
  for _,u in ipairs(units) do
    if not is_windows or not u:name():s() then
      recurse(u, "Units", u:name(), u)
    end
  end
  local total = 0
  local res = {}
  for k,v in pairs(count) do
    total = total + v
    if l_13_0 or 100 < v then
      res[#res + 1] = string.format("%6i  %s", v, k)
    end
  end
  table.sort(res)
  for _,l in ipairs(res) do
    CoreDebug.cat_print("debug", l)
  end
  CoreDebug.cat_print("debug", string.format("\n%6i  TOTAL", total))
end

if not __old_profiled then
  __old_profiled = {}
end
if __profiled then
  __old_profiled = __profiled
  for k,v in pairs(__profiled) do
    Application:console_command("profiler remove " .. k)
  end
end
__profiled = {}
profile = function(l_14_0)
  if __profiled[l_14_0] then
    return 
  end
  local t = {}
  t.s = l_14_0
  local start, stop = l_14_0:find(":")
  if start then
    t.class = l_14_0:sub(0, start - 1)
    t.name = l_14_0:sub(stop + 1)
    if not rawget(_G, t.class) then
      CoreDebug.cat_print("debug", "Could not find class " .. t.class)
      return 
    end
    t.f = rawget(_G, t.class)[t.name]
    t.patch = function(l_1_0)
      _G[t.class][t.name] = l_1_0
      end
  else
    t.name = l_14_0
    t.f = rawget(_G, t.name)
    t.patch = function(l_2_0)
      _G[t.name] = l_2_0
      end
  end
  if not t.f or type(t.f) ~= "function" then
    CoreDebug.cat_print("debug", "Could not find function " .. l_14_0)
    return 
  end
  t.instrumented = function(...)
    do
      local id = Profiler:start(t.s)
      res = t.f(...)
      Profiler:stop(id)
      return res
    end
     -- DECOMPILER ERROR: Confused about usage of registers for local variables.

   end
  t.patch(t.instrumented)
  __profiled[l_14_0] = t
  Application:console_command("profiler add " .. l_14_0)
end

unprofile = function(l_15_0)
  local t = __profiled[l_15_0]
  if t then
    t.patch(t.f)
  end
  Application:console_command("profiler remove " .. l_15_0)
  __profiled[l_15_0] = nil
end

reprofile = function()
  for k,v in pairs(__old_profiled) do
    profile(k)
  end
  __old_profiled = {}
end


