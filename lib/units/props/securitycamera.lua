-- Decompiled using luadec 2.0.1 by sztupy (http://winmo.sztupy.hu)
-- Command line was: F:\SteamLibrary\SteamApps\common\PAYDAY 2\lua\lib\units\props\securitycamera.luac 

if not SecurityCamera then
  SecurityCamera = class()
end
local l_0_0 = SecurityCamera
local l_0_1 = {}
l_0_1.sound_off = 1
l_0_1.alarm_start = 2
l_0_1.suspicion_1 = 3
l_0_1.suspicion_2 = 4
l_0_1.suspicion_3 = 5
l_0_1.suspicion_4 = 6
l_0_1.suspicion_5 = 7
l_0_1.suspicion_6 = 8
l_0_0._NET_EVENTS = l_0_1
l_0_0 = SecurityCamera
l_0_1 = function(l_1_0, l_1_1)
  l_1_0._unit = l_1_1
  l_1_0:set_update_enabled(false)
end

l_0_0.init = l_0_1
l_0_0 = SecurityCamera
l_0_1 = function(l_2_0, l_2_1, l_2_2, l_2_3)
  if managers.groupai:state():is_ecm_jammer_active("camera") then
    l_2_0:_destroy_all_detected_attention_object_data()
    l_2_0:_stop_all_sounds()
  else
    l_2_0:_upd_detection(l_2_2)
  end
  l_2_0:_upd_sound(l_2_1, l_2_2)
end

l_0_0.update = l_0_1
l_0_0 = SecurityCamera
l_0_1 = function(l_3_0, l_3_1)
  l_3_0._unit:set_extension_update_enabled(Idstring("base"), l_3_1)
end

l_0_0.set_update_enabled = l_0_1
l_0_0 = SecurityCamera
l_0_1 = function(l_4_0, l_4_1, l_4_2, l_4_3)
  if l_4_0._destroyed then
    return 
  end
  l_4_0:set_update_enabled(l_4_1)
  l_4_0._mission_script_element = l_4_3
  if l_4_1 then
    l_4_0._u_key = l_4_0._unit:key()
    if not l_4_0._last_detect_t then
      l_4_0._last_detect_t = TimerManager:game():time()
    end
    l_4_0._detection_interval = 0.10000000149012
    l_4_0._SO_access_str = "security"
    l_4_0._SO_access = managers.navigation:convert_access_filter_to_number({l_4_0._SO_access_str})
    l_4_0._visibility_slotmask = managers.slot:get_mask("AI_visibility")
    if l_4_2 then
      l_4_0._cone_angle = l_4_2.fov
      l_4_0._detection_delay = l_4_2.detection_delay
      l_4_0._range = l_4_2.detection_range
      l_4_0._suspicion_range = l_4_2.suspicion_range
    end
    if not l_4_0._detected_attention_objects then
      l_4_0._detected_attention_objects = {}
    end
    l_4_0._look_obj = l_4_0._unit:get_object(Idstring("CameraLens"))
    l_4_0._yaw_obj = l_4_0._unit:get_object(Idstring("CameraYaw"))
    l_4_0._pitch_obj = l_4_0._unit:get_object(Idstring("CameraPitch"))
    l_4_0._pos = l_4_0._yaw_obj:position()
    l_4_0._look_fwd = nil
    if not l_4_0._tmp_vec1 then
      l_4_0._tmp_vec1 = Vector3()
    end
    l_4_0._suspicion_lvl_sync = 0
  else
    l_4_0._last_detect_t = nil
    l_4_0:_destroy_all_detected_attention_object_data()
    l_4_0._brush = nil
    l_4_0._visibility_slotmask = nil
    l_4_0._detection_delay = nil
    l_4_0._look_obj = nil
    l_4_0._yaw_obj = nil
    l_4_0._pitch_obj = nil
    l_4_0._pos = nil
    l_4_0._look_fwd = nil
    l_4_0._tmp_vec1 = nil
    l_4_0._detected_attention_objects = nil
    l_4_0._suspicion_lvl_sync = nil
    if not l_4_0._destroying then
      l_4_0:_stop_all_sounds()
    end
  end
  if l_4_2 then
    l_4_0:apply_rotations(l_4_2.yaw, l_4_2.pitch)
  end
  managers.groupai:state():register_security_camera(l_4_0._unit, l_4_1)
end

l_0_0.set_detection_enabled = l_0_1
l_0_0 = SecurityCamera
l_0_1 = function(l_5_0, l_5_1, l_5_2)
  if not l_5_0._yaw_obj then
    local yaw_obj = l_5_0._unit:get_object(Idstring("CameraYaw"))
  end
  if not l_5_0._pitch_obj then
    local pitch_obj = l_5_0._unit:get_object(Idstring("CameraPitch"))
  end
  local original_yaw_rot = yaw_obj:local_rotation()
  local new_yaw_rot = Rotation(180 + l_5_1, original_yaw_rot:pitch(), original_yaw_rot:roll())
  yaw_obj:set_local_rotation(new_yaw_rot)
  local original_pitch_rot = pitch_obj:local_rotation()
  local new_pitch_rot = Rotation(original_pitch_rot:yaw(), l_5_2, original_pitch_rot:roll())
  pitch_obj:set_local_rotation(new_pitch_rot)
  l_5_0._look_fwd = nil
  l_5_0._unit:set_moving()
  if Network:is_server() then
    local sync_yaw = 255 * (l_5_1 + 180) / 360
    local sync_pitch = 255 * (l_5_2 + 90) / 180
    managers.network:session():send_to_peers_synched("camera_yaw_pitch", l_5_0._unit, sync_yaw, sync_pitch)
  end
  l_5_0._yaw = l_5_1
  l_5_0._pitch = l_5_2
end

l_0_0.apply_rotations = l_0_1
l_0_0 = SecurityCamera
l_0_1 = function(l_6_0, l_6_1)
  local dt = l_6_1 - l_6_0._last_detect_t
  if l_6_0._detection_interval < dt then
    l_6_0._last_detect_t = l_6_1
    if managers.groupai:state()._draw_enabled then
      if not l_6_0._brush then
        l_6_0._brush = Draw:brush(Color(0.20000000298023, 1, 1, 1), l_6_0._detection_interval)
      end
      l_6_0._look_obj:m_position(l_6_0._tmp_vec1)
      local cone_base = l_6_0._look_obj:rotation():y()
      mvector3.multiply(cone_base, l_6_0._range)
      mvector3.add(cone_base, l_6_0._tmp_vec1)
      local cone_base_rad = math.tan(l_6_0._cone_angle * 0.5) * l_6_0._range
      l_6_0._brush:cone(l_6_0._tmp_vec1, cone_base, cone_base_rad, 8)
    end
    if not l_6_0._look_fwd then
      local tmp_rot1 = l_6_0._look_obj:rotation()
      l_6_0._look_fwd = Vector3()
      mrotation.y(tmp_rot1, l_6_0._look_fwd)
    end
    l_6_0:_upd_acquire_new_attention_objects(l_6_1)
    l_6_0:_upd_detect_attention_objects(l_6_1)
    l_6_0:_upd_suspicion(l_6_1)
  end
end

l_0_0._upd_detection = l_0_1
l_0_0 = SecurityCamera
l_0_1 = function(l_7_0, l_7_1)
  local all_attention_objects = managers.groupai:state():get_AI_attention_objects_by_filter(l_7_0._SO_access_str)
  local detected_obj = l_7_0._detected_attention_objects
  local my_key = l_7_0._u_key
  local my_pos = l_7_0._pos
  local my_fwd = l_7_0._look_fwd
  for u_key,attention_info in pairs(all_attention_objects) do
    if u_key ~= my_key and not detected_obj[u_key] then
      local settings = attention_info.handler:get_attention(l_7_0._SO_access, AIAttentionObject.REACT_SUSPICIOUS)
      if settings then
        local attention_pos = attention_info.handler:get_detection_m_pos()
        if l_7_0:_detection_angle_and_dis_chk(my_pos, my_fwd, attention_info.handler, settings, attention_pos) then
          local vis_ray = l_7_0._unit:raycast("ray", my_pos, attention_pos, "slot_mask", l_7_0._visibility_slotmask, "ray_type", "ai_vision")
          if not vis_ray or vis_ray.unit:key() == u_key then
            detected_obj[u_key] = l_7_0:_create_detected_attention_object_data(l_7_1, u_key, attention_info, settings)
          end
        end
      end
    end
  end
end

l_0_0._upd_acquire_new_attention_objects = l_0_1
l_0_0 = SecurityCamera
l_0_1 = function(l_8_0, l_8_1)
  local detected_obj = l_8_0._detected_attention_objects
  local my_key = l_8_0._u_key
  local my_pos = l_8_0._pos
  local my_fwd = l_8_0._look_fwd
  do
    local det_delay = l_8_0._detection_delay
    for u_key,attention_info in pairs(detected_obj) do
      if l_8_1 < attention_info.next_verify_t then
        for (for control),u_key in (for generator) do
        end
        if not attention_info.identified or not attention_info.verified or not attention_info.settings.verification_interval * 1.2999999523163 then
          attention_info.next_verify_t = l_8_1 + attention_info.settings.verification_interval * 0.30000001192093
          if not attention_info.identified then
            local noticable = nil
            local angle, dis_multiplier = l_8_0:_detection_angle_and_dis_chk(my_pos, my_fwd, attention_info.handler, attention_info.settings, attention_info.handler:get_detection_m_pos())
            if angle then
              local attention_pos = attention_info.handler:get_detection_m_pos()
              local vis_ray = l_8_0._unit:raycast("ray", my_pos, attention_pos, "slot_mask", l_8_0._visibility_slotmask, "ray_type", "ai_vision")
              if not vis_ray or vis_ray.unit:key() == u_key then
                noticable = true
              end
            end
            local delta_prog = nil
            local dt = l_8_1 - attention_info.prev_notice_chk_t
            if noticable then
              if angle == -1 then
                delta_prog = 1
              else
                local min_delay = det_delay[1]
                local max_delay = det_delay[2]
                local angle_mul_mod = 0.25 * math.min(angle / l_8_0._cone_angle, 1)
                local dis_mul_mod = 0.75 * dis_multiplier
                local notice_delay_modified = math.lerp(min_delay, max_delay, dis_mul_mod + angle_mul_mod) * (attention_info.settings.notice_delay_mul or 1)
                delta_prog = notice_delay_modified > 0 and dt / notice_delay_modified or 1
              end
            elseif det_delay[2] <= 0 or not -dt / det_delay[2] then
               -- DECOMPILER ERROR: Attempted to build a boolean expression without a pending context

              delta_prog = -1
            end
          end
          attention_info.notice_progress = attention_info.notice_progress + delta_prog
          if attention_info.notice_progress > 1 then
            attention_info.notice_progress = nil
            attention_info.prev_notice_chk_t = nil
            attention_info.identified = true
            attention_info.release_t = l_8_1 + attention_info.settings.release_delay
            attention_info.identified_t = l_8_1
            noticable = true
            if AIAttentionObject.REACT_SCARED <= attention_info.settings.reaction then
              managers.groupai:state():on_criminal_suspicion_progress(attention_info.unit, l_8_0._unit, true)
            elseif attention_info.notice_progress < 0 then
              l_8_0:_destroy_detected_attention_object_data(attention_info)
              noticable = false
            else
              noticable = attention_info.notice_progress
              attention_info.prev_notice_chk_t = l_8_1
              if AIAttentionObject.REACT_SCARED <= attention_info.settings.reaction then
                managers.groupai:state():on_criminal_suspicion_progress(attention_info.unit, l_8_0._unit, noticable)
              end
            end
          end
          if noticable ~= false and attention_info.settings.notice_clbk then
            attention_info.settings.notice_clbk(l_8_0._unit, noticable)
          end
        end
        if attention_info.identified then
          attention_info.nearly_visible = nil
          local verified, vis_ray = nil, nil
          local attention_pos = attention_info.handler:get_detection_m_pos()
          local dis = mvector3.distance(my_pos, attention_info.m_pos)
          if dis < l_8_0._range * 1.2000000476837 then
            local detect_pos = nil
            if attention_info.is_husk_player and attention_info.unit:anim_data().crouch then
              detect_pos = l_8_0._tmp_vec1
              mvector3.set(detect_pos, attention_info.m_pos)
              mvector3.add(detect_pos, tweak_data.player.stances.default.crouched.head.translation)
            else
              detect_pos = attention_pos
            end
            local in_FOV = l_8_0:_detection_angle_chk(my_pos, my_fwd, detect_pos, 0.80000001192093)
            if in_FOV then
              vis_ray = l_8_0._unit:raycast("ray", my_pos, detect_pos, "slot_mask", l_8_0._visibility_slotmask, "ray_type", "ai_vision")
              if not vis_ray or vis_ray.unit:key() == u_key then
                verified = true
              end
            end
            attention_info.verified = verified
          end
          attention_info.dis = dis
          if verified then
            attention_info.release_t = nil
            attention_info.verified_t = l_8_1
            mvector3.set(attention_info.verified_pos, attention_pos)
            attention_info.last_verified_pos = mvector3.copy(attention_pos)
            attention_info.verified_dis = dis
            for (for control),u_key in (for generator) do
            end
            if attention_info.release_t and attention_info.release_t < l_8_1 then
              l_8_0:_destroy_detected_attention_object_data(attention_info)
              for (for control),u_key in (for generator) do
              end
              if not attention_info.release_t then
                attention_info.release_t = l_8_1 + attention_info.settings.release_delay
              end
            end
          end
        end
         -- Warning: missing end command somewhere! Added here
      end
       -- Warning: missing end command somewhere! Added here
    end
     -- Warning: missing end command somewhere! Added here
  end
end

l_0_0._upd_detect_attention_objects = l_0_1
l_0_0 = SecurityCamera
l_0_1 = function(l_9_0, l_9_1, l_9_2, l_9_3, l_9_4, l_9_5)
  local dis = (mvector3.direction(l_9_0._tmp_vec1, l_9_1, l_9_5))
  local dis_multiplier, angle_multiplier = nil, nil
  dis_multiplier = dis / l_9_0._range
  if dis_multiplier < 1 then
    if l_9_4.notice_requires_FOV then
      local angle = mvector3.angle(l_9_2, l_9_0._tmp_vec1)
      local angle_max = l_9_0._cone_angle * 0.5
      angle_multiplier = angle / angle_max
      if angle_multiplier < 1 then
        return angle, dis_multiplier
      else
        return 0, dis_multiplier
      end
    end
  end
end

l_0_0._detection_angle_and_dis_chk = l_0_1
l_0_0 = SecurityCamera
l_0_1 = function(l_10_0, l_10_1, l_10_2, l_10_3, l_10_4)
  mvector3.direction(l_10_0._tmp_vec1, l_10_1, l_10_3)
  local angle = mvector3.angle(l_10_2, l_10_0._tmp_vec1)
  local angle_max = l_10_0._cone_angle * 0.5
  if angle * l_10_4 < angle_max then
    return true
  end
end

l_0_0._detection_angle_chk = l_0_1
l_0_0 = SecurityCamera
l_0_1 = function(l_11_0, l_11_1)
  local mission_script_element = l_11_0._mission_script_element
  l_11_0:set_detection_enabled(false)
  managers.statistics:camera_destroyed()
  if mission_script_element then
    mission_script_element:on_destroyed(l_11_0._unit)
  end
  if l_11_0._access_camera_mission_element then
    l_11_0._access_camera_mission_element:access_camera_operation_destroy()
  end
  l_11_0._destroyed = true
end

l_0_0.generate_cooldown = l_0_1
l_0_0 = SecurityCamera
l_0_1 = function(l_12_0, l_12_1)
  l_12_0._access_camera_mission_element = l_12_1
end

l_0_0.set_access_camera_mission_element = l_0_1
l_0_0 = SecurityCamera
l_0_1 = function(l_13_0, l_13_1, l_13_2, l_13_3, l_13_4)
  l_13_3.handler:add_listener("sec_cam_" .. tostring(l_13_0._u_key), callback(l_13_0, l_13_0, "on_detected_attention_obj_modified"))
  local att_unit = l_13_3.unit
  local m_pos = l_13_3.handler:get_ground_m_pos()
  local m_head_pos = (l_13_3.handler:get_detection_m_pos())
  local is_local_player, is_husk_player, is_deployable, is_person, is_very_dangerous, nav_tracker, char_tweak = nil, nil, nil, nil, nil, nil, nil
  if att_unit:base() then
    is_local_player = att_unit:base().is_local_player
    is_husk_player = att_unit:base().is_husk_player
    is_deployable = att_unit:base().sentry_gun
    is_person = att_unit:in_slot(managers.slot:get_mask("persons"))
    if att_unit:base()._tweak_table then
      char_tweak = tweak_data.character[att_unit:base()._tweak_table]
    end
  end
  local dis = mvector3.distance(l_13_0._pos, m_head_pos)
  {settings = l_13_4, unit = l_13_3.unit, u_key = l_13_2, handler = l_13_3.handler, next_verify_t = l_13_1 + l_13_4.verification_interval, prev_notice_chk_t = l_13_1, notice_progress = 0, m_pos = m_pos, m_head_pos = m_head_pos, nav_tracker = l_13_3.nav_tracker, is_local_player = is_local_player, is_husk_player = is_husk_player, is_human_player = is_local_player or is_husk_player, is_deployable = is_deployable, is_person = is_person, is_very_dangerous = is_very_dangerous}.reaction = l_13_4.reaction
   -- DECOMPILER ERROR: Confused about usage of registers!

  {settings = l_13_4, unit = l_13_3.unit, u_key = l_13_2, handler = l_13_3.handler, next_verify_t = l_13_1 + l_13_4.verification_interval, prev_notice_chk_t = l_13_1, notice_progress = 0, m_pos = m_pos, m_head_pos = m_head_pos, nav_tracker = l_13_3.nav_tracker, is_local_player = is_local_player, is_husk_player = is_husk_player, is_human_player = is_local_player or is_husk_player, is_deployable = is_deployable, is_person = is_person, is_very_dangerous = is_very_dangerous}.criminal_record = managers.groupai:state():criminal_record(l_13_2)
   -- DECOMPILER ERROR: Confused about usage of registers!

  {settings = l_13_4, unit = l_13_3.unit, u_key = l_13_2, handler = l_13_3.handler, next_verify_t = l_13_1 + l_13_4.verification_interval, prev_notice_chk_t = l_13_1, notice_progress = 0, m_pos = m_pos, m_head_pos = m_head_pos, nav_tracker = l_13_3.nav_tracker, is_local_player = is_local_player, is_husk_player = is_husk_player, is_human_player = is_local_player or is_husk_player, is_deployable = is_deployable, is_person = is_person, is_very_dangerous = is_very_dangerous}.char_tweak = char_tweak
   -- DECOMPILER ERROR: Confused about usage of registers!

  {settings = l_13_4, unit = l_13_3.unit, u_key = l_13_2, handler = l_13_3.handler, next_verify_t = l_13_1 + l_13_4.verification_interval, prev_notice_chk_t = l_13_1, notice_progress = 0, m_pos = m_pos, m_head_pos = m_head_pos, nav_tracker = l_13_3.nav_tracker, is_local_player = is_local_player, is_husk_player = is_husk_player, is_human_player = is_local_player or is_husk_player, is_deployable = is_deployable, is_person = is_person, is_very_dangerous = is_very_dangerous}.verified_pos = mvector3.copy(m_head_pos)
   -- DECOMPILER ERROR: Confused about usage of registers!

  {settings = l_13_4, unit = l_13_3.unit, u_key = l_13_2, handler = l_13_3.handler, next_verify_t = l_13_1 + l_13_4.verification_interval, prev_notice_chk_t = l_13_1, notice_progress = 0, m_pos = m_pos, m_head_pos = m_head_pos, nav_tracker = l_13_3.nav_tracker, is_local_player = is_local_player, is_husk_player = is_husk_player, is_human_player = is_local_player or is_husk_player, is_deployable = is_deployable, is_person = is_person, is_very_dangerous = is_very_dangerous}.verified_dis = dis
   -- DECOMPILER ERROR: Confused about usage of registers!

  {settings = l_13_4, unit = l_13_3.unit, u_key = l_13_2, handler = l_13_3.handler, next_verify_t = l_13_1 + l_13_4.verification_interval, prev_notice_chk_t = l_13_1, notice_progress = 0, m_pos = m_pos, m_head_pos = m_head_pos, nav_tracker = l_13_3.nav_tracker, is_local_player = is_local_player, is_husk_player = is_husk_player, is_human_player = is_local_player or is_husk_player, is_deployable = is_deployable, is_person = is_person, is_very_dangerous = is_very_dangerous}.dis = dis
   -- DECOMPILER ERROR: Confused about usage of registers!

  {settings = l_13_4, unit = l_13_3.unit, u_key = l_13_2, handler = l_13_3.handler, next_verify_t = l_13_1 + l_13_4.verification_interval, prev_notice_chk_t = l_13_1, notice_progress = 0, m_pos = m_pos, m_head_pos = m_head_pos, nav_tracker = l_13_3.nav_tracker, is_local_player = is_local_player, is_husk_player = is_husk_player, is_human_player = is_local_player or is_husk_player, is_deployable = is_deployable, is_person = is_person, is_very_dangerous = is_very_dangerous}.verified = false
   -- DECOMPILER ERROR: Confused about usage of registers!

  {settings = l_13_4, unit = l_13_3.unit, u_key = l_13_2, handler = l_13_3.handler, next_verify_t = l_13_1 + l_13_4.verification_interval, prev_notice_chk_t = l_13_1, notice_progress = 0, m_pos = m_pos, m_head_pos = m_head_pos, nav_tracker = l_13_3.nav_tracker, is_local_player = is_local_player, is_husk_player = is_husk_player, is_human_player = is_local_player or is_husk_player, is_deployable = is_deployable, is_person = is_person, is_very_dangerous = is_very_dangerous}.verified_t = false
  do
     -- DECOMPILER ERROR: Confused at declaration of local variable

     -- DECOMPILER ERROR: Confused about usage of registers!

    return {settings = l_13_4, unit = l_13_3.unit, u_key = l_13_2, handler = l_13_3.handler, next_verify_t = l_13_1 + l_13_4.verification_interval, prev_notice_chk_t = l_13_1, notice_progress = 0, m_pos = m_pos, m_head_pos = m_head_pos, nav_tracker = l_13_3.nav_tracker, is_local_player = is_local_player, is_husk_player = is_husk_player, is_human_player = is_local_player or is_husk_player, is_deployable = is_deployable, is_person = is_person, is_very_dangerous = is_very_dangerous}
  end
   -- DECOMPILER ERROR: Confused about usage of registers for local variables.

end

l_0_0._create_detected_attention_object_data = l_0_1
l_0_0 = SecurityCamera
l_0_1 = function(l_14_0, l_14_1)
  local attention_info = l_14_0._detected_attention_objects[l_14_1]
  if not attention_info then
    return 
  end
  local new_settings = attention_info.handler:get_attention(l_14_0._SO_access, AIAttentionObject.REACT_SUSPICIOUS)
  local old_settings = attention_info.settings
  if new_settings == old_settings then
    return 
  end
  local old_notice_clbk = (not attention_info.identified and old_settings.notice_clbk)
  do
    if AIAttentionObject.REACT_SCARED > new_settings.reaction or attention_info.reaction ~= AIAttentionObject.REACT_SUSPICIOUS then
      local switch_from_suspicious = not new_settings
    end
    attention_info.settings = new_settings
    if attention_info.uncover_progress then
      attention_info.uncover_progress = nil
      attention_info.unit:movement():on_suspicion(l_14_0._unit, false)
      managers.groupai:state():on_criminal_suspicion_progress(attention_info.unit, l_14_0._unit, nil)
    end
    if attention_info.identified then
      if switch_from_suspicious then
        attention_info.identified = false
        attention_info.notice_progress = attention_info.uncover_progress or 0
      end
      attention_info.verified = nil
      attention_info.next_verify_t = 0
      attention_info.prev_notice_chk_t = TimerManager:game():time()
    elseif switch_from_suspicious then
      attention_info.notice_progress = 0
      attention_info.prev_notice_chk_t = TimerManager:game():time()
    end
    attention_info.reaction = new_settings.reaction
  end
  do return end
  l_14_0:_destroy_detected_attention_object_data(attention_info)
  if old_notice_clbk and (not new_settings or not new_settings.notice_clbk) then
    old_notice_clbk(l_14_0._unit, false)
  end
  if AIAttentionObject.REACT_SCARED <= old_settings.reaction and (not new_settings or AIAttentionObject.REACT_SCARED > new_settings.reaction) then
    managers.groupai:state():on_criminal_suspicion_progress(attention_info.unit, l_14_0._unit, nil)
  end
end

l_0_0.on_detected_attention_obj_modified = l_0_1
l_0_0 = SecurityCamera
l_0_1 = function(l_15_0, l_15_1)
  l_15_1.handler:remove_listener("sec_cam_" .. tostring(l_15_0._u_key))
  if l_15_1.settings.notice_clbk then
    l_15_1.settings.notice_clbk(l_15_0._unit, false)
  end
  if l_15_1.uncover_progress then
    l_15_1.unit:movement():on_suspicion(l_15_0._unit, false)
  end
  managers.groupai:state():on_criminal_suspicion_progress(l_15_1.unit, l_15_0._unit, false)
  l_15_0._detected_attention_objects[l_15_1.u_key] = nil
end

l_0_0._destroy_detected_attention_object_data = l_0_1
l_0_0 = SecurityCamera
l_0_1 = function(l_16_0)
  if not l_16_0._detected_attention_objects then
    return 
  end
  for u_key,attention_info in pairs(l_16_0._detected_attention_objects) do
    attention_info.handler:remove_listener("sec_cam_" .. tostring(l_16_0._u_key))
    if not attention_info.identified and attention_info.settings.notice_clbk then
      attention_info.settings.notice_clbk(l_16_0._unit, false)
    end
    if attention_info.uncover_progress then
      attention_info.unit:movement():on_suspicion(l_16_0._unit, false)
    end
    managers.groupai:state():on_criminal_suspicion_progress(attention_info.unit, l_16_0._unit, false)
  end
  l_16_0._detected_attention_objects = {}
end

l_0_0._destroy_all_detected_attention_object_data = l_0_1
l_0_0 = SecurityCamera
l_0_1 = function(l_17_0, l_17_1)
  local _exit_func = function(l_1_0)
    l_1_0.unit:movement():on_uncovered(self._unit)
    self:_sound_the_alarm(l_1_0.unit)
   end
  do
    local max_suspicion = 0
    for u_key,attention_data in pairs(l_17_0._detected_attention_objects) do
      if attention_data.identified and attention_data.reaction == AIAttentionObject.REACT_SUSPICIOUS and not attention_data.verified and attention_data.last_suspicion_t then
        attention_data.last_suspicion_t = l_17_1
        for (for control),u_key in (for generator) do
          local dis = attention_data.dis
          local susp_settings = attention_data.unit:base():suspicion_settings()
          local suspicion_range = l_17_0._suspicion_range
          local uncover_range = 0
          local max_range = l_17_0._range
          if attention_data.settings.uncover_range and dis < math.min(max_range, uncover_range * susp_settings.range_mul) then
            attention_data.unit:movement():on_suspicion(l_17_0._unit, true)
            managers.groupai:state():on_criminal_suspicion_progress(attention_data.unit, l_17_0._unit, true)
            managers.groupai:state():criminal_spotted(attention_data.unit)
            max_suspicion = 1
            _exit_func(attention_data)
            for (for control),u_key in (for generator) do
            end
            if suspicion_range and dis < math.min(max_range, suspicion_range * susp_settings.range_mul) then
              if attention_data.last_suspicion_t then
                local dt = l_17_1 - attention_data.last_suspicion_t
                local range_max = (suspicion_range - uncover_range) * susp_settings.range_mul
                local range_min = uncover_range
                local mul = 1 - (dis - range_min) / range_max
                do
                  local progress = dt * 0.15000000596046 * mul * susp_settings.buildup_mul
                  attention_data.uncover_progress = (attention_data.uncover_progress or 0) + progress
                  max_suspicion = math.max(max_suspicion, attention_data.uncover_progress)
                  if attention_data.uncover_progress < 1 then
                    attention_data.unit:movement():on_suspicion(l_17_0._unit, attention_data.uncover_progress)
                    for (for control),u_key in (for generator) do
                    end
                    attention_data.unit:movement():on_suspicion(l_17_0._unit, true)
                    managers.groupai:state():on_criminal_suspicion_progress(attention_data.unit, l_17_0._unit, true)
                    managers.groupai:state():criminal_spotted(attention_data.unit)
                    _exit_func(attention_data)
                  end
                  for (for control),u_key in (for generator) do
                  end
                  attention_data.uncover_progress = 0
                  attention_data.last_suspicion_t = l_17_1
                  managers.groupai:state():on_criminal_suspicion_progress(attention_data.unit, l_17_0._unit, 0)
                  for (for control),u_key in (for generator) do
                  end
                  do
                    if attention_data.uncover_progress and attention_data.last_suspicion_t then
                      local dt = l_17_1 - attention_data.last_suspicion_t
                      attention_data.uncover_progress = attention_data.uncover_progress - dt
                      if attention_data.uncover_progress <= 0 then
                        attention_data.uncover_progress = nil
                        attention_data.last_suspicion_t = nil
                        attention_data.unit:movement():on_suspicion(l_17_0._unit, false)
                        managers.groupai:state():on_criminal_suspicion_progress(attention_data.unit, l_17_0._unit, false)
                        for (for control),u_key in (for generator) do
                        end
                        max_suspicion = math.max(max_suspicion, attention_data.uncover_progress)
                        attention_data.unit:movement():on_suspicion(l_17_0._unit, attention_data.uncover_progress)
                      end
                      for (for control),u_key in (for generator) do
                      end
                      attention_data.last_suspicion_t = l_17_1
                    end
                  end
                  l_17_0._suspicion = (max_suspicion > 0 and max_suspicion)
                end
                 -- Warning: missing end command somewhere! Added here
              end
               -- Warning: missing end command somewhere! Added here
            end
             -- Warning: missing end command somewhere! Added here
          end
           -- Warning: missing end command somewhere! Added here
        end
         -- Warning: missing end command somewhere! Added here
      end
       -- Warning: missing end command somewhere! Added here
    end
     -- Warning: missing end command somewhere! Added here
  end
end

l_0_0._upd_suspicion = l_0_1
l_0_0 = SecurityCamera
l_0_1 = function(l_18_0, l_18_1)
  if l_18_0._alarm_sound then
    return 
  end
  if Network:is_server() then
    if l_18_0._mission_script_element then
      l_18_0._mission_script_element:on_alarm(l_18_0._unit)
    end
    l_18_0:_send_net_event(l_18_0._NET_EVENTS.alarm_start)
    l_18_0._call_police_clbk_id = "cam_call_cops" .. tostring(l_18_0._unit:key())
    managers.enemy:add_delayed_clbk(l_18_0._call_police_clbk_id, callback(l_18_0, l_18_0, "clbk_call_the_police"), Application:time() + 7)
    local reason_called = managers.groupai:state().analyse_giveaway("security_camera", l_18_1)
    l_18_0._reason_called = managers.groupai:state():fetch_highest_giveaway(l_18_0._reason_called, reason_called)
  end
  if l_18_0._suspicion_sound then
    l_18_0._suspicion_sound = nil
    l_18_0._unit:sound_source():post_event("camera_suspicious_signal_stop")
  end
  l_18_0._alarm_sound = l_18_0._unit:sound_source():post_event("camera_alarm_signal")
end

l_0_0._sound_the_alarm = l_0_1
l_0_0 = SecurityCamera
l_0_1 = function(l_19_0)
  if Network:is_server() and (l_19_0._alarm_sound or l_19_0._suspicion_sound) then
    l_19_0:_send_net_event(l_19_0._NET_EVENTS.sound_off)
  end
  if l_19_0._alarm_sound or l_19_0._suspicion_sound then
    l_19_0._alarm_sound = nil
    l_19_0._suspicion_sound = nil
    l_19_0._unit:sound_source():post_event("camera_silent")
  end
  l_19_0._suspicion_lvl_sync = 0
  l_19_0._suspicion_sound_lvl = 0
end

l_0_0._stop_all_sounds = l_0_1
l_0_0 = SecurityCamera
l_0_1 = function(l_20_0, l_20_1)
  if l_20_0._suspicion_sound_lvl == l_20_1 then
    return 
  end
  if not l_20_0._suspicion_sound then
    l_20_0._suspicion_sound = l_20_0._unit:sound_source():post_event("camera_suspicious_signal")
    l_20_0._suspicion_sound_lvl = 0
  end
  local pitch = l_20_0._suspicion_sound_lvl <= l_20_1 and 1 or 0.60000002384186
  l_20_0._suspicion_sound_lvl = l_20_1
  l_20_0._unit:sound_source():set_rtpc("camera_suspicion_level_pitch", pitch)
  l_20_0._unit:sound_source():set_rtpc("camera_suspicion_level", l_20_1)
  if Network:is_server() then
    local suspicion_lvl_sync = math.clamp(math.ceil(l_20_1 * 6), 1, 6)
    if suspicion_lvl_sync ~= l_20_0._suspicion_lvl_sync then
      l_20_0._suspicion_lvl_sync = suspicion_lvl_sync
      local event_id = l_20_0._NET_EVENTS.suspicion_" .. tostring(suspicion_lvl_sync
      l_20_0:_send_net_event(event_id)
    end
  end
end

l_0_0._set_suspicion_sound = l_0_1
l_0_0 = SecurityCamera
l_0_1 = function(l_21_0, l_21_1, l_21_2)
  if l_21_0._alarm_sound then
    return 
  end
  do
    local suspicion_level = l_21_0._suspicion
    for u_key,attention_info in pairs(l_21_0._detected_attention_objects) do
      if AIAttentionObject.REACT_SCARED <= attention_info.reaction and attention_info.identified and attention_info.verified then
        l_21_0:_sound_the_alarm(attention_info.unit)
        return 
        for (for control),u_key in (for generator) do
          if not suspicion_level or suspicion_level < attention_info.notice_progress then
            suspicion_level = attention_info.notice_progress
          end
        end
      end
      if not suspicion_level then
        l_21_0:_set_suspicion_sound(0)
        l_21_0:_stop_all_sounds()
        return 
      end
      l_21_0:_set_suspicion_sound(suspicion_level)
    end
     -- Warning: missing end command somewhere! Added here
  end
end

l_0_0._upd_sound = l_0_1
l_0_0 = SecurityCamera
l_0_1 = function(l_22_0, l_22_1)
  local net_events = l_22_0._NET_EVENTS
  if net_events.suspicion_1 <= l_22_1 and l_22_1 <= net_events.suspicion_6 then
    local suspicion_lvl = (l_22_1 - net_events.suspicion_1 + 1) / 6
    l_22_0:_set_suspicion_sound(suspicion_lvl)
  elseif l_22_1 == net_events.sound_off then
    l_22_0:_stop_all_sounds()
  elseif l_22_1 == net_events.alarm_start then
    l_22_0:_sound_the_alarm()
  end
end

l_0_0.sync_net_event = l_0_1
l_0_0 = SecurityCamera
l_0_1 = function(l_23_0, l_23_1)
  managers.network:session():send_to_peers_synched("sync_unit_event_id_8", l_23_0._unit, "base", l_23_1)
end

l_0_0._send_net_event = l_0_1
l_0_0 = SecurityCamera
l_0_1 = function(l_24_0)
  l_24_0._call_police_clbk_id = nil
  managers.groupai:state():on_police_called(l_24_0._reason_called)
end

l_0_0.clbk_call_the_police = l_0_1
l_0_0 = SecurityCamera
l_0_1 = function(l_25_0, l_25_1)
  if l_25_0._alarm_sound then
    l_25_1.alarm = true
  elseif l_25_0._suspicion_sound then
    l_25_1.suspicion_lvl = l_25_0._suspicion_lvl_sync
  end
  if l_25_0._yaw then
    l_25_1.yaw = l_25_0._yaw
    l_25_1.pitch = l_25_0._pitch
  end
end

l_0_0.save = l_0_1
l_0_0 = SecurityCamera
l_0_1 = function(l_26_0, l_26_1)
  if l_26_1.alarm then
    l_26_0:_sound_the_alarm()
  elseif l_26_1.suspicion_lvl then
    l_26_0:_set_suspicion_sound(l_26_1.suspicion_lvl)
  end
  if l_26_1.yaw then
    l_26_0:apply_rotations(l_26_1.yaw, l_26_1.pitch)
  end
end

l_0_0.load = l_0_1
l_0_0 = SecurityCamera
l_0_1 = function(l_27_0, l_27_1)
  l_27_0._destroying = true
  l_27_0:set_detection_enabled(false)
  if l_27_0._call_police_clbk_id then
    managers.enemy:remove_delayed_clbk(l_27_0._call_police_clbk_id)
    l_27_0._call_police_clbk_id = nil
  end
end

l_0_0.destroy = l_0_1

