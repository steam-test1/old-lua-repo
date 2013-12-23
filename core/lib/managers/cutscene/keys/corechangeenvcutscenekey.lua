-- Decompiled using luadec 2.0.1 by sztupy (http://winmo.sztupy.hu)
-- Command line was: F:\SteamLibrary\SteamApps\common\PAYDAY 2\lua\core\lib\managers\cutscene\keys\corechangeenvcutscenekey.luac 

require("core/lib/managers/cutscene/keys/CoreCutsceneKeyBase")
if not CoreChangeEnvCutsceneKey then
  CoreChangeEnvCutsceneKey = class(CoreCutsceneKeyBase)
end
CoreChangeEnvCutsceneKey.ELEMENT_NAME = "change_env"
CoreChangeEnvCutsceneKey.NAME = "Environment Change"
CoreChangeEnvCutsceneKey:register_serialized_attribute("name", "")
CoreChangeEnvCutsceneKey:register_serialized_attribute("transition_time", 0, tonumber)
CoreChangeEnvCutsceneKey.__tostring = function(l_1_0)
  return "Change environment to \"" .. l_1_0:name() .. "\"."
end

CoreChangeEnvCutsceneKey.prime = function(l_2_0, l_2_1)
  managers.environment:preload_environment(l_2_0:name(), false)
end

CoreChangeEnvCutsceneKey.unload = function(l_3_0, l_3_1)
  if l_3_0.__previous_environment_name then
    managers.viewport:first_active_viewport():set_environment(l_3_0.__previous_environment_name)
  end
end

CoreChangeEnvCutsceneKey.evaluate = function(l_4_0, l_4_1, l_4_2)
  if not l_4_0.__previous_environment_name then
    l_4_0.__previous_environment_name = managers.environment:get_current_environment_name()
  end
  local transition_time = l_4_0:transition_time()
  if transition_time and transition_time > 0 then
    managers.viewport:first_active_viewport():set_environment(l_4_0:name(), transition_time)
  else
    managers.viewport:first_active_viewport():set_environment(l_4_0:name())
  end
end

CoreChangeEnvCutsceneKey.can_evaluate_with_player = function(l_5_0, l_5_1)
  return true
end

CoreChangeEnvCutsceneKey.is_valid_name = function(l_6_0, l_6_1)
  return Database:has("environment", l_6_1)
end

CoreChangeEnvCutsceneKey.is_valid_transition_time = function(l_7_0, l_7_1)
  return not l_7_1 or l_7_1 >= 0
end

CoreChangeEnvCutsceneKey.control_for_name = CoreCutsceneKeyBase.standard_combo_box_control
CoreChangeEnvCutsceneKey.refresh_control_for_name = function(l_8_0, l_8_1)
  l_8_1:freeze()
  l_8_1:clear()
  local value = l_8_0:name()
  for _,name in ipairs(managers.database:list_entries_of_type("environment")) do
    l_8_1:append(name)
    if name == value then
      l_8_1:set_value(value)
    end
  end
  l_8_1:thaw()
end


