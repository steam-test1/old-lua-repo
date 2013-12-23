-- Decompiled using luadec 2.0.1 by sztupy (http://winmo.sztupy.hu)
-- Command line was: F:\SteamLibrary\SteamApps\common\PAYDAY 2\lua\lib\network\extensions\cop\husktankcopdamage.luac 

if not HuskTankCopDamage then
  HuskTankCopDamage = class(HuskCopDamage)
end
HuskTankCopDamage.damage_melee = function(l_1_0, l_1_1)
  return 
end

HuskTankCopDamage.sync_damage_melee = function(l_2_0, l_2_1, l_2_2, l_2_3, l_2_4, l_2_5)
  return 
end

HuskTankCopDamage.seq_clbk_vizor_shatter = function(l_3_0)
  TankCopDamage.seq_clbk_vizor_shatter(l_3_0)
end


