-- Decompiled using luadec 2.0.1 by sztupy (http://winmo.sztupy.hu)
-- Command line was: F:\SteamLibrary\SteamApps\common\PAYDAY 2\lua\lib\network\handlers\unitnetworkhandler.luac 

if not UnitNetworkHandler then
  UnitNetworkHandler = class(BaseNetworkHandler)
end
UnitNetworkHandler.set_unit = function(l_1_0, l_1_1, l_1_2, l_1_3, l_1_4)
  print("[UnitNetworkHandler:set_unit]", l_1_1, l_1_2, l_1_4)
  Application:stack_dump()
  if not alive(l_1_1) then
    return 
  end
  if not l_1_0._verify_gamestate(l_1_0._gamestate_filter.any_ingame) then
    return 
  end
  if l_1_4 == 0 then
    local crim_data = managers.criminals:character_data_by_name(l_1_2)
    if not crim_data or not crim_data.ai then
      managers.criminals:add_character(l_1_2, l_1_1, l_1_4, true)
    else
      managers.criminals:set_unit(l_1_2, l_1_1)
    end
    l_1_1:movement():set_character_anim_variables()
    return 
  end
  local peer = managers.network:session():peer(l_1_4)
  if not peer then
    return 
  end
  peer:set_outfit_string(l_1_3)
  local member = managers.network:game():member_peer(peer)
  if member then
    member:set_unit(l_1_1, l_1_2)
  elseif l_1_1 then
    if l_1_1:base() and l_1_1:base().set_slot then
      l_1_1:base():set_slot(l_1_1, 0)
    else
      l_1_1:set_slot(0)
    end
  end
  l_1_0:_chk_flush_unit_too_early_packets(l_1_1)
end

UnitNetworkHandler.set_equipped_weapon = function(l_2_0, l_2_1, l_2_2, l_2_3, l_2_4)
  if not l_2_0._verify_character_and_sender(l_2_1, l_2_4) then
    return 
  end
  l_2_1:inventory():synch_equipped_weapon(l_2_2, l_2_3)
end

UnitNetworkHandler.set_weapon_gadget_state = function(l_3_0, l_3_1, l_3_2, l_3_3)
  if not l_3_0._verify_character_and_sender(l_3_1, l_3_3) then
    return 
  end
  l_3_1:inventory():synch_weapon_gadget_state(l_3_2)
end

UnitNetworkHandler.set_look_dir = function(l_4_0, l_4_1, l_4_2, l_4_3)
  if not l_4_0._verify_character_and_sender(l_4_1, l_4_3) then
    return 
  end
  l_4_1:movement():sync_look_dir(l_4_2)
end

UnitNetworkHandler.action_walk_start = function(l_5_0, l_5_1, l_5_2, l_5_3, l_5_4, l_5_5, l_5_6, l_5_7, l_5_8, l_5_9)
  if not l_5_0._verify_character(l_5_1) or not l_5_0._verify_gamestate(l_5_0._gamestate_filter.any_ingame) then
    return 
  end
  local end_rot = nil
  if l_5_7 ~= 0 then
    end_rot = Rotation(360 * (l_5_7 - 1) / 254, 0, 0)
  end
   -- DECOMPILER ERROR: No list found. Setlist fails

  local nav_path = {}
   -- DECOMPILER ERROR: Overwrote pending register.

  if l_5_4 ~= 0 then
    local nav_link_rot = l_5_1:position()(360 * l_5_3 / 255, 0, 0)
    local nav_link = l_5_1:movement()._actions.walk.synthesize_nav_link(l_5_2, nav_link_rot, l_5_1:movement()._actions.act:_get_act_name_from_index(l_5_4), l_5_5)
    nav_link.element.value = function(l_1_0, l_1_1)
      return l_1_0[l_1_1]
      end
    nav_link.element.nav_link_wants_align_pos = function(l_2_0)
      return l_2_0.from_idle
      end
    table.insert(nav_path, nav_link)
  else
    table.insert(nav_path, l_5_2)
  end
  {type = "walk", variant = l_5_6 == 1 and "walk" or "run", end_rot = end_rot, body_part = 2}.nav_path = nav_path
   -- DECOMPILER ERROR: Confused about usage of registers!

  {type = "walk", variant = l_5_6 == 1 and "walk" or "run", end_rot = end_rot, body_part = 2}.path_simplified = true
   -- DECOMPILER ERROR: Confused about usage of registers!

  {type = "walk", variant = l_5_6 == 1 and "walk" or "run", end_rot = end_rot, body_part = 2}.persistent = true
   -- DECOMPILER ERROR: Confused about usage of registers!

  {type = "walk", variant = l_5_6 == 1 and "walk" or "run", end_rot = end_rot, body_part = 2}.no_walk = l_5_8
   -- DECOMPILER ERROR: Confused about usage of registers!

  {type = "walk", variant = l_5_6 == 1 and "walk" or "run", end_rot = end_rot, body_part = 2}.no_strafe = l_5_9
   -- DECOMPILER ERROR: Confused about usage of registers!

  {type = "walk", variant = l_5_6 == 1 and "walk" or "run", end_rot = end_rot, body_part = 2}.blocks = {walk = -1, turn = -1, act = -1, idle = -1}
  do
     -- DECOMPILER ERROR: Confused at declaration of local variable

     -- DECOMPILER ERROR: Confused about usage of registers!

    l_5_1:movement():action_request({type = "walk", variant = l_5_6 == 1 and "walk" or "run", end_rot = end_rot, body_part = 2})
  end
   -- DECOMPILER ERROR: Confused about usage of registers for local variables.

end

UnitNetworkHandler.action_walk_nav_point = function(l_6_0, l_6_1, l_6_2, l_6_3)
  if not l_6_0._verify_character_and_sender(l_6_1, l_6_3) or not l_6_0._verify_gamestate(l_6_0._gamestate_filter.any_ingame) then
    return 
  end
  l_6_1:movement():sync_action_walk_nav_point(l_6_2)
end

UnitNetworkHandler.action_walk_stop = function(l_7_0, l_7_1, l_7_2)
  if not l_7_0._verify_character(l_7_1) or not l_7_0._verify_gamestate(l_7_0._gamestate_filter.any_ingame) then
    return 
  end
  l_7_1:movement():sync_action_walk_stop(l_7_2)
end

UnitNetworkHandler.action_walk_nav_link = function(l_8_0, l_8_1, l_8_2, l_8_3, l_8_4, l_8_5)
  if not l_8_0._verify_character(l_8_1) or not l_8_0._verify_gamestate(l_8_0._gamestate_filter.any_ingame) then
    return 
  end
  local rot = Rotation(360 * l_8_3 / 255, 0, 0)
  l_8_1:movement():sync_action_walk_nav_link(l_8_2, rot, l_8_4, l_8_5)
end

UnitNetworkHandler.action_spooc_start = function(l_9_0, l_9_1)
  if not l_9_0._verify_character(l_9_1) or not l_9_0._verify_gamestate(l_9_0._gamestate_filter.any_ingame) then
    return 
  end
   -- DECOMPILER ERROR: Unhandled construct in list

  local action_desc = {type = "spooc", body_part = 1, block_type = "walk", nav_path = {}, path_index = 1, blocks = {walk = -1, turn = -1, act = -1, idle = -1}}
   -- DECOMPILER ERROR: Overwrote pending register.

  l_9_1:movement():action_request(action_desc)
end

UnitNetworkHandler.action_spooc_stop = function(l_10_0, l_10_1, l_10_2, l_10_3)
  if not l_10_0._verify_character(l_10_1) then
    return 
  end
  l_10_1:movement():sync_action_spooc_stop(l_10_2, l_10_3)
end

UnitNetworkHandler.action_spooc_nav_point = function(l_11_0, l_11_1, l_11_2, l_11_3)
  if not l_11_0._verify_character_and_sender(l_11_1, l_11_3) or not l_11_0._verify_gamestate(l_11_0._gamestate_filter.any_ingame) then
    return 
  end
  l_11_1:movement():sync_action_spooc_nav_point(l_11_2)
end

UnitNetworkHandler.action_spooc_strike = function(l_12_0, l_12_1, l_12_2, l_12_3)
  if not l_12_0._verify_character_and_sender(l_12_1, l_12_3) or not l_12_0._verify_gamestate(l_12_0._gamestate_filter.any_ingame) then
    return 
  end
  l_12_1:movement():sync_action_spooc_strike(l_12_2)
end

UnitNetworkHandler.friendly_fire_hit = function(l_13_0, l_13_1)
  if not l_13_0._verify_character(l_13_1) or not l_13_0._verify_gamestate(l_13_0._gamestate_filter.any_ingame) then
    return 
  end
  l_13_1:character_damage():friendly_fire_hit()
end

UnitNetworkHandler.damage_bullet = function(l_14_0, l_14_1, l_14_2, l_14_3, l_14_4, l_14_5, l_14_6, l_14_7)
  if not l_14_0._verify_character_and_sender(l_14_1, l_14_7) or not l_14_0._verify_gamestate(l_14_0._gamestate_filter.any_ingame) then
    return 
  end
  if not alive(l_14_2) or l_14_2:key() == l_14_1:key() then
    l_14_2 = nil
  end
  l_14_1:character_damage():sync_damage_bullet(l_14_2, l_14_3, l_14_4, l_14_5, l_14_6)
end

UnitNetworkHandler.damage_explosion = function(l_15_0, l_15_1, l_15_2, l_15_3, l_15_4, l_15_5, l_15_6)
  if not l_15_0._verify_character_and_sender(l_15_1, l_15_6) or not l_15_0._verify_gamestate(l_15_0._gamestate_filter.any_ingame) then
    return 
  end
  if not alive(l_15_2) or l_15_2:key() == l_15_1:key() then
    l_15_2 = nil
  end
  l_15_1:character_damage():sync_damage_explosion(l_15_2, l_15_3, l_15_4, l_15_5)
end

UnitNetworkHandler.damage_melee = function(l_16_0, l_16_1, l_16_2, l_16_3, l_16_4, l_16_5, l_16_6, l_16_7, l_16_8, l_16_9)
  if not l_16_0._verify_character_and_sender(l_16_1, l_16_9) or not l_16_0._verify_gamestate(l_16_0._gamestate_filter.any_ingame) then
    return 
  end
  if not alive(l_16_2) or l_16_2:key() == l_16_1:key() then
    l_16_2 = nil
  end
  l_16_1:character_damage():sync_damage_melee(l_16_2, l_16_3, l_16_4, l_16_5, l_16_6, l_16_7, l_16_8)
end

UnitNetworkHandler.from_server_damage_bullet = function(l_17_0, l_17_1, l_17_2, l_17_3, l_17_4, l_17_5)
  if not l_17_0._verify_character_and_sender(l_17_1, l_17_5) or not l_17_0._verify_gamestate(l_17_0._gamestate_filter.any_ingame) then
    return 
  end
  if not alive(l_17_2) or l_17_2:key() == l_17_1:key() then
    l_17_2 = nil
  end
  l_17_1:character_damage():sync_damage_bullet(l_17_2, l_17_3, l_17_4)
end

UnitNetworkHandler.from_server_damage_explosion = function(l_18_0, l_18_1, l_18_2, l_18_3, l_18_4, l_18_5)
  if not l_18_0._verify_character(l_18_1) or not l_18_0._verify_gamestate(l_18_0._gamestate_filter.any_ingame) then
    return 
  end
  if not alive(l_18_2) or l_18_2:key() == l_18_1:key() then
    l_18_2 = nil
  end
  l_18_1:character_damage():sync_damage_explosion(l_18_2, l_18_3, l_18_4)
end

UnitNetworkHandler.from_server_damage_melee = function(l_19_0, l_19_1, l_19_2, l_19_3, l_19_4, l_19_5)
  if not l_19_0._verify_character(l_19_1) or not l_19_0._verify_gamestate(l_19_0._gamestate_filter.any_ingame) then
    return 
  end
  if not alive(l_19_2) or l_19_2:key() == l_19_1:key() then
    l_19_2 = nil
  end
  l_19_1:character_damage():sync_damage_melee(l_19_2, l_19_2, l_19_3, l_19_4)
end

UnitNetworkHandler.from_server_damage_incapacitated = function(l_20_0, l_20_1, l_20_2)
  if not l_20_0._verify_gamestate(l_20_0._gamestate_filter.any_ingame) or not l_20_0._verify_character(l_20_1) then
    return 
  end
  l_20_1:character_damage():sync_damage_incapacitated()
end

UnitNetworkHandler.from_server_damage_bleeding = function(l_21_0, l_21_1)
  if not l_21_0._verify_gamestate(l_21_0._gamestate_filter.any_ingame) or not l_21_0._verify_character(l_21_1) then
    return 
  end
  l_21_1:character_damage():sync_damage_bleeding()
end

UnitNetworkHandler.from_server_damage_tase = function(l_22_0, l_22_1)
  if not l_22_0._verify_gamestate(l_22_0._gamestate_filter.any_ingame) or not l_22_0._verify_character(l_22_1) then
    return 
  end
  l_22_1:character_damage():sync_damage_tase()
end

UnitNetworkHandler.from_server_unit_recovered = function(l_23_0, l_23_1)
  if not l_23_0._verify_gamestate(l_23_0._gamestate_filter.any_ingame) or not l_23_0._verify_character(l_23_1) then
    return 
  end
  l_23_1:character_damage():sync_unit_recovered()
end

UnitNetworkHandler.shot_blank = function(l_24_0, l_24_1, l_24_2, l_24_3)
  if not l_24_0._verify_gamestate(l_24_0._gamestate_filter.any_ingame) or not l_24_0._verify_character_and_sender(l_24_1, l_24_3) then
    return 
  end
  l_24_1:movement():sync_shot_blank(l_24_2)
end

UnitNetworkHandler.reload_weapon = function(l_25_0, l_25_1, l_25_2)
  if not l_25_0._verify_gamestate(l_25_0._gamestate_filter.any_ingame) or not l_25_0._verify_character_and_sender(l_25_1, l_25_2) then
    return 
  end
  l_25_1:movement():sync_reload_weapon()
end

UnitNetworkHandler.run_mission_element = function(l_26_0, l_26_1, l_26_2)
  if not l_26_0._verify_gamestate(l_26_0._gamestate_filter.any_ingame) and l_26_0._verify_gamestate(l_26_0._gamestate_filter.any_end_game) then
    managers.mission:client_run_mission_element_end_screen(l_26_1, l_26_2)
  end
  return 
  managers.mission:client_run_mission_element(l_26_1, l_26_2)
end

UnitNetworkHandler.run_mission_element_no_instigator = function(l_27_0, l_27_1)
  if not l_27_0._verify_gamestate(l_27_0._gamestate_filter.any_ingame) and l_27_0._verify_gamestate(l_27_0._gamestate_filter.any_end_game) then
    managers.mission:client_run_mission_element_end_screen(l_27_1)
  end
  return 
  managers.mission:client_run_mission_element(l_27_1)
end

UnitNetworkHandler.to_server_mission_element_trigger = function(l_28_0, l_28_1, l_28_2)
  if not l_28_0._verify_gamestate(l_28_0._gamestate_filter.any_ingame) then
    return 
  end
  managers.mission:server_run_mission_element_trigger(l_28_1, l_28_2)
end

UnitNetworkHandler.to_server_enter_area = function(l_29_0, l_29_1, l_29_2)
  if not l_29_0._verify_gamestate(l_29_0._gamestate_filter.any_ingame) then
    return 
  end
  managers.mission:server_enter_area(l_29_1, l_29_2)
end

UnitNetworkHandler.to_server_exit_area = function(l_30_0, l_30_1, l_30_2)
  if not l_30_0._verify_gamestate(l_30_0._gamestate_filter.any_ingame) then
    return 
  end
  managers.mission:server_exit_area(l_30_1, l_30_2)
end

UnitNetworkHandler.to_server_access_camera_trigger = function(l_31_0, l_31_1, l_31_2, l_31_3)
  if not l_31_0._verify_gamestate(l_31_0._gamestate_filter.any_ingame) then
    return 
  end
  managers.mission:to_server_access_camera_trigger(l_31_1, l_31_2, l_31_3)
end

UnitNetworkHandler.sync_body_damage_bullet = function(l_32_0, l_32_1, l_32_2, l_32_3, l_32_4, l_32_5, l_32_6)
  if not l_32_0._verify_gamestate(l_32_0._gamestate_filter.any_ingame) then
    return 
  end
  if not alive(l_32_1) then
    return 
  end
  if not l_32_1:extension() then
    print("[UnitNetworkHandler:sync_body_damage_bullet] body has no extension", l_32_1:name(), l_32_1:unit():name())
    return 
  end
  if not l_32_1:extension().damage then
    print("[UnitNetworkHandler:sync_body_damage_bullet] body has no damage extension", l_32_1:name(), l_32_1:unit():name())
    return 
  end
  if not l_32_1:extension().damage.damage_bullet then
    print("[UnitNetworkHandler:sync_body_damage_bullet] body has no damage damage_bullet function", l_32_1:name(), l_32_1:unit():name())
    return 
  end
  l_32_1:extension().damage:damage_bullet(l_32_2, l_32_3, l_32_4, l_32_5, 1)
  l_32_1:extension().damage:damage_damage(l_32_2, l_32_3, l_32_4, l_32_5, l_32_6 / 163.83999633789)
end

UnitNetworkHandler.sync_body_damage_bullet_no_attacker = function(l_33_0, l_33_1, l_33_2, l_33_3, l_33_4, l_33_5)
  l_33_0:sync_body_damage_bullet(l_33_1, nil, l_33_2, l_33_3, l_33_4, l_33_5)
end

UnitNetworkHandler.sync_body_damage_lock = function(l_34_0, l_34_1, l_34_2)
  if not l_34_0._verify_gamestate(l_34_0._gamestate_filter.any_ingame) then
    return 
  end
  if not alive(l_34_1) then
    return 
  end
  if not l_34_1:extension() then
    print("[UnitNetworkHandler:sync_body_damage_bullet] body has no extension", l_34_1:name(), l_34_1:unit():name())
    return 
  end
  if not l_34_1:extension().damage then
    print("[UnitNetworkHandler:sync_body_damage_bullet] body has no damage extension", l_34_1:name(), l_34_1:unit():name())
    return 
  end
  if not l_34_1:extension().damage.damage_lock then
    print("[UnitNetworkHandler:sync_body_damage_bullet] body has no damage damage_lock function", l_34_1:name(), l_34_1:unit():name())
    return 
  end
  l_34_1:extension().damage:damage_lock(nil, nil, nil, nil, l_34_2)
end

UnitNetworkHandler.sync_body_damage_explosion = function(l_35_0, l_35_1, l_35_2, l_35_3, l_35_4, l_35_5, l_35_6)
  if not l_35_0._verify_gamestate(l_35_0._gamestate_filter.any_ingame) then
    return 
  end
  if not alive(l_35_1) then
    return 
  end
  if not l_35_1:extension() then
    print("[UnitNetworkHandler:sync_body_damage_explosion] body has no extension", l_35_1:name(), l_35_1:unit():name())
    return 
  end
  if not l_35_1:extension().damage then
    print("[UnitNetworkHandler:sync_body_damage_explosion] body has no damage extension", l_35_1:name(), l_35_1:unit():name())
    return 
  end
  if not l_35_1:extension().damage.damage_explosion then
    print("[UnitNetworkHandler:sync_body_damage_explosion] body has no damage damage_explosion function", l_35_1:name(), l_35_1:unit():name())
    return 
  end
  l_35_1:extension().damage:damage_explosion(l_35_2, l_35_3, l_35_4, l_35_5, l_35_6)
  l_35_1:extension().damage:damage_damage(l_35_2, l_35_3, l_35_4, l_35_5, l_35_6)
end

UnitNetworkHandler.sync_body_damage_explosion_no_attacker = function(l_36_0, l_36_1, l_36_2, l_36_3, l_36_4, l_36_5)
  l_36_0:sync_body_damage_explosion(l_36_1, nil, l_36_2, l_36_3, l_36_4, l_36_5)
end

UnitNetworkHandler.sync_body_damage_melee = function(l_37_0, l_37_1, l_37_2, l_37_3, l_37_4, l_37_5, l_37_6)
  if not l_37_0._verify_gamestate(l_37_0._gamestate_filter.any_ingame) then
    return 
  end
  if not alive(l_37_1) then
    return 
  end
  if not l_37_1:extension() then
    print("[UnitNetworkHandler:sync_body_damage_melee] body has no extension", l_37_1:name(), l_37_1:unit():name())
    return 
  end
  if not l_37_1:extension().damage then
    print("[UnitNetworkHandler:sync_body_damage_melee] body has no damage extension", l_37_1:name(), l_37_1:unit():name())
    return 
  end
  if not l_37_1:extension().damage.damage_melee then
    print("[UnitNetworkHandler:sync_body_damage_melee] body has no damage damage_melee function", l_37_1:name(), l_37_1:unit():name())
    return 
  end
  l_37_1:extension().damage:damage_melee(l_37_2, l_37_3, l_37_4, l_37_5, l_37_6)
end

UnitNetworkHandler.sync_interacted = function(l_38_0, l_38_1, l_38_2, l_38_3, l_38_4)
  if not l_38_0._verify_gamestate(l_38_0._gamestate_filter.any_ingame) then
    return 
  end
  local peer = l_38_0._verify_sender(l_38_4)
  if not peer then
    return 
  end
  if Network:is_server() and l_38_2 ~= -2 then
    if alive(l_38_1) and l_38_1:interaction().tweak_data == l_38_3 and l_38_1:interaction():active() then
      l_38_4:sync_interaction_reply(true)
    else
      l_38_4:sync_interaction_reply(false)
      return 
    end
    if alive(l_38_1) then
      l_38_1:interaction():sync_interacted(peer)
    end
     -- Warning: missing end command somewhere! Added here
  end
end

UnitNetworkHandler.sync_interacted_by_id = function(l_39_0, l_39_1, l_39_2, l_39_3)
  if not l_39_0._verify_gamestate(l_39_0._gamestate_filter.any_ingame) and not l_39_0._verify_sender(l_39_3) then
    return 
  end
  local u_data = managers.enemy:get_corpse_unit_data_from_id(l_39_1)
  if not u_data then
    return 
  end
  l_39_0:sync_interacted(u_data.unit, l_39_1, l_39_2, l_39_3)
end

UnitNetworkHandler.sync_interaction_reply = function(l_40_0, l_40_1)
  if not l_40_0._verify_gamestate(l_40_0._gamestate_filter.any_ingame) then
    return 
  end
  if not alive(managers.player:player_unit()) then
    return 
  end
  managers.player:from_server_interaction_reply(l_40_1)
end

UnitNetworkHandler.sync_interaction_set_active = function(l_41_0, l_41_1, l_41_2, l_41_3, l_41_4)
  if not alive(l_41_1) or not l_41_0._verify_gamestate(l_41_0._gamestate_filter.any_ingame) or not l_41_0._verify_sender(l_41_4) then
    return 
  end
  l_41_1:interaction():set_tweak_data(l_41_3)
  l_41_1:interaction():set_active(l_41_2)
end

UnitNetworkHandler.sync_interaction_set_active_by_id = function(l_42_0, l_42_1, l_42_2, l_42_3, l_42_4)
  if not l_42_0._verify_gamestate(l_42_0._gamestate_filter.any_ingame) or not l_42_0._verify_sender(l_42_4) then
    return 
  end
  local u_data = managers.enemy:get_corpse_unit_data_from_id(l_42_1)
  if not u_data then
    debug_pause("no unit!")
    return 
  end
  l_42_0:sync_interaction_set_active(u_data.unit, l_42_2, l_42_3, l_42_4)
end

UnitNetworkHandler.sync_teammate_progress = function(l_43_0, l_43_1, l_43_2, l_43_3, l_43_4, l_43_5, l_43_6)
  local sender_peer = l_43_0._verify_sender(l_43_6)
  if not l_43_0._verify_gamestate(l_43_0._gamestate_filter.any_ingame) or not sender_peer then
    return 
  end
  local peer_id = sender_peer:id()
  managers.hud:teammate_progress(peer_id, l_43_1, l_43_2, l_43_3, l_43_4, l_43_5)
end

UnitNetworkHandler.action_aim_start = function(l_44_0, l_44_1)
  if not l_44_0._verify_gamestate(l_44_0._gamestate_filter.any_ingame) or not l_44_0._verify_character(l_44_1) then
    return 
  end
  local shoot_action = {type = "shoot", body_part = 3, block_type = "action"}
  l_44_1:movement():action_request(shoot_action)
end

UnitNetworkHandler.action_aim_end = function(l_45_0, l_45_1)
  if not l_45_0._verify_gamestate(l_45_0._gamestate_filter.any_ingame) or not l_45_0._verify_character(l_45_1) then
    return 
  end
  l_45_1:movement():sync_action_aim_end()
end

UnitNetworkHandler.action_hurt_end = function(l_46_0, l_46_1)
  if not l_46_0._verify_gamestate(l_46_0._gamestate_filter.any_ingame) or not l_46_0._verify_character(l_46_1) then
    return 
  end
  l_46_1:movement():sync_action_hurt_end()
end

UnitNetworkHandler.set_attention = function(l_47_0, l_47_1, l_47_2, l_47_3, l_47_4)
  if not l_47_0._verify_gamestate(l_47_0._gamestate_filter.any_ingame) or not l_47_0._verify_character(l_47_1) or not alive(l_47_2) then
    return 
  end
  local handler = nil
  if l_47_2:attention() then
    handler = l_47_2:attention()
  else
    if l_47_2:brain() and l_47_2:brain().attention_handler then
      handler = l_47_2:brain():attention_handler()
    else
      if l_47_2:movement() and l_47_2:movement().attention_handler then
        handler = l_47_2:movement():attention_handler()
      else
        if l_47_2:base() and l_47_2:base().attention_handler then
          handler = l_47_2:base():attention_handler()
        end
      end
    end
  end
  if not handler and (not l_47_2:movement() or not l_47_2:movement().m_head_pos) then
    debug_pause_unit(l_47_2, "[UnitNetworkHandler:set_attention] no attention handler or m_head_pos", l_47_2)
    return 
  end
  l_47_1:movement():synch_attention({unit = l_47_2, u_key = l_47_2:key(), handler = handler, reaction = l_47_3})
end

UnitNetworkHandler.cop_set_attention_unit = function(l_48_0, l_48_1, l_48_2)
  if not l_48_0._verify_gamestate(l_48_0._gamestate_filter.any_ingame) or not l_48_0._verify_character(l_48_1) or not l_48_0._verify_character(l_48_2) then
    return 
  end
  l_48_1:movement():synch_attention({unit = l_48_2})
end

UnitNetworkHandler.cop_set_attention_pos = function(l_49_0, l_49_1, l_49_2)
  if not l_49_0._verify_gamestate(l_49_0._gamestate_filter.any_ingame) or not l_49_0._verify_character(l_49_1) then
    return 
  end
  l_49_1:movement():synch_attention({pos = l_49_2})
end

UnitNetworkHandler.cop_reset_attention = function(l_50_0, l_50_1)
  if not l_50_0._verify_gamestate(l_50_0._gamestate_filter.any_ingame) or not l_50_0._verify_character(l_50_1) then
    return 
  end
  l_50_1:movement():synch_attention()
end

UnitNetworkHandler.cop_allow_fire = function(l_51_0, l_51_1)
  if not l_51_0._verify_gamestate(l_51_0._gamestate_filter.any_ingame) or not l_51_0._verify_character(l_51_1) then
    return 
  end
  l_51_1:movement():synch_allow_fire(true)
end

UnitNetworkHandler.cop_forbid_fire = function(l_52_0, l_52_1)
  if not l_52_0._verify_gamestate(l_52_0._gamestate_filter.any_ingame) or not l_52_0._verify_character(l_52_1) then
    return 
  end
  l_52_1:movement():synch_allow_fire(false)
end

UnitNetworkHandler.set_stance = function(l_53_0, l_53_1, l_53_2, l_53_3)
  if not l_53_0._verify_gamestate(l_53_0._gamestate_filter.any_ingame) or not l_53_0._verify_character_and_sender(l_53_1, l_53_3) then
    return 
  end
  l_53_1:movement():sync_stance(l_53_2)
end

UnitNetworkHandler.set_pose = function(l_54_0, l_54_1, l_54_2, l_54_3)
  if not l_54_0._verify_gamestate(l_54_0._gamestate_filter.any_ingame) or not l_54_0._verify_character_and_sender(l_54_1, l_54_3) then
    return 
  end
  l_54_1:movement():sync_pose(l_54_2)
end

UnitNetworkHandler.long_dis_interaction = function(l_55_0, l_55_1, l_55_2, l_55_3)
  if not l_55_0._verify_gamestate(l_55_0._gamestate_filter.any_ingame) or not l_55_0._verify_character(l_55_1) or not l_55_0._verify_character(l_55_3) then
    return 
  end
  if not l_55_1:in_slot(managers.slot:get_mask("criminals")) then
    local target_is_criminal = l_55_1:in_slot(managers.slot:get_mask("harmless_criminals"))
  end
  local target_is_civilian = (not target_is_criminal and l_55_1:in_slot(21))
  if not l_55_3:in_slot(managers.slot:get_mask("criminals")) then
    local aggressor_is_criminal = l_55_3:in_slot(managers.slot:get_mask("harmless_criminals"))
  end
  if target_is_criminal then
    if aggressor_is_criminal then
      managers.game_play_central:flash_contour(l_55_3)
      if l_55_1:brain() then
        l_55_1:movement():set_cool(false)
        l_55_1:brain():on_long_dis_interacted(l_55_2, l_55_3)
      elseif l_55_2 == 1 then
        l_55_1:movement():on_morale_boost(l_55_3)
      else
        l_55_1:brain():on_intimidated(l_55_2 / 10, l_55_3)
      end
    elseif l_55_2 == 0 and target_is_civilian and aggressor_is_criminal and l_55_0._verify_in_server_session() then
      l_55_3:movement():sync_call_civilian(l_55_1)
      do return end
      l_55_1:brain():on_intimidated(l_55_2 / 10, l_55_3)
    end
  end
end

UnitNetworkHandler.alarm_pager_interaction = function(l_56_0, l_56_1, l_56_2, l_56_3, l_56_4)
  if not l_56_0._verify_gamestate(l_56_0._gamestate_filter.any_ingame) then
    return 
  end
  local unit_data = managers.enemy:get_corpse_unit_data_from_id(l_56_1)
  if unit_data and unit_data.unit:interaction():active() and unit_data.unit:interaction().tweak_data == l_56_2 then
    local peer = l_56_0._verify_sender(l_56_4)
    if peer then
      local status_str = nil
      if l_56_3 == 1 then
        status_str = "started"
      elseif l_56_3 == 2 then
        status_str = "interrupted"
      else
        status_str = "complete"
      end
      unit_data.unit:interaction():sync_interacted(peer, status_str)
    end
  end
end

UnitNetworkHandler.set_corpse_material_config = function(l_57_0, l_57_1, l_57_2)
  if not l_57_0._verify_gamestate(l_57_0._gamestate_filter.any_ingame) then
    return 
  end
  local unit_data = managers.enemy:get_corpse_unit_data_from_id(l_57_1)
  if not unit_data then
    return 
  end
  unit_data.unit:base():set_material_state(l_57_2)
end

UnitNetworkHandler.remove_corpse_by_id = function(l_58_0, l_58_1)
  if not l_58_0._verify_gamestate(l_58_0._gamestate_filter.any_ingame) then
    return 
  end
  managers.enemy:remove_corpse_by_id(l_58_1)
end

UnitNetworkHandler.unit_tied = function(l_59_0, l_59_1, l_59_2)
  if not l_59_0._verify_gamestate(l_59_0._gamestate_filter.any_ingame) or not l_59_0._verify_character(l_59_1) then
    return 
  end
  l_59_1:brain():on_tied(l_59_2)
end

UnitNetworkHandler.unit_traded = function(l_60_0, l_60_1, l_60_2)
  if not l_60_0._verify_gamestate(l_60_0._gamestate_filter.any_ingame) or not l_60_0._verify_character(l_60_1) then
    return 
  end
  l_60_1:brain():on_trade(l_60_2)
end

UnitNetworkHandler.hostage_trade = function(l_61_0, l_61_1, l_61_2, l_61_3)
  if not l_61_0._verify_gamestate(l_61_0._gamestate_filter.any_ingame) or not l_61_0._verify_character(l_61_1) then
    return 
  end
  CopLogicTrade.hostage_trade(l_61_1, l_61_2, l_61_3)
end

UnitNetworkHandler.set_unit_invulnerable = function(l_62_0, l_62_1, l_62_2)
  if not l_62_0._verify_gamestate(l_62_0._gamestate_filter.any_ingame) or not l_62_0._verify_character(l_62_1) then
    return 
  end
  l_62_1:character_damage():set_invulnerable(l_62_2)
end

UnitNetworkHandler.set_trade_countdown = function(l_63_0, l_63_1)
  if not l_63_0._verify_gamestate(l_63_0._gamestate_filter.any_ingame) then
    return 
  end
  managers.trade:set_trade_countdown(l_63_1)
end

UnitNetworkHandler.set_trade_death = function(l_64_0, l_64_1, l_64_2, l_64_3)
  if not l_64_0._verify_gamestate(l_64_0._gamestate_filter.any_ingame) then
    return 
  end
  managers.trade:sync_set_trade_death(l_64_1, l_64_2, l_64_3)
end

UnitNetworkHandler.set_trade_spawn = function(l_65_0, l_65_1)
  if not l_65_0._verify_gamestate(l_65_0._gamestate_filter.any_ingame) then
    return 
  end
  managers.trade:sync_set_trade_spawn(l_65_1)
end

UnitNetworkHandler.set_trade_replace = function(l_66_0, l_66_1, l_66_2, l_66_3, l_66_4)
  if not l_66_0._verify_gamestate(l_66_0._gamestate_filter.any_ingame) then
    return 
  end
  managers.trade:sync_set_trade_replace(l_66_1, l_66_2, l_66_3, l_66_4)
end

UnitNetworkHandler.action_idle_start = function(l_67_0, l_67_1, l_67_2, l_67_3)
  if not l_67_0._verify_gamestate(l_67_0._gamestate_filter.any_ingame) or not l_67_0._verify_character(l_67_1) then
    return 
  end
  l_67_1:movement():action_request({type = "idle", body_part = l_67_2})
end

UnitNetworkHandler.action_act_start = function(l_68_0, l_68_1, l_68_2, l_68_3)
  l_68_0:action_act_start_align(l_68_1, l_68_2, l_68_3, nil, nil)
end

UnitNetworkHandler.action_act_start_align = function(l_69_0, l_69_1, l_69_2, l_69_3, l_69_4, l_69_5)
  if not l_69_0._verify_gamestate(l_69_0._gamestate_filter.any_ingame) or not l_69_0._verify_character(l_69_1) then
    return 
  end
  local start_rot = nil
  if l_69_4 and l_69_4 ~= 0 then
    start_rot = Rotation(360 * (l_69_4 - 1) / 254, 0, 0)
  end
  l_69_1:movement():sync_action_act_start(l_69_2, l_69_3, start_rot, l_69_5)
end

UnitNetworkHandler.action_act_end = function(l_70_0, l_70_1)
  if not alive(l_70_1) or l_70_1:character_damage():dead() then
    return 
  end
  l_70_1:movement():sync_action_act_end()
end

UnitNetworkHandler.action_dodge_start = function(l_71_0, l_71_1, l_71_2, l_71_3, l_71_4, l_71_5)
  if not l_71_0._verify_gamestate(l_71_0._gamestate_filter.any_ingame) or not l_71_0._verify_character(l_71_1) then
    return 
  end
  l_71_1:movement():sync_action_dodge_start(l_71_2, l_71_3, l_71_4, l_71_5)
end

UnitNetworkHandler.action_dodge_end = function(l_72_0, l_72_1)
  if not l_72_0._verify_gamestate(l_72_0._gamestate_filter.any_ingame) or not l_72_0._verify_character(l_72_1) then
    return 
  end
  l_72_1:movement():sync_action_dodge_end()
end

UnitNetworkHandler.action_tase_start = function(l_73_0, l_73_1)
  if not l_73_0._verify_gamestate(l_73_0._gamestate_filter.any_ingame) or not l_73_0._verify_character(l_73_1) then
    return 
  end
  local tase_action = {type = "tase", body_part = 3}
  l_73_1:movement():action_request(tase_action)
end

UnitNetworkHandler.action_tase_end = function(l_74_0, l_74_1)
  if not l_74_0._verify_gamestate(l_74_0._gamestate_filter.any_ingame) or not l_74_0._verify_character(l_74_1) then
    return 
  end
  l_74_1:movement():sync_action_tase_end()
end

UnitNetworkHandler.action_tase_fire = function(l_75_0, l_75_1, l_75_2)
  if not l_75_0._verify_gamestate(l_75_0._gamestate_filter.any_ingame) or not l_75_0._verify_character_and_sender(l_75_1, l_75_2) then
    return 
  end
  l_75_1:movement():sync_taser_fire()
end

UnitNetworkHandler.alert = function(l_76_0, l_76_1, l_76_2)
  if not l_76_0._verify_gamestate(l_76_0._gamestate_filter.any_ingame) or not l_76_0._verify_character(l_76_1) or not l_76_0._verify_character(l_76_2) then
    return 
  end
  local record = managers.groupai:state():criminal_record(l_76_2:key())
  if not record then
    return 
  end
  local aggressor_pos = nil
  if l_76_2:movement() and l_76_2:movement().m_head_pos then
    aggressor_pos = l_76_2:movement():m_head_pos()
  else
    aggressor_pos = l_76_2:position()
  end
  l_76_1:brain():on_alert({"aggression", aggressor_pos, false, nil, l_76_2})
end

UnitNetworkHandler.revive_player = function(l_77_0, l_77_1, l_77_2)
  local peer = l_77_0._verify_sender(l_77_2)
  if not l_77_0._verify_gamestate(l_77_0._gamestate_filter.need_revive) or not peer then
    return 
  end
  if l_77_1 > 0 then
    managers.player:player_unit():character_damage():set_revive_boost(l_77_1)
  end
  managers.player:player_unit():character_damage():revive()
end

UnitNetworkHandler.start_revive_player = function(l_78_0, l_78_1, l_78_2)
  if not l_78_0._verify_gamestate(l_78_0._gamestate_filter.downed) or not l_78_0._verify_sender(l_78_2) then
    return 
  end
  local player = managers.player:player_unit()
  player:character_damage():pause_downed_timer(l_78_1)
end

UnitNetworkHandler.interupt_revive_player = function(l_79_0, l_79_1)
  if not l_79_0._verify_gamestate(l_79_0._gamestate_filter.downed) or not l_79_0._verify_sender(l_79_1) then
    return 
  end
  local player = managers.player:player_unit()
  player:character_damage():unpause_downed_timer()
end

UnitNetworkHandler.start_free_player = function(l_80_0, l_80_1)
  if not l_80_0._verify_gamestate(l_80_0._gamestate_filter.arrested) or not l_80_0._verify_sender(l_80_1) then
    return 
  end
  local player = managers.player:player_unit()
  player:character_damage():pause_arrested_timer()
end

UnitNetworkHandler.interupt_free_player = function(l_81_0, l_81_1)
  if not l_81_0._verify_gamestate(l_81_0._gamestate_filter.arrested) or not l_81_0._verify_sender(l_81_1) then
    return 
  end
  local player = managers.player:player_unit()
  player:character_damage():unpause_arrested_timer()
end

UnitNetworkHandler.pause_arrested_timer = function(l_82_0, l_82_1, l_82_2)
  if not l_82_0._verify_gamestate(l_82_0._gamestate_filter.any_ingame) or not l_82_0._verify_character_and_sender(l_82_1, l_82_2) then
    return 
  end
  l_82_1:character_damage():pause_arrested_timer()
end

UnitNetworkHandler.unpause_arrested_timer = function(l_83_0, l_83_1, l_83_2)
  if not l_83_0._verify_gamestate(l_83_0._gamestate_filter.any_ingame) or not l_83_0._verify_character_and_sender(l_83_1, l_83_2) then
    return 
  end
  l_83_1:character_damage():unpause_arrested_timer()
end

UnitNetworkHandler.revive_unit = function(l_84_0, l_84_1, l_84_2)
  if not l_84_0._verify_gamestate(l_84_0._gamestate_filter.any_ingame) or not l_84_0._verify_character(l_84_1) or not alive(l_84_2) then
    return 
  end
  l_84_1:interaction():interact(l_84_2)
end

UnitNetworkHandler.pause_bleed_out = function(l_85_0, l_85_1, l_85_2)
  if not l_85_0._verify_gamestate(l_85_0._gamestate_filter.any_ingame) or not l_85_0._verify_character_and_sender(l_85_1, l_85_2) then
    return 
  end
  l_85_1:character_damage():pause_bleed_out()
end

UnitNetworkHandler.unpause_bleed_out = function(l_86_0, l_86_1, l_86_2)
  if not l_86_0._verify_gamestate(l_86_0._gamestate_filter.any_ingame) or not l_86_0._verify_character_and_sender(l_86_1, l_86_2) then
    return 
  end
  l_86_1:character_damage():unpause_bleed_out()
end

UnitNetworkHandler.interaction_set_waypoint_paused = function(l_87_0, l_87_1, l_87_2, l_87_3)
  if not l_87_0._verify_gamestate(l_87_0._gamestate_filter.any_ingame) or not l_87_0._verify_sender(l_87_3) then
    return 
  end
  if not alive(l_87_1) then
    return 
  end
  if not l_87_1:interaction() then
    return 
  end
  l_87_1:interaction():set_waypoint_paused(l_87_2)
end

UnitNetworkHandler.attach_device = function(l_88_0, l_88_1, l_88_2, l_88_3, l_88_4)
  if not l_88_0._verify_gamestate(l_88_0._gamestate_filter.any_ingame) or not l_88_0._verify_sender(l_88_4) then
    return 
  end
  local rot = Rotation(l_88_2, math.UP)
  local peer = l_88_0._verify_sender(l_88_4)
  local unit = TripMineBase.spawn(l_88_1, rot, l_88_3)
  unit:base():set_server_information(peer:id())
  l_88_4:activate_trip_mine(unit)
end

UnitNetworkHandler.activate_trip_mine = function(l_89_0, l_89_1)
  if not l_89_0._verify_gamestate(l_89_0._gamestate_filter.any_ingame) then
    return 
  end
  if alive(l_89_1) then
    l_89_1:base():set_active(true, managers.player:player_unit())
  end
end

UnitNetworkHandler.sync_trip_mine_setup = function(l_90_0, l_90_1, l_90_2)
  if not alive(l_90_1) or not l_90_0._verify_gamestate(l_90_0._gamestate_filter.any_ingame) then
    return 
  end
  l_90_1:base():sync_setup(l_90_2)
end

UnitNetworkHandler.sync_trip_mine_explode = function(l_91_0, l_91_1, l_91_2, l_91_3, l_91_4, l_91_5, l_91_6, l_91_7)
  if not l_91_0._verify_gamestate(l_91_0._gamestate_filter.any_ingame) or not l_91_0._verify_sender(l_91_7) then
    return 
  end
  if not alive(l_91_2) then
    l_91_2 = nil
  end
  if alive(l_91_1) then
    l_91_1:base():sync_trip_mine_explode(l_91_2, l_91_3, l_91_4, l_91_5, l_91_6)
  end
end

UnitNetworkHandler.sync_trip_mine_explode_no_user = function(l_92_0, l_92_1, l_92_2, l_92_3, l_92_4, l_92_5, l_92_6)
  l_92_0:sync_trip_mine_explode(l_92_1, nil, l_92_2, l_92_3, l_92_4, l_92_5, l_92_6)
end

UnitNetworkHandler.sync_trip_mine_set_armed = function(l_93_0, l_93_1, l_93_2, l_93_3, l_93_4)
  if not alive(l_93_1) or not l_93_0._verify_gamestate(l_93_0._gamestate_filter.any_ingame) or not l_93_0._verify_sender(l_93_4) then
    return 
  end
  l_93_1:base():sync_trip_mine_set_armed(l_93_2, l_93_3)
end

UnitNetworkHandler.sync_trip_mine_beep_explode = function(l_94_0, l_94_1, l_94_2)
  if not alive(l_94_1) or not l_94_0._verify_gamestate(l_94_0._gamestate_filter.any_ingame) or not l_94_0._verify_sender(l_94_2) then
    return 
  end
  l_94_1:base():sync_trip_mine_beep_explode()
end

UnitNetworkHandler.sync_trip_mine_beep_sensor = function(l_95_0, l_95_1, l_95_2)
  if not alive(l_95_1) or not l_95_0._verify_gamestate(l_95_0._gamestate_filter.any_ingame) or not l_95_0._verify_sender(l_95_2) then
    return 
  end
  l_95_1:base():sync_trip_mine_beep_sensor()
end

UnitNetworkHandler.request_place_ecm_jammer = function(l_96_0, l_96_1, l_96_2, l_96_3, l_96_4)
  local peer = l_96_0._verify_sender(l_96_4)
  if not l_96_0._verify_gamestate(l_96_0._gamestate_filter.any_ingame) or not peer then
    return 
  end
  local owner_unit = managers.network:game():member(peer:id()):unit()
  if not alive(owner_unit) or owner_unit:id() == -1 then
    l_96_4:from_server_ecm_jammer_place_rejected()
    return 
  end
  local rot = Rotation(l_96_2, math.UP)
  local peer = l_96_0._verify_sender(l_96_4)
  local unit = ECMJammerBase.spawn(l_96_1, rot, l_96_3, owner_unit)
  unit:base():set_server_information(peer:id())
  unit:base():set_active(true)
  l_96_4:from_server_ecm_jammer_placed(unit)
end

UnitNetworkHandler.from_server_ecm_jammer_placed = function(l_97_0, l_97_1, l_97_2)
  if not l_97_0._verify_gamestate(l_97_0._gamestate_filter.any_ingame) then
    return 
  end
  if alive(managers.player:player_unit()) then
    managers.player:player_unit():equipment():from_server_ecm_jammer_placement_result(true)
  end
  if not alive(l_97_1) then
    return 
  end
  l_97_1:base():set_owner(managers.player:player_unit())
end

UnitNetworkHandler.sync_unit_event_id_8 = function(l_98_0, l_98_1, l_98_2, l_98_3, l_98_4)
  local peer = l_98_0._verify_sender(l_98_4)
  if not peer or not alive(l_98_1) or not l_98_0._verify_gamestate(l_98_0._gamestate_filter.any_ingame) then
    return 
  end
  local extension = l_98_1[l_98_2](l_98_1)
  if not extension then
    debug_pause("[UnitNetworkHandler:sync_unit_event_id_8] unit", l_98_1, "does not have extension", l_98_2)
    return 
  end
  extension:sync_net_event(l_98_3)
end

UnitNetworkHandler.from_server_ecm_jammer_rejected = function(l_99_0, l_99_1)
  if not l_99_0._verify_gamestate(l_99_0._gamestate_filter.any_ingame) then
    return 
  end
  if alive(managers.player:player_unit()) then
    managers.player:player_unit():equipment():from_server_ecm_jammer_placement_result(false)
  end
end

UnitNetworkHandler.m79grenade_explode_on_client = function(l_100_0, l_100_1, l_100_2, l_100_3, l_100_4, l_100_5, l_100_6, l_100_7)
  if not l_100_0._verify_gamestate(l_100_0._gamestate_filter.any_ingame) or not l_100_0._verify_character_and_sender(l_100_3, l_100_7) then
    return 
  end
  GrenadeBase._explode_on_client(l_100_1, l_100_2, l_100_3, l_100_4, l_100_5, l_100_6)
end

UnitNetworkHandler.element_explode_on_client = function(l_101_0, l_101_1, l_101_2, l_101_3, l_101_4, l_101_5, l_101_6)
  if not l_101_0._verify_gamestate(l_101_0._gamestate_filter.any_ingame) or not l_101_0._verify_sender(l_101_6) then
    return 
  end
  GrenadeBase._client_damage_and_push(l_101_1, l_101_2, nil, l_101_3, l_101_4, l_101_5)
end

UnitNetworkHandler.place_sentry_gun = function(l_102_0, l_102_1, l_102_2, l_102_3, l_102_4, l_102_5, l_102_6, l_102_7, l_102_8)
  local peer = l_102_0._verify_sender(l_102_8)
  if not l_102_0._verify_gamestate(l_102_0._gamestate_filter.any_ingame) or not peer then
    return 
  end
  local unit = SentryGunBase.spawn(l_102_7, l_102_1, l_102_2, l_102_3, l_102_4, l_102_5)
  if unit then
    unit:base():set_server_information(peer:id())
  end
   -- DECOMPILER ERROR: Confused while interpreting a jump as a 'while'

end
 -- DECOMPILER ERROR: Confused while interpreting a jump as a 'while'

end
managers.network:session():send_to_peers_synched("from_server_sentry_gun_place_result", peer:id(), not alive(l_102_7) or l_102_7:id() == -1 or 0, unit, unit:movement()._rot_speed_mul, unit:weapon()._setup.spread_mul, true)
end

UnitNetworkHandler.from_server_sentry_gun_place_result = function(l_103_0, l_103_1, l_103_2, l_103_3, l_103_4, l_103_5, l_103_6, l_103_7)
  if not l_103_0._verify_gamestate(l_103_0._gamestate_filter.any_ingame) or not l_103_0._verify_sender(l_103_7) or not alive(l_103_3) or not managers.network:session():peer(l_103_1) then
    return 
  end
  if l_103_1 == managers.network:session():local_peer():id() and alive(Global.local_member:unit()) then
    managers.player:from_server_equipment_place_result(l_103_2, Global.local_member:unit())
  end
  if l_103_6 then
    l_103_3:base():enable_shield()
  end
  l_103_3:movement():setup(l_103_4)
  l_103_3:brain():setup(1 / l_103_4)
  local setup_data = {spread_mul = l_103_5}
  l_103_3:weapon():setup(setup_data, 1)
end

UnitNetworkHandler.place_ammo_bag = function(l_104_0, l_104_1, l_104_2, l_104_3, l_104_4)
  if not l_104_0._verify_gamestate(l_104_0._gamestate_filter.any_ingame) or not l_104_0._verify_sender(l_104_4) then
    return 
  end
  local peer = l_104_0._verify_sender(l_104_4)
  local unit = AmmoBagBase.spawn(l_104_1, l_104_2, l_104_3)
  unit:base():set_server_information(peer:id())
end

UnitNetworkHandler.sentrygun_ammo = function(l_105_0, l_105_1, l_105_2)
  if not l_105_0._verify_gamestate(l_105_0._gamestate_filter.any_ingame) then
    return 
  end
  l_105_1:weapon():sync_ammo(l_105_2)
end

UnitNetworkHandler.sentrygun_health = function(l_106_0, l_106_1, l_106_2)
  if not l_106_0._verify_gamestate(l_106_0._gamestate_filter.any_ingame) then
    return 
  end
  l_106_1:character_damage():sync_health(l_106_2)
end

UnitNetworkHandler.sync_ammo_bag_setup = function(l_107_0, l_107_1, l_107_2)
  if not alive(l_107_1) or not l_107_0._verify_gamestate(l_107_0._gamestate_filter.any_ingame) then
    return 
  end
  l_107_1:base():sync_setup(l_107_2)
end

UnitNetworkHandler.sync_ammo_bag_ammo_taken = function(l_108_0, l_108_1, l_108_2, l_108_3)
  if not alive(l_108_1) or not l_108_0._verify_gamestate(l_108_0._gamestate_filter.any_ingame) or not l_108_0._verify_sender(l_108_3) then
    return 
  end
  l_108_1:base():sync_ammo_taken(l_108_2)
end

UnitNetworkHandler.place_doctor_bag = function(l_109_0, l_109_1, l_109_2, l_109_3, l_109_4)
  if not l_109_0._verify_gamestate(l_109_0._gamestate_filter.any_ingame) or not l_109_0._verify_sender(l_109_4) then
    return 
  end
  local peer = l_109_0._verify_sender(l_109_4)
  local unit = DoctorBagBase.spawn(l_109_1, l_109_2, l_109_3)
  unit:base():set_server_information(peer:id())
end

UnitNetworkHandler.sync_doctor_bag_setup = function(l_110_0, l_110_1, l_110_2)
  if not alive(l_110_1) or not l_110_0._verify_gamestate(l_110_0._gamestate_filter.any_ingame) then
    return 
  end
  l_110_1:base():sync_setup(l_110_2)
end

UnitNetworkHandler.sync_doctor_bag_taken = function(l_111_0, l_111_1, l_111_2, l_111_3)
  if not alive(l_111_1) or not l_111_0._verify_gamestate(l_111_0._gamestate_filter.any_ingame) or not l_111_0._verify_sender(l_111_3) then
    return 
  end
  l_111_1:base():sync_taken(l_111_2)
end

UnitNetworkHandler.sync_money_wrap_money_taken = function(l_112_0, l_112_1, l_112_2)
  if not alive(l_112_1) or not l_112_0._verify_gamestate(l_112_0._gamestate_filter.any_ingame) or not l_112_0._verify_sender(l_112_2) then
    return 
  end
  l_112_1:base():sync_money_taken()
end

UnitNetworkHandler.sync_pickup = function(l_113_0, l_113_1)
  if not alive(l_113_1) or not l_113_0._verify_gamestate(l_113_0._gamestate_filter.any_ingame) then
    return 
  end
  l_113_1:base():sync_pickup()
end

UnitNetworkHandler.unit_sound_play = function(l_114_0, l_114_1, l_114_2, l_114_3, l_114_4)
  if not alive(l_114_1) or not l_114_0._verify_sender(l_114_4) then
    return 
  end
  if l_114_3 == "" then
    l_114_3 = nil
  end
  l_114_1:sound():play(l_114_2, l_114_3, false)
end

UnitNetworkHandler.corpse_sound_play = function(l_115_0, l_115_1, l_115_2, l_115_3)
  if not l_115_0._verify_gamestate(l_115_0._gamestate_filter.any_ingame) then
    return 
  end
  local u_data = managers.enemy:get_corpse_unit_data_from_id(l_115_1)
  if not u_data then
    return 
  end
  if not u_data.unit then
    debug_pause("[UnitNetworkHandler:corpse_sound_play] u_data without unit", inspect(u_data))
    return 
  end
  if not u_data.unit:sound() then
    return 
  end
  u_data.unit:sound():play(l_115_2, l_115_3, false)
end

UnitNetworkHandler.say = function(l_116_0, l_116_1, l_116_2, l_116_3)
  if not alive(l_116_1) or not l_116_0._verify_gamestate(l_116_0._gamestate_filter.any_ingame) or not l_116_0._verify_sender(l_116_3) then
    return 
  end
  if l_116_1:in_slot(managers.slot:get_mask("all_criminals")) and not managers.groupai:state():is_enemy_converted_to_criminal(l_116_1) then
    l_116_1:sound():say(l_116_2, true, nil)
  else
    l_116_1:sound():say(l_116_2, nil, true)
  end
end

UnitNetworkHandler.sync_remove_one_teamAI = function(l_117_0, l_117_1, l_117_2)
  if not l_117_0._verify_gamestate(l_117_0._gamestate_filter.any_ingame) then
    return 
  end
  managers.groupai:state():sync_remove_one_teamAI(l_117_1, l_117_2)
end

UnitNetworkHandler.sync_smoke_grenade = function(l_118_0, l_118_1, l_118_2, l_118_3, l_118_4)
  if not l_118_0._verify_gamestate(l_118_0._gamestate_filter.any_ingame) then
    return 
  end
  managers.groupai:state():sync_smoke_grenade(l_118_1, l_118_2, l_118_3, l_118_4)
end

UnitNetworkHandler.sync_smoke_grenade_kill = function(l_119_0)
  if not l_119_0._verify_gamestate(l_119_0._gamestate_filter.any_ingame) then
    return 
  end
  managers.groupai:state():sync_smoke_grenade_kill()
end

UnitNetworkHandler.sync_hostage_headcount = function(l_120_0, l_120_1)
  if not l_120_0._verify_gamestate(l_120_0._gamestate_filter.any_ingame) then
    return 
  end
  managers.groupai:state():sync_hostage_headcount(l_120_1)
end

UnitNetworkHandler.play_distance_interact_redirect = function(l_121_0, l_121_1, l_121_2, l_121_3)
  if not alive(l_121_1) or not l_121_0._verify_gamestate(l_121_0._gamestate_filter.any_ingame) or not l_121_0._verify_sender(l_121_3) then
    return 
  end
  l_121_1:movement():play_redirect(l_121_2)
end

UnitNetworkHandler.start_timer_gui = function(l_122_0, l_122_1, l_122_2, l_122_3)
  if not alive(l_122_1) or not l_122_0._verify_gamestate(l_122_0._gamestate_filter.any_ingame) or not l_122_0._verify_sender(l_122_3) then
    return 
  end
  l_122_1:timer_gui():sync_start(l_122_2)
end

UnitNetworkHandler.set_jammed_timer_gui = function(l_123_0, l_123_1, l_123_2)
  if not alive(l_123_1) or not l_123_0._verify_gamestate(l_123_0._gamestate_filter.any_ingame) then
    return 
  end
  l_123_1:timer_gui():sync_set_jammed(l_123_2)
end

UnitNetworkHandler.give_equipment = function(l_124_0, l_124_1, l_124_2, l_124_3)
  if not l_124_0._verify_gamestate(l_124_0._gamestate_filter.any_ingame) or not l_124_0._verify_sender(l_124_3) then
    return 
  end
  managers.player:add_special({name = l_124_1, amount = l_124_2})
end

UnitNetworkHandler.killzone_set_unit = function(l_125_0, l_125_1)
  if not l_125_0._verify_gamestate(l_125_0._gamestate_filter.any_ingame) then
    return 
  end
  managers.killzone:set_unit(managers.player:player_unit(), l_125_1)
end

UnitNetworkHandler.dangerzone_set_level = function(l_126_0, l_126_1)
  if not l_126_0._verify_gamestate(l_126_0._gamestate_filter.any_ingame) then
    return 
  end
  managers.player:player_unit():character_damage():set_danger_level(l_126_1)
end

UnitNetworkHandler.sync_player_movement_state = function(l_127_0, l_127_1, l_127_2, l_127_3, l_127_4)
  if not l_127_0._verify_gamestate(l_127_0._gamestate_filter.any_ingame) then
    return 
  end
  l_127_0:_chk_unit_too_early(l_127_1, l_127_4, "sync_player_movement_state", 1, l_127_1, l_127_2, l_127_3, l_127_4)
  if not alive(l_127_1) then
    return 
  end
  if Global.local_member:unit() and l_127_1:key() == Global.local_member:unit():key() then
    {standard = {bleed_out = true, arrested = true, tased = true, incapacitated = true, carry = true}, carry = {bleed_out = true, arrested = true, tased = true, incapacitated = true, standard = true}}.mask_off = {standard = true, carry = true, arrested = true}
     -- DECOMPILER ERROR: Confused about usage of registers!

    {standard = {bleed_out = true, arrested = true, tased = true, incapacitated = true, carry = true}, carry = {bleed_out = true, arrested = true, tased = true, incapacitated = true, standard = true}}.bleed_out = {fatal = true, standard = true, carry = true}
     -- DECOMPILER ERROR: Confused about usage of registers!

    {standard = {bleed_out = true, arrested = true, tased = true, incapacitated = true, carry = true}, carry = {bleed_out = true, arrested = true, tased = true, incapacitated = true, standard = true}}.fatal = {standard = true, carry = true}
     -- DECOMPILER ERROR: Confused about usage of registers!

    {standard = {bleed_out = true, arrested = true, tased = true, incapacitated = true, carry = true}, carry = {bleed_out = true, arrested = true, tased = true, incapacitated = true, standard = true}}.arrested = {standard = true, carry = true}
     -- DECOMPILER ERROR: Confused about usage of registers!

    {standard = {bleed_out = true, arrested = true, tased = true, incapacitated = true, carry = true}, carry = {bleed_out = true, arrested = true, tased = true, incapacitated = true, standard = true}}.tased = {standard = true, carry = true, incapacitated = true}
     -- DECOMPILER ERROR: Confused about usage of registers!

    {standard = {bleed_out = true, arrested = true, tased = true, incapacitated = true, carry = true}, carry = {bleed_out = true, arrested = true, tased = true, incapacitated = true, standard = true}}.incapacitated = {standard = true, carry = true}
     -- DECOMPILER ERROR: Confused about usage of registers!

    {standard = {bleed_out = true, arrested = true, tased = true, incapacitated = true, carry = true}, carry = {bleed_out = true, arrested = true, tased = true, incapacitated = true, standard = true}}.clean = {mask_off = true, standard = true, carry = true, arrested = true}
     -- DECOMPILER ERROR: Confused at declaration of local variable

    if l_127_1:movement():current_state_name() == l_127_2 then
      return 
    end
     -- DECOMPILER ERROR: Confused about usage of registers!

    if l_127_1:movement():current_state_name() and ({standard = {bleed_out = true, arrested = true, tased = true, incapacitated = true, carry = true}, carry = {bleed_out = true, arrested = true, tased = true, incapacitated = true, standard = true}})[l_127_1:movement():current_state_name()][l_127_2] then
      managers.player:set_player_state(l_127_2)
    else
      debug_pause_unit(l_127_1, "[UnitNetworkHandler:sync_player_movement_state] received invalid transition", l_127_1, l_127_1:movement():current_state_name(), "->", l_127_2)
    end
  else
    l_127_1:movement():sync_movement_state(l_127_2, l_127_3)
     -- DECOMPILER ERROR: Confused about usage of registers for local variables.

  end
end

UnitNetworkHandler.sync_show_hint = function(l_128_0, l_128_1, l_128_2)
  if not l_128_0._verify_gamestate(l_128_0._gamestate_filter.any_ingame) or not l_128_0._verify_sender(l_128_2) then
    return 
  end
  managers.hint:sync_show_hint(l_128_1)
end

UnitNetworkHandler.sync_show_action_message = function(l_129_0, l_129_1, l_129_2, l_129_3)
  if not alive(l_129_1) or not l_129_0._verify_gamestate(l_129_0._gamestate_filter.any_ingame) or not l_129_0._verify_sender(l_129_3) then
    return 
  end
  managers.action_messaging:sync_show_message(l_129_2, l_129_1)
end

UnitNetworkHandler.sync_waiting_for_player_start = function(l_130_0, l_130_1)
  if not l_130_0._verify_gamestate(l_130_0._gamestate_filter.waiting_for_players) then
    return 
  end
  game_state_machine:current_state():sync_start(l_130_1)
end

UnitNetworkHandler.sync_waiting_for_player_skip = function(l_131_0)
  if not l_131_0._verify_gamestate(l_131_0._gamestate_filter.waiting_for_players) then
    return 
  end
  game_state_machine:current_state():sync_skip()
end

UnitNetworkHandler.criminal_hurt = function(l_132_0, l_132_1, l_132_2, l_132_3, l_132_4)
  if not l_132_0._verify_gamestate(l_132_0._gamestate_filter.any_ingame) or not l_132_0._verify_character_and_sender(l_132_1, l_132_4) then
    return 
  end
  if not alive(l_132_2) or l_132_1:key() == l_132_2:key() then
    l_132_2 = nil
  end
  managers.hud:set_mugshot_damage_taken(l_132_1:unit_data().mugshot_id)
  managers.groupai:state():criminal_hurt_drama(l_132_1, l_132_2, l_132_3 * 0.0099999997764826)
end

UnitNetworkHandler.assign_secret_assignment = function(l_133_0, l_133_1)
  if not l_133_0._verify_gamestate(l_133_0._gamestate_filter.any_ingame) then
    return 
  end
  managers.secret_assignment:assign(l_133_1)
end

UnitNetworkHandler.complete_secret_assignment = function(l_134_0, l_134_1, l_134_2)
  if not l_134_0._verify_gamestate(l_134_0._gamestate_filter.any_ingame) or not l_134_0._verify_sender(l_134_2) then
    return 
  end
  managers.secret_assignment:complete_secret_assignment(l_134_1)
end

UnitNetworkHandler.failed_secret_assignment = function(l_135_0, l_135_1)
  if not l_135_0._verify_gamestate(l_135_0._gamestate_filter.any_ingame) then
    return 
  end
  managers.secret_assignment:failed_secret_assignment(l_135_1)
end

UnitNetworkHandler.secret_assignment_done = function(l_136_0, l_136_1, l_136_2)
  if not l_136_0._verify_gamestate(l_136_0._gamestate_filter.any_ingame) then
    return 
  end
  managers.secret_assignment:secret_assignment_done(l_136_1, l_136_2)
end

UnitNetworkHandler.arrested = function(l_137_0, l_137_1)
  if not alive(l_137_1) then
    return 
  end
  l_137_1:movement():sync_arrested()
end

UnitNetworkHandler.suspect_uncovered = function(l_138_0, l_138_1, l_138_2)
  if not l_138_0._verify_gamestate(l_138_0._gamestate_filter.any_ingame) then
    return 
  end
  local suspect_member = Global.local_member
  if not suspect_member then
    return 
  end
  local suspect_unit = suspect_member:unit()
  if not suspect_unit then
    return 
  end
  suspect_unit:movement():on_uncovered(l_138_1)
end

UnitNetworkHandler.add_synced_team_upgrade = function(l_139_0, l_139_1, l_139_2, l_139_3, l_139_4)
  local sender_peer = l_139_0._verify_sender(l_139_4)
  if not l_139_0._verify_gamestate(l_139_0._gamestate_filter.any_ingame) or not sender_peer then
    return 
  end
  local peer_id = sender_peer:id()
  managers.player:add_synced_team_upgrade(peer_id, l_139_1, l_139_2, l_139_3)
end

UnitNetworkHandler.sync_deployable_equipment = function(l_140_0, l_140_1, l_140_2, l_140_3, l_140_4)
  if not l_140_0._verify_gamestate(l_140_0._gamestate_filter.any_ingame) or not l_140_0._verify_sender(l_140_4) then
    return 
  end
  managers.player:set_synced_deployable_equipment(l_140_1, l_140_2, l_140_3)
end

UnitNetworkHandler.sync_cable_ties = function(l_141_0, l_141_1, l_141_2, l_141_3)
  if not l_141_0._verify_gamestate(l_141_0._gamestate_filter.any_ingame) or not l_141_0._verify_sender(l_141_3) then
    return 
  end
  managers.player:set_synced_cable_ties(l_141_1, l_141_2)
end

UnitNetworkHandler.sync_perk_equipment = function(l_142_0, l_142_1, l_142_2, l_142_3)
  if not l_142_0._verify_gamestate(l_142_0._gamestate_filter.any_ingame) or not l_142_0._verify_sender(l_142_3) then
    return 
  end
  managers.player:set_synced_perk(l_142_1, l_142_2)
end

UnitNetworkHandler.sync_ammo_amount = function(l_143_0, l_143_1, l_143_2, l_143_3, l_143_4, l_143_5, l_143_6, l_143_7)
  if not l_143_0._verify_gamestate(l_143_0._gamestate_filter.any_ingame) or not l_143_0._verify_sender(l_143_7) then
    return 
  end
  managers.player:set_synced_ammo_info(l_143_1, l_143_2, l_143_3, l_143_4, l_143_5, l_143_6)
end

UnitNetworkHandler.sync_carry = function(l_144_0, l_144_1, l_144_2, l_144_3, l_144_4, l_144_5, l_144_6, l_144_7)
  if not l_144_0._verify_gamestate(l_144_0._gamestate_filter.any_ingame) or not l_144_0._verify_sender(l_144_7) then
    return 
  end
  managers.player:set_synced_carry(l_144_1, l_144_2, l_144_3, l_144_4, l_144_5, l_144_6)
end

UnitNetworkHandler.sync_remove_carry = function(l_145_0, l_145_1, l_145_2)
  if not l_145_0._verify_gamestate(l_145_0._gamestate_filter.any_ingame) or not l_145_0._verify_sender(l_145_2) then
    return 
  end
  managers.player:remove_synced_carry(l_145_1)
end

UnitNetworkHandler.server_drop_carry = function(l_146_0, l_146_1, l_146_2, l_146_3, l_146_4, l_146_5, l_146_6, l_146_7, l_146_8, l_146_9, l_146_10)
  if not l_146_0._verify_gamestate(l_146_0._gamestate_filter.any_ingame) or not l_146_0._verify_sender(l_146_10) then
    return 
  end
  managers.player:server_drop_carry(l_146_1, l_146_2, l_146_3, l_146_4, l_146_5, l_146_6, l_146_7, l_146_8, l_146_9)
end

UnitNetworkHandler.sync_carry_data = function(l_147_0, l_147_1, l_147_2, l_147_3, l_147_4, l_147_5, l_147_6, l_147_7, l_147_8, l_147_9, l_147_10)
  if not alive(l_147_1) or not l_147_0._verify_gamestate(l_147_0._gamestate_filter.any_ingame) or not l_147_0._verify_sender(l_147_10) then
    return 
  end
  managers.player:sync_carry_data(l_147_1, l_147_2, l_147_3, l_147_4, l_147_5, l_147_6, l_147_7, l_147_8, l_147_9)
end

UnitNetworkHandler.sync_bag_dye_pack_exploded = function(l_148_0, l_148_1, l_148_2)
  if not alive(l_148_1) or not l_148_0._verify_gamestate(l_148_0._gamestate_filter.any_ingame) or not l_148_0._verify_sender(l_148_2) then
    return 
  end
  l_148_1:carry_data():sync_dye_exploded()
end

UnitNetworkHandler.server_secure_loot = function(l_149_0, l_149_1, l_149_2, l_149_3)
  if not l_149_0._verify_gamestate(l_149_0._gamestate_filter.any_ingame) or not l_149_0._verify_sender(l_149_3) then
    return 
  end
  managers.loot:server_secure_loot(l_149_1, l_149_2)
end

UnitNetworkHandler.sync_secure_loot = function(l_150_0, l_150_1, l_150_2, l_150_3, l_150_4)
  if (not l_150_0._verify_gamestate(l_150_0._gamestate_filter.any_ingame) and not l_150_0._verify_gamestate(l_150_0._gamestate_filter.any_end_game)) or not l_150_0._verify_sender(l_150_4) then
    return 
  end
  managers.loot:sync_secure_loot(l_150_1, l_150_2, l_150_3)
end

UnitNetworkHandler.sync_small_loot_taken = function(l_151_0, l_151_1, l_151_2, l_151_3)
  if not alive(l_151_1) or not l_151_0._verify_gamestate(l_151_0._gamestate_filter.any_ingame) or not l_151_0._verify_sender(l_151_3) then
    return 
  end
  l_151_1:base():taken(l_151_2)
end

UnitNetworkHandler.server_unlock_asset = function(l_152_0, l_152_1, l_152_2)
  if not l_152_0._verify_gamestate(l_152_0._gamestate_filter.any_ingame) or not l_152_0._verify_sender(l_152_2) then
    return 
  end
  managers.assets:server_unlock_asset(l_152_1)
end

UnitNetworkHandler.sync_unlock_asset = function(l_153_0, l_153_1, l_153_2)
  if not l_153_0._verify_gamestate(l_153_0._gamestate_filter.any_ingame) or not l_153_0._verify_sender(l_153_2) then
    return 
  end
  managers.assets:sync_unlock_asset(l_153_1)
end

UnitNetworkHandler.sync_heist_time = function(l_154_0, l_154_1, l_154_2)
  if not l_154_0._verify_gamestate(l_154_0._gamestate_filter.any_ingame) or not l_154_0._verify_sender(l_154_2) then
    return 
  end
  managers.game_play_central:sync_heist_time(l_154_1)
end

UnitNetworkHandler.run_mission_door_sequence = function(l_155_0, l_155_1, l_155_2, l_155_3)
  if not alive(l_155_1) or not l_155_0._verify_gamestate(l_155_0._gamestate_filter.any_ingame) or not l_155_0._verify_sender(l_155_3) then
    return 
  end
  l_155_1:base():run_sequence_simple(l_155_2)
end

UnitNetworkHandler.set_mission_door_device_powered = function(l_156_0, l_156_1, l_156_2, l_156_3, l_156_4)
  if not alive(l_156_1) or not l_156_0._verify_gamestate(l_156_0._gamestate_filter.any_ingame) or not l_156_0._verify_sender(l_156_4) then
    return 
  end
  MissionDoor.set_mission_door_device_powered(l_156_1, l_156_2, l_156_3)
end

UnitNetworkHandler.run_mission_door_device_sequence = function(l_157_0, l_157_1, l_157_2, l_157_3)
  if not alive(l_157_1) or not l_157_0._verify_gamestate(l_157_0._gamestate_filter.any_ingame) or not l_157_0._verify_sender(l_157_3) then
    return 
  end
  MissionDoor.run_mission_door_device_sequence(l_157_1, l_157_2)
end

UnitNetworkHandler.server_place_mission_door_device = function(l_158_0, l_158_1, l_158_2, l_158_3)
  if not alive(l_158_1) or not l_158_0._verify_gamestate(l_158_0._gamestate_filter.any_ingame) or not l_158_0._verify_sender(l_158_3) then
    return 
  end
  local result = l_158_1:interaction():server_place_mission_door_device(l_158_2)
  l_158_3:result_place_mission_door_device(l_158_1, result)
end

UnitNetworkHandler.result_place_mission_door_device = function(l_159_0, l_159_1, l_159_2, l_159_3)
  if not alive(l_159_1) or not l_159_0._verify_gamestate(l_159_0._gamestate_filter.any_ingame) or not l_159_0._verify_sender(l_159_3) then
    return 
  end
  l_159_1:interaction():result_place_mission_door_device(l_159_2)
end

UnitNetworkHandler.set_kit_selection = function(l_160_0, l_160_1, l_160_2, l_160_3, l_160_4, l_160_5)
  if not l_160_0._verify_gamestate(l_160_0._gamestate_filter.any_ingame) or not l_160_0._verify_sender(l_160_5) then
    return 
  end
  managers.menu:get_menu("kit_menu").renderer:set_kit_selection(l_160_1, l_160_2, l_160_3, l_160_4)
end

UnitNetworkHandler.set_armor = function(l_161_0, l_161_1, l_161_2, l_161_3)
  if not alive(l_161_1) or not l_161_0._verify_gamestate(l_161_0._gamestate_filter.any_ingame) or not l_161_0._verify_sender(l_161_3) then
    return 
  end
  local peer = l_161_0._verify_sender(l_161_3)
  local peer_id = peer:id()
  local character_data = managers.criminals:character_data_by_peer_id(peer_id)
  if character_data and character_data.panel_id then
    managers.hud:set_teammate_armor(character_data.panel_id, {current = l_161_2 / 100, total = 1, max = 1})
  else
    managers.hud:set_mugshot_armor(l_161_1:unit_data().mugshot_id, l_161_2 / 100)
  end
end

UnitNetworkHandler.set_health = function(l_162_0, l_162_1, l_162_2, l_162_3)
  if not alive(l_162_1) or not l_162_0._verify_gamestate(l_162_0._gamestate_filter.any_ingame) or not l_162_0._verify_sender(l_162_3) then
    return 
  end
  local peer = l_162_0._verify_sender(l_162_3)
  local peer_id = peer:id()
  local character_data = managers.criminals:character_data_by_peer_id(peer_id)
  if character_data and character_data.panel_id then
    managers.hud:set_teammate_health(character_data.panel_id, {current = l_162_2 / 100, total = 1, max = 1})
  else
    managers.hud:set_mugshot_health(l_162_1:unit_data().mugshot_id, l_162_2 / 100)
  end
end

UnitNetworkHandler.sync_equipment_possession = function(l_163_0, l_163_1, l_163_2, l_163_3, l_163_4)
  if not l_163_0._verify_gamestate(l_163_0._gamestate_filter.any_ingame) or not l_163_0._verify_sender(l_163_4) then
    return 
  end
  managers.player:set_synced_equipment_possession(l_163_1, l_163_2, l_163_3)
end

UnitNetworkHandler.sync_remove_equipment_possession = function(l_164_0, l_164_1, l_164_2, l_164_3)
  if not l_164_0._verify_gamestate(l_164_0._gamestate_filter.any_ingame) or not l_164_0._verify_sender(l_164_3) then
    return 
  end
  local equipment_peer = managers.network:session():peer(l_164_1)
  if not equipment_peer then
    print("[UnitNetworkHandler:sync_remove_equipment_possession] unknown peer", l_164_1)
    return 
  end
  managers.player:remove_equipment_possession(l_164_1, l_164_2)
end

UnitNetworkHandler.sync_start_anticipation = function(l_165_0)
  if not l_165_0._verify_gamestate(l_165_0._gamestate_filter.any_ingame) then
    return 
  end
  managers.hud:sync_start_anticipation()
end

UnitNetworkHandler.sync_start_anticipation_music = function(l_166_0)
  if not l_166_0._verify_gamestate(l_166_0._gamestate_filter.any_ingame) then
    return 
  end
  managers.hud:sync_start_anticipation_music()
end

UnitNetworkHandler.sync_start_assault = function(l_167_0)
  if not l_167_0._verify_gamestate(l_167_0._gamestate_filter.any_ingame) then
    return 
  end
  managers.hud:sync_start_assault()
end

UnitNetworkHandler.sync_end_assault = function(l_168_0, l_168_1)
  if not l_168_0._verify_gamestate(l_168_0._gamestate_filter.any_ingame) then
    return 
  end
  managers.hud:sync_end_assault(l_168_1)
end

UnitNetworkHandler.sync_assault_dialog = function(l_169_0, l_169_1)
  if not l_169_0._verify_gamestate(l_169_0._gamestate_filter.any_ingame) then
    return 
  end
  managers.hud:sync_assault_dialog(l_169_1)
end

UnitNetworkHandler.set_contour = function(l_170_0, l_170_1, l_170_2)
  if not alive(l_170_1) then
    return 
  end
  l_170_1:base():set_contour(l_170_2)
end

UnitNetworkHandler.mark_enemy = function(l_171_0, l_171_1, l_171_2, l_171_3)
  if not l_171_0._verify_gamestate(l_171_0._gamestate_filter.any_ingame) or not l_171_0._verify_character_and_sender(l_171_1, l_171_3) then
    return 
  end
  managers.game_play_central:add_enemy_contour(l_171_1, l_171_2)
end

UnitNetworkHandler.mark_minion = function(l_172_0, l_172_1, l_172_2, l_172_3, l_172_4, l_172_5)
  if not l_172_0._verify_gamestate(l_172_0._gamestate_filter.any_ingame) or not l_172_0._verify_character_and_sender(l_172_1, l_172_5) then
    return 
  end
  local health_multiplier = 1
  if l_172_3 > 0 then
    health_multiplier = health_multiplier * tweak_data.upgrades.values.player.convert_enemies_health_multiplier[l_172_3]
  end
  if l_172_4 > 0 then
    health_multiplier = health_multiplier * tweak_data.upgrades.values.player.passive_convert_enemies_health_multiplier[l_172_4]
  end
  l_172_1:character_damage():convert_to_criminal(health_multiplier)
  managers.game_play_central:add_friendly_contour(l_172_1)
  managers.groupai:state():sync_converted_enemy(l_172_1)
  if l_172_2 == managers.network:session():local_peer():id() then
    managers.player:count_up_player_minions()
  end
end

UnitNetworkHandler.count_down_player_minions = function(l_173_0)
  if not l_173_0._verify_gamestate(l_173_0._gamestate_filter.any_ingame) then
    return 
  end
  managers.player:count_down_player_minions()
end

UnitNetworkHandler.sync_teammate_helped_hint = function(l_174_0, l_174_1, l_174_2, l_174_3, l_174_4)
  if not l_174_0._verify_gamestate(l_174_0._gamestate_filter.any_ingame) or not l_174_0._verify_character_and_sender(l_174_2, l_174_4) or not l_174_0._verify_character(l_174_3, l_174_4) then
    return 
  end
  managers.trade:sync_teammate_helped_hint(l_174_2, l_174_3, l_174_1)
end

UnitNetworkHandler.sync_assault_mode = function(l_175_0, l_175_1)
  if not l_175_0._verify_gamestate(l_175_0._gamestate_filter.any_ingame) then
    return 
  end
  managers.groupai:state():sync_assault_mode(l_175_1)
end

UnitNetworkHandler.sync_hostage_killed_warning = function(l_176_0, l_176_1)
  if not l_176_0._verify_gamestate(l_176_0._gamestate_filter.any_ingame) then
    return 
  end
  managers.groupai:state():sync_hostage_killed_warning(l_176_1)
end

UnitNetworkHandler.set_interaction_voice = function(l_177_0, l_177_1, l_177_2, l_177_3)
  if not l_177_0._verify_gamestate(l_177_0._gamestate_filter.any_ingame) or not l_177_0._verify_character_and_sender(l_177_1, l_177_3) then
    return 
  end
  l_177_1:brain():set_interaction_voice(l_177_2 ~= "" and l_177_2 or nil)
end

UnitNetworkHandler.award_achievment = function(l_178_0, l_178_1, l_178_2)
  if not l_178_0._verify_sender(l_178_2) then
    return 
  end
  if not managers.statistics:is_dropin() then
    managers.challenges:set_flag(l_178_1)
  end
end

UnitNetworkHandler.sync_teammate_comment = function(l_179_0, l_179_1, l_179_2, l_179_3, l_179_4, l_179_5)
  if not l_179_0._verify_gamestate(l_179_0._gamestate_filter.any_ingame) or not l_179_0._verify_sender(l_179_5) then
    return 
  end
  managers.groupai:state():sync_teammate_comment(l_179_1, l_179_2, l_179_3, l_179_4)
end

UnitNetworkHandler.sync_teammate_comment_instigator = function(l_180_0, l_180_1, l_180_2)
  if not l_180_0._verify_gamestate(l_180_0._gamestate_filter.any_ingame) or not l_180_0._verify_sender(sender) then
    return 
  end
  managers.groupai:state():sync_teammate_comment_instigator(l_180_1, l_180_2)
end

UnitNetworkHandler.begin_gameover_fadeout = function(l_181_0)
  if not l_181_0._verify_gamestate(l_181_0._gamestate_filter.any_ingame) then
    return 
  end
  managers.groupai:state():begin_gameover_fadeout()
end

UnitNetworkHandler.send_statistics = function(l_182_0, l_182_1, l_182_2, l_182_3, l_182_4, l_182_5, l_182_6)
  if not l_182_0._verify_gamestate(l_182_0._gamestate_filter.any_end_game) then
    return 
  end
  managers.network:game():on_statistics_recieved(l_182_1, l_182_2, l_182_3, l_182_4, l_182_5, l_182_6)
end

UnitNetworkHandler.sync_statistics_result = function(l_183_0, ...)
  if game_state_machine:current_state().on_statistics_result then
    game_state_machine:current_state():on_statistics_result(...)
     -- DECOMPILER ERROR: Confused about usage of registers for local variables.

  end
end

UnitNetworkHandler.statistics_tied = function(l_184_0, l_184_1, l_184_2)
  if not l_184_0._verify_sender(l_184_2) then
    return 
  end
  managers.statistics:tied({name = l_184_1})
end

UnitNetworkHandler.bain_comment = function(l_185_0, l_185_1, l_185_2)
  if not l_185_0._verify_sender(l_185_2) then
    return 
  end
  if managers.dialog and managers.groupai and managers.groupai:state():bain_state() then
    managers.dialog:queue_dialog(l_185_1, {})
  end
end

UnitNetworkHandler.is_inside_point_of_no_return = function(l_186_0, l_186_1, l_186_2, l_186_3)
  if not l_186_0._verify_gamestate(l_186_0._gamestate_filter.any_ingame) or not l_186_0._verify_sender(l_186_3) then
    return 
  end
  managers.groupai:state():set_is_inside_point_of_no_return(l_186_2, l_186_1)
end

UnitNetworkHandler.mission_ended = function(l_187_0, l_187_1, l_187_2, l_187_3)
  if not l_187_0._verify_gamestate(l_187_0._gamestate_filter.any_ingame) or not l_187_0._verify_sender(l_187_3) then
    return 
  end
  game_state_machine:change_state_by_name("victoryscreen", {num_winners = l_187_2, personal_win = (not managers.groupai:state()._failed_point_of_no_return and alive(managers.player:player_unit()))})
  do return end
  game_state_machine:change_state_by_name("gameoverscreen")
end

UnitNetworkHandler.sync_level_up = function(l_188_0, l_188_1, l_188_2, l_188_3)
  if not l_188_0._verify_sender(l_188_3) then
    return 
  end
  local peer = managers.network:session():peer(l_188_1)
  if not peer then
    return 
  end
  peer:set_level(l_188_2)
end

UnitNetworkHandler.sync_set_outline = function(l_189_0, l_189_1, l_189_2, l_189_3)
  if not l_189_0._verify_gamestate(l_189_0._gamestate_filter.any_ingame) or not l_189_0._verify_character_and_sender(l_189_1, l_189_3) then
    return 
  end
  ElementSetOutline.sync_function(l_189_1, l_189_2)
end

UnitNetworkHandler.sync_disable_shout = function(l_190_0, l_190_1, l_190_2, l_190_3)
  if not l_190_0._verify_gamestate(l_190_0._gamestate_filter.any_ingame) or not l_190_0._verify_character_and_sender(l_190_1, l_190_3) then
    return 
  end
  ElementDisableShout.sync_function(l_190_1, l_190_2)
end

UnitNetworkHandler.sync_run_sequence_char = function(l_191_0, l_191_1, l_191_2, l_191_3)
  if not l_191_0._verify_gamestate(l_191_0._gamestate_filter.any_ingame) or not l_191_0._verify_character_and_sender(l_191_1, l_191_3) then
    return 
  end
  ElementSequenceCharacter.sync_function(l_191_1, l_191_2)
end

UnitNetworkHandler.sync_player_kill_statistic = function(l_192_0, l_192_1, l_192_2, l_192_3, l_192_4, l_192_5)
  if not l_192_0._verify_gamestate(l_192_0._gamestate_filter.any_ingame) or not l_192_0._verify_sender(l_192_5) or not alive(l_192_3) then
    return 
  end
  local data = {name = l_192_1, head_shot = l_192_2, weapon_unit = l_192_3, variant = l_192_4}
  managers.statistics:killed_by_anyone(data)
  local attacker_state = managers.player:current_state()
  data.attacker_state = attacker_state
  managers.statistics:killed(data)
end

UnitNetworkHandler.set_attention_enabled = function(l_193_0, l_193_1, l_193_2, l_193_3, l_193_4)
  if not l_193_0._verify_gamestate(l_193_0._gamestate_filter.any_ingame) or not l_193_0._verify_character_and_sender(l_193_1, l_193_4) then
    return 
  end
  if l_193_1:in_slot(managers.slot:get_mask("players")) and l_193_1:base().is_husk_player then
    local setting_name = tweak_data.attention:get_attention_name(l_193_2)
    l_193_1:movement():set_attention_setting_enabled(setting_name, l_193_3, false)
  else
    debug_pause_unit(l_193_1, "[UnitNetworkHandler:set_attention_enabled] invalid unit", l_193_1)
  end
end

UnitNetworkHandler.link_attention_no_rot = function(l_194_0, l_194_1, l_194_2, l_194_3, l_194_4, l_194_5)
  if not l_194_0._verify_gamestate(l_194_0._gamestate_filter.any_ingame) or not alive(l_194_1) or not alive(l_194_2) then
    return 
  end
  l_194_2:attention():link(l_194_1, l_194_3, l_194_4)
end

UnitNetworkHandler.unlink_attention = function(l_195_0, l_195_1, l_195_2)
  if not l_195_0._verify_gamestate(l_195_0._gamestate_filter.any_ingame) or not alive(l_195_1) then
    return 
  end
  l_195_1:attention():link(nil)
end

UnitNetworkHandler.suspicion = function(l_196_0, l_196_1, l_196_2, l_196_3)
  if not l_196_0._verify_gamestate(l_196_0._gamestate_filter.any_ingame) then
    return 
  end
  local suspect_member = managers.network:game():member(l_196_1)
  if not suspect_member then
    return 
  end
  local suspect_unit = suspect_member:unit()
  if not suspect_unit then
    return 
  end
  if l_196_2 == 0 then
    l_196_2 = false
  elseif l_196_2 == 255 then
    l_196_2 = true
  else
    l_196_2 = l_196_2 / 254
  end
  suspect_unit:movement():on_suspicion(nil, l_196_2)
end

UnitNetworkHandler.suspicion_hud = function(l_197_0, l_197_1, l_197_2)
  if not l_197_0._verify_gamestate(l_197_0._gamestate_filter.any_ingame) or not alive(l_197_1) then
    return 
  end
  if l_197_2 == 0 then
    l_197_2 = false
  elseif l_197_2 == 1 then
    l_197_2 = 1
  else
    l_197_2 = true
  end
  managers.groupai:state():sync_suspicion_hud(l_197_1, l_197_2)
end

UnitNetworkHandler.group_ai_event = function(l_198_0, l_198_1, l_198_2, l_198_3)
  if not l_198_0._verify_gamestate(l_198_0._gamestate_filter.any_ingame) then
    return 
  end
  managers.groupai:state():sync_event(l_198_1, l_198_2)
end

UnitNetworkHandler.start_timespeed_effect = function(l_199_0, l_199_1, l_199_2, l_199_3, l_199_4, l_199_5, l_199_6, l_199_7)
  if not l_199_0._verify_gamestate(l_199_0._gamestate_filter.any_ingame) or not l_199_0._verify_sender(l_199_7) then
    return 
  end
  local effect_desc = {timer = l_199_2, speed = l_199_3, fade_in = l_199_4, sustain = l_199_5, fade_out = l_199_6}
  managers.time_speed:play_effect(l_199_1, effect_desc)
end

UnitNetworkHandler.stop_timespeed_effect = function(l_200_0, l_200_1, l_200_2, l_200_3)
  if not l_200_0._verify_gamestate(l_200_0._gamestate_filter.any_ingame) or not l_200_0._verify_sender(l_200_3) then
    return 
  end
  managers.time_speed:stop_effect(l_200_1, l_200_2)
end

UnitNetworkHandler.sync_upgrade = function(l_201_0, l_201_1, l_201_2, l_201_3, l_201_4)
  local peer = l_201_0._verify_sender(l_201_4)
  if not peer then
    print("[UnitNetworkHandler:sync_upgrade] missing peer", l_201_1, l_201_2, l_201_3, l_201_4:ip_at_index(0))
    return 
  end
  local _get_unit = function()
    local unit = managers.network:game():member_peer(peer):unit()
    if not unit then
      print("[UnitNetworkHandler:sync_upgrade] missing unit", upgrade_category, upgrade_name, upgrade_level, sender:ip_at_index(0))
    end
    return unit
   end
  local unit = _get_unit()
  if not unit then
    return 
  end
  unit:base():set_upgrade_value(l_201_1, l_201_2, l_201_3)
end

UnitNetworkHandler.suppression = function(l_202_0, l_202_1, l_202_2, l_202_3)
  if not l_202_0._verify_gamestate(l_202_0._gamestate_filter.any_ingame) or not l_202_0._verify_character(l_202_1) then
    return 
  end
  local sup_tweak = l_202_1:base():char_tweak().suppression
  if not sup_tweak then
    debug_pause_unit(l_202_1, "[UnitNetworkHandler:suppression] husk missing suppression settings", l_202_1)
    return 
  end
  if not sup_tweak.brown_point then
    local amount_max = sup_tweak.react_point[2]
  end
  local amount = amount_max > 0 and amount_max * l_202_2 / 255 or "max"
  l_202_1:character_damage():build_suppression(amount)
end

UnitNetworkHandler.suppressed_state = function(l_203_0, l_203_1, l_203_2, l_203_3)
  if not l_203_0._verify_gamestate(l_203_0._gamestate_filter.any_ingame) or not l_203_0._verify_character(l_203_1) then
    return 
  end
  l_203_1:movement():on_suppressed(l_203_2)
end

UnitNetworkHandler.camera_yaw_pitch = function(l_204_0, l_204_1, l_204_2, l_204_3)
  if not alive(l_204_1) or not l_204_0._verify_gamestate(l_204_0._gamestate_filter.any_ingame) then
    return 
  end
  local yaw = 360 * l_204_2 / 255 - 180
  local pitch = 180 * l_204_3 / 255 - 90
  l_204_1:base():apply_rotations(yaw, pitch)
end

UnitNetworkHandler.loot_link = function(l_205_0, l_205_1, l_205_2, l_205_3)
  if not alive(l_205_1) or not alive(l_205_2) or not l_205_0._verify_gamestate(l_205_0._gamestate_filter.any_ingame) then
    return 
  end
  if l_205_1 == l_205_2 then
    l_205_1:carry_data():unlink()
  else
    l_205_1:carry_data():link_to(l_205_2)
  end
end

UnitNetworkHandler.remove_unit = function(l_206_0, l_206_1, l_206_2)
  if not alive(l_206_1) then
    return 
  end
  if l_206_1:id() ~= -1 then
    Network:detach_unit(l_206_1)
  end
  l_206_1:set_slot(0)
end


