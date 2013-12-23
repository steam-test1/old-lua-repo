-- Decompiled using luadec 2.0.1 by sztupy (http://winmo.sztupy.hu)
-- Command line was: F:\SteamLibrary\SteamApps\common\PAYDAY 2\lua\lib\tweak_data\moneytweakdata.luac 

if not MoneyTweakData then
  MoneyTweakData = class()
end
MoneyTweakData._create_value_table = function(l_1_0, l_1_1, l_1_2, l_1_3, l_1_4)
  local t = {}
  for i = 1, l_1_2 do
    local v = math.lerp(l_1_0, l_1_1, math.pow((i - 1) / (l_1_2 - 1), l_1_4 and l_1_4 or 1))
    if v > 999 then
      v = v * 0.0010000000474975
      if not l_1_3 or not math.ceil(v) then
        v = v * 1000
    else
      end
      if v > 99 then
        v = v * 0.0099999997764826
        if not l_1_3 or not math.ceil(v) then
          v = v * 100
      else
        end
        if v > 9 then
          v = v * 0.10000000149012
          if not l_1_3 or not math.ceil(v) then
            v = v * 10
        else
          end
        if not l_1_3 or not math.ceil(v) then
          end
        end
      end
    end
    table.insert(t, v)
  end
  return t
end

MoneyTweakData._test_curves = function(l_2_0, l_2_1, l_2_2, l_2_3, l_2_4)
  local v = nil
  local loot_bags = tweak_data:get_value("money_manager", "bag_value_multiplier", l_2_0) * tweak_data:get_value("money_manager", "bag_values", "default")
  local diff_multiplier = 0
  if l_2_3 > 0 then
    diff_multiplier = tweak_data:get_value("money_manager", "difficulty_multiplier", l_2_3)
  end
  v = tweak_data:get_value("money_manager", "stage_completion", l_2_0) + tweak_data:get_value("money_manager", "job_completion", l_2_0) + loot_bags * l_2_1 + tweak_data:get_value("money_manager", "flat_stage_completion") + tweak_data:get_value("money_manager", "flat_job_completion")
  v = (v) * l_2_4
  v = v + v * diff_multiplier
  v = (v) * tweak_data:get_value("money_manager", "alive_humans_multiplier", l_2_2)
  print(v, v * tweak_data:get_value("money_manager", "offshore_rate"))
end

MoneyTweakData.init = function(l_3_0)
  l_3_0.biggest_score = 5040000
  l_3_0.biggest_cashout = 250000
  l_3_0.offshore_rate = l_3_0.biggest_cashout / l_3_0.biggest_score
  l_3_0.alive_players_max = 1.2999999523163
  l_3_0.cashout_without_player_alive = l_3_0.biggest_cashout / l_3_0.alive_players_max
  l_3_0.cut_difficulty = 8
  l_3_0.max_mission_bags = 6
  l_3_0.cut_lootbag_bonus = l_3_0.cashout_without_player_alive * 0.30000001192093
  l_3_0.cut_lootbag_bonus = l_3_0.cut_lootbag_bonus / l_3_0.max_mission_bags / l_3_0.cut_difficulty
  l_3_0.max_days = 3
  l_3_0.cut_stage_complete = l_3_0.cashout_without_player_alive * 0.55000001192093
  l_3_0.cut_stage_complete = l_3_0.cut_stage_complete / l_3_0.cut_difficulty * 0.69999998807907
  l_3_0.cut_job_complete = l_3_0.cashout_without_player_alive * 0.15000000596046
  l_3_0.cut_job_complete = l_3_0.cut_job_complete / l_3_0.cut_difficulty
  l_3_0.bag_values = {}
  l_3_0.bag_values.default = 150
  l_3_0.bag_values.money = 450
  l_3_0.bag_values.gold = 600
  l_3_0.bag_values.diamonds = 125
  l_3_0.bag_values.coke = 500
  l_3_0.bag_values.meth = 600
  l_3_0.bag_values.weapons = 700
  l_3_0.bag_value_multiplier = l_3_0._create_value_table(l_3_0.cut_lootbag_bonus / 5 / l_3_0.offshore_rate / l_3_0.bag_values.default, l_3_0.cut_lootbag_bonus / l_3_0.offshore_rate / l_3_0.bag_values.default, 7, true, 0.85000002384186)
  l_3_0.stage_completion = l_3_0._create_value_table(l_3_0.cut_stage_complete / 7 / l_3_0.offshore_rate, l_3_0.cut_stage_complete / l_3_0.offshore_rate, 7, true, 1)
  l_3_0.job_completion = l_3_0._create_value_table(l_3_0.cut_job_complete / 7 / l_3_0.offshore_rate, l_3_0.cut_job_complete / l_3_0.offshore_rate, 7, true, 1)
  l_3_0.flat_stage_completion = math.round(2500 / l_3_0.offshore_rate)
  l_3_0.flat_job_completion = 0
  l_3_0.level_limit = {}
  l_3_0.level_limit.low_cap_level = -1
  l_3_0.level_limit.low_cap_multiplier = 0.75
  l_3_0.level_limit.pc_difference_multipliers = {1, 0.89999997615814, 0.80000001192093, 0.69999998807907, 0.60000002384186, 0.5, 0.40000000596046, 0.30000001192093, 0.20000000298023, 0.10000000149012}
  l_3_0.stage_failed_multiplier = 0.10000000149012
  l_3_0.difficulty_multiplier = l_3_0._create_value_table(2.5, l_3_0.cut_difficulty, 3, false, 1)
  l_3_0.small_loot_difficulty_multiplier = l_3_0._create_value_table(0, 0, 3, false, 1)
  l_3_0.alive_humans_multiplier = l_3_0._create_value_table(1, l_3_0.alive_players_max, 4, false, 1)
  l_3_0.sell_weapon_multiplier = 0.25
  l_3_0.sell_mask_multiplier = 0.25
  l_3_0.killing_civilian_deduction = l_3_0._create_value_table(2000, 20000, 10, true, 2)
  l_3_0.global_value_multipliers = {}
  l_3_0.global_value_multipliers.normal = 1
  l_3_0.global_value_multipliers.superior = 1
  l_3_0.global_value_multipliers.exceptional = 1
  l_3_0.global_value_multipliers.infamous = 5
  l_3_0.global_value_multipliers.preorder = 1
  l_3_0.global_value_multipliers.overkill = 0.0099999997764826
  l_3_0.global_value_bonus_multiplier = {}
  l_3_0.global_value_bonus_multiplier.normal = 0
  l_3_0.global_value_bonus_multiplier.superior = 0.10000000149012
  l_3_0.global_value_bonus_multiplier.exceptional = 0.20000000298023
  l_3_0.global_value_bonus_multiplier.infamous = 1
  l_3_0.global_value_bonus_multiplier.preorder = 0
  l_3_0.global_value_bonus_multiplier.overkill = 20
  local smallest_cashout = (l_3_0.stage_completion[1] + l_3_0.job_completion[1]) * l_3_0.offshore_rate
  local biggest_mask_cost = l_3_0.biggest_cashout * 100
  local biggest_mask_cost_deinfamous = math.round(biggest_mask_cost / l_3_0.global_value_multipliers.infamous)
  local biggest_mask_part_cost = math.round(smallest_cashout * 46)
  local smallest_mask_part_cost = math.round(smallest_cashout * 3.9000000953674)
  local biggest_weapon_cost = math.round(l_3_0.biggest_cashout * 2.5)
  local smallest_weapon_cost = math.round(smallest_cashout * 6)
  local biggest_weapon_mod_cost = math.round(l_3_0.biggest_cashout * 1.2999999523163)
  local smallest_weapon_mod_cost = math.round(smallest_cashout * 7)
  l_3_0.weapon_cost = l_3_0._create_value_table(smallest_weapon_cost, biggest_weapon_cost, 40, true, 1.1000000238419)
  l_3_0.modify_weapon_cost = l_3_0._create_value_table(smallest_weapon_mod_cost, biggest_weapon_mod_cost, 10, true, 1.2000000476837)
  l_3_0.remove_weapon_mod_cost_multiplier = l_3_0._create_value_table(1, 1, 10, true, 1)
  l_3_0.masks = {}
  l_3_0.masks.mask_value = l_3_0._create_value_table(smallest_mask_part_cost, smallest_mask_part_cost * 3, 10, true, 2)
  l_3_0.masks.material_value = l_3_0._create_value_table(smallest_mask_part_cost * 0.89999997615814, biggest_mask_part_cost, 10, true, 1.2000000476837)
  l_3_0.masks.pattern_value = l_3_0._create_value_table(smallest_mask_part_cost * 0.80000001192093, biggest_mask_part_cost, 10, true, 1.1000000238419)
  l_3_0.masks.color_value = l_3_0._create_value_table(smallest_mask_part_cost * 0.69999998807907, biggest_mask_part_cost, 10, true, 1)
  l_3_0.mission_asset_cost_by_pc = l_3_0._create_value_table(1, 1, 10, true, 1)
  l_3_0.mission_asset_cost_multiplier_by_pc = {0, 0, 0, 0, 0, 0, 1}
  l_3_0.mission_asset_cost_multiplier_by_risk = {0.5, 1, 2}
  l_3_0.mission_asset_cost_small = l_3_0._create_value_table(2500, 15000, 10, true, 1)
  l_3_0.mission_asset_cost_medium = l_3_0._create_value_table(10000, 45000, 10, true, 1)
  l_3_0.mission_asset_cost_large = l_3_0._create_value_table(55000, 400000, 10, true, 1)
  l_3_0.small_loot_value_multiplier = {100, 100, 100, 100, 100, 100, 100, 100, 100, 100}
  l_3_0.small_loot = {}
  l_3_0.small_loot.money_bundle = 10
  l_3_0.small_loot.diamondheist_vault_bust = 12
  l_3_0.small_loot.diamondheist_vault_diamond = 15
  l_3_0.small_loot.diamondheist_big_diamond = 15
  l_3_0.small_loot.value_gold = 30
  l_3_0.small_loot.gen_atm = 220
  l_3_0.small_loot.special_deposit_box = 35
  l_3_0.small_loot.vault_loot_gold = 100
  l_3_0.small_loot.vault_loot_cash = 50
  l_3_0.small_loot.vault_loot_coins = 35
  l_3_0.small_loot.vault_loot_ring = 15
  l_3_0.small_loot.vault_loot_jewels = 25
  l_3_0.small_loot.vault_loot_macka = 0.0099999997764826
  l_3_0.skilltree = {}
  l_3_0.skilltree.respec = {}
  l_3_0.skilltree.respec.base_cost = 200
  l_3_0.skilltree.respec.profile_cost_increaser_multiplier = {1, 1, 1, 1, 1, 1, 1, 1, 1, 1}
  l_3_0.skilltree.respec.tier_cost = {}
  l_3_0.skilltree.respec.tier_cost[1] = 1500
  l_3_0.skilltree.respec.tier_cost[2] = 2000
  l_3_0.skilltree.respec.tier_cost[3] = 10000
  l_3_0.skilltree.respec.tier_cost[4] = 40000
  l_3_0.skilltree.respec.tier_cost[5] = 100000
  l_3_0.skilltree.respec.tier_cost[6] = 400000
  l_3_0.skilltree.respec.base_point_cost = 500
  l_3_0.skilltree.respec.point_tier_cost = l_3_0._create_value_table(4000, l_3_0.biggest_cashout * 0.44999998807907, 6, true, 1.1000000238419)
  l_3_0.skilltree.respec.respec_refund_multiplier = 0.5
  l_3_0.skilltree.respec.point_cost = 0
  l_3_0.skilltree.respec.point_multiplier_cost = 1
  local loot_drop_value = 1500
  l_3_0.loot_drop_cash = {}
  l_3_0.loot_drop_cash.cash10 = loot_drop_value * 2
  l_3_0.loot_drop_cash.cash20 = loot_drop_value * 4
  l_3_0.loot_drop_cash.cash30 = loot_drop_value * 6
  l_3_0.loot_drop_cash.cash40 = loot_drop_value * 8
  l_3_0.loot_drop_cash.cash50 = loot_drop_value * 9
  l_3_0.loot_drop_cash.cash60 = loot_drop_value * 10
  l_3_0.loot_drop_cash.cash70 = loot_drop_value * 11
  l_3_0.loot_drop_cash.cash80 = loot_drop_value * 12
  l_3_0.loot_drop_cash.cash90 = loot_drop_value * 13
  l_3_0.loot_drop_cash.cash100 = loot_drop_value * 14
  l_3_0.loot_drop_cash.cash_preorder = l_3_0.biggest_cashout / 10
end


