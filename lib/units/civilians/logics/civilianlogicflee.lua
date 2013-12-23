-- Decompiled using luadec 2.0.1 by sztupy (http://winmo.sztupy.hu)
-- Command line was: F:\SteamLibrary\SteamApps\common\PAYDAY 2\lua\lib\units\civilians\logics\civilianlogicflee.luac 

CivilianLogicFlee = class(CopLogicBase)
CivilianLogicFlee.enter = function(l_1_0, l_1_1, l_1_2)
  CopLogicBase.enter(l_1_0, l_1_1, l_1_2)
  l_1_0.unit:brain():cancel_all_pathing_searches()
  local old_internal_data = l_1_0.internal_data
  local my_data = {unit = l_1_0.unit}
  l_1_0.internal_data = my_data
  my_data.detection = l_1_0.char_tweak.detection.cbt
  my_data.rsrv_pos = {}
  if old_internal_data and not old_internal_data.rsrv_pos then
    my_data.rsrv_pos = my_data.rsrv_pos
  end
  l_1_0.unit:brain():set_update_enabled_state(false)
  local key_str = tostring(l_1_0.key)
  managers.groupai:state():register_fleeing_civilian(l_1_0.key, l_1_0.unit)
  my_data.panic_area = managers.groupai:state():get_area_from_nav_seg_id(l_1_0.unit:movement():nav_tracker():nav_segment())
  CivilianLogicFlee.reset_actions(l_1_0)
  if l_1_0.objective then
    if l_1_0.objective.alert_data then
      CivilianLogicFlee.on_alert(l_1_0, l_1_0.objective.alert_data)
      if my_data ~= l_1_0.internal_data then
        return 
      end
      if l_1_0.unit:anim_data().react_enter and not l_1_0.unit:anim_data().idle then
        my_data.delayed_post_react_alert_id = "postreact_alert" .. key_str
        CopLogicBase.add_delayed_clbk(my_data, my_data.delayed_post_react_alert_id, callback(CivilianLogicFlee, CivilianLogicFlee, "post_react_alert_clbk", {data = l_1_0, alert_data = clone(l_1_0.objective.alert_data)}), TimerManager:game():time() + math.lerp(4, 8, math.random()))
      else
        if l_1_0.objective.dmg_info then
          CivilianLogicFlee.damage_clbk(l_1_0, l_1_0.objective.dmg_info)
        end
      end
    end
  end
  l_1_0.unit:movement():set_stance("hos")
  l_1_0.unit:movement():set_cool(false)
  if my_data ~= l_1_0.internal_data then
    return 
  end
  CivilianLogicFlee._chk_add_delayed_rescue_SO(l_1_0, my_data)
  if l_1_0.objective and l_1_0.objective.was_rescued then
    l_1_0.objective.was_rescued = nil
    if CivilianLogicFlee._get_coarse_flee_path(l_1_0) then
      managers.groupai:state():on_civilian_freed()
    end
  end
  if not l_1_0.been_outlined and l_1_0.char_tweak.outline_on_discover then
    my_data.outline_detection_task_key = "CivilianLogicFlee_upd_outline_detection" .. key_str
    CopLogicBase.queue_task(my_data, my_data.outline_detection_task_key, CivilianLogicIdle._upd_outline_detection, l_1_0, l_1_0.t + 2)
  end
  if not my_data.detection_task_key and l_1_0.unit:anim_data().react_enter then
    my_data.detection_task_key = "CivilianLogicFlee._upd_detection" .. key_str
    CopLogicBase.queue_task(my_data, my_data.detection_task_key, CivilianLogicFlee._upd_detection, l_1_0, l_1_0.t + 0)
  end
  local attention_settings = nil
  if not managers.groupai:state():enemy_weapons_hot() then
    attention_settings = {"civ_enemy_cbt", "civ_civ_cbt"}
    my_data.enemy_weapons_hot_listen_id = "CivilianLogicFlee" .. tostring(l_1_0.key)
    managers.groupai:state():add_listener(my_data.enemy_weapons_hot_listen_id, {"enemy_weapons_hot"}, callback(CivilianLogicIdle, CivilianLogicIdle, "clbk_enemy_weapons_hot", l_1_0))
  end
  CivilianLogicFlee.schedule_run_away_clbk(l_1_0)
  if not my_data.delayed_post_react_alert_id and l_1_0.unit:movement():stance_name() == "ntl" then
    my_data.delayed_post_react_alert_id = "postreact_alert" .. key_str
    CopLogicBase.add_delayed_clbk(my_data, my_data.delayed_post_react_alert_id, callback(CivilianLogicFlee, CivilianLogicFlee, "post_react_alert_clbk", {data = l_1_0}), TimerManager:game():time() + math.lerp(4, 8, math.random()))
  end
  l_1_0.unit:brain():set_attention_settings(attention_settings)
  if not managers.groupai:state():is_police_called() then
    my_data.call_police_clbk_id = "civ_call_police" .. key_str
    local call_t = math.max(l_1_0.call_police_delay_t or 0, TimerManager:game():time() + math.lerp(1, 10, math.random()))
    CopLogicBase.add_delayed_clbk(my_data, my_data.call_police_clbk_id, callback(CivilianLogicFlee, CivilianLogicFlee, "clbk_chk_call_the_police", l_1_0), call_t)
  end
  my_data.next_action_t = 0
end

CivilianLogicFlee.exit = function(l_2_0, l_2_1, l_2_2)
  CopLogicBase.exit(l_2_0, l_2_1, l_2_2)
  CopLogicBase._reset_attention(l_2_0)
  local my_data = l_2_0.internal_data
  CivilianLogicFlee._unregister_rescue_SO(l_2_0, my_data)
  l_2_0.unit:brain():cancel_all_pathing_searches()
  CopLogicBase.cancel_delayed_clbks(my_data)
  managers.groupai:state():unregister_fleeing_civilian(l_2_0.key)
  CopLogicBase.cancel_queued_tasks(my_data)
  if my_data.best_cover then
    managers.navigation:release_cover(my_data.best_cover[1])
  end
  if my_data.nearest_cover then
    managers.navigation:release_cover(my_data.nearest_cover[1])
  end
  if my_data.enemy_weapons_hot_listen_id then
    managers.groupai:state():remove_listener(my_data.enemy_weapons_hot_listen_id)
  end
end

CivilianLogicFlee.update = function(l_3_0)
  local exit_state = nil
  local unit = l_3_0.unit
  local my_data = l_3_0.internal_data
  local objective = l_3_0.objective
  local t = l_3_0.t
  if my_data.calling_the_police then
    do return end
  end
  if my_data.flee_path_search_id or my_data.coarse_path_search_id then
    CivilianLogicFlee._update_pathing(l_3_0, my_data)
  elseif my_data.flee_path and not unit:movement():chk_action_forbidden("walk") then
    CivilianLogicFlee._start_moving_to_cover(l_3_0, my_data)
    do return end
    if my_data.coarse_path and not my_data.advancing and my_data.next_action_t < l_3_0.t then
      local coarse_path = my_data.coarse_path
      local cur_index = my_data.coarse_path_index
      local total_nav_points = #coarse_path
      if cur_index == total_nav_points then
        if l_3_0.unit:unit_data().mission_element then
          l_3_0.unit:unit_data().mission_element:event("fled", l_3_0.unit)
        end
        managers.secret_assignment:civilian_escaped()
        l_3_0.unit:base():set_slot(unit, 0)
      else
        local to_pos, to_cover = nil, nil
        if cur_index == total_nav_points - 1 then
          to_pos = my_data.flee_target.pos
        else
          local next_area = managers.groupai:state():get_area_from_nav_seg_id(coarse_path[cur_index + 1][1])
          local cover = managers.navigation:find_cover_in_nav_seg_1(managers.navigation, next_area.nav_segs)
          if cover then
            CopLogicAttack._set_best_cover(l_3_0, my_data, {cover})
            to_cover = my_data.best_cover
          else
            to_pos = CopLogicTravel._get_pos_on_wall(coarse_path[cur_index + 1][2], 700)
          end
        end
        my_data.flee_path_search_id = "civ_flee" .. tostring(l_3_0.key)
        if to_cover then
          my_data.pathing_to_cover = to_cover
          unit:brain():search_for_path_to_cover(my_data.flee_path_search_id, to_cover[1], nil, nil)
        do
          else
            local reservation = managers.navigation:reserve_pos(nil, nil, to_pos, nil, 30, l_3_0.pos_rsrv_id)
            my_data.rsrv_pos.path = reservation
            unit:brain():search_for_path(my_data.flee_path_search_id, to_pos)
          end
          do return end
          if my_data.best_cover then
            local best_cover = my_data.best_cover
            if not my_data.moving_to_cover or my_data.moving_to_cover ~= best_cover then
              if my_data.in_cover and my_data.in_cover == best_cover then
                do return end
              end
              if not unit:anim_data().panic then
                local action_data = {type = "act", body_part = 1, variant = "panic", clamp_to_graph = true}
                l_3_0.unit:brain():action_request(action_data)
                l_3_0.unit:brain():set_update_enabled_state(true)
                CopLogicBase._reset_attention(l_3_0)
              end
              my_data.pathing_to_cover = my_data.best_cover
              local search_id = "civ_cover" .. tostring(l_3_0.key)
              my_data.flee_path_search_id = search_id
              l_3_0.unit:brain():search_for_path_to_cover(search_id, my_data.best_cover[1])
            end
          end
        end
      end
    end
  end
end

CivilianLogicFlee._upd_detection = function(l_4_0)
  local my_data = l_4_0.internal_data
  if my_data.advancing or not l_4_0.unit:anim_data().react and not l_4_0.unit:anim_data().react_enter then
    my_data.detection_task_key = nil
    CopLogicBase._reset_attention(l_4_0)
    return 
  end
  managers.groupai:state():on_unit_detection_updated(l_4_0.unit)
  l_4_0.t = TimerManager:game():time()
  local delay = CopLogicBase._upd_attention_obj_detection(l_4_0, nil, nil)
  local new_attention, new_reaction = CivilianLogicIdle._get_priority_attention(l_4_0, l_4_0.detected_attention_objects)
  CivilianLogicIdle._set_attention_obj(l_4_0, new_attention, new_reaction)
  if not managers.groupai:state():is_police_called() then
    CopLogicArrest._mark_call_in_event(l_4_0, my_data, new_attention)
  end
  if not my_data.flee_target then
    CivilianLogicFlee._chk_add_delayed_rescue_SO(l_4_0, my_data)
  end
  delay = delay * 3
  CopLogicBase.queue_task(my_data, my_data.detection_task_key, CivilianLogicFlee._upd_detection, l_4_0, l_4_0.t + delay)
end

CivilianLogicFlee._update_pathing = function(l_5_0, l_5_1)
  if l_5_0.pathing_results then
    local pathing_results = l_5_0.pathing_results
    l_5_0.pathing_results = nil
    l_5_1.has_cover_path = nil
    if l_5_1.flee_path_search_id then
      local path = pathing_results[l_5_1.flee_path_search_id]
    end
    if path then
      if path ~= "failed" then
        l_5_1.flee_path = path
        if l_5_1.pathing_to_cover then
          l_5_1.has_path_to_cover = l_5_1.pathing_to_cover
      end
      l_5_1.pathing_to_cover = nil
      l_5_1.flee_path_search_id = nil
    end
  end
end

CivilianLogicFlee.action_complete_clbk = function(l_6_0, l_6_1)
  local my_data = l_6_0.internal_data
  if l_6_1:type() == "walk" then
    my_data.next_action_t = TimerManager:game():time() + math.lerp(2, 8, math.random())
    if l_6_1:expired() then
      my_data.rsrv_pos.stand = my_data.rsrv_pos.move_dest
      my_data.rsrv_pos.move_dest = nil
      if my_data.moving_to_cover then
        l_6_0.unit:sound():say("a03x_any", true)
        my_data.in_cover = my_data.moving_to_cover
        CopLogicAttack._set_nearest_cover(my_data, my_data.in_cover)
        CivilianLogicFlee._chk_add_delayed_rescue_SO(l_6_0, my_data)
      end
      if my_data.coarse_path_index then
        my_data.coarse_path_index = my_data.coarse_path_index + 1
      else
        if my_data.rsrv_pos.move_dest then
          if not my_data.rsrv_pos.stand then
            my_data.rsrv_pos.stand = managers.navigation:add_pos_reservation({position = mvector3.copy(l_6_0.m_pos), radius = 45, filter = l_6_0.pos_rsrv_id})
          end
          managers.navigation:unreserve_pos(my_data.rsrv_pos.move_dest)
          my_data.rsrv_pos.move_dest = nil
        end
      end
    end
    my_data.moving_to_cover = nil
    my_data.advancing = nil
    if not my_data.coarse_path_index then
      l_6_0.unit:brain():set_update_enabled_state(false)
    else
      if l_6_1:type() == "act" and my_data.calling_the_police then
        my_data.calling_the_police = nil
      end
    end
  end
end

CivilianLogicFlee.on_alert = function(l_7_0, l_7_1)
  local my_data = l_7_0.internal_data
  if my_data.coarse_path then
    return 
  end
  if CopLogicBase.is_alert_aggressive(l_7_1[1]) then
    local aggressor = l_7_1[5]
    if aggressor and aggressor:base() then
      local is_intimidation = nil
      if aggressor:base().is_local_player and managers.player:has_category_upgrade("player", "civ_calming_alerts") then
        is_intimidation = true
        do return end
        if aggressor:base().is_husk_player and aggressor:base():upgrade_value("player", "civ_calming_alerts") then
          is_intimidation = true
        end
      end
      if is_intimidation then
        l_7_0.unit:brain():on_intimidated(1, aggressor)
        return 
      end
    end
  end
  local anim_data = l_7_0.unit:anim_data()
  if anim_data.react_enter and not anim_data.idle then
    if not my_data.delayed_post_react_alert_id then
      my_data.delayed_post_react_alert_id = "postreact_alert" .. tostring(l_7_0.key)
      CopLogicBase.add_delayed_clbk(my_data, my_data.delayed_post_react_alert_id, callback(CivilianLogicFlee, CivilianLogicFlee, "post_react_alert_clbk", {data = l_7_0, alert_data = clone(l_7_1)}), TimerManager:game():time() + 1)
    end
    return 
  elseif anim_data.peaceful or l_7_0.unit:movement():stance_name() == "ntl" then
    local action_data = {type = "act", body_part = 1, variant = "panic", clamp_to_graph = true}
    l_7_0.unit:brain():action_request(action_data)
    l_7_0.unit:sound():say("a01x_any", true)
    if l_7_0.unit:unit_data().mission_element then
      l_7_0.unit:unit_data().mission_element:event("panic", l_7_0.unit)
    end
    if not managers.groupai:state():enemy_weapons_hot() then
      local alert = {"vo_distress", l_7_0.unit:movement():m_head_pos(), 200, l_7_0.SO_access, l_7_0.unit}
      managers.groupai:state():propagate_alert(alert)
    end
    return 
  elseif l_7_1[1] ~= "bullet" and l_7_1[1] ~= "aggression" then
    return 
  elseif anim_data.react or anim_data.drop then
    local action_data = {type = "act", body_part = 1, variant = "panic", clamp_to_graph = true}
    l_7_0.unit:brain():action_request(action_data)
    local is_dangerous = CopLogicBase.is_alert_dangerous(l_7_1[1])
    if is_dangerous then
      l_7_0.unit:sound():say("a01x_any", true)
    end
    if l_7_0.unit:unit_data().mission_element then
      l_7_0.unit:unit_data().mission_element:event("panic", l_7_0.unit)
    end
    CopLogicBase._reset_attention(l_7_0)
    if is_dangerous and not managers.groupai:state():enemy_weapons_hot() then
      local alert = {"vo_distress", l_7_0.unit:movement():m_head_pos(), 200, l_7_0.SO_access, l_7_0.unit}
      managers.groupai:state():propagate_alert(alert)
    end
    return 
  end
  CivilianLogicFlee._run_away_from_alert(l_7_0, l_7_1)
end

CivilianLogicFlee._run_away_from_alert = function(l_8_0, l_8_1)
  local my_data = l_8_0.internal_data
  local avoid_pos = nil
  if l_8_1[1] == "bullet" then
    local tail = l_8_1[2]
    local head = l_8_1[6]
    local alert_dir = head - tail
    local alert_len = mvector3.normalize(alert_dir)
    avoid_pos = l_8_0.m_pos - tail
    local my_dot = mvector3.dot(alert_dir, avoid_pos)
    mvector3.set(avoid_pos, alert_dir)
    mvector3.multiply(avoid_pos, my_dot)
    mvector3.add(avoid_pos, tail)
  elseif not l_8_1[2] and (not l_8_1[5] or not l_8_1[5]:position()) then
    avoid_pos = math.UP:random_orthogonal() * 100 + l_8_0.m_pos
  end
  my_data.avoid_pos = avoid_pos
  if not my_data.cover_search_task_key then
    my_data.cover_search_task_key = "CivilianLogicFlee._find_hide_cover" .. tostring(l_8_0.key)
    CopLogicBase.queue_task(my_data, my_data.cover_search_task_key, CivilianLogicFlee._find_hide_cover, l_8_0, l_8_0.t + 0.5)
  end
end

CivilianLogicFlee.post_react_alert_clbk = function(l_9_0, l_9_1)
  local data = l_9_1.data
  local alert_data = l_9_1.alert_data
  local my_data = data.internal_data
  local anim_data = data.unit:anim_data()
  CopLogicBase.on_delayed_clbk(my_data, my_data.delayed_post_react_alert_id)
   -- DECOMPILER ERROR: Confused while interpreting a jump as a 'while'

end
CopLogicBase.add_delayed_clbk(my_data, my_data.delayed_post_react_alert_id, callback(CivilianLogicFlee, CivilianLogicFlee, "post_react_alert_clbk", {data = data, alert_data = not anim_data.react_enter or alert_data}), TimerManager:game():time() + 1)
return 
my_data.delayed_post_react_alert_id = nil
if not anim_data.react then
  return 
end
if alert_data and alive(alert_data[5]) then
  CivilianLogicFlee._run_away_from_alert(data, alert_data)
  return 
end
if anim_data.react or anim_data.drop then
  local action_data = {type = "act", body_part = 1, variant = "panic", clamp_to_graph = true}
  data.unit:brain():action_request(action_data)
  data.unit:sound():say("a01x_any", true)
  if data.unit:unit_data().mission_element then
    data.unit:unit_data().mission_element:event("panic", data.unit)
  end
  CopLogicBase._reset_attention(data)
  if not managers.groupai:state():enemy_weapons_hot() then
    local alert = {"vo_distress", data.unit:movement():m_head_pos(), 200, data.SO_access, data.unit}
    managers.groupai:state():propagate_alert(alert)
  end
  return 
end
CopLogicBase.add_delayed_clbk(my_data, my_data.delayed_post_react_alert_id, callback(CivilianLogicFlee, CivilianLogicFlee, "post_react_alert_clbk", {data = data, alert_data = data.objective and data.objective.alert_data and clone(data.objective.alert_data) or alert_data}), TimerManager:game():time() + 1)
end

CivilianLogicFlee._flee_coarse_path_verify_clbk = function(l_10_0, l_10_1)
  return managers.groupai:state():is_nav_seg_safe(l_10_1)
end

CivilianLogicFlee.on_intimidated = function(l_11_0, l_11_1, l_11_2)
  if not l_11_0.char_tweak.intimidateable or l_11_0.unit:base().unintimidateable or l_11_0.unit:anim_data().unintimidateable then
    return 
  end
  local my_data = l_11_0.internal_data
  if not my_data.delayed_intimidate_id then
    my_data.delayed_intimidate_id = "intimidate" .. tostring(l_11_0.key)
    local delay = 1 - l_11_1 + math.random() * 0.20000000298023
    CopLogicBase.add_delayed_clbk(my_data, my_data.delayed_intimidate_id, callback(CivilianLogicFlee, CivilianLogicFlee, "_delayed_intimidate_clbk", {l_11_0, l_11_1, l_11_2}), TimerManager:game():time() + delay)
  end
end

CivilianLogicFlee._delayed_intimidate_clbk = function(l_12_0, l_12_1)
  local data = l_12_1[1]
  local my_data = data.internal_data
  CopLogicBase.on_delayed_clbk(my_data, my_data.delayed_intimidate_id)
  my_data.delayed_intimidate_id = nil
  if not alive(l_12_1[3]) then
    return 
  end
  CivilianLogicIdle.on_intimidated(data, l_12_1[2], l_12_1[3])
end

CivilianLogicFlee._cancel_pathing = function(l_13_0, l_13_1)
  l_13_0.unit:brain():cancel_all_pathing_searches()
  l_13_1.pathing_to_cover = nil
  l_13_1.has_path_to_cover = nil
  l_13_1.coarse_path_search_id = nil
  l_13_1.coarse_search_failed = nil
  l_13_1.coarse_path = nil
  l_13_1.flee_target = nil
  l_13_1.coarse_path_index = nil
end

CivilianLogicFlee._find_hide_cover = function(l_14_0)
  local my_data = l_14_0.internal_data
  my_data.cover_search_task_key = nil
  if l_14_0.unit:anim_data().dont_flee then
    return 
  end
  local avoid_pos = nil
  if my_data.avoid_pos then
    avoid_pos = my_data.avoid_pos
  elseif l_14_0.attention_obj and AIAttentionObject.REACT_SCARED <= l_14_0.attention_obj.reaction then
    avoid_pos = l_14_0.attention_obj.m_pos
  else
    local closest_crim, closest_crim_dis = nil, nil
    for u_key,att_data in pairs(l_14_0.detected_attention_objects) do
      if not closest_crim_dis or att_data.dis < closest_crim_dis then
        closest_crim = att_data
        closest_crim_dis = att_data.dis
      end
    end
    if closest_crim then
      avoid_pos = closest_crim.m_pos
    else
      avoid_pos = Vector3()
      mvector3.random_orthogonal(avoid_pos, math.UP)
      mvector3.multiply(avoid_pos, 100)
      mvector3.add(l_14_0.m_pos, 100)
    end
  end
  if my_data.best_cover then
    local best_cover_vec = avoid_pos - my_data.best_cover[1][1]
    if mvector3.dot(best_cover_vec, my_data.best_cover[1][2]) > 0.69999998807907 then
      return 
    end
  end
  local cover = managers.navigation:find_cover_away_from_pos(l_14_0.m_pos, avoid_pos, my_data.panic_area.nav_segs)
  if cover then
    if not l_14_0.unit:anim_data().panic then
      local action_data = {type = "act", body_part = 1, variant = "panic", clamp_to_graph = true}
      l_14_0.unit:brain():action_request(action_data)
    end
    CivilianLogicFlee._cancel_pathing(l_14_0, my_data)
    CopLogicAttack._set_best_cover(l_14_0, my_data, {cover})
    l_14_0.unit:brain():set_update_enabled_state(true)
    CopLogicBase._reset_attention(l_14_0)
  else
    if l_14_0.unit:anim_data().react or l_14_0.unit:anim_data().halt then
      local action_data = {type = "act", body_part = 1, variant = "panic", clamp_to_graph = true}
      l_14_0.unit:brain():action_request(action_data)
      l_14_0.unit:sound():say("a02x_any", true)
      if l_14_0.unit:unit_data().mission_element then
        l_14_0.unit:unit_data().mission_element:event("panic", l_14_0.unit)
      end
      CopLogicBase._reset_attention(l_14_0)
      if not managers.groupai:state():enemy_weapons_hot() then
        local alert = {"vo_distress", l_14_0.unit:movement():m_head_pos(), 200, l_14_0.SO_access, l_14_0.unit}
        managers.groupai:state():propagate_alert(alert)
      end
    end
  end
end

CivilianLogicFlee._start_moving_to_cover = function(l_15_0, l_15_1)
  l_15_0.unit:sound():say("a03x_any", true)
  CivilianLogicFlee._unregister_rescue_SO(l_15_0, l_15_1)
  CopLogicAttack._correct_path_start_pos(l_15_0, l_15_1.flee_path)
  CopLogicBase._reset_attention(l_15_0)
  local new_action_data = {type = "walk", nav_path = l_15_1.flee_path, variant = "run", body_part = 2}
  l_15_1.advancing = l_15_0.unit:brain():action_request(new_action_data)
  l_15_1.flee_path = nil
  if l_15_1.has_path_to_cover then
    l_15_1.moving_to_cover = l_15_1.has_path_to_cover
    l_15_1.has_path_to_cover = nil
  end
  l_15_1.rsrv_pos.move_dest = l_15_1.rsrv_pos.path
  l_15_1.rsrv_pos.path = nil
  if l_15_1.rsrv_pos.stand then
    managers.navigation:unreserve_pos(l_15_1.rsrv_pos.stand)
    l_15_1.rsrv_pos.stand = nil
  end
end

CivilianLogicFlee._add_delayed_rescue_SO = function(l_16_0, l_16_1)
  if l_16_1.rescue_active then
    return 
  end
  if l_16_0.char_tweak.flee_type ~= "hide" then
    if l_16_0.unit:unit_data() and l_16_0.unit:unit_data().not_rescued then
      do return end
    end
    if l_16_1.delayed_clbks and l_16_1.delayed_clbks[l_16_1.delayed_rescue_SO_id] then
      managers.enemy:reschedule_delayed_clbk(l_16_1.delayed_rescue_SO_id, TimerManager:game():time() + 1)
    elseif l_16_1.rescuer then
      local objective = l_16_1.rescuer:brain():objective()
      local rescuer = l_16_1.rescuer
      l_16_1.rescuer = nil
      managers.groupai:state():on_objective_failed(rescuer, objective)
    elseif l_16_1.rescue_SO_id then
      managers.groupai:state():remove_special_objective(l_16_1.rescue_SO_id)
      l_16_1.rescue_SO_id = nil
    end
    l_16_1.delayed_rescue_SO_id = "rescue" .. tostring(l_16_0.key)
    CopLogicBase.add_delayed_clbk(l_16_1, l_16_1.delayed_rescue_SO_id, callback(CivilianLogicFlee, CivilianLogicFlee, "register_rescue_SO", l_16_0), TimerManager:game():time() + 1)
  end
  l_16_1.rescue_active = true
end

CivilianLogicFlee.register_rescue_SO = function(l_17_0, l_17_1)
  local my_data = l_17_1.internal_data
  CopLogicBase.on_delayed_clbk(my_data, my_data.delayed_rescue_SO_id)
  my_data.delayed_rescue_SO_id = nil
  if l_17_1.unit:anim_data().dont_flee then
    return 
  end
  local my_tracker = l_17_1.unit:movement():nav_tracker()
  local objective_pos = my_tracker:field_position()
  local followup_objective = {type = "act", stance = "hos", scan = true, action = {type = "act", variant = "idle", body_part = 1, blocks = {action = -1, walk = -1}}, action_duration = tweak_data.interaction.free.timer}
  local side = l_17_1.unit:movement():m_rot():x()
  mvector3.multiply(side, 65)
  local test_pos = mvector3.copy(objective_pos)
  mvector3.add(test_pos, side)
  local so_pos, so_rot = nil, nil
  local ray_params = {tracker_from = l_17_1.unit:movement():nav_tracker(), pos_to = test_pos, allow_entry = false, trace = true}
  if not managers.navigation:raycast(ray_params) then
    so_pos = test_pos
    so_rot = Rotation(-side, math.UP)
  else
    test_pos = mvector3.copy(objective_pos)
    mvector3.subtract(test_pos, side)
    ray_params.pos_to = test_pos
    if not managers.navigation:raycast(ray_params) then
      so_pos = test_pos
      so_rot = Rotation(side, math.UP)
    else
      so_pos = mvector3.copy(objective_pos)
      so_rot = nil
    end
    {type = "act", follow_unit = l_17_1.unit, pos = so_pos, rot = so_rot, destroy_clbk_key = false, interrupt_dis = 700, interrupt_health = 0.75, stance = "hos", scan = true, nav_seg = l_17_1.unit:movement():nav_tracker():nav_segment(), fail_clbk = callback(CivilianLogicFlee, CivilianLogicFlee, "on_rescue_SO_failed", l_17_1), complete_clbk = callback(CivilianLogicFlee, CivilianLogicFlee, "on_rescue_SO_completed", l_17_1), action = {type = "act", variant = "untie", body_part = 1, blocks = {action = -1, walk = -1}}, action_duration = tweak_data.interaction.free.timer}.followup_objective = followup_objective
     -- DECOMPILER ERROR: Confused at declaration of local variable

     -- DECOMPILER ERROR: Confused about usage of registers!

     -- DECOMPILER ERROR: Confused at declaration of local variable

     -- DECOMPILER ERROR: Confused about usage of registers!

     -- DECOMPILER ERROR: Confused about usage of registers!

     -- DECOMPILER ERROR: Confused about usage of registers!

     -- DECOMPILER ERROR: Confused about usage of registers!

     -- DECOMPILER ERROR: Confused about usage of registers!

     -- DECOMPILER ERROR: Confused about usage of registers!

    {objective = {type = "act", follow_unit = l_17_1.unit, pos = so_pos, rot = so_rot, destroy_clbk_key = false, interrupt_dis = 700, interrupt_health = 0.75, stance = "hos", scan = true, nav_seg = l_17_1.unit:movement():nav_tracker():nav_segment(), fail_clbk = callback(CivilianLogicFlee, CivilianLogicFlee, "on_rescue_SO_failed", l_17_1), complete_clbk = callback(CivilianLogicFlee, CivilianLogicFlee, "on_rescue_SO_completed", l_17_1), action = {type = "act", variant = "untie", body_part = 1, blocks = {action = -1, walk = -1}}, action_duration = tweak_data.interaction.free.timer}, base_chance = 1, chance_inc = 0, interval = 10}.verification_clbk, {objective = {type = "act", follow_unit = l_17_1.unit, pos = so_pos, rot = so_rot, destroy_clbk_key = false, interrupt_dis = 700, interrupt_health = 0.75, stance = "hos", scan = true, nav_seg = l_17_1.unit:movement():nav_tracker():nav_segment(), fail_clbk = callback(CivilianLogicFlee, CivilianLogicFlee, "on_rescue_SO_failed", l_17_1), complete_clbk = callback(CivilianLogicFlee, CivilianLogicFlee, "on_rescue_SO_completed", l_17_1), action = {type = "act", variant = "untie", body_part = 1, blocks = {action = -1, walk = -1}}, action_duration = tweak_data.interaction.free.timer}, base_chance = 1, chance_inc = 0, interval = 10}.admin_clbk, {objective = {type = "act", follow_unit = l_17_1.unit, pos = so_pos, rot = so_rot, destroy_clbk_key = false, interrupt_dis = 700, interrupt_health = 0.75, stance = "hos", scan = true, nav_seg = l_17_1.unit:movement():nav_tracker():nav_segment(), fail_clbk = callback(CivilianLogicFlee, CivilianLogicFlee, "on_rescue_SO_failed", l_17_1), complete_clbk = callback(CivilianLogicFlee, CivilianLogicFlee, "on_rescue_SO_completed", l_17_1), action = {type = "act", variant = "untie", body_part = 1, blocks = {action = -1, walk = -1}}, action_duration = tweak_data.interaction.free.timer}, base_chance = 1, chance_inc = 0, interval = 10}.AI_group, {objective = {type = "act", follow_unit = l_17_1.unit, pos = so_pos, rot = so_rot, destroy_clbk_key = false, interrupt_dis = 700, interrupt_health = 0.75, stance = "hos", scan = true, nav_seg = l_17_1.unit:movement():nav_tracker():nav_segment(), fail_clbk = callback(CivilianLogicFlee, CivilianLogicFlee, "on_rescue_SO_failed", l_17_1), complete_clbk = callback(CivilianLogicFlee, CivilianLogicFlee, "on_rescue_SO_completed", l_17_1), action = {type = "act", variant = "untie", body_part = 1, blocks = {action = -1, walk = -1}}, action_duration = tweak_data.interaction.free.timer}, base_chance = 1, chance_inc = 0, interval = 10}.usage_amount, {objective = {type = "act", follow_unit = l_17_1.unit, pos = so_pos, rot = so_rot, destroy_clbk_key = false, interrupt_dis = 700, interrupt_health = 0.75, stance = "hos", scan = true, nav_seg = l_17_1.unit:movement():nav_tracker():nav_segment(), fail_clbk = callback(CivilianLogicFlee, CivilianLogicFlee, "on_rescue_SO_failed", l_17_1), complete_clbk = callback(CivilianLogicFlee, CivilianLogicFlee, "on_rescue_SO_completed", l_17_1), action = {type = "act", variant = "untie", body_part = 1, blocks = {action = -1, walk = -1}}, action_duration = tweak_data.interaction.free.timer}, base_chance = 1, chance_inc = 0, interval = 10}.search_pos, {objective = {type = "act", follow_unit = l_17_1.unit, pos = so_pos, rot = so_rot, destroy_clbk_key = false, interrupt_dis = 700, interrupt_health = 0.75, stance = "hos", scan = true, nav_seg = l_17_1.unit:movement():nav_tracker():nav_segment(), fail_clbk = callback(CivilianLogicFlee, CivilianLogicFlee, "on_rescue_SO_failed", l_17_1), complete_clbk = callback(CivilianLogicFlee, CivilianLogicFlee, "on_rescue_SO_completed", l_17_1), action = {type = "act", variant = "untie", body_part = 1, blocks = {action = -1, walk = -1}}, action_duration = tweak_data.interaction.free.timer}, base_chance = 1, chance_inc = 0, interval = 10}.search_dis_sq = callback(CivilianLogicFlee, CivilianLogicFlee, "rescue_SO_verification", managers.groupai:state():get_areas_from_nav_seg_id(({type = "act", follow_unit = l_17_1.unit, pos = so_pos, rot = so_rot, destroy_clbk_key = false, interrupt_dis = 700, interrupt_health = 0.75, stance = "hos", scan = true, nav_seg = l_17_1.unit:movement():nav_tracker():nav_segment(), fail_clbk = callback(CivilianLogicFlee, CivilianLogicFlee, "on_rescue_SO_failed", l_17_1), complete_clbk = callback(CivilianLogicFlee, CivilianLogicFlee, "on_rescue_SO_completed", l_17_1), action = {type = "act", variant = "untie", body_part = 1, blocks = {action = -1, walk = -1}}, action_duration = tweak_data.interaction.free.timer}).nav_seg)), callback(CivilianLogicFlee, CivilianLogicFlee, "on_rescue_SO_administered", l_17_1), "enemies", 1, mvector3.copy(l_17_1.m_pos), 25000000
     -- DECOMPILER ERROR: Confused at declaration of local variable

    do
       -- DECOMPILER ERROR: Confused at declaration of local variable

      my_data.rescue_SO_id = "rescue" .. tostring(l_17_1.key)
       -- DECOMPILER ERROR: Confused about usage of registers!

       -- DECOMPILER ERROR: Confused about usage of registers!

      managers.groupai:state():add_special_objective("rescue" .. tostring(l_17_1.key), {objective = {type = "act", follow_unit = l_17_1.unit, pos = so_pos, rot = so_rot, destroy_clbk_key = false, interrupt_dis = 700, interrupt_health = 0.75, stance = "hos", scan = true, nav_seg = l_17_1.unit:movement():nav_tracker():nav_segment(), fail_clbk = callback(CivilianLogicFlee, CivilianLogicFlee, "on_rescue_SO_failed", l_17_1), complete_clbk = callback(CivilianLogicFlee, CivilianLogicFlee, "on_rescue_SO_completed", l_17_1), action = {type = "act", variant = "untie", body_part = 1, blocks = {action = -1, walk = -1}}, action_duration = tweak_data.interaction.free.timer}, base_chance = 1, chance_inc = 0, interval = 10})
      managers.groupai:state():register_rescueable_hostage(l_17_1.unit, nil)
    end
     -- DECOMPILER ERROR: Confused about usage of registers for local variables.

     -- Warning: missing end command somewhere! Added here
  end
end

CivilianLogicFlee._unregister_rescue_SO = function(l_18_0, l_18_1)
  if l_18_1.rescuer then
    local rescuer = l_18_1.rescuer
    l_18_1.rescuer = nil
    managers.groupai:state():on_objective_failed(rescuer, rescuer:brain():objective())
  elseif l_18_1.rescue_SO_id then
    managers.groupai:state():remove_special_objective(l_18_1.rescue_SO_id)
    l_18_1.rescue_SO_id = nil
    managers.groupai:state():unregister_rescueable_hostage(l_18_0.key)
  elseif l_18_1.delayed_rescue_SO_id then
    CopLogicBase.chk_cancel_delayed_clbk(l_18_1, l_18_1.delayed_rescue_SO_id)
    l_18_1.delayed_rescue_SO_id = nil
  end
  l_18_1.rescue_active = nil
end

CivilianLogicFlee.on_rescue_SO_administered = function(l_19_0, l_19_1, l_19_2)
  managers.groupai:state():on_civilian_try_freed()
  local my_data = l_19_1.internal_data
  my_data.rescuer = l_19_2
  my_data.rescue_SO_id = nil
  managers.groupai:state():unregister_rescueable_hostage(l_19_1.key)
end

CivilianLogicFlee.rescue_SO_verification = function(l_20_0, l_20_1, l_20_2)
  if not tweak_data.character[l_20_2:base()._tweak_table].rescue_hostages then
    return 
  end
  local u_nav_seg = l_20_2:movement():nav_tracker():nav_segment()
  for _,area in ipairs(l_20_1) do
    if area.nav_segs[u_nav_seg] then
      return true
    end
  end
end

CivilianLogicFlee.on_rescue_SO_failed = function(l_21_0, l_21_1)
  local my_data = l_21_1.internal_data
  if my_data.rescuer then
    my_data.rescue_active = nil
    my_data.rescuer = nil
    CivilianLogicFlee._add_delayed_rescue_SO(l_21_1, l_21_1.internal_data)
  end
end

CivilianLogicFlee.on_rescue_SO_completed = function(l_22_0, l_22_1, l_22_2)
  if l_22_1.internal_data.rescuer and l_22_2:key() == l_22_1.internal_data.rescuer:key() then
    l_22_1.internal_data.rescue_active = nil
    l_22_1.internal_data.rescuer = nil
    if l_22_1.unit:anim_data().tied or l_22_1.unit:anim_data().drop then
      local new_action = {type = "act", variant = "stand", body_part = 1}
      l_22_1.unit:brain():action_request(new_action)
      l_22_1.unit:brain():set_objective({type = "free", is_default = true, was_rescued = true})
    else
      if not CivilianLogicFlee._get_coarse_flee_path(l_22_1) then
        return 
      end
    end
  end
  l_22_1.unit:brain():set_update_enabled_state(true)
  managers.groupai:state():on_civilian_freed()
  l_22_2:sound():say("h01", true)
end

CivilianLogicFlee._get_coarse_flee_path = function(l_23_0)
  local flee_point = managers.groupai:state():safe_flee_point(l_23_0.unit:movement():nav_tracker():nav_segment())
  if not flee_point then
    return 
  end
  local my_data = l_23_0.internal_data
  local verify_clbk = callback(CivilianLogicFlee, CivilianLogicFlee, "_flee_coarse_path_verify_clbk")
  local search_params = {from_tracker = l_23_0.unit:movement():nav_tracker(), to_seg = flee_point.nav_seg, id = "CivilianLogicFlee._get_coarse_flee_path" .. tostring(l_23_0.key), access_pos = l_23_0.char_tweak.access, verify_clbk = callback(CivilianLogicFlee, CivilianLogicFlee, "_flee_coarse_path_verify_clbk")}
  local coarse_path = managers.navigation:search_coarse(search_params)
  if not coarse_path then
    return 
  end
  managers.groupai:state():trim_coarse_path_to_areas(coarse_path)
  my_data.coarse_path_index = 1
  my_data.coarse_path = coarse_path
  my_data.flee_target = flee_point
  return true
end

CivilianLogicFlee.on_new_objective = function(l_24_0, l_24_1)
  CivilianLogicIdle.on_new_objective(l_24_0, l_24_1)
end

CivilianLogicFlee.on_rescue_allowed_state = function(l_25_0, l_25_1)
end

CivilianLogicFlee.wants_rescue = function(l_26_0)
  return l_26_0.internal_data.rescue_SO_id
end

CivilianLogicFlee._get_all_paths = function(l_27_0)
  return {flee_path = l_27_0.internal_data.flee_path}
end

CivilianLogicFlee._set_verified_paths = function(l_28_0, l_28_1)
  l_28_0.internal_data.flee_path = l_28_1.flee_path
end

CivilianLogicFlee.reset_actions = function(l_29_0)
  local walk_action = l_29_0.unit:movement()._active_actions[2]
  if walk_action and walk_action:type() == "walk" then
    local action = {type = "idle", body_part = 2}
    l_29_0.unit:movement():action_request(action)
  end
end

CivilianLogicFlee._chk_add_delayed_rescue_SO = function(l_30_0, l_30_1)
  if not l_30_1.exiting and not l_30_0.unit:anim_data().move and managers.groupai:state():rescue_state() and not l_30_1.rescue_active then
    CivilianLogicFlee._add_delayed_rescue_SO(l_30_0, l_30_1)
    do return end
    if l_30_1.rescue_active then
      CivilianLogicFlee._unregister_rescue_SO(l_30_0, l_30_1)
    end
  end
end

CivilianLogicFlee.clbk_chk_run_away = function(l_31_0, l_31_1)
  local my_data = l_31_1.internal_data
  CopLogicBase.on_delayed_clbk(my_data, my_data.run_away_clbk_id)
  my_data.run_away_clbk_id = nil
  if not my_data.coarse_path and CivilianLogicFlee._get_coarse_flee_path(l_31_1) then
    l_31_1.unit:brain():set_update_enabled_state(true)
  end
  l_31_1.run_away_next_chk_t = TimerManager:game():time() + math.lerp(5, 8, math.random())
  CivilianLogicFlee.schedule_run_away_clbk(l_31_1)
end

CivilianLogicFlee.schedule_run_away_clbk = function(l_32_0)
  local my_data = l_32_0.internal_data
  if my_data.run_away_clbk_id or not l_32_0.char_tweak.run_away_delay then
    return 
  end
  if not l_32_0.run_away_next_chk_t then
    l_32_0.run_away_next_chk_t = l_32_0.t + math.lerp(l_32_0.char_tweak.run_away_delay[1], l_32_0.char_tweak.run_away_delay[2], math.random())
  end
  my_data.run_away_clbk_id = "runaway_chk" .. tostring(l_32_0.key)
  CopLogicBase.add_delayed_clbk(my_data, my_data.run_away_clbk_id, callback(CivilianLogicFlee, CivilianLogicFlee, "clbk_chk_run_away", l_32_0), l_32_0.run_away_next_chk_t)
end

CivilianLogicFlee.clbk_chk_call_the_police = function(l_33_0, l_33_1)
  local my_data = l_33_1.internal_data
  CopLogicBase.on_delayed_clbk(my_data, my_data.call_police_clbk_id)
  my_data.call_police_clbk_id = nil
  if managers.groupai:state():is_police_called() then
    return 
  end
  local my_areas = managers.groupai:state():get_areas_from_nav_seg_id(l_33_1.unit:movement():nav_tracker():nav_segment())
  local already_calling = false
  for u_key,u_data in pairs(managers.enemy:all_civilians()) do
    local civ_nav_seg = u_data.unit:movement():nav_tracker():nav_segment()
    if my_areas[civ_nav_seg] and u_data.unit:anim_data().call_police then
      already_calling = true
  else
    end
  end
  if not already_calling and (not my_data.calling_the_police or not l_33_1.unit:movement():chk_action_forbidden("walk")) then
    local action = {type = "act", body_part = 1, variant = "cmf_so_call_police", blocks = {}}
    my_data.calling_the_police = l_33_1.unit:movement():action_request(action)
    if my_data.calling_the_police then
      CivilianLogicFlee._say_call_the_police(l_33_1, my_data)
    end
  end
  my_data.call_police_clbk_id = "civ_call_police" .. tostring(l_33_1.key)
  CopLogicBase.add_delayed_clbk(my_data, my_data.call_police_clbk_id, callback(CivilianLogicFlee, CivilianLogicFlee, "clbk_chk_call_the_police", l_33_1), TimerManager:game():time() + math.lerp(15, 20, math.random()))
end

CivilianLogicFlee._say_call_the_police = function(l_34_0, l_34_1)
  local snd_event_name = nil
  if l_34_1.call_in_event == "corpse" then
    snd_event_name = "cmd_cal_bod_xxx"
  elseif l_34_1.call_in_event == "w_hot" then
    snd_event_name = "cmd_sht_frd_xxx"
  elseif l_34_1.call_in_event == "drill" then
    snd_event_name = "cmd_sht_frd_xxx"
  elseif l_34_1.call_in_event == "civilian" then
    snd_event_name = "cmd_civ_dist_xxx"
  elseif l_34_1.call_in_event == "criminal" then
    snd_event_name = "cmd_sht_frd_xxx"
  else
    snd_event_name = "cmd_sht_frd_xxx"
  end
  l_34_0.unit:sound():say(snd_event_name, true, false)
end


