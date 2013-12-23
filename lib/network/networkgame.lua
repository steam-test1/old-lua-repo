-- Decompiled using luadec 2.0.1 by sztupy (http://winmo.sztupy.hu)
-- Command line was: F:\SteamLibrary\SteamApps\common\PAYDAY 2\lua\lib\network\networkgame.luac 

require("lib/network/NetworkMember")
require("lib/network/handlers/UnitNetworkHandler")
if not NetworkGame then
  NetworkGame = class()
end
NetworkGame.init = function(l_1_0)
  l_1_0._members = {}
  l_1_0._spawn_point_beanbag = nil
  l_1_0._dropin_pause_info = {}
  l_1_0._old_players = {}
end

NetworkGame.on_network_started = function(l_2_0)
  managers.network:register_handler("unit", UnitNetworkHandler)
end

NetworkGame.on_network_stopped = function(l_3_0)
  for k = 1, 4 do
    l_3_0:on_drop_in_pause_request_received(k, nil, false)
    if l_3_0._members[k] then
      l_3_0._members[k]:delete()
    end
  end
  if managers.network:session():local_peer() then
    l_3_0:on_drop_in_pause_request_received((managers.network:session():local_peer():id()), nil, false)
  end
end

NetworkGame.load = function(l_4_0, l_4_1)
  if managers.network:session():is_client() then
    Network:set_client(managers.network:session():server_peer():rpc())
    local is_playing = BaseNetworkHandler._gamestate_filter.any_ingame_playing[game_state_machine:last_queued_state_name()]
    if is_playing then
      Application:set_pause(true)
    end
  end
  if l_4_1 then
    for k,v in pairs(l_4_1.members) do
      l_4_0._members[k] = NetworkMember:new()
      l_4_0._members[k]:load(v)
    end
  end
end

NetworkGame.save = function(l_5_0)
  Global.network_game = {members = {}}
  for k,v in pairs(l_5_0._members) do
    Global.network_game.members[k] = v:save()
  end
  Global.local_member = nil
end

NetworkGame.on_server_session_created = function(l_6_0)
  if Network:multiplayer() then
    Network:set_server()
  end
end

NetworkGame.on_new_host = function(l_7_0, l_7_1)
  if Network:multiplayer() and Network:is_client() then
    Network:set_client(l_7_1:rpc())
  end
end

NetworkGame.on_entered_lobby = function(l_8_0)
  local local_peer = managers.network:session():local_peer()
  local id = local_peer:id()
  if not l_8_0._members[id] then
    local my_member = NetworkMember:new(local_peer)
  end
  l_8_0._members[id] = my_member
  Global.local_member = my_member
  local_peer:set_in_lobby(true)
  if id ~= 1 then
    l_8_0:on_peer_entered_lobby(1)
  end
  managers.network:session():send_to_peers_loaded("set_peer_entered_lobby")
  cat_print("multiplayer_base", "NetworkGame:on_entered_lobby", local_peer, id)
end

NetworkGame.on_peer_entered_lobby = function(l_9_0, l_9_1)
  cat_print("multiplayer_base", "[NetworkGame:on_peer_entered_lobby]", l_9_1)
  local peer = managers.network:session():peer(l_9_1)
  peer:set_in_lobby(true)
  if peer:ip_verified() then
    Global.local_member:sync_lobby_data(peer)
  end
end

NetworkGame.on_load_complete = function(l_10_0)
  local local_peer = managers.network:session():local_peer()
  local_peer:set_synched(true)
  local id = local_peer:id()
  local my_member = NetworkMember:new(local_peer)
  l_10_0._members[id] = my_member
  Global.local_member = my_member
  cat_print("multiplayer_base", "[NetworkGame:on_load_complete]", local_peer, id)
  if managers.hud then
    for _,peer in pairs(managers.network:session():peers()) do
      local peer_id = peer:id()
    end
  end
  if SystemInfo:platform() == Idstring("PS3") then
    PSN:set_online_callback(callback(l_10_0, l_10_0, "ps3_disconnect"))
  end
end

NetworkGame.psn_disconnected = function(l_11_0)
  if Global.game_settings.single_player then
    return 
  end
  if game_state_machine:current_state().on_disconnected then
    game_state_machine:current_state():on_disconnected()
  end
  managers.network.voice_chat:destroy_voice(true)
end

NetworkGame.steam_disconnected = function(l_12_0)
  if Global.game_settings.single_player then
    return 
  end
  if game_state_machine:current_state().on_disconnected then
    game_state_machine:current_state():on_disconnected()
  end
  managers.network.voice_chat:destroy_voice(true)
end

NetworkGame.xbox_disconnected = function(l_13_0)
  if Global.game_settings.single_player then
    return 
  end
  if game_state_machine:current_state().on_disconnected then
    game_state_machine:current_state():on_disconnected()
  end
  managers.network.voice_chat:destroy_voice(true)
end

NetworkGame.ps3_disconnect = function(l_14_0, l_14_1)
  print("NetworkGame ps3_disconnect", l_14_1)
  if Global.game_settings.single_player then
    return 
  end
  if not l_14_1 and not PSN:is_online() then
    if game_state_machine:current_state().on_disconnected then
      game_state_machine:current_state():on_disconnected()
    end
    managers.network.voice_chat:destroy_voice(true)
  end
end

NetworkGame.on_peer_added = function(l_15_0, l_15_1, l_15_2)
  cat_print("multiplayer_base", "NetworkGame:on_peer_added", l_15_1, l_15_2)
  l_15_0._members[l_15_2] = NetworkMember:new(l_15_1)
  if managers.hud then
    managers.menu:get_menu("kit_menu").renderer:set_slot_joining(l_15_1, l_15_2)
  end
  if Network:is_server() then
    managers.network.matchmake:set_num_players(table.size(l_15_0._members))
  end
  if SystemInfo:platform() == Idstring("X360") then
    managers.network.matchmake:on_peer_added(l_15_1)
  end
end

NetworkGame.check_peer_preferred_character = function(l_16_0, l_16_1)
  local free_characters = CriminalsManager.character_names()
  for pid,member in pairs(l_16_0._members) do
    local character = member:peer():character()
    table.delete(free_characters, character)
  end
  if table.contains(free_characters, l_16_1) then
    return l_16_1
  end
  local character = free_characters[math.random(#free_characters)]
  print("Player will be", character, "instead of", l_16_1)
  return character
end

NetworkGame.on_peer_request_character = function(l_17_0, l_17_1, l_17_2)
  if Global.game_settings.single_player then
    local peer = managers.network:session():peer(l_17_1)
    peer:set_character(l_17_2)
    local lobby_menu = managers.menu:get_menu("lobby_menu")
    if lobby_menu and lobby_menu.renderer:is_open() then
      lobby_menu.renderer:set_character(l_17_1, l_17_2)
    end
    local kit_menu = managers.menu:get_menu("kit_menu")
    if kit_menu and kit_menu.renderer:is_open() then
      kit_menu.renderer:set_character(l_17_1, l_17_2)
    end
    return 
  end
   -- DECOMPILER ERROR: unhandled construct in 'if'

  if managers.network:session():local_peer():in_lobby() or l_17_2 ~= "random" then
    for pid,member in pairs(l_17_0._members) do
      if member:peer():character() == l_17_2 then
        print("Deny", l_17_1, "cause peer", member:peer():id(), "has character", l_17_2)
        return 
      end
    end
  end
  print("[NetworkGame:on_peer_request_character] peer", l_17_1, "character", l_17_2)
  managers.network:session():peer(l_17_1):set_character(l_17_2)
  local lobby_menu = managers.menu:get_menu("lobby_menu")
  if lobby_menu and lobby_menu.renderer:is_open() then
    lobby_menu.renderer:set_character(l_17_1, l_17_2)
  end
  local kit_menu = managers.menu:get_menu("kit_menu")
  if kit_menu and kit_menu.renderer:is_open() then
    kit_menu.renderer:set_character(l_17_1, l_17_2)
  end
  managers.network:session():send_to_peers("request_character_response", l_17_1, l_17_2)
end

NetworkGame.on_peer_sync_complete = function(l_18_0, l_18_1, l_18_2)
  cat_print("multiplayer_base", "[NetworkGame:on_peer_sync_complete]", l_18_2)
  if not Global.local_member then
    return 
  end
  if not l_18_1:ip_verified() then
    return 
  end
  local local_peer = managers.network:session():local_peer()
  local local_peer_id = local_peer:id()
  if l_18_1:ip_verified() then
    Global.local_member:sync_lobby_data(l_18_1)
    Global.local_member:sync_data(l_18_1)
  end
  local kit_menu = managers.menu:get_menu("kit_menu")
  if kit_menu and kit_menu.renderer:is_open() then
    if l_18_1:waiting_for_player_ready() then
      kit_menu.renderer:set_slot_ready(l_18_1, l_18_2)
    else
      kit_menu.renderer:set_slot_not_ready(l_18_1, l_18_2)
    end
  end
  if Network:is_server() then
    l_18_0:_check_start_game_intro()
  end
end

NetworkGame.on_set_member_ready = function(l_19_0, l_19_1, l_19_2)
  print("[NetworkGame:on_set_member_ready]", l_19_1, l_19_2)
  local peer = managers.network:session():peer(l_19_1)
  local kit_menu = managers.menu:get_menu("kit_menu")
  if kit_menu and kit_menu.renderer:is_open() then
    if l_19_2 then
      kit_menu.renderer:set_slot_ready(peer, l_19_1)
    else
      kit_menu.renderer:set_slot_not_ready(peer, l_19_1)
    end
  end
  if Network:is_server() then
    l_19_0:_check_start_game_intro()
  end
end

NetworkGame._check_start_game_intro = function(l_20_0)
  if not managers.network:session():chk_all_handshakes_complete() then
    return 
  end
  for _,member in pairs(l_20_0._members) do
    if not member:peer():waiting_for_player_ready() then
      print("[NetworkGame:_check_start_game_intro]", member:peer():id(), "not ready")
      return 
    end
    if not member:peer():synched() then
      print("[NetworkGame:_check_start_game_intro]", member:peer():id(), "not synched")
      return 
    end
  end
  if not managers.network:session():chk_send_ready_to_unpause() then
    return 
  end
  if game_state_machine:current_state().start_game_intro then
    game_state_machine:current_state():start_game_intro()
  end
end

NetworkGame.on_statistics_recieved = function(l_21_0, l_21_1, l_21_2, l_21_3, l_21_4, l_21_5, l_21_6)
  local peer = managers.network:session():peer(l_21_1)
  peer:set_statistics(l_21_2, l_21_3, l_21_4, l_21_5, l_21_6)
  for _,member in pairs(l_21_0._members) do
    if member:peer():has_statistics() then
      for (for control),_ in (for generator) do
      end
      if member:peer():waiting_for_player_ready() and not member:peer():has_statistics() then
        return 
      end
    end
    print("decide the stats")
    local total_kills = 0
    local total_specials_kills = 0
    local total_head_shots = 0
    local best_killer = {peer_id = nil, score = 0}
    local best_special_killer = {peer_id = nil, score = 0}
    local best_accuracy = {peer_id = nil, score = 0}
    local group_accuracy = 0
    local group_downs = 0
    do
      local most_downs = {peer_id = nil, score = 0}
      for _,member in pairs(l_21_0._members) do
        if member:peer():has_statistics() then
          local stats = member:peer():statistics()
          total_kills = total_kills + stats.total_kills
          total_specials_kills = total_specials_kills + stats.total_specials_kills
          total_head_shots = total_head_shots + stats.total_head_shots
          group_accuracy = group_accuracy + stats.accuracy
          group_downs = group_downs + stats.downs
          if best_killer.score < stats.total_kills or not best_killer.peer_id then
            best_killer.score = stats.total_kills
            best_killer.peer_id = member:peer():id()
          end
          if best_special_killer.score < stats.total_specials_kills or not best_special_killer.peer_id then
            best_special_killer.score = stats.total_specials_kills
            best_special_killer.peer_id = member:peer():id()
          end
          if best_accuracy.score < stats.accuracy or not best_accuracy.peer_id then
            best_accuracy.score = stats.accuracy
            best_accuracy.peer_id = member:peer():id()
          end
          if most_downs.score < stats.downs or not most_downs.peer_id then
            most_downs.score = stats.downs
            most_downs.peer_id = member:peer():id()
          end
        end
      end
      group_accuracy = math.floor((group_accuracy) / table.size(l_21_0._members))
      print("result is", "total_kills", total_kills, "total_specials_kills", total_specials_kills, "total_head_shots", total_head_shots)
      print(inspect(best_killer))
      print(inspect(best_special_killer))
      print(inspect(best_accuracy.peer_id))
      if game_state_machine:current_state().on_statistics_result then
        game_state_machine:current_state():on_statistics_result(best_killer.peer_id, best_killer.score, best_special_killer.peer_id, best_special_killer.score, best_accuracy.peer_id, best_accuracy.score, most_downs.peer_id, most_downs.score, total_kills, total_specials_kills, total_head_shots, group_accuracy, group_downs)
      end
      managers.network:session():send_to_peers("sync_statistics_result", best_killer.peer_id, best_killer.score, best_special_killer.peer_id, best_special_killer.score, best_accuracy.peer_id, best_accuracy.score, most_downs.peer_id, most_downs.score, total_kills, total_specials_kills, total_head_shots, group_accuracy, group_downs)
    end
     -- Warning: missing end command somewhere! Added here
  end
end

NetworkGame.on_peer_removed = function(l_22_0, l_22_1, l_22_2, l_22_3)
  if l_22_0._members[l_22_2] then
    if managers.player then
      managers.player:peer_dropped_out(l_22_1)
    end
    if managers.menu_scene then
      managers.menu_scene:set_lobby_character_visible(l_22_2, false)
    end
    local lobby_menu = managers.menu:get_menu("lobby_menu")
    if lobby_menu and lobby_menu.renderer:is_open() then
      lobby_menu.renderer:remove_player_slot_by_peer_id(l_22_1, l_22_3)
    end
    local kit_menu = managers.menu:get_menu("kit_menu")
    if kit_menu and kit_menu.renderer:is_open() then
      kit_menu.renderer:remove_player_slot_by_peer_id(l_22_1, l_22_3)
    end
    if managers.menu_component then
      managers.menu_component:on_peer_removed(l_22_1, l_22_3)
    end
    print("Someone left", l_22_1:name(), l_22_2)
    local player_left = false
    local player_character = nil
    if managers.criminals then
      player_character = managers.criminals:character_name_by_peer_id(l_22_2)
      if player_character then
        player_left = true
        print("Player left")
      end
    end
    local member_unit = l_22_0._members[l_22_2]:unit()
    if alive(member_unit) then
      local member_downed = member_unit:movement():downed()
    end
    local member_health = 1
    if managers.trade then
      local member_dead = managers.trade:is_peer_in_custody(l_22_2)
    end
    if player_left then
      local mugshot_id = managers.criminals:character_data_by_peer_id(l_22_2).mugshot_id
      local mugshot_data = managers.hud:_get_mugshot_data(mugshot_id)
      member_health = mugshot_data and mugshot_data.health_amount or 1
    end
    local member_used_deployable = l_22_1:used_deployable() or false
    l_22_0._members[l_22_2]:delete()
    l_22_0._members[l_22_2] = nil
    if SystemInfo:platform() ~= Idstring("WIN32") or not l_22_1:user_id() then
      local peer_ident = l_22_1:name()
    end
    if Network:is_server() then
      l_22_0:_check_start_game_intro()
    end
    if Network:multiplayer() then
      if SystemInfo:platform() == Idstring("X360") then
        managers.network.matchmake:on_peer_removed(l_22_1)
      end
      if Network:is_client() and player_left then
        managers.criminals:remove_character_by_peer_id(l_22_2)
        managers.trade:replace_player_with_ai(player_character, player_character)
        do return end
        if Network:is_server() then
          managers.network.matchmake:set_num_players(table.size(l_22_0._members))
          Network:remove_client(l_22_1:rpc())
          if player_left then
            managers.achievment:set_script_data("cant_touch_fail", true)
            managers.criminals:remove_character_by_peer_id(l_22_2)
            local unit = managers.groupai:state():spawn_one_teamAI(true, player_character)
            l_22_0._old_players[peer_ident] = {t = Application:time(), member_downed = member_downed, health = member_health, used_deployable = member_used_deployable, member_dead = member_dead}
            local trade_entry = managers.trade:replace_player_with_ai(player_character, player_character)
            if unit then
              if trade_entry then
                unit:brain():set_active(false)
                unit:base():set_slot(unit, 0)
                unit:base():unregister()
              elseif member_downed then
                unit:character_damage():force_bleedout()
              end
            end
          end
          local deployed_equipment = World:find_units_quick("all", 14, 25, 26)
          for _,equipment in ipairs(deployed_equipment) do
            if equipment:base() and equipment:base().server_information then
              local server_information = equipment:base():server_information()
              if server_information and server_information.owner_peer_id == l_22_2 then
                equipment:set_slot(0)
              end
            end
          end
        else
          print("Tried to remove client when neither server or client")
          Application:stack_dump()
        end
      end
    end
  end
end

NetworkGame._has_client = function(l_23_0, l_23_1)
  for i = 0, Network:clients():num_peers() - 1 do
    if Network:clients():ip_at_index(i) == l_23_1:ip() then
      return true
    end
  end
  return false
end

NetworkGame.on_peer_loading = function(l_24_0, l_24_1, l_24_2)
  cat_print("multiplayer_base", "[NetworkGame:on_peer_loading]", inspect(l_24_1), l_24_2)
  if Network:is_server() and not l_24_2 then
    if not l_24_0:_has_client(l_24_1) then
      Network:remove_co_client(l_24_1:rpc())
      Network:add_client(l_24_1:rpc())
    end
    if not NetworkManager.DROPIN_ENABLED then
      l_24_1:on_sync_start()
      l_24_1:chk_enable_queue()
      Network:drop_in(l_24_1:rpc())
    end
  end
  if l_24_2 and l_24_1 == managers.network:session():server_peer() then
    cat_print("multiplayer_base", "  SERVER STARTED LOADING", l_24_1, l_24_1:id())
    if managers.network:session():local_peer():in_lobby() then
      local lobby_menu = managers.menu:get_menu("lobby_menu")
      if lobby_menu and lobby_menu.renderer:is_open() then
        lobby_menu.renderer:set_server_state("loading")
      end
      if managers.menu_scene then
        managers.menu_scene:set_server_loading()
      end
      if managers.menu_component then
        managers.menu_component:set_server_info_state("loading")
      end
    end
  end
end

NetworkGame.spawn_players = function(l_25_0, l_25_1)
  if not managers.network:has_spawn_points() then
    return 
  end
  if not l_25_0._spawn_point_beanbag then
    l_25_0:_create_spawn_point_beanbag()
  end
  if Network:is_server() then
    if not Global.local_member then
      return 
    end
    local id = l_25_0:_get_next_spawn_point_id()
    Application:stack_dump()
    for peer_id,member in pairs(l_25_0._members) do
      local character = member:peer()._character
      if member ~= Global.local_member and character ~= "random" then
        member:spawn_unit(l_25_0:_get_next_spawn_point_id(), l_25_1, character)
      end
    end
    local local_character = Global.local_member:peer()._character
    Global.local_member:spawn_unit(id, false, local_character ~= "random" and local_character or nil)
    for peer_id,member in pairs(l_25_0._members) do
      local character = member:peer()._character
      if member ~= Global.local_member and character == "random" then
        member:spawn_unit(l_25_0:_get_next_spawn_point_id(), l_25_1)
      end
    end
    managers.network:session():set_game_started(true)
  end
  managers.groupai:state():fill_criminal_team_with_AI(l_25_1)
end

NetworkGame.spawn_dropin_player = function(l_26_0, l_26_1)
  managers.achievment:set_script_data("cant_touch_fail", true)
  l_26_0._members[l_26_1]:spawn_unit(0, true)
  managers.groupai:state():fill_criminal_team_with_AI(true)
end

NetworkGame.member = function(l_27_0, l_27_1)
  return l_27_0._members[l_27_1]
end

NetworkGame.all_members = function(l_28_0)
  return l_28_0._members
end

NetworkGame.amount_of_members = function(l_29_0)
  return table.size(l_29_0._members)
end

NetworkGame.amount_of_alive_players = function(l_30_0)
  local i = 0
  for _,member in pairs(l_30_0._members) do
    i = i + (alive(member._unit) and 1 or 0)
  end
  return i
end

NetworkGame.member_peer = function(l_31_0, l_31_1)
  return l_31_0._members[l_31_1:id()]
end

NetworkGame.member_from_unit = function(l_32_0, l_32_1)
  local wanted_key = l_32_1:key()
  for _,member in pairs(l_32_0._members) do
    local test_unit = member:unit()
    if alive(test_unit) and test_unit:key() == wanted_key then
      return member
    end
  end
end

NetworkGame.member_from_unit_key = function(l_33_0, l_33_1)
  for _,member in pairs(l_33_0._members) do
    local test_unit = member:unit()
    if alive(test_unit) and test_unit:key() == l_33_1 then
      return member
    end
  end
end

NetworkGame.unit_from_peer_id = function(l_34_0, l_34_1)
  for _,member in pairs(l_34_0._members) do
    if member:peer():id() == l_34_1 then
      return member:unit()
    end
  end
end

NetworkGame._create_spawn_point_beanbag = function(l_35_0)
  local spawn_points = managers.network._spawn_points
  do
    local spawn_point_ids = {}
    l_35_0._spawn_point_beanbag = {}
    for sp_id,sp_data in pairs(spawn_points) do
      table.insert(spawn_point_ids, sp_id)
    end
    repeat
      if #spawn_point_ids > 0 then
        local i_id = math.random(#spawn_point_ids)
        local random_id = spawn_point_ids[i_id]
        table.insert(l_35_0._spawn_point_beanbag, random_id)
        spawn_point_ids[i_id] = spawn_point_ids[#spawn_point_ids]
        table.remove(spawn_point_ids)
      else
        l_35_0._next_i_spawn_point = 1
      end
       -- Warning: missing end command somewhere! Added here
    end
     -- Warning: missing end command somewhere! Added here
  end
end

NetworkGame._get_next_spawn_point_id = function(l_36_0)
  local id = l_36_0._spawn_point_beanbag[l_36_0._next_i_spawn_point]
  if l_36_0._next_i_spawn_point == #l_36_0._spawn_point_beanbag then
    l_36_0._next_i_spawn_point = 1
  else
    l_36_0._next_i_spawn_point = l_36_0._next_i_spawn_point + 1
  end
  return id
end

NetworkGame.get_next_spawn_point = function(l_37_0)
  local id = l_37_0:_get_next_spawn_point_id()
  return managers.network:spawn_point(id)
end

NetworkGame.spawn_member_by_id = function(l_38_0, l_38_1, l_38_2, l_38_3)
  local member = l_38_0._members[l_38_1]
  if member then
    local character = member:peer():character()
    return member:spawn_unit(l_38_2, l_38_3, character ~= "random" and character or nil)
  end
end

NetworkGame.on_drop_in_pause_request_received = function(l_39_0, l_39_1, l_39_2, l_39_3)
  print("[NetworkGame:on_drop_in_pause_request_received]", l_39_1, l_39_2, l_39_3)
  local status_changed = false
  local is_playing = BaseNetworkHandler._gamestate_filter.any_ingame_playing[game_state_machine:last_queued_state_name()]
  if l_39_3 and not managers.network:session():closing() then
    status_changed = true
    l_39_0._dropin_pause_info[l_39_1] = l_39_2
    if is_playing then
      managers.menu:show_person_joining(l_39_1, l_39_2)
      do return end
      if l_39_0._dropin_pause_info[l_39_1] then
        status_changed = true
        if l_39_1 == managers.network:session():local_peer():id() then
          l_39_0._dropin_pause_info[l_39_1] = nil
          managers.menu:close_person_joining(l_39_1)
        else
          l_39_0._dropin_pause_info[l_39_1] = nil
          managers.menu:close_person_joining(l_39_1)
        end
      end
    end
  end
  if status_changed and l_39_3 and not managers.network:session():closing() then
    if table.size(l_39_0._dropin_pause_info) == 1 then
      print("DROP-IN PAUSE")
      Application:set_pause(true)
      SoundDevice:set_rtpc("ingame_sound", 0)
    end
    if Network:is_client() then
      managers.network:session():send_to_host("drop_in_pause_confirmation", l_39_1)
      do return end
      if not next(l_39_0._dropin_pause_info) then
        print("DROP-IN UNPAUSE")
        Application:set_pause(false)
        SoundDevice:set_rtpc("ingame_sound", 1)
      else
        print("MAINTAINING DROP-IN UNPAUSE. # dropping peers:", table.size(l_39_0._dropin_pause_info))
      end
    end
  end
end

NetworkGame.chk_create_dropin_dialog = function(l_40_0)
  for peer_id,nickname in pairs(l_40_0._dropin_pause_info) do
    managers.menu:show_person_joining(peer_id, nickname)
    return true
  end
end

NetworkGame.on_dropin_progress_received = function(l_41_0, l_41_1, l_41_2)
  local peer = managers.network:session():peer(l_41_1)
  if peer:synched() then
    return 
  end
  local dropin_member = l_41_0._members[l_41_1]
  local old_drop_in_prog = dropin_member:drop_in_progress()
  if not old_drop_in_prog or old_drop_in_prog < l_41_2 then
    dropin_member:set_drop_in_progress(l_41_2)
    if game_state_machine:last_queued_state_name() == "ingame_waiting_for_players" then
      managers.menu:get_menu("kit_menu").renderer:set_dropin_progress(l_41_1, l_41_2)
    else
      managers.menu:update_person_joining(l_41_1, l_41_2)
    end
  end
end


