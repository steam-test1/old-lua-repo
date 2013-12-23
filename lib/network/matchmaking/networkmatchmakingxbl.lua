-- Decompiled using luadec 2.0.1 by sztupy (http://winmo.sztupy.hu)
-- Command line was: F:\SteamLibrary\SteamApps\common\PAYDAY 2\lua\lib\network\matchmaking\networkmatchmakingxbl.luac 

if not NetworkMatchMakingXBL then
  NetworkMatchMakingXBL = class()
end
NetworkMatchMakingXBL.OPEN_SLOTS = 4
NetworkMatchMakingXBL.GAMEVERSION = 1
NetworkMatchMakingXBL.init = function(l_1_0)
  cat_print("lobby", "matchmake = NetworkMatchMakingXBL")
  l_1_0._callback_map = {}
  l_1_0._distance_filter = -1
  l_1_0._difficulty_filter = 0
  l_1_0._try_re_enter_lobby = nil
  l_1_0._players = {}
  l_1_0:set_server_joinable(true)
  managers.platform:add_event_callback("invite_accepted", callback(l_1_0, l_1_0, "invite_accepted_callback"))
end

NetworkMatchMakingXBL.invite_accepted_callback = function(l_2_0, l_2_1)
  print("NetworkMatchMakingXBL:invite_accepted_callback", l_2_1)
  local invitation = XboxLive:accepted_invite(l_2_1)
  if not invitation then
    Application:error("NetworkMatchMakingXBL:invite_accepted_callback Invitation didn't contain anything")
    return 
  end
  if not Global.boot_invite then
    Global.boot_invite = {}
  end
  if not Global.user_manager.user_index or not Global.user_manager.active_user_state_change_quit then
    print("BOOT UP INVITE")
    Global.boot_invite[l_2_1] = invitation
    return 
  end
  if managers.user:get_platform_id() ~= l_2_1 then
    print("INACTIVE USER RECIEVED INVITE")
    Global.boot_invite[l_2_1] = invitation
    managers.menu:show_inactive_user_accepted_invite({ok_func = nil})
    managers.user:invite_accepted_by_inactive_user()
    return 
  end
  if game_state_machine:current_state_name() ~= "menu_main" then
    print("INGAME INVITE")
    Global.boot_invite[l_2_1] = invitation
    MenuCallbackHandler:_dialog_end_game_yes()
    return 
  end
  l_2_0:_check_invite_requirements(invitation)
end

NetworkMatchMakingXBL.join_boot_invite = function(l_3_0)
  local invitation = Global.boot_invite[managers.user:get_platform_id()]
  print("NetworkMatchMakingXBL:join_boot_invite()", invitation)
  if not invitation then
    return 
  end
  l_3_0:_check_invite_requirements(invitation)
  Global.boot_invite[managers.user:get_platform_id()] = nil
end

NetworkMatchMakingXBL._check_invite_requirements = function(l_4_0, l_4_1)
  Global.game_settings.single_player = false
  l_4_0._test_invitation = l_4_1
  print("invitation\n", inspect(l_4_1))
  if not managers.menu:_enter_online_menus_x360(managers.menu) then
    return 
  end
  if l_4_0._session and l_4_0._session:id() == l_4_1.host_info:id() then
    print("Allready in that session")
    return 
  end
  l_4_0._has_pending_invite = true
  l_4_0:_join_invite_accepted(l_4_1.host_info)
end

NetworkMatchMakingXBL._join_invite_accepted = function(l_5_0, l_5_1)
  managers.system_menu:close("server_left_dialog")
  print("_join_invite_accepted", l_5_1)
  l_5_0._has_pending_invite = nil
  l_5_0._invite_host_info = l_5_1
  if l_5_0._session then
    print("MUST LEAVE session")
    MenuCallbackHandler:_dialog_leave_lobby_yes()
  end
  l_5_0:join_server_with_check(l_5_1:id(), true, {})
end

NetworkMatchMakingXBL.register_callback = function(l_6_0, l_6_1, l_6_2)
  l_6_0._callback_map[l_6_1] = l_6_2
end

NetworkMatchMakingXBL._call_callback = function(l_7_0, l_7_1, ...)
  if l_7_0._callback_map[l_7_1] then
    return l_7_0._callback_map[l_7_1](...)
  else
    Application:error("Callback " .. l_7_1 .. " not found.")
     -- DECOMPILER ERROR: Confused about usage of registers for local variables.

  end
end

NetworkMatchMakingXBL._has_callback = function(l_8_0, l_8_1)
  if l_8_0._callback_map[l_8_1] then
    return true
  end
  return false
end

NetworkMatchMakingXBL._split_attribute_number = function(l_9_0, l_9_1, l_9_2)
  if not l_9_2 or l_9_2 == 0 or type(l_9_2) ~= "number" then
    Application:error("NetworkMatchMakingXBL:_split_attribute_number. splitter needs to be a non 0 number!", "attribute_number", l_9_1, "splitter", l_9_2)
    Application:stack_dump()
    return 1, 1
  end
  return l_9_1 % l_9_2, math.floor(l_9_1 / l_9_2)
end

NetworkMatchMakingXBL.destroy_game = function(l_10_0)
  l_10_0:leave_game()
end

NetworkMatchMakingXBL.leave_game = function(l_11_0)
  if l_11_0._session then
    print("NetworkMatchMakingXBL:leave_game()", l_11_0._session:state())
  end
  Application:stack_dump()
  if l_11_0._session then
    local player_index = managers.user:get_platform_id()
    print("managers.user:get_platform_id()", managers.user:get_platform_id())
    print("  _leave and destroy", l_11_0._session)
    XboxLive:leave_local(l_11_0._session, player_index)
    print(" has left")
    XboxLive:delete_session(l_11_0._session)
    print(" has deleted")
    if l_11_0:_is_server() then
      l_11_0._server_last_alive_t = nil
      l_11_0._next_time_out_check_t = nil
    end
    l_11_0._session = nil
    l_11_0:set_server_joinable(true)
    print("NetworkMatchMakingXBL:leave_game() done")
    Application:stack_dump()
  else
    cat_print("multiplayer", "Dont have a session!?")
  end
  l_11_0:_is_server(false)
  l_11_0:_is_client(false)
  l_11_0._game_owner_name = nil
end

NetworkMatchMakingXBL._load_globals = function(l_12_0)
  if Global.xbl and Global.xbl.match then
    l_12_0._session = Global.xbl.match.session
    l_12_0._server_rpc = Global.xbl.match.server_rpc
    l_12_0._game_owner_name = Global.xbl.match.game_owner_name
    l_12_0._num_players = Global.xbl.match.num_players
    l_12_0._is_server_var = Global.xbl.match.is_server
    l_12_0._is_client_var = Global.xbl.match.is_client
    l_12_0._players = Global.xbl.match.players
    Global.xbl.match = nil
  end
end

NetworkMatchMakingXBL._save_globals = function(l_13_0)
  if not Global.xbl then
    Global.xbl = {}
  end
  Global.xbl.match = {}
  Global.xbl.match.session = l_13_0._session
  Global.xbl.match.server_rpc = l_13_0._server_rpc
  Global.xbl.match.game_owner_name = l_13_0._game_owner_name
  Global.xbl.match.num_players = l_13_0._num_players
  Global.xbl.match.is_server = l_13_0._is_server_var
  Global.xbl.match.is_client = l_13_0._is_client_var
  Global.xbl.match.players = l_13_0._players
end

NetworkMatchMakingXBL.update = function(l_14_0)
end

NetworkMatchMakingXBL.get_friends_lobbies = function(l_15_0)
end

NetworkMatchMakingXBL.search_friends_only = function(l_16_0)
  return l_16_0._search_friends_only
end

NetworkMatchMakingXBL.distance_filter = function(l_17_0)
  return l_17_0._distance_filter
end

NetworkMatchMakingXBL.set_distance_filter = function(l_18_0, l_18_1)
  l_18_0._distance_filter = l_18_1
end

NetworkMatchMakingXBL.difficulty_filter = function(l_19_0)
  return l_19_0._difficulty_filter
end

NetworkMatchMakingXBL.set_difficulty_filter = function(l_20_0, l_20_1)
  l_20_0._difficulty_filter = l_20_1
end

NetworkMatchMakingXBL.search_lobby = function(l_21_0, l_21_1)
  if l_21_0._searching_lobbys then
    print("Allready searching lobbys, waiting result")
    return 
  end
  l_21_0._search_friends_only = l_21_1
  if not l_21_0:_has_callback("search_lobby") then
    return 
  end
  local player_index = managers.user:get_platform_id()
  local prop = {}
  prop.MINLEVEL = managers.experience:current_level()
  prop.GAMEVERSION = l_21_0.GAMEVERSION
  local con = {}
  con.GAME_TYPE = "STANDARD"
  con.game_mode = "ONLINE"
  l_21_0._searching_lobbys = true
  XboxLive:search_session("Find Matches", player_index, 50, prop, con, callback(l_21_0, l_21_0, "_find_server_callback"))
end

NetworkMatchMakingXBL._find_server_callback = function(l_22_0, l_22_1, l_22_2)
  l_22_0._searching_lobbys = nil
  if l_22_0._cancel_find then
    return 
  end
  l_22_0._last_mode = l_22_2
  print("find_server_callback", l_22_2, inspect(l_22_1))
  if not l_22_1 then
    print("SEaRCH FAILED")
    return 
  end
  local info = {room_list = {}, attribute_list = {}}
  for _,server in ipairs(l_22_1) do
    l_22_0._test_server = server
    print(inspect(server))
    table.insert(info.room_list, {owner_id = nil, owner_name = server.properties.GAMERHOSTNAME, room_id = server.info:id(), info = server.info})
    table.insert(info.attribute_list, {numbers = l_22_0:_server_to_numbers(server)})
  end
  l_22_0:_call_callback("search_lobby", info)
  local player_index = managers.user:get_platform_id()
end

NetworkMatchMakingXBL.search_lobby_done = function(l_23_0)
  managers.system_menu:close("find_server")
  l_23_0.browser = nil
end

NetworkMatchMakingXBL.game_owner_name = function(l_24_0)
  return l_24_0._game_owner_name
end

NetworkMatchMakingXBL.is_server_ok = function(l_25_0, l_25_1, l_25_2, l_25_3)
  local permission = tweak_data:index_to_permission(l_25_3[3])
  local level_index, job_index = l_25_0:_split_attribute_number(l_25_3[1], 1000)
  if not tweak_data.levels:get_level_name_from_index(level_index) then
    Application:error("No level data for index " .. level_index .. ". Payday1 data not compatible with Payday2.")
    return false
  end
  if (not NetworkManager.DROPIN_ENABLED or l_25_3[6] == 0) and l_25_3[4] ~= 1 then
    return false, 1
  end
  if managers.experience:current_level() < l_25_3[7] then
    return false, 3
  end
  if permission == "private" then
    return false, 2
  end
  if permission == "public" then
    return true
  end
  return true
end

NetworkMatchMakingXBL.join_server_with_check = function(l_26_0, l_26_1, l_26_2, l_26_3)
  print("NetworkMatchMakingXBL:join_server_with_check", l_26_1)
  local player_index = managers.user:get_platform_id()
  managers.menu:show_joining_lobby_dialog()
  local empty = function()
   end
  local f = function(l_2_0)
    print("servers", l_2_0)
    if not l_2_0 or not l_2_0[1] then
      managers.system_menu:close("join_server")
      if managers.user:signed_in_state() ~= "signed_in_to_live" then
        managers.menu:xbox_disconnected()
      else
        managers.menu:show_game_no_longer_exists()
        return 
      end
      print("NetworkMatchMakingXBL:join_server_with_check f", inspect(l_2_0[1]))
      print("SELF", self, player_index)
      local server_ok, ok_error = true, nil
      if server_ok then
        print("CALL JOIN SERVER", l_2_0[1].info)
        self._game_owner_name = data.host_name
        self:join_server(session_id, l_2_0[1], true)
      else
        managers.system_menu:close("join_server")
        if ok_error == 1 then
          managers.menu:show_game_started_dialog()
        elseif ok_error == 2 then
          managers.menu:show_game_permission_changed_dialog()
        elseif ok_error == 3 then
          managers.menu:show_too_low_level()
        elseif ok_error == 4 then
          managers.menu:show_does_not_own_heist()
        end
        self:search_lobby(self:search_friends_only())
      end
       -- Warning: missing end command somewhere! Added here
    end
   end
  XboxLive:search_session_by_id(l_26_1, player_index, f)
end

NetworkMatchMakingXBL._on_data_update = function(...)
   -- DECOMPILER ERROR: Confused about usage of registers for local variables.

end

NetworkMatchMakingXBL._on_chat_message = function(l_28_0, l_28_1)
  print("[NetworkMatchMakingXBL._on_chat_message]", l_28_0, l_28_1)
end

NetworkMatchMakingXBL._handle_chat_message = function(l_29_0, l_29_1)
  local s = "" .. l_29_1
  managers.chat:receive_message_by_name(ChatManager.GLOBAL, l_29_0:name(), s)
end

NetworkMatchMakingXBL.join_server = function(l_30_0, l_30_1, l_30_2, l_30_3)
  local xs_info = l_30_2.info
  if not l_30_3 then
    managers.menu:show_joining_lobby_dialog()
  end
  local player_index = managers.user:get_platform_id()
  print("join_server", xs_info, xs_info:id())
  if l_30_0._session then
    XboxLive:leave_local(l_30_0._session, player_index)
    XboxLive:delete_session(l_30_0._session)
  end
  XboxLive:set_context(player_index, "GAME_TYPE", "STANDARD")
  XboxLive:set_context(player_index, "game_mode", "ONLINE")
  local permission = l_30_2.open_private_slots > 0 and "private" or "public"
  local pub_slots = l_30_0.OPEN_SLOTS
  local priv_slots = 0
  l_30_0._private = false
  if permission == "private" then
    pub_slots = 0
    priv_slots = l_30_0.OPEN_SLOTS
    l_30_0._private = true
  end
  l_30_0._session = XboxLive:create_client_session("live_multiplayer_standard", player_index, pub_slots, priv_slots, xs_info)
  local result = "success"
  if not l_30_0._session then
    print("FAILED CREATE CLIENT SESSION")
    result = "failed"
  end
  XboxLive:join_local(l_30_0._session, player_index, l_30_0._private)
  print("self._session", l_30_0._session)
  print("[NetworkMatchMakingXBL:join_server:f]")
  managers.system_menu:close("join_server")
  if result == "success" then
    print("Success!")
    print("[NetworkMatchMakingXBL:join_server] server details", l_30_0._session:ip(), l_30_0._session:id())
    print("Gonna handshake now!")
    l_30_0._server_rpc = Network:handshake(l_30_0._session:ip(), managers.network.DEFAULT_PORT, "TCP_IP")
    print("Handshook!")
    if l_30_0._server_rpc then
      print("Server RPC:", l_30_0._server_rpc:ip_at_index(0))
    end
    if not l_30_0._server_rpc then
      return 
    end
    l_30_0._players = {}
    l_30_0:_is_server(false)
    l_30_0:_is_client(true)
    managers.network.voice_chat:open_session()
    managers.network:start_client()
    managers.menu:show_waiting_for_server_response({cancel_func = function()
      managers.network:session():on_join_request_cancelled()
      end})
    local joined_game = function(l_2_0, l_2_1, l_2_2, l_2_3)
      managers.system_menu:close("waiting_for_server_response")
      print("[NetworkMatchMakingXBL:join_server:joined_game]", l_2_0, l_2_1, l_2_2, l_2_3)
      if l_2_0 == "JOINED_LOBBY" then
        MenuCallbackHandler:crimenet_focus_changed(nil, false)
        managers.menu:on_enter_lobby()
      elseif l_2_0 == "JOINED_GAME" then
        local level_id = tweak_data.levels:get_level_name_from_index(l_2_1)
        Global.game_settings.level_id = level_id
        managers.network:session():ok_to_load_level()
      elseif l_2_0 == "KICKED" then
        managers.network.matchmake:leave_game()
        managers.network.voice_chat:destroy_voice()
        managers.network:queue_stop_network()
        managers.menu:show_peer_kicked_dialog()
      elseif l_2_0 == "TIMED_OUT" then
        managers.network.matchmake:leave_game()
        managers.network.voice_chat:destroy_voice()
        managers.network:queue_stop_network()
        managers.menu:show_request_timed_out_dialog()
      elseif l_2_0 == "GAME_STARTED" then
        managers.network.matchmake:leave_game()
        managers.network.voice_chat:destroy_voice()
        managers.network:queue_stop_network()
        managers.menu:show_game_started_dialog()
      elseif l_2_0 == "DO_NOT_OWN_HEIST" then
        managers.network.matchmake:leave_game()
        managers.network.voice_chat:destroy_voice()
        managers.network:queue_stop_network()
        managers.menu:show_does_not_own_heist()
      elseif l_2_0 == "CANCELLED" then
        managers.network.matchmake:leave_game()
        managers.network.voice_chat:destroy_voice()
        managers.network:queue_stop_network()
      elseif l_2_0 == "FAILED_CONNECT" then
        managers.network.matchmake:leave_game()
        managers.network.voice_chat:destroy_voice()
        managers.network:queue_stop_network()
        managers.menu:show_failed_joining_dialog()
      elseif l_2_0 == "GAME_FULL" then
        managers.network.matchmake:leave_game()
        managers.network.voice_chat:destroy_voice()
        managers.network:queue_stop_network()
        managers.menu:show_game_is_full()
      elseif l_2_0 == "LOW_LEVEL" then
        managers.network.matchmake:leave_game()
        managers.network.voice_chat:destroy_voice()
        managers.network:queue_stop_network()
        managers.menu:show_too_low_level()
      elseif l_2_0 == "WRONG_VERSION" then
        managers.network.matchmake:leave_game()
        managers.network.voice_chat:destroy_voice()
        managers.network:queue_stop_network()
        managers.menu:show_wrong_version_message()
      else
        Application:error("[NetworkMatchMakingXBL:join_server] FAILED TO START MULTIPLAYER!", l_2_0)
      end
      end
    managers.network:join_game_at_host_rpc(l_30_0._server_rpc, joined_game)
  else
    l_30_0:leave_game()
    managers.menu:show_failed_joining_dialog()
    l_30_0:search_lobby(l_30_0:search_friends_only())
  end
end

NetworkMatchMakingXBL.send_join_invite = function(l_31_0, l_31_1)
end

NetworkMatchMakingXBL.set_server_attributes = function(l_32_0, l_32_1)
  l_32_0:set_attributes(l_32_1)
end

NetworkMatchMakingXBL.create_lobby = function(l_33_0, l_33_1)
  local attributes_numbers = l_33_1.numbers
  l_33_0._num_players = nil
  l_33_0:set_server_joinable(true)
  print("NetworkMatchMakingXBL:create_lobby", inspect(l_33_1))
  l_33_1.numbers[4] = 1
  l_33_0:set_attributes(l_33_1)
  local player_index = managers.user:get_platform_id()
  local gt = "STANDARD"
  local gm = "ONLINE"
  XboxLive:set_context(player_index, "GAME_TYPE", gt)
  XboxLive:set_context(player_index, "game_mode", gm)
  if l_33_0._session and l_33_0._session:state() == "started" then
    XboxLive:leave_local(l_33_0._session, player_index)
    XboxLive:delete_session(l_33_0._session, function()
      print("DELETED SESSION")
      end)
  end
  local permission = tweak_data:index_to_permission(attributes_numbers[3])
  local pub_slots = l_33_0.OPEN_SLOTS
  local priv_slots = 0
  l_33_0._private = false
  if permission == "private" then
    pub_slots = 0
    priv_slots = l_33_0.OPEN_SLOTS
    l_33_0._private = true
  end
  local dialog_data = {}
  dialog_data.title = managers.localization:text("dialog_creating_lobby_title")
  dialog_data.text = managers.localization:text("dialog_wait")
  dialog_data.id = "create_lobby"
  dialog_data.no_buttons = true
  managers.system_menu:show(dialog_data)
  local success = XboxLive:create_session("live_multiplayer_standard", player_index, pub_slots, priv_slots, callback(l_33_0, l_33_0, "_create_lobby_callback", l_33_1))
  print("create return value", success)
end

NetworkMatchMakingXBL._create_lobby_failed = function(l_34_0)
  l_34_0:_create_lobby_done()
  local title = managers.localization:text("dialog_error_title")
  local dialog_data = {title = title, text = managers.localization:text("dialog_err_failed_creating_lobby")}
  dialog_data.button_list = {{text = managers.localization:text("dialog_ok")}}
  managers.system_menu:show(dialog_data)
end

NetworkMatchMakingXBL._create_lobby_done = function(l_35_0)
  l_35_0._creating_lobby = nil
  managers.system_menu:close("create_lobby")
end

NetworkMatchMakingXBL._create_lobby_callback = function(l_36_0, l_36_1, l_36_2)
  if l_36_0._cancel_find then
    cat_print("lobby", "create_server canceled")
    return 
  end
  print("NetworkMatchMakingXBL:_create_server_callback", inspect(l_36_1))
  local player_index = managers.user:get_platform_id()
  if not l_36_2 then
    print("CREATE SESSION FAILED")
    l_36_0:_create_lobby_failed()
    return 
  end
  XboxLive:join_local(l_36_2, player_index, l_36_0._private)
  if alive(l_36_0._session) then
    cat_print("lobby", "Trying to remove self._session", l_36_0._session:id(), "in state", l_36_0._session:state())
    cat_stack_dump("lobby")
  end
  l_36_0._session = l_36_2
  print(" Created mm session ", l_36_0._session:id())
  l_36_0._trytime = nil
  l_36_0._players = {}
  l_36_0._server_rpc = nil
  l_36_0:_is_server(true)
  l_36_0:_is_client(false)
  managers.network.voice_chat:open_session()
  l_36_0:_create_lobby_done()
  managers.menu:created_lobby()
end

NetworkMatchMakingXBL.set_num_players = function(l_37_0, l_37_1)
  print("NetworkMatchMakingXBL:set_num_players", l_37_1)
  local player_index = managers.user:get_platform_id()
  l_37_0._num_players = l_37_1
  XboxLive:set_property(player_index, "NUMPLAYERS", l_37_0._num_players)
end

NetworkMatchMakingXBL.set_server_state = function(l_38_0, l_38_1)
  local player_index = managers.user:get_platform_id()
  local state_id = tweak_data:server_state_to_index(l_38_1)
  XboxLive:set_property(player_index, "SERVERSTATE", state_id)
end

NetworkMatchMakingXBL.set_server_joinable = function(l_39_0, l_39_1)
  print("[NetworkMatchMakingXBL:set_server_joinable]", l_39_1)
  local player_index = managers.user:get_platform_id()
  XboxLive:set_property(player_index, "SERVERJOINABLE", l_39_1 and 1 or 0)
end

NetworkMatchMakingXBL.is_server_joinable = function(l_40_0)
  local player_index = managers.user:get_platform_id()
  return XboxLive:get_property(player_index, "SERVERJOINABLE") == 1
end

NetworkMatchMakingXBL.server_state_name = function(l_41_0)
end

NetworkMatchMakingXBL.on_peer_added = function(l_42_0, l_42_1)
  print("NetworkMatchMakingXBL:on_peer_added", l_42_1:id(), l_42_1:xuid(), l_42_0._session, l_42_0._private)
  if (managers.network:session() and managers.network:session():local_peer() == l_42_1) or type(l_42_1:xuid()) == "string" then
    print("  Dont add local peer or empty string")
    return 
  end
  if not l_42_0._session then
    Application:error("NetworkMatchMakingXBL:on_peer_added, had no session!")
    return 
  end
  l_42_0._players[l_42_1:id()] = l_42_1:xuid()
  XboxLive:join_remote(l_42_0._session, l_42_1:xuid(), l_42_0._private or false)
  local player_info = {}
  player_info.name = l_42_1:name()
  player_info.player_id = l_42_1:xuid()
  player_info.external_address = l_42_1:xnaddr()
  managers.network.voice_chat:open_channel_to(player_info, "game")
end

NetworkMatchMakingXBL.on_peer_removed = function(l_43_0, l_43_1)
  print("NetworkMatchMakingXBL:on_peer_removed", l_43_1:id(), l_43_1:xuid(), l_43_0._session)
  if type(l_43_1:xuid()) == "string" then
    print("  Dont remove peer with empty string")
    return 
  end
  if not l_43_0._session then
    Application:error("NetworkMatchMakingXBL:on_peer_removed, had no session!")
    return 
  end
  l_43_0._players[l_43_1:id()] = nil
  XboxLive:leave_remote(l_43_0._session, l_43_1:xuid())
  local player_info = {}
  player_info.name = l_43_1:name()
  player_info.player_id = l_43_1:xuid()
  managers.network.voice_chat:close_channel_to(player_info)
end

NetworkMatchMakingXBL.set_attributes = function(l_44_0, l_44_1)
  local player_index = managers.user:get_platform_id()
  XboxLive:set_property(player_index, "LEVELINDEX", l_44_1.numbers[1])
  XboxLive:set_property(player_index, "DIFFICULTY", l_44_1.numbers[2])
  XboxLive:set_property(player_index, "PERMISSION", l_44_1.numbers[3])
  if not l_44_1.numbers[4] then
    XboxLive:set_property(player_index, "SERVERSTATE", XboxLive:get_property(player_index, "SERVERSTATE"))
  end
  XboxLive:set_property(player_index, "NUMPLAYERS", l_44_0._num_players or 1)
  XboxLive:set_property(player_index, "ALLOWDROPIN", l_44_1.numbers[6])
  XboxLive:set_property(player_index, "MINLEVEL", l_44_1.numbers[7])
  XboxLive:set_property(player_index, "GAMEVERSION", l_44_0.GAMEVERSION)
end

NetworkMatchMakingXBL._server_to_numbers = function(l_45_0, l_45_1)
  do
    local properties = l_45_1.properties
    return {}
  end
   -- Warning: undefined locals caused missing assignments!
end

NetworkMatchMakingXBL.external_address = function(l_46_0, l_46_1)
  if not l_46_0._session then
    Application:error("NetworkMatchMakingXBL:translate_to_xnaddr, had no session!")
    return ""
  end
  return XboxLive:external_address(l_46_1)
end

NetworkMatchMakingXBL.internal_address = function(l_47_0, l_47_1)
  if not l_47_0._session then
    Application:error("NetworkMatchMakingXBL:internal_address, had no session!")
    return ""
  end
  return XboxLive:internal_address(l_47_0._session, l_47_1)
end

NetworkMatchMakingXBL.from_host_lobby_re_opened = function(l_48_0, l_48_1)
  print("[NetworkMatchMakingXBL::from_host_lobby_re_opened]", l_48_0._try_re_enter_lobby, l_48_1)
  if l_48_0._try_re_enter_lobby == "asked" then
    if l_48_1 then
      l_48_0._try_re_enter_lobby = "open"
    else
      l_48_0._try_re_enter_lobby = nil
      managers.network.matchmake:leave_game()
    end
  end
end

NetworkMatchMakingXBL._test_search = function(l_49_0, l_49_1)
  local player_index = managers.user:get_platform_id()
  local prop = {}
  prop.MINLEVEL = managers.experience:current_level()
  local con = {}
  con.GAME_TYPE = l_49_1.game_type
  con.game_mode = l_49_1.game_mode
  XboxLive:search_session("Find Matches", player_index, 25, prop, con, callback(l_49_0, l_49_0, "_find_test_server_callback"))
end

NetworkMatchMakingXBL._find_test_server_callback = function(l_50_0, l_50_1, l_50_2)
  if l_50_0._cancel_find then
    return 
  end
  l_50_0._last_mode = l_50_2
  print("_find_test_server_callback", l_50_2, inspect(l_50_1))
  if not l_50_1 then
    print("SEaRCH FAILED")
    return 
  end
  l_50_0._test_servers = {}
  for _,server in ipairs(l_50_1) do
    l_50_0._test_server = server
    table.insert(l_50_0._test_servers, server)
    print(inspect(server))
  end
  local player_index = managers.user:get_platform_id()
end

NetworkMatchMakingXBL._test_join = function(l_51_0, l_51_1, l_51_2)
  if not l_51_1 then
    l_51_1 = l_51_0._test_server.info
  end
  local player_index = managers.user:get_platform_id()
  print("_test_join", l_51_1)
  if l_51_0._session then
    XboxLive:leave_local(l_51_0._session, player_index)
    XboxLive:delete_session(l_51_0._session)
  end
  l_51_0._session = XboxLive:create_client_session("live_multiplayer_standard", player_index, 4, 0, l_51_1)
  if not l_51_0._session then
    print("FAILED CREATE CLIENT SESSION")
    return 
  end
  XboxLive:join_local(l_51_0._session, player_index, true)
  print("self._session", l_51_0._session)
  local result = "failed"
  print("[NetworkMatchMakingXBL:join_server:f]")
  managers.system_menu:close("join_server")
  if result == "success" then
    print("Success!")
    print("[NetworkMatchMakingXBL:join_server] server details", l_51_0._session:ip(), l_51_0._session:id())
    print("Gonna handshake now!")
    l_51_0._server_rpc = Network:handshake((l_51_0._session:ip()), nil, "TCP_IP")
    print("Handshook!")
    if l_51_0._server_rpc then
      print("Server RPC:", l_51_0._server_rpc:ip_at_index(0))
    end
    if not l_51_0._server_rpc then
      return 
    end
    managers.network:start_client()
    managers.menu:show_waiting_for_server_response({cancel_func = function()
      managers.network:session():on_join_request_cancelled()
      end})
    local joined_game = function(l_2_0, l_2_1, l_2_2, l_2_3)
      managers.system_menu:close("waiting_for_server_response")
      print("[NetworkMatchMakingXBL:join_server:joined_game]", l_2_0, l_2_1, l_2_2, l_2_3)
      if l_2_0 == "JOINED_LOBBY" then
        managers.network.voice_chat:open_session()
        MenuCallbackHandler:crimenet_focus_changed(nil, false)
        managers.menu:on_enter_lobby()
      elseif l_2_0 == "JOINED_GAME" then
        local level_id = tweak_data.levels:get_level_name_from_index(l_2_1)
        Global.game_settings.level_id = level_id
        managers.network:session():ok_to_load_level()
      elseif l_2_0 == "KICKED" then
        managers.network.matchmake:leave_game()
        managers.network.voice_chat:destroy_voice()
        managers.network:queue_stop_network()
        managers.menu:show_peer_kicked_dialog()
      elseif l_2_0 == "TIMED_OUT" then
        managers.network.matchmake:leave_game()
        managers.network.voice_chat:destroy_voice()
        managers.network:queue_stop_network()
        managers.menu:show_request_timed_out_dialog()
      elseif l_2_0 == "GAME_STARTED" then
        managers.network.matchmake:leave_game()
        managers.network.voice_chat:destroy_voice()
        managers.network:queue_stop_network()
        managers.menu:show_game_started_dialog()
      elseif l_2_0 == "DO_NOT_OWN_HEIST" then
        managers.network.matchmake:leave_game()
        managers.network.voice_chat:destroy_voice()
        managers.network:queue_stop_network()
        managers.menu:show_does_not_own_heist()
      elseif l_2_0 == "CANCELLED" then
        managers.network.matchmake:leave_game()
        managers.network.voice_chat:destroy_voice()
        managers.network:queue_stop_network()
      elseif l_2_0 == "FAILED_CONNECT" then
        managers.network.matchmake:leave_game()
        managers.network.voice_chat:destroy_voice()
        managers.network:queue_stop_network()
        managers.menu:show_failed_joining_dialog()
      else
        Application:error("[NetworkMatchMakingXBL:join_server] FAILED TO START MULTIPLAYER!", l_2_0)
      end
      end
    managers.network:join_game_at_host_rpc(l_51_0._server_rpc, joined_game)
  else
    managers.menu:show_failed_joining_dialog()
    l_51_0:search_lobby(l_51_0:search_friends_only())
  end
end

NetworkMatchMakingXBL._join_server_callback = function(l_52_0)
end

NetworkMatchMakingXBL._test_create = function(l_53_0, l_53_1)
  print("settings\n", inspect(l_53_1))
  if l_53_1 == nil then
    local gt = l_53_1.game_type
  end
  local gm = l_53_1.game_mode
  local skl = l_53_1.skill
  local player_index = managers.user:get_platform_id()
  XboxLive:set_context(player_index, "GAME_TYPE", gt)
  XboxLive:set_context(player_index, "game_mode", gm)
  if l_53_0._session and l_53_0._session:state() == "started" then
    XboxLive:leave_local(l_53_0._session, player_index)
    XboxLive:delete_session(l_53_0._session, function()
      print("DELETED SESSION")
      end)
  end
  local create_prop = {"group_lobby"}
  if l_53_0._uses_arbitration == true then
    table.insert(create_prop, "uses_arbitration")
  end
  local pub_slots = l_53_0.OPEN_SLOTS
  local priv_slots = 0
  print("creating session\n", inspect(create_prop))
  local session = XboxLive:create_session("live_multiplayer_standard", player_index, pub_slots, priv_slots, callback(l_53_0, l_53_0, "_create_server_callback"))
  print("create return value", session)
end

NetworkMatchMakingXBL._create_server_callback = function(l_54_0, l_54_1)
  if l_54_0._cancel_find then
    cat_print("lobby", "create_server canceled")
    return 
  end
  print("NetworkMatchMakingXBL:_create_server_callback")
  local player_index = managers.user:get_platform_id()
  if not l_54_1 then
    print("CREATE SESSION FAILED")
    return 
  end
  XboxLive:join_local(l_54_1, player_index, l_54_0._private)
  if alive(l_54_0._session) then
    cat_print("lobby", "Trying to remove self._session", l_54_0._session:id(), "in state", l_54_0._session:state())
    cat_stack_dump("lobby")
  end
  l_54_0._session = l_54_1
  print(" Created mm session ", l_54_0._session:id())
  l_54_0._players = {}
  l_54_0._server_rpc = nil
end

NetworkMatchMakingXBL._is_server = function(l_55_0, l_55_1)
  if l_55_1 == true or l_55_1 == false then
    l_55_0._is_server_var = l_55_1
  else
    return l_55_0._is_server_var
  end
end

NetworkMatchMakingXBL._is_client = function(l_56_0, l_56_1)
  if l_56_1 == true or l_56_1 == false then
    l_56_0._is_client_var = l_56_1
  else
    return l_56_0._is_client_var
  end
end


