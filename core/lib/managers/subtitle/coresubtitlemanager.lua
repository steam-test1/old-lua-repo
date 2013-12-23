-- Decompiled using luadec 2.0.1 by sztupy (http://winmo.sztupy.hu)
-- Command line was: F:\SteamLibrary\SteamApps\common\PAYDAY 2\lua\core\lib\managers\subtitle\coresubtitlemanager.luac 

core:module("CoreSubtitleManager")
core:import("CoreClass")
core:import("CoreDebug")
core:import("CoreTable")
core:import("CoreSubtitlePresenter")
core:import("CoreSubtitleSequence")
core:import("CoreSubtitleSequencePlayer")
if not SubtitleManager then
  SubtitleManager = CoreClass.class()
end
SubtitleManager.init = function(l_1_0)
  l_1_0.__subtitle_sequences = {}
  l_1_0.__loaded_sequence_file_paths = {}
  l_1_0.__presenter = CoreSubtitlePresenter.DebugPresenter:new()
  l_1_0:_update_presenter_visibility()
end

SubtitleManager.destroy = function(l_2_0)
  l_2_0:set_presenter(nil)
end

SubtitleManager.presenter = function(l_3_0)
  return assert(l_3_0.__presenter, "Invalid presenter. SubtitleManager might have been destroyed.")
end

SubtitleManager.set_presenter = function(l_4_0, l_4_1)
  assert(l_4_1 == nil or type(l_4_1.preprocess_sequence) == "function", "Invalid presenter.")
  if l_4_0.__presenter then
    l_4_0.__presenter:destroy()
  end
  l_4_0.__presenter = l_4_1
  if l_4_0.__presenter then
    l_4_0:_update_presenter_visibility()
  end
end

SubtitleManager.load_sequences = function(l_5_0, l_5_1)
  local root_node = DB:load_node("subtitle_sequence", l_5_1)
  assert(root_node:name() == "subtitle_sequence", "File is not a subtitle sequence file.")
  l_5_0.__loaded_sequence_file_paths[l_5_1] = true
  for sequence_node in root_node:children() do
    if sequence_node:name() == "sequence" then
      local sequence = CoreSubtitleSequence.SubtitleSequence:new(sequence_node)
      l_5_0.__subtitle_sequences[sequence:name()] = sequence
    end
  end
end

SubtitleManager.reload_sequences = function(l_6_0)
  l_6_0.__subtitle_sequences = {}
  for sequence_file_path,_ in pairs(l_6_0.__loaded_sequence_file_paths) do
    l_6_0:load_sequences(sequence_file_path)
  end
end

SubtitleManager.update = function(l_7_0, l_7_1, l_7_2)
  if l_7_0.__player then
    l_7_0.__player:update(l_7_1, l_7_2)
    if l_7_0.__player:is_done() then
      l_7_0.__player = nil
    end
  end
  l_7_0:presenter():update(l_7_1, l_7_2)
end

SubtitleManager.enabled = function(l_8_0)
  return Global.__SubtitleManager__enabled or false
end

SubtitleManager.set_enabled = function(l_9_0, l_9_1)
  Global.__SubtitleManager__enabled = not not l_9_1
  l_9_0:_update_presenter_visibility()
end

SubtitleManager.visible = function(l_10_0)
  return not l_10_0.__hidden
end

SubtitleManager.set_visible = function(l_11_0, l_11_1)
  l_11_0.__hidden = (l_11_1 and nil)
  l_11_0:_update_presenter_visibility()
end

SubtitleManager.clear_subtitle = function(l_12_0)
  l_12_0:show_subtitle_localized("")
end

SubtitleManager.is_showing_subtitles = function(l_13_0)
  return not l_13_0:enabled() or not l_13_0:visible() or l_13_0.__player ~= nil
end

SubtitleManager.show_subtitle = function(l_14_0, l_14_1, l_14_2, l_14_3)
  l_14_0:show_subtitle_localized(managers.localization:text(l_14_1, l_14_3), l_14_2)
end

SubtitleManager.show_subtitle_localized = function(l_15_0, l_15_1, l_15_2)
  local sequence = CoreSubtitleSequence.SubtitleSequence:new()
  sequence:add_subtitle(CoreSubtitleSequence.Subtitle:new(l_15_1, 0, l_15_2 or 3))
  l_15_0.__player = CoreSubtitleSequencePlayer.SubtitleSequencePlayer:new(sequence, l_15_0:presenter())
end

SubtitleManager.run_subtitle_sequence = function(l_16_0, l_16_1)
  if l_16_1 then
    local sequence = assert(l_16_0.__subtitle_sequences[l_16_1], string.format("Sequence \"%s\" not found.", l_16_1))
  end
  if sequence then
    l_16_0.__player = CoreSubtitleSequencePlayer.SubtitleSequencePlayer:new(sequence, l_16_0:presenter())
  end
end

SubtitleManager.subtitle_sequence_ids = function(l_17_0)
  if not l_17_0.__subtitle_sequences then
    return CoreTable.table.map_keys({})
     -- Warning: missing end command somewhere! Added here
  end
end

SubtitleManager.has_subtitle_sequence = function(l_18_0, l_18_1)
  return l_18_0.__subtitle_sequences and l_18_0.__subtitle_sequences[l_18_1] ~= nil
end

SubtitleManager._update_presenter_visibility = function(l_19_0)
  local presenter = l_19_0:presenter()
  local show_presenter = l_19_0:enabled() and ((managers.user and managers.user:get_setting("subtitle")))
  presenter[show_presenter and "show" or "hide"](presenter)
end


