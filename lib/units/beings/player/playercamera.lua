-- Decompiled using luadec 2.0.1 by sztupy (http://winmo.sztupy.hu)
-- Command line was: F:\SteamLibrary\SteamApps\common\PAYDAY 2\lua\lib\units\beings\player\playercamera.luac 

if not PlayerCamera then
  PlayerCamera = class()
end
PlayerCamera.IDS_NOTHING = Idstring("")
PlayerCamera.init = function(l_1_0, l_1_1)
  l_1_0._unit = l_1_1
  l_1_0._m_cam_rot = l_1_1:rotation()
  l_1_0._m_cam_pos = l_1_1:position() + math.UP * 140
  l_1_0._m_cam_fwd = l_1_0._m_cam_rot:y()
  l_1_0._camera_object = World:create_camera()
  l_1_0._camera_object:set_near_range(3)
  l_1_0._camera_object:set_far_range(250000)
  l_1_0._camera_object:set_fov(75)
  l_1_0:spawn_camera_unit()
  l_1_0:_setup_sound_listener()
  l_1_0._sync_fwd = l_1_1:rotation():y():with_z(0):normalized()
  l_1_0._last_sync_t = 0
  l_1_0:setup_viewport(managers.player:viewport_config())
end

PlayerCamera.setup_viewport = function(l_2_0, l_2_1)
  if l_2_0._vp then
    l_2_0._vp:destroy()
  end
  local dimensions = l_2_1.dimensions
  local name = "player" .. tostring(l_2_0._id)
  local vp = managers.viewport:new_vp(dimensions.x, dimensions.y, dimensions.w, dimensions.h, name)
  l_2_0._director = vp:director()
  l_2_0._shaker = l_2_0._director:shaker()
  l_2_0._shaker:set_timer(managers.player:player_timer())
  l_2_0._camera_controller = l_2_0._director:make_camera(l_2_0._camera_object, Idstring("fps"))
  l_2_0._director:set_camera(l_2_0._camera_controller)
  l_2_0._director:position_as(l_2_0._camera_object)
  l_2_0._camera_controller:set_both(l_2_0._camera_unit)
  l_2_0._camera_controller:set_timer(managers.player:player_timer())
  l_2_0._shakers = {}
  l_2_0._shakers.breathing = l_2_0._shaker:play("breathing", 0.30000001192093)
  l_2_0._shakers.headbob = l_2_0._shaker:play("headbob", 0)
  vp:set_camera(l_2_0._camera_object)
  vp:set_environment(managers.environment_area:default_environment())
  l_2_0._vp = vp
  do return end
  vp:set_width_mul_enabled()
  vp:camera():set_width_multiplier(CoreMath.width_mul(1.7777777910233))
  l_2_0:_set_dimensions()
end

PlayerCamera._set_dimensions = function(l_3_0)
  l_3_0._vp._vp:set_dimensions(0, (1 - RenderSettings.aspect_ratio / 1.7777777910233) / 2, 1, RenderSettings.aspect_ratio / 1.7777777910233)
end

PlayerCamera.spawn_camera_unit = function(l_4_0)
  if Global.level_data and Global.level_data.level_id then
    local lvl_tweak_data = tweak_data.levels[Global.level_data.level_id]
  end
  local unit_folder = "suit"
  l_4_0._camera_unit = World:spawn_unit(Idstring("units/payday2/characters/fps_criminals_suit_1/fps_criminals_suit_1"), l_4_0._m_cam_pos, l_4_0._m_cam_rot)
  l_4_0._machine = l_4_0._camera_unit:anim_state_machine()
  l_4_0._unit:link(l_4_0._camera_unit)
  l_4_0._camera_unit:base():set_parent_unit(l_4_0._unit)
  l_4_0._camera_unit:base():reset_properties()
  l_4_0._camera_unit:base():set_stance_instant("standard")
end

PlayerCamera.camera_unit = function(l_5_0)
  return l_5_0._camera_unit
end

PlayerCamera.anim_state_machine = function(l_6_0)
  return l_6_0._camera_unit:anim_state_machine()
end

PlayerCamera.play_redirect = function(l_7_0, l_7_1, l_7_2)
  local result = l_7_0._camera_unit:base():play_redirect(l_7_1, l_7_2)
  return (result ~= PlayerCamera.IDS_NOTHING and result)
end

PlayerCamera.play_state = function(l_8_0, l_8_1, l_8_2)
  local result = l_8_0._camera_unit:base():play_state(l_8_1, l_8_2)
  return (result ~= PlayerCamera.IDS_NOTHING and result)
end

PlayerCamera.set_speed = function(l_9_0, l_9_1, l_9_2)
  l_9_0._machine:set_speed(l_9_1, l_9_2)
end

PlayerCamera.anim_data = function(l_10_0)
  return l_10_0._camera_unit:anim_data()
end

PlayerCamera.destroy = function(l_11_0)
  l_11_0._vp:destroy()
  l_11_0._unit = nil
  if alive(l_11_0._camera_object) then
    World:delete_camera(l_11_0._camera_object)
  end
  l_11_0._camera_object = nil
  l_11_0:remove_sound_listener()
end

PlayerCamera.remove_sound_listener = function(l_12_0)
  if not l_12_0._listener_id then
    return 
  end
  managers.sound_environment:remove_check_object(l_12_0._sound_check_object)
  managers.listener:remove_listener(l_12_0._listener_id)
  managers.listener:remove_set("player_camera")
  l_12_0._listener_id = nil
end

PlayerCamera.clbk_fp_enter = function(l_13_0, l_13_1)
  if l_13_0._camera_manager_mode ~= "first_person" then
    l_13_0._camera_manager_mode = "first_person"
  end
end

PlayerCamera._setup_sound_listener = function(l_14_0)
  l_14_0._listener_id = managers.listener:add_listener("player_camera", l_14_0._camera_object, l_14_0._camera_object, nil, false)
  managers.listener:add_set("player_camera", {"player_camera"})
  l_14_0._listener_activation_id = managers.listener:activate_set("main", "player_camera")
  l_14_0._sound_check_object = managers.sound_environment:add_check_object({object = l_14_0._unit:orientation_object(), active = true, primary = true})
end

PlayerCamera.position = function(l_15_0)
  return l_15_0._m_cam_pos
end

PlayerCamera.rotation = function(l_16_0)
  return l_16_0._m_cam_rot
end

PlayerCamera.forward = function(l_17_0)
  return l_17_0._m_cam_fwd
end

PlayerCamera.set_position = function(l_18_0, l_18_1)
  l_18_0._camera_controller:set_camera(l_18_1)
  mvector3.set(l_18_0._m_cam_pos, l_18_1)
end

local mvec1 = Vector3()
PlayerCamera.set_rotation = function(l_19_0, l_19_1)
  mrotation.y(l_19_1, mvec1)
  mvector3.multiply(mvec1, 100000)
  mvector3.add(mvec1, l_19_0._m_cam_pos)
  l_19_0._camera_controller:set_target(mvec1)
  mrotation.z(l_19_1, mvec1)
  l_19_0._camera_controller:set_default_up(mvec1)
  mrotation.set_yaw_pitch_roll(l_19_0._m_cam_rot, l_19_1:yaw(), l_19_1:pitch(), l_19_1:roll())
  mrotation.y(l_19_0._m_cam_rot, l_19_0._m_cam_fwd)
  local new_fwd = l_19_0:forward()
  local error_sync_dot = mvector3.dot(l_19_0._sync_fwd, new_fwd)
  local t = managers.player:player_timer():time()
  local sync_dt = t - l_19_0._last_sync_t
  if (error_sync_dot < 0.89999997615814 and sync_dt > 0.5) or error_sync_dot < 0.99000000953674 and sync_dt > 1 then
    l_19_0._last_sync_t = t
    l_19_0._unit:network():send("set_look_dir", new_fwd)
    mvector3.set(l_19_0._sync_fwd, new_fwd)
  end
end

PlayerCamera.set_FOV = function(l_20_0, l_20_1)
  l_20_0._camera_object:set_fov(l_20_1)
end

PlayerCamera.viewport = function(l_21_0)
  return l_21_0._vp
end

PlayerCamera.set_shaker_parameter = function(l_22_0, l_22_1, l_22_2, l_22_3)
  if not l_22_0._shakers then
    return 
  end
  if l_22_0._shakers[l_22_1] then
    l_22_0._shaker:set_parameter(l_22_0._shakers[l_22_1], l_22_2, l_22_3)
  end
end

PlayerCamera.play_shaker = function(l_23_0, l_23_1, l_23_2, l_23_3, l_23_4)
  return l_23_0._shaker:play(l_23_1, l_23_2 or 1, l_23_3 or 1, l_23_4 or 0)
end

PlayerCamera.stop_shaker = function(l_24_0, l_24_1)
  l_24_0._shaker:stop_immediately(l_24_1)
end

PlayerCamera.shaker = function(l_25_0)
  return l_25_0._shaker
end


