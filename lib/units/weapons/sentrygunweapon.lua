-- Decompiled using luadec 2.0.1 by sztupy (http://winmo.sztupy.hu)
-- Command line was: F:\SteamLibrary\SteamApps\common\PAYDAY 2\lua\lib\units\weapons\sentrygunweapon.luac 

if not SentryGunWeapon then
  SentryGunWeapon = class()
end
SentryGunWeapon.init = function(l_1_0, l_1_1)
  l_1_0._unit = l_1_1
  l_1_0._timer = TimerManager:game()
  l_1_0._name_id = l_1_0.name_id
  l_1_0.name_id = nil
  local my_tweak_data = tweak_data.weapon[l_1_0._name_id]
  l_1_0._bullet_slotmask = managers.slot:get_mask(Network:is_server() and "bullet_impact_targets_sentry_gun" or "bullet_blank_impact_targets")
  l_1_0._character_slotmask = managers.slot:get_mask("raycastable_characters")
  l_1_0._next_fire_allowed = -1000
  l_1_0._obj_fire = l_1_0._unit:get_object(Idstring("a_detect"))
   -- DECOMPILER ERROR: Overwrote pending register.

   -- DECOMPILER ERROR: Overwrote pending register.

  l_1_0._muzzle_effect, l_1_0._interleaving_fire, l_1_0._effect_align = Idstring(l_1_0._unit:get_object(Idstring("fire")) or "effects/particles/test/muzzleflash_maingun"), 1, {}
  l_1_0._muzzle_effect_table = {{effect = l_1_0._unit:get_object(Idstring("fire")), parent = l_1_0._effect_align[1], force_synch = false}, {effect = l_1_0._muzzle_effect, parent = l_1_0._effect_align[2], force_synch = false}}
  l_1_0._use_shell_ejection_effect = SystemInfo:platform() == Idstring("WIN32")
  if l_1_0._use_shell_ejection_effect then
    l_1_0._obj_shell_ejection = l_1_0._unit:get_object(Idstring("shell"))
    l_1_0._shell_ejection_effect = Idstring(tweak_data.weapon[l_1_0._name_id].shell_ejection or "effects/payday2/particles/weapons/shells/shell_556")
    l_1_0._shell_ejection_effect_table = {effect = l_1_0._shell_ejection_effect, parent = l_1_0._obj_shell_ejection}
  end
  l_1_0._damage = my_tweak_data.DAMAGE
  l_1_0._alert_events = {}
  l_1_0._alert_size = my_tweak_data.alert_size
  l_1_0._alert_fires = {}
  l_1_0._trail_effect_table = {effect = RaycastWeaponBase.TRAIL_EFFECT, position = Vector3(), normal = Vector3()}
  l_1_0._ammo_sync_resolution = 0.20000000298023
  if Network:is_server() then
    l_1_0._ammo_total = 1
    l_1_0._ammo_max = l_1_0._ammo_total
    l_1_0._ammo_sync = 1
  else
    l_1_0._ammo_ratio = 1
  end
  l_1_0._spread_mul = 1
end

SentryGunWeapon.setup = function(l_2_0, l_2_1, l_2_2)
  l_2_0._setup = l_2_1
  l_2_0._owner = l_2_1.user_unit
  l_2_0._damage = tweak_data.weapon[l_2_0._name_id].DAMAGE * l_2_2
  l_2_0._spread_mul = l_2_1.spread_mul
end

SentryGunWeapon.set_ammo = function(l_3_0, l_3_1)
  l_3_0._ammo_total = l_3_1
  l_3_0._ammo_max = math.max(l_3_0._ammo_max, l_3_1)
end

SentryGunWeapon.sync_ammo = function(l_4_0, l_4_1)
  l_4_0._ammo_ratio = l_4_1 * l_4_0._ammo_sync_resolution * 100
end

SentryGunWeapon.set_spread_mul = function(l_5_0, l_5_1)
  l_5_0._spread_mul = l_5_1
end

SentryGunWeapon.start_autofire = function(l_6_0)
  if l_6_0._shooting then
    return 
  end
  l_6_0:_sound_autofire_start()
  l_6_0._next_fire_allowed = math.max(l_6_0._next_fire_allowed, Application:time())
  l_6_0._shooting = true
  l_6_0._fire_start_t = l_6_0._timer:time()
end

SentryGunWeapon.stop_autofire = function(l_7_0)
  if not l_7_0._shooting then
    return 
  end
  if l_7_0:out_of_ammo() then
    l_7_0:_sound_autofire_end_empty()
  else
    if l_7_0._timer:time() - l_7_0._fire_start_t > 3 then
      l_7_0:_sound_autofire_end_cooldown()
    else
      l_7_0:_sound_autofire_end()
    end
  end
  l_7_0._shooting = nil
end

SentryGunWeapon.trigger_held = function(l_8_0, l_8_1, l_8_2)
  local fired = nil
  if l_8_0._next_fire_allowed <= l_8_0._timer:time() then
    fired = l_8_0:fire(l_8_1, l_8_2)
    if fired then
      l_8_0._next_fire_allowed = l_8_0._next_fire_allowed + tweak_data.weapon[l_8_0._name_id].auto.fire_rate
      l_8_0._interleaving_fire = l_8_0._interleaving_fire == 1 and 2 or 1
    end
  end
  return fired
end

SentryGunWeapon.fire = function(l_9_0, l_9_1, l_9_2)
  if l_9_2 then
    if l_9_0._ammo_total <= 0 then
      return 
    end
    l_9_0._ammo_total = l_9_0._ammo_total - 1
    local ammo_percent = l_9_0._ammo_total / l_9_0._ammo_max
    if ammo_percent == 0 or l_9_0._ammo_sync_resolution <= math.abs(ammo_percent - l_9_0._ammo_sync) then
      l_9_0._ammo_sync = ammo_percent
      l_9_0._unit:network():send("sentrygun_ammo", math.ceil(ammo_percent / l_9_0._ammo_sync_resolution))
    end
  end
  local fire_obj = l_9_0._effect_align[l_9_0._interleaving_fire]
  local from_pos = fire_obj:position()
  local direction = fire_obj:rotation():y()
  mvector3.spread(direction, tweak_data.weapon[l_9_0._name_id].SPREAD * l_9_0._spread_mul)
  World:effect_manager():spawn(l_9_0._muzzle_effect_table[l_9_0._interleaving_fire])
  if l_9_0._use_shell_ejection_effect then
    World:effect_manager():spawn(l_9_0._shell_ejection_effect_table)
  end
  local ray_res = l_9_0:_fire_raycast(from_pos, direction, l_9_1)
  if l_9_0._alert_events and ray_res.rays then
    RaycastWeaponBase._check_alert(l_9_0, ray_res.rays, from_pos, direction, l_9_0._unit)
  end
  l_9_0._unit:movement():give_recoil()
  return ray_res
end

local mvec_to = Vector3()
SentryGunWeapon._fire_raycast = function(l_10_0, l_10_1, l_10_2, l_10_3)
  local result = {}
  local hit_unit = nil
  mvector3.set(mvec_to, l_10_2)
  mvector3.multiply(mvec_to, tweak_data.weapon[l_10_0._name_id].FIRE_RANGE)
  mvector3.add(mvec_to, l_10_1)
  local col_ray = World:raycast("ray", l_10_1, mvec_to, "slot_mask", l_10_0._bullet_slotmask)
  if col_ray then
    if col_ray.unit:in_slot(l_10_0._character_slotmask) then
      hit_unit = InstantBulletBase:on_collision(col_ray, l_10_0._unit, l_10_0._unit, l_10_0._damage)
    else
      hit_unit = InstantBulletBase:on_collision(col_ray, l_10_0._unit, l_10_0._unit, l_10_0._damage)
    end
  end
  if not col_ray or col_ray.distance > 600 then
    l_10_0:_spawn_trail_effect(l_10_2, col_ray)
  end
  result.hit_enemy = hit_unit
  if l_10_0._alert_events then
    result.rays = {col_ray}
  end
  return result
end

SentryGunWeapon._sound_autofire_start = function(l_11_0)
  l_11_0._autofire_sound_event = l_11_0._unit:sound_source():post_event("turret_fire")
end

SentryGunWeapon._sound_autofire_end = function(l_12_0)
  if l_12_0._autofire_sound_event then
    l_12_0._autofire_sound_event:stop()
    l_12_0._autofire_sound_event = nil
  end
  l_12_0._unit:sound_source():post_event("turret_fire_end")
end

SentryGunWeapon._sound_autofire_end_empty = function(l_13_0)
  if l_13_0._autofire_sound_event then
    l_13_0._autofire_sound_event:stop()
    l_13_0._autofire_sound_event = nil
  end
  l_13_0._unit:sound_source():post_event("turret_ammo_depleted")
end

SentryGunWeapon._sound_autofire_end_cooldown = function(l_14_0)
  if l_14_0._autofire_sound_event then
    l_14_0._autofire_sound_event:stop()
    l_14_0._autofire_sound_event = nil
  end
  l_14_0._unit:sound_source():post_event("turret_fire_end")
  l_14_0._unit:sound_source():post_event("turret_cooldown")
end

SentryGunWeapon._spawn_trail_effect = function(l_15_0, l_15_1, l_15_2)
  l_15_0._effect_align[l_15_0._interleaving_fire]:m_position(l_15_0._trail_effect_table.position)
  mvector3.set(l_15_0._trail_effect_table.normal, l_15_1)
  local trail = World:effect_manager():spawn(l_15_0._trail_effect_table)
  if l_15_2 then
    World:effect_manager():set_remaining_lifetime(trail, math.clamp((l_15_2.distance - 600) / 10000, 0, l_15_2.distance))
  end
end

SentryGunWeapon.out_of_ammo = function(l_16_0)
  if l_16_0._ammo_total ~= 0 then
    return not l_16_0._ammo_total
  end
  do return end
  return l_16_0._ammo_ratio == 0
end

SentryGunWeapon.save = function(l_17_0, l_17_1)
  local my_save_data = {}
  if l_17_0._spread_mul ~= 1 then
    my_save_data.spread_mul = l_17_0._spread_mul
  end
  my_save_data.setup = {}
  my_save_data.setup.alert_filter = l_17_0._setup.alert_filter
  if next(my_save_data) then
    l_17_1.weapon = my_save_data
  end
end

SentryGunWeapon.load = function(l_18_0, l_18_1)
  if not l_18_1 or not l_18_1.weapon then
    l_18_0._spread_mul = 1
    return 
  end
  l_18_0._spread_mul = l_18_1.weapon.spread_mul or 1
  if not l_18_0._setup then
    l_18_0._setup = {}
  end
  for name,data in pairs(l_18_1.weapon.setup) do
    l_18_0._setup[name] = data
  end
end


