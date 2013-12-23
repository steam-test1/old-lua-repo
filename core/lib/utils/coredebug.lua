-- Decompiled using luadec 2.0.1 by sztupy (http://winmo.sztupy.hu)
-- Command line was: F:\SteamLibrary\SteamApps\common\PAYDAY 2\lua\core\lib\utils\coredebug.luac 

core:module("CoreDebug")
core:import("CoreCode")
core:import("CoreApp")
if not Global.render_debug then
  Global.render_debug = {}
end
if not Global.render_debug_initialized then
  Global.render_debug_initialized = {}
end
if not Global.render_debug_initialized.coredebug then
  Global.render_debug.draw_enabled = true
  Global.render_debug.render_sky = true
  Global.render_debug.render_world = true
  Global.render_debug.render_overlay = true
  Global.render_debug_initialized.coredebug = true
end
only_in_debug = function(l_1_0, l_1_1)
  if not l_1_1 then
    l_1_1 = getmetatable(Application)
  end
  local old = "old_" .. l_1_0
  if not l_1_1[old] then
    l_1_1[old] = l_1_1[l_1_0]
    l_1_1[l_1_0] = function(...)
      if Global.render_debug.draw_enabled then
        klass[old](...)
         -- DECOMPILER ERROR: Confused about usage of registers for local variables.

      end
      end
  end
end

only_in_debug("draw")
only_in_debug("draw_sphere")
only_in_debug("draw_line")
only_in_debug("draw_cone")
only_in_debug("draw_circle")
only_in_debug("draw_rotation")
only_in_debug("draw_cylinder")
only_in_debug("draw_line_unpaused")
only_in_debug("draw_sphere_unpaused")
only_in_debug("draw_rotation_size")
only_in_debug("draw_arrow")
only_in_debug("draw_link")
only_in_debug("arrow", Pen)
if not Global.category_print then
  Global.category_print = {}
end
if not Global.category_print_initialized then
  Global.category_print_initialized = {}
end
if not Global.category_print_initialized.coredebug then
  Global.category_print.debug = true
  Global.category_print.editor = false
  Global.category_print.sequence = false
  Global.category_print.controller_manager = false
  Global.category_print.game_state_machine = false
  Global.category_print.subtitle_manager = false
  Global.category_print_initialized.coredebug = true
end
out = function(...)
  local CAT_TYPE = "debug"
  local NO_CAT = "spam"
  local args = {...}
  local correct_spaces = function(...)
    local args = {...}
     -- DECOMPILER ERROR: No list found. Setlist fails

    do
      local sel = {}
       -- DECOMPILER ERROR: Overwrote pending register.

      sel[1] = select(2, ...) .. " " .. tostring(sel[1])
      return unpack(sel)
    end
     -- DECOMPILER ERROR: Confused about usage of registers for local variables.

   end
  do
    local do_print = function(l_2_0, ...)
    local cat = CAT_TYPE
    do
      local args = {...}
      for k,_ in pairs(Global.category_print) do
        if k == l_2_0 then
          cat = l_2_0
      else
        end
      end
      cat_print(cat, ...)
    end
     -- DECOMPILER ERROR: Confused about usage of registers for local variables.

   end
    if #args == 0 then
      return 
    elseif #args > 1 and type(args[1]) == "string" then
      local a = args[1]
      args[1] = "[" .. a .. "]"
      do_print(a, correct_spaces(unpack(args)))
    else
      do_print(NO_CAT, correct_spaces("[" .. NO_CAT .. "]", unpack(args)))
    end
     -- DECOMPILER ERROR: Confused about usage of registers for local variables.

  end
end

cat_print = function(l_3_0, ...)
  if Global.category_print[l_3_0] then
    _G.print(...)
     -- DECOMPILER ERROR: Confused about usage of registers for local variables.

  end
end

cat_debug = function(l_4_0, ...)
  if Global.category_print[l_4_0] then
    Application:debug(...)
     -- DECOMPILER ERROR: Confused about usage of registers for local variables.

  end
end

cat_error = function(l_5_0, ...)
  if Global.category_print[l_5_0] then
    Application:error(...)
     -- DECOMPILER ERROR: Confused about usage of registers for local variables.

  end
end

cat_stack_dump = function(l_6_0)
  if Global.category_print[l_6_0] then
    Application:stack_dump()
  end
end

cat_print_inspect = function(l_7_0, ...)
  if Global.category_print[l_7_0] then
    for _,var in ipairs({...}) do
      cat_print(l_7_0, CoreCode.inspect(var))
    end
     -- DECOMPILER ERROR: Confused about usage of registers for local variables.

  end
end

cat_debug_inspect = function(l_8_0, ...)
  if Global.category_print[l_8_0] then
    for _,var in ipairs({...}) do
      cat_debug(l_8_0, "\n" .. tostring(CoreCode.inspect(var)))
    end
     -- DECOMPILER ERROR: Confused about usage of registers for local variables.

  end
end

catprint_save = function()
  local data = {_meta = "categories"}
  for name,allow_print in pairs(Global.category_print) do
    if Global.original_category_print[name] ~= allow_print then
      table.insert(data, {_meta = "category", name = name, print = allow_print})
    end
  end
  local path = managers.database:base_path() .. "settings/catprint.catprint"
  local file = SystemFS:open(path, "w")
  file:print(ScriptSerializer:to_custom_xml(data))
  file:close()
end

catprint_load = function()
  if not Global.original_category_print then
    Global.original_category_print = {}
    for category,default in pairs(Global.category_print) do
      Global.original_category_print[category] = default
    end
  end
  local file_path = "settings/catprint"
  local file_extension = "catprint"
  if DB:has(file_extension, file_path) then
    local xml = DB:open(file_extension, file_path):read()
    local data = ScriptSerializer:from_custom_xml(xml)
    for _,sub_data in ipairs(data) do
      local name = tostring(sub_data.name)
      local allow_print = sub_data.print == true
      Global.category_print[name] = allow_print
    end
  end
end

print_console_result = function(...)
  for i = 1, select("#", ...) do
    cat_print("debug", CoreCode.full_representation(select(i, ...)))
  end
   -- DECOMPILER ERROR: Confused about usage of registers for local variables.

end

compile_and_reload = function()
  local root_path = function()
    local path = Application:base_path() .. (CoreApp.arg_value("-assetslocation") or "../../")
    local f = nil
    f = function(l_1_0)
      local str, i = string.gsub(l_1_0, "\\[%w_%.%s]+\\%.%.", "")
      return i > 0 and f(str) or str
      end
    return f(path)
   end
  assert(SystemInfo:platform() == Idstring("WIN32"), "You can only compile on win32 platforms!")
  Application:data_compile({platform = "win32", source_root = root_path() .. "//assets", target_db_root = Application:base_path() .. "//assets", target_db_name = "all", verbose = false})
  DB:reload()
  Application:console_command("reload")
end

class_name = function(l_13_0)
  return core:_lookup(l_13_0)
end

full_class_name = function(l_14_0)
  local x, y = class_name(l_14_0)
  return y .. "." .. x
end

watch = function(l_15_0, l_15_1)
  debug.sethook(function()
    if exact then
      if not rawget(_G, "__watch_previnfo") then
        cat_print("debug", string.format("[CoreVarTrace] %s", not cond_func() or "? : -1"))
      end
    else
      local src = debug.getinfo(2, "Sl")
      cat_print("debug", "[CoreVarTrace] Probably file: " .. (src and src.source or "?"))
      cat_print("debug", "[CoreVarTrace] Might be line: " .. (src and src.currentline or -1))
    end
    cat_print("debug", debug.traceback())
    debug.sethook()
    if exact then
      local src = debug.getinfo(2, "Sl")
      rawset(_G, "__watch_previnfo", string.format("%s : %i", not src or "?", src.currentline or src.currentline or -1))
    end
   end, "l", 1)
end

trace_ref = function(l_16_0, l_16_1, l_16_2)
  local class_mt = type(l_16_0) == "string" and getmetatable(assert(rawget(_G, l_16_0))) or l_16_0
  local ref = function()
    local t = rawget(_G, "_trace_ref_table")
    if not t then
      t = {}
      rawset(_G, "_trace_ref_table", t)
      cat_print("debug", "[CoreTraceRef] ---------------------- New Script Environment --------------------------")
    end
   end
  local stack = function()
    return string.gsub(debug.traceback(), "%\n", "\n[CoreTraceRef]\t")
   end
  if not rawget(class_mt, "_" .. l_16_1) then
    rawset(class_mt, "_" .. l_16_1, assert(rawget(class_mt, l_16_1)))
    rawset(class_mt, l_16_1, function(...)
      ref()
      local r = rawget(class_mt, "_" .. init_name)(...)
      do
        local t = rawget(_G, "_trace_ref_table")
        cat_print("debug", "[CoreTraceRef] New ref:", r)
        t[r] = stack()
        return r
      end
       -- DECOMPILER ERROR: Confused about usage of registers for local variables.

      end)
  end
  if not rawget(class_mt, "_" .. l_16_2) then
    rawset(class_mt, "_" .. l_16_2, assert(rawget(class_mt, l_16_2)))
    rawset(class_mt, l_16_2, function(...)
      ref()
      local p = {...}
      local o = p[2]
      if not o or o.alive and not o:alive() then
        cat_print("debug", "[CoreTraceRef] WARNING! Deleting NULL ref: ", o, stack())
      else
        cat_print("debug", "[CoreTraceRef] Delete ref:", o)
      end
      local r = rawget(class_mt, "_" .. destroy_name)(...)
      do
        local t = rawget(_G, "_trace_ref_table")
        t[o] = nil
        return r
      end
       -- DECOMPILER ERROR: Confused about usage of registers for local variables.

      end)
  end
  if not rawget(_G, "_destroy") then
    rawset(_G, "_destroy", rawget(_G, "destroy"))
    rawset(_G, "destroy", function(...)
      ref()
      local d = rawget(_G, "_destroy")
      if d then
        d(...)
      end
      local c = 0
      do
        local t = assert(rawget(_G, "_trace_ref_table"))
        for k,v in pairs(t) do
          c = c + 1
        end
        cat_print("debug", string.format("[CoreTraceRef] ---------------------- %i Script References Lost --------------------------", c))
        for k,v in pairs(t) do
          cat_print("debug", "[CoreTraceRef]", k, v)
        end
      end
       -- DECOMPILER ERROR: Confused about usage of registers for local variables.

      end)
  end
end

trace_ref_add_destroy_all = function(l_17_0, l_17_1)
  local class_mt = type(l_17_0) == "string" and getmetatable(assert(rawget(_G, l_17_0))) or l_17_0
  rawset(class_mt, "_" .. l_17_1, assert(rawget(class_mt, l_17_1)))
  if not rawget(class_mt, "_" .. l_17_1) then
    rawset(class_mt, l_17_1, function(...)
    do
      local r = rawget(class_mt, "_" .. func_name)(...)
      cat_print("debug", "[CoreTraceRef] WARNING! Called destroy all function:", func_name)
      return r
    end
     -- DECOMPILER ERROR: Confused about usage of registers for local variables.

   end)
  end
end

debug_pause = function(...)
  if Application:production_build() then
    Application:error("[debug_pause]", ...)
    Application:stack_dump("error")
    if not Application:editor() or Global.running_simulation then
      Application:set_pause(true)
       -- DECOMPILER ERROR: Confused about usage of registers for local variables.

    end
  end
end

debug_pause_unit = function(l_19_0, ...)
  if Application:production_build() then
    debug_pause(...)
    if alive(l_19_0) then
      Application:draw_cylinder(l_19_0:position(), l_19_0:position() + math.UP * 5000, 30, 1, 0, 0)
    else
      Application:error("[debug_pause] DEAD UNIT")
       -- DECOMPILER ERROR: Confused about usage of registers for local variables.

    end
  end
end


