-- Decompiled using luadec 2.0.1 by sztupy (http://winmo.sztupy.hu)
-- Command line was: F:\SteamLibrary\SteamApps\common\PAYDAY 2\lua\core\lib\managers\cutscene\keys\coresequencecutscenekey.luac 

require("core/lib/managers/cutscene/keys/CoreCutsceneKeyBase")
if not CoreSequenceCutsceneKey then
  CoreSequenceCutsceneKey = class(CoreCutsceneKeyBase)
end
CoreSequenceCutsceneKey.ELEMENT_NAME = "sequence"
CoreSequenceCutsceneKey.NAME = "Sequence"
CoreSequenceCutsceneKey:register_serialized_attribute("unit_name", "")
CoreSequenceCutsceneKey:register_serialized_attribute("name", "")
CoreSequenceCutsceneKey:attribute_affects("unit_name", "name")
CoreSequenceCutsceneKey.control_for_name = CoreCutsceneKeyBase.standard_combo_box_control
CoreSequenceCutsceneKey.__tostring = function(l_1_0)
  return "Trigger sequence \"" .. l_1_0:name() .. "\" on \"" .. l_1_0:unit_name() .. "\"."
end

CoreSequenceCutsceneKey.evaluate = function(l_2_0, l_2_1, l_2_2)
  l_2_0:_unit_extension(l_2_0:unit_name(), "damage"):run_sequence_simple(l_2_0:name())
end

CoreSequenceCutsceneKey.revert = function(l_3_0, l_3_1)
  l_3_0:_run_sequence_if_exists("undo_" .. l_3_0:name())
end

CoreSequenceCutsceneKey.skip = function(l_4_0, l_4_1)
  l_4_0:_run_sequence_if_exists("skip_" .. l_4_0:name())
end

CoreSequenceCutsceneKey.is_valid_unit_name = function(l_5_0, l_5_1)
  if not l_5_0.super.is_valid_unit_name(l_5_0, l_5_1) then
    return false
  end
  local unit = l_5_0:_unit(l_5_1, true)
  return (unit ~= nil and managers.sequence:has(l_5_1))
end

CoreSequenceCutsceneKey.is_valid_name = function(l_6_0, l_6_1)
  local unit = l_6_0:_unit(l_6_0:unit_name(), true)
  return (unit ~= nil and not string.begins(l_6_1, "undo_") and not string.begins(l_6_1, "skip_") and managers.sequence:has_sequence_name(l_6_0:unit_name(), l_6_1))
end

CoreSequenceCutsceneKey.refresh_control_for_name = function(l_7_0, l_7_1)
  l_7_1:freeze()
  l_7_1:clear()
  local unit = l_7_0:_unit(l_7_0:unit_name(), true)
  if not unit or not managers.sequence:get_sequence_list(l_7_0:unit_name()) then
    local sequence_names = {}
  end
  if not table.empty(sequence_names) then
    l_7_1:set_enabled(true)
    local value = l_7_0:name()
    for _,name in ipairs(sequence_names) do
      l_7_1:append(name)
      if name == value then
        l_7_1:set_value(value)
      end
    end
  else
    l_7_1:set_enabled(false)
  end
  l_7_1:thaw()
end

CoreSequenceCutsceneKey._run_sequence_if_exists = function(l_8_0, l_8_1)
  local unit = l_8_0:_unit(l_8_0:unit_name())
  if managers.sequence:has_sequence_name(l_8_0:unit_name(), l_8_1) then
    l_8_0:_unit_extension(l_8_0:unit_name(), "damage"):run_sequence_simple(l_8_1)
  end
end


