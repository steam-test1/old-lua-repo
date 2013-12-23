-- Decompiled using luadec 2.0.1 by sztupy (http://winmo.sztupy.hu)
-- Command line was: F:\SteamLibrary\SteamApps\common\PAYDAY 2\lua\lib\network\base\session_states\hoststateinlobby.luac 

if not HostStateInLobby then
  HostStateInLobby = class(HostStateBase)
end
HostStateInLobby.on_join_request_received = function(l_1_0, l_1_1, l_1_2, l_1_3, l_1_4, l_1_5, l_1_6, l_1_7, l_1_8, l_1_9)
  print("HostStateInLobby:on_join_request_received peer_level", l_1_6, l_1_8, l_1_7)
  if l_1_0:_has_peer_left_PSN(l_1_2) then
    print("this CLIENT has left us from PSN, ignore his request", l_1_2)
    return 
  end
  local my_user_id = l_1_1.local_peer:user_id() or ""
  if l_1_0:_is_kicked(l_1_1, l_1_2, l_1_9) then
    print("YOU ARE IN MY KICKED LIST", l_1_2)
    l_1_0:_send_request_denied(l_1_9, 2, my_user_id)
    return 
  end
  if l_1_6 < Global.game_settings.reputation_permission then
    l_1_0:_send_request_denied(l_1_9, 6, my_user_id)
    return 
  end
  if l_1_7 ~= -1 and l_1_7 ~= managers.network.matchmake.GAMEVERSION then
    l_1_0:_send_request_denied(l_1_9, 7, my_user_id)
    return 
  end
  if l_1_1.wants_to_load_level then
    l_1_0:_send_request_denied(l_1_9, 0, my_user_id)
    return 
  end
  local old_peer = l_1_1.session:chk_peer_already_in(l_1_9)
   -- DECOMPILER ERROR: unhandled construct in 'if'

  if old_peer and l_1_8 ~= old_peer:join_attempt_identifier() then
    l_1_1.session:remove_peer(old_peer, old_peer:id(), "lost")
    l_1_0:_send_request_denied(l_1_9, 0, my_user_id)
  end
  return 
  if table.size(l_1_1.peers) >= 3 then
    print("server is full")
    l_1_0:_send_request_denied(l_1_9, 5, my_user_id)
    return 
  end
  print("[HostStateInLobby:on_join_request_received] new peer accepted", l_1_2)
  local character = managers.network:game():check_peer_preferred_character(l_1_3)
  local xnaddr = ""
  if SystemInfo:platform() == Idstring("X360") then
    xnaddr = managers.network.matchmake:external_address(l_1_9)
  end
  local new_peer_id, new_peer = nil, nil
  new_peer_id, new_peer = l_1_1.session:add_peer(l_1_2, nil, true, false, false, nil, character, l_1_9:ip_at_index(0), l_1_5, xnaddr)
  if not new_peer_id then
    print("there was no clean peer_id")
    l_1_0:_send_request_denied(l_1_9, 0, my_user_id)
    return 
  end
  new_peer:set_dlcs(l_1_4)
  new_peer:set_xuid(l_1_5)
  new_peer:set_join_attempt_identifier(l_1_8)
  local new_peer_rpc = nil
  if managers.network:protocol_type() == "TCP_IP" then
    new_peer_rpc = managers.network:session():resolve_new_peer_rpc(new_peer, l_1_9)
  else
    new_peer_rpc = l_1_9
  end
  new_peer:set_rpc(new_peer_rpc)
  new_peer:set_ip_verified(true)
  Network:add_client(new_peer:rpc())
  new_peer:set_entering_lobby(true)
  local level_index = tweak_data.levels:get_index_from_level_id(Global.game_settings.level_id)
  local difficulty_index = tweak_data:difficulty_to_index(Global.game_settings.difficulty)
  local job_id_index = 0
  local job_stage = 0
  local alternative_job_stage = 0
  local interupt_job_stage_level_index = 0
  if managers.job:has_active_job() then
    job_id_index = tweak_data.narrative:get_index_from_job_id(managers.job:current_job_id())
    job_stage = managers.job:current_stage()
    alternative_job_stage = managers.job:alternative_stage() or 0
    local interupt_stage_level = managers.job:interupt_stage()
    interupt_job_stage_level_index = interupt_stage_level and tweak_data.levels:get_index_from_level_id(interupt_stage_level) or 0
  end
  local server_xuid = SystemInfo:platform() == Idstring("X360") and managers.network.account:player_id() or ""
  new_peer:send("join_request_reply", 1, new_peer_id, character, level_index, difficulty_index, 1, l_1_1.local_peer:character(), my_user_id, Global.game_settings.mission, job_id_index, job_stage, alternative_job_stage, interupt_job_stage_level_index, server_xuid)
  new_peer:send("set_loading_state", false)
  if SystemInfo:platform() == Idstring("X360") then
    new_peer:send("request_player_name_reply", managers.network:session():local_peer():name())
  end
  l_1_0:_introduce_new_peer_to_old_peers(l_1_1, new_peer, false, l_1_2, new_peer:character(), "remove", new_peer:xuid(), new_peer:xnaddr())
  l_1_0:_introduce_old_peers_to_new_peer(l_1_1, new_peer)
  l_1_0:on_handshake_confirmation(l_1_1, new_peer, 1)
  Global.local_member:sync_lobby_data(new_peer)
end

HostStateInLobby.is_joinable = function(l_2_0, l_2_1)
  return not l_2_1.wants_to_load_level
end


