-- Decompiled using luadec 2.0.1 by sztupy (http://winmo.sztupy.hu)
-- Command line was: F:\SteamLibrary\SteamApps\common\PAYDAY 2\lua\core\lib\managers\camera\corespringcameranode.luac 

core:module("CoreSpringCameraNode")
core:import("CoreTransformCameraNode")
core:import("CoreClass")
core:import("CoreMath")
local mvector3_add = mvector3.add
local mvector3_sub = mvector3.subtract
local mvector3_mul = mvector3.multiply
local mvector3_neg = mvector3.negate
local mvector3_set_zero = mvector3.set_zero
local mvector3_set = mvector3.set
local mvector3_set_static = mvector3.set_static
local mvector3_copy = mvector3.copy
local mvector3_rotate_with = mvector3.rotate_with
if not SpringCameraNode then
  SpringCameraNode = CoreClass.class(CoreTransformCameraNode.TransformCameraNode)
end
SpringCameraNode.init = function(l_1_0, l_1_1)
  SpringCameraNode.super.init(l_1_0, l_1_1)
  l_1_0._force = Vector3(0, 0, 0)
  l_1_0._spring = l_1_1.spring
  l_1_0._max_displacement = l_1_1.max_displacement
  l_1_0._damping = l_1_1.damping
  l_1_0._force_scale = l_1_1.force_scale
  l_1_0._force_applicant = l_1_1.force_applicant:new()
  l_1_0._integrator_func = l_1_1.integrator_func
  l_1_0:reset()
end

SpringCameraNode.compile_settings = function(l_2_0, l_2_1)
  SpringCameraNode.super.compile_settings(l_2_0, l_2_1)
  if l_2_0:has_parameter("spring") then
    l_2_1.spring = math.string_to_vector(l_2_0:parameter("spring"))
  end
  if l_2_0:has_parameter("max_displacement") then
    l_2_1.max_displacement = math.string_to_vector(l_2_0:parameter("max_displacement"))
  end
  if l_2_0:has_parameter("damping") then
    l_2_1.damping = math.string_to_vector(l_2_0:parameter("damping"))
  end
  if l_2_0:has_parameter("force_scale") then
    l_2_1.force_scale = math.string_to_vector(l_2_0:parameter("force_scale"))
  end
  if l_2_0:has_parameter("force") then
    local force = l_2_0:parameter("force")
    if force == "acceleration" then
      l_2_1.force_applicant = SpringCameraAcceleration
    elseif force == "velocity" then
      l_2_1.force_applicant = SpringCameraVelocity
    elseif force == "position" then
      l_2_1.force_applicant = SpringCameraPosition
    else
      l_2_1.force_applicant = SpringCameraPosition
    end
  end
  if l_2_0:has_parameter("integrator") then
    local integrator = l_2_0:parameter("integrator")
    if integrator == "euler" then
      l_2_1.integrator_func = SpringCameraNode.euler_integration
    elseif integrator == "rk2" then
      l_2_1.integrator_func = SpringCameraNode.rk2_integration
    elseif integrator == "rk4" then
      l_2_1.integrator_func = SpringCameraNode.rk4_integration
    else
      l_2_1.integrator_func = SpringCameraNode.rk2_integration
    end
  end
end

SpringCameraNode.acceleration = function(l_3_0, l_3_1, l_3_2, l_3_3)
  local spring = l_3_0._spring
  local damping = l_3_0._damping
  return Vector3(-(l_3_1.x * spring.x) - damping.x * l_3_2.x + l_3_3.x, -(l_3_1.y * spring.y) - damping.y * l_3_2.y + l_3_3.y, -(l_3_1.z * spring.z) - damping.z * l_3_2.z + l_3_3.z)
end

SpringCameraNode.euler_integration = function(l_4_0, l_4_1, l_4_2)
  local displacement = l_4_0._displacement
  local velocity = l_4_0._velocity
  local a1 = l_4_0:acceleration(displacement, velocity, l_4_2)
  l_4_0._displacement = velocity + a1 * l_4_1
  l_4_0._velocity = l_4_0._displacement + velocity * l_4_1 + 0.5 * a1 * l_4_1 * l_4_1
end

SpringCameraNode.rk2_integration = function(l_5_0, l_5_1, l_5_2)
  local xf = l_5_0._displacement
  local vf = l_5_0._velocity
  local x1 = mvector3.copy(xf)
  local v1 = mvector3.copy(vf)
  local x2 = mvector3.copy(v1)
  mvector3_mul(x2, 0.5 * l_5_1)
  mvector3_add(x2, x1)
  local a = l_5_0:acceleration(x1, v1, l_5_2)
  local v2 = mvector3.copy(a)
  mvector3_mul(v2, 0.5 * l_5_1)
  mvector3_add(v2, v1)
  mvector3_set(xf, v2)
  mvector3_mul(xf, l_5_1)
  mvector3_add(xf, x1)
  mvector3_set(a, l_5_0:acceleration(x2, v2, l_5_2))
  mvector3_set(vf, a)
  mvector3_mul(vf, l_5_1)
  mvector3_add(vf, v1)
end

SpringCameraNode.rk4_integration = function(l_6_0, l_6_1, l_6_2)
  local x1 = l_6_0._displacement
  local v1 = l_6_0._velocity
  local a1 = l_6_0:acceleration(x1, v1, l_6_2)
  local x2 = x1 + 0.5 * v1 * l_6_1
  local v2 = v1 + 0.5 * a1 * l_6_1
  local a2 = l_6_0:acceleration(x2, v2, l_6_2)
  local x3 = x1 + 0.5 * v2 * l_6_1
  local v3 = v1 + 0.5 * a2 * l_6_1
  local a3 = l_6_0:acceleration(x3, v3, l_6_2)
  local x4 = x1 + v3 * l_6_1
  local v4 = v1 + a3 * l_6_1
  local a4 = l_6_0:acceleration(x4, v4, l_6_2)
  local xf = x1 + l_6_1 / 6 * (v1 + 2 * v2 + 2 * v3 + v4)
  local vf = v1 + l_6_1 / 6 * (a1 + 2 * a2 + 2 * a3 + a4)
  l_6_0._displacement = xf
  l_6_0._velocity = vf
end

SpringCameraNode.update = function(l_7_0, l_7_1, l_7_2, l_7_3, l_7_4)
  local displacement = l_7_0._displacement
  local max_displacement = l_7_0._max_displacement
  local force = l_7_0._force
  local force_scale = l_7_0._force_scale
  l_7_0._force_applicant:force(l_7_1, l_7_2, force, l_7_3._position, l_7_3._rotation)
  mvector3_set_static(force, force.x * force_scale.x, force.y * force_scale.y, force.z * force_scale.z)
  l_7_0:_integrator_func(l_7_2, force)
  mvector3_set_static(displacement, math.clamp(displacement.x, -max_displacement.x, max_displacement.x), math.clamp(displacement.y, -max_displacement.y, max_displacement.y), math.clamp(displacement.z, -max_displacement.z, max_displacement.z))
  mvector3_set(l_7_0._local_position, displacement)
  SpringCameraNode.super.update(l_7_0, l_7_1, l_7_2, l_7_3, l_7_4)
end

SpringCameraNode.reset = function(l_8_0)
  l_8_0._velocity = Vector3(0, 0, 0)
  l_8_0._displacement = Vector3(0, 0, 0)
  if l_8_0._force_applicant then
    l_8_0._force_applicant:reset()
  end
end

SpringCameraNode.debug_render = function(l_9_0, l_9_1, l_9_2)
  SpringCameraNode.super.debug_render(l_9_0, l_9_1, l_9_2)
  local start_brush = Draw:brush(Color(0.30000001192093, 1, 0, 0))
  local end_brush = Draw:brush(Color(0.30000001192093, 0, 1, 0))
  local line_pen = (Draw:pen(Color(0.30000001192093, 0, 0, 1)))
  local parent_position = nil
  start_brush:sphere(l_9_0:parent_camera():position(), 1)
  end_brush:sphere(l_9_0:position(), 1)
  line_pen:line(l_9_0:parent_camera():position(), l_9_0:position())
  local line_pen2 = Draw:pen(Color(0.30000001192093, 1, 0, 1))
  line_pen2:line(l_9_0:position(), l_9_0:position() + l_9_0._force:rotate_with(l_9_0:rotation()))
end

if not SpringCameraForce then
  SpringCameraForce = CoreClass.class()
end
SpringCameraForce.init = function(l_10_0)
end

SpringCameraForce.force = function(l_11_0, l_11_1, l_11_2, l_11_3, l_11_4, l_11_5)
end

SpringCameraForce.reset = function(l_12_0)
end

if not SpringCameraPosition then
  SpringCameraPosition = CoreClass.class(SpringCameraForce)
end
SpringCameraPosition.init = function(l_13_0)
  l_13_0:reset()
end

SpringCameraPosition.force = function(l_14_0, l_14_1, l_14_2, l_14_3, l_14_4, l_14_5)
  if not l_14_0._reset then
    mvector3_set(l_14_3, l_14_4)
    mvector3_sub(l_14_3, l_14_0._previous_parent_position)
    mvector3_rotate_with(l_14_3, l_14_5:inverse())
    mvector3_neg(l_14_3)
  else
    mvector3_set_zero(l_14_3)
    l_14_0._reset = false
  end
  mvector3_set(l_14_0._previous_parent_position, l_14_4)
end

SpringCameraPosition.reset = function(l_15_0)
  l_15_0._reset = true
  l_15_0._previous_parent_position = Vector3(0, 0, 0)
end

if not SpringCameraVelocity then
  SpringCameraVelocity = CoreClass.class(SpringCameraForce)
end
SpringCameraVelocity.init = function(l_16_0)
  l_16_0:reset()
end

SpringCameraVelocity.force = function(l_17_0, l_17_1, l_17_2, l_17_3, l_17_4, l_17_5)
  if not l_17_0._reset then
    mvector3_set(l_17_3, l_17_4)
    mvector3_sub(l_17_3, l_17_0._previous_parent_position)
    mvector3_mul(l_17_3, 1 / l_17_2)
    local velocity = mvector3_copy(l_17_3)
    mvector3_sub(l_17_3, l_17_0._velocity)
    mvector3_set(l_17_0._velocity, velocity)
    mvector3_rotate_with(l_17_3, l_17_5:inverse())
    mvector3_neg(l_17_3)
  else
    mvector3_set_zero(l_17_3)
    mvector3_set_zero(l_17_0._velocity)
    l_17_0._reset = false
  end
  mvector3_set(l_17_0._previous_parent_position, l_17_4)
end

SpringCameraVelocity.reset = function(l_18_0)
  l_18_0._reset = true
  l_18_0._velocity = Vector3(0, 0, 0)
  l_18_0._previous_parent_position = Vector3(0, 0, 0)
end

if not SpringCameraAcceleration then
  SpringCameraAcceleration = CoreClass.class(SpringCameraForce)
end
SpringCameraAcceleration.init = function(l_19_0)
  l_19_0:reset()
end

SpringCameraAcceleration.force = function(l_20_0, l_20_1, l_20_2, l_20_3, l_20_4, l_20_5)
  if not l_20_0._reset then
    mvector3_set(l_20_3, l_20_4)
    mvector3_sub(l_20_3, l_20_0._previous_parent_position)
    mvector3_mul(l_20_3, 1 / l_20_2)
    local velocity = mvector3_copy(l_20_3)
    mvector3_sub(l_20_3, l_20_0._velocity)
    mvector3_mul(l_20_3, 1 / l_20_2)
    mvector3_set(l_20_0._velocity, velocity)
    mvector3_rotate_with(l_20_3, l_20_5:inverse())
    mvector3_neg(l_20_3)
  else
    mvector3_set_zero(l_20_3)
    mvector3_set_zero(l_20_0._velocity)
    l_20_0._reset = false
  end
  mvector3_set(l_20_0._previous_parent_position, l_20_4)
end

SpringCameraAcceleration.reset = function(l_21_0)
  l_21_0._reset = true
  l_21_0._velocity = Vector3(0, 0, 0)
  l_21_0._previous_parent_position = Vector3(0, 0, 0)
end


