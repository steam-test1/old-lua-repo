-- Decompiled using luadec 2.0.1 by sztupy (http://winmo.sztupy.hu)
-- Command line was: F:\SteamLibrary\SteamApps\common\PAYDAY 2\lua\lib\units\weapons\newnpcraycastweaponbase.luac 

if not NewNPCRaycastWeaponBase then
  NewNPCRaycastWeaponBase = class(NewRaycastWeaponBase)
end
NewNPCRaycastWeaponBase._VOICES = {"a", "b", "c"}
NewNPCRaycastWeaponBase._next_i_voice = {}
NewNPCRaycastWeaponBase.init = function(l_1_0, l_1_1)
  NewRaycastWeaponBase.super.super.init(l_1_0, l_1_1, false)
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
  if l_1_0._multivoice then
    if not NewNPCRaycastWeaponBase._next_i_voice[l_1_0._name_id] then
      NewNPCRaycastWeaponBase._next_i_voice[l_1_0._name_id] = 1
    end
    l_1_0._voice = NewNPCRaycastWeaponBase._VOICES[NewNPCRaycastWeaponBase._next_i_voice[l_1_0._name_id]]
    if NewNPCRaycastWeaponBase._next_i_voice[l_1_0._name_id] == #NewNPCRaycastWeaponBase._VOICES then
      NewNPCRaycastWeaponBase._next_i_voice[l_1_0._name_id] = 1
    else
      NewNPCRaycastWeaponBase._next_i_voice[l_1_0._name_id] = NewNPCRaycastWeaponBase._next_i_voice[l_1_0._name_id] + 1
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

NewNPCRaycastWeaponBase.setup = function(l_2_0, l_2_1)
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
end

NewNPCRaycastWeaponBase.is_npc = function(l_3_0)
  return true
end

NewNPCRaycastWeaponBase.skip_queue = function(l_4_0)
  return true
end

NewNPCRaycastWeaponBase.check_npc = function(l_5_0)
  local gadget = managers.weapon_factory:get_part_from_weapon_by_type("gadget", l_5_0._parts)
  if gadget then
    gadget.unit:base():set_npc()
  end
end

NewNPCRaycastWeaponBase.start_autofire = function(l_6_0, l_6_1)
  l_6_0:_sound_autofire_start(l_6_1)
  l_6_0._next_fire_allowed = math.max(l_6_0._next_fire_allowed, Application:time())
  l_6_0._shooting = true
end

NewNPCRaycastWeaponBase.stop_autofire = function(l_7_0)
  l_7_0:_sound_autofire_end()
  l_7_0._shooting = nil
end

NewNPCRaycastWeaponBase.singleshot = function(l_8_0, ...)
  do
    local fired = l_8_0:fire(...)
    if fired then
      l_8_0:_sound_singleshot()
    end
    return fired
  end
   -- DECOMPILER ERROR: Confused about usage of registers for local variables.

end

NewNPCRaycastWeaponBase.trigger_held = function(l_9_0, ...)
   -- DECOMPILER ERROR: Overwrote pending register.

  if l_9_0._next_fire_allowed <= Application:time() and nil then
    l_9_0._next_fire_allowed = l_9_0._next_fire_allowed + tweak_data.weapon[l_9_0._name_id].auto.fire_rate
  end
   -- DECOMPILER ERROR: Confused about usage of registers!

  return nil
   -- DECOMPILER ERROR: Confused about usage of registers for local variables.

end

local mto = Vector3()
local mfrom = Vector3()
local mspread = Vector3()
NewNPCRaycastWeaponBase.fire_blank = function(l_10_0, l_10_1, l_10_2)
  local user_unit = l_10_0._setup.user_unit
  l_10_0._unit:m_position(mfrom)
  local rays = {}
  if l_10_2 then
    mvector3.set(mspread, l_10_1)
    mvector3.spread(mspread, 5)
    mvector3.set(mto, mspread)
    mvector3.multiply(mto, 20000)
    mvector3.add(mto, mfrom)
    local col_ray = World:raycast("ray", mfrom, mto, "slot_mask", l_10_0._blank_slotmask, "ignore_unit", l_10_0._setup.ignore_units)
    if alive(l_10_0._obj_fire) then
      l_10_0._obj_fire:m_position(l_10_0._trail_effect_table.position)
      mvector3.set(l_10_0._trail_effect_table.normal, mspread)
    end
    local trail = not alive(l_10_0._obj_fire) or ((not col_ray or col_ray.distance > 650) and World:effect_manager():spawn(l_10_0._trail_effect_table)) or nil
    if col_ray then
      InstantBulletBase:on_collision(col_ray, l_10_0._unit, user_unit, l_10_0._damage, true)
      if trail then
        World:effect_manager():set_remaining_lifetime(trail, math.clamp((col_ray.distance - 600) / 10000, 0, col_ray.distance))
      end
      table.insert(rays, col_ray)
    end
  end
  if alive(l_10_0._obj_fire) then
    World:effect_manager():spawn(l_10_0._muzzle_effect_table)
  end
  if l_10_0._use_shell_ejection_effect then
    World:effect_manager():spawn(l_10_0._shell_ejection_effect_table)
  end
  l_10_0:_sound_singleshot()
end

NewNPCRaycastWeaponBase.destroy = function(l_11_0, l_11_1)
  RaycastWeaponBase.super.pre_destroy(l_11_0, l_11_1)
  managers.weapon_factory:disassemble(l_11_0._parts)
  if l_11_0._shooting then
    l_11_0:stop_autofire()
  end
end

NewNPCRaycastWeaponBase._get_spread = function(l_12_0, l_12_1)
end

NewNPCRaycastWeaponBase._sound_autofire_start = function(l_13_0, l_13_1)
  local tweak_sound = tweak_data.weapon[l_13_0._name_id].sounds
  local sound_name = tweak_sound.prefix .. l_13_0._setup.user_sound_variant .. l_13_0._voice .. (l_13_1 and "_" .. tostring(l_13_1) .. "shot" or "_loop")
  local sound = l_13_0._sound_fire:post_event(sound_name)
  if not sound then
    sound_name = tweak_sound.prefix .. "1" .. l_13_0._voice .. "_end"
    sound = l_13_0._sound_fire:post_event(sound_name)
  end
end

NewNPCRaycastWeaponBase._sound_autofire_end = function(l_14_0)
  local tweak_sound = tweak_data.weapon[l_14_0._name_id].sounds
  local sound_name = tweak_sound.prefix .. l_14_0._setup.user_sound_variant .. l_14_0._voice .. "_end"
  local sound = l_14_0._sound_fire:post_event(sound_name)
  if not sound then
    sound_name = tweak_sound.prefix .. "1" .. l_14_0._voice .. "_end"
    sound = l_14_0._sound_fire:post_event(sound_name)
  end
end

NewNPCRaycastWeaponBase._sound_singleshot = function(l_15_0)
  local tweak_sound = tweak_data.weapon[l_15_0._name_id].sounds
  local sound_name = tweak_sound.prefix .. l_15_0._setup.user_sound_variant .. l_15_0._voice .. "_1shot"
  local sound = l_15_0._sound_fire:post_event(sound_name)
  if not sound then
    sound_name = tweak_sound.prefix .. "1" .. l_15_0._voice .. "_1shot"
    sound = l_15_0._sound_fire:post_event(sound_name)
  end
end

local mvec_to = Vector3()
NewNPCRaycastWeaponBase._fire_raycast = function(l_16_0, l_16_1, l_16_2, l_16_3, l_16_4, l_16_5)
  local result = {}
  local hit_unit = nil
  mvector3.set(mvec_to, l_16_3)
  mvector3.multiply(mvec_to, 20000)
  mvector3.add(mvec_to, l_16_2)
  local damage = l_16_0._damage * (l_16_4 or 1)
  local col_ray = World:raycast("ray", l_16_2, mvec_to, "slot_mask", l_16_0._bullet_slotmask, "ignore_unit", l_16_0._setup.ignore_units)
  if col_ray then
    if col_ray.unit:in_slot(l_16_0._character_slotmask) then
      hit_unit = InstantBulletBase:on_collision(col_ray, l_16_0._unit, l_16_1, damage)
    elseif l_16_5 and l_16_0._hit_player and l_16_0:damage_player(col_ray, l_16_2, l_16_3) then
      InstantBulletBase:on_hit_player(col_ray, l_16_0._unit, l_16_1, l_16_0._damage * (l_16_4 or 1))
    else
      hit_unit = InstantBulletBase:on_collision(col_ray, l_16_0._unit, l_16_1, damage)
    end
  elseif l_16_5 and l_16_0._hit_player then
    local hit, ray_data = l_16_0:damage_player(col_ray, l_16_2, l_16_3)
    if hit then
      InstantBulletBase:on_hit_player(ray_data, l_16_0._unit, l_16_1, damage)
    end
  end
  if not col_ray or col_ray.distance > 600 then
    l_16_0:_spawn_trail_effect(l_16_3, col_ray)
  end
  result.hit_enemy = hit_unit
  if l_16_0._alert_events then
    result.rays = {col_ray}
  end
  return result
end

NewNPCRaycastWeaponBase._spawn_trail_effect = function(l_17_0, l_17_1, l_17_2)
  if alive(not l_17_0._obj_fire) then
    return 
  end
  l_17_0._obj_fire:m_position(l_17_0._trail_effect_table.position)
  mvector3.set(l_17_0._trail_effect_table.normal, l_17_1)
  local trail = World:effect_manager():spawn(l_17_0._trail_effect_table)
  if l_17_2 then
    World:effect_manager():set_remaining_lifetime(trail, math.clamp((l_17_2.distance - 600) / 10000, 0, l_17_2.distance))
  end
end

NewNPCRaycastWeaponBase.has_flashlight_on = function(l_18_0)
   -- DECOMPILER ERROR: Confused while interpreting a jump as a 'while'

end
return true
end

NewNPCRaycastWeaponBase.flashlight_data = function(l_19_0)
  return l_19_0._flashlight_data
end

NewNPCRaycastWeaponBase.flashlight_state_changed = function(l_20_0)
  if not l_20_0._flashlight_data then
    return 
  end
  if not l_20_0._flashlight_data.enabled or l_20_0._flashlight_data.dropped then
    return 
  end
  if managers.game_play_central:flashlights_on() then
    l_20_0._flashlight_data.light:set_enable(l_20_0._flashlight_light_lod_enabled)
    l_20_0._flashlight_data.effect:activate()
    l_20_0._flashlight_data.on = true
  else
    l_20_0._flashlight_data.light:set_enable(false)
    l_20_0._flashlight_data.effect:kill_effect()
    l_20_0._flashlight_data.on = false
  end
end

NewNPCRaycastWeaponBase.set_flashlight_enabled = function(l_21_0, l_21_1)
  if not l_21_0._flashlight_data then
    return 
  end
  l_21_0._flashlight_data.enabled = l_21_1
  if managers.game_play_central:flashlights_on() and l_21_1 then
    l_21_0._flashlight_data.light:set_enable(l_21_0._flashlight_light_lod_enabled)
    l_21_0._flashlight_data.effect:activate()
    l_21_0._flashlight_data.on = true
  else
    l_21_0._flashlight_data.light:set_enable(false)
    l_21_0._flashlight_data.effect:kill_effect()
    l_21_0._flashlight_data.on = false
  end
end

NewNPCRaycastWeaponBase.set_flashlight_light_lod_enabled = function(l_22_0, l_22_1)
  if not l_22_0._flashlight_data then
    return 
  end
  l_22_0._flashlight_light_lod_enabled = l_22_1
  if l_22_0._flashlight_data.on and l_22_1 then
    l_22_0._flashlight_data.light:set_enable(true)
  else
    l_22_0._flashlight_data.light:set_enable(false)
  end
end


