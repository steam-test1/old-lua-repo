-- Decompiled using luadec 2.0.1 by sztupy (http://winmo.sztupy.hu)
-- Command line was: F:\SteamLibrary\SteamApps\common\PAYDAY 2\lua\lib\network\base\basenetworksession.luac 

if not BaseNetworkSession then
  BaseNetworkSession = class()
end
BaseNetworkSession.TIMEOUT_CHK_INTERVAL = 5
if SystemInfo:platform() == Idstring("X360") then
  BaseNetworkSession.CONNECTION_TIMEOUT = 15
else
  BaseNetworkSession.CONNECTION_TIMEOUT = 10
end
BaseNetworkSession.LOADING_CONNECTION_TIMEOUT = 20
BaseNetworkSession._LOAD_WAIT_TIME = 3
BaseNetworkSession._STEAM_P2P_SEND_INTERVAL = 1
BaseNetworkSession.init = function(l_1_0)
  print("[BaseNetworkSession:init]")
  l_1_0._ids_WIN32 = Idstring("WIN32")
  local my_name = managers.network.account:username_id()
  local my_user_id = SystemInfo:platform() == l_1_0._ids_WIN32 and Steam:userid() or false
  l_1_0._local_peer = NetworkPeer:new(my_name, Network:self("TCP_IP"), 1, false, false, false, managers.blackmarket:get_preferred_character(), my_user_id)
  l_1_0._local_peer:set_outfit_string(managers.blackmarket:outfit_string())
  l_1_0._peers = {}
  l_1_0._server_peer = nil
  l_1_0._timeout_chk_t = 0
  l_1_0._kicked_list = {}
  l_1_0._connection_established_results = {}
  l_1_0._soft_remove_peers = false
  Network:set_client_send_callback(callback(l_1_0, l_1_0, "clbk_network_send"))
  l_1_0._dropin_complete_event_manager_id = EventManager:register_listener(Idstring("net_save_received"), callback(l_1_0, l_1_0, "on_peer_save_received"))
end

BaseNetworkSession.load = function(l_2_0, l_2_1)
  for peer_id,peer_data in pairs(l_2_1.peers) do
    l_2_0._peers[peer_id] = NetworkPeer:new()
    l_2_0._peers[peer_id]:load(peer_data)
  end
  if l_2_1.server_peer then
    l_2_0._server_peer = l_2_0._peers[l_2_1.server_peer]
  end
  l_2_0._local_peer:load(l_2_1.local_peer)
  l_2_0.update = l_2_0.update_skip_one
  l_2_0._kicked_list = l_2_1.kicked_list
  l_2_0._connection_established_results = l_2_1.connection_established_results
  if l_2_1.dead_con_reports then
    l_2_0._dead_con_reports = {}
    for _,report in ipairs(l_2_1.dead_con_reports) do
      local report = {process_t = report.process_t, reporter = l_2_0._peers[report.reporter], reported = l_2_0._peers[report.reported]}
      table.insert(l_2_0._dead_con_reports, report)
    end
  end
  l_2_0._server_protocol = l_2_1.server_protocol
end

BaseNetworkSession.save = function(l_3_0, l_3_1)
  if l_3_0._server_peer then
    l_3_1.server_peer = l_3_0._server_peer:id()
  end
  local peers = {}
  l_3_1.peers = peers
  for peer_id,peer in pairs(l_3_0._peers) do
    local peer_data = {}
    peers[peer_id] = peer_data
    peer:save(peer_data)
  end
  l_3_1.local_peer = {}
  l_3_0._local_peer:save(l_3_1.local_peer)
  l_3_1.kicked_list = l_3_0._kicked_list
  l_3_1.connection_established_results = l_3_0._connection_established_results
  if l_3_0._dead_con_reports then
    l_3_1.dead_con_reports = {}
    for _,report in ipairs(l_3_0._dead_con_reports) do
      local save_report = {process_t = report.process_t, reporter = report.reporter:id(), reported = report.reported:id()}
      table.insert(l_3_1.dead_con_reports, save_report)
    end
  end
  if l_3_0._dropin_complete_event_manager_id then
    EventManager:unregister_listener(l_3_0._dropin_complete_event_manager_id)
    l_3_0._dropin_complete_event_manager_id = nil
  end
  l_3_0:_flush_soft_remove_peers()
  l_3_1.server_protocol = l_3_0._server_protocol
end

BaseNetworkSession.server_peer = function(l_4_0)
  return l_4_0._server_peer
end

BaseNetworkSession.peer = function(l_5_0, l_5_1)
  local peer = l_5_0._peers[l_5_1]
  if peer then
    return peer
  else
    if l_5_1 == l_5_0._local_peer:id() then
      return l_5_0._local_peer
    end
  end
end

BaseNetworkSession.peers = function(l_6_0)
  return l_6_0._peers
end

BaseNetworkSession.peer_by_ip = function(l_7_0, l_7_1)
  for peer_id,peer in pairs(l_7_0._peers) do
    if peer:ip() == l_7_1 then
      return peer
    end
  end
  if l_7_0._local_peer:ip() == l_7_1 then
    return l_7_0._local_peer
  end
end

BaseNetworkSession.peer_by_name = function(l_8_0, l_8_1)
  for peer_id,peer in pairs(l_8_0._peers) do
    if peer:name() == l_8_1 then
      return peer
    end
  end
end

BaseNetworkSession.peer_by_user_id = function(l_9_0, l_9_1)
  for peer_id,peer in pairs(l_9_0._peers) do
    if peer:user_id() == l_9_1 then
      return peer
    end
  end
  if l_9_0._local_peer:user_id() == l_9_1 then
    return l_9_0._local_peer
  end
end

BaseNetworkSession.local_peer = function(l_10_0)
  return l_10_0._local_peer
end

BaseNetworkSession.is_kicked = function(l_11_0, l_11_1)
  return l_11_0._kicked_list[l_11_1]
end

BaseNetworkSession.add_peer = function(l_12_0, l_12_1, l_12_2, l_12_3, l_12_4, l_12_5, l_12_6, l_12_7, l_12_8, l_12_9, l_12_10)
  print("[BaseNetworkSession:add_peer]", l_12_1, l_12_2, l_12_3, l_12_4, l_12_5, l_12_6, l_12_7, l_12_8, l_12_9, l_12_10)
  local peer = NetworkPeer:new(l_12_1, l_12_2, l_12_6, l_12_4, l_12_5, l_12_3, l_12_7, l_12_8)
  peer:set_xuid(l_12_9)
  peer:set_xnaddr(l_12_10)
  if SystemInfo:platform() == Idstring("WIN32") then
    Steam:set_played_with(peer:user_id())
  end
  l_12_0._peers[l_12_6] = peer
  managers.network:game():on_peer_added(peer, l_12_6)
  if l_12_5 then
    managers.network:game():on_peer_sync_complete(peer, l_12_6)
  end
  if l_12_2 then
    l_12_0:remove_connection_from_trash(l_12_2)
    l_12_0:remove_connection_from_soft_remove_peers(l_12_2)
  end
  return l_12_6, peer
end

BaseNetworkSession.remove_peer = function(l_13_0, l_13_1, l_13_2, l_13_3)
  print("[BaseNetworkSession:remove_peer]", inspect(l_13_1), l_13_2, l_13_3)
  Application:stack_dump()
  if l_13_2 == 1 then
    l_13_0._server_peer = nil
  end
  l_13_0._peers[l_13_2] = nil
  l_13_0._connection_established_results[l_13_1:name()] = nil
  if l_13_1:rpc() then
    l_13_0:_soft_remove_peer(l_13_1)
  else
    l_13_1:destroy()
  end
  managers.network:game():on_peer_removed(l_13_1, l_13_2, l_13_3)
end

BaseNetworkSession._soft_remove_peer = function(l_14_0, l_14_1)
  if not l_14_0._soft_remove_peers then
    l_14_0._soft_remove_peers = {}
  end
  l_14_0._soft_remove_peers[l_14_1:rpc():ip_at_index(0)] = {peer = l_14_1, expire_t = TimerManager:wall():time() + 1.5}
end

BaseNetworkSession.on_peer_left_lobby = function(l_15_0, l_15_1)
  if l_15_1:id() == 1 and l_15_0:is_client() and l_15_0._cb_find_game then
    l_15_0:on_join_request_timed_out()
  end
end

BaseNetworkSession.on_peer_left = function(l_16_0, l_16_1, l_16_2)
  cat_print("multiplayer_base", "[BaseNetworkSession:on_peer_left] Peer Left", l_16_2, l_16_1:name(), l_16_1:ip())
  Application:stack_dump()
  l_16_0:remove_peer(l_16_1, l_16_2, "left")
  if l_16_2 == 1 and l_16_0:is_client() then
    if l_16_0._cb_find_game then
      l_16_0:on_join_request_timed_out()
    else
      if l_16_0:_local_peer_in_lobby() then
        managers.network.matchmake:leave_game()
      else
        managers.network.matchmake:destroy_game()
      end
      managers.network.voice_chat:destroy_voice()
      if game_state_machine:current_state().on_server_left then
        game_state_machine:current_state():on_server_left()
      end
    end
  end
end

BaseNetworkSession.on_peer_lost = function(l_17_0, l_17_1, l_17_2)
  cat_print("multiplayer_base", "[BaseNetworkSession:on_peer_lost] Peer Lost", l_17_2, l_17_1:name(), l_17_1:ip())
  Application:stack_dump()
  l_17_0:remove_peer(l_17_1, l_17_2, "lost")
  if l_17_2 == 1 and l_17_0:is_client() then
    if l_17_0._cb_find_game then
      l_17_0:on_join_request_timed_out()
    else
      if l_17_0:_local_peer_in_lobby() then
        managers.network.matchmake:leave_game()
      else
        managers.network.matchmake:destroy_game()
      end
      managers.network.voice_chat:destroy_voice()
      if managers.network:stopping() then
        return 
      end
      managers.system_menu:close("leave_lobby")
      if game_state_machine:current_state().on_server_left then
        Global.on_server_left_message = "dialog_connection_to_host_lost"
        game_state_machine:current_state():on_server_left()
      end
    end
  end
  if l_17_2 ~= 1 and l_17_0:is_client() and l_17_0._server_peer then
    l_17_0._server_peer:send_after_load("report_dead_connection", l_17_2)
  end
end

BaseNetworkSession.on_peer_kicked = function(l_18_0, l_18_1, l_18_2)
  if l_18_1 ~= l_18_0._local_peer then
    if l_18_0._ids_WIN32 ~= SystemInfo:platform() or not l_18_1:user_id() then
      local ident = l_18_1:name()
    end
    l_18_0._kicked_list[ident] = true
    l_18_0:remove_peer(l_18_1, l_18_2, "kicked")
  else
    print("IVE BEEN KICKED!")
    if l_18_0:_local_peer_in_lobby() then
      print("KICKED FROM LOBBY")
      managers.menu:on_leave_lobby()
      managers.menu:show_peer_kicked_dialog()
    else
      print("KICKED FROM INGAME")
      managers.network.matchmake:destroy_game()
      managers.network.voice_chat:destroy_voice()
      if game_state_machine:current_state().on_kicked then
        game_state_machine:current_state():on_kicked()
      end
    end
  end
end

BaseNetworkSession.on_remove_dead_peer = function(l_19_0, l_19_1, l_19_2)
  if l_19_1 ~= l_19_0._local_peer then
    l_19_0:remove_peer(l_19_1, l_19_2, "removed_dead")
  else
    print("IVE BEEN REMOVED DEAD!")
    if l_19_0._recieved_ok_to_load_level then
      print("ignoring due to self._received_ok_to_load_level")
    else
      Global.on_remove_dead_peer_message = "dialog_remove_dead_peer"
      if l_19_0:_local_peer_in_lobby() then
        print("REMOVED FROM LOBBY")
        managers.menu:on_leave_lobby()
        managers.menu:show_peer_kicked_dialog()
      else
        print("REMOVED FROM INGAME")
        managers.network.matchmake:destroy_game()
        managers.network.voice_chat:destroy_voice()
        if game_state_machine:current_state().on_kicked then
          game_state_machine:current_state():on_kicked()
        end
      end
    end
  end
end

BaseNetworkSession._local_peer_in_lobby = function(l_20_0)
  return not l_20_0._local_peer:in_lobby() or game_state_machine:current_state_name() ~= "ingame_lobby_menu"
end

BaseNetworkSession.update_skip_one = function(l_21_0)
  l_21_0.update = nil
  local wall_time = TimerManager:wall():time()
  l_21_0._timeout_chk_t = wall_time + l_21_0.TIMEOUT_CHK_INTERVAL
end

BaseNetworkSession.update = function(l_22_0)
  local wall_time = TimerManager:wall():time()
  if l_22_0._timeout_chk_t < wall_time then
    for peer_id,peer in pairs(l_22_0._peers) do
      if not peer:loading() or not l_22_0.LOADING_CONNECTION_TIMEOUT then
        peer:chk_timeout(l_22_0.CONNECTION_TIMEOUT)
      end
    end
    l_22_0._timeout_chk_t = wall_time + l_22_0.TIMEOUT_CHK_INTERVAL
  end
  if l_22_0._closing and l_22_0:is_ready_to_close() then
    l_22_0._closing = false
    managers.network:queue_stop_network()
  end
  l_22_0:upd_trash_connections(wall_time)
  l_22_0:send_steam_p2p_msgs(l_22_0, wall_time)
end

BaseNetworkSession.end_update = function(l_23_0)
end

BaseNetworkSession.send_to_peers = function(l_24_0, ...)
  for peer_id,peer in pairs(l_24_0._peers) do
    peer:send(...)
  end
   -- DECOMPILER ERROR: Confused about usage of registers for local variables.

end

BaseNetworkSession.send_to_peers_ip_verified = function(l_25_0, ...)
  for peer_id,peer in pairs(l_25_0._peers) do
    if peer:ip_verified() then
      peer:send(...)
    end
  end
   -- DECOMPILER ERROR: Confused about usage of registers for local variables.

end

BaseNetworkSession.send_to_peers_except = function(l_26_0, l_26_1, ...)
  for peer_id,peer in pairs(l_26_0._peers) do
    if peer_id ~= l_26_1 then
      peer:send(...)
    end
  end
   -- DECOMPILER ERROR: Confused about usage of registers for local variables.

end

BaseNetworkSession.send_to_peers_synched = function(l_27_0, ...)
  for peer_id,peer in pairs(l_27_0._peers) do
    peer:send_queued_sync(...)
  end
   -- DECOMPILER ERROR: Confused about usage of registers for local variables.

end

BaseNetworkSession.send_to_peers_synched_except = function(l_28_0, l_28_1, ...)
  for peer_id,peer in pairs(l_28_0._peers) do
    if peer_id ~= l_28_1 then
      peer:send_queued_sync(...)
    end
  end
   -- DECOMPILER ERROR: Confused about usage of registers for local variables.

end

BaseNetworkSession.send_to_peers_loaded = function(l_29_0, ...)
  for peer_id,peer in pairs(l_29_0._peers) do
    peer:send_after_load(...)
  end
   -- DECOMPILER ERROR: Confused about usage of registers for local variables.

end

BaseNetworkSession.send_to_peers_loaded_except = function(l_30_0, l_30_1, ...)
  for peer_id,peer in pairs(l_30_0._peers) do
    if peer_id ~= l_30_1 then
      peer:send_after_load(...)
    end
  end
   -- DECOMPILER ERROR: Confused about usage of registers for local variables.

end

BaseNetworkSession.send_to_peer = function(l_31_0, l_31_1, ...)
  l_31_1:send(...)
   -- DECOMPILER ERROR: Confused about usage of registers for local variables.

end

BaseNetworkSession.send_to_peer_synched = function(l_32_0, l_32_1, ...)
  l_32_1:send_queued_sync(...)
   -- DECOMPILER ERROR: Confused about usage of registers for local variables.

end

BaseNetworkSession.has_recieved_ok_to_load_level = function(l_33_0)
  return l_33_0._recieved_ok_to_load_level
end

BaseNetworkSession._load_level = function(l_34_0, ...)
  l_34_0._local_peer:set_loading(true)
  Network:set_multiplayer(true)
  setup:load_level(...)
  l_34_0._load_wait_timeout_t = TimerManager:wall():time() + l_34_0._LOAD_WAIT_TIME
   -- DECOMPILER ERROR: Confused about usage of registers for local variables.

end

BaseNetworkSession._load_lobby = function(l_35_0, ...)
  managers.menu:on_leave_active_job()
  l_35_0._local_peer:set_loading(true)
  Network:set_multiplayer(true)
  setup:load_start_menu_lobby(...)
  l_35_0._load_wait_timeout_t = TimerManager:wall():time() + l_35_0._LOAD_WAIT_TIME
   -- DECOMPILER ERROR: Confused about usage of registers for local variables.

end

BaseNetworkSession.debug_list_peers = function(l_36_0)
  for i,peer in pairs(l_36_0._peers) do
    cat_print("multiplayer_base", "Peer", i, peer:connection_info())
  end
end

BaseNetworkSession.clbk_network_send = function(l_37_0, l_37_1, l_37_2)
  local target_ip = l_37_1:ip_at_index(0)
  if l_37_2 then
    if l_37_0._soft_remove_peers and l_37_0._soft_remove_peers[target_ip] then
      local ok_to_delete = true
      local peer_remove_info = l_37_0._soft_remove_peers[target_ip]
      if not peer_remove_info.expire_t or TimerManager:game():time() < peer_remove_info.expire_t then
        local send_resume = Network:get_connection_send_status(l_37_1)
        if send_resume then
          for delivery_type,amount in pairs(send_resume) do
            if amount > 0 then
              ok_to_delete = false
          else
            end
          end
        end
        if ok_to_delete then
          print("[BaseNetworkSession:clbk_network_send] soft-removed peer", peer_remove_info.peer:id(), target_ip)
          peer_remove_info.peer:destroy()
          l_37_0._soft_remove_peers[target_ip] = nil
          if not next(l_37_0._soft_remove_peers) then
            l_37_0._soft_remove_peers = false
          else
            if l_37_1:protocol_at_index(0) ~= "TCP_IP" or not l_37_0:peer_by_ip(target_ip) then
              local peer = l_37_0:peer_by_user_id(target_ip)
            end
            if not peer then
              l_37_0:add_connection_to_trash(l_37_1)
            else
              local peer = l_37_0:peer_by_ip(target_ip)
              if peer then
                peer:on_send()
              end
            end
          end
        end
      end
    end
     -- Warning: missing end command somewhere! Added here
  end
end

BaseNetworkSession.is_ready_to_close = function(l_38_0)
  for peer_id,peer in pairs(l_38_0._peers) do
    if peer:has_queued_rpcs() then
      print("[BaseNetworkSession:is_ready_to_close] waiting queued rpcs", peer_id)
      return false
    end
    if not peer:rpc() then
      print("[BaseNetworkSession:is_ready_to_close] waiting rpc", peer_id)
      return false
    end
  end
  return true
end

BaseNetworkSession.closing = function(l_39_0)
  return l_39_0._closing
end

BaseNetworkSession.prepare_to_close = function(l_40_0, l_40_1)
  print("[BaseNetworkSession:prepare_to_close]")
  l_40_0._closing = true
  if not l_40_1 then
    managers.network.matchmake:destroy_game()
  end
  Network:set_disconnected()
end

BaseNetworkSession.set_peer_loading_state = function(l_41_0, l_41_1, l_41_2)
  print("[BaseNetworkSession:set_peer_loading_state]", l_41_1:id(), l_41_2)
  l_41_1:set_loading(l_41_2)
  if Global.load_start_menu_lobby then
    return 
  end
  if not l_41_2 and l_41_0._local_peer:loaded() then
    if l_41_1:ip_verified() then
      Global.local_member:sync_lobby_data(l_41_1)
      Global.local_member:sync_data(l_41_1)
      l_41_1:send_after_load("set_member_ready", l_41_0._local_peer:waiting_for_player_ready())
    end
    l_41_1:flush_overwriteable_msgs()
  end
end

BaseNetworkSession.upd_trash_connections = function(l_42_0, l_42_1)
  if l_42_0._trash_connections then
    for ip,info in pairs(l_42_0._trash_connections) do
      if info.expire_t < l_42_1 then
        local reset = true
        for peer_id,peer in pairs(l_42_0._peers) do
          if (peer:ip_verified() and peer:ip() == ip) or peer:user_id() == ip then
            reset = false
        else
          end
        end
        if reset then
          print("[BaseNetworkSession:upd_trash_connections] resetting connection:", info.rpc:ip_at_index(0))
          Network:reset_connection(info.rpc)
        end
        l_42_0._trash_connections[ip] = nil
      end
    end
    if not next(l_42_0._trash_connections) then
      l_42_0._trash_connections = nil
    end
  end
  if l_42_0._soft_remove_peers then
    for peer_ip,info in pairs(l_42_0._soft_remove_peers) do
      if info.expire_t < l_42_1 then
        info.peer:destroy()
        l_42_0._soft_remove_peers[peer_ip] = nil
    else
      end
    end
    if not next(l_42_0._soft_remove_peers) then
      l_42_0._soft_remove_peers = nil
    end
  end
end

BaseNetworkSession.add_connection_to_trash = function(l_43_0, l_43_1)
  local wanted_ip = l_43_1:ip_at_index(0)
  if not l_43_0._trash_connections then
    l_43_0._trash_connections = {}
  end
  if not l_43_0._trash_connections[wanted_ip] then
    print("[BaseNetworkSession:add_connection_to_trash]", wanted_ip)
    l_43_0._trash_connections[wanted_ip] = {rpc = l_43_1, expire_t = TimerManager:wall():time() + l_43_0.CONNECTION_TIMEOUT}
  end
end

BaseNetworkSession.remove_connection_from_trash = function(l_44_0, l_44_1)
  local wanted_ip = l_44_1:ip_at_index(0)
  if l_44_0._trash_connections then
    if l_44_0._trash_connections[wanted_ip] then
      print("[BaseNetworkSession:remove_connection_from_trash]", wanted_ip)
    end
    l_44_0._trash_connections[wanted_ip] = nil
    if not next(l_44_0._trash_connections) then
      l_44_0._trash_connections = nil
    end
  end
end

BaseNetworkSession.remove_connection_from_soft_remove_peers = function(l_45_0, l_45_1)
  if l_45_0._soft_remove_peers and l_45_0._soft_remove_peers[l_45_1:ip_at_index(0)] then
    l_45_0._soft_remove_peers[l_45_1:ip_at_index(0)] = nil
    if not next(l_45_0._soft_remove_peers) then
      l_45_0._soft_remove_peers = nil
    end
  end
end

BaseNetworkSession.chk_send_local_player_ready = function(l_46_0)
  local state = l_46_0._local_peer:waiting_for_player_ready()
  managers.network:session():send_to_peers_loaded("set_member_ready", state)
end

BaseNetworkSession.destroy = function(l_47_0)
  if l_47_0._dropin_complete_event_manager_id then
    EventManager:unregister_listener(l_47_0._dropin_complete_event_manager_id)
    l_47_0._dropin_complete_event_manager_id = nil
  end
end

BaseNetworkSession._flush_soft_remove_peers = function(l_48_0)
  if l_48_0._soft_remove_peers then
    for ip,peer_remove_info in pairs(l_48_0._soft_remove_peers) do
      cat_print("multiplayer_base", "[BaseNetworkSession:destroy] soft-removed peer", peer_remove_info.peer:id(), ip)
      peer_remove_info.peer:destroy()
    end
  end
  l_48_0._soft_remove_peers = nil
end

BaseNetworkSession.on_load_complete = function(l_49_0)
  print("[BaseNetworkSession:on_load_complete]")
  l_49_0._local_peer:set_loading(false)
  for peer_id,peer in pairs(l_49_0._peers) do
    if peer:ip_verified() then
      peer:send("set_loading_state", false)
    end
  end
end

BaseNetworkSession.on_steam_p2p_ping = function(l_50_0, l_50_1)
  local user_id = l_50_1:ip_at_index(0)
  local peer = l_50_0:peer_by_user_id(user_id)
  if not peer then
    print("[BaseNetworkSession:on_steam_p2p_ping] unknown peer", user_id)
    return 
  end
  if l_50_0._server_protocol ~= "TCP_IP" then
    print("[BaseNetworkSession:on_steam_p2p_ping] wrong server protocol", l_50_0._server_protocol)
    return 
  end
  local final_rpc = l_50_0:resolve_new_peer_rpc(peer)
  if not final_rpc then
    return 
  end
  if peer:rpc() and final_rpc:ip_at_index(0) == peer:rpc():ip_at_index(0) and final_rpc:protocol_at_index(0) == peer:rpc():protocol_at_index(0) then
    local sender_ip = Network:get_ip_address_from_user_id(user_id)
    print("[BaseNetworkSession:on_steam_p2p_ping] already had IP", peer:rpc():ip_at_index(0), peer:rpc():protocol_at_index(0))
    return 
  end
  peer:set_rpc(final_rpc)
  Network:add_co_client(final_rpc)
  l_50_0:remove_connection_from_trash(final_rpc)
  l_50_0:remove_connection_from_soft_remove_peers(final_rpc)
  l_50_0:chk_send_connection_established(nil, user_id)
end

BaseNetworkSession.chk_send_connection_established = function(l_51_0, l_51_1, l_51_2, l_51_3)
  if SystemInfo:platform() == Idstring("PS3") then
    l_51_3 = l_51_0:peer_by_name(l_51_1)
    if not l_51_3 then
      print("[BaseNetworkSession:chk_send_connection_established] no peer yet", l_51_1)
      return 
    end
    local connection_info = managers.network.matchmake:get_connection_info(l_51_1)
    if not connection_info then
      print("[BaseNetworkSession:chk_send_connection_established] no connection_info yet", l_51_1)
      return 
    end
     -- DECOMPILER ERROR: unhandled construct in 'if'

    if connection_info.dead and l_51_3:id() ~= 1 then
      print("[BaseNetworkSession:chk_send_connection_established] reporting dead connection", l_51_1)
      if l_51_0._server_peer then
        l_51_0._server_peer:send_queued_load("report_dead_connection", l_51_3:id())
      end
    end
    return 
    local rpc = Network:handshake(connection_info.external_ip, connection_info.port, "TCP_IP")
    l_51_3:set_rpc(rpc)
    Network:add_co_client(rpc)
    l_51_0:remove_connection_from_trash(rpc)
    l_51_0:remove_connection_from_soft_remove_peers(rpc)
  elseif not l_51_3 then
    l_51_3 = l_51_0:peer_by_user_id(l_51_2)
  end
  if not l_51_3 then
    print("[BaseNetworkSession:chk_send_connection_established] no peer yet", l_51_2)
    return 
  end
  if not l_51_3:rpc() then
    print("[BaseNetworkSession:chk_send_connection_established] no rpc yet", l_51_2)
    return 
  end
  print("[BaseNetworkSession:chk_send_connection_established] success", l_51_1 or "", l_51_2 or "", l_51_3:id())
  if l_51_0._server_peer then
    l_51_0._server_peer:send("connection_established", l_51_3:id())
  end
end

BaseNetworkSession.send_steam_p2p_msgs = function(l_52_0, l_52_1)
  if l_52_0._server_protocol ~= "TCP_IP" then
    return 
  end
  if SystemInfo:platform() ~= l_52_0._ids_WIN32 then
    return 
  end
  for peer_id,peer in pairs(l_52_0._peers) do
    if peer ~= l_52_0._server_peer and not peer:ip_verified() and (not peer:next_steam_p2p_send_t(peer) or peer:next_steam_p2p_send_t(peer) < l_52_1) then
      peer:steam_rpc():steam_p2p_ping(peer:steam_rpc())
      peer:set_next_steam_p2p_send_t(peer, l_52_1 + l_52_0._STEAM_P2P_SEND_INTERVAL)
    end
  end
end

BaseNetworkSession.resolve_new_peer_rpc = function(l_53_0, l_53_1, l_53_2)
  if SystemInfo:platform() ~= l_53_0._ids_WIN32 then
    return l_53_2
  end
  local new_peer_ip_address = Network:get_ip_address_from_user_id(l_53_1:user_id())
  print("new_peer_ip_address", new_peer_ip_address)
  if new_peer_ip_address then
    local new_peer_ip_address_split = string.split(new_peer_ip_address, ":")
    local new_peer_ip = new_peer_ip_address_split[1]
    local new_peer_port = new_peer_ip_address_split[2]
    local connect_port = new_peer_port
    print("new_peer_ip", new_peer_ip, "new_peer_port", new_peer_port)
    if string.begins(new_peer_ip, "192.168.") then
      print("using internal port", NetworkManager.DEFAULT_PORT)
      connect_port = NetworkManager.DEFAULT_PORT
    end
    return Network:handshake(new_peer_ip, connect_port, "TCP_IP")
  else
    Application:error("[BaseNetworkSession:resolve_new_peer_rpc] could not resolve IP address!!!")
    return l_53_2
  end
end


