-- Decompiled using luadec 2.0.1 by sztupy (http://winmo.sztupy.hu)
-- Command line was: F:\SteamLibrary\SteamApps\common\PAYDAY 2\lua\lib\units\civilians\logics\civilianlogictravel.luac 

CivilianLogicTravel = class(CopLogicBase)
CivilianLogicTravel.on_alert = CivilianLogicIdle.on_alert
CivilianLogicTravel.on_new_objective = CivilianLogicIdle.on_new_objective
CivilianLogicTravel.action_complete_clbk = CopLogicTravel.action_complete_clbk
CivilianLogicTravel.is_available_for_assignment = CopLogicTravel.is_available_for_assignment
CivilianLogicTravel.enter = function(l_1_0, l_1_1, l_1_2)
  CopLogicBase.enter(l_1_0, l_1_1, l_1_2)
  l_1_0.unit:brain():cancel_all_pathing_searches()
  local old_internal_data = l_1_0.internal_data
  local my_data = {unit = l_1_0.unit}
  l_1_0.internal_data = my_data
  local is_cool = l_1_0.unit:movement():cool()
  if is_cool then
    my_data.detection = l_1_0.char_tweak.detection.ntl
  else
    my_data.detection = l_1_0.char_tweak.detection.cbt
  end
  my_data.rsrv_pos = {}
  if old_internal_data and not old_internal_data.rsrv_pos then
    my_data.rsrv_pos = my_data.rsrv_pos
  end
  l_1_0.unit:brain():set_update_enabled_state(true)
  CivilianLogicEscort._get_objective_path_data(l_1_0, my_data)
  my_data.tmp_vec3 = Vector3()
  local key_str = tostring(l_1_0.key)
  if not l_1_0.been_outlined and l_1_0.char_tweak.outline_on_discover then
    my_data.outline_detection_task_key = "CivilianLogicIdle._upd_outline_detection" .. key_str
    CopLogicBase.queue_task(my_data, my_data.outline_detection_task_key, CivilianLogicIdle._upd_outline_detection, l_1_0, l_1_0.t + 2)
  end
  my_data.detection_task_key = "CivilianLogicTravel_upd_detection" .. key_str
  CopLogicBase.queue_task(my_data, my_data.detection_task_key, CivilianLogicIdle._upd_detection, l_1_0, l_1_0.t + 1)
  if not l_1_0.unit:movement():cool() then
    my_data.registered_as_fleeing = true
    managers.groupai:state():register_fleeing_civilian(l_1_0.key, l_1_0.unit)
  end
  if l_1_0.objective and l_1_0.objective.stance then
    l_1_0.unit:movement():set_stance(l_1_0.objective.stance)
  end
  local attention_settings = nil
  if is_cool then
    attention_settings = {"civ_all_peaceful"}
  else
    if not managers.groupai:state():enemy_weapons_hot() then
      attention_settings = {"civ_enemy_cbt", "civ_civ_cbt"}
      my_data.enemy_weapons_hot_listen_id = "CivilianLogicTravel" .. tostring(l_1_0.key)
      managers.groupai:state():add_listener(my_data.enemy_weapons_hot_listen_id, {"enemy_weapons_hot"}, callback(CivilianLogicIdle, CivilianLogicIdle, "clbk_enemy_weapons_hot", l_1_0))
    end
  end
  l_1_0.unit:brain():set_attention_settings(attention_settings)
end

CivilianLogicTravel.exit = function(l_2_0, l_2_1, l_2_2)
  CopLogicBase.exit(l_2_0, l_2_1, l_2_2)
  local my_data = l_2_0.internal_data
  l_2_0.unit:brain():cancel_all_pathing_searches()
  CopLogicBase.cancel_delayed_clbks(my_data)
  CopLogicBase.cancel_queued_tasks(my_data)
  if my_data.registered_as_fleeing then
    managers.groupai:state():unregister_fleeing_civilian(l_2_0.key)
  end
  if my_data.enemy_weapons_hot_listen_id then
    managers.groupai:state():remove_listener(my_data.enemy_weapons_hot_listen_id)
  end
  if l_2_1 ~= "inactive" then
    l_2_0.unit:brain():set_update_enabled_state(true)
  end
end

CivilianLogicTravel.update = function(l_3_0)
  local my_data = l_3_0.internal_data
  local unit = l_3_0.unit
  local objective = l_3_0.objective
  local t = l_3_0.t
  if my_data.processing_advance_path or my_data.processing_coarse_path then
    CivilianLogicEscort._upd_pathing(l_3_0, my_data)
  elseif my_data.advancing then
    do return end
  end
  if my_data.advance_path then
    CopLogicAttack._correct_path_start_pos(l_3_0, my_data.advance_path)
    local end_rot = nil
    if my_data.coarse_path_index == #my_data.coarse_path - 1 and objective then
      end_rot = objective.rot
    end
    local haste = objective and objective.haste or "walk"
    local new_action_data = {type = "walk", nav_path = my_data.advance_path, variant = haste, body_part = 2, end_rot = end_rot}
    my_data.starting_advance_action = true
    my_data.advancing = l_3_0.unit:brain():action_request(new_action_data)
    my_data.starting_advance_action = false
    if my_data.advancing then
      my_data.advance_path = nil
      my_data.rsrv_pos.move_dest = my_data.rsrv_pos.path
      my_data.rsrv_pos.path = nil
      if my_data.rsrv_pos.stand then
        managers.navigation:unreserve_pos(my_data.rsrv_pos.stand)
        my_data.rsrv_pos.stand = nil
      elseif objective then
        if my_data.coarse_path then
          local coarse_path = my_data.coarse_path
          local cur_index = my_data.coarse_path_index
          local total_nav_points = #coarse_path
          if total_nav_points <= cur_index then
            objective.in_place = true
            if objective.type ~= "escort" and objective.type ~= "act" and not objective.action_duration then
              managers.groupai:state():on_civilian_objective_complete(unit, objective)
            else
              CivilianLogicTravel.on_new_objective(l_3_0)
            end
            return 
          else
            my_data.rsrv_pos.path = nil
            local to_pos = nil
            if objective.pos and cur_index == total_nav_points - 1 then
              to_pos = objective.pos
            else
              to_pos = coarse_path[cur_index + 1][2]
            end
            my_data.advance_path_search_id = tostring(unit:key()) .. "advance"
            my_data.processing_advance_path = true
            unit:brain():search_for_path(my_data.advance_path_search_id, to_pos)
          else
            local search_id = tostring(unit:key()) .. "coarse"
            if unit:brain():search_for_coarse_path(search_id, objective.nav_seg) then
              my_data.coarse_path_search_id = search_id
              my_data.processing_coarse_path = true
            else
              CopLogicBase._exit(l_3_0.unit, "idle")
            end
          end
        end
      end
    end
  end
end

CivilianLogicTravel.on_intimidated = function(l_4_0, l_4_1, l_4_2)
  if not CivilianLogicIdle.is_obstructed(l_4_0, l_4_2) then
    return 
  end
  local new_objective = {type = "surrender", amount = l_4_1, aggressor_unit = l_4_2}
  local anim_data = l_4_0.unit:anim_data()
  if anim_data.run then
    new_objective.initial_act = "halt"
  end
  l_4_0.unit:sound():say("a02x_any", true)
  l_4_0.unit:brain():set_objective(new_objective)
end


