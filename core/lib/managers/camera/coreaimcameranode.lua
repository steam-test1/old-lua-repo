-- Decompiled using luadec 2.0.1 by sztupy (http://winmo.sztupy.hu)
-- Command line was: F:\SteamLibrary\SteamApps\common\PAYDAY 2\lua\core\lib\managers\camera\coreaimcameranode.luac 

core:module("CoreAimCameraNode")
core:import("CoreTransformCameraNode")
core:import("CoreClass")
local mvector3_add = mvector3.add
local mvector3_set = mvector3.set
local mvector3_copy = mvector3.copy
local mvector3_negate = mvector3.negate
local mvector3_rotate_with = mvector3.rotate_with
local mvector3_normalize = mvector3.normalize
local mrotation_set_zero = mrotation.set_zero
local mrotation_mul = mrotation.multiply
local mrotation_inv = mrotation.invert
if not AimCameraNode then
  AimCameraNode = CoreClass.class(CoreTransformCameraNode.TransformCameraNode)
end
AimCameraNode.init = function(l_1_0, l_1_1)
  AimCameraNode.super.init(l_1_0, l_1_1)
  l_1_0._pitch_offset = l_1_1.pitch_offset
end

AimCameraNode.compile_settings = function(l_2_0, l_2_1)
  AimCameraNode.super.compile_settings(l_2_0, l_2_1)
  if l_2_0:parameter("pitch_offset") ~= "true" then
    l_2_1.pitch_offset = not l_2_0:has_parameter("pitch_offset")
    do return end
    l_2_1.pitch_offset = false
     -- Warning: missing end command somewhere! Added here
  end
end

AimCameraNode.set_eye_target_position = function(l_3_0, l_3_1)
  l_3_0._eye_target_position = l_3_1
end

AimCameraNode.update = function(l_4_0, l_4_1, l_4_2, l_4_3, l_4_4)
  local eye_target_position = l_4_0._eye_target_position
  if not eye_target_position then
    return 
  end
  local parent_position = l_4_3:position()
  local parent_rotation = l_4_3:rotation()
  if l_4_0._pitch_offset then
    mvector3_set(l_4_0._local_position, l_4_0:_update_pitch_offset(parent_position, parent_rotation))
  end
  local direction = mvector3_copy(l_4_0._local_position)
  mvector3_rotate_with(direction, parent_rotation)
  mvector3_add(direction, parent_position)
  mvector3_negate(direction)
  mvector3_add(direction, eye_target_position)
  mvector3_normalize(direction)
  mrotation_set_zero(l_4_0._local_rotation)
  mrotation_mul(l_4_0._local_rotation, parent_rotation)
  mrotation_inv(l_4_0._local_rotation)
  mrotation_mul(l_4_0._local_rotation, Rotation(direction, math.UP))
  l_4_4:set_constraints(Rotation(), 10, 10)
  AimCameraNode.super.update(l_4_0, l_4_1, l_4_2, l_4_3, l_4_4)
end

AimCameraNode._update_pitch_offset = function(l_5_0, l_5_1, l_5_2)
  local current_position = l_5_1 + l_5_0:local_position():rotate_with(l_5_2)
  local current_position_to_eye_target = l_5_0._camera_data.eye_target_position - current_position
  if current_position_to_eye_target:length() > 0 then
    local polar = current_position_to_eye_target:to_polar_with_reference(l_5_2:y(), l_5_2:z())
    local pitch = polar.pitch
    local yaw = polar.spin
    if pitch < 0 and pitch > -90 then
      local normalized_pitch = math.abs(pitch) / 90
      local y_offset = -math.sign(pitch) * (math.sin(270 + normalized_pitch * 180) * 0.5 + 0.5) * 90
      local offset = Vector3(0, y_offset, 0)
      return offset:rotate_with(Rotation(math.UP, yaw))
    end
  end
  return l_5_0:local_position()
end


