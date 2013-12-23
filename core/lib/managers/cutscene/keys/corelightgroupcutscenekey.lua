-- Decompiled using luadec 2.0.1 by sztupy (http://winmo.sztupy.hu)
-- Command line was: F:\SteamLibrary\SteamApps\common\PAYDAY 2\lua\core\lib\managers\cutscene\keys\corelightgroupcutscenekey.luac 

require("core/lib/managers/cutscene/keys/CoreCutsceneKeyBase")
if not CoreLightGroupCutsceneKey then
  CoreLightGroupCutsceneKey = class(CoreCutsceneKeyBase)
end
CoreLightGroupCutsceneKey.ELEMENT_NAME = "light_group"
CoreLightGroupCutsceneKey.NAME = "Light Group"
CoreLightGroupCutsceneKey:register_serialized_attribute("group", "")
CoreLightGroupCutsceneKey:register_serialized_attribute("enable", false, toboolean)
CoreLightGroupCutsceneKey:attribute_affects("group", "enable")
CoreLightGroupCutsceneKey.__tostring = function(l_1_0)
  return string.format("Change light group, %s stateto %s.", l_1_0:group(), tostring(l_1_0:enable()))
end

CoreLightGroupCutsceneKey.prime = function(l_2_0)
  l_2_0:_build_group_cache()
end

CoreLightGroupCutsceneKey.evaluate = function(l_3_0)
  local group = assert(l_3_0:_light_groups()[l_3_0:group()], "Could not find group!")
  for _,unit in ipairs(group) do
    l_3_0:_enable_lights(unit, l_3_0:enable())
  end
end

CoreLightGroupCutsceneKey.revert = function(l_4_0)
  local prev_key = l_4_0:preceeding_key({group = l_4_0:group()})
  if prev_key then
    prev_key:evaluate()
  else
    local group = assert(l_4_0:_light_groups()[l_4_0:group()], "Could not find group!")
    for _,unit in ipairs(group) do
      l_4_0:_enable_lights(unit, false)
    end
  end
end

CoreLightGroupCutsceneKey.unload = function(l_5_0)
  for group_name,group in pairs(l_5_0:_light_groups()) do
    for _,unit in ipairs(group) do
      l_5_0:_enable_lights(unit, false)
    end
  end
end

CoreLightGroupCutsceneKey.can_evaluate_with_player = function(l_6_0, l_6_1)
  return true
end

CoreLightGroupCutsceneKey.is_valid_group = function(l_7_0, l_7_1)
  for group_name,_ in pairs(l_7_0:_light_groups()) do
    if group_name == l_7_1 then
      return true
    end
  end
end

CoreLightGroupCutsceneKey.is_valid_enable = function(l_8_0)
  return true
end

CoreLightGroupCutsceneKey.on_attribute_changed = function(l_9_0, l_9_1, l_9_2, l_9_3)
  if l_9_1 == "group" or l_9_1 == "enable" and not l_9_2 then
    l_9_0:_eval_prev_group()
  end
end

CoreLightGroupCutsceneKey._light_groups = function(l_10_0)
  if not l_10_0._light_groups_cache then
    l_10_0:_build_group_cache()
  end
  return l_10_0._light_groups_cache
end

CoreLightGroupCutsceneKey._enable_lights = function(l_11_0, l_11_1, l_11_2)
  local lights = l_11_1:get_objects_by_type("light")
  if #lights == 0 then
    Application:stack_dump_error("[CoreLightGroupCutsceneKey] No lights in unit: " .. l_11_1:name())
  end
  for _,light in ipairs(lights) do
    light:set_enable(l_11_2)
  end
end

CoreLightGroupCutsceneKey._build_group_cache = function(l_12_0)
  l_12_0._light_groups_cache = {}
  for key,unit in pairs(managers.cutscene:cutscene_actors_in_world()) do
    local identifier, name, id = string.match(key, "(.+)_(.+)_(.+)")
    if identifier == "lightgroup" then
      if not l_12_0._light_groups_cache[name] then
        l_12_0._light_groups_cache[name] = {}
      end
      table.insert(l_12_0._light_groups_cache[name], unit)
      l_12_0:_enable_lights(unit, false)
    end
  end
end

CoreLightGroupCutsceneKey._eval_prev_group = function(l_13_0)
  local prev_key = l_13_0:preceeding_key({group = l_13_0:group()})
  if prev_key then
    prev_key:evaluate()
  else
    l_13_0:evaluate()
  end
end

CoreLightGroupCutsceneKey.refresh_control_for_group = function(l_14_0, l_14_1)
  l_14_1:freeze()
  l_14_1:clear()
  local value = l_14_0:group()
  for group_name,_ in pairs(l_14_0:_light_groups()) do
    l_14_1:append(group_name)
    if group_name == value then
      l_14_1:set_value(group_name)
    end
  end
  l_14_1:thaw()
end

CoreLightGroupCutsceneKey.check_box_control = function(l_15_0, l_15_1, l_15_2)
  local control = EWS:CheckBox(l_15_1, "Enable", "", "")
  control:set_min_size(control:get_min_size():with_x(0))
  control:connect("EVT_COMMAND_CHECKBOX_CLICKED", l_15_2)
  return control
end

CoreLightGroupCutsceneKey.refresh_control_for_enable = function(l_16_0, l_16_1)
  l_16_1:set_value(l_16_0:enable())
end

CoreLightGroupCutsceneKey.control_for_group = CoreCutsceneKeyBase.standard_combo_box_control
CoreLightGroupCutsceneKey.control_for_enable = CoreLightGroupCutsceneKey.check_box_control

