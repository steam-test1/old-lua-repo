-- Decompiled using luadec 2.0.1 by sztupy (http://winmo.sztupy.hu)
-- Command line was: F:\SteamLibrary\SteamApps\common\PAYDAY 2\lua\lib\units\weapons\npcgrenadelauncherbase.luac 

if not NPCGrenadeLauncherBase then
  NPCGrenadeLauncherBase = class(NPCRaycastWeaponBase)
end
NPCGrenadeLauncherBase.init = function(l_1_0, ...)
  NPCGrenadeLauncherBase.super.init(l_1_0, ...)
   -- DECOMPILER ERROR: Confused about usage of registers for local variables.

end

NPCGrenadeLauncherBase.fire_blank = function(l_2_0, l_2_1, l_2_2)
  World:effect_manager():spawn(l_2_0._muzzle_effect_table)
  l_2_0:_sound_singleshot()
end


