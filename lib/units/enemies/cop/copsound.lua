-- Decompiled using luadec 2.0.1 by sztupy (http://winmo.sztupy.hu)
-- Command line was: F:\SteamLibrary\SteamApps\common\PAYDAY 2\lua\lib\units\enemies\cop\copsound.luac 

if not CopSound then
  CopSound = class()
end
CopSound.init = function(l_1_0, l_1_1)
  l_1_0._unit = l_1_1
  l_1_0._speak_expire_t = 0
  local char_tweak = tweak_data.character[l_1_1:base()._tweak_table]
  local nr_variations = char_tweak.speech_prefix_count
  l_1_0._prefix = (char_tweak.speech_prefix_p1 or "") .. (nr_variations and tostring(math.random(nr_variations)) or "") .. (char_tweak.speech_prefix_p2 or "") .. "_"
  l_1_1:base():post_init()
end

CopSound.destroy = function(l_2_0, l_2_1)
  l_2_1:base():pre_destroy(l_2_1)
end

CopSound._play = function(l_3_0, l_3_1, l_3_2)
   -- DECOMPILER ERROR: Confused at declaration of local variable

  do
     -- DECOMPILER ERROR: Confused at declaration of local variable

     -- DECOMPILER ERROR: Confused while interpreting a jump as a 'while'

  end
  return l_3_0._unit:sound_source(Idstring(l_3_2)):post_event(l_3_1)
end
 -- DECOMPILER ERROR: Confused about usage of registers for local variables.

end

CopSound.play = function(l_4_0, l_4_1, l_4_2, l_4_3)
  local event_id = nil
  if type(l_4_1) == "number" then
    event_id = l_4_1
  end
  if l_4_3 then
    if not event_id then
      event_id = SoundDevice:string_to_id(l_4_1)
    end
    local sync_source_name = l_4_2 or ""
    l_4_0._unit:network():send("unit_sound_play", event_id, sync_source_name)
  end
  local event = l_4_0:_play(event_id or l_4_1, l_4_2)
  if not event then
    Application:error("[CopSound:play] event not found in Wwise", l_4_1, event_id, l_4_0._unit)
    Application:stack_dump("error")
    return 
  end
  return event
end

CopSound.corpse_play = function(l_5_0, l_5_1, l_5_2, l_5_3)
  local event_id = nil
  if type(l_5_1) == "number" then
    event_id = l_5_1
  end
  if l_5_3 then
    if not event_id then
      event_id = SoundDevice:string_to_id(l_5_1)
    end
    local sync_source_name = l_5_2 or ""
    local u_id = managers.enemy:get_corpse_unit_data_from_key(l_5_0._unit:key()).u_id
    managers.network:session():send_to_peers_synched("corpse_sound_play", u_id, event_id, sync_source_name)
  end
  local event = l_5_0:_play(event_id or l_5_1, l_5_2)
  if not event then
    Application:error("[CopSound:corpse_play] event not found in Wwise", l_5_1, event_id, l_5_0._unit)
    Application:stack_dump("error")
    return 
  end
  return event
end

CopSound.stop = function(l_6_0, l_6_1)
   -- DECOMPILER ERROR: Confused at declaration of local variable

   -- DECOMPILER ERROR: Confused while interpreting a jump as a 'while'

end
l_6_0._unit:sound_source(Idstring(l_6_1)):stop()
 -- DECOMPILER ERROR: Confused about usage of registers for local variables.

end

CopSound.say = function(l_7_0, l_7_1, l_7_2, l_7_3)
  if l_7_0._last_speech then
    l_7_0._last_speech:stop()
  end
  local full_sound = nil
  if l_7_3 then
    full_sound = l_7_1
  else
    full_sound = l_7_0._prefix .. l_7_1
  end
  local event_id = nil
  if type(full_sound) == "number" then
    event_id = full_sound
  end
  if l_7_2 then
    if not event_id then
      event_id = SoundDevice:string_to_id(full_sound)
    end
    l_7_0._unit:network():send("say", event_id)
  end
  l_7_0._last_speech = l_7_0:_play(event_id or full_sound)
  if not l_7_0._last_speech then
    Application:error("[CopSound:say] event not found in Wwise", full_sound, event_id, l_7_0._unit)
    Application:stack_dump("error")
    return 
  end
  l_7_0._speak_expire_t = TimerManager:game():time() + 2
end

CopSound.sync_say_str = function(l_8_0, l_8_1)
  if l_8_0._last_speech then
    l_8_0._last_speech:stop()
  end
  l_8_0._last_speech = l_8_0:play(l_8_1)
end

CopSound.speaking = function(l_9_0, l_9_1)
  return l_9_1 < l_9_0._speak_expire_t
end

CopSound.anim_clbk_play_sound = function(l_10_0, l_10_1, l_10_2)
  l_10_0:_play(l_10_2)
end


