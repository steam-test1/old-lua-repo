-- Decompiled using luadec 2.0.1 by sztupy (http://winmo.sztupy.hu)
-- Command line was: F:\SteamLibrary\SteamApps\common\PAYDAY 2\lua\lib\managers\mission\elementexplosiondamage.luac 

core:import("CoreMissionScriptElement")
if not ElementExplosionDamage then
  ElementExplosionDamage = class(CoreMissionScriptElement.MissionScriptElement)
end
ElementExplosionDamage.init = function(l_1_0, ...)
  ElementExplosionDamage.super.init(l_1_0, ...)
   -- DECOMPILER ERROR: Confused about usage of registers for local variables.

end

ElementExplosionDamage.client_on_executed = function(l_2_0, ...)
  l_2_0:on_executed(...)
   -- DECOMPILER ERROR: Confused about usage of registers for local variables.

end

ElementExplosionDamage.on_executed = function(l_3_0, l_3_1)
  if not l_3_0._values.enabled then
    return 
  end
  local player = managers.player:player_unit()
  if player then
    player:character_damage():damage_explosion({position = l_3_0._values.position, range = l_3_0._values.range, damage = l_3_0._values.damage})
  end
  ElementExplosionDamage.super.on_executed(l_3_0, l_3_1)
end


