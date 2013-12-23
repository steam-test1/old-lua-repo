-- Decompiled using luadec 2.0.1 by sztupy (http://winmo.sztupy.hu)
-- Command line was: F:\SteamLibrary\SteamApps\common\PAYDAY 2\lua\core\lib\utils\coreevent.luac 

if core then
  core:module("CoreEvent")
  core:import("CoreDebug")
end
callback = function(l_1_0, l_1_1, l_1_2, l_1_3)
  if l_1_1 and l_1_2 and l_1_1[l_1_2] then
    if l_1_3 ~= nil then
      if l_1_0 then
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
    elseif l_1_0 then
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
  elseif l_1_1 then
    local class_name = CoreDebug.class_name(not l_1_1 or getmetatable(l_1_1) or l_1_1)
    error("Callback on class \"" .. tostring(class_name) .. "\" refers to a non-existing function \"" .. tostring(l_1_2) .. "\".")
  elseif l_1_2 then
    error("Callback to function \"" .. tostring(l_1_2) .. "\" is on a nil class.")
  else
    error("Callback class and function was nil.")
  end
end

local tc = 0
get_ticket = function(l_2_0)
  return {}
   -- Warning: undefined locals caused missing assignments!
end

valid_ticket = function(l_3_0)
  return tc % l_3_0[1] == l_3_0[2]
end

update_tickets = function()
  tc = tc + 1
  if tc > 30 then
    tc = 0
  end
end

BasicEventHandling = {}
BasicEventHandling.connect = function(l_5_0, l_5_1, l_5_2, l_5_3)
  if not l_5_0._event_callbacks then
    l_5_0._event_callbacks = {}
  end
  if not l_5_0._event_callbacks[l_5_1] then
    l_5_0._event_callbacks[l_5_1] = {}
  end
  local wrapped_func = function(...)
      callback_func(data, ...)
       -- DECOMPILER ERROR: Confused about usage of registers for local variables.

      end
  table.insert(l_5_0._event_callbacks[l_5_1], wrapped_func)
  return wrapped_func
end

BasicEventHandling.disconnect = function(l_6_0, l_6_1, l_6_2)
  if l_6_0._event_callbacks and l_6_0._event_callbacks[l_6_1] then
    table.delete(l_6_0._event_callbacks[l_6_1], l_6_2)
    if table.empty(l_6_0._event_callbacks[l_6_1]) then
      l_6_0._event_callbacks[l_6_1] = nil
      if table.empty(l_6_0._event_callbacks) then
        l_6_0._event_callbacks = nil
      end
    end
  end
end

BasicEventHandling._has_callbacks_for_event = function(l_7_0, l_7_1)
  return l_7_0._event_callbacks ~= nil and l_7_0._event_callbacks[l_7_1] ~= nil
end

BasicEventHandling._send_event = function(l_8_0, l_8_1, ...)
  if l_8_0._event_callbacks then
    if not l_8_0._event_callbacks[l_8_1] then
      for _,wrapped_func in ipairs({}) do
      end
      wrapped_func(...)
    end
     -- DECOMPILER ERROR: Confused about usage of registers for local variables.

  end
end

if not CallbackHandler then
  CallbackHandler = class()
end
CallbackHandler.init = function(l_9_0)
  l_9_0:clear()
end

CallbackHandler.clear = function(l_10_0)
  l_10_0._t = 0
  l_10_0._sorted = {}
end

CallbackHandler.__insert_sorted = function(l_11_0, l_11_1)
  do
    local i = 1
    repeat
      if l_11_0._sorted[i] and (l_11_0._sorted[i].next == nil or l_11_0._sorted[i].next < l_11_1.next) then
        i = i + 1
      else
        table.insert(l_11_0._sorted, i, l_11_1)
      end
       -- Warning: missing end command somewhere! Added here
    end
     -- Warning: missing end command somewhere! Added here
  end
end

CallbackHandler.add = function(l_12_0, l_12_1, l_12_2, l_12_3)
  if not l_12_3 then
    l_12_3 = -1
  end
  local cb = {f = l_12_1, interval = l_12_2, times = l_12_3, next = l_12_0._t + l_12_2}
  l_12_0:__insert_sorted(cb)
  return cb
end

CallbackHandler.remove = function(l_13_0, l_13_1)
  if l_13_1 then
    l_13_1.next = nil
  end
end

CallbackHandler.update = function(l_14_0, l_14_1)
  l_14_0._t = l_14_0._t + l_14_1
  repeat
    repeat
      repeat
        repeat
          repeat
            do
              local cb = l_14_0._sorted[1]
              if cb == nil then
                return 
              elseif cb.next == nil then
                table.remove(l_14_0._sorted, 1)
              else
                if l_14_0._t < cb.next then
                  return 
                else
                  table.remove(l_14_0._sorted, 1)
                  cb.f(cb, l_14_0._t)
                  if cb.times >= 0 then
                    cb.times = cb.times - 1
                    if cb.times <= 0 then
                      cb.next = nil
                    end
                  end
                until cb.next
                cb.next = cb.next + cb.interval
                l_14_0:__insert_sorted(cb)
              end
              do return end
               -- Warning: missing end command somewhere! Added here
            end
             -- Warning: missing end command somewhere! Added here
          end
           -- Warning: missing end command somewhere! Added here
        end
         -- Warning: missing end command somewhere! Added here
      end
       -- Warning: missing end command somewhere! Added here
    end
     -- Warning: missing end command somewhere! Added here
  end
end

if not CallbackEventHandler then
  CallbackEventHandler = class()
end
CallbackEventHandler.init = function(l_15_0)
end

CallbackEventHandler.clear = function(l_16_0)
  l_16_0._callback_map = nil
end

CallbackEventHandler.add = function(l_17_0, l_17_1)
  if not l_17_0._callback_map then
    l_17_0._callback_map = {}
  end
  l_17_0._callback_map[l_17_1] = true
end

CallbackEventHandler.remove = function(l_18_0, l_18_1)
  if not l_18_0._callback_map or not l_18_0._callback_map[l_18_1] then
    return 
  end
  if l_18_0._next_callback == l_18_1 then
    l_18_0._next_callback = next(l_18_0._callback_map, l_18_0._next_callback)
  end
  l_18_0._callback_map[l_18_1] = nil
  if not next(l_18_0._callback_map) then
    l_18_0._callback_map = nil
  end
end

CallbackEventHandler.dispatch = function(l_19_0, ...)
  if l_19_0._callback_map then
    l_19_0._next_callback = next(l_19_0._callback_map)
    l_19_0._next_callback(...)
    repeat
      repeat
        if l_19_0._next_callback then
          l_19_0._next_callback = next(l_19_0._callback_map, l_19_0._next_callback)
        until l_19_0._next_callback
        l_19_0._next_callback(...)
       -- DECOMPILER ERROR: Confused about usage of registers for local variables.

    end
     -- Warning: missing end command somewhere! Added here
  end
end

over = function(l_20_0, l_20_1, l_20_2)
  do
    local t = 0
    repeat
      do
        local dt = coroutine.yield()
        t = t + (l_20_2 and 0.033333335071802 or dt)
        if l_20_0 <= t then
          do return end
        end
        l_20_1((t) / l_20_0, t)
      end
      do return end
      l_20_1(1, l_20_0)
    end
     -- Warning: missing end command somewhere! Added here
  end
end

seconds = function(l_21_0, l_21_1)
  if not l_21_1 then
    return seconds, l_21_0, 0
  end
  if l_21_0 and l_21_0 <= l_21_1 then
    return nil
  end
  local dt = coroutine.yield()
  l_21_1 = l_21_1 + dt
  if l_21_0 and l_21_0 < l_21_1 then
    l_21_1 = l_21_0
  end
  if l_21_0 then
    return l_21_1, l_21_1 / l_21_0, dt
  else
    return l_21_1, l_21_1, dt
  end
end

wait = function(l_22_0, l_22_1)
  local t = 0
  repeat
    if t < l_22_0 then
      local dt = coroutine.yield()
      t = t + (l_22_1 and 0.033333335071802 or dt)
    else
       -- Warning: missing end command somewhere! Added here
    end
     -- Warning: missing end command somewhere! Added here
  end
end


