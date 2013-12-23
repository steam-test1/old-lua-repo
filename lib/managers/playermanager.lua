-- Decompiled using luadec 2.0.1 by sztupy (http://winmo.sztupy.hu)
-- Command line was: F:\SteamLibrary\SteamApps\common\PAYDAY 2\lua\lib\managers\playermanager.luac 

if not PlayerManager then
  PlayerManager = class()
end
PlayerManager.WEAPON_SLOTS = 2
PlayerManager.init = function(l_1_0)
  l_1_0._player_name = Idstring("units/multiplayer/mp_fps_mover/mp_fps_mover")
  l_1_0._players = {}
  l_1_0._nr_players = Global.nr_players or 1
  l_1_0._last_id = 1
  l_1_0._viewport_configs = {}
  l_1_0._viewport_configs[1] = {}
  l_1_0._viewport_configs[1][1] = {dimensions = {x = 0, y = 0, w = 1, h = 1}}
  l_1_0._viewport_configs[2] = {}
  l_1_0._viewport_configs[2][1] = {dimensions = {x = 0, y = 0, w = 1, h = 0.5}}
  l_1_0._viewport_configs[2][2] = {dimensions = {x = 0, y = 0.5, w = 1, h = 0.5}}
  l_1_0:_setup_rules()
  l_1_0._local_player_minions = 0
  {standard = "ingame_standard", mask_off = "ingame_mask_off"}.bleed_out = "ingame_bleed_out"
   -- DECOMPILER ERROR: Confused about usage of registers!

  {standard = "ingame_standard", mask_off = "ingame_mask_off"}.fatal = "ingame_fatal"
   -- DECOMPILER ERROR: Confused about usage of registers!

  {standard = "ingame_standard", mask_off = "ingame_mask_off"}.arrested = "ingame_arrested"
   -- DECOMPILER ERROR: Confused about usage of registers!

  {standard = "ingame_standard", mask_off = "ingame_mask_off"}.tased = "ingame_electrified"
   -- DECOMPILER ERROR: Confused about usage of registers!

  {standard = "ingame_standard", mask_off = "ingame_mask_off"}.incapacitated = "ingame_incapacitated"
   -- DECOMPILER ERROR: Confused about usage of registers!

  {standard = "ingame_standard", mask_off = "ingame_mask_off"}.clean = "ingame_clean"
   -- DECOMPILER ERROR: Confused about usage of registers!

  {standard = "ingame_standard", mask_off = "ingame_mask_off"}.carry = "ingame_standard"
   -- DECOMPILER ERROR: Confused about usage of registers!

  l_1_0._player_states = {standard = "ingame_standard", mask_off = "ingame_mask_off"}
  l_1_0._DEFAULT_STATE = "mask_off"
  l_1_0._current_state = l_1_0._DEFAULT_STATE
  l_1_0._sync_states = {"clean", "mask_off", "standard"}
  l_1_0._current_sync_state = l_1_0._DEFAULT_STATE
  local ids_player = Idstring("player")
  if not TimerManager:timer(ids_player) then
    l_1_0._player_timer = TimerManager:make_timer(ids_player, TimerManager:pausable())
  end
  l_1_0:_setup()
end

PlayerManager._setup = function(l_2_0)
  l_2_0._equipment = {selections = {}, specials = {}, selected_index = nil}
  l_2_0._listener_holder = EventListenerHolder:new()
  l_2_0._player_mesh_suffix = ""
  l_2_0._temporary_upgrades = {}
  if not Global.player_manager then
    Global.player_manager = {}
    Global.player_manager.upgrades = {}
    Global.player_manager.team_upgrades = {}
    Global.player_manager.weapons = {}
    Global.player_manager.equipment = {}
    Global.player_manager.kit = {weapon_slots = {"glock_17"}, equipment_slots = {}, special_equipment_slots = {}}
  end
  Global.player_manager.default_kit = {weapon_slots = {"glock_17"}, equipment_slots = {}, special_equipment_slots = {"cable_tie"}}
  Global.player_manager.synced_bonuses = {}
  Global.player_manager.synced_equipment_possession = {}
  Global.player_manager.synced_deployables = {}
  Global.player_manager.synced_cable_ties = {}
  Global.player_manager.synced_perks = {}
  Global.player_manager.synced_ammo_info = {}
  Global.player_manager.synced_carry = {}
  Global.player_manager.synced_team_upgrades = {}
  l_2_0._global = Global.player_manager
end

PlayerManager._setup_rules = function(l_3_0)
  l_3_0._rules = {no_run = 0}
end

PlayerManager.aquire_default_upgrades = function(l_4_0)
  managers.upgrades:aquire_default("cable_tie")
  managers.upgrades:aquire_default("player_special_enemy_highlight")
  managers.upgrades:aquire_default("player_hostage_trade")
  managers.upgrades:aquire_default("player_sec_camera_highlight")
  for i = 1, PlayerManager.WEAPON_SLOTS do
    if not managers.player:weapon_in_slot(i) then
      l_4_0._global.kit.weapon_slots[i] = managers.player:availible_weapons(i)[1]
    end
  end
  l_4_0:_verify_equipment_kit()
end

PlayerManager.update_kit_to_peer = function(l_5_0, l_5_1)
  local peer_id = managers.network:session():local_peer():id()
  for i = 1, PlayerManager.WEAPON_SLOTS do
    local weapon = l_5_0:weapon_in_slot(i)
    if weapon then
      l_5_1:send_after_load("set_kit_selection", peer_id, "weapon", weapon, i)
    end
  end
  for i = 1, 3 do
    local equipment = l_5_0:equipment_in_slot(i)
    if equipment then
      l_5_1:send_after_load("set_kit_selection", peer_id, "equipment", equipment, i)
    end
  end
end

PlayerManager.update = function(l_6_0, l_6_1, l_6_2)
end

PlayerManager.add_listener = function(l_7_0, l_7_1, l_7_2, l_7_3)
  l_7_0._listener_holder:add(l_7_1, l_7_2, l_7_3)
end

PlayerManager.remove_listener = function(l_8_0, l_8_1)
  l_8_0._listener_holder:remove(l_8_1)
end

PlayerManager.preload = function(l_9_0)
end

PlayerManager._internal_load = function(l_10_0)
  local player = l_10_0:player_unit()
  if not player then
    return 
  end
  local secondary = managers.blackmarket:equipped_secondary()
  player:inventory():add_unit_by_factory_name(secondary.factory_id, true, false, secondary.blueprint)
  do
    local primary = managers.blackmarket:equipped_primary()
    if primary then
      player:inventory():add_unit_by_factory_name(primary.factory_id, false, false, primary.blueprint)
    end
    if l_10_0._respawn then
      do return end
    end
    l_10_0:_add_level_equipment(player)
    for i,name in ipairs(l_10_0._global.default_kit.special_equipment_slots) do
      local ok_name = not l_10_0._global.equipment[name] or name
      if ok_name then
        local upgrade = tweak_data.upgrades.definitions[ok_name]
        if (upgrade.slot and upgrade.slot < 2) or not upgrade.slot then
          l_10_0:add_equipment({equipment = upgrade.equipment_id, silent = true})
        end
      end
    end
    for i,name in ipairs(l_10_0._global.kit.equipment_slots) do
      if not l_10_0._global.equipment[name] or not name then
        local ok_name = l_10_0._global.default_kit.equipment_slots[i]
      end
      if ok_name then
        local upgrade = tweak_data.upgrades.definitions[ok_name]
        if upgrade then
          if (upgrade.slot and upgrade.slot < 2) or not upgrade.slot then
            l_10_0:add_equipment({equipment = upgrade.equipment_id, silent = true})
            for (for control),i in (for generator) do
            end
            if upgrade.slot and upgrade.slot == 2 then
              managers.hud:set_perk_equipment(HUDManager.PLAYER_PANEL, upgrade)
              l_10_0:update_synced_perks_to_peers(ok_name)
            end
          end
        end
      end
    end
     -- Warning: missing end command somewhere! Added here
  end
end

PlayerManager._add_level_equipment = function(l_11_0, l_11_1)
  if Global.running_simulation then
    local id = managers.editor:layer("Level Settings"):get_setting("simulation_level_id")
  end
  if id == "none" or not id then
    id = nil
  end
  if not id then
    id = Global.level_data.level_id
  end
  if not id then
    return 
  end
  local equipment = tweak_data.levels[id].equipment
  if not equipment then
    return 
  end
  for _,eq in ipairs(equipment) do
    l_11_0:add_equipment({equipment = eq, silent = true})
  end
end

PlayerManager.spawn_dropin_penalty = function(l_12_0, l_12_1, l_12_2, l_12_3, l_12_4)
  local player = l_12_0:player_unit()
  print("[PlayerManager:spawn_dropin_penalty]", l_12_1, l_12_2, l_12_3)
  if not alive(player) then
    return 
  end
  if l_12_4 then
    managers.player:clear_equipment()
  end
  local min_health = nil
  if l_12_1 or l_12_2 then
    min_health = 0
  else
    min_health = 0.25
  end
  player:character_damage():set_health(math.max(min_health, l_12_3) * player:character_damage():_max_health())
  player:inventory():set_ammo(0.5)
  if l_12_1 or l_12_2 then
    print("[PlayerManager:spawn_dead] Killing")
    managers.groupai:state():on_player_criminal_death(Global.local_member:peer():id())
    player:base():set_enabled(false)
    game_state_machine:change_state_by_name("ingame_waiting_for_respawn")
    player:character_damage():set_invulnerable(true)
    player:base():_unregister()
    player:base():set_slot(player, 0)
  end
end

PlayerManager.nr_players = function(l_13_0)
  return l_13_0._nr_players
end

PlayerManager.set_nr_players = function(l_14_0, l_14_1)
  l_14_0._nr_players = l_14_1
end

PlayerManager.player_id = function(l_15_0, l_15_1)
  local id = l_15_0._last_id
  for k,player in ipairs(l_15_0._players) do
    if player == l_15_1 then
      id = k
    end
  end
  return id
end

PlayerManager.viewport_config = function(l_16_0)
  local configs = l_16_0._viewport_configs[l_16_0._last_id]
  if configs then
    return configs[1]
  end
end

PlayerManager.setup_viewports = function(l_17_0)
  local configs = l_17_0._viewport_configs[l_17_0._last_id]
  if configs then
    for k,player in ipairs(l_17_0._players) do
    end
  else
    Application:error("Unsupported number of players: " .. tostring(l_17_0._last_id))
  end
end

PlayerManager.player_states = function(l_18_0)
  local ret = {}
  for k,_ in pairs(l_18_0._player_states) do
    table.insert(ret, k)
  end
  return ret
end

PlayerManager.current_state = function(l_19_0)
  return l_19_0._current_state
end

PlayerManager.default_player_state = function(l_20_0)
  return l_20_0._DEFAULT_STATE
end

PlayerManager.set_player_state = function(l_21_0, l_21_1)
  if not l_21_1 then
    l_21_1 = l_21_0._current_state
  end
  if l_21_1 == "standard" and l_21_0:get_my_carry_data() then
    l_21_1 = "carry"
  end
  if l_21_1 == l_21_0._current_state then
    return 
  end
  if not l_21_0._player_states[l_21_1] then
    Application:error("State '" .. tostring(l_21_1) .. "' does not exist in list of available states.")
    l_21_1 = l_21_0._DEFAULT_STATE
  end
  if table.contains(l_21_0._sync_states, l_21_1) then
    l_21_0._current_sync_state = l_21_1
  end
  l_21_0._current_state = l_21_1
  l_21_0:_change_player_state()
  if l_21_1 == "clean" or l_21_1 == "mask_off" then
    managers.groupai:state():calm_ai()
  end
end

PlayerManager.spawn_players = function(l_22_0, l_22_1, l_22_2, l_22_3)
  for var = 1, l_22_0._nr_players do
    l_22_0._last_id = var
  end
  l_22_0:spawned_player(l_22_0._last_id, safe_spawn_unit(l_22_0:player_unit_name(), l_22_1, l_22_2))
  return l_22_0._players[1]
end

PlayerManager.spawned_player = function(l_23_0, l_23_1, l_23_2)
  l_23_0._players[l_23_1] = l_23_2
  l_23_0:setup_viewports()
  l_23_0:_internal_load()
  l_23_0:_change_player_state()
end

PlayerManager._change_player_state = function(l_24_0)
  local unit = l_24_0:player_unit()
  if not unit then
    return 
  end
  l_24_0._listener_holder:call(l_24_0._current_state, unit)
  if game_state_machine:last_queued_state_name() ~= l_24_0._player_states[l_24_0._current_state] then
    game_state_machine:change_state_by_name(l_24_0._player_states[l_24_0._current_state])
  end
  unit:movement():change_state(l_24_0._current_state)
end

PlayerManager.player_destroyed = function(l_25_0, l_25_1)
  l_25_0._players[l_25_1] = nil
  l_25_0._respawn = true
end

PlayerManager.players = function(l_26_0)
  return l_26_0._players
end

PlayerManager.player_unit_name = function(l_27_0)
  return l_27_0._player_name
end

PlayerManager.player_unit = function(l_28_0, l_28_1)
  local p_id = l_28_1 or 1
  return l_28_0._players[p_id]
end

PlayerManager.warp_to = function(l_29_0, l_29_1, l_29_2, l_29_3)
  local player = l_29_0._players[l_29_3 or 1]
  if alive(player) then
    player:movement():warp_to(l_29_1, l_29_2)
  end
end

PlayerManager.on_out_of_world = function(l_30_0)
  local player_unit = managers.player:player_unit()
  if not alive(player_unit) then
    return 
  end
  local player_pos = (player_unit:position())
  local closest_pos, closest_distance = nil, nil
  for _,data in pairs(managers.groupai:state():all_player_criminals()) do
    if data.unit ~= player_unit then
      local pos = data.unit:position()
      local distance = mvector3.distance(player_pos, pos)
      if not closest_distance or distance < closest_distance then
        closest_distance = distance
        closest_pos = pos
      end
    end
  end
  if closest_pos then
    managers.player:warp_to(closest_pos, player_unit:rotation())
    return 
  end
  local pos = player_unit:movement():nav_tracker():field_position()
  managers.player:warp_to(pos, player_unit:rotation())
end

PlayerManager.aquire_weapon = function(l_31_0, l_31_1, l_31_2)
  if l_31_0._global.weapons[l_31_2] then
    return 
  end
  l_31_0._global.weapons[l_31_2] = l_31_1
  local player = l_31_0:player_unit()
  if not player then
    return 
  end
end

PlayerManager.unaquire_weapon = function(l_32_0, l_32_1, l_32_2)
  l_32_0._global.weapons[l_32_2] = l_32_1
end

PlayerManager._verify_equipment_kit = function(l_33_0)
  for i = 1, 3 do
    if not managers.player:equipment_in_slot(i) then
      l_33_0._global.kit.equipment_slots[i] = managers.player:availible_equipment(i)[1]
    end
  end
end

PlayerManager.aquire_equipment = function(l_34_0, l_34_1, l_34_2)
  if l_34_0._global.equipment[l_34_2] then
    return 
  end
  l_34_0._global.equipment[l_34_2] = l_34_1
  if l_34_1.aquire then
    managers.upgrades:aquire_default(l_34_1.aquire.upgrade)
  end
  l_34_0:_verify_equipment_kit()
end

PlayerManager.unaquire_equipment = function(l_35_0, l_35_1, l_35_2)
  if not l_35_0._global.equipment[l_35_2] then
    return 
  end
  local is_equipped = managers.player:equipment_in_slot(l_35_1.slot) == l_35_2
  l_35_0._global.equipment[l_35_2] = nil
  if is_equipped then
    l_35_0._global.kit.equipment_slots[l_35_1.slot] = nil
    l_35_0:_verify_equipment_kit()
  end
  if l_35_1.aquire then
    managers.upgrades:unaquire(l_35_1.aquire.upgrade)
  end
end

PlayerManager.aquire_upgrade = function(l_36_0, l_36_1)
  if not l_36_0._global.upgrades[l_36_1.category] then
    l_36_0._global.upgrades[l_36_1.category] = {}
  end
  l_36_0._global.upgrades[l_36_1.category][l_36_1.upgrade] = l_36_1.value
  local value = tweak_data.upgrades.values[l_36_1.category][l_36_1.upgrade][l_36_1.value]
  if l_36_0[l_36_1.upgrade] then
    l_36_0[l_36_1.upgrade](l_36_0, value)
  end
end

PlayerManager.unaquire_upgrade = function(l_37_0, l_37_1)
  if not l_37_0._global.upgrades[l_37_1.category] then
    Application:error("[PlayerManager:unaquire_upgrade] Can't unaquire upgrade of category", l_37_1.category)
    return 
  end
  if not l_37_0._global.upgrades[l_37_1.category][l_37_1.upgrade] then
    Application:error("[PlayerManager:unaquire_upgrade] Can't unaquire upgrade", l_37_1.upgrade)
    return 
  end
  l_37_0:unaquire_incremental_upgrade(l_37_1)
end

PlayerManager.aquire_incremental_upgrade = function(l_38_0, l_38_1)
  if not l_38_0._global.upgrades[l_38_1.category] then
    l_38_0._global.upgrades[l_38_1.category] = {}
  end
  local val = l_38_0._global.upgrades[l_38_1.category][l_38_1.upgrade]
  l_38_0._global.upgrades[l_38_1.category][l_38_1.upgrade] = (val or 0) + 1
  local value = tweak_data.upgrades.values[l_38_1.category][l_38_1.upgrade][l_38_0._global.upgrades[l_38_1.category][l_38_1.upgrade]]
  if l_38_0[l_38_1.upgrade] then
    l_38_0[l_38_1.upgrade](l_38_0, value)
  end
end

PlayerManager.unaquire_incremental_upgrade = function(l_39_0, l_39_1)
  if not l_39_0._global.upgrades[l_39_1.category] then
    Application:error("[PlayerManager:unaquire_incremental_upgrade] Can't unaquire upgrade of category", l_39_1.category)
    return 
  end
  if not l_39_0._global.upgrades[l_39_1.category][l_39_1.upgrade] then
    Application:error("[PlayerManager:unaquire_incremental_upgrade] Can't unaquire upgrade", l_39_1.upgrade)
    return 
  end
  local val = l_39_0._global.upgrades[l_39_1.category][l_39_1.upgrade]
  val = val - 1
  l_39_0._global.upgrades[l_39_1.category][l_39_1.upgrade] = val > 0 and val or nil
  if l_39_0._global.upgrades[l_39_1.category][l_39_1.upgrade] then
    local value = tweak_data.upgrades.values[l_39_1.category][l_39_1.upgrade][l_39_0._global.upgrades[l_39_1.category][l_39_1.upgrade]]
    if l_39_0[l_39_1.upgrade] then
      l_39_0[l_39_1.upgrade](l_39_0, value)
    end
  end
end

PlayerManager.upgrade_value = function(l_40_0, l_40_1, l_40_2, l_40_3)
  return l_40_0._global.upgrades[l_40_1] or l_40_3 or 0
  return l_40_0._global.upgrades[l_40_1][l_40_2] or l_40_3 or 0
  local level = l_40_0._global.upgrades[l_40_1][l_40_2]
  local value = tweak_data.upgrades.values[l_40_1][l_40_2][level]
  return value
end

PlayerManager.activate_temporary_upgrade = function(l_41_0, l_41_1, l_41_2)
  local upgrade_value = l_41_0:upgrade_value(l_41_1, l_41_2)
  if upgrade_value == 0 then
    return 
  end
  local time = upgrade_value[2]
  if not l_41_0._temporary_upgrades[l_41_1] then
    l_41_0._temporary_upgrades[l_41_1] = {}
  end
  l_41_0._temporary_upgrades[l_41_1][l_41_2] = {}
  l_41_0._temporary_upgrades[l_41_1][l_41_2].expire_time = Application:time() + time
end

PlayerManager.has_activate_temporary_upgrade = function(l_42_0, l_42_1, l_42_2)
  local upgrade_value = l_42_0:upgrade_value(l_42_1, l_42_2)
  if upgrade_value == 0 then
    return false
  end
  if not l_42_0._temporary_upgrades[l_42_1] then
    return false
  end
  if not l_42_0._temporary_upgrades[l_42_1][l_42_2] then
    return false
  end
  return Application:time() < l_42_0._temporary_upgrades[l_42_1][l_42_2].expire_time
end

PlayerManager.temporary_upgrade_value = function(l_43_0, l_43_1, l_43_2, l_43_3)
  local upgrade_value = l_43_0:upgrade_value(l_43_1, l_43_2)
  if not l_43_3 then
    return upgrade_value ~= 0 or 0
  end
  return l_43_0._temporary_upgrades[l_43_1] or l_43_3 or 0
  return l_43_0._temporary_upgrades[l_43_1][l_43_2] or l_43_3 or 0
  if not l_43_3 then
    return l_43_0._temporary_upgrades[l_43_1][l_43_2].expire_time >= Application:time() or 0
  end
  return upgrade_value[1]
end

PlayerManager.equiptment_upgrade_value = function(l_44_0, l_44_1, l_44_2, l_44_3)
  if l_44_1 == "trip_mine" and l_44_2 == "quantity" then
    return l_44_0:upgrade_value(l_44_1, "quantity_1", l_44_3) + l_44_0:upgrade_value(l_44_1, "quantity_2", l_44_3) + l_44_0:upgrade_value(l_44_1, "quantity_3", l_44_3)
  end
  return l_44_0:upgrade_value(l_44_1, l_44_2, l_44_3)
end

PlayerManager.upgrade_level = function(l_45_0, l_45_1, l_45_2, l_45_3)
  return l_45_0._global.upgrades[l_45_1] or l_45_3 or 0
  return l_45_0._global.upgrades[l_45_1][l_45_2] or l_45_3 or 0
  local level = l_45_0._global.upgrades[l_45_1][l_45_2]
  return level
end

PlayerManager.upgrade_value_by_level = function(l_46_0, l_46_1, l_46_2, l_46_3, l_46_4)
  return tweak_data.upgrades.values[l_46_1][l_46_2][l_46_3] or l_46_4 or 0
end

PlayerManager.equipped_upgrade_value = function(l_47_0, l_47_1, l_47_2, l_47_3)
  if not l_47_0:has_category_upgrade(l_47_2, l_47_3) then
    return 0
  end
  if not table.contains(l_47_0._global.kit.equipment_slots, l_47_1) then
    return 0
  end
  return l_47_0:upgrade_value(l_47_2, l_47_3)
end

PlayerManager.has_category_upgrade = function(l_48_0, l_48_1, l_48_2)
  if not l_48_0._global.upgrades[l_48_1] then
    return false
  end
  if not l_48_0._global.upgrades[l_48_1][l_48_2] then
    return false
  end
  return true
end

PlayerManager.body_armor_value = function(l_49_0)
  local armor_data = tweak_data.blackmarket.armors[managers.blackmarket:equipped_armor()]
  return l_49_0:upgrade_value_by_level("player", "body_armor", armor_data.upgrade_level, 0)
end

PlayerManager.body_armor_movement_penalty = function(l_50_0)
  local armor_data = tweak_data.blackmarket.armors[managers.blackmarket:equipped_armor()]
  return l_50_0:upgrade_value_by_level("player", "armor_movement_penalty", armor_data.movement_penalty, 1)
end

PlayerManager.thick_skin_value = function(l_51_0)
  if not l_51_0:has_category_upgrade("player", "thick_skin") then
    return 0
  end
  if not table.contains(l_51_0._global.kit.equipment_slots, "thick_skin") then
    return 0
  end
  return l_51_0:upgrade_value("player", "thick_skin")
end

PlayerManager.toolset_value = function(l_52_0)
  if not l_52_0:has_category_upgrade("player", "toolset") then
    return 1
  end
  if not table.contains(l_52_0._global.kit.equipment_slots, "toolset") then
    return 1
  end
  return l_52_0:upgrade_value("player", "toolset")
end

PlayerManager.inspect_current_upgrades = function(l_53_0)
  for name,upgrades in pairs(l_53_0._global.upgrades) do
    print("Weapon " .. name .. ":")
    for upgrade,level in pairs(upgrades) do
      print("Upgrade:", upgrade, "is at level", level, "and has value", string.format("%.2f", tweak_data.upgrades.values[name][upgrade][level]))
    end
    print("\n")
  end
end

PlayerManager.spread_multiplier = function(l_54_0)
  if not alive(l_54_0:player_unit()) then
    return 
  end
  l_54_0:player_unit():movement()._current_state:_update_crosshair_offset()
end

PlayerManager.weapon_upgrade_progress = function(l_55_0, l_55_1)
  local current = 0
  local total = 0
  if l_55_0._global.upgrades[l_55_1] then
    for upgrade,value in pairs(l_55_0._global.upgrades[l_55_1]) do
      current = current + value
    end
  end
  if tweak_data.upgrades.values[l_55_1] then
    for _,values in pairs(tweak_data.upgrades.values[l_55_1]) do
      total = total + #values
    end
  end
  return current, total
end

PlayerManager.equipment_upgrade_progress = function(l_56_0, l_56_1)
  local current = 0
  local total = 0
  if tweak_data.upgrades.values[l_56_1] then
    if l_56_0._global.upgrades[l_56_1] then
      for upgrade,value in pairs(l_56_0._global.upgrades[l_56_1]) do
        current = current + value
      end
    end
    for _,values in pairs(tweak_data.upgrades.values[l_56_1]) do
      total = total + #values
    end
    return current, total
  end
  if tweak_data.upgrades.values.player[l_56_1] then
    if l_56_0._global.upgrades.player and l_56_0._global.upgrades.player[l_56_1] then
      current = l_56_0._global.upgrades.player[l_56_1]
    end
    total = #tweak_data.upgrades.values.player[l_56_1]
    return current, total
  end
  if tweak_data.upgrades.definitions[l_56_1] and tweak_data.upgrades.definitions[l_56_1].aquire then
    local upgrade = tweak_data.upgrades.definitions[tweak_data.upgrades.definitions[l_56_1].aquire.upgrade]
    return l_56_0:equipment_upgrade_progress(upgrade.upgrade.upgrade)
  end
  return current, total
end

PlayerManager.has_weapon = function(l_57_0, l_57_1)
  return managers.player._global.weapons[l_57_1]
end

PlayerManager.has_aquired_equipment = function(l_58_0, l_58_1)
  return managers.player._global.equipment[l_58_1]
end

PlayerManager.availible_weapons = function(l_59_0, l_59_1)
  local weapons = {}
  for name,_ in pairs(managers.player._global.weapons) do
    if not l_59_1 or l_59_1 and tweak_data.weapon[name].use_data.selection_index == l_59_1 then
      table.insert(weapons, name)
    end
  end
  return weapons
end

PlayerManager.weapon_in_slot = function(l_60_0, l_60_1)
  local weapon = l_60_0._global.kit.weapon_slots[l_60_1]
  if l_60_0._global.weapons[weapon] then
    return weapon
  end
  local weapon = l_60_0._global.default_kit.weapon_slots[l_60_1]
  return not l_60_0._global.weapons[weapon] or weapon
end

PlayerManager.availible_equipment = function(l_61_0, l_61_1)
  local equipment = {}
  for name,_ in pairs(l_61_0._global.equipment) do
    if not l_61_1 or l_61_1 and tweak_data.upgrades.definitions[name].slot == l_61_1 then
      table.insert(equipment, name)
    end
  end
  return equipment
end

PlayerManager.equipment_in_slot = function(l_62_0, l_62_1)
  return l_62_0._global.kit.equipment_slots[l_62_1]
end

PlayerManager.toggle_player_rule = function(l_63_0, l_63_1)
  l_63_0._rules[l_63_1] = not l_63_0._rules[l_63_1]
  if l_63_1 == "no_run" and l_63_0._rules[l_63_1] then
    local player = l_63_0:player_unit()
    if player:movement():current_state()._interupt_action_running then
      player:movement():current_state():_interupt_action_running(Application:time())
    end
  end
end

PlayerManager.set_player_rule = function(l_64_0, l_64_1, l_64_2)
  l_64_0._rules[l_64_1] = l_64_0._rules[l_64_1] + (l_64_2 and 1 or -1)
  if l_64_1 == "no_run" and l_64_0:get_player_rule(l_64_1) then
    local player = l_64_0:player_unit()
    if player:movement():current_state()._interupt_action_running then
      player:movement():current_state():_interupt_action_running(Application:time())
    end
  end
end

PlayerManager.get_player_rule = function(l_65_0, l_65_1)
  return l_65_0._rules[l_65_1] > 0
end

PlayerManager.update_deployable_equipment_to_peer = function(l_66_0, l_66_1)
  local peer_id = managers.network:session():local_peer():id()
  if l_66_0._global.synced_deployables[peer_id] then
    local deployable = l_66_0._global.synced_deployables[peer_id].deployable
    local amount = l_66_0._global.synced_deployables[peer_id].amount
    l_66_1:send_after_load("sync_deployable_equipment", peer_id, deployable, amount)
  end
end

PlayerManager.update_deployable_equipment_amount_to_peers = function(l_67_0, l_67_1, l_67_2)
  local peer_id = managers.network:session():local_peer():id()
  managers.network:session():send_to_peers("sync_deployable_equipment", peer_id, l_67_1, l_67_2)
  l_67_0:set_synced_deployable_equipment(peer_id, l_67_1, l_67_2)
end

PlayerManager.set_synced_deployable_equipment = function(l_68_0, l_68_1, l_68_2, l_68_3)
  local only_update_amount = not l_68_0._global.synced_deployables[l_68_1] or l_68_0._global.synced_deployables[l_68_1].deployable == l_68_2
  l_68_0._global.synced_deployables[l_68_1] = {deployable = l_68_2, amount = l_68_3}
  local character_data = managers.criminals:character_data_by_peer_id(l_68_1)
  if character_data and character_data.panel_id then
    local icon = tweak_data.equipments[l_68_2].icon
    if only_update_amount then
      managers.hud:set_teammate_deployable_equipment_amount(character_data.panel_id, 1, {icon = icon, amount = l_68_3})
    else
      managers.hud:set_deployable_equipment(character_data.panel_id, {icon = icon, amount = l_68_3})
    end
  end
  local local_peer_id = managers.network:session():local_peer():id()
  if l_68_1 ~= local_peer_id and managers.network:game():member(l_68_1) then
    local unit = managers.network:game():member(l_68_1):unit()
    if alive(unit) then
      unit:movement():set_visual_deployable_equipment(l_68_2, l_68_3)
    end
  end
end

PlayerManager.get_synced_deployable_equipment = function(l_69_0, l_69_1)
  return l_69_0._global.synced_deployables[l_69_1]
end

PlayerManager.update_cable_ties_to_peer = function(l_70_0, l_70_1)
  local peer_id = managers.network:session():local_peer():id()
  if l_70_0._global.synced_cable_ties[peer_id] then
    local amount = l_70_0._global.synced_cable_ties[peer_id].amount
    l_70_1:send_after_load("sync_cable_ties", peer_id, amount)
  end
end

PlayerManager.update_synced_cable_ties_to_peers = function(l_71_0, l_71_1)
  local peer_id = managers.network:session():local_peer():id()
  managers.network:session():send_to_peers("sync_cable_ties", peer_id, l_71_1)
  l_71_0:set_synced_cable_ties(peer_id, l_71_1)
end

PlayerManager.set_synced_cable_ties = function(l_72_0, l_72_1, l_72_2)
  local only_update_amount = false
  l_72_0._global.synced_cable_ties[l_72_1] = {amount = l_72_2}
  local character_data = managers.criminals:character_data_by_peer_id(l_72_1)
  if character_data and character_data.panel_id then
    local icon = tweak_data.equipments.specials.cable_tie.icon
    if only_update_amount then
      managers.hud:set_cable_ties_amount(character_data.panel_id, l_72_2)
    else
      managers.hud:set_cable_tie(character_data.panel_id, {icon = icon, amount = l_72_2})
    end
  end
end

PlayerManager.get_synced_cable_ties = function(l_73_0, l_73_1)
  return l_73_0._global.synced_cable_ties[l_73_1]
end

PlayerManager.update_perks_to_peer = function(l_74_0, l_74_1)
  local peer_id = managers.network:session():local_peer():id()
  if l_74_0._global.synced_perks[peer_id] then
    local perk = l_74_0._global.synced_perks[peer_id].perk
    l_74_1:send_after_load("sync_perk_equipment", peer_id, perk)
  end
end

PlayerManager.update_synced_perks_to_peers = function(l_75_0, l_75_1)
  local peer_id = managers.network:session():local_peer():id()
  managers.network:session():send_to_peers("sync_perk_equipment", peer_id, l_75_1)
  l_75_0:set_synced_perk(peer_id, l_75_1)
end

PlayerManager.set_synced_perk = function(l_76_0, l_76_1, l_76_2)
  l_76_0._global.synced_perks[l_76_1] = {perk = l_76_2}
  local character_data = managers.criminals:character_data_by_peer_id(l_76_1)
  if character_data and character_data.panel_id then
    local icon = tweak_data.upgrades.definitions[l_76_2].icon
    managers.hud:set_perk_equipment(character_data.panel_id, {icon = icon})
  end
end

PlayerManager.get_synced_perk = function(l_77_0, l_77_1)
  return l_77_0._global.synced_perks[l_77_1]
end

PlayerManager.update_ammo_info_to_peer = function(l_78_0, l_78_1)
  local peer_id = managers.network:session():local_peer():id()
  if l_78_0._global.synced_ammo_info[peer_id] then
    for selection_index,ammo_info in pairs(l_78_0._global.synced_ammo_info[peer_id]) do
      l_78_1:send_after_load("sync_ammo_amount", peer_id, selection_index, unpack(ammo_info))
    end
  end
end

PlayerManager.update_synced_ammo_info_to_peers = function(l_79_0, l_79_1, l_79_2, l_79_3, l_79_4, l_79_5)
  local peer_id = managers.network:session():local_peer():id()
  managers.network:session():send_to_peers_loaded("sync_ammo_amount", peer_id, l_79_1, l_79_2, l_79_3, l_79_4, l_79_5)
  l_79_0:set_synced_ammo_info(peer_id, l_79_1, l_79_2, l_79_3, l_79_4, l_79_5)
end

PlayerManager.set_synced_ammo_info = function(l_80_0, l_80_1, l_80_2, l_80_3, l_80_4, l_80_5, l_80_6)
  if not l_80_0._global.synced_ammo_info[l_80_1] then
    l_80_0._global.synced_ammo_info[l_80_1] = {}
  end
  l_80_0._global.synced_ammo_info[l_80_1][l_80_2] = {l_80_3, l_80_4, l_80_5, l_80_6}
  local character_data = managers.criminals:character_data_by_peer_id(l_80_1)
  if character_data and character_data.panel_id then
    managers.hud:set_teammate_ammo_amount(character_data.panel_id, l_80_2, l_80_3, l_80_4, l_80_5, l_80_6)
  end
end

PlayerManager.get_synced_ammo_info = function(l_81_0, l_81_1)
  return l_81_0._global.synced_ammo_info[l_81_1]
end

PlayerManager.update_carry_to_peer = function(l_82_0, l_82_1)
  local peer_id = managers.network:session():local_peer():id()
  if l_82_0._global.synced_carry[peer_id] then
    local carry_id = l_82_0._global.synced_carry[peer_id].carry_id
    local value = l_82_0._global.synced_carry[peer_id].value
    local dye_initiated = l_82_0._global.synced_carry[peer_id].dye_initiated
    local has_dye_pack = l_82_0._global.synced_carry[peer_id].has_dye_pack
    local dye_value_multiplier = l_82_0._global.synced_carry[peer_id].dye_value_multiplier
    l_82_1:send_after_load("sync_carry", peer_id, carry_id, value, dye_initiated, has_dye_pack, dye_value_multiplier)
  end
end

PlayerManager.update_synced_carry_to_peers = function(l_83_0, l_83_1, l_83_2, l_83_3, l_83_4, l_83_5)
  local peer_id = managers.network:session():local_peer():id()
  managers.network:session():send_to_peers("sync_carry", peer_id, l_83_1, l_83_2, l_83_3, l_83_4, l_83_5)
  l_83_0:set_synced_carry(peer_id, l_83_1, l_83_2, l_83_3, l_83_4, l_83_5)
end

PlayerManager.set_synced_carry = function(l_84_0, l_84_1, l_84_2, l_84_3, l_84_4, l_84_5, l_84_6)
  l_84_0._global.synced_carry[l_84_1] = {carry_id = l_84_2, value = l_84_3, dye_initiated = l_84_4, has_dye_pack = l_84_5, dye_value_multiplier = l_84_6}
  local character_data = managers.criminals:character_data_by_peer_id(l_84_1)
  if character_data and character_data.panel_id then
    managers.hud:set_teammate_carry_info(character_data.panel_id, l_84_2, managers.loot:get_real_value(l_84_2, l_84_3))
  end
  managers.hud:set_name_label_carry_info(l_84_1, l_84_2, managers.loot:get_real_value(l_84_2, l_84_3))
  local local_peer_id = managers.network:session():local_peer():id()
  if l_84_1 ~= local_peer_id and managers.network:game():member(l_84_1) then
    local unit = managers.network:game():member(l_84_1):unit()
    if alive(unit) then
      unit:movement():set_visual_carry(l_84_2)
    end
  end
end

PlayerManager.set_carry_approved = function(l_85_0, l_85_1)
  l_85_0._global.synced_carry[l_85_1:id()].approved = true
end

PlayerManager.update_removed_synced_carry_to_peers = function(l_86_0)
  local peer_id = managers.network:session():local_peer():id()
  managers.network:session():send_to_peers("sync_remove_carry", peer_id)
  l_86_0:remove_synced_carry(peer_id)
end

PlayerManager.remove_synced_carry = function(l_87_0, l_87_1)
  if not l_87_0._global.synced_carry[l_87_1] then
    return 
  end
  l_87_0._global.synced_carry[l_87_1] = nil
  local character_data = managers.criminals:character_data_by_peer_id(l_87_1)
  if character_data and character_data.panel_id then
    managers.hud:remove_teammate_carry_info(character_data.panel_id)
  end
  managers.hud:remove_name_label_carry_info(l_87_1)
  local local_peer_id = managers.network:session():local_peer():id()
  if l_87_1 ~= local_peer_id and managers.network:game():member(l_87_1) then
    local unit = managers.network:game():member(l_87_1):unit()
    if alive(unit) then
      unit:movement():set_visual_carry(nil)
    end
  end
end

PlayerManager.get_my_carry_data = function(l_88_0)
  local peer_id = managers.network:session():local_peer():id()
  return l_88_0._global.synced_carry[peer_id]
end

PlayerManager.get_synced_carry = function(l_89_0, l_89_1)
  return l_89_0._global.synced_carry[l_89_1]
end

PlayerManager.from_server_interaction_reply = function(l_90_0, l_90_1)
  l_90_0:player_unit():movement():set_carry_restriction(false)
  if not l_90_1 then
    l_90_0:clear_carry()
  end
end

PlayerManager.get_all_synced_carry = function(l_91_0)
  return l_91_0._global.synced_carry
end

PlayerManager.aquire_team_upgrade = function(l_92_0, l_92_1)
  if not l_92_0._global.team_upgrades[l_92_1.category] then
    l_92_0._global.team_upgrades[l_92_1.category] = {}
  end
  l_92_0._global.team_upgrades[l_92_1.category][l_92_1.upgrade] = l_92_1.value
end

PlayerManager.unaquire_team_upgrade = function(l_93_0, l_93_1)
  if not l_93_0._global.team_upgrades[l_93_1.category] then
    Application:error("[PlayerManager:unaquire_team_upgrade] Can't unaquire team upgrade of category", l_93_1.category)
    return 
  end
  if not l_93_0._global.team_upgrades[l_93_1.category][l_93_1.upgrade] then
    Application:error("[PlayerManager:unaquire_team_upgrade] Can't unaquire team upgrade", l_93_1.upgrade)
    return 
  end
  local val = l_93_0._global.team_upgrades[l_93_1.category][l_93_1.upgrade]
  val = val - 1
  l_93_0._global.team_upgrades[l_93_1.category][l_93_1.upgrade] = val > 0 and val or nil
end

PlayerManager.team_upgrade_value = function(l_94_0, l_94_1, l_94_2, l_94_3)
  for peer_id,categories in pairs(l_94_0._global.synced_team_upgrades) do
    if categories[l_94_1] and categories[l_94_1][l_94_2] then
      local level = categories[l_94_1][l_94_2]
      return tweak_data.upgrades.values.team[l_94_1][l_94_2][level]
    end
  end
  return l_94_0._global.team_upgrades[l_94_1] or l_94_3 or 0
  return l_94_0._global.team_upgrades[l_94_1][l_94_2] or l_94_3 or 0
  local level = l_94_0._global.team_upgrades[l_94_1][l_94_2]
  local value = tweak_data.upgrades.values.team[l_94_1][l_94_2][level]
  return value
end

PlayerManager.has_team_category_upgrade = function(l_95_0, l_95_1, l_95_2)
  for peer_id,categories in pairs(l_95_0._global.synced_team_upgrades) do
    if categories[l_95_1] and categories[l_95_1][l_95_2] then
      return true
    end
  end
  if not l_95_0._global.team_upgrades[l_95_1] then
    return false
  end
  if not l_95_0._global.team_upgrades[l_95_1][l_95_2] then
    return false
  end
  return true
end

PlayerManager.update_team_upgrades_to_peers = function(l_96_0)
  for category,upgrades in pairs(l_96_0._global.team_upgrades) do
    for upgrade,level in pairs(upgrades) do
      managers.network:session():send_to_peers("add_synced_team_upgrade", category, upgrade, level)
    end
  end
end

PlayerManager.update_team_upgrades_to_peer = function(l_97_0, l_97_1)
  for category,upgrades in pairs(l_97_0._global.team_upgrades) do
    for upgrade,level in pairs(upgrades) do
      l_97_1:send_after_load("add_synced_team_upgrade", category, upgrade, level)
    end
  end
end

PlayerManager.add_synced_team_upgrade = function(l_98_0, l_98_1, l_98_2, l_98_3, l_98_4)
  if not l_98_0._global.synced_team_upgrades[l_98_1] then
    l_98_0._global.synced_team_upgrades[l_98_1] = {}
  end
  if not l_98_0._global.synced_team_upgrades[l_98_1][l_98_2] then
    l_98_0._global.synced_team_upgrades[l_98_1][l_98_2] = {}
  end
  l_98_0._global.synced_team_upgrades[l_98_1][l_98_2][l_98_3] = l_98_4
end

PlayerManager.remove_equipment_possession = function(l_99_0, l_99_1, l_99_2)
  if not l_99_0._global.synced_equipment_possession[l_99_1] then
    return 
  end
  l_99_0._global.synced_equipment_possession[l_99_1][l_99_2] = nil
  local character_data = managers.criminals:character_data_by_peer_id(l_99_1)
  if character_data and character_data.panel_id then
    managers.hud:remove_teammate_special_equipment(character_data.panel_id, l_99_2)
  end
end

PlayerManager.get_synced_equipment_possession = function(l_100_0, l_100_1)
  return l_100_0._global.synced_equipment_possession[l_100_1]
end

PlayerManager.update_equipment_possession_to_peer = function(l_101_0, l_101_1)
  local peer_id = managers.network:session():local_peer():id()
  if l_101_0._global.synced_equipment_possession[peer_id] then
    for name,amount in pairs(l_101_0._global.synced_equipment_possession[peer_id]) do
      l_101_1:send_after_load("sync_equipment_possession", peer_id, name, amount)
    end
  end
end

PlayerManager.update_equipment_possession_to_peers = function(l_102_0, l_102_1, l_102_2)
  local peer_id = managers.network:session():local_peer():id()
  managers.network:session():send_to_peers("sync_equipment_possession", peer_id, l_102_1, l_102_2 or 1)
  l_102_0:set_synced_equipment_possession(peer_id, l_102_1, l_102_2)
end

PlayerManager.set_synced_equipment_possession = function(l_103_0, l_103_1, l_103_2, l_103_3)
  if l_103_0._global.synced_equipment_possession[l_103_1] then
    local only_update_amount = l_103_0._global.synced_equipment_possession[l_103_1][l_103_2]
  end
  if not l_103_0._global.synced_equipment_possession[l_103_1] then
    l_103_0._global.synced_equipment_possession[l_103_1] = {}
  end
  l_103_0._global.synced_equipment_possession[l_103_1][l_103_2] = l_103_3 or 1
  local character_data = managers.criminals:character_data_by_peer_id(l_103_1)
  if character_data and character_data.panel_id then
    local equipment_data = tweak_data.equipments.specials[l_103_2]
    local icon = equipment_data.icon
    if only_update_amount then
      managers.hud:set_teammate_special_equipment_amount(character_data.panel_id, l_103_2, l_103_3)
    else
      managers.hud:add_teammate_special_equipment(character_data.panel_id, {id = l_103_2, icon = icon, amount = l_103_3})
    end
  end
end

PlayerManager.peer_dropped_out = function(l_104_0, l_104_1)
  do
    local peer_id = l_104_1:id()
     -- DECOMPILER ERROR: No list found. Setlist fails

    if Network:is_server() then
      if l_104_0._global.synced_equipment_possession[peer_id] then
        local peers = {}
         -- DECOMPILER ERROR: Overwrote pending register.

        for _,p in managers.network:session():local_peer()(managers.network:session():peers()) do
          table.insert(peers, p)
        end
        for name,amount in pairs(l_104_0._global.synced_equipment_possession[peer_id]) do
          for _,p in pairs(peers) do
            local id = p:id()
            if not l_104_0._global.synced_equipment_possession[id] or not l_104_0._global.synced_equipment_possession[id][name] then
              if p == managers.network:session():local_peer() then
                managers.player:add_special({name = name, amount = amount})
                for (for control),name in (for generator) do
                end
                p:send("give_equipment", name, amount)
                for (for control),name in (for generator) do
                end
              end
            end
          end
          if l_104_0._global.synced_carry[peer_id] and l_104_0._global.synced_carry[peer_id].approved then
            local carry_id = l_104_0._global.synced_carry[peer_id].carry_id
            local carry_value = l_104_0._global.synced_carry[peer_id].value
            local dye_initiated = l_104_0._global.synced_carry[peer_id].dye_initiated
            local has_dye_pack = l_104_0._global.synced_carry[peer_id].has_dye_pack
            local dye_value_multiplier = l_104_0._global.synced_carry[peer_id].dye_value_multiplier
            local peer_unit = managers.network:game():member(peer_id):unit()
            if not alive(peer_unit) or not peer_unit:position() then
              local position = Vector3()
            end
            local dir = Vector3(0, 0, 0)
            l_104_0:server_drop_carry(carry_id, carry_value, dye_initiated, has_dye_pack, dye_value_multiplier, position, Rotation(), dir, 0)
          end
        end
        l_104_0._global.synced_equipment_possession[peer_id] = nil
        l_104_0._global.synced_deployables[peer_id] = nil
        l_104_0._global.synced_cable_ties[peer_id] = nil
        l_104_0._global.synced_perks[peer_id] = nil
        l_104_0._global.synced_ammo_info[peer_id] = nil
        l_104_0._global.synced_carry[peer_id] = nil
        l_104_0._global.synced_team_upgrades[peer_id] = nil
      end
       -- Warning: missing end command somewhere! Added here
    end
     -- Warning: missing end command somewhere! Added here
  end
end

PlayerManager.add_equipment = function(l_105_0, l_105_1)
  if l_105_1.equipment or tweak_data.equipments[l_105_1.name] then
    l_105_0:_add_equipment(l_105_1)
    return 
  end
  if l_105_1.equipment or tweak_data.equipments.specials[l_105_1.name] then
    l_105_0:add_special(l_105_1)
    return 
  end
  if not l_105_1.equipment then
    Application:error("No equipment or special equipment named", l_105_1.name)
  end
end

PlayerManager._add_equipment = function(l_106_0, l_106_1)
  if l_106_0:has_equipment(l_106_1.equipment) then
    print("Allready have equipment", l_106_1.equipment)
    return 
  end
  local equipment = l_106_1.equipment
  local tweak_data = tweak_data.equipments[equipment]
   -- DECOMPILER ERROR: Confused while interpreting a jump as a 'while'

end
local amount = (l_106_1.amount or 0) + l_106_0:equiptment_upgrade_value(equipment, "quantity")
if not l_106_1.icon and tweak_data then
  local icon = tweak_data.icon
end
if not l_106_1.use_function_name and tweak_data then
  local use_function_name = tweak_data.use_function_name
end
local use_function = use_function_name or nil
table.insert(l_106_0._equipment.selections, {equipment = equipment, amount = Application:digest_value(0, true), use_function = use_function, action_timer = tweak_data.action_timer})
l_106_0._equipment.selected_index = l_106_0._equipment.selected_index or 1
l_106_0:update_deployable_equipment_amount_to_peers(equipment, amount)
managers.hud:add_item({amount = amount, icon = icon})
l_106_0:add_equipment_amount(equipment, amount)
end

PlayerManager.add_equipment_amount = function(l_107_0, l_107_1, l_107_2)
  local data, index = l_107_0:equipment_data_by_name(l_107_1)
  if data then
    local new_amount = Application:digest_value(data.amount, false) + l_107_2
    data.amount = Application:digest_value(new_amount, true)
    managers.hud:set_item_amount(index, new_amount)
  end
end

PlayerManager.set_equipment_amount = function(l_108_0, l_108_1, l_108_2)
  local data, index = l_108_0:equipment_data_by_name(l_108_1)
  if data then
    local new_amount = l_108_2
    data.amount = Application:digest_value(new_amount, true)
    managers.hud:set_item_amount(index, new_amount)
  end
end

PlayerManager.equipment_data_by_name = function(l_109_0, l_109_1)
  for i,equipments in ipairs(l_109_0._equipment.selections) do
    if equipments.equipment == l_109_1 then
      return equipments, i
    end
  end
  return nil
end

PlayerManager.get_equipment_amount = function(l_110_0, l_110_1)
  for i,equipments in ipairs(l_110_0._equipment.selections) do
    if equipments.equipment == l_110_1 then
      return Application:digest_value(equipments.amount, false)
    end
  end
  return 0
end

PlayerManager.has_equipment = function(l_111_0, l_111_1)
  for i,equipments in ipairs(l_111_0._equipment.selections) do
    if equipments.equipment == l_111_1 then
      return true
    end
  end
  return false
end

PlayerManager.has_deployable_left = function(l_112_0, l_112_1)
  return l_112_0:get_equipment_amount(l_112_1) > 0
end

PlayerManager.select_next_item = function(l_113_0)
  if not l_113_0._equipment.selected_index then
    return 
  end
  l_113_0._equipment.selected_index = l_113_0._equipment.selected_index + 1 <= #l_113_0._equipment.selections and l_113_0._equipment.selected_index + 1 or 1
  managers.hud:set_next_item_selected()
end

PlayerManager.select_previous_item = function(l_114_0)
  if not l_114_0._equipment.selected_index then
    return 
  end
  if l_114_0._equipment.selected_index - 1 < 1 or not l_114_0._equipment.selected_index - 1 then
    l_114_0._equipment.selected_index = #l_114_0._equipment.selections
  end
  managers.hud:set_previous_item_selected()
end

PlayerManager.clear_equipment = function(l_115_0)
  for i,equipment in ipairs(l_115_0._equipment.selections) do
    equipment.amount = Application:digest_value(0, true)
    managers.hud:set_item_amount(i, 0)
    l_115_0:update_deployable_equipment_amount_to_peers(equipment.equipment, 0)
  end
end

PlayerManager.from_server_equipment_place_result = function(l_116_0, l_116_1, l_116_2)
  if l_116_1 == 0 then
    l_116_2:equipment():from_server_sentry_gun_place_result(not alive(l_116_2))
  end
  local equipment = l_116_0._equipment.selections[l_116_1]
  if not equipment then
    return 
  end
  local new_amount = Application:digest_value(equipment.amount, false) - 1
  equipment.amount = Application:digest_value(new_amount, true)
  do return end
  if new_amount == 0 then
    if equipment.equipment == "trip_mine" and not l_116_0:has_equipment("sentry_gun") then
      l_116_0:add_equipment({equipment = "sentry_gun"})
      l_116_0:select_next_item()
      return 
    elseif equipment.equipment == "sentry_gun" and not l_116_0:has_equipment("trip_mine") then
      l_116_0:add_equipment({equipment = "trip_mine"})
      l_116_0:select_next_item()
      return 
    end
  end
  managers.hud:set_item_amount(l_116_0._equipment.selected_index, new_amount)
  l_116_0:update_deployable_equipment_amount_to_peers(equipment.equipment, new_amount)
end

PlayerManager.can_use_selected_equipment = function(l_117_0, l_117_1)
  local equipment = l_117_0._equipment.selections[l_117_0._equipment.selected_index]
  if not equipment or Application:digest_value(equipment.amount, false) == 0 then
    return false
  end
  return true
end

PlayerManager.selected_equipment = function(l_118_0)
  local equipment = l_118_0._equipment.selections[l_118_0._equipment.selected_index]
  if not equipment or Application:digest_value(equipment.amount, false) == 0 then
    return nil
  end
  return equipment
end

PlayerManager.selected_equipment_id = function(l_119_0)
  local equipment_data = l_119_0:selected_equipment()
  if not equipment_data then
    return nil
  end
  return equipment_data.equipment
end

PlayerManager.selected_equipment_name = function(l_120_0)
  local equipment_data = l_120_0:selected_equipment()
  if not equipment_data then
    return ""
  end
  return managers.localization:text(tweak_data.equipments[equipment_data.equipment].text_id)
end

PlayerManager.use_selected_equipment = function(l_121_0, l_121_1)
  local equipment = l_121_0._equipment.selections[l_121_0._equipment.selected_index]
  if not equipment or Application:digest_value(equipment.amount, false) == 0 then
    return 
  end
  local used_one = false
  local redirect = nil
  if equipment.use_function then
    used_one, redirect = l_121_1:equipment()[equipment.use_function](l_121_1:equipment(), l_121_0._equipment.selected_index)
  else
    used_one = true
  end
  if used_one then
    l_121_0:remove_equipment(equipment.equipment)
  end
  return {expire_timer = equipment.action_timer, redirect = redirect}
end

PlayerManager.check_selected_equipment_placement_valid = function(l_122_0, l_122_1)
  local equipment_data = managers.player:selected_equipment()
  if not equipment_data then
    return false
  end
  if equipment_data.equipment == "trip_mine" or equipment_data.equipment == "ecm_jammer" then
     -- DECOMPILER ERROR: Confused while interpreting a jump as a 'while'

  end
  return true
elseif equipment_data.equipment == "sentry_gun" or equipment_data.equipment == "ammo_bag" or equipment_data.equipment == "doctor_bag" then
   -- DECOMPILER ERROR: Confused while interpreting a jump as a 'while'

end
return true
end
 -- DECOMPILER ERROR: Confused while interpreting a jump as a 'while'

end
return true
end

PlayerManager.selected_equipment_deploy_timer = function(l_123_0)
  local equipment_data = managers.player:selected_equipment()
  if not equipment_data then
    return 0
  end
  local equipment_tweak_data = tweak_data.equipments[equipment_data.equipment]
  local multiplier = 1
  if equipment_tweak_data.upgrade_deploy_time_multiplier then
    multiplier = managers.player:upgrade_value(equipment_tweak_data.upgrade_deploy_time_multiplier.category, equipment_tweak_data.upgrade_deploy_time_multiplier.upgrade, 1)
  end
  return (equipment_tweak_data.deploy_time or 1) * multiplier
end

PlayerManager.remove_equipment = function(l_124_0, l_124_1)
  local equipment, index = l_124_0:equipment_data_by_name(l_124_1)
  local new_amount = Application:digest_value(equipment.amount, false) - 1
  equipment.amount = Application:digest_value(new_amount, true)
  do return end
  if new_amount == 0 then
    if equipment.equipment == "trip_mine" and not l_124_0:has_equipment("sentry_gun") then
      l_124_0:add_equipment({equipment = "sentry_gun"})
      l_124_0:select_next_item()
      return 
    elseif equipment.equipment == "sentry_gun" and not l_124_0:has_equipment("trip_mine") then
      l_124_0:add_equipment({equipment = "trip_mine"})
      l_124_0:select_next_item()
      return 
    end
  end
  managers.hud:set_item_amount(index, new_amount)
  l_124_0:update_deployable_equipment_amount_to_peers(equipment.equipment, new_amount)
end

PlayerManager.add_special = function(l_125_0, l_125_1)
  if not l_125_1.equipment then
    local name = l_125_1.name
  end
  if not tweak_data.equipments.specials[name] then
    Application:error("Special equipment " .. name .. " doesn't exist!")
    return 
  end
  local unit = l_125_0:player_unit()
   -- DECOMPILER ERROR: Confused while interpreting a jump as a 'while'

end
local respawn = true
local equipment = tweak_data.equipments.specials[name]
local special_equipment = l_125_0._equipment.specials[name]
if not l_125_1.amount then
  local amount = equipment.quantity
end
local extra = l_125_0:_equipped_upgrade_value(equipment) + l_125_0:upgrade_value(name, "quantity")
if special_equipment and equipment.quantity then
  local dedigested_amount = Application:digest_value(special_equipment.amount, false)
  if not l_125_0:has_category_upgrade(name, "quantity_unlimited") or not -1 then
    local new_amount = math.min(dedigested_amount + amount, equipment.quantity + extra)
  end
  special_equipment.amount = Application:digest_value(new_amount, true)
  if special_equipment.is_cable_tie then
    managers.hud:set_cable_ties_amount(HUDManager.PLAYER_PANEL, new_amount)
    l_125_0:update_synced_cable_ties_to_peers(new_amount)
  else
    managers.hud:set_special_equipment_amount(name, new_amount)
    l_125_0:update_equipment_possession_to_peers(name, new_amount)
  end
end
return 
local icon = equipment.icon
local action_message = equipment.action_message
local dialog = equipment.dialog_id
if not l_125_1.silent then
  local text = managers.localization:text(equipment.text_id)
  local title = managers.localization:text("present_obtained_mission_equipment_title")
  managers.hud:present_mid_text({text = text, title = title, icon = icon, time = 4})
  if dialog then
    managers.dialog:queue_dialog(dialog, {})
  end
  if action_message and alive(unit) then
    managers.network:session():send_to_peers("sync_show_action_message", unit, action_message)
  end
end
if ((l_125_0:has_category_upgrade(name, "quantity_unlimited") and -1) or not equipment.quantity or (respawn and math.min(l_125_1.amount, equipment.quantity + extra)) or equipment.quantity) then
  local quantity = math.min(amount + extra, equipment.quantity + extra)
end
local is_cable_tie = name == "cable_tie"
if not quantity then
  managers.hud:set_cable_tie(HUDManager.PLAYER_PANEL, {icon = icon, amount = not is_cable_tie or nil})
end
l_125_0:update_synced_cable_ties_to_peers(quantity)

l_125_0._equipment.specials[name] = {amount = quantity and Application:digest_value(quantity, true) or nil, is_cable_tie = is_cable_tie}
if equipment.player_rule then
  l_125_0:set_player_rule(equipment.player_rule, true)
end
end

PlayerManager._equipped_upgrade_value = function(l_126_0, l_126_1)
  if not l_126_1.extra_quantity then
    return 0
  end
  local equipped_upgrade = l_126_1.extra_quantity.equipped_upgrade
  local category = l_126_1.extra_quantity.category
  local upgrade = l_126_1.extra_quantity.upgrade
  return l_126_0:equipped_upgrade_value(equipped_upgrade, category, upgrade)
end

PlayerManager.has_special_equipment = function(l_127_0, l_127_1)
  return l_127_0._equipment.specials[l_127_1]
end

PlayerManager.can_pickup_equipment = function(l_128_0, l_128_1)
  local special_equipment = l_128_0._equipment.specials[l_128_1]
  if special_equipment then
    if special_equipment.amount then
      local equipment = tweak_data.equipments.specials[l_128_1]
      local extra = l_128_0:_equipped_upgrade_value(equipment)
      return Application:digest_value(special_equipment.amount, false) < equipment.quantity + extra
    end
    return false
  end
  return true
end

PlayerManager.remove_special = function(l_129_0, l_129_1)
  local special_equipment = l_129_0._equipment.specials[l_129_1]
  if not special_equipment then
    return 
  end
  if special_equipment.amount then
    local special_amount = Application:digest_value(special_equipment.amount, false)
  end
  if special_amount and special_amount ~= -1 then
    special_amount = math.max(0, special_amount - 1)
    if special_equipment.is_cable_tie then
      managers.hud:set_cable_ties_amount(HUDManager.PLAYER_PANEL, special_amount)
      l_129_0:update_synced_cable_ties_to_peers(special_amount)
    else
      managers.hud:set_special_equipment_amount(l_129_1, special_amount)
      l_129_0:update_equipment_possession_to_peers(l_129_1, special_amount)
    end
    special_equipment.amount = Application:digest_value(special_amount, true)
  end
  if not special_amount or special_amount == 0 then
    if not special_equipment.is_cable_tie then
      managers.hud:remove_special_equipment(l_129_1)
      managers.network:session():send_to_peers_loaded("sync_remove_equipment_possession", managers.network:session():local_peer():id(), l_129_1)
      l_129_0:remove_equipment_possession(managers.network:session():local_peer():id(), l_129_1)
    end
    l_129_0._equipment.specials[l_129_1] = nil
    local equipment = tweak_data.equipments.specials[l_129_1]
    if equipment.player_rule then
      l_129_0:set_player_rule(equipment.player_rule, false)
    end
  end
end

PlayerManager.set_carry = function(l_130_0, l_130_1, l_130_2, l_130_3, l_130_4, l_130_5)
  local carry_data = tweak_data.carry[l_130_1]
  local carry_type = carry_data.type
  l_130_0:set_player_state("carry")
  local title = managers.localization:text("hud_carrying_announcement_title")
  if carry_data.name_id then
    local type_text = managers.localization:text(carry_data.name_id)
  end
  local text = (managers.localization:text("hud_carrying_announcement", {CARRY_TYPE = type_text}))
  local icon = nil
  if not l_130_3 then
    l_130_3 = true
    if carry_data.dye then
      local chance = tweak_data.carry.dye.chance * managers.player:upgrade_value("player", "dye_pack_chance_multiplier", 1)
      do return end
      l_130_4 = true
      l_130_5 = math.round(tweak_data.carry.dye.value_multiplier * managers.player:upgrade_value("player", "dye_pack_cash_loss_multiplier", 1))
    end
  end
  l_130_0:update_synced_carry_to_peers(l_130_1, l_130_2 or 100, l_130_3, l_130_4, l_130_5)
  managers.hud:set_teammate_carry_info(HUDManager.PLAYER_PANEL, l_130_1, managers.loot:get_real_value(l_130_1, l_130_2 or 100))
  managers.hud:temp_show_carry_bag(l_130_1, managers.loot:get_real_value(l_130_1, l_130_2 or 100))
  local player = l_130_0:player_unit()
  if not player then
    return 
  end
  player:movement():current_state():set_tweak_data(carry_type)
end

PlayerManager.bank_carry = function(l_131_0)
  local carry_data = l_131_0:get_my_carry_data()
  managers.loot:secure(carry_data.carry_id, carry_data.value)
  managers.hud:remove_teammate_carry_info(HUDManager.PLAYER_PANEL)
  managers.hud:temp_hide_carry_bag()
  l_131_0:update_removed_synced_carry_to_peers()
  managers.player:set_player_state("standard")
end

PlayerManager.drop_carry = function(l_132_0)
  local carry_data = l_132_0:get_my_carry_data()
  if not carry_data then
    return 
  end
  l_132_0._carry_blocked_cooldown_t = Application:time() + (1.2000000476837 + math.rand(0.30000001192093))
  local player = l_132_0:player_unit()
  local camera_ext = player:camera()
  local dye_initiated = carry_data.dye_initiated
  local has_dye_pack = carry_data.has_dye_pack
  local dye_value_multiplier = carry_data.dye_value_multiplier
  local throw_distance_multiplier_upgrade_level = managers.player:upgrade_level("carry", "throw_distance_multiplier", 0)
  if Network:is_client() then
    managers.network:session():send_to_host("server_drop_carry", carry_data.carry_id, carry_data.value, dye_initiated, has_dye_pack, dye_value_multiplier, camera_ext:position(), camera_ext:rotation(), player:camera():forward(), throw_distance_multiplier_upgrade_level)
  else
    l_132_0:server_drop_carry(carry_data.carry_id, carry_data.value, dye_initiated, has_dye_pack, dye_value_multiplier, camera_ext:position(), camera_ext:rotation(), player:camera():forward(), throw_distance_multiplier_upgrade_level)
  end
  managers.hud:remove_teammate_carry_info(HUDManager.PLAYER_PANEL)
  managers.hud:temp_hide_carry_bag()
  l_132_0:update_removed_synced_carry_to_peers()
  if l_132_0._current_state == "carry" then
    managers.player:set_player_state("standard")
  end
end

PlayerManager.server_drop_carry = function(l_133_0, l_133_1, l_133_2, l_133_3, l_133_4, l_133_5, l_133_6, l_133_7, l_133_8, l_133_9)
  if l_133_2 <= 0 then
    return 
  end
  local unit_name = tweak_data.carry[l_133_1].unit or "units/payday2/pickups/gen_pku_lootbag/gen_pku_lootbag"
  local unit = World:spawn_unit(Idstring(unit_name), l_133_6, l_133_7)
  managers.network:session():send_to_peers_synched("sync_carry_data", unit, l_133_1, l_133_2, l_133_3, l_133_4, l_133_5, l_133_6, l_133_8, l_133_9)
  l_133_0:sync_carry_data(unit, l_133_1, l_133_2, l_133_3, l_133_4, l_133_5, l_133_6, l_133_8, l_133_9)
  return unit
end

PlayerManager.sync_carry_data = function(l_134_0, l_134_1, l_134_2, l_134_3, l_134_4, l_134_5, l_134_6, l_134_7, l_134_8, l_134_9)
  local throw_distance_multiplier = l_134_0:upgrade_value_by_level("carry", "throw_distance_multiplier", l_134_9, 1)
  local carry_type = tweak_data.carry[l_134_2].type
  throw_distance_multiplier = throw_distance_multiplier * tweak_data.carry.types[carry_type].throw_distance_multiplier
  l_134_1:push(100, l_134_8 * 600 * (throw_distance_multiplier))
  l_134_1:carry_data():set_carry_id(l_134_2)
  l_134_1:carry_data():set_value(l_134_3)
  l_134_1:carry_data():set_dye_pack_data(l_134_4, l_134_5, l_134_6)
  l_134_1:interaction():register_collision_callbacks()
end

PlayerManager.force_drop_carry = function(l_135_0)
  local carry_data = l_135_0:get_my_carry_data()
  if not carry_data then
    return 
  end
  local player = l_135_0:player_unit()
  if not alive(player) then
    print("COULDN'T FORCE DROP! DIDN'T HAVE A UNIT")
    return 
  end
  local dye_initiated = carry_data.dye_initiated
  local has_dye_pack = carry_data.has_dye_pack
  local dye_value_multiplier = carry_data.dye_value_multiplier
  local camera_ext = player:camera()
  if Network:is_client() then
    managers.network:session():send_to_host("server_drop_carry", carry_data.carry_id, carry_data.value, dye_initiated, has_dye_pack, dye_value_multiplier, camera_ext:position(), camera_ext:rotation(), Vector3(0, 0, 0), 0)
  else
    l_135_0:server_drop_carry(carry_data.carry_id, carry_data.value, dye_initiated, has_dye_pack, dye_value_multiplier, camera_ext:position(), camera_ext:rotation(), Vector3(0, 0, 0), 0)
  end
  managers.hud:remove_teammate_carry_info(HUDManager.PLAYER_PANEL)
  managers.hud:temp_hide_carry_bag()
  l_135_0:update_removed_synced_carry_to_peers()
end

PlayerManager.clear_carry = function(l_136_0)
  local carry_data = l_136_0:get_my_carry_data()
  if not carry_data then
    return 
  end
  local player = l_136_0:player_unit()
  if not alive(player) then
    print("COULDN'T FORCE DROP! DIDN'T HAVE A UNIT")
    return 
  end
  managers.hud:remove_teammate_carry_info(HUDManager.PLAYER_PANEL)
  managers.hud:temp_hide_carry_bag()
  l_136_0:update_removed_synced_carry_to_peers()
  if l_136_0._current_state == "carry" then
    managers.player:set_player_state("standard")
  end
end

PlayerManager.is_carrying = function(l_137_0)
   -- DECOMPILER ERROR: Confused while interpreting a jump as a 'while'

end
return true
end

PlayerManager.carry_blocked_by_cooldown = function(l_138_0)
  return ((not l_138_0._carry_blocked_cooldown_t or Application:time() >= l_138_0._carry_blocked_cooldown_t) and false)
end

PlayerManager.can_carry = function(l_139_0, l_139_1)
  return true
end

PlayerManager.check_damage_carry = function(l_140_0, l_140_1)
  local carry_data = l_140_0:get_my_carry_data()
  if not carry_data then
    return 
  end
  local carry_id = carry_data.carry_id
  local type = tweak_data.carry[carry_id].type
  if not tweak_data.carry.types[type].looses_value then
    return 
  end
  local dye_initiated = carry_data.dye_initiated
  local has_dye_pack = carry_data.has_dye_pack
  local dye_value_multiplier = carry_data.dye_value_multiplier
  local value = math.max(carry_data.value - tweak_data.carry.types[type].looses_value_per_hit * l_140_1.damage, 0)
  l_140_0:update_synced_carry_to_peers(carry_id, value, dye_initiated, has_dye_pack, dye_value_multiplier)
  managers.hud:set_teammate_carry_info(HUDManager.PLAYER_PANEL, carry_id, managers.loot:get_real_value(carry_id, value))
end

PlayerManager.dye_pack_exploded = function(l_141_0)
  local carry_data = l_141_0:get_my_carry_data()
  if not carry_data then
    return 
  end
  local carry_id = carry_data.carry_id
  local type = tweak_data.carry[carry_id].type
  local dye_initiated = carry_data.dye_initiated
  local has_dye_pack = carry_data.has_dye_pack
  local dye_value_multiplier = carry_data.dye_value_multiplier
  local value = carry_data.value * (1 - dye_value_multiplier / 100)
  value = math.round(value)
  has_dye_pack = false
  l_141_0:update_synced_carry_to_peers(carry_id, value, dye_initiated, has_dye_pack, dye_value_multiplier)
  managers.hud:set_teammate_carry_info(HUDManager.PLAYER_PANEL, carry_id, managers.loot:get_real_value(carry_id, value))
end

PlayerManager.count_up_player_minions = function(l_142_0)
  l_142_0._local_player_minions = math.min(l_142_0._local_player_minions + 1, l_142_0:upgrade_value("player", "convert_enemies_max_minions", 0))
end

PlayerManager.count_down_player_minions = function(l_143_0)
  l_143_0._local_player_minions = math.max(l_143_0._local_player_minions - 1, 0)
end

PlayerManager.reset_minions = function(l_144_0)
  l_144_0._local_player_minions = 0
end

PlayerManager.chk_minion_limit_reached = function(l_145_0)
  return l_145_0:upgrade_value("player", "convert_enemies_max_minions", 0) <= l_145_0._local_player_minions
end

PlayerManager.change_player_look = function(l_146_0, l_146_1)
  l_146_0._player_mesh_suffix = l_146_1
  for _,unit in pairs(managers.groupai:state():all_char_criminals()) do
    unit.unit:movement():set_character_anim_variables()
  end
end

PlayerManager.player_timer = function(l_147_0)
  return l_147_0._player_timer
end

PlayerManager.save = function(l_148_0, l_148_1)
  local state = {kit = l_148_0._global.kit}
  l_148_1.PlayerManager = state
end

PlayerManager.load = function(l_149_0, l_149_1)
  l_149_0:aquire_default_upgrades()
  local state = l_149_1.PlayerManager
  if state then
    if not state.kit then
      l_149_0._global.kit = l_149_0._global.kit
    end
    l_149_0:_verify_loaded_data()
  end
end

PlayerManager._verify_loaded_data = function(l_150_0)
end

PlayerManager.sync_save = function(l_151_0, l_151_1)
  local state = {current_sync_state = l_151_0._current_sync_state, player_mesh_suffix = l_151_0._player_mesh_suffix}
  l_151_1.PlayerManager = state
end

PlayerManager.sync_load = function(l_152_0, l_152_1)
  local state = l_152_1.PlayerManager
  if state then
    l_152_0:set_player_state(state.current_sync_state)
    l_152_0:change_player_look(state.player_mesh_suffix)
  end
end

PlayerManager.on_simulation_started = function(l_153_0)
  l_153_0._respawn = false
end

PlayerManager.reset = function(l_154_0)
  if managers.hud then
    managers.hud:clear_items()
    managers.hud:clear_special_equipments()
    managers.hud:clear_player_special_equipments()
  end
  Global.player_manager = nil
  l_154_0:_setup()
  l_154_0:_setup_rules()
  l_154_0:aquire_default_upgrades()
end

PlayerManager.soft_reset = function(l_155_0)
  l_155_0._listener_holder = EventListenerHolder:new()
end

PlayerManager.on_peer_synch_request = function(l_156_0, l_156_1)
  l_156_0:player_unit():network():synch_to_peer(l_156_1)
end


