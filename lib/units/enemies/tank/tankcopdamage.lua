-- Decompiled using luadec 2.0.1 by sztupy (http://winmo.sztupy.hu)
-- Command line was: F:\SteamLibrary\SteamApps\common\PAYDAY 2\lua\lib\units\enemies\tank\tankcopdamage.luac 

if not TankCopDamage then
  TankCopDamage = class(CopDamage)
end
TankCopDamage.damage_melee = function(l_1_0, l_1_1)
  return 
end

TankCopDamage.sync_damage_melee = function(l_2_0, l_2_1, l_2_2, l_2_3, l_2_4, l_2_5)
  return 
end

TankCopDamage.seq_clbk_vizor_shatter = function(l_3_0)
  if not l_3_0._unit:character_damage():dead() then
    l_3_0._unit:sound():say("visor_lost")
  end
end


