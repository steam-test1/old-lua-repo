-- Decompiled using luadec 2.0.1 by sztupy (http://winmo.sztupy.hu)
-- Command line was: F:\SteamLibrary\SteamApps\common\PAYDAY 2\lua\lib\units\beings\player\playerdamage.luac 

if not PlayerDamage then
  PlayerDamage = class()
end
PlayerDamage._HEALTH_INIT = tweak_data.player.damage.HEALTH_INIT
PlayerDamage._ARMOR_INIT = tweak_data.player.damage.ARMOR_INIT
PlayerDamage._ARMOR_STEPS = tweak_data.player.damage.ARMOR_STEPS
PlayerDamage._ARMOR_DAMAGE_REDUCTION = tweak_data.player.damage.ARMOR_DAMAGE_REDUCTION
PlayerDamage._ARMOR_DAMAGE_REDUCTION_STEPS = tweak_data.player.damage.ARMOR_DAMAGE_REDUCTION_STEPS
PlayerDamage.init = function(l_1_0, l_1_1)
  l_1_0._unit = l_1_1
  l_1_0._revives = Application:digest_value(0, true)
  l_1_0:replenish()
  l_1_0._bleed_out_health = Application:digest_value(tweak_data.player.damage.BLEED_OUT_HEALTH_INIT * managers.player:upgrade_value("player", "bleed_out_health_multiplier", 1), true)
  l_1_0._god_mode = Global.god_mode
  l_1_0._invulnerable = false
  l_1_0._gui = Overlay:newgui()
  l_1_0._ws = l_1_0._gui:create_screen_workspace()
  l_1_0._focus_delay_mul = 1
  l_1_0._listener_holder = EventListenerHolder:new()
  l_1_0._dmg_interval = tweak_data.player.damage.MIN_DAMAGE_INTERVAL
  l_1_0._next_allowed_dmg_t = Application:digest_value(-100, true)
  l_1_0._last_received_dmg = 0
  l_1_0._next_allowed_sup_t = -100
  l_1_0._last_received_sup = 0
  l_1_0._supperssion_data = {}
end

PlayerDamage.post_init = function(l_2_0)
  l_2_0:_send_set_armor()
  l_2_0:_send_set_health()
end

PlayerDamage.update = function(l_3_0, l_3_1, l_3_2, l_3_3)
  if l_3_0._regenerate_timer and not l_3_0._dead and not l_3_0._bleed_out then
    l_3_0._regenerate_timer = l_3_0._regenerate_timer - l_3_3
    local top_fade = math.clamp(l_3_0._hurt_value - 0.80000001192093, 0, 1) / 0.20000000298023
    local hurt = l_3_0._hurt_value - (1 - top_fade) * ((1 + math.sin(l_3_2 * 500)) / 2) / 10
    managers.environment_controller:set_hurt_value(hurt)
    if l_3_0._regenerate_timer < 0 then
      l_3_0:_regenerate_armor()
    elseif l_3_0._hurt_value then
      if not l_3_0._bleed_out then
        l_3_0._hurt_value = math.min(1, l_3_0._hurt_value + l_3_3)
        local top_fade = math.clamp(l_3_0._hurt_value - 0.80000001192093, 0, 1) / 0.20000000298023
        local hurt = l_3_0._hurt_value - (1 - top_fade) * ((1 + math.sin(l_3_2 * 500)) / 2) / 10
        managers.environment_controller:set_hurt_value(hurt)
        local armor_value = math.max(l_3_0._armor_value or 0, l_3_0._hurt_value)
        managers.hud:set_player_armor({current = l_3_0:get_real_armor() * armor_value, total = l_3_0:_total_armor(), max = l_3_0:_max_armor()})
        SoundDevice:set_rtpc("shield_status", l_3_0._hurt_value * 100)
        if l_3_0._hurt_value >= 1 then
          l_3_0._hurt_value = nil
          managers.environment_controller:set_hurt_value(1)
        else
          local hurt = l_3_0._hurt_value - (1 + math.sin(l_3_2 * 500)) / 2 / 10
          managers.environment_controller:set_hurt_value(hurt)
        end
      end
    end
  end
  if l_3_0._tinnitus_data then
    l_3_0._tinnitus_data.intensity = (l_3_0._tinnitus_data.end_t - l_3_2) / l_3_0._tinnitus_data.duration
    if l_3_0._tinnitus_data.intensity <= 0 then
      l_3_0:_stop_tinnitus()
    else
      SoundDevice:set_rtpc("downed_state_progression", math.max(l_3_0._downed_progression or 0, l_3_0._tinnitus_data.intensity * 100))
    end
  end
  if not l_3_0._downed_timer and l_3_0._downed_progression then
    l_3_0._downed_progression = math.max(0, l_3_0._downed_progression - l_3_3 * 50)
    managers.environment_controller:set_downed_value(l_3_0._downed_progression)
    SoundDevice:set_rtpc("downed_state_progression", l_3_0._downed_progression)
    if l_3_0._downed_progression == 0 then
      l_3_0._unit:sound():play("critical_state_heart_stop")
      l_3_0._downed_progression = nil
    end
  end
  if l_3_0._auto_revive_timer then
    if not managers.platform:presence() == "Playing" or not l_3_0._bleed_out or l_3_0._dead or l_3_0:incapacitated() or l_3_0:arrested() then
      l_3_0._auto_revive_timer = nil
    else
      l_3_0._auto_revive_timer = l_3_0._auto_revive_timer - l_3_3
      if l_3_0._auto_revive_timer <= 0 then
        l_3_0:revive(true)
        l_3_0._auto_revive_timer = nil
      end
    end
  end
  if l_3_0._revive_miss then
    l_3_0._revive_miss = l_3_0._revive_miss - l_3_3
    if l_3_0._revive_miss <= 0 then
      l_3_0._revive_miss = nil
    end
  end
  l_3_0:_upd_suppression(l_3_2, l_3_3)
  if not l_3_0._dead and not l_3_0._bleed_out then
    l_3_0:_upd_health_regen(l_3_2, l_3_3)
  end
end

PlayerDamage.recover_health = function(l_4_0)
  if managers.platform:presence() == "Playing" and (l_4_0:arrested() or l_4_0:need_revive()) then
    l_4_0:revive(true)
  end
  l_4_0:_regenerated(true)
  managers.hud:set_player_health({current = l_4_0:get_real_health(), total = l_4_0:_max_health(), revives = Application:digest_value(l_4_0._revives, false)})
end

PlayerDamage.replenish = function(l_5_0)
  if managers.platform:presence() == "Playing" and (l_5_0:arrested() or l_5_0:need_revive()) then
    l_5_0:revive(true)
  end
  l_5_0:_regenerated()
  l_5_0:_regenerate_armor()
  managers.hud:set_player_health({current = l_5_0:get_real_health(), total = l_5_0:_max_health(), revives = Application:digest_value(l_5_0._revives, false)})
  managers.hud:set_player_armor({current = l_5_0:get_real_armor(), total = l_5_0:_total_armor(), max = l_5_0:_max_armor()})
  SoundDevice:set_rtpc("shield_status", 100)
  SoundDevice:set_rtpc("downed_state_progression", 0)
end

PlayerDamage._regenerate_armor = function(l_6_0)
  if l_6_0._unit:sound() then
    l_6_0._unit:sound():play("shield_full_indicator")
  end
  l_6_0:set_armor(l_6_0:_max_armor())
  l_6_0._regenerate_timer = nil
  l_6_0:_send_set_armor()
end

PlayerDamage._regenerated = function(l_7_0, l_7_1)
  l_7_0:set_health(l_7_0:_max_health())
  l_7_0:_send_set_health()
  l_7_0:_set_health_effect()
  l_7_0._said_hurt = false
  l_7_0._revives = Application:digest_value(tweak_data.player.damage.LIVES_INIT + managers.player:upgrade_value("player", "additional_lives", 0), true)
  l_7_0._revive_health_i = 1
  managers.environment_controller:set_last_life(false)
  l_7_0._down_time = tweak_data.player.damage.DOWNED_TIME
  l_7_0._regenerate_timer = nil
  if not l_7_1 then
    l_7_0._messiah_charges = managers.player:upgrade_value("player", "pistol_revive_from_bleed_out", 0)
  end
end

PlayerDamage.consume_messiah_charge = function(l_8_0)
  if l_8_0:got_messiah_charges() then
    l_8_0._messiah_charges = l_8_0._messiah_charges - 1
    return true
  end
  return false
end

PlayerDamage.got_messiah_charges = function(l_9_0)
  return not l_9_0._messiah_charges or l_9_0._messiah_charges > 0
end

PlayerDamage.get_real_health = function(l_10_0)
  return Application:digest_value(l_10_0._health, false)
end

PlayerDamage.get_real_armor = function(l_11_0)
  return Application:digest_value(l_11_0._armor, false)
end

PlayerDamage.change_health = function(l_12_0, l_12_1)
  l_12_0:set_health(l_12_0:get_real_health() + l_12_1)
end

PlayerDamage.set_health = function(l_13_0, l_13_1)
  local max_health = l_13_0:_max_health()
  l_13_0._health = Application:digest_value(math.clamp(l_13_1, 0, max_health), true)
  l_13_0:_send_set_health()
  l_13_0:_set_health_effect()
  managers.hud:set_player_health({current = l_13_0:get_real_health(), total = max_health, revives = Application:digest_value(l_13_0._revives, false)})
end

PlayerDamage.set_armor = function(l_14_0, l_14_1)
  l_14_0._armor = Application:digest_value(math.clamp(l_14_1, 0, l_14_0:_max_armor()), true)
end

PlayerDamage.down_time = function(l_15_0)
  return l_15_0._down_time
end

PlayerDamage.health_ratio = function(l_16_0)
  return l_16_0:get_real_health() / l_16_0:_max_health()
end

PlayerDamage._max_health = function(l_17_0)
  return (l_17_0._HEALTH_INIT + managers.player:thick_skin_value()) * managers.player:upgrade_value("player", "health_multiplier", 1) * managers.player:upgrade_value("player", "passive_health_multiplier", 1)
end

PlayerDamage._total_armor = function(l_18_0)
  return (l_18_0._ARMOR_INIT + managers.player:body_armor_value()) * managers.player:upgrade_value("player", "passive_armor_multiplier", 1) * managers.player:upgrade_value("player", "armor_multiplier", 1)
end

PlayerDamage._max_armor = function(l_19_0)
  return l_19_0:_total_armor()
end

PlayerDamage._armor_steps = function(l_20_0)
  return l_20_0._ARMOR_STEPS
end

PlayerDamage._armor_damage_reduction = function(l_21_0)
  return 0
end

PlayerDamage.full_health = function(l_22_0)
  return l_22_0:get_real_health() == l_22_0:_max_health()
end

PlayerDamage.damage_tase = function(l_23_0, l_23_1)
  if l_23_0._god_mode then
    return 
  end
  local cur_state = l_23_0._unit:movement():current_state_name()
  if cur_state ~= "tased" and cur_state ~= "fatal" then
    l_23_0._tase_data = l_23_1
    managers.player:set_player_state("tased")
    local damage_info = {result = {type = "hurt", variant = "tase"}}
    l_23_0:_call_listeners(damage_info)
    if l_23_1.attacker_unit and l_23_1.attacker_unit:alive() and l_23_1.attacker_unit:base()._tweak_table == "taser" then
      l_23_1.attacker_unit:sound():say("post_tasing_taunt")
    end
  end
end

PlayerDamage.tase_data = function(l_24_0)
  return l_24_0._tase_data
end

PlayerDamage.erase_tase_data = function(l_25_0)
  l_25_0._tase_data = nil
end

PlayerDamage.damage_melee = function(l_26_0, l_26_1)
  l_26_0:damage_bullet(l_26_1)
  l_26_0._unit:movement():push(l_26_1.push_vel)
end

PlayerDamage._look_for_friendly_fire = function(l_27_0, l_27_1)
  local players = managers.player:players()
  for _,player in ipairs(players) do
    if player == l_27_1 then
      return true
    end
  end
  local criminals = managers.groupai:state():all_criminals()
  if l_27_1 and criminals[l_27_1:key()] then
    return true
  end
  return false
end

PlayerDamage.play_whizby = function(l_28_0, l_28_1)
  l_28_0._unit:sound():play_whizby({position = l_28_1})
  l_28_0._unit:camera():play_shaker("whizby", 0.10000000149012)
  managers.rumble:play("bullet_whizby")
end

PlayerDamage.clbk_kill_taunt = function(l_29_0, l_29_1)
  l_29_0._kill_taunt_clbk_id = nil
  l_29_1.attacker_unit:sound():say("post_kill_taunt")
end

PlayerDamage.damage_bullet = function(l_30_0, l_30_1)
  local damage_info = {result = {type = "hurt", variant = "bullet"}, attacker_unit = l_30_1.attacker_unit}
  if math.rand(1) <= managers.player:upgrade_value("player", "passive_dodge_chance", 0) or l_30_0._unit:movement():running() and math.rand(1) <= managers.player:upgrade_value("player", "run_dodge_chance", 0) then
    if l_30_1.damage > 0 then
      l_30_0:_send_damage_drama(l_30_1, l_30_1.damage)
    end
    l_30_0:_call_listeners(damage_info)
    l_30_0:_hit_direction(l_30_1.col_ray)
    return 
  end
  local dmg_mul = managers.player:temporary_upgrade_value("temporary", "dmg_dampener_outnumbered", 1) * managers.player:upgrade_value("player", "damage_dampener", 1)
  if l_30_0._unit:movement()._current_state and l_30_0._unit:movement()._current_state:_interacting() then
    dmg_mul = dmg_mul * managers.player:upgrade_value("player", "interacting_damage_multiplier", 1)
  end
  l_30_1.damage = l_30_1.damage * (dmg_mul)
  if l_30_0._god_mode then
    if l_30_1.damage > 0 then
      l_30_0:_send_damage_drama(l_30_1, l_30_1.damage)
    end
    l_30_0:_call_listeners(damage_info)
    return 
  elseif l_30_0._invulnerable then
    l_30_0:_call_listeners(damage_info)
    return 
  else
    if l_30_0:incapacitated() then
      return 
    else
      if PlayerDamage:_look_for_friendly_fire(l_30_1.attacker_unit) then
        return 
      else
        if l_30_0:_chk_dmg_too_soon(l_30_1.damage) then
          return 
        elseif l_30_0._revive_miss and math.random() < l_30_0._revive_miss then
          l_30_0:play_whizby(l_30_1.col_ray.position)
          return 
        end
      end
    end
  end
  if l_30_1.attacker_unit:base()._tweak_table == "tank" then
    managers.achievment:set_script_data("dodge_this_fail", true)
  end
  if l_30_0:get_real_armor() > 0 then
    l_30_0._unit:sound():play("player_hit")
  else
    l_30_0._unit:sound():play("player_hit_permadamage")
  end
  local shake_multiplier = math.clamp(l_30_1.damage, 0.20000000298023, 2) * managers.player:upgrade_value("player", "damage_shake_multiplier", 1)
  l_30_0._unit:camera():play_shaker("player_bullet_damage", 1 * shake_multiplier)
  managers.rumble:play("damage_bullet")
  l_30_0:_hit_direction(l_30_1.col_ray)
  managers.player:check_damage_carry(l_30_1)
  if l_30_0._bleed_out then
    l_30_0:_bleed_out_damage(l_30_1)
    return 
  end
  if not l_30_0:is_suppressed() then
    return 
  end
  local armor_reduction_multiplier = 0
  if l_30_0:get_real_armor() <= 0 then
    armor_reduction_multiplier = 1
  end
  local health_subtracted = l_30_0:_calc_armor_damage(l_30_1)
  l_30_1.damage = l_30_1.damage * armor_reduction_multiplier
  health_subtracted = health_subtracted + l_30_0:_calc_health_damage(l_30_1)
  managers.player:activate_temporary_upgrade("temporary", "wolverine_health_regen")
  l_30_0._next_allowed_dmg_t = Application:digest_value(managers.player:player_timer():time() + l_30_0._dmg_interval, true)
  l_30_0._last_received_dmg = health_subtracted
  if not l_30_0._bleed_out and health_subtracted > 0 then
    l_30_0:_send_damage_drama(l_30_1, health_subtracted)
  elseif l_30_0._bleed_out then
    managers.challenges:set_flag("bullet_to_bleed_out")
    if l_30_1.attacker_unit and l_30_1.attacker_unit:alive() and l_30_1.attacker_unit:base()._tweak_table == "tank" then
      l_30_0._kill_taunt_clbk_id = "kill_taunt" .. tostring(l_30_0._unit:key())
      managers.enemy:add_delayed_clbk(l_30_0._kill_taunt_clbk_id, callback(l_30_0, l_30_0, "clbk_kill_taunt", l_30_1), managers.player:player_timer():time() + tweak_data.timespeed.downed.fade_in + tweak_data.timespeed.downed.sustain + tweak_data.timespeed.downed.fade_out)
    end
  end
  l_30_0:_call_listeners(damage_info)
end

PlayerDamage._calc_armor_damage = function(l_31_0, l_31_1)
  local health_subtracted = 0
  if l_31_0:get_real_armor() > 0 then
    health_subtracted = l_31_0:get_real_armor()
    l_31_0:set_armor(l_31_0:get_real_armor() - l_31_1.damage)
    health_subtracted = health_subtracted - l_31_0:get_real_armor()
    l_31_0:_damage_screen()
    managers.hud:set_player_armor({current = l_31_0:get_real_armor(), total = l_31_0:_total_armor(), max = l_31_0:_max_armor()})
    SoundDevice:set_rtpc("shield_status", l_31_0:get_real_armor() / l_31_0:_total_armor() * 100)
    l_31_0:_send_set_armor()
    if l_31_0:get_real_armor() <= 0 then
      l_31_0._unit:sound():play("player_armor_gone_stinger")
    end
  end
  return health_subtracted
end

PlayerDamage._calc_health_damage = function(l_32_0, l_32_1)
  local health_subtracted = 0
  health_subtracted = l_32_0:get_real_health()
  l_32_0:change_health(-l_32_1.damage)
  health_subtracted = health_subtracted - l_32_0:get_real_health()
  if l_32_0:get_real_health() == 0 and l_32_1.variant and l_32_1.variant == "bullet" and Application:digest_value(l_32_0._revives, false) > 1 and managers.player:has_category_upgrade("player", "cheat_death_chance") then
    local r = math.rand(1)
    if r <= managers.player:upgrade_value("player", "cheat_death_chance") then
      l_32_0._auto_revive_timer = 1
    end
  end
  l_32_0:_damage_screen()
  l_32_0:_check_bleed_out()
  managers.hud:set_player_health({current = l_32_0:get_real_health(), total = l_32_0:_max_health(), revives = Application:digest_value(l_32_0._revives, false)})
  l_32_0:_send_set_health()
  l_32_0:_set_health_effect()
  managers.statistics:health_subtracted(health_subtracted)
  return health_subtracted
end

PlayerDamage._send_damage_drama = function(l_33_0, l_33_1, l_33_2)
  local dmg_percent = l_33_2 / l_33_0._HEALTH_INIT
  local attacker = nil
  if not attacker or l_33_1.attacker_unit:id() == -1 then
    attacker = l_33_0._unit
  end
  l_33_0._unit:network():send("criminal_hurt", attacker, math.clamp(math.ceil(dmg_percent * 100), 1, 100))
  if Network:is_server() then
    attacker = l_33_1.attacker_unit
    if attacker and not l_33_1.attacker_unit:movement() then
      attacker = nil
    end
    managers.groupai:state():criminal_hurt_drama(l_33_0._unit, attacker, dmg_percent)
  end
  if Network:is_client() then
    l_33_0._unit:network():send_to_host("damage_bullet", attacker, 1, 1, 1, false)
  end
end

PlayerDamage.damage_killzone = function(l_34_0, l_34_1)
  local damage_info = {result = {type = "hurt", variant = "killzone"}}
  if l_34_0._god_mode or l_34_0._invulnerable then
    l_34_0:_call_listeners(damage_info)
    return 
  else
    if l_34_0:incapacitated() then
      return 
    end
  end
  l_34_0._unit:sound():play("player_hit")
  l_34_0:_hit_direction(l_34_1.col_ray)
  if l_34_0._bleed_out then
    return 
  end
  local armor_reduction_multiplier = 0
  if l_34_0:get_real_armor() <= 0 then
    armor_reduction_multiplier = 1
  end
  local health_subtracted = l_34_0:_calc_armor_damage(l_34_1)
  l_34_1.damage = l_34_1.damage * armor_reduction_multiplier
  health_subtracted = health_subtracted + l_34_0:_calc_health_damage(l_34_1)
  l_34_0:_call_listeners(damage_info)
end

PlayerDamage.damage_fall = function(l_35_0, l_35_1)
  local damage_info = {result = {type = "hurt", variant = "fall"}}
  if l_35_0._god_mode or l_35_0._invulnerable then
    l_35_0:_call_listeners(damage_info)
    return 
  else
    if l_35_0:incapacitated() then
      return 
    end
  end
  local height_limit = 300
  local death_limit = 631
  if l_35_1.height < height_limit then
    return 
  end
  local die = death_limit < l_35_1.height
  l_35_0._unit:sound():play("player_hit")
  managers.environment_controller:hit_feedback_down()
  managers.hud:on_hit_direction("down")
  if l_35_0._bleed_out then
    return 
  end
  local health_damage_multiplier = 0
  if die then
    l_35_0:set_health(0)
  else
    health_damage_multiplier = managers.player:upgrade_value("player", "fall_damage_multiplier", 1) * managers.player:upgrade_value("player", "fall_health_damage_multiplier", 1)
    l_35_0:change_health(-(tweak_data.player.fall_health_damage * (health_damage_multiplier)))
  end
  if not tweak_data.player.fall_damage_alert_size then
    local alert_rad = not die and health_damage_multiplier <= 0 or 500
  end
  do
    local new_alert = {"vo_cbt", l_35_0._unit:movement():m_head_pos(), alert_rad, l_35_0._unit:movement():SO_access(), l_35_0._unit}
    managers.groupai:state():propagate_alert(new_alert)
  end
  local max_armor = l_35_0:_max_armor()
  if die then
    l_35_0:set_armor(0)
  else
    l_35_0:set_armor(l_35_0:get_real_armor() - max_armor * managers.player:upgrade_value("player", "fall_damage_multiplier", 1))
  end
  managers.hud:set_player_armor({current = l_35_0:get_real_armor(), total = l_35_0:_total_armor(), max = max_armor, no_hint = true})
  SoundDevice:set_rtpc("shield_status", 0)
  l_35_0:_send_set_armor()
  managers.hud:set_player_health({current = l_35_0:get_real_health(), total = l_35_0:_max_health(), revives = Application:digest_value(l_35_0._revives, false)})
  l_35_0:_send_set_health()
  l_35_0:_set_health_effect()
  l_35_0:_damage_screen()
  l_35_0:_check_bleed_out()
  if die then
    managers.challenges:set_flag("fall_to_bleed_out")
  end
  l_35_0:_call_listeners(damage_info)
  return true
end

PlayerDamage.damage_explosion = function(l_36_0, l_36_1)
  local damage_info = {result = {type = "hurt", variant = "explosion"}}
  if l_36_0._god_mode or l_36_0._invulnerable then
    l_36_0:_call_listeners(damage_info)
    return 
  else
    if l_36_0:incapacitated() then
      return 
    end
  end
  local distance = mvector3.distance(l_36_1.position, l_36_0._unit:position())
  if l_36_1.range < distance then
    return 
  end
  local damage = (l_36_1.damage or 1) * (1 - distance / l_36_1.range)
  if l_36_0._bleed_out then
    return 
  end
  l_36_1.damage = damage
  local armor_subtracted = l_36_0:_calc_armor_damage(l_36_1)
  l_36_1.damage = l_36_1.damage - (armor_subtracted or 0)
  local health_subtracted = l_36_0:_calc_health_damage(l_36_1)
  l_36_0:_call_listeners(damage_info)
end

PlayerDamage.update_downed = function(l_37_0, l_37_1, l_37_2)
  if l_37_0._downed_timer and l_37_0._downed_paused_counter == 0 then
    l_37_0._downed_timer = l_37_0._downed_timer - l_37_2
    if l_37_0._downed_start_time == 0 then
      l_37_0._downed_progression = 100
    else
      l_37_0._downed_progression = math.clamp(1 - l_37_0._downed_timer / l_37_0._downed_start_time, 0, 1) * 100
    end
    managers.environment_controller:set_downed_value(l_37_0._downed_progression)
    SoundDevice:set_rtpc("downed_state_progression", l_37_0._downed_progression)
    return l_37_0._downed_timer <= 0
  end
  return false
end

PlayerDamage._check_bleed_out = function(l_38_0)
  if l_38_0:get_real_health() == 0 then
    l_38_0._revives = Application:digest_value(Application:digest_value(l_38_0._revives, false) - 1, true)
    managers.environment_controller:set_last_life(Application:digest_value(l_38_0._revives, false) <= 1)
    if Application:digest_value(l_38_0._revives, false) == 0 then
      l_38_0._down_time = 0
    end
    l_38_0._bleed_out = true
    managers.player:set_player_state("bleed_out")
    l_38_0._critical_state_heart_loop_instance = l_38_0._unit:sound():play("critical_state_heart_loop")
    managers.environment_controller:set_downed_value(0)
    SoundDevice:set_rtpc("downed_state_progression", 0)
    l_38_0._slomo_sound_instance = l_38_0._unit:sound():play("downed_slomo_fx")
    l_38_0._bleed_out_health = Application:digest_value(tweak_data.player.damage.BLEED_OUT_HEALTH_INIT * managers.player:upgrade_value("player", "bleed_out_health_multiplier", 1), true)
    l_38_0._hurt_value = 0.20000000298023
    if managers.player:has_category_upgrade("temporary", "pistol_revive_from_bleed_out") then
      local upgrade_value = managers.player:upgrade_value("temporary", "pistol_revive_from_bleed_out")
      if upgrade_value == 0 then
        do return end
      end
      local time = upgrade_value[2]
      managers.player:activate_temporary_upgrade("temporary", "pistol_revive_from_bleed_out")
    end
    l_38_0:_drop_blood_sample()
    l_38_0:on_downed()
  elseif not l_38_0._said_hurt and l_38_0:get_real_health() / l_38_0:_max_health() < 0.20000000298023 then
    l_38_0._said_hurt = true
    PlayerStandard.say_line(l_38_0, "g80x_plu")
  end
end

PlayerDamage._drop_blood_sample = function(l_39_0)
  local remove = math.rand(1) < 0.5
  if not remove then
    return 
  end
  local removed = false
  if managers.player:has_special_equipment("blood_sample") then
    removed = true
    managers.player:remove_special("blood_sample")
    managers.hint:show_hint("dropped_blood_sample")
  end
  if managers.player:has_special_equipment("blood_sample_verified") then
    removed = true
    managers.player:remove_special("blood_sample_verified")
    managers.hint:show_hint("dropped_blood_sample")
  end
  if removed then
    l_39_0._unit:sound():play("vial_break_2d")
    l_39_0._unit:sound():say("g29", false)
    if managers.groupai:state():bain_state() then
      managers.dialog:queue_dialog("hos_ban_139", {})
    end
    local splatter_from = l_39_0._unit:position() + math.UP * 5
    local splatter_to = l_39_0._unit:position() - math.UP * 45
    local splatter_ray = World:raycast("ray", splatter_from, splatter_to, "slot_mask", managers.game_play_central._slotmask_world_geometry)
    if splatter_ray then
      World:project_decal(Idstring("blood_spatter"), splatter_ray.position, splatter_ray.ray, splatter_ray.unit, nil, splatter_ray.normal)
    end
  end
end

PlayerDamage.on_downed = function(l_40_0)
  l_40_0._downed_timer = l_40_0:down_time()
  l_40_0._downed_start_time = l_40_0._downed_timer
  l_40_0._downed_paused_counter = 0
  managers.hud:pd_start_timer({time = l_40_0._downed_timer})
  managers.hud:on_downed()
  l_40_0:_stop_tinnitus()
end

PlayerDamage.pause_downed_timer = function(l_41_0, l_41_1)
  l_41_0._downed_paused_counter = l_41_0._downed_paused_counter + 1
  if l_41_0._downed_paused_counter == 1 then
    managers.hud:pd_pause_timer()
    if not l_41_1 then
      managers.hud:pd_start_progress(0, tweak_data.interaction.revive.timer, "debug_interact_being_revived", "interaction_help")
    end
     -- Warning: missing end command somewhere! Added here
  end
end

PlayerDamage.unpause_downed_timer = function(l_42_0)
  l_42_0._downed_paused_counter = l_42_0._downed_paused_counter - 1
  if l_42_0._downed_paused_counter == 0 then
    managers.hud:pd_unpause_timer()
    managers.hud:pd_stop_progress()
  end
end

PlayerDamage.update_arrested = function(l_43_0, l_43_1, l_43_2)
  if l_43_0._arrested_timer and l_43_0._arrested_paused_counter == 0 then
    l_43_0._arrested_timer = l_43_0._arrested_timer - l_43_2
    return not l_43_0:arrested()
  end
  return false
end

PlayerDamage.on_freed = function(l_44_0)
  l_44_0._arrested_timer = nil
  l_44_0._arrested = nil
end

PlayerDamage.on_arrested = function(l_45_0)
  l_45_0._bleed_out = false
  l_45_0._arrested_timer = tweak_data.player.damage.ARRESTED_TIME
  l_45_0._arrested_paused_counter = 0
  managers.hud:pd_start_timer({time = l_45_0._arrested_timer})
  managers.hud:on_arrested()
end

PlayerDamage.pause_arrested_timer = function(l_46_0)
  if not l_46_0._arrested_timer or l_46_0._arrested_timer <= 0 then
    return 
  end
  l_46_0._arrested_paused_counter = l_46_0._arrested_paused_counter + 1
  if l_46_0._arrested_paused_counter == 1 then
    managers.hud:pd_pause_timer()
    managers.hud:pd_start_progress(0, tweak_data.interaction.free.timer, "debug_interact_being_freed", "interaction_free")
  end
end

PlayerDamage.unpause_arrested_timer = function(l_47_0)
  if not l_47_0._arrested_timer or l_47_0._arrested_timer <= 0 then
    return 
  end
  l_47_0._arrested_paused_counter = l_47_0._arrested_paused_counter - 1
  if l_47_0._arrested_paused_counter == 0 then
    managers.hud:pd_unpause_timer()
    managers.hud:pd_stop_progress()
  end
end

PlayerDamage.update_incapacitated = function(l_48_0, l_48_1, l_48_2)
  return l_48_0:update_downed(l_48_1, l_48_2)
end

PlayerDamage.on_incapacitated = function(l_49_0)
  l_49_0:on_downed()
  l_49_0._incapacitated = true
end

PlayerDamage.bleed_out = function(l_50_0)
  return l_50_0._bleed_out
end

PlayerDamage.incapacitated = function(l_51_0)
  return l_51_0._incapacitated
end

PlayerDamage.arrested = function(l_52_0)
  if not l_52_0._arrested_timer then
    return l_52_0._arrested
  end
end

PlayerDamage._bleed_out_damage = function(l_53_0, l_53_1)
  local health_subtracted = Application:digest_value(l_53_0._bleed_out_health, false)
  l_53_0._bleed_out_health = Application:digest_value(math.max(0, health_subtracted - l_53_1.damage), true)
  health_subtracted = health_subtracted - Application:digest_value(l_53_0._bleed_out_health, false)
  l_53_0._next_allowed_dmg_t = Application:digest_value(managers.player:player_timer():time() + l_53_0._dmg_interval, true)
  l_53_0._last_received_dmg = health_subtracted
  if Application:digest_value(l_53_0._bleed_out_health, false) <= 0 then
    managers.player:set_player_state("fatal")
  end
  if health_subtracted > 0 then
    l_53_0:_send_damage_drama(l_53_1, health_subtracted)
  end
end

PlayerDamage._hit_direction = function(l_54_0, l_54_1)
  if l_54_1 then
    local dir = l_54_1.ray
    local infront = math.dot(l_54_0._unit:camera():forward(), dir)
    if infront < -0.89999997615814 then
      managers.environment_controller:hit_feedback_front()
    elseif infront > 0.89999997615814 then
      managers.environment_controller:hit_feedback_back()
      managers.hud:on_hit_direction("right")
    else
      local polar = l_54_0._unit:camera():forward():to_polar_with_reference(-dir, Vector3(0, 0, 1))
      local direction = Vector3(polar.spin, polar.pitch, 0):normalized()
      if math.abs(direction.y) < math.abs(direction.x) then
        if direction.x < 0 then
          managers.environment_controller:hit_feedback_left()
          managers.hud:on_hit_direction("left")
        else
          managers.environment_controller:hit_feedback_right()
          managers.hud:on_hit_direction("right")
        end
      elseif direction.y < 0 then
        managers.environment_controller:hit_feedback_up()
        managers.hud:on_hit_direction("up")
      else
        managers.environment_controller:hit_feedback_down()
        managers.hud:on_hit_direction("down")
      end
  end
end
end
end

PlayerDamage._damage_screen = function(l_55_0)
  l_55_0:set_regenerate_timer_to_max()
  l_55_0._hurt_value = 1 - math.clamp(0.80000001192093 - math.pow(l_55_0:get_real_armor() / l_55_0:_max_armor(), 2), 0, 1)
  l_55_0._armor_value = math.clamp(l_55_0:get_real_armor() / l_55_0:_max_armor(), 0, 1)
  managers.environment_controller:set_hurt_value(l_55_0._hurt_value)
end

PlayerDamage.set_revive_boost = function(l_56_0, l_56_1)
  l_56_0._revive_health_multiplier = tweak_data.upgrades.revive_health_multiplier[l_56_1]
  print("PlayerDamage:set_revive_boost", "revive_health_level", l_56_1, "revive_health_multiplier", tostring(l_56_0._revive_health_multiplier))
end

PlayerDamage.revive = function(l_57_0, l_57_1)
  if Application:digest_value(l_57_0._revives, false) == 0 then
    l_57_0._revive_health_multiplier = nil
    return 
  end
  local arrested = l_57_0:arrested()
  managers.player:set_player_state("standard")
  if not l_57_1 then
    PlayerStandard.say_line(l_57_0, "s05x_sin")
  end
  l_57_0._bleed_out = false
  l_57_0._incapacitated = nil
  l_57_0._downed_timer = nil
  l_57_0._downed_start_time = nil
  if not arrested then
    if l_57_1 == true then
      managers.challenges:count_up("revived")
    end
    l_57_0:set_health(l_57_0:_max_health() * tweak_data.player.damage.REVIVE_HEALTH_STEPS[l_57_0._revive_health_i] * (l_57_0._revive_health_multiplier or 1))
    l_57_0:set_armor(l_57_0:_total_armor())
    l_57_0._revive_health_i = math.min(#tweak_data.player.damage.REVIVE_HEALTH_STEPS, l_57_0._revive_health_i + 1)
    l_57_0._revive_miss = 2
  end
  l_57_0:_regenerate_armor()
  managers.hud:set_player_health({current = l_57_0:get_real_health(), total = l_57_0:_max_health(), revives = Application:digest_value(l_57_0._revives, false)})
  l_57_0:_send_set_health()
  l_57_0:_set_health_effect()
  managers.hud:pd_stop_progress()
  l_57_0._revive_health_multiplier = nil
end

PlayerDamage.need_revive = function(l_58_0)
  if not l_58_0._bleed_out then
    return l_58_0._incapacitated
  end
end

PlayerDamage.dead = function(l_59_0)
  return l_59_0._dead
end

PlayerDamage.set_god_mode = function(l_60_0, l_60_1)
  Global.god_mode = l_60_1
  l_60_0._god_mode = l_60_1
  l_60_0:print("PlayerDamage god mode " .. (l_60_1 and "ON" or "OFF"))
end

PlayerDamage.god_mode = function(l_61_0)
  return l_61_0._god_mode
end

PlayerDamage.print = function(l_62_0, ...)
  cat_print("player_damage", ...)
   -- DECOMPILER ERROR: Confused about usage of registers for local variables.

end

PlayerDamage.set_invulnerable = function(l_63_0, l_63_1)
  l_63_0._invulnerable = l_63_1
end

PlayerDamage.set_danger_level = function(l_64_0, l_64_1)
  l_64_0._danger_level = l_64_0._danger_level ~= l_64_1 and l_64_1 or nil
  l_64_0._focus_delay_mul = l_64_1 and tweak_data.danger_zones[l_64_0._danger_level] or 1
end

PlayerDamage.focus_delay_mul = function(l_65_0)
  return l_65_0._focus_delay_mul
end

PlayerDamage.shoot_pos_mid = function(l_66_0, l_66_1)
  mvector3.set(l_66_1, l_66_0._unit:movement():m_head_pos())
end

PlayerDamage.set_regenerate_timer_to_max = function(l_67_0)
  l_67_0._regenerate_timer = tweak_data.player.damage.REGENERATE_TIME * managers.player:upgrade_value("player", "armor_regen_timer_multiplier", 1) * managers.player:team_upgrade_value("armor", "regen_time_multiplier", 1) * managers.player:team_upgrade_value("armor", "passive_regen_time_multiplier", 1)
end

PlayerDamage._send_set_health = function(l_68_0)
  if l_68_0._unit:network() then
    local hp = math.round(l_68_0:get_real_health() / l_68_0:_max_health() * 100)
    l_68_0._unit:network():send("set_health", math.clamp(hp, 0, 100))
  end
end

PlayerDamage._set_health_effect = function(l_69_0)
  local hp = l_69_0:get_real_health() / l_69_0:_max_health()
  math.clamp(hp, 0, 1)
  managers.environment_controller:set_health_effect_value(hp)
end

PlayerDamage._send_set_armor = function(l_70_0)
  if l_70_0._unit:network() then
    local armor = math.round(l_70_0:get_real_armor() / l_70_0:_total_armor() * 100)
    l_70_0._unit:network():send("set_armor", math.clamp(armor, 0, 100))
  end
end

PlayerDamage.stop_heartbeat = function(l_71_0)
  if l_71_0._critical_state_heart_loop_instance then
    l_71_0._critical_state_heart_loop_instance:stop()
    l_71_0._critical_state_heart_loop_instance = nil
  end
  if l_71_0._slomo_sound_instance then
    l_71_0._slomo_sound_instance:stop()
    l_71_0._slomo_sound_instance = nil
  end
  managers.environment_controller:set_downed_value(0)
  SoundDevice:set_rtpc("downed_state_progression", 0)
  SoundDevice:set_rtpc("stamina", 100)
end

PlayerDamage.pre_destroy = function(l_72_0)
  if alive(l_72_0._gui) and alive(l_72_0._ws) then
    l_72_0._gui:destroy_workspace(l_72_0._ws)
  end
  if l_72_0._critical_state_heart_loop_instance then
    l_72_0._critical_state_heart_loop_instance:stop()
  end
  if l_72_0._slomo_sound_instance then
    l_72_0._slomo_sound_instance:stop()
    l_72_0._slomo_sound_instance = nil
  end
  managers.environment_controller:set_last_life(false)
  managers.environment_controller:set_downed_value(0)
  SoundDevice:set_rtpc("downed_state_progression", 0)
  SoundDevice:set_rtpc("shield_status", 100)
  managers.environment_controller:set_hurt_value(1)
  managers.environment_controller:set_health_effect_value(1)
  managers.environment_controller:set_suppression_value(0)
end

PlayerDamage._call_listeners = function(l_73_0, l_73_1)
  CopDamage._call_listeners(l_73_0, l_73_1)
end

PlayerDamage.add_listener = function(l_74_0, ...)
  CopDamage.add_listener(l_74_0, ...)
   -- DECOMPILER ERROR: Confused about usage of registers for local variables.

end

PlayerDamage.remove_listener = function(l_75_0, l_75_1)
  CopDamage.remove_listener(l_75_0, l_75_1)
end

PlayerDamage.on_fatal_state_enter = function(l_76_0)
  local dmg_info = {result = {type = "death"}}
  l_76_0:_call_listeners(dmg_info)
end

PlayerDamage.on_incapacitated_state_enter = function(l_77_0)
  local dmg_info = {result = {type = "death"}}
  l_77_0:_call_listeners(dmg_info)
end

PlayerDamage._chk_dmg_too_soon = function(l_78_0, l_78_1)
  if type(l_78_0._next_allowed_dmg_t) ~= "number" or not l_78_0._next_allowed_dmg_t then
    local next_allowed_dmg_t = Application:digest_value(l_78_0._next_allowed_dmg_t, false)
  end
  if l_78_1 <= l_78_0._last_received_dmg and managers.player:player_timer():time() < next_allowed_dmg_t then
    return true
  end
end

PlayerDamage._chk_suppression_too_soon = function(l_79_0, l_79_1)
  if l_79_1 <= l_79_0._last_received_sup and managers.player:player_timer():time() < l_79_0._next_allowed_sup_t then
    return true
  end
end

PlayerDamage.clbk_msg_overwrite_criminal_hurt = function(l_80_0, l_80_1, l_80_2, l_80_3, l_80_4, l_80_5)
  if l_80_1 then
    local crim_key = l_80_3:key()
    local attacker_key = l_80_4:key()
    if l_80_0.indexes[crim_key] and l_80_0.indexes[crim_key][attacker_key] then
      local index = l_80_0.indexes[crim_key][attacker_key]
      local old_msg = l_80_1[index]
      old_msg[4] = math.clamp(l_80_5 + old_msg[4], 1, 100)
    else
      table.insert(l_80_1, {l_80_2, l_80_3, l_80_4, l_80_5})
      l_80_0.indexes[crim_key] = {attacker_key = #l_80_1}
    end
  else
    l_80_0.indexes = {}
  end
end
end

PlayerDamage.build_suppression = function(l_81_0, l_81_1)
  if l_81_0:_chk_suppression_too_soon(l_81_1) then
    return 
  end
  local data = l_81_0._supperssion_data
  l_81_1 = l_81_1 * managers.player:upgrade_value("player", "suppressed_multiplier", 1)
  local morale_boost_bonus = l_81_0._unit:movement():morale_boost()
  if morale_boost_bonus then
    l_81_1 = l_81_1 * morale_boost_bonus.suppression_resistance
  end
  l_81_1 = l_81_1 * tweak_data.player.suppression.receive_mul
  data.value = math.min(tweak_data.player.suppression.max_value, (data.value or 0) + l_81_1 * tweak_data.player.suppression.receive_mul)
  l_81_0._last_received_sup = l_81_1
  l_81_0._next_allowed_sup_t = managers.player:player_timer():time() + l_81_0._dmg_interval
  data.decay_start_t = managers.player:player_timer():time() + tweak_data.player.suppression.decay_start_delay
end

PlayerDamage._upd_suppression = function(l_82_0, l_82_1, l_82_2)
  local data = l_82_0._supperssion_data
  if data.value then
    if data.decay_start_t < l_82_1 then
      data.value = data.value - l_82_2
      if data.value <= 0 then
        data.value = nil
        data.decay_start_t = nil
        managers.environment_controller:set_suppression_value(0, 0)
      else
        if data.value == tweak_data.player.suppression.max_value and l_82_0._regenerate_timer then
          l_82_0:set_regenerate_timer_to_max()
        end
      end
    end
    if data.value then
      managers.environment_controller:set_suppression_value(l_82_0:effective_suppression_ratio(), l_82_0:suppression_ratio())
    end
  end
end

PlayerDamage._upd_health_regen = function(l_83_0, l_83_1, l_83_2)
  if l_83_0._health_regen_update_timer then
    l_83_0._health_regen_update_timer = l_83_0._health_regen_update_timer - l_83_2
    if l_83_0._health_regen_update_timer <= 0 then
      l_83_0._health_regen_update_timer = nil
    end
  end
  if not l_83_0._health_regen_update_timer then
    local regen_rate = 0 + managers.player:temporary_upgrade_value("temporary", "wolverine_health_regen", 0)
    local max_health = l_83_0:_max_health()
    if regen_rate > 0 and l_83_0:get_real_health() < max_health then
      l_83_0:change_health(max_health * regen_rate)
      l_83_0._health_regen_update_timer = 1
    end
  end
end

PlayerDamage.suppression_ratio = function(l_84_0)
  return (l_84_0._supperssion_data.value or 0) / tweak_data.player.suppression.max_value
end

PlayerDamage.effective_suppression_ratio = function(l_85_0)
  local effective_ratio = math.max(0, (l_85_0._supperssion_data.value or 0) - tweak_data.player.suppression.tolerance) / (tweak_data.player.suppression.max_value - tweak_data.player.suppression.tolerance)
  return effective_ratio
end

PlayerDamage.is_suppressed = function(l_86_0)
  return l_86_0:effective_suppression_ratio() > 0
end

PlayerDamage.reset_suppression = function(l_87_0)
  l_87_0._supperssion_data.value = nil
  l_87_0._supperssion_data.decay_start_t = nil
end

PlayerDamage.on_flashbanged = function(l_88_0, l_88_1)
  if l_88_0._downed_timer then
    return 
  end
  l_88_0:_start_tinnitus(l_88_1)
end

PlayerDamage._start_tinnitus = function(l_89_0, l_89_1)
  if l_89_0._tinnitus_data then
    if l_89_1 < l_89_0._tinnitus_data.intensity then
      return 
    end
    l_89_0._tinnitus_data.intensity = l_89_1
    l_89_0._tinnitus_data.duration = 4 + l_89_1 * math.lerp(8, 12, math.random())
    l_89_0._tinnitus_data.end_t = managers.player:player_timer():time() + l_89_0._tinnitus_data.duration
    if l_89_0._tinnitus_data.snd_event then
      l_89_0._tinnitus_data.snd_event:stop()
    end
    SoundDevice:set_rtpc("downed_state_progression", math.max(l_89_0._downed_progression or 0, l_89_0._tinnitus_data.intensity * 100))
    l_89_0._tinnitus_data.snd_event = l_89_0._unit:sound():play("tinnitus_beep")
  else
    local duration = 4 + l_89_1 * math.lerp(8, 12, math.random())
    SoundDevice:set_rtpc("downed_state_progression", math.max(l_89_0._downed_progression or 0, l_89_1 * 100))
    l_89_0._tinnitus_data = {intensity = l_89_1, duration = duration, end_t = managers.player:player_timer():time() + duration, snd_event = l_89_0._unit:sound():play("tinnitus_beep")}
  end
end

PlayerDamage._stop_tinnitus = function(l_90_0)
  if not l_90_0._tinnitus_data then
    return 
  end
  l_90_0._unit:sound():play("tinnitus_beep_stop")
  l_90_0._tinnitus_data = nil
end


