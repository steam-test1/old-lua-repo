-- Decompiled using luadec 2.0.1 by sztupy (http://winmo.sztupy.hu)
-- Command line was: F:\SteamLibrary\SteamApps\common\PAYDAY 2\lua\core\lib\managers\camera\coretransformcameranode.luac 

core:module("CoreTransformCameraNode")
core:import("CoreClass")
core:import("CoreMath")
local mvector3_add = mvector3.add
local mvector3_sub = mvector3.subtract
local mvector3_set = mvector3.set
local mvector3_rotate_with = mvector3.rotate_with
local mrotation_set_zero = mrotation.set_zero
local mrotation_mul = mrotation.multiply
if not TransformCameraNode then
  TransformCameraNode = CoreClass.class()
end
TransformCameraNode.init = function(l_1_0, l_1_1)
  l_1_0._child = nil
  l_1_0._parent_camera = nil
  l_1_0._local_position = l_1_1.position
  l_1_0._local_rotation = l_1_1.rotation
  l_1_0._local_fov = l_1_1.fov
  l_1_0._local_dof_near_min = l_1_1.dof_near_min
  l_1_0._local_dof_near_max = l_1_1.dof_near_max
  l_1_0._local_dof_far_min = l_1_1.dof_far_min
  l_1_0._local_dof_far_max = l_1_1.dof_far_max
  l_1_0._local_dof_amount = l_1_1.dof_amount
  l_1_0._position = Vector3(0, 0, 0)
  l_1_0._rotation = Rotation()
  l_1_0._name = l_1_1.name
  l_1_0._settings = l_1_1
end

TransformCameraNode.compile_settings = function(l_2_0, l_2_1)
  if l_2_0:has_parameter("name") then
    l_2_1.name = l_2_0:parameter("name")
  end
  if l_2_0:has_parameter("position") then
    l_2_1.position = CoreMath.string_to_vector(l_2_0:parameter("position"))
  else
    l_2_1.position = Vector3(0, 0, 0)
  end
  if l_2_0:has_parameter("rotation") then
    l_2_1.rotation = CoreMath.string_to_rotation(l_2_0:parameter("rotation"))
  else
    l_2_1.rotation = Rotation()
  end
  if l_2_0:has_parameter("fov") then
    l_2_1.fov = tonumber(l_2_0:parameter("fov"))
  else
    l_2_1.fov = 0
  end
  if l_2_0:has_parameter("dof_near_min") then
    l_2_1.dof_near_min = tonumber(l_2_0:parameter("dof_near_min"))
  else
    l_2_1.dof_near_min = 0
  end
  if l_2_0:has_parameter("dof_near_max") then
    l_2_1.dof_near_max = tonumber(l_2_0:parameter("dof_near_max"))
  else
    l_2_1.dof_near_max = 0
  end
  if l_2_0:has_parameter("dof_far_min") then
    l_2_1.dof_far_min = tonumber(l_2_0:parameter("dof_far_min"))
  else
    l_2_1.dof_far_min = 0
  end
  if l_2_0:has_parameter("dof_far_max") then
    l_2_1.dof_far_max = tonumber(l_2_0:parameter("dof_far_max"))
  else
    l_2_1.dof_far_max = 0
  end
  if l_2_0:has_parameter("dof_amount") then
    l_2_1.dof_amount = tonumber(l_2_0:parameter("dof_amount"))
  else
    l_2_1.dof_amount = 0
  end
end

TransformCameraNode.destroy = function(l_3_0)
  l_3_0._child = nil
  l_3_0._parent_camera = nil
end

TransformCameraNode.name = function(l_4_0)
  return l_4_0._name
end

TransformCameraNode.set_parent = function(l_5_0, l_5_1)
  l_5_1._child = l_5_0
  l_5_0._parent_camera = l_5_1
end

TransformCameraNode.child = function(l_6_0)
  return l_6_0._child
end

TransformCameraNode.set_local_position = function(l_7_0, l_7_1)
  l_7_0._local_position = l_7_1
end

TransformCameraNode.set_local_rotation = function(l_8_0, l_8_1)
  l_8_0._local_rotation = l_8_1
end

TransformCameraNode.set_local_position_from_world_position = function(l_9_0, l_9_1)
  local parent_camera = l_9_0._parent_camera
  if parent_camera then
    local parent_position = parent_camera:position()
    local parent_rotation = parent_camera:rotation()
    mvector3_set(l_9_0._local_position, l_9_1)
    mvector3_sub(l_9_0._local_position, parent_camera:position())
    mvector3_rotate_with(l_9_0._local_position, parent_camera:rotation():inverse())
  else
    mvector3_set(l_9_0._local_position, l_9_1)
  end
end

TransformCameraNode.set_local_rotation_from_world_rotation = function(l_10_0, l_10_1)
  local parent_camera = l_10_0._parent_camera
  if parent_camera then
    local parent_rotation = parent_camera:rotation()
    l_10_0._local_rotation = parent_rotation:inverse() * l_10_1
  else
    l_10_0._local_rotation = l_10_1
  end
end

TransformCameraNode.position = function(l_11_0)
  return l_11_0._position
end

TransformCameraNode.rotation = function(l_12_0)
  return l_12_0._rotation
end

TransformCameraNode.local_position = function(l_13_0)
  return l_13_0._local_position
end

TransformCameraNode.local_rotation = function(l_14_0)
  return l_14_0._local_rotation
end

TransformCameraNode.update = function(l_15_0, l_15_1, l_15_2, l_15_3, l_15_4)
  if l_15_0._pivot_position then
    l_15_4:set_pivot_position(l_15_0._pivot_position)
  end
  if l_15_0._pivot_rotation then
    l_15_4:set_pivot_rotation(l_15_0._pivot_rotation)
  end
  l_15_4:set_position(l_15_0._local_position)
  l_15_4:set_rotation(l_15_0._local_rotation)
  l_15_4:set_fov(l_15_0._local_fov)
  l_15_4:set_dof(l_15_0._local_dof_amount, l_15_0._local_dof_near_min, l_15_0._local_dof_near_max, l_15_0._local_dof_far_min, l_15_0._local_dof_far_max)
end

TransformCameraNode.debug_render = function(l_16_0, l_16_1, l_16_2)
  local x_pen = Draw:pen(Color(0.050000000745058, 1, 0, 0))
  local y_pen = Draw:pen(Color(0.050000000745058, 0, 1, 0))
  local z_pen = Draw:pen(Color(0.050000000745058, 0, 0, 1))
  local position = l_16_0._position
  local rotation = l_16_0._rotation
  x_pen:line(position, position + rotation:x() * 2)
  y_pen:line(position, position + rotation:y() * 2)
  z_pen:line(position, position + rotation:z() * 2)
  local brush = Draw:brush(Color(0.30000001192093, 1, 1, 1))
  brush:sphere(position, 1)
end

TransformCameraNode.parent_camera = function(l_17_0)
  return l_17_0._parent_camera
end


