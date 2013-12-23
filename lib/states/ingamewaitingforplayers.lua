-- Decompiled using luadec 2.0.1 by sztupy (http://winmo.sztupy.hu)
-- Command line was: F:\SteamLibrary\SteamApps\common\PAYDAY 2\lua\lib\states\ingamewaitingforplayers.luac 

core:import("CoreUnit")
require("lib/states/GameState")
if not IngameWaitingForPlayersState then
  IngameWaitingForPlayersState = class(GameState)
end
IngameWaitingForPlayersState.GUI_SAFERECT = Idstring("guis/waiting_saferect")
IngameWaitingForPlayersState.GUI_FULLSCREEN = Idstring("guis/waiting_fullscreen")
IngameWaitingForPlayersState.PLAYER_HUD = Idstring("guis/player_hud")
IngameWaitingForPlayersState.PLAYER_INFO_HUD = Idstring("guis/player_info_hud")
IngameWaitingForPlayersState.PLAYER_INFO_HUD_FULLSCREEN = Idstring("guis/player_info_hud_fullscreen")
IngameWaitingForPlayersState.PLAYER_DOWNED_HUD = Idstring("guis/player_downed_hud")
IngameWaitingForPlayersState.LEVEL_INTRO_GUI = Idstring("guis/level_intro")
IngameWaitingForPlayersState.init = function(l_1_0, l_1_1)
  GameState.init(l_1_0, "ingame_waiting_for_players", l_1_1)
  l_1_0._intro_source = SoundDevice:create_source("intro_source")
  l_1_0._start_cb = callback(l_1_0, l_1_0, "_start")
  l_1_0._skip_cb = callback(l_1_0, l_1_0, "_skip")
  l_1_0._controller = nil
end

IngameWaitingForPlayersState.setup_controller = function(l_2_0)
  if not l_2_0._controller then
    l_2_0._controller = managers.controller:create_controller("waiting_for_players", managers.controller:get_default_wrapper_index(), false)
  end
  l_2_0._controller:set_enabled(true)
end

IngameWaitingForPlayersState.set_controller_enabled = function(l_3_0, l_3_1)
  if l_3_0._controller then
     -- Warning: missing end command somewhere! Added here
  end
end

IngameWaitingForPlayersState._skip = function(l_4_0)
  if not Network:is_server() then
    return 
  end
  if not l_4_0._audio_started then
    return 
  end
  if l_4_0._skipped then
    return 
  end
  l_4_0:sync_skip()
  managers.network:session():send_to_peers_synched("sync_waiting_for_player_skip")
end

IngameWaitingForPlayersState.sync_skip = function(l_5_0)
  print("SKIP")
  l_5_0._skipped = true
  managers.briefing:stop_event(true)
  l_5_0:_start_delay()
end

IngameWaitingForPlayersState._start = function(l_6_0)
  if not Network:is_server() then
    return 
  end
  local variant = managers.groupai:state():blackscreen_variant() or 0
  l_6_0:sync_start(variant)
  managers.network:session():send_to_peers_synched("sync_waiting_for_player_start", variant)
end

IngameWaitingForPlayersState.sync_start = function(l_7_0, l_7_1)
  l_7_0._kit_menu.renderer:set_all_items_enabled(false)
  l_7_0._briefing_start_t = nil
  managers.briefing:stop_event()
  managers.music:post_event(tweak_data.levels:get_music_event("intro"))
  l_7_0._fade_out_id = managers.overlay_effect:play_effect(tweak_data.overlay_effects.fade_out_permanent)
  if Global.level_data.level_id then
    local level_data = tweak_data.levels[Global.level_data.level_id]
  end
  if level_data then
    l_7_0._intro_text_id = level_data.intro_text_id
  end
  if level_data and (l_7_1 ~= 0 or not level_data.intro_event) then
    l_7_0._intro_event = level_data.intro_event[l_7_1]
  end
  l_7_0._blackscreen_started = true
  managers.menu_component:close_asset_mission_briefing_gui()
  if l_7_0._intro_event then
    l_7_0._delay_audio_t = Application:time() + 1
  else
    l_7_0:_start_delay()
  end
end

IngameWaitingForPlayersState.blackscreen_started = function(l_8_0)
  return l_8_0._blackscreen_started or false
end

IngameWaitingForPlayersState._start_audio = function(l_9_0)
  managers.hud:show(l_9_0.LEVEL_INTRO_GUI)
  managers.hud:set_blackscreen_mid_text(l_9_0._intro_text_id and managers.localization:text(l_9_0._intro_text_id) or "")
  managers.hud:set_blackscreen_job_data()
  managers.hud:blackscreen_fade_in_mid_text()
  l_9_0._intro_cue_index = 1
  l_9_0._audio_started = true
  managers.menu:close_menu("kit_menu")
  local event_started = nil
  local job_data = managers.job:current_job_data()
  if job_data and managers.job:current_job_id() == "safehouse" and Global.mission_manager.saved_job_values.playedSafeHouseBefore then
    do return end
  end
  event_started = managers.briefing:post_event(l_9_0._intro_event, {show_subtitle = true, listener = {clbk = callback(l_9_0, l_9_0, "_audio_done"), end_of_event = true}})
  if not event_started then
    print("failed to start audio, or played safehouse before")
    if Network:is_server() then
      l_9_0:_start_delay()
    end
  end
end

IngameWaitingForPlayersState._start_delay = function(l_10_0)
  if l_10_0._delay_start_t then
    return 
  end
  l_10_0._delay_start_t = Application:time() + 1
end

IngameWaitingForPlayersState._audio_done = function(l_11_0, l_11_1, l_11_2, l_11_3)
  l_11_0:_start_delay()
end

IngameWaitingForPlayersState._briefing_callback = function(l_12_0, l_12_1, l_12_2, l_12_3)
  print("[IngameWaitingForPlayersState]", "event_type", l_12_1, "label", l_12_2, "cookie", l_12_3)
  managers.menu_component:set_mission_briefing_description(l_12_2)
end

IngameWaitingForPlayersState.update = function(l_13_0, l_13_1, l_13_2)
  if l_13_0._camera_data.next_t < l_13_1 then
    l_13_0:_next_camera()
  end
  if l_13_0._briefing_start_t and l_13_0._briefing_start_t < l_13_1 then
    l_13_0._briefing_start_t = nil
    if managers.job:has_active_job() then
      local stage_data = managers.job:current_stage_data()
      local level_data = managers.job:current_level_data()
      if not stage_data.briefing_dialog then
        local briefing_dialog = level_data.briefing_dialog
      end
      if type(briefing_dialog) == "table" then
        briefing_dialog = briefing_dialog[math.random(#briefing_dialog)]
      end
      local job_data = managers.job:current_job_data()
      if job_data and managers.job:current_job_id() == "safehouse" and Global.mission_manager.saved_job_values.playedSafeHouseBefore then
        do return end
      end
      managers.briefing:post_event(briefing_dialog, {show_subtitle = false, listener = {clbk = callback(l_13_0, l_13_0, "_briefing_callback"), marker = false}})
    end
  end
  if l_13_0._delay_audio_t and l_13_0._delay_audio_t < l_13_1 then
    l_13_0._delay_audio_t = nil
    l_13_0:_start_audio()
  end
  if l_13_0._delay_start_t and l_13_0._delay_start_t < l_13_1 then
    l_13_0._delay_start_t = nil
    managers.hud:blackscreen_fade_out_mid_text()
    if Network:is_server() then
      l_13_0._delay_spawn_t = Application:time() + 1
    end
    FadeoutGuiObject:new(tweak_data.overlay_effects.level_fade_in)
  end
  if l_13_0._delay_spawn_t and l_13_0._delay_spawn_t < l_13_1 then
    l_13_0._delay_spawn_t = nil
    if managers.network:game() then
      managers.network:game():spawn_players()
    end
  end
  local in_foucs = managers.menu:active_menu() == l_13_0._kit_menu
  local in_focus = (not managers.menu:active_menu() and Network:is_server())
  if in_focus and l_13_0._audio_started and not l_13_0._skipped then
    if l_13_0._controller then
      local btn_skip_press = l_13_0._controller:get_input_bool("continue")
      if btn_skip_press and not l_13_0._skip_data then
        l_13_0._skip_data = {total = 1, current = 0}
      elseif not btn_skip_press and l_13_0._skip_data then
        l_13_0._skip_data = nil
        managers.hud:set_blackscreen_skip_circle(0, 1)
      end
    end
    if l_13_0._skip_data then
      l_13_0._skip_data.current = l_13_0._skip_data.current + l_13_2
      managers.hud:set_blackscreen_skip_circle(l_13_0._skip_data.current, l_13_0._skip_data.total)
      if l_13_0._skip_data.total < l_13_0._skip_data.current then
        managers.hud:blackscreen_skip_circle_done()
        l_13_0:_skip()
        do return end
        if l_13_0._skip_data then
          l_13_0._skip_data = nil
          managers.hud:set_blackscreen_skip_circle(0, 1)
        end
      end
    end
  end
end

IngameWaitingForPlayersState.at_enter = function(l_14_0)
  l_14_0._started_from_beginning = true
  l_14_0:setup_controller()
  l_14_0._sound_listener = SoundDevice:create_listener("lobby_menu")
  l_14_0._sound_listener:set_position(Vector3(0, -50000, 0))
  l_14_0._sound_listener:activate(true)
  managers.hud:load_hud(l_14_0.GUI_SAFERECT, false, true, true, {})
  managers.hud:show(l_14_0.GUI_SAFERECT)
  managers.hud:load_hud(l_14_0.GUI_FULLSCREEN, false, true, false, {}, nil, nil, true)
  managers.hud:show(l_14_0.GUI_FULLSCREEN)
  if not managers.hud:exists(l_14_0.PLAYER_HUD) then
    managers.hud:load_hud(l_14_0.PLAYER_HUD, false, false, true, {})
  end
  if not managers.hud:exists(l_14_0.PLAYER_INFO_HUD_FULLSCREEN) then
    managers.hud:load_hud(l_14_0.PLAYER_INFO_HUD_FULLSCREEN, false, false, false, {})
  end
  if not managers.hud:exists(l_14_0.PLAYER_INFO_HUD) then
    managers.hud:load_hud(l_14_0.PLAYER_INFO_HUD, false, false, true, {})
  end
  if not managers.hud:exists(l_14_0.PLAYER_DOWNED_HUD) then
    managers.hud:load_hud(l_14_0.PLAYER_DOWNED_HUD, false, false, true, {})
  end
  if not managers.hud:exists(l_14_0.LEVEL_INTRO_GUI) then
    managers.hud:load_hud(l_14_0.LEVEL_INTRO_GUI, false, false, true, {})
  end
  managers.menu:close_menu()
  managers.menu:open_menu("kit_menu")
  l_14_0._kit_menu = managers.menu:get_menu("kit_menu")
  l_14_0:_get_cameras()
  l_14_0._cam_unit = CoreUnit.safe_spawn_unit("units/gui/background_camera_01/waiting_camera_01", Vector3(), Rotation())
  l_14_0._camera_data = {}
  l_14_0._camera_data.index = 0
  l_14_0:_next_camera()
  l_14_0._briefing_start_t = Application:time() + 2
  if managers.network:session():is_client() and managers.network:session():server_peer() then
    Global.local_member:sync_lobby_data(managers.network:session():server_peer())
    Global.local_member:sync_data(managers.network:session():server_peer())
  end
  if managers.job:interupt_stage() then
    managers.menu_component:post_event("escape_menu")
  end
end

IngameWaitingForPlayersState.start_game_intro = function(l_15_0)
  if l_15_0._starting_game_intro then
    return 
  end
  l_15_0._starting_game_intro = true
  l_15_0:_start()
end

IngameWaitingForPlayersState.set_dropin = function(l_16_0, l_16_1)
  l_16_0._started_from_beginning = false
  print("Joining as " .. l_16_1)
end

IngameWaitingForPlayersState.at_exit = function(l_17_0)
  print("[IngameWaitingForPlayersState:at_exit()]")
  managers.briefing:stop_event(true)
  managers.assets:clear_asset_textures()
  managers.menu:close_menu("kit_menu")
  managers.statistics:start_session({from_beginning = l_17_0._started_from_beginning, drop_in = not l_17_0._started_from_beginning})
  managers.hud:hide(l_17_0.GUI_SAFERECT)
  managers.hud:hide(l_17_0.GUI_FULLSCREEN)
  World:delete_unit(l_17_0._cam_unit)
  managers.menu_component:hide_game_chat_gui()
  managers.menu_component:close_mission_briefing_gui()
  managers.overlay_effect:play_effect(tweak_data.overlay_effects.level_fade_in)
  managers.overlay_effect:stop_effect(l_17_0._fade_out_id)
  if l_17_0._sound_listener then
    l_17_0._sound_listener:delete()
    l_17_0._sound_listener = nil
  end
  managers.hud:hide(l_17_0.LEVEL_INTRO_GUI)
  if l_17_0._started_from_beginning then
    managers.music:post_event(tweak_data.levels:get_music_event("intro"))
  end
  managers.platform:set_presence("Playing")
  managers.platform:set_rich_presence(Global.game_settings.single_player and "SPPlaying" or "MPPlaying")
  managers.game_play_central:start_heist_timer()
end

IngameWaitingForPlayersState._get_cameras = function(l_18_0)
  l_18_0._cameras = {}
  for _,unit in ipairs(managers.helper_unit:get_units_by_type("waiting_camera")) do
    table.insert(l_18_0._cameras, {pos = unit:position(), rot = unit:rotation(), nr = math.random(20)})
  end
  if #l_18_0._cameras == 0 then
    table.insert(l_18_0._cameras, {pos = Vector3(-196, -496, 851), rot = Rotation(90, 0, 0), nr = math.random(20)})
    table.insert(l_18_0._cameras, {pos = Vector3(-1897, -349, 365), rot = Rotation(0, 0, 0), nr = math.random(20)})
    table.insert(l_18_0._cameras, {pos = Vector3(-2593, 552, 386), rot = Rotation(-90, 0, 0), nr = math.random(20)})
  end
end

IngameWaitingForPlayersState._next_camera = function(l_19_0)
  l_19_0._camera_data.next_t = Application:time() + 8 + math.rand(4)
  l_19_0._camera_data.index = l_19_0._camera_data.index + 1
  if #l_19_0._cameras < l_19_0._camera_data.index then
    l_19_0._camera_data.index = 1
  end
  l_19_0._cam_unit:set_position(l_19_0._cameras[l_19_0._camera_data.index].pos)
  l_19_0._cam_unit:set_rotation(l_19_0._cameras[l_19_0._camera_data.index].rot)
  l_19_0._cam_unit:camera():start(math.rand(30))
end

IngameWaitingForPlayersState.on_server_left = function(l_20_0)
  IngameCleanState.on_server_left(l_20_0)
end

IngameWaitingForPlayersState.on_kicked = function(l_21_0)
  IngameCleanState.on_kicked(l_21_0)
end

IngameWaitingForPlayersState.on_disconnected = function(l_22_0)
  IngameCleanState.on_disconnected(l_22_0)
end


