-- Decompiled using luadec 2.0.1 by sztupy (http://winmo.sztupy.hu)
-- Command line was: F:\SteamLibrary\SteamApps\common\PAYDAY 2\lua\lib\managers\voicebriefingmanager.luac 

core:import("CoreSubtitlePresenter")
if not VoiceBriefingManager then
  VoiceBriefingManager = class()
end
VoiceBriefingManager.init = function(l_1_0)
  l_1_0:_clear_event()
  l_1_0:_setup()
end

VoiceBriefingManager._setup = function(l_2_0)
  l_2_0._sound_source = SoundDevice:create_source("VoiceBriefingManager")
  managers.subtitle:set_presenter(CoreSubtitlePresenter.OverlayPresenter:new(tweak_data.menu.pd2_medium_font, tweak_data.menu.pd2_medium_font_size))
end

VoiceBriefingManager._set_parameters = function(l_3_0, l_3_1)
  if not l_3_1 then
    l_3_1 = {}
  end
   -- DECOMPILER ERROR: Confused while interpreting a jump as a 'while'

end
l_3_0._params.show_subtitle = true
if l_3_1.listener then
  l_3_0:add_listener(l_3_1.listener)
end
if l_3_1.listeners then
  for _,listener in pairs(l_3_1.listeners) do
    l_3_0:add_listener(listener)
  end
end
end

VoiceBriefingManager._debug_callback = function(l_4_0, ...)
  Application:debug(inspect({...}))
  l_4_0:_sound_callback(...)
   -- DECOMPILER ERROR: Confused about usage of registers for local variables.

end

VoiceBriefingManager._sound_callback = function(l_5_0, l_5_1, l_5_2, l_5_3, l_5_4, l_5_5, l_5_6, l_5_7)
  if l_5_3 == "end_of_event" then
    l_5_0:_end_of_event(l_5_4)
  elseif l_5_3 == "marker" and l_5_5 then
    l_5_0:_play_subtitle(l_5_5, l_5_4)
    do return end
    if l_5_3 == "duration" then
      l_5_0:_set_duration(l_5_5, l_5_4)
    end
  end
end

VoiceBriefingManager._end_of_event = function(l_6_0, l_6_1)
  if l_6_0._listeners_enabled then
    for _,listener in ipairs(l_6_0._listeners) do
      if listener.end_of_event then
        listener.clbk("end_of_event", l_6_0._event_name, l_6_1)
      end
    end
  end
  l_6_0:_clear_event()
end

VoiceBriefingManager._play_subtitle = function(l_7_0, l_7_1, l_7_2)
  local duration = l_7_0:_subtitle_len(l_7_1)
  if l_7_0._params.show_subtitle then
    managers.subtitle:set_visible(true)
    managers.subtitle:set_enabled(true)
    managers.subtitle:show_subtitle(l_7_1, duration)
  end
  if l_7_0._listeners_enabled then
    for _,listener in ipairs(l_7_0._listeners) do
      if listener.marker then
        listener.clbk("marker", l_7_1, duration, l_7_2)
      end
    end
  end
end

VoiceBriefingManager._set_duration = function(l_8_0, l_8_1, l_8_2)
  if l_8_0._listeners_enabled then
    for _,listener in ipairs(l_8_0._listeners) do
      if listener.duration then
        listener.clbk("duration", l_8_1, l_8_2)
      end
    end
  end
end

VoiceBriefingManager._subtitle_len = function(l_9_0, l_9_1)
  local text = managers.localization:text(l_9_1)
  local duration = text:len() * tweak_data.dialog.DURATION_PER_CHAR
  if duration < tweak_data.dialog.MINIMUM_DURATION then
    duration = tweak_data.dialog.MINIMUM_DURATION
  end
  return duration
end

VoiceBriefingManager._check_event_ok = function(l_10_0)
  if not l_10_0._event_instance then
    Application:error("[VoiceBriefingManager:_check_event_ok] Wasn't able to play sound event " .. tostring(l_10_0._event_name))
    Application:stack_dump()
    l_10_0._post_event_enabled = false
    l_10_0:_sound_callback(nil, nil, "end_of_event", nil, l_10_0._event_name, nil, nil, nil)
    l_10_0._post_event_enabled = true
    return false
  end
  return true
end

VoiceBriefingManager._clear_event = function(l_11_0)
  l_11_0._event_name = nil
  l_11_0._event_instance = nil
  l_11_0._listeners = {}
  l_11_0._params = {}
  managers.subtitle:set_visible(false)
  managers.subtitle:set_enabled(false)
  l_11_0._post_event_enabled = true
  l_11_0._listeners_enabled = true
end

VoiceBriefingManager.post_event_simple = function(l_12_0, l_12_1)
  if not l_12_1 or not l_12_0._post_event_enabled then
    return 
  end
  l_12_0:stop_event()
  l_12_0:_set_parameters({show_subtitle = true})
  l_12_0._event_name = l_12_1
  l_12_0._event_instance = l_12_0._sound_source:post_event(l_12_1, (callback(l_12_0, l_12_0, "_sound_callback")), nil, "marker", "end_of_event")
  return l_12_0:_check_event_ok()
end

VoiceBriefingManager.post_event = function(l_13_0, l_13_1, l_13_2)
  if not l_13_1 or not l_13_0._post_event_enabled then
    return 
  end
  l_13_0:stop_event()
  l_13_0:_set_parameters(l_13_2)
  l_13_0._event_name = l_13_1
  l_13_0._event_instance = l_13_0._sound_source:post_event(l_13_1, callback(l_13_0, l_13_0, "_sound_callback"), l_13_2 and l_13_2.cookie or nil, "marker", "duration", "end_of_event")
  return l_13_0:_check_event_ok()
end

VoiceBriefingManager.event_playing = function(l_14_0)
   -- DECOMPILER ERROR: Confused while interpreting a jump as a 'while'

end
return true
end

VoiceBriefingManager.stop_event = function(l_15_0, l_15_1)
  if l_15_0._event_instance then
    l_15_0._event_instance:stop()
    if not l_15_1 then
      l_15_0:_end_of_event()
    else
      l_15_0:_clear_event()
    end
  end
end

VoiceBriefingManager.add_listener = function(l_16_0, l_16_1)
  table.insert(l_16_0._listeners, l_16_1)
end


