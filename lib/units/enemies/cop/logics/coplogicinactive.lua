-- Decompiled using luadec 2.0.1 by sztupy (http://winmo.sztupy.hu)
-- Command line was: F:\SteamLibrary\SteamApps\common\PAYDAY 2\lua\lib\units\enemies\cop\logics\coplogicinactive.luac 

CopLogicInactive = class(CopLogicBase)
CopLogicInactive.enter = function(l_1_0, l_1_1, l_1_2)
  CopLogicBase.enter(l_1_0, l_1_1, l_1_2)
  local old_internal_data = l_1_0.internal_data
  l_1_0.internal_data = {}
  local my_data = l_1_0.internal_data
  if l_1_0.has_outline then
    l_1_0.unit:base():set_contour(false)
    l_1_0.has_outline = nil
  end
  local attention_obj = l_1_0.attention_obj
  CopLogicBase._set_attention_obj(l_1_0, nil, nil)
  CopLogicBase._destroy_all_detected_attention_object_data(l_1_0)
  CopLogicBase._reset_attention(l_1_0)
  for c_key,c_data in pairs(managers.groupai:state():all_char_criminals()) do
    if c_data.engaged[l_1_0.key] then
      debug_pause_unit(l_1_0.unit, "inactive AI engaging player", l_1_0.unit, c_data.unit, inspect(attention_obj), inspect(l_1_0.attention_obj))
    end
  end
  local rsrv_pos = old_internal_data.rsrv_pos
  if rsrv_pos.path then
    managers.navigation:unreserve_pos(rsrv_pos.path)
    rsrv_pos.path = nil
  end
  if rsrv_pos.move_dest then
    managers.navigation:unreserve_pos(rsrv_pos.move_dest)
    rsrv_pos.move_dest = nil
  end
  if rsrv_pos.stand then
    managers.navigation:unreserve_pos(rsrv_pos.stand)
    rsrv_pos.stand = nil
  end
  if l_1_0.objective and l_1_0.objective.type == "follow" and l_1_0.objective.destroy_clbk_key then
    l_1_0.objective.follow_unit:base():remove_destroy_listener(l_1_0.objective.destroy_clbk_key)
    l_1_0.objective.destroy_clbk_key = nil
  end
  l_1_0.unit:brain():set_update_enabled_state(false)
  if l_1_0.objective then
    managers.groupai:state():on_objective_failed(l_1_0.unit, l_1_0.objective)
  end
  l_1_0.logic._register_attention(l_1_0, my_data)
  l_1_0.logic._set_interaction(l_1_0, my_data)
end

CopLogicInactive.exit = function(l_2_0, l_2_1, l_2_2)
  CopLogicBase.exit(l_2_0, l_2_1, l_2_2)
  local my_data = l_2_0.internal_data
  if my_data.weapons_hot_listener_key then
    managers.groupai:state():remove_listener(my_data.weapons_hot_listener_key)
    my_data.weapons_hot_listener_key = nil
  end
  CopLogicBase.cancel_delayed_clbks(my_data)
end

CopLogicInactive.is_available_for_assignment = function(l_3_0)
  return false
end

CopLogicInactive.on_enemy_weapons_hot = function(l_4_0, l_4_1)
  local my_data = l_4_1.internal_data
  l_4_1.unit:brain():set_attention_settings({corpse_cbt = true})
  if l_4_1.unit:interaction():active() then
    l_4_1.unit:interaction():set_active(false, true, true)
  end
  if my_data.pager_alert_clbk_id then
    CopLogicBase.cancel_delayed_clbk(my_data, my_data.pager_alert_clbk_id)
    my_data.pager_alert_clbk_id = nil
  end
  if my_data.pager_reminder_clbk_id then
    CopLogicBase.cancel_delayed_clbk(my_data, my_data.pager_reminder_clbk_id)
    my_data.pager_reminder_clbk_id = nil
  end
end

CopLogicInactive._register_attention = function(l_5_0, l_5_1)
  if l_5_0.unit:character_damage():dead() then
    if managers.groupai:state():enemy_weapons_hot() then
      l_5_0.unit:brain():set_attention_settings({corpse_cbt = true})
    else
      l_5_1.weapons_hot_listener_key = "CopLogicInactive_corpse" .. tostring(l_5_0.key)
      managers.groupai:state():add_listener(l_5_1.weapons_hot_listener_key, {"enemy_weapons_hot"}, callback(CopLogicInactive, CopLogicInactive, "on_enemy_weapons_hot", l_5_0))
      l_5_0.unit:brain():set_attention_settings({corpse_sneak = true})
    end
  else
    l_5_0.unit:brain():set_attention_settings(nil)
  end
end
end

CopLogicInactive.on_alarm_pager_interaction = function(l_6_0, l_6_1, l_6_2)
  print("[CopLogicInactive.on_alarm_pager_interaction]", l_6_1, l_6_2)
  if managers.groupai:state():enemy_weapons_hot() then
    return 
  end
  local my_data = l_6_0.internal_data
  if l_6_1 == "started" then
    CopLogicBase.cancel_delayed_clbk(my_data, my_data.pager_alert_clbk_id)
    my_data.pager_alert_clbk_id = nil
    if my_data.pager_reminder_clbk_id then
      CopLogicBase.cancel_delayed_clbk(my_data, my_data.pager_reminder_clbk_id)
      my_data.pager_reminder_clbk_id = nil
    elseif l_6_1 == "complete" then
      local nr_previous_bluffs = (managers.groupai:state():get_nr_successful_alarm_pager_bluffs())
      local has_upgrade = nil
      if l_6_2:base().is_local_player then
        has_upgrade = managers.player:has_category_upgrade("player", "corpse_alarm_pager_bluff")
      else
        has_upgrade = l_6_2:base():upgrade_value("player", "corpse_alarm_pager_bluff")
      end
      local chance_table = tweak_data.player.alarm_pager[has_upgrade and "bluff_success_chance_w_skill" or "bluff_success_chance"]
      local chance_index = math.min(nr_previous_bluffs + 1, #chance_table)
      local is_last = chance_table[math.min(chance_index + 1, #chance_table)] == 0
      local rand_nr = math.random()
      local success = chance_table[chance_index] > 0 and rand_nr < chance_table[chance_index]
      print("nr_previous_bluffs", nr_previous_bluffs, "has_upgrade", has_upgrade, "chance_index", chance_index, "rand_nr", rand_nr, "chance_table", inspect(chance_table), "success", success)
      if success then
        l_6_0.unit:interaction():set_tweak_data("corpse_dispose")
        l_6_0.unit:interaction():set_active(true, true, true)
        managers.groupai:state():on_successful_alarm_pager_bluff()
        l_6_0.unit:sound():stop()
        local cue_index = is_last and 4 or chance_index
        l_6_0.unit:sound():corpse_play("dsp_radio_fooled_" .. tostring(cue_index), nil, true)
      else
        managers.groupai:state():on_police_called("alarm_pager_bluff_failed")
        l_6_0.unit:interaction():set_active(false, true, true)
        l_6_0.unit:sound():stop()
        l_6_0.unit:sound():corpse_play("dsp_radio_alarm_1", nil, true)
      end
    elseif l_6_1 == "interrupted" then
      managers.groupai:state():on_police_called("alarm_pager_hang_up")
      l_6_0.unit:interaction():set_active(false, true, true)
      l_6_0.unit:sound():stop()
      l_6_0.unit:sound():corpse_play("dsp_radio_alarm_1", nil, true)
    end
  end
end
end

CopLogicInactive._set_interaction = function(l_7_0, l_7_1)
  if l_7_0.unit:character_damage():dead() and managers.groupai:state():whisper_mode() then
    local my_data = l_7_0.internal_data
    if l_7_0.char_tweak.has_alarm_pager then
      local pager_delay = math.lerp(tweak_data.player.alarm_pager.ring_delay[1], tweak_data.player.alarm_pager.ring_delay[2], math.random())
      my_data.pager_alert_clbk_id = "alarm_pager" .. tostring(l_7_0.key)
      CopLogicBase.add_delayed_clbk(my_data, my_data.pager_alert_clbk_id, callback(CopLogicInactive, CopLogicInactive, "clbk_alarm_pager_triggered", l_7_0), TimerManager:game():time() + pager_delay)
    else
      l_7_0.unit:interaction():set_tweak_data("corpse_dispose")
      l_7_0.unit:interaction():set_active(true, true, true)
    end
  end
end

CopLogicInactive.clbk_alarm_pager_triggered = function(l_8_0, l_8_1)
  print("[CopLogicInactive.clbk_alarm_pager_triggered]")
  local my_data = l_8_1.internal_data
  CopLogicBase.on_delayed_clbk(my_data, my_data.pager_alert_clbk_id)
  my_data.pager_alert_clbk_id = nil
  if managers.groupai:state():enemy_weapons_hot() then
    return 
  end
  l_8_1.unit:base():set_material_state(false)
  local u_id = managers.enemy:get_corpse_unit_data_from_key(l_8_1.key).u_id
  managers.network:session():send_to_peers_synched("set_corpse_material_config", u_id, false)
  l_8_1.unit:interaction():set_tweak_data("corpse_alarm_pager")
  l_8_1.unit:interaction():set_active(true, true, true)
  l_8_1.unit:sound():stop()
  l_8_1.unit:sound():corpse_play("dsp_radio_query_1", nil, true)
  local pager_delay = math.lerp(tweak_data.player.alarm_pager.ring_duration[1], tweak_data.player.alarm_pager.ring_duration[2], math.random())
  my_data.hang_up_t = TimerManager:game():time() + pager_delay
  my_data.pager_alert_clbk_id = "alarm_pager_hang_up" .. tostring(l_8_1.key)
  CopLogicBase.add_delayed_clbk(my_data, my_data.pager_alert_clbk_id, callback(CopLogicInactive, CopLogicInactive, "clbk_alarm_pager_not_answered", l_8_1), TimerManager:game():time() + pager_delay)
  local reminder_delay = math.lerp(tweak_data.player.alarm_pager.ring_reminder[1], tweak_data.player.alarm_pager.ring_reminder[2], math.random())
  my_data.pager_reminder_clbk_id = "alarm_pager_reminder" .. tostring(l_8_1.key)
  CopLogicBase.add_delayed_clbk(my_data, my_data.pager_reminder_clbk_id, callback(CopLogicInactive, CopLogicInactive, "clbk_alarm_pager_reminder", l_8_1), TimerManager:game():time() + reminder_delay)
end

CopLogicInactive.clbk_alarm_pager_reminder = function(l_9_0, l_9_1)
  print("[CopLogicInactive.clbk_alarm_pager_reminder]")
  local my_data = l_9_1.internal_data
  CopLogicBase.on_delayed_clbk(my_data, my_data.pager_reminder_clbk_id)
  my_data.pager_reminder_clbk_id = nil
  if managers.groupai:state():enemy_weapons_hot() then
    return 
  end
  if not my_data.pager_alert_clbk_id or my_data.hang_up_t - TimerManager:game():time() < 1.5 then
    return 
  end
  l_9_1.unit:sound():stop()
  l_9_1.unit:sound():corpse_play("dsp_radio_reminder_1", nil, true)
  local reminder_delay = math.lerp(tweak_data.player.alarm_pager.ring_reminder[1], tweak_data.player.alarm_pager.ring_reminder[2], math.random())
  my_data.pager_reminder_clbk_id = "alarm_pager_reminder" .. tostring(l_9_1.key)
  CopLogicBase.add_delayed_clbk(my_data, my_data.pager_reminder_clbk_id, callback(CopLogicInactive, CopLogicInactive, "clbk_alarm_pager_reminder", l_9_1), TimerManager:game():time() + reminder_delay)
end

CopLogicInactive.clbk_alarm_pager_not_answered = function(l_10_0, l_10_1)
  print("[CopLogicInactive.clbk_alarm_pager_not_answered]")
  local my_data = l_10_1.internal_data
  CopLogicBase.on_delayed_clbk(my_data, my_data.pager_alert_clbk_id)
  my_data.pager_alert_clbk_id = nil
  if managers.groupai:state():enemy_weapons_hot() then
    return 
  end
  l_10_1.unit:base():swap_material_config()
  l_10_1.unit:interaction():set_active(false, true, true)
  managers.groupai:state():on_police_called("alarm_pager_not_answered")
  l_10_1.unit:sound():stop()
  l_10_1.unit:sound():corpse_play("pln_alm_any_any", nil, true)
end

CopLogicInactive.on_new_objective = function(l_11_0, l_11_1)
  if not l_11_0.objective or l_11_1 then
    debug_pause_unit(l_11_0.unit, "[CopLogicInactive.on_new_objective]", l_11_0.unit, "new_objective", inspect(l_11_0.objective), "old_objective", inspect(l_11_1))
  end
  CopLogicBase.on_new_objective(l_11_0, l_11_1)
end

CopLogicInactive.pre_destroy = function(l_12_0)
  local my_data = l_12_0.internal_data
  if my_data.weapons_hot_listener_key then
    managers.groupai:state():remove_listener(my_data.weapons_hot_listener_key)
    my_data.weapons_hot_listener_key = nil
  end
  if my_data.pager_alert_clbk_id then
    managers.enemy:remove_delayed_clbk(my_data.pager_alert_clbk_id)
    my_data.pager_alert_clbk_id = nil
  end
  if my_data.pager_reminder_clbk_id then
    managers.enemy:remove_delayed_clbk(my_data.pager_reminder_clbk_id)
    my_data.pager_reminder_clbk_id = nil
  end
end


