-- Decompiled using luadec 2.0.1 by sztupy (http://winmo.sztupy.hu)
-- Command line was: F:\SteamLibrary\SteamApps\common\PAYDAY 2\lua\core\lib\managers\cutscene\keys\corelocatorconstraintcutscenekey.luac 

require("core/lib/managers/cutscene/keys/CoreCutsceneKeyBase")
if not CoreLocatorConstraintCutsceneKey then
  CoreLocatorConstraintCutsceneKey = class(CoreCutsceneKeyBase)
end
CoreLocatorConstraintCutsceneKey.ELEMENT_NAME = "locator_constraint"
CoreLocatorConstraintCutsceneKey.NAME = "Locator Constraint"
CoreLocatorConstraintCutsceneKey:register_serialized_attribute("locator_name", "")
CoreLocatorConstraintCutsceneKey:register_serialized_attribute("parent_unit_name", "")
CoreLocatorConstraintCutsceneKey:register_serialized_attribute("parent_object_name", "")
CoreLocatorConstraintCutsceneKey.control_for_locator_name = CoreCutsceneKeyBase.standard_combo_box_control
CoreLocatorConstraintCutsceneKey.control_for_parent_unit_name = CoreCutsceneKeyBase.standard_combo_box_control
CoreLocatorConstraintCutsceneKey.control_for_parent_object_name = CoreCutsceneKeyBase.standard_combo_box_control
CoreLocatorConstraintCutsceneKey.__tostring = function(l_1_0)
  local attach_point_name = "disabled"
  if l_1_0:parent_unit_name() ~= "" and l_1_0:parent_object_name() ~= "" then
    attach_point_name = string.format("\"%s/%s\"", l_1_0:parent_unit_name(), l_1_0:parent_object_name())
  end
  return string.format("Set constaint of locator \"%s\" to %s.", l_1_0:locator_name(), attach_point_name)
end

CoreLocatorConstraintCutsceneKey.can_evaluate_with_player = function(l_2_0, l_2_1)
  return l_2_0._cast ~= nil
end

CoreLocatorConstraintCutsceneKey.evaluate = function(l_3_0, l_3_1, l_3_2)
  local parent_object = l_3_0:_unit_object(l_3_0:parent_unit_name(), l_3_0:parent_object_name(), true)
  l_3_0:_constrain_locator_to_object(parent_object)
end

CoreLocatorConstraintCutsceneKey.revert = function(l_4_0, l_4_1)
  local preceeding_key = l_4_0:preceeding_key({locator_name = l_4_0:locator_name()})
  if preceeding_key then
    preceeding_key:evaluate(l_4_1, false)
  else
    l_4_0:_constrain_locator_to_object(nil)
  end
end

CoreLocatorConstraintCutsceneKey.update_gui = function(l_5_0, l_5_1, l_5_2, l_5_3)
  local locator_object = l_5_0:_unit_object(l_5_0:locator_name(), "locator", true)
  if locator_object then
    local pen = Draw:pen()
    pen:set("no_z")
    pen:set(Color(1, 0.5, 0))
    pen:sphere(locator_object:position(), 1, 5, 1)
    local parent_object = l_5_0:_unit_object(l_5_0:parent_unit_name(), l_5_0:parent_object_name(), true)
    if parent_object then
      pen:set(Color(1, 0, 1))
      pen:line(locator_object:position(), parent_object:position())
      pen:rotation(parent_object:position(), parent_object:rotation(), 10)
      pen:set(Color(0, 1, 1))
      pen:sphere(parent_object:position(), 1, 10, 1)
    end
  end
end

CoreLocatorConstraintCutsceneKey.is_valid_locator_name = function(l_6_0, l_6_1)
  return not string.begins(l_6_1, "locator") or l_6_0:_unit_type(l_6_1) == "locator"
end

CoreLocatorConstraintCutsceneKey.is_valid_parent_unit_name = function(l_7_0, l_7_1)
  return (l_7_1 ~= nil and l_7_1 ~= "" and CoreCutsceneKeyBase.is_valid_unit_name(l_7_0, l_7_1))
end

CoreLocatorConstraintCutsceneKey.is_valid_parent_object_name = function(l_8_0, l_8_1)
  return (l_8_1 ~= nil and l_8_1 ~= "" and CoreCutsceneKeyBase.is_valid_object_name(l_8_0, l_8_1, l_8_0:parent_unit_name()))
end

CoreLocatorConstraintCutsceneKey.refresh_control_for_locator_name = function(l_9_0, l_9_1)
  l_9_1:freeze()
  l_9_1:clear()
  local locator_names = table.find_all_values(l_9_0:_unit_names(), function(l_1_0)
    return self:is_valid_locator_name(l_1_0)
   end)
  for _,locator_name in ipairs(locator_names) do
    l_9_1:append(locator_name)
  end
  l_9_1:set_enabled(not table.empty(locator_names))
  l_9_1:append("")
  l_9_1:set_value(l_9_0:locator_name())
  l_9_1:thaw()
end

CoreLocatorConstraintCutsceneKey.refresh_control_for_parent_unit_name = function(l_10_0, l_10_1)
  CoreCutsceneKeyBase.refresh_control_for_unit_name(l_10_0, l_10_1, l_10_0:parent_unit_name())
  l_10_1:append("")
  if l_10_0:parent_unit_name() == "" then
    l_10_1:set_value("")
  end
end

CoreLocatorConstraintCutsceneKey.refresh_control_for_parent_object_name = function(l_11_0, l_11_1)
  CoreCutsceneKeyBase.refresh_control_for_object_name(l_11_0, l_11_1, l_11_0:parent_unit_name(), l_11_0:parent_object_name())
  l_11_1:append("")
  if l_11_0:parent_object_name() == "" then
    l_11_1:set_value("")
  end
end

CoreLocatorConstraintCutsceneKey.on_attribute_before_changed = function(l_12_0, l_12_1, l_12_2, l_12_3)
  l_12_0:revert(nil)
end

CoreLocatorConstraintCutsceneKey.on_attribute_changed = function(l_13_0, l_13_1, l_13_2, l_13_3)
  l_13_0:evaluate(nil)
end

CoreLocatorConstraintCutsceneKey._constrain_locator_to_object = function(l_14_0, l_14_1)
  local locator_unit = l_14_0:_unit(l_14_0:locator_name(), true)
  if locator_unit == nil then
    return 
  end
  if l_14_1 then
    locator_unit:set_animations_enabled(false)
    local locator_object = locator_unit:get_object("locator")
    local position = locator_object:position()
    local rotation = locator_object:rotation()
    local parent_unit = l_14_0:_unit(l_14_0:parent_unit_name())
    locator_object:set_local_position(Vector3(0, 0, 0))
    locator_object:set_local_rotation(Rotation())
    locator_object:link(l_14_1)
    locator_object:set_position(position)
    locator_object:set_rotation(rotation)
    parent_unit:link(locator_unit)
  else
    local locator_object = locator_unit:get_object("locator")
    locator_object:unlink()
    locator_unit:unlink()
    locator_unit:set_animations_enabled(true)
  end
end


