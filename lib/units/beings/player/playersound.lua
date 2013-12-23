-- Decompiled using luadec 2.0.1 by sztupy (http://winmo.sztupy.hu)
-- Command line was: F:\SteamLibrary\SteamApps\common\PAYDAY 2\lua\lib\units\beings\player\playersound.luac 

if not PlayerSound then
  PlayerSound = class()
end
PlayerSound.init = function(l_1_0, l_1_1)
  l_1_0._unit = l_1_1
  l_1_1:base():post_init()
  local ss = l_1_1:sound_source()
  ss:set_switch("robber", "rb3")
  if l_1_1:base().is_local_player then
    ss:set_switch("int_ext", "first")
  else
    ss:set_switch("int_ext", "third")
  end
end

PlayerSound.destroy = function(l_2_0, l_2_1)
  l_2_1:base():pre_destroy(l_2_1)
end

PlayerSound._play = function(l_3_0, l_3_1, l_3_2)
   -- DECOMPILER ERROR: Confused at declaration of local variable

  do
     -- DECOMPILER ERROR: Confused at declaration of local variable

     -- DECOMPILER ERROR: Confused while interpreting a jump as a 'while'

  end
  return l_3_0._unit:sound_source(Idstring(l_3_2)):post_event(l_3_1, l_3_0.sound_callback, l_3_0._unit, "marker", "end_of_event")
end
 -- DECOMPILER ERROR: Confused about usage of registers for local variables.

end

PlayerSound.sound_callback = function(l_4_0, l_4_1, l_4_2, l_4_3, l_4_4, l_4_5, l_4_6, l_4_7)
  if not alive(l_4_3) then
    return 
  end
  if l_4_2 == "end_of_event" then
    managers.hud:set_mugshot_talk(l_4_3:unit_data().mugshot_id, false)
    l_4_3:sound()._speaking = nil
  end
end

PlayerSound.play = function(l_5_0, l_5_1, l_5_2, l_5_3)
  local event_id = nil
  if type(l_5_1) == "number" then
    event_id = l_5_1
  end
  if l_5_3 then
    if not event_id then
      event_id = SoundDevice:string_to_id(l_5_1)
    end
    if not l_5_2 then
      l_5_2 = ""
    end
    l_5_0._unit:network():send("unit_sound_play", event_id, l_5_2)
  end
  local event = l_5_0:_play(event_id or l_5_1, l_5_2)
  if not event then
    Application:error("[PlayerSound:play] event not found in Wwise", l_5_1, event_id, l_5_0._unit)
    return 
  end
  return event
end

PlayerSound.stop = function(l_6_0, l_6_1)
   -- DECOMPILER ERROR: Confused at declaration of local variable

   -- DECOMPILER ERROR: Confused while interpreting a jump as a 'while'

end
l_6_0._unit:sound_source(Idstring(l_6_1)):stop()
 -- DECOMPILER ERROR: Confused about usage of registers for local variables.

end

PlayerSound.play_footstep = function(l_7_0, l_7_1, l_7_2)
  if l_7_0._last_material ~= l_7_2 then
    l_7_0._last_material = l_7_2
    local material_name = tweak_data.materials[l_7_2:key()]
    l_7_0._unit:sound_source(Idstring("root")):set_switch("materials", material_name or "no_material")
  end
  l_7_0:_play(l_7_0._unit:movement():running() and "footstep_run" or "footstep_walk")
end

PlayerSound.play_land = function(l_8_0, l_8_1)
  if l_8_0._last_material ~= l_8_1 then
    l_8_0._last_material = l_8_1
    local material_name = tweak_data.materials[l_8_1:key()]
    l_8_0._unit:sound_source(Idstring("root")):set_switch("materials", material_name or "concrete")
  end
  l_8_0:_play("footstep_land")
end

PlayerSound.play_whizby = function(l_9_0, l_9_1)
  l_9_0:_play("bullet_whizby_medium")
end

PlayerSound.say = function(l_10_0, l_10_1, l_10_2, l_10_3)
  if l_10_0._last_speech and l_10_0._speaking then
    l_10_0._last_speech:stop()
    l_10_0._speaking = nil
  end
  local event_id = nil
  if type(l_10_1) == "number" then
    event_id = l_10_1
  end
  if l_10_3 then
    if not event_id then
      event_id = SoundDevice:string_to_id(l_10_1)
    end
    l_10_0._unit:network():send("say", event_id)
  end
  l_10_0._last_speech = l_10_0:_play(event_id or l_10_1, nil, true)
  if not l_10_0._last_speech then
    Application:error("[PlayerSound:say] event not found in Wwise", l_10_1, event_id, l_10_0._unit)
    return 
  end
  if l_10_2 then
    managers.hud:set_mugshot_talk(l_10_0._unit:unit_data().mugshot_id, true)
    l_10_0._speaking = true
  end
  return l_10_0._last_speech
end

PlayerSound.speaking = function(l_11_0)
  return l_11_0._speaking
end

PlayerSound.set_voice = function(l_12_0, l_12_1)
  l_12_0._unit:sound_source():set_switch("robber", l_12_1)
end


