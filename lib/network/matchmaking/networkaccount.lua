-- Decompiled using luadec 2.0.1 by sztupy (http://winmo.sztupy.hu)
-- Command line was: F:\SteamLibrary\SteamApps\common\PAYDAY 2\lua\lib\network\matchmaking\networkaccount.luac 

if not NetworkAccount then
  NetworkAccount = class()
end
NetworkAccount.init = function(l_1_0)
  l_1_0._postprocess_username = callback(l_1_0, l_1_0, "_standard_username")
end

NetworkAccount.create_account = function(l_2_0, l_2_1, l_2_2, l_2_3)
end

NetworkAccount.reset_password = function(l_3_0, l_3_1, l_3_2)
end

NetworkAccount.login = function(l_4_0, l_4_1, l_4_2, l_4_3)
end

NetworkAccount.logout = function(l_5_0)
end

NetworkAccount.register_callback = function(l_6_0, l_6_1, l_6_2)
end

NetworkAccount.register_post_username = function(l_7_0, l_7_1)
  l_7_0._postprocess_username = l_7_1
end

NetworkAccount.username = function(l_8_0)
  return l_8_0._postprocess_username(l_8_0:username_id())
end

NetworkAccount.clan_tag = function(l_9_0)
  if managers.save.get_profile_setting and managers.save:get_profile_setting("clan_tag") and string.len(managers.save:get_profile_setting("clan_tag")) > 0 then
    return "[" .. managers.save:get_profile_setting("clan_tag") .. "]"
  end
  return ""
end

NetworkAccount._standard_username = function(l_10_0, l_10_1)
  return l_10_1
end


