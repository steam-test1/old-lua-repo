-- Decompiled using luadec 2.0.1 by sztupy (http://winmo.sztupy.hu)
-- Command line was: F:\SteamLibrary\SteamApps\common\PAYDAY 2\lua\lib\units\beings\player\playerequipment.luac 

if not PlayerEquipment then
  PlayerEquipment = class()
end
PlayerEquipment.init = function(l_1_0, l_1_1)
  l_1_0._unit = l_1_1
end

PlayerEquipment.on_deploy_interupted = function(l_2_0)
  if alive(l_2_0._dummy_unit) then
    World:delete_unit(l_2_0._dummy_unit)
    l_2_0._dummy_unit = nil
  end
end

PlayerEquipment.valid_look_at_placement = function(l_3_0, l_3_1)
  local from = l_3_0._unit:movement():m_head_pos()
  local to = from + l_3_0._unit:movement():m_head_rot():y() * 200
  local ray = l_3_0._unit:raycast("ray", from, to, "slot_mask", managers.slot:get_mask("trip_mine_placeables"), "ignore_unit", {})
  if ray and l_3_1 and l_3_1.dummy_unit then
    local pos = ray.position
    local rot = Rotation(ray.normal, math.UP)
    if not alive(l_3_0._dummy_unit) then
      l_3_0._dummy_unit = World:spawn_unit(Idstring(l_3_1.dummy_unit), pos, rot)
      l_3_0:_disable_contour(l_3_0._dummy_unit)
    end
    l_3_0._dummy_unit:set_position(pos)
    l_3_0._dummy_unit:set_rotation(rot)
  end
  if alive(l_3_0._dummy_unit) then
     -- DECOMPILER ERROR: Confused while interpreting a jump as a 'while'

  end
  l_3_0._dummy_unit:set_enabled(true)
end
return ray
end

PlayerEquipment.use_trip_mine = function(l_4_0)
  local ray = l_4_0:valid_look_at_placement()
  if ray then
    managers.challenges:count_up("plant_tripmine")
    managers.statistics:use_trip_mine()
    local sensor_upgrade = managers.player:has_category_upgrade("trip_mine", "sensor_toggle")
    if Network:is_client() then
      managers.network:session():send_to_host("attach_device", ray.position, ray.normal, sensor_upgrade)
    else
      local rot = Rotation(ray.normal, math.UP)
      local unit = TripMineBase.spawn(ray.position, rot, sensor_upgrade)
      unit:base():set_active(true, l_4_0._unit)
    end
    return true
  end
  return false
end

PlayerEquipment.valid_placement = function(l_5_0, l_5_1)
  local valid = not l_5_0._unit:movement():current_state():in_air()
  local pos = l_5_0._unit:movement():m_pos()
  local rot = l_5_0._unit:movement():m_head_rot()
  rot = Rotation(rot:yaw(), 0, 0)
  if l_5_1 and l_5_1.dummy_unit then
    if not alive(l_5_0._dummy_unit) then
      l_5_0._dummy_unit = World:spawn_unit(Idstring(l_5_1.dummy_unit), pos, rot)
      l_5_0:_disable_contour(l_5_0._dummy_unit)
    end
    l_5_0._dummy_unit:set_position(pos)
    l_5_0._dummy_unit:set_rotation(rot)
    if alive(l_5_0._dummy_unit) then
      l_5_0._dummy_unit:set_enabled(valid)
    end
  end
  return valid
end

local ids_contour_color = Idstring("contour_color")
local ids_contour_opacity = Idstring("contour_opacity")
local ids_material = Idstring("material")
PlayerEquipment._disable_contour = function(l_6_0, l_6_1)
  local materials = l_6_1:get_objects_by_type(ids_material)
  for _,m in ipairs(materials) do
    m:set_variable(ids_contour_opacity, 0)
  end
end

PlayerEquipment.use_ammo_bag = function(l_7_0)
  local ray = l_7_0:valid_shape_placement("ammo_bag")
  if ray then
    local pos = ray.position
    local rot = l_7_0._unit:movement():m_head_rot()
    rot = Rotation(rot:yaw(), 0, 0)
    PlayerStandard.say_line(l_7_0, "s01x_plu")
    managers.statistics:use_ammo_bag()
    managers.challenges:count_up("deploy_ammobag")
    local ammo_upgrade_lvl = managers.player:upgrade_level("ammo_bag", "ammo_increase")
    if Network:is_client() then
      managers.network:session():send_to_host("place_ammo_bag", pos, rot, ammo_upgrade_lvl)
    else
      local unit = AmmoBagBase.spawn(pos, rot, ammo_upgrade_lvl)
    end
    if managers.player:has_category_upgrade("temporary", "no_ammo_cost") then
      managers.player:activate_temporary_upgrade("temporary", "no_ammo_cost")
    end
    return true
  end
  return false
end

PlayerEquipment.use_doctor_bag = function(l_8_0)
  do
    local ray = l_8_0:valid_shape_placement("doctor_bag")
    if ray then
      local pos = ray.position
      local rot = l_8_0._unit:movement():m_head_rot()
      rot = Rotation(rot:yaw(), 0, 0)
      PlayerStandard.say_line(l_8_0, "s02x_plu")
      managers.statistics:use_doctor_bag()
      local amount_upgrade_lvl = managers.player:upgrade_level("doctor_bag", "amount_increase")
      if Network:is_client() then
        managers.network:session():send_to_host("place_doctor_bag", pos, rot, amount_upgrade_lvl)
      do
        else
          local unit = DoctorBagBase.spawn(pos, rot, amount_upgrade_lvl)
        end
        return true
      end
      return false
    end
     -- Warning: missing end command somewhere! Added here
  end
end

PlayerEquipment.use_ecm_jammer = function(l_9_0)
  if l_9_0._ecm_jammer_placement_requested then
    return 
  end
  local ray = l_9_0:valid_look_at_placement()
  if ray then
    managers.statistics:use_ecm_jammer()
    local duration_multiplier = managers.player:upgrade_value("ecm_jammer", "duration_multiplier", 1) * managers.player:upgrade_value("ecm_jammer", "duration_multiplier_2", 1)
    if Network:is_client() then
      l_9_0._ecm_jammer_placement_requested = true
      managers.network:session():send_to_host("request_place_ecm_jammer", ray.position, ray.normal, duration_multiplier)
    else
      local rot = Rotation(ray.normal, math.UP)
      local unit = ECMJammerBase.spawn(ray.position, rot, duration_multiplier, l_9_0._unit)
      unit:base():set_active(true)
    end
    return true
  end
  return false
end

PlayerEquipment.from_server_ecm_jammer_placement_result = function(l_10_0)
  l_10_0._ecm_jammer_placement_requested = nil
end

PlayerEquipment._spawn_dummy = function(l_11_0, l_11_1, l_11_2, l_11_3)
  if alive(l_11_0._dummy_unit) then
    return l_11_0._dummy_unit
  end
  l_11_0._dummy_unit = World:spawn_unit(Idstring(l_11_1), l_11_2, l_11_3)
  for i = 0, l_11_0._dummy_unit:num_bodies() - 1 do
    l_11_0._dummy_unit:body(i):set_enabled(false)
  end
  return l_11_0._dummy_unit
end

PlayerEquipment.valid_shape_placement = function(l_12_0, l_12_1, l_12_2)
  local from = l_12_0._unit:movement():m_head_pos()
  local to = from + l_12_0._unit:movement():m_head_rot():y() * 220
  local ray = l_12_0._unit:raycast("ray", from, to, "slot_mask", managers.slot:get_mask("trip_mine_placeables"), "ignore_unit", {})
   -- DECOMPILER ERROR: Confused while interpreting a jump as a 'while'

end
local valid = true
if ray then
  local pos = ray.position
  local rot = l_12_0._unit:movement():m_head_rot()
  rot = Rotation(rot:yaw(), 0, 0)
  if not alive(l_12_0._dummy_unit) then
    l_12_0._dummy_unit = World:spawn_unit(Idstring(l_12_2.dummy_unit), pos, rot)
    l_12_0:_disable_contour(l_12_0._dummy_unit)
  end
  l_12_0._dummy_unit:set_position(pos)
  l_12_0._dummy_unit:set_rotation(rot)
  valid = not valid or math.dot(ray.normal, math.UP) > 0.25
  local find_start_pos, find_end_pos, find_radius = nil, nil, nil
  if l_12_1 == "ammo_bag" then
    find_start_pos = pos + math.UP * 20
    find_end_pos = pos + math.UP * 21
    find_radius = 12
  elseif l_12_1 == "doctor_bag" then
    find_start_pos = pos + math.UP * 22
    find_end_pos = pos + math.UP * 28
    find_radius = 15
  else
    find_start_pos = pos + math.UP * 30
    find_end_pos = pos + math.UP * 40
    find_radius = 17
  end
  local bodies = l_12_0._dummy_unit:find_bodies("intersect", "capsule", find_start_pos, find_end_pos, find_radius, managers.slot:get_mask("trip_mine_placeables") + 14 + 25)
  for _,body in ipairs(bodies) do
    if body:unit() ~= l_12_0._dummy_unit and body:has_ray_type(Idstring("body")) then
      valid = false
  else
    end
  end
  if alive(l_12_0._dummy_unit) then
    l_12_0._dummy_unit:set_enabled(valid)
  end
  return not valid or ray
end

PlayerEquipment.use_sentry_gun = function(l_13_0, l_13_1)
  if l_13_0._sentrygun_placement_requested then
    return 
  end
  local ray = l_13_0:valid_shape_placement()
  if ray then
    local pos = ray.position
    local rot = l_13_0._unit:movement():m_head_rot()
    rot = Rotation(rot:yaw(), 0, 0)
    local ammo_multiplier = managers.player:upgrade_value("sentry_gun", "extra_ammo_multiplier", 1)
    local armor_multiplier = managers.player:upgrade_value("sentry_gun", "armor_multiplier", 1)
    local damage_multiplier = managers.player:upgrade_value("sentry_gun", "damage_multiplier", 1)
    if Network:is_client() then
      managers.network:session():send_to_host("place_sentry_gun", pos, rot, ammo_multiplier, armor_multiplier, damage_multiplier, l_13_1, l_13_0._unit)
      l_13_0._sentrygun_placement_requested = true
      return false
    else
      local shield = managers.player:has_category_upgrade("sentry_gun", "shield")
      local sentry_gun_unit = SentryGunBase.spawn(l_13_0._unit, pos, rot, ammo_multiplier, armor_multiplier, damage_multiplier)
      if sentry_gun_unit then
        managers.network:session():send_to_peers_synched("from_server_sentry_gun_place_result", managers.network:session():local_peer():id(), l_13_1, sentry_gun_unit, sentry_gun_unit:movement()._rot_speed_mul, sentry_gun_unit:weapon()._setup.spread_mul, shield)
      else
        return false
      end
    end
    return true
  end
  return false
end

PlayerEquipment.use_flash_grenade = function(l_14_0)
  l_14_0._grenade_name = "units/weapons/flash_grenade/flash_grenade"
  return true, "throw_grenade"
end

PlayerEquipment.use_smoke_grenade = function(l_15_0)
  l_15_0._grenade_name = "units/weapons/smoke_grenade/smoke_grenade"
  return true, "throw_grenade"
end

PlayerEquipment.use_frag_grenade = function(l_16_0)
  l_16_0._grenade_name = "units/weapons/frag_grenade/frag_grenade"
  return true, "throw_grenade"
end

PlayerEquipment.throw_flash_grenade = function(l_17_0)
  if not l_17_0._grenade_name then
    Application:error("Tried to throw a grenade with no name")
  end
  local from = l_17_0._unit:movement():m_head_pos()
  local to = from + l_17_0._unit:movement():m_head_rot():y() * 50 + Vector3(0, 0, 0)
  local unit = GrenadeBase.spawn(l_17_0._grenade_name, to, Rotation())
  unit:base():throw({dir = l_17_0._unit:movement():m_head_rot():y(), owner = l_17_0._unit})
  l_17_0._grenade_name = nil
end

PlayerEquipment.use_duck = function(l_18_0)
  local soundsource = SoundDevice:create_source("duck")
  soundsource:post_event("footstep_walk")
  return true
end

PlayerEquipment.from_server_sentry_gun_place_result = function(l_19_0)
  l_19_0._sentrygun_placement_requested = nil
end

PlayerEquipment.destroy = function(l_20_0)
  if alive(l_20_0._dummy_unit) then
    World:delete_unit(l_20_0._dummy_unit)
    l_20_0._dummy_unit = nil
  end
end


