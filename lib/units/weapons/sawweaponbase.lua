-- Decompiled using luadec 2.0.1 by sztupy (http://winmo.sztupy.hu)
-- Command line was: F:\SteamLibrary\SteamApps\common\PAYDAY 2\lua\lib\units\weapons\sawweaponbase.luac 

local mvec3_set = mvector3.set
local mvec3_add = mvector3.add
local mvec3_dot = mvector3.dot
local mvec3_sub = mvector3.subtract
local mvec3_mul = mvector3.multiply
local mvec3_norm = mvector3.normalize
local mvec3_dir = mvector3.direction
local mvec3_set_l = mvector3.set_length
local mvec3_len = mvector3.length
local math_clamp = math.clamp
local math_lerp = math.lerp
local tmp_vec1 = Vector3()
local tmp_vec2 = Vector3()
if not SawWeaponBase then
  SawWeaponBase = class(NewRaycastWeaponBase)
end
SawWeaponBase.init = function(l_1_0, l_1_1)
  SawWeaponBase.super.init(l_1_0, l_1_1)
  l_1_0._active_effect_name = Idstring("effects/payday2/particles/weapons/saw/sawing")
  l_1_0._active_effect_table = {effect = l_1_0._active_effect_name, parent = l_1_0._obj_fire, force_synch = true}
end

SawWeaponBase.change_fire_object = function(l_2_0, l_2_1)
  SawWeaponBase.super.change_fire_object(l_2_0, l_2_1)
  l_2_0._active_effect_table.parent = l_2_1
end

SawWeaponBase.start_shooting = function(l_3_0, ...)
  SawWeaponBase.super.start_shooting(l_3_0, ...)
   -- DECOMPILER ERROR: Confused about usage of registers for local variables.

end

SawWeaponBase.stop_shooting = function(l_4_0, ...)
  l_4_0:_stop_sawing_effect()
  SawWeaponBase.super.stop_shooting(l_4_0, ...)
   -- DECOMPILER ERROR: Confused about usage of registers for local variables.

end

SawWeaponBase._play_sound_sawing = function(l_5_0)
  l_5_0:play_sound("Play_saw_handheld_grind_generic")
end

SawWeaponBase._play_sound_idle = function(l_6_0)
  l_6_0:play_sound("Play_saw_handheld_loop_idle")
end

SawWeaponBase._start_sawing_effect = function(l_7_0)
  if not l_7_0._active_effect then
    l_7_0:_play_sound_sawing()
    l_7_0._active_effect = World:effect_manager():spawn(l_7_0._active_effect_table)
  end
end

SawWeaponBase._stop_sawing_effect = function(l_8_0)
  if l_8_0._active_effect then
    l_8_0:_play_sound_idle()
    World:effect_manager():fade_kill(l_8_0._active_effect)
    l_8_0._active_effect = nil
  end
end

SawWeaponBase.setup = function(l_9_0, l_9_1)
  SawWeaponBase.super.setup(l_9_0, l_9_1)
  l_9_0._no_hit_alert_size = l_9_0._alert_size
  l_9_0._hit_alert_size = tweak_data.weapon.stats.alert_size[math.clamp(l_9_0:check_stats().suppression - (l_9_0:weapon_tweak_data().hit_alert_size_increase or 0), 1, #tweak_data.weapon.stats.alert_size)]
end

SawWeaponBase.fire = function(l_10_0, l_10_1, l_10_2, l_10_3, l_10_4, l_10_5, l_10_6, l_10_7, l_10_8)
  if l_10_0:get_ammo_remaining_in_clip() == 0 then
    return 
  end
  local user_unit = l_10_0._setup.user_unit
  local ray_res, hit_something = l_10_0:_fire_raycast(user_unit, l_10_1, l_10_2, l_10_3, l_10_4, l_10_5, l_10_6, l_10_7, l_10_8)
  if hit_something then
    l_10_0:_start_sawing_effect()
    local ammo_usage = 5
    if ray_res.hit_enemy and managers.player:has_category_upgrade("saw", "enemy_slicer") then
      ammo_usage = 10
    else
      ammo_usage = 15
    end
    ammo_usage = ammo_usage + math.ceil(math.random() * 10)
    l_10_0:set_ammo_remaining_in_clip(math.max(l_10_0:get_ammo_remaining_in_clip() - (ammo_usage), 0))
    l_10_0:set_ammo_total(math.max(l_10_0:get_ammo_total() - (ammo_usage), 0))
    l_10_0:_check_ammo_total(user_unit)
  else
    l_10_0:_stop_sawing_effect()
  end
  if l_10_0._alert_events and ray_res.rays then
    if hit_something then
      l_10_0._alert_size = l_10_0._hit_alert_size
    else
      l_10_0._alert_size = l_10_0._no_hit_alert_size
    end
    l_10_0._current_stats.alert_size = l_10_0._alert_size
    l_10_0:_check_alert(ray_res.rays, l_10_1, l_10_2, user_unit)
  end
  return ray_res
end

local mvec_to = Vector3()
local mvec_spread_direction = Vector3()
SawWeaponBase._fire_raycast = function(l_11_0, l_11_1, l_11_2, l_11_3, l_11_4, l_11_5, l_11_6, l_11_7, l_11_8)
  local result = {}
  local hit_unit = nil
  local spread = l_11_0:_get_spread(l_11_1)
  l_11_2 = l_11_0._obj_fire:position()
  l_11_3 = l_11_0._obj_fire:rotation():y()
  mvec3_add(l_11_2, l_11_3 * -30)
  mvector3.set(mvec_spread_direction, l_11_3)
  mvector3.set(mvec_to, mvec_spread_direction)
  mvector3.multiply(mvec_to, 100)
  mvector3.add(mvec_to, l_11_2)
  local damage = l_11_0:_get_current_damage(l_11_4)
  local col_ray = World:raycast("ray", l_11_2, mvec_to, "slot_mask", l_11_0._bullet_slotmask, "ignore_unit", l_11_0._setup.ignore_units, "ray_type", "body bullet lock")
  if col_ray then
    hit_unit = SawHit:on_collision(col_ray, l_11_0._unit, l_11_1, damage)
  end
  result.hit_enemy = hit_unit
  if l_11_0._alert_events then
    result.rays = {col_ray}
  end
  if col_ray then
    return result, col_ray.unit
  end
end

SawWeaponBase.ammo_info = function(l_12_0)
  return l_12_0:get_ammo_max_per_clip(), l_12_0:get_ammo_remaining_in_clip(), l_12_0:remaining_full_clips(), l_12_0:get_ammo_max()
end

SawWeaponBase.can_reload = function(l_13_0)
  if l_13_0:clip_empty() then
    return SawWeaponBase.super.can_reload(l_13_0)
  end
end

if not SawHit then
  SawHit = class(InstantBulletBase)
end
local tank_name_server = Idstring("units/payday2/characters/ene_bulldozer_1/ene_bulldozer_1")
local tank_name_client = Idstring("units/payday2/characters/ene_bulldozer_1/ene_bulldozer_1_husk")
SawHit.on_collision = function(l_14_0, l_14_1, l_14_2, l_14_3, l_14_4)
  local hit_unit = l_14_1.unit
  if hit_unit and (hit_unit:name() == tank_name_server or hit_unit:name() == tank_name_client) then
    l_14_4 = 50
  end
  local result = InstantBulletBase.on_collision(l_14_0, l_14_1, l_14_2, l_14_3, l_14_4)
  if hit_unit:damage() and l_14_1.body:extension() and l_14_1.body:extension().damage then
    l_14_4 = l_14_4 * managers.player:upgrade_value("saw", "lock_damage_multiplier", 1) * 4
    l_14_1.body:extension().damage:damage_lock(l_14_3, l_14_1.normal, l_14_1.position, l_14_1.direction, l_14_4)
    if hit_unit:id() ~= -1 then
      managers.network:session():send_to_peers_synched("sync_body_damage_lock", l_14_1.body, l_14_4)
    end
  end
  return result
end

SawHit.play_impact_sound_and_effects = function(l_15_0, l_15_1)
  managers.game_play_central:play_impact_sound_and_effects({decal = "saw", col_ray = l_15_1, no_sound = true})
end


