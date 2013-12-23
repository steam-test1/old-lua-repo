-- Decompiled using luadec 2.0.1 by sztupy (http://winmo.sztupy.hu)
-- Command line was: F:\SteamLibrary\SteamApps\common\PAYDAY 2\lua\lib\units\weapons\npcraycastweaponbase.luac 

if not NPCRaycastWeaponBase then
  NPCRaycastWeaponBase = class(RaycastWeaponBase)
end
NPCRaycastWeaponBase._VOICES = {"a", "b", "c"}
NPCRaycastWeaponBase._next_i_voice = {}
NPCRaycastWeaponBase.init = function(l_1_0, l_1_1)
  RaycastWeaponBase.super.init(l_1_0, l_1_1, false)
  l_1_0._unit = l_1_1
  l_1_0._name_id = l_1_0.name_id or "m4_npc"
  l_1_0.name_id = nil
  l_1_0._bullet_slotmask = managers.slot:get_mask("bullet_impact_targets")
  l_1_0._blank_slotmask = managers.slot:get_mask("bullet_blank_impact_targets")
  l_1_0:_create_use_setups()
  l_1_0._setup = {}
  l_1_0._digest_values = false
  l_1_0:set_ammo_max(tweak_data.weapon[l_1_0._name_id].AMMO_MAX)
  l_1_0:set_ammo_total(l_1_0:get_ammo_max())
  l_1_0:set_ammo_max_per_clip(tweak_data.weapon[l_1_0._name_id].CLIP_AMMO_MAX)
  l_1_0:set_ammo_remaining_in_clip(l_1_0:get_ammo_max_per_clip())
  l_1_0._damage = tweak_data.weapon[l_1_0._name_id].DAMAGE
  l_1_0._next_fire_allowed = -1000
  l_1_0._obj_fire = l_1_0._unit:get_object(Idstring("fire"))
  l_1_0._sound_fire = SoundDevice:create_source("fire")
  l_1_0._sound_fire:link(l_1_0._unit:orientation_object())
  l_1_0._muzzle_effect = Idstring(l_1_0:weapon_tweak_data().muzzleflash or "effects/particles/test/muzzleflash_maingun")
  l_1_0._muzzle_effect_table = {effect = l_1_0._muzzle_effect, parent = l_1_0._obj_fire, force_synch = false}
  l_1_0._use_shell_ejection_effect = SystemInfo:platform() == Idstring("WIN32")
  if l_1_0._use_shell_ejection_effect then
    l_1_0._obj_shell_ejection = l_1_0._unit:get_object(Idstring("a_shell"))
    l_1_0._shell_ejection_effect = Idstring(l_1_0:weapon_tweak_data().shell_ejection or "effects/payday2/particles/weapons/shells/shell_556")
    l_1_0._shell_ejection_effect_table = {effect = l_1_0._shell_ejection_effect, parent = l_1_0._obj_shell_ejection}
  end
  l_1_0._trail_effect_table = {effect = l_1_0.TRAIL_EFFECT, position = Vector3(), normal = Vector3()}
  l_1_0._flashlight_light_lod_enabled = true
  do return end
  if l_1_0._multivoice then
    if not NPCRaycastWeaponBase._next_i_voice[l_1_0._name_id] then
      NPCRaycastWeaponBase._next_i_voice[l_1_0._name_id] = 1
    end
    l_1_0._voice = NPCRaycastWeaponBase._VOICES[NPCRaycastWeaponBase._next_i_voice[l_1_0._name_id]]
    if NPCRaycastWeaponBase._next_i_voice[l_1_0._name_id] == #NPCRaycastWeaponBase._VOICES then
      NPCRaycastWeaponBase._next_i_voice[l_1_0._name_id] = 1
    else
      NPCRaycastWeaponBase._next_i_voice[l_1_0._name_id] = NPCRaycastWeaponBase._next_i_voice[l_1_0._name_id] + 1
    end
  else
    l_1_0._voice = "a"
  end
  if l_1_0._unit:get_object(Idstring("ls_flashlight")) then
    l_1_0._flashlight_data = {}
    l_1_0._flashlight_data.light = l_1_0._unit:get_object(Idstring("ls_flashlight"))
    l_1_0._flashlight_data.effect = l_1_0._unit:effect_spawner(Idstring("flashlight"))
    l_1_0._flashlight_data.light:set_far_range(400)
    l_1_0._flashlight_data.light:set_spot_angle_end(25)
    l_1_0._flashlight_data.light:set_multiplier(2)
  end
end

NPCRaycastWeaponBase.setup = function(l_2_0, l_2_1)
  l_2_0._autoaim = l_2_1.autoaim
  l_2_0._alert_events = l_2_1.alert_AI and {} or nil
  l_2_0._alert_size = tweak_data.weapon[l_2_0._name_id].alert_size
  l_2_0._alert_fires = {}
  l_2_0._suppression = tweak_data.weapon[l_2_0._name_id].suppression
  if not l_2_1.hit_slotmask then
    l_2_0._bullet_slotmask = l_2_0._bullet_slotmask
  end
  l_2_0._character_slotmask = managers.slot:get_mask("raycastable_characters")
   -- DECOMPILER ERROR: Confused while interpreting a jump as a 'while'

end
l_2_0._hit_player = true
l_2_0._setup = l_2_1
l_2_0._setup.user_sound_variant = 1
end

NPCRaycastWeaponBase.start_autofire = function(l_3_0, l_3_1)
  l_3_0:_sound_autofire_start(l_3_1)
  l_3_0._next_fire_allowed = math.max(l_3_0._next_fire_allowed, Application:time())
  l_3_0._shooting = true
end

NPCRaycastWeaponBase.stop_autofire = function(l_4_0)
  if not l_4_0._shooting then
    return 
  end
  l_4_0:_sound_autofire_end()
  l_4_0._shooting = nil
end

NPCRaycastWeaponBase.singleshot = function(l_5_0, ...)
  do
    local fired = l_5_0:fire(...)
    if fired then
      l_5_0:_sound_singleshot()
    end
    return fired
  end
   -- DECOMPILER ERROR: Confused about usage of registers for local variables.

end

NPCRaycastWeaponBase.trigger_held = function(l_6_0, ...)
   -- DECOMPILER ERROR: Overwrote pending register.

  if l_6_0._next_fire_allowed <= Application:time() and nil then
    l_6_0._next_fire_allowed = l_6_0._next_fire_allowed + tweak_data.weapon[l_6_0._name_id].auto.fire_rate
  end
   -- DECOMPILER ERROR: Confused about usage of registers!

  return nil
   -- DECOMPILER ERROR: Confused about usage of registers for local variables.

end

NPCRaycastWeaponBase.add_damage_multiplier = function(l_7_0, l_7_1)
  l_7_0._damage = l_7_0._damage * l_7_1
end

local mto = Vector3()
local mfrom = Vector3()
local mspread = Vector3()
NPCRaycastWeaponBase.fire_blank = function(l_8_0, l_8_1, l_8_2)
  local user_unit = l_8_0._setup.user_unit
  l_8_0._unit:m_position(mfrom)
  local rays = {}
  if l_8_2 then
    mvector3.set(mspread, l_8_1)
    mvector3.spread(mspread, 5)
    mvector3.set(mto, mspread)
    mvector3.multiply(mto, 20000)
    mvector3.add(mto, mfrom)
    local col_ray = World:raycast("ray", mfrom, mto, "slot_mask", l_8_0._blank_slotmask, "ignore_unit", l_8_0._setup.ignore_units)
    l_8_0._obj_fire:m_position(l_8_0._trail_effect_table.position)
    mvector3.set(l_8_0._trail_effect_table.normal, mspread)
    local trail = (not col_ray or col_ray.distance > 650) and World:effect_manager():spawn(l_8_0._trail_effect_table) or nil
    if col_ray then
      InstantBulletBase:on_collision(col_ray, l_8_0._unit, user_unit, l_8_0._damage, true)
      if trail then
        World:effect_manager():set_remaining_lifetime(trail, math.clamp((col_ray.distance - 600) / 10000, 0, col_ray.distance))
      end
      table.insert(rays, col_ray)
    end
  end
  World:effect_manager():spawn(l_8_0._muzzle_effect_table)
  l_8_0:_sound_singleshot()
end

NPCRaycastWeaponBase.destroy = function(l_9_0, l_9_1)
  RaycastWeaponBase.super.pre_destroy(l_9_0, l_9_1)
  if l_9_0._shooting then
    l_9_0:stop_autofire()
  end
end

NPCRaycastWeaponBase._get_spread = function(l_10_0, l_10_1)
end

NPCRaycastWeaponBase._sound_autofire_start = function(l_11_0, l_11_1)
  local tweak_sound = tweak_data.weapon[l_11_0._name_id].sounds
  local sound_name = tweak_sound.prefix .. l_11_0._setup.user_sound_variant .. l_11_0._voice .. (l_11_1 and "_" .. tostring(l_11_1) .. "shot" or "_loop")
  local sound = l_11_0._sound_fire:post_event(sound_name)
  if not sound then
    sound_name = tweak_sound.prefix .. "1" .. l_11_0._voice .. "_end"
    sound = l_11_0._sound_fire:post_event(sound_name)
  end
end

NPCRaycastWeaponBase._sound_autofire_end = function(l_12_0)
  local tweak_sound = tweak_data.weapon[l_12_0._name_id].sounds
  local sound_name = tweak_sound.prefix .. l_12_0._setup.user_sound_variant .. l_12_0._voice .. "_end"
  local sound = l_12_0._sound_fire:post_event(sound_name)
  if not sound then
    sound_name = tweak_sound.prefix .. "1" .. l_12_0._voice .. "_end"
    sound = l_12_0._sound_fire:post_event(sound_name)
  end
end

NPCRaycastWeaponBase._sound_singleshot = function(l_13_0)
  local tweak_sound = tweak_data.weapon[l_13_0._name_id].sounds
  local sound_name = tweak_sound.prefix .. l_13_0._setup.user_sound_variant .. l_13_0._voice .. "_1shot"
  local sound = l_13_0._sound_fire:post_event(sound_name)
  if not sound then
    sound_name = tweak_sound.prefix .. "1" .. l_13_0._voice .. "_1shot"
    sound = l_13_0._sound_fire:post_event(sound_name)
  end
end

local mvec_to = Vector3()
NPCRaycastWeaponBase._fire_raycast = function(l_14_0, l_14_1, l_14_2, l_14_3, l_14_4, l_14_5, l_14_6)
  local result = {}
  local hit_unit = nil
  mvector3.set(mvec_to, l_14_3)
  mvector3.multiply(mvec_to, 20000)
  mvector3.add(mvec_to, l_14_2)
  local damage = l_14_0._damage * (l_14_4 or 1)
  local col_ray = World:raycast("ray", l_14_2, mvec_to, "slot_mask", l_14_0._bullet_slotmask, "ignore_unit", l_14_0._setup.ignore_units)
  if col_ray then
    if col_ray.unit:in_slot(l_14_0._character_slotmask) then
      hit_unit = InstantBulletBase:on_collision(col_ray, l_14_0._unit, l_14_1, damage)
    else
      local hit, ray = nil, nil
      if l_14_5 and l_14_0._hit_player then
        hit, ray = l_14_0:damage_player(col_ray, l_14_2, l_14_3)
        if not l_14_4 then
          InstantBulletBase:on_hit_player(col_ray, l_14_0._unit, l_14_1, l_14_0._damage * (not hit or 1))
        end
      end
      if not hit then
        hit_unit = InstantBulletBase:on_collision(col_ray, l_14_0._unit, l_14_1, damage)
        if l_14_6 and l_14_6:character_damage() and l_14_6:character_damage().build_suppression then
          l_14_6:character_damage():build_suppression(tweak_data.weapon[l_14_0._name_id].suppression)
        elseif l_14_5 and l_14_0._hit_player then
          local hit, ray_data = l_14_0:damage_player(col_ray, l_14_2, l_14_3)
          if hit then
            InstantBulletBase:on_hit_player(ray_data, l_14_0._unit, l_14_1, damage)
          end
        end
      end
    end
  end
  if not col_ray or col_ray.distance > 600 then
    l_14_0:_spawn_trail_effect(l_14_3, col_ray)
  end
  result.hit_enemy = hit_unit
  if l_14_0._alert_events then
    result.rays = {col_ray}
  end
  return result
end

NPCRaycastWeaponBase._spawn_trail_effect = function(l_15_0, l_15_1, l_15_2)
  l_15_0._obj_fire:m_position(l_15_0._trail_effect_table.position)
  mvector3.set(l_15_0._trail_effect_table.normal, l_15_1)
  local trail = World:effect_manager():spawn(l_15_0._trail_effect_table)
  if l_15_2 then
    World:effect_manager():set_remaining_lifetime(trail, math.clamp((l_15_2.distance - 600) / 10000, 0, l_15_2.distance))
  end
end

NPCRaycastWeaponBase.has_flashlight_on = function(l_16_0)
   -- DECOMPILER ERROR: Confused while interpreting a jump as a 'while'

end
return true
end

NPCRaycastWeaponBase.flashlight_data = function(l_17_0)
  return l_17_0._flashlight_data
end

NPCRaycastWeaponBase.flashlight_state_changed = function(l_18_0)
  if not l_18_0._flashlight_data then
    return 
  end
  if not l_18_0._flashlight_data.enabled or l_18_0._flashlight_data.dropped then
    return 
  end
  if managers.game_play_central:flashlights_on() then
    l_18_0._flashlight_data.light:set_enable(l_18_0._flashlight_light_lod_enabled)
    l_18_0._flashlight_data.effect:activate()
    l_18_0._flashlight_data.on = true
  else
    l_18_0._flashlight_data.light:set_enable(false)
    l_18_0._flashlight_data.effect:kill_effect()
    l_18_0._flashlight_data.on = false
  end
end

NPCRaycastWeaponBase.set_flashlight_enabled = function(l_19_0, l_19_1)
  if not l_19_0._flashlight_data then
    return 
  end
  l_19_0._flashlight_data.enabled = l_19_1
  if managers.game_play_central:flashlights_on() and l_19_1 then
    l_19_0._flashlight_data.light:set_enable(l_19_0._flashlight_light_lod_enabled)
    l_19_0._flashlight_data.effect:activate()
    l_19_0._flashlight_data.on = true
  else
    l_19_0._flashlight_data.light:set_enable(false)
    l_19_0._flashlight_data.effect:kill_effect()
    l_19_0._flashlight_data.on = false
  end
end

NPCRaycastWeaponBase.set_flashlight_light_lod_enabled = function(l_20_0, l_20_1)
  if not l_20_0._flashlight_data then
    return 
  end
  l_20_0._flashlight_light_lod_enabled = l_20_1
  if l_20_0._flashlight_data.on and l_20_1 then
    l_20_0._flashlight_data.light:set_enable(true)
  else
    l_20_0._flashlight_data.light:set_enable(false)
  end
end

NPCRaycastWeaponBase.set_laser_enabled = function(l_21_0, l_21_1)
  if l_21_1 then
    if alive(l_21_0._laser_unit) then
      return 
    end
    local spawn_rot = l_21_0._obj_fire:rotation()
    local spawn_pos = l_21_0._obj_fire:position()
    spawn_pos = spawn_pos - spawn_rot:y() * 8 + spawn_rot:z() * 2 - spawn_rot:x() * 1.5
    l_21_0._laser_unit = World:spawn_unit(Idstring("units/payday2/weapons/wpn_npc_upg_fl_ass_smg_sho_peqbox/wpn_npc_upg_fl_ass_smg_sho_peqbox"), spawn_pos, spawn_rot)
    l_21_0._unit:link(l_21_0._obj_fire:name(), l_21_0._laser_unit)
    l_21_0._laser_unit:base():set_npc()
    l_21_0._laser_unit:base():set_on()
    l_21_0._laser_unit:base():set_color(Color(0.15000000596046, 1, 0, 0))
    l_21_0._laser_unit:base():set_max_distace(10000)
  else
    if alive(l_21_0._laser_unit) then
      l_21_0._laser_unit:set_slot(0)
      l_21_0._laser_unit = nil
    end
  end
end


