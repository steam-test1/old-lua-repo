-- Decompiled using luadec 2.0.1 by sztupy (http://winmo.sztupy.hu)
-- Command line was: F:\SteamLibrary\SteamApps\common\PAYDAY 2\lua\lib\units\weapons\grenades\quicksmokegrenade.luac 

if not QuickSmokeGrenade then
  QuickSmokeGrenade = class()
end
QuickSmokeGrenade.init = function(l_1_0, l_1_1)
  l_1_0._unit = l_1_1
  l_1_0._state = 0
end

QuickSmokeGrenade.update = function(l_2_0, l_2_1, l_2_2, l_2_3)
  if l_2_0._remove_t and l_2_0._remove_t < l_2_2 then
    l_2_0._unit:set_slot(0)
  end
  if l_2_0._state == 1 then
    l_2_0._timer = l_2_0._timer - l_2_3
    if l_2_0._timer <= 0 then
      l_2_0._timer = l_2_0._timer + 0.5
      l_2_0._state = 2
      l_2_0:_play_sound_and_effects()
    elseif l_2_0._state == 2 then
      l_2_0._timer = l_2_0._timer - l_2_3
      if l_2_0._timer <= 0 then
        l_2_0._state = 3
        l_2_0:detonate()
      end
    end
  end
end

QuickSmokeGrenade.activate = function(l_3_0, l_3_1, l_3_2)
  l_3_0._state = 1
  l_3_0._timer = 0.5
  l_3_0._shoot_position = l_3_1
  l_3_0._duration = l_3_2
  l_3_0:_play_sound_and_effects()
end

QuickSmokeGrenade.detonate = function(l_4_0)
  l_4_0:_play_sound_and_effects()
  l_4_0._remove_t = TimerManager:game():time() + l_4_0._duration
end

QuickSmokeGrenade.preemptive_kill = function(l_5_0)
  l_5_0._unit:sound_source():post_event("grenade_gas_stop")
  l_5_0._unit:set_slot(0)
end

QuickSmokeGrenade._play_sound_and_effects = function(l_6_0)
  if l_6_0._state == 1 then
    local sound_source = SoundDevice:create_source("grenade_fire_source")
    sound_source:set_position(l_6_0._shoot_position)
    sound_source:post_event("grenade_gas_npc_fire")
  elseif l_6_0._state == 2 then
    local bounce_point = Vector3()
    mvector3.lerp(bounce_point, l_6_0._shoot_position, l_6_0._unit:position(), 0.64999997615814)
    local sound_source = SoundDevice:create_source("grenade_bounce_source")
    sound_source:set_position(bounce_point)
    sound_source:post_event("grenade_gas_bounce")
  elseif l_6_0._state == 3 then
    World:effect_manager():spawn({effect = Idstring("effects/particles/explosions/explosion_smoke_grenade"), position = l_6_0._unit:position(), normal = l_6_0._unit:rotation():y()})
    l_6_0._unit:sound_source():post_event("grenade_gas_explode")
    local parent = l_6_0._unit:orientation_object()
    l_6_0._smoke_effect = World:effect_manager():spawn({effect = Idstring("effects/particles/explosions/smoke_grenade_smoke"), parent = parent})
  end
end

QuickSmokeGrenade.destroy = function(l_7_0)
  if l_7_0._smoke_effect then
    World:effect_manager():fade_kill(l_7_0._smoke_effect)
  end
end


