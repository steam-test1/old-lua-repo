-- Decompiled using luadec 2.0.1 by sztupy (http://winmo.sztupy.hu)
-- Command line was: F:\SteamLibrary\SteamApps\common\PAYDAY 2\lua\core\lib\managers\coreworldcameramanager.luac 

core:import("CoreManagerBase")
if not CoreWorldCameraManager then
  CoreWorldCameraManager = class()
end
CoreWorldCameraManager.init = function(l_1_0)
  l_1_0._camera = World:create_camera()
  l_1_0:set_default_fov(75)
  l_1_0:set_fov(l_1_0._default_fov)
  l_1_0:set_default_dof(150, 10000)
  l_1_0._current_near_dof = l_1_0._default_near_dof
  l_1_0._current_far_dof = l_1_0._default_far_dof
  l_1_0._default_dof_padding = 100
  l_1_0._current_dof_padding = l_1_0._default_dof_padding
  l_1_0._default_dof_clamp = 1
  l_1_0._current_dof_clamp = l_1_0._default_dof_clamp
  l_1_0:set_dof(l_1_0._default_near_dof, l_1_0._default_far_dof)
  l_1_0._camera:set_near_range(7.5)
  l_1_0._camera:set_far_range(200000)
  l_1_0._viewport = managers.viewport:new_vp(0, 0, 1, 1, "worldcamera", CoreManagerBase.PRIO_WORLDCAMERA)
  l_1_0._director = l_1_0._viewport:director()
  l_1_0._shaker = l_1_0._director:shaker()
  l_1_0._camera_controller = l_1_0._director:make_camera(l_1_0._camera, Idstring("world_camera"))
  l_1_0._viewport:set_camera(l_1_0._camera)
  l_1_0._director:set_camera(l_1_0._camera_controller)
  l_1_0._director:position_as(l_1_0._camera)
  l_1_0:_create_listener()
  l_1_0._use_gui = false
  l_1_0._workspace = Overlay:newgui():create_screen_workspace(0, 0, 1, 1)
  l_1_0._gui = l_1_0._workspace:panel():gui(Idstring("core/guis/core_world_camera"))
  l_1_0._gui_visible = nil
  l_1_0:_set_gui_visible(false)
  l_1_0:_clear_callback_lists()
  l_1_0:_set_dof_effect()
  l_1_0:clear()
end

CoreWorldCameraManager.use_gui = function(l_2_0)
  return l_2_0._use_gui
end

CoreWorldCameraManager._create_listener = function(l_3_0)
  l_3_0._listener_id = managers.listener:add_listener("world_camera", l_3_0._camera)
  l_3_0._listener_activation_id = nil
  managers.listener:add_set("world_camera", {"world_camera"})
end

CoreWorldCameraManager.set_default_fov = function(l_4_0, l_4_1)
  l_4_0._default_fov = l_4_1
end

CoreWorldCameraManager.default_fov = function(l_5_0)
  return l_5_0._default_fov
end

CoreWorldCameraManager.set_fov = function(l_6_0, l_6_1)
  l_6_0._camera:set_fov(l_6_1)
end

CoreWorldCameraManager.set_default_dof = function(l_7_0, l_7_1, l_7_2)
  l_7_0._default_near_dof = l_7_1
  l_7_0._default_far_dof = l_7_2
end

CoreWorldCameraManager.default_near_dof = function(l_8_0)
  return l_8_0._default_near_dof
end

CoreWorldCameraManager.default_far_dof = function(l_9_0)
  return l_9_0._default_far_dof
end

CoreWorldCameraManager.set_dof = function(l_10_0, l_10_1)
end

CoreWorldCameraManager.default_dof_padding = function(l_11_0)
  return l_11_0._default_dof_padding
end

CoreWorldCameraManager.default_dof_clamp = function(l_12_0)
  return l_12_0._default_dof_clamp
end

CoreWorldCameraManager._set_dof_effect = function(l_13_0)
  l_13_0._dof = {}
  l_13_0._dof.update_callback = "update_world_camera"
  l_13_0._dof.near_min = l_13_0:default_near_dof()
  l_13_0._dof.near_max = l_13_0:default_near_dof()
  l_13_0._dof.far_min = l_13_0:default_far_dof()
  l_13_0._dof.far_max = l_13_0:default_far_dof()
  l_13_0._dof.clamp = 1
  l_13_0._dof.prio = 1
  l_13_0._dof.name = "world_camera"
  l_13_0._dof.fade_in = 0
  l_13_0._dof.fade_out = 0
end

CoreWorldCameraManager.destroy = function(l_14_0)
  l_14_0:_destroy_listener()
  if l_14_0._viewport then
    l_14_0._viewport:destroy()
    l_14_0._viewport = nil
  end
  if alive(l_14_0._workspace) then
    Overlay:newgui():destroy_workspace(l_14_0._workspace)
    l_14_0._workspace = nil
  end
  if alive(l_14_0._camera) then
    World:delete_camera(l_14_0._camera)
    l_14_0._camera = nil
  end
end

CoreWorldCameraManager._destroy_listener = function(l_15_0)
  if l_15_0._listener_id then
    managers.listener:remove_listener(l_15_0._listener_id)
    managers.listener:remove_set("world_camera")
    l_15_0._listener_id = nil
  end
end

CoreWorldCameraManager.stop_simulation = function(l_16_0)
  l_16_0:_clear_callback_lists()
  l_16_0:stop_world_camera()
end

CoreWorldCameraManager._clear_callback_lists = function(l_17_0)
  l_17_0._last_world_camera_done_callback_id = {}
  l_17_0._world_camera_done_callback_list = {}
  l_17_0._last_sequence_done_callback_id = {}
  l_17_0._sequence_done_callback_list = {}
  l_17_0._last_sequence_camera_clip_callback_id = {}
  l_17_0._sequence_camera_clip_callback_list = {}
end

CoreWorldCameraManager.clear = function(l_18_0)
  l_18_0._world_cameras = {}
  l_18_0._world_camera_sequences = {}
  l_18_0._current_world_camera = nil
end

CoreWorldCameraManager.current_world_camera = function(l_19_0)
  return l_19_0._current_world_camera
end

CoreWorldCameraManager.save = function(l_20_0, l_20_1)
  local worldcameras = {}
  for name,world_camera in pairs(l_20_0._world_cameras) do
    worldcameras[name] = world_camera:save_data_table()
  end
  local camera_data = {worldcameras = worldcameras, sequences = l_20_0._world_camera_sequences}
  l_20_1:puts(ScriptSerializer:to_generic_xml(camera_data))
end

CoreWorldCameraManager.load = function(l_21_0, l_21_1)
  if not l_21_0:_old_load(l_21_1) then
    if not l_21_1.worldcameras then
      Application:error("Can't load world cameras, it is in new format but probably loaded from old level")
      return 
    end
    for name,camera_data in pairs(l_21_1.worldcameras) do
       -- DECOMPILER ERROR: Confused while interpreting a jump as a 'while'

    end
    l_21_0._world_cameras[name] = rawget(_G, "CoreWorldCamera"):new(name)
    l_21_0._world_cameras[name]:load(camera_data)
  end
  l_21_0._world_camera_sequences = l_21_1.sequences
end
end

CoreWorldCameraManager._old_load = function(l_22_0, l_22_1)
  if type_name(l_22_1) ~= "string" then
    return false
  end
  local path = managers.database:entry_expanded_path("world_cameras", l_22_1)
  local node = SystemFS:parse_xml(path)
  if node:name() ~= "world_cameras" then
    return false
  end
  for child in node:children() do
    do
      if child:name() == "world_camera" then
        local world_camera_name = child:parameter("name")
         -- DECOMPILER ERROR: Confused while interpreting a jump as a 'while'

      end
      l_22_0._world_cameras[world_camera_name] = rawget(_G, "CoreWorldCamera"):new(world_camera_name)
      l_22_0._world_cameras[world_camera_name]:old_load(child)
    end
    for (for control) in (for generator) do
    end
    local name, value = parse_value_node(child)
    l_22_0[name] = value
  end
  return true
end

CoreWorldCameraManager.update = function(l_23_0, l_23_1, l_23_2)
  if l_23_0._current_world_camera then
    l_23_0._current_world_camera:update(l_23_1, l_23_2)
  end
end

CoreWorldCameraManager._set_gui_visible = function(l_24_0, l_24_1)
  if l_24_0._gui_visible ~= l_24_1 then
    if l_24_1 and l_24_0._use_gui then
      l_24_0._workspace:show()
    else
      l_24_0._workspace:hide()
      l_24_0._gui_visible = l_24_1
    end
     -- Warning: missing end command somewhere! Added here
  end
end

CoreWorldCameraManager.add_world_camera_done_callback = function(l_25_0, l_25_1, l_25_2)
  l_25_0._last_world_camera_done_callback_id[l_25_1] = l_25_0._last_world_camera_done_callback_id[l_25_1] or 0
  l_25_0._last_world_camera_done_callback_id[l_25_1] = l_25_0._last_world_camera_done_callback_id[l_25_1] + 1
  if not l_25_0._world_camera_done_callback_list[l_25_1] then
    l_25_0._world_camera_done_callback_list[l_25_1] = {}
  end
  l_25_0._world_camera_done_callback_list[l_25_1][l_25_0._last_world_camera_done_callback_id[l_25_1]] = l_25_2
  return l_25_0._last_world_camera_done_callback_id[l_25_1]
end

CoreWorldCameraManager.remove_world_camera_done_callback = function(l_26_0, l_26_1, l_26_2)
  l_26_0._world_camera_done_callback_list[l_26_1][l_26_2] = nil
end

CoreWorldCameraManager.add_sequence_done_callback = function(l_27_0, l_27_1, l_27_2)
  l_27_0._last_sequence_done_callback_id[l_27_1] = l_27_0._last_sequence_done_callback_id[l_27_1] or 0
  l_27_0._last_sequence_done_callback_id[l_27_1] = l_27_0._last_sequence_done_callback_id[l_27_1] + 1
  if not l_27_0._sequence_done_callback_list[l_27_1] then
    l_27_0._sequence_done_callback_list[l_27_1] = {}
  end
  l_27_0._sequence_done_callback_list[l_27_1][l_27_0._last_sequence_done_callback_id[l_27_1]] = l_27_2
  return l_27_0._last_sequence_done_callback_id[l_27_1]
end

CoreWorldCameraManager.remove_sequence_done_callback = function(l_28_0, l_28_1, l_28_2)
  l_28_0._sequence_done_callback_list[l_28_1][l_28_2] = nil
end

CoreWorldCameraManager.add_sequence_camera_clip_callback = function(l_29_0, l_29_1, l_29_2, l_29_3)
  l_29_0._last_sequence_camera_clip_callback_id[l_29_1] = l_29_0._last_sequence_camera_clip_callback_id[l_29_1] or 0
  l_29_0._last_sequence_camera_clip_callback_id[l_29_1] = l_29_0._last_sequence_camera_clip_callback_id[l_29_1] + 1
  if not l_29_0._sequence_camera_clip_callback_list[l_29_1] then
    l_29_0._sequence_camera_clip_callback_list[l_29_1] = {}
  end
  if not l_29_0._sequence_camera_clip_callback_list[l_29_1][l_29_2] then
    l_29_0._sequence_camera_clip_callback_list[l_29_1][l_29_2] = {}
  end
  l_29_0._sequence_camera_clip_callback_list[l_29_1][l_29_2][l_29_0._last_sequence_camera_clip_callback_id[l_29_1]] = l_29_3
  return l_29_0._last_sequence_camera_clip_callback_id[l_29_1]
end

CoreWorldCameraManager.remove_sequence_camera_clip_callback = function(l_30_0, l_30_1, l_30_2, l_30_3)
  l_30_0._sequence_camera_clip_callback_list[l_30_1][l_30_2][l_30_3] = nil
end

CoreWorldCameraManager.create_world_camera = function(l_31_0, l_31_1)
   -- DECOMPILER ERROR: Confused while interpreting a jump as a 'while'

end
l_31_0._world_cameras[l_31_1] = rawget(_G, "CoreWorldCamera"):new(l_31_1)
return l_31_0._world_cameras[l_31_1]
end

CoreWorldCameraManager.remove_world_camera = function(l_32_0, l_32_1)
  l_32_0._world_cameras[l_32_1] = nil
end

CoreWorldCameraManager.all_world_cameras = function(l_33_0)
  return l_33_0._world_cameras
end

CoreWorldCameraManager.world_camera = function(l_34_0, l_34_1)
  return l_34_0._world_cameras[l_34_1]
end

CoreWorldCameraManager.play_world_camera = function(l_35_0, l_35_1)
   -- DECOMPILER ERROR: No list found. Setlist fails

  local s = {}
   -- DECOMPILER ERROR: Overwrote pending register.

  l_35_0:_camera_sequence_table(l_35_1)(l_35_0, nil, s)
end

CoreWorldCameraManager.new_play_world_camera = function(l_36_0, l_36_1)
  local world_camera = l_36_0._world_cameras[l_36_1.name]
  if world_camera then
    if l_36_0._current_world_camera then
      l_36_0._current_world_camera:stop()
    end
    l_36_0._current_world_camera = world_camera
    local ok, msg = l_36_0._current_world_camera:play(l_36_1)
    if not ok then
      if Application:editor() then
        managers.editor:output_error(msg)
      end
      l_36_0:stop_world_camera()
      return 
    else
      Application:error("WorldCamera named", l_36_1.name, "did not exist.")
    end
  end
end

CoreWorldCameraManager.stop_world_camera = function(l_37_0)
  if not l_37_0._current_world_camera then
    return 
  end
  local stop_camera = l_37_0._current_world_camera
  stop_camera:stop()
  if l_37_0._current_sequence then
    if l_37_0._sequence_camera_clip_callback_list[l_37_0._current_sequence_name] and l_37_0._sequence_camera_clip_callback_list[l_37_0._current_sequence_name][l_37_0._sequence_index] then
      for id,func in pairs(l_37_0._sequence_camera_clip_callback_list[l_37_0._current_sequence_name][l_37_0._sequence_index]) do
        l_37_0:remove_sequence_camera_clip_callback(l_37_0._current_sequence_name, l_37_0._sequence_index, id)
        func(l_37_0._current_sequence_name, l_37_0._sequence_index, id)
      end
    end
    if l_37_0._sequence_index < #l_37_0._current_sequence then
      l_37_0._sequence_index = l_37_0._sequence_index + 1
      l_37_0:new_play_world_camera(l_37_0._current_sequence[l_37_0._sequence_index])
    else
      l_37_0._current_world_camera = nil
      l_37_0:_sequence_done()
    end
  end
  if l_37_0._world_camera_done_callback_list[stop_camera:name()] then
    for id,func in pairs(l_37_0._world_camera_done_callback_list[stop_camera:name()]) do
      l_37_0:remove_world_camera_done_callback(stop_camera:name(), id)
      func(stop_camera, id)
    end
  end
end

CoreWorldCameraManager.create_world_camera_sequence = function(l_38_0, l_38_1)
  l_38_0._world_camera_sequences[l_38_1] = {}
  return l_38_0._world_camera_sequences[l_38_1]
end

CoreWorldCameraManager.remove_world_camera_sequence = function(l_39_0, l_39_1)
  l_39_0._world_camera_sequences[l_39_1] = nil
end

CoreWorldCameraManager.all_world_camera_sequences = function(l_40_0)
  return l_40_0._world_camera_sequences
end

CoreWorldCameraManager.world_camera_sequence = function(l_41_0, l_41_1)
  return l_41_0._world_camera_sequences[l_41_1]
end

CoreWorldCameraManager.add_camera_to_sequence = function(l_42_0, l_42_1, l_42_2)
  local sequence = l_42_0._world_camera_sequences[l_42_1]
  if not sequence then
    Application:error("World camera sequence named", l_42_1, "did not exist.")
    return 
  end
  table.insert(sequence, l_42_0:_camera_sequence_table(l_42_2))
  return #sequence
end

CoreWorldCameraManager.insert_camera_to_sequence = function(l_43_0, l_43_1, l_43_2, l_43_3)
  local sequence = l_43_0._world_camera_sequences[l_43_1]
  if not sequence then
    Application:error("World camera sequence named", l_43_1, "did not exist.")
    return 
  end
  table.insert(sequence, l_43_3, l_43_2)
  return #sequence
end

CoreWorldCameraManager.remove_camera_from_sequence = function(l_44_0, l_44_1, l_44_2)
  local sequence = l_44_0._world_camera_sequences[l_44_1]
  local camera_sequence_table = sequence[l_44_2]
  table.remove(sequence, l_44_2)
  return camera_sequence_table
end

CoreWorldCameraManager._camera_sequence_table = function(l_45_0, l_45_1)
  local t = {}
  t.name = l_45_1
  t.start = 0
  t.stop = 1
  return t
end

CoreWorldCameraManager._break_sequence = function(l_46_0)
  if l_46_0._current_sequence then
    l_46_0:_sequence_done()
  end
end

CoreWorldCameraManager._sequence_done = function(l_47_0)
  l_47_0:_set_listener_enabled(false)
  l_47_0:_reset_old_viewports()
  l_47_0:stop_dof()
  l_47_0:_set_gui_visible(false)
  managers.sound_environment:set_check_object_active(l_47_0._sound_environment_check_object, false)
  local done_sequence = l_47_0._current_sequence
  local done_sequence_name = l_47_0._current_sequence_name
  l_47_0._current_sequence = nil
  l_47_0._current_sequence_name = nil
  if l_47_0._sequence_done_callback_list[done_sequence_name] then
    for id,func in pairs(l_47_0._sequence_done_callback_list[done_sequence_name]) do
      l_47_0:remove_sequence_done_callback(done_sequence_name, id)
      func(done_sequence, id)
    end
  end
  if l_47_0._old_game_state_name then
    game_state_machine:change_state_by_name(l_47_0._old_game_state_name)
    l_47_0._old_game_state_name = nil
  end
end

CoreWorldCameraManager.play_world_camera_sequence = function(l_48_0, l_48_1, l_48_2)
  if game_state_machine:current_state_name() ~= "editor" then
    l_48_0._old_game_state_name = game_state_machine:current_state_name()
  end
  game_state_machine:change_state_by_name("world_camera")
  l_48_0:_break_sequence()
  local sequence = l_48_0._world_camera_sequences[l_48_1] or l_48_2
  if not sequence then
    Application:error("World camera sequence named", l_48_1, "did not exist.")
    return 
  end
  if #sequence == 0 then
    Application:error("World camera sequence named", l_48_1, "did not have any cameras.")
    return 
  end
  l_48_0._current_sequence = sequence
  l_48_0._current_sequence_name = l_48_1
  if not l_48_0._sound_environment_check_object then
    l_48_0._sound_environment_check_object = managers.sound_environment:add_check_object({object = l_48_0._camera, active = false, primary = true})
  end
  managers.sound_environment:set_check_object_active(l_48_0._sound_environment_check_object, true)
  l_48_0:_use_vp()
  l_48_0:_set_gui_visible(true)
  l_48_0:_set_listener_enabled(true)
  l_48_0._sequence_index = 1
  l_48_0:new_play_world_camera(l_48_0._current_sequence[l_48_0._sequence_index])
end

CoreWorldCameraManager._use_vp = function(l_49_0)
  l_49_0:viewport():set_active(true)
end

CoreWorldCameraManager._reset_old_viewports = function(l_50_0)
  l_50_0:viewport():set_active(false)
end

CoreWorldCameraManager._set_listener_enabled = function(l_51_0, l_51_1)
  if l_51_1 and not l_51_0._listener_activation_id then
    l_51_0._listener_activation_id = managers.listener:activate_set("main", "world_camera")
    do return end
    if l_51_0._listener_activation_id then
      managers.listener:deactivate_set(l_51_0._listener_activation_id)
      l_51_0._listener_activation_id = nil
    end
  end
end

CoreWorldCameraManager.start_dof = function(l_52_0)
  if not l_52_0._using_dof then
    l_52_0._using_dof = true
    l_52_0._dof_effect_id = managers.DOF:play(l_52_0._dof)
  end
end

CoreWorldCameraManager.stop_dof = function(l_53_0)
  managers.DOF:stop(l_53_0._dof_effect_id)
  l_53_0._dof_effect_id = nil
  l_53_0._using_dof = false
end

CoreWorldCameraManager.using_dof = function(l_54_0)
  return l_54_0._using_dof
end

CoreWorldCameraManager.update_dof_values = function(l_55_0, l_55_1, l_55_2, l_55_3, l_55_4)
  l_55_0._current_near_dof = l_55_1
  l_55_0._current_far_dof = l_55_2
  l_55_0._current_dof_padding = l_55_3
  l_55_0._current_dof_clamp = l_55_4
  managers.DOF:set_effect_parameters(l_55_0._dof_effect_id, {near_min = l_55_1, near_max = l_55_1 - l_55_3, far_min = l_55_2, far_max = l_55_2 + l_55_3}, l_55_4)
end

CoreWorldCameraManager.viewport = function(l_56_0)
  return l_56_0._viewport
end

CoreWorldCameraManager.director = function(l_57_0)
  return l_57_0._director
end

CoreWorldCameraManager.workspace = function(l_58_0)
  return l_58_0._workspace
end

CoreWorldCameraManager.camera = function(l_59_0)
  return l_59_0._camera
end

CoreWorldCameraManager.camera_controller = function(l_60_0)
  return l_60_0._camera_controller
end

if not CoreWorldCamera then
  CoreWorldCamera = class()
end
CoreWorldCamera.init = function(l_61_0, l_61_1)
  l_61_0._world_camera_name = l_61_1
  l_61_0._points = {}
  l_61_0._positions = {}
  l_61_0._target_positions = {}
  l_61_0._duration = 2.5
  l_61_0._delay = 0
  l_61_0._playing = false
  l_61_0._target_offset = 1000
  l_61_0._in_accelerations = {}
  l_61_0._out_accelerations = {}
  l_61_0._in_accelerations.linear = 0.33000001311302
  l_61_0._out_accelerations.linear = 0.66000002622604
  l_61_0._in_accelerations.ease = 0
  l_61_0._out_accelerations.ease = 1
  l_61_0._in_accelerations.fast = 0.5
  l_61_0._out_accelerations.fast = 0.5
  l_61_0._in_acc = l_61_0._in_accelerations.linear
  l_61_0._out_acc = l_61_0._out_accelerations.linear
  l_61_0._old_viewport = nil
  l_61_0._keys = {}
  local time = 0
  local fov = managers.worldcamera:default_fov()
  local near_dof = managers.worldcamera:default_near_dof()
  local far_dof = managers.worldcamera:default_far_dof()
  table.insert(l_61_0._keys, {time = time, fov = fov, near_dof = near_dof, far_dof = far_dof, roll = 0})
  l_61_0._dof_padding = managers.worldcamera:default_dof_padding()
  l_61_0._dof_clamp = managers.worldcamera:default_dof_clamp()
  l_61_0._curve_type = "bezier"
end

CoreWorldCamera.save_data_table = function(l_62_0)
  {name = l_62_0._world_camera_name, duration = l_62_0._duration, delay = l_62_0._delay, in_acc = l_62_0._in_acc, out_acc = l_62_0._out_acc, positions = l_62_0._positions, target_positions = l_62_0._target_positions, keys = l_62_0._keys}.dof_padding = l_62_0._dof_padding
   -- DECOMPILER ERROR: Confused about usage of registers!

  {name = l_62_0._world_camera_name, duration = l_62_0._duration, delay = l_62_0._delay, in_acc = l_62_0._in_acc, out_acc = l_62_0._out_acc, positions = l_62_0._positions, target_positions = l_62_0._target_positions, keys = l_62_0._keys}.dof_clamp = l_62_0._dof_clamp
   -- DECOMPILER ERROR: Confused about usage of registers!

  {name = l_62_0._world_camera_name, duration = l_62_0._duration, delay = l_62_0._delay, in_acc = l_62_0._in_acc, out_acc = l_62_0._out_acc, positions = l_62_0._positions, target_positions = l_62_0._target_positions, keys = l_62_0._keys}.curve_type = l_62_0._curve_type
   -- DECOMPILER ERROR: Confused about usage of registers!

  {name = l_62_0._world_camera_name, duration = l_62_0._duration, delay = l_62_0._delay, in_acc = l_62_0._in_acc, out_acc = l_62_0._out_acc, positions = l_62_0._positions, target_positions = l_62_0._target_positions, keys = l_62_0._keys}.spline_metadata = l_62_0._spline_metadata
  do
     -- DECOMPILER ERROR: Confused at declaration of local variable

     -- DECOMPILER ERROR: Confused about usage of registers!

    return {name = l_62_0._world_camera_name, duration = l_62_0._duration, delay = l_62_0._delay, in_acc = l_62_0._in_acc, out_acc = l_62_0._out_acc, positions = l_62_0._positions, target_positions = l_62_0._target_positions, keys = l_62_0._keys}
  end
   -- DECOMPILER ERROR: Confused about usage of registers for local variables.

end

CoreWorldCamera.load = function(l_63_0, l_63_1)
  l_63_0._duration = l_63_1.duration
  l_63_0._delay = l_63_1.delay
  l_63_0._in_acc = l_63_1.in_acc
  l_63_0._out_acc = l_63_1.out_acc
  l_63_0._positions = l_63_1.positions
  l_63_0._target_positions = l_63_1.target_positions
  l_63_0._keys = l_63_1.keys
  l_63_0._dof_padding = l_63_1.dof_padding
  l_63_0._dof_clamp = l_63_1.dof_clamp
  l_63_0._curve_type = l_63_1.curve_type
  l_63_0._spline_metadata = l_63_1.spline_metadata
  l_63_0:_check_loaded_data()
end

CoreWorldCamera._check_loaded_data = function(l_64_0)
  for _,key in pairs(l_64_0._keys) do
    key.roll = key.roll or 0
  end
end

CoreWorldCamera.old_load = function(l_65_0, l_65_1)
  l_65_0._duration = tonumber(l_65_1:parameter("duration"))
  l_65_0._delay = tonumber(l_65_1:parameter("delay"))
  if l_65_1:has_parameter("in_acc") then
    l_65_0._in_acc = tonumber(l_65_1:parameter("in_acc"))
  end
  if l_65_1:has_parameter("out_acc") then
    l_65_0._out_acc = tonumber(l_65_1:parameter("out_acc"))
  end
  for child in l_65_1:children() do
    do
      if child:name() == "point" then
        local index = tonumber(child:parameter("index"))
        for value in child:children() do
          if value:name() == "pos" then
            l_65_0._positions[index] = math.string_to_vector(value:parameter("value"))
            for (for control) in (for generator) do
            end
            if value:name() == "t_pos" then
              l_65_0._target_positions[index] = math.string_to_vector(value:parameter("value"))
            end
          end
        end
        for (for control) in (for generator) do
        end
        if child:name() == "value" then
          local name, value = parse_value_node(child)
          l_65_0[name] = value
        end
      end
       -- Warning: missing end command somewhere! Added here
    end
     -- Warning: missing end command somewhere! Added here
  end
end

CoreWorldCamera.duration = function(l_66_0)
  return l_66_0._duration
end

CoreWorldCamera.set_duration = function(l_67_0, l_67_1)
  l_67_0._duration = l_67_1
end

CoreWorldCamera.duration = function(l_68_0)
  return l_68_0._duration
end

CoreWorldCamera.set_delay = function(l_69_0, l_69_1)
  l_69_0._delay = l_69_1
end

CoreWorldCamera.delay = function(l_70_0)
  return l_70_0._delay
end

CoreWorldCamera.set_dof_padding = function(l_71_0, l_71_1)
  l_71_0._dof_padding = l_71_1
end

CoreWorldCamera.dof_padding = function(l_72_0)
  return l_72_0._dof_padding
end

CoreWorldCamera.set_dof_clamp = function(l_73_0, l_73_1)
  l_73_0._dof_clamp = l_73_1
end

CoreWorldCamera.dof_clamp = function(l_74_0)
  return l_74_0._dof_clamp
end

CoreWorldCamera.name = function(l_75_0)
  return l_75_0._world_camera_name
end

CoreWorldCamera.in_acc = function(l_76_0)
  return l_76_0._in_acc
end

CoreWorldCamera.out_acc = function(l_77_0)
  return l_77_0._out_acc
end

CoreWorldCamera.set_sine_segment_position = function(l_78_0, l_78_1, l_78_2, l_78_3, l_78_4)
  local old_pos = l_78_3[l_78_2]
  local offset = l_78_1 - old_pos
  if l_78_4.p1 then
    l_78_4.p1 = l_78_4.p1 + offset
    l_78_3[l_78_2] = l_78_1
    if l_78_4.p2 then
      mvector3.set(offset, l_78_1)
      mvector3.subtract(offset, l_78_4.p1)
      mvector3.set_length(offset, mvector3.distance(old_pos, l_78_4.p2))
      mvector3.add(offset, l_78_1)
      l_78_4.p2 = offset
    elseif l_78_4.p2 then
      l_78_4.p2 = l_78_4.p2 + offset
      l_78_3[l_78_2] = l_78_1
    end
  end
end

CoreWorldCamera.set_control_point_length = function(l_79_0, l_79_1, l_79_2, l_79_3)
  local positions = l_79_0._positions
  local temp_vector = nil
  if l_79_1 and l_79_3 > 1 then
    temp_vector = l_79_0._spline_metadata.ctrl_points[l_79_3].p1 - positions[l_79_3]
    mvector3.set_length(temp_vector, l_79_1)
    l_79_0._spline_metadata.ctrl_points[l_79_3].p1 = positions[l_79_3] + (temp_vector)
  end
  if l_79_2 and l_79_3 < #positions then
    if temp_vector then
      mvector3.set(temp_vector, l_79_0._spline_metadata.ctrl_points[l_79_3].p2)
      mvector3.subtract(temp_vector, positions[l_79_3])
    else
      temp_vector = l_79_0._spline_metadata.ctrl_points[l_79_3].p2 - positions[l_79_3]
    end
    mvector3.set_length(temp_vector, l_79_2)
    mvector3.add(temp_vector, positions[l_79_3])
    l_79_0._spline_metadata.ctrl_points[l_79_3].p2 = temp_vector
  end
end

CoreWorldCamera.rotate_control_points = function(l_80_0, l_80_1, l_80_2)
  local positions = l_80_0._positions
  local temp_vector = nil
  if l_80_2 > 1 then
    local p1_len = mvector3.distance(l_80_0._spline_metadata.ctrl_points[l_80_2].p1, positions[l_80_2])
    temp_vector = -l_80_1
    mvector3.set_length(temp_vector, p1_len)
    l_80_0._spline_metadata.ctrl_points[l_80_2].p1 = positions[l_80_2] + temp_vector
  end
  if l_80_2 < #positions then
    local p2_len = mvector3.distance(l_80_0._spline_metadata.ctrl_points[l_80_2].p2, positions[l_80_2])
    if temp_vector then
      mvector3.negate(temp_vector)
    else
      temp_vector = mvector3.copy(l_80_1)
    end
    mvector3.set_length(temp_vector, p2_len)
    l_80_0._spline_metadata.ctrl_points[l_80_2].p2 = positions[l_80_2] + temp_vector
  end
end

CoreWorldCamera.set_curve_type_bezier = function(l_81_0)
  l_81_0._curve_type = "bezier"
  l_81_0._spline_metadata = nil
  repeat
    if #l_81_0._positions > 4 then
      table.remove(l_81_0._positions)
      table.remove(l_81_0._target_positions)
    else
      l_81_0._editor_random_access_data = nil
       -- Warning: missing end command somewhere! Added here
    end
     -- Warning: missing end command somewhere! Added here
  end
end

CoreWorldCamera.set_curve_type_sine = function(l_82_0)
  l_82_0._curve_type = "sine"
  if #l_82_0._positions > 2 then
    l_82_0:extract_spline_metadata()
  end
  l_82_0._editor_random_access_data = nil
end

CoreWorldCamera.in_acc_string = function(l_83_0)
  for name,value in pairs(l_83_0._in_accelerations) do
    if value == l_83_0._in_acc then
      return name
    end
  end
end

CoreWorldCamera.out_acc_string = function(l_84_0)
  for name,value in pairs(l_84_0._out_accelerations) do
    if value == l_84_0._out_acc then
      return name
    end
  end
end

CoreWorldCamera.set_in_acc = function(l_85_0, l_85_1)
  l_85_0._in_acc = l_85_0._in_accelerations[l_85_1]
end

CoreWorldCamera.set_out_acc = function(l_86_0, l_86_1)
  l_86_0._out_acc = l_86_0._out_accelerations[l_86_1]
end

CoreWorldCamera.positions_at_time_bezier = function(l_87_0, l_87_1)
  local acc = math.bezier({0, l_87_0._in_acc, l_87_0._out_acc, 1}, l_87_1)
  if not l_87_0._bezier then
    local b_type = l_87_0:bezier_function()
  end
  if b_type then
    local pos = b_type(l_87_0._positions, acc)
    local t_pos = b_type(l_87_0._target_positions, acc)
    return pos, t_pos
  end
  return l_87_0._positions[1], l_87_0._target_positions[1]
end

CoreWorldCamera.update = function(l_88_0, l_88_1, l_88_2)
  if l_88_0._timer < l_88_0._stop_timer then
    l_88_0._timer = l_88_0._timer + l_88_2 / l_88_0._duration
    local pos, t_pos = l_88_0:play_to_time(l_88_0._timer)
    l_88_0:update_camera(pos, t_pos)
    l_88_0:set_current_fov(l_88_0:value_at_time(l_88_0._timer, "fov"))
    local near_dof = l_88_0:value_at_time(l_88_0._timer, "near_dof")
    local far_dof = l_88_0:value_at_time(l_88_0._timer, "far_dof")
    l_88_0:update_dof_values(near_dof, far_dof, l_88_0._dof_padding, l_88_0._dof_clamp)
    local rot = Rotation(t_pos - pos:normalized(), l_88_0:value_at_time(l_88_0._timer, "roll"))
    managers.worldcamera:camera_controller():set_default_up(rot:z())
  elseif l_88_0._delay > 0 and l_88_0._delay_timer < 1 then
    l_88_0._delay_timer = l_88_0._delay_timer + l_88_2 / l_88_0._delay
  else
    managers.worldcamera:stop_world_camera()
  end
end

CoreWorldCamera.positions_at_time = function(l_89_0, l_89_1)
  if l_89_0._curve_type == "sine" then
    if not l_89_0._editor_random_access_data then
      local metadata = l_89_0._spline_metadata
      local subsegment_positions, subsegment_distances = l_89_0:extract_editor_random_access_data(l_89_0._positions, metadata.ctrl_points, metadata.nr_subseg_per_seg)
      local tar_subsegment_positions, tar_subsegment_distances = l_89_0:extract_editor_random_access_data(l_89_0._target_positions, metadata.tar_ctrl_points, metadata.nr_subseg_per_seg)
      l_89_0._editor_random_access_data = {subsegment_positions = subsegment_positions, subsegment_distances = subsegment_distances, tar_subsegment_positions = tar_subsegment_positions, tar_subsegment_distances = tar_subsegment_distances}
    end
    return l_89_0:positions_at_time_sine(l_89_1)
  else
    return l_89_0:positions_at_time_bezier(l_89_1)
  end
end

CoreWorldCamera.play_to_time = function(l_90_0, l_90_1)
  if l_90_0._curve_type == "sine" then
    local smooth_time = math.bezier({0, l_90_0._in_acc, l_90_0._out_acc, 1}, math.clamp(l_90_0._timer, 0, 1))
    return l_90_0:play_to_time_sine(smooth_time)
  else
    return l_90_0:positions_at_time_bezier(l_90_0._timer)
  end
end

CoreWorldCamera.positions_at_time_sine = function(l_91_0, l_91_1)
  local result_pos, result_look_pos = nil, nil
  local positions = l_91_0._positions
  local tar_positions = l_91_0._target_positions
  if #positions > 2 then
    local rand_acc_data = l_91_0._editor_random_access_data
    local metadata = l_91_0._spline_metadata
    local wanted_dis_in_spline = math.clamp(l_91_1 * metadata.spline_length, 0, metadata.spline_length)
    local segment_lengths = metadata.segment_lengths
    for seg_i,seg_dis in ipairs(segment_lengths) do
      if not segment_lengths[seg_i - 1] then
        local wanted_dis_in_segment = wanted_dis_in_spline - (wanted_dis_in_spline > seg_dis and seg_i ~= #segment_lengths or 0)
      end
      local subseg_positions = rand_acc_data.subsegment_positions[seg_i]
      local subseg_distances = rand_acc_data.subsegment_distances[seg_i]
      for subseg_i,subseg_dis in ipairs(subseg_distances) do
        if not subseg_distances[subseg_i - 1] then
          local wanted_dis_in_subseg = wanted_dis_in_segment - (wanted_dis_in_segment > subseg_dis and subseg_i ~= #subseg_distances or 0)
        end
        local subseg_pos = subseg_positions[subseg_i]
        if not subseg_positions[subseg_i - 1] then
          local prev_subseg_pos = positions[seg_i]
        end
        local subseg_len = mvector3.distance(subseg_pos, prev_subseg_pos)
        local percent_in_subseg = math.clamp(wanted_dis_in_subseg / subseg_len, 0, 1)
        result_pos = math.lerp(prev_subseg_pos, subseg_pos, percent_in_subseg)
        local percent_in_seg = wanted_dis_in_segment / (seg_dis - (segment_lengths[seg_i - 1] or 0))
        local tar_segment_lengths = metadata.tar_segment_lengths
        local tar_seg_len = tar_segment_lengths[seg_i] - (tar_segment_lengths[seg_i - 1] or 0)
        local wanted_dis_in_tar_seg = tar_seg_len * percent_in_seg
        local tar_subseg_positions = rand_acc_data.tar_subsegment_positions[seg_i]
        local tar_subseg_distances = rand_acc_data.tar_subsegment_distances[seg_i]
        for tar_subseg_i,tar_subseg_dis in ipairs(tar_subseg_distances) do
          if not tar_subseg_distances[tar_subseg_i - 1] then
            local wanted_dis_in_tar_subseg = wanted_dis_in_tar_seg - (wanted_dis_in_tar_seg > tar_subseg_dis and tar_subseg_i ~= #tar_subseg_distances or 0)
          end
          local tar_subseg_pos = tar_subseg_positions[tar_subseg_i]
          if not tar_subseg_positions[tar_subseg_i - 1] then
            local prev_tar_subseg_pos = tar_positions[seg_i]
          end
          local tar_subseg_len = mvector3.distance(tar_subseg_pos, prev_tar_subseg_pos)
          local percent_in_tar_subseg = math.clamp(wanted_dis_in_tar_subseg / tar_subseg_len, 0, 1)
          result_look_pos = result_pos + math.lerp(prev_tar_subseg_pos, tar_subseg_pos, percent_in_tar_subseg)
          do return end
        end
        return result_pos, result_look_pos
      end
    end
  elseif #positions > 1 then
    result_pos = math.lerp(positions[1], positions[2], l_91_1)
    result_look_pos = math.lerp(tar_positions[1], tar_positions[2], l_91_1)
    result_look_pos = result_pos + result_look_pos
  else
    result_pos = positions[1]
    result_look_pos = result_pos + tar_positions[1]
  end
  return result_pos, result_look_pos
end

CoreWorldCamera.play_to_time_sine = function(l_92_0, l_92_1)
  local result_pos, result_look_pos = nil, nil
  if #l_92_0._positions > 2 then
    local segments = l_92_0._positions
    local metadata = l_92_0._spline_metadata
    local runtime_data = l_92_0._spline_runtime_data.pos
    local wanted_dis = (math.clamp(l_92_1 * metadata.spline_length, 0, metadata.spline_length))
    local adv_seg = nil
    repeat
      if runtime_data.seg_i == 0 or runtime_data.seg_dis < wanted_dis then
        runtime_data.seg_i = runtime_data.seg_i + 1
        runtime_data.seg_dis = metadata.segment_lengths[runtime_data.seg_i]
        adv_seg = true
      elseif adv_seg then
        runtime_data.seg_len = metadata.segment_lengths[runtime_data.seg_i] - (metadata.segment_lengths[runtime_data.seg_i - 1] or 0)
        runtime_data.subseg_i = 0
        runtime_data.subseg_dis = 0
        runtime_data.subseg_len = nil
        runtime_data.subseg_pos = nil
        runtime_data.subseg_prev_pos = segments[runtime_data.seg_i]
      end
      local wanted_dis_in_seg = wanted_dis - (metadata.segment_lengths[runtime_data.seg_i - 1] or 0)
      local seg_pos = segments[runtime_data.seg_i]
      local next_seg_pos = segments[runtime_data.seg_i + 1]
      local seg_p1 = metadata.ctrl_points[runtime_data.seg_i + 1].p1
      local seg_p2 = metadata.ctrl_points[runtime_data.seg_i].p2
      repeat
        if (not runtime_data.subseg_pos or runtime_data.subseg_dis < wanted_dis_in_seg) and runtime_data.subseg_i < metadata.nr_subseg_per_seg then
          runtime_data.subseg_i = runtime_data.subseg_i + 1
          local new_subseg_pos = l_92_0:position_at_time_on_segment(runtime_data.subseg_i / metadata.nr_subseg_per_seg, seg_pos, next_seg_pos, seg_p1, seg_p2)
          if not runtime_data.subseg_pos then
            runtime_data.subseg_len = mvector3.distance(runtime_data.subseg_prev_pos, new_subseg_pos)
            runtime_data.subseg_dis = runtime_data.subseg_dis + runtime_data.subseg_len
            if not runtime_data.subseg_pos then
              runtime_data.subseg_prev_pos = runtime_data.subseg_prev_pos
            end
            runtime_data.subseg_pos = new_subseg_pos
          else
            local percentage_in_subseg = 1 - (runtime_data.subseg_dis - wanted_dis_in_seg) / runtime_data.subseg_len
            result_pos = math.lerp(runtime_data.subseg_prev_pos, runtime_data.subseg_pos, percentage_in_subseg)
            local percentage_in_seg = wanted_dis_in_seg / runtime_data.seg_len
            result_look_pos = result_pos + 500 * l_92_0:cam_look_vec_on_segment(percentage_in_seg, runtime_data.seg_i)
          end
        else
          if #l_92_0._positions > 1 then
            result_pos = math.lerp(l_92_0._positions[1], l_92_0._positions[2], l_92_1)
            result_look_pos = math.lerp(l_92_0._target_positions[1], l_92_0._target_positions[2], l_92_1)
            result_look_pos = result_pos + result_look_pos
          else
            result_pos = l_92_0._positions[1]
            result_look_pos = result_pos + l_92_0._target_positions[1]
          end
        end
        return result_pos, result_look_pos
         -- Warning: missing end command somewhere! Added here
      end
       -- Warning: missing end command somewhere! Added here
    end
     -- Warning: missing end command somewhere! Added here
  end
end

CoreWorldCamera.cam_look_vec_on_segment = function(l_93_0, l_93_1, l_93_2)
  local segments = l_93_0._target_positions
  local metadata = l_93_0._spline_metadata
  local runtime_data = l_93_0._spline_runtime_data.dir
  if runtime_data.seg_i ~= l_93_2 then
    runtime_data.seg_i = l_93_2
    runtime_data.subseg_dis = 0
    runtime_data.subseg_i = 0
    runtime_data.subseg_pos = nil
    runtime_data.subseg_prev_pos = segments[runtime_data.seg_i]
  end
  local wanted_dis_in_seg = l_93_1 * (metadata.tar_segment_lengths[l_93_2] - (metadata.tar_segment_lengths[l_93_2 - 1] or 0))
  local seg_pos = segments[l_93_2]
  local next_seg_pos = segments[l_93_2 + 1]
  local seg_p1 = metadata.tar_ctrl_points[l_93_2 + 1].p1
  local seg_p2 = metadata.tar_ctrl_points[l_93_2].p2
  repeat
    if (not runtime_data.subseg_pos or runtime_data.subseg_dis < wanted_dis_in_seg) and runtime_data.subseg_i < metadata.nr_subseg_per_seg then
      runtime_data.subseg_i = runtime_data.subseg_i + 1
      local new_subseg_pos = l_93_0:position_at_time_on_segment(runtime_data.subseg_i / metadata.nr_subseg_per_seg, seg_pos, next_seg_pos, seg_p1, seg_p2)
      if not runtime_data.subseg_pos then
        runtime_data.subseg_len = mvector3.distance(runtime_data.subseg_prev_pos, new_subseg_pos)
        runtime_data.subseg_dis = runtime_data.subseg_dis + runtime_data.subseg_len
        if not runtime_data.subseg_pos then
          runtime_data.subseg_prev_pos = runtime_data.subseg_prev_pos
        end
        runtime_data.subseg_pos = new_subseg_pos
      else
        local percentage_in_subseg = 1 - (runtime_data.subseg_dis - wanted_dis_in_seg) / runtime_data.subseg_len
        do
          local wanted_pos = math.lerp(runtime_data.subseg_prev_pos, runtime_data.subseg_pos, percentage_in_subseg)
          return wanted_pos
        end
         -- Warning: missing end command somewhere! Added here
      end
       -- Warning: missing end command somewhere! Added here
    end
     -- Warning: missing end command somewhere! Added here
  end
end

CoreWorldCamera.position_at_time_on_segment = function(l_94_0, l_94_1, l_94_2, l_94_3, l_94_4, l_94_5)
  local ext_pos1 = math.lerp(l_94_2, l_94_5, l_94_1)
  local ext_pos2 = math.lerp(l_94_4, l_94_3, l_94_1)
  local xpo = (math.sin((l_94_1 * 2 - 1) * 90) + 1) * 0.5
  return math.lerp(ext_pos1, ext_pos2, xpo)
end

CoreWorldCamera.extract_spline_control_points = function(l_95_0, l_95_1, l_95_2, l_95_3, l_95_4)
  do
    local control_points = {}
    if not l_95_3 then
      l_95_3 = 1
    end
    if not l_95_4 then
      l_95_4 = math.min(#l_95_1, #l_95_1)
      if l_95_4 > 2 then
        local i = math.clamp(l_95_3, 2, l_95_4)
        repeat
          if i <= l_95_4 then
            local segment_control_points = l_95_0:extract_control_points_at_index(l_95_1, control_points, i, l_95_2)
            control_points[i] = segment_control_points
            i = i + 1
        end
        if l_95_3 == 1 then
          local segment_control_points = l_95_0:extract_control_points_at_index(l_95_1, control_points, 1, l_95_2)
          control_points[1] = segment_control_points
        end
        return control_points
      end
       -- Warning: missing end command somewhere! Added here
    end
     -- Warning: missing end command somewhere! Added here
  end
end

CoreWorldCamera.extract_control_points_at_index = function(l_96_0, l_96_1, l_96_2, l_96_3, l_96_4)
  local pos = l_96_1[l_96_3]
  local segment_control_points = {}
  local tan_seg = nil
  if l_96_3 == #l_96_1 then
    local last_seg = pos - l_96_1[#l_96_1 - 1]
     -- DECOMPILER ERROR: Confused while interpreting a jump as a 'while'

  end
  local last_vec = l_96_1[1] - l_96_1[#l_96_1 - 1]
  local last_angle = last_vec:angle(last_seg)
  local last_rot = last_seg:cross(last_vec)
  last_rot = Rotation(last_rot, 180 - 2 * last_angle)
  local w_vec = pos + last_vec:rotate_with(last_rot)
  segment_control_points.p1 = w_vec
elseif l_96_3 == 1 then
  local first_vec = l_96_2[2].p1 - l_96_1[2]
  local first_seg = l_96_1[2] - l_96_1[1]
  local first_angle = first_vec:angle(first_seg)
  local first_rot = first_seg:cross(first_vec)
  first_rot = Rotation(first_rot, 180 - 2 * first_angle)
  local w_vec = l_96_1[1] + first_vec:rotate_with(first_rot)
  segment_control_points.p2 = w_vec
else
  tan_seg = l_96_1[l_96_3 + 1] - l_96_1[l_96_3 - 1]
  mvector3.set_length(tan_seg, mvector3.distance(pos, l_96_1[l_96_3 - 1]) * l_96_4)
  segment_control_points.p1 = pos - (tan_seg)
  mvector3.set_length(tan_seg, mvector3.distance(pos, l_96_1[l_96_3 + 1]) * l_96_4)
  segment_control_points.p2 = pos + (tan_seg)
end
return segment_control_points
end

CoreWorldCamera.extract_spline_metadata = function(l_97_0)
  local nr_subseg_per_seg = 30
  local control_points = l_97_0:extract_spline_control_points(l_97_0._positions, 0.5)
  local segment_lengths, spline_length = l_97_0:extract_segment_dis_markers(l_97_0._positions, control_points, nr_subseg_per_seg)
  local tar_control_points = l_97_0:extract_spline_control_points(l_97_0._target_positions, 0.5)
  local tar_segment_lengths, tar_spline_length = l_97_0:extract_segment_dis_markers(l_97_0._target_positions, tar_control_points, nr_subseg_per_seg)
  l_97_0._spline_metadata = {ctrl_points = control_points, segment_lengths = segment_lengths, spline_length = spline_length, tar_ctrl_points = tar_control_points, tar_segment_lengths = tar_segment_lengths, tar_spline_length = tar_spline_length, nr_subseg_per_seg = nr_subseg_per_seg}
end

CoreWorldCamera.extract_segment_dis_markers = function(l_98_0, l_98_1, l_98_2, l_98_3)
  local segment_lengths = {}
  do
    local spline_length = 0
    for index,pos in ipairs(l_98_1) do
      if index == #l_98_1 then
        do return end
      end
      local next_seg_pos = l_98_1[index + 1]
      local seg_p1 = l_98_2[index + 1].p1
      local seg_p2 = l_98_2[index].p2
      local seg_len = 0
      local subsegment_index = 1
      local prev_subseg_pos = pos
      repeat
        if subsegment_index <= l_98_3 then
          local spline_t = math.min(1, subsegment_index / l_98_3)
          local subseg_pos = l_98_0:position_at_time_on_segment(spline_t, pos, next_seg_pos, seg_p1, seg_p2)
          local subseg_len = mvector3.distance(prev_subseg_pos, subseg_pos)
          seg_len = seg_len + subseg_len
          prev_subseg_pos = subseg_pos
          subsegment_index = subsegment_index + 1
        else
          spline_length = spline_length + (seg_len)
          table.insert(segment_lengths, spline_length)
        end
        return segment_lengths, spline_length
      end
       -- Warning: missing end command somewhere! Added here
    end
     -- Warning: missing end command somewhere! Added here
  end
end

CoreWorldCamera.extract_editor_random_access_data = function(l_99_0, l_99_1, l_99_2, l_99_3)
  local subsegment_lengths = {}
  do
    local subsegment_positions = {}
    for index,pos in ipairs(l_99_1) do
      if index == #l_99_1 then
        do return end
      end
      local seg_subsegment_lengths = {}
      local seg_subsegment_positions = {}
      local next_seg_pos = l_99_1[index + 1]
      local seg_p1 = l_99_2[index + 1].p1
      local seg_p2 = l_99_2[index].p2
      local seg_len = 0
      local subsegment_index = 1
      local prev_subseg_pos = pos
      repeat
        if subsegment_index <= l_99_3 then
          local spline_t = math.min(1, subsegment_index / l_99_3)
          local subseg_pos = l_99_0:position_at_time_on_segment(spline_t, pos, next_seg_pos, seg_p1, seg_p2)
          local subseg_len = mvector3.distance(prev_subseg_pos, subseg_pos)
          seg_len = seg_len + subseg_len
          table.insert(seg_subsegment_lengths, seg_len)
          table.insert(seg_subsegment_positions, subseg_pos)
          prev_subseg_pos = subseg_pos
          subsegment_index = subsegment_index + 1
        else
          table.insert(subsegment_lengths, seg_subsegment_lengths)
          table.insert(subsegment_positions, seg_subsegment_positions)
        end
        return subsegment_positions, subsegment_lengths
      end
       -- Warning: missing end command somewhere! Added here
    end
     -- Warning: missing end command somewhere! Added here
  end
end

CoreWorldCamera.debug_draw_editor = function(l_100_0)
  local positions = l_100_0._positions
  local target_positions = l_100_0._target_positions
  local nr_segments = #positions
  if nr_segments > 0 then
    if nr_segments > 2 then
      if l_100_0._curve_type == "sine" then
        local metadata = l_100_0._spline_metadata
        local prev_subseg_pos = positions[1]
        for seg_i,seg_pos in ipairs(positions) do
          if seg_i == #positions then
            do return end
          end
          local seg_p1 = metadata.ctrl_points[seg_i + 1].p1
          local seg_p2 = metadata.ctrl_points[seg_i].p2
          local subsegment_index = 1
          local next_seg_pos = positions[seg_i + 1]
          repeat
            if subsegment_index <= metadata.nr_subseg_per_seg then
              local spline_t = math.min(1, subsegment_index / metadata.nr_subseg_per_seg)
              local subseg_pos = l_100_0:position_at_time_on_segment(spline_t, seg_pos, next_seg_pos, seg_p1, seg_p2)
              Application:draw_line(subseg_pos, prev_subseg_pos, 1, 1, 1)
              prev_subseg_pos = subseg_pos
              subsegment_index = subsegment_index + 1
          else
            end
          end
        else
          local step = 0.019999999552965
          local previous_pos = nil
          for i = step, 1, step do
            local acc = math.bezier({0, l_100_0:in_acc(), l_100_0:out_acc(), 1}, i)
            local cam_pos, cam_look_pos = l_100_0:positions_at_time_bezier(acc)
            if previous_pos then
              Application:draw_line(cam_pos, previous_pos, 1, 1, 1)
            end
            previous_pos = cam_pos
            local look_dir = cam_look_pos - cam_pos
            mvector3.set_length(look_dir, 100)
            mvector3.add(look_dir, cam_pos)
            Application:draw_line(cam_pos, look_dir, 1, 1, 0)
          end
        end
      end
      for i,pos in ipairs(positions) do
        if i ~= nr_segments then
          Application:draw_line(pos, positions[i + 1], 0.75, 0.75, 0.75)
        end
        Application:draw_sphere(pos, 20, 1, 1, 1)
        local t_pos = target_positions[i]
        Application:draw_line(pos, pos + t_pos - pos:normalized() * 500, 1, 1, 0)
      end
    end
     -- Warning: missing end command somewhere! Added here
  end
end

CoreWorldCamera.update_dof_values = function(l_101_0, ...)
  managers.worldcamera:update_dof_values(...)
   -- DECOMPILER ERROR: Confused about usage of registers for local variables.

end

CoreWorldCamera.set_current_fov = function(l_102_0, l_102_1)
  managers.worldcamera:set_fov(l_102_1)
end

CoreWorldCamera.play = function(l_103_0, l_103_1)
  if #l_103_0._positions == 0 then
    return false, "Camera " .. l_103_0._world_camera_name .. " didn't have any points."
  end
  if l_103_0._duration == 0 then
    return false, "Camera " .. l_103_0._world_camera_name .. " has duration 0, must be higher."
  end
  l_103_0._timer = l_103_1.start or 0
  l_103_0._stop_timer = l_103_1.stop or 1
  l_103_0._delay_timer = 0
  l_103_0._index = 1
  l_103_0._target_point = nil
  l_103_0._playing = true
  if not l_103_0._curve_type or l_103_0._curve_type == "bezier" then
    l_103_0:set_curve_type_bezier()
    l_103_0._bezier = l_103_0:bezier_function()
  end
  local runtime_data_pos = {}
  runtime_data_pos.seg_dis = 0
  runtime_data_pos.seg_len = 0
  runtime_data_pos.seg_i = 0
  runtime_data_pos.subseg_i = 0
  runtime_data_pos.subseg_prev_pos = l_103_0._positions[1]
  local runtime_data_look_dir = {}
  runtime_data_look_dir.seg_i = 0
  runtime_data_look_dir.subseg_i = 0
  runtime_data_look_dir.subseg_prev_pos = l_103_0._target_positions[1]
  l_103_0._spline_runtime_data = {}
  l_103_0._spline_runtime_data.pos = runtime_data_pos
  l_103_0._spline_runtime_data.dir = runtime_data_look_dir
  l_103_0:update_camera(l_103_0._positions[1], l_103_0._target_positions[1])
  l_103_0:set_current_fov(l_103_0:value_at_time(l_103_0._timer, "fov"))
  return true
end

CoreWorldCamera.stop = function(l_104_0)
  l_104_0._playing = false
  l_104_0._bezier = nil
  l_104_0._spline_runtime_data = nil
end

CoreWorldCamera.bezier_function = function(l_105_0)
  if #l_105_0._positions == 2 then
    return math.linear_bezier
  else
    if #l_105_0._positions == 3 then
      return math.quadratic_bezier
    else
      if #l_105_0._positions == 4 then
        return math.bezier
      end
    end
  end
  return nil
end

CoreWorldCamera.update_camera = function(l_106_0, l_106_1, l_106_2)
  managers.worldcamera:camera_controller():set_camera(l_106_1)
  managers.worldcamera:camera_controller():set_target(l_106_2)
end

CoreWorldCamera.add_point = function(l_107_0, l_107_1, l_107_2)
  if l_107_0._curve_type == "sine" then
    table.insert(l_107_0._positions, l_107_1)
    table.insert(l_107_0._target_positions, l_107_2:y())
    if #l_107_0._positions == 3 then
      l_107_0:extract_spline_metadata()
    else
      if #l_107_0._positions > 3 then
        local new_control_points = l_107_0:extract_spline_control_points(l_107_0._positions, 0.5, #l_107_0._positions - 1, #l_107_0._positions)
        l_107_0._spline_metadata.ctrl_points[#l_107_0._positions - 1] = new_control_points[#l_107_0._positions - 1]
        l_107_0._spline_metadata.ctrl_points[#l_107_0._positions] = new_control_points[#l_107_0._positions]
        local segment_lengths, spline_length = l_107_0:extract_segment_dis_markers(l_107_0._positions, l_107_0._spline_metadata.ctrl_points, l_107_0._spline_metadata.nr_subseg_per_seg)
        l_107_0._spline_metadata.segment_lengths = segment_lengths
        l_107_0._spline_metadata.spline_length = spline_length
        new_control_points = l_107_0:extract_spline_control_points(l_107_0._target_positions, 0.5, #l_107_0._target_positions - 1, #l_107_0._target_positions)
        l_107_0._spline_metadata.tar_ctrl_points[#l_107_0._target_positions - 1] = new_control_points[#l_107_0._target_positions - 1]
        l_107_0._spline_metadata.tar_ctrl_points[#l_107_0._target_positions] = new_control_points[#l_107_0._target_positions]
        segment_lengths, spline_length = l_107_0:extract_segment_dis_markers(l_107_0._target_positions, l_107_0._spline_metadata.tar_ctrl_points, l_107_0._spline_metadata.nr_subseg_per_seg)
        l_107_0._spline_metadata.tar_segment_lengths = segment_lengths
        l_107_0._spline_metadata.tar_spline_length = spline_length
      end
    end
    l_107_0:delete_editor_random_access_data()
  else
    if #l_107_0._positions < 4 then
      table.insert(l_107_0._positions, l_107_1)
      table.insert(l_107_0._target_positions, l_107_1 + l_107_2:y() * l_107_0._target_offset)
    end
  end
end

CoreWorldCamera.get_points = function(l_108_0)
  return l_108_0._positions
end

CoreWorldCamera.get_point = function(l_109_0, l_109_1)
  return {pos = l_109_0._positions[l_109_1], t_pos = l_109_0._target_positions[l_109_1]}
end

CoreWorldCamera.delete_point = function(l_110_0, l_110_1)
  table.remove(l_110_0._positions, l_110_1)
  table.remove(l_110_0._target_positions, l_110_1)
  if l_110_0._curve_type == "sine" then
    if #l_110_0._positions < 3 then
      l_110_0:delete_spline_metadata()
    else
      table.remove(l_110_0._spline_metadata.ctrl_points, l_110_1)
      table.remove(l_110_0._spline_metadata.tar_ctrl_points, l_110_1)
      l_110_0._spline_metadata.ctrl_points[1].p1 = nil
      l_110_0._spline_metadata.ctrl_points[#l_110_0._positions].p2 = nil
      l_110_0._spline_metadata.tar_ctrl_points[1].p1 = nil
      l_110_0._spline_metadata.tar_ctrl_points[#l_110_0._target_positions].p2 = nil
      local segment_lengths, spline_length = l_110_0:extract_segment_dis_markers(l_110_0._positions, l_110_0._spline_metadata.ctrl_points, l_110_0._spline_metadata.nr_subseg_per_seg)
      l_110_0._spline_metadata.segment_lengths = segment_lengths
      l_110_0._spline_metadata.spline_length = spline_length
      segment_lengths, spline_length = l_110_0:extract_segment_dis_markers(l_110_0._target_positions, l_110_0._spline_metadata.tar_ctrl_points, l_110_0._spline_metadata.nr_subseg_per_seg)
      l_110_0._spline_metadata.tar_segment_lengths = segment_lengths
      l_110_0._spline_metadata.tar_spline_length = spline_length
    end
    l_110_0:delete_editor_random_access_data()
  end
end

CoreWorldCamera.delete_spline_metadata = function(l_111_0)
  l_111_0._spline_metadata = nil
end

CoreWorldCamera.delete_editor_random_access_data = function(l_112_0)
  l_112_0._editor_random_access_data = nil
end

CoreWorldCamera.reset_control_points = function(l_113_0, l_113_1)
  if l_113_0._curve_type == "sine" and #l_113_0._positions > 2 then
    local control_points = l_113_0:extract_control_points_at_index(l_113_0._positions, l_113_0._spline_metadata.ctrl_points, l_113_1, 0.5)
    l_113_0._spline_metadata.ctrl_points[l_113_1] = control_points
    local segment_lengths, spline_length = l_113_0:extract_segment_dis_markers(l_113_0._positions, l_113_0._spline_metadata.ctrl_points, l_113_0._spline_metadata.nr_subseg_per_seg)
    l_113_0._spline_metadata.spline_length = spline_length
    l_113_0._spline_metadata.segment_lengths = segment_lengths
    l_113_0:delete_editor_random_access_data()
  end
end

CoreWorldCamera.move_point = function(l_114_0, l_114_1, l_114_2, l_114_3)
  if l_114_0._curve_type == "sine" then
    if l_114_2 then
      if #l_114_0._positions > 2 then
        l_114_0:set_sine_segment_position(l_114_2, l_114_1, l_114_0._positions, l_114_0._spline_metadata.ctrl_points[l_114_1])
        local segment_lengths, spline_length = l_114_0:extract_segment_dis_markers(l_114_0._positions, l_114_0._spline_metadata.ctrl_points, l_114_0._spline_metadata.nr_subseg_per_seg)
        l_114_0._spline_metadata.spline_length = spline_length
        l_114_0._spline_metadata.segment_lengths = segment_lengths
      else
        l_114_0._positions[l_114_1] = l_114_2
      end
    end
    if l_114_3 then
      if #l_114_0._positions > 2 then
        l_114_0:set_sine_segment_position(l_114_3:y(), l_114_1, l_114_0._target_positions, l_114_0._spline_metadata.tar_ctrl_points[l_114_1])
        local new_control_points = l_114_0:extract_spline_control_points(l_114_0._target_positions, 0.5, l_114_1 - 1, l_114_1 + 1)
        for k,v in pairs(new_control_points) do
          l_114_0._spline_metadata.tar_ctrl_points[k] = v
        end
        local segment_lengths, spline_length = l_114_0:extract_segment_dis_markers(l_114_0._target_positions, l_114_0._spline_metadata.tar_ctrl_points, l_114_0._spline_metadata.nr_subseg_per_seg)
        l_114_0._spline_metadata.tar_spline_length = spline_length
        l_114_0._spline_metadata.tar_segment_lengths = segment_lengths
      else
        l_114_0._target_positions[l_114_1] = l_114_3:y()
      end
    end
    l_114_0:delete_editor_random_access_data()
  elseif l_114_2 then
    l_114_0._positions[l_114_1] = l_114_2
  end
  if l_114_3 then
    local t_pos = l_114_3:y() * l_114_0._target_offset + l_114_0._positions[l_114_1]
    l_114_0._target_positions[l_114_1] = t_pos
  end
end

CoreWorldCamera.positions = function(l_115_0)
  return l_115_0._positions
end

CoreWorldCamera.target_positions = function(l_116_0)
  return l_116_0._target_positions
end

CoreWorldCamera.insert_point = function(l_117_0, l_117_1, l_117_2, l_117_3)
end

CoreWorldCamera.keys = function(l_118_0)
  return l_118_0._keys
end

CoreWorldCamera.key = function(l_119_0, l_119_1)
  return l_119_0._keys[l_119_1]
end

CoreWorldCamera.next_key = function(l_120_0, l_120_1)
  local index = 1
  for i,key in ipairs(l_120_0._keys) do
    if key.time <= l_120_1 then
      index = i + 1
    end
  end
  if #l_120_0._keys < index then
    index = #l_120_0._keys
  end
  return index
end

CoreWorldCamera.prev_key = function(l_121_0, l_121_1, l_121_2)
  do
    local index = 1
    for i,key in ipairs(l_121_0._keys) do
       -- DECOMPILER ERROR: unhandled construct in 'if'

      if l_121_2 and key.time < l_121_1 then
        index = i
        for (for control),i in (for generator) do
          if key.time <= l_121_1 then
            index = i
          end
        end
      end
      return index
    end
     -- Warning: missing end command somewhere! Added here
  end
end

CoreWorldCamera.add_key = function(l_122_0, l_122_1)
  local index = 1
  local fov, near_dof, far_dof, roll = nil, nil, nil, nil
  fov = math.round(l_122_0:value_at_time(l_122_1, "fov"))
  near_dof = math.round(l_122_0:value_at_time(l_122_1, "near_dof"))
  far_dof = math.round(l_122_0:value_at_time(l_122_1, "far_dof"))
  roll = math.round(l_122_0:value_at_time(l_122_1, "roll"))
  do
    local key = {time = l_122_1, fov = fov, near_dof = near_dof, far_dof = far_dof, roll = roll}
    for i,key in ipairs(l_122_0._keys) do
      if key.time < l_122_1 then
        index = i + 1
        for (for control),i in (for generator) do
          do return end
        end
      end
      table.insert(l_122_0._keys, index, key)
      return index, key
    end
     -- Warning: missing end command somewhere! Added here
  end
end

CoreWorldCamera.delete_key = function(l_123_0, l_123_1)
  table.remove(l_123_0._keys, l_123_1)
end

CoreWorldCamera.move_key = function(l_124_0, l_124_1, l_124_2)
  if #l_124_0._keys == 1 then
    l_124_0._keys[1].time = l_124_2
    return 1
  else
    local old_key = clone(l_124_0._keys[l_124_1])
    l_124_0:delete_key(l_124_1)
    local index, key = l_124_0:add_key(l_124_2)
    key.fov = old_key.fov
    key.near_dof = old_key.near_dof
    key.far_dof = old_key.far_dof
    key.roll = old_key.roll
    return index
  end
end

CoreWorldCamera.value_at_time = function(l_125_0, l_125_1, l_125_2)
  local prev_key = l_125_0:prev_value_key(l_125_1, l_125_2)
  local next_key = l_125_0:next_value_key(l_125_1, l_125_2)
  local mul = 1
  if next_key.time - prev_key.time ~= 0 then
    mul = (l_125_1 - prev_key.time) / (next_key.time - prev_key.time)
  end
  local v = (next_key[l_125_2] - prev_key[l_125_2]) * (mul) + prev_key[l_125_2]
  return v
end

CoreWorldCamera.prev_value_key = function(l_126_0, l_126_1, l_126_2)
  local index = l_126_0:prev_key(l_126_1)
  local key = l_126_0._keys[index]
  if key[l_126_2] then
    return key
  else
    return l_126_0:prev_value_key(key.time, l_126_2)
  end
end

CoreWorldCamera.next_value_key = function(l_127_0, l_127_1, l_127_2)
  local index = l_127_0:next_key(l_127_1)
  local key = l_127_0._keys[index]
  if key[l_127_2] then
    return key
  else
    return l_127_0:next_value_key(key.time, l_127_2)
  end
end

CoreWorldCamera.print_points = function(l_128_0)
  for i = 1, 4 do
    cat_print("debug", i, l_128_0._positions[i], l_128_0._target_positions[i])
  end
end

CoreWorldCamera.playing = function(l_129_0)
  return l_129_0._playing
end


