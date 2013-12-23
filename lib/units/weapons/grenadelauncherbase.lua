-- Decompiled using luadec 2.0.1 by sztupy (http://winmo.sztupy.hu)
-- Command line was: F:\SteamLibrary\SteamApps\common\PAYDAY 2\lua\lib\units\weapons\grenadelauncherbase.luac 

if not GrenadeLauncherBase then
  GrenadeLauncherBase = class(RaycastWeaponBase)
end
GrenadeLauncherBase.init = function(l_1_0, ...)
  GrenadeLauncherBase.super.init(l_1_0, ...)
   -- DECOMPILER ERROR: Confused about usage of registers for local variables.

end

GrenadeLauncherBase._fire_raycast = function(l_2_0, l_2_1, l_2_2, l_2_3)
  local range_mul = managers.player:upgrade_value(l_2_0._name_id, "explosion_range_multiplier")
  local range = tweak_data.weapon[l_2_0._name_id].EXPLOSION_RANGE * (range_mul == 0 and 1 or range_mul)
  local curve_pow = tweak_data.weapon[l_2_0._name_id].DAMAGE_CURVE_POW
  local unit = M79GrenadeBase.spawn("units/weapons/m79/grenade", l_2_2, Rotation(l_2_3, math.UP))
  unit:base():launch({dir = l_2_3, owner = l_2_0._unit, user = l_2_1, damage = l_2_0._damage, range = range, curve_pow = curve_pow, alert_filter = l_2_1:movement():SO_access()})
  return {}
end


