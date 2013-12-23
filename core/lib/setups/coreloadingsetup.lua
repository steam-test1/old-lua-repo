-- Decompiled using luadec 2.0.1 by sztupy (http://winmo.sztupy.hu)
-- Command line was: F:\SteamLibrary\SteamApps\common\PAYDAY 2\lua\core\lib\setups\coreloadingsetup.luac 

class = function(...)
  local super = ...
   -- DECOMPILER ERROR: Overwrote pending register.

  if ...("#", ...) >= 1 and super == nil then
    error("trying to inherit from nil", 2)
  end
  do
    local class_table = {}
    class_table.super = super
    class_table.__index = class_table
    setmetatable(class_table, super)
    class_table.new = function(l_1_0, ...)
    do
      local object = {}
      setmetatable(object, class_table)
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

callback = function(l_2_0, l_2_1, l_2_2, l_2_3)
  if l_2_1 and l_2_2 and l_2_1[l_2_2] then
    if l_2_3 ~= nil then
      if l_2_0 then
        return function(...)
    return base_callback_class[base_callback_func_name](o, base_callback_param, ...)
     -- DECOMPILER ERROR: Confused about usage of registers for local variables.

   end
      else
        return function(...)
        return base_callback_class[base_callback_func_name](base_callback_param, ...)
         -- DECOMPILER ERROR: Confused about usage of registers for local variables.

         end
      end
    elseif l_2_0 then
      return function(...)
      return base_callback_class[base_callback_func_name](o, ...)
       -- DECOMPILER ERROR: Confused about usage of registers for local variables.

      end
    else
      return function(...)
      return base_callback_class[base_callback_func_name](...)
       -- DECOMPILER ERROR: Confused about usage of registers for local variables.

      end
    end
  elseif l_2_1 then
    local class_name = CoreDebug.class_name(not l_2_1 or getmetatable(l_2_1) or l_2_1)
    error("Callback on class \"" .. tostring(class_name) .. "\" refers to a non-existing function \"" .. tostring(l_2_2) .. "\".")
  elseif l_2_2 then
    error("Callback to function \"" .. tostring(l_2_2) .. "\" is on a nil class.")
  else
    error("Callback class and function was nil.")
  end
end

if not CoreLoadingSetup then
  CoreLoadingSetup = class()
end
CoreLoadingSetup.init = function(l_3_0)
end

CoreLoadingSetup.init_managers = function(l_4_0, l_4_1)
end

CoreLoadingSetup.init_gp = function(l_5_0)
end

CoreLoadingSetup.post_init = function(l_6_0)
end

CoreLoadingSetup.update = function(l_7_0, l_7_1, l_7_2)
end

CoreLoadingSetup.destroy = function(l_8_0)
end

CoreLoadingSetup.__init = function(l_9_0)
  l_9_0:init_managers(managers)
  l_9_0:init_gp()
  l_9_0:post_init()
end

CoreLoadingSetup.__update = function(l_10_0, l_10_1, l_10_2)
  l_10_0:update(l_10_1, l_10_2)
end

CoreLoadingSetup.__destroy = function(l_11_0, l_11_1, l_11_2)
  l_11_0:destroy()
end

CoreLoadingSetup.make_entrypoint = function(l_12_0)
  rawset(_G, "init", callback(l_12_0, l_12_0, "__init"))
  rawset(_G, "update", callback(l_12_0, l_12_0, "__update"))
  rawset(_G, "destroy", callback(l_12_0, l_12_0, "__destroy"))
end


