-- Decompiled using luadec 2.0.1 by sztupy (http://winmo.sztupy.hu)
-- Command line was: F:\SteamLibrary\SteamApps\common\PAYDAY 2\lua\core\lib\managers\camera\corecameramixer.luac 

core:module("CoreCameraMixer")
core:import("CoreClass")
local mvector3_add = mvector3.add
local mvector3_sub = mvector3.subtract
local mvector3_mul = mvector3.multiply
local mvector3_set = mvector3.set
local mvector3_copy = mvector3.copy
local mrotation_mul = mrotation.multiply
local mrotation_slerp = mrotation.slerp
local mrotation_set_zero = mrotation.set_zero
local safe_divide = function(l_1_0, l_1_1)
  if l_1_1 == 0 then
    return 1
  end
  return l_1_0 / l_1_1
end

if not CameraMixer then
  CameraMixer = CoreClass.class()
end
CameraMixer.init = function(l_2_0, l_2_1)
  l_2_0._name = l_2_1
  l_2_0._cameras = {}
end

CameraMixer.destroy = function(l_3_0)
  for index,camera in ipairs(l_3_0._cameras) do
    camera.camera:destroy()
  end
  l_3_0._cameras = {}
end

CameraMixer.add_camera = function(l_4_0, l_4_1, l_4_2)
  table.insert(l_4_0._cameras, {camera = l_4_1, blend_time = l_4_2, time = 0, cam_data = nil})
end

CameraMixer.stop = function(l_5_0)
  for index,camera in ipairs(l_5_0._cameras) do
    camera.camera:destroy()
  end
  l_5_0._cameras = {}
end

CameraMixer.update = function(l_6_0, l_6_1, l_6_2, l_6_3, l_6_4)
  for index,camera in ipairs(l_6_0._cameras) do
    local _camera = camera.camera
    local cam_data = l_6_2:new(l_6_1)
    for _,cam in ipairs(_camera._nodes) do
      local local_cam_data = l_6_2:new()
      cam:update(l_6_3, l_6_4, cam_data, local_cam_data)
      cam_data:transform_with(local_cam_data)
      mvector3_set(cam._position, cam_data._position)
      mrotation_set_zero(cam._rotation)
      mrotation_mul(cam._rotation, cam_data._rotation)
    end
    camera.cam_data = cam_data
  end
  local full_blend_index = 1
  for index,_camera in ipairs(l_6_0._cameras) do
    _camera.time = _camera.time + l_6_4
    local factor = nil
    if index > 1 then
      factor = math.sin(math.clamp(safe_divide(_camera.time, _camera.blend_time), 0, 1) * 90)
    else
      factor = 1
    end
    l_6_1:interpolate_to_target(_camera.cam_data, factor)
    if factor >= 1 then
      full_blend_index = index
    end
  end
  for i = 1, full_blend_index - 1 do
    l_6_0._cameras[1].camera:destroy()
    table.remove(l_6_0._cameras, 1)
  end
  for index,camera in ipairs(l_6_0._cameras) do
    assert(not camera.camera._destroyed)
  end
end

CameraMixer.debug_render = function(l_7_0, l_7_1, l_7_2)
  local pen = Draw:pen(Color(0.050000000745058, 0, 0, 1))
  for _,camera in ipairs(l_7_0._cameras) do
    local cam = camera.camera
    local parent_node = nil
    for _,node in ipairs(cam._nodes) do
      node:debug_render(l_7_1, l_7_2)
      if parent_node then
        pen:line(parent_node._position, node._position)
      end
      parent_node = node
    end
  end
end

CameraMixer.active_camera = function(l_8_0)
  local camera_count = #l_8_0._cameras
  if camera_count == 0 then
    return nil
  end
  return l_8_0._cameras[camera_count].camera
end

CameraMixer.cameras = function(l_9_0)
  local cameras = {}
  for _,camera in ipairs(l_9_0._cameras) do
    table.insert(cameras, camera.camera)
  end
  return cameras
end


