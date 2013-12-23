-- Decompiled using luadec 2.0.1 by sztupy (http://winmo.sztupy.hu)
-- Command line was: F:\SteamLibrary\SteamApps\common\PAYDAY 2\lua\lib\units\enemies\cop\logics\coplogicguard.luac 

CopLogicGuard = class(CopLogicIdle)
CopLogicGuard.enter = function(l_1_0, l_1_1, l_1_2)
  CopLogicBase.enter(l_1_0, l_1_1, l_1_2)
  l_1_0.unit:brain():cancel_all_pathing_searches()
  local objective = l_1_0.objective
  local guard_obj = objective.guard_obj
  local my_data = {unit = l_1_0.unit}
  my_data.detection = l_1_0.char_tweak.detection.guard
  my_data.rsrv_pos = {}
  my_data.guard_obj = guard_obj
  if guard_obj and guard_obj.type == "door" then
    CopLogicAttack._set_attention_on_pos(l_1_0, guard_obj.door.center + math.UP * 140)
  else
    CopLogicBase._reset_attention(l_1_0)
  end
  if managers.groupai:state():is_nav_seg_safe(guard_obj.from_seg) then
    my_data.from_seg_safe = true
  end
  local old_internal_data = l_1_0.internal_data
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
  my_data.need_turn_check = true
  l_1_0.internal_data = my_data
  my_data.detection_task_key = "CopLogicGuard._upd_enemy_detection" .. tostring(l_1_0.unit:key())
  CopLogicBase.queue_task(my_data, my_data.detection_task_key, CopLogicIdle._upd_enemy_detection, l_1_0, l_1_0.t + 1)
  CopLogicTravel.reset_actions(l_1_0, my_data, old_internal_data, CopLogicTravel.allowed_transitional_actions)
  l_1_0.unit:movement():set_cool(false)
  if my_data ~= l_1_0.internal_data then
    return 
  end
  l_1_0.unit:brain():set_attention_settings({cbt = true})
end

CopLogicGuard.update = function(l_2_0)
  local my_data = l_2_0.internal_data
  local guard_obj = my_data.guard_obj
  if my_data.need_turn_check and not my_data.turning and not l_2_0.unit:movement():chk_action_forbidden("walk") then
    my_data.need_turn_check = CopLogicAttack._chk_request_action_turn_to_enemy(l_2_0, my_data, l_2_0.m_pos, guard_obj.door.center)
  end
  if guard_obj.type == "door" and not my_data.aiming and not my_data.from_seg_safe then
    local shoot_action = {}
    shoot_action.type = "shoot"
    shoot_action.body_part = 3
    CopLogicAttack._set_attention_on_pos(l_2_0, guard_obj.door.center + math.UP * 140)
    if l_2_0.unit:brain():action_request(shoot_action) then
      my_data.aiming = true
    end
  end
  if my_data.from_seg_safe and not my_data.need_turn_check and not my_data.turning then
    CopLogicBase._exit(l_2_0.unit, "idle")
  end
end

CopLogicGuard.action_complete_clbk = function(l_3_0, l_3_1)
  local action_type = l_3_1:type()
  if action_type == "shoot" then
    l_3_0.internal_data.shooting = nil
  elseif action_type == "turn" then
    l_3_0.internal_data.turning = nil
  end
end

CopLogicGuard.on_new_objective = function(l_4_0, l_4_1)
  CopLogicIdle.on_new_objective(l_4_0, l_4_1)
end

CopLogicGuard.on_area_safety = function(l_5_0, l_5_1, l_5_2, l_5_3)
  local objective = l_5_0.objective
  if objective.guard_obj.from_seg == l_5_1 then
    local my_data = l_5_0.internal_data
    if l_5_2 then
      if my_data.need_turn_check or my_data.turning then
        my_data.from_seg_safe = true
      else
        CopLogicBase._exit(l_5_0.unit, "idle")
      end
      managers.groupai:state():on_objective_complete(l_5_0.unit, objective)
    else
      my_data.from_seg_safe = nil
    end
  else
    if l_5_1 == l_5_0.unit:movement():nav_tracker():nav_segment() and not l_5_2 then
      CopLogicBase._exit(l_5_0.unit, "attack")
      do return end
      if l_5_3.reason == "criminal" then
        local new_occupation = managers.groupai:state():verify_occupation_in_area(objective)
        if new_occupation then
          new_occupation.type = "guard"
          local new_objective = {type = "investigate_area", nav_seg = objective.nav_seg, status = "in_progress", guard_obj = new_occupation, scan = true}
          l_5_0.unit:brain():set_objective(new_objective)
        end
      end
    end
  end
end


