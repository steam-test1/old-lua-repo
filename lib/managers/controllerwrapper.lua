-- Decompiled using luadec 2.0.1 by sztupy (http://winmo.sztupy.hu)
-- Command line was: F:\SteamLibrary\SteamApps\common\PAYDAY 2\lua\lib\managers\controllerwrapper.luac 

core:import("CoreControllerWrapper")
if not ControllerWrapper then
  ControllerWrapper = class(CoreControllerWrapper.ControllerWrapper)
end
ControllerWrapper.init = function(l_1_0, ...)
  l_1_0._input_released_cache = {}
  ControllerWrapper.super.init(l_1_0, ...)
   -- DECOMPILER ERROR: Confused about usage of registers for local variables.

end

ControllerWrapper.reset_cache = function(l_2_0, l_2_1)
  local reset_cache_time = TimerManager:wall_running():time()
  if (not l_2_1 or l_2_0._reset_cache_time < reset_cache_time) and next(l_2_0._input_released_cache) then
    l_2_0._input_released_cache = {}
  end
  ControllerWrapper.super.reset_cache(l_2_0, l_2_1)
end

ControllerWrapper.get_input_released = function(l_3_0, l_3_1)
  local cache = l_3_0._input_released_cache[l_3_1]
  if l_3_0._connection_map[l_3_1] then
    if not l_3_0._enabled or not l_3_0._virtual_controller or not l_3_0:get_connection_enabled(l_3_1) or not l_3_0._virtual_controller:released(Idstring(l_3_1)) then
      cache = cache ~= nil or false
    end
    cache = not not (cache)
  else
    Application:error(l_3_0:to_string() .. " No controller input binded to connection \"" .. tostring(l_3_1) .. "\".")
    cache = false
  end
  l_3_0._input_released_cache[l_3_1] = cache
  return cache
end

CoreClass.override_class(CoreControllerWrapper.ControllerWrapper, ControllerWrapper)

