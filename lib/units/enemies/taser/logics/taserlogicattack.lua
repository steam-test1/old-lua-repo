-- Decompiled using luadec 2.0.1 by sztupy (http://winmo.sztupy.hu)
-- Command line was: F:\SteamLibrary\SteamApps\common\PAYDAY 2\lua\lib\units\enemies\taser\logics\taserlogicattack.luac 

TaserLogicAttack = class(CopLogicAttack)
TaserLogicAttack.enter = function(l_1_0, l_1_1, l_1_2)
  CopLogicBase.enter(l_1_0, l_1_1, l_1_2)
  l_1_0.unit:brain():cancel_all_pathing_searches()
  local old_internal_data = l_1_0.internal_data
  local my_data = {unit = l_1_0.unit}
  l_1_0.internal_data = my_data
  my_data.detection = l_1_0.char_tweak.detection.combat
  my_data.tase_distance = l_1_0.char_tweak.weapon.m4.tase_distance
  my_data.rsrv_pos = {}
  if old_internal_data then
    if not old_internal_data.rsrv_pos then
      my_data.rsrv_pos = my_data.rsrv_pos
    end
    CopLogicAttack._set_best_cover(l_1_0, my_data, old_internal_data.best_cover)
    CopLogicAttack._set_nearest_cover(my_data, old_internal_data.nearest_cover)
  end
  local key_str = tostring(l_1_0.key)
  my_data.update_task_key = "TaserLogicAttack.queued_update" .. key_str
  CopLogicBase.queue_task(my_data, my_data.update_task_key, TaserLogicAttack.queued_update, l_1_0, l_1_0.t, l_1_0.important)
  l_1_0.unit:brain():set_update_enabled_state(false)
  CopLogicTravel.reset_actions(l_1_0, my_data, old_internal_data, CopLogicTravel.allowed_transitional_actions)
  local objective = l_1_0.objective
  my_data.attitude = not objective or l_1_0.objective.attitude or "avoid"
  my_data.weapon_range = l_1_0.char_tweak.weapon[l_1_0.unit:inventory():equipped_unit():base():weapon_tweak_data().usage].range
  my_data.cover_test_step = 1
  local upper_body_action = l_1_0.unit:movement()._active_actions[3]
  if not upper_body_action or upper_body_action:type() ~= "shoot" then
    l_1_0.unit:movement():set_stance("hos")
  end
  l_1_0.tase_delay_t = l_1_0.tase_delay_t or -1
  TaserLogicAttack._chk_play_charge_weapon_sound(l_1_0, my_data, l_1_0.attention_obj)
  l_1_0.unit:movement():set_cool(false)
  if my_data ~= l_1_0.internal_data then
    return 
  end
  l_1_0.unit:brain():set_attention_settings({cbt = true})
end

TaserLogicAttack.exit = function(l_2_0, l_2_1, l_2_2)
  CopLogicBase.exit(l_2_0, l_2_1, l_2_2)
  local my_data = l_2_0.internal_data
  l_2_0.unit:brain():cancel_all_pathing_searches()
  TaserLogicAttack._cancel_tase_attempt(l_2_0, my_data)
  CopLogicBase.cancel_queued_tasks(my_data)
  if my_data.best_cover then
    managers.navigation:release_cover(my_data.best_cover[1])
  end
  if my_data.nearest_cover then
    managers.navigation:release_cover(my_data.nearest_cover[1])
  end
  local rsrv_pos = my_data.rsrv_pos
  if rsrv_pos.path then
    managers.navigation:unreserve_pos(rsrv_pos.path)
    rsrv_pos.path = nil
  end
  if rsrv_pos.move_dest then
    managers.navigation:unreserve_pos(rsrv_pos.move_dest)
    rsrv_pos.move_dest = nil
  end
  l_2_0.unit:brain():set_update_enabled_state(true)
end

TaserLogicAttack.queued_update = function(l_3_0)
  if CopLogicIdle._chk_relocate(l_3_0) then
    return 
  end
  CopLogicAttack._update_cover(l_3_0)
  local t = TimerManager:game():time()
  l_3_0.t = t
  local unit = l_3_0.unit
  local my_data = l_3_0.internal_data
  local objective = l_3_0.objective
  TaserLogicAttack._upd_enemy_detection(l_3_0)
  if my_data ~= l_3_0.internal_data then
    CopLogicBase._report_detections(l_3_0.detected_attention_objects)
    return 
  elseif not l_3_0.attention_obj then
    CopLogicBase.queue_task(my_data, my_data.update_task_key, TaserLogicAttack.queued_update, l_3_0, l_3_0.t + 1, l_3_0.important)
    CopLogicBase._report_detections(l_3_0.detected_attention_objects)
    return 
  end
  local focus_enemy = l_3_0.attention_obj
  if not my_data.turning and not l_3_0.unit:movement():chk_action_forbidden("walk") and not my_data.moving_to_cover and not my_data.walking_to_cover_shoot_pos then
    local action_taken = my_data.acting
  end
  if my_data.tasing then
    if not action_taken then
      action_taken = CopLogicAttack._chk_request_action_turn_to_enemy(l_3_0, my_data, l_3_0.m_pos, focus_enemy.m_pos)
    end
    CopLogicBase.queue_task(my_data, my_data.update_task_key, TaserLogicAttack.queued_update, l_3_0, l_3_0.t + 2, l_3_0.important)
    CopLogicBase._report_detections(l_3_0.detected_attention_objects)
    return 
  end
  CopLogicAttack._process_pathing_results(l_3_0, my_data)
  if AIAttentionObject.REACT_COMBAT <= l_3_0.attention_obj.reaction then
    CopLogicAttack._update_cover(l_3_0)
    CopLogicAttack._upd_combat_movement(l_3_0)
  end
  CopLogicBase.queue_task(my_data, my_data.update_task_key, TaserLogicAttack.queued_update, l_3_0, l_3_0.t + 1.5, l_3_0.important)
  CopLogicBase._report_detections(l_3_0.detected_attention_objects)
end

TaserLogicAttack._upd_enemy_detection = function(l_4_0)
  managers.groupai:state():on_unit_detection_updated(l_4_0.unit)
  l_4_0.t = TimerManager:game():time()
  local my_data = l_4_0.internal_data
  local min_reaction = AIAttentionObject.REACT_AIM
  CopLogicBase._upd_attention_obj_detection(l_4_0, min_reaction, nil)
  local under_multiple_fire = nil
  local alert_chk_t = l_4_0.t - 1.2000000476837
  for key,enemy_data in pairs(l_4_0.detected_attention_objects) do
    if not under_multiple_fire then
      under_multiple_fire = (not enemy_data.dmg_t or alert_chk_t >= enemy_data.dmg_t or 0) + 1
    end
    if under_multiple_fire > 2 then
      under_multiple_fire = true
  else
    end
  end
  local find_new_focus_enemy = nil
  local tasing = my_data.tasing
  if tasing then
    local tased_u_key = tasing.target_u_key
  end
  if tasing then
    local tase_in_effect = tasing.target_u_data.unit:movement():tased()
  end
  if (tase_in_effect or not tasing or l_4_0.t - tasing.start_t < math.max(1, l_4_0.char_tweak.weapon.m4.aim_delay_tase[2] * 1.5)) and under_multiple_fire then
    find_new_focus_enemy = true
    do return end
    find_new_focus_enemy = true
  end
  if not find_new_focus_enemy then
    return 
  end
  local new_attention, new_prio_slot, new_reaction = CopLogicIdle._get_priority_attention(l_4_0, l_4_0.detected_attention_objects, TaserLogicAttack._chk_reaction_to_attention_object)
  local old_att_obj = l_4_0.attention_obj
  CopLogicBase._set_attention_obj(l_4_0, new_attention, new_reaction)
  CopLogicAttack._chk_exit_attack_logic(l_4_0, new_reaction)
  if my_data ~= l_4_0.internal_data then
    return 
  end
   -- DECOMPILER ERROR: unhandled construct in 'if'

  if new_attention and old_att_obj and old_att_obj.u_key ~= new_attention.u_key then
    CopLogicAttack._cancel_charge(l_4_0, my_data)
    if not l_4_0.unit:movement():chk_action_forbidden("walk") then
      CopLogicAttack._cancel_walking_to_cover(l_4_0, my_data)
    end
    CopLogicAttack._set_best_cover(l_4_0, my_data, nil)
    TaserLogicAttack._chk_play_charge_weapon_sound(l_4_0, my_data, new_attention)
    do return end
    TaserLogicAttack._chk_play_charge_weapon_sound(l_4_0, my_data, new_attention)
    do return end
    if old_att_obj then
      CopLogicAttack._cancel_charge(l_4_0, my_data)
    end
  end
  TaserLogicAttack._upd_aim(l_4_0, my_data, new_reaction)
end

TaserLogicAttack._upd_aim = function(l_5_0, l_5_1, l_5_2)
  local shoot, aim = nil, nil
  local focus_enemy = l_5_0.attention_obj
  local tase = l_5_2 == AIAttentionObject.REACT_SPECIAL_ATTACK
  if focus_enemy then
    if tase then
      shoot = true
    elseif focus_enemy.verified and (focus_enemy.verified_dis < 1500 or not l_5_1.alert_t or l_5_0.t - l_5_1.alert_t < 7) then
      shoot = true
      if focus_enemy.verified_dis > 800 and l_5_0.unit:anim_data().run then
        local walk_to_pos = l_5_0.unit:movement():get_walk_to_pos()
        if walk_to_pos then
          local move_vec = walk_to_pos - l_5_0.m_pos
          do
            local enemy_vec = focus_enemy.m_pos - l_5_0.m_pos
            mvector3.normalize(enemy_vec)
            if mvector3.dot(enemy_vec, move_vec) < 0.60000002384186 then
              shoot = nil
            end
            do return end
            if focus_enemy.verified_t and l_5_0.t - focus_enemy.verified_t < 10 then
              aim = true
              if l_5_1.shooting and l_5_0.t - focus_enemy.verified_t < 3 then
                shoot = true
              elseif focus_enemy.verified_dis < 600 and l_5_1.walking_to_cover_shoot_pos then
                aim = true
              end
            end
          end
        end
      end
    end
  end
  if shoot and (l_5_1.walking_to_cover_shoot_pos or not tase or l_5_1.moving_to_cover) and not l_5_0.unit:movement():chk_action_forbidden("walk") then
    local new_action = {type = "idle", body_part = 2}
    l_5_0.unit:brain():action_request(new_action)
  end
  if aim or shoot then
     -- DECOMPILER ERROR: unhandled construct in 'if'

    if focus_enemy.verified and l_5_1.attention_unit ~= focus_enemy.u_key then
      CopLogicBase._set_attention(l_5_0, focus_enemy)
      l_5_1.attention_unit = focus_enemy.u_key
      do return end
      if l_5_1.attention_unit ~= focus_enemy.verified_pos then
        CopLogicBase._set_attention_on_pos(l_5_0, mvector3.copy(focus_enemy.verified_pos))
        l_5_1.attention_unit = mvector3.copy(focus_enemy.verified_pos)
      end
    end
     -- DECOMPILER ERROR: unhandled construct in 'if'

    if not l_5_0.unit:anim_data().reload and not l_5_0.unit:movement():chk_action_forbidden("action") and tase and (not l_5_1.tasing or l_5_1.tasing.target_u_data ~= focus_enemy) and not l_5_0.unit:movement():chk_action_forbidden("walk") then
      if l_5_1.attention_unit ~= focus_enemy.u_key then
        CopLogicBase._set_attention(l_5_0, focus_enemy)
        l_5_1.attention_unit = focus_enemy.u_key
      end
      do
        local tase_action = {type = "tase", body_part = 3}
        if l_5_0.unit:brain():action_request(tase_action) then
          l_5_1.tasing = {target_u_data = focus_enemy, target_u_key = focus_enemy.u_key, start_t = l_5_0.t}
          CopLogicAttack._cancel_charge(l_5_0, l_5_1)
          managers.groupai:state():on_tase_start(l_5_0.key, focus_enemy.u_key)
        end
        do return end
        if shoot and not l_5_1.shooting then
          local shoot_action = {}
          shoot_action.type = "shoot"
          shoot_action.body_part = 3
          if l_5_0.unit:brain():action_request(shoot_action) then
            l_5_1.shooting = true
          elseif l_5_1.shooting or l_5_1.tasing then
            local new_action = nil
            if l_5_0.unit:anim_data().reload then
              new_action = {type = "reload", body_part = 3}
            else
              new_action = {type = "idle", body_part = 3}
            end
            l_5_0.unit:brain():action_request(new_action)
          else
            if not l_5_0.unit:anim_data().run then
              local ammo_max, ammo = l_5_0.unit:inventory():equipped_unit():base():ammo_info()
              if ammo / ammo_max < 0.5 then
                local new_action = {type = "reload", body_part = 3}
                l_5_0.unit:brain():action_request(new_action)
              end
            end
          end
          if l_5_1.attention_unit then
            CopLogicBase._reset_attention(l_5_0)
            l_5_1.attention_unit = nil
          end
        end
      end
    end
  end
  CopLogicAttack.aim_allow_fire(shoot, aim, l_5_0, l_5_1)
end

TaserLogicAttack.action_complete_clbk = function(l_6_0, l_6_1)
  local my_data = l_6_0.internal_data
  local action_type = l_6_1:type()
  if action_type == "walk" then
    if my_data.moving_to_cover then
      if l_6_1:expired() then
        my_data.in_cover = my_data.moving_to_cover
        CopLogicAttack._set_nearest_cover(my_data, my_data.in_cover)
        my_data.cover_enter_t = l_6_0.t
        my_data.cover_sideways_chk = nil
      end
      my_data.moving_to_cover = nil
    elseif my_data.walking_to_cover_shoot_pos then
      my_data.walking_to_cover_shoot_pos = nil
    elseif action_type == "shoot" then
      my_data.shooting = nil
    elseif action_type == "turn" then
      my_data.turning = nil
    elseif action_type == "tase" then
      if l_6_1:expired() and my_data.tasing then
        local record = managers.groupai:state():criminal_record(my_data.tasing.target_u_key)
        if record and record.status then
          l_6_0.tase_delay_t = TimerManager:game():time() + 45
        end
      end
      managers.groupai:state():on_tase_end(my_data.tasing.target_u_key)
      my_data.tasing = nil
    end
  end
end

TaserLogicAttack._cancel_tase_attempt = function(l_7_0, l_7_1)
  if l_7_1.tasing then
    local new_action = {type = "idle", body_part = 3}
    l_7_0.unit:brain():action_request(new_action)
  end
end

TaserLogicAttack.on_criminal_neutralized = function(l_8_0, l_8_1)
  local my_data = l_8_0.internal_data
  if my_data.tasing and l_8_1 == my_data.tasing.target_u_data.u_key and not my_data.tasing.target_u_data.unit:movement():tased() then
    CopLogicAttack.on_criminal_neutralized(l_8_0, l_8_1)
    TaserLogicAttack._cancel_tase_attempt(l_8_0, my_data)
    do return end
    CopLogicAttack.on_criminal_neutralized(l_8_0, l_8_1)
  end
end

TaserLogicAttack.on_detected_enemy_destroyed = function(l_9_0, l_9_1)
  CopLogicAttack.on_detected_enemy_destroyed(l_9_0, l_9_1)
  local my_data = l_9_0.internal_data
  if my_data.tasing and l_9_1:key() == my_data.tasing.target_u_data.u_key then
    TaserLogicAttack._cancel_tase_attempt(l_9_0, my_data)
  end
end

TaserLogicAttack.damage_clbk = function(l_10_0, l_10_1)
  CopLogicIdle.damage_clbk(l_10_0, l_10_1)
end

TaserLogicAttack._chk_reaction_to_attention_object = function(l_11_0, l_11_1, l_11_2)
  local reaction = CopLogicIdle._chk_reaction_to_attention_object(l_11_0, l_11_1, l_11_2)
  if reaction < AIAttentionObject.REACT_SHOOT or not l_11_1.criminal_record or not l_11_1.is_person then
    return reaction
  end
  if (l_11_1.is_human_player or not l_11_1.unit:movement():chk_action_forbidden("hurt")) and l_11_1.verified and l_11_1.verified_dis < l_11_0.internal_data.tase_distance * 0.89999997615814 then
    if l_11_0.tase_delay_t < l_11_0.t then
      return AIAttentionObject.REACT_SPECIAL_ATTACK
    else
      return AIAttentionObject.REACT_COMBAT
    end
  end
  return reaction
end

TaserLogicAttack._chk_play_charge_weapon_sound = function(l_12_0, l_12_1, l_12_2)
  if not l_12_1.tasing and (not l_12_1.last_charge_snd_play_t or l_12_0.t - l_12_1.last_charge_snd_play_t > 30) and l_12_2.verified_dis < 2000 and math.abs(l_12_0.m_pos.z - l_12_2.m_pos.z) < 300 then
    l_12_1.last_charge_snd_play_t = l_12_0.t
    l_12_0.unit:sound():play("taser_charge", nil, true)
  end
end


