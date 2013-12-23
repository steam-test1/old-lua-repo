-- Decompiled using luadec 2.0.1 by sztupy (http://winmo.sztupy.hu)
-- Command line was: F:\SteamLibrary\SteamApps\common\PAYDAY 2\lua\lib\units\weapons\weaponlaser.luac 

if not WeaponLaser then
  WeaponLaser = class(WeaponGadgetBase)
end
WeaponLaser.init = function(l_1_0, l_1_1)
  WeaponLaser.super.init(l_1_0, l_1_1)
  l_1_0._on_event = "gadget_laser_aim_on"
  l_1_0._off_event = "gadget_laser_aim_off"
  local obj = l_1_0._unit:get_object(Idstring("a_laser"))
  l_1_0._laser_obj = obj
  l_1_0._max_distance = 3000
  l_1_0._scale_distance = 1000
  l_1_0._g_laser = l_1_0._unit:get_object(Idstring("g_laser"))
  l_1_0._g_indicator = l_1_0._unit:get_object(Idstring("g_indicator"))
  l_1_0._spot_angle_end = 0
  l_1_0._light = World:create_light("spot|specular")
  l_1_0._light:set_spot_angle_end(3)
  l_1_0._light:set_far_range(75)
  l_1_0._light:set_near_range(40)
  l_1_0._light:link(obj)
  l_1_0._light:set_rotation(Rotation(obj:rotation():z(), -obj:rotation():x(), -obj:rotation():y()))
  l_1_0._colors = {{light = Vector3(0, 10, 0), brush = Color(0.050000000745058, 0, 1, 0)}, {light = Vector3(10, 0, 0), brush = Color(0.050000000745058, 1, 0, 0)}, {light = Vector3(0, 0, 10), brush = Color(0.050000000745058, 0, 0, 1)}}
  l_1_0._light_color = l_1_0._colors[1].light
  l_1_0._light:set_color(l_1_0._light_color)
  l_1_0._light:set_enable(false)
  l_1_0._light_glow = World:create_light("spot|specular")
  l_1_0._light_glow:set_spot_angle_end(20)
  l_1_0._light_glow:set_far_range(75)
  l_1_0._light_glow:set_near_range(40)
  l_1_0._light_glow_color = Vector3(0, 0.20000000298023, 0)
  l_1_0._light_glow:set_color(l_1_0._light_glow_color)
  l_1_0._light_glow:set_enable(false)
  l_1_0._light_glow:link(obj)
  l_1_0._light_glow:set_rotation(Rotation(obj:rotation():z(), -obj:rotation():x(), -obj:rotation():y()))
  l_1_0._slotmask = managers.slot:get_mask("bullet_impact_targets")
  l_1_0._brush = Draw:brush(l_1_0._colors[1].brush)
  l_1_0._brush:set_blend_mode("opacity_add")
end

local mvec1 = Vector3()
local mvec2 = Vector3()
local mvec_l_dir = Vector3()
WeaponLaser.update = function(l_2_0, l_2_1, l_2_2, l_2_3)
  mrotation.y(l_2_0._laser_obj:rotation(), mvec_l_dir)
  local from = mvec1
  mvector3.set(from, l_2_0._laser_obj:position())
  local to = mvec2
  mvector3.set(to, mvec_l_dir)
  mvector3.multiply(to, l_2_0._max_distance)
  mvector3.add(to, from)
  local ray = l_2_0._unit:raycast(from, to, l_2_0._slotmask)
  if ray then
    if not l_2_0._is_npc then
      l_2_0._light:set_spot_angle_end(l_2_0._spot_angle_end)
      l_2_0._spot_angle_end = math.lerp(1, 18, ray.distance / l_2_0._max_distance)
      l_2_0._light_glow:set_spot_angle_end(math.lerp(8, 80, ray.distance / l_2_0._max_distance))
      local scale = (math.clamp(ray.distance, l_2_0._max_distance - l_2_0._scale_distance, l_2_0._max_distance) - (l_2_0._max_distance - l_2_0._scale_distance)) / l_2_0._scale_distance
      scale = 1 - scale
      l_2_0._light:set_multiplier(scale)
      l_2_0._light_glow:set_multiplier((scale) * 0.10000000149012)
    end
    l_2_0._brush:cylinder(ray.position, from, l_2_0._is_npc and 0.5 or 0.25)
    local pos = mvec1
    mvector3.set(pos, mvec_l_dir)
    mvector3.multiply(pos, 50)
    mvector3.negate(pos)
    mvector3.add(pos, ray.position)
    l_2_0._light:set_position(pos)
    l_2_0._light_glow:set_position(pos)
  else
    l_2_0._light:set_position(to)
    l_2_0._light_glow:set_position(to)
    l_2_0._brush:cylinder(from, to, l_2_0._is_npc and 0.5 or 0.25)
  end
end

WeaponLaser._check_state = function(l_3_0)
  WeaponLaser.super._check_state(l_3_0)
  l_3_0._light:set_enable(l_3_0._on)
  l_3_0._light_glow:set_enable(l_3_0._on)
  l_3_0._g_laser:set_visibility(l_3_0._on)
  l_3_0._g_indicator:set_visibility(l_3_0._on)
  l_3_0._unit:set_extension_update_enabled(Idstring("base"), l_3_0._on)
end

WeaponLaser.set_npc = function(l_4_0)
  l_4_0._is_npc = true
end

WeaponLaser.destroy = function(l_5_0, l_5_1)
  WeaponLaser.super.destroy(l_5_0, l_5_1)
  if alive(l_5_0._light) then
    World:delete_light(l_5_0._light)
  end
  if alive(l_5_0._light_glow) then
    World:delete_light(l_5_0._light_glow)
  end
end

WeaponLaser.set_color = function(l_6_0, l_6_1)
  l_6_0._light_color = Vector3(l_6_1.r * 10, l_6_1.g * 10, l_6_1.b * 10)
  l_6_0._light:set_color(l_6_0._light_color)
  l_6_0._light_glow_color = Vector3(l_6_1.r * 0.20000000298023, l_6_1.g * 0.20000000298023, l_6_1.b * 0.20000000298023)
  l_6_0._light_glow:set_color(l_6_0._light_glow_color)
  l_6_0._brush:set_color(l_6_1)
end

WeaponLaser.set_max_distace = function(l_7_0, l_7_1)
  l_7_0._max_distance = l_7_1
end


