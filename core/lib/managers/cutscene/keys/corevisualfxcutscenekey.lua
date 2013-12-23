-- Decompiled using luadec 2.0.1 by sztupy (http://winmo.sztupy.hu)
-- Command line was: F:\SteamLibrary\SteamApps\common\PAYDAY 2\lua\core\lib\managers\cutscene\keys\corevisualfxcutscenekey.luac 

require("core/lib/managers/cutscene/keys/CoreCutsceneKeyBase")
core:import("CoreEngineAccess")
if not CoreVisualFXCutsceneKey then
  CoreVisualFXCutsceneKey = class(CoreCutsceneKeyBase)
end
CoreVisualFXCutsceneKey.ELEMENT_NAME = "visual_fx"
CoreVisualFXCutsceneKey.NAME = "Visual Effect"
CoreVisualFXCutsceneKey:register_serialized_attribute("unit_name", "")
CoreVisualFXCutsceneKey:register_serialized_attribute("object_name", "")
CoreVisualFXCutsceneKey:register_serialized_attribute("effect", "")
CoreVisualFXCutsceneKey:register_serialized_attribute("duration", nil, tonumber)
CoreVisualFXCutsceneKey:register_serialized_attribute("offset", Vector3(0, 0, 0), CoreCutsceneKeyBase.string_to_vector)
CoreVisualFXCutsceneKey:register_serialized_attribute("rotation", Rotation(), CoreCutsceneKeyBase.string_to_rotation)
CoreVisualFXCutsceneKey:register_serialized_attribute("force_synch", false, toboolean)
CoreVisualFXCutsceneKey.control_for_effect = CoreCutsceneKeyBase.standard_combo_box_control
CoreVisualFXCutsceneKey.__tostring = function(l_1_0)
  return "Trigger visual effect \"" .. l_1_0:effect() .. "\" on \"" .. l_1_0:object_name() .. " in " .. l_1_0:unit_name() .. "\"."
end

CoreVisualFXCutsceneKey.can_evaluate_with_player = function(l_2_0, l_2_1)
  return true
end

CoreVisualFXCutsceneKey.prime = function(l_3_0, l_3_1)
  if Application:production_build() then
    CoreEngineAccess._editor_load(Idstring("effect"), l_3_0:effect():id())
  end
end

CoreVisualFXCutsceneKey.unload = function(l_4_0, l_4_1)
  l_4_0:stop()
end

CoreVisualFXCutsceneKey.play = function(l_5_0, l_5_1, l_5_2, l_5_3)
  if l_5_2 then
    l_5_0:stop()
  elseif not l_5_3 then
    l_5_0:stop()
    l_5_0:prime(l_5_1)
    local effect_manager = World:effect_manager()
    do
      local parent_object = l_5_0:_unit_object(l_5_0:unit_name(), l_5_0:object_name(), true)
      local effect_id = effect_manager:spawn({effect = l_5_0:effect(), parent = parent_object, position = l_5_0:offset(), rotation = l_5_0:rotation(), force_synch = l_5_0:force_synch()})
      l_5_0._effect_abort_func = function()
        effect_manager:kill(effect_id)
         end
    end
  end
end

CoreVisualFXCutsceneKey.update = function(l_6_0, l_6_1, l_6_2)
  if l_6_0:duration() and l_6_0:duration() < l_6_2 then
    l_6_0:stop()
  end
end

CoreVisualFXCutsceneKey.is_valid_unit_name = function(l_7_0, l_7_1)
  return (l_7_1 ~= nil and l_7_1 ~= "" and CoreCutsceneKeyBase.is_valid_unit_name(l_7_0, l_7_1))
end

CoreVisualFXCutsceneKey.is_valid_object_name = function(l_8_0, l_8_1)
  return ((l_8_1 == nil or l_8_1 == "" or not table.contains(l_8_0:_unit_object_names(l_8_0:unit_name()), l_8_1)) and false)
end

CoreVisualFXCutsceneKey.is_valid_effect = function(l_9_0, l_9_1)
  return DB:has("effect", l_9_1)
end

CoreVisualFXCutsceneKey.is_valid_duration = function(l_10_0, l_10_1)
  return l_10_1 == nil or l_10_1 > 0
end

CoreVisualFXCutsceneKey.is_valid_offset = function(l_11_0, l_11_1)
  return l_11_1 ~= nil
end

CoreVisualFXCutsceneKey.is_valid_rotation = function(l_12_0, l_12_1)
  return l_12_1 ~= nil
end

CoreVisualFXCutsceneKey.refresh_control_for_unit_name = function(l_13_0, l_13_1)
  l_13_0.super.refresh_control_for_unit_name(l_13_0, l_13_1, l_13_0:unit_name())
  l_13_1:append("")
  if l_13_0:unit_name() == "" then
    l_13_1:set_value("")
  end
end

CoreVisualFXCutsceneKey.refresh_control_for_object_name = function(l_14_0, l_14_1)
  l_14_0.super.refresh_control_for_object_name(l_14_0, l_14_1, l_14_0:unit_name(), l_14_0:object_name())
  l_14_1:append("")
  if l_14_0:object_name() == "" or not l_14_0:is_valid_object_name(l_14_0:object_name()) then
    l_14_0:set_object_name("")
    l_14_1:set_value("")
  end
  l_14_1:set_enabled(l_14_0:unit_name() ~= "")
end

CoreVisualFXCutsceneKey.refresh_control_for_effect = function(l_15_0, l_15_1)
  l_15_1:freeze()
  l_15_1:clear()
  local value = l_15_0:effect()
  for _,name in ipairs(managers.database:list_entries_of_type("effect")) do
    l_15_1:append(name)
    if name == value then
      l_15_1:set_value(value)
    end
  end
  l_15_1:thaw()
end

CoreVisualFXCutsceneKey.on_attribute_before_changed = function(l_16_0, l_16_1, l_16_2, l_16_3)
  l_16_0:stop()
end

CoreVisualFXCutsceneKey.stop = function(l_17_0)
  if l_17_0._effect_abort_func then
    l_17_0._effect_abort_func()
    l_17_0._effect_abort_func = nil
  end
end


