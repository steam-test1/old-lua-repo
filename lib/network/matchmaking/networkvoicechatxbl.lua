-- Decompiled using luadec 2.0.1 by sztupy (http://winmo.sztupy.hu)
-- Command line was: F:\SteamLibrary\SteamApps\common\PAYDAY 2\lua\lib\network\matchmaking\networkvoicechatxbl.luac 

if not NetworkVoiceChatXBL then
  NetworkVoiceChatXBL = class()
end
NetworkVoiceChatXBL._NUM_PEERS = 4
NetworkVoiceChatXBL.init = function(l_1_0)
  l_1_0.DEFAULT_TEAM = 1
  l_1_0._paused = true
  l_1_0._userid_callback_id = managers.user:add_user_state_changed_callback(callback(l_1_0, l_1_0, "user_id_update"))
end

NetworkVoiceChatXBL.open_session = function(l_2_0)
  if l_2_0._paused == false then
    Application:throw_exception("Trying to re-initialize voice chat")
  end
  l_2_0._current_player_index = managers.user:get_platform_id()
  XboxVoice:start(NetworkVoiceChatXBL._NUM_PEERS)
  if l_2_0._current_player_index then
    cat_print("lobby", "Voice: Registring Talker", l_2_0._current_player_index)
    XboxVoice:register_talker(l_2_0._current_player_index)
  end
  l_2_0._team = l_2_0.DEFAULT_TEAM
  l_2_0._peers = {}
  l_2_0:_load_globals()
  l_2_0._has_headset = false
  l_2_0._can_communicate = true
  l_2_0._only_friends = false
  l_2_0._paused = false
  l_2_0._user_changed = true
  l_2_0._number_of_users = 1
  l_2_0._mute_callback_id = managers.platform:add_event_callback("mute_list_changed", callback(l_2_0, l_2_0, "mute_callback"))
  l_2_0._voice_callback_id = managers.platform:add_event_callback("voicechat_away", callback(l_2_0, l_2_0, "voicechat_away"))
  l_2_0._friendsadd_callback_id = managers.platform:add_event_callback("friend_added", callback(l_2_0, l_2_0, "friends_update"))
  l_2_0._friendsdel_callback_id = managers.platform:add_event_callback("friend_remove", callback(l_2_0, l_2_0, "friends_update"))
  l_2_0._signin_callback_id = managers.platform:add_event_callback("signin_changed", callback(l_2_0, l_2_0, "user_update"))
  l_2_0._profile_callback_id = managers.platform:add_event_callback("profile_setting_changed", callback(l_2_0, l_2_0, "user_update"))
end

NetworkVoiceChatXBL.pause = function(l_3_0)
  cat_print("lobby", "NetworkVoiceChatXBL:pause")
  l_3_0._paused = true
  XboxVoice:stop()
end

NetworkVoiceChatXBL.resume = function(l_4_0)
  cat_print("lobby", "NetworkVoiceChatXBL:resume")
  l_4_0:open_session()
  l_4_0:_update_all()
end

NetworkVoiceChatXBL.open_channel_to = function(l_5_0, l_5_1, l_5_2)
  cat_print("lobby", "Opening Voice Channel to ", tostring(l_5_1.name))
  local player_index = managers.user:get_platform_id()
  if not player_index then
    Application:error("Player map not ready yet.")
    player_index = 0
  end
  local session = nil
  if l_5_2 == "game" then
    session = managers.network.matchmake._session
  else
    Application:throw_exception("Context '" .. tostring(l_5_2) .. "' not a valid context.")
  end
  if session == nil then
    Application:throw_exception("Session retreived from context '" .. tostring(l_5_2) .. "' is nil")
  end
  local internal_address = XboxLive:internal_address(session, l_5_1.external_address)
  l_5_1.voice_rpc = Network:handshake(internal_address, managers.network.DEFAULT_PORT, "TCP_IP")
  if l_5_1.voice_rpc then
    print("Voice: Created rpc")
  else
    Application:throw_exception("failed to create voice rpc from here to there")
  end
  local peer_info = {}
  peer_info.xuid = l_5_1.player_id
  peer_info.player_id = tostring(l_5_1.player_id)
  peer_info.rpc = l_5_1.voice_rpc
  peer_info.team = l_5_0.DEFAULT_TEAM
  peer_info.listen = true
  peer_info.talk = true
  peer_info.name = l_5_1.name
  peer_info.why = "open"
  peer_info.dead = false
  l_5_0._peers[peer_info.player_id] = peer_info
  if l_5_0._paused == false then
    l_5_0:_peer_flags(peer_info)
    l_5_0:_peer_update(peer_info)
  end
end

NetworkVoiceChatXBL.playerid_to_name = function(l_6_0, l_6_1)
  return l_6_0._peers[tostring(l_6_1)].name
end

NetworkVoiceChatXBL.ip_to_name = function(l_7_0, l_7_1)
  for k,v in pairs(l_7_0._peers) do
    if v.rpc and l_7_1 == tostring(v.rpc:ip_at_index(0)) then
      return v.name
    end
  end
end

NetworkVoiceChatXBL.close_channel_to = function(l_8_0, l_8_1)
  cat_print("lobby", "Closing Voice Channel to ", tostring(l_8_1.name))
  local player_index = managers.user:get_platform_id()
  local peer_info = l_8_0._peers[tostring(l_8_1.player_id)]
  if peer_info then
    cat_print("lobby", "Voice: Stop talking to ", tostring(l_8_1.name))
    l_8_0:_close_peer(peer_info)
    l_8_0._peers[tostring(l_8_1.player_id)] = nil
  end
end

NetworkVoiceChatXBL.lost_peer = function(l_9_0, l_9_1)
  if l_9_0._peers == nil then
    return 
  end
  local player_index = managers.user:get_platform_id()
  cat_print("lobby", "Voice: Lost peer ", tostring(l_9_1))
  for k,v in pairs(l_9_0._peers) do
    if v.rpc and l_9_1:ip_at_index(0) == v.rpc:ip_at_index(0) then
      cat_print("lobby", "\tVoice: Lost Connection to Name = ", v.name)
      l_9_0:_close_peer(v)
      l_9_0:_peer_flags(v)
      l_9_0._peers[k] = nil
    end
  end
end

NetworkVoiceChatXBL.close_all = function(l_10_0)
  cat_print("lobby", "Voice: Close all channels ")
  l_10_0._paused = true
  XboxVoice:stop()
  cat_print("lobby", "Voice: Close all channels End ")
  l_10_0._peers = {}
  l_10_0._team = l_10_0.DEFAULT_TEAM
end

NetworkVoiceChatXBL.set_team = function(l_11_0, l_11_1)
  cat_print("lobby", "Voice: set_team ", l_11_1)
  l_11_0._team = l_11_1
  for k,v in pairs(l_11_0._peers) do
    if v.rpc then
      v.rpc:voice_team(managers.network.account:player_id(), l_11_1)
    end
  end
  l_11_0:_update_all()
end

NetworkVoiceChatXBL.peer_team = function(l_12_0, l_12_1, l_12_2, l_12_3)
  for k,v in pairs(l_12_0._peers) do
    if v.player_id == tostring(l_12_1) then
      v.team = l_12_2
      l_12_0:_update_all()
      return 
    end
  end
end

NetworkVoiceChatXBL.clear_team = function(l_13_0)
  cat_print("lobby", "Voice: clear_team, eveyone can now speak to each other ")
  l_13_0._team = l_13_0.DEFAULT_TEAM
  for k,v in pairs(l_13_0._peers) do
    v.team = l_13_0.DEFAULT_TEAM
  end
  l_13_0:_update_all()
end

NetworkVoiceChatXBL.update = function(l_14_0, l_14_1)
  if l_14_0._paused == true then
    return 
  end
  local player_index = managers.user:get_platform_id()
  if l_14_0._current_player_index ~= player_index then
    cat_print("lobby", "Voice: Talker Changing from ", l_14_0._current_player_index, " to ", player_index)
    if l_14_0._current_player_index then
      XboxVoice:unregister_talker(l_14_0._current_player_index)
    end
    XboxVoice:register_talker(player_index)
    l_14_0._current_player_index = player_index
  end
  local headset = XboxVoice:has_headset(player_index)
  if headset ~= l_14_0._has_headset then
    if headset then
      cat_print("lobby", "Voice: Headset connected ")
      l_14_0._has_headset = true
    else
      cat_print("lobby", "Voice: Headset disconneted ")
      l_14_0._has_headset = false
    end
    l_14_0:_update_all()
  end
  if l_14_0._user_changed then
    cat_print("lobby", "Voice: Users (Login/Settings) has changed. Updating voice flags.")
    l_14_0._user_changed = false
    l_14_0:_update_numberofusers()
    l_14_0:_check_privilege()
    l_14_0:_update_all()
  end
end

NetworkVoiceChatXBL._close_peer = function(l_15_0, l_15_1)
  local player_index = managers.user:get_platform_id()
  if not l_15_0._paused and not l_15_1.dead then
    XboxVoice:unregister_talker(l_15_1.xuid)
    XboxVoice:stop_sending_to(player_index, l_15_1.rpc)
  end
  l_15_1.dead = true
  l_15_1.rpc = nil
end

NetworkVoiceChatXBL._peer_update = function(l_16_0, l_16_1)
  if l_16_1.dead then
    return 
  end
  local player_index = managers.user:get_platform_id()
  if l_16_1.listen then
    XboxVoice:register_talker(l_16_1.xuid)
  else
    XboxVoice:unregister_talker(l_16_1.xuid)
  end
  if l_16_1.talk and l_16_0._has_headset then
    XboxVoice:send_to(player_index, l_16_1.rpc)
    do return end
    XboxVoice:stop_sending_to(player_index, l_16_1.rpc)
  end
end

NetworkVoiceChatXBL._peer_flags = function(l_17_0, l_17_1)
  if l_17_1.dead then
    l_17_1.why = "Dead"
    return 
  end
  local player_index = managers.user:get_platform_id()
  XboxVoice:unregister_talker(l_17_1.xuid)
  XboxVoice:stop_sending_to(player_index, l_17_1.rpc)
  l_17_1.listen = true
  l_17_1.talk = true
  l_17_1.why = "Open"
  if l_17_0._can_communicate == false then
    l_17_1.listen = false
    l_17_1.talk = false
    l_17_1.why = "Communications off"
    return 
  end
   -- DECOMPILER ERROR: unhandled construct in 'if'

   -- DECOMPILER ERROR: unhandled construct in 'if'

  if l_17_0._only_friends and l_17_0._number_of_users == 1 and XboxLive:is_friend(player_index, l_17_1.xuid) == false then
    l_17_1.listen = false
    l_17_1.talk = false
    l_17_1.why = "Non friend"
    return 
    do return end
    l_17_1.listen = false
    l_17_1.talk = false
    l_17_1.why = "Friend Limiting"
    return 
  end
  if XboxLive:muted(player_index, l_17_1.xuid) then
    cat_print("lobby", "Voice: Mute, stop talking to ", l_17_1.name)
    l_17_1.listen = false
    l_17_1.talk = false
    l_17_1.why = "Muted"
    return 
  end
  if l_17_1.team ~= l_17_0._team then
    l_17_1.listen = false
    l_17_1.talk = false
    l_17_1.why = "Other Team"
  end
end

NetworkVoiceChatXBL._update_all = function(l_18_0)
  if l_18_0._paused == true then
    return 
  end
  for k,v in pairs(l_18_0._peers) do
    l_18_0:_peer_flags(v)
    l_18_0:_peer_update(v)
  end
end

NetworkVoiceChatXBL._save_globals = function(l_19_0)
  cat_print("lobby", "Voice: NetworkVoiceChatXBL:_save_globals ")
  Global.xvoice = nil
  Global.xvoice = {}
  Global.xvoice.peers = l_19_0._peers
  Global.xvoice.team = l_19_0._team
  l_19_0:pause()
end

NetworkVoiceChatXBL._load_globals = function(l_20_0)
  cat_print("lobby", "Voice: NetworkVoiceChatXBL:_load_globals ")
  if Global.xvoice == nil then
    return 
  end
  if not Global.xvoice.team then
    l_20_0._team = l_20_0._team
  end
  if Global.xvoice and Global.xvoice.peers then
    l_20_0._peers = Global.xvoice.peers
  end
  Global.xvoice = nil
end

NetworkVoiceChatXBL._update_numberofusers = function(l_21_0)
  l_21_0._number_of_users = 0
  for i = 0, 3 do
    if XboxLive:signin_state(i) ~= "not_signed_in" then
      l_21_0._number_of_users = l_21_0._number_of_users + 1
    end
  end
  cat_print("lobby", "   Voice: Number of users = ", l_21_0._number_of_users)
end

NetworkVoiceChatXBL._get_privilege = function(l_22_0, l_22_1)
  local cancommunicate = true
  local friendsonly = false
  if XboxLive:signin_state(l_22_1) ~= "not_signed_in" then
    cancommunicate = XboxLive:check_privilege(l_22_1, "communications")
    friendsonly = XboxLive:check_privilege(l_22_1, "communications_friends_only")
    if cancommunicate then
      friendsonly = false
    elseif friendsonly then
      cancommunicate = true
    end
  end
  return cancommunicate, friendsonly
end

NetworkVoiceChatXBL._check_privilege = function(l_23_0)
  local cancommunicate = true
  local friendsonly = false
  local usercancommunicate, userfriendsonly = nil, nil
  for i = 0, 3 do
    usercancommunicate, userfriendsonly = l_23_0:_get_privilege(i)
    if usercancommunicate == false then
      cancommunicate = false
    end
    if userfriendsonly == true then
      friendsonly = true
    end
  end
  local flagsupdate = false
  cat_print("lobby", "   Voice: Can Communicate = ", cancommunicate)
  if cancommunicate ~= l_23_0._can_communicate then
    l_23_0._can_communicate = cancommunicate
    flagsupdate = true
    return 
  end
  cat_print("lobby", "   Voice: Friends only = ", friendsonly)
  if friendsonly ~= l_23_0._only_friends then
    l_23_0._only_friends = friendsonly
    flagsupdate = true
  end
  return flagsupdate
end

NetworkVoiceChatXBL.num_peers = function(l_24_0)
  return true
end

NetworkVoiceChatXBL.destroy_voice = function(l_25_0, l_25_1)
  l_25_0:pause()
end

NetworkVoiceChatXBL.set_volume = function(l_26_0, l_26_1)
  print("new_value", l_26_1)
end

NetworkVoiceChatXBL.is_muted = function(l_27_0, l_27_1)
  local player_index = managers.user:get_platform_id()
  return XboxLive:muted(player_index, l_27_1)
end

NetworkVoiceChatXBL.set_muted = function(l_28_0, l_28_1, l_28_2)
  local player_index = managers.user:get_platform_id()
  XboxLive:set_muted(player_index, l_28_1, l_28_2)
end

NetworkVoiceChatXBL.user_id_update = function(l_29_0, l_29_1, l_29_2)
end

NetworkVoiceChatXBL.mute_callback = function(l_30_0)
  cat_print("lobby", "Voice: Mute list changed")
  print("Voice: Mute list changed")
  l_30_0:_update_all()
end

NetworkVoiceChatXBL.voicechat_away = function(l_31_0, l_31_1)
  cat_print("lobby", "Voice: voicechat_away: ", tostring(l_31_1))
  print("Voice: voicechat_away: ", tostring(l_31_1))
end

NetworkVoiceChatXBL.friends_update = function(l_32_0, l_32_1)
  cat_print("lobby", "Voice: Friends update: ")
  print("Voice: Friends update: ")
  l_32_0:_update_all()
end

NetworkVoiceChatXBL.user_update = function(l_33_0)
  cat_print("lobby", "Voice: NetworkVoiceChatXBL:user_update")
  print("Voice: NetworkVoiceChatXBL:user_update")
  l_33_0._user_changed = true
end

NetworkVoiceChatXBL.info = function(l_34_0)
  l_34_0:info_script()
  l_34_0:info_engine()
end

NetworkVoiceChatXBL.info_script = function(l_35_0)
  cat_print("lobby", "Voice Script Info")
  cat_print("lobby", "\tActive Player:     ", l_35_0._current_player_index)
  cat_print("lobby", "\tHas Headset:     ", l_35_0._has_headset)
  cat_print("lobby", "\tCan Communicate: ", l_35_0._can_communicate)
  cat_print("lobby", "\tVoice Paused:    ", l_35_0._paused)
  cat_print("lobby", "\tOnly Friends:    ", l_35_0._only_friends)
  cat_print("lobby", "\tSelf Team:       ", l_35_0._team)
  for k,v in pairs(l_35_0._peers) do
    local info = "\t\t" .. v.name
    info = info .. " Team=" .. tostring(v.team)
    info = info .. ", Listen=" .. tostring(v.listen)
    info = info .. ", talk=" .. tostring(v.talk)
    info = info .. ", why=" .. tostring(v.why)
    cat_print("lobby", info)
  end
end

NetworkVoiceChatXBL.info_engine = function(l_36_0)
  cat_print("lobby", "Voice Engine Info")
  cat_print("lobby", "   Registred Talkers")
  local talkers = XboxVoice:registered_talkers()
  for k,v in pairs(talkers) do
    local info = nil
    if type(v) == "number" then
      info = "      " .. tostring(v) .. " - Local Player"
    else
      info = "      " .. tostring(v) .. " - " .. l_36_0:playerid_to_name(v)
    end
    cat_print("lobby", info)
  end
  cat_print("lobby", "   Registred Sends")
  do
    local sends = XboxVoice:active_sends()
    for k,v in pairs(sends) do
      local num_peers = v:num_peers()
      cat_print("lobby", "      " .. tostring(k) .. " - " .. tostring(num_peers))
      local PeerNumber = 0
      repeat
        if PeerNumber < num_peers then
          local ip = v:ip_at_index(PeerNumber)
          cat_print("lobby", "         " .. tostring(ip) .. " - " .. l_36_0:ip_to_name(ip))
          PeerNumber = PeerNumber + 1
      else
        end
      end
       -- Warning: missing end command somewhere! Added here
    end
     -- Warning: missing end command somewhere! Added here
  end
end


