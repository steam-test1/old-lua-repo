-- Decompiled using luadec 2.0.1 by sztupy (http://winmo.sztupy.hu)
-- Command line was: F:\SteamLibrary\SteamApps\common\PAYDAY 2\lua\core\lib\managers\subtitle\coresubtitlesequenceplayer.luac 

core:module("CoreSubtitleSequencePlayer")
core:import("CoreClass")
if not SubtitleSequencePlayer then
  SubtitleSequencePlayer = CoreClass.class()
end
SubtitleSequencePlayer.init = function(l_1_0, l_1_1, l_1_2)
  assert(l_1_1, "Invalid sequence.")
  assert(l_1_2, "Invalid presenter.")
  l_1_0.__presenter = l_1_2
  l_1_0.__sequence = l_1_0.__presenter:preprocess_sequence(l_1_1)
end

SubtitleSequencePlayer.is_done = function(l_2_0)
  return l_2_0.__sequence:duration() <= l_2_0.__time or 0
end

SubtitleSequencePlayer.update = function(l_3_0, l_3_1, l_3_2)
  l_3_0.__time = (l_3_0.__time or 0) + l_3_2
  l_3_0:evaluate_at_time(l_3_0.__time)
end

SubtitleSequencePlayer.evaluate_at_time = function(l_4_0, l_4_1)
  if l_4_1 ~= l_4_0._last_evaluated_time then
    local subtitle = table.inject((l_4_0.__sequence:subtitles()), nil, function(l_1_0, l_1_1)
    return l_1_1:is_active_at_time(time) and l_1_1 or l_1_0
   end)
    if (not subtitle or subtitle) and subtitle then
      l_4_0.__presenter:show_text(subtitle == l_4_0.__previous_subtitle or "", subtitle:duration())
    end
    l_4_0.__previous_subtitle = subtitle
    l_4_0._last_evaluated_time = l_4_1
  end
end


