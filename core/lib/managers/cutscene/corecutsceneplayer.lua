-- Decompiled using luadec 2.0.1 by sztupy (http://winmo.sztupy.hu)
-- Command line was: F:\SteamLibrary\SteamApps\common\PAYDAY 2\lua\core\lib\managers\cutscene\corecutsceneplayer.luac 

require("core/lib/managers/cutscene/CoreCutsceneCast")
require("core/lib/managers/cutscene/CoreCutsceneKeyCollection")
core:import("CoreManagerBase")
if not CoreCutscenePlayer then
  CoreCutscenePlayer = class()
end
mixin(CoreCutscenePlayer, get_core_or_local("CutsceneKeyCollection"))
CoreCutscenePlayer.BLACK_BAR_GUI_LAYER = 29
CoreCutscenePlayer.BLACK_BAR_TOP_GUI_NAME = "__CutscenePlayer__black_bar_top"
CoreCutscenePlayer.BLACK_BAR_BOTTOM_GUI_NAME = "__CutscenePlayer__black_bar_bottom"
CoreCutscenePlayer._all_keys_sorted_by_time = function(l_1_0)
  return l_1_0._owned_cutscene_keys
end

CoreCutscenePlayer.init = function(l_2_0, l_2_1, l_2_2, l_2_3)
  l_2_0._cutscene = assert(l_2_1, "No cutscene supplied.")
  if not l_2_2 then
    l_2_0._viewport = l_2_0:_create_viewport()
  end
  l_2_0._dof_environment_modifier = assert(l_2_0._viewport:environment_mixer():create_modifier(false, "dof", function(...)
    return self:_dof_modifier_cb(...)
     -- DECOMPILER ERROR: Confused about usage of registers for local variables.

   end), "[CoreCutscenePlayer] Environment modifier alredy created by: " .. tostring(l_2_0._viewport:environment_mixer():modifier_owner("dof")))
  if not l_2_3 then
    l_2_0._cast = l_2_0:_create_cast()
  end
  l_2_0._owned_cutscene_keys = {}
  l_2_0._time = 0
  cat_print("cutscene", string.format("[CoreCutscenePlayer] Created CutscenePlayer for \"%s\".", l_2_0:cutscene_name()))
  if not alive(l_2_0._viewport:camera()) then
    l_2_0:_create_camera()
  end
  l_2_0:_create_future_camera()
  l_2_0:_clear_workspace()
  l_2_0._resolution_changed_callback_id = managers.viewport:add_resolution_changed_func(callback(l_2_0, l_2_0, "_configure_viewport"))
end

CoreCutscenePlayer._create_future_camera = function(l_3_0)
  l_3_0._future_camera_locator = World:spawn_unit(Idstring("core/units/locator/locator"), Vector3(0, 0, 0), Rotation())
  l_3_0._future_camera = World:create_camera()
  l_3_0:_initialize_camera(l_3_0._future_camera)
  l_3_0._future_camera:link(l_3_0._future_camera_locator:get_object("locator"))
  l_3_0._future_camera:set_local_rotation(Rotation(-90, 0, 0))
  l_3_0._cast:_reparent_to_locator_unit(l_3_0._cast:_root_unit(), l_3_0._future_camera_locator)
end

CoreCutscenePlayer.add_keys = function(l_4_0, l_4_1)
  if not l_4_1 then
    l_4_1 = l_4_0._cutscene
  end
  for _,template_key in ipairs(l_4_1:_all_keys_sorted_by_time()) do
    if l_4_0:_is_driving_sound_key(template_key) then
      l_4_0:_set_driving_sound_from_key(template_key)
      for (for control),_ in (for generator) do
      end
      local cutscene_key = template_key:clone()
      cutscene_key:set_key_collection(l_4_0)
      cutscene_key:set_cast(l_4_0._cast)
      table.insert(l_4_0._owned_cutscene_keys, cutscene_key)
    end
     -- Warning: missing end command somewhere! Added here
  end
end

CoreCutscenePlayer._is_driving_sound_key = function(l_5_0, l_5_1)
  return (l_5_1.ELEMENT_NAME == CoreSoundCutsceneKey.ELEMENT_NAME and l_5_1:frame() == 0 and l_5_1:sync_to_video())
end

CoreCutscenePlayer._set_driving_sound_from_key = function(l_6_0, l_6_1)
  cat_print("cutscene", string.format("[CoreCutscenePlayer] Using sound cue \"%s/%s\" to drive the playhead.", l_6_1:bank(), l_6_1:cue()))
  l_6_0._driving_sound = assert(Sound:make_bank(l_6_1:bank(), l_6_1:cue()), string.format("Driving sound cue \"%s/%s\" not found.", l_6_1:bank(), l_6_1:cue()))
end

CoreCutscenePlayer.set_timer = function(l_7_0, l_7_1)
  l_7_0._cast:set_timer(l_7_1)
  if alive(l_7_0._workspace) then
    l_7_0._workspace:set_timer(l_7_1)
  end
  local camera_controller = l_7_0:_camera_controller()
  if alive(camera_controller) then
    camera_controller:set_timer(l_7_1)
  end
end

CoreCutscenePlayer.viewport = function(l_8_0)
  return l_8_0._viewport
end

CoreCutscenePlayer.cutscene_name = function(l_9_0)
  return l_9_0._cutscene:name()
end

CoreCutscenePlayer.cutscene_duration = function(l_10_0)
  return l_10_0._cutscene:duration()
end

CoreCutscenePlayer.camera_attributes = function(l_11_0)
  local camera = l_11_0:_camera()
  local attributes = {}
  attributes.aspect_ratio = camera:aspect_ratio()
  attributes.fov = camera:fov()
  attributes.near_range = camera:near_range()
  attributes.far_range = camera:far_range()
  if l_11_0._dof_attributes then
    for key,value in pairs(l_11_0._dof_attributes) do
      attributes[key] = value
    end
  end
  return attributes
end

CoreCutscenePlayer.depth_of_field_attributes = function(l_12_0)
  return l_12_0._dof_attributes
end

CoreCutscenePlayer.prime = function(l_13_0)
  if not l_13_0._primed then
    l_13_0._cast:prime(l_13_0._cutscene)
    for _,cutscene_key in dpairs(l_13_0._owned_cutscene_keys) do
      if cutscene_key:is_valid() then
        l_13_0:prime_cutscene_key(cutscene_key)
        for (for control),_ in (for generator) do
        end
        if not cutscene_key.__tostring or not cutscene_key:__tostring() then
          Application:error(string.format("[CoreCutscenePlayer] Invalid cutscene key in \"%s\": %s", l_13_0:cutscene_name(), tostring(cutscene_key)))
        end
        table.delete(l_13_0._owned_cutscene_keys, cutscene_key)
      end
      l_13_0:_process_camera_cutscene_keys_between(-1, 0)
      if l_13_0:_camera_object() ~= nil then
        l_13_0:_reparent_camera()
      end
      if l_13_0._driving_sound then
        l_13_0._driving_sound:prime()
      end
      l_13_0._primed = true
    end
     -- Warning: missing end command somewhere! Added here
  end
end

CoreCutscenePlayer.is_primed = function(l_14_0)
  return l_14_0._primed == true
end

CoreCutscenePlayer._driving_sound_offset = function(l_15_0)
  if alive(l_15_0._driving_sound_instance) then
    local master_sound_instance = l_15_0:_master_driving_sound_instance(l_15_0._driving_sound_instance)
    if master_sound_instance == nil then
      return 0
    else
      if not alive(master_sound_instance) or not master_sound_instance:is_playing() then
        return nil
      end
    end
    local name, offset = master_sound_instance:offset()
    if offset < l_15_0._time then
      cat_print("cutscene", string.format("[CoreCutscenePlayer] Bad SoundInstance offset: Got %g, previous was %g.", offset, l_15_0._time))
      offset = l_15_0._time
    end
    return offset
  end
  return nil
end

CoreCutscenePlayer._master_driving_sound_instance = function(l_16_0, l_16_1)
  if not l_16_0._driving_sound_instance_map then
    l_16_0._driving_sound_instance_map = {}
  end
  local master_instance = l_16_0._driving_sound_instance_map[l_16_1]
  if master_instance == nil then
    if l_16_1.playing_instances then
      master_instance = l_16_1:playing_instances()[1]
    else
      master_instance = l_16_1
    end
    l_16_0._driving_sound_instance_map[l_16_1] = master_instance
  end
  return master_instance
end

CoreCutscenePlayer.is_presentable = function(l_17_0)
  return not l_17_0._cast:is_ready(l_17_0._cutscene) or 1 > 0 or not l_17_0._cast:is_ready(l_17_0._cutscene) or 1 > 0
end

CoreCutscenePlayer.is_viewport_enabled = function(l_18_0)
  if managers.viewport and l_18_0._viewport then
    return l_18_0._viewport:active()
  end
end

CoreCutscenePlayer.unload = function(l_19_0)
  l_19_0:stop()
  for key in l_19_0:keys_between(math.huge, -math.huge) do
    key:unload(l_19_0)
  end
  if l_19_0._owned_cast then
    l_19_0._owned_cast:unload()
  end
end

CoreCutscenePlayer.destroy = function(l_20_0)
  cat_print("cutscene", string.format("[CoreCutscenePlayer] Destroying CutscenePlayer for \"%s\".", l_20_0:cutscene_name()))
  l_20_0:set_viewport_enabled(false)
  if not l_20_0._owned_gui_objects then
    for gui_name,_ in pairs({}) do
    end
    l_20_0:invoke_callback_in_gui(gui_name, "on_cutscene_player_destroyed", l_20_0)
  end
  l_20_0._owned_gui_objects = nil
  l_20_0:unload()
  l_20_0._viewport:environment_mixer():destroy_modifier(l_20_0._dof_environment_modifier)
  if l_20_0._listener_id and managers.listener then
    managers.listener:remove_listener(l_20_0._listener_id)
  end
  l_20_0._listener_id = nil
  if l_20_0._resolution_changed_callback_id and managers.viewport then
    managers.viewport:remove_resolution_changed_func(l_20_0._resolution_changed_callback_id)
  end
  l_20_0._resolution_changed_callback_id = nil
  if l_20_0._owned_camera_controller then
    l_20_0._viewport:director():release_camera()
    assert(l_20_0._viewport:director():camera() == nil)
  end
  if alive(l_20_0._workspace) then
    Overlay:newgui():destroy_workspace(l_20_0._workspace)
  end
  l_20_0._workspace = nil
  if l_20_0._owned_viewport and l_20_0._owned_viewport:alive() then
    l_20_0._owned_viewport:destroy()
  end
  l_20_0._owned_viewport = nil
  if alive(l_20_0._owned_camera) then
    World:delete_camera(l_20_0._owned_camera)
  end
  l_20_0._owned_camera = nil
  if alive(l_20_0._future_camera) then
    World:delete_camera(l_20_0._future_camera)
  end
  l_20_0._future_camera = nil
  if alive(l_20_0._future_camera_locator) then
    World:delete_unit(l_20_0._future_camera_locator)
  end
  l_20_0._future_camera_locator = nil
end

CoreCutscenePlayer.update = function(l_21_0, l_21_1, l_21_2)
  local done = false
  if l_21_0:is_playing() then
    if alive(l_21_0._driving_sound_instance) then
      l_21_0._driving_sound_instance:unpause()
    elseif l_21_0._driving_sound then
      l_21_0._driving_sound_instance = l_21_0._driving_sound:play("offset", l_21_0._time)
    end
    if l_21_0:is_presentable() then
      if not l_21_0:_driving_sound_offset() then
        local offset = l_21_0._time + l_21_2
      end
      done = l_21_0:seek(offset, l_21_0._time == offset) == false
    else
      if alive(l_21_0._driving_sound_instance) then
        l_21_0._driving_sound_instance:pause()
      end
    end
  end
  if done then
    l_21_0:stop()
  else
    if l_21_0:is_viewport_enabled() then
      l_21_0:refresh()
    end
  end
  return not done
end

CoreCutscenePlayer.refresh = function(l_22_0)
  if l_22_0:_camera_has_cut() and managers.environment then
    managers.environment:clear_luminance()
  end
  l_22_0:_update_future_camera()
end

CoreCutscenePlayer.evaluate_current_frame = function(l_23_0)
  l_23_0._last_evaluated_time = l_23_0._last_evaluated_time or -1
  l_23_0:_set_visible(true)
  l_23_0:_process_discontinuity_cutscene_keys_between(l_23_0._last_evaluated_time, l_23_0._time)
  l_23_0:_evaluate_animations()
  l_23_0:_resume_discontinuity()
  l_23_0:_process_camera_cutscene_keys_between(l_23_0._last_evaluated_time, l_23_0._time)
  l_23_0:_reparent_camera()
  l_23_0:_process_non_camera_cutscene_keys_between(l_23_0._last_evaluated_time, l_23_0._time)
  l_23_0._last_evaluated_time = l_23_0._time
end

CoreCutscenePlayer.preroll_cutscene_keys = function(l_24_0)
  if l_24_0._time > 0 then
    return 
  end
  for _,cutscene_key in ipairs(l_24_0:_all_keys_sorted_by_time()) do
    if cutscene_key:frame() > 0 then
      do return end
    end
    if cutscene_key.preroll then
      cutscene_key:preroll(l_24_0)
    end
  end
end

CoreCutscenePlayer.is_playing = function(l_25_0)
  return l_25_0._playing or false
end

CoreCutscenePlayer.play = function(l_26_0)
  l_26_0._playing = true
  for _,cutscene_key in ipairs(l_26_0:_all_keys_sorted_by_time()) do
    if cutscene_key.resume then
      cutscene_key:resume(l_26_0)
    end
  end
end

CoreCutscenePlayer.pause = function(l_27_0)
  l_27_0._playing = nil
  for _,cutscene_key in ipairs(l_27_0:_all_keys_sorted_by_time()) do
    if cutscene_key.pause then
      cutscene_key:pause(l_27_0)
    end
  end
end

CoreCutscenePlayer.stop = function(l_28_0)
  l_28_0._playing = nil
  l_28_0._driving_sound_instance = nil
  l_28_0:_set_visible(false)
end

CoreCutscenePlayer.skip_to_end = function(l_29_0)
  for key in l_29_0:keys_between(l_29_0._time, math.huge) do
    if key.skip then
      l_29_0:skip_cutscene_key(key)
    end
  end
  if alive(l_29_0._driving_sound_instance) then
    l_29_0._driving_sound_instance:stop()
  end
  l_29_0._driving_sound_instance = nil
  l_29_0._time = l_29_0:cutscene_duration()
end

CoreCutscenePlayer.seek = function(l_30_0, l_30_1, l_30_2)
  l_30_0._time = math.min(math.max(0, l_30_1), l_30_0:cutscene_duration())
  if not l_30_2 then
    l_30_0:evaluate_current_frame()
  end
  return l_30_0._time == l_30_1
end

CoreCutscenePlayer.distance_from_camera = function(l_31_0, l_31_1, l_31_2)
  local object = l_31_0:_actor_object(l_31_1, l_31_2)
  if object then
    local distance = l_31_0:_camera():world_to_screen(object:position()).z
  end
  return distance
end

CoreCutscenePlayer.set_camera = function(l_32_0, l_32_1)
  assert((l_32_1 ~= nil and string.begins(l_32_1, "camera")))
  l_32_0._camera_name = l_32_1
end

CoreCutscenePlayer.set_camera_attribute = function(l_33_0, l_33_1, l_33_2)
  local camera = l_33_0:_camera()
  local func = assert(camera.set_" .. l_33_, "Invalid camera attribute.")
  func(camera, l_33_2)
  func(l_33_0._future_camera, l_33_2)
end

CoreCutscenePlayer.set_camera_depth_of_field = function(l_34_0, l_34_1, l_34_2)
  local range = l_34_2 - l_34_1
  if not l_34_0._dof_attributes then
    l_34_0._dof_attributes = {}
  end
  l_34_0._dof_attributes.near_focus_distance_min = math.max(9.9999999747524e-007, l_34_1 - range * 0.33000001311302)
  l_34_0._dof_attributes.near_focus_distance_max = math.max(9.9999999747524e-007, l_34_1)
  l_34_0._dof_attributes.far_focus_distance_min = l_34_2
  l_34_0._dof_attributes.far_focus_distance_max = l_34_2 + range * 0.6700000166893
end

CoreCutscenePlayer._dof_modifier_cb = function(l_35_0, l_35_1)
  local output = l_35_1:parameters()
  if l_35_0._dof_attributes then
    output.clamp = 1
    output.near_focus_distance_min = l_35_0._dof_attributes.near_focus_distance_min
    output.near_focus_distance_max = l_35_0._dof_attributes.near_focus_distance_max
    output.far_focus_distance_min = l_35_0._dof_attributes.far_focus_distance_min
    output.far_focus_distance_max = l_35_0._dof_attributes.far_focus_distance_max
  end
  return output
end

CoreCutscenePlayer.play_camera_shake = function(l_36_0, l_36_1, l_36_2, l_36_3, l_36_4)
  local shake_id = l_36_0._viewport:director():shaker():play(l_36_1, l_36_2, l_36_3, l_36_4)
  return function()
    self._viewport:director():shaker():stop_immediately(shake_id)
   end
end

CoreCutscenePlayer.has_gui = function(l_37_0, l_37_1)
  return l_37_0._owned_gui_objects ~= nil and l_37_0._owned_gui_objects[l_37_1] ~= nil
end

CoreCutscenePlayer.load_gui = function(l_38_0, l_38_1)
  local preload = true
  Overlay:newgui():preload(l_38_1)
  l_38_0:_gui_panel(l_38_1, preload)
  l_38_0:set_gui_visible(l_38_1, false)
end

CoreCutscenePlayer.set_gui_visible = function(l_39_0, l_39_1, l_39_2)
  local panel = l_39_0:_gui_panel(l_39_1)
  if not l_39_2 == panel:visible() then
    l_39_0:invoke_callback_in_gui(l_39_1, "on_cutscene_player_set_visible", l_39_2, l_39_0)
    panel:set_visible(l_39_2)
  end
end

CoreCutscenePlayer.invoke_callback_in_gui = function(l_40_0, l_40_1, l_40_2, ...)
  if l_40_0._owned_gui_objects then
    local gui_object = l_40_0._owned_gui_objects[l_40_1]
  end
  if alive(gui_object) and gui_object:has_script() then
    local script = gui_object:script()
    do
      local callback_func = rawget(script, l_40_2)
      if type(callback_func) == "function" then
        if Application:production_build() then
          local argument_string = table.concat(table.collect({...}, function(l_1_0)
      if type(l_1_0) ~= "string" or not string.format("%q", l_1_0) then
        return tostring(l_1_0)
      end
      end), ", ")
          cat_print("cutscene", string.format("[CoreCutscenePlayer] Calling %s(%s) in Gui \"%s\".", l_40_2, argument_string, l_40_1))
        end
        callback_func(...)
      end
       -- DECOMPILER ERROR: Confused about usage of registers for local variables.

    end
  end
end

CoreCutscenePlayer._gui_panel = function(l_41_0, l_41_1, l_41_2)
  local panel = l_41_0._workspace:panel():child(l_41_1)
  if panel == nil then
    if not l_41_2 then
      Application:error("[CoreCutscenePlayer] The gui \"" .. l_41_1 .. "\" was not preloaded, causing a performance spike.")
    end
    if not l_41_0._owned_gui_objects then
      l_41_0._owned_gui_objects = {}
    end
    local viewport_rect = l_41_0:_viewport_rect()
    panel = l_41_0._workspace:panel():panel({name = l_41_1, visible = false, halign = "grow", valign = "grow", x = viewport_rect.px, y = viewport_rect.py, width = viewport_rect.pw, height = viewport_rect.ph})
    local gui_object = panel:gui(l_41_1)
    l_41_0._owned_gui_objects[l_41_1] = gui_object
  end
  return panel
end

CoreCutscenePlayer.set_viewport_enabled = function(l_42_0, l_42_1)
  local is_enabled = l_42_0._viewport:active()
  if l_42_1 ~= is_enabled then
    if l_42_1 then
      l_42_0._viewport:set_active(true)
    else
      l_42_0._viewport:set_active(false)
    end
    l_42_0:_set_listener_enabled(l_42_1)
    l_42_0:_set_depth_of_field_enabled(l_42_1)
    l_42_0._viewport:set_width_mul_enabled(not l_42_1)
    local black_bars_enabled = not l_42_0._widescreen or l_42_1
    l_42_0._workspace:panel():child(l_42_0.BLACK_BAR_TOP_GUI_NAME):set_visible(black_bars_enabled)
    l_42_0._workspace:panel():child(l_42_0.BLACK_BAR_BOTTOM_GUI_NAME):set_visible(black_bars_enabled)
  end
end

CoreCutscenePlayer.set_widescreen = function(l_43_0, l_43_1)
  l_43_0._widescreen = l_43_1 or nil
  l_43_0:_configure_viewport()
end

CoreCutscenePlayer.set_key_handler = function(l_44_0, l_44_1)
  l_44_0._key_handler = l_44_1
end

CoreCutscenePlayer.prime_cutscene_key = function(l_45_0, l_45_1, l_45_2)
  local delegate = l_45_0._key_handler
  if delegate and delegate.prime_cutscene_key then
    return delegate.prime_cutscene_key(delegate, l_45_0, l_45_1, l_45_2)
  else
    return l_45_1:prime(l_45_0)
  end
end

CoreCutscenePlayer.evaluate_cutscene_key = function(l_46_0, l_46_1, l_46_2, l_46_3)
  local delegate = l_46_0._key_handler
  if delegate and delegate.evaluate_cutscene_key then
    return delegate.evaluate_cutscene_key(delegate, l_46_0, l_46_1, l_46_2, l_46_3)
  else
    return l_46_1:play(l_46_0, false, false)
  end
end

CoreCutscenePlayer.revert_cutscene_key = function(l_47_0, l_47_1, l_47_2, l_47_3)
  local delegate = l_47_0._key_handler
  if delegate and delegate.revert_cutscene_key then
    return delegate.revert_cutscene_key(delegate, l_47_0, l_47_1, l_47_2, l_47_3)
  else
    return l_47_1:play(l_47_0, true, false)
  end
end

CoreCutscenePlayer.update_cutscene_key = function(l_48_0, l_48_1, l_48_2, l_48_3)
  local delegate = l_48_0._key_handler
  if delegate and delegate.update_cutscene_key then
    return delegate.update_cutscene_key(delegate, l_48_0, l_48_1, l_48_2, l_48_3)
  else
    return l_48_1:update(l_48_0, l_48_2)
  end
end

CoreCutscenePlayer.skip_cutscene_key = function(l_49_0, l_49_1)
  local delegate = l_49_0._key_handler
  if delegate and delegate.skip_cutscene_key then
    return delegate.skip_cutscene_key(delegate, l_49_0, l_49_1)
  else
    return l_49_1:skip(l_49_0)
  end
end

CoreCutscenePlayer.time_in_relation_to_cutscene_key = function(l_50_0, l_50_1)
  local delegate = l_50_0._key_handler
  if delegate and delegate.time_in_relation_to_cutscene_key then
    return delegate.time_in_relation_to_cutscene_key(delegate, l_50_1)
  else
    return l_50_0._time - l_50_1:time()
  end
end

CoreCutscenePlayer._set_visible = function(l_51_0, l_51_1)
  l_51_0._cast:set_cutscene_visible(l_51_0._cutscene, l_51_1)
end

CoreCutscenePlayer._set_listener_enabled = function(l_52_0, l_52_1)
  if l_52_1 and not l_52_0._listener_activation_id then
    l_52_0._listener_activation_id = managers.listener:activate_set("main", "cutscene")
    do return end
    if l_52_0._listener_activation_id then
      managers.listener:deactivate_set(l_52_0._listener_activation_id)
    end
    l_52_0._listener_activation_id = nil
  end
end

CoreCutscenePlayer._set_depth_of_field_enabled = function(l_53_0, l_53_1)
  if l_53_1 then
    managers.environment:disable_dof()
  else
    managers.environment:enable_dof()
    managers.environment:needs_update()
  end
end

CoreCutscenePlayer._viewport_rect = function(l_54_0)
  if not l_54_0._widescreen or not l_54_0:_wide_viewport_rect() then
    return l_54_0:_full_viewport_rect()
  end
end

CoreCutscenePlayer._full_viewport_rect = function(l_55_0)
  local resolution = RenderSettings.resolution
  return {x = 0, y = 0, w = 1, h = 1, px = 0, py = 0, pw = resolution.x, ph = resolution.y}
end

CoreCutscenePlayer._wide_viewport_rect = function(l_56_0)
  local resolution = RenderSettings.resolution
  local resolution_aspect = 1 / managers.viewport:aspect_ratio()
  local cutscene_aspect = 0.5625
  local viewport_width = math.min(resolution_aspect / cutscene_aspect, 1)
  local viewport_height = 1 / resolution_aspect * cutscene_aspect * viewport_width
  local viewport_x = (1 - viewport_width) / 2
  local viewport_y = (1 - viewport_height) / 2
  local rect = {x = viewport_x, y = viewport_y, w = viewport_width, h = viewport_height}
  rect.px = rect.x * resolution.x
  rect.py = rect.y * resolution.y
  rect.pw = rect.w * resolution.x
  rect.ph = rect.h * resolution.y
  return rect
end

CoreCutscenePlayer._camera = function(l_57_0)
  if not l_57_0._viewport:camera() then
    return l_57_0:_create_camera()
  end
end

CoreCutscenePlayer._camera_controller = function(l_58_0)
  local controller = l_58_0._viewport:director():camera()
  if not controller then
    return l_58_0:_create_camera_controller()
  end
end

CoreCutscenePlayer._camera_object = function(l_59_0)
  if l_59_0._camera_name then
    return l_59_0:_actor_object(l_59_0._camera_name, "locator")
  end
end

CoreCutscenePlayer._actor_object = function(l_60_0, l_60_1, l_60_2)
  local unit = l_60_0._cast:actor_unit(l_60_1, l_60_0._cutscene)
  if unit == nil and managers.cutscene then
    unit = managers.cutscene:cutscene_actors_in_world()[l_60_1]
  end
  if unit then
    return unit:get_object(l_60_2)
  end
end

CoreCutscenePlayer._clear_workspace = function(l_61_0)
  if alive(l_61_0._workspace) then
    Overlay:newgui():destroy_workspace(l_61_0._workspace)
  end
  local resolution = RenderSettings.resolution
  l_61_0._workspace = Overlay:newgui():create_scaled_screen_workspace(resolution.x, resolution.y, 0, 0, resolution.x)
  l_61_0._workspace:set_timer(managers.cutscene:timer())
  l_61_0._workspace:panel():rect({visible = l_61_0._widescreen, layer = l_61_0.BLACK_BAR_GUI_LAYER, name = l_61_0.BLACK_BAR_TOP_GUI_NAME, color = Color.black})
  l_61_0._workspace:panel():rect({visible = l_61_0._widescreen, layer = l_61_0.BLACK_BAR_GUI_LAYER, name = l_61_0.BLACK_BAR_BOTTOM_GUI_NAME, color = Color.black})
  l_61_0._workspace:show()
  l_61_0:_configure_viewport()
end

CoreCutscenePlayer._create_viewport = function(l_62_0)
  assert(l_62_0._owned_viewport == nil)
  l_62_0._owned_viewport = managers.viewport:new_vp(0, 0, 1, 1, "cutscene", CoreManagerBase.PRIO_CUTSCENE)
  return l_62_0._owned_viewport
end

CoreCutscenePlayer._configure_viewport = function(l_63_0)
  l_63_0:set_camera_attribute("aspect_ratio", managers.viewport:aspect_ratio())
  if alive(l_63_0._workspace) then
    local resolution = RenderSettings.resolution
    l_63_0._workspace:set_screen(resolution.x, resolution.y, 0, 0, resolution.x)
    local viewport_rect = l_63_0:_viewport_rect()
    if l_63_0._widescreen then
      local black_bars_enabled = l_63_0:is_viewport_enabled()
    end
    l_63_0._workspace:panel():child(l_63_0.BLACK_BAR_TOP_GUI_NAME):configure({visible = black_bars_enabled, x = 0, y = 0, width = viewport_rect.pw, height = viewport_rect.py})
    l_63_0._workspace:panel():child(l_63_0.BLACK_BAR_BOTTOM_GUI_NAME):configure({visible = black_bars_enabled, x = 0, y = resolution.y - viewport_rect.py, width = viewport_rect.pw, height = viewport_rect.py})
    if l_63_0._owned_gui_objects then
      for gui_name,_ in pairs(table.map_copy(l_63_0._owned_gui_objects)) do
        l_63_0:invoke_callback_in_gui(gui_name, "on_cutscene_player_set_visible", false, l_63_0)
        l_63_0:invoke_callback_in_gui(gui_name, "on_cutscene_player_destroyed", l_63_0)
        local panel = l_63_0._workspace:panel():child(gui_name)
        panel:clear()
        panel:configure({x = viewport_rect.px, y = viewport_rect.py, width = viewport_rect.pw, height = viewport_rect.ph})
        l_63_0._owned_gui_objects[gui_name] = panel:gui(gui_name)
      end
    end
  end
end

CoreCutscenePlayer._create_camera = function(l_64_0)
  assert(l_64_0._owned_camera == nil)
  l_64_0._owned_camera = World:create_camera()
  l_64_0:_initialize_camera(l_64_0._owned_camera)
  l_64_0._viewport:set_camera(l_64_0._owned_camera)
  return l_64_0._owned_camera
end

CoreCutscenePlayer._initialize_camera = function(l_65_0, l_65_1)
  l_65_1:set_fov(CoreZoomCameraCutsceneKey.DEFAULT_CAMERA_FOV)
  l_65_1:set_near_range(7.5)
  l_65_1:set_far_range(50000)
  l_65_1:set_width_multiplier(1)
end

CoreCutscenePlayer._create_camera_controller = function(l_66_0)
  assert(l_66_0._owned_camera_controller == nil)
  l_66_0._owned_camera_controller = l_66_0._viewport:director():make_camera(l_66_0:_camera(), "cutscene_camera")
  l_66_0._owned_camera_controller:set_timer(managers.cutscene:timer())
  l_66_0._viewport:director():set_camera(l_66_0._owned_camera_controller)
  return l_66_0._owned_camera_controller
end

CoreCutscenePlayer._create_cast = function(l_67_0)
  assert(l_67_0._owned_cast == nil)
  l_67_0._owned_cast = core_or_local("CutsceneCast")
  return l_67_0._owned_cast
end

CoreCutscenePlayer._evaluate_animations = function(l_68_0)
  l_68_0._cast:evaluate_cutscene_at_time(l_68_0._cutscene, l_68_0._time)
end

CoreCutscenePlayer._notify_discontinuity = function(l_69_0)
  for unit_name,_ in pairs(l_69_0._cutscene:controlled_unit_types()) do
    local unit = l_69_0._cast:actor_unit(unit_name, l_69_0._cutscene)
    for index = 0, unit:num_bodies() - 1 do
      local body = unit:body(index)
      if body:dynamic() and body:enabled() then
        body:set_enabled(false)
        if not l_69_0._disabled_bodies then
          l_69_0._disabled_bodies = {}
        end
        table.insert(l_69_0._disabled_bodies, body)
      end
    end
  end
end

CoreCutscenePlayer._resume_discontinuity = function(l_70_0)
  if l_70_0._disabled_bodies then
    for _,body in ipairs(l_70_0._disabled_bodies) do
      body:enable_with_no_velocity()
    end
    l_70_0._disabled_bodies = nil
  end
end

CoreCutscenePlayer._process_discontinuity_cutscene_keys_between = function(l_71_0, l_71_1, l_71_2)
  for key in l_71_0:keys_between(l_71_1, l_71_2, CoreDiscontinuityCutsceneKey.ELEMENT_NAME) do
    l_71_0:evaluate_cutscene_key(key, l_71_2, l_71_1)
  end
end

CoreCutscenePlayer._process_camera_cutscene_keys_between = function(l_72_0, l_72_1, l_72_2)
  for key in l_72_0:keys_between(l_72_1, l_72_2, CoreChangeCameraCutsceneKey.ELEMENT_NAME) do
    if l_72_1 < l_72_2 then
      l_72_0:evaluate_cutscene_key(key, l_72_2, l_72_1)
      for (for control) in (for generator) do
      end
      l_72_0:revert_cutscene_key(key, l_72_2, l_72_1)
    end
    for key in l_72_0:keys_to_update(l_72_2, CoreChangeCameraCutsceneKey.ELEMENT_NAME) do
      l_72_0:update_cutscene_key(key, l_72_2 - key:time(), math.max(0, l_72_1 - key:time()))
    end
     -- Warning: missing end command somewhere! Added here
  end
end

CoreCutscenePlayer._process_non_camera_cutscene_keys_between = function(l_73_0, l_73_1, l_73_2)
  for key in l_73_0:keys_between(l_73_1, l_73_2) do
    if key.ELEMENT_NAME ~= CoreChangeCameraCutsceneKey.ELEMENT_NAME and key.ELEMENT_NAME ~= CoreDiscontinuityCutsceneKey.ELEMENT_NAME then
      if l_73_1 < l_73_2 then
        l_73_0:evaluate_cutscene_key(key, l_73_2, l_73_1)
        for (for control) in (for generator) do
        end
        l_73_0:revert_cutscene_key(key, l_73_2, l_73_1)
      end
    end
    for key in l_73_0:keys_to_update(l_73_2) do
      if key.ELEMENT_NAME ~= CoreChangeCameraCutsceneKey.ELEMENT_NAME and key.ELEMENT_NAME ~= CoreDiscontinuityCutsceneKey.ELEMENT_NAME then
        l_73_0:update_cutscene_key(key, l_73_2 - key:time(), math.max(0, l_73_1 - key:time()))
      end
    end
     -- Warning: missing end command somewhere! Added here
  end
end

CoreCutscenePlayer._reparent_camera = function(l_74_0)
  if l_74_0._camera_name then
    local camera_object = assert(l_74_0:_camera_object(), string.format("Camera \"%s\" not found in cutscene \"%s\".", l_74_0._camera_name, l_74_0:cutscene_name()))
  end
  if camera_object ~= nil and camera_object ~= l_74_0:_camera_controller():get_camera() then
    l_74_0:_camera_controller():set_both(camera_object)
    if l_74_0._listener_id then
      managers.listener:set_listener(l_74_0._listener_id, camera_object)
    else
      l_74_0._listener_id = managers.listener:add_listener("cutscene", camera_object)
    end
  end
end

CoreCutscenePlayer._update_future_camera = function(l_75_0)
  if l_75_0._cutscene:is_optimized() then
    local position, rotation = l_75_0._cast:evaluate_object_at_time(l_75_0._cutscene, "camera", "locator", l_75_0._time + 0.16666667163372)
    l_75_0._future_camera_locator:warp_to(rotation, position)
    World:effect_manager():add_camera(l_75_0._future_camera)
    World:lod_viewers():add_viewer(l_75_0._future_camera)
  end
end

CoreCutscenePlayer._camera_has_cut = function(l_76_0)
  if not l_76_0._last_frame_camera_position then
    l_76_0._last_frame_camera_position = Vector3(0, 0, 0)
  end
  if not l_76_0._last_frame_camera_rotation then
    l_76_0._last_frame_camera_rotation = Rotation()
  end
  local camera = l_76_0:_camera()
  local camera_position = camera:position()
  local camera_rotation = camera:rotation()
  local position_difference = l_76_0._last_frame_camera_position - camera_position
  local rotation_difference = Rotation:rotation_difference(l_76_0._last_frame_camera_rotation, camera_rotation)
  local position_threshold_reached = position_difference:length() > 50
  local rotation_threshold_reached = rotation_difference:yaw() > 5 or rotation_difference:pitch() > 5 or rotation_difference:roll() > 5
  l_76_0._last_frame_camera_position = camera_position
  l_76_0._last_frame_camera_rotation = camera_rotation
  return position_threshold_reached or rotation_threshold_reached
end


