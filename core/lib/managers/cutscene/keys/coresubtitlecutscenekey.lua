-- Decompiled using luadec 2.0.1 by sztupy (http://winmo.sztupy.hu)
-- Command line was: F:\SteamLibrary\SteamApps\common\PAYDAY 2\lua\core\lib\managers\cutscene\keys\coresubtitlecutscenekey.luac 

require("core/lib/managers/cutscene/keys/CoreCutsceneKeyBase")
if not CoreSubtitleCutsceneKey then
  CoreSubtitleCutsceneKey = class(CoreCutsceneKeyBase)
end
CoreSubtitleCutsceneKey.ELEMENT_NAME = "subtitle"
CoreSubtitleCutsceneKey.NAME = "Subtitle"
CoreSubtitleCutsceneKey:register_serialized_attribute("category", "")
CoreSubtitleCutsceneKey:register_serialized_attribute("string_id", "")
CoreSubtitleCutsceneKey:register_serialized_attribute("duration", 3, tonumber)
CoreSubtitleCutsceneKey:register_control("divider")
CoreSubtitleCutsceneKey:register_control("localized_text")
CoreSubtitleCutsceneKey:attribute_affects("category", "string_id")
CoreSubtitleCutsceneKey:attribute_affects("string_id", "localized_text")
CoreSubtitleCutsceneKey.control_for_category = CoreCutsceneKeyBase.standard_combo_box_control
CoreSubtitleCutsceneKey.control_for_string_id = CoreCutsceneKeyBase.standard_combo_box_control
CoreSubtitleCutsceneKey.control_for_divider = CoreCutsceneKeyBase.standard_divider_control
CoreSubtitleCutsceneKey.__tostring = function(l_1_0)
  return "Display subtitle \"" .. l_1_0:string_id() .. "\"."
end

CoreSubtitleCutsceneKey.can_evaluate_with_player = function(l_2_0, l_2_1)
  return true
end

CoreSubtitleCutsceneKey.unload = function(l_3_0, l_3_1)
  managers.subtitle:clear_subtitle()
end

CoreSubtitleCutsceneKey.play = function(l_4_0, l_4_1, l_4_2, l_4_3)
  if l_4_2 then
    managers.subtitle:clear_subtitle()
  elseif not l_4_3 then
    managers.subtitle:show_subtitle(l_4_0:string_id(), l_4_0:duration())
  end
end

CoreSubtitleCutsceneKey.is_valid_category = function(l_5_0, l_5_1)
  return not l_5_1 or l_5_1 ~= ""
end

CoreSubtitleCutsceneKey.is_valid_string_id = function(l_6_0, l_6_1)
  return not l_6_1 or l_6_1 ~= ""
end

CoreSubtitleCutsceneKey.is_valid_duration = function(l_7_0, l_7_1)
  return not l_7_1 or l_7_1 > 0
end

CoreSubtitleCutsceneKey.control_for_localized_text = function(l_8_0, l_8_1)
  local control = EWS:TextCtrl(l_8_1, "", "", "NO_BORDER,TE_RICH,TE_MULTILINE,TE_READONLY")
  control:set_min_size(control:get_min_size():with_y(160))
  control:set_background_colour(l_8_1:background_colour():unpack())
  return control
end

CoreSubtitleCutsceneKey.refresh_control_for_category = function(l_9_0, l_9_1)
  l_9_1:freeze()
  l_9_1:clear()
  local categories = managers.localization:xml_names()
  if table.empty(categories) then
    l_9_1:set_enabled(false)
  else
    l_9_1:set_enabled(true)
    local value = l_9_0:category()
    for _,category in ipairs(categories) do
      l_9_1:append(category)
      if category == value then
        l_9_1:set_value(value)
      end
    end
  end
  l_9_1:thaw()
end

CoreSubtitleCutsceneKey.refresh_control_for_string_id = function(l_10_0, l_10_1)
  l_10_1:freeze()
  l_10_1:clear()
  if l_10_0:category() == "" or not managers.localization:string_map(l_10_0:category()) then
    local string_ids = {}
  end
  if table.empty(string_ids) then
    l_10_1:set_enabled(false)
  else
    l_10_1:set_enabled(true)
    local value = l_10_0:string_id()
    for _,string_id in ipairs(string_ids) do
      l_10_1:append(string_id)
      if string_id == value then
        l_10_1:set_value(value)
      end
    end
  end
  l_10_1:thaw()
end

CoreSubtitleCutsceneKey.refresh_control_for_localized_text = function(l_11_0, l_11_1)
  if l_11_0:is_valid_category(l_11_0:category()) and l_11_0:is_valid_string_id(l_11_0:string_id()) then
    l_11_1:set_value(managers.localization:text(l_11_0:string_id()))
  else
    l_11_1:set_value("<No String Id>")
  end
end

CoreSubtitleCutsceneKey.validate_control_for_attribute = function(l_12_0, l_12_1)
  if l_12_1 ~= "localized_text" then
    return l_12_0.super.validate_control_for_attribute(l_12_0, l_12_1)
  end
  return true
end


