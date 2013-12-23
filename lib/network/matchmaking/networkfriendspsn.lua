-- Decompiled using luadec 2.0.1 by sztupy (http://winmo.sztupy.hu)
-- Command line was: F:\SteamLibrary\SteamApps\common\PAYDAY 2\lua\lib\network\matchmaking\networkfriendspsn.luac 

if not NetworkFriendsPSN then
  NetworkFriendsPSN = class()
end
NetworkFriendsPSN.init = function(l_1_0)
  cat_print("lobby", "friends = NetworkFriendsPSN")
  l_1_0._friends = {}
  l_1_0._callback = {}
  l_1_0._updated_list_friends = PSN:update_list_friends()
  l_1_0._last_info = {}
  l_1_0._last_info.friends = 0
  l_1_0._last_info.friends_map = {}
  l_1_0._last_info.friends_status_map = {}
  PSN:set_matchmaking_callback("friends_updated", function()
    managers.network.friends:psn_update_friends()
   end)
  PSN:update_async_friends(true, 20)
end

NetworkFriendsPSN.destroy = function(l_2_0)
  PSN:set_matchmaking_callback("friends_updated", function()
   end)
  PSN:update_async_friends(false, 20)
end

NetworkFriendsPSN.set_visible = function(l_3_0, l_3_1)
  if l_3_1 == true then
    PSN:update_async_friends(true, 5)
  else
    PSN:update_async_friends(true, 20)
  end
end

NetworkFriendsPSN.call_callback = function(l_4_0, l_4_1, ...)
  if l_4_0._callback[l_4_1] then
    l_4_0._callback[l_4_1](...)
  else
    Application:error("Callback", l_4_1, "is not registred.")
     -- DECOMPILER ERROR: Confused about usage of registers for local variables.

  end
end

NetworkFriendsPSN.call_silent_callback = function(l_5_0, l_5_1, ...)
  if l_5_0._callback[l_5_1] then
    l_5_0._callback[l_5_1](...)
     -- DECOMPILER ERROR: Confused about usage of registers for local variables.

  end
end

NetworkFriendsPSN.get_friends_list = function(l_6_0)
  return l_6_0._friends
  local npids = {}
  local friends = PSN:get_list_friends()
  for _,f in pairs(friends) do
    table.insert(npids, f)
  end
  return npids
end

NetworkFriendsPSN.get_names_friends_list = function(l_7_0)
  if not l_7_0._updated_list_friends then
    l_7_0._updated_list_friends = PSN:update_list_friends()
  end
  local names = {}
  local friends = PSN:get_list_friends()
  if not friends then
    return names
  end
  for _,f in pairs(friends) do
    if f.friend ~= PSN:get_local_userid() then
      names[tostring(f.friend)] = true
    end
  end
  return names
end

NetworkFriendsPSN.get_npid_friends_list = function(l_8_0)
  local npids = {}
  local friends = PSN:get_list_friends()
  if not friends then
    return npids
  end
  for _,f in pairs(friends) do
    if f.friend ~= PSN:get_local_userid() then
      table.insert(npids, f.friend)
    end
  end
  return npids
end

NetworkFriendsPSN.get_friends = function(l_9_0)
  cat_print("lobby", "NetworkFriendsPSN:get_friends()")
  if not l_9_0._updated_list_friends then
    l_9_0._updated_list_friends = PSN:update_list_friends()
  end
  l_9_0._friends = {}
  local name = managers.network.account:player_id()
  local friends = PSN:get_list_friends()
  if friends then
    l_9_0._last_info.friends = #friends
    l_9_0:_fill_li_friends_map(friends)
    l_9_0._last_info.friends_status_map = {}
    for k,v in pairs(friends) do
      if tostring(v.friend) ~= name then
        local online_status = "not_signed_in"
        local info_mod = 1
        l_9_0._last_info.friends_status_map[tostring(v.friend)] = v.status * info_mod
        if managers.network.matchmake:user_in_lobby(v.friend) then
          online_status = "in_group"
        else
          if managers.network:session() and managers.network:session():is_kicked(tostring(v.friend)) then
            online_status = "banned"
          else
            if managers.network.group:find(v.friend) then
              online_status = "in_group"
            elseif v.status == 0 then
              do return end
            end
            if v.status == 1 then
              online_status = "signed_in"
            elseif v.status == 2 then
              online_status = "signed_in"
            end
          end
        end
        local f = NetworkFriend:new(v.friend, tostring(v.friend), online_status)
        table.insert(l_9_0._friends, f)
        l_9_0:call_callback("status_change", f)
      end
    end
    l_9_0:call_callback("get_friends_done", l_9_0._friends)
  end
end

NetworkFriendsPSN.register_callback = function(l_10_0, l_10_1, l_10_2)
  l_10_0._callback[l_10_1] = l_10_2
end

NetworkFriendsPSN.send_friend_request = function(l_11_0, l_11_1)
end

NetworkFriendsPSN.remove_friend = function(l_12_0, l_12_1)
end

NetworkFriendsPSN.has_builtin_screen = function(l_13_0)
  return false
end

NetworkFriendsPSN.accept_friend_request = function(l_14_0, l_14_1)
end

NetworkFriendsPSN.ignore_friend_request = function(l_15_0, l_15_1)
end

NetworkFriendsPSN.num_pending_friend_requests = function(l_16_0)
  return 0
end

NetworkFriendsPSN.debug_update = function(l_17_0, l_17_1, l_17_2)
end

NetworkFriendsPSN.psn_disconnected = function(l_18_0)
  l_18_0._updated_list_friends = false
end

NetworkFriendsPSN.psn_update_friends = function(l_19_0)
  if not PSN:get_list_friends() then
    local friends = {}
  end
  if #friends >= 0 then
    local change_of_friends = false
    for k,v in pairs(friends) do
      local friend_in_list = l_19_0._last_info.friends_map[tostring(v.friend)]
      if not friend_in_list then
        change_of_friends = true
      else
        l_19_0._last_info.friends_map[tostring(v.friend)] = nil
      end
    end
    for k,v in pairs(l_19_0._last_info.friends_map) do
      change_of_friends = true
      do return end
    end
    l_19_0:_fill_li_friends_map(friends)
    if change_of_friends then
      l_19_0._last_info.friends = #friends
      l_19_0._updated_list_friends = PSN:update_list_friends()
      l_19_0:call_silent_callback("friends_reset")
      return 
    else
      if l_19_0:_count_online(friends) then
        l_19_0:call_silent_callback("friends_reset")
        return 
      end
    end
     -- Warning: missing end command somewhere! Added here
  end
end

NetworkFriendsPSN.is_friend = function(l_20_0, l_20_1)
  local friends = PSN:get_list_friends()
  if not friends then
    return false
  end
  for _,data in ipairs(friends) do
    if data.friend == l_20_1 then
      return true
    end
  end
  return false
end

NetworkFriendsPSN._fill_li_friends_map = function(l_21_0, l_21_1)
  l_21_0._last_info.friends_map = {}
  for k,v in pairs(l_21_1) do
    l_21_0._last_info.friends_map[tostring(v.friend)] = true
  end
end

NetworkFriendsPSN._fill_li_friends_status_map = function(l_22_0, l_22_1)
  l_22_0._last_info.friends_status_map = {}
  for k,v in pairs(l_22_1) do
    local info_mod = 1
    if v.status == 2 and v.info and v.info == managers.platform:presence() then
      info_mod = -1
    end
    l_22_0._last_info.friends_status_map[tostring(v.friend)] = v.status * info_mod
  end
end

NetworkFriendsPSN._count_online = function(l_23_0, l_23_1)
  local name = managers.network.account:player_id()
  local status_changed = false
  for k,v in pairs(l_23_1) do
    local friend_status = l_23_0._last_info.friends_status_map[tostring(v.friend)] or 42
    local info_mod = 1
    if tostring(v.friend) ~= name and friend_status ~= v.status * info_mod then
      status_changed = true
  else
    end
  end
  if not status_changed then
    return false
  end
  l_23_0:_fill_li_friends_status_map(l_23_1)
  return true
end


