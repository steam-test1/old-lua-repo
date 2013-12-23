-- Decompiled using luadec 2.0.1 by sztupy (http://winmo.sztupy.hu)
-- Command line was: F:\SteamLibrary\SteamApps\common\PAYDAY 2\lua\core\lib\managers\cutscene\keys\corechangeshadowcutscenekey.luac 

require("core/lib/managers/cutscene/keys/CoreCutsceneKeyBase")
if not CoreChangeShadowCutsceneKey then
  CoreChangeShadowCutsceneKey = class(CoreCutsceneKeyBase)
end
CoreChangeShadowCutsceneKey.ELEMENT_NAME = "change_shadow"
CoreChangeShadowCutsceneKey.NAME = "Shadow Change"
CoreChangeShadowCutsceneKey:register_serialized_attribute("name", "")
CoreChangeShadowCutsceneKey.init = function(l_1_0, l_1_1)
  l_1_0.super.init(l_1_0, l_1_1)
  l_1_0._mixer = managers.viewport:first_active_viewport():environment_mixer()
  l_1_0._shadow_interface_id = nil
  l_1_0._modify_func = function(l_1_0)
    return managers.viewport:first_active_viewport():environment_mixer():static_parameters(self:name(), "post_effect", "shadow_processor", "shadow_rendering", "shadow_modifier")
   end
end

CoreChangeShadowCutsceneKey.__tostring = function(l_2_0)
  return "Change shadow settings to \"" .. l_2_0:name() .. "\"."
end

CoreChangeShadowCutsceneKey.evaluate = function(l_3_0, l_3_1, l_3_2)
  do
    if not l_3_0.unit_name or l_3_0.object_name then
      local preceeding_key = l_3_0:preceeding_key({unit_name = l_3_0:unit_name(), object_name = l_3_0:object_name()})
      if preceeding_key then
        preceeding_key:revert()
      end
      l_3_0._shadow_interface_id = l_3_0._mixer:create_modifier(true, "shared_shadow", l_3_0._modify_func)
    end
     -- Warning: missing end command somewhere! Added here
  end
end

CoreChangeShadowCutsceneKey.revert = function(l_4_0)
  l_4_0:_reset_interface()
end

CoreChangeShadowCutsceneKey.unload = function(l_5_0)
  l_5_0:_reset_interface()
end

CoreChangeShadowCutsceneKey.can_evaluate_with_player = function(l_6_0, l_6_1)
  return true
end

CoreChangeShadowCutsceneKey.is_valid_name = function(l_7_0, l_7_1)
  if l_7_1 then
    return DB:has("environment", l_7_1)
  end
end

CoreChangeShadowCutsceneKey.control_for_name = CoreCutsceneKeyBase.standard_combo_box_control
CoreChangeShadowCutsceneKey.refresh_control_for_name = function(l_8_0, l_8_1)
  l_8_1:freeze()
  l_8_1:clear()
  local value = l_8_0:name()
  for _,setting_name in ipairs(managers.database:list_entries_of_type("environment")) do
    l_8_1:append(setting_name)
    if setting_name == value then
      l_8_1:set_value(setting_name)
    end
  end
  l_8_1:thaw()
end

CoreChangeShadowCutsceneKey._reset_interface = function(l_9_0)
  if l_9_0._shadow_interface_id then
    l_9_0._mixer:destroy_modifier(l_9_0._shadow_interface_id)
    l_9_0._shadow_interface_id = nil
  end
end


