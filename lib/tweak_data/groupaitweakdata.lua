-- Decompiled using luadec 2.0.1 by sztupy (http://winmo.sztupy.hu)
-- Command line was: F:\SteamLibrary\SteamApps\common\PAYDAY 2\lua\lib\tweak_data\groupaitweakdata.luac 

if not GroupAITweakData then
  GroupAITweakData = class()
end
GroupAITweakData.init = function(l_1_0, l_1_1)
  l_1_0:_read_mission_preset(l_1_1)
  l_1_0:_create_table_structure()
  l_1_0:_init_task_data()
  l_1_0:_init_chatter_data()
  l_1_0:_init_unit_categories()
  l_1_0:_init_enemy_spawn_groups()
  l_1_0._level_mod = "CS_normal"
end

GroupAITweakData._init_chatter_data = function(l_2_0)
  l_2_0.enemy_chatter.aggressive = {radius = 1000, max_nr = 3, duration = {1, 3}, interval = {2, 5}, group_min = 3, queue = "g90"}
  l_2_0.enemy_chatter.retreat = {radius = 700, max_nr = 2, duration = {2, 4}, interval = {0.75, 1.5}, group_min = 3, queue = "m01"}
  l_2_0.enemy_chatter.follow_me = {radius = 700, max_nr = 1, duration = {5, 10}, interval = {0.75, 1.5}, group_min = 2, queue = "mov"}
  l_2_0.enemy_chatter.clear = {radius = 700, max_nr = 1, duration = {60, 60}, interval = {0.75, 1.5}, group_min = 3, queue = "clr"}
  l_2_0.enemy_chatter.go_go = {radius = 700, max_nr = 1, duration = {60, 60}, interval = {0.75, 1.2000000476837}, group_min = 0, queue = "mov"}
  l_2_0.enemy_chatter.ready = {radius = 700, max_nr = 1, duration = {60, 60}, interval = {0.75, 1.2000000476837}, group_min = 3, queue = "rdy"}
  l_2_0.enemy_chatter.smoke = {radius = 0, max_nr = 1, duration = {0, 0}, interval = {0, 0}, group_min = 2, queue = "d01"}
  l_2_0.enemy_chatter.flash_grenade = {radius = 0, max_nr = 1, duration = {0, 0}, interval = {0, 0}, group_min = 2, queue = "d02"}
  l_2_0.enemy_chatter.incomming_tank = {radius = 1000, max_nr = 1, duration = {60, 60}, interval = {0.5, 1}, group_min = 0, queue = "bdz"}
  l_2_0.enemy_chatter.incomming_spooc = {radius = 1000, max_nr = 1, duration = {60, 60}, interval = {0.5, 1}, group_min = 0, queue = "clk"}
  l_2_0.enemy_chatter.incomming_shield = {radius = 1000, max_nr = 1, duration = {60, 60}, interval = {0.5, 1}, group_min = 0, queue = "shd"}
  l_2_0.enemy_chatter.incomming_taser = {radius = 1000, max_nr = 1, duration = {60, 60}, interval = {0.5, 1}, group_min = 0, queue = "tsr"}
end

GroupAITweakData._init_unit_categories = function(l_3_0)
  local access_type_walk_only = {walk = true}
  do
    local access_type_all = {walk = true, acrobatic = true}
     -- DECOMPILER ERROR: Overwrote pending register.

     -- DECOMPILER ERROR: Overwrote pending register.

     -- DECOMPILER ERROR: Overwrote pending register.

     -- DECOMPILER ERROR: Overwrote pending register.

     -- DECOMPILER ERROR: Overwrote pending register.

     -- DECOMPILER ERROR: Unhandled construct in list

     -- DECOMPILER ERROR: Overwrote pending register.

     -- DECOMPILER ERROR: Overwrote pending register.

     -- DECOMPILER ERROR: Overwrote pending register.

     -- DECOMPILER ERROR: Overwrote pending register.

     -- DECOMPILER ERROR: Unhandled construct in list

     -- DECOMPILER ERROR: Overwrote pending register.

     -- DECOMPILER ERROR: Overwrote pending register.

     -- DECOMPILER ERROR: Overwrote pending register.

     -- DECOMPILER ERROR: Overwrote pending register.

     -- DECOMPILER ERROR: Unhandled construct in list

     -- DECOMPILER ERROR: Overwrote pending register.

     -- DECOMPILER ERROR: Unhandled construct in list

     -- DECOMPILER ERROR: Overwrote pending register.

     -- DECOMPILER ERROR: Overwrote pending register.

     -- DECOMPILER ERROR: Overwrote pending register.

     -- DECOMPILER ERROR: Unhandled construct in list

     -- DECOMPILER ERROR: Overwrote pending register.

     -- DECOMPILER ERROR: Unhandled construct in list

     -- DECOMPILER ERROR: Overwrote pending register.

     -- DECOMPILER ERROR: Unhandled construct in list

     -- DECOMPILER ERROR: Overwrote pending register.

     -- DECOMPILER ERROR: Unhandled construct in list

     -- DECOMPILER ERROR: Overwrote pending register.

     -- DECOMPILER ERROR: Unhandled construct in list

     -- DECOMPILER ERROR: Overwrote pending register.

     -- DECOMPILER ERROR: Unhandled construct in list

     -- DECOMPILER ERROR: Overwrote pending register.

     -- DECOMPILER ERROR: Unhandled construct in list

     -- DECOMPILER ERROR: Overwrote pending register.

     -- DECOMPILER ERROR: Unhandled construct in list

     -- DECOMPILER ERROR: Overwrote pending register.

     -- DECOMPILER ERROR: Unhandled construct in list

     -- DECOMPILER ERROR: Confused about usage of registers!

     -- DECOMPILER ERROR: Overwrote pending register.

     -- DECOMPILER ERROR: Confused about usage of registers!

     -- DECOMPILER ERROR: Overwrote pending register.

     -- DECOMPILER ERROR: Overwrote pending register.

     -- DECOMPILER ERROR: Unhandled construct in list

     -- DECOMPILER ERROR: Confused about usage of registers!

     -- DECOMPILER ERROR: Overwrote pending register.

     -- DECOMPILER ERROR: Overwrote pending register.

     -- DECOMPILER ERROR: Confused about usage of registers!

     -- DECOMPILER ERROR: Overwrote pending register.

     -- DECOMPILER ERROR: Overwrote pending register.

     -- DECOMPILER ERROR: Unhandled construct in list

     -- DECOMPILER ERROR: Confused about usage of registers!

     -- DECOMPILER ERROR: Overwrote pending register.

     -- DECOMPILER ERROR: Unhandled construct in list

     -- DECOMPILER ERROR: Confused about usage of registers!

     -- DECOMPILER ERROR: Overwrote pending register.

     -- DECOMPILER ERROR: Unhandled construct in list

     -- DECOMPILER ERROR: Confused about usage of registers!

     -- DECOMPILER ERROR: Overwrote pending register.

     -- DECOMPILER ERROR: Unhandled construct in list

     -- DECOMPILER ERROR: Confused about usage of registers!

     -- DECOMPILER ERROR: Overwrote pending register.

     -- DECOMPILER ERROR: Unhandled construct in list

     -- DECOMPILER ERROR: Confused about usage of registers!

     -- DECOMPILER ERROR: Overwrote pending register.

     -- DECOMPILER ERROR: Unhandled construct in list

     -- DECOMPILER ERROR: Confused about usage of registers!

     -- DECOMPILER ERROR: Overwrote pending register.

     -- DECOMPILER ERROR: Unhandled construct in list

     -- DECOMPILER ERROR: Confused about usage of registers!

     -- DECOMPILER ERROR: Overwrote pending register.

     -- DECOMPILER ERROR: Overwrote pending register.

     -- DECOMPILER ERROR: Confused about usage of registers!

     -- DECOMPILER ERROR: Overwrote pending register.

     -- DECOMPILER ERROR: Overwrote pending register.

     -- DECOMPILER ERROR: Confused about usage of registers!

     -- DECOMPILER ERROR: Overwrote pending register.

     -- DECOMPILER ERROR: Overwrote pending register.

     -- DECOMPILER ERROR: Unhandled construct in list

     -- DECOMPILER ERROR: Confused about usage of registers!

     -- DECOMPILER ERROR: Overwrote pending register.

     -- DECOMPILER ERROR: Unhandled construct in list

     -- DECOMPILER ERROR: Confused about usage of registers!

     -- DECOMPILER ERROR: Overwrote pending register.

     -- DECOMPILER ERROR: Unhandled construct in list

     -- DECOMPILER ERROR: Confused about usage of registers!

     -- DECOMPILER ERROR: Overwrote pending register.

     -- DECOMPILER ERROR: Unhandled construct in list

     -- DECOMPILER ERROR: Confused about usage of registers!

     -- DECOMPILER ERROR: Overwrote pending register.

     -- DECOMPILER ERROR: Unhandled construct in list

     -- DECOMPILER ERROR: Confused about usage of registers!

     -- DECOMPILER ERROR: Overwrote pending register.

     -- DECOMPILER ERROR: Unhandled construct in list

     -- DECOMPILER ERROR: Confused about usage of registers!

     -- DECOMPILER ERROR: Overwrote pending register.

     -- DECOMPILER ERROR: Unhandled construct in list

     -- DECOMPILER ERROR: Confused about usage of registers!

     -- DECOMPILER ERROR: Overwrote pending register.

     -- DECOMPILER ERROR: Unhandled construct in list

     -- DECOMPILER ERROR: Confused about usage of registers!

     -- DECOMPILER ERROR: Confused about usage of registers!

  end
   -- Warning: undefined locals caused missing assignments!
end

GroupAITweakData._init_enemy_spawn_groups = function(l_4_0)
  local tactics_CS_cop = {"provide_coverfire", "provide_support", "ranged_fire"}
  local tactics_CS_cop_stealth = {"flank", "provide_coverfire", "provide_support"}
  local tactics_CS_swat_rifle = {"smoke_grenade", "charge", "provide_coverfire", "provide_support", "ranged_fire"}
  local tactics_CS_swat_shotgun = {"smoke_grenade", "charge", "provide_coverfire", "provide_support"}
  local tactics_CS_swat_heavy = {"smoke_grenade", "charge", "provide_coverfire", "provide_support", "shield_cover"}
  local tactics_CS_shield = {"charge", "provide_coverfire", "provide_support", "shield"}
  local tactics_CS_swat_rifle_flank = {"flank", "flash_grenade", "smoke_grenade", "charge", "provide_coverfire", "provide_support"}
  local tactics_CS_swat_shotgun_flank = {"flank", "flash_grenade", "smoke_grenade", "charge", "provide_coverfire", "provide_support"}
  local tactics_CS_swat_heavy_flank = {"flank", "flash_grenade", "smoke_grenade", "charge", "provide_coverfire", "provide_support", "shield_cover"}
  local tactics_CS_shield_flank = {"flank", "charge", "flash_grenade", "provide_coverfire", "provide_support", "shield"}
  local tactics_CS_tazer = {"flank", "charge", "flash_grenade", "provide_coverfire", "provide_support"}
  local tactics_FBI_suit = {"provide_coverfire", "provide_support", "ranged_fire"}
  local tactics_FBI_suit_stealth = {"provide_coverfire", "provide_support"}
  local tactics_FBI_swat_rifle = {"smoke_grenade", "charge", "provide_coverfire", "provide_support", "ranged_fire"}
  local tactics_FBI_swat_shotgun = {"smoke_grenade", "charge", "provide_coverfire", "provide_support"}
  local tactics_FBI_heavy = {"smoke_grenade", "charge", "provide_coverfire", "provide_support", "shield_cover"}
  local tactics_FBI_shield = {"smoke_grenade", "charge", "provide_coverfire", "provide_support", "shield"}
  local tactics_FBI_swat_rifle_flank = {"flank", "smoke_grenade", "flash_grenade", "charge", "provide_coverfire", "provide_support"}
  local tactics_FBI_swat_shotgun_flank = {"flank", "smoke_grenade", "flash_grenade", "charge", "provide_coverfire", "provide_support"}
  local tactics_FBI_heavy_flank = {"flank", "smoke_grenade", "flash_grenade", "charge", "provide_coverfire", "provide_support", "shield_cover"}
  local tactics_FBI_shield_flank = {"flank", "smoke_grenade", "flash_grenade", "charge", "provide_coverfire", "provide_support", "shield"}
  local tactics_FBI_spooc = {"flank", "smoke_grenade", "flash_grenade", "charge", "provide_coverfire"}
  local tactics_FBI_tank = {"charge", "provide_coverfire", "provide_support"}
  l_4_0.enemy_spawn_groups.CS_defend_a = {amount = {3, 4}, spawn = {{unit = "CS_cop_C45_R870", freq = 1, tactics = tactics_CS_cop, rank = 1}}}
  l_4_0.enemy_spawn_groups.CS_defend_b = {amount = {3, 4}, spawn = {{unit = "CS_swat_MP5", freq = 1, amount_min = 1, tactics = tactics_CS_cop, rank = 1}}}
  l_4_0.enemy_spawn_groups.CS_defend_c = {amount = {3, 4}, spawn = {{unit = "CS_heavy_M4", freq = 1, amount_min = 1, tactics = tactics_CS_cop, rank = 1}}}
  l_4_0.enemy_spawn_groups.CS_cops = {amount = {3, 4}, spawn = {{unit = "CS_cop_C45_R870", freq = 1, amount_min = 1, tactics = tactics_CS_cop, rank = 1}}}
  l_4_0.enemy_spawn_groups.CS_stealth_a = {amount = {2, 3}, spawn = {{unit = "CS_cop_stealth_MP5", freq = 1, amount_min = 1, tactics = tactics_CS_cop_stealth, rank = 1}}}
  l_4_0.enemy_spawn_groups.CS_swats = {amount = {3, 4}, spawn = {{unit = "CS_swat_MP5", freq = 1, tactics = tactics_CS_swat_rifle, rank = 2}, {unit = "CS_swat_R870", freq = 0.40000000596046, amount_max = 2, tactics = tactics_CS_swat_shotgun, rank = 1}, {unit = "CS_swat_MP5", freq = 0.20000000298023, tactics = tactics_CS_swat_rifle_flank, rank = 3}}}
  l_4_0.enemy_spawn_groups.CS_heavys = {amount = {3, 4}, spawn = {{unit = "CS_heavy_M4", freq = 1, tactics = tactics_CS_swat_rifle, rank = 1}, {unit = "CS_heavy_M4", freq = 0.34999999403954, tactics = tactics_CS_swat_rifle_flank, rank = 2}}}
  l_4_0.enemy_spawn_groups.CS_shields = {amount = {3, 4}, spawn = {{unit = "CS_shield", freq = 1, amount_min = 1, amount_max = 1, tactics = tactics_CS_shield, rank = 3}, {unit = "CS_shield", freq = 0.10000000149012, amount_max = 1, tactics = tactics_CS_shield, rank = 2}, {unit = "CS_heavy_M4_w", freq = 1, amount_min = 1, tactics = tactics_CS_swat_heavy, rank = 1}}}
  l_4_0.enemy_spawn_groups.CS_tazers = {amount = {2, 2}, spawn = {{unit = "CS_tazer", freq = 1, amount_min = 2, amount_max = 2, tactics = tactics_CS_tazer, rank = 1}}}
  l_4_0.enemy_spawn_groups.CS_tanks = {amount = {1, 1}, spawn = {{unit = "FBI_tank", freq = 1, tactics = tactics_FBI_tank, rank = 1}}}
  l_4_0.enemy_spawn_groups.FBI_defend_a = {amount = {3, 4}, spawn = {{unit = "FBI_suit_C45_M4", freq = 1, amount_min = 1, tactics = tactics_FBI_suit, rank = 2}, {unit = "CS_cop_C45_R870", freq = 1, tactics = tactics_FBI_suit, rank = 1}}}
  l_4_0.enemy_spawn_groups.FBI_defend_b = {amount = {3, 4}, spawn = {{unit = "FBI_suit_M4_MP5", freq = 1, amount_min = 1, tactics = tactics_FBI_suit, rank = 2}, {unit = "FBI_swat_M4", freq = 1, tactics = tactics_FBI_suit, rank = 1}}}
  l_4_0.enemy_spawn_groups.FBI_defend_c = {amount = {3, 4}, spawn = {{unit = "FBI_swat_M4", freq = 1, tactics = tactics_FBI_suit, rank = 1}}}
  l_4_0.enemy_spawn_groups.FBI_defend_d = {amount = {3, 4}, spawn = {{unit = "FBI_heavy_G36", freq = 1, tactics = tactics_FBI_suit, rank = 1}}}
  l_4_0.enemy_spawn_groups.FBI_stealth_a = {amount = {2, 3}, spawn = {{unit = "FBI_suit_stealth_MP5", freq = 1, amount_min = 1, tactics = tactics_FBI_suit_stealth, rank = 1}}}
  l_4_0.enemy_spawn_groups.FBI_stealth_b = {amount = {2, 4}, spawn = {{unit = "FBI_suit_stealth_MP5", freq = 1, amount_min = 1, tactics = tactics_FBI_suit_stealth, rank = 1}}}
  l_4_0.enemy_spawn_groups.FBI_swats = {amount = {3, 4}, spawn = {{unit = "FBI_swat_M4", freq = 1, amount_min = 1, tactics = tactics_FBI_swat_rifle, rank = 2}, {unit = "FBI_swat_M4", freq = 0.75, tactics = tactics_FBI_swat_rifle_flank, rank = 3}, {unit = "FBI_swat_R870", freq = 0.5, amount_max = 2, tactics = tactics_FBI_swat_shotgun, rank = 1}}}
  l_4_0.enemy_spawn_groups.FBI_heavys = {amount = {3, 4}, spawn = {{unit = "FBI_heavy_G36", freq = 1, tactics = tactics_FBI_swat_rifle, rank = 1}, {unit = "FBI_heavy_G36", freq = 0.5, tactics = tactics_FBI_swat_rifle_flank, rank = 2}}}
  l_4_0.enemy_spawn_groups.FBI_shields = {amount = {3, 4}, spawn = {{unit = "FBI_shield", freq = 0.30000001192093, amount_min = 1, amount_max = 2, tactics = tactics_FBI_shield_flank, rank = 3}, {unit = "FBI_heavy_G36_w", freq = 1, amount_min = 1, tactics = tactics_FBI_heavy_flank, rank = 1}}}
  l_4_0.enemy_spawn_groups.FBI_spoocs = {amount = {2, 2}, spawn = {{unit = "FBI_suit_stealth_MP5", freq = 1, amount_min = 1, tactics = tactics_FBI_suit_stealth, rank = 1}}}
  l_4_0.enemy_spawn_groups.FBI_tanks = {amount = {1, 2}, spawn = {{unit = "FBI_tank", freq = 1, tactics = tactics_FBI_tank, rank = 1}}}
end

GroupAITweakData._init_task_data = function(l_5_0)
  local is_console = SystemInfo:platform() ~= Idstring("WIN32")
  l_5_0.max_nr_simultaneous_boss_types = 0
  l_5_0.difficulty_curve_points = {0.5}
  l_5_0.optimal_trade_distance = {0, 0}
  l_5_0.bain_assault_praise_limits = {1, 3}
  l_5_0.besiege.regroup.duration = {15, 15, 15}
  l_5_0.besiege.assault.anticipation_duration = {{30, 1}, {30, 1}, {45, 0.5}}
  l_5_0.besiege.assault.build_duration = 35
  l_5_0.besiege.assault.sustain_duration_min = {0, 80, 120}
  l_5_0.besiege.assault.sustain_duration_max = {0, 80, 120}
  l_5_0.besiege.assault.sustain_duration_balance_mul = {1, 1.1000000238419, 1.2000000476837, 1.2999999523163}
  l_5_0.besiege.assault.fade_duration = 5
  l_5_0.besiege.assault.delay = {80, 70, 30}
  l_5_0.besiege.assault.hostage_hesitation_delay = {30, 30, 30}
  if is_console then
    l_5_0.besiege.assault.force = {0, 4, 6}
    l_5_0.besiege.assault.force_pool = {0, 60, 100}
  else
    l_5_0.besiege.assault.force = {0, 5, 7}
    l_5_0.besiege.assault.force_pool = {0, 20, 50}
  end
  if is_console then
    l_5_0.besiege.assault.force_balance_mul = {1, 1.1000000238419, 1.2000000476837, 1.2999999523163}
    l_5_0.besiege.assault.force_pool_balance_mul = {1, 1.1000000238419, 1.2000000476837, 1.2999999523163}
  else
    l_5_0.besiege.assault.force_balance_mul = {1, 1.5, 2, 2.25}
    l_5_0.besiege.assault.force_pool_balance_mul = {1, 1.5, 2, 3}
  end
  l_5_0.besiege.assault.groups = {CS_swats = {0, 1, 0.69999998807907}, CS_heavys = {0, 0, 0.5}, CS_shields = {0, 0, 0.10000000149012}}
  l_5_0.besiege.reenforce.interval = {10, 20, 30}
  l_5_0.besiege.reenforce.groups = {CS_defend_a = {1, 0.20000000298023, 0}, CS_defend_b = {0, 1, 1}}
  l_5_0.besiege.recon.interval = {5, 5, 5}
  l_5_0.besiege.recon.force = {2, 4, 6}
  l_5_0.besiege.recon.interval_variation = 40
  l_5_0.besiege.recon.groups = {CS_stealth_a = {1, 1, 0}, CS_swats = {0, 1, 1}}
  print("-------------\\//\\//\\//\\//\\//\\//\\//\\//\\//-------------")
  print("-------------//\\//\\//\\//\\//\\//\\//\\//\\//\\-------------")
  print("-------------\\//> GroupAI Data Initialized <\\//-------------")
  print("-------------//\\//\\//\\//\\//\\//\\//\\//\\//\\-------------")
  print("-------------\\//\\//\\//\\//\\//\\//\\//\\//\\//-------------")
end

GroupAITweakData._set_easy = function(l_6_0)
  print("-------------\\//\\//\\//\\//\\//\\//\\//\\//\\//-------------")
  print("-------------//\\//\\//\\//\\//\\//\\//\\//\\//\\-------------")
  print("-------------\\//> Difficulty set to : Easy <\\//-------------")
  print("-------------//\\//\\//\\//\\//\\//\\//\\//\\//\\-------------")
  print("-------------\\//\\//\\//\\//\\//\\//\\//\\//\\//-------------")
end

GroupAITweakData._set_normal = function(l_7_0)
  print("-------------\\//\\//\\//\\//\\//\\//\\//\\//\\//\\-------------")
  print("-------------//\\//\\//\\//\\//\\//\\//\\//\\//\\//-------------")
  print("-------------\\//> Difficulty set to : Normal <//\\-------------")
  print("-------------//\\//\\//\\//\\//\\//\\//\\//\\//\\//-------------")
  print("-------------\\//\\//\\//\\//\\//\\//\\//\\//\\//\\-------------")
end

GroupAITweakData._set_hard = function(l_8_0)
  print("-------------\\//\\//\\//\\//\\//\\//\\//\\//\\//-------------")
  print("-------------//\\//\\//\\//\\//\\//\\//\\//\\//\\-------------")
  print("-------------\\//> Difficulty set to : Hard <\\//-------------")
  print("-------------//\\//\\//\\//\\//\\//\\//\\//\\//\\-------------")
  print("-------------\\//\\//\\//\\//\\//\\//\\//\\//\\//-------------")
  l_8_0.besiege.assault.groups = {CS_swats = {0, 1, 0}, CS_heavys = {0, 0.20000000298023, 1}, CS_shields = {0, 0.019999999552965, 1}, CS_tazers = {0, 0.0099999997764826, 0.20000000298023}, CS_tanks = {0, 0.0099999997764826, 0.10000000149012}}
  l_8_0.besiege.reenforce.interval = {10, 20, 30}
  l_8_0.besiege.reenforce.groups = {CS_defend_a = {1, 0, 0}, CS_defend_b = {2, 1, 0}, CS_defend_c = {0, 0, 1}}
  l_8_0.besiege.assault.delay = {45, 35, 20}
  l_8_0.besiege.recon.interval = {5, 5, 5}
  l_8_0.besiege.recon.force = {2, 4, 6}
  l_8_0.besiege.recon.interval_variation = 40
  l_8_0.besiege.recon.groups = {CS_stealth_a = {1, 0, 0}, CS_swats = {0, 1, 1}, CS_tazers = {0, 0, 0.20000000298023}, FBI_stealth_b = {0, 0, 0.10000000149012}}
  l_8_0.besiege.assault.force_balance_mul = {1.5, 1.6000000238419, 1.7000000476837, 1.7999999523163}
  l_8_0.besiege.assault.force_pool_balance_mul = {1.2000000476837, 1.3999999761581, 1.6000000238419, 1.7999999523163}
end

GroupAITweakData._set_overkill = function(l_9_0)
  print("-------------\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//-------------")
  print("-------------//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\-------------")
  print("-------------\\//> Difficulty set to : Overkill <\\//-------------")
  print("-------------//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\-------------")
  print("-------------\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//-------------")
  l_9_0.besiege.assault.groups = {FBI_swats = {0, 1, 0.25}, FBI_heavys = {0, 0.20000000298023, 1}, FBI_shields = {0, 0.20000000298023, 1}, FBI_tanks = {0, 0.0099999997764826, 0.050000000745058}, CS_tazers = {0, 0.10000000149012, 0.20000000298023}}
  l_9_0.besiege.reenforce.interval = {10, 20, 30}
  l_9_0.besiege.reenforce.groups = {CS_defend_a = {1, 0, 0}, CS_defend_b = {2, 1, 0}, CS_defend_c = {0, 0, 1}, FBI_defend_a = {0, 1, 0}, FBI_defend_b = {0, 0, 1}}
  l_9_0.besiege.assault.delay = {40, 30, 20}
  l_9_0.besiege.recon.interval = {5, 5, 5}
  l_9_0.besiege.recon.force = {2, 4, 6}
  l_9_0.besiege.recon.interval_variation = 40
  l_9_0.besiege.recon.groups = {FBI_stealth_a = {1, 1, 0}, FBI_stealth_b = {0, 0, 1}}
  l_9_0.besiege.assault.force_balance_mul = {1.7999999523163, 1.8999999761581, 2, 2.0999999046326}
  l_9_0.besiege.assault.force_pool_balance_mul = {1.6000000238419, 1.7999999523163, 2, 2.2000000476837}
end

GroupAITweakData._set_overkill_145 = function(l_10_0)
  print("-------------//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\-------------")
  print("-------------\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//-------------")
  print("-------------//\\> Difficulty set to : Overkill_145 <//\\-------------")
  print("-------------\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//-------------")
  print("-------------//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\-------------")
  l_10_0.besiege.assault.groups = {FBI_swats = {0, 1, 0}, FBI_heavys = {0, 1, 1}, FBI_shields = {0, 0.5, 1}, FBI_tanks = {0, 0.10000000149012, 0.10000000149012}, CS_tazers = {0, 0.10000000149012, 0.20000000298023}}
  l_10_0.besiege.reenforce.interval = {10, 20, 30}
  l_10_0.besiege.reenforce.groups = {CS_defend_a = {0.10000000149012, 0, 0}, FBI_defend_b = {1, 1, 0}, FBI_defend_c = {0, 1, 0}, FBI_defend_d = {0, 0, 1}}
  l_10_0.besiege.assault.delay = {30, 20, 15}
  l_10_0.besiege.recon.interval = {5, 5, 5}
  l_10_0.besiege.recon.force = {2, 4, 6}
  l_10_0.besiege.recon.interval_variation = 40
  l_10_0.besiege.recon.groups = {FBI_stealth_a = {1, 0.5, 0}, FBI_stealth_b = {0, 1, 1}}
  l_10_0.besiege.assault.force_balance_mul = {1.7999999523163, 1.8999999761581, 2, 2.0999999046326}
  l_10_0.besiege.assault.force_pool_balance_mul = {2, 2.2000000476837, 2.4000000953674, 2.5999999046326}
end

GroupAITweakData._read_mission_preset = function(l_11_0, l_11_1)
  if not Global.game_settings then
    return 
  end
  local lvl_tweak_data = l_11_1.levels[Global.game_settings.level_id]
  l_11_0._mission_preset = lvl_tweak_data.group_ai_preset
end

GroupAITweakData._create_table_structure = function(l_12_0)
  l_12_0.enemy_chatter = {}
  l_12_0.enemy_spawn_groups = {}
  l_12_0.besiege = {regroup = {}, assault = {force = {}}, reenforce = {}, recon = {}, rescue = {}}
  l_12_0.street = {blockade = {force = {}}, assault = {force = {}}, regroup = {}, capture = {force = {}}}
end


