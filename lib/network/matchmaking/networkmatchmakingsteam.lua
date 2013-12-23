-- Decompiled using luadec 2.0.1 by sztupy (http://winmo.sztupy.hu)
-- Command line was: F:\SteamLibrary\SteamApps\common\PAYDAY 2\lua\lib\network\matchmaking\networkmatchmakingsteam.luac 

if not NetworkMatchMakingSTEAM then
  NetworkMatchMakingSTEAM = class()
end
NetworkMatchMakingSTEAM.OPEN_SLOTS = 4
NetworkMatchMakingSTEAM._BUILD_SEARCH_INTEREST_KEY = "payday2_release_v0.0.24"
NetworkMatchMakingSTEAM.init = function(l_1_0)
  cat_print("lobby", "matchmake = NetworkMatchMakingSTEAM")
  l_1_0._callback_map = {}
  l_1_0._distance_filter = -1
  l_1_0._difficulty_filter = 0
  l_1_0._try_re_enter_lobby = nil
  l_1_0._server_joinable = true
end

NetworkMatchMakingSTEAM.register_callback = function(l_2_0, l_2_1, l_2_2)
  l_2_0._callback_map[l_2_1] = l_2_2
end

NetworkMatchMakingSTEAM._call_callback = function(l_3_0, l_3_1, ...)
  if l_3_0._callback_map[l_3_1] then
    return l_3_0._callback_map[l_3_1](...)
  else
    Application:error("Callback " .. l_3_1 .. " not found.")
     -- DECOMPILER ERROR: Confused about usage of registers for local variables.

  end
end

NetworkMatchMakingSTEAM._has_callback = function(l_4_0, l_4_1)
  if l_4_0._callback_map[l_4_1] then
    return true
  end
  return false
end

NetworkMatchMakingSTEAM._split_attribute_number = function(l_5_0, l_5_1, l_5_2)
  if not l_5_2 or l_5_2 == 0 or type(l_5_2) ~= "number" then
    Application:error("NetworkMatchMakingSTEAM:_split_attribute_number. splitter needs to be a non 0 number!", "attribute_number", l_5_1, "splitter", l_5_2)
    Application:stack_dump()
    return 1, 1
  end
  return l_5_1 % l_5_2, math.floor(l_5_1 / l_5_2)
end

NetworkMatchMakingSTEAM.destroy_game = function(l_6_0)
  l_6_0:leave_game()
end

NetworkMatchMakingSTEAM._load_globals = function(l_7_0)
  if Global.steam and Global.steam.match then
    l_7_0.lobby_handler = Global.steam.match.lobby_handler
    l_7_0._lobby_attributes = Global.steam.match.lobby_attributes
    if l_7_0.lobby_handler then
      l_7_0.lobby_handler:setup_callbacks(NetworkMatchMakingSTEAM._on_memberstatus_change, NetworkMatchMakingSTEAM._on_data_update, NetworkMatchMakingSTEAM._on_chat_message)
    end
    l_7_0._try_re_enter_lobby = Global.steam.match.try_re_enter_lobby
    l_7_0._server_rpc = Global.steam.match.server_rpc
    Global.steam.match = nil
  end
end

NetworkMatchMakingSTEAM._save_globals = function(l_8_0)
  if not Global.steam then
    Global.steam = {}
  end
  Global.steam.match = {}
  Global.steam.match.lobby_handler = l_8_0.lobby_handler
  Global.steam.match.lobby_attributes = l_8_0._lobby_attributes
  Global.steam.match.try_re_enter_lobby = l_8_0._try_re_enter_lobby
  Global.steam.match.server_rpc = l_8_0._server_rpc
end

NetworkMatchMakingSTEAM.update = function(l_9_0)
  Steam:update()
  if l_9_0._try_re_enter_lobby then
    if l_9_0._try_re_enter_lobby == "lost" then
      Application:error("REQUESTING RE-OPEN LOBBY")
      l_9_0._server_rpc:re_open_lobby_request(true)
      l_9_0._try_re_enter_lobby = "asked"
    elseif l_9_0._try_re_enter_lobby == "asked" then
      do return end
    end
    if l_9_0._try_re_enter_lobby == "open" then
      l_9_0._try_re_enter_lobby = "joining"
      Application:error("RE-ENTERING LOBBY", l_9_0.lobby_handler:id())
      local _join_lobby_result_f = function(l_1_0, l_1_1)
        if l_1_0 == "success" then
          Application:error("SUCCESS!")
          self.lobby_handler = l_1_1
          self._server_rpc:re_open_lobby_request(false)
          self._try_re_enter_lobby = nil
        else
          Application:error("FAIL!")
          self._try_re_enter_lobby = "open"
        end
         end
      Steam:join_lobby(l_9_0.lobby_handler:id(), _join_lobby_result_f)
  end
end

NetworkMatchMakingSTEAM.leave_game = function(l_10_0)
  l_10_0._server_rpc = nil
  if l_10_0.lobby_handler then
    l_10_0.lobby_handler:leave_lobby()
  end
  l_10_0.lobby_handler = nil
  l_10_0._server_joinable = true
  if l_10_0._try_re_enter_lobby then
    l_10_0._try_re_enter_lobby = nil
  end
  print("NetworkMatchMakingSTEAM:leave_game()")
end

NetworkMatchMakingSTEAM.get_friends_lobbies = function(l_11_0)
  local lobbies = {}
  local num_updated_lobbies = 0
  local empty = function()
   end
  local f = function(l_2_0)
    l_2_0:setup_callback(empty)
    print("NetworkMatchMakingSTEAM:get_friends_lobbies f")
    upvalue_512 = num_updated_lobbies + 1
    if #lobbies <= num_updated_lobbies then
      local info = {room_list = {}, attribute_list = {}}
      for _,lobby in ipairs(lobbies) do
        if NetworkMatchMakingSTEAM._BUILD_SEARCH_INTEREST_KEY then
          local ikey = lobby:key_value(NetworkMatchMakingSTEAM._BUILD_SEARCH_INTEREST_KEY)
          if ikey ~= "value_missing" and ikey ~= "value_pending" then
            table.insert(info.room_list, {owner_id = lobby:key_value("owner_id"), owner_name = lobby:key_value("owner_name"), room_id = lobby:id()})
            table.insert(info.attribute_list, {numbers = self:_lobby_to_numbers(lobby)})
          end
        end
      end
      self:_call_callback("search_lobby", info)
    end
   end
  if Steam:logged_on() and Steam:friends() then
    for _,friend in ipairs(Steam:friends()) do
      local lobby = friend:lobby()
      if lobby then
        table.insert(lobbies, lobby)
      end
    end
  end
  if #lobbies == 0 then
    local info = {room_list = {}, attribute_list = {}}
    l_11_0:_call_callback("search_lobby", info)
  else
    for _,lobby in ipairs(lobbies) do
      lobby:setup_callback(f)
      if lobby:key_value("state") == "value_pending" then
        print("NetworkMatchMakingSTEAM:get_friends_lobbies value_pending")
        lobby:request_data()
        for (for control),_ in (for generator) do
        end
        f(lobby)
      end
    end
     -- Warning: missing end command somewhere! Added here
  end
end

NetworkMatchMakingSTEAM.search_friends_only = function(l_12_0)
  return l_12_0._search_friends_only
end

NetworkMatchMakingSTEAM.distance_filter = function(l_13_0)
  return l_13_0._distance_filter
end

NetworkMatchMakingSTEAM.set_distance_filter = function(l_14_0, l_14_1)
  l_14_0._distance_filter = l_14_1
end

NetworkMatchMakingSTEAM.difficulty_filter = function(l_15_0)
  return l_15_0._difficulty_filter
end

NetworkMatchMakingSTEAM.set_difficulty_filter = function(l_16_0, l_16_1)
  l_16_0._difficulty_filter = l_16_1
end

NetworkMatchMakingSTEAM.search_lobby = function(l_17_0, l_17_1)
  l_17_0._search_friends_only = l_17_1
  if not l_17_0:_has_callback("search_lobby") then
    return 
  end
  if l_17_1 then
    l_17_0:get_friends_lobbies()
  else
    local refresh_lobby = function()
    if not self.browser then
      return 
    end
    local lobbies = self.browser:lobbies()
    local info = {room_list = {}, attribute_list = {}}
    if lobbies then
      for _,lobby in ipairs(lobbies) do
        if self._difficulty_filter == 0 or self._difficulty_filter == tonumber(lobby:key_value("difficulty")) then
          table.insert(info.room_list, {owner_id = lobby:key_value("owner_id"), owner_name = lobby:key_value("owner_name"), room_id = lobby:id()})
          table.insert(info.attribute_list, {numbers = self:_lobby_to_numbers(lobby)})
        end
      end
    end
    self:_call_callback("search_lobby", info)
   end
    l_17_0.browser = LobbyBrowser(refresh_lobby, function()
      end)
    local interest_keys = {"owner_id", "owner_name", "level", "difficulty", "permission", "state", "num_players", "drop_in", "min_level"}
    if l_17_0._BUILD_SEARCH_INTEREST_KEY then
      table.insert(interest_keys, l_17_0._BUILD_SEARCH_INTEREST_KEY)
    end
    l_17_0.browser:set_interest_keys(interest_keys)
    l_17_0.browser:set_distance_filter(l_17_0._distance_filter)
    if Global.game_settings.playing_lan then
      l_17_0.browser:refresh_lan()
    else
      l_17_0.browser:refresh()
    end
  end
end

NetworkMatchMakingSTEAM.search_lobby_done = function(l_18_0)
  managers.system_menu:close("find_server")
  l_18_0.browser = nil
end

NetworkMatchMakingSTEAM.game_owner_name = function(l_19_0)
  return managers.network.matchmake.lobby_handler:get_lobby_data("owner_name")
end

NetworkMatchMakingSTEAM.is_server_ok = function(l_20_0, l_20_1, l_20_2, l_20_3, l_20_4)
  local permission = tweak_data:index_to_permission(l_20_3[3])
  local level_index, job_index = l_20_0:_split_attribute_number(l_20_3[1], 1000)
  if not tweak_data.levels:get_level_name_from_index(level_index) then
    Application:error("No level data for index " .. level_index .. ". Payday1 data not compatible with Payday2.")
    return false
  end
  if (not NetworkManager.DROPIN_ENABLED or l_20_3[6] == 0) and l_20_3[4] ~= 1 then
    return false, 1
  end
  if managers.experience:current_level() < l_20_3[7] then
    return false, 3
  end
  if not l_20_4 and permission == "private" then
    return false, 2
  end
  if permission == "public" then
    return true
  end
  return true
end

NetworkMatchMakingSTEAM.join_server_with_check = function(l_21_0, l_21_1, l_21_2)
  managers.menu:show_joining_lobby_dialog()
  local lobby = Steam:lobby(l_21_1)
  local empty = function()
   end
  local f = function()
    print("NetworkMatchMakingSTEAM:join_server_with_check f")
    lobby:setup_callback(empty)
    local attributes = self:_lobby_to_numbers(lobby)
    if NetworkMatchMakingSTEAM._BUILD_SEARCH_INTEREST_KEY then
      local ikey = lobby:key_value(NetworkMatchMakingSTEAM._BUILD_SEARCH_INTEREST_KEY)
      if ikey == "value_missing" or ikey == "value_pending" then
        print("Wrong version!!")
        managers.system_menu:close("join_server")
        managers.menu:show_failed_joining_dialog()
        return 
      end
    end
    print(inspect(attributes))
    local server_ok, ok_error = self:is_server_ok(nil, room_id, attributes, is_invite)
    if server_ok then
      self:join_server(room_id, true)
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
   end
  lobby:setup_callback(f)
  if lobby:key_value("state") == "value_pending" then
    print("NetworkMatchMakingSTEAM:join_server_with_check value_pending")
    lobby:request_data()
  else
    f()
  end
end

NetworkMatchMakingSTEAM._on_member_left = function(l_22_0, l_22_1)
  if not managers.network:session() then
    return 
  end
  local peer = managers.network:session():peer_by_user_id(l_22_0)
  if not peer then
    return 
  end
  if peer == managers.network:session():local_peer() and managers.network:session():is_server() then
    managers.network:session():on_peer_left(peer, peer_id)
    return 
  else
    if peer == managers.network:session():local_peer() and not managers.network:session():closing() then
      Application:error("OMG I LEFT THE LOBBY")
      managers.network.matchmake._try_re_enter_lobby = "lost"
    end
  end
  managers.network:session():on_peer_left_lobby(peer)
end

NetworkMatchMakingSTEAM._on_memberstatus_change = function(l_23_0)
  print("[NetworkMatchMakingSTEAM._on_memberstatus_change]", l_23_0)
  local user, status = unpack(string.split(l_23_0, ":"))
  if status == "lost_steam_connection" or status == "left_become_owner" or status == "left" or status == "kicked" or status == "banned" or status == "invalid" then
    NetworkMatchMakingSTEAM._on_member_left(user, status)
  end
end

NetworkMatchMakingSTEAM._on_data_update = function(...)
   -- DECOMPILER ERROR: Confused about usage of registers for local variables.

end

NetworkMatchMakingSTEAM._on_chat_message = function(l_25_0, l_25_1)
  print("[NetworkMatchMakingSTEAM._on_chat_message]", l_25_0, l_25_1)
  NetworkMatchMakingSTEAM._handle_chat_message(l_25_0, l_25_1)
end

NetworkMatchMakingSTEAM._handle_chat_message = function(l_26_0, l_26_1)
  local s = "" .. l_26_1
  managers.chat:receive_message_by_name(ChatManager.GLOBAL, l_26_0:name(), s)
end

NetworkMatchMakingSTEAM.join_server = function(l_27_0, l_27_1, l_27_2)
  if not l_27_2 then
    managers.menu:show_joining_lobby_dialog()
  end
  local f = function(l_1_0, l_1_1)
    print("[NetworkMatchMakingSTEAM:join_server:f]", l_1_0, l_1_1)
    managers.system_menu:close("join_server")
    if l_1_0 == "success" then
      print("Success!")
      self.lobby_handler = l_1_1
      local _, host_id, owner = self.lobby_handler:get_server_details()
      print("[NetworkMatchMakingSTEAM:join_server] server details", _, host_id)
      print("Gonna handshake now!")
      self._server_rpc = Network:handshake((host_id:tostring()), nil, "STEAM")
      print("Handshook!")
      if self._server_rpc then
        print("Server RPC:", self._server_rpc:ip_at_index(0))
      end
      if not self._server_rpc then
        return 
      end
      self.lobby_handler:setup_callbacks(NetworkMatchMakingSTEAM._on_memberstatus_change, NetworkMatchMakingSTEAM._on_data_update, NetworkMatchMakingSTEAM._on_chat_message)
      managers.network:start_client()
      managers.menu:show_waiting_for_server_response({cancel_func = function()
        managers.network:session():on_join_request_cancelled()
         end})
      local joined_game = function(l_2_0, l_2_1, l_2_2, l_2_3)
        managers.system_menu:close("waiting_for_server_response")
        print("[NetworkMatchMakingSTEAM:join_server:joined_game]", l_2_0, l_2_1, l_2_2, l_2_3)
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
          Application:error("[NetworkMatchMakingSTEAM:join_server] FAILED TO START MULTIPLAYER!", l_2_0)
        end
         end
      managers.network:join_game_at_host_rpc(self._server_rpc, joined_game)
    else
      managers.menu:show_failed_joining_dialog()
      self:search_lobby(self:search_friends_only())
    end
   end
  Steam:join_lobby(l_27_1, f)
end

NetworkMatchMakingSTEAM.send_join_invite = function(l_28_0, l_28_1)
end

NetworkMatchMakingSTEAM.set_server_attributes = function(l_29_0, l_29_1)
  l_29_0:set_attributes(l_29_1)
end

NetworkMatchMakingSTEAM.create_lobby = function(l_30_0, l_30_1)
  l_30_0._num_players = nil
  local dialog_data = {}
  dialog_data.title = managers.localization:text("dialog_creating_lobby_title")
  dialog_data.text = managers.localization:text("dialog_wait")
  dialog_data.id = "create_lobby"
  dialog_data.no_buttons = true
  managers.system_menu:show(dialog_data)
  local f = function(l_1_0, l_1_1)
    print("Create lobby callback!!", l_1_0, l_1_1)
    if l_1_0 == "success" then
      self.lobby_handler = l_1_1
      self:set_attributes(settings)
      self.lobby_handler:publish_server_details()
      self._server_joinable = true
      self.lobby_handler:set_joinable(true)
      self.lobby_handler:setup_callbacks(NetworkMatchMakingSTEAM._on_memberstatus_change, NetworkMatchMakingSTEAM._on_data_update, NetworkMatchMakingSTEAM._on_chat_message)
      managers.system_menu:close("create_lobby")
      managers.menu:created_lobby()
    else
      managers.system_menu:close("create_lobby")
      local title = managers.localization:text("dialog_error_title")
      local dialog_data = {title = title, text = managers.localization:text("dialog_err_failed_creating_lobby")}
      dialog_data.button_list = {{text = managers.localization:text("dialog_ok")}}
      managers.system_menu:show(dialog_data)
    end
   end
  return Steam:create_lobby(f, NetworkMatchMakingSTEAM.OPEN_SLOTS, "invisible")
end

NetworkMatchMakingSTEAM.set_num_players = function(l_31_0, l_31_1)
  print("NetworkMatchMakingSTEAM:set_num_players", l_31_1)
  l_31_0._num_players = l_31_1
  if l_31_0._lobby_attributes then
    l_31_0._lobby_attributes.num_players = l_31_1
    l_31_0.lobby_handler:set_lobby_data(l_31_0._lobby_attributes)
  end
end

NetworkMatchMakingSTEAM.set_server_state = function(l_32_0, l_32_1)
  if l_32_0._lobby_attributes then
    local state_id = tweak_data:server_state_to_index(l_32_1)
    l_32_0._lobby_attributes.state = state_id
    if l_32_0.lobby_handler then
      l_32_0.lobby_handler:set_lobby_data(l_32_0._lobby_attributes)
      if l_32_1 ~= "in_lobby" then
        l_32_0.lobby_handler:set_joinable(NetworkManager.DROPIN_ENABLED)
      end
    end
  end
end

NetworkMatchMakingSTEAM.set_server_joinable = function(l_33_0, l_33_1)
  print("[NetworkMatchMakingSTEAM:set_server_joinable]", l_33_1)
  l_33_0._server_joinable = l_33_1
  if l_33_0.lobby_handler then
    l_33_0.lobby_handler:set_joinable(l_33_1)
  end
end

NetworkMatchMakingSTEAM.is_server_joinable = function(l_34_0)
  return l_34_0._server_joinable
end

NetworkMatchMakingSTEAM.server_state_name = function(l_35_0)
  return tweak_data:index_to_server_state(l_35_0._lobby_attributes.state)
end

NetworkMatchMakingSTEAM.set_attributes = function(l_36_0, l_36_1)
  if not l_36_0.lobby_handler then
    return 
  end
  local permissions = {"public", "friend", "private"}
  local level_index, job_index = l_36_0:_split_attribute_number(l_36_1.numbers[1], 1000)
  {owner_name = managers.network.account:username_id(), owner_id = managers.network.account:player_id(), level = level_index, difficulty = l_36_1.numbers[2]}.permission = l_36_1.numbers[3]
   -- DECOMPILER ERROR: Confused about usage of registers!

  {owner_name = managers.network.account:username_id(), owner_id = managers.network.account:player_id(), level = level_index, difficulty = l_36_1.numbers[2]}.state = l_36_1.numbers[4] or (l_36_0._lobby_attributes and l_36_0._lobby_attributes.state) or 1
   -- DECOMPILER ERROR: Confused about usage of registers!

  {owner_name = managers.network.account:username_id(), owner_id = managers.network.account:player_id(), level = level_index, difficulty = l_36_1.numbers[2]}.min_level = l_36_1.numbers[7] or 0
   -- DECOMPILER ERROR: Confused about usage of registers!

  {owner_name = managers.network.account:username_id(), owner_id = managers.network.account:player_id(), level = level_index, difficulty = l_36_1.numbers[2]}.num_players = l_36_0._num_players or 1
   -- DECOMPILER ERROR: Confused about usage of registers!

  {owner_name = managers.network.account:username_id(), owner_id = managers.network.account:player_id(), level = level_index, difficulty = l_36_1.numbers[2]}.drop_in = l_36_1.numbers[6] or 1
   -- DECOMPILER ERROR: Confused about usage of registers!

  {owner_name = managers.network.account:username_id(), owner_id = managers.network.account:player_id(), level = level_index, difficulty = l_36_1.numbers[2]}.job_id = job_index or 0
  do
     -- DECOMPILER ERROR: Confused at declaration of local variable

     -- DECOMPILER ERROR: Confused about usage of registers!

    if l_36_0._BUILD_SEARCH_INTEREST_KEY then
      {owner_name = managers.network.account:username_id(), owner_id = managers.network.account:player_id(), level = level_index, difficulty = l_36_1.numbers[2]}[l_36_0._BUILD_SEARCH_INTEREST_KEY] = "true"
    end
     -- DECOMPILER ERROR: Confused about usage of registers!

    l_36_0._lobby_attributes = {owner_name = managers.network.account:username_id(), owner_id = managers.network.account:player_id(), level = level_index, difficulty = l_36_1.numbers[2]}
     -- DECOMPILER ERROR: Confused about usage of registers!

    l_36_0.lobby_handler:set_lobby_data({owner_name = managers.network.account:username_id(), owner_id = managers.network.account:player_id(), level = level_index, difficulty = l_36_1.numbers[2]})
    l_36_0.lobby_handler:set_lobby_type(permissions[l_36_1.numbers[3]])
  end
   -- DECOMPILER ERROR: Confused about usage of registers for local variables.

end

NetworkMatchMakingSTEAM._lobby_to_numbers = function(l_37_0, l_37_1)
  return {}
   -- Warning: undefined locals caused missing assignments!
end

NetworkMatchMakingSTEAM.from_host_lobby_re_opened = function(l_38_0, l_38_1)
  print("[NetworkMatchMakingSTEAM::from_host_lobby_re_opened]", l_38_0._try_re_enter_lobby, l_38_1)
  if l_38_0._try_re_enter_lobby == "asked" then
    if l_38_1 then
      l_38_0._try_re_enter_lobby = "open"
    else
      l_38_0._try_re_enter_lobby = nil
      managers.network.matchmake:leave_game()
    end
  end
end


