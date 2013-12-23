-- Decompiled using luadec 2.0.1 by sztupy (http://winmo.sztupy.hu)
-- Command line was: F:\SteamLibrary\SteamApps\common\PAYDAY 2\lua\lib\units\beings\player\playerbase.luac 

if not PlayerBase then
  PlayerBase = class(UnitBase)
end
PlayerBase.PLAYER_HUD = Idstring("guis/player_hud")
PlayerBase.PLAYER_INFO_HUD_FULLSCREEN = Idstring("guis/player_info_hud_fullscreen")
PlayerBase.PLAYER_INFO_HUD = Idstring("guis/player_info_hud")
PlayerBase.PLAYER_DOWNED_HUD = Idstring("guis/player_downed_hud")
PlayerBase.PLAYER_CUSTODY_HUD = Idstring("guis/spectator_mode")
PlayerBase.PLAYER_INFO_HUD_PD2 = Idstring("guis/player_info_hud_pd2")
PlayerBase.PLAYER_INFO_HUD_FULLSCREEN_PD2 = Idstring("guis/player_info_hud_fullscreen_pd2")
PlayerBase.init = function(l_1_0, l_1_1)
  UnitBase.init(l_1_0, l_1_1, false)
  l_1_0._unit = l_1_1
  l_1_0:_setup_suspicion_and_detection_data()
  l_1_0:_setup_hud()
  l_1_0._id = managers.player:player_id(l_1_0._unit)
  l_1_0._rumble_pos_callback = callback(l_1_0, l_1_0, "get_rumble_position")
  l_1_0:_setup_controller()
  l_1_0._unit:set_extension_update_enabled(Idstring("base"), false)
  l_1_0._stats_screen_visible = false
  managers.game_play_central:restart_portal_effects()
  l_1_0:_chk_set_unit_upgrades()
end

PlayerBase.update = function(l_2_0, l_2_1, l_2_2, l_2_3)
  if l_2_0._wanted_controller_enabled_t then
    if l_2_0._wanted_controller_enabled_t <= 0 then
      if l_2_0._wanted_controller_enabled then
        l_2_0._controller:set_enabled(true)
        l_2_0._wanted_controller_enabled = nil
        l_2_0._wanted_controller_enabled_t = nil
      end
      l_2_0._unit:set_extension_update_enabled(Idstring("base"), false)
    else
      l_2_0._wanted_controller_enabled_t = l_2_0._wanted_controller_enabled_t - 1
    end
  end
end

PlayerBase._setup_suspicion_and_detection_data = function(l_3_0)
  if not Network:is_server() then
    return 
  end
  l_3_0._suspicion_settings = deep_clone(tweak_data.player.suspicion)
  l_3_0._suspicion_settings.multipliers = {}
  l_3_0._suspicion_settings.init_buildup_mul = l_3_0._suspicion_settings.buildup_mul
  l_3_0._suspicion_settings.init_range_mul = l_3_0._suspicion_settings.range_mul
  l_3_0._detection_settings = {}
  l_3_0._detection_settings.multipliers = {}
  l_3_0._detection_settings.init_delay_mul = 1
  l_3_0._detection_settings.init_range_mul = 1
end

PlayerBase._chk_set_unit_upgrades = function(l_4_0)
  local multiplier = 1
  if managers.player:has_category_upgrade("player", "suspicion_multiplier") then
    multiplier = multiplier * managers.player:upgrade_value("player", "suspicion_multiplier", 1)
  end
  if managers.player:has_category_upgrade("player", "passive_suspicion_multiplier") then
    multiplier = multiplier * managers.player:upgrade_value("player", "passive_suspicion_multiplier", 1)
  end
  if multiplier and multiplier ~= 1 then
    l_4_0:set_suspicion_multiplier("upgrade", multiplier)
  end
  managers.environment_controller:set_flashbang_multiplier(managers.player:upgrade_value("player", "flashbang_multiplier"))
  local is_client = Network:is_client()
  if is_client then
    if managers.player:has_category_upgrade("player", "suspicion_multiplier") then
      local level = managers.player:upgrade_level("player", "suspicion_multiplier")
      managers.network:session():send_to_host("sync_upgrade", "player", "suspicion_multiplier", level)
    end
    if managers.player:has_category_upgrade("player", "passive_suspicion_multiplier") then
      local level = managers.player:upgrade_level("player", "passive_suspicion_multiplier")
      managers.network:session():send_to_host("sync_upgrade", "player", "passive_suspicion_multiplier", level)
    end
    if managers.player:has_category_upgrade("player", "silent_kill") then
      managers.network:session():send_to_host("sync_upgrade", "player", "silent_kill", 1)
    end
    if managers.player:has_category_upgrade("player", "crouch_speed_multiplier") then
      managers.network:session():send_to_host("sync_upgrade", "player", "crouch_speed_multiplier", 1)
    end
    if managers.player:has_category_upgrade("player", "run_speed_multiplier") then
      managers.network:session():send_to_host("sync_upgrade", "player", "run_speed_multiplier", 1)
    end
    if managers.player:has_category_upgrade("player", "silent_drill") then
      managers.network:session():send_to_host("sync_upgrade", "player", "silent_drill", 1)
    end
    if managers.player:has_category_upgrade("player", "drill_alert_rad") then
      managers.network:session():send_to_host("sync_upgrade", "player", "drill_alert_rad", 1)
    end
    if managers.player:has_category_upgrade("player", "drill_autorepair") then
      managers.network:session():send_to_host("sync_upgrade", "player", "drill_autorepair", 1)
    end
    if managers.player:has_category_upgrade("player", "intimidate_enemies") then
      managers.network:session():send_to_host("sync_upgrade", "player", "intimidate_enemies", 1)
    end
    if managers.player:has_category_upgrade("player", "intimidate_specials") then
      managers.network:session():send_to_host("sync_upgrade", "player", "intimidate_specials", 1)
    end
    if managers.player:has_category_upgrade("player", "empowered_intimidation_mul") then
      managers.network:session():send_to_host("sync_upgrade", "player", "empowered_intimidation_mul", 1)
    end
    if managers.player:has_category_upgrade("player", "intimidation_multiplier") then
      managers.network:session():send_to_host("sync_upgrade", "player", "intimidation_multiplier", 1)
    end
    if managers.player:has_category_upgrade("player", "intimidate_aura") then
      local level = managers.player:upgrade_level("player", "intimidate_aura")
      managers.network:session():send_to_host("sync_upgrade", "player", "intimidate_aura", level)
    end
    if managers.player:has_category_upgrade("player", "uncover_progress_mul") then
      local level = managers.player:upgrade_level("player", "uncover_progress_mul")
      managers.network:session():send_to_host("sync_upgrade", "player", "uncover_progress_mul", level)
    end
    if managers.player:has_category_upgrade("player", "uncover_progress_decay_mul") then
      local level = managers.player:upgrade_level("player", "uncover_progress_decay_mul")
      managers.network:session():send_to_host("sync_upgrade", "player", "uncover_progress_decay_mul", level)
    end
    if managers.player:has_category_upgrade("player", "civilian_gives_ammo") then
      managers.network:session():send_to_host("sync_upgrade", "player", "civilian_gives_ammo", 1)
    end
    if managers.player:has_category_upgrade("player", "drill_speed_multiplier") then
      local level = managers.player:upgrade_level("player", "drill_speed_multiplier")
      managers.network:session():send_to_host("sync_upgrade", "player", "drill_speed_multiplier", level)
    end
    if managers.player:has_category_upgrade("player", "saw_speed_multiplier") then
      local level = managers.player:upgrade_level("player", "saw_speed_multiplier")
      managers.network:session():send_to_host("sync_upgrade", "player", "saw_speed_multiplier", level)
    end
    if managers.player:has_category_upgrade("player", "camouflage_bonus") then
      managers.network:session():send_to_host("sync_upgrade", "player", "camouflage_bonus", 1)
    end
    if managers.player:has_category_upgrade("sentry_gun", "spread_multiplier") then
      managers.network:session():send_to_host("sync_upgrade", "sentry_gun", "spread_multiplier", 1)
    end
    if managers.player:has_category_upgrade("sentry_gun", "rot_speed_multiplier") then
      managers.network:session():send_to_host("sync_upgrade", "sentry_gun", "rot_speed_multiplier", 1)
    end
    if managers.player:has_category_upgrade("sentry_gun", "shield") then
      managers.network:session():send_to_host("sync_upgrade", "sentry_gun", "shield", 1)
    end
    if managers.player:has_category_upgrade("ecm_jammer", "affects_cameras") then
      managers.network:session():send_to_host("sync_upgrade", "ecm_jammer", "affects_cameras", 1)
    end
    if managers.player:has_category_upgrade("ecm_jammer", "feedback_duration_boost") then
      managers.network:session():send_to_host("sync_upgrade", "ecm_jammer", "feedback_duration_boost", 1)
    end
    if managers.player:has_category_upgrade("ecm_jammer", "feedback_duration_boost_2") then
      managers.network:session():send_to_host("sync_upgrade", "ecm_jammer", "feedback_duration_boost_2", 1)
    end
    if managers.player:has_category_upgrade("player", "convert_enemies_health_multiplier") then
      local level = managers.player:upgrade_level("player", "convert_enemies_health_multiplier")
      managers.network:session():send_to_host("sync_upgrade", "player", "convert_enemies_health_multiplier", level)
    end
    if managers.player:has_category_upgrade("player", "passive_convert_enemies_health_multiplier") then
      local level = managers.player:upgrade_level("player", "passive_convert_enemies_health_multiplier")
      managers.network:session():send_to_host("sync_upgrade", "player", "passive_convert_enemies_health_multiplier", level)
    end
    if managers.player:has_category_upgrade("player", "convert_enemies_damage_multiplier") then
      local level = managers.player:upgrade_level("player", "convert_enemies_damage_multiplier")
      managers.network:session():send_to_host("sync_upgrade", "player", "convert_enemies_damage_multiplier", level)
    end
    if managers.player:has_category_upgrade("player", "passive_convert_enemies_damage_multiplier") then
      local level = managers.player:upgrade_level("player", "passive_convert_enemies_damage_multiplier")
      managers.network:session():send_to_host("sync_upgrade", "player", "passive_convert_enemies_damage_multiplier", level)
    end
    if managers.player:has_category_upgrade("player", "corpse_alarm_pager_bluff") then
      local level = managers.player:upgrade_level("player", "corpse_alarm_pager_bluff")
      managers.network:session():send_to_host("sync_upgrade", "player", "corpse_alarm_pager_bluff", level)
    end
    if managers.player:has_category_upgrade("player", "civ_harmless_bullets") then
      managers.network:session():send_to_host("sync_upgrade", "player", "civ_harmless_bullets", 1)
    end
    if managers.player:has_category_upgrade("player", "civ_harmless_melee") then
      managers.network:session():send_to_host("sync_upgrade", "player", "civ_harmless_melee", 1)
    end
    if managers.player:has_category_upgrade("player", "civ_calming_alerts") then
      managers.network:session():send_to_host("sync_upgrade", "player", "civ_calming_alerts", 1)
    end
    if managers.player:has_category_upgrade("player", "convert_enemies_max_minions") then
      local level = managers.player:upgrade_level("player", "convert_enemies_max_minions")
      managers.network:session():send_to_host("sync_upgrade", "player", "convert_enemies_max_minions", level)
    end
  end
end

PlayerBase.stats_screen_visible = function(l_5_0)
  return l_5_0._stats_screen_visible
end

PlayerBase.set_stats_screen_visible = function(l_6_0, l_6_1)
  l_6_0._stats_screen_visible = l_6_1
  if l_6_0._stats_screen_visible then
    managers.hud:show_stats_screen()
  else
    managers.hud:hide_stats_screen()
  end
end

PlayerBase.set_enabled = function(l_7_0, l_7_1)
  l_7_0._unit:set_extension_update_enabled(Idstring("movement"), l_7_1)
end

PlayerBase.set_visible = function(l_8_0, l_8_1)
  l_8_0._unit:set_visible(l_8_1)
  l_8_0._unit:camera():camera_unit():set_visible(l_8_1)
  if l_8_1 then
    l_8_0._unit:inventory():show_equipped_unit()
  else
    l_8_0._unit:inventory():hide_equipped_unit()
  end
end

PlayerBase._setup_hud = function(l_9_0)
  if not managers.hud:exists(l_9_0.PLAYER_HUD) then
    managers.hud:load_hud(l_9_0.PLAYER_HUD, false, false, true, {})
  end
  if not managers.hud:exists(l_9_0.PLAYER_INFO_HUD_FULLSCREEN) then
    managers.hud:load_hud(l_9_0.PLAYER_INFO_HUD_FULLSCREEN, false, false, false, {})
  end
  if not managers.hud:exists(l_9_0.PLAYER_INFO_HUD) then
    managers.hud:load_hud(l_9_0.PLAYER_INFO_HUD, false, false, true, {})
  end
  if not managers.hud:exists(l_9_0.PLAYER_DOWNED_HUD) then
    managers.hud:load_hud(l_9_0.PLAYER_DOWNED_HUD, false, false, true, {})
  end
end

PlayerBase._equip_default_weapon = function(l_10_0)
end

PlayerBase.post_init = function(l_11_0)
  l_11_0._unit:movement():post_init()
  l_11_0:_equip_default_weapon()
  if l_11_0._unit:movement():nav_tracker() then
    managers.groupai:state():register_criminal(l_11_0._unit)
  else
    l_11_0._unregistered = true
  end
  l_11_0._unit:character_damage():post_init()
  if Network:is_server() then
    local suspicion_mul, max_index = managers.blackmarket:get_suspicion_of_peer(Global.local_member:peer())
    l_11_0:set_suspicion_multiplier("equipment", suspicion_mul)
    l_11_0:set_detection_multiplier("equipment", 1 / suspicion_mul)
  end
end

PlayerBase._setup_controller = function(l_12_0)
  l_12_0._controller = managers.controller:create_controller("player_" .. tostring(l_12_0._id), nil, false)
  managers.rumble:register_controller(l_12_0._controller, l_12_0._rumble_pos_callback)
end

PlayerBase.id = function(l_13_0)
  return l_13_0._id
end

PlayerBase.nick_name = function(l_14_0)
  return Global.local_member:peer():name()
end

PlayerBase.set_controller_enabled = function(l_15_0, l_15_1)
  if not l_15_0._controller then
    return 
  end
  if not l_15_1 then
    l_15_0._controller:set_enabled(false)
  end
  l_15_0._wanted_controller_enabled = l_15_1
  if l_15_0._wanted_controller_enabled then
    l_15_0._wanted_controller_enabled_t = 1
    l_15_0._unit:set_extension_update_enabled(Idstring("base"), true)
  end
end

PlayerBase.controller = function(l_16_0)
  return l_16_0._controller
end

PlayerBase.anim_data_clbk_footstep = function(l_17_0, l_17_1)
  local obj = l_17_0._unit:orientation_object()
  local proj_dir = math.UP
  local proj_from = obj:position()
  local proj_to = proj_from - proj_dir * 30
  local material_name, pos, norm = World:pick_decal_material(proj_from, proj_to, managers.slot:get_mask("surface_move"))
  l_17_0._unit:sound():play_footstep(l_17_1, material_name)
end

PlayerBase.get_rumble_position = function(l_18_0)
  return l_18_0._unit:position() + math.UP * 100
end

PlayerBase.replenish = function(l_19_0)
  for id,weapon in pairs(l_19_0._unit:inventory():available_selections()) do
    if alive(weapon.unit) then
      weapon.unit:base():replenish()
      managers.hud:set_ammo_amount(id, weapon.unit:base():ammo_info())
    end
  end
  l_19_0._unit:character_damage():replenish()
end

PlayerBase.suspicion_settings = function(l_20_0)
  return l_20_0._suspicion_settings
end

PlayerBase.detection_settings = function(l_21_0)
  return l_21_0._detection_settings
end

PlayerBase.set_suspicion_multiplier = function(l_22_0, l_22_1, l_22_2)
  if not Network:is_server() then
    return 
  end
  l_22_0._suspicion_settings.multipliers[l_22_1] = l_22_2
  local buildup_mul = l_22_0._suspicion_settings.init_buildup_mul
  local range_mul = l_22_0._suspicion_settings.init_range_mul
  for reason,mul in pairs(l_22_0._suspicion_settings.multipliers) do
    buildup_mul = buildup_mul * mul
  end
  l_22_0._suspicion_settings.buildup_mul = buildup_mul
  l_22_0._suspicion_settings.range_mul = range_mul
end

PlayerBase.set_detection_multiplier = function(l_23_0, l_23_1, l_23_2)
  if not Network:is_server() then
    return 
  end
  l_23_0._detection_settings.multipliers[l_23_1] = l_23_2
  local delay_mul = l_23_0._detection_settings.init_delay_mul
  local range_mul = l_23_0._detection_settings.init_range_mul
  for reason,mul in pairs(l_23_0._detection_settings.multipliers) do
    delay_mul = delay_mul * mul
    range_mul = range_mul * mul
  end
  l_23_0._detection_settings.delay_mul = delay_mul
  l_23_0._detection_settings.range_mul = range_mul
end

PlayerBase.arrest_settings = function(l_24_0)
  return tweak_data.player.arrest
end

PlayerBase._unregister = function(l_25_0)
  if not l_25_0._unregistered then
    l_25_0._unit:movement():attention_handler():set_attention(nil)
    managers.groupai:state():unregister_criminal(l_25_0._unit)
    l_25_0._unregistered = true
  end
end

PlayerBase.pre_destroy = function(l_26_0, l_26_1)
  l_26_0:_unregister()
  UnitBase.pre_destroy(l_26_0, l_26_1)
  managers.player:player_destroyed(l_26_0._id)
  if l_26_0._controller then
    managers.rumble:unregister_controller(l_26_0._controller, l_26_0._rumble_pos_callback)
    l_26_0._controller:destroy()
    l_26_0._controller = nil
  end
  if managers.hud:alive(l_26_0.PLAYER_HUD) then
    managers.hud:clear_weapons()
    managers.hud:hide(l_26_0.PLAYER_HUD)
  end
  l_26_0:set_stats_screen_visible(false)
  if Global.local_member then
    Global.local_member:set_unit(nil)
  end
  l_26_1:movement():pre_destroy(l_26_1)
  l_26_1:inventory():pre_destroy(l_26_1)
  l_26_1:character_damage():pre_destroy()
end


