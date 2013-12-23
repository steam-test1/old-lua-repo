-- Decompiled using luadec 2.0.1 by sztupy (http://winmo.sztupy.hu)
-- Command line was: F:\SteamLibrary\SteamApps\common\PAYDAY 2\lua\core\lib\utils\coreserialize.luac 

core:module("CoreSerialize")
string_to_classtable = function(l_1_0)
  local module_name, name = nil, nil
  if string.find(l_1_0, "[.]") then
    module_name, name = unpack(string.split(l_1_0, "[.]"))
  else
    module_name, name = "_G", l_1_0
  end
  if module_name == "_G" then
    local obj = rawget(_G, name)
    assert(obj, "Can't find '" .. name .. "' in _G")
    return obj
  else
    local module = core:_name_to_module(module_name)
    local obj = module[name]
    assert(obj, "Can't get name '" .. name .. "' from module '" .. module_name .. "'")
    return obj
  end
end

classtable_to_string = function(l_2_0)
  local module_name = core:_module_to_name(l_2_0.__module__)
  for name,obj in pairs(l_2_0.__module__) do
    if obj == l_2_0 then
      return module_name .. "." .. name
    end
  end
  error("Can't find classtable in module '" .. module_name .. "'")
end


