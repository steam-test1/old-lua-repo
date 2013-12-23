-- Decompiled using luadec 2.0.1 by sztupy (http://winmo.sztupy.hu)
-- Command line was: F:\SteamLibrary\SteamApps\common\PAYDAY 2\lua\lib\network\base\networkpeer.luac 

if not NetworkPeer then
  NetworkPeer = class()
end
NetworkPeer.PRE_HANDSHAKE_CHK_TIME = 8
NetworkPeer.init = function(l_1_0, l_1_1, l_1_2, l_1_3, l_1_4, l_1_5, l_1_6, l_1_7, l_1_8)
   -- DECOMPILER ERROR: Confused while interpreting a jump as a 'while'

end
l_1_0._name = managers.localization:text("menu_" .. tostring(l_1_1 or "russian"))
l_1_0._rpc = l_1_2
l_1_0._id = l_1_3
l_1_0._user_id = l_1_8
l_1_0._xuid = ""
l_1_0._xnaddr = ""
if l_1_0._rpc then
  Network:set_connection_persistent(l_1_2, true)
  l_1_0._ip = l_1_0._rpc:ip_at_index(0)
  Network:set_throttling_disabled(l_1_0._rpc, true)
end
if l_1_8 and SystemInfo:platform() == Idstring("WIN32") then
  l_1_0._steam_rpc = Network:handshake(l_1_8, nil, "STEAM")
  Network:set_connection_persistent(l_1_0._steam_rpc, true)
  Network:set_throttling_disabled(l_1_0._steam_rpc, true)
end
l_1_0._level = 0
l_1_0._in_lobby = l_1_6
l_1_0._loading = l_1_4
l_1_0._synced = l_1_5
l_1_0._waiting_for_player_ready = false
l_1_0._ip_verified = false
l_1_0._dlcs = {dlc1 = false, dlc2 = false, dlc3 = false, dlc4 = false}
l_1_0:chk_enable_queue()
l_1_0._character = l_1_7
l_1_0._overwriteable_msgs = deep_clone(managers.network.OVERWRITEABLE_MSGS)
l_1_0._overwriteable_queue = {}
l_1_0:_chk_flush_msg_queues()
 -- DECOMPILER ERROR: Confused while interpreting a jump as a 'while'

end
l_1_0._creation_t = TimerManager:wall_running():time()
if l_1_0._rpc and not l_1_0._loading and managers.network.voice_chat.on_member_added and l_1_0._rpc:ip_at_index(0) ~= Network:self("TCP_IP"):ip_at_index(0) then
managers.network.voice_chat:on_member_added(l_1_0)
end
l_1_0._profile = {level = nil, outfit_string = ""}
l_1_0._handshakes = {}
end

NetworkPeer.set_rpc = function(l_2_0, l_2_1)
  l_2_0._rpc = l_2_1
  if l_2_0._rpc then
    Network:set_connection_persistent(l_2_1, true)
    l_2_0._ip = l_2_0._rpc:ip_at_index(0)
    Network:set_throttling_disabled(l_2_0._rpc, true)
    l_2_0:_chk_flush_msg_queues()
    if managers.network.voice_chat.on_member_added then
      managers.network.voice_chat:on_member_added(l_2_0)
    end
  end
end

NetworkPeer.set_steam_rpc = function(l_3_0, l_3_1)
  l_3_0._steam_rpc = l_3_1
  if l_3_0._steam_rpc then
    Network:set_connection_persistent(l_3_0._steam_rpc, true)
    Network:set_throttling_disabled(l_3_0._steam_rpc, true)
  end
end

NetworkPeer.set_dlcs = function(l_4_0, l_4_1)
  local i_dlcs = string.split(l_4_1, " ")
  for _,dlc in ipairs(i_dlcs) do
    l_4_0._dlcs[dlc] = true
  end
end

NetworkPeer.has_dlc = function(l_5_0, l_5_1)
  return l_5_0._dlcs[l_5_1]
end

NetworkPeer.load = function(l_6_0, l_6_1)
  print("[NetworkPeer:load] data:", inspect(l_6_1))
  l_6_0._name = l_6_1.name
  l_6_0._rpc = l_6_1.rpc
  l_6_0._steam_rpc = l_6_1.steam_rpc
  l_6_0._id = l_6_1.id
  if l_6_0._rpc then
    l_6_0._ip = l_6_0._rpc:ip_at_index(0)
  end
  if l_6_0._rpc then
    print("LOAD IP", l_6_0._ip, "self._rpc ip", l_6_0._rpc:ip_at_index(0))
  end
  l_6_0._synced = l_6_1.synced
  l_6_0._character = l_6_1.character
  l_6_0._ip_verified = l_6_1.ip_verified
  l_6_0._creation_t = l_6_1.creation_t
  l_6_0._dlcs = l_6_1.dlcs
  l_6_0._handshakes = l_6_1.handshakes
  l_6_0._loaded = l_6_1.loaded
  l_6_0._loading = l_6_1.loading
  l_6_0._msg_queues = l_6_1.msg_queues
  l_6_0._user_id = l_6_1.user_id
  l_6_0._force_open_lobby = l_6_1.force_open_lobby
  l_6_0._profile = l_6_1.profile
  l_6_0._xuid = l_6_1.xuid
  l_6_0._xnaddr = l_6_1.xnaddr
  l_6_0._join_attempt_identifier = l_6_1.join_attempt_identifier
  l_6_0:chk_enable_queue()
  l_6_0:_chk_flush_msg_queues()
  if l_6_0._rpc and not l_6_0._loading and managers.network.voice_chat.on_member_added then
    managers.network.voice_chat:on_member_added(l_6_0)
  end
  l_6_0._expected_dropin_pause_confirmations = l_6_1.expected_dropin_pause_confirmations
end

NetworkPeer.save = function(l_7_0, l_7_1)
  l_7_1.name = l_7_0._name
  l_7_1.rpc = l_7_0._rpc
  l_7_1.steam_rpc = l_7_0._steam_rpc
  l_7_1.id = l_7_0._id
  if l_7_0._rpc then
    print("SAVE IP", l_7_1.ip, "self._rpc ip", l_7_0._rpc:ip_at_index(0))
  end
  l_7_1.synced = l_7_0._synced
  l_7_1.character = l_7_0._character
  l_7_1.ip_verified = l_7_0._ip_verified
  l_7_1.creation_t = l_7_0._creation_t
  l_7_1.dlcs = l_7_0._dlcs
  l_7_1.handshakes = l_7_0._handshakes
  l_7_1.loaded = l_7_0._loaded
  l_7_1.loading = l_7_0._loading
  l_7_1.expected_dropin_pause_confirmations = l_7_0._expected_dropin_pause_confirmations
  l_7_1.msg_queues = l_7_0._msg_queues
  l_7_1.user_id = l_7_0._user_id
  l_7_1.force_open_lobby = l_7_0._force_open_lobby
  l_7_1.profile = l_7_0._profile
  l_7_1.xuid = l_7_0._xuid
  l_7_1.xnaddr = l_7_0._xnaddr
  l_7_1.join_attempt_identifier = l_7_0._join_attempt_identifier
  print("[NetworkPeer:save]", inspect(l_7_1))
end

NetworkPeer.name = function(l_8_0)
  return l_8_0._name
end

NetworkPeer.ip = function(l_9_0)
  return l_9_0._ip
end

NetworkPeer.id = function(l_10_0)
  return l_10_0._id
end

NetworkPeer.rpc = function(l_11_0)
  return l_11_0._rpc
end

NetworkPeer.steam_rpc = function(l_12_0)
  return l_12_0._steam_rpc
end

NetworkPeer.connection_info = function(l_13_0)
  return l_13_0._name, l_13_0._id, l_13_0._user_id or "", l_13_0._in_lobby, l_13_0._loading, l_13_0._synced, l_13_0._character, "remove", l_13_0._xuid, l_13_0._xnaddr
end

NetworkPeer.synched = function(l_14_0)
  return l_14_0._synced
end

NetworkPeer.loading = function(l_15_0)
  return l_15_0._loading
end

NetworkPeer.loaded = function(l_16_0)
  return l_16_0._loaded
end

NetworkPeer.in_lobby = function(l_17_0)
  return l_17_0._in_lobby
end

NetworkPeer.character = function(l_18_0)
  return l_18_0._character
end

NetworkPeer.used_deployable = function(l_19_0)
  return l_19_0._used_deployable
end

NetworkPeer.set_used_deployable = function(l_20_0, l_20_1)
  l_20_0._used_deployable = l_20_1
end

NetworkPeer.waiting_for_player_ready = function(l_21_0)
  return l_21_0._waiting_for_player_ready
end

NetworkPeer.ip_verified = function(l_22_0)
  return l_22_0._ip_verified
end

NetworkPeer.set_ip_verified = function(l_23_0, l_23_1)
  cat_print("multiplayer_base", "NetworkPeer:set_ip_verified", l_23_1, l_23_0._name, l_23_0._id)
  l_23_0._ip_verified = l_23_1
  l_23_0:_chk_flush_msg_queues()
end

NetworkPeer.set_loading = function(l_24_0, l_24_1)
  cat_print("multiplayer_base", "[NetworkPeer:set_loading]", l_24_1, "was loading", l_24_0._loading, "id", l_24_0._id)
  if l_24_0._loading and not l_24_1 then
    l_24_0._loaded = true
  end
  l_24_0._loading = l_24_1
  if l_24_1 then
    l_24_0:chk_enable_queue()
  end
  l_24_0:_chk_flush_msg_queues()
  if l_24_0 == managers.network:session():local_peer() then
    return 
  end
  managers.network:game():on_peer_loading(l_24_0, l_24_1)
  if l_24_1 then
    l_24_0._default_timeout_check_reset = nil
    if managers.network.voice_chat.on_member_removed then
      managers.network.voice_chat:on_member_removed(l_24_0)
    elseif l_24_0._rpc and managers.network.voice_chat.on_member_added then
      managers.network.voice_chat:on_member_added(l_24_0)
    end
  end
end

NetworkPeer.set_loaded = function(l_25_0, l_25_1)
  l_25_0._loaded = l_25_1
end

NetworkPeer.set_synched = function(l_26_0, l_26_1)
  cat_print("multiplayer_base", "[NetworkPeer:set_synched]", l_26_0._id, l_26_1)
  if l_26_1 and l_26_0.chk_timeout == l_26_0.pre_handshake_chk_timeout then
    l_26_0._default_timeout_check_reset = TimerManager:wall():time() + NetworkPeer.PRE_HANDSHAKE_CHK_TIME
  end
  l_26_0._synced = l_26_1
  if l_26_1 then
    l_26_0._syncing = false
  end
  l_26_0:_chk_flush_msg_queues()
end

NetworkPeer.on_sync_start = function(l_27_0)
  l_27_0._syncing = true
end

NetworkPeer.set_entering_lobby = function(l_28_0, l_28_1)
  l_28_0._entering_lobby = l_28_1
end

NetworkPeer.entering_lobby = function(l_29_0)
  return l_29_0._entering_lobby
end

NetworkPeer.set_in_lobby = function(l_30_0, l_30_1)
  cat_print("multiplayer_base", "NetworkPeer:set_in_lobby", l_30_1, l_30_0._id)
  l_30_0._in_lobby = l_30_1
  if l_30_1 and l_30_0.chk_timeout == l_30_0.pre_handshake_chk_timeout then
    l_30_0._entering_lobby = false
    l_30_0._default_timeout_check_reset = TimerManager:wall():time() + NetworkPeer.PRE_HANDSHAKE_CHK_TIME
  end
  l_30_0:_chk_flush_msg_queues()
end

NetworkPeer.set_in_lobby_soft = function(l_31_0, l_31_1)
  l_31_0._in_lobby = l_31_1
end

NetworkPeer.set_synched_soft = function(l_32_0, l_32_1)
  l_32_0._synced = l_32_1
  l_32_0:_chk_flush_msg_queues()
end

NetworkPeer.set_character = function(l_33_0, l_33_1)
  l_33_0._character = l_33_1
end

NetworkPeer.set_waiting_for_player_ready = function(l_34_0, l_34_1)
  cat_print("multiplayer_base", "NetworkPeer:waiting_for_player_ready", l_34_1, l_34_0._id)
  l_34_0._waiting_for_player_ready = l_34_1
end

NetworkPeer.set_statistics = function(l_35_0, l_35_1, l_35_2, l_35_3, l_35_4, l_35_5)
  l_35_0._statistics = {total_kills = l_35_1, total_specials_kills = l_35_2, total_head_shots = l_35_3, accuracy = l_35_4, downs = l_35_5}
end

NetworkPeer.statistics = function(l_36_0)
  return l_36_0._statistics
end

NetworkPeer.has_statistics = function(l_37_0)
   -- DECOMPILER ERROR: Confused while interpreting a jump as a 'while'

end
return true
end

NetworkPeer.send = function(l_38_0, l_38_1, ...)
  if not l_38_0._ip_verified then
    debug_pause("[NetworkPeer:send] ip unverified:", l_38_1, ...)
    return 
  end
  do
    local rpc = l_38_0._rpc
    rpc[l_38_1](rpc, ...)
  end
   -- DECOMPILER ERROR: Confused about usage of registers for local variables.

end

NetworkPeer._send_queued = function(l_39_0, l_39_1, l_39_2, ...)
  if l_39_0._msg_queues and l_39_0._msg_queues[l_39_1] then
    l_39_0:_push_to_queue(l_39_1, l_39_2, ...)
  do
    else
      local overwrite_data = l_39_0._overwriteable_msgs[l_39_2]
      if overwrite_data then
        overwrite_data.clbk(overwrite_data, l_39_0._overwriteable_queue, l_39_2, ...)
        return 
      end
      l_39_0:send(l_39_2, ...)
    end
     -- DECOMPILER ERROR: Confused about usage of registers for local variables.

  end
end

NetworkPeer.send_after_load = function(l_40_0, ...)
  if not l_40_0._ip_verified then
    Application:error("[NetworkPeer:send_after_load] ip unverified:", ...)
    return 
  end
  l_40_0:_send_queued("load", ...)
   -- DECOMPILER ERROR: Confused about usage of registers for local variables.

end

NetworkPeer.send_queued_sync = function(l_41_0, ...)
  if not l_41_0._ip_verified then
    Application:error("[NetworkPeer:send_queued_sync] ip unverified:", ...)
    return 
  end
  if l_41_0._synced or l_41_0._syncing then
    l_41_0:_send_queued("sync", ...)
     -- DECOMPILER ERROR: Confused about usage of registers for local variables.

  end
end

NetworkPeer._chk_flush_msg_queues = function(l_42_0)
  if not l_42_0._msg_queues or not l_42_0._ip_verified then
    return 
  end
  if not l_42_0._loading then
    l_42_0:_flush_queue("load")
  end
  if l_42_0._synced then
    l_42_0:_flush_queue("sync")
  end
  if not next(l_42_0._msg_queues) then
    l_42_0._msg_queues = nil
  end
end

NetworkPeer.chk_enable_queue = function(l_43_0)
  if l_43_0._loading then
    if not l_43_0._msg_queues then
      l_43_0._msg_queues = {}
    end
    if not l_43_0._msg_queues.load then
      l_43_0._msg_queues.load = {}
    end
  end
  if not l_43_0._synched then
    if not l_43_0._msg_queues then
      l_43_0._msg_queues = {}
    end
    if not l_43_0._msg_queues.sync then
      l_43_0._msg_queues.sync = {}
    end
  end
end

NetworkPeer._push_to_queue = function(l_44_0, l_44_1, ...)
  table.insert(l_44_0._msg_queues[l_44_1], {...})
   -- DECOMPILER ERROR: Confused about usage of registers for local variables.

end

NetworkPeer._flush_queue = function(l_45_0, l_45_1)
  local msg_queue = l_45_0._msg_queues[l_45_1]
  if not msg_queue then
    return 
  end
  l_45_0._msg_queues[l_45_1] = nil
  do
    local ok = nil
    for i,msg in ipairs(msg_queue) do
      ok = true
      for _,param in ipairs(msg) do
        local param_type = type_name(param)
         -- DECOMPILER ERROR: unhandled construct in 'if'

        if param_type == "Unit" and (not alive(param) or param:id() == -1) then
          ok = nil
          do return end
          for (for control),_ in (for generator) do
            if param_type == "Body" and not alive(param) then
              ok = nil
          end
        end
        if ok then
          l_45_0:send(unpack(msg))
        end
      end
    end
     -- Warning: missing end command somewhere! Added here
  end
end

NetworkPeer.chk_timeout = function(l_46_0, l_46_1)
  if not l_46_0._ip_verified then
    return 
  end
  if l_46_0._rpc then
    local silent_time = Network:receive_silent_time(l_46_0._rpc)
    if l_46_1 < silent_time then
      if l_46_0._steam_rpc then
        silent_time = math.min(silent_time, Network:receive_silent_time(l_46_0._steam_rpc))
      end
      if l_46_1 < silent_time then
        print("PINGED OUT", l_46_0._ip, silent_time, l_46_1)
        l_46_0:_ping_timedout()
      else
        l_46_0:_ping_timedout()
      end
    end
  end
end

NetworkPeer.pre_handshake_chk_timeout = function(l_47_0)
  local wall_t = TimerManager:wall():time()
  if l_47_0._default_timeout_check_reset and l_47_0._default_timeout_check_reset < wall_t then
    l_47_0._default_timeout_check_reset = nil
    l_47_0.chk_timeout = nil
  end
end

NetworkPeer.on_lost = function(l_48_0)
  l_48_0._in_lobby = false
  l_48_0._loading = false
  l_48_0._synced = false
  l_48_0._waiting_for_player_ready = false
  l_48_0._msg_queue = nil
end

NetworkPeer._ping_timedout = function(l_49_0)
  managers.network:session():on_peer_lost(l_49_0, l_49_0._id)
end

NetworkPeer.set_ip = function(l_50_0, l_50_1)
  l_50_0._ip = l_50_1
end

NetworkPeer.set_id = function(l_51_0, l_51_1)
  l_51_0._id = l_51_1
end

NetworkPeer.set_name = function(l_52_0, l_52_1)
  l_52_0._name = l_52_1
end

NetworkPeer.destroy = function(l_53_0)
  print("!! NetworkPeer:destroy()", l_53_0:id())
  if l_53_0._rpc then
    Network:reset_connection(l_53_0._rpc)
    if managers.network.voice_chat.on_member_removed then
      managers.network.voice_chat:on_member_removed(l_53_0)
    end
  end
  if l_53_0._steam_rpc then
    Network:reset_connection(l_53_0._steam_rpc)
  end
end

NetworkPeer.on_send = function(l_54_0)
  l_54_0:flush_overwriteable_msgs()
end

NetworkPeer.flush_overwriteable_msgs = function(l_55_0)
  do
    local overwriteable_queue = l_55_0._overwriteable_queue
    if l_55_0._loading or not next(overwriteable_queue) then
      return 
    end
    for msg_name,data in pairs(l_55_0._overwriteable_msgs) do
      data.clbk(data)
    end
    for msg_name,rpc_params in pairs(overwriteable_queue) do
      local ok = true
      for _,param in ipairs(rpc_params) do
        local param_type = type_name(param)
         -- DECOMPILER ERROR: unhandled construct in 'if'

        if param_type == "Unit" and (not alive(param) or param:id() == -1) then
          ok = nil
          do return end
          for (for control),_ in (for generator) do
            if param_type == "Body" and not alive(param) then
              ok = nil
          end
        end
        if ok then
          l_55_0:send(unpack(rpc_params))
          for (for control),msg_name in (for generator) do
          end
          debug_pause("[NetworkPeer:flush_overwriteable_msgs] msg with dead params peer_id:", l_55_0._id, "msg", msg_name, "params", unpack(rpc_params))
        end
        l_55_0._overwriteable_queue = {}
      end
       -- Warning: missing end command somewhere! Added here
    end
     -- Warning: missing end command somewhere! Added here
  end
end

NetworkPeer.set_expecting_drop_in_pause_confirmation = function(l_56_0, l_56_1, l_56_2)
  print(" [NetworkPeer:set_expecting_drop_in_pause_confirmation] peer", l_56_0._id, "dropin_peer", l_56_1, "state", l_56_2)
  if l_56_2 then
    if not l_56_0._expected_dropin_pause_confirmations then
      l_56_0._expected_dropin_pause_confirmations = {}
    end
    l_56_0._expected_dropin_pause_confirmations[l_56_1] = l_56_2
  elseif l_56_0._expected_dropin_pause_confirmations then
    l_56_0._expected_dropin_pause_confirmations[l_56_1] = nil
    if not next(l_56_0._expected_dropin_pause_confirmations) then
      l_56_0._expected_dropin_pause_confirmations = nil
    end
  end
end

NetworkPeer.is_expecting_pause_confirmation = function(l_57_0, l_57_1)
  if l_57_0._expected_dropin_pause_confirmations then
    return l_57_0._expected_dropin_pause_confirmations[l_57_1]
  end
end

NetworkPeer.expected_dropin_pause_confirmations = function(l_58_0)
  return l_58_0._expected_dropin_pause_confirmations
end

NetworkPeer.set_expecting_pause_sequence = function(l_59_0, l_59_1)
  l_59_0._expecting_pause_sequence = l_59_1
end

NetworkPeer.expecting_pause_sequence = function(l_60_0)
  return l_60_0._expecting_pause_sequence
end

NetworkPeer.set_expecting_dropin = function(l_61_0, l_61_1)
  l_61_0._expecting_dropin = l_61_1
end

NetworkPeer.expecting_dropin = function(l_62_0)
  return l_62_0._expecting_dropin
end

NetworkPeer.creation_t = function(l_63_0)
  return l_63_0._creation_t
end

NetworkPeer.set_level = function(l_64_0, l_64_1)
  l_64_0._level = l_64_1
  if managers.hud then
    managers.hud:update_name_label_by_peer(l_64_0)
  end
end

NetworkPeer.level = function(l_65_0)
  return l_65_0._level
end

NetworkPeer.set_profile = function(l_66_0, l_66_1)
  l_66_0._profile.level = l_66_1
end

NetworkPeer.set_outfit_string = function(l_67_0, l_67_1)
  l_67_0._profile.outfit_string = l_67_1
end

NetworkPeer.profile = function(l_68_0, l_68_1)
  if l_68_1 then
    return l_68_0._profile[l_68_1]
  end
  return l_68_0._profile
end

NetworkPeer.character_id = function(l_69_0)
  local outfit_string = l_69_0:profile("outfit_string")
  local data = string.split(outfit_string, " ")
  return data[managers.blackmarket:outfit_string_index("character")]
end

NetworkPeer.mask_id = function(l_70_0)
  local outfit_string = l_70_0:profile("outfit_string")
  local data = string.split(outfit_string, " ")
  return data[managers.blackmarket:outfit_string_index("mask")]
end

NetworkPeer.mask_blueprint = function(l_71_0)
  local outfit_string = l_71_0:profile("outfit_string")
  return managers.blackmarket:mask_blueprint_from_outfit_string(outfit_string)
end

NetworkPeer.armor_id = function(l_72_0)
  local outfit_string = l_72_0:profile("outfit_string")
  local data = string.split(outfit_string, " ")
  return data[managers.blackmarket:outfit_string_index("armor")]
end

NetworkPeer.blackmarket_outfit = function(l_73_0)
  local outfit_string = l_73_0:profile("outfit_string")
  return managers.blackmarket:unpack_outfit_from_string(outfit_string)
end

NetworkPeer.set_handshake_status = function(l_74_0, l_74_1, l_74_2)
  print("[NetworkPeer:set_handshake_status]", l_74_0._id, l_74_1, l_74_2)
  Application:stack_dump()
  l_74_0._handshakes[l_74_1] = l_74_2
end

NetworkPeer.handshakes = function(l_75_0)
  return l_75_0._handshakes
end

NetworkPeer.has_queued_rpcs = function(l_76_0)
  if not l_76_0._msg_queues then
    return 
  end
  for queue_name,queue in pairs(l_76_0._msg_queues) do
    if next(queue) then
      return queue_name
    end
  end
end

NetworkPeer.set_xuid = function(l_77_0, l_77_1)
  l_77_0._xuid = l_77_1
end

NetworkPeer.xuid = function(l_78_0)
  return l_78_0._xuid
end

NetworkPeer.set_xnaddr = function(l_79_0, l_79_1)
  l_79_0._xnaddr = l_79_1
end

NetworkPeer.xnaddr = function(l_80_0)
  return l_80_0._xnaddr
end

NetworkPeer.user_id = function(l_81_0)
  return l_81_0._user_id
end

NetworkPeer.next_steam_p2p_send_t = function(l_82_0)
  return l_82_0._next_steam_p2p_send_t
end

NetworkPeer.set_next_steam_p2p_send_t = function(l_83_0, l_83_1)
  l_83_0._next_steam_p2p_send_t = l_83_1
end

NetworkPeer.set_force_open_lobby_state = function(l_84_0, l_84_1)
  l_84_0._force_open_lobby = l_84_1 or nil
end

NetworkPeer.force_open_lobby_state = function(l_85_0)
  return l_85_0._force_open_lobby
end

NetworkPeer.set_join_attempt_identifier = function(l_86_0, l_86_1)
  l_86_0._join_attempt_identifier = l_86_1
end

NetworkPeer.join_attempt_identifier = function(l_87_0)
  return l_87_0._join_attempt_identifier
end


