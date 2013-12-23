-- Decompiled using luadec 2.0.1 by sztupy (http://winmo.sztupy.hu)
-- Command line was: F:\SteamLibrary\SteamApps\common\PAYDAY 2\lua\lib\managers\moneymanager.luac 

if not MoneyManager then
  MoneyManager = class()
end
MoneyManager.init = function(l_1_0)
  l_1_0:_setup()
end

MoneyManager._setup = function(l_2_0)
  if not Global.money_manager then
    Global.money_manager = {}
    Global.money_manager.total = Application:digest_value(0, true)
    Global.money_manager.total_collected = Application:digest_value(0, true)
    Global.money_manager.offshore = Application:digest_value(0, true)
    Global.money_manager.total_spent = Application:digest_value(0, true)
  end
  l_2_0._global = Global.money_manager
  l_2_0._heist_total = 0
  l_2_0._heist_spending = 0
  l_2_0._heist_offshore = 0
  l_2_0._active_multipliers = {}
  l_2_0._stage_payout = 0
  l_2_0._job_payout = 0
  l_2_0._bag_payout = 0
  l_2_0._small_loot_payout = 0
  l_2_0._crew_payout = 0
  l_2_0._cash_tousand_separator = managers.localization:text("cash_tousand_separator")
  l_2_0._cash_sign = managers.localization:text("cash_sign")
end

MoneyManager.total_string_no_currency = function(l_3_0)
  local total = math.round(l_3_0:total())
  total = tostring(total)
  local reverse = string.reverse(total)
  local s = ""
  for i = 1, string.len(reverse) do
    s = s .. string.sub(reverse, i, i) .. (math.mod(i, 3) == 0 and i ~= string.len(reverse) and l_3_0._cash_tousand_separator or "")
  end
  return string.reverse(s)
end

MoneyManager.total_string = function(l_4_0)
  local total = math.round(l_4_0:total())
  total = tostring(total)
  local reverse = string.reverse(total)
  local s = ""
  for i = 1, string.len(reverse) do
    s = s .. string.sub(reverse, i, i) .. (math.mod(i, 3) == 0 and i ~= string.len(reverse) and l_4_0._cash_tousand_separator or "")
  end
  return l_4_0._cash_sign .. string.reverse(s)
end

MoneyManager.total_collected_string_no_currency = function(l_5_0)
  local total = math.round(l_5_0:total_collected())
  total = tostring(total)
  local reverse = string.reverse(total)
  local s = ""
  for i = 1, string.len(reverse) do
    s = s .. string.sub(reverse, i, i) .. (math.mod(i, 3) == 0 and i ~= string.len(reverse) and l_5_0._cash_tousand_separator or "")
  end
  return string.reverse(s)
end

MoneyManager.total_collected_string = function(l_6_0)
  local total = math.round(l_6_0:total_collected())
  total = tostring(total)
  local reverse = string.reverse(total)
  local s = ""
  for i = 1, string.len(reverse) do
    s = s .. string.sub(reverse, i, i) .. (math.mod(i, 3) == 0 and i ~= string.len(reverse) and l_6_0._cash_tousand_separator or "")
  end
  return l_6_0._cash_sign .. string.reverse(s)
end

MoneyManager.add_decimal_marks_to_string = function(l_7_0, l_7_1)
  local total = l_7_1
  local reverse = l_7_1.reverse(total)
  local s = ""
  for i = 1, l_7_1.len(reverse) do
    s = s .. l_7_1.sub(reverse, i, i) .. (math.mod(i, 3) == 0 and i ~= l_7_1.len(reverse) and l_7_0._cash_tousand_separator or "")
  end
  return l_7_1.reverse(s)
end

MoneyManager.use_multiplier = function(l_8_0, l_8_1)
  if not tweak_data.money_manager.multipliers[l_8_1] then
    Application:error("Unknown multiplier \"" .. tostring(l_8_1) .. " in money manager.")
    return 
  end
  l_8_0._active_multipliers[l_8_1] = tweak_data.money_manager.multipliers[l_8_1]
end

MoneyManager.remove_multiplier = function(l_9_0, l_9_1)
  if not tweak_data.money_manager.multipliers[l_9_1] then
    Application:error("Unknown multiplier \"" .. tostring(l_9_1) .. " in money manager.")
    return 
  end
  l_9_0._active_multipliers[l_9_1] = nil
end

MoneyManager.perform_action = function(l_10_0, l_10_1)
  return 
end

MoneyManager.perform_action_interact = function(l_11_0, l_11_1)
  return 
end

MoneyManager.perform_action_money_wrap = function(l_12_0, l_12_1)
  l_12_0:_add(l_12_1)
end

MoneyManager.get_civilian_deduction = function(l_13_0)
  local has_active_job = managers.job:has_active_job()
  local job_and_difficulty_stars = has_active_job and managers.job:current_job_and_difficulty_stars() or 1
  return math.round(tweak_data:get_value("money_manager", "killing_civilian_deduction", job_and_difficulty_stars))
end

MoneyManager.civilian_killed = function(l_14_0)
  local deduct_amount = l_14_0:get_civilian_deduction()
  local text = managers.localization:text("hud_civilian_killed_message", {AMOUNT = managers.experience:cash_string(deduct_amount)})
  local title = managers.localization:text("hud_civilian_killed_title")
  managers.hud:present_mid_text({text = text, title = title, time = 4})
  l_14_0:_deduct_from_total(deduct_amount)
end

MoneyManager.on_mission_completed = function(l_15_0, l_15_1)
  if managers.job:interupt_stage() then
    return 
  end
  local stage_value, job_value, bag_value, small_value, crew_value, total_payout = l_15_0:get_real_job_money_values(l_15_1)
  l_15_0:_set_stage_payout(stage_value)
  l_15_0:_set_job_payout(job_value)
  l_15_0:_set_bag_payout(bag_value)
  l_15_0:_set_small_loot_payout(small_value)
  l_15_0:_set_crew_payout(crew_value)
  l_15_0:_add_to_total(total_payout)
end

MoneyManager.get_real_job_money_values = function(l_16_0, l_16_1)
  local has_active_job = managers.job:has_active_job()
  local job_and_difficulty_stars = has_active_job and managers.job:current_job_and_difficulty_stars() or 1
  local job_stars = has_active_job and managers.job:current_job_stars() or 1
  local difficulty_stars = job_and_difficulty_stars - job_stars
  local player_stars = managers.experience:level_to_stars()
  local is_level_limited = player_stars < job_and_difficulty_stars
  local total_stars = math.min(job_and_difficulty_stars, player_stars)
  local total_difficulty_stars = math.max(0, total_stars - job_stars)
  local money_multiplier = managers.money:get_contract_difficulty_multiplier(total_difficulty_stars) or 0
  local small_loot_multiplier = managers.money:get_small_loot_difficulty_multiplier(total_difficulty_stars) or 0
  total_stars = math.min(job_stars, total_stars)
  local secured_bags = managers.loot:get_secured_bonus_bags_value()
  local real_small_value = math.round(managers.loot:get_real_total_small_loot_value())
  local stage_value = l_16_0:get_stage_payout_by_stars(total_stars) or 0
  local job_value = 0
  local bag_value = 0
  local crew_value = 0
  local small_value = real_small_value
  if not l_16_0:get_job_payout_by_stars(total_stars) then
    job_value = not managers.job:on_last_stage() or 0
  end
  bag_value = secured_bags * tweak_data:get_value("money_manager", "bag_value_multiplier", total_stars)
  stage_value = math.round(stage_value + stage_value * money_multiplier)
  job_value = math.round((job_value) + (job_value) * money_multiplier)
  bag_value = math.round(bag_value + bag_value * money_multiplier)
  small_value = math.round(small_value + small_value * small_loot_multiplier)
  local total_payout = math.round(stage_value + job_value + bag_value + small_value)
  if is_level_limited then
    local player_pc_payout = total_payout
    local potential_pc_payout = 0
    local money_multiplier = managers.money:get_contract_difficulty_multiplier(difficulty_stars)
    local small_loot_multiplier = managers.money:get_small_loot_difficulty_multiplier(difficulty_stars)
    local new_stage_value = l_16_0:get_stage_payout_by_stars(job_stars) or 0
    local new_job_value = 0
    local new_bag_value = 0
    local new_small_value = real_small_value
    if not l_16_0:get_job_payout_by_stars(job_stars) then
      new_job_value = not managers.job:on_last_stage() or 0
    end
    new_bag_value = secured_bags * tweak_data:get_value("money_manager", "bag_value_multiplier", job_stars)
    potential_pc_payout = math.round(new_stage_value + (new_job_value) + new_bag_value)
    potential_pc_payout = math.round(potential_pc_payout + potential_pc_payout * money_multiplier)
    potential_pc_payout = potential_pc_payout + (new_small_value + new_small_value * small_loot_multiplier)
    local low_cap_multiplier = tweak_data:get_value("money_manager", "level_limit", "low_cap_multiplier")
    if managers.experience:current_level() <= tweak_data:get_value("money_manager", "level_limit", "low_cap_level") then
      player_pc_payout = player_pc_payout + player_pc_payout * low_cap_multiplier
      player_pc_payout = math.round(math.min(player_pc_payout, potential_pc_payout))
      stage_value = stage_value + stage_value * low_cap_multiplier
      stage_value = math.round(math.min(stage_value, new_stage_value))
      job_value = job_value + job_value * low_cap_multiplier
      job_value = math.round(math.min(job_value, new_job_value))
      bag_value = bag_value + bag_value * low_cap_multiplier
      bag_value = math.round(math.min(bag_value, new_bag_value))
      small_value = small_value + small_value * low_cap_multiplier
      small_value = math.round(math.min(small_value, new_small_value))
    else
      local diff_in_money = potential_pc_payout - player_pc_payout
      local diff_in_stars = job_and_difficulty_stars - player_stars
      local tweak_multiplier = tweak_data:get_value("money_manager", "level_limit", "pc_difference_multipliers", diff_in_stars) or 0
      player_pc_payout = player_pc_payout + diff_in_money * tweak_multiplier
      player_pc_payout = math.round(math.min(player_pc_payout, potential_pc_payout))
      new_stage_value = new_stage_value + new_stage_value * money_multiplier
      do
        local diff_in_money = new_stage_value - stage_value
        stage_value = stage_value + diff_in_money * tweak_multiplier
        stage_value = math.round(math.min(stage_value, new_stage_value))
      end
      new_job_value = (new_job_value) + (new_job_value) * money_multiplier
      do
        local diff_in_money = new_job_value - job_value
        job_value = job_value + diff_in_money * tweak_multiplier
        job_value = math.round(math.min(job_value, new_job_value))
      end
      new_bag_value = new_bag_value + new_bag_value * money_multiplier
      do
        local diff_in_money = new_bag_value - bag_value
        bag_value = bag_value + diff_in_money * tweak_multiplier
        bag_value = math.round(math.min(bag_value, new_bag_value))
      end
      new_small_value = new_small_value + new_small_value * small_loot_multiplier
      do
        local diff_in_money = new_small_value - small_value
        small_value = small_value + diff_in_money * tweak_multiplier
        small_value = math.round(math.min(small_value, new_small_value))
      end
      local collected_value = stage_value + job_value + bag_value + small_value
      if player_pc_payout ~= collected_value then
        local rounded_error_value = player_pc_payout - collected_value
        small_value = small_value - rounded_error_value
        print("ROUNDING ERROR DETECTED", rounded_error_value)
      end
    end
    total_payout = player_pc_payout
  end
  total_payout = math.round(total_payout)
  crew_value = total_payout
  total_payout = math.round(total_payout * (tweak_data:get_value("money_manager", "alive_humans_multiplier", l_16_1) or 1))
  crew_value = math.round(total_payout - crew_value)
  total_payout = total_payout + tweak_data:get_value("money_manager", "flat_stage_completion")
  stage_value = stage_value + tweak_data:get_value("money_manager", "flat_stage_completion")
  if managers.job:on_last_stage() then
    total_payout = total_payout + tweak_data:get_value("money_manager", "flat_job_completion")
    job_value = job_value + tweak_data:get_value("money_manager", "flat_job_completion")
  end
  return stage_value, job_value, bag_value, small_value, crew_value, total_payout
end

MoneyManager.on_stage_completed = function(l_17_0, l_17_1)
  if not managers.job:has_active_job() then
    return 0
  end
  local stage_value = l_17_0:_get_contract_money(false, nil)
  local amount = stage_value
  amount = math.round(amount * tweak_data:get_value("money_manager", "alive_humans_multiplier", l_17_1))
  l_17_0:_add_to_total(amount)
  l_17_0:_set_stage_payout(stage_value)
  l_17_0:_set_crew_payout(amount - stage_value)
  return amount
end

MoneyManager.on_job_completed = function(l_18_0, l_18_1)
  if not managers.job:has_active_job() then
    return 0
  end
  local stage_value = l_18_0:_get_contract_money(false, nil)
  local job_value = l_18_0:_get_contract_money(true, nil)
  local bag_value = l_18_0:get_secured_bonus_bags_money()
  local amount = stage_value + job_value
  amount = amount + bag_value
  amount = math.round((amount) * tweak_data:get_value("money_manager", "alive_humans_multiplier", l_18_1))
  l_18_0:_add_to_total(amount)
  l_18_0:_set_stage_payout(stage_value)
  l_18_0:_set_job_payout(job_value)
  l_18_0:_set_bag_payout(bag_value)
  l_18_0:_set_crew_payout(amount - stage_value - job_value - bag_value)
  return amount
end

MoneyManager.get_secured_bonus_bags_money = function(l_19_0)
  local has_active_job = managers.job:has_active_job()
  local job_and_difficulty_stars = has_active_job and managers.job:current_job_and_difficulty_stars() or 1
  local job_stars = has_active_job and managers.job:current_job_stars() or 1
  local difficulty_stars = job_and_difficulty_stars - job_stars
  local player_stars = managers.experience:level_to_stars()
  local is_level_limited = player_stars < job_and_difficulty_stars
  local total_stars = job_and_difficulty_stars
  local total_difficulty_stars = math.max(0, total_stars - job_stars)
  local money_multiplier = managers.money:get_contract_difficulty_multiplier(total_difficulty_stars) or 0
  total_stars = math.min(job_stars, total_stars)
  local secured_bags = managers.loot:get_secured_bonus_bags_value()
  local bag_value = 0
  bag_value = secured_bags * tweak_data:get_value("money_manager", "bag_value_multiplier", total_stars)
  bag_value = math.round(bag_value)
  return bag_value
end

MoneyManager._get_contract_money = function(l_20_0, l_20_1, l_20_2)
  local has_active_job = managers.job:has_active_job()
  local job_and_difficulty_stars = has_active_job and managers.job:current_job_and_difficulty_stars() or 1
  local job_stars = has_active_job and managers.job:current_job_stars() or 1
  local difficulty_stars = job_and_difficulty_stars - job_stars
  local player_stars = managers.experience:level_to_stars()
  local total_stars = math.min(job_and_difficulty_stars, player_stars + 1)
  local total_difficulty_stars = math.max(0, total_stars - job_stars)
  local money_multiplier = l_20_0:get_contract_difficulty_multiplier(total_difficulty_stars)
  total_stars = math.min(job_stars, total_stars)
  local contract_money = 0
  if l_20_1 then
    contract_money = contract_money + l_20_0:get_job_payout_by_stars(total_stars)
  else
    contract_money = contract_money + l_20_0:get_stage_payout_by_stars(total_stars)
  end
  contract_money = contract_money + (contract_money) * money_multiplier
  return math.round(contract_money)
end

MoneyManager.get_job_bag_value = function(l_21_0)
  local has_active_job = managers.job:has_active_job()
  local job_and_difficulty_stars = has_active_job and managers.job:current_job_and_difficulty_stars() or 1
  return tweak_data:get_value("money_manager", "bag_value_multiplier", job_and_difficulty_stars)
end

MoneyManager.get_bag_value = function(l_22_0, l_22_1)
  local carry_data = tweak_data.carry[l_22_1]
  local bag_value_id = carry_data.bag_value or "default"
  local value = tweak_data:get_value("money_manager", "bag_values", bag_value_id)
  return math.round(value)
end

MoneyManager.debug_job_completed = function(l_23_0, l_23_1)
  local amount = tweak_data:get_value("money_manager", "job_completion", l_23_1)
  l_23_0:_add_to_total(amount)
end

MoneyManager.get_job_payout_by_stars = function(l_24_0, l_24_1, l_24_2)
  if l_24_2 then
    l_24_1 = math.clamp(l_24_1, 1, #tweak_data.money_manager.stage_completion)
  end
  local amount = tweak_data:get_value("money_manager", "job_completion", l_24_1)
  return amount
end

MoneyManager.get_stage_payout_by_stars = function(l_25_0, l_25_1, l_25_2)
  if l_25_2 then
    l_25_1 = math.clamp(l_25_1, 1, #tweak_data.money_manager.stage_completion)
  end
  local amount = tweak_data:get_value("money_manager", "stage_completion", l_25_1)
  return amount
end

MoneyManager.get_small_loot_difficulty_multiplier = function(l_26_0, l_26_1)
  local multiplier = tweak_data:get_value("money_manager", "small_loot_difficulty_multiplier", l_26_1)
  return multiplier or 0
end

MoneyManager.get_contract_difficulty_multiplier = function(l_27_0, l_27_1)
  local multiplier = tweak_data:get_value("money_manager", "difficulty_multiplier", l_27_1)
  return multiplier or 0
end

MoneyManager.get_potential_payout_from_current_stage = function(l_28_0)
  local stage_value, job_value, bag_value, small_value, crew_value, total_payout = l_28_0:get_real_job_money_values(0)
  return stage_value + job_value
end

MoneyManager.can_afford_weapon = function(l_29_0, l_29_1)
  return l_29_0:get_weapon_price_modified(l_29_1) <= l_29_0:total()
end

MoneyManager.get_weapon_price = function(l_30_0, l_30_1)
  local pc = l_30_0:_get_weapon_pc(l_30_1)
  if not tweak_data.money_manager.weapon_cost[pc] then
    pc = 1
  end
  return tweak_data:get_value("money_manager", "weapon_cost", pc)
end

MoneyManager.get_weapon_price_modified = function(l_31_0, l_31_1)
  local pc = l_31_0:_get_weapon_pc(l_31_1)
  if not tweak_data.money_manager.weapon_cost[pc] then
    pc = 1
  end
  return math.round(tweak_data:get_value("money_manager", "weapon_cost", pc) * managers.player:upgrade_value("player", "buy_cost_multiplier", 1) * managers.player:upgrade_value("player", "crime_net_deal", 1))
end

MoneyManager.get_weapon_slot_sell_value = function(l_32_0, l_32_1, l_32_2)
  local crafted_item = managers.blackmarket:get_crafted_category_slot(l_32_1, l_32_2)
  if not crafted_item then
    return 0
  end
  local weapon_id = crafted_item.weapon_id
  local blueprint = crafted_item.blueprint
  local base_value = l_32_0:get_weapon_price(weapon_id)
  local parts_value = 0
  return math.round((base_value + parts_value) * tweak_data:get_value("money_manager", "sell_weapon_multiplier") * managers.player:upgrade_value("player", "sell_cost_multiplier", 1))
end

MoneyManager.get_weapon_sell_value = function(l_33_0, l_33_1)
  return math.round(l_33_0:get_weapon_price(l_33_1) * tweak_data:get_value("money_manager", "sell_weapon_multiplier") * managers.player:upgrade_value("player", "sell_cost_multiplier", 1))
end

MoneyManager._get_weapon_pc = function(l_34_0, l_34_1)
  local weapon_level = nil
  for level,level_data in pairs(tweak_data.upgrades.level_tree) do
    for _,upgrade in ipairs(level_data.upgrades) do
      if upgrade == l_34_1 then
        weapon_level = level
        for (for control),level in (for generator) do
        end
      end
    end
    if not weapon_level then
      Application:error("DIDN'T FIND LEVEL FOR", l_34_1)
      weapon_level = 1
    end
    do
      local pc = math.ceil(weapon_level)
      return pc
    end
     -- Warning: missing end command somewhere! Added here
  end
end

MoneyManager.on_buy_weapon_platform = function(l_35_0, l_35_1, l_35_2)
  local amount = l_35_0:get_weapon_price_modified(l_35_1)
  l_35_0:_deduct_from_total(math.round(amount * (l_35_2 and tweak_data:get_value("money_manager", "sell_weapon_multiplier") or 1)))
end

MoneyManager.on_sell_weapon = function(l_36_0, l_36_1, l_36_2)
  local amount = l_36_0:get_weapon_slot_sell_value(l_36_1, l_36_2)
  l_36_0:_add_to_total(amount, {no_offshore = true})
end

MoneyManager.get_weapon_part_sell_value = function(l_37_0, l_37_1, l_37_2)
  local part = tweak_data.weapon.factory.parts[l_37_1]
  local mod_price = 1000
  if part then
    local pc_value = l_37_0:_get_pc_entry(part)
    if pc_value then
      local star_value = math.ceil(pc_value / 10)
      mod_price = tweak_data:get_value("money_manager", "modify_weapon_cost", star_value)
    end
    local stats_value = part.stats
    stats_value = stats_value and stats_value.value or 1
    mod_price = mod_price * tweak_data.weapon.stats.value[math.clamp(stats_value, 1, #tweak_data.weapon.stats.value)]
  end
  return math.round(mod_price * tweak_data:get_value("money_manager", "sell_weapon_multiplier") * managers.player:upgrade_value("player", "sell_cost_multiplier", 1))
end

MoneyManager.on_sell_weapon_part = function(l_38_0, l_38_1)
  local amount = l_38_0:get_weapon_part_sell_value(l_38_1)
  Application:debug("value of removed weapon part", amount)
  l_38_0:_add_to_total(amount, {no_offshore = true})
end

MoneyManager.on_sell_weapon_slot = function(l_39_0, l_39_1, l_39_2)
  local amount = l_39_0:get_weapon_slot_sell_value(l_39_1, l_39_2)
  l_39_0._add_to_total(amount, {no_offshore = true})
end

MoneyManager.can_afford_mission_asset = function(l_40_0, l_40_1)
  return l_40_0:get_mission_asset_cost_by_id(l_40_1) <= l_40_0:total()
end

MoneyManager.on_buy_mission_asset = function(l_41_0, l_41_1)
  local amount = l_41_0:get_mission_asset_cost_by_id(l_41_1)
  l_41_0:_deduct_from_total(amount)
  return amount
end

MoneyManager.can_afford_spend_skillpoint = function(l_42_0, l_42_1, l_42_2, l_42_3)
  return l_42_0:get_skillpoint_cost(l_42_1, l_42_2, l_42_3) <= l_42_0:total()
end

MoneyManager.can_afford_respec_skilltree = function(l_43_0, l_43_1)
  return true
end

MoneyManager.on_skillpoint_spent = function(l_44_0, l_44_1, l_44_2, l_44_3)
  local amount = l_44_0:get_skillpoint_cost(l_44_1, l_44_2, l_44_3)
  l_44_0:_deduct_from_total(amount)
end

MoneyManager.on_respec_skilltree = function(l_45_0, l_45_1, l_45_2)
  local amount = l_45_0:get_skilltree_tree_respec_cost(l_45_1, l_45_2)
  l_45_0:_add_to_total(amount, {no_offshore = true})
end

MoneyManager.refund_weapon_part = function(l_46_0, l_46_1, l_46_2, l_46_3)
  local pc_value = tweak_data.blackmarket.weapon_mods[l_46_2].value or 1
  local mod_price = tweak_data:get_value("money_manager", "modify_weapon_cost", pc_value)
  local global_value_multiplier = tweak_data:get_value("money_manager", "global_value_multipliers", l_46_3 or "normal")
  l_46_0:_add_to_total(math.round(mod_price * global_value_multiplier), {no_offshore = true})
end

MoneyManager.get_weapon_modify_price = function(l_47_0, l_47_1, l_47_2, l_47_3)
  local star_value = nil
  local pc_value = tweak_data.blackmarket.weapon_mods[l_47_2].value or 1
  local mod_price = tweak_data:get_value("money_manager", "modify_weapon_cost", pc_value)
  local global_value_multiplier = tweak_data:get_value("money_manager", "global_value_multipliers", l_47_3 or "normal")
  local crafting_multiplier = managers.player:upgrade_value("player", "passive_crafting_weapon_multiplier", 1)
  crafting_multiplier = crafting_multiplier * managers.player:upgrade_value("player", "crafting_weapon_multiplier", 1)
  crafting_multiplier = crafting_multiplier * managers.player:upgrade_value("player", "buy_cost_multiplier", 1)
  crafting_multiplier = crafting_multiplier * managers.player:upgrade_value("player", "crime_net_deal", 1)
  local total_price = mod_price * (crafting_multiplier) * global_value_multiplier
  return math.round(total_price)
end

MoneyManager.can_afford_weapon_modification = function(l_48_0, l_48_1, l_48_2, l_48_3)
  return l_48_0:get_weapon_modify_price(l_48_1, l_48_2, l_48_3) <= l_48_0:total()
end

MoneyManager.on_buy_weapon_modification = function(l_49_0, l_49_1, l_49_2, l_49_3)
  local amount = l_49_0:get_weapon_modify_price(l_49_1, l_49_2, l_49_3)
  l_49_0:_deduct_from_total(amount)
end

MoneyManager._get_pc_entry = function(l_50_0, l_50_1)
  if not l_50_1 then
    Application:error("MoneyManager:_get_pc_entry. No entry")
    return 5
  end
  local pcs = l_50_1.pcs
  local pc_value = nil
  if not pcs then
    local pc = l_50_1.pc
    if not pc then
      do return end
    end
    pc_value = pc
  else
    pc_value = pcs[1]
    for _,pcv in ipairs(pcs) do
      pc_value = math.min(pc_value, pcv)
    end
  end
  return pc_value
end

MoneyManager.get_mask_part_price_modified = function(l_51_0, l_51_1, l_51_2, l_51_3)
  local mask_part_price = l_51_0:get_mask_part_price(l_51_1, l_51_2, l_51_3)
  local crafting_multiplier = managers.player:upgrade_value("player", "passive_crafting_mask_multiplier", 1)
  crafting_multiplier = crafting_multiplier * managers.player:upgrade_value("player", "crafting_mask_multiplier", 1)
  crafting_multiplier = crafting_multiplier * managers.player:upgrade_value("player", "buy_cost_multiplier", 1)
  crafting_multiplier = crafting_multiplier * managers.player:upgrade_value("player", "crime_net_deal", 1)
  local total_price = mask_part_price * (crafting_multiplier)
  return math.round(total_price)
end

MoneyManager.get_mask_crafting_price_modified = function(l_52_0, l_52_1, l_52_2, l_52_3)
  local mask_price = l_52_0:get_mask_crafting_price(l_52_1, l_52_2, l_52_3)
  local crafting_multiplier = managers.player:upgrade_value("player", "passive_crafting_mask_multiplier", 1)
  crafting_multiplier = crafting_multiplier * managers.player:upgrade_value("player", "crafting_mask_multiplier", 1)
  crafting_multiplier = crafting_multiplier * managers.player:upgrade_value("player", "buy_cost_multiplier", 1)
  crafting_multiplier = crafting_multiplier * managers.player:upgrade_value("player", "crime_net_deal", 1)
  local total_price = mask_price * (crafting_multiplier)
  return math.round(total_price)
end

MoneyManager.get_mask_part_price = function(l_53_0, l_53_1, l_53_2, l_53_3)
  local part_pc = l_53_0:_get_pc_entry(tweak_data.blackmarket[l_53_1][l_53_2]) or 0
  if part_pc ~= 0 or not part_pc then
    local star_value = math.ceil(part_pc / 10)
  end
  local part_name_converter = {textures = "pattern", materials = "material", colors = "color"}
  local gv_multiplier = tweak_data:get_value("money_manager", "global_value_multipliers", l_53_3)
  local value = tweak_data.blackmarket[l_53_1][l_53_2].value or 1
  local pv = tweak_data:get_value("money_manager", "masks", part_name_converter[l_53_1] .. "_value", value) or 0
  return math.round(pv * gv_multiplier)
end

MoneyManager.get_mask_crafting_price = function(l_54_0, l_54_1, l_54_2, l_54_3)
  local bonus_global_values = {normal = 0, superior = 0, exceptional = 0, infamous = 0}
  local pc_value = tweak_data.blackmarket.masks[l_54_1].value or 1
  local star_value = pc_value and math.ceil(pc_value) or 1
  local base_value = tweak_data:get_value("money_manager", "masks", "mask_value", star_value) * tweak_data:get_value("money_manager", "global_value_multipliers", l_54_2)
  local parts_value = 0
  local part_name_converter = {pattern = "textures", material = "materials", color = "colors"}
  bonus_global_values[l_54_2] = (bonus_global_values[l_54_2] or 0) + 1
  if not l_54_3 then
    l_54_3 = managers.blackmarket:get_default_mask_blueprint()
  end
  for id,data in pairs(l_54_3) do
    local part_pc = l_54_0:_get_pc_entry(tweak_data.blackmarket[part_name_converter[id]][data.id]) or 0
    star_value = tweak_data.blackmarket[part_name_converter[id]][data.id].value or 1
    local gv_multiplier = tweak_data:get_value("money_manager", "global_value_multipliers", data.global_value)
    bonus_global_values[data.global_value] = (bonus_global_values[data.global_value] or 0) + 1
    local pv = tweak_data:get_value("money_manager", "masks", id .. "_value", star_value) or 0
    parts_value = parts_value + pv * gv_multiplier
  end
  return math.round(base_value + (parts_value)), bonus_global_values
end

MoneyManager.get_mask_sell_value = function(l_55_0, l_55_1, l_55_2, l_55_3)
  local sell_value, bonuses = l_55_0:get_mask_crafting_price(l_55_1, l_55_2, l_55_3)
  local bonus_multiplier = nil
  for gv,amount in pairs(bonuses) do
    bonus_multiplier = tweak_data:get_value("money_manager", "global_value_bonus_multiplier", gv) * math.max(amount - 1, 0)
    sell_value = sell_value + sell_value * (bonus_multiplier)
  end
  return math.round((sell_value) * tweak_data:get_value("money_manager", "sell_mask_multiplier") * managers.player:upgrade_value("player", "sell_cost_multiplier", 1))
end

MoneyManager.get_mask_slot_sell_value = function(l_56_0, l_56_1)
  local mask = managers.blackmarket:get_crafted_category_slot("masks", l_56_1)
  if not mask then
    return 0
  end
  return math.round(l_56_0:get_mask_sell_value(mask.mask_id, mask.global_value, mask.blueprint))
end

MoneyManager.can_afford_mask_crafting = function(l_57_0, l_57_1, l_57_2, l_57_3)
  return l_57_0:get_mask_crafting_price_modified(l_57_1, l_57_2, l_57_3) <= l_57_0:total()
end

MoneyManager.on_buy_mask = function(l_58_0, l_58_1, l_58_2, l_58_3)
  local amount = l_58_0:get_mask_crafting_price_modified(l_58_1, l_58_2, l_58_3)
  l_58_0:_deduct_from_total(amount)
end

MoneyManager.on_sell_mask = function(l_59_0, l_59_1, l_59_2, l_59_3)
  local amount = l_59_0:get_mask_sell_value(l_59_1, l_59_2, l_59_3)
  l_59_0:_add_to_total(amount, {no_offshore = true})
end

MoneyManager.on_loot_drop_cash = function(l_60_0, l_60_1)
  local amount = tweak_data:get_value("money_manager", "loot_drop_cash", l_60_1) or 100
  l_60_0:_add_to_total(amount, {no_offshore = true})
end

MoneyManager.get_skillpoint_cost = function(l_61_0, l_61_1, l_61_2, l_61_3)
  local respec_tweak_data = tweak_data.money_manager.skilltree.respec
  local exp_cost = 0
  if l_61_2 or not 0 then
    local tier_cost = tweak_data:get_value("money_manager", "skilltree", "respec", "point_tier_cost", l_61_2) * l_61_3
  end
  local cost = tweak_data:get_value("money_manager", "skilltree", "respec", "base_point_cost") + tier_cost
  return math.round(cost)
end

MoneyManager.get_skilltree_tree_respec_cost = function(l_62_0, l_62_1, l_62_2)
  local base_point_cost = tweak_data:get_value("money_manager", "skilltree", "respec", "base_point_cost")
  local value = base_point_cost
  for id,tier in ipairs(tweak_data.skilltree.trees[l_62_1].tiers) do
    for _,skill_id in ipairs(tier) do
      local step = managers.skilltree:skill_step(skill_id)
      if step > 0 then
        local skill_tweak_data = tweak_data.skilltree.skills[skill_id]
        for i = 1, step do
          value = value + base_point_cost + Application:digest_value(skill_tweak_data[i].cost, false) * tweak_data:get_value("money_manager", "skilltree", "respec", "point_tier_cost", id)
        end
      end
    end
  end
  if not l_62_2 then
    return math.round((value) * tweak_data:get_value("money_manager", "skilltree", "respec", "respec_refund_multiplier"))
  end
end

MoneyManager.get_mission_asset_cost = function(l_63_0)
  local stars = managers.job:has_active_job() and managers.job:current_job_and_difficulty_stars() or 1
  return math.round(tweak_data:get_value("money_manager", "mission_asset_cost", stars) * managers.player:upgrade_value("player", "assets_cost_multiplier", 1) * managers.player:upgrade_value("player", "passive_assets_cost_multiplier", 1) * managers.player:upgrade_value("player", "buy_cost_multiplier", 1) * managers.player:upgrade_value("player", "crime_net_deal", 1))
end

MoneyManager.get_mission_asset_cost_by_stars = function(l_64_0, l_64_1)
  return math.round(tweak_data:get_value("money_manager", "mission_asset_cost", l_64_1) * managers.player:upgrade_value("player", "assets_cost_multiplier", 1) * managers.player:upgrade_value("player", "passive_assets_cost_multiplier", 1) * managers.player:upgrade_value("player", "buy_cost_multiplier", 1) * managers.player:upgrade_value("player", "crime_net_deal", 1))
end

MoneyManager.get_mission_asset_cost_by_id = function(l_65_0, l_65_1)
  local asset_tweak_data = managers.assets:get_asset_tweak_data_by_id(l_65_1)
  local value = asset_tweak_data and asset_tweak_data.money_lock or 0
  local has_active_job = managers.job:has_active_job()
  local job_and_difficulty_stars = has_active_job and managers.job:current_job_and_difficulty_stars() or 1
  local job_stars = has_active_job and managers.job:current_job_stars() or 1
  local difficulty_stars = job_and_difficulty_stars - job_stars
  local pc_multiplier = tweak_data:get_value("money_manager", "mission_asset_cost_multiplier_by_pc", job_stars) or 0
  local risk_multiplier = difficulty_stars > 0 and tweak_data:get_value("money_manager", "mission_asset_cost_multiplier_by_risk", difficulty_stars) or 0
  value = value + value * pc_multiplier + value * risk_multiplier
  return math.round((value) * managers.player:upgrade_value("player", "assets_cost_multiplier", 1) * managers.player:upgrade_value("player", "passive_assets_cost_multiplier", 1) * managers.player:upgrade_value("player", "buy_cost_multiplier", 1) * managers.player:upgrade_value("player", "crime_net_deal", 1))
end

MoneyManager.total = function(l_66_0)
  return Application:digest_value(l_66_0._global.total, false)
end

MoneyManager._set_total = function(l_67_0, l_67_1)
  l_67_0._global.total = Application:digest_value(l_67_1, true)
end

MoneyManager.total_collected = function(l_68_0)
  return Application:digest_value(l_68_0._global.total_collected, false)
end

MoneyManager._set_total_collected = function(l_69_0, l_69_1)
  l_69_0._global.total_collected = Application:digest_value(l_69_1, true)
end

MoneyManager.offshore = function(l_70_0)
  return Application:digest_value(l_70_0._global.offshore, false)
end

MoneyManager._set_offshore = function(l_71_0, l_71_1)
  l_71_0._global.offshore = Application:digest_value(l_71_1, true)
end

MoneyManager.total_spent = function(l_72_0)
  return Application:digest_value(l_72_0._global.total_spent, false)
end

MoneyManager._set_total_spent = function(l_73_0, l_73_1)
  l_73_0._global.total_spent = Application:digest_value(l_73_1, true)
end

MoneyManager.add_to_total = function(l_74_0, l_74_1)
  l_74_1 = math.round(l_74_1)
  print("MoneyManager:add_to_total", l_74_1)
  l_74_0:_add_to_total(l_74_1)
end

MoneyManager._add_to_total = function(l_75_0, l_75_1, l_75_2)
  if l_75_2 then
    local no_offshore = l_75_2.no_offshore
  end
  if not no_offshore or not 0 then
    local offshore = math.round(l_75_1 * (1 - tweak_data:get_value("money_manager", "offshore_rate")))
  end
  if not no_offshore or not l_75_1 then
    local spending_cash = math.round(l_75_1 * tweak_data:get_value("money_manager", "offshore_rate"))
  end
  local rounding_error = math.round(l_75_1 - (offshore + spending_cash))
  spending_cash = spending_cash + rounding_error
  l_75_0:_set_total(l_75_0:total() + (spending_cash))
  l_75_0:_set_total_collected(l_75_0:total_collected() + math.round(l_75_1))
  l_75_0:_set_offshore(l_75_0:offshore() + offshore)
  l_75_0:_on_total_changed(l_75_1, spending_cash, offshore)
end

MoneyManager.deduct_from_total = function(l_76_0, l_76_1)
  l_76_1 = math.round(l_76_1)
  print("MoneyManager:deduct_from_total", l_76_1)
  l_76_0:_deduct_from_total(l_76_1)
end

MoneyManager._deduct_from_total = function(l_77_0, l_77_1)
  l_77_1 = math.min(l_77_1, l_77_0:total())
  l_77_0:_set_total(math.max(0, l_77_0:total() - l_77_1))
  l_77_0:_set_total_spent(l_77_0:total_spent() + l_77_1)
  l_77_0:_on_total_changed(-l_77_1, -l_77_1, 0)
end

MoneyManager._on_total_changed = function(l_78_0, l_78_1, l_78_2, l_78_3)
  l_78_0._heist_total = l_78_0._heist_total + l_78_1
  l_78_0._heist_offshore = l_78_0._heist_offshore + l_78_3
  if l_78_3 and l_78_3 > 0 then
    l_78_0._heist_spending = l_78_0._heist_spending + l_78_2
  end
  if tweak_data.achievement.going_places <= l_78_0:total() then
    managers.achievment:award("going_places")
  end
  if tweak_data.achievement.spend_money_to_make_money <= l_78_0:total_spent() then
    managers.achievment:award("spend_money_to_make_money")
  end
end

MoneyManager.heist_total = function(l_79_0)
  return l_79_0._heist_total or 0
end

MoneyManager.heist_spending = function(l_80_0)
  return l_80_0._heist_spending or 0
end

MoneyManager.heist_offshore = function(l_81_0)
  return l_81_0._heist_offshore or 0
end

MoneyManager.get_payouts = function(l_82_0)
  return l_82_0._stage_payout, l_82_0._job_payout, l_82_0._bag_payout, l_82_0._small_loot_payout, l_82_0._crew_payout
end

MoneyManager._set_stage_payout = function(l_83_0, l_83_1)
  l_83_0._stage_payout = l_83_1
end

MoneyManager._set_job_payout = function(l_84_0, l_84_1)
  l_84_0._job_payout = l_84_1
end

MoneyManager._set_bag_payout = function(l_85_0, l_85_1)
  l_85_0._bag_payout = l_85_1
end

MoneyManager._set_small_loot_payout = function(l_86_0, l_86_1)
  l_86_0._small_loot_payout = l_86_1
end

MoneyManager._set_crew_payout = function(l_87_0, l_87_1)
  l_87_0._crew_payout = l_87_1
end

MoneyManager._add = function(l_88_0, l_88_1)
  l_88_1 = l_88_0:_check_multipliers(l_88_1)
  l_88_0._heist_total = l_88_0._heist_total + l_88_1
  l_88_0:_present(l_88_1)
end

MoneyManager._check_multipliers = function(l_89_0, l_89_1)
  for _,multiplier in pairs(l_89_0._active_multipliers) do
    l_89_1 = l_89_1 * multiplier
  end
  return math.round(l_89_1)
end

MoneyManager._present = function(l_90_0, l_90_1)
  local s_amount = tostring(l_90_1)
  local reverse = string.reverse(s_amount)
  local present = ""
  for i = 1, string.len(reverse) do
    present = present .. string.sub(reverse, i, i) .. (math.mod(i, 3) == 0 and i ~= string.len(reverse) and "," or "")
  end
  local event = "money_collect_small"
  if l_90_1 > 999 then
    event = "money_collect_large"
  elseif l_90_1 > 101 then
    event = "money_collect_medium"
  end
end

MoneyManager.actions = function(l_91_0)
  local t = {}
  for action,_ in pairs(tweak_data.money_manager.actions) do
    table.insert(t, action)
  end
  table.sort(t)
  return t
end

MoneyManager.multipliers = function(l_92_0)
  local t = {}
  for multiplier,_ in pairs(tweak_data.money_manager.multipliers) do
    table.insert(t, multiplier)
  end
  table.sort(t)
  return t
end

MoneyManager.reset = function(l_93_0)
  Global.money_manager = nil
  l_93_0:_setup()
end

MoneyManager.save = function(l_94_0, l_94_1)
  local state = {total = l_94_0._global.total, total_collected = l_94_0._global.total_collected, offshore = l_94_0._global.offshore, total_spent = l_94_0._global.total_spent}
  l_94_1.MoneyManager = state
end

MoneyManager.load = function(l_95_0, l_95_1)
  local state = l_95_1.MoneyManager
  l_95_0._global.total = state.total
  if not state.total_collected then
    l_95_0._global.total_collected = Application:digest_value(0, true)
  end
  if not state.offshore then
    l_95_0._global.offshore = Application:digest_value(0, true)
  end
  if not state.total_spent then
    l_95_0._global.total_spent = Application:digest_value(0, true)
  end
end


