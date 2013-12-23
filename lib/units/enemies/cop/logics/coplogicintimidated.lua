-- Decompiled using luadec 2.0.1 by sztupy (http://winmo.sztupy.hu)
-- Command line was: F:\SteamLibrary\SteamApps\common\PAYDAY 2\lua\lib\units\enemies\cop\logics\coplogicintimidated.luac 

local tmp_vec1 = Vector3()
CopLogicIntimidated = class(CopLogicBase)
CopLogicIntimidated.enter = function(l_1_0, l_1_1, l_1_2)
  CopLogicBase.enter(l_1_0, l_1_1, l_1_2)
  l_1_0.unit:brain():cancel_all_pathing_searches()
  local old_internal_data = l_1_0.internal_data
  local my_data = {unit = l_1_0.unit}
  l_1_0.internal_data = my_data
  my_data.detection = l_1_0.char_tweak.detection.combat
  my_data.rsrv_pos = {}
  if l_1_0.attention_obj then
    CopLogicBase._set_attention_obj(l_1_0, nil, nil)
  end
  if old_internal_data then
    if not old_internal_data.rsrv_pos then
      my_data.rsrv_pos = my_data.rsrv_pos
    end
    if old_internal_data.nearest_cover then
      my_data.nearest_cover = old_internal_data.nearest_cover
      managers.navigation:reserve_cover(my_data.nearest_cover[1], l_1_0.pos_rsrv_id)
    end
  end
  if l_1_0.char_tweak.surrender_break_time then
    my_data.surrender_break_t = l_1_0.t + math.random(l_1_0.char_tweak.surrender_break_time[1], l_1_0.char_tweak.surrender_break_time[2], math.random())
  end
  if l_1_0.unit:anim_data().hands_tied then
    CopLogicIntimidated._do_tied(l_1_0, nil)
  else
    l_1_0.unit:brain():set_update_enabled_state(true)
  end
  l_1_0.unit:movement():set_allow_fire(false)
  if l_1_0.objective then
    managers.groupai:state():on_objective_failed(l_1_0.unit, l_1_0.objective)
  end
  if managers.groupai:state():rescue_state() then
    CopLogicIntimidated._add_delayed_rescue_SO(l_1_0, my_data)
  end
  managers.groupai:state():add_to_surrendered(l_1_0.unit, callback(CopLogicIntimidated, CopLogicIntimidated, "queued_update", l_1_0))
  my_data.surrender_clbk_registered = true
  l_1_0.unit:sound():say("s01x", true)
  l_1_0.unit:movement():set_cool(false)
  if my_data ~= l_1_0.internal_data then
    return 
  end
  l_1_0.unit:brain():set_attention_settings({peaceful = true})
  managers.groupai:state():register_rescueable_hostage(l_1_0.unit, nil)
end

CopLogicIntimidated.exit = function(l_2_0, l_2_1, l_2_2)
  CopLogicBase.exit(l_2_0, l_2_1, l_2_2)
  local my_data = l_2_0.internal_data
  CopLogicIntimidated._unregister_rescue_SO(l_2_0, my_data)
  if l_2_1 ~= "inactive" then
    l_2_0.unit:base():set_slot(l_2_0.unit, 12)
  end
  if my_data.nearest_cover then
    managers.navigation:release_cover(my_data.nearest_cover[1])
  end
  if l_2_1 ~= "inactive" then
    l_2_0.unit:brain():set_update_enabled_state(true)
  end
  if my_data.tied then
    managers.groupai:state():on_enemy_untied(l_2_0.unit:key())
  end
  managers.groupai:state():unregister_rescueable_hostage(l_2_0.key)
  CopLogicIntimidated._unregister_harassment_SO(l_2_0, my_data)
  if my_data.surrender_clbk_registered then
    managers.groupai:state():remove_from_surrendered(l_2_0.unit)
  end
  if my_data.is_hostage then
    managers.groupai:state():on_hostage_state(false, l_2_0.key, true)
  end
  l_2_0.unit:interaction():set_active(false, true, false)
end

CopLogicIntimidated.death_clbk = function(l_3_0, l_3_1)
  CopLogicIntimidated.super.death_clbk(l_3_0, l_3_1)
end

CopLogicIntimidated.queued_update = function(l_4_0, l_4_1)
  local my_data = l_4_1.internal_data
  CopLogicIntimidated._update_enemy_detection(l_4_1, my_data)
  if my_data ~= l_4_1.internal_data then
    return 
  end
  managers.groupai:state():add_to_surrendered(l_4_1.unit, callback(CopLogicIntimidated, CopLogicIntimidated, "queued_update", l_4_1))
end

CopLogicIntimidated._update_enemy_detection = function(l_5_0, l_5_1)
  local robbers = managers.groupai:state():all_criminals()
  local my_tracker = l_5_0.unit:movement():nav_tracker()
  local chk_vis_func = my_tracker.check_visibility
  local fight = not l_5_1.tied
  if not l_5_1.surrender_break_t or l_5_0.t < l_5_1.surrender_break_t then
    for u_key,u_data in pairs(robbers) do
      if not u_data.is_deployable and chk_vis_func(my_tracker, u_data.tracker) then
        local crim_unit = u_data.unit
        local crim_pos = u_data.m_pos
        local dis = mvector3.direction(tmp_vec1, l_5_0.m_pos, crim_pos)
        if dis < tweak_data.player.long_dis_interaction.intimidate_range_enemies * tweak_data.upgrades.values.player.intimidate_range_mul[1] * 1.0499999523163 then
          local crim_fwd = crim_unit:movement():m_head_rot():y()
          mvector3.set_z(crim_fwd, 0)
          mvector3.normalize(crim_fwd)
          if mvector3.dot(crim_fwd, tmp_vec1) < -0.20000000298023 then
            local vis_ray = World:raycast("ray", l_5_0.unit:movement():m_head_pos(), u_data.m_det_pos, "slot_mask", l_5_0.visibility_slotmask, "ray_type", "ai_vision", "report")
            if not vis_ray then
              fight = nil
          end
        end
      end
    end
  end
  if fight then
    l_5_1.surrender_clbk_registered = nil
    local new_action = {type = "act", variant = "idle", body_part = 1}
    l_5_0.unit:brain():action_request(new_action)
    l_5_0.unit:brain():set_logic("idle")
  end
end

CopLogicIntimidated.action_complete_clbk = function(l_6_0, l_6_1)
  local my_data = l_6_0.internal_data
  local action_type = l_6_1:type()
  if action_type == "act" then
    if my_data.being_harassed then
      my_data.being_harassed = nil
      CopLogicIntimidated._add_delayed_rescue_SO(l_6_0, my_data)
    elseif my_data.act_action then
      my_data.act_action = nil
    end
  end
  l_6_0.unit:brain():set_update_enabled_state(true)
end

CopLogicIntimidated.update = function(l_7_0)
  if l_7_0.unit:anim_data().surrender then
    return 
  end
  if not l_7_0.unit:movement():chk_action_forbidden("walk") then
    CopLogicIntimidated._start_action_hands_up(l_7_0)
    l_7_0.unit:brain():set_update_enabled_state(false)
  end
end

CopLogicIntimidated.can_activate = function()
  return false
end

CopLogicIntimidated.on_intimidated = function(l_9_0, l_9_1, l_9_2)
  local my_data = l_9_0.internal_data
  if not my_data.tied then
    if l_9_0.char_tweak.surrender_break_time then
      my_data.surrender_break_t = l_9_0.t + math.random(l_9_0.char_tweak.surrender_break_time[1], l_9_0.char_tweak.surrender_break_time[2], math.random())
    end
    local anim_data = (l_9_0.unit:anim_data())
    local anim, blocks = nil, nil
    if anim_data.hands_up then
      anim = "hands_back"
      blocks = {light_hurt = -1, hurt = -1, heavy_hurt = -1, action = -1, walk = -1}
    elseif anim_data.hands_back then
      anim = "tied"
      blocks = {light_hurt = -1, hurt = -1, heavy_hurt = -1, hurt_sick = -1, action = -1, walk = -1}
    else
      anim = "hands_up"
      blocks = {light_hurt = -1, hurt = -1, heavy_hurt = -1, action = -1, walk = -1}
    end
    local action_data = {type = "act", body_part = 1, variant = anim, clamp_to_graph = true, blocks = blocks}
    local act_action = l_9_0.unit:brain():action_request(action_data)
    if l_9_0.unit:anim_data().hands_tied then
      CopLogicIntimidated._do_tied(l_9_0, l_9_2)
    end
  end
end

CopLogicIntimidated._register_harassment_SO = function(l_10_0, l_10_1)
  local objective_pos = l_10_0.unit:position() - l_10_0.unit:rotation():y() * 100
  local objective_rot = l_10_0.unit:rotation()
  {type = "act", pos = objective_pos, rot = objective_rot, interrupt_dis = 700, interrupt_health = 0.85000002384186, stance = "hos"}.scan = true
   -- DECOMPILER ERROR: Confused about usage of registers!

  {type = "act", pos = objective_pos, rot = objective_rot, interrupt_dis = 700, interrupt_health = 0.85000002384186, stance = "hos"}.nav_seg = l_10_0.unit:movement():nav_tracker():nav_segment()
   -- DECOMPILER ERROR: Confused about usage of registers!

  {type = "act", pos = objective_pos, rot = objective_rot, interrupt_dis = 700, interrupt_health = 0.85000002384186, stance = "hos"}.action_start_clbk = callback(CopLogicIntimidated, CopLogicIntimidated, "on_harassment_SO_action_start", l_10_0)
   -- DECOMPILER ERROR: Confused about usage of registers!

  {type = "act", pos = objective_pos, rot = objective_rot, interrupt_dis = 700, interrupt_health = 0.85000002384186, stance = "hos"}.fail_clbk = callback(CopLogicIntimidated, CopLogicIntimidated, "on_harassment_SO_failed", l_10_0)
   -- DECOMPILER ERROR: Confused about usage of registers!

  {type = "act", pos = objective_pos, rot = objective_rot, interrupt_dis = 700, interrupt_health = 0.85000002384186, stance = "hos"}.action = {type = "act", variant = "kick_fwd", body_part = 1, blocks = {action = -1, walk = -1}}
   -- DECOMPILER ERROR: Confused at declaration of local variable

   -- DECOMPILER ERROR: Confused about usage of registers!

  {objective = {type = "act", pos = objective_pos, rot = objective_rot, interrupt_dis = 700, interrupt_health = 0.85000002384186, stance = "hos"}, base_chance = 1}.chance_inc = 0
   -- DECOMPILER ERROR: Confused about usage of registers!

  {objective = {type = "act", pos = objective_pos, rot = objective_rot, interrupt_dis = 700, interrupt_health = 0.85000002384186, stance = "hos"}, base_chance = 1}.interval = 10
   -- DECOMPILER ERROR: Confused about usage of registers!

  {objective = {type = "act", pos = objective_pos, rot = objective_rot, interrupt_dis = 700, interrupt_health = 0.85000002384186, stance = "hos"}, base_chance = 1}.search_dis_sq = 2250000
   -- DECOMPILER ERROR: Confused about usage of registers!

  {objective = {type = "act", pos = objective_pos, rot = objective_rot, interrupt_dis = 700, interrupt_health = 0.85000002384186, stance = "hos"}, base_chance = 1}.search_pos = mvector3.copy(l_10_0.m_pos)
   -- DECOMPILER ERROR: Confused about usage of registers!

  {objective = {type = "act", pos = objective_pos, rot = objective_rot, interrupt_dis = 700, interrupt_health = 0.85000002384186, stance = "hos"}, base_chance = 1}.usage_amount = 1
   -- DECOMPILER ERROR: Confused about usage of registers!

  {objective = {type = "act", pos = objective_pos, rot = objective_rot, interrupt_dis = 700, interrupt_health = 0.85000002384186, stance = "hos"}, base_chance = 1}.AI_group = "friendlies"
   -- DECOMPILER ERROR: Confused about usage of registers!

  {objective = {type = "act", pos = objective_pos, rot = objective_rot, interrupt_dis = 700, interrupt_health = 0.85000002384186, stance = "hos"}, base_chance = 1}.admin_clbk = callback(CopLogicIntimidated, CopLogicIntimidated, "on_harassment_SO_administered", l_10_0)
   -- DECOMPILER ERROR: Confused at declaration of local variable

  do
     -- DECOMPILER ERROR: Confused at declaration of local variable

    l_10_1.harassment_SO_id = "harass" .. tostring(l_10_0.unit:key())
     -- DECOMPILER ERROR: Confused about usage of registers!

     -- DECOMPILER ERROR: Confused about usage of registers!

    managers.groupai:state():add_special_objective("harass" .. tostring(l_10_0.unit:key()), {objective = {type = "act", pos = objective_pos, rot = objective_rot, interrupt_dis = 700, interrupt_health = 0.85000002384186, stance = "hos"}, base_chance = 1})
  end
   -- DECOMPILER ERROR: Confused about usage of registers for local variables.

end

CopLogicIntimidated.on_harassment_SO_administered = function(l_11_0, l_11_1, l_11_2)
  local my_data = l_11_1.internal_data
  my_data.harassment_SO_id = nil
end

CopLogicIntimidated.on_harassment_SO_action_start = function(l_12_0, l_12_1, l_12_2)
  local my_data = l_12_1.internal_data
  local action = {type = "act", variant = "harassed_kicked_from_behind", body_part = 1, blocks = {action = -1, walk = -1, light_hurt = -1, hurt = -1, heavy_hurt = -1}}
  my_data.being_harassed = l_12_1.unit:movement():action_request(action)
  managers.groupai:state():on_occasional_event("cop_harassment")
  CopLogicIntimidated._unregister_rescue_SO(l_12_1, my_data)
end

CopLogicIntimidated.on_harassment_SO_failed = function(l_13_0, l_13_1, l_13_2)
  local my_data = l_13_1.internal_data
  if my_data.being_harassed then
    local action_data = {type = "act", body_part = 1, variant = "tied", blocks = {light_hurt = -1, hurt = -1, heavy_hurt = -1, walk = -1}}
    l_13_1.unit:brain():action_request(action_data)
    my_data.being_harassed = nil
  end
end

CopLogicIntimidated._unregister_harassment_SO = function(l_14_0, l_14_1)
  local my_data = l_14_0.internal_data
  if my_data.harassment_SO_id then
    managers.groupai:state():remove_special_objective(my_data.harassment_SO_id)
    my_data.harassment_SO_id = nil
  end
end

CopLogicIntimidated._do_tied = function(l_15_0, l_15_1)
  local my_data = l_15_0.internal_data
  if my_data.surrender_clbk_registered then
    managers.groupai:state():remove_from_surrendered(l_15_0.unit)
    my_data.surrender_clbk_registered = nil
  end
  my_data.tied = true
  l_15_0.unit:inventory():destroy_all_items()
  l_15_0.unit:brain():set_update_enabled_state(false)
  if my_data.update_task_key then
    managers.enemy:unqueue_task(my_data.update_task_key)
    my_data.update_task_key = nil
  end
  local rsrv_pos = my_data.rsrv_pos
  if rsrv_pos.stand then
    managers.navigation:unreserve_pos(rsrv_pos.stand)
    rsrv_pos.stand = nil
  end
  managers.groupai:state():on_enemy_tied(l_15_0.unit:key())
  l_15_0.unit:base():set_slot(l_15_0.unit, 22)
  l_15_0.unit:interaction():set_tweak_data("hostage_convert")
  l_15_0.unit:interaction():set_active(true, true, false)
  my_data.is_hostage = true
  managers.groupai:state():on_hostage_state(true, l_15_0.key, true)
  if l_15_1 then
    l_15_0.unit:character_damage():drop_pickup()
    l_15_0.unit:character_damage():set_pickup(nil)
    if l_15_1 == managers.player:player_unit() then
      managers.statistics:tied({name = l_15_0.unit:base()._tweak_table})
    else
      l_15_1:network():send_to_unit({"statistics_tied", l_15_0.unit:base()._tweak_table})
    end
  end
end

CopLogicIntimidated.on_detected_enemy_destroyed = function(l_16_0, l_16_1)
  CopLogicIdle.on_detected_enemy_destroyed(l_16_0, l_16_1)
end

CopLogicIntimidated.on_criminal_neutralized = function(l_17_0, l_17_1)
  CopLogicIdle.on_criminal_neutralized(l_17_0, l_17_1)
end

CopLogicIntimidated.on_alert = function(l_18_0, l_18_1)
  local alert_unit = l_18_1[5]
  if alert_unit and alert_unit:in_slot(l_18_0.enemy_slotmask) then
    local att_obj_data, is_new = CopLogicBase.identify_attention_obj_instant(l_18_0, alert_unit:key())
    if not att_obj_data then
      return 
    end
    local alert_type = l_18_1[1]
    if alert_type == "bullet" or alert_type == "aggression" then
      att_obj_data.alert_t = TimerManager:game():time()
    end
    if att_obj_data.criminal_record then
      managers.groupai:state():criminal_spotted(alert_unit)
      if alert_type == "bullet" or alert_type == "aggression" then
        managers.groupai:state():report_aggression(alert_unit)
      end
    end
  end
end

CopLogicIntimidated.is_available_for_assignment = function(l_19_0, l_19_1)
  if l_19_1 and l_19_1.forced then
    return true
  end
  return false
end

CopLogicIntimidated._add_delayed_rescue_SO = function(l_20_0, l_20_1)
  if l_20_0.char_tweak.flee_type ~= "hide" then
    if l_20_0.unit:unit_data() and l_20_0.unit:unit_data().not_rescued then
      do return end
    end
    if l_20_1.delayed_clbks and l_20_1.delayed_clbks[l_20_1.delayed_rescue_SO_id] then
      managers.enemy:reschedule_delayed_clbk(l_20_1.delayed_rescue_SO_id, TimerManager:game():time() + 10)
    elseif l_20_1.rescuer then
      local objective = l_20_1.rescuer:brain():objective()
      local rescuer = l_20_1.rescuer
      l_20_1.rescuer = nil
      managers.groupai:state():on_objective_failed(rescuer, objective)
    elseif l_20_1.rescue_SO_id then
      managers.groupai:state():remove_special_objective(l_20_1.rescue_SO_id)
      l_20_1.rescue_SO_id = nil
    end
    l_20_1.delayed_rescue_SO_id = "rescue" .. tostring(l_20_0.unit:key())
    CopLogicBase.add_delayed_clbk(l_20_1, l_20_1.delayed_rescue_SO_id, callback(CopLogicIntimidated, CopLogicIntimidated, "register_rescue_SO", l_20_0), TimerManager:game():time() + 10)
  end
end

CopLogicIntimidated.register_rescue_SO = function(l_21_0, l_21_1)
  local my_data = l_21_1.internal_data
  CopLogicBase.on_delayed_clbk(my_data, my_data.delayed_rescue_SO_id)
  my_data.delayed_rescue_SO_id = nil
  local my_tracker = l_21_1.unit:movement():nav_tracker()
  local objective_pos = my_tracker:field_position()
  local followup_objective = {type = "act", stance = "hos", scan = true, action = {type = "act", variant = "idle", body_part = 1, blocks = {action = -1, walk = -1}}, action_duration = tweak_data.interaction.free.timer}
  {type = "act", follow_unit = l_21_1.unit, pos = mvector3.copy(objective_pos), destroy_clbk_key = false, interrupt_dis = 700, interrupt_health = 0.85000002384186, stance = "hos", scan = true, nav_seg = l_21_1.unit:movement():nav_tracker():nav_segment(), fail_clbk = callback(CopLogicIntimidated, CopLogicIntimidated, "on_rescue_SO_failed", l_21_1), complete_clbk = callback(CopLogicIntimidated, CopLogicIntimidated, "on_rescue_SO_completed", l_21_1), action = {type = "act", variant = "untie", body_part = 1, blocks = {action = -1, walk = -1}}}.action_duration = tweak_data.interaction.free.timer
   -- DECOMPILER ERROR: Confused about usage of registers!

  {type = "act", follow_unit = l_21_1.unit, pos = mvector3.copy(objective_pos), destroy_clbk_key = false, interrupt_dis = 700, interrupt_health = 0.85000002384186, stance = "hos", scan = true, nav_seg = l_21_1.unit:movement():nav_tracker():nav_segment(), fail_clbk = callback(CopLogicIntimidated, CopLogicIntimidated, "on_rescue_SO_failed", l_21_1), complete_clbk = callback(CopLogicIntimidated, CopLogicIntimidated, "on_rescue_SO_completed", l_21_1), action = {type = "act", variant = "untie", body_part = 1, blocks = {action = -1, walk = -1}}}.followup_objective = followup_objective
   -- DECOMPILER ERROR: Confused at declaration of local variable

   -- DECOMPILER ERROR: Confused about usage of registers!

  {objective = {type = "act", follow_unit = l_21_1.unit, pos = mvector3.copy(objective_pos), destroy_clbk_key = false, interrupt_dis = 700, interrupt_health = 0.85000002384186, stance = "hos", scan = true, nav_seg = l_21_1.unit:movement():nav_tracker():nav_segment(), fail_clbk = callback(CopLogicIntimidated, CopLogicIntimidated, "on_rescue_SO_failed", l_21_1), complete_clbk = callback(CopLogicIntimidated, CopLogicIntimidated, "on_rescue_SO_completed", l_21_1), action = {type = "act", variant = "untie", body_part = 1, blocks = {action = -1, walk = -1}}}, base_chance = 1, chance_inc = 0, interval = 10}.search_dis_sq = 1000000
   -- DECOMPILER ERROR: Confused about usage of registers!

  {objective = {type = "act", follow_unit = l_21_1.unit, pos = mvector3.copy(objective_pos), destroy_clbk_key = false, interrupt_dis = 700, interrupt_health = 0.85000002384186, stance = "hos", scan = true, nav_seg = l_21_1.unit:movement():nav_tracker():nav_segment(), fail_clbk = callback(CopLogicIntimidated, CopLogicIntimidated, "on_rescue_SO_failed", l_21_1), complete_clbk = callback(CopLogicIntimidated, CopLogicIntimidated, "on_rescue_SO_completed", l_21_1), action = {type = "act", variant = "untie", body_part = 1, blocks = {action = -1, walk = -1}}}, base_chance = 1, chance_inc = 0, interval = 10}.search_pos = mvector3.copy(l_21_1.m_pos)
   -- DECOMPILER ERROR: Confused about usage of registers!

  {objective = {type = "act", follow_unit = l_21_1.unit, pos = mvector3.copy(objective_pos), destroy_clbk_key = false, interrupt_dis = 700, interrupt_health = 0.85000002384186, stance = "hos", scan = true, nav_seg = l_21_1.unit:movement():nav_tracker():nav_segment(), fail_clbk = callback(CopLogicIntimidated, CopLogicIntimidated, "on_rescue_SO_failed", l_21_1), complete_clbk = callback(CopLogicIntimidated, CopLogicIntimidated, "on_rescue_SO_completed", l_21_1), action = {type = "act", variant = "untie", body_part = 1, blocks = {action = -1, walk = -1}}}, base_chance = 1, chance_inc = 0, interval = 10}.usage_amount = 1
   -- DECOMPILER ERROR: Confused about usage of registers!

  {objective = {type = "act", follow_unit = l_21_1.unit, pos = mvector3.copy(objective_pos), destroy_clbk_key = false, interrupt_dis = 700, interrupt_health = 0.85000002384186, stance = "hos", scan = true, nav_seg = l_21_1.unit:movement():nav_tracker():nav_segment(), fail_clbk = callback(CopLogicIntimidated, CopLogicIntimidated, "on_rescue_SO_failed", l_21_1), complete_clbk = callback(CopLogicIntimidated, CopLogicIntimidated, "on_rescue_SO_completed", l_21_1), action = {type = "act", variant = "untie", body_part = 1, blocks = {action = -1, walk = -1}}}, base_chance = 1, chance_inc = 0, interval = 10}.AI_group = "enemies"
   -- DECOMPILER ERROR: Confused about usage of registers!

  {objective = {type = "act", follow_unit = l_21_1.unit, pos = mvector3.copy(objective_pos), destroy_clbk_key = false, interrupt_dis = 700, interrupt_health = 0.85000002384186, stance = "hos", scan = true, nav_seg = l_21_1.unit:movement():nav_tracker():nav_segment(), fail_clbk = callback(CopLogicIntimidated, CopLogicIntimidated, "on_rescue_SO_failed", l_21_1), complete_clbk = callback(CopLogicIntimidated, CopLogicIntimidated, "on_rescue_SO_completed", l_21_1), action = {type = "act", variant = "untie", body_part = 1, blocks = {action = -1, walk = -1}}}, base_chance = 1, chance_inc = 0, interval = 10}.admin_clbk = callback(CopLogicIntimidated, CopLogicIntimidated, "on_rescue_SO_administered", l_21_1)
   -- DECOMPILER ERROR: Confused about usage of registers!

  {objective = {type = "act", follow_unit = l_21_1.unit, pos = mvector3.copy(objective_pos), destroy_clbk_key = false, interrupt_dis = 700, interrupt_health = 0.85000002384186, stance = "hos", scan = true, nav_seg = l_21_1.unit:movement():nav_tracker():nav_segment(), fail_clbk = callback(CopLogicIntimidated, CopLogicIntimidated, "on_rescue_SO_failed", l_21_1), complete_clbk = callback(CopLogicIntimidated, CopLogicIntimidated, "on_rescue_SO_completed", l_21_1), action = {type = "act", variant = "untie", body_part = 1, blocks = {action = -1, walk = -1}}}, base_chance = 1, chance_inc = 0, interval = 10}.verification_clbk = callback(CopLogicIntimidated, CopLogicIntimidated, "rescue_SO_verification")
   -- DECOMPILER ERROR: Confused at declaration of local variable

  do
     -- DECOMPILER ERROR: Confused at declaration of local variable

    my_data.rescue_SO_id = "rescue" .. tostring(l_21_1.unit:key())
     -- DECOMPILER ERROR: Confused about usage of registers!

     -- DECOMPILER ERROR: Confused about usage of registers!

    managers.groupai:state():add_special_objective("rescue" .. tostring(l_21_1.unit:key()), {objective = {type = "act", follow_unit = l_21_1.unit, pos = mvector3.copy(objective_pos), destroy_clbk_key = false, interrupt_dis = 700, interrupt_health = 0.85000002384186, stance = "hos", scan = true, nav_seg = l_21_1.unit:movement():nav_tracker():nav_segment(), fail_clbk = callback(CopLogicIntimidated, CopLogicIntimidated, "on_rescue_SO_failed", l_21_1), complete_clbk = callback(CopLogicIntimidated, CopLogicIntimidated, "on_rescue_SO_completed", l_21_1), action = {type = "act", variant = "untie", body_part = 1, blocks = {action = -1, walk = -1}}}, base_chance = 1, chance_inc = 0, interval = 10})
  end
   -- DECOMPILER ERROR: Confused about usage of registers for local variables.

end

CopLogicIntimidated._unregister_rescue_SO = function(l_22_0, l_22_1)
  if l_22_1.rescuer then
    local rescuer = l_22_1.rescuer
    l_22_1.rescuer = nil
    managers.groupai:state():on_objective_failed(rescuer, rescuer:brain():objective())
  elseif l_22_1.rescue_SO_id then
    managers.groupai:state():remove_special_objective(l_22_1.rescue_SO_id)
    l_22_1.rescue_SO_id = nil
  elseif l_22_1.delayed_rescue_SO_id then
    CopLogicBase.chk_cancel_delayed_clbk(l_22_1, l_22_1.delayed_rescue_SO_id)
  end
end

CopLogicIntimidated.on_rescue_SO_administered = function(l_23_0, l_23_1, l_23_2)
  local my_data = l_23_1.internal_data
  my_data.rescuer = l_23_2
  my_data.rescue_SO_id = nil
end

CopLogicIntimidated.rescue_SO_verification = function(l_24_0, l_24_1)
  return tweak_data.character[l_24_1:base()._tweak_table].rescue_hostages
end

CopLogicIntimidated.on_rescue_SO_failed = function(l_25_0, l_25_1)
  local my_data = l_25_1.internal_data
  if my_data.rescuer then
    my_data.rescuer = nil
    my_data.delayed_rescue_SO_id = "rescue" .. tostring(l_25_1.unit:key())
    CopLogicBase.add_delayed_clbk(my_data, my_data.delayed_rescue_SO_id, callback(CopLogicIntimidated, CopLogicIntimidated, "register_rescue_SO", l_25_1), TimerManager:game():time() + 10)
  end
end

CopLogicIntimidated.on_rescue_SO_completed = function(l_26_0, l_26_1, l_26_2)
  if not l_26_1.unit:inventory():equipped_unit() then
    if l_26_1.unit:inventory():num_selections() <= 0 then
      local weap_name = l_26_1.unit:base():default_weapon_name()
      if weap_name then
        l_26_1.unit:inventory():add_unit_by_name(weap_name, true, true)
      else
        l_26_1.unit:inventory():equip_selection(1, true)
      end
    end
  end
  if l_26_1.unit:anim_data().hands_tied then
    local new_action = {type = "act", variant = "stand", body_part = 1}
    l_26_1.unit:brain():action_request(new_action)
  end
  CopLogicBase._exit(l_26_1.unit, "idle")
end

CopLogicIntimidated.on_rescue_allowed_state = function(l_27_0, l_27_1)
  if l_27_1 and not l_27_0.unit:anim_data().move then
    CopLogicIntimidated._add_delayed_rescue_SO(l_27_0, l_27_0.internal_data)
    do return end
    CopLogicIntimidated._unregister_rescue_SO(l_27_0, l_27_0.internal_data)
  end
end

CopLogicIntimidated.anim_clbk = function(l_28_0, l_28_1)
  local my_data = l_28_0.internal_data
  if l_28_1 == "harass_end" and my_data.being_harassed then
    my_data.being_harassed = nil
    CopLogicIntimidated._add_delayed_rescue_SO(l_28_0, l_28_0.internal_data)
  end
end

CopLogicIntimidated._start_action_hands_up = function(l_29_0)
  local my_data = l_29_0.internal_data
  local action_data = {type = "act", body_part = 1, variant = "hands_up", clamp_to_graph = true, blocks = {light_hurt = -1, hurt = -1, heavy_hurt = -1, walk = -1}}
  my_data.act_action = l_29_0.unit:brain():action_request(action_data)
end


