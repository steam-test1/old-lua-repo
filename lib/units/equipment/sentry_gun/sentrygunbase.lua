-- Decompiled using luadec 2.0.1 by sztupy (http://winmo.sztupy.hu)
-- Command line was: F:\SteamLibrary\SteamApps\common\PAYDAY 2\lua\lib\units\equipment\sentry_gun\sentrygunbase.luac 

if not SentryGunBase then
  SentryGunBase = class(UnitBase)
end
SentryGunBase.init = function(l_1_0, l_1_1)
  SentryGunBase.super.init(l_1_0, l_1_1, false)
  l_1_0._unit = l_1_1
  l_1_0._unit:sound_source():post_event("turret_place")
end

SentryGunBase.post_init = function(l_2_0)
  l_2_0._registered = true
  managers.groupai:state():register_criminal(l_2_0._unit)
  if Network:is_client() then
    l_2_0._unit:brain():set_active(true)
  end
end

SentryGunBase.spawn = function(l_3_0, l_3_1, l_3_2, l_3_3, l_3_4, l_3_5)
  local attached_data = SentryGunBase._attach(l_3_1, l_3_2)
  if not attached_data then
    return 
  end
  local spread_multiplier, rot_speed_multiplier, has_shield = nil, nil, nil
  if not l_3_0:base():upgrade_value("sentry_gun", "spread_multiplier") then
    spread_multiplier = not l_3_0 or not l_3_0:base().upgrade_value or 1
  end
  rot_speed_multiplier = l_3_0:base():upgrade_value("sentry_gun", "rot_speed_multiplier") or 1
  has_shield = l_3_0:base():upgrade_value("sentry_gun", "shield")
  do return end
  spread_multiplier = managers.player:upgrade_value("sentry_gun", "spread_multiplier", 1)
  rot_speed_multiplier = managers.player:upgrade_value("sentry_gun", "rot_speed_multiplier", 1)
  has_shield = managers.player:has_category_upgrade("sentry_gun", "shield")
  local unit = World:spawn_unit(Idstring("units/payday2/equipment/gen_equipment_sentry/gen_equipment_sentry"), l_3_1, l_3_2)
  unit:base():setup(l_3_0, l_3_3, l_3_4, l_3_5, spread_multiplier, rot_speed_multiplier, has_shield, attached_data)
  unit:brain():set_active(true)
  SentryGunBase.deployed = (SentryGunBase.deployed or 0) + 1
  if SentryGunBase.deployed >= 4 then
    managers.challenges:set_flag("sentry_gun_resources")
  end
  return unit
end

SentryGunBase.get_name_id = function(l_4_0)
  return "sentry_gun"
end

SentryGunBase.set_server_information = function(l_5_0, l_5_1)
  l_5_0._server_information = {owner_peer_id = l_5_1}
  managers.network:game():member(l_5_1):peer():set_used_deployable(true)
end

SentryGunBase.server_information = function(l_6_0)
  return l_6_0._server_information
end

SentryGunBase.setup = function(l_7_0, l_7_1, l_7_2, l_7_3, l_7_4, l_7_5, l_7_6, l_7_7, l_7_8)
  l_7_0._attached_data = l_7_8
  if l_7_7 then
    l_7_0:enable_shield()
  end
  local ammo_amount = tweak_data.upgrades.sentry_gun_base_ammo * l_7_2
  l_7_0._unit:weapon():set_ammo(ammo_amount)
  local armor_amount = tweak_data.upgrades.sentry_gun_base_armor * l_7_3
  l_7_0._unit:character_damage():set_health(armor_amount)
  l_7_0._owner = l_7_1
  l_7_0._unit:movement():setup(l_7_6)
  l_7_0._unit:brain():setup(1 / l_7_6)
  local setup_data = {}
  setup_data.user_unit = l_7_0._owner
  setup_data.ignore_units = {l_7_0._unit, l_7_0._owner}
  setup_data.expend_ammo = true
  setup_data.autoaim = true
  setup_data.alert_AI = true
  setup_data.alert_filter = l_7_0._owner:movement():SO_access()
  setup_data.spread_mul = l_7_5
  l_7_0._unit:weapon():setup(setup_data, l_7_4)
  l_7_0._unit:set_extension_update_enabled(Idstring("base"), true)
  return true
end

SentryGunBase.update = function(l_8_0, l_8_1, l_8_2, l_8_3)
  l_8_0:_check_body()
end

SentryGunBase._check_body = function(l_9_0)
  if l_9_0._attached_data.index == 1 and not l_9_0._attached_data.body:enabled() then
    l_9_0._attached_data = l_9_0._attach(nil, nil, l_9_0._unit)
    if not l_9_0._attached_data then
      l_9_0:remove()
      return 
      do return end
      if l_9_0._attached_data.index == 2 and (not alive(l_9_0._attached_data.body) or not mrotation.equal(l_9_0._attached_data.rotation, l_9_0._attached_data.body:rotation())) then
        l_9_0._attached_data = l_9_0._attach(nil, nil, l_9_0._unit)
        if not l_9_0._attached_data then
          l_9_0:remove()
          return 
          do return end
          if l_9_0._attached_data.index == 3 and (not alive(l_9_0._attached_data.body) or mvector3.not_equal(l_9_0._attached_data.position, l_9_0._attached_data.body:position())) then
            l_9_0._attached_data = l_9_0._attach(nil, nil, l_9_0._unit)
            if not l_9_0._attached_data then
              l_9_0:remove()
              return 
            end
          end
        end
      end
    end
  end
  l_9_0._attached_data.index = (l_9_0._attached_data.index < l_9_0._attached_data.max_index and l_9_0._attached_data.index or 0) + 1
end

SentryGunBase.remove = function(l_10_0)
  l_10_0._removed = true
  l_10_0._unit:set_slot(0)
end

SentryGunBase._attach = function(l_11_0, l_11_1, l_11_2)
  if not l_11_0 then
    l_11_0 = l_11_2:position()
  end
  if not l_11_1 then
    l_11_1 = l_11_2:rotation()
  end
  local from_pos = l_11_0 + l_11_1:z() * 10
  local to_pos = l_11_0 + l_11_1:z() * -10
  local ray = nil
  if l_11_2 then
    ray = l_11_2:raycast("ray", from_pos, to_pos, "slot_mask", managers.slot:get_mask("world_geometry"))
  else
    ray = World:raycast("ray", from_pos, to_pos, "slot_mask", managers.slot:get_mask("world_geometry"))
  end
  if ray then
    local attached_data = {body = ray.body, position = ray.body:position(), rotation = ray.body:rotation(), index = 1, max_index = 3}
    return attached_data
  end
end

SentryGunBase.set_visibility_state = function(l_12_0, l_12_1)
  local state = not l_12_1 or true
  if l_12_0._visibility_state ~= state then
    l_12_0._unit:set_visible(state)
    l_12_0._visibility_state = state
  end
  l_12_0._lod_stage = l_12_1
end

SentryGunBase.weapon_tweak_data = function(l_13_0)
  return tweak_data.weapon[l_13_0._unit:weapon()._name_id]
end

SentryGunBase.on_death = function(l_14_0)
  l_14_0._unit:set_extension_update_enabled(Idstring("base"), false)
  if l_14_0._registered then
    l_14_0._registered = nil
    managers.groupai:state():unregister_criminal(l_14_0._unit)
  end
end

SentryGunBase.enable_shield = function(l_15_0)
  l_15_0._has_shield = true
  l_15_0._unit:get_object(Idstring("g_shield")):set_visibility(true)
  l_15_0._unit:get_object(Idstring("s_shield")):set_visibility(true)
  l_15_0._unit:decal_surface():set_mesh_enabled(Idstring("dm_metal_shield"), true)
  l_15_0._unit:body("shield"):set_enabled(true)
end

SentryGunBase.has_shield = function(l_16_0)
  return l_16_0._has_shield
end

SentryGunBase.unregister = function(l_17_0)
  if l_17_0._registered then
    l_17_0._registered = nil
    managers.groupai:state():unregister_criminal(l_17_0._unit)
  end
end

SentryGunBase.pre_destroy = function(l_18_0)
  SentryGunBase.super.pre_destroy(l_18_0, l_18_0._unit)
  l_18_0:unregister()
  l_18_0._removed = true
end


