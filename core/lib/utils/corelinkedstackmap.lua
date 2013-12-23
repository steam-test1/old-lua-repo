-- Decompiled using luadec 2.0.1 by sztupy (http://winmo.sztupy.hu)
-- Command line was: F:\SteamLibrary\SteamApps\common\PAYDAY 2\lua\core\lib\utils\corelinkedstackmap.luac 

core:module("CoreLinkedStackMap")
if not LinkedStackMap then
  LinkedStackMap = class()
end
LinkedStackMap.init = function(l_1_0)
  l_1_0._linked_map = {}
  l_1_0._top_link = nil
  l_1_0._bottom_link = nil
  l_1_0._last_link_id = 0
end

LinkedStackMap.top_link = function(l_2_0)
  return l_2_0._top_link
end

LinkedStackMap.top = function(l_3_0)
  if l_3_0._top_link then
    return l_3_0._top_link.value
  end
end

LinkedStackMap.get_linked_map = function(l_4_0)
  return l_4_0._linked_map
end

LinkedStackMap.get = function(l_5_0, l_5_1)
  return l_5_0._linked_map[l_5_1]
end

LinkedStackMap.iterator = function(l_6_0)
  local func = function(l_1_0, l_1_1)
    local id, link = next(l_1_0, l_1_1)
    if link then
      return id, link.value
    end
   end
  return func, l_6_0._linked_map, nil
end

LinkedStackMap.top_bottom_iterator = function(l_7_0)
  local func = function(l_1_0, l_1_1)
    if l_1_1 then
      local link = l_1_0[l_1_1].previous
      if link then
        return link.id, link.value
      else
        return nil, nil
      end
    else
      if self._top_link then
        return self._top_link.id, self._top_link.value
      else
        return nil, nil
      end
    end
   end
  return func, l_7_0._linked_map, nil
end

LinkedStackMap.bottom_top_iterator = function(l_8_0)
  local func = function(l_1_0, l_1_1)
    if l_1_1 then
      local link = l_1_0[l_1_1].next
      if link then
        return link.id, link.value
      else
        return nil, nil
      end
    else
      if self._bottom_link then
        return self._bottom_link.id, self._bottom_link.value
      else
        return nil, nil
      end
    end
   end
  return func, l_8_0._linked_map, nil
end

LinkedStackMap.add = function(l_9_0, l_9_1)
  l_9_0._last_link_id = l_9_0._last_link_id + 1
  local link = {value = l_9_1, id = l_9_0._last_link_id}
  l_9_0._linked_map[l_9_0._last_link_id] = link
  if l_9_0._top_link then
    l_9_0._top_link.next = link
    link.previous = l_9_0._top_link
  else
    l_9_0._bottom_link = link
  end
  l_9_0._top_link = link
  return l_9_0._last_link_id
end

LinkedStackMap.remove = function(l_10_0, l_10_1)
  local link = l_10_0._linked_map[l_10_1]
  if link then
    local previous_link = link.previous
    local next_link = link.next
    if previous_link then
      previous_link.next = next_link
    end
    if next_link then
      next_link.previous = previous_link
    end
    if l_10_0._top_link == link then
      l_10_0._top_link = previous_link
    end
    if l_10_0._bottom_link == link then
      l_10_0._bottom_link = next_link
    end
    l_10_0._linked_map[l_10_1] = nil
  end
end

LinkedStackMap.to_string = function(l_11_0)
  local string = ""
  do
    local link = l_11_0._top_link
    repeat
      if link then
        if string == "" then
          string = tostring(link.value)
        else
          string = string .. ", " .. tostring(link.value)
        end
        link = link.previous
      else
        return string
      end
       -- Warning: missing end command somewhere! Added here
    end
     -- Warning: missing end command somewhere! Added here
  end
end


