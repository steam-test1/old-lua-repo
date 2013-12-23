-- Decompiled using luadec 2.0.1 by sztupy (http://winmo.sztupy.hu)
-- Command line was: F:\SteamLibrary\SteamApps\common\PAYDAY 2\lua\lib\managers\lootdropmanager.luac 

if not LootDropManager then
  LootDropManager = class()
end
LootDropManager.init = function(l_1_0)
  l_1_0:_setup()
end

LootDropManager._setup = function(l_2_0)
  l_2_0:add_qlvl_to_weapon_mods()
  if not Global.lootdrop_manager then
    Global.lootdrop_manager = {}
    l_2_0:_setup_items()
  end
  l_2_0._global = Global.lootdrop_manager
end

LootDropManager.add_qlvl_to_weapon_mods = function(l_3_0, l_3_1)
  if not l_3_1 then
    local weapon_mods_tweak_data = tweak_data.blackmarket.weapon_mods
  end
  local weapon_level_data = {wpn_fps_ass_amcar = 0, wpn_fps_pis_g17 = 0, wpn_fps_saw = 0}
  for level,data in pairs(tweak_data.upgrades.level_tree) do
    if data.upgrades then
      for _,upgrade in ipairs(data.upgrades) do
        local def = tweak_data.upgrades.definitions[upgrade]
        if def.weapon_id then
          local factory_id = managers.weapon_factory:get_factory_id_by_weapon_id(def.weapon_id)
          weapon_level_data[factory_id] = level
        end
      end
    end
  end
  for part_id,data in pairs(tweak_data.weapon.factory.parts) do
    if not managers.weapon_factory:get_weapons_uses_part(part_id) then
      local weapon_uses_part = {}
    end
    local min_level = managers.experience:level_cap()
    for _,factory_id in ipairs(weapon_uses_part) do
      if not table.contains(tweak_data.weapon.factory[factory_id].default_blueprint, part_id) then
        min_level = math.min(min_level, weapon_level_data[factory_id])
      end
    end
    weapon_mods_tweak_data[part_id].qlvl = min_level
  end
end

LootDropManager._setup_items = function(l_4_0)
  local pc_items = {}
  Global.lootdrop_manager.pc_items = pc_items
  local sort_pc = function(l_1_0, l_1_1)
    for id,item_data in pairs(l_1_1) do
      if not item_data.dlcs then
        local dlcs = {}
      end
      local dlc = item_data.dlc
      if dlc then
        table.insert(dlcs, dlc)
      end
      local has_dlc = #dlcs == 0
      for _,dlc in pairs(dlcs) do
        if not has_dlc then
          has_dlc = managers.dlc:has_dlc(dlc)
        end
      end
      if has_dlc then
        if item_data.pc then
          if not pc_items[item_data.pc] then
            pc_items[item_data.pc] = {}
          end
          if not pc_items[item_data.pc][l_1_0] then
            pc_items[item_data.pc][l_1_0] = {}
          end
          table.insert(pc_items[item_data.pc][l_1_0], id)
        end
        if item_data.pcs then
          for _,pc in ipairs(item_data.pcs) do
            if not pc_items[pc] then
              pc_items[pc] = {}
            end
            if not pc_items[pc][l_1_0] then
              pc_items[pc][l_1_0] = {}
            end
            table.insert(pc_items[pc][l_1_0], id)
          end
        end
      end
    end
   end
  for type,data in pairs(tweak_data.blackmarket) do
    sort_pc(type, data)
  end
end

LootDropManager.debug_drop = function(l_5_0, l_5_1, l_5_2, l_5_3)
  if not l_5_1 then
    l_5_1 = 10
  end
  if not l_5_2 then
    l_5_2 = false
  end
  local debug_infamous = 0
  local debug_max_pc = 0
  if l_5_3 == "random" then
    do return end
  end
  if not l_5_3 then
    l_5_3 = 5
  end
  l_5_0._debug_drop_result = {}
  for i = 1, l_5_1 do
    local s = l_5_3 == "random" and math.random(10) or l_5_3
    local global_value, category, id, pc = l_5_0:_make_drop(true, l_5_2, s)
    if not l_5_0._debug_drop_result[global_value] then
      l_5_0._debug_drop_result[global_value] = {}
    end
    if not l_5_0._debug_drop_result[global_value][category] then
      l_5_0._debug_drop_result[global_value][category] = {}
    end
    l_5_0._debug_drop_result[global_value][category][id] = (l_5_0._debug_drop_result[global_value][category][id] or 0) + 1
    if global_value == "infamous" then
      debug_infamous = debug_infamous + 1
    end
    if pc == tweak_data.lootdrop.STARS[s].pcs[1] then
      debug_max_pc = debug_max_pc + 1
    end
  end
  if l_5_3 ~= "random" then
    Application:debug(debug_max_pc .. " dropped at PC " .. l_5_3, "infamous items dropped: " .. debug_infamous)
  end
  Global.debug_drop_result = l_5_0._debug_drop_result
end

LootDropManager.make_drop = function(l_6_0, l_6_1)
  if type(l_6_1) ~= "table" or not l_6_1 then
    l_6_1 = {}
  end
  l_6_0:_make_drop(false, true, nil, l_6_1)
end

LootDropManager._make_drop = function(l_7_0, l_7_1, l_7_2, l_7_3, l_7_4)
  local human_players = managers.network:game() and managers.network:game():amount_of_alive_players() or 1
  local all_humans = human_players == 4
  local plvl = managers.experience:current_level()
  if not l_7_3 then
    local stars = managers.job:current_job_stars()
  end
  if not l_7_4 then
    l_7_4 = {}
  end
  l_7_4.job_stars = stars
  l_7_4.player_level = plvl
  local difficulty = Global.game_settings.difficulty or "easy"
  local difficulty_id = math.max(0, (tweak_data:difficulty_to_index(difficulty) or 0) - 2)
  stars = stars + difficulty_id
  local player_stars = math.max(math.ceil(plvl / 10), 1)
  difficulty_id = math.min(difficulty_id, stars - l_7_4.job_stars)
  if not all_humans or not l_7_1 then
    print("Total stars", stars)
  end
  stars = player_stars
  l_7_4.player_stars = player_stars
  l_7_4.difficulty_stars = difficulty_id
  l_7_4.total_stars = stars
  local pc = math.lerp(0, 100, stars / 10)
  l_7_4.payclass = pc
  if not l_7_1 then
    print("Pay class", pc)
  end
  local drop_pc = stars * 10
  local pcs = tweak_data.lootdrop.STARS[stars].pcs
  if math.rand(1) <= tweak_data.lootdrop.joker_chance then
    pcs = deep_clone(pcs)
    for i = 1, #pcs do
      local new_value = pcs[i] + math.random(5) * 10 - 30
      if new_value >= 5 and new_value <= 100 then
        pcs[i] = new_value
      end
    end
    l_7_4.joker = true
    if not l_7_1 then
      Application:debug("JOKER")
    end
  end
  if not l_7_1 then
    print("num of pcs", #pcs)
  end
  local chance_risk_mod = tweak_data.lootdrop.risk_pc_multiplier[difficulty_id] or 0
  local chance_curve = tweak_data.lootdrop.STARS_CURVES[stars]
  local start_chance = tweak_data.lootdrop.PC_CHANCE[stars]
  if not l_7_1 then
    print("start_chance before skills: ", start_chance)
  end
  local no_pcs = #pcs
  local pc = nil
  for i = 1, no_pcs do
    local chance = math.lerp(start_chance, 1, math.pow((i - 1) / (no_pcs - 1), chance_curve))
    if not l_7_1 then
      print("chance for", i, pcs[i], "is", chance)
    end
    local roll = math.rand(1)
    if not l_7_1 then
      print(" roll,", roll)
    end
    if roll <= chance then
      if not l_7_1 then
        print(" got it at", i, pcs[i])
      end
      pc = pcs[i]
      l_7_4.item_payclass = pc
  else
    end
  end
  if not l_7_1 then
    print("Select from pc", pc)
  end
  local pc_items = l_7_0._global.pc_items[pc]
  local i_pc_items = {}
  if not l_7_1 then
    print(" Random from type:")
  end
  local weighted_type_chance = tweak_data.lootdrop.WEIGHTED_TYPE_CHANCE[pc]
  local sum = 0
  for type,items in pairs(pc_items) do
    sum = sum + weighted_type_chance[type]
    if not l_7_1 then
      print("added", type, weighted_type_chance[type], "to sum", sum)
    end
  end
  if not l_7_1 then
    print("sum", sum)
  end
  local normalized_chance = {}
  for type,items in pairs(pc_items) do
    normalized_chance[type] = weighted_type_chance[type] / (sum)
  end
  if not l_7_1 then
    print("normalized_chance", inspect(normalized_chance))
  end
  local has_result = nil
  repeat
    repeat
      repeat
        repeat
          if not has_result then
            local type_items = l_7_0:_get_type_items(normalized_chance, l_7_1)
            if not l_7_1 then
              print(" Type result", type_items)
            end
            local items = pc_items[type_items]
            local item_entry = items[math.random(#items)]
            local global_value = "normal"
          until not tweak_data.blackmarket[type_items][item_entry].qlvl or tweak_data.blackmarket[type_items][item_entry].qlvl <= plvl
          local global_value_chance = math.rand(1)
          local quality_mul = managers.player:upgrade_value("player", "passive_loot_drop_multiplier", 1) * managers.player:upgrade_value("player", "loot_drop_multiplier", 1)
          if tweak_data.blackmarket[type_items][item_entry].infamous and global_value_chance < tweak_data.lootdrop.global_values.infamous.chance * quality_mul then
            global_value = "infamous"
          else
            if not tweak_data.blackmarket[type_items][item_entry].dlcs then
              local dlcs = {}
            end
            local dlc = tweak_data.blackmarket[type_items][item_entry].dlc
            if dlc then
              table.insert(dlcs, dlc)
            end
            local dlc_global_values = {}
            for _,dlc in pairs(dlcs) do
              if managers.dlc:has_dlc(dlc) then
                table.insert(dlc_global_values, dlc)
              end
            end
            if #dlc_global_values > 0 then
              global_value = dlc_global_values[math.random(#dlc_global_values)]
            end
          end
          if tweak_data.blackmarket[type_items][item_entry].max_in_inventory and tweak_data.blackmarket[type_items][item_entry].max_in_inventory <= managers.blackmarket:get_item_amount(global_value, type_items, item_entry) then
            do return end
          end
        until not tweak_data.blackmarket[type_items][item_entry].infamous or global_value == "infamous"
        has_result = true
        if not l_7_1 then
          print("You got", item_entry, "of type", type_items, "with global value", global_value)
        end
        if l_7_2 then
          if type_items == "cash" then
            managers.blackmarket:add_to_inventory(global_value, type_items, item_entry)
          else
            managers.blackmarket:add_to_inventory(global_value, type_items, item_entry)
          end
          l_7_4.global_value = global_value
          l_7_4.type_items = type_items
          l_7_4.item_entry = item_entry
        end
        if not l_7_1 then
          print(inspect(tweak_data.blackmarket[type_items][item_entry]))
        end
         -- DECOMPILER ERROR: Confused while interpreting a jump as a 'while'

      end
      return global_value, type_items, item_entry, pc
    else
       -- Warning: missing end command somewhere! Added here
    end
     -- Warning: missing end command somewhere! Added here
  end
end

LootDropManager._get_type_items = function(l_8_0, l_8_1, l_8_2)
  local seed = math.rand(1)
  if not l_8_2 then
    print("seed", seed)
  end
  for type,weight in pairs(l_8_1) do
    seed = seed - weight
    if not l_8_2 then
      print("   sub seed", type, weight, seed)
    end
    if seed <= 0 then
      if not l_8_2 then
        print("RETURN TYPE", type)
      end
      return type
    end
  end
  return next(l_8_1)
end

LootDropManager.reset = function(l_9_0)
  Global.lootdrop_manager = nil
  l_9_0:_setup()
end

LootDropManager.debug_check_items = function(l_10_0, l_10_1)
  for type,data in pairs(tweak_data.blackmarket) do
    if not l_10_1 or type == l_10_1 then
      for id,item_data in pairs(data) do
        if not item_data.pc and not item_data.pcs then
          print("Item", id, "of type", type, "hasn't been assigned a pay class")
        end
      end
    end
  end
end

LootDropManager.debug_print_pc_items = function(l_11_0, l_11_1)
  for type,data in pairs(tweak_data.blackmarket) do
    if not l_11_1 or type == l_11_1 then
      for id,item_data in pairs(data) do
        if not item_data.name_id or not managers.localization:text(item_data.name_id) then
          local name = l_11_1 == "weapon_mods" and not item_data.pc and not item_data.pcs or "NO NAME"
        end
        local pcs = "" .. (item_data.pc or "")
        if item_data.pcs then
          for _,pc in ipairs(item_data.pcs) do
            pcs = pcs .. " " .. pc
          end
        end
        local infamous = item_data.infamous and "infamous" or ""
        print(name, id, pcs, infamous)
      end
    end
  end
end

LootDropManager.save = function(l_12_0, l_12_1)
  l_12_1.LootDropManager = l_12_0._global
end

LootDropManager.load = function(l_13_0, l_13_1)
  l_13_0._global = l_13_1.LootDropManager
end


