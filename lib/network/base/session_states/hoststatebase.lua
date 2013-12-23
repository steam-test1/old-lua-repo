-- Decompiled using luadec 2.0.1 by sztupy (http://winmo.sztupy.hu)
-- Command line was: F:\SteamLibrary\SteamApps\common\PAYDAY 2\lua\lib\network\base\session_states\hoststatebase.luac 

if not HostStateBase then
  HostStateBase = class()
end
HostStateBase.enter = function(l_1_0, l_1_1, l_1_2)
end

HostStateBase.exit = function(l_2_0, l_2_1, l_2_2, l_2_3)
end

HostStateBase.on_join_request_received = function(l_3_0, l_3_1, l_3_2, l_3_3, l_3_4, l_3_5, l_3_6, l_3_7, l_3_8, l_3_9)
  print("[HostStateBase:on_join_request_received]", l_3_1, l_3_2, l_3_3, l_3_4, l_3_5, l_3_6, l_3_7, l_3_8, l_3_9:ip_at_index(0))
  local my_user_id = l_3_1.local_peer:user_id() or ""
  if not managers.network.matchmake:is_server_joinable() then
    l_3_0:_send_request_denied(l_3_9, 3, my_user_id)
    return 
  end
  l_3_0:_send_request_denied(l_3_9, 0, my_user_id)
end

HostStateBase._send_request_denied = function(l_4_0, l_4_1, l_4_2, l_4_3)
  local xuid = SystemInfo:platform() == Idstring("X360") and managers.network.account:player_id() or ""
  l_4_1:join_request_reply(l_4_2, 0, "", 1, 1, 0, "", l_4_3, "", 0, 0, 0, 0, xuid)
end

HostStateBase._has_peer_left_PSN = function(l_5_0, l_5_1)
  if SystemInfo:platform() == Idstring("PS3") and managers.network.matchmake:check_peer_join_request_remove(l_5_1) then
    print("this CLIENT has left us from PSN, ignore his request", l_5_1)
    return 
  end
end

HostStateBase._is_in_server_state = function(l_6_0)
  if managers.network:game() then
    return Network:is_server()
  end
end

HostStateBase._introduce_new_peer_to_old_peers = function(l_7_0, l_7_1, l_7_2, l_7_3, l_7_4, l_7_5, l_7_6, l_7_7, l_7_8)
  local new_peer_user_id = SystemInfo:platform() == Idstring("WIN32") and l_7_2:user_id() or ""
  do
    local new_peer_id = l_7_2:id()
    for old_pid,old_peer in pairs(l_7_1.peers) do
      if old_pid ~= new_peer_id then
        if old_peer:handshakes()[new_peer_id] == nil then
          print("[HostStateBase:_introduce_new_peer_to_old_peers] introducing", new_peer_id, "to", old_pid)
          old_peer:send_after_load("peer_handshake", l_7_4, new_peer_id, new_peer_user_id, l_7_2:in_lobby(), l_7_3, false, l_7_5, l_7_6, l_7_7, l_7_8)
          old_peer:set_handshake_status(new_peer_id, "asked")
          for (for control),old_pid in (for generator) do
          end
          print("[HostStateBase:_introduce_new_peer_to_old_peers] peer already had handshake", new_peer_id, "to", old_pid)
        end
      end
    end
     -- Warning: missing end command somewhere! Added here
  end
end

HostStateBase._introduce_old_peers_to_new_peer = function(l_8_0, l_8_1, l_8_2)
  do
    local new_peer_id = l_8_2:id()
    for old_pid,old_peer in pairs(l_8_1.peers) do
      if old_pid ~= new_peer_id then
        if l_8_2:handshakes()[old_pid] == nil then
          print("[HostStateBase:_introduce_old_peers_to_new_peer] introducing", old_pid, "to", new_peer_id)
          l_8_2:send_after_load("peer_handshake", old_peer:connection_info())
          l_8_2:set_handshake_status(old_pid, "asked")
          for (for control),old_pid in (for generator) do
          end
          print("[HostStateBase:_introduce_new_peer_to_old_peers] peer already had handshake", old_pid, "to", new_peer_id)
        end
      end
    end
     -- Warning: missing end command somewhere! Added here
  end
end

HostStateBase._chk_mutual_connection_established = function(l_9_0, l_9_1, l_9_2, l_9_3)
  local introduced_peer = l_9_1.peers[l_9_3]
  if introduced_peer:handshakes()[l_9_2:id()] == true then
    cat_print("multiplayer_base", "[HostStateBase:_chk_mutual_connection_established] mutual connection", l_9_2:id(), l_9_3)
    introduced_peer:send_after_load("mutual_connection", l_9_2:id())
    l_9_2:send_after_load("mutual_connection", l_9_3)
    return true
  end
  return false
end

HostStateBase.on_handshake_confirmation = function(l_10_0, l_10_1, l_10_2, l_10_3)
  cat_print("multiplayer_base", "[HostStateBase:on_handshake_confirmation]", inspect(l_10_2), l_10_2:id(), l_10_3)
  local has_mutual_connection = nil
  if l_10_3 ~= 1 then
    has_mutual_connection = l_10_0:_chk_mutual_connection_established(l_10_1, l_10_2, l_10_3)
  end
  if has_mutual_connection then
    l_10_1.session:chk_initiate_dropin_pause(l_10_2)
    l_10_1.session:chk_initiate_dropin_pause(l_10_1.peers[l_10_3])
    if l_10_1.game_started then
      for other_peer_id,other_peer in pairs(l_10_1.peers) do
        l_10_1.session:chk_spawn_member_unit(other_peer, other_peer_id)
      end
    end
  end
  managers.network:game():_check_start_game_intro()
end

HostStateBase._is_kicked = function(l_11_0, l_11_1, l_11_2, l_11_3)
  local ident = SystemInfo:platform() == Idstring("WIN32") and l_11_3:ip_at_index(0) or l_11_2
  if l_11_1.kicked_list[ident] then
    return true
  end
end

HostStateBase._chk_peer_owns_current_dlc = function(l_12_0, l_12_1, l_12_2)
  local requires_dlc = tweak_data.levels[Global.game_settings.level_id].dlc
  if requires_dlc then
    local i_dlcs = string.split(l_12_2, " ")
    for _,dlc in ipairs(i_dlcs) do
      if requires_dlc == dlc then
        return true
      end
    end
  end
  return false
end

HostStateBase.on_peer_finished_loading = function(l_13_0, l_13_1, l_13_2)
  print("[HostStateBase:on_peer_finished_loading]", inspect(l_13_2))
  if not next(l_13_2:handshakes()) then
    l_13_0:_introduce_new_peer_to_old_peers(l_13_1, l_13_2, false, l_13_2:name(), l_13_2:character(), "remove", l_13_2:xuid(), l_13_2:xnaddr())
    l_13_0:_introduce_old_peers_to_new_peer(l_13_1, l_13_2)
  end
end

HostStateBase.on_load_level = function(l_14_0, l_14_1)
  l_14_1.wants_to_load_level = true
end

HostStateBase.is_joinable = function(l_15_0, l_15_1)
  return false
end


