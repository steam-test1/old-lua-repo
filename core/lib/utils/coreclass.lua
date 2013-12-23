-- Decompiled using luadec 2.0.1 by sztupy (http://winmo.sztupy.hu)
-- Command line was: F:\SteamLibrary\SteamApps\common\PAYDAY 2\lua\core\lib\utils\coreclass.luac 

core:module("CoreClass")
__overrides = {}
__everyclass = {}
class = function(...)
  local super = ...
   -- DECOMPILER ERROR: Overwrote pending register.

  if ...("#", ...) >= 1 and super == nil then
    error("trying to inherit from nil", 2)
  end
  do
    local class_table = {}
    if __everyclass then
      table.insert(__everyclass, class_table)
    end
    class_table.super = __overrides[super] or super
    class_table.__index = class_table
    class_table.__module__ = getfenv(2)
    setmetatable(class_table, __overrides[super] or super)
    class_table.new = function(l_1_0, ...)
    do
      local object = {}
      setmetatable(object, __overrides[class_table] or class_table)
      if object.init then
        return object, object:init(...)
      end
      return object
    end
     -- DECOMPILER ERROR: Confused about usage of registers for local variables.

   end
    return class_table
  end
   -- DECOMPILER ERROR: Confused about usage of registers for local variables.

end

override_class = function(l_2_0, l_2_1)
  assert(__everyclass, "Too late to override class now.")
  for _,ct in ipairs(__everyclass) do
    if ct ~= l_2_1 and ct.super == l_2_0 then
      ct.super = l_2_1
      setmetatable(ct, l_2_1)
    end
  end
  __overrides[l_2_0] = l_2_1
end

close_override = function()
  __everyclass = nil
end

type_name = function(l_4_0)
  local name = type(l_4_0)
  if name == "userdata" and l_4_0.type_name then
    return l_4_0.type_name
  end
  return name
end

mixin = function(l_5_0, ...)
  for _,t in ipairs({...}) do
    for k,v in pairs(t) do
      if k ~= "new" and k ~= "__index" then
        rawset(l_5_0, k, v)
      end
    end
  end
  return l_5_0
   -- DECOMPILER ERROR: Confused about usage of registers for local variables.

end

mix = function(...)
  return mixin({}, ...)
   -- DECOMPILER ERROR: Confused about usage of registers for local variables.

end

mixin_add = function(l_7_0, ...)
  for _,t in ipairs({...}) do
    for k,v in pairs(t) do
      table.insert(l_7_0, v)
    end
  end
  return l_7_0
   -- DECOMPILER ERROR: Confused about usage of registers for local variables.

end

mix_add = function(...)
  return mixin_add({}, ...)
   -- DECOMPILER ERROR: Confused about usage of registers for local variables.

end

hijack_func = function(l_9_0, l_9_1, l_9_2)
  local meta = getmetatable(l_9_0) or l_9_0
  if not meta then
    Application:error("Can't hijack nil instance or class.")
  elseif not meta[l_9_1] then
    Application:error("Unable to hijack non-existing function \"" .. tostring(l_9_1) .. "\".")
  else
    local old_func_name = "hijacked_" .. l_9_1
    if not meta[old_func_name] then
      meta[old_func_name] = meta[l_9_1]
      if not l_9_2 then
        meta[l_9_1] = function()
         end
      end
    end
  end
end

unhijack_func = function(l_10_0, l_10_1)
  local meta = getmetatable(l_10_0) or l_10_0
  if not meta then
    Application:error("Can't unhijack nil instance or class.")
  else
    local old_func_name = "hijacked_" .. l_10_1
    if meta[old_func_name] then
      meta[l_10_1] = meta[old_func_name]
      meta[old_func_name] = nil
    end
  end
end

if not __frozen__newindex then
  __frozen__newindex = function(l_11_0, l_11_1, l_11_2)
  error(string.format("Attempt to set %s = %s in frozen %s.", tostring(l_11_1), tostring(l_11_2), type_or_class_name(l_11_0)))
end

end
freeze = function(...)
    for _,instance in ipairs({...}) do
      if not is_frozen(instance) then
        local metatable = getmetatable(instance)
        if metatable == nil then
          setmetatable(instance, {__newindex = __frozen__newindex, __metatable = nil})
          for (for control),_ in (for generator) do
          end
          setmetatable(instance, {__index = metatable.__index, __newindex = __frozen__newindex, __metatable = metatable})
        end
      end
      return ...
       -- DECOMPILER ERROR: Confused about usage of registers for local variables.

       -- Warning: missing end command somewhere! Added here
    end
   end
is_frozen = function(l_13_0)
  local metatable = debug.getmetatable(l_13_0)
  return not metatable or metatable.__newindex == __frozen__newindex
end

frozen_class = function(...)
  local class_table = class(...)
  do
    local new = class_table.new
    class_table.new = function(l_1_0, ...)
    do
      local instance, ret = new(l_1_0, ...)
      return freeze(instance), ret
    end
     -- DECOMPILER ERROR: Confused about usage of registers for local variables.

   end
    return class_table
  end
   -- DECOMPILER ERROR: Confused about usage of registers for local variables.

end

responder = function(...)
  local response = {...}
  do
    local responder_function = function()
    return unpack(response)
   end
    return setmetatable({}, {__index = function()
    return responder_function
   end})
  end
   -- DECOMPILER ERROR: Confused about usage of registers for local variables.

end

responder_map = function(l_16_0)
  local responder = {}
  for key,value in pairs(l_16_0) do
    do
      if key == "default" then
        setmetatable(responder, {__index = function()
        return function()
          return value
            end
         end})
      else
        responder[key] = function()
        return value
         end
      end
    end
  end
  return responder
end

if not GetSet then
  GetSet = class()
end
GetSet.init = function(l_17_0, l_17_1)
  for k,v in pairs(l_17_1) do
    do
      l_17_0._" ..  = v
      l_17_0[k] = function(l_1_0)
        return l_1_0._" .. 
         end
      l_17_0.set_" ..  = function(l_2_0, l_2_1)
        l_2_0._" ..  = l_2_1
         end
    end
  end
end


