-- Decompiled using luadec 2.0.1 by sztupy (http://winmo.sztupy.hu)
-- Command line was: F:\SteamLibrary\SteamApps\common\PAYDAY 2\lua\lib\units\cameras\waitingforplayerscamera.luac 

if not WaitingForPlayersCamera then
  WaitingForPlayersCamera = class()
end
WaitingForPlayersCamera.init = function(l_1_0, l_1_1)
  l_1_0._unit = l_1_1
  l_1_0._camera = World:create_camera()
  l_1_0._camera:set_fov(57)
  l_1_0._camera:set_near_range(7.5)
  l_1_0._camera:set_far_range(200000)
  l_1_0._viewport = managers.viewport:new_vp(0, 0.25, 1, 0.5, "WaitingForPlayersCamera", CoreManagerBase.PRIO_WORLDCAMERA)
  l_1_0._director = l_1_0._viewport:director()
  l_1_0._shaker = l_1_0._director:shaker()
  l_1_0._camera_controller = l_1_0._director:make_camera(l_1_0._camera, Idstring("previs_camera"))
  l_1_0._viewport:set_camera(l_1_0._camera)
  l_1_0._viewport:set_environment(managers.environment_area:default_environment())
  l_1_0._director:set_camera(l_1_0._camera_controller)
  l_1_0._director:position_as(l_1_0._camera)
  l_1_0._camera_controller:set_both(l_1_0._unit:get_object(Idstring("a_camera")))
end

WaitingForPlayersCamera._setup_sound_listener = function(l_2_0)
  l_2_0._listener_id = managers.listener:add_listener("wait_camera", l_2_0._camera, l_2_0._camera, nil, false)
  managers.listener:add_set("wait_camera", {"wait_camera"})
  l_2_0._listener_activation_id = managers.listener:activate_set("main", "wait_camera")
  l_2_0._sound_check_object = managers.sound_environment:add_check_object({object = l_2_0._unit:orientation_object(), active = true, primary = true})
end

WaitingForPlayersCamera.start = function(l_3_0, l_3_1)
  l_3_0._playing = true
  l_3_0._unit:anim_stop(Idstring("camera_animation"))
  l_3_0._unit:anim_set_time(Idstring("camera_animation"), l_3_1 or 0)
  l_3_0._unit:anim_play(Idstring("camera_animation"), 1)
  l_3_0._viewport:set_active(true)
end

WaitingForPlayersCamera.stop = function(l_4_0)
  l_4_0._viewport:set_active(false)
  l_4_0._unit:anim_stop(Idstring("camera_animation"))
  l_4_0._unit:anim_set_time(Idstring("camera_animation"), 0)
  l_4_0._playing = false
end

WaitingForPlayersCamera.update = function(l_5_0, l_5_1, l_5_2, l_5_3)
   -- DECOMPILER ERROR: unhandled construct in 'if'

  if l_5_0._playing and l_5_0._wait_t and l_5_0._wait_t < l_5_2 then
    l_5_0._wait_t = nil
    l_5_0:stop()
    do return end
    if not l_5_0._unit:anim_is_playing(Idstring("camera_animation")) then
      l_5_0._wait_t = l_5_2 + 4
    end
  end
end

WaitingForPlayersCamera.destroy = function(l_6_0)
  if l_6_0._viewport then
    l_6_0._viewport:destroy()
    l_6_0._viewport = nil
  end
  if alive(l_6_0._camera) then
    World:delete_camera(l_6_0._camera)
    l_6_0._camera = nil
  end
  if l_6_0._listener_id then
    managers.sound_environment:remove_check_object(l_6_0._sound_check_object)
    managers.listener:remove_listener(l_6_0._listener_id)
    managers.listener:remove_set("wait_camera")
    l_6_0._listener_id = nil
  end
end


