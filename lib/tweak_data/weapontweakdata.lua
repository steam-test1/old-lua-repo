-- Decompiled using luadec 2.0.1 by sztupy (http://winmo.sztupy.hu)
-- Command line was: F:\SteamLibrary\SteamApps\common\PAYDAY 2\lua\lib\tweak_data\weapontweakdata.luac 

require("lib/tweak_data/WeaponFactoryTweakData")
if not WeaponTweakData then
  WeaponTweakData = class()
end
WeaponTweakData.init = function(l_1_0)
  l_1_0:_create_table_structure()
  l_1_0:_init_data_player_weapons()
  l_1_0:_init_data_m4_npc(l_1_0)
  l_1_0:_init_data_m14_npc(l_1_0)
  l_1_0:_init_data_m14_sniper_npc(l_1_0)
  l_1_0:_init_data_c45_npc(l_1_0)
  l_1_0:_init_data_beretta92_npc(l_1_0)
  l_1_0:_init_data_raging_bull_npc()
  l_1_0:_init_data_r870_npc(l_1_0)
  l_1_0:_init_data_mossberg_npc()
  l_1_0:_init_data_mp5_npc(l_1_0)
  l_1_0:_init_data_mac11_npc(l_1_0)
  l_1_0:_init_data_glock_18_npc(l_1_0)
  l_1_0:_init_data_ak47_npc(l_1_0)
  l_1_0:_init_data_g36_npc(l_1_0)
  l_1_0:_init_data_g17_npc(l_1_0)
  l_1_0:_init_data_mp9_npc(l_1_0)
  l_1_0:_init_data_olympic_npc()
  l_1_0:_init_data_m16_npc(l_1_0)
  l_1_0:_init_data_aug_npc()
  l_1_0:_init_data_ak74_npc(l_1_0)
  l_1_0:_init_data_ak5_npc(l_1_0)
  l_1_0:_init_data_p90_npc(l_1_0)
  l_1_0:_init_data_amcar_npc()
  l_1_0:_init_data_mac10_npc(l_1_0)
  l_1_0:_init_data_akmsu_npc()
  l_1_0:_init_data_akm_npc()
  l_1_0:_init_data_deagle_npc()
  l_1_0:_init_data_serbu_npc()
  l_1_0:_init_data_saiga_npc()
  l_1_0:_init_data_huntsman_npc()
  l_1_0:_init_data_saw_npc()
  l_1_0:_init_data_sentry_gun_npc()
  l_1_0:_precalculate_values()
end

WeaponTweakData._init_data_c45_npc = function(l_2_0)
  l_2_0.c45_npc.sounds.prefix = "c45_npc"
  l_2_0.c45_npc.use_data.selection_index = 1
  l_2_0.c45_npc.DAMAGE = 1
  l_2_0.c45_npc.muzzleflash = "effects/payday2/particles/weapons/9mm_auto"
  l_2_0.c45_npc.muzzleflash_silenced = "effects/payday2/particles/weapons/9mm_auto_silence"
  l_2_0.c45_npc.shell_ejection = "effects/payday2/particles/weapons/shells/shell_9mm"
  l_2_0.c45_npc.CLIP_AMMO_MAX = 10
  l_2_0.c45_npc.NR_CLIPS_MAX = 5
  l_2_0.c45_npc.hold = "pistol"
  l_2_0.c45_npc.hud_icon = "c45"
  l_2_0.c45_npc.alert_size = 2500
  l_2_0.c45_npc.suppression = 1
end

WeaponTweakData._init_data_beretta92_npc = function(l_3_0)
  l_3_0.beretta92_npc.sounds.prefix = "beretta_npc"
  l_3_0.beretta92_npc.use_data.selection_index = 1
  l_3_0.beretta92_npc.DAMAGE = 1
  l_3_0.beretta92_npc.muzzleflash = "effects/payday2/particles/weapons/9mm_auto"
  l_3_0.beretta92_npc.muzzleflash_silenced = "effects/payday2/particles/weapons/9mm_auto_silence"
  l_3_0.beretta92_npc.shell_ejection = "effects/payday2/particles/weapons/shells/shell_9mm"
  l_3_0.beretta92_npc.CLIP_AMMO_MAX = 14
  l_3_0.beretta92_npc.NR_CLIPS_MAX = 4
  l_3_0.beretta92_npc.hold = "pistol"
  l_3_0.beretta92_npc.hud_icon = "beretta92"
  l_3_0.beretta92_npc.alert_size = 300
  l_3_0.beretta92_npc.suppression = 0.30000001192093
end

WeaponTweakData._init_data_glock_18_npc = function(l_4_0)
  l_4_0.glock_18_npc.sounds.prefix = "g18c_npc"
  l_4_0.glock_18_npc.use_data.selection_index = 1
  l_4_0.glock_18_npc.DAMAGE = 1
  l_4_0.glock_18_npc.muzzleflash = "effects/payday2/particles/weapons/9mm_auto"
  l_4_0.glock_18_npc.muzzleflash_silenced = "effects/payday2/particles/weapons/9mm_auto_silence"
  l_4_0.glock_18_npc.shell_ejection = "effects/payday2/particles/weapons/shells/shell_9mm"
  l_4_0.glock_18_npc.CLIP_AMMO_MAX = 20
  l_4_0.glock_18_npc.NR_CLIPS_MAX = 8
  l_4_0.glock_18_npc.hold = "pistol"
  l_4_0.glock_18_npc.hud_icon = "glock"
  l_4_0.glock_18_npc.alert_size = 2500
  l_4_0.glock_18_npc.suppression = 0.44999998807907
end

WeaponTweakData._init_data_raging_bull_npc = function(l_5_0)
  l_5_0.raging_bull_npc.sounds.prefix = "rbull_npc"
  l_5_0.raging_bull_npc.use_data.selection_index = 1
  l_5_0.raging_bull_npc.DAMAGE = 4
  l_5_0.raging_bull_npc.muzzleflash = "effects/payday2/particles/weapons/9mm_auto"
  l_5_0.raging_bull_npc.muzzleflash_silenced = "effects/payday2/particles/weapons/9mm_auto_silence"
  l_5_0.raging_bull_npc.shell_ejection = "effects/payday2/particles/weapons/shells/shell_empty"
  l_5_0.raging_bull_npc.CLIP_AMMO_MAX = 6
  l_5_0.raging_bull_npc.NR_CLIPS_MAX = 8
  l_5_0.raging_bull_npc.hold = "pistol"
  l_5_0.raging_bull_npc.hud_icon = "raging_bull"
  l_5_0.raging_bull_npc.alert_size = 5000
  l_5_0.raging_bull_npc.suppression = 1.7999999523163
end

WeaponTweakData._init_data_m4_npc = function(l_6_0)
  l_6_0.m4_npc.sounds.prefix = "m4_npc"
  l_6_0.m4_npc.use_data.selection_index = 2
  l_6_0.m4_npc.DAMAGE = 2
  l_6_0.m4_npc.muzzleflash = "effects/payday2/particles/weapons/556_auto"
  l_6_0.m4_npc.shell_ejection = "effects/payday2/particles/weapons/shells/shell_556"
  l_6_0.m4_npc.CLIP_AMMO_MAX = 20
  l_6_0.m4_npc.NR_CLIPS_MAX = 5
  l_6_0.m4_npc.auto.fire_rate = 0.20000000298023
  l_6_0.m4_npc.hold = "rifle"
  l_6_0.m4_npc.hud_icon = "m4"
  l_6_0.m4_npc.alert_size = 5000
  l_6_0.m4_npc.suppression = 1
end

WeaponTweakData._init_data_ak47_npc = function(l_7_0)
  l_7_0.ak47_npc.sounds.prefix = "akm_npc"
  l_7_0.ak47_npc.use_data.selection_index = 2
  l_7_0.ak47_npc.DAMAGE = 3
  l_7_0.ak47_npc.muzzleflash = "effects/payday2/particles/weapons/762_auto"
  l_7_0.ak47_npc.shell_ejection = "effects/payday2/particles/weapons/shells/shell_556"
  l_7_0.ak47_npc.CLIP_AMMO_MAX = 20
  l_7_0.ak47_npc.NR_CLIPS_MAX = 5
  l_7_0.ak47_npc.auto.fire_rate = 0.20000000298023
  l_7_0.ak47_npc.hold = "rifle"
  l_7_0.ak47_npc.hud_icon = "ak"
  l_7_0.ak47_npc.alert_size = 5000
  l_7_0.ak47_npc.suppression = 1
end

WeaponTweakData._init_data_m14_npc = function(l_8_0)
  l_8_0.m14_npc.sounds.prefix = "m14_npc"
  l_8_0.m14_npc.use_data.selection_index = 2
  l_8_0.m14_npc.DAMAGE = 4
  l_8_0.m14_npc.muzzleflash = "effects/payday2/particles/weapons/762_auto"
  l_8_0.m14_npc.shell_ejection = "effects/payday2/particles/weapons/shells/shell_556"
  l_8_0.m14_npc.CLIP_AMMO_MAX = 12
  l_8_0.m14_npc.NR_CLIPS_MAX = 8
  l_8_0.m14_npc.auto.fire_rate = 0.20000000298023
  l_8_0.m14_npc.hold = "rifle"
  l_8_0.m14_npc.hud_icon = "m14"
  l_8_0.m14_npc.alert_size = 5000
  l_8_0.m14_npc.suppression = 1
end

WeaponTweakData._init_data_m14_sniper_npc = function(l_9_0)
  l_9_0.m14_sniper_npc.sounds.prefix = "sniper_npc"
  l_9_0.m14_sniper_npc.use_data.selection_index = 2
  l_9_0.m14_sniper_npc.DAMAGE = 5.5
  l_9_0.m14_sniper_npc.muzzleflash = "effects/payday2/particles/weapons/762_auto"
  l_9_0.m14_sniper_npc.shell_ejection = "effects/payday2/particles/weapons/shells/shell_556"
  l_9_0.m14_sniper_npc.CLIP_AMMO_MAX = 6
  l_9_0.m14_sniper_npc.NR_CLIPS_MAX = 8
  l_9_0.m14_sniper_npc.hold = "rifle"
  l_9_0.m14_sniper_npc.hud_icon = "m14"
  l_9_0.m14_sniper_npc.alert_size = 5000
  l_9_0.m14_sniper_npc.suppression = 1
end

WeaponTweakData._init_data_r870_npc = function(l_10_0)
  l_10_0.r870_npc.sounds.prefix = "remington_npc"
  l_10_0.r870_npc.use_data.selection_index = 2
  l_10_0.r870_npc.DAMAGE = 6
  l_10_0.r870_npc.muzzleflash = "effects/payday2/particles/weapons/762_auto"
  l_10_0.r870_npc.shell_ejection = "effects/payday2/particles/weapons/shells/shell_slug_semi"
  l_10_0.r870_npc.CLIP_AMMO_MAX = 6
  l_10_0.r870_npc.NR_CLIPS_MAX = 4
  l_10_0.r870_npc.hold = "rifle"
  l_10_0.r870_npc.hud_icon = "r870_shotgun"
  l_10_0.r870_npc.alert_size = 4500
  l_10_0.r870_npc.suppression = 1.7999999523163
end

WeaponTweakData._init_data_mossberg_npc = function(l_11_0)
  l_11_0.mossberg_npc.sounds.prefix = "mossberg_npc"
  l_11_0.mossberg_npc.use_data.selection_index = 2
  l_11_0.mossberg_npc.DAMAGE = 6
  l_11_0.mossberg_npc.muzzleflash = "effects/payday2/particles/weapons/762_auto"
  l_11_0.mossberg_npc.shell_ejection = "effects/payday2/particles/weapons/shells/shell_slug_semi"
  l_11_0.mossberg_npc.CLIP_AMMO_MAX = 4
  l_11_0.mossberg_npc.NR_CLIPS_MAX = 6
  l_11_0.mossberg_npc.hold = "rifle"
  l_11_0.mossberg_npc.hud_icon = "mossberg"
  l_11_0.mossberg_npc.alert_size = 3000
  l_11_0.mossberg_npc.suppression = 2
end

WeaponTweakData._init_data_mp5_npc = function(l_12_0)
  l_12_0.mp5_npc.sounds.prefix = "mp5_npc"
  l_12_0.mp5_npc.use_data.selection_index = 1
  l_12_0.mp5_npc.DAMAGE = 1
  l_12_0.mp5_npc.muzzleflash = "effects/payday2/particles/weapons/9mm_auto"
  l_12_0.mp5_npc.muzzleflash_silenced = "effects/payday2/particles/weapons/9mm_auto_silence"
  l_12_0.mp5_npc.shell_ejection = "effects/payday2/particles/weapons/shells/shell_9mm"
  l_12_0.mp5_npc.CLIP_AMMO_MAX = 30
  l_12_0.mp5_npc.NR_CLIPS_MAX = 5
  l_12_0.mp5_npc.auto.fire_rate = 0.10000000149012
  l_12_0.mp5_npc.hold = "rifle"
  l_12_0.mp5_npc.hud_icon = "mp5"
  l_12_0.mp5_npc.alert_size = 2500
  l_12_0.mp5_npc.suppression = 1
end

WeaponTweakData._init_data_mac11_npc = function(l_13_0)
  l_13_0.mac11_npc.sounds.prefix = "mp5_npc"
  l_13_0.mac11_npc.use_data.selection_index = 1
  l_13_0.mac11_npc.DAMAGE = 2
  l_13_0.mac11_npc.muzzleflash = "effects/payday2/particles/weapons/9mm_auto"
  l_13_0.mac11_npc.muzzleflash_silenced = "effects/payday2/particles/weapons/9mm_auto_silence"
  l_13_0.mac11_npc.shell_ejection = "effects/payday2/particles/weapons/shells/shell_9mm"
  l_13_0.mac11_npc.CLIP_AMMO_MAX = 32
  l_13_0.mac11_npc.NR_CLIPS_MAX = 5
  l_13_0.mac11_npc.auto.fire_rate = 0.10000000149012
  l_13_0.mac11_npc.hold = "pistol"
  l_13_0.mac11_npc.hud_icon = "mac11"
  l_13_0.mac11_npc.alert_size = 1000
  l_13_0.mac11_npc.suppression = 1
end

WeaponTweakData._init_data_g36_npc = function(l_14_0)
  l_14_0.g36_npc.sounds.prefix = "g36_npc"
  l_14_0.g36_npc.use_data.selection_index = 2
  l_14_0.g36_npc.DAMAGE = 2
  l_14_0.g36_npc.muzzleflash = "effects/payday2/particles/weapons/556_auto"
  l_14_0.g36_npc.shell_ejection = "effects/payday2/particles/weapons/shells/shell_556"
  l_14_0.g36_npc.CLIP_AMMO_MAX = 20
  l_14_0.g36_npc.NR_CLIPS_MAX = 5
  l_14_0.g36_npc.auto.fire_rate = 0.20000000298023
  l_14_0.g36_npc.hold = "rifle"
  l_14_0.g36_npc.hud_icon = "m4"
  l_14_0.g36_npc.alert_size = 5000
  l_14_0.g36_npc.suppression = 1
end

WeaponTweakData._init_data_g17_npc = function(l_15_0)
  l_15_0.g17_npc.sounds.prefix = "g17_npc"
  l_15_0.g17_npc.use_data.selection_index = 1
  l_15_0.g17_npc.DAMAGE = 1
  l_15_0.g17_npc.muzzleflash = "effects/payday2/particles/weapons/9mm_auto"
  l_15_0.g17_npc.muzzleflash_silenced = "effects/payday2/particles/weapons/9mm_auto_silence"
  l_15_0.g17_npc.shell_ejection = "effects/payday2/particles/weapons/shells/shell_9mm"
  l_15_0.g17_npc.CLIP_AMMO_MAX = 10
  l_15_0.g17_npc.NR_CLIPS_MAX = 5
  l_15_0.g17_npc.hold = "pistol"
  l_15_0.g17_npc.hud_icon = "c45"
  l_15_0.g17_npc.alert_size = 2500
  l_15_0.g17_npc.suppression = 1
end

WeaponTweakData._init_data_mp9_npc = function(l_16_0)
  l_16_0.mp9_npc.sounds.prefix = "mp9_npc"
  l_16_0.mp9_npc.use_data.selection_index = 1
  l_16_0.mp9_npc.DAMAGE = 1
  l_16_0.mp9_npc.muzzleflash = "effects/payday2/particles/weapons/9mm_auto"
  l_16_0.mp9_npc.muzzleflash_silenced = "effects/payday2/particles/weapons/9mm_auto_silence"
  l_16_0.mp9_npc.shell_ejection = "effects/payday2/particles/weapons/shells/shell_9mm"
  l_16_0.mp9_npc.CLIP_AMMO_MAX = 32
  l_16_0.mp9_npc.NR_CLIPS_MAX = 5
  l_16_0.mp9_npc.auto.fire_rate = 0.10000000149012
  l_16_0.mp9_npc.hold = "pistol"
  l_16_0.mp9_npc.hud_icon = "mac11"
  l_16_0.mp9_npc.alert_size = 1000
  l_16_0.mp9_npc.suppression = 1
end

WeaponTweakData._init_data_olympic_npc = function(l_17_0)
  l_17_0.olympic_npc.sounds.prefix = "m4_olympic_npc"
  l_17_0.olympic_npc.use_data.selection_index = 1
  l_17_0.olympic_npc.DAMAGE = 2
  l_17_0.olympic_npc.muzzleflash = "effects/payday2/particles/weapons/9mm_auto"
  l_17_0.olympic_npc.muzzleflash_silenced = "effects/payday2/particles/weapons/9mm_auto_silence"
  l_17_0.olympic_npc.shell_ejection = "effects/payday2/particles/weapons/shells/shell_556"
  l_17_0.olympic_npc.CLIP_AMMO_MAX = 32
  l_17_0.olympic_npc.NR_CLIPS_MAX = 5
  l_17_0.olympic_npc.auto.fire_rate = 0.10000000149012
  l_17_0.olympic_npc.hold = "rifle"
  l_17_0.olympic_npc.hud_icon = "mac11"
  l_17_0.olympic_npc.alert_size = 1000
  l_17_0.olympic_npc.suppression = 1
end

WeaponTweakData._init_data_m16_npc = function(l_18_0)
  l_18_0.m16_npc.sounds.prefix = "m16_npc"
  l_18_0.m16_npc.use_data.selection_index = 2
  l_18_0.m16_npc.DAMAGE = 3
  l_18_0.m16_npc.muzzleflash = "effects/payday2/particles/weapons/762_auto"
  l_18_0.m16_npc.shell_ejection = "effects/payday2/particles/weapons/shells/shell_556"
  l_18_0.m16_npc.CLIP_AMMO_MAX = 12
  l_18_0.m16_npc.NR_CLIPS_MAX = 8
  l_18_0.m16_npc.auto.fire_rate = 0.20000000298023
  l_18_0.m16_npc.hold = "rifle"
  l_18_0.m16_npc.hud_icon = "m14"
  l_18_0.m16_npc.alert_size = 5000
  l_18_0.m16_npc.suppression = 1
end

WeaponTweakData._init_data_aug_npc = function(l_19_0)
  l_19_0.aug_npc.sounds.prefix = "aug_npc"
  l_19_0.aug_npc.use_data.selection_index = 2
  l_19_0.aug_npc.DAMAGE = 2
  l_19_0.aug_npc.muzzleflash = "effects/payday2/particles/weapons/556_auto"
  l_19_0.aug_npc.shell_ejection = "effects/payday2/particles/weapons/shells/shell_556"
  l_19_0.aug_npc.CLIP_AMMO_MAX = 20
  l_19_0.aug_npc.NR_CLIPS_MAX = 5
  l_19_0.aug_npc.auto.fire_rate = 0.20000000298023
  l_19_0.aug_npc.hold = "rifle"
  l_19_0.aug_npc.hud_icon = "m4"
  l_19_0.aug_npc.alert_size = 5000
  l_19_0.aug_npc.suppression = 1
end

WeaponTweakData._init_data_ak74_npc = function(l_20_0)
  l_20_0.ak74_npc.sounds.prefix = "ak74_npc"
  l_20_0.ak74_npc.use_data.selection_index = 2
  l_20_0.ak74_npc.DAMAGE = 2
  l_20_0.ak74_npc.muzzleflash = "effects/payday2/particles/weapons/762_auto"
  l_20_0.ak74_npc.shell_ejection = "effects/payday2/particles/weapons/shells/shell_556"
  l_20_0.ak74_npc.CLIP_AMMO_MAX = 20
  l_20_0.ak74_npc.NR_CLIPS_MAX = 5
  l_20_0.ak74_npc.auto.fire_rate = 0.20000000298023
  l_20_0.ak74_npc.hold = "rifle"
  l_20_0.ak74_npc.hud_icon = "ak"
  l_20_0.ak74_npc.alert_size = 5000
  l_20_0.ak74_npc.suppression = 1
end

WeaponTweakData._init_data_ak5_npc = function(l_21_0)
  l_21_0.ak5_npc.sounds.prefix = "ak5_npc"
  l_21_0.ak5_npc.use_data.selection_index = 2
  l_21_0.ak5_npc.DAMAGE = 2
  l_21_0.ak5_npc.muzzleflash = "effects/payday2/particles/weapons/556_auto"
  l_21_0.ak5_npc.shell_ejection = "effects/payday2/particles/weapons/shells/shell_556"
  l_21_0.ak5_npc.CLIP_AMMO_MAX = 20
  l_21_0.ak5_npc.NR_CLIPS_MAX = 5
  l_21_0.ak5_npc.auto.fire_rate = 0.20000000298023
  l_21_0.ak5_npc.hold = "rifle"
  l_21_0.ak5_npc.hud_icon = "m4"
  l_21_0.ak5_npc.alert_size = 5000
  l_21_0.ak5_npc.suppression = 1
end

WeaponTweakData._init_data_p90_npc = function(l_22_0)
  l_22_0.p90_npc.sounds.prefix = "p90_npc"
  l_22_0.p90_npc.use_data.selection_index = 1
  l_22_0.p90_npc.DAMAGE = 1
  l_22_0.p90_npc.muzzleflash = "effects/payday2/particles/weapons/9mm_auto"
  l_22_0.p90_npc.muzzleflash_silenced = "effects/payday2/particles/weapons/9mm_auto_silence"
  l_22_0.p90_npc.shell_ejection = "effects/payday2/particles/weapons/shells/shell_556"
  l_22_0.p90_npc.CLIP_AMMO_MAX = 32
  l_22_0.p90_npc.NR_CLIPS_MAX = 5
  l_22_0.p90_npc.auto.fire_rate = 0.10000000149012
  l_22_0.p90_npc.hold = "rifle"
  l_22_0.p90_npc.hud_icon = "mac11"
  l_22_0.p90_npc.alert_size = 1000
  l_22_0.p90_npc.suppression = 1
end

WeaponTweakData._init_data_amcar_npc = function(l_23_0)
  l_23_0.amcar_npc.sounds.prefix = "amcar_npc"
  l_23_0.amcar_npc.use_data.selection_index = 2
  l_23_0.amcar_npc.DAMAGE = 2
  l_23_0.amcar_npc.muzzleflash = "effects/payday2/particles/weapons/556_auto"
  l_23_0.amcar_npc.shell_ejection = "effects/payday2/particles/weapons/shells/shell_556"
  l_23_0.amcar_npc.CLIP_AMMO_MAX = 20
  l_23_0.amcar_npc.NR_CLIPS_MAX = 5
  l_23_0.amcar_npc.auto.fire_rate = 0.20000000298023
  l_23_0.amcar_npc.hold = "rifle"
  l_23_0.amcar_npc.hud_icon = "m4"
  l_23_0.amcar_npc.alert_size = 5000
  l_23_0.amcar_npc.suppression = 1
end

WeaponTweakData._init_data_mac10_npc = function(l_24_0)
  l_24_0.mac10_npc.sounds.prefix = "mac10_npc"
  l_24_0.mac10_npc.use_data.selection_index = 1
  l_24_0.mac10_npc.DAMAGE = 2
  l_24_0.mac10_npc.muzzleflash = "effects/payday2/particles/weapons/9mm_auto"
  l_24_0.mac10_npc.muzzleflash_silenced = "effects/payday2/particles/weapons/9mm_auto_silence"
  l_24_0.mac10_npc.shell_ejection = "effects/payday2/particles/weapons/shells/shell_9mm"
  l_24_0.mac10_npc.CLIP_AMMO_MAX = 32
  l_24_0.mac10_npc.NR_CLIPS_MAX = 5
  l_24_0.mac10_npc.auto.fire_rate = 0.10000000149012
  l_24_0.mac10_npc.hold = "pistol"
  l_24_0.mac10_npc.hud_icon = "mac11"
  l_24_0.mac10_npc.alert_size = 1000
  l_24_0.mac10_npc.suppression = 1
end

WeaponTweakData._init_data_akmsu_npc = function(l_25_0)
  l_25_0.akmsu_npc.sounds.prefix = "akmsu_npc"
  l_25_0.akmsu_npc.use_data.selection_index = 1
  l_25_0.akmsu_npc.DAMAGE = 3
  l_25_0.akmsu_npc.muzzleflash = "effects/payday2/particles/weapons/9mm_auto"
  l_25_0.akmsu_npc.muzzleflash_silenced = "effects/payday2/particles/weapons/9mm_auto_silence"
  l_25_0.akmsu_npc.shell_ejection = "effects/payday2/particles/weapons/shells/shell_556"
  l_25_0.akmsu_npc.CLIP_AMMO_MAX = 32
  l_25_0.akmsu_npc.NR_CLIPS_MAX = 5
  l_25_0.akmsu_npc.auto.fire_rate = 0.10000000149012
  l_25_0.akmsu_npc.hold = "rifle"
  l_25_0.akmsu_npc.hud_icon = "mac11"
  l_25_0.akmsu_npc.alert_size = 1000
  l_25_0.akmsu_npc.suppression = 1
end

WeaponTweakData._init_data_akm_npc = function(l_26_0)
  l_26_0.akm_npc.sounds.prefix = "akm_npc"
  l_26_0.akm_npc.use_data.selection_index = 2
  l_26_0.akm_npc.DAMAGE = 3
  l_26_0.akm_npc.muzzleflash = "effects/payday2/particles/weapons/762_auto"
  l_26_0.akm_npc.shell_ejection = "effects/payday2/particles/weapons/shells/shell_556"
  l_26_0.akm_npc.CLIP_AMMO_MAX = 20
  l_26_0.akm_npc.NR_CLIPS_MAX = 5
  l_26_0.akm_npc.auto.fire_rate = 0.20000000298023
  l_26_0.akm_npc.hold = "rifle"
  l_26_0.akm_npc.hud_icon = "ak"
  l_26_0.akm_npc.alert_size = 5000
  l_26_0.akm_npc.suppression = 1
end

WeaponTweakData._init_data_deagle_npc = function(l_27_0)
  l_27_0.deagle_npc.sounds.prefix = "deagle_npc"
  l_27_0.deagle_npc.use_data.selection_index = 1
  l_27_0.deagle_npc.DAMAGE = 4
  l_27_0.deagle_npc.muzzleflash = "effects/payday2/particles/weapons/9mm_auto"
  l_27_0.deagle_npc.muzzleflash_silenced = "effects/payday2/particles/weapons/9mm_auto_silence"
  l_27_0.deagle_npc.shell_ejection = "effects/payday2/particles/weapons/shells/shell_9mm"
  l_27_0.deagle_npc.CLIP_AMMO_MAX = 10
  l_27_0.deagle_npc.NR_CLIPS_MAX = 5
  l_27_0.deagle_npc.hold = "pistol"
  l_27_0.deagle_npc.hud_icon = "c45"
  l_27_0.deagle_npc.alert_size = 2500
  l_27_0.deagle_npc.suppression = 1
end

WeaponTweakData._init_data_serbu_npc = function(l_28_0)
  l_28_0.serbu_npc.sounds.prefix = "serbu_npc"
  l_28_0.serbu_npc.use_data.selection_index = 1
  l_28_0.serbu_npc.DAMAGE = 5
  l_28_0.serbu_npc.muzzleflash = "effects/payday2/particles/weapons/762_auto"
  l_28_0.serbu_npc.shell_ejection = "effects/payday2/particles/weapons/shells/shell_slug_semi"
  l_28_0.serbu_npc.CLIP_AMMO_MAX = 6
  l_28_0.serbu_npc.NR_CLIPS_MAX = 4
  l_28_0.serbu_npc.hold = "rifle"
  l_28_0.serbu_npc.hud_icon = "r870_shotgun"
  l_28_0.serbu_npc.alert_size = 4500
  l_28_0.serbu_npc.suppression = 1.7999999523163
end

WeaponTweakData._init_data_saiga_npc = function(l_29_0)
  l_29_0.saiga_npc.sounds.prefix = "saiga_npc"
  l_29_0.saiga_npc.use_data.selection_index = 2
  l_29_0.saiga_npc.DAMAGE = 5
  l_29_0.saiga_npc.muzzleflash = "effects/payday2/particles/weapons/762_auto"
  l_29_0.saiga_npc.shell_ejection = "effects/payday2/particles/weapons/shells/shell_slug"
  l_29_0.saiga_npc.CLIP_AMMO_MAX = 6
  l_29_0.saiga_npc.NR_CLIPS_MAX = 4
  l_29_0.saiga_npc.hold = "rifle"
  l_29_0.saiga_npc.hud_icon = "r870_shotgun"
  l_29_0.saiga_npc.alert_size = 4500
  l_29_0.saiga_npc.suppression = 1.7999999523163
end

WeaponTweakData._init_data_huntsman_npc = function(l_30_0)
  l_30_0.huntsman_npc.sounds.prefix = "huntsman_npc"
  l_30_0.huntsman_npc.use_data.selection_index = 2
  l_30_0.huntsman_npc.DAMAGE = 12
  l_30_0.huntsman_npc.muzzleflash = "effects/payday2/particles/weapons/762_auto"
  l_30_0.huntsman_npc.shell_ejection = "effects/payday2/particles/weapons/shells/shell_empty"
  l_30_0.huntsman_npc.CLIP_AMMO_MAX = 2
  l_30_0.huntsman_npc.NR_CLIPS_MAX = 4
  l_30_0.huntsman_npc.hold = "rifle"
  l_30_0.huntsman_npc.hud_icon = "r870_shotgun"
  l_30_0.huntsman_npc.alert_size = 4500
  l_30_0.huntsman_npc.suppression = 1.7999999523163
end

WeaponTweakData._init_data_saw_npc = function(l_31_0)
  l_31_0.saw_npc.sounds.prefix = "saw_npc"
  l_31_0.saw_npc.sounds.fire = "Play_npc_saw_handheld_start"
  l_31_0.saw_npc.sounds.stop_fire = "Play_npc_saw_handheld_end"
  l_31_0.saw_npc.use_data.selection_index = 2
  l_31_0.saw_npc.DAMAGE = 1
  l_31_0.saw_npc.muzzleflash = "effects/payday2/particles/weapons/762_auto"
  l_31_0.saw_npc.shell_ejection = "effects/payday2/particles/weapons/shells/shell_empty"
  l_31_0.saw_npc.CLIP_AMMO_MAX = 2
  l_31_0.saw_npc.NR_CLIPS_MAX = 4
  l_31_0.saw_npc.hold = "rifle"
  l_31_0.saw_npc.hud_icon = "r870_shotgun"
  l_31_0.saw_npc.alert_size = 4500
  l_31_0.saw_npc.suppression = 1.7999999523163
end

WeaponTweakData._init_data_sentry_gun_npc = function(l_32_0)
  l_32_0.sentry_gun.name_id = "debug_sentry_gun"
  l_32_0.sentry_gun.DAMAGE = 0.5
  l_32_0.sentry_gun.SPREAD = 5
  l_32_0.sentry_gun.FIRE_RANGE = 5000
  l_32_0.sentry_gun.muzzleflash = "effects/payday2/particles/weapons/9mm_auto"
  l_32_0.sentry_gun.muzzleflash_silenced = "effects/payday2/particles/weapons/9mm_auto_silence"
  l_32_0.sentry_gun.auto.fire_rate = 0.15000000596046
  l_32_0.sentry_gun.alert_size = 2500
  l_32_0.sentry_gun.BAG_DMG_MUL = 0.25
  l_32_0.sentry_gun.SHIELD_DMG_MUL = 0
  l_32_0.sentry_gun.LOST_SIGHT_VERIFICATION = 0.10000000149012
  l_32_0.sentry_gun.DEATH_VERIFICATION = {0.60000002384186, 0.89999997615814}
  l_32_0.sentry_gun.DETECTION_RANGE = 1800
  l_32_0.sentry_gun.KEEP_FIRE_ANGLE = 0.80000001192093
  l_32_0.sentry_gun.MAX_VEL_SPIN = 120
  l_32_0.sentry_gun.MIN_VEL_SPIN = l_32_0.sentry_gun.MAX_VEL_SPIN * 0.050000000745058
  l_32_0.sentry_gun.SLOWDOWN_ANGLE_SPIN = 30
  l_32_0.sentry_gun.ACC_SPIN = l_32_0.sentry_gun.MAX_VEL_SPIN * 5
  l_32_0.sentry_gun.MAX_VEL_PITCH = 100
  l_32_0.sentry_gun.MIN_VEL_PITCH = l_32_0.sentry_gun.MAX_VEL_PITCH * 0.050000000745058
  l_32_0.sentry_gun.SLOWDOWN_ANGLE_PITCH = 20
  l_32_0.sentry_gun.ACC_PITCH = l_32_0.sentry_gun.MAX_VEL_PITCH * 5
  l_32_0.sentry_gun.recoil = {}
  l_32_0.sentry_gun.recoil.horizontal = {2, 3, 0, 3}
  l_32_0.sentry_gun.recoil.vertical = {1, 2, 0, 4}
  l_32_0.sentry_gun.challenges = {}
  l_32_0.sentry_gun.challenges.group = "sentry_gun"
  l_32_0.sentry_gun.challenges.weapon = "sentry_gun"
  l_32_0.sentry_gun.suppression = 0.80000001192093
end

WeaponTweakData._init_data_player_weapons = function(l_33_0)
  local autohit_rifle_default, autohit_pistol_default, autohit_shotgun_default, aim_assist_rifle_default, aim_assist_pistol_default, aim_assist_shotgun_default = nil, nil, nil, nil, nil, nil
  if SystemInfo:platform() == Idstring("WIN32") then
    autohit_rifle_default = {MIN_RATIO = 0.75, MAX_RATIO = 0.85000002384186, INIT_RATIO = 0.15000000596046, far_dis = 5000, far_angle = 1.5, near_angle = 3}
    autohit_pistol_default = {MIN_RATIO = 0.81999999284744, MAX_RATIO = 0.94999998807907, INIT_RATIO = 0.15000000596046, far_dis = 5000, far_angle = 1.5, near_angle = 3}
    autohit_shotgun_default = {MIN_RATIO = 0.60000002384186, MAX_RATIO = 0.69999998807907, INIT_RATIO = 0.15000000596046, far_dis = 5000, far_angle = 1.5, near_angle = 3}
  else
    autohit_rifle_default = {MIN_RATIO = 0.25, MAX_RATIO = 0.60000002384186, INIT_RATIO = 0.60000002384186, far_dis = 5000, far_angle = 3, near_angle = 3}
    autohit_pistol_default = {MIN_RATIO = 0.25, MAX_RATIO = 0.60000002384186, INIT_RATIO = 0.60000002384186, far_dis = 2500, far_angle = 3, near_angle = 3}
    autohit_shotgun_default = {MIN_RATIO = 0.15000000596046, MAX_RATIO = 0.30000001192093, INIT_RATIO = 0.30000001192093, far_dis = 5000, far_angle = 5, near_angle = 3}
  end
  aim_assist_rifle_default = deep_clone(autohit_rifle_default)
  aim_assist_pistol_default = deep_clone(autohit_pistol_default)
  aim_assist_shotgun_default = deep_clone(autohit_shotgun_default)
  aim_assist_rifle_default.near_angle = 40
  aim_assist_pistol_default.near_angle = 40
  aim_assist_shotgun_default.near_angle = 40
  l_33_0.crosshair = {}
  l_33_0.crosshair.MIN_OFFSET = 18
  l_33_0.crosshair.MAX_OFFSET = 150
  l_33_0.crosshair.MIN_KICK_OFFSET = 0
  l_33_0.crosshair.MAX_KICK_OFFSET = 100
  l_33_0.crosshair.DEFAULT_OFFSET = 0.15999999642372
  l_33_0.crosshair.DEFAULT_KICK_OFFSET = 0.60000002384186
  local damage_melee_default = 1.5
  local damage_melee_effect_multiplier_default = 1.75
  l_33_0.trip_mines = {}
  l_33_0.trip_mines.delay = 0.30000001192093
  l_33_0.trip_mines.damage = 100
  l_33_0.trip_mines.damage_size = 300
  l_33_0.trip_mines.alert_radius = 5000
  l_33_0:_init_stats()
  l_33_0.factory = WeaponFactoryTweakData:new()
  l_33_0:_init_new_weapons(autohit_rifle_default, autohit_pistol_default, autohit_shotgun_default, damage_melee_default, damage_melee_effect_multiplier_default, aim_assist_rifle_default, aim_assist_pistol_default, aim_assist_shotgun_default)
end

WeaponTweakData._init_stats = function(l_34_0)
  l_34_0.stats = {}
  l_34_0.stats.alert_size = {30000, 20000, 15000, 10000, 7500, 6000, 4500, 4000, 3500, 1800, 1500, 1200, 1000, 900, 800, 700, 600, 500, 400, 200}
  l_34_0.stats.suppression = {4.5, 3.9000000953674, 3.5999999046326, 3.2999999523163, 3, 2.7999999523163, 2.5999999046326, 2.4000000953674, 2.2000000476837, 1.6000000238419, 1.5, 1.3999999761581, 1.2999999523163, 1.2000000476837, 1.1000000238419, 1, 0.80000001192093, 0.60000002384186, 0.40000000596046, 0.20000000298023}
  l_34_0.stats.damage = {1, 1.1000000238419, 1.2000000476837, 1.2999999523163, 1.3999999761581, 1.5, 1.6000000238419, 1.75, 2, 2.25, 2.5, 2.75, 3, 3.25, 3.5, 3.75, 4, 4.25, 4.5, 4.75, 5, 5.5, 6, 6.5, 7, 7.5, 8, 8.5, 9, 9.5, 10, 10.5, 11, 11.5, 12}
  l_34_0.stats.zoom = {63, 60, 55, 50, 45, 40, 35, 30, 25, 20}
  l_34_0.stats.spread = {2, 1.7999999523163, 1.6000000238419, 1.3999999761581, 1.2000000476837, 1, 0.80000001192093, 0.60000002384186, 0.40000000596046, 0.20000000298023}
  l_34_0.stats.spread_moving = {3, 2.7000000476837, 2.4000000953674, 2.2000000476837, 2, 1.7000000476837, 1.3999999761581, 1.2000000476837, 1, 0.89999997615814, 0.80000001192093, 0.69999998807907, 0.60000002384186, 0.5}
  l_34_0.stats.recoil = {3, 2.7000000476837, 2.4000000953674, 2.2000000476837, 2, 1.7000000476837, 1.3999999761581, 1.2000000476837, 1, 0.89999997615814, 0.80000001192093, 0.69999998807907, 0.60000002384186, 0.5}
  l_34_0.stats.value = {1, 2, 3, 4, 5, 6, 7, 8, 9, 10}
  l_34_0.stats.concealment = {0.5, 0.5, 0.75, 0.75, 0.75, 0.75, 0.75, 0.75, 0.75, 1.1499999761581, 1.1499999761581, 1.1499999761581, 1.1499999761581, 1.1499999761581, 1.1499999761581, 1.1499999761581, 1.1499999761581, 1.1499999761581, 1.1499999761581, 1.1499999761581, 1.3500000238419, 1.3500000238419, 1.3500000238419, 1.3500000238419, 1.3500000238419, 1.3500000238419, 1.3500000238419, 1.3500000238419, 1.5, 1.5}
  l_34_0.stats.extra_ammo = {}
  for i = -10, 50, 2 do
    table.insert(l_34_0.stats.extra_ammo, i)
  end
end

WeaponTweakData._pickup_chance = function(l_35_0, l_35_1, l_35_2)
   -- DECOMPILER ERROR: Confused at declaration of local variable

  if l_35_2 == 2 then
    do return end
  end
   -- DECOMPILER ERROR: Overwrote pending register.

   -- DECOMPILER ERROR: Overwrote pending register.

  return {l_35_1 * 0.019999999552965, l_35_1 * 0.050000000745058}
   -- DECOMPILER ERROR: Confused about usage of registers for local variables.

end

WeaponTweakData._init_new_weapons = function(l_36_0, l_36_1, l_36_2, l_36_3, l_36_4, l_36_5, l_36_6, l_36_7, l_36_8)
  local total_damage_primary = 300
  local total_damage_secondary = 150
  l_36_0.new_m4 = {}
  l_36_0.new_m4.category = "assault_rifle"
  l_36_0.new_m4.damage_melee = l_36_4
  l_36_0.new_m4.damage_melee_effect_mul = l_36_5
  l_36_0.new_m4.sounds = {}
  l_36_0.new_m4.sounds.fire = "m4_fire"
  l_36_0.new_m4.sounds.stop_fire = "m4_stop"
  l_36_0.new_m4.sounds.dryfire = "m4_dryfire"
  l_36_0.new_m4.sounds.enter_steelsight = "m4_tighten"
  l_36_0.new_m4.sounds.enter_steelsight = "primary_steel_sight_enter"
  l_36_0.new_m4.sounds.leave_steelsight = "primary_steel_sight_exit"
  l_36_0.new_m4.timers = {}
  l_36_0.new_m4.timers.reload_not_empty = 2.25
  l_36_0.new_m4.timers.reload_empty = 3
  l_36_0.new_m4.timers.unequip = 0.69999998807907
  l_36_0.new_m4.timers.equip = 0.66000002622604
  l_36_0.new_m4.name_id = "bm_w_m4"
  l_36_0.new_m4.desc_id = "bm_w_m4_desc"
  l_36_0.new_m4.hud_icon = "m4"
  l_36_0.new_m4.description_id = "des_m4"
  l_36_0.new_m4.muzzleflash = "effects/payday2/particles/weapons/556_auto_fps"
  l_36_0.new_m4.shell_ejection = "effects/payday2/particles/weapons/shells/shell_556"
  l_36_0.new_m4.use_data = {}
  l_36_0.new_m4.use_data.selection_index = 2
  l_36_0.new_m4.DAMAGE = 2.25
  l_36_0.new_m4.CLIP_AMMO_MAX = 30
  l_36_0.new_m4.NR_CLIPS_MAX = math.round(total_damage_primary / 2 / l_36_0.new_m4.CLIP_AMMO_MAX)
  l_36_0.new_m4.AMMO_MAX = l_36_0.new_m4.CLIP_AMMO_MAX * l_36_0.new_m4.NR_CLIPS_MAX
  l_36_0.new_m4.AMMO_PICKUP = l_36_0:_pickup_chance(l_36_0.new_m4.AMMO_MAX, 2)
  l_36_0.new_m4.auto = {}
  l_36_0.new_m4.auto.fire_rate = 0.10999999940395
  l_36_0.new_m4.spread = {}
  l_36_0.new_m4.spread.standing = 3.5
  l_36_0.new_m4.spread.crouching = l_36_0.new_m4.spread.standing
  l_36_0.new_m4.spread.steelsight = 1
  l_36_0.new_m4.spread.moving_standing = l_36_0.new_m4.spread.standing
  l_36_0.new_m4.spread.moving_crouching = l_36_0.new_m4.spread.standing
  l_36_0.new_m4.spread.moving_steelsight = l_36_0.new_m4.spread.steelsight * 2
  l_36_0.new_m4.kick = {}
  l_36_0.new_m4.kick.standing = {0.89999997615814, 1, -1, 1}
  l_36_0.new_m4.kick.crouching = l_36_0.new_m4.kick.standing
  l_36_0.new_m4.kick.steelsight = l_36_0.new_m4.kick.standing
  l_36_0.new_m4.shake = {}
  l_36_0.new_m4.shake.fire_multiplier = 1
  l_36_0.new_m4.shake.fire_steelsight_multiplier = -1
  l_36_0.new_m4.autohit = l_36_1
  l_36_0.new_m4.aim_assist = l_36_6
  l_36_0.new_m4.animations = {}
  l_36_0.new_m4.animations.reload = "reload"
  l_36_0.new_m4.animations.reload_not_empty = "reload_not_empty"
  l_36_0.new_m4.animations.equip_id = "equip_m4"
  l_36_0.new_m4.animations.recoil_steelsight = false
  l_36_0.new_m4.transition_duration = 0.019999999552965
   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

  l_36_0.new_m4.stats, {damage = 10, spread = 6}.value, {damage = 10, spread = 6}.extra_ammo, {damage = 10, spread = 6}.suppression, {damage = 10, spread = 6}.concealment, {damage = 10, spread = 6}.zoom, {damage = 10, spread = 6}.spread_moving, {damage = 10, spread = 6}.recoil = {damage = 10, spread = 6}, 1, 6, 7, 24, 3, 7, 10
  l_36_0.glock_17 = {}
  l_36_0.glock_17.category = "pistol"
  l_36_0.glock_17.damage_melee = l_36_4
  l_36_0.glock_17.damage_melee_effect_mul = l_36_5
  l_36_0.glock_17.sounds = {}
  l_36_0.glock_17.sounds.fire = "g17_fire"
  l_36_0.glock_17.sounds.dryfire = "g17_dryfire"
  l_36_0.glock_17.sounds.enter_steelsight = "pistol_steel_sight_enter"
  l_36_0.glock_17.sounds.leave_steelsight = "pistol_steel_sight_exit"
  l_36_0.glock_17.single = {}
  l_36_0.glock_17.single.fire_rate = 0.11999999731779
  l_36_0.glock_17.timers = {}
  l_36_0.glock_17.timers.reload_not_empty = 1.4700000286102
  l_36_0.glock_17.timers.reload_empty = 2.1199998855591
  l_36_0.glock_17.timers.unequip = 0.5
  l_36_0.glock_17.timers.equip = 0.5
  l_36_0.glock_17.name_id = "bm_w_glock_17"
  l_36_0.glock_17.desc_id = "bm_w_glock_17_desc"
  l_36_0.glock_17.hud_icon = "c45"
  l_36_0.glock_17.description_id = "des_glock_17"
  l_36_0.glock_17.hud_ammo = "guis/textures/ammo_9mm"
  l_36_0.glock_17.muzzleflash = "effects/payday2/particles/weapons/9mm_auto_fps"
  l_36_0.glock_17.muzzleflash_silenced = "effects/payday2/particles/weapons/9mm_auto_silence_fps"
  l_36_0.glock_17.shell_ejection = "effects/payday2/particles/weapons/shells/shell_9mm"
  l_36_0.glock_17.use_data = {}
  l_36_0.glock_17.use_data.selection_index = 1
  l_36_0.glock_17.DAMAGE = 1
  l_36_0.glock_17.CLIP_AMMO_MAX = 17
  l_36_0.glock_17.NR_CLIPS_MAX = math.round(total_damage_secondary / 1.1499999761581 / l_36_0.glock_17.CLIP_AMMO_MAX)
  l_36_0.glock_17.AMMO_MAX = l_36_0.glock_17.CLIP_AMMO_MAX * l_36_0.glock_17.NR_CLIPS_MAX
  l_36_0.glock_17.AMMO_PICKUP = l_36_0:_pickup_chance(l_36_0.glock_17.AMMO_MAX, 1)
  l_36_0.glock_17.spread = {}
  l_36_0.glock_17.spread.standing = l_36_0.new_m4.spread.standing * 0.75
  l_36_0.glock_17.spread.crouching = l_36_0.new_m4.spread.standing * 0.75
  l_36_0.glock_17.spread.steelsight = l_36_0.new_m4.spread.steelsight
  l_36_0.glock_17.spread.moving_standing = l_36_0.new_m4.spread.standing * 0.75
  l_36_0.glock_17.spread.moving_crouching = l_36_0.new_m4.spread.standing * 0.75
  l_36_0.glock_17.spread.moving_steelsight = l_36_0.new_m4.spread.moving_steelsight
  l_36_0.glock_17.kick = {}
  l_36_0.glock_17.kick.standing = {1.2000000476837, 1.7999999523163, -0.5, 0.5}
  l_36_0.glock_17.kick.crouching = l_36_0.glock_17.kick.standing
  l_36_0.glock_17.kick.steelsight = l_36_0.glock_17.kick.standing
  l_36_0.glock_17.crosshair = {}
  l_36_0.glock_17.crosshair.standing = {}
  l_36_0.glock_17.crosshair.crouching = {}
  l_36_0.glock_17.crosshair.steelsight = {}
  l_36_0.glock_17.crosshair.standing.offset = 0.17499999701977
  l_36_0.glock_17.crosshair.standing.moving_offset = 0.60000002384186
  l_36_0.glock_17.crosshair.standing.kick_offset = 0.40000000596046
  l_36_0.glock_17.crosshair.crouching.offset = 0.10000000149012
  l_36_0.glock_17.crosshair.crouching.moving_offset = 0.60000002384186
  l_36_0.glock_17.crosshair.crouching.kick_offset = 0.30000001192093
  l_36_0.glock_17.crosshair.steelsight.hidden = true
  l_36_0.glock_17.crosshair.steelsight.offset = 0
  l_36_0.glock_17.crosshair.steelsight.moving_offset = 0
  l_36_0.glock_17.crosshair.steelsight.kick_offset = 0.10000000149012
  l_36_0.glock_17.shake = {}
  l_36_0.glock_17.shake.fire_multiplier = 1
  l_36_0.glock_17.shake.fire_steelsight_multiplier = 1
  l_36_0.glock_17.autohit = l_36_2
  l_36_0.glock_17.aim_assist = l_36_7
  l_36_0.glock_17.weapon_hold = "glock"
  l_36_0.glock_17.animations = {}
  l_36_0.glock_17.animations.equip_id = "equip_glock"
  l_36_0.glock_17.animations.recoil_steelsight = true
  l_36_0.glock_17.transition_duration = 0
   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

  l_36_0.glock_17.stats, {damage = 4, spread = 3}.value, {damage = 4, spread = 3}.extra_ammo, {damage = 4, spread = 3}.suppression, {damage = 4, spread = 3}.concealment, {damage = 4, spread = 3}.zoom, {damage = 4, spread = 3}.spread_moving, {damage = 4, spread = 3}.recoil = {damage = 4, spread = 3}, 1, 6, 7, 30, 1, 7, 4
  l_36_0.mp9 = {}
  l_36_0.mp9.category = "smg"
  l_36_0.mp9.damage_melee = l_36_4
  l_36_0.mp9.damage_melee_effect_mul = l_36_5
  l_36_0.mp9.sounds = {}
  l_36_0.mp9.sounds.fire = "mp9_fire"
  l_36_0.mp9.sounds.stop_fire = "mp9_stop"
  l_36_0.mp9.sounds.dryfire = "mk11_dryfire"
  l_36_0.mp9.sounds.enter_steelsight = "secondary_steel_sight_enter"
  l_36_0.mp9.sounds.leave_steelsight = "secondary_steel_sight_exit"
  l_36_0.mp9.timers = {}
  l_36_0.mp9.timers.reload_not_empty = 1.7000000476837
  l_36_0.mp9.timers.reload_empty = 2.5999999046326
  l_36_0.mp9.timers.unequip = 0.75
  l_36_0.mp9.timers.equip = 0.5
  l_36_0.mp9.name_id = "bm_w_mp9"
  l_36_0.mp9.desc_id = "bm_w_mp9_desc"
  l_36_0.mp9.hud_icon = "mac11"
  l_36_0.mp9.description_id = "des_mp9"
  l_36_0.mp9.hud_ammo = "guis/textures/ammo_small_9mm"
  l_36_0.mp9.muzzleflash = "effects/payday2/particles/weapons/9mm_auto_fps"
  l_36_0.mp9.muzzleflash_silenced = "effects/payday2/particles/weapons/9mm_auto_silence_fps"
  l_36_0.mp9.shell_ejection = "effects/payday2/particles/weapons/shells/shell_9mm"
  l_36_0.mp9.use_data = {}
  l_36_0.mp9.use_data.selection_index = 1
  l_36_0.mp9.DAMAGE = 1
  l_36_0.mp9.CLIP_AMMO_MAX = 30
  l_36_0.mp9.NR_CLIPS_MAX = math.round(total_damage_secondary / 1.1499999761581 / l_36_0.mp9.CLIP_AMMO_MAX)
  l_36_0.mp9.AMMO_MAX = l_36_0.mp9.CLIP_AMMO_MAX * l_36_0.mp9.NR_CLIPS_MAX
  l_36_0.mp9.AMMO_PICKUP = l_36_0:_pickup_chance(l_36_0.mp9.AMMO_MAX, 1)
  l_36_0.mp9.auto = {}
  l_36_0.mp9.auto.fire_rate = 0.070000000298023
  l_36_0.mp9.spread = {}
  l_36_0.mp9.spread.standing = l_36_0.new_m4.spread.standing * 0.75
  l_36_0.mp9.spread.crouching = l_36_0.new_m4.spread.standing * 0.75
  l_36_0.mp9.spread.steelsight = l_36_0.new_m4.spread.steelsight
  l_36_0.mp9.spread.moving_standing = l_36_0.new_m4.spread.standing * 0.75
  l_36_0.mp9.spread.moving_crouching = l_36_0.new_m4.spread.standing * 0.75
  l_36_0.mp9.spread.moving_steelsight = l_36_0.new_m4.spread.moving_steelsight
  l_36_0.mp9.kick = {}
  l_36_0.mp9.kick.standing = {-1.2000000476837, 1.2000000476837, -1, 1}
  l_36_0.mp9.kick.crouching = l_36_0.mp9.kick.standing
  l_36_0.mp9.kick.steelsight = l_36_0.mp9.kick.standing
  l_36_0.mp9.crosshair = {}
  l_36_0.mp9.crosshair.standing = {}
  l_36_0.mp9.crosshair.crouching = {}
  l_36_0.mp9.crosshair.steelsight = {}
  l_36_0.mp9.crosshair.standing.offset = 0.40000000596046
  l_36_0.mp9.crosshair.standing.moving_offset = 0.69999998807907
  l_36_0.mp9.crosshair.standing.kick_offset = 0.60000002384186
  l_36_0.mp9.crosshair.crouching.offset = 0.30000001192093
  l_36_0.mp9.crosshair.crouching.moving_offset = 0.60000002384186
  l_36_0.mp9.crosshair.crouching.kick_offset = 0.40000000596046
  l_36_0.mp9.crosshair.steelsight.hidden = true
  l_36_0.mp9.crosshair.steelsight.offset = 0
  l_36_0.mp9.crosshair.steelsight.moving_offset = 0
  l_36_0.mp9.crosshair.steelsight.kick_offset = 0.40000000596046
  l_36_0.mp9.shake = {}
  l_36_0.mp9.shake.fire_multiplier = 1
  l_36_0.mp9.shake.fire_steelsight_multiplier = -1
  l_36_0.mp9.autohit = l_36_2
  l_36_0.mp9.aim_assist = l_36_7
  l_36_0.mp9.weapon_hold = "mac11"
  l_36_0.mp9.animations = {}
  l_36_0.mp9.animations.equip_id = "equip_mac11_rifle"
  l_36_0.mp9.animations.recoil_steelsight = false
   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

  l_36_0.mp9.stats, {damage = 5, spread = 2}.value, {damage = 5, spread = 2}.extra_ammo, {damage = 5, spread = 2}.suppression, {damage = 5, spread = 2}.concealment, {damage = 5, spread = 2}.zoom, {damage = 5, spread = 2}.spread_moving, {damage = 5, spread = 2}.recoil = {damage = 5, spread = 2}, 1, 6, 7, 27, 3, 7, 6
  l_36_0.r870 = {}
  l_36_0.r870.category = "shotgun"
  l_36_0.r870.damage_melee = l_36_4
  l_36_0.r870.damage_melee_effect_mul = l_36_5
  l_36_0.r870.sounds = {}
  l_36_0.r870.sounds.fire = "remington_fire"
  l_36_0.r870.sounds.dryfire = "remington_dryfire"
  l_36_0.r870.sounds.enter_steelsight = "primary_steel_sight_enter"
  l_36_0.r870.sounds.leave_steelsight = "primary_steel_sight_exit"
  l_36_0.r870.timers = {}
  l_36_0.r870.timers.unequip = 0.69999998807907
  l_36_0.r870.timers.equip = 0.60000002384186
  l_36_0.r870.name_id = "bm_w_r870"
  l_36_0.r870.desc_id = "bm_w_r870_desc"
  l_36_0.r870.hud_icon = "r870_shotgun"
  l_36_0.r870.description_id = "des_r870"
  l_36_0.r870.hud_ammo = "guis/textures/ammo_shell"
  l_36_0.r870.muzzleflash = "effects/payday2/particles/weapons/762_auto_fps"
  l_36_0.r870.shell_ejection = "effects/payday2/particles/weapons/shells/shell_slug_semi"
  l_36_0.r870.use_data = {}
  l_36_0.r870.use_data.selection_index = 2
  l_36_0.r870.use_data.align_place = "right_hand"
  l_36_0.r870.DAMAGE = 6
  l_36_0.r870.damage_near = 700
  l_36_0.r870.damage_far = 2000
  l_36_0.r870.rays = 5
  l_36_0.r870.CLIP_AMMO_MAX = 6
  l_36_0.r870.NR_CLIPS_MAX = math.round(total_damage_primary / 6.5 / l_36_0.r870.CLIP_AMMO_MAX)
  l_36_0.r870.AMMO_MAX = l_36_0.r870.CLIP_AMMO_MAX * l_36_0.r870.NR_CLIPS_MAX
  l_36_0.r870.AMMO_PICKUP = l_36_0:_pickup_chance(l_36_0.r870.AMMO_MAX, 2)
  l_36_0.r870.single = {}
  l_36_0.r870.single.fire_rate = 0.57499998807907
  l_36_0.r870.spread = {}
  l_36_0.r870.spread.standing = l_36_0.new_m4.spread.standing * 1
  l_36_0.r870.spread.crouching = l_36_0.new_m4.spread.standing * 1
  l_36_0.r870.spread.steelsight = l_36_0.new_m4.spread.standing * 0.80000001192093
  l_36_0.r870.spread.moving_standing = l_36_0.new_m4.spread.standing * 1
  l_36_0.r870.spread.moving_crouching = l_36_0.new_m4.spread.standing * 1
  l_36_0.r870.spread.moving_steelsight = l_36_0.new_m4.spread.standing * 0.80000001192093
  l_36_0.r870.kick = {}
  l_36_0.r870.kick.standing = {1.8999999761581, 2, -0.20000000298023, 0.20000000298023}
  l_36_0.r870.kick.crouching = l_36_0.r870.kick.standing
  l_36_0.r870.kick.steelsight = {1.5, 1.7000000476837, -0.20000000298023, 0.20000000298023}
  l_36_0.r870.crosshair = {}
  l_36_0.r870.crosshair.standing = {}
  l_36_0.r870.crosshair.crouching = {}
  l_36_0.r870.crosshair.steelsight = {}
  l_36_0.r870.crosshair.standing.offset = 0.69999998807907
  l_36_0.r870.crosshair.standing.moving_offset = 0.69999998807907
  l_36_0.r870.crosshair.standing.kick_offset = 0.80000001192093
  l_36_0.r870.crosshair.crouching.offset = 0.64999997615814
  l_36_0.r870.crosshair.crouching.moving_offset = 0.64999997615814
  l_36_0.r870.crosshair.crouching.kick_offset = 0.75
  l_36_0.r870.crosshair.steelsight.hidden = true
  l_36_0.r870.crosshair.steelsight.offset = 0
  l_36_0.r870.crosshair.steelsight.moving_offset = 0
  l_36_0.r870.crosshair.steelsight.kick_offset = 0
  l_36_0.r870.shake = {}
  l_36_0.r870.shake.fire_multiplier = 1
  l_36_0.r870.shake.fire_steelsight_multiplier = -1
  l_36_0.r870.autohit = l_36_3
  l_36_0.r870.aim_assist = l_36_8
  l_36_0.r870.weapon_hold = "r870_shotgun"
  l_36_0.r870.animations = {}
  l_36_0.r870.animations.equip_id = "equip_r870_shotgun"
  l_36_0.r870.animations.recoil_steelsight = true
   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

  l_36_0.r870.stats, {damage = 24, spread = 7}.value, {damage = 24, spread = 7}.extra_ammo, {damage = 24, spread = 7}.suppression, {damage = 24, spread = 7}.concealment, {damage = 24, spread = 7}.zoom, {damage = 24, spread = 7}.spread_moving, {damage = 24, spread = 7}.recoil = {damage = 24, spread = 7}, 1, 6, 7, 21, 3, 7, 3
  l_36_0.glock_18c = {}
  l_36_0.glock_18c.category = "pistol"
  l_36_0.glock_18c.damage_melee = l_36_4
  l_36_0.glock_18c.damage_melee_effect_mul = l_36_5
  l_36_0.glock_18c.sounds = {}
  l_36_0.glock_18c.sounds.fire = "g18c_fire"
  l_36_0.glock_18c.sounds.stop_fire = "g18c_stop"
  l_36_0.glock_18c.sounds.dryfire = "stryk_dryfire"
  l_36_0.glock_18c.sounds.enter_steelsight = "pistol_steel_sight_enter"
  l_36_0.glock_18c.sounds.leave_steelsight = "pistol_steel_sight_exit"
  l_36_0.glock_18c.timers = {}
  l_36_0.glock_18c.timers.reload_not_empty = 1.4700000286102
  l_36_0.glock_18c.timers.reload_empty = 2.1199998855591
  l_36_0.glock_18c.timers.unequip = 0.55000001192093
  l_36_0.glock_18c.timers.equip = 0.55000001192093
  l_36_0.glock_18c.name_id = "bm_w_glock_18c"
  l_36_0.glock_18c.desc_id = "bm_w_glock_18c_desc"
  l_36_0.glock_18c.hud_icon = "glock"
  l_36_0.glock_18c.description_id = "des_glock"
  l_36_0.glock_18c.hud_ammo = "guis/textures/ammo_small_9mm"
  l_36_0.glock_18c.muzzleflash = "effects/payday2/particles/weapons/9mm_auto_fps"
  l_36_0.glock_18c.muzzleflash_silenced = "effects/payday2/particles/weapons/9mm_auto_silence_fps"
  l_36_0.glock_18c.shell_ejection = "effects/payday2/particles/weapons/shells/shell_9mm"
  l_36_0.glock_18c.use_data = {}
  l_36_0.glock_18c.use_data.selection_index = 1
  l_36_0.glock_18c.DAMAGE = 1
  l_36_0.glock_18c.CLIP_AMMO_MAX = 20
  l_36_0.glock_18c.NR_CLIPS_MAX = math.round(total_damage_secondary / 1.1499999761581 / l_36_0.glock_18c.CLIP_AMMO_MAX)
  l_36_0.glock_18c.AMMO_MAX = l_36_0.glock_18c.CLIP_AMMO_MAX * l_36_0.glock_18c.NR_CLIPS_MAX
  l_36_0.glock_18c.AMMO_PICKUP = l_36_0:_pickup_chance(l_36_0.glock_18c.AMMO_MAX, 1)
  l_36_0.glock_18c.auto = {}
  l_36_0.glock_18c.auto.fire_rate = 0.054999999701977
  l_36_0.glock_18c.spread = {}
  l_36_0.glock_18c.spread.standing = l_36_0.new_m4.spread.standing * 0.75
  l_36_0.glock_18c.spread.crouching = l_36_0.new_m4.spread.standing * 0.75
  l_36_0.glock_18c.spread.steelsight = l_36_0.new_m4.spread.steelsight
  l_36_0.glock_18c.spread.moving_standing = l_36_0.new_m4.spread.standing * 0.75
  l_36_0.glock_18c.spread.moving_crouching = l_36_0.new_m4.spread.standing * 0.75
  l_36_0.glock_18c.spread.moving_steelsight = l_36_0.new_m4.spread.moving_steelsight
  l_36_0.glock_18c.kick = {}
  l_36_0.glock_18c.kick.standing = l_36_0.glock_17.kick.standing
  l_36_0.glock_18c.kick.crouching = l_36_0.glock_18c.kick.standing
  l_36_0.glock_18c.kick.steelsight = l_36_0.glock_18c.kick.standing
  l_36_0.glock_18c.crosshair = {}
  l_36_0.glock_18c.crosshair.standing = {}
  l_36_0.glock_18c.crosshair.crouching = {}
  l_36_0.glock_18c.crosshair.steelsight = {}
  l_36_0.glock_18c.crosshair.standing.offset = 0.30000001192093
  l_36_0.glock_18c.crosshair.standing.moving_offset = 0.5
  l_36_0.glock_18c.crosshair.standing.kick_offset = 0.60000002384186
  l_36_0.glock_18c.crosshair.crouching.offset = 0.20000000298023
  l_36_0.glock_18c.crosshair.crouching.moving_offset = 0.5
  l_36_0.glock_18c.crosshair.crouching.kick_offset = 0.30000001192093
  l_36_0.glock_18c.crosshair.steelsight.hidden = true
  l_36_0.glock_18c.crosshair.steelsight.offset = 0.20000000298023
  l_36_0.glock_18c.crosshair.steelsight.moving_offset = 0.20000000298023
  l_36_0.glock_18c.crosshair.steelsight.kick_offset = 0.30000001192093
  l_36_0.glock_18c.shake = {}
  l_36_0.glock_18c.shake.fire_multiplier = 1
  l_36_0.glock_18c.shake.fire_steelsight_multiplier = 1
  l_36_0.glock_18c.autohit = l_36_2
  l_36_0.glock_18c.aim_assist = l_36_7
  l_36_0.glock_18c.weapon_hold = "glock"
  l_36_0.glock_18c.animations = {}
  l_36_0.glock_18c.animations.fire = "recoil"
  l_36_0.glock_18c.animations.reload = "reload"
  l_36_0.glock_18c.animations.reload_not_empty = "reload_not_empty"
  l_36_0.glock_18c.animations.equip_id = "equip_glock"
  l_36_0.glock_18c.animations.recoil_steelsight = true
  l_36_0.glock_18c.challenges = {}
  l_36_0.glock_18c.challenges.group = "handgun"
  l_36_0.glock_18c.challenges.weapon = "glock"
  l_36_0.glock_18c.transition_duration = 0
   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

  l_36_0.glock_18c.stats, {damage = 5, spread = 3}.value, {damage = 5, spread = 3}.extra_ammo, {damage = 5, spread = 3}.suppression, {damage = 5, spread = 3}.concealment, {damage = 5, spread = 3}.zoom, {damage = 5, spread = 3}.spread_moving, {damage = 5, spread = 3}.recoil = {damage = 5, spread = 3}, 1, 6, 7, 30, 1, 7, 6
  l_36_0.amcar = {}
  l_36_0.amcar.category = "assault_rifle"
  l_36_0.amcar.damage_melee = l_36_4
  l_36_0.amcar.damage_melee_effect_mul = l_36_5
  l_36_0.amcar.sounds = {}
  l_36_0.amcar.sounds.fire = "amcar_fire"
  l_36_0.amcar.sounds.stop_fire = "amcar_stop"
  l_36_0.amcar.sounds.dryfire = "m4_dryfire"
  l_36_0.amcar.sounds.enter_steelsight = "m4_tighten"
  l_36_0.amcar.sounds.enter_steelsight = "primary_steel_sight_enter"
  l_36_0.amcar.sounds.leave_steelsight = "primary_steel_sight_exit"
  l_36_0.amcar.timers = {}
  l_36_0.amcar.timers.reload_not_empty = 2.25
  l_36_0.amcar.timers.reload_empty = 3
  l_36_0.amcar.timers.unequip = 0.80000001192093
  l_36_0.amcar.timers.equip = 0.69999998807907
  l_36_0.amcar.name_id = "bm_w_amcar"
  l_36_0.amcar.desc_id = "bm_w_amcar_desc"
  l_36_0.amcar.hud_icon = "m4"
  l_36_0.amcar.description_id = "des_m4"
  l_36_0.amcar.muzzleflash = "effects/payday2/particles/weapons/556_auto_fps"
  l_36_0.amcar.shell_ejection = "effects/payday2/particles/weapons/shells/shell_556"
  l_36_0.amcar.use_data = {}
  l_36_0.amcar.use_data.selection_index = 2
  l_36_0.amcar.DAMAGE = 1
  l_36_0.amcar.CLIP_AMMO_MAX = 20
  l_36_0.amcar.NR_CLIPS_MAX = math.round(total_damage_primary / 1.6000000238419 / l_36_0.amcar.CLIP_AMMO_MAX)
  l_36_0.amcar.AMMO_MAX = l_36_0.amcar.CLIP_AMMO_MAX * l_36_0.amcar.NR_CLIPS_MAX
  l_36_0.amcar.AMMO_PICKUP = l_36_0:_pickup_chance(l_36_0.amcar.AMMO_MAX, 2)
  l_36_0.amcar.auto = {}
  l_36_0.amcar.auto.fire_rate = 0.10999999940395
  l_36_0.amcar.spread = {}
  l_36_0.amcar.spread.standing = l_36_0.new_m4.spread.standing
  l_36_0.amcar.spread.crouching = l_36_0.new_m4.spread.standing
  l_36_0.amcar.spread.steelsight = l_36_0.new_m4.spread.steelsight
  l_36_0.amcar.spread.moving_standing = l_36_0.new_m4.spread.standing
  l_36_0.amcar.spread.moving_crouching = l_36_0.new_m4.spread.standing
  l_36_0.amcar.spread.moving_steelsight = l_36_0.new_m4.spread.moving_steelsight
  l_36_0.amcar.kick = {}
  l_36_0.amcar.kick.standing = l_36_0.new_m4.kick.standing
  l_36_0.amcar.kick.crouching = l_36_0.amcar.kick.standing
  l_36_0.amcar.kick.steelsight = l_36_0.amcar.kick.standing
  l_36_0.amcar.crosshair = {}
  l_36_0.amcar.crosshair.standing = {}
  l_36_0.amcar.crosshair.crouching = {}
  l_36_0.amcar.crosshair.steelsight = {}
  l_36_0.amcar.crosshair.standing.offset = 0.15999999642372
  l_36_0.amcar.crosshair.standing.moving_offset = 0.80000001192093
  l_36_0.amcar.crosshair.standing.kick_offset = 0.60000002384186
  l_36_0.amcar.crosshair.crouching.offset = 0.079999998211861
  l_36_0.amcar.crosshair.crouching.moving_offset = 0.69999998807907
  l_36_0.amcar.crosshair.crouching.kick_offset = 0.40000000596046
  l_36_0.amcar.crosshair.steelsight.hidden = true
  l_36_0.amcar.crosshair.steelsight.offset = 0
  l_36_0.amcar.crosshair.steelsight.moving_offset = 0
  l_36_0.amcar.crosshair.steelsight.kick_offset = 0.10000000149012
  l_36_0.amcar.shake = {}
  l_36_0.amcar.shake.fire_multiplier = 1
  l_36_0.amcar.shake.fire_steelsight_multiplier = -1
  l_36_0.amcar.autohit = l_36_1
  l_36_0.amcar.aim_assist = l_36_6
  l_36_0.amcar.weapon_hold = "m4"
  l_36_0.amcar.animations = {}
  l_36_0.amcar.animations.reload = "reload"
  l_36_0.amcar.animations.reload_not_empty = "reload_not_empty"
  l_36_0.amcar.animations.equip_id = "equip_m4"
  l_36_0.amcar.animations.recoil_steelsight = false
   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

  l_36_0.amcar.stats, {damage = 7, spread = 5}.value, {damage = 7, spread = 5}.extra_ammo, {damage = 7, spread = 5}.suppression, {damage = 7, spread = 5}.concealment, {damage = 7, spread = 5}.zoom, {damage = 7, spread = 5}.spread_moving, {damage = 7, spread = 5}.recoil = {damage = 7, spread = 5}, 1, 6, 7, 24, 3, 7, 8
  l_36_0.m16 = {}
  l_36_0.m16.category = "assault_rifle"
  l_36_0.m16.damage_melee = l_36_4
  l_36_0.m16.damage_melee_effect_mul = l_36_5
  l_36_0.m16.sounds = {}
  l_36_0.m16.sounds.fire = "m16_fire"
  l_36_0.m16.sounds.stop_fire = "m16_stop"
  l_36_0.m16.sounds.dryfire = "m4_dryfire"
  l_36_0.m16.sounds.enter_steelsight = "m4_tighten"
  l_36_0.m16.sounds.enter_steelsight = "primary_steel_sight_enter"
  l_36_0.m16.sounds.leave_steelsight = "primary_steel_sight_exit"
  l_36_0.m16.timers = {}
  l_36_0.m16.timers.reload_not_empty = 2.25
  l_36_0.m16.timers.reload_empty = 3
  l_36_0.m16.timers.unequip = 0.85000002384186
  l_36_0.m16.timers.equip = 0.75
  l_36_0.m16.name_id = "bm_w_m16"
  l_36_0.m16.desc_id = "bm_w_m16_desc"
  l_36_0.m16.hud_icon = "m4"
  l_36_0.m16.description_id = "des_m4"
  l_36_0.m16.muzzleflash = "effects/payday2/particles/weapons/762_auto_fps"
  l_36_0.m16.shell_ejection = "effects/payday2/particles/weapons/shells/shell_556"
  l_36_0.m16.use_data = {}
  l_36_0.m16.use_data.selection_index = 2
  l_36_0.m16.DAMAGE = 1
  l_36_0.m16.CLIP_AMMO_MAX = 30
  l_36_0.m16.NR_CLIPS_MAX = math.round(total_damage_primary / 3 / l_36_0.m16.CLIP_AMMO_MAX)
  l_36_0.m16.AMMO_MAX = l_36_0.m16.CLIP_AMMO_MAX * l_36_0.m16.NR_CLIPS_MAX
  l_36_0.m16.AMMO_PICKUP = l_36_0:_pickup_chance(l_36_0.m16.AMMO_MAX, 2)
  l_36_0.m16.auto = {}
  l_36_0.m16.auto.fire_rate = 0.10000000149012
  l_36_0.m16.spread = {}
  l_36_0.m16.spread.standing = l_36_0.new_m4.spread.standing
  l_36_0.m16.spread.crouching = l_36_0.new_m4.spread.standing
  l_36_0.m16.spread.steelsight = l_36_0.new_m4.spread.steelsight
  l_36_0.m16.spread.moving_standing = l_36_0.new_m4.spread.standing
  l_36_0.m16.spread.moving_crouching = l_36_0.new_m4.spread.standing
  l_36_0.m16.spread.moving_steelsight = l_36_0.new_m4.spread.moving_steelsight
  l_36_0.m16.kick = {}
  l_36_0.m16.kick.standing = l_36_0.new_m4.kick.standing
  l_36_0.m16.kick.crouching = l_36_0.m16.kick.standing
  l_36_0.m16.kick.steelsight = l_36_0.m16.kick.standing
  l_36_0.m16.crosshair = {}
  l_36_0.m16.crosshair.standing = {}
  l_36_0.m16.crosshair.crouching = {}
  l_36_0.m16.crosshair.steelsight = {}
  l_36_0.m16.crosshair.standing.offset = 0.15999999642372
  l_36_0.m16.crosshair.standing.moving_offset = 0.80000001192093
  l_36_0.m16.crosshair.standing.kick_offset = 0.60000002384186
  l_36_0.m16.crosshair.crouching.offset = 0.079999998211861
  l_36_0.m16.crosshair.crouching.moving_offset = 0.69999998807907
  l_36_0.m16.crosshair.crouching.kick_offset = 0.40000000596046
  l_36_0.m16.crosshair.steelsight.hidden = true
  l_36_0.m16.crosshair.steelsight.offset = 0
  l_36_0.m16.crosshair.steelsight.moving_offset = 0
  l_36_0.m16.crosshair.steelsight.kick_offset = 0.10000000149012
  l_36_0.m16.shake = {}
  l_36_0.m16.shake.fire_multiplier = 1
  l_36_0.m16.shake.fire_steelsight_multiplier = -1
  l_36_0.m16.autohit = l_36_1
  l_36_0.m16.aim_assist = l_36_6
  l_36_0.m16.weapon_hold = "m4"
  l_36_0.m16.animations = {}
  l_36_0.m16.animations.reload = "reload"
  l_36_0.m16.animations.reload_not_empty = "reload_not_empty"
  l_36_0.m16.animations.equip_id = "equip_m4"
  l_36_0.m16.animations.recoil_steelsight = false
   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

  l_36_0.m16.stats, {damage = 13, spread = 6}.value, {damage = 13, spread = 6}.extra_ammo, {damage = 13, spread = 6}.suppression, {damage = 13, spread = 6}.concealment, {damage = 13, spread = 6}.zoom, {damage = 13, spread = 6}.spread_moving, {damage = 13, spread = 6}.recoil = {damage = 13, spread = 6}, 1, 6, 7, 21, 4, 7, 8
  l_36_0.olympic = {}
  l_36_0.olympic.category = "smg"
  l_36_0.olympic.damage_melee = l_36_4
  l_36_0.olympic.damage_melee_effect_mul = l_36_5
  l_36_0.olympic.sounds = {}
  l_36_0.olympic.sounds.fire = "m4_olympic_fire"
  l_36_0.olympic.sounds.stop_fire = "m4_olympic_stop"
  l_36_0.olympic.sounds.dryfire = "m4_dryfire"
  l_36_0.olympic.sounds.enter_steelsight = "m4_tighten"
  l_36_0.olympic.sounds.enter_steelsight = "primary_steel_sight_enter"
  l_36_0.olympic.sounds.leave_steelsight = "primary_steel_sight_exit"
  l_36_0.olympic.timers = {}
  l_36_0.olympic.timers.reload_not_empty = 2.5350000858307
  l_36_0.olympic.timers.reload_empty = 3.4900000095367
  l_36_0.olympic.timers.unequip = 0.60000002384186
  l_36_0.olympic.timers.equip = 0.5
  l_36_0.olympic.name_id = "bm_w_olympic"
  l_36_0.olympic.desc_id = "bm_w_olympic_desc"
  l_36_0.olympic.hud_icon = "m4"
  l_36_0.olympic.description_id = "des_m4"
  l_36_0.olympic.muzzleflash = "effects/payday2/particles/weapons/556_auto_fps"
  l_36_0.olympic.shell_ejection = "effects/payday2/particles/weapons/shells/shell_556"
  l_36_0.olympic.use_data = {}
  l_36_0.olympic.use_data.selection_index = 1
  l_36_0.olympic.DAMAGE = 1
  l_36_0.olympic.CLIP_AMMO_MAX = 25
  l_36_0.olympic.NR_CLIPS_MAX = math.round(total_damage_secondary / 1.6000000238419 / l_36_0.olympic.CLIP_AMMO_MAX)
  l_36_0.olympic.AMMO_MAX = l_36_0.olympic.CLIP_AMMO_MAX * l_36_0.olympic.NR_CLIPS_MAX
  l_36_0.olympic.AMMO_PICKUP = l_36_0:_pickup_chance(l_36_0.olympic.AMMO_MAX, 1)
  l_36_0.olympic.auto = {}
  l_36_0.olympic.auto.fire_rate = 0.11999999731779
  l_36_0.olympic.spread = {}
  l_36_0.olympic.spread.standing = l_36_0.new_m4.spread.standing * 0.80000001192093
  l_36_0.olympic.spread.crouching = l_36_0.new_m4.spread.standing * 0.80000001192093
  l_36_0.olympic.spread.steelsight = l_36_0.new_m4.spread.steelsight
  l_36_0.olympic.spread.moving_standing = l_36_0.new_m4.spread.standing * 0.80000001192093
  l_36_0.olympic.spread.moving_crouching = l_36_0.new_m4.spread.standing * 0.80000001192093
  l_36_0.olympic.spread.moving_steelsight = l_36_0.new_m4.spread.moving_steelsight
  l_36_0.olympic.kick = {}
  l_36_0.olympic.kick.standing = l_36_0.new_m4.kick.standing
  l_36_0.olympic.kick.crouching = l_36_0.olympic.kick.standing
  l_36_0.olympic.kick.steelsight = l_36_0.olympic.kick.standing
  l_36_0.olympic.crosshair = {}
  l_36_0.olympic.crosshair.standing = {}
  l_36_0.olympic.crosshair.crouching = {}
  l_36_0.olympic.crosshair.steelsight = {}
  l_36_0.olympic.crosshair.standing.offset = 0.15999999642372
  l_36_0.olympic.crosshair.standing.moving_offset = 0.80000001192093
  l_36_0.olympic.crosshair.standing.kick_offset = 0.60000002384186
  l_36_0.olympic.crosshair.crouching.offset = 0.079999998211861
  l_36_0.olympic.crosshair.crouching.moving_offset = 0.69999998807907
  l_36_0.olympic.crosshair.crouching.kick_offset = 0.40000000596046
  l_36_0.olympic.crosshair.steelsight.hidden = true
  l_36_0.olympic.crosshair.steelsight.offset = 0
  l_36_0.olympic.crosshair.steelsight.moving_offset = 0
  l_36_0.olympic.crosshair.steelsight.kick_offset = 0.10000000149012
  l_36_0.olympic.shake = {}
  l_36_0.olympic.shake.fire_multiplier = 1
  l_36_0.olympic.shake.fire_steelsight_multiplier = -1
  l_36_0.olympic.autohit = l_36_1
  l_36_0.olympic.aim_assist = l_36_6
  l_36_0.olympic.weapon_hold = "m4"
  l_36_0.olympic.animations = {}
  l_36_0.olympic.animations.reload = "reload"
  l_36_0.olympic.animations.reload_not_empty = "reload_not_empty"
  l_36_0.olympic.animations.equip_id = "equip_mp5"
  l_36_0.olympic.animations.recoil_steelsight = false
   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

  l_36_0.olympic.stats, {damage = 7, spread = 4}.value, {damage = 7, spread = 4}.extra_ammo, {damage = 7, spread = 4}.suppression, {damage = 7, spread = 4}.concealment, {damage = 7, spread = 4}.zoom, {damage = 7, spread = 4}.spread_moving, {damage = 7, spread = 4}.recoil = {damage = 7, spread = 4}, 1, 6, 7, 27, 3, 7, 5
  l_36_0.ak74 = {}
  l_36_0.ak74.category = "assault_rifle"
  l_36_0.ak74.damage_melee = l_36_4
  l_36_0.ak74.damage_melee_effect_mul = l_36_5
  l_36_0.ak74.sounds = {}
  l_36_0.ak74.sounds.fire = "ak74_fire"
  l_36_0.ak74.sounds.stop_fire = "ak74_stop"
  l_36_0.ak74.sounds.dryfire = "ak47_dryfire"
  l_36_0.ak74.sounds.enter_steelsight = "primary_steel_sight_enter"
  l_36_0.ak74.sounds.leave_steelsight = "primary_steel_sight_exit"
  l_36_0.ak74.timers = {}
  l_36_0.ak74.timers.reload_not_empty = 2.2999999523163
  l_36_0.ak74.timers.reload_empty = 3.4000000953674
  l_36_0.ak74.timers.unequip = 0.69999998807907
  l_36_0.ak74.timers.equip = 0.5
  l_36_0.ak74.name_id = "bm_w_ak74"
  l_36_0.ak74.desc_id = "bm_w_ak74_desc"
  l_36_0.ak74.hud_icon = "ak"
  l_36_0.ak74.description_id = "des_ak47"
  l_36_0.ak74.muzzleflash = "effects/payday2/particles/weapons/556_auto_fps"
  l_36_0.ak74.shell_ejection = "effects/payday2/particles/weapons/shells/shell_556"
  l_36_0.ak74.use_data = {}
  l_36_0.ak74.use_data.selection_index = 2
  l_36_0.ak74.DAMAGE = 1
  l_36_0.ak74.CLIP_AMMO_MAX = 30
  l_36_0.ak74.NR_CLIPS_MAX = math.round(total_damage_primary / 2.5 / l_36_0.ak74.CLIP_AMMO_MAX)
  l_36_0.ak74.AMMO_MAX = l_36_0.ak74.CLIP_AMMO_MAX * l_36_0.ak74.NR_CLIPS_MAX
  l_36_0.ak74.AMMO_PICKUP = l_36_0:_pickup_chance(l_36_0.ak74.AMMO_MAX, 2)
  l_36_0.ak74.auto = {}
  l_36_0.ak74.auto.fire_rate = 0.14000000059605
  l_36_0.ak74.spread = {}
  l_36_0.ak74.spread.standing = l_36_0.new_m4.spread.standing
  l_36_0.ak74.spread.crouching = l_36_0.new_m4.spread.standing
  l_36_0.ak74.spread.steelsight = l_36_0.new_m4.spread.steelsight
  l_36_0.ak74.spread.moving_standing = l_36_0.new_m4.spread.standing
  l_36_0.ak74.spread.moving_crouching = l_36_0.new_m4.spread.standing
  l_36_0.ak74.spread.moving_steelsight = l_36_0.new_m4.spread.moving_steelsight
  l_36_0.ak74.kick = {}
  l_36_0.ak74.kick.standing = l_36_0.new_m4.kick.standing
  l_36_0.ak74.kick.crouching = l_36_0.ak74.kick.standing
  l_36_0.ak74.kick.steelsight = l_36_0.ak74.kick.standing
  l_36_0.ak74.crosshair = {}
  l_36_0.ak74.crosshair.standing = {}
  l_36_0.ak74.crosshair.crouching = {}
  l_36_0.ak74.crosshair.steelsight = {}
  l_36_0.ak74.crosshair.standing.offset = 0.15999999642372
  l_36_0.ak74.crosshair.standing.moving_offset = 0.80000001192093
  l_36_0.ak74.crosshair.standing.kick_offset = 0.60000002384186
  l_36_0.ak74.crosshair.crouching.offset = 0.079999998211861
  l_36_0.ak74.crosshair.crouching.moving_offset = 0.69999998807907
  l_36_0.ak74.crosshair.crouching.kick_offset = 0.40000000596046
  l_36_0.ak74.crosshair.steelsight.hidden = true
  l_36_0.ak74.crosshair.steelsight.offset = 0
  l_36_0.ak74.crosshair.steelsight.moving_offset = 0
  l_36_0.ak74.crosshair.steelsight.kick_offset = 0.10000000149012
  l_36_0.ak74.shake = {}
  l_36_0.ak74.shake.fire_multiplier = 1
  l_36_0.ak74.shake.fire_steelsight_multiplier = -1
  l_36_0.ak74.autohit = l_36_1
  l_36_0.ak74.aim_assist = l_36_6
  l_36_0.ak74.weapon_hold = "ak47"
  l_36_0.ak74.animations = {}
  l_36_0.ak74.animations.equip_id = "equip_ak47"
  l_36_0.ak74.animations.recoil_steelsight = false
  l_36_0.ak74.challenges = {}
  l_36_0.ak74.challenges.group = "rifle"
  l_36_0.ak74.challenges.weapon = "ak47"
   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

  l_36_0.ak74.stats, {damage = 11, spread = 6}.value, {damage = 11, spread = 6}.extra_ammo, {damage = 11, spread = 6}.suppression, {damage = 11, spread = 6}.concealment, {damage = 11, spread = 6}.zoom, {damage = 11, spread = 6}.spread_moving, {damage = 11, spread = 6}.recoil = {damage = 11, spread = 6}, 1, 6, 7, 18, 3, 7, 9
  l_36_0.akm = {}
  l_36_0.akm.category = "assault_rifle"
  l_36_0.akm.damage_melee = l_36_4
  l_36_0.akm.damage_melee_effect_mul = l_36_5
  l_36_0.akm.sounds = {}
  l_36_0.akm.sounds.fire = "akm_fire"
  l_36_0.akm.sounds.stop_fire = "akm_stop"
  l_36_0.akm.sounds.dryfire = "ak47_dryfire"
  l_36_0.akm.sounds.enter_steelsight = "primary_steel_sight_enter"
  l_36_0.akm.sounds.leave_steelsight = "primary_steel_sight_exit"
  l_36_0.akm.timers = {}
  l_36_0.akm.timers.reload_not_empty = 2.2999999523163
  l_36_0.akm.timers.reload_empty = 3.4000000953674
  l_36_0.akm.timers.unequip = 0.80000001192093
  l_36_0.akm.timers.equip = 0.5
  l_36_0.akm.name_id = "bm_w_akm"
  l_36_0.akm.desc_id = "bm_w_akm_desc"
  l_36_0.akm.hud_icon = "ak"
  l_36_0.akm.description_id = "des_ak47"
  l_36_0.akm.muzzleflash = "effects/payday2/particles/weapons/762_auto_fps"
  l_36_0.akm.shell_ejection = "effects/payday2/particles/weapons/shells/shell_556"
  l_36_0.akm.use_data = {}
  l_36_0.akm.use_data.selection_index = 2
  l_36_0.akm.DAMAGE = 1.25
  l_36_0.akm.CLIP_AMMO_MAX = 30
  l_36_0.akm.NR_CLIPS_MAX = math.round(total_damage_primary / 4 / l_36_0.akm.CLIP_AMMO_MAX)
  l_36_0.akm.AMMO_MAX = l_36_0.akm.CLIP_AMMO_MAX * l_36_0.akm.NR_CLIPS_MAX
  l_36_0.akm.AMMO_PICKUP = l_36_0:_pickup_chance(l_36_0.akm.AMMO_MAX, 2)
  l_36_0.akm.auto = {}
  l_36_0.akm.auto.fire_rate = 0.15999999642372
  l_36_0.akm.spread = {}
  l_36_0.akm.spread.standing = l_36_0.new_m4.spread.standing
  l_36_0.akm.spread.crouching = l_36_0.new_m4.spread.standing
  l_36_0.akm.spread.steelsight = l_36_0.new_m4.spread.steelsight
  l_36_0.akm.spread.moving_standing = l_36_0.new_m4.spread.standing
  l_36_0.akm.spread.moving_crouching = l_36_0.new_m4.spread.standing
  l_36_0.akm.spread.moving_steelsight = l_36_0.new_m4.spread.moving_steelsight
  l_36_0.akm.kick = {}
  l_36_0.akm.kick.standing = l_36_0.new_m4.kick.standing
  l_36_0.akm.kick.crouching = l_36_0.akm.kick.standing
  l_36_0.akm.kick.steelsight = l_36_0.akm.kick.standing
  l_36_0.akm.crosshair = {}
  l_36_0.akm.crosshair.standing = {}
  l_36_0.akm.crosshair.crouching = {}
  l_36_0.akm.crosshair.steelsight = {}
  l_36_0.akm.crosshair.standing.offset = 0.15999999642372
  l_36_0.akm.crosshair.standing.moving_offset = 0.80000001192093
  l_36_0.akm.crosshair.standing.kick_offset = 0.60000002384186
  l_36_0.akm.crosshair.crouching.offset = 0.079999998211861
  l_36_0.akm.crosshair.crouching.moving_offset = 0.69999998807907
  l_36_0.akm.crosshair.crouching.kick_offset = 0.40000000596046
  l_36_0.akm.crosshair.steelsight.hidden = true
  l_36_0.akm.crosshair.steelsight.offset = 0
  l_36_0.akm.crosshair.steelsight.moving_offset = 0
  l_36_0.akm.crosshair.steelsight.kick_offset = 0.10000000149012
  l_36_0.akm.shake = {}
  l_36_0.akm.shake.fire_multiplier = 1
  l_36_0.akm.shake.fire_steelsight_multiplier = -1
  l_36_0.akm.autohit = l_36_1
  l_36_0.akm.aim_assist = l_36_6
  l_36_0.akm.weapon_hold = "ak47"
  l_36_0.akm.animations = {}
  l_36_0.akm.animations.equip_id = "equip_ak47"
  l_36_0.akm.animations.recoil_steelsight = false
  l_36_0.akm.challenges = {}
  l_36_0.akm.challenges.group = "rifle"
  l_36_0.akm.challenges.weapon = "ak47"
   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

  l_36_0.akm.stats, {damage = 17, spread = 5}.value, {damage = 17, spread = 5}.extra_ammo, {damage = 17, spread = 5}.suppression, {damage = 17, spread = 5}.concealment, {damage = 17, spread = 5}.zoom, {damage = 17, spread = 5}.spread_moving, {damage = 17, spread = 5}.recoil = {damage = 17, spread = 5}, 1, 6, 7, 18, 3, 7, 7
  l_36_0.akmsu = {}
  l_36_0.akmsu.category = "smg"
  l_36_0.akmsu.damage_melee = l_36_4
  l_36_0.akmsu.damage_melee_effect_mul = l_36_5
  l_36_0.akmsu.sounds = {}
  l_36_0.akmsu.sounds.fire = "akmsu_fire"
  l_36_0.akmsu.sounds.stop_fire = "akmsu_stop"
  l_36_0.akmsu.sounds.dryfire = "ak47_dryfire"
  l_36_0.akmsu.sounds.enter_steelsight = "primary_steel_sight_enter"
  l_36_0.akmsu.sounds.leave_steelsight = "primary_steel_sight_exit"
  l_36_0.akmsu.timers = {}
  l_36_0.akmsu.timers.reload_not_empty = 2.2999999523163
  l_36_0.akmsu.timers.reload_empty = 3.4000000953674
  l_36_0.akmsu.timers.unequip = 0.64999997615814
  l_36_0.akmsu.timers.equip = 0.5
  l_36_0.akmsu.name_id = "bm_w_akmsu"
  l_36_0.akmsu.desc_id = "bm_w_akmsu_desc"
  l_36_0.akmsu.hud_icon = "ak"
  l_36_0.akmsu.description_id = "des_ak47"
  l_36_0.akmsu.muzzleflash = "effects/payday2/particles/weapons/556_auto_fps"
  l_36_0.akmsu.shell_ejection = "effects/payday2/particles/weapons/shells/shell_556"
  l_36_0.akmsu.use_data = {}
  l_36_0.akmsu.use_data.selection_index = 1
  l_36_0.akmsu.DAMAGE = 1
  l_36_0.akmsu.CLIP_AMMO_MAX = 30
  l_36_0.akmsu.NR_CLIPS_MAX = math.round(total_damage_secondary / 2.75 / l_36_0.akmsu.CLIP_AMMO_MAX)
  l_36_0.akmsu.AMMO_MAX = l_36_0.akmsu.CLIP_AMMO_MAX * l_36_0.akmsu.NR_CLIPS_MAX
  l_36_0.akmsu.AMMO_PICKUP = l_36_0:_pickup_chance(l_36_0.akmsu.AMMO_MAX, 1)
  l_36_0.akmsu.auto = {}
  l_36_0.akmsu.auto.fire_rate = 0.11999999731779
  l_36_0.akmsu.spread = {}
  l_36_0.akmsu.spread.standing = l_36_0.new_m4.spread.standing
  l_36_0.akmsu.spread.crouching = l_36_0.new_m4.spread.standing
  l_36_0.akmsu.spread.steelsight = l_36_0.new_m4.spread.steelsight
  l_36_0.akmsu.spread.moving_standing = l_36_0.new_m4.spread.standing
  l_36_0.akmsu.spread.moving_crouching = l_36_0.new_m4.spread.standing
  l_36_0.akmsu.spread.moving_steelsight = l_36_0.new_m4.spread.moving_steelsight
  l_36_0.akmsu.kick = {}
  l_36_0.akmsu.kick.standing = l_36_0.new_m4.kick.standing
  l_36_0.akmsu.kick.crouching = l_36_0.akmsu.kick.standing
  l_36_0.akmsu.kick.steelsight = l_36_0.akmsu.kick.standing
  l_36_0.akmsu.crosshair = {}
  l_36_0.akmsu.crosshair.standing = {}
  l_36_0.akmsu.crosshair.crouching = {}
  l_36_0.akmsu.crosshair.steelsight = {}
  l_36_0.akmsu.crosshair.standing.offset = 0.15999999642372
  l_36_0.akmsu.crosshair.standing.moving_offset = 0.80000001192093
  l_36_0.akmsu.crosshair.standing.kick_offset = 0.60000002384186
  l_36_0.akmsu.crosshair.crouching.offset = 0.079999998211861
  l_36_0.akmsu.crosshair.crouching.moving_offset = 0.69999998807907
  l_36_0.akmsu.crosshair.crouching.kick_offset = 0.40000000596046
  l_36_0.akmsu.crosshair.steelsight.hidden = true
  l_36_0.akmsu.crosshair.steelsight.offset = 0
  l_36_0.akmsu.crosshair.steelsight.moving_offset = 0
  l_36_0.akmsu.crosshair.steelsight.kick_offset = 0.10000000149012
  l_36_0.akmsu.shake = {}
  l_36_0.akmsu.shake.fire_multiplier = 1
  l_36_0.akmsu.shake.fire_steelsight_multiplier = -1
  l_36_0.akmsu.autohit = l_36_1
  l_36_0.akmsu.aim_assist = l_36_6
  l_36_0.akmsu.weapon_hold = "ak47"
  l_36_0.akmsu.animations = {}
  l_36_0.akmsu.animations.equip_id = "equip_ak47"
  l_36_0.akmsu.animations.recoil_steelsight = false
  l_36_0.akmsu.challenges = {}
  l_36_0.akmsu.challenges.group = "rifle"
  l_36_0.akmsu.challenges.weapon = "ak47"
   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

  l_36_0.akmsu.stats, {damage = 12, spread = 3}.value, {damage = 12, spread = 3}.extra_ammo, {damage = 12, spread = 3}.suppression, {damage = 12, spread = 3}.concealment, {damage = 12, spread = 3}.zoom, {damage = 12, spread = 3}.spread_moving, {damage = 12, spread = 3}.recoil = {damage = 12, spread = 3}, 1, 6, 7, 24, 3, 7, 4
  l_36_0.saiga = {}
  l_36_0.saiga.category = "shotgun"
  l_36_0.saiga.damage_melee = l_36_4
  l_36_0.saiga.damage_melee_effect_mul = l_36_5
  l_36_0.saiga.sounds = {}
  l_36_0.saiga.sounds.fire = "saiga_play"
  l_36_0.saiga.sounds.dryfire = "remington_dryfire"
  l_36_0.saiga.sounds.stop_fire = "saiga_stop"
  l_36_0.saiga.sounds.enter_steelsight = "primary_steel_sight_enter"
  l_36_0.saiga.sounds.leave_steelsight = "primary_steel_sight_exit"
  l_36_0.saiga.timers = {}
  l_36_0.saiga.timers.reload_not_empty = 2.2999999523163
  l_36_0.saiga.timers.reload_empty = 3.4000000953674
  l_36_0.saiga.timers.unequip = 0.80000001192093
  l_36_0.saiga.timers.equip = 0.80000001192093
  l_36_0.saiga.name_id = "bm_w_saiga"
  l_36_0.saiga.desc_id = "bm_w_saiga_desc"
  l_36_0.saiga.hud_icon = "r870_shotgun"
  l_36_0.saiga.description_id = "des_saiga"
  l_36_0.saiga.hud_ammo = "guis/textures/ammo_shell"
  l_36_0.saiga.muzzleflash = "effects/payday2/particles/weapons/762_auto_fps"
  l_36_0.saiga.shell_ejection = "effects/payday2/particles/weapons/shells/shell_slug"
  l_36_0.saiga.use_data = {}
  l_36_0.saiga.use_data.selection_index = 2
  l_36_0.saiga.use_data.align_place = "right_hand"
  l_36_0.saiga.DAMAGE = 4.5
  l_36_0.saiga.damage_near = 50
  l_36_0.saiga.damage_far = 2000
  l_36_0.saiga.rays = 4
  l_36_0.saiga.CLIP_AMMO_MAX = 7
  l_36_0.saiga.NR_CLIPS_MAX = math.round(total_damage_primary / 4.5 / l_36_0.saiga.CLIP_AMMO_MAX)
  l_36_0.saiga.AMMO_MAX = l_36_0.saiga.CLIP_AMMO_MAX * l_36_0.saiga.NR_CLIPS_MAX
  l_36_0.saiga.AMMO_PICKUP = l_36_0:_pickup_chance(l_36_0.saiga.AMMO_MAX, 2)
  l_36_0.saiga.auto = {}
  l_36_0.saiga.auto.fire_rate = 0.22499999403954
  l_36_0.saiga.spread = {}
  l_36_0.saiga.spread.standing = l_36_0.r870.spread.standing
  l_36_0.saiga.spread.crouching = l_36_0.r870.spread.crouching
  l_36_0.saiga.spread.steelsight = l_36_0.r870.spread.steelsight
  l_36_0.saiga.spread.moving_standing = l_36_0.r870.spread.moving_standing
  l_36_0.saiga.spread.moving_crouching = l_36_0.r870.spread.moving_crouching
  l_36_0.saiga.spread.moving_steelsight = l_36_0.r870.spread.moving_steelsight
  l_36_0.saiga.kick = {}
  l_36_0.saiga.kick.standing = l_36_0.r870.kick.standing
  l_36_0.saiga.kick.crouching = l_36_0.saiga.kick.standing
  l_36_0.saiga.kick.steelsight = l_36_0.r870.kick.steelsight
  l_36_0.saiga.crosshair = {}
  l_36_0.saiga.crosshair.standing = {}
  l_36_0.saiga.crosshair.crouching = {}
  l_36_0.saiga.crosshair.steelsight = {}
  l_36_0.saiga.crosshair.standing.offset = 0.69999998807907
  l_36_0.saiga.crosshair.standing.moving_offset = 0.69999998807907
  l_36_0.saiga.crosshair.standing.kick_offset = 0.80000001192093
  l_36_0.saiga.crosshair.crouching.offset = 0.64999997615814
  l_36_0.saiga.crosshair.crouching.moving_offset = 0.64999997615814
  l_36_0.saiga.crosshair.crouching.kick_offset = 0.75
  l_36_0.saiga.crosshair.steelsight.hidden = true
  l_36_0.saiga.crosshair.steelsight.offset = 0
  l_36_0.saiga.crosshair.steelsight.moving_offset = 0
  l_36_0.saiga.crosshair.steelsight.kick_offset = 0
  l_36_0.saiga.shake = {}
  l_36_0.saiga.shake.fire_multiplier = 2
  l_36_0.saiga.shake.fire_steelsight_multiplier = 1.25
  l_36_0.saiga.autohit = l_36_3
  l_36_0.saiga.aim_assist = l_36_8
  l_36_0.saiga.weapon_hold = "ak47"
  l_36_0.saiga.animations = {}
  l_36_0.saiga.animations.equip_id = "equip_r870_shotgun"
  l_36_0.saiga.animations.recoil_steelsight = true
   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

  l_36_0.saiga.stats, {damage = 19, spread = 5}.value, {damage = 19, spread = 5}.extra_ammo, {damage = 19, spread = 5}.suppression, {damage = 19, spread = 5}.concealment, {damage = 19, spread = 5}.zoom, {damage = 19, spread = 5}.spread_moving, {damage = 19, spread = 5}.recoil = {damage = 19, spread = 5}, 1, 6, 7, 18, 3, 7, 5
  l_36_0.ak5 = {}
  l_36_0.ak5.category = "assault_rifle"
  l_36_0.ak5.damage_melee = l_36_4
  l_36_0.ak5.damage_melee_effect_mul = l_36_5
  l_36_0.ak5.sounds = {}
  l_36_0.ak5.sounds.fire = "ak5_fire"
  l_36_0.ak5.sounds.stop_fire = "ak5_stop"
  l_36_0.ak5.sounds.dryfire = "m4_dryfire"
  l_36_0.ak5.sounds.enter_steelsight = "m4_tighten"
  l_36_0.ak5.sounds.enter_steelsight = "primary_steel_sight_enter"
  l_36_0.ak5.sounds.leave_steelsight = "primary_steel_sight_exit"
  l_36_0.ak5.timers = {}
  l_36_0.ak5.timers.reload_not_empty = 2.25
  l_36_0.ak5.timers.reload_empty = 3.4700000286102
  l_36_0.ak5.timers.unequip = 0.69999998807907
  l_36_0.ak5.timers.equip = 0.5
  l_36_0.ak5.name_id = "bm_w_ak5"
  l_36_0.ak5.desc_id = "bm_w_ak5_desc"
  l_36_0.ak5.hud_icon = "m4"
  l_36_0.ak5.description_id = "des_m4"
  l_36_0.ak5.muzzleflash = "effects/payday2/particles/weapons/556_auto_fps"
  l_36_0.ak5.shell_ejection = "effects/payday2/particles/weapons/shells/shell_556"
  l_36_0.ak5.use_data = {}
  l_36_0.ak5.use_data.selection_index = 2
  l_36_0.ak5.DAMAGE = 1
  l_36_0.ak5.CLIP_AMMO_MAX = 30
  l_36_0.ak5.NR_CLIPS_MAX = math.round(total_damage_primary / 2 / l_36_0.ak5.CLIP_AMMO_MAX)
  l_36_0.ak5.AMMO_MAX = l_36_0.ak5.CLIP_AMMO_MAX * l_36_0.ak5.NR_CLIPS_MAX
  l_36_0.ak5.AMMO_PICKUP = l_36_0:_pickup_chance(l_36_0.ak5.AMMO_MAX, 2)
  l_36_0.ak5.auto = {}
  l_36_0.ak5.auto.fire_rate = 0.12999999523163
  l_36_0.ak5.spread = {}
  l_36_0.ak5.spread.standing = l_36_0.new_m4.spread.standing
  l_36_0.ak5.spread.crouching = l_36_0.new_m4.spread.standing
  l_36_0.ak5.spread.steelsight = l_36_0.new_m4.spread.steelsight
  l_36_0.ak5.spread.moving_standing = l_36_0.new_m4.spread.standing
  l_36_0.ak5.spread.moving_crouching = l_36_0.new_m4.spread.standing
  l_36_0.ak5.spread.moving_steelsight = l_36_0.new_m4.spread.moving_steelsight
  l_36_0.ak5.kick = {}
  l_36_0.ak5.kick.standing = l_36_0.new_m4.kick.standing
  l_36_0.ak5.kick.crouching = l_36_0.ak5.kick.standing
  l_36_0.ak5.kick.steelsight = l_36_0.ak5.kick.standing
  l_36_0.ak5.crosshair = {}
  l_36_0.ak5.crosshair.standing = {}
  l_36_0.ak5.crosshair.crouching = {}
  l_36_0.ak5.crosshair.steelsight = {}
  l_36_0.ak5.crosshair.standing.offset = 0.15999999642372
  l_36_0.ak5.crosshair.standing.moving_offset = 0.80000001192093
  l_36_0.ak5.crosshair.standing.kick_offset = 0.60000002384186
  l_36_0.ak5.crosshair.crouching.offset = 0.079999998211861
  l_36_0.ak5.crosshair.crouching.moving_offset = 0.69999998807907
  l_36_0.ak5.crosshair.crouching.kick_offset = 0.40000000596046
  l_36_0.ak5.crosshair.steelsight.hidden = true
  l_36_0.ak5.crosshair.steelsight.offset = 0
  l_36_0.ak5.crosshair.steelsight.moving_offset = 0
  l_36_0.ak5.crosshair.steelsight.kick_offset = 0.10000000149012
  l_36_0.ak5.shake = {}
  l_36_0.ak5.shake.fire_multiplier = 1
  l_36_0.ak5.shake.fire_steelsight_multiplier = 1
  l_36_0.ak5.autohit = l_36_1
  l_36_0.ak5.aim_assist = l_36_6
  l_36_0.ak5.weapon_hold = "m4"
  l_36_0.ak5.animations = {}
  l_36_0.ak5.animations.reload_not_empty = "reload_not_empty"
  l_36_0.ak5.animations.reload = "reload"
  l_36_0.ak5.animations.equip_id = "equip_m4"
  l_36_0.ak5.animations.recoil_steelsight = false
   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

  l_36_0.ak5.stats, {damage = 9, spread = 5}.value, {damage = 9, spread = 5}.extra_ammo, {damage = 9, spread = 5}.suppression, {damage = 9, spread = 5}.concealment, {damage = 9, spread = 5}.zoom, {damage = 9, spread = 5}.spread_moving, {damage = 9, spread = 5}.recoil = {damage = 9, spread = 5}, 1, 6, 7, 21, 3, 7, 11
  l_36_0.aug = {}
  l_36_0.aug.category = "assault_rifle"
  l_36_0.aug.damage_melee = l_36_4
  l_36_0.aug.damage_melee_effect_mul = l_36_5
  l_36_0.aug.sounds = {}
  l_36_0.aug.sounds.fire = "aug_fire"
  l_36_0.aug.sounds.stop_fire = "aug_stop"
  l_36_0.aug.sounds.dryfire = "mp5_dryfire"
  l_36_0.aug.sounds.enter_steelsight = "secondary_steel_sight_enter"
  l_36_0.aug.sounds.leave_steelsight = "secondary_steel_sight_exit"
  l_36_0.aug.timers = {}
  l_36_0.aug.timers.reload_not_empty = 2.5
  l_36_0.aug.timers.reload_empty = 3.2999999523163
  l_36_0.aug.timers.unequip = 0.72000002861023
  l_36_0.aug.timers.equip = 0.60000002384186
  l_36_0.aug.name_id = "bm_w_aug"
  l_36_0.aug.desc_id = "bm_w_aug_desc"
  l_36_0.aug.hud_icon = "mp5"
  l_36_0.aug.description_id = "des_aug"
  l_36_0.aug.hud_ammo = "guis/textures/ammo_9mm"
  l_36_0.aug.muzzleflash = "effects/payday2/particles/weapons/556_auto_fps"
  l_36_0.aug.shell_ejection = "effects/payday2/particles/weapons/shells/shell_556"
  l_36_0.aug.use_data = {}
  l_36_0.aug.use_data.selection_index = 2
  l_36_0.aug.DAMAGE = 1
  l_36_0.aug.CLIP_AMMO_MAX = 30
  l_36_0.aug.NR_CLIPS_MAX = math.round(total_damage_primary / 2.25 / l_36_0.aug.CLIP_AMMO_MAX)
  l_36_0.aug.AMMO_MAX = l_36_0.aug.CLIP_AMMO_MAX * l_36_0.aug.NR_CLIPS_MAX
  l_36_0.aug.AMMO_PICKUP = l_36_0:_pickup_chance(l_36_0.aug.AMMO_MAX, 2)
  l_36_0.aug.auto = {}
  l_36_0.aug.auto.fire_rate = 0.11999999731779
  l_36_0.aug.spread = {}
  l_36_0.aug.spread.standing = l_36_0.new_m4.spread.standing * 2.5
  l_36_0.aug.spread.crouching = l_36_0.new_m4.spread.standing * 2.5
  l_36_0.aug.spread.steelsight = l_36_0.new_m4.spread.steelsight
  l_36_0.aug.spread.moving_standing = l_36_0.new_m4.spread.standing * 3.5
  l_36_0.aug.spread.moving_crouching = l_36_0.new_m4.spread.standing * 3.5
  l_36_0.aug.spread.moving_steelsight = l_36_0.new_m4.spread.moving_steelsight * 1.5
  l_36_0.aug.kick = {}
  l_36_0.aug.kick.standing = l_36_0.new_m4.kick.standing
  l_36_0.aug.kick.crouching = l_36_0.aug.kick.standing
  l_36_0.aug.kick.steelsight = l_36_0.aug.kick.standing
  l_36_0.aug.crosshair = {}
  l_36_0.aug.crosshair.standing = {}
  l_36_0.aug.crosshair.crouching = {}
  l_36_0.aug.crosshair.steelsight = {}
  l_36_0.aug.crosshair.standing.offset = 0.5
  l_36_0.aug.crosshair.standing.moving_offset = 0.60000002384186
  l_36_0.aug.crosshair.standing.kick_offset = 0.69999998807907
  l_36_0.aug.crosshair.crouching.offset = 0.40000000596046
  l_36_0.aug.crosshair.crouching.moving_offset = 0.5
  l_36_0.aug.crosshair.crouching.kick_offset = 0.60000002384186
  l_36_0.aug.crosshair.steelsight.hidden = true
  l_36_0.aug.crosshair.steelsight.offset = 0
  l_36_0.aug.crosshair.steelsight.moving_offset = 0
  l_36_0.aug.crosshair.steelsight.kick_offset = 0
  l_36_0.aug.shake = {}
  l_36_0.aug.shake.fire_multiplier = 1
  l_36_0.aug.shake.fire_steelsight_multiplier = 1
  l_36_0.aug.autohit = l_36_2
  l_36_0.aug.aim_assist = l_36_7
  l_36_0.aug.animations = {}
  l_36_0.aug.animations.equip_id = "equip_mp5_rifle"
  l_36_0.aug.animations.recoil_steelsight = false
   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

  l_36_0.aug.stats, {damage = 10, spread = 8}.value, {damage = 10, spread = 8}.extra_ammo, {damage = 10, spread = 8}.suppression, {damage = 10, spread = 8}.concealment, {damage = 10, spread = 8}.zoom, {damage = 10, spread = 8}.spread_moving, {damage = 10, spread = 8}.recoil = {damage = 10, spread = 8}, 1, 6, 7, 24, 3, 7, 6
  l_36_0.g36 = {}
  l_36_0.g36.category = "assault_rifle"
  l_36_0.g36.damage_melee = l_36_4
  l_36_0.g36.damage_melee_effect_mul = l_36_5
  l_36_0.g36.sounds = {}
  l_36_0.g36.sounds.fire = "g36_fire"
  l_36_0.g36.sounds.stop_fire = "g36_stop"
  l_36_0.g36.sounds.dryfire = "m4_dryfire"
  l_36_0.g36.sounds.enter_steelsight = "m4_tighten"
  l_36_0.g36.sounds.enter_steelsight = "primary_steel_sight_enter"
  l_36_0.g36.sounds.leave_steelsight = "primary_steel_sight_exit"
  l_36_0.g36.timers = {}
  l_36_0.g36.timers.reload_not_empty = 2.5
  l_36_0.g36.timers.reload_empty = 3.4500000476837
  l_36_0.g36.timers.unequip = 0.75
  l_36_0.g36.timers.equip = 0.5
  l_36_0.g36.name_id = "bm_w_g36"
  l_36_0.g36.desc_id = "bm_w_g36_desc"
  l_36_0.g36.hud_icon = "m4"
  l_36_0.g36.description_id = "des_m4"
  l_36_0.g36.muzzleflash = "effects/payday2/particles/weapons/556_auto_fps"
  l_36_0.g36.shell_ejection = "effects/payday2/particles/weapons/shells/shell_556"
  l_36_0.g36.use_data = {}
  l_36_0.g36.use_data.selection_index = 2
  l_36_0.g36.DAMAGE = 1
  l_36_0.g36.CLIP_AMMO_MAX = 30
  l_36_0.g36.NR_CLIPS_MAX = math.round(total_damage_primary / 1.75 / l_36_0.g36.CLIP_AMMO_MAX)
  l_36_0.g36.AMMO_MAX = l_36_0.g36.CLIP_AMMO_MAX * l_36_0.g36.NR_CLIPS_MAX
  l_36_0.g36.AMMO_PICKUP = l_36_0:_pickup_chance(l_36_0.g36.AMMO_MAX, 2)
  l_36_0.g36.auto = {}
  l_36_0.g36.auto.fire_rate = 0.11500000208616
  l_36_0.g36.spread = {}
  l_36_0.g36.spread.standing = l_36_0.new_m4.spread.standing * 0.80000001192093
  l_36_0.g36.spread.crouching = l_36_0.new_m4.spread.standing * 0.80000001192093
  l_36_0.g36.spread.steelsight = l_36_0.new_m4.spread.steelsight
  l_36_0.g36.spread.moving_standing = l_36_0.new_m4.spread.standing * 0.80000001192093
  l_36_0.g36.spread.moving_crouching = l_36_0.new_m4.spread.standing * 0.80000001192093
  l_36_0.g36.spread.moving_steelsight = l_36_0.new_m4.spread.moving_steelsight
  l_36_0.g36.kick = {}
  l_36_0.g36.kick.standing = l_36_0.new_m4.kick.standing
  l_36_0.g36.kick.crouching = l_36_0.g36.kick.standing
  l_36_0.g36.kick.steelsight = l_36_0.g36.kick.standing
  l_36_0.g36.crosshair = {}
  l_36_0.g36.crosshair.standing = {}
  l_36_0.g36.crosshair.crouching = {}
  l_36_0.g36.crosshair.steelsight = {}
  l_36_0.g36.crosshair.standing.offset = 0.15999999642372
  l_36_0.g36.crosshair.standing.moving_offset = 0.80000001192093
  l_36_0.g36.crosshair.standing.kick_offset = 0.60000002384186
  l_36_0.g36.crosshair.crouching.offset = 0.079999998211861
  l_36_0.g36.crosshair.crouching.moving_offset = 0.69999998807907
  l_36_0.g36.crosshair.crouching.kick_offset = 0.40000000596046
  l_36_0.g36.crosshair.steelsight.hidden = true
  l_36_0.g36.crosshair.steelsight.offset = 0
  l_36_0.g36.crosshair.steelsight.moving_offset = 0
  l_36_0.g36.crosshair.steelsight.kick_offset = 0.10000000149012
  l_36_0.g36.shake = {}
  l_36_0.g36.shake.fire_multiplier = 1
  l_36_0.g36.shake.fire_steelsight_multiplier = -1
  l_36_0.g36.autohit = l_36_1
  l_36_0.g36.aim_assist = l_36_6
  l_36_0.g36.animations = {}
  l_36_0.g36.animations.equip_id = "equip_m4"
  l_36_0.g36.animations.recoil_steelsight = false
   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

  l_36_0.g36.stats, {damage = 8, spread = 6}.value, {damage = 8, spread = 6}.extra_ammo, {damage = 8, spread = 6}.suppression, {damage = 8, spread = 6}.concealment, {damage = 8, spread = 6}.zoom, {damage = 8, spread = 6}.spread_moving, {damage = 8, spread = 6}.recoil = {damage = 8, spread = 6}, 1, 6, 7, 21, 3, 7, 11
  l_36_0.p90 = {}
  l_36_0.p90.category = "smg"
  l_36_0.p90.damage_melee = l_36_4
  l_36_0.p90.damage_melee_effect_mul = l_36_5
  l_36_0.p90.sounds = {}
  l_36_0.p90.sounds.fire = "p90_fire"
  l_36_0.p90.sounds.stop_fire = "p90_stop"
  l_36_0.p90.sounds.dryfire = "m4_dryfire"
  l_36_0.p90.sounds.enter_steelsight = "secondary_steel_sight_enter"
  l_36_0.p90.sounds.leave_steelsight = "secondary_steel_sight_exit"
  l_36_0.p90.timers = {}
  l_36_0.p90.timers.reload_not_empty = 2.9000000953674
  l_36_0.p90.timers.reload_empty = 3.9000000953674
  l_36_0.p90.timers.unequip = 0.69999998807907
  l_36_0.p90.timers.equip = 0.5
  l_36_0.p90.name_id = "bm_w_p90"
  l_36_0.p90.desc_id = "bm_w_p90_desc"
  l_36_0.p90.hud_icon = "mac11"
  l_36_0.p90.description_id = "des_p90"
  l_36_0.p90.hud_ammo = "guis/textures/ammo_small_9mm"
  l_36_0.p90.muzzleflash = "effects/payday2/particles/weapons/556_auto_fps"
  l_36_0.p90.shell_ejection = "effects/payday2/particles/weapons/shells/shell_556"
  l_36_0.p90.use_data = {}
  l_36_0.p90.use_data.selection_index = 1
  l_36_0.p90.DAMAGE = 1
  l_36_0.p90.CLIP_AMMO_MAX = 50
  l_36_0.p90.NR_CLIPS_MAX = math.round(total_damage_secondary / 1.4500000476837 / l_36_0.p90.CLIP_AMMO_MAX)
  l_36_0.p90.AMMO_MAX = l_36_0.p90.CLIP_AMMO_MAX * l_36_0.p90.NR_CLIPS_MAX
  l_36_0.p90.AMMO_PICKUP = l_36_0:_pickup_chance(l_36_0.p90.AMMO_MAX, 1)
  l_36_0.p90.auto = {}
  l_36_0.p90.auto.fire_rate = 0.090000003576279
  l_36_0.p90.spread = {}
  l_36_0.p90.spread.standing = l_36_0.new_m4.spread.standing * 1.3500000238419
  l_36_0.p90.spread.crouching = l_36_0.new_m4.spread.standing * 1.3500000238419
  l_36_0.p90.spread.steelsight = l_36_0.new_m4.spread.steelsight
  l_36_0.p90.spread.moving_standing = l_36_0.new_m4.spread.standing * 1.3500000238419
  l_36_0.p90.spread.moving_crouching = l_36_0.new_m4.spread.standing * 1.3500000238419
  l_36_0.p90.spread.moving_steelsight = l_36_0.new_m4.spread.moving_steelsight
  l_36_0.p90.kick = {}
  l_36_0.p90.kick.standing = l_36_0.new_m4.kick.standing
  l_36_0.p90.kick.crouching = l_36_0.p90.kick.standing
  l_36_0.p90.kick.steelsight = l_36_0.p90.kick.standing
  l_36_0.p90.crosshair = {}
  l_36_0.p90.crosshair.standing = {}
  l_36_0.p90.crosshair.crouching = {}
  l_36_0.p90.crosshair.steelsight = {}
  l_36_0.p90.crosshair.standing.offset = 0.40000000596046
  l_36_0.p90.crosshair.standing.moving_offset = 0.69999998807907
  l_36_0.p90.crosshair.standing.kick_offset = 0.60000002384186
  l_36_0.p90.crosshair.crouching.offset = 0.30000001192093
  l_36_0.p90.crosshair.crouching.moving_offset = 0.60000002384186
  l_36_0.p90.crosshair.crouching.kick_offset = 0.40000000596046
  l_36_0.p90.crosshair.steelsight.hidden = true
  l_36_0.p90.crosshair.steelsight.offset = 0
  l_36_0.p90.crosshair.steelsight.moving_offset = 0
  l_36_0.p90.crosshair.steelsight.kick_offset = 0.40000000596046
  l_36_0.p90.shake = {}
  l_36_0.p90.shake.fire_multiplier = 1
  l_36_0.p90.shake.fire_steelsight_multiplier = 1
  l_36_0.p90.autohit = l_36_2
  l_36_0.p90.aim_assist = l_36_7
  l_36_0.p90.animations = {}
  l_36_0.p90.animations.equip_id = "equip_mac11_rifle"
  l_36_0.p90.animations.recoil_steelsight = false
   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

  l_36_0.p90.stats, {damage = 6, spread = 6}.value, {damage = 6, spread = 6}.extra_ammo, {damage = 6, spread = 6}.suppression, {damage = 6, spread = 6}.concealment, {damage = 6, spread = 6}.zoom, {damage = 6, spread = 6}.spread_moving, {damage = 6, spread = 6}.recoil = {damage = 6, spread = 6}, 1, 6, 7, 24, 3, 7, 6
  l_36_0.new_m14 = {}
  l_36_0.new_m14.category = "assault_rifle"
  l_36_0.new_m14.damage_melee = l_36_4
  l_36_0.new_m14.damage_melee_effect_mul = l_36_5
  l_36_0.new_m14.sounds = {}
  l_36_0.new_m14.sounds.fire = "m14_fire"
  l_36_0.new_m14.sounds.dryfire = "m14_dryfire"
  l_36_0.new_m14.sounds.enter_steelsight = "primary_steel_sight_enter"
  l_36_0.new_m14.sounds.leave_steelsight = "primary_steel_sight_exit"
  l_36_0.new_m14.timers = {}
  l_36_0.new_m14.timers.reload_not_empty = 1.9700000286102
  l_36_0.new_m14.timers.reload_empty = 3.0999999046326
  l_36_0.new_m14.timers.unequip = 0.80000001192093
  l_36_0.new_m14.timers.equip = 0.64999997615814
  l_36_0.new_m14.name_id = "bm_w_m14"
  l_36_0.new_m14.desc_id = "bm_w_m14_desc"
  l_36_0.new_m14.hud_icon = "m14"
  l_36_0.new_m14.description_id = "des_m14"
  l_36_0.new_m14.muzzleflash = "effects/payday2/particles/weapons/762_auto_fps"
  l_36_0.new_m14.shell_ejection = "effects/payday2/particles/weapons/shells/shell_556"
  l_36_0.new_m14.use_data = {}
  l_36_0.new_m14.use_data.selection_index = 2
  l_36_0.new_m14.DAMAGE = 2
  l_36_0.new_m14.CLIP_AMMO_MAX = 10
  l_36_0.new_m14.NR_CLIPS_MAX = math.round(total_damage_primary / 8 / l_36_0.new_m14.CLIP_AMMO_MAX)
  l_36_0.new_m14.AMMO_MAX = l_36_0.new_m14.CLIP_AMMO_MAX * l_36_0.new_m14.NR_CLIPS_MAX
  l_36_0.new_m14.AMMO_PICKUP = l_36_0:_pickup_chance(l_36_0.new_m14.AMMO_MAX, 2)
  l_36_0.new_m14.single = {}
  l_36_0.new_m14.single.fire_rate = 0.14000000059605
  l_36_0.new_m14.spread = {}
  l_36_0.new_m14.spread.standing = l_36_0.new_m4.spread.standing * 2
  l_36_0.new_m14.spread.crouching = l_36_0.new_m4.spread.standing * 2
  l_36_0.new_m14.spread.steelsight = l_36_0.new_m4.spread.steelsight
  l_36_0.new_m14.spread.moving_standing = l_36_0.new_m4.spread.standing * 2.5
  l_36_0.new_m14.spread.moving_crouching = l_36_0.new_m4.spread.standing * 2.5
  l_36_0.new_m14.spread.moving_steelsight = l_36_0.new_m4.spread.moving_steelsight * 1.5
  l_36_0.new_m14.kick = {}
  l_36_0.new_m14.kick.standing = l_36_0.new_m4.kick.standing
  l_36_0.new_m14.kick.crouching = l_36_0.new_m14.kick.standing
  l_36_0.new_m14.kick.steelsight = l_36_0.new_m14.kick.standing
  l_36_0.new_m14.crosshair = {}
  l_36_0.new_m14.crosshair.standing = {}
  l_36_0.new_m14.crosshair.crouching = {}
  l_36_0.new_m14.crosshair.steelsight = {}
  l_36_0.new_m14.crosshair.standing.offset = 0.15999999642372
  l_36_0.new_m14.crosshair.standing.moving_offset = 0.80000001192093
  l_36_0.new_m14.crosshair.standing.kick_offset = 0.60000002384186
  l_36_0.new_m14.crosshair.crouching.offset = 0.079999998211861
  l_36_0.new_m14.crosshair.crouching.moving_offset = 0.69999998807907
  l_36_0.new_m14.crosshair.crouching.kick_offset = 0.40000000596046
  l_36_0.new_m14.crosshair.steelsight.hidden = true
  l_36_0.new_m14.crosshair.steelsight.offset = 0
  l_36_0.new_m14.crosshair.steelsight.moving_offset = 0
  l_36_0.new_m14.crosshair.steelsight.kick_offset = 0.10000000149012
  l_36_0.new_m14.shake = {}
  l_36_0.new_m14.shake.fire_multiplier = 1
  l_36_0.new_m14.shake.fire_steelsight_multiplier = 1
  l_36_0.new_m14.autohit = l_36_1
  l_36_0.new_m14.aim_assist = l_36_6
  l_36_0.new_m14.animations = {}
  l_36_0.new_m14.animations.fire = "recoil"
  l_36_0.new_m14.animations.equip_id = "equip_m14_rifle"
  l_36_0.new_m14.animations.recoil_steelsight = true
   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

  l_36_0.new_m14.stats, {damage = 27, spread = 8}.value, {damage = 27, spread = 8}.extra_ammo, {damage = 27, spread = 8}.suppression, {damage = 27, spread = 8}.concealment, {damage = 27, spread = 8}.zoom, {damage = 27, spread = 8}.spread_moving, {damage = 27, spread = 8}.recoil = {damage = 27, spread = 8}, 1, 6, 7, 18, 3, 7, 2
  l_36_0.deagle = {}
  l_36_0.deagle.category = "pistol"
  l_36_0.deagle.damage_melee = l_36_4
  l_36_0.deagle.damage_melee_effect_mul = l_36_5
  l_36_0.deagle.sounds = {}
  l_36_0.deagle.sounds.fire = "deagle_fire"
  l_36_0.deagle.sounds.dryfire = "c45_dryfire"
  l_36_0.deagle.sounds.enter_steelsight = "pistol_steel_sight_enter"
  l_36_0.deagle.sounds.leave_steelsight = "pistol_steel_sight_exit"
  l_36_0.deagle.single = {}
  l_36_0.deagle.single.fire_rate = 0.15000000596046
  l_36_0.deagle.timers = {}
  l_36_0.deagle.timers.reload_not_empty = 1.4700000286102
  l_36_0.deagle.timers.reload_empty = 2.1199998855591
  l_36_0.deagle.timers.unequip = 0.60000002384186
  l_36_0.deagle.timers.equip = 0.60000002384186
  l_36_0.deagle.name_id = "bm_w_deagle"
  l_36_0.deagle.desc_id = "bm_w_deagle_desc"
  l_36_0.deagle.hud_icon = "c45"
  l_36_0.deagle.description_id = "des_deagle"
  l_36_0.deagle.hud_ammo = "guis/textures/ammo_9mm"
  l_36_0.deagle.muzzleflash = "effects/payday2/particles/weapons/556_auto_fps"
  l_36_0.deagle.shell_ejection = "effects/payday2/particles/weapons/shells/shell_9mm"
  l_36_0.deagle.use_data = {}
  l_36_0.deagle.use_data.selection_index = 1
  l_36_0.deagle.DAMAGE = 2
  l_36_0.deagle.CLIP_AMMO_MAX = 10
  l_36_0.deagle.NR_CLIPS_MAX = math.round(total_damage_secondary / 4.5 / l_36_0.deagle.CLIP_AMMO_MAX)
  l_36_0.deagle.AMMO_MAX = l_36_0.deagle.CLIP_AMMO_MAX * l_36_0.deagle.NR_CLIPS_MAX
  l_36_0.deagle.AMMO_PICKUP = l_36_0:_pickup_chance(l_36_0.deagle.AMMO_MAX, 1)
  l_36_0.deagle.spread = {}
  l_36_0.deagle.spread.standing = l_36_0.new_m4.spread.standing
  l_36_0.deagle.spread.crouching = l_36_0.new_m4.spread.standing
  l_36_0.deagle.spread.steelsight = l_36_0.new_m4.spread.steelsight
  l_36_0.deagle.spread.moving_standing = l_36_0.new_m4.spread.standing
  l_36_0.deagle.spread.moving_crouching = l_36_0.new_m4.spread.standing
  l_36_0.deagle.spread.moving_steelsight = l_36_0.new_m4.spread.moving_steelsight
  l_36_0.deagle.kick = {}
  l_36_0.deagle.kick.standing = l_36_0.glock_17.kick.standing
  l_36_0.deagle.kick.crouching = l_36_0.deagle.kick.standing
  l_36_0.deagle.kick.steelsight = l_36_0.deagle.kick.standing
  l_36_0.deagle.crosshair = {}
  l_36_0.deagle.crosshair.standing = {}
  l_36_0.deagle.crosshair.crouching = {}
  l_36_0.deagle.crosshair.steelsight = {}
  l_36_0.deagle.crosshair.standing.offset = 0.20000000298023
  l_36_0.deagle.crosshair.standing.moving_offset = 0.60000002384186
  l_36_0.deagle.crosshair.standing.kick_offset = 0.40000000596046
  l_36_0.deagle.crosshair.crouching.offset = 0.10000000149012
  l_36_0.deagle.crosshair.crouching.moving_offset = 0.60000002384186
  l_36_0.deagle.crosshair.crouching.kick_offset = 0.30000001192093
  l_36_0.deagle.crosshair.steelsight.hidden = true
  l_36_0.deagle.crosshair.steelsight.offset = 0
  l_36_0.deagle.crosshair.steelsight.moving_offset = 0
  l_36_0.deagle.crosshair.steelsight.kick_offset = 0.10000000149012
  l_36_0.deagle.shake = {}
  l_36_0.deagle.shake.fire_multiplier = -1
  l_36_0.deagle.shake.fire_steelsight_multiplier = -1
  l_36_0.deagle.autohit = l_36_2
  l_36_0.deagle.aim_assist = l_36_7
  l_36_0.deagle.animations = {}
  l_36_0.deagle.animations.equip_id = "equip_glock"
  l_36_0.deagle.animations.recoil_steelsight = true
   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

  l_36_0.deagle.stats, {damage = 19, spread = 4}.value, {damage = 19, spread = 4}.extra_ammo, {damage = 19, spread = 4}.suppression, {damage = 19, spread = 4}.concealment, {damage = 19, spread = 4}.zoom, {damage = 19, spread = 4}.spread_moving, {damage = 19, spread = 4}.recoil = {damage = 19, spread = 4}, 1, 6, 7, 27, 3, 7, 2
  l_36_0.new_mp5 = {}
  l_36_0.new_mp5.category = "smg"
  l_36_0.new_mp5.damage_melee = l_36_4
  l_36_0.new_mp5.damage_melee_effect_mul = l_36_5
  l_36_0.new_mp5.sounds = {}
  l_36_0.new_mp5.sounds.fire = "mp5_fire"
  l_36_0.new_mp5.sounds.stop_fire = "mp5_stop"
  l_36_0.new_mp5.sounds.dryfire = "mp5_dryfire"
  l_36_0.new_mp5.sounds.enter_steelsight = "secondary_steel_sight_enter"
  l_36_0.new_mp5.sounds.leave_steelsight = "secondary_steel_sight_exit"
  l_36_0.new_mp5.timers = {}
  l_36_0.new_mp5.timers.reload_not_empty = 2.4000000953674
  l_36_0.new_mp5.timers.reload_empty = 3.2999999523163
  l_36_0.new_mp5.timers.unequip = 0.69999998807907
  l_36_0.new_mp5.timers.equip = 0.5
  l_36_0.new_mp5.name_id = "bm_w_mp5"
  l_36_0.new_mp5.desc_id = "bm_w_mp5_desc"
  l_36_0.new_mp5.hud_icon = "mp5"
  l_36_0.new_mp5.description_id = "des_mp5"
  l_36_0.new_mp5.hud_ammo = "guis/textures/ammo_9mm"
  l_36_0.new_mp5.muzzleflash = "effects/payday2/particles/weapons/9mm_auto_fps"
  l_36_0.new_mp5.muzzleflash_silenced = "effects/payday2/particles/weapons/9mm_auto_silence_fps"
  l_36_0.new_mp5.shell_ejection = "effects/payday2/particles/weapons/shells/shell_9mm"
  l_36_0.new_mp5.use_data = {}
  l_36_0.new_mp5.use_data.selection_index = 1
  l_36_0.new_mp5.DAMAGE = 1
  l_36_0.new_mp5.CLIP_AMMO_MAX = 30
  l_36_0.new_mp5.NR_CLIPS_MAX = math.round(total_damage_secondary / 1 / l_36_0.new_mp5.CLIP_AMMO_MAX)
  l_36_0.new_mp5.AMMO_MAX = l_36_0.new_mp5.CLIP_AMMO_MAX * l_36_0.new_mp5.NR_CLIPS_MAX
  l_36_0.new_mp5.AMMO_PICKUP = l_36_0:_pickup_chance(l_36_0.new_mp5.AMMO_MAX, 1)
  l_36_0.new_mp5.auto = {}
  l_36_0.new_mp5.auto.fire_rate = 0.12999999523163
  l_36_0.new_mp5.spread = {}
  l_36_0.new_mp5.spread.standing = l_36_0.new_m4.spread.standing
  l_36_0.new_mp5.spread.crouching = l_36_0.new_m4.spread.standing
  l_36_0.new_mp5.spread.steelsight = l_36_0.new_m4.spread.steelsight
  l_36_0.new_mp5.spread.moving_standing = l_36_0.new_m4.spread.standing
  l_36_0.new_mp5.spread.moving_crouching = l_36_0.new_m4.spread.standing
  l_36_0.new_mp5.spread.moving_steelsight = l_36_0.new_m4.spread.moving_steelsight
  l_36_0.new_mp5.kick = {}
  l_36_0.new_mp5.kick.standing = l_36_0.new_m4.kick.standing
  l_36_0.new_mp5.kick.crouching = l_36_0.new_mp5.kick.standing
  l_36_0.new_mp5.kick.steelsight = l_36_0.new_mp5.kick.standing
  l_36_0.new_mp5.crosshair = {}
  l_36_0.new_mp5.crosshair.standing = {}
  l_36_0.new_mp5.crosshair.crouching = {}
  l_36_0.new_mp5.crosshair.steelsight = {}
  l_36_0.new_mp5.crosshair.standing.offset = 0.5
  l_36_0.new_mp5.crosshair.standing.moving_offset = 0.60000002384186
  l_36_0.new_mp5.crosshair.standing.kick_offset = 0.69999998807907
  l_36_0.new_mp5.crosshair.crouching.offset = 0.40000000596046
  l_36_0.new_mp5.crosshair.crouching.moving_offset = 0.5
  l_36_0.new_mp5.crosshair.crouching.kick_offset = 0.60000002384186
  l_36_0.new_mp5.crosshair.steelsight.hidden = true
  l_36_0.new_mp5.crosshair.steelsight.offset = 0
  l_36_0.new_mp5.crosshair.steelsight.moving_offset = 0
  l_36_0.new_mp5.crosshair.steelsight.kick_offset = 0
  l_36_0.new_mp5.shake = {}
  l_36_0.new_mp5.shake.fire_multiplier = 1
  l_36_0.new_mp5.shake.fire_steelsight_multiplier = 0.5
  l_36_0.new_mp5.autohit = l_36_2
  l_36_0.new_mp5.aim_assist = l_36_7
  l_36_0.new_mp5.weapon_hold = "mp5"
  l_36_0.new_mp5.animations = {}
  l_36_0.new_mp5.animations.equip_id = "equip_mp5_rifle"
  l_36_0.new_mp5.animations.recoil_steelsight = false
   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

  l_36_0.new_mp5.stats, {damage = 5, spread = 6}.value, {damage = 5, spread = 6}.extra_ammo, {damage = 5, spread = 6}.suppression, {damage = 5, spread = 6}.concealment, {damage = 5, spread = 6}.zoom, {damage = 5, spread = 6}.spread_moving, {damage = 5, spread = 6}.recoil = {damage = 5, spread = 6}, 1, 6, 7, 24, 3, 7, 9
  l_36_0.colt_1911 = {}
  l_36_0.colt_1911.category = "pistol"
  l_36_0.colt_1911.damage_melee = l_36_4
  l_36_0.colt_1911.damage_melee_effect_mul = l_36_5
  l_36_0.colt_1911.sounds = {}
  l_36_0.colt_1911.sounds.fire = "c45_fire"
  l_36_0.colt_1911.sounds.dryfire = "c45_dryfire"
  l_36_0.colt_1911.sounds.enter_steelsight = "pistol_steel_sight_enter"
  l_36_0.colt_1911.sounds.leave_steelsight = "pistol_steel_sight_exit"
  l_36_0.colt_1911.single = {}
  l_36_0.colt_1911.single.fire_rate = 0.11999999731779
  l_36_0.colt_1911.timers = {}
  l_36_0.colt_1911.timers.reload_not_empty = 1.4700000286102
  l_36_0.colt_1911.timers.reload_empty = 2.1199998855591
  l_36_0.colt_1911.timers.unequip = 0.5
  l_36_0.colt_1911.timers.equip = 0.5
  l_36_0.colt_1911.name_id = "bm_w_colt_1911"
  l_36_0.colt_1911.desc_id = "bm_w_colt_1911_desc"
  l_36_0.colt_1911.hud_icon = "c45"
  l_36_0.colt_1911.description_id = "des_colt_1911"
  l_36_0.colt_1911.hud_ammo = "guis/textures/ammo_9mm"
  l_36_0.colt_1911.muzzleflash = "effects/payday2/particles/weapons/9mm_auto_fps"
  l_36_0.colt_1911.muzzleflash_silenced = "effects/payday2/particles/weapons/9mm_auto_silence_fps"
  l_36_0.colt_1911.shell_ejection = "effects/payday2/particles/weapons/shells/shell_9mm"
  l_36_0.colt_1911.use_data = {}
  l_36_0.colt_1911.use_data.selection_index = 1
  l_36_0.colt_1911.DAMAGE = 1
  l_36_0.colt_1911.CLIP_AMMO_MAX = 10
  l_36_0.colt_1911.NR_CLIPS_MAX = math.round(total_damage_secondary / 2.5 / l_36_0.colt_1911.CLIP_AMMO_MAX)
  l_36_0.colt_1911.AMMO_MAX = l_36_0.colt_1911.CLIP_AMMO_MAX * l_36_0.colt_1911.NR_CLIPS_MAX
  l_36_0.colt_1911.AMMO_PICKUP = l_36_0:_pickup_chance(l_36_0.colt_1911.AMMO_MAX, 1)
  l_36_0.colt_1911.spread = {}
  l_36_0.colt_1911.spread.standing = l_36_0.new_m4.spread.standing * 0.75
  l_36_0.colt_1911.spread.crouching = l_36_0.new_m4.spread.standing * 0.75
  l_36_0.colt_1911.spread.steelsight = l_36_0.new_m4.spread.steelsight
  l_36_0.colt_1911.spread.moving_standing = l_36_0.new_m4.spread.standing * 0.75
  l_36_0.colt_1911.spread.moving_crouching = l_36_0.new_m4.spread.standing * 0.75
  l_36_0.colt_1911.spread.moving_steelsight = l_36_0.new_m4.spread.moving_steelsight
  l_36_0.colt_1911.kick = {}
  l_36_0.colt_1911.kick.standing = l_36_0.glock_17.kick.standing
  l_36_0.colt_1911.kick.crouching = l_36_0.colt_1911.kick.standing
  l_36_0.colt_1911.kick.steelsight = l_36_0.colt_1911.kick.standing
  l_36_0.colt_1911.crosshair = {}
  l_36_0.colt_1911.crosshair.standing = {}
  l_36_0.colt_1911.crosshair.crouching = {}
  l_36_0.colt_1911.crosshair.steelsight = {}
  l_36_0.colt_1911.crosshair.standing.offset = 0.20000000298023
  l_36_0.colt_1911.crosshair.standing.moving_offset = 0.60000002384186
  l_36_0.colt_1911.crosshair.standing.kick_offset = 0.40000000596046
  l_36_0.colt_1911.crosshair.crouching.offset = 0.10000000149012
  l_36_0.colt_1911.crosshair.crouching.moving_offset = 0.60000002384186
  l_36_0.colt_1911.crosshair.crouching.kick_offset = 0.30000001192093
  l_36_0.colt_1911.crosshair.steelsight.hidden = true
  l_36_0.colt_1911.crosshair.steelsight.offset = 0
  l_36_0.colt_1911.crosshair.steelsight.moving_offset = 0
  l_36_0.colt_1911.crosshair.steelsight.kick_offset = 0.10000000149012
  l_36_0.colt_1911.shake = {}
  l_36_0.colt_1911.shake.fire_multiplier = 1
  l_36_0.colt_1911.shake.fire_steelsight_multiplier = -1
  l_36_0.colt_1911.autohit = l_36_2
  l_36_0.colt_1911.aim_assist = l_36_7
  l_36_0.colt_1911.animations = {}
  l_36_0.colt_1911.animations.reload = "reload"
  l_36_0.colt_1911.animations.reload_not_empty = "reload_not_empty"
  l_36_0.colt_1911.animations.equip_id = "equip_glock"
  l_36_0.colt_1911.animations.recoil_steelsight = true
   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

  l_36_0.colt_1911.stats, {damage = 11, spread = 4}.value, {damage = 11, spread = 4}.extra_ammo, {damage = 11, spread = 4}.suppression, {damage = 11, spread = 4}.concealment, {damage = 11, spread = 4}.zoom, {damage = 11, spread = 4}.spread_moving, {damage = 11, spread = 4}.recoil = {damage = 11, spread = 4}, 1, 6, 7, 30, 3, 7, 2
  l_36_0.mac10 = {}
  l_36_0.mac10.category = "smg"
  l_36_0.mac10.damage_melee = l_36_4
  l_36_0.mac10.damage_melee_effect_mul = l_36_5
  l_36_0.mac10.sounds = {}
  l_36_0.mac10.sounds.fire = "mac10_fire"
  l_36_0.mac10.sounds.stop_fire = "mac10_stop"
  l_36_0.mac10.sounds.dryfire = "mk11_dryfire"
  l_36_0.mac10.sounds.enter_steelsight = "secondary_steel_sight_enter"
  l_36_0.mac10.sounds.leave_steelsight = "secondary_steel_sight_exit"
  l_36_0.mac10.timers = {}
  l_36_0.mac10.timers.reload_not_empty = 1.7000000476837
  l_36_0.mac10.timers.reload_empty = 2.5
  l_36_0.mac10.timers.unequip = 0.69999998807907
  l_36_0.mac10.timers.equip = 0.5
  l_36_0.mac10.name_id = "bm_w_mac10"
  l_36_0.mac10.desc_id = "bm_w_mac10_desc"
  l_36_0.mac10.hud_icon = "mac11"
  l_36_0.mac10.description_id = "des_mac10"
  l_36_0.mac10.hud_ammo = "guis/textures/ammo_small_9mm"
  l_36_0.mac10.muzzleflash = "effects/payday2/particles/weapons/9mm_auto_fps"
  l_36_0.mac10.muzzleflash_silenced = "effects/payday2/particles/weapons/9mm_auto_silence_fps"
  l_36_0.mac10.shell_ejection = "effects/payday2/particles/weapons/shells/shell_9mm"
  l_36_0.mac10.use_data = {}
  l_36_0.mac10.use_data.selection_index = 1
  l_36_0.mac10.DAMAGE = 1
  l_36_0.mac10.CLIP_AMMO_MAX = 40
  l_36_0.mac10.NR_CLIPS_MAX = math.round(total_damage_secondary / 2.25 / l_36_0.mac10.CLIP_AMMO_MAX)
  l_36_0.mac10.AMMO_MAX = l_36_0.mac10.CLIP_AMMO_MAX * l_36_0.mac10.NR_CLIPS_MAX
  l_36_0.mac10.AMMO_PICKUP = l_36_0:_pickup_chance(l_36_0.mac10.AMMO_MAX, 1)
  l_36_0.mac10.auto = {}
  l_36_0.mac10.auto.fire_rate = 0.064999997615814
  l_36_0.mac10.spread = {}
  l_36_0.mac10.spread.standing = l_36_0.new_m4.spread.standing * 0.75
  l_36_0.mac10.spread.crouching = l_36_0.new_m4.spread.standing * 0.75
  l_36_0.mac10.spread.steelsight = l_36_0.new_m4.spread.steelsight
  l_36_0.mac10.spread.moving_standing = l_36_0.new_m4.spread.standing * 0.75
  l_36_0.mac10.spread.moving_crouching = l_36_0.new_m4.spread.standing * 0.75
  l_36_0.mac10.spread.moving_steelsight = l_36_0.new_m4.spread.moving_steelsight
  l_36_0.mac10.kick = {}
  l_36_0.mac10.kick.standing = l_36_0.mp9.kick.standing
  l_36_0.mac10.kick.crouching = l_36_0.mac10.kick.standing
  l_36_0.mac10.kick.steelsight = l_36_0.mac10.kick.standing
  l_36_0.mac10.crosshair = {}
  l_36_0.mac10.crosshair.standing = {}
  l_36_0.mac10.crosshair.crouching = {}
  l_36_0.mac10.crosshair.steelsight = {}
  l_36_0.mac10.crosshair.standing.offset = 0.40000000596046
  l_36_0.mac10.crosshair.standing.moving_offset = 0.69999998807907
  l_36_0.mac10.crosshair.standing.kick_offset = 0.60000002384186
  l_36_0.mac10.crosshair.crouching.offset = 0.30000001192093
  l_36_0.mac10.crosshair.crouching.moving_offset = 0.60000002384186
  l_36_0.mac10.crosshair.crouching.kick_offset = 0.40000000596046
  l_36_0.mac10.crosshair.steelsight.hidden = true
  l_36_0.mac10.crosshair.steelsight.offset = 0
  l_36_0.mac10.crosshair.steelsight.moving_offset = 0
  l_36_0.mac10.crosshair.steelsight.kick_offset = 0.40000000596046
  l_36_0.mac10.shake = {}
  l_36_0.mac10.shake.fire_multiplier = 1
  l_36_0.mac10.shake.fire_steelsight_multiplier = -1
  l_36_0.mac10.autohit = l_36_2
  l_36_0.mac10.aim_assist = l_36_7
  l_36_0.mac10.weapon_hold = "mac11"
  l_36_0.mac10.animations = {}
  l_36_0.mac10.animations.equip_id = "equip_mac11_rifle"
  l_36_0.mac10.animations.recoil_steelsight = false
   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

  l_36_0.mac10.stats, {damage = 10, spread = 2}.value, {damage = 10, spread = 2}.extra_ammo, {damage = 10, spread = 2}.suppression, {damage = 10, spread = 2}.concealment, {damage = 10, spread = 2}.zoom, {damage = 10, spread = 2}.spread_moving, {damage = 10, spread = 2}.recoil = {damage = 10, spread = 2}, 1, 6, 7, 27, 3, 7, 4
  l_36_0.serbu = {}
  l_36_0.serbu.category = "shotgun"
  l_36_0.serbu.damage_melee = l_36_4
  l_36_0.serbu.damage_melee_effect_mul = l_36_5
  l_36_0.serbu.sounds = {}
  l_36_0.serbu.sounds.fire = "serbu_fire"
  l_36_0.serbu.sounds.dryfire = "remington_dryfire"
  l_36_0.serbu.sounds.enter_steelsight = "primary_steel_sight_enter"
  l_36_0.serbu.sounds.leave_steelsight = "primary_steel_sight_exit"
  l_36_0.serbu.timers = {}
  l_36_0.serbu.timers.unequip = 0.69999998807907
  l_36_0.serbu.timers.equip = 0.60000002384186
  l_36_0.serbu.name_id = "bm_w_serbu"
  l_36_0.serbu.desc_id = "bm_w_serbu_desc"
  l_36_0.serbu.hud_icon = "r870_shotgun"
  l_36_0.serbu.description_id = "des_r870"
  l_36_0.serbu.hud_ammo = "guis/textures/ammo_shell"
  l_36_0.serbu.muzzleflash = "effects/payday2/particles/weapons/762_auto_fps"
  l_36_0.serbu.shell_ejection = "effects/payday2/particles/weapons/shells/shell_slug_semi"
  l_36_0.serbu.use_data = {}
  l_36_0.serbu.use_data.selection_index = 1
  l_36_0.serbu.use_data.align_place = "right_hand"
  l_36_0.serbu.DAMAGE = 6
  l_36_0.serbu.damage_near = 100
  l_36_0.serbu.damage_far = 3000
  l_36_0.serbu.rays = 6
  l_36_0.serbu.CLIP_AMMO_MAX = 6
  l_36_0.serbu.NR_CLIPS_MAX = math.round(total_damage_secondary / 5.5 / l_36_0.serbu.CLIP_AMMO_MAX)
  l_36_0.serbu.AMMO_MAX = l_36_0.serbu.CLIP_AMMO_MAX * l_36_0.serbu.NR_CLIPS_MAX
  l_36_0.serbu.AMMO_PICKUP = l_36_0:_pickup_chance(l_36_0.serbu.AMMO_MAX, 1)
  l_36_0.serbu.single = {}
  l_36_0.serbu.single.fire_rate = 0.375
  l_36_0.serbu.spread = {}
  l_36_0.serbu.spread.standing = l_36_0.r870.spread.standing
  l_36_0.serbu.spread.crouching = l_36_0.r870.spread.crouching
  l_36_0.serbu.spread.steelsight = l_36_0.r870.spread.steelsight
  l_36_0.serbu.spread.moving_standing = l_36_0.r870.spread.moving_standing
  l_36_0.serbu.spread.moving_crouching = l_36_0.r870.spread.moving_crouching
  l_36_0.serbu.spread.moving_steelsight = l_36_0.r870.spread.moving_steelsight
  l_36_0.serbu.kick = {}
  l_36_0.serbu.kick.standing = l_36_0.r870.kick.standing
  l_36_0.serbu.kick.crouching = l_36_0.serbu.kick.standing
  l_36_0.serbu.kick.steelsight = l_36_0.serbu.kick.standing
  l_36_0.serbu.crosshair = {}
  l_36_0.serbu.crosshair.standing = {}
  l_36_0.serbu.crosshair.crouching = {}
  l_36_0.serbu.crosshair.steelsight = {}
  l_36_0.serbu.crosshair.standing.offset = 0.69999998807907
  l_36_0.serbu.crosshair.standing.moving_offset = 0.69999998807907
  l_36_0.serbu.crosshair.standing.kick_offset = 0.80000001192093
  l_36_0.serbu.crosshair.crouching.offset = 0.64999997615814
  l_36_0.serbu.crosshair.crouching.moving_offset = 0.64999997615814
  l_36_0.serbu.crosshair.crouching.kick_offset = 0.75
  l_36_0.serbu.crosshair.steelsight.hidden = true
  l_36_0.serbu.crosshair.steelsight.offset = 0
  l_36_0.serbu.crosshair.steelsight.moving_offset = 0
  l_36_0.serbu.crosshair.steelsight.kick_offset = 0
  l_36_0.serbu.shake = {}
  l_36_0.serbu.shake.fire_multiplier = 1
  l_36_0.serbu.shake.fire_steelsight_multiplier = -1
  l_36_0.serbu.autohit = l_36_3
  l_36_0.serbu.aim_assist = l_36_8
  l_36_0.serbu.weapon_hold = "r870_shotgun"
  l_36_0.serbu.animations = {}
  l_36_0.serbu.animations.equip_id = "equip_r870_shotgun"
  l_36_0.serbu.animations.recoil_steelsight = true
   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

  l_36_0.serbu.stats, {damage = 22, spread = 5}.value, {damage = 22, spread = 5}.extra_ammo, {damage = 22, spread = 5}.suppression, {damage = 22, spread = 5}.concealment, {damage = 22, spread = 5}.zoom, {damage = 22, spread = 5}.spread_moving, {damage = 22, spread = 5}.recoil = {damage = 22, spread = 5}, 1, 6, 7, 24, 3, 7, 5
  l_36_0.huntsman = {}
  l_36_0.huntsman.category = "shotgun"
  l_36_0.huntsman.upgrade_blocks = {weapon = {"clip_ammo_increase"}}
  l_36_0.huntsman.damage_melee = l_36_4
  l_36_0.huntsman.damage_melee_effect_mul = l_36_5
  l_36_0.huntsman.sounds = {}
  l_36_0.huntsman.sounds.fire = "huntsman_fire"
  l_36_0.huntsman.sounds.dryfire = "remington_dryfire"
  l_36_0.huntsman.sounds.enter_steelsight = "secondary_steel_sight_enter"
  l_36_0.huntsman.sounds.leave_steelsight = "secondary_steel_sight_exit"
  l_36_0.huntsman.timers = {}
  l_36_0.huntsman.timers.reload_not_empty = 2.5
  l_36_0.huntsman.timers.reload_empty = l_36_0.huntsman.timers.reload_not_empty
  l_36_0.huntsman.timers.unequip = 0.69999998807907
  l_36_0.huntsman.timers.equip = 0.60000002384186
  l_36_0.huntsman.name_id = "bm_w_huntsman"
  l_36_0.huntsman.desc_id = "bm_w_huntsman_desc"
  l_36_0.huntsman.hud_icon = "m79"
  l_36_0.huntsman.description_id = "des_huntsman"
  l_36_0.huntsman.hud_ammo = "guis/textures/ammo_grenade"
  l_36_0.huntsman.muzzleflash = "effects/payday2/particles/weapons/762_auto_fps"
  l_36_0.huntsman.shell_ejection = "effects/payday2/particles/weapons/shells/shell_empty"
  l_36_0.huntsman.use_data = {}
  l_36_0.huntsman.use_data.selection_index = 2
  l_36_0.huntsman.use_data.align_place = "right_hand"
  l_36_0.huntsman.DAMAGE = 6
  l_36_0.huntsman.damage_near = 1000
  l_36_0.huntsman.damage_far = 3000
  l_36_0.huntsman.rays = 6
  l_36_0.huntsman.CLIP_AMMO_MAX = 2
  l_36_0.huntsman.NR_CLIPS_MAX = math.round(total_damage_primary / 12 / l_36_0.huntsman.CLIP_AMMO_MAX)
  l_36_0.huntsman.AMMO_MAX = l_36_0.huntsman.CLIP_AMMO_MAX * l_36_0.huntsman.NR_CLIPS_MAX
  l_36_0.huntsman.AMMO_PICKUP = l_36_0:_pickup_chance(l_36_0.huntsman.AMMO_MAX, 1)
  l_36_0.huntsman.single = {}
  l_36_0.huntsman.single.fire_rate = 0.11999999731779
  l_36_0.huntsman.spread = {}
  l_36_0.huntsman.spread.standing = l_36_0.r870.spread.standing
  l_36_0.huntsman.spread.crouching = l_36_0.r870.spread.crouching
  l_36_0.huntsman.spread.steelsight = l_36_0.r870.spread.steelsight
  l_36_0.huntsman.spread.moving_standing = l_36_0.r870.spread.moving_standing
  l_36_0.huntsman.spread.moving_crouching = l_36_0.r870.spread.moving_crouching
  l_36_0.huntsman.spread.moving_steelsight = l_36_0.r870.spread.moving_steelsight
  l_36_0.huntsman.kick = {}
  l_36_0.huntsman.kick.standing = {2.9000000953674, 3, -0.5, 0.5}
  l_36_0.huntsman.kick.crouching = l_36_0.huntsman.kick.standing
  l_36_0.huntsman.kick.steelsight = l_36_0.huntsman.kick.standing
  l_36_0.huntsman.crosshair = {}
  l_36_0.huntsman.crosshair.standing = {}
  l_36_0.huntsman.crosshair.crouching = {}
  l_36_0.huntsman.crosshair.steelsight = {}
  l_36_0.huntsman.crosshair.standing.offset = 0.15999999642372
  l_36_0.huntsman.crosshair.standing.moving_offset = 0.80000001192093
  l_36_0.huntsman.crosshair.standing.kick_offset = 0.60000002384186
  l_36_0.huntsman.crosshair.standing.hidden = true
  l_36_0.huntsman.crosshair.crouching.offset = 0.079999998211861
  l_36_0.huntsman.crosshair.crouching.moving_offset = 0.69999998807907
  l_36_0.huntsman.crosshair.crouching.kick_offset = 0.40000000596046
  l_36_0.huntsman.crosshair.crouching.hidden = true
  l_36_0.huntsman.crosshair.steelsight.hidden = true
  l_36_0.huntsman.crosshair.steelsight.offset = 0
  l_36_0.huntsman.crosshair.steelsight.moving_offset = 0
  l_36_0.huntsman.crosshair.steelsight.kick_offset = 0.10000000149012
  l_36_0.huntsman.shake = {}
  l_36_0.huntsman.shake.fire_multiplier = 2
  l_36_0.huntsman.shake.fire_steelsight_multiplier = 2
  l_36_0.huntsman.autohit = l_36_1
  l_36_0.huntsman.aim_assist = l_36_6
  l_36_0.huntsman.animations = {}
  l_36_0.huntsman.animations.fire = "recoil"
  l_36_0.huntsman.animations.reload = "reload"
  l_36_0.huntsman.animations.reload_not_empty = "reload"
  l_36_0.huntsman.animations.equip_id = "equip_huntsman"
  l_36_0.huntsman.animations.recoil_steelsight = true
   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

  l_36_0.huntsman.stats, {damage = 35, spread = 8}.value, {damage = 35, spread = 8}.extra_ammo, {damage = 35, spread = 8}.suppression, {damage = 35, spread = 8}.concealment, {damage = 35, spread = 8}.zoom, {damage = 35, spread = 8}.spread_moving, {damage = 35, spread = 8}.recoil = {damage = 35, spread = 8}, 1, 6, 7, 21, 3, 7, 6
  l_36_0.b92fs = {}
  l_36_0.b92fs.category = "pistol"
  l_36_0.b92fs.damage_melee = l_36_4
  l_36_0.b92fs.damage_melee_effect_mul = l_36_5
  l_36_0.b92fs.sounds = {}
  l_36_0.b92fs.sounds.fire = "beretta_fire"
  l_36_0.b92fs.sounds.enter_steelsight = "pistol_steel_sight_enter"
  l_36_0.b92fs.sounds.leave_steelsight = "pistol_steel_sight_exit"
  l_36_0.b92fs.sounds.dryfire = "beretta_dryfire"
  l_36_0.b92fs.timers = {}
  l_36_0.b92fs.timers.reload_not_empty = 1.4700000286102
  l_36_0.b92fs.timers.reload_empty = 2.1199998855591
  l_36_0.b92fs.timers.unequip = 0.55000001192093
  l_36_0.b92fs.timers.equip = 0.55000001192093
  l_36_0.b92fs.name_id = "bm_w_b92fs"
  l_36_0.b92fs.desc_id = "bm_w_b92fs_desc"
  l_36_0.b92fs.hud_icon = "beretta92"
  l_36_0.b92fs.description_id = "des_b92fs"
  l_36_0.b92fs.hud_ammo = "guis/textures/ammo_9mm"
  l_36_0.b92fs.muzzleflash = "effects/payday2/particles/weapons/9mm_auto_fps"
  l_36_0.b92fs.muzzleflash_silenced = "effects/payday2/particles/weapons/9mm_auto_silence_fps"
  l_36_0.b92fs.shell_ejection = "effects/payday2/particles/weapons/shells/shell_9mm"
  l_36_0.b92fs.use_data = {}
  l_36_0.b92fs.use_data.selection_index = 1
  l_36_0.b92fs.DAMAGE = 1
  l_36_0.b92fs.CLIP_AMMO_MAX = 14
  l_36_0.b92fs.NR_CLIPS_MAX = math.round(total_damage_secondary / 1 / l_36_0.b92fs.CLIP_AMMO_MAX)
  l_36_0.b92fs.AMMO_MAX = l_36_0.b92fs.CLIP_AMMO_MAX * l_36_0.b92fs.NR_CLIPS_MAX
  l_36_0.b92fs.AMMO_PICKUP = l_36_0:_pickup_chance(l_36_0.b92fs.AMMO_MAX, 1)
  l_36_0.b92fs.single = {}
  l_36_0.b92fs.single.fire_rate = 0.090000003576279
  l_36_0.b92fs.spread = {}
  l_36_0.b92fs.spread.standing = l_36_0.new_m4.spread.standing * 0.5
  l_36_0.b92fs.spread.crouching = l_36_0.new_m4.spread.standing * 0.5
  l_36_0.b92fs.spread.steelsight = l_36_0.new_m4.spread.steelsight
  l_36_0.b92fs.spread.moving_standing = l_36_0.new_m4.spread.standing * 0.5
  l_36_0.b92fs.spread.moving_crouching = l_36_0.new_m4.spread.standing * 0.5
  l_36_0.b92fs.spread.moving_steelsight = l_36_0.new_m4.spread.moving_steelsight
  l_36_0.b92fs.kick = {}
  l_36_0.b92fs.kick.standing = l_36_0.glock_17.kick.standing
  l_36_0.b92fs.kick.crouching = l_36_0.b92fs.kick.standing
  l_36_0.b92fs.kick.steelsight = l_36_0.b92fs.kick.standing
  l_36_0.b92fs.crosshair = {}
  l_36_0.b92fs.crosshair.standing = {}
  l_36_0.b92fs.crosshair.crouching = {}
  l_36_0.b92fs.crosshair.steelsight = {}
  l_36_0.b92fs.crosshair.standing.offset = 0.20000000298023
  l_36_0.b92fs.crosshair.standing.moving_offset = 0.60000002384186
  l_36_0.b92fs.crosshair.standing.kick_offset = 0.40000000596046
  l_36_0.b92fs.crosshair.crouching.offset = 0.10000000149012
  l_36_0.b92fs.crosshair.crouching.moving_offset = 0.60000002384186
  l_36_0.b92fs.crosshair.crouching.kick_offset = 0.30000001192093
  l_36_0.b92fs.crosshair.steelsight.hidden = true
  l_36_0.b92fs.crosshair.steelsight.offset = 0
  l_36_0.b92fs.crosshair.steelsight.moving_offset = 0
  l_36_0.b92fs.crosshair.steelsight.kick_offset = 0.10000000149012
  l_36_0.b92fs.shake = {}
  l_36_0.b92fs.shake.fire_multiplier = 1
  l_36_0.b92fs.shake.fire_steelsight_multiplier = -1
  l_36_0.b92fs.autohit = l_36_2
  l_36_0.b92fs.aim_assist = l_36_7
  l_36_0.b92fs.weapon_hold = "glock"
  l_36_0.b92fs.animations = {}
  l_36_0.b92fs.animations.equip_id = "equip_glock"
  l_36_0.b92fs.animations.recoil_steelsight = true
   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

  l_36_0.b92fs.stats, {damage = 5, spread = 5}.value, {damage = 5, spread = 5}.extra_ammo, {damage = 5, spread = 5}.suppression, {damage = 5, spread = 5}.concealment, {damage = 5, spread = 5}.zoom, {damage = 5, spread = 5}.spread_moving, {damage = 5, spread = 5}.recoil = {damage = 5, spread = 5}, 1, 6, 7, 30, 3, 7, 6
  l_36_0.new_raging_bull = {}
  l_36_0.new_raging_bull.category = "pistol"
  l_36_0.new_raging_bull.upgrade_blocks = {weapon = {"clip_ammo_increase"}}
  l_36_0.new_raging_bull.damage_melee = l_36_4
  l_36_0.new_raging_bull.damage_melee_effect_mul = l_36_5
  l_36_0.new_raging_bull.sounds = {}
  l_36_0.new_raging_bull.sounds.fire = "rbull_fire"
  l_36_0.new_raging_bull.sounds.dryfire = "rbull_dryfire"
  l_36_0.new_raging_bull.sounds.enter_steelsight = "pistol_steel_sight_enter"
  l_36_0.new_raging_bull.sounds.leave_steelsight = "pistol_steel_sight_exit"
  l_36_0.new_raging_bull.timers = {}
  l_36_0.new_raging_bull.timers.reload_not_empty = 2.25
  l_36_0.new_raging_bull.timers.reload_empty = 2.25
  l_36_0.new_raging_bull.timers.unequip = 0.5
  l_36_0.new_raging_bull.timers.equip = 0.5
  l_36_0.new_raging_bull.single = {}
  l_36_0.new_raging_bull.single.fire_rate = 0.20999999344349
  l_36_0.new_raging_bull.name_id = "bm_w_raging_bull"
  l_36_0.new_raging_bull.desc_id = "bm_w_raging_bull_desc"
  l_36_0.new_raging_bull.hud_icon = "raging_bull"
  l_36_0.new_raging_bull.description_id = "des_new_raging_bull"
  l_36_0.new_raging_bull.hud_ammo = "guis/textures/ammo_9mm"
  l_36_0.new_raging_bull.muzzleflash = "effects/payday2/particles/weapons/762_auto_fps"
  l_36_0.new_raging_bull.shell_ejection = "effects/payday2/particles/weapons/shells/shell_empty"
  l_36_0.new_raging_bull.use_data = {}
  l_36_0.new_raging_bull.use_data.selection_index = 1
  l_36_0.new_raging_bull.DAMAGE = 2
  l_36_0.new_raging_bull.CLIP_AMMO_MAX = 6
  l_36_0.new_raging_bull.NR_CLIPS_MAX = math.round(total_damage_secondary / 4.6999998092651 / l_36_0.new_raging_bull.CLIP_AMMO_MAX)
  l_36_0.new_raging_bull.AMMO_MAX = l_36_0.new_raging_bull.CLIP_AMMO_MAX * l_36_0.new_raging_bull.NR_CLIPS_MAX
  l_36_0.new_raging_bull.AMMO_PICKUP = l_36_0:_pickup_chance(l_36_0.new_raging_bull.AMMO_MAX, 1)
  l_36_0.new_raging_bull.spread = {}
  l_36_0.new_raging_bull.spread.standing = l_36_0.new_m4.spread.standing * 0.75
  l_36_0.new_raging_bull.spread.crouching = l_36_0.new_m4.spread.standing * 0.75
  l_36_0.new_raging_bull.spread.steelsight = l_36_0.new_m4.spread.steelsight
  l_36_0.new_raging_bull.spread.moving_standing = l_36_0.new_m4.spread.standing * 0.75
  l_36_0.new_raging_bull.spread.moving_crouching = l_36_0.new_m4.spread.standing * 0.75
  l_36_0.new_raging_bull.spread.moving_steelsight = l_36_0.new_m4.spread.moving_steelsight
  l_36_0.new_raging_bull.kick = {}
  l_36_0.new_raging_bull.kick.standing = l_36_0.glock_17.kick.standing
  l_36_0.new_raging_bull.kick.crouching = l_36_0.new_raging_bull.kick.standing
  l_36_0.new_raging_bull.kick.steelsight = l_36_0.new_raging_bull.kick.standing
  l_36_0.new_raging_bull.crosshair = {}
  l_36_0.new_raging_bull.crosshair.standing = {}
  l_36_0.new_raging_bull.crosshair.crouching = {}
  l_36_0.new_raging_bull.crosshair.steelsight = {}
  l_36_0.new_raging_bull.crosshair.standing.offset = 0.20000000298023
  l_36_0.new_raging_bull.crosshair.standing.moving_offset = 0.60000002384186
  l_36_0.new_raging_bull.crosshair.standing.kick_offset = 0.40000000596046
  l_36_0.new_raging_bull.crosshair.crouching.offset = 0.10000000149012
  l_36_0.new_raging_bull.crosshair.crouching.moving_offset = 0.60000002384186
  l_36_0.new_raging_bull.crosshair.crouching.kick_offset = 0.30000001192093
  l_36_0.new_raging_bull.crosshair.steelsight.hidden = true
  l_36_0.new_raging_bull.crosshair.steelsight.offset = 0
  l_36_0.new_raging_bull.crosshair.steelsight.moving_offset = 0
  l_36_0.new_raging_bull.crosshair.steelsight.kick_offset = 0.10000000149012
  l_36_0.new_raging_bull.shake = {}
  l_36_0.new_raging_bull.shake.fire_multiplier = 1
  l_36_0.new_raging_bull.shake.fire_steelsight_multiplier = -1
  l_36_0.new_raging_bull.autohit = l_36_2
  l_36_0.new_raging_bull.aim_assist = l_36_7
  l_36_0.new_raging_bull.weapon_hold = "raging_bull"
  l_36_0.new_raging_bull.animations = {}
  l_36_0.new_raging_bull.animations.equip_id = "equip_raging_bull"
  l_36_0.new_raging_bull.animations.recoil_steelsight = true
   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

  l_36_0.new_raging_bull.stats, {damage = 23, spread = 5}.value, {damage = 23, spread = 5}.extra_ammo, {damage = 23, spread = 5}.suppression, {damage = 23, spread = 5}.concealment, {damage = 23, spread = 5}.zoom, {damage = 23, spread = 5}.spread_moving, {damage = 23, spread = 5}.recoil = {damage = 23, spread = 5}, 1, 6, 7, 27, 3, 7, 3
  l_36_0.saw = {}
  l_36_0.saw.category = "saw"
  l_36_0.saw.upgrade_blocks = {weapon = {"clip_ammo_increase"}}
  l_36_0.saw.damage_melee = l_36_4
  l_36_0.saw.damage_melee_effect_mul = l_36_5
  l_36_0.saw.sounds = {}
  l_36_0.saw.sounds.fire = "Play_saw_handheld_start"
  l_36_0.saw.sounds.stop_fire = "Play_saw_handheld_end"
  l_36_0.saw.sounds.dryfire = "mp5_dryfire"
  l_36_0.saw.sounds.enter_steelsight = "secondary_steel_sight_enter"
  l_36_0.saw.sounds.leave_steelsight = "secondary_steel_sight_exit"
  l_36_0.saw.timers = {}
  l_36_0.saw.timers.reload_not_empty = 3.2000000476837
  l_36_0.saw.timers.reload_empty = 3.2000000476837
  l_36_0.saw.timers.unequip = 0.69999998807907
  l_36_0.saw.timers.equip = 0.5
  l_36_0.saw.name_id = "bm_w_saw"
  l_36_0.saw.desc_id = "bm_w_saw_desc"
  l_36_0.saw.hud_icon = "equipment_saw"
  l_36_0.saw.description_id = "des_mp5"
  l_36_0.saw.hud_ammo = "guis/textures/ammo_9mm"
  l_36_0.saw.muzzleflash = "effects/payday2/particles/weapons/9mm_auto_fps"
  l_36_0.saw.muzzleflash_silenced = "effects/payday2/particles/weapons/9mm_auto_silence_fps"
  l_36_0.saw.use_data = {}
  l_36_0.saw.use_data.selection_index = 2
  l_36_0.saw.DAMAGE = 0.050000000745058
  l_36_0.saw.CLIP_AMMO_MAX = 100
  l_36_0.saw.NR_CLIPS_MAX = 2
  l_36_0.saw.AMMO_MAX = l_36_0.saw.CLIP_AMMO_MAX * l_36_0.saw.NR_CLIPS_MAX
  l_36_0.saw.AMMO_PICKUP = {0, 0}
  l_36_0.saw.auto = {}
  l_36_0.saw.auto.fire_rate = 0.15000000596046
  l_36_0.saw.spread = {}
  l_36_0.saw.spread.standing = 1
  l_36_0.saw.spread.crouching = 0.70999997854233
  l_36_0.saw.spread.steelsight = 0.47999998927116
  l_36_0.saw.spread.moving_standing = 1.2799999713898
  l_36_0.saw.spread.moving_crouching = 1.5199999809265
  l_36_0.saw.spread.moving_steelsight = 0.47999998927116
  l_36_0.saw.kick = {}
  l_36_0.saw.kick.standing = {1, -1, -1, 1}
  l_36_0.saw.kick.crouching = {1, -1, -1, 1}
  l_36_0.saw.kick.steelsight = {0.72500002384186, -0.72500002384186, -0.72500002384186, 0.72500002384186}
  l_36_0.saw.crosshair = {}
  l_36_0.saw.crosshair.standing = {}
  l_36_0.saw.crosshair.crouching = {}
  l_36_0.saw.crosshair.steelsight = {}
  l_36_0.saw.crosshair.standing.offset = 0.5
  l_36_0.saw.crosshair.standing.moving_offset = 0.60000002384186
  l_36_0.saw.crosshair.standing.kick_offset = 0.69999998807907
  l_36_0.saw.crosshair.crouching.offset = 0.40000000596046
  l_36_0.saw.crosshair.crouching.moving_offset = 0.5
  l_36_0.saw.crosshair.crouching.kick_offset = 0.60000002384186
  l_36_0.saw.crosshair.steelsight.hidden = true
  l_36_0.saw.crosshair.steelsight.offset = 0
  l_36_0.saw.crosshair.steelsight.moving_offset = 0
  l_36_0.saw.crosshair.steelsight.kick_offset = 0
  l_36_0.saw.shake = {}
  l_36_0.saw.shake.fire_multiplier = 1
  l_36_0.saw.shake.fire_steelsight_multiplier = 1
  l_36_0.saw.autohit = l_36_2
  l_36_0.saw.aim_assist = l_36_7
  l_36_0.saw.weapon_hold = "saw"
  l_36_0.saw.animations = {}
  l_36_0.saw.animations.equip_id = "equip_saw"
  l_36_0.saw.animations.recoil_steelsight = false
   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

  l_36_0.saw.stats, {suppression = 9, zoom = 1}.extra_ammo, {suppression = 9, zoom = 1}.value, {suppression = 9, zoom = 1}.concealment, {suppression = 9, zoom = 1}.damage, {suppression = 9, zoom = 1}.spread_moving, {suppression = 9, zoom = 1}.recoil, {suppression = 9, zoom = 1}.spread = {suppression = 9, zoom = 1}, 6, 1, 18, 10, 7, 7, 3
  l_36_0.saw.hit_alert_size_increase = 4
end

WeaponTweakData._create_table_structure = function(l_37_0)
  l_37_0.c45_npc = {usage = "c45", sounds = {}, use_data = {}}
  l_37_0.beretta92_npc = {usage = "beretta92", sounds = {}, use_data = {}}
  l_37_0.raging_bull_npc = {usage = "raging_bull", sounds = {}, use_data = {}}
  l_37_0.m4_npc = {usage = "m4", sounds = {}, use_data = {}, auto = {}}
  l_37_0.m14_npc = {usage = "m4", sounds = {}, use_data = {}, auto = {}}
  l_37_0.m14_sniper_npc = {usage = "m4", sounds = {}, use_data = {}, auto = {}}
  l_37_0.r870_npc = {usage = "r870", sounds = {}, use_data = {}}
  l_37_0.mossberg_npc = {usage = "mossberg", sounds = {}, use_data = {}}
  l_37_0.mp5_npc = {usage = "mp5", sounds = {}, use_data = {}, auto = {}}
  l_37_0.mac11_npc = {usage = "mp5", sounds = {}, use_data = {}, auto = {}}
  l_37_0.m79_npc = {usage = "m4", sounds = {}, use_data = {}, auto = {}}
  l_37_0.glock_18_npc = {usage = "glock18", sounds = {}, use_data = {}, auto = {}}
  l_37_0.ak47_npc = {usage = "ak47", sounds = {}, use_data = {}, auto = {}}
  l_37_0.g36_npc = {usage = "m4", sounds = {}, use_data = {}, auto = {}}
  l_37_0.g17_npc = {usage = "c45", sounds = {}, use_data = {}}
  l_37_0.mp9_npc = {usage = "mp5", sounds = {}, use_data = {}, auto = {}}
  l_37_0.olympic_npc = {usage = "mp5", sounds = {}, use_data = {}, auto = {}}
  l_37_0.m16_npc = {usage = "m4", sounds = {}, use_data = {}, auto = {}}
  l_37_0.aug_npc = {usage = "m4", sounds = {}, use_data = {}, auto = {}}
  l_37_0.ak74_npc = {usage = "ak47", sounds = {}, use_data = {}, auto = {}}
  l_37_0.ak5_npc = {usage = "m4", sounds = {}, use_data = {}, auto = {}}
  l_37_0.p90_npc = {usage = "mp5", sounds = {}, use_data = {}, auto = {}}
  l_37_0.amcar_npc = {usage = "m4", sounds = {}, use_data = {}, auto = {}}
  l_37_0.mac10_npc = {usage = "mp5", sounds = {}, use_data = {}, auto = {}}
  l_37_0.akmsu_npc = {usage = "m4", sounds = {}, use_data = {}, auto = {}}
  l_37_0.akm_npc = {usage = "m4", sounds = {}, use_data = {}, auto = {}}
  l_37_0.deagle_npc = {usage = "raging_bull", sounds = {}, use_data = {}}
  l_37_0.serbu_npc = {usage = "r870", sounds = {}, use_data = {}}
  l_37_0.saiga_npc = {usage = "r870", sounds = {}, use_data = {}}
  l_37_0.huntsman_npc = {usage = "r870", sounds = {}, use_data = {}}
  l_37_0.saw_npc = {usage = "mp5", sounds = {}, use_data = {}}
  l_37_0.sentry_gun = {sounds = {}, auto = {}}
end

WeaponTweakData._precalculate_values = function(l_38_0)
  l_38_0.m4_npc.AMMO_MAX = l_38_0.m4_npc.CLIP_AMMO_MAX * l_38_0.m4_npc.NR_CLIPS_MAX
  l_38_0.m14_npc.AMMO_MAX = l_38_0.m14_npc.CLIP_AMMO_MAX * l_38_0.m14_npc.NR_CLIPS_MAX
  l_38_0.m14_sniper_npc.AMMO_MAX = l_38_0.m14_sniper_npc.CLIP_AMMO_MAX * l_38_0.m14_sniper_npc.NR_CLIPS_MAX
  l_38_0.c45_npc.AMMO_MAX = l_38_0.c45_npc.CLIP_AMMO_MAX * l_38_0.c45_npc.NR_CLIPS_MAX
  l_38_0.beretta92_npc.AMMO_MAX = l_38_0.beretta92_npc.CLIP_AMMO_MAX * l_38_0.beretta92_npc.NR_CLIPS_MAX
  l_38_0.raging_bull_npc.AMMO_MAX = l_38_0.raging_bull_npc.CLIP_AMMO_MAX * l_38_0.raging_bull_npc.NR_CLIPS_MAX
  l_38_0.r870_npc.AMMO_MAX = l_38_0.r870_npc.CLIP_AMMO_MAX * l_38_0.r870_npc.NR_CLIPS_MAX
  l_38_0.mossberg_npc.AMMO_MAX = l_38_0.mossberg_npc.CLIP_AMMO_MAX * l_38_0.mossberg_npc.NR_CLIPS_MAX
  l_38_0.mp5_npc.AMMO_MAX = l_38_0.mp5_npc.CLIP_AMMO_MAX * l_38_0.mp5_npc.NR_CLIPS_MAX
  l_38_0.mac11_npc.AMMO_MAX = l_38_0.mac11_npc.CLIP_AMMO_MAX * l_38_0.mac11_npc.NR_CLIPS_MAX
  l_38_0.glock_18_npc.AMMO_MAX = l_38_0.glock_18_npc.CLIP_AMMO_MAX * l_38_0.glock_18_npc.NR_CLIPS_MAX
  l_38_0.ak47_npc.AMMO_MAX = l_38_0.ak47_npc.CLIP_AMMO_MAX * l_38_0.ak47_npc.NR_CLIPS_MAX
  l_38_0.g36_npc.AMMO_MAX = l_38_0.g36_npc.CLIP_AMMO_MAX * l_38_0.g36_npc.NR_CLIPS_MAX
  l_38_0.g17_npc.AMMO_MAX = l_38_0.g17_npc.CLIP_AMMO_MAX * l_38_0.g17_npc.NR_CLIPS_MAX
  l_38_0.mp9_npc.AMMO_MAX = l_38_0.mp9_npc.CLIP_AMMO_MAX * l_38_0.mp9_npc.NR_CLIPS_MAX
  l_38_0.olympic_npc.AMMO_MAX = l_38_0.olympic_npc.CLIP_AMMO_MAX * l_38_0.olympic_npc.NR_CLIPS_MAX
  l_38_0.m16_npc.AMMO_MAX = l_38_0.m16_npc.CLIP_AMMO_MAX * l_38_0.m16_npc.NR_CLIPS_MAX
  l_38_0.aug_npc.AMMO_MAX = l_38_0.aug_npc.CLIP_AMMO_MAX * l_38_0.aug_npc.NR_CLIPS_MAX
  l_38_0.ak74_npc.AMMO_MAX = l_38_0.ak74_npc.CLIP_AMMO_MAX * l_38_0.ak74_npc.NR_CLIPS_MAX
  l_38_0.ak5_npc.AMMO_MAX = l_38_0.ak5_npc.CLIP_AMMO_MAX * l_38_0.ak5_npc.NR_CLIPS_MAX
  l_38_0.p90_npc.AMMO_MAX = l_38_0.p90_npc.CLIP_AMMO_MAX * l_38_0.p90_npc.NR_CLIPS_MAX
  l_38_0.amcar_npc.AMMO_MAX = l_38_0.amcar_npc.CLIP_AMMO_MAX * l_38_0.amcar_npc.NR_CLIPS_MAX
  l_38_0.mac10_npc.AMMO_MAX = l_38_0.mac10_npc.CLIP_AMMO_MAX * l_38_0.mac10_npc.NR_CLIPS_MAX
  l_38_0.akmsu_npc.AMMO_MAX = l_38_0.akmsu_npc.CLIP_AMMO_MAX * l_38_0.akmsu_npc.NR_CLIPS_MAX
  l_38_0.akm_npc.AMMO_MAX = l_38_0.akm_npc.CLIP_AMMO_MAX * l_38_0.akm_npc.NR_CLIPS_MAX
  l_38_0.deagle_npc.AMMO_MAX = l_38_0.deagle_npc.CLIP_AMMO_MAX * l_38_0.deagle_npc.NR_CLIPS_MAX
  l_38_0.serbu_npc.AMMO_MAX = l_38_0.serbu_npc.CLIP_AMMO_MAX * l_38_0.serbu_npc.NR_CLIPS_MAX
  l_38_0.saiga_npc.AMMO_MAX = l_38_0.saiga_npc.CLIP_AMMO_MAX * l_38_0.saiga_npc.NR_CLIPS_MAX
  l_38_0.huntsman_npc.AMMO_MAX = l_38_0.huntsman_npc.CLIP_AMMO_MAX * l_38_0.huntsman_npc.NR_CLIPS_MAX
  l_38_0.saw_npc.AMMO_MAX = l_38_0.saw_npc.CLIP_AMMO_MAX * l_38_0.saw_npc.NR_CLIPS_MAX
end


