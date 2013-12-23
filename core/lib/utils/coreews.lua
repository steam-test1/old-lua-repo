-- Decompiled using luadec 2.0.1 by sztupy (http://winmo.sztupy.hu)
-- Command line was: F:\SteamLibrary\SteamApps\common\PAYDAY 2\lua\core\lib\utils\coreews.luac 

core:module("CoreEws")
core:import("CoreClass")
core:import("CoreApp")
verify_number = function(l_1_0, l_1_1)
  if EWS:name_to_key_code("K_BACK") ~= l_1_1:key_code() and ((l_1_1:key_code() >= 48 and l_1_1:key_code() <= 57) or EWS:name_to_key_code("K_DELETE") == l_1_1:key_code()) then
    if l_1_1:key_code() == 46 then
      local s = l_1_0:get_value() .. "."
      if not tonumber(s) then
        return 
      end
    end
    l_1_1:skip()
  end
end

image_path = function(l_2_0)
  if not l_2_0 then
    l_2_0 = ""
  end
  if not CoreApp.arg_value("-assetslocation") then
    local base_path = Application:base_path() .. (managers.database and managers.database:base_path() or "../../") .. "assets\\"
    do
      local path = base_path .. "lib\\utils\\dev\\ews\\images\\"
      if l_2_0 ~= "" and EWS and not EWS:system_file_exists(path .. l_2_0) then
        path = base_path .. "core\\lib\\utils\\dev\\ews\\images\\"
      end
      return path .. l_2_0
    end
     -- Warning: missing end command somewhere! Added here
  end
end

if not EWSConfirmDialog then
  EWSConfirmDialog = CoreClass.class()
end
EWSConfirmDialog.init = function(l_3_0, l_3_1, l_3_2)
  l_3_0._yes = false
  l_3_0._no = false
  l_3_0._cancel = false
  l_3_0._dialog = EWS:Dialog(nil, l_3_1, "", Vector3(525, 400, 0), Vector3(250, 110, 0), "DEFAULT_DIALOG_STYLE")
  local dialog_sizer = EWS:BoxSizer("HORIZONTAL")
  l_3_0._dialog:set_sizer(dialog_sizer)
  local panel = EWS:Panel(l_3_0._dialog, "", "")
  local panel_sizer = EWS:BoxSizer("VERTICAL")
  panel:set_sizer(panel_sizer)
  local msg = EWS:StaticText(panel, l_3_2, "", "ALIGN_CENTRE")
  panel_sizer:add(msg, 0, 20, "EXPAND,TOP,BOTTOM")
  local button_sizer = EWS:BoxSizer("HORIZONTAL")
  local yes_btn = EWS:Button(panel, "Yes", "", "BU_BOTTOM")
  button_sizer:add(yes_btn, 0, 2, "RIGHT,LEFT")
  yes_btn:connect("EVT_COMMAND_BUTTON_CLICKED", callback(l_3_0, l_3_0, "set_value"), "_yes")
  local no_btn = EWS:Button(panel, "No", "", "")
  button_sizer:add(no_btn, 0, 2, "RIGHT,LEFT")
  no_btn:connect("EVT_COMMAND_BUTTON_CLICKED", callback(l_3_0, l_3_0, "set_value"), "_no")
  local cancel_btn = EWS:Button(panel, "Cancel", "", "")
  button_sizer:add(cancel_btn, 0, 2, "RIGHT,LEFT")
  cancel_btn:connect("EVT_COMMAND_BUTTON_CLICKED", callback(l_3_0, l_3_0, "set_value"), "_cancel")
  panel_sizer:add(button_sizer, 1, 0, "EXPAND")
  dialog_sizer:add(panel_sizer, 1, 0, "EXPAND")
  panel:fit()
end

EWSConfirmDialog.show_modal = function(l_4_0)
  l_4_0._dialog:show_modal()
  return true
end

EWSConfirmDialog.set_value = function(l_5_0, l_5_1)
  l_5_0[l_5_1] = true
  l_5_0._dialog:end_modal()
end

EWSConfirmDialog.yes = function(l_6_0)
  return l_6_0._yes
end

EWSConfirmDialog.no = function(l_7_0)
  return l_7_0._no
end

EWSConfirmDialog.cancel = function(l_8_0)
  return l_8_0._cancel
end

if not LocalizerTextCtrl then
  LocalizerTextCtrl = CoreClass.class()
end
LocalizerTextCtrl.init = function(l_9_0, l_9_1, l_9_2, l_9_3)
  l_9_0._text_ctrlr = EWS:TextCtrl(l_9_1, Localizer:lookup(l_9_3), "", "TE_CENTRE,TE_READONLY")
  l_9_2:add(l_9_0._text_ctrlr, 1, 0, "EXPAND")
end

LocalizerTextCtrl.get = function(l_10_0)
  return l_10_0._text_ctrlr
end

LocalizerTextCtrl.get_value = function(l_11_0)
  return l_11_0._text_ctrlr:get_value()
end

LocalizerTextCtrl.set_value = function(l_12_0, l_12_1)
  return l_12_0._text_ctrlr:set_value(Localizer:lookup(l_12_1))
end

if not EWSRadioBitmapButton then
  EWSRadioBitmapButton = CoreClass.class()
end
EWSRadioBitmapButton.init = function(l_13_0, l_13_1, l_13_2, l_13_3, l_13_4)
  l_13_0._on_bmp = l_13_2
  l_13_0._off_bmp = l_13_2
  l_13_0._button = EWS:BitmapButton(l_13_1, l_13_2, "", "")
  l_13_0._value = true
end

EWSRadioBitmapButton.button = function(l_14_0)
  return l_14_0._button
end

EWSRadioBitmapButton.set_on_bmp = function(l_15_0, l_15_1)
  l_15_0._on_bmp = l_15_1
end

EWSRadioBitmapButton.set_off_bmp = function(l_16_0, l_16_1)
  l_16_0._off_bmp = l_16_1
end

EWSRadioBitmapButton.set_value = function(l_17_0, l_17_1)
  l_17_0._value = l_17_1
  if l_17_1 then
    l_17_0._button:set_label_bitmap(l_17_0._on_bmp)
  else
    l_17_0._button:set_label_bitmap(l_17_0._off_bmp)
  end
end

EWSRadioBitmapButton.value = function(l_18_0)
  return l_18_0._value
end

if not EwsTextDialog then
  EwsTextDialog = CoreClass.class()
end
EwsTextDialog.init = function(l_19_0, l_19_1, l_19_2)
  if not l_19_2 then
    l_19_2 = "new"
  end
  l_19_0._dialog = EWS:Dialog(nil, l_19_1, "", Vector3(525, 400, 0), Vector3(230, 150, 0), "CAPTION,CLOSE_BOX")
  l_19_0._dialog:set_background_colour("LIGHT GREY")
  local dialog_main_sizer = EWS:StaticBoxSizer(l_19_0._dialog, "VERTICAL")
  l_19_0._dialog:set_sizer(dialog_main_sizer)
  l_19_0._text = EWS:TextCtrl(l_19_0._dialog, l_19_2, "", "TE_CENTRE")
  dialog_main_sizer:add(l_19_0._text, 0, 0, "EXPAND")
  local button_sizer = EWS:BoxSizer("HORIZONTAL")
  local ok_btn = EWS:Button(l_19_0._dialog, "Ok", "", "BU_EXACTFIT,NO_BORDER")
  button_sizer:add(ok_btn, 0, 0, "EXPAND")
  ok_btn:connect("EVT_COMMAND_BUTTON_CLICKED", callback(l_19_0, l_19_0, "close"), {dialog = l_19_0._dialog, cancel = false})
  local cancel_btn = EWS:Button(l_19_0._dialog, "Cancel", "", "BU_EXACTFIT,NO_BORDER")
  button_sizer:add(cancel_btn, 0, 0, "EXPAND")
  cancel_btn:connect("EVT_COMMAND_BUTTON_CLICKED", callback(l_19_0, l_19_0, "close"), {dialog = l_19_0._dialog, cancel = true})
  dialog_main_sizer:add(button_sizer, 0, 0, "ALIGN_RIGHT")
end

EwsTextDialog.close = function(l_20_0, l_20_1)
  l_20_1.dialog:end_modal()
  l_20_0._cancel_dialog = l_20_1.cancel
end

EwsTextDialog.cancel_dialog = function(l_21_0)
  return l_21_0._cancel_dialog
end

EwsTextDialog.dialog = function(l_22_0)
  return l_22_0._dialog
end

EwsTextDialog.text = function(l_23_0)
  return l_23_0._text
end

number_controller = function(l_24_0)
  l_24_0.value = l_24_0.value or 0
  l_24_0.name_proportions = l_24_0.name_proportions or 1
  l_24_0.ctrlr_proportions = l_24_0.ctrlr_proportions or 1
  l_24_0.floats = l_24_0.floats or 0
  l_24_0.ctrl_sizer = EWS:BoxSizer("HORIZONTAL")
  _ctrlr_tooltip(l_24_0)
  _name_ctrlr(l_24_0)
  _number_ctrlr(l_24_0)
  l_24_0.ctrl_sizer:add(l_24_0.number_ctrlr, l_24_0.ctrlr_proportions, 0, "EXPAND")
  l_24_0.sizer:add(l_24_0.ctrl_sizer, 0, 0, "EXPAND")
  _connect_events(l_24_0)
  return l_24_0.number_ctrlr, l_24_0.name_ctrlr, l_24_0
end

verify_entered_number = function(l_25_0)
  local value = tonumber(l_25_0.number_ctrlr:get_value()) or 0
  if (((not l_25_0.min or value >= l_25_0.min or not l_25_0.min) and not l_25_0.max) or l_25_0.max >= value or not l_25_0.max) then
    l_25_0.value = value
  end
  local floats = l_25_0.floats or 0
  l_25_0.number_ctrlr:change_value(string.format("%." .. floats .. "f", value))
  l_25_0.number_ctrlr:set_selection(-1, -1)
end

change_entered_number = function(l_26_0, l_26_1)
  local floats = l_26_0.floats or 0
  l_26_0.value = l_26_1
  l_26_0.number_ctrlr:change_value(string.format("%." .. floats .. "f", l_26_0.value))
end

change_slider_and_number_value = function(l_27_0, l_27_1)
  l_27_0.value = l_27_1
  l_27_0.slider_ctrlr:set_value(l_27_1 * l_27_0.slider_multiplier)
  change_entered_number(l_27_0, l_27_1)
end

_connect_events = function(l_28_0)
  if not l_28_0.events then
    return 
  end
  for _,data in ipairs(l_28_0.events) do
    l_28_0.number_ctrlr:connect(data.event, data.callback, l_28_0)
  end
end

combobox = function(l_29_0)
  local name = l_29_0.name
  local panel = l_29_0.panel
  local sizer = l_29_0.sizer
  local default = l_29_0.default
  if not l_29_0.options then
    local options = {}
  end
  if not l_29_0.value then
    local value = options[1]
  end
  local name_proportions = l_29_0.name_proportions or 1
  local ctrlr_proportions = l_29_0.ctrlr_proportions or 1
  l_29_0.sizer_proportions = l_29_0.sizer_proportions or 0
  local tooltip = l_29_0.tooltip
  local styles = l_29_0.styles or "CB_DROPDOWN,CB_READONLY"
  local sorted = l_29_0.sorted
  local ctrl_sizer = (EWS:BoxSizer("HORIZONTAL"))
  local name_ctrlr = nil
  if name then
    name_ctrlr = EWS:StaticText(panel, name, 0, "")
    ctrl_sizer:add(name_ctrlr, name_proportions, 0, "ALIGN_CENTER_VERTICAL")
  end
  if sorted then
    table.sort(options)
  end
  local ctrlr = EWS:ComboBox(panel, "", "", styles)
  ctrlr:set_tool_tip(tooltip)
  ctrlr:freeze()
  if default then
    ctrlr:append(default)
  end
  for _,option in ipairs(options) do
    ctrlr:append(option)
  end
  ctrlr:set_value(value)
  ctrlr:thaw()
  l_29_0.name_ctrlr = name_ctrlr
  l_29_0.ctrlr = ctrlr
  ctrl_sizer:add(ctrlr, ctrlr_proportions, 0, "EXPAND")
  sizer:add(ctrl_sizer, l_29_0.sizer_proportions, 0, "EXPAND")
  l_29_0.ctrlr:connect("EVT_COMMAND_COMBOBOX_SELECTED", callback(nil, _M, "_set_combobox_value"), l_29_0)
  _connect_events(l_29_0)
  return ctrlr, name_ctrlr, l_29_0
end

_set_combobox_value = function(l_30_0)
  l_30_0.value = l_30_0.ctrlr:get_value()
  if not l_30_0.numbers or not tonumber(l_30_0.value) then
    l_30_0.value = l_30_0.value
  end
end

update_combobox_options = function(l_31_0, l_31_1)
  l_31_0.ctrlr:clear()
  if l_31_0.sorted then
    table.sort(l_31_1)
  end
  if l_31_0.default then
    l_31_0.ctrlr:append(l_31_0.default)
  end
  for _,option in ipairs(l_31_1) do
    l_31_0.ctrlr:append(option)
  end
end

change_combobox_value = function(l_32_0, l_32_1)
  l_32_0.value = l_32_1
  if not l_32_0.numbers or not tonumber(l_32_0.value) then
    l_32_0.value = l_32_0.value
  end
  l_32_0.ctrlr:set_value(l_32_1)
end

slider_and_number_controller = function(l_33_0)
  l_33_0.value = l_33_0.value or 0
  l_33_0.name_proportions = l_33_0.name_proportions or 1
  l_33_0.ctrlr_proportions = l_33_0.ctrlr_proportions or 1
  l_33_0.slider_ctrlr_proportions = l_33_0.slider_ctrlr_proportions or 2
  l_33_0.number_ctrlr_proportions = l_33_0.number_ctrlr_proportions or 1
  l_33_0.floats = l_33_0.floats or 0
  l_33_0.slider_multiplier = math.pow(10, l_33_0.floats)
  l_33_0.min = l_33_0.min or 0
  l_33_0.max = l_33_0.max or 10
  l_33_0.ctrl_sizer = EWS:BoxSizer("HORIZONTAL")
  _ctrlr_tooltip(l_33_0)
  _name_ctrlr(l_33_0)
  _number_ctrlr(l_33_0)
  _slider_ctrlr(l_33_0)
  l_33_0.number_ctrlr:connect("EVT_COMMAND_TEXT_ENTER", callback(nil, _M, "update_slider_from_number"), l_33_0)
  l_33_0.number_ctrlr:connect("EVT_KILL_FOCUS", callback(nil, _M, "update_slider_from_number"), l_33_0)
  l_33_0.slider_ctrlr:connect("EVT_SCROLL_CHANGED", callback(nil, _M, "update_number_from_slider"), l_33_0)
  l_33_0.slider_ctrlr:connect("EVT_SCROLL_THUMBTRACK", callback(nil, _M, "update_number_from_slider"), l_33_0)
  local ctrl_sizer2 = EWS:BoxSizer("HORIZONTAL")
  ctrl_sizer2:add(l_33_0.slider_ctrlr, l_33_0.slider_ctrlr_proportions, 0, "ALIGN_CENTER_VERTICAL")
  ctrl_sizer2:add(l_33_0.number_ctrlr, l_33_0.number_ctrlr_proportions, 0, "EXPAND")
  l_33_0.ctrl_sizer:add(ctrl_sizer2, l_33_0.ctrlr_proportions, 0, "EXPAND")
  l_33_0.sizer:add(l_33_0.ctrl_sizer, l_33_0.sizer_proportions or 0, 0, "EXPAND")
  return l_33_0
end

_ctrlr_tooltip = function(l_34_0)
  local max = l_34_0.max
  local min = l_34_0.min
   -- DECOMPILER ERROR: Confused while interpreting a jump as a 'while'

end
l_34_0.tooltip = (not min or not max or "") .. " (Between " .. string.format("%." .. l_34_0.floats .. "f", min) .. " and " .. string.format("%." .. l_34_0.floats .. "f", max) .. ")"

end

_slider_ctrlr = function(l_35_0)
  l_35_0.slider_ctrlr = EWS:Slider(l_35_0.panel, l_35_0.value * l_35_0.slider_multiplier, l_35_0.min * l_35_0.slider_multiplier, l_35_0.max * l_35_0.slider_multiplier, "", "")
  l_35_0.slider_ctrlr:set_tool_tip(l_35_0.tooltip)
end

_number_ctrlr = function(l_36_0)
  if not l_36_0.min then
    l_36_0.value = CoreClass.type_name(l_36_0.value) == "number" or 0
  end
  l_36_0.number_ctrlr = EWS:TextCtrl(l_36_0.panel, string.format("%." .. l_36_0.floats .. "f", l_36_0.value), "", "TE_PROCESS_ENTER")
  l_36_0.number_ctrlr:set_tool_tip(l_36_0.tooltip)
  l_36_0.number_ctrlr:connect("EVT_CHAR", callback(nil, _G, "verify_number"), l_36_0.number_ctrlr)
  l_36_0.number_ctrlr:connect("EVT_COMMAND_TEXT_ENTER", callback(nil, _M, "verify_entered_number"), l_36_0)
  l_36_0.number_ctrlr:connect("EVT_KILL_FOCUS", callback(nil, _M, "verify_entered_number"), l_36_0)
end

_name_ctrlr = function(l_37_0)
  if l_37_0.name then
    l_37_0.name_ctrlr = EWS:StaticText(l_37_0.panel, l_37_0.name, 0, "")
    l_37_0.ctrl_sizer:add(l_37_0.name_ctrlr, l_37_0.name_proportions, 0, "ALIGN_CENTER_VERTICAL")
  end
end

verify_entered_number = function(l_38_0)
  if not l_38_0.ctrlr then
    local ctrlr = l_38_0.number_ctrlr
  end
  local value = tonumber(ctrlr:get_value()) or 0
  if (((not l_38_0.min or value >= l_38_0.min or not l_38_0.min) and not l_38_0.max) or l_38_0.max >= value or not l_38_0.max) then
    l_38_0.value = value
  end
  local floats = l_38_0.floats or 0
  ctrlr:change_value(string.format("%." .. floats .. "f", value))
  ctrlr:set_selection(-1, -1)
end

update_slider_from_number = function(l_39_0)
  l_39_0.slider_ctrlr:set_value(l_39_0.value * l_39_0.slider_multiplier)
end

update_number_from_slider = function(l_40_0)
  l_40_0.value = l_40_0.slider_ctrlr:get_value() / l_40_0.slider_multiplier
  change_entered_number(l_40_0, l_40_0.value)
end


