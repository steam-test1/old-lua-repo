-- Decompiled using luadec 2.0.1 by sztupy (http://winmo.sztupy.hu)
-- Command line was: F:\SteamLibrary\SteamApps\common\PAYDAY 2\lua\core\lib\managers\cutscene\corecutscenekeycollection.luac 

if not CoreCutsceneKeyCollection then
  CoreCutsceneKeyCollection = class()
end
CoreCutsceneKeyCollection.keys = function(l_1_0, l_1_1)
  return l_1_0:keys_between(-1, math.huge, l_1_1)
end

CoreCutsceneKeyCollection.keys_between = function(l_2_0, l_2_1, l_2_2, l_2_3)
  if l_2_1 == l_2_2 then
    return function()
   end
  end
  local keys = l_2_0:_all_keys_sorted_by_time()
  if l_2_1 < l_2_2 then
    local index = 0
    do
      local count = table.getn(keys)
      return function()
        repeat
          repeat
            repeat
              repeat
                repeat
                  if index < count then
                    index = index + 1
                    local key = keys[index]
                  until key
                until start_time < key:time()
              until key:time() <= end_time and (element_name ~= nil and element_name == key.ELEMENT_NAME)
              return key
              do return end
              do return end
            else
               -- Warning: missing end command somewhere! Added here
            end
             -- Warning: missing end command somewhere! Added here
          end
           -- Warning: missing end command somewhere! Added here
        end
         end
    end
  else
    local index = table.getn(keys) + 1
    return function()
      repeat
        repeat
          repeat
            repeat
              repeat
                if index > 1 then
                  index = index - 1
                  local key = keys[index]
                until key
              until key:time() <= start_time
            until end_time < key:time() and (element_name ~= nil and element_name == key.ELEMENT_NAME)
            return key
            do return end
            do return end
          else
             -- Warning: missing end command somewhere! Added here
          end
           -- Warning: missing end command somewhere! Added here
        end
         -- Warning: missing end command somewhere! Added here
      end
      end
  end
end

CoreCutsceneKeyCollection.keys_to_update = function(l_3_0, l_3_1, l_3_2)
  local keys = l_3_0:_all_keys_sorted_by_time()
  local index = 0
  local count = table.getn(keys)
  return function()
    repeat
      repeat
        repeat
          repeat
            if index < count then
              index = index + 1
              local key = keys[index]
              if time < key:time() then
                do return end
            until element_name == nil or element_name == key.ELEMENT_NAME
          until type(key.update) == "function"
          else
            return key
          end
        else
           -- Warning: missing end command somewhere! Added here
        end
         -- Warning: missing end command somewhere! Added here
      end
       -- Warning: missing end command somewhere! Added here
    end
   end
end

CoreCutsceneKeyCollection.first_key = function(l_4_0, l_4_1, l_4_2, l_4_3)
  for index,key in ipairs(l_4_0:_all_keys_sorted_by_time()) do
    do
      if l_4_1 <= key:time() and (l_4_2 == nil or l_4_2 == key.ELEMENT_NAME) and (l_4_3 == nil or table.true_for_all(l_4_3, function(l_1_0, l_1_1)
        return key[l_1_1](key) == l_1_0
         end)) then
        return key, index
      end
    end
  end
end

CoreCutsceneKeyCollection.last_key_before = function(l_5_0, l_5_1, l_5_2, l_5_3)
  local last_key = nil
  for _,key in ipairs(l_5_0:_all_keys_sorted_by_time()) do
    do
      if l_5_1 <= key:time() then
        do return end
      end
      if (l_5_2 == nil or l_5_2 == key.ELEMENT_NAME) and (l_5_3 == nil or table.true_for_all(l_5_3, function(l_1_0, l_1_1)
        return key[l_1_1](key) == l_1_0
         end)) then
        last_key = key
      end
    end
  end
  return last_key
end


