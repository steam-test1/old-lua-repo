-- Decompiled using luadec 2.0.1 by sztupy (http://winmo.sztupy.hu)
-- Command line was: F:\SteamLibrary\SteamApps\common\PAYDAY 2\lua\lib\tweak_data\charactertweakdata.luac 

if not CharacterTweakData then
  CharacterTweakData = class()
end
CharacterTweakData.init = function(l_1_0, l_1_1)
  l_1_0:_create_table_structure()
  local presets = l_1_0:_presets(l_1_1)
  l_1_0.presets = presets
  l_1_0:_init_security(presets)
  l_1_0:_init_cop(presets)
  l_1_0:_init_fbi(presets)
  l_1_0:_init_swat(presets)
  l_1_0:_init_heavy_swat(presets)
  l_1_0:_init_fbi_swat(presets)
  l_1_0:_init_fbi_heavy_swat(presets)
  l_1_0:_init_sniper(presets)
  l_1_0:_init_gangster(presets)
  l_1_0:_init_biker_escape(presets)
  l_1_0:_init_tank(presets)
  l_1_0:_init_spooc(presets)
  l_1_0:_init_shield(presets)
  l_1_0:_init_taser(presets)
  l_1_0:_init_civilian(presets)
  l_1_0:_init_bank_manager(presets)
  l_1_0:_init_russian(presets)
  l_1_0:_init_german(presets)
  l_1_0:_init_spanish(presets)
  l_1_0:_init_american(presets)
end

CharacterTweakData._init_security = function(l_2_0, l_2_1)
  l_2_0.security = deep_clone(l_2_1.base)
  l_2_0.security.experience = {}
  l_2_0.security.weapon = l_2_1.weapon.normal
  l_2_0.security.detection = l_2_1.detection.guard
  l_2_0.security.HEALTH_INIT = 3
  l_2_0.security.headshot_dmg_mul = l_2_0.security.HEALTH_INIT / 1
  l_2_0.security.move_speed = l_2_1.move_speed.normal
  l_2_0.security.crouch_move = nil
  l_2_0.security.surrender_break_time = {20, 30}
  l_2_0.security.suppression = l_2_1.suppression.easy
  l_2_0.security.surrender = l_2_1.surrender.easy
  l_2_0.security.ecm_vulnerability = 0.80000001192093
  l_2_0.security.ecm_hurts = {ears = {min_duration = 1, max_duration = 3}}
  l_2_0.security.weapon_voice = "3"
  l_2_0.security.experience.cable_tie = "tie_swat"
  l_2_0.security.speech_prefix_p1 = "l"
  l_2_0.security.speech_prefix_p2 = "n"
  l_2_0.security.speech_prefix_count = 4
  l_2_0.security.access = "security"
  l_2_0.security.rescue_hostages = false
  l_2_0.security.use_radio = nil
  l_2_0.security.silent_priority_shout = "Dia_10"
  l_2_0.security.dodge = l_2_1.dodge.poor
  l_2_0.security.deathguard = false
  l_2_0.security.chatter = l_2_1.enemy_chatter.cop
  l_2_0.security.has_alarm_pager = true
end

CharacterTweakData._init_cop = function(l_3_0, l_3_1)
  l_3_0.cop = deep_clone(l_3_1.base)
  l_3_0.cop.experience = {}
  l_3_0.cop.weapon = l_3_1.weapon.normal
  l_3_0.cop.detection = l_3_1.detection.normal
  l_3_0.cop.HEALTH_INIT = 3
  l_3_0.cop.headshot_dmg_mul = l_3_0.cop.HEALTH_INIT / 1
  l_3_0.cop.move_speed = l_3_1.move_speed.normal
  l_3_0.cop.surrender_break_time = {10, 15}
  l_3_0.cop.suppression = l_3_1.suppression.easy
  l_3_0.cop.surrender = l_3_1.surrender.normal
  l_3_0.cop.ecm_vulnerability = 0.80000001192093
  l_3_0.cop.ecm_hurts = {ears = {min_duration = 1, max_duration = 3}}
  l_3_0.cop.weapon_voice = "1"
  l_3_0.cop.experience.cable_tie = "tie_swat"
  l_3_0.cop.speech_prefix_p1 = "l"
  l_3_0.cop.speech_prefix_p2 = "n"
  l_3_0.cop.speech_prefix_count = 4
  l_3_0.cop.access = "cop"
  l_3_0.cop.dodge = l_3_1.dodge.average
  l_3_0.cop.follower = true
  l_3_0.cop.deathguard = true
  l_3_0.cop.chatter = l_3_1.enemy_chatter.cop
end

CharacterTweakData._init_fbi = function(l_4_0, l_4_1)
  l_4_0.fbi = deep_clone(l_4_1.base)
  l_4_0.fbi.experience = {}
  l_4_0.fbi.weapon = l_4_1.weapon.normal
  l_4_0.fbi.detection = l_4_1.detection.normal
  l_4_0.fbi.HEALTH_INIT = 4
  l_4_0.fbi.headshot_dmg_mul = l_4_0.fbi.HEALTH_INIT / 1
  l_4_0.fbi.move_speed = l_4_1.move_speed.normal
  l_4_0.fbi.surrender_break_time = {7, 12}
  l_4_0.fbi.suppression = l_4_1.suppression.easy
  l_4_0.fbi.surrender = l_4_1.surrender.normal
  l_4_0.fbi.ecm_vulnerability = 0.60000002384186
  l_4_0.fbi.ecm_hurts = {ears = {min_duration = 1, max_duration = 3}}
  l_4_0.fbi.weapon_voice = "2"
  l_4_0.fbi.experience.cable_tie = "tie_swat"
  l_4_0.fbi.speech_prefix_p1 = "l"
  l_4_0.fbi.speech_prefix_p2 = "n"
  l_4_0.fbi.speech_prefix_count = 4
  l_4_0.fbi.access = "fbi"
  l_4_0.fbi.dodge = l_4_1.dodge.athletic
  l_4_0.fbi.follower = true
  l_4_0.fbi.deathguard = true
  l_4_0.fbi.no_arrest = true
  l_4_0.fbi.chatter = l_4_1.enemy_chatter.cop
end

CharacterTweakData._init_swat = function(l_5_0, l_5_1)
  l_5_0.swat = deep_clone(l_5_1.base)
  l_5_0.swat.experience = {}
  l_5_0.swat.weapon = l_5_1.weapon.normal
  l_5_0.swat.detection = l_5_1.detection.normal
  l_5_0.swat.HEALTH_INIT = 10
  l_5_0.swat.headshot_dmg_mul = l_5_0.swat.HEALTH_INIT / 2
  l_5_0.swat.move_speed = l_5_1.move_speed.fast
  l_5_0.swat.surrender_break_time = {6, 10}
  l_5_0.swat.suppression = l_5_1.suppression.hard_def
  l_5_0.swat.surrender = l_5_1.surrender.normal
  l_5_0.swat.ecm_vulnerability = 0.40000000596046
  l_5_0.swat.ecm_hurts = {ears = {min_duration = 1, max_duration = 3}}
  l_5_0.swat.weapon_voice = "2"
  l_5_0.swat.experience.cable_tie = "tie_swat"
  l_5_0.swat.speech_prefix_p1 = "l"
  l_5_0.swat.speech_prefix_p2 = "n"
  l_5_0.swat.speech_prefix_count = 4
  l_5_0.swat.access = "swat"
  l_5_0.swat.dodge = l_5_1.dodge.athletic
  l_5_0.swat.follower = true
  l_5_0.swat.no_arrest = true
  l_5_0.swat.chatter = l_5_1.enemy_chatter.swat
end

CharacterTweakData._init_heavy_swat = function(l_6_0, l_6_1)
  l_6_0.heavy_swat = deep_clone(l_6_1.base)
  l_6_0.heavy_swat.experience = {}
  l_6_0.heavy_swat.weapon = l_6_1.weapon.normal
  l_6_0.heavy_swat.detection = l_6_1.detection.normal
  l_6_0.heavy_swat.HEALTH_INIT = 16
  l_6_0.heavy_swat.headshot_dmg_mul = l_6_0.heavy_swat.HEALTH_INIT / 6
  l_6_0.heavy_swat.move_speed = l_6_1.move_speed.fast
  l_6_0.heavy_swat.surrender_break_time = {6, 8}
  l_6_0.heavy_swat.suppression = l_6_1.suppression.hard_agg
  l_6_0.heavy_swat.surrender = l_6_1.surrender.normal
  l_6_0.heavy_swat.ecm_vulnerability = 0.20000000298023
  l_6_0.heavy_swat.ecm_hurts = {ears = {min_duration = 1, max_duration = 3}}
  l_6_0.heavy_swat.weapon_voice = "2"
  l_6_0.heavy_swat.experience.cable_tie = "tie_swat"
  l_6_0.heavy_swat.speech_prefix_p1 = "l"
  l_6_0.heavy_swat.speech_prefix_p2 = "n"
  l_6_0.heavy_swat.speech_prefix_count = 4
  l_6_0.heavy_swat.access = "swat"
  l_6_0.heavy_swat.dodge = l_6_1.dodge.heavy
  l_6_0.heavy_swat.follower = true
  l_6_0.heavy_swat.no_arrest = true
  l_6_0.heavy_swat.chatter = l_6_1.enemy_chatter.swat
end

CharacterTweakData._init_fbi_swat = function(l_7_0, l_7_1)
  l_7_0.fbi_swat = deep_clone(l_7_1.base)
  l_7_0.fbi_swat.experience = {}
  l_7_0.fbi_swat.weapon = l_7_1.weapon.normal
  l_7_0.fbi_swat.detection = l_7_1.detection.normal
  l_7_0.fbi_swat.HEALTH_INIT = 10
  l_7_0.fbi_swat.headshot_dmg_mul = l_7_0.fbi_swat.HEALTH_INIT / 4
  l_7_0.fbi_swat.move_speed = l_7_1.move_speed.very_fast
  l_7_0.fbi_swat.surrender_break_time = {6, 10}
  l_7_0.fbi_swat.suppression = l_7_1.suppression.hard_def
  l_7_0.fbi_swat.surrender = l_7_1.surrender.normal
  l_7_0.fbi_swat.ecm_vulnerability = 0.40000000596046
  l_7_0.fbi_swat.ecm_hurts = {ears = {min_duration = 1, max_duration = 3}}
  l_7_0.fbi_swat.weapon_voice = "2"
  l_7_0.fbi_swat.experience.cable_tie = "tie_swat"
  l_7_0.fbi_swat.speech_prefix_p1 = "l"
  l_7_0.fbi_swat.speech_prefix_p2 = "n"
  l_7_0.fbi_swat.speech_prefix_count = 4
  l_7_0.fbi_swat.access = "swat"
  l_7_0.fbi_swat.dodge = l_7_1.dodge.athletic
  l_7_0.fbi_swat.follower = true
  l_7_0.fbi_swat.no_arrest = true
  l_7_0.fbi_swat.chatter = l_7_1.enemy_chatter.swat
end

CharacterTweakData._init_fbi_heavy_swat = function(l_8_0, l_8_1)
  l_8_0.fbi_heavy_swat = deep_clone(l_8_1.base)
  l_8_0.fbi_heavy_swat.experience = {}
  l_8_0.fbi_heavy_swat.weapon = l_8_1.weapon.normal
  l_8_0.fbi_heavy_swat.detection = l_8_1.detection.normal
  l_8_0.fbi_heavy_swat.HEALTH_INIT = 20
  l_8_0.fbi_heavy_swat.headshot_dmg_mul = l_8_0.fbi_heavy_swat.HEALTH_INIT / 10
  l_8_0.fbi_heavy_swat.move_speed = l_8_1.move_speed.fast
  l_8_0.fbi_heavy_swat.surrender_break_time = {6, 8}
  l_8_0.fbi_heavy_swat.suppression = l_8_1.suppression.hard_agg
  l_8_0.fbi_heavy_swat.surrender = l_8_1.surrender.normal
  l_8_0.fbi_heavy_swat.ecm_vulnerability = 0.20000000298023
  l_8_0.fbi_heavy_swat.ecm_hurts = {ears = {min_duration = 1, max_duration = 3}}
  l_8_0.fbi_heavy_swat.weapon_voice = "2"
  l_8_0.fbi_heavy_swat.experience.cable_tie = "tie_swat"
  l_8_0.fbi_heavy_swat.speech_prefix_p1 = "l"
  l_8_0.fbi_heavy_swat.speech_prefix_p2 = "n"
  l_8_0.fbi_heavy_swat.speech_prefix_count = 4
  l_8_0.fbi_heavy_swat.access = "swat"
  l_8_0.fbi_heavy_swat.dodge = l_8_1.dodge.heavy
  l_8_0.fbi_heavy_swat.follower = true
  l_8_0.fbi_heavy_swat.no_arrest = true
  l_8_0.fbi_heavy_swat.chatter = l_8_1.enemy_chatter.swat
end

CharacterTweakData._init_sniper = function(l_9_0, l_9_1)
  l_9_0.sniper = deep_clone(l_9_1.base)
  l_9_0.sniper.experience = {}
  l_9_0.sniper.weapon = l_9_1.weapon.sniper
  l_9_0.sniper.detection = l_9_1.detection.sniper
  l_9_0.sniper.HEALTH_INIT = 4
  l_9_0.sniper.headshot_dmg_mul = l_9_0.sniper.HEALTH_INIT / 2
  l_9_0.sniper.move_speed = l_9_1.move_speed.normal
  l_9_0.sniper.shooting_death = false
  l_9_0.sniper.suppression = l_9_1.suppression.easy
  l_9_0.sniper.ecm_vulnerability = 0.5
  l_9_0.sniper.ecm_hurts = {ears = {min_duration = 1, max_duration = 3}}
  l_9_0.sniper.weapon_voice = "1"
  l_9_0.sniper.experience.cable_tie = "tie_swat"
  l_9_0.sniper.speech_prefix_p1 = "l"
  l_9_0.sniper.speech_prefix_p2 = "n"
  l_9_0.sniper.speech_prefix_count = 4
  l_9_0.sniper.priority_shout = "f34"
  l_9_0.sniper.access = "sniper"
  l_9_0.sniper.no_retreat = true
  l_9_0.sniper.no_arrest = true
  l_9_0.sniper.chatter = l_9_1.enemy_chatter.no_chatter
end

CharacterTweakData._init_gangster = function(l_10_0, l_10_1)
  l_10_0.gangster = deep_clone(l_10_1.base)
  l_10_0.gangster.experience = {}
  l_10_0.gangster.weapon = l_10_1.weapon.normal
  l_10_0.gangster.detection = l_10_1.detection.normal
  l_10_0.gangster.HEALTH_INIT = 4
  l_10_0.gangster.headshot_dmg_mul = l_10_0.gangster.HEALTH_INIT / 1
  l_10_0.gangster.move_speed = l_10_1.move_speed.fast
  l_10_0.gangster.suspicious = nil
  l_10_0.gangster.suppression = l_10_1.suppression.easy
  l_10_0.gangster.surrender = nil
  l_10_0.gangster.ecm_vulnerability = 0.69999998807907
  l_10_0.gangster.ecm_hurts = {ears = {min_duration = 1, max_duration = 3}}
  l_10_0.gangster.no_arrest = true
  l_10_0.gangster.no_retreat = true
  l_10_0.gangster.weapon_voice = "3"
  l_10_0.gangster.experience.cable_tie = "tie_swat"
  l_10_0.gangster.speech_prefix_p1 = "l"
  l_10_0.gangster.speech_prefix_p2 = "n"
  l_10_0.gangster.speech_prefix_count = 4
  l_10_0.gangster.access = "gangster"
  l_10_0.gangster.rescue_hostages = false
  l_10_0.gangster.use_radio = nil
  l_10_0.gangster.dodge = l_10_1.dodge.average
  l_10_0.gangster.challenges = {type = "gangster"}
  l_10_0.gangster.chatter = l_10_1.enemy_chatter.no_chatter
end

CharacterTweakData._init_biker_escape = function(l_11_0, l_11_1)
  l_11_0.biker_escape = deep_clone(l_11_0.gangster)
  l_11_0.biker_escape.move_speed = l_11_1.move_speed.very_fast
  l_11_0.biker_escape.HEALTH_INIT = 8
  l_11_0.biker_escape.suppression = nil
end

CharacterTweakData._init_tank = function(l_12_0, l_12_1)
  l_12_0.tank = deep_clone(l_12_1.base)
  l_12_0.tank.experience = {}
  l_12_0.tank.weapon = deep_clone(l_12_1.weapon.expert)
  l_12_0.tank.weapon.r870.FALLOFF[1].dmg_mul = 6
  l_12_0.tank.weapon.r870.FALLOFF[2].dmg_mul = 4
  l_12_0.tank.weapon.r870.FALLOFF[3].dmg_mul = 2
  l_12_0.tank.weapon.r870.RELOAD_SPEED = 1
  l_12_0.tank.detection = l_12_1.detection.normal
  l_12_0.tank.HEALTH_INIT = 125
  l_12_0.tank.headshot_dmg_mul = l_12_0.tank.HEALTH_INIT / 24
  l_12_0.tank.move_speed = l_12_1.move_speed.slow
  l_12_0.tank.allowed_stances = {cbt = true}
  l_12_0.tank.allowed_poses = {stand = true}
  l_12_0.tank.crouch_move = false
  l_12_0.tank.allow_crouch = false
  l_12_0.tank.no_run_start = true
  l_12_0.tank.no_run_stop = true
  l_12_0.tank.no_retreat = true
  l_12_0.tank.no_arrest = true
  l_12_0.tank.surrender = nil
  l_12_0.tank.ecm_vulnerability = 0.10000000149012
  l_12_0.tank.ecm_hurts = {ears = {min_duration = 1, max_duration = 3}}
  l_12_0.tank.weapon_voice = "3"
  l_12_0.tank.experience.cable_tie = "tie_swat"
  l_12_0.tank.access = "tank"
  l_12_0.tank.speech_prefix_p1 = "bdz"
  l_12_0.tank.speech_prefix_p2 = nil
  l_12_0.tank.speech_prefix_count = nil
  l_12_0.tank.priority_shout = "f30"
  l_12_0.tank.rescue_hostages = false
  l_12_0.tank.damage.hurt_severity = l_12_1.hurt_severities.only_light_hurt
  l_12_0.tank.chatter = {aggressive = true, retreat = true, go_go = true, contact = true, entrance = true}
  l_12_0.tank.announce_incomming = "incomming_tank"
end

CharacterTweakData._init_spooc = function(l_13_0, l_13_1)
  l_13_0.spooc = deep_clone(l_13_1.base)
  l_13_0.spooc.experience = {}
  l_13_0.spooc.weapon = deep_clone(l_13_1.weapon.normal)
  l_13_0.spooc.detection = l_13_1.detection.normal
  l_13_0.spooc.HEALTH_INIT = 16
  l_13_0.spooc.headshot_dmg_mul = l_13_0.spooc.HEALTH_INIT / 6
  l_13_0.spooc.move_speed = l_13_1.move_speed.lightning
  l_13_0.spooc.SPEED_SPRINT = 670
  l_13_0.spooc.no_retreat = true
  l_13_0.spooc.no_arrest = true
  l_13_0.spooc.damage.hurt_severity = l_13_1.hurt_severities.no_hurts
  l_13_0.spooc.surrender_break_time = {4, 6}
  l_13_0.spooc.suppression = nil
  l_13_0.spooc.surrender = l_13_1.surrender.special
  l_13_0.spooc.ecm_vulnerability = 0.15000000596046
  l_13_0.spooc.ecm_hurts = {ears = {min_duration = 1, max_duration = 3}}
  l_13_0.spooc.priority_shout = "f33"
  l_13_0.spooc.rescue_hostages = false
  l_13_0.spooc.weapon.beretta92.choice_chance = 0
  l_13_0.spooc.weapon.m4.choice_chance = 1
  l_13_0.spooc.weapon.r870.choice_chance = 0
  l_13_0.spooc.weapon.mp5.choice_chance = 1
  l_13_0.spooc.weapon_voice = "3"
  l_13_0.spooc.experience.cable_tie = "tie_swat"
  l_13_0.spooc.speech_prefix_p1 = "l"
  l_13_0.spooc.speech_prefix_p2 = "n"
  l_13_0.spooc.speech_prefix_count = 4
  l_13_0.spooc.access = "spooc"
  l_13_0.spooc.dodge = l_13_1.dodge.ninja
  l_13_0.spooc.follower = true
  l_13_0.spooc.chatter = l_13_1.enemy_chatter.no_chatter
  l_13_0.spooc.announce_incomming = "incomming_spooc"
end

CharacterTweakData._init_shield = function(l_14_0, l_14_1)
  l_14_0.shield = deep_clone(l_14_1.base)
  l_14_0.shield.experience = {}
  l_14_0.shield.weapon = deep_clone(l_14_1.weapon.normal)
  l_14_0.shield.detection = l_14_1.detection.normal
  l_14_0.shield.HEALTH_INIT = 10
  l_14_0.shield.headshot_dmg_mul = l_14_0.shield.HEALTH_INIT / 6
  l_14_0.shield.allowed_stances = {cbt = true}
  l_14_0.shield.allowed_poses = {crouch = true}
  l_14_0.shield.move_speed = l_14_1.move_speed.fast
  l_14_0.shield.no_run_start = true
  l_14_0.shield.no_run_stop = true
  l_14_0.shield.no_retreat = true
  l_14_0.shield.no_stand = true
  l_14_0.shield.no_arrest = true
  l_14_0.shield.surrender = nil
  l_14_0.shield.ecm_vulnerability = 0.40000000596046
  l_14_0.shield.ecm_hurts = {ears = {min_duration = 1, max_duration = 3}}
  l_14_0.shield.priority_shout = "f31"
  l_14_0.shield.rescue_hostages = false
  l_14_0.shield.deathguard = true
  l_14_0.shield.no_equip_anim = true
  l_14_0.shield.wall_fwd_offset = 100
  l_14_0.shield.damage.hurt_severity = l_14_1.hurt_severities.no_hurts
  l_14_0.shield.damage.shield_knocked = true
  l_14_0.shield.weapon.mp9 = {}
  l_14_0.shield.weapon.mp9.choice_chance = 1
  l_14_0.shield.weapon.mp9.aim_delay = {0, 0.30000001192093}
  l_14_0.shield.weapon.mp9.focus_delay = 6
  l_14_0.shield.weapon.mp9.focus_dis = 250
  l_14_0.shield.weapon.mp9.spread = 60
  l_14_0.shield.weapon.mp9.miss_dis = 15
  l_14_0.shield.weapon.mp9.RELOAD_SPEED = 2
  l_14_0.shield.weapon.mp9.melee_speed = nil
  l_14_0.shield.weapon.mp9.melee_dmg = nil
  l_14_0.shield.weapon.mp9.range = {close = 500, optimal = 700, far = 1200}
  l_14_0.shield.weapon.mp9.FALLOFF = {{r = 0, acc = {0.10000000149012, 0.60000002384186}, dmg_mul = 4, recoil = {0.34999999403954, 0.55000001192093}, mode = {0.20000000298023, 2, 4, 10}}, {r = 700, acc = {0.10000000149012, 0.60000002384186}, dmg_mul = 1, recoil = {0.34999999403954, 0.55000001192093}, mode = {0.20000000298023, 2, 4, 10}}, {r = 1000, acc = {0.10000000149012, 0.40000000596046}, dmg_mul = 1, recoil = {0.34999999403954, 0.55000001192093}, mode = {0.20000000298023, 2, 4, 10}}, {r = 2000, acc = {0.10000000149012, 0.25}, dmg_mul = 1, recoil = {0.34999999403954, 0.55000001192093}, mode = {2, 5, 6, 4}}, {r = 10000, acc = {0.10000000149012, 0.25}, dmg_mul = 1, recoil = {0.34999999403954, 0.55000001192093}, mode = {6, 4, 2, 1}}}
  l_14_0.shield.weapon.c45 = {}
  l_14_0.shield.weapon.c45.choice_chance = 1
  l_14_0.shield.weapon.c45.aim_delay = {0, 0.30000001192093}
  l_14_0.shield.weapon.c45.focus_delay = 6
  l_14_0.shield.weapon.c45.focus_dis = 250
  l_14_0.shield.weapon.c45.spread = 60
  l_14_0.shield.weapon.c45.miss_dis = 15
  l_14_0.shield.weapon.c45.RELOAD_SPEED = 2
  l_14_0.shield.weapon.c45.melee_speed = nil
  l_14_0.shield.weapon.c45.melee_dmg = nil
  l_14_0.shield.weapon.c45.range = {close = 500, optimal = 700, far = 1200}
  l_14_0.shield.weapon.c45.FALLOFF = {{r = 0, acc = {0.10000000149012, 0.60000002384186}, dmg_mul = 4, recoil = {0.34999999403954, 0.55000001192093}, mode = {1, 0, 0, 0}}, {r = 700, acc = {0.10000000149012, 0.60000002384186}, dmg_mul = 1, recoil = {0.34999999403954, 0.55000001192093}, mode = {1, 0, 0, 0}}, {r = 1000, acc = {0.10000000149012, 0.40000000596046}, dmg_mul = 1, recoil = {0.34999999403954, 0.55000001192093}, mode = {1, 0, 0, 0}}, {r = 2000, acc = {0.050000000745058, 0.20000000298023}, dmg_mul = 1, recoil = {0.34999999403954, 0.55000001192093}, mode = {1, 0, 0, 0}}, {r = 10000, acc = {0, 0.15000000596046}, dmg_mul = 1, recoil = {0.34999999403954, 0.55000001192093}, mode = {1, 0, 0, 0}}}
  l_14_0:_process_weapon_usage_table(l_14_0.shield.weapon)
  l_14_0.shield.weapon_voice = "3"
  l_14_0.shield.experience.cable_tie = "tie_swat"
  l_14_0.shield.speech_prefix_p1 = "l"
  l_14_0.shield.speech_prefix_p2 = "n"
  l_14_0.shield.speech_prefix_count = 4
  l_14_0.shield.access = "shield"
  l_14_0.shield.chatter = l_14_1.enemy_chatter.shield
  l_14_0.shield.announce_incomming = "incomming_shield"
end

CharacterTweakData._init_taser = function(l_15_0, l_15_1)
  l_15_0.taser = deep_clone(l_15_1.base)
  l_15_0.taser.experience = {}
  l_15_0.taser.weapon = deep_clone(l_15_1.weapon.normal)
  l_15_0.taser.weapon.m4.tase_distance = 1200
  l_15_0.taser.weapon.m4.aim_delay_tase = {0, 0.10000000149012}
  l_15_0.taser.detection = l_15_1.detection.normal
  l_15_0.taser.HEALTH_INIT = 36
  l_15_0.taser.headshot_dmg_mul = l_15_0.taser.HEALTH_INIT / 8
  l_15_0.taser.move_speed = l_15_1.move_speed.fast
  l_15_0.taser.no_retreat = true
  l_15_0.taser.no_arrest = true
  l_15_0.taser.surrender = l_15_1.surrender.normal
  l_15_0.taser.ecm_vulnerability = 0.10000000149012
  l_15_0.taser.ecm_hurts = {ears = {min_duration = 1, max_duration = 3}}
  l_15_0.taser.surrender_break_time = {4, 6}
  l_15_0.taser.suppression = nil
  l_15_0.taser.damage.hurt_severity = l_15_1.hurt_severities.only_light_hurt
  l_15_0.taser.weapon_voice = "3"
  l_15_0.taser.experience.cable_tie = "tie_swat"
  l_15_0.taser.speech_prefix_p1 = "tsr"
  l_15_0.taser.speech_prefix_p2 = nil
  l_15_0.taser.speech_prefix_count = nil
  l_15_0.taser.access = "taser"
  l_15_0.taser.dodge = l_15_1.dodge.heavy
  l_15_0.taser.priority_shout = "f32"
  l_15_0.taser.rescue_hostages = false
  l_15_0.taser.follower = true
  l_15_0.taser.chatter = {aggressive = true, retreat = true, go_go = true, contact = true, entrance = true}
  l_15_0.taser.announce_incomming = "incomming_taser"
end

CharacterTweakData._init_civilian = function(l_16_0, l_16_1)
  l_16_0.civilian = {experience = {}}
  l_16_0.civilian.detection = l_16_1.detection.civilian
  l_16_0.civilian.HEALTH_INIT = 0.89999997615814
  l_16_0.civilian.headshot_dmg_mul = 1
  l_16_0.civilian.move_speed = l_16_1.move_speed.civ_fast
  l_16_0.civilian.flee_type = "escape"
  l_16_0.civilian.scare_max = {10, 20}
  l_16_0.civilian.scare_shot = 1
  l_16_0.civilian.scare_intimidate = -5
  l_16_0.civilian.submission_max = {60, 120}
  l_16_0.civilian.submission_intimidate = 120
  l_16_0.civilian.run_away_delay = {5, 20}
  l_16_0.civilian.damage = l_16_1.hurt_severities.no_hurts
  l_16_0.civilian.ecm_vulnerability = 0.80000001192093
  l_16_0.civilian.ecm_hurts = {ears = {min_duration = 2, max_duration = 12}}
  l_16_0.civilian.experience.cable_tie = "tie_civ"
  l_16_0.civilian.speech_prefix_p1 = "cm"
  l_16_0.civilian.speech_prefix_count = 2
  l_16_0.civilian.access = "civ_male"
  l_16_0.civilian.intimidateable = true
  l_16_0.civilian.challenges = {type = "civilians"}
  l_16_0.civilian_female = deep_clone(l_16_0.civilian)
  l_16_0.civilian_female.speech_prefix_p1 = "cf"
  l_16_0.civilian_female.speech_prefix_count = 5
  l_16_0.civilian_female.female = true
  l_16_0.civilian_female.access = "civ_female"
end

CharacterTweakData._init_bank_manager = function(l_17_0, l_17_1)
  l_17_0.bank_manager = {experience = {}, escort = {}}
  l_17_0.bank_manager.detection = l_17_1.detection.civilian
  l_17_0.bank_manager.HEALTH_INIT = l_17_0.civilian.HEALTH_INIT
  l_17_0.bank_manager.headshot_dmg_mul = l_17_0.civilian.headshot_dmg_mul
  l_17_0.bank_manager.move_speed = l_17_1.move_speed.normal
  l_17_0.bank_manager.flee_type = "hide"
  l_17_0.bank_manager.scare_max = {10, 20}
  l_17_0.bank_manager.scare_shot = 1
  l_17_0.bank_manager.scare_intimidate = -2
  l_17_0.bank_manager.submission_max = {60, 120}
  l_17_0.bank_manager.submission_intimidate = 60
  l_17_0.bank_manager.damage = l_17_1.hurt_severities.no_hurts
  l_17_0.bank_manager.ecm_vulnerability = 0.80000001192093
  l_17_0.bank_manager.ecm_hurts = {ears = {min_duration = 1, max_duration = 5}}
  l_17_0.bank_manager.experience.cable_tie = "tie_civ"
  l_17_0.bank_manager.speech_prefix_p1 = "cm"
  l_17_0.bank_manager.speech_prefix_count = 2
  l_17_0.bank_manager.escort.scared_duration = 45
  l_17_0.bank_manager.escort.shot_scare = 25
  l_17_0.bank_manager.escort.yell_scare = -25
  l_17_0.bank_manager.escort.yell_timeout = 2
  l_17_0.bank_manager.access = "civ_male"
  l_17_0.bank_manager.intimidateable = true
  l_17_0.bank_manager.challenges = {type = "civilians"}
  l_17_0.bank_manager.outline_on_discover = true
end

CharacterTweakData._init_russian = function(l_18_0, l_18_1)
  l_18_0.russian = {}
  l_18_0.russian.damage = l_18_1.gang_member_damage
  l_18_0.russian.weapon = deep_clone(l_18_1.weapon.gang_member)
  l_18_0.russian.weapon.weapons_of_choice = {primary = Idstring("units/payday2/weapons/wpn_npc_ak47/wpn_npc_ak47"), secondary = Idstring("units/payday2/weapons/wpn_npc_beretta92/wpn_npc_beretta92")}
  l_18_0.russian.detection = l_18_1.detection.gang_member
  l_18_0.russian.move_speed = l_18_1.move_speed.fast
  l_18_0.russian.crouch_move = false
  l_18_0.russian.speech_prefix = "rb2"
  l_18_0.russian.weapon_voice = "1"
  l_18_0.russian.access = "teamAI1"
  l_18_0.russian.arrest = {timeout = 240, aggression_timeout = 6, arrest_timeout = 240}
end

CharacterTweakData._init_german = function(l_19_0, l_19_1)
  l_19_0.german = {}
  l_19_0.german.damage = l_19_1.gang_member_damage
  l_19_0.german.weapon = deep_clone(l_19_1.weapon.gang_member)
  l_19_0.german.weapon.weapons_of_choice = {primary = Idstring("units/payday2/weapons/wpn_npc_mp5/wpn_npc_mp5")}
  l_19_0.german.detection = l_19_1.detection.gang_member
  l_19_0.german.move_speed = l_19_1.move_speed.fast
  l_19_0.german.crouch_move = false
  l_19_0.german.speech_prefix = "rb2"
  l_19_0.german.weapon_voice = "2"
  l_19_0.german.access = "teamAI2"
  l_19_0.german.arrest = {timeout = 240, aggression_timeout = 6, arrest_timeout = 240}
end

CharacterTweakData._init_spanish = function(l_20_0, l_20_1)
  l_20_0.spanish = {}
  l_20_0.spanish.damage = l_20_1.gang_member_damage
  l_20_0.spanish.weapon = deep_clone(l_20_1.weapon.gang_member)
  l_20_0.spanish.weapon.weapons_of_choice = {primary = Idstring("units/payday2/weapons/wpn_npc_m4/wpn_npc_m4"), secondary = Idstring("units/payday2/weapons/wpn_npc_mac11/wpn_npc_mac11")}
  l_20_0.spanish.detection = l_20_1.detection.gang_member
  l_20_0.spanish.move_speed = l_20_1.move_speed.fast
  l_20_0.spanish.crouch_move = false
  l_20_0.spanish.speech_prefix = "rb2"
  l_20_0.spanish.weapon_voice = "3"
  l_20_0.spanish.access = "teamAI3"
  l_20_0.spanish.arrest = {timeout = 240, aggression_timeout = 6, arrest_timeout = 240}
end

CharacterTweakData._init_american = function(l_21_0, l_21_1)
  l_21_0.american = {}
  l_21_0.american.damage = l_21_1.gang_member_damage
  l_21_0.american.weapon = deep_clone(l_21_1.weapon.gang_member)
  l_21_0.american.weapon.weapons_of_choice = {primary = Idstring("units/payday2/weapons/wpn_npc_ak47/wpn_npc_ak47"), secondary = Idstring("units/payday2/weapons/wpn_npc_c45/wpn_npc_c45")}
  l_21_0.american.detection = l_21_1.detection.gang_member
  l_21_0.american.move_speed = l_21_1.move_speed.fast
  l_21_0.american.crouch_move = false
  l_21_0.american.speech_prefix = "rb2"
  l_21_0.american.weapon_voice = "3"
  l_21_0.american.access = "teamAI4"
  l_21_0.american.arrest = {timeout = 240, aggression_timeout = 6, arrest_timeout = 240}
end

CharacterTweakData._presets = function(l_22_0, l_22_1)
  local presets = {}
  presets.hurt_severities = {}
  presets.hurt_severities.no_hurts = {health_reference = 1, zones = {{none = 1}}}
  presets.hurt_severities.only_light_hurt = {health_reference = 1, zones = {{light = 1}}}
  presets.hurt_severities.base = {health_reference = "current", zones = {{health_limit = 0.20000000298023, none = 0, light = 0.69999998807907, moderate = 0.20000000298023, heavy = 0.10000000149012}, {health_limit = 0.40000000596046, light = 0.20000000298023, moderate = 0.5, heavy = 0.30000001192093}, {light = 0.10000000149012, moderate = 0.30000001192093, heavy = 0.60000002384186}}}
  presets.base = {}
  presets.base.HEALTH_INIT = 2.5
  presets.base.headshot_dmg_mul = 2
  presets.base.SPEED_WALK = {ntl = 120, hos = 180, cbt = 160, pnc = 160}
  presets.base.SPEED_RUN = 370
  presets.base.crouch_move = true
  presets.base.allow_crouch = true
  presets.base.shooting_death = true
  presets.base.suspicious = true
  presets.base.surrender_break_time = {20, 30}
  presets.base.submission_max = {45, 60}
  presets.base.submission_intimidate = 15
  presets.base.speech_prefix = "po"
  presets.base.speech_prefix_count = 1
  presets.base.rescue_hostages = true
  presets.base.use_radio = "dispatch_generic_message"
  presets.base.dodge = nil
  presets.base.challenges = {type = "law"}
  presets.base.experience = {}
  presets.base.experience.cable_tie = "tie_swat"
  presets.base.damage = {}
  presets.base.damage.hurt_severity = presets.hurt_severities.base
  presets.base.damage.death_severity = 0.5
  presets.gang_member_damage = {}
  presets.gang_member_damage.HEALTH_INIT = 75
  presets.gang_member_damage.REGENERATE_TIME = 2
  presets.gang_member_damage.REGENERATE_TIME_AWAY = 0.20000000298023
  presets.gang_member_damage.DOWNED_TIME = l_22_1.player.damage.DOWNED_TIME
  presets.gang_member_damage.TASED_TIME = l_22_1.player.damage.TASED_TIME
  presets.gang_member_damage.BLEED_OUT_HEALTH_INIT = l_22_1.player.damage.BLEED_OUT_HEALTH_INIT
  presets.gang_member_damage.ARRESTED_TIME = l_22_1.player.damage.ARRESTED_TIME
  presets.gang_member_damage.INCAPACITATED_TIME = l_22_1.player.damage.INCAPACITATED_TIME
  presets.gang_member_damage.hurt_severity = {health_reference = "current", zones = {{health_limit = 0.40000000596046, none = 0.30000001192093, light = 0.60000002384186, moderate = 0.10000000149012}, {health_limit = 0.69999998807907, none = 0.10000000149012, light = 0.69999998807907, moderate = 0.20000000298023}, {none = 0.10000000149012, light = 0.5, moderate = 0.30000001192093, heavy = 0.10000000149012}}}
  presets.gang_member_damage.MIN_DAMAGE_INTERVAL = 0
  presets.gang_member_damage.respawn_time_penalty = 0
  presets.gang_member_damage.base_respawn_time_penalty = 5
  presets.weapon = {}
   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

  presets.weapon.normal, {beretta92 = {}, c45 = {}}.mac11, {beretta92 = {}, c45 = {}}.mp5, {beretta92 = {}, c45 = {}}.mossberg, {beretta92 = {}, c45 = {}}.r870, {beretta92 = {}, c45 = {}}.ak47, {beretta92 = {}, c45 = {}}.m4, {beretta92 = {}, c45 = {}}.raging_bull = {beretta92 = {}, c45 = {}}, {}, {}, {}, {}, {}, {}, {}
  presets.weapon.normal.beretta92.aim_delay = {0.10000000149012, 0.10000000149012}
  presets.weapon.normal.beretta92.focus_delay = 10
  presets.weapon.normal.beretta92.focus_dis = 200
  presets.weapon.normal.beretta92.spread = 25
  presets.weapon.normal.beretta92.miss_dis = 30
  presets.weapon.normal.beretta92.RELOAD_SPEED = 1
  presets.weapon.normal.beretta92.melee_speed = 1.5
  presets.weapon.normal.beretta92.melee_dmg = 6
  presets.weapon.normal.beretta92.range = {close = 1000, optimal = 2000, far = 5000}
  presets.weapon.normal.beretta92.FALLOFF = {{r = 500, acc = {0.40000000596046, 0.94999998807907}, dmg_mul = 1, recoil = {0.10000000149012, 0.25}, mode = {1, 0, 0, 0}}, {r = 1000, acc = {0.375, 0.55000001192093}, dmg_mul = 1, recoil = {0.15000000596046, 0.30000001192093}, mode = {1, 0, 0, 0}}, {r = 2000, acc = {0.25, 0.44999998807907}, dmg_mul = 1, recoil = {0.30000001192093, 0.69999998807907}, mode = {1, 0, 0, 0}}, {r = 3000, acc = {0.0099999997764826, 0.34999999403954}, dmg_mul = 1, recoil = {0.40000000596046, 1}, mode = {1, 0, 0, 0}}}
  presets.weapon.normal.c45.aim_delay = {0.10000000149012, 0.10000000149012}
  presets.weapon.normal.c45.focus_delay = 10
  presets.weapon.normal.c45.focus_dis = 200
  presets.weapon.normal.c45.spread = 20
  presets.weapon.normal.c45.miss_dis = 50
  presets.weapon.normal.c45.RELOAD_SPEED = 1
  presets.weapon.normal.c45.melee_speed = 1.5
  presets.weapon.normal.c45.melee_dmg = 6
  presets.weapon.normal.c45.range = {close = 1000, optimal = 2000, far = 5000}
  presets.weapon.normal.c45.FALLOFF = {{r = 500, acc = {0.40000000596046, 0.94999998807907}, dmg_mul = 2, recoil = {0.15000000596046, 0.25}, mode = {1, 0, 0, 0}}, {r = 1000, acc = {0.375, 0.55000001192093}, dmg_mul = 1, recoil = {0.15000000596046, 0.30000001192093}, mode = {1, 0, 0, 0}}, {r = 2000, acc = {0.25, 0.44999998807907}, dmg_mul = 1, recoil = {0.30000001192093, 0.69999998807907}, mode = {1, 0, 0, 0}}, {r = 3000, acc = {0.0099999997764826, 0.34999999403954}, dmg_mul = 1, recoil = {0.40000000596046, 1}, mode = {1, 0, 0, 0}}}
  presets.weapon.normal.m4.aim_delay = {0.10000000149012, 0.10000000149012}
  presets.weapon.normal.m4.focus_delay = 10
  presets.weapon.normal.m4.focus_dis = 200
  presets.weapon.normal.m4.spread = 20
  presets.weapon.normal.m4.miss_dis = 40
  presets.weapon.normal.m4.RELOAD_SPEED = 1
  presets.weapon.normal.m4.melee_speed = 0.89999997615814
  presets.weapon.normal.m4.melee_dmg = 6
  presets.weapon.normal.m4.range = {close = 1000, optimal = 2000, far = 5000}
  presets.weapon.normal.m4.FALLOFF = {{r = 500, acc = {0.40000000596046, 0.89999997615814}, dmg_mul = 2, recoil = {0.44999998807907, 0.80000001192093}, mode = {0, 3, 3, 1}}, {r = 1000, acc = {0.20000000298023, 0.80000001192093}, dmg_mul = 1, recoil = {0.34999999403954, 0.75}, mode = {1, 2, 2, 0}}, {r = 2000, acc = {0.20000000298023, 0.5}, dmg_mul = 1, recoil = {0.40000000596046, 1.2000000476837}, mode = {3, 2, 2, 0}}, {r = 3000, acc = {0.0099999997764826, 0.34999999403954}, dmg_mul = 1, recoil = {1.5, 3}, mode = {3, 1, 1, 0}}}
  presets.weapon.normal.r870.aim_delay = {0.10000000149012, 0.10000000149012}
  presets.weapon.normal.r870.focus_delay = 10
  presets.weapon.normal.r870.focus_dis = 200
  presets.weapon.normal.r870.spread = 15
  presets.weapon.normal.r870.miss_dis = 20
  presets.weapon.normal.r870.RELOAD_SPEED = 1
  presets.weapon.normal.r870.melee_speed = 0.89999997615814
  presets.weapon.normal.r870.melee_dmg = 6
  presets.weapon.normal.r870.range = {close = 1000, optimal = 2000, far = 5000}
  presets.weapon.normal.r870.FALLOFF = {{r = 500, acc = {0.40000000596046, 0.94999998807907}, dmg_mul = 2, recoil = {1.5, 2}, mode = {1, 0, 0, 0}}, {r = 1000, acc = {0.20000000298023, 0.75}, dmg_mul = 0.5, recoil = {1.5, 2}, mode = {1, 0, 0, 0}}, {r = 2000, acc = {0.0099999997764826, 0.25}, dmg_mul = 0.5, recoil = {1.5, 2}, mode = {1, 0, 0, 0}}, {r = 3000, acc = {0.050000000745058, 0.34999999403954}, dmg_mul = 0.20000000298023, recoil = {1.5, 2}, mode = {1, 0, 0, 0}}}
  presets.weapon.normal.mp5.aim_delay = {0.10000000149012, 0.10000000149012}
  presets.weapon.normal.mp5.focus_delay = 10
  presets.weapon.normal.mp5.focus_dis = 200
  presets.weapon.normal.mp5.spread = 15
  presets.weapon.normal.mp5.miss_dis = 20
  presets.weapon.normal.mp5.RELOAD_SPEED = 1
  presets.weapon.normal.mp5.melee_speed = 1
  presets.weapon.normal.mp5.melee_dmg = 6
  presets.weapon.normal.mp5.range = {close = 1000, optimal = 2000, far = 5000}
  presets.weapon.normal.mp5.FALLOFF = {{r = 500, acc = {0.40000000596046, 0.94999998807907}, dmg_mul = 2, recoil = {0.10000000149012, 0.30000001192093}, mode = {0, 3, 3, 1}}, {r = 1000, acc = {0.20000000298023, 0.80000001192093}, dmg_mul = 1, recoil = {0.30000001192093, 0.40000000596046}, mode = {0, 3, 3, 0}}, {r = 2000, acc = {0.10000000149012, 0.44999998807907}, dmg_mul = 1, recoil = {0.30000001192093, 0.40000000596046}, mode = {0, 3, 3, 0}}, {r = 3000, acc = {0.10000000149012, 0.34999999403954}, dmg_mul = 1, recoil = {0.5, 0.60000002384186}, mode = {1, 3, 2, 0}}}
  presets.weapon.normal.mac11.aim_delay = {0.10000000149012, 0.10000000149012}
  presets.weapon.normal.mac11.focus_delay = 10
  presets.weapon.normal.mac11.focus_dis = 200
  presets.weapon.normal.mac11.spread = 20
  presets.weapon.normal.mac11.miss_dis = 25
  presets.weapon.normal.mac11.RELOAD_SPEED = 1
  presets.weapon.normal.mac11.melee_speed = 1.2000000476837
  presets.weapon.normal.mac11.melee_dmg = 6
  presets.weapon.normal.mac11.range = {close = 1000, optimal = 2000, far = 5000}
  presets.weapon.normal.mac11.FALLOFF = {{r = 500, acc = {0.10000000149012, 0.89999997615814}, dmg_mul = 2, recoil = {0.5, 0.64999997615814}, mode = {0, 1, 3, 1}}, {r = 1000, acc = {0.20000000298023, 0.55000001192093}, dmg_mul = 1, recoil = {0.55000001192093, 0.85000002384186}, mode = {2, 1, 3, 0}}, {r = 2000, acc = {0.050000000745058, 0.40000000596046}, dmg_mul = 1, recoil = {0.64999997615814, 1}, mode = {2, 1, 3, 0}}, {r = 3000, acc = {0, 0.30000001192093}, dmg_mul = 1, recoil = {0.64999997615814, 1}, mode = {2, 1, 3, 0}}}
  presets.weapon.normal.raging_bull = presets.weapon.normal.c45
  presets.weapon.normal.ak47 = presets.weapon.normal.m4
  presets.weapon.normal.mossberg = presets.weapon.normal.r870
   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

  presets.weapon.good, {beretta92 = {}, c45 = {}}.mac11, {beretta92 = {}, c45 = {}}.mp5, {beretta92 = {}, c45 = {}}.mossberg, {beretta92 = {}, c45 = {}}.r870, {beretta92 = {}, c45 = {}}.ak47, {beretta92 = {}, c45 = {}}.m4, {beretta92 = {}, c45 = {}}.raging_bull = {beretta92 = {}, c45 = {}}, {}, {}, {}, {}, {}, {}, {}
  presets.weapon.good.beretta92.aim_delay = {0, 0.20000000298023}
  presets.weapon.good.beretta92.focus_delay = 1
  presets.weapon.good.beretta92.focus_dis = 200
  presets.weapon.good.beretta92.spread = 15
  presets.weapon.good.beretta92.miss_dis = 20
  presets.weapon.good.beretta92.RELOAD_SPEED = 1.5
  presets.weapon.good.beretta92.melee_speed = presets.weapon.normal.beretta92.melee_speed
  presets.weapon.good.beretta92.melee_dmg = presets.weapon.normal.beretta92.melee_dmg
  presets.weapon.good.beretta92.range = presets.weapon.normal.beretta92.range
  presets.weapon.good.beretta92.FALLOFF = {{r = 0, acc = {0.15000000596046, 0.60000002384186}, dmg_mul = 4, recoil = {0.25, 0.34999999403954}, mode = {1, 3, 1, 0}}, {r = 700, acc = {0.090000003576279, 0.25}, dmg_mul = 1, recoil = {0.25, 0.34999999403954}, mode = {1, 3, 1, 0}}, {r = 3000, acc = {0.050000000745058, 0.15000000596046}, dmg_mul = 1, recoil = {0.25, 0.34999999403954}, mode = {1, 3, 1, 0}}, {r = 10000, acc = {0, 0.10000000149012}, dmg_mul = 1, recoil = {1.6000000238419, 3.5}, mode = {1, 0, 0, 0}}}
  presets.weapon.good.c45.aim_delay = {0, 0.20000000298023}
  presets.weapon.good.c45.focus_delay = 1
  presets.weapon.good.c45.focus_dis = 2000
  presets.weapon.good.c45.spread = 15
  presets.weapon.good.c45.miss_dis = 15
  presets.weapon.good.c45.RELOAD_SPEED = 1.5
  presets.weapon.good.c45.melee_speed = presets.weapon.normal.c45.melee_speed
  presets.weapon.good.c45.melee_dmg = presets.weapon.normal.c45.melee_dmg
  presets.weapon.good.c45.range = presets.weapon.normal.c45.range
  presets.weapon.good.c45.FALLOFF = {{r = 0, acc = {0.10000000149012, 0.60000002384186}, dmg_mul = 4, recoil = {0.25, 0.34999999403954}, mode = {1, 3, 1, 0}}, {r = 700, acc = {0.10000000149012, 0.60000002384186}, dmg_mul = 1, recoil = {0.25, 0.34999999403954}, mode = {1, 3, 1, 0}}, {r = 3000, acc = {0, 0.10000000149012}, dmg_mul = 1, recoil = {0.25, 0.34999999403954}, mode = {1, 3, 1, 0}}, {r = 10000, acc = {0, 0.10000000149012}, dmg_mul = 1, recoil = {1.6000000238419, 3.5}, mode = {1, 0, 0, 0}}}
  presets.weapon.good.m4.aim_delay = {0.10000000149012, 0.10000000149012}
  presets.weapon.good.m4.focus_delay = 10
  presets.weapon.good.m4.focus_dis = 200
  presets.weapon.good.m4.spread = 20
  presets.weapon.good.m4.miss_dis = 40
  presets.weapon.good.m4.RELOAD_SPEED = 1
  presets.weapon.good.m4.melee_speed = 0.89999997615814
  presets.weapon.good.m4.melee_dmg = 6
  presets.weapon.good.m4.range = {close = 1000, optimal = 2000, far = 5000}
  presets.weapon.good.m4.FALLOFF = {{r = 500, acc = {0.40000000596046, 0.89999997615814}, dmg_mul = 2, recoil = {0.44999998807907, 0.80000001192093}, mode = {0, 3, 3, 1}}, {r = 1000, acc = {0.20000000298023, 0.80000001192093}, dmg_mul = 1, recoil = {0.34999999403954, 0.75}, mode = {1, 2, 2, 0}}, {r = 2000, acc = {0.20000000298023, 0.5}, dmg_mul = 1, recoil = {0.40000000596046, 1.2000000476837}, mode = {3, 2, 2, 0}}, {r = 3000, acc = {0.0099999997764826, 0.34999999403954}, dmg_mul = 1, recoil = {1.5, 3}, mode = {3, 1, 1, 0}}}
  presets.weapon.good.r870.aim_delay = {0.10000000149012, 0.10000000149012}
  presets.weapon.good.r870.focus_delay = 10
  presets.weapon.good.r870.focus_dis = 200
  presets.weapon.good.r870.spread = 15
  presets.weapon.good.r870.miss_dis = 20
  presets.weapon.good.r870.RELOAD_SPEED = 1
  presets.weapon.good.r870.melee_speed = 0.89999997615814
  presets.weapon.good.r870.melee_dmg = 6
  presets.weapon.good.r870.range = {close = 1000, optimal = 2000, far = 5000}
  presets.weapon.good.r870.FALLOFF = {{r = 500, acc = {0.40000000596046, 0.94999998807907}, dmg_mul = 2, recoil = {1.5, 2}, mode = {1, 0, 0, 0}}, {r = 1000, acc = {0.20000000298023, 0.75}, dmg_mul = 0.5, recoil = {1.5, 2}, mode = {1, 0, 0, 0}}, {r = 2000, acc = {0.0099999997764826, 0.25}, dmg_mul = 0.5, recoil = {1.5, 2}, mode = {1, 0, 0, 0}}, {r = 3000, acc = {0.050000000745058, 0.34999999403954}, dmg_mul = 0.20000000298023, recoil = {1.5, 2}, mode = {1, 0, 0, 0}}}
  presets.weapon.good.mp5.aim_delay = {0, 0.20000000298023}
  presets.weapon.good.mp5.focus_delay = 1
  presets.weapon.good.mp5.focus_dis = 2000
  presets.weapon.good.mp5.spread = 15
  presets.weapon.good.mp5.miss_dis = 10
  presets.weapon.good.mp5.RELOAD_SPEED = 1.5
  presets.weapon.good.mp5.melee_speed = presets.weapon.normal.mp5.melee_speed
  presets.weapon.good.mp5.melee_dmg = presets.weapon.normal.mp5.melee_dmg
  presets.weapon.good.mp5.range = presets.weapon.normal.mp5.range
  presets.weapon.good.mp5.FALLOFF = {{r = 0, acc = {0.10000000149012, 0.60000002384186}, dmg_mul = 4, recoil = {0.34999999403954, 0.55000001192093}, mode = {0.20000000298023, 2, 4, 10}}, {r = 700, acc = {0.10000000149012, 0.60000002384186}, dmg_mul = 1, recoil = {0.34999999403954, 0.55000001192093}, mode = {0.20000000298023, 2, 4, 10}}, {r = 3000, acc = {0, 0.20000000298023}, dmg_mul = 1, recoil = {0.34999999403954, 0.55000001192093}, mode = {0.20000000298023, 2, 4, 10}}, {r = 10000, acc = {0, 0.20000000298023}, dmg_mul = 1, recoil = {1.7999999523163, 3.5}, mode = {3, 1, 0, 0}}}
  presets.weapon.good.mac11.aim_delay = {0, 0.20000000298023}
  presets.weapon.good.mac11.focus_delay = 1
  presets.weapon.good.mac11.focus_dis = 2000
  presets.weapon.good.mac11.spread = 15
  presets.weapon.good.mac11.miss_dis = 10
  presets.weapon.good.mac11.RELOAD_SPEED = 1.5
  presets.weapon.good.mac11.melee_speed = presets.weapon.normal.mac11.melee_speed
  presets.weapon.good.mac11.melee_dmg = presets.weapon.normal.mac11.melee_dmg
  presets.weapon.good.mac11.range = presets.weapon.normal.mac11.range
  presets.weapon.good.mac11.FALLOFF = {{r = 0, acc = {0.10000000149012, 0.60000002384186}, dmg_mul = 4, recoil = {0.34999999403954, 0.55000001192093}, mode = {0.20000000298023, 2, 4, 10}}, {r = 700, acc = {0.050000000745058, 0.5}, dmg_mul = 1, recoil = {0.34999999403954, 0.55000001192093}, mode = {0.20000000298023, 2, 4, 10}}, {r = 3000, acc = {0, 0.40000000596046}, dmg_mul = 1, recoil = {0.34999999403954, 0.55000001192093}, mode = {0.20000000298023, 2, 4, 10}}, {r = 10000, acc = {0, 0.20000000298023}, dmg_mul = 1, recoil = {2, 4}, mode = {4, 1, 0, 0}}}
  presets.weapon.good.raging_bull = presets.weapon.good.c45
  presets.weapon.good.ak47 = presets.weapon.good.m4
  presets.weapon.good.mossberg = presets.weapon.good.r870
   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

  presets.weapon.expert, {beretta92 = {}, c45 = {}}.mac11, {beretta92 = {}, c45 = {}}.mp5, {beretta92 = {}, c45 = {}}.mossberg, {beretta92 = {}, c45 = {}}.r870, {beretta92 = {}, c45 = {}}.ak47, {beretta92 = {}, c45 = {}}.m4, {beretta92 = {}, c45 = {}}.raging_bull = {beretta92 = {}, c45 = {}}, {}, {}, {}, {}, {}, {}, {}
  presets.weapon.expert.beretta92.aim_delay = {0, 0.20000000298023}
  presets.weapon.expert.beretta92.focus_delay = 1
  presets.weapon.expert.beretta92.focus_dis = 2000
  presets.weapon.expert.beretta92.spread = 15
  presets.weapon.expert.beretta92.miss_dis = 20
  presets.weapon.expert.beretta92.RELOAD_SPEED = 1.5
  presets.weapon.expert.beretta92.melee_speed = presets.weapon.normal.beretta92.melee_speed
  presets.weapon.expert.beretta92.melee_dmg = presets.weapon.normal.beretta92.melee_dmg
  presets.weapon.expert.beretta92.range = presets.weapon.normal.beretta92.range
  presets.weapon.expert.beretta92.FALLOFF = {{r = 0, acc = {0.10000000149012, 0.89999997615814}, dmg_mul = 4, recoil = {0.25, 0.34999999403954}, mode = {1, 3, 1, 0}}, {r = 700, acc = {0.10000000149012, 0.60000002384186}, dmg_mul = 1, recoil = {0.25, 0.34999999403954}, mode = {1, 3, 1, 0}}, {r = 3000, acc = {0, 0.40000000596046}, dmg_mul = 1, recoil = {0.25, 0.34999999403954}, mode = {1, 3, 1, 0}}, {r = 10000, acc = {0, 0.30000001192093}, dmg_mul = 1, recoil = {1.5, 3}, mode = {1, 0, 0, 0}}}
  presets.weapon.expert.c45.aim_delay = {0, 0.20000000298023}
  presets.weapon.expert.c45.focus_delay = 1
  presets.weapon.expert.c45.focus_dis = 2000
  presets.weapon.expert.c45.spread = 15
  presets.weapon.expert.c45.miss_dis = 20
  presets.weapon.expert.c45.RELOAD_SPEED = 1.5
  presets.weapon.expert.c45.melee_speed = presets.weapon.normal.c45.melee_speed
  presets.weapon.expert.c45.melee_dmg = presets.weapon.normal.c45.melee_dmg
  presets.weapon.expert.c45.range = presets.weapon.normal.c45.range
  presets.weapon.expert.c45.FALLOFF = {{r = 0, acc = {0.10000000149012, 0.89999997615814}, dmg_mul = 4, recoil = {0.25, 0.34999999403954}, mode = {1, 3, 1, 0}}, {r = 700, acc = {0.10000000149012, 0.89999997615814}, dmg_mul = 1, recoil = {0.25, 0.34999999403954}, mode = {1, 3, 1, 0}}, {r = 3000, acc = {0, 0.30000001192093}, dmg_mul = 1, recoil = {0.25, 0.34999999403954}, mode = {1, 3, 1, 0}}, {r = 10000, acc = {0, 0.30000001192093}, dmg_mul = 1, recoil = {1.5, 3}, mode = {1, 0, 0, 0}}}
  presets.weapon.expert.m4.aim_delay = {0, 0.20000000298023}
  presets.weapon.expert.m4.focus_delay = 1
  presets.weapon.expert.m4.focus_dis = 2000
  presets.weapon.expert.m4.spread = 15
  presets.weapon.expert.m4.miss_dis = 10
  presets.weapon.expert.m4.RELOAD_SPEED = 1
  presets.weapon.expert.m4.melee_speed = presets.weapon.normal.m4.melee_speed
  presets.weapon.expert.m4.melee_dmg = presets.weapon.normal.m4.melee_dmg
  presets.weapon.expert.m4.range = presets.weapon.normal.m4.range
  presets.weapon.expert.m4.FALLOFF = {{r = 0, acc = {0.10000000149012, 0.89999997615814}, dmg_mul = 4, recoil = {0.25, 0.44999998807907}, mode = {0.20000000298023, 2, 4, 10}}, {r = 700, acc = {0.10000000149012, 0.69999998807907}, dmg_mul = 1, recoil = {0.25, 0.44999998807907}, mode = {0.20000000298023, 2, 4, 10}}, {r = 3000, acc = {0, 0.60000002384186}, dmg_mul = 1, recoil = {0.25, 0.44999998807907}, mode = {0.20000000298023, 2, 4, 10}}, {r = 10000, acc = {0, 0.5}, dmg_mul = 1, recoil = {1.1000000238419, 2.2000000476837}, mode = {2, 1, 0, 0}}}
  presets.weapon.expert.r870.aim_delay = {0, 0.019999999552965}
  presets.weapon.expert.r870.focus_delay = 1
  presets.weapon.expert.r870.focus_dis = 2000
  presets.weapon.expert.r870.spread = 15
  presets.weapon.expert.r870.miss_dis = 10
  presets.weapon.expert.r870.RELOAD_SPEED = 2
  presets.weapon.expert.r870.melee_speed = presets.weapon.normal.r870.melee_speed
  presets.weapon.expert.r870.melee_dmg = presets.weapon.normal.r870.melee_dmg
  presets.weapon.expert.r870.range = presets.weapon.normal.r870.range
  presets.weapon.expert.r870.FALLOFF = {{r = 0, acc = {0.40000000596046, 0.89999997615814}, dmg_mul = 4, recoil = {2, 2}, mode = {1, 1, 0, 0}}, {r = 700, acc = {0.40000000596046, 0.89999997615814}, dmg_mul = 1, recoil = {2, 2}, mode = {1, 1, 0, 0}}, {r = 1000, acc = {0.40000000596046, 0.89999997615814}, dmg_mul = 1, recoil = {2, 2}, mode = {1, 1, 0, 0}}, {r = 2000, acc = {0, 0.89999997615814}, dmg_mul = 0.5, recoil = {2, 3}, mode = {1, 0, 0, 0}}, {r = 10000, acc = {0, 0.89999997615814}, dmg_mul = 0.30000001192093, recoil = {2, 4}, mode = {1, 0, 0, 0}}}
  presets.weapon.expert.mp5.aim_delay = {0, 0.20000000298023}
  presets.weapon.expert.mp5.focus_delay = 1
  presets.weapon.expert.mp5.focus_dis = 2000
  presets.weapon.expert.mp5.spread = 15
  presets.weapon.expert.mp5.miss_dis = 10
  presets.weapon.expert.mp5.RELOAD_SPEED = 1.5
  presets.weapon.expert.mp5.melee_speed = presets.weapon.normal.mp5.melee_speed
  presets.weapon.expert.mp5.melee_dmg = presets.weapon.normal.mp5.melee_dmg
  presets.weapon.expert.mp5.range = presets.weapon.normal.mp5.range
  presets.weapon.expert.mp5.FALLOFF = {{r = 0, acc = {0.10000000149012, 0.89999997615814}, dmg_mul = 4, recoil = {0.34999999403954, 0.55000001192093}, mode = {0.20000000298023, 2, 4, 10}}, {r = 700, acc = {0.10000000149012, 0.60000002384186}, dmg_mul = 1, recoil = {0.34999999403954, 0.55000001192093}, mode = {0.20000000298023, 2, 4, 10}}, {r = 3000, acc = {0, 0.5}, dmg_mul = 1, recoil = {0.34999999403954, 0.55000001192093}, mode = {0.20000000298023, 2, 4, 10}}, {r = 10000, acc = {0, 0.30000001192093}, dmg_mul = 1, recoil = {1.5, 3.0999999046326}, mode = {3, 1, 0, 0}}}
  presets.weapon.expert.mac11.aim_delay = {0, 0.20000000298023}
  presets.weapon.expert.mac11.focus_delay = 1
  presets.weapon.expert.mac11.focus_dis = 2000
  presets.weapon.expert.mac11.spread = 15
  presets.weapon.expert.mac11.miss_dis = 10
  presets.weapon.expert.mac11.RELOAD_SPEED = 1.5
  presets.weapon.expert.mac11.melee_speed = presets.weapon.normal.mac11.melee_speed
  presets.weapon.expert.mac11.melee_dmg = presets.weapon.normal.mac11.melee_dmg
  presets.weapon.expert.mac11.range = presets.weapon.normal.mac11.range
  presets.weapon.expert.mac11.FALLOFF = {{r = 0, acc = {0.10000000149012, 0.89999997615814}, dmg_mul = 4, recoil = {0.34999999403954, 0.55000001192093}, mode = {0.20000000298023, 2, 4, 10}}, {r = 700, acc = {0.10000000149012, 0.60000002384186}, dmg_mul = 1, recoil = {0.34999999403954, 0.55000001192093}, mode = {0.20000000298023, 2, 4, 10}}, {r = 3000, acc = {0, 0.5}, dmg_mul = 1, recoil = {0.34999999403954, 0.55000001192093}, mode = {0.20000000298023, 2, 4, 10}}, {r = 10000, acc = {0, 0.30000001192093}, dmg_mul = 1, recoil = {1.7999999523163, 3.5}, mode = {4, 1, 0, 0}}}
  presets.weapon.expert.raging_bull = presets.weapon.expert.c45
  presets.weapon.expert.ak47 = presets.weapon.expert.m4
  presets.weapon.expert.mossberg = presets.weapon.expert.r870
  presets.weapon.sniper = {m4 = {}}
  presets.weapon.sniper.m4.aim_delay = {0, 0.20000000298023}
  presets.weapon.sniper.m4.focus_delay = 4
  presets.weapon.sniper.m4.focus_dis = 200
  presets.weapon.sniper.m4.spread = 30
  presets.weapon.sniper.m4.miss_dis = 250
  presets.weapon.sniper.m4.RELOAD_SPEED = 1.25
  presets.weapon.sniper.m4.melee_speed = presets.weapon.normal.m4.melee_speed
  presets.weapon.sniper.m4.melee_dmg = presets.weapon.normal.m4.melee_dmg
  presets.weapon.sniper.m4.range = {close = 15000, optimal = 15000, far = 15000}
  presets.weapon.sniper.m4.use_laser = true
  presets.weapon.sniper.m4.FALLOFF = {{r = 700, acc = {0.40000000596046, 1}, dmg_mul = 1, recoil = {0.5, 0.80000001192093}, mode = {1, 0, 0, 0}}, {r = 2500, acc = {0, 0.60000002384186}, dmg_mul = 1, recoil = {1, 3.5}, mode = {1, 0, 0, 0}}, {r = 10000, acc = {0, 0.30000001192093}, dmg_mul = 1, recoil = {3, 6}, mode = {1, 0, 0, 0}}}
   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

  presets.weapon.gang_member, {beretta92 = {}, c45 = {}}.mac11, {beretta92 = {}, c45 = {}}.mp5, {beretta92 = {}, c45 = {}}.mossberg, {beretta92 = {}, c45 = {}}.r870, {beretta92 = {}, c45 = {}}.ak47, {beretta92 = {}, c45 = {}}.m4, {beretta92 = {}, c45 = {}}.raging_bull = {beretta92 = {}, c45 = {}}, {}, {}, {}, {}, {}, {}, {}
  presets.weapon.gang_member.beretta92.aim_delay = {0, 1}
  presets.weapon.gang_member.beretta92.focus_delay = 1
  presets.weapon.gang_member.beretta92.focus_dis = 2000
  presets.weapon.gang_member.beretta92.spread = 25
  presets.weapon.gang_member.beretta92.miss_dis = 20
  presets.weapon.gang_member.beretta92.RELOAD_SPEED = 1.5
  presets.weapon.gang_member.beretta92.melee_speed = 3
  presets.weapon.gang_member.beretta92.melee_dmg = 3
  presets.weapon.gang_member.beretta92.range = presets.weapon.normal.beretta92.range
  presets.weapon.gang_member.beretta92.FALLOFF = {{r = 300, acc = {0.69999998807907, 0.89999997615814}, dmg_mul = 1.5, recoil = {0.25, 0.44999998807907}, mode = {1, 0, 0, 0}}, {r = 2000, acc = {0.10000000149012, 0.60000002384186}, dmg_mul = 1, recoil = {0.25, 2}, mode = {1, 0, 0, 0}}, {r = 10000, acc = {0, 0.15000000596046}, dmg_mul = 1, recoil = {2, 3}, mode = {1, 0, 0, 0}}}
  presets.weapon.gang_member.m4.aim_delay = {0, 1}
  presets.weapon.gang_member.m4.focus_delay = 1
  presets.weapon.gang_member.m4.focus_dis = 3000
  presets.weapon.gang_member.m4.spread = 25
  presets.weapon.gang_member.m4.miss_dis = 10
  presets.weapon.gang_member.m4.RELOAD_SPEED = 1
  presets.weapon.gang_member.m4.melee_speed = 2
  presets.weapon.gang_member.m4.melee_dmg = 3
  presets.weapon.gang_member.m4.range = {close = 1500, optimal = 2500, far = 6000}
  presets.weapon.gang_member.m4.FALLOFF = {{r = 300, acc = {0.69999998807907, 0.89999997615814}, dmg_mul = 0.5, recoil = {0.25, 0.44999998807907}, mode = {0.10000000149012, 0.30000001192093, 4, 7}}, {r = 2000, acc = {0.10000000149012, 0.60000002384186}, dmg_mul = 0.5, recoil = {0.25, 2}, mode = {2, 2, 5, 8}}, {r = 10000, acc = {0, 0.15000000596046}, dmg_mul = 0.5, recoil = {2, 3}, mode = {2, 1, 1, 0.0099999997764826}}}
  presets.weapon.gang_member.r870.aim_delay = {0, 0.019999999552965}
  presets.weapon.gang_member.r870.focus_delay = 1
  presets.weapon.gang_member.r870.focus_dis = 2000
  presets.weapon.gang_member.r870.spread = 15
  presets.weapon.gang_member.r870.miss_dis = 10
  presets.weapon.gang_member.r870.RELOAD_SPEED = 2
  presets.weapon.gang_member.r870.melee_speed = 2
  presets.weapon.gang_member.r870.melee_dmg = 3
  presets.weapon.gang_member.r870.range = presets.weapon.normal.r870.range
  presets.weapon.gang_member.r870.FALLOFF = {{r = 300, acc = {0.69999998807907, 0.89999997615814}, dmg_mul = 1.5, recoil = {2, 2}, mode = {1, 0, 0, 0}}, {r = 1000, acc = {0.10000000149012, 0.60000002384186}, dmg_mul = 1, recoil = {2, 2}, mode = {1, 0, 0, 0}}, {r = 4000, acc = {0, 0.15000000596046}, dmg_mul = 0.10000000149012, recoil = {2, 4}, mode = {1, 0, 0, 0}}}
  presets.weapon.gang_member.mp5 = presets.weapon.gang_member.m4
  presets.weapon.gang_member.c45 = presets.weapon.gang_member.beretta92
  presets.weapon.gang_member.raging_bull = presets.weapon.gang_member.beretta92
  presets.weapon.gang_member.ak47 = presets.weapon.gang_member.m4
  presets.weapon.gang_member.mossberg = presets.weapon.gang_member.r870
  presets.weapon.gang_member.mac11 = presets.weapon.gang_member.mp5
  presets.detection = {}
  presets.detection.normal = {idle = {}, combat = {}, recon = {}, guard = {}, ntl = {}}
  presets.detection.normal.idle.dis_max = 10000
  presets.detection.normal.idle.angle_max = 120
  presets.detection.normal.idle.delay = {0, 0}
  presets.detection.normal.idle.use_uncover_range = true
  presets.detection.normal.combat.dis_max = 10000
  presets.detection.normal.combat.angle_max = 120
  presets.detection.normal.combat.delay = {0, 0}
  presets.detection.normal.combat.use_uncover_range = true
  presets.detection.normal.recon.dis_max = 10000
  presets.detection.normal.recon.angle_max = 120
  presets.detection.normal.recon.delay = {0, 0}
  presets.detection.normal.recon.use_uncover_range = true
  presets.detection.normal.guard.dis_max = 10000
  presets.detection.normal.guard.angle_max = 120
  presets.detection.normal.guard.delay = {0, 0}
  presets.detection.normal.ntl.dis_max = 4000
  presets.detection.normal.ntl.angle_max = 60
  presets.detection.normal.ntl.delay = {0.20000000298023, 2}
  presets.detection.guard = {idle = {}, combat = {}, recon = {}, guard = {}, ntl = {}}
  presets.detection.guard.idle.dis_max = 10000
  presets.detection.guard.idle.angle_max = 120
  presets.detection.guard.idle.delay = {0, 0}
  presets.detection.guard.idle.use_uncover_range = true
  presets.detection.guard.combat.dis_max = 10000
  presets.detection.guard.combat.angle_max = 120
  presets.detection.guard.combat.delay = {0, 0}
  presets.detection.guard.combat.use_uncover_range = true
  presets.detection.guard.recon.dis_max = 10000
  presets.detection.guard.recon.angle_max = 120
  presets.detection.guard.recon.delay = {0, 0}
  presets.detection.guard.recon.use_uncover_range = true
  presets.detection.guard.guard.dis_max = 10000
  presets.detection.guard.guard.angle_max = 120
  presets.detection.guard.guard.delay = {0, 0}
  presets.detection.guard.ntl = presets.detection.normal.ntl
  presets.detection.sniper = {idle = {}, combat = {}, recon = {}, guard = {}, ntl = {}}
  presets.detection.sniper.idle.dis_max = 10000
  presets.detection.sniper.idle.angle_max = 180
  presets.detection.sniper.idle.delay = {0.5, 1}
  presets.detection.sniper.idle.use_uncover_range = true
  presets.detection.sniper.combat.dis_max = 10000
  presets.detection.sniper.combat.angle_max = 120
  presets.detection.sniper.combat.delay = {0.5, 1}
  presets.detection.sniper.combat.use_uncover_range = true
  presets.detection.sniper.recon.dis_max = 10000
  presets.detection.sniper.recon.angle_max = 120
  presets.detection.sniper.recon.delay = {0.5, 1}
  presets.detection.sniper.recon.use_uncover_range = true
  presets.detection.sniper.guard.dis_max = 10000
  presets.detection.sniper.guard.angle_max = 150
  presets.detection.sniper.guard.delay = {0.30000001192093, 1}
  presets.detection.sniper.ntl = presets.detection.normal.ntl
  presets.detection.gang_member = {idle = {}, combat = {}, recon = {}, guard = {}, ntl = {}}
  presets.detection.gang_member.idle.dis_max = 10000
  presets.detection.gang_member.idle.angle_max = 120
  presets.detection.gang_member.idle.delay = {0, 0}
  presets.detection.gang_member.idle.use_uncover_range = true
  presets.detection.gang_member.combat.dis_max = 10000
  presets.detection.gang_member.combat.angle_max = 120
  presets.detection.gang_member.combat.delay = {0, 0}
  presets.detection.gang_member.combat.use_uncover_range = true
  presets.detection.gang_member.recon.dis_max = 10000
  presets.detection.gang_member.recon.angle_max = 120
  presets.detection.gang_member.recon.delay = {0, 0}
  presets.detection.gang_member.recon.use_uncover_range = true
  presets.detection.gang_member.guard.dis_max = 10000
  presets.detection.gang_member.guard.angle_max = 120
  presets.detection.gang_member.guard.delay = {0, 0}
  presets.detection.gang_member.ntl = presets.detection.normal.ntl
  l_22_0:_process_weapon_usage_table(presets.weapon.normal)
  l_22_0:_process_weapon_usage_table(presets.weapon.good)
  l_22_0:_process_weapon_usage_table(presets.weapon.expert)
  l_22_0:_process_weapon_usage_table(presets.weapon.gang_member)
  presets.detection.patrol = presets.detection.guard
  presets.detection.civilian = {cbt = {}, ntl = {}}
  presets.detection.civilian.cbt.dis_max = 700
  presets.detection.civilian.cbt.angle_max = 120
  presets.detection.civilian.cbt.delay = {0, 0}
  presets.detection.civilian.cbt.use_uncover_range = true
  presets.detection.civilian.ntl.dis_max = 2000
  presets.detection.civilian.ntl.angle_max = 60
  presets.detection.civilian.ntl.delay = {0.20000000298023, 3}
  presets.dodge = {poor = {speed = 0.89999997615814, occasions = {hit = {chance = 0.89999997615814, check_timeout = {0, 0}, variations = {side_step = {chance = 1, timeout = {2, 3}}}}, scared = {chance = 0.5, check_timeout = {1, 2}, variations = {side_step = {chance = 1, timeout = {2, 3}}}}}}, average = {speed = 1, occasions = {hit = {chance = 0.34999999403954, check_timeout = {0, 0}, variations = {side_step = {chance = 1, timeout = {2, 3}}}}, scared = {chance = 0.40000000596046, check_timeout = {4, 7}, variations = {dive = {chance = 1, timeout = {5, 8}}}}}}, heavy = {speed = 1, occasions = {hit = {chance = 0.75, check_timeout = {0, 0}, variations = {side_step = {chance = 9, timeout = {0, 7}}, roll = {chance = 1, timeout = {8, 10}}}}, preemptive = {chance = 0.10000000149012, check_timeout = {1, 7}, variations = {side_step = {chance = 1, timeout = {1, 7}}}}, scared = {chance = 0.80000001192093, check_timeout = {1, 2}, variations = {side_step = {chance = 5, timeout = {1, 2}}, roll = {chance = 1, timeout = {8, 10}}, dive = {chance = 2, timeout = {8, 10}}}}}}, athletic = {speed = 1.2999999523163, occasions = {hit = {chance = 0.89999997615814, check_timeout = {0, 0}, variations = {side_step = {chance = 5, timeout = {1, 3}}, roll = {chance = 1, timeout = {3, 4}}}}, preemptive = {chance = 0.25, check_timeout = {2, 3}, variations = {side_step = {chance = 3, timeout = {1, 2}}, roll = {chance = 1, timeout = {3, 4}}}}, scared = {chance = 0.40000000596046, check_timeout = {1, 2}, variations = {side_step = {chance = 5, timeout = {1, 2}}, roll = {chance = 3, timeout = {3, 5}}, dive = {chance = 1, timeout = {3, 5}}}}}}, ninja = {speed = 1.5, occasions = {hit = {chance = 0.89999997615814, check_timeout = {0, 3}, variations = {side_step = {chance = 2, timeout = {1, 2}}, roll = {chance = 1, timeout = {2, 3}}}}, preemptive = {chance = 0.5, check_timeout = {0, 3}, variations = {side_step = {chance = 3, timeout = {1, 2}}, roll = {chance = 1, timeout = {1.2000000476837, 2}}}}, scared = {chance = 0.89999997615814, check_timeout = {0, 3}, variations = {side_step = {chance = 5, timeout = {1, 2}}, roll = {chance = 3, timeout = {1.2000000476837, 2}}, dive = {chance = 1, timeout = {1.2000000476837, 2}}}}}}}
  for preset_name,preset_data in pairs(presets.dodge) do
    for reason_name,reason_data in pairs(preset_data.occasions) do
      local total_w = 0
      for variation_name,variation_data in pairs(reason_data.variations) do
        total_w = total_w + variation_data.chance
      end
      if total_w > 0 then
        for variation_name,variation_data in pairs(reason_data.variations) do
          variation_data.chance = variation_data.chance / (total_w)
        end
      end
    end
  end
  presets.move_speed = {civ_fast = {stand = {walk = {ntl = {fwd = 150, strafe = 120, bwd = 100}, hos = {fwd = 210, strafe = 190, bwd = 160}, cbt = {fwd = 210, strafe = 175, bwd = 160}}, run = {hos = {fwd = 500, strafe = 192, bwd = 230}, cbt = {fwd = 500, strafe = 250, bwd = 230}}}, crouch = {walk = {hos = {fwd = 174, strafe = 160, bwd = 163}, cbt = {fwd = 174, strafe = 160, bwd = 163}}, run = {hos = {fwd = 312, strafe = 245, bwd = 260}, cbt = {fwd = 312, strafe = 245, bwd = 260}}}}, lightning = {stand = {walk = {ntl = {fwd = 150, strafe = 120, bwd = 100}, hos = {fwd = 285, strafe = 225, bwd = 215}, cbt = {fwd = 285, strafe = 225, bwd = 215}}, run = {hos = {fwd = 600, strafe = 390, bwd = 325}, cbt = {fwd = 475, strafe = 350, bwd = 325}}}, crouch = {walk = {hos = {fwd = 255, strafe = 210, bwd = 190}, cbt = {fwd = 255, strafe = 210, bwd = 190}}, run = {hos = {fwd = 400, strafe = 315, bwd = 280}, cbt = {fwd = 400, strafe = 315, bwd = 280}}}}, slow = {stand = {walk = {ntl = {fwd = 144, strafe = 120, bwd = 113}, hos = {fwd = 144, strafe = 120, bwd = 113}, cbt = {fwd = 144, strafe = 120, bwd = 113}}, run = {hos = {fwd = 360, strafe = 300, bwd = 355}, cbt = {fwd = 360, strafe = 300, bwd = 355}}}, crouch = {walk = {hos = {fwd = 144, strafe = 120, bwd = 113}, cbt = {fwd = 144, strafe = 120, bwd = 113}}, run = {hos = {fwd = 360, strafe = 300, bwd = 355}, cbt = {fwd = 360, strafe = 300, bwd = 355}}}}, normal = {stand = {walk = {ntl = {fwd = 150, strafe = 120, bwd = 100}, hos = {fwd = 220, strafe = 190, bwd = 170}, cbt = {fwd = 220, strafe = 190, bwd = 170}}, run = {hos = {fwd = 450, strafe = 290, bwd = 255}, cbt = {fwd = 400, strafe = 250, bwd = 255}}}, crouch = {walk = {hos = {fwd = 210, strafe = 170, bwd = 160}, cbt = {fwd = 210, strafe = 170, bwd = 160}}, run = {hos = {fwd = 310, strafe = 260, bwd = 235}, cbt = {fwd = 350, strafe = 260, bwd = 235}}}}, fast = {stand = {walk = {ntl = {fwd = 150, strafe = 120, bwd = 110}, hos = {fwd = 270, strafe = 215, bwd = 185}, cbt = {fwd = 270, strafe = 215, bwd = 185}}, run = {hos = {fwd = 525, strafe = 315, bwd = 280}, cbt = {fwd = 450, strafe = 285, bwd = 280}}}, crouch = {walk = {hos = {fwd = 235, strafe = 180, bwd = 170}, cbt = {fwd = 235, strafe = 180, bwd = 170}}, run = {hos = {fwd = 330, strafe = 280, bwd = 255}, cbt = {fwd = 312, strafe = 270, bwd = 255}}}}, very_fast = {stand = {walk = {ntl = {fwd = 150, strafe = 120, bwd = 110}, hos = {fwd = 285, strafe = 225, bwd = 215}, cbt = {fwd = 285, strafe = 225, bwd = 215}}, run = {hos = {fwd = 550, strafe = 340, bwd = 325}, cbt = {fwd = 475, strafe = 325, bwd = 300}}}, crouch = {walk = {hos = {fwd = 245, strafe = 210, bwd = 190}, cbt = {fwd = 255, strafe = 190, bwd = 190}}, run = {hos = {fwd = 350, strafe = 282, bwd = 268}, cbt = {fwd = 312, strafe = 282, bwd = 268}}}}}
  for speed_preset_name,poses in pairs(presets.move_speed) do
    for pose,hastes in pairs(poses) do
      hastes.run.ntl = hastes.run.hos
    end
    poses.crouch.walk.ntl = poses.crouch.walk.hos
    poses.crouch.run.ntl = poses.crouch.run.hos
    poses.stand.run.ntl = poses.stand.run.hos
    poses.panic = poses.stand
  end
  presets.surrender = {}
  presets.surrender.easy = {base_chance = 0.75, significant_chance = 0.10000000149012, violence_timeout = 2, reasons = {health = {1 = 0.20000000298023, 0.30000001192093 = 1}, weapon_down = 0.80000001192093, pants_down = 1, isolated = 0.10000000149012}, factors = {flanked = 0.070000000298023, unaware_of_aggressor = 0.079999998211861, enemy_weap_cold = 0.15000000596046, aggressor_dis = {1000 = 0.019999999552965, 300 = 0.15000000596046}}}
  presets.surrender.normal = {base_chance = 0.5, significant_chance = 0.20000000298023, violence_timeout = 2, reasons = {health = {1 = 0, 0.5 = 0.5}, weapon_down = 0.5, pants_down = 1, isolated = 0.079999998211861}, factors = {flanked = 0.050000000745058, unaware_of_aggressor = 0.10000000149012, enemy_weap_cold = 0.10999999940395, aggressor_dis = {1000 = 0, 300 = 0.10000000149012}}}
  presets.surrender.hard = {base_chance = 0.34999999403954, significant_chance = 0.25, violence_timeout = 2, reasons = {health = {1 = 0, 0.5 = 0.5}, weapon_down = 0.10000000149012, pants_down = 0.25}, factors = {isolated = 0.10000000149012, flanked = 0.03999999910593, unaware_of_aggressor = 0.10000000149012, enemy_weap_cold = 0.050000000745058, aggressor_dis = {1000 = 0, 300 = 0.10000000149012}}}
  presets.surrender.special = {base_chance = 0.25, significant_chance = 0.25, violence_timeout = 2, reasons = {health = {0.5 = 0, 0.20000000298023 = 0.25}, weapon_down = 0.019999999552965, pants_down = 0.20000000298023}, factors = {isolated = 0.050000000745058, flanked = 0.014999999664724, unaware_of_aggressor = 0.019999999552965, enemy_weap_cold = 0.050000000745058}}
  presets.suppression = {easy = {duration = {10, 15}, react_point = {0, 2}, brown_point = {3, 5}}, hard_def = {duration = {5, 10}, react_point = {0, 2}, brown_point = {5, 6}}, hard_agg = {duration = {5, 8}, react_point = {2, 5}, brown_point = {5, 6}}, no_supress = {duration = {0.10000000149012, 0.15000000596046}, react_point = {100, 200}, brown_point = {400, 500}}}
   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

  presets.enemy_chatter, {aggressive = true, retreat = true, follow_me = true, clear = true, go_go = true, ready = true, smoke = true, incomming_tank = true}.contact, {aggressive = true, retreat = true, follow_me = true, clear = true, go_go = true, ready = true, smoke = true, incomming_tank = true}.incomming_taser, {aggressive = true, retreat = true, follow_me = true, clear = true, go_go = true, ready = true, smoke = true, incomming_tank = true}.incomming_shield, {aggressive = true, retreat = true, follow_me = true, clear = true, go_go = true, ready = true, smoke = true, incomming_tank = true}.incomming_spooc = {no_chatter = {}, cop = {aggressive = true, retreat = true, go_go = true, contact = true}, swat = {aggressive = true, retreat = true, follow_me = true, clear = true, go_go = true, ready = true, smoke = true, incomming_tank = true}, shield = {follow_me = true}}, true, true, true, true
  return presets
end

CharacterTweakData._create_table_structure = function(l_23_0)
  l_23_0.weap_ids = {"beretta92", "c45", "raging_bull", "m4", "ak47", "r870", "mossberg", "mp5", "mp9", "mac11", "m14_sniper_npc"}
   -- Warning: undefined locals caused missing assignments!
end

CharacterTweakData._process_weapon_usage_table = function(l_24_0, l_24_1)
  for _,weap_id in ipairs(l_24_0.weap_ids) do
    local usage_data = l_24_1[weap_id]
    if usage_data then
      for i_range,range_data in ipairs(usage_data.FALLOFF) do
        local modes = range_data.mode
        local total = 0
        for i_firemode,value in ipairs(modes) do
          total = total + value
        end
        local prev_value = nil
        for i_firemode,value in ipairs(modes) do
          prev_value = (prev_value or 0) + value / (total)
          modes[i_firemode] = prev_value
        end
      end
    end
  end
end

CharacterTweakData._set_easy = function(l_25_0)
  l_25_0:_multiply_all_hp(1, 1)
  l_25_0:_multiply_weapon_delay(l_25_0.presets.weapon.normal, 0)
  l_25_0:_multiply_weapon_delay(l_25_0.presets.weapon.good, 0)
  l_25_0:_multiply_weapon_delay(l_25_0.presets.weapon.expert, 0)
  l_25_0:_multiply_weapon_delay(l_25_0.presets.weapon.sniper, 3)
  l_25_0:_multiply_weapon_delay(l_25_0.presets.weapon.gang_member, 0)
  l_25_0.presets.gang_member_damage.REGENERATE_TIME = 1.7999999523163
  l_25_0.presets.gang_member_damage.REGENERATE_TIME_AWAY = 0.20000000298023
end

CharacterTweakData._set_normal = function(l_26_0)
  l_26_0:_multiply_all_hp(1, 1)
  l_26_0:_multiply_weapon_delay(l_26_0.presets.weapon.normal, 0)
  l_26_0:_multiply_weapon_delay(l_26_0.presets.weapon.good, 0)
  l_26_0:_multiply_weapon_delay(l_26_0.presets.weapon.expert, 0)
  l_26_0:_multiply_weapon_delay(l_26_0.presets.weapon.sniper, 3)
  l_26_0:_multiply_weapon_delay(l_26_0.presets.weapon.gang_member, 0)
  l_26_0.presets.gang_member_damage.REGENERATE_TIME = 2
  l_26_0.presets.gang_member_damage.REGENERATE_TIME_AWAY = 0.20000000298023
end

CharacterTweakData._set_hard = function(l_27_0)
  l_27_0:_multiply_all_hp(1, 1)
  l_27_0:_multiply_weapon_delay(l_27_0.presets.weapon.normal, 0)
  l_27_0:_multiply_weapon_delay(l_27_0.presets.weapon.good, 0)
  l_27_0:_multiply_weapon_delay(l_27_0.presets.weapon.expert, 0)
  l_27_0:_multiply_weapon_delay(l_27_0.presets.weapon.sniper, 3)
  l_27_0:_multiply_weapon_delay(l_27_0.presets.weapon.gang_member, 0)
  l_27_0.presets.gang_member_damage.REGENERATE_TIME = 2
  l_27_0.presets.gang_member_damage.REGENERATE_TIME_AWAY = 1
end

CharacterTweakData._set_overkill = function(l_28_0)
  l_28_0:_multiply_all_hp(1, 1)
  l_28_0:_multiply_weapon_delay(l_28_0.presets.weapon.normal, 0)
  l_28_0:_multiply_weapon_delay(l_28_0.presets.weapon.good, 0)
  l_28_0:_multiply_weapon_delay(l_28_0.presets.weapon.expert, 0)
  l_28_0:_multiply_weapon_delay(l_28_0.presets.weapon.sniper, 3)
  l_28_0:_multiply_weapon_delay(l_28_0.presets.weapon.gang_member, 0)
  l_28_0.presets.gang_member_damage.REGENERATE_TIME = 2.5
  l_28_0.presets.gang_member_damage.REGENERATE_TIME_AWAY = 1.3999999761581
end

CharacterTweakData._set_overkill_145 = function(l_29_0)
  if SystemInfo:platform() == Idstring("PS3") then
    l_29_0:_multiply_all_hp(1, 1)
  else
    l_29_0:_multiply_all_hp(1, 1)
  end
  l_29_0:_multiply_weapon_delay(l_29_0.presets.weapon.normal, 0)
  l_29_0:_multiply_weapon_delay(l_29_0.presets.weapon.good, 0)
  l_29_0:_multiply_weapon_delay(l_29_0.presets.weapon.expert, 0)
  l_29_0:_multiply_weapon_delay(l_29_0.presets.weapon.sniper, 3)
  l_29_0:_multiply_weapon_delay(l_29_0.presets.weapon.gang_member, 0)
  l_29_0.presets.gang_member_damage.REGENERATE_TIME = 2.5
  l_29_0.presets.gang_member_damage.REGENERATE_TIME_AWAY = 1.3999999761581
end

CharacterTweakData._multiply_weapon_delay = function(l_30_0, l_30_1, l_30_2)
  for _,weap_id in ipairs(l_30_0.weap_ids) do
    local usage_data = l_30_1[weap_id]
    if usage_data then
      usage_data.focus_delay = usage_data.focus_delay * l_30_2
    end
  end
end

CharacterTweakData._multiply_all_hp = function(l_31_0, l_31_1, l_31_2)
  l_31_0.security.HEALTH_INIT = l_31_0.security.HEALTH_INIT * l_31_1
  l_31_0.cop.HEALTH_INIT = l_31_0.cop.HEALTH_INIT * l_31_1
  l_31_0.fbi.HEALTH_INIT = l_31_0.fbi.HEALTH_INIT * l_31_1
  l_31_0.swat.HEALTH_INIT = l_31_0.swat.HEALTH_INIT * l_31_1
  l_31_0.heavy_swat.HEALTH_INIT = l_31_0.heavy_swat.HEALTH_INIT * l_31_1
  l_31_0.fbi_heavy_swat.HEALTH_INIT = l_31_0.fbi_heavy_swat.HEALTH_INIT * l_31_1
  l_31_0.sniper.HEALTH_INIT = l_31_0.sniper.HEALTH_INIT * l_31_1
  l_31_0.gangster.HEALTH_INIT = l_31_0.gangster.HEALTH_INIT * l_31_1
  l_31_0.tank.HEALTH_INIT = l_31_0.tank.HEALTH_INIT * l_31_1
  l_31_0.spooc.HEALTH_INIT = l_31_0.spooc.HEALTH_INIT * l_31_1
  l_31_0.shield.HEALTH_INIT = l_31_0.shield.HEALTH_INIT * l_31_1
  l_31_0.taser.HEALTH_INIT = l_31_0.taser.HEALTH_INIT * l_31_1
  l_31_0.biker_escape.HEALTH_INIT = l_31_0.biker_escape.HEALTH_INIT * l_31_1
  if l_31_0.security.headshot_dmg_mul then
    l_31_0.security.headshot_dmg_mul = l_31_0.security.headshot_dmg_mul * l_31_2
  end
  if l_31_0.cop.headshot_dmg_mul then
    l_31_0.cop.headshot_dmg_mul = l_31_0.cop.headshot_dmg_mul * l_31_2
  end
  if l_31_0.fbi.headshot_dmg_mul then
    l_31_0.fbi.headshot_dmg_mul = l_31_0.fbi.headshot_dmg_mul * l_31_2
  end
  if l_31_0.swat.headshot_dmg_mul then
    l_31_0.swat.headshot_dmg_mul = l_31_0.swat.headshot_dmg_mul * l_31_2
  end
  if l_31_0.heavy_swat.headshot_dmg_mul then
    l_31_0.heavy_swat.headshot_dmg_mul = l_31_0.heavy_swat.headshot_dmg_mul * l_31_2
  end
  if l_31_0.fbi_heavy_swat.headshot_dmg_mul then
    l_31_0.fbi_heavy_swat.headshot_dmg_mul = l_31_0.fbi_heavy_swat.headshot_dmg_mul * l_31_2
  end
  if l_31_0.sniper.headshot_dmg_mul then
    l_31_0.sniper.headshot_dmg_mul = l_31_0.sniper.headshot_dmg_mul * l_31_2
  end
  if l_31_0.gangster.headshot_dmg_mul then
    l_31_0.gangster.headshot_dmg_mul = l_31_0.gangster.headshot_dmg_mul * l_31_2
  end
  if l_31_0.tank.headshot_dmg_mul then
    l_31_0.tank.headshot_dmg_mul = l_31_0.tank.headshot_dmg_mul * l_31_2
  end
  if l_31_0.spooc.headshot_dmg_mul then
    l_31_0.spooc.headshot_dmg_mul = l_31_0.spooc.headshot_dmg_mul * l_31_2
  end
  if l_31_0.shield.headshot_dmg_mul then
    l_31_0.shield.headshot_dmg_mul = l_31_0.shield.headshot_dmg_mul * l_31_2
  end
  if l_31_0.taser.headshot_dmg_mul then
    l_31_0.taser.headshot_dmg_mul = l_31_0.taser.headshot_dmg_mul * l_31_2
  end
  if l_31_0.biker_escape.headshot_dmg_mul then
    l_31_0.biker_escape.headshot_dmg_mul = l_31_0.biker_escape.headshot_dmg_mul * l_31_2
  end
end

CharacterTweakData._multiply_all_speeds = function(l_32_0, l_32_1, l_32_2)
  local all_units = {"security", "cop", "fbi", "swat", "heavy_swat", "sniper", "gangster", "tank", "spooc", "shield", "taser"}
  for _,name in ipairs(all_units) do
    local speed_table = l_32_0[name].SPEED_WALK
    speed_table.hos = speed_table.hos * l_32_1
    speed_table.cbt = speed_table.cbt * l_32_1
  end
  l_32_0.security.SPEED_RUN = l_32_0.security.SPEED_RUN * l_32_2
  l_32_0.cop.SPEED_RUN = l_32_0.cop.SPEED_RUN * l_32_2
  l_32_0.fbi.SPEED_RUN = l_32_0.fbi.SPEED_RUN * l_32_2
  l_32_0.swat.SPEED_RUN = l_32_0.swat.SPEED_RUN * l_32_2
  l_32_0.heavy_swat.SPEED_RUN = l_32_0.heavy_swat.SPEED_RUN * l_32_2
  l_32_0.fbi_heavy_swat.SPEED_RUN = l_32_0.fbi_heavy_swat.SPEED_RUN * l_32_2
  l_32_0.sniper.SPEED_RUN = l_32_0.sniper.SPEED_RUN * l_32_2
  l_32_0.gangster.SPEED_RUN = l_32_0.gangster.SPEED_RUN * l_32_2
  l_32_0.tank.SPEED_RUN = l_32_0.tank.SPEED_RUN * l_32_2
  l_32_0.spooc.SPEED_RUN = l_32_0.spooc.SPEED_RUN * l_32_2
  l_32_0.shield.SPEED_RUN = l_32_0.shield.SPEED_RUN * l_32_2
  l_32_0.taser.SPEED_RUN = l_32_0.taser.SPEED_RUN * l_32_2
  l_32_0.biker_escape.SPEED_RUN = l_32_0.biker_escape.SPEED_RUN * l_32_2
end


