-- Decompiled using luadec 2.0.1 by sztupy (http://winmo.sztupy.hu)
-- Command line was: F:\SteamLibrary\SteamApps\common\PAYDAY 2\lua\core\lib\managers\subtitle\coresubtitlesequence.luac 

core:module("CoreSubtitleSequence")
core:import("CoreClass")
if not SubtitleSequence then
  SubtitleSequence = CoreClass.class()
end
if not Subtitle then
  Subtitle = CoreClass.class()
end
if not StringIDSubtitle then
  StringIDSubtitle = CoreClass.class(Subtitle)
end
SubtitleSequence.init = function(l_1_0, l_1_1)
  if l_1_1 then
    l_1_0:_load_from_xml(l_1_1)
  end
end

SubtitleSequence.name = function(l_2_0)
  return l_2_0:parameters().name or ""
end

SubtitleSequence.duration = function(l_3_0)
  if l_3_0.__subtitles then
    return l_3_0.__subtitles[#l_3_0.__subtitles]:end_time()
  end
end

SubtitleSequence.parameters = function(l_4_0)
  if not l_4_0.__parameters then
    return {}
  end
end

SubtitleSequence.subtitles = function(l_5_0)
  if not l_5_0.__subtitles then
    return {}
  end
end

SubtitleSequence.add_subtitle = function(l_6_0, l_6_1)
  if not l_6_0.__subtitles then
    l_6_0.__subtitles = {}
  end
  table.insert_sorted(l_6_0.__subtitles, l_6_1, function(l_1_0, l_1_1)
    return l_1_0:start_time() < l_1_1:start_time()
   end)
end

SubtitleSequence._load_from_xml = function(l_7_0, l_7_1)
  assert(managers.localization, "Localization Manager not ready.")
  assert(not l_7_1 or l_7_1:name() == "sequence", "Attempting to construct from non-sequence XML node.")
  assert(l_7_1:parameter("name"), "Sequence must have a name.")
  l_7_0.__parameters = l_7_1:parameter_map()
  l_7_0.__subtitles = {}
  for node in l_7_1:children() do
    local string_id = l_7_0:_xml_assert(node:parameter("text_id"), node, string.format("Sequence \"%s\" has entries without text_ids.", l_7_0:name()))
    if not managers.localization:exists(string_id) then
      l_7_0:_report_bad_string_id(string_id)
    end
    local start_time = l_7_0:_xml_assert(tonumber(node:parameter("time")), node, string.format("Sequence \"%s\" has entries without valid times.", l_7_0:name()))
    local subtitle = StringIDSubtitle:new(string_id, start_time, tonumber(node:parameter("duration") or 2))
    l_7_0:add_subtitle(CoreClass.freeze(subtitle))
  end
  CoreClass.freeze(l_7_0.__subtitles)
end

SubtitleSequence._report_bad_string_id = function(l_8_0, l_8_1)
  Localizer:lookup(l_8_1)
end

SubtitleSequence._xml_assert = function(l_9_0, l_9_1, l_9_2, l_9_3)
  if not l_9_1 then
    return error(string.format("Error parsing \"%s\" - %s", string.gsub(l_9_2:file(), "^.*[/\\]", ""), l_9_3))
  end
end

Subtitle.init = function(l_10_0, l_10_1, l_10_2, l_10_3)
  l_10_0.__string_data = l_10_1 ~= nil and assert(tostring(l_10_1), "Invalid string argument.") or ""
  l_10_0.__start_time = assert(tonumber(l_10_2), "Invalid start time argument.")
  l_10_0.__duration = l_10_3 ~= nil and assert(tonumber(l_10_3), "Invalid duration argument.") or nil
end

Subtitle.string = function(l_11_0)
  return l_11_0.__string_data
end

Subtitle.start_time = function(l_12_0)
  return l_12_0.__start_time
end

Subtitle.end_time = function(l_13_0)
  if not l_13_0:duration() then
    return l_13_0:start_time() + math.huge
  end
end

Subtitle.duration = function(l_14_0)
  return l_14_0.__duration
end

Subtitle.is_active_at_time = function(l_15_0, l_15_1)
  return l_15_0:start_time() < l_15_1 and l_15_1 < l_15_0:end_time()
end

StringIDSubtitle.string = function(l_16_0)
  assert(managers.localization, "Localization Manager not ready.")
  return managers.localization:text(l_16_0.__string_data)
end


