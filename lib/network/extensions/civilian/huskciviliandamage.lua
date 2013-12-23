-- Decompiled using luadec 2.0.1 by sztupy (http://winmo.sztupy.hu)
-- Command line was: F:\SteamLibrary\SteamApps\common\PAYDAY 2\lua\lib\network\extensions\civilian\huskciviliandamage.luac 

if not HuskCivilianDamage then
  HuskCivilianDamage = class(HuskCopDamage)
end
HuskCivilianDamage._HEALTH_INIT = CivilianDamage._HEALTH_INIT
HuskCivilianDamage.damage_bullet = CivilianDamage.damage_bullet
HuskCivilianDamage.damage_melee = CivilianDamage.damage_melee
HuskCivilianDamage._on_damage_received = function(l_1_0, l_1_1)
  CivilianDamage._on_damage_received(l_1_0, l_1_1)
end

HuskCivilianDamage._unregister_from_enemy_manager = function(l_2_0, l_2_1)
  CivilianDamage._unregister_from_enemy_manager(l_2_0, l_2_1)
end

HuskCivilianDamage.damage_explosion = function(l_3_0, l_3_1)
  if l_3_1.variant == "explosion" then
    l_3_1.damage = 10
  end
  return CopDamage.damage_explosion(l_3_0, l_3_1)
end


