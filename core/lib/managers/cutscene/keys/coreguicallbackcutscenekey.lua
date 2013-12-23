-- Decompiled using luadec 2.0.1 by sztupy (http://winmo.sztupy.hu)
-- Command line was: F:\SteamLibrary\SteamApps\common\PAYDAY 2\lua\core\lib\managers\cutscene\keys\coreguicallbackcutscenekey.luac 

require("core/lib/managers/cutscene/keys/CoreCutsceneKeyBase")
if not CoreGuiCallbackCutsceneKey then
  CoreGuiCallbackCutsceneKey = class(CoreCutsceneKeyBase)
end
CoreGuiCallbackCutsceneKey.ELEMENT_NAME = "gui_callback"
CoreGuiCallbackCutsceneKey.NAME = "Gui Callback"
CoreGuiCallbackCutsceneKey:register_serialized_attribute("name", "")
CoreGuiCallbackCutsceneKey:register_serialized_attribute("function_name", "")
CoreGuiCallbackCutsceneKey:register_serialized_attribute("enabled", true, toboolean)
CoreGuiCallbackCutsceneKey.control_for_name = CoreCutsceneKeyBase.standard_combo_box_control
CoreGuiCallbackCutsceneKey.__tostring = function(l_1_0)
  return "Call " .. l_1_0:function_name() .. " in gui \"" .. l_1_0:name() .. "\"."
end

CoreGuiCallbackCutsceneKey.evaluate = function(l_2_0, l_2_1, l_2_2)
  if l_2_0:enabled() then
    l_2_1:invoke_callback_in_gui(l_2_0:name(), l_2_0:function_name(), l_2_1)
  end
end

CoreGuiCallbackCutsceneKey.is_valid_name = function(l_3_0, l_3_1)
  return DB:has("gui", l_3_1)
end

CoreGuiCallbackCutsceneKey.refresh_control_for_name = function(l_4_0, l_4_1)
  l_4_1:freeze()
  l_4_1:clear()
  local value = l_4_0:name()
  for _,name in ipairs(managers.database:list_entries_of_type("gui")) do
    l_4_1:append(name)
    if name == value then
      l_4_1:set_value(value)
    end
  end
  l_4_1:thaw()
end


