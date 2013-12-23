-- Decompiled using luadec 2.0.1 by sztupy (http://winmo.sztupy.hu)
-- Command line was: F:\SteamLibrary\SteamApps\common\PAYDAY 2\lua\core\lib\managers\mission\coreelementplaysound.luac 

core:module("CoreElementPlaySound")
core:import("CoreMissionScriptElement")
if not ElementPlaySound then
  ElementPlaySound = class(CoreMissionScriptElement.MissionScriptElement)
end
ElementPlaySound.init = function(l_1_0, ...)
  ElementPlaySound.super.init(l_1_0, ...)
   -- DECOMPILER ERROR: Confused about usage of registers for local variables.

end

ElementPlaySound.client_on_executed = function(l_2_0, ...)
  l_2_0:on_executed(...)
   -- DECOMPILER ERROR: Confused about usage of registers for local variables.

end

ElementPlaySound.on_executed = function(l_3_0, l_3_1)
  if not l_3_0._values.enabled then
    return 
  end
  if l_3_0._source then
    l_3_0._source:stop()
  end
  if l_3_0._values.use_instigator and Network:is_server() and l_3_1:id() ~= -1 then
    l_3_1:sound():say(l_3_0._values.sound_event, true, not l_3_0._values.append_prefix, true)
    do return end
    if not l_3_0._values.elements or #l_3_0._values.elements == 0 then
      l_3_0:_play_sound()
    else
      if Network:is_server() then
        l_3_0:_play_sound_on_elements()
      end
    end
  end
  ElementPlaySound.super.on_executed(l_3_0, l_3_1)
end

ElementPlaySound._play_sound_on_elements = function(l_4_0)
  local f = function(l_1_0)
    if l_1_0:id() ~= -1 then
      l_1_0:sound():say(self._values.sound_event, true, not self._values.append_prefix, true)
    end
   end
  for _,id in ipairs(l_4_0._values.elements) do
    local element = l_4_0:get_mission_element(id)
    element:execute_on_all_units(f)
  end
end

ElementPlaySound._play_sound = function(l_5_0)
  if l_5_0._values.sound_event then
    if l_5_0._source then
      l_5_0._source:stop()
    end
    l_5_0._source = SoundDevice:create_source(l_5_0._editor_name)
    l_5_0._source:set_position(l_5_0._values.position)
    l_5_0._source:set_orientation(l_5_0._values.rotation)
    if l_5_0._source:post_event(l_5_0._values.sound_event, (callback(l_5_0, l_5_0, "sound_ended")), nil, "end_of_event") then
      l_5_0._mission_script:add_save_state_cb(l_5_0._id)
    else
      if Application:editor() then
        managers.editor:output_error("Cant play sound event nil [" .. l_5_0._editor_name .. "]")
      end
    end
  end
end

ElementPlaySound.sound_ended = function(l_6_0, ...)
  l_6_0._mission_script:remove_save_state_cb(l_6_0._id)
   -- DECOMPILER ERROR: Confused about usage of registers for local variables.

end

ElementPlaySound.operation_remove = function(l_7_0)
  if l_7_0._source then
    l_7_0._source:stop()
    l_7_0:sound_ended()
  end
end

ElementPlaySound.save = function(l_8_0, l_8_1)
end

ElementPlaySound.load = function(l_9_0, l_9_1)
  l_9_0:_play_sound()
end

ElementPlaySound.stop_simulation = function(l_10_0)
  if l_10_0._source then
    l_10_0._source:stop()
  end
  ElementPlaySound.super.stop_simulation(l_10_0)
end

ElementPlaySound.destroy = function(l_11_0)
  if l_11_0._source then
    l_11_0._source:stop()
    l_11_0._source:delete()
    l_11_0._source = nil
    l_11_0:sound_ended()
  end
end


