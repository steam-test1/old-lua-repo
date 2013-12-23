-- Decompiled using luadec 2.0.1 by sztupy (http://winmo.sztupy.hu)
-- Command line was: F:\SteamLibrary\SteamApps\common\PAYDAY 2\lua\core\lib\system\coremodule.luac 

local CORE, PROJ = 0, 1
local CoreModule = {}
CoreModule.PRODUCTION_ONLY = "PRODUCTION_ONLY"
CoreModule.new = function(l_1_0)
  local instance = {}
  l_1_0.__index = l_1_0
  setmetatable(instance, l_1_0)
  instance:init()
  return instance
end

CoreModule.init = function(l_2_0)
  l_2_0.__modules = {}
  l_2_0.__filepaths = {}
  l_2_0.__pristine_G = {}
  l_2_0.__pristine_closed = false
  l_2_0.__obj2nametable = {}
  for k,v in pairs(_G) do
    l_2_0.__pristine_G[k] = v
  end
  l_2_0.__pristine_G.core = l_2_0
  return l_2_0
end

CoreModule.register_module = function(l_3_0, l_3_1)
  local module_name = l_3_0:_get_module_name(l_3_1)
  assert(l_3_0.__filepaths[module_name] == nil, "Can't register module '" .. tostring(module_name) .. "'. It is already registred.")
  l_3_0.__filepaths[module_name] = l_3_1
end

CoreModule.import = function(l_4_0, l_4_1)
  if l_4_0.__filepaths[l_4_1] ~= nil then
    local fp = l_4_0.__filepaths[l_4_1]
    require(fp)
    local m = l_4_0.__modules[l_4_1]
    assert(m, "Can't import. Please check statement core:module('" .. l_4_1 .. "') in: " .. fp)
    rawset(getfenv(2), l_4_1, m)
    return m
  else
    error("Can't import module '" .. tostring(l_4_1) .. "'. It is not registred (is spelling correct?)")
  end
end

CoreModule.from_module_import = function(l_5_0, l_5_1, ...)
  if l_5_0.__filepaths[l_5_1] ~= nil then
    local fp = l_5_0.__filepaths[l_5_1]
    require(fp)
    local m = l_5_0.__modules[l_5_1]
    assert(m, "Can't import. Please check statement core:module('" .. l_5_1 .. "') in: " .. fp)
    for _,name in ipairs({...}) do
      local v = assert(m[name], "Can't import name '" .. tostring(name) .. "' from module '" .. l_5_1 .. "'")
      rawset(getfenv(2), name, v)
    end
  else
    error("Can't import module '" .. tostring(l_5_1) .. "'. It is not registred (is spelling correct?)")
     -- DECOMPILER ERROR: Confused about usage of registers for local variables.

  end
end

CoreModule.module = function(l_6_0, l_6_1)
  local M = nil
  if not l_6_0.__modules[l_6_1] then
    M = {}
  end
  l_6_0.__modules[l_6_1] = M
  M._M = M
  M._NAME = l_6_1
  setmetatable(M, {__index = l_6_0.__pristine_G})
  setfenv(2, M)
end

CoreModule._add_to_pristine_and_global = function(l_7_0, l_7_1, l_7_2)
  assert(not l_7_0.__pristine_closed)
  rawset(l_7_0.__pristine_G, l_7_1, l_7_2)
  rawset(_G, l_7_1, l_7_2)
end

CoreModule._copy_module_to_global = function(l_8_0, l_8_1)
  assert(not l_8_0.__pristine_closed)
  local module = l_8_0:import(l_8_1)
  for k,v in pairs(module) do
    rawset(_G, k, v)
  end
end

CoreModule._close_pristine_namespace = function(l_9_0, l_9_1)
  l_9_0.__pristine_closed = true
end

CoreModule._get_module_name = function(l_10_0, l_10_1)
  assert(type(l_10_1) == "string")
  local i = 1
  local j = string.find(l_10_1, "/", i, true)
  repeat
    if j then
      i = j + 1
      j = string.find(l_10_1, "/", i, true)
    do
      else
        local module_name = string.sub(l_10_1, i)
        assert(module_name ~= "", string.format("Malformed module_file_path '%s'", l_10_1))
        return module_name
      end
       -- Warning: missing end command somewhere! Added here
    end
     -- Warning: missing end command somewhere! Added here
  end
end

CoreModule._prepare_reload = function(l_11_0)
  l_11_0.__filepaths = {}
  l_11_0.__pristine_closed = false
end

CoreModule._lookup = function(l_12_0, l_12_1)
  assert(Application:production_build(), "core:_lookup(...) is for debugging only!")
  if not l_12_0.__obj2nametable[l_12_1] then
    local find = function(l_1_0, l_1_1, l_1_2)
    for k,v in pairs(l_1_2) do
      if v == l_1_0 then
        self.__obj2nametable[l_1_0] = {k, l_1_1}
        return true
      end
    end
   end
    find(l_12_1, "_G", _G)
    for n,m in pairs(l_12_0.__modules) do
      find(l_12_1, n, m)
    end
  end
  if not l_12_0.__obj2nametable[l_12_1] then
    return unpack({"<notfound>", "<notfound>"})
     -- Warning: missing end command somewhere! Added here
  end
end

CoreModule._name_to_module = function(l_13_0, l_13_1)
  if not l_13_0.__modules[l_13_1] then
    if l_13_0.__filepaths[l_13_1] ~= nil then
      local fp = l_13_0.__filepaths[l_13_1]
      require(fp)
      local m = l_13_0.__modules[l_13_1]
      assert(m, "Can't import. Please check statement core:module('" .. l_13_1 .. "') in: " .. fp)
    else
      error("Can't import module '" .. tostring(l_13_1) .. "'. It is not registred (is spelling correct?)")
    end
  end
  return l_13_0.__modules[l_13_1]
end

CoreModule._module_to_name = function(l_14_0, l_14_1)
  for n,m in pairs(l_14_0.__modules) do
    if m == l_14_1 then
      return n
    end
  end
  error("Can't locate module")
end

if _G.core == nil then
  _G.core = CoreModule:new()
else
  _G.core:_prepare_reload()
end

