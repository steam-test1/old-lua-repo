-- Decompiled using luadec 2.0.1 by sztupy (http://winmo.sztupy.hu)
-- Command line was: F:\SteamLibrary\SteamApps\common\PAYDAY 2\lua\lib\units\weapons\menuraycastweaponbase.luac 

if not NewRaycastWeaponBase then
  NewRaycastWeaponBase = class()
end
NewRaycastWeaponBase.init = function(l_1_0, l_1_1)
  l_1_0._unit = l_1_1
end

NewRaycastWeaponBase.set_factory_data = function(l_2_0, l_2_1)
  l_2_0._factory_id = l_2_1
end

NewRaycastWeaponBase.set_npc = function(l_3_0, l_3_1)
  l_3_0._npc = l_3_1
end

NewRaycastWeaponBase.is_npc = function(l_4_0)
  return l_4_0._npc or false
end

NewRaycastWeaponBase.assemble = function(l_5_0, l_5_1, l_5_2)
  local third_person = l_5_0:is_npc()
  l_5_0._parts, l_5_0._blueprint = managers.weapon_factory:assemble_default(l_5_1, l_5_0._unit, third_person, callback(l_5_0, l_5_0, "_assemble_completed"), l_5_2), managers.weapon_factory
  l_5_0:_update_stats_values()
  return 
  local third_person = l_5_0:is_npc()
  l_5_0._parts, l_5_0._blueprint = managers.weapon_factory:assemble_default(l_5_1, l_5_0._unit, third_person), managers.weapon_factory
  l_5_0:_update_fire_object()
  l_5_0:_update_stats_values()
end

NewRaycastWeaponBase.assemble_from_blueprint = function(l_6_0, l_6_1, l_6_2, l_6_3)
  local third_person = l_6_0:is_npc()
  l_6_0._parts, l_6_0._blueprint = managers.weapon_factory:assemble_from_blueprint(l_6_1, l_6_0._unit, l_6_2, third_person, callback(l_6_0, l_6_0, "_assemble_completed"), l_6_3), managers.weapon_factory
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
end

NewRaycastWeaponBase._update_stats_values = function(l_15_0)
  return 
  local base_stats = l_15_0:weapon_tweak_data().stats
  if not base_stats then
    return 
  end
  local parts_stats = managers.weapon_factory:get_stats(l_15_0._factory_id, l_15_0._blueprint)
  l_15_0._silencer = managers.weapon_factory:has_perk("silencer", l_15_0._factory_id, l_15_0._blueprint)
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
end

NewRaycastWeaponBase.stance_id = function(l_16_0)
  return "new_m4"
end

NewRaycastWeaponBase.weapon_hold = function(l_17_0)
  return l_17_0:weapon_tweak_data().weapon_hold
end

NewRaycastWeaponBase.stance_mod = function(l_18_0)
  if not l_18_0._parts then
    return nil
  end
  local factory = tweak_data.weapon.factory
  for part_id,data in pairs(l_18_0._parts) do
    if factory.parts[part_id].stance_mod and factory.parts[part_id].stance_mod[l_18_0._factory_id] then
      return {translation = factory.parts[part_id].stance_mod[l_18_0._factory_id].translation}
    end
  end
  return nil
end

NewRaycastWeaponBase.tweak_data_anim_play = function(l_19_0, l_19_1, l_19_2)
  local data = tweak_data.weapon.factory[l_19_0._factory_id]
  if data.animations and data.animations[l_19_1] then
    local anim_name = data.animations[l_19_1]
    local length = l_19_0._unit:anim_length(Idstring(anim_name))
    if not l_19_2 then
      l_19_2 = 1
    end
    l_19_0._unit:anim_stop(Idstring(anim_name))
    l_19_0._unit:anim_play_to(Idstring(anim_name), length, l_19_2)
  end
  for part_id,data in pairs(l_19_0._parts) do
    if data.animations and data.animations[l_19_1] then
      local anim_name = data.animations[l_19_1]
      local length = data.unit:anim_length(Idstring(anim_name))
      if not l_19_2 then
        l_19_2 = 1
      end
      data.unit:anim_stop(Idstring(anim_name))
      data.unit:anim_play_to(Idstring(anim_name), length, l_19_2)
    end
  end
  return true
end

NewRaycastWeaponBase.tweak_data_anim_stop = function(l_20_0, l_20_1)
  local data = tweak_data.weapon.factory[l_20_0._factory_id]
  if data.animations and data.animations[l_20_1] then
    local anim_name = data.animations[l_20_1]
    l_20_0._unit:anim_stop(Idstring(anim_name))
  end
  for part_id,data in pairs(l_20_0._parts) do
    if data.animations and data.animations[l_20_1] then
      local anim_name = data.animations[l_20_1]
      data.unit:anim_stop(Idstring(anim_name))
    end
  end
end

NewRaycastWeaponBase._set_parts_enabled = function(l_21_0, l_21_1)
  if l_21_0._parts then
    for part_id,data in pairs(l_21_0._parts) do
      if alive(data.unit) then
        data.unit:set_enabled(l_21_1)
      end
    end
  end
end

NewRaycastWeaponBase.on_enabled = function(l_22_0, ...)
  NewRaycastWeaponBase.super.on_enabled(l_22_0, ...)
  l_22_0:_set_parts_enabled(true)
   -- DECOMPILER ERROR: Confused about usage of registers for local variables.

end

NewRaycastWeaponBase.on_disabled = function(l_23_0, ...)
  l_23_0:gadget_off()
  l_23_0:_set_parts_enabled(false)
   -- DECOMPILER ERROR: Confused about usage of registers for local variables.

end

NewRaycastWeaponBase.has_gadget = function(l_24_0)
   -- DECOMPILER ERROR: Confused while interpreting a jump as a 'while'

end
return true
end

NewRaycastWeaponBase.gadget_on = function(l_25_0)
  l_25_0._gadget_on = true
  local gadget = managers.weapon_factory:get_part_from_weapon_by_type("gadget", l_25_0._parts)
  if gadget then
    gadget.unit:base():set_state(l_25_0._gadget_on)
  end
end

NewRaycastWeaponBase.gadget_off = function(l_26_0)
  l_26_0._gadget_on = false
  local gadget = managers.weapon_factory:get_part_from_weapon_by_type("gadget", l_26_0._parts)
  if gadget then
    gadget.unit:base():set_state(l_26_0._gadget_on)
  end
end

NewRaycastWeaponBase.toggle_gadget = function(l_27_0)
  l_27_0._gadget_on = not l_27_0._gadget_on
  local gadget = managers.weapon_factory:get_part_from_weapon_by_type("gadget", l_27_0._parts)
  if gadget then
    gadget.unit:base():set_state(l_27_0._gadget_on)
  end
end

NewRaycastWeaponBase.check_stats = function(l_28_0)
  local base_stats = l_28_0:weapon_tweak_data().stats
  if not base_stats then
    print("no stats")
    return 
  end
  local parts_stats = managers.weapon_factory:get_stats(l_28_0._factory_id, l_28_0._blueprint)
  local stats = deep_clone(base_stats)
  local tweak_data = tweak_data.weapon.stats
  stats.zoom = math.min(stats.zoom + managers.player:upgrade_value(l_28_0:weapon_tweak_data().category, "zoom_increase", 0), #tweak_data.zoom)
  for stat,_ in pairs(stats) do
    if parts_stats[stat] then
      stats[stat] = math_clamp(stats[stat] + parts_stats[stat], 1, #tweak_data[stat])
    end
  end
  l_28_0._current_stats = {}
  for stat,i in pairs(stats) do
    l_28_0._current_stats[stat] = tweak_data[stat][i]
  end
  l_28_0._current_stats.alert_size = tweak_data.alert_size[math_clamp(stats.suppression, 1, #tweak_data.alert_size)]
  return stats
end

NewRaycastWeaponBase.spread_multiplier = function(l_29_0)
  local multiplier = NewRaycastWeaponBase.super.spread_multiplier(l_29_0)
  if l_29_0._silencer then
    multiplier = multiplier * managers.player:upgrade_value("weapon", "silencer_spread_multiplier", 1)
    multiplier = multiplier * managers.player:upgrade_value(l_29_0:weapon_tweak_data().category, "silencer_spread_multiplier", 1)
  end
  return multiplier
end

NewRaycastWeaponBase.recoil_multiplier = function(l_30_0)
  local multiplier = NewRaycastWeaponBase.super.recoil_multiplier(l_30_0)
  multiplier = multiplier * managers.player:upgrade_value("weapon", "passive_recoil_multiplier", 1)
  if l_30_0._silencer then
    multiplier = multiplier * managers.player:upgrade_value("weapon", "silencer_recoil_multiplier", 1)
    multiplier = multiplier * managers.player:upgrade_value(l_30_0:weapon_tweak_data().category, "silencer_recoil_multiplier", 1)
  end
  return multiplier
end

NewRaycastWeaponBase.enter_steelsight_speed_multiplier = function(l_31_0)
  local multiplier = NewRaycastWeaponBase.super.enter_steelsight_speed_multiplier(l_31_0)
  if l_31_0._silencer then
    multiplier = multiplier * managers.player:upgrade_value("weapon", "silencer_enter_steelsight_speed_multiplier", 1)
    multiplier = multiplier * managers.player:upgrade_value(l_31_0:weapon_tweak_data().category, "silencer_enter_steelsight_speed_multiplier", 1)
  end
  return multiplier
end

NewRaycastWeaponBase.destroy = function(l_32_0, l_32_1)
  managers.weapon_factory:disassemble(l_32_0._parts)
end


