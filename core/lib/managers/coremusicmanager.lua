-- Decompiled using luadec 2.0.1 by sztupy (http://winmo.sztupy.hu)
-- Command line was: F:\SteamLibrary\SteamApps\common\PAYDAY 2\lua\core\lib\managers\coremusicmanager.luac 

if not CoreMusicManager then
  CoreMusicManager = class()
end
CoreMusicManager.init = function(l_1_0)
  if not Global.music_manager then
    Global.music_manager = {}
    Global.music_manager.source = SoundDevice:create_source("music")
    Global.music_manager.volume = 0
  end
  l_1_0:_check_music_switch()
  l_1_0._path_list = {}
  l_1_0._path_map = {}
  l_1_0._event_map = {}
  local temp_list = {}
  if Application:editor() and PackageManager:has(Idstring("bnk"), Idstring("soundbanks/music")) then
    local events = SoundDevice:events("soundbanks/music")
  end
  if events then
    for k,v in pairs(events) do
      if not temp_list[v.path] then
        temp_list[v.path] = 1
        table.insert(l_1_0._path_list, v.path)
      end
      l_1_0._path_map[k] = v.path
      if not l_1_0._event_map[v.path] then
        l_1_0._event_map[v.path] = {}
      end
      table.insert(l_1_0._event_map[v.path], k)
    end
  end
  table.sort(l_1_0._path_list)
  for k,v in pairs(l_1_0._event_map) do
    table.sort(v)
  end
  l_1_0._has_music_control = true
  l_1_0._external_media_playing = false
end

CoreMusicManager.init_finalize = function(l_2_0)
  if SystemInfo:platform() == Idstring("X360") then
    l_2_0._has_music_control = XboxLive:app_has_playback_control()
    print("[CoreMusicManager:init_finalize]", l_2_0._has_music_control)
    managers.platform:add_event_callback("media_player_control", callback(l_2_0, l_2_0, "clbk_game_has_music_control"))
    l_2_0:set_volume(Global.music_manager.volume)
  end
  managers.savefile:add_load_sequence_done_callback_handler(callback(l_2_0, l_2_0, "on_load_complete"))
end

CoreMusicManager._check_music_switch = function(l_3_0)
  local switches = tweak_data.levels:get_music_switches()
  if switches then
    local switch = switches[math.random(#switches)]
    print("CoreMusicManager:_check_music_switch()", switch)
    Global.music_manager.source:set_switch("music_randomizer", switch)
  else
     -- Warning: missing end command somewhere! Added here
  end
end

CoreMusicManager.post_event = function(l_4_0, l_4_1)
  if Global.music_manager.current_event ~= l_4_1 then
    Global.music_manager.source:post_event(l_4_1)
    Global.music_manager.current_event = l_4_1
  end
end

CoreMusicManager.stop = function(l_5_0)
  Global.music_manager.source:stop()
  Global.music_manager.current_event = nil
end

CoreMusicManager.music_paths = function(l_6_0)
  return l_6_0._path_list
end

CoreMusicManager.music_events = function(l_7_0, l_7_1)
  return l_7_0._event_map[l_7_1]
end

CoreMusicManager.music_path = function(l_8_0, l_8_1)
  return l_8_0._path_map[l_8_1]
end

CoreMusicManager.set_volume = function(l_9_0, l_9_1)
  Global.music_manager.volume = l_9_1
  if l_9_0._has_music_control then
    SoundDevice:set_rtpc("option_music_volume", l_9_1 * 100)
  else
    SoundDevice:set_rtpc("option_music_volume", 0)
  end
end

CoreMusicManager.clbk_game_has_music_control = function(l_10_0, l_10_1)
  print("[CoreMusicManager:clbk_game_has_music_control]", l_10_1)
  if l_10_1 then
    SoundDevice:set_rtpc("option_music_volume", Global.music_manager.volume * 100)
  else
    SoundDevice:set_rtpc("option_music_volume", 0)
  end
  l_10_0._has_music_control = l_10_1
end

CoreMusicManager.on_load_complete = function(l_11_0)
  l_11_0:set_volume(managers.user:get_setting("music_volume") / 100)
end

CoreMusicManager.has_music_control = function(l_12_0)
  return l_12_0._has_music_control
end

CoreMusicManager.save = function(l_13_0, l_13_1)
  local state = {event = Global.music_manager.current_event}
  l_13_1.CoreMusicManager = state
end

CoreMusicManager.load = function(l_14_0, l_14_1)
  local state = l_14_1.CoreMusicManager
  if state.event then
    l_14_0:post_event(state.event)
  end
end


