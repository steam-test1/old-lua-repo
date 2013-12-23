-- Decompiled using luadec 2.0.1 by sztupy (http://winmo.sztupy.hu)
-- Command line was: F:\SteamLibrary\SteamApps\common\PAYDAY 2\lua\core\lib\utils\dev\ews\color_picker\corecolorpickerdraggables.luac 

core:module("CoreColorPickerDraggables")
core:import("CoreClass")
core:import("CoreEvent")
core:import("CoreMath")
if not ColorPickerDraggables then
  ColorPickerDraggables = CoreClass.mixin(CoreClass.class(), CoreEvent.BasicEventHandling)
end
ColorPickerDraggables.init = function(l_1_0, l_1_1, l_1_2, l_1_3)
  l_1_0:_create_panel(l_1_1, l_1_2, l_1_3)
  l_1_0:set_color(Color.white)
end

ColorPickerDraggables.update = function(l_2_0, l_2_1, l_2_2)
  local current_mouse_event = EWS:MouseEvent("EVT_MOTION")
  l_2_0._previous_mouse_event = l_2_0._previous_mouse_event or current_mouse_event
  if l_2_0._dragged_control and current_mouse_event:get_position() ~= l_2_0._previous_mouse_event:get_position() then
    l_2_0:_on_dragging(l_2_0._dragged_control, current_mouse_event)
  end
  if l_2_0._dragged_control and current_mouse_event:left_is_down() == false and l_2_0._previous_mouse_event:left_is_down() == true then
    l_2_0:_on_drag_stop(l_2_0._dragged_control, current_mouse_event)
  end
  l_2_0._previous_mouse_event = current_mouse_event
end

ColorPickerDraggables.panel = function(l_3_0)
  return l_3_0._panel
end

ColorPickerDraggables.color = function(l_4_0)
  if not l_4_0._alpha_slider and not l_4_0._value_slider then
    return l_4_0._spectrum:color()
  end
end

ColorPickerDraggables.set_color = function(l_5_0, l_5_1)
  hue, saturation, value = CoreMath.rgb_to_hsv(l_5_1.red, l_5_1.green, l_5_1.blue), l_5_1.red, l_5_1.green
  l_5_0._spectrum:set_hue(hue)
  l_5_0._spectrum:set_saturation(saturation)
  l_5_0._spectrum:set_value(value)
  if l_5_0._value_slider then
    l_5_0._value_slider:set_value(value)
  end
  if l_5_0._alpha_slider then
    l_5_0._alpha_slider:set_value(l_5_1.alpha)
  end
  l_5_0:_update_ui_except(l_5_0._spectrum)
end

ColorPickerDraggables._create_panel = function(l_6_0, l_6_1, l_6_2, l_6_3)
  l_6_0 = l_6_2 == nil and (l_6_0)
  l_6_2 = true
  l_6_0 = l_6_3 == nil and (l_6_0)
  l_6_3 = true
  l_6_0._panel = EWS:Panel(l_6_1)
  l_6_0._panel:set_min_size(Vector3(180, 134, 0))
  local panel_sizer = EWS:BoxSizer("HORIZONTAL")
  l_6_0._panel:set_sizer(panel_sizer)
  local slider_width = 20
  local slider_margin = 3
  l_6_0._spectrum = EWS:ColorSpectrum(l_6_0._panel, "")
  panel_sizer:add(l_6_0._spectrum, 0, slider_margin, "ALL")
  l_6_0._spectrum:connect("EVT_LEFT_DOWN", CoreEvent.callback(l_6_0, l_6_0, "_on_drag_start"), l_6_0._spectrum)
  local spectrum_size = l_6_0._spectrum:get_min_size()
  if l_6_3 then
    l_6_0._value_slider = EWS:ColorSlider(l_6_0._panel, "")
    panel_sizer:add(l_6_0._value_slider, 0, 0, "EXPAND")
    l_6_0._value_slider:connect("EVT_LEFT_DOWN", CoreEvent.callback(l_6_0, l_6_0, "_on_drag_start"), l_6_0._value_slider)
  else
    spectrum_size = spectrum_size:with_x(spectrum_size.x + slider_width + slider_margin)
  end
  if l_6_2 then
    l_6_0._alpha_slider = EWS:ColorSlider(l_6_0._panel, "")
    panel_sizer:add(l_6_0._alpha_slider, 0, slider_margin, "LEFT,RIGHT,EXPAND")
    l_6_0._alpha_slider:connect("EVT_LEFT_DOWN", CoreEvent.callback(l_6_0, l_6_0, "_on_drag_start"), l_6_0._alpha_slider)
  else
    spectrum_size = spectrum_size:with_x(spectrum_size.x + slider_width + slider_margin)
  end
  l_6_0._spectrum:set_min_size(spectrum_size)
end

ColorPickerDraggables._update_ui_except = function(l_7_0, l_7_1)
  if l_7_0._value_slider ~= nil then
    if l_7_1 ~= l_7_0._spectrum then
      l_7_0._spectrum:set_value(l_7_0._value_slider:value())
    end
    if l_7_1 ~= l_7_0._value_slider then
      l_7_0._value_slider:set_top_color(l_7_0._spectrum:unscaled_color())
    end
  end
  if l_7_1 ~= l_7_0._alpha_slider and l_7_0._alpha_slider ~= nil then
    if not l_7_0._value_slider then
      local opaque_color = l_7_0._spectrum:color()
      l_7_0._alpha_slider:set_top_color(opaque_color)
      l_7_0._alpha_slider:set_bottom_color(opaque_color:with_alpha(0))
    end
     -- Warning: missing end command somewhere! Added here
  end
end

ColorPickerDraggables._process_color_update_event = function(l_8_0, l_8_1, l_8_2)
  local event_position_in_sender = l_8_2:get_position(l_8_1)
  if l_8_1 == l_8_0._spectrum then
    l_8_1:set_hue(l_8_1:point_to_hue(event_position_in_sender))
    l_8_1:set_saturation(l_8_1:point_to_saturation(event_position_in_sender))
  else
    l_8_1:set_value(l_8_1:point_to_value(event_position_in_sender))
  end
  l_8_0:_update_ui_except(l_8_1)
  l_8_0:_send_event("EVT_COLOR_UPDATED", l_8_0:color())
end

ColorPickerDraggables._process_color_change_event = function(l_9_0, l_9_1, l_9_2)
  l_9_0:_process_color_update_event(l_9_1, l_9_2)
  l_9_0:_send_event("EVT_COLOR_CHANGED", l_9_0:color())
end

ColorPickerDraggables._on_drag_start = function(l_10_0, l_10_1, l_10_2)
  l_10_0._previous_mouse_event = EWS:MouseEvent("EVT_LEFT_DOWN")
  l_10_0._dragged_control = l_10_1
  l_10_0:_process_color_update_event(l_10_1, l_10_2)
end

ColorPickerDraggables._on_dragging = function(l_11_0, l_11_1, l_11_2)
  l_11_0:_process_color_update_event(l_11_1, l_11_2)
end

ColorPickerDraggables._on_drag_stop = function(l_12_0, l_12_1, l_12_2)
  l_12_0:_process_color_change_event(l_12_1, l_12_2)
  l_12_0._dragged_control = nil
end


