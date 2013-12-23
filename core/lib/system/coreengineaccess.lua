-- Decompiled using luadec 2.0.1 by sztupy (http://winmo.sztupy.hu)
-- Command line was: F:\SteamLibrary\SteamApps\common\PAYDAY 2\lua\core\lib\system\coreengineaccess.luac 

core:module("CoreEngineAccess")
local get_class_table = function(l_1_0)
  local class_table = rawget(_G, l_1_0)
  if class_table then
    return class_table, nil
  else
    return nil, string.format("Engine-side class not found: \"%s\".", l_1_0)
  end
end

local get_method_table = function(l_2_0)
  local class_table, problem = get_class_table(l_2_0)
  if problem then
    return nil, problem
  end
  local class_meta_table = getmetatable(class_table)
  if class_meta_table == nil then
    return nil, string.format("Global \"%s\" is not bound to a class table.", l_2_0)
  end
  local method_table = rawget(class_meta_table, "__index")
  if method_table == nil then
    return nil, string.format("Metatable for class \"%s\" does not have an __index member.", l_2_0)
  end
  if type(method_table) ~= "table" then
    return nil, string.format("Metatable for class \"%s\" does not use a table for indexing methods.", l_2_0)
  end
  return method_table, nil
end

local hide_static_engine_method = function(l_3_0, l_3_1, l_3_2)
  assert(not l_3_0 or l_3_1, "Invalid argument list.")
  local failure_func = function(l_1_0)
    return function(...)
      error(string.format("Failed to call hidden method %s:%s(...). %s", engine_class_name, method_name, failure_message))
       -- DECOMPILER ERROR: Confused about usage of registers for local variables.

      end
   end
  local method_table, problem = get_method_table(l_3_0)
  if problem then
    return failure_func(problem)
  end
  local method = method_table[l_3_1]
  if type(method) ~= "function" then
    return failure_func("Method not found.")
  end
  method_table[l_3_1] = function()
    error(string.format("%s:%s(...) has been hidden by core. %s", engine_class_name, method_name, message or "You should not call it directly."))
   end
  local class_table = assert(get_class_table(l_3_0))
  return function(...)
    return method(class_table, ...)
     -- DECOMPILER ERROR: Confused about usage of registers for local variables.

   end
end

if not __required then
  __required = true
  _exec = hide_static_engine_method("Application", "exec", "Use CoreSetup:exec(...) instead!")
  _quit = hide_static_engine_method("Application", "quit", "Use CoreSetup:quit(...) instead!")
  _editor_package = hide_static_engine_method("PackageManager", "editor_package")
  _editor_load = hide_static_engine_method("PackageManager", "editor_load")
  _editor_reload = hide_static_engine_method("PackageManager", "editor_reload")
  _editor_reload_node = hide_static_engine_method("PackageManager", "editor_reload_node")
  _editor_unit_data = hide_static_engine_method("PackageManager", "editor_unit_data")
end

