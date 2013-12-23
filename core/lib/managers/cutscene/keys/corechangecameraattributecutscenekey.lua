-- Decompiled using luadec 2.0.1 by sztupy (http://winmo.sztupy.hu)
-- Command line was: F:\SteamLibrary\SteamApps\common\PAYDAY 2\lua\core\lib\managers\cutscene\keys\corechangecameraattributecutscenekey.luac 

require("core/lib/managers/cutscene/keys/CoreCutsceneKeyBase")
if not CoreChangeCameraAttributeCutsceneKey then
  CoreChangeCameraAttributeCutsceneKey = class(CoreCutsceneKeyBase)
end
CoreChangeCameraAttributeCutsceneKey.ELEMENT_NAME = "camera_attribute"
CoreChangeCameraAttributeCutsceneKey.NAME = "Camera Attribute"
CoreChangeCameraAttributeCutsceneKey:register_serialized_attribute("near_range", nil, tonumber)
CoreChangeCameraAttributeCutsceneKey:register_serialized_attribute("far_range", nil, tonumber)
CoreChangeCameraAttributeCutsceneKey:attribute_affects("near_range", "far_range")
CoreChangeCameraAttributeCutsceneKey:attribute_affects("far_range", "near_range")
CoreChangeCameraAttributeCutsceneKey.__tostring = function(l_1_0)
  return "Change camera attributes."
end

CoreChangeCameraAttributeCutsceneKey.populate_from_editor = function(l_2_0, l_2_1)
  l_2_0.super.populate_from_editor(l_2_0, l_2_1)
  local camera_attributes = l_2_1:camera_attributes()
  l_2_0:set_near_range(camera_attributes.near_range)
  l_2_0:set_far_range(camera_attributes.far_range)
end

CoreChangeCameraAttributeCutsceneKey.is_valid = function(l_3_0)
  return true
end

CoreChangeCameraAttributeCutsceneKey.evaluate = function(l_4_0, l_4_1, l_4_2)
  local set_attribute_if_valid = function(l_1_0)
    local value = self:attribute_value(l_1_0)
    if value and self.is_valid_" .. l_1_(self, value) then
      player:set_camera_attribute(l_1_0, value)
    end
   end
  for attribute_name,_ in pairs(l_4_0.__serialized_attributes) do
    set_attribute_if_valid(attribute_name)
  end
end

CoreChangeCameraAttributeCutsceneKey.is_valid_near_range = function(l_5_0, l_5_1)
  return l_5_1 == nil or (l_5_1 > 0 and (not l_5_0:far_range() and l_5_1 < math.huge))
end

CoreChangeCameraAttributeCutsceneKey.is_valid_far_range = function(l_6_0, l_6_1)
  return l_6_1 == nil or 0 < l_6_1 or l_6_1 == nil or 0 < l_6_1
end


