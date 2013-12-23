-- Decompiled using luadec 2.0.1 by sztupy (http://winmo.sztupy.hu)
-- Command line was: F:\SteamLibrary\SteamApps\common\PAYDAY 2\lua\core\lib\utils\dev\ews\color_picker\corecolorpickerpanel.luac 

core:module("CoreColorPickerPanel")
core:import("CoreClass")
core:import("CoreEvent")
core:import("CoreColorPickerDraggables")
core:import("CoreColorPickerFields")
if not ColorPickerPanel then
  ColorPickerPanel = CoreClass.mixin(CoreClass.class(), CoreEvent.BasicEventHandling)
end
ColorPickerPanel.init = function(l_1_0, l_1_1, l_1_2, l_1_3, l_1_4)
  assert(l_1_3 == "HORIZONTAL" or l_1_3 == "VERTICAL")
  l_1_0:_create_panel(l_1_1, l_1_2, l_1_3, l_1_4)
end

ColorPickerPanel.panel = function(l_2_0)
  return l_2_0._panel
end

ColorPickerPanel.color = function(l_3_0)
  return l_3_0._fields:color()
end

ColorPickerPanel.set_color = function(l_4_0, l_4_1)
  l_4_0._draggables:set_color(l_4_1)
  l_4_0._fields:set_color(l_4_1)
end

ColorPickerPanel.update = function(l_5_0, l_5_1, l_5_2)
  l_5_0._draggables:update(l_5_1, l_5_2)
  l_5_0._fields:update(l_5_1, l_5_2)
end

ColorPickerPanel._create_panel = function(l_6_0, l_6_1, l_6_2, l_6_3, l_6_4)
  l_6_0._panel = EWS:Panel(l_6_1)
  local panel_sizer = EWS:BoxSizer(l_6_3)
  l_6_0._panel:set_sizer(panel_sizer)
  l_6_0._draggables = CoreColorPickerDraggables.ColorPickerDraggables:new(l_6_0._panel, l_6_2, l_6_4)
  l_6_0._fields = CoreColorPickerFields.ColorPickerFields:new(l_6_0._panel, l_6_2, l_6_4)
  l_6_0._draggables:connect("EVT_COLOR_UPDATED", CoreEvent.callback(l_6_0, l_6_0, "_on_color_updated"), l_6_0._draggables)
  l_6_0._fields:connect("EVT_COLOR_UPDATED", CoreEvent.callback(l_6_0, l_6_0, "_on_color_updated"), l_6_0._fields)
  l_6_0._draggables:connect("EVT_COLOR_CHANGED", CoreEvent.callback(l_6_0, l_6_0, "_on_color_changed"), l_6_0._draggables)
  l_6_0._fields:connect("EVT_COLOR_CHANGED", CoreEvent.callback(l_6_0, l_6_0, "_on_color_changed"), l_6_0._fields)
  panel_sizer:add(l_6_0._draggables:panel(), 0, 0, "EXPAND")
  panel_sizer:add(l_6_0._fields:panel(), 1, 0, "EXPAND")
end

ColorPickerPanel._on_color_updated = function(l_7_0, l_7_1, l_7_2)
  table.exclude({l_7_0._draggables, l_7_0._fields}, l_7_1)[1]:set_color(l_7_2)
  l_7_0:_send_event("EVT_COLOR_UPDATED", l_7_2)
end

ColorPickerPanel._on_color_changed = function(l_8_0, l_8_1, l_8_2)
  l_8_0:_send_event("EVT_COLOR_CHANGED", l_8_2)
end


