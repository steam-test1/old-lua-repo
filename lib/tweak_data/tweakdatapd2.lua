-- Decompiled using luadec 2.0.1 by sztupy (http://winmo.sztupy.hu)
-- Command line was: F:\SteamLibrary\SteamApps\common\PAYDAY 2\lua\lib\tweak_data\tweakdatapd2.luac 

TweakData._init_pd2 = function(l_1_0)
  print("TweakData:_init_pd2()")
  l_1_0.hud_players = {}
  l_1_0.hud_players.name_font = "fonts/font_small_mf"
  l_1_0.hud_players.name_size = 19
  l_1_0.hud_players.ammo_font = "fonts/font_large_mf"
  l_1_0.hud_players.ammo_size = 24
  l_1_0.hud_players.timer_font = "fonts/font_medium_shadow_mf"
  l_1_0.hud_players.timer_size = 30
  l_1_0.hud_players.timer_flash_size = 50
  l_1_0.hud_present = {}
  l_1_0.hud_present.title_font = "fonts/font_medium_mf"
  l_1_0.hud_present.title_size = 28
  l_1_0.hud_present.text_font = "fonts/font_medium_mf"
  l_1_0.hud_present.text_size = 28
  l_1_0.hud_mask_off = {}
  l_1_0.hud_mask_off.text_size = 28
  l_1_0.hud_mask_off.text_font = "fonts/font_medium_mf"
  l_1_0.hud_stats = {}
  l_1_0.hud_stats.objectives_font = "fonts/font_medium_mf"
  l_1_0.hud_stats.objective_desc_font = "fonts/font_medium_mf"
  l_1_0.hud_stats.objectives_title_size = 28
  l_1_0.hud_stats.objectives_size = 24
  l_1_0.hud_stats.loot_size = 24
  l_1_0.hud_stats.loot_title_size = 28
  l_1_0.hud_stats.day_description_size = 22
  l_1_0.hud_stats.potential_xp_color = Color(0, 0.66666668653488, 1)
  l_1_0.hud_corner = {}
  l_1_0.hud_corner.assault_font = "fonts/font_medium_mf"
  l_1_0.hud_corner.assault_size = 24
  l_1_0.hud_corner.noreturn_size = 24
  l_1_0.hud_corner.numhostages_size = 24
  l_1_0.hud_downed = {}
  l_1_0.hud_downed.timer_message_size = 24
  l_1_0.hud_custody = {}
  l_1_0.hud_custody.custody_font = "fonts/font_medium_mf"
  l_1_0.hud_custody.custody_font_large = "fonts/font_large_mf"
  l_1_0.hud_custody.font_size = 28
  l_1_0.hud_custody.small_font_size = 24
  l_1_0.hud_icons.bag_icon = {texture = "guis/textures/pd2/hud_tabs", texture_rect = {2, 34, 20, 17}}
  l_1_0.hud_icons.pd2_mask_1 = {texture = "guis/textures/pd2/masks", texture_rect = {0, 0, 64, 64}}
  l_1_0.hud_icons.pd2_mask_2 = {texture = "guis/textures/pd2/masks", texture_rect = {64, 0, 64, 64}}
  l_1_0.hud_icons.pd2_mask_3 = {texture = "guis/textures/pd2/masks", texture_rect = {64, 64, 64, 64}}
  l_1_0.hud_icons.pd2_mask_4 = {texture = "guis/textures/pd2/masks", texture_rect = {0, 64, 64, 64}}
  l_1_0.hud_icons.equipment_bg = {texture = "guis/textures/pd2/equipment", texture_rect = {64, 32, 32, 32}}
  l_1_0.hud_icons.equipment_cable_ties = {texture = "guis/textures/pd2/equipment", texture_rect = {0, 0, 32, 32}}
  l_1_0.hud_icons.equipment_ammo_bag = {texture = "guis/textures/pd2/equipment", texture_rect = {0, 32, 32, 32}}
  l_1_0.hud_icons.equipment_doctor_bag = {texture = "guis/textures/pd2/equipment", texture_rect = {96, 0, 32, 32}}
  l_1_0.hud_icons.equipment_sentry = {texture = "guis/textures/pd2/equipment", texture_rect = {32, 32, 32, 32}}
  l_1_0.hud_icons.equipment_trip_mine = {texture = "guis/textures/pd2/equipment", texture_rect = {64, 0, 32, 32}}
  l_1_0.hud_icons.equipment_ecm_jammer = {texture = "guis/textures/pd2/equipment", texture_rect = {32, 0, 32, 32}}
  l_1_0.hud_icons.equipment_extra_cable_ties = {texture = "guis/textures/pd2/equipment", texture_rect = {192, 64, 64, 64}}
  l_1_0.hud_icons.equipment_armor = {texture = "guis/textures/pd2/equipment", texture_rect = {128, 0, 64, 64}}
  l_1_0.hud_icons.equipment_thick_skin = {texture = "guis/textures/pd2/equipment", texture_rect = {128, 0, 64, 64}}
  l_1_0.hud_icons.equipment_extra_start_out_ammo = {texture = "guis/textures/pd2/equipment", texture_rect = {128, 64, 64, 64}}
  l_1_0.hud_icons.equipment_toolset = {texture = "guis/textures/pd2/equipment", texture_rect = {192, 0, 64, 64}}
  l_1_0.hud_icons.equipment_chavez_key = {texture = "guis/textures/pd2/mission_equipment", texture_rect = {0, 0, 42, 42}}
  l_1_0.hud_icons.equipment_bank_manager_key = {texture = "guis/textures/pd2/hud_pickups", texture_rect = {32, 0, 32, 32}}
  l_1_0.hud_icons.equipment_drill = {texture = "guis/textures/pd2/hud_pickups", texture_rect = {0, 0, 32, 32}}
  l_1_0.hud_icons.equipment_thermite = {texture = "guis/textures/pd2/hud_pickups", texture_rect = {64, 0, 32, 32}}
  l_1_0.hud_icons.equipment_c4 = {texture = "guis/textures/pd2/hud_pickups", texture_rect = {96, 0, 32, 32}}
  l_1_0.hud_icons.equipment_saw = {texture = "guis/textures/pd2/mission_equipment", texture_rect = {42, 84, 42, 42}}
  l_1_0.hud_icons.equipment_cutter = {texture = "guis/textures/pd2/mission_equipment", texture_rect = {42, 84, 42, 42}}
  l_1_0.hud_icons.equipment_gasoline = {texture = "guis/textures/pd2/hud_pickups", texture_rect = {64, 0, 32, 32}}
  l_1_0.hud_icons.equipment_planks = {texture = "guis/textures/pd2/hud_pickups", texture_rect = {0, 32, 32, 32}}
  l_1_0.hud_icons.equipment_muriatic_acid = {texture = "guis/textures/pd2/hud_pickups", texture_rect = {32, 32, 32, 32}}
  l_1_0.hud_icons.equipment_hydrogen_chloride = {texture = "guis/textures/pd2/hud_pickups", texture_rect = {64, 32, 32, 32}}
  l_1_0.hud_icons.equipment_caustic_soda = {texture = "guis/textures/pd2/hud_pickups", texture_rect = {96, 32, 32, 32}}
  l_1_0.hud_icons.ak = {texture = "guis/textures/pd2/weapons", texture_rect = {0, 0, 64, 64}}
  l_1_0.hud_icons.hk21 = {texture = "guis/textures/pd2/weapons", texture_rect = {64, 64, 64, 64}}
  l_1_0.hud_icons.mac11 = {texture = "guis/textures/pd2/weapons", texture_rect = {64, 0, 64, 64}}
  l_1_0.hud_icons.glock = {texture = "guis/textures/pd2/weapons", texture_rect = {0, 64, 64, 64}}
  l_1_0.hud_icons.beretta92 = {texture = "guis/textures/pd2/weapons", texture_rect = {128, 128, 64, 64}}
  l_1_0.hud_icons.m4 = {texture = "guis/textures/pd2/weapons", texture_rect = {128, 0, 64, 64}}
  l_1_0.hud_icons.r870_shotgun = {texture = "guis/textures/pd2/weapons", texture_rect = {64, 128, 64, 64}}
  l_1_0.hud_icons.mp5 = {texture = "guis/textures/pd2/weapons", texture_rect = {0, 192, 64, 64}}
  l_1_0.hud_icons.c45 = {texture = "guis/textures/pd2/weapons", texture_rect = {192, 0, 64, 64}}
  l_1_0.hud_icons.raging_bull = {texture = "guis/textures/pd2/weapons", texture_rect = {0, 128, 64, 64}}
  l_1_0.hud_icons.mossberg = {texture = "guis/textures/pd2/weapons", texture_rect = {192, 64, 64, 64}}
  l_1_0.hud_icons.m14 = {texture = "guis/textures/pd2/weapons", texture_rect = {192, 128, 64, 64}}
  l_1_0.hud_icons.m79 = {texture = "guis/textures/pd2/weapons", texture_rect = {128, 64, 64, 64}}
  l_1_0.hud_icons.risk_pd = {texture = "guis/textures/pd2/hud_difficultymarkers", texture_rect = {90, 0, 30, 30}}
  l_1_0.hud_icons.risk_swat = {texture = "guis/textures/pd2/hud_difficultymarkers", texture_rect = {0, 0, 30, 30}}
  l_1_0.hud_icons.risk_fbi = {texture = "guis/textures/pd2/hud_difficultymarkers", texture_rect = {30, 0, 30, 30}}
  l_1_0.hud_icons.risk_death_squad = {texture = "guis/textures/pd2/hud_difficultymarkers", texture_rect = {60, 0, 30, 30}}
end


