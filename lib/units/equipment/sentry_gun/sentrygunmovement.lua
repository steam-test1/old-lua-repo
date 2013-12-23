-- Decompiled using luadec 2.0.1 by sztupy (http://winmo.sztupy.hu)
-- Command line was: F:\SteamLibrary\SteamApps\common\PAYDAY 2\lua\lib\units\equipment\sentry_gun\sentrygunmovement.luac 

local mvec3_dir = mvector3.direction
local tmp_rot1 = Rotation()
local tmp_vec1 = Vector3()
local tmp_vec2 = Vector3()
if not SentryGunMovement then
  SentryGunMovement = class()
end
SentryGunMovement.init = function(l_1_0, l_1_1)
  l_1_0._unit = l_1_1
  l_1_0._head_obj = l_1_0._unit:get_object(Idstring("a_detect"))
  l_1_0._spin_obj = l_1_0._unit:get_object(Idstring("a_shield"))
  l_1_0._pitch_obj = l_1_0._unit:get_object(Idstring("a_gun"))
  l_1_0._m_rot = l_1_1:rotation()
  l_1_0._m_head_fwd = l_1_0._m_rot:y()
  l_1_0._unit_up = l_1_0._m_rot:z()
  l_1_0._unit_fwd = l_1_0._m_rot:y()
  l_1_0._m_head_pos = l_1_0._head_obj:position()
  l_1_0._vel = {spin = 0, pitch = 0}
  if managers.navigation:is_data_ready() then
    l_1_0._nav_tracker = managers.navigation:create_nav_tracker(l_1_0._unit:position())
    l_1_0._pos_reservation = {position = l_1_0._unit:position(), radius = 30}
    managers.navigation:add_pos_reservation(l_1_0._pos_reservation)
  else
    Application:error("[SentryGunBase:setup] Spawned Sentry gun unit with incomplete navigation data.")
  end
  l_1_0._tweak = tweak_data.weapon.sentry_gun
  l_1_0._sound_source = l_1_0._unit:sound_source()
  l_1_0._last_attention_t = 0
  l_1_0._warmup_t = 0
  l_1_0._rot_speed_mul = 1
end

SentryGunMovement.post_init = function(l_2_0)
  l_2_0._ext_network = l_2_0._unit:network()
end

SentryGunMovement.update = function(l_3_0, l_3_1, l_3_2, l_3_3)
  if l_3_0._warmup_t < l_3_2 then
    l_3_0:_upd_movement(l_3_3)
  end
end

SentryGunMovement.setup = function(l_4_0, l_4_1)
  l_4_0._rot_speed_mul = l_4_1
end

SentryGunMovement.set_active = function(l_5_0, l_5_1)
  l_5_0._unit:set_extension_update_enabled(Idstring("movement"), l_5_1)
  if not l_5_1 and l_5_0._motor_sound then
    l_5_0._motor_sound:stop()
    l_5_0._motor_sound = false
  end
end

SentryGunMovement.nav_tracker = function(l_6_0)
  return l_6_0._nav_tracker
end

SentryGunMovement.set_attention = function(l_7_0, l_7_1)
  if l_7_0._attention and l_7_0._attention.destroy_listener_key then
    l_7_0._attention.unit:base():remove_destroy_listener(l_7_0._attention.destroy_listener_key)
  end
  if l_7_1 then
    if l_7_1.unit then
      local listener_key = "SentryGunMovement" .. tostring(l_7_0._unit:key())
      l_7_1.destroy_listener_key = listener_key
      l_7_1.unit:base():add_destroy_listener(listener_key, callback(l_7_0, l_7_0, "attention_unit_destroy_clbk"))
      if l_7_0._ext_network then
        l_7_0._ext_network:send("cop_set_attention_unit", l_7_1.unit)
      elseif l_7_0._ext_network then
        l_7_0._ext_network:send("cop_set_attention_pos", l_7_1.pos)
      elseif l_7_0._attention and Network:is_server() and l_7_0._unit:id() ~= -1 then
        l_7_0._ext_network:send("cop_reset_attention")
      end
    end
  end
  l_7_0:chk_play_alert(l_7_1, l_7_0._attention)
  l_7_0._attention = l_7_1
end

SentryGunMovement.synch_attention = function(l_8_0, l_8_1)
  if l_8_0._attention and l_8_0._attention.destroy_listener_key then
    l_8_0._attention.unit:base():remove_destroy_listener(l_8_0._attention.destroy_listener_key)
  end
  if l_8_1 and l_8_1.unit then
    local listener_key = "SentryGunMovement" .. tostring(l_8_0._unit:key())
    l_8_1.destroy_listener_key = listener_key
    l_8_1.unit:base():add_destroy_listener(listener_key, callback(l_8_0, l_8_0, "attention_unit_destroy_clbk"))
  end
  l_8_0:chk_play_alert(l_8_1, l_8_0._attention)
  l_8_0._attention = l_8_1
end

SentryGunMovement.chk_play_alert = function(l_9_0, l_9_1, l_9_2)
  if not l_9_1 and l_9_2 then
    l_9_0._last_attention_t = TimerManager:game():time()
  end
  if l_9_1 and not l_9_2 and TimerManager:game():time() - l_9_0._last_attention_t > 3 then
    l_9_0._sound_source:post_event("turret_alert")
    l_9_0._warmup_t = TimerManager:game():time() + 0.5
  end
end

SentryGunMovement.attention = function(l_10_0)
  return l_10_0._attention
end

SentryGunMovement.attention_unit_destroy_clbk = function(l_11_0, l_11_1)
  if Network:is_server() then
    l_11_0:set_attention()
  else
    l_11_0:synch_attention()
  end
end

SentryGunMovement.m_head_pos = function(l_12_0)
  return l_12_0._m_head_pos
end

SentryGunMovement.m_com = function(l_13_0)
  return l_13_0._m_head_pos
end

SentryGunMovement.m_pos = function(l_14_0)
  return l_14_0._m_head_pos
end

SentryGunMovement.m_detect_pos = function(l_15_0)
  return l_15_0._m_head_pos
end

SentryGunMovement.m_stand_pos = function(l_16_0)
  return l_16_0._m_head_pos
end

SentryGunMovement.m_head_fwd = function(l_17_0)
  return l_17_0._m_head_fwd
end

SentryGunMovement.set_look_vec3 = function(l_18_0, l_18_1)
  mvector3.set(l_18_0._m_head_fwd, l_18_1)
  local look_rel_polar = l_18_1:to_polar_with_reference(l_18_0._unit_fwd, l_18_0._unit_up)
  l_18_0._spin_obj:set_local_rotation(Rotation(look_rel_polar.spin, 0, 0))
  l_18_0._pitch_obj:set_local_rotation(Rotation(0, look_rel_polar.pitch, 0))
  l_18_0._unit:set_moving(true)
end

SentryGunMovement._upd_movement = function(l_19_0, l_19_1)
  local target_dir = l_19_0:_get_target_dir(l_19_0._attention)
  local unit_fwd_polar = l_19_0._unit_fwd:to_polar()
  local fwd_polar = l_19_0._m_head_fwd:to_polar_with_reference(l_19_0._unit_fwd, l_19_0._unit_up)
  local error_polar = target_dir:to_polar_with_reference(l_19_0._unit_fwd, l_19_0._unit_up)
  error_polar = Polar(1, math.clamp(error_polar.pitch, -55, 35.5), error_polar.spin)
  error_polar = error_polar - fwd_polar
  local _ramp_value = function(l_1_0, l_1_1, l_1_2, l_1_3, l_1_4, l_1_5, l_1_6)
    local sign_err = math.sign(l_1_1)
    local abs_err = (math.abs(l_1_1))
    local wanted_vel = nil
    if abs_err < l_1_3 then
      wanted_vel = math.lerp(l_1_5, l_1_4, abs_err / l_1_3) * sign_err
    else
      wanted_vel = l_1_4 * sign_err
    end
    local err_vel = wanted_vel - l_1_2
    local sign_err_vel = math.sign(err_vel)
    local abs_err_vel = math.abs(err_vel)
    local abs_delta_vel = math.min(l_1_6 * dt, abs_err_vel)
    local delta_vel = abs_delta_vel * sign_err_vel
    local new_vel = l_1_2 + delta_vel
    local at_end = nil
    local correction = new_vel * dt
    if math.abs(l_1_1) <= math.abs(correction) and math.sign(correction) == math.sign(l_1_1) then
      new_vel = 0
      correction = l_1_1
      at_end = true
    end
    local new_val = l_1_0 + correction
    return at_end, new_vel, new_val
   end
  local pitch_end, spin_end, new_vel, new_spin, new_pitch = nil, nil, nil, nil, nil
  spin_end, new_vel, new_spin = _ramp_value(fwd_polar.spin, error_polar.spin, l_19_0._vel.spin, l_19_0._tweak.SLOWDOWN_ANGLE_SPIN, l_19_0._tweak.MAX_VEL_SPIN * l_19_0._rot_speed_mul, l_19_0._tweak.MIN_VEL_SPIN, l_19_0._tweak.ACC_SPIN * l_19_0._rot_speed_mul)
  l_19_0._vel.spin = new_vel
  if l_19_0._tweak.MAX_VEL_SPIN * l_19_0._rot_speed_mul * 0.25 < new_vel and not l_19_0._motor_sound then
    l_19_0._sound_source:post_event("turret_spin_start")
    l_19_0._motor_sound = l_19_0._sound_source:post_event("turret_spin_loop")
    do return end
    if l_19_0._motor_sound and new_vel < l_19_0._tweak.MAX_VEL_SPIN * l_19_0._rot_speed_mul * 0.20000000298023 then
      l_19_0._sound_source:post_event("turret_spin_stop")
      l_19_0._motor_sound:stop()
      l_19_0._motor_sound = false
    end
  end
  if l_19_0._motor_sound then
    l_19_0._sound_source:set_rtpc("spin_vel", math.clamp((new_vel - l_19_0._tweak.MAX_VEL_SPIN * l_19_0._rot_speed_mul * 0.25) / (l_19_0._tweak.MAX_VEL_SPIN * l_19_0._rot_speed_mul), 0, 1))
  end
  pitch_end, new_vel, new_pitch = _ramp_value(fwd_polar.pitch, error_polar.pitch, l_19_0._vel.pitch, l_19_0._tweak.SLOWDOWN_ANGLE_PITCH, l_19_0._tweak.MAX_VEL_PITCH * l_19_0._rot_speed_mul, l_19_0._tweak.MIN_VEL_PITCH, l_19_0._tweak.ACC_PITCH * l_19_0._rot_speed_mul)
  l_19_0._vel.pitch = new_vel
  local new_fwd_polar = Polar(1, new_pitch, new_spin)
  local new_fwd_vec3 = new_fwd_polar:to_vector()
  mvector3.rotate_with(new_fwd_vec3, Rotation(math.UP, 90))
  mvector3.rotate_with(new_fwd_vec3, l_19_0._m_rot)
  l_19_0:set_look_vec3(l_19_0, new_fwd_vec3)
  if pitch_end and spin_end and l_19_0._switched_off then
    l_19_0:set_active(false)
  end
end

SentryGunMovement.give_recoil = function(l_20_0)
  local recoil_tweak = l_20_0._tweak.recoil
  local th = recoil_tweak.horizontal
  local recoil_pitch = math.rand(th[1], th[2]) * math.random(th[3], th[4])
  local tv = recoil_tweak.vertical
  local recoil_spin = math.rand(tv[1], tv[2]) * math.random(tv[3], tv[4])
  local unit_fwd_polar = l_20_0._unit_fwd:to_polar()
  local fwd_polar = l_20_0._m_head_fwd:to_polar_with_reference(l_20_0._unit_fwd, l_20_0._unit_up)
  local recoil_polar = Polar(recoil_pitch, recoil_spin, 0)
  local new_pitch = fwd_polar.pitch + recoil_pitch
  local new_spin = fwd_polar.spin + recoil_spin
  local new_fwd_polar = Polar(1, new_pitch, new_spin)
  local new_fwd_vec3 = new_fwd_polar:to_vector()
  mvector3.rotate_with(new_fwd_vec3, Rotation(math.UP, 90))
  mvector3.rotate_with(new_fwd_vec3, l_20_0._m_rot)
  l_20_0:set_look_vec3(l_20_0, new_fwd_vec3)
end

SentryGunMovement._get_target_dir = function(l_21_0, l_21_1)
  if not l_21_1 then
    if l_21_0._switched_off then
      mvector3.set(tmp_vec2, l_21_0._unit_fwd)
      mvector3.rotate_with(tmp_vec2, l_21_0._switch_off_rot)
      return tmp_vec2
    else
      return l_21_0._unit_fwd
    end
  else
    local target_pos = nil
    if l_21_1.unit then
      target_pos = tmp_vec1
      l_21_1.unit:character_damage():shoot_pos_mid(target_pos)
    else
      target_pos = l_21_1.pos
    end
    local target_vec = tmp_vec2
    mvec3_dir(target_vec, l_21_0._m_head_pos, target_pos)
    return target_vec
  end
end

SentryGunMovement.tased = function(l_22_0)
  return false
end

SentryGunMovement.on_death = function(l_23_0)
  l_23_0._unit:set_extension_update_enabled(Idstring("movement"), false)
end

SentryGunMovement.synch_allow_fire = function(l_24_0, ...)
  l_24_0._unit:brain():synch_allow_fire(...)
   -- DECOMPILER ERROR: Confused about usage of registers for local variables.

end

SentryGunMovement.warming_up = function(l_25_0, l_25_1)
  return l_25_1 < l_25_0._warmup_t
end

SentryGunMovement.switch_off = function(l_26_0)
  l_26_0._switched_off = true
  l_26_0._switch_off_rot = Rotation(l_26_0._m_rot:x(), -35)
end

SentryGunMovement.save = function(l_27_0, l_27_1)
  local my_save_data = {}
  if l_27_0._attention then
    if l_27_0._attention.pos then
      my_save_data.attention = l_27_0._attention
    else
      if l_27_0._attention.unit:id() == -1 then
        my_save_data.attention = {pos = l_27_0._attention.unit:movement():m_com()}
      else
        managers.enemy:add_delayed_clbk("clbk_sync_attention" .. tostring(l_27_0._unit:key()), callback(l_27_0, CopMovement, "clbk_sync_attention", {l_27_0._unit, l_27_0._attention.unit}), TimerManager:game():time() + 0.10000000149012)
      end
    end
  end
  if l_27_0._rot_speed_mul ~= 1 then
    my_save_data.rot_speed_mul = l_27_0._rot_speed_mul
  end
  if next(my_save_data) then
    l_27_1.movement = my_save_data
  end
end

SentryGunMovement.load = function(l_28_0, l_28_1)
  if not l_28_1 or not l_28_1.movement then
    return 
  end
  l_28_0._rot_speed_mul = l_28_1.movement.rot_speed_mul or 1
  if l_28_1.movement.attention then
    l_28_0._attention = l_28_1.movement.attention
  end
end

SentryGunMovement.pre_destroy = function(l_29_0)
  if Network:is_server() then
    l_29_0:set_attention()
  else
    l_29_0:synch_attention()
  end
  if l_29_0._nav_tracker then
    managers.navigation:destroy_nav_tracker(l_29_0._nav_tracker)
    l_29_0._nav_tracker = nil
  end
  if l_29_0._pos_reservation then
    managers.navigation:unreserve_pos(l_29_0._pos_reservation)
    l_29_0._pos_reservation = nil
  end
end


