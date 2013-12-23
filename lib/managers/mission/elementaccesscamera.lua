-- Decompiled using luadec 2.0.1 by sztupy (http://winmo.sztupy.hu)
-- Command line was: F:\SteamLibrary\SteamApps\common\PAYDAY 2\lua\lib\managers\mission\elementaccesscamera.luac 

core:import("CoreMissionScriptElement")
if not ElementAccessCamera then
  ElementAccessCamera = class(CoreMissionScriptElement.MissionScriptElement)
end
ElementAccessCamera.init = function(l_1_0, ...)
  ElementAccessCamera.super.init(l_1_0, ...)
  l_1_0._camera_unit = nil
  l_1_0._triggers = {}
   -- DECOMPILER ERROR: Confused about usage of registers for local variables.

end

ElementAccessCamera.on_script_activated = function(l_2_0)
  if l_2_0._values.camera_u_id then
    local id = l_2_0._values.camera_u_id
    local unit = nil
    if Global.running_simulation then
      unit = managers.editor:unit_with_id(id)
    else
      unit = managers.worlddefinition:get_unit_on_load(id, callback(l_2_0, l_2_0, "_load_unit"))
    end
    if unit then
      unit:base():set_access_camera_mission_element(l_2_0)
      l_2_0._camera_unit = unit
    end
  end
  l_2_0._has_fetched_units = true
  l_2_0._mission_script:add_save_state_cb(l_2_0._id)
end

ElementAccessCamera._load_unit = function(l_3_0, l_3_1)
  l_3_1:base():set_access_camera_mission_element(l_3_0)
  l_3_0._camera_unit = l_3_1
end

ElementAccessCamera.client_on_executed = function(l_4_0, ...)
   -- DECOMPILER ERROR: Confused about usage of registers for local variables.

end

ElementAccessCamera.on_executed = function(l_5_0, l_5_1)
  if not l_5_0._values.enabled then
    return 
  end
  ElementAccessCamera.super.on_executed(l_5_0, l_5_1)
end

ElementAccessCamera.access_camera_operation_destroy = function(l_6_0)
  l_6_0._values.destroyed = true
  l_6_0:check_triggers("destroyed")
end

ElementAccessCamera.add_trigger = function(l_7_0, l_7_1, l_7_2, l_7_3)
  if not l_7_0._triggers[l_7_2] then
    l_7_0._triggers[l_7_2] = {}
  end
  l_7_0._triggers[l_7_2][l_7_1] = {callback = l_7_3}
end

ElementAccessCamera.remove_trigger = function(l_8_0, l_8_1, l_8_2)
  if l_8_0._triggers[l_8_2] then
    l_8_0._triggers[l_8_2][l_8_1] = nil
  end
end

ElementAccessCamera.trigger_accessed = function(l_9_0, l_9_1)
  if Network:is_client() then
    managers.network:session():send_to_host("to_server_access_camera_trigger", l_9_0._id, "accessed", l_9_1)
  else
    l_9_0:check_triggers("accessed", l_9_1)
  end
end

ElementAccessCamera.check_triggers = function(l_10_0, l_10_1, l_10_2)
  if not l_10_0._triggers[l_10_1] then
    return 
  end
  for id,cb_data in pairs(l_10_0._triggers[l_10_1]) do
    cb_data.callback(l_10_2)
  end
end

ElementAccessCamera.enabled = function(l_11_0, ...)
  if alive(l_11_0._camera_unit) then
    return l_11_0._camera_unit:enabled()
  end
  return ElementAccessCamera.super.enabled(l_11_0, ...)
   -- DECOMPILER ERROR: Confused about usage of registers for local variables.

end

ElementAccessCamera.has_camera_unit = function(l_12_0)
   -- DECOMPILER ERROR: Confused while interpreting a jump as a 'while'

end
return true
end

ElementAccessCamera.camera_unit = function(l_13_0)
  if alive(l_13_0._camera_unit) then
    return l_13_0._camera_unit
  end
  return nil
end

ElementAccessCamera.camera_position = function(l_14_0)
  if alive(l_14_0._camera_unit) then
    return l_14_0._camera_unit:get_object(Idstring("CameraLens")):position()
  end
  return l_14_0:value("position")
end

ElementAccessCamera.save = function(l_15_0, l_15_1)
  l_15_1.enabled = l_15_0._values.enabled
  l_15_1.destroyed = l_15_0._values.destroyed
end

ElementAccessCamera.load = function(l_16_0, l_16_1)
  l_16_0:set_enabled(l_16_1.enabled)
  l_16_0._values.destroyed = l_16_1.destroyed
  if not l_16_0._has_fetched_units then
    l_16_0:on_script_activated()
  end
end

if not ElementAccessCameraOperator then
  ElementAccessCameraOperator = class(CoreMissionScriptElement.MissionScriptElement)
end
ElementAccessCameraOperator.init = function(l_17_0, ...)
  ElementAccessCameraOperator.super.init(l_17_0, ...)
   -- DECOMPILER ERROR: Confused about usage of registers for local variables.

end

ElementAccessCameraOperator.client_on_executed = function(l_18_0, ...)
  l_18_0:on_executed(...)
   -- DECOMPILER ERROR: Confused about usage of registers for local variables.

end

ElementAccessCameraOperator.on_executed = function(l_19_0, l_19_1)
  if not l_19_0._values.enabled then
    return 
  end
  for _,id in ipairs(l_19_0._values.elements) do
    local element = l_19_0:get_mission_element(id)
    if element and l_19_0._values.operation == "destroy" then
      element:access_camera_operation_destroy()
    end
  end
  ElementAccessCameraOperator.super.on_executed(l_19_0, l_19_1)
end

if not ElementAccessCameraTrigger then
  ElementAccessCameraTrigger = class(CoreMissionScriptElement.MissionScriptElement)
end
ElementAccessCameraTrigger.init = function(l_20_0, ...)
  ElementAccessCameraTrigger.super.init(l_20_0, ...)
   -- DECOMPILER ERROR: Confused about usage of registers for local variables.

end

ElementAccessCameraTrigger.on_script_activated = function(l_21_0)
  for _,id in ipairs(l_21_0._values.elements) do
    local element = l_21_0:get_mission_element(id)
    element:add_trigger(l_21_0._id, l_21_0._values.trigger_type, callback(l_21_0, l_21_0, "on_executed"))
  end
end

ElementAccessCameraTrigger.client_on_executed = function(l_22_0, ...)
   -- DECOMPILER ERROR: Confused about usage of registers for local variables.

end

ElementAccessCameraTrigger.on_executed = function(l_23_0, l_23_1)
  if not l_23_0._values.enabled then
    return 
  end
  ElementAccessCameraTrigger.super.on_executed(l_23_0, l_23_1)
end


