-- Decompiled using luadec 2.0.1 by sztupy (http://winmo.sztupy.hu)
-- Command line was: F:\SteamLibrary\SteamApps\common\PAYDAY 2\lua\lib\network\matchmaking\networkaccountxbl.luac 

require("lib/network/matchmaking/NetworkAccount")
if not NetworkAccountXBL then
  NetworkAccountXBL = class(NetworkAccount)
end
NetworkAccountXBL.init = function(l_1_0)
  NetworkAccount.init(l_1_0)
end

NetworkAccountXBL.signin_state = function(l_2_0)
  local xbl_state = managers.user:signed_in_state(managers.user:get_index())
  local game_signin_state = l_2_0:_translate_signin_state(xbl_state)
  return game_signin_state
end

NetworkAccountXBL.local_signin_state = function(l_3_0)
  local xbl_state = managers.user:signed_in_state(managers.user:get_index())
  if xbl_state == "not_signed_in" then
    return "not signed in"
  end
  if xbl_state == "signed_in_locally" then
    return "signed in"
  end
  if xbl_state == "signed_in_to_live" then
    return "signed in"
  end
  return "not signed in"
end

NetworkAccountXBL.show_signin_ui = function(l_4_0)
end

NetworkAccountXBL.username_id = function(l_5_0)
  return Global.user_manager.user_map[Global.user_manager.user_index].username
end

NetworkAccountXBL.player_id = function(l_6_0)
  return managers.user:get_xuid(nil)
end

NetworkAccountXBL.is_connected = function(l_7_0)
  return true
end

NetworkAccountXBL.lan_connection = function(l_8_0)
  return true
end

NetworkAccountXBL.challenges_loaded = function(l_9_0)
  l_9_0._challenges_loaded = true
end

NetworkAccountXBL.experience_loaded = function(l_10_0)
  l_10_0._experience_loaded = true
end

NetworkAccountXBL._translate_signin_state = function(l_11_0, l_11_1)
  if l_11_1 == "signed_in_to_live" then
    return "signed in"
  end
  return "not signed in"
end


