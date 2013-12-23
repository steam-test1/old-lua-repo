-- Decompiled using luadec 2.0.1 by sztupy (http://winmo.sztupy.hu)
-- Command line was: F:\SteamLibrary\SteamApps\common\PAYDAY 2\lua\lib\tweak_data\upgradestweakdata.luac 

if not UpgradesTweakData then
  UpgradesTweakData = class()
end
UpgradesTweakData._init_pd2_values = function(l_1_0)
  l_1_0:_init_value_tables()
  l_1_0.values.rep_upgrades = {}
  l_1_0.values.rep_upgrades.classes = {"rep_upgrade"}
  l_1_0.values.rep_upgrades.values = {2}
  l_1_0.values.player.body_armor = {1, 2, 3, 4, 5, 10}
  l_1_0.values.player.armor_movement_penalty = {0.95999997854233, 0.9200000166893, 0.87999999523163, 0.83999997377396, 0.80000001192093, 0.75999999046326}
  l_1_0.values.player.special_enemy_highlight = {true}
  l_1_0.values.player.hostage_trade = {true}
  l_1_0.values.player.sec_camera_highlight = {true}
  l_1_0.ammo_bag_base = 4
  l_1_0.ecm_jammer_base_battery_life = 20
  l_1_0.ecm_jammer_base_low_battery_life = 8
  l_1_0.sentry_gun_base_ammo = 150
  l_1_0.sentry_gun_base_armor = 10
  l_1_0.doctor_bag_base = 2
  l_1_0.values.player.crime_net_deal = {0.89999997615814, 0.80000001192093}
  l_1_0.values.weapon.special_damage_taken_multiplier = {1.0499999523163}
  l_1_0.values.player.marked_enemy_extra_damage = {true}
  l_1_0.values.player.marked_enemy_damage_mul = 1.1499999761581
  l_1_0.values.cable_tie.interact_speed_multiplier = {0.5}
  l_1_0.values.cable_tie.quantity = {3}
  l_1_0.values.cable_tie.can_cable_tie_doors = {true}
  l_1_0.values.temporary.combat_medic_damage_multiplier = {{1.25, 10}, {1.25, 15}}
  l_1_0.values.player.revive_health_boost = {1}
  l_1_0.revive_health_multiplier = {1.25}
  l_1_0.values.player.civ_harmless_bullets = {true}
  l_1_0.values.player.civ_harmless_melee = {true}
  l_1_0.values.player.civ_calming_alerts = {true}
  l_1_0.values.player.civ_intimidation_mul = {10}
  l_1_0.values.team.pistol.recoil_multiplier = {0.75}
  l_1_0.values.team.weapon.recoil_multiplier = {0.5}
  l_1_0.values.player.assets_cost_multiplier = {0.5}
  l_1_0.values.player.additional_assets = {true}
  l_1_0.values.player.stamina_multiplier = {2}
  l_1_0.values.team.stamina.multiplier = {1.5}
  l_1_0.values.player.intimidate_enemies = {true}
  l_1_0.values.player.intimidate_range_mul = {1.5}
  l_1_0.values.player.intimidate_aura = {700}
  l_1_0.values.player.civilian_reviver = {true}
  l_1_0.values.player.civilian_gives_ammo = {true}
  l_1_0.values.player.buy_cost_multiplier = {0.94999998807907, 0.80000001192093}
  l_1_0.values.player.sell_cost_multiplier = {1.25}
  l_1_0.values.doctor_bag.quantity = {1}
  l_1_0.values.doctor_bag.amount_increase = {2}
  l_1_0.values.player.convert_enemies = {true}
  l_1_0.values.player.convert_enemies_max_minions = {1, 2}
  l_1_0.values.player.convert_enemies_health_multiplier = {0.64999997615814}
  l_1_0.values.player.convert_enemies_damage_multiplier = {1.4299999475479}
  l_1_0.values.player.xp_multiplier = {1.1000000238419}
  l_1_0.values.team.xp.multiplier = {1.1000000238419}
  l_1_0.values.pistol.reload_speed_multiplier = {1.3300000429153}
  l_1_0.values.pistol.damage_multiplier = {1.25}
  l_1_0.values.assault_rifle.reload_speed_multiplier = {1.3300000429153}
  l_1_0.values.assault_rifle.move_spread_multiplier = {0.5}
  l_1_0.values.player.pistol_revive_from_bleed_out = {1, 3}
  l_1_0.values.pistol.spread_multiplier = {0.89999997615814}
  l_1_0.values.pistol.swap_speed_multiplier = {1.5}
  l_1_0.values.pistol.fire_rate_multiplier = {2}
  l_1_0.values.player.revive_interaction_speed_multiplier = {0.5}
  l_1_0.values.player.long_dis_revive = {true}
  l_1_0.values.doctor_bag.interaction_speed_multiplier = {0.80000001192093}
  l_1_0.values.team.stamina.passive_multiplier = {1.1499999761581, 1.2999999523163}
  l_1_0.values.player.passive_intimidate_range_mul = {1.25}
  l_1_0.values.player.passive_convert_enemies_health_multiplier = {0.25}
  l_1_0.values.player.passive_convert_enemies_damage_multiplier = {1.0499999523163}
  l_1_0.values.player.convert_enemies_interaction_speed_multiplier = {0.33000001311302}
  l_1_0.values.player.empowered_intimidation_mul = {3}
  l_1_0.values.player.passive_assets_cost_multiplier = {0.5}
  l_1_0.values.player.suppression_multiplier = {1.25, 1.75}
  l_1_0.values.carry.movement_speed_multiplier = {1.5}
  l_1_0.values.carry.throw_distance_multiplier = {1.5}
  l_1_0.values.temporary.no_ammo_cost = {{true, 5}, {true, 10}}
  l_1_0.values.player.non_special_melee_multiplier = {2}
  l_1_0.values.player.melee_damage_multiplier = {2}
  l_1_0.values.player.primary_weapon_when_downed = {true}
  l_1_0.values.player.armor_regen_timer_multiplier = {0.85000002384186}
  l_1_0.values.temporary.dmg_multiplier_outnumbered = {{1.1000000238419, 7}}
  l_1_0.values.temporary.dmg_dampener_outnumbered = {{0.85000002384186, 7}}
  l_1_0.values.player.extra_ammo_multiplier = {1.25}
  l_1_0.values.player.pick_up_ammo_multiplier = {1.75}
  l_1_0.values.player.damage_shake_multiplier = {0.5}
  l_1_0.values.player.bleed_out_health_multiplier = {1.25}
  l_1_0.values.shotgun.recoil_multiplier = {0.75}
  l_1_0.values.shotgun.damage_multiplier = {1.2000000476837}
  l_1_0.values.ammo_bag.ammo_increase = {2}
  l_1_0.values.ammo_bag.quantity = {1}
  l_1_0.values.shotgun.reload_speed_multiplier = {1.5}
  l_1_0.values.shotgun.enter_steelsight_speed_multiplier = {2.25}
  l_1_0.values.saw.extra_ammo_multiplier = {1.5}
  l_1_0.values.player.flashbang_multiplier = {0.5, 0.25}
  l_1_0.values.shotgun.hip_fire_spread_multiplier = {0.80000001192093}
  l_1_0.values.pistol.hip_fire_spread_multiplier = {0.80000001192093}
  l_1_0.values.assault_rifle.hip_fire_spread_multiplier = {0.80000001192093}
  l_1_0.values.smg.hip_fire_spread_multiplier = {0.80000001192093}
  l_1_0.values.saw.hip_fire_spread_multiplier = {0.80000001192093}
  l_1_0.values.player.saw_speed_multiplier = {0.89999997615814, 0.69999998807907}
  l_1_0.values.saw.lock_damage_multiplier = {1.2000000476837, 1.3999999761581}
  l_1_0.values.saw.enemy_slicer = {true}
  l_1_0.values.player.melee_damage_health_ratio_multiplier = {5}
  l_1_0.values.player.damage_health_ratio_multiplier = {1}
  l_1_0.player_damage_health_ratio_threshold = 0.40000000596046
  l_1_0.values.player.shield_knock = {true}
  l_1_0.values.temporary.overkill_damage_multiplier = {{2, 6}}
  l_1_0.values.player.overkill_all_weapons = {true}
  l_1_0.values.player.passive_suppression_multiplier = {1.1000000238419, 1.2000000476837}
  l_1_0.values.player.passive_health_multiplier = {1.1000000238419, 1.2000000476837, 1.3999999761581}
  l_1_0.values.weapon.passive_damage_multiplier = {1.0499999523163}
  l_1_0.values.assault_rifle.enter_steelsight_speed_multiplier = {2}
  l_1_0.values.assault_rifle.zoom_increase = {2}
  l_1_0.values.player.crafting_weapon_multiplier = {0.89999997615814}
  l_1_0.values.player.crafting_mask_multiplier = {0.89999997615814}
  l_1_0.values.trip_mine.quantity_1 = {1}
  l_1_0.values.trip_mine.can_switch_on_off = {true}
  l_1_0.values.player.drill_speed_multiplier = {0.89999997615814, 0.75}
  l_1_0.values.player.trip_mine_deploy_time_multiplier = {0.80000001192093, 0.5}
  l_1_0.values.trip_mine.sensor_toggle = {true}
  l_1_0.values.player.drill_fix_interaction_speed_multiplier = {0.75}
  l_1_0.values.player.drill_autorepair = {0.30000001192093}
  l_1_0.values.player.sentry_gun_deploy_time_multiplier = {0.5}
  l_1_0.values.sentry_gun.armor_multiplier = {2}
  l_1_0.values.weapon.single_spread_multiplier = {0.5}
  l_1_0.values.assault_rifle.recoil_multiplier = {0.75}
  l_1_0.values.player.taser_malfunction = {true}
  l_1_0.values.player.taser_self_shock = {true}
  l_1_0.values.sentry_gun.spread_multiplier = {0.5}
  l_1_0.values.sentry_gun.rot_speed_multiplier = {2}
  l_1_0.values.player.interacting_damage_multiplier = {0.5}
  l_1_0.values.player.steelsight_when_downed = {true}
  l_1_0.values.player.drill_alert_rad = {900}
  l_1_0.values.player.silent_drill = {true}
  l_1_0.values.sentry_gun.extra_ammo_multiplier = {1.5, 2}
  l_1_0.values.sentry_gun.shield = {true}
  l_1_0.values.trip_mine.explosion_size_multiplier = {1.25, 1.75}
  l_1_0.values.trip_mine.quantity_3 = {3}
  l_1_0.values.player.trip_mine_shaped_charge = {true}
  l_1_0.values.sentry_gun.quantity = {1}
  l_1_0.values.sentry_gun.damage_multiplier = {2}
  l_1_0.values.weapon.clip_ammo_increase = {5, 15}
  l_1_0.values.player.armor_multiplier = {1.5}
  l_1_0.values.team.armor.regen_time_multiplier = {0.75}
  l_1_0.values.player.passive_crafting_weapon_multiplier = {0.99000000953674, 0.97000002861023, 0.94999998807907}
  l_1_0.values.player.passive_crafting_mask_multiplier = {0.99000000953674, 0.97000002861023, 0.94999998807907}
  l_1_0.values.weapon.passive_recoil_multiplier = {0.94999998807907, 0.89999997615814}
  l_1_0.values.weapon.passive_headshot_damage_multiplier = {1.25}
  l_1_0.values.player.passive_armor_multiplier = {1.1000000238419, 1.25}
  l_1_0.values.team.armor.passive_regen_time_multiplier = {0.89999997615814}
  l_1_0.values.player.small_loot_multiplier = {1.1000000238419, 1.2999999523163}
  l_1_0.values.player.stamina_regen_timer_multiplier = {0.75}
  l_1_0.values.player.stamina_regen_multiplier = {1.25}
  l_1_0.values.player.run_dodge_chance = {0.25}
  l_1_0.values.player.run_speed_multiplier = {1.25}
  l_1_0.values.player.fall_damage_multiplier = {0.5}
  l_1_0.values.player.fall_health_damage_multiplier = {0}
  l_1_0.values.player.respawn_time_multiplier = {0.5}
  l_1_0.values.player.corpse_alarm_pager_bluff = {true}
  l_1_0.values.player.corpse_dispose = {true}
  l_1_0.values.carry.interact_speed_multiplier = {0.60000002384186, 0.25}
  l_1_0.values.player.suspicion_multiplier = {0.75}
  l_1_0.values.player.camouflage_bonus = {1.25}
  l_1_0.values.player.walk_speed_multiplier = {1.25}
  l_1_0.values.player.crouch_speed_multiplier = {1.25}
  l_1_0.values.player.silent_kill = {400}
  l_1_0.values.player.melee_knockdown_mul = {1.5}
  l_1_0.values.player.damage_dampener = {0.5}
  l_1_0.values.smg.reload_speed_multiplier = {1.3300000429153}
  l_1_0.values.smg.recoil_multiplier = {0.75}
  l_1_0.values.player.additional_lives = {1, 3}
  l_1_0.values.player.cheat_death_chance = {0.10000000149012}
  l_1_0.values.ecm_jammer.can_activate_feedback = {true}
  l_1_0.values.ecm_jammer.feedback_duration_boost = {1.25}
  l_1_0.values.weapon.silencer_damage_multiplier = {1.1000000238419, 1.2000000476837}
  l_1_0.values.ecm_jammer.duration_multiplier = {1.25}
  l_1_0.values.ecm_jammer.can_open_sec_doors = {true}
  l_1_0.values.player.pick_lock_easy = {true}
  l_1_0.values.player.pick_lock_easy_speed_multiplier = {0.75}
  l_1_0.values.player.pick_lock_hard = {true}
  l_1_0.values.weapon.silencer_recoil_multiplier = {0.5}
  l_1_0.values.weapon.silencer_spread_multiplier = {0.5}
  l_1_0.values.weapon.silencer_enter_steelsight_speed_multiplier = {2}
  l_1_0.values.player.loot_drop_multiplier = {1.5, 3}
  l_1_0.values.ecm_jammer.quantity = {1, 3}
  l_1_0.values.ecm_jammer.duration_multiplier_2 = {1.25}
  l_1_0.values.ecm_jammer.feedback_duration_boost_2 = {1.25}
  l_1_0.values.player.can_strafe_run = {true}
  l_1_0.values.player.can_free_run = {true}
  l_1_0.values.ecm_jammer.affects_cameras = {true}
  l_1_0.values.player.passive_dodge_chance = {0.050000000745058, 0.15000000596046}
  l_1_0.values.weapon.passive_swap_speed_multiplier = {1.2000000476837, 2}
  l_1_0.values.player.passive_suspicion_multiplier = {0.75}
  l_1_0.values.player.passive_loot_drop_multiplier = {1.1000000238419}
end

UpgradesTweakData.init = function(l_2_0)
  l_2_0.level_tree = {}
  l_2_0.level_tree[1] = {name_id = "body_armor", upgrades = {"body_armor2", "ak74"}}
  l_2_0.level_tree[2] = {name_id = "Angst", upgrades = {"colt_1911", "mac10"}}
  l_2_0.level_tree[4] = {name_id = "Angst", upgrades = {"new_m4"}}
  l_2_0.level_tree[6] = {name_id = "Angst", upgrades = {"new_raging_bull", "b92fs"}}
  l_2_0.level_tree[7] = {name_id = "body_armor", upgrades = {"body_armor1"}}
  l_2_0.level_tree[8] = {name_id = "Angst", upgrades = {"r870", "aug"}}
  l_2_0.level_tree[10] = {name_id = "lvl_10", upgrades = {"rep_upgrade1"}}
  l_2_0.level_tree[12] = {name_id = "body_armor3", upgrades = {"body_armor3"}}
  l_2_0.level_tree[13] = {name_id = "Angst", upgrades = {"new_mp5", "serbu"}}
  l_2_0.level_tree[16] = {name_id = "Angst", upgrades = {"akm", "g36"}}
  l_2_0.level_tree[19] = {name_id = "Angst", upgrades = {"olympic", "mp9"}}
  l_2_0.level_tree[20] = {name_id = "lvl_20", upgrades = {"rep_upgrade2"}}
  l_2_0.level_tree[21] = {name_id = "body_armor4", upgrades = {"body_armor4"}}
  l_2_0.level_tree[26] = {name_id = "Angst", upgrades = {"new_m14", "saiga"}}
  l_2_0.level_tree[29] = {name_id = "Angst", upgrades = {"akmsu", "glock_18c"}}
  l_2_0.level_tree[30] = {name_id = "lvl_30", upgrades = {"rep_upgrade3"}}
  l_2_0.level_tree[31] = {name_id = "body_armor5", upgrades = {"body_armor5"}}
  l_2_0.level_tree[33] = {name_id = "Angst", upgrades = {"ak5"}}
  l_2_0.level_tree[36] = {name_id = "Angst", upgrades = {"p90", "deagle"}}
  l_2_0.level_tree[39] = {name_id = "Angst", upgrades = {"m16", "huntsman"}}
  l_2_0.level_tree[40] = {name_id = "lvl_40", upgrades = {"rep_upgrade4"}}
  l_2_0.level_tree[50] = {name_id = "lvl_50", upgrades = {"rep_upgrade5"}}
  l_2_0.level_tree[60] = {name_id = "lvl_60", upgrades = {"rep_upgrade6"}}
  l_2_0.level_tree[70] = {name_id = "lvl_70", upgrades = {"rep_upgrade7"}}
  l_2_0.level_tree[80] = {name_id = "lvl_80", upgrades = {"rep_upgrade8"}}
  l_2_0.level_tree[90] = {name_id = "lvl_90", upgrades = {"rep_upgrade9"}}
  l_2_0.level_tree[95] = {name_id = "menu_es_jobs_available", upgrades = {"lucky_charm"}}
  l_2_0.level_tree[100] = {name_id = "lvl_100", upgrades = {"rep_upgrade10"}}
  l_2_0:_init_pd2_values(l_2_0)
  l_2_0:_init_values()
  l_2_0.steps = {}
  if not l_2_0.values.player then
    l_2_0.values.player = {}
  end
  l_2_0.values.player.thick_skin = {2, 4, 6, 8, 10}
  l_2_0.values.player.primary_weapon_when_carrying = {true}
  l_2_0.values.player.health_multiplier = {1.1000000238419}
  l_2_0.values.player.electrocution_resistance_multiplier = {0.25}
  l_2_0.values.player.passive_xp_multiplier = {1.0499999523163}
  l_2_0.values.player.dye_pack_chance_multiplier = {0.5}
  l_2_0.values.player.dye_pack_cash_loss_multiplier = {0.40000000596046}
  l_2_0.values.player.toolset = {0.94999998807907, 0.89999997615814, 0.85000002384186, 0.80000001192093}
  l_2_0.values.player.uncover_progress_mul = {0.5}
  l_2_0.values.player.uncover_progress_decay_mul = {1.5}
  l_2_0.values.player.suppressed_multiplier = {0.5}
  l_2_0.values.player.intimidate_specials = {true}
  l_2_0.values.player.intimidation_multiplier = {1.25}
  l_2_0.values.player.morale_boost = {true}
  l_2_0.steps.player = {}
  l_2_0.steps.player.thick_skin = {nil, 8, 18, 27, 39}
  l_2_0.steps.player.extra_ammo_multiplier = {nil, 7, 16, 24, 38}
  l_2_0.steps.player.toolset = {nil, 7, 16, 38}
  if not l_2_0.values.trip_mine then
    l_2_0.values.trip_mine = {}
  end
  l_2_0.values.trip_mine.quantity = {1, 2, 3, 4, 5, 8}
  l_2_0.values.trip_mine.quantity_2 = {2}
  l_2_0.values.trip_mine.quantity_increase = {2}
  l_2_0.values.trip_mine.explode_timer_delay = {2}
  l_2_0.steps.trip_mine = {}
  l_2_0.steps.trip_mine.quantity = {14, 22, 29, 36, 42, 47}
  l_2_0.steps.trip_mine.damage_multiplier = {6, 32}
  if not l_2_0.values.ammo_bag then
    l_2_0.values.ammo_bag = {}
  end
  l_2_0.steps.ammo_bag = {}
  l_2_0.steps.ammo_bag.ammo_increase = {10, 19, 30}
  if not l_2_0.values.ecm_jammer then
    l_2_0.values.ecm_jammer = {}
  end
  if not l_2_0.values.sentry_gun then
    l_2_0.values.sentry_gun = {}
  end
  l_2_0.steps.sentry_gun = {}
  if not l_2_0.values.doctor_bag then
    l_2_0.values.doctor_bag = {}
  end
  l_2_0.steps.doctor_bag = {}
  l_2_0.steps.doctor_bag.amount_increase = {11, 19, 33}
  l_2_0.values.extra_cable_tie = {}
  l_2_0.values.extra_cable_tie.quantity = {1, 2, 3, 4}
  l_2_0.steps.extra_cable_tie = {}
  l_2_0.steps.extra_cable_tie.quantity = {nil, 12, 23, 33}
  l_2_0.definitions = {}
  l_2_0:_player_definitions()
  l_2_0:_trip_mine_definitions()
  l_2_0:_ecm_jammer_definitions()
  l_2_0:_ammo_bag_definitions()
  l_2_0:_doctor_bag_definitions()
  l_2_0:_cable_tie_definitions()
  l_2_0:_sentry_gun_definitions()
  l_2_0:_rep_definitions()
  l_2_0:_olympic_definitions()
  l_2_0:_amcar_definitions()
  l_2_0:_m16_definitions(l_2_0)
  l_2_0:_new_m4_definitions(l_2_0)
  l_2_0:_glock_18c_definitions(l_2_0)
  l_2_0:_saiga_definitions()
  l_2_0:_akmsu_definitions()
  l_2_0:_ak74_definitions(l_2_0)
  l_2_0:_akm_definitions()
  l_2_0:_ak5_definitions(l_2_0)
  l_2_0:_aug_definitions()
  l_2_0:_g36_definitions(l_2_0)
  l_2_0:_p90_definitions(l_2_0)
  l_2_0:_new_m14_definitions(l_2_0)
  l_2_0:_mp9_definitions(l_2_0)
  l_2_0:_deagle_definitions()
  l_2_0:_new_mp5_definitions(l_2_0)
  l_2_0:_colt_1911_definitions(l_2_0)
  l_2_0:_mac10_definitions(l_2_0)
  l_2_0:_glock_17_definitions(l_2_0)
  l_2_0:_b92fs_definitions(l_2_0)
  l_2_0:_huntsman_definitions()
  l_2_0:_r870_definitions(l_2_0)
  l_2_0:_serbu_definitions()
  l_2_0:_new_raging_bull_definitions()
  l_2_0:_saw_definitions()
  l_2_0:_weapon_definitions()
  l_2_0:_pistol_definitions()
  l_2_0:_assault_rifle_definitions()
  l_2_0:_smg_definitions()
  l_2_0:_shotgun_definitions()
  l_2_0:_carry_definitions()
  l_2_0:_team_definitions()
  l_2_0:_temporary_definitions()
  l_2_0:_shape_charge_definitions()
  l_2_0.definitions.lucky_charm = {category = "what_is_this", name_id = "menu_lucky_charm"}
  l_2_0.levels = {}
  for name,upgrade in pairs(l_2_0.definitions) do
    local unlock_lvl = upgrade.unlock_lvl or 1
    if not l_2_0.levels[unlock_lvl] then
      l_2_0.levels[unlock_lvl] = {}
    end
    if upgrade.prio and upgrade.prio == "high" then
      table.insert(l_2_0.levels[unlock_lvl], 1, name)
      for (for control),name in (for generator) do
      end
      table.insert(l_2_0.levels[unlock_lvl], name)
    end
    l_2_0.progress = {{}, {}, {}, {}}
    for name,upgrade in pairs(l_2_0.definitions) do
      if upgrade.tree then
        if upgrade.step then
          if l_2_0.progress[upgrade.tree][upgrade.step] then
            Application:error("upgrade collision", upgrade.tree, upgrade.step, l_2_0.progress[upgrade.tree][upgrade.step], name)
          end
          l_2_0.progress[upgrade.tree][upgrade.step] = name
          for (for control),name in (for generator) do
          end
          print(name, upgrade.tree, "is in no step")
        end
      end
      l_2_0.progress[1][49] = "mr_nice_guy"
      l_2_0.progress[2][49] = "mr_nice_guy"
      l_2_0.progress[3][49] = "mr_nice_guy"
      l_2_0.progress[4][49] = "mr_nice_guy"
       -- Warning: missing end command somewhere! Added here
    end
     -- Warning: missing end command somewhere! Added here
  end
end

UpgradesTweakData._init_value_tables = function(l_3_0)
  l_3_0.values = {}
  l_3_0.values.player = {}
  l_3_0.values.carry = {}
  l_3_0.values.trip_mine = {}
  l_3_0.values.ammo_bag = {}
  l_3_0.values.ecm_jammer = {}
  l_3_0.values.sentry_gun = {}
  l_3_0.values.doctor_bag = {}
  l_3_0.values.cable_tie = {}
  l_3_0.values.weapon = {}
  l_3_0.values.pistol = {}
  l_3_0.values.assault_rifle = {}
  l_3_0.values.smg = {}
  l_3_0.values.shotgun = {}
  l_3_0.values.saw = {}
  l_3_0.values.temporary = {}
  l_3_0.values.team = {}
  l_3_0.values.team.weapon = {}
  l_3_0.values.team.pistol = {}
  l_3_0.values.team.xp = {}
  l_3_0.values.team.armor = {}
  l_3_0.values.team.stamina = {}
end

UpgradesTweakData._init_values = function(l_4_0)
  if not l_4_0.values.weapon then
    l_4_0.values.weapon = {}
  end
  l_4_0.values.weapon.reload_speed_multiplier = {1}
  l_4_0.values.weapon.damage_multiplier = {1}
  l_4_0.values.weapon.swap_speed_multiplier = {1.25}
  l_4_0.values.weapon.passive_reload_speed_multiplier = {1.1000000238419}
  l_4_0.values.weapon.auto_spread_multiplier = {1}
  l_4_0.values.weapon.spread_multiplier = {0.89999997615814}
  l_4_0.values.weapon.fire_rate_multiplier = {2}
  if not l_4_0.values.pistol then
    l_4_0.values.pistol = {}
  end
  l_4_0.values.pistol.exit_run_speed_multiplier = {1.25}
  if not l_4_0.values.assault_rifle then
    l_4_0.values.assault_rifle = {}
  end
  if not l_4_0.values.smg then
    l_4_0.values.smg = {}
  end
  if not l_4_0.values.shotgun then
    l_4_0.values.shotgun = {}
  end
  if not l_4_0.values.carry then
    l_4_0.values.carry = {}
  end
  l_4_0.values.carry.catch_interaction_speed = {0.60000002384186, 0.10000000149012}
  if not l_4_0.values.cable_tie then
    l_4_0.values.cable_tie = {}
  end
  l_4_0.values.cable_tie.quantity_unlimited = {true}
  if not l_4_0.values.temporary then
    l_4_0.values.temporary = {}
  end
  l_4_0.values.temporary.combat_medic_enter_steelsight_speed_multiplier = {{1.2000000476837, 15}}
  l_4_0.values.temporary.wolverine_health_regen = {{0.0010000000474975, 5}}
  l_4_0.values.temporary.pistol_revive_from_bleed_out = {{true, 3}}
  l_4_0.values.temporary.revive_health_boost = {{true, 10}}
  if not l_4_0.values.team then
    l_4_0.values.team = {}
  end
  if not l_4_0.values.team.pistol then
    l_4_0.values.team.pistol = {}
  end
  if not l_4_0.values.team.weapon then
    l_4_0.values.team.weapon = {}
  end
  l_4_0.values.team.weapon.suppression_recoil_multiplier = {0.75}
  if not l_4_0.values.team.xp then
    l_4_0.values.team.xp = {}
  end
  if not l_4_0.values.team.armor then
    l_4_0.values.team.armor = {}
  end
  if not l_4_0.values.team.stamina then
    l_4_0.values.team.stamina = {}
  end
  if not l_4_0.values.saw then
    l_4_0.values.saw = {}
  end
  l_4_0.values.saw.recoil_multiplier = {0.75}
  l_4_0.values.saw.fire_rate_multiplier = {1.25, 1.5}
end

UpgradesTweakData._player_definitions = function(l_5_0)
  l_5_0.definitions.body_armor1 = {category = "armor", armor_id = "level_2", name_id = "bm_armor_level_2"}
  l_5_0.definitions.body_armor2 = {category = "armor", armor_id = "level_3", name_id = "bm_armor_level_3"}
  l_5_0.definitions.body_armor3 = {category = "armor", armor_id = "level_4", name_id = "bm_armor_level_4"}
  l_5_0.definitions.body_armor4 = {category = "armor", armor_id = "level_5", name_id = "bm_armor_level_5"}
  l_5_0.definitions.body_armor5 = {category = "armor", armor_id = "level_6", name_id = "bm_armor_level_6"}
  l_5_0.definitions.body_armor6 = {category = "armor", armor_id = "level_7", name_id = "bm_armor_level_7"}
   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

  l_5_0.definitions.thick_skin, {tree = 2, step = 2, category = "equipment", equipment_id = "thick_skin", title_id = "debug_upgrade_player_upgrade", subtitle_id = "debug_upgrade_thick_skin1", name_id = "debug_upgrade_thick_skin1", icon = "equipment_armor", image = "upgrades_thugskin", image_slice = "upgrades_thugskin_slice", description_text_id = "thick_skin", unlock_lvl = 0}.slot, {tree = 2, step = 2, category = "equipment", equipment_id = "thick_skin", title_id = "debug_upgrade_player_upgrade", subtitle_id = "debug_upgrade_thick_skin1", name_id = "debug_upgrade_thick_skin1", icon = "equipment_armor", image = "upgrades_thugskin", image_slice = "upgrades_thugskin_slice", description_text_id = "thick_skin", unlock_lvl = 0}.aquire = {tree = 2, step = 2, category = "equipment", equipment_id = "thick_skin", title_id = "debug_upgrade_player_upgrade", subtitle_id = "debug_upgrade_thick_skin1", name_id = "debug_upgrade_thick_skin1", icon = "equipment_armor", image = "upgrades_thugskin", image_slice = "upgrades_thugskin_slice", description_text_id = "thick_skin", unlock_lvl = 0}, 2, {upgrade = "thick_skin1"}
  for i,_ in ipairs(l_5_0.values.player.thick_skin) do
    local depends_on = (i - 1 > 0 and "thick_skin" .. i - 1)
    local unlock_lvl = 3
    local prio = (i == 1 and "high")
     -- DECOMPILER ERROR: Confused about usage of registers!

     -- DECOMPILER ERROR: Confused about usage of registers!

    l_5_0.definitions.thick_skin" .. , {tree = 2, step = l_5_0.steps.player.thick_skin[i], category = "feature", title_id = "debug_upgrade_player_upgrade", subtitle_id = "debug_upgrade_thick_skin" .. i, name_id = "debug_upgrade_thick_skin" .. i, icon = "equipment_thick_skin", image = "upgrades_thugskin", image_slice = "upgrades_thugskin_slice", description_text_id = "thick_skin", depends_on = depends_on, unlock_lvl = unlock_lvl}.upgrade, {tree = 2, step = l_5_0.steps.player.thick_skin[i], category = "feature", title_id = "debug_upgrade_player_upgrade", subtitle_id = "debug_upgrade_thick_skin" .. i, name_id = "debug_upgrade_thick_skin" .. i, icon = "equipment_thick_skin", image = "upgrades_thugskin", image_slice = "upgrades_thugskin_slice", description_text_id = "thick_skin", depends_on = depends_on, unlock_lvl = unlock_lvl}.prio = {tree = 2, step = l_5_0.steps.player.thick_skin[i], category = "feature", title_id = "debug_upgrade_player_upgrade", subtitle_id = "debug_upgrade_thick_skin" .. i, name_id = "debug_upgrade_thick_skin" .. i, icon = "equipment_thick_skin", image = "upgrades_thugskin", image_slice = "upgrades_thugskin_slice", description_text_id = "thick_skin", depends_on = depends_on, unlock_lvl = unlock_lvl}, {category = "player", upgrade = "thick_skin", value = i}, prio
  end
   -- DECOMPILER ERROR: Confused about usage of registers!

  l_5_0.definitions.extra_start_out_ammo, {tree = 3, step = 2, category = "equipment", equipment_id = "extra_start_out_ammo", name_id = "debug_upgrade_extra_start_out_ammo1", title_id = "debug_upgrade_player_upgrade", subtitle_id = "debug_upgrade_extra_start_out_ammo1", icon = "equipment_extra_start_out_ammo", image = "upgrades_extrastartammo", image_slice = "upgrades_extrastartammo_slice", description_text_id = "extra_ammo_multiplier", unlock_lvl = 13, prio = "high", aquire = {upgrade = "extra_ammo_multiplier1"}}.slot = {tree = 3, step = 2, category = "equipment", equipment_id = "extra_start_out_ammo", name_id = "debug_upgrade_extra_start_out_ammo1", title_id = "debug_upgrade_player_upgrade", subtitle_id = "debug_upgrade_extra_start_out_ammo1", icon = "equipment_extra_start_out_ammo", image = "upgrades_extrastartammo", image_slice = "upgrades_extrastartammo_slice", description_text_id = "extra_ammo_multiplier", unlock_lvl = 13, prio = "high", aquire = {upgrade = "extra_ammo_multiplier1"}}, 2
  for i,_ in ipairs(l_5_0.values.player.extra_ammo_multiplier) do
    local depends_on = (i - 1 > 0 and "extra_ammo_multiplier" .. i - 1)
    local unlock_lvl = 14
    local prio = (i == 1 and "high")
     -- DECOMPILER ERROR: Confused about usage of registers!

     -- DECOMPILER ERROR: Confused about usage of registers!

    l_5_0.definitions.extra_ammo_multiplier" .. , {tree = 3, step = l_5_0.steps.player.extra_ammo_multiplier[i], category = "feature", name_id = "debug_upgrade_extra_start_out_ammo" .. i, title_id = "debug_upgrade_player_upgrade", subtitle_id = "debug_upgrade_extra_start_out_ammo" .. i, icon = "equipment_extra_start_out_ammo", image = "upgrades_extrastartammo", image_slice = "upgrades_extrastartammo_slice", description_text_id = "extra_ammo_multiplier", depends_on = depends_on, unlock_lvl = unlock_lvl}.upgrade, {tree = 3, step = l_5_0.steps.player.extra_ammo_multiplier[i], category = "feature", name_id = "debug_upgrade_extra_start_out_ammo" .. i, title_id = "debug_upgrade_player_upgrade", subtitle_id = "debug_upgrade_extra_start_out_ammo" .. i, icon = "equipment_extra_start_out_ammo", image = "upgrades_extrastartammo", image_slice = "upgrades_extrastartammo_slice", description_text_id = "extra_ammo_multiplier", depends_on = depends_on, unlock_lvl = unlock_lvl}.prio = {tree = 3, step = l_5_0.steps.player.extra_ammo_multiplier[i], category = "feature", name_id = "debug_upgrade_extra_start_out_ammo" .. i, title_id = "debug_upgrade_player_upgrade", subtitle_id = "debug_upgrade_extra_start_out_ammo" .. i, icon = "equipment_extra_start_out_ammo", image = "upgrades_extrastartammo", image_slice = "upgrades_extrastartammo_slice", description_text_id = "extra_ammo_multiplier", depends_on = depends_on, unlock_lvl = unlock_lvl}, {category = "player", upgrade = "extra_ammo_multiplier", value = i}, prio
  end
  l_5_0.definitions.player_flashbang_multiplier_1 = {category = "feature", name_id = "menu_player_flashbang_multiplier", upgrade = {category = "player", upgrade = "flashbang_multiplier", value = 1}}
  l_5_0.definitions.player_flashbang_multiplier_2 = {category = "feature", name_id = "menu_player_flashbang_multiplier", upgrade = {category = "player", upgrade = "flashbang_multiplier", value = 2}}
  l_5_0.definitions.player_pick_up_ammo_multiplier = {category = "feature", name_id = "menu_player_pick_up_ammo_multiplier", upgrade = {category = "player", upgrade = "pick_up_ammo_multiplier", value = 1}}
  l_5_0.definitions.player_primary_weapon_when_downed = {category = "feature", name_id = "menu_player_primary_weapon_when_downed", upgrade = {category = "player", upgrade = "primary_weapon_when_downed", value = 1}}
  l_5_0.definitions.player_primary_weapon_when_carrying = {category = "feature", name_id = "menu_player_primary_weapon_when_carrying", upgrade = {category = "player", upgrade = "primary_weapon_when_carrying", value = 1}}
  l_5_0.definitions.player_pistol_revive_from_bleed_out_1 = {category = "feature", name_id = "menu_player_pistol_revive_from_bleed_out", upgrade = {category = "player", upgrade = "pistol_revive_from_bleed_out", value = 1}}
  l_5_0.definitions.player_pistol_revive_from_bleed_out_2 = {category = "feature", name_id = "menu_player_pistol_revive_from_bleed_out", upgrade = {category = "player", upgrade = "pistol_revive_from_bleed_out", value = 2}}
  l_5_0.definitions.player_pistol_revive_from_bleed_out_timer = {category = "temporary", name_id = "menu_player_pistol_revive_from_bleed_out_timer", upgrade = {category = "temporary", upgrade = "pistol_revive_from_bleed_out", value = 1}}
  l_5_0.definitions.player_can_strafe_run = {category = "feature", name_id = "menu_player_can_strafe_run", upgrade = {category = "player", upgrade = "can_strafe_run", value = 1}}
  l_5_0.definitions.player_can_free_run = {category = "feature", name_id = "menu_player_can_free_run", upgrade = {category = "player", upgrade = "can_free_run", value = 1}}
  l_5_0.definitions.player_damage_shake_multiplier = {category = "feature", name_id = "menu_player_damage_shake_multiplier", upgrade = {category = "player", upgrade = "damage_shake_multiplier", value = 1}}
  l_5_0.definitions.player_health_multiplier = {category = "feature", name_id = "menu_player_health_multiplier", upgrade = {category = "player", upgrade = "health_multiplier", value = 1}}
  l_5_0.definitions.player_passive_health_multiplier_1 = {category = "feature", name_id = "menu_player_health_multiplier", upgrade = {category = "player", upgrade = "passive_health_multiplier", value = 1}}
  l_5_0.definitions.player_passive_health_multiplier_2 = {category = "feature", name_id = "menu_player_health_multiplier", upgrade = {category = "player", upgrade = "passive_health_multiplier", value = 2}}
  l_5_0.definitions.player_passive_health_multiplier_3 = {category = "feature", name_id = "menu_player_health_multiplier", upgrade = {category = "player", upgrade = "passive_health_multiplier", value = 3}}
  l_5_0.definitions.player_bleed_out_health_multiplier = {category = "feature", name_id = "menu_player_bleed_out_health_multiplier", upgrade = {category = "player", upgrade = "bleed_out_health_multiplier", value = 1}}
  l_5_0.definitions.player_revive_interaction_speed_multiplier = {category = "feature", name_id = "menu_player_revive_interaction_speed_multiplier", upgrade = {category = "player", upgrade = "revive_interaction_speed_multiplier", value = 1}}
  l_5_0.definitions.player_shield_knock = {category = "feature", name_id = "menu_player_shield_knock", upgrade = {category = "player", upgrade = "shield_knock", value = 1}}
  l_5_0.definitions.player_steelsight_when_downed = {category = "feature", name_id = "menu_player_steelsight_when_downed", upgrade = {category = "player", upgrade = "steelsight_when_downed", value = 1}}
  l_5_0.definitions.player_armor_multiplier = {category = "feature", name_id = "menu_player_armor_multiplier", upgrade = {category = "player", upgrade = "armor_multiplier", value = 1}}
  l_5_0.definitions.player_passive_armor_multiplier_1 = {category = "feature", name_id = "menu_player_passive_armor_multiplier", upgrade = {category = "player", upgrade = "passive_armor_multiplier", value = 1}}
  l_5_0.definitions.player_passive_armor_multiplier_2 = {category = "feature", name_id = "menu_player_passive_armor_multiplier", upgrade = {category = "player", upgrade = "passive_armor_multiplier", value = 2}}
  l_5_0.definitions.player_armor_regen_timer_multiplier = {category = "feature", name_id = "menu_player_armor_regen_timer_multiplier", upgrade = {category = "player", upgrade = "armor_regen_timer_multiplier", value = 1}}
  l_5_0.definitions.player_wolverine_health_regen = {category = "temporary", name_id = "menu_player_wolverine_health_regen", upgrade = {category = "temporary", upgrade = "wolverine_health_regen", value = 1}}
  l_5_0.definitions.player_stamina_multiplier = {category = "feature", name_id = "menu_player_stamina_multiplier", upgrade = {category = "player", upgrade = "stamina_multiplier", value = 1}}
  l_5_0.definitions.player_stamina_regen_multiplier = {category = "feature", name_id = "menu_player_stamina_regen_multiplier", upgrade = {category = "player", upgrade = "stamina_regen_multiplier", value = 1}}
  l_5_0.definitions.player_stamina_regen_timer_multiplier = {category = "feature", name_id = "menu_player_stamina_regen_timer_multiplier", upgrade = {category = "player", upgrade = "stamina_regen_timer_multiplier", value = 1}}
  l_5_0.definitions.player_run_speed_multiplier = {category = "feature", name_id = "menu_player_run_speed_multiplier", upgrade = {category = "player", upgrade = "run_speed_multiplier", value = 1}}
  l_5_0.definitions.player_passive_dodge_chance_1 = {category = "feature", name_id = "menu_player_run_dodge_chance", upgrade = {category = "player", upgrade = "passive_dodge_chance", value = 1}}
  l_5_0.definitions.player_passive_dodge_chance_2 = {category = "feature", name_id = "menu_player_run_dodge_chance", upgrade = {category = "player", upgrade = "passive_dodge_chance", value = 2}}
  l_5_0.definitions.player_run_dodge_chance = {category = "feature", name_id = "menu_player_run_dodge_chance", upgrade = {category = "player", upgrade = "run_dodge_chance", value = 1}}
  l_5_0.definitions.player_walk_speed_multiplier = {category = "feature", name_id = "menu_player_walk_speed_multiplier", upgrade = {category = "player", upgrade = "walk_speed_multiplier", value = 1}}
  l_5_0.definitions.player_crouch_speed_multiplier = {category = "feature", name_id = "menu_player_crouch_speed_multiplier", upgrade = {category = "player", upgrade = "crouch_speed_multiplier", value = 1}}
  l_5_0.definitions.player_fall_damage_multiplier = {category = "feature", name_id = "menu_player_fall_damage_multiplier", upgrade = {category = "player", upgrade = "fall_damage_multiplier", value = 1}}
  l_5_0.definitions.player_fall_health_damage_multiplier = {category = "feature", name_id = "menu_player_fall_health_damage_multiplier", upgrade = {category = "player", upgrade = "fall_health_damage_multiplier", value = 1}}
  l_5_0.definitions.player_interacting_damage_multiplier = {category = "feature", name_id = "menu_player_interacting_damage_multiplier", upgrade = {category = "player", upgrade = "interacting_damage_multiplier", value = 1}}
  l_5_0.definitions.player_damage_health_ratio_multiplier = {category = "feature", name_id = "menu_player_damage_health_ratio_multiplier", upgrade = {category = "player", upgrade = "damage_health_ratio_multiplier", value = 1}}
  l_5_0.definitions.player_melee_damage_health_ratio_multiplier = {category = "feature", name_id = "menu_player_melee_damage_health_ratio_multiplier", upgrade = {category = "player", upgrade = "melee_damage_health_ratio_multiplier", value = 1}}
  l_5_0.definitions.player_melee_damage_multiplier = {category = "feature", name_id = "menu_player_melee_damage_multiplier", upgrade = {category = "player", upgrade = "melee_damage_multiplier", value = 1}}
  l_5_0.definitions.player_respawn_time_multiplier = {category = "feature", name_id = "menu_player_respawn_time_multiplier", upgrade = {category = "player", upgrade = "respawn_time_multiplier", value = 1}}
  l_5_0.definitions.passive_player_xp_multiplier = {category = "feature", name_id = "menu_player_xp_multiplier", upgrade = {category = "player", upgrade = "passive_xp_multiplier", value = 1}}
  l_5_0.definitions.player_xp_multiplier = {category = "feature", name_id = "menu_player_xp_multiplier", upgrade = {category = "player", upgrade = "xp_multiplier", value = 1}}
  l_5_0.definitions.player_non_special_melee_multiplier = {category = "feature", name_id = "menu_player_non_special_melee_multiplier", upgrade = {category = "player", upgrade = "non_special_melee_multiplier", value = 1}}
  l_5_0.definitions.player_passive_suspicion_bonus = {category = "feature", name_id = "menu_player_passive_suspicion_bonus", upgrade = {category = "player", upgrade = "passive_suspicion_multiplier", value = 1}}
  l_5_0.definitions.player_suspicion_bonus = {category = "feature", name_id = "menu_player_suspicion_bonus", upgrade = {category = "player", upgrade = "suspicion_multiplier", value = 1}}
  l_5_0.definitions.player_uncover_progress_mul = {category = "feature", name_id = "player_uncover_progress_mul", upgrade = {category = "player", upgrade = "uncover_progress_mul", value = 1}}
  l_5_0.definitions.player_uncover_progress_decay_mul = {category = "feature", name_id = "menu_player_uncover_progress_decay_mul", upgrade = {category = "player", upgrade = "uncover_progress_decay_mul", value = 1}}
  l_5_0.definitions.player_camouflage_bonus = {category = "feature", name_id = "menu_player_camouflage_bonus", upgrade = {category = "player", upgrade = "camouflage_bonus", value = 1}}
  l_5_0.definitions.player_suppressed_bonus = {category = "feature", name_id = "menu_player_suppressed_bonus", upgrade = {category = "player", upgrade = "suppressed_multiplier", value = 1}}
  l_5_0.definitions.player_passive_suppression_bonus_1 = {category = "feature", name_id = "menu_player_suppression_bonus", upgrade = {category = "player", upgrade = "passive_suppression_multiplier", value = 1}}
  l_5_0.definitions.player_passive_suppression_bonus_2 = {category = "feature", name_id = "menu_player_suppression_bonus", upgrade = {category = "player", upgrade = "passive_suppression_multiplier", value = 2}}
  l_5_0.definitions.player_suppression_bonus = {category = "feature", name_id = "menu_player_suppression_bonus", upgrade = {category = "player", upgrade = "suppression_multiplier", value = 1}}
  l_5_0.definitions.player_civilian_reviver = {category = "feature", name_id = "menu_player_civilian_reviver", upgrade = {category = "player", upgrade = "civilian_reviver", value = 1}}
  l_5_0.definitions.player_overkill_damage_multiplier = {category = "temporary", name_id = "menu_player_overkill_damage_multiplier", upgrade = {category = "temporary", upgrade = "overkill_damage_multiplier", value = 1}}
  l_5_0.definitions.player_overkill_all_weapons = {category = "feature", name_id = "menu_player_overkill_all_weapons", upgrade = {category = "player", upgrade = "overkill_all_weapons", value = 1}}
  l_5_0.definitions.player_damage_multiplier_outnumbered = {category = "temporary", name_id = "menu_player_dmg_mul_outnumbered", upgrade = {category = "temporary", upgrade = "dmg_multiplier_outnumbered", value = 1}}
  l_5_0.definitions.player_damage_dampener_outnumbered = {category = "temporary", name_id = "menu_player_dmg_damp_outnumbered", upgrade = {category = "temporary", upgrade = "dmg_dampener_outnumbered", value = 1}}
  l_5_0.definitions.player_corpse_alarm_pager_bluff = {category = "feature", name_id = "menu_player_pager_dis", upgrade = {category = "player", upgrade = "corpse_alarm_pager_bluff", value = 1}}
  l_5_0.definitions.player_corpse_dispose = {category = "feature", name_id = "menu_player_corpse_disp", upgrade = {category = "player", upgrade = "corpse_dispose", value = 1}}
  l_5_0.definitions.player_taser_malfunction = {category = "feature", name_id = "menu_player_taser_malf", upgrade = {category = "player", upgrade = "taser_malfunction", value = 1}}
  l_5_0.definitions.player_taser_self_shock = {category = "feature", name_id = "menu_player_taser_shock", upgrade = {category = "player", upgrade = "taser_self_shock", value = 1}}
  l_5_0.definitions.player_electrocution_resistance = {category = "feature", name_id = "menu_player_electrocution_resistance", upgrade = {category = "player", upgrade = "electrocution_resistance_multiplier", value = 1}}
  l_5_0.definitions.player_silent_kill = {category = "feature", name_id = "menu_player_silent_kill", upgrade = {category = "player", upgrade = "silent_kill", value = 1}}
  l_5_0.definitions.player_melee_knockdown_mul = {category = "feature", name_id = "menu_player_melee_knockdown_mul", upgrade = {category = "player", upgrade = "melee_knockdown_mul", value = 1}}
  l_5_0.definitions.player_suppression_mul_2 = {category = "feature", name_id = "menu_player_suppression_mul_2", upgrade = {category = "player", upgrade = "suppression_multiplier", value = 2}}
  l_5_0.definitions.player_damage_dampener = {category = "feature", name_id = "menu_player_damage_dampener", upgrade = {category = "player", upgrade = "damage_dampener", value = 1}}
  l_5_0.definitions.player_marked_enemy_extra_damage = {category = "feature", name_id = "menu_player_marked_enemy_extra_damage", upgrade = {category = "player", upgrade = "marked_enemy_extra_damage", value = 1}}
  l_5_0.definitions.player_civ_intimidation_mul = {category = "feature", name_id = "menu_player_civ_intimidation_mul", upgrade = {category = "player", upgrade = "civ_intimidation_mul", value = 1}}
  l_5_0.definitions.player_civ_harmless_bullets = {category = "feature", name_id = "menu_player_civ_harmless_bullets", upgrade = {category = "player", upgrade = "civ_harmless_bullets", value = 1}}
  l_5_0.definitions.player_civ_harmless_melee = {category = "feature", name_id = "menu_player_civ_harmless_melee", upgrade = {category = "player", upgrade = "civ_harmless_melee", value = 1}}
  l_5_0.definitions.player_civ_calming_alerts = {category = "feature", name_id = "menu_player_civ_calming_alerts", upgrade = {category = "player", upgrade = "civ_calming_alerts", value = 1}}
  l_5_0.definitions.player_special_enemy_highlight = {category = "feature", name_id = "menu_player_special_enemy_highlight", upgrade = {category = "player", upgrade = "special_enemy_highlight", value = 1}}
  l_5_0.definitions.player_drill_alert = {category = "feature", name_id = "menu_player_drill_alert", upgrade = {category = "player", upgrade = "drill_alert_rad", value = 1}}
  l_5_0.definitions.player_silent_drill = {category = "feature", name_id = "menu_player_silent_drill", upgrade = {category = "player", upgrade = "silent_drill", value = 1}}
  l_5_0.definitions.player_drill_speed_multiplier1 = {category = "feature", name_id = "menu_player_drill_speed_multiplier", upgrade = {category = "player", upgrade = "drill_speed_multiplier", value = 1}}
  l_5_0.definitions.player_drill_speed_multiplier2 = {category = "feature", name_id = "menu_player_drill_speed_multiplier", upgrade = {category = "player", upgrade = "drill_speed_multiplier", value = 2}}
  l_5_0.definitions.player_saw_speed_multiplier_1 = {category = "feature", name_id = "menu_player_saw_speed_multiplier", upgrade = {category = "player", upgrade = "saw_speed_multiplier", value = 1}}
  l_5_0.definitions.player_saw_speed_multiplier_2 = {category = "feature", name_id = "menu_player_saw_speed_multiplier", upgrade = {category = "player", upgrade = "saw_speed_multiplier", value = 2}}
  l_5_0.definitions.player_drill_fix_interaction_speed_multiplier = {category = "feature", name_id = "menu_player_drill_fix_interaction_speed_multiplier", upgrade = {category = "player", upgrade = "drill_fix_interaction_speed_multiplier", value = 1}}
  l_5_0.definitions.player_dye_pack_chance_multiplier = {category = "feature", name_id = "menu_player_dye_pack_chance_multiplier", upgrade = {category = "player", upgrade = "dye_pack_chance_multiplier", value = 1}}
  l_5_0.definitions.player_dye_pack_cash_loss_multiplier = {category = "feature", name_id = "menu_player_dye_pack_cash_loss_multiplier", upgrade = {category = "player", upgrade = "dye_pack_cash_loss_multiplier", value = 1}}
  l_5_0.definitions.player_cheat_death_chance = {category = "feature", name_id = "menu_player_cheat_death_chance", upgrade = {category = "player", upgrade = "cheat_death_chance", value = 1}}
  l_5_0.definitions.player_additional_lives_1 = {category = "feature", name_id = "menu_player_additional_lives_1", upgrade = {category = "player", upgrade = "additional_lives", value = 1}}
  l_5_0.definitions.player_additional_lives_2 = {category = "feature", name_id = "menu_player_additional_lives_2", upgrade = {category = "player", upgrade = "additional_lives", value = 2}}
  l_5_0.definitions.player_trip_mine_shaped_charge = {category = "feature", name_id = "menu_player_trip_mine_shaped_charge", upgrade = {category = "player", upgrade = "trip_mine_shaped_charge", value = 1}}
  l_5_0.definitions.player_small_loot_multiplier1 = {category = "feature", name_id = "menu_player_small_loot_multiplier", upgrade = {category = "player", upgrade = "small_loot_multiplier", value = 1}}
  l_5_0.definitions.player_small_loot_multiplier2 = {category = "feature", name_id = "menu_player_small_loot_multiplier", upgrade = {category = "player", upgrade = "small_loot_multiplier", value = 2}}
  l_5_0.definitions.player_intimidate_enemies = {category = "feature", name_id = "menu_player_intimidate_enemies", upgrade = {category = "player", upgrade = "intimidate_enemies", value = 1}}
  l_5_0.definitions.player_intimidate_specials = {category = "feature", name_id = "menu_player_intimidate_specials", upgrade = {category = "player", upgrade = "intimidate_specials", value = 1}}
  l_5_0.definitions.player_passive_empowered_intimidation = {category = "feature", name_id = "menu_player_passive_empowered_intimidation", upgrade = {category = "player", upgrade = "empowered_intimidation_mul", value = 1}}
  l_5_0.definitions.player_intimidation_multiplier = {category = "feature", name_id = "menu_player_intimidation_multiplier", upgrade = {category = "player", upgrade = "intimidation_multiplier", value = 1}}
  l_5_0.definitions.player_sentry_gun_deploy_time_multiplier = {category = "feature", name_id = "menu_player_sentry_gun_deploy_time_multiplier", upgrade = {category = "player", upgrade = "sentry_gun_deploy_time_multiplier", value = 1}}
  l_5_0.definitions.player_trip_mine_deploy_time_multiplier = {category = "feature", incremental = true, name_id = "menu_player_trip_mine_deploy_time_multiplier", upgrade = {category = "player", upgrade = "trip_mine_deploy_time_multiplier", value = 1}}
  l_5_0.definitions.player_trip_mine_deploy_time_multiplier_2 = {category = "feature", incremental = true, name_id = "menu_player_trip_mine_deploy_time_multiplier", upgrade = {category = "player", upgrade = "trip_mine_deploy_time_multiplier", value = 1}}
  l_5_0.definitions.player_convert_enemies = {category = "feature", name_id = "menu_player_convert_enemies", upgrade = {category = "player", upgrade = "convert_enemies", value = 1}}
  l_5_0.definitions.player_convert_enemies_max_minions_1 = {category = "feature", name_id = "menu_player_convert_enemies_max_minions", upgrade = {category = "player", upgrade = "convert_enemies_max_minions", value = 1}}
  l_5_0.definitions.player_convert_enemies_max_minions_2 = {category = "feature", name_id = "menu_player_convert_enemies_max_minions", upgrade = {category = "player", upgrade = "convert_enemies_max_minions", value = 2}}
  l_5_0.definitions.player_convert_enemies_interaction_speed_multiplier = {category = "feature", name_id = "menu_player_convert_enemies_interaction_speed_multiplier", upgrade = {category = "player", upgrade = "convert_enemies_interaction_speed_multiplier", value = 1}}
  l_5_0.definitions.player_convert_enemies_health_multiplier = {category = "feature", name_id = "menu_player_convert_enemies_health_multiplier", upgrade = {category = "player", upgrade = "convert_enemies_health_multiplier", value = 1}}
  l_5_0.definitions.player_passive_convert_enemies_health_multiplier = {category = "feature", name_id = "menu_player_passive_convert_enemies_health_multiplier", upgrade = {category = "player", upgrade = "passive_convert_enemies_health_multiplier", value = 1}}
  l_5_0.definitions.player_convert_enemies_damage_multiplier = {category = "feature", name_id = "menu_player_convert_enemies_damage_multiplier", upgrade = {category = "player", upgrade = "convert_enemies_damage_multiplier", value = 1}}
  l_5_0.definitions.player_passive_convert_enemies_damage_multiplier = {category = "feature", name_id = "menu_player_passive_convert_enemies_damage_multiplier", upgrade = {category = "player", upgrade = "passive_convert_enemies_damage_multiplier", value = 1}}
  l_5_0.definitions.player_passive_intimidate_range_mul = {category = "feature", name_id = "menu_player_intimidate_range_mul", upgrade = {category = "player", upgrade = "passive_intimidate_range_mul", value = 1}}
  l_5_0.definitions.player_intimidate_range_mul = {category = "feature", name_id = "menu_player_intimidate_range_mul", upgrade = {category = "player", upgrade = "intimidate_range_mul", value = 1}}
  l_5_0.definitions.player_intimidate_aura = {category = "feature", name_id = "menu_player_intimidate_aura", upgrade = {category = "player", upgrade = "intimidate_aura", value = 1}}
  l_5_0.definitions.player_civilian_gives_ammo = {category = "feature", name_id = "menu_player_civilian_gives_ammo", upgrade = {category = "player", upgrade = "civilian_gives_ammo", value = 1}}
  l_5_0.definitions.player_drill_autorepair = {category = "feature", name_id = "menu_player_drill_autorepair", upgrade = {category = "player", upgrade = "drill_autorepair", value = 1}}
  l_5_0.definitions.player_hostage_trade = {category = "feature", name_id = "menu_player_hostage_trade", upgrade = {category = "player", upgrade = "hostage_trade", value = 1}}
  l_5_0.definitions.player_sec_camera_highlight = {category = "feature", name_id = "menu_player_sec_camera_highlight", upgrade = {category = "player", upgrade = "sec_camera_highlight", value = 1}}
  l_5_0.definitions.player_morale_boost = {category = "feature", name_id = "menu_player_morale_boost", upgrade = {category = "player", upgrade = "morale_boost", value = 1}}
  l_5_0.definitions.player_long_dis_revive = {category = "feature", name_id = "menu_player_long_dis_revive", upgrade = {category = "player", upgrade = "long_dis_revive", value = 1}}
  l_5_0.definitions.player_pick_lock_easy = {category = "feature", name_id = "menu_player_pick_lock_easy", upgrade = {category = "player", upgrade = "pick_lock_easy", value = 1}}
  l_5_0.definitions.player_pick_lock_hard = {category = "feature", name_id = "menu_player_pick_lock_hard", upgrade = {category = "player", upgrade = "pick_lock_hard", value = 1}}
  l_5_0.definitions.player_pick_lock_easy_speed_multiplier = {category = "feature", name_id = "menu_player_pick_lock_easy_speed_multiplier", upgrade = {category = "player", upgrade = "pick_lock_easy_speed_multiplier", value = 1}}
  l_5_0.definitions.player_loot_drop_multiplier_1 = {category = "feature", name_id = "menu_player_loot_drop_multiplier", upgrade = {category = "player", upgrade = "loot_drop_multiplier", value = 1}}
  l_5_0.definitions.player_loot_drop_multiplier_2 = {category = "feature", name_id = "menu_player_loot_drop_multiplier", upgrade = {category = "player", upgrade = "loot_drop_multiplier", value = 2}}
  l_5_0.definitions.player_passive_loot_drop_multiplier = {category = "feature", name_id = "menu_player_passive_loot_drop_multiplier", upgrade = {category = "player", upgrade = "passive_loot_drop_multiplier", value = 1}}
  l_5_0.definitions.player_buy_cost_multiplier_1 = {category = "feature", name_id = "menu_player_buy_cost_multiplier", upgrade = {category = "player", upgrade = "buy_cost_multiplier", value = 1}}
  l_5_0.definitions.player_buy_cost_multiplier_2 = {category = "feature", name_id = "menu_player_buy_cost_multiplier", upgrade = {category = "player", upgrade = "buy_cost_multiplier", value = 2}}
  l_5_0.definitions.player_crime_net_deal = {category = "feature", name_id = "menu_player_crime_net_deal", upgrade = {category = "player", upgrade = "crime_net_deal", value = 1}}
  l_5_0.definitions.player_crime_net_deal_2 = {category = "feature", name_id = "menu_player_crime_net_deal", upgrade = {category = "player", upgrade = "crime_net_deal", value = 2}}
  l_5_0.definitions.player_sell_cost_multiplier_1 = {category = "feature", name_id = "menu_player_sell_cost_multiplier", upgrade = {category = "player", upgrade = "sell_cost_multiplier", value = 1}}
  l_5_0.definitions.player_crafting_weapon_multiplier = {category = "feature", name_id = "menu_player_crafting_weapon_multiplier", upgrade = {category = "player", upgrade = "crafting_weapon_multiplier", value = 1}}
  l_5_0.definitions.player_passive_crafting_weapon_multiplier_1 = {category = "feature", name_id = "menu_player_crafting_weapon_multiplier", upgrade = {category = "player", upgrade = "passive_crafting_weapon_multiplier", value = 1}}
  l_5_0.definitions.player_passive_crafting_weapon_multiplier_2 = {category = "feature", name_id = "menu_player_crafting_weapon_multiplier_2", upgrade = {category = "player", upgrade = "passive_crafting_weapon_multiplier", value = 2}}
  l_5_0.definitions.player_passive_crafting_weapon_multiplier_3 = {category = "feature", name_id = "menu_player_crafting_weapon_multiplier_3", upgrade = {category = "player", upgrade = "passive_crafting_weapon_multiplier", value = 3}}
  l_5_0.definitions.player_crafting_mask_multiplier = {category = "feature", name_id = "menu_player_crafting_mask_multiplier", upgrade = {category = "player", upgrade = "crafting_mask_multiplier", value = 1}}
  l_5_0.definitions.player_passive_crafting_mask_multiplier_1 = {category = "feature", name_id = "menu_player_crafting_mask_multiplier", upgrade = {category = "player", upgrade = "passive_crafting_mask_multiplier", value = 1}}
  l_5_0.definitions.player_passive_crafting_mask_multiplier_2 = {category = "feature", name_id = "menu_player_crafting_mask_multiplier", upgrade = {category = "player", upgrade = "passive_crafting_mask_multiplier", value = 2}}
  l_5_0.definitions.player_passive_crafting_mask_multiplier_3 = {category = "feature", name_id = "menu_player_crafting_mask_multiplier", upgrade = {category = "player", upgrade = "passive_crafting_mask_multiplier", value = 3}}
  l_5_0.definitions.player_additional_assets = {category = "feature", name_id = "menu_player_additional_assets", upgrade = {category = "player", upgrade = "additional_assets", value = 1}}
  l_5_0.definitions.player_assets_cost_multiplier = {category = "feature", name_id = "menu_player_assets_cost_multiplier", upgrade = {category = "player", upgrade = "assets_cost_multiplier", value = 1}}
  l_5_0.definitions.passive_player_assets_cost_multiplier = {category = "feature", name_id = "menu_passive_player_assets_cost_multiplier", upgrade = {category = "player", upgrade = "passive_assets_cost_multiplier", value = 1}}
  l_5_0.definitions.player_revive_health_boost = {category = "feature", name_id = "menu_player_revive_health_boost", upgrade = {category = "player", upgrade = "revive_health_boost", value = 1}}
   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

  l_5_0.definitions.toolset, {tree = 4, step = 1, category = "equipment", equipment_id = "toolset", title_id = "debug_upgrade_player_upgrade", subtitle_id = "debug_upgrade_toolset1", name_id = "debug_upgrade_toolset1", icon = "equipment_toolset", image = "upgrades_toolset", image_slice = "upgrades_toolset_slice", description_text_id = "toolset", unlock_lvl = 0}.slot, {tree = 4, step = 1, category = "equipment", equipment_id = "toolset", title_id = "debug_upgrade_player_upgrade", subtitle_id = "debug_upgrade_toolset1", name_id = "debug_upgrade_toolset1", icon = "equipment_toolset", image = "upgrades_toolset", image_slice = "upgrades_toolset_slice", description_text_id = "toolset", unlock_lvl = 0}.aquire = {tree = 4, step = 1, category = "equipment", equipment_id = "toolset", title_id = "debug_upgrade_player_upgrade", subtitle_id = "debug_upgrade_toolset1", name_id = "debug_upgrade_toolset1", icon = "equipment_toolset", image = "upgrades_toolset", image_slice = "upgrades_toolset_slice", description_text_id = "toolset", unlock_lvl = 0}, 2, {upgrade = "toolset1"}
  for i,_ in ipairs(l_5_0.values.player.toolset) do
    local depends_on = (0 < i - 1 and "toolset" .. i - 1)
    local unlock_lvl = 3
    local prio = (i == 1 and "high")
     -- DECOMPILER ERROR: Confused about usage of registers!

     -- DECOMPILER ERROR: Confused about usage of registers!

    l_5_0.definitions.toolset" .. , {tree = 4, step = l_5_0.steps.player.toolset[i], category = "feature", title_id = "debug_upgrade_player_upgrade", subtitle_id = "debug_upgrade_toolset" .. i, name_id = "debug_upgrade_toolset" .. i, icon = "equipment_toolset", image = "upgrades_toolset", image_slice = "upgrades_toolset_slice", description_text_id = "toolset", depends_on = depends_on, unlock_lvl = unlock_lvl}.upgrade, {tree = 4, step = l_5_0.steps.player.toolset[i], category = "feature", title_id = "debug_upgrade_player_upgrade", subtitle_id = "debug_upgrade_toolset" .. i, name_id = "debug_upgrade_toolset" .. i, icon = "equipment_toolset", image = "upgrades_toolset", image_slice = "upgrades_toolset_slice", description_text_id = "toolset", depends_on = depends_on, unlock_lvl = unlock_lvl}.prio = {tree = 4, step = l_5_0.steps.player.toolset[i], category = "feature", title_id = "debug_upgrade_player_upgrade", subtitle_id = "debug_upgrade_toolset" .. i, name_id = "debug_upgrade_toolset" .. i, icon = "equipment_toolset", image = "upgrades_toolset", image_slice = "upgrades_toolset_slice", description_text_id = "toolset", depends_on = depends_on, unlock_lvl = unlock_lvl}, {category = "player", upgrade = "toolset", value = i}, prio
  end
end

UpgradesTweakData._trip_mine_definitions = function(l_6_0)
   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

  l_6_0.definitions.trip_mine, {tree = 2, step = 4, category = "equipment", equipment_id = "trip_mine", name_id = "debug_trip_mine", title_id = "debug_upgrade_new_equipment", subtitle_id = "debug_trip_mine", icon = "equipment_trip_mine", image = "upgrades_tripmines", image_slice = "upgrades_tripmines_slice", description_text_id = "trip_mine", unlock_lvl = 0}.slot, {tree = 2, step = 4, category = "equipment", equipment_id = "trip_mine", name_id = "debug_trip_mine", title_id = "debug_upgrade_new_equipment", subtitle_id = "debug_trip_mine", icon = "equipment_trip_mine", image = "upgrades_tripmines", image_slice = "upgrades_tripmines_slice", description_text_id = "trip_mine", unlock_lvl = 0}.prio = {tree = 2, step = 4, category = "equipment", equipment_id = "trip_mine", name_id = "debug_trip_mine", title_id = "debug_upgrade_new_equipment", subtitle_id = "debug_trip_mine", icon = "equipment_trip_mine", image = "upgrades_tripmines", image_slice = "upgrades_tripmines_slice", description_text_id = "trip_mine", unlock_lvl = 0}, 1, "high"
  l_6_0.definitions.trip_mine_can_switch_on_off = {category = "feature", name_id = "menu_trip_mine_can_switch_on_off", upgrade = {category = "trip_mine", upgrade = "can_switch_on_off", value = 1}}
  l_6_0.definitions.trip_mine_sensor_toggle = {category = "feature", name_id = "menu_trip_mine_sensor_toggle", upgrade = {category = "trip_mine", upgrade = "sensor_toggle", value = 1}}
  l_6_0.definitions.trip_mine_quantity_increase_1 = {category = "feature", name_id = "menu_trip_mine_quantity_increase_1", upgrade = {category = "trip_mine", upgrade = "quantity_1", value = 1}}
  l_6_0.definitions.trip_mine_quantity_increase_2 = {category = "feature", name_id = "menu_trip_mine_quantity_increase_1", upgrade = {category = "trip_mine", upgrade = "quantity_2", value = 1}}
  l_6_0.definitions.trip_mine_quantity_increase_3 = {category = "feature", name_id = "menu_trip_mine_quantity_increase_1", upgrade = {category = "trip_mine", upgrade = "quantity_3", value = 1}}
  l_6_0.definitions.trip_mine_explosion_size_multiplier_1 = {category = "feature", incremental = true, name_id = "menu_trip_mine_explosion_size_multiplier", upgrade = {category = "trip_mine", upgrade = "explosion_size_multiplier", value = 1}}
  l_6_0.definitions.trip_mine_explosion_size_multiplier_2 = {category = "feature", incremental = true, name_id = "menu_trip_mine_explosion_size_multiplier", upgrade = {category = "trip_mine", upgrade = "explosion_size_multiplier", value = 2}}
  l_6_0.definitions.trip_mine_explode_timer_delay = {category = "feature", incremental = true, name_id = "menu_trip_mine_explode_timer_delay", upgrade = {category = "trip_mine", upgrade = "explode_timer_delay", value = 1}}
end

UpgradesTweakData._ecm_jammer_definitions = function(l_7_0)
  l_7_0.definitions.ecm_jammer = {category = "equipment", equipment_id = "ecm_jammer", name_id = "menu_equipment_ecm_jammer", slot = 1}
  l_7_0.definitions.ecm_jammer_can_activate_feedback = {category = "feature", name_id = "menu_ecm_jammer_can_activate_feedback", upgrade = {category = "ecm_jammer", upgrade = "can_activate_feedback", value = 1}}
  l_7_0.definitions.ecm_jammer_can_open_sec_doors = {category = "feature", name_id = "menu_ecm_jammer_can_open_sec_doors", upgrade = {category = "ecm_jammer", upgrade = "can_open_sec_doors", value = 1}}
  l_7_0.definitions.ecm_jammer_quantity_increase_1 = {category = "equipment_upgrade", name_id = "menu_ecm_jammer_quantity_1", upgrade = {category = "ecm_jammer", upgrade = "quantity", value = 1}}
  l_7_0.definitions.ecm_jammer_quantity_increase_2 = {category = "equipment_upgrade", name_id = "menu_ecm_jammer_quantity_2", upgrade = {category = "ecm_jammer", upgrade = "quantity", value = 2}}
  l_7_0.definitions.ecm_jammer_duration_multiplier = {category = "equipment_upgrade", name_id = "menu_ecm_jammer_duration_multiplier", upgrade = {category = "ecm_jammer", upgrade = "duration_multiplier", value = 1}}
  l_7_0.definitions.ecm_jammer_duration_multiplier_2 = {category = "equipment_upgrade", name_id = "menu_ecm_jammer_duration_multiplier", upgrade = {category = "ecm_jammer", upgrade = "duration_multiplier_2", value = 1}}
  l_7_0.definitions.ecm_jammer_affects_cameras = {category = "equipment_upgrade", name_id = "menu_ecm_jammer_affects_cameras", upgrade = {category = "ecm_jammer", upgrade = "affects_cameras", value = 1}}
  l_7_0.definitions.ecm_jammer_feedback_duration_boost = {category = "equipment_upgrade", name_id = "menu_ecm_jammer_feedback_duration_boost", upgrade = {category = "ecm_jammer", upgrade = "feedback_duration_boost", value = 1}}
  l_7_0.definitions.ecm_jammer_feedback_duration_boost_2 = {category = "equipment_upgrade", name_id = "menu_ecm_jammer_feedback_duration_boost_2", upgrade = {category = "ecm_jammer", upgrade = "feedback_duration_boost_2", value = 1}}
end

UpgradesTweakData._ammo_bag_definitions = function(l_8_0)
   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

  l_8_0.definitions.ammo_bag, {tree = 1, step = 2, category = "equipment", equipment_id = "ammo_bag", name_id = "debug_ammo_bag", title_id = "debug_upgrade_new_equipment", subtitle_id = "debug_ammo_bag", icon = "equipment_ammo_bag", image = "upgrades_ammobag", image_slice = "upgrades_ammobag_slice", description_text_id = "ammo_bag", unlock_lvl = 0}.slot, {tree = 1, step = 2, category = "equipment", equipment_id = "ammo_bag", name_id = "debug_ammo_bag", title_id = "debug_upgrade_new_equipment", subtitle_id = "debug_ammo_bag", icon = "equipment_ammo_bag", image = "upgrades_ammobag", image_slice = "upgrades_ammobag_slice", description_text_id = "ammo_bag", unlock_lvl = 0}.prio = {tree = 1, step = 2, category = "equipment", equipment_id = "ammo_bag", name_id = "debug_ammo_bag", title_id = "debug_upgrade_new_equipment", subtitle_id = "debug_ammo_bag", icon = "equipment_ammo_bag", image = "upgrades_ammobag", image_slice = "upgrades_ammobag_slice", description_text_id = "ammo_bag", unlock_lvl = 0}, 1, "high"
  for i,_ in ipairs(l_8_0.values.ammo_bag.ammo_increase) do
    local depends_on = i - 1 > 0 and "ammo_bag_ammo_increase" .. i - 1 or "ammo_bag"
    local unlock_lvl = 11
    local prio = (i == 1 and "high")
     -- DECOMPILER ERROR: Confused about usage of registers!

     -- DECOMPILER ERROR: Confused about usage of registers!

    l_8_0.definitions.ammo_bag_ammo_increase" .. , {tree = 1, step = l_8_0.steps.ammo_bag.ammo_increase[i], category = "equipment_upgrade", name_id = "debug_upgrade_ammo_bag_ammo_increase" .. i, title_id = "debug_ammo_bag", subtitle_id = "debug_upgrade_amount_increase" .. i, icon = "equipment_ammo_bag", image = "upgrades_ammobag", image_slice = "upgrades_ammobag_slice", description_text_id = "ammo_bag_increase", depends_on = depends_on, unlock_lvl = unlock_lvl}.upgrade, {tree = 1, step = l_8_0.steps.ammo_bag.ammo_increase[i], category = "equipment_upgrade", name_id = "debug_upgrade_ammo_bag_ammo_increase" .. i, title_id = "debug_ammo_bag", subtitle_id = "debug_upgrade_amount_increase" .. i, icon = "equipment_ammo_bag", image = "upgrades_ammobag", image_slice = "upgrades_ammobag_slice", description_text_id = "ammo_bag_increase", depends_on = depends_on, unlock_lvl = unlock_lvl}.prio = {tree = 1, step = l_8_0.steps.ammo_bag.ammo_increase[i], category = "equipment_upgrade", name_id = "debug_upgrade_ammo_bag_ammo_increase" .. i, title_id = "debug_ammo_bag", subtitle_id = "debug_upgrade_amount_increase" .. i, icon = "equipment_ammo_bag", image = "upgrades_ammobag", image_slice = "upgrades_ammobag_slice", description_text_id = "ammo_bag_increase", depends_on = depends_on, unlock_lvl = unlock_lvl}, {category = "ammo_bag", upgrade = "ammo_increase", value = i}, prio
  end
  l_8_0.definitions.ammo_bag_quantity = {category = "equipment_upgrade", name_id = "menu_ammo_bag_quantity", upgrade = {category = "ammo_bag", upgrade = "quantity", value = 1}}
end

UpgradesTweakData._doctor_bag_definitions = function(l_9_0)
   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

  l_9_0.definitions.doctor_bag, {tree = 3, step = 5, category = "equipment", equipment_id = "doctor_bag", name_id = "debug_doctor_bag", title_id = "debug_upgrade_new_equipment", subtitle_id = "debug_doctor_bag", icon = "equipment_doctor_bag", image = "upgrades_doctorbag", image_slice = "upgrades_doctorbag_slice", description_text_id = "doctor_bag", unlock_lvl = 2}.slot, {tree = 3, step = 5, category = "equipment", equipment_id = "doctor_bag", name_id = "debug_doctor_bag", title_id = "debug_upgrade_new_equipment", subtitle_id = "debug_doctor_bag", icon = "equipment_doctor_bag", image = "upgrades_doctorbag", image_slice = "upgrades_doctorbag_slice", description_text_id = "doctor_bag", unlock_lvl = 2}.prio = {tree = 3, step = 5, category = "equipment", equipment_id = "doctor_bag", name_id = "debug_doctor_bag", title_id = "debug_upgrade_new_equipment", subtitle_id = "debug_doctor_bag", icon = "equipment_doctor_bag", image = "upgrades_doctorbag", image_slice = "upgrades_doctorbag_slice", description_text_id = "doctor_bag", unlock_lvl = 2}, 1, "high"
  for i,_ in ipairs(l_9_0.values.doctor_bag.amount_increase) do
    local depends_on = i - 1 > 0 and "doctor_bag_amount_increase" .. i - 1 or "doctor_bag"
    local unlock_lvl = 3
    local prio = (i == 1 and "high")
     -- DECOMPILER ERROR: Confused about usage of registers!

     -- DECOMPILER ERROR: Confused about usage of registers!

    l_9_0.definitions.doctor_bag_amount_increase" .. , {tree = 3, step = l_9_0.steps.doctor_bag.amount_increase[i], category = "equipment_upgrade", name_id = "debug_upgrade_doctor_bag_amount_increase" .. i, title_id = "debug_doctor_bag", subtitle_id = "debug_upgrade_amount_increase" .. i, icon = "equipment_doctor_bag", image = "upgrades_doctorbag", image_slice = "upgrades_doctorbag_slice", description_text_id = "doctor_bag_increase", depends_on = depends_on, unlock_lvl = unlock_lvl}.upgrade, {tree = 3, step = l_9_0.steps.doctor_bag.amount_increase[i], category = "equipment_upgrade", name_id = "debug_upgrade_doctor_bag_amount_increase" .. i, title_id = "debug_doctor_bag", subtitle_id = "debug_upgrade_amount_increase" .. i, icon = "equipment_doctor_bag", image = "upgrades_doctorbag", image_slice = "upgrades_doctorbag_slice", description_text_id = "doctor_bag_increase", depends_on = depends_on, unlock_lvl = unlock_lvl}.prio = {tree = 3, step = l_9_0.steps.doctor_bag.amount_increase[i], category = "equipment_upgrade", name_id = "debug_upgrade_doctor_bag_amount_increase" .. i, title_id = "debug_doctor_bag", subtitle_id = "debug_upgrade_amount_increase" .. i, icon = "equipment_doctor_bag", image = "upgrades_doctorbag", image_slice = "upgrades_doctorbag_slice", description_text_id = "doctor_bag_increase", depends_on = depends_on, unlock_lvl = unlock_lvl}, {category = "doctor_bag", upgrade = "amount_increase", value = i}, prio
  end
  l_9_0.definitions.doctor_bag_quantity = {category = "equipment_upgrade", name_id = "menu_doctor_bag_quantity", upgrade = {category = "doctor_bag", upgrade = "quantity", value = 1}}
  l_9_0.definitions.passive_doctor_bag_interaction_speed_multiplier = {category = "feature", name_id = "menu_passive_doctor_bag_interaction_speed_multiplier", upgrade = {category = "doctor_bag", upgrade = "interaction_speed_multiplier", value = 1}}
end

UpgradesTweakData._cable_tie_definitions = function(l_10_0)
   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

  l_10_0.definitions.cable_tie, {category = "equipment", equipment_id = "cable_tie"}.prio, {category = "equipment", equipment_id = "cable_tie"}.unlock_lvl, {category = "equipment", equipment_id = "cable_tie"}.image_slice, {category = "equipment", equipment_id = "cable_tie"}.image, {category = "equipment", equipment_id = "cable_tie"}.icon, {category = "equipment", equipment_id = "cable_tie"}.title_id, {category = "equipment", equipment_id = "cable_tie"}.name_id = {category = "equipment", equipment_id = "cable_tie"}, "high", 0, "upgrades_extracableties_slice", "upgrades_extracableties", "equipment_cable_ties", "debug_equipment_cable_tie", "debug_equipment_cable_tie"
   -- DECOMPILER ERROR: Confused about usage of registers!

  l_10_0.definitions.extra_cable_tie, {tree = 1, step = 4, category = "equipment", equipment_id = "extra_cable_tie", name_id = "debug_upgrade_extra_cable_tie_quantity1", title_id = "debug_equipment_cable_tie", subtitle_id = "debug_upgrade_amount_increase1", icon = "equipment_extra_cable_ties", image = "upgrades_extracableties", image_slice = "upgrades_extracableties_slice", description_text_id = "extra_cable_tie", unlock_lvl = 3, prio = "high", aquire = {upgrade = "extra_cable_tie_quantity1"}}.slot = {tree = 1, step = 4, category = "equipment", equipment_id = "extra_cable_tie", name_id = "debug_upgrade_extra_cable_tie_quantity1", title_id = "debug_equipment_cable_tie", subtitle_id = "debug_upgrade_amount_increase1", icon = "equipment_extra_cable_ties", image = "upgrades_extracableties", image_slice = "upgrades_extracableties_slice", description_text_id = "extra_cable_tie", unlock_lvl = 3, prio = "high", aquire = {upgrade = "extra_cable_tie_quantity1"}}, 2
  for i,_ in ipairs(l_10_0.values.extra_cable_tie.quantity) do
    local depends_on = i - 1 > 0 and "extra_cable_tie_quantity" .. i - 1 or "extra_cable_tie"
    local unlock_lvl = 4
    local prio = (i == 1 and "high")
     -- DECOMPILER ERROR: Confused about usage of registers!

     -- DECOMPILER ERROR: Confused about usage of registers!

    l_10_0.definitions.extra_cable_tie_quantity" .. , {tree = 1, step = l_10_0.steps.extra_cable_tie.quantity[i], category = "equipment_upgrade", name_id = "debug_upgrade_extra_cable_tie_quantity" .. i, title_id = "debug_equipment_cable_tie", subtitle_id = "debug_upgrade_amount_increase" .. i, icon = "equipment_extra_cable_ties", image = "upgrades_extracableties", image_slice = "upgrades_extracableties_slice", description_text_id = "extra_cable_tie", depends_on = depends_on, unlock_lvl = unlock_lvl}.upgrade, {tree = 1, step = l_10_0.steps.extra_cable_tie.quantity[i], category = "equipment_upgrade", name_id = "debug_upgrade_extra_cable_tie_quantity" .. i, title_id = "debug_equipment_cable_tie", subtitle_id = "debug_upgrade_amount_increase" .. i, icon = "equipment_extra_cable_ties", image = "upgrades_extracableties", image_slice = "upgrades_extracableties_slice", description_text_id = "extra_cable_tie", depends_on = depends_on, unlock_lvl = unlock_lvl}.prio = {tree = 1, step = l_10_0.steps.extra_cable_tie.quantity[i], category = "equipment_upgrade", name_id = "debug_upgrade_extra_cable_tie_quantity" .. i, title_id = "debug_equipment_cable_tie", subtitle_id = "debug_upgrade_amount_increase" .. i, icon = "equipment_extra_cable_ties", image = "upgrades_extracableties", image_slice = "upgrades_extracableties_slice", description_text_id = "extra_cable_tie", depends_on = depends_on, unlock_lvl = unlock_lvl}, {category = "extra_cable_tie", upgrade = "quantity", value = i}, prio
  end
  l_10_0.definitions.cable_tie_quantity = {category = "equipment_upgrade", name_id = "menu_cable_tie_quantity", upgrade = {category = "cable_tie", upgrade = "quantity", value = 1}}
  l_10_0.definitions.cable_tie_interact_speed_multiplier = {category = "equipment_upgrade", name_id = "menu_cable_tie_interact_speed_multiplier", upgrade = {category = "cable_tie", upgrade = "interact_speed_multiplier", value = 1}}
  l_10_0.definitions.cable_tie_can_cable_tie_doors = {category = "equipment_upgrade", name_id = "menu_cable_tie_can_cable_tie_doors", upgrade = {category = "cable_tie", upgrade = "can_cable_tie_doors", value = 1}}
  l_10_0.definitions.cable_tie_quantity_unlimited = {category = "equipment_upgrade", name_id = "menu_cable_tie_quantity_unlimited", upgrade = {category = "cable_tie", upgrade = "quantity_unlimited", value = 1}}
end

UpgradesTweakData._sentry_gun_definitions = function(l_11_0)
   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

  l_11_0.definitions.sentry_gun, {tree = 4, step = 5, category = "equipment", equipment_id = "sentry_gun", name_id = "debug_sentry_gun", title_id = "debug_upgrade_new_equipment", subtitle_id = "debug_sentry_gun", icon = "equipment_sentry", image = "upgrades_sentry", image_slice = "upgrades_sentry_slice", description_text_id = "sentry_gun", unlock_lvl = 0}.slot, {tree = 4, step = 5, category = "equipment", equipment_id = "sentry_gun", name_id = "debug_sentry_gun", title_id = "debug_upgrade_new_equipment", subtitle_id = "debug_sentry_gun", icon = "equipment_sentry", image = "upgrades_sentry", image_slice = "upgrades_sentry_slice", description_text_id = "sentry_gun", unlock_lvl = 0}.prio = {tree = 4, step = 5, category = "equipment", equipment_id = "sentry_gun", name_id = "debug_sentry_gun", title_id = "debug_upgrade_new_equipment", subtitle_id = "debug_sentry_gun", icon = "equipment_sentry", image = "upgrades_sentry", image_slice = "upgrades_sentry_slice", description_text_id = "sentry_gun", unlock_lvl = 0}, 1, "high"
  l_11_0.definitions.sentry_gun_quantity_increase = {category = "feature", name_id = "menu_sentry_gun_quantity_increase", upgrade = {category = "sentry_gun", upgrade = "quantity", value = 1}}
  l_11_0.definitions.sentry_gun_damage_multiplier = {category = "feature", name_id = "menu_sentry_gun_damage_multiplier", upgrade = {category = "sentry_gun", upgrade = "damage_multiplier", value = 1}}
  l_11_0.definitions.sentry_gun_extra_ammo_multiplier_1 = {category = "feature", incremental = true, name_id = "menu_sentry_gun_extra_ammo_multiplier", upgrade = {category = "sentry_gun", upgrade = "extra_ammo_multiplier", value = 1}}
  l_11_0.definitions.sentry_gun_extra_ammo_multiplier_2 = {category = "feature", incremental = true, name_id = "menu_sentry_gun_extra_ammo_multiplier", upgrade = {category = "sentry_gun", upgrade = "extra_ammo_multiplier", value = 2}}
  l_11_0.definitions.sentry_gun_armor_multiplier = {category = "feature", name_id = "menu_sentry_gun_armor_multiplier", upgrade = {category = "sentry_gun", upgrade = "armor_multiplier", value = 1}}
  l_11_0.definitions.sentry_gun_spread_multiplier = {category = "feature", name_id = "menu_sentry_gun_spread_multiplier", upgrade = {category = "sentry_gun", upgrade = "spread_multiplier", value = 1}}
  l_11_0.definitions.sentry_gun_rot_speed_multiplier = {category = "feature", name_id = "menu_sentry_gun_rot_speed_multiplier", upgrade = {category = "sentry_gun", upgrade = "rot_speed_multiplier", value = 1}}
  l_11_0.definitions.sentry_gun_shield = {category = "feature", name_id = "menu_sentry_gun_shield", upgrade = {category = "sentry_gun", upgrade = "shield", value = 1}}
end

UpgradesTweakData._rep_definitions = function(l_12_0)
  local rep_upgrades = l_12_0.values.rep_upgrades
  for index,rep_class in ipairs(rep_upgrades.classes) do
    for i = 1, 10 do
      l_12_0.definitions[rep_class .. i] = {category = "rep_upgrade", value = rep_upgrades.values[index]}
    end
  end
end

UpgradesTweakData._c45_definitions = function(l_13_0)
   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

  l_13_0.definitions.c45, {tree = 1, step = 13, category = "weapon", unit_name = Idstring("units/weapons/c45/c45"), name_id = "debug_c45", title_id = "debug_upgrade_new_weapon", subtitle_id = "debug_c45_short", icon = "c45", image = "upgrades_45", image_slice = "upgrades_45_slice"}.description_text_id, {tree = 1, step = 13, category = "weapon", unit_name = Idstring("units/weapons/c45/c45"), name_id = "debug_c45", title_id = "debug_upgrade_new_weapon", subtitle_id = "debug_c45_short", icon = "c45", image = "upgrades_45", image_slice = "upgrades_45_slice"}.prio, {tree = 1, step = 13, category = "weapon", unit_name = Idstring("units/weapons/c45/c45"), name_id = "debug_c45", title_id = "debug_upgrade_new_weapon", subtitle_id = "debug_c45_short", icon = "c45", image = "upgrades_45", image_slice = "upgrades_45_slice"}.unlock_lvl = {tree = 1, step = 13, category = "weapon", unit_name = Idstring("units/weapons/c45/c45"), name_id = "debug_c45", title_id = "debug_upgrade_new_weapon", subtitle_id = "debug_c45_short", icon = "c45", image = "upgrades_45", image_slice = "upgrades_45_slice"}, "des_c45", "high", 30
  for i,_ in ipairs(l_13_0.values.c45.clip_ammo_increase) do
    local depends_on = i - 1 > 0 and "c45_mag" .. i - 1 or "c45"
    local unlock_lvl = 31
    local prio = (i == 1 and "high")
     -- DECOMPILER ERROR: Confused about usage of registers!

     -- DECOMPILER ERROR: Confused about usage of registers!

    l_13_0.definitions.c45_mag" .. , {tree = 1, step = l_13_0.steps.c45.clip_ammo_increase[i], category = "feature", name_id = "debug_upgrade_c45_mag" .. i, title_id = "debug_c45_short", subtitle_id = "debug_upgrade_mag" .. i, icon = "c45", image = "upgrades_45", image_slice = "upgrades_45_slice", description_text_id = "clip_ammo_increase", depends_on = depends_on, unlock_lvl = unlock_lvl}.upgrade, {tree = 1, step = l_13_0.steps.c45.clip_ammo_increase[i], category = "feature", name_id = "debug_upgrade_c45_mag" .. i, title_id = "debug_c45_short", subtitle_id = "debug_upgrade_mag" .. i, icon = "c45", image = "upgrades_45", image_slice = "upgrades_45_slice", description_text_id = "clip_ammo_increase", depends_on = depends_on, unlock_lvl = unlock_lvl}.prio = {tree = 1, step = l_13_0.steps.c45.clip_ammo_increase[i], category = "feature", name_id = "debug_upgrade_c45_mag" .. i, title_id = "debug_c45_short", subtitle_id = "debug_upgrade_mag" .. i, icon = "c45", image = "upgrades_45", image_slice = "upgrades_45_slice", description_text_id = "clip_ammo_increase", depends_on = depends_on, unlock_lvl = unlock_lvl}, {category = "c45", upgrade = "clip_ammo_increase", value = i}, prio
  end
  for i,_ in ipairs(l_13_0.values.c45.recoil_multiplier) do
    local depends_on = i - 1 > 0 and "c45_recoil" .. i - 1 or "c45"
    local unlock_lvl = 31
    local prio = (i == 1 and "high")
     -- DECOMPILER ERROR: Confused about usage of registers!

     -- DECOMPILER ERROR: Confused about usage of registers!

    l_13_0.definitions.c45_recoil" .. , {tree = 1, step = l_13_0.steps.c45.recoil_multiplier[i], category = "feature", name_id = "debug_upgrade_c45_recoil" .. i, title_id = "debug_c45_short", subtitle_id = "debug_upgrade_recoil" .. i, icon = "c45", image = "upgrades_45", image_slice = "upgrades_45_slice", description_text_id = "recoil_multiplier", depends_on = depends_on, unlock_lvl = unlock_lvl}.upgrade, {tree = 1, step = l_13_0.steps.c45.recoil_multiplier[i], category = "feature", name_id = "debug_upgrade_c45_recoil" .. i, title_id = "debug_c45_short", subtitle_id = "debug_upgrade_recoil" .. i, icon = "c45", image = "upgrades_45", image_slice = "upgrades_45_slice", description_text_id = "recoil_multiplier", depends_on = depends_on, unlock_lvl = unlock_lvl}.prio = {tree = 1, step = l_13_0.steps.c45.recoil_multiplier[i], category = "feature", name_id = "debug_upgrade_c45_recoil" .. i, title_id = "debug_c45_short", subtitle_id = "debug_upgrade_recoil" .. i, icon = "c45", image = "upgrades_45", image_slice = "upgrades_45_slice", description_text_id = "recoil_multiplier", depends_on = depends_on, unlock_lvl = unlock_lvl}, {category = "c45", upgrade = "recoil_multiplier", value = i}, prio
  end
  for i,_ in ipairs(l_13_0.values.c45.damage_multiplier) do
    local depends_on = i - 1 > 0 and "c45_damage" .. i - 1 or "c45"
    local unlock_lvl = 31
    local prio = (i == 1 and "high")
     -- DECOMPILER ERROR: Confused about usage of registers!

     -- DECOMPILER ERROR: Confused about usage of registers!

    l_13_0.definitions.c45_damage" .. , {tree = 1, step = l_13_0.steps.c45.damage_multiplier[i], category = "feature", name_id = "debug_upgrade_c45_damage" .. i, title_id = "debug_c45_short", subtitle_id = "debug_upgrade_damage" .. i, icon = "c45", image = "upgrades_45", image_slice = "upgrades_45_slice", description_text_id = "damage_multiplier", depends_on = depends_on, unlock_lvl = unlock_lvl}.upgrade, {tree = 1, step = l_13_0.steps.c45.damage_multiplier[i], category = "feature", name_id = "debug_upgrade_c45_damage" .. i, title_id = "debug_c45_short", subtitle_id = "debug_upgrade_damage" .. i, icon = "c45", image = "upgrades_45", image_slice = "upgrades_45_slice", description_text_id = "damage_multiplier", depends_on = depends_on, unlock_lvl = unlock_lvl}.prio = {tree = 1, step = l_13_0.steps.c45.damage_multiplier[i], category = "feature", name_id = "debug_upgrade_c45_damage" .. i, title_id = "debug_c45_short", subtitle_id = "debug_upgrade_damage" .. i, icon = "c45", image = "upgrades_45", image_slice = "upgrades_45_slice", description_text_id = "damage_multiplier", depends_on = depends_on, unlock_lvl = unlock_lvl}, {category = "c45", upgrade = "damage_multiplier", value = i}, prio
  end
end

UpgradesTweakData._beretta92_definitions = function(l_14_0)
   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

  l_14_0.definitions.beretta92, {category = "weapon", weapon_id = "beretta92", unit_name = Idstring("units/weapons/beretta92/beretta92"), name_id = "debug_beretta92", title_id = "debug_upgrade_new_weapon", subtitle_id = "debug_beretta92_short", icon = "beretta92", image = "upgrades_m9sd"}.description_text_id, {category = "weapon", weapon_id = "beretta92", unit_name = Idstring("units/weapons/beretta92/beretta92"), name_id = "debug_beretta92", title_id = "debug_upgrade_new_weapon", subtitle_id = "debug_beretta92_short", icon = "beretta92", image = "upgrades_m9sd"}.prio, {category = "weapon", weapon_id = "beretta92", unit_name = Idstring("units/weapons/beretta92/beretta92"), name_id = "debug_beretta92", title_id = "debug_upgrade_new_weapon", subtitle_id = "debug_beretta92_short", icon = "beretta92", image = "upgrades_m9sd"}.unlock_lvl, {category = "weapon", weapon_id = "beretta92", unit_name = Idstring("units/weapons/beretta92/beretta92"), name_id = "debug_beretta92", title_id = "debug_upgrade_new_weapon", subtitle_id = "debug_beretta92_short", icon = "beretta92", image = "upgrades_m9sd"}.image_slice = {category = "weapon", weapon_id = "beretta92", unit_name = Idstring("units/weapons/beretta92/beretta92"), name_id = "debug_beretta92", title_id = "debug_upgrade_new_weapon", subtitle_id = "debug_beretta92_short", icon = "beretta92", image = "upgrades_m9sd"}, "des_beretta92", "high", 0, "upgrades_m9sd_slice"
  for i,_ in ipairs(l_14_0.values.beretta92.clip_ammo_increase) do
    local depends_on = i - 1 > 0 and "beretta_mag" .. i - 1 or "beretta92"
    local unlock_lvl = 2
    local prio = (i == 1 and "high")
     -- DECOMPILER ERROR: Confused about usage of registers!

     -- DECOMPILER ERROR: Confused about usage of registers!

    l_14_0.definitions.beretta_mag" .. , {tree = 1, step = l_14_0.steps.beretta92.clip_ammo_increase[i], category = "feature", name_id = "debug_upgrade_beretta_mag" .. i, title_id = "debug_beretta92_short", subtitle_id = "debug_upgrade_mag" .. i, icon = "beretta92", image = "upgrades_m9sd", image_slice = "upgrades_m9sd_slice", description_text_id = "clip_ammo_increase", depends_on = depends_on, unlock_lvl = unlock_lvl}.upgrade, {tree = 1, step = l_14_0.steps.beretta92.clip_ammo_increase[i], category = "feature", name_id = "debug_upgrade_beretta_mag" .. i, title_id = "debug_beretta92_short", subtitle_id = "debug_upgrade_mag" .. i, icon = "beretta92", image = "upgrades_m9sd", image_slice = "upgrades_m9sd_slice", description_text_id = "clip_ammo_increase", depends_on = depends_on, unlock_lvl = unlock_lvl}.prio = {tree = 1, step = l_14_0.steps.beretta92.clip_ammo_increase[i], category = "feature", name_id = "debug_upgrade_beretta_mag" .. i, title_id = "debug_beretta92_short", subtitle_id = "debug_upgrade_mag" .. i, icon = "beretta92", image = "upgrades_m9sd", image_slice = "upgrades_m9sd_slice", description_text_id = "clip_ammo_increase", depends_on = depends_on, unlock_lvl = unlock_lvl}, {category = "beretta92", upgrade = "clip_ammo_increase", value = i}, prio
  end
  for i,_ in ipairs(l_14_0.values.beretta92.recoil_multiplier) do
    local depends_on = i - 1 > 0 and "beretta_recoil" .. i - 1 or "beretta92"
    local unlock_lvl = 2
    local prio = (i == 1 and "high")
     -- DECOMPILER ERROR: Confused about usage of registers!

     -- DECOMPILER ERROR: Confused about usage of registers!

    l_14_0.definitions.beretta_recoil" .. , {tree = 2, step = l_14_0.steps.beretta92.recoil_multiplier[i], category = "feature", name_id = "debug_upgrade_beretta_recoil" .. i, title_id = "debug_beretta92_short", subtitle_id = "debug_upgrade_recoil" .. i, icon = "beretta92", image = "upgrades_m9sd", image_slice = "upgrades_m9sd_slice", description_text_id = "recoil_multiplier", depends_on = depends_on, unlock_lvl = unlock_lvl}.upgrade, {tree = 2, step = l_14_0.steps.beretta92.recoil_multiplier[i], category = "feature", name_id = "debug_upgrade_beretta_recoil" .. i, title_id = "debug_beretta92_short", subtitle_id = "debug_upgrade_recoil" .. i, icon = "beretta92", image = "upgrades_m9sd", image_slice = "upgrades_m9sd_slice", description_text_id = "recoil_multiplier", depends_on = depends_on, unlock_lvl = unlock_lvl}.prio = {tree = 2, step = l_14_0.steps.beretta92.recoil_multiplier[i], category = "feature", name_id = "debug_upgrade_beretta_recoil" .. i, title_id = "debug_beretta92_short", subtitle_id = "debug_upgrade_recoil" .. i, icon = "beretta92", image = "upgrades_m9sd", image_slice = "upgrades_m9sd_slice", description_text_id = "recoil_multiplier", depends_on = depends_on, unlock_lvl = unlock_lvl}, {category = "beretta92", upgrade = "recoil_multiplier", value = i}, prio
  end
  for i,_ in ipairs(l_14_0.values.beretta92.spread_multiplier) do
    local depends_on = i - 1 > 0 and "beretta_spread" .. i - 1 or "beretta92"
    local unlock_lvl = 2
    local prio = (i == 1 and "high")
     -- DECOMPILER ERROR: Confused about usage of registers!

     -- DECOMPILER ERROR: Confused about usage of registers!

    l_14_0.definitions.beretta_spread" .. , {tree = 3, step = l_14_0.steps.beretta92.spread_multiplier[i], category = "feature", name_id = "debug_upgrade_beretta_spread" .. i, title_id = "debug_beretta92_short", subtitle_id = "debug_upgrade_spread" .. i, icon = "beretta92", image = "upgrades_m9sd", image_slice = "upgrades_m9sd_slice", description_text_id = "spread_multiplier", depends_on = depends_on, unlock_lvl = unlock_lvl}.upgrade, {tree = 3, step = l_14_0.steps.beretta92.spread_multiplier[i], category = "feature", name_id = "debug_upgrade_beretta_spread" .. i, title_id = "debug_beretta92_short", subtitle_id = "debug_upgrade_spread" .. i, icon = "beretta92", image = "upgrades_m9sd", image_slice = "upgrades_m9sd_slice", description_text_id = "spread_multiplier", depends_on = depends_on, unlock_lvl = unlock_lvl}.prio = {tree = 3, step = l_14_0.steps.beretta92.spread_multiplier[i], category = "feature", name_id = "debug_upgrade_beretta_spread" .. i, title_id = "debug_beretta92_short", subtitle_id = "debug_upgrade_spread" .. i, icon = "beretta92", image = "upgrades_m9sd", image_slice = "upgrades_m9sd_slice", description_text_id = "spread_multiplier", depends_on = depends_on, unlock_lvl = unlock_lvl}, {category = "beretta92", upgrade = "spread_multiplier", value = i}, prio
  end
end

UpgradesTweakData._raging_bull_definitions = function(l_15_0)
   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

  l_15_0.definitions.raging_bull, {tree = 3, step = 6, category = "weapon", weapon_id = "raging_bull", unit_name = Idstring("units/weapons/raging_bull/raging_bull"), name_id = "debug_raging_bull", title_id = "debug_upgrade_new_weapon", subtitle_id = "debug_raging_bull_short", icon = "raging_bull", image = "upgrades_ragingbull", image_slice = "upgrades_ragingbull_slice", unlock_lvl = 60}.description_text_id, {tree = 3, step = 6, category = "weapon", weapon_id = "raging_bull", unit_name = Idstring("units/weapons/raging_bull/raging_bull"), name_id = "debug_raging_bull", title_id = "debug_upgrade_new_weapon", subtitle_id = "debug_raging_bull_short", icon = "raging_bull", image = "upgrades_ragingbull", image_slice = "upgrades_ragingbull_slice", unlock_lvl = 60}.prio = {tree = 3, step = 6, category = "weapon", weapon_id = "raging_bull", unit_name = Idstring("units/weapons/raging_bull/raging_bull"), name_id = "debug_raging_bull", title_id = "debug_upgrade_new_weapon", subtitle_id = "debug_raging_bull_short", icon = "raging_bull", image = "upgrades_ragingbull", image_slice = "upgrades_ragingbull_slice", unlock_lvl = 60}, "des_raging_bull", "high"
  for i,_ in ipairs(l_15_0.values.raging_bull.spread_multiplier) do
    local depends_on = (i - 1 > 0 and "raging_bull_spread" .. i - 1)
    local unlock_lvl = 61
    local prio = (i == 1 and "high")
     -- DECOMPILER ERROR: Confused about usage of registers!

     -- DECOMPILER ERROR: Confused about usage of registers!

    l_15_0.definitions.raging_bull_spread" .. , {tree = 3, step = l_15_0.steps.raging_bull.spread_multiplier[i], category = "feature", name_id = "debug_upgrade_raging_bull_spread" .. i, title_id = "debug_raging_bull_short", subtitle_id = "debug_upgrade_spread" .. i, icon = "raging_bull", image = "upgrades_ragingbull", image_slice = "upgrades_ragingbull_slice", description_text_id = "spread_multiplier", depends_on = depends_on, unlock_lvl = unlock_lvl}.upgrade, {tree = 3, step = l_15_0.steps.raging_bull.spread_multiplier[i], category = "feature", name_id = "debug_upgrade_raging_bull_spread" .. i, title_id = "debug_raging_bull_short", subtitle_id = "debug_upgrade_spread" .. i, icon = "raging_bull", image = "upgrades_ragingbull", image_slice = "upgrades_ragingbull_slice", description_text_id = "spread_multiplier", depends_on = depends_on, unlock_lvl = unlock_lvl}.prio = {tree = 3, step = l_15_0.steps.raging_bull.spread_multiplier[i], category = "feature", name_id = "debug_upgrade_raging_bull_spread" .. i, title_id = "debug_raging_bull_short", subtitle_id = "debug_upgrade_spread" .. i, icon = "raging_bull", image = "upgrades_ragingbull", image_slice = "upgrades_ragingbull_slice", description_text_id = "spread_multiplier", depends_on = depends_on, unlock_lvl = unlock_lvl}, {category = "raging_bull", upgrade = "spread_multiplier", value = i}, prio
  end
  for i,_ in ipairs(l_15_0.values.raging_bull.reload_speed_multiplier) do
    local depends_on = i - 1 > 0 and "raging_bull_reload_speed" .. i - 1 or "raging_bull"
    local unlock_lvl = 61
    local prio = (i == 1 and "high")
     -- DECOMPILER ERROR: Confused about usage of registers!

     -- DECOMPILER ERROR: Confused about usage of registers!

    l_15_0.definitions.raging_bull_reload_speed" .. , {tree = 3, step = l_15_0.steps.raging_bull.reload_speed_multiplier[i], category = "feature", name_id = "debug_upgrade_raging_bull_reload_speed" .. i, title_id = "debug_raging_bull_short", subtitle_id = "debug_upgrade_reload_speed" .. i, icon = "raging_bull", image = "upgrades_ragingbull", image_slice = "upgrades_ragingbull_slice", description_text_id = "reload_speed_multiplier", depends_on = depends_on, unlock_lvl = unlock_lvl}.upgrade, {tree = 3, step = l_15_0.steps.raging_bull.reload_speed_multiplier[i], category = "feature", name_id = "debug_upgrade_raging_bull_reload_speed" .. i, title_id = "debug_raging_bull_short", subtitle_id = "debug_upgrade_reload_speed" .. i, icon = "raging_bull", image = "upgrades_ragingbull", image_slice = "upgrades_ragingbull_slice", description_text_id = "reload_speed_multiplier", depends_on = depends_on, unlock_lvl = unlock_lvl}.prio = {tree = 3, step = l_15_0.steps.raging_bull.reload_speed_multiplier[i], category = "feature", name_id = "debug_upgrade_raging_bull_reload_speed" .. i, title_id = "debug_raging_bull_short", subtitle_id = "debug_upgrade_reload_speed" .. i, icon = "raging_bull", image = "upgrades_ragingbull", image_slice = "upgrades_ragingbull_slice", description_text_id = "reload_speed_multiplier", depends_on = depends_on, unlock_lvl = unlock_lvl}, {category = "raging_bull", upgrade = "reload_speed_multiplier", value = i}, prio
  end
  for i,_ in ipairs(l_15_0.values.raging_bull.damage_multiplier) do
    local depends_on = i - 1 > 0 and "raging_bull_damage" .. i - 1 or "raging_bull"
    local unlock_lvl = 61
    local prio = (i == 1 and "high")
     -- DECOMPILER ERROR: Confused about usage of registers!

     -- DECOMPILER ERROR: Confused about usage of registers!

    l_15_0.definitions.raging_bull_damage" .. , {tree = 3, step = l_15_0.steps.raging_bull.damage_multiplier[i], category = "feature", name_id = "debug_upgrade_raging_bull_damage" .. i, title_id = "debug_raging_bull_short", subtitle_id = "debug_upgrade_damage" .. i, icon = "raging_bull", image = "upgrades_ragingbull", image_slice = "upgrades_ragingbull_slice", description_text_id = "damage_multiplier", depends_on = depends_on, unlock_lvl = unlock_lvl}.upgrade, {tree = 3, step = l_15_0.steps.raging_bull.damage_multiplier[i], category = "feature", name_id = "debug_upgrade_raging_bull_damage" .. i, title_id = "debug_raging_bull_short", subtitle_id = "debug_upgrade_damage" .. i, icon = "raging_bull", image = "upgrades_ragingbull", image_slice = "upgrades_ragingbull_slice", description_text_id = "damage_multiplier", depends_on = depends_on, unlock_lvl = unlock_lvl}.prio = {tree = 3, step = l_15_0.steps.raging_bull.damage_multiplier[i], category = "feature", name_id = "debug_upgrade_raging_bull_damage" .. i, title_id = "debug_raging_bull_short", subtitle_id = "debug_upgrade_damage" .. i, icon = "raging_bull", image = "upgrades_ragingbull", image_slice = "upgrades_ragingbull_slice", description_text_id = "damage_multiplier", depends_on = depends_on, unlock_lvl = unlock_lvl}, {category = "raging_bull", upgrade = "damage_multiplier", value = i}, prio
  end
end

UpgradesTweakData._olympic_definitions = function(l_16_0)
  l_16_0.definitions.olympic = {category = "weapon", weapon_id = "olympic", factory_id = "wpn_fps_smg_olympic"}
end

UpgradesTweakData._amcar_definitions = function(l_17_0)
  l_17_0.definitions.amcar = {category = "weapon", weapon_id = "amcar", factory_id = "wpn_fps_ass_amcar", free = true}
end

UpgradesTweakData._m16_definitions = function(l_18_0)
  l_18_0.definitions.m16 = {category = "weapon", weapon_id = "m16", factory_id = "wpn_fps_ass_m16"}
end

UpgradesTweakData._new_m4_definitions = function(l_19_0)
  l_19_0.definitions.new_m4 = {category = "weapon", weapon_id = "new_m4", factory_id = "wpn_fps_ass_m4"}
end

UpgradesTweakData._glock_18c_definitions = function(l_20_0)
  l_20_0.definitions.glock_18c = {category = "weapon", weapon_id = "glock_18c", factory_id = "wpn_fps_pis_g18c"}
end

UpgradesTweakData._saiga_definitions = function(l_21_0)
  l_21_0.definitions.saiga = {category = "weapon", weapon_id = "saiga", factory_id = "wpn_fps_shot_saiga"}
end

UpgradesTweakData._akmsu_definitions = function(l_22_0)
  l_22_0.definitions.akmsu = {category = "weapon", weapon_id = "akmsu", factory_id = "wpn_fps_smg_akmsu"}
end

UpgradesTweakData._ak74_definitions = function(l_23_0)
  l_23_0.definitions.ak74 = {category = "weapon", weapon_id = "ak74", factory_id = "wpn_fps_ass_74"}
end

UpgradesTweakData._akm_definitions = function(l_24_0)
  l_24_0.definitions.akm = {category = "weapon", weapon_id = "akm", factory_id = "wpn_fps_ass_akm"}
end

UpgradesTweakData._ak5_definitions = function(l_25_0)
  l_25_0.definitions.ak5 = {category = "weapon", weapon_id = "ak5", factory_id = "wpn_fps_ass_ak5"}
end

UpgradesTweakData._aug_definitions = function(l_26_0)
  l_26_0.definitions.aug = {category = "weapon", weapon_id = "aug", factory_id = "wpn_fps_ass_aug"}
end

UpgradesTweakData._g36_definitions = function(l_27_0)
  l_27_0.definitions.g36 = {category = "weapon", weapon_id = "g36", factory_id = "wpn_fps_ass_g36"}
end

UpgradesTweakData._p90_definitions = function(l_28_0)
  l_28_0.definitions.p90 = {category = "weapon", weapon_id = "p90", factory_id = "wpn_fps_smg_p90"}
end

UpgradesTweakData._new_m14_definitions = function(l_29_0)
  l_29_0.definitions.new_m14 = {category = "weapon", weapon_id = "new_m14", factory_id = "wpn_fps_ass_m14"}
end

UpgradesTweakData._mp9_definitions = function(l_30_0)
  l_30_0.definitions.mp9 = {category = "weapon", weapon_id = "mp9", factory_id = "wpn_fps_smg_mp9"}
end

UpgradesTweakData._deagle_definitions = function(l_31_0)
  l_31_0.definitions.deagle = {category = "weapon", weapon_id = "deagle", factory_id = "wpn_fps_pis_deagle"}
end

UpgradesTweakData._new_mp5_definitions = function(l_32_0)
  l_32_0.definitions.new_mp5 = {category = "weapon", weapon_id = "new_mp5", factory_id = "wpn_fps_smg_mp5"}
end

UpgradesTweakData._colt_1911_definitions = function(l_33_0)
  l_33_0.definitions.colt_1911 = {category = "weapon", weapon_id = "colt_1911", factory_id = "wpn_fps_pis_1911"}
end

UpgradesTweakData._mac10_definitions = function(l_34_0)
  l_34_0.definitions.mac10 = {category = "weapon", weapon_id = "mac10", factory_id = "wpn_fps_smg_mac10"}
end

UpgradesTweakData._glock_17_definitions = function(l_35_0)
  l_35_0.definitions.glock_17 = {category = "weapon", weapon_id = "glock_17", factory_id = "wpn_fps_pis_g17", free = true}
end

UpgradesTweakData._b92fs_definitions = function(l_36_0)
  l_36_0.definitions.b92fs = {category = "weapon", weapon_id = "b92fs", factory_id = "wpn_fps_pis_beretta"}
end

UpgradesTweakData._huntsman_definitions = function(l_37_0)
  l_37_0.definitions.huntsman = {category = "weapon", weapon_id = "huntsman", factory_id = "wpn_fps_shot_huntsman"}
end

UpgradesTweakData._r870_definitions = function(l_38_0)
  l_38_0.definitions.r870 = {category = "weapon", weapon_id = "r870", factory_id = "wpn_fps_shot_r870"}
end

UpgradesTweakData._serbu_definitions = function(l_39_0)
  l_39_0.definitions.serbu = {category = "weapon", weapon_id = "serbu", factory_id = "wpn_fps_shot_serbu"}
end

UpgradesTweakData._new_raging_bull_definitions = function(l_40_0)
  l_40_0.definitions.new_raging_bull = {category = "weapon", weapon_id = "new_raging_bull", factory_id = "wpn_fps_pis_rage"}
end

UpgradesTweakData._saw_definitions = function(l_41_0)
  l_41_0.definitions.saw = {category = "weapon", weapon_id = "saw", factory_id = "wpn_fps_saw"}
  l_41_0.definitions.saw_extra_ammo_multiplier = {category = "feature", name_id = "menu_saw_extra_ammo_multiplier", upgrade = {category = "saw", upgrade = "extra_ammo_multiplier", value = 1}}
  l_41_0.definitions.saw_enemy_slicer = {category = "feature", name_id = "menu_saw_enemy_slicer", upgrade = {category = "saw", upgrade = "enemy_slicer", value = 1}}
  l_41_0.definitions.saw_recoil_multiplier = {category = "feature", name_id = "menu_saw_recoil_multiplier", upgrade = {category = "saw", upgrade = "recoil_multiplier", value = 1}}
  l_41_0.definitions.saw_fire_rate_multiplier_1 = {category = "feature", name_id = "menu_saw_fire_rate_multiplier", upgrade = {category = "saw", upgrade = "fire_rate_multiplier", value = 1}}
  l_41_0.definitions.saw_fire_rate_multiplier_2 = {category = "feature", name_id = "menu_saw_fire_rate_multiplier", upgrade = {category = "saw", upgrade = "fire_rate_multiplier", value = 2}}
  l_41_0.definitions.saw_lock_damage_multiplier_1 = {category = "feature", name_id = "menu_lock_damage_multiplier", upgrade = {category = "saw", upgrade = "lock_damage_multiplier", value = 1}}
  l_41_0.definitions.saw_lock_damage_multiplier_2 = {category = "feature", name_id = "menu_lock_damage_multiplier", upgrade = {category = "saw", upgrade = "lock_damage_multiplier", value = 2}}
  l_41_0.definitions.saw_hip_fire_spread_multiplier = {category = "feature", name_id = "menu_saw_hip_fire_spread_multiplier", upgrade = {category = "saw", upgrade = "hip_fire_spread_multiplier", value = 1}}
end

UpgradesTweakData._weapon_definitions = function(l_42_0)
  l_42_0.definitions.weapon_clip_ammo_increase_1 = {category = "feature", name_id = "menu_weapon_clip_ammo_increase_1", upgrade = {category = "weapon", upgrade = "clip_ammo_increase", value = 1}}
  l_42_0.definitions.weapon_clip_ammo_increase_2 = {category = "feature", name_id = "menu_weapon_clip_ammo_increase_2", upgrade = {category = "weapon", upgrade = "clip_ammo_increase", value = 2}}
  l_42_0.definitions.weapon_passive_swap_speed_multiplier_1 = {category = "feature", name_id = "menu_weapon_swap_speed_multiplier", upgrade = {category = "weapon", upgrade = "passive_swap_speed_multiplier", value = 1}}
  l_42_0.definitions.weapon_passive_swap_speed_multiplier_2 = {category = "feature", name_id = "menu_weapon_swap_speed_multiplier", upgrade = {category = "weapon", upgrade = "passive_swap_speed_multiplier", value = 2}}
  l_42_0.definitions.weapon_swap_speed_multiplier = {category = "feature", name_id = "menu_weapon_swap_speed_multiplier", upgrade = {category = "weapon", upgrade = "swap_speed_multiplier", value = 1}}
  l_42_0.definitions.weapon_single_spread_multiplier = {category = "feature", name_id = "menu_weapon_single_spread_multiplier", upgrade = {category = "weapon", upgrade = "single_spread_multiplier", value = 1}}
  l_42_0.definitions.weapon_silencer_enter_steelsight_speed_multiplier = {category = "feature", name_id = "menu_weapon_silencer_enter_steelsight_speed_multiplier", upgrade = {category = "weapon", upgrade = "silencer_enter_steelsight_speed_multiplier", value = 1}}
  l_42_0.definitions.weapon_silencer_spread_multiplier = {category = "feature", name_id = "menu_silencer_spread_multiplier", upgrade = {category = "weapon", upgrade = "silencer_spread_multiplier", value = 1}}
  l_42_0.definitions.weapon_silencer_recoil_multiplier = {category = "feature", name_id = "menu_silencer_recoil_multiplier", upgrade = {category = "weapon", upgrade = "silencer_recoil_multiplier", value = 1}}
  l_42_0.definitions.weapon_silencer_damage_multiplier_1 = {category = "feature", name_id = "silencer_damage_multiplier", upgrade = {category = "weapon", upgrade = "silencer_damage_multiplier", value = 1}}
  l_42_0.definitions.weapon_silencer_damage_multiplier_2 = {category = "feature", name_id = "silencer_damage_multiplier", upgrade = {category = "weapon", upgrade = "silencer_damage_multiplier", value = 2}}
  l_42_0.definitions.weapon_passive_reload_speed_multiplier = {category = "feature", name_id = "menu_weapon_reload_speed", upgrade = {category = "weapon", upgrade = "passive_reload_speed_multiplier", value = 1}}
  l_42_0.definitions.weapon_passive_recoil_multiplier_1 = {category = "feature", name_id = "menu_weapon_recoil_multiplier", upgrade = {category = "weapon", upgrade = "passive_recoil_multiplier", value = 1}}
  l_42_0.definitions.weapon_passive_recoil_multiplier_2 = {category = "feature", name_id = "menu_weapon_recoil_multiplier", upgrade = {category = "weapon", upgrade = "passive_recoil_multiplier", value = 2}}
  l_42_0.definitions.weapon_passive_headshot_damage_multiplier = {category = "feature", name_id = "menu_weapon_headshot_damage_multiplier", upgrade = {category = "weapon", upgrade = "passive_headshot_damage_multiplier", value = 1}}
  l_42_0.definitions.weapon_passive_damage_multiplier = {category = "feature", name_id = "menu_weapon_passive_damage_multiplier", upgrade = {category = "weapon", upgrade = "passive_damage_multiplier", value = 1}}
  l_42_0.definitions.weapon_special_damage_taken_multiplier = {category = "feature", name_id = "menu_weapon_special_damage_taken_multiplier", upgrade = {category = "weapon", upgrade = "special_damage_taken_multiplier", value = 1}}
  l_42_0.definitions.weapon_spread_multiplier = {category = "feature", name_id = "menu_weapon_spread_multiplier", upgrade = {category = "weapon", upgrade = "spread_multiplier", value = 1}}
  l_42_0.definitions.weapon_fire_rate_multiplier = {category = "feature", name_id = "menu_weapon_fire_rate_multiplier", upgrade = {category = "weapon", upgrade = "fire_rate_multiplier", value = 1}}
end

UpgradesTweakData._pistol_definitions = function(l_43_0)
  l_43_0.definitions.pistol_reload_speed_multiplier = {category = "feature", name_id = "menu_pistol_reload_speed", upgrade = {category = "pistol", upgrade = "reload_speed_multiplier", value = 1}}
  l_43_0.definitions.pistol_damage_multiplier = {category = "feature", name_id = "menu_pistol_damage_multiplier", upgrade = {category = "pistol", upgrade = "damage_multiplier", value = 1}}
  l_43_0.definitions.pistol_spread_multiplier = {category = "feature", name_id = "menu_pistol_spread_multiplier", upgrade = {category = "pistol", upgrade = "spread_multiplier", value = 1}}
  l_43_0.definitions.pistol_fire_rate_multiplier = {category = "feature", name_id = "menu_pistol_fire_rate_multiplier", upgrade = {category = "pistol", upgrade = "fire_rate_multiplier", value = 1}}
  l_43_0.definitions.pistol_exit_run_speed_multiplier = {category = "feature", name_id = "menu_exit_run_speed_multiplier", upgrade = {category = "pistol", upgrade = "exit_run_speed_multiplier", value = 1}}
  l_43_0.definitions.pistol_hip_fire_spread_multiplier = {category = "feature", name_id = "menu_pistol_hip_fire_spread_multiplier", upgrade = {category = "pistol", upgrade = "hip_fire_spread_multiplier", value = 1}}
  l_43_0.definitions.pistol_swap_speed_multiplier = {category = "feature", name_id = "menu_pistol_swap_speed_multiplier", upgrade = {category = "pistol", upgrade = "swap_speed_multiplier", value = 1}}
end

UpgradesTweakData._assault_rifle_definitions = function(l_44_0)
  l_44_0.definitions.assault_rifle_recoil_multiplier = {category = "feature", name_id = "menu_assault_rifle_recoil_multiplier", upgrade = {category = "assault_rifle", upgrade = "recoil_multiplier", value = 1}}
  l_44_0.definitions.assault_rifle_enter_steelsight_speed_multiplier = {category = "feature", name_id = "menu_assault_rifle_enter_steelsight_speed_multiplier", upgrade = {category = "assault_rifle", upgrade = "enter_steelsight_speed_multiplier", value = 1}}
  l_44_0.definitions.assault_rifle_reload_speed_multiplier = {category = "feature", name_id = "menu_assault_rifle_reload_speed_multiplier", upgrade = {category = "assault_rifle", upgrade = "reload_speed_multiplier", value = 1}}
  l_44_0.definitions.assault_rifle_move_spread_multiplier = {category = "feature", name_id = "menu_assault_rifle_move_spread_multiplier", upgrade = {category = "assault_rifle", upgrade = "move_spread_multiplier", value = 1}}
  l_44_0.definitions.assault_rifle_hip_fire_spread_multiplier = {category = "feature", name_id = "menu_assault_rifle_hip_fire_spread_multiplier", upgrade = {category = "assault_rifle", upgrade = "hip_fire_spread_multiplier", value = 1}}
  l_44_0.definitions.assault_rifle_zoom_increase = {category = "feature", name_id = "menu_assault_rifle_zoom_increase", upgrade = {category = "assault_rifle", upgrade = "zoom_increase", value = 1}}
end

UpgradesTweakData._smg_definitions = function(l_45_0)
  l_45_0.definitions.smg_reload_speed_multiplier = {category = "feature", name_id = "menu_reload_speed_multiplier", upgrade = {category = "smg", upgrade = "reload_speed_multiplier", value = 1}}
  l_45_0.definitions.smg_recoil_multiplier = {category = "feature", name_id = "menu_smg_recoil_multiplier", upgrade = {category = "smg", upgrade = "recoil_multiplier", value = 1}}
  l_45_0.definitions.smg_hip_fire_spread_multiplier = {category = "feature", name_id = "menu_smg_hip_fire_spread_multiplier", upgrade = {category = "smg", upgrade = "hip_fire_spread_multiplier", value = 1}}
end

UpgradesTweakData._shotgun_definitions = function(l_46_0)
  l_46_0.definitions.shotgun_recoil_multiplier = {category = "feature", name_id = "menu_shotgun_recoil_multiplier", upgrade = {category = "shotgun", upgrade = "recoil_multiplier", value = 1}}
  l_46_0.definitions.shotgun_damage_multiplier = {category = "feature", name_id = "menu_shotgun_damage_multiplier", upgrade = {category = "shotgun", upgrade = "damage_multiplier", value = 1}}
  l_46_0.definitions.shotgun_reload_speed_multiplier = {category = "feature", name_id = "menu_shotgun_reload_speed_multiplier", upgrade = {category = "shotgun", upgrade = "reload_speed_multiplier", value = 1}}
  l_46_0.definitions.shotgun_enter_steelsight_speed_multiplier = {category = "feature", name_id = "menu_shotgun_enter_steelsight_speed_multiplier", upgrade = {category = "shotgun", upgrade = "enter_steelsight_speed_multiplier", value = 1}}
  l_46_0.definitions.shotgun_hip_fire_spread_multiplier = {category = "feature", name_id = "menu_shotgun_hip_fire_spread_multiplier", upgrade = {category = "shotgun", upgrade = "hip_fire_spread_multiplier", value = 1}}
end

UpgradesTweakData._carry_definitions = function(l_47_0)
  l_47_0.definitions.carry_movement_speed_multiplier = {category = "feature", name_id = "menu_carry_movement_speed_multiplier", upgrade = {category = "carry", upgrade = "movement_speed_multiplier", value = 1}}
  l_47_0.definitions.carry_throw_distance_multiplier = {category = "feature", name_id = "menu_carry_throw_distance_multiplier", upgrade = {category = "carry", upgrade = "throw_distance_multiplier", value = 1}}
  l_47_0.definitions.carry_interact_speed_multiplier_1 = {category = "feature", name_id = "menu_carry_interact_speed_multiplierr", upgrade = {category = "carry", upgrade = "interact_speed_multiplier", value = 1}}
  l_47_0.definitions.carry_catch_interaction_speed_1 = {category = "feature", name_id = "menu_carry_catch_interaction_speed", upgrade = {category = "carry", upgrade = "catch_interaction_speed", value = 1}}
  l_47_0.definitions.carry_interact_speed_multiplier_2 = {category = "feature", name_id = "menu_carry_interact_speed_multiplierr", upgrade = {category = "carry", upgrade = "interact_speed_multiplier", value = 2}}
  l_47_0.definitions.carry_catch_interaction_speed_2 = {category = "feature", name_id = "menu_carry_catch_interaction_speed", upgrade = {category = "carry", upgrade = "catch_interaction_speed", value = 2}}
end

UpgradesTweakData._team_definitions = function(l_48_0)
  l_48_0.definitions.team_pistol_suppression_recoil_multiplier = {category = "team", name_id = "menu_team_pistol_suppression_recoil_multiplier", upgrade = {category = "pistol", upgrade = "suppression_recoil_multiplier", value = 1}}
  l_48_0.definitions.team_pistol_recoil_multiplier = {category = "team", name_id = "menu_team_pistol_recoil_multiplier", upgrade = {category = "pistol", upgrade = "recoil_multiplier", value = 1}}
  l_48_0.definitions.team_weapon_suppression_recoil_multiplier = {category = "team", name_id = "menu_team_weapon_suppression_recoil_multiplier", upgrade = {category = "weapon", upgrade = "suppression_recoil_multiplier", value = 1}}
  l_48_0.definitions.team_weapon_recoil_multiplier = {category = "team", name_id = "menu_team_weapon_recoil_multiplier", upgrade = {category = "weapon", upgrade = "recoil_multiplier", value = 1}}
  l_48_0.definitions.team_xp_multiplier = {category = "team", name_id = "menu_team_xp_multiplier", upgrade = {category = "xp", upgrade = "multiplier", value = 1}}
  l_48_0.definitions.team_armor_regen_time_multiplier = {category = "team", name_id = "menu_team_armor_regen_time_multiplier", upgrade = {category = "armor", upgrade = "regen_time_multiplier", value = 1}}
  l_48_0.definitions.team_passive_armor_regen_time_multiplier = {category = "team", name_id = "menu_team_armor_regen_time_multiplier", upgrade = {category = "armor", upgrade = "passive_regen_time_multiplier", value = 1}}
  l_48_0.definitions.team_stamina_multiplier = {category = "team", name_id = "menu_team_stamina_multiplier", upgrade = {category = "stamina", upgrade = "multiplier", value = 1}}
  l_48_0.definitions.team_passive_stamina_multiplier_1 = {category = "team", name_id = "menu_team_stamina_multiplier", upgrade = {category = "stamina", upgrade = "passive_multiplier", value = 1}}
  l_48_0.definitions.team_passive_stamina_multiplier_2 = {category = "team", name_id = "menu_team_stamina_multiplier", upgrade = {category = "stamina", upgrade = "passive_multiplier", value = 2}}
end

UpgradesTweakData._temporary_definitions = function(l_49_0)
  l_49_0.definitions.temporary_combat_medic_damage_multiplier1 = {incremental = true, category = "temporary", name_id = "menu_temporary_combat_medic_damage_multiplier", upgrade = {category = "temporary", upgrade = "combat_medic_damage_multiplier", value = 1}}
  l_49_0.definitions.temporary_combat_medic_damage_multiplier2 = {incremental = true, category = "temporary", name_id = "menu_temporary_combat_medic_damage_multiplier", upgrade = {category = "temporary", upgrade = "combat_medic_damage_multiplier", value = 2}}
  l_49_0.definitions.temporary_combat_medic_enter_steelsight_speed_multiplier = {category = "temporary", name_id = "menu_temporary_combat_medic_enter_steelsight_speed_multiplier", upgrade = {category = "temporary", upgrade = "combat_medic_enter_steelsight_speed_multiplier", value = 1}}
  l_49_0.definitions.temporary_revive_health_boost = {category = "temporary", name_id = "menu_temporary_revive_health_boost", upgrade = {category = "temporary", upgrade = "revive_health_boost", value = 1}}
  l_49_0.definitions.temporary_no_ammo_cost_1 = {category = "temporary", name_id = "menu_temporary_no_ammo_cost_1", upgrade = {category = "temporary", upgrade = "no_ammo_cost", value = 1}}
  l_49_0.definitions.temporary_no_ammo_cost_2 = {category = "temporary", name_id = "menu_temporary_no_ammo_cost_2", upgrade = {category = "temporary", upgrade = "no_ammo_cost", value = 2}}
end

UpgradesTweakData._shape_charge_definitions = function(l_50_0)
  l_50_0.definitions.shape_charge = {category = "equipment", equipment_id = "shape_charge", name_id = "menu_shape_charge"}
end

UpgradesTweakData._m4_definitions = function(l_51_0)
   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

  l_51_0.definitions.m4, {category = "weapon", weapon_id = "m4", unit_name = Idstring("units/weapons/m4_rifle/m4_rifle"), name_id = "debug_m4_rifle", title_id = "debug_m4_rifle_short", icon = "m4"}.description_text_id, {category = "weapon", weapon_id = "m4", unit_name = Idstring("units/weapons/m4_rifle/m4_rifle"), name_id = "debug_m4_rifle", title_id = "debug_m4_rifle_short", icon = "m4"}.prio, {category = "weapon", weapon_id = "m4", unit_name = Idstring("units/weapons/m4_rifle/m4_rifle"), name_id = "debug_m4_rifle", title_id = "debug_m4_rifle_short", icon = "m4"}.unlock_lvl, {category = "weapon", weapon_id = "m4", unit_name = Idstring("units/weapons/m4_rifle/m4_rifle"), name_id = "debug_m4_rifle", title_id = "debug_m4_rifle_short", icon = "m4"}.image_slice, {category = "weapon", weapon_id = "m4", unit_name = Idstring("units/weapons/m4_rifle/m4_rifle"), name_id = "debug_m4_rifle", title_id = "debug_m4_rifle_short", icon = "m4"}.image = {category = "weapon", weapon_id = "m4", unit_name = Idstring("units/weapons/m4_rifle/m4_rifle"), name_id = "debug_m4_rifle", title_id = "debug_m4_rifle_short", icon = "m4"}, "des_m4", "high", 0, "upgrades_m4_slice", "upgrades_m4"
  for i,_ in ipairs(l_51_0.values.m4.clip_ammo_increase) do
    local depends_on = i - 1 > 0 and "m4_mag" .. i - 1 or "m4"
    local unlock_lvl = 3
    local prio = (i == 1 and "high")
     -- DECOMPILER ERROR: Confused about usage of registers!

     -- DECOMPILER ERROR: Confused about usage of registers!

    l_51_0.definitions.m4_mag" .. , {tree = 3, step = l_51_0.steps.m4.clip_ammo_increase[i], category = "feature", name_id = "debug_upgrade_m4_mag" .. i, title_id = "debug_m4_rifle_short", subtitle_id = "debug_upgrade_mag" .. i, icon = "m4", image = "upgrades_m4", image_slice = "upgrades_m4_slice", description_text_id = "clip_ammo_increase", depends_on = depends_on, unlock_lvl = unlock_lvl}.upgrade, {tree = 3, step = l_51_0.steps.m4.clip_ammo_increase[i], category = "feature", name_id = "debug_upgrade_m4_mag" .. i, title_id = "debug_m4_rifle_short", subtitle_id = "debug_upgrade_mag" .. i, icon = "m4", image = "upgrades_m4", image_slice = "upgrades_m4_slice", description_text_id = "clip_ammo_increase", depends_on = depends_on, unlock_lvl = unlock_lvl}.prio = {tree = 3, step = l_51_0.steps.m4.clip_ammo_increase[i], category = "feature", name_id = "debug_upgrade_m4_mag" .. i, title_id = "debug_m4_rifle_short", subtitle_id = "debug_upgrade_mag" .. i, icon = "m4", image = "upgrades_m4", image_slice = "upgrades_m4_slice", description_text_id = "clip_ammo_increase", depends_on = depends_on, unlock_lvl = unlock_lvl}, {category = "m4", upgrade = "clip_ammo_increase", value = i}, prio
  end
  for i,_ in ipairs(l_51_0.values.m4.spread_multiplier) do
    local depends_on = i - 1 > 0 and "m4_spread" .. i - 1 or "m4"
    local unlock_lvl = 4
    local prio = (i == 1 and "high")
     -- DECOMPILER ERROR: Confused about usage of registers!

     -- DECOMPILER ERROR: Confused about usage of registers!

    l_51_0.definitions.m4_spread" .. , {tree = 2, step = l_51_0.steps.m4.spread_multiplier[i], category = "feature", name_id = "debug_upgrade_m4_spread" .. i, title_id = "debug_m4_rifle_short", subtitle_id = "debug_upgrade_spread" .. i, icon = "m4", image = "upgrades_m4", image_slice = "upgrades_m4_slice", description_text_id = "spread_multiplier", depends_on = depends_on, unlock_lvl = unlock_lvl}.upgrade, {tree = 2, step = l_51_0.steps.m4.spread_multiplier[i], category = "feature", name_id = "debug_upgrade_m4_spread" .. i, title_id = "debug_m4_rifle_short", subtitle_id = "debug_upgrade_spread" .. i, icon = "m4", image = "upgrades_m4", image_slice = "upgrades_m4_slice", description_text_id = "spread_multiplier", depends_on = depends_on, unlock_lvl = unlock_lvl}.prio = {tree = 2, step = l_51_0.steps.m4.spread_multiplier[i], category = "feature", name_id = "debug_upgrade_m4_spread" .. i, title_id = "debug_m4_rifle_short", subtitle_id = "debug_upgrade_spread" .. i, icon = "m4", image = "upgrades_m4", image_slice = "upgrades_m4_slice", description_text_id = "spread_multiplier", depends_on = depends_on, unlock_lvl = unlock_lvl}, {category = "m4", upgrade = "spread_multiplier", value = i}, prio
  end
  for i,_ in ipairs(l_51_0.values.m4.damage_multiplier) do
    local depends_on = i - 1 > 0 and "m4_damage" .. i - 1 or "m4"
    local unlock_lvl = 5
    local prio = (i == 1 and "high")
     -- DECOMPILER ERROR: Confused about usage of registers!

     -- DECOMPILER ERROR: Confused about usage of registers!

    l_51_0.definitions.m4_damage" .. , {tree = 1, step = l_51_0.steps.m4.damage_multiplier[i], category = "feature", name_id = "debug_upgrade_m4_damage" .. i, title_id = "debug_m4_rifle_short", subtitle_id = "debug_upgrade_damage" .. i, icon = "m4", image = "upgrades_m4", image_slice = "upgrades_m4_slice", description_text_id = "damage_multiplier", depends_on = depends_on, unlock_lvl = unlock_lvl}.upgrade, {tree = 1, step = l_51_0.steps.m4.damage_multiplier[i], category = "feature", name_id = "debug_upgrade_m4_damage" .. i, title_id = "debug_m4_rifle_short", subtitle_id = "debug_upgrade_damage" .. i, icon = "m4", image = "upgrades_m4", image_slice = "upgrades_m4_slice", description_text_id = "damage_multiplier", depends_on = depends_on, unlock_lvl = unlock_lvl}.prio = {tree = 1, step = l_51_0.steps.m4.damage_multiplier[i], category = "feature", name_id = "debug_upgrade_m4_damage" .. i, title_id = "debug_m4_rifle_short", subtitle_id = "debug_upgrade_damage" .. i, icon = "m4", image = "upgrades_m4", image_slice = "upgrades_m4_slice", description_text_id = "damage_multiplier", depends_on = depends_on, unlock_lvl = unlock_lvl}, {category = "m4", upgrade = "damage_multiplier", value = i}, prio
  end
end

UpgradesTweakData._m14_definitions = function(l_52_0)
   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

  l_52_0.definitions.m14, {tree = 2, step = 17, category = "weapon", weapon_id = "m14", unit_name = Idstring("units/weapons/m14/m14"), name_id = "debug_m14", title_id = "debug_upgrade_new_weapon", subtitle_id = "debug_m14_short", icon = "m14", image = "upgrades_m14", image_slice = "upgrades_m14_slice", unlock_lvl = 101}.description_text_id, {tree = 2, step = 17, category = "weapon", weapon_id = "m14", unit_name = Idstring("units/weapons/m14/m14"), name_id = "debug_m14", title_id = "debug_upgrade_new_weapon", subtitle_id = "debug_m14_short", icon = "m14", image = "upgrades_m14", image_slice = "upgrades_m14_slice", unlock_lvl = 101}.prio = {tree = 2, step = 17, category = "weapon", weapon_id = "m14", unit_name = Idstring("units/weapons/m14/m14"), name_id = "debug_m14", title_id = "debug_upgrade_new_weapon", subtitle_id = "debug_m14_short", icon = "m14", image = "upgrades_m14", image_slice = "upgrades_m14_slice", unlock_lvl = 101}, "des_m14", "high"
  for i,_ in ipairs(l_52_0.values.m14.clip_ammo_increase) do
    local depends_on = i - 1 > 0 and "m14_mag" .. i - 1 or "m14"
    local unlock_lvl = 102
    local prio = (i == 1 and "high")
     -- DECOMPILER ERROR: Confused about usage of registers!

     -- DECOMPILER ERROR: Confused about usage of registers!

    l_52_0.definitions.m14_mag" .. , {tree = 2, step = l_52_0.steps.m14.clip_ammo_increase[i], category = "feature", name_id = "debug_upgrade_m14_mag" .. i, title_id = "debug_m14_short", subtitle_id = "debug_upgrade_mag" .. i, icon = "m14", image = "upgrades_m14", image_slice = "upgrades_m14_slice", description_text_id = "clip_ammo_increase", depends_on = depends_on, unlock_lvl = unlock_lvl}.upgrade, {tree = 2, step = l_52_0.steps.m14.clip_ammo_increase[i], category = "feature", name_id = "debug_upgrade_m14_mag" .. i, title_id = "debug_m14_short", subtitle_id = "debug_upgrade_mag" .. i, icon = "m14", image = "upgrades_m14", image_slice = "upgrades_m14_slice", description_text_id = "clip_ammo_increase", depends_on = depends_on, unlock_lvl = unlock_lvl}.prio = {tree = 2, step = l_52_0.steps.m14.clip_ammo_increase[i], category = "feature", name_id = "debug_upgrade_m14_mag" .. i, title_id = "debug_m14_short", subtitle_id = "debug_upgrade_mag" .. i, icon = "m14", image = "upgrades_m14", image_slice = "upgrades_m14_slice", description_text_id = "clip_ammo_increase", depends_on = depends_on, unlock_lvl = unlock_lvl}, {category = "m14", upgrade = "clip_ammo_increase", value = i}, prio
  end
  for i,_ in ipairs(l_52_0.values.m14.spread_multiplier) do
    local depends_on = i - 1 > 0 and "m14_spread" .. i - 1 or "m14"
    local unlock_lvl = 102
    local prio = (i == 1 and "high")
     -- DECOMPILER ERROR: Confused about usage of registers!

     -- DECOMPILER ERROR: Confused about usage of registers!

    l_52_0.definitions.m14_spread" .. , {tree = 2, step = l_52_0.steps.m14.spread_multiplier[i], category = "feature", name_id = "debug_upgrade_m14_spread" .. i, title_id = "debug_m14_short", subtitle_id = "debug_upgrade_spread" .. i, icon = "m14", image = "upgrades_m14", image_slice = "upgrades_m14_slice", description_text_id = "spread_multiplier", depends_on = depends_on, unlock_lvl = unlock_lvl}.upgrade, {tree = 2, step = l_52_0.steps.m14.spread_multiplier[i], category = "feature", name_id = "debug_upgrade_m14_spread" .. i, title_id = "debug_m14_short", subtitle_id = "debug_upgrade_spread" .. i, icon = "m14", image = "upgrades_m14", image_slice = "upgrades_m14_slice", description_text_id = "spread_multiplier", depends_on = depends_on, unlock_lvl = unlock_lvl}.prio = {tree = 2, step = l_52_0.steps.m14.spread_multiplier[i], category = "feature", name_id = "debug_upgrade_m14_spread" .. i, title_id = "debug_m14_short", subtitle_id = "debug_upgrade_spread" .. i, icon = "m14", image = "upgrades_m14", image_slice = "upgrades_m14_slice", description_text_id = "spread_multiplier", depends_on = depends_on, unlock_lvl = unlock_lvl}, {category = "m14", upgrade = "spread_multiplier", value = i}, prio
  end
  for i,_ in ipairs(l_52_0.values.m14.damage_multiplier) do
    local depends_on = i - 1 > 0 and "m14_damage" .. i - 1 or "m14"
    local unlock_lvl = 102
    local prio = (i == 1 and "high")
     -- DECOMPILER ERROR: Confused about usage of registers!

     -- DECOMPILER ERROR: Confused about usage of registers!

    l_52_0.definitions.m14_damage" .. , {tree = 2, step = l_52_0.steps.m14.damage_multiplier[i], category = "feature", name_id = "debug_upgrade_m14_damage" .. i, title_id = "debug_m14_short", subtitle_id = "debug_upgrade_damage" .. i, icon = "m14", image = "upgrades_m14", image_slice = "upgrades_m14_slice", description_text_id = "damage_multiplier", depends_on = depends_on, unlock_lvl = unlock_lvl}.upgrade, {tree = 2, step = l_52_0.steps.m14.damage_multiplier[i], category = "feature", name_id = "debug_upgrade_m14_damage" .. i, title_id = "debug_m14_short", subtitle_id = "debug_upgrade_damage" .. i, icon = "m14", image = "upgrades_m14", image_slice = "upgrades_m14_slice", description_text_id = "damage_multiplier", depends_on = depends_on, unlock_lvl = unlock_lvl}.prio = {tree = 2, step = l_52_0.steps.m14.damage_multiplier[i], category = "feature", name_id = "debug_upgrade_m14_damage" .. i, title_id = "debug_m14_short", subtitle_id = "debug_upgrade_damage" .. i, icon = "m14", image = "upgrades_m14", image_slice = "upgrades_m14_slice", description_text_id = "damage_multiplier", depends_on = depends_on, unlock_lvl = unlock_lvl}, {category = "m14", upgrade = "damage_multiplier", value = i}, prio
  end
  for i,_ in ipairs(l_52_0.values.m14.recoil_multiplier) do
    local depends_on = i - 1 > 0 and "m14_recoil" .. i - 1 or "m14"
    local unlock_lvl = 102
    local prio = (i == 1 and "high")
     -- DECOMPILER ERROR: Confused about usage of registers!

     -- DECOMPILER ERROR: Confused about usage of registers!

    l_52_0.definitions.m14_recoil" .. , {tree = 2, step = l_52_0.steps.m14.recoil_multiplier[i], category = "feature", name_id = "debug_upgrade_m14_recoil" .. i, title_id = "debug_m14_short", subtitle_id = "debug_upgrade_recoil" .. i, icon = "m14", image = "upgrades_m14", image_slice = "upgrades_m14_slice", description_text_id = "recoil_multiplier", depends_on = depends_on, unlock_lvl = unlock_lvl}.upgrade, {tree = 2, step = l_52_0.steps.m14.recoil_multiplier[i], category = "feature", name_id = "debug_upgrade_m14_recoil" .. i, title_id = "debug_m14_short", subtitle_id = "debug_upgrade_recoil" .. i, icon = "m14", image = "upgrades_m14", image_slice = "upgrades_m14_slice", description_text_id = "recoil_multiplier", depends_on = depends_on, unlock_lvl = unlock_lvl}.prio = {tree = 2, step = l_52_0.steps.m14.recoil_multiplier[i], category = "feature", name_id = "debug_upgrade_m14_recoil" .. i, title_id = "debug_m14_short", subtitle_id = "debug_upgrade_recoil" .. i, icon = "m14", image = "upgrades_m14", image_slice = "upgrades_m14_slice", description_text_id = "recoil_multiplier", depends_on = depends_on, unlock_lvl = unlock_lvl}, {category = "m14", upgrade = "recoil_multiplier", value = i}, prio
  end
end

UpgradesTweakData._mp5_definitions = function(l_53_0)
   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

  l_53_0.definitions.mp5, {tree = 3, step = 21, category = "weapon", weapon_id = "mp5", unit_name = Idstring("units/weapons/mp5/mp5"), name_id = "debug_mp5", title_id = "debug_upgrade_new_weapon", subtitle_id = "debug_mp5_short", icon = "mp5", image = "upgrades_mp5", image_slice = "upgrades_mp5_slice", unlock_lvl = 6}.description_text_id, {tree = 3, step = 21, category = "weapon", weapon_id = "mp5", unit_name = Idstring("units/weapons/mp5/mp5"), name_id = "debug_mp5", title_id = "debug_upgrade_new_weapon", subtitle_id = "debug_mp5_short", icon = "mp5", image = "upgrades_mp5", image_slice = "upgrades_mp5_slice", unlock_lvl = 6}.prio = {tree = 3, step = 21, category = "weapon", weapon_id = "mp5", unit_name = Idstring("units/weapons/mp5/mp5"), name_id = "debug_mp5", title_id = "debug_upgrade_new_weapon", subtitle_id = "debug_mp5_short", icon = "mp5", image = "upgrades_mp5", image_slice = "upgrades_mp5_slice", unlock_lvl = 6}, "des_mp5", "high"
  for i,_ in ipairs(l_53_0.values.mp5.spread_multiplier) do
    local depends_on = i - 1 > 0 and "mp5_spread" .. i - 1 or "mp5"
    local unlock_lvl = 7
    local prio = (i == 1 and "high")
     -- DECOMPILER ERROR: Confused about usage of registers!

     -- DECOMPILER ERROR: Confused about usage of registers!

    l_53_0.definitions.mp5_spread" .. , {tree = 3, step = l_53_0.steps.mp5.spread_multiplier[i], category = "feature", name_id = "debug_upgrade_mp5_spread" .. i, title_id = "debug_mp5_short", subtitle_id = "debug_upgrade_spread" .. i, icon = "mp5", image = "upgrades_mp5", image_slice = "upgrades_mp5_slice", description_text_id = "spread_multiplier", depends_on = depends_on, unlock_lvl = unlock_lvl}.upgrade, {tree = 3, step = l_53_0.steps.mp5.spread_multiplier[i], category = "feature", name_id = "debug_upgrade_mp5_spread" .. i, title_id = "debug_mp5_short", subtitle_id = "debug_upgrade_spread" .. i, icon = "mp5", image = "upgrades_mp5", image_slice = "upgrades_mp5_slice", description_text_id = "spread_multiplier", depends_on = depends_on, unlock_lvl = unlock_lvl}.prio = {tree = 3, step = l_53_0.steps.mp5.spread_multiplier[i], category = "feature", name_id = "debug_upgrade_mp5_spread" .. i, title_id = "debug_mp5_short", subtitle_id = "debug_upgrade_spread" .. i, icon = "mp5", image = "upgrades_mp5", image_slice = "upgrades_mp5_slice", description_text_id = "spread_multiplier", depends_on = depends_on, unlock_lvl = unlock_lvl}, {category = "mp5", upgrade = "spread_multiplier", value = i}, prio
  end
  for i,_ in ipairs(l_53_0.values.mp5.recoil_multiplier) do
    local depends_on = i - 1 > 0 and "mp5_recoil" .. i - 1 or "mp5"
    local unlock_lvl = 8
    local prio = (i == 1 and "high")
     -- DECOMPILER ERROR: Confused about usage of registers!

     -- DECOMPILER ERROR: Confused about usage of registers!

    l_53_0.definitions.mp5_recoil" .. , {tree = 3, step = l_53_0.steps.mp5.recoil_multiplier[i], category = "feature", name_id = "debug_upgrade_mp5_recoil" .. i, title_id = "debug_mp5_short", subtitle_id = "debug_upgrade_recoil" .. i, icon = "mp5", image = "upgrades_mp5", image_slice = "upgrades_mp5_slice", description_text_id = "recoil_multiplier", depends_on = depends_on, unlock_lvl = unlock_lvl}.upgrade, {tree = 3, step = l_53_0.steps.mp5.recoil_multiplier[i], category = "feature", name_id = "debug_upgrade_mp5_recoil" .. i, title_id = "debug_mp5_short", subtitle_id = "debug_upgrade_recoil" .. i, icon = "mp5", image = "upgrades_mp5", image_slice = "upgrades_mp5_slice", description_text_id = "recoil_multiplier", depends_on = depends_on, unlock_lvl = unlock_lvl}.prio = {tree = 3, step = l_53_0.steps.mp5.recoil_multiplier[i], category = "feature", name_id = "debug_upgrade_mp5_recoil" .. i, title_id = "debug_mp5_short", subtitle_id = "debug_upgrade_recoil" .. i, icon = "mp5", image = "upgrades_mp5", image_slice = "upgrades_mp5_slice", description_text_id = "recoil_multiplier", depends_on = depends_on, unlock_lvl = unlock_lvl}, {category = "mp5", upgrade = "recoil_multiplier", value = i}, prio
  end
  for i,_ in ipairs(l_53_0.values.mp5.reload_speed_multiplier) do
    local depends_on = i - 1 > 0 and "mp5_reload_speed" .. i - 1 or "mp5"
    local unlock_lvl = 9
    local prio = (i == 1 and "high")
     -- DECOMPILER ERROR: Confused about usage of registers!

     -- DECOMPILER ERROR: Confused about usage of registers!

    l_53_0.definitions.mp5_reload_speed" .. , {tree = 3, step = l_53_0.steps.mp5.reload_speed_multiplier[i], category = "feature", name_id = "debug_upgrade_mp5_reload_speed" .. i, title_id = "debug_mp5_short", subtitle_id = "debug_upgrade_reload_speed" .. i, icon = "mp5", image = "upgrades_mp5", image_slice = "upgrades_mp5_slice", description_text_id = "reload_speed_multiplier", depends_on = depends_on, unlock_lvl = unlock_lvl}.upgrade, {tree = 3, step = l_53_0.steps.mp5.reload_speed_multiplier[i], category = "feature", name_id = "debug_upgrade_mp5_reload_speed" .. i, title_id = "debug_mp5_short", subtitle_id = "debug_upgrade_reload_speed" .. i, icon = "mp5", image = "upgrades_mp5", image_slice = "upgrades_mp5_slice", description_text_id = "reload_speed_multiplier", depends_on = depends_on, unlock_lvl = unlock_lvl}.prio = {tree = 3, step = l_53_0.steps.mp5.reload_speed_multiplier[i], category = "feature", name_id = "debug_upgrade_mp5_reload_speed" .. i, title_id = "debug_mp5_short", subtitle_id = "debug_upgrade_reload_speed" .. i, icon = "mp5", image = "upgrades_mp5", image_slice = "upgrades_mp5_slice", description_text_id = "reload_speed_multiplier", depends_on = depends_on, unlock_lvl = unlock_lvl}, {category = "mp5", upgrade = "reload_speed_multiplier", value = i}, prio
  end
  for i,_ in ipairs(l_53_0.values.mp5.enter_steelsight_speed_multiplier) do
    local depends_on = i - 1 > 0 and "mp5_enter_steelsight_speed" .. i - 1 or "mp5"
    local unlock_lvl = 10
    local prio = (i == 1 and "high")
     -- DECOMPILER ERROR: Confused about usage of registers!

     -- DECOMPILER ERROR: Confused about usage of registers!

    l_53_0.definitions.mp5_enter_steelsight_speed" .. , {tree = 3, step = l_53_0.steps.mp5.enter_steelsight_speed_multiplier[i], category = "feature", name_id = "debug_upgrade_mp5_enter_steelsight_speed" .. i, title_id = "debug_mp5_short", subtitle_id = "debug_upgrade_enter_steelsight_speed" .. i, icon = "mp5", image = "upgrades_mp5", image_slice = "upgrades_mp5_slice", description_text_id = "enter_steelsight_speed_multiplier", depends_on = depends_on, unlock_lvl = unlock_lvl}.upgrade, {tree = 3, step = l_53_0.steps.mp5.enter_steelsight_speed_multiplier[i], category = "feature", name_id = "debug_upgrade_mp5_enter_steelsight_speed" .. i, title_id = "debug_mp5_short", subtitle_id = "debug_upgrade_enter_steelsight_speed" .. i, icon = "mp5", image = "upgrades_mp5", image_slice = "upgrades_mp5_slice", description_text_id = "enter_steelsight_speed_multiplier", depends_on = depends_on, unlock_lvl = unlock_lvl}.prio = {tree = 3, step = l_53_0.steps.mp5.enter_steelsight_speed_multiplier[i], category = "feature", name_id = "debug_upgrade_mp5_enter_steelsight_speed" .. i, title_id = "debug_mp5_short", subtitle_id = "debug_upgrade_enter_steelsight_speed" .. i, icon = "mp5", image = "upgrades_mp5", image_slice = "upgrades_mp5_slice", description_text_id = "enter_steelsight_speed_multiplier", depends_on = depends_on, unlock_lvl = unlock_lvl}, {category = "mp5", upgrade = "enter_steelsight_speed_multiplier", value = i}, prio
  end
end

UpgradesTweakData._mac11_definitions = function(l_54_0)
   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

  l_54_0.definitions.mac11, {tree = 1, step = 5, category = "weapon", weapon_id = "mac11", unit_name = Idstring("units/weapons/mac11/mac11"), name_id = "debug_mac11", title_id = "debug_upgrade_new_weapon", subtitle_id = "debug_mac11_short", icon = "mac11", image = "upgrades_mac10", image_slice = "upgrades_mac10_slice", unlock_lvl = 81}.description_text_id, {tree = 1, step = 5, category = "weapon", weapon_id = "mac11", unit_name = Idstring("units/weapons/mac11/mac11"), name_id = "debug_mac11", title_id = "debug_upgrade_new_weapon", subtitle_id = "debug_mac11_short", icon = "mac11", image = "upgrades_mac10", image_slice = "upgrades_mac10_slice", unlock_lvl = 81}.prio = {tree = 1, step = 5, category = "weapon", weapon_id = "mac11", unit_name = Idstring("units/weapons/mac11/mac11"), name_id = "debug_mac11", title_id = "debug_upgrade_new_weapon", subtitle_id = "debug_mac11_short", icon = "mac11", image = "upgrades_mac10", image_slice = "upgrades_mac10_slice", unlock_lvl = 81}, "des_mac11", "high"
  for i,_ in ipairs(l_54_0.values.mac11.recoil_multiplier) do
    local depends_on = i - 1 > 0 and "mac11_recoil" .. i - 1 or "mac11"
    local unlock_lvl = 82
    local prio = (i == 1 and "high")
     -- DECOMPILER ERROR: Confused about usage of registers!

     -- DECOMPILER ERROR: Confused about usage of registers!

    l_54_0.definitions.mac11_recoil" .. , {tree = 1, step = l_54_0.steps.mac11.recoil_multiplier[i], category = "feature", name_id = "debug_upgrade_mac11_recoil" .. i, title_id = "debug_mac11_short", subtitle_id = "debug_upgrade_recoil" .. i, icon = "mac11", image = "upgrades_mac10", image_slice = "upgrades_mac10_slice", description_text_id = "recoil_multiplier", depends_on = depends_on, unlock_lvl = unlock_lvl}.upgrade, {tree = 1, step = l_54_0.steps.mac11.recoil_multiplier[i], category = "feature", name_id = "debug_upgrade_mac11_recoil" .. i, title_id = "debug_mac11_short", subtitle_id = "debug_upgrade_recoil" .. i, icon = "mac11", image = "upgrades_mac10", image_slice = "upgrades_mac10_slice", description_text_id = "recoil_multiplier", depends_on = depends_on, unlock_lvl = unlock_lvl}.prio = {tree = 1, step = l_54_0.steps.mac11.recoil_multiplier[i], category = "feature", name_id = "debug_upgrade_mac11_recoil" .. i, title_id = "debug_mac11_short", subtitle_id = "debug_upgrade_recoil" .. i, icon = "mac11", image = "upgrades_mac10", image_slice = "upgrades_mac10_slice", description_text_id = "recoil_multiplier", depends_on = depends_on, unlock_lvl = unlock_lvl}, {category = "mac11", upgrade = "recoil_multiplier", value = i}, prio
  end
  for i,_ in ipairs(l_54_0.values.mac11.enter_steelsight_speed_multiplier) do
    local depends_on = i - 1 > 0 and "mac11_enter_steelsight_speed" .. i - 1 or "mac11"
    local unlock_lvl = 82
    local prio = (i == 1 and "high")
     -- DECOMPILER ERROR: Confused about usage of registers!

     -- DECOMPILER ERROR: Confused about usage of registers!

    l_54_0.definitions.mac11_enter_steelsight_speed" .. , {tree = 1, step = l_54_0.steps.mac11.enter_steelsight_speed_multiplier[i], category = "feature", name_id = "debug_upgrade_mac11_enter_steelsight_speed" .. i, title_id = "debug_mac11_short", subtitle_id = "debug_upgrade_enter_steelsight_speed" .. i, icon = "mac11", image = "upgrades_mac10", image_slice = "upgrades_mac10_slice", description_text_id = "enter_steelsight_speed_multiplier", depends_on = depends_on, unlock_lvl = unlock_lvl}.upgrade, {tree = 1, step = l_54_0.steps.mac11.enter_steelsight_speed_multiplier[i], category = "feature", name_id = "debug_upgrade_mac11_enter_steelsight_speed" .. i, title_id = "debug_mac11_short", subtitle_id = "debug_upgrade_enter_steelsight_speed" .. i, icon = "mac11", image = "upgrades_mac10", image_slice = "upgrades_mac10_slice", description_text_id = "enter_steelsight_speed_multiplier", depends_on = depends_on, unlock_lvl = unlock_lvl}.prio = {tree = 1, step = l_54_0.steps.mac11.enter_steelsight_speed_multiplier[i], category = "feature", name_id = "debug_upgrade_mac11_enter_steelsight_speed" .. i, title_id = "debug_mac11_short", subtitle_id = "debug_upgrade_enter_steelsight_speed" .. i, icon = "mac11", image = "upgrades_mac10", image_slice = "upgrades_mac10_slice", description_text_id = "enter_steelsight_speed_multiplier", depends_on = depends_on, unlock_lvl = unlock_lvl}, {category = "mac11", upgrade = "enter_steelsight_speed_multiplier", value = i}, prio
  end
  for i,_ in ipairs(l_54_0.values.mac11.clip_ammo_increase) do
    local depends_on = i - 1 > 0 and "mac11_mag" .. i - 1 or "mac11"
    local unlock_lvl = 82
    local prio = (i == 1 and "high")
     -- DECOMPILER ERROR: Confused about usage of registers!

     -- DECOMPILER ERROR: Confused about usage of registers!

    l_54_0.definitions.mac11_mag" .. , {tree = 1, step = l_54_0.steps.mac11.clip_ammo_increase[i], category = "feature", name_id = "debug_upgrade_mac11_mag" .. i, title_id = "debug_mac11_short", subtitle_id = "debug_upgrade_mag" .. i, icon = "mac11", image = "upgrades_mac10", image_slice = "upgrades_mac10_slice", description_text_id = "clip_ammo_increase", depends_on = depends_on, unlock_lvl = unlock_lvl}.upgrade, {tree = 1, step = l_54_0.steps.mac11.clip_ammo_increase[i], category = "feature", name_id = "debug_upgrade_mac11_mag" .. i, title_id = "debug_mac11_short", subtitle_id = "debug_upgrade_mag" .. i, icon = "mac11", image = "upgrades_mac10", image_slice = "upgrades_mac10_slice", description_text_id = "clip_ammo_increase", depends_on = depends_on, unlock_lvl = unlock_lvl}.prio = {tree = 1, step = l_54_0.steps.mac11.clip_ammo_increase[i], category = "feature", name_id = "debug_upgrade_mac11_mag" .. i, title_id = "debug_mac11_short", subtitle_id = "debug_upgrade_mag" .. i, icon = "mac11", image = "upgrades_mac10", image_slice = "upgrades_mac10_slice", description_text_id = "clip_ammo_increase", depends_on = depends_on, unlock_lvl = unlock_lvl}, {category = "mac11", upgrade = "clip_ammo_increase", value = i}, prio
  end
end

UpgradesTweakData._remington_definitions = function(l_55_0)
   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

  l_55_0.definitions.r870_shotgun, {tree = 3, step = 13, category = "weapon", weapon_id = "r870_shotgun", unit_name = Idstring("units/weapons/r870_shotgun/r870_shotgun"), name_id = "debug_r870_shotgun", title_id = "debug_upgrade_new_weapon", subtitle_id = "debug_r870_shotgun_short", icon = "r870_shotgun", image = "upgrades_remington", image_slice = "upgrades_remington_slice", unlock_lvl = 1}.description_text_id, {tree = 3, step = 13, category = "weapon", weapon_id = "r870_shotgun", unit_name = Idstring("units/weapons/r870_shotgun/r870_shotgun"), name_id = "debug_r870_shotgun", title_id = "debug_upgrade_new_weapon", subtitle_id = "debug_r870_shotgun_short", icon = "r870_shotgun", image = "upgrades_remington", image_slice = "upgrades_remington_slice", unlock_lvl = 1}.prio = {tree = 3, step = 13, category = "weapon", weapon_id = "r870_shotgun", unit_name = Idstring("units/weapons/r870_shotgun/r870_shotgun"), name_id = "debug_r870_shotgun", title_id = "debug_upgrade_new_weapon", subtitle_id = "debug_r870_shotgun_short", icon = "r870_shotgun", image = "upgrades_remington", image_slice = "upgrades_remington_slice", unlock_lvl = 1}, "des_r870_shotgun", "high"
  for i,_ in ipairs(l_55_0.values.r870_shotgun.clip_ammo_increase) do
    local depends_on = i - 1 > 0 and "remington_mag" .. i - 1 or "r870_shotgun"
    local unlock_lvl = 2
    local prio = (i == 1 and "high")
     -- DECOMPILER ERROR: Confused about usage of registers!

     -- DECOMPILER ERROR: Confused about usage of registers!

    l_55_0.definitions.remington_mag" .. , {tree = 3, step = l_55_0.steps.r870_shotgun.clip_ammo_increase[i], category = "feature", name_id = "debug_upgrade_remington_mag" .. i, title_id = "debug_r870_shotgun_short", subtitle_id = "debug_upgrade_mag" .. i, icon = "r870_shotgun", image = "upgrades_remington", image_slice = "upgrades_remington_slice", description_text_id = "clip_ammo_increase", depends_on = depends_on, unlock_lvl = unlock_lvl}.upgrade, {tree = 3, step = l_55_0.steps.r870_shotgun.clip_ammo_increase[i], category = "feature", name_id = "debug_upgrade_remington_mag" .. i, title_id = "debug_r870_shotgun_short", subtitle_id = "debug_upgrade_mag" .. i, icon = "r870_shotgun", image = "upgrades_remington", image_slice = "upgrades_remington_slice", description_text_id = "clip_ammo_increase", depends_on = depends_on, unlock_lvl = unlock_lvl}.prio = {tree = 3, step = l_55_0.steps.r870_shotgun.clip_ammo_increase[i], category = "feature", name_id = "debug_upgrade_remington_mag" .. i, title_id = "debug_r870_shotgun_short", subtitle_id = "debug_upgrade_mag" .. i, icon = "r870_shotgun", image = "upgrades_remington", image_slice = "upgrades_remington_slice", description_text_id = "clip_ammo_increase", depends_on = depends_on, unlock_lvl = unlock_lvl}, {category = "r870_shotgun", upgrade = "clip_ammo_increase", value = i}, prio
  end
  for i,_ in ipairs(l_55_0.values.r870_shotgun.recoil_multiplier) do
    local depends_on = i - 1 > 0 and "remington_recoil" .. i - 1 or "r870_shotgun"
    local unlock_lvl = 3
    local prio = (i == 1 and "high")
     -- DECOMPILER ERROR: Confused about usage of registers!

     -- DECOMPILER ERROR: Confused about usage of registers!

    l_55_0.definitions.remington_recoil" .. , {tree = 3, step = l_55_0.steps.r870_shotgun.recoil_multiplier[i], category = "feature", name_id = "debug_upgrade_remington_recoil" .. i, title_id = "debug_r870_shotgun_short", subtitle_id = "debug_upgrade_recoil" .. i, icon = "r870_shotgun", image = "upgrades_remington", image_slice = "upgrades_remington_slice", description_text_id = "recoil_multiplier", depends_on = depends_on, unlock_lvl = unlock_lvl}.upgrade, {tree = 3, step = l_55_0.steps.r870_shotgun.recoil_multiplier[i], category = "feature", name_id = "debug_upgrade_remington_recoil" .. i, title_id = "debug_r870_shotgun_short", subtitle_id = "debug_upgrade_recoil" .. i, icon = "r870_shotgun", image = "upgrades_remington", image_slice = "upgrades_remington_slice", description_text_id = "recoil_multiplier", depends_on = depends_on, unlock_lvl = unlock_lvl}.prio = {tree = 3, step = l_55_0.steps.r870_shotgun.recoil_multiplier[i], category = "feature", name_id = "debug_upgrade_remington_recoil" .. i, title_id = "debug_r870_shotgun_short", subtitle_id = "debug_upgrade_recoil" .. i, icon = "r870_shotgun", image = "upgrades_remington", image_slice = "upgrades_remington_slice", description_text_id = "recoil_multiplier", depends_on = depends_on, unlock_lvl = unlock_lvl}, {category = "r870_shotgun", upgrade = "recoil_multiplier", value = i}, prio
  end
  for i,_ in ipairs(l_55_0.values.r870_shotgun.damage_multiplier) do
    local depends_on = i - 1 > 0 and "remington_damage" .. i - 1 or "r870_shotgun"
    local unlock_lvl = 4
    local prio = (i == 1 and "high")
     -- DECOMPILER ERROR: Confused about usage of registers!

     -- DECOMPILER ERROR: Confused about usage of registers!

    l_55_0.definitions.remington_damage" .. , {tree = 3, step = l_55_0.steps.r870_shotgun.damage_multiplier[i], category = "feature", name_id = "debug_upgrade_remington_damage" .. i, title_id = "debug_r870_shotgun_short", subtitle_id = "debug_upgrade_damage" .. i, icon = "r870_shotgun", image = "upgrades_remington", image_slice = "upgrades_remington_slice", description_text_id = "damage_multiplier", depends_on = depends_on, unlock_lvl = unlock_lvl}.upgrade, {tree = 3, step = l_55_0.steps.r870_shotgun.damage_multiplier[i], category = "feature", name_id = "debug_upgrade_remington_damage" .. i, title_id = "debug_r870_shotgun_short", subtitle_id = "debug_upgrade_damage" .. i, icon = "r870_shotgun", image = "upgrades_remington", image_slice = "upgrades_remington_slice", description_text_id = "damage_multiplier", depends_on = depends_on, unlock_lvl = unlock_lvl}.prio = {tree = 3, step = l_55_0.steps.r870_shotgun.damage_multiplier[i], category = "feature", name_id = "debug_upgrade_remington_damage" .. i, title_id = "debug_r870_shotgun_short", subtitle_id = "debug_upgrade_damage" .. i, icon = "r870_shotgun", image = "upgrades_remington", image_slice = "upgrades_remington_slice", description_text_id = "damage_multiplier", depends_on = depends_on, unlock_lvl = unlock_lvl}, {category = "r870_shotgun", upgrade = "damage_multiplier", value = i}, prio
  end
end

UpgradesTweakData._mossberg_definitions = function(l_56_0)
   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

  l_56_0.definitions.mossberg, {tree = 2, step = 7, category = "weapon", weapon_id = "mossberg", unit_name = Idstring("units/weapons/mossberg/mossberg"), name_id = "debug_mossberg", title_id = "debug_upgrade_new_weapon", subtitle_id = "debug_mossberg_short", icon = "mossberg", image = "upgrades_mossberg", image_slice = "upgrades_mossberg_slice", unlock_lvl = 120}.description_text_id, {tree = 2, step = 7, category = "weapon", weapon_id = "mossberg", unit_name = Idstring("units/weapons/mossberg/mossberg"), name_id = "debug_mossberg", title_id = "debug_upgrade_new_weapon", subtitle_id = "debug_mossberg_short", icon = "mossberg", image = "upgrades_mossberg", image_slice = "upgrades_mossberg_slice", unlock_lvl = 120}.prio = {tree = 2, step = 7, category = "weapon", weapon_id = "mossberg", unit_name = Idstring("units/weapons/mossberg/mossberg"), name_id = "debug_mossberg", title_id = "debug_upgrade_new_weapon", subtitle_id = "debug_mossberg_short", icon = "mossberg", image = "upgrades_mossberg", image_slice = "upgrades_mossberg_slice", unlock_lvl = 120}, "des_mossberg", "high"
  for i,_ in ipairs(l_56_0.values.mossberg.clip_ammo_increase) do
    local depends_on = i - 1 > 0 and "mossberg_mag" .. i - 1 or "mossberg"
    local unlock_lvl = 121
    local prio = (i == 1 and "high")
     -- DECOMPILER ERROR: Confused about usage of registers!

     -- DECOMPILER ERROR: Confused about usage of registers!

    l_56_0.definitions.mossberg_mag" .. , {tree = 2, step = l_56_0.steps.mossberg.clip_ammo_increase[i], category = "feature", name_id = "debug_upgrade_mossberg_mag" .. i, title_id = "debug_mossberg_short", subtitle_id = "debug_upgrade_mag" .. i, icon = "mossberg", image = "upgrades_mossberg", image_slice = "upgrades_mossberg_slice", description_text_id = "clip_ammo_increase", depends_on = depends_on, unlock_lvl = unlock_lvl}.upgrade, {tree = 2, step = l_56_0.steps.mossberg.clip_ammo_increase[i], category = "feature", name_id = "debug_upgrade_mossberg_mag" .. i, title_id = "debug_mossberg_short", subtitle_id = "debug_upgrade_mag" .. i, icon = "mossberg", image = "upgrades_mossberg", image_slice = "upgrades_mossberg_slice", description_text_id = "clip_ammo_increase", depends_on = depends_on, unlock_lvl = unlock_lvl}.prio = {tree = 2, step = l_56_0.steps.mossberg.clip_ammo_increase[i], category = "feature", name_id = "debug_upgrade_mossberg_mag" .. i, title_id = "debug_mossberg_short", subtitle_id = "debug_upgrade_mag" .. i, icon = "mossberg", image = "upgrades_mossberg", image_slice = "upgrades_mossberg_slice", description_text_id = "clip_ammo_increase", depends_on = depends_on, unlock_lvl = unlock_lvl}, {category = "mossberg", upgrade = "clip_ammo_increase", value = i}, prio
  end
  for i,_ in ipairs(l_56_0.values.mossberg.reload_speed_multiplier) do
    local depends_on = i - 1 > 0 and "mossberg_reload_speed" .. i - 1 or "mossberg"
    local unlock_lvl = 121
    local prio = (i == 1 and "high")
     -- DECOMPILER ERROR: Confused about usage of registers!

     -- DECOMPILER ERROR: Confused about usage of registers!

    l_56_0.definitions.mossberg_reload_speed" .. , {tree = 2, step = l_56_0.steps.mossberg.reload_speed_multiplier[i], category = "feature", name_id = "debug_upgrade_mossberg_reload_speed" .. i, title_id = "debug_mossberg_short", subtitle_id = "debug_upgrade_reload_speed" .. i, icon = "mossberg", image = "upgrades_mossberg", image_slice = "upgrades_mossberg_slice", description_text_id = "reload_speed_multiplier", depends_on = depends_on, unlock_lvl = unlock_lvl}.upgrade, {tree = 2, step = l_56_0.steps.mossberg.reload_speed_multiplier[i], category = "feature", name_id = "debug_upgrade_mossberg_reload_speed" .. i, title_id = "debug_mossberg_short", subtitle_id = "debug_upgrade_reload_speed" .. i, icon = "mossberg", image = "upgrades_mossberg", image_slice = "upgrades_mossberg_slice", description_text_id = "reload_speed_multiplier", depends_on = depends_on, unlock_lvl = unlock_lvl}.prio = {tree = 2, step = l_56_0.steps.mossberg.reload_speed_multiplier[i], category = "feature", name_id = "debug_upgrade_mossberg_reload_speed" .. i, title_id = "debug_mossberg_short", subtitle_id = "debug_upgrade_reload_speed" .. i, icon = "mossberg", image = "upgrades_mossberg", image_slice = "upgrades_mossberg_slice", description_text_id = "reload_speed_multiplier", depends_on = depends_on, unlock_lvl = unlock_lvl}, {category = "mossberg", upgrade = "reload_speed_multiplier", value = i}, prio
  end
  for i,_ in ipairs(l_56_0.values.mossberg.fire_rate_multiplier) do
    local depends_on = i - 1 > 0 and "mossberg_fire_rate_multiplier" .. i - 1 or "mossberg"
    local unlock_lvl = 121
    local prio = (i == 1 and "high")
     -- DECOMPILER ERROR: Confused about usage of registers!

     -- DECOMPILER ERROR: Confused about usage of registers!

    l_56_0.definitions.mossberg_fire_rate_multiplier" .. , {tree = 2, step = l_56_0.steps.mossberg.fire_rate_multiplier[i], category = "feature", name_id = "debug_upgrade_mossberg_fire_rate" .. i, title_id = "debug_mossberg_short", subtitle_id = "debug_upgrade_fire_rate" .. i, icon = "mossberg", image = "upgrades_mossberg", image_slice = "upgrades_mossberg_slice", description_text_id = "fire_rate_multiplier", depends_on = depends_on, unlock_lvl = unlock_lvl}.upgrade, {tree = 2, step = l_56_0.steps.mossberg.fire_rate_multiplier[i], category = "feature", name_id = "debug_upgrade_mossberg_fire_rate" .. i, title_id = "debug_mossberg_short", subtitle_id = "debug_upgrade_fire_rate" .. i, icon = "mossberg", image = "upgrades_mossberg", image_slice = "upgrades_mossberg_slice", description_text_id = "fire_rate_multiplier", depends_on = depends_on, unlock_lvl = unlock_lvl}.prio = {tree = 2, step = l_56_0.steps.mossberg.fire_rate_multiplier[i], category = "feature", name_id = "debug_upgrade_mossberg_fire_rate" .. i, title_id = "debug_mossberg_short", subtitle_id = "debug_upgrade_fire_rate" .. i, icon = "mossberg", image = "upgrades_mossberg", image_slice = "upgrades_mossberg_slice", description_text_id = "fire_rate_multiplier", depends_on = depends_on, unlock_lvl = unlock_lvl}, {category = "mossberg", upgrade = "fire_rate_multiplier", value = i}, prio
  end
  for i,_ in ipairs(l_56_0.values.mossberg.recoil_multiplier) do
    local depends_on = i - 1 > 0 and "mossberg_recoil_multiplier" .. i - 1 or "mossberg"
    local unlock_lvl = 121
    local prio = (i == 1 and "high")
     -- DECOMPILER ERROR: Confused about usage of registers!

     -- DECOMPILER ERROR: Confused about usage of registers!

    l_56_0.definitions.mossberg_recoil_multiplier" .. , {tree = 2, step = l_56_0.steps.mossberg.recoil_multiplier[i], category = "feature", name_id = "debug_upgrade_mossberg_recoil_multiplier" .. i, title_id = "debug_mossberg_short", subtitle_id = "debug_upgrade_recoil" .. i, icon = "mossberg", image = "upgrades_mossberg", image_slice = "upgrades_mossberg_slice", description_text_id = "recoil_multiplier", depends_on = depends_on, unlock_lvl = unlock_lvl}.upgrade, {tree = 2, step = l_56_0.steps.mossberg.recoil_multiplier[i], category = "feature", name_id = "debug_upgrade_mossberg_recoil_multiplier" .. i, title_id = "debug_mossberg_short", subtitle_id = "debug_upgrade_recoil" .. i, icon = "mossberg", image = "upgrades_mossberg", image_slice = "upgrades_mossberg_slice", description_text_id = "recoil_multiplier", depends_on = depends_on, unlock_lvl = unlock_lvl}.prio = {tree = 2, step = l_56_0.steps.mossberg.recoil_multiplier[i], category = "feature", name_id = "debug_upgrade_mossberg_recoil_multiplier" .. i, title_id = "debug_mossberg_short", subtitle_id = "debug_upgrade_recoil" .. i, icon = "mossberg", image = "upgrades_mossberg", image_slice = "upgrades_mossberg_slice", description_text_id = "recoil_multiplier", depends_on = depends_on, unlock_lvl = unlock_lvl}, {category = "mossberg", upgrade = "recoil_multiplier", value = i}, prio
  end
end

UpgradesTweakData._hk21_definitions = function(l_57_0)
   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

  l_57_0.definitions.hk21, {tree = 1, step = 22, category = "weapon", weapon_id = "hk21", unit_name = Idstring("units/weapons/hk21/hk21"), name_id = "debug_hk21", title_id = "debug_upgrade_new_weapon", subtitle_id = "debug_hk21_short", icon = "hk21", image = "upgrades_hk21", image_slice = "upgrades_hk21_slice", unlock_lvl = 140}.description_text_id, {tree = 1, step = 22, category = "weapon", weapon_id = "hk21", unit_name = Idstring("units/weapons/hk21/hk21"), name_id = "debug_hk21", title_id = "debug_upgrade_new_weapon", subtitle_id = "debug_hk21_short", icon = "hk21", image = "upgrades_hk21", image_slice = "upgrades_hk21_slice", unlock_lvl = 140}.prio = {tree = 1, step = 22, category = "weapon", weapon_id = "hk21", unit_name = Idstring("units/weapons/hk21/hk21"), name_id = "debug_hk21", title_id = "debug_upgrade_new_weapon", subtitle_id = "debug_hk21_short", icon = "hk21", image = "upgrades_hk21", image_slice = "upgrades_hk21_slice", unlock_lvl = 140}, "des_hk21", "high"
  for i,_ in ipairs(l_57_0.values.hk21.clip_ammo_increase) do
    local depends_on = i - 1 > 0 and "hk21_mag" .. i - 1 or "hk21"
    local unlock_lvl = 141
    local prio = (i == 1 and "high")
     -- DECOMPILER ERROR: Confused about usage of registers!

     -- DECOMPILER ERROR: Confused about usage of registers!

    l_57_0.definitions.hk21_mag" .. , {tree = 1, step = l_57_0.steps.hk21.clip_ammo_increase[i], category = "feature", name_id = "debug_upgrade_hk21_mag" .. i, title_id = "debug_hk21_short", subtitle_id = "debug_upgrade_mag" .. i, icon = "hk21", image = "upgrades_hk21", image_slice = "upgrades_hk21_slice", description_text_id = "clip_ammo_increase", depends_on = depends_on, unlock_lvl = unlock_lvl}.upgrade, {tree = 1, step = l_57_0.steps.hk21.clip_ammo_increase[i], category = "feature", name_id = "debug_upgrade_hk21_mag" .. i, title_id = "debug_hk21_short", subtitle_id = "debug_upgrade_mag" .. i, icon = "hk21", image = "upgrades_hk21", image_slice = "upgrades_hk21_slice", description_text_id = "clip_ammo_increase", depends_on = depends_on, unlock_lvl = unlock_lvl}.prio = {tree = 1, step = l_57_0.steps.hk21.clip_ammo_increase[i], category = "feature", name_id = "debug_upgrade_hk21_mag" .. i, title_id = "debug_hk21_short", subtitle_id = "debug_upgrade_mag" .. i, icon = "hk21", image = "upgrades_hk21", image_slice = "upgrades_hk21_slice", description_text_id = "clip_ammo_increase", depends_on = depends_on, unlock_lvl = unlock_lvl}, {category = "hk21", upgrade = "clip_ammo_increase", value = i}, prio
  end
  for i,_ in ipairs(l_57_0.values.hk21.recoil_multiplier) do
    local depends_on = i - 1 > 0 and "hk21_recoil" .. i - 1 or "hk21"
    local unlock_lvl = 141
    local prio = (i == 1 and "high")
     -- DECOMPILER ERROR: Confused about usage of registers!

     -- DECOMPILER ERROR: Confused about usage of registers!

    l_57_0.definitions.hk21_recoil" .. , {tree = 1, step = l_57_0.steps.hk21.recoil_multiplier[i], category = "feature", name_id = "debug_upgrade_hk21_recoil" .. i, title_id = "debug_hk21_short", subtitle_id = "debug_upgrade_recoil" .. i, icon = "hk21", image = "upgrades_hk21", image_slice = "upgrades_hk21_slice", description_text_id = "recoil_multiplier", depends_on = depends_on, unlock_lvl = unlock_lvl}.upgrade, {tree = 1, step = l_57_0.steps.hk21.recoil_multiplier[i], category = "feature", name_id = "debug_upgrade_hk21_recoil" .. i, title_id = "debug_hk21_short", subtitle_id = "debug_upgrade_recoil" .. i, icon = "hk21", image = "upgrades_hk21", image_slice = "upgrades_hk21_slice", description_text_id = "recoil_multiplier", depends_on = depends_on, unlock_lvl = unlock_lvl}.prio = {tree = 1, step = l_57_0.steps.hk21.recoil_multiplier[i], category = "feature", name_id = "debug_upgrade_hk21_recoil" .. i, title_id = "debug_hk21_short", subtitle_id = "debug_upgrade_recoil" .. i, icon = "hk21", image = "upgrades_hk21", image_slice = "upgrades_hk21_slice", description_text_id = "recoil_multiplier", depends_on = depends_on, unlock_lvl = unlock_lvl}, {category = "hk21", upgrade = "recoil_multiplier", value = i}, prio
  end
  for i,_ in ipairs(l_57_0.values.hk21.damage_multiplier) do
    local depends_on = i - 1 > 0 and "hk21_damage" .. i - 1 or "hk21"
    local unlock_lvl = 141
    local prio = (i == 1 and "high")
     -- DECOMPILER ERROR: Confused about usage of registers!

     -- DECOMPILER ERROR: Confused about usage of registers!

    l_57_0.definitions.hk21_damage" .. , {tree = 1, step = l_57_0.steps.hk21.damage_multiplier[i], category = "feature", name_id = "debug_upgrade_hk21_damage" .. i, title_id = "debug_hk21_short", subtitle_id = "debug_upgrade_damage" .. i, icon = "hk21", image = "upgrades_hk21", image_slice = "upgrades_hk21_slice", description_text_id = "damage_multiplier", depends_on = depends_on, unlock_lvl = unlock_lvl}.upgrade, {tree = 1, step = l_57_0.steps.hk21.damage_multiplier[i], category = "feature", name_id = "debug_upgrade_hk21_damage" .. i, title_id = "debug_hk21_short", subtitle_id = "debug_upgrade_damage" .. i, icon = "hk21", image = "upgrades_hk21", image_slice = "upgrades_hk21_slice", description_text_id = "damage_multiplier", depends_on = depends_on, unlock_lvl = unlock_lvl}.prio = {tree = 1, step = l_57_0.steps.hk21.damage_multiplier[i], category = "feature", name_id = "debug_upgrade_hk21_damage" .. i, title_id = "debug_hk21_short", subtitle_id = "debug_upgrade_damage" .. i, icon = "hk21", image = "upgrades_hk21", image_slice = "upgrades_hk21_slice", description_text_id = "damage_multiplier", depends_on = depends_on, unlock_lvl = unlock_lvl}, {category = "hk21", upgrade = "damage_multiplier", value = i}, prio
  end
end

UpgradesTweakData._ak47_definitions = function(l_58_0)
   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

  l_58_0.definitions.ak47, {tree = 4, step = 9, category = "weapon", weapon_id = "ak47", unit_name = Idstring("units/weapons/ak47/ak"), name_id = "debug_ak47", title_id = "debug_upgrade_new_weapon", subtitle_id = "debug_ak47_short", icon = "ak", image = "upgrades_ak", image_slice = "upgrades_ak_slice", unlock_lvl = 0}.description_text_id, {tree = 4, step = 9, category = "weapon", weapon_id = "ak47", unit_name = Idstring("units/weapons/ak47/ak"), name_id = "debug_ak47", title_id = "debug_upgrade_new_weapon", subtitle_id = "debug_ak47_short", icon = "ak", image = "upgrades_ak", image_slice = "upgrades_ak_slice", unlock_lvl = 0}.prio = {tree = 4, step = 9, category = "weapon", weapon_id = "ak47", unit_name = Idstring("units/weapons/ak47/ak"), name_id = "debug_ak47", title_id = "debug_upgrade_new_weapon", subtitle_id = "debug_ak47_short", icon = "ak", image = "upgrades_ak", image_slice = "upgrades_ak_slice", unlock_lvl = 0}, "des_ak47", "high"
  for i,_ in ipairs(l_58_0.values.ak47.damage_multiplier) do
    local depends_on = i - 1 > 0 and "ak47_damage" .. i - 1 or "ak47"
    local unlock_lvl = 141
    local prio = (i == 1 and "high")
     -- DECOMPILER ERROR: Confused about usage of registers!

     -- DECOMPILER ERROR: Confused about usage of registers!

    l_58_0.definitions.ak47_damage" .. , {tree = 4, step = l_58_0.steps.ak47.damage_multiplier[i], category = "feature", name_id = "debug_upgrade_ak47_damage" .. i, title_id = "debug_ak47_short", subtitle_id = "debug_upgrade_damage" .. i, icon = "ak", image = "upgrades_ak", image_slice = "upgrades_ak_slice", description_text_id = "damage_multiplier", depends_on = depends_on, unlock_lvl = unlock_lvl}.upgrade, {tree = 4, step = l_58_0.steps.ak47.damage_multiplier[i], category = "feature", name_id = "debug_upgrade_ak47_damage" .. i, title_id = "debug_ak47_short", subtitle_id = "debug_upgrade_damage" .. i, icon = "ak", image = "upgrades_ak", image_slice = "upgrades_ak_slice", description_text_id = "damage_multiplier", depends_on = depends_on, unlock_lvl = unlock_lvl}.prio = {tree = 4, step = l_58_0.steps.ak47.damage_multiplier[i], category = "feature", name_id = "debug_upgrade_ak47_damage" .. i, title_id = "debug_ak47_short", subtitle_id = "debug_upgrade_damage" .. i, icon = "ak", image = "upgrades_ak", image_slice = "upgrades_ak_slice", description_text_id = "damage_multiplier", depends_on = depends_on, unlock_lvl = unlock_lvl}, {category = "ak47", upgrade = "damage_multiplier", value = i}, prio
  end
  for i,_ in ipairs(l_58_0.values.ak47.recoil_multiplier) do
    local depends_on = i - 1 > 0 and "ak47_recoil" .. i - 1 or "ak47"
    local unlock_lvl = 141
    local prio = (i == 1 and "high")
     -- DECOMPILER ERROR: Confused about usage of registers!

     -- DECOMPILER ERROR: Confused about usage of registers!

    l_58_0.definitions.ak47_recoil" .. , {tree = 4, step = l_58_0.steps.ak47.recoil_multiplier[i], category = "feature", name_id = "debug_upgrade_ak47_recoil" .. i, title_id = "debug_ak47_short", subtitle_id = "debug_upgrade_recoil" .. i, icon = "ak", image = "upgrades_ak", image_slice = "upgrades_ak_slice", description_text_id = "recoil_multiplier", depends_on = depends_on, unlock_lvl = unlock_lvl}.upgrade, {tree = 4, step = l_58_0.steps.ak47.recoil_multiplier[i], category = "feature", name_id = "debug_upgrade_ak47_recoil" .. i, title_id = "debug_ak47_short", subtitle_id = "debug_upgrade_recoil" .. i, icon = "ak", image = "upgrades_ak", image_slice = "upgrades_ak_slice", description_text_id = "recoil_multiplier", depends_on = depends_on, unlock_lvl = unlock_lvl}.prio = {tree = 4, step = l_58_0.steps.ak47.recoil_multiplier[i], category = "feature", name_id = "debug_upgrade_ak47_recoil" .. i, title_id = "debug_ak47_short", subtitle_id = "debug_upgrade_recoil" .. i, icon = "ak", image = "upgrades_ak", image_slice = "upgrades_ak_slice", description_text_id = "recoil_multiplier", depends_on = depends_on, unlock_lvl = unlock_lvl}, {category = "ak47", upgrade = "recoil_multiplier", value = i}, prio
  end
  for i,_ in ipairs(l_58_0.values.ak47.spread_multiplier) do
    local depends_on = i - 1 > 0 and "ak47_spread" .. i - 1 or "ak47"
    local unlock_lvl = 141
    local prio = (i == 1 and "high")
     -- DECOMPILER ERROR: Confused about usage of registers!

     -- DECOMPILER ERROR: Confused about usage of registers!

    l_58_0.definitions.ak47_spread" .. , {tree = 4, step = l_58_0.steps.ak47.spread_multiplier[i], category = "feature", name_id = "debug_upgrade_ak47_spread" .. i, title_id = "debug_ak47_short", subtitle_id = "debug_upgrade_spread" .. i, icon = "ak", image = "upgrades_ak", image_slice = "upgrades_ak_slice", description_text_id = "spread_multiplier", depends_on = depends_on, unlock_lvl = unlock_lvl}.upgrade, {tree = 4, step = l_58_0.steps.ak47.spread_multiplier[i], category = "feature", name_id = "debug_upgrade_ak47_spread" .. i, title_id = "debug_ak47_short", subtitle_id = "debug_upgrade_spread" .. i, icon = "ak", image = "upgrades_ak", image_slice = "upgrades_ak_slice", description_text_id = "spread_multiplier", depends_on = depends_on, unlock_lvl = unlock_lvl}.prio = {tree = 4, step = l_58_0.steps.ak47.spread_multiplier[i], category = "feature", name_id = "debug_upgrade_ak47_spread" .. i, title_id = "debug_ak47_short", subtitle_id = "debug_upgrade_spread" .. i, icon = "ak", image = "upgrades_ak", image_slice = "upgrades_ak_slice", description_text_id = "spread_multiplier", depends_on = depends_on, unlock_lvl = unlock_lvl}, {category = "ak47", upgrade = "spread_multiplier", value = i}, prio
  end
  for i,_ in ipairs(l_58_0.values.ak47.clip_ammo_increase) do
    local depends_on = i - 1 > 0 and "ak47_mag" .. i - 1 or "ak47"
    local unlock_lvl = 141
    local prio = (i == 1 and "high")
     -- DECOMPILER ERROR: Confused about usage of registers!

     -- DECOMPILER ERROR: Confused about usage of registers!

    l_58_0.definitions.ak47_mag" .. , {tree = 4, step = l_58_0.steps.ak47.clip_ammo_increase[i], category = "feature", name_id = "debug_upgrade_ak47_mag" .. i, title_id = "debug_ak47_short", subtitle_id = "debug_upgrade_mag" .. i, icon = "ak", image = "upgrades_ak", image_slice = "upgrades_ak_slice", description_text_id = "clip_ammo_increase", depends_on = depends_on, unlock_lvl = unlock_lvl}.upgrade, {tree = 4, step = l_58_0.steps.ak47.clip_ammo_increase[i], category = "feature", name_id = "debug_upgrade_ak47_mag" .. i, title_id = "debug_ak47_short", subtitle_id = "debug_upgrade_mag" .. i, icon = "ak", image = "upgrades_ak", image_slice = "upgrades_ak_slice", description_text_id = "clip_ammo_increase", depends_on = depends_on, unlock_lvl = unlock_lvl}.prio = {tree = 4, step = l_58_0.steps.ak47.clip_ammo_increase[i], category = "feature", name_id = "debug_upgrade_ak47_mag" .. i, title_id = "debug_ak47_short", subtitle_id = "debug_upgrade_mag" .. i, icon = "ak", image = "upgrades_ak", image_slice = "upgrades_ak_slice", description_text_id = "clip_ammo_increase", depends_on = depends_on, unlock_lvl = unlock_lvl}, {category = "ak47", upgrade = "clip_ammo_increase", value = i}, prio
  end
end

UpgradesTweakData._glock_definitions = function(l_59_0)
   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

  l_59_0.definitions.glock, {tree = 4, step = 2, category = "weapon", weapon_id = "glock", unit_name = Idstring("units/weapons/glock/glock"), name_id = "debug_glock", title_id = "debug_upgrade_new_weapon", subtitle_id = "debug_glock_short", icon = "glock", image = "upgrades_glock", image_slice = "upgrades_glock_slice", unlock_lvl = 0}.description_text_id, {tree = 4, step = 2, category = "weapon", weapon_id = "glock", unit_name = Idstring("units/weapons/glock/glock"), name_id = "debug_glock", title_id = "debug_upgrade_new_weapon", subtitle_id = "debug_glock_short", icon = "glock", image = "upgrades_glock", image_slice = "upgrades_glock_slice", unlock_lvl = 0}.prio = {tree = 4, step = 2, category = "weapon", weapon_id = "glock", unit_name = Idstring("units/weapons/glock/glock"), name_id = "debug_glock", title_id = "debug_upgrade_new_weapon", subtitle_id = "debug_glock_short", icon = "glock", image = "upgrades_glock", image_slice = "upgrades_glock_slice", unlock_lvl = 0}, "des_glock", "high"
  for i,_ in ipairs(l_59_0.values.glock.damage_multiplier) do
    local depends_on = i - 1 > 0 and "glock_damage" .. i - 1 or "glock"
    local unlock_lvl = 141
    local prio = (i == 1 and "high")
     -- DECOMPILER ERROR: Confused about usage of registers!

     -- DECOMPILER ERROR: Confused about usage of registers!

    l_59_0.definitions.glock_damage" .. , {tree = 4, step = l_59_0.steps.glock.damage_multiplier[i], category = "feature", name_id = "debug_upgrade_glock_damage" .. i, title_id = "debug_glock_short", subtitle_id = "debug_upgrade_damage" .. i, icon = "glock", image = "upgrades_glock", image_slice = "upgrades_glock_slice", description_text_id = "damage_multiplier", depends_on = depends_on, unlock_lvl = unlock_lvl}.upgrade, {tree = 4, step = l_59_0.steps.glock.damage_multiplier[i], category = "feature", name_id = "debug_upgrade_glock_damage" .. i, title_id = "debug_glock_short", subtitle_id = "debug_upgrade_damage" .. i, icon = "glock", image = "upgrades_glock", image_slice = "upgrades_glock_slice", description_text_id = "damage_multiplier", depends_on = depends_on, unlock_lvl = unlock_lvl}.prio = {tree = 4, step = l_59_0.steps.glock.damage_multiplier[i], category = "feature", name_id = "debug_upgrade_glock_damage" .. i, title_id = "debug_glock_short", subtitle_id = "debug_upgrade_damage" .. i, icon = "glock", image = "upgrades_glock", image_slice = "upgrades_glock_slice", description_text_id = "damage_multiplier", depends_on = depends_on, unlock_lvl = unlock_lvl}, {category = "glock", upgrade = "damage_multiplier", value = i}, prio
  end
  for i,_ in ipairs(l_59_0.values.glock.recoil_multiplier) do
    local depends_on = i - 1 > 0 and "glock_recoil" .. i - 1 or "glock"
    local unlock_lvl = 141
    local prio = (i == 1 and "high")
     -- DECOMPILER ERROR: Confused about usage of registers!

     -- DECOMPILER ERROR: Confused about usage of registers!

    l_59_0.definitions.glock_recoil" .. , {tree = 4, step = l_59_0.steps.glock.recoil_multiplier[i], category = "feature", name_id = "debug_upgrade_glock_recoil" .. i, title_id = "debug_glock_short", subtitle_id = "debug_upgrade_recoil" .. i, icon = "glock", image = "upgrades_glock", image_slice = "upgrades_glock_slice", description_text_id = "recoil_multiplier", depends_on = depends_on, unlock_lvl = unlock_lvl}.upgrade, {tree = 4, step = l_59_0.steps.glock.recoil_multiplier[i], category = "feature", name_id = "debug_upgrade_glock_recoil" .. i, title_id = "debug_glock_short", subtitle_id = "debug_upgrade_recoil" .. i, icon = "glock", image = "upgrades_glock", image_slice = "upgrades_glock_slice", description_text_id = "recoil_multiplier", depends_on = depends_on, unlock_lvl = unlock_lvl}.prio = {tree = 4, step = l_59_0.steps.glock.recoil_multiplier[i], category = "feature", name_id = "debug_upgrade_glock_recoil" .. i, title_id = "debug_glock_short", subtitle_id = "debug_upgrade_recoil" .. i, icon = "glock", image = "upgrades_glock", image_slice = "upgrades_glock_slice", description_text_id = "recoil_multiplier", depends_on = depends_on, unlock_lvl = unlock_lvl}, {category = "glock", upgrade = "recoil_multiplier", value = i}, prio
  end
  for i,_ in ipairs(l_59_0.values.glock.clip_ammo_increase) do
    local depends_on = i - 1 > 0 and "glock_mag" .. i - 1 or "glock"
    local unlock_lvl = 141
    local prio = (i == 1 and "high")
     -- DECOMPILER ERROR: Confused about usage of registers!

     -- DECOMPILER ERROR: Confused about usage of registers!

    l_59_0.definitions.glock_mag" .. , {tree = 4, step = l_59_0.steps.glock.clip_ammo_increase[i], category = "feature", name_id = "debug_upgrade_glock_mag" .. i, title_id = "debug_glock_short", subtitle_id = "debug_upgrade_mag" .. i, icon = "glock", image = "upgrades_glock", image_slice = "upgrades_glock_slice", description_text_id = "clip_ammo_increase", depends_on = depends_on, unlock_lvl = unlock_lvl}.upgrade, {tree = 4, step = l_59_0.steps.glock.clip_ammo_increase[i], category = "feature", name_id = "debug_upgrade_glock_mag" .. i, title_id = "debug_glock_short", subtitle_id = "debug_upgrade_mag" .. i, icon = "glock", image = "upgrades_glock", image_slice = "upgrades_glock_slice", description_text_id = "clip_ammo_increase", depends_on = depends_on, unlock_lvl = unlock_lvl}.prio = {tree = 4, step = l_59_0.steps.glock.clip_ammo_increase[i], category = "feature", name_id = "debug_upgrade_glock_mag" .. i, title_id = "debug_glock_short", subtitle_id = "debug_upgrade_mag" .. i, icon = "glock", image = "upgrades_glock", image_slice = "upgrades_glock_slice", description_text_id = "clip_ammo_increase", depends_on = depends_on, unlock_lvl = unlock_lvl}, {category = "glock", upgrade = "clip_ammo_increase", value = i}, prio
  end
  for i,_ in ipairs(l_59_0.values.glock.reload_speed_multiplier) do
    local depends_on = i - 1 > 0 and "glock_reload_speed" .. i - 1 or "glock"
    local unlock_lvl = 141
    local prio = (i == 1 and "high")
     -- DECOMPILER ERROR: Confused about usage of registers!

     -- DECOMPILER ERROR: Confused about usage of registers!

    l_59_0.definitions.glock_reload_speed" .. , {tree = 4, step = l_59_0.steps.glock.reload_speed_multiplier[i], category = "feature", name_id = "debug_upgrade_glock_reload_speed" .. i, title_id = "debug_glock_short", subtitle_id = "debug_upgrade_reload_speed" .. i, icon = "glock", image = "upgrades_glock", image_slice = "upgrades_glock_slice", description_text_id = "reload_speed_multiplier", depends_on = depends_on, unlock_lvl = unlock_lvl}.upgrade, {tree = 4, step = l_59_0.steps.glock.reload_speed_multiplier[i], category = "feature", name_id = "debug_upgrade_glock_reload_speed" .. i, title_id = "debug_glock_short", subtitle_id = "debug_upgrade_reload_speed" .. i, icon = "glock", image = "upgrades_glock", image_slice = "upgrades_glock_slice", description_text_id = "reload_speed_multiplier", depends_on = depends_on, unlock_lvl = unlock_lvl}.prio = {tree = 4, step = l_59_0.steps.glock.reload_speed_multiplier[i], category = "feature", name_id = "debug_upgrade_glock_reload_speed" .. i, title_id = "debug_glock_short", subtitle_id = "debug_upgrade_reload_speed" .. i, icon = "glock", image = "upgrades_glock", image_slice = "upgrades_glock_slice", description_text_id = "reload_speed_multiplier", depends_on = depends_on, unlock_lvl = unlock_lvl}, {category = "glock", upgrade = "reload_speed_multiplier", value = i}, prio
  end
end

UpgradesTweakData._m79_definitions = function(l_60_0)
   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

  l_60_0.definitions.m79, {tree = 4, step = 21, category = "weapon", weapon_id = "m79", unit_name = Idstring("units/weapons/m79/m79"), name_id = "debug_m79", title_id = "debug_upgrade_new_weapon", subtitle_id = "debug_m79_short", icon = "m79", image = "upgrades_grenade", image_slice = "upgrades_grenade_slice", unlock_lvl = 0}.description_text_id, {tree = 4, step = 21, category = "weapon", weapon_id = "m79", unit_name = Idstring("units/weapons/m79/m79"), name_id = "debug_m79", title_id = "debug_upgrade_new_weapon", subtitle_id = "debug_m79_short", icon = "m79", image = "upgrades_grenade", image_slice = "upgrades_grenade_slice", unlock_lvl = 0}.prio = {tree = 4, step = 21, category = "weapon", weapon_id = "m79", unit_name = Idstring("units/weapons/m79/m79"), name_id = "debug_m79", title_id = "debug_upgrade_new_weapon", subtitle_id = "debug_m79_short", icon = "m79", image = "upgrades_grenade", image_slice = "upgrades_grenade_slice", unlock_lvl = 0}, "des_m79", "high"
  for i,_ in ipairs(l_60_0.values.m79.damage_multiplier) do
    local depends_on = i - 1 > 0 and "m79_damage" .. i - 1 or "m79"
    local unlock_lvl = 141
    local prio = (i == 1 and "high")
     -- DECOMPILER ERROR: Confused about usage of registers!

     -- DECOMPILER ERROR: Confused about usage of registers!

    l_60_0.definitions.m79_damage" .. , {tree = 4, step = l_60_0.steps.m79.damage_multiplier[i], category = "feature", name_id = "debug_upgrade_m79_damage" .. i, title_id = "debug_m79_short", subtitle_id = "debug_upgrade_damage" .. i, icon = "m79", image = "upgrades_grenade", image_slice = "upgrades_grenade_slice", description_text_id = "damage_multiplier", depends_on = depends_on, unlock_lvl = unlock_lvl}.upgrade, {tree = 4, step = l_60_0.steps.m79.damage_multiplier[i], category = "feature", name_id = "debug_upgrade_m79_damage" .. i, title_id = "debug_m79_short", subtitle_id = "debug_upgrade_damage" .. i, icon = "m79", image = "upgrades_grenade", image_slice = "upgrades_grenade_slice", description_text_id = "damage_multiplier", depends_on = depends_on, unlock_lvl = unlock_lvl}.prio = {tree = 4, step = l_60_0.steps.m79.damage_multiplier[i], category = "feature", name_id = "debug_upgrade_m79_damage" .. i, title_id = "debug_m79_short", subtitle_id = "debug_upgrade_damage" .. i, icon = "m79", image = "upgrades_grenade", image_slice = "upgrades_grenade_slice", description_text_id = "damage_multiplier", depends_on = depends_on, unlock_lvl = unlock_lvl}, {category = "m79", upgrade = "damage_multiplier", value = i}, prio
  end
  for i,_ in ipairs(l_60_0.values.m79.explosion_range_multiplier) do
    local depends_on = i - 1 > 0 and "m79_expl_range" .. i - 1 or "m79"
    local unlock_lvl = 141
    local prio = (i == 1 and "high")
     -- DECOMPILER ERROR: Confused about usage of registers!

     -- DECOMPILER ERROR: Confused about usage of registers!

    l_60_0.definitions.m79_expl_range" .. , {tree = 4, step = l_60_0.steps.m79.explosion_range_multiplier[i], category = "feature", name_id = "debug_upgrade_m79_expl_range" .. i, title_id = "debug_m79_short", subtitle_id = "debug_upgrade_expl_range" .. i, icon = "m79", image = "upgrades_grenade", image_slice = "upgrades_grenade_slice", description_text_id = "explosion_range_multiplier", depends_on = depends_on, unlock_lvl = unlock_lvl}.upgrade, {tree = 4, step = l_60_0.steps.m79.explosion_range_multiplier[i], category = "feature", name_id = "debug_upgrade_m79_expl_range" .. i, title_id = "debug_m79_short", subtitle_id = "debug_upgrade_expl_range" .. i, icon = "m79", image = "upgrades_grenade", image_slice = "upgrades_grenade_slice", description_text_id = "explosion_range_multiplier", depends_on = depends_on, unlock_lvl = unlock_lvl}.prio = {tree = 4, step = l_60_0.steps.m79.explosion_range_multiplier[i], category = "feature", name_id = "debug_upgrade_m79_expl_range" .. i, title_id = "debug_m79_short", subtitle_id = "debug_upgrade_expl_range" .. i, icon = "m79", image = "upgrades_grenade", image_slice = "upgrades_grenade_slice", description_text_id = "explosion_range_multiplier", depends_on = depends_on, unlock_lvl = unlock_lvl}, {category = "m79", upgrade = "explosion_range_multiplier", value = i}, prio
  end
  for i,_ in ipairs(l_60_0.values.m79.clip_amount_increase) do
    local depends_on = i - 1 > 0 and "m79_clip_num" .. i - 1 or "m79"
    local unlock_lvl = 141
    local prio = (i == 1 and "high")
     -- DECOMPILER ERROR: Confused about usage of registers!

     -- DECOMPILER ERROR: Confused about usage of registers!

    l_60_0.definitions.m79_clip_num" .. , {tree = 4, step = l_60_0.steps.m79.clip_amount_increase[i], category = "feature", name_id = "debug_upgrade_m79_clip_num" .. i, title_id = "debug_m79_short", subtitle_id = "debug_upgrade_clip_num" .. i, icon = "m79", image = "upgrades_grenade", image_slice = "upgrades_grenade_slice", description_text_id = "clip_amount_increase", depends_on = depends_on, unlock_lvl = unlock_lvl}.upgrade, {tree = 4, step = l_60_0.steps.m79.clip_amount_increase[i], category = "feature", name_id = "debug_upgrade_m79_clip_num" .. i, title_id = "debug_m79_short", subtitle_id = "debug_upgrade_clip_num" .. i, icon = "m79", image = "upgrades_grenade", image_slice = "upgrades_grenade_slice", description_text_id = "clip_amount_increase", depends_on = depends_on, unlock_lvl = unlock_lvl}.prio = {tree = 4, step = l_60_0.steps.m79.clip_amount_increase[i], category = "feature", name_id = "debug_upgrade_m79_clip_num" .. i, title_id = "debug_m79_short", subtitle_id = "debug_upgrade_clip_num" .. i, icon = "m79", image = "upgrades_grenade", image_slice = "upgrades_grenade_slice", description_text_id = "clip_amount_increase", depends_on = depends_on, unlock_lvl = unlock_lvl}, {category = "m79", upgrade = "clip_amount_increase", value = i}, prio
  end
end


