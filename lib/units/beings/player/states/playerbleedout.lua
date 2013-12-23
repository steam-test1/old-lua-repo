-- Decompiled using luadec 2.0.1 by sztupy (http://winmo.sztupy.hu)
-- Command line was: F:\SteamLibrary\SteamApps\common\PAYDAY 2\lua\lib\units\beings\player\states\playerbleedout.luac 

if not PlayerBleedOut then
  PlayerBleedOut = class(PlayerStandard)
end
PlayerBleedOut.init = function(l_1_0, l_1_1)
  PlayerBleedOut.super.init(l_1_0, l_1_1)
end

PlayerBleedOut.enter = function(l_2_0, l_2_1, l_2_2)
  PlayerBleedOut.super.enter(l_2_0, l_2_1, l_2_2)
  l_2_0._revive_SO_data = {unit = l_2_0._unit}
  l_2_0:_start_action_bleedout(managers.player:player_timer():time())
  l_2_0._tilt_wait_t = managers.player:player_timer():time() + 1
  l_2_0._old_selection = nil
  if not managers.player:has_category_upgrade("player", "primary_weapon_when_downed") and l_2_0._unit:inventory():equipped_selection() ~= 1 then
    l_2_0._old_selection = l_2_0._unit:inventory():equipped_selection()
    l_2_0:_start_action_unequip_weapon(managers.player:player_timer():time(), {selection_wanted = 1})
    l_2_0._unit:inventory():unit_by_selection(1):base():on_reload()
  end
  l_2_0._unit:camera():play_shaker("player_bleedout_land")
  local effect_id_world = "world_downed_Peer" .. tostring(managers.network:session():local_peer():id())
  managers.time_speed:play_effect(effect_id_world, tweak_data.timespeed.downed)
  local effect_id_player = "player_downed_Peer" .. tostring(managers.network:session():local_peer():id())
  managers.time_speed:play_effect(effect_id_player, tweak_data.timespeed.downed_player)
  managers.groupai:state():on_criminal_disabled(l_2_0._unit)
  if Network:is_server() and l_2_0._ext_movement:nav_tracker() then
    l_2_0._register_revive_SO(l_2_0._revive_SO_data, "revive")
  end
  if l_2_0._state_data.in_steelsight then
    l_2_0:_interupt_action_steelsight(managers.player:player_timer():time())
  end
  managers.groupai:state():report_criminal_downed(l_2_0._unit)
end

PlayerBleedOut._enter = function(l_3_0, l_3_1)
  l_3_0._unit:base():set_slot(l_3_0._unit, 2)
  if Network:is_server() and l_3_0._ext_movement:nav_tracker() then
    managers.groupai:state():on_player_weapons_hot()
  end
  l_3_0._ext_movement:set_attention_settings({"pl_enemy_cbt", "pl_team_idle_std", "pl_civ_cbt"})
end

PlayerBleedOut.exit = function(l_4_0, l_4_1, l_4_2)
  PlayerBleedOut.super.exit(l_4_0, l_4_1, l_4_2)
  l_4_0:_end_action_bleedout(managers.player:player_timer():time())
  l_4_0._unit:camera():camera_unit():base():set_target_tilt(0)
  l_4_0._tilt_wait_t = nil
  local exit_data = {equip_weapon = l_4_0._old_selection}
  if Network:is_server() then
    if l_4_2 == "fatal" then
      exit_data.revive_SO_data = l_4_0._revive_SO_data
      l_4_0._revive_SO_data = nil
    else
      l_4_0:_unregister_revive_SO()
    end
  end
  exit_data.skip_equip = true
  if l_4_2 == "standard" then
    exit_data.wants_crouch = true
  end
  return exit_data
end

PlayerBleedOut.interaction_blocked = function(l_5_0)
  return true
end

PlayerBleedOut.update = function(l_6_0, l_6_1, l_6_2)
  PlayerBleedOut.super.update(l_6_0, l_6_1, l_6_2)
  if l_6_0._tilt_wait_t then
    local tilt = math.lerp(35, 0, l_6_0._tilt_wait_t - l_6_1)
    l_6_0._unit:camera():camera_unit():base():set_target_tilt(tilt)
    if l_6_0._tilt_wait_t < l_6_1 then
      l_6_0._tilt_wait_t = nil
      l_6_0._unit:camera():camera_unit():base():set_target_tilt(35)
    end
  end
end

PlayerBleedOut._update_check_actions = function(l_7_0, l_7_1, l_7_2)
  local input = l_7_0:_get_input()
  l_7_0._unit:camera():set_shaker_parameter("headbob", "amplitude", 0)
  l_7_0:_update_reload_timers(l_7_1, l_7_2, input)
  l_7_0:_update_equip_weapon_timers(l_7_1, input)
  if input.btn_stats_screen_press then
    l_7_0._unit:base():set_stats_screen_visible(true)
  elseif input.btn_stats_screen_release then
    l_7_0._unit:base():set_stats_screen_visible(false)
  end
  l_7_0:_update_foley(l_7_1, input)
  local new_action = nil
  if not new_action then
    new_action = l_7_0:_check_action_weapon_gadget(l_7_1, input)
  end
  if not new_action then
    new_action = l_7_0:_check_action_reload(l_7_1, input)
  end
  if not new_action then
    new_action = l_7_0:_check_change_weapon(l_7_1, input)
  end
  if not new_action then
    new_action = l_7_0:_check_action_primary_attack(l_7_1, input)
    l_7_0._shooting = new_action
  end
  if not new_action then
    new_action = l_7_0:_check_action_equip(l_7_1, input)
  end
  if not new_action then
    new_action = l_7_0:_check_action_interact(l_7_1, input)
  end
  if not new_action then
    new_action = l_7_0:_check_action_steelsight(l_7_1, input)
  end
  PlayerCarry._check_use_item(l_7_0, l_7_1, input)
end

PlayerBleedOut._check_action_interact = function(l_8_0, l_8_1, l_8_2)
  if l_8_2.btn_interact_press and (not l_8_0._intimidate_t or tweak_data.player.movement_state.interaction_delay < l_8_1 - l_8_0._intimidate_t) then
    l_8_0._intimidate_t = l_8_1
    if not PlayerArrested.call_teammate(l_8_0, "f11", l_8_1) then
      l_8_0:call_civilian("f11", l_8_1, false, true, l_8_0._revive_SO_data)
    end
  end
end

PlayerBleedOut._check_change_weapon = function(l_9_0, ...)
  if managers.player:has_category_upgrade("player", "primary_weapon_when_downed") then
    return PlayerBleedOut.super._check_change_weapon(l_9_0, ...)
  end
  return false
   -- DECOMPILER ERROR: Confused about usage of registers for local variables.

end

PlayerBleedOut._check_action_equip = function(l_10_0, ...)
  if managers.player:has_category_upgrade("player", "primary_weapon_when_downed") then
    return PlayerBleedOut.super._check_action_equip(l_10_0, ...)
  end
  return false
   -- DECOMPILER ERROR: Confused about usage of registers for local variables.

end

PlayerBleedOut._check_action_steelsight = function(l_11_0, ...)
  if managers.player:has_category_upgrade("player", "steelsight_when_downed") then
    return PlayerBleedOut.super._check_action_steelsight(l_11_0, ...)
  end
  return false
   -- DECOMPILER ERROR: Confused about usage of registers for local variables.

end

PlayerBleedOut._start_action_state_standard = function(l_12_0, l_12_1)
  managers.player:set_player_state("standard")
end

PlayerBleedOut._register_revive_SO = function(l_13_0, l_13_1)
  if l_13_0.SO_id or not managers.navigation:is_data_ready() then
    return 
  end
  local followup_objective = {type = "act", scan = true, action = {type = "act", body_part = 1, variant = "crouch", blocks = {action = -1, walk = -1, hurt = -1, heavy_hurt = -1, aim = -1}}}
  {type = "revive", follow_unit = l_13_0.unit, called = true, destroy_clbk_key = false, nav_seg = l_13_0.unit:movement():nav_tracker():nav_segment(), fail_clbk = callback(PlayerBleedOut, PlayerBleedOut, "on_rescue_SO_failed", l_13_0), complete_clbk = callback(PlayerBleedOut, PlayerBleedOut, "on_rescue_SO_completed", l_13_0), action_start_clbk = callback(PlayerBleedOut, PlayerBleedOut, "on_rescue_SO_started", l_13_0)}.scan = true
   -- DECOMPILER ERROR: Confused about usage of registers!

  {type = "revive", follow_unit = l_13_0.unit, called = true, destroy_clbk_key = false, nav_seg = l_13_0.unit:movement():nav_tracker():nav_segment(), fail_clbk = callback(PlayerBleedOut, PlayerBleedOut, "on_rescue_SO_failed", l_13_0), complete_clbk = callback(PlayerBleedOut, PlayerBleedOut, "on_rescue_SO_completed", l_13_0), action_start_clbk = callback(PlayerBleedOut, PlayerBleedOut, "on_rescue_SO_started", l_13_0)}.action = {type = "act", variant = l_13_1, body_part = 1, blocks = {action = -1, walk = -1, light_hurt = -1, hurt = -1, heavy_hurt = -1, aim = -1}, align_sync = true}
   -- DECOMPILER ERROR: Confused about usage of registers!

  {type = "revive", follow_unit = l_13_0.unit, called = true, destroy_clbk_key = false, nav_seg = l_13_0.unit:movement():nav_tracker():nav_segment(), fail_clbk = callback(PlayerBleedOut, PlayerBleedOut, "on_rescue_SO_failed", l_13_0), complete_clbk = callback(PlayerBleedOut, PlayerBleedOut, "on_rescue_SO_completed", l_13_0), action_start_clbk = callback(PlayerBleedOut, PlayerBleedOut, "on_rescue_SO_started", l_13_0)}.action_duration = tweak_data.interaction[l_13_1 == "untie" and "free" or l_13_1].timer
   -- DECOMPILER ERROR: Confused about usage of registers!

  {type = "revive", follow_unit = l_13_0.unit, called = true, destroy_clbk_key = false, nav_seg = l_13_0.unit:movement():nav_tracker():nav_segment(), fail_clbk = callback(PlayerBleedOut, PlayerBleedOut, "on_rescue_SO_failed", l_13_0), complete_clbk = callback(PlayerBleedOut, PlayerBleedOut, "on_rescue_SO_completed", l_13_0), action_start_clbk = callback(PlayerBleedOut, PlayerBleedOut, "on_rescue_SO_started", l_13_0)}.followup_objective = followup_objective
   -- DECOMPILER ERROR: Confused at declaration of local variable

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused at declaration of local variable

  l_13_0.variant = l_13_1
  do
     -- DECOMPILER ERROR: Confused at declaration of local variable

    l_13_0.SO_id = "Playerrevive"
     -- DECOMPILER ERROR: Confused about usage of registers!

    managers.groupai:state():add_special_objective("Playerrevive", {objective = {type = "revive", follow_unit = l_13_0.unit, called = true, destroy_clbk_key = false, nav_seg = l_13_0.unit:movement():nav_tracker():nav_segment(), fail_clbk = callback(PlayerBleedOut, PlayerBleedOut, "on_rescue_SO_failed", l_13_0), complete_clbk = callback(PlayerBleedOut, PlayerBleedOut, "on_rescue_SO_completed", l_13_0), action_start_clbk = callback(PlayerBleedOut, PlayerBleedOut, "on_rescue_SO_started", l_13_0)}, base_chance = 1, chance_inc = 0, interval = 0, search_pos = l_13_0.unit:position(), usage_amount = 1, AI_group = "friendlies", admin_clbk = callback(PlayerBleedOut, PlayerBleedOut, "on_rescue_SO_administered", l_13_0)})
    if not l_13_0.deathguard_SO_id then
      l_13_0.deathguard_SO_id = PlayerBleedOut._register_deathguard_SO(l_13_0.unit)
    end
     -- DECOMPILER ERROR: Confused about usage of registers for local variables.

  end
end

PlayerBleedOut.call_civilian = function(l_14_0, l_14_1, l_14_2, l_14_3, l_14_4, l_14_5)
  if not managers.player:has_category_upgrade("player", "civilian_reviver") or l_14_5 and l_14_5.sympathy_civ then
    return 
  end
  local detect_only = managers.statistics:session_total_civilian_kills() > 0
  local voice_type, plural, prime_target = l_14_0:_get_unit_intimidation_action(false, true, false, false, false, 0, true, detect_only)
  if prime_target and detect_only and not prime_target.unit:sound():speaking(l_14_2) then
    prime_target.unit:sound():say("_a01x_any", true)
    do return end
    if not prime_target.unit:sound():speaking(l_14_2) then
      prime_target.unit:sound():say("stockholm_syndrome", true)
    end
    local queue_name = l_14_1 .. "e_plu"
    l_14_0:_do_action_intimidate(l_14_2, not l_14_3 and "cmd_come" or nil, queue_name, l_14_4)
    if Network:is_server() and prime_target.unit:brain():is_available_for_assignment({type = "revive"}) then
      local followup_objective = {type = "free", interrupt_dis = -1, interrupt_health = 1, action = {type = "idle", body_part = 1, sync = true}}
      {type = "act", haste = "run", destroy_clbk_key = false, nav_seg = l_14_0._unit:movement():nav_tracker():nav_segment(), pos = l_14_0._unit:movement():nav_tracker():field_position(), fail_clbk = callback(PlayerBleedOut, PlayerBleedOut, "on_civ_revive_failed", l_14_5)}.complete_clbk = callback(PlayerBleedOut, PlayerBleedOut, "on_civ_revive_completed", l_14_5)
       -- DECOMPILER ERROR: Confused about usage of registers!

      {type = "act", haste = "run", destroy_clbk_key = false, nav_seg = l_14_0._unit:movement():nav_tracker():nav_segment(), pos = l_14_0._unit:movement():nav_tracker():field_position(), fail_clbk = callback(PlayerBleedOut, PlayerBleedOut, "on_civ_revive_failed", l_14_5)}.action_start_clbk = callback(PlayerBleedOut, PlayerBleedOut, "on_civ_revive_started", l_14_5)
       -- DECOMPILER ERROR: Confused about usage of registers!

      {type = "act", haste = "run", destroy_clbk_key = false, nav_seg = l_14_0._unit:movement():nav_tracker():nav_segment(), pos = l_14_0._unit:movement():nav_tracker():field_position(), fail_clbk = callback(PlayerBleedOut, PlayerBleedOut, "on_civ_revive_failed", l_14_5)}.action = {type = "act", variant = "revive", body_part = 1, blocks = {action = -1, walk = -1, light_hurt = -1, hurt = -1, heavy_hurt = -1, aim = -1}, align_sync = true}
       -- DECOMPILER ERROR: Confused about usage of registers!

      {type = "act", haste = "run", destroy_clbk_key = false, nav_seg = l_14_0._unit:movement():nav_tracker():nav_segment(), pos = l_14_0._unit:movement():nav_tracker():field_position(), fail_clbk = callback(PlayerBleedOut, PlayerBleedOut, "on_civ_revive_failed", l_14_5)}.action_duration = tweak_data.interaction.revive.timer
       -- DECOMPILER ERROR: Confused about usage of registers!

      {type = "act", haste = "run", destroy_clbk_key = false, nav_seg = l_14_0._unit:movement():nav_tracker():nav_segment(), pos = l_14_0._unit:movement():nav_tracker():field_position(), fail_clbk = callback(PlayerBleedOut, PlayerBleedOut, "on_civ_revive_failed", l_14_5)}.followup_objective = followup_objective
      do
         -- DECOMPILER ERROR: Confused at declaration of local variable

        l_14_5.sympathy_civ = prime_target.unit
         -- DECOMPILER ERROR: Confused about usage of registers!

        prime_target.unit:brain():set_objective({type = "act", haste = "run", destroy_clbk_key = false, nav_seg = l_14_0._unit:movement():nav_tracker():nav_segment(), pos = l_14_0._unit:movement():nav_tracker():field_position(), fail_clbk = callback(PlayerBleedOut, PlayerBleedOut, "on_civ_revive_failed", l_14_5)})
      end
       -- DECOMPILER ERROR: Confused about usage of registers for local variables.

    end
  end
end

PlayerBleedOut._unregister_revive_SO = function(l_15_0)
  if l_15_0._revive_SO_data.deathguard_SO_id then
    PlayerBleedOut._unregister_deathguard_SO(l_15_0._revive_SO_data.deathguard_SO_id)
    l_15_0._revive_SO_data.deathguard_SO_id = nil
  end
  if l_15_0._revive_SO_data.SO_id then
    managers.groupai:state():remove_special_objective(l_15_0._revive_SO_data.SO_id)
    l_15_0._revive_SO_data.SO_id = nil
  else
    if l_15_0._revive_SO_data.rescuer then
      local rescuer = l_15_0._revive_SO_data.rescuer
      l_15_0._revive_SO_data.rescuer = nil
      if alive(rescuer) then
        rescuer:brain():set_objective(nil)
      end
    end
  end
  if l_15_0._revive_SO_data.sympathy_civ then
    local sympathy_civ = l_15_0._revive_SO_data.sympathy_civ
    l_15_0._revive_SO_data.sympathy_civ = nil
    sympathy_civ:brain():set_objective(nil)
  end
end

PlayerBleedOut._register_deathguard_SO = function(l_16_0)
end

PlayerBleedOut._unregister_deathguard_SO = function(l_17_0)
  managers.groupai:state():remove_special_objective(l_17_0)
end

PlayerBleedOut._start_action_bleedout = function(l_18_0, l_18_1)
  l_18_0:_interupt_action_running(l_18_1)
  l_18_0._state_data.ducking = true
  l_18_0:_stance_entered()
  l_18_0:_update_crosshair_offset()
  l_18_0._unit:kill_mover()
  l_18_0._unit:activate_mover(Idstring("duck"))
end

PlayerBleedOut._end_action_bleedout = function(l_19_0, l_19_1)
  if not l_19_0:_can_stand() then
    return 
  end
  l_19_0._state_data.ducking = false
  l_19_0:_stance_entered()
  l_19_0:_update_crosshair_offset()
  l_19_0._unit:kill_mover()
  l_19_0._unit:activate_mover(Idstring("stand"))
end

PlayerBleedOut._update_movement = function(l_20_0, l_20_1, l_20_2)
  if l_20_0._ext_network then
    local cur_pos = l_20_0._pos
    local move_dis = mvector3.distance_sq(cur_pos, l_20_0._last_sent_pos)
    if move_dis > 22500 or move_dis > 400 and l_20_1 - l_20_0._last_sent_pos_t > 1.5 then
      l_20_0._ext_network:send("action_walk_nav_point", cur_pos)
      mvector3.set(l_20_0._last_sent_pos, cur_pos)
      l_20_0._last_sent_pos_t = l_20_1
    end
  end
end

PlayerBleedOut.on_rescue_SO_administered = function(l_21_0, l_21_1, l_21_2)
  if l_21_1.rescuer then
    debug_pause("[PlayerBleedOut:on_rescue_SO_administered] Already had a rescuer!!!!", l_21_2, l_21_1.rescuer)
  end
  l_21_1.rescuer = l_21_2
  l_21_1.SO_id = nil
end

PlayerBleedOut.on_rescue_SO_failed = function(l_22_0, l_22_1, l_22_2)
  if l_22_1.rescuer then
    l_22_1.rescuer = nil
    PlayerBleedOut._register_revive_SO(l_22_1, l_22_1.variant)
  end
end

PlayerBleedOut.on_rescue_SO_completed = function(l_23_0, l_23_1, l_23_2)
  if l_23_1.sympathy_civ then
    local objective = {type = "free", interrupt_dis = -1, interrupt_health = 1, action = {type = "idle", body_part = 1, sync = true}}
    l_23_1.sympathy_civ:brain():set_objective(objective)
  end
  l_23_1.rescuer = nil
end

PlayerBleedOut.on_rescue_SO_started = function(l_24_0, l_24_1, l_24_2)
  for c_key,criminal in pairs(managers.groupai:state():all_AI_criminals()) do
    if c_key ~= l_24_2:key() then
      local obj = criminal.unit:brain():objective()
      if obj and obj.type == "revive" and obj.follow_unit:key() == l_24_1.unit:key() then
        criminal.unit:brain():set_objective(nil)
      end
    end
  end
end

PlayerBleedOut.on_civ_revive_completed = function(l_25_0, l_25_1, l_25_2)
  if l_25_2 ~= l_25_1.sympathy_civ then
    debug_pause_unit(l_25_2, "[PlayerBleedOut:on_civ_revive_completed] idiot thinks he is reviving", l_25_2)
    return 
  end
  l_25_1.sympathy_civ = nil
  l_25_1.unit:character_damage():revive(l_25_2)
  if managers.player:has_category_upgrade("player", "civilian_gives_ammo") then
    managers.game_play_central:spawn_pickup({name = "ammo", position = l_25_2:position(), rotation = Rotation()})
  end
end

PlayerBleedOut.on_civ_revive_started = function(l_26_0, l_26_1, l_26_2)
  if l_26_2 ~= l_26_1.sympathy_civ then
    debug_pause_unit(l_26_2, "[PlayerBleedOut:on_civ_revive_started] idiot thinks he is reviving", l_26_2)
    return 
  end
  l_26_1.unit:character_damage():pause_downed_timer()
  if l_26_1.SO_id then
    managers.groupai:state():remove_special_objective(l_26_1.SO_id)
    l_26_1.SO_id = nil
  elseif l_26_1.rescuer then
    local rescuer = l_26_1.rescuer
    l_26_1.rescuer = nil
    if alive(rescuer) then
      rescuer:brain():set_objective(nil)
    end
  end
end

PlayerBleedOut.on_civ_revive_failed = function(l_27_0, l_27_1, l_27_2)
  if l_27_1.sympathy_civ then
    if l_27_2 ~= l_27_1.sympathy_civ then
      debug_pause_unit(l_27_2, "[PlayerBleedOut:on_civ_revive_failed] idiot thinks he is reviving", l_27_2)
      return 
    end
    l_27_1.unit:character_damage():unpause_downed_timer()
    l_27_1.sympathy_civ = nil
  end
end

PlayerBleedOut.verif_clbk_is_unit_deathguard = function(l_28_0, l_28_1)
  local char_tweak = tweak_data.character[l_28_1:base()._tweak_table]
  return char_tweak.deathguard
end

PlayerBleedOut.clbk_deathguard_administered = function(l_29_0, l_29_1)
  l_29_1:movement():set_cool(false)
end

PlayerBleedOut.pre_destroy = function(l_30_0, l_30_1)
  if Network:is_server() then
    l_30_0:_unregister_revive_SO()
  end
end

PlayerBleedOut.destroy = function(l_31_0)
  if Network:is_server() then
    l_31_0:_unregister_revive_SO()
  end
end


