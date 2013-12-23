-- Decompiled using luadec 2.0.1 by sztupy (http://winmo.sztupy.hu)
-- Command line was: F:\SteamLibrary\SteamApps\common\PAYDAY 2\lua\lib\network\matchmaking\networkvoicechatsteam.luac 

if not NetworkVoiceChatSTEAM then
  NetworkVoiceChatSTEAM = class()
end
NetworkVoiceChatSTEAM.init = function(l_1_0)
  l_1_0.handler = Steam:voip_handler()
  l_1_0._enabled = false
  l_1_0._users_talking = {}
end

NetworkVoiceChatSTEAM.set_volume = function(l_2_0, l_2_1)
  l_2_0.handler:set_out_volume(l_2_1)
end

NetworkVoiceChatSTEAM.open = function(l_3_0)
  l_3_0._push_to_talk = managers.user:get_setting("push_to_talk")
  if not l_3_0._enabled and managers.user:get_setting("voice_chat") then
    l_3_0.handler:open()
    l_3_0._enabled = true
    if not l_3_0._push_to_talk then
      l_3_0.handler:start_recording()
    end
  end
end

NetworkVoiceChatSTEAM.destroy_voice = function(l_4_0, l_4_1)
  if l_4_0._enabled then
    l_4_0.handler:stop_recording()
    l_4_0.handler:close()
    l_4_0._enabled = false
  end
end

NetworkVoiceChatSTEAM._load_globals = function(l_5_0)
  if Global.steam and Global.steam.voip then
    l_5_0.handler = Global.steam.voip.handler
    Global.steam.voip = nil
  end
end

NetworkVoiceChatSTEAM._save_globals = function(l_6_0)
  if not Global.steam then
    Global.steam = {}
  end
  Global.steam.voip = {}
  Global.steam.voip.handler = l_6_0.handler
end

NetworkVoiceChatSTEAM.enabled = function(l_7_0)
  return managers.user:get_setting("voice_chat")
end

NetworkVoiceChatSTEAM.set_recording = function(l_8_0, l_8_1)
  if not l_8_0._push_to_talk then
    return 
  end
  if l_8_1 then
    l_8_0.handler:start_recording()
  else
    l_8_0.handler:stop_recording()
  end
end

NetworkVoiceChatSTEAM.update = function(l_9_0)
  l_9_0.handler:update()
  local t = Application:time()
  local playing = l_9_0.handler:get_voice_receivers_playing()
  for id,pl in pairs(playing) do
    if not l_9_0._users_talking[id] then
      l_9_0._users_talking[id] = {time = 0}
    end
    if pl then
      l_9_0._users_talking[id].time = t
    end
    local active = t < l_9_0._users_talking[id].time + 0.15000000596046
    if active ~= l_9_0._users_talking[id].active then
      l_9_0._users_talking[id].active = active
      if managers.network:session() then
        local peer = managers.network:session():peer(id)
        if peer then
          managers.menu:set_slot_voice(peer, id, active)
          if managers.hud then
            local crim_data = managers.criminals:character_data_by_peer_id(id)
            if crim_data then
              local mugshot = crim_data.mugshot_id
              managers.hud:set_mugshot_voice(mugshot, active)
            end
          end
        end
      end
    end
  end
end

NetworkVoiceChatSTEAM.on_member_added = function(l_10_0, l_10_1)
  if l_10_1:rpc() then
    l_10_0.handler:add_receiver(l_10_1:id(), l_10_1:rpc())
  end
end

NetworkVoiceChatSTEAM.on_member_removed = function(l_11_0, l_11_1)
  l_11_0.handler:remove_receiver(l_11_1:id())
end

NetworkVoiceChatSTEAM.mute_player = function(l_12_0, l_12_1, l_12_2)
  l_12_0.handler:mute_voice_receiver(l_12_1:id(), l_12_2)
end

NetworkVoiceChatSTEAM.is_muted = function(l_13_0, l_13_1)
  return l_13_0.handler:is_voice_receiver_muted(l_13_1:id())
end


