-- Decompiled using luadec 2.0.1 by sztupy (http://winmo.sztupy.hu)
-- Command line was: F:\SteamLibrary\SteamApps\common\PAYDAY 2\lua\lib\units\cameras\missionaccesscamera.luac 

if not MissionAccessCamera then
  MissionAccessCamera = class()
end
MissionAccessCamera.init = function(l_1_0, l_1_1)
  l_1_0._unit = l_1_1
  l_1_0._camera = World:create_camera()
  l_1_0._default_fov = 57
  l_1_0._fov = l_1_0._default_fov
  l_1_0._camera:set_fov(l_1_0._default_fov)
  l_1_0._camera:set_near_range(15)
  l_1_0._camera:set_far_range(250000)
  l_1_0._viewport = managers.viewport:new_vp(0, 0, 1, 1, "MissionAccessCamera", CoreManagerBase.PRIO_WORLDCAMERA)
  l_1_0._director = l_1_0._viewport:director()
  l_1_0._shaker = l_1_0._director:shaker()
  l_1_0._camera_controller = l_1_0._director:make_camera(l_1_0._camera, Idstring("previs_camera"))
  l_1_0._viewport:set_camera(l_1_0._camera)
  l_1_0._viewport:set_environment(managers.environment_area:default_environment())
  l_1_0._director:set_camera(l_1_0._camera_controller)
  l_1_0._director:position_as(l_1_0._camera)
  l_1_0._camera_controller:set_both(l_1_0._unit)
end

MissionAccessCamera._setup_sound_listener = function(l_2_0)
  l_2_0._listener_id = managers.listener:add_listener("access_camera", l_2_0._camera, l_2_0._camera, nil, false)
  managers.listener:add_set("access_camera", {"access_camera"})
  l_2_0._listener_activation_id = managers.listener:activate_set("main", "access_camera")
  l_2_0._sound_check_object = managers.sound_environment:add_check_object({object = l_2_0._unit:orientation_object(), active = true, primary = true})
end

MissionAccessCamera.set_rotation = function(l_3_0, l_3_1)
  l_3_0._original_rotation = l_3_1
  l_3_0._unit:set_rotation(l_3_1)
end

MissionAccessCamera.start = function(l_4_0, l_4_1)
  l_4_0._playing = true
  l_4_0._unit:anim_stop(Idstring("camera_animation"))
  l_4_0._fov = l_4_0._default_fov
  l_4_0._viewport:set_active(true)
end

MissionAccessCamera.stop = function(l_5_0)
  l_5_0._viewport:set_active(false)
  l_5_0._unit:anim_stop(Idstring("camera_animation"))
  l_5_0._unit:anim_set_time(Idstring("camera_animation"), 0)
  l_5_0._playing = false
end

MissionAccessCamera.set_destroyed = function(l_6_0, l_6_1)
end

MissionAccessCamera.modify_fov = function(l_7_0, l_7_1)
  l_7_0._fov = math.clamp(l_7_0._fov + l_7_1, 25, 75)
  l_7_0._camera:set_fov(l_7_0._fov)
end

MissionAccessCamera.zoomed_value = function(l_8_0)
  return l_8_0._fov / l_8_0._default_fov
end

MissionAccessCamera.set_offset_rotation = function(l_9_0, l_9_1, l_9_2)
  if not l_9_0._offset_rotation then
    l_9_0._offset_rotation = Rotation()
  end
  l_9_1 = l_9_1 + mrotation.yaw(l_9_0._original_rotation)
  l_9_2 = l_9_2 + mrotation.pitch(l_9_0._original_rotation)
  mrotation.set_yaw_pitch_roll(l_9_0._offset_rotation, l_9_1, l_9_2, 0)
  l_9_0._unit:set_rotation(l_9_0._offset_rotation)
end

MissionAccessCamera.destroy = function(l_10_0)
  if l_10_0._viewport then
    l_10_0._viewport:destroy()
    l_10_0._viewport = nil
  end
  if alive(l_10_0._camera) then
    World:delete_camera(l_10_0._camera)
    l_10_0._camera = nil
  end
  if l_10_0._listener_id then
    managers.sound_environment:remove_check_object(l_10_0._sound_check_object)
    managers.listener:remove_listener(l_10_0._listener_id)
    managers.listener:remove_set("access_camera")
    l_10_0._listener_id = nil
  end
end


