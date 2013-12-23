-- Decompiled using luadec 2.0.1 by sztupy (http://winmo.sztupy.hu)
-- Command line was: F:\SteamLibrary\SteamApps\common\PAYDAY 2\lua\core\lib\managers\subtitle\coresubtitlepresenter.luac 

core:module("CoreSubtitlePresenter")
core:import("CoreClass")
core:import("CoreCode")
core:import("CoreEvent")
core:import("CoreDebug")
core:import("CoreSubtitleSequence")
if not SubtitlePresenter then
  SubtitlePresenter = CoreClass.class()
end
if not DebugPresenter then
  DebugPresenter = CoreClass.class(SubtitlePresenter)
end
if not OverlayPresenter then
  OverlayPresenter = CoreClass.class(SubtitlePresenter)
end
SubtitlePresenter.destroy = function(l_1_0)
end

SubtitlePresenter.update = function(l_2_0, l_2_1, l_2_2)
end

SubtitlePresenter.show = function(l_3_0)
end

SubtitlePresenter.hide = function(l_4_0)
end

SubtitlePresenter.show_text = function(l_5_0, l_5_1, l_5_2)
end

SubtitlePresenter.preprocess_sequence = function(l_6_0, l_6_1)
  return l_6_1
end

DebugPresenter.destroy = function(l_7_0)
  CoreDebug.cat_print("subtitle_manager", string.format("SubtitlePresenter is destroyed."))
end

DebugPresenter.show = function(l_8_0)
  CoreDebug.cat_print("subtitle_manager", string.format("SubtitlePresenter is shown."))
end

DebugPresenter.hide = function(l_9_0)
  CoreDebug.cat_print("subtitle_manager", string.format("SubtitlePresenter hides."))
end

DebugPresenter.show_text = function(l_10_0, l_10_1, l_10_2)
  CoreDebug.cat_print("subtitle_manager", string.format("SubtitlePresenter displays \"%s\" %s.", l_10_1, l_10_2 and string.format("for %g seconds", l_10_2) or "until further notice"))
end

OverlayPresenter.init = function(l_11_0, l_11_1, l_11_2)
  if l_11_1 or not l_11_2 then
    l_11_0:set_font(l_11_0:_default_font_name(), l_11_0:_default_font_size())
  end
  l_11_0:_clear_workspace()
  l_11_0.__resolution_changed_id = managers.viewport:add_resolution_changed_func(CoreEvent.callback(l_11_0, l_11_0, "_on_resolution_changed"))
end

OverlayPresenter.destroy = function(l_12_0)
  if l_12_0.__resolution_changed_id and managers.viewport then
    managers.viewport:remove_resolution_changed_func(l_12_0.__resolution_changed_id)
  end
  l_12_0.__resolution_changed_id = nil
  if CoreCode.alive(l_12_0.__subtitle_panel) then
    l_12_0.__subtitle_panel:stop()
    l_12_0.__subtitle_panel:clear()
  end
  l_12_0.__subtitle_panel = nil
  if CoreCode.alive(l_12_0.__ws) then
    l_12_0.__ws:gui():destroy_workspace(l_12_0.__ws)
  end
  l_12_0.__ws = nil
end

OverlayPresenter.show = function(l_13_0)
  l_13_0.__ws:show()
end

OverlayPresenter.hide = function(l_14_0)
  l_14_0.__ws:hide()
end

OverlayPresenter.set_debug = function(l_15_0, l_15_1)
  if l_15_0.__ws then
    l_15_0.__ws:panel():set_debug(l_15_1)
  end
end

OverlayPresenter.set_font = function(l_16_0, l_16_1, l_16_2)
  l_16_0.__font_name = assert(tostring(l_16_1), "Invalid font name parameter.")
  l_16_0.__font_size = assert(tonumber(l_16_2), "Invalid font size parameter.")
  if l_16_0.__subtitle_panel then
    for _,ui_element_name in ipairs({"layout", "label", "shadow"}) do
      local ui_element = l_16_0.__subtitle_panel:child(ui_element_name)
      if ui_element then
        ui_element:set_font(Idstring(l_16_0.__font_name))
        ui_element:set_font_size(l_16_0.__font_size)
      end
    end
  end
  if CoreCode.alive(l_16_0.__ws) then
    local string_width_measure_text_field = l_16_0.__ws:panel():child("string_width")
  end
  if string_width_measure_text_field then
    string_width_measure_text_field:set_font(Idstring(l_16_0.__font_name))
    string_width_measure_text_field:set_font_size(l_16_0.__font_size)
  end
end

OverlayPresenter.set_width = function(l_17_0, l_17_1)
  local safe_width = l_17_0:_gui_width()
  l_17_0.__width = math.min(l_17_1, safe_width)
  if CoreCode.alive(l_17_0.__subtitle_panel) then
    l_17_0:_layout_text_field():set_width(l_17_0.__width)
  end
end

OverlayPresenter.show_text = function(l_18_0, l_18_1, l_18_2)
   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

  if not l_18_0.__subtitle_panel:child("label") then
    local label = l_18_0.__subtitle_panel:text({name = "label", x = 1, y = 1, font = l_18_0.__font_name, font_size = l_18_0.__font_size, color = Color.white})
  end
  {name = "label", x = 1, y = 1, font = l_18_0.__font_name, font_size = l_18_0.__font_size, color = Color.white}.word_wrap, {name = "label", x = 1, y = 1, font = l_18_0.__font_name, font_size = l_18_0.__font_size, color = Color.white}.wrap, {name = "label", x = 1, y = 1, font = l_18_0.__font_name, font_size = l_18_0.__font_size, color = Color.white}.layer, {name = "label", x = 1, y = 1, font = l_18_0.__font_name, font_size = l_18_0.__font_size, color = Color.white}.vertical, {name = "label", x = 1, y = 1, font = l_18_0.__font_name, font_size = l_18_0.__font_size, color = Color.white}.align = true, true, 1, "bottom", "center"
   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

  if not l_18_0.__subtitle_panel:child("shadow") then
    local shadow = l_18_0.__subtitle_panel:text({visible = false, name = "shadow", x = 2, y = 2, font = l_18_0.__font_name, font_size = l_18_0.__font_size, color = Color.black:with_alpha(0.5), align = "center"})
  end
  label:set_text(l_18_1)
  {visible = false, name = "shadow", x = 2, y = 2, font = l_18_0.__font_name, font_size = l_18_0.__font_size, color = Color.black:with_alpha(0.5), align = "center"}.word_wrap, {visible = false, name = "shadow", x = 2, y = 2, font = l_18_0.__font_name, font_size = l_18_0.__font_size, color = Color.black:with_alpha(0.5), align = "center"}.wrap, {visible = false, name = "shadow", x = 2, y = 2, font = l_18_0.__font_name, font_size = l_18_0.__font_size, color = Color.black:with_alpha(0.5), align = "center"}.layer, {visible = false, name = "shadow", x = 2, y = 2, font = l_18_0.__font_name, font_size = l_18_0.__font_size, color = Color.black:with_alpha(0.5), align = "center"}.vertical = true, true, 0, "bottom"
  shadow:set_text(l_18_1)
end

OverlayPresenter.preprocess_sequence = function(l_19_0, l_19_1)
  local new_sequence = CoreSubtitleSequence.SubtitleSequence:new()
  for _,subtitle in ipairs(l_19_1:subtitles()) do
    local subtitle_string = subtitle:string()
    local wrapped_lines = l_19_0:_split_string_into_lines(subtitle_string, l_19_1)
    local lines_per_batch = 2
    local batch_count = math.max(math.ceil(#wrapped_lines / lines_per_batch), 1)
    local batch_duration = subtitle:duration() / batch_count
    local batch = 0
    for line = 1, batch_count * lines_per_batch, 2 do
      local wrapped_string = table.concat({wrapped_lines[line], wrapped_lines[line + 1]}, "\n")
      new_sequence:add_subtitle(CoreSubtitleSequence.Subtitle:new(wrapped_string, subtitle:start_time() + batch_duration * batch, batch_duration))
      batch = batch + 1
    end
  end
  return new_sequence
end

OverlayPresenter._clear_workspace = function(l_20_0)
  if CoreCode.alive(l_20_0.__ws) then
    Overlay:gui():destroy_workspace(l_20_0.__ws)
  end
  l_20_0.__ws = managers.gui_data:create_saferect_workspace()
  l_20_0.__subtitle_panel = l_20_0.__ws:panel():panel({layer = 150})
  l_20_0:_on_resolution_changed()
end

OverlayPresenter._split_string_into_lines = function(l_21_0, l_21_1, l_21_2)
  return l_21_0:_auto_word_wrap_string(l_21_1)
end

OverlayPresenter._auto_word_wrap_string = function(l_22_0, l_22_1)
  local layout_text_field = l_22_0:_layout_text_field()
  layout_text_field:set_text(l_22_1)
  local line_breaks = table.collect(layout_text_field:line_breaks(), function(l_1_0)
    return l_1_0 + 1
   end)
  local wrapped_lines = {}
  for line = 1, #line_breaks do
    local range_start = line_breaks[line]
    local range_end = line_breaks[line + 1]
    local string_range = utf8.sub(l_22_1, range_start, (range_end or 0) - 1)
    table.insert(wrapped_lines, string.trim(string_range))
  end
  return wrapped_lines
end

OverlayPresenter._layout_text_field = function(l_23_0)
  assert(l_23_0.__subtitle_panel)
   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

  if not l_23_0.__subtitle_panel:child("layout") then
    return l_23_0.__subtitle_panel:text({name = "layout", width = l_23_0.__width})
    {name = "layout", width = l_23_0.__width}.word_wrap, {name = "layout", width = l_23_0.__width}.wrap, {name = "layout", width = l_23_0.__width}.vertical, {name = "layout", width = l_23_0.__width}.align, {name = "layout", width = l_23_0.__width}.font_size, {name = "layout", width = l_23_0.__width}.font, {name = "layout", width = l_23_0.__width}.visible = true, true, "bottom", "center", l_23_0.__font_size, l_23_0.__font_name, false
  end
end

OverlayPresenter._string_width = function(l_24_0, l_24_1)
  if not l_24_0.__ws:panel():child("string_width") then
    local string_width_measure_text_field = l_24_0.__ws:panel():text({name = "string_width", visible = false, font = l_24_0.__font_name, font_size = l_24_0.__font_size, wrap = false})
  end
  string_width_measure_text_field:set_text(l_24_1)
  local x, y, width, height = string_width_measure_text_field:text_rect()
  return width
end

OverlayPresenter._on_resolution_changed = function(l_25_0)
  if l_25_0.__font_name or not l_25_0.__font_size then
    l_25_0:set_font(l_25_0:_default_font_name(), l_25_0:_default_font_size())
  end
  local width = l_25_0:_gui_width()
  local height = l_25_0:_gui_height()
  local safe_rect = managers.gui_data:corner_scaled_size()
  managers.gui_data:layout_corner_saferect_workspace(l_25_0.__ws)
  l_25_0.__subtitle_panel:set_width(safe_rect.width)
  l_25_0.__subtitle_panel:set_height(safe_rect.height - 120)
  l_25_0.__subtitle_panel:set_x(0)
  l_25_0.__subtitle_panel:set_y(0)
  l_25_0:set_width(l_25_0:_string_width("The quick brown fox jumped over the lazy dog bla bla bla bla bla bla bla bla bla blah blah blah blah blah ."))
  local label = l_25_0.__subtitle_panel:child("label")
  if label then
    label:set_h(l_25_0.__subtitle_panel:h())
    label:set_w(l_25_0.__subtitle_panel:w())
  end
  local shadow = l_25_0.__subtitle_panel:child("shadow")
  if shadow then
    shadow:set_h(l_25_0.__subtitle_panel:h())
    shadow:set_w(l_25_0.__subtitle_panel:w())
  end
end

OverlayPresenter._gui_width = function(l_26_0)
  return l_26_0.__subtitle_panel:width()
end

OverlayPresenter._gui_height = function(l_27_0)
  return l_27_0.__subtitle_panel:width()
end

OverlayPresenter._default_font_name = function(l_28_0)
  return "core/fonts/system_font"
end

OverlayPresenter._default_font_size = function(l_29_0)
  return 22
end


