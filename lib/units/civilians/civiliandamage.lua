-- Decompiled using luadec 2.0.1 by sztupy (http://winmo.sztupy.hu)
-- Command line was: F:\SteamLibrary\SteamApps\common\PAYDAY 2\lua\lib\units\civilians\civiliandamage.luac 

if not CivilianDamage then
  CivilianDamage = class(CopDamage)
end
CivilianDamage.init = function(l_1_0, l_1_1)
  CivilianDamage.super.init(l_1_0, l_1_1)
  l_1_0._pickup = nil
end

CivilianDamage.die = function(l_2_0, l_2_1)
  l_2_0._unit:base():set_slot(l_2_0._unit, 17)
  l_2_0:drop_pickup()
  if l_2_0._unit:unit_data().mission_element then
    l_2_0._unit:unit_data().mission_element:event("death", l_2_0._unit)
  end
  if not l_2_1 then
    l_2_1 = "bullet"
  end
  l_2_0._health = 0
  l_2_0._health_ratio = 0
  l_2_0._dead = true
  l_2_0:set_mover_collision_state(false)
end

CivilianDamage._on_damage_received = function(l_3_0, l_3_1)
  l_3_0:_call_listeners(l_3_1)
  if l_3_1.result.type == "death" then
    l_3_0:_unregister_from_enemy_manager(l_3_1)
    if Network:is_client() then
      l_3_0._unit:interaction():set_active(false, false)
    end
  end
end

CivilianDamage.print = function(l_4_0, ...)
  cat_print("civ_damage", ...)
   -- DECOMPILER ERROR: Confused about usage of registers for local variables.

end

CivilianDamage._unregister_from_enemy_manager = function(l_5_0, l_5_1)
  managers.enemy:on_civilian_died(l_5_0._unit, l_5_1)
end

CivilianDamage.damage_bullet = function(l_6_0, l_6_1)
  if managers.player:has_category_upgrade("player", "civ_harmless_bullets") then
    print("self._survive_shot_t", l_6_0._survive_shot_t, "TimerManager:game():time()", TimerManager:game():time())
    if not l_6_0._survive_shot_t or l_6_0._survive_shot_t < TimerManager:game():time() then
      print("good")
      l_6_0._survive_shot_t = TimerManager:game():time() + 2.5
      l_6_0._unit:brain():on_intimidated(1, l_6_1.attacker_unit)
      return 
    end
  end
  l_6_1.damage = 10
  return CopDamage.damage_bullet(l_6_0, l_6_1)
end

CivilianDamage.damage_explosion = function(l_7_0, l_7_1)
  if l_7_1.variant == "explosion" then
    l_7_1.damage = 10
  end
  return CopDamage.damage_explosion(l_7_0, l_7_1)
end

CivilianDamage.damage_melee = function(l_8_0, l_8_1)
  if managers.player:has_category_upgrade("player", "civ_harmless_melee") then
    print("self._survive_shot_t", l_8_0._survive_shot_t, "TimerManager:game():time()", TimerManager:game():time())
    if not l_8_0._survive_shot_t or l_8_0._survive_shot_t < TimerManager:game():time() then
      print("good")
      l_8_0._survive_shot_t = TimerManager:game():time() + 2.5
      l_8_0._unit:brain():on_intimidated(1, l_8_1.attacker_unit)
      return 
    end
  end
  l_8_1.damage = 10
  return CopDamage.damage_melee(l_8_0, l_8_1)
end


