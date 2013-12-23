-- Decompiled using luadec 2.0.1 by sztupy (http://winmo.sztupy.hu)
-- Command line was: F:\SteamLibrary\SteamApps\common\PAYDAY 2\lua\lib\network\base\hostnetworksession.luac 

require("lib/network/base/session_states/HostStateBase")
require("lib/network/base/session_states/HostStateInLobby")
require("lib/network/base/session_states/HostStateInGame")
require("lib/network/base/session_states/HostStateLoadout")
require("lib/network/base/session_states/HostStateGameEnd")
require("lib/network/base/session_states/HostStateClosing")
if not HostNetworkSession then
  HostNetworkSession = class(BaseNetworkSession)
end
local l_0_0 = HostNetworkSession
local l_0_1 = {}
l_0_1.in_lobby = HostStateInLobby
l_0_1.loadout = HostStateLoadout
l_0_1.in_game = HostStateInGame
l_0_1.game_end = HostStateGameEnd
l_0_1.closing = HostStateClosing
l_0_0._STATES = l_0_1
l_0_0 = HostNetworkSession
l_0_0._DEAD_CONNECTION_REPORT_PROCESS_DELAY = 5
l_0_0 = HostNetworkSession
l_0_1 = function(l_1_0)
  HostNetworkSession.super.init(l_1_0)
  l_1_0._state_data = {session = l_1_0, peers = l_1_0._peers, kicked_list = l_1_0._kicked_list, local_peer = l_1_0._local_peer}
  l_1_0:set_state("in_lobby")
end

l_0_0.init = l_0_1
l_0_0 = HostNetworkSession
l_0_1 = function(l_2_0, l_2_1, l_2_2, l_2_3, l_2_4, l_2_5, l_2_6, l_2_7, l_2_8)
  if l_2_0._state.on_join_request_received then
    return l_2_0._state:on_join_request_received(l_2_0._state_data, l_2_1, l_2_2, l_2_3, l_2_4, l_2_5, l_2_6, l_2_7, l_2_8)
  end
end

l_0_0.on_join_request_received = l_0_1
l_0_0 = HostNetworkSession
l_0_1 = function(l_3_0, ...)
  debug_pause("[HostNetworkSession:send_to_host] This is dumb. call the function directly instead of sending it...")
   -- DECOMPILER ERROR: Confused about usage of registers for local variables.

end

l_0_0.send_to_host = l_0_1
l_0_0 = HostNetworkSession
l_0_1 = function(l_4_0)
  return true
end

l_0_0.is_host = l_0_1
l_0_0 = HostNetworkSession
l_0_1 = function(l_5_0)
  return false
end

l_0_0.is_client = l_0_1
l_0_0 = HostNetworkSession
l_0_1 = function(l_6_0, ...)
  l_6_0._state:on_load_level(l_6_0._state_data)
  managers.network.matchmake:set_server_state("loading")
  for _,peer in pairs(l_6_0._peers) do
    peer:set_synched(false)
    peer:set_loaded(false)
  end
  l_6_0._local_peer:set_loaded(false)
  l_6_0:set_state("closing")
  l_6_0:send_to_peers("set_loading_state", true)
  l_6_0:send_ok_to_load_level()
  l_6_0:_load_level(...)
   -- DECOMPILER ERROR: Confused about usage of registers for local variables.

end

l_0_0.load_level = l_0_1
l_0_0 = HostNetworkSession
l_0_1 = function(l_7_0, ...)
  managers.network.matchmake:set_server_state("loading")
  for _,peer in pairs(l_7_0._peers) do
    peer:set_synched(false)
    peer:set_loaded(false)
    peer:set_in_lobby(true)
  end
  l_7_0._local_peer:set_loaded(false)
  l_7_0:set_state("closing")
  l_7_0:send_to_peers("set_loading_state", true)
  l_7_0:send_ok_to_load_lobby()
  l_7_0:_load_lobby(...)
   -- DECOMPILER ERROR: Confused about usage of registers for local variables.

end

l_0_0.load_lobby = l_0_1
l_0_0 = HostNetworkSession
l_0_1 = function(l_8_0)
  print("[HostNetworkSession:broadcast_server_up]")
  Network:broadcast(NetworkManager.DEFAULT_PORT):server_up()
end

l_0_0.broadcast_server_up = l_0_1
l_0_0 = HostNetworkSession
l_0_1 = function(l_9_0)
end

l_0_0.on_server_up_received = l_0_1
l_0_0 = HostNetworkSession
l_0_1 = function(l_10_0, l_10_1)
  if Global.load_start_menu_lobby then
    l_10_0:set_state("in_lobby")
  else
    l_10_0:set_state("loadout")
  end
  HostNetworkSession.super.load(l_10_0, l_10_1)
  l_10_0._state_data = {session = l_10_0, peers = l_10_0._peers, kicked_list = l_10_0._kicked_list, local_peer = l_10_0._local_peer}
end

l_0_0.load = l_0_1
l_0_0 = HostNetworkSession
l_0_1 = function(l_11_0, l_11_1, l_11_2)
  print("[HostNetworkSession:on_peer_connection_established]", l_11_1:id(), l_11_2)
  if not l_11_0._peers[l_11_2] then
    print("introduced peer does not exist. ignoring.")
    return 
  end
  print("status:", l_11_1:handshakes()[l_11_2], l_11_0._peers[l_11_2]:handshakes()[l_11_1:id()])
  if l_11_1:handshakes()[l_11_2] == "asked" then
    l_11_1:set_handshake_status(l_11_2, "exchanging_info")
    local introduced_peer = l_11_0._peers[l_11_2]
    if introduced_peer:handshakes()[l_11_1:id()] == "exchanging_info" then
      l_11_1:send_after_load("peer_exchange_info", l_11_2)
      introduced_peer:send_after_load("peer_exchange_info", l_11_1:id())
    end
    return 
  else
    if l_11_1:handshakes()[l_11_2] == "exchanging_info" then
      l_11_1:set_handshake_status(l_11_2, true)
    else
      print("peer was not asked. ignoring.")
      return 
    end
    if l_11_0._state.on_handshake_confirmation then
      l_11_0._state:on_handshake_confirmation(l_11_0._state_data, l_11_1, l_11_2)
    end
    l_11_0:chk_initiate_dropin_pause(l_11_1)
    if l_11_0._peers[l_11_2] then
      l_11_0:chk_initiate_dropin_pause(l_11_0._peers[l_11_2])
    end
     -- Warning: missing end command somewhere! Added here
  end
end

l_0_0.on_peer_connection_established = l_0_1
l_0_0 = HostNetworkSession
l_0_1 = function(l_12_0, l_12_1)
  l_12_0._game_started = l_12_1
  l_12_0._state_data.game_started = l_12_1
  if l_12_1 then
    l_12_0:set_state("in_game")
  end
end

l_0_0.set_game_started = l_0_1
l_0_0 = HostNetworkSession
l_0_1 = function(l_13_0, l_13_1)
  local old_peer = nil
  if l_13_1:protocol_at_index(0) == "STEAM" then
    old_peer = l_13_0:peer_by_user_id(l_13_1:ip_at_index(0))
  else
    old_peer = l_13_0:peer_by_ip(l_13_1:ip_at_index(0))
  end
  return old_peer
end

l_0_0.chk_peer_already_in = l_0_1
l_0_0 = HostNetworkSession
l_0_1 = function(l_14_0)
  for peer_id,peer in pairs(l_14_0._peers) do
    if not peer:loaded() and not peer:loading() then
      print("[HostNetworkSession:send_ok_to_load_level]", inspect(peer))
      peer:send("ok_to_load_level")
      for (for control),peer_id in (for generator) do
      end
      l_14_0:remove_peer(peer, peer_id, "lost")
    end
     -- Warning: missing end command somewhere! Added here
  end
end

l_0_0.send_ok_to_load_level = l_0_1
l_0_0 = HostNetworkSession
l_0_1 = function(l_15_0)
  for peer_id,peer in pairs(l_15_0._peers) do
    if not peer:loaded() and not peer:loading() then
      print("[HostNetworkSession:send_ok_to_load_lobby]", inspect(peer))
      peer:send("ok_to_load_lobby")
      for (for control),peer_id in (for generator) do
      end
      l_15_0:remove_peer(peer, peer_id, "lost")
    end
     -- Warning: missing end command somewhere! Added here
  end
end

l_0_0.send_ok_to_load_lobby = l_0_1
l_0_0 = HostNetworkSession
l_0_1 = function(l_16_0, l_16_1, l_16_2)
  if managers.network:stopping() then
    return 
  end
  local peer = l_16_0:peer_by_ip(l_16_2.ip_address)
  if not peer then
    Application:error("[HostNetworkSession:on_peer_save_received] A nonregistered peer confirmed save packet.")
    return 
  end
  if l_16_2.index then
    local packet_index = l_16_2.index
    local total_nr_packets = l_16_2.total
    local progress_ratio = packet_index / total_nr_packets
    local progress_percentage = math.floor(math.clamp(progress_ratio * 100, 0, 100))
    local is_playing = BaseNetworkHandler._gamestate_filter.any_ingame_playing[game_state_machine:last_queued_state_name()]
    if is_playing then
      managers.menu:update_person_joining(peer:id(), progress_percentage)
    else
      if BaseNetworkHandler._gamestate_filter.any_ingame[game_state_machine:last_queued_state_name()] then
        managers.menu:get_menu("kit_menu").renderer:set_dropin_progress(peer:id(), progress_percentage)
      end
    end
    l_16_0:send_to_peers_synched_except(peer:id(), "dropin_progress", peer:id(), progress_percentage)
  else
    cat_print("multiplayer_base", "[HostNetworkSession:on_peer_save_received]", peer, peer:id())
    peer:set_synched(true)
    peer:send("set_peer_synched", 1)
    for _,old_peer in pairs(l_16_0._peers) do
      if old_peer ~= peer then
        old_peer:send_after_load("set_peer_synched", peer:id())
      end
    end
    if NetworkManager.DROPIN_ENABLED then
      for other_peer_id,other_peer in pairs(l_16_0._peers) do
        if other_peer_id ~= peer:id() and other_peer:expecting_dropin() then
          l_16_0:set_dropin_pause_request(peer, other_peer_id, "asked")
        end
      end
      for old_peer_id,old_peer in pairs(l_16_0._peers) do
        if old_peer_id ~= peer:id() and old_peer:is_expecting_pause_confirmation(peer:id()) then
          l_16_0:set_dropin_pause_request(old_peer, peer:id(), false)
        end
      end
      if l_16_0._local_peer:is_expecting_pause_confirmation(peer:id()) then
        l_16_0._local_peer:set_expecting_drop_in_pause_confirmation((peer:id()), nil)
        managers.network:game():on_drop_in_pause_request_received(peer:id(), peer:name(), false)
      end
    end
    for other_peer_id,other_peer in pairs(l_16_0._peers) do
      l_16_0:chk_spawn_member_unit(other_peer, other_peer_id)
    end
    managers.network:game():on_peer_sync_complete(peer, peer:id())
  end
end

l_0_0.on_peer_save_received = l_0_1
l_0_0 = HostNetworkSession
l_0_1 = function(l_17_0)
  HostNetworkSession.super.update(l_17_0)
  l_17_0:process_dead_con_reports()
end

l_0_0.update = l_0_1
l_0_0 = HostNetworkSession
l_0_1 = function(l_18_0, l_18_1, l_18_2)
  print("[HostNetworkSession:set_peer_loading_state]", l_18_1:id(), l_18_2)
  HostNetworkSession.super.set_peer_loading_state(l_18_0, l_18_1, l_18_2)
  if Global.load_start_menu_lobby then
    return 
  end
  if not l_18_2 and l_18_0._local_peer:loaded() and NetworkManager.DROPIN_ENABLED then
    if l_18_0._state.on_peer_finished_loading then
      l_18_0._state:on_peer_finished_loading(l_18_0._state_data, l_18_1)
    end
    l_18_1:set_expecting_pause_sequence(true)
    local dropin_pause_ok = l_18_0:chk_initiate_dropin_pause(l_18_1)
    if dropin_pause_ok then
      l_18_0:chk_drop_in_peer(l_18_1)
    else
      print(" setting set_expecting_pause_sequence", l_18_1:id())
    end
  end
end

l_0_0.set_peer_loading_state = l_0_1
l_0_0 = HostNetworkSession
l_0_1 = function(l_19_0, l_19_1, l_19_2)
  print("[HostNetworkSession:on_drop_in_pause_confirmation_received]", l_19_2:id(), " paused for ", l_19_1)
  local is_expecting = l_19_2:is_expecting_pause_confirmation(l_19_1)
  local dropin_peer = l_19_0._peers[l_19_1]
  if dropin_peer and dropin_peer:expecting_dropin() then
    if is_expecting == "asked" then
      l_19_0:set_dropin_pause_request(l_19_2, l_19_1, "paused")
    else
      print("peer", l_19_2:id(), "was not asked for confirmation. is_expecting:", is_expecting)
    end
    l_19_0:chk_drop_in_peer(dropin_peer)
  else
    l_19_0:set_dropin_pause_request(l_19_2, l_19_1, false)
    if dropin_peer then
      l_19_0:chk_initiate_dropin_pause(dropin_peer)
    end
  end
end

l_0_0.on_drop_in_pause_confirmation_received = l_0_1
l_0_0 = HostNetworkSession
l_0_1 = function(l_20_0, l_20_1)
  print("[HostNetworkSession:chk_initiate_dropin_pause]", l_20_1:id())
  if not l_20_1:expecting_pause_sequence() then
    print("not expecting")
    return 
  end
  if not l_20_0:chk_peer_handshakes_complete(l_20_1) then
    print("misses handshakes")
    return 
  end
  for peer_id,peer in pairs(l_20_0._peers) do
    local is_expecting = peer:is_expecting_pause_confirmation(l_20_1:id())
    if is_expecting then
      print(" peer", peer_id, "is still to confirm", is_expecting)
      return 
    end
  end
  for other_peer_id,other_peer in pairs(l_20_0._peers) do
    if other_peer_id ~= l_20_1:id() and not other_peer:is_expecting_pause_confirmation(l_20_1:id()) then
      l_20_0:set_dropin_pause_request(other_peer, l_20_1:id(), "asked")
    end
  end
  if not l_20_0._local_peer:is_expecting_pause_confirmation(l_20_1:id()) then
    l_20_0._local_peer:set_expecting_drop_in_pause_confirmation(l_20_1:id(), "paused")
    managers.network:game():on_drop_in_pause_request_received(l_20_1:id(), l_20_1:name(), true)
  end
  l_20_1:set_expecting_pause_sequence(nil)
  l_20_1:set_expecting_dropin(true)
  return true
end

l_0_0.chk_initiate_dropin_pause = l_0_1
l_0_0 = HostNetworkSession
l_0_1 = function(l_21_0, l_21_1)
  if not l_21_1:expecting_dropin() then
    return 
  end
  local dropin_peer_id = l_21_1:id()
  print("[HostNetworkSession:chk_drop_in_peer]", dropin_peer_id)
  for peer_id,peer in pairs(l_21_0._peers) do
    if dropin_peer_id ~= peer_id and peer:synched() then
      local is_expecting = peer:is_expecting_pause_confirmation(dropin_peer_id)
      if is_expecting ~= "paused" then
        print("peer", peer_id, "is expected to confirm", is_expecting)
        if not is_expecting then
          debug_pause("was not asked!")
        end
        return 
      end
    end
  end
  print("doing drop-in!")
  Application:stack_dump()
  l_21_1:set_expecting_dropin(nil)
  l_21_1:on_sync_start()
  l_21_1:chk_enable_queue()
  Network:drop_in(l_21_1:rpc())
  return true
end

l_0_0.chk_drop_in_peer = l_0_1
l_0_0 = HostNetworkSession
l_0_1 = function(l_22_0, l_22_1, l_22_2, l_22_3, l_22_4, l_22_5, l_22_6, l_22_7, l_22_8, l_22_9, l_22_10)
  if not l_22_6 then
    l_22_6 = l_22_0:_get_free_client_id()
  end
  if not l_22_6 then
    return 
  end
  if not l_22_1 then
    l_22_1 = "Player " .. tostring(l_22_6)
  end
  local peer = nil
  l_22_6, peer = HostNetworkSession.super.add_peer(l_22_0, l_22_1, l_22_2, l_22_3, l_22_4, l_22_5, l_22_6, l_22_7, l_22_8, l_22_9, l_22_10)
  l_22_0:chk_server_joinable_state()
  return l_22_6, peer
end

l_0_0.add_peer = l_0_1
l_0_0 = HostNetworkSession
l_0_1 = function(l_23_0)
  local i = 2
  repeat
    if not l_23_0._peers[i] then
      local is_dirty = false
      for peer_id,peer in pairs(l_23_0._peers) do
        if peer:handshakes()[i] then
          is_dirty = true
        end
      end
      if not is_dirty then
        return i
      end
    end
    i = i + 1
  until i == 5
end

l_0_0._get_free_client_id = l_0_1
l_0_0 = HostNetworkSession
l_0_1 = function(l_24_0, l_24_1, l_24_2, l_24_3)
  print("[HostNetworkSession:remove_peer]", inspect(l_24_1), l_24_2, l_24_3)
  HostNetworkSession.super.remove_peer(l_24_0, l_24_1, l_24_2, l_24_3)
  if l_24_0._dead_con_reports then
    local i = #l_24_0._dead_con_reports
    repeat
      if i > 0 then
        local dead_con_report = l_24_0._dead_con_reports[i]
        if dead_con_report.reporter == l_24_1 or dead_con_report.reported == l_24_1 then
          table.remove(l_24_0._dead_con_reports, i)
        end
        i = i - 1
      else
        if not next(l_24_0._dead_con_reports) then
          l_24_0._dead_con_reports = nil
        end
      end
      if NetworkManager.DROPIN_ENABLED then
        for other_peer_id,other_peer in pairs(l_24_0._peers) do
          if other_peer:is_expecting_pause_confirmation(l_24_2) then
            l_24_0:set_dropin_pause_request(other_peer, l_24_2, false)
          end
        end
        if l_24_0._local_peer:is_expecting_pause_confirmation(l_24_2) then
          l_24_0._local_peer:set_expecting_drop_in_pause_confirmation(l_24_2, nil)
          managers.network:game():on_drop_in_pause_request_received(l_24_2, "", false)
        end
        for other_peer_id,other_peer in pairs(l_24_0._peers) do
          l_24_0:chk_initiate_dropin_pause(other_peer)
          l_24_0:chk_drop_in_peer(other_peer)
          l_24_0:chk_spawn_member_unit(other_peer, other_peer_id)
        end
      end
      do
        local info_msg_type = nil
        if l_24_3 == "kicked" then
          info_msg_type = "kick_peer"
        else
          info_msg_type = "remove_dead_peer"
        end
        for other_peer_id,other_peer in pairs(l_24_0._peers) do
          if other_peer:handshakes()[l_24_2] == true or other_peer:handshakes()[l_24_2] == "asked" or other_peer:handshakes()[l_24_2] == "exchanging_info" then
            other_peer:send_after_load(info_msg_type, l_24_2)
            other_peer:set_handshake_status(l_24_2, "removing")
          end
        end
        if l_24_3 ~= "left" and l_24_3 ~= "kicked" then
          l_24_1:send(info_msg_type, l_24_2)
        end
        l_24_0:chk_server_joinable_state()
      end
       -- Warning: missing end command somewhere! Added here
    end
     -- Warning: missing end command somewhere! Added here
  end
end

l_0_0.remove_peer = l_0_1
l_0_0 = HostNetworkSession
l_0_1 = function(l_25_0, l_25_1, l_25_2)
  print("[HostNetworkSession:on_remove_peer_confirmation]", l_25_1:id(), l_25_2)
  if l_25_1:handshakes()[l_25_2] ~= "removing" then
    print("peer should not remove. ignoring.")
    return 
  end
  l_25_1:set_handshake_status(l_25_2, nil)
  l_25_0:chk_server_joinable_state()
  managers.network:game():_check_start_game_intro()
end

l_0_0.on_remove_peer_confirmation = l_0_1
l_0_0 = HostNetworkSession
l_0_1 = function(l_26_0, l_26_1, l_26_2)
  print("[HostNetworkSession:on_dead_connection_reported]", l_26_1, l_26_2)
  if not l_26_0._peers[l_26_1] or not l_26_0._peers[l_26_2] then
    return 
  end
  if not l_26_0._dead_con_reports then
    l_26_0._dead_con_reports = {}
  end
  local entry = {process_t = TimerManager:wall():time() + l_26_0._DEAD_CONNECTION_REPORT_PROCESS_DELAY, reporter = l_26_0._peers[l_26_1], reported = l_26_0._peers[l_26_2]}
  table.insert(l_26_0._dead_con_reports, entry)
end

l_0_0.on_dead_connection_reported = l_0_1
l_0_0 = HostNetworkSession
l_0_1 = function(l_27_0)
  if l_27_0._dead_con_reports then
    local t = TimerManager:wall():time()
    local first_dead_con_report = l_27_0._dead_con_reports[1]
    if first_dead_con_report.process_t < t then
      if #l_27_0._dead_con_reports == 1 then
        l_27_0._dead_con_reports = nil
      else
        table.remove(l_27_0._dead_con_reports, 1)
      end
      local kick_peer = nil
      local reporter_peer = first_dead_con_report.reporter
      local reported_peer = first_dead_con_report.reported
      if reported_peer:creation_t() < reporter_peer:creation_t() then
        print("[HostNetworkSession:process_dead_con_reports] kicking reporter ", reporter_peer:id(), reported_peer:id(), reporter_peer:creation_t(), reported_peer:creation_t())
        kick_peer = reporter_peer
      else
        print("[HostNetworkSession:process_dead_con_reports] kicking reported ", reporter_peer:id(), reported_peer:id(), reporter_peer:creation_t(), reported_peer:creation_t())
        kick_peer = reported_peer
      end
      l_27_0:on_remove_dead_peer(kick_peer, kick_peer:id())
    end
  end
end

l_0_0.process_dead_con_reports = l_0_1
l_0_0 = HostNetworkSession
l_0_1 = function(l_28_0, l_28_1, l_28_2)
  print("[HostNetworkSession:chk_spawn_member_unit]", l_28_1:name(), l_28_2)
  local member = managers.network:game():member(l_28_2)
  if not l_28_0._game_started then
    print("Game not started yet")
    return 
  end
  if not member or member:spawn_unit_called() or not l_28_1:waiting_for_player_ready() then
    print("not ready to spawn unit: member", member, "member:spawn_unit_called()", member:spawn_unit_called(), "peer:waiting_for_player_ready()", l_28_1:waiting_for_player_ready())
    return 
  end
  for other_peer_id,other_peer in pairs(l_28_0._peers) do
    if not other_peer:synched() then
      print("peer", other_peer_id, "is not synched")
      return 
    end
  end
  if not l_28_0:chk_all_handshakes_complete() then
    return 
  end
  managers.network:game():spawn_dropin_player(l_28_2)
end

l_0_0.chk_spawn_member_unit = l_0_1
l_0_0 = HostNetworkSession
l_0_1 = function(l_29_0)
  for peer_id,peer in pairs(l_29_0._peers) do
    if peer:force_open_lobby_state() then
      print("force-opening lobby for peer", peer_id)
      managers.network.matchmake:set_server_joinable(true)
      return 
    end
  end
  if table.size(l_29_0._peers) >= 3 then
    managers.network.matchmake:set_server_joinable(false)
    return 
  end
  do
    local game_state_name = game_state_machine:last_queued_state_name()
    if BaseNetworkHandler._gamestate_filter.any_end_game[game_state_name] then
      managers.network.matchmake:set_server_joinable(false)
      return 
    end
    if not l_29_0:_get_free_client_id() then
      managers.network.matchmake:set_server_joinable(false)
      return 
    end
    if not l_29_0._state:is_joinable(l_29_0._state_data) then
      managers.network.matchmake:set_server_joinable(false)
      return 
    end
    if NetworkManager.DROPIN_ENABLED then
      if BaseNetworkHandler._gamestate_filter.lobby[game_state_name] then
        managers.network.matchmake:set_server_joinable(true)
        return 
      else
        if (managers.groupai and not managers.groupai:state():chk_allow_drop_in()) or not Global.game_settings.drop_in_allowed then
          managers.network.matchmake:set_server_joinable(false)
          return 
        else
          if not BaseNetworkHandler._gamestate_filter.lobby[game_state_name] then
            managers.network.matchmake:set_server_joinable(false)
            return 
          end
        end
      end
      managers.network.matchmake:set_server_joinable(true)
    end
     -- Warning: missing end command somewhere! Added here
  end
end

l_0_0.chk_server_joinable_state = l_0_1
l_0_0 = HostNetworkSession
l_0_1 = function(l_30_0)
  HostNetworkSession.super.on_load_complete(l_30_0)
  if Global.load_start_menu_lobby then
    managers.network.matchmake:set_server_state("in_lobby")
    return 
  else
    managers.network.matchmake:set_server_state("in_game")
  end
  l_30_0:chk_server_joinable_state()
  if NetworkManager.DROPIN_ENABLED then
    for peer_id,peer in pairs(l_30_0._peers) do
      if peer:loaded() then
        if not managers.network:game():_has_client(peer) then
          Network:add_client(peer:rpc())
        end
        if not peer:synched() then
          peer:set_expecting_pause_sequence(true)
          local dropin_pause_ok = l_30_0:chk_initiate_dropin_pause(peer)
          if dropin_pause_ok then
            l_30_0:chk_drop_in_peer(peer)
          end
        end
      end
    end
  end
end

l_0_0.on_load_complete = l_0_1
l_0_0 = HostNetworkSession
l_0_1 = function(l_31_0, ...)
  HostNetworkSession.super.prepare_to_close(l_31_0, ...)
  l_31_0:set_state("closing")
   -- DECOMPILER ERROR: Confused about usage of registers for local variables.

end

l_0_0.prepare_to_close = l_0_1
l_0_0 = HostNetworkSession
l_0_1 = function(l_32_0, l_32_1)
  local peer_id = l_32_1:id()
  local peer_handshakes = l_32_1:handshakes()
  for other_peer_id,other_peer in pairs(l_32_0._peers) do
    if other_peer_id ~= peer_id and other_peer:loaded() then
      if peer_handshakes[other_peer_id] ~= true then
        print("[HostNetworkSession:chk_peer_handshakes_complete]", peer_id, "is missing handshake for", other_peer_id)
        return false
      end
      if other_peer:handshakes()[peer_id] ~= true then
        print("[HostNetworkSession:chk_peer_handshakes_complete]", peer_id, "is not known by", other_peer_id)
        return false
      end
    end
  end
  return true
end

l_0_0.chk_peer_handshakes_complete = l_0_1
l_0_0 = HostNetworkSession
l_0_1 = function(l_33_0)
  for peer_id,peer in pairs(l_33_0._peers) do
    local peer_handshakes = peer:handshakes()
    for other_peer_id,other_peer in pairs(l_33_0._peers) do
      if other_peer_id ~= peer_id and peer_handshakes[other_peer_id] ~= true then
        print("[HostNetworkSession:chk_all_handshakes_complete]", peer_id, "is missing handshake for", other_peer_id)
        return false
      end
    end
  end
  return true
end

l_0_0.chk_all_handshakes_complete = l_0_1
l_0_0 = HostNetworkSession
l_0_1 = function(l_34_0, l_34_1, l_34_2, l_34_3)
  if l_34_3 == "asked" then
    local dropin_peer = l_34_0._peers[l_34_2]
    l_34_1:set_expecting_drop_in_pause_confirmation(l_34_2, l_34_3)
    l_34_1:send_after_load("request_drop_in_pause", l_34_2, dropin_peer:name() or "unknown_peer", true)
  elseif l_34_3 == "paused" then
    l_34_1:set_expecting_drop_in_pause_confirmation(l_34_2, l_34_3)
  elseif not l_34_3 then
    l_34_1:set_expecting_drop_in_pause_confirmation(l_34_2, nil)
    l_34_1:send_after_load("request_drop_in_pause", l_34_2, "", false)
  else
    debug_pause("[HostNetworkSession:set_dropin_pause_request] unknown state", l_34_3)
  end
end

l_0_0.set_dropin_pause_request = l_0_1
l_0_0 = HostNetworkSession
l_0_1 = function(l_35_0)
  for peer_id,peer in pairs(l_35_0._peers) do
    if peer:loaded() and not peer:synched() then
      return 
    end
  end
  for peer_id,peer in pairs(l_35_0._peers) do
    l_35_0:set_dropin_pause_request(peer, peer_id, false)
  end
  if l_35_0._local_peer:is_expecting_pause_confirmation(l_35_0._local_peer:id()) then
    l_35_0._local_peer:set_expecting_drop_in_pause_confirmation((l_35_0._local_peer:id()), nil)
    managers.network:game():on_drop_in_pause_request_received(l_35_0._local_peer:id(), "", false)
  end
  return true
end

l_0_0.chk_send_ready_to_unpause = l_0_1
l_0_0 = HostNetworkSession
l_0_1 = function(l_36_0, l_36_1, l_36_2)
  local state = l_36_0._STATES[l_36_1]
  local state_data = l_36_0._state_data
  if l_36_0._state then
    l_36_0._state:exit(state_data, l_36_1, l_36_2)
  end
  state_data.name = l_36_1
  state_data.state = state
  l_36_0._state = state
  l_36_0._state_name = l_36_1
  state:enter(state_data, l_36_2)
end

l_0_0.set_state = l_0_1
l_0_0 = HostNetworkSession
l_0_1 = function(l_37_0, l_37_1, l_37_2)
  if l_37_2 then
    l_37_1:send_after_load("re_open_lobby_reply", true)
  end
  l_37_1:set_force_open_lobby_state(l_37_2)
  l_37_0:chk_server_joinable_state()
end

l_0_0.on_re_open_lobby_request = l_0_1

