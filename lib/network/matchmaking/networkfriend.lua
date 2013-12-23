-- Decompiled using luadec 2.0.1 by sztupy (http://winmo.sztupy.hu)
-- Command line was: F:\SteamLibrary\SteamApps\common\PAYDAY 2\lua\lib\network\matchmaking\networkfriend.luac 

if not NetworkFriend then
  NetworkFriend = class()
end
NetworkFriend.init = function(l_1_0, l_1_1, l_1_2, l_1_3)
  l_1_0._id = l_1_1
  l_1_0._name = l_1_2
  l_1_0._signin_status = l_1_3
end

NetworkFriend.id = function(l_2_0)
  return l_2_0._id
end

NetworkFriend.name = function(l_3_0)
  return l_3_0._name
end

NetworkFriend.signin_status = function(l_4_0)
  return l_4_0._signin_status
end


