-- Decompiled using luadec 2.0.1 by sztupy (http://winmo.sztupy.hu)
-- Command line was: F:\SteamLibrary\SteamApps\common\PAYDAY 2\lua\lib\utils\eventlistenerholder.luac 

if not EventListenerHolder then
  EventListenerHolder = class()
end
EventListenerHolder.add = function(l_1_0, l_1_1, l_1_2, l_1_3)
  if l_1_0._calling then
    l_1_0:_set_new(l_1_1, l_1_2, l_1_3)
  else
    l_1_0:_add(l_1_1, l_1_2, l_1_3)
  end
end

EventListenerHolder.remove = function(l_2_0, l_2_1)
  if l_2_0._calling then
    l_2_0:_set_trash(l_2_1)
  else
    l_2_0:_remove(l_2_1)
  end
end

EventListenerHolder.call = function(l_3_0, l_3_1, ...)
  do
    if l_3_0._listeners then
      local event_listeners = l_3_0._listeners[l_3_1]
      if event_listeners then
        l_3_0._calling = true
        for key,clbk in pairs(event_listeners) do
          if l_3_0:_not_trash(key) then
            clbk(...)
          end
        end
        l_3_0._calling = nil
        l_3_0:_append_new_additions()
        l_3_0:_dispose_trash()
      end
       -- DECOMPILER ERROR: Confused about usage of registers for local variables.

    end
  end
end

EventListenerHolder._remove = function(l_4_0, l_4_1)
  local listeners = l_4_0._listeners
  for _,event in pairs(l_4_0._listener_keys[l_4_1]) do
    listeners[event][l_4_1] = nil
    if not next(listeners[event]) then
      listeners[event] = nil
    end
  end
  if next(listeners) then
    l_4_0._listener_keys[l_4_1] = nil
  else
    l_4_0._listeners = nil
    l_4_0._listener_keys = nil
  end
end

EventListenerHolder._add = function(l_5_0, l_5_1, l_5_2, l_5_3)
  if l_5_0._listener_keys and l_5_0._listener_keys[l_5_1] then
    debug_pause("[EventListenerHolder:_add] duplicate", l_5_1, inspect(l_5_2), l_5_3)
    return 
  end
  local listeners = l_5_0._listeners
  if not listeners then
    l_5_0._listeners = {}
    l_5_0._listener_keys = {}
    listeners = l_5_0._listeners
  end
  for _,event in pairs(l_5_2) do
    if not listeners[event] then
      listeners[event] = {}
    end
    listeners[event][l_5_1] = l_5_3
  end
  l_5_0._listener_keys[l_5_1] = l_5_2
end

EventListenerHolder._set_trash = function(l_6_0, l_6_1)
  if not l_6_0._trash then
    l_6_0._trash = {}
  end
  l_6_0._trash[l_6_1] = true
  if l_6_0._additions then
    l_6_0._additions[l_6_1] = nil
  end
end

EventListenerHolder._set_new = function(l_7_0, l_7_1, l_7_2, l_7_3)
  if l_7_0._additions and l_7_0._additions[l_7_1] then
    debug_pause("[EventListenerHolder:_set_new] duplicate", l_7_1, inspect(l_7_2), l_7_3)
    return 
  end
  if not l_7_0._additions then
    l_7_0._additions = {}
  end
  l_7_0._additions[l_7_1] = {l_7_3, l_7_2}
  if l_7_0._trash then
    l_7_0._trash[l_7_1] = nil
  end
end

EventListenerHolder._append_new_additions = function(l_8_0)
  if l_8_0._additions then
    local listeners = l_8_0._listeners
    if not listeners then
      l_8_0._listeners = {}
      l_8_0._listener_keys = {}
      listeners = l_8_0._listeners
    end
    for key,new_entry in pairs(l_8_0._additions) do
      for _,event in ipairs(new_entry[2]) do
        if not listeners[event] then
          listeners[event] = {}
        end
        listeners[event][key] = new_entry[1]
      end
      l_8_0._listener_keys[key] = new_entry[2]
    end
    l_8_0._additions = nil
  end
end

EventListenerHolder._dispose_trash = function(l_9_0)
  if l_9_0._trash then
    for key,_ in pairs(l_9_0._trash) do
      l_9_0:_remove(key)
    end
    l_9_0._trash = nil
  end
end

EventListenerHolder._not_trash = function(l_10_0, l_10_1)
  return (l_10_0._trash and not l_10_0._trash[l_10_1])
end


