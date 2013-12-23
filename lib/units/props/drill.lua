-- Decompiled using luadec 2.0.1 by sztupy (http://winmo.sztupy.hu)
-- Command line was: F:\SteamLibrary\SteamApps\common\PAYDAY 2\lua\lib\units\props\drill.luac 

if not Drill then
  Drill = class(UnitBase)
end
Drill.active_drills = Drill.active_drills or 0
Drill.jammed_drills = Drill.jammed_drills or 0
Drill._drill_remind_clbk_id = "_drill_remind_clbk"
Drill.init = function(l_1_0, l_1_1)
  Drill.super.init(l_1_0, l_1_1, false)
  l_1_0._unit = l_1_1
  l_1_0._jammed = false
  l_1_0._jammed_count = 0
  l_1_0._powered = true
  l_1_0._use_effect = true
  l_1_0._active_effect_name = "effects/payday2/environment/drill"
  l_1_0._pos = l_1_1:position()
  managers.groupai:state():on_editor_sim_unit_spawned(l_1_1)
end

Drill.start = function(l_2_0)
  l_2_0:_start_drill_effect()
  if not l_2_0.started then
    l_2_0.started = true
    Drill.active_drills = Drill.active_drills + 1
    if Network:is_server() then
      if not l_2_0._nav_tracker and managers.navigation:is_data_ready() then
        if l_2_0._sabotage_align_obj_name then
          l_2_0._nav_tracker = managers.navigation:create_nav_tracker(l_2_0._unit:get_object(Idstring(l_2_0._sabotage_align_obj_name)):position())
        else
          l_2_0._nav_tracker = managers.navigation:create_nav_tracker(l_2_0._pos)
        end
      end
      l_2_0:_register_sabotage_SO()
    end
    if not managers.groupai:state():enemy_weapons_hot() then
      l_2_0:_set_attention_state(true)
      l_2_0:_set_alert_state(true)
      managers.dialog:queue_dialog("Play_pln_drl_wrn", {})
      l_2_0._ene_weap_hot_listen_id = "Drill_ene_w_hot" .. tostring(l_2_0._unit:key())
      managers.groupai:state():add_listener(l_2_0._ene_weap_hot_listen_id, {"enemy_weapons_hot"}, callback(l_2_0, l_2_0, "clbk_enemy_weapons_hot"))
    end
  end
end

Drill.stop = function(l_3_0)
  l_3_0:set_jammed(false)
end

Drill.done = function(l_4_0)
  l_4_0:set_jammed(false)
  l_4_0:_kill_drill_effect()
  if l_4_0.started then
    l_4_0.started = nil
    Drill.active_drills = Drill.active_drills - 1
  end
  if l_4_0._alert_clbk_id then
    managers.enemy:remove_delayed_clbk(l_4_0._alert_clbk_id)
    l_4_0._alert_clbk_id = nil
  end
  l_4_0:_unregister_sabotage_SO()
end

Drill._start_drill_effect = function(l_5_0)
  if l_5_0._drill_effect then
    return 
  end
  if l_5_0._use_effect then
    local params = {}
    params.effect = Idstring(l_5_0._active_effect_name)
    params.parent = l_5_0._unit:get_object(Idstring("e_drill_particles"))
    l_5_0._drill_effect = World:effect_manager():spawn(params)
  end
end

Drill._kill_drill_effect = function(l_6_0)
  if not l_6_0._drill_effect then
    return 
  end
  if l_6_0._use_effect then
    World:effect_manager():fade_kill(l_6_0._drill_effect)
  end
  l_6_0._drill_effect = nil
end

Drill._kill_jammed_effect = function(l_7_0)
  if not l_7_0._jammed_effect then
    return 
  end
  if l_7_0._use_effect then
    World:effect_manager():fade_kill(l_7_0._jammed_effect)
  end
  l_7_0._jammed_effect = nil
end

Drill.set_jammed = function(l_8_0, l_8_1)
  if l_8_0._jammed or false == l_8_1 or false then
    return 
  end
  l_8_0._jammed = l_8_1
  if l_8_0._jammed then
    l_8_0._jammed_count = l_8_0._jammed_count + 1
    l_8_0:_kill_drill_effect()
    if l_8_0._use_effect then
      local params = {}
      params.effect = Idstring("effects/payday2/environment/drill_jammed")
      params.parent = l_8_0._unit:get_object(Idstring("e_drill_particles"))
      l_8_0._jammed_effect = World:effect_manager():spawn(params)
    end
    if l_8_0._autorepair and not l_8_0._autorepair_clbk_id then
      l_8_0._autorepair_clbk_id = "Drill_autorepair" .. tostring(l_8_0._unit:key())
      managers.enemy:add_delayed_clbk(l_8_0._autorepair_clbk_id, callback(l_8_0, l_8_0, "clbk_autorepair"), TimerManager:game():time() + 5 + 15 * math.random())
    elseif l_8_0._jammed_effect then
      l_8_0:_kill_jammed_effect()
      l_8_0:_start_drill_effect()
      if not l_8_0.is_hacking_device and not l_8_0.is_saw then
        managers.groupai:state():teammate_comment(nil, "g22", l_8_0._unit:position(), true, 500, false)
      end
      if l_8_0._autorepair_clbk_id then
        managers.enemy:remove_delayed_clbk(l_8_0._autorepair_clbk_id)
        l_8_0._autorepair_clbk_id = nil
      end
      if l_8_0._bain_report_sabotage_clbk_id then
        managers.enemy:remove_delayed_clbk(l_8_0._bain_report_sabotage_clbk_id)
        l_8_0._bain_report_sabotage_clbk_id = nil
      end
    end
  end
  l_8_0:_change_num_jammed_drills(l_8_0._jammed and 1 or -1)
  if Network:is_server() then
    if l_8_1 then
      l_8_0:_unregister_sabotage_SO()
    else
      l_8_0:_register_sabotage_SO()
    end
  end
end

Drill._change_num_jammed_drills = function(l_9_0, l_9_1)
  Drill.jammed_drills = Drill.jammed_drills + l_9_1
  if Drill.jammed_drills > 0 and not Drill._drll_remind_clbk then
    Drill._drll_remind_clbk = callback(l_9_0, l_9_0, "_drill_remind_clbk")
    managers.enemy:add_delayed_clbk(Drill._drill_remind_clbk_id, Drill._drll_remind_clbk, Application:time() + 20)
  end
  if Drill.jammed_drills <= 0 and Drill._drll_remind_clbk then
    managers.enemy:remove_delayed_clbk(Drill._drill_remind_clbk_id)
    Drill._drll_remind_clbk = nil
  end
end

Drill._drill_remind_clbk = function(l_10_0)
  if Drill.active_drills <= 1 or not "plu" then
    local suffix = l_10_0.is_hacking_device or "sin"
  end
   -- DECOMPILER ERROR: Confused while interpreting a jump as a 'while'

end
managers.groupai:state():teammate_comment(nil, (l_10_0._jammed_count > 1 or "d01x_") .. suffix, nil, false, nil, false)

suffix = managers
suffix = suffix.enemy
suffix(suffix, Drill._drill_remind_clbk_id, Drill._drll_remind_clbk, Application:time() + 45)
suffix = suffix:add_delayed_clbk
end

Drill.set_powered = function(l_11_0, l_11_1)
  if l_11_0._powered or false == l_11_1 or false then
    return 
  end
  l_11_0._powered = l_11_1
  if not l_11_0._powered then
    l_11_0:_kill_drill_effect()
  else
    l_11_0:_start_drill_effect()
    if not l_11_0.is_hacking_device and not l_11_0.is_saw then
      managers.groupai:state():teammate_comment(nil, "g22", l_11_0._unit:position(), true, 500, false)
    end
  end
end

Drill._register_sabotage_SO = function(l_12_0)
  if l_12_0._sabotage_SO_id or not managers.navigation:is_data_ready() or not l_12_0._unit:timer_gui() or not l_12_0._unit:timer_gui()._can_jam or not l_12_0._sabotage_align_obj_name then
    return 
  end
  local field_pos = l_12_0._nav_tracker:field_position()
  local field_z = l_12_0._nav_tracker:field_z() - 25
  local height = l_12_0._pos.z - field_z
  local act_anim = "sabotage_device_" .. ((height > 100 and "high") or (height > 60 and "mid") or "low")
  local align_obj = l_12_0._unit:get_object(Idstring(l_12_0._sabotage_align_obj_name))
  local objective_rot = align_obj:rotation()
  local objective_pos = align_obj:position()
  l_12_0._SO_area = managers.groupai:state():get_area_from_nav_seg_id(l_12_0._nav_tracker:nav_segment())
  local followup_objective = {type = "defend_area", nav_seg = l_12_0._nav_tracker:nav_segment(), area = l_12_0._SO_area, attitude = "avoid", stance = "hos", scan = true, interrupt_dis = 500, interrupt_health = 1}
  {type = "act", nav_seg = l_12_0._nav_tracker:nav_segment(), area = l_12_0._SO_area, pos = objective_pos, rot = objective_rot, stance = "hos", haste = "run", fail_clbk = callback(l_12_0, l_12_0, "on_sabotage_SO_failed"), complete_clbk = callback(l_12_0, l_12_0, "on_sabotage_SO_completed"), action_start_clbk = callback(l_12_0, l_12_0, "on_sabotage_SO_started"), scan = true, followup_objective = followup_objective, interrupt_dis = 800, interrupt_health = 1}.action = {type = "act", variant = act_anim, body_part = 1, blocks = {action = -1, light_hurt = -1, aim = -1}, align_sync = true}
   -- DECOMPILER ERROR: Confused at declaration of local variable

   -- DECOMPILER ERROR: Confused about usage of registers!

  {objective = {type = "act", nav_seg = l_12_0._nav_tracker:nav_segment(), area = l_12_0._SO_area, pos = objective_pos, rot = objective_rot, stance = "hos", haste = "run", fail_clbk = callback(l_12_0, l_12_0, "on_sabotage_SO_failed"), complete_clbk = callback(l_12_0, l_12_0, "on_sabotage_SO_completed"), action_start_clbk = callback(l_12_0, l_12_0, "on_sabotage_SO_started"), scan = true, followup_objective = followup_objective, interrupt_dis = 800, interrupt_health = 1}, base_chance = 1, chance_inc = 0, interval = 0, search_pos = field_pos, search_dis_sq = 1000000}.verification_clbk = callback(l_12_0, l_12_0, "clbk_sabotage_SO_verification")
   -- DECOMPILER ERROR: Confused about usage of registers!

  {objective = {type = "act", nav_seg = l_12_0._nav_tracker:nav_segment(), area = l_12_0._SO_area, pos = objective_pos, rot = objective_rot, stance = "hos", haste = "run", fail_clbk = callback(l_12_0, l_12_0, "on_sabotage_SO_failed"), complete_clbk = callback(l_12_0, l_12_0, "on_sabotage_SO_completed"), action_start_clbk = callback(l_12_0, l_12_0, "on_sabotage_SO_started"), scan = true, followup_objective = followup_objective, interrupt_dis = 800, interrupt_health = 1}, base_chance = 1, chance_inc = 0, interval = 0, search_pos = field_pos, search_dis_sq = 1000000}.usage_amount = 1
   -- DECOMPILER ERROR: Confused about usage of registers!

  {objective = {type = "act", nav_seg = l_12_0._nav_tracker:nav_segment(), area = l_12_0._SO_area, pos = objective_pos, rot = objective_rot, stance = "hos", haste = "run", fail_clbk = callback(l_12_0, l_12_0, "on_sabotage_SO_failed"), complete_clbk = callback(l_12_0, l_12_0, "on_sabotage_SO_completed"), action_start_clbk = callback(l_12_0, l_12_0, "on_sabotage_SO_started"), scan = true, followup_objective = followup_objective, interrupt_dis = 800, interrupt_health = 1}, base_chance = 1, chance_inc = 0, interval = 0, search_pos = field_pos, search_dis_sq = 1000000}.AI_group = "enemies"
   -- DECOMPILER ERROR: Confused about usage of registers!

  {objective = {type = "act", nav_seg = l_12_0._nav_tracker:nav_segment(), area = l_12_0._SO_area, pos = objective_pos, rot = objective_rot, stance = "hos", haste = "run", fail_clbk = callback(l_12_0, l_12_0, "on_sabotage_SO_failed"), complete_clbk = callback(l_12_0, l_12_0, "on_sabotage_SO_completed"), action_start_clbk = callback(l_12_0, l_12_0, "on_sabotage_SO_started"), scan = true, followup_objective = followup_objective, interrupt_dis = 800, interrupt_health = 1}, base_chance = 1, chance_inc = 0, interval = 0, search_pos = field_pos, search_dis_sq = 1000000}.access = managers.navigation:convert_access_filter_to_number({"gangster", "security", "security_patrol", "cop", "fbi", "swat", "murky", "sniper", "spooc", "tank", "taser"})
   -- DECOMPILER ERROR: Confused about usage of registers!

  {objective = {type = "act", nav_seg = l_12_0._nav_tracker:nav_segment(), area = l_12_0._SO_area, pos = objective_pos, rot = objective_rot, stance = "hos", haste = "run", fail_clbk = callback(l_12_0, l_12_0, "on_sabotage_SO_failed"), complete_clbk = callback(l_12_0, l_12_0, "on_sabotage_SO_completed"), action_start_clbk = callback(l_12_0, l_12_0, "on_sabotage_SO_started"), scan = true, followup_objective = followup_objective, interrupt_dis = 800, interrupt_health = 1}, base_chance = 1, chance_inc = 0, interval = 0, search_pos = field_pos, search_dis_sq = 1000000}.admin_clbk = callback(l_12_0, l_12_0, "on_sabotage_SO_administered")
  do
     -- DECOMPILER ERROR: Confused at declaration of local variable

    l_12_0._sabotage_SO_id = "drill_sabotage" .. tostring(l_12_0._unit:key())
     -- DECOMPILER ERROR: Confused about usage of registers!

    managers.groupai:state():add_special_objective(l_12_0._sabotage_SO_id, {objective = {type = "act", nav_seg = l_12_0._nav_tracker:nav_segment(), area = l_12_0._SO_area, pos = objective_pos, rot = objective_rot, stance = "hos", haste = "run", fail_clbk = callback(l_12_0, l_12_0, "on_sabotage_SO_failed"), complete_clbk = callback(l_12_0, l_12_0, "on_sabotage_SO_completed"), action_start_clbk = callback(l_12_0, l_12_0, "on_sabotage_SO_started"), scan = true, followup_objective = followup_objective, interrupt_dis = 800, interrupt_health = 1}, base_chance = 1, chance_inc = 0, interval = 0, search_pos = field_pos, search_dis_sq = 1000000})
  end
   -- DECOMPILER ERROR: Confused about usage of registers for local variables.

end

Drill._unregister_sabotage_SO = function(l_13_0)
  if l_13_0._sabotage_SO_id then
    managers.groupai:state():remove_special_objective(l_13_0._sabotage_SO_id)
    l_13_0._sabotage_SO_id = nil
  elseif l_13_0._saboteur then
    local saboteur = l_13_0._saboteur
    l_13_0._saboteur = nil
    if alive(saboteur) then
      saboteur:brain():set_objective(nil)
    end
  end
end

Drill.on_sabotage_SO_administered = function(l_14_0, l_14_1)
  if l_14_0._saboteur then
    debug_pause("[Drill:on_sabotage_SO_administered] Already had a saboteur", l_14_1, l_14_0._saboteur)
  end
  l_14_0._saboteur = l_14_1
  l_14_0._sabotage_SO_id = nil
end

Drill.on_sabotage_SO_failed = function(l_15_0, l_15_1)
  if l_15_0._saboteur then
    l_15_0._saboteur = nil
    l_15_0:_register_sabotage_SO()
  end
end

Drill.on_sabotage_SO_completed = function(l_16_0, l_16_1)
  l_16_0._saboteur = nil
end

Drill.on_sabotage_SO_started = function(l_17_0, l_17_1)
  if not l_17_0._saboteur or l_17_0._saboteur:key() ~= l_17_1:key() then
    debug_pause_unit(l_17_0._unit, "[Drill:on_sabotage_SO_started] wrong saboteur", l_17_0._unit, l_17_1, l_17_0._saboteur)
  end
  l_17_0._saboteur = nil
  l_17_0._unit:timer_gui():set_jammed(true)
  if not l_17_0._bain_report_sabotage_clbk_id then
    l_17_0._bain_report_sabotage_clbk_id = "Drill_bain_report_sabotage" .. tostring(l_17_0._unit:key())
    managers.enemy:add_delayed_clbk(l_17_0._bain_report_sabotage_clbk_id, callback(l_17_0, l_17_0, "clbk_bain_report_sabotage"), TimerManager:game():time() + 2 + 4 * math.random())
  end
end

Drill.clbk_sabotage_SO_verification = function(l_18_0, l_18_1)
  if not l_18_0._sabotage_SO_id then
    debug_pause_unit(l_18_0._unit, "[Drill:clbk_sabotage_SO_verification] SO is not registered", l_18_0._unit, l_18_1)
    return 
  end
  local nav_seg = l_18_1:movement():nav_tracker():nav_segment()
  if l_18_0._SO_area.nav_segs[nav_seg] and not l_18_1:movement():cool() then
    return true
  end
end

Drill._set_attention_state = function(l_19_0, l_19_1)
  if l_19_1 and not l_19_0._attention_setting then
    l_19_0._attention_handler = AIAttentionObject:new(l_19_0._unit, true)
    if l_19_0._attention_obj_name then
      l_19_0._attention_handler:set_detection_object_name(l_19_0._attention_obj_name)
    end
    do
      local attention_setting = PlayerMovement._create_attention_setting_from_descriptor(l_19_0, tweak_data.attention.settings.drill_civ_ene_ntl, "drill_civ_ene_ntl")
      l_19_0._attention_handler:set_attention(attention_setting)
    end
    do return end
    if l_19_0._attention_handler then
      l_19_0._attention_handler:set_attention(nil)
      l_19_0._attention_handler = nil
    end
  end
end

Drill.clbk_enemy_weapons_hot = function(l_20_0)
  managers.groupai:state():remove_listener(l_20_0._ene_weap_hot_listen_id)
  l_20_0._ene_weap_hot_listen_id = nil
  l_20_0:_set_attention_state(false)
  l_20_0:_set_alert_state(false)
end

Drill.set_autorepair = function(l_21_0, l_21_1)
  l_21_0._autorepair = l_21_1
  if l_21_1 and l_21_0._jammed and not l_21_0._autorepair_clbk_id then
    l_21_0._autorepair_clbk_id = "Drill_autorepair" .. tostring(l_21_0._unit:key())
    managers.enemy:add_delayed_clbk(l_21_0._autorepair_clbk_id, callback(l_21_0, l_21_0, "clbk_autorepair"), TimerManager:game():time() + 5 + 15 * math.random())
    do return end
    if l_21_0._autorepair_clbk_id then
      managers.enemy:remove_delayed_clbk(l_21_0._autorepair_clbk_id)
      l_21_0._autorepair_clbk_id = nil
    end
  end
end

Drill.clbk_autorepair = function(l_22_0)
  l_22_0._autorepair_clbk_id = nil
  l_22_0._unit:timer_gui():set_jammed(false)
  l_22_0._unit:interaction():set_active(false, true)
end

Drill._set_alert_state = function(l_23_0, l_23_1)
  l_23_0._alert_state = l_23_1
  if l_23_1 and l_23_0._alert_radius then
    l_23_0:_register_investigate_SO()
  else
    l_23_0:_unregister_investigate_SO()
  end
end

Drill.set_alert_radius = function(l_24_0, l_24_1)
  if l_24_1 then
    l_24_0._alert_radius = l_24_1
    if l_24_0._alert_state then
      l_24_0:_register_investigate_SO()
    else
      l_24_0:_unregister_investigate_SO()
    end
  end
end

Drill._register_investigate_SO = function(l_25_0)
  if l_25_0._investigate_SO_data then
    return 
  end
  if not Network:is_server() or not managers.navigation:is_data_ready() then
    return 
  end
  local SO_category = "enemies"
  local SO_filter = managers.navigation:convert_SO_AI_group_to_access(SO_category)
  local investigate_pos = Vector3()
  local my_rot = l_25_0._unit:rotation()
  mrotation.y(my_rot, investigate_pos)
  mvector3.multiply(investigate_pos, 300)
  mvector3.add(investigate_pos, l_25_0._nav_tracker:field_position())
  local investigate_pos_tracker = managers.navigation:create_nav_tracker(investigate_pos, true)
  investigate_pos = investigate_pos_tracker:field_position()
  managers.navigation:destroy_nav_tracker(investigate_pos_tracker)
  local investigate_fwd = Vector3()
  mvector3.direction(investigate_fwd, investigate_pos, l_25_0._nav_tracker:field_position())
  local investigate_rot = Rotation(investigate_fwd, math.UP)
  local investigate_nav_seg = l_25_0._nav_tracker:nav_segment()
  local investigate_area = managers.groupai:state():get_area_from_nav_seg_id(investigate_nav_seg)
  {type = "free", haste = "walk", pose = "stand", stance = "ntl", nav_seg = investigate_nav_seg, area = investigate_area, pos = investigate_pos, rot = investigate_rot, interrupt_dis = -1, interrupt_health = 1}.fail_clbk = callback(l_25_0, l_25_0, "on_investigate_SO_failed")
   -- DECOMPILER ERROR: Confused about usage of registers!

  {type = "free", haste = "walk", pose = "stand", stance = "ntl", nav_seg = investigate_nav_seg, area = investigate_area, pos = investigate_pos, rot = investigate_rot, interrupt_dis = -1, interrupt_health = 1}.complete_clbk = callback(l_25_0, l_25_0, "on_investigate_SO_completed")
   -- DECOMPILER ERROR: Confused about usage of registers!

  {type = "free", haste = "walk", pose = "stand", stance = "ntl", nav_seg = investigate_nav_seg, area = investigate_area, pos = investigate_pos, rot = investigate_rot, interrupt_dis = -1, interrupt_health = 1}.action_duration = math.lerp(3, 8, math.random())
   -- DECOMPILER ERROR: Confused at declaration of local variable

   -- DECOMPILER ERROR: Confused about usage of registers!

  {objective = {type = "free", haste = "walk", pose = "stand", stance = "ntl", nav_seg = investigate_nav_seg, area = investigate_area, pos = investigate_pos, rot = investigate_rot, interrupt_dis = -1, interrupt_health = 1}, base_chance = 1}.chance_inc = 0
   -- DECOMPILER ERROR: Confused about usage of registers!

  {objective = {type = "free", haste = "walk", pose = "stand", stance = "ntl", nav_seg = investigate_nav_seg, area = investigate_area, pos = investigate_pos, rot = investigate_rot, interrupt_dis = -1, interrupt_health = 1}, base_chance = 1}.interval = 0
   -- DECOMPILER ERROR: Confused about usage of registers!

  {objective = {type = "free", haste = "walk", pose = "stand", stance = "ntl", nav_seg = investigate_nav_seg, area = investigate_area, pos = investigate_pos, rot = investigate_rot, interrupt_dis = -1, interrupt_health = 1}, base_chance = 1}.search_pos = l_25_0._nav_tracker:field_position()
   -- DECOMPILER ERROR: Confused about usage of registers!

  {objective = {type = "free", haste = "walk", pose = "stand", stance = "ntl", nav_seg = investigate_nav_seg, area = investigate_area, pos = investigate_pos, rot = investigate_rot, interrupt_dis = -1, interrupt_health = 1}, base_chance = 1}.verification_clbk = callback(l_25_0, l_25_0, "clbk_investigate_SO_verification")
   -- DECOMPILER ERROR: Confused about usage of registers!

  {objective = {type = "free", haste = "walk", pose = "stand", stance = "ntl", nav_seg = investigate_nav_seg, area = investigate_area, pos = investigate_pos, rot = investigate_rot, interrupt_dis = -1, interrupt_health = 1}, base_chance = 1}.usage_amount = 1
   -- DECOMPILER ERROR: Confused about usage of registers!

  {objective = {type = "free", haste = "walk", pose = "stand", stance = "ntl", nav_seg = investigate_nav_seg, area = investigate_area, pos = investigate_pos, rot = investigate_rot, interrupt_dis = -1, interrupt_health = 1}, base_chance = 1}.AI_group = "enemies"
   -- DECOMPILER ERROR: Confused about usage of registers!

  {objective = {type = "free", haste = "walk", pose = "stand", stance = "ntl", nav_seg = investigate_nav_seg, area = investigate_area, pos = investigate_pos, rot = investigate_rot, interrupt_dis = -1, interrupt_health = 1}, base_chance = 1}.admin_clbk = callback(l_25_0, l_25_0, "on_investigate_SO_administered")
   -- DECOMPILER ERROR: Confused at declaration of local variable

  do
     -- DECOMPILER ERROR: Confused at declaration of local variable

    l_25_0._investigate_SO_data = {SO_id = "Drill_investigate" .. tostring(l_25_0._unit:key()), SO_registered = true}
     -- DECOMPILER ERROR: Confused about usage of registers!

     -- DECOMPILER ERROR: Confused about usage of registers!

    managers.groupai:state():add_special_objective("Drill_investigate" .. tostring(l_25_0._unit:key()), {objective = {type = "free", haste = "walk", pose = "stand", stance = "ntl", nav_seg = investigate_nav_seg, area = investigate_area, pos = investigate_pos, rot = investigate_rot, interrupt_dis = -1, interrupt_health = 1}, base_chance = 1})
  end
   -- DECOMPILER ERROR: Confused about usage of registers for local variables.

end

Drill._unregister_investigate_SO = function(l_26_0)
  if not l_26_0._investigate_SO_data then
    return 
  end
  if l_26_0._investigate_SO_data.SO_registered then
    managers.groupai:state():remove_special_objective(l_26_0._investigate_SO_data.SO_id)
  else
    if l_26_0._investigate_SO_data.receiver_unit then
      local receiver_unit = l_26_0._investigate_SO_data.receiver_unit
      l_26_0._investigate_SO_data.receiver_unit = nil
      if alive(receiver_unit) then
        receiver_unit:brain():set_objective(nil)
      end
    end
  end
  l_26_0._investigate_SO_data = nil
end

Drill.clbk_investigate_SO_verification = function(l_27_0, l_27_1)
  if not l_27_0._investigate_SO_data or not l_27_0._investigate_SO_data.SO_id then
    debug_pause_unit(l_27_0._unit, "[Drill:clbk_investigate_SO_verification] SO is not registered", l_27_0._unit, l_27_1, inspect(l_27_0._investigate_SO_data))
    return 
  end
  if not l_27_1:movement():cool() then
    return 
  end
  local candidate_listen_pos = l_27_1:movement():m_head_pos()
  local sound_source_pos = l_27_0._unit:position()
  local ray = l_27_0._unit:raycast("ray", candidate_listen_pos, sound_source_pos, "slot_mask", managers.slot:get_mask("AI_visibility"), "ray_type", "ai_vision", "report")
  if ray then
    local my_dis = mvector3.distance(candidate_listen_pos, sound_source_pos)
    if l_27_0._alert_radius * 0.5 < my_dis then
      return 
    end
  end
  return true
end

Drill.on_investigate_SO_administered = function(l_28_0, l_28_1)
  if l_28_0._investigate_SO_data.receiver_unit then
    debug_pause("[Drill:on_investigate_SO_administered] Already had a receiver_unit!!!!", thief, l_28_0._investigate_SO_data.receiver_unit)
  end
  l_28_0._investigate_SO_data.receiver_unit = l_28_1
  l_28_0._investigate_SO_data.SO_registered = false
end

Drill.on_investigate_SO_completed = function(l_29_0, l_29_1)
  if l_29_1 ~= l_29_0._investigate_SO_data.receiver_unit then
    debug_pause_unit(l_29_1, "[Drill:on_investigate_SO_completed] idiot thinks he is investigating", l_29_1)
    return 
  end
  l_29_0:_register_investigate_SO()
end

Drill.on_investigate_SO_failed = function(l_30_0, l_30_1)
  if not l_30_0._investigate_SO_data.receiver_unit then
    return 
  end
  if l_30_1 ~= l_30_0._investigate_SO_data.receiver_unit then
    debug_pause_unit(l_30_1, "[CarryData:on_pickup_SO_failed] idiot thinks he is investigating", l_30_1)
    return 
  end
  l_30_0._investigate_SO_data = nil
  l_30_0:_register_investigate_SO()
end

Drill.attention_handler = function(l_31_0)
  return l_31_0._attention_handler
end

Drill.clbk_bain_report_sabotage = function(l_32_0)
  l_32_0._bain_report_sabotage_clbk_id = nil
  if l_32_0._jammed then
    managers.dialog:queue_dialog("Play_pln_csod_01", {})
  end
end

Drill.destroy = function(l_33_0)
  if l_33_0._alert_clbk_id then
    managers.enemy:remove_delayed_clbk(l_33_0._alert_clbk_id)
    l_33_0._alert_clbk_id = nil
  end
  if l_33_0._ene_weap_hot_listen_id then
    managers.groupai:state():remove_listener(l_33_0._ene_weap_hot_listen_id)
    l_33_0._ene_weap_hot_listen_id = nil
  end
  if l_33_0._attention_handler then
    l_33_0._attention_handler:set_attention(nil)
    l_33_0._attention_handler = nil
  end
  if l_33_0._autorepair_clbk_id then
    managers.enemy:remove_delayed_clbk(l_33_0._autorepair_clbk_id)
    l_33_0._autorepair_clbk_id = nil
  end
  if l_33_0._bain_report_sabotage_clbk_id then
    managers.enemy:remove_delayed_clbk(l_33_0._bain_report_sabotage_clbk_id)
    l_33_0._bain_report_sabotage_clbk_id = nil
  end
  l_33_0:_unregister_sabotage_SO()
  l_33_0:_unregister_investigate_SO()
  l_33_0:_kill_jammed_effect()
  l_33_0:_kill_drill_effect()
  l_33_0:set_jammed(false)
end


