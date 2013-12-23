-- Decompiled using luadec 2.0.1 by sztupy (http://winmo.sztupy.hu)
-- Command line was: F:\SteamLibrary\SteamApps\common\PAYDAY 2\lua\lib\network\base\session_states\hoststateingame.luac 

if not HostStateInGame then
  HostStateInGame = class(HostStateBase)
end
HostStateInGame.enter = function(l_1_0, l_1_1, l_1_2)
  print("[HostStateInGame:enter]", l_1_1, inspect(l_1_2))
end

HostStateInGame.on_join_request_received = function(l_2_0, l_2_1, l_2_2, l_2_3, l_2_4, l_2_5, l_2_6, l_2_7, l_2_8, l_2_9)
  print("[HostStateInGame:on_join_request_received]", l_2_1, l_2_2, l_2_3, l_2_4, l_2_5, l_2_6, l_2_7, l_2_8, l_2_9:ip_at_index(0))
  local my_user_id = l_2_1.local_peer:user_id() or ""
  if l_2_0:_has_peer_left_PSN(l_2_2) then
    print("this CLIENT has left us from PSN, ignore his request", l_2_2)
    return 
  else
    if not l_2_0:_is_in_server_state() then
      l_2_0:_send_request_denied(l_2_9, 0, my_user_id)
      return 
    else
      if not NetworkManager.DROPIN_ENABLED or not Global.game_settings.drop_in_allowed then
        l_2_0:_send_request_denied(l_2_9, 3, my_user_id)
        return 
      else
        if managers.groupai and not managers.groupai:state():chk_allow_drop_in() then
          l_2_0:_send_request_denied(l_2_9, 0, my_user_id)
          return 
        else
          if l_2_0:_is_kicked(l_2_1, l_2_2, l_2_9) then
            print("YOU ARE IN MY KICKED LIST", l_2_2)
            l_2_0:_send_request_denied(l_2_9, 2, my_user_id)
            return 
          else
            if l_2_6 < Global.game_settings.reputation_permission then
              l_2_0:_send_request_denied(l_2_9, 6, my_user_id)
              return 
            elseif l_2_7 ~= -1 and l_2_7 ~= managers.network.matchmake.GAMEVERSION then
              l_2_0:_send_request_denied(l_2_9, 7, my_user_id)
              return 
            elseif l_2_1.wants_to_load_level then
              l_2_0:_send_request_denied(l_2_9, 0, my_user_id)
              return 
            end
          end
        end
      end
    end
  end
  local old_peer = l_2_1.session:chk_peer_already_in(l_2_9)
   -- DECOMPILER ERROR: unhandled construct in 'if'

  if old_peer and l_2_8 ~= old_peer:join_attempt_identifier() then
    l_2_1.session:remove_peer(old_peer, old_peer:id(), "lost")
    l_2_0:_send_request_denied(l_2_9, 0, my_user_id)
  end
  return 
  if table.size(l_2_1.peers) >= 3 then
    print("server is full")
    l_2_0:_send_request_denied(l_2_9, 5, my_user_id)
    return 
  end
  local character = managers.network:game():check_peer_preferred_character(l_2_3)
  local xnaddr = ""
  if SystemInfo:platform() == Idstring("X360") then
    xnaddr = managers.network.matchmake:external_address(l_2_9)
  end
  local new_peer_id, new_peer = nil, nil
  new_peer_id, new_peer = l_2_1.session:add_peer(l_2_2, nil, false, false, false, nil, character, l_2_9:ip_at_index(0), l_2_5, xnaddr)
  if not new_peer_id then
    print("there was no clean peer_id")
    l_2_0:_send_request_denied(l_2_9, 0, my_user_id)
    return 
  end
  new_peer:set_dlcs(l_2_4)
  new_peer:set_xuid(l_2_5)
  new_peer:set_join_attempt_identifier(l_2_8)
  local new_peer_rpc = nil
  if managers.network:protocol_type() == "TCP_IP" then
    new_peer_rpc = managers.network:session():resolve_new_peer_rpc(new_peer, l_2_9)
  else
    new_peer_rpc = l_2_9
  end
  new_peer:set_rpc(new_peer_rpc)
  new_peer:set_ip_verified(true)
  Network:add_co_client(new_peer_rpc)
  local level_index = tweak_data.levels:get_index_from_level_id(Global.game_settings.level_id)
  local difficulty_index = tweak_data:difficulty_to_index(Global.game_settings.difficulty)
  local job_id_index = 0
  local job_stage = 0
  local alternative_job_stage = 0
  local interupt_job_stage_level_index = 0
  if managers.job:has_active_job() then
    job_id_index = tweak_data.narrative:get_index_from_job_id(managers.job:current_job_id())
    job_stage = managers.job:current_stage()
    alternative_job_stage = managers.job:alternative_stage() or 0
    local interupt_stage_level = managers.job:interupt_stage()
    interupt_job_stage_level_index = interupt_stage_level and tweak_data.levels:get_index_from_level_id(interupt_stage_level) or 0
  end
  local server_xuid = SystemInfo:platform() == Idstring("X360") and managers.network.account:player_id() or ""
  new_peer:send("join_request_reply", 1, new_peer_id, character, level_index, difficulty_index, 2, l_2_1.local_peer:character(), my_user_id, Global.game_settings.mission, job_id_index, job_stage, alternative_job_stage, interupt_job_stage_level_index, server_xuid)
  new_peer:send("set_loading_state", false)
  if SystemInfo:platform() == Idstring("X360") then
    new_peer:send("request_player_name_reply", managers.network:session():local_peer():name())
  end
  l_2_0:on_handshake_confirmation(l_2_1, new_peer, 1)
end

HostStateInGame.on_peer_finished_loading = function(l_3_0, l_3_1, l_3_2)
  l_3_0:_introduce_new_peer_to_old_peers(l_3_1, l_3_2, false, l_3_2:name(), l_3_2:character(), "remove", l_3_2:xuid(), l_3_2:xnaddr())
  l_3_0:_introduce_old_peers_to_new_peer(l_3_1, l_3_2)
  if l_3_1.game_started then
    l_3_2:send_after_load("set_dropin")
  end
end

HostStateInGame.is_joinable = function(l_4_0, l_4_1)
  return not l_4_1.wants_to_load_level
end


