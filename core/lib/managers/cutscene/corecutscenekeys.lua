-- Decompiled using luadec 2.0.1 by sztupy (http://winmo.sztupy.hu)
-- Command line was: F:\SteamLibrary\SteamApps\common\PAYDAY 2\lua\core\lib\managers\cutscene\corecutscenekeys.luac 

if not CoreCutsceneKey then
  local l_0_0 = {}
  l_0_0._classes = {}
end
 -- DECOMPILER ERROR: Confused about usage of registers!

CoreCutsceneKey = l_0_0
CoreCutsceneKey.create = function(l_1_0, l_1_1, l_1_2)
  return assert(l_1_0._classes[l_1_1], "Element name \"" .. tostring(l_1_1) .. "\" does not match any registered cutscene key type."):new(l_1_2)
end

CoreCutsceneKey.register_class = function(l_2_0, l_2_1)
  require(l_2_1)
  local class_name = assert(string.match(l_2_1, ".*[\\/](.*)"), "Malformed class path supplied for cutscene key type.")
  local class = assert(rawget(_G, class_name), "The class should be named like the file.")
  local element_name = assert(class.ELEMENT_NAME, "Class does not have required ELEMENT_NAME string member.")
  if Application:ews_enabled() and not class.COLOUR then
    class.COLOUR = l_2_0:next_available_colour()
  end
  CoreCutsceneKey._classes[element_name] = class
end

CoreCutsceneKey.types = function(l_3_0)
  local sorted_types = {}
  for _,class in pairs(l_3_0._classes) do
    table.insert(sorted_types, class)
  end
  table.sort(sorted_types, function(l_1_0, l_1_1)
    return l_1_0.NAME < l_1_1.NAME
   end)
  return sorted_types
end

CoreCutsceneKey.next_available_colour = function(l_4_0)
  l_4_0._colour_index = (l_4_0._colour_index or 0) + 1
  if #l_4_0:colour_palette() < l_4_0._colour_index then
    l_4_0._colour_index = 1
  end
  return l_4_0:colour_palette()[l_4_0._colour_index]
end

CoreCutsceneKey.colour_palette = function(l_5_0)
  if l_5_0._colour_palette == nil then
    local hex_values = {"468966", "FFF0A5", "FFB03B", "B64926", "445878", "046380", "ADCF4F", "4A1A2C", "8E3557", "CCB689", "7EBE74", "756D43", "664689", "A5FFF0", "3BFFB0", "26B649", "784458", "800463", "4FADCF", "2C4A1A", "578E35", "89CCB6", "747EBE", "43756D", "896646", "F0A5FF", "B03BFF", "4926B6", "587844", "638004", "CF4FAD", "1A2C4A", "35578E", "B689CC", "BE747E", "6D4375"}
    l_5_0._colour_palette = table.collect(hex_values, function(l_1_0)
      return Color(l_1_0)
      end)
  end
  return l_5_0._colour_palette
end

CoreCutsceneKey:register_class("core/lib/managers/cutscene/keys/CoreChangeCameraAttributeCutsceneKey")
CoreCutsceneKey:register_class("core/lib/managers/cutscene/keys/CoreChangeCameraCutsceneKey")
CoreCutsceneKey:register_class("core/lib/managers/cutscene/keys/CoreChangeEnvCutsceneKey")
CoreCutsceneKey:register_class("core/lib/managers/cutscene/keys/CoreDepthOfFieldCutsceneKey")
CoreCutsceneKey:register_class("core/lib/managers/cutscene/keys/CoreDiscontinuityCutsceneKey")
CoreCutsceneKey:register_class("core/lib/managers/cutscene/keys/CoreGuiCallbackCutsceneKey")
CoreCutsceneKey:register_class("core/lib/managers/cutscene/keys/CoreGuiCutsceneKey")
CoreCutsceneKey:register_class("core/lib/managers/cutscene/keys/CoreLocatorConstraintCutsceneKey")
CoreCutsceneKey:register_class("core/lib/managers/cutscene/keys/CoreObjectVisibleCutsceneKey")
CoreCutsceneKey:register_class("core/lib/managers/cutscene/keys/CoreOverlayFXCutsceneKey")
CoreCutsceneKey:register_class("core/lib/managers/cutscene/keys/CoreSequenceCutsceneKey")
CoreCutsceneKey:register_class("core/lib/managers/cutscene/keys/CoreShakeCameraCutsceneKey")
CoreCutsceneKey:register_class("core/lib/managers/cutscene/keys/CoreSimpleAnimationCutsceneKey")
CoreCutsceneKey:register_class("core/lib/managers/cutscene/keys/CoreSoundCutsceneKey")
CoreCutsceneKey:register_class("core/lib/managers/cutscene/keys/CoreSpawnUnitCutsceneKey")
CoreCutsceneKey:register_class("core/lib/managers/cutscene/keys/CoreSubtitleCutsceneKey")
CoreCutsceneKey:register_class("core/lib/managers/cutscene/keys/CoreTimerSpeedCutsceneKey")
CoreCutsceneKey:register_class("core/lib/managers/cutscene/keys/CoreUnitCallbackCutsceneKey")
CoreCutsceneKey:register_class("core/lib/managers/cutscene/keys/CoreUnitVisibleCutsceneKey")
CoreCutsceneKey:register_class("core/lib/managers/cutscene/keys/CoreVideoCutsceneKey")
CoreCutsceneKey:register_class("core/lib/managers/cutscene/keys/CoreVisualFXCutsceneKey")
CoreCutsceneKey:register_class("core/lib/managers/cutscene/keys/CoreVolumeSetCutsceneKey")
CoreCutsceneKey:register_class("core/lib/managers/cutscene/keys/CoreZoomCameraCutsceneKey")
CoreCutsceneKey:register_class("core/lib/managers/cutscene/keys/CoreChangeShadowCutsceneKey")
CoreCutsceneKey:register_class("core/lib/managers/cutscene/keys/CoreLightGroupCutsceneKey")

