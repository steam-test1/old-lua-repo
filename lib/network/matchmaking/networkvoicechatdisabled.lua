-- Decompiled using luadec 2.0.1 by sztupy (http://winmo.sztupy.hu)
-- Command line was: F:\SteamLibrary\SteamApps\common\PAYDAY 2\lua\lib\network\matchmaking\networkvoicechatdisabled.luac 

if not NetworkVoiceChatDisabled then
  NetworkVoiceChatDisabled = class()
end
NetworkVoiceChatDisabled.init = function(l_1_0, l_1_1)
  l_1_0._quiet = l_1_1 or false
  if l_1_0._quiet then
    cat_print("lobby", "Voice is quiet.")
  else
    cat_print("lobby", "Voice is disabled.")
  end
end

NetworkVoiceChatDisabled.check_status_information = function(l_2_0)
  l_2_0:_display_warning()
end

NetworkVoiceChatDisabled.open = function(l_3_0)
end

NetworkVoiceChatDisabled.set_volume = function(l_4_0, l_4_1)
end

NetworkVoiceChatDisabled.voice_type = function(l_5_0)
  if l_5_0._quiet == true then
    return "voice_quiet"
  else
    return "voice_disabled"
  end
end

NetworkVoiceChatDisabled.set_drop_in = function(l_6_0, l_6_1)
end

NetworkVoiceChatDisabled.pause = function(l_7_0)
end

NetworkVoiceChatDisabled.resume = function(l_8_0)
end

NetworkVoiceChatDisabled.init_voice = function(l_9_0)
end

NetworkVoiceChatDisabled.destroy_voice = function(l_10_0)
end

NetworkVoiceChatDisabled.num_peers = function(l_11_0)
  return true
end

NetworkVoiceChatDisabled.open_session = function(l_12_0, l_12_1)
  l_12_0:_display_warning()
end

NetworkVoiceChatDisabled.close_session = function(l_13_0)
end

NetworkVoiceChatDisabled.open_channel_to = function(l_14_0, l_14_1, l_14_2)
  l_14_0:_display_warning()
end

NetworkVoiceChatDisabled.close_channel_to = function(l_15_0, l_15_1)
end

NetworkVoiceChatDisabled.lost_peer = function(l_16_0, l_16_1)
end

NetworkVoiceChatDisabled.close_all = function(l_17_0)
end

NetworkVoiceChatDisabled.set_team = function(l_18_0, l_18_1)
end

NetworkVoiceChatDisabled.peer_team = function(l_19_0, l_19_1, l_19_2, l_19_3)
end

NetworkVoiceChatDisabled._open_close_peers = function(l_20_0)
end

NetworkVoiceChatDisabled.update = function(l_21_0)
end

NetworkVoiceChatDisabled._load_globals = function(l_22_0)
end

NetworkVoiceChatDisabled._save_globals = function(l_23_0, l_23_1)
end

NetworkVoiceChatDisabled._display_warning = function(l_24_0)
  if l_24_0._quiet == false and l_24_0:_have_displayed_warning() == true then
    managers.menu:show_err_no_chat_parental_control()
  end
end

NetworkVoiceChatDisabled._have_displayed_warning = function(l_25_0)
  if Global.psn_parental_voice and Global.psn_parental_voice == true then
    return false
  end
  Global.psn_parental_voice = true
  return true
end

NetworkVoiceChatDisabled.clear_team = function(l_26_0)
end

NetworkVoiceChatDisabled.psn_session_destroyed = function(l_27_0)
  if Global.psn and Global.psn.voice then
    Global.psn.voice.restart = nil
  end
end


