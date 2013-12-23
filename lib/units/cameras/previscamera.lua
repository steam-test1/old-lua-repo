-- Decompiled using luadec 2.0.1 by sztupy (http://winmo.sztupy.hu)
-- Command line was: F:\SteamLibrary\SteamApps\common\PAYDAY 2\lua\lib\units\cameras\previscamera.luac 

if not PrevisCamera then
  PrevisCamera = class()
end
PrevisCamera.init = function(l_1_0, l_1_1)
  l_1_0._unit = l_1_1
  l_1_0._camera = World:create_camera()
  l_1_0._camera:set_fov(57)
  l_1_0._camera:set_near_range(7.5)
  l_1_0._camera:set_far_range(200000)
  l_1_0._viewport = managers.viewport:new_vp(0, 0, 1, 1, "previscamera", CoreManagerBase.PRIO_WORLDCAMERA)
  l_1_0._director = l_1_0._viewport:director()
  l_1_0._shaker = l_1_0._director:shaker()
  l_1_0._camera_controller = l_1_0._director:make_camera(l_1_0._camera, Idstring("previs_camera"))
  l_1_0._viewport:set_camera(l_1_0._camera)
  l_1_0._director:set_camera(l_1_0._camera_controller)
  l_1_0._director:position_as(l_1_0._camera)
  if not l_1_0._unit:get_object(Idstring("g_camera")) then
    l_1_0._camera_controller:set_both(l_1_0._unit:get_object(Idstring("g_camtest")))
  end
end

PrevisCamera.start = function(l_2_0)
  if game_state_machine:current_state_name() ~= "editor" then
    l_2_0._old_game_state_name = game_state_machine:current_state_name()
  end
  game_state_machine:change_state_by_name("world_camera")
  l_2_0._playing = true
  l_2_0._unit:anim_set_time(Idstring("camera_animation"), 0)
  l_2_0._unit:anim_play_to(Idstring("camera_animation"), l_2_0._unit:anim_length(Idstring("camera_animation")), 1)
  l_2_0._viewport:set_active(true)
end

PrevisCamera.stop = function(l_3_0)
  l_3_0._viewport:set_active(false)
  l_3_0._unit:anim_stop(Idstring("camera_animation"))
  l_3_0._unit:anim_set_time(Idstring("camera_animation"), 0)
  if l_3_0._old_game_state_name then
    game_state_machine:change_state_by_name(l_3_0._old_game_state_name)
    l_3_0._old_game_state_name = nil
  end
  l_3_0._playing = false
end

PrevisCamera.update = function(l_4_0, l_4_1, l_4_2, l_4_3)
   -- DECOMPILER ERROR: unhandled construct in 'if'

  if l_4_0._playing and l_4_0._wait_t and l_4_0._wait_t < l_4_2 then
    l_4_0._wait_t = nil
    l_4_0:stop()
    do return end
    if not l_4_0._unit:anim_is_playing(Idstring("camera_animation")) then
      l_4_0._wait_t = l_4_2 + 4
    end
  end
end

PrevisCamera.destroy = function(l_5_0)
  if l_5_0._viewport then
    l_5_0._viewport:destroy()
    l_5_0._viewport = nil
  end
  if alive(l_5_0._camera) then
    World:delete_camera(l_5_0._camera)
    l_5_0._camera = nil
  end
end


