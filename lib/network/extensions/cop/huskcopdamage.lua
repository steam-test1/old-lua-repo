-- Decompiled using luadec 2.0.1 by sztupy (http://winmo.sztupy.hu)
-- Command line was: F:\SteamLibrary\SteamApps\common\PAYDAY 2\lua\lib\network\extensions\cop\huskcopdamage.luac 

if not HuskCopDamage then
  HuskCopDamage = class(CopDamage)
end
HuskCopDamage.die = function(l_1_0, l_1_1)
  l_1_0._unit:base():set_slot(l_1_0._unit, 17)
  if l_1_0._unit:inventory() then
    l_1_0._unit:inventory():drop_shield()
  end
  if not l_1_1 then
    l_1_1 = "bullet"
  end
  l_1_0._health = 0
  l_1_0._health_ratio = 0
  l_1_0._dead = true
  l_1_0:set_mover_collision_state(false)
  if l_1_0._death_sequence then
    if l_1_0._unit:damage() and l_1_0._unit:damage():has_sequence(l_1_0._death_sequence) then
      l_1_0._unit:damage():run_sequence_simple(l_1_0._death_sequence)
    else
      debug_pause_unit(l_1_0._unit, "[HuskCopDamage:die] does not have death sequence", l_1_0._death_sequence, l_1_0._unit)
    end
  end
end


