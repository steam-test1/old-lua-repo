-- Decompiled using luadec 2.0.1 by sztupy (http://winmo.sztupy.hu)
-- Command line was: F:\SteamLibrary\SteamApps\common\PAYDAY 2\lua\lib\units\weapons\npcsawweaponbase.luac 

if not NPCSawWeaponBase then
  NPCSawWeaponBase = class(NewNPCRaycastWeaponBase)
end
NPCSawWeaponBase.init = function(l_1_0, l_1_1)
  NPCSawWeaponBase.super.init(l_1_0, l_1_1, false)
  l_1_0._active_effect_name = Idstring("effects/payday2/particles/weapons/saw/sawing")
  l_1_0._active_effect_table = {effect = l_1_0._active_effect_name, parent = l_1_0._obj_fire, force_synch = true}
end

NPCSawWeaponBase._play_sound_sawing = function(l_2_0)
  l_2_0:play_sound("Play_npc_saw_handheld_grind_generic")
end

NPCSawWeaponBase._play_sound_idle = function(l_3_0)
  l_3_0:play_sound("Play_npc_saw_handheld_loop_idle")
end

NPCSawWeaponBase.update = function(l_4_0, l_4_1, l_4_2, l_4_3)
  if l_4_0._check_shooting_expired and l_4_0._check_shooting_expired.check_t < l_4_2 then
    l_4_0._check_shooting_expired = nil
    l_4_0._unit:set_extension_update_enabled(Idstring("base"), false)
    SawWeaponBase._stop_sawing_effect(l_4_0)
    l_4_0:play_tweak_data_sound("stop_fire")
  end
end

NPCSawWeaponBase.change_fire_object = function(l_5_0, l_5_1)
  NPCSawWeaponBase.super.change_fire_object(l_5_0, l_5_1)
  l_5_0._active_effect_table.parent = l_5_1
end

local mto = Vector3()
local mfrom = Vector3()
NPCSawWeaponBase.fire_blank = function(l_6_0, l_6_1, l_6_2)
  if not l_6_0._check_shooting_expired then
    l_6_0:play_tweak_data_sound("fire")
  end
  l_6_0._check_shooting_expired = {check_t = Application:time() + 0.5}
  l_6_0._unit:set_extension_update_enabled(Idstring("base"), true)
  l_6_0._obj_fire:m_position(mfrom)
  l_6_1 = l_6_0._obj_fire:rotation():y()
  mvector3.add(mfrom, l_6_1 * -30)
  mvector3.set(mto, l_6_1)
  mvector3.multiply(mto, 50)
  mvector3.add(mto, mfrom)
  local col_ray = World:raycast("ray", mfrom, mto, "slot_mask", l_6_0._bullet_slotmask, "ignore_unit", l_6_0._setup.ignore_units)
  if col_ray and col_ray.unit then
    SawWeaponBase._start_sawing_effect(l_6_0)
  else
    SawWeaponBase._stop_sawing_effect(l_6_0)
  end
end

NPCSawWeaponBase.destroy = function(l_7_0, ...)
  NPCSawWeaponBase.super.destroy(l_7_0, ...)
  SawWeaponBase._stop_sawing_effect(l_7_0)
   -- DECOMPILER ERROR: Confused about usage of registers for local variables.

end


