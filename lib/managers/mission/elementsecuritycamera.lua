-- Decompiled using luadec 2.0.1 by sztupy (http://winmo.sztupy.hu)
-- Command line was: F:\SteamLibrary\SteamApps\common\PAYDAY 2\lua\lib\managers\mission\elementsecuritycamera.luac 

core:import("CoreMissionScriptElement")
if not ElementSecurityCamera then
  ElementSecurityCamera = class(CoreMissionScriptElement.MissionScriptElement)
end
ElementSecurityCamera.init = function(l_1_0, ...)
  ElementSecurityCamera.super.init(l_1_0, ...)
  l_1_0._triggers = {}
   -- DECOMPILER ERROR: Confused about usage of registers for local variables.

end

ElementSecurityCamera.on_executed = function(l_2_0, l_2_1)
  if not l_2_0._values.enabled or Network:is_client() then
    return 
  end
  if not l_2_0._values.camera_u_id then
    return 
  end
  local camera_unit = l_2_0:_fetch_unit_by_unit_id(l_2_0._values.camera_u_id)
  if not camera_unit then
    return 
  end
   -- DECOMPILER ERROR: Confused while interpreting a jump as a 'while'

end
local ai_state = true
local settings = nil
if ai_state or l_2_0._values.apply_settings then
  settings = {yaw = l_2_0._values.yaw, pitch = l_2_0._values.pitch, fov = l_2_0._values.fov, detection_range = l_2_0._values.detection_range * 100, suspicion_range = l_2_0._values.suspicion_range * 100, detection_delay = {l_2_0._values.detection_delay_min, l_2_0._values.detection_delay_max}}
end
camera_unit:base():set_detection_enabled(ai_state, settings, l_2_0)
ElementSpecialObjective.super.on_executed(l_2_0, l_2_1)
end

ElementSecurityCamera.client_on_executed = function(l_3_0, ...)
   -- DECOMPILER ERROR: Confused about usage of registers for local variables.

end

ElementSecurityCamera._fetch_unit_by_unit_id = function(l_4_0, l_4_1)
  local unit = nil
  if Application:editor() then
    unit = managers.editor:unit_with_id(tonumber(l_4_1))
  else
    unit = managers.worlddefinition:get_unit_on_load(tonumber(l_4_1), callback(l_4_0, l_4_0, "_load_unit"))
  end
  return unit
end

ElementSecurityCamera._load_unit = function(l_5_0)
end

ElementSecurityCamera.on_script_activated = function(l_6_0)
  l_6_0._mission_script:add_save_state_cb(l_6_0._id)
end

ElementSecurityCamera.on_destroyed = function(l_7_0)
  if not l_7_0._values.enabled then
    return 
  end
  l_7_0._values.destroyed = true
  l_7_0:check_triggers("destroyed")
end

ElementSecurityCamera.on_alarm = function(l_8_0)
  if not l_8_0._values.enabled then
    return 
  end
  l_8_0._values.alarm = true
  l_8_0:check_triggers("alarm")
end

ElementSecurityCamera.add_trigger = function(l_9_0, l_9_1, l_9_2, l_9_3)
  if not l_9_0._triggers[l_9_2] then
    l_9_0._triggers[l_9_2] = {}
  end
  l_9_0._triggers[l_9_2][l_9_1] = {callback = l_9_3}
end

ElementSecurityCamera.remove_trigger = function(l_10_0, l_10_1, l_10_2)
  if l_10_0._triggers[l_10_2] then
    l_10_0._triggers[l_10_2][l_10_1] = nil
  end
end

ElementSecurityCamera.check_triggers = function(l_11_0, l_11_1, l_11_2)
  if not l_11_0._triggers[l_11_1] then
    return 
  end
  for id,cb_data in pairs(l_11_0._triggers[l_11_1]) do
    cb_data.callback(l_11_2)
  end
end

ElementSecurityCamera.save = function(l_12_0, l_12_1)
  l_12_1.enabled = l_12_0._values.enabled
  l_12_1.destroyed = l_12_0._values.destroyed
end

ElementSecurityCamera.load = function(l_13_0, l_13_1)
  l_13_0:set_enabled(l_13_1.enabled)
  l_13_0._values.destroyed = l_13_1.destroyed
end


