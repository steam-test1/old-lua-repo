-- Decompiled using luadec 2.0.1 by sztupy (http://winmo.sztupy.hu)
-- Command line was: F:\SteamLibrary\SteamApps\common\PAYDAY 2\lua\lib\units\enemies\cop\logics\coplogicsniper.luac 

local tmp_vec1 = Vector3()
CopLogicSniper = class(CopLogicBase)
CopLogicSniper.damage_clbk = CopLogicIdle.damage_clbk
CopLogicSniper.on_detected_enemy_destroyed = CopLogicAttack.on_detected_enemy_destroyed
CopLogicSniper.on_criminal_neutralized = CopLogicAttack.on_criminal_neutralized
CopLogicSniper.is_available_for_assignment = CopLogicAttack.is_available_for_assignment
CopLogicSniper.death_clbk = CopLogicAttack.death_clbk
CopLogicSniper.on_alert = CopLogicIdle.on_alert
CopLogicSniper.on_intimidated = CopLogicIdle.on_intimidated
CopLogicSniper.on_new_objective = CopLogicIdle.on_new_objective
CopLogicSniper.enter = function(l_1_0, l_1_1, l_1_2)
  CopLogicBase.enter(l_1_0, l_1_1, l_1_2)
  local objective = l_1_0.objective
  l_1_0.unit:brain():cancel_all_pathing_searches()
  local old_internal_data = l_1_0.internal_data
  local my_data = {unit = l_1_0.unit}
  my_data.detection = l_1_0.char_tweak.detection.recon
  if old_internal_data then
    my_data.rsrv_pos = old_internal_data.rsrv_pos
    if old_internal_data.nearest_cover then
      my_data.nearest_cover = old_internal_data.nearest_cover
      managers.navigation:reserve_cover(my_data.nearest_cover[1], l_1_0.pos_rsrv_id)
    end
    if old_internal_data.best_cover then
      my_data.best_cover = old_internal_data.best_cover
      managers.navigation:reserve_cover(my_data.best_cover[1], l_1_0.pos_rsrv_id)
    end
  end
  l_1_0.internal_data = my_data
  if not my_data.rsrv_pos then
    my_data.rsrv_pos = {}
  end
  if not my_data.rsrv_pos.stand then
    local pos_rsrv = {position = mvector3.copy(l_1_0.m_pos), radius = 100, filter = l_1_0.pos_rsrv_id}
    my_data.rsrv_pos.stand = pos_rsrv
    managers.navigation:add_pos_reservation(pos_rsrv)
  end
  local key_str = tostring(l_1_0.unit:key())
  my_data.detection_task_key = "CopLogicSniper._upd_enemy_detection" .. key_str
  CopLogicBase.queue_task(my_data, my_data.detection_task_key, CopLogicSniper._upd_enemy_detection, l_1_0)
  CopLogicTravel.reset_actions(l_1_0, my_data, old_internal_data, CopLogicTravel.allowed_transitional_actions)
  CopLogicBase._reset_attention(l_1_0)
  if objective then
    my_data.wanted_stance = objective.stance
    my_data.wanted_pose = objective.pose
    my_data.attitude = objective.attitude or "avoid"
  end
  l_1_0.unit:movement():set_cool(false)
  if my_data ~= l_1_0.internal_data then
    return 
  end
  l_1_0.unit:brain():set_attention_settings({cbt = true})
  my_data.weapon_range = l_1_0.char_tweak.weapon[l_1_0.unit:inventory():equipped_unit():base():weapon_tweak_data().usage].range
  if l_1_0.char_tweak.weapon[l_1_0.unit:inventory():equipped_unit():base():weapon_tweak_data().usage].use_laser then
    l_1_0.unit:inventory():equipped_unit():base():set_laser_enabled(true)
    my_data.weapon_laser_on = true
    managers.enemy:_destroy_unit_gfx_lod_data(l_1_0.key)
    managers.network:session():send_to_peers_synched("sync_unit_event_id_8", l_1_0.unit, "brain", HuskCopBrain._NET_EVENTS.weapon_laser_on)
  end
end

CopLogicSniper.exit = function(l_2_0, l_2_1, l_2_2)
  CopLogicBase.exit(l_2_0, l_2_1, l_2_2)
  local my_data = l_2_0.internal_data
  l_2_0.unit:brain():cancel_all_pathing_searches()
  CopLogicBase.cancel_queued_tasks(my_data)
  if my_data.nearest_cover then
    managers.navigation:release_cover(my_data.nearest_cover[1])
  end
  if my_data.best_cover then
    managers.navigation:release_cover(my_data.best_cover[1])
  end
  if my_data.weapon_laser_on then
    if l_2_0.unit:inventory():equipped_unit() then
      l_2_0.unit:inventory():equipped_unit():base():set_laser_enabled(false)
    end
    managers.network:session():send_to_peers_synched("sync_unit_event_id_8", l_2_0.unit, "brain", HuskCopBrain._NET_EVENTS.weapon_laser_off)
    if l_2_1 ~= "inactive" then
      managers.enemy:_create_unit_gfx_lod_data(l_2_0.unit)
    end
  end
end

CopLogicSniper._upd_enemy_detection = function(l_3_0)
  managers.groupai:state():on_unit_detection_updated(l_3_0.unit)
  l_3_0.t = TimerManager:game():time()
  local my_data = l_3_0.internal_data
  local min_reaction = AIAttentionObject.REACT_AIM
  local delay = CopLogicBase._upd_attention_obj_detection(l_3_0, min_reaction, nil)
  local new_attention, new_prio_slot, new_reaction = CopLogicIdle._get_priority_attention(l_3_0, l_3_0.detected_attention_objects, CopLogicSniper._chk_reaction_to_attention_object)
  local old_att_obj = l_3_0.attention_obj
  CopLogicBase._set_attention_obj(l_3_0, new_attention, new_reaction)
  if new_reaction and AIAttentionObject.REACT_SCARED <= new_reaction then
    local objective = l_3_0.objective
    local wanted_state = nil
    local allow_trans, obj_failed = CopLogicBase.is_obstructed(l_3_0, objective, nil, new_attention)
    if allow_trans and obj_failed then
      wanted_state = CopLogicBase._get_logic_state_from_reaction(l_3_0)
    end
    if wanted_state and wanted_state ~= l_3_0.name then
      if obj_failed then
        managers.groupai:state():on_objective_failed(l_3_0.unit, l_3_0.objective)
      end
      if my_data == l_3_0.internal_data then
        CopLogicBase._exit(l_3_0.unit, wanted_state)
      end
      CopLogicBase._report_detections(l_3_0.detected_attention_objects)
      return 
    end
  end
  CopLogicSniper._upd_aim(l_3_0, my_data)
  if l_3_0.important then
    delay = 0
  else
    delay = 0.5 + delay * 1.5
  end
  CopLogicBase.queue_task(my_data, my_data.detection_task_key, CopLogicSniper._upd_enemy_detection, l_3_0, l_3_0.t + (delay))
  CopLogicBase._report_detections(l_3_0.detected_attention_objects)
end

CopLogicSniper._chk_stand_visibility = function(l_4_0, l_4_1, l_4_2)
  mvector3.set(tmp_vec1, l_4_0)
  mvector3.set_z(tmp_vec1, l_4_0.z + 150)
  local ray = World:raycast("ray", tmp_vec1, l_4_1, "slot_mask", l_4_2, "ray_type", "ai_vision", "report")
  return ray
end

CopLogicSniper._chk_crouch_visibility = function(l_5_0, l_5_1, l_5_2)
  mvector3.set(tmp_vec1, l_5_0)
  mvector3.set_z(tmp_vec1, l_5_0.z + 50)
  local ray = World:raycast("ray", tmp_vec1, l_5_1, "slot_mask", l_5_2, "ray_type", "ai_vision", "report")
  return ray
end

CopLogicSniper.action_complete_clbk = function(l_6_0, l_6_1)
  local action_type = l_6_1:type()
  local my_data = l_6_0.internal_data
  if action_type == "turn" then
    my_data.turning = nil
  elseif action_type == "shoot" then
    my_data.shooting = nil
  elseif action_type == "walk" then
    my_data.advacing = nil
    if l_6_1.expired then
      my_data.reposition = nil
    elseif action_type == "hurt" and (l_6_1:body_part() == 1 or l_6_1:body_part() == 2) and l_6_0.objective and l_6_0.objective.pos then
      my_data.reposition = true
    end
  end
end

CopLogicSniper._upd_aim = function(l_7_0, l_7_1)
  local shoot, aim = nil, nil
  local focus_enemy = l_7_0.attention_obj
  if focus_enemy then
    if focus_enemy.verified then
      shoot = true
    elseif l_7_1.wanted_stance == "cbt" then
      aim = true
    elseif focus_enemy.verified_t and l_7_0.t - focus_enemy.verified_t < 20 then
      aim = true
    end
    if aim and not shoot and l_7_1.shooting and focus_enemy.verified_t and l_7_0.t - focus_enemy.verified_t < 2 then
      shoot = true
    end
  end
  if shoot and focus_enemy.reaction < AIAttentionObject.REACT_SHOOT then
    shoot = nil
    aim = true
  end
  if not l_7_1.turning then
    local action_taken = l_7_0.unit:movement():chk_action_forbidden("walk")
  end
  if not action_taken then
    local anim_data = l_7_0.unit:anim_data()
    if anim_data.reload and not anim_data.crouch and l_7_0.char_tweak.allow_crouch then
      action_taken = CopLogicAttack._chk_request_action_crouch(l_7_0)
    end
    if action_taken then
      do return end
    end
    if l_7_1.attitude == "engage" and not l_7_0.is_suppressed and focus_enemy and (focus_enemy.verified_pos or not CopLogicAttack._chk_request_action_turn_to_enemy(l_7_0, l_7_1, l_7_0.m_pos, focus_enemy.m_head_pos)) and not focus_enemy.verified and not anim_data.reload and anim_data.crouch and not l_7_0.char_tweak.no_stand and not CopLogicSniper._chk_stand_visibility(l_7_0.m_pos, focus_enemy.m_head_pos, l_7_0.visibility_slotmask) then
      CopLogicAttack._chk_request_action_stand(l_7_0)
      do return end
      if l_7_0.char_tweak.allow_crouch and not CopLogicSniper._chk_crouch_visibility(l_7_0.m_pos, focus_enemy.m_head_pos, l_7_0.visibility_slotmask) then
        CopLogicAttack._chk_request_action_crouch(l_7_0)
        do return end
         -- DECOMPILER ERROR: unhandled construct in 'if'

        if l_7_1.wanted_pose and not anim_data.reload and l_7_1.wanted_pose == "crouch" and not anim_data.crouch and l_7_0.char_tweak.allow_crouch then
          action_taken = CopLogicAttack._chk_request_action_crouch(l_7_0)
          do return end
          if not anim_data.stand and not l_7_0.char_tweak.no_stand then
            action_taken = CopLogicAttack._chk_request_action_stand(l_7_0)
            do return end
            if focus_enemy and (focus_enemy.verified_pos or not CopLogicAttack._chk_request_action_turn_to_enemy(l_7_0, l_7_1, l_7_0.m_pos, focus_enemy.m_head_pos)) and focus_enemy.verified and anim_data.stand and l_7_0.char_tweak.allow_crouch and CopLogicSniper._chk_crouch_visibility(l_7_0.m_pos, focus_enemy.m_head_pos, l_7_0.visibility_slotmask) then
              CopLogicAttack._chk_request_action_crouch(l_7_0)
              do return end
               -- DECOMPILER ERROR: unhandled construct in 'if'

              if l_7_1.wanted_pose and not anim_data.reload and l_7_1.wanted_pose == "crouch" and not anim_data.crouch and l_7_0.char_tweak.allow_crouch then
                action_taken = CopLogicAttack._chk_request_action_crouch(l_7_0)
                do return end
                if not anim_data.stand and not l_7_0.char_tweak.no_stand then
                  action_taken = CopLogicAttack._chk_request_action_stand(l_7_0)
                end
              end
            end
          end
        end
      end
    end
  end
  if l_7_1.reposition and not action_taken and not l_7_1.advancing then
    local objective = l_7_0.objective
     -- DECOMPILER ERROR: Overwrote pending register.

     -- DECOMPILER ERROR: Overwrote pending register.

    l_7_1.advance_path = {}
    if CopLogicTravel._chk_request_action_walk_to_advance_pos(mvector3.copy(l_7_0.m_pos), mvector3.copy(objective.pos), objective.haste or "walk", objective.rot) then
      action_taken = true
    end
  end
  if aim or shoot then
     -- DECOMPILER ERROR: unhandled construct in 'if'

    if focus_enemy.verified and l_7_1.attention_unit ~= focus_enemy.unit:key() then
      CopLogicBase._set_attention(l_7_0, focus_enemy)
      l_7_1.attention_unit = focus_enemy.unit:key()
      do return end
      if l_7_1.attention_unit ~= focus_enemy.verified_pos then
        CopLogicBase._set_attention_on_pos(l_7_0, mvector3.copy(focus_enemy.verified_pos))
        l_7_1.attention_unit = mvector3.copy(focus_enemy.verified_pos)
      end
    end
    if not l_7_1.shooting and not l_7_0.unit:anim_data().reload and not l_7_0.unit:movement():chk_action_forbidden("action") then
      local shoot_action = {type = "shoot", body_part = 3}
      if l_7_0.unit:brain():action_request(shoot_action) then
        l_7_1.shooting = true
      elseif l_7_1.shooting then
        local new_action = nil
        if l_7_0.unit:anim_data().reload then
          new_action = {type = "reload", body_part = 3}
        else
          new_action = {type = "idle", body_part = 3}
        end
        l_7_0.unit:brain():action_request(new_action)
      end
      if l_7_1.attention_unit then
        CopLogicBase._reset_attention(l_7_0)
        l_7_1.attention_unit = nil
      end
    end
  end
  CopLogicAttack.aim_allow_fire(shoot, aim, l_7_0, l_7_1)
end

CopLogicSniper._chk_reaction_to_attention_object = function(l_8_0, l_8_1, l_8_2)
  local record = l_8_1.criminal_record
  if not record or not l_8_1.is_person then
    return l_8_1.settings.reaction
  end
  local att_unit = l_8_1.unit
  local assault_mode = managers.groupai:state():get_assault_mode()
  if l_8_1.is_deployable or l_8_0.t < record.arrest_timeout then
    return math.min(l_8_1.settings.reaction, AIAttentionObject.REACT_COMBAT)
  end
  if record.status == "disabled" then
    if record.assault_t and record.assault_t - record.disabled_t > 0.60000002384186 then
      return math.min(l_8_1.settings.reaction, AIAttentionObject.REACT_COMBAT)
    end
    return AIAttentionObject.REACT_AIM
  elseif record.being_arrested then
    return AIAttentionObject.REACT_AIM
  end
  return math.min(l_8_1.settings.reaction, AIAttentionObject.REACT_COMBAT)
end

CopLogicSniper.should_duck_on_alert = function(l_9_0, l_9_1)
  return (l_9_0.internal_data.attitude == "avoid" and CopLogicBase.should_duck_on_alert(l_9_0, l_9_1))
end


