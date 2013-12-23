-- Decompiled using luadec 2.0.1 by sztupy (http://winmo.sztupy.hu)
-- Command line was: F:\SteamLibrary\SteamApps\common\PAYDAY 2\lua\lib\network\networkmember.luac 

if not NetworkMember then
  NetworkMember = class()
end
NetworkMember.init = function(l_1_0, l_1_1)
  l_1_0._peer = l_1_1
end

NetworkMember.delete = function(l_2_0)
  if managers.criminals then
    managers.criminals:remove_character_by_peer_id(l_2_0._peer:id())
  end
  if alive(l_2_0._unit) then
    if Network:is_server() then
      managers.network:session():send_to_peers_loaded_except(l_2_0._peer:id(), "remove_unit", l_2_0._unit)
    end
    if l_2_0._unit:id() ~= -1 then
      Network:detach_unit(l_2_0._unit)
    end
    if l_2_0._unit:base() and l_2_0._unit:base().set_slot then
      l_2_0._unit:base():set_slot(l_2_0._unit, 0)
    else
      l_2_0._unit:set_slot(0)
    end
  end
  l_2_0._unit = nil
end

NetworkMember.load = function(l_3_0, l_3_1)
  l_3_0._peer = managers.network:session():peer(l_3_1.id)
end

NetworkMember.save = function(l_4_0)
  local data = {}
  data.id = l_4_0._peer:id()
  return data
end

NetworkMember.peer = function(l_5_0)
  return l_5_0._peer
end

NetworkMember.unit = function(l_6_0)
  return l_6_0._unit
end

NetworkMember._get_old_entry = function(l_7_0)
  if SystemInfo:platform() ~= Idstring("WIN32") or not l_7_0._peer:user_id() then
    local peer_ident = l_7_0._peer:name()
  end
  local old_plr_entry = managers.network:game()._old_players[peer_ident]
  local member_downed = nil
  local health = 1
  local used_deployable = false
  local member_dead = nil
  if old_plr_entry and Application:time() < old_plr_entry.t + 180 then
    member_downed = old_plr_entry.member_downed
    health = old_plr_entry.health
    used_deployable = old_plr_entry.used_deployable
    member_dead = old_plr_entry.member_dead
  end
  return member_downed, member_dead, health, used_deployable, old_plr_entry
end

NetworkMember.spawn_unit = function(l_8_0, l_8_1, l_8_2, l_8_3)
  if l_8_0._unit then
    return 
  end
  if not l_8_0._peer:synched() then
    return 
  end
  local peer_id = l_8_0._peer:id()
  l_8_0._spawn_unit_called = true
  local pos_rot = nil
  if l_8_2 then
    local spawn_on = nil
    if Global.local_member and alive(Global.local_member:unit()) then
      spawn_on = Global.local_member:unit()
    end
    if not spawn_on then
      local u_key, u_data = next(managers.groupai:state():all_char_criminals())
      if u_data and alive(u_data.unit) then
        spawn_on = u_data.unit
      end
    end
    if spawn_on then
      local pos = spawn_on:position()
      local rot = spawn_on:rotation()
      pos_rot = {pos, rot}
    else
      if not managers.network:game():get_next_spawn_point() then
        local spawn_point = managers.network:spawn_point(1)
      end
      pos_rot = spawn_point.pos_rot
    else
      pos_rot = managers.network:spawn_point(l_8_1).pos_rot
    end
    local member_downed, member_dead, health, used_deployable, old_plr_entry = l_8_0:_get_old_entry()
    if old_plr_entry then
      old_plr_entry.member_downed = nil
      old_plr_entry.member_dead = nil
    end
    local character_name = (l_8_0:character_name())
    local trade_entry, spawn_in_custody = nil, nil
    print("[NetworkMember:spawn_unit] Member assigned as", character_name)
    local old_unit = nil
    trade_entry, old_unit = managers.groupai:state():remove_one_teamAI(character_name, member_downed or member_dead)
    if trade_entry and member_dead then
      trade_entry.peer_id = peer_id
    end
    local has_old_unit = alive(old_unit)
    local ai_is_downed = false
    if alive(old_unit) then
      if not old_unit:character_damage():bleed_out() and not old_unit:character_damage():fatal() and not old_unit:character_damage():arrested() and not old_unit:character_damage():need_revive() then
        ai_is_downed = old_unit:character_damage():dead()
      end
      World:delete_unit(old_unit)
    end
    if (member_downed or member_dead) and not trade_entry and not ai_is_downed then
      if not trade_entry then
        spawn_in_custody = not has_old_unit
      else
        spawn_in_custody = false
      end
      if Global.level_data and Global.level_data.level_id then
        local lvl_tweak_data = tweak_data.levels[Global.level_data.level_id]
      end
      local unit_name_suffix = lvl_tweak_data and lvl_tweak_data.unit_suit or "suit"
      local unit_name = (Idstring(tweak_data.blackmarket.characters[l_8_0._peer:character_id()].fps_unit))
      do
        local unit = nil
        if l_8_0 == Global.local_member then
          unit = World:spawn_unit(unit_name, pos_rot[1], pos_rot[2])
        else
          unit = Network:spawn_unit_on_client(l_8_0._peer:rpc(), unit_name, pos_rot[1], pos_rot[2])
          local suspicion_mul, max_index = managers.blackmarket:get_suspicion_of_peer(l_8_0._peer)
          unit:base():set_suspicion_multiplier("equipment", suspicion_mul)
          unit:base():set_detection_multiplier("equipment", 1 / suspicion_mul)
        end
        l_8_0:set_unit(unit, character_name)
        managers.network:session():send_to_peers_synched("set_unit", unit, character_name, l_8_0._peer:profile().outfit_string, peer_id)
        if l_8_2 then
          l_8_0._peer:set_used_deployable(used_deployable)
          if l_8_0 == Global.local_member then
            managers.player:spawn_dropin_penalty(spawn_in_custody, spawn_in_custody, health, used_deployable)
          else
            l_8_0._peer:send_queued_sync("spawn_dropin_penalty", spawn_in_custody, spawn_in_custody, health, used_deployable)
          end
        end
        return unit
      end
       -- Warning: missing end command somewhere! Added here
    end
     -- Warning: missing end command somewhere! Added here
  end
end

NetworkMember.set_unit = function(l_9_0, l_9_1, l_9_2)
  do
    local is_new_unit = not l_9_1 or not l_9_0._unit or l_9_0._unit:key() ~= l_9_1:key()
    l_9_0._unit = l_9_1
    if is_new_unit and l_9_0 == Global.local_member then
      managers.player:spawned_player(1, l_9_1)
    end
    if SystemInfo:platform() == Idstring("PS3") and is_new_unit and l_9_0 ~= Global.local_member and l_9_1:inventory() then
      l_9_1:inventory():add_peer_blackmarket_outfit(l_9_0:peer())
    end
    if l_9_1 then
      if managers.criminals:character_peer_id_by_name(l_9_2) == l_9_0._peer:id() then
        managers.criminals:set_unit(l_9_2, l_9_1)
      else
        if managers.criminals:is_taken(l_9_2) then
          managers.criminals:remove_character_by_name(l_9_2)
        end
        managers.criminals:add_character(l_9_2, l_9_1, l_9_0._peer:id(), false)
      end
    end
    if is_new_unit then
      if l_9_1:damage() then
        local sequence = managers.blackmarket:character_sequence_by_character_id(l_9_0._peer:character_id(), l_9_0._peer:id())
        l_9_1:damage():run_sequence_simple(sequence)
        l_9_1:damage():run_sequence_simple(tweak_data.blackmarket.armors[l_9_0._peer:armor_id()].sequence)
        managers.game_play_central:change_contour_material_by_unit(l_9_1)
      end
      l_9_1:movement():set_character_anim_variables()
  end
  if l_9_0 ~= Global.local_member then
    end
  end
end

NetworkMember.sync_lobby_data = function(l_10_0, l_10_1)
  print("[NetworkMember:sync_lobby_data] to", l_10_1:id())
  local local_peer = managers.network:session():local_peer()
  local peer_id = local_peer:id()
  local level = managers.experience:current_level()
  local character = local_peer:character()
  local mask_set = "remove"
  local progress = managers.upgrades:progress()
  local menu_state = managers.menu:get_peer_state(local_peer:id())
  local menu_state_index = tweak_data:menu_sync_state_to_index(menu_state)
  cat_print("multiplayer_base", "NetworkMember:sync_lobby_data to", l_10_1:id(), " : ", peer_id, level)
  local_peer:set_outfit_string(managers.blackmarket:outfit_string())
  l_10_1:send_after_load("lobby_info", peer_id, level, character, mask_set, progress[1], progress[2], progress[3], progress[4] or -1)
  l_10_1:send_after_load("sync_profile", level)
  l_10_1:send_after_load("sync_outfit", managers.blackmarket:outfit_string())
  if menu_state_index then
    l_10_1:send_after_load("set_menu_sync_state_index", menu_state_index)
  end
  if Network:is_server() then
    local level_id_index = tweak_data.levels:get_index_from_level_id(Global.game_settings.level_id)
    l_10_1:send_after_load("lobby_sync_update_level_id", level_id_index)
    local difficulty = Global.game_settings.difficulty
    l_10_1:send_after_load("lobby_sync_update_difficulty", difficulty)
  end
end

NetworkMember.sync_data = function(l_11_0, l_11_1)
  print("[NetworkMember:sync_data] to", l_11_1:id())
  do
    local level = managers.experience:current_level()
    l_11_1:send_after_load("sync_profile", level)
    l_11_1:send_after_load("sync_outfit", managers.blackmarket:outfit_string())
    managers.player:update_deployable_equipment_to_peer(l_11_1)
    managers.player:update_cable_ties_to_peer(l_11_1)
    managers.player:update_perks_to_peer(l_11_1)
    managers.player:update_equipment_possession_to_peer(l_11_1)
    managers.player:update_ammo_info_to_peer(l_11_1)
    managers.player:update_carry_to_peer(l_11_1)
    managers.player:update_team_upgrades_to_peer(l_11_1)
  end
  if l_11_0._unit then
     -- Warning: missing end command somewhere! Added here
  end
end

NetworkMember.spawn_unit_called = function(l_12_0)
  return l_12_0._spawn_unit_called
end

NetworkMember.drop_in_progress = function(l_13_0)
  return l_13_0._dropin_progress
end

NetworkMember.set_drop_in_progress = function(l_14_0, l_14_1)
  l_14_0._dropin_progress = l_14_1
end

NetworkMember.character_name = function(l_15_0)
  return l_15_0._peer:character()
end


