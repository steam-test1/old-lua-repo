-- Decompiled using luadec 2.0.1 by sztupy (http://winmo.sztupy.hu)
-- Command line was: F:\SteamLibrary\SteamApps\common\PAYDAY 2\lua\core\lib\managers\coredofmanager.luac 

core:module("CoreDOFManager")
if not DOFManager then
  DOFManager = class()
end
DOFManager.init = function(l_1_0)
  l_1_0._queued_effects = {}
  l_1_0._sorted_effect_list = {}
  l_1_0._last_id = 0
  l_1_0._current_effect = nil
  l_1_0._enabled = true
  l_1_0._var_map = {"near_min", "near_max", "far_min", "far_max"}
  l_1_0._game_timer = TimerManager:game()
  l_1_0._env_dof_enabled = true
  l_1_0._environment_parameters = {near_min = 0, near_max = 0, far_min = 0, far_max = 0, clamp = 0}
  l_1_0._clamp_prev_frame = 0
end

DOFManager.save = function(l_2_0, l_2_1)
  if next(l_2_0._queued_effects) then
    local state = {}
    state.queued_effects = clone(l_2_0._queued_effects)
    l_2_1.DOFManager = state
  end
end

DOFManager.load = function(l_3_0, l_3_1)
  local state = l_3_1.DOFManager
  if state then
    if state.queued_effects then
      l_3_0._queued_effects = clone(state.queued_effects)
    else
      l_3_0._queued_effects = {}
    end
  end
end

DOFManager.update = function(l_4_0, l_4_1, l_4_2)
  l_4_0:remove_expired_effects(l_4_1, l_4_2)
  l_4_0._current_effect = l_4_0._sorted_effect_list[1]
  local new_data, new_clamp = nil, nil
  if l_4_0._current_effect then
    l_4_0:update_effect(l_4_1, l_4_2, l_4_0._current_effect)
    if l_4_0:check_dof_allowed() then
      new_data = l_4_0._queued_effects[l_4_0._current_effect]
    end
  end
  if new_data then
    if l_4_0._env_dof_enabled then
      assert(not l_4_0._dof_modifier)
      l_4_0._dof_modifier = assert(managers.viewport:viewports()[1]:environment_mixer():create_modifier(false, "shared_dof", function(...)
        return self:modifier_callback(...)
         -- DECOMPILER ERROR: Confused about usage of registers for local variables.

         end))
      l_4_0._env_dof_enabled = nil
    end
    new_data = new_data.prog_data
    if new_data.dirty then
      new_clamp = new_data.clamp
    end
    if new_clamp then
      new_data = new_data.cur_values
    end
    if new_data then
      if l_4_0._clamp_prev_frame ~= new_clamp then
        l_4_0._clamp_prev_frame = new_clamp
      end
      l_4_0:feed_dof(new_data.near_min, new_data.near_max, new_data.far_min, new_data.far_max, new_clamp)
    elseif not l_4_0._env_dof_enabled and managers.viewport:get_active_vp() then
      assert(l_4_0._dof_modifier)
      managers.viewport:viewports()[1]:environment_mixer():destroy_modifier(l_4_0._dof_modifier)
      l_4_0._env_dof_enabled = true
    end
  end
end

DOFManager.update_world_camera = function(l_5_0, l_5_1, l_5_2, l_5_3)
  managers.worldcamera:update_dof(l_5_1, l_5_2, l_5_3)
end

DOFManager.paused_update = function(l_6_0, l_6_1, l_6_2)
  l_6_0:update(l_6_1, l_6_2)
end

DOFManager.modifier_callback = function(l_7_0, l_7_1)
  l_7_0._modifier_output = l_7_1:parameters()
  return assert(l_7_0._modifier_input)
end

DOFManager.feed_dof = function(l_8_0, l_8_1, l_8_2, l_8_3, l_8_4, l_8_5)
  l_8_0._modifier_input = {}
  l_8_0._modifier_input.near_focus_distance_min = l_8_1
  l_8_0._modifier_input.near_focus_distance_max = l_8_2
  l_8_0._modifier_input.far_focus_distance_min = l_8_3
  l_8_0._modifier_input.far_focus_distance_max = l_8_4
  l_8_0._modifier_input.clamp = l_8_5
end

DOFManager.get_dof_parameters = function(l_9_0)
  if l_9_0._current_effect then
    return l_9_0._queued_effects[l_9_0._current_effect].prog_data.cur_values
  end
end

DOFManager.get_dof_values = function(l_10_0)
  assert(l_10_0._modifier_output)
  return l_10_0._modifier_output.near_focus_distance_min, l_10_0._modifier_output.near_focus_distance_max, l_10_0._modifier_output.far_focus_distance_min, l_10_0._modifier_output.far_focus_distance_max, l_10_0._modifier_output.clamp
end

DOFManager.debug_draw_feed = function(l_11_0, l_11_1, l_11_2, l_11_3, l_11_4, l_11_5)
  local vp = managers.viewport:first_active_viewport()
  if vp and alive(vp:camera()) then
    local camera = vp:camera()
    local cam_dir = camera:rotation():y()
    local cam_pos = camera:position() - math.UP * 50
    Application:draw_cone(cam_pos + cam_dir * l_11_2, cam_pos + cam_dir * l_11_1, 49 * l_11_5 + 1, 0, 0, 1)
    Application:draw_cone(cam_pos + cam_dir * l_11_3, cam_pos + cam_dir * l_11_4, 49 * l_11_5 + 1, 0, 1, 0)
  end
end

DOFManager.remove_expired_effects = function(l_12_0, l_12_1, l_12_2)
  local id, effect = next(l_12_0._queued_effects)
  repeat
    if id then
      if effect.prog_data.finish_t then
        if not effect.preset.timer then
          local eff_t = l_12_0._game_timer:time()
          if effect.prog_data.finish_t <= eff_t then
            l_12_0:intern_remove_effect(id)
          end
        end
        id, effect = next(l_12_0._queued_effects, id)
      else
         -- Warning: missing end command somewhere! Added here
      end
       -- Warning: missing end command somewhere! Added here
    end
     -- Warning: missing end command somewhere! Added here
  end
end

DOFManager.update_effect = function(l_13_0, l_13_1, l_13_2, l_13_3)
  local effect = l_13_0._queued_effects[l_13_3]
  local preset = effect.preset
  local prog = effect.prog_data
  local eff_t = preset.timer and preset.timer:time() or l_13_1
  if prog.fade_in_end and eff_t < prog.fade_in_end then
    prog.lerp = (eff_t - prog.start_t) / preset.fade_in
    l_13_0:calculate_current_parameters_fade_in(l_13_1, l_13_2, effect)
  elseif not prog.sustain_end or eff_t < prog.sustain_end then
    prog.lerp = 1
    l_13_0:calculate_current_parameters_sustain(l_13_1, l_13_2, effect)
  elseif prog.finish_t then
    prog.lerp = (prog.finish_t - eff_t) / preset.fade_out
    l_13_0:calculate_current_parameters_fade_out(l_13_1, l_13_2, effect, l_13_3)
  end
end

DOFManager.calculate_current_parameters_fade_in = function(l_14_0, l_14_1, l_14_2, l_14_3)
  local next_eff_sort = l_14_3.prog_data.sort_index + 1
  local next_eff_id = l_14_0._sorted_effect_list[next_eff_sort]
  local init = nil
  if next_eff_id then
    l_14_0:update_effect(l_14_1, l_14_2, next_eff_id)
    init = l_14_0._queued_effects[l_14_0._sorted_effect_list[next_eff_sort]].prog_data.cur_values
  end
  if not init then
    init = l_14_0._environment_parameters
  end
  local cur = l_14_3.prog_data.cur_values
  local tar = l_14_3.prog_data.target_values
  local eff_lerp = l_14_3.prog_data.lerp
  for _,v in pairs(l_14_0._var_map) do
    cur[v] = math.lerp(init[v], tar[v], eff_lerp)
  end
  cur.clamp = math.lerp(init.clamp, l_14_3.prog_data.clamp, eff_lerp)
  l_14_3.prog_data.dirty = true
end

DOFManager.calculate_current_parameters_sustain = function(l_15_0, l_15_1, l_15_2, l_15_3)
  if l_15_3.prog_data.peak_reached then
    l_15_3.prog_data.dirty = nil
  else
    l_15_3.prog_data.peak_reached = true
    local cur = l_15_3.prog_data.cur_values
    local tar = l_15_3.prog_data.target_values
    for _,v in pairs(l_15_0._var_map) do
      cur[v] = tar[v]
    end
    cur.clamp = l_15_3.prog_data.clamp
    l_15_3.prog_data.dirty = true
  end
end

DOFManager.calculate_current_parameters_fade_out = function(l_16_0, l_16_1, l_16_2, l_16_3, l_16_4)
  local next_eff_sort = l_16_3.prog_data.sort_index + 1
  local next_eff_id = l_16_0._sorted_effect_list[next_eff_sort]
  local out = nil
  if next_eff_id then
    l_16_0:update_effect(l_16_1, l_16_2, next_eff_id)
    out = l_16_0._queued_effects[l_16_0._sorted_effect_list[next_eff_sort]].prog_data.cur_values
  end
  if not out then
    out = l_16_0._environment_parameters
  end
  local cur = l_16_3.prog_data.cur_values
  local tar = l_16_3.prog_data.target_values
  local eff_lerp = l_16_3.prog_data.lerp
  for _,v in pairs(l_16_0._var_map) do
    cur[v] = math.lerp(out[v], tar[v], eff_lerp)
  end
  cur.clamp = math.lerp(out.clamp, l_16_3.prog_data.clamp, eff_lerp)
  l_16_3.prog_data.dirty = true
end

DOFManager.play = function(l_17_0, l_17_1, l_17_2)
  l_17_0._last_id = l_17_0._last_id + 1
  local new_data = {}
  if not l_17_1.timer then
    local timer = l_17_0._game_timer
  end
  local t = timer:time()
  local prog_data = {}
  if not l_17_2 or not l_17_1.clamp * l_17_2 then
    prog_data.clamp = l_17_1.clamp
  end
  prog_data.fade_in_end = l_17_1.fade_in and t + l_17_1.fade_in or t
  if l_17_1.sustain then
    prog_data.sustain_end = prog_data.fade_in_end + l_17_1.sustain
  end
  prog_data.finish_t = prog_data.sustain_end + (not prog_data.sustain_end or l_17_1.fade_out or 0)
  prog_data.start_t = t
  local cur_values = nil
  local near_min, near_max, far_min, far_max, clamp = l_17_0:get_dof_values()
  if clamp > 0 then
    cur_values = {near_min = near_min, near_max = near_max, far_min = far_min, far_max = far_max, clamp = clamp}
  else
    cur_values = {near_min = 0, near_max = 0, far_min = 0, far_max = 0, clamp = 0}
  end
  local target_values = {}
  for _,v in pairs(l_17_0._var_map) do
    target_values[v] = l_17_1[v]
  end
  prog_data.target_values = target_values
  prog_data.cur_values = cur_values
  new_data.preset = l_17_1
  new_data.prog_data = prog_data
  l_17_0._queued_effects[l_17_0._last_id] = new_data
  l_17_0:add_to_sorted_list(l_17_0._last_id, l_17_1.prio)
  return l_17_0._last_id
end

DOFManager.add_to_sorted_list = function(l_18_0, l_18_1, l_18_2)
  local allocated = nil
  for index,eff_id in ipairs(l_18_0._sorted_effect_list) do
    if l_18_0._queued_effects[eff_id].preset.prio <= l_18_2 then
      table.insert(l_18_0._sorted_effect_list, index, l_18_1)
      allocated = true
  else
    end
  end
  if not allocated then
    table.insert(l_18_0._sorted_effect_list, l_18_1)
  end
  for index,eff_id in ipairs(l_18_0._sorted_effect_list) do
    l_18_0._queued_effects[eff_id].prog_data.sort_index = index
  end
end

DOFManager.remove_from_sorted_list = function(l_19_0, l_19_1)
  for index,eff_id in ipairs(l_19_0._sorted_effect_list) do
    if eff_id == l_19_1 then
      table.remove(l_19_0._sorted_effect_list, index)
  else
    end
  end
  for index,eff_id in ipairs(l_19_0._sorted_effect_list) do
    l_19_0._queued_effects[eff_id].prog_data.sort_index = index
  end
end

DOFManager.stop = function(l_20_0, l_20_1, l_20_2)
  local effect = l_20_0._queued_effects[l_20_1]
  if effect then
    if l_20_2 then
      l_20_0:intern_remove_effect(l_20_1)
      if l_20_0._current_effect == l_20_1 then
        l_20_0._current_effect = nil
      else
        if not effect.preset.timer then
          local t = l_20_0._game_timer:time()
          effect.prog_data.sustain_end = t
          effect.prog_data.finish_t = t + (effect.preset.fade_out or 0)
        end
      end
    end
     -- Warning: missing end command somewhere! Added here
  end
end

DOFManager.stop_all = function(l_21_0, l_21_1)
  l_21_0._queued_effects = {}
  l_21_0._sorted_effect_list = {}
  l_21_0._current_effect = nil
  managers.environment:enable_dof()
  managers.environment:needs_update("PE")
  l_21_0._env_dof_enabled = true
  if managers.viewport:get_active_vp() then
    l_21_0:feed_dof(0, 0, 0, 0, 0)
  end
end

DOFManager.intern_remove_effect = function(l_22_0, l_22_1)
  l_22_0._queued_effects[l_22_1] = nil
  l_22_0:remove_from_sorted_list(l_22_1)
end

DOFManager.check_dof_allowed = function(l_23_0)
  return l_23_0._enabled
end

DOFManager.set_enabled = function(l_24_0, l_24_1)
  l_24_0._enabled = l_24_1
end

DOFManager.is_effect_playing = function(l_25_0, l_25_1)
  return not l_25_1 or not l_25_0._queued_effects[l_25_1] or true
end

DOFManager.from_env_mgr_set_env_dof = function(l_26_0, l_26_1)
  local env_param = l_26_0._environment_parameters
  env_param.near_min = l_26_1.near_focus_distance_min
  env_param.near_max = l_26_1.near_focus_distance_max
  env_param.far_min = l_26_1.far_focus_distance_min
  env_param.far_max = l_26_1.far_focus_distance_max
  env_param.clamp = l_26_1.clamp
end

DOFManager.clbk_environment_change = function(l_27_0)
  local env_data = managers.environment:get_posteffect()
  if env_data then
    env_data = env_data._post_processors
  end
  if env_data then
    env_data = env_data.hdr_post_processor
  end
  if env_data then
    env_data = env_data._modifiers
  end
  if env_data then
    env_data = env_data.dof
  end
  if env_data then
    env_data = env_data._params
  end
  if env_data then
    l_27_0._environment_parameters = {near_min = env_data.near_focus_distance_min, near_max = env_data.near_focus_distance_max, far_min = env_data.far_focus_distance_min, far_max = env_data.far_focus_distance_max, clamp = env_data.clamp}
  end
end

DOFManager.set_effect_parameters = function(l_28_0, l_28_1, l_28_2, l_28_3)
  if l_28_0._queued_effects[l_28_1] then
    if l_28_2 then
      for k,v in pairs(l_28_2) do
        l_28_0._queued_effects[l_28_1].prog_data.target_values[k] = v
      end
    end
    if l_28_3 then
      l_28_0._queued_effects[l_28_1].prog_data.clamp = l_28_3
    end
    l_28_0._queued_effects[l_28_1].prog_data.peak_reached = nil
    return true
  end
end


