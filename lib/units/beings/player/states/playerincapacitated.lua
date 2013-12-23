-- Decompiled using luadec 2.0.1 by sztupy (http://winmo.sztupy.hu)
-- Command line was: F:\SteamLibrary\SteamApps\common\PAYDAY 2\lua\lib\units\beings\player\states\playerincapacitated.luac 

if not PlayerIncapacitated then
  PlayerIncapacitated = class(PlayerStandard)
end
PlayerIncapacitated._update_movement = PlayerBleedOut._update_movement
PlayerIncapacitated.init = function(l_1_0, l_1_1)
  PlayerIncapacitated.super.init(l_1_0, l_1_1)
  l_1_0._ids_tased_exit = Idstring("tased_exit")
end

PlayerIncapacitated.enter = function(l_2_0, l_2_1, l_2_2)
  PlayerIncapacitated.super.enter(l_2_0, l_2_1, l_2_2)
  l_2_0._revive_SO_data = {unit = l_2_0._unit}
  l_2_0:_start_action_incapacitated(managers.player:player_timer():time())
  l_2_0._unit:base():set_slot(l_2_0._unit, 4)
  l_2_0._unit:camera():camera_unit():base():set_target_tilt(80)
  l_2_0._unit:character_damage():on_incapacitated()
  l_2_0._unit:character_damage():on_incapacitated_state_enter()
  if l_2_2 then
    l_2_0._reequip_weapon = l_2_2.equip_weapon
  end
  l_2_0._next_shock = 0.5
  l_2_0._taser_value = 0.5
  managers.groupai:state():on_criminal_neutralized(l_2_0._unit)
  if Network:is_server() then
    PlayerBleedOut._register_revive_SO(l_2_0._revive_SO_data, "revive")
  end
  managers.groupai:state():report_criminal_downed(l_2_0._unit)
end

PlayerIncapacitated._enter = function(l_3_0, l_3_1)
  l_3_0._ext_movement:set_attention_settings({"pl_team_idle_std", "pl_civ_cbt"})
  if Network:is_server() and l_3_0._ext_movement:nav_tracker() then
    managers.groupai:state():on_player_weapons_hot()
  end
end

PlayerIncapacitated.exit = function(l_4_0, l_4_1, l_4_2)
  PlayerIncapacitated.super.exit(l_4_0, l_4_1, l_4_2)
  l_4_0:_end_action_incapacitated(managers.player:player_timer():time())
  managers.environment_controller:set_taser_value(1)
  PlayerBleedOut._unregister_revive_SO(l_4_0)
  return {equip_weapon = l_4_0._reequip_weapon}
end

PlayerIncapacitated.interaction_blocked = function(l_5_0)
  return true
end

PlayerIncapacitated.update = function(l_6_0, l_6_1, l_6_2)
  PlayerIncapacitated.super.update(l_6_0, l_6_1, l_6_2)
end

PlayerIncapacitated._update_check_actions = function(l_7_0, l_7_1, l_7_2)
  local input = l_7_0:_get_input()
  if l_7_0._next_shock < l_7_1 then
    l_7_0._unit:camera():play_shaker("player_taser_shock", 0.5, 10)
    l_7_0._next_shock = l_7_1 + 0.5 + math.rand(2.5)
    l_7_0._camera_unit:base():start_shooting()
    l_7_0._recoil_t = l_7_1 + 0.5
    l_7_0._camera_unit:base():recoil_kick(-2, 2, -2, 2)
    l_7_0._taser_value = 0.25
    managers.rumble:play("incapacitated_shock")
    l_7_0._unit:camera()._camera_unit:base():animate_fov(math.lerp(65, 75, math.random()), 0.33000001311302)
  elseif l_7_0._recoil_t and l_7_0._recoil_t < l_7_1 then
    l_7_0._recoil_t = nil
    l_7_0._camera_unit:base():stop_shooting()
  end
  l_7_0._taser_value = math.step(l_7_0._taser_value, 0.75, l_7_2 / 2)
  managers.environment_controller:set_taser_value(l_7_0._taser_value)
  if input.btn_stats_screen_press then
    l_7_0._unit:base():set_stats_screen_visible(true)
  elseif input.btn_stats_screen_release then
    l_7_0._unit:base():set_stats_screen_visible(false)
  end
  l_7_0:_update_foley(l_7_1, input)
  local new_action = nil
  l_7_0:_check_action_interact(l_7_1, input)
end

PlayerIncapacitated._check_action_interact = function(l_8_0, l_8_1, l_8_2)
  if l_8_2.btn_interact_press and (not l_8_0._intimidate_t or tweak_data.player.movement_state.interaction_delay < l_8_1 - l_8_0._intimidate_t) then
    l_8_0._intimidate_t = l_8_1
    PlayerArrested.call_teammate(l_8_0, "f11", l_8_1, true, true)
  end
end

PlayerIncapacitated._start_action_incapacitated = function(l_9_0, l_9_1)
  l_9_0:_interupt_action_running(l_9_1)
  l_9_0._state_data.ducking = true
  l_9_0:_stance_entered()
  l_9_0:_update_crosshair_offset()
  l_9_0._unit:kill_mover()
  l_9_0._unit:activate_mover(Idstring("duck"))
  l_9_0._unit:camera():play_redirect(l_9_0._ids_tased_exit)
  l_9_0._unit:camera()._camera_unit:base():animate_fov(75)
end

PlayerIncapacitated._end_action_incapacitated = function(l_10_0, l_10_1)
  if not l_10_0:_can_stand() then
    return 
  end
  l_10_0._state_data.ducking = false
  l_10_0:_stance_entered()
  l_10_0:_update_crosshair_offset()
  l_10_0._unit:kill_mover()
  l_10_0._unit:activate_mover(Idstring("stand"))
end

PlayerIncapacitated.pre_destroy = function(l_11_0, l_11_1)
  PlayerBleedOut._unregister_revive_SO(l_11_0)
end

PlayerIncapacitated.destroy = function(l_12_0, l_12_1)
  PlayerBleedOut._unregister_revive_SO(l_12_0)
  managers.environment_controller:set_taser_value(1)
end


