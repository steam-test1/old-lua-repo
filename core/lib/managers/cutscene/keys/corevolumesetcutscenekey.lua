-- Decompiled using luadec 2.0.1 by sztupy (http://winmo.sztupy.hu)
-- Command line was: F:\SteamLibrary\SteamApps\common\PAYDAY 2\lua\core\lib\managers\cutscene\keys\corevolumesetcutscenekey.luac 

require("core/lib/managers/cutscene/keys/CoreCutsceneKeyBase")
if not CoreVolumeSetCutsceneKey then
  CoreVolumeSetCutsceneKey = class(CoreCutsceneKeyBase)
end
CoreVolumeSetCutsceneKey.ELEMENT_NAME = "volume_set"
CoreVolumeSetCutsceneKey.NAME = "Volume Set"
local l_0_0 = CoreVolumeSetCutsceneKey
local l_0_1 = {}
 -- DECOMPILER ERROR: No list found. Setlist fails

 -- DECOMPILER ERROR: Overwrote pending register.

 -- DECOMPILER ERROR: Overwrote pending register.

 -- DECOMPILER ERROR: Overwrote pending register.

l_0_0(l_0_1, "activate", "deactivate")
l_0_1, l_0_0, l_0_0.VALID_ACTIONS = l_0_0, CoreVolumeSetCutsceneKey, l_0_1
l_0_0 = CoreVolumeSetCutsceneKey
l_0_0, l_0_1 = l_0_0:register_serialized_attribute, l_0_0
l_0_0(l_0_1, "name", "")
l_0_0 = CoreVolumeSetCutsceneKey
l_0_1 = CoreCutsceneKeyBase
l_0_1 = l_0_1.standard_combo_box_control
l_0_0.control_for_action = l_0_1
l_0_0 = CoreVolumeSetCutsceneKey
l_0_1 = CoreCutsceneKeyBase
l_0_1 = l_0_1.standard_combo_box_control
l_0_0.control_for_name = l_0_1
l_0_0 = CoreVolumeSetCutsceneKey
l_0_1 = CoreCutsceneKeyBase
 -- DECOMPILER ERROR: Overwrote pending register.

l_0_1 = l_0_1:standard_combo_box_control_refresh
l_0_0.refresh_control_for_action = l_0_1
l_0_0 = CoreVolumeSetCutsceneKey
l_0_1 = function(l_1_0)
  return string.capitalize(l_1_0:action()) .. " volume set \"" .. l_1_0:name() .. "\"."
end

l_0_0.__tostring = l_0_1
l_0_0 = CoreVolumeSetCutsceneKey
l_0_1 = function(l_2_0, l_2_1)
  l_2_0:play(l_2_1, true)
end

l_0_0.unload = l_0_1
l_0_0 = CoreVolumeSetCutsceneKey
l_0_1 = function(l_3_0, l_3_1, l_3_2, l_3_3)
  if managers.volume == nil then
    return 
  end
  if l_3_2 then
    local preceeding_key = l_3_0:preceeding_key({name = l_3_0:name()})
    if preceeding_key == nil or preceeding_key:action() == l_3_0:inverse_action() then
      l_3_0:_perform_action(l_3_0:inverse_action())
    else
      l_3_0:_perform_action(l_3_0:action())
    end
  end
end

l_0_0.play = l_0_1
l_0_0 = CoreVolumeSetCutsceneKey
l_0_1 = function(l_4_0)
  return l_4_0:action() == "activate" and "deactivate" or "activate"
end

l_0_0.inverse_action = l_0_1
l_0_0 = CoreVolumeSetCutsceneKey
l_0_1 = function(l_5_0, l_5_1)
  if l_5_1 == "deactivate" and managers.volume:is_active(l_5_0:name()) then
    managers.volume:deactivate_set(l_5_0:name())
  elseif l_5_1 == "activate" and not managers.volume:is_active(l_5_0:name()) then
    managers.volume:activate_set(l_5_0:name())
  end
end

l_0_0._perform_action = l_0_1
l_0_0 = CoreVolumeSetCutsceneKey
l_0_1 = function(l_6_0, l_6_1)
  return table.contains(l_6_0.VALID_ACTIONS, l_6_1)
end

l_0_0.is_valid_action = l_0_1
l_0_0 = CoreVolumeSetCutsceneKey
l_0_1 = function(l_7_0, l_7_1)
  return managers.volume and managers.volume:is_valid_volume_set_name(l_7_1) or false
end

l_0_0.is_valid_name = l_0_1
l_0_0 = CoreVolumeSetCutsceneKey
l_0_1 = function(l_8_0, l_8_1)
  l_8_1:freeze()
  l_8_1:clear()
  if managers.volume then
    local value = l_8_0:name()
    for _,entry in ipairs(managers.volume:volume_set_names()) do
      l_8_1:append(entry)
      if entry == value then
        l_8_1:set_value(value)
      end
    end
  end
  l_8_1:thaw()
end

l_0_0.refresh_control_for_name = l_0_1

