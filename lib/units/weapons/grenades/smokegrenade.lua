-- Decompiled using luadec 2.0.1 by sztupy (http://winmo.sztupy.hu)
-- Command line was: F:\SteamLibrary\SteamApps\common\PAYDAY 2\lua\lib\units\weapons\grenades\smokegrenade.luac 

if not SmokeGrenade then
  SmokeGrenade = class(GrenadeBase)
end
SmokeGrenade.init = function(l_1_0, l_1_1)
  l_1_0._init_timer = 1.5
  SmokeGrenade.super.init(l_1_0, l_1_1)
end

SmokeGrenade.update = function(l_2_0, l_2_1, l_2_2, l_2_3)
  SmokeGrenade.super.update(l_2_0, l_2_1, l_2_2, l_2_3)
  if l_2_0._smoke_timer then
    l_2_0._smoke_timer = l_2_0._smoke_timer - l_2_3
    if l_2_0._smoke_timer <= 0 then
      l_2_0._smoke_timer = nil
      World:effect_manager():fade_kill(l_2_0._smoke_effect)
    end
  end
end

SmokeGrenade._detonate = function(l_3_0)
  local units = World:find_units("sphere", l_3_0._unit:position(), 400, l_3_0._slotmask)
  for _,unit in ipairs(units) do
    local col_ray = {}
    col_ray.ray = unit:position() - l_3_0._unit:position():normalized()
    col_ray.position = l_3_0._unit:position()
    l_3_0:_give_smoke_damage(col_ray, unit, 10)
  end
end

SmokeGrenade._play_sound_and_effects = function(l_4_0)
  World:effect_manager():spawn({effect = Idstring("effects/particles/explosions/explosion_smoke_grenade"), position = l_4_0._unit:position(), normal = l_4_0._unit:rotation():y()})
  l_4_0._unit:sound_source():post_event("trip_mine_explode")
  local parent = l_4_0._unit:orientation_object()
  l_4_0._smoke_effect = World:effect_manager():spawn({effect = Idstring("effects/particles/explosions/smoke_grenade_smoke"), parent = parent})
  l_4_0._smoke_timer = 10
end

SmokeGrenade._give_smoke_damage = function(l_5_0, l_5_1, l_5_2, l_5_3)
end

SmokeGrenade.destroy = function(l_6_0)
  if l_6_0._smoke_effect then
    World:effect_manager():kill(l_6_0._smoke_effect)
  end
  SmokeGrenade.super.destroy(l_6_0)
end


