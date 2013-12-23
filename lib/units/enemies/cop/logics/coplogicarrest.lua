-- Decompiled using luadec 2.0.1 by sztupy (http://winmo.sztupy.hu)
-- Command line was: F:\SteamLibrary\SteamApps\common\PAYDAY 2\lua\lib\units\enemies\cop\logics\coplogicarrest.luac 

CopLogicArrest = class(CopLogicBase)
CopLogicArrest.on_alert = CopLogicIdle.on_alert
CopLogicArrest.on_intimidated = CopLogicIdle.on_intimidated
CopLogicArrest.on_new_objective = CopLogicIdle.on_new_objective
CopLogicArrest.enter = function(l_1_0, l_1_1, l_1_2)
  CopLogicBase.enter(l_1_0, l_1_1, l_1_2)
  l_1_0.unit:brain():cancel_all_pathing_searches()
  local old_internal_data = l_1_0.internal_data
  local my_data = {unit = l_1_0.unit}
  l_1_0.internal_data = my_data
  my_data.detection = l_1_0.char_tweak.detection.guard
  my_data.arrest_targets = {}
  my_data.rsrv_pos = {}
  if old_internal_data then
    if not old_internal_data.rsrv_pos then
      my_data.rsrv_pos = my_data.rsrv_pos
    end
    if old_internal_data.best_cover then
      my_data.best_cover = old_internal_data.best_cover
      managers.navigation:reserve_cover(my_data.best_cover[1], l_1_0.pos_rsrv_id)
    end
    if old_internal_data.nearest_cover then
      my_data.nearest_cover = old_internal_data.nearest_cover
      managers.navigation:reserve_cover(my_data.nearest_cover[1], l_1_0.pos_rsrv_id)
    end
  end
  local key_str = tostring(l_1_0.key)
  my_data.update_task_key = "CopLogicArrest.queued_update" .. key_str
  CopLogicBase.queue_task(my_data, my_data.update_task_key, CopLogicArrest.queued_update, l_1_0, l_1_0.t)
  l_1_0.unit:brain():set_update_enabled_state(false)
  CopLogicTravel.reset_actions(l_1_0, my_data, old_internal_data, CopLogicTravel.allowed_transitional_actions)
  if not l_1_0.char_tweak.no_stand and not l_1_0.unit:anim_data().stand then
    CopLogicAttack._chk_request_action_stand(l_1_0)
  end
  l_1_0.unit:movement():set_cool(false)
  if my_data ~= l_1_0.internal_data then
    return 
  end
  if l_1_0.objective and (l_1_0.objective.nav_seg or l_1_0.objective.type == "follow") and not l_1_0.objective.in_place then
    debug_pause_unit(l_1_0.unit, "[CopLogicArrest.enter] wrong logic1", l_1_0.unit, "objective", inspect(l_1_0.objective))
  end
  if l_1_0.unit:movement():stance_name() == "ntl" then
    l_1_0.unit:movement():set_stance("cbt")
  end
  l_1_0.unit:brain():set_attention_settings({cbt = true})
  my_data.next_action_delay_t = l_1_0.t + math.lerp(2, 2.5, math.random())
  my_data.weapon_range = l_1_0.char_tweak.weapon[l_1_0.unit:inventory():equipped_unit():base():weapon_tweak_data().usage].range
  if l_1_0.objective and (l_1_0.objective.nav_seg or l_1_0.objective.type == "follow") and not l_1_0.objective.in_place then
    debug_pause_unit(l_1_0.unit, "[CopLogicArrest.enter] wrong logic2", l_1_0.unit, "objective", inspect(l_1_0.objective))
  end
end

CopLogicArrest.exit = function(l_2_0, l_2_1, l_2_2)
  CopLogicBase.exit(l_2_0, l_2_1, l_2_2)
  local my_data = l_2_0.internal_data
  l_2_0.unit:brain():cancel_all_pathing_searches()
  CopLogicBase.cancel_queued_tasks(my_data)
  CopLogicBase.cancel_delayed_clbks(my_data)
  if my_data.best_cover then
    managers.navigation:release_cover(my_data.best_cover[1])
  end
  if my_data.nearest_cover then
    managers.navigation:release_cover(my_data.nearest_cover[1])
  end
  for u_key,enemy_arrest_data in pairs(my_data.arrest_targets) do
    managers.groupai:state():on_arrest_end(l_2_0.key, u_key)
  end
  if l_2_1 ~= "inactive" then
    l_2_0.unit:brain():set_update_enabled_state(true)
    CopLogicBase._reset_attention(l_2_0)
  end
  if my_data.calling_the_police then
    local action_data = {type = "idle", body_part = 3}
    l_2_0.unit:brain():action_request(action_data)
  end
end

CopLogicArrest.queued_update = function(l_3_0)
  l_3_0.t = TimerManager:game():time()
  local my_data = l_3_0.internal_data
  CopLogicArrest._upd_enemy_detection(l_3_0)
  if my_data ~= l_3_0.internal_data then
    return 
  end
  local attention_obj = l_3_0.attention_obj
  if attention_obj then
    local arrest_data = my_data.arrest_targets[attention_obj.u_key]
  end
  do
    if not l_3_0.unit:anim_data().reload and not l_3_0.unit:movement():chk_action_forbidden("action") and attention_obj and AIAttentionObject.REACT_ARREST <= attention_obj.reaction and not my_data.shooting and not l_3_0.unit:anim_data().reload then
      local shoot_action = {type = "shoot", body_part = 3}
      if l_3_0.unit:brain():action_request(shoot_action) then
        my_data.shooting = true
      end
      do return end
      if my_data.shooting and not l_3_0.unit:anim_data().reload then
        local idle_action = {type = "idle", body_part = 3}
        l_3_0.unit:brain():action_request(idle_action)
      else
        if l_3_0.unit:movement():stance_name() == "ntl" then
          l_3_0.unit:movement():set_stance("cbt")
        end
      end
    end
  end
  if arrest_data then
    if not arrest_data.intro_t then
      arrest_data.intro_t = l_3_0.t
      l_3_0.unit:sound():say("i01", true)
      if not attention_obj.is_human_player then
        attention_obj.unit:brain():on_intimidated(1, l_3_0.unit)
      end
      if not l_3_0.unit:movement():chk_action_forbidden("action") then
        local new_action = {type = "act", variant = "arrest", body_part = 1}
        if l_3_0.unit:brain():action_request(new_action) then
          my_data.gesture_arrest = true
        elseif not arrest_data.intro_pos and l_3_0.t - arrest_data.intro_t > 1 then
          arrest_data.intro_pos = mvector3.copy(attention_obj.m_pos)
        end
      end
    end
  end
  if (arrest_data and arrest_data.intro_pos) or my_data.should_stand_close then
    CopLogicArrest._upd_advance(l_3_0, my_data, attention_obj, arrest_data)
  end
  if attention_obj and not my_data.turning and not my_data.advancing and not l_3_0.unit:movement():chk_action_forbidden("walk") then
    CopLogicIdle._chk_request_action_turn_to_look_pos(l_3_0, my_data, l_3_0.m_pos, attention_obj.m_pos)
  end
  CopLogicArrest._upd_cover(l_3_0)
  CopLogicBase.queue_task(my_data, my_data.update_task_key, CopLogicArrest.queued_update, l_3_0, l_3_0.t + 1, l_3_0.important)
  CopLogicBase._report_detections(l_3_0.detected_attention_objects)
end

CopLogicArrest._upd_advance = function(l_4_0, l_4_1, l_4_2, l_4_3)
  if not l_4_1.turning then
    local action_taken = l_4_0.unit:movement():chk_action_forbidden("walk")
  end
  do
     -- DECOMPILER ERROR: unhandled construct in 'if'

    if l_4_3 and l_4_1.should_arrest and l_4_2.dis < 180 and not action_taken then
       -- DECOMPILER ERROR: unhandled construct in 'if'

      if not l_4_0.unit:anim_data().idle_full_blend and l_4_2.dis < 150 and not l_4_0.unit:anim_data().idle then
        local action_data = {type = "idle", body_part = 1}
        l_4_0.unit:brain():action_request(action_data)
      end
      do return end
      if not l_4_0.unit:anim_data().crouch then
        CopLogicAttack._chk_request_action_crouch(l_4_0)
      end
    end
    if l_4_0.unit:anim_data().idle_full_blend then
      l_4_2.unit:movement():on_cuffed()
      l_4_0.unit:sound():say("i03", true, false)
      return 
      do return end
      if not l_4_3.approach_snd and l_4_2.dis < 600 and l_4_2.dis > 500 and not l_4_0.unit:sound():speaking(l_4_0.t) then
        l_4_3.approach_snd = true
        l_4_0.unit:sound():say("i02", true)
        do return end
        if l_4_1.should_arrest and l_4_2.dis < 300 and not l_4_0.unit:sound():speaking(l_4_0.t) then
          CopLogicArrest._chk_say_approach(l_4_0, l_4_1, l_4_2)
        end
      end
    end
  end
  if action_taken then
    return 
  end
  if l_4_1.advancing then
    do return end
  end
   -- DECOMPILER ERROR: unhandled construct in 'if'

  if l_4_1.advance_path and l_4_1.next_action_delay_t < l_4_0.t and not l_4_0.unit:movement():chk_action_forbidden("walk") then
    if not l_4_0.char_tweak.no_stand and l_4_1.should_stand_close and not l_4_0.unit:anim_data().stand then
      CopLogicAttack._chk_request_action_stand(l_4_0)
    end
    do
      local new_action_data = {type = "walk", nav_path = l_4_1.advance_path, variant = "walk", body_part = 2}
      l_4_1.advance_path = nil
      l_4_1.advancing = l_4_0.unit:brain():action_request(new_action_data)
      if l_4_1.advancing and l_4_1.rsrv_pos.stand then
        managers.navigation:unreserve_pos(l_4_1.rsrv_pos.stand)
        l_4_1.rsrv_pos.stand = nil
      end
      do return end
      if l_4_1.processing_path then
        CopLogicArrest._process_pathing_results(l_4_0, l_4_1)
      elseif not l_4_1.in_position and l_4_1.next_action_delay_t < l_4_0.t then
        if l_4_1.should_arrest then
          l_4_1.path_search_id = "cuff" .. tostring(l_4_0.key)
          l_4_1.processing_path = true
          l_4_0.unit:brain():search_for_path_to_unit(l_4_1.path_search_id, l_4_2.unit)
        elseif l_4_1.should_stand_close then
          CopLogicArrest._say_scary_stuff_discovered(l_4_0)
          local close_pos, need_pathing = CopLogicArrest._get_att_obj_close_pos(l_4_0, l_4_1)
          if need_pathing then
            l_4_1.path_search_id = "stand_close" .. tostring(l_4_0.key)
            l_4_1.processing_path = true
            l_4_0.unit:brain():search_for_path(l_4_1.path_search_id, close_pos, 1, nil)
          elseif close_pos then
            l_4_1.advance_path = {mvector3.copy(l_4_0.m_pos), close_pos}
          else
            l_4_1.in_position = true
          end
        else
          debug_pause_unit(l_4_0.unit, "not sure what I am supposed to do", l_4_0.unit, l_4_0.attention_obj)
        end
      end
    end
  end
end

CopLogicArrest._upd_cover = function(l_5_0)
  local my_data = l_5_0.internal_data
  if not my_data.best_cover and not my_data.nearest_cover then
    return 
  end
  local cover_release_dis = 100
  local best_cover = my_data.best_cover
  local nearest_cover = my_data.nearest_cover
  local m_pos = l_5_0.m_pos
  if nearest_cover and cover_release_dis < mvector3.distance(nearest_cover[1][1], m_pos) then
    managers.navigation:release_cover(nearest_cover[1])
    my_data.nearest_cover = nil
    nearest_cover = nil
  end
  if best_cover and cover_release_dis < mvector3.distance(best_cover[1][1], m_pos) then
    managers.navigation:release_cover(best_cover[1])
    my_data.best_cover = nil
    best_cover = nil
  end
end

CopLogicArrest._upd_enemy_detection = function(l_6_0)
  managers.groupai:state():on_unit_detection_updated(l_6_0.unit)
  l_6_0.t = TimerManager:game():time()
  local my_data = l_6_0.internal_data
  local delay = CopLogicBase._upd_attention_obj_detection(l_6_0, nil, nil)
  local all_attention_objects = l_6_0.detected_attention_objects
  local arrest_targets = my_data.arrest_targets
  CopLogicArrest._verify_arrest_targets(l_6_0, my_data)
  local new_attention, new_prio_slot, new_reaction = CopLogicArrest._get_priority_attention(l_6_0, l_6_0.detected_attention_objects)
  local old_att_obj = l_6_0.attention_obj
  CopLogicBase._set_attention_obj(l_6_0, new_attention, new_reaction)
  local should_arrest = new_reaction == AIAttentionObject.REACT_ARREST
  local should_stand_close = ((new_reaction == AIAttentionObject.REACT_SCARED or new_attention) and new_attention.criminal_record and new_attention.criminal_record.status)
  if should_arrest ~= my_data.should_arrest or should_stand_close ~= my_data.should_stand_close then
    my_data.should_arrest = should_arrest
    my_data.should_stand_close = should_stand_close
    CopLogicArrest._cancel_advance(l_6_0, my_data)
  end
  if should_arrest and not my_data.arrest_targets[new_attention.u_key] then
    my_data.arrest_targets[new_attention.u_key] = {attention_obj = new_attention}
    managers.groupai:state():on_arrest_start(l_6_0.key, new_attention.u_key)
  end
  CopLogicArrest._mark_call_in_event(l_6_0, my_data, new_attention)
  CopLogicArrest._chk_say_discovery(l_6_0, my_data, new_attention)
  if not my_data.should_arrest and not my_data.should_stand_close then
    my_data.in_position = true
  end
  local current_attention = l_6_0.unit:movement():attention()
  if (((new_attention and not current_attention) or not current_attention or not new_attention or new_attention and current_attention.u_key ~= new_attention.u_key)) then
    if new_attention then
      CopLogicBase._set_attention(l_6_0, new_attention)
    else
      CopLogicBase._reset_attention(l_6_0)
    end
  end
  if new_reaction ~= AIAttentionObject.REACT_ARREST then
    if (not new_reaction or new_reaction < AIAttentionObject.REACT_SHOOT or not new_attention.verified or new_attention.dis >= 1500) and (my_data.in_position or my_data.should_arrest or not my_data.should_stand_close) then
      if my_data.next_action_delay_t < l_6_0.t and not managers.groupai:state():is_police_called() and not my_data.calling_the_police and not my_data.turning and not l_6_0.unit:sound():speaking(l_6_0.t) then
        CopLogicArrest._call_the_police(l_6_0, my_data, true)
        return 
      end
      if not CopLogicBase._get_logic_state_from_reaction(l_6_0) then
        local wanted_state = (not managers.groupai:state():is_police_called() and not managers.groupai:state():chk_enemy_calling_in_area(managers.groupai:state():get_area_from_nav_seg_id(l_6_0.unit:movement():nav_tracker():nav_segment()), l_6_0.key)) or my_data.calling_the_police or "idle"
      end
      CopLogicBase._exit(l_6_0.unit, wanted_state)
      CopLogicBase._report_detections(l_6_0.detected_attention_objects)
      return 
    else
      local wanted_state = CopLogicBase._get_logic_state_from_reaction(l_6_0)
      if wanted_state and wanted_state ~= l_6_0.name then
        if my_data.calling_the_police then
          local action_data = {type = "idle", body_part = 3}
          l_6_0.unit:brain():action_request(action_data)
        end
        CopLogicBase._exit(l_6_0.unit, wanted_state)
        CopLogicBase._report_detections(l_6_0.detected_attention_objects)
        return 
      end
    end
  end
end

CopLogicArrest._chk_reaction_to_attention_object = function(l_7_0, l_7_1, l_7_2)
  local record = l_7_1.criminal_record
  if not record or not l_7_1.is_person then
    return l_7_1.settings.reaction
  end
  local att_unit = l_7_1.unit
  if l_7_1.is_deployable or l_7_0.t < record.arrest_timeout then
    return math.min(l_7_1.settings.reaction, AIAttentionObject.REACT_SHOOT)
  end
  local can_disarm = not l_7_2
  local can_arrest = CopLogicBase._can_arrest(l_7_0)
  do
    local visible = l_7_1.verified
    if record.status == "disabled" then
      if record.assault_t and record.assault_t - record.disabled_t > 0.60000002384186 then
        return math.min(l_7_1.settings.reaction, AIAttentionObject.REACT_COMBAT)
      end
      return math.min(l_7_1.settings.reaction, AIAttentionObject.REACT_AIM)
    elseif record.being_arrested then
      local my_data = l_7_0.internal_data
      if record.being_arrested[l_7_0.key] then
        return math.min(l_7_1.settings.reaction, AIAttentionObject.REACT_ARREST)
      end
      return math.min(l_7_1.settings.reaction, AIAttentionObject.REACT_AIM)
    end
    if can_arrest and (not record.assault_t or att_unit:base():arrest_settings().aggression_timeout < l_7_0.t - record.assault_t) and record.arrest_timeout < l_7_0.t and not record.status then
      if l_7_1.dis < 2000 and visible then
        return math.min(l_7_1.settings.reaction, AIAttentionObject.REACT_ARREST)
      else
        return math.min(l_7_1.settings.reaction, AIAttentionObject.REACT_AIM)
      end
      return math.min(l_7_1.settings.reaction, AIAttentionObject.REACT_COMBAT)
    end
     -- Warning: missing end command somewhere! Added here
  end
end

CopLogicArrest._verify_arrest_targets = function(l_8_0, l_8_1)
  local all_attention_objects = l_8_0.detected_attention_objects
  local arrest_targets = l_8_1.arrest_targets
  local group_ai = managers.groupai:state()
  for u_key,arrest_data in pairs(arrest_targets) do
    local drop, penalty = nil, nil
    local record = group_ai:criminal_record(u_key)
    if not record then
      do return end
    end
    if arrest_data.intro_pos and mvector3.distance_sq(arrest_data.attention_obj.m_pos, arrest_data.intro_pos) > 28900 then
      drop = true
      penalty = true
    elseif arrest_data.intro_t and record.assault_t and arrest_data.intro_t + 0.60000002384186 < record.assault_t then
      drop = true
      penalty = true
    elseif record.status or l_8_0.t < record.arrest_timeout then
      drop = true
    else
      if all_attention_objects[u_key] ~= arrest_data.attention_obj or not arrest_data.attention_obj.identified then
        drop = true
        if arrest_data.intro_pos then
          penalty = true
        end
      end
    end
    if drop then
      if penalty then
        record.arrest_timeout = l_8_0.t + arrest_data.attention_obj.unit:base():arrest_settings().arrest_timeout
      end
      group_ai:on_arrest_end(l_8_0.key, u_key)
      arrest_targets[u_key] = nil
    end
  end
end

CopLogicArrest.action_complete_clbk = function(l_9_0, l_9_1)
  local my_data = l_9_0.internal_data
  local action_type = l_9_1:type()
  if action_type == "walk" then
    my_data.advancing = nil
    my_data.next_action_delay_t = TimerManager:game():time() + math.lerp(2, 2.5, math.random())
    if my_data.should_stand_close then
      my_data.in_position = true
    elseif action_type == "shoot" then
      my_data.shooting = nil
    elseif action_type == "turn" then
      my_data.turning = nil
    elseif action_type == "act" then
      if my_data.gesture_arrest then
        my_data.gesture_arrest = nil
      elseif my_data.calling_the_police then
        my_data.calling_the_police = nil
      end
      my_data.next_action_delay_t = TimerManager:game():time() + math.lerp(2, 2.5, math.random())
    end
  end
end

CopLogicArrest.damage_clbk = function(l_10_0, l_10_1)
  local my_data = l_10_0.internal_data
  CopLogicIdle.damage_clbk(l_10_0, l_10_1)
  if my_data ~= l_10_0.internal_data then
    return 
  end
  local enemy = l_10_1.attacker_unit
  if enemy then
    for enemy_key,arrest_data in pairs(my_data.arrest_targets) do
      managers.groupai:state():on_arrest_end(l_10_0.key, enemy_key)
      my_data.arrest_targets[enemy_key] = nil
      local record = managers.groupai:state():criminal_record(enemy_key)
      if record then
        record.arrest_timeout = l_10_0.t + arrest_data.attention_obj.unit:base():arrest_settings().arrest_timeout
      end
    end
  end
end

CopLogicArrest.on_detected_enemy_destroyed = function(l_11_0, l_11_1)
end

CopLogicArrest.is_available_for_assignment = function(l_12_0, l_12_1)
  if l_12_1 and l_12_1.forced then
    return true
  end
  return false
end

CopLogicArrest.on_criminal_neutralized = function(l_13_0, l_13_1)
  local record = managers.groupai:state():criminal_record(l_13_1)
  local my_data = l_13_0.internal_data
  if record.status == "dead" or record.status == "removed" then
    if my_data.arrest_targets[l_13_1] then
      managers.groupai:state():on_arrest_end(l_13_0.key, l_13_1)
    end
    my_data.arrest_targets[l_13_1] = nil
  else
    if my_data.arrest_targets[l_13_1] and my_data.arrest_targets[l_13_1].intro_pos then
      my_data.arrest_targets[l_13_1].intro_pos = mvector3.copy(my_data.arrest_targets[l_13_1].attention_obj.m_pos)
      my_data.arrest_targets[l_13_1].intro_t = TimerManager:game():time()
    end
  end
end

CopLogicArrest._call_the_police = function(l_14_0, l_14_1, l_14_2)
  local action = {type = "act", body_part = 1, variant = "arrest_call", blocks = {action = -1, walk = -1, aim = -1}}
  l_14_1.calling_the_police = l_14_0.unit:movement():action_request(action)
  CopLogicArrest._say_call_the_police(l_14_0, l_14_1)
end

CopLogicArrest._get_priority_attention = function(l_15_0, l_15_1, l_15_2)
  if not l_15_2 then
    l_15_2 = CopLogicArrest._chk_reaction_to_attention_object
  end
  local best_target, best_target_priority_slot, best_target_priority, best_target_reaction = nil, nil, nil, nil
  local near_threshold = l_15_0.internal_data.weapon_range.optimal
  do
    local too_close_threshold = l_15_0.internal_data.weapon_range.close
    for u_key,attention_data in pairs(l_15_1) do
      local att_unit = attention_data.unit
      local crim_record = attention_data.criminal_record
      if not attention_data.identified then
        for (for control),u_key in (for generator) do
        end
         -- DECOMPILER ERROR: unhandled construct in 'if'

        if attention_data.pause_expire_t and attention_data.pause_expire_t < l_15_0.t then
          attention_data.pause_expire_t = nil
          for (for control),u_key in (for generator) do
            if attention_data.stare_expire_t and attention_data.stare_expire_t < l_15_0.t and attention_data.settings.pause then
              attention_data.stare_expire_t = nil
              attention_data.pause_expire_t = l_15_0.t + math.lerp(attention_data.settings.pause[1], attention_data.settings.pause[2], math.random())
              for (for control),u_key in (for generator) do
                local distance = mvector3.distance(l_15_0.m_pos, attention_data.m_pos)
                local reaction = (l_15_2(l_15_0, attention_data, not CopLogicAttack._can_move(l_15_0)))
                local reaction_too_mild = nil
                if not reaction or best_target_reaction and reaction < best_target_reaction then
                  reaction_too_mild = true
                elseif distance < 150 and reaction == AIAttentionObject.REACT_IDLE then
                  reaction_too_mild = true
                end
                if not reaction_too_mild then
                  local arrest_targets = l_15_0.internal_data.arrest_targets
                  if reaction == AIAttentionObject.REACT_ARREST and reaction == best_target_reaction and arrest_targets[best_target.u_key] and arrest_targets[best_target.u_key].intro_t and (not arrest_targets[u_key] or not arrest_targets[u_key].intro_t) then
                    best_target = attention_data
                    best_target_reaction = reaction
                    best_target_priority_slot = 7
                    best_target_priority = distance
                    for (for control),u_key in (for generator) do
                    end
                    local alert_dt = attention_data.alert_t and l_15_0.t - attention_data.alert_t or 10000
                    local dmg_dt = attention_data.dmg_t and l_15_0.t - attention_data.dmg_t or 10000
                    if crim_record then
                      local status = crim_record.status
                    end
                    if crim_record then
                      local nr_enemies = crim_record.engaged_force
                    end
                    if l_15_0.attention_obj and l_15_0.attention_obj.u_key == u_key then
                      if alert_dt then
                        alert_dt = alert_dt * 0.80000001192093
                      end
                      if dmg_dt then
                        dmg_dt = dmg_dt * 0.80000001192093
                      end
                      distance = distance * 0.80000001192093
                    end
                    local assault_reaction = reaction == AIAttentionObject.REACT_SPECIAL_ATTACK
                    local visible = attention_data.verified
                    local near = distance < near_threshold
                    local too_near = distance < too_close_threshold and math.abs(attention_data.m_pos.z - l_15_0.m_pos.z) < 250
                    local free_status = status == nil
                    local has_alerted = alert_dt < 3.5
                    local has_damaged = dmg_dt < 5
                    local reviving = nil
                    if attention_data.is_local_player then
                      local iparams = att_unit:movement():current_state()._interact_params
                      if iparams and managers.criminals:character_name_by_unit(iparams.object) ~= nil then
                        reviving = true
                      else
                        if att_unit:anim_data() then
                          reviving = att_unit:anim_data().revive
                        end
                      end
                    end
                    local target_priority = distance
                    local target_priority_slot = 0
                    if visible and not reviving then
                      if free_status then
                        if too_near then
                          target_priority_slot = 1
                        elseif near then
                          target_priority_slot = 2
                        elseif assault_reaction then
                          target_priority_slot = 3
                        else
                          target_priority_slot = 4
                        end
                      elseif has_damaged then
                        if near then
                          target_priority_slot = 3
                        else
                          target_priority_slot = 5
                        end
                      elseif has_alerted then
                        target_priority_slot = 6
                      elseif free_status then
                        target_priority_slot = 7
                      end
                    end
                    if reaction < AIAttentionObject.REACT_COMBAT then
                      target_priority_slot = 10 + target_priority_slot + math.max(0, AIAttentionObject.REACT_COMBAT - reaction)
                    end
                    if target_priority_slot ~= 0 then
                      local best = false
                      if not best_target then
                        best = true
                      elseif target_priority_slot < best_target_priority_slot then
                        best = true
                      elseif target_priority_slot == best_target_priority_slot and target_priority < best_target_priority then
                        best = true
                      end
                      if best then
                        best_target = attention_data
                        best_target_reaction = reaction
                        best_target_priority_slot = target_priority_slot
                        best_target_priority = target_priority
                      end
                    end
                  end
                end
              end
            end
            return best_target, best_target_priority_slot, best_target_reaction
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

CopLogicArrest._process_pathing_results = function(l_16_0, l_16_1)
  if l_16_0.pathing_results then
    for path_id,path in pairs(l_16_0.pathing_results) do
      if path_id == l_16_1.path_search_id then
        if path ~= "failed" then
          l_16_1.advance_path = path
        else
          print("[CopLogicArrest._process_pathing_results] advance path failed")
        end
        l_16_1.processing_path = nil
        l_16_1.path_search_id = nil
      end
    end
    l_16_0.pathing_results = nil
  end
end

CopLogicArrest._cancel_advance = function(l_17_0, l_17_1)
  if l_17_1.processing_path then
    if l_17_0.active_searches[l_17_1.path_search_id] then
      managers.navigation:cancel_pathing_search(l_17_1.path_search_id)
      l_17_0.active_searches[l_17_1.path_search_id] = nil
    elseif l_17_0.pathing_results then
      l_17_0.pathing_results[l_17_1.path_search_id] = nil
    end
    l_17_1.processing_path = nil
    l_17_1.path_search_id = nil
  end
  l_17_1.advance_path = nil
  if l_17_1.advancing then
    local action_data = {type = "idle", body_part = 2}
    l_17_0.unit:brain():action_request(action_data)
  end
  l_17_1.in_position = false
end

CopLogicArrest._get_att_obj_close_pos = function(l_18_0, l_18_1)
  local nav_manager = managers.navigation
  local my_nav_tracker = (l_18_0.unit:movement():nav_tracker())
  local destroy_att_nav_tracker, att_nav_tracker = nil, nil
  if l_18_0.attention_obj.nav_tracker then
    att_nav_tracker = l_18_0.attention_obj.nav_tracker
  else
    destroy_att_nav_tracker = true
    att_nav_tracker = nav_manager:create_nav_tracker(l_18_0.attention_obj.m_pos)
  end
  local att_obj_pos = att_nav_tracker:field_position()
  local attention_dir = Vector3()
  local my_dis = mvector3.direction(attention_dir, my_nav_tracker:field_position(), att_obj_pos)
  local optimal_dis = 250 + math.random() * 150
  if optimal_dis * 0.80000001192093 < my_dis and my_dis < optimal_dis * 1.2000000476837 and nav_manager:is_pos_free({position = my_nav_tracker:field_position(), radius = 40, filter = l_18_0.pos_rsrv_id}) then
    if destroy_att_nav_tracker then
      nav_manager:destroy_nav_tracker(att_nav_tracker)
    end
    return my_nav_tracker:lost() and my_nav_tracker:field_position() or false, false
  end
  local optimal_pos = att_obj_pos - optimal_dis * attention_dir
  local ray_params = {tracker_from = att_nav_tracker, allow_entry = false, pos_to = optimal_pos, trace = true}
  local ray_res = nav_manager:raycast(ray_params)
  if not ray_res and nav_manager:is_pos_free({position = optimal_pos, radius = 40, filter = l_18_0.pos_rsrv_id}) then
    if destroy_att_nav_tracker then
      nav_manager:destroy_nav_tracker(att_nav_tracker)
    end
    return optimal_pos, false
  end
  local hit_pos = ray_params.trace[1]
  local hit_dis = mvector3.distance(hit_pos, att_obj_pos)
  local hit_dis_error = math.abs(optimal_dis - hit_dis)
  local my_error = math.abs(optimal_dis - my_dis)
  if hit_dis_error < my_error and nav_manager:is_pos_free({position = hit_pos, radius = 40, filter = l_18_0.pos_rsrv_id}) then
    if destroy_att_nav_tracker then
      nav_manager:destroy_nav_tracker(att_nav_tracker)
    end
    return hit_pos, true
  end
  local pos_on_wall = CopLogicTravel._get_pos_on_wall(att_obj_pos, optimal_dis, nil, false)
  return pos_on_wall, true
end

CopLogicArrest._say_scary_stuff_discovered = function(l_19_0)
  if not l_19_0.attention_obj then
    return 
  end
  l_19_0.unit:sound():stop()
  l_19_0.unit:sound():say("a07a", true)
end

CopLogicArrest.death_clbk = function(l_20_0, l_20_1)
  local my_data = l_20_0.internal_data
  local attacker_u_key = l_20_1.attacker_unit:key()
  local arrest_data = my_data.arrest_targets[attacker_u_key]
  if arrest_data then
    local record = managers.groupai:state():criminal_record(attacker_u_key)
    if record then
      record.arrest_timeout = l_20_0.t + l_20_1.attacker_unit:base():arrest_settings().arrest_timeout
    end
  end
end

CopLogicArrest._mark_call_in_event = function(l_21_0, l_21_1, l_21_2)
  if not l_21_2 then
    return 
  end
  if l_21_2.reaction == AIAttentionObject.REACT_SCARED then
    if l_21_2.unit:in_slot(17) then
      l_21_1.call_in_event = "corpse"
    else
      if l_21_2.unit:in_slot(managers.slot:get_mask("enemies")) then
        l_21_1.call_in_event = "w_hot"
      else
        if l_21_2.unit:base() and l_21_2.unit:base().is_drill then
          l_21_1.call_in_event = "drill"
        else
          if l_21_2.unit:in_slot(21) then
            l_21_1.call_in_event = "civilian"
            do return end
          else
            if l_21_2.reaction == AIAttentionObject.REACT_ARREST then
              l_21_1.call_in_event = "criminal"
            end
          end
        end
      end
    end
  end
end

CopLogicArrest._chk_say_discovery = function(l_22_0, l_22_1, l_22_2)
  if not l_22_2 then
    return 
  end
  if not l_22_1.discovery_said and l_22_2.reaction == AIAttentionObject.REACT_SCARED then
    l_22_1.discovery_said = true
    l_22_0.unit:sound():say("a07a", true)
  end
end

CopLogicArrest._chk_say_approach = function(l_23_0, l_23_1, l_23_2)
end

CopLogicArrest._say_call_the_police = function(l_24_0, l_24_1)
  local snd_event_name = nil
  if l_24_1.call_in_event == "corpse" then
    snd_event_name = "a11"
  elseif l_24_1.call_in_event == "w_hot" then
    snd_event_name = "a16"
  elseif l_24_1.call_in_event == "drill" then
    snd_event_name = "a25"
  elseif l_24_1.call_in_event == "civilian" then
    snd_event_name = "a11"
  elseif l_24_1.call_in_event == "criminal" then
    snd_event_name = "a23"
  else
    snd_event_name = "a23"
  end
  l_24_0.unit:sound():say(snd_event_name, true)
end


