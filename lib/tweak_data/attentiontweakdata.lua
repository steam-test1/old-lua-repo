-- Decompiled using luadec 2.0.1 by sztupy (http://winmo.sztupy.hu)
-- Command line was: F:\SteamLibrary\SteamApps\common\PAYDAY 2\lua\lib\tweak_data\attentiontweakdata.luac 

if not AttentionTweakData then
  AttentionTweakData = class()
end
AttentionTweakData.init = function(l_1_0)
  l_1_0.settings = {}
  l_1_0.indexes = {}
  l_1_0:_init_player()
  l_1_0:_init_team_AI()
  l_1_0:_init_civilian()
  l_1_0:_init_enemy()
  l_1_0:_init_drill()
  l_1_0:_init_sentry_gun()
  l_1_0:_init_prop()
  l_1_0:_init_custom()
  l_1_0:_post_init()
end

AttentionTweakData._init_player = function(l_2_0)
   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

  l_2_0.settings.pl_team_cur_peaceful, {reaction = "REACT_IDLE", filter = "criminal"}.notice_requires_FOV, {reaction = "REACT_IDLE", filter = "criminal"}.pause, {reaction = "REACT_IDLE", filter = "criminal"}.duration, {reaction = "REACT_IDLE", filter = "criminal"}.release_delay, {reaction = "REACT_IDLE", filter = "criminal"}.verification_interval, {reaction = "REACT_IDLE", filter = "criminal"}.notice_delay_mul, {reaction = "REACT_IDLE", filter = "criminal"}.max_range = {reaction = "REACT_IDLE", filter = "criminal"}, false, {15, 25}, {2, 5}, 3, 4, 1, 1000
   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

  l_2_0.settings.pl_team_idle_std, {reaction = "REACT_IDLE", filter = "criminal"}.notice_requires_FOV, {reaction = "REACT_IDLE", filter = "criminal"}.pause, {reaction = "REACT_IDLE", filter = "criminal"}.duration, {reaction = "REACT_IDLE", filter = "criminal"}.release_delay, {reaction = "REACT_IDLE", filter = "criminal"}.verification_interval, {reaction = "REACT_IDLE", filter = "criminal"}.notice_delay_mul, {reaction = "REACT_IDLE", filter = "criminal"}.max_range = {reaction = "REACT_IDLE", filter = "criminal"}, false, {45, 90}, {1.7000000476837, 2.5}, 3, 4, 0, 1000
   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

  l_2_0.settings.pl_gangster_cur_peaceful, {reaction = "REACT_SUSPICIOUS", filter = "gangster", max_range = 600, suspicion_range = 500, suspicion_duration = 5.5, turn_around_range = 250}.notice_requires_FOV, {reaction = "REACT_SUSPICIOUS", filter = "gangster", max_range = 600, suspicion_range = 500, suspicion_duration = 5.5, turn_around_range = 250}.release_delay, {reaction = "REACT_SUSPICIOUS", filter = "gangster", max_range = 600, suspicion_range = 500, suspicion_duration = 5.5, turn_around_range = 250}.verification_interval, {reaction = "REACT_SUSPICIOUS", filter = "gangster", max_range = 600, suspicion_range = 500, suspicion_duration = 5.5, turn_around_range = 250}.notice_delay_mul, {reaction = "REACT_SUSPICIOUS", filter = "gangster", max_range = 600, suspicion_range = 500, suspicion_duration = 5.5, turn_around_range = 250}.uncover_range = {reaction = "REACT_SUSPICIOUS", filter = "gangster", max_range = 600, suspicion_range = 500, suspicion_duration = 5.5, turn_around_range = 250}, true, 2, 0.019999999552965, 0.30000001192093, 90
  l_2_0.settings.pl_gangster_cbt = {reaction = "REACT_COMBAT", filter = "gangster", verification_interval = 1, release_delay = 1, uncover_range = 550, notice_requires_FOV = true}
   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

  l_2_0.settings.pl_law_susp_peaceful, {reaction = "REACT_SUSPICIOUS", filter = "law_enforcer", max_range = 600, suspicion_range = 500, suspicion_duration = 4, turn_around_range = 250}.notice_requires_FOV, {reaction = "REACT_SUSPICIOUS", filter = "law_enforcer", max_range = 600, suspicion_range = 500, suspicion_duration = 4, turn_around_range = 250}.release_delay, {reaction = "REACT_SUSPICIOUS", filter = "law_enforcer", max_range = 600, suspicion_range = 500, suspicion_duration = 4, turn_around_range = 250}.verification_interval, {reaction = "REACT_SUSPICIOUS", filter = "law_enforcer", max_range = 600, suspicion_range = 500, suspicion_duration = 4, turn_around_range = 250}.notice_delay_mul, {reaction = "REACT_SUSPICIOUS", filter = "law_enforcer", max_range = 600, suspicion_range = 500, suspicion_duration = 4, turn_around_range = 250}.uncover_range = {reaction = "REACT_SUSPICIOUS", filter = "law_enforcer", max_range = 600, suspicion_range = 500, suspicion_duration = 4, turn_around_range = 250}, true, 2, 0.019999999552965, 0.30000001192093, 150
   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

  l_2_0.settings.pl_enemy_cur_peaceful, {reaction = "REACT_CURIOUS", filter = "all_enemy"}.notice_requires_FOV, {reaction = "REACT_CURIOUS", filter = "all_enemy"}.pause, {reaction = "REACT_CURIOUS", filter = "all_enemy"}.duration, {reaction = "REACT_CURIOUS", filter = "all_enemy"}.release_delay, {reaction = "REACT_CURIOUS", filter = "all_enemy"}.verification_interval, {reaction = "REACT_CURIOUS", filter = "all_enemy"}.notice_delay_mul, {reaction = "REACT_CURIOUS", filter = "all_enemy"}.max_range = {reaction = "REACT_CURIOUS", filter = "all_enemy"}, true, {25, 50}, {1.5, 3.5}, 1, 2, 0.5, 600
  l_2_0.settings.pl_enemy_cbt = {reaction = "REACT_COMBAT", filter = "all_enemy", verification_interval = 1, notice_interval = 0.10000000149012, uncover_range = 550, release_delay = 1, notice_clbk = "clbk_attention_notice_sneak", notice_requires_FOV = true}
  l_2_0.settings.pl_enemy_cbt_crh = {reaction = "REACT_COMBAT", filter = "all_enemy", verification_interval = 0.10000000149012, uncover_range = 350, release_delay = 1, notice_delay_mul = 2, notice_requires_FOV = true}
   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

  l_2_0.settings.pl_enemy_sneak, {reaction = "REACT_COMBAT", filter = "all_enemy"}.notice_requires_FOV, {reaction = "REACT_COMBAT", filter = "all_enemy"}.notice_clbk, {reaction = "REACT_COMBAT", filter = "all_enemy"}.max_range, {reaction = "REACT_COMBAT", filter = "all_enemy"}.notice_delay_mul, {reaction = "REACT_COMBAT", filter = "all_enemy"}.release_delay, {reaction = "REACT_COMBAT", filter = "all_enemy"}.uncover_range, {reaction = "REACT_COMBAT", filter = "all_enemy"}.verification_interval = {reaction = "REACT_COMBAT", filter = "all_enemy"}, true, "clbk_attention_notice_sneak", 1500, 2, 1, 350, 0.10000000149012
   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

  l_2_0.settings.pl_civ_idle_peaceful, {reaction = "REACT_IDLE", filter = "civilian", max_range = 600, notice_delay_mul = 0, notice_interval = 0.5, attract_chance = 0.5}.notice_requires_FOV, {reaction = "REACT_IDLE", filter = "civilian", max_range = 600, notice_delay_mul = 0, notice_interval = 0.5, attract_chance = 0.5}.pause, {reaction = "REACT_IDLE", filter = "civilian", max_range = 600, notice_delay_mul = 0, notice_interval = 0.5, attract_chance = 0.5}.duration, {reaction = "REACT_IDLE", filter = "civilian", max_range = 600, notice_delay_mul = 0, notice_interval = 0.5, attract_chance = 0.5}.release_delay, {reaction = "REACT_IDLE", filter = "civilian", max_range = 600, notice_delay_mul = 0, notice_interval = 0.5, attract_chance = 0.5}.verification_interval = {reaction = "REACT_IDLE", filter = "civilian", max_range = 600, notice_delay_mul = 0, notice_interval = 0.5, attract_chance = 0.5}, true, {10, 60}, {2, 15}, 3, 2
   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

  l_2_0.settings.pl_civ_sneak, {reaction = "REACT_COMBAT", filter = "civilian"}.notice_requires_FOV, {reaction = "REACT_COMBAT", filter = "civilian"}.notice_clbk, {reaction = "REACT_COMBAT", filter = "civilian"}.max_range, {reaction = "REACT_COMBAT", filter = "civilian"}.notice_delay_mul, {reaction = "REACT_COMBAT", filter = "civilian"}.release_delay, {reaction = "REACT_COMBAT", filter = "civilian"}.uncover_range, {reaction = "REACT_COMBAT", filter = "civilian"}.verification_interval = {reaction = "REACT_COMBAT", filter = "civilian"}, true, "clbk_attention_notice_sneak", 1500, 3, 1, 200, 0.10000000149012
  l_2_0.settings.pl_civ_cbt = {reaction = "REACT_COMBAT", filter = "civilian", verification_interval = 0.10000000149012, uncover_range = 550, release_delay = 1, notice_delay_mul = 1.5, notice_clbk = "clbk_attention_notice_sneak", notice_requires_FOV = true}
end

AttentionTweakData._init_team_AI = function(l_3_0)
  l_3_0.settings.team_team_idle = {reaction = "REACT_IDLE", filter = "criminal", max_range = 1000, verification_interval = 3, release_delay = 2, duration = {1.5, 4}, pause = {25, 40}, notice_requires_FOV = false}
  l_3_0.settings.team_enemy_idle = {reaction = "REACT_IDLE", filter = "all_enemy", max_range = 550, verification_interval = 3, release_delay = 1, duration = {1.5, 3}, pause = {35, 60}, notice_requires_FOV = false}
   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

  l_3_0.settings.team_enemy_cbt, {reaction = "REACT_COMBAT", filter = "all_enemy"}.weight_mul, {reaction = "REACT_COMBAT", filter = "all_enemy"}.notice_requires_FOV, {reaction = "REACT_COMBAT", filter = "all_enemy"}.release_delay, {reaction = "REACT_COMBAT", filter = "all_enemy"}.uncover_range, {reaction = "REACT_COMBAT", filter = "all_enemy"}.verification_interval, {reaction = "REACT_COMBAT", filter = "all_enemy"}.notice_interval, {reaction = "REACT_COMBAT", filter = "all_enemy"}.max_range = {reaction = "REACT_COMBAT", filter = "all_enemy"}, 0.5, true, 1, 400, 1.5, 1, 20000
end

AttentionTweakData._init_civilian = function(l_4_0)
  l_4_0.settings.civ_all_peaceful = {reaction = "REACT_IDLE", filter = "all", max_range = 2000, verification_interval = 3, release_delay = 2, duration = {1.5, 6}, pause = {35, 60}, notice_requires_FOV = true}
   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

  l_4_0.settings.civ_enemy_cbt, {reaction = "REACT_SCARED", filter = "all_enemy", max_range = 8000, uncover_range = 300}.notice_requires_FOV, {reaction = "REACT_SCARED", filter = "all_enemy", max_range = 8000, uncover_range = 300}.notice_clbk, {reaction = "REACT_SCARED", filter = "all_enemy", max_range = 8000, uncover_range = 300}.duration, {reaction = "REACT_SCARED", filter = "all_enemy", max_range = 8000, uncover_range = 300}.release_delay, {reaction = "REACT_SCARED", filter = "all_enemy", max_range = 8000, uncover_range = 300}.verification_interval, {reaction = "REACT_SCARED", filter = "all_enemy", max_range = 8000, uncover_range = 300}.notice_delay_mul = {reaction = "REACT_SCARED", filter = "all_enemy", max_range = 8000, uncover_range = 300}, true, "clbk_attention_notice_corpse", {3, 6}, 6, 0.10000000149012, 0.60000002384186
  l_4_0.settings.civ_enemy_corpse_sneak = {reaction = "REACT_SCARED", filter = "civilians_enemies", max_range = 2500, uncover_range = 300, notice_delay_mul = 0.050000000745058, verification_interval = 0.10000000149012, release_delay = 6, notice_requires_FOV = true}
  l_4_0.settings.civ_civ_cbt = {reaction = "REACT_SCARED", filter = "civilian", uncover_range = 300, notice_delay_mul = 0.050000000745058, verification_interval = 0.10000000149012, release_delay = 6, duration = {3, 6}, notice_requires_FOV = true}
end

AttentionTweakData._init_enemy = function(l_5_0)
  l_5_0.settings.enemy_team_idle = {reaction = "REACT_IDLE", filter = "criminal", max_range = 2000, verification_interval = 3, release_delay = 1, duration = {2, 4}, pause = {9, 40}, notice_requires_FOV = false}
  l_5_0.settings.enemy_team_cbt = {reaction = "REACT_COMBAT", filter = "criminal", max_range = 20000, notice_delay_mul = 0, notice_interval = 0.20000000298023, verification_interval = 0.75, release_delay = 2, notice_requires_FOV = false}
  l_5_0.settings.enemy_law_corpse_sneak = l_5_0.settings.civ_enemy_corpse_sneak
  l_5_0.settings.enemy_team_corpse_sneak = l_5_0.settings.civ_enemy_corpse_sneak
   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

  l_5_0.settings.enemy_law_corpse_cbt, {reaction = "REACT_CURIOUS", filter = "law_enforcer"}.notice_requires_FOV, {reaction = "REACT_CURIOUS", filter = "law_enforcer"}.pause, {reaction = "REACT_CURIOUS", filter = "law_enforcer"}.duration, {reaction = "REACT_CURIOUS", filter = "law_enforcer"}.release_delay, {reaction = "REACT_CURIOUS", filter = "law_enforcer"}.verification_interval, {reaction = "REACT_CURIOUS", filter = "law_enforcer"}.notice_delay_mul, {reaction = "REACT_CURIOUS", filter = "law_enforcer"}.max_range = {reaction = "REACT_CURIOUS", filter = "law_enforcer"}, true, {30, 120}, {2, 3}, 1, 1.5, 0.10000000149012, 800
   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

  l_5_0.settings.enemy_team_corpse_cbt, {reaction = "REACT_IDLE", filter = "criminal"}.notice_requires_FOV, {reaction = "REACT_IDLE", filter = "criminal"}.pause, {reaction = "REACT_IDLE", filter = "criminal"}.duration, {reaction = "REACT_IDLE", filter = "criminal"}.release_delay, {reaction = "REACT_IDLE", filter = "criminal"}.verification_interval, {reaction = "REACT_IDLE", filter = "criminal"}.notice_delay_mul, {reaction = "REACT_IDLE", filter = "criminal"}.max_range = {reaction = "REACT_IDLE", filter = "criminal"}, true, {50, 360}, {2, 3}, 0, 1.5, 2, 800
  l_5_0.settings.enemy_enemy_cbt = {reaction = "REACT_SCARED", filter = "all_enemy", max_range = 8000, uncover_range = 300, notice_delay_mul = 0.5, verification_interval = 0.5, release_delay = 1, notice_requires_FOV = true}
   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

  l_5_0.settings.enemy_civ_cbt, {reaction = "REACT_SCARED", filter = "civilian"}.notice_requires_FOV, {reaction = "REACT_SCARED", filter = "civilian"}.duration, {reaction = "REACT_SCARED", filter = "civilian"}.release_delay, {reaction = "REACT_SCARED", filter = "civilian"}.verification_interval, {reaction = "REACT_SCARED", filter = "civilian"}.notice_delay_mul, {reaction = "REACT_SCARED", filter = "civilian"}.uncover_range, {reaction = "REACT_SCARED", filter = "civilian"}.max_range = {reaction = "REACT_SCARED", filter = "civilian"}, true, {1.5, 3}, 6, 0.5, 0.20000000298023, 300, 8000
end

AttentionTweakData._init_custom = function(l_6_0)
  l_6_0.settings.custom_void = {reaction = "REACT_IDLE", filter = "none", max_range = 2000, verification_interval = 10, release_delay = 10}
  l_6_0.settings.custom_team_idle = {reaction = "REACT_IDLE", filter = "criminal", max_range = 2000, verification_interval = 3, release_delay = 1, duration = {2, 4}, pause = {9, 40}, notice_requires_FOV = false}
  l_6_0.settings.custom_team_cbt = {reaction = "REACT_COMBAT", filter = "criminal", max_range = 20000, verification_interval = 1.5, release_delay = 2, notice_requires_FOV = false}
  l_6_0.settings.custom_team_shoot_const = {reaction = "REACT_SHOOT", filter = "criminal", max_range = 10000, verification_interval = 1.5, release_delay = 2, notice_requires_FOV = false}
  l_6_0.settings.custom_team_shoot_burst = {reaction = "REACT_SHOOT", filter = "criminal", max_range = 10000, verification_interval = 1.5, release_delay = 2, duration = {2, 4}, notice_requires_FOV = false}
  l_6_0.settings.custom_team_aim_const = {reaction = "REACT_AIM", filter = "criminal", max_range = 10000, verification_interval = 1.5, release_delay = 2, notice_requires_FOV = false}
  l_6_0.settings.custom_enemy_forest_survive_kruka = {reaction = "REACT_COMBAT", filter = "all_enemy", max_range = 20000, verification_interval = 1, release_delay = 2, notice_requires_FOV = false}
  l_6_0.settings.custom_enemy_suburbia_shootout = {reaction = "REACT_SHOOT", filter = "all_enemy", max_range = 12000, verification_interval = 2, release_delay = 5, turn_around_range = 15000, notice_requires_FOV = true, weight_mul = 0.5}
  l_6_0.settings.custom_enemy_suburbia_shootout_cops = {reaction = "REACT_SHOOT", filter = "all_enemy", max_range = 2000, verification_interval = 2, release_delay = 5, turn_around_range = 15000, notice_requires_FOV = true}
  l_6_0.settings.custom_enemy_china_store_vase_shoot = {reaction = "REACT_COMBAT", filter = "all_enemy", max_range = 1200, verification_interval = 2, release_delay = 3, turn_around_range = 500, notice_requires_FOV = true}
  l_6_0.settings.custom_enemy_china_store_vase_melee = {reaction = "REACT_MELEE", filter = "all_enemy", max_range = 500, verification_interval = 5, release_delay = 10, pause = 10, turn_around_range = 250, notice_requires_FOV = true}
  l_6_0.settings.custom_enemy_china_store_vase_aim = {reaction = "REACT_COMBAT", filter = "all_enemy", max_range = 500, verification_interval = 5, release_delay = 10, pause = 10, notice_requires_FOV = false}
  l_6_0.settings.custom_enemy_shoot_const = {reaction = "REACT_SHOOT", filter = "all_enemy", max_range = 10000, verification_interval = 1, release_delay = 2, notice_requires_FOV = true}
  l_6_0.settings.custom_gangster_shoot_const = {reaction = "REACT_SHOOT", filter = "gangster", max_range = 10000, verification_interval = 1, release_delay = 2, notice_requires_FOV = true}
  l_6_0.settings.custom_law_shoot_const = {reaction = "REACT_SHOOT", filter = "law_enforcer", max_range = 100000, verification_interval = 1, release_delay = 2, notice_requires_FOV = false}
  l_6_0.settings.custom_law_look_in_container = {reaction = "REACT_AIM", filter = "law_enforcer", max_range = 100000, verification_interval = 1, release_delay = 2, notice_requires_FOV = false}
  l_6_0.settings.custom_law_shoot_const_escape_vehicle = {reaction = "REACT_COMBAT", filter = "law_enforcer", max_range = 4500, verification_interval = 1, release_delay = 2, notice_requires_FOV = false}
  l_6_0.settings.custom_law_shoot_const_container = {reaction = "REACT_SHOOT", filter = "law_enforcer", max_range = 2000, verification_interval = 1, release_delay = 2, notice_requires_FOV = false}
  l_6_0.settings.custom_gangsters_shoot_warehouse = {reaction = "REACT_COMBAT", filter = "gangster", max_range = 2000, verification_interval = 1, release_delay = 2, notice_requires_FOV = false}
  l_6_0.settings.custom_gangster_sniper_apartment_suspicous = {reaction = "REACT_SCARED", filter = "law_enforcer", max_range = 850, verification_interval = 1, release_delay = 6, notice_requires_FOV = true, uncover_range = 350, notice_delay_mul = 0.10000000149012}
  l_6_0.settings.custom_gangster_docks_idle = {reaction = "REACT_CURIOUS", filter = "gangster", max_range = 10000, verification_interval = 1, release_delay = 6, notice_requires_FOV = true}
  l_6_0.settings.custom_enemy_civ_scared = {reaction = "REACT_SCARED", filter = "civilians_enemies", verification_interval = 5, release_delay = 2, duration = {2, 4}, notice_requires_FOV = true}
  l_6_0.settings.custom_boat_gangster = {reaction = "REACT_COMBAT", filter = "gangster", max_range = 4000, verification_interval = 1, release_delay = 2, notice_requires_FOV = false}
  l_6_0.settings.custom_law_cbt = {reaction = "REACT_COMBAT", filter = "law_enforcer", verification_interval = 1, uncover_range = 350, release_delay = 1, notice_clbk = "clbk_attention_notice_sneak", notice_requires_FOV = true}
   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

  l_6_0.settings.custom_airport_window, {reaction = "REACT_CURIOUS", filter = "all_enemy"}.notice_requires_FOV, {reaction = "REACT_CURIOUS", filter = "all_enemy"}.duration, {reaction = "REACT_CURIOUS", filter = "all_enemy"}.release_delay, {reaction = "REACT_CURIOUS", filter = "all_enemy"}.verification_interval, {reaction = "REACT_CURIOUS", filter = "all_enemy"}.notice_delay_mul, {reaction = "REACT_CURIOUS", filter = "all_enemy"}.uncover_range, {reaction = "REACT_CURIOUS", filter = "all_enemy"}.max_range = {reaction = "REACT_CURIOUS", filter = "all_enemy"}, true, {3, 6}, 6, 1.5, 0.20000000298023, 100, 1500
  l_6_0.settings.custom_look_at = {reaction = "REACT_IDLE", filter = "all_enemy", max_range = 15000, notice_delay_mul = 0.20000000298023, verification_interval = 1, release_delay = 3, notice_requires_FOV = false}
  l_6_0.settings.custom_look_at_FOV = {reaction = "REACT_CURIOUS", filter = "all_enemy", max_range = 1500, notice_delay_mul = 0.20000000298023, verification_interval = 1.5, release_delay = 6, duration = {3, 6}, notice_requires_FOV = true}
   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

  l_6_0.settings.custom_server_room, {reaction = "REACT_SCARED", filter = "all_enemy"}.notice_requires_FOV, {reaction = "REACT_SCARED", filter = "all_enemy"}.duration, {reaction = "REACT_SCARED", filter = "all_enemy"}.release_delay, {reaction = "REACT_SCARED", filter = "all_enemy"}.verification_interval, {reaction = "REACT_SCARED", filter = "all_enemy"}.notice_delay_mul, {reaction = "REACT_SCARED", filter = "all_enemy"}.uncover_range, {reaction = "REACT_SCARED", filter = "all_enemy"}.max_range = {reaction = "REACT_SCARED", filter = "all_enemy"}, true, {3, 6}, 6, 1.5, 0.20000000298023, 100, 350
end

AttentionTweakData._init_drill = function(l_7_0)
  l_7_0.settings.drill_civ_ene_ntl = {reaction = "REACT_SCARED", filter = "civilians_enemies", verification_interval = 0.40000000596046, uncover_range = 200, release_delay = 1, notice_requires_FOV = false}
end

AttentionTweakData._init_sentry_gun = function(l_8_0)
  l_8_0.settings.sentry_gun_enemy_cbt = {reaction = "REACT_COMBAT", filter = "all_enemy", verification_interval = 1.5, uncover_range = 300, release_delay = 1}
end

AttentionTweakData._init_prop = function(l_9_0)
  l_9_0.settings.prop_civ_ene_ntl = {reaction = "REACT_AIM", filter = "civilians_enemies", verification_interval = 0.40000000596046, uncover_range = 500, release_delay = 1, notice_requires_FOV = true}
  l_9_0.settings.prop_ene_ntl = {reaction = "REACT_AIM", filter = "all_enemy", verification_interval = 0.40000000596046, uncover_range = 500, release_delay = 1, notice_requires_FOV = true}
  l_9_0.settings.broken_cam_ene_ntl = {reaction = "REACT_AIM", filter = "law_enforcer", verification_interval = 0.40000000596046, uncover_range = 100, suspicion_range = 1000, max_range = 1200, release_delay = 1, notice_requires_FOV = true}
  l_9_0.settings.prop_law_scary = {reaction = "REACT_SCARED", filter = "law_enforcer", verification_interval = 0.40000000596046, uncover_range = 300, release_delay = 1, notice_requires_FOV = true}
  l_9_0.settings.prop_state_civ_ene_ntl = {reaction = "REACT_CURIOUS", filter = "civilians_enemies", verification_interval = 0.40000000596046, uncover_range = 200, release_delay = 1, notice_requires_FOV = true}
end

AttentionTweakData.get_attention_index = function(l_10_0, l_10_1)
  for i_setting,test_setting_name in ipairs(l_10_0.indexes) do
    if l_10_1 == test_setting_name then
      return i_setting
    end
  end
end

AttentionTweakData.get_attention_name = function(l_11_0, l_11_1)
  return l_11_0.indexes[l_11_1]
end

AttentionTweakData._post_init = function(l_12_0)
  for setting_name,setting in pairs(l_12_0.settings) do
    table.insert(l_12_0.indexes, setting_name)
  end
end


