-- Decompiled using luadec 2.0.1 by sztupy (http://winmo.sztupy.hu)
-- Command line was: F:\SteamLibrary\SteamApps\common\PAYDAY 2\lua\lib\states\ingameaccesscamera.luac 

require("lib/states/GameState")
if not IngameAccessCamera then
  IngameAccessCamera = class(IngamePlayerBaseState)
end
IngameAccessCamera.GUI_SAFERECT = Idstring("guis/access_camera_saferect")
IngameAccessCamera.GUI_FULLSCREEN = Idstring("guis/access_camera_fullrect")
IngameAccessCamera.init = function(l_1_0, l_1_1)
  IngameAccessCamera.super.init(l_1_0, "ingame_access_camera", l_1_1)
end

IngameAccessCamera._setup_controller = function(l_2_0)
  l_2_0._controller = managers.controller:create_controller("ingame_access_camera", managers.controller:get_default_wrapper_index(), false)
  l_2_0._leave_cb = callback(l_2_0, l_2_0, "cb_leave")
  l_2_0._prev_camera_cb = callback(l_2_0, l_2_0, "_prev_camera")
  l_2_0._next_camera_cb = callback(l_2_0, l_2_0, "_next_camera")
  l_2_0._controller:add_trigger("jump", l_2_0._leave_cb)
  l_2_0._controller:add_trigger("primary_attack", l_2_0._prev_camera_cb)
  l_2_0._controller:add_trigger("secondary_attack", l_2_0._next_camera_cb)
  l_2_0._controller:set_enabled(true)
end

IngameAccessCamera._clear_controller = function(l_3_0)
  if l_3_0._controller then
    l_3_0._controller:remove_trigger("jump", l_3_0._leave_cb)
    l_3_0._controller:remove_trigger("primary_attack", l_3_0._prev_camera_cb)
    l_3_0._controller:remove_trigger("secondary_attack", l_3_0._next_camera_cb)
    l_3_0._controller:set_enabled(false)
    l_3_0._controller:destroy()
    l_3_0._controller = nil
  end
end

IngameAccessCamera.set_controller_enabled = function(l_4_0, l_4_1)
  if l_4_0._controller then
    l_4_0._controller:set_enabled(l_4_1)
  end
end

IngameAccessCamera.cb_leave = function(l_5_0)
  game_state_machine:change_state_by_name(l_5_0._old_state)
end

IngameAccessCamera._get_cameras = function(l_6_0)
  l_6_0._cameras = {}
  for _,script in pairs(managers.mission:scripts()) do
    local access_cameras = script:element_group("ElementAccessCamera")
    if access_cameras then
      for _,access_camera in ipairs(access_cameras) do
        table.insert(l_6_0._cameras, {access_camera = access_camera})
      end
    end
  end
end

IngameAccessCamera._next_index = function(l_7_0)
  l_7_0._camera_data.index = l_7_0._camera_data.index + 1
  if #l_7_0._cameras < l_7_0._camera_data.index then
    l_7_0._camera_data.index = 1
  end
  if not l_7_0._cameras[l_7_0._camera_data.index].access_camera:enabled() then
    l_7_0:_next_index()
  end
end

IngameAccessCamera._prev_index = function(l_8_0)
  l_8_0._camera_data.index = l_8_0._camera_data.index - 1
  if l_8_0._camera_data.index < 1 then
    l_8_0._camera_data.index = #l_8_0._cameras
  end
  if not l_8_0._cameras[l_8_0._camera_data.index].access_camera:enabled() then
    l_8_0:_prev_index()
  end
end

IngameAccessCamera._prev_camera = function(l_9_0)
  if l_9_0._no_feeds then
    return 
  end
  l_9_0:_prev_index()
  l_9_0:_show_camera()
end

IngameAccessCamera._next_camera = function(l_10_0)
  if l_10_0._no_feeds then
    return 
  end
  l_10_0:_next_index()
  l_10_0:_show_camera()
end

IngameAccessCamera.on_destroyed = function(l_11_0)
  local access_camera = l_11_0._cameras[l_11_0._camera_data.index].access_camera
  managers.hud:set_access_camera_destroyed(access_camera:value("destroyed"))
end

IngameAccessCamera._show_camera = function(l_12_0)
  l_12_0._sound_source:post_event("camera_monitor_change")
  if l_12_0._last_access_camera then
    l_12_0._last_access_camera:remove_trigger("IngameAccessCamera", "destroyed")
  end
  local access_camera = l_12_0._cameras[l_12_0._camera_data.index].access_camera
  access_camera:add_trigger("IngameAccessCamera", "destroyed", callback(l_12_0, l_12_0, "on_destroyed"))
  l_12_0._last_access_camera = access_camera
  access_camera:trigger_accessed(managers.player:player_unit())
  l_12_0._cam_unit:set_position(access_camera:camera_position())
  l_12_0._cam_unit:camera():set_rotation(access_camera:value("rotation"))
  l_12_0._cam_unit:camera():start(math.rand(30))
  l_12_0._yaw = 0
  l_12_0._pitch = 0
  l_12_0._target_yaw = 0
  l_12_0._target_pitch = 0
  l_12_0._yaw_limit = access_camera:value("yaw_limit") or 25
  l_12_0._pitch_limit = access_camera:value("pitch_limit") or 25
  managers.hud:set_access_camera_destroyed(access_camera:value("destroyed"))
  local text_id = access_camera:value("text_id") ~= "debug_none" and access_camera:value("text_id") or "hud_cam_access_camera_test_generated"
  local number = (l_12_0._camera_data.index < 10 and "0" or "") .. l_12_0._camera_data.index
  managers.hud:set_access_camera_name(managers.localization:text(text_id, {NUMBER = number}))
end

IngameAccessCamera.update = function(l_13_0, l_13_1, l_13_2)
  if l_13_0._no_feeds then
    return 
  end
  l_13_1 = managers.player:player_timer():time()
  l_13_2 = managers.player:player_timer():delta_time()
  local look_d = l_13_0._controller:get_input_axis("look")
  local zoomed_value = l_13_0._cam_unit:camera():zoomed_value()
  l_13_0._target_yaw = l_13_0._target_yaw - look_d.x * zoomed_value
  if l_13_0._yaw_limit ~= -1 then
    l_13_0._target_yaw = math.clamp(l_13_0._target_yaw, -l_13_0._yaw_limit, l_13_0._yaw_limit)
  end
  l_13_0._target_pitch = l_13_0._target_pitch + look_d.y * zoomed_value
  if l_13_0._pitch_limit ~= -1 then
    l_13_0._target_pitch = math.clamp(l_13_0._target_pitch + look_d.y * zoomed_value, -l_13_0._pitch_limit, l_13_0._pitch_limit)
  end
  l_13_0._yaw = math.step(l_13_0._yaw, l_13_0._target_yaw, l_13_2 * 10)
  l_13_0._pitch = math.step(l_13_0._pitch, l_13_0._target_pitch, l_13_2 * 10)
  l_13_0._cam_unit:camera():set_offset_rotation(l_13_0._yaw, l_13_0._pitch)
  local move_d = l_13_0._controller:get_input_axis("move")
  l_13_0._cam_unit:camera():modify_fov(-move_d.y * (l_13_2 * 12))
  if l_13_0._do_show_camera then
    l_13_0._do_show_camera = false
    local access_camera = l_13_0._cameras[l_13_0._camera_data.index].access_camera
    managers.hud:set_access_camera_destroyed(access_camera:value("destroyed"))
  end
  local units = World:find_units_quick("all", 3, 16, 21, managers.slot:get_mask("enemies"))
  local amount = 0
  for i,unit in ipairs(units) do
    if World:in_view_with_options(unit:movement():m_head_pos(), 0, 0, 4000) then
      local ray = nil
      if l_13_0._last_access_camera and l_13_0._last_access_camera:has_camera_unit() then
        ray = l_13_0._cam_unit:raycast("ray", unit:movement():m_head_pos(), l_13_0._cam_unit:position(), "slot_mask", managers.slot:get_mask("world_geometry"), "ignore_unit", l_13_0._last_access_camera:camera_unit(), "report")
      else
        ray = l_13_0._cam_unit:raycast("ray", unit:movement():m_head_pos(), l_13_0._cam_unit:position(), "slot_mask", managers.slot:get_mask("world_geometry"), "report")
      end
      if not ray then
        amount = amount + 1
        managers.hud:access_camera_track(amount, l_13_0._cam_unit:camera()._camera, unit:movement():m_head_pos())
        if managers.player:upgrade_value("player", "sec_camera_highlight", false) and managers.groupai:state():whisper_mode() and tweak_data.character[unit:base()._tweak_table].silent_priority_shout then
          l_13_0:add_enemy_contour(unit)
        end
      end
    end
  end
  managers.hud:access_camera_track_max_amount(amount)
end

IngameAccessCamera.add_enemy_contour = function(l_14_0, l_14_1)
  if l_14_0._enemy_contours[l_14_1:key()] and Application:time() < l_14_0._enemy_contours[l_14_1:key()] then
    return 
  end
  l_14_0._enemy_contours[l_14_1:key()] = Application:time() + 9
  managers.game_play_central:add_enemy_contour(l_14_1, false)
  managers.network:session():send_to_peers_synched("mark_enemy", l_14_1, false)
end

IngameAccessCamera.update_player_stamina = function(l_15_0, l_15_1, l_15_2)
  local player = managers.player:player_unit()
  if player and player:movement() then
    player:movement():update_stamina(l_15_1, l_15_2, true)
  end
end

IngameAccessCamera._player_damage = function(l_16_0, l_16_1)
  l_16_0:cb_leave()
end

IngameAccessCamera.at_enter = function(l_17_0, l_17_1, ...)
   -- DECOMPILER ERROR: Confused at declaration of local variable

  if managers.player:player_unit() then
    managers.player:player_unit():base():set_enabled(false)
    managers.player:player_unit():base():set_visible(false)
    managers.player:player_unit():character_damage():add_listener("IngameAccessCamera", {"hurt", "death"}, callback(l_17_0, l_17_0, "_player_damage"))
    SoundDevice:set_rtpc("stamina", 100)
  end
  if not l_17_0._sound_source then
    l_17_0._sound_source = SoundDevice:create_source("IngameAccessCamera")
  end
  l_17_0._sound_source:post_event("camera_monitor_engage")
  managers.enemy:set_gfx_lod_enabled(false)
  l_17_0._old_state = l_17_1:name()
  if not managers.hud:exists(l_17_0.GUI_SAFERECT) then
    managers.hud:load_hud(l_17_0.GUI_FULLSCREEN, false, true, false, {})
    managers.hud:load_hud(l_17_0.GUI_SAFERECT, false, true, true, {})
  end
  managers.hud:show(l_17_0.GUI_SAFERECT)
  managers.hud:show(l_17_0.GUI_FULLSCREEN)
  managers.hud:start_access_camera()
  l_17_0._saved_default_color_grading = managers.environment_controller:default_color_grading()
  managers.environment_controller:set_default_color_grading("color_sin")
  l_17_0._cam_unit = CoreUnit.safe_spawn_unit("units/gui/background_camera_01/access_camera", Vector3(), Rotation())
  l_17_0:_get_cameras()
  l_17_0._camera_data = {}
  l_17_0._camera_data.index = 0
  l_17_0._no_feeds = not l_17_0:_any_enabled_cameras()
  if l_17_0._no_feeds then
    managers.hud:set_access_camera_destroyed(true, true)
  else
    l_17_0:_next_camera()
  end
  l_17_0._enemy_contours = {}
  l_17_0:_setup_controller()
   -- DECOMPILER ERROR: Confused about usage of registers for local variables.

end

IngameAccessCamera._any_enabled_cameras = function(l_18_0)
  if not l_18_0._cameras or #l_18_0._cameras == 0 then
    return false
  end
  for _,data in ipairs(l_18_0._cameras) do
    if data.access_camera:enabled() then
      return true
    end
  end
  return false
end

IngameAccessCamera.at_exit = function(l_19_0)
  l_19_0._sound_source:post_event("camera_monitor_leave")
  managers.environment_controller:set_default_color_grading(l_19_0._saved_default_color_grading)
  managers.enemy:set_gfx_lod_enabled(true)
  l_19_0:_clear_controller()
  World:delete_unit(l_19_0._cam_unit)
  managers.hud:hide(l_19_0.GUI_SAFERECT)
  managers.hud:hide(l_19_0.GUI_FULLSCREEN)
  managers.hud:stop_access_camera()
  if l_19_0._last_access_camera then
    l_19_0._last_access_camera:remove_trigger("IngameAccessCamera", "destroyed")
  end
  local player = managers.player:player_unit()
  if player then
    player:base():set_enabled(true)
    player:base():set_visible(true)
    player:character_damage():remove_listener("IngameAccessCamera")
  end
end

IngameAccessCamera.on_server_left = function(l_20_0)
  IngameCleanState.on_server_left(l_20_0)
end

IngameAccessCamera.on_kicked = function(l_21_0)
  IngameCleanState.on_kicked(l_21_0)
end

IngameAccessCamera.on_disconnected = function(l_22_0)
  IngameCleanState.on_disconnected(l_22_0)
end


