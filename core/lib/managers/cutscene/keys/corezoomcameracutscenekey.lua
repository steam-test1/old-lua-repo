-- Decompiled using luadec 2.0.1 by sztupy (http://winmo.sztupy.hu)
-- Command line was: F:\SteamLibrary\SteamApps\common\PAYDAY 2\lua\core\lib\managers\cutscene\keys\corezoomcameracutscenekey.luac 

require("core/lib/managers/cutscene/keys/CoreCutsceneKeyBase")
if not CoreZoomCameraCutsceneKey then
  CoreZoomCameraCutsceneKey = class(CoreCutsceneKeyBase)
end
CoreZoomCameraCutsceneKey.ELEMENT_NAME = "camera_zoom"
CoreZoomCameraCutsceneKey.NAME = "Camera Zoom"
CoreZoomCameraCutsceneKey.DEFAULT_CAMERA_FOV = 55
local l_0_0 = CoreZoomCameraCutsceneKey
local l_0_1 = {}
l_0_1.Linear = function(l_1_0, l_1_1)
  return l_1_0
end

l_0_1["J curve"] = function(l_2_0, l_2_1)
  local b = 2 * (1 - l_2_1)
  local a = 1 - b
  return a * l_2_0 ^ 2 + b * l_2_0
end

l_0_1["S curve"] = function(l_3_0, l_3_1)
  local a = 1 + l_3_1 * 2
  local b = a + 1
  return b * l_3_0 ^ a - a * l_3_0 ^ b
end

l_0_0.INTERPOLATION_FUNCTIONS = l_0_1
l_0_0 = CoreZoomCameraCutsceneKey
l_0_0, l_0_1 = l_0_0:register_serialized_attribute, l_0_0
l_0_0(l_0_1, "start_fov", CoreZoomCameraCutsceneKey.DEFAULT_CAMERA_FOV, tonumber)
l_0_0 = CoreZoomCameraCutsceneKey
l_0_0, l_0_1 = l_0_0:register_serialized_attribute, l_0_0
l_0_0(l_0_1, "end_fov", CoreZoomCameraCutsceneKey.DEFAULT_CAMERA_FOV, tonumber)
l_0_0 = CoreZoomCameraCutsceneKey
l_0_0, l_0_1 = l_0_0:register_serialized_attribute, l_0_0
l_0_0(l_0_1, "transition_time", 0, tonumber)
l_0_0 = CoreZoomCameraCutsceneKey
l_0_0, l_0_1 = l_0_0:register_serialized_attribute, l_0_0
l_0_0(l_0_1, "interpolation", "Linear")
l_0_0 = CoreZoomCameraCutsceneKey
l_0_0, l_0_1 = l_0_0:register_serialized_attribute, l_0_0
l_0_0(l_0_1, "interpolation_bias", 0.5, function(l_4_0)
  return (tonumber(l_4_0) or 0) / 100
end
)
l_0_0 = CoreZoomCameraCutsceneKey
l_0_1 = function(l_5_0)
  return "Change camera zoom."
end

l_0_0.__tostring = l_0_1
l_0_0 = CoreZoomCameraCutsceneKey
l_0_1 = function(l_6_0, l_6_1)
  l_6_0.super.populate_from_editor(l_6_0, l_6_1)
  local camera_attributes = l_6_1:camera_attributes()
  l_6_0:set_start_fov(camera_attributes.fov)
  l_6_0:set_end_fov(camera_attributes.fov)
end

l_0_0.populate_from_editor = l_0_1
l_0_0 = CoreZoomCameraCutsceneKey
l_0_1 = function(l_7_0, l_7_1, l_7_2, l_7_3)
  if l_7_2 then
    local preceeding_key = l_7_0:preceeding_key()
    if preceeding_key then
      l_7_1:set_camera_attribute("fov", preceeding_key:end_fov())
    else
      l_7_1:set_camera_attribute("fov", CoreZoomCameraCutsceneKey.DEFAULT_CAMERA_FOV)
    end
  else
    l_7_1:set_camera_attribute("fov", l_7_0:start_fov())
  end
end

l_0_0.play = l_0_1
l_0_0 = CoreZoomCameraCutsceneKey
l_0_1 = function(l_8_0, l_8_1, l_8_2)
  local transition_time = l_8_0:transition_time()
  if transition_time <= 0 or not math.min(l_8_2 / transition_time, 1) then
    local t = l_8_2 > transition_time + 0.033333335071802 or 1
  end
  local alpha = l_8_0:_calc_interpolation(t)
  local fov = l_8_0:start_fov() + (l_8_0:end_fov() - l_8_0:start_fov()) * alpha
  l_8_1:set_camera_attribute("fov", fov)
end

l_0_0.update = l_0_1
l_0_0 = CoreZoomCameraCutsceneKey
l_0_1 = function(l_9_0, l_9_1)
  return not l_9_1 or (l_9_1 > 0 and l_9_1 < 180)
end

l_0_0.is_valid_start_fov = l_0_1
l_0_0 = CoreZoomCameraCutsceneKey
l_0_1 = function(l_10_0, l_10_1)
  return not l_10_1 or l_10_1 >= 0
end

l_0_0.is_valid_transition_time = l_0_1
l_0_0 = CoreZoomCameraCutsceneKey
l_0_1 = function(l_11_0, l_11_1)
  return l_11_0.INTERPOLATION_FUNCTIONS[l_11_1] ~= nil
end

l_0_0.is_valid_interpolation = l_0_1
l_0_0 = CoreZoomCameraCutsceneKey
l_0_1 = function(l_12_0, l_12_1)
  return not l_12_1 or (l_12_1 >= 0 and l_12_1 <= 1)
end

l_0_0.is_valid_interpolation_bias = l_0_1
l_0_0 = CoreZoomCameraCutsceneKey
l_0_1 = CoreZoomCameraCutsceneKey
l_0_1 = l_0_1.is_valid_start_fov
l_0_0.is_valid_end_fov = l_0_1
l_0_0 = CoreZoomCameraCutsceneKey
l_0_1 = CoreCutsceneKeyBase
l_0_1 = l_0_1.standard_combo_box_control
l_0_0.control_for_interpolation = l_0_1
l_0_0 = CoreZoomCameraCutsceneKey
l_0_1 = CoreCutsceneKeyBase
l_0_1 = l_0_1.standard_percentage_slider_control
l_0_0.control_for_interpolation_bias = l_0_1
l_0_0 = CoreZoomCameraCutsceneKey
l_0_1 = CoreCutsceneKeyBase
 -- DECOMPILER ERROR: Overwrote pending register.

l_0_1 = l_0_1:standard_combo_box_control_refresh
l_0_0.refresh_control_for_interpolation = l_0_1
l_0_0 = CoreZoomCameraCutsceneKey
l_0_1 = CoreCutsceneKeyBase
 -- DECOMPILER ERROR: Overwrote pending register.

l_0_1 = l_0_1:standard_percentage_slider_control_refresh
l_0_0.refresh_control_for_interpolation_bias = l_0_1
l_0_0 = CoreZoomCameraCutsceneKey
l_0_1 = function(l_14_0, l_14_1)
  local interpolation_func = l_14_0.INTERPOLATION_FUNCTIONS[l_14_0:interpolation()]
  return interpolation_func(l_14_1, math.clamp(l_14_0:interpolation_bias(), 0, 1))
end

l_0_0._calc_interpolation = l_0_1

