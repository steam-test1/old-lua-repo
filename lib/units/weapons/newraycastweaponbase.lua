-- Decompiled using luadec 2.0.1 by sztupy (http://winmo.sztupy.hu)
-- Command line was: F:\SteamLibrary\SteamApps\common\PAYDAY 2\lua\lib\units\weapons\newraycastweaponbase.luac 

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
if not NewRaycastWeaponBase then
  NewRaycastWeaponBase = class(RaycastWeaponBase)
end
NewRaycastWeaponBase.init = function(l_1_0, l_1_1)
  NewRaycastWeaponBase.super.init(l_1_0, l_1_1)
end

NewRaycastWeaponBase.is_npc = function(l_2_0)
  return false
end

NewRaycastWeaponBase.skip_queue = function(l_3_0)
  return false
end

NewRaycastWeaponBase.set_factory_data = function(l_4_0, l_4_1)
  l_4_0._factory_id = l_4_1
end

NewRaycastWeaponBase.assemble = function(l_5_0, l_5_1)
  local third_person = l_5_0:is_npc()
  local skip_queue = l_5_0:skip_queue()
  l_5_0._parts, l_5_0._blueprint = managers.weapon_factory:assemble_default(l_5_1, l_5_0._unit, third_person, callback(l_5_0, l_5_0, "_assemble_completed"), skip_queue), managers.weapon_factory
  l_5_0:_update_stats_values()
  return 
  local third_person = l_5_0:is_npc()
  l_5_0._parts, l_5_0._blueprint = managers.weapon_factory:assemble_default(l_5_1, l_5_0._unit, third_person), managers.weapon_factory
  l_5_0:_update_fire_object()
  l_5_0:_update_stats_values()
end

NewRaycastWeaponBase.assemble_from_blueprint = function(l_6_0, l_6_1, l_6_2)
  local third_person = l_6_0:is_npc()
  local skip_queue = l_6_0:skip_queue()
  l_6_0._parts, l_6_0._blueprint = managers.weapon_factory:assemble_from_blueprint(l_6_1, l_6_0._unit, l_6_2, third_person, callback(l_6_0, l_6_0, "_assemble_completed"), skip_queue), managers.weapon_factory
  l_6_0:_update_stats_values()
  return 
  local third_person = l_6_0:is_npc()
  l_6_0._parts, l_6_0._blueprint = managers.weapon_factory:assemble_from_blueprint(l_6_1, l_6_0._unit, l_6_2, third_person), managers.weapon_factory
  l_6_0:_update_fire_object()
  l_6_0:_update_stats_values()
end

NewRaycastWeaponBase._assemble_completed = function(l_7_0, l_7_1, l_7_2)
  print("NewRaycastWeaponBase:_assemble_completed", l_7_1, l_7_2)
  l_7_0._parts = l_7_1
  l_7_0._blueprint = l_7_2
  l_7_0:_update_fire_object()
  l_7_0:_update_stats_values()
  l_7_0:check_npc()
  l_7_0:_set_parts_enabled(l_7_0._enabled)
end

NewRaycastWeaponBase.check_npc = function(l_8_0)
end

NewRaycastWeaponBase.change_part = function(l_9_0, l_9_1)
  l_9_0._parts = managers.weapon_factory:change_part(l_9_0._unit, l_9_0._factory_id, l_9_1 or "wpn_fps_m4_uupg_b_sd", l_9_0._parts, l_9_0._blueprint)
  l_9_0:_update_fire_object()
  l_9_0:_update_stats_values()
end

NewRaycastWeaponBase.remove_part = function(l_10_0, l_10_1)
  l_10_0._parts = managers.weapon_factory:remove_part(l_10_0._unit, l_10_0._factory_id, l_10_1, l_10_0._parts, l_10_0._blueprint)
  l_10_0:_update_fire_object()
  l_10_0:_update_stats_values()
end

NewRaycastWeaponBase.remove_part_by_type = function(l_11_0, l_11_1)
  l_11_0._parts = managers.weapon_factory:remove_part_by_type(l_11_0._unit, l_11_0._factory_id, l_11_1, l_11_0._parts, l_11_0._blueprint)
  l_11_0:_update_fire_object()
  l_11_0:_update_stats_values()
end

NewRaycastWeaponBase.change_blueprint = function(l_12_0, l_12_1)
  l_12_0._blueprint = l_12_1
  l_12_0._parts = managers.weapon_factory:change_blueprint(l_12_0._unit, l_12_0._factory_id, l_12_0._parts, l_12_1)
  l_12_0:_update_fire_object()
  l_12_0:_update_stats_values()
end

NewRaycastWeaponBase.blueprint_to_string = function(l_13_0)
  local s = managers.weapon_factory:blueprint_to_string(l_13_0._factory_id, l_13_0._blueprint)
  return s
end

NewRaycastWeaponBase._update_fire_object = function(l_14_0)
  if not managers.weapon_factory:get_part_from_weapon_by_type("barrel_ext", l_14_0._parts) and not managers.weapon_factory:get_part_from_weapon_by_type("slide", l_14_0._parts) then
    local fire = managers.weapon_factory:get_part_from_weapon_by_type("barrel", l_14_0._parts)
  end
  l_14_0:change_fire_object(fire.unit:get_object(Idstring("fire")))
end

NewRaycastWeaponBase._update_stats_values = function(l_15_0)
  l_15_0:_check_sound_switch()
  l_15_0._silencer = managers.weapon_factory:has_perk("silencer", l_15_0._factory_id, l_15_0._blueprint)
  if not l_15_0:weapon_tweak_data().muzzleflash_silenced then
    l_15_0._muzzle_effect = Idstring(not l_15_0._silencer or "effects/payday2/particles/weapons/9mm_auto_silence_fps")
    do return end
    l_15_0._muzzle_effect = Idstring(l_15_0:weapon_tweak_data().muzzleflash or "effects/particles/test/muzzleflash_maingun")
    l_15_0._muzzle_effect_table = {effect = l_15_0._muzzle_effect, parent = l_15_0._obj_fire, force_synch = l_15_0._muzzle_effect_table.force_synch or false}
    local base_stats = l_15_0:weapon_tweak_data().stats
    if not base_stats then
      return 
    end
    local parts_stats = managers.weapon_factory:get_stats(l_15_0._factory_id, l_15_0._blueprint)
    local stats = deep_clone(base_stats)
    local tweak_data = tweak_data.weapon.stats
    if stats.zoom then
      stats.zoom = math.min(stats.zoom + managers.player:upgrade_value(l_15_0:weapon_tweak_data().category, "zoom_increase", 0), #tweak_data.zoom)
    end
    for stat,_ in pairs(stats) do
      if parts_stats[stat] then
        stats[stat] = math_clamp(stats[stat] + parts_stats[stat], 1, #tweak_data[stat])
      end
    end
    l_15_0._current_stats = {}
    for stat,i in pairs(stats) do
      l_15_0._current_stats[stat] = tweak_data[stat][i]
    end
    l_15_0._current_stats.alert_size = tweak_data.alert_size[math_clamp(stats.suppression, 1, #tweak_data.alert_size)]
     -- DECOMPILER ERROR: Confused while interpreting a jump as a 'while'

  end
  stats.suspicion = math.clamp(#tweak_data.concealment - base_stats.concealment - (not stats.concealment or 0), 1, #tweak_data.concealment)
  l_15_0._current_stats.suspicion = tweak_data.concealment[stats.suspicion]
  if not l_15_0._current_stats.alert_size then
    l_15_0._alert_size = l_15_0._alert_size
  end
  if not l_15_0._current_stats.suppression then
    l_15_0._suppression = l_15_0._suppression
  end
  if not l_15_0._current_stats.zoom then
    l_15_0._zoom = l_15_0._zoom
  end
  if not l_15_0._current_stats.spread then
    l_15_0._spread = l_15_0._spread
  end
  if not l_15_0._current_stats.recoil then
    l_15_0._recoil = l_15_0._recoil
  end
  if not l_15_0._current_stats.spread_moving then
    l_15_0._spread_moving = l_15_0._spread_moving
  end
  if not l_15_0._current_stats.extra_ammo then
    l_15_0._extra_ammo = l_15_0._extra_ammo
  end
  l_15_0:replenish()
end

NewRaycastWeaponBase._check_sound_switch = function(l_16_0)
  local suppressed_switch = managers.weapon_factory:get_sound_switch("suppressed", l_16_0._factory_id, l_16_0._blueprint)
  l_16_0._sound_fire:set_switch("suppressed", suppressed_switch or "regular")
end

NewRaycastWeaponBase.stance_id = function(l_17_0)
  return "new_m4"
end

NewRaycastWeaponBase.weapon_hold = function(l_18_0)
  return l_18_0:weapon_tweak_data().weapon_hold
end

NewRaycastWeaponBase.replenish = function(l_19_0)
  local ammo_max_multiplier = managers.player:upgrade_value("player", "extra_ammo_multiplier", 1)
  ammo_max_multiplier = ammo_max_multiplier * managers.player:upgrade_value(l_19_0:weapon_tweak_data().category, "extra_ammo_multiplier", 1)
  local ammo_max_per_clip = l_19_0:calculate_ammo_max_per_clip()
  local ammo_max = math.round((tweak_data.weapon[l_19_0._name_id].AMMO_MAX + managers.player:upgrade_value(l_19_0._name_id, "clip_amount_increase") * ammo_max_per_clip) * (ammo_max_multiplier))
  l_19_0:set_ammo_max_per_clip(ammo_max_per_clip)
  l_19_0:set_ammo_max(ammo_max)
  l_19_0:set_ammo_total(ammo_max)
  l_19_0:set_ammo_remaining_in_clip(ammo_max_per_clip)
  l_19_0._ammo_pickup = tweak_data.weapon[l_19_0._name_id].AMMO_PICKUP
  l_19_0:update_damage()
end

NewRaycastWeaponBase.update_damage = function(l_20_0)
  l_20_0._damage = (l_20_0._current_stats and l_20_0._current_stats.damage or 0) * l_20_0:damage_multiplier()
end

NewRaycastWeaponBase.calculate_ammo_max_per_clip = function(l_21_0)
  local ammo = tweak_data.weapon[l_21_0._name_id].CLIP_AMMO_MAX
  ammo = ammo + managers.player:upgrade_value(l_21_0._name_id, "clip_ammo_increase")
  if not l_21_0:upgrade_blocked("weapon", "clip_ammo_increase") then
    ammo = ammo + managers.player:upgrade_value("weapon", "clip_ammo_increase", 0)
  end
  ammo = ammo + (l_21_0._extra_ammo or 0)
  return ammo
end

NewRaycastWeaponBase.stance_mod = function(l_22_0)
  if not l_22_0._parts then
    return nil
  end
  local factory = tweak_data.weapon.factory
  for part_id,data in pairs(l_22_0._parts) do
    if factory.parts[part_id].stance_mod and factory.parts[part_id].stance_mod[l_22_0._factory_id] then
      return {translation = factory.parts[part_id].stance_mod[l_22_0._factory_id].translation}
    end
  end
  return nil
end

NewRaycastWeaponBase.tweak_data_anim_play = function(l_23_0, l_23_1, l_23_2)
  local data = tweak_data.weapon.factory[l_23_0._factory_id]
  if data.animations and data.animations[l_23_1] then
    local anim_name = data.animations[l_23_1]
    local length = l_23_0._unit:anim_length(Idstring(anim_name))
    if not l_23_2 then
      l_23_2 = 1
    end
    l_23_0._unit:anim_stop(Idstring(anim_name))
    l_23_0._unit:anim_play_to(Idstring(anim_name), length, l_23_2)
  end
  for part_id,data in pairs(l_23_0._parts) do
    if data.animations and data.animations[l_23_1] then
      local anim_name = data.animations[l_23_1]
      local length = data.unit:anim_length(Idstring(anim_name))
      if not l_23_2 then
        l_23_2 = 1
      end
      data.unit:anim_stop(Idstring(anim_name))
      data.unit:anim_play_to(Idstring(anim_name), length, l_23_2)
    end
  end
  NewRaycastWeaponBase.super.tweak_data_anim_play(l_23_0, l_23_1, l_23_2)
  return true
end

NewRaycastWeaponBase.tweak_data_anim_stop = function(l_24_0, l_24_1)
  local data = tweak_data.weapon.factory[l_24_0._factory_id]
  if data.animations and data.animations[l_24_1] then
    local anim_name = data.animations[l_24_1]
    l_24_0._unit:anim_stop(Idstring(anim_name))
  end
  for part_id,data in pairs(l_24_0._parts) do
    if data.animations and data.animations[l_24_1] then
      local anim_name = data.animations[l_24_1]
      data.unit:anim_stop(Idstring(anim_name))
    end
  end
end

NewRaycastWeaponBase._set_parts_enabled = function(l_25_0, l_25_1)
  if l_25_0._parts then
    for part_id,data in pairs(l_25_0._parts) do
      if alive(data.unit) then
        data.unit:set_enabled(l_25_1)
      end
    end
  end
end

NewRaycastWeaponBase.on_enabled = function(l_26_0, ...)
  NewRaycastWeaponBase.super.on_enabled(l_26_0, ...)
  l_26_0:_set_parts_enabled(true)
   -- DECOMPILER ERROR: Confused about usage of registers for local variables.

end

NewRaycastWeaponBase.on_disabled = function(l_27_0, ...)
  NewRaycastWeaponBase.super.on_disabled(l_27_0, ...)
  l_27_0:gadget_off()
  l_27_0:_set_parts_enabled(false)
   -- DECOMPILER ERROR: Confused about usage of registers for local variables.

end

NewRaycastWeaponBase.has_gadget = function(l_28_0)
   -- DECOMPILER ERROR: Confused while interpreting a jump as a 'while'

end
return true
end

NewRaycastWeaponBase.gadget_on = function(l_29_0)
  l_29_0._gadget_on = true
  local gadget = managers.weapon_factory:get_part_from_weapon_by_type("gadget", l_29_0._parts)
  if gadget then
    gadget.unit:base():set_state(l_29_0._gadget_on, l_29_0._sound_fire)
  end
end

NewRaycastWeaponBase.gadget_off = function(l_30_0)
  l_30_0._gadget_on = false
  local gadget = managers.weapon_factory:get_part_from_weapon_by_type("gadget", l_30_0._parts)
  if gadget then
    gadget.unit:base():set_state(l_30_0._gadget_on, l_30_0._sound_fire)
  end
end

NewRaycastWeaponBase.toggle_gadget = function(l_31_0)
  l_31_0._gadget_on = not l_31_0._gadget_on
  local gadget = managers.weapon_factory:get_part_from_weapon_by_type("gadget", l_31_0._parts)
  if gadget then
    gadget.unit:base():set_state(l_31_0._gadget_on, l_31_0._sound_fire)
  end
end

NewRaycastWeaponBase.check_stats = function(l_32_0)
  local base_stats = l_32_0:weapon_tweak_data().stats
  if not base_stats then
    print("no stats")
    return 
  end
  local parts_stats = managers.weapon_factory:get_stats(l_32_0._factory_id, l_32_0._blueprint)
  local stats = deep_clone(base_stats)
  local tweak_data = tweak_data.weapon.stats
  stats.zoom = math.min(stats.zoom + managers.player:upgrade_value(l_32_0:weapon_tweak_data().category, "zoom_increase", 0), #tweak_data.zoom)
  for stat,_ in pairs(stats) do
    if parts_stats[stat] then
      stats[stat] = math_clamp(stats[stat] + parts_stats[stat], 1, #tweak_data[stat])
    end
  end
  l_32_0._current_stats = {}
  for stat,i in pairs(stats) do
    l_32_0._current_stats[stat] = tweak_data[stat][i]
  end
  l_32_0._current_stats.alert_size = tweak_data.alert_size[math_clamp(stats.suppression, 1, #tweak_data.alert_size)]
  return stats
end

NewRaycastWeaponBase._convert_add_to_mul = function(l_33_0, l_33_1)
  if l_33_1 > 1 then
    return 1 / l_33_1
  elseif l_33_1 < 1 then
    return math.abs(l_33_1 - 1) + 1
  else
    return 1
  end
end

NewRaycastWeaponBase._get_spread = function(l_34_0, l_34_1)
  local current_state = l_34_1:movement()._current_state
  local spread_multiplier = l_34_0:spread_multiplier(current_state)
  return l_34_0._spread * spread_multiplier
end

NewRaycastWeaponBase.damage_multiplier = function(l_35_0)
  local multiplier = 1
  multiplier = multiplier + (1 - managers.player:upgrade_value(l_35_0:weapon_tweak_data().category, "damage_multiplier", 1))
  multiplier = multiplier + (1 - managers.player:upgrade_value(l_35_0._name_id, "damage_multiplier", 1))
  if l_35_0._silencer then
    multiplier = multiplier + (1 - managers.player:upgrade_value("weapon", "silencer_damage_multiplier", 1))
  end
  return l_35_0:_convert_add_to_mul(multiplier)
end

NewRaycastWeaponBase.melee_damage_multiplier = function(l_36_0)
  return managers.player:upgrade_value(l_36_0._name_id, "melee_multiplier", 1)
end

NewRaycastWeaponBase.spread_multiplier = function(l_37_0, l_37_1)
  do
    local multiplier = 1
    multiplier = multiplier + (1 - managers.player:upgrade_value("weapon", "spread_multiplier", 1))
    multiplier = multiplier + (1 - managers.player:upgrade_value(l_37_0:weapon_tweak_data().category, "spread_multiplier", 1))
    multiplier = multiplier + (1 - managers.player:upgrade_value("weapon", l_37_0:fire_mode() .. "_spread_multiplier", 1))
    multiplier = multiplier + (1 - managers.player:upgrade_value(l_37_0._name_id, "spread_multiplier", 1))
    if l_37_0._silencer then
      multiplier = multiplier + (1 - managers.player:upgrade_value("weapon", "silencer_spread_multiplier", 1))
      multiplier = multiplier + (1 - managers.player:upgrade_value(l_37_0:weapon_tweak_data().category, "silencer_spread_multiplier", 1))
    end
    if l_37_1 then
      if l_37_1._moving then
        multiplier = multiplier + (1 - managers.player:upgrade_value(l_37_0:weapon_tweak_data().category, "move_spread_multiplier", 1))
        multiplier = multiplier + (1 - (l_37_0._spread_moving or 1))
      end
      if not l_37_1._moving or not "moving_steelsight" then
        multiplier = multiplier + (1 - tweak_data.weapon[l_37_0._name_id].spread[not l_37_1:in_steelsight() or "steelsight"])
        do return end
        multiplier = multiplier + (1 - managers.player:upgrade_value(l_37_0:weapon_tweak_data().category, "hip_fire_spread_multiplier", 1))
        if not l_37_1._moving or not "moving_crouching" then
          multiplier = multiplier + (1 - tweak_data.weapon[l_37_0._name_id].spread[not l_37_1._state_data.ducking or "crouching"])
          do return end
          multiplier = multiplier + (1 - tweak_data.weapon[l_37_0._name_id].spread[l_37_1._moving and "moving_standing" or "standing"])
        end
        return l_37_0:_convert_add_to_mul(multiplier)
      end
       -- Warning: missing end command somewhere! Added here
    end
     -- Warning: missing end command somewhere! Added here
  end
end

NewRaycastWeaponBase.recoil_multiplier = function(l_38_0)
  local category = l_38_0:weapon_tweak_data().category
  local multiplier = 1
  multiplier = multiplier + (1 - managers.player:upgrade_value(category, "recoil_multiplier", 1))
  if managers.player:player_unit() and managers.player:player_unit():character_damage():is_suppressed() then
    if managers.player:has_team_category_upgrade(category, "suppression_recoil_multiplier") then
      multiplier = multiplier + (1 - managers.player:team_upgrade_value(category, "suppression_recoil_multiplier", 1))
    end
    if managers.player:has_team_category_upgrade("weapon", "suppression_recoil_multiplier") then
      multiplier = multiplier + (1 - managers.player:team_upgrade_value("weapon", "suppression_recoil_multiplier", 1))
    else
      if managers.player:has_team_category_upgrade(category, "recoil_multiplier") then
        multiplier = multiplier + (1 - managers.player:team_upgrade_value(category, "recoil_multiplier", 1))
      end
      if managers.player:has_team_category_upgrade("weapon", "recoil_multiplier") then
        multiplier = multiplier + (1 - managers.player:team_upgrade_value("weapon", "recoil_multiplier", 1))
      end
    end
  end
  multiplier = multiplier + (1 - managers.player:upgrade_value(l_38_0._name_id, "recoil_multiplier", 1))
  multiplier = multiplier + (1 - managers.player:upgrade_value("weapon", "passive_recoil_multiplier", 1))
  multiplier = multiplier + (1 - managers.player:upgrade_value("player", "recoil_multiplier", 1))
  if l_38_0._silencer then
    multiplier = multiplier + (1 - managers.player:upgrade_value("weapon", "silencer_recoil_multiplier", 1))
    multiplier = multiplier + (1 - managers.player:upgrade_value(l_38_0:weapon_tweak_data().category, "silencer_recoil_multiplier", 1))
  end
  return l_38_0:_convert_add_to_mul(multiplier)
end

NewRaycastWeaponBase.enter_steelsight_speed_multiplier = function(l_39_0)
  local multiplier = 1
  multiplier = multiplier + (1 - managers.player:upgrade_value(l_39_0:weapon_tweak_data().category, "enter_steelsight_speed_multiplier", 1))
  multiplier = multiplier + (1 - managers.player:temporary_upgrade_value("temporary", "combat_medic_enter_steelsight_speed_multiplier", 1))
  multiplier = multiplier + (1 - managers.player:upgrade_value(l_39_0._name_id, "enter_steelsight_speed_multiplier", 1))
  if l_39_0._silencer then
    multiplier = multiplier + (1 - managers.player:upgrade_value("weapon", "silencer_enter_steelsight_speed_multiplier", 1))
    multiplier = multiplier + (1 - managers.player:upgrade_value(l_39_0:weapon_tweak_data().category, "silencer_enter_steelsight_speed_multiplier", 1))
  end
  return l_39_0:_convert_add_to_mul(multiplier)
end

NewRaycastWeaponBase.fire_rate_multiplier = function(l_40_0)
  local multiplier = 1
  multiplier = multiplier + (1 - managers.player:upgrade_value(l_40_0:weapon_tweak_data().category, "fire_rate_multiplier", 1))
  multiplier = multiplier + (1 - managers.player:upgrade_value(l_40_0._name_id, "fire_rate_multiplier", 1))
  multiplier = multiplier + (1 - managers.player:upgrade_value("weapon", "fire_rate_multiplier", 1))
  return l_40_0:_convert_add_to_mul(multiplier)
end

NewRaycastWeaponBase.reload_speed_multiplier = function(l_41_0)
  local multiplier = 1
  multiplier = multiplier + (1 - managers.player:upgrade_value(l_41_0:weapon_tweak_data().category, "reload_speed_multiplier", 1))
  multiplier = multiplier + (1 - managers.player:upgrade_value("weapon", "passive_reload_speed_multiplier", 1))
  multiplier = multiplier + (1 - managers.player:upgrade_value(l_41_0._name_id, "reload_speed_multiplier", 1))
  return l_41_0:_convert_add_to_mul(multiplier)
end

NewRaycastWeaponBase.destroy = function(l_42_0, l_42_1)
  NewRaycastWeaponBase.super.destroy(l_42_0, l_42_1)
  managers.weapon_factory:disassemble(l_42_0._parts)
end


