-- Decompiled using luadec 2.0.1 by sztupy (http://winmo.sztupy.hu)
-- Command line was: F:\SteamLibrary\SteamApps\common\PAYDAY 2\lua\core\lib\managers\cutscene\keys\corevideocutscenekey.luac 

require("core/lib/managers/cutscene/keys/CoreCutsceneKeyBase")
if not CoreVideoCutsceneKey then
  CoreVideoCutsceneKey = class(CoreCutsceneKeyBase)
end
CoreVideoCutsceneKey.ELEMENT_NAME = "video"
CoreVideoCutsceneKey.NAME = "Video Playback"
CoreVideoCutsceneKey:register_serialized_attribute("video", "")
CoreVideoCutsceneKey:register_serialized_attribute("gui_layer", 2, tonumber)
CoreVideoCutsceneKey:register_serialized_attribute("loop", 0, tonumber)
CoreVideoCutsceneKey:register_serialized_attribute("speed", 1, tonumber)
CoreVideoCutsceneKey.__tostring = function(l_1_0)
  return string.format("Play video \"%s\".", l_1_0:video())
end

CoreVideoCutsceneKey.can_evaluate_with_player = function(l_2_0, l_2_1)
  return true
end

CoreVideoCutsceneKey.play = function(l_3_0, l_3_1, l_3_2, l_3_3)
  local video_ws = managers.cutscene:video_workspace()
  local was_paused = l_3_0._paused
  l_3_0._paused = false
  if l_3_2 then
    l_3_0:_stop()
  else
    if alive(l_3_0._video_object) then
      if was_paused then
        l_3_0:_play_video(video_ws)
      end
      if l_3_0:loop() < l_3_0._video_object:loop_count() then
        l_3_0:_stop()
        managers.cutscene:_cleanup(true)
        managers.overlay_effect:play_effect(tweak_data.player.overlay.cutscene_fade_out)
      else
        if l_3_0:video() ~= "" then
          l_3_0:_play_video(video_ws)
        end
      end
    end
    return true
  end
end

CoreVideoCutsceneKey.unload = function(l_4_0, l_4_1)
  l_4_0:_stop()
end

CoreVideoCutsceneKey.update = function(l_5_0, l_5_1, l_5_2)
  if l_5_0.is_in_cutscene_editor then
    l_5_0:_handle_cutscene_editor_scrubbing(l_5_2)
  end
end

CoreVideoCutsceneKey.is_valid_video = function(l_6_0, l_6_1)
  return ((l_6_1 == nil or l_6_1 == "" or SystemFS:exists(l_6_1)) and not SystemFS:is_dir(l_6_1))
  do return end
  return l_6_1 ~= nil and l_6_1 ~= ""
end

CoreVideoCutsceneKey.on_attribute_changed = function(l_7_0, l_7_1, l_7_2, l_7_3)
  l_7_0:_stop()
end

CoreVideoCutsceneKey._handle_cutscene_editor_scrubbing = function(l_8_0, l_8_1)
  if l_8_1 == l_8_0._last_evaluated_time then
    if not l_8_0._stopped_frame_count then
      l_8_0._stopped_frame_count = (not l_8_0._last_evaluated_time or 0) + 1
      if l_8_0._stopped_frame_count > 5 then
        l_8_0._stopped_frame_count = nil
        l_8_0:pause()
      else
        l_8_0._stopped_frame_count = nil
        if alive(l_8_0._video_object) and (l_8_1 < l_8_0._last_evaluated_time or l_8_1 - l_8_0._last_evaluated_time > 1) then
          l_8_0._video_object:goto_time(l_8_1)
        end
        l_8_0:resume()
      end
    end
    l_8_0._last_evaluated_time = l_8_1
     -- Warning: missing end command somewhere! Added here
  end
end

CoreVideoCutsceneKey._play_video = function(l_9_0, l_9_1)
  if not alive(l_9_0._video_object) or l_9_0:video() ~= l_9_0._video_played or l_9_0:loop() ~= l_9_0._loop_played or l_9_0:speed() ~= l_9_0._speed_played then
    l_9_1:panel():clear()
    l_9_1:show()
    l_9_1:panel():rect({width = l_9_1:width(), height = l_9_1:height(), color = Color.black})
    l_9_0._video_object = l_9_1:panel():video({video = l_9_0:video(), loop = l_9_0:loop() > 0, speed = l_9_0:speed(), layer = l_9_0:gui_layer()})
    l_9_0._video_played = l_9_0:video()
    l_9_0._loop_played = l_9_0:loop()
    l_9_0._speed_played = l_9_0:speed()
    local width, height = get_fit_size(l_9_0._video_object:video_width(), l_9_0._video_object:video_height(), l_9_1:width(), l_9_1:height())
    l_9_0._video_object:set_size(width, height)
    l_9_0._video_object:set_center(l_9_1:width() / 2, l_9_1:height() / 2)
    l_9_0._video_object:set_volume_gain(Global.video_sound_volume or 1)
  end
  l_9_0._video_object:play()
end

CoreVideoCutsceneKey._stop = function(l_10_0)
  if alive(l_10_0._video_object) then
    local video_ws = managers.cutscene:video_workspace()
    video_ws:panel():clear()
    video_ws:hide()
    l_10_0._video_object = nil
  end
  l_10_0._last_evaluated_time = nil
end

CoreVideoCutsceneKey.pause = function(l_11_0)
  if not l_11_0._paused and alive(l_11_0._video_object) then
    l_11_0._video_object:pause()
    l_11_0._paused = true
  end
end

CoreVideoCutsceneKey.resume = function(l_12_0)
  if l_12_0._paused and alive(l_12_0._video_object) then
    l_12_0._video_object:play()
    l_12_0._paused = false
  end
end


