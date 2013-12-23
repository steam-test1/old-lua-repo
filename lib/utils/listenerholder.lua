-- Decompiled using luadec 2.0.1 by sztupy (http://winmo.sztupy.hu)
-- Command line was: F:\SteamLibrary\SteamApps\common\PAYDAY 2\lua\lib\utils\listenerholder.luac 

if not ListenerHolder then
  ListenerHolder = class()
end
ListenerHolder.add = function(l_1_0, l_1_1, l_1_2)
  if l_1_0._calling then
    l_1_0:_set_new(l_1_1, l_1_2)
  else
    l_1_0:_add(l_1_1, l_1_2)
  end
end

ListenerHolder.remove = function(l_2_0, l_2_1)
  if l_2_0._calling then
    l_2_0:_set_trash(l_2_1)
  else
    l_2_0:_remove(l_2_1)
  end
end

ListenerHolder.call = function(l_3_0, ...)
  if l_3_0._listeners then
    l_3_0._calling = true
    for key,clbk in pairs(l_3_0._listeners) do
      if l_3_0:_not_trash(key) then
        clbk(...)
      end
    end
    l_3_0._calling = nil
    l_3_0:_append_new_additions()
    l_3_0:_dispose_trash()
     -- DECOMPILER ERROR: Confused about usage of registers for local variables.

  end
end

ListenerHolder._remove = function(l_4_0, l_4_1)
  l_4_0._listeners[l_4_1] = nil
  if not next(l_4_0._listeners) then
    l_4_0._listeners = nil
  end
end

ListenerHolder._add = function(l_5_0, l_5_1, l_5_2)
  if not l_5_0._listeners then
    l_5_0._listeners = {}
  end
  l_5_0._listeners[l_5_1] = l_5_2
end

ListenerHolder._set_trash = function(l_6_0, l_6_1)
  if not l_6_0._trash then
    l_6_0._trash = {}
  end
  l_6_0._trash[l_6_1] = true
  if l_6_0._additions then
    l_6_0._additions[l_6_1] = nil
  end
end

ListenerHolder._set_new = function(l_7_0, l_7_1, l_7_2)
  if not l_7_0._additions then
    l_7_0._additions = {}
  end
  l_7_0._additions[l_7_1] = l_7_2
  if l_7_0._trash then
    l_7_0._trash[l_7_1] = nil
  end
end

ListenerHolder._append_new_additions = function(l_8_0)
  if l_8_0._additions then
    for key,clbk in pairs(l_8_0._additions) do
      l_8_0:_add(key, clbk)
    end
    l_8_0._additions = nil
  end
end

ListenerHolder._dispose_trash = function(l_9_0)
  if l_9_0._trash then
    for key,_ in pairs(l_9_0._trash) do
      l_9_0:_remove(key)
    end
    l_9_0._trash = nil
  end
end

ListenerHolder._not_trash = function(l_10_0, l_10_1)
  return (l_10_0._trash and not l_10_0._trash[l_10_1])
end


