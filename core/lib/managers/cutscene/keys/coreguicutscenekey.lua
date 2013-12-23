-- Decompiled using luadec 2.0.1 by sztupy (http://winmo.sztupy.hu)
-- Command line was: F:\SteamLibrary\SteamApps\common\PAYDAY 2\lua\core\lib\managers\cutscene\keys\coreguicutscenekey.luac 

require("core/lib/managers/cutscene/keys/CoreCutsceneKeyBase")
if not CoreGuiCutsceneKey then
  CoreGuiCutsceneKey = class(CoreCutsceneKeyBase)
end
CoreGuiCutsceneKey.ELEMENT_NAME = "gui"
CoreGuiCutsceneKey.NAME = "Gui"
local l_0_0 = CoreGuiCutsceneKey
local l_0_1 = {}
 -- DECOMPILER ERROR: No list found. Setlist fails

 -- DECOMPILER ERROR: Overwrote pending register.

 -- DECOMPILER ERROR: Overwrote pending register.

 -- DECOMPILER ERROR: Overwrote pending register.

l_0_0(l_0_1, "show", "hide")
l_0_1, l_0_0, l_0_0.VALID_ACTIONS = l_0_0, CoreGuiCutsceneKey, l_0_1
l_0_0 = CoreGuiCutsceneKey
l_0_0, l_0_1 = l_0_0:register_serialized_attribute, l_0_0
l_0_0(l_0_1, "name", "")
l_0_0 = CoreGuiCutsceneKey
l_0_1 = CoreCutsceneKeyBase
l_0_1 = l_0_1.standard_combo_box_control
l_0_0.control_for_action = l_0_1
l_0_0 = CoreGuiCutsceneKey
l_0_1 = CoreCutsceneKeyBase
l_0_1 = l_0_1.standard_combo_box_control
l_0_0.control_for_name = l_0_1
l_0_0 = CoreGuiCutsceneKey
l_0_1 = CoreCutsceneKeyBase
 -- DECOMPILER ERROR: Overwrote pending register.

l_0_1 = l_0_1:standard_combo_box_control_refresh
l_0_0.refresh_control_for_action = l_0_1
l_0_0 = CoreGuiCutsceneKey
l_0_1 = function(l_1_0)
  return string.capitalize(l_1_0:action()) .. " gui \"" .. l_1_0:name() .. "\"."
end

l_0_0.__tostring = l_0_1
l_0_0 = CoreGuiCutsceneKey
l_0_1 = function(l_2_0, l_2_1)
  if l_2_0:action() == "show" and l_2_0:is_valid_name(l_2_0:name()) then
    l_2_1:load_gui(l_2_0:name())
  end
end

l_0_0.prime = l_0_1
l_0_0 = CoreGuiCutsceneKey
l_0_1 = function(l_3_0, l_3_1)
  if l_3_1 then
    l_3_0:play(l_3_1, true)
  end
end

l_0_0.unload = l_0_1
l_0_0 = CoreGuiCutsceneKey
l_0_1 = function(l_4_0, l_4_1, l_4_2, l_4_3)
  if l_4_2 then
    local preceeding_key = l_4_0:preceeding_key({name = l_4_0:name()})
    if preceeding_key == nil or preceeding_key:action() == l_4_0:inverse_action() then
      l_4_0:_perform_action(l_4_0:inverse_action(), l_4_1)
    else
      l_4_0:_perform_action(l_4_0:action(), l_4_1)
    end
  end
end

l_0_0.play = l_0_1
l_0_0 = CoreGuiCutsceneKey
l_0_1 = function(l_5_0)
  return l_5_0:action() == "show" and "hide" or "show"
end

l_0_0.inverse_action = l_0_1
l_0_0 = CoreGuiCutsceneKey
l_0_1 = function(l_6_0, l_6_1, l_6_2)
  l_6_2:set_gui_visible(l_6_0:name(), l_6_1 == "show")
end

l_0_0._perform_action = l_0_1
l_0_0 = CoreGuiCutsceneKey
l_0_1 = function(l_7_0, l_7_1)
  return table.contains(l_7_0.VALID_ACTIONS, l_7_1)
end

l_0_0.is_valid_action = l_0_1
l_0_0 = CoreGuiCutsceneKey
l_0_1 = function(l_8_0, l_8_1)
  return DB:has("gui", l_8_1)
end

l_0_0.is_valid_name = l_0_1
l_0_0 = CoreGuiCutsceneKey
l_0_1 = function(l_9_0, l_9_1)
  l_9_1:freeze()
  l_9_1:clear()
  local value = l_9_0:name()
  for _,name in ipairs(managers.database:list_entries_of_type("gui")) do
    l_9_1:append(name)
    if name == value then
      l_9_1:set_value(value)
    end
  end
  l_9_1:thaw()
end

l_0_0.refresh_control_for_name = l_0_1

