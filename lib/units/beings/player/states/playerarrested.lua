-- Decompiled using luadec 2.0.1 by sztupy (http://winmo.sztupy.hu)
-- Command line was: F:\SteamLibrary\SteamApps\common\PAYDAY 2\lua\lib\units\beings\player\states\playerarrested.luac 

if not PlayerArrested then
  PlayerArrested = class(PlayerStandard)
end
PlayerArrested.init = function(l_1_0, l_1_1)
  PlayerArrested.super.init(l_1_0, l_1_1)
  l_1_0._ids_escape = Idstring("escape")
  l_1_0._ids_cuffed = Idstring("cuffed")
end

PlayerArrested.enter = function(l_2_0, l_2_1, l_2_2)
  PlayerArrested.super.enter(l_2_0, l_2_1, l_2_2)
  l_2_0._revive_SO_data = {unit = l_2_0._unit}
  l_2_0._old_selection = l_2_0._unit:inventory():equipped_selection()
  l_2_0:_start_action_handcuffed(managers.player:player_timer():time())
  l_2_0:_start_action_unequip_weapon(managers.player:player_timer():time(), {selection_wanted = 1})
  l_2_0._timer_finished = false
  if Network:is_server() then
    l_2_0._unit:base():set_slot(l_2_0._unit, 4)
    PlayerBleedOut._register_revive_SO(l_2_0._revive_SO_data, "untie")
  end
  managers.groupai:state():on_criminal_neutralized(l_2_0._unit)
  managers.groupai:state():report_criminal_downed(l_2_0._unit)
  managers.hud:pd_hide_text()
  l_2_0._unit:camera():camera_unit():base():set_target_tilt(0)
  l_2_0._unit:camera():camera_unit():base():set_limits(135, nil)
  l_2_0._unit:character_damage():on_arrested()
  l_2_0._unit:character_damage():set_invulnerable(true)
  l_2_0._entry_speech_clbk = "PlayerArrested_entryspeech"
  managers.enemy:add_delayed_clbk(l_2_0._entry_speech_clbk, callback(l_2_0, l_2_0, "clbk_entry_speech"), managers.player:player_timer():time() + 5 + 2 * math.random())
end

PlayerArrested._enter = function(l_3_0, l_3_1)
  l_3_0._ext_movement:set_attention_settings({"pl_enemy_cur_peaceful", "pl_team_cur_peaceful", "pl_civ_cbt"})
  if Network:is_server() and l_3_0._ext_movement:nav_tracker() then
    managers.groupai:state():on_player_weapons_hot()
  end
end

PlayerArrested.exit = function(l_4_0, l_4_1, l_4_2)
  PlayerArrested.super.exit(l_4_0, l_4_1, l_4_2)
  l_4_0._unit:character_damage():set_invulnerable(false)
  l_4_0:_end_action_handcuffed(managers.player:player_timer():time())
  PlayerBleedOut._unregister_revive_SO(l_4_0)
  l_4_0._SO_id = nil
  l_4_0._rescuer = nil
  l_4_0._unit:character_damage():on_freed()
  l_4_0._unit:camera():camera_unit():base():remove_limits()
  managers.hud:pd_hide_text()
  if l_4_0._entry_speech_clbk then
    managers.enemy:remove_delayed_clbk(l_4_0._entry_speech_clbk)
    l_4_0._entry_speech_clbk = nil
  end
  if not l_4_0._unequip_weapon_expire_t and not l_4_0._timer_finished then
    local exit_data = {equip_weapon = l_4_0._old_selection}
    return exit_data
  end
end

PlayerArrested.interaction_blocked = function(l_5_0)
  return true
end

PlayerArrested.update = function(l_6_0, l_6_1, l_6_2)
  PlayerArrested.super.update(l_6_0, l_6_1, l_6_2)
end

PlayerArrested._update_check_actions = function(l_7_0, l_7_1, l_7_2)
  local input = l_7_0:_get_input()
  if input.btn_stats_screen_press then
    l_7_0._unit:base():set_stats_screen_visible(true)
  elseif input.btn_stats_screen_release then
    l_7_0._unit:base():set_stats_screen_visible(false)
  end
  l_7_0:_update_foley(l_7_1, input)
  if l_7_0._unit:character_damage()._arrested_timer <= 0 and not l_7_0._timer_finished then
    l_7_0._timer_finished = true
    managers.hud:pd_stop_timer()
    managers.hud:pd_show_text()
    l_7_0._unit:camera():play_redirect(l_7_0._ids_escape)
    PlayerStandard.say_line(l_7_0, "s21x_sin")
  end
  if l_7_0._equip_weapon_expire_t and l_7_0._equip_weapon_expire_t <= l_7_1 then
    l_7_0._equip_weapon_expire_t = nil
  end
  if l_7_0._unequip_weapon_expire_t and l_7_0._unequip_weapon_expire_t + 0.5 <= l_7_1 then
    l_7_0._unequip_weapon_expire_t = nil
    l_7_0._unit:camera():play_redirect(l_7_0._ids_cuffed)
  end
  l_7_0:_update_foley(l_7_1, input)
  local new_action = l_7_0:_check_action_interact(l_7_1, input)
end

PlayerArrested._check_action_interact = function(l_8_0, l_8_1, l_8_2)
  local new_action = nil
  local interaction_wanted = l_8_2.btn_interact_press
  if interaction_wanted then
    if not l_8_0:chk_action_forbidden("interact") then
      local action_forbidden = l_8_0._stats_screen
    end
    if not action_forbidden then
      if l_8_0._timer_finished then
        l_8_0._unit:character_damage():revive(true)
        return 
      else
        new_action = l_8_0:_start_action_distance_interact(l_8_1)
      end
    end
  end
  return new_action
end

PlayerArrested._start_action_distance_interact = function(l_9_0, l_9_1)
  if not l_9_0._intimidate_t or tweak_data.player.movement_state.interaction_delay < l_9_1 - l_9_0._intimidate_t then
    l_9_0._intimidate_t = l_9_1
    l_9_0:call_teammate("f13", l_9_1, true, true)
  end
end

PlayerArrested.call_teammate = function(l_10_0, l_10_1, l_10_2, l_10_3, l_10_4)
  local voice_type, plural, prime_target = l_10_0:_get_unit_intimidation_action(true, false, true, true, false)
  do
    local interact_type, queue_name = nil, nil
    if voice_type == "come" then
      interact_type = "cmd_come"
      local character_code = managers.criminals:character_static_data_by_unit(prime_target.unit).ssuffix
      queue_name = l_10_1 .. character_code .. "_sin"
    elseif voice_type == "stop_cop" then
      local shout_sound = tweak_data.character[prime_target.unit:base()._tweak_table].priority_shout
      if (managers.groupai:state():whisper_mode() and tweak_data.character[prime_target.unit:base()._tweak_table].silent_priority_shout) or shout_sound then
        interact_type = "cmd_point"
        queue_name = shout_sound .. "y_any"
        if not managers.player:has_category_upgrade("player", "marked_enemy_extra_damage") then
          local marked_extra_damage = not managers.player:has_category_upgrade("player", "special_enemy_highlight") or false
        end
        managers.game_play_central:add_enemy_contour(prime_target.unit, marked_extra_damage)
        managers.network:session():send_to_peers_synched("mark_enemy", prime_target.unit, marked_extra_damage)
        managers.challenges:set_flag("eagle_eyes")
      end
    end
    if l_10_3 or not interact_type then
      l_10_0:_do_action_intimidate(l_10_2, not interact_type or nil, queue_name, l_10_4)
      return true
    end
     -- Warning: missing end command somewhere! Added here
  end
end

PlayerArrested._update_movement = function(l_11_0, l_11_1, l_11_2)
end

PlayerArrested._start_action_handcuffed = function(l_12_0, l_12_1)
  l_12_0:_interupt_action_running(l_12_1)
  l_12_0._state_data.ducking = true
  l_12_0:_stance_entered(true)
  l_12_0:_update_crosshair_offset()
  l_12_0._unit:kill_mover()
  l_12_0._unit:character_damage()._arrested = true
  l_12_0._unit:activate_mover(Idstring("duck"))
end

PlayerArrested._end_action_handcuffed = function(l_13_0, l_13_1)
  if not l_13_0:_can_stand() then
    return 
  end
  l_13_0._state_data.ducking = false
  l_13_0:_stance_entered()
  l_13_0:_update_crosshair_offset()
  l_13_0._unit:kill_mover()
  l_13_0._unit:character_damage()._arrested = nil
  l_13_0._unit:activate_mover(Idstring("stand"))
end

PlayerArrested.clbk_entry_speech = function(l_14_0)
  l_14_0._entry_speech_clbk = nil
  PlayerStandard.say_line(l_14_0, "s20x_sin")
end

PlayerArrested.pre_destroy = function(l_15_0, l_15_1)
  PlayerBleedOut._unregister_revive_SO(l_15_0)
  if l_15_0._entry_speech_clbk then
    managers.enemy:remove_delayed_clbk(l_15_0._entry_speech_clbk)
    l_15_0._entry_speech_clbk = nil
  end
end

PlayerArrested.destroy = function(l_16_0)
  PlayerBleedOut._unregister_revive_SO(l_16_0)
end


