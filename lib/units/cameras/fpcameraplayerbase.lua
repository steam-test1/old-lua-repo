-- Decompiled using luadec 2.0.1 by sztupy (http://winmo.sztupy.hu)
-- Command line was: F:\SteamLibrary\SteamApps\common\PAYDAY 2\lua\lib\units\cameras\fpcameraplayerbase.luac 

if not FPCameraPlayerBase then
  FPCameraPlayerBase = class(UnitBase)
end
FPCameraPlayerBase.IDS_EMPTY = Idstring("empty")
FPCameraPlayerBase.IDS_NOSTRING = Idstring("")
FPCameraPlayerBase.init = function(l_1_0, l_1_1)
  UnitBase.init(l_1_0, l_1_1, true)
  l_1_0._unit = l_1_1
  l_1_1:set_timer(managers.player:player_timer())
  l_1_1:set_animation_timer(managers.player:player_timer())
  l_1_0._anims_enabled = true
  l_1_0._obj_eye = l_1_0._unit:orientation_object()
  l_1_0._weap_align = l_1_0._unit:get_object(Idstring("right_weapon_align"))
  l_1_0._camera_properties = {spin = 0, pitch = 0.5}
  l_1_0._output_data = {position = l_1_1:position(), rotation = l_1_1:rotation()}
  l_1_0._head_stance = {}
  l_1_0._head_stance.translation = Vector3()
  l_1_0._head_stance.rotation = Rotation()
  l_1_0._shoulder_stance = {}
  l_1_0._shoulder_stance.translation = Vector3()
  l_1_0._shoulder_stance.rotation = Rotation()
  l_1_0._vel_overshot = {}
  l_1_0._vel_overshot.translation = Vector3()
  l_1_0._vel_overshot.rotation = Rotation()
  l_1_0._vel_overshot.last_yaw = 0
  l_1_0._vel_overshot.last_pitch = 0
  l_1_0._vel_overshot.target_yaw = 0
  l_1_0._vel_overshot.target_pitch = 0
  l_1_0._aim_assist = {}
  l_1_0._aim_assist.direction = Vector3()
  l_1_0._aim_assist.distance = 0
  l_1_0._aim_assist.mrotation = Rotation()
  l_1_0._fov = {fov = 75}
  l_1_0._input = {}
  l_1_0._tweak_data = {}
  l_1_0._tweak_data.look_speed_dead_zone = 0.10000000149012
  l_1_0._tweak_data.look_speed_standard = 120
  l_1_0._tweak_data.look_speed_fast = 360
  l_1_0._tweak_data.look_speed_steel_sight = 60
  l_1_0._tweak_data.look_speed_transition_to_fast = 0.5
  l_1_0._tweak_data.look_speed_transition_zone = 0.80000001192093
  l_1_0._tweak_data.look_speed_transition_occluder = 0.94999998807907
  l_1_0._tweak_data.overshot_multiplier_yaw = 1
  l_1_0._tweak_data.overshot_multiplier_pitch = 1
  l_1_0._tweak_data.aim_assist_speed = 200
  l_1_0._camera_properties.look_speed_current = l_1_0._tweak_data.look_speed_standard
  l_1_0._camera_properties.look_speed_transition_timer = 0
  l_1_0._camera_properties.target_tilt = 0
  l_1_0._camera_properties.current_tilt = 0
  l_1_0._recoil_kick = {}
  l_1_0._recoil_kick.h = {}
  l_1_0:check_flashlight_enabled()
end

FPCameraPlayerBase.set_parent_unit = function(l_2_0, l_2_1)
  l_2_0._parent_unit = l_2_1
  l_2_0._parent_movement_ext = l_2_0._parent_unit:movement()
  l_2_1:base():add_destroy_listener("FPCameraPlayerBase", callback(l_2_0, l_2_0, "parent_destroyed_clbk"))
  local controller_type = l_2_0._parent_unit:base():controller():get_default_controller_id()
  if controller_type == "keyboard" then
    l_2_0._look_function = callback(l_2_0, l_2_0, "_pc_look_function")
  else
    l_2_0._look_function = callback(l_2_0, l_2_0, "_gamepad_look_function")
    l_2_0._tweak_data.overshot_multiplier_yaw = 16
    l_2_0._tweak_data.overshot_multiplier_pitch = l_2_0._tweak_data.overshot_multiplier_yaw / 3
  end
end

FPCameraPlayerBase.parent_destroyed_clbk = function(l_3_0, l_3_1)
  l_3_0._unit:set_extension_update_enabled(Idstring("base"), false)
  l_3_0:set_slot(l_3_0._unit, 0)
  l_3_0._parent_unit = nil
end

FPCameraPlayerBase.reset_properties = function(l_4_0)
  l_4_0._camera_properties.spin = l_4_0._parent_unit:rotation():y():to_polar().spin
end

FPCameraPlayerBase.update = function(l_5_0, l_5_1, l_5_2, l_5_3)
  l_5_0._parent_unit:base():controller():get_input_axis_clbk("look", callback(l_5_0, l_5_0, "_update_rot"))
  l_5_0:_update_stance(l_5_2, l_5_3)
  l_5_0:_update_movement(l_5_2, l_5_3)
  l_5_0._parent_unit:camera():set_position(l_5_0._output_data.position)
  l_5_0._parent_unit:camera():set_rotation(l_5_0._output_data.rotation)
  if l_5_0._fov.dirty then
    l_5_0._parent_unit:camera():set_FOV(l_5_0._fov.fov)
    l_5_0._fov.dirty = nil
  end
  if alive(l_5_0._light) then
    local weapon = l_5_0._parent_unit:inventory():equipped_unit()
    if weapon then
      local object = weapon:get_object(Idstring("fire"))
      local pos = object:position() + object:rotation():y() * 10 + object:rotation():x() * 0 + object:rotation():z() * -2
      l_5_0._light:set_position(pos)
      l_5_0._light:set_rotation(Rotation(object:rotation():z(), object:rotation():x(), object:rotation():y()))
      World:effect_manager():move_rotate(l_5_0._light_effect, pos, Rotation(object:rotation():x(), -object:rotation():y(), -object:rotation():z()))
    end
  end
end

FPCameraPlayerBase.check_flashlight_enabled = function(l_6_0)
  if managers.game_play_central:flashlights_on_player_on() then
    if not alive(l_6_0._light) then
      l_6_0._light = World:create_light("spot|specular")
      l_6_0._light:set_spot_angle_end(45)
      l_6_0._light:set_far_range(1000)
    end
    if not l_6_0._light_effect then
      l_6_0._light_effect = World:effect_manager():spawn({effect = Idstring("effects/particles/weapons/flashlight/fp_flashlight"), position = l_6_0._unit:position(), rotation = Rotation()})
    end
    l_6_0._light:set_enable(true)
    World:effect_manager():set_hidden(l_6_0._light_effect, false)
  else
    if alive(l_6_0._light) then
      l_6_0._light:set_enable(false)
      World:effect_manager():set_hidden(l_6_0._light_effect, true)
    end
  end
end

FPCameraPlayerBase.start_shooting = function(l_7_0)
  l_7_0._recoil_kick.accumulated = l_7_0._recoil_kick.to_reduce or 0
  l_7_0._recoil_kick.to_reduce = nil
  l_7_0._recoil_kick.current = (l_7_0._recoil_kick.current and l_7_0._recoil_kick.current) or l_7_0._recoil_kick.accumulated or 0
  l_7_0._recoil_kick.h.accumulated = l_7_0._recoil_kick.h.to_reduce or 0
  l_7_0._recoil_kick.h.to_reduce = nil
  l_7_0._recoil_kick.h.current = (l_7_0._recoil_kick.h.current and l_7_0._recoil_kick.h.current) or l_7_0._recoil_kick.h.accumulated or 0
end

FPCameraPlayerBase.stop_shooting = function(l_8_0, l_8_1)
  l_8_0._recoil_kick.to_reduce = l_8_0._recoil_kick.accumulated
  l_8_0._recoil_kick.h.to_reduce = l_8_0._recoil_kick.h.accumulated
  l_8_0._recoil_wait = l_8_1 or 0
end

FPCameraPlayerBase.break_recoil = function(l_9_0)
  l_9_0._recoil_kick.current = 0
  l_9_0._recoil_kick.h.current = 0
  l_9_0._recoil_kick.accumulated = 0
  l_9_0._recoil_kick.h.accumulated = 0
  l_9_0:stop_shooting()
end

FPCameraPlayerBase.recoil_kick = function(l_10_0, l_10_1, l_10_2, l_10_3, l_10_4)
  if math.abs(l_10_0._recoil_kick.accumulated) < 20 then
    local v = nil
    v = math.lerp(l_10_1, l_10_2, math.random())
    l_10_0._recoil_kick.accumulated = (l_10_0._recoil_kick.accumulated or 0) + v
  end
  local h = nil
  h = math.lerp(l_10_3, l_10_4, math.random())
  l_10_0._recoil_kick.h.accumulated = (l_10_0._recoil_kick.h.accumulated or 0) + h
end

local bezier_values = {0, 0, 1, 1}
FPCameraPlayerBase._update_stance = function(l_11_0, l_11_1, l_11_2)
  if l_11_0._shoulder_stance.transition then
    local trans_data = l_11_0._shoulder_stance.transition
    local elapsed_t = l_11_1 - trans_data.start_t
    if trans_data.duration < elapsed_t then
      mvector3.set(l_11_0._shoulder_stance.translation, trans_data.end_translation)
      l_11_0._shoulder_stance.rotation = trans_data.end_rotation
      l_11_0._shoulder_stance.transition = nil
    else
      local progress = elapsed_t / trans_data.duration
      local progress_smooth = math.bezier(bezier_values, progress)
      mvector3.lerp(l_11_0._shoulder_stance.translation, trans_data.start_translation, trans_data.end_translation, progress_smooth)
      l_11_0._shoulder_stance.rotation = trans_data.start_rotation:slerp(trans_data.end_rotation, progress_smooth)
    end
  end
  if l_11_0._head_stance.transition then
    local trans_data = l_11_0._head_stance.transition
    local elapsed_t = l_11_1 - trans_data.start_t
    if trans_data.duration < elapsed_t then
      mvector3.set(l_11_0._head_stance.translation, trans_data.end_translation)
      l_11_0._head_stance.transition = nil
    else
      local progress = elapsed_t / trans_data.duration
      local progress_smooth = math.bezier(bezier_values, progress)
      mvector3.lerp(l_11_0._head_stance.translation, trans_data.start_translation, trans_data.end_translation, progress_smooth)
    end
  end
  if l_11_0._vel_overshot.transition then
    local trans_data = l_11_0._vel_overshot.transition
    local elapsed_t = l_11_1 - trans_data.start_t
    if trans_data.duration < elapsed_t then
      l_11_0._vel_overshot.yaw_neg = trans_data.end_yaw_neg
      l_11_0._vel_overshot.yaw_pos = trans_data.end_yaw_pos
      l_11_0._vel_overshot.pitch_neg = trans_data.end_pitch_neg
      l_11_0._vel_overshot.pitch_pos = trans_data.end_pitch_pos
      mvector3.set(l_11_0._vel_overshot.pivot, trans_data.end_pivot)
      l_11_0._vel_overshot.transition = nil
    else
      local progress = elapsed_t / trans_data.duration
      local progress_smooth = math.bezier(bezier_values, progress)
      l_11_0._vel_overshot.yaw_neg = math.lerp(trans_data.start_yaw_neg, trans_data.end_yaw_neg, progress_smooth)
      l_11_0._vel_overshot.yaw_pos = math.lerp(trans_data.start_yaw_pos, trans_data.end_yaw_pos, progress_smooth)
      l_11_0._vel_overshot.pitch_neg = math.lerp(trans_data.start_pitch_neg, trans_data.end_pitch_neg, progress_smooth)
      l_11_0._vel_overshot.pitch_pos = math.lerp(trans_data.start_pitch_pos, trans_data.end_pitch_pos, progress_smooth)
      mvector3.lerp(l_11_0._vel_overshot.pivot, trans_data.start_pivot, trans_data.end_pivot, progress_smooth)
    end
  end
  l_11_0:_calculate_soft_velocity_overshot(l_11_2)
  if l_11_0._fov.transition then
    local trans_data = l_11_0._fov.transition
    local elapsed_t = l_11_1 - trans_data.start_t
    if trans_data.duration < elapsed_t then
      l_11_0._fov.fov = trans_data.end_fov
      l_11_0._fov.transition = nil
    else
      local progress = elapsed_t / trans_data.duration
      local progress_smooth = math.max(math.min(math.bezier(bezier_values, progress), 1), 0)
      l_11_0._fov.fov = math.lerp(trans_data.start_fov, trans_data.end_fov, progress_smooth)
    end
    l_11_0._fov.dirty = true
  end
end

local mrot1 = Rotation()
local mrot2 = Rotation()
local mrot3 = Rotation()
local mvec1 = Vector3()
local mvec2 = Vector3()
local mvec3 = Vector3()
FPCameraPlayerBase._update_movement = function(l_12_0, l_12_1, l_12_2)
  local data = l_12_0._camera_properties
  local new_head_pos = mvec2
  local new_shoulder_pos = mvec1
  local new_shoulder_rot = mrot1
  local new_head_rot = mrot2
  l_12_0._parent_unit:m_position(new_head_pos)
  mvector3.add(new_head_pos, l_12_0._head_stance.translation)
  local stick_input_x, stick_input_y = 0, 0
  local aim_assist_x, aim_assist_y = l_12_0:_get_aim_assist(l_12_1, l_12_2)
  stick_input_x = stick_input_x + l_12_0:_horizonatal_recoil_kick(l_12_1, l_12_2) + aim_assist_x
  stick_input_y = stick_input_y + l_12_0:_vertical_recoil_kick(l_12_1, l_12_2) + aim_assist_y
  local look_polar_spin = data.spin - (stick_input_x)
  local look_polar_pitch = math.clamp(data.pitch + (stick_input_y), -85, 85)
  if not l_12_0._limits or not l_12_0._limits.spin then
    look_polar_spin = look_polar_spin % 360
  end
  local look_polar = Polar(1, look_polar_pitch, look_polar_spin)
  local look_vec = look_polar:to_vector()
  local cam_offset_rot = mrot3
  mrotation.set_look_at(cam_offset_rot, look_vec, math.UP)
  mrotation.set_zero(new_head_rot)
  mrotation.multiply(new_head_rot, l_12_0._head_stance.rotation)
  mrotation.multiply(new_head_rot, cam_offset_rot)
  data.pitch = look_polar_pitch
  data.spin = look_polar_spin
  l_12_0._output_data.position = new_head_pos
  if not new_head_rot then
    l_12_0._output_data.rotation = l_12_0._output_data.rotation
  end
  if l_12_0._camera_properties.current_tilt ~= l_12_0._camera_properties.target_tilt then
    l_12_0._camera_properties.current_tilt = math.step(l_12_0._camera_properties.current_tilt, l_12_0._camera_properties.target_tilt, 150 * l_12_2)
  end
  if l_12_0._camera_properties.current_tilt ~= 0 then
    l_12_0._output_data.rotation = Rotation(l_12_0._output_data.rotation:yaw(), l_12_0._output_data.rotation:pitch(), l_12_0._output_data.rotation:roll() + l_12_0._camera_properties.current_tilt)
  end
  mvector3.set(new_shoulder_pos, l_12_0._shoulder_stance.translation)
  mvector3.add(new_shoulder_pos, l_12_0._vel_overshot.translation)
  mvector3.rotate_with(new_shoulder_pos, l_12_0._output_data.rotation)
  mvector3.add(new_shoulder_pos, new_head_pos)
  mrotation.set_zero(new_shoulder_rot)
  mrotation.multiply(new_shoulder_rot, l_12_0._output_data.rotation)
  mrotation.multiply(new_shoulder_rot, l_12_0._shoulder_stance.rotation)
  mrotation.multiply(new_shoulder_rot, l_12_0._vel_overshot.rotation)
  l_12_0:set_position(new_shoulder_pos)
  l_12_0:set_rotation(new_shoulder_rot)
end

FPCameraPlayerBase._update_rot = function(l_13_0, l_13_1)
  local t = managers.player:player_timer():time()
  local dt = t - (l_13_0._last_rot_t or t)
  l_13_0._last_rot_t = t
  local data = l_13_0._camera_properties
  local new_head_pos = mvec2
  local new_shoulder_pos = mvec1
  local new_shoulder_rot = mrot1
  local new_head_rot = mrot2
  l_13_0._parent_unit:m_position(new_head_pos)
  mvector3.add(new_head_pos, l_13_0._head_stance.translation)
  l_13_0._input.look = l_13_1
  local stick_input_x, stick_input_y = l_13_0._look_function(l_13_0._input.look, dt)
  local look_polar_spin = data.spin - stick_input_x
  local look_polar_pitch = math.clamp(data.pitch + stick_input_y, -85, 85)
  if l_13_0._limits then
    if l_13_0._limits.spin then
      local d = (look_polar_spin - l_13_0._limits.spin.mid) / l_13_0._limits.spin.offset
      look_polar_spin = data.spin - math.lerp(stick_input_x, 0, math.abs(d))
    end
    if l_13_0._limits.pitch then
      local d = math.abs((look_polar_pitch - l_13_0._limits.pitch.mid) / l_13_0._limits.pitch.offset)
      look_polar_pitch = data.pitch + math.lerp(stick_input_y, 0, math.abs(d))
      look_polar_pitch = math.clamp(look_polar_pitch, -85, 85)
    end
  end
  if not l_13_0._limits or not l_13_0._limits.spin then
    look_polar_spin = (look_polar_spin) % 360
  end
  local look_polar = Polar(1, look_polar_pitch, look_polar_spin)
  local look_vec = look_polar:to_vector()
  local cam_offset_rot = mrot3
  mrotation.set_look_at(cam_offset_rot, look_vec, math.UP)
  mrotation.set_zero(new_head_rot)
  mrotation.multiply(new_head_rot, l_13_0._head_stance.rotation)
  mrotation.multiply(new_head_rot, cam_offset_rot)
  data.pitch = look_polar_pitch
  data.spin = look_polar_spin
  l_13_0._output_data.position = new_head_pos
  if not new_head_rot then
    l_13_0._output_data.rotation = l_13_0._output_data.rotation
  end
  if l_13_0._camera_properties.current_tilt ~= l_13_0._camera_properties.target_tilt then
    l_13_0._camera_properties.current_tilt = math.step(l_13_0._camera_properties.current_tilt, l_13_0._camera_properties.target_tilt, 150 * dt)
  end
  if l_13_0._camera_properties.current_tilt ~= 0 then
    l_13_0._output_data.rotation = Rotation(l_13_0._output_data.rotation:yaw(), l_13_0._output_data.rotation:pitch(), l_13_0._output_data.rotation:roll() + l_13_0._camera_properties.current_tilt)
  end
  mvector3.set(new_shoulder_pos, l_13_0._shoulder_stance.translation)
  mvector3.add(new_shoulder_pos, l_13_0._vel_overshot.translation)
  mvector3.rotate_with(new_shoulder_pos, l_13_0._output_data.rotation)
  mvector3.add(new_shoulder_pos, new_head_pos)
  mrotation.set_zero(new_shoulder_rot)
  mrotation.multiply(new_shoulder_rot, l_13_0._output_data.rotation)
  mrotation.multiply(new_shoulder_rot, l_13_0._shoulder_stance.rotation)
  mrotation.multiply(new_shoulder_rot, l_13_0._vel_overshot.rotation)
  l_13_0:set_position(new_shoulder_pos)
  l_13_0:set_rotation(new_shoulder_rot)
  l_13_0._parent_unit:camera():set_position(l_13_0._output_data.position)
  l_13_0._parent_unit:camera():set_rotation(l_13_0._output_data.rotation)
end

FPCameraPlayerBase._get_aim_assist = function(l_14_0, l_14_1, l_14_2)
  if l_14_0._aim_assist.distance == 0 then
    return 0, 0
  end
  local s_value = math.step(0, l_14_0._aim_assist.distance, l_14_0._tweak_data.aim_assist_speed * l_14_2)
  local r_value_x = mvector3.x(l_14_0._aim_assist.direction) * s_value
  local r_value_y = mvector3.y(l_14_0._aim_assist.direction) * s_value
  l_14_0._aim_assist.distance = l_14_0._aim_assist.distance - s_value
  if l_14_0._aim_assist.distance <= 0 then
    l_14_0:clbk_stop_aim_assist()
  end
  return r_value_x, r_value_y
end

FPCameraPlayerBase._vertical_recoil_kick = function(l_15_0, l_15_1, l_15_2)
  local r_value = 0
  if l_15_0._recoil_kick.current and l_15_0._recoil_kick.current ~= l_15_0._recoil_kick.accumulated then
    local n = math.step(l_15_0._recoil_kick.current, l_15_0._recoil_kick.accumulated, 40 * l_15_2)
    r_value = n - l_15_0._recoil_kick.current
    l_15_0._recoil_kick.current = n
  elseif l_15_0._recoil_wait then
    do return end
  end
  if l_15_0._recoil_kick.to_reduce then
    l_15_0._recoil_kick.current = nil
    local n = math.lerp(l_15_0._recoil_kick.to_reduce, 0, 9 * l_15_2)
    r_value = -(l_15_0._recoil_kick.to_reduce - n)
    l_15_0._recoil_kick.to_reduce = n
    if l_15_0._recoil_kick.to_reduce == 0 then
      l_15_0._recoil_kick.to_reduce = nil
    end
  end
  return r_value
end

FPCameraPlayerBase._horizonatal_recoil_kick = function(l_16_0, l_16_1, l_16_2)
  local r_value = 0
  if l_16_0._recoil_kick.h.current and l_16_0._recoil_kick.h.current ~= l_16_0._recoil_kick.h.accumulated then
    local n = math.step(l_16_0._recoil_kick.h.current, l_16_0._recoil_kick.h.accumulated, 40 * l_16_2)
    r_value = n - l_16_0._recoil_kick.h.current
    l_16_0._recoil_kick.h.current = n
  elseif l_16_0._recoil_wait then
    l_16_0._recoil_wait = l_16_0._recoil_wait - l_16_2
    if l_16_0._recoil_wait < 0 then
      l_16_0._recoil_wait = nil
    else
      if l_16_0._recoil_kick.h.to_reduce then
        l_16_0._recoil_kick.h.current = nil
        local n = math.lerp(l_16_0._recoil_kick.h.to_reduce, 0, 5 * l_16_2)
        r_value = -(l_16_0._recoil_kick.h.to_reduce - n)
        l_16_0._recoil_kick.h.to_reduce = n
        if l_16_0._recoil_kick.h.to_reduce == 0 then
          l_16_0._recoil_kick.h.to_reduce = nil
        end
      end
    end
  end
  return r_value
end

FPCameraPlayerBase._pc_look_function = function(l_17_0, l_17_1, l_17_2)
  return l_17_1.x, l_17_1.y
end

FPCameraPlayerBase._gamepad_look_function = function(l_18_0, l_18_1, l_18_2)
  if l_18_0._tweak_data.look_speed_dead_zone < mvector3.length(l_18_1) then
    local x = l_18_1.x
    local y = l_18_1.y
    l_18_1 = Vector3(x / (1.2999999523163 - 0.30000001192093 * (1 - math.abs(y))), y / (1.2999999523163 - 0.30000001192093 * (1 - math.abs(x))), 0)
    local look_speed = l_18_0:_get_look_speed(l_18_1, l_18_2)
    local stick_input_x = l_18_1.x * l_18_2 * look_speed
    local stick_input_y = l_18_1.y * l_18_2 * look_speed
    return stick_input_x, stick_input_y
  end
  return 0, 0
end

FPCameraPlayerBase._get_look_speed = function(l_19_0, l_19_1, l_19_2)
  if l_19_0._parent_unit:movement()._current_state:in_steelsight() then
    return l_19_0._tweak_data.look_speed_steel_sight
  end
  if l_19_0._tweak_data.look_speed_transition_occluder >= mvector3.length(l_19_1) or l_19_0._tweak_data.look_speed_transition_zone >= math.abs(l_19_1.x) then
    l_19_0._camera_properties.look_speed_transition_timer = 0
    return l_19_0._tweak_data.look_speed_standard
  end
  if l_19_0._camera_properties.look_speed_transition_timer >= 1 then
    return l_19_0._tweak_data.look_speed_fast
  end
  local p1 = l_19_0._tweak_data.look_speed_standard
  local p2 = l_19_0._tweak_data.look_speed_standard
  local p3 = l_19_0._tweak_data.look_speed_standard + (l_19_0._tweak_data.look_speed_fast - l_19_0._tweak_data.look_speed_standard) / 3 * 2
  local p4 = l_19_0._tweak_data.look_speed_fast
  l_19_0._camera_properties.look_speed_transition_timer = l_19_0._camera_properties.look_speed_transition_timer + l_19_2 / l_19_0._tweak_data.look_speed_transition_to_fast
  return math.bezier({p1, p2, p3, p4}, l_19_0._camera_properties.look_speed_transition_timer)
end

FPCameraPlayerBase._calculate_soft_velocity_overshot = function(l_20_0, l_20_1)
  local stick_input = l_20_0._input.look
  local vel_overshot = l_20_0._vel_overshot
  if not stick_input then
    return 
  end
  local input_yaw, input_pitch, input_x, input_z = nil, nil, nil, nil
  if stick_input.x >= 0 then
    local stick_input_x = math.pow(math.abs(math.clamp(0.0020000000949949 * stick_input.x / l_20_1, 0, 1)), 1.5) * math.sign(stick_input.x) * l_20_0._tweak_data.overshot_multiplier_yaw
    input_yaw = stick_input_x * vel_overshot.yaw_pos
  else
    local stick_input_x = math.pow(math.abs(math.clamp(0.0020000000949949 * stick_input.x / l_20_1, -1, 0)), 1.5) * l_20_0._tweak_data.overshot_multiplier_yaw
    input_yaw = stick_input_x * vel_overshot.yaw_neg
  end
  local last_yaw = vel_overshot.last_yaw
  local sign_in_yaw = math.sign(input_yaw)
  local abs_in_yaw = math.abs(input_yaw)
  local sign_last_yaw = math.sign(last_yaw)
  local abs_last_yaw = math.abs(last_yaw)
  vel_overshot.target_yaw = math.step(vel_overshot.target_yaw, input_yaw, 120 * l_20_1)
  local final_yaw = nil
  local diff = math.abs(vel_overshot.target_yaw - last_yaw)
  local diff_clamp = 40
  local diff_ratio = math.pow(diff / diff_clamp, 1)
  local diff_ratio_clamped = math.clamp(diff_ratio, 0, 1)
  local step_amount = math.lerp(3, 180, diff_ratio_clamped) * l_20_1
  final_yaw = math.step(last_yaw, vel_overshot.target_yaw, step_amount)
  vel_overshot.last_yaw = final_yaw
  if stick_input.y >= 0 then
    local stick_input_y = math.pow(math.abs(math.clamp(0.0020000000949949 * stick_input.y / l_20_1, 0, 1)), 1.5) * math.sign(stick_input.y) * l_20_0._tweak_data.overshot_multiplier_pitch
    input_pitch = stick_input_y * vel_overshot.pitch_pos
  else
    local stick_input_y = math.pow(math.abs(math.clamp(0.0020000000949949 * stick_input.y / l_20_1, -1, 0)), 1.5) * l_20_0._tweak_data.overshot_multiplier_pitch
    input_pitch = stick_input_y * vel_overshot.pitch_neg
  end
  local last_pitch = vel_overshot.last_pitch
  local sign_in_pitch = math.sign(input_pitch)
  local abs_in_pitch = math.abs(input_pitch)
  local sign_last_pitch = math.sign(last_pitch)
  local abs_last_pitch = math.abs(last_pitch)
  vel_overshot.target_pitch = math.step(vel_overshot.target_pitch, input_pitch, 120 * l_20_1)
  local final_pitch = nil
  local diff = math.abs(vel_overshot.target_pitch - last_pitch)
  local diff_clamp = 40
  local diff_ratio = math.pow(diff / diff_clamp, 1)
  local diff_ratio_clamped = math.clamp(diff_ratio, 0, 1)
  local step_amount = math.lerp(3, 180, diff_ratio_clamped) * l_20_1
  final_pitch = math.step(last_pitch, vel_overshot.target_pitch, step_amount)
  vel_overshot.last_pitch = final_pitch
  mrotation.set_yaw_pitch_roll(vel_overshot.rotation, final_yaw, final_pitch, -final_yaw)
  local pivot = vel_overshot.pivot
  local new_root = mvec3
  mvector3.set(new_root, pivot)
  mvector3.negate(new_root)
  mvector3.rotate_with(new_root, vel_overshot.rotation)
  mvector3.add(new_root, pivot)
  mvector3.set(vel_overshot.translation, new_root)
end

FPCameraPlayerBase.set_position = function(l_21_0, l_21_1)
  l_21_0._unit:set_position(l_21_1)
end

FPCameraPlayerBase.set_rotation = function(l_22_0, l_22_1)
  l_22_0._unit:set_rotation(l_22_1)
end

FPCameraPlayerBase.eye_position = function(l_23_0)
  return l_23_0._obj_eye:position()
end

FPCameraPlayerBase.eye_rotation = function(l_24_0)
  return l_24_0._obj_eye:rotation()
end

FPCameraPlayerBase.play_redirect = function(l_25_0, l_25_1, l_25_2)
  l_25_0:set_anims_enabled(true)
  local result = l_25_0._unit:play_redirect(l_25_1)
  if result == l_25_0.IDS_NOSTRING then
    return false
  end
  if l_25_2 then
    l_25_0._unit:anim_state_machine():set_speed(result, l_25_2)
  end
  return result
end

FPCameraPlayerBase.play_state = function(l_26_0, l_26_1)
  l_26_0:set_anims_enabled(true)
  local result = l_26_0._unit:play_state(Idstring(l_26_1))
  return (result ~= l_26_0.IDS_NOSTRING and result)
end

FPCameraPlayerBase.set_target_tilt = function(l_27_0, l_27_1)
  l_27_0._camera_properties.target_tilt = l_27_1
end

FPCameraPlayerBase.set_stance_instant = function(l_28_0, l_28_1)
  local new_stance = tweak_data.player.stances.default[l_28_1].shoulders
  if new_stance then
    l_28_0._shoulder_stance.transition = nil
    l_28_0._shoulder_stance.translation = mvector3.copy(new_stance.translation)
    l_28_0._shoulder_stance.rotation = new_stance.rotation
  end
  local new_stance = tweak_data.player.stances.default[l_28_1].head
  if new_stance then
    l_28_0._head_stance.transition = nil
    l_28_0._head_stance.translation = mvector3.copy(new_stance.translation)
    l_28_0._head_stance.rotation = new_stance.rotation
  end
  local new_overshot = tweak_data.player.stances.default[l_28_1].vel_overshot
  if new_overshot then
    l_28_0._vel_overshot.transition = nil
    l_28_0._vel_overshot.yaw_neg = new_overshot.yaw_neg
    l_28_0._vel_overshot.yaw_pos = new_overshot.yaw_pos
    l_28_0._vel_overshot.pitch_neg = new_overshot.pitch_neg
    l_28_0._vel_overshot.pitch_pos = new_overshot.pitch_pos
    l_28_0._vel_overshot.pivot = mvector3.copy(new_overshot.pivot)
  end
  l_28_0:set_stance_fov_instant(l_28_1)
end

FPCameraPlayerBase.set_fov_instant = function(l_29_0, l_29_1)
  if l_29_1 then
    l_29_0._fov.transition = nil
    l_29_0._fov.fov = l_29_1
    l_29_0._fov.dirty = true
    if Application:paused() then
      l_29_0._parent_unit:camera():set_FOV(l_29_0._fov.fov)
    end
  end
end

FPCameraPlayerBase.set_stance_fov_instant = function(l_30_0, l_30_1)
  if not tweak_data.player.stances.default[l_30_1].zoom_fov or not managers.user:get_setting("fov_zoom") then
    local new_fov = managers.user:get_setting("fov_standard")
  end
  if new_fov then
    l_30_0._fov.transition = nil
    l_30_0._fov.fov = new_fov
    l_30_0._fov.dirty = true
    if Application:paused() then
      l_30_0._parent_unit:camera():set_FOV(l_30_0._fov.fov)
    end
  end
end

FPCameraPlayerBase.clbk_stance_entered = function(l_31_0, l_31_1, l_31_2, l_31_3, l_31_4, l_31_5, l_31_6, l_31_7, l_31_8)
  local t = managers.player:player_timer():time()
  if l_31_1 then
    local transition = {}
    l_31_0._shoulder_stance.transition = transition
    transition.end_translation = l_31_1.translation + l_31_6.translation
    transition.end_rotation = l_31_1.rotation
    transition.start_translation = mvector3.copy(l_31_0._shoulder_stance.translation)
    transition.start_rotation = l_31_0._shoulder_stance.rotation
    transition.start_t = t
    transition.duration = l_31_8 * l_31_7
  end
  if l_31_2 then
    local transition = {}
    l_31_0._head_stance.transition = transition
    transition.end_translation = l_31_2.translation
    transition.end_rotation = l_31_2.rotation
    transition.start_translation = mvector3.copy(l_31_0._head_stance.translation)
    transition.start_rotation = l_31_0._head_stance.rotation
    transition.start_t = t
    transition.duration = l_31_8 * l_31_7
  end
  if l_31_3 then
    local transition = {}
    l_31_0._vel_overshot.transition = transition
    transition.end_pivot = l_31_3.pivot
    transition.end_yaw_neg = l_31_3.yaw_neg
    transition.end_yaw_pos = l_31_3.yaw_pos
    transition.end_pitch_neg = l_31_3.pitch_neg
    transition.end_pitch_pos = l_31_3.pitch_pos
    transition.start_pivot = mvector3.copy(l_31_0._vel_overshot.pivot)
    transition.start_yaw_neg = l_31_0._vel_overshot.yaw_neg
    transition.start_yaw_pos = l_31_0._vel_overshot.yaw_pos
    transition.start_pitch_neg = l_31_0._vel_overshot.pitch_neg
    transition.start_pitch_pos = l_31_0._vel_overshot.pitch_pos
    transition.start_t = t
    transition.duration = l_31_8 * l_31_7
  end
  if l_31_4 then
    if l_31_4 == l_31_0._fov.fov then
      l_31_0._fov.transition = nil
    else
      local transition = {}
      l_31_0._fov.transition = transition
      transition.end_fov = l_31_4
      transition.start_fov = l_31_0._fov.fov
      transition.start_t = t
      transition.duration = l_31_8 * l_31_7
    end
  end
  if l_31_5 then
    for effect,values in pairs(l_31_5) do
      for parameter,value in pairs(values) do
        l_31_0._parent_unit:camera():set_shaker_parameter(effect, parameter, value)
      end
    end
  end
end

FPCameraPlayerBase.clbk_aim_assist = function(l_32_0, l_32_1)
  if l_32_1 then
    local ray = l_32_1.ray
    local r1 = l_32_0._parent_unit:camera():rotation()
    if not l_32_0._aim_assist.mrotation then
      local r2 = Rotation()
    end
    mrotation.set_look_at(r2, ray, math.UP)
    local yaw = mrotation.yaw(r1) - mrotation.yaw(r2)
    local pitch = mrotation.pitch(r1) - mrotation.pitch(r2)
    if yaw > 180 then
      yaw = 360 - yaw
    elseif yaw < -180 then
      yaw = 360 + (yaw)
    end
    if pitch > 180 then
      pitch = 360 - pitch
    elseif pitch < -180 then
      pitch = 360 + (pitch)
    end
    mvector3.set_static(l_32_0._aim_assist.direction, yaw, -(pitch), 0)
    l_32_0._aim_assist.distance = mvector3.normalize(l_32_0._aim_assist.direction)
  end
end

FPCameraPlayerBase.clbk_stop_aim_assist = function(l_33_0)
  mvector3.set_static(l_33_0._aim_assist.direction, 0, 0, 0)
  l_33_0._aim_assist.distance = 0
end

FPCameraPlayerBase.animate_fov = function(l_34_0, l_34_1, l_34_2)
  if l_34_1 == l_34_0._fov.fov then
    l_34_0._fov.transition = nil
  else
    local transition = {}
    l_34_0._fov.transition = transition
    transition.end_fov = l_34_1
    transition.start_fov = l_34_0._fov.fov
    transition.start_t = managers.player:player_timer():time()
    transition.duration = 0.23000000417233 * (l_34_2 or 1)
  end
end

FPCameraPlayerBase.anim_clbk_idle_full_blend = function(l_35_0)
  l_35_0:play_redirect(l_35_0.IDS_EMPTY)
end

FPCameraPlayerBase.anim_clbk_idle_exit = function(l_36_0)
end

FPCameraPlayerBase.anim_clbk_empty_full_blend = function(l_37_0)
  l_37_0:set_anims_enabled(false)
end

FPCameraPlayerBase.set_handcuff_units = function(l_38_0, l_38_1)
  l_38_0._handcuff_units = l_38_1
end

FPCameraPlayerBase.anim_clbk_spawn_handcuffs = function(l_39_0)
  if not l_39_0._handcuff_units then
    local align_obj_l_name = Idstring("a_weapon_left")
    local align_obj_r_name = Idstring("a_weapon_right")
    local align_obj_l = l_39_0._unit:get_object(align_obj_l_name)
    local align_obj_r = l_39_0._unit:get_object(align_obj_r_name)
    local handcuff_unit_name = Idstring("units/equipment/handcuffs_first_person/handcuffs_first_person")
    local handcuff_unit_l = World:spawn_unit(handcuff_unit_name, align_obj_l:position(), align_obj_l:rotation())
    local handcuff_unit_r = World:spawn_unit(handcuff_unit_name, align_obj_r:position(), align_obj_r:rotation())
    l_39_0._unit:link(align_obj_l_name, handcuff_unit_l, handcuff_unit_l:orientation_object():name())
    l_39_0._unit:link(align_obj_r_name, handcuff_unit_r, handcuff_unit_r:orientation_object():name())
    local handcuff_units = {handcuff_unit_l, handcuff_unit_r}
    l_39_0:set_handcuff_units(handcuff_units)
  end
end

FPCameraPlayerBase.anim_clbk_unspawn_handcuffs = function(l_40_0)
  if l_40_0._handcuff_units then
    for _,handcuff_unit in ipairs(l_40_0._handcuff_units) do
      if alive(handcuff_unit) then
        handcuff_unit:set_slot(0)
      end
    end
  end
  l_40_0:set_handcuff_units(nil)
end

FPCameraPlayerBase.get_weapon_offsets = function(l_41_0)
  local weapon = l_41_0._parent_unit:inventory():equipped_unit()
  local object = weapon:get_object(Idstring("a_sight"))
  print(object:position() - l_41_0._unit:position():rotate_HP(l_41_0._unit:rotation():inverse()))
  print(l_41_0._unit:rotation():inverse() * object:rotation())
end

FPCameraPlayerBase.set_anims_enabled = function(l_42_0, l_42_1)
  if l_42_1 ~= l_42_0._anims_enabled then
    l_42_0._unit:set_animations_enabled(l_42_1)
    l_42_0._anims_enabled = l_42_1
  end
end

FPCameraPlayerBase.play_sound = function(l_43_0, l_43_1, l_43_2)
  if alive(l_43_0._parent_unit) then
    l_43_0._parent_unit:sound():play(l_43_2)
  end
end

FPCameraPlayerBase.set_limits = function(l_44_0, l_44_1, l_44_2)
  l_44_0._limits = {}
  if l_44_1 then
    l_44_0._limits.spin = {mid = l_44_0._camera_properties.spin, offset = l_44_1}
  end
  if l_44_2 then
    l_44_0._limits.pitch = {mid = l_44_0._camera_properties.pitch, offset = l_44_2}
  end
end

FPCameraPlayerBase.remove_limits = function(l_45_0)
  l_45_0._limits = nil
end

FPCameraPlayerBase.throw_flash_grenade = function(l_46_0, l_46_1)
  if alive(l_46_0._parent_unit) then
    l_46_0._parent_unit:equipment():throw_flash_grenade()
  end
end

FPCameraPlayerBase.hide_weapon = function(l_47_0)
  if alive(l_47_0._parent_unit) then
    l_47_0._parent_unit:inventory():hide_equipped_unit()
  end
end

FPCameraPlayerBase.show_weapon = function(l_48_0)
  if alive(l_48_0._parent_unit) then
    l_48_0._parent_unit:inventory():show_equipped_unit()
  end
end

FPCameraPlayerBase.enter_shotgun_reload_loop = function(l_49_0, l_49_1, l_49_2, ...)
   -- DECOMPILER ERROR: Confused at declaration of local variable

  if alive(l_49_0._parent_unit) then
    l_49_0._unit:anim_state_machine():set_speed(Idstring(l_49_2), l_49_0._parent_unit:inventory():equipped_unit():base():reload_speed_multiplier())
     -- DECOMPILER ERROR: Confused about usage of registers for local variables.

  end
end

FPCameraPlayerBase.spawn_mask = function(l_50_0)
  if not l_50_0._mask_unit then
    local align_obj_l_name = Idstring("a_weapon_left")
    local align_obj_r_name = Idstring("a_weapon_right")
    local align_obj_l = l_50_0._unit:get_object(align_obj_l_name)
    local align_obj_r = l_50_0._unit:get_object(align_obj_r_name)
    local mask_unit_name = "units/payday2/masks/fps_temp_dallas/temp_mask_dallas"
    local equipped_mask = managers.blackmarket:equipped_mask()
    local peer_id = (managers.network:session():local_peer():id())
    local blueprint = nil
    if equipped_mask.mask_id then
      mask_unit_name = managers.blackmarket:mask_unit_name_by_mask_id(equipped_mask.mask_id, peer_id)
      blueprint = equipped_mask.blueprint
    else
      mask_unit_name = tweak_data.blackmarket.masks[equipped_mask].unit
    end
    managers.dyn_resource:load(Idstring("unit"), Idstring(mask_unit_name), DynamicResourceManager.DYN_RESOURCES_PACKAGE, false)
    l_50_0._mask_unit = World:spawn_unit(Idstring(mask_unit_name), align_obj_r:position(), align_obj_r:rotation())
    for _,material in ipairs(l_50_0._mask_unit:get_objects_by_type(Idstring("material"))) do
      material:set_render_template(Idstring("solid_mask:DEPTH_SCALING"))
    end
    if blueprint then
      print("FPCameraPlayerBase:spawn_mask", inspect(blueprint))
      l_50_0._mask_unit:base():apply_blueprint(blueprint)
    end
    print(inspect(l_50_0._mask_unit:get_objects_by_type(Idstring("material"))))
    l_50_0._mask_unit:set_timer(managers.player:player_timer())
    l_50_0._mask_unit:set_animation_timer(managers.player:player_timer())
    l_50_0._mask_unit:anim_stop()
    local backside = World:spawn_unit(Idstring("units/payday2/masks/msk_fps_back_straps/msk_fps_back_straps"), align_obj_r:position(), align_obj_r:rotation())
    for _,material in ipairs(backside:get_objects_by_type(Idstring("material"))) do
      material:set_render_template(Idstring("generic:DEPTH_SCALING:DIFFUSE_TEXTURE:NORMALMAP:SKINNED_3WEIGHTS"))
    end
    backside:set_timer(managers.player:player_timer())
    backside:set_animation_timer(managers.player:player_timer())
    backside:anim_play(Idstring("mask_on"))
    l_50_0._mask_unit:link(l_50_0._mask_unit:orientation_object():name(), backside, backside:orientation_object():name())
    l_50_0._unit:link(align_obj_l:name(), l_50_0._mask_unit, l_50_0._mask_unit:orientation_object():name())
  end
end

FPCameraPlayerBase.relink_mask = function(l_51_0)
  print("FPCameraPlayerBase:relink_mask()")
end

FPCameraPlayerBase.unspawn_mask = function(l_52_0)
  if alive(l_52_0._mask_unit) then
    for _,linked_unit in ipairs(l_52_0._mask_unit:children()) do
      linked_unit:unlink()
      World:delete_unit(linked_unit)
    end
    l_52_0._mask_unit:unlink()
    local name = l_52_0._mask_unit:name()
    World:delete_unit(l_52_0._mask_unit)
    managers.dyn_resource:unload(Idstring("unit"), name, DynamicResourceManager.DYN_RESOURCES_PACKAGE, false)
    l_52_0._mask_unit = nil
  end
end

FPCameraPlayerBase.counter_taser = function(l_53_0)
  local current_state = l_53_0._parent_movement_ext._current_state
  if current_state and current_state.give_shock_to_taser then
    current_state:give_shock_to_taser()
    if alive(l_53_0._taser_hooks_unit) then
      local align_obj = l_53_0._unit:get_object(Idstring("a_weapon_right"))
      World:effect_manager():spawn({effect = Idstring("effects/payday2/particles/character/taser_stop"), position = align_obj:position(), normal = align_obj:rotation():y()})
    end
  end
end

FPCameraPlayerBase.spawn_taser_hooks = function(l_54_0)
  if not alive(l_54_0._taser_hooks_unit) and alive(l_54_0._parent_unit) then
    local hooks_align = l_54_0._unit:get_object(Idstring("a_weapon_right"))
    local taser_hooks_unit_name = "units/payday2/weapons/wpn_fps_taser_hooks/wpn_fps_taser_hooks"
    managers.dyn_resource:load(Idstring("unit"), Idstring(taser_hooks_unit_name), DynamicResourceManager.DYN_RESOURCES_PACKAGE, false)
    l_54_0._taser_hooks_unit = World:spawn_unit(Idstring(taser_hooks_unit_name), hooks_align:position(), hooks_align:rotation())
    l_54_0._taser_hooks_unit:set_timer(managers.player:player_timer())
    l_54_0._taser_hooks_unit:set_animation_timer(managers.player:player_timer())
    l_54_0._taser_hooks_unit:anim_play(Idstring("taser_hooks"))
    l_54_0._unit:link(hooks_align:name(), l_54_0._taser_hooks_unit, l_54_0._taser_hooks_unit:orientation_object():name())
  end
end

FPCameraPlayerBase.unspawn_taser_hooks = function(l_55_0)
  if alive(l_55_0._taser_hooks_unit) then
    l_55_0._taser_hooks_unit:unlink()
    local name = l_55_0._taser_hooks_unit:name()
    World:delete_unit(l_55_0._taser_hooks_unit)
    managers.dyn_resource:unload(Idstring("unit"), name, DynamicResourceManager.DYN_RESOURCES_PACKAGE, false)
    l_55_0._taser_hooks_unit = nil
  end
end

FPCameraPlayerBase.end_tase = function(l_56_0)
  local current_state = l_56_0._parent_movement_ext._current_state
  if current_state and current_state.clbk_exit_to_std then
    current_state:clbk_exit_to_std()
  end
end

FPCameraPlayerBase.destroy = function(l_57_0)
  if l_57_0._parent_unit then
    l_57_0._parent_unit:base():remove_destroy_listener("FPCameraPlayerBase")
  end
  if l_57_0._light then
    World:delete_light(l_57_0._light)
  end
  if l_57_0._light_effect then
    World:effect_manager():kill(l_57_0._light_effect)
    l_57_0._light_effect = nil
  end
  l_57_0:anim_clbk_unspawn_handcuffs()
  l_57_0:unspawn_mask()
end


