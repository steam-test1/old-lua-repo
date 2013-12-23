-- Decompiled using luadec 2.0.1 by sztupy (http://winmo.sztupy.hu)
-- Command line was: F:\SteamLibrary\SteamApps\common\PAYDAY 2\lua\lib\units\beings\player\states\playercarry.luac 

if not PlayerCarry then
  PlayerCarry = class(PlayerStandard)
end
PlayerCarry.init = function(l_1_0, l_1_1)
  PlayerCarry.super.init(l_1_0, l_1_1)
end

PlayerCarry.enter = function(l_2_0, l_2_1, l_2_2)
  PlayerCarry.super.enter(l_2_0, l_2_1, l_2_2)
  l_2_0._unit:camera():camera_unit():base():set_target_tilt(-5)
end

PlayerCarry._enter = function(l_3_0, l_3_1)
  local my_carry_data = managers.player:get_my_carry_data()
  if my_carry_data then
    local carry_data = tweak_data.carry[my_carry_data.carry_id]
    print("SET CARRY TYPE ON ENTER", carry_data.type)
    l_3_0._tweak_data_name = carry_data.type
  else
    l_3_0._tweak_data_name = "light"
  end
  if l_3_0._ext_movement:nav_tracker() then
    managers.groupai:state():on_criminal_recovered(l_3_0._unit)
  end
  if not l_3_0._state_data.ducking then
    l_3_0._ext_movement:set_attention_settings({"pl_enemy_cbt", "pl_team_idle_std", "pl_civ_cbt"})
  end
end

PlayerCarry.exit = function(l_4_0, l_4_1, l_4_2)
  PlayerCarry.super.exit(l_4_0, l_4_1, l_4_2)
  l_4_0._unit:camera():camera_unit():base():set_target_tilt(0)
  local exit_data = {}
  exit_data.skip_equip = true
  l_4_0._dye_risk = nil
  return exit_data
end

PlayerCarry.update = function(l_5_0, l_5_1, l_5_2)
  PlayerCarry.super.update(l_5_0, l_5_1, l_5_2)
  if l_5_0._dye_risk and l_5_0._dye_risk.next_t < l_5_1 then
    l_5_0:_check_dye_explode()
  end
end

PlayerCarry.set_tweak_data = function(l_6_0, l_6_1)
  l_6_0._tweak_data_name = l_6_1
  l_6_0:_check_dye_pack()
end

PlayerCarry._check_dye_pack = function(l_7_0)
  local my_carry_data = managers.player:get_my_carry_data()
  if my_carry_data.has_dye_pack then
    l_7_0._dye_risk = {}
    l_7_0._dye_risk.next_t = managers.player:player_timer():time() + 2 + math.random(3)
  end
end

PlayerCarry._check_dye_explode = function(l_8_0)
  local chance = math.rand(1)
  if chance < 0.25 then
    print("DYE BOOM")
    l_8_0._dye_risk = nil
    managers.player:dye_pack_exploded()
    return 
  end
  l_8_0._dye_risk.next_t = managers.player:player_timer():time() + 2 + math.random(3)
end

PlayerCarry._update_check_actions = function(l_9_0, l_9_1, l_9_2)
  local input = l_9_0:_get_input()
  l_9_0:_determine_move_direction()
  l_9_0:_update_interaction_timers(l_9_1)
  l_9_0:_update_reload_timers(l_9_1, l_9_2, input)
  l_9_0:_update_melee_timers(l_9_1, input)
  l_9_0:_update_equip_weapon_timers(l_9_1, input)
  l_9_0:_update_running_timers(l_9_1)
  if input.btn_stats_screen_press then
    l_9_0._unit:base():set_stats_screen_visible(true)
  elseif input.btn_stats_screen_release then
    l_9_0._unit:base():set_stats_screen_visible(false)
  end
  l_9_0:_update_foley(l_9_1, input)
  local new_action = nil
  if not new_action then
    new_action = l_9_0:_check_action_weapon_gadget(l_9_1, input)
  end
  if not new_action then
    new_action = l_9_0:_check_action_melee(l_9_1, input)
  end
  if not new_action then
    new_action = l_9_0:_check_action_reload(l_9_1, input)
  end
  if not new_action then
    new_action = l_9_0:_check_change_weapon(l_9_1, input)
  end
  if not new_action then
    new_action = l_9_0:_check_action_equip(l_9_1, input)
  end
  if not new_action then
    new_action = l_9_0:_check_action_primary_attack(l_9_1, input)
    l_9_0._shooting = new_action
  end
  l_9_0:_check_action_interact(l_9_1, input)
  l_9_0:_check_action_jump(l_9_1, input)
  l_9_0:_check_action_run(l_9_1, input)
  l_9_0:_check_action_duck(l_9_1, input)
  l_9_0:_check_action_steelsight(l_9_1, input)
  l_9_0:_check_use_item(l_9_1, input)
  l_9_0:_find_pickups(l_9_1)
end

PlayerCarry._check_action_run = function(l_10_0, ...)
  if tweak_data.carry.types[l_10_0._tweak_data_name].can_run then
    PlayerCarry.super._check_action_run(l_10_0, ...)
     -- DECOMPILER ERROR: Confused about usage of registers for local variables.

  end
end

PlayerCarry._check_use_item = function(l_11_0, l_11_1, l_11_2)
  local new_action = nil
  local action_wanted = l_11_2.btn_use_item_press
  if action_wanted then
    if not l_11_0._use_item_expire_t and not l_11_0:_changing_weapon() and not l_11_0:_interacting() then
      local action_forbidden = l_11_0._ext_movement:has_carry_restriction()
    end
    if not action_forbidden then
      managers.player:drop_carry()
      new_action = true
    end
  end
  return new_action
end

PlayerCarry._check_change_weapon = function(l_12_0, ...)
  return PlayerCarry.super._check_change_weapon(l_12_0, ...)
   -- DECOMPILER ERROR: Confused about usage of registers for local variables.

end

PlayerCarry._check_action_equip = function(l_13_0, ...)
  return PlayerCarry.super._check_action_equip(l_13_0, ...)
   -- DECOMPILER ERROR: Confused about usage of registers for local variables.

end

PlayerCarry._update_movement = function(l_14_0, l_14_1, l_14_2)
  PlayerCarry.super._update_movement(l_14_0, l_14_1, l_14_2)
end

PlayerCarry._start_action_jump = function(l_15_0, ...)
  PlayerCarry.super._start_action_jump(l_15_0, ...)
   -- DECOMPILER ERROR: Confused about usage of registers for local variables.

end

PlayerCarry._perform_jump = function(l_16_0, l_16_1)
  mvector3.multiply(l_16_1, tweak_data.carry.types[l_16_0._tweak_data_name].jump_modifier)
  PlayerCarry.super._perform_jump(l_16_0, l_16_1)
end

PlayerCarry._get_max_walk_speed = function(l_17_0, ...)
  do
    local multiplier = tweak_data.carry.types[l_17_0._tweak_data_name].move_speed_modifier
    multiplier = math.clamp(multiplier * managers.player:upgrade_value("carry", "movement_speed_multiplier", 1), 0, 1)
    return PlayerCarry.super._get_max_walk_speed(l_17_0, ...) * multiplier
  end
   -- DECOMPILER ERROR: Confused about usage of registers for local variables.

end

PlayerCarry._get_walk_headbob = function(l_18_0, ...)
  return PlayerCarry.super._get_walk_headbob(l_18_0, ...) * tweak_data.carry.types[l_18_0._tweak_data_name].move_speed_modifier
   -- DECOMPILER ERROR: Confused about usage of registers for local variables.

end

PlayerCarry.pre_destroy = function(l_19_0, l_19_1)
end

PlayerCarry.destroy = function(l_20_0)
end


