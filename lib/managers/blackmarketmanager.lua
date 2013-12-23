-- Decompiled using luadec 2.0.1 by sztupy (http://winmo.sztupy.hu)
-- Command line was: F:\SteamLibrary\SteamApps\common\PAYDAY 2\lua\lib\managers\blackmarketmanager.luac 

if not BlackMarketManager then
  BlackMarketManager = class()
end
local INV_TO_CRAFT = Idstring("inventory_to_crafted")
local CRAFT_TO_INV = Idstring("crafted_to_inventroy")
local INV_ADD = Idstring("add_to_inventory")
local INV_REMOVE = Idstring("remove_from_inventory")
local CRAFT_ADD = Idstring("add_to_crafted")
local CRAFT_REMOVE = Idstring("remove_from_crafted")
BlackMarketManager.init = function(l_1_0)
  l_1_0:_setup()
end

BlackMarketManager._setup = function(l_2_0)
  l_2_0._defaults = {}
  l_2_0._defaults.mask = "character_locked"
  l_2_0._defaults.character = "locked"
  l_2_0._defaults.armor = "level_1"
  l_2_0._defaults.preferred_character = "russian"
  if not Global.blackmarket_manager then
    Global.blackmarket_manager = {}
    l_2_0:_setup_armors()
    l_2_0:_setup_weapons()
    l_2_0:_setup_characters()
    l_2_0:_setup_track_global_values()
    Global.blackmarket_manager.inventory = {}
    Global.blackmarket_manager.crafted_items = {}
    Global.blackmarket_manager.new_drops = {}
    Global.blackmarket_manager.new_item_type_unlocked = {}
  end
  l_2_0._global = Global.blackmarket_manager
  l_2_0._preloading_list = {}
  l_2_0._preloading_index = 0
  l_2_0._category_resource_loaded = {}
end

BlackMarketManager.init_finalize = function(l_3_0)
  print("BlackMarketManager:init_finalize()")
  managers.savefile:add_load_sequence_done_callback_handler(callback(l_3_0, l_3_0, "_load_done"))
end

BlackMarketManager._setup_armors = function(l_4_0)
  local armors = {}
  Global.blackmarket_manager.armors = armors
  for armor,_ in pairs(tweak_data.blackmarket.armors) do
    armors[armor] = {unlocked = false, owned = false, equipped = false}
  end
  armors[l_4_0._defaults.armor].owned = true
  armors[l_4_0._defaults.armor].equipped = true
  armors[l_4_0._defaults.armor].unlocked = true
end

BlackMarketManager._setup_track_global_values = function(l_5_0)
  if not l_5_0._global or not l_5_0._global.global_value_items then
    local global_value_items = {}
  end
  Global.blackmarket_manager.global_value_items = global_value_items
  for gv,td in pairs(tweak_data.lootdrop.global_values) do
    if td.track then
      if not global_value_items[gv] then
        global_value_items[gv] = {}
      end
      if not global_value_items[gv].crafted_items then
        global_value_items[gv].crafted_items = {}
      end
      if not global_value_items[gv].inventory then
        global_value_items[gv].inventory = {}
      end
    end
  end
end

BlackMarketManager._setup_masks = function(l_6_0)
  local masks = {}
  Global.blackmarket_manager.masks = masks
  for mask,_ in pairs(tweak_data.blackmarket.masks) do
    masks[mask] = {unlocked = true, owned = true, equipped = false}
  end
  masks[l_6_0._defaults.mask].owned = true
  masks[l_6_0._defaults.mask].equipped = true
end

BlackMarketManager._setup_characters = function(l_7_0)
  local characters = {}
  Global.blackmarket_manager.characters = characters
  for character,_ in pairs(tweak_data.blackmarket.characters) do
    characters[character] = {unlocked = true, owned = true, equipped = false}
  end
  characters[l_7_0._defaults.character].owned = true
  characters[l_7_0._defaults.character].equipped = true
  Global.blackmarket_manager._preferred_character = l_7_0._defaults.preferred_character
end

BlackMarketManager._setup_weapon_upgrades = function(l_8_0)
  local weapon_upgrades = {}
  Global.blackmarket_manager.weapon_upgrades = weapon_upgrades
  for weapon,_ in pairs(tweak_data.weapon_upgrades.weapon) do
    weapon_upgrades[weapon] = {}
    for upgrades,data in pairs(tweak_data.weapon_upgrades.weapon[weapon]) do
      for _,upgrade in ipairs(data) do
        weapon_upgrades[weapon][upgrade] = {unlocked = true, owned = true, attached = false}
      end
    end
  end
  weapon_upgrades.m4.m4_scope1.attached = false
  weapon_upgrades.m4.scope2.owned = false
  weapon_upgrades.m4.scope3.unlocked = false
  weapon_upgrades.m4.scope3.owned = false
  weapon_upgrades.m4.grip1.unlocked = false
  weapon_upgrades.m4.grip1.owned = false
  weapon_upgrades.m14.m14_scope1.attached = true
  weapon_upgrades.m14.m14_scope2.owned = false
  weapon_upgrades.m14.barrel1.owned = false
  weapon_upgrades.m14.scope3.unlocked = false
  weapon_upgrades.m14.scope3.owned = false
  weapon_upgrades.raging_bull.grip1.unlocked = false
  weapon_upgrades.raging_bull.grip1.owned = false
end

BlackMarketManager._setup_weapons = function(l_9_0)
  local weapons = {}
  Global.blackmarket_manager.weapons = weapons
  for weapon,data in pairs(tweak_data.weapon) do
    if data.autohit then
      local selection_index = data.use_data.selection_index
      local equipped = weapon == managers.player:weapon_in_slot(selection_index)
      local factory_id = managers.weapon_factory:get_factory_id_by_weapon_id(weapon)
      weapons[weapon] = {owned = false, unlocked = false, factory_id = factory_id, selection_index = selection_index}
    end
  end
end

BlackMarketManager.weapons_to_buy = {}
BlackMarketManager.weapons_to_buy.mac11 = true
BlackMarketManager.weapons_to_buy.raging_bull = true
BlackMarketManager.mask_data = function(l_10_0, l_10_1)
  return Global.blackmarket_manager.masks[l_10_1]
end

BlackMarketManager.weapon_unlocked = function(l_11_0, l_11_1)
  return Global.blackmarket_manager.weapons[l_11_1].unlocked
end

BlackMarketManager.weapon_level = function(l_12_0, l_12_1)
  for level,level_data in pairs(tweak_data.upgrades.level_tree) do
    for _,upgrade in ipairs(level_data.upgrades) do
      if upgrade == l_12_1 then
        return level
      end
    end
  end
  return 0
end

BlackMarketManager.equipped_item = function(l_13_0, l_13_1)
  if l_13_1 == "primaries" then
    return l_13_0:equipped_primary()
  elseif l_13_1 == "secondaries" then
    return l_13_0:equipped_secondary()
  elseif l_13_1 == "masks" then
    return l_13_0:equipped_mask()
  elseif l_13_1 == "character" then
    return l_13_0:equipped_character()
  elseif l_13_1 == "armors" then
    return l_13_0:equipped_armor()
  end
end

BlackMarketManager.equipped_character = function(l_14_0)
  for character_id,data in pairs(tweak_data.blackmarket.characters) do
    if Global.blackmarket_manager.characters[character_id].equipped then
      return character_id
    end
  end
end

BlackMarketManager.equipped_mask = function(l_15_0)
  if not Global.blackmarket_manager.crafted_items.masks then
    l_15_0:aquire_default_masks()
  end
  for slot,data in pairs(Global.blackmarket_manager.crafted_items.masks) do
    if data.equipped then
      return data
    end
  end
end

BlackMarketManager.equipped_mask_slot = function(l_16_0)
  if not Global.blackmarket_manager.crafted_items.masks then
    l_16_0:aquire_default_masks()
  end
  for slot,data in pairs(Global.blackmarket_manager.crafted_items.masks) do
    if data.equipped then
      return slot
    end
  end
end

BlackMarketManager.equipped_armor = function(l_17_0)
  local armor = nil
  for armor_id,data in pairs(tweak_data.blackmarket.armors) do
    armor = Global.blackmarket_manager.armors[armor_id]
    if armor.equipped and armor.unlocked and armor.owned then
      return armor_id
    end
  end
  return l_17_0._defaults.armor
end

BlackMarketManager.equipped_secondary = function(l_18_0)
  if not Global.blackmarket_manager.crafted_items.secondaries then
    l_18_0:aquire_default_weapons()
  end
  for slot,data in pairs(Global.blackmarket_manager.crafted_items.secondaries) do
    if data.equipped then
      return data
    end
  end
  l_18_0:aquire_default_weapons()
end

BlackMarketManager.equipped_primary = function(l_19_0)
  if not Global.blackmarket_manager.crafted_items.primaries then
    return nil
  end
  for slot,data in pairs(Global.blackmarket_manager.crafted_items.primaries) do
    if data.equipped then
      return data
    end
  end
  return nil
end

BlackMarketManager.equipped_weapon_slot = function(l_20_0, l_20_1)
  if not Global.blackmarket_manager.crafted_items[l_20_1] then
    return nil
  end
  for slot,data in pairs(Global.blackmarket_manager.crafted_items[l_20_1]) do
    if data.equipped then
      return slot
    end
  end
  return nil
end

BlackMarketManager.equip_weapon = function(l_21_0, l_21_1, l_21_2)
  if not Global.blackmarket_manager.crafted_items[l_21_1] then
    return nil
  end
  for s,data in pairs(Global.blackmarket_manager.crafted_items[l_21_1]) do
    data.equipped = s == l_21_2
  end
  if managers.menu_scene then
    if l_21_1 ~= "primaries" or not l_21_0:equipped_primary() then
      local data = l_21_0:equipped_secondary()
    end
    managers.menu_scene:set_character_equipped_weapon(nil, data.factory_id, data.blueprint, l_21_1 == "primaries" and "primary" or "secondary")
  end
  MenuCallbackHandler:_update_outfit_information()
end

BlackMarketManager.equip_deployable = function(l_22_0, l_22_1)
  Global.player_manager.kit.equipment_slots[1] = l_22_1
  MenuCallbackHandler:_update_outfit_information()
end

BlackMarketManager.equip_armor = function(l_23_0, l_23_1)
  for s,data in pairs(Global.blackmarket_manager.armors) do
    data.equipped = s == l_23_1
  end
  local equipped = managers.blackmarket:equipped_armor()
  if equipped ~= tweak_data.achievement.how_do_you_like_me_now then
    managers.achievment:award("how_do_you_like_me_now")
  end
  if equipped == tweak_data.achievement.iron_man then
    managers.achievment:award("iron_man")
  end
  if managers.menu_scene then
    managers.menu_scene:set_character_armor(l_23_1)
  end
  MenuCallbackHandler:_update_outfit_information()
end

BlackMarketManager._update_cached_mask = function(l_24_0)
  return 
  if SystemInfo:platform() ~= Idstring("X360") then
    return 
  end
  Application:debug("[BlackMarketManager:_update_cached_mask()]")
  local old_cached_mask = Global.cached_player_mask
  if old_cached_mask and old_cached_mask.mask_id ~= "character_locked" then
    local blueprint = old_cached_mask.blueprint
    local pattern_id = blueprint.pattern.id
    local material_id = blueprint.material.id
    local pattern = Idstring(tweak_data.blackmarket.textures[pattern_id].texture)
    local reflection = Idstring(tweak_data.blackmarket.materials[material_id].texture)
    managers.dyn_resource:unload(Idstring("unit"), Idstring(tweak_data.blackmarket.masks[old_cached_mask.mask_id].unit), DynamicResourceManager.DYN_RESOURCES_PACKAGE, false)
    TextureCache:unretrieve(pattern)
    TextureCache:unretrieve(reflection)
  end
  Global.cached_player_mask = nil
end

BlackMarketManager.equip_mask = function(l_25_0, l_25_1)
  local category = "masks"
  if not Global.blackmarket_manager.crafted_items[category] then
    return nil
  end
  for s,data in pairs(Global.blackmarket_manager.crafted_items[category]) do
    data.equipped = s == l_25_1
  end
  local new_mask_data = Global.blackmarket_manager.crafted_items[category][l_25_1]
  if managers.menu_scene then
    managers.menu_scene:set_character_mask_by_id(new_mask_data.mask_id, new_mask_data.blueprint)
  end
  if SystemInfo:platform() == Idstring("X360") then
    do return end
    local old_cached_mask = Global.cached_player_mask
    Global.cached_player_mask = new_mask_data
    Application:debug("[BlackMarketManager:equip_mask()] Set cached mask")
    if new_mask_data and new_mask_data.mask_id ~= "character_locked" then
      local blueprint = new_mask_data.blueprint
      local pattern_id = blueprint.pattern.id
      local material_id = blueprint.material.id
      local pattern = tweak_data.blackmarket.textures[pattern_id].texture
      local reflection = tweak_data.blackmarket.materials[material_id].texture
      managers.dyn_resource:load(Idstring("unit"), Idstring(tweak_data.blackmarket.masks[new_mask_data.mask_id].unit), DynamicResourceManager.DYN_RESOURCES_PACKAGE, false)
      TextureCache:retrieve(pattern, "NORMAL")
      TextureCache:retrieve(reflection, "NORMAL")
    end
    if old_cached_mask and old_cached_mask.mask_id ~= "character_locked" then
      local blueprint = old_cached_mask.blueprint
      local pattern_id = blueprint.pattern.id
      local material_id = blueprint.material.id
      local pattern = Idstring(tweak_data.blackmarket.textures[pattern_id].texture)
      local reflection = Idstring(tweak_data.blackmarket.materials[material_id].texture)
      managers.dyn_resource:unload(Idstring("unit"), Idstring(tweak_data.blackmarket.masks[old_cached_mask.mask_id].unit), DynamicResourceManager.DYN_RESOURCES_PACKAGE, false)
      TextureCache:unretrieve(pattern)
      TextureCache:unretrieve(reflection)
    end
  end
  MenuCallbackHandler:_update_outfit_information()
end

BlackMarketManager.mask_blueprint_from_outfit_string = function(l_26_0, l_26_1)
  local data = string.split(l_26_1, " ")
  local color_id = data[l_26_0:outfit_string_index("mask_color")]
  local pattern_id = data[l_26_0:outfit_string_index("mask_pattern")]
  local material_id = data[l_26_0:outfit_string_index("mask_material")]
  local blueprint = {}
  blueprint.color = {id = color_id}
  blueprint.pattern = {id = pattern_id}
  blueprint.material = {id = material_id}
  return blueprint
end

BlackMarketManager._outfit_string_mask = function(l_27_0)
  local s = ""
  local equipped = managers.blackmarket:equipped_mask()
  if type(equipped) == "string" then
    s = s .. " " .. equipped
    s = s .. " " .. "nothing"
    s = s .. " " .. "no_color_no_material"
    s = s .. " " .. "plastic"
  else
    s = s .. " " .. equipped.mask_id
    s = s .. " " .. equipped.blueprint.color.id
    s = s .. " " .. equipped.blueprint.pattern.id
    s = s .. " " .. equipped.blueprint.material.id
  end
  return s
end

BlackMarketManager.outfit_string_index = function(l_28_0, l_28_1)
  if l_28_1 == "mask" then
    return 1
  end
  if l_28_1 == "mask_color" then
    return 2
  end
  if l_28_1 == "mask_pattern" then
    return 3
  end
  if l_28_1 == "mask_material" then
    return 4
  end
  if l_28_1 == "armor" then
    return 5
  end
  if l_28_1 == "character" then
    return 6
  end
  if l_28_1 == "primary" then
    return 7
  end
  if l_28_1 == "primary_blueprint" then
    return 8
  end
  if l_28_1 == "secondary" then
    return 9
  end
  if l_28_1 == "secondary_blueprint" then
    return 10
  end
  if l_28_1 == "deployable" then
    return 11
  end
  if l_28_1 == "concealment_modifier" then
    return 12
  end
end

BlackMarketManager.unpack_outfit_from_string = function(l_29_0, l_29_1)
  local data = string.split(l_29_1, " ")
  local outfit = {}
  outfit.character = data[l_29_0:outfit_string_index("character")]
  outfit.mask = {}
  outfit.mask.mask_id = data[l_29_0:outfit_string_index("mask")]
  outfit.mask.blueprint = l_29_0:mask_blueprint_from_outfit_string(l_29_1)
  outfit.armor = data[l_29_0:outfit_string_index("armor")]
  local primary_blueprint_string = string.gsub(data[l_29_0:outfit_string_index("primary_blueprint")], "_", " ")
  local secondary_blueprint_string = string.gsub(data[l_29_0:outfit_string_index("secondary_blueprint")], "_", " ")
  outfit.primary = {}
  outfit.primary.factory_id = data[l_29_0:outfit_string_index("primary")]
  outfit.primary.blueprint = managers.weapon_factory:unpack_blueprint_from_string(outfit.primary.factory_id, primary_blueprint_string)
  outfit.secondary = {}
  outfit.secondary.factory_id = data[l_29_0:outfit_string_index("secondary")]
  outfit.secondary.blueprint = managers.weapon_factory:unpack_blueprint_from_string(outfit.secondary.factory_id, secondary_blueprint_string)
  outfit.deployable = data[l_29_0:outfit_string_index("deployable")]
  outfit.concealment_modifier = data[l_29_0:outfit_string_index("concealment_modifier")]
  return outfit
end

BlackMarketManager.outfit_string = function(l_30_0)
  local s = ""
  s = s .. l_30_0:_outfit_string_mask()
  for armor_id,data in pairs(tweak_data.blackmarket.armors) do
    if Global.blackmarket_manager.armors[armor_id].equipped then
      s = s .. " " .. armor_id
    end
  end
  for character_id,data in pairs(tweak_data.blackmarket.characters) do
    if Global.blackmarket_manager.characters[character_id].equipped then
      s = s .. " " .. character_id
    end
  end
  local equipped_primary = l_30_0:equipped_primary()
  if equipped_primary then
    local primary_string = managers.weapon_factory:blueprint_to_string(equipped_primary.factory_id, equipped_primary.blueprint)
    primary_string = string.gsub(primary_string, " ", "_")
    s = s .. " " .. equipped_primary.factory_id .. " " .. primary_string
  else
    s = s .. " " .. "nil" .. " " .. "0"
  end
  local equipped_secondary = l_30_0:equipped_secondary()
  if equipped_secondary then
    local secondary_string = managers.weapon_factory:blueprint_to_string(equipped_secondary.factory_id, equipped_secondary.blueprint)
    secondary_string = string.gsub(secondary_string, " ", "_")
    s = s .. " " .. equipped_secondary.factory_id .. " " .. secondary_string
  else
    s = s .. " " .. "nil" .. " " .. "0"
  end
  local equipped_deployable = Global.player_manager.kit.equipment_slots[1]
  if equipped_deployable then
    s = s .. " " .. tostring(equipped_deployable)
  else
    s = s .. " " .. "nil"
  end
  local concealment_modifier = l_30_0:concealment_modifiers() or 0
  s = s .. " " .. tostring(concealment_modifier)
  return s
end

BlackMarketManager.load_equipped_weapons = function(l_31_0)
  do
    local weapon = l_31_0:equipped_primary()
    managers.weapon_factory:preload_blueprint(weapon.factory_id, weapon.blueprint, false, callback(l_31_0, l_31_0, "resource_loaded_callback", "primaries"), false)
  end
  local weapon = l_31_0:equipped_secondary()
  managers.weapon_factory:preload_blueprint(weapon.factory_id, weapon.blueprint, false, callback(l_31_0, l_31_0, "resource_loaded_callback", "secondaries"), false)
end

BlackMarketManager.load_all_crafted_weapons = function(l_32_0)
  print("--PRIMARIES-------------------------")
  for i,weapon in pairs(l_32_0._global.crafted_items.primaries) do
    print("loading crafted weapon", "index", i, "weapon", weapon)
    managers.weapon_factory:preload_blueprint(weapon.factory_id, weapon.blueprint, false, callback(l_32_0, l_32_0, "resource_loaded_callback", "primaries" .. tostring(i)), false)
  end
  print("--SECONDARIES-----------------------")
  for i,weapon in pairs(l_32_0._global.crafted_items.secondaries) do
    print("loading crafted weapon", "index", i, "weapon", weapon)
    managers.weapon_factory:preload_blueprint(weapon.factory_id, weapon.blueprint, false, callback(l_32_0, l_32_0, "resource_loaded_callback", "secondaries" .. tostring(i)), false)
  end
end

BlackMarketManager.preload_equipped_weapons = function(l_33_0)
  l_33_0:preload_primary_weapon()
  l_33_0:preload_secondary_weapon()
end

BlackMarketManager.preload_primary_weapon = function(l_34_0)
  local weapon = l_34_0:equipped_primary()
  l_34_0:preload_weapon_blueprint("primaries", weapon.factory_id, weapon.blueprint)
end

BlackMarketManager.preload_secondary_weapon = function(l_35_0)
  local weapon = l_35_0:equipped_secondary()
  l_35_0:preload_weapon_blueprint("secondaries", weapon.factory_id, weapon.blueprint)
end

BlackMarketManager.preload_weapon_blueprint = function(l_36_0, l_36_1, l_36_2, l_36_3)
  Application:debug("[BlackMarketManager] preload_weapon_blueprint():", "category", l_36_1, "factory_id", l_36_2, "blueprint", inspect(l_36_3))
  managers.weapon_factory:preload_blueprint(l_36_2, l_36_3, false, callback(l_36_0, l_36_0, "preload_done_callback", l_36_1), true)
end

BlackMarketManager.preload_done_callback = function(l_37_0, l_37_1, l_37_2, l_37_3)
  print("preload_done_callback", l_37_1, inspect(l_37_2), inspect(l_37_3))
  local new_loading = nil
  for part_id,_preload in pairs(l_37_2) do
    if _preload.package then
      new_loading = {package = _preload.package}
    else
      new_loading = {load_me = _preload}
    end
    if Application:production_build() then
      new_loading.part_id = part_id
    end
    table.insert(l_37_0._preloading_list, new_loading)
  end
  table.insert(l_37_0._preloading_list, {l_37_1, l_37_2, l_37_3})
end

BlackMarketManager.resource_loaded_callback = function(l_38_0, l_38_1, l_38_2, l_38_3)
  print("resource_loaded_callback", l_38_1, inspect(l_38_2), inspect(l_38_3))
  do
    local loaded_category = l_38_0._category_resource_loaded[l_38_1]
    if loaded_category then
      Application:debug("[BlackMarketManager] resource_loaded_callback(): Unloading old blueprint", inspect(loaded_category))
      for part_id,unload in pairs(loaded_category) do
        if unload.package then
          managers.weapon_factory:unload_package(unload.package)
          for (for control),part_id in (for generator) do
          end
          managers.dyn_resource:unload(unpack(unload))
        end
      end
      l_38_0._category_resource_loaded[l_38_1] = l_38_2
    end
     -- Warning: missing end command somewhere! Added here
  end
end

BlackMarketManager.release_preloaded_blueprints = function(l_39_0)
  Application:debug("[BlackMarketManager] release_preloaded_blueprints(): Unloading all blueprints", inspect(l_39_0._category_resource_loaded))
  for category,data in pairs(l_39_0._category_resource_loaded) do
    for part_id,unload in pairs(data) do
      if unload.package then
        managers.weapon_factory:unload_package(unload.package)
        for (for control),part_id in (for generator) do
        end
        managers.dyn_resource:unload(unpack(unload))
      end
    end
    l_39_0._category_resource_loaded = {}
     -- Warning: missing end command somewhere! Added here
  end
end

BlackMarketManager.is_preloading_weapons = function(l_40_0)
  return #l_40_0._preloading_list > 0
end

BlackMarketManager.create_preload_ws = function(l_41_0)
  if l_41_0._preload_ws then
    return 
  end
  l_41_0._preload_ws = managers.gui_data:create_fullscreen_workspace()
  local panel = l_41_0._preload_ws:panel()
  panel:set_layer(10000)
  local new_script = {}
  new_script.progress = 1
  new_script.step_progress = function()
    new_script.set_progress(new_script.progress + 1)
   end
  new_script.set_progress = function(l_2_0)
    new_script.progress = l_2_0
    local square_panel = panel:child("square_panel")
    local progress_rect = panel:child("progress")
    if l_2_0 == 0 then
      progress_rect:hide()
    end
    for i,child in ipairs(square_panel:children()) do
      if i >= l_2_0 or not Color.white then
        child:set_color(Color(0.30000001192093, 0.30000001192093, 0.30000001192093))
      end
      if i == l_2_0 then
        progress_rect:set_world_position(child:world_position())
        progress_rect:move(-3, -3)
        progress_rect:show()
      end
    end
   end
  panel:set_script(new_script)
  local square_panel = panel:panel({name = "square_panel", layer = 1})
  local num_squares = 0
  for i,preload in ipairs(l_41_0._preloading_list) do
    if preload.package or preload.load_me then
      num_squares = num_squares + 1
    end
  end
  local rows = math.max(1, math.ceil((num_squares) / 8))
  local next_row_at = math.ceil((num_squares) / rows)
  local row_index = 0
  local x = 0
  local y = 0
  local last_rect = nil
  local max_w = 0
  local max_h = 0
  for i = 1, num_squares do
    row_index = row_index + 1
    last_rect = square_panel:rect({x = x, y = y, w = 14, h = 14, color = Color(0.30000001192093, 0.30000001192093, 0.30000001192093), blend_mode = "add"})
    x = x + 24
    max_w = math.max(max_w, last_rect:right())
    max_h = math.max(max_h, last_rect:bottom())
    if row_index == next_row_at then
      row_index = 0
      y = y + 24
      x = 0
    end
  end
  square_panel:set_size(max_w, max_h)
  panel:rect({name = "progress", w = 20, h = 20, color = Color(0.30000001192093, 0.30000001192093, 0.30000001192093), layer = 2, blend_mode = "add"})
  local bg = panel:rect({color = Color.black, alpha = 0.80000001192093})
  local width = square_panel:w() + 20
  local height = square_panel:h() + 20
  bg:set_size(width, height)
  bg:set_center(panel:w() / 2, panel:h() / 2)
  square_panel:set_center(bg:center())
  local box_panel = panel:panel({layer = 2})
  box_panel:set_shape(bg:shape())
  BoxGuiObject:new(box_panel, {sides = {1, 1, 1, 1}})
  panel:script().set_progress(1)
  local fade_in_animation = function(l_3_0)
    l_3_0:hide()
    coroutine.yield()
    l_3_0:show()
   end
  panel:animate(fade_in_animation)
end

BlackMarketManager.update = function(l_42_0, l_42_1, l_42_2)
  if #l_42_0._preloading_list > 0 then
    if not l_42_0._preload_ws then
      l_42_0:create_preload_ws()
    else
      l_42_0._preloading_index = l_42_0._preloading_index + 1
      if #l_42_0._preloading_list < l_42_0._preloading_index then
        l_42_0._preloading_list = {}
        l_42_0._preloading_index = 0
        if l_42_0._preload_ws then
          Overlay:gui():destroy_workspace(l_42_0._preload_ws)
          l_42_0._preload_ws = nil
        else
          local next_in_line = l_42_0._preloading_list[l_42_0._preloading_index]
          if not next_in_line.package then
             -- DECOMPILER ERROR: Confused while interpreting a jump as a 'while'

          end
          local is_load = true
        end
         -- DECOMPILER ERROR: Confused while interpreting a jump as a 'while'

      end
      local is_done_cb = true
      if is_load then
        if not next_in_line.part_id or next_in_line.package then
          if l_42_0._preload_ws then
            l_42_0._preload_ws:panel():script().step_progress()
          end
          managers.weapon_factory:load_package(next_in_line.package)
        else
          managers.dyn_resource:load(unpack(next_in_line.load_me))
        end
      elseif is_done_cb then
        if l_42_0._preload_ws then
          l_42_0._preload_ws:panel():script().set_progress(l_42_0._preloading_index)
        end
        next_in_line.done_cb()
      elseif l_42_0._preload_ws then
        l_42_0._preload_ws:panel():script().set_progress(l_42_0._preloading_index)
      end
      l_42_0:resource_loaded_callback(unpack(next_in_line))
    end
  end
end
end
end

BlackMarketManager.add_to_inventory = function(l_43_0, l_43_1, l_43_2, l_43_3, l_43_4)
  if l_43_2 == "cash" then
    local value_id = tweak_data.blackmarket[l_43_2][l_43_3].value_id
    managers.money:on_loot_drop_cash(value_id)
  end
  if not l_43_0._global.inventory[l_43_1] then
    l_43_0._global.inventory[l_43_1] = {}
  end
  if not l_43_0._global.inventory[l_43_1][l_43_2] then
    l_43_0._global.inventory[l_43_1][l_43_2] = {}
  end
  l_43_0._global.inventory[l_43_1][l_43_2][l_43_3] = (l_43_0._global.inventory[l_43_1][l_43_2][l_43_3] or 0) + 1
  if not l_43_4 and l_43_2 ~= "cash" and l_43_0._global.inventory[l_43_1][l_43_2][l_43_3] > 0 then
    if not l_43_0._global.new_drops[l_43_1] then
      l_43_0._global.new_drops[l_43_1] = {}
    end
    if not l_43_0._global.new_drops[l_43_1][l_43_2] then
      l_43_0._global.new_drops[l_43_1][l_43_2] = {}
    end
    l_43_0._global.new_drops[l_43_1][l_43_2][l_43_3] = true
  end
  if l_43_0._global.new_item_type_unlocked[l_43_2] == nil and l_43_2 ~= "cash" then
    l_43_0._global.new_item_type_unlocked[l_43_2] = l_43_3
  end
  l_43_0:alter_global_value_item(l_43_1, l_43_2, nil, l_43_3, INV_ADD)
end

BlackMarketManager._add_gvi_to_inventory = function(l_44_0, l_44_1, l_44_2, l_44_3)
  if not l_44_0._global.global_value_items[l_44_1].inventory[l_44_2] then
    l_44_0._global.global_value_items[l_44_1].inventory[l_44_2] = {}
  end
  local inv_data = l_44_0._global.global_value_items[l_44_1].inventory[l_44_2]
  inv_data[l_44_3] = (inv_data[l_44_3] or 0) + 1
end

BlackMarketManager._remove_gvi_from_inventory = function(l_45_0, l_45_1, l_45_2, l_45_3)
  local inv_data = l_45_0._global.global_value_items[l_45_1].inventory[l_45_2]
  if not inv_data[l_45_3] then
    inv_data[l_45_3] = (not inv_data or 0) - 1
    if inv_data[l_45_3] <= 0 then
      inv_data[l_45_3] = nil
    end
     -- Warning: missing end command somewhere! Added here
  end
end

BlackMarketManager._add_gvi_to_crafted_item = function(l_46_0, l_46_1, l_46_2, l_46_3, l_46_4)
  if not l_46_0._global.global_value_items[l_46_1].crafted_items[l_46_2] then
    l_46_0._global.global_value_items[l_46_1].crafted_items[l_46_2] = {}
  end
  local craft_data = l_46_0._global.global_value_items[l_46_1].crafted_items[l_46_2]
  if not craft_data[l_46_3] then
    craft_data[l_46_3] = {}
  end
  craft_data[l_46_3][l_46_4] = (craft_data[l_46_3][l_46_4] or 0) + 1
end

BlackMarketManager._remove_gvi_from_crafted_item = function(l_47_0, l_47_1, l_47_2, l_47_3, l_47_4)
  local craft_data = l_47_0._global.global_value_items[l_47_1].crafted_items[l_47_2]
  if craft_data then
    craft_data = craft_data[l_47_3]
    if not craft_data[l_47_4] then
      craft_data[l_47_4] = (not craft_data or 0) - 1
      if craft_data[l_47_4] <= 0 then
        craft_data[l_47_4] = nil
      end
    end
     -- Warning: missing end command somewhere! Added here
  end
end

BlackMarketManager.alter_global_value_item = function(l_48_0, l_48_1, l_48_2, l_48_3, l_48_4, ...)
  if not l_48_0._global.global_value_items or not l_48_0._global.global_value_items[l_48_1] then
    return 
  end
  do
    local args = {...}
    for _,arg in pairs(args) do
      if arg == INV_TO_CRAFT then
        Application:debug("INV_TO_CRAFT is bugged for weapons, if this is from a weapon, change it!")
        l_48_0:_remove_gvi_from_inventory(l_48_1, l_48_2, l_48_4)
        l_48_0:_add_gvi_to_crafted_item(l_48_1, l_48_2, l_48_3, l_48_4)
        for (for control),_ in (for generator) do
        end
        if arg == CRAFT_TO_INV then
          Application:debug("CRAFT_TO_INV is bugged for weapons, if this is from a weapon, change it!")
          l_48_0:_add_gvi_to_inventory(l_48_1, l_48_2, l_48_4)
          l_48_0:_remove_gvi_from_crafted_item(l_48_1, l_48_2, l_48_3, l_48_4)
          for (for control),_ in (for generator) do
          end
          if arg == INV_ADD then
            l_48_0:_add_gvi_to_inventory(l_48_1, l_48_2, l_48_4)
            for (for control),_ in (for generator) do
            end
            if arg == INV_REMOVE then
              l_48_0:_remove_gvi_from_inventory(l_48_1, l_48_2, l_48_4)
              for (for control),_ in (for generator) do
              end
              if arg == CRAFT_ADD then
                l_48_0:_add_gvi_to_crafted_item(l_48_1, l_48_2, l_48_3, l_48_4)
                for (for control),_ in (for generator) do
                end
                if arg == CRAFT_REMOVE then
                  l_48_0:_remove_gvi_from_crafted_item(l_48_1, l_48_2, l_48_3, l_48_4)
                  for (for control),_ in (for generator) do
                  end
                end
              end
               -- DECOMPILER ERROR: Confused about usage of registers for local variables.

               -- Warning: missing end command somewhere! Added here
            end
             -- Warning: missing end command somewhere! Added here
          end
           -- Warning: missing end command somewhere! Added here
        end
         -- Warning: missing end command somewhere! Added here
      end
       -- Warning: missing end command somewhere! Added here
    end
     -- Warning: missing end command somewhere! Added here
  end
end

BlackMarketManager.fetch_new_items_unlocked = function(l_49_0)
  local data = {}
  for category,value in pairs(l_49_0._global.new_item_type_unlocked) do
    if value then
      table.insert(data, {category, value})
      l_49_0._global.new_item_type_unlocked[category] = false
    end
  end
  return data
end

BlackMarketManager.remove_new_drop = function(l_50_0, l_50_1, l_50_2, l_50_3)
  if not l_50_0._global.new_drops[l_50_1] then
    return 
  end
  if not l_50_0._global.new_drops[l_50_1][l_50_2] then
    return 
  end
  l_50_0._global.new_drops[l_50_1][l_50_2][l_50_3] = nil
  if table.size(l_50_0._global.new_drops[l_50_1][l_50_2]) == 0 then
    l_50_0._global.new_drops[l_50_1][l_50_2] = nil
    if table.size(l_50_0._global.new_drops[l_50_1]) == 0 then
      l_50_0._global.new_drops[l_50_1] = nil
    end
  end
end

BlackMarketManager.check_new_drop = function(l_51_0, l_51_1, l_51_2, l_51_3)
  if not l_51_0._global.new_drops[l_51_1] then
    return false
  end
  if not l_51_0._global.new_drops[l_51_1][l_51_2] then
    return false
  end
   -- DECOMPILER ERROR: Confused while interpreting a jump as a 'while'

end
return true
end

BlackMarketManager.check_new_drop_category = function(l_52_0, l_52_1, l_52_2)
  if not l_52_0._global.new_drops[l_52_1] then
    return false
  end
  if not l_52_0._global.new_drops[l_52_1][l_52_2] then
    return false
  end
   -- DECOMPILER ERROR: Confused while interpreting a jump as a 'while'

end
return true
end

BlackMarketManager.got_any_new_drop = function(l_53_0)
  local amount_new_loot = table.size(l_53_0._global.new_drops)
  if amount_new_loot > 0 then
    return true
  end
  return false
end

BlackMarketManager.got_new_drop = function(l_54_0, l_54_1, l_54_2, l_54_3)
  do
    local category_ids = Idstring(l_54_2)
    if category_ids == Idstring("primaries") or category_ids == Idstring("secondaries") then
      local uses_parts = managers.weapon_factory:get_parts_from_factory_id(l_54_3)
      for type,parts in pairs(uses_parts) do
        for _,part in ipairs(parts) do
          if l_54_0:check_new_drop("normal", "weapon_mods", part) then
            return true
          end
          if l_54_0:check_new_drop("infamous", "weapon_mods", part) then
            return true
          end
        end
      end
    else
      if category_ids == Idstring("weapon_mods") then
        if l_54_0:check_new_drop("normal", "weapon_mods", l_54_3) then
          return true
        end
        if l_54_0:check_new_drop("infamous", "weapon_mods", l_54_3) then
          return true
        else
          if category_ids == Idstring("weapon_tabs") then
            local uses_parts = managers.weapon_factory:get_parts_from_factory_id(l_54_3)
            if not uses_parts[l_54_1] then
              local tab_parts = {}
            end
            for type,part in ipairs(tab_parts) do
              if l_54_0:check_new_drop("normal", "weapon_mods", part) then
                return true
              end
              if l_54_0:check_new_drop("infamous", "weapon_mods", part) then
                return true
              end
            end
          else
            if category_ids == Idstring("mask_mods") then
              local textures = managers.blackmarket:get_inventory_category("textures")
              local colors = managers.blackmarket:get_inventory_category("colors")
              local got_table = {}
              for _,mmod in ipairs({"colors", "materials", "textures"}) do
                if l_54_0:check_new_drop_category("normal", mmod) then
                  got_table[mmod] = true
                  for (for control),_ in (for generator) do
                  end
                  if l_54_0:check_new_drop_category("infamous", mmod) then
                    got_table[mmod] = true
                  end
                end
                if #colors <= 0 then
                  return not got_table.textures
                end
                if #textures <= 0 then
                  return not got_table.colors
                end
                return table.size(got_table) > 0
              else
                if category_ids == Idstring("mask_buy") then
                  if l_54_0:check_new_drop_category("normal", "masks") then
                    return true
                  end
                  if l_54_0:check_new_drop_category("infamous", "masks") then
                    return true
                  else
                    if category_ids == Idstring("weapon_buy") and l_54_0:check_new_drop("normal", l_54_1, l_54_3) then
                      return true
                    end
                  end
                end
              end
            end
          end
        end
      end
      return false
    end
     -- Warning: missing end command somewhere! Added here
  end
end

BlackMarketManager.get_inventory_category = function(l_55_0, l_55_1)
  local t = {}
  for global_value,categories in pairs(l_55_0._global.inventory) do
    if categories[l_55_1] then
      for id,amount in pairs(categories[l_55_1]) do
        table.insert(t, {id = id, global_value = global_value, amount = amount})
      end
    end
  end
  return t
end

BlackMarketManager.merge_inventory_masks = function(l_56_0)
  if not l_56_0._global.inventory.normal.masks then
    local normals = {}
  end
  for global_value,categories in pairs(l_56_0._global.inventory) do
    if global_value ~= "normal" and global_value ~= "infamous" and categories.masks then
      for mask_id,amount in pairs(categories.masks) do
        normals[mask_id] = normals[mask_id] or 0
        normals[mask_id] = normals[mask_id] + amount
      end
    end
  end
  if l_56_0._global.inventory.superior then
    l_56_0._global.inventory.superior.masks = nil
  end
  if l_56_0._global.inventory.exceptional then
    l_56_0._global.inventory.exceptional.masks = nil
  end
end

BlackMarketManager.get_inventory_masks = function(l_57_0)
  local masks = {}
  for global_value,categories in pairs(l_57_0._global.inventory) do
    if categories.masks then
      for mask_id,amount in pairs(categories.masks) do
        table.insert(masks, {mask_id = mask_id, global_value = global_value, amount = amount})
      end
    end
  end
  return masks
end

BlackMarketManager.get_crafted_category = function(l_58_0, l_58_1)
  if not l_58_0._global.crafted_items then
    return 
  end
  return l_58_0._global.crafted_items[l_58_1]
end

BlackMarketManager.get_crafted_category_slot = function(l_59_0, l_59_1, l_59_2)
  if not l_59_0._global.crafted_items then
    return 
  end
  if not l_59_0._global.crafted_items[l_59_1] then
    return 
  end
  return l_59_0._global.crafted_items[l_59_1][l_59_2]
end

BlackMarketManager.get_weapon_category = function(l_60_0, l_60_1)
  local weapon_index = {secondaries = 1, primaries = 2}
  local selection_index = weapon_index[l_60_1] or 1
  local t = {}
  for weapon_name,weapon_data in pairs(l_60_0._global.weapons) do
    if weapon_data.selection_index == selection_index then
      table.insert(t, weapon_data)
      t[#t].weapon_id = weapon_name
    end
  end
  return t
end

BlackMarketManager.get_weapon_blueprint = function(l_61_0, l_61_1, l_61_2)
  if not l_61_0._global.crafted_items then
    return 
  end
  if not l_61_0._global.crafted_items[l_61_1] then
    return 
  end
  if not l_61_0._global.crafted_items[l_61_1][l_61_2] then
    return 
  end
  return l_61_0._global.crafted_items[l_61_1][l_61_2].blueprint
end

BlackMarketManager.get_perks_from_weapon_blueprint = function(l_62_0, l_62_1, l_62_2)
  return managers.weapon_factory:get_perks(l_62_1, l_62_2)
end

BlackMarketManager.get_perks_from_part = function(l_63_0, l_63_1)
  return managers.weapon_factory:get_perks_from_part_id(l_63_1)
end

BlackMarketManager.get_weapon_stats = function(l_64_0, l_64_1, l_64_2)
  if not l_64_0._global.crafted_items[l_64_1] or not l_64_0._global.crafted_items[l_64_1][l_64_2] then
    Application:error("[BlackMarketManager:get_weapon_stats] Trying to get weapon stats on weapon that doesn't exist", l_64_1, l_64_2)
    return 
  end
  local blueprint = l_64_0:get_weapon_blueprint(l_64_1, l_64_2)
  local weapon = l_64_0._global.crafted_items[l_64_1][l_64_2]
  local weapon_tweak_data = tweak_data.weapon[weapon.weapon_id]
  if not blueprint or not weapon or not weapon_tweak_data then
    return 
  end
  local weapon_stats = managers.weapon_factory:get_stats(weapon.factory_id, blueprint)
  for stat,value in pairs(weapon_tweak_data.stats) do
    weapon_stats[stat] = (weapon_stats[stat] or 0) + weapon_tweak_data.stats[stat]
  end
  return weapon_stats
end

BlackMarketManager.get_weapon_stats_without_mod = function(l_65_0, l_65_1, l_65_2, l_65_3)
  return l_65_0:get_weapon_stats_with_mod(l_65_1, l_65_2, l_65_3, true)
end

BlackMarketManager.get_weapon_stats_with_mod = function(l_66_0, l_66_1, l_66_2, l_66_3, l_66_4)
  if not l_66_0._global.crafted_items[l_66_1] or not l_66_0._global.crafted_items[l_66_1][l_66_2] then
    Application:error("[BlackMarketManager:get_weapon_stats_with_mod] Trying to get weapon stats on weapon that doesn't exist", l_66_1, l_66_2)
    return 
  end
  local blueprint = deep_clone(l_66_0:get_weapon_blueprint(l_66_1, l_66_2))
  local weapon = l_66_0._global.crafted_items[l_66_1][l_66_2]
  local weapon_tweak_data = tweak_data.weapon[weapon.weapon_id]
  if not blueprint or not weapon or not weapon_tweak_data then
    return 
  end
  if l_66_4 then
    managers.weapon_factory:remove_part_from_blueprint(l_66_3, blueprint)
  else
    managers.weapon_factory:change_part_blueprint_only(weapon.factory_id, l_66_3, blueprint)
  end
  local weapon_stats = managers.weapon_factory:get_stats(weapon.factory_id, blueprint)
  for stat,value in pairs(weapon_tweak_data.stats) do
    weapon_stats[stat] = (weapon_stats[stat] or 0) + weapon_tweak_data.stats[stat]
  end
  return weapon_stats
end

BlackMarketManager.calculate_weapon_concealment = function(l_67_0, l_67_1)
  if type(l_67_1) == "string" and (l_67_1 ~= "primaries" or not l_67_0:equipped_primary()) then
    if l_67_1 == "secondaries" then
      l_67_1 = l_67_0:equipped_secondary()
    else
      l_67_1 = false
    end
    return l_67_0:_calculate_weapon_concealment(l_67_1)
     -- Warning: missing end command somewhere! Added here
  end
end

BlackMarketManager.calculate_armor_concealment = function(l_68_0, l_68_1)
  if not l_68_1 then
    return l_68_0:_calculate_armor_concealment(l_68_0:equipped_armor())
     -- Warning: missing end command somewhere! Added here
  end
end

BlackMarketManager._calculate_weapon_concealment = function(l_69_0, l_69_1)
  local factory_id = l_69_1.factory_id
  if not l_69_1.weapon_id then
    local weapon_id = managers.weapon_factory:get_weapon_id_by_factory_id(factory_id)
  end
  local blueprint = l_69_1.blueprint
  local base_stats = tweak_data.weapon[weapon_id].stats
  if not base_stats or not base_stats.concealment then
    return 0
  end
  local parts_stats = managers.weapon_factory:get_stats(factory_id, blueprint)
  local stats_tweak_data = tweak_data.weapon.stats
  local concealment = math.max(#stats_tweak_data.concealment - (base_stats.concealment + (parts_stats.concealment or 0)), 0)
  return concealment
end

BlackMarketManager._calculate_armor_concealment = function(l_70_0, l_70_1)
  local stats_tweak_data = tweak_data.weapon.stats
  return math.max(#stats_tweak_data.concealment - tweak_data.blackmarket.armors[l_70_1].concealment, 0)
end

BlackMarketManager._get_concealment = function(l_71_0, l_71_1, l_71_2, l_71_3, l_71_4)
  local stats_tweak_data = tweak_data.weapon.stats
  local primary_concealment = l_71_0:_calculate_weapon_concealment(l_71_1)
  local secondary_concealment = l_71_0:_calculate_weapon_concealment(l_71_2)
  local armor_concealment = l_71_0:_calculate_armor_concealment(l_71_3)
  local modifier = l_71_4 or 0
  local total_concealment = math.clamp(primary_concealment + secondary_concealment + armor_concealment + modifier + 3, 1, #stats_tweak_data.concealment)
  return stats_tweak_data.concealment[total_concealment], total_concealment
end

BlackMarketManager._get_concealment_from_local_player = function(l_72_0)
  return l_72_0:_get_concealment(l_72_0:equipped_primary(), l_72_0:equipped_secondary(), l_72_0:equipped_armor(), l_72_0:concealment_modifiers())
end

BlackMarketManager._get_concealment_from_peer = function(l_73_0, l_73_1)
  local outfit = l_73_1:blackmarket_outfit()
  return l_73_0:_get_concealment(outfit.primary, outfit.secondary, outfit.armor, outfit.concealment_modifier)
end

BlackMarketManager.get_real_concealment_index_from_custom_data = function(l_74_0, l_74_1)
  local primary_concealment = l_74_0:calculate_weapon_concealment(l_74_1.primaries or "primaries")
  local secondary_concealment = l_74_0:calculate_weapon_concealment(l_74_1.secondaries or "secondaries")
  local armor_concealment = l_74_0:calculate_armor_concealment(l_74_1.armors)
  local modifier = l_74_0:concealment_modifiers()
  return primary_concealment + secondary_concealment + armor_concealment + modifier + 3
end

BlackMarketManager.get_real_concealment_index_of_local_player = function(l_75_0)
  local primary_concealment = l_75_0:calculate_weapon_concealment("primaries")
  local secondary_concealment = l_75_0:calculate_weapon_concealment("secondaries")
  local armor_concealment = l_75_0:calculate_armor_concealment()
  local modifier = l_75_0:concealment_modifiers()
  return primary_concealment + secondary_concealment + armor_concealment + modifier + 3
end

BlackMarketManager.get_suspicion_of_local_player = function(l_76_0)
  return l_76_0:_get_concealment_from_local_player()
end

BlackMarketManager.get_suspicion_of_peer = function(l_77_0, l_77_1)
  return l_77_0:_get_concealment_from_peer(l_77_1)
end

BlackMarketManager.concealment_modifiers = function(l_78_0)
  local skill_bonuses = 0
  return skill_bonuses
end

BlackMarketManager.get_dropable_mods_by_weapon_id = function(l_79_0, l_79_1)
  local parts_tweak_data = tweak_data.weapon.factory.parts
  local all_mods = tweak_data.blackmarket.weapon_mods
  local weapon_mods = managers.weapon_factory:get_parts_from_weapon_id(l_79_1)
  local dropable_mods = {}
  local dlc_mods = {}
  for id,data in pairs(weapon_mods) do
    if not dropable_mods[id] then
      dropable_mods[id] = {}
    end
    for _,mod in ipairs(data) do
      local my_mod = all_mods[mod]
      if my_mod and (my_mod.pcs or my_mod.pc) then
        if not my_mod.dlcs then
          local is_dlc = my_mod.dlc
        end
        if not all_mods.infamous or not "infamous" then
          table.insert(dropable_mods[id], {mod, is_dlc and not all_mods.infamous or "normal"})
        end
      end
    end
  end
  local content, loot_drops = nil, nil
  for package_id,dlc in pairs(tweak_data.dlc) do
    local global_value = dlc.content and dlc.content.loot_global_value or package_id
    if (dlc.free or managers.dlc:has_dlc(global_value)) and global_value ~= "normal" and global_value ~= "infamous" then
      content = dlc.content
      if not content or not content.loot_drops then
        loot_drops = {}
      end
      for _,item_data in ipairs(loot_drops) do
        if item_data.type_items == "weapon_mods" then
          local part_id = item_data.item_entry
          if parts_tweak_data[part_id] then
            local part_type = parts_tweak_data[part_id].type
          end
          if part_type then
            if not dropable_mods[part_type] then
              dropable_mods[part_type] = {}
            end
            if weapon_mods[part_type] then
              local got_mod = table.contains(weapon_mods[part_type], part_id)
            end
            if got_mod then
              table.insert(dropable_mods[part_type], {part_id, global_value})
            end
          end
        end
      end
    end
  end
  for key,data in pairs(dropable_mods) do
    if #data == 0 then
      dropable_mods[key] = nil
    end
  end
  return dropable_mods
end

BlackMarketManager.sell_item = function(l_80_0, l_80_1)
  if not l_80_0:remove_item(l_80_1.global_value, l_80_1.category, l_80_1.id) then
    Application:error("[BlackMarketManager:sell_item] Failed to sell item", l_80_1.global_value, l_80_1.category, l_80_1.id)
    return 
  end
  l_80_0:_sell_item(l_80_1)
end

BlackMarketManager._sell_item = function(l_81_0, l_81_1)
  local item_def = tweak_data.blackmarket[l_81_1.category][l_81_1.id]
  local value_multiplier = tweak_data.lootdrop.global_values[l_81_1.global_value].value_multiplier
  if not item_def.pc then
    local pc = item_def.pcs[1]
  end
  local money = pc * value_multiplier * managers.player:upgrade_value("player", "sell_cost_multiplier", 1)
  print("Sold for", money, "! (", pc, value_multiplier, managers.plater:upgrade_value("player", "sell_cost_multiplier", 1), ")")
end

BlackMarketManager.apply_mask_craft_on_unit = function(l_82_0, l_82_1, l_82_2)
  local materials = l_82_1:get_objects_by_type(Idstring("material"))
  local material = materials[#materials]
  print("apply_mask_craft_on_unit material", material, inspect(materials))
  local tint_color_a = Vector3(0, 0, 0)
  local tint_color_b = Vector3(0, 0, 0)
  local pattern_id = l_82_2 and l_82_2.pattern.id or "no_color_no_material"
  local material_id = l_82_2 and l_82_2.material.id or "plastic"
  if l_82_2 then
    local color_data = tweak_data.blackmarket.colors[l_82_2.color.id]
    tint_color_a = Vector3(color_data.colors[1]:unpack())
    tint_color_b = Vector3(color_data.colors[2]:unpack())
  end
  material:set_variable(Idstring("tint_color_a"), tint_color_a)
  material:set_variable(Idstring("tint_color_b"), tint_color_b)
  local pattern = tweak_data.blackmarket.textures[pattern_id].texture
  print("pattern", pattern)
  local material_texture = TextureCache:retrieve(pattern, "normal")
  material:set_texture("material_texture", material_texture)
  local reflection = tweak_data.blackmarket.materials[material_id].texture
  local material_amount = tweak_data.blackmarket.materials[material_id].material_amount or 1
  local reflection_texture = TextureCache:retrieve(reflection, "normal")
  material:set_texture("reflection_texture", reflection_texture)
  material:set_variable(Idstring("material_amount"), material_amount)
  return material_texture, reflection_texture
end

BlackMarketManager.test_craft_mask = function(l_83_0, l_83_1)
  if not l_83_1 then
    l_83_1 = 1
  end
  local blueprint = {}
  local masks = managers.blackmarket:get_inventory_category("masks")
  local entry = masks[math.random(#masks)]
  blueprint.masks = {id = entry.id, global_value = entry.global_value}
  local materials = managers.blackmarket:get_inventory_category("materials")
  local entry = materials[math.random(#materials)]
  blueprint.materials = {id = entry.id, global_value = entry.global_value}
  local colors = managers.blackmarket:get_inventory_category("colors")
  local entry = colors[math.random(#colors)]
  blueprint.colors = {id = entry.id, global_value = entry.global_value}
  local textures = managers.blackmarket:get_inventory_category("textures")
  local entry = textures[math.random(#textures)]
  blueprint.textures = {id = entry.id, global_value = entry.global_value}
  l_83_0:craft_item("masks", l_83_1, blueprint)
end

BlackMarketManager.has_parts_for_blueprint = function(l_84_0, l_84_1, l_84_2)
  for category,data in pairs(l_84_2) do
    if not l_84_0:has_item(data.global_value, category, data.id) then
      print("misses part", data.global_value, category, data.id)
      return false
    end
  end
  print("has all parts")
  return true
end

BlackMarketManager.get_crafted_item_amount = function(l_85_0, l_85_1, l_85_2)
  local crafted_category = l_85_0._global.crafted_items[l_85_1]
  if not crafted_category then
    print("[BlackMarketManager:get_crafted_item_amount] No such category", l_85_1)
    return 0
  end
  do
    local item_amount = 0
    for _,item in pairs(crafted_category) do
       -- DECOMPILER ERROR: unhandled construct in 'if'

      if (l_85_1 == "primaries" or l_85_1 == "secondaries") and item.weapon_id == l_85_2 then
        item_amount = item_amount + 1
        for (for control),_ in (for generator) do
           -- DECOMPILER ERROR: unhandled construct in 'if'

          if l_85_1 == "masks" and item.mask_id == l_85_2 then
            item_amount = item_amount + 1
            for (for control),_ in (for generator) do
              if l_85_1 == "character" then
                for (for control),_ in (for generator) do
                end
                if l_85_1 == "armors" then
                  for (for control),_ in (for generator) do
                end
              end
            end
            return item_amount
          end
           -- Warning: missing end command somewhere! Added here
        end
         -- Warning: missing end command somewhere! Added here
      end
       -- Warning: missing end command somewhere! Added here
    end
     -- Warning: missing end command somewhere! Added here
  end
end

BlackMarketManager.get_crafted_part_global_value = function(l_86_0, l_86_1, l_86_2, l_86_3)
  local global_values = l_86_0._global.crafted_items[l_86_1][l_86_2].global_values
  if global_values then
    return global_values[l_86_3]
  end
end

BlackMarketManager.get_inventory_item_global_values = function(l_87_0, l_87_1, l_87_2)
  local global_values = {}
  for global_value,data in pairs(l_87_0._global.inventory) do
    if l_87_0:get_item_amount(global_value, l_87_1, l_87_2, true) > 0 then
      table.insert(global_values, global_value)
    end
  end
  return global_values
end

BlackMarketManager.has_inventory_item = function(l_88_0, l_88_1, l_88_2, l_88_3)
  if l_88_0:get_item_amount(l_88_1, l_88_2, l_88_3, true) > 0 then
    return true
  end
  for global_value,data in pairs(l_88_0._global.inventory) do
    if l_88_1 ~= global_value and l_88_0:get_item_amount(global_value, l_88_2, l_88_3, true) > 0 then
      return true
    end
  end
end

BlackMarketManager.get_item_amount = function(l_89_0, l_89_1, l_89_2, l_89_3, l_89_4)
  local global_value_data = l_89_0._global.inventory[l_89_1]
  if not global_value_data then
    if not l_89_4 then
      print("[BlackMarketManager:get_item_amount] No such global value", l_89_1)
    end
    return 0
  end
  local category_data = global_value_data[l_89_2]
  if not category_data then
    if not l_89_4 then
      print("[BlackMarketManager:get_item_amount] No such category", l_89_2, "of global value", l_89_1)
    end
    return 0
  end
  local item_amount = category_data[l_89_3]
  if not item_amount then
    if not l_89_4 then
      print("[BlackMarketManager:get_item_amount] No such item id", l_89_3, "in category", l_89_2, "of global value", l_89_1)
    end
    return 0
  end
  local item_def = tweak_data.blackmarket[l_89_2][l_89_3]
  if not item_def then
    if not l_89_4 then
      print("[BlackMarketManager:get_item_amount] No item", l_89_2, l_89_3)
    end
    return 0
  end
  return item_amount
end

BlackMarketManager.has_item = function(l_90_0, l_90_1, l_90_2, l_90_3)
  local global_value_data = l_90_0._global.inventory[l_90_1]
  if not global_value_data then
    print("[BlackMarketManager:has_item] No such global value", l_90_1)
    return false
  end
  local category_data = global_value_data[l_90_2]
  if not category_data then
    print("[BlackMarketManager:has_item] No such category", l_90_2, "of global value", l_90_1)
    return false
  end
  local item_amount = category_data[l_90_3]
  if not item_amount then
    print("[BlackMarketManager:has_item] No such item id", l_90_3, "in category", l_90_2, "of global value", l_90_1)
    return false
  end
  local item_def = tweak_data.blackmarket[l_90_2][l_90_3]
  if not item_def then
    print("[BlackMarketManager:has_item] No item", l_90_2, l_90_3)
    return false
  end
  return true
end

BlackMarketManager.remove_item = function(l_91_0, l_91_1, l_91_2, l_91_3)
  if not l_91_0:has_item(l_91_1, l_91_2, l_91_3) then
    return false
  end
  local category_data = l_91_0._global.inventory[l_91_1][l_91_2]
  category_data[l_91_3] = category_data[l_91_3] - 1
  if category_data[l_91_3] <= 0 then
    print("Run out of", l_91_2, l_91_3)
    category_data[l_91_3] = nil
  end
  return true
end

BlackMarketManager.craft_item = function(l_92_0, l_92_1, l_92_2, l_92_3)
  if not l_92_0:has_parts_for_blueprint(l_92_1, l_92_3) then
    Application:error("[BlackMarketManager:craft_item] Blueprint not valid", l_92_1)
    return 
  end
  for category,data in pairs(l_92_3) do
    l_92_0:remove_item(data.global_value, category, data.id)
    l_92_0:alter_global_value_item(data.global_value, category, l_92_2, data.id, INV_TO_CRAFT)
  end
  if not l_92_0._global.crafted_items[l_92_1] then
    l_92_0._global.crafted_items[l_92_1] = {}
  end
  l_92_0._global.crafted_items[l_92_1][l_92_2] = l_92_3
end

BlackMarketManager.sell_crafted_item = function(l_93_0, l_93_1, l_93_2)
  if not l_93_0._global.crafted_items[l_93_1] then
    Application:error("[BlackMarketManager:sell_crafted_item] No crafted items of category", l_93_1)
    return 
  end
  if not l_93_0._global.crafted_items[l_93_1][l_93_2] then
    Application:error("[BlackMarketManager:sell_crafted_item] No crafted items of category", l_93_1, "in slot", l_93_2)
    return 
  end
  local blueprint = l_93_0._global.crafted_items[l_93_1][l_93_2]
  for category,data in pairs(blueprint) do
    l_93_0:_sell_item({global_value = data.global_value, category = category, id = data.id})
    l_93_0:alter_global_value_item(data.global_value, category, l_93_2, data.id, CRAFT_TO_INV)
  end
  l_93_0:alter_global_value_item(l_93_0._global.crafted_items[l_93_1][l_93_2].global_value, l_93_1, l_93_2, l_93_0._global.crafted_items[l_93_1][l_93_2].id, CRAFT_TO_INV)
  l_93_0._global.crafted_items[l_93_1][l_93_2] = nil
end

BlackMarketManager.uncraft_item = function(l_94_0, l_94_1, l_94_2)
  if not l_94_0._global.crafted_items[l_94_1] then
    Application:error("[BlackMarketManager:uncraft_item] No crafted items of category", l_94_1)
    return 
  end
  if not l_94_0._global.crafted_items[l_94_1][l_94_2] then
    Application:error("[BlackMarketManager:uncraft_item] No crafted items of category", l_94_1, "in slot", l_94_2)
    return 
  end
  local blueprint = l_94_0._global.crafted_items[l_94_1][l_94_2]
  for category,data in pairs(blueprint) do
    l_94_0:add_to_inventory(data.global_value, category, data.id)
  end
  l_94_0._global.crafted_items[l_94_1][l_94_2] = nil
end

BlackMarketManager._get_free_weapon_slot = function(l_95_0, l_95_1)
  if not l_95_0._global.crafted_items[l_95_1] then
    return 1
  end
  for i = 1, 9 do
    if not l_95_0._global.crafted_items[l_95_1][i] then
      return i
    end
  end
end

BlackMarketManager.on_aquired_weapon_platform = function(l_96_0, l_96_1, l_96_2, l_96_3)
  l_96_0._global.weapons[l_96_2].unlocked = true
  local category = tweak_data.weapon[l_96_1.weapon_id].use_data.selection_index == 2 and "primaries" or "secondaries"
  if l_96_1.free then
    local slot = l_96_0:_get_free_weapon_slot(category)
    if slot then
      l_96_0:on_buy_weapon_platform(category, l_96_1.weapon_id, slot, true)
    elseif not l_96_3 and l_96_2 ~= "saw" then
      print("on_aquired_weapon_platform", inspect(l_96_1), l_96_2)
      if not l_96_0._global.new_drops.normal then
        l_96_0._global.new_drops.normal = {}
      end
      if not l_96_0._global.new_drops.normal[category] then
        l_96_0._global.new_drops.normal[category] = {}
      end
      l_96_0._global.new_drops.normal[category][l_96_2] = true
      l_96_0._global.new_item_type_unlocked[category] = l_96_1.factory_id
    end
  end
end

BlackMarketManager.on_unaquired_weapon_platform = function(l_97_0, l_97_1, l_97_2)
  l_97_0._global.weapons[l_97_2].unlocked = false
  if not managers.blackmarket:equipped_primary() then
    return 
  end
  if managers.blackmarket:equipped_primary().weapon_id == l_97_2 then
    managers.blackmarket:equipped_primary().equipped = false
    l_97_0:_verfify_equipped_category("primaries")
    l_97_0:_update_menu_scene_primary()
  end
end

BlackMarketManager.aquire_default_weapons = function(l_98_0)
  print("BlackMarketManager:aquire_default_weapons()")
  if l_98_0._global and l_98_0._global.weapons then
    local glock_17 = l_98_0._global.weapons.glock_17
  end
  if glock_17 and (not l_98_0._global.crafted_items.secondaries or not glock_17.unlocked) and not managers.upgrades:aquired("glock_17") then
    managers.upgrades:aquire("glock_17")
  end
  if l_98_0._global and l_98_0._global.weapons then
    local amcar = l_98_0._global.weapons.amcar
  end
  if amcar and (not l_98_0._global.crafted_items.primaries or not amcar.unlocked) and not managers.upgrades:aquired("amcar") then
    managers.upgrades:aquire("amcar")
  end
end

BlackMarketManager.on_buy_weapon_platform = function(l_99_0, l_99_1, l_99_2, l_99_3, l_99_4)
  if l_99_1 ~= "primaries" and l_99_1 ~= "secondaries" then
    return 
  end
  if not l_99_0._global.crafted_items[l_99_1] then
    l_99_0._global.crafted_items[l_99_1] = {}
  end
  local factory_id = managers.weapon_factory:get_factory_id_by_weapon_id(l_99_2)
  local blueprint = deep_clone(managers.weapon_factory:get_default_blueprint_by_factory_id(factory_id))
  l_99_0._global.crafted_items[l_99_1][l_99_3] = {weapon_id = l_99_2, factory_id = factory_id, blueprint = blueprint, global_values = {}}
  l_99_0:_verfify_equipped_category(l_99_1)
  if l_99_1 ~= "primaries" or not l_99_4 then
    managers.money:on_buy_weapon_platform(l_99_2)
    managers.achievment:award("armed_to_the_teeth")
  end
  if l_99_0._global.crafted_items.primaries and l_99_0._global.crafted_items.secondaries then
    local amount = table.size(l_99_0._global.crafted_items.primaries) + table.size(l_99_0._global.crafted_items.secondaries)
    if tweak_data.achievement.fully_loaded <= amount then
      managers.achievment:award("fully_loaded")
    end
    if tweak_data.achievement.weapon_collector <= amount then
      managers.achievment:award("weapon_collector")
    end
  end
end

BlackMarketManager.on_sell_weapon_part = function(l_100_0, l_100_1, l_100_2)
  managers.money:on_sell_weapon_part(l_100_1, l_100_2)
  l_100_0:alter_global_value_item(l_100_2, "weapon_mods", nil, l_100_1, INV_REMOVE)
  l_100_0:remove_item(l_100_2, "weapon_mods", l_100_1)
end

BlackMarketManager.on_sell_weapon = function(l_101_0, l_101_1, l_101_2)
  if not l_101_0._global.crafted_items[l_101_1] or not l_101_0._global.crafted_items[l_101_1][l_101_2] then
    return 
  end
  if not l_101_0._global.crafted_items[l_101_1][l_101_2].global_values then
    local global_values = {}
  end
  local blueprint = l_101_0._global.crafted_items[l_101_1][l_101_2].blueprint
  local default_blueprint = managers.weapon_factory:get_default_blueprint_by_factory_id(l_101_0._global.crafted_items[l_101_1][l_101_2].factory_id)
  for _,default_part in ipairs(default_blueprint) do
    table.delete(blueprint, default_part)
  end
  for _,part_id in pairs(blueprint) do
    local global_value = global_values[part_id] or "normal"
    l_101_0:add_to_inventory(global_value, "weapon_mods", part_id, true)
    l_101_0:alter_global_value_item(global_value, l_101_1, l_101_2, part_id, CRAFT_REMOVE)
  end
  managers.money:on_sell_weapon(l_101_1, l_101_2)
  l_101_0._global.crafted_items[l_101_1][l_101_2] = nil
  l_101_0:_verfify_equipped_category(l_101_1)
  if l_101_1 == "primaries" then
    l_101_0:_update_menu_scene_primary()
  elseif l_101_1 == "secondaries" then
    l_101_0:_update_menu_scene_secondary()
  end
end

BlackMarketManager._update_menu_scene_primary = function(l_102_0)
  if not managers.menu_scene then
    return 
  end
  local primary = l_102_0:equipped_primary()
  if primary then
    managers.menu_scene:set_character_equipped_weapon(nil, primary.factory_id, primary.blueprint, "primary")
  else
    managers.menu_scene:set_character_equipped_weapon(nil, nil, nil, "primary")
  end
end

BlackMarketManager._update_menu_scene_secondary = function(l_103_0)
  if not managers.menu_scene then
    return 
  end
  local secondary = l_103_0:equipped_secondary()
  if secondary then
    managers.menu_scene:set_character_equipped_weapon(nil, secondary.factory_id, secondary.blueprint, "secondary")
  else
    managers.menu_scene:set_character_equipped_weapon(nil, nil, nil, "secondary")
  end
end

BlackMarketManager.get_modify_weapon_consequence = function(l_104_0, l_104_1, l_104_2, l_104_3)
  if not l_104_0._global.crafted_items[l_104_1] or not l_104_0._global.crafted_items[l_104_1][l_104_2] then
    Application:error("[BlackMarketManager:get_modify_weapon_consequence] Weapon doesn't exist", l_104_1, l_104_2)
    return 
  end
  local craft_data = l_104_0._global.crafted_items[l_104_1][l_104_2]
  local replaces = managers.weapon_factory:get_replaces_parts(craft_data.factory_id, l_104_3, craft_data.blueprint)
  local removes = managers.weapon_factory:get_removes_parts(craft_data.factory_id, l_104_3, craft_data.blueprint)
  return replaces, removes
end

BlackMarketManager.can_modify_weapon = function(l_105_0, l_105_1, l_105_2, l_105_3)
  if not l_105_0._global.crafted_items[l_105_1] or not l_105_0._global.crafted_items[l_105_1][l_105_2] then
    Application:error("[BlackMarketManager:can_modify_weapon] Weapon doesn't exist", l_105_1, l_105_2)
    return 
  end
  local craft_data = l_105_0._global.crafted_items[l_105_1][l_105_2]
  local forbids = managers.weapon_factory:can_add_part(craft_data.factory_id, l_105_3, craft_data.blueprint)
  return forbids
end

BlackMarketManager.remove_weapon_part = function(l_106_0, l_106_1, l_106_2, l_106_3, l_106_4)
  if not l_106_4 or not l_106_0._global.crafted_items[l_106_1] or not l_106_0._global.crafted_items[l_106_1][l_106_2] then
    Application:error("[BlackMarketManager:remove_weapon_part] Trying to remove part", l_106_4, "from weapon that doesn't exist", l_106_1, l_106_2)
    return false
  end
  local craft_data = l_106_0._global.crafted_items[l_106_1][l_106_2]
  managers.weapon_factory:remove_part_from_blueprint(l_106_4, craft_data.blueprint)
  l_106_0:_on_modified_weapon(l_106_1, l_106_2)
  local given_global_value = l_106_3
  if not craft_data.global_values then
    local global_value = {}
  end
  global_value = global_value[l_106_4] or "normal"
  if given_global_value and global_value ~= given_global_value then
    Application:error("[BlackMarketManager] remove_weapon_part(): global_value mismatch", given_global_value, global_value)
  end
  l_106_0:alter_global_value_item(global_value, l_106_1, l_106_2, l_106_4, CRAFT_REMOVE)
  l_106_0:add_to_inventory(global_value, "weapon_mods", l_106_4, true)
  return true
end

BlackMarketManager.modify_weapon = function(l_107_0, l_107_1, l_107_2, l_107_3, l_107_4)
  if not l_107_0._global.crafted_items[l_107_1] or not l_107_0._global.crafted_items[l_107_1][l_107_2] then
    Application:error("[BlackMarketManager:modify_weapon] Trying to modify weapon that doesn't exist", l_107_1, l_107_2)
    return 
  end
  local replaces, removes = l_107_0:get_modify_weapon_consequence(l_107_1, l_107_2, l_107_4)
  local craft_data = l_107_0._global.crafted_items[l_107_1][l_107_2]
  managers.weapon_factory:change_part_blueprint_only(craft_data.factory_id, l_107_4, craft_data.blueprint)
  if not craft_data.global_values then
    craft_data.global_values = {}
  end
  local old_gv = "" .. (craft_data.global_values[l_107_4] or "normal")
  craft_data.global_values[l_107_4] = l_107_3 or "normal"
  local removed_parts = {}
  for _,part in pairs(replaces) do
    table.insert(removed_parts, part)
  end
  for _,part in pairs(removes) do
    table.insert(removed_parts, part)
  end
  local default_blueprint = managers.weapon_factory:get_default_blueprint_by_factory_id(craft_data.factory_id)
  for _,default_part in ipairs(default_blueprint) do
    table.delete(removed_parts, default_part)
  end
  local global_value = "normal"
  for _,removed_part_id in pairs(removed_parts) do
    if not old_gv then
      global_value = removed_part_id ~= l_107_4 or "normal"
    end
    do return end
    global_value = craft_data.global_values[removed_part_id] or "normal"
    craft_data.global_values[removed_part_id] = nil
    l_107_0:add_to_inventory(global_value, "weapon_mods", removed_part_id, true)
    l_107_0:alter_global_value_item(global_value, l_107_1, l_107_2, removed_part_id, CRAFT_REMOVE)
  end
  l_107_0:_on_modified_weapon(l_107_1, l_107_2)
end

BlackMarketManager.buy_and_modify_weapon = function(l_108_0, l_108_1, l_108_2, l_108_3, l_108_4, l_108_5)
  if not l_108_0._global.crafted_items[l_108_1] or not l_108_0._global.crafted_items[l_108_1][l_108_2] then
    Application:error("[BlackMarketManager:modify_weapon] Trying to buy and modify weapon that doesn't exist", l_108_1, l_108_2)
    return 
  end
  l_108_0:modify_weapon(l_108_1, l_108_2, l_108_3, l_108_4)
  if not l_108_5 then
    managers.money:on_buy_weapon_modification(l_108_0._global.crafted_items[l_108_1][l_108_2].weapon_id, l_108_4, l_108_3)
    l_108_0:remove_item(l_108_3, "weapon_mods", l_108_4)
    l_108_0:alter_global_value_item(l_108_3, "weapon_mods", l_108_2, l_108_4, INV_REMOVE)
    l_108_0:alter_global_value_item(l_108_3, l_108_1, l_108_2, l_108_4, CRAFT_ADD)
    managers.achievment:award("would_you_like_your_receipt")
  else
     -- Warning: missing end command somewhere! Added here
  end
end

BlackMarketManager._on_modified_weapon = function(l_109_0, l_109_1, l_109_2)
  if l_109_0:equipped_weapon_slot(l_109_1) ~= l_109_2 then
    return 
  end
  if managers.menu_scene then
    if l_109_1 ~= "primaries" or not l_109_0:equipped_primary() then
      local data = l_109_0:equipped_secondary()
    end
    managers.menu_scene:set_character_equipped_weapon(nil, data.factory_id, data.blueprint, not data or (l_109_1 == "primaries" and "primary") or "secondary")
  end
end

BlackMarketManager.view_weapon_platform = function(l_110_0, l_110_1, l_110_2)
  local factory_id = managers.weapon_factory:get_factory_id_by_weapon_id(l_110_1)
  local blueprint = deep_clone(managers.weapon_factory:get_default_blueprint_by_factory_id(factory_id))
  l_110_0:preload_weapon_blueprint("preview", factory_id, blueprint)
  table.insert(l_110_0._preloading_list, {done_cb = function()
    managers.menu_scene:spawn_item_weapon(factory_id, blueprint)
   end})
  table.insert(l_110_0._preloading_list, {done_cb = l_110_2})
end

BlackMarketManager.view_weapon = function(l_111_0, l_111_1, l_111_2, l_111_3)
  if not l_111_0._global.crafted_items[l_111_1] or not l_111_0._global.crafted_items[l_111_1][l_111_2] then
    Application:error("[BlackMarketManager:view_weapon] Trying to view weapon that doesn't exist", l_111_1, l_111_2)
    return 
  end
  local weapon = l_111_0._global.crafted_items[l_111_1][l_111_2]
  l_111_0:preload_weapon_blueprint("preview", weapon.factory_id, weapon.blueprint)
  table.insert(l_111_0._preloading_list, {done_cb = function()
    managers.menu_scene:spawn_item_weapon(weapon.factory_id, weapon.blueprint)
   end})
  table.insert(l_111_0._preloading_list, {done_cb = l_111_3})
end

BlackMarketManager.view_weapon_with_mod = function(l_112_0, l_112_1, l_112_2, l_112_3, l_112_4)
  if not l_112_0._global.crafted_items[l_112_1] or not l_112_0._global.crafted_items[l_112_1][l_112_2] then
    Application:error("[BlackMarketManager:view_weapon_with_mod] Trying to view weapon that doesn't exist", l_112_1, l_112_2)
    return 
  end
  local weapon = l_112_0._global.crafted_items[l_112_1][l_112_2]
  local blueprint = deep_clone(weapon.blueprint)
  managers.weapon_factory:change_part_blueprint_only(weapon.factory_id, l_112_3, blueprint)
  l_112_0:preload_weapon_blueprint("preview", weapon.factory_id, weapon.blueprint)
  table.insert(l_112_0._preloading_list, {done_cb = function()
    managers.menu_scene:spawn_item_weapon(weapon.factory_id, blueprint)
   end})
  table.insert(l_112_0._preloading_list, {done_cb = l_112_4})
end

BlackMarketManager.view_weapon_without_mod = function(l_113_0, l_113_1, l_113_2, l_113_3, l_113_4)
  if not l_113_0._global.crafted_items[l_113_1] or not l_113_0._global.crafted_items[l_113_1][l_113_2] then
    Application:error("[BlackMarketManager:view_weapon_with_mod] Trying to view weapon that doesn't exist", l_113_1, l_113_2)
    return 
  end
  local weapon = l_113_0._global.crafted_items[l_113_1][l_113_2]
  local blueprint = deep_clone(weapon.blueprint)
  managers.weapon_factory:remove_part_from_blueprint(l_113_3, blueprint)
  l_113_0:preload_weapon_blueprint("preview", weapon.factory_id, blueprint)
  table.insert(l_113_0._preloading_list, {done_cb = function()
    managers.menu_scene:spawn_item_weapon(weapon.factory_id, blueprint)
   end})
  table.insert(l_113_0._preloading_list, {done_cb = l_113_4})
end

BlackMarketManager.on_aquired_armor = function(l_114_0, l_114_1, l_114_2, l_114_3)
  l_114_0._global.armors[l_114_1.armor_id].unlocked = true
  l_114_0._global.armors[l_114_1.armor_id].owned = true
  if not l_114_3 then
    print("BlackMarketManager:on_aquired_armor", inspect(l_114_1), l_114_2)
    if not l_114_0._global.new_drops.normal then
      l_114_0._global.new_drops.normal = {}
    end
    if not l_114_0._global.new_drops.normal.armors then
      l_114_0._global.new_drops.normal.armors = {}
    end
    l_114_0._global.new_drops.normal.armors[l_114_1.armor_id] = true
    if l_114_0._global.new_item_type_unlocked.armors == nil then
      l_114_0._global.new_item_type_unlocked.armors = l_114_1.armor_id
    end
  end
end

BlackMarketManager.on_unaquired_armor = function(l_115_0, l_115_1, l_115_2)
  l_115_0._global.armors[l_115_1.armor_id].unlocked = false
  l_115_0._global.armors[l_115_1.armor_id].owned = false
  if l_115_0._global.armors[l_115_1.armor_id].equipped then
    l_115_0._global.armors[l_115_1.armor_id].equipped = false
    l_115_0._global.armors[l_115_0._defaults.armor].owned = true
    l_115_0._global.armors[l_115_0._defaults.armor].equipped = true
    l_115_0._global.armors[l_115_0._defaults.armor].unlocked = true
    managers.menu_scene:set_character_armor(l_115_0._defaults.armor)
    MenuCallbackHandler:_update_outfit_information()
  end
end

BlackMarketManager.set_preferred_character = function(l_116_0, l_116_1)
  l_116_0._global._preferred_character = l_116_1
  if managers.menu_scene then
    managers.menu_scene:on_set_preferred_character()
  end
end

BlackMarketManager.get_preferred_character = function(l_117_0)
  return l_117_0._global._preferred_character
end

BlackMarketManager.get_preferred_character_real_name = function(l_118_0)
  return managers.localization:text("menu_" .. tostring(l_118_0._global._preferred_character or "russian"))
end

BlackMarketManager.aquire_default_masks = function(l_119_0)
  print("BlackMarketManager:aquire_default_masks()", l_119_0._global.crafted_items.masks)
  if not l_119_0._global.crafted_items.masks then
    l_119_0:on_buy_mask(l_119_0._defaults.mask, "normal", 1)
  end
end

BlackMarketManager.can_modify_mask = function(l_120_0, l_120_1)
  local mask = managers.blackmarket:get_crafted_category("masks")[l_120_1]
  if not mask or mask.modded then
    return false
  end
  local materials = managers.blackmarket:get_inventory_category("materials")
  local textures = managers.blackmarket:get_inventory_category("textures")
  local colors = managers.blackmarket:get_inventory_category("colors")
  return true
end

BlackMarketManager.start_customize_mask = function(l_121_0, l_121_1)
  print("start_customize_mask", l_121_1)
  local mask = managers.blackmarket:get_crafted_category("masks")[l_121_1]
  l_121_0._customize_mask = {}
  l_121_0._customize_mask.slot = l_121_1
  l_121_0._customize_mask.mask_id = mask.mask_id
  l_121_0._customize_mask.global_value = mask.global_value
  l_121_0._customize_mask.textures = {id = "no_color_full_material", global_value = "normal"}
  l_121_0:view_mask(l_121_1)
end

BlackMarketManager.select_customize_mask = function(l_122_0, l_122_1, l_122_2, l_122_3)
  print("select_customize_mask", l_122_1, l_122_2)
  l_122_0._customize_mask[l_122_1] = {id = l_122_2, global_value = l_122_3 or "normal"}
  if l_122_0:can_view_customized_mask() then
    managers.menu_scene:update_mask(l_122_0:get_customized_mask_blueprint())
  end
end

BlackMarketManager.customize_mask_category_id = function(l_123_0, l_123_1)
  if not l_123_0._customize_mask then
    Application:error("BlackMarketManager:customize_mask_category_id( category ), self._customize_mask is nil", l_123_1)
    return 
  end
  return l_123_0._customize_mask[l_123_1] and l_123_0._customize_mask[l_123_1].id or ""
end

BlackMarketManager.customize_mask_category_default = function(l_124_0, l_124_1)
  if l_124_1 == "colors" then
    do return end
  end
  if l_124_1 == "textures" then
    return {id = "no_color_full_material", global_value = "normal"}
  elseif l_124_1 == "materials" then
    return {id = "plastic", global_value = "normal"}
  end
end

BlackMarketManager.get_customize_mask_id = function(l_125_0)
  if not l_125_0._customize_mask then
    return 
  end
  return l_125_0._customize_mask.mask_id
  local mask = managers.blackmarket:get_crafted_category("masks")[l_125_0._customize_mask.slot]
  if mask then
    return mask.mask_id
  end
end

BlackMarketManager.get_customize_mask_value = function(l_126_0)
  local blueprint = l_126_0:get_customized_mask_blueprint()
  return managers.money:get_mask_crafting_price_modified(l_126_0._customize_mask.mask_id, l_126_0._customize_mask.global_value, blueprint), managers.money:can_afford_mask_crafting(l_126_0._customize_mask.mask_id, l_126_0._customize_mask.global_value, blueprint)
end

BlackMarketManager.warn_abort_customize_mask = function(l_127_0, l_127_1)
  if l_127_0._customize_mask then
    managers.menu:show_confirm_blackmarket_abort(l_127_1)
    return true
  end
end

BlackMarketManager.currently_customizing_mask = function(l_128_0)
   -- DECOMPILER ERROR: Confused while interpreting a jump as a 'while'

end
return true
end

BlackMarketManager.abort_customize_mask = function(l_129_0)
  l_129_0._customize_mask = nil
  managers.menu_scene:remove_item()
end

BlackMarketManager.info_customize_mask = function(l_130_0)
  local got_material = l_130_0._customize_mask.materials
  local got_pattern = l_130_0._customize_mask.textures
  local got_color = l_130_0._customize_mask.colors
  local status = {}
   -- DECOMPILER ERROR: Confused while interpreting a jump as a 'while'

end
table.insert(status, {name = "materials", text = got_material and tweak_data.blackmarket.materials[l_130_0._customize_mask.materials.id].name_id or "bm_menu_materials", color = tweak_data.screen_colors.important_1, id = l_130_0._customize_mask.materials.id, is_good = true})
 -- DECOMPILER ERROR: Confused while interpreting a jump as a 'while'

end
table.insert(status, {name = "textures", text = got_pattern and tweak_data.blackmarket.textures[l_130_0._customize_mask.textures.id].name_id or "bm_menu_textures", color = tweak_data.screen_colors.important_1, id = l_130_0._customize_mask.textures.id, is_good = true})
 -- DECOMPILER ERROR: Confused while interpreting a jump as a 'while'

end
table.insert(status, {name = "colors", text = got_color and tweak_data.blackmarket.colors[l_130_0._customize_mask.colors.id].name_id or "bm_menu_colors", color = tweak_data.screen_colors.important_1, id = l_130_0._customize_mask.colors.id, is_good = true})
if got_material then
status[1].price = managers.money:get_mask_part_price_modified("materials", l_130_0._customize_mask.materials.id, l_130_0._customize_mask.materials.global_value)
end
if got_pattern then
status[2].price = managers.money:get_mask_part_price_modified("textures", l_130_0._customize_mask.textures.id, l_130_0._customize_mask.textures.global_value)
end
if got_color then
status[3].price = managers.money:get_mask_part_price_modified("colors", l_130_0._customize_mask.colors.id, l_130_0._customize_mask.colors.global_value)
end
if status[2].is_good and Idstring(l_130_0._customize_mask.textures.id) == Idstring("no_color_full_material") then
status[2].override = "colors"
status[3].overwritten = true
end
if status[2].is_good and Idstring(l_130_0._customize_mask.textures.id) == Idstring("solidfirst") then
status[2].override = "materials"
status[1].overwritten = true
end
if status[2].is_good and Idstring(l_130_0._customize_mask.textures.id) == Idstring("solidsecond") then
status[2].override = "materials"
status[1].overwritten = true
end
return status
end

BlackMarketManager.can_view_customized_mask = function(l_131_0)
  return l_131_0:can_finish_customize_mask()
end

BlackMarketManager.can_view_mask_blueprint = function(l_132_0, l_132_1)
  if not l_132_1 then
    return false
  end
  if not l_132_1.pattern then
    return false
  end
  local pattern_ids = Idstring(l_132_1.pattern.id)
  if not l_132_1.material and pattern_ids ~= Idstring("solidfirst") and pattern_ids ~= Idstring("solidsecond") then
    return false
  end
  if (not l_132_1.color or Idstring(l_132_1.color.id) == Idstring("nothing")) and pattern_ids ~= Idstring("no_color_full_material") then
    return false
  end
  return true
end

BlackMarketManager.can_view_customized_mask_with_mod = function(l_133_0, l_133_1, l_133_2, l_133_3)
  if not l_133_0._customize_mask then
    return false
  end
  local modded = deep_clone(l_133_0._customize_mask)
  modded[l_133_1] = {id = l_133_2, global_value = l_133_3}
  if not modded.textures then
    return false
  end
  if not modded.materials and Idstring(modded.textures.id) ~= Idstring("solidfirst") and Idstring(modded.textures.id) ~= Idstring("solidsecond") then
    return false
  end
  if not modded.colors and Idstring(modded.textures.id) ~= Idstring("no_color_full_material") then
    return false
  end
  return true
end

BlackMarketManager.view_customized_mask_with_mod = function(l_134_0, l_134_1, l_134_2)
  if not l_134_0._customize_mask then
    return 
  end
  local blueprint = {}
  local modded = deep_clone(l_134_0._customize_mask)
  modded[l_134_1] = {id = l_134_2, global_value = "normal"}
  local slot = modded.slot
  blueprint.color = modded.colors
  blueprint.pattern = modded.textures
  blueprint.material = modded.materials
  if not blueprint.color then
    blueprint.pattern = l_134_0:customize_mask_category_default("textures")
    blueprint.color = {id = "nothing", global_value = "normal"}
  end
  l_134_0:view_mask_with_blueprint(slot, blueprint)
end

BlackMarketManager.get_customized_mask_blueprint = function(l_135_0)
  local blueprint = {}
  blueprint.color = l_135_0._customize_mask.colors
  blueprint.pattern = l_135_0._customize_mask.textures
  blueprint.material = l_135_0._customize_mask.materials
  if not blueprint.color then
    blueprint.color = {id = "nothing", global_value = "normal"}
  end
  if Idstring(blueprint.pattern.id) == Idstring("no_color_full_material") then
    blueprint.color = {id = "nothing", global_value = "normal"}
  end
  if Idstring(blueprint.pattern.id) == Idstring("solidfirst") then
    blueprint.material = {id = "plastic", global_value = "normal"}
  end
  if Idstring(blueprint.pattern.id) == Idstring("solidsecond") then
    blueprint.material = {id = "plastic", global_value = "normal"}
  end
  return blueprint
end

BlackMarketManager.view_customized_mask = function(l_136_0)
  if not l_136_0._customize_mask then
    return 
  end
  local blueprint = l_136_0:get_customized_mask_blueprint()
  local slot = l_136_0._customize_mask.slot
  l_136_0:view_mask_with_blueprint(slot, blueprint)
end

BlackMarketManager.can_afford_customize_mask = function(l_137_0)
  if not managers.money:can_afford_mask_crafting(l_137_0._customize_mask.mask_id, l_137_0._customize_mask.global_value, l_137_0:get_customized_mask_blueprint()) then
    return false
  end
  return true
end

BlackMarketManager.can_finish_customize_mask = function(l_138_0, l_138_1)
  if not l_138_0._customize_mask then
    return false
  end
  if not l_138_0._customize_mask.textures then
    return false
  end
  if not l_138_0._customize_mask.materials and Idstring(l_138_0._customize_mask.textures.id) ~= Idstring("solidfirst") and Idstring(l_138_0._customize_mask.textures.id) ~= Idstring("solidsecond") then
    return false
  end
  if not l_138_0._customize_mask.colors and Idstring(l_138_0._customize_mask.textures.id) ~= Idstring("no_color_full_material") then
    return false
  end
  if l_138_1 and not managers.money:can_afford_mask_crafting(l_138_0._customize_mask.mask_id, l_138_0._customize_mask.global_value, l_138_0:get_customized_mask_blueprint()) then
    return false
  end
  return true
end

BlackMarketManager.finish_customize_mask = function(l_139_0)
  print("finish_customize_mask", inspect(l_139_0._customize_mask))
  local blueprint = l_139_0:get_customized_mask_blueprint()
  local slot = l_139_0._customize_mask.slot
  managers.money:on_buy_mask(l_139_0._customize_mask.mask_id, l_139_0._customize_mask.global_value, blueprint)
  if not l_139_0._customize_mask.textures then
    l_139_0._customize_mask.textures = {id = "no_color_full_material", global_value = "normal"}
  end
  if not l_139_0._customize_mask.materials then
    l_139_0._customize_mask.materials = {id = "plastic", global_value = "normal"}
  end
  if Idstring(blueprint.pattern.id) ~= Idstring("no_color_full_material") then
    l_139_0:remove_item(blueprint.color.global_value, "colors", blueprint.color.id)
    l_139_0:alter_global_value_item(blueprint.color.global_value, "colors", slot, blueprint.color.id, INV_TO_CRAFT)
    l_139_0:remove_item(blueprint.pattern.global_value, "textures", blueprint.pattern.id)
    l_139_0:alter_global_value_item(blueprint.pattern.global_value, "textures", slot, blueprint.pattern.id, INV_TO_CRAFT)
  else
    blueprint.color = {id = "nothing", global_value = "normal"}
  end
  if Idstring(blueprint.pattern.id) ~= Idstring("solidfirst") and Idstring(blueprint.pattern.id) ~= Idstring("solidsecond") then
    l_139_0:remove_item(blueprint.material.global_value, "materials", blueprint.material.id)
    l_139_0:alter_global_value_item(blueprint.material.global_value, "materials", slot, blueprint.material.id, INV_TO_CRAFT)
  else
    blueprint.material = {id = "plastic", global_value = "normal"}
  end
  l_139_0._customize_mask = nil
  l_139_0:set_mask_blueprint(slot, blueprint)
  local modified_slot = managers.blackmarket:get_crafted_category("masks")[slot]
  if modified_slot then
    modified_slot.modded = true
    if modified_slot.equipped then
      l_139_0:equip_mask(slot)
    end
  end
  managers.achievment:award("masked_villain")
end

BlackMarketManager.on_buy_mask_to_inventory = function(l_140_0, l_140_1, l_140_2, l_140_3)
  l_140_0:on_buy_mask(l_140_1, l_140_2, l_140_3)
  l_140_0:remove_item(l_140_2, "masks", l_140_1)
  l_140_0:alter_global_value_item(l_140_2, "masks", l_140_3, l_140_1, INV_TO_CRAFT)
end

BlackMarketManager.on_buy_mask = function(l_141_0, l_141_1, l_141_2, l_141_3)
  local category = "masks"
  if not l_141_0._global.crafted_items[category] then
    l_141_0._global.crafted_items[category] = {}
  end
  local blueprint = {}
  blueprint.color = {id = "nothing", global_value = "normal"}
  blueprint.pattern = {id = "no_color_no_material", global_value = "normal"}
  blueprint.material = {id = "plastic", global_value = "normal"}
  l_141_0._global.crafted_items[category][l_141_3] = {mask_id = l_141_1, global_value = l_141_2, blueprint = blueprint, modded = false}
  l_141_0:_verfify_equipped_category(category)
end

BlackMarketManager.get_default_mask_blueprint = function(l_142_0)
  local blueprint = {}
  blueprint.color = {id = "nothing", global_value = "normal"}
  blueprint.pattern = {id = "no_color_no_material", global_value = "normal"}
  blueprint.material = {id = "plastic", global_value = "normal"}
  return blueprint
end

BlackMarketManager.on_sell_inventory_mask = function(l_143_0, l_143_1, l_143_2)
  local blueprint = {}
  blueprint.color = {id = "nothing", global_value = "normal"}
  blueprint.pattern = {id = "no_color_no_material", global_value = "normal"}
  blueprint.material = {id = "plastic", global_value = "normal"}
  managers.money:on_sell_mask(l_143_1, l_143_2, blueprint)
  l_143_0:remove_item(l_143_2, "masks", l_143_1)
  l_143_0:alter_global_value_item(l_143_2, "masks", nil, l_143_1, INV_REMOVE)
end

BlackMarketManager.on_sell_mask = function(l_144_0, l_144_1)
  local category = "masks"
  if not l_144_0._global.crafted_items[category] or not l_144_0._global.crafted_items[category][l_144_1] then
    return 
  end
  local mask = l_144_0._global.crafted_items[category][l_144_1]
  managers.money:on_sell_mask(mask.mask_id, mask.global_value, mask.blueprint)
  if l_144_1 == l_144_0:equipped_mask_slot() then
    l_144_0:equip_mask(1)
  end
  if not mask.blueprint then
    local blueprint = {}
  end
  for category,part in pairs(blueprint) do
    local converted_category = ((category ~= "color" or not "colors") and (category ~= "material" or not "materials") and (category == "pattern" and "textures")) or category
    Application:debug(part.global_value, converted_category, l_144_1, part.id, CRAFT_REMOVE)
    l_144_0:alter_global_value_item(part.global_value, converted_category, l_144_1, part.id, CRAFT_REMOVE)
  end
  l_144_0:alter_global_value_item(mask.global_value, category, l_144_1, mask.mask_id, CRAFT_REMOVE)
  l_144_0._global.crafted_items[category][l_144_1] = nil
  l_144_0:_verfify_equipped_category(category)
end

BlackMarketManager.view_mask_with_mask_id = function(l_145_0, l_145_1)
  managers.menu_scene:spawn_mask(l_145_1)
end

BlackMarketManager.view_mask = function(l_146_0, l_146_1)
  local category = "masks"
  if not l_146_0._global.crafted_items[category] or not l_146_0._global.crafted_items[category][l_146_1] then
    Application:error("[BlackMarketManager:view_mask] Trying to view mask that doesn't exist", category, l_146_1)
    return 
  end
  local data = l_146_0._global.crafted_items[category][l_146_1]
  local mask_id = data.mask_id
  local blueprint = data.blueprint
  managers.menu_scene:spawn_mask(mask_id, blueprint)
end

BlackMarketManager.view_mask_with_blueprint = function(l_147_0, l_147_1, l_147_2)
  local category = "masks"
  if not l_147_0._global.crafted_items[category] or not l_147_0._global.crafted_items[category][l_147_1] then
    Application:error("[BlackMarketManager:view_mask_with_blueprint] Trying to view mask that doesn't exist", category, l_147_1)
    return 
  end
  local data = l_147_0._global.crafted_items[category][l_147_1]
  local mask_id = data.mask_id
  if not l_147_0:can_view_mask_blueprint(l_147_2) then
    managers.menu_scene:spawn_or_update_mask(mask_id, data.blueprint)
  else
    managers.menu_scene:spawn_or_update_mask(mask_id, l_147_2)
  end
end

BlackMarketManager.set_mask_blueprint = function(l_148_0, l_148_1, l_148_2)
  local category = "masks"
  if not l_148_0._global.crafted_items[category] or not l_148_0._global.crafted_items[category][l_148_1] then
    Application:error("[BlackMarketManager:set_mask_blueprint] Trying to set blueprint for mask that doesn't exist", category, l_148_1)
    return 
  end
  if not l_148_2 then
    Application:error("[BlackMarketManager:set_mask_blueprint] Need to provide a blueprint")
    return 
  end
  l_148_0._global.crafted_items[category][l_148_1].blueprint = l_148_2
end

BlackMarketManager.mask_unit_name_by_mask_id = function(l_149_0, l_149_1, l_149_2)
  if l_149_1 ~= "character_locked" then
    return tweak_data.blackmarket.masks[l_149_1].unit
  end
  local character = l_149_0:get_preferred_character()
  if managers.network and managers.network:session() and l_149_2 then
    print("HERE", managers.network:session(), l_149_2)
    character = managers.network:session():peer(l_149_2):character()
  end
  character = CriminalsManager.convert_old_to_new_character_workname(character)
  return tweak_data.blackmarket.masks[l_149_1][character]
end

BlackMarketManager.character_sequence_by_character_id = function(l_150_0, l_150_1, l_150_2)
  if l_150_1 ~= "locked" then
    return tweak_data.blackmarket.characters[l_150_1].sequence
  end
  local character = l_150_0:get_preferred_character()
  if managers.network and managers.network:session() and l_150_2 then
    print("character_sequence_by_character_id", managers.network:session(), l_150_2, character)
    character = managers.network:session():peer(l_150_2):character()
  end
  character = CriminalsManager.convert_old_to_new_character_workname(character)
  print("character_sequence_by_character_id", "character", character, "character_id", l_150_1)
  return tweak_data.blackmarket.characters[l_150_1][character].sequence
end

BlackMarketManager.reset = function(l_151_0)
  l_151_0._global.inventory = {}
  l_151_0._global.crafted_items = {}
  l_151_0._global.global_value_items = {}
  l_151_0._global.new_drops = {}
  l_151_0._global.new_item_type_unlocked = {}
  l_151_0:_setup_weapons()
  l_151_0:_setup_characters()
  l_151_0:_setup_armors()
  l_151_0:_setup_track_global_values()
  l_151_0:aquire_default_weapons()
  l_151_0:aquire_default_masks()
  l_151_0:_verfify_equipped()
  if managers.menu_scene then
    managers.menu_scene:on_blackmarket_reset()
  end
end

BlackMarketManager.save = function(l_152_0, l_152_1)
  local save_data = deep_clone(l_152_0._global)
  save_data.equipped_armor = l_152_0:equipped_armor()
  save_data.armors = nil
  save_data.masks = nil
  save_data.weapon_upgrades = nil
  save_data.weapons = nil
  l_152_1.blackmarket = save_data
end

BlackMarketManager.load = function(l_153_0, l_153_1)
  if l_153_1.blackmarket then
    if not l_153_0._global then
      local default_global = {}
    end
    Global.blackmarket_manager = l_153_1.blackmarket
    l_153_0._global = Global.blackmarket_manager
    if l_153_0._global.equipped_armor and type(l_153_0._global.equipped_armor) ~= "string" then
      l_153_0._global.equipped_armor = nil
    end
    if not default_global.armors then
      l_153_0._global.armors = {}
    end
    for armor,_ in pairs(tweak_data.blackmarket.armors) do
      if not l_153_0._global.armors[armor] then
        l_153_0._global.armors[armor] = {unlocked = false, owned = false, equipped = false}
        for (for control),armor in (for generator) do
        end
        l_153_0._global.armors[armor].equipped = false
      end
      if not l_153_0._global.equipped_armor then
        l_153_0._global.armors[l_153_0._defaults.armor].equipped = true
        l_153_0._global.equipped_armor = nil
        if not default_global.weapons then
          l_153_0._global.weapons = {}
        end
        for weapon,data in pairs(tweak_data.weapon) do
          if not l_153_0._global.weapons[weapon] and data.autohit then
            local selection_index = data.use_data.selection_index
            local factory_id = managers.weapon_factory:get_factory_id_by_weapon_id(weapon)
            l_153_0._global.weapons[weapon] = {owned = false, equipped = false, unlocked = false, factory_id = factory_id, selection_index = selection_index}
          end
        end
        if not l_153_0._global._preferred_character then
          l_153_0._global._preferred_character = l_153_0._defaults.preferred_character
        end
        for character,_ in pairs(tweak_data.blackmarket.characters) do
          if not l_153_0._global.characters[character] then
            l_153_0._global.characters[character] = {unlocked = true, owned = true, equipped = false}
          end
        end
        for character,_ in pairs(clone(l_153_0._global.characters)) do
          if not tweak_data.blackmarket.characters[character] then
            l_153_0._global.characters[character] = nil
          end
        end
        if not l_153_0:equipped_character() then
          l_153_0._global.characters[l_153_0._defaults.character].equipped = true
        end
        if not l_153_0._global.inventory then
          l_153_0._global.inventory = {}
        end
        if not l_153_0._global.crafted_items then
          l_153_0._global.crafted_items = {}
        end
        if not l_153_0._global.new_drops then
          l_153_0._global.new_drops = {}
        end
        if not l_153_0._global.new_item_type_unlocked then
          l_153_0._global.new_item_type_unlocked = {}
        end
        if not l_153_0._global.global_value_items then
          l_153_0:_setup_track_global_values()
        end
      end
       -- Warning: missing end command somewhere! Added here
    end
     -- Warning: missing end command somewhere! Added here
  end
end

BlackMarketManager._load_done = function(l_154_0)
  Application:debug("BlackMarketManager:_load_done()")
  l_154_0:aquire_default_weapons()
  l_154_0:aquire_default_masks()
  l_154_0:_verfify_equipped()
  if managers.menu_scene then
    managers.menu_scene:set_character(l_154_0:equipped_character())
    managers.menu_scene:on_set_preferred_character()
    local equipped_mask = l_154_0:equipped_mask()
    if equipped_mask.mask_id then
      managers.menu_scene:set_character_mask_by_id(equipped_mask.mask_id, equipped_mask.blueprint)
    else
      managers.menu_scene:set_character_mask(tweak_data.blackmarket.masks[equipped_mask].unit)
    end
    managers.menu_scene:set_character_armor(l_154_0:equipped_armor())
    local secondary = l_154_0:equipped_secondary()
    if secondary then
      managers.menu_scene:set_character_equipped_weapon(nil, secondary.factory_id, secondary.blueprint, "secondary")
    end
    local primary = l_154_0:equipped_primary()
    if primary then
      managers.menu_scene:set_character_equipped_weapon(nil, primary.factory_id, primary.blueprint, "primary")
    end
  end
end

BlackMarketManager.verify_dlc_items = function(l_155_0)
  l_155_0:_verify_dlc_items()
end

BlackMarketManager._verify_dlc_items = function(l_156_0)
  Application:debug("-----------------------BlackMarketManager:_verify_dlc_items-----------------------")
  do
    local owns_dlc = nil
    for package_id,data in pairs(tweak_data.dlc) do
      if tweak_data.lootdrop.global_values[package_id] then
        if tweak_data.lootdrop.global_values[package_id].dlc and not data.free then
          owns_dlc = managers.dlc:has_dlc(package_id)
        end
        print(owns_dlc, tweak_data.lootdrop.global_values[package_id].dlc, not data.free, not managers.dlc:has_dlc(package_id))
        if owns_dlc then
          for (for control),package_id in (for generator) do
          end
          if l_156_0._global.global_value_items[package_id] then
            print("You do not own " .. package_id .. ", will lock all related items.")
            if not l_156_0._global.global_value_items[package_id].crafted_items then
              local all_crafted_items = {}
            end
            if not all_crafted_items.primaries then
              local primaries = {}
            end
            if not all_crafted_items.secondaries then
              local secondaries = {}
            end
            for slot,parts in pairs(primaries) do
              local crafted = managers.blackmarket:get_crafted_category("primaries")
              if not crafted then
                do return end
              end
              crafted = crafted[slot]
              if crafted then
                local factory_id = crafted.factory_id
                local default_blueprint = managers.weapon_factory:get_default_blueprint_by_factory_id(factory_id)
                for part_id,only_one in pairs(parts) do
                  if only_one ~= 1 then
                    Application:error("[BlackMarketManager] _verify_dlc_items(): something wrong with", primaries, part_id, only_one)
                  end
                  local default_mod = nil
                  local ids_id = Idstring(tweak_data.weapon.factory.parts[part_id].type)
                  for i,d_mod in ipairs(default_blueprint) do
                    if Idstring(tweak_data.weapon.factory.parts[d_mod].type) == ids_id then
                      default_mod = d_mod
                  else
                    end
                  end
                  if default_mod then
                    l_156_0:buy_and_modify_weapon("primaries", slot, "normal", default_mod, true)
                  else
                    l_156_0:remove_weapon_part("primaries", slot, package_id, part_id)
                  end
                  managers.money:refund_weapon_part(crafted.weapon_id, part_id, package_id)
                end
              end
            end
            for slot,parts in pairs(secondaries) do
              local crafted = managers.blackmarket:get_crafted_category("secondaries")
              if not crafted then
                do return end
              end
              crafted = crafted[slot]
              if crafted then
                local factory_id = crafted.factory_id
                local default_blueprint = managers.weapon_factory:get_default_blueprint_by_factory_id(factory_id)
                for part_id,only_one in pairs(parts) do
                  if only_one ~= 1 then
                    Application:error("[BlackMarketManager] _verify_dlc_items(): something wrong with", secondaries, part_id, only_one)
                  end
                  local default_mod = nil
                  local ids_id = Idstring(tweak_data.weapon.factory.parts[part_id].type)
                  for i,d_mod in ipairs(default_blueprint) do
                    if Idstring(tweak_data.weapon.factory.parts[d_mod].type) == ids_id then
                      default_mod = d_mod
                  else
                    end
                  end
                  if default_mod then
                    l_156_0:buy_and_modify_weapon("secondaries", slot, "normal", default_mod, true)
                  else
                    l_156_0:remove_weapon_part("secondaries", slot, package_id, part_id)
                  end
                  managers.money:refund_weapon_part(crafted.weapon_id, part_id, package_id)
                end
              end
            end
            local mask = managers.blackmarket:equipped_mask()
            local is_locked = mask.global_value == package_id
            if not is_locked then
              for _,part in pairs(mask.blueprint) do
                print(package_id, inspect(part))
                is_locked = part.global_value == package_id
                if is_locked then
                  do return end
                end
              end
            end
            if is_locked then
              l_156_0:equip_mask(1)
            end
          end
        end
      end
    end
     -- Warning: missing end command somewhere! Added here
  end
end

BlackMarketManager._verfify_equipped = function(l_157_0)
  l_157_0:_verfify_equipped_category("secondaries")
  l_157_0:_verfify_equipped_category("primaries")
  l_157_0:_verfify_equipped_category("masks")
  l_157_0:_verfify_equipped_category("armors")
end

BlackMarketManager._verfify_equipped_category = function(l_158_0, l_158_1)
  if l_158_1 == "armors" then
    local armor_id = l_158_0._defaults.armor
    for armor,craft in pairs(Global.blackmarket_manager.armors) do
      if craft.equipped and craft.unlocked and craft.owned then
        armor_id = armor
      end
    end
    for s,data in pairs(Global.blackmarket_manager.armors) do
      data.equipped = s == armor_id
    end
    if managers.menu_scene then
      managers.menu_scene:set_character_armor(armor_id)
    end
    return 
  end
  if not l_158_0._global.crafted_items[l_158_1] then
    return 
  end
  local is_weapon = l_158_1 == "secondaries" or l_158_1 == "primaries"
  for slot,craft in pairs(l_158_0._global.crafted_items[l_158_1]) do
    if craft.equipped and is_weapon then
      if l_158_0._global.weapons[craft.weapon_id].unlocked then
        return 
        for (for control),slot in (for generator) do
        end
        craft.equipped = false
        for (for control),slot in (for generator) do
        end
        return 
      end
      for slot,craft in pairs(l_158_0._global.crafted_items[l_158_1]) do
        if is_weapon and l_158_0._global.weapons[craft.weapon_id].unlocked then
          print("  Equip", l_158_1, slot)
          craft.equipped = true
          return 
          for (for control),slot in (for generator) do
            print("  Equip", l_158_1, slot)
            craft.equipped = true
            return 
          end
        end
        if not l_158_0:_get_free_weapon_slot(l_158_1) then
          local free_slot = l_158_1 ~= "secondaries" and l_158_1 ~= "primaries" or 1
        end
        l_158_0:on_sell_weapon(l_158_1, free_slot)
        local weapon_id = l_158_1 == "primaries" and "amcar" or "glock_17"
        local factory_id = managers.weapon_factory:get_factory_id_by_weapon_id(weapon_id)
        do
          local blueprint = deep_clone(managers.weapon_factory:get_default_blueprint_by_factory_id(factory_id))
          l_158_0._global.crafted_items[l_158_1][free_slot] = {weapon_id = weapon_id, factory_id = factory_id, blueprint = blueprint, equipped = true}
          managers.money:on_buy_weapon_platform(weapon_id, true)
          return 
        end
         -- Warning: missing end command somewhere! Added here
      end
       -- Warning: missing end command somewhere! Added here
    end
     -- Warning: missing end command somewhere! Added here
  end
end

BlackMarketManager.debug_inventory = function(l_159_0)
  local t = {}
  for gv,cat in pairs(l_159_0._global.inventory) do
    for type,entry in pairs(cat) do
      if not t[type] then
        t[type] = {amount = 0}
      end
      for name,amount in pairs(entry) do
        t[type].amount = t[type].amount + amount
      end
    end
  end
  print(inspect(t))
end


