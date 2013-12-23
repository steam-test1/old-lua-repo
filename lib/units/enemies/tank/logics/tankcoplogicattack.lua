-- Decompiled using luadec 2.0.1 by sztupy (http://winmo.sztupy.hu)
-- Command line was: F:\SteamLibrary\SteamApps\common\PAYDAY 2\lua\lib\units\enemies\tank\logics\tankcoplogicattack.luac 

TankCopLogicAttack = class(CopLogicAttack)
TankCopLogicAttack.enter = function(l_1_0, l_1_1, l_1_2)
  CopLogicBase.enter(l_1_0, l_1_1, l_1_2)
  local old_internal_data = l_1_0.internal_data
  local my_data = {unit = l_1_0.unit}
  l_1_0.internal_data = my_data
  my_data.detection = l_1_0.char_tweak.detection.combat
  my_data.rsrv_pos = {}
  if old_internal_data and not old_internal_data.rsrv_pos then
    my_data.rsrv_pos = my_data.rsrv_pos
  end
  local key_str = tostring(l_1_0.key)
  my_data.detection_task_key = "CopLogicAttack._upd_enemy_detection" .. key_str
  CopLogicBase.queue_task(my_data, my_data.detection_task_key, CopLogicAttack._upd_enemy_detection, l_1_0)
  CopLogicTravel.reset_actions(l_1_0, my_data, old_internal_data, CopLogicTravel.allowed_transitional_actions)
  my_data.attitude = l_1_0.objective and l_1_0.objective.attitude or "avoid"
  my_data.weapon_range = l_1_0.char_tweak.weapon[l_1_0.unit:inventory():equipped_unit():base():weapon_tweak_data().usage].range
  local upper_body_action = l_1_0.unit:movement()._active_actions[3]
  if not upper_body_action or upper_body_action:type() ~= "shoot" then
    l_1_0.unit:movement():set_stance("hos")
  end
  l_1_0.unit:brain():set_update_enabled_state(false)
  my_data.update_queue_id = "TankCopLogicAttack.queued_update" .. key_str
  TankCopLogicAttack.queue_update(l_1_0, my_data)
  l_1_0.unit:movement():set_cool(false)
  if my_data ~= l_1_0.internal_data then
    return 
  end
  l_1_0.unit:brain():set_attention_settings({cbt = true})
end

TankCopLogicAttack.exit = function(l_2_0, l_2_1, l_2_2)
  CopLogicBase.exit(l_2_0, l_2_1, l_2_2)
  local my_data = l_2_0.internal_data
  TankCopLogicAttack._cancel_chase_attempt(l_2_0, my_data)
  l_2_0.unit:brain():cancel_all_pathing_searches()
  CopLogicBase.cancel_queued_tasks(my_data)
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

TankCopLogicAttack.update = function(l_3_0)
  managers.groupai:state():on_unit_detection_updated(l_3_0.unit)
  local t = l_3_0.t
  local unit = l_3_0.unit
  local my_data = l_3_0.internal_data
  if CopLogicIdle._chk_relocate(l_3_0) then
    return 
  end
  if not l_3_0.attention_obj or l_3_0.attention_obj.reaction < AIAttentionObject.REACT_AIM then
    CopLogicAttack._upd_enemy_detection(l_3_0, true)
    if my_data ~= l_3_0.internal_data or not l_3_0.attention_obj or l_3_0.attention_obj.reaction < AIAttentionObject.REACT_AIM then
      return 
    end
  end
  local focus_enemy = l_3_0.attention_obj
  TankCopLogicAttack._process_pathing_results(l_3_0, my_data)
  local enemy_visible = focus_enemy.verified
  local engage = my_data.attitude == "engage"
  if not my_data.turning and not l_3_0.unit:movement():chk_action_forbidden("walk") then
    local action_taken = my_data.walking_to_chase_pos
  end
  if action_taken then
    return 
  end
  if unit:anim_data().crouch then
    action_taken = CopLogicAttack._chk_request_action_stand(l_3_0)
  end
  if action_taken then
    return 
  end
  if not enemy_visible or not focus_enemy.m_pos then
    local enemy_pos = focus_enemy.verified_pos
  end
  action_taken = CopLogicAttack._chk_request_action_turn_to_enemy(l_3_0, my_data, l_3_0.m_pos, enemy_pos)
  if action_taken then
    return 
  end
  local chase = nil
  local z_dist = math.abs(l_3_0.m_pos.z - focus_enemy.m_pos.z)
  if AIAttentionObject.REACT_COMBAT <= focus_enemy.reaction then
    if enemy_visible then
      if z_dist < 300 or focus_enemy.verified_dis > 2000 or engage and focus_enemy.verified_dis > 500 then
        chase = true
      end
      if focus_enemy.verified_dis < 800 and unit:anim_data().run then
        local new_action = {type = "idle", body_part = 2}
        l_3_0.unit:brain():action_request(new_action)
      elseif z_dist < 300 or focus_enemy.verified_dis > 2000 or engage and (not focus_enemy.verified_t or t - focus_enemy.verified_t > 5 or focus_enemy.verified_dis > 700) then
        chase = true
      end
    end
  end
  if chase then
    if my_data.walking_to_chase_pos then
      do return end
    end
    if my_data.pathing_to_chase_pos then
      do return end
    end
    if my_data.chase_path then
      local dist = focus_enemy.verified_dis
      local run_dist = focus_enemy.verified and 1500 or 800
      local walk = dist < run_dist
      TankCopLogicAttack._chk_request_action_walk_to_chase_pos(l_3_0, my_data, walk and "walk" or "run")
    elseif my_data.chase_pos then
      my_data.chase_path_search_id = tostring(unit:key()) .. "chase"
      my_data.pathing_to_chase_pos = true
      local to_pos = my_data.chase_pos
      my_data.chase_pos = nil
      if my_data.rsrv_pos.path then
        managers.navigation:unreserve_pos(my_data.rsrv_pos.path)
        my_data.rsrv_pos.path = nil
      end
      local reservation = {position = mvector3.copy(to_pos), radius = 70, filter = l_3_0.pos_rsrv_id}
      managers.navigation:add_pos_reservation(reservation)
      my_data.rsrv_pos.path = reservation
      unit:brain():search_for_path(my_data.chase_path_search_id, to_pos)
    elseif focus_enemy.nav_tracker then
      my_data.chase_pos = CopLogicAttack._find_flank_pos(l_3_0, my_data, focus_enemy.nav_tracker)
    else
      TankCopLogicAttack._cancel_chase_attempt(l_3_0, my_data)
    end
  end
end

TankCopLogicAttack.queued_update = function(l_4_0)
  local my_data = l_4_0.internal_data
  my_data.update_queued = false
  l_4_0.t = TimerManager:game():time()
  TankCopLogicAttack.update(l_4_0)
  if my_data == l_4_0.internal_data then
    TankCopLogicAttack.queue_update(l_4_0, l_4_0.internal_data)
  end
end

TankCopLogicAttack._process_pathing_results = function(l_5_0, l_5_1)
  if l_5_0.pathing_results then
    local pathing_results = l_5_0.pathing_results
    l_5_0.pathing_results = nil
    local path = pathing_results[l_5_1.chase_path_search_id]
    if path then
      if path ~= "failed" then
        l_5_1.chase_path = path
      else
        print("[TankCopLogicAttack._process_pathing_results] chase path failed")
      end
      l_5_1.pathing_to_chase_pos = nil
      l_5_1.chase_path_search_id = nil
    end
  end
end

TankCopLogicAttack._cancel_chase_attempt = function(l_6_0, l_6_1)
  l_6_1.chase_path = nil
  if l_6_1.walking_to_chase_pos then
    local new_action = {type = "idle", body_part = 2}
    l_6_0.unit:brain():action_request(new_action)
  elseif l_6_1.pathing_to_chase_pos then
    if l_6_1.rsrv_pos.path then
      managers.navigation:unreserve_pos(l_6_1.rsrv_pos.path)
      l_6_1.rsrv_pos.path = nil
    end
    if l_6_0.active_searches[l_6_1.chase_path_search_id] then
      managers.navigation:cancel_pathing_search(l_6_1.chase_path_search_id)
      l_6_0.active_searches[l_6_1.chase_path_search_id] = nil
    elseif l_6_0.pathing_results then
      l_6_0.pathing_results[l_6_1.chase_path_search_id] = nil
    end
    l_6_1.chase_path_search_id = nil
    l_6_1.pathing_to_chase_pos = nil
    l_6_0.unit:brain():cancel_all_pathing_searches()
  elseif l_6_1.chase_pos then
    l_6_1.chase_pos = nil
  end
end

TankCopLogicAttack.action_complete_clbk = function(l_7_0, l_7_1)
  local action_type = l_7_1:type()
  local my_data = l_7_0.internal_data
  if action_type == "walk" then
    if my_data.rsrv_pos.stand then
      managers.navigation:unreserve_pos(my_data.rsrv_pos.stand)
      my_data.rsrv_pos.stand = nil
    end
    if l_7_1:expired() then
      my_data.rsrv_pos.stand = my_data.rsrv_pos.move_dest
      my_data.rsrv_pos.move_dest = nil
    else
      if my_data.rsrv_pos.move_dest then
        managers.navigation:unreserve_pos(my_data.rsrv_pos.move_dest)
        my_data.rsrv_pos.move_dest = nil
      end
      local reservation = {position = mvector3.copy(l_7_0.m_pos), radius = 70, filter = l_7_0.pos_rsrv_id}
      managers.navigation:add_pos_reservation(reservation)
      my_data.rsrv_pos.stand = reservation
    end
    if my_data.walking_to_chase_pos then
      my_data.walking_to_chase_pos = nil
    elseif action_type == "shoot" then
      my_data.shooting = nil
    elseif action_type == "turn" then
      my_data.turning = nil
    elseif action_type == "hurt" and l_7_1:expired() then
      CopLogicAttack._upd_aim(l_7_0, my_data)
    end
  end
end

TankCopLogicAttack.chk_should_turn = function(l_8_0, l_8_1)
  return (not l_8_1.turning and not l_8_0.unit:movement():chk_action_forbidden("walk") and not l_8_1.surprised and not l_8_1.walking_to_chase_pos)
end

TankCopLogicAttack.queue_update = function(l_9_0, l_9_1)
  l_9_1.update_queued = true
  CopLogicBase.queue_task(l_9_1, l_9_1.update_queue_id, TankCopLogicAttack.queued_update, l_9_0, l_9_0.t + 1.5, l_9_0.important)
end

TankCopLogicAttack._chk_request_action_walk_to_chase_pos = function(l_10_0, l_10_1, l_10_2, l_10_3)
   -- DECOMPILER ERROR: Confused while interpreting a jump as a 'while'

end
local new_action_data = {type = "walk", nav_path = l_10_1.chase_path, variant = l_10_0.unit:movement():chk_action_forbidden("walk") or "run", body_part = 2, end_rot = l_10_3}
l_10_1.chase_path = nil
l_10_1.walking_to_chase_pos = l_10_0.unit:brain():action_request(new_action_data)
if l_10_1.walking_to_chase_pos then
  l_10_1.rsrv_pos.move_dest = l_10_1.rsrv_pos.path
  l_10_1.rsrv_pos.path = nil
  if l_10_1.rsrv_pos.stand then
    managers.navigation:unreserve_pos(l_10_1.rsrv_pos.stand)
    l_10_1.rsrv_pos.stand = nil
  end
end
end

TankCopLogicAttack.is_advancing = function(l_11_0)
  if l_11_0.internal_data.walking_to_chase_pos then
    return l_11_0.internal_data.rsrv_pos.move_dest.position
  end
end

TankCopLogicAttack._get_all_paths = function(l_12_0)
  return {chase_path = l_12_0.internal_data.chase_path}
end

TankCopLogicAttack._set_verified_paths = function(l_13_0, l_13_1)
  l_13_0.internal_data.chase_path = l_13_1.chase_path
end


