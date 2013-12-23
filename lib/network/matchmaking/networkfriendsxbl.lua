-- Decompiled using luadec 2.0.1 by sztupy (http://winmo.sztupy.hu)
-- Command line was: F:\SteamLibrary\SteamApps\common\PAYDAY 2\lua\lib\network\matchmaking\networkfriendsxbl.luac 

if not NetworkFriendsXBL then
  NetworkFriendsXBL = class()
end
NetworkFriendsXBL.init = function(l_1_0)
  l_1_0._callback = {}
end

NetworkFriendsXBL.destroy = function(l_2_0)
end

NetworkFriendsXBL.set_visible = function(l_3_0, l_3_1)
end

NetworkFriendsXBL.get_friends_list = function(l_4_0)
  local player_index = managers.user:get_platform_id()
  if not player_index then
    Application:error("Player map not ready yet.")
    player_index = 0
  end
  local friend_list = XboxLive:friends(player_index)
  local friends = {}
  for i,friend in ipairs(friend_list) do
    table.insert(friends, NetworkFriend:new(friend.xuid, friend.gamertag))
  end
  return friends
end

NetworkFriendsXBL.get_friends_by_name = function(l_5_0)
  local player_index = managers.user:get_platform_id()
  local friend_list = XboxLive:friends(player_index)
  local friends = {}
  for i,friend in ipairs(friend_list) do
    friends[friend.gamertag] = friend
  end
  return friends
end

NetworkFriendsXBL.get_friends = function(l_6_0)
  if not l_6_0._initialized then
    l_6_0._initialized = true
    l_6_0._callback.initialization_done()
  end
end

NetworkFriendsXBL.register_callback = function(l_7_0, l_7_1, l_7_2)
  l_7_0._callback[l_7_1] = l_7_2
end

NetworkFriendsXBL.send_friend_request = function(l_8_0, l_8_1)
end

NetworkFriendsXBL.remove_friend = function(l_9_0, l_9_1)
end

NetworkFriendsXBL.has_builtin_screen = function(l_10_0)
  return true
end

NetworkFriendsXBL.accept_friend_request = function(l_11_0, l_11_1)
end

NetworkFriendsXBL.ignore_friend_request = function(l_12_0, l_12_1)
end

NetworkFriendsXBL.num_pending_friend_requests = function(l_13_0)
  return 0
end


