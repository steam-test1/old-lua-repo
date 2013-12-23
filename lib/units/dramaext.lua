-- Decompiled using luadec 2.0.1 by sztupy (http://winmo.sztupy.hu)
-- Command line was: F:\SteamLibrary\SteamApps\common\PAYDAY 2\lua\lib\units\dramaext.luac 

core:import("CoreSubtitlePresenter")
if not DramaExt then
  DramaExt = class()
end
DramaExt.init = function(l_1_0, l_1_1)
  l_1_0._unit = l_1_1
  l_1_0._cue = nil
end

DramaExt.name = function(l_2_0)
  return l_2_0.character_name
end

DramaExt.play_cue = function(l_3_0, l_3_1)
  l_3_0._cue = managers.drama:cue(l_3_1)
  if not l_3_0._cue then
    Application:throw_exception("The drama script tries to access a cue id '" .. tostring(l_3_1) .. "' which doesn't seem to exist!")
  end
  local duration = l_3_0._cue.duration
  if duration == "sound" then
    duration = 0
    managers.dialog:pause_dialog()
  elseif duration == "animation" then
    duration = tweak_data.dialog.MINIMUM_DURATION
  end
  if l_3_0._cue.string_id then
    managers.subtitle:set_visible(true)
    managers.subtitle:set_enabled(true)
    if duration == 0 then
      managers.subtitle:show_subtitle(l_3_0._cue.string_id, 100000)
    else
      managers.subtitle:show_subtitle(l_3_0._cue.string_id, duration)
    end
  end
  if l_3_0._cue.sound then
    managers.hud:set_mugshot_talk(l_3_0._unit:unit_data().mugshot_id, true)
    local playing = l_3_0._unit:sound_source(l_3_0._cue.sound_source):post_event(l_3_0._cue.sound, l_3_0.sound_callback, l_3_0._unit, "marker", "end_of_event")
    if not playing then
      l_3_0:sound_callback(nil, "end_of_event", l_3_0._unit, l_3_0._cue.sound_source, nil, nil, nil)
      Application:error("[DramaExt:play_cue] Wasn't able to play sound event " .. l_3_0._cue.sound)
      Application:stack_dump()
    end
  end
  if l_3_0._cue.animation then
    return duration
  end
end

DramaExt.stop_cue = function(l_4_0, l_4_1)
  if l_4_0._cue then
    if l_4_0._cue.string_id then
      managers.subtitle:set_visible(false)
      managers.subtitle:set_enabled(false)
    end
    if l_4_0._cue.sound then
      l_4_0._unit:sound_source(l_4_0._cue.sound_source):stop()
    end
    l_4_0._cue = nil
  end
end

DramaExt.sound_callback = function(l_5_0, l_5_1, l_5_2, l_5_3, l_5_4, l_5_5, l_5_6, l_5_7)
  if l_5_2 == "end_of_event" then
    managers.subtitle:set_visible(false)
    managers.subtitle:set_enabled(false)
    managers.hud:set_mugshot_talk(l_5_3:unit_data().mugshot_id, false)
    managers.dialog:play_dialog()
  elseif l_5_2 == "marker" and l_5_4 then
    managers.subtitle:set_visible(true)
    managers.subtitle:set_enabled(true)
    managers.subtitle:show_subtitle(l_5_4, DramaExt._subtitle_len(DramaExt, l_5_4))
  end
end

DramaExt._subtitle_len = function(l_6_0, l_6_1)
  local text = managers.localization:text(l_6_1)
  local duration = text:len() * tweak_data.dialog.DURATION_PER_CHAR
  if duration < tweak_data.dialog.MINIMUM_DURATION then
    duration = tweak_data.dialog.MINIMUM_DURATION
  end
  return duration
end


