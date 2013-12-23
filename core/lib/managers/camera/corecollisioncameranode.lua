-- Decompiled using luadec 2.0.1 by sztupy (http://winmo.sztupy.hu)
-- Command line was: F:\SteamLibrary\SteamApps\common\PAYDAY 2\lua\core\lib\managers\camera\corecollisioncameranode.luac 

core:module("CoreCollisionCameraNode")
core:import("CoreTransformCameraNode")
core:import("CoreClass")
core:import("CoreMath")
if not CollisionCameraNode then
  CollisionCameraNode = CoreClass.class(CoreTransformCameraNode.TransformCameraNode)
end
CollisionCameraNode.init = function(l_1_0, l_1_1)
  CollisionCameraNode.super.init(l_1_0, l_1_1)
  l_1_0._pop_controller = SmootherPopController()
  l_1_0._update = CollisionCameraNode._update_smoother
  l_1_0._ignore_unit = l_1_1.ignore_unit
  l_1_0._pop_controller:set_parameter("smooth_radius", l_1_1.smooth_radius)
  l_1_0._pop_controller:set_parameter("near_radius", l_1_1.near_radius)
  l_1_0._pop_controller:set_parameter("precision", l_1_1.precision)
  l_1_0._camera_distance = 10000
  l_1_0._camera_max_velocity = l_1_1.max_velocity
  l_1_0._safe_position_var = l_1_1.safe_position_var
end

CollisionCameraNode.set_unit = function(l_2_0, l_2_1)
  l_2_0._unit = l_2_1
  if l_2_0._ignore_unit then
    l_2_0._pop_controller:set_parameter("ignore_units", {l_2_1})
  end
end

CollisionCameraNode.set_safe_position = function(l_3_0, l_3_1)
  l_3_0._safe_position = l_3_1
end

CollisionCameraNode.compile_settings = function(l_4_0, l_4_1)
  CollisionCameraNode.super.compile_settings(l_4_0, l_4_1)
  if l_4_0:parameter("ignore_unit") ~= "true" then
    l_4_1.ignore_unit = not l_4_0:has_parameter("ignore_unit")
    do return end
    l_4_1.ignore_unit = true
    if l_4_0:has_parameter("smooth_radius") then
      l_4_1.smooth_radius = tonumber(l_4_0:parameter("smooth_radius"))
    else
      l_4_1.smooth_radius = 30
    end
    if l_4_0:has_parameter("near_radius") then
      l_4_1.near_radius = tonumber(l_4_0:parameter("near_radius"))
    else
      l_4_1.near_radius = 5
    end
    if l_4_0:has_parameter("precision") then
      l_4_1.precision = tonumber(l_4_0:parameter("precision"))
    else
      l_4_1.precision = 0.0049999998882413
    end
    if l_4_0:has_parameter("max_velocity") then
      l_4_1.max_velocity = tonumber(l_4_0:parameter("max_velocity"))
    else
      l_4_1.max_velocity = 300
    end
     -- Warning: missing end command somewhere! Added here
  end
end

CollisionCameraNode.update = function(l_5_0, l_5_1, l_5_2, l_5_3, l_5_4)
  l_5_0._update(l_5_0, l_5_1, l_5_2, l_5_3, l_5_4)
  CollisionCameraNode.super.update(l_5_0, l_5_1, l_5_2, l_5_3, l_5_4)
end

CollisionCameraNode._update_smoother = function(l_6_0, l_6_1, l_6_2, l_6_3, l_6_4)
  local position = l_6_3._position
  local rotation = l_6_3._rotation
  local safe_position = l_6_0._safe_position
  local new_position = l_6_0._pop_controller:wanted_position(safe_position, position)
  l_6_0._local_position = new_position - position:rotate_with(rotation:inverse())
end

CollisionCameraNode._update_fast_smooth = function(l_7_0, l_7_1, l_7_2, l_7_3, l_7_4)
  local position = l_7_3._position
  local rotation = l_7_3._rotation
  local safe_position = l_7_0._safe_position
  if not safe_position then
    safe_position = position
  end
  local camera_direction = position - safe_position
  local camera_distance = camera_direction:length()
  if camera_distance > 0 then
    camera_direction = camera_direction * (1 / camera_distance)
    local fraction = l_7_0._pop_controller:wanted_position(safe_position, position)
    local collision_distance = fraction * camera_distance
    local new_distance = nil
    if collision_distance < l_7_0._camera_distance then
      new_distance = collision_distance
    else
      local diff = math.clamp(collision_distance - l_7_0._camera_distance, 0, l_7_0._camera_max_velocity * l_7_2)
      new_distance = l_7_0._camera_distance + diff
    end
    local new_position = safe_position + position - safe_position:normalized() * (new_distance)
    l_7_0._camera_distance = new_distance
    l_7_0._local_position = new_position - position:rotate_with(rotation:inverse())
  else
    l_7_0._local_position = Vector3(0, 0, 0)
  end
end

CollisionCameraNode.debug_render = function(l_8_0, l_8_1, l_8_2)
  local safe_position = l_8_0._camera_data[l_8_0._safe_position_var]
  local brush = Draw:brush(Color(0.30000001192093, 1, 1, 1))
  brush:sphere(safe_position, 1)
  local brush2 = Draw:brush(Color(0.30000001192093, 1, 0, 0))
  brush2:sphere(l_8_0._position, 1)
end


