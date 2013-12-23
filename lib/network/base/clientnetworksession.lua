-- Decompiled using luadec 2.0.1 by sztupy (http://winmo.sztupy.hu)
-- Command line was: F:\SteamLibrary\SteamApps\common\PAYDAY 2\lua\lib\network\base\clientnetworksession.luac 

if not ClientNetworkSession then
  ClientNetworkSession = class(BaseNetworkSession)
end
ClientNetworkSession.HOST_SANITY_CHECK_INTERVAL = 4
ClientNetworkSession.HOST_REQUEST_JOIN_INTERVAL = 2
ClientNetworkSession.request_join_host = function(l_1_0, l_1_1, l_1_2)
  print("[ClientNetworkSession:request_join_host]", l_1_1, l_1_2)
  l_1_0._cb_find_game = l_1_2
  local host_name = managers.network.matchmake:game_owner_name()
  local host_user_id = SystemInfo:platform() == l_1_0._ids_WIN32 and l_1_1:ip_at_index(0) or false
  local id, peer = l_1_0:add_peer(host_name, nil, nil, nil, nil, 1, nil, host_user_id, "", "")
  if SystemInfo:platform() == l_1_0._ids_WIN32 then
    peer:set_steam_rpc(l_1_1)
  end
  l_1_0._server_peer = peer
  Network:set_multiplayer(true)
  Network:set_client(l_1_1)
  local request_rpc = SystemInfo:platform() == l_1_0._ids_WIN32 and peer:steam_rpc() or l_1_1
  local xuid = SystemInfo:platform() == Idstring("X360") and managers.network.account:player_id() or ""
  local lvl = managers.experience:current_level()
  local gameversion = managers.network.matchmake.GAMEVERSION or -1
  local join_req_id = l_1_0:_get_join_attempt_identifier()
  l_1_0._join_request_params = {host_rpc = request_rpc, params = {l_1_0._local_peer:name(), managers.blackmarket:get_preferred_character(), managers.dlc:dlcs_string(), xuid, lvl, gameversion, join_req_id}}
  request_rpc:request_join(unpack(l_1_0._join_request_params.params))
  l_1_0._last_join_request_t = TimerManager:wall():time()
end

ClientNetworkSession.on_join_request_reply = function(l_2_0, l_2_1, l_2_2, l_2_3, l_2_4, l_2_5, l_2_6, l_2_7, l_2_8, l_2_9, l_2_10, l_2_11, l_2_12, l_2_13, l_2_14, l_2_15)
   -- DECOMPILER ERROR: Confused while interpreting a jump as a 'while'

end
print("[ClientNetworkSession:on_join_request_reply] ", l_2_0._server_peer:user_id(), l_2_8, l_2_15:ip_at_index(0), l_2_15:protocol_at_index(0))
if not l_2_0._server_peer or not l_2_0._cb_find_game then
  return 
end
if l_2_0._server_peer:ip() and l_2_15:ip_at_index(0) ~= l_2_0._server_peer:ip() then
  print("[ClientNetworkSession:on_join_request_reply] wrong host replied", l_2_0._server_peer:ip(), l_2_15:ip_at_index(0))
  return 
end
l_2_0._last_join_request_t = nil
if SystemInfo:platform() == l_2_0._ids_WIN32 then
  if l_2_0._server_peer:user_id() and l_2_8 ~= l_2_0._server_peer:user_id() then
    print("[ClientNetworkSession:on_join_request_reply] wrong host replied", l_2_0._server_peer:user_id(), l_2_8)
    return 
  else
    if l_2_15:protocol_at_index(0) == "STEAM" then
      l_2_0._server_protocol = "STEAM"
    else
      l_2_0._server_protocol = "TCP_IP"
    end
    print("self._server_protocol", l_2_0._server_protocol)
    l_2_0._server_peer:set_rpc(l_2_15)
    l_2_0._server_peer:set_ip_verified(true)
    Network:set_client(l_2_15)
  else
    l_2_0._server_protocol = "TCP_IP"
    l_2_0._server_peer:set_rpc(l_2_15)
    l_2_0._server_peer:set_ip_verified(true)
    Network:set_client(l_2_15)
  end
end
local cb = l_2_0._cb_find_game
l_2_0._cb_find_game = nil
if l_2_1 == 1 then
  l_2_0._host_sanity_send_t = TimerManager:wall():time() + l_2_0.HOST_SANITY_CHECK_INTERVAL
  Global.game_settings.level_id = tweak_data.levels:get_level_name_from_index(l_2_4)
  Global.game_settings.difficulty = tweak_data:index_to_difficulty(l_2_5)
  Global.game_settings.mission = l_2_9
  l_2_0._server_peer:set_character(l_2_7)
  l_2_0._server_peer:set_xuid(l_2_14)
  if SystemInfo:platform() == Idstring("X360") then
    local xnaddr = managers.network.matchmake:external_address(l_2_0._server_peer:rpc())
    l_2_0._server_peer:set_xnaddr(xnaddr)
    managers.network.matchmake:on_peer_added(l_2_0._server_peer)
  end
  l_2_0._local_peer:set_id(l_2_2)
  l_2_0._local_peer:set_character(l_2_3)
  l_2_0._server_peer:set_id(1)
  l_2_0._server_peer:set_in_lobby_soft(l_2_6 == 1)
  l_2_0._server_peer:set_synched_soft(l_2_6 ~= 1)
   -- DECOMPILER ERROR: unhandled construct in 'if'

  if SystemInfo:platform() ~= Idstring("PS3") or l_2_10 ~= 0 then
    local job_id = tweak_data.narrative:get_job_name_from_index(l_2_10)
    managers.job:activate_job(job_id, l_2_11)
    if l_2_12 ~= 0 then
      managers.job:synced_alternative_stage(l_2_12)
    end
    if l_2_13 ~= 0 then
      local interupt_level = tweak_data.levels:get_level_name_from_index(l_2_13)
      managers.job:synced_interupt_stage(interupt_level)
    end
  end
  cb(l_2_6 == 1 and "JOINED_LOBBY" or "JOINED_GAME", l_2_4, l_2_5, l_2_6)
elseif l_2_1 == 2 then
  l_2_0:remove_peer(l_2_0._server_peer, 1)
  cb("KICKED")
elseif l_2_1 == 0 then
  l_2_0:remove_peer(l_2_0._server_peer, 1)
  cb("FAILED_CONNECT")
elseif l_2_1 == 3 then
  l_2_0:remove_peer(l_2_0._server_peer, 1)
  cb("GAME_STARTED")
elseif l_2_1 == 4 then
  l_2_0:remove_peer(l_2_0._server_peer, 1)
  cb("DO_NOT_OWN_HEIST")
elseif l_2_1 == 5 then
  l_2_0:remove_peer(l_2_0._server_peer, 1)
  cb("GAME_FULL")
elseif l_2_1 == 6 then
  l_2_0:remove_peer(l_2_0._server_peer, 1)
  cb("LOW_LEVEL")
elseif l_2_1 == 7 then
  l_2_0:remove_peer(l_2_0._server_peer, 1)
  cb("WRONG_VERSION")
end
end

ClientNetworkSession.on_join_request_timed_out = function(l_3_0)
  local cb = l_3_0._cb_find_game
  l_3_0._cb_find_game = nil
  cb("TIMED_OUT")
end

ClientNetworkSession.on_join_request_cancelled = function(l_4_0)
  local cb = l_4_0._cb_find_game
  if cb then
    l_4_0._cb_find_game = nil
    if l_4_0._server_peer then
      l_4_0:remove_peer(l_4_0._server_peer, 1)
    end
    cb("CANCELLED")
  end
end

ClientNetworkSession.discover_hosts = function(l_5_0)
  l_5_0._discovered_hosts = {}
  Network:broadcast(NetworkManager.DEFAULT_PORT):discover_host()
end

ClientNetworkSession.on_host_discovered = function(l_6_0, l_6_1, l_6_2, l_6_3, l_6_4, l_6_5, l_6_6)
  if l_6_0._discovered_hosts then
    local new_host_data = {rpc = l_6_1, host_name = l_6_2, level_name = l_6_3, my_ip = l_6_4, state = l_6_5, difficulty = l_6_6}
    local already_known = nil
    for i_host,host_data in ipairs(l_6_0._discovered_hosts) do
      if host_data.host_name == l_6_2 and host_data.rpc:ip_at_index(0) == l_6_1:ip_at_index(0) then
        l_6_0._discovered_hosts[i_host] = new_host_data
        already_known = true
    else
      end
    end
    if not already_known then
      table.insert(l_6_0._discovered_hosts, new_host_data)
    end
  end
end

ClientNetworkSession.on_server_up_received = function(l_7_0, l_7_1)
  if l_7_0._discovered_hosts then
    l_7_1:request_host_discover_reply()
  end
end

ClientNetworkSession.discovered_hosts = function(l_8_0)
  return l_8_0._discovered_hosts
end

ClientNetworkSession.send_to_host = function(l_9_0, ...)
  if l_9_0._server_peer then
    l_9_0._server_peer:send(...)
  else
    print("[ClientNetworkSession:send_to_host] no host")
     -- DECOMPILER ERROR: Confused about usage of registers for local variables.

  end
end

ClientNetworkSession.is_host = function(l_10_0)
  return false
end

ClientNetworkSession.is_client = function(l_11_0)
  return true
end

ClientNetworkSession.load_level = function(l_12_0, ...)
  l_12_0:_load_level(...)
   -- DECOMPILER ERROR: Confused about usage of registers for local variables.

end

ClientNetworkSession.load_lobby = function(l_13_0, ...)
  l_13_0:_load_lobby(...)
   -- DECOMPILER ERROR: Confused about usage of registers for local variables.

end

ClientNetworkSession.peer_handshake = function(l_14_0, l_14_1, l_14_2, l_14_3, l_14_4, l_14_5, l_14_6, l_14_7, l_14_8, l_14_9, l_14_10)
  print("ClientNetworkSession:peer_handshake", l_14_1, l_14_2, l_14_3, l_14_4, l_14_5, l_14_6, l_14_7, l_14_8, l_14_9, l_14_10)
  if l_14_0._peers[l_14_2] then
    print("ALREADY HAD PEER returns here")
    local peer = l_14_0._peers[l_14_2]
    if peer:ip_verified() then
      l_14_0._server_peer:send("connection_established", l_14_2)
    end
    return 
  end
  local rpc = nil
  if l_14_0._server_protocol == "STEAM" then
    rpc = Network:handshake(l_14_3, nil, "STEAM")
    Network:add_co_client(rpc)
  end
  if SystemInfo:platform() == Idstring("X360") then
    local ip = managers.network.matchmake:internal_address(l_14_10)
    rpc = Network:handshake(ip, managers.network.DEFAULT_PORT, "TCP_IP")
    Network:add_co_client(rpc)
  end
  if SystemInfo:platform() ~= l_14_0._ids_WIN32 or not l_14_3 then
    l_14_3 = false
  end
  local id, peer = l_14_0:add_peer(l_14_1, rpc, l_14_4, l_14_5, l_14_6, l_14_2, l_14_7, l_14_3, l_14_9, l_14_10)
  cat_print("multiplayer_base", "[ClientNetworkSession:peer_handshake]", l_14_1, l_14_3, l_14_5, l_14_6, id, inspect(peer))
  local check_peer = SystemInfo:platform() == Idstring("X360") and peer or nil
  l_14_0:chk_send_connection_established(l_14_1, l_14_3, check_peer)
  if managers.trade then
    managers.trade:handshake_complete(l_14_2)
  end
end

ClientNetworkSession.on_PSN_connection_established = function(l_15_0, l_15_1, l_15_2)
  if SystemInfo:platform() ~= Idstring("PS3") then
    return 
  end
  l_15_0:chk_send_connection_established(l_15_1, nil, false)
end

ClientNetworkSession.on_peer_synched = function(l_16_0, l_16_1)
  local peer = l_16_0._peers[l_16_1]
  if not peer then
    cat_error("multiplayer_base", "[ClientNetworkSession:on_peer_synched] Unknown Peer:", l_16_1)
    return 
  end
  peer:set_loading(false)
  peer:set_synched(true)
  managers.network:game():on_peer_sync_complete(peer, l_16_1)
end

ClientNetworkSession.ok_to_load_level = function(l_17_0)
  print("[ClientNetworkSession:ok_to_load_level]", l_17_0._recieved_ok_to_load_level, l_17_0._local_peer:id())
  if l_17_0._closing then
    return 
  end
  l_17_0:send_to_host("set_loading_state", true)
  if l_17_0._recieved_ok_to_load_level then
    print("Allready recieved ok to load level, returns")
    return 
  end
  l_17_0._recieved_ok_to_load_level = true
  if managers.menu:active_menu() then
    managers.menu:close_menu()
  end
  managers.system_menu:force_close_all()
  local level_id = Global.game_settings.level_id
  if level_id then
    local level_name = tweak_data.levels[level_id].world_name
  end
  local mission = Global.game_settings.mission ~= "none" and Global.game_settings.mission or nil
  managers.network:session():load_level(level_name, mission, nil, nil, level_id)
end

ClientNetworkSession.ok_to_load_lobby = function(l_18_0)
  print("[ClientNetworkSession:ok_to_load_lobby]", l_18_0._recieved_ok_to_load_lobby, l_18_0._local_peer:id())
  if l_18_0._closing then
    return 
  end
  if l_18_0:_local_peer_in_lobby() then
    return 
  end
  l_18_0:send_to_host("set_loading_state", true)
  if l_18_0._recieved_ok_to_load_lobby then
    print("Allready recieved ok to load lobby, returns")
    return 
  end
  l_18_0._recieved_ok_to_load_lobby = true
  if managers.menu:active_menu() then
    managers.menu:close_menu()
  end
  managers.system_menu:force_close_all()
  managers.network:session():load_lobby()
end

ClientNetworkSession.on_mutual_connection = function(l_19_0, l_19_1)
  local other_peer = l_19_0._peers[l_19_1]
  if not other_peer then
    return 
  end
  if l_19_0._local_peer:loaded() and other_peer:ip_verified() then
    other_peer:send_after_load("set_member_ready", l_19_0._local_peer:waiting_for_player_ready())
  end
end

ClientNetworkSession.on_peer_requested_info = function(l_20_0, l_20_1)
  local other_peer = l_20_0._peers[l_20_1]
  if not other_peer then
    return 
  end
  other_peer:set_ip_verified(true)
  Global.local_member:sync_lobby_data(other_peer)
  Global.local_member:sync_data(other_peer)
  other_peer:send("set_loading_state", l_20_0._local_peer:loading())
  other_peer:send("peer_exchange_info", l_20_0._local_peer:id())
end

ClientNetworkSession.update = function(l_21_0)
  ClientNetworkSession.super.update(l_21_0)
  if not l_21_0._closing then
    local wall_time = TimerManager:wall():time()
    if l_21_0._server_peer and l_21_0._host_sanity_send_t and l_21_0._host_sanity_send_t < wall_time then
      l_21_0._server_peer:send("sanity_check_network_status")
      l_21_0._host_sanity_send_t = wall_time + l_21_0.HOST_SANITY_CHECK_INTERVAL
    end
    l_21_0:_upd_request_join_resend(wall_time)
  end
end

ClientNetworkSession._soft_remove_peer = function(l_22_0, l_22_1)
  ClientNetworkSession.super._soft_remove_peer(l_22_0, l_22_1)
  if l_22_1:id() == 1 then
    Network:set_disconnected()
  end
end

ClientNetworkSession.on_peer_save_received = function(l_23_0, l_23_1, l_23_2)
  if managers.network:stopping() then
    return 
  end
  local packet_index = l_23_2.index
  local total_nr_packets = l_23_2.total
  print("[ClientNetworkSession:on_peer_save_received]", packet_index, "/", total_nr_packets)
  local kit_menu = managers.menu:get_menu("kit_menu")
  if not kit_menu or not kit_menu.renderer:is_open() then
    return 
  end
  if packet_index == total_nr_packets then
    local is_ready = l_23_0._local_peer:waiting_for_player_ready()
    if is_ready then
      kit_menu.renderer:set_slot_ready(l_23_0._local_peer, l_23_0._local_peer:id())
    else
      kit_menu.renderer:set_slot_not_ready(l_23_0._local_peer, l_23_0._local_peer:id())
    end
  else
    local progress_ratio = packet_index / total_nr_packets
    local progress_percentage = math.floor(math.clamp(progress_ratio * 100, 0, 100))
    managers.menu:get_menu("kit_menu").renderer:set_dropin_progress(l_23_0._local_peer:id(), progress_percentage)
  end
end

ClientNetworkSession.is_expecting_sanity_chk_reply = function(l_24_0)
  return not l_24_0._host_sanity_send_t or true
end

ClientNetworkSession.load = function(l_25_0, l_25_1)
  ClientNetworkSession.super.load(l_25_0, l_25_1)
end

ClientNetworkSession.on_load_complete = function(l_26_0)
  ClientNetworkSession.super.on_load_complete(l_26_0)
  l_26_0._host_sanity_send_t = TimerManager:wall():time() + l_26_0.HOST_SANITY_CHECK_INTERVAL
end

ClientNetworkSession._get_join_attempt_identifier = function(l_27_0)
  if not l_27_0._join_attempt_identifier then
    l_27_0._join_attempt_identifier = math.random(1, 65536)
  end
  return l_27_0._join_attempt_identifier
end

ClientNetworkSession._upd_request_join_resend = function(l_28_0, l_28_1)
  if l_28_0._last_join_request_t and ClientNetworkSession.HOST_REQUEST_JOIN_INTERVAL < l_28_1 - l_28_0._last_join_request_t then
    l_28_0._join_request_params.host_rpc:request_join(unpack(l_28_0._join_request_params.params))
    l_28_0._last_join_request_t = l_28_1
  end
end


