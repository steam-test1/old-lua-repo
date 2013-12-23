-- Decompiled using luadec 2.0.1 by sztupy (http://winmo.sztupy.hu)
-- Command line was: F:\SteamLibrary\SteamApps\common\PAYDAY 2\lua\lib\units\weapons\weaponflashlight.luac 

if not WeaponFlashLight then
  WeaponFlashLight = class(WeaponGadgetBase)
end
WeaponFlashLight.init = function(l_1_0, l_1_1)
  WeaponFlashLight.super.init(l_1_0, l_1_1)
  l_1_0._on_event = "gadget_flashlight_on"
  l_1_0._off_event = "gadget_flashlight_off"
  local obj = l_1_0._unit:get_object(Idstring("a_flashlight"))
  l_1_0._g_light = l_1_0._unit:get_object(Idstring("g_light"))
  l_1_0._light = World:create_light("spot|specular|plane_projection", "units/lights/spot_light_projection_textures/spotprojection_11_flashlight_df")
  l_1_0._light:set_spot_angle_end(60)
  l_1_0._light:set_far_range(1000)
  l_1_0._light:set_multiplier(2)
  l_1_0._light:link(obj)
  l_1_0._light:set_rotation(Rotation(obj:rotation():z(), -obj:rotation():x(), -obj:rotation():y()))
  l_1_0._light:set_enable(false)
  l_1_0._light_effect = World:effect_manager():spawn({effect = Idstring("effects/particles/weapons/flashlight/fp_flashlight"), parent = obj})
  World:effect_manager():set_hidden(l_1_0._light_effect, true)
end

WeaponFlashLight.set_npc = function(l_2_0)
  if l_2_0._light_effect then
    World:effect_manager():kill(l_2_0._light_effect)
  end
  local obj = l_2_0._unit:get_object(Idstring("a_flashlight"))
  l_2_0._light_effect = World:effect_manager():spawn({effect = Idstring("effects/particles/weapons/flashlight/flashlight"), parent = obj})
  World:effect_manager():set_hidden(l_2_0._light_effect, true)
end

WeaponFlashLight._check_state = function(l_3_0)
  WeaponFlashLight.super._check_state(l_3_0)
  l_3_0._light:set_enable(l_3_0._on)
  l_3_0._g_light:set_visibility(l_3_0._on)
  World:effect_manager():set_hidden(l_3_0._light_effect, not l_3_0._on)
end

WeaponFlashLight.destroy = function(l_4_0, l_4_1)
  WeaponFlashLight.super.destroy(l_4_0, l_4_1)
  if alive(l_4_0._light) then
    World:delete_light(l_4_0._light)
  end
  if l_4_0._light_effect then
    World:effect_manager():kill(l_4_0._light_effect)
    l_4_0._light_effect = nil
  end
end


