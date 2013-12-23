-- Decompiled using luadec 2.0.1 by sztupy (http://winmo.sztupy.hu)
-- Command line was: F:\SteamLibrary\SteamApps\common\PAYDAY 2\lua\lib\managers\timespeedmanager.luac 

if not TimeSpeedManager then
  TimeSpeedManager = class()
end
TimeSpeedManager.init = function(l_1_0)
  l_1_0._pausable_timer = TimerManager:pausable()
  l_1_0._game_timer = TimerManager:game()
  l_1_0._game_anim_timer = TimerManager:game_animation()
  l_1_0._game_speed_rtpc = 1
end

TimeSpeedManager.update = function(l_2_0)
  if l_2_0._playing_effects then
    l_2_0:_update_playing_effects()
  end
end

TimeSpeedManager._update_playing_effects = function(l_3_0)
  local slowest_speed = nil
  local playing_effects = l_3_0._playing_effects
  if playing_effects then
    local all_affected_timers = l_3_0._affected_timers
    for timer_key,timer_info in pairs(all_affected_timers) do
      timer_info.mul = 1
    end
    for effect_id,effect in pairs(playing_effects) do
      local time = (effect.timer:time())
      local effect_speed = nil
      if time < effect.fade_in_delay_end_t then
        do return end
      end
      if time < effect.fade_in_end_t then
        effect_speed = math.lerp(1, effect.desc.speed, (time - effect.fade_in_delay_end_t) / effect.desc.fade_in ^ 0.5)
      elseif not effect.sustain_end_t or time < effect.sustain_end_t then
        effect_speed = effect.desc.speed
      elseif time < effect.effect_end_t then
        effect_speed = math.lerp(effect.desc.speed, 1, (time - effect.sustain_end_t) / effect.desc.fade_out ^ 0.5)
      else
        l_3_0:_on_effect_expired(effect_id)
      end
      if effect_speed then
        for timer_key,affect_timer in pairs(effect.affect_timers) do
          local timer_info = l_3_0._affected_timers[timer_key]
          timer_info.mul = math.min(timer_info.mul, effect_speed)
        end
        if slowest_speed or not effect_speed then
          slowest_speed = math.min(slowest_speed, effect_speed)
        end
      end
    end
    local game_speed_rtpc_changed = false
     -- DECOMPILER ERROR: unhandled construct in 'if'

     -- DECOMPILER ERROR: unhandled construct in 'if'

    if slowest_speed and slowest_speed < 0.5 and l_3_0._game_speed_rtpc ~= 0 then
      l_3_0._game_speed_rtpc = 0
      game_speed_rtpc_changed = true
      do return end
       -- DECOMPILER ERROR: unhandled construct in 'if'

      if slowest_speed > 1.5 and l_3_0._game_speed_rtpc ~= 2 then
        l_3_0._game_speed_rtpc = 2
        game_speed_rtpc_changed = true
        do return end
        if l_3_0._game_speed_rtpc ~= 1 then
          l_3_0._game_speed_rtpc = 1
          game_speed_rtpc_changed = true
          do return end
          if l_3_0._game_speed_rtpc ~= 1 then
            l_3_0._game_speed_rtpc = 1
            game_speed_rtpc_changed = true
          end
        end
      end
    end
    if game_speed_rtpc_changed then
      SoundDevice:set_rtpc("game_speed", l_3_0._game_speed_rtpc)
    end
    if l_3_0._affected_timers then
      for timer_key,timer_info in pairs(all_affected_timers) do
        timer_info.timer:set_multiplier(timer_info.mul)
      end
    end
  end
end

TimeSpeedManager.play_effect = function(l_4_0, l_4_1, l_4_2)
  local effect = {desc = l_4_2}
  if l_4_2.timer ~= "pausable" or not l_4_0._pausable_timer then
    effect.timer = l_4_0._game_timer
  end
  effect.start_t = effect.timer:time()
  effect.fade_in_delay_end_t = effect.start_t + (l_4_2.fade_in_delay or 0)
  effect.fade_in_end_t = effect.fade_in_delay_end_t + l_4_2.fade_in
  if l_4_2.sustain then
    effect.sustain_end_t = effect.fade_in_end_t + l_4_2.sustain
  end
  effect.effect_end_t = effect.sustain_end_t + (not effect.sustain_end_t or l_4_2.fade_out or 0)
  if l_4_2.affect_timer then
    if type(l_4_2.affect_timer) == "table" then
      effect.affect_timers = {}
      for _,ids_timer_name in ipairs(l_4_2.affect_timer) do
        local timer = TimerManager:timer(ids_timer_name)
        effect.affect_timers[timer:key()] = timer
      end
    else
      local timer = TimerManager:timer(l_4_2.affect_timer)
      effect.affect_timers = {timer:key() = timer}
    end
  else
    effect.affect_timers = {l_4_0._game_timer:key() = l_4_0._game_timer, l_4_0._game_anim_timer:key() = l_4_0._game_anim_timer}
  end
end
if not l_4_0._affected_timers then
  l_4_0._affected_timers = {}
end
for timer_key,affect_timer in pairs(effect.affect_timers) do
  if l_4_0._affected_timers[timer_key] then
    l_4_0._affected_timers[timer_key].ref_count = l_4_0._affected_timers[timer_key].ref_count + 1
    for (for control),timer_key in (for generator) do
    end
    l_4_0._affected_timers[timer_key] = {timer = affect_timer, mul = 1, ref_count = 1}
  end
  if not l_4_0._playing_effects then
    l_4_0._playing_effects = {}
  end
  l_4_0._playing_effects[l_4_1] = effect
  managers.network:session():send_to_peers_synched("start_timespeed_effect", l_4_1, l_4_2.timer, l_4_2.speed, not l_4_2.sync or not managers.network:session() or managers.network:session():closing() or 0, not l_4_2.fade_in and l_4_2.sustain or 0, l_4_2.fade_out or 0)
end

TimeSpeedManager.stop_effect = function(l_5_0, l_5_1, l_5_2)
  if not l_5_0._playing_effects then
    return 
  end
  if managers.network:session() and not managers.network:session():closing() then
    local effect_instance = l_5_0._playing_effects[l_5_1]
    if effect_instance and effect_instance.desc.sync then
      local sync_fade_out_duration = nil
      if l_5_2 and l_5_2 ~= 0 then
        sync_fade_out_duration = l_5_2
      else
        sync_fade_out_duration = 0
      end
      managers.network:session():send_to_peers_synched("start_timespeed_effect", l_5_1, sync_fade_out_duration)
    end
  end
  if l_5_2 and l_5_2 ~= 0 then
    local effect_instance = l_5_0._playing_effects[l_5_1]
    if not effect_instance then
      return 
    end
    local t = effect_instance.timer:time()
    effect_instance.sustain_end_t = t
    effect_instance.effect_end_t = t + l_5_2
  else
    l_5_0:_on_effect_expired(l_5_1)
  end
end

TimeSpeedManager._on_effect_expired = function(l_6_0, l_6_1)
  local effect = l_6_0._playing_effects[l_6_1]
  for timer_key,affect_timer in pairs(effect.affect_timers) do
    local timer_info = l_6_0._affected_timers[timer_key]
    if timer_info.ref_count == 1 then
      timer_info.timer:set_multiplier(1)
      l_6_0._affected_timers[timer_key] = nil
      for (for control),timer_key in (for generator) do
      end
      timer_info.ref_count = timer_info.ref_count - 1
    end
    l_6_0._playing_effects[l_6_1] = nil
    if not next(l_6_0._playing_effects) then
      l_6_0._playing_effects = nil
      l_6_0._affected_timers = nil
    end
     -- Warning: missing end command somewhere! Added here
  end
end

TimeSpeedManager.in_effect = function(l_7_0)
  return not l_7_0._playing_effects or true
end

TimeSpeedManager.destroy = function(l_8_0)
  repeat
    if l_8_0._playing_effects then
      local eff_id, eff = next(l_8_0._playing_effects)
      l_8_0:_on_effect_expired(eff_id)
    else
      SoundDevice:set_rtpc("game_speed", 1)
       -- Warning: missing end command somewhere! Added here
    end
     -- Warning: missing end command somewhere! Added here
  end
end


