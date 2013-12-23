-- Decompiled using luadec 2.0.1 by sztupy (http://winmo.sztupy.hu)
-- Command line was: F:\SteamLibrary\SteamApps\common\PAYDAY 2\lua\core\lib\managers\camera\corecameradatainterpreter.luac 

core:module("CoreCameraDataInterpreter")
core:import("CoreClass")
local mvector3_add = mvector3.add
local mvector3_sub = mvector3.subtract
local mvector3_mul = mvector3.multiply
local mvector3_copy = mvector3.copy
local mvector3_rotate_with = mvector3.rotate_with
local mrotation_slerp = mrotation.slerp
local mrotation_mul = mrotation.multiply
local mrotation_set_zero = mrotation.set_zero
if not CameraDataInterpreter then
  CameraDataInterpreter = CoreClass.class()
end
CameraDataInterpreter.init = function(l_1_0, l_1_1)
  if l_1_1 then
    l_1_0._position = l_1_1._position
    l_1_0._rotation = l_1_1._rotation
    l_1_0._pivot_position = l_1_1._pivot_position
    l_1_0._pivot_rotation = l_1_1._pivot_rotation
    l_1_0._fov = l_1_1._fov
    l_1_0._dof_amount = l_1_1._dof_amount
    l_1_0._dof_near_min = l_1_1._dof_near_min
    l_1_0._dof_near_max = l_1_1._dof_near_max
    l_1_0._dof_far_min = l_1_1._dof_far_min
    l_1_0._dof_far_max = l_1_1._dof_far_max
  else
    l_1_0._position = Vector3(0, 0, 0)
    l_1_0._rotation = Rotation()
    l_1_0._pivot_position = nil
    l_1_0._pivot_rotation = nil
    l_1_0._fov = 0
    l_1_0._dof_amount = 0
    l_1_0._dof_near_min = 0
    l_1_0._dof_near_max = 0
    l_1_0._dof_far_min = 0
    l_1_0._dof_far_max = 0
  end
end

CameraDataInterpreter.reset = function(l_2_0)
  l_2_0._position = Vector3(0, 0, 0)
  l_2_0._rotation = Rotation()
  l_2_0._pivot_position = nil
  l_2_0._pivot_rotation = nil
  l_2_0._fov = 0
  l_2_0._dof_amount = 0
  l_2_0._dof_near_min = 0
  l_2_0._dof_near_max = 0
  l_2_0._dof_far_min = 0
  l_2_0._dof_far_max = 0
end

CameraDataInterpreter.position = function(l_3_0)
  return l_3_0._position
end

CameraDataInterpreter.set_position = function(l_4_0, l_4_1)
  l_4_0._position = l_4_1
end

CameraDataInterpreter.rotation = function(l_5_0)
  return l_5_0._rotation
end

CameraDataInterpreter.set_rotation = function(l_6_0, l_6_1)
  l_6_0._rotation = l_6_1
end

CameraDataInterpreter.set_pivot_position = function(l_7_0, l_7_1)
  l_7_0._pivot_position = l_7_1
end

CameraDataInterpreter.set_pivot_rotation = function(l_8_0, l_8_1)
  l_8_0._pivot_rotation = l_8_1
end

CameraDataInterpreter.fov = function(l_9_0)
  return l_9_0._fov
end

CameraDataInterpreter.set_fov = function(l_10_0, l_10_1)
  l_10_0._fov = l_10_1
end

CameraDataInterpreter.dof = function(l_11_0)
  return {amount = l_11_0._dof_amount, near_min = l_11_0._dof_near_min, near_max = l_11_0._dof_near_max, far_min = l_11_0._dof_far_min, far_max = l_11_0._dof_far_max}
end

CameraDataInterpreter.set_dof = function(l_12_0, l_12_1, l_12_2, l_12_3, l_12_4, l_12_5)
  l_12_0._dof_amount = l_12_1
  l_12_0._dof_near_min = l_12_2
  l_12_0._dof_near_max = l_12_3
  l_12_0._dof_far_min = l_12_4
  l_12_0._dof_far_max = l_12_5
end

CameraDataInterpreter.transform_with = function(l_13_0, l_13_1)
  if l_13_1._pivot_position then
    l_13_0._position = l_13_0._position + l_13_1._pivot_position:rotate_with(l_13_0._rotation)
  end
  if l_13_1._pivot_rotation then
    l_13_0._rotation = l_13_0._rotation * l_13_1._pivot_rotation
  end
  l_13_0._position = l_13_0._position + l_13_1._position:rotate_with(l_13_0._rotation)
  l_13_0._rotation = l_13_0._rotation * l_13_1._rotation
  l_13_0._fov = l_13_0._fov + l_13_1._fov
  l_13_0._dof_amount = l_13_0._dof_amount + l_13_1._dof_amount
  l_13_0._dof_near_min = l_13_0._dof_near_min + l_13_1._dof_near_min
  l_13_0._dof_near_max = l_13_0._dof_near_max + l_13_1._dof_near_max
  l_13_0._dof_far_min = l_13_0._dof_far_min + l_13_1._dof_far_min
  l_13_0._dof_far_max = l_13_0._dof_far_max + l_13_1._dof_far_max
end

CameraDataInterpreter.interpolate_to_target = function(l_14_0, l_14_1, l_14_2)
  local position = l_14_0._position
  l_14_0._position = mvector3_copy(l_14_1._position)
  mvector3_sub(l_14_0._position, position)
  mvector3_mul(l_14_0._position, l_14_2)
  mvector3_add(l_14_0._position, position)
  local rotation = Rotation()
  mrotation_slerp(rotation, l_14_0._rotation, l_14_1._rotation, l_14_2)
  l_14_0._rotation = rotation
  l_14_0._fov = l_14_0._fov + (l_14_1._fov - l_14_0._fov) * l_14_2
  l_14_0._dof_amount = l_14_0._dof_amount + (l_14_1._dof_amount - l_14_0._dof_amount) * l_14_2
  l_14_0._dof_near_min = l_14_0._dof_near_min + (l_14_1._dof_near_min - l_14_0._dof_near_min) * l_14_2
  l_14_0._dof_near_max = l_14_0._dof_near_max + (l_14_1._dof_near_max - l_14_0._dof_near_max) * l_14_2
  l_14_0._dof_far_min = l_14_0._dof_far_min + (l_14_1._dof_far_min - l_14_0._dof_far_min) * l_14_2
  l_14_0._dof_far_max = l_14_0._dof_far_max + (l_14_1._dof_far_max - l_14_0._dof_far_max) * l_14_2
end


