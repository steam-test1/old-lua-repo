-- Decompiled using luadec 2.0.1 by sztupy (http://winmo.sztupy.hu)
-- Command line was: F:\SteamLibrary\SteamApps\common\PAYDAY 2\lua\lib\units\weapons\grenades\flashgrenade.luac 

if not FlashGrenade then
  FlashGrenade = class(GrenadeBase)
end
FlashGrenade.init = function(l_1_0, l_1_1)
  l_1_0._init_timer = 1
  FlashGrenade.super.init(l_1_0, l_1_1)
end

FlashGrenade._detonate = function(l_2_0)
  local units = World:find_units("sphere", l_2_0._unit:position(), 400, l_2_0._slotmask)
  for _,unit in ipairs(units) do
    local col_ray = {}
    col_ray.ray = unit:position() - l_2_0._unit:position():normalized()
    col_ray.position = l_2_0._unit:position()
    l_2_0:_give_flash_damage(col_ray, unit, 10)
  end
  l_2_0._unit:set_slot(0)
end

FlashGrenade._play_sound_and_effects = function(l_3_0)
  World:effect_manager():spawn({effect = Idstring("effects/particles/explosions/explosion_flash_grenade"), position = l_3_0._unit:position(), normal = l_3_0._unit:rotation():y()})
  l_3_0._unit:sound_source():post_event("trip_mine_explode")
end

FlashGrenade._give_flash_damage = function(l_4_0, l_4_1, l_4_2, l_4_3)
end


