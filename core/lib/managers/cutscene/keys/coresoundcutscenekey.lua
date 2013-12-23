-- Decompiled using luadec 2.0.1 by sztupy (http://winmo.sztupy.hu)
-- Command line was: F:\SteamLibrary\SteamApps\common\PAYDAY 2\lua\core\lib\managers\cutscene\keys\coresoundcutscenekey.luac 

require("core/lib/managers/cutscene/keys/CoreCutsceneKeyBase")
if not CoreSoundCutsceneKey then
  CoreSoundCutsceneKey = class(CoreCutsceneKeyBase)
end
CoreSoundCutsceneKey.ELEMENT_NAME = "sound"
CoreSoundCutsceneKey.NAME = "Sound"
CoreSoundCutsceneKey:register_serialized_attribute("bank", "")
CoreSoundCutsceneKey:register_serialized_attribute("cue", "")
CoreSoundCutsceneKey:register_serialized_attribute("unit_name", "")
CoreSoundCutsceneKey:register_serialized_attribute("object_name", "")
CoreSoundCutsceneKey:register_serialized_attribute("sync_to_video", false, toboolean)
CoreSoundCutsceneKey:attribute_affects("bank", "cue")
CoreSoundCutsceneKey.control_for_unit_name = CoreCutsceneKeyBase.standard_combo_box_control
CoreSoundCutsceneKey.control_for_object_name = CoreCutsceneKeyBase.standard_combo_box_control
CoreSoundCutsceneKey.control_for_bank = CoreCutsceneKeyBase.standard_combo_box_control
CoreSoundCutsceneKey.__tostring = function(l_1_0)
  return "Trigger sound \"" .. l_1_0:bank() .. "/" .. l_1_0:cue() .. "\" on \"" .. l_1_0:unit_name() .. "\"."
end

CoreSoundCutsceneKey.prime = function(l_2_0, l_2_1)
  l_2_0:sound():prime()
end

CoreSoundCutsceneKey.skip = function(l_3_0, l_3_1)
  l_3_0:stop()
end

CoreSoundCutsceneKey.can_evaluate_with_player = function(l_4_0, l_4_1)
  return true
end

CoreSoundCutsceneKey.play = function(l_5_0, l_5_1, l_5_2, l_5_3)
  if l_5_2 then
    l_5_0:stop()
  elseif not l_5_3 then
    if l_5_0:unit_name() ~= "" and l_5_0:object_name() ~= "" then
      l_5_0:sound():set_output(l_5_0:_unit_object(l_5_0:unit_name(), l_5_0:object_name()))
    end
    l_5_0:_trigger_sound()
  end
end

CoreSoundCutsceneKey.update = function(l_6_0, l_6_1, l_6_2)
  if l_6_0.is_in_cutscene_editor then
    l_6_0:handle_cutscene_editor_scrubbing(l_6_1, l_6_2)
  end
end

CoreSoundCutsceneKey.handle_cutscene_editor_scrubbing = function(l_7_0, l_7_1, l_7_2)
  if l_7_2 == l_7_0._last_evaluated_time then
    if not l_7_0._stopped_frame_count then
      l_7_0._stopped_frame_count = (not l_7_0._last_evaluated_time or 0) + 1
      if l_7_0._stopped_frame_count > 10 then
        l_7_0._stopped_frame_count = nil
        l_7_0:stop()
      else
        l_7_0._stopped_frame_count = nil
        if l_7_0._sound_abort_func == nil or l_7_2 < l_7_0._last_evaluated_time or l_7_2 - l_7_0._last_evaluated_time > 1 then
          l_7_0:_trigger_sound(l_7_2)
        end
      end
    end
    l_7_0._last_evaluated_time = l_7_2
     -- Warning: missing end command somewhere! Added here
  end
end

CoreSoundCutsceneKey.is_valid_unit_name = function(l_8_0, l_8_1)
  return (l_8_1 ~= nil and l_8_1 ~= "" and CoreCutsceneKeyBase.is_valid_unit_name(l_8_0, l_8_1))
end

CoreSoundCutsceneKey.is_valid_object_name = function(l_9_0, l_9_1)
  return (l_9_1 ~= nil and l_9_1 ~= "" and CoreCutsceneKeyBase.is_valid_object_name(l_9_0, l_9_1))
end

CoreSoundCutsceneKey.is_valid_bank = function(l_10_0, l_10_1)
  return l_10_1 and ((l_10_1 ~= "" and table.contains(Sound:soundbanks(), l_10_1)))
end

CoreSoundCutsceneKey.is_valid_cue = function(l_11_0, l_11_1)
  return not l_11_1 or (l_11_1 ~= "" and not l_11_0:is_valid_bank(l_11_0:bank()) or Sound:make_bank(l_11_0:bank(), l_11_1) ~= nil)
end

CoreSoundCutsceneKey.refresh_control_for_bank = function(l_12_0, l_12_1)
  l_12_1:freeze()
  l_12_1:clear()
  local value = l_12_0:bank()
  for _,bank_name in ipairs(Sound:soundbanks()) do
    l_12_1:append(bank_name)
    if bank_name == value then
      l_12_1:set_value(value)
    end
  end
  l_12_1:thaw()
end

CoreSoundCutsceneKey.refresh_control_for_unit_name = function(l_13_0, l_13_1)
  CoreCutsceneKeyBase.refresh_control_for_unit_name(l_13_0, l_13_1)
  l_13_1:append("")
  if l_13_0:unit_name() == "" then
    l_13_1:set_value("")
  end
end

CoreSoundCutsceneKey.refresh_control_for_object_name = function(l_14_0, l_14_1)
  CoreCutsceneKeyBase.refresh_control_for_object_name(l_14_0, l_14_1)
  l_14_1:append("")
  if l_14_0:object_name() == "" then
    l_14_1:set_value("")
  end
end

CoreSoundCutsceneKey.on_attribute_before_changed = function(l_15_0, l_15_1, l_15_2, l_15_3)
  if l_15_1 ~= "sync_to_video" then
    l_15_0:stop()
  end
end

CoreSoundCutsceneKey.on_attribute_changed = function(l_16_0, l_16_1, l_16_2, l_16_3)
  if l_16_1 == "bank" or l_16_1 == "cue" then
    l_16_0._sound = nil
    if l_16_0:is_valid() then
      l_16_0:prime()
    end
  end
end

CoreSoundCutsceneKey.sound = function(l_17_0)
  if l_17_0._sound == nil then
    l_17_0._sound = assert(Sound:make_bank(l_17_0:bank(), l_17_0:cue()), "Sound \"" .. l_17_0:bank() .. "/" .. l_17_0:cue() .. "\" not found.")
  end
  return l_17_0._sound
end

CoreSoundCutsceneKey.stop = function(l_18_0)
  if l_18_0._sound_abort_func then
    l_18_0._sound_abort_func()
    l_18_0._sound_abort_func = nil
  end
  l_18_0._last_evaluated_time = nil
end

CoreSoundCutsceneKey._trigger_sound = function(l_19_0, l_19_1)
  l_19_0:stop()
  local instance = l_19_0:sound():play(l_19_0:sync_to_video() and "running_offset" or "offset", l_19_1 or 0)
  if alive(instance) then
    l_19_0._sound_abort_func = function()
    if alive(instance) and instance:is_playing() then
      instance:stop()
    end
   end
  end
end


