-- Decompiled using luadec 2.0.1 by sztupy (http://winmo.sztupy.hu)
-- Command line was: F:\SteamLibrary\SteamApps\common\PAYDAY 2\lua\lib\network\matchmaking\networkvoicechatpsn.luac 

if not NetworkVoiceChatPSN then
  NetworkVoiceChatPSN = class()
end
NetworkVoiceChatPSN.init = function(l_1_0)
  l_1_0._started = false
  l_1_0._room_id = nil
  l_1_0._team = 1
  l_1_0._restart_session = nil
  l_1_0:_load_globals()
  l_1_0._muted_players = {}
end

NetworkVoiceChatPSN.check_status_information = function(l_2_0)
end

NetworkVoiceChatPSN.open = function(l_3_0)
end

NetworkVoiceChatPSN.voice_type = function(l_4_0)
  return "voice_psn"
end

NetworkVoiceChatPSN.pause = function(l_5_0)
end

NetworkVoiceChatPSN.resume = function(l_6_0)
end

NetworkVoiceChatPSN.set_volume = function(l_7_0, l_7_1)
  PSNVoice:set_volume(l_7_1)
end

NetworkVoiceChatPSN.init_voice = function(l_8_0)
  if l_8_0._started == false and not l_8_0._starting then
    l_8_0._starting = true
    PSNVoice:assign_callback(function(...)
      self:_callback(...)
       -- DECOMPILER ERROR: Confused about usage of registers for local variables.

      end)
    PSNVoice:init(4, 4, 50, 8000)
    l_8_0:set_volume(managers.user:get_setting("voice_volume"))
  end
end

NetworkVoiceChatPSN.destroy_voice = function(l_9_0, l_9_1)
  if l_9_0._started == true then
    l_9_0._started = false
    if l_9_0._room_id and not l_9_1 then
      l_9_0:close_session()
    end
    PSNVoice:destroy()
    l_9_0._closing = nil
    l_9_0._room_id = nil
    l_9_0._restart_session = nil
    l_9_0._team = 1
  end
end

NetworkVoiceChatPSN.num_peers = function(l_10_0)
  local l = PSNVoice:get_players_info()
  if l then
    local x = 0
    for k,v in pairs(l) do
      if v.joined == 1 then
        x = x + 1
      end
    end
    return #l <= x
  end
  return true
end

NetworkVoiceChatPSN.open_session = function(l_11_0, l_11_1)
  if l_11_0._room_id and l_11_0._room_id == l_11_1 then
    return 
  end
  if l_11_0._restart_session and l_11_0._restart_session == l_11_1 then
    return 
  end
  if l_11_0._closing or l_11_0._joining then
    l_11_0._restart_session = l_11_1
    return 
  end
  if l_11_0._started == false then
    l_11_0._restart_session = l_11_1
    l_11_0:init_voice()
    return 
  end
  if l_11_0._room_id then
    l_11_0._restart_session = l_11_1
    l_11_0:close_session()
    return 
  end
  l_11_0._room_id = l_11_1
  l_11_0._joining = true
  PSNVoice:start_session(l_11_1)
end

NetworkVoiceChatPSN.close_session = function(l_12_0)
  if l_12_0._joining then
    l_12_0._close = true
    return 
  end
  if l_12_0._room_id and not l_12_0._closing then
    l_12_0._closing = true
    if not PSNVoice:stop_session() then
      l_12_0._closing = nil
      l_12_0._room_id = nil
      l_12_0._delay_frame = TimerManager:wall():time() + 1
    elseif not l_12_0._closing then
      l_12_0._restart_session = nil
      l_12_0._delay_frame = nil
    end
  end
end

NetworkVoiceChatPSN.open_channel_to = function(l_13_0, l_13_1, l_13_2)
end

NetworkVoiceChatPSN.close_channel_to = function(l_14_0, l_14_1)
end

NetworkVoiceChatPSN.lost_peer = function(l_15_0, l_15_1)
end

NetworkVoiceChatPSN.close_all = function(l_16_0)
  if l_16_0._room_id then
    l_16_0:close_session()
  end
  l_16_0._room_id = nil
  l_16_0._closing = nil
end

NetworkVoiceChatPSN.set_team = function(l_17_0, l_17_1)
  if l_17_0._room_id then
    PSN:change_team(l_17_0._room_id, PSN:get_local_userid(), l_17_1)
    PSNVoice:set_team_target(l_17_1)
  end
  l_17_0._team = l_17_1
end

NetworkVoiceChatPSN.clear_team = function(l_18_0)
  if l_18_0._room_id and PSN:get_local_userid() then
    PSN:change_team(l_18_0._room_id, PSN:get_local_userid(), 1)
    PSNVoice:set_team_target(1)
    l_18_0._team = 1
  end
end

NetworkVoiceChatPSN.set_drop_in = function(l_19_0, l_19_1)
  l_19_0._drop_in = l_19_1
end

NetworkVoiceChatPSN._load_globals = function(l_20_0)
  if Global.psn and Global.psn.voice then
    l_20_0._started = Global.psn.voice.started
  end
  if PSN:is_online() and Global.psn and Global.psn.voice then
    PSNVoice:assign_callback(function(...)
     -- DECOMPILER ERROR: Confused about usage of registers for local variables.

   end)
    l_20_0._room_id = Global.psn.voice.room
    l_20_0._team = Global.psn.voice.team
    if Global.psn.voice.drop_in then
      l_20_0:open_session(Global.psn.voice.drop_in.room_id)
    end
    if Global.psn.voice.restart then
      l_20_0._restart_session = restart
      l_20_0._delay_frame = TimerManager:wall():time() + 2
    else
      PSNVoice:assign_callback(function(...)
      self:_callback(...)
       -- DECOMPILER ERROR: Confused about usage of registers for local variables.

      end)
      if l_20_0._room_id then
        l_20_0:set_team(l_20_0._team)
      end
    end
    Global.psn.voice = nil
  end
end

NetworkVoiceChatPSN._save_globals = function(l_21_0, l_21_1)
  if l_21_1 == nil then
    return 
  end
  if not Global.psn then
    Global.psn = {}
  end
  local f = function(...)
     -- DECOMPILER ERROR: Confused about usage of registers for local variables.

   end
  PSNVoice:assign_callback(f)
  Global.psn.voice = {}
  Global.psn.voice.started = l_21_0._started
  Global.psn.voice.drop_in = l_21_0._drop_in
  if type(l_21_1) == "boolean" then
    if l_21_1 == true then
      Global.psn.voice.room = l_21_0._room_id
      Global.psn.voice.team = l_21_0._team
    else
      Global.psn.voice.team = 1
    end
  else
    l_21_0:close_all()
    Global.psn.voice.restart = l_21_1
    Global.psn.voice.team = 1
  end
end

NetworkVoiceChatPSN._callback = function(l_22_0, l_22_1)
  if l_22_1 and PSN:get_local_userid() then
    if l_22_1.load_succeeded ~= nil then
      l_22_0._starting = nil
      if l_22_1.load_succeeded then
        l_22_0._started = true
        l_22_0._delay_frame = TimerManager:wall():time() + 1
      end
      return 
    end
    if l_22_1.join_succeeded ~= nil then
      l_22_0._joining = nil
      if l_22_1.join_succeeded == false then
        l_22_0._room_id = nil
      else
        l_22_0:set_team(l_22_0._team)
      end
      if l_22_0._restart_session then
        l_22_0._delay_frame = TimerManager:wall():time() + 1
      end
      if l_22_0._close then
        l_22_0._close = nil
        l_22_0:close_session()
      end
    end
    if l_22_1.leave_succeeded ~= nil then
      l_22_0._closing = nil
      l_22_0._room_id = nil
      if l_22_0._restart_session then
        l_22_0._delay_frame = TimerManager:wall():time() + 1
      end
    end
    if l_22_1.unload_succeeded ~= nil then
      local f = function(...)
       -- DECOMPILER ERROR: Confused about usage of registers for local variables.

      end
      PSNVoice:assign_callback(f)
    end
  end
end

NetworkVoiceChatPSN.update = function(l_23_0)
  if l_23_0._delay_frame and l_23_0._delay_frame < TimerManager:wall():time() then
    l_23_0._delay_frame = nil
    if l_23_0._restart_session then
      PSNVoice:assign_callback(function(...)
      self:_callback(...)
       -- DECOMPILER ERROR: Confused about usage of registers for local variables.

      end)
      local r = l_23_0._restart_session
      l_23_0._restart_session = nil
      l_23_0:open_session(r)
    end
  end
end

NetworkVoiceChatPSN.psn_session_destroyed = function(l_24_0, l_24_1)
  if l_24_0._room_id and l_24_0._room_id == l_24_1 then
    l_24_0._room_id = nil
    l_24_0._closing = nil
  end
end

NetworkVoiceChatPSN._get_peer_user_id = function(l_25_0, l_25_1)
  if not l_25_0._room_id then
    return 
  end
  local members = PSN:get_info_session(l_25_0._room_id).memberlist
  local name = l_25_1:name()
  for i,member in ipairs(members) do
    if tostring(member.user_id) == name then
      return member.user_id
    end
  end
end

NetworkVoiceChatPSN.mute_player = function(l_26_0, l_26_1, l_26_2)
  local id = l_26_0:_get_peer_user_id(l_26_1)
  if id then
    l_26_0._muted_players[l_26_1:name()] = l_26_2
    PSNVoice:mute_player(l_26_2, id)
  end
end

NetworkVoiceChatPSN.is_muted = function(l_27_0, l_27_1)
  return l_27_0._muted_players[l_27_1:name()] or false
end


