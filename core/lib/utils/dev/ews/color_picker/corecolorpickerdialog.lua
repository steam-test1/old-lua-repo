-- Decompiled using luadec 2.0.1 by sztupy (http://winmo.sztupy.hu)
-- Command line was: F:\SteamLibrary\SteamApps\common\PAYDAY 2\lua\core\lib\utils\dev\ews\color_picker\corecolorpickerdialog.luac 

core:module("CoreColorPickerDialog")
core:import("CoreClass")
core:import("CoreEvent")
core:import("CoreEws")
core:import("CoreColorPickerPanel")
if not ColorPickerDialog then
  ColorPickerDialog = CoreClass.mixin(CoreClass.class(), CoreEvent.BasicEventHandling)
end
ColorPickerDialog.EDITOR_TITLE = "Color Picker"
ColorPickerDialog.init = function(l_1_0, l_1_1, l_1_2, l_1_3, l_1_4)
  if not l_1_3 then
    l_1_3 = "HORIZONTAL"
  end
  assert(l_1_3 == "HORIZONTAL" or l_1_3 == "VERTICAL", "Invalid orientation.")
  if l_1_3 ~= "HORIZONTAL" or not Vector3(366, 166) then
    local frame_size = Vector3(186, 300, 0)
  end
  l_1_0._window = EWS:Frame(ColorPickerDialog.EDITOR_TITLE, Vector3(-1, -1, 0), frame_size, "SYSTEM_MENU,CAPTION,CLOSE_BOX,CLIP_CHILDREN", l_1_1)
  local sizer = EWS:BoxSizer("HORIZONTAL")
  l_1_0._window:set_sizer(sizer)
  l_1_0._window:set_icon(CoreEws.image_path("toolbar/color_16x16.png"))
  l_1_0._window:connect("", "EVT_CLOSE_WINDOW", CoreEvent.callback(l_1_0, l_1_0, "_on_close"), "")
  l_1_0._picker_panel = CoreColorPickerPanel.ColorPickerPanel:new(l_1_0._window, l_1_2, l_1_3, l_1_4)
  l_1_0._picker_panel:connect("EVT_COLOR_UPDATED", CoreEvent.callback(l_1_0, l_1_0, "_on_color_updated"), l_1_0._picker_panel)
  l_1_0._picker_panel:connect("EVT_COLOR_CHANGED", CoreEvent.callback(l_1_0, l_1_0, "_on_color_changed"), l_1_0._picker_panel)
  sizer:add(l_1_0._picker_panel:panel(), 0, 0, "EXPAND")
  l_1_0:set_visible(true)
end

ColorPickerDialog.update = function(l_2_0, l_2_1, l_2_2)
  l_2_0._picker_panel:update(l_2_1, l_2_2)
end

ColorPickerDialog.color = function(l_3_0)
  return l_3_0._picker_panel:color()
end

ColorPickerDialog.set_color = function(l_4_0, l_4_1)
  l_4_0._picker_panel:set_color(l_4_1)
end

ColorPickerDialog.set_position = function(l_5_0, l_5_1)
  l_5_0._window:set_position(l_5_1)
end

ColorPickerDialog.set_visible = function(l_6_0, l_6_1)
  l_6_0._window:set_visible(l_6_1)
end

ColorPickerDialog.center = function(l_7_0, l_7_1)
  l_7_0._window:set_position(l_7_1:get_position() + l_7_1:get_size() * 0.5 - l_7_0._window:get_size() * 0.5)
end

ColorPickerDialog.close = function(l_8_0)
  l_8_0._window:destroy()
end

ColorPickerDialog._on_color_updated = function(l_9_0, l_9_1, l_9_2)
  l_9_0:_send_event("EVT_COLOR_UPDATED", l_9_2)
end

ColorPickerDialog._on_color_changed = function(l_10_0, l_10_1, l_10_2)
  l_10_0:_send_event("EVT_COLOR_CHANGED", l_10_2)
end

ColorPickerDialog._on_close = function(l_11_0)
  l_11_0._window:set_visible(false)
  l_11_0:_send_event("EVT_CLOSE_WINDOW", l_11_0._window)
  managers.toolhub:close(ColorPickerDialog.EDITOR_TITLE)
end


