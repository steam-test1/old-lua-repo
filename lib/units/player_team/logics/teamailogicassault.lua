-- Decompiled using luadec 2.0.1 by sztupy (http://winmo.sztupy.hu)
-- Command line was: F:\SteamLibrary\SteamApps\common\PAYDAY 2\lua\lib\units\player_team\logics\teamailogicassault.luac 

require("lib/units/enemies/cop/logics/CopLogicAttack")
TeamAILogicAssault = class(CopLogicAttack)
TeamAILogicAssault._COVER_CHK_INTERVAL = 2
TeamAILogicAssault.on_cop_neutralized = TeamAILogicIdle.on_cop_neutralized
TeamAILogicAssault.on_objective_unit_damaged = TeamAILogicIdle.on_objective_unit_damaged
TeamAILogicAssault.on_alert = TeamAILogicIdle.on_alert
TeamAILogicAssault.on_intimidated = TeamAILogicIdle.on_intimidated
TeamAILogicAssault.on_long_dis_interacted = TeamAILogicIdle.on_long_dis_interacted
TeamAILogicAssault.on_new_objective = TeamAILogicIdle.on_new_objective
TeamAILogicAssault.on_objective_unit_destroyed = TeamAILogicBase.on_objective_unit_destroyed
TeamAILogicAssault.is_available_for_assignment = TeamAILogicIdle.is_available_for_assignment
TeamAILogicAssault.clbk_heat = TeamAILogicIdle.clbk_heat
TeamAILogicAssault.enter = function(l_1_0, l_1_1, l_1_2)
  TeamAILogicBase.enter(l_1_0, l_1_1, l_1_2)
  l_1_0.unit:brain():cancel_all_pathing_searches()
  local old_internal_data = l_1_0.internal_data
  local my_data = {unit = l_1_0.unit}
  l_1_0.internal_data = my_data
  my_data.detection = l_1_0.char_tweak.detection.combat
  if not old_internal_data or not old_internal_data.rsrv_pos then
    my_data.rsrv_pos = {}
  end
  my_data.cover_chk_t = l_1_0.t + TeamAILogicAssault._COVER_CHK_INTERVAL
  my_data.weapon_range = l_1_0.char_tweak.weapon[l_1_0.unit:inventory():equipped_unit():base():weapon_tweak_data().usage].range
  if old_internal_data then
    my_data.attention_unit = old_internal_data.attention_unit
    CopLogicAttack._set_best_cover(l_1_0, my_data, old_internal_data.best_cover)
    CopLogicAttack._set_nearest_cover(my_data, old_internal_data.nearest_cover)
  end
  local key_str = tostring(l_1_0.key)
  my_data.detection_task_key = "TeamAILogicAssault._upd_enemy_detection" .. key_str
  CopLogicBase.queue_task(my_data, my_data.detection_task_key, TeamAILogicAssault._upd_enemy_detection, l_1_0, l_1_0.t)
  if l_1_0.objective then
    my_data.attitude = l_1_0.objective.attitude
  end
  l_1_0.unit:movement():set_cool(false)
  l_1_0.unit:movement():set_stance("hos")
  my_data.weapon_range = l_1_0.char_tweak.weapon[l_1_0.unit:inventory():equipped_unit():base():weapon_tweak_data().usage].range
end

TeamAILogicAssault.exit = function(l_2_0, l_2_1, l_2_2)
  TeamAILogicBase.exit(l_2_0, l_2_1, l_2_2)
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
  local rsrv_pos = my_data.rsrv_pos
  if rsrv_pos.path then
    managers.navigation:unreserve_pos(rsrv_pos.path)
    rsrv_pos.path = nil
  end
  if rsrv_pos.move_dest then
    managers.navigation:unreserve_pos(rsrv_pos.move_dest)
    rsrv_pos.move_dest = nil
  end
end

TeamAILogicAssault.update = function(l_3_0)
  local my_data = l_3_0.internal_data
  local t = l_3_0.t
  local unit = l_3_0.unit
  local focus_enemy = l_3_0.attention_obj
  local in_cover = my_data.in_cover
  local best_cover = my_data.best_cover
  CopLogicAttack._process_pathing_results(l_3_0, my_data)
  local focus_enemy = l_3_0.attention_obj
  if not focus_enemy or focus_enemy.reaction < AIAttentionObject.REACT_AIM then
    TeamAILogicAssault._upd_enemy_detection(l_3_0, true)
    if my_data ~= l_3_0.internal_data or not l_3_0.attention_obj or l_3_0.attention_obj.reaction <= AIAttentionObject.REACT_SCARED then
      return 
    end
    focus_enemy = l_3_0.attention_obj
  end
  local enemy_visible = focus_enemy.verified
  if not my_data.turning and not l_3_0.unit:movement():chk_action_forbidden("walk") and not my_data.moving_to_cover and not my_data.walking_to_cover_shoot_pos then
    local action_taken = my_data._turning_to_intimidate
  end
  my_data.want_to_take_cover = CopLogicAttack._chk_wants_to_take_cover(l_3_0, my_data)
  local want_to_take_cover = my_data.want_to_take_cover
  if ((want_to_take_cover and not in_cover) or not in_cover[4] or l_3_0.char_tweak.no_stand and not unit:anim_data().crouch) then
    action_taken = CopLogicAttack._chk_request_action_crouch(l_3_0)
    do return end
    if unit:anim_data().crouch and (not l_3_0.char_tweak.allow_crouch or my_data.cover_test_step > 2) then
      action_taken = CopLogicAttack._chk_request_action_stand(l_3_0)
    end
  end
  local move_to_cover = nil
  if action_taken then
    do return end
  end
  if want_to_take_cover then
    move_to_cover = true
  end
  if not my_data.processing_cover_path and not my_data.cover_path and not my_data.charge_path_search_id and not action_taken and best_cover and (not in_cover or best_cover[1] ~= in_cover[1]) then
    CopLogicAttack._cancel_cover_pathing(l_3_0, my_data)
    local search_id = tostring(unit:key()) .. "cover"
    if l_3_0.unit:brain():search_for_path_to_cover(search_id, best_cover[1], best_cover[5]) then
      my_data.cover_path_search_id = search_id
      my_data.processing_cover_path = best_cover
    end
  end
  if not action_taken and move_to_cover and my_data.cover_path then
    action_taken = CopLogicAttack._chk_request_action_walk_to_cover(l_3_0, my_data)
  end
  if not l_3_0.objective and (not l_3_0.path_fail_t or l_3_0.t - l_3_0.path_fail_t > 6) then
    managers.groupai:state():on_criminal_jobless(unit)
    if my_data ~= l_3_0.internal_data then
      return 
    end
  end
  if my_data.cover_chk_t < l_3_0.t then
    CopLogicAttack._update_cover(l_3_0)
    my_data.cover_chk_t = l_3_0.t + TeamAILogicAssault._COVER_CHK_INTERVAL
  end
end

TeamAILogicAssault._upd_enemy_detection = function(l_4_0, l_4_1)
  managers.groupai:state():on_unit_detection_updated(l_4_0.unit)
  l_4_0.t = TimerManager:game():time()
  local my_data = l_4_0.internal_data
  local max_reaction = nil
  if l_4_0.cool then
    max_reaction = AIAttentionObject.REACT_SURPRISED
  end
  local delay = CopLogicBase._upd_attention_obj_detection(l_4_0, nil, max_reaction)
  local new_attention, new_prio_slot, new_reaction = TeamAILogicIdle._get_priority_attention(l_4_0, l_4_0.detected_attention_objects, nil)
  local old_att_obj = l_4_0.attention_obj
  TeamAILogicBase._set_attention_obj(l_4_0, new_attention, new_reaction)
  TeamAILogicAssault._chk_exit_attack_logic(l_4_0, new_reaction)
  if my_data ~= l_4_0.internal_data then
    return 
  end
  if l_4_0.objective and l_4_0.objective.type == "follow" and TeamAILogicIdle._check_should_relocate(l_4_0, my_data, l_4_0.objective) and not l_4_0.unit:movement():chk_action_forbidden("walk") then
    l_4_0.objective.in_place = nil
    if new_prio_slot and new_prio_slot > 3 then
      l_4_0.objective.called = true
    end
    TeamAILogicBase._exit(l_4_0.unit, "travel")
    return 
  end
  CopLogicAttack._upd_aim(l_4_0, my_data)
  if l_4_0.unit:movement():chk_action_forbidden("walk") or new_prio_slot <= 3 then
    local can_turn = my_data._intimidate_t and my_data._intimidate_t + 2 >= l_4_0.t or my_data._turning_to_intimidate or l_4_0.unit:character_damage():health_ratio() <= 0.5
  end
  local is_assault = managers.groupai:state():get_assault_mode()
  local civ = TeamAILogicIdle.find_civilian_to_intimidate(l_4_0.unit, can_turn and 180 or 60, is_assault and 800 or 1200)
  if civ and (not is_assault or civ:anim_data().run or civ:anim_data().stand) then
    my_data._intimidate_t = l_4_0.t
    if can_turn and CopLogicAttack._chk_request_action_turn_to_enemy(l_4_0, my_data, l_4_0.unit:movement():m_pos(), civ:movement():m_pos()) then
      my_data._turning_to_intimidate = true
      my_data._primary_intimidation_target = civ
    else
      TeamAILogicIdle.intimidate_civilians(l_4_0, l_4_0.unit, true, false)
    end
  end
  if ((TeamAILogicAssault._mark_special_chk_t and TeamAILogicAssault._mark_special_chk_t + 0.75 >= l_4_0.t) or (TeamAILogicAssault._mark_special_t and TeamAILogicAssault._mark_special_t + 6 >= l_4_0.t) or my_data.acting or not l_4_0.unit:sound():speaking()) then
    local nmy = TeamAILogicAssault.find_enemy_to_mark(l_4_0.detected_attention_objects)
    TeamAILogicAssault._mark_special_chk_t = l_4_0.t
    if nmy then
      TeamAILogicAssault._mark_special_t = l_4_0.t
      TeamAILogicAssault.mark_enemy(l_4_0, l_4_0.unit, nmy, true, true)
    end
  end
  TeamAILogicAssault._chk_request_combat_chatter(l_4_0, my_data)
  if not l_4_1 then
    CopLogicBase.queue_task(my_data, my_data.detection_task_key, TeamAILogicAssault._upd_enemy_detection, l_4_0, l_4_0.t + delay)
  end
end

TeamAILogicAssault.find_enemy_to_mark = function(l_5_0)
  local best_nmy, best_nmy_wgt = nil, nil
  for key,attention_info in pairs(l_5_0) do
    if attention_info.identified and (attention_info.verified or attention_info.nearly_visible) and attention_info.is_person and attention_info.char_tweak and attention_info.char_tweak.priority_shout and AIAttentionObject.REACT_COMBAT <= attention_info.reaction and (not best_nmy_wgt or attention_info.verified_dis < best_nmy_wgt) then
      best_nmy_wgt = attention_info.verified_dis
      best_nmy = attention_info.unit
    end
  end
  return best_nmy
end

TeamAILogicAssault.mark_enemy = function(l_6_0, l_6_1, l_6_2, l_6_3, l_6_4)
  if l_6_3 then
    l_6_1:sound():say(tweak_data.character[l_6_2:base()._tweak_table].priority_shout .. "x_any", true)
  end
  if l_6_4 and not l_6_1:movement():chk_action_forbidden("action") then
    local new_action = {type = "act", variant = "arrest", body_part = 3, align_sync = true}
    if l_6_1:brain():action_request(new_action) then
      l_6_0.internal_data.gesture_arrest = true
    end
  end
  managers.game_play_central:add_enemy_contour(l_6_2, false)
  managers.network:session():send_to_peers_synched("mark_enemy", l_6_2, false)
end

TeamAILogicAssault.action_complete_clbk = function(l_7_0, l_7_1)
  local my_data = l_7_0.internal_data
  local action_type = l_7_1:type()
  if action_type == "walk" then
    my_data.rsrv_pos.stand = my_data.rsrv_pos.move_dest
    my_data.rsrv_pos.move_dest = nil
    if my_data.surprised then
      my_data.surprised = false
    elseif my_data.moving_to_cover then
      if l_7_1:expired() then
        my_data.in_cover = my_data.moving_to_cover
        my_data.cover_enter_t = l_7_0.t
        my_data.cover_sideways_chk = nil
      end
      my_data.moving_to_cover = nil
    elseif my_data.walking_to_cover_shoot_pos then
      my_data.walking_to_cover_shoot_pos = nil
    elseif action_type == "shoot" then
      my_data.shooting = nil
    elseif action_type == "turn" then
      my_data.turning = nil
      if my_data._turning_to_intimidate then
        my_data._turning_to_intimidate = nil
        TeamAILogicIdle.intimidate_civilians(l_7_0, l_7_0.unit, true, true, my_data._primary_intimidation_target)
        my_data._primary_intimidation_target = nil
      elseif action_type == "hurt" and l_7_1:expired() then
        CopLogicAttack._upd_aim(l_7_0, my_data)
        do return end
        if action_type == "dodge" then
          CopLogicAttack._upd_aim(l_7_0, my_data)
        end
      end
    end
  end
end

TeamAILogicAssault.damage_clbk = function(l_8_0, l_8_1)
  TeamAILogicIdle.damage_clbk(l_8_0, l_8_1)
end

TeamAILogicAssault.death_clbk = function(l_9_0, l_9_1)
end

TeamAILogicAssault.on_detected_enemy_destroyed = function(l_10_0, l_10_1)
  TeamAILogicIdle.on_cop_neutralized(l_10_0, l_10_1:key())
end

TeamAILogicAssault._chk_request_combat_chatter = function(l_11_0, l_11_1)
  local focus_enemy = l_11_0.attention_obj
  if focus_enemy and focus_enemy.verified and focus_enemy.is_person and AIAttentionObject.REACT_COMBAT <= focus_enemy.reaction and (l_11_1.firing or l_11_0.unit:character_damage():health_ratio() < 1) and not l_11_0.unit:movement():chk_action_forbidden("walk") and not l_11_0.unit:sound():speaking() then
    managers.groupai:state():chk_say_teamAI_combat_chatter(l_11_0.unit)
  end
end

TeamAILogicAssault._chk_exit_attack_logic = function(l_12_0, l_12_1)
  local wanted_state = TeamAILogicBase._get_logic_state_from_reaction(l_12_0, l_12_1)
  if wanted_state ~= l_12_0.name then
    local allow_trans, obj_failed = CopLogicBase.is_obstructed(l_12_0, l_12_0.objective, nil, nil)
    if allow_trans or wanted_state == "idle" then
      if obj_failed then
        managers.groupai:state():on_criminal_objective_failed(l_12_0.unit, l_12_0.objective)
      else
        TeamAILogicBase._exit(l_12_0.unit, wanted_state)
      end
    end
  end
end


