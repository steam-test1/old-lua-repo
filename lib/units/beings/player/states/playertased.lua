-- Decompiled using luadec 2.0.1 by sztupy (http://winmo.sztupy.hu)
-- Command line was: F:\SteamLibrary\SteamApps\common\PAYDAY 2\lua\lib\units\beings\player\states\playertased.luac 

if not PlayerTased then
  PlayerTased = class(PlayerStandard)
end
PlayerTased._update_movement = PlayerBleedOut._update_movement
PlayerTased.enter = function(l_1_0, l_1_1, l_1_2)
  PlayerTased.super.enter(l_1_0, l_1_1, l_1_2)
  l_1_0._ids_tased_boost = Idstring("tased_boost")
  l_1_0._ids_tased = Idstring("tased")
  l_1_0._ids_counter_tase = Idstring("tazer_counter")
  l_1_0:_start_action_tased(managers.player:player_timer():time(), l_1_1.non_lethal_electrocution)
  if l_1_1.non_lethal_electrocution then
    l_1_1.non_lethal_electrocution = nil
    local recover_time = Application:time() + tweak_data.player.damage.TASED_TIME * managers.player:upgrade_value("player", "electrocution_resistance_multiplier", 1)
    l_1_0._recover_delayed_clbk = "PlayerTased_recover_delayed_clbk"
    managers.enemy:add_delayed_clbk(l_1_0._recover_delayed_clbk, callback(l_1_0, l_1_0, "clbk_exit_to_std"), recover_time)
  else
    l_1_0._fatal_delayed_clbk = "PlayerTased_fatal_delayed_clbk"
    managers.enemy:add_delayed_clbk(l_1_0._fatal_delayed_clbk, callback(l_1_0, l_1_0, "clbk_exit_to_fatal"), managers.player:player_timer():time() + tweak_data.player.damage.TASED_TIME)
  end
  l_1_0._next_shock = 0.5
  l_1_0._taser_value = 1
  managers.groupai:state():on_criminal_disabled(l_1_0._unit, "electrified")
  if Network:is_server() then
    l_1_0:_register_revive_SO()
  end
  l_1_0._equipped_unit:base():on_reload()
  l_1_0:_interupt_action_reload()
  l_1_0:_interupt_action_steelsight()
  l_1_0._rumble_electrified = managers.rumble:play("electrified")
end

PlayerTased._enter = function(l_2_0, l_2_1)
  l_2_0._unit:base():set_slot(l_2_0._unit, 2)
  l_2_0._unit:camera():camera_unit():base():set_target_tilt(0)
  l_2_0._ext_movement:set_attention_settings({"pl_enemy_cbt", "pl_team_idle_std", "pl_civ_cbt"})
  if Network:is_server() and l_2_0._ext_movement:nav_tracker() then
    managers.groupai:state():on_player_weapons_hot()
  end
end

PlayerTased.exit = function(l_3_0, l_3_1, l_3_2)
  PlayerTased.super.exit(l_3_0, l_3_1, l_3_2)
  if l_3_0._fatal_delayed_clbk then
    managers.enemy:remove_delayed_clbk(l_3_0._fatal_delayed_clbk)
    l_3_0._fatal_delayed_clbk = nil
  end
  if l_3_0._recover_delayed_clbk then
    managers.enemy:remove_delayed_clbk(l_3_0._recover_delayed_clbk)
    l_3_0._recover_delayed_clbk = nil
  end
  if Network:is_server() and l_3_0._SO_id then
    managers.groupai:state():remove_special_objective(l_3_0._SO_id)
  end
  managers.environment_controller:set_taser_value(1)
  l_3_0._camera_unit:base():break_recoil()
  l_3_0._unit:sound():play("tasered_stop")
  managers.rumble:stop(l_3_0._rumble_electrified)
  l_3_0._unit:camera():play_redirect(Idstring("idle"))
  l_3_0._tase_ended = nil
  l_3_0._counter_taser_unit = nil
end

PlayerTased.interaction_blocked = function(l_4_0)
  return true
end

PlayerTased.update = function(l_5_0, l_5_1, l_5_2)
  PlayerTased.super.update(l_5_0, l_5_1, l_5_2)
end

PlayerTased._update_check_actions = function(l_6_0, l_6_1, l_6_2)
  local input = l_6_0:_get_input()
  if l_6_0._next_shock < l_6_1 then
    l_6_0._next_shock = l_6_1 + 0.25 + math.rand(1)
    l_6_0._unit:camera():play_shaker("player_taser_shock", 1, 10)
    l_6_0._unit:camera():camera_unit():base():set_target_tilt((math.random(2) == 1 and -1 or 1) * math.random(10))
    l_6_0._taser_value = math.max(l_6_0._taser_value - 0.25, 0)
    l_6_0._unit:sound():play("tasered_shock")
    managers.rumble:play("electric_shock")
    if not alive(l_6_0._counter_taser_unit) then
      l_6_0._camera_unit:base():start_shooting()
      l_6_0._recoil_t = l_6_1 + 0.5
      input.btn_primary_attack_state = true
      input.btn_primary_attack_press = true
      l_6_0._camera_unit:base():recoil_kick(-5, 5, -5, 5)
      l_6_0._unit:camera():play_redirect(l_6_0._ids_tased_boost)
    elseif l_6_0._recoil_t then
      input.btn_primary_attack_state = true
      if l_6_0._recoil_t < l_6_1 then
        l_6_0._recoil_t = nil
        l_6_0._camera_unit:base():stop_shooting()
      end
    end
  end
  l_6_0._taser_value = math.step(l_6_0._taser_value, 0.80000001192093, l_6_2 / 4)
  managers.environment_controller:set_taser_value(l_6_0._taser_value)
  l_6_0._shooting = l_6_0:_check_action_primary_attack(l_6_1, input)
  if l_6_0._shooting then
    l_6_0._camera_unit:base():recoil_kick(-5, 5, -5, 5)
  end
  if l_6_0._unequip_weapon_expire_t and l_6_0._unequip_weapon_expire_t <= l_6_1 then
    l_6_0._unequip_weapon_expire_t = nil
    l_6_0:_start_action_equip_weapon(l_6_1)
  end
  if l_6_0._equip_weapon_expire_t and l_6_0._equip_weapon_expire_t <= l_6_1 then
    l_6_0._equip_weapon_expire_t = nil
  end
  if input.btn_stats_screen_press then
    l_6_0._unit:base():set_stats_screen_visible(true)
  elseif input.btn_stats_screen_release then
    l_6_0._unit:base():set_stats_screen_visible(false)
  end
  l_6_0:_update_foley(l_6_1, input)
  local new_action = nil
   -- DECOMPILER ERROR: Confused while interpreting a jump as a 'while'

end
l_6_0:_check_action_interact(l_6_1, input)
local new_action = nil
end

PlayerTased._check_action_primary_attack = function(l_7_0, l_7_1, l_7_2)
  local new_action = nil
  local action_forbidden = l_7_0:chk_action_forbidden("primary_attack")
  if not action_forbidden and not l_7_0:_is_reloading() and not l_7_0:_changing_weapon() and not l_7_0._melee_expire_t and not l_7_0._use_item_expire_t and not l_7_0:_interacting() then
    action_forbidden = alive(l_7_0._counter_taser_unit)
  end
  local action_wanted = l_7_2.btn_primary_attack_state
  if action_wanted then
    if not action_forbidden then
      l_7_0._queue_reload_interupt = nil
      l_7_0._ext_inventory:equip_selected_primary(false)
      if l_7_0._equipped_unit then
        local weap_base = l_7_0._equipped_unit:base()
        local fire_mode = weap_base:fire_mode()
        if weap_base:out_of_ammo() and l_7_2.btn_primary_attack_press then
          weap_base:dryfire()
          do return end
           -- DECOMPILER ERROR: unhandled construct in 'if'

          if weap_base.clip_empty and weap_base:clip_empty() and fire_mode == "single" and l_7_2.btn_primary_attack_press then
            weap_base:dryfire()
            do return end
            if l_7_0._running then
              l_7_0:_interupt_action_running(l_7_1)
            elseif (fire_mode ~= "single" or not l_7_2.btn_primary_attack_press) then
               -- DECOMPILER ERROR: Attempted to build a boolean expression without a pending context

              local start = error_maybe_false
              if not start then
                if fire_mode ~= "single" then
                  start = l_7_2.btn_primary_attack_state
                else
                  start = false
                end
                if start then
                  weap_base:start_shooting()
                  l_7_0._camera_unit:base():start_shooting()
                  if not l_7_0._state_data.in_steelsight or not weap_base:tweak_data_anim_play("fire_steelsight", weap_base:fire_rate_multiplier()) then
                    weap_base:tweak_data_anim_play("fire", weap_base:fire_rate_multiplier())
                  end
                end
              end
              local suppression_mul = managers.player:upgrade_value("player", "suppression_multiplier", 1) * managers.player:upgrade_value("player", "suppression_multiplier2", 1) * managers.player:upgrade_value("player", "passive_suppression_multiplier", 1)
              local fired = nil
              if fire_mode == "single" and l_7_2.btn_primary_attack_press then
                fired = weap_base:trigger_pressed(l_7_0._ext_camera:position(), (l_7_0._ext_camera:forward()), nil, nil, nil, nil, suppression_mul)
              end
              new_action = true
              if fired then
                local weap_tweak_data = tweak_data.weapon[weap_base:get_name_id()]
                if not l_7_0._state_data.in_steelsight then
                  do return end
                end
                 -- DECOMPILER ERROR: Confused while interpreting a jump as a 'while'

              end
              local recoil_multiplier = weap_base:recoil() * weap_base:recoil_multiplier()
              local up, down, left, right = unpack(weap_tweak_data.kick[(l_7_0._state_data.in_steelsight and "steelsight") or (l_7_0._state_data.ducking and "crouching") or "standing"])
              l_7_0._camera_unit:base():recoil_kick(up * recoil_multiplier, down * recoil_multiplier, left * recoil_multiplier, right * recoil_multiplier)
              local spread_multiplier = weap_base:spread_multiplier()
               -- DECOMPILER ERROR: Confused while interpreting a jump as a 'while'

            end
            managers.hud:_kick_crosshair_offset(weap_tweak_data.crosshair[not weap_tweak_data.crosshair or "standing"].kick_offset * spread_multiplier)
            managers.hud:set_ammo_amount(weap_base:selection_index(), weap_base:ammo_info())
            if l_7_0._ext_network then
              local impact = not fired.hit_enemy
              l_7_0._ext_network:send("shot_blank", impact)
            elseif fire_mode == "single" then
              new_action = false
            else
              if l_7_0:_is_reloading() and l_7_0._equipped_unit:base():reload_interuptable() and l_7_2.btn_primary_attack_press then
                l_7_0._queue_reload_interupt = true
            end
          end
        end
      end
    end
  end
  if not new_action and l_7_0._shooting then
    l_7_0._equipped_unit:base():stop_shooting()
    l_7_0._camera_unit:base():stop_shooting()
  end
  return new_action
end

PlayerTased._check_action_interact = function(l_8_0, l_8_1, l_8_2)
  if l_8_2.btn_interact_press and (not l_8_0._intimidate_t or tweak_data.player.movement_state.interaction_delay < l_8_1 - l_8_0._intimidate_t) and not alive(l_8_0._counter_taser_unit) then
    l_8_0._intimidate_t = l_8_1
    l_8_0:call_teammate(nil, l_8_1, true, true)
  end
end

PlayerTased.call_teammate = function(l_9_0, l_9_1, l_9_2, l_9_3, l_9_4)
  local voice_type, plural, prime_target = l_9_0:_get_unit_intimidation_action(true, false, false, true, false)
  do
    local interact_type, queue_name = nil, nil
    if voice_type == "stop_cop" or voice_type == "mark_cop" then
      local prime_target_tweak = tweak_data.character[prime_target.unit:base()._tweak_table]
      local shout_sound = prime_target_tweak.priority_shout
      if (managers.groupai:state():whisper_mode() and prime_target_tweak.silent_priority_shout) or shout_sound then
        interact_type = "cmd_point"
        queue_name = "s07x_sin"
        do
          if not managers.player:has_category_upgrade("player", "marked_enemy_extra_damage") then
            local marked_extra_damage = not managers.player:has_category_upgrade("player", "special_enemy_highlight") or false
          end
          managers.game_play_central:add_enemy_contour(prime_target.unit, marked_extra_damage)
          managers.network:session():send_to_peers_synched("mark_enemy", prime_target.unit, marked_extra_damage)
          managers.challenges:set_flag("eagle_eyes")
        end
        if not l_9_0._tase_ended and managers.player:has_category_upgrade("player", "taser_self_shock") and prime_target.unit:key() == l_9_0._unit:character_damage():tase_data().attacker_unit:key() then
          l_9_0:_start_action_counter_tase(l_9_2, prime_target)
        end
      end
    end
    if l_9_3 or not interact_type then
      l_9_0:_do_action_intimidate(l_9_2, not interact_type or nil, queue_name, l_9_4)
    end
     -- Warning: missing end command somewhere! Added here
  end
end

PlayerTased._start_action_tased = function(l_10_0, l_10_1, l_10_2)
  l_10_0:_interupt_action_running(l_10_1)
  l_10_0:_stance_entered()
  l_10_0:_update_crosshair_offset()
  l_10_0._unit:camera():play_redirect(l_10_0._ids_tased)
  l_10_0._unit:sound():play("tasered_loop")
  managers.hint:show_hint(l_10_2 and "hint_been_electrocuted" or "hint_been_tasered")
end

PlayerTased._start_action_counter_tase = function(l_11_0, l_11_1, l_11_2)
  l_11_0._counter_taser_unit = l_11_2.unit
  l_11_0._unit:camera():play_redirect(l_11_0._ids_counter_tase)
end

PlayerTased._register_revive_SO = function(l_12_0)
  if l_12_0._SO_id or not managers.navigation:is_data_ready() then
    return 
  end
  local objective = {type = "follow", follow_unit = l_12_0._unit, called = true, destroy_clbk_key = false, scan = true, nav_seg = l_12_0._unit:movement():nav_tracker():nav_segment()}
  local so_descriptor = {objective = objective, base_chance = 1, chance_inc = 0, interval = 6, search_dis_sq = 25000000, search_pos = l_12_0._unit:position(), usage_amount = 1, AI_group = "friendlies"}
  local so_id = "PlayerTased_assistance"
  l_12_0._SO_id = so_id
  managers.groupai:state():add_special_objective(so_id, so_descriptor)
end

PlayerTased.clbk_exit_to_fatal = function(l_13_0)
  l_13_0._fatal_delayed_clbk = nil
  managers.player:set_player_state("incapacitated")
end

PlayerTased.clbk_exit_to_std = function(l_14_0)
  l_14_0._recover_delayed_clbk = nil
  managers.player:set_player_state("standard")
end

PlayerTased.on_tase_ended = function(l_15_0)
  l_15_0._tase_ended = true
  if l_15_0._fatal_delayed_clbk then
    managers.enemy:remove_delayed_clbk(l_15_0._fatal_delayed_clbk)
    l_15_0._fatal_delayed_clbk = nil
  end
  if not l_15_0._recover_delayed_clbk then
    l_15_0._recover_delayed_clbk = "PlayerTased_recover_delayed_clbk"
    managers.enemy:add_delayed_clbk(l_15_0._recover_delayed_clbk, callback(l_15_0, l_15_0, "clbk_exit_to_std"), managers.player:player_timer():time() + tweak_data.player.damage.TASED_RECOVER_TIME)
  end
end

PlayerTased.give_shock_to_taser = function(l_16_0)
  if not alive(l_16_0._counter_taser_unit) then
    return 
  end
  l_16_0:_give_shock_to_taser(l_16_0._counter_taser_unit)
end

PlayerTased._give_shock_to_taser = function(l_17_0, l_17_1)
  local action_data = {variant = "counter_tased", damage = l_17_1:character_damage()._HEALTH_INIT * 0.20000000298023, damage_effect = l_17_1:character_damage()._HEALTH_INIT * 2, attacker_unit = l_17_0._unit, attack_dir = -l_17_1:movement()._action_common_data.fwd, col_ray = {position = mvector3.copy(l_17_1:movement():m_head_pos()), body = l_17_1:body("body")}}
  l_17_1:character_damage():damage_melee(action_data)
end


