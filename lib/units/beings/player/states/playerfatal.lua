-- Decompiled using luadec 2.0.1 by sztupy (http://winmo.sztupy.hu)
-- Command line was: F:\SteamLibrary\SteamApps\common\PAYDAY 2\lua\lib\units\beings\player\states\playerfatal.luac 

if not PlayerFatal then
  PlayerFatal = class(PlayerStandard)
end
PlayerFatal._update_movement = PlayerBleedOut._update_movement
PlayerFatal.init = function(l_1_0, l_1_1)
  PlayerFatal.super.init(l_1_0, l_1_1)
end

PlayerFatal.enter = function(l_2_0, l_2_1, l_2_2)
  PlayerFatal.super.enter(l_2_0, l_2_1, l_2_2)
  l_2_0:_interupt_action_steelsight()
  l_2_0:_start_action_dead(managers.player:player_timer():time())
  l_2_0:_start_action_unequip_weapon(managers.player:player_timer():time(), {selection_wanted = 1})
  l_2_0._unit:base():set_slot(l_2_0._unit, 4)
  l_2_0._unit:camera():camera_unit():base():set_target_tilt(80)
  if l_2_0._ext_movement:nav_tracker() then
    managers.groupai:state():on_criminal_neutralized(l_2_0._unit)
  end
  l_2_0._unit:character_damage():on_fatal_state_enter()
  if Network:is_server() and l_2_2 then
    if l_2_2.revive_SO_data then
      l_2_0._revive_SO_data = l_2_2.revive_SO_data
    end
    l_2_0._deathguard_SO_id = l_2_2.deathguard_SO_id
  end
  if l_2_2 then
    l_2_0._reequip_weapon = l_2_2.equip_weapon
  end
end

PlayerFatal._enter = function(l_3_0, l_3_1)
  l_3_0._ext_movement:set_attention_settings({"pl_team_idle_std", "pl_civ_cbt"})
  if Network:is_server() and l_3_0._ext_movement:nav_tracker() then
    managers.groupai:state():on_player_weapons_hot()
  end
end

PlayerFatal.exit = function(l_4_0, l_4_1, l_4_2)
  PlayerFatal.super.exit(l_4_0, l_4_1, l_4_2)
  l_4_0:_end_action_dead(managers.player:player_timer():time())
  if Network:is_server() then
    PlayerBleedOut._unregister_revive_SO(l_4_0)
  end
  l_4_0._revive_SO_data = nil
  if l_4_0._stats_screen then
    l_4_0._stats_screen = false
    managers.hud:hide_stats_screen()
  end
  local exit_data = {equip_weapon = l_4_0._reequip_weapon}
  if l_4_2 == "standard" then
    exit_data.wants_crouch = true
  end
  return exit_data
end

PlayerFatal.interaction_blocked = function(l_5_0)
  return true
end

PlayerFatal.update = function(l_6_0, l_6_1, l_6_2)
  PlayerFatal.super.update(l_6_0, l_6_1, l_6_2)
end

PlayerFatal._update_check_actions = function(l_7_0, l_7_1, l_7_2)
  local input = l_7_0:_get_input()
  l_7_0:_update_foley(l_7_1, input)
  local new_action = nil
  if input.btn_stats_screen_press then
    l_7_0._unit:base():set_stats_screen_visible(true)
  elseif input.btn_stats_screen_release then
    l_7_0._unit:base():set_stats_screen_visible(false)
  end
  l_7_0:_check_action_interact(l_7_1, input)
end

PlayerFatal._check_action_interact = function(l_8_0, l_8_1, l_8_2)
  if l_8_2.btn_interact_press and (not l_8_0._intimidate_t or tweak_data.player.movement_state.interaction_delay < l_8_1 - l_8_0._intimidate_t) then
    l_8_0._intimidate_t = l_8_1
    if not PlayerArrested.call_teammate(l_8_0, "f11", l_8_1, true, true) then
      PlayerBleedOut.call_civilian(l_8_0, "f11", l_8_1, false, true, l_8_0._revive_SO_data)
    end
  end
end

PlayerFatal._start_action_dead = function(l_9_0, l_9_1)
  l_9_0:_interupt_action_running(l_9_1)
  l_9_0._state_data.ducking = true
  l_9_0:_stance_entered()
  l_9_0:_update_crosshair_offset()
  l_9_0._unit:kill_mover()
  l_9_0._unit:activate_mover(Idstring("duck"))
end

PlayerFatal._end_action_dead = function(l_10_0, l_10_1)
  if not l_10_0:_can_stand() then
    return 
  end
  l_10_0._state_data.ducking = false
  l_10_0:_stance_entered()
  l_10_0:_update_crosshair_offset()
  l_10_0._unit:kill_mover()
  l_10_0._unit:activate_mover(Idstring("stand"))
end

PlayerFatal.pre_destroy = function(l_11_0, l_11_1)
  if Network:is_server() then
    PlayerBleedOut._unregister_revive_SO(l_11_0)
  end
end

PlayerFatal.destroy = function(l_12_0)
  if Network:is_server() then
    PlayerBleedOut._unregister_revive_SO(l_12_0)
  end
end


