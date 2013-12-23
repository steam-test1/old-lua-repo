-- Decompiled using luadec 2.0.1 by sztupy (http://winmo.sztupy.hu)
-- Command line was: F:\SteamLibrary\SteamApps\common\PAYDAY 2\lua\lib\network\matchmaking\networkaccountpsn.luac 

require("lib/network/matchmaking/NetworkAccount")
if not NetworkAccountPSN then
  NetworkAccountPSN = class(NetworkAccount)
end
NetworkAccountPSN.init = function(l_1_0)
  NetworkAccount.init(l_1_0)
end

NetworkAccountPSN.signin_state = function(l_2_0)
  if PSN:is_online() == true then
    return "signed in"
  end
  return "not signed in"
end

NetworkAccountPSN.local_signin_state = function(l_3_0)
  if not PSN:cable_connected() then
    return false
  end
  local n = PSN:get_localinfo()
  if not n then
    return false
  end
  if not n.local_ip then
    return false
  end
  return true
end

NetworkAccountPSN.show_signin_ui = function(l_4_0)
  PSN:display_online_connection()
end

NetworkAccountPSN.username_id = function(l_5_0)
  local online_name = PSN:get_npid_user()
  if online_name then
    return online_name
  else
    local local_user_info_name = PS3:get_userinfo()
    if local_user_info_name then
      return local_user_info_name
    end
  end
  return managers.localization:text("menu_mp_player")
end

NetworkAccountPSN.player_id = function(l_6_0)
  if PSN:get_npid_user() == nil then
    local n = PSN:get_localinfo()
    if n and n.local_ip then
      return n.local_ip
    end
    Application:error("Could not get local ip, returning \"player_id\" VERY BAD!.")
    return "player_id"
  end
  return PSN:get_npid_user()
end

NetworkAccountPSN.is_connected = function(l_7_0)
  return true
end

NetworkAccountPSN.lan_connection = function(l_8_0)
  return PSN:cable_connected()
end

NetworkAccountPSN._lan_ip = function(l_9_0)
  local l = PSN:get_lan_info()
  if l and l.lan_ip then
    return l.lan_ip
  end
  return "player_lan"
end

NetworkAccountPSN.has_mask = function(l_10_0, l_10_1)
  return false
end

NetworkAccountPSN.achievements_fetched = function(l_11_0)
  l_11_0._achievements_fetched = true
  l_11_0:_check_for_unawarded_achievements()
end

NetworkAccountPSN.challenges_loaded = function(l_12_0)
  l_12_0._challenges_loaded = true
  l_12_0:_check_for_unawarded_achievements()
end

NetworkAccountPSN.experience_loaded = function(l_13_0)
  l_13_0._experience_loaded = true
  l_13_0:_check_for_unawarded_achievements()
end

NetworkAccountPSN._check_for_unawarded_achievements = function(l_14_0)
  if not l_14_0._achievements_fetched or not l_14_0._challenges_loaded or not l_14_0._experience_loaded then
    return 
  end
  print("[NetworkAccountPSN:_check_for_unawarded_achievements]")
  for _,challenge in ipairs(managers.challenges:get_completed()) do
    local achievement = managers.challenges:get_awarded_achievment(challenge.id)
    if achievement and not managers.achievment:get_info(achievement).awarded then
      managers.challenges:add_already_awarded_challenge(challenge.id)
    end
  end
end


