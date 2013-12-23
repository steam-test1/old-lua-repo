-- Decompiled using luadec 2.0.1 by sztupy (http://winmo.sztupy.hu)
-- Command line was: F:\SteamLibrary\SteamApps\common\PAYDAY 2\lua\core\lib\managers\cutscene\keys\corespawnunitcutscenekey.luac 

core:import("CoreEngineAccess")
require("core/lib/managers/cutscene/keys/CoreSetupCutsceneKeyBase")
if not CoreSpawnUnitCutsceneKey then
  CoreSpawnUnitCutsceneKey = class(CoreSetupCutsceneKeyBase)
end
CoreSpawnUnitCutsceneKey.ELEMENT_NAME = "spawn_unit"
CoreSpawnUnitCutsceneKey.NAME = "Spawn Unit"
CoreSpawnUnitCutsceneKey:register_serialized_attribute("name", "")
CoreSpawnUnitCutsceneKey:register_serialized_attribute("unit_category", "")
CoreSpawnUnitCutsceneKey:register_serialized_attribute("unit_type", "")
CoreSpawnUnitCutsceneKey:register_control("database_browser_button")
CoreSpawnUnitCutsceneKey:register_control("divider")
CoreSpawnUnitCutsceneKey:register_serialized_attribute("parent_unit_name", "")
CoreSpawnUnitCutsceneKey:register_serialized_attribute("parent_object_name", "")
CoreSpawnUnitCutsceneKey:register_serialized_attribute("offset", Vector3(0, 0, 0), CoreCutsceneKeyBase.string_to_vector)
CoreSpawnUnitCutsceneKey:register_serialized_attribute("rotation", Rotation(), CoreCutsceneKeyBase.string_to_rotation)
CoreSpawnUnitCutsceneKey:attribute_affects("unit_category", "unit_type")
CoreSpawnUnitCutsceneKey:attribute_affects("parent_unit_name", "parent_object_name")
CoreSpawnUnitCutsceneKey.control_for_unit_category = CoreSetupCutsceneKeyBase.standard_combo_box_control
CoreSpawnUnitCutsceneKey.control_for_unit_type = CoreSetupCutsceneKeyBase.standard_combo_box_control
CoreSpawnUnitCutsceneKey.control_for_divider = CoreSetupCutsceneKeyBase.standard_divider_control
CoreSpawnUnitCutsceneKey.control_for_parent_unit_name = CoreSetupCutsceneKeyBase.standard_combo_box_control
CoreSpawnUnitCutsceneKey.control_for_parent_object_name = CoreSetupCutsceneKeyBase.standard_combo_box_control
CoreSpawnUnitCutsceneKey.__tostring = function(l_1_0)
  return string.format("Spawn %s named \"%s\".", l_1_0:unit_type(), l_1_0:name())
end

CoreSpawnUnitCutsceneKey.prime = function(l_2_0, l_2_1)
  l_2_0:_spawn_unit()
end

CoreSpawnUnitCutsceneKey.unload = function(l_3_0, l_3_1)
  if l_3_0._cast then
    l_3_0:_delete_unit()
  end
end

CoreSpawnUnitCutsceneKey.play = function(l_4_0, l_4_1, l_4_2, l_4_3)
  l_4_0:_reparent_unit()
end

CoreSpawnUnitCutsceneKey.is_valid_unit_category = function(l_5_0, l_5_1)
  if not Application:ews_enabled() then
    return true
  elseif (l_5_1 == nil or not table.contains(managers.database:list_unit_types(), l_5_1)) then
     -- DECOMPILER ERROR: Attempted to build a boolean expression without a pending context

    return error_maybe_false
  end
end

CoreSpawnUnitCutsceneKey.is_valid_unit_type = function(l_6_0, l_6_1)
  return (l_6_1 ~= nil and DB:has("unit", l_6_1))
end

CoreSpawnUnitCutsceneKey.is_valid_name = function(l_7_0, l_7_1)
  if l_7_1 == nil or #l_7_1 <= 3 or string.match(l_7_1, "[a-z_0-9]+") ~= l_7_1 then
    return false
  end
  local existing_unit = l_7_0:_unit(l_7_1, true)
  return existing_unit == nil or existing_unit == l_7_0._spawned_unit
end

CoreSpawnUnitCutsceneKey.control_for_database_browser_button = function(l_8_0, l_8_1)
  local button = EWS:Button(l_8_1, "Pick From Database Browser", "", "")
  button:connect("EVT_COMMAND_BUTTON_CLICKED", callback(l_8_0, l_8_0, "_on_database_browser_button_clicked"), button)
  return button
end

CoreSpawnUnitCutsceneKey.refresh_control_for_unit_category = function(l_9_0, l_9_1)
  l_9_1:freeze()
  l_9_1:clear()
  local value = l_9_0:unit_category()
  for _,unit_category in ipairs(managers.database:list_unit_types()) do
    l_9_1:append(unit_category)
    if unit_category == value then
      l_9_1:set_value(value)
    end
  end
  l_9_1:thaw()
end

CoreSpawnUnitCutsceneKey.refresh_control_for_unit_type = function(l_10_0, l_10_1)
  l_10_1:freeze()
  l_10_1:clear()
  local value = l_10_0:unit_type()
  for _,unit_type in ipairs(managers.database:list_units_of_type(l_10_0:unit_category())) do
    l_10_1:append(unit_type)
    if unit_type == value then
      l_10_1:set_value(value)
    end
  end
  l_10_1:thaw()
end

CoreSpawnUnitCutsceneKey.refresh_control_for_parent_unit_name = function(l_11_0, l_11_1)
  l_11_1:freeze()
  l_11_1:clear()
  local unit_names = table.exclude(l_11_0:_unit_names(), l_11_0:name())
  if table.empty(unit_names) then
    l_11_1:set_enabled(false)
  else
    l_11_1:set_enabled(true)
    local value = l_11_0:parent_unit_name()
    for _,unit_name in pairs(unit_names) do
      l_11_1:append(unit_name)
      if unit_name == value then
        l_11_1:set_value(value)
      end
    end
  end
  l_11_1:thaw()
end

CoreSpawnUnitCutsceneKey.refresh_control_for_parent_object_name = function(l_12_0, l_12_1)
  l_12_1:freeze()
  l_12_1:clear()
  local object_names = l_12_0:_unit_object_names(l_12_0:parent_unit_name())
  if #object_names == 0 then
    l_12_1:set_enabled(false)
  else
    l_12_1:set_enabled(true)
    local value = l_12_0:parent_object_name()
    for _,object_name in ipairs(object_names) do
      l_12_1:append(object_name)
      if object_name == value then
        l_12_1:set_value(value)
      end
    end
  end
  l_12_1:thaw()
end

CoreSpawnUnitCutsceneKey.on_attribute_changed = function(l_13_0, l_13_1, l_13_2, l_13_3)
  assert(l_13_0._cast)
  if l_13_0._spawned_unit == nil then
    l_13_0:_spawn_unit()
  elseif l_13_1 == "unit_type" then
    l_13_0._cast:delete_unit(l_13_0:name())
    l_13_0:_spawn_unit()
  elseif l_13_1 == "name" then
    local existing_unit = l_13_0:_unit(l_13_2, true)
    assert(existing_unit == nil or existing_unit == l_13_0._spawned_unit)
    l_13_0._cast:rename_unit(l_13_3, l_13_2)
  elseif l_13_1 == "parent_object_name" or l_13_1 == "offset" or l_13_1 == "rotation" then
    l_13_0:_reparent_unit()
  end
end

CoreSpawnUnitCutsceneKey._spawn_unit = function(l_14_0)
  if l_14_0:is_valid() and l_14_0._cast and l_14_0._cast:unit(l_14_0:name()) == nil then
    l_14_0._spawned_unit = l_14_0._cast:spawn_unit(l_14_0:name(), l_14_0:unit_type())
    l_14_0:_reparent_unit()
  end
end

CoreSpawnUnitCutsceneKey._delete_unit = function(l_15_0)
  if l_15_0:is_valid() and l_15_0._cast then
    l_15_0._cast:delete_unit(l_15_0:name())
  end
end

CoreSpawnUnitCutsceneKey._reparent_unit = function(l_16_0)
  if l_16_0._spawned_unit then
    l_16_0._spawned_unit:unlink()
    local parent_object = l_16_0:_unit_object(l_16_0:parent_unit_name(), l_16_0:parent_object_name(), true)
    if parent_object then
      local parent_unit = l_16_0:_unit(l_16_0:parent_unit_name())
      parent_unit:link(parent_object:name(), l_16_0._spawned_unit)
      l_16_0._spawned_unit:set_local_position(l_16_0:offset())
      l_16_0._spawned_unit:set_local_rotation(l_16_0:rotation())
      if l_16_0._cast:unit_visible(l_16_0:name()) then
        l_16_0._cast:_set_unit_and_children_visible(l_16_0._spawned_unit, parent_unit:visible())
      end
    end
  end
end

CoreSpawnUnitCutsceneKey.update_gui = function(l_17_0, l_17_1, l_17_2)
  if l_17_0._database_browser and l_17_0._database_browser:update(l_17_1, l_17_2) then
    if alive(l_17_0._cutscene_editor_window) then
      l_17_0._cutscene_editor_window:set_enabled(true)
      l_17_0._cutscene_editor_window:set_focus()
    end
    l_17_0._cutscene_editor_window = nil
    l_17_0._database_browser = nil
  end
end

CoreSpawnUnitCutsceneKey._on_database_browser_button_clicked = function(l_18_0, l_18_1)
  l_18_0._cutscene_editor_window = l_18_1:parent()
  repeat
    if l_18_0._cutscene_editor_window and type_name(l_18_0._cutscene_editor_window) ~= "EWSFrame" then
      l_18_0._cutscene_editor_window = l_18_0._cutscene_editor_window:parent()
    else
      assert(l_18_0._cutscene_editor_window, "Button is not inside a top-level window.")
      l_18_0._cutscene_editor_window:set_enabled(false)
      l_18_0._database_browser = CoreDBDialog:new("unit", l_18_0, l_18_0._on_database_browser_entry_selected, ProjectDatabase)
       -- Warning: missing end command somewhere! Added here
    end
     -- Warning: missing end command somewhere! Added here
  end
end

CoreSpawnUnitCutsceneKey._on_database_browser_entry_selected = function(l_19_0)
  if l_19_0._database_browser then
    local selected_entry = l_19_0._database_browser:get_value()
  end
  assert(selected_entry, "Callback should only be called if an entry was selected.")
  local unit_data = CoreEngineAccess._editor_unit_data(selected_entry:name():id())
  if unit_data then
    l_19_0:set_unit_category(unit_data:type():s())
    l_19_0:set_unit_type(unit_data:name():s())
    l_19_0:refresh_control_for_attribute("unit_category")
    l_19_0:refresh_control_for_attribute("unit_type")
  end
end


