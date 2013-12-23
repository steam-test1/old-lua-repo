-- Decompiled using luadec 2.0.1 by sztupy (http://winmo.sztupy.hu)
-- Command line was: F:\SteamLibrary\SteamApps\common\PAYDAY 2\lua\lib\units\beings\player\states\playermaskoff.luac 

if not PlayerMaskOff then
  PlayerMaskOff = class(PlayerStandard)
end
PlayerMaskOff.clbk_enemy_weapons_hot = PlayerClean.clbk_enemy_weapons_hot
PlayerMaskOff.init = function(l_1_0, l_1_1)
  PlayerMaskOff.super.init(l_1_0, l_1_1)
  l_1_0._ids_unequip = Idstring("unequip")
end

PlayerMaskOff.enter = function(l_2_0, l_2_1, l_2_2)
  PlayerMaskOff.super.enter(l_2_0, l_2_1, l_2_2)
end

PlayerMaskOff._enter = function(l_3_0, l_3_1)
  local equipped_selection = l_3_0._unit:inventory():equipped_selection()
  if equipped_selection ~= 1 then
    l_3_0._previous_equipped_selection = equipped_selection
    l_3_0._ext_inventory:equip_selection(1, false)
    managers.upgrades:setup_current_weapon()
  end
  if l_3_0._unit:camera():anim_data().equipped then
    l_3_0._unit:camera():play_redirect(l_3_0._ids_unequip)
  end
  l_3_0._unit:base():set_slot(l_3_0._unit, 4)
  l_3_0._ext_movement:set_attention_settings({"pl_law_susp_peaceful", "pl_gangster_cur_peaceful", "pl_team_cur_peaceful", "pl_civ_idle_peaceful"})
  if not managers.groupai:state():enemy_weapons_hot() then
    l_3_0._enemy_weapons_hot_listen_id = "PlayerMaskOff" .. tostring(l_3_0._unit:key())
    managers.groupai:state():add_listener(l_3_0._enemy_weapons_hot_listen_id, {"enemy_weapons_hot"}, callback(l_3_0, l_3_0, "clbk_enemy_weapons_hot"))
  end
  l_3_0._ext_network:send("set_stance", 1)
  l_3_0._show_casing_t = Application:time() + 4
end

PlayerMaskOff.exit = function(l_4_0, l_4_1, l_4_2)
  PlayerMaskOff.super.exit(l_4_0, l_4_1)
  managers.hud:hide_casing()
  if l_4_0._previous_equipped_selection then
    l_4_0._unit:inventory():equip_selection(l_4_0._previous_equipped_selection, false)
    l_4_0._previous_equipped_selection = nil
  end
  l_4_0._unit:base():set_slot(l_4_0._unit, 2)
  l_4_0._ext_movement:chk_play_mask_on_slow_mo(l_4_1)
  if l_4_0._enemy_weapons_hot_listen_id then
    managers.groupai:state():remove_listener(l_4_0._enemy_weapons_hot_listen_id)
  end
  l_4_0:_interupt_action_start_standard()
end

PlayerMaskOff.interaction_blocked = function(l_5_0)
  return true
end

PlayerMaskOff.update = function(l_6_0, l_6_1, l_6_2)
  PlayerMaskOff.super.update(l_6_0, l_6_1, l_6_2)
  if l_6_0._show_casing_t and l_6_0._show_casing_t < l_6_1 then
    l_6_0._show_casing_t = nil
    managers.hud:show_casing()
  end
end

PlayerMaskOff._update_check_actions = function(l_7_0, l_7_1, l_7_2)
  local input = l_7_0:_get_input()
  l_7_0._stick_move = l_7_0._controller:get_input_axis("move")
  if mvector3.length(l_7_0._stick_move) < 0.10000000149012 then
    l_7_0._move_dir = nil
  else
    l_7_0._move_dir = mvector3.copy(l_7_0._stick_move)
    local cam_flat_rot = Rotation(l_7_0._cam_fwd_flat, math.UP)
    mvector3.rotate_with(l_7_0._move_dir, cam_flat_rot)
  end
  l_7_0:_update_start_standard_timers(l_7_1)
  if input.btn_stats_screen_press then
    l_7_0._unit:base():set_stats_screen_visible(true)
  elseif input.btn_stats_screen_release then
    l_7_0._unit:base():set_stats_screen_visible(false)
  end
  l_7_0:_update_foley(l_7_1, input)
  local new_action = nil
  if not new_action and l_7_0._state_data.ducking then
    l_7_0:_end_action_ducking(l_7_1)
  end
  if not new_action then
    new_action = l_7_0:_check_use_item(l_7_1, input)
  end
  if not new_action then
    new_action = l_7_0:_check_action_interact(l_7_1, input)
  end
  l_7_0:_check_action_jump(l_7_1, input)
  l_7_0:_check_action_duck(l_7_1, input)
end

PlayerMaskOff._get_walk_headbob = function(l_8_0)
  return 0.012500000186265
end

PlayerMaskOff._check_action_interact = function(l_9_0, l_9_1, l_9_2)
  if l_9_2.btn_interact_press then
    managers.hint:show_hint("mask_off_block_interact")
  end
end

PlayerMaskOff._check_action_jump = function(l_10_0, l_10_1, l_10_2)
  if l_10_2.btn_duck_press then
    managers.hint:show_hint("mask_off_block_interact")
  end
end

PlayerMaskOff._check_action_duck = function(l_11_0, l_11_1, l_11_2)
  if l_11_2.btn_jump_press then
    managers.hint:show_hint("mask_off_block_interact")
  end
end

PlayerMaskOff._check_use_item = function(l_12_0, l_12_1, l_12_2)
  local new_action = nil
  local action_wanted = l_12_2.btn_use_item_press
  if action_wanted then
    if not l_12_0._use_item_expire_t and not l_12_0:_changing_weapon() then
      local action_forbidden = l_12_0:_interacting()
    end
    if not action_forbidden then
      l_12_0:_start_action_state_standard(l_12_1)
    end
  end
  if l_12_2.btn_use_item_release then
    l_12_0:_interupt_action_start_standard()
  end
end

PlayerMaskOff._start_action_state_standard = function(l_13_0, l_13_1)
  l_13_0._start_standard_expire_t = l_13_1 + tweak_data.player.put_on_mask_time
  managers.hud:show_progress_timer_bar(0, tweak_data.player.put_on_mask_time)
  managers.hud:show_progress_timer({text = managers.localization:text("hud_starting_heist"), icon = nil})
  managers.network:session():send_to_peers_loaded("sync_teammate_progress", 3, true, "mask_on_action", tweak_data.player.put_on_mask_time, false)
end

PlayerMaskOff._interupt_action_start_standard = function(l_14_0, l_14_1, l_14_2, l_14_3)
  if l_14_0._start_standard_expire_t then
    l_14_0._start_standard_expire_t = nil
    managers.hud:hide_progress_timer_bar(l_14_3)
    managers.hud:remove_progress_timer()
     -- DECOMPILER ERROR: Confused while interpreting a jump as a 'while'

  end
  managers.network:session():send_to_peers_loaded("sync_teammate_progress", 3, false, "mask_on_action", 0, true)
end
end

PlayerMaskOff._end_action_start_standard = function(l_15_0)
  l_15_0:_interupt_action_start_standard(nil, nil, true)
  PlayerStandard.say_line(l_15_0, "a01x_any", true)
  managers.player:set_player_state("standard")
  managers.achievment:award("no_one_cared_who_i_was")
end

PlayerMaskOff._update_start_standard_timers = function(l_16_0, l_16_1)
  if l_16_0._start_standard_expire_t then
    managers.hud:set_progress_timer_bar_width(tweak_data.player.put_on_mask_time - (l_16_0._start_standard_expire_t - l_16_1), tweak_data.player.put_on_mask_time)
    if l_16_0._start_standard_expire_t <= l_16_1 then
      l_16_0:_end_action_start_standard(l_16_1)
      l_16_0._start_standard_expire_t = nil
    end
  end
end


