-- Decompiled using luadec 2.0.1 by sztupy (http://winmo.sztupy.hu)
-- Command line was: F:\SteamLibrary\SteamApps\common\PAYDAY 2\lua\core\lib\managers\viewport\coreenvironmentdata.luac 

core:module("CoreEnvironmentData")
core:import("CoreClass")
if not EnvironmentData then
  EnvironmentData = CoreClass.class()
end
EnvironmentData.init = function(l_1_0, l_1_1)
  l_1_0._entry_path = l_1_1
  l_1_0._metadata = {}
  l_1_0._data = {}
  if l_1_1 then
    l_1_0:load(l_1_1)
  end
end

EnvironmentData.load = function(l_2_0, l_2_1)
  l_2_0._metadata = {}
  l_2_0._data = {}
  local env_data = l_2_0:_serialize_to_script("environment", l_2_1)
  env_data.metadata._meta = nil
  env_data.metadata.param = nil
  for _,data in ipairs(env_data.metadata) do
    l_2_0._metadata[data.key] = data.key.value
  end
  l_2_0:_serialized_load_data(env_data.data, l_2_0._data)
  return 
end

EnvironmentData.name = function(l_3_0)
  return l_3_0._entry_path
end

EnvironmentData.copy = function(l_4_0)
  local data = EnvironmentData:new()
  data._entry_path = l_4_0._entry_path
  l_4_0:for_each(function(l_1_0, ...)
    data:_set(true, data._data, l_1_0, ...)
     -- DECOMPILER ERROR: Confused about usage of registers for local variables.

   end)
  return data
end

EnvironmentData.for_each = function(l_5_0, l_5_1)
  l_5_0:_for_each(l_5_1, l_5_0._data, {})
end

EnvironmentData.parameter_block = function(l_6_0, ...)
  return l_6_0:_get(l_6_0._data, ...)
   -- DECOMPILER ERROR: Confused about usage of registers for local variables.

end

EnvironmentData.set_parameter_block = function(l_7_0, l_7_1, ...)
  l_7_0:_set(false, l_7_0._data, l_7_1, ...)
   -- DECOMPILER ERROR: Confused about usage of registers for local variables.

end

EnvironmentData.data_root = function(l_8_0)
  return l_8_0._data
end

EnvironmentData.metadata = function(l_9_0)
  return l_9_0._metadata
end

EnvironmentData._serialize_to_script = function(l_10_0, l_10_1, l_10_2)
  if Application:editor() then
    return PackageManager:editor_load_script_data(l_10_1:id(), l_10_2:id())
  else
    return PackageManager:script_data(l_10_1:id(), l_10_2:id())
  end
end

EnvironmentData._for_each = function(l_11_0, l_11_1, l_11_2, l_11_3)
  for k,v in pairs(l_11_2) do
     -- DECOMPILER ERROR: No list found. Setlist fails

    local t = {}
    local the_end = false
    for _,pv in pairs(v) do
      if type(pv) ~= "table" then
        table.insert(t, k)
        l_11_1(v, unpack(t))
        the_end = true
    else
      end
    end
    if not the_end then
      table.insert(t, k)
      l_11_0:_for_each(l_11_1, v, t)
    end
  end
end

EnvironmentData._get = function(l_12_0, l_12_1, ...)
  local args = {...}
  do
    local arg = l_12_1[args[1]]
    if #args == 1 then
      return arg
    else
      return l_12_0:_get(arg, select(2, ...))
    end
    error("[EnvironmentData] Bad path!")
  end
   -- DECOMPILER ERROR: Confused about usage of registers for local variables.

end

EnvironmentData._set = function(l_13_0, l_13_1, l_13_2, l_13_3, ...)
  local args = {...}
  do
    local arg = l_13_2[args[1]]
    if not arg and l_13_1 then
      arg = {}
      l_13_2[args[1]] = arg
    end
    if #args == 1 then
      for pk,pv in pairs(l_13_3) do
        arg[pk] = pv
      end
      return 
    else
      l_13_0:_set(l_13_1, arg, l_13_3, select(2, ...))
      return 
    end
    error("[EnvironmentData] Bad path!")
  end
   -- DECOMPILER ERROR: Confused about usage of registers for local variables.

end

EnvironmentData._serialized_load_data = function(l_14_0, l_14_1, l_14_2)
  for _,d in ipairs(l_14_1) do
    if d._meta == "param" then
      l_14_2[d.key] = d.value
      for (for control),_ in (for generator) do
      end
      local child_data = {}
      l_14_2[d._meta] = child_data
      l_14_0:_serialized_load_data(d, child_data)
    end
     -- Warning: missing end command somewhere! Added here
  end
end


