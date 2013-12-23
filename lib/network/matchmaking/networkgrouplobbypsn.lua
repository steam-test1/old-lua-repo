-- Decompiled using luadec 2.0.1 by sztupy (http://winmo.sztupy.hu)
-- Command line was: F:\SteamLibrary\SteamApps\common\PAYDAY 2\lua\lib\network\matchmaking\networkgrouplobbypsn.luac 

require("lib/network/matchmaking/NetworkGroupLobby")
if not NetworkGroupLobbyPSN then
  NetworkGroupLobbyPSN = class(NetworkGroupLobby)
end
NetworkGroupLobbyPSN.init = function(l_1_0)
  NetworkGroupLobby.init(l_1_0)
  cat_print("lobby", "group = NetworkGroupLobbyPSN")
  l_1_0.OPEN_SLOTS = 4
  l_1_0._players = {}
  l_1_0._returned_players = {}
  l_1_0._room_id = nil
  l_1_0._inlobby = false
  l_1_0._join_enable = true
  l_1_0._is_server_var = false
  l_1_0._is_client_var = false
  l_1_0._callback_map = {}
  local f = function(...)
    self:_custom_message_cb(...)
     -- DECOMPILER ERROR: Confused about usage of registers for local variables.

   end
  PSN:set_matchmaking_callback("custom_message", f)
  l_1_0._time_to_leave = nil
  l_1_0:_load_globals()
end

NetworkGroupLobbyPSN._session_destroyed_cb = function(l_2_0, l_2_1)
  cat_print("lobby", "NetworkGroupLobbyPSN:_session_destroyed_cb")
  if l_2_1 == l_2_0._room_id then
    l_2_0:leave_group_lobby_cb()
  end
end

NetworkGroupLobbyPSN.destroy = function(l_3_0)
end

NetworkGroupLobbyPSN.update = function(l_4_0, l_4_1)
  if l_4_0._time_to_leave and l_4_0._time_to_leave < TimerManager:wall():time() then
    l_4_0._time_to_leave = nil
    l_4_0:leave_group_lobby_cb()
  end
  if l_4_0._try_time and l_4_0._try_time < TimerManager:wall():time() then
    l_4_0._try_time = nil
    l_4_0:leave_group_lobby_cb("join_failed")
  end
end

NetworkGroupLobbyPSN.create_group_lobby = function(l_5_0)
  cat_print("lobby", "NetworkGroupLobbyPSN:create_group_lobby()")
  l_5_0._players = {}
  local world_list = PSN:get_world_list()
  local session_created = function(l_1_0)
    managers.network.group:_created_group_lobby(l_1_0)
   end
  PSN:set_matchmaking_callback("session_created", session_created)
  PSN:create_session(0, world_list[1].world_id, 0, l_5_0.OPEN_SLOTS, 0)
end

NetworkGroupLobbyPSN.join_group_lobby = function(l_6_0, l_6_1)
  l_6_0:_is_server(false)
  l_6_0:_is_client(true)
  if Global.psn_invite_id then
    Global.psn_invite_id = Global.psn_invite_id + 1
    if Global.psn_invite_id > 990 then
      Global.psn_invite_id = 1
    end
  end
  l_6_0._room_id = l_6_1.room_id
  local f = function(...)
    self:_join_invite(...)
     -- DECOMPILER ERROR: Confused about usage of registers for local variables.

   end
  PSN:set_matchmaking_callback("connection_etablished", f)
  l_6_0._try_time = TimerManager:wall():time() + 30
  PSN:join_session(l_6_0._room_id)
end

NetworkGroupLobbyPSN.send_go_to_lobby = function(l_7_0)
  if l_7_0:_is_server() then
    for k,v in pairs(l_7_0._players) do
      if v.rpc then
        v.rpc:grp_go_to_lobby()
      end
    end
  end
end

NetworkGroupLobbyPSN.go_to_lobby = function(l_8_0)
  if l_8_0._callback_map.go_to_lobby then
    l_8_0:_call_callback("go_to_lobby")
  else
    l_8_0:leave_group_lobby()
  end
end

NetworkGroupLobbyPSN.send_return_group_lobby = function(l_9_0)
  local playerid = managers.network.account:player_id()
  cat_print("lobby", "Now telling server that im back and ready. My playerid is: ", tostring(playerid))
  local timeout = 40
  if Application:bundled() then
    timeout = 15
  end
  l_9_0._server_rpc:lobby_return(managers.network.account:player_id())
  for k,v in pairs(l_9_0._players) do
    if v.is_server then
      managers.network.generic:ping_watch(l_9_0._server_rpc, false, callback(l_9_0, l_9_0, "_server_timed_out"), v.pnid, timeout)
      return 
    end
  end
end

NetworkGroupLobbyPSN._handle_returned_players = function(l_10_0)
  if #l_10_0._returned_players ~= 0 and l_10_0._callback_map.player_returned then
    cat_print("lobby", "We now have a return callback so now handling players")
    for index,playerid in pairs(l_10_0._returned_players) do
      local v, k = nil, nil
      k, v = l_10_0:find(playerid)
      if k then
        local res = l_10_0:_call_callback("player_returned", v)
        if res == true then
          v.rpc:lobby_return_answer("yes")
          managers.network.generic:ping_watch(v.rpc, false, callback(l_10_0, l_10_0, "_client_timed_out"), v.pnid)
          for (for control),index in (for generator) do
          end
          v.rpc:lobby_return_answer("no")
        end
      end
      l_10_0._returned_players = {}
    end
     -- Warning: missing end command somewhere! Added here
  end
end

NetworkGroupLobbyPSN.return_group_lobby = function(l_11_0, l_11_1, l_11_2)
  cat_print("lobby", "Client reports that it has returned to group lobby. ", tostring(l_11_1))
  table.insert(l_11_0._returned_players, l_11_1)
  if l_11_0._callback_map.player_returned then
    l_11_0:_handle_returned_players()
  else
    cat_print("lobby", "No player_returned callback so save these returns for later")
  end
end

NetworkGroupLobbyPSN.lobby_return_answer = function(l_12_0, l_12_1, l_12_2)
  cat_print("lobby", "Group leader tell us lobby_return_answer. ", tostring(l_12_1), tostring(l_12_0._server_rpc))
  if l_12_1 == "yes" then
    for k,v in pairs(l_12_0._players) do
      if v.is_server then
        managers.network.generic:ping_watch(l_12_2, false, callback(l_12_0, l_12_0, "_server_timed_out"), v.pnid)
        return 
      end
    end
  else
    l_12_0:leave_group_lobby()
  end
end

NetworkGroupLobbyPSN.find = function(l_13_0, l_13_1)
  for k,v in pairs(l_13_0._players) do
    if tostring(v.playerid) == tostring(l_13_1) then
      return k, v
    end
  end
  return nil, nil
end

NetworkGroupLobbyPSN.leave_group_lobby = function(l_14_0, l_14_1)
  if l_14_0:_is_server() and #l_14_0._players == 0 then
    l_14_0:leave_group_lobby_cb()
    return nil
  end
  l_14_0._try_time = nil
  if not l_14_1 then
    if l_14_0:_is_server() then
      for k,v in pairs(l_14_0._players) do
        managers.network.generic:ping_remove(v.rpc, false)
        v.rpc:psn_grp_unregister_player(managers.network.account:player_id(), true)
      end
    elseif l_14_0._server_rpc then
      l_14_0._server_rpc:psn_grp_unregister_player(managers.network.account:player_id(), false)
      managers.network.generic:ping_remove(l_14_0._server_rpc)
    end
    l_14_0._time_to_leave = TimerManager:wall():time() + 2
  else
    l_14_0:leave_group_lobby_cb()
  end
end

NetworkGroupLobbyPSN.leave_group_lobby_cb = function(l_15_0, l_15_1)
  if l_15_0._room_id then
    managers.network.voice_chat:close_session()
    if l_15_0:_is_server() then
      PSN:destroy_session(l_15_0._room_id)
    else
      PSN:leave_session(l_15_0._room_id)
    end
  end
  l_15_0._room_id = nil
  l_15_0._inlobby = false
  l_15_0._is_server_var = false
  l_15_0._is_client_var = false
  l_15_0._players = {}
  if l_15_0._server_rpc then
    managers.network.generic:ping_remove(l_15_0._server_rpc, false)
    l_15_0._server_rpc = nil
  end
  l_15_0:_call_callback(l_15_1 or "left_group")
end

NetworkGroupLobbyPSN.set_join_enabled = function(l_16_0, l_16_1)
  l_16_0._join_enable = l_16_1
  if l_16_1 and not managers.network.systemlink:is_lan() then
    managers.platform:set_presence("MPLobby")
  else
    managers.platform:set_presence("MPLobby_no_invite")
  end
end

NetworkGroupLobbyPSN.send_group_lobby_invite = function(l_17_0, l_17_1)
  if l_17_0._room_id == nil then
    return false
  end
  for k,v in pairs(l_17_0._players) do
    if tostring(v.pnid) == tostring(l_17_1) then
      return false
    end
  end
  local friends = PSN:get_list_friends()
  if friends then
    for k,v in pairs(friends) do
      if tostring(v.friend) == tostring(l_17_1) and v.status == 2 and v.info and v.info == managers.platform:presence() then
        local msg = {}
        msg.join_invite = true
        if not Global.psn_invite_id then
          Global.psn_invite_id = 1
        end
        msg.invite_id = Global.psn_invite_id
        PSN:send_message_custom(l_17_1, l_17_0._room_id, msg)
        return true
      end
    end
  end
  return false
end

NetworkGroupLobbyPSN.kick_player = function(l_18_0, l_18_1, l_18_2)
  local v, k, rpc = nil, nil, nil
  k, v = l_18_0:find(l_18_1)
  if k and v.rpc then
    rpc = v.rpc
    rpc:lobby_return_answer("no")
  end
  l_18_0:_unregister_player(l_18_1, false, rpc)
end

NetworkGroupLobbyPSN.accept_group_lobby_invite = function(l_19_0, l_19_1, l_19_2)
  if l_19_2 == true then
    l_19_0:_call_callback("accepted_group_lobby_invite", l_19_1)
  end
end

NetworkGroupLobbyPSN.send_game_id = function(l_20_0, l_20_1, l_20_2, l_20_3)
  if l_20_3 and l_20_3 == true then
    for k,v in pairs(l_20_0._players) do
      l_20_0:_call_callback("reserv_slot", v.pnid)
    end
  end
  for k,v in pairs(l_20_0._players) do
    v.rpc:psn_send_mm_id(PSN:convert_sessionid_to_string(l_20_1), l_20_2)
  end
end

NetworkGroupLobbyPSN.register_callback = function(l_21_0, l_21_1, l_21_2)
  l_21_0._callback_map[l_21_1] = l_21_2
end

NetworkGroupLobbyPSN.start_game = function(l_22_0)
  l_22_0:_call_callback("game_started")
end

NetworkGroupLobbyPSN.end_game = function(l_23_0)
end

NetworkGroupLobbyPSN.ingame_start_game = function(l_24_0)
  if l_24_0._server_rpc then
    for k,v in pairs(l_24_0._players) do
      if v.is_server then
        managers.network.generic:ping_watch(l_24_0._server_rpc, false, callback(l_24_0, l_24_0, "_server_timed_out"), v.pnid)
        return 
      end
    end
  end
end

NetworkGroupLobbyPSN.say = function(l_25_0, l_25_1)
  if l_25_0:_is_server() then
    for k,v in pairs(l_25_0._players) do
      v.rpc:say_toclient(l_25_1)
    end
  end
end

NetworkGroupLobbyPSN.membervoted = function(l_26_0, l_26_1, l_26_2)
  if l_26_0:_is_server() then
    for k,v in pairs(l_26_0._players) do
      v.rpc:membervoted_toclient(l_26_1, l_26_2)
    end
  end
end

NetworkGroupLobbyPSN.is_group_leader = function(l_27_0)
  return l_27_0:_is_server() == true
end

NetworkGroupLobbyPSN.has_pending_invite = function(l_28_0)
  return false
end

NetworkGroupLobbyPSN.is_in_group = function(l_29_0)
  if l_29_0._inlobby then
    return true
  end
  return false
end

NetworkGroupLobbyPSN.num_group_players = function(l_30_0)
  local x = 0
  for k,v in pairs(l_30_0._players) do
    x = x + 1
  end
  return x
end

NetworkGroupLobbyPSN.get_group_players = function(l_31_0)
  return l_31_0._players
end

NetworkGroupLobbyPSN.is_full = function(l_32_0)
  if #l_32_0._players == l_32_0.OPEN_SLOTS - 1 then
    return true
  end
  return false
end

NetworkGroupLobbyPSN.get_leader_rpc = function(l_33_0)
  return l_33_0._server_rpc
end

NetworkGroupLobbyPSN.get_members_rpcs = function(l_34_0)
  do
    local rpcs = {}
    for _,v in pairs(l_34_0._players) do
      if v.rpc then
        table.insert(rpcs, v.rpc)
        for (for control),_ in (for generator) do
        end
        Application:throw_exception("A player without an RPC. This is not good!")
      end
      return rpcs
    end
     -- Warning: missing end command somewhere! Added here
  end
end

NetworkGroupLobbyPSN.resync_screen = function(l_35_0)
  managers.network:bind_port()
  if l_35_0:is_group_leader() then
    local playerinfo = {}
    playerinfo.name = managers.network.account:username()
    playerinfo.player_id = managers.network.account:player_id()
    playerinfo.group_id = tostring(l_35_0._room_id)
    playerinfo.rpc = Network:self("TCP_IP")
    l_35_0:_call_callback("player_joined", playerinfo)
  else
    local playerinfo = {}
    playerinfo.name = managers.network.account:username()
    playerinfo.player_id = managers.network.account:player_id()
    playerinfo.group_id = tostring(l_35_0._room_id)
    playerinfo.rpc = Network:self("TCP_IP")
    l_35_0:_call_callback("player_joined", playerinfo)
  end
  for k,v in pairs(l_35_0._players) do
    local playerinfo = {}
    playerinfo.name = v.name
    playerinfo.player_id = v.pnid
    playerinfo.group_id = v.group
    playerinfo.rpc = v.rpc
    l_35_0:_call_callback("player_joined", playerinfo)
  end
end

NetworkGroupLobbyPSN.room_id = function(l_36_0)
  return l_36_0._room_id
end

NetworkGroupLobbyPSN._load_globals = function(l_37_0)
  if Global.psn and Global.psn.group then
    l_37_0._room_id = Global.psn.group.room_id
    l_37_0._inlobby = Global.psn.group.inlobby
    l_37_0._is_server_var = Global.psn.group.is_server
    l_37_0._is_client_var = Global.psn.group.is_client
    l_37_0._players = Global.psn.group.players
    l_37_0._server_rpc = Global.psn.group.server_rpc
    l_37_0._returned_players = Global.psn.group._returned_players
    Global.psn.group = nil
  end
end

NetworkGroupLobbyPSN._save_global = function(l_38_0)
  if not Global.psn then
    Global.psn = {}
  end
  Global.psn.group = {}
  Global.psn.group.room_id = l_38_0._room_id
  Global.psn.group.inlobby = l_38_0._inlobby
  Global.psn.group.is_server = l_38_0._is_server_var
  Global.psn.group.is_client = l_38_0._is_client_var
  Global.psn.group.players = l_38_0._players
  Global.psn.group.server_rpc = l_38_0._server_rpc
  Global.psn.group._returned_players = l_38_0._returned_players
end

NetworkGroupLobbyPSN._call_callback = function(l_39_0, l_39_1, ...)
  if l_39_0._callback_map[l_39_1] then
    return l_39_0._callback_map[l_39_1](...)
  else
    Application:error("Callback " .. l_39_1 .. " not found.")
     -- DECOMPILER ERROR: Confused about usage of registers for local variables.

  end
end

NetworkGroupLobbyPSN._is_server = function(l_40_0, l_40_1)
  if l_40_1 == true or l_40_1 == false then
    l_40_0._is_server_var = l_40_1
  else
    return l_40_0._is_server_var
  end
end

NetworkGroupLobbyPSN._is_client = function(l_41_0, l_41_1)
  if l_41_1 == true or l_41_1 == false then
    l_41_0._is_client_var = l_41_1
  else
    return l_41_0._is_client_var
  end
end

NetworkGroupLobbyPSN._custom_message_cb = function(l_42_0, l_42_1)
  if l_42_1.custom_table and l_42_1.custom_table.join_invite and l_42_0._join_enable then
    l_42_0._invite_id = l_42_1.custom_table.invite_id
    l_42_0:_call_callback("receive_group_lobby_invite", l_42_1, l_42_1.sender)
  end
end

NetworkGroupLobbyPSN._recv_game_id = function(l_43_0, l_43_1, l_43_2)
  l_43_0:_call_callback("receive_game_id", l_43_1, l_43_2)
end

NetworkGroupLobbyPSN._created_group_lobby = function(l_44_0, l_44_1)
  if not l_44_1 then
    l_44_0:_call_callback("create_group_failed")
    return 
  end
  PSN:set_matchmaking_callback("session_created", function()
   end)
  l_44_0:_call_callback("created_group")
  cat_print("lobby", "NetworkGroupLobbyPSN:_created_group_lobby()")
  l_44_0._room_id = l_44_1
  PSN:hide_session(l_44_0._room_id)
  l_44_0._inlobby = true
  l_44_0._room_info = PSN:get_info_session(l_44_0._room_id)
  l_44_0:_is_server(true)
  l_44_0:_is_client(false)
  managers.network:bind_port()
  managers.network.voice_chat:open_session(l_44_0._room_id)
  local playerinfo = {}
  playerinfo.name = managers.network.account:username()
  playerinfo.player_id = managers.network.account:player_id()
  playerinfo.group_id = tostring(l_44_1)
  playerinfo.rpc = Network:self("TCP_IP")
  l_44_0:_call_callback("player_joined", playerinfo)
end

NetworkGroupLobbyPSN._clear_psn_callback = function(l_45_0, l_45_1)
  local f = function()
   end
  PSN:set_matchmaking_callback(l_45_1, f)
end

NetworkGroupLobbyPSN._join_invite = function(l_46_0, l_46_1)
  if l_46_1.room_id == l_46_0._room_id and l_46_1.user_id == l_46_1.owner_id then
    l_46_0:_clear_psn_callback("connection_etablished")
    l_46_0._try_time = nil
    l_46_0._room_info = PSN:get_info_session(l_46_0._room_id)
    l_46_0._server_rpc = Network:handshake(l_46_1.external_ip, l_46_1.port)
    if not l_46_0._server_rpc then
      Application:error("Could not connect with rpc")
      return 
    end
    Network:set_timeout(l_46_0._server_rpc, 10)
    l_46_0._try_time = TimerManager:wall():time() + 10
    l_46_0._server_rpc:psn_grp_hello(l_46_0._invite_id)
  end
end

NetworkGroupLobbyPSN._server_alive = function(l_47_0, l_47_1)
  if l_47_0._server_rpc and l_47_0._server_rpc:ip_at_index(0) == l_47_1:ip_at_index(0) then
    l_47_0._try_time = nil
    Network:set_timeout(l_47_0._server_rpc, 3000)
    l_47_0._server_rpc:psn_grp_register_player(managers.network.account:username(), managers.network.account:player_id(), tostring(managers.network.group:room_id()), false)
    l_47_0._inlobby = true
    l_47_0._try_time = TimerManager:wall():time() + 10
  end
end

NetworkGroupLobbyPSN._register_player = function(l_48_0, l_48_1, l_48_2, l_48_3, l_48_4, l_48_5)
  if l_48_0.OPEN_SLOTS <= #l_48_0._players + 1 then
    return 
  end
  l_48_0._try_time = nil
  local new_player = {}
  new_player.name = l_48_1
  new_player.pnid = l_48_2
  new_player.playerid = l_48_2
  new_player.group = l_48_3
  if l_48_0:_is_server() then
    new_player.rpc = l_48_4
    l_48_4:psn_grp_register_player(managers.network.account:username(), managers.network.account:player_id(), tostring(managers.network.group:room_id()), true)
    for k,v in pairs(l_48_0._players) do
      v.rpc:psn_grp_register_player(l_48_1, l_48_2, l_48_3, false)
      l_48_4:psn_grp_register_player(v.name, v.pnid, v.group, false)
    end
    managers.network.generic:ping_watch(l_48_4, false, callback(l_48_0, l_48_0, "_client_timed_out"), l_48_2)
  end
  if l_48_5 and l_48_5 == true then
    new_player.is_server = true
    managers.network.generic:ping_watch(l_48_0._server_rpc, false, callback(l_48_0, l_48_0, "_server_timed_out"), l_48_2)
    managers.network.voice_chat:open_session(l_48_0._room_id)
    l_48_0:_call_callback("player_joined", {player_id = managers.network.account:player_id(), group_id = tostring(l_48_0._room_id), name = managers.network.account:username(), rpc = Network:self("TCP_IP")})
  end
  table.insert(l_48_0._players, new_player)
  if MPFriendsScreen.instance then
    MPFriendsScreen.instance:reset_list()
  end
  local playerinfo = {}
  playerinfo.name = l_48_1
  playerinfo.player_id = l_48_2
  playerinfo.group_id = l_48_3
  playerinfo.rpc = l_48_4
  l_48_0:_call_callback("player_joined", playerinfo)
end

NetworkGroupLobbyPSN._unregister_player = function(l_49_0, l_49_1, l_49_2, l_49_3)
  if l_49_0:_is_client() and l_49_2 == true then
    l_49_0:leave_group_lobby_cb()
    return 
  end
  cat_print("lobby", "_unregister_player: didn't leave group")
  local new_list = {}
  for k,v in pairs(l_49_0._players) do
    if v.pnid ~= l_49_1 then
      table.insert(new_list, v)
    end
  end
  l_49_0._players = new_list
  if MPFriendsScreen.instance then
    MPFriendsScreen.instance:reset_list()
  end
  if l_49_0:_is_server() then
    managers.network.generic:ping_remove(l_49_3, false)
    for k,v in pairs(l_49_0._players) do
      v.rpc:psn_grp_unregister_player(l_49_1, false)
    end
  end
  l_49_0:_call_callback("player_left", {player_id = l_49_1, reason = "went home to mama"})
end

NetworkGroupLobbyPSN._in_list = function(l_50_0, l_50_1)
  for k,v in pairs(l_50_0._players) do
    if tostring(v.pnid) == tostring(l_50_1) then
      return true
    end
  end
  return false
end

NetworkGroupLobbyPSN._server_timed_out = function(l_51_0, l_51_1)
  NetworkGroupLobby._server_timed_out(l_51_0, l_51_1)
  l_51_0:_unregister_player(nil, true, l_51_1)
end

NetworkGroupLobbyPSN._client_timed_out = function(l_52_0, l_52_1)
  for k,v in pairs(l_52_0._players) do
    if v.rpc and v.rpc:ip_at_index(0) == l_52_1:ip_at_index(0) then
      l_52_0:_unregister_player(v.pnid, false, v.rpc)
      return 
    end
  end
end

NetworkGroupLobbyPSN.leaving_game = function(l_53_0)
  if l_53_0:_is_server() then
    l_53_0:leave_group_lobby(true)
  end
end


