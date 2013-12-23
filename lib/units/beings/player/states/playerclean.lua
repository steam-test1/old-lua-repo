-- Decompiled using luadec 2.0.1 by sztupy (http://winmo.sztupy.hu)
-- Command line was: F:\SteamLibrary\SteamApps\common\PAYDAY 2\lua\lib\units\beings\player\states\playerclean.luac 

if not PlayerClean then
  PlayerClean = class(PlayerStandard)
end
PlayerClean.init = function(l_1_0, l_1_1)
  PlayerClean.super.init(l_1_0, l_1_1)
  l_1_0._ids_unequip = Idstring("unequip")
end

PlayerClean.enter = function(l_2_0, l_2_1, l_2_2)
  PlayerClean.super.enter(l_2_0, l_2_1, l_2_2)
end

PlayerClean._enter = function(l_3_0, l_3_1)
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
    l_3_0._enemy_weapons_hot_listen_id = "PlayerClean" .. tostring(l_3_0._unit:key())
    managers.groupai:state():add_listener(l_3_0._enemy_weapons_hot_listen_id, {"enemy_weapons_hot"}, callback(l_3_0, l_3_0, "clbk_enemy_weapons_hot"))
  end
  l_3_0._ext_network:send("set_stance", 1)
end

PlayerClean.exit = function(l_4_0, l_4_1, l_4_2)
  PlayerClean.super.exit(l_4_0, l_4_1)
  if l_4_0._previous_equipped_selection then
    l_4_0._unit:inventory():equip_selection(l_4_0._previous_equipped_selection, false)
    l_4_0._previous_equipped_selection = nil
  end
  l_4_0._unit:base():set_slot(l_4_0._unit, 2)
  if l_4_0._enemy_weapons_hot_listen_id then
    managers.groupai:state():remove_listener(l_4_0._enemy_weapons_hot_listen_id)
  end
  return 
end

PlayerClean.interaction_blocked = function(l_5_0)
  return true
end

PlayerClean.update = function(l_6_0, l_6_1, l_6_2)
  PlayerClean.super.update(l_6_0, l_6_1, l_6_2)
end

PlayerClean._update_check_actions = function(l_7_0, l_7_1, l_7_2)
  local input = l_7_0:_get_input()
  l_7_0._stick_move = l_7_0._controller:get_input_axis("move")
  if mvector3.length(l_7_0._stick_move) < 0.10000000149012 then
    l_7_0._move_dir = nil
  else
    l_7_0._move_dir = mvector3.copy(l_7_0._stick_move)
    local cam_flat_rot = Rotation(l_7_0._cam_fwd_flat, math.UP)
    mvector3.rotate_with(l_7_0._move_dir, cam_flat_rot)
  end
  if input.btn_stats_screen_press then
    l_7_0._unit:base():set_stats_screen_visible(true)
  elseif input.btn_stats_screen_release then
    l_7_0._unit:base():set_stats_screen_visible(false)
  end
  l_7_0:_update_foley(l_7_1, input)
  local new_action = nil
  if new_action or not new_action and l_7_0._state_data.ducking then
    l_7_0:_end_action_ducking(l_7_1)
  end
end

PlayerClean._get_walk_headbob = function(l_8_0)
  return 0.012500000186265
end

PlayerClean._check_action_interact = function(l_9_0, l_9_1, l_9_2)
  local new_action = nil
  local interaction_wanted = l_9_2.btn_interact_press
  if interaction_wanted then
    local action_forbidden = l_9_0:chk_action_forbidden("interact")
    if not action_forbidden then
      l_9_0:_start_action_state_standard(l_9_1)
    end
  end
  return new_action
end

PlayerClean._start_action_state_standard = function(l_10_0, l_10_1)
  managers.player:set_player_state("standard")
end

PlayerClean.clbk_enemy_weapons_hot = function(l_11_0)
  managers.groupai:state():remove_listener(l_11_0._enemy_weapons_hot_listen_id)
  l_11_0._enemy_weapons_hot_listen_id = nil
  managers.player:set_player_state("standard")
end


