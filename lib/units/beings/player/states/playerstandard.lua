-- Decompiled using luadec 2.0.1 by sztupy (http://winmo.sztupy.hu)
-- Command line was: F:\SteamLibrary\SteamApps\common\PAYDAY 2\lua\lib\units\beings\player\states\playerstandard.luac 

local mvec3_dis_sq = mvector3.distance_sq
local mvec3_set = mvector3.set
local mvec3_sub = mvector3.subtract
local mvec3_add = mvector3.add
local mvec3_mul = mvector3.multiply
local mvec3_norm = mvector3.normalize
if not PlayerStandard then
  PlayerStandard = class(PlayerMovementState)
end
PlayerStandard.MOVER_STAND = Idstring("stand")
PlayerStandard.MOVER_DUCK = Idstring("duck")
PlayerStandard.IDS_EQUIP = Idstring("equip")
PlayerStandard.IDS_MASK_EQUIP = Idstring("mask_equip")
PlayerStandard.IDS_UNEQUIP = Idstring("unequip")
PlayerStandard.IDS_RELOAD_EXIT = Idstring("reload_exit")
PlayerStandard.IDS_RELOAD_NOT_EMPTY_EXIT = Idstring("reload_not_empty_exit")
PlayerStandard.IDS_START_RUNNING = Idstring("start_running")
PlayerStandard.IDS_STOP_RUNNING = Idstring("stop_running")
PlayerStandard.IDS_MELEE = Idstring("melee")
PlayerStandard.IDS_MELEE_MISS = Idstring("melee_miss")
PlayerStandard.IDS_IDLE = Idstring("idle")
PlayerStandard.IDS_USE = Idstring("use")
PlayerStandard.IDS_RECOIL = Idstring("recoil")
PlayerStandard.IDS_RECOIL_STEELSIGHT = Idstring("recoil_steelsight")
PlayerStandard.IDS_RECOIL_ENTER = Idstring("recoil_enter")
PlayerStandard.IDS_RECOIL_LOOP = Idstring("recoil_loop")
PlayerStandard.IDS_RECOIL_EXIT = Idstring("recoil_exit")
PlayerStandard.init = function(l_1_0, l_1_1)
  PlayerMovementState.init(l_1_0, l_1_1)
  l_1_0._tweak_data = tweak_data.player.movement_state.standard
  l_1_0._obj_com = l_1_0._unit:get_object(Idstring("rp_mover"))
  l_1_0._slotmask_gnd_ray = managers.slot:get_mask("AI_graph_obstacle_check")
  l_1_0._slotmask_fwd_ray = managers.slot:get_mask("bullet_impact_targets")
  l_1_0._slotmask_bullet_impact_targets = managers.slot:get_mask("bullet_impact_targets")
  l_1_0._slotmask_pickups = managers.slot:get_mask("pickups")
  l_1_0._slotmask_AI_visibility = managers.slot:get_mask("AI_visibility")
  l_1_0._slotmask_long_distance_interaction = managers.slot:get_mask("long_distance_interaction")
  l_1_0._ext_camera = l_1_1:camera()
  l_1_0._ext_movement = l_1_1:movement()
  l_1_0._ext_damage = l_1_1:character_damage()
  l_1_0._ext_inventory = l_1_1:inventory()
  l_1_0._ext_anim = l_1_1:anim_data()
  l_1_0._ext_network = l_1_1:network()
  l_1_0._camera_unit = l_1_0._ext_camera._camera_unit
  l_1_0._machine = l_1_1:anim_state_machine()
  l_1_0._m_pos = l_1_0._ext_movement:m_pos()
  l_1_0._pos = Vector3()
  l_1_0._stick_move = Vector3()
  l_1_0._stick_look = Vector3()
  l_1_0._cam_fwd_flat = Vector3()
  l_1_0._walk_release_t = -100
  l_1_0._last_sent_pos = l_1_1:position()
  l_1_0._last_sent_pos_t = 0
  l_1_0._state_data = l_1_1:movement()._state_data
end

PlayerStandard.enter = function(l_2_0, l_2_1, l_2_2)
  PlayerMovementState.enter(l_2_0, l_2_1, l_2_2)
  tweak_data:add_reload_callback(l_2_0, l_2_0.tweak_data_clbk_reload)
  l_2_0._state_data = l_2_1
  l_2_0._equipped_unit = l_2_0._ext_inventory:equipped_unit()
  local weapon = l_2_0._ext_inventory:equipped_unit()
  if not weapon or not weapon:base().weapon_hold or not weapon:base():weapon_hold() then
    l_2_0._weapon_hold = weapon:base():get_name_id()
  end
  l_2_0:inventory_clbk_listener(l_2_0._unit, "equip")
  l_2_0:_enter(l_2_2)
  l_2_0:_update_ground_ray()
  l_2_0._controller = l_2_0._unit:base():controller()
  if not l_2_0._unit:mover() then
    l_2_0._unit:activate_mover(PlayerStandard.MOVER_STAND)
  end
  if l_2_2 and l_2_2.wants_crouch and not l_2_0._state_data.ducking then
    l_2_0:_start_action_ducking(managers.player:player_timer():time())
  end
  l_2_0._ext_camera:clbk_fp_enter(l_2_0._unit:rotation():y())
  if l_2_0._ext_movement:nav_tracker() then
    l_2_0._pos_reservation = {position = l_2_0._ext_movement:m_pos(), radius = 100, filter = l_2_0._ext_movement:pos_rsrv_id()}
    l_2_0._pos_reservation_slow = {position = mvector3.copy(l_2_0._ext_movement:m_pos()), radius = 100, filter = l_2_0._ext_movement:pos_rsrv_id()}
    managers.navigation:add_pos_reservation(l_2_0._pos_reservation)
    managers.navigation:add_pos_reservation(l_2_0._pos_reservation_slow)
  end
  managers.hud:set_ammo_amount(l_2_0._equipped_unit:base():selection_index(), l_2_0._equipped_unit:base():ammo_info())
  managers.hud:set_weapon_name(tweak_data.weapon[l_2_0._equipped_unit:base():get_name_id()].name_id)
  if l_2_2 and l_2_2.equip_weapon then
    l_2_0:_start_action_unequip_weapon(managers.player:player_timer():time(), {selection_wanted = l_2_2.equip_weapon})
  end
  l_2_0:_reset_delay_action()
  l_2_0._last_velocity_xy = Vector3()
  if not l_2_2 or not l_2_2.last_sent_pos_t then
    l_2_0._last_sent_pos_t = managers.player:player_timer():time()
  end
  if not l_2_2 or not l_2_2.last_sent_pos then
    l_2_0._last_sent_pos = mvector3.copy(l_2_0._pos)
  end
end

PlayerStandard._enter = function(l_3_0, l_3_1)
  l_3_0._unit:base():set_slot(l_3_0._unit, 2)
  if Network:is_server() and l_3_0._ext_movement:nav_tracker() then
    managers.groupai:state():on_player_weapons_hot()
  end
  if l_3_0._ext_movement:nav_tracker() then
    managers.groupai:state():on_criminal_recovered(l_3_0._unit)
  end
  if l_3_1 then
    local skip_equip = l_3_1.skip_equip
  end
  if not l_3_0:_changing_weapon() and not skip_equip then
    if not l_3_0._state_data.mask_equipped then
      l_3_0._state_data.mask_equipped = true
      l_3_0:_start_action_equip(l_3_0.IDS_MASK_EQUIP, 1.6000000238419)
    else
      l_3_0:_start_action_equip(l_3_0.IDS_EQUIP)
    end
  end
  l_3_0._ext_camera:camera_unit():base():set_target_tilt(0)
  if l_3_0._ext_movement:nav_tracker() then
    l_3_0._standing_nav_seg_id = l_3_0._ext_movement:nav_tracker():nav_segment()
    local metadata = managers.navigation:get_nav_seg_metadata(l_3_0._standing_nav_seg_id)
    local location_id = metadata.location_id
    managers.hud:set_player_location(location_id)
    l_3_0._unit:base():set_suspicion_multiplier("area", metadata.suspicion_mul)
    l_3_0._unit:base():set_detection_multiplier("area", metadata.detection_mul and 1 / metadata.detection_mul or nil)
  end
  l_3_0._ext_inventory:set_mask_visibility(true)
  if not l_3_0._state_data.ducking then
    l_3_0._ext_movement:set_attention_settings({"pl_enemy_cbt", "pl_team_idle_std", "pl_civ_cbt"})
  end
  l_3_0._ext_network:send("set_stance", 2)
end

PlayerStandard.exit = function(l_4_0, l_4_1, l_4_2)
  PlayerMovementState.exit(l_4_0, l_4_1)
  tweak_data:remove_reload_callback(l_4_0)
  l_4_0:_interupt_action_interact()
  l_4_0:_interupt_action_use_item()
  managers.environment_controller:set_dof_distance()
  if l_4_0._pos_reservation then
    managers.navigation:unreserve_pos(l_4_0._pos_reservation)
    managers.navigation:unreserve_pos(l_4_0._pos_reservation_slow)
    l_4_0._pos_reservation = nil
    l_4_0._pos_reservation_slow = nil
  end
  if l_4_0._running then
    l_4_0:_end_action_running(managers.player:player_timer():time())
    l_4_0:set_running(false)
  end
  if l_4_0._shooting then
    l_4_0._shooting = false
    l_4_0._equipped_unit:base():stop_shooting()
    l_4_0._camera_unit:base():stop_shooting()
  end
  l_4_0._headbob = 0
  l_4_0._target_headbob = 0
  l_4_0._ext_camera:set_shaker_parameter("headbob", "amplitude", 0)
  local exit_data = {last_sent_pos_t = l_4_0._last_sent_pos_t, last_sent_pos = l_4_0._last_sent_pos, ducking = l_4_0._state_data.ducking}
  return exit_data
end

PlayerStandard.interaction_blocked = function(l_5_0)
  return l_5_0:is_deploying()
end

PlayerStandard.update = function(l_6_0, l_6_1, l_6_2)
  PlayerMovementState.update(l_6_0, l_6_1, l_6_2)
  l_6_0:_calculate_standard_variables(l_6_1, l_6_2)
  l_6_0:_update_ground_ray()
  l_6_0:_update_fwd_ray()
  l_6_0:_update_check_actions(l_6_1, l_6_2)
  l_6_0:_update_movement(l_6_1, l_6_2)
  l_6_0:_upd_nav_data()
  managers.hud:_update_crosshair_offset(l_6_1, l_6_2)
end

PlayerStandard.in_air = function(l_7_0)
  return l_7_0._state_data.in_air
end

PlayerStandard.in_steelsight = function(l_8_0)
  return l_8_0._state_data.in_steelsight
end

local temp_vec1 = Vector3()
PlayerStandard._upd_nav_data = function(l_9_0)
  if mvec3_dis_sq(l_9_0._m_pos, l_9_0._pos) > 1 then
    if l_9_0._ext_movement:nav_tracker() then
      l_9_0._ext_movement:nav_tracker():move(l_9_0._pos)
      local nav_seg_id = l_9_0._ext_movement:nav_tracker():nav_segment()
      if l_9_0._standing_nav_seg_id ~= nav_seg_id then
        l_9_0._standing_nav_seg_id = nav_seg_id
        local metadata = managers.navigation:get_nav_seg_metadata(nav_seg_id)
        local location_id = metadata.location_id
        managers.hud:set_player_location(location_id)
        l_9_0._unit:base():set_suspicion_multiplier("area", metadata.suspicion_mul)
        l_9_0._unit:base():set_detection_multiplier("area", metadata.detection_mul and 1 / metadata.detection_mul or nil)
        managers.groupai:state():on_criminal_nav_seg_change(l_9_0._unit, nav_seg_id)
      end
    end
    if l_9_0._pos_reservation then
      managers.navigation:move_pos_rsrv(l_9_0._pos_reservation)
      local slow_dist = 100
      mvec3_set(temp_vec1, l_9_0._pos_reservation_slow.position)
      mvec3_sub(temp_vec1, l_9_0._pos_reservation.position)
      if slow_dist < mvec3_norm(temp_vec1) then
        mvec3_mul(temp_vec1, slow_dist)
        mvec3_add(temp_vec1, l_9_0._pos_reservation.position)
        mvec3_set(l_9_0._pos_reservation_slow.position, temp_vec1)
        managers.navigation:move_pos_rsrv(l_9_0._pos_reservation)
      end
    end
    l_9_0._ext_movement:set_m_pos(l_9_0._pos)
  end
end

PlayerStandard._calculate_standard_variables = function(l_10_0, l_10_1, l_10_2)
  l_10_0._gnd_ray = nil
  l_10_0._gnd_ray_chk = nil
  l_10_0._unit:m_position(l_10_0._pos)
  l_10_0._rot = l_10_0._unit:rotation()
  l_10_0._cam_fwd = l_10_0._ext_camera:forward()
  mvector3.set(l_10_0._cam_fwd_flat, l_10_0._cam_fwd)
  mvector3.set_z(l_10_0._cam_fwd_flat, 0)
  mvector3.normalize(l_10_0._cam_fwd_flat)
  local last_vel_xy = l_10_0._last_velocity_xy
  local sampled_vel_dir = l_10_0._unit:sampled_velocity()
  mvector3.set_z(sampled_vel_dir, 0)
  local sampled_vel_len = mvector3.normalize(sampled_vel_dir)
  if sampled_vel_len == 0 then
    mvector3.set_zero(l_10_0._last_velocity_xy)
  else
    local fwd_dot = mvector3.dot(sampled_vel_dir, last_vel_xy)
    mvector3.set(l_10_0._last_velocity_xy, sampled_vel_dir)
    if sampled_vel_len < fwd_dot then
      mvector3.multiply(l_10_0._last_velocity_xy, sampled_vel_len)
    else
      mvector3.multiply(l_10_0._last_velocity_xy, math.max(0, fwd_dot))
    end
  end
  l_10_0._setting_hold_to_run = managers.user:get_setting("hold_to_run")
  l_10_0._setting_hold_to_duck = managers.user:get_setting("hold_to_duck")
end

local tmp_ground_from_vec = Vector3()
local tmp_ground_to_vec = Vector3()
local up_offset_vec = math.UP * 30
local down_offset_vec = math.UP * -40
PlayerStandard._update_ground_ray = function(l_11_0)
  local hips_pos = tmp_ground_from_vec
  local down_pos = tmp_ground_to_vec
  mvector3.set(hips_pos, l_11_0._pos)
  mvector3.add(hips_pos, up_offset_vec)
  mvector3.set(down_pos, hips_pos)
  mvector3.add(down_pos, down_offset_vec)
  l_11_0._gnd_ray = World:raycast("ray", hips_pos, down_pos, "slot_mask", l_11_0._slotmask_gnd_ray, "ray_type", "body mover", "sphere_cast_radius", 29, "report")
  l_11_0._gnd_ray_chk = true
end

PlayerStandard._update_fwd_ray = function(l_12_0)
  local from = l_12_0._unit:movement():m_head_pos()
  local to = l_12_0._cam_fwd * 4000
  mvector3.add(to, from)
  l_12_0._fwd_ray = World:raycast("ray", from, to, "slot_mask", l_12_0._slotmask_fwd_ray)
  managers.environment_controller:set_dof_distance(math.max(0, (l_12_0._fwd_ray and l_12_0._fwd_ray.distance or 4000) - 200), l_12_0._state_data.in_steelsight)
end

local win32 = SystemInfo:platform() == Idstring("WIN32")
PlayerStandard._get_input = function(l_13_0, l_13_1, l_13_2)
  if l_13_0._state_data.controller_enabled ~= l_13_0._controller:enabled() and l_13_0._state_data.controller_enabled then
    if not Global.game_settings.single_player then
      local release_interact = not managers.menu:get_controller():get_input_bool("interact")
    end
    do
      local input = {btn_steelsight_release = true, btn_interact_release = release_interact, btn_use_item_release = true}
      l_13_0._state_data.controller_enabled = l_13_0._controller:enabled()
      return input
    end
    do return end
    if not l_13_0._state_data.controller_enabled then
      local input = {btn_interact_release = managers.menu:get_controller():get_input_released("interact")}
      return input
    end
  end
  l_13_0._state_data.controller_enabled = l_13_0._controller:enabled()
  local pressed = l_13_0._controller:get_any_input_pressed()
  local released = l_13_0._controller:get_any_input_released()
  local downed = l_13_0._controller:get_any_input()
  if not pressed and not released and not downed then
    return {}
  end
  if ((((((((((released and l_13_0._unit:base():stats_screen_visible() and not pressed) or released and pressed and pressed and downed and pressed and pressed and released and downed and pressed and released))))))))) then
    {btn_stats_screen_press = pressed and ((not l_13_0._unit:base():stats_screen_visible() and l_13_0._controller:get_input_pressed("stats_screen"))), btn_stats_screen_release = l_13_0._controller:get_input_released("stats_screen"), btn_duck_press = l_13_0._controller:get_input_pressed("duck"), btn_duck_release = l_13_0._controller:get_input_released("duck"), btn_jump_press = l_13_0._controller:get_input_pressed("jump"), btn_primary_attack_press = l_13_0._controller:get_input_pressed("primary_attack"), btn_primary_attack_state = l_13_0._controller:get_input_bool("primary_attack"), btn_reload_press = l_13_0._controller:get_input_pressed("reload"), btn_steelsight_press = l_13_0._controller:get_input_pressed("secondary_attack"), btn_steelsight_release = l_13_0._controller:get_input_released("secondary_attack"), btn_steelsight_state = l_13_0._controller:get_input_bool("secondary_attack"), btn_interact_press = l_13_0._controller:get_input_pressed("interact")}.btn_interact_release = l_13_0._controller:get_input_released("interact")
  end
   -- DECOMPILER ERROR: Confused about usage of registers!

  if pressed then
    {btn_stats_screen_press = pressed and ((not l_13_0._unit:base():stats_screen_visible() and l_13_0._controller:get_input_pressed("stats_screen"))), btn_stats_screen_release = l_13_0._controller:get_input_released("stats_screen"), btn_duck_press = l_13_0._controller:get_input_pressed("duck"), btn_duck_release = l_13_0._controller:get_input_released("duck"), btn_jump_press = l_13_0._controller:get_input_pressed("jump"), btn_primary_attack_press = l_13_0._controller:get_input_pressed("primary_attack"), btn_primary_attack_state = l_13_0._controller:get_input_bool("primary_attack"), btn_reload_press = l_13_0._controller:get_input_pressed("reload"), btn_steelsight_press = l_13_0._controller:get_input_pressed("secondary_attack"), btn_steelsight_release = l_13_0._controller:get_input_released("secondary_attack"), btn_steelsight_state = l_13_0._controller:get_input_bool("secondary_attack"), btn_interact_press = l_13_0._controller:get_input_pressed("interact")}.btn_run_press = l_13_0._controller:get_input_pressed("run")
  end
   -- DECOMPILER ERROR: Confused about usage of registers!

  if released then
    {btn_stats_screen_press = pressed and ((not l_13_0._unit:base():stats_screen_visible() and l_13_0._controller:get_input_pressed("stats_screen"))), btn_stats_screen_release = l_13_0._controller:get_input_released("stats_screen"), btn_duck_press = l_13_0._controller:get_input_pressed("duck"), btn_duck_release = l_13_0._controller:get_input_released("duck"), btn_jump_press = l_13_0._controller:get_input_pressed("jump"), btn_primary_attack_press = l_13_0._controller:get_input_pressed("primary_attack"), btn_primary_attack_state = l_13_0._controller:get_input_bool("primary_attack"), btn_reload_press = l_13_0._controller:get_input_pressed("reload"), btn_steelsight_press = l_13_0._controller:get_input_pressed("secondary_attack"), btn_steelsight_release = l_13_0._controller:get_input_released("secondary_attack"), btn_steelsight_state = l_13_0._controller:get_input_bool("secondary_attack"), btn_interact_press = l_13_0._controller:get_input_pressed("interact")}.btn_run_release = l_13_0._controller:get_input_released("run")
  end
   -- DECOMPILER ERROR: Confused about usage of registers!

  if downed then
    {btn_stats_screen_press = pressed and ((not l_13_0._unit:base():stats_screen_visible() and l_13_0._controller:get_input_pressed("stats_screen"))), btn_stats_screen_release = l_13_0._controller:get_input_released("stats_screen"), btn_duck_press = l_13_0._controller:get_input_pressed("duck"), btn_duck_release = l_13_0._controller:get_input_released("duck"), btn_jump_press = l_13_0._controller:get_input_pressed("jump"), btn_primary_attack_press = l_13_0._controller:get_input_pressed("primary_attack"), btn_primary_attack_state = l_13_0._controller:get_input_bool("primary_attack"), btn_reload_press = l_13_0._controller:get_input_pressed("reload"), btn_steelsight_press = l_13_0._controller:get_input_pressed("secondary_attack"), btn_steelsight_release = l_13_0._controller:get_input_released("secondary_attack"), btn_steelsight_state = l_13_0._controller:get_input_bool("secondary_attack"), btn_interact_press = l_13_0._controller:get_input_pressed("interact")}.btn_run_state = l_13_0._controller:get_input_bool("run")
  end
   -- DECOMPILER ERROR: Confused about usage of registers!

  if pressed then
    {btn_stats_screen_press = pressed and ((not l_13_0._unit:base():stats_screen_visible() and l_13_0._controller:get_input_pressed("stats_screen"))), btn_stats_screen_release = l_13_0._controller:get_input_released("stats_screen"), btn_duck_press = l_13_0._controller:get_input_pressed("duck"), btn_duck_release = l_13_0._controller:get_input_released("duck"), btn_jump_press = l_13_0._controller:get_input_pressed("jump"), btn_primary_attack_press = l_13_0._controller:get_input_pressed("primary_attack"), btn_primary_attack_state = l_13_0._controller:get_input_bool("primary_attack"), btn_reload_press = l_13_0._controller:get_input_pressed("reload"), btn_steelsight_press = l_13_0._controller:get_input_pressed("secondary_attack"), btn_steelsight_release = l_13_0._controller:get_input_released("secondary_attack"), btn_steelsight_state = l_13_0._controller:get_input_bool("secondary_attack"), btn_interact_press = l_13_0._controller:get_input_pressed("interact")}.btn_switch_weapon_press = l_13_0._controller:get_input_pressed("switch_weapon")
  end
   -- DECOMPILER ERROR: Confused about usage of registers!

  if pressed then
    {btn_stats_screen_press = pressed and ((not l_13_0._unit:base():stats_screen_visible() and l_13_0._controller:get_input_pressed("stats_screen"))), btn_stats_screen_release = l_13_0._controller:get_input_released("stats_screen"), btn_duck_press = l_13_0._controller:get_input_pressed("duck"), btn_duck_release = l_13_0._controller:get_input_released("duck"), btn_jump_press = l_13_0._controller:get_input_pressed("jump"), btn_primary_attack_press = l_13_0._controller:get_input_pressed("primary_attack"), btn_primary_attack_state = l_13_0._controller:get_input_bool("primary_attack"), btn_reload_press = l_13_0._controller:get_input_pressed("reload"), btn_steelsight_press = l_13_0._controller:get_input_pressed("secondary_attack"), btn_steelsight_release = l_13_0._controller:get_input_released("secondary_attack"), btn_steelsight_state = l_13_0._controller:get_input_bool("secondary_attack"), btn_interact_press = l_13_0._controller:get_input_pressed("interact")}.btn_use_item_press = l_13_0._controller:get_input_pressed("use_item")
  end
   -- DECOMPILER ERROR: Confused about usage of registers!

  if released then
    {btn_stats_screen_press = pressed and ((not l_13_0._unit:base():stats_screen_visible() and l_13_0._controller:get_input_pressed("stats_screen"))), btn_stats_screen_release = l_13_0._controller:get_input_released("stats_screen"), btn_duck_press = l_13_0._controller:get_input_pressed("duck"), btn_duck_release = l_13_0._controller:get_input_released("duck"), btn_jump_press = l_13_0._controller:get_input_pressed("jump"), btn_primary_attack_press = l_13_0._controller:get_input_pressed("primary_attack"), btn_primary_attack_state = l_13_0._controller:get_input_bool("primary_attack"), btn_reload_press = l_13_0._controller:get_input_pressed("reload"), btn_steelsight_press = l_13_0._controller:get_input_pressed("secondary_attack"), btn_steelsight_release = l_13_0._controller:get_input_released("secondary_attack"), btn_steelsight_state = l_13_0._controller:get_input_bool("secondary_attack"), btn_interact_press = l_13_0._controller:get_input_pressed("interact")}.btn_use_item_release = l_13_0._controller:get_input_released("use_item")
  end
   -- DECOMPILER ERROR: Confused about usage of registers!

  if pressed then
    {btn_stats_screen_press = pressed and ((not l_13_0._unit:base():stats_screen_visible() and l_13_0._controller:get_input_pressed("stats_screen"))), btn_stats_screen_release = l_13_0._controller:get_input_released("stats_screen"), btn_duck_press = l_13_0._controller:get_input_pressed("duck"), btn_duck_release = l_13_0._controller:get_input_released("duck"), btn_jump_press = l_13_0._controller:get_input_pressed("jump"), btn_primary_attack_press = l_13_0._controller:get_input_pressed("primary_attack"), btn_primary_attack_state = l_13_0._controller:get_input_bool("primary_attack"), btn_reload_press = l_13_0._controller:get_input_pressed("reload"), btn_steelsight_press = l_13_0._controller:get_input_pressed("secondary_attack"), btn_steelsight_release = l_13_0._controller:get_input_released("secondary_attack"), btn_steelsight_state = l_13_0._controller:get_input_bool("secondary_attack"), btn_interact_press = l_13_0._controller:get_input_pressed("interact")}.btn_melee_press = l_13_0._controller:get_input_pressed("melee")
  end
   -- DECOMPILER ERROR: Confused about usage of registers!

  if pressed then
    {btn_stats_screen_press = pressed and ((not l_13_0._unit:base():stats_screen_visible() and l_13_0._controller:get_input_pressed("stats_screen"))), btn_stats_screen_release = l_13_0._controller:get_input_released("stats_screen"), btn_duck_press = l_13_0._controller:get_input_pressed("duck"), btn_duck_release = l_13_0._controller:get_input_released("duck"), btn_jump_press = l_13_0._controller:get_input_pressed("jump"), btn_primary_attack_press = l_13_0._controller:get_input_pressed("primary_attack"), btn_primary_attack_state = l_13_0._controller:get_input_bool("primary_attack"), btn_reload_press = l_13_0._controller:get_input_pressed("reload"), btn_steelsight_press = l_13_0._controller:get_input_pressed("secondary_attack"), btn_steelsight_release = l_13_0._controller:get_input_released("secondary_attack"), btn_steelsight_state = l_13_0._controller:get_input_bool("secondary_attack"), btn_interact_press = l_13_0._controller:get_input_pressed("interact")}.btn_weapon_gadget_press = l_13_0._controller:get_input_pressed("weapon_gadget")
    do
       -- DECOMPILER ERROR: Confused at declaration of local variable

    end
     -- DECOMPILER ERROR: Confused at declaration of local variable

    if win32 then
      repeat
         -- DECOMPILER ERROR: Confused about usage of registers!

         -- DECOMPILER ERROR: Confused about usage of registers!

         -- DECOMPILER ERROR: Confused about usage of registers!

        if 1 < 3 then
          if l_13_0._controller:get_input_pressed("primary_choice" .. 1) then
            {btn_stats_screen_press = pressed and ((not l_13_0._unit:base():stats_screen_visible() and l_13_0._controller:get_input_pressed("stats_screen"))), btn_stats_screen_release = l_13_0._controller:get_input_released("stats_screen"), btn_duck_press = l_13_0._controller:get_input_pressed("duck"), btn_duck_release = l_13_0._controller:get_input_released("duck"), btn_jump_press = l_13_0._controller:get_input_pressed("jump"), btn_primary_attack_press = l_13_0._controller:get_input_pressed("primary_attack"), btn_primary_attack_state = l_13_0._controller:get_input_bool("primary_attack"), btn_reload_press = l_13_0._controller:get_input_pressed("reload"), btn_steelsight_press = l_13_0._controller:get_input_pressed("secondary_attack"), btn_steelsight_release = l_13_0._controller:get_input_released("secondary_attack"), btn_steelsight_state = l_13_0._controller:get_input_bool("secondary_attack"), btn_interact_press = l_13_0._controller:get_input_pressed("interact")}.btn_primary_choice = 1
           -- DECOMPILER ERROR: Confused about usage of registers!

      end
       -- DECOMPILER ERROR: Confused about usage of registers!

      return {btn_stats_screen_press = pressed and ((not l_13_0._unit:base():stats_screen_visible() and l_13_0._controller:get_input_pressed("stats_screen"))), btn_stats_screen_release = l_13_0._controller:get_input_released("stats_screen"), btn_duck_press = l_13_0._controller:get_input_pressed("duck"), btn_duck_release = l_13_0._controller:get_input_released("duck"), btn_jump_press = l_13_0._controller:get_input_pressed("jump"), btn_primary_attack_press = l_13_0._controller:get_input_pressed("primary_attack"), btn_primary_attack_state = l_13_0._controller:get_input_bool("primary_attack"), btn_reload_press = l_13_0._controller:get_input_pressed("reload"), btn_steelsight_press = l_13_0._controller:get_input_pressed("secondary_attack"), btn_steelsight_release = l_13_0._controller:get_input_released("secondary_attack"), btn_steelsight_state = l_13_0._controller:get_input_bool("secondary_attack"), btn_interact_press = l_13_0._controller:get_input_pressed("interact")}
    end
     -- DECOMPILER ERROR: Confused about usage of registers for local variables.

     -- Warning: undefined locals caused missing assignments!
     -- Warning: missing end command somewhere! Added here
  end
end

PlayerStandard._determine_move_direction = function(l_14_0)
  l_14_0._stick_move = l_14_0._controller:get_input_axis("move")
  if mvector3.length(l_14_0._stick_move) < 0.10000000149012 or l_14_0:_interacting() then
    l_14_0._move_dir = nil
  else
    l_14_0._move_dir = mvector3.copy(l_14_0._stick_move)
    local cam_flat_rot = Rotation(l_14_0._cam_fwd_flat, math.UP)
    mvector3.rotate_with(l_14_0._move_dir, cam_flat_rot)
  end
end

PlayerStandard.update_check_actions_paused = function(l_15_0, l_15_1, l_15_2)
  l_15_0:_update_check_actions(Application:time(), 0.10000000149012)
end

PlayerStandard._update_check_actions = function(l_16_0, l_16_1, l_16_2)
  local input = l_16_0:_get_input()
  l_16_0:_determine_move_direction()
  l_16_0:_update_interaction_timers(l_16_1)
  l_16_0:_update_reload_timers(l_16_1, l_16_2, input)
  l_16_0:_update_melee_timers(l_16_1, input)
  l_16_0:_update_use_item_timers(l_16_1, input)
  l_16_0:_update_equip_weapon_timers(l_16_1, input)
  l_16_0:_update_running_timers(l_16_1)
  if l_16_0._change_item_expire_t and l_16_0._change_item_expire_t <= l_16_1 then
    l_16_0._change_item_expire_t = nil
  end
  if l_16_0._change_weapon_pressed_expire_t and l_16_0._change_weapon_pressed_expire_t <= l_16_1 then
    l_16_0._change_weapon_pressed_expire_t = nil
  end
  if input.btn_stats_screen_press then
    l_16_0._unit:base():set_stats_screen_visible(true)
  elseif input.btn_stats_screen_release then
    l_16_0._unit:base():set_stats_screen_visible(false)
  end
  l_16_0:_update_foley(l_16_1, input)
  local new_action = nil
  local anim_data = l_16_0._ext_anim
  if not new_action then
    new_action = l_16_0:_check_action_weapon_gadget(l_16_1, input)
  end
  if not new_action then
    new_action = l_16_0:_check_action_melee(l_16_1, input)
  end
  if not new_action then
    new_action = l_16_0:_check_action_reload(l_16_1, input)
  end
  if not new_action then
    new_action = l_16_0:_check_change_weapon(l_16_1, input)
  end
  if not new_action then
    new_action = l_16_0:_check_action_primary_attack(l_16_1, input)
  end
  if not new_action then
    new_action = l_16_0:_check_action_equip(l_16_1, input)
  end
  if not new_action then
    new_action = l_16_0:_check_use_item(l_16_1, input)
  end
  if not new_action then
    new_action = l_16_0:_check_action_interact(l_16_1, input)
  end
  l_16_0:_check_action_jump(l_16_1, input)
  l_16_0:_check_action_run(l_16_1, input)
  l_16_0:_check_action_duck(l_16_1, input)
  l_16_0:_check_action_steelsight(l_16_1, input)
  l_16_0:_find_pickups(l_16_1)
end

local mvec_pos_new = Vector3()
local mvec_achieved_walk_vel = Vector3()
local mvec_move_dir_normalized = Vector3()
PlayerStandard._update_movement = function(l_17_0, l_17_1, l_17_2)
  local anim_data = (l_17_0._unit:anim_data())
  local pos_new = nil
  l_17_0._target_headbob = l_17_0._target_headbob or 0
  l_17_0._headbob = l_17_0._headbob or 0
  if l_17_0._move_dir then
    local enter_moving = not l_17_0._moving
    l_17_0._moving = true
    if enter_moving then
      l_17_0._last_sent_pos_t = l_17_1
      l_17_0:_update_crosshair_offset()
    end
    local WALK_SPEED_MAX = l_17_0:_get_max_walk_speed(l_17_1)
    mvector3.set(mvec_move_dir_normalized, l_17_0._move_dir)
    mvector3.normalize(mvec_move_dir_normalized)
    local wanted_walk_speed = WALK_SPEED_MAX * math.min(1, l_17_0._move_dir:length())
    local acceleration = (l_17_0._state_data.in_air and 700) or (l_17_0._running and 5000) or 3000
    local achieved_walk_vel = mvec_achieved_walk_vel
    if l_17_0._jump_vel_xy and l_17_0._state_data.in_air and mvector3.dot(l_17_0._jump_vel_xy, l_17_0._last_velocity_xy) > 0 then
      local input_move_vec = wanted_walk_speed * l_17_0._move_dir
      local jump_dir = mvector3.copy(l_17_0._last_velocity_xy)
      local jump_vel = mvector3.normalize(jump_dir)
      local fwd_dot = jump_dir:dot(input_move_vec)
      if fwd_dot < jump_vel then
        local sustain_dot = input_move_vec:normalized() * jump_vel:dot(jump_dir)
        local new_move_vec = input_move_vec + jump_dir * (sustain_dot - fwd_dot)
        mvector3.step(achieved_walk_vel, l_17_0._last_velocity_xy, new_move_vec, 700 * l_17_2)
      else
        mvector3.multiply(mvec_move_dir_normalized, wanted_walk_speed)
        mvector3.step(achieved_walk_vel, l_17_0._last_velocity_xy, wanted_walk_speed * l_17_0._move_dir:normalized(), acceleration * l_17_2)
      end
      local fwd_component = nil
    else
      mvector3.multiply(mvec_move_dir_normalized, wanted_walk_speed)
      mvector3.step(achieved_walk_vel, l_17_0._last_velocity_xy, mvec_move_dir_normalized, acceleration * l_17_2)
    end
    if mvector3.is_zero(l_17_0._last_velocity_xy) then
      mvector3.set_length(achieved_walk_vel, math.max(achieved_walk_vel:length(), 100))
    end
    pos_new = mvec_pos_new
    mvector3.set(pos_new, achieved_walk_vel)
    mvector3.multiply(pos_new, l_17_2)
    mvector3.add(pos_new, l_17_0._pos)
    l_17_0._target_headbob = l_17_0:_get_walk_headbob()
    l_17_0._target_headbob = l_17_0._target_headbob * l_17_0._move_dir:length()
  else
    if not mvector3.is_zero(l_17_0._last_velocity_xy) then
      if not l_17_0._state_data.in_air or not 250 then
        local decceleration = math.lerp(2000, 1500, math.min(l_17_0._last_velocity_xy:length() / tweak_data.player.movement_state.standard.movement.speed.RUNNING_MAX, 1))
      end
      local achieved_walk_vel = math.step(l_17_0._last_velocity_xy, Vector3(), decceleration * l_17_2)
      pos_new = mvec_pos_new
      mvector3.set(pos_new, achieved_walk_vel)
      mvector3.multiply(pos_new, l_17_2)
      mvector3.add(pos_new, l_17_0._pos)
      l_17_0._target_headbob = 0
    elseif l_17_0._moving then
      l_17_0._target_headbob = 0
      l_17_0._moving = false
      l_17_0:_update_crosshair_offset()
    end
  end
  if l_17_0._headbob ~= l_17_0._target_headbob then
    l_17_0._headbob = math.step(l_17_0._headbob, l_17_0._target_headbob, l_17_2 / 4)
    l_17_0._ext_camera:set_shaker_parameter("headbob", "amplitude", l_17_0._headbob)
  end
  if pos_new then
    l_17_0._unit:movement():set_position(pos_new)
    mvector3.set(l_17_0._last_velocity_xy, pos_new)
    mvector3.subtract(l_17_0._last_velocity_xy, l_17_0._pos)
    mvector3.set_z(l_17_0._last_velocity_xy, 0)
    mvector3.divide(l_17_0._last_velocity_xy, l_17_2)
  else
    mvector3.set_static(l_17_0._last_velocity_xy, 0, 0, 0)
  end
  if not pos_new then
    local cur_pos = l_17_0._pos
  end
  local move_dis = mvector3.distance_sq(cur_pos, l_17_0._last_sent_pos)
  if move_dis > 22500 or move_dis > 400 and (l_17_1 - l_17_0._last_sent_pos_t > 1.5 or not pos_new) then
    l_17_0._ext_network:send("action_walk_nav_point", cur_pos)
    mvector3.set(l_17_0._last_sent_pos, cur_pos)
    l_17_0._last_sent_pos_t = l_17_1
    if l_17_0._move_dir and l_17_0._running and not l_17_0._state_data.ducking and not managers.groupai:state():enemy_weapons_hot() then
      local alert_epicenter = mvector3.copy(l_17_0._last_sent_pos)
      mvector3.set_z(alert_epicenter, alert_epicenter.z + 150)
      local alert_rad = 450 * mvector3.length(l_17_0._move_dir)
      local footstep_alert = {"footstep", alert_epicenter, alert_rad, managers.groupai:state():get_unit_type_filter("civilians_enemies"), l_17_0._unit}
      managers.groupai:state():propagate_alert(footstep_alert)
    end
  end
end

PlayerStandard._get_walk_headbob = function(l_18_0)
  if l_18_0._state_data.in_steelsight then
    return 0
  else
    if l_18_0._state_data.in_air then
      return 0
    else
      if l_18_0._state_data.ducking then
        return 0.012500000186265
      elseif l_18_0._running then
        return 0.10000000149012
      end
    end
  end
  return 0.025000000372529
end

PlayerStandard._update_foley = function(l_19_0, l_19_1, l_19_2)
  if not l_19_0._gnd_ray and not l_19_0._state_data.in_air then
    l_19_0._state_data.in_air = true
    l_19_0._state_data.enter_air_pos_z = l_19_0._pos.z
    l_19_0:_interupt_action_running(l_19_1)
    l_19_0._unit:set_driving("orientation_object")
    do return end
    if l_19_0._state_data.in_air then
      l_19_0._unit:set_driving("script")
      l_19_0._state_data.in_air = false
      local from = l_19_0._pos + math.UP * 10
      local to = l_19_0._pos - math.UP * 60
      local material_name, pos, norm = World:pick_decal_material(from, to, l_19_0._slotmask_bullet_impact_targets)
      l_19_0._unit:sound():play_land(material_name)
      if l_19_0._unit:character_damage():damage_fall({height = l_19_0._state_data.enter_air_pos_z - l_19_0._pos.z}) then
        l_19_0._running_wanted = false
        managers.rumble:play("hard_land")
        l_19_0._ext_camera:play_shaker("player_fall_damage")
        l_19_0:_start_action_ducking(l_19_1)
      elseif l_19_2.btn_run_state then
        l_19_0._running_wanted = true
      end
      l_19_0._jump_t = nil
      l_19_0._jump_vel_xy = nil
      l_19_0._ext_camera:play_shaker("player_land", 0.5)
      managers.rumble:play("land")
    elseif l_19_0._jump_vel_xy and l_19_1 - l_19_0._jump_t > 0.30000001192093 then
      l_19_0._jump_vel_xy = nil
      if l_19_2.btn_run_state then
        l_19_0._running_wanted = true
      end
    end
  end
  l_19_0:_check_step(l_19_1)
end

PlayerStandard._check_step = function(l_20_0, l_20_1)
  if l_20_0._state_data.in_air then
    return 
  end
  if not l_20_0._last_step_pos then
    l_20_0._last_step_pos = Vector3()
  end
  local step_length = ((not l_20_0._state_data.in_steelsight or not 100) and (not l_20_0._state_data.ducking or not 125) and (l_20_0._running and 175)) or 150
  if step_length * step_length < mvector3.distance_sq(l_20_0._last_step_pos, l_20_0._pos) then
    mvector3.set(l_20_0._last_step_pos, l_20_0._pos)
    l_20_0._unit:base():anim_data_clbk_footstep()
  end
end

PlayerStandard._update_crosshair_offset = function(l_21_0, l_21_1)
  return 
  if not alive(l_21_0._equipped_unit) then
    return 
  end
  local name_id = l_21_0._equipped_unit:base():get_name_id()
  if not tweak_data.weapon[name_id].crosshair then
    return 
  end
  if l_21_0._state_data.in_steelsight then
    managers.hud:set_crosshair_visible(not tweak_data.weapon[name_id].crosshair.steelsight.hidden)
    managers.hud:set_crosshair_offset(tweak_data.weapon[name_id].crosshair.steelsight.offset)
    return 
  end
  local spread_multiplier = l_21_0._equipped_unit:base():spread_multiplier()
  managers.hud:set_crosshair_visible(not tweak_data.weapon[name_id].crosshair[l_21_0._state_data.ducking and "crouching" or "standing"].hidden)
   -- DECOMPILER ERROR: Confused while interpreting a jump as a 'while'

end
managers.hud:set_crosshair_offset(tweak_data.weapon[name_id].crosshair[not l_21_0._moving or "standing"].moving_offset * spread_multiplier)
return 

end

PlayerStandard._stance_entered = function(l_22_0, l_22_1)
  if not tweak_data.player.stances.default[managers.player:current_state()] then
    local stance_standard = tweak_data.player.stances.default.standard
  end
  if not l_22_0._state_data.ducking or not tweak_data.player.stances.default.crouched.head then
    local head_stance = stance_standard.head
  end
  local weapon_id = nil
  local stance_mod = {translation = Vector3(0, 0, 0)}
  if not l_22_1 then
    weapon_id = l_22_0._equipped_unit:base():get_name_id()
  if not l_22_0._state_data.in_steelsight or not l_22_0._equipped_unit:base().stance_mod or not l_22_0._equipped_unit:base():stance_mod() then
    end
  end
  if not tweak_data.player.stances[weapon_id] then
    local stances = tweak_data.player.stances.default
  end
  if (not l_22_0._state_data.in_steelsight or not stances.steelsight) and (not l_22_0._state_data.ducking or not stances.crouched) then
    local misc_attribs = stances.standard
  end
  local duration = tweak_data.player.TRANSITION_DURATION + (l_22_0._equipped_unit:base():transition_duration() or 0)
  local duration_multiplier = l_22_0._state_data.in_steelsight and 1 / l_22_0._equipped_unit:base():enter_steelsight_speed_multiplier() or 1
  local new_fov = l_22_0:get_zoom_fov(misc_attribs) + 0
  l_22_0._camera_unit:base():clbk_stance_entered(misc_attribs.shoulders, head_stance, misc_attribs.vel_overshot, new_fov, misc_attribs.shakers, stance_mod, duration_multiplier, duration)
  managers.menu:set_mouse_sensitivity(new_fov < misc_attribs.FOV or 75)
end

PlayerStandard.update_fov_external = function(l_23_0)
  if not alive(l_23_0._equipped_unit) then
    return 
  end
  local weapon_id = l_23_0._equipped_unit:base():get_name_id()
  if not tweak_data.player.stances[weapon_id] then
    local stances = tweak_data.player.stances.default
  end
  if (not l_23_0._state_data.in_steelsight or not stances.steelsight) and (not l_23_0._state_data.ducking or not stances.crouched) then
    local misc_attribs = stances.standard
  end
  local new_fov = l_23_0:get_zoom_fov(misc_attribs) + 0
  l_23_0._camera_unit:base():set_fov_instant(new_fov)
end

PlayerStandard._get_max_walk_speed = function(l_24_0, l_24_1)
  if l_24_0._state_data.in_steelsight then
    return l_24_0._tweak_data.movement.speed.STEELSIGHT_MAX
  end
  if l_24_0._state_data.ducking then
    return l_24_0._tweak_data.movement.speed.CROUCHING_MAX * managers.player:upgrade_value("player", "crouch_speed_multiplier", 1)
  end
  if l_24_0._state_data.in_air then
    return l_24_0._tweak_data.movement.speed.INAIR_MAX
  end
  local morale_boost_bonus = l_24_0._ext_movement:morale_boost()
  morale_boost_bonus = morale_boost_bonus and morale_boost_bonus.move_speed_bonus or 1
  do
    local armor_penalty = managers.player:body_armor_movement_penalty()
    if not l_24_0._running or not l_24_0._tweak_data.movement.speed.RUNNING_MAX * managers.player:upgrade_value("player", "run_speed_multiplier", 1) then
      return l_24_0._tweak_data.movement.speed.STANDARD_MAX * managers.player:upgrade_value("player", "walk_speed_multiplier", 1) * (morale_boost_bonus) * armor_penalty
    end
     -- Warning: missing end command somewhere! Added here
  end
end

PlayerStandard._start_action_steelsight = function(l_25_0, l_25_1)
  if l_25_0:_changing_weapon() or l_25_0:_is_reloading() or l_25_0:_interacting() or l_25_0._melee_expire_t or l_25_0._use_item_expire_t then
    l_25_0._steelsight_wanted = true
    return 
  end
  if l_25_0._running and not l_25_0._end_running_expire_t then
    l_25_0:_interupt_action_running(l_25_1)
    l_25_0._steelsight_wanted = true
    return 
  end
  l_25_0:_break_intimidate_redirect()
  l_25_0._steelsight_wanted = false
  l_25_0._state_data.in_steelsight = true
  l_25_0:_update_crosshair_offset()
  l_25_0:_stance_entered()
  l_25_0:_interupt_action_running(l_25_1)
  l_25_0._equipped_unit:base():play_tweak_data_sound("enter_steelsight")
  if managers.controller:get_default_wrapper_type() ~= "pc" and managers.user:get_setting("aim_assist") then
    local closest_ray = l_25_0._equipped_unit:base():check_autoaim(l_25_0._ext_camera:position(), (l_25_0._ext_camera:forward()), nil, true)
    l_25_0._camera_unit:base():clbk_aim_assist(closest_ray)
  end
  l_25_0._ext_network:send("set_stance", 3)
end

PlayerStandard._end_action_steelsight = function(l_26_0, l_26_1)
  l_26_0._state_data.in_steelsight = false
  l_26_0:_stance_entered()
  l_26_0:_update_crosshair_offset()
  l_26_0._equipped_unit:base():play_tweak_data_sound("leave_steelsight")
  l_26_0._camera_unit:base():clbk_stop_aim_assist()
  l_26_0._ext_network:send("set_stance", 2)
end

PlayerStandard._interupt_action_steelsight = function(l_27_0, l_27_1)
  l_27_0._steelsight_wanted = false
  if l_27_0._state_data.in_steelsight then
    l_27_0:_end_action_steelsight(l_27_1)
  end
end

PlayerStandard._start_action_running = function(l_28_0, l_28_1)
  if not l_28_0._move_dir then
    l_28_0._running_wanted = true
    return 
  end
  if l_28_0._shooting or l_28_0:_changing_weapon() or l_28_0._melee_expire_t or l_28_0._use_item_expire_t or l_28_0._state_data.in_air then
    l_28_0._running_wanted = true
    return 
  end
  if l_28_0._state_data.ducking and not l_28_0:_can_stand() then
    l_28_0._running_wanted = true
    return 
  end
  if not l_28_0:_can_run_directional() then
    return 
  end
  l_28_0._running_wanted = false
  if managers.player:get_player_rule("no_run") then
    return 
  end
  if not l_28_0._unit:movement():is_above_stamina_threshold() then
    return 
  end
  l_28_0:set_running(true)
  l_28_0._end_running_expire_t = nil
  l_28_0._start_running_t = l_28_1
  l_28_0._ext_camera:play_redirect(l_28_0.IDS_START_RUNNING)
  l_28_0:_interupt_action_reload(l_28_1)
  l_28_0:_interupt_action_steelsight(l_28_1)
  l_28_0:_interupt_action_ducking(l_28_1)
end

PlayerStandard._end_action_running = function(l_29_0, l_29_1)
  if not l_29_0._end_running_expire_t then
    local speed_multiplier = l_29_0._equipped_unit:base():exit_run_speed_multiplier()
    l_29_0._end_running_expire_t = l_29_1 + 0.40000000596046 / speed_multiplier
    l_29_0._ext_camera:play_redirect(l_29_0.IDS_STOP_RUNNING, speed_multiplier)
  end
end

PlayerStandard._interupt_action_running = function(l_30_0, l_30_1)
  if l_30_0._running and not l_30_0._end_running_expire_t then
    l_30_0:_end_action_running(l_30_1)
  end
end

PlayerStandard._start_action_ducking = function(l_31_0, l_31_1)
  if l_31_0:_interacting() then
    return 
  end
  l_31_0:_interupt_action_running(l_31_1)
  l_31_0._state_data.ducking = true
  l_31_0:_stance_entered()
  l_31_0:_update_crosshair_offset()
  local velocity = l_31_0._unit:mover():velocity()
  l_31_0._unit:kill_mover()
  l_31_0._unit:activate_mover(PlayerStandard.MOVER_DUCK, velocity)
  l_31_0._ext_network:send("set_pose", 2)
  local crh_attention = nil
  if managers.groupai:state():whisper_mode() then
    crh_attention = "pl_enemy_sneak"
  else
    crh_attention = "pl_enemy_cbt_crh"
  end
  l_31_0._ext_movement:set_attention_settings({crh_attention, "pl_team_idle_std", "pl_civ_sneak"})
end

PlayerStandard._end_action_ducking = function(l_32_0, l_32_1)
  if not l_32_0:_can_stand() then
    return 
  end
  l_32_0._state_data.ducking = false
  l_32_0:_stance_entered()
  l_32_0:_update_crosshair_offset()
  local velocity = l_32_0._unit:mover():velocity()
  l_32_0._unit:kill_mover()
  l_32_0._unit:activate_mover(PlayerStandard.MOVER_STAND, velocity)
  l_32_0._ext_network:send("set_pose", 1)
  l_32_0._ext_movement:set_attention_settings({"pl_enemy_cbt", "pl_team_idle_std", "pl_civ_cbt"})
end

PlayerStandard._interupt_action_ducking = function(l_33_0, l_33_1)
  if l_33_0._state_data.ducking then
    l_33_0:_end_action_ducking(l_33_1)
  end
end

PlayerStandard._can_stand = function(l_34_0)
  local offset = 50
  local radius = 30
  local hips_pos = l_34_0._obj_com:position() + math.UP * offset
  local up_pos = math.UP * (160 - offset)
  mvector3.add(up_pos, hips_pos)
  local ray = World:raycast("ray", hips_pos, up_pos, "slot_mask", l_34_0._slotmask_gnd_ray, "ray_type", "body mover", "sphere_cast_radius", radius, "bundle", 20)
  if ray then
    managers.hint:show_hint("cant_stand_up", 2)
    return false
  end
  return true
end

PlayerStandard._can_run_directional = function(l_35_0)
  if managers.player:has_category_upgrade("player", "can_free_run") then
    return true
  end
  local running_angle = managers.player:has_category_upgrade("player", "can_strafe_run") and 92 or 50
  return mvector3.angle(l_35_0._stick_move, math.Y) <= running_angle
end

PlayerStandard._start_action_equip = function(l_36_0, l_36_1, l_36_2)
  local tweak_data = l_36_0._equipped_unit:base():weapon_tweak_data()
  l_36_0._equip_weapon_expire_t = managers.player:player_timer():time() + ((tweak_data.timers.equip or 0.69999998807907) + (l_36_2 or 0))
  if not l_36_1 then
    local result = l_36_0._ext_camera:play_redirect(l_36_0.IDS_EQUIP)
  end
end

PlayerStandard._check_action_interact = function(l_37_0, l_37_1, l_37_2)
  local new_action, timer, interact_object = nil, nil, nil
  local interaction_wanted = l_37_2.btn_interact_press
  if interaction_wanted then
    if not l_37_0:chk_action_forbidden("interact") and not l_37_0._unit:base():stats_screen_visible() and not l_37_0:_interacting() and not l_37_0._ext_movement:has_carry_restriction() and not l_37_0:is_deploying() then
      local action_forbidden = l_37_0:_changing_weapon()
    end
    if not action_forbidden then
      new_action, timer, interact_object = managers.interaction:interact(l_37_0._unit)
      if new_action then
        l_37_0:_play_interact_redirect(l_37_1, l_37_2)
      end
      if timer then
        new_action = true
        l_37_0._ext_camera:camera_unit():base():set_limits(80, 50)
        l_37_0:_start_action_interact(l_37_1, l_37_2, timer, interact_object)
      end
      if not new_action then
        new_action = l_37_0:_start_action_intimidate(l_37_1)
      end
    end
  end
  if l_37_2.btn_interact_release then
    l_37_0:_interupt_action_interact()
  end
  return new_action
end

PlayerStandard._start_action_interact = function(l_38_0, l_38_1, l_38_2, l_38_3, l_38_4)
  l_38_0:_interupt_action_reload(l_38_1)
  l_38_0:_interupt_action_steelsight(l_38_1)
  l_38_0:_interupt_action_running(l_38_1)
  l_38_0._interact_expire_t = l_38_1 + l_38_3
  l_38_0._interact_params = {object = l_38_4, timer = l_38_3, tweak_data = l_38_4:interaction().tweak_data}
  l_38_0._ext_camera:play_redirect(l_38_0.IDS_UNEQUIP)
  l_38_0._equipped_unit:base():tweak_data_anim_play("unequip")
  managers.hud:show_interaction_bar(0, l_38_3)
  l_38_0._unit:base():set_detection_multiplier("interact", 0.5)
  managers.network:session():send_to_peers_loaded("sync_teammate_progress", 1, true, l_38_0._interact_params.tweak_data, l_38_3, false)
end

PlayerStandard._interupt_action_interact = function(l_39_0, l_39_1, l_39_2, l_39_3)
  if l_39_0._interact_expire_t then
    l_39_0._interact_expire_t = nil
    if alive(l_39_0._interact_params.object) then
      l_39_0._interact_params.object:interaction():interact_interupt(l_39_0._unit, l_39_3)
    end
    l_39_0._ext_camera:camera_unit():base():remove_limits()
    managers.interaction:interupt_action_interact(l_39_0._unit)
     -- DECOMPILER ERROR: Confused while interpreting a jump as a 'while'

  end
  managers.network:session():send_to_peers_loaded("sync_teammate_progress", 1, false, l_39_0._interact_params.tweak_data, 0, true)
  l_39_0._interact_params = nil
  local tweak_data = l_39_0._equipped_unit:base():weapon_tweak_data()
  l_39_0._equip_weapon_expire_t = managers.player:player_timer():time() + (tweak_data.timers.equip or 0.69999998807907)
  local result = l_39_0._ext_camera:play_redirect(l_39_0.IDS_EQUIP)
  managers.hud:hide_interaction_bar(l_39_3)
  l_39_0._equipped_unit:base():tweak_data_anim_stop("unequip")
  l_39_0._unit:base():set_detection_multiplier("interact", nil)
end
end

PlayerStandard._end_action_interact = function(l_40_0)
  l_40_0:_interupt_action_interact(nil, nil, true)
  managers.interaction:end_action_interact(l_40_0._unit)
  l_40_0._unit:base():set_detection_multiplier("interact", nil)
end

PlayerStandard._interacting = function(l_41_0)
  return l_41_0._interact_expire_t
end

PlayerStandard._update_interaction_timers = function(l_42_0, l_42_1)
  if l_42_0._interact_expire_t then
    if not alive(l_42_0._interact_params.object) or l_42_0._interact_params.object ~= managers.interaction:active_object() or l_42_0._interact_params.tweak_data ~= l_42_0._interact_params.object:interaction().tweak_data then
      l_42_0:_interupt_action_interact(l_42_1)
    else
      managers.hud:set_interaction_bar_width(l_42_0._interact_params.timer - (l_42_0._interact_expire_t - l_42_1), l_42_0._interact_params.timer)
      if l_42_0._interact_expire_t <= l_42_1 then
        l_42_0:_end_action_interact(l_42_1)
        l_42_0._interact_expire_t = nil
      end
    end
  end
end

PlayerStandard._check_action_weapon_gadget = function(l_43_0, l_43_1, l_43_2)
  if l_43_2.btn_weapon_gadget_press and l_43_0._equipped_unit:base().toggle_gadget and l_43_0._equipped_unit:base():has_gadget() then
    l_43_0._equipped_unit:base():toggle_gadget()
    l_43_0._unit:network():send("set_weapon_gadget_state", l_43_0._equipped_unit:base()._gadget_on)
  end
end

PlayerStandard._check_action_melee = function(l_44_0, l_44_1, l_44_2)
  local action_wanted = l_44_2.btn_melee_press
  if not action_wanted then
    return 
  end
  if not l_44_0._melee_expire_t and not l_44_0._use_item_expire_t and not l_44_0:_changing_weapon() then
    local action_forbidden = l_44_0:_interacting()
  end
  if action_forbidden then
    return 
  end
  l_44_0._equipped_unit:base():tweak_data_anim_stop("fire")
  l_44_0:_interupt_action_reload(l_44_1)
  l_44_0:_interupt_action_steelsight(l_44_1)
  l_44_0:_interupt_action_running(l_44_1)
  managers.network:session():send_to_peers("play_distance_interact_redirect", l_44_0._unit, "melee")
  l_44_0._ext_camera:play_shaker("player_melee")
  l_44_0._melee_expire_t = l_44_1 + 0.60000002384186
  local range = 175
  local from = l_44_0._unit:movement():m_head_pos()
  local to = from + l_44_0._unit:movement():m_head_rot():y() * range
  local sphere_cast_radius = 20
  do
    local col_ray = l_44_0._unit:raycast("ray", from, to, "slot_mask", l_44_0._slotmask_bullet_impact_targets, "sphere_cast_radius", sphere_cast_radius, "ray_type", "body melee")
    if col_ray then
      l_44_0._ext_camera:play_redirect(l_44_0.IDS_MELEE)
      local damage, damage_effect = l_44_0._equipped_unit:base():melee_damage_info()
      damage_effect = damage_effect * managers.player:upgrade_value("player", "melee_knockdown_mul", 1)
      col_ray.sphere_cast_radius = sphere_cast_radius
      local hit_unit = col_ray.unit
      if not hit_unit:character_damage() or not hit_unit:character_damage()._no_blood then
        managers.game_play_central:play_impact_flesh({col_ray = col_ray})
      end
      if hit_unit:character_damage() then
        l_44_0._unit:sound():play("melee_hit_body", nil, false)
      end
      if hit_unit:damage() and col_ray.body:extension() and col_ray.body:extension().damage then
        col_ray.body:extension().damage:damage_melee(l_44_0._unit, col_ray.normal, col_ray.position, col_ray.direction, damage)
        if hit_unit:id() ~= -1 then
          managers.network:session():send_to_peers_synched("sync_body_damage_melee", col_ray.body, l_44_0._unit, col_ray.normal, col_ray.position, col_ray.direction, damage)
        end
      end
      managers.rumble:play("melee_hit")
      managers.game_play_central:physics_push(col_ray)
      local character_unit, shield_knock = nil, nil
      local can_shield_knock = managers.player:has_category_upgrade("player", "shield_knock")
      if can_shield_knock and hit_unit:in_slot(8) and alive(hit_unit:parent()) then
        shield_knock = true
        character_unit = hit_unit:parent()
      end
      if not character_unit then
        character_unit = hit_unit
      end
      if character_unit:character_damage() and character_unit:character_damage().damage_melee then
        local dmg_multiplier = 1
        if not managers.enemy:is_civilian(character_unit) and not managers.groupai:state():is_enemy_special(character_unit) then
          dmg_multiplier = dmg_multiplier * managers.player:upgrade_value("player", "non_special_melee_multiplier", 1)
        end
        dmg_multiplier = dmg_multiplier * managers.player:upgrade_value("player", "melee_damage_multiplier", 1)
        local health_ratio = l_44_0._ext_damage:health_ratio()
        if health_ratio <= tweak_data.upgrades.player_damage_health_ratio_threshold then
          local damage_ratio = 1 - health_ratio / math.max(0.0099999997764826, tweak_data.upgrades.player_damage_health_ratio_threshold)
          dmg_multiplier = dmg_multiplier * (1 + managers.player:upgrade_value("player", "melee_damage_health_ratio_multiplier", 0) * damage_ratio)
        end
        local action_data = {}
        action_data.variant = "melee"
        if not shield_knock or not 0 then
          action_data.damage = damage * (dmg_multiplier)
        end
        action_data.damage_effect = damage_effect
        action_data.attacker_unit = l_44_0._unit
        action_data.col_ray = col_ray
        action_data.shield_knock = can_shield_knock
        local defense_data = character_unit:character_damage():damage_melee(action_data)
        return defense_data
      end
      damage = true
      return damage
    end
     -- Warning: missing end command somewhere! Added here
  end
end

PlayerStandard._interupt_action_melee = function(l_45_0, l_45_1)
  l_45_0._melee_expire_t = nil
end

PlayerStandard._update_melee_timers = function(l_46_0, l_46_1, l_46_2)
  if l_46_0._melee_expire_t and l_46_0._melee_expire_t <= l_46_1 then
    l_46_0._melee_expire_t = nil
    if l_46_0._equipped_unit and l_46_2.btn_steelsight_state then
      l_46_0._steelsight_wanted = true
    end
  end
end

PlayerStandard._check_action_reload = function(l_47_0, l_47_1, l_47_2)
  local new_action = nil
  local action_wanted = l_47_2.btn_reload_press
  if action_wanted then
    if not l_47_0:_is_reloading() and not l_47_0:_changing_weapon() and not l_47_0._melee_expire_t and not l_47_0._use_item_expire_t then
      local action_forbidden = l_47_0:_interacting()
    end
    if not action_forbidden and l_47_0._equipped_unit and not l_47_0._equipped_unit:base():clip_full() then
      l_47_0:_start_action_reload_enter(l_47_1)
      new_action = true
    end
  end
  return new_action
end

PlayerStandard._update_reload_timers = function(l_48_0, l_48_1, l_48_2, l_48_3)
  if l_48_0._state_data.reload_enter_expire_t and l_48_0._state_data.reload_enter_expire_t <= l_48_1 then
    l_48_0._state_data.reload_enter_expire_t = nil
    l_48_0:_start_action_reload(l_48_1)
  end
  if l_48_0._state_data.reload_expire_t then
    local interupt = nil
    if l_48_0._equipped_unit:base():update_reloading(l_48_1, l_48_2, l_48_0._state_data.reload_expire_t - l_48_1) then
      managers.hud:set_ammo_amount(l_48_0._equipped_unit:base():selection_index(), l_48_0._equipped_unit:base():ammo_info())
      local speed_multiplier = l_48_0._equipped_unit:base():reload_speed_multiplier()
      if l_48_0._queue_reload_interupt then
        l_48_0._queue_reload_interupt = nil
        interupt = true
      end
    end
    if l_48_0._state_data.reload_expire_t <= l_48_1 or interupt then
      l_48_0._state_data.reload_expire_t = nil
      if l_48_0._equipped_unit:base():reload_exit_expire_t() then
        local speed_multiplier = l_48_0._equipped_unit:base():reload_speed_multiplier()
        if l_48_0._equipped_unit:base():started_reload_empty() then
          l_48_0._state_data.reload_exit_expire_t = l_48_1 + l_48_0._equipped_unit:base():reload_exit_expire_t() / speed_multiplier
          l_48_0._ext_camera:play_redirect(l_48_0.IDS_RELOAD_EXIT, speed_multiplier)
          l_48_0._equipped_unit:base():tweak_data_anim_play("reload_exit", speed_multiplier)
        else
          l_48_0._state_data.reload_exit_expire_t = l_48_1 + l_48_0._equipped_unit:base():reload_not_empty_exit_expire_t() / speed_multiplier
          l_48_0._ext_camera:play_redirect(l_48_0.IDS_RELOAD_NOT_EMPTY_EXIT, speed_multiplier)
        end
      elseif l_48_0._equipped_unit then
        if not interupt then
          l_48_0._equipped_unit:base():on_reload()
        end
        managers.statistics:reloaded()
        managers.hud:set_ammo_amount(l_48_0._equipped_unit:base():selection_index(), l_48_0._equipped_unit:base():ammo_info())
        if l_48_3.btn_steelsight_state then
          l_48_0._steelsight_wanted = true
        end
      end
    end
  end
end
if l_48_0._state_data.reload_exit_expire_t and l_48_0._state_data.reload_exit_expire_t <= l_48_1 then
  l_48_0._state_data.reload_exit_expire_t = nil
  if l_48_0._equipped_unit then
    managers.statistics:reloaded()
    managers.hud:set_ammo_amount(l_48_0._equipped_unit:base():selection_index(), l_48_0._equipped_unit:base():ammo_info())
    if l_48_3.btn_steelsight_state then
      l_48_0._steelsight_wanted = true
    end
  end
end
end

PlayerStandard._check_use_item = function(l_49_0, l_49_1, l_49_2)
  local new_action = nil
  local action_wanted = l_49_2.btn_use_item_press
  if action_wanted then
    if not l_49_0._use_item_expire_t and not l_49_0:_interacting() then
      local action_forbidden = l_49_0:_changing_weapon()
    end
    if not action_forbidden and managers.player:can_use_selected_equipment(l_49_0._unit) then
      l_49_0:_start_action_use_item(l_49_1)
      new_action = true
    end
  end
  if l_49_2.btn_use_item_release then
    l_49_0:_interupt_action_use_item()
  end
  return new_action
end

PlayerStandard._update_use_item_timers = function(l_50_0, l_50_1, l_50_2)
  if l_50_0._use_item_expire_t then
    local valid = managers.player:check_selected_equipment_placement_valid(l_50_0._unit)
    local deploy_timer = managers.player:selected_equipment_deploy_timer()
    managers.hud:set_progress_timer_bar_valid(valid, (not valid and "hud_deploy_valid_help"))
    managers.hud:set_progress_timer_bar_width(deploy_timer - (l_50_0._use_item_expire_t - l_50_1), deploy_timer)
    if l_50_0._use_item_expire_t <= l_50_1 then
      l_50_0:_end_action_use_item(valid)
      l_50_0._use_item_expire_t = nil
    end
  end
end

PlayerStandard.is_deploying = function(l_51_0)
   -- DECOMPILER ERROR: Confused while interpreting a jump as a 'while'

end
return true
end

PlayerStandard._start_action_use_item = function(l_52_0, l_52_1)
  l_52_0:_interupt_action_reload(l_52_1)
  l_52_0:_interupt_action_steelsight(l_52_1)
  l_52_0:_interupt_action_running(l_52_1)
  local deploy_timer = managers.player:selected_equipment_deploy_timer()
  l_52_0._use_item_expire_t = l_52_1 + deploy_timer
  l_52_0._ext_camera:play_redirect(l_52_0.IDS_UNEQUIP)
  l_52_0._equipped_unit:base():tweak_data_anim_play("unequip")
  managers.hud:show_progress_timer_bar(0, deploy_timer)
  local text = managers.localization:text("hud_deploying_equipment", {EQUIPMENT = managers.player:selected_equipment_name()})
  managers.hud:show_progress_timer({text = text, icon = nil})
  local equipment_id = managers.player:selected_equipment_id()
  managers.network:session():send_to_peers_loaded("sync_teammate_progress", 2, true, equipment_id, deploy_timer, false)
end

PlayerStandard._end_action_use_item = function(l_53_0, l_53_1)
  local result = managers.player:use_selected_equipment(l_53_0._unit)
  l_53_0:_interupt_action_use_item(nil, nil, l_53_1)
end

PlayerStandard._interupt_action_use_item = function(l_54_0, l_54_1, l_54_2, l_54_3)
  if l_54_0._use_item_expire_t then
    l_54_0._use_item_expire_t = nil
    local tweak_data = l_54_0._equipped_unit:base():weapon_tweak_data()
    l_54_0._equip_weapon_expire_t = managers.player:player_timer():time() + (tweak_data.timers.equip or 0.69999998807907)
    local result = l_54_0._ext_camera:play_redirect(l_54_0.IDS_EQUIP)
    l_54_0._equipped_unit:base():tweak_data_anim_stop("unequip")
    managers.hud:hide_progress_timer_bar(l_54_3)
    managers.hud:remove_progress_timer()
    l_54_0._unit:equipment():on_deploy_interupted()
     -- DECOMPILER ERROR: Confused while interpreting a jump as a 'while'

  end
  managers.network:session():send_to_peers_loaded("sync_teammate_progress", 2, false, "", 0, true)
end
end

PlayerStandard._check_change_weapon = function(l_55_0, l_55_1, l_55_2)
  local new_action = nil
  local action_wanted = l_55_2.btn_switch_weapon_press
  if action_wanted then
    local action_forbidden = l_55_0:_changing_weapon()
    if not action_forbidden and not l_55_0._melee_expire_t and not l_55_0._use_item_expire_t then
      action_forbidden = l_55_0._change_item_expire_t
    end
     -- DECOMPILER ERROR: unhandled construct in 'if'

    if not action_forbidden and l_55_0._unit:inventory():num_selections() ~= 1 then
      action_forbidden = l_55_0:_interacting()
      action_forbidden = action_forbidden
    end
    if not action_forbidden then
      local data = {}
      data.next = true
      l_55_0._change_weapon_pressed_expire_t = l_55_1 + 0.33000001311302
      l_55_0:_start_action_unequip_weapon(l_55_1, data)
      new_action = true
    end
  end
  return new_action
end

PlayerStandard._update_equip_weapon_timers = function(l_56_0, l_56_1, l_56_2)
  if l_56_0._unequip_weapon_expire_t and l_56_0._unequip_weapon_expire_t <= l_56_1 then
    l_56_0._unequip_weapon_expire_t = nil
    l_56_0:_start_action_equip_weapon(l_56_1)
  end
  if l_56_0._equip_weapon_expire_t and l_56_0._equip_weapon_expire_t <= l_56_1 then
    l_56_0._equip_weapon_expire_t = nil
    if l_56_2.btn_steelsight_state then
      l_56_0._steelsight_wanted = true
    end
  end
end

PlayerStandard.is_equipping = function(l_57_0)
  return l_57_0._equip_weapon_expire_t
end

PlayerStandard._add_unit_to_char_table = function(l_58_0, l_58_1, l_58_2, l_58_3, l_58_4, l_58_5, l_58_6, l_58_7, l_58_8, l_58_9)
  if l_58_2:unit_data().disable_shout and not l_58_2:brain():interaction_voice() then
    return 
  end
  local u_head_pos = l_58_2:movement():m_head_pos() + math.UP * 30
  local vec = u_head_pos - l_58_8
  local dis = mvector3.normalize(vec)
  local max_dis = l_58_4
  local max_angle = math.max(8, math.lerp(dis >= max_dis or 90, ((not l_58_6 or l_58_6) and l_58_6 and 10) or 30, dis / 1200))
  local angle = vec:angle(l_58_9)
  if angle < max_angle then
    local ing_wgt = dis * dis * (1 - vec:dot(l_58_9)) / l_58_7
    if l_58_5 then
      table.insert(l_58_1, {unit = l_58_2, inv_wgt = ing_wgt, unit_type = l_58_3})
    else
      local ray = World:raycast("ray", l_58_8, u_head_pos, "slot_mask", l_58_0._slotmask_AI_visibility, "ray_type", "ai_vision")
      if not ray or mvector3.distance(ray.position, u_head_pos) < 30 then
        table.insert(l_58_1, {unit = l_58_2, inv_wgt = ing_wgt, unit_type = l_58_3})
      end
    end
  end
end

PlayerStandard._get_interaction_target = function(l_59_0, l_59_1, l_59_2, l_59_3)
  local prime_target = nil
  do
    local ray = World:raycast("ray", l_59_2, l_59_2 + l_59_3 * 100 * 100, "slot_mask", l_59_0._slotmask_long_distance_interaction)
    if ray then
      for _,char in pairs(l_59_1) do
        if ray.unit == char.unit then
          prime_target = char
      else
        end
      end
      if not prime_target then
        local low_wgt = nil
        for _,char in pairs(l_59_1) do
          local inv_wgt = char.inv_wgt
          if not low_wgt or inv_wgt < low_wgt then
            low_wgt = inv_wgt
            prime_target = char
          end
        end
      end
      return prime_target
    end
     -- Warning: missing end command somewhere! Added here
  end
end

PlayerStandard._get_intimidation_action = function(l_60_0, l_60_1, l_60_2, l_60_3, l_60_4, l_60_5)
  local voice_type, new_action, plural = nil, nil, nil
  local unit_type_enemy = 0
  local unit_type_civilian = 1
  local unit_type_teammate = 2
  local is_whisper_mode = managers.groupai:state():whisper_mode()
  if l_60_1 then
    if l_60_1.unit_type == unit_type_teammate then
      local is_human_player, record = nil, nil
      if not l_60_5 then
        record = managers.groupai:state():all_criminals()[l_60_1.unit:key()]
        if record.ai then
          l_60_1.unit:movement():set_cool(false)
          l_60_1.unit:brain():on_long_dis_interacted(0, l_60_0._unit)
        else
          is_human_player = true
        end
      end
      local amount = 0
      local rally_skill_data = l_60_0._ext_movement:rally_skill_data()
      if rally_skill_data and mvector3.distance_sq(l_60_0._pos, record.m_pos) < rally_skill_data.range_sq then
        local needs_revive, is_arrested = nil, nil
        if l_60_1.unit:movement():current_state_name() ~= "arrested" then
          is_arrested = not l_60_1.unit:base().is_husk_player
        end
        if l_60_1.unit:interaction():active() and l_60_1.unit:movement():need_revive() then
          needs_revive = not is_arrested
        end
        do return end
        is_arrested = l_60_1.unit:character_damage():arrested()
        needs_revive = l_60_1.unit:character_damage():need_revive()
        if needs_revive and rally_skill_data.long_dis_revive then
          voice_type = "revive"
        elseif not is_arrested and not needs_revive and rally_skill_data.morale_boost_delay_t and rally_skill_data.morale_boost_delay_t < managers.player:player_timer():time() then
          voice_type = "boost"
          amount = 1
        end
      end
      if is_human_player then
        l_60_1.unit:network():send_to_unit({"long_dis_interaction", l_60_1.unit, amount, l_60_0._unit})
      elseif voice_type == "revive" then
        do return end
      end
      if voice_type == "boost" then
        if Network:is_server() then
          l_60_1.unit:brain():on_long_dis_interacted(amount, l_60_0._unit)
        else
          managers.network:session():send_to_host("long_dis_interaction", l_60_1.unit, amount, l_60_0._unit)
        end
      end
      if not voice_type then
        voice_type = "come"
      end
      plural = false
    else
      local prime_target_key = l_60_1.unit:key()
      if l_60_1.unit_type == unit_type_enemy then
        plural = false
        if l_60_1.unit:anim_data().hands_back then
          voice_type = "cuff_cop"
        else
          if l_60_1.unit:anim_data().surrender then
            voice_type = "down_cop"
          elseif is_whisper_mode and l_60_1.unit:movement():cool() and tweak_data.character[l_60_1.unit:base()._tweak_table].silent_priority_shout then
            voice_type = "mark_cop_quiet"
          else
            if tweak_data.character[l_60_1.unit:base()._tweak_table].priority_shout then
              voice_type = "mark_cop"
            else
              voice_type = "stop_cop"
            end
          else
            if tweak_data.character[l_60_1.unit:base()._tweak_table].is_escort then
              plural = false
              local e_guy = l_60_1.unit
              if e_guy:anim_data().move then
                voice_type = "escort_keep"
              else
                if e_guy:anim_data().panic then
                  voice_type = "escort_go"
                else
                  voice_type = "escort"
                end
              else
                if l_60_1.unit:anim_data().move then
                  voice_type = "stop"
                else
                  if l_60_1.unit:anim_data().drop then
                    voice_type = "down_stay"
                  else
                    voice_type = "down"
                  end
                end
                local num_affected = 0
                for _,char in pairs(l_60_2) do
                  if char.unit_type == unit_type_civilian then
                    if voice_type == "stop" and char.unit:anim_data().move then
                      num_affected = num_affected + 1
                      for (for control),_ in (for generator) do
                      end
                      if voice_type == "down_stay" and char.unit:anim_data().drop then
                        num_affected = num_affected + 1
                        for (for control),_ in (for generator) do
                        end
                        if voice_type == "down" and not char.unit:anim_data().move and not char.unit:anim_data().drop then
                          num_affected = num_affected + 1
                        end
                      end
                    end
                     -- DECOMPILER ERROR: Confused while interpreting a jump as a 'while'

                  end
                  plural = true
                end
              end
            end
          end
        end
        local max_inv_wgt = 0
        for _,char in pairs(l_60_2) do
          if max_inv_wgt < char.inv_wgt then
            max_inv_wgt = char.inv_wgt
          end
        end
        if max_inv_wgt < 1 then
          max_inv_wgt = 1
        end
        if l_60_5 then
          voice_type = "come"
        else
          for _,char in pairs(l_60_2) do
            if char.unit_type ~= unit_type_teammate and (not is_whisper_mode or not char.unit:movement():cool()) then
              if char.unit_type == unit_type_civilian then
                 -- DECOMPILER ERROR: Confused while interpreting a jump as a 'while'

              end
              l_60_3 = tweak_data.player.long_dis_interaction.intimidate_strength * managers.player:upgrade_value("player", "civ_intimidation_mul", 1)
            end
            if (l_60_3 or not char.unit:brain():on_intimidated(tweak_data.player.long_dis_interaction.intimidate_strength, l_60_0._unit)) then
              for (for control),_ in (for generator) do
              end
              if not l_60_4 and char.unit_type ~= unit_type_enemy then
                 -- DECOMPILER ERROR: Confused while interpreting a jump as a 'while'

              end
              char.unit:brain():on_intimidated(tweak_data.player.long_dis_interaction.intimidate_strength * char.inv_wgt / max_inv_wgt, l_60_0._unit)
            end
          end
        end
      end
    end
  end
  return voice_type, plural, l_60_1
end

PlayerStandard._get_unit_intimidation_action = function(l_61_0, l_61_1, l_61_2, l_61_3, l_61_4, l_61_5, l_61_6, l_61_7, l_61_8)
  local char_table = {}
  local unit_type_enemy = 0
  local unit_type_civilian = 1
  local unit_type_teammate = 2
  local cam_fwd = l_61_0._ext_camera:forward()
  local my_head_pos = l_61_0._ext_movement:m_head_pos()
  local range_mul = managers.player:upgrade_value("player", "intimidate_range_mul", 1) * managers.player:upgrade_value("player", "passive_intimidate_range_mul", 1)
  local intimidate_range_civ = tweak_data.player.long_dis_interaction.intimidate_range_civilians * range_mul
  local intimidate_range_ene = tweak_data.player.long_dis_interaction.intimidate_range_enemies * range_mul
  local highlight_range = tweak_data.player.long_dis_interaction.highlight_range * range_mul
  if l_61_1 then
    local enemies = managers.enemy:all_enemies()
    for u_key,u_data in pairs(enemies) do
      if not u_data.is_converted and not u_data.unit:anim_data().hands_tied and (u_data.char_tweak.priority_shout or not l_61_4) then
        if managers.groupai:state():whisper_mode() then
          if u_data.char_tweak.silent_priority_shout and u_data.unit:movement():cool() then
            l_61_0:_add_unit_to_char_table(char_table, u_data.unit, unit_type_enemy, highlight_range, false, false, 0.0099999997764826, my_head_pos, cam_fwd)
            for (for control),u_key in (for generator) do
            end
            if not u_data.unit:movement():cool() then
              l_61_0:_add_unit_to_char_table(char_table, u_data.unit, unit_type_enemy, intimidate_range_ene, false, false, 10000, my_head_pos, cam_fwd)
              for (for control),u_key in (for generator) do
              end
              if u_data.char_tweak.priority_shout then
                l_61_0:_add_unit_to_char_table(char_table, u_data.unit, unit_type_enemy, highlight_range, false, false, 0.0099999997764826, my_head_pos, cam_fwd)
                for (for control),u_key in (for generator) do
                end
                l_61_0:_add_unit_to_char_table(char_table, u_data.unit, unit_type_enemy, intimidate_range_ene, false, false, 10000, my_head_pos, cam_fwd)
              end
            end
          end
        end
        if l_61_2 then
          local civilians = managers.enemy:all_civilians()
          for u_key,u_data in pairs(civilians) do
            if u_data.unit:in_slot(21) then
              local is_escort = u_data.char_tweak.is_escort
              if not is_escort or not 300 then
                local dist = is_escort and not l_61_5 or intimidate_range_civ
              end
              local prio = is_escort and 100000 or 0.0010000000474975
              l_61_0:_add_unit_to_char_table(char_table, u_data.unit, unit_type_civilian, dist, false, false, prio, my_head_pos, cam_fwd)
            end
          end
        end
        if l_61_3 and not managers.groupai:state():whisper_mode() then
          local criminals = managers.groupai:state():all_char_criminals()
          for u_key,u_data in pairs(criminals) do
            local added = nil
            if u_key ~= l_61_0._unit:key() then
              local rally_skill_data = l_61_0._ext_movement:rally_skill_data()
              if rally_skill_data and rally_skill_data.long_dis_revive and mvector3.distance_sq(l_61_0._pos, u_data.m_pos) < rally_skill_data.range_sq then
                local needs_revive = nil
                 -- DECOMPILER ERROR: unhandled construct in 'if'

                if u_data.unit:interaction():active() and u_data.unit:movement():need_revive() and u_data.unit:movement():current_state_name() == "arrested" then
                  needs_revive = not u_data.unit:base().is_husk_player
                  do return end
                end
                needs_revive = u_data.unit:character_damage():need_revive()
                if needs_revive then
                  added = true
                  l_61_0:_add_unit_to_char_table(char_table, u_data.unit, unit_type_teammate, 100000, true, true, 0.0099999997764826, my_head_pos, cam_fwd)
                end
              end
            end
            if not added and not u_data.is_deployable and not u_data.unit:movement():downed() and not u_data.unit:base().is_local_player then
              l_61_0:_add_unit_to_char_table(char_table, u_data.unit, unit_type_teammate, 100000, true, true, 0.0099999997764826, my_head_pos, cam_fwd)
            end
          end
        end
        do
          local prime_target = l_61_0:_get_interaction_target(char_table, my_head_pos, cam_fwd)
          return l_61_0:_get_intimidation_action(prime_target, char_table, l_61_6, l_61_7, l_61_8)
        end
         -- Warning: missing end command somewhere! Added here
      end
       -- Warning: missing end command somewhere! Added here
    end
     -- Warning: missing end command somewhere! Added here
  end
end

PlayerStandard._start_action_intimidate = function(l_62_0, l_62_1)
  if not l_62_0._intimidate_t or tweak_data.player.movement_state.interaction_delay < l_62_1 - l_62_0._intimidate_t then
    local skip_alert = managers.groupai:state():whisper_mode()
    local voice_type, plural, prime_target = l_62_0:_get_unit_intimidation_action(true, true, true, false, true, nil, nil, nil)
    local interact_type, sound_name = nil, nil
    local sound_suffix = plural and "plu" or "sin"
    if voice_type == "stop" then
      interact_type = "cmd_stop"
      sound_name = "f02x_" .. sound_suffix
    elseif voice_type == "stop_cop" then
      interact_type = "cmd_stop"
      sound_name = "l01x_" .. sound_suffix
    elseif voice_type == "mark_cop" or voice_type == "mark_cop_quiet" then
      interact_type = "cmd_point"
      if voice_type == "mark_cop_quiet" then
        sound_name = tweak_data.character[prime_target.unit:base()._tweak_table].silent_priority_shout .. "x_any"
      else
        sound_name = tweak_data.character[prime_target.unit:base()._tweak_table].priority_shout .. "x_any"
      end
      if not managers.player:has_category_upgrade("player", "marked_enemy_extra_damage") then
        local marked_extra_damage = not managers.player:has_category_upgrade("player", "special_enemy_highlight") or false
      end
      managers.game_play_central:add_enemy_contour(prime_target.unit, marked_extra_damage)
      managers.network:session():send_to_peers_synched("mark_enemy", prime_target.unit, marked_extra_damage)
      managers.challenges:set_flag("eagle_eyes")
    elseif voice_type == "down" then
      interact_type = "cmd_down"
      sound_name = "f02x_" .. sound_suffix
      l_62_0._shout_down_t = l_62_1
    elseif voice_type == "down_cop" then
      interact_type = "cmd_down"
      sound_name = "l02x_" .. sound_suffix
    elseif voice_type == "cuff_cop" then
      interact_type = "cmd_down"
      sound_name = "l03x_" .. sound_suffix
    elseif voice_type == "down_stay" then
      interact_type = "cmd_down"
      if l_62_0._shout_down_t and l_62_1 < l_62_0._shout_down_t + 2 then
        sound_name = "f03b_any"
      else
        sound_name = "f03a_" .. sound_suffix
      end
    elseif voice_type == "come" then
      interact_type = "cmd_come"
      local static_data = managers.criminals:character_static_data_by_unit(prime_target.unit)
      if not static_data then
        return 
      end
      local character_code = static_data.ssuffix
      sound_name = "f21" .. character_code .. "_sin"
    elseif voice_type == "revive" then
      interact_type = "cmd_get_up"
      local static_data = managers.criminals:character_static_data_by_unit(prime_target.unit)
      if not static_data then
        return 
      end
      local character_code = static_data.ssuffix
      sound_name = "f35x_any"
      if math.random() < l_62_0._ext_movement:rally_skill_data().revive_chance then
        prime_target.unit:interaction():interact(l_62_0._unit)
      end
      l_62_0._ext_movement:rally_skill_data().morale_boost_delay_t = managers.player:player_timer():time() + 3.5
    elseif voice_type == "boost" then
      interact_type = "cmd_gogo"
      local static_data = managers.criminals:character_static_data_by_unit(prime_target.unit)
      if not static_data then
        return 
      end
      local character_code = static_data.ssuffix
      sound_name = "f36x_any"
    elseif voice_type == "escort" then
      interact_type = "cmd_point"
      sound_name = "e01x_" .. sound_suffix
    elseif voice_type == "escort_keep" then
      interact_type = "cmd_point"
      sound_name = "e05x_" .. sound_suffix
    elseif voice_type == "escort_go" then
      interact_type = "cmd_point"
      local e_guy = prime_target.unit
      local stopped_t = 0
      if l_62_1 < stopped_t + 2 then
        sound_name = "e02x_" .. sound_suffix
      else
        sound_name = "e03x_" .. sound_suffix
      end
    elseif voice_type == "bridge_codeword" then
      sound_name = "bri_14"
      interact_type = "cmd_point"
    elseif voice_type == "bridge_chair" then
      sound_name = "bri_29"
      interact_type = "cmd_point"
    elseif voice_type == "undercover_interrogate" then
      sound_name = "und_18"
      interact_type = "cmd_point"
    end
    l_62_0:_do_action_intimidate(l_62_1, interact_type, sound_name, skip_alert)
  end
end

PlayerStandard._do_action_intimidate = function(l_63_0, l_63_1, l_63_2, l_63_3, l_63_4)
  if l_63_3 then
    l_63_0._intimidate_t = l_63_1
    l_63_0:say_line(l_63_3, l_63_4)
    if l_63_2 then
      l_63_0:_play_distance_interact_redirect(l_63_1, l_63_2)
    end
  end
end

PlayerStandard.say_line = function(l_64_0, l_64_1, l_64_2)
  l_64_0._unit:sound():say(l_64_1, nil, true)
  if not l_64_2 then
    l_64_2 = managers.groupai:state():whisper_mode()
  end
  if not l_64_2 then
    local alert_rad = 500
    local new_alert = {"vo_cbt", l_64_0._unit:movement():m_head_pos(), alert_rad, l_64_0._unit:movement():SO_access(), l_64_0._unit}
    managers.groupai:state():propagate_alert(new_alert)
  end
end

PlayerStandard._play_distance_interact_redirect = function(l_65_0, l_65_1, l_65_2)
  managers.network:session():send_to_peers("play_distance_interact_redirect", l_65_0._unit, l_65_2)
  if l_65_0._state_data.in_steelsight then
    return 
  end
  if l_65_0._shooting or not l_65_0._equipped_unit:base():start_shooting_allowed() then
    return 
  end
  if l_65_0:_is_reloading() or l_65_0:_changing_weapon() or l_65_0._melee_expire_t or l_65_0._use_item_expire_t then
    return 
  end
  if l_65_0._running then
    return 
  end
  l_65_0._ext_camera:play_redirect(Idstring(l_65_2))
end

PlayerStandard._break_intimidate_redirect = function(l_66_0, l_66_1)
  if l_66_0._shooting then
    return 
  end
  l_66_0._ext_camera:play_redirect(l_66_0.IDS_IDLE)
end

PlayerStandard._play_interact_redirect = function(l_67_0, l_67_1)
  if l_67_0._shooting or not l_67_0._equipped_unit:base():start_shooting_allowed() then
    return 
  end
  if l_67_0:_is_reloading() or l_67_0:_changing_weapon() or l_67_0._melee_expire_t then
    return 
  end
  if l_67_0._running then
    return 
  end
  l_67_0._ext_camera:play_redirect(l_67_0.IDS_USE)
end

PlayerStandard._break_interact_redirect = function(l_68_0, l_68_1)
  l_68_0._ext_camera:play_redirect(l_68_0.IDS_IDLE)
end

PlayerStandard._check_action_equip = function(l_69_0, l_69_1, l_69_2)
  local new_action = nil
  local selection_wanted = l_69_2.btn_primary_choice
  if selection_wanted then
    local action_forbidden = l_69_0:chk_action_forbidden("equip")
    if not action_forbidden and l_69_0._ext_inventory:is_selection_available(selection_wanted) and not l_69_0._melee_expire_t and not l_69_0._use_item_expire_t and not l_69_0:_changing_weapon() then
      action_forbidden = l_69_0:_interacting()
      action_forbidden = action_forbidden
    end
    if not action_forbidden then
      local new_action = not l_69_0._ext_inventory:is_equipped(selection_wanted)
      if new_action then
        l_69_0:_start_action_unequip_weapon(l_69_1, {selection_wanted = selection_wanted})
      end
    end
  end
  return new_action
end

PlayerStandard._check_action_jump = function(l_70_0, l_70_1, l_70_2)
  local new_action = nil
  local action_wanted = l_70_2.btn_jump_press
   -- DECOMPILER ERROR: unhandled construct in 'if'

  if l_70_0._jump_t and l_70_1 >= l_70_0._jump_t + 0.55000001192093 then
    local action_forbidden = not action_wanted
  end
  if not action_forbidden and not l_70_0._unit:base():stats_screen_visible() and not l_70_0._state_data.in_air then
    action_forbidden = l_70_0:_interacting()
  end
  if not action_forbidden then
    if l_70_0._state_data.ducking then
      l_70_0:_interupt_action_ducking(l_70_1)
    else
      local action_start_data = {}
      local jump_vel_z = tweak_data.player.movement_state.standard.movement.jump_velocity.z
      action_start_data.jump_vel_z = jump_vel_z
       -- DECOMPILER ERROR: unhandled construct in 'if'

      if l_70_0._running and l_70_0._unit:movement():is_above_stamina_threshold() and l_70_1 - l_70_0._start_running_t <= 0.40000000596046 then
        local is_running = not l_70_0._move_dir
      end
      local jump_vel_xy = tweak_data.player.movement_state.standard.movement.jump_velocity.xy[is_running and "run" or "walk"]
      action_start_data.jump_vel_xy = jump_vel_xy
      if is_running then
        l_70_0._unit:movement():subtract_stamina(tweak_data.player.movement_state.stamina.JUMP_STAMINA_DRAIN)
      end
      new_action = l_70_0:_start_action_jump(l_70_1, action_start_data)
    end
  end
  return new_action
end

PlayerStandard._start_action_jump = function(l_71_0, l_71_1, l_71_2)
  l_71_0:_interupt_action_running(l_71_1)
  l_71_0._jump_t = l_71_1
  local jump_vec = l_71_2.jump_vel_z * math.UP
  l_71_0._unit:mover():jump()
  if l_71_0._move_dir then
    local move_dir_clamp = l_71_0._move_dir:normalized() * math.min(1, l_71_0._move_dir:length())
    l_71_0._last_velocity_xy = move_dir_clamp * l_71_2.jump_vel_xy
    l_71_0._jump_vel_xy = mvector3.copy(l_71_0._last_velocity_xy)
  else
    l_71_0._last_velocity_xy = Vector3()
  end
  l_71_0:_perform_jump(jump_vec)
end

PlayerStandard._perform_jump = function(l_72_0, l_72_1)
  l_72_0._unit:mover():set_velocity(l_72_1)
end

PlayerStandard._check_action_run = function(l_73_0, l_73_1, l_73_2)
  if (l_73_0._setting_hold_to_run and l_73_2.btn_run_release) or l_73_0._running and not l_73_0._move_dir then
    l_73_0._running_wanted = false
    if l_73_0._running then
      l_73_0:_end_action_running(l_73_1)
      if l_73_2.btn_steelsight_state and not l_73_0._state_data.in_steelsight then
        l_73_0._steelsight_wanted = true
      elseif not l_73_0._setting_hold_to_run and l_73_2.btn_run_release and not l_73_0._move_dir then
        l_73_0._running_wanted = false
      elseif l_73_2.btn_run_press or l_73_0._running_wanted then
        if not l_73_0._running or l_73_0._end_running_expire_t then
          l_73_0:_start_action_running(l_73_1)
        elseif l_73_0._running and not l_73_0._setting_hold_to_run then
          l_73_0:_end_action_running(l_73_1)
          if l_73_2.btn_steelsight_state and not l_73_0._state_data.in_steelsight then
            l_73_0._steelsight_wanted = true
          end
        end
      end
    end
  end
end

PlayerStandard._update_running_timers = function(l_74_0, l_74_1)
   -- DECOMPILER ERROR: unhandled construct in 'if'

  if l_74_0._end_running_expire_t and l_74_0._end_running_expire_t <= l_74_1 then
    l_74_0._end_running_expire_t = nil
    l_74_0:set_running(false)
    do return end
    if l_74_0._running and (l_74_0._unit:movement():is_stamina_drained() or not l_74_0:_can_run_directional()) then
      l_74_0:_interupt_action_running(l_74_1)
    end
  end
end

PlayerStandard.set_running = function(l_75_0, l_75_1)
  l_75_0._running = l_75_1
  l_75_0._unit:movement():set_running(l_75_0._running)
end

PlayerStandard._check_action_duck = function(l_76_0, l_76_1, l_76_2)
  if l_76_0._setting_hold_to_duck and l_76_2.btn_duck_release and l_76_0._state_data.ducking then
    l_76_0:_end_action_ducking(l_76_1)
    do return end
    if l_76_2.btn_duck_press and not l_76_0._unit:base():stats_screen_visible() then
      if not l_76_0._state_data.ducking then
        l_76_0:_start_action_ducking(l_76_1)
      else
        if l_76_0._state_data.ducking then
          l_76_0:_end_action_ducking(l_76_1)
        end
      end
    end
  end
end

PlayerStandard._check_action_steelsight = function(l_77_0, l_77_1, l_77_2)
  local new_action = nil
  if managers.user:get_setting("hold_to_steelsight") and l_77_2.btn_steelsight_release then
    l_77_0._steelsight_wanted = false
    if l_77_0._state_data.in_steelsight then
      l_77_0:_end_action_steelsight(l_77_1)
      new_action = true
    elseif l_77_2.btn_steelsight_press or l_77_0._steelsight_wanted then
      if l_77_0._state_data.in_steelsight then
        l_77_0:_end_action_steelsight(l_77_1)
        new_action = true
      else
        if not l_77_0._state_data.in_steelsight then
          l_77_0:_start_action_steelsight(l_77_1)
          new_action = true
        end
      end
    end
    return new_action
     -- Warning: missing end command somewhere! Added here
  end
end

PlayerStandard.shooting = function(l_78_0)
  return l_78_0._shooting
end

PlayerStandard.running = function(l_79_0)
  return l_79_0._running
end

PlayerStandard.get_zoom_fov = function(l_80_0, l_80_1)
  local fov = l_80_1 and l_80_1.FOV or 75
  local fov_multiplier = managers.user:get_setting("fov_multiplier")
  if l_80_0._state_data.in_steelsight then
    fov = l_80_0._equipped_unit:base():zoom()
    fov_multiplier = 1 + (fov_multiplier - 1) / 2
  end
  return fov * (fov_multiplier)
end

PlayerStandard._check_action_primary_attack = function(l_81_0, l_81_1, l_81_2)
  local new_action = nil
  do
    local action_wanted = l_81_2.btn_primary_attack_state
    if action_wanted then
      if not l_81_0:_is_reloading() and not l_81_0:_changing_weapon() and not l_81_0._melee_expire_t and not l_81_0._use_item_expire_t then
        local action_forbidden = l_81_0:_interacting()
      end
      if not action_forbidden then
        l_81_0._queue_reload_interupt = nil
        l_81_0._ext_inventory:equip_selected_primary(false)
        if l_81_0._equipped_unit then
          local weap_base = l_81_0._equipped_unit:base()
          local fire_mode = weap_base:fire_mode()
          if weap_base:out_of_ammo() and l_81_2.btn_primary_attack_press then
            weap_base:dryfire()
            do return end
             -- DECOMPILER ERROR: unhandled construct in 'if'

            if weap_base.clip_empty and weap_base:clip_empty() and fire_mode == "single" and l_81_2.btn_primary_attack_press then
              l_81_0:_start_action_reload_enter(l_81_1)
              do return end
              new_action = true
              l_81_0:_start_action_reload_enter(l_81_1)
              do return end
              if l_81_0._running then
                l_81_0:_interupt_action_running(l_81_1)
              elseif (fire_mode ~= "single" or not l_81_2.btn_primary_attack_press) then
                 -- DECOMPILER ERROR: Attempted to build a boolean expression without a pending context

                local start = error_maybe_false
                if not start then
                  if fire_mode ~= "single" then
                    start = l_81_2.btn_primary_attack_state
                  else
                    start = false
                  end
                  if start then
                    weap_base:start_shooting()
                    l_81_0._camera_unit:base():start_shooting()
                    l_81_0._shooting = true
                    if fire_mode == "auto" then
                      l_81_0._unit:camera():play_redirect(l_81_0.IDS_RECOIL_ENTER)
                    else
                      return false
                    end
                  end
                end
                local suppression_ratio = l_81_0._unit:character_damage():effective_suppression_ratio()
                local spread_mul = math.lerp(1, tweak_data.player.suppression.spread_mul, suppression_ratio)
                local autohit_mul = math.lerp(1, tweak_data.player.suppression.autohit_chance_mul, suppression_ratio)
                local suppression_mul = managers.player:upgrade_value("player", "suppression_multiplier", 1) * managers.player:upgrade_value("player", "suppression_multiplier2", 1) * managers.player:upgrade_value("player", "passive_suppression_multiplier", 1)
                local dmg_mul = managers.player:temporary_upgrade_value("temporary", "dmg_multiplier_outnumbered", 1)
                dmg_mul = dmg_mul * managers.player:upgrade_value("player", "passive_damage_multiplier", 1)
                local weapon_category = weap_base:weapon_tweak_data().category
                if managers.player:has_category_upgrade("player", "overkill_all_weapons") or weapon_category == "shotgun" or weapon_category == "saw" then
                  dmg_mul = dmg_mul * managers.player:temporary_upgrade_value("temporary", "overkill_damage_multiplier", 1)
                end
                local health_ratio = l_81_0._ext_damage:health_ratio()
                if weapon_category ~= "saw" or not "melee_damage_health_ratio_multiplier" then
                  local upgrade_name = health_ratio > tweak_data.upgrades.player_damage_health_ratio_threshold or "damage_health_ratio_multiplier"
                end
                do
                  local damage_ratio = 1 - health_ratio / math.max(0.0099999997764826, tweak_data.upgrades.player_damage_health_ratio_threshold)
                  dmg_mul = dmg_mul * (1 + managers.player:upgrade_value("player", upgrade_name, 0) * damage_ratio)
                end
                local fired = nil
                if fire_mode == "single" and l_81_2.btn_primary_attack_press then
                  fired = weap_base:trigger_pressed(l_81_0._ext_camera:position(), l_81_0._ext_camera:forward(), dmg_mul, nil, spread_mul, autohit_mul, suppression_mul)
                end
                new_action = true
                if fired then
                  managers.rumble:play("weapon_fire")
                  local weap_tweak_data = tweak_data.weapon[weap_base:get_name_id()]
                  local shake_multiplier = weap_tweak_data.shake[l_81_0._state_data.in_steelsight and "fire_steelsight_multiplier" or "fire_multiplier"]
                  l_81_0._ext_camera:play_shaker("fire_weapon_rot", 1 * shake_multiplier)
                  l_81_0._ext_camera:play_shaker("fire_weapon_kick", 1 * shake_multiplier, 1, 0.15000000596046)
                  if not l_81_0._state_data.in_steelsight or not weap_base:tweak_data_anim_play("fire_steelsight", weap_base:fire_rate_multiplier()) then
                    weap_base:tweak_data_anim_play("fire", weap_base:fire_rate_multiplier())
                  end
                  if fire_mode == "single" then
                    if not l_81_0._state_data.in_steelsight then
                      l_81_0._ext_camera:play_redirect(l_81_0.IDS_RECOIL, 1)
                    else
                      if weap_tweak_data.animations.recoil_steelsight then
                        l_81_0._ext_camera:play_redirect(l_81_0.IDS_RECOIL_STEELSIGHT, 1)
                      end
                    end
                  end
                  local recoil_multiplier = weap_base:recoil() * weap_base:recoil_multiplier()
                  local up, down, left, right = unpack(weap_tweak_data.kick[(l_81_0._state_data.in_steelsight and "steelsight") or (l_81_0._state_data.ducking and "crouching") or "standing"])
                  l_81_0._camera_unit:base():recoil_kick(up * recoil_multiplier, down * recoil_multiplier, left * recoil_multiplier, right * recoil_multiplier)
                  managers.hud:set_ammo_amount(weap_base:selection_index(), weap_base:ammo_info())
                  local impact = not fired.hit_enemy
                  l_81_0._ext_network:send("shot_blank", impact)
                elseif fire_mode == "single" then
                  new_action = false
                else
                  if l_81_0:_is_reloading() and l_81_0._equipped_unit:base():reload_interuptable() and l_81_2.btn_primary_attack_press then
                    l_81_0._queue_reload_interupt = true
                end
              end
            end
          end
        end
        if not new_action and l_81_0._shooting then
          l_81_0._equipped_unit:base():stop_shooting()
          l_81_0._camera_unit:base():stop_shooting(l_81_0._equipped_unit:base():recoil_wait())
          local weap_base = l_81_0._equipped_unit:base()
          local fire_mode = weap_base:fire_mode()
          if fire_mode == "auto" and not l_81_0:_is_reloading() then
            l_81_0._unit:camera():play_redirect(l_81_0.IDS_RECOIL_EXIT)
          end
          l_81_0._shooting = false
        end
        return new_action
      end
       -- Warning: missing end command somewhere! Added here
    end
     -- Warning: missing end command somewhere! Added here
  end
end

PlayerStandard._start_action_reload_enter = function(l_82_0, l_82_1)
  if l_82_0._equipped_unit:base():can_reload() then
    l_82_0:_interupt_action_steelsight(l_82_1)
    l_82_0:_interupt_action_running(l_82_1)
    if l_82_0._equipped_unit:base():reload_enter_expire_t() then
      local speed_multiplier = l_82_0._equipped_unit:base():reload_speed_multiplier()
      l_82_0._ext_camera:play_redirect(Idstring("reload_enter_" .. l_82_0._equipped_unit:base().name_id), speed_multiplier)
      l_82_0._state_data.reload_enter_expire_t = l_82_1 + l_82_0._equipped_unit:base():reload_enter_expire_t() / speed_multiplier
      return 
    end
    l_82_0:_start_action_reload(l_82_1)
  end
end

PlayerStandard._start_action_reload = function(l_83_0, l_83_1)
  if l_83_0._equipped_unit:base():can_reload() then
    l_83_0._equipped_unit:base():tweak_data_anim_stop("fire")
    local speed_multiplier = l_83_0._equipped_unit:base():reload_speed_multiplier()
    local tweak_data = l_83_0._equipped_unit:base():weapon_tweak_data()
    local reload_anim = "reload"
    if l_83_0._equipped_unit:base():clip_empty() then
      local result = l_83_0._ext_camera:play_redirect(Idstring("reload_" .. l_83_0._equipped_unit:base().name_id), speed_multiplier)
      l_83_0._state_data.reload_expire_t = l_83_1 + (tweak_data.timers.reload_empty or l_83_0._equipped_unit:base():reload_expire_t() or 2.5999999046326) / speed_multiplier
    else
      reload_anim = "reload_not_empty"
      local result = l_83_0._ext_camera:play_redirect(Idstring("reload_not_empty_" .. l_83_0._equipped_unit:base().name_id), speed_multiplier)
      l_83_0._state_data.reload_expire_t = l_83_1 + (tweak_data.timers.reload_not_empty or l_83_0._equipped_unit:base():reload_expire_t() or 2.2000000476837) / speed_multiplier
    end
    l_83_0._equipped_unit:base():start_reload()
    if not l_83_0._equipped_unit:base():tweak_data_anim_play(reload_anim, speed_multiplier) then
      l_83_0._equipped_unit:base():tweak_data_anim_play("reload", speed_multiplier)
    end
    l_83_0._ext_network:send("reload_weapon")
  end
end

PlayerStandard._interupt_action_reload = function(l_84_0, l_84_1)
  if l_84_0:_is_reloading() then
    l_84_0._equipped_unit:base():tweak_data_anim_stop("reload")
    l_84_0._equipped_unit:base():tweak_data_anim_stop("reload_not_empty")
    l_84_0._equipped_unit:base():tweak_data_anim_stop("reload_exit")
  end
  l_84_0._state_data.reload_enter_expire_t = nil
  l_84_0._state_data.reload_expire_t = nil
  l_84_0._state_data.reload_exit_expire_t = nil
end

PlayerStandard._is_reloading = function(l_85_0)
  if not l_85_0._state_data.reload_expire_t and not l_85_0._state_data.reload_enter_expire_t then
    return l_85_0._state_data.reload_exit_expire_t
  end
end

PlayerStandard._get_swap_speed_multiplier = function(l_86_0)
  local multiplier = 1
  multiplier = multiplier * managers.player:upgrade_value("weapon", "swap_speed_multiplier", 1)
  multiplier = multiplier * managers.player:upgrade_value("weapon", "passive_swap_speed_multiplier", 1)
  multiplier = multiplier * managers.player:upgrade_value(l_86_0._equipped_unit:base():weapon_tweak_data().category, "swap_speed_multiplier", 1)
  return multiplier
end

PlayerStandard._start_action_unequip_weapon = function(l_87_0, l_87_1, l_87_2)
  local speed_multiplier = l_87_0:_get_swap_speed_multiplier()
  l_87_0._equipped_unit:base():tweak_data_anim_play("unequip", speed_multiplier)
  local tweak_data = l_87_0._equipped_unit:base():weapon_tweak_data()
  l_87_0._change_weapon_data = l_87_2
  l_87_0._unequip_weapon_expire_t = l_87_1 + (tweak_data.timers.unequip or 0.5) / speed_multiplier
  l_87_0:_interupt_action_running(l_87_1)
  local result = l_87_0._ext_camera:play_redirect(l_87_0.IDS_UNEQUIP, speed_multiplier)
  l_87_0:_interupt_action_reload(l_87_1)
  l_87_0:_interupt_action_steelsight(l_87_1)
end

PlayerStandard._start_action_equip_weapon = function(l_88_0, l_88_1)
  local speed_multiplier = l_88_0:_get_swap_speed_multiplier()
  if l_88_0._change_weapon_data.next then
    l_88_0._ext_inventory:equip_next(false)
  else
    if l_88_0._change_weapon_data.previous then
      l_88_0._ext_inventory:equip_previous(false)
    else
      if l_88_0._change_weapon_data.selection_wanted then
        l_88_0._ext_inventory:equip_selection(l_88_0._change_weapon_data.selection_wanted, false)
      end
    end
  end
  local tweak_data = l_88_0._equipped_unit:base():weapon_tweak_data()
  l_88_0._equip_weapon_expire_t = l_88_1 + (tweak_data.timers.equip or 0.69999998807907) / speed_multiplier
  l_88_0._ext_camera:play_redirect(l_88_0.IDS_EQUIP, speed_multiplier)
  managers.upgrades:setup_current_weapon()
end

PlayerStandard._changing_weapon = function(l_89_0)
  if not l_89_0._unequip_weapon_expire_t then
    return l_89_0._equip_weapon_expire_t
  end
end

PlayerStandard._find_pickups = function(l_90_0, l_90_1)
  local pickups = World:find_units_quick("sphere", l_90_0._unit:movement():m_pos(), 200, l_90_0._slotmask_pickups)
  for _,pickup in ipairs(pickups) do
    if pickup:base():pickup(l_90_0._unit) then
      for id,weapon in pairs(l_90_0._unit:inventory():available_selections()) do
        managers.hud:set_ammo_amount(id, weapon.unit:base():ammo_info())
      end
    end
  end
end

PlayerStandard.get_melee_damage_result = function(l_91_0, l_91_1)
end

PlayerStandard.get_bullet_damage_result = function(l_92_0, l_92_1)
end

PlayerStandard.push = function(l_93_0, l_93_1)
  l_93_0._last_velocity_xy = l_93_0._last_velocity_xy + l_93_1
  l_93_0._unit:mover():set_velocity(l_93_0._last_velocity_xy)
  l_93_0:_start_action_ducking(managers.player:player_timer():time())
end

PlayerStandard._get_dir_str_from_vec = function(l_94_0, l_94_1, l_94_2)
  local att_dir_spin = l_94_2:to_polar_with_reference(l_94_1, math.UP).spin
  local abs_spin = math.abs(att_dir_spin)
  if abs_spin < 45 then
    return "fwd"
  elseif abs_spin > 135 then
    return "bwd"
  elseif att_dir_spin < 0 then
    return "right"
  else
    return "left"
  end
end

PlayerStandard.inventory_clbk_listener = function(l_95_0, l_95_1, l_95_2)
  if l_95_2 == "equip" then
    local weapon = l_95_0._ext_inventory:equipped_unit()
    if l_95_0._weapon_hold then
      l_95_0._camera_unit:anim_state_machine():set_global(l_95_0._weapon_hold, 0)
    end
    if not weapon:base().weapon_hold or not weapon:base():weapon_hold() then
      l_95_0._weapon_hold = weapon:base():get_name_id()
    end
    l_95_0._camera_unit:anim_state_machine():set_global(l_95_0._weapon_hold, 1)
    l_95_0._equipped_unit = weapon
    weapon:base():on_equip()
    managers.hud:set_weapon_selected_by_inventory_index(l_95_0._ext_inventory:equipped_selection())
    for id,weapon in pairs(l_95_0._ext_inventory:available_selections()) do
      managers.hud:set_ammo_amount(id, weapon.unit:base():ammo_info())
    end
    managers.hud:set_weapon_name(tweak_data.weapon[weapon:base():get_name_id()].name_id)
    l_95_0:_update_crosshair_offset()
    l_95_0:_stance_entered()
  end
end

PlayerStandard.save = function(l_96_0, l_96_1)
  if l_96_0._state_data.ducking then
    l_96_1.pose = 2
  else
    l_96_1.pose = 1
  end
end

PlayerStandard.destroy = function(l_97_0)
  if l_97_0._pos_reservation then
    managers.navigation:unreserve_pos(l_97_0._pos_reservation)
    l_97_0._pos_reservation = nil
    managers.navigation:unreserve_pos(l_97_0._pos_reservation_slow)
    l_97_0._pos_reservation_slow = nil
  end
end

PlayerStandard.tweak_data_clbk_reload = function(l_98_0)
  l_98_0._tweak_data = tweak_data.player.movement_state.standard
end


