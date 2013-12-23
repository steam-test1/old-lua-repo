-- Decompiled using luadec 2.0.1 by sztupy (http://winmo.sztupy.hu)
-- Command line was: F:\SteamLibrary\SteamApps\common\PAYDAY 2\lua\lib\network\base\networkmanager.luac 

require("lib/network/base/BaseNetworkSession")
require("lib/network/base/ClientNetworkSession")
require("lib/network/base/HostNetworkSession")
require("lib/network/matchmaking/NetworkAccount")
require("lib/network/matchmaking/NetworkAccountPSN")
require("lib/network/matchmaking/NetworkAccountSTEAM")
require("lib/network/matchmaking/NetworkAccountXBL")
require("lib/network/matchmaking/NetworkFriend")
require("lib/network/matchmaking/NetworkFriendsPSN")
require("lib/network/matchmaking/NetworkFriendsXBL")
require("lib/network/matchmaking/NetworkGenericPSN")
require("lib/network/matchmaking/NetworkGroupLobby")
require("lib/network/matchmaking/NetworkGroupLobbyPSN")
require("lib/network/matchmaking/NetworkMatchMakingPSN")
require("lib/network/matchmaking/NetworkMatchMakingSTEAM")
require("lib/network/matchmaking/NetworkMatchMakingXBL")
require("lib/network/matchmaking/NetworkVoiceChatDisabled")
require("lib/network/matchmaking/NetworkVoiceChatPSN")
require("lib/network/matchmaking/NetworkVoiceChatSTEAM")
require("lib/network/matchmaking/NetworkVoiceChatXBL")
require("lib/network/base/NetworkPeer")
require("lib/network/base/handlers/BaseNetworkHandler")
require("lib/network/base/handlers/DefaultNetworkHandler")
require("lib/network/base/handlers/ConnectionNetworkHandler")
require("lib/network/base/handlers/PacketNetworkHandler")
require("lib/units/beings/player/PlayerDamage")
require("lib/units/beings/player/PlayerMovement")
if not NetworkManager then
  NetworkManager = class()
end
if SystemInfo:platform() == Idstring("X360") then
  NetworkManager.DEFAULT_PORT = 1000
else
  NetworkManager.DEFAULT_PORT = 9899
end
NetworkManager.DROPIN_ENABLED = true
if SystemInfo:platform() == Idstring("X360") or SystemInfo:platform() == Idstring("PS3") then
  NetworkManager.PROTOCOL_TYPE = "TCP_IP"
else
  NetworkManager.PROTOCOL_TYPE = "STEAM"
end
NetworkManager.init = function(l_1_0, l_1_1)
  l_1_0.OVERWRITEABLE_MSGS = {request_character = {clbk = NetworkManager.clbk_msg_overwrite}, set_look_dir = {clbk = NetworkManager.clbk_msg_overwrite}, set_kit_selection = {clbk = MenuItemKitSlot.clbk_msg_set_kit_selection, categories = {}}, set_mask_set = {clbk = NetworkManager.clbk_msg_overwrite}, criminal_hurt = {clbk = PlayerDamage.clbk_msg_overwrite_criminal_hurt, indexes = {}}, suspicion = {clbk = PlayerMovement.clbk_msg_overwrite_suspicion, indexes = {}}}
  if SystemInfo:platform() == Idstring("PS3") then
    l_1_0._is_ps3 = true
  else
    if SystemInfo:platform() == Idstring("X360") then
      l_1_0._is_x360 = true
    else
      l_1_0._is_win32 = true
    end
  end
  l_1_0._spawn_points = {}
  if l_1_0._is_ps3 then
    Network:set_use_psn_network(true)
    if #PSN:get_world_list() == 0 then
      PSN:init_matchmaking()
    end
    l_1_0:_register_PSN_matchmaking_callbacks()
  elseif l_1_0._is_win32 then
    l_1_0.account = NetworkAccountSTEAM:new()
    l_1_0.voice_chat = NetworkVoiceChatSTEAM:new()
  elseif l_1_0._is_x360 then
    l_1_0.account = NetworkAccountXBL:new()
    l_1_0.voice_chat = NetworkVoiceChatXBL:new()
  end
  l_1_0._started = false
  l_1_0._game_class = l_1_1
  managers.network = l_1_0
  l_1_0:_create_lobby()
  l_1_0:load()
end

NetworkManager.init_finalize = function(l_2_0)
  print("NetworkManager:init_finalize()")
  if Network:multiplayer() and not Application:editor() then
    l_2_0._session:on_load_complete()
    l_2_0._game:on_load_complete()
  end
end

NetworkManager._create_lobby = function(l_3_0)
  if l_3_0._is_win32 then
    cat_print("lobby", "Online Lobby is PC")
    l_3_0.matchmake = NetworkMatchMakingSTEAM:new()
  elseif l_3_0._is_ps3 then
    cat_print("lobby", "Online Lobby is PS3")
    l_3_0.friends = NetworkFriendsPSN:new()
    l_3_0.group = NetworkGroupLobbyPSN:new()
    l_3_0.matchmake = NetworkMatchMakingPSN:new()
    l_3_0.shared_psn = NetworkGenericPSN:new()
    l_3_0.shared = l_3_0.shared_psn
    l_3_0.account = NetworkAccountPSN:new()
    l_3_0.match = nil
    l_3_0:ps3_determine_voice(l_3_0)
    l_3_0._shared_update = l_3_0.shared_psn
  elseif l_3_0._is_x360 then
    l_3_0.friends = NetworkFriendsXBL:new()
    l_3_0.matchmake = NetworkMatchMakingXBL:new()
  else
    Global._boot_invite_mp = nil
    Application:error("NetworkManager:create_lobby failed to get a valid lobby for online play.")
    return 
  end
end

NetworkManager.ps3_determine_voice = function(l_4_0, l_4_1)
  local voice = "voice_quiet"
  if l_4_1 == true then
    voice = "voice_quiet"
  else
    if PSN:is_online() and PSN:online_chat_allowed() then
      voice = "voice_psn"
    else
      voice = "voice_disabled"
    end
  end
  if l_4_0.voice_chat and l_4_0.voice_chat:voice_type() == voice then
    return 
  end
  if l_4_0.voice_chat and l_4_0.voice_chat:voice_type() ~= voice then
    l_4_0.voice_chat:close_all(true)
    l_4_0.voice_chat = nil
  end
  if voice == "voice_psn" then
    l_4_0.voice_chat = NetworkVoiceChatPSN:new()
  elseif voice == "voice_disabled" then
    l_4_0.voice_chat = NetworkVoiceChatDisabled:new()
  else
    l_4_0.voice_chat = NetworkVoiceChatDisabled:new(true)
  end
end

NetworkManager.session = function(l_5_0)
  return l_5_0._session
end

NetworkManager.game = function(l_6_0)
  return l_6_0._game
end

NetworkManager.shared_handler_data = function(l_7_0)
  return l_7_0._shared_handler_data
end

NetworkManager.load = function(l_8_0)
  if Global.network then
    l_8_0._network_bound = Global.network.network_bound
    l_8_0:start_network()
    if Global.network.session then
      if Global.network.session_host then
        l_8_0._session = HostNetworkSession:new()
        l_8_0._game:on_server_session_created()
      else
        l_8_0._session = ClientNetworkSession:new()
      end
    end
    l_8_0._session:load(Global.network.session)
    l_8_0._game:load(Global.network_game)
    managers.network.matchmake:_load_globals()
    if l_8_0._is_x360 then
      managers.network.voice_chat:resume()
    else
      managers.network.voice_chat:_load_globals()
    end
    Global.network_game = nil
    Global.network = nil
    if l_8_0._is_win32 then
      managers.network.voice_chat:open()
    end
  end
end

NetworkManager.save = function(l_9_0)
  if l_9_0._started then
    Global.network = {}
    Global.network.network_bound = l_9_0._network_bound
    if l_9_0._session then
      Global.network.session_host = l_9_0._session:is_host()
      Global.network.session = {}
      l_9_0._session:save(Global.network.session)
    end
    managers.network.matchmake:_save_globals()
    managers.network.voice_chat:_save_globals(true)
    l_9_0._game:save()
    if l_9_0._is_win32 then
      managers.network.voice_chat:destroy_voice()
    end
  end
end

NetworkManager.update = function(l_10_0, l_10_1, l_10_2)
  if l_10_0._stop_next_frame then
    l_10_0:stop_network(true)
    l_10_0._stop_next_frame = nil
    return 
  end
  if l_10_0._session then
    l_10_0._session:update()
  end
  if l_10_0.matchmake then
    l_10_0.matchmake:update()
  end
  if l_10_0.voice_chat then
    l_10_0.voice_chat:update(l_10_1)
  end
end

NetworkManager.end_update = function(l_11_0)
  if l_11_0._stop_network then
    l_11_0._stop_next_frame = true
    l_11_0._stop_network = nil
  end
  if l_11_0._session then
    l_11_0._session:end_update()
  end
end

NetworkManager.start_network = function(l_12_0)
  if not l_12_0._started then
    Global.category_print.multiplayer_base = true
    if l_12_0._game_class then
      l_12_0._game = _G[l_12_0._game_class]:new()
    end
    l_12_0:register_handler("connection", ConnectionNetworkHandler)
    l_12_0:register_handler("packet", PacketNetworkHandler)
    l_12_0._game:on_network_started()
     -- DECOMPILER ERROR: Confused while interpreting a jump as a 'while'

  end
  Network:bind(l_12_0.DEFAULT_PORT, DefaultNetworkHandler:new())
  l_12_0._network_bound = true
  l_12_0._started = true
  cat_print("multiplayer_base", "[NetworkManager:start_network]")
end
end

NetworkManager.register_handler = function(l_13_0, l_13_1, l_13_2)
  if not l_13_0._handlers then
    l_13_0._handlers = {}
    l_13_0._shared_handler_data = {}
  end
  local new_handler = l_13_2:new()
  l_13_0._handlers[l_13_1] = new_handler
  Network:set_receiver(Idstring(l_13_1), new_handler)
end

NetworkManager.prepare_stop_network = function(l_14_0, ...)
  if l_14_0._session then
    l_14_0._session:prepare_to_close(...)
    if l_14_0.voice_chat and l_14_0._is_win32 then
      l_14_0.voice_chat:destroy_voice()
       -- DECOMPILER ERROR: Confused about usage of registers for local variables.

    end
  end
end

NetworkManager.stop_network = function(l_15_0, l_15_1)
  if l_15_0._started then
    l_15_0._game:on_network_stopped()
    l_15_0._started = false
    if l_15_1 and l_15_0._session then
      local peers = l_15_0._session:peers()
      for k,peer in pairs(peers) do
        local rpc = peer:rpc()
        if rpc then
          Network:reset_connection(rpc)
          Network:remove_client(rpc)
        end
      end
    end
    l_15_0._handlers = nil
    l_15_0._shared_handler_data = nil
    l_15_0._session:destroy()
    l_15_0._session = nil
    l_15_0._game = nil
    l_15_0._stop_network = nil
    l_15_0._stop_next_frame = nil
    l_15_0._network_bound = nil
    Network:unbind()
    Network:set_disconnected()
    if not Application:editor() then
      Network:set_multiplayer(false)
    end
    cat_print("multiplayer_base", "[NetworkManager:stop_network]")
    print("---------------------------------------------------------")
  end
end

NetworkManager.queue_stop_network = function(l_16_0)
  l_16_0._stop_network = true
end

NetworkManager.is_ready_to_load = function(l_17_0)
  if l_17_0._stop_next_frame or l_17_0._stop_network then
    return false
  end
  return (l_17_0._session and l_17_0._session:is_ready_to_close())
end

NetworkManager.stopping = function(l_18_0)
  if not l_18_0._started then
    return true
  end
  if l_18_0._stop_next_frame or l_18_0._stop_network then
    return true
  end
  return false
end

NetworkManager.start_client = function(l_19_0)
  l_19_0:stop_network(true)
  l_19_0:start_network()
  if l_19_0._is_win32 then
    l_19_0.voice_chat:open()
  end
  l_19_0._session = ClientNetworkSession:new()
end

NetworkManager.discover_hosts = function(l_20_0, l_20_1)
  l_20_0:stop_network(true)
  l_20_0:start_network()
  l_20_0._session = ClientNetworkSession:new()
  l_20_0._discover_hosts_cb = l_20_1
  l_20_0._session:discover_hosts()
end

NetworkManager.on_discover_host_received = function(l_21_0, l_21_1)
  if Global.game_settings.single_player then
    return 
  end
  local level_name = Global.level_data.level
  local level_id = tweak_data.levels:get_index_from_world_name(level_name)
  if level_id then
    level_name = ""
  else
    level_id = 1
  end
  local peer = managers.network:session():local_peer()
  local state = peer:in_lobby() and 1 or 2
  local difficulty = Global.game_settings.difficulty
  level_id = tweak_data.levels:get_index_from_level_id(Global.game_settings.level_id)
  print("on_discover_host_received", level_id)
  local my_name = nil
  if SystemInfo:platform() == Idstring("PS3") then
    my_name = "Player 1"
  else
    my_name = Network:hostname()
  end
  l_21_1:discover_host_reply(my_name, level_id, level_name, l_21_1:ip_at_index(0), state, difficulty)
end

NetworkManager.on_discover_host_reply = function(l_22_0, l_22_1, l_22_2, l_22_3, l_22_4, l_22_5, l_22_6)
  print("on_discover_host_reply", l_22_1, l_22_2, l_22_3, l_22_4, l_22_5)
  if l_22_0._discover_hosts_cb then
    local cb = l_22_0._discover_hosts_cb
    l_22_0._session:on_host_discovered(l_22_1, l_22_2, l_22_3, l_22_4, l_22_5, l_22_6)
    cb(l_22_1, l_22_2, l_22_3, l_22_4, l_22_5, l_22_6)
  end
end

NetworkManager.host_game = function(l_23_0)
  l_23_0:stop_network(true)
  l_23_0:start_network()
  if l_23_0._is_win32 then
    l_23_0.voice_chat:open()
  end
  l_23_0._session = HostNetworkSession:new()
  l_23_0._game:on_server_session_created()
  if l_23_0.is_ps3 then
    l_23_0._session:broadcast_server_up()
  end
end

NetworkManager.join_game_at_host_rpc = function(l_24_0, l_24_1, l_24_2)
  l_24_0._discover_hosts_cb = nil
  if l_24_0._session then
    l_24_0._session:request_join_host(l_24_1, l_24_2)
  else
    print("[NetworkManager:join_game_at_host_rpc] no session!!!")
  end
end

NetworkManager.register_spawn_point = function(l_25_0, l_25_1, l_25_2)
  local runtime_data = {pos_rot = {l_25_2.position, l_25_2.rotation}, id = l_25_1}
  l_25_0._spawn_points[l_25_1] = runtime_data
end

NetworkManager.unregister_spawn_point = function(l_26_0, l_26_1)
  l_26_0._spawn_points[l_26_1] = nil
end

NetworkManager.unregister_all_spawn_points = function(l_27_0)
  l_27_0._spawn_points = {}
end

NetworkManager.has_spawn_points = function(l_28_0)
  return next(l_28_0._spawn_points)
end

NetworkManager.spawn_point = function(l_29_0, l_29_1)
  return l_29_0._spawn_points[l_29_1]
end

NetworkManager._register_PSN_matchmaking_callbacks = function(l_30_0)
  local gen_clbk = callback(l_30_0, l_30_0, "clbk_PSN_event")
  PSN:set_matchmaking_callback("session_destroyed", gen_clbk)
  PSN:set_matchmaking_callback("session_created", gen_clbk)
  PSN:set_matchmaking_callback("session_kickout", gen_clbk)
  PSN:set_matchmaking_callback("member_left", gen_clbk)
  PSN:set_matchmaking_callback("member_joined", gen_clbk)
  PSN:set_matchmaking_callback("owner_changed", gen_clbk)
  PSN:set_matchmaking_callback("server_ready", gen_clbk)
  PSN:set_matchmaking_callback("lobby_refresh", gen_clbk)
  PSN:set_matchmaking_callback("lobby_joined", gen_clbk)
  PSN:set_matchmaking_callback("lobby_left", gen_clbk)
  PSN:set_matchmaking_callback("friends_updated", gen_clbk)
  PSN:set_matchmaking_callback("receive_group_invitation", gen_clbk)
  PSN:set_matchmaking_callback("room_custom_info", gen_clbk)
  PSN:set_matchmaking_callback("invitation_received", gen_clbk)
  PSN:set_matchmaking_callback("invitation_received_result", gen_clbk)
  PSN:set_matchmaking_callback("invitation_gui_opened", gen_clbk)
  PSN:set_matchmaking_callback("invitation_gui_closed", gen_clbk)
  PSN:set_matchmaking_callback("connection_etablished", gen_clbk)
  PSN:set_matchmaking_callback("session_search", gen_clbk)
  PSN:set_matchmaking_callback("custom_message", gen_clbk)
  PSN:set_matchmaking_callback("session_update", gen_clbk)
  PSN:set_matchmaking_callback("error", gen_clbk)
end

NetworkManager.clbk_PSN_event = function(l_31_0, ...)
  print("[NetworkManager:clbk_PSN_event]", inspect(...))
   -- DECOMPILER ERROR: Confused about usage of registers for local variables.

end

NetworkManager.search_ses = function(l_32_0)
  PSN:set_matchmaking_callback("session_search", callback(l_32_0, l_32_0, "clbk_search_session"))
  local search_params = {numbers = {1, 3}}
  PSN:search_session(search_params, {}, PSN:get_world_list()[1].world_id)
end

NetworkManager.clbk_search_session = function(l_33_0, l_33_1)
  print("[NetworkManager:clbk_search_session]", l_33_1)
  for i,k in pairs(l_33_1) do
    if k then
      print(i, inspect(k))
    end
  end
end

NetworkManager.clbk_msg_overwrite = function(l_34_0, l_34_1, ...)
  if l_34_1 then
    if l_34_0.index then
      l_34_1[l_34_0.index] = {...}
    else
      table.insert(l_34_1, {...})
      l_34_0.index = #l_34_1
    end
  else
    l_34_0.index = nil
     -- DECOMPILER ERROR: Confused about usage of registers for local variables.

  end
end
end

NetworkManager.protocol_type = function(l_35_0)
  return l_35_0.PROTOCOL_TYPE
end


