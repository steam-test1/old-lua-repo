-- Decompiled using luadec 2.0.1 by sztupy (http://winmo.sztupy.hu)
-- Command line was: F:\SteamLibrary\SteamApps\common\PAYDAY 2\lua\lib\tweak_data\carrytweakdata.luac 

if not CarryTweakData then
  CarryTweakData = class()
end
CarryTweakData.init = function(l_1_0, l_1_1)
  l_1_0.value_multiplier = l_1_1.money_manager.bag_value_multiplier
  l_1_0.small_loot_value_multiplier = l_1_1.money_manager.small_loot_value_multiplier
  l_1_0.dye = {}
  l_1_0.dye.chance = 0.5
  l_1_0.dye.value_multiplier = 60
  l_1_0.types = {}
  l_1_0.types.being = {}
  l_1_0.types.being.move_speed_modifier = 0.5
  l_1_0.types.being.jump_modifier = 0.5
  l_1_0.types.being.can_run = false
  l_1_0.types.being.throw_distance_multiplier = 0.5
  l_1_0.types.mega_heavy = {}
  l_1_0.types.mega_heavy.move_speed_modifier = 0.25
  l_1_0.types.mega_heavy.jump_modifier = 0.25
  l_1_0.types.mega_heavy.can_run = false
  l_1_0.types.mega_heavy.throw_distance_multiplier = 0.125
  l_1_0.types.heavy = {}
  l_1_0.types.heavy.move_speed_modifier = 0.5
  l_1_0.types.heavy.jump_modifier = 0.5
  l_1_0.types.heavy.can_run = false
  l_1_0.types.heavy.throw_distance_multiplier = 0.5
  l_1_0.types.medium = {}
  l_1_0.types.medium.move_speed_modifier = 0.75
  l_1_0.types.medium.jump_modifier = 1
  l_1_0.types.medium.can_run = false
  l_1_0.types.medium.throw_distance_multiplier = 1
  l_1_0.types.light = {}
  l_1_0.types.light.move_speed_modifier = 1
  l_1_0.types.light.jump_modifier = 1
  l_1_0.types.light.can_run = true
  l_1_0.types.light.throw_distance_multiplier = 1
  l_1_0.types.coke_light = {}
  l_1_0.types.coke_light.move_speed_modifier = l_1_0.types.light.move_speed_modifier
  l_1_0.types.coke_light.jump_modifier = l_1_0.types.light.jump_modifier
  l_1_0.types.coke_light.can_run = l_1_0.types.light.can_run
  l_1_0.types.coke_light.throw_distance_multiplier = l_1_0.types.light.throw_distance_multiplier
  l_1_0.small_loot = {}
  l_1_0.small_loot.money_bundle = l_1_1:get_value("money_manager", "small_loot", "money_bundle")
  l_1_0.small_loot.diamondheist_vault_bust = l_1_1:get_value("money_manager", "small_loot", "diamondheist_vault_bust")
  l_1_0.small_loot.diamondheist_vault_diamond = l_1_1:get_value("money_manager", "small_loot", "diamondheist_vault_diamond")
  l_1_0.small_loot.diamondheist_big_diamond = l_1_1:get_value("money_manager", "small_loot", "diamondheist_big_diamond")
  l_1_0.small_loot.value_gold = l_1_1:get_value("money_manager", "small_loot", "value_gold")
  l_1_0.small_loot.gen_atm = l_1_1:get_value("money_manager", "small_loot", "gen_atm")
  l_1_0.small_loot.special_deposit_box = l_1_1:get_value("money_manager", "small_loot", "special_deposit_box")
  l_1_0.small_loot.vault_loot_gold = l_1_1:get_value("money_manager", "small_loot", "vault_loot_gold")
  l_1_0.small_loot.vault_loot_cash = l_1_1:get_value("money_manager", "small_loot", "vault_loot_cash")
  l_1_0.small_loot.vault_loot_coins = l_1_1:get_value("money_manager", "small_loot", "vault_loot_coins")
  l_1_0.small_loot.vault_loot_ring = l_1_1:get_value("money_manager", "small_loot", "vault_loot_ring")
  l_1_0.small_loot.vault_loot_jewels = l_1_1:get_value("money_manager", "small_loot", "vault_loot_jewels")
  l_1_0.small_loot.vault_loot_macka = l_1_1:get_value("money_manager", "small_loot", "vault_loot_macka")
  l_1_0.gold = {}
  l_1_0.gold.type = "heavy"
  l_1_0.gold.name_id = "hud_carry_gold"
  l_1_0.gold.bag_value = "gold"
  l_1_0.gold.AI_carry = {SO_category = "enemies"}
  l_1_0.money = {}
  l_1_0.money.type = "medium"
  l_1_0.money.name_id = "hud_carry_money"
  l_1_0.money.bag_value = "money"
  l_1_0.money.dye = true
  l_1_0.money.AI_carry = {SO_category = "enemies"}
  l_1_0.diamonds = {}
  l_1_0.diamonds.type = "light"
  l_1_0.diamonds.name_id = "hud_carry_diamonds"
  l_1_0.diamonds.bag_value = "diamonds"
  l_1_0.diamonds.AI_carry = {SO_category = "enemies"}
  l_1_0.painting = {}
  l_1_0.painting.type = "light"
  l_1_0.painting.name_id = "hud_carry_painting"
  l_1_0.painting.visual_object = "g_canvas_bag"
  l_1_0.painting.unit = "units/payday2/pickups/gen_pku_canvasbag/gen_pku_canvasbag"
  l_1_0.painting.AI_carry = {SO_category = "enemies"}
  l_1_0.coke = {}
  l_1_0.coke.type = "coke_light"
  l_1_0.coke.name_id = "hud_carry_coke"
  l_1_0.coke.bag_value = "coke"
  l_1_0.coke.AI_carry = {SO_category = "enemies"}
  l_1_0.meth = {}
  l_1_0.meth.type = "coke_light"
  l_1_0.meth.name_id = "hud_carry_meth"
  l_1_0.meth.bag_value = "meth"
  l_1_0.meth.AI_carry = {SO_category = "enemies"}
  l_1_0.lance_bag = {}
  l_1_0.lance_bag.type = "medium"
  l_1_0.lance_bag.name_id = "hud_carry_lance_bag"
  l_1_0.lance_bag.skip_exit_secure = true
  l_1_0.lance_bag.visual_object = "g_toolsbag"
  l_1_0.lance_bag.unit = "units/payday2/pickups/gen_pku_toolbag/gen_pku_toolbag"
  l_1_0.lance_bag.AI_carry = {SO_category = "enemies"}
  l_1_0.weapon = {}
  l_1_0.weapon.type = "heavy"
  l_1_0.weapon.name_id = "hud_carry_weapon"
  l_1_0.weapon.bag_value = "weapons"
  l_1_0.weapons = {}
  l_1_0.weapons.type = "heavy"
  l_1_0.weapons.bag_value = "weapons"
  l_1_0.weapons.name_id = "hud_carry_weapons"
  l_1_0.person = {}
  l_1_0.person.type = "being"
  l_1_0.person.name_id = "hud_carry_person"
  l_1_0.person.unit = "units/payday2/pickups/gen_pku_bodybag/gen_pku_bodybag"
  l_1_0.person.visual_object = "g_body_bag"
  l_1_0.person.default_value = 1
  l_1_0.person.is_unique_loot = true
  l_1_0.person.skip_exit_secure = true
  l_1_0.special_person = {}
  l_1_0.special_person.type = "being"
  l_1_0.special_person.name_id = "hud_carry_special_person"
  l_1_0.special_person.unit = "units/payday2/pickups/gen_pku_bodybag/gen_pku_bodybag"
  l_1_0.special_person.default_value = 1
  l_1_0.special_person.is_unique_loot = true
  l_1_0.special_person.skip_exit_secure = true
  l_1_0.circuit = {}
  l_1_0.circuit.type = "heavy"
  l_1_0.circuit.name_id = "hud_carry_circuit"
  l_1_0.engine_01 = {}
  l_1_0.engine_01.type = "mega_heavy"
  l_1_0.engine_01.name_id = "hud_carry_engine_1"
  l_1_0.engine_01.skip_exit_secure = true
  l_1_0.engine_01.AI_carry = {SO_category = "enemies"}
  l_1_0.engine_02 = {}
  l_1_0.engine_02.type = "mega_heavy"
  l_1_0.engine_02.name_id = "hud_carry_engine_2"
  l_1_0.engine_02.skip_exit_secure = true
  l_1_0.engine_02.AI_carry = {SO_category = "enemies"}
  l_1_0.engine_03 = {}
  l_1_0.engine_03.type = "mega_heavy"
  l_1_0.engine_03.name_id = "hud_carry_engine_3"
  l_1_0.engine_03.skip_exit_secure = true
  l_1_0.engine_03.AI_carry = {SO_category = "enemies"}
  l_1_0.engine_04 = {}
  l_1_0.engine_04.type = "mega_heavy"
  l_1_0.engine_04.name_id = "hud_carry_engine_4"
  l_1_0.engine_04.skip_exit_secure = true
  l_1_0.engine_04.AI_carry = {SO_category = "enemies"}
  l_1_0.engine_05 = {}
  l_1_0.engine_05.type = "mega_heavy"
  l_1_0.engine_05.name_id = "hud_carry_engine_5"
  l_1_0.engine_05.skip_exit_secure = true
  l_1_0.engine_05.AI_carry = {SO_category = "enemies"}
  l_1_0.engine_06 = {}
  l_1_0.engine_06.type = "mega_heavy"
  l_1_0.engine_06.name_id = "hud_carry_engine_6"
  l_1_0.engine_06.skip_exit_secure = true
  l_1_0.engine_06.AI_carry = {SO_category = "enemies"}
  l_1_0.engine_07 = {}
  l_1_0.engine_07.type = "mega_heavy"
  l_1_0.engine_07.name_id = "hud_carry_engine_7"
  l_1_0.engine_07.skip_exit_secure = true
  l_1_0.engine_07.AI_carry = {SO_category = "enemies"}
  l_1_0.engine_08 = {}
  l_1_0.engine_08.type = "mega_heavy"
  l_1_0.engine_08.name_id = "hud_carry_engine_8"
  l_1_0.engine_08.skip_exit_secure = true
  l_1_0.engine_08.AI_carry = {SO_category = "enemies"}
  l_1_0.engine_09 = {}
  l_1_0.engine_09.type = "mega_heavy"
  l_1_0.engine_09.name_id = "hud_carry_engine_9"
  l_1_0.engine_09.skip_exit_secure = true
  l_1_0.engine_09.AI_carry = {SO_category = "enemies"}
  l_1_0.engine_10 = {}
  l_1_0.engine_10.type = "mega_heavy"
  l_1_0.engine_10.name_id = "hud_carry_engine_10"
  l_1_0.engine_10.skip_exit_secure = true
  l_1_0.engine_10.AI_carry = {SO_category = "enemies"}
  l_1_0.engine_11 = {}
  l_1_0.engine_11.type = "mega_heavy"
  l_1_0.engine_11.name_id = "hud_carry_engine_11"
  l_1_0.engine_11.skip_exit_secure = true
  l_1_0.engine_11.AI_carry = {SO_category = "enemies"}
  l_1_0.engine_12 = {}
  l_1_0.engine_12.type = "mega_heavy"
  l_1_0.engine_12.name_id = "hud_carry_engine_12"
  l_1_0.engine_12.skip_exit_secure = true
  l_1_0.engine_12.AI_carry = {SO_category = "enemies"}
end

CarryTweakData.get_carry_ids = function(l_2_0)
  local t = {}
  for id,_ in pairs(tweak_data.carry) do
    if type(tweak_data.carry[id]) == "table" and tweak_data.carry[id].type then
      table.insert(t, id)
    end
  end
  return t
end


