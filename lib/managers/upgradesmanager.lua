-- Decompiled using luadec 2.0.1 by sztupy (http://winmo.sztupy.hu)
-- Command line was: F:\SteamLibrary\SteamApps\common\PAYDAY 2\lua\lib\managers\upgradesmanager.luac 

if not UpgradesManager then
  UpgradesManager = class()
end
UpgradesManager.init = function(l_1_0)
  l_1_0:_setup()
end

UpgradesManager._setup = function(l_2_0)
  if not Global.upgrades_manager then
    Global.upgrades_manager = {}
    Global.upgrades_manager.aquired = {}
    Global.upgrades_manager.automanage = false
    Global.upgrades_manager.progress = {0, 0, 0, 0}
    Global.upgrades_manager.target_tree = l_2_0:_autochange_tree()
    Global.upgrades_manager.disabled_visual_upgrades = {}
  end
  l_2_0._global = Global.upgrades_manager
end

UpgradesManager.setup_current_weapon = function(l_3_0)
end

UpgradesManager.visual_weapon_upgrade_active = function(l_4_0, l_4_1)
  return not l_4_0._global.disabled_visual_upgrades[l_4_1]
end

UpgradesManager.toggle_visual_weapon_upgrade = function(l_5_0, l_5_1)
  if l_5_0._global.disabled_visual_upgrades[l_5_1] then
    l_5_0._global.disabled_visual_upgrades[l_5_1] = nil
  else
    l_5_0._global.disabled_visual_upgrades[l_5_1] = true
  end
end

UpgradesManager.set_target_tree = function(l_6_0, l_6_1)
  local level = managers.experience:current_level()
  local step = l_6_0._global.progress[l_6_1]
  local cap = tweak_data.upgrades.tree_caps[l_6_0._global.progress[l_6_1] + 1]
  if cap and level < cap then
    return 
  end
  l_6_0:_set_target_tree(l_6_1)
end

UpgradesManager._set_target_tree = function(l_7_0, l_7_1)
  local i = l_7_0._global.progress[l_7_1] + 1
  local upgrade = tweak_data.upgrades.definitions[tweak_data.upgrades.progress[l_7_1][i]]
  l_7_0._global.target_tree = l_7_1
end

UpgradesManager.current_tree_name = function(l_8_0)
  return l_8_0:tree_name(l_8_0._global.target_tree)
end

UpgradesManager.tree_name = function(l_9_0, l_9_1)
  return managers.localization:text(tweak_data.upgrades.trees[l_9_1].name_id)
end

UpgradesManager.tree_allowed = function(l_10_0, l_10_1, l_10_2)
  if not l_10_2 then
    l_10_2 = managers.experience:current_level()
  end
  local cap = tweak_data.upgrades.tree_caps[l_10_0._global.progress[l_10_1] + 1]
  return not cap or l_10_2 >= cap, cap
end

UpgradesManager.current_tree = function(l_11_0)
  return l_11_0._global.target_tree
end

UpgradesManager.next_upgrade = function(l_12_0, l_12_1)
end

UpgradesManager.level_up = function(l_13_0)
  local level = managers.experience:current_level()
  print("UpgradesManager:level_up()", level)
  l_13_0:aquire_from_level_tree(level, false)
end

UpgradesManager.aquire_from_level_tree = function(l_14_0, l_14_1, l_14_2)
  local tree_data = tweak_data.upgrades.level_tree[l_14_1]
  if not tree_data then
    return 
  end
  for _,upgrade in ipairs(tree_data.upgrades) do
    l_14_0:aquire(upgrade, l_14_2)
  end
end

UpgradesManager._next_tree = function(l_15_0)
  local tree = nil
  if l_15_0._global.automanage then
    tree = l_15_0:_autochange_tree()
  end
  local level = managers.experience:current_level() + 1
  local cap = tweak_data.upgrades.tree_caps[l_15_0._global.progress[l_15_0._global.target_tree] + 1]
  if cap and level < cap then
    tree = l_15_0:_autochange_tree(l_15_0._global.target_tree)
  end
  if not tree then
    return l_15_0._global.target_tree
  end
end

UpgradesManager.num_trees = function(l_16_0)
  return managers.dlc:has_preorder() and 4 or 3
end

UpgradesManager._autochange_tree = function(l_17_0, l_17_1)
  local progress = clone(Global.upgrades_manager.progress)
  if l_17_1 then
    progress[l_17_1] = nil
  end
  if not managers.dlc:has_preorder() then
    progress[4] = nil
  end
  local n_tree = 0
  local n_v = 100
  for tree,v in pairs(progress) do
    if v < n_v then
      n_tree = tree
      n_v = v
    end
  end
  return n_tree
end

UpgradesManager.aquired = function(l_18_0, l_18_1)
  if l_18_0._global.aquired[l_18_1] then
    return true
  end
end

UpgradesManager.aquire_default = function(l_19_0, l_19_1)
  if not tweak_data.upgrades.definitions[l_19_1] then
    Application:error("Tried to aquire an upgrade that doesn't exist: " .. l_19_1 .. "")
    return 
  end
  if l_19_0._global.aquired[l_19_1] then
    return 
  end
  l_19_0._global.aquired[l_19_1] = true
  local upgrade = tweak_data.upgrades.definitions[l_19_1]
  l_19_0:_aquire_upgrade(upgrade, l_19_1)
end

UpgradesManager.aquire = function(l_20_0, l_20_1, l_20_2)
  if not l_20_1 then
    Application:error("Tried to aquire an upgrade that doesn't exist: " .. (tweak_data.upgrades.definitions[l_20_1] or "nil") .. "")
    return 
    if l_20_0._global.aquired[l_20_1] then
      Application:error("Tried to aquire an upgrade that has allready been aquired: " .. l_20_1 .. "")
      return 
    end
    local level = managers.experience:current_level() + 1
    l_20_0._global.aquired[l_20_1] = true
    do
      local upgrade = tweak_data.upgrades.definitions[l_20_1]
      l_20_0:_aquire_upgrade(upgrade, l_20_1, l_20_2)
      l_20_0:setup_current_weapon()
    end
     -- Warning: missing end command somewhere! Added here
  end
end

UpgradesManager.unaquire = function(l_21_0, l_21_1)
  if not l_21_1 then
    Application:error("Tried to unaquire an upgrade that doesn't exist: " .. (tweak_data.upgrades.definitions[l_21_1] or "nil") .. "")
    return 
    if not l_21_0._global.aquired[l_21_1] then
      Application:error("Tried to unaquire an upgrade that hasn't benn aquired: " .. l_21_1 .. "")
      return 
    end
    l_21_0._global.aquired[l_21_1] = nil
    do
      local upgrade = tweak_data.upgrades.definitions[l_21_1]
      l_21_0:_unaquire_upgrade(upgrade, l_21_1)
    end
     -- Warning: missing end command somewhere! Added here
  end
end

UpgradesManager._aquire_upgrade = function(l_22_0, l_22_1, l_22_2, l_22_3)
  if l_22_1.category == "weapon" then
    l_22_0:_aquire_weapon(l_22_1, l_22_2, l_22_3)
  elseif l_22_1.category == "feature" then
    l_22_0:_aquire_feature(l_22_1, l_22_2, l_22_3)
  elseif l_22_1.category == "equipment" then
    l_22_0:_aquire_equipment(l_22_1, l_22_2, l_22_3)
  elseif l_22_1.category == "equipment_upgrade" then
    l_22_0:_aquire_equipment_upgrade(l_22_1, l_22_2, l_22_3)
  elseif l_22_1.category == "temporary" then
    l_22_0:_aquire_temporary(l_22_1, l_22_2, l_22_3)
  elseif l_22_1.category == "team" then
    l_22_0:_aquire_team(l_22_1, l_22_2, l_22_3)
  elseif l_22_1.category == "armor" then
    l_22_0:_aquire_armor(l_22_1, l_22_2, l_22_3)
  elseif l_22_1.category == "rep_upgrade" then
    l_22_0:_aquire_rep_upgrade(l_22_1, l_22_2, l_22_3)
  end
end

UpgradesManager._unaquire_upgrade = function(l_23_0, l_23_1, l_23_2)
  if l_23_1.category == "weapon" then
    l_23_0:_unaquire_weapon(l_23_1, l_23_2)
  elseif l_23_1.category == "feature" then
    l_23_0:_unaquire_feature(l_23_1, l_23_2)
  elseif l_23_1.category == "equipment" then
    l_23_0:_unaquire_equipment(l_23_1, l_23_2)
  elseif l_23_1.category == "equipment_upgrade" then
    l_23_0:_unaquire_equipment_upgrade(l_23_1, l_23_2)
  elseif l_23_1.category == "temporary" then
    l_23_0:_unaquire_temporary(l_23_1, l_23_2)
  elseif l_23_1.category == "team" then
    l_23_0:_unaquire_team(l_23_1, l_23_2)
  elseif l_23_1.category == "armor" then
    l_23_0:_unaquire_armor(l_23_1, l_23_2)
  end
end

UpgradesManager._aquire_weapon = function(l_24_0, l_24_1, l_24_2, l_24_3)
  managers.player:aquire_weapon(l_24_1, l_24_2)
  managers.blackmarket:on_aquired_weapon_platform(l_24_1, l_24_2, l_24_3)
end

UpgradesManager._unaquire_weapon = function(l_25_0, l_25_1, l_25_2)
  managers.player:unaquire_weapon(l_25_1, l_25_2)
  managers.blackmarket:on_unaquired_weapon_platform(l_25_1, l_25_2)
end

UpgradesManager._aquire_feature = function(l_26_0, l_26_1)
  if l_26_1.incremental then
    managers.player:aquire_incremental_upgrade(l_26_1.upgrade)
  else
    managers.player:aquire_upgrade(l_26_1.upgrade)
  end
end

UpgradesManager._unaquire_feature = function(l_27_0, l_27_1)
  if l_27_1.incremental then
    managers.player:unaquire_incremental_upgrade(l_27_1.upgrade)
  else
    managers.player:unaquire_upgrade(l_27_1.upgrade)
  end
end

UpgradesManager._aquire_equipment = function(l_28_0, l_28_1, l_28_2)
  managers.player:aquire_equipment(l_28_1, l_28_2)
end

UpgradesManager._unaquire_equipment = function(l_29_0, l_29_1, l_29_2)
  managers.player:unaquire_equipment(l_29_1, l_29_2)
end

UpgradesManager._aquire_equipment_upgrade = function(l_30_0, l_30_1)
  managers.player:aquire_upgrade(l_30_1.upgrade)
end

UpgradesManager._unaquire_equipment_upgrade = function(l_31_0, l_31_1)
  managers.player:unaquire_upgrade(l_31_1.upgrade)
end

UpgradesManager._aquire_temporary = function(l_32_0, l_32_1, l_32_2)
  if l_32_1.incremental then
    managers.player:aquire_incremental_upgrade(l_32_1.upgrade)
  else
    managers.player:aquire_upgrade(l_32_1.upgrade, l_32_2)
  end
end

UpgradesManager._unaquire_temporary = function(l_33_0, l_33_1, l_33_2)
  if l_33_1.incremental then
    managers.player:unaquire_incremental_upgrade(l_33_1.upgrade)
  else
    managers.player:unaquire_upgrade(l_33_1.upgrade)
  end
end

UpgradesManager._aquire_team = function(l_34_0, l_34_1, l_34_2)
  managers.player:aquire_team_upgrade(l_34_1.upgrade, l_34_2)
end

UpgradesManager._unaquire_team = function(l_35_0, l_35_1, l_35_2)
  managers.player:unaquire_team_upgrade(l_35_1.upgrade, l_35_2)
end

UpgradesManager._aquire_armor = function(l_36_0, l_36_1, l_36_2, l_36_3)
  managers.blackmarket:on_aquired_armor(l_36_1, l_36_2, l_36_3)
end

UpgradesManager._unaquire_armor = function(l_37_0, l_37_1, l_37_2)
  managers.blackmarket:on_unaquired_armor(l_37_1, l_37_2)
end

UpgradesManager._aquire_rep_upgrade = function(l_38_0, l_38_1, l_38_2)
  managers.skilltree:rep_upgrade(l_38_1, l_38_2)
end

UpgradesManager.get_value = function(l_39_0, l_39_1)
  local upgrade = tweak_data.upgrades.definitions[l_39_1]
  local u = upgrade.upgrade
  if upgrade.category == "feature" then
    return tweak_data.upgrades.values[u.category][u.upgrade][u.value]
  elseif upgrade.category == "equipment" then
    return upgrade.equipment_id
  elseif upgrade.category == "equipment_upgrade" then
    return tweak_data.upgrades.values[u.category][u.upgrade][u.value]
  elseif upgrade.category == "temporary" then
    local temporary = tweak_data.upgrades.values[u.category][u.upgrade][u.value]
    return "Value: " .. tostring(temporary[1]) .. " Time: " .. temporary[2]
  elseif upgrade.category == "team" then
    local value = tweak_data.upgrades.values.team[u.category][u.upgrade][u.value]
    return value
  end
  print("no value for", l_39_1, upgrade.category)
end

UpgradesManager.get_category = function(l_40_0, l_40_1)
  local upgrade = tweak_data.upgrades.definitions[l_40_1]
  return upgrade.category
end

UpgradesManager.get_upgrade_upgrade = function(l_41_0, l_41_1)
  local upgrade = tweak_data.upgrades.definitions[l_41_1]
  return upgrade.upgrade
end

UpgradesManager.is_locked = function(l_42_0, l_42_1)
  local level = managers.experience:current_level()
  for i,d in ipairs(tweak_data.upgrades.itree_caps) do
    if d.step > l_42_1 then
      return level >= d.level
    end
  end
  return false
end

UpgradesManager.get_level_from_step = function(l_43_0, l_43_1)
  for i,d in ipairs(tweak_data.upgrades.itree_caps) do
    if l_43_1 == d.step then
      return d.level
    end
  end
  return 0
end

UpgradesManager.progress = function(l_44_0)
  if managers.dlc:has_preorder() then
    return {l_44_0._global.progress[1], l_44_0._global.progress[2], l_44_0._global.progress[3], l_44_0._global.progress[4]}
  end
  return {l_44_0._global.progress[1], l_44_0._global.progress[2], l_44_0._global.progress[3]}
end

UpgradesManager.progress_by_tree = function(l_45_0, l_45_1)
  return l_45_0._global.progress[l_45_1]
end

UpgradesManager.name = function(l_46_0, l_46_1)
  if not tweak_data.upgrades.definitions[l_46_1] then
    Application:error("Tried to get name from an upgrade that doesn't exist: " .. l_46_1 .. "")
    return 
  end
  local upgrade = tweak_data.upgrades.definitions[l_46_1]
  return managers.localization:text(upgrade.name_id)
end

UpgradesManager.title = function(l_47_0, l_47_1)
  if not tweak_data.upgrades.definitions[l_47_1] then
    Application:error("Tried to get title from an upgrade that doesn't exist: " .. l_47_1 .. "")
    return 
  end
  local upgrade = tweak_data.upgrades.definitions[l_47_1]
  return upgrade.title_id and managers.localization:text(upgrade.title_id) or nil
end

UpgradesManager.subtitle = function(l_48_0, l_48_1)
  if not tweak_data.upgrades.definitions[l_48_1] then
    Application:error("Tried to get subtitle from an upgrade that doesn't exist: " .. l_48_1 .. "")
    return 
  end
  local upgrade = tweak_data.upgrades.definitions[l_48_1]
  return upgrade.subtitle_id and managers.localization:text(upgrade.subtitle_id) or nil
end

UpgradesManager.complete_title = function(l_49_0, l_49_1, l_49_2)
  local title = l_49_0:title(l_49_1)
  if not title then
    return nil
  end
  local subtitle = l_49_0:subtitle(l_49_1)
  if not subtitle then
    return title
  end
  if l_49_2 then
    if l_49_2 == "single" then
      return title .. " " .. subtitle
    else
      return title .. l_49_2 .. subtitle
    end
  end
  return title .. "\n" .. subtitle
end

UpgradesManager.description = function(l_50_0, l_50_1)
  if not tweak_data.upgrades.definitions[l_50_1] then
    Application:error("Tried to get description from an upgrade that doesn't exist: " .. l_50_1 .. "")
    return 
  end
  local upgrade = tweak_data.upgrades.definitions[l_50_1]
  return managers.localization:text(not upgrade.subtitle_id or l_50_1) or managers.localization:text(not upgrade.subtitle_id or l_50_1) or nil
end

UpgradesManager.image = function(l_51_0, l_51_1)
  local image = tweak_data.upgrades.definitions[l_51_1].image
  if not image then
    return nil, nil
  end
  return tweak_data.hud_icons:get_icon_data(image)
end

UpgradesManager.image_slice = function(l_52_0, l_52_1)
  local image_slice = tweak_data.upgrades.definitions[l_52_1].image_slice
  if not image_slice then
    return nil, nil
  end
  return tweak_data.hud_icons:get_icon_data(image_slice)
end

UpgradesManager.icon = function(l_53_0, l_53_1)
  if not tweak_data.upgrades.definitions[l_53_1] then
    Application:error("Tried to aquire an upgrade that doesn't exist: " .. l_53_1 .. "")
    return 
  end
  return tweak_data.upgrades.definitions[l_53_1].icon
end

UpgradesManager.aquired_by_category = function(l_54_0, l_54_1)
  local t = {}
  for name,_ in pairs(l_54_0._global.aquired) do
    if tweak_data.upgrades.definitions[name].category == l_54_1 then
      table.insert(t, name)
    end
  end
  return t
end

UpgradesManager.aquired_features = function(l_55_0)
  return l_55_0:aquired_by_category("feature")
end

UpgradesManager.aquired_weapons = function(l_56_0)
  return l_56_0:aquired_by_category("weapon")
end

UpgradesManager.all_weapon_upgrades = function(l_57_0)
  for id,data in pairs(tweak_data.upgrades.definitions) do
    if data.category == "weapon" then
      print(id)
    end
  end
end

UpgradesManager.weapon_upgrade_by_weapon_id = function(l_58_0, l_58_1)
  for id,data in pairs(tweak_data.upgrades.definitions) do
    if data.category == "weapon" and data.weapon_id == l_58_1 then
      return data
    end
  end
end

UpgradesManager.weapon_upgrade_by_factory_id = function(l_59_0, l_59_1)
  for id,data in pairs(tweak_data.upgrades.definitions) do
    if data.category == "weapon" and data.factory_id == l_59_1 then
      return data
    end
  end
end

UpgradesManager.print_aquired_tree = function(l_60_0)
  local tree = {}
  for name,data in pairs(l_60_0._global.aquired) do
    tree[data.level] = {name = name}
  end
  for i,data in pairs(tree) do
    print(l_60_0:name(data.name))
  end
end

UpgradesManager.analyze = function(l_61_0)
  local not_placed = {}
  local placed = {}
  local features = {}
  local amount = 0
  for lvl,upgrades in pairs(tweak_data.upgrades.levels) do
    print("Upgrades at level " .. lvl .. ":")
    for _,upgrade in ipairs(upgrades) do
      print("\t" .. upgrade)
    end
  end
  for name,data in pairs(tweak_data.upgrades.definitions) do
    amount = amount + 1
    for lvl,upgrades in pairs(tweak_data.upgrades.levels) do
      for _,upgrade in ipairs(upgrades) do
        if upgrade == name then
          if placed[name] then
            print("ERROR: Upgrade " .. name .. " is already placed in level " .. placed[name] .. "!")
          else
            placed[name] = lvl
          end
          if data.category == "feature" then
            if not features[data.upgrade.category] then
              features[data.upgrade.category] = {}
            end
            table.insert(features[data.upgrade.category], {level = lvl, name = name})
          end
        end
      end
    end
    if not placed[name] then
      not_placed[name] = true
    end
  end
  for name,lvl in pairs(placed) do
    print("Upgrade " .. name .. " is placed in level\t\t " .. lvl .. ".")
  end
  for name,_ in pairs(not_placed) do
    print("Upgrade " .. name .. " is not placed any level!")
  end
  print("")
  for category,upgrades in pairs(features) do
    print("Upgrades for category " .. category .. " is recieved at:")
    for _,upgrade in ipairs(upgrades) do
      print("  Level: " .. upgrade.level .. ", " .. upgrade.name .. "")
    end
  end
  print("\nTotal upgrades " .. amount .. ".")
end

UpgradesManager.tree_stats = function(l_62_0)
  local t = {{u = {}, a = 0}, {u = {}, a = 0}, {u = {}, a = 0}}
  for name,d in pairs(tweak_data.upgrades.definitions) do
    if d.tree then
      t[d.tree].a = t[d.tree].a + 1
      table.insert(t[d.tree].u, name)
    end
  end
  for i,d in ipairs(t) do
    print(inspect(d.u))
    print(d.a)
  end
end

UpgradesManager.save = function(l_63_0, l_63_1)
  local state = {automanage = l_63_0._global.automanage, progress = l_63_0._global.progress, target_tree = l_63_0._global.target_tree, disabled_visual_upgrades = l_63_0._global.disabled_visual_upgrades}
  if l_63_0._global.incompatible_data_loaded and l_63_0._global.incompatible_data_loaded.progress then
    state.progress = clone(l_63_0._global.progress)
    for i,k in pairs(l_63_0._global.incompatible_data_loaded.progress) do
      print("saving incompatible data", i, k)
      state.progress[i] = math.max(state.progress[i], k)
    end
  end
  l_63_1.UpgradesManager = state
end

UpgradesManager.load = function(l_64_0, l_64_1)
  local state = l_64_1.UpgradesManager
  l_64_0._global.automanage = state.automanage
  l_64_0._global.progress = state.progress
  l_64_0._global.target_tree = state.target_tree
  l_64_0._global.disabled_visual_upgrades = state.disabled_visual_upgrades
  l_64_0:_verify_loaded_data()
end

UpgradesManager._verify_loaded_data = function(l_65_0)
end

UpgradesManager.reset = function(l_66_0)
  Global.upgrades_manager = nil
  l_66_0:_setup()
end


