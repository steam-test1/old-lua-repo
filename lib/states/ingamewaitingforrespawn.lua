-- Decompiled using luadec 2.0.1 by sztupy (http://winmo.sztupy.hu)
-- Command line was: F:\SteamLibrary\SteamApps\common\PAYDAY 2\lua\lib\states\ingamewaitingforrespawn.luac 

core:import("CoreUnit")
require("lib/states/GameState")
if not IngameWaitingForRespawnState then
  IngameWaitingForRespawnState = class(GameState)
end
IngameWaitingForRespawnState.GUI_SPECTATOR_FULLSCREEN = Idstring("guis/spectator_fullscreen")
IngameWaitingForRespawnState.GUI_SPECTATOR = Idstring("guis/spectator_mode")
IngameWaitingForRespawnState.PLAYER_HUD = Idstring("guis/player_hud")
IngameWaitingForRespawnState.PLAYER_INFO_HUD = Idstring("guis/player_info_hud")
IngameWaitingForRespawnState.init = function(l_1_0, l_1_1)
  GameState.init(l_1_0, "ingame_waiting_for_respawn", l_1_1)
  l_1_0._slotmask = managers.slot:get_mask("world_geometry")
  l_1_0._fwd = Vector3(1, 0, 0)
  l_1_0._up_offset = math.UP * 80
  l_1_0._rot = Rotation()
  l_1_0._vec_target = Vector3()
  l_1_0._vec_eye = Vector3()
  l_1_0._vec_dir = Vector3()
end

IngameWaitingForRespawnState._setup_controller = function(l_2_0)
  l_2_0._controller = managers.controller:create_controller("waiting_for_respawn", managers.controller:get_default_wrapper_index(), false)
  l_2_0._next_player_cb = callback(l_2_0, l_2_0, "cb_next_player")
  l_2_0._prev_player_cb = callback(l_2_0, l_2_0, "cb_prev_player")
  l_2_0._controller:add_trigger("left", l_2_0._prev_player_cb)
  l_2_0._controller:add_trigger("right", l_2_0._next_player_cb)
  l_2_0._controller:add_trigger("primary_attack", l_2_0._prev_player_cb)
  l_2_0._controller:add_trigger("secondary_attack", l_2_0._next_player_cb)
  l_2_0._controller:set_enabled(true)
end

IngameWaitingForRespawnState._clear_controller = function(l_3_0)
  if l_3_0._controller then
    l_3_0._controller:remove_trigger("left", l_3_0._prev_player_cb)
    l_3_0._controller:remove_trigger("right", l_3_0._next_player_cb)
    l_3_0._controller:remove_trigger("primary_attack", l_3_0._prev_player_cb)
    l_3_0._controller:remove_trigger("secondary_attack", l_3_0._next_player_cb)
    l_3_0._controller:set_enabled(false)
    l_3_0._controller:destroy()
    l_3_0._controller = nil
  end
end

IngameWaitingForRespawnState.set_controller_enabled = function(l_4_0, l_4_1)
  if l_4_0._controller then
    l_4_0._controller:set_enabled(l_4_1)
  end
end

IngameWaitingForRespawnState._setup_camera = function(l_5_0)
  l_5_0._camera_object = World:create_camera()
  l_5_0._camera_object:set_near_range(3)
  l_5_0._camera_object:set_far_range(1000000)
  l_5_0._camera_object:set_fov(75)
  l_5_0._viewport = managers.viewport:new_vp(0, 0, 1, 1, "spectator", CoreManagerBase.PRIO_WORLDCAMERA)
  l_5_0._viewport:set_camera(l_5_0._camera_object)
  l_5_0._viewport:set_environment(managers.environment_area:default_environment())
  l_5_0._viewport:set_active(true)
end

IngameWaitingForRespawnState._clear_camera = function(l_6_0)
  l_6_0._viewport:destroy()
  l_6_0._viewport = nil
  World:delete_camera(l_6_0._camera_object)
  l_6_0._camera_object = nil
end

IngameWaitingForRespawnState._setup_sound_listener = function(l_7_0)
  l_7_0._listener_id = managers.listener:add_listener("spectator_camera", l_7_0._camera_object, l_7_0._camera_object, nil, false)
  managers.listener:add_set("spectator_camera", {"spectator_camera"})
  l_7_0._listener_activation_id = managers.listener:activate_set("main", "spectator_camera")
  l_7_0._sound_check_object = managers.sound_environment:add_check_object({object = l_7_0._camera_object, active = true, primary = true})
end

IngameWaitingForRespawnState._clear_sound_listener = function(l_8_0)
  managers.sound_environment:remove_check_object(l_8_0._sound_check_object)
  managers.listener:remove_listener(l_8_0._listener_id)
  managers.listener:remove_set("spectator_camera")
  l_8_0._listener_id = nil
end

IngameWaitingForRespawnState._create_spectator_data = function(l_9_0)
  local all_teammates = managers.groupai:state():all_char_criminals()
  local teammate_list = {}
  for u_key,u_data in pairs(all_teammates) do
    table.insert(teammate_list, u_key)
  end
  l_9_0._spectator_data = {teammate_records = all_teammates, teammate_list = teammate_list, watch_u_key = teammate_list[1]}
end

IngameWaitingForRespawnState._begin_game_enter_transition = function(l_10_0)
  if l_10_0._ready_to_spawn_t then
    return 
  end
  l_10_0._auto_respawn_t = nil
  local overlay_effect_desc = tweak_data.overlay_effects.spectator
  local fade_in_duration = overlay_effect_desc.fade_in
  l_10_0._fade_in_overlay_eff_id = managers.overlay_effect:play_effect(overlay_effect_desc)
  l_10_0._ready_to_spawn_t = TimerManager:game():time() + fade_in_duration
end

IngameWaitingForRespawnState.request_player_spawn = function(l_11_0)
  if Network:is_client() then
    local peer_id = managers.network:session():local_peer():id()
    managers.network:session():server_peer():send("request_spawn_member", peer_id)
  else
    local possible_criminals = {}
    for u_key,u_data in pairs(managers.groupai:state():all_player_criminals()) do
      table.insert(possible_criminals, u_key)
    end
    local spawn_at = managers.groupai:state():all_player_criminals()[possible_criminals[math.random(1, #possible_criminals)]]
    if spawn_at then
      local spawn_pos = spawn_at.unit:position()
      local spawn_rot = spawn_at.unit:rotation()
      local peer_id = l_11_0 or 1
      local crim_name = managers.criminals:character_name_by_peer_id(peer_id)
      local first_crim = managers.trade:get_criminal_to_trade()
      if first_crim and first_crim.id == crim_name then
        managers.trade:cancel_trade()
      end
      managers.trade:sync_set_trade_spawn(crim_name)
      managers.network:session():send_to_peers_synched("set_trade_spawn", crim_name)
      local sp_id = "IngameWaitingForRespawnState"
      local spawn_point = {position = spawn_pos, rotation = spawn_rot}
      managers.network:register_spawn_point(sp_id, spawn_point)
      managers.network:game():spawn_member_by_id(peer_id, sp_id, true)
      managers.network:unregister_spawn_point(sp_id)
    end
  end
end

IngameWaitingForRespawnState.update = function(l_12_0, l_12_1, l_12_2)
  if l_12_0._player_state_change_needed and not alive(managers.player:player_unit()) then
    l_12_0._player_state_change_needed = nil
    managers.player:set_player_state("standard")
  end
  local btn_stats_screen_press = (not l_12_0._stats_screen and l_12_0._controller:get_input_pressed("stats_screen"))
  if l_12_0._stats_screen then
    local btn_stats_screen_release = l_12_0._controller:get_input_released("stats_screen")
  end
  if btn_stats_screen_press then
    l_12_0._stats_screen = true
    managers.hud:show_stats_screen()
  elseif btn_stats_screen_release then
    l_12_0._stats_screen = false
    managers.hud:hide_stats_screen()
  end
  if l_12_0._auto_respawn_t then
    local time = l_12_0._auto_respawn_t - l_12_1
    managers.hud:set_custody_respawn_time(time)
    if l_12_0._auto_respawn_t < l_12_1 then
      l_12_0._auto_respawn_t = nil
      l_12_0:_begin_game_enter_transition()
    elseif l_12_0._ready_to_spawn_t and l_12_0._ready_to_spawn_t < l_12_1 then
      IngameWaitingForRespawnState.request_player_spawn()
    end
  end
  if l_12_0._respawn_delay then
    l_12_0._respawn_delay = managers.trade:respawn_delay_by_name(managers.criminals:local_character_name())
    if l_12_0._respawn_delay <= 0 then
      l_12_0._respawn_delay = nil
      managers.hud:set_custody_negotiating_visible(false)
      managers.hud:set_custody_trade_delay_visible(false)
    else
      managers.hud:set_custody_trade_delay(l_12_0._respawn_delay)
    end
  end
  if l_12_0._play_too_long_line_t and l_12_0._play_too_long_line_t < l_12_1 and managers.groupai:state():bain_state() then
    l_12_0._play_too_long_line_t = nil
    managers.dialog:queue_dialog("Play_ban_h38x", {})
  end
  l_12_0:_upd_watch(l_12_1, l_12_2)
end

local mvec3_set = mvector3.set
local mvec3_add = mvector3.add
local mvec3_subtract = mvector3.subtract
local mvec3_multiply = mvector3.multiply
local mvec3_negate = mvector3.negate
local mvec3_rotate_with = mvector3.rotate_with
local mvec3_x = mvector3.x
local mvec3_y = mvector3.y
local mvec3_normalize = mvector3.normalize
local mvec3_length = mvector3.length
local mvec3_cross = mvector3.cross
local mvec3_angle = mvector3.angle
local mrot_set_axis_angle = mrotation.set_axis_angle
local mrot_set_look_at = mrotation.set_look_at
local math_up = math.UP
IngameWaitingForRespawnState._upd_watch = function(l_13_0, l_13_1, l_13_2)
  l_13_0:_refresh_teammate_list()
  if l_13_0._spectator_data.watch_u_key then
    if managers.hud:visible(l_13_0.GUI_SPECTATOR_FULLSCREEN) then
      managers.hud:hide(l_13_0.GUI_SPECTATOR_FULLSCREEN)
    end
    local watch_u_record = l_13_0._spectator_data.teammate_records[l_13_0._spectator_data.watch_u_key]
    local watch_u_head = watch_u_record.unit:movement():get_object(Idstring("Head"))
    if not watch_u_head then
      l_13_0._next_player_cb()
      return 
    end
    mvec3_set(l_13_0._vec_dir, l_13_0._controller:get_input_axis("look"))
    local controller_type = l_13_0._controller:get_default_controller_id()
    local stick_input_x = mvec3_x(l_13_0._vec_dir)
    if mvec3_length(l_13_0._vec_dir) > 0.10000000149012 then
      if controller_type ~= "keyboard" then
        stick_input_x = stick_input_x / (1.2999999523163 - 0.30000001192093 * (1 - math.abs(mvec3_y(l_13_0._vec_dir))))
        stick_input_x = stick_input_x * l_13_2 * 180
      end
      mrot_set_axis_angle(l_13_0._rot, math_up, -0.5 * (stick_input_x))
      mvec3_rotate_with(l_13_0._fwd, l_13_0._rot)
      mvec3_cross(l_13_0._vec_target, math_up, l_13_0._fwd)
      mrot_set_axis_angle(l_13_0._rot, l_13_0._vec_target, 0.5 * -mvec3_y(l_13_0._vec_dir))
      mvec3_rotate_with(l_13_0._fwd, l_13_0._rot)
      local angle = mvec3_angle(math_up, l_13_0._fwd)
      local rot = 0
      if angle > 145 then
        rot = 145 - angle
      elseif angle < 85 then
        rot = 85 - angle
      end
      if rot ~= 0 then
        mrot_set_axis_angle(l_13_0._rot, l_13_0._vec_target, rot)
        mvec3_rotate_with(l_13_0._fwd, l_13_0._rot)
      end
    end
    watch_u_head:m_position(l_13_0._vec_target)
    mvec3_set(l_13_0._vec_eye, l_13_0._fwd)
    mvec3_multiply(l_13_0._vec_eye, 150)
    mvec3_negate(l_13_0._vec_eye)
    mvec3_add(l_13_0._vec_eye, l_13_0._vec_target)
    mrot_set_look_at(l_13_0._rot, l_13_0._fwd, math_up)
    local col_ray = (World:raycast("ray", l_13_0._vec_target, l_13_0._vec_eye, "slot_mask", l_13_0._slotmask))
    local dis_new = nil
    if col_ray then
      mvec3_set(l_13_0._vec_dir, col_ray.ray)
      dis_new = math.max(col_ray.distance - 30, 0)
    else
      mvec3_set(l_13_0._vec_dir, l_13_0._vec_eye)
      mvec3_subtract(l_13_0._vec_dir, l_13_0._vec_target)
      dis_new = mvec3_normalize(l_13_0._vec_dir)
    end
    if l_13_0._dis_curr and l_13_0._dis_curr < dis_new then
      local speed = math.max((dis_new - l_13_0._dis_curr) / 5, 1.5)
      l_13_0._dis_curr = math.lerp(l_13_0._dis_curr, dis_new, speed * l_13_2)
    else
      l_13_0._dis_curr = dis_new
    end
    mvec3_set(l_13_0._vec_eye, l_13_0._vec_dir)
    mvec3_multiply(l_13_0._vec_eye, l_13_0._dis_curr)
    mvec3_add(l_13_0._vec_eye, l_13_0._vec_target)
    l_13_0._camera_object:set_position(l_13_0._vec_eye)
    l_13_0._camera_object:set_rotation(l_13_0._rot)
  else
    if not managers.hud:visible(l_13_0.GUI_SPECTATOR_FULLSCREEN) then
      managers.hud:show(l_13_0.GUI_SPECTATOR_FULLSCREEN)
    end
  end
end

IngameWaitingForRespawnState.at_enter = function(l_14_0)
  managers.player:force_drop_carry()
  managers.hud:set_player_health({current = 0, total = 100, no_hint = true})
  managers.hud:set_player_armor({current = 0, total = 100, no_hint = true})
  managers.hud:set_player_condition("mugshot_in_custody", managers.localization:text("debug_mugshot_in_custody"))
  managers.overlay_effect:play_effect(tweak_data.overlay_effects.fade_in)
  l_14_0:_setup_camera()
  l_14_0:_setup_controller()
  l_14_0:_setup_sound_listener()
  l_14_0._dis_curr = 150
  managers.statistics:in_custody()
  managers.menu:set_mouse_sensitivity(false)
  l_14_0._player_state_change_needed = true
  l_14_0._respawn_delay = nil
  l_14_0._play_too_long_line_t = nil
  if not managers.hud:exists(l_14_0.GUI_SPECTATOR_FULLSCREEN) then
    managers.hud:load_hud(l_14_0.GUI_SPECTATOR_FULLSCREEN, false, false, false, {})
  end
  if not managers.hud:exists(PlayerBase.PLAYER_CUSTODY_HUD) then
    managers.hud:load_hud(l_14_0.GUI_SPECTATOR, false, true, true, {})
  end
  managers.hud:show(l_14_0.GUI_SPECTATOR)
  managers.hud:show(l_14_0.PLAYER_INFO_HUD)
  managers.hud:show(PlayerBase.PLAYER_INFO_HUD_FULLSCREEN)
  managers.hud:set_custody_can_be_trade_visible(false)
  managers.hud:set_custody_negotiating_visible(false)
  managers.hud:set_custody_trade_delay_visible(false)
  if tweak_data.player.damage.automatic_respawn_time then
    l_14_0._auto_respawn_t = Application:time() + tweak_data.player.damage.automatic_respawn_time * managers.player:upgrade_value("player", "respawn_time_multiplier", 1)
    managers.hud:set_custody_timer_visibility(true)
  else
    managers.hud:set_custody_timer_visibility(false)
  end
  if not managers.hud:exists(l_14_0.PLAYER_HUD) then
    managers.hud:load_hud(l_14_0.PLAYER_HUD, false, false, true, {})
  end
  if not managers.hud:exists(l_14_0.PLAYER_INFO_HUD) then
    managers.hud:load_hud(l_14_0.PLAYER_INFO_HUD, false, false, true, {})
  end
  l_14_0:_create_spectator_data()
  l_14_0._next_player_cb()
  if Network:is_server() then
    local respawn_delay = managers.trade:respawn_delay_by_name(managers.criminals:local_character_name())
    local hostages_killed = managers.trade:hostages_killed_by_name(managers.criminals:local_character_name())
    l_14_0:trade_death(respawn_delay, hostages_killed)
  end
  if Global.game_settings.single_player then
    managers.hud:set_custody_negotiating_visible(false)
    managers.hud:set_custody_trade_delay_visible(false)
    managers.hud:set_custody_timer_visibility(false)
  end
end

IngameWaitingForRespawnState.at_exit = function(l_15_0)
  managers.hud:hide(l_15_0.GUI_SPECTATOR)
  managers.hud:hide(l_15_0.PLAYER_INFO_HUD)
  managers.hud:hide(PlayerBase.PLAYER_INFO_HUD_FULLSCREEN)
  managers.overlay_effect:fade_out_effect(l_15_0._fade_in_overlay_eff_id)
  if managers.hud:visible(l_15_0.GUI_SPECTATOR_FULLSCREEN) then
    managers.hud:hide(l_15_0.GUI_SPECTATOR_FULLSCREEN)
  end
  l_15_0:_clear_controller()
  l_15_0:_clear_camera()
  l_15_0:_clear_sound_listener()
  l_15_0._ready_to_spawn_t = nil
  l_15_0._fade_in_overlay_eff_id = nil
  managers.hud:set_player_condition("mugshot_normal", "")
end

IngameWaitingForRespawnState._refresh_teammate_list = function(l_16_0)
  local all_teammates = l_16_0._spectator_data.teammate_records
  local teammate_list = l_16_0._spectator_data.teammate_list
  local lost_teammate_at_i = nil
  local i = #teammate_list
  repeat
    if i > 0 then
      local u_key = teammate_list[i]
      local teammate_data = all_teammates[u_key]
      if not teammate_data then
        table.remove(teammate_list, i)
        if u_key == l_16_0._spectator_data.watch_u_key then
          lost_teammate_at_i = i
          l_16_0._spectator_data.watch_u_key = nil
        end
      end
      i = i - 1
    else
      if #teammate_list ~= table.size(all_teammates) then
        for u_key,u_data in pairs(all_teammates) do
          local add = true
          for i_key,test_u_key in ipairs(teammate_list) do
            if test_u_key == u_key then
              add = false
          else
            end
          end
          if add then
            table.insert(teammate_list, u_key)
          end
        end
      end
      if lost_teammate_at_i then
        l_16_0._spectator_data.watch_u_key = teammate_list[math.clamp(lost_teammate_at_i, 1, #teammate_list)]
      end
       -- Warning: missing end command somewhere! Added here
    end
     -- Warning: missing end command somewhere! Added here
  end
end

IngameWaitingForRespawnState._get_teammate_index_by_unit_key = function(l_17_0, l_17_1)
  for i_key,test_u_key in ipairs(l_17_0._spectator_data.teammate_list) do
    if test_u_key == l_17_1 then
      return i_key
    end
  end
end

IngameWaitingForRespawnState.cb_next_player = function(l_18_0)
  l_18_0:_refresh_teammate_list()
  local watch_u_key = l_18_0._spectator_data.watch_u_key
  if not watch_u_key then
    return 
  end
  local i_watch = l_18_0:_get_teammate_index_by_unit_key(watch_u_key)
  if i_watch == #l_18_0._spectator_data.teammate_list then
    i_watch = 1
  else
    i_watch = i_watch + 1
  end
  watch_u_key = l_18_0._spectator_data.teammate_list[i_watch]
  l_18_0._spectator_data.watch_u_key = watch_u_key
  l_18_0:_upd_hud_watch_character_name()
  l_18_0._dis_curr = nil
end

IngameWaitingForRespawnState.cb_prev_player = function(l_19_0)
  l_19_0:_refresh_teammate_list()
  local watch_u_key = l_19_0._spectator_data.watch_u_key
  if not watch_u_key then
    return 
  end
  local i_watch = l_19_0:_get_teammate_index_by_unit_key(watch_u_key)
  if i_watch == 1 then
    i_watch = #l_19_0._spectator_data.teammate_list
  else
    i_watch = i_watch - 1
  end
  watch_u_key = l_19_0._spectator_data.teammate_list[i_watch]
  l_19_0._spectator_data.watch_u_key = watch_u_key
  l_19_0:_upd_hud_watch_character_name()
  l_19_0._dis_curr = nil
end

IngameWaitingForRespawnState._upd_hud_watch_character_name = function(l_20_0)
  local new_text = nil
  if l_20_0._spectator_data.watch_u_key then
    new_text = managers.localization:text("menu_spectator_spactating") .. " " .. l_20_0._spectator_data.teammate_records[l_20_0._spectator_data.watch_u_key].unit:base():nick_name()
  else
    new_text = ""
  end
  managers.hud:script(l_20_0.GUI_SPECTATOR).text_title:set_text(utf8.to_upper(new_text))
end

IngameWaitingForRespawnState.trade_death = function(l_21_0, l_21_1, l_21_2)
  managers.hud:set_custody_can_be_trade_visible(false)
  l_21_0._respawn_delay = managers.trade:respawn_delay_by_name(managers.criminals:local_character_name())
  l_21_0._hostages_killed = l_21_2
  if l_21_0._respawn_delay > 0 then
    managers.hud:set_custody_trade_delay_visible(true)
    managers.hud:set_custody_civilians_killed(l_21_0._hostages_killed)
    managers.hud:set_custody_trade_delay(l_21_0._respawn_delay)
    managers.hud:set_custody_negotiating_visible(true)
  end
  if not Global.game_settings.single_player and managers.groupai:state():bain_state() then
    if managers.groupai:state():get_assault_mode() then
      managers.dialog:queue_dialog("ban_h31x", {})
    elseif l_21_2 == 0 then
      managers.dialog:queue_dialog("Play_ban_h32x", {})
    elseif l_21_2 < 3 then
      managers.dialog:queue_dialog("Play_ban_h33x", {})
    else
      managers.dialog:queue_dialog("Play_ban_h34x", {})
    end
  end
end

IngameWaitingForRespawnState.finish_trade = function(l_22_0)
  l_22_0:_begin_game_enter_transition()
end

IngameWaitingForRespawnState.begin_trade = function(l_23_0)
  managers.hud:set_custody_can_be_trade_visible(true)
  local crims = {}
  for k,d in pairs(managers.groupai:state():all_char_criminals()) do
    crims[k] = d
  end
  if managers.groupai:state():bain_state() and next(crims) then
    if table.size(crims) > 1 then
      managers.dialog:queue_dialog("Play_ban_h36x", {})
    else
      local _, data = next(crims)
      local char_code = managers.criminals:character_static_data_by_unit(data.unit).ssuffix
      managers.dialog:queue_dialog("Play_ban_h37" .. char_code, {})
    end
  end
  l_23_0._play_too_long_line_t = Application:time() + 60
end

IngameWaitingForRespawnState.cancel_trade = function(l_24_0)
  managers.hud:set_custody_can_be_trade_visible(false)
end

IngameWaitingForRespawnState.on_server_left = function(l_25_0)
  IngameCleanState.on_server_left(l_25_0)
end

IngameWaitingForRespawnState.on_kicked = function(l_26_0)
  IngameCleanState.on_kicked(l_26_0)
end

IngameWaitingForRespawnState.on_disconnected = function(l_27_0)
  IngameCleanState.on_disconnected(l_27_0)
end


