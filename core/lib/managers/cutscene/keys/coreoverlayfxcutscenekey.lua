-- Decompiled using luadec 2.0.1 by sztupy (http://winmo.sztupy.hu)
-- Command line was: F:\SteamLibrary\SteamApps\common\PAYDAY 2\lua\core\lib\managers\cutscene\keys\coreoverlayfxcutscenekey.luac 

require("core/lib/managers/cutscene/keys/CoreCutsceneKeyBase")
core:import("CoreColorPickerDialog")
if not CoreOverlayFXCutsceneKey then
  CoreOverlayFXCutsceneKey = class(CoreCutsceneKeyBase)
end
CoreOverlayFXCutsceneKey.ELEMENT_NAME = "overlay_fx"
CoreOverlayFXCutsceneKey.NAME = "Overlay Effect"
local l_0_0 = CoreOverlayFXCutsceneKey
local l_0_1 = {}
 -- DECOMPILER ERROR: No list found. Setlist fails

 -- DECOMPILER ERROR: Overwrote pending register.

 -- DECOMPILER ERROR: Overwrote pending register.

 -- DECOMPILER ERROR: Overwrote pending register.

l_0_0(l_0_1, "normal", "add".VALID_BLEND_MODES[1])
l_0_1, l_0_0, l_0_0.VALID_BLEND_MODES = l_0_0, CoreOverlayFXCutsceneKey, l_0_1
l_0_0 = CoreOverlayFXCutsceneKey
l_0_0, l_0_1 = l_0_0:register_serialized_attribute, l_0_0
l_0_0(l_0_1, "color", Color.white, CoreCutsceneKeyBase.string_to_color)
l_0_0 = CoreOverlayFXCutsceneKey
l_0_0, l_0_1 = l_0_0:register_serialized_attribute, l_0_0
l_0_0(l_0_1, "fade_in", 0, tonumber)
l_0_0 = CoreOverlayFXCutsceneKey
l_0_0, l_0_1 = l_0_0:register_serialized_attribute, l_0_0
l_0_0(l_0_1, "sustain", 0, tonumber)
l_0_0 = CoreOverlayFXCutsceneKey
l_0_0, l_0_1 = l_0_0:register_serialized_attribute, l_0_0
l_0_0(l_0_1, "fade_out", 0, tonumber)
l_0_0 = CoreOverlayFXCutsceneKey
l_0_1 = CoreCutsceneKeyBase
l_0_1 = l_0_1.standard_combo_box_control
l_0_0.control_for_blend_mode = l_0_1
l_0_0 = CoreOverlayFXCutsceneKey
l_0_1 = CoreCutsceneKeyBase
 -- DECOMPILER ERROR: Overwrote pending register.

l_0_1 = l_0_1:standard_combo_box_control_refresh
l_0_0.refresh_control_for_blend_mode = l_0_1
l_0_0 = CoreOverlayFXCutsceneKey
l_0_1 = function(l_1_0)
  return "Trigger overlay effect."
end

l_0_0.__tostring = l_0_1
l_0_0 = CoreOverlayFXCutsceneKey
l_0_1 = function(l_2_0, l_2_1)
  if l_2_0:fade_in() == 0 then
    local effect_data = l_2_0:_effect_data()
    effect_data.fade_in = 0
    effect_data.sustain = nil
    effect_data.fade_out = 0
    managers.cutscene:play_overlay_effect(effect_data)
  end
end

l_0_0.preroll = l_0_1
l_0_0 = CoreOverlayFXCutsceneKey
l_0_1 = function(l_3_0, l_3_1)
  local full_intensity_start = l_3_0:time() + l_3_0:fade_in()
  local full_intensity_end = full_intensity_start + l_3_0:sustain()
  local cutscene_end = l_3_1:cutscene_duration()
  if full_intensity_start <= cutscene_end and cutscene_end <= full_intensity_end then
    local effect_data = l_3_0:_effect_data()
    effect_data.fade_in = 0
    effect_data.sustain = math.max(full_intensity_end - cutscene_end, 0)
    managers.cutscene:play_overlay_effect(effect_data)
  end
end

l_0_0.skip = l_0_1
l_0_0 = CoreOverlayFXCutsceneKey
l_0_1 = function(l_4_0, l_4_1, l_4_2)
  local effect_data = table.remap(l_4_0:attribute_names(), function(l_1_0, l_1_1)
    return l_1_1, self:attribute_value(l_1_1)
   end)
  managers.cutscene:play_overlay_effect(effect_data)
end

l_0_0.evaluate = l_0_1
l_0_0 = CoreOverlayFXCutsceneKey
l_0_1 = function(l_5_0, l_5_1)
  l_5_0:_stop()
end

l_0_0.revert = l_0_1
l_0_0 = CoreOverlayFXCutsceneKey
l_0_1 = function(l_6_0, l_6_1, l_6_2, l_6_3)
  if l_6_0.__color_picker_dialog then
    l_6_0.__color_picker_dialog:update(l_6_1, l_6_2)
  end
end

l_0_0.update_gui = l_0_1
l_0_0 = CoreOverlayFXCutsceneKey
l_0_1 = function(l_7_0, l_7_1)
  return table.contains(l_7_0.VALID_BLEND_MODES, l_7_1)
end

l_0_0.is_valid_blend_mode = l_0_1
l_0_0 = CoreOverlayFXCutsceneKey
l_0_1 = function(l_8_0, l_8_1)
  return l_8_1 >= 0
end

l_0_0.is_valid_fade_in = l_0_1
l_0_0 = CoreOverlayFXCutsceneKey
l_0_1 = function(l_9_0, l_9_1)
  return l_9_1 >= 0
end

l_0_0.is_valid_sustain = l_0_1
l_0_0 = CoreOverlayFXCutsceneKey
l_0_1 = function(l_10_0, l_10_1)
  return l_10_1 >= 0
end

l_0_0.is_valid_fade_out = l_0_1
l_0_0 = CoreOverlayFXCutsceneKey
l_0_1 = function(l_11_0, l_11_1)
  local control = EWS:ColorWell(l_11_1, "")
  control:set_tool_tip("Open Color Picker")
  control:set_background_colour(255, 20, 255)
  control:set_color(l_11_0:color())
  control:connect("EVT_LEFT_UP", callback(l_11_0, l_11_0, "_on_pick_color"), control)
  return control
end

l_0_0.control_for_color = l_0_1
l_0_0 = CoreOverlayFXCutsceneKey
l_0_1 = function(l_12_0, l_12_1)
  if l_12_0.__color_picker_dialog == nil then
    local cutscene_editor_window = l_12_0:_top_level_window(l_12_1)
    l_12_0.__color_picker_dialog = CoreColorPickerDialog.ColorPickerDialog:new(cutscene_editor_window, true, "HORIZONTAL", true)
    l_12_0.__color_picker_dialog:connect("EVT_CLOSE_WINDOW", function()
      self.__color_picker_dialog = nil
      end)
    l_12_0.__color_picker_dialog:connect("EVT_COLOR_CHANGED", function()
      local color = self.__color_picker_dialog:color()
      sender:set_color(color)
      self:set_color(color)
      end)
    l_12_0.__color_picker_dialog:center(cutscene_editor_window)
    l_12_0.__color_picker_dialog:set_color(l_12_0:color())
    l_12_0.__color_picker_dialog:set_visible(true)
  end
end

l_0_0._on_pick_color = l_0_1
l_0_0 = CoreOverlayFXCutsceneKey
l_0_1 = function(l_13_0)
  return table.remap(l_13_0:attribute_names(), function(l_1_0, l_1_1)
    return l_1_1, self:attribute_value(l_1_1)
   end)
end

l_0_0._effect_data = l_0_1
l_0_0 = CoreOverlayFXCutsceneKey
l_0_1 = function(l_14_0)
  managers.cutscene:stop_overlay_effect()
end

l_0_0._stop = l_0_1
l_0_0 = CoreOverlayFXCutsceneKey
l_0_1 = function(l_15_0, l_15_1)
  if (type_name(l_15_1) ~= "EWSFrame" and type_name(l_15_1) ~= "EWSDialog") or not l_15_1 then
    return l_15_0:_top_level_window(assert(l_15_1:parent()))
  end
end

l_0_0._top_level_window = l_0_1

