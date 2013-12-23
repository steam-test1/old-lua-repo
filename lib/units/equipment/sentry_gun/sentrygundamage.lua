-- Decompiled using luadec 2.0.1 by sztupy (http://winmo.sztupy.hu)
-- Command line was: F:\SteamLibrary\SteamApps\common\PAYDAY 2\lua\lib\units\equipment\sentry_gun\sentrygundamage.luac 

if not SentryGunDamage then
  SentryGunDamage = class()
end
SentryGunDamage.init = function(l_1_0, l_1_1)
  l_1_0._unit = l_1_1
  l_1_0._ext_movement = l_1_1:movement()
  l_1_1:base():post_init()
  l_1_1:brain():post_init()
  l_1_1:movement():post_init()
  l_1_0._shield_body_name = Idstring("shield")
  l_1_0._bag_body_name = Idstring("bag")
  l_1_0._health_sync_resolution = 0.20000000298023
  if Network:is_server() then
    l_1_0._health = 1
    l_1_0._health_max = l_1_0._health
    l_1_0._health_sync = 1
  else
    l_1_0._health_ratio = 1
  end
end

SentryGunDamage.set_health = function(l_2_0, l_2_1)
  l_2_0._health = l_2_1
  l_2_0._health_max = math.max(l_2_0._health_max, l_2_1)
end

SentryGunDamage.sync_health = function(l_3_0, l_3_1)
  l_3_0._health_ratio = l_3_1 * l_3_0._health_sync_resolution * 100
  if l_3_1 == 0 then
    l_3_0:die()
  end
end

SentryGunDamage.shoot_pos_mid = function(l_4_0, l_4_1)
  mvector3.set(l_4_1, l_4_0._ext_movement:m_head_pos())
end

SentryGunDamage.damage_bullet = function(l_5_0, l_5_1)
  if l_5_0._dead or l_5_0._invulnerable or PlayerDamage:_look_for_friendly_fire(l_5_1.attacker_unit) then
    return 
  end
  local hit_shield = not l_5_1.col_ray.body or l_5_1.col_ray.body:name() == l_5_0._shield_body_name
  local hit_bag = not l_5_1.col_ray.body or l_5_1.col_ray.body:name() == l_5_0._bag_body_name
  local dmg_adjusted = l_5_1.damage * (hit_shield and tweak_data.weapon.sentry_gun.SHIELD_DMG_MUL or 1) * (hit_bag and tweak_data.weapon.sentry_gun.BAG_DMG_MUL or 1)
  if l_5_0._health <= dmg_adjusted then
    l_5_0:die()
  else
    l_5_0._health = l_5_0._health - dmg_adjusted
  end
  local health_percent = l_5_0._health / l_5_0._health_max
  if health_percent == 0 or l_5_0._health_sync_resolution <= math.abs(health_percent - l_5_0._health_sync) then
    l_5_0._health_sync = health_percent
    l_5_0._unit:network():send("sentrygun_health", math.ceil(health_percent / l_5_0._health_sync_resolution))
  end
end

SentryGunDamage.dead = function(l_6_0)
  return l_6_0._dead
end

SentryGunDamage.health_ratio = function(l_7_0)
  return l_7_0._health / HEALTH_MAX
end

SentryGunDamage.focus_delay_mul = function(l_8_0)
  return 1
end

SentryGunDamage.die = function(l_9_0)
  l_9_0._health = 0
  l_9_0._dead = true
  l_9_0._unit:set_slot(26)
  l_9_0._unit:brain():set_active(false)
  l_9_0._unit:movement():set_active(false)
  managers.groupai:state():on_criminal_neutralized(l_9_0._unit)
  l_9_0._unit:base():on_death()
  l_9_0._unit:sound_source():post_event("turret_breakdown")
  if l_9_0._unit:base():has_shield() then
    l_9_0._unit:damage():run_sequence_simple("broken_with_shield")
  else
    l_9_0._unit:damage():run_sequence_simple("broken")
  end
end

SentryGunDamage.save = function(l_10_0, l_10_1)
  local my_save_data = {}
  if l_10_0._health_sync then
    my_save_data.health = math.ceil(l_10_0._health_sync / l_10_0._health_sync_resolution)
  end
  if next(my_save_data) then
    l_10_1.char_damage = my_save_data
  end
end

SentryGunDamage.load = function(l_11_0, l_11_1)
  if not l_11_1 or not l_11_1.char_damage then
    return 
  end
  if l_11_1.char_damage.health then
    l_11_0:sync_health(l_11_1.char_damage.health)
  end
end

SentryGunDamage.destroy = function(l_12_0, l_12_1)
  l_12_1:brain():pre_destroy()
  l_12_1:movement():pre_destroy()
  l_12_1:base():pre_destroy()
end


