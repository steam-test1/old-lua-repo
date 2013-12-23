-- Decompiled using luadec 2.0.1 by sztupy (http://winmo.sztupy.hu)
-- Command line was: F:\SteamLibrary\SteamApps\common\PAYDAY 2\lua\lib\units\weapons\grenades\fraggrenade.luac 

if not FragGrenade then
  FragGrenade = class(GrenadeBase)
end
FragGrenade.init = function(l_1_0, l_1_1)
  FragGrenade.super.init(l_1_0, l_1_1)
end

FragGrenade._detonate = function(l_2_0)
  local units = World:find_units("sphere", l_2_0._unit:position(), 400, l_2_0._slotmask)
  for _,unit in ipairs(units) do
    local col_ray = {}
    col_ray.ray = unit:position() - l_2_0._unit:position():normalized()
    col_ray.position = l_2_0._unit:position()
    if unit:character_damage() and unit:character_damage().damage_explosion then
      l_2_0:_give_explosion_damage(col_ray, unit, 10)
    end
  end
  l_2_0._unit:set_slot(0)
end

FragGrenade._play_sound_and_effects = function(l_3_0)
  World:effect_manager():spawn({effect = Idstring("effects/particles/explosions/explosion_grenade"), position = l_3_0._unit:position(), normal = l_3_0._unit:rotation():y()})
  l_3_0._unit:sound_source():post_event("trip_mine_explode")
end

FragGrenade._give_explosion_damage = function(l_4_0, l_4_1, l_4_2, l_4_3)
  local action_data = {}
  action_data.variant = "explosion"
  action_data.damage = l_4_3
  action_data.attacker_unit = l_4_0._unit
  action_data.col_ray = l_4_1
  local defense_data = l_4_2:character_damage():damage_explosion(action_data)
  return defense_data
end


