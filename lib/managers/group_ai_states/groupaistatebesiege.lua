-- Decompiled using luadec 2.0.1 by sztupy (http://winmo.sztupy.hu)
-- Command line was: F:\SteamLibrary\SteamApps\common\PAYDAY 2\lua\lib\managers\group_ai_states\groupaistatebesiege.luac 

if not GroupAIStateBesiege then
  GroupAIStateBesiege = class(GroupAIStateBase)
end
GroupAIStateBesiege._MAX_SIMULTANEOUS_SPAWNS = 3
GroupAIStateBesiege.init = function(l_1_0)
  GroupAIStateBesiege.super.init(l_1_0)
  if Network:is_server() and not l_1_0._police_upd_task_queued and managers.navigation:is_data_ready() then
    l_1_0:_queue_police_upd_task()
  end
end

GroupAIStateBesiege._init_misc_data = function(l_2_0)
  GroupAIStateBesiege.super:_init_misc_data(l_2_0)
  if managers.navigation:is_data_ready() then
    l_2_0._nr_dynamic_waves = 0
    l_2_0._nr_waves = 0
    l_2_0:_create_area_data()
    l_2_0._task_data = {}
    l_2_0._task_data.reenforce = {tasks = {}, next_dispatch_t = 0}
    l_2_0._task_data.recon = {tasks = {}, next_dispatch_t = 0}
    l_2_0._task_data.assault = {disabled = true, is_first = true}
    l_2_0._task_data.regroup = {}
    local all_areas = l_2_0._area_data
    for u_key,u_data in pairs(l_2_0._police) do
      if not u_data.assigned_area then
        local nav_seg = u_data.unit:movement():nav_tracker():nav_segment()
        l_2_0:set_enemy_assigned(l_2_0:get_area_from_nav_seg_id(nav_seg), u_key)
      end
    end
  end
end

GroupAIStateBesiege.update = function(l_3_0, l_3_1, l_3_2)
  GroupAIStateBesiege.super.update(l_3_0, l_3_1, l_3_2)
  if Network:is_server() then
    if not l_3_0._police_upd_task_queued then
      l_3_0:_queue_police_upd_task()
    end
    if managers.navigation:is_data_ready() and l_3_0._draw_enabled then
      l_3_0:_draw_enemy_activity(l_3_1)
      l_3_0:_draw_spawn_points()
    end
  end
end

GroupAIStateBesiege.paused_update = function(l_4_0, l_4_1, l_4_2)
  GroupAIStateBesiege.super.paused_update(l_4_0, l_4_1, l_4_2)
  if Network:is_server() and managers.navigation:is_data_ready() and l_4_0._draw_enabled then
    l_4_0:_draw_enemy_activity(l_4_1)
    l_4_0:_draw_spawn_points()
  end
end

GroupAIStateBesiege._queue_police_upd_task = function(l_5_0)
  l_5_0._police_upd_task_queued = true
  managers.enemy:queue_task("GroupAIStateBesiege._upd_police_activity", GroupAIStateBesiege._upd_police_activity, l_5_0, l_5_0._t + 2)
end

GroupAIStateBesiege.assign_enemy_to_group_ai = function(l_6_0, l_6_1)
  local u_tracker = l_6_1:movement():nav_tracker()
  local seg = u_tracker:nav_segment()
  local area = l_6_0:get_area_from_nav_seg_id(seg)
  local u_name = (l_6_1:name())
  local u_category = nil
  for cat_name,category in pairs(tweak_data.group_ai.unit_categories) do
    for _,test_u_name in ipairs(category.units) do
      if u_name == test_u_name then
        u_category = cat_name
        for (for control),cat_name in (for generator) do
        end
      end
    end
    local group_desc = {type = u_category or "custom", size = 1}
    local group = (l_6_0:_create_group(group_desc))
    local grp_objective = nil
    local objective = l_6_1:brain():objective()
    do
      local grp_obj_type = l_6_0._task_data.assault.active and "assault_area" or "recon_area"
      if not objective.area and (not objective.nav_seg or not l_6_0:get_area_from_nav_seg_id(objective.nav_seg)) then
        grp_objective = {type = grp_obj_type, area = not objective or area}
        objective.grp_objective = grp_objective
        do return end
        grp_objective = {type = grp_obj_type, area = area}
        grp_objective.moving_out = false
        group.objective = grp_objective
        group.has_spawned = true
        l_6_0:_add_group_member(group, l_6_1:key())
        l_6_0:set_enemy_assigned(area, l_6_1:key())
      end
       -- Warning: missing end command somewhere! Added here
    end
     -- Warning: missing end command somewhere! Added here
  end
end

GroupAIStateBesiege.on_enemy_unregistered = function(l_7_0, l_7_1)
  GroupAIStateBesiege.super.on_enemy_unregistered(l_7_0, l_7_1)
  if l_7_0._is_server then
    l_7_0:set_enemy_assigned(nil, l_7_1:key())
    local objective = l_7_1:brain():objective()
    if objective and objective.fail_clbk then
      local fail_clbk = objective.fail_clbk
      objective.fail_clbk = nil
      fail_clbk(l_7_1)
    end
  end
end

GroupAIStateBesiege._upd_police_activity = function(l_8_0)
  l_8_0._police_upd_task_queued = false
  if l_8_0._ai_enabled then
    l_8_0:_upd_SO()
    if l_8_0._enemy_weapons_hot then
      l_8_0:_claculate_drama_value()
      l_8_0:_upd_regroup_task()
      l_8_0:_upd_reenforce_tasks()
      l_8_0:_upd_recon_tasks()
      l_8_0:_upd_assault_task()
      l_8_0:_begin_new_tasks()
      l_8_0:_upd_group_spawning()
      l_8_0:_upd_groups()
    end
  end
  l_8_0:_queue_police_upd_task()
end

GroupAIStateBesiege._upd_SO = function(l_9_0)
  local t = l_9_0._t
  local trash = nil
  for id,so in pairs(l_9_0._special_objectives) do
    if so.delay_t < t then
      so.delay_t = t + so.data.interval
      if math.random() <= so.chance then
        local so_data = so.data
        so.chance = so_data.base_chance
        if so_data.objective.follow_unit and not alive(so_data.objective.follow_unit) then
          if not trash then
            trash = {}
          end
          table.insert(trash, id)
        else
          local closest_u_data = GroupAIStateBase._execute_so(l_9_0, so_data, so.rooms, so.administered)
          if closest_u_data then
            if so.remaining_usage then
              if so.remaining_usage == 1 then
                if not trash then
                  trash = {}
                end
                table.insert(trash, id)
              else
                so.remaining_usage = so.remaining_usage - 1
              end
            end
            if so.non_repeatable then
              so.administered[closest_u_data.unit:key()] = true
            else
              so.chance = so.chance + so.data.chance_inc
            end
          end
        end
      end
      if so.data.interval < 0 then
        if not trash then
          trash = {}
        end
        table.insert(trash, id)
      end
    end
  end
  if trash then
    for _,so_id in ipairs(trash) do
      l_9_0:remove_special_objective(so_id)
    end
  end
end

GroupAIStateBesiege._begin_new_tasks = function(l_10_0)
  local all_areas = l_10_0._area_data
  local nav_manager = managers.navigation
  local all_nav_segs = nav_manager._nav_segments
  local task_data = l_10_0._task_data
  local t = l_10_0._t
  local reenforce_candidates = nil
  local reenforce_data = task_data.reenforce
  if reenforce_data.next_dispatch_t and reenforce_data.next_dispatch_t < t then
    reenforce_candidates = {}
  end
  local recon_candidates, are_recon_candidates_safe = nil, nil
  local recon_data = task_data.recon
  if recon_data.next_dispatch_t and recon_data.next_dispatch_t < t and not task_data.assault.active and not task_data.regroup.active then
    recon_candidates = {}
  end
  local assault_candidates = nil
  local assault_data = task_data.assault
  if l_10_0._difficulty_value > 0 and assault_data.next_dispatch_t and assault_data.next_dispatch_t < t and not task_data.regroup.active then
    assault_candidates = {}
  end
  if not reenforce_candidates and not recon_candidates and not assault_candidates then
    return 
  end
  local found_areas = {}
  local to_search_areas = {}
  for area_id,area in pairs(all_areas) do
    if area.spawn_points then
      for _,sp_data in pairs(area.spawn_points) do
        if sp_data.delay_t <= t and not all_nav_segs[sp_data.nav_seg].disabled then
          table.insert(to_search_areas, area)
          found_areas[area_id] = true
      else
        end
      end
      if not found_areas[area_id] and area.spawn_groups then
        for _,sp_data in pairs(area.spawn_groups) do
          if sp_data.delay_t <= t and not all_nav_segs[sp_data.nav_seg].disabled then
            table.insert(to_search_areas, area)
            found_areas[area_id] = true
            for (for control),area_id in (for generator) do
            end
          end
        end
      end
      if #to_search_areas == 0 then
        return 
      end
      if assault_candidates and l_10_0._hunt_mode then
        for criminal_key,criminal_data in pairs(l_10_0._criminals) do
          if not criminal_data.status then
            local nav_seg = criminal_data.tracker:nav_segment()
            local area = l_10_0:get_area_from_nav_seg_id(nav_seg)
            found_areas[area] = true
            table.insert(assault_candidates, area)
          end
        end
      end
      local i = 1
      repeat
        local area = to_search_areas[i]
        local force_factor = area.factors.force
        if force_factor then
          local demand = force_factor.force
        end
        local nr_police = table.size(area.police.units)
        do
          local nr_criminals = table.size(area.criminal.units)
          if reenforce_candidates and demand and demand > 0 and nr_criminals == 0 then
            local area_free = true
            for i_task,reenforce_task_data in ipairs(reenforce_data.tasks) do
              if reenforce_task_data.target_area == area then
                area_free = false
            else
              end
            end
            if area_free then
              table.insert(reenforce_candidates, area)
            end
          end
          if recon_candidates and (area.loot or area.hostages) then
            local occupied = nil
            for group_id,group in pairs(l_10_0._groups) do
              if group.objective.target_area == area or group.objective.area == area then
                occupied = true
            else
              end
            end
            if nr_criminals ~= 0 then
              local is_area_safe = occupied
            end
            if is_area_safe then
              if are_recon_candidates_safe then
                table.insert(recon_candidates, area)
              else
                are_recon_candidates_safe = true
                recon_candidates = {area}
              end
            elseif not are_recon_candidates_safe then
              table.insert(recon_candidates, area)
            end
          end
        end
        if assault_candidates then
          for criminal_key,_ in pairs(area.criminal.units) do
            if not l_10_0._criminals[criminal_key].status then
              table.insert(assault_candidates, area)
          else
            end
          end
          if nr_criminals == 0 then
            for neighbour_area_id,neighbour_area in pairs(area.neighbours) do
              if not found_areas[neighbour_area_id] then
                table.insert(to_search_areas, neighbour_area)
                found_areas[neighbour_area_id] = true
              end
            end
          end
          i = i + 1
        until #to_search_areas < i
      end
      if assault_candidates and #assault_candidates > 0 then
        l_10_0:_begin_assault_task(assault_candidates)
        recon_candidates = nil
      end
      if recon_candidates and #recon_candidates > 0 then
        local recon_area = recon_candidates[math.random(#recon_candidates)]
        l_10_0:_begin_recon_task(recon_area)
      end
      if reenforce_candidates and #reenforce_candidates > 0 then
        local lucky_i_candidate = math.random(#reenforce_candidates)
        local reenforce_area = reenforce_candidates[lucky_i_candidate]
        l_10_0:_begin_reenforce_task(reenforce_area)
        recon_candidates = nil
      end
       -- Warning: missing end command somewhere! Added here
    end
     -- Warning: missing end command somewhere! Added here
  end
end

GroupAIStateBesiege._begin_assault_task = function(l_11_0, l_11_1)
  local assault_task = l_11_0._task_data.assault
  assault_task.active = true
  assault_task.next_dispatch_t = nil
  assault_task.target_areas = l_11_1
  assault_task.phase = "anticipation"
  assault_task.start_t = l_11_0._t
  local anticipation_duration = l_11_0:_get_anticipation_duration(tweak_data.group_ai.besiege.assault.anticipation_duration, assault_task.is_first)
  assault_task.is_first = nil
  assault_task.phase_end_t = l_11_0._t + anticipation_duration
  assault_task.force = math.ceil(l_11_0:_get_difficulty_dependent_value(tweak_data.group_ai.besiege.assault.force) * l_11_0:_get_balancing_multiplier(tweak_data.group_ai.besiege.assault.force_balance_mul))
  assault_task.use_smoke = true
  assault_task.use_smoke_timer = 0
  assault_task.use_spawn_event = true
  assault_task.force_spawned = 0
  if l_11_0._hostage_headcount > 0 then
    assault_task.phase_end_t = assault_task.phase_end_t + l_11_0:_get_difficulty_dependent_value(tweak_data.group_ai.besiege.assault.hostage_hesitation_delay)
    assault_task.is_hesitating = true
    assault_task.voice_delay = l_11_0._t + (assault_task.phase_end_t - l_11_0._t) / 2
  end
  l_11_0._downs_during_assault = 0
  if l_11_0._hunt_mode then
    assault_task.phase_end_t = 0
  else
    managers.hud:setup_anticipation(anticipation_duration)
    managers.hud:start_anticipation()
  end
  if l_11_0._draw_drama then
    table.insert(l_11_0._draw_drama.assault_hist, {l_11_0._t})
  end
  l_11_0._task_data.recon.tasks = {}
end

GroupAIStateBesiege._upd_assault_task = function(l_12_0)
  local task_data = l_12_0._task_data.assault
  if not task_data.active then
    return 
  end
  local t = l_12_0._t
  l_12_0:_assign_recon_groups_to_retire()
  local force_pool = l_12_0:_get_difficulty_dependent_value(tweak_data.group_ai.besiege.assault.force_pool) * l_12_0:_get_balancing_multiplier(tweak_data.group_ai.besiege.assault.force_pool_balance_mul)
  if not l_12_0._hunt_mode or not 0 then
    local task_spawn_allowance = force_pool - task_data.force_spawned
  end
  if task_data.phase == "anticipation" then
    if task_spawn_allowance <= 0 then
      task_data.phase = "fade"
      task_data.phase_end_t = t + tweak_data.group_ai.besiege.assault.fade_duration
    elseif task_data.phase_end_t < t or l_12_0._drama_data.zone == "high" then
      managers.mission:call_global_event("start_assault")
      managers.hud:start_assault()
      l_12_0:_set_rescue_state(false)
      task_data.phase = "build"
      task_data.phase_end_t = l_12_0._t + tweak_data.group_ai.besiege.assault.build_duration
      task_data.is_hesitating = nil
      l_12_0:set_assault_mode(true)
      managers.trade:set_trade_countdown(false)
    else
      managers.hud:check_anticipation_voice(task_data.phase_end_t - t)
      managers.hud:check_start_anticipation_music(task_data.phase_end_t - t)
      if task_data.is_hesitating and task_data.voice_delay < l_12_0._t then
        if l_12_0._hostage_headcount > 0 then
          local best_group = nil
          for _,group in pairs(l_12_0._groups) do
            if not best_group or group.objective.type == "reenforce_area" then
              best_group = group
              for (for control),_ in (for generator) do
              end
              if best_group.objective.type ~= "reenforce_area" and group.objective.type ~= "retire" then
                best_group = group
              end
            end
            if best_group and l_12_0:_voice_delay_assault(best_group) then
              task_data.is_hesitating = nil
            else
              task_data.is_hesitating = nil
            end
          elseif task_data.phase == "build" then
            if task_spawn_allowance <= 0 then
              task_data.phase = "fade"
              task_data.phase_end_t = t + tweak_data.group_ai.besiege.assault.fade_duration
            elseif task_data.phase_end_t < t or l_12_0._drama_data.zone == "high" then
              task_data.phase = "sustain"
              task_data.phase_end_t = t + math.lerp(l_12_0:_get_difficulty_dependent_value(tweak_data.group_ai.besiege.assault.sustain_duration_min), l_12_0:_get_difficulty_dependent_value(tweak_data.group_ai.besiege.assault.sustain_duration_max), math.random()) * l_12_0:_get_balancing_multiplier(tweak_data.group_ai.besiege.assault.sustain_duration_balance_mul)
            elseif task_data.phase == "sustain" then
              if task_spawn_allowance <= 0 then
                task_data.phase = "fade"
                task_data.phase_end_t = t + tweak_data.group_ai.besiege.assault.fade_duration
              elseif task_data.phase_end_t < t and not l_12_0._hunt_mode then
                task_data.phase = "fade"
                task_data.phase_end_t = t + tweak_data.group_ai.besiege.assault.fade_duration
              else
                local enemies_left = l_12_0:_count_police_force("assault")
                 -- DECOMPILER ERROR: unhandled construct in 'if'

                 -- DECOMPILER ERROR: unhandled construct in 'if'

                if (enemies_left < 7 or task_data.phase_end_t + 350 < t) and task_data.phase_end_t - 8 < t and not task_data.said_retreat and l_12_0._drama_data.amount < tweak_data.drama.assault_fade_end then
                  task_data.said_retreat = true
                  l_12_0:_police_announce_retreat()
                  do return end
                  if task_data.phase_end_t < t and l_12_0._drama_data.amount < tweak_data.drama.assault_fade_end and l_12_0:_count_criminals_engaged_force(4) <= 3 then
                    task_data.active = nil
                    task_data.phase = nil
                    task_data.said_retreat = nil
                    if l_12_0._draw_drama then
                      l_12_0._draw_drama.assault_hist[#l_12_0._draw_drama.assault_hist][2] = t
                    end
                    managers.mission:call_global_event("end_assault")
                    l_12_0:_begin_regroup_task()
                    return 
                end
              end
            end
          end
        end
      end
    end
    if l_12_0._drama_data.amount <= tweak_data.drama.low then
      for criminal_key,criminal_data in pairs(l_12_0._player_criminals) do
        l_12_0:criminal_spotted(criminal_data.unit)
        for group_id,group in pairs(l_12_0._groups) do
          if group.objective.charge then
            for u_key,u_data in pairs(group.units) do
              u_data.unit:brain():clbk_group_member_attention_identified(nil, criminal_key)
            end
          end
        end
      end
    end
    local primary_target_area = task_data.target_areas[1]
    if l_12_0:is_area_safe(primary_target_area) then
      local target_pos = primary_target_area.pos
      local nearest_area, nearest_dis = nil, nil
      for criminal_key,criminal_data in pairs(l_12_0._player_criminals) do
        if not criminal_data.status then
          local dis = mvector3.distance_sq(target_pos, criminal_data.m_pos)
          if not nearest_dis or dis < nearest_dis then
            nearest_dis = dis
            nearest_area = l_12_0:get_area_from_nav_seg_id(criminal_data.tracker:nav_segment())
          end
        end
      end
      if nearest_area then
        primary_target_area = nearest_area
        task_data.target_areas[1] = nearest_area
      end
    end
    do
      local nr_wanted = task_data.force - l_12_0:_count_police_force("assault")
      if task_data.phase == "anticipation" then
        nr_wanted = nr_wanted - 5
      end
      if nr_wanted > 0 and task_data.phase ~= "fade" then
        local used_event = nil
        if task_data.use_spawn_event and task_data.phase ~= "anticipation" then
          task_data.use_spawn_event = false
          if l_12_0:_try_use_task_spawn_event(t, primary_target_area, "assault") then
            used_event = true
          end
        end
        if not used_event then
          if next(l_12_0._spawning_groups) then
            do return end
          end
          local spawn_group, spawn_group_type = l_12_0:_find_spawn_group_near_area(primary_target_area, nr_wanted, tweak_data.group_ai.besiege.assault.groups, nil, nil, nil)
          if spawn_group then
            local grp_objective = {type = "assault_area", area = spawn_group.area, coarse_path = {{spawn_group.area.pos_nav_seg, spawn_group.area.pos}}, attitude = "avoid", pose = "crouch", stance = "cbt"}
            l_12_0:_spawn_in_group(spawn_group, spawn_group_type, grp_objective, task_data)
          end
        end
      end
      if task_data.phase ~= "anticipation" then
        if task_data.use_smoke_timer < t then
          task_data.use_smoke = true
        end
        if l_12_0._smoke_grenade_queued and task_data.use_smoke and not l_12_0:is_smoke_grenade_active() then
          l_12_0:_detonate_smoke_grenade(l_12_0._smoke_grenade_queued[1], l_12_0._smoke_grenade_queued[1], l_12_0._smoke_grenade_queued[2], l_12_0._smoke_grenade_queued[4])
          if l_12_0._smoke_grenade_queued[3] then
            l_12_0._smoke_grenade_ignore_control = true
          end
        end
      end
      l_12_0:_assign_enemy_groups_to_assault(task_data.phase)
    end
     -- Warning: missing end command somewhere! Added here
  end
end

GroupAIStateBesiege._verify_anticipation_spawn_point = function(l_13_0, l_13_1)
  local sp_nav_seg = l_13_1.nav_seg
  local area = l_13_0:get_area_from_nav_seg_id(sp_nav_seg)
  if area.is_safe then
    return true
  else
    for criminal_key,c_data in pairs(l_13_0._criminals) do
      if not c_data.status and mvector3.distance(l_13_1.pos, c_data.m_pos) < 2500 and math.abs(l_13_1.pos.z - c_data.m_pos.z) < 300 then
        return 
      end
    end
  end
  return true
end

GroupAIStateBesiege.is_smoke_grenade_active = function(l_14_0)
  return not l_14_0._smoke_end_t or Application:time() < l_14_0._smoke_end_t
end

GroupAIStateBesiege._begin_reenforce_task = function(l_15_0, l_15_1)
  local new_task = {target_area = l_15_1, start_t = l_15_0._t, use_spawn_event = true}
  table.insert(l_15_0._task_data.reenforce.tasks, new_task)
  l_15_0._task_data.reenforce.active = true
  l_15_0._task_data.reenforce.next_dispatch_t = l_15_0._t + l_15_0:_get_difficulty_dependent_value(tweak_data.group_ai.besiege.reenforce.interval)
end

GroupAIStateBesiege._begin_recon_task = function(l_16_0, l_16_1)
  local new_task = {target_area = l_16_1, start_t = l_16_0._t, use_spawn_event = true, use_smoke = true}
  table.insert(l_16_0._task_data.recon.tasks, new_task)
  l_16_0._task_data.recon.next_dispatch_t = nil
end

GroupAIStateBesiege._begin_regroup_task = function(l_17_0)
  l_17_0._task_data.regroup.start_t = l_17_0._t
  l_17_0._task_data.regroup.end_t = l_17_0._t + l_17_0:_get_difficulty_dependent_value(tweak_data.group_ai.besiege.regroup.duration)
  l_17_0._task_data.regroup.active = true
  if l_17_0._draw_drama then
    table.insert(l_17_0._draw_drama.regroup_hist, {l_17_0._t})
  end
  l_17_0:_assign_assault_groups_to_retire()
end

GroupAIStateBesiege._end_regroup_task = function(l_18_0)
  if l_18_0._task_data.regroup.active then
    l_18_0._task_data.regroup.active = nil
    managers.trade:set_trade_countdown(true)
    l_18_0:set_assault_mode(false)
    if not l_18_0._smoke_grenade_ignore_control then
      managers.network:session():send_to_peers("sync_smoke_grenade_kill")
      l_18_0:sync_smoke_grenade_kill()
    end
    local dmg = l_18_0._downs_during_assault
    local limits = tweak_data.group_ai.bain_assault_praise_limits
    local result = (dmg < limits[1] and 0) or (dmg < limits[2] and 1) or 2
    managers.hud:end_assault(result)
    l_18_0:_mark_hostage_areas_as_unsafe()
    l_18_0:_set_rescue_state(true)
    if not l_18_0._task_data.assault.next_dispatch_t then
      local assault_delay = tweak_data.group_ai.besiege.assault.delay
      l_18_0._task_data.assault.next_dispatch_t = l_18_0._t + l_18_0:_get_difficulty_dependent_value(assault_delay)
    end
    if l_18_0._draw_drama then
      l_18_0._draw_drama.regroup_hist[#l_18_0._draw_drama.regroup_hist][2] = l_18_0._t
    end
    l_18_0._task_data.recon.next_dispatch_t = l_18_0._t
  end
end

GroupAIStateBesiege._upd_regroup_task = function(l_19_0)
  local regroup_task = l_19_0._task_data.regroup
  if regroup_task.active then
    l_19_0:_assign_assault_groups_to_retire()
    if regroup_task.end_t < l_19_0._t or l_19_0._drama_data.zone == "low" then
      l_19_0:_end_regroup_task()
    end
  end
end

GroupAIStateBesiege._find_nearest_safe_area = function(l_20_0, l_20_1, l_20_2)
  local to_search_areas = {group.objective.area}
  local found_areas = {group.objective.area = "init"}
  repeat
    do
      local search_area = table.remove(to_search_areas, 1)
      if next(search_area.criminal.units) then
        assault_area = search_area
        do return end
      else
        for other_area_id,other_area in pairs(search_area.neighbours) do
          if not found_areas[other_area] then
            table.insert(to_search_areas, other_area)
            found_areas[other_area] = search_area
          end
        end
      end
    until #to_search_areas == 0
  end
  local mvec3_dis_sq = mvector3.distance_sq
  local all_areas = l_20_0._area_data
  local all_nav_segs = managers.navigation._nav_segments
  local all_doors = managers.navigation._room_doors
  local my_enemy_pos, my_enemy_dis_sq = nil, nil
  for c_key,c_data in pairs(l_20_0._criminals) do
    local my_dis = mvec3_dis_sq(l_20_2, c_data.m_pos)
    if (not my_enemy_pos or my_enemy_dis_sq < my_dis) and math.abs(mvector3.z(c_data.m_pos) - mvector3.z(l_20_2)) < 300 then
      my_enemy_pos = c_data.m_pos
      my_enemy_dis_sq = my_dis
    end
  end
  if not my_enemy_pos or my_enemy_dis_sq > 9000000 then
    return 
  end
  local closest_dis, closest_safe_nav_seg_id, closest_area = nil, nil, nil
  local start_neighbours = all_nav_segs[nav_seg_id].neighbours
  for neighbour_seg_id,door_list in pairs(start_neighbours) do
    local neighbour_area = l_20_0:get_area_from_nav_seg_id(neighbour_seg_id)
    if not next(neighbour_area.criminal.units) then
      local neighbour_nav_seg = all_nav_segs[neighbour_seg_id]
      if not neighbour_nav_seg.disabled and my_enemy_dis_sq < mvec3_dis_sq(my_enemy_pos, neighbour_nav_seg.pos) then
        for _,i_door in ipairs(door_list) do
          if type(i_door) == "number" then
            local door = all_doors[i_door]
            local my_dis = mvec3_dis_sq(door.center, l_20_2)
            if not closest_dis or my_dis < closest_dis then
              closest_dis = my_dis
              closest_safe_nav_seg_id = neighbour_seg_id
              closest_area = neighbour_area
            end
          end
        end
      end
    end
  end
  return closest_area, closest_safe_nav_seg_id
end

GroupAIStateBesiege._upd_recon_tasks = function(l_21_0)
  local task_data = l_21_0._task_data.recon.tasks[1]
  l_21_0:_assign_enemy_groups_to_recon()
  if not task_data then
    return 
  end
  local t = l_21_0._t
  l_21_0:_assign_assault_groups_to_retire()
  local target_pos = task_data.target_area.pos
  local nr_wanted = l_21_0:_get_difficulty_dependent_value(tweak_data.group_ai.besiege.recon.force) - l_21_0:_count_police_force("recon")
  if nr_wanted <= 0 then
    return 
  end
  local used_event, used_spawn_points, reassigned = nil, nil, nil
  if task_data.use_spawn_event then
    task_data.use_spawn_event = false
    if l_21_0:_try_use_task_spawn_event(t, task_data.target_area, "recon") then
      used_event = true
    end
  end
  if not used_event then
    local used_group = nil
    if next(l_21_0._spawning_groups) then
      used_group = true
    else
      local spawn_group, spawn_group_type = l_21_0:_find_spawn_group_near_area(task_data.target_area, nr_wanted, tweak_data.group_ai.besiege.recon.groups, nil, nil, callback(l_21_0, l_21_0, "_verify_anticipation_spawn_point"))
      if spawn_group then
        local grp_objective = {type = "recon_area", area = spawn_group.area, target_area = task_data.target_area, attitude = "avoid", stance = "cbt", scan = true}
        l_21_0:_spawn_in_group(spawn_group, spawn_group_type, grp_objective)
        used_group = true
      end
    end
  end
  if used_event or used_spawn_points or reassigned then
    table.remove(l_21_0._task_data.recon.tasks, 1)
    l_21_0._task_data.recon.next_dispatch_t = t + math.ceil(l_21_0:_get_difficulty_dependent_value(tweak_data.group_ai.besiege.recon.interval)) + math.random() * tweak_data.group_ai.besiege.recon.interval_variation
  end
end

GroupAIStateBesiege._find_spawn_points_near_area = function(l_22_0, l_22_1, l_22_2, l_22_3, l_22_4, l_22_5)
  local all_areas = l_22_0._area_data
  local all_nav_segs = managers.navigation._nav_segments
  local mvec3_dis = mvector3.distance
  local t = l_22_0._t
  local distances = {}
  local s_points = {}
  if not l_22_3 then
    l_22_3 = l_22_1.pos
  end
  local to_search_areas = {l_22_1}
  do
    local found_areas = {}
    found_areas[l_22_1.id] = true
    repeat
      local search_area = table.remove(to_search_areas, 1)
      do
        local spawn_points = search_area.spawn_points
        if spawn_points then
          for _,sp_data in ipairs(spawn_points) do
            if sp_data.delay_t <= t and (not l_22_5 or l_22_5(sp_data)) then
              local my_dis = mvec3_dis(l_22_3, sp_data.pos)
              if not l_22_4 or my_dis < l_22_4 then
                local i = #distances
                repeat
                  if i > 0 then
                    if distances[i] < my_dis then
                      do return end
                    end
                    i = i - 1
                  elseif i < #distances then
                    if #distances == l_22_2 then
                      distances[l_22_2] = my_dis
                      s_points[l_22_2] = sp_data
                      for (for control),_ in (for generator) do
                      end
                      table.remove(distances)
                      table.remove(s_points)
                      table.insert(distances, i + 1, my_dis)
                      table.insert(s_points, i + 1, sp_data)
                      for (for control),_ in (for generator) do
                      end
                      if i < l_22_2 then
                        table.insert(distances, my_dis)
                        table.insert(s_points, sp_data)
                      end
                    end
                  end
                end
              end
              if #s_points == l_22_2 then
                do return end
              end
              for other_area_id,other_area in pairs(all_areas) do
                if not found_areas[other_area_id] and other_area.neighbours[search_area.id] then
                  table.insert(to_search_areas, other_area)
                  found_areas[other_area_id] = true
                end
              end
            until #to_search_areas == 0
          end
          return (#s_points > 0 and s_points)
        end
         -- Warning: missing end command somewhere! Added here
      end
       -- Warning: missing end command somewhere! Added here
    end
     -- Warning: missing end command somewhere! Added here
  end
end

GroupAIStateBesiege._find_spawn_group_near_area = function(l_23_0, l_23_1, l_23_2, l_23_3, l_23_4, l_23_5, l_23_6)
  local all_areas = l_23_0._area_data
  local mvec3_dis = mvector3.distance_sq
  if l_23_5 then
    l_23_5 = l_23_5 * l_23_5
  end
  local t = l_23_0._t
  local valid_spawn_groups = {}
  local valid_spawn_group_distances = {}
  local total_dis = 0
  if not l_23_4 then
    l_23_4 = l_23_1.pos
  end
  local to_search_areas = {l_23_1}
  local found_areas = {}
  found_areas[l_23_1.id] = true
  repeat
    local search_area = table.remove(to_search_areas, 1)
    do
      local spawn_groups = search_area.spawn_groups
      if spawn_groups then
        for _,spawn_group in ipairs(spawn_groups) do
          if spawn_group.delay_t <= t and (not l_23_6 or l_23_6(spawn_group)) then
            local my_dis = mvec3_dis(l_23_4, spawn_group.pos)
            if not l_23_5 or my_dis < l_23_5 then
              total_dis = total_dis + my_dis
              table.insert(valid_spawn_groups, spawn_group)
              table.insert(valid_spawn_group_distances, my_dis)
            end
          end
        end
      end
      for other_area_id,other_area in pairs(all_areas) do
        if not found_areas[other_area_id] and other_area.neighbours[search_area.id] then
          table.insert(to_search_areas, other_area)
          found_areas[other_area_id] = true
        end
      end
    until #to_search_areas == 0
  end
  if not next(valid_spawn_group_distances) then
    return 
  end
  if total_dis == 0 then
    total_dis = 1
  end
  local total_weight = 0
  local candidate_groups = {}
  local dis_limit = 100000000
  for i,dis in ipairs(valid_spawn_group_distances) do
    local my_wgt = valid_spawn_group_distances[i]
    my_wgt = math.lerp(1, 0.20000000298023, math.min(1, my_wgt / dis_limit))
    local my_spawn_group = valid_spawn_groups[i]
    local my_group_types = my_spawn_group.mission_element:spawn_groups()
    for _,group_type in ipairs(my_group_types) do
      local cat_weights = l_23_3[group_type]
      if cat_weights then
        local cat_weight = l_23_0:_get_difficulty_dependent_value(cat_weights)
        local mod_weight = my_wgt * cat_weight
        table.insert(candidate_groups, {group = my_spawn_group, group_type = group_type, wght = mod_weight})
        total_weight = total_weight + mod_weight
      end
    end
  end
  if total_weight == 0 then
    return 
  end
  local rand_wgt = (total_weight) * math.random()
  local best_grp, best_grp_type = nil, nil
  for i,candidate in ipairs(candidate_groups) do
    rand_wgt = rand_wgt - candidate.wght
    if rand_wgt <= 0 then
      best_grp = candidate.group
      best_grp_type = candidate.group_type
  else
    end
  end
  return best_grp, best_grp_type
end

GroupAIStateBesiege._spawn_in_individual_groups = function(l_24_0, l_24_1, l_24_2, l_24_3)
  for i_sp,spawn_point in ipairs(l_24_2) do
    local group_desc = {type = "custom", size = 1}
    local grp_objective_cpy = clone(l_24_1)
    if not grp_objective_cpy.area then
      grp_objective_cpy.area = spawn_point.area
    end
    local group = l_24_0:_create_group(group_desc)
    group.objective = grp_objective_cpy
    group.objective.moving_out = true
    local spawn_task = {objective = l_24_0._create_objective_from_group_objective(grp_objective_cpy), spawn_point = spawn_point, group = group, task = l_24_3}
    table.insert(l_24_0._spawning_groups, spawn_task)
  end
end

GroupAIStateBesiege._extract_group_desc_structure = function(l_25_0, l_25_1)
  for spawn_entry_key,spawn_entry in ipairs(l_25_0) do
    if spawn_entry.unit then
      table.insert(l_25_1, clone(spawn_entry))
      for (for control),spawn_entry_key in (for generator) do
      end
      GroupAIStateBesiege._extract_group_desc_structure(spawn_entry, l_25_1)
    end
    for spawn_entry_key,spawn_entry in pairs(l_25_0) do
      if (type(spawn_entry_key) ~= "number" or #l_25_0 < spawn_entry_key) and #spawn_entry ~= 0 then
        local i_rand = math.random(#spawn_entry)
        local rand_branch = spawn_entry[i_rand]
        if rand_branch.unit then
          table.insert(l_25_1, clone(rand_branch))
          for (for control),spawn_entry_key in (for generator) do
          end
          GroupAIStateBesiege._extract_group_desc_structure(rand_branch, l_25_1)
        end
      end
       -- Warning: missing end command somewhere! Added here
    end
     -- Warning: missing end command somewhere! Added here
  end
end

GroupAIStateBesiege._spawn_in_group = function(l_26_0, l_26_1, l_26_2, l_26_3, l_26_4)
  local spawn_group_desc = tweak_data.group_ai.enemy_spawn_groups[l_26_2]
  local wanted_nr_units = nil
  if type(spawn_group_desc.amount) == "number" then
    wanted_nr_units = spawn_group_desc.amount
  else
    wanted_nr_units = math.random(spawn_group_desc.amount[1], spawn_group_desc.amount[2])
  end
  local valid_unit_types = {}
  l_26_0._extract_group_desc_structure(spawn_group_desc.spawn, valid_unit_types)
  local total_wgt = 0
  for i,spawn_entry in ipairs(valid_unit_types) do
    total_wgt = total_wgt + spawn_entry.freq
  end
  local spawn_task = {objective = l_26_0._create_objective_from_group_objective(l_26_3), units_remaining = {}, spawn_group = l_26_1, spawn_group_type = l_26_2, ai_task = l_26_4}
  table.insert(l_26_0._spawning_groups, spawn_task)
  local _add_unit_type_to_spawn_task = function(l_1_0, l_1_1)
    local spawn_amount_mine = 1 + (spawn_task.units_remaining[l_1_1.unit] and spawn_task.units_remaining[l_1_1.unit].amount or 0)
    spawn_task.units_remaining[l_1_1.unit] = {amount = spawn_amount_mine, spawn_entry = l_1_1}
    upvalue_512 = wanted_nr_units - 1
    if l_1_1.amount_min then
      l_1_1.amount_min = l_1_1.amount_min - 1
    end
    if l_1_1.amount_max then
      l_1_1.amount_max = l_1_1.amount_max - 1
      if l_1_1.amount_max == 0 then
        table.remove(valid_unit_types, l_1_0)
        upvalue_1536 = total_wgt - l_1_1.freq
        return true
      end
    end
   end
  local i = 1
  repeat
    repeat
      repeat
        if i <= #valid_unit_types then
          local spawn_entry = valid_unit_types[i]
        until i <= #valid_unit_types and wanted_nr_units > 0 and spawn_entry.amount_min and spawn_entry.amount_min > 0 and (not spawn_entry.amount_max or spawn_entry.amount_max > 0) and not _add_unit_type_to_spawn_task(i, spawn_entry)
        i = i + 1
        do return end
        i = i + 1
      elseif wanted_nr_units > 0 and #valid_unit_types ~= 0 then
        local rand_wght = math.random() * (total_wgt)
        local rand_i = 1
        local rand_entry = nil
        repeat
          repeat
            rand_entry = valid_unit_types[rand_i]
            rand_wght = rand_wght - rand_entry.freq
            if rand_wght <= 0 then
              do return end
            else
              rand_i = rand_i + 1
              do return end
              _add_unit_type_to_spawn_task(rand_i, rand_entry)
            end
          else
            local group_desc = {type = l_26_2, size = 0}
            for u_name,spawn_info in pairs(spawn_task.units_remaining) do
              group_desc.size = group_desc.size + spawn_info.amount
            end
            do
              local group = l_26_0:_create_group(group_desc)
              group.objective = l_26_3
              group.objective.moving_out = true
              spawn_task.group = group
            end
             -- Warning: missing end command somewhere! Added here
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

GroupAIStateBesiege._upd_group_spawning = function(l_27_0)
  local spawn_task = l_27_0._spawning_groups[1]
  if not spawn_task then
    return 
  end
  local nr_units_spawned = 0
  local produce_data = {name = true, spawn_ai = {}}
  local group_ai_tweak = tweak_data.group_ai
  local spawn_points = spawn_task.spawn_group.spawn_pts
  local _try_spawn_unit = function(l_1_0, l_1_1)
    if GroupAIStateBesiege._MAX_SIMULTANEOUS_SPAWNS <= nr_units_spawned then
      return 
    end
    local hopeless = true
    for _,sp_data in ipairs(spawn_points) do
      local category = group_ai_tweak.unit_categories[l_1_0]
      if (sp_data.accessibility == "any" or category.access[sp_data.accessibility]) and (not sp_data.amount or sp_data.amount > 0) then
        hopeless = false
        if sp_data.delay_t < self._t then
          produce_data.name = category.units[math.random(#category.units)]
          local spawned_unit = sp_data.mission_element:produce(produce_data)
          sp_data.delay_t = self._t + sp_data.interval
          if sp_data.amount then
            sp_data.amount = sp_data.amount - 1
          end
          local u_key = spawned_unit:key()
          local u_data = self._police[u_key]
          self:set_enemy_assigned(spawn_task.objective.area, u_key)
          if l_1_1.tactics then
            u_data.tactics = l_1_1.tactics
            u_data.tactics_map = {}
            for _,tactic_name in ipairs(u_data.tactics) do
              u_data.tactics_map[tactic_name] = true
            end
          end
          spawned_unit:brain():set_spawn_entry(l_1_1, u_data.tactics_map)
          u_data.rank = l_1_1.rank
          self:_add_group_member(spawn_task.group, u_key)
          local objective = self.clone_objective(spawn_task.objective)
          if spawned_unit:brain():is_available_for_assignment(objective) then
            spawned_unit:brain():set_objective(objective)
          else
            spawned_unit:brain():set_followup_objective(objective)
          end
          nr_units_spawned = nr_units_spawned + 1
          if spawn_task.ai_task then
            spawn_task.ai_task.force_spawned = spawn_task.ai_task.force_spawned + 1
          end
          return true
        end
      end
    end
    if hopeless then
      debug_pause("[GroupAIStateBesiege:_upd_group_spawning] spawn group", spawn_task.spawn_group.id, "failed to spawn unit", l_1_0)
      return true
    end
   end
  for u_type_name,spawn_info in pairs(spawn_task.units_remaining) do
    if not group_ai_tweak.unit_categories[u_type_name].access.acrobatic then
      repeat
        if spawn_info.amount > 0 then
          local success = _try_spawn_unit(u_type_name, spawn_info.spawn_entry)
          if success then
            spawn_info.amount = spawn_info.amount - 1
          end
          for (for control),u_type_name in (for generator) do
        end
      end
    end
    for u_type_name,spawn_info in pairs(spawn_task.units_remaining) do
      repeat
        if spawn_info.amount > 0 then
          local success = _try_spawn_unit(u_type_name, spawn_info.spawn_entry)
          if success then
            spawn_info.amount = spawn_info.amount - 1
          end
          for (for control),u_type_name in (for generator) do
        end
      end
      local complete = true
      for u_type_name,spawn_info in pairs(spawn_task.units_remaining) do
        if spawn_info.amount > 0 then
          complete = false
      else
        end
      end
      if complete then
        spawn_task.group.has_spawned = true
        table.remove(l_27_0._spawning_groups, 1)
        if spawn_task.group.size <= 0 then
          l_27_0._groups[spawn_task.group.id] = nil
        end
      end
       -- Warning: missing end command somewhere! Added here
    end
     -- Warning: missing end command somewhere! Added here
  end
end

GroupAIStateBesiege._upd_reenforce_tasks = function(l_28_0)
  local reenforce_tasks = l_28_0._task_data.reenforce.tasks
  local t = l_28_0._t
  do
    local i = #reenforce_tasks
    repeat
      if i > 0 then
        local task_data = reenforce_tasks[i]
        local force_settings = task_data.target_area.factors.force
        if force_settings then
          local force_required = force_settings.force
        end
        if force_required then
          local force_occupied = 0
          for group_id,group in pairs(l_28_0._groups) do
            if (group.objective.target_area or group.objective.area == task_data.target_area) and group.objective.type == "reenforce_area" then
              if not group.has_spawned or not group.size then
                force_occupied = force_occupied + group.initial_size
              end
            end
          end
          local undershot = force_required - (force_occupied)
          if undershot > 0 and not l_28_0._task_data.regroup.active and l_28_0._task_data.assault.phase ~= "fade" and l_28_0._task_data.reenforce.next_dispatch_t < t and l_28_0:is_area_safe(task_data.target_area) then
            local used_event = nil
            if task_data.use_spawn_event then
              task_data.use_spawn_event = false
              if l_28_0:_try_use_task_spawn_event(t, task_data.target_area, "reenforce") then
                used_event = true
              end
            end
            local used_group, spawning_groups = nil, nil
            if not used_event then
              if next(l_28_0._spawning_groups) then
                spawning_groups = true
              else
                local spawn_group, spawn_group_type = l_28_0:_find_spawn_group_near_area(task_data.target_area, undershot, tweak_data.group_ai.besiege.reenforce.groups, nil, nil, nil)
                if spawn_group then
                  local grp_objective = {type = "reenforce_area", area = spawn_group.area, target_area = task_data.target_area, attitude = "avoid", stance = "cbt", scan = true}
                  l_28_0:_spawn_in_group(spawn_group, spawn_group_type, grp_objective)
                  used_group = true
                end
              end
            end
            if used_event or used_group then
              l_28_0._task_data.reenforce.next_dispatch_t = t + l_28_0:_get_difficulty_dependent_value(tweak_data.group_ai.besiege.reenforce.interval)
            elseif undershot < 0 then
              local force_defending = 0
              for group_id,group in pairs(l_28_0._groups) do
                if group.objective.area == task_data.target_area and group.objective.type == "reenforce_area" then
                  if not group.has_spawned or not group.size then
                    force_defending = force_defending + group.initial_size
                  end
                end
              end
              local overshot = force_defending - force_required
              if overshot > 0 then
                local closest_group, closest_group_size = nil, nil
                for group_id,group in pairs(l_28_0._groups) do
                  if (not group.has_spawned or (not group.objective.target_area and group.objective.area ~= task_data.target_area) or group.objective.type ~= "reenforce area" or (closest_group_size and closest_group_size >= group.size) or group.size <= overshot) then
                    closest_group = group
                    closest_group_size = group.size
                  end
                end
                if closest_group then
                  l_28_0:_assign_group_to_retire(closest_group)
                else
                  reenforce_tasks[i] = reenforce_tasks[#reenforce_tasks]
                  table.remove(reenforce_tasks)
                end
              end
            end
          end
        end
        i = i - 1
      else
        l_28_0:_assign_enemy_groups_to_reenforce()
      end
       -- Warning: missing end command somewhere! Added here
    end
     -- Warning: missing end command somewhere! Added here
  end
end

GroupAIStateBesiege.register_criminal = function(l_29_0, l_29_1)
  GroupAIStateBesiege.super.register_criminal(l_29_0, l_29_1)
  if not Network:is_server() then
    return 
  end
  local u_key = l_29_1:key()
  local record = l_29_0._criminals[u_key]
  local area_data = l_29_0:get_area_from_nav_seg_id(record.seg)
  area_data.criminal.units[u_key] = record
end

GroupAIStateBesiege.unregister_criminal = function(l_30_0, l_30_1)
  if Network:is_server() then
    local u_key = l_30_1:key()
    local record = l_30_0._criminals[u_key]
    for area_id,area in pairs(l_30_0._area_data) do
      if area.nav_segs[record.seg] then
        area.criminal.units[u_key] = nil
      end
    end
  end
  GroupAIStateBesiege.super.unregister_criminal(l_30_0, l_30_1)
end

GroupAIStateBesiege.on_objective_complete = function(l_31_0, l_31_1, l_31_2)
  local new_objective, so_element = nil, nil
  if l_31_2.followup_objective then
    if not l_31_2.followup_objective.trigger_on then
      new_objective = l_31_2.followup_objective
    else
      new_objective = {type = "free", followup_objective = l_31_2.followup_objective, interrupt_dis = l_31_2.interrupt_dis, interrupt_health = l_31_2.interrupt_health}
    end
  elseif l_31_2.followup_SO then
    local current_SO_element = l_31_2.followup_SO
    so_element = current_SO_element:choose_followup_SO(l_31_1)
    if so_element then
      new_objective = so_element:get_objective(l_31_1)
    end
  end
  if new_objective and new_objective.nav_seg then
    local u_key = l_31_1:key()
    do
      local u_data = l_31_0._police[u_key]
      if u_data and u_data.assigned_area then
        l_31_0:set_enemy_assigned(l_31_0._area_data[new_objective.nav_seg], u_key)
      end
      do return end
      local seg = l_31_1:movement():nav_tracker():nav_segment()
      local area_data = l_31_0:get_area_from_nav_seg_id(seg)
      if l_31_0:rescue_state() and tweak_data.character[l_31_1:base()._tweak_table].rescue_hostages then
        for u_key,u_data in pairs(managers.enemy:all_civilians()) do
          if seg == u_data.tracker:nav_segment() then
            local so_id = u_data.unit:brain():wants_rescue()
            if so_id then
              local so = l_31_0._special_objectives[so_id]
              local so_data = so.data
              local so_objective = so_data.objective
              new_objective = l_31_0.clone_objective(so_objective)
              if so_data.admin_clbk then
                so_data.admin_clbk(l_31_1)
              end
              l_31_0:remove_special_objective(so_id)
          end
        end
      end
       -- DECOMPILER ERROR: unhandled construct in 'if'

      if not new_objective and l_31_2.type == "investigate_area" and l_31_2.guard_obj then
        {type = "guard", nav_seg = seg}.vis_group = l_31_2.vis_group
         -- DECOMPILER ERROR: Confused about usage of registers!

        {type = "guard", nav_seg = seg}.guard_obj = l_31_2.guard_obj
         -- DECOMPILER ERROR: Confused about usage of registers!

        {type = "guard", nav_seg = seg}.interrupt_dis = 700
         -- DECOMPILER ERROR: Confused about usage of registers!

        {type = "guard", nav_seg = seg}.interrupt_health = 0.75
         -- DECOMPILER ERROR: Confused about usage of registers!

        {type = "guard", nav_seg = seg}.in_place = true
         -- DECOMPILER ERROR: Confused about usage of registers!

        {type = "guard", nav_seg = seg}.scan = l_31_2.scan
         -- DECOMPILER ERROR: Confused about usage of registers!

        {type = "guard", nav_seg = seg}.attitude = l_31_2.attitude
         -- DECOMPILER ERROR: Confused about usage of registers!

        new_objective = {type = "guard", nav_seg = seg}
        do return end
        if l_31_2.type == "free" then
          new_objective = {type = "free", is_default = true, attitude = l_31_2.attitude}
        end
      end
      if not area_data.is_safe then
        area_data.is_safe = true
        l_31_0:_on_nav_seg_safety_status(seg, {reason = "guard", unit = l_31_1})
      end
    end
  end
  l_31_2.fail_clbk = nil
  l_31_1:brain():set_objective(new_objective)
  if l_31_2.complete_clbk then
    l_31_2.complete_clbk(l_31_1)
  end
  if so_element then
    so_element:clbk_objective_administered(l_31_1)
  end
end

GroupAIStateBesiege.on_defend_travel_end = function(l_32_0, l_32_1, l_32_2)
  local seg = l_32_2.nav_seg
  local area = l_32_0:get_area_from_nav_seg_id(seg)
  if not area.is_safe then
    area.is_safe = true
    l_32_0:_on_area_safety_status(area, {reason = "guard", unit = l_32_1})
  end
end

GroupAIStateBesiege.on_cop_jobless = function(l_33_0, l_33_1)
  local u_key = l_33_1:key()
  if not l_33_0._police[u_key].assigned_area then
    return 
  end
  local nav_seg = l_33_1:movement():nav_tracker():nav_segment()
  local new_occupation = l_33_0:find_occupation_in_area(nav_seg)
  local area = l_33_0:get_area_from_nav_seg_id(nav_seg)
  local force_factor = area.factors.force
  if force_factor then
    local demand = force_factor.force
  end
  local nr_police = table.size(area.police.units)
  if demand then
    local undershot = demand - nr_police
  end
  if undershot and undershot > 0 then
    {type = "defend_area", nav_seg = nav_seg}.attitude = "avoid"
     -- DECOMPILER ERROR: Confused about usage of registers!

    {type = "defend_area", nav_seg = nav_seg}.stance = "hos"
     -- DECOMPILER ERROR: Confused about usage of registers!

    {type = "defend_area", nav_seg = nav_seg}.interrupt_dis = 700
     -- DECOMPILER ERROR: Confused about usage of registers!

    {type = "defend_area", nav_seg = nav_seg}.interrupt_health = 0.75
     -- DECOMPILER ERROR: Confused about usage of registers!

    {type = "defend_area", nav_seg = nav_seg}.in_place = true
     -- DECOMPILER ERROR: Confused about usage of registers!

    {type = "defend_area", nav_seg = nav_seg}.scan = true
     -- DECOMPILER ERROR: Confused about usage of registers!

    {type = "defend_area", nav_seg = nav_seg}.is_default = true
     -- DECOMPILER ERROR: Confused at declaration of local variable

    l_33_0:set_enemy_assigned(l_33_0._area_data[nav_seg], u_key)
     -- DECOMPILER ERROR: Confused about usage of registers!

    l_33_1:brain():set_objective({type = "defend_area", nav_seg = nav_seg})
    return true
  end
  do
     -- DECOMPILER ERROR: Confused at declaration of local variable

    if not area.is_safe then
      l_33_0:set_enemy_assigned(l_33_0._area_data[nav_seg], u_key)
      l_33_1:brain():set_objective({type = "free", nav_seg = nav_seg, attitude = "avoid", stance = "hos", in_place = true, scan = true, is_default = true})
      return true
    end
     -- DECOMPILER ERROR: Confused about usage of registers for local variables.

  end
end

GroupAIStateBesiege._draw_enemy_activity = function(l_34_0, l_34_1)
  local draw_data = l_34_0._AI_draw_data
  local brush_area = draw_data.brush_area
  local area_normal = -math.UP
  local logic_name_texts = draw_data.logic_name_texts
  local group_id_texts = draw_data.group_id_texts
  local panel = draw_data.panel
  local camera = managers.viewport:get_current_camera()
  local ws = draw_data.workspace
  local mid_pos1 = Vector3()
  local mid_pos2 = Vector3()
  local focus_enemy_pen = draw_data.pen_focus_enemy
  local focus_player_brush = draw_data.brush_focus_player
  local suppr_period = 0.40000000596046
  local suppr_t = l_34_1 % suppr_period
  if suppr_period * 0.5 < suppr_t then
    suppr_t = suppr_period - suppr_t
  end
  draw_data.brush_suppressed:set_color(Color(math.lerp(0.20000000298023, 0.5, suppr_t), 0.85000002384186, 0.89999997615814, 0.20000000298023))
  for area_id,area in pairs(l_34_0._area_data) do
    if table.size(area.police.units) > 0 then
      brush_area:half_sphere(area.pos, 22, area_normal)
    end
  end
  local _f_draw_logic_name = function(l_1_0, l_1_1, l_1_2)
    local logic_name_text = logic_name_texts[l_1_0]
    local text_str = l_1_1.name
    if l_1_1.objective then
      text_str = text_str .. ":" .. l_1_1.objective.type
    end
    if logic_name_text then
      logic_name_text:set_text(text_str)
    else
      logic_name_text = panel:text({name = "text", text = text_str, font = tweak_data.hud.medium_font, font_size = 20, color = l_1_2, layer = 1})
      logic_name_texts[l_1_0] = logic_name_text
    end
    local my_head_pos = mid_pos1
    mvector3.set(my_head_pos, l_1_1.unit:movement():m_head_pos())
    mvector3.set_z(my_head_pos, my_head_pos.z + 30)
    local my_head_pos_screen = camera:world_to_screen(my_head_pos)
    if my_head_pos_screen.z > 0 then
      local screen_x = (my_head_pos_screen.x + 1) * 0.5 * RenderSettings.resolution.x
      local screen_y = (my_head_pos_screen.y + 1) * 0.5 * RenderSettings.resolution.y
      logic_name_text:set_x(screen_x)
      logic_name_text:set_y(screen_y)
      if not logic_name_text:visible() then
        logic_name_text:show()
      else
        if logic_name_text:visible() then
          logic_name_text:hide()
        end
      end
    end
   end
  local _f_draw_obj_pos = function(l_2_0)
    local brush = nil
    local objective = l_2_0:brain():objective()
    if objective then
      local objective_type = objective.type
    end
    if objective_type == "guard" then
      brush = draw_data.brush_guard
    elseif objective_type == "investigate_area" then
      brush = draw_data.brush_investigate
    elseif objective_type == "defend_area" then
      brush = draw_data.brush_defend
    elseif objective_type == "free" or objective_type == "follow" or objective_type == "surrender" then
      brush = draw_data.brush_free
    elseif objective_type == "act" then
      brush = draw_data.brush_act
    else
      brush = draw_data.brush_misc
    end
    local obj_pos = nil
    if objective then
      if objective.pos then
        obj_pos = objective.pos
      elseif objective.follow_unit then
        obj_pos = objective.follow_unit:movement():m_head_pos()
        if objective.follow_unit:base().is_local_player then
          obj_pos = obj_pos + math.UP * -30
        elseif objective.nav_seg then
          obj_pos = managers.navigation._nav_segments[objective.nav_seg].pos
        elseif objective.area then
          obj_pos = objective.area.pos
        end
      end
    end
    if obj_pos then
      local u_pos = l_2_0:movement():m_com()
      brush:cylinder(u_pos, obj_pos, 4, 3)
      brush:sphere(u_pos, 24)
    end
    if l_2_0:brain()._logic_data.is_suppressed then
      mvector3.set(mid_pos1, l_2_0:movement():m_pos())
      mvector3.set_z(mid_pos1, mid_pos1.z + 220)
      draw_data.brush_suppressed:cylinder(l_2_0:movement():m_pos(), mid_pos1, 35)
    end
   end
  local group_center = Vector3()
  for group_id,group in pairs(l_34_0._groups) do
    local nr_units = 0
    for u_key,u_data in pairs(group.units) do
      nr_units = nr_units + 1
      mvector3.add(group_center, u_data.unit:movement():m_com())
    end
    if nr_units > 0 then
      mvector3.divide(group_center, nr_units)
      local gui_text = group_id_texts[group_id]
      local group_pos_screen = camera:world_to_screen(group_center)
      if group_pos_screen.z > 0 then
        if not gui_text then
          gui_text = panel:text({name = "text", text = group_id .. ":" .. group.objective.type, font = tweak_data.hud.medium_font, font_size = 24, color = draw_data.group_id_color, layer = 2})
          group_id_texts[group_id] = gui_text
        end
        local screen_x = (group_pos_screen.x + 1) * 0.5 * RenderSettings.resolution.x
        local screen_y = (group_pos_screen.y + 1) * 0.5 * RenderSettings.resolution.y
        gui_text:set_x(screen_x)
        gui_text:set_y(screen_y)
        if not gui_text:visible() then
          gui_text:show()
        elseif gui_text and gui_text:visible() then
          gui_text:hide()
        end
      end
      for u_key,u_data in pairs(group.units) do
        draw_data.pen_group:line(group_center, u_data.unit:movement():m_com())
      end
    end
    mvector3.set_zero(group_center)
  end
  local _f_draw_attention_on_player = function(l_3_0)
    if l_3_0.attention_obj then
      local my_head_pos = l_3_0.unit:movement():m_head_pos()
      local e_pos = l_3_0.attention_obj.m_head_pos
      local dis = mvector3.distance(my_head_pos, e_pos)
      mvector3.step(mid_pos2, my_head_pos, e_pos, 300)
      mvector3.lerp(mid_pos1, my_head_pos, mid_pos2, t % 0.5)
      mvector3.step(mid_pos2, mid_pos1, e_pos, 50)
      focus_enemy_pen:line(mid_pos1, mid_pos2)
      if l_3_0.attention_obj.unit:base() and l_3_0.attention_obj.unit:base().is_local_player then
        focus_player_brush:sphere(my_head_pos, 20)
      end
    end
   end
  local groups = {{group = l_34_0._police, color = Color(1, 1, 0, 0)}, {group = managers.enemy:all_civilians(), color = Color(1, 0.75, 0.75, 0.75)}, {group = l_34_0._ai_criminals, color = Color(1, 0, 1, 0)}}
  for _,group_data in ipairs(groups) do
    for u_key,u_data in pairs(group_data.group) do
      _f_draw_obj_pos(u_data.unit)
      if camera then
        local l_data = u_data.unit:brain()._logic_data
        _f_draw_logic_name(, l_data, group_data.color)
        _f_draw_attention_on_player(l_data)
      end
    end
  end
  for u_key,gui_text in pairs(logic_name_texts) do
    local keep = nil
    for _,group_data in ipairs(groups) do
      if group_data.group[u_key] then
        keep = true
    else
      end
    end
    if not keep then
      panel:remove(gui_text)
      logic_name_texts[u_key] = nil
    end
  end
  for group_id,gui_text in pairs(group_id_texts) do
    if not l_34_0._groups[group_id] then
      panel:remove(gui_text)
      group_id_texts[group_id] = nil
    end
  end
end

GroupAIStateBesiege.find_occupation_in_area = function(l_35_0, l_35_1)
  local doors = managers.navigation:find_segment_doors(l_35_1, callback(l_35_0, l_35_0, "filter_nav_seg_unsafe"))
  if not next(doors) then
    return 
  end
  for other_seg,door_list in ipairs(doors) do
    for i_door,door_data in ipairs(door_list) do
      door_data.weight = 0
    end
  end
  local tmp_vec1 = Vector3()
  local tmp_vec2 = Vector3()
  local math_max = math.max
  local mvec3_lerp = mvector3.lerp
  local mvec3_dis_sq = mvector3.distance_sq
  local nav_manager = managers.navigation
  local area_data = l_35_0:get_area_from_nav_seg_id(l_35_1)
  local area_police = area_data.police.units
  local unit_data = l_35_0._police
  local guarded_doors = {}
  for u_key,_ in pairs(area_police) do
    local objective = unit_data[u_key].unit:brain():objective()
    if objective and objective.guard_obj then
      local door_list = doors[objective.from_seg]
      if door_list then
        mvec3_lerp(tmp_vec1, objective.guard_obj.door.low_pos, objective.guard_obj.door.high_pos, 0.5)
        for i_door,door_data in ipairs(door_list) do
          mvec3_lerp(tmp_vec2, door_data.low_pos, door_dataoor.high_pos, 0.5)
          local weight = 1 / math_max(1, mvec3_dis_sq(tmp_vec1, tmp_vec2))
          door_data.weight = door_data.weight + weight
        end
      end
    end
  end
  local best_door, best_door_weight, best_door_nav_seg = nil, nil, nil
  for other_seg,door_list in ipairs(doors) do
    for i_door,door_data in ipairs(door_list) do
      if not best_door or door_data.weight < best_door_weight then
        best_door = door_data.center
        best_door_weight = door_data.weight
        best_door_nav_seg = other_seg
      end
    end
  end
  for other_seg,door_list in ipairs(doors) do
    for i_door,door_data in ipairs(door_list) do
      door_data.weight = nil
    end
  end
  if best_door then
    local center = mvector3.copy(best_door.low_pos)
    mvec3_lerp(center, center, best_door.heigh_pos, 0.5)
    best_door.center = center
    return {type = "guard", door = best_door, from_seg = best_door_nav_seg}
  end
end

GroupAIStateBesiege.verify_occupation_in_area = function(l_36_0, l_36_1)
  local nav_seg = l_36_1.nav_seg
  return l_36_0:find_occupation_in_area(nav_seg)
end

GroupAIStateBesiege.filter_nav_seg_unsafe = function(l_37_0, l_37_1)
  return not l_37_0:is_nav_seg_safe(l_37_1)
end

GroupAIStateBesiege._on_nav_seg_safety_status = function(l_38_0, l_38_1, l_38_2)
  local area = l_38_0:get_area_from_nav_seg_id(l_38_1)
  l_38_0:_on_area_safety_status(area, l_38_2)
end

GroupAIStateBesiege.add_flee_point = function(l_39_0, l_39_1, l_39_2)
  local nav_seg = managers.navigation:get_nav_seg_from_pos(l_39_2, true)
  local area = l_39_0:get_area_from_nav_seg_id(nav_seg)
  local flee_point = {pos = l_39_2, nav_seg = nav_seg, area = area}
  l_39_0._flee_points[l_39_1] = flee_point
  if not area.flee_points then
    area.flee_points = {}
  end
  area.flee_points[l_39_1] = flee_point
end

GroupAIStateBesiege.remove_flee_point = function(l_40_0, l_40_1)
  local flee_point = l_40_0._flee_points[l_40_1]
  if not flee_point then
    return 
  end
  l_40_0._flee_points[l_40_1] = nil
  local area = flee_point.area
  area.flee_points[l_40_1] = nil
  if not next(area.flee_points) then
    area.flee_points = nil
  end
end

GroupAIStateBesiege.flee_point = function(l_41_0, l_41_1)
  local start_area = l_41_0:get_area_from_nav_seg_id(l_41_1)
  local to_search_areas = {start_area}
  local found_areas = {start_area = true}
  repeat
    local search_area = table.remove(to_search_areas, 1)
    if search_area.flee_points and next(search_area.flee_points) then
      local flee_point_id, flee_point = next(search_area.flee_points)
      return flee_point.pos
    else
      for other_area_id,other_area in pairs(search_area.neighbours) do
        if not found_areas[other_area] then
          table.insert(to_search_areas, other_area)
          found_areas[other_area] = true
        end
      end
    end
  until #to_search_areas == 0
end

GroupAIStateBesiege.safe_flee_point = function(l_42_0, l_42_1)
  local start_area = l_42_0:get_area_from_nav_seg_id(l_42_1)
  if next(start_area.criminal.units) then
    return 
  end
  local to_search_areas = {start_area}
  local found_areas = {start_area = true}
  repeat
    local search_area = table.remove(to_search_areas, 1)
    if search_area.flee_points and next(search_area.flee_points) then
      local flee_point_id, flee_point = next(search_area.flee_points)
      return flee_point
    else
      for other_area_id,other_area in pairs(search_area.neighbours) do
        if not found_areas[other_area] and not next(other_area.criminal.units) then
          table.insert(to_search_areas, other_area)
          found_areas[other_area] = true
        end
      end
    end
  until #to_search_areas == 0
end

GroupAIStateBesiege.add_enemy_loot_drop_point = function(l_43_0, l_43_1, l_43_2)
  local nav_seg = managers.navigation:get_nav_seg_from_pos(l_43_2, true)
  local area = l_43_0:get_area_from_nav_seg_id(nav_seg)
  local drop_point = {pos = l_43_2, nav_seg = nav_seg, area = area}
  l_43_0._enemy_loot_drop_points[l_43_1] = drop_point
  if not area.enemy_loot_drop_points then
    area.enemy_loot_drop_points = {}
  end
  area.enemy_loot_drop_points[l_43_1] = drop_point
end

GroupAIStateBesiege.remove_enemy_loot_drop_point = function(l_44_0, l_44_1)
  local drop_point = l_44_0._enemy_loot_drop_points[l_44_1]
  if not drop_point then
    return 
  end
  l_44_0._enemy_loot_drop_points[l_44_1] = nil
  local area = drop_point.area
  area.enemy_loot_drop_points[l_44_1] = nil
  if not next(area.enemy_loot_drop_points) then
    area.enemy_loot_drop_points = nil
  end
end

GroupAIStateBesiege.get_safe_enemy_loot_drop_point = function(l_45_0, l_45_1)
  local start_area = l_45_0:get_area_from_nav_seg_id(l_45_1)
  if next(start_area.criminal.units) then
    return 
  end
  local to_search_areas = {start_area}
  local found_areas = {start_area = true}
  repeat
    local search_area = table.remove(to_search_areas, 1)
    if search_area.enemy_loot_drop_points and next(search_area.enemy_loot_drop_points) then
      local nr_drop_points = table.size(search_area.enemy_loot_drop_points)
      local lucky_drop_point = math.random(nr_drop_points)
      for drop_point_id,drop_point in pairs(search_area.enemy_loot_drop_points) do
        lucky_drop_point = lucky_drop_point - 1
        if lucky_drop_point == 0 then
          return drop_point
        end
      end
    else
      for other_area_id,other_area in pairs(search_area.neighbours) do
        if not found_areas[other_area] and not next(other_area.criminal.units) then
          table.insert(to_search_areas, )
          found_areas[other_area] = true
        end
      end
    end
  until #to_search_areas == 0
end

GroupAIStateBesiege._draw_spawn_points = function(l_46_0)
  local all_areas = l_46_0._area_data
  local tmp_vec3 = Vector3()
  for area_id,area_data in pairs(all_areas) do
    local area_spawn_points = area_data.spawn_points
    if area_spawn_points then
      for _,sp_data in ipairs(area_spawn_points) do
        Application:draw_sphere(sp_data.pos, 220, 0.10000000149012, 0.40000000596046, 0.60000002384186)
      end
    end
    local area_spawn_groups = area_data.spawn_groups
    if area_spawn_groups then
      for _,spawn_group in ipairs(area_spawn_groups) do
        mvector3.set(tmp_vec3, math.UP)
        mvector3.multiply(tmp_vec3, 2500)
        mvector3.add(tmp_vec3, spawn_group.pos)
        Application:draw_cylinder(spawn_group.pos, tmp_vec3, 220, 0.20000000298023, 0.10000000149012, 0.75)
        for _,sp_data in ipairs(spawn_group.spawn_pts) do
          mvector3.set(tmp_vec3, math.UP)
          mvector3.multiply(tmp_vec3, 200)
          mvector3.add(tmp_vec3, sp_data.pos)
          Application:draw_cylinder(sp_data.pos, tmp_vec3, 63, 0.10000000149012, 0.40000000596046, 0.60000002384186)
          Application:draw_cylinder(spawn_group.pos, sp_data.pos, 20, 0.20000000298023, 0.10000000149012, 0.75)
        end
      end
    end
  end
end

GroupAIStateBesiege.on_hostage_fleeing = function(l_47_0, l_47_1)
  l_47_0._hostage_fleeing = l_47_1
end

GroupAIStateBesiege.on_hostage_flee_end = function(l_48_0)
  l_48_0._hostage_fleeing = nil
end

GroupAIStateBesiege.can_hostage_flee = function(l_49_0)
  return not l_49_0._hostage_fleeing
end

GroupAIStateBesiege.add_to_surrendered = function(l_50_0, l_50_1, l_50_2)
  local hos_data = l_50_0._hostage_data
  local nr_entries = #hos_data
  local entry = {u_key = l_50_1:key(), clbk = l_50_2}
  if not l_50_0._hostage_upd_key then
    l_50_0._hostage_upd_key = "GroupAIStateBesiege:_upd_hostage_task"
    managers.enemy:queue_task(l_50_0._hostage_upd_key, l_50_0._upd_hostage_task, l_50_0, l_50_0._t + 1)
  end
  table.insert(hos_data, entry)
end

GroupAIStateBesiege.remove_from_surrendered = function(l_51_0, l_51_1)
  local hos_data = l_51_0._hostage_data
  local u_key = l_51_1:key()
  for i,entry in ipairs(hos_data) do
    if u_key == entry.u_key then
      table.remove(hos_data, i)
  else
    end
  end
  if #hos_data == 0 then
    managers.enemy:unqueue_task(l_51_0._hostage_upd_key)
    l_51_0._hostage_upd_key = nil
  end
end

GroupAIStateBesiege._upd_hostage_task = function(l_52_0)
  l_52_0._hostage_upd_key = nil
  local hos_data = l_52_0._hostage_data
  local first_entry = hos_data[1]
  table.remove(hos_data, 1)
  first_entry.clbk()
  if not l_52_0._hostage_upd_key and #hos_data > 0 then
    l_52_0._hostage_upd_key = "GroupAIStateBesiege:_upd_hostage_task"
    managers.enemy:queue_task(l_52_0._hostage_upd_key, l_52_0._upd_hostage_task, l_52_0, l_52_0._t + 1)
  end
end

GroupAIStateBesiege.set_area_min_police_force = function(l_53_0, l_53_1, l_53_2, l_53_3)
  if l_53_2 then
    local nav_seg_id = managers.navigation:get_nav_seg_from_pos(l_53_3, true)
    local area = l_53_0:get_area_from_nav_seg_id(nav_seg_id)
    local factors = area.factors
    factors.force = {id = l_53_1, force = l_53_2}
  else
    for area_id,area in pairs(l_53_0._area_data) do
      local force_factor = area.factors.force
      if force_factor and force_factor.id == l_53_1 then
        area.factors.force = nil
        return 
      end
    end
  end
end

GroupAIStateBesiege.set_wave_mode = function(l_54_0, l_54_1)
  local old_wave_mode = l_54_0._wave_mode
  l_54_0._wave_mode = l_54_1
  l_54_0._hunt_mode = nil
  if l_54_1 == "hunt" then
    l_54_0._hunt_mode = true
    l_54_0._wave_mode = "besiege"
    managers.hud:start_assault()
    l_54_0:_set_rescue_state(false)
    l_54_0:set_assault_mode(true)
    managers.trade:set_trade_countdown(false)
    l_54_0:_end_regroup_task()
    if l_54_0._task_data.assault.active then
      l_54_0._task_data.assault.phase = "sustain"
      l_54_0._task_data.use_smoke = true
      l_54_0._task_data.use_smoke_timer = 0
    else
      l_54_0._task_data.assault.next_dispatch_t = l_54_0._t
    end
  elseif l_54_1 == "besiege" then
    if l_54_0._task_data.regroup.active then
      l_54_0._task_data.assault.next_dispatch_t = l_54_0._task_data.regroup.end_t
    else
      if not l_54_0._task_data.assault.active then
        l_54_0._task_data.assault.next_dispatch_t = l_54_0._t
      elseif l_54_1 == "quiet" then
        l_54_0._hunt_mode = nil
      else
        l_54_0._wave_mode = old_wave_mode
        debug_pause("[GroupAIStateBesiege:set_wave_mode] flag", l_54_1, " does not apply to the current Group AI state.")
      end
    end
     -- Warning: missing end command somewhere! Added here
  end
end

GroupAIStateBesiege.on_simulation_ended = function(l_55_0)
  GroupAIStateBesiege.super.on_simulation_ended(l_55_0)
  if managers.navigation:is_data_ready() then
    l_55_0:_create_area_data()
    l_55_0._task_data = {}
    l_55_0._task_data.reenforce = {tasks = {}, next_dispatch_t = 0}
    l_55_0._task_data.recon = {tasks = {}, next_dispatch_t = 0}
    l_55_0._task_data.assault = {disabled = true, is_first = true}
    l_55_0._task_data.regroup = {}
  end
  if l_55_0._police_upd_task_queued then
    l_55_0._police_upd_task_queued = nil
    managers.enemy:unqueue_task("GroupAIStateBesiege._upd_police_activity")
  end
end

GroupAIStateBesiege.on_simulation_started = function(l_56_0)
  GroupAIStateBesiege.super.on_simulation_started(l_56_0)
  if managers.navigation:is_data_ready() then
    l_56_0:_create_area_data()
    l_56_0._task_data = {}
    l_56_0._task_data.reenforce = {tasks = {}, next_dispatch_t = 0}
    l_56_0._task_data.recon = {tasks = {}, next_dispatch_t = 0}
    l_56_0._task_data.assault = {disabled = true, is_first = true}
    l_56_0._task_data.regroup = {}
  end
  if not l_56_0._police_upd_task_queued then
    l_56_0:_queue_police_upd_task()
  end
end

GroupAIStateBesiege.on_enemy_weapons_hot = function(l_57_0, l_57_1)
  if not l_57_0._ai_enabled then
    return 
  end
  if not l_57_0._enemy_weapons_hot then
    l_57_0._task_data.assault.disabled = nil
    l_57_0._task_data.assault.next_dispatch_t = l_57_0._t
  end
  GroupAIStateBesiege.super.on_enemy_weapons_hot(l_57_0, l_57_1)
end

GroupAIStateBesiege.is_detection_persistent = function(l_58_0)
  return l_58_0._task_data.assault.active
end

GroupAIStateBesiege._assign_enemy_groups_to_assault = function(l_59_0, l_59_1)
  for group_id,group in pairs(l_59_0._groups) do
    if group.has_spawned and group.objective.type == "assault_area" then
      if group.objective.moving_out then
        local done_moving = nil
        for u_key,u_data in pairs(group.units) do
          local objective = u_data.unit:brain():objective()
          if objective then
            if objective.grp_objective ~= group.objective then
              for (for control),u_key in (for generator) do
              end
              if not objective.in_place then
                done_moving = false
                for (for control),u_key in (for generator) do
                end
                if done_moving == nil then
                  done_moving = true
                end
              end
            end
            if done_moving == true then
              group.objective.moving_out = nil
              group.in_place_t = l_59_0._t
              group.objective.moving_in = nil
              l_59_0:_voice_move_complete(group)
            end
          end
          if not group.objective.moving_in then
            l_59_0:_set_assault_objective_to_group(group, l_59_1)
          end
        end
      end
       -- Warning: missing end command somewhere! Added here
    end
     -- Warning: missing end command somewhere! Added here
  end
end

GroupAIStateBesiege._assign_enemy_groups_to_recon = function(l_60_0)
  for group_id,group in pairs(l_60_0._groups) do
    if group.has_spawned and group.objective.type == "recon_area" then
      if group.objective.moving_out then
        local done_moving = nil
        for u_key,u_data in pairs(group.units) do
          local objective = u_data.unit:brain():objective()
          if objective then
            if objective.grp_objective ~= group.objective then
              for (for control),u_key in (for generator) do
              end
              if not objective.in_place then
                done_moving = false
                for (for control),u_key in (for generator) do
                end
                if done_moving == nil then
                  done_moving = true
                end
              end
            end
            if done_moving == true then
              if group.objective.moved_in then
                if not group.visited_areas then
                  group.visited_areas = {}
                end
                group.visited_areas[group.objective.area] = true
              end
              group.objective.moving_out = nil
              group.in_place_t = l_60_0._t
              group.objective.moving_in = nil
              l_60_0:_voice_move_complete(group)
            end
          end
          if not group.objective.moving_in then
            l_60_0:_set_recon_objective_to_group(group)
          end
        end
      end
       -- Warning: missing end command somewhere! Added here
    end
     -- Warning: missing end command somewhere! Added here
  end
end

GroupAIStateBesiege._set_recon_objective_to_group = function(l_61_0, l_61_1)
  local current_objective = l_61_1.objective
  if not current_objective.target_area then
    local target_area = current_objective.area
  end
  if (not target_area.loot and not target_area.hostages) or not current_objective.moving_out and current_objective.moved_in and l_61_1.in_place_t and l_61_0._t - l_61_1.in_place_t > 15 then
    local recon_area = nil
    local to_search_areas = {current_objective.area}
    local found_areas = {current_objective.area = "init"}
    repeat
      do
        local search_area = table.remove(to_search_areas, 1)
        if search_area.loot or search_area.hostages then
          local occupied = nil
          for test_group_id,test_group in pairs(l_61_0._groups) do
            if test_group ~= l_61_1 and (test_group.objective.target_area == search_area or test_group.objective.area == search_area) then
              occupied = true
          else
            end
          end
          if not occupied and l_61_1.visited_areas and l_61_1.visited_areas[search_area] then
            occupied = true
          end
          if not occupied then
            local is_area_safe = not next(search_area.criminal.units)
            if is_area_safe then
              recon_area = search_area
              do return end
            elseif not recon_area then
              recon_area = search_area
            end
          end
        end
        if not next(search_area.criminal.units) then
          for other_area_id,other_area in pairs(search_area.neighbours) do
            if not found_areas[other_area] then
              table.insert(to_search_areas, other_area)
              found_areas[other_area] = search_area
            end
          end
        end
      until #to_search_areas == 0
    end
    if recon_area then
      local coarse_path = {{recon_area.pos_nav_seg, recon_area.pos}}
      local last_added_area = recon_area
      repeat
        if found_areas[last_added_area] ~= "init" then
          last_added_area = found_areas[last_added_area]
          table.insert(coarse_path, 1, {last_added_area.pos_nav_seg, last_added_area.pos})
        else
          local grp_objective = {type = "recon_area", area = current_objective.area, target_area = recon_area, coarse_path = coarse_path, attitude = "avoid", stance = "hos", pose = "stand", scan = true}
          l_61_0:_set_objective_to_enemy_group(l_61_1, grp_objective)
          current_objective = l_61_1.objective
        end
      end
      if current_objective.target_area then
        if current_objective.moving_out and not current_objective.moving_in and current_objective.coarse_path then
          local forwardmost_i_nav_point = l_61_0:_get_group_forwardmost_coarse_path_index(l_61_1)
          if forwardmost_i_nav_point and forwardmost_i_nav_point > 1 then
            for i = forwardmost_i_nav_point + 1, #current_objective.coarse_path do
              local nav_point = current_objective.coarse_path[forwardmost_i_nav_point]
              if not l_61_0:is_nav_seg_safe(nav_point[1]) then
                for i = 0, #current_objective.coarse_path - forwardmost_i_nav_point do
                  table.remove(current_objective.coarse_path)
                end
                local grp_objective = {type = "recon_area", area = l_61_0:get_area_from_nav_seg_id(current_objective.coarse_path[#current_objective.coarse_path][1]), target_area = current_objective.target_area, attitude = "avoid", stance = "hos", pose = "stand", scan = true}
                l_61_0:_set_objective_to_enemy_group(l_61_1, grp_objective)
                return 
              end
            end
          end
        end
        if not current_objective.moving_out and not current_objective.area.neighbours[current_objective.target_area.id] then
          local search_params = {from_seg = current_objective.area.pos_nav_seg, to_seg = current_objective.target_area.pos_nav_seg, id = "GroupAI_recon", access_pos = "cop", verify_clbk = callback(l_61_0, l_61_0, "is_nav_seg_safe")}
          local coarse_path = managers.navigation:search_coarse(search_params)
          if coarse_path then
            l_61_0:_merge_coarse_path_by_area(coarse_path)
            table.remove(coarse_path)
            local grp_objective = {type = "recon_area", area = l_61_0:get_area_from_nav_seg_id(coarse_path[#coarse_path][1]), target_area = current_objective.target_area, coarse_path = coarse_path, attitude = "avoid", stance = "hos", pose = "stand", scan = true}
            l_61_0:_set_objective_to_enemy_group(l_61_1, grp_objective)
          end
        end
        if not current_objective.moving_out and current_objective.area.neighbours[current_objective.target_area.id] then
          local grp_objective = {type = "recon_area", area = current_objective.target_area, attitude = "avoid", stance = "cbt", pose = "crouch", scan = true}
          l_61_0:_set_objective_to_enemy_group(l_61_1, grp_objective)
          l_61_1.objective.moving_in = true
          l_61_1.objective.moved_in = true
          if next(current_objective.target_area.criminal.units) then
            l_61_0:_chk_group_use_smoke_grenade(l_61_1, {use_smoke = true, target_areas = {grp_objective.area}})
          end
        end
      end
       -- Warning: missing end command somewhere! Added here
    end
     -- Warning: missing end command somewhere! Added here
  end
end

GroupAIStateBesiege._set_objective_to_enemy_group = function(l_62_0, l_62_1, l_62_2)
  l_62_1.objective = l_62_2
  if l_62_2.area then
    l_62_2.moving_out = true
  end
  l_62_2.assigned_t = l_62_0._t
  if l_62_0._AI_draw_data and l_62_0._AI_draw_data.group_id_texts[l_62_1.id] then
    l_62_0._AI_draw_data.panel:remove(l_62_0._AI_draw_data.group_id_texts[l_62_1.id])
    l_62_0._AI_draw_data.group_id_texts[l_62_1.id] = nil
  end
end

GroupAIStateBesiege._upd_groups = function(l_63_0)
  for group_id,group in pairs(l_63_0._groups) do
    for u_key,u_data in pairs(group.units) do
      local brain = u_data.unit:brain()
      local current_objective = brain:objective()
      if (not current_objective or current_objective.is_default or not current_objective.grp_objective or current_objective.grp_objective ~= group.objective) and (not group.objective.follow_unit or alive(group.objective.follow_unit)) then
        local objective = l_63_0._create_objective_from_group_objective(group.objective)
        if brain:is_available_for_assignment(objective) then
          l_63_0:set_enemy_assigned(group.objective.area, u_key)
          u_data.unit:brain():set_objective(objective)
        end
      end
    end
  end
end

GroupAIStateBesiege._set_assault_objective_to_group = function(l_64_0, l_64_1, l_64_2)
  if not l_64_1.has_spawned then
    return 
  end
  local phase_is_anticipation = l_64_2 == "anticipation"
  local current_objective = l_64_1.objective
  local approach, open_fire, push, pull_back, charge = nil, nil, nil, nil, nil
  local obstructed_area = l_64_0:_chk_group_areas_tresspassed(l_64_1)
  local group_leader_u_key, group_leader_u_data = l_64_0._determine_group_leader(l_64_1.units)
  local tactics_map = nil
  if group_leader_u_data and group_leader_u_data.tactics then
    tactics_map = {}
    for _,tactic_name in ipairs(group_leader_u_data.tactics) do
      tactics_map[tactic_name] = true
    end
    if current_objective.tactic and not tactics_map[current_objective.tactic] then
      current_objective.tactic = nil
    end
    for i_tactic,tactic_name in ipairs(group_leader_u_data.tactics) do
      if tactic_name == "deathguard" and not phase_is_anticipation then
        if current_objective.tactic == tactic_name then
          for u_key,u_data in pairs(l_64_0._char_criminals) do
            if u_data.status and current_objective.follow_unit == u_data.unit then
              local crim_nav_seg = u_data.tracker:nav_segment()
              if current_objective.area.nav_segs[crim_nav_seg] then
                return 
              end
            end
          end
        end
        local closest_crim_u_data, closest_crim_dis_sq = nil, nil
        for u_key,u_data in pairs(l_64_0._char_criminals) do
          if u_data.status then
            local closest_u_id, closest_u_data, closest_u_dis_sq = l_64_0._get_closest_group_unit_to_pos(u_data.m_pos, l_64_1.units)
            if closest_u_dis_sq and (not closest_crim_dis_sq or closest_u_dis_sq < closest_crim_dis_sq) then
              closest_crim_u_data = u_data
              closest_crim_dis_sq = closest_u_dis_sq
            end
          end
        end
        if closest_crim_u_data then
          local search_params = {from_tracker = group_leader_u_data.unit:movement():nav_tracker(), to_tracker = closest_crim_u_data.tracker, id = "GroupAI_deathguard", access_pos = group_leader_u_data.char_tweak.access}
          local coarse_path = managers.navigation:search_coarse(search_params)
          do
            if coarse_path then
              local grp_objective = {type = "assault_area", tactic = "deathguard", follow_unit = closest_crim_u_data.unit, distance = 800, area = l_64_0:get_area_from_nav_seg_id(coarse_path[#coarse_path][1]), coarse_path = coarse_path, attitude = "engage", moving_in = true}
              l_64_1.is_chasing = true
              l_64_0:_set_objective_to_enemy_group(l_64_1, grp_objective)
              l_64_0:_voice_deathguard_start(l_64_1)
              return 
            end
            for (for control),i_tactic in (for generator) do
            end
            if tactic_name == "charge" and not current_objective.moving_out and l_64_1.in_place_t and (l_64_0._t - l_64_1.in_place_t > 15 or l_64_0._t - l_64_1.in_place_t <= 4 or l_64_0._drama_data.amount <= tweak_data.drama.low) and next(current_objective.area.criminal.units) and l_64_1.is_chasing and not current_objective.charge then
              charge = true
            end
          end
        end
      end
    end
    local objective_area = nil
    if obstructed_area and current_objective.moving_out and not current_objective.open_fire then
      open_fire = true
      do return end
      if not current_objective.pushed or charge and not current_objective.charge then
        push = true
        do return end
        local obstructed_path_index = l_64_0:_chk_coarse_path_obstructed(l_64_1)
        if obstructed_path_index then
          print("obstructed_path_index", obstructed_path_index)
          objective_area = l_64_0:get_area_from_nav_seg_id(l_64_1.coarse_path[math.max(obstructed_path_index - 1, 1)][1])
          pull_back = true
        elseif not current_objective.moving_out then
          local has_criminals_close = nil
          if not current_objective.moving_out then
            for area_id,neighbour_area in pairs(current_objective.area.neighbours) do
              if next(neighbour_area.criminal.units) then
                has_criminals_close = true
            else
              end
            end
            if charge then
              push = true
            elseif not has_criminals_close or not l_64_1.in_place_t then
              approach = true
            elseif not phase_is_anticipation and not current_objective.open_fire then
              open_fire = true
            elseif not phase_is_anticipation and l_64_1.in_place_t and (l_64_1.is_chasing or not tactics_map or not tactics_map.ranged_fire or l_64_0._t - l_64_1.in_place_t > 15) then
              push = true
            elseif phase_is_anticipation and current_objective.open_fire then
              pull_back = true
            end
          end
        end
      end
      if not objective_area then
        objective_area = current_objective.area
      end
      if open_fire then
         -- DECOMPILER ERROR: Confused while interpreting a jump as a 'while'

      end
      local grp_objective = {type = "assault_area", tactic = current_objective.tactic, area = current_objective.area, coarse_path = {{}}, attitude = "engage", pose = "stand", stance = "cbt", open_fire = true}
       -- DECOMPILER ERROR: Overwrote pending register.

       -- DECOMPILER ERROR: Overwrote pending register.

      l_64_0:_set_objective_to_enemy_group(objective_area.pos_nav_seg, mvector3.copy(current_objective.area.pos))
      l_64_0:_voice_open_fire_start(l_64_1)
    elseif approach or push then
      local assault_area, alternate_assault_area, alternate_assault_area_from = nil, nil, nil
      local to_search_areas = {objective_area}
      local found_areas = {objective_area = "init"}
      repeat
        do
          local search_area = table.remove(to_search_areas, 1)
          if next(search_area.criminal.units) then
            local assault_from_here = true
            if not push and tactics_map and tactics_map.flank then
              local assault_from_area = found_areas[search_area]
              if assault_from_area ~= "init" then
                local cop_units = assault_from_area.police.units
                for u_key,u_data in pairs(cop_units) do
                  if u_data.group and u_data.group ~= l_64_1 and u_data.group.objective.type == "assault_area" then
                    assault_from_here = false
                    if not alternate_assault_area or math.random() < 0.5 then
                      alternate_assault_area = search_area
                      alternate_assault_area_from = assault_from_area
                    end
                    found_areas[search_area] = nil
                else
                  end
                end
              end
              if assault_from_here then
                assault_area = search_area
                do return end
              else
                for other_area_id,other_area in pairs(search_area.neighbours) do
                  if not found_areas[other_area] then
                    table.insert(to_search_areas, )
                    found_areas[other_area] = search_area
                  end
                end
              end
            end
          until #to_search_areas == 0
        end
        if not assault_area and alternate_assault_area then
          assault_area = alternate_assault_area
          found_areas[assault_area] = alternate_assault_area_from
        end
        if assault_area then
          if (not push or not assault_area) and (found_areas[assault_area] ~= "init" or not objective_area) then
            local target_area = found_areas[assault_area]
          end
          if not push or not {{assault_area.pos_nav_seg, assault_area.pos}} then
            local coarse_path = {}
          end
          local last_added_area = assault_area
          repeat
            if found_areas[last_added_area] ~= "init" then
              last_added_area = found_areas[last_added_area]
              table.insert(coarse_path, 1, {last_added_area.pos_nav_seg, last_added_area.pos})
            elseif #coarse_path == 0 then
              table.insert(coarse_path, {assault_area.pos_nav_seg, assault_area.pos})
            end
             -- DECOMPILER ERROR: Confused while interpreting a jump as a 'while'

          end
          {type = "assault_area", area = target_area, coarse_path = coarse_path, pose = push and "crouch" or "stand", stance = push and "cbt" or "hos", attitude = push and "engage" or "avoid"}.moving_in = true
           -- DECOMPILER ERROR: Confused about usage of registers!

          {type = "assault_area", area = target_area, coarse_path = coarse_path, pose = push and "crouch" or "stand", stance = push and "cbt" or "hos", attitude = push and "engage" or "avoid"}.open_fire = push or nil
           -- DECOMPILER ERROR: Confused about usage of registers!

          {type = "assault_area", area = target_area, coarse_path = coarse_path, pose = push and "crouch" or "stand", stance = push and "cbt" or "hos", attitude = push and "engage" or "avoid"}.pushed = push or nil
           -- DECOMPILER ERROR: Confused about usage of registers!

          {type = "assault_area", area = target_area, coarse_path = coarse_path, pose = push and "crouch" or "stand", stance = push and "cbt" or "hos", attitude = push and "engage" or "avoid"}.charge = charge
           -- DECOMPILER ERROR: Confused about usage of registers!

          {type = "assault_area", area = target_area, coarse_path = coarse_path, pose = push and "crouch" or "stand", stance = push and "cbt" or "hos", attitude = push and "engage" or "avoid"}.interrupt_dis = charge and 0 or nil
           -- DECOMPILER ERROR: Confused at declaration of local variable

          l_64_1.is_chasing = l_64_1.is_chasing or push
           -- DECOMPILER ERROR: Confused about usage of registers!

          l_64_0:_set_objective_to_enemy_group(l_64_1, {type = "assault_area", area = target_area, coarse_path = coarse_path, pose = push and "crouch" or "stand", stance = push and "cbt" or "hos", attitude = push and "engage" or "avoid"})
          do
             -- DECOMPILER ERROR: Confused at declaration of local variable

            if push then
              if charge then
                for c_key,c_data in pairs(target_area.criminal.units) do
                   -- DECOMPILER ERROR: Confused at declaration of local variable

                   -- DECOMPILER ERROR: Overwrote pending register.

                  do return end
                end
              end
              l_64_0:_chk_group_use_flash_grenade(l_64_1, l_64_0._task_data.assault, nil)
               -- DECOMPILER ERROR: Confused about usage of registers!

              l_64_0:_chk_group_use_smoke_grenade(l_64_1, l_64_0._task_data.assault, nil)
              l_64_0:_voice_move_in_start(l_64_1)
          end
           -- DECOMPILER ERROR: Confused about usage of registers!

           -- DECOMPILER ERROR: Confused at declaration of local variable

          elseif pull_back then
            for u_key,u_data in pairs(l_64_1.units) do
               -- DECOMPILER ERROR: Confused at declaration of local variable

               -- DECOMPILER ERROR: Confused at declaration of local variable

               -- DECOMPILER ERROR: Overwrote pending register.

              if current_objective.area.nav_segs[i_3.tracker:nav_segment()] then
                do return end
              end
               -- DECOMPILER ERROR: Overwrote pending register.

              if l_64_0:is_nav_seg_safe(i_3.tracker:nav_segment()) then
                do return end
              end
            end
             -- DECOMPILER ERROR: Confused about usage of registers!

             -- DECOMPILER ERROR: Confused at declaration of local variable

             -- DECOMPILER ERROR: Confused about usage of registers!

            do
               -- DECOMPILER ERROR: Confused at declaration of local variable

            end
             -- DECOMPILER ERROR: Confused about usage of registers!

             -- DECOMPILER ERROR: Confused about usage of registers!

             -- DECOMPILER ERROR: Confused about usage of registers!

             -- DECOMPILER ERROR: Confused at declaration of local variable

             -- DECOMPILER ERROR: Confused about usage of registers!

             -- DECOMPILER ERROR: Confused about usage of registers!

             -- DECOMPILER ERROR: Confused about usage of registers!

             -- DECOMPILER ERROR: Overwrote pending register.

             -- DECOMPILER ERROR: Overwrote pending register.

            if nil or nil or not current_objective.coarse_path or not l_64_0:_get_group_forwardmost_coarse_path_index(l_64_1) or l_64_0:get_area_from_nav_seg_id(current_objective.coarse_path(l_64_0:_get_group_forwardmost_coarse_path_index(l_64_1))) then
              l_64_0:_set_objective_to_enemy_group(l_64_0:get_area_from_nav_seg_id(current_objective.coarse_path(l_64_0:_get_group_forwardmost_coarse_path_index(l_64_1))).pos_nav_seg, mvector3.copy(l_64_0:get_area_from_nav_seg_id(current_objective.coarse_path(l_64_0:_get_group_forwardmost_coarse_path_index(l_64_1))).pos))
              l_64_1.is_chasing = nil
              return 
               -- DECOMPILER ERROR: Confused about usage of registers for local variables.

            end
          end
        end
      end
       -- Warning: missing end command somewhere! Added here
    end
     -- Warning: missing end command somewhere! Added here
  end
end

GroupAIStateBesiege._create_objective_from_group_objective = function(l_65_0)
  local objective = {grp_objective = l_65_0}
  if l_65_0.type == "defend_area" or l_65_0.type == "recon_area" or l_65_0.type == "reenforce_area" or l_65_0.type == "retire" then
    objective.type = "defend_area"
    objective.stance = "cbt"
    objective.pose = "crouch"
    objective.scan = true
    objective.interrupt_dis = 200
    if l_65_0.type ~= "retire" then
      objective.interrupt_suppression = true
    elseif l_65_0.type == "assault_area" then
      objective.type = "defend_area"
      if l_65_0.follow_unit then
        objective.follow_unit = l_65_0.follow_unit
        objective.distance = l_65_0.distance
      end
      objective.stance = "cbt"
      objective.pose = "stand"
      objective.scan = true
      objective.interrupt_dis = 200
      objective.interrupt_suppression = true
    end
  end
  if not l_65_0.stance then
    objective.stance = objective.stance
  end
  if not l_65_0.pose then
    objective.pose = objective.pose
  end
  objective.area = l_65_0.area
  if not l_65_0.nav_seg then
    objective.nav_seg = objective.area.pos_nav_seg
  end
  objective.attitude = l_65_0.attitude
  if not l_65_0.interrupt_dis then
    objective.interrupt_dis = objective.interrupt_dis
  end
  if not l_65_0.interrupt_health then
    objective.interrupt_health = objective.interrupt_health
  end
  if not l_65_0.interrupt_suppression then
    objective.interrupt_suppression = objective.interrupt_suppression
  end
  objective.pos = l_65_0.pos
  if l_65_0.scan ~= nil then
    objective.scan = l_65_0.scan
  end
  if l_65_0.coarse_path then
    objective.path_style = "coarse_complete"
    objective.path_data = l_65_0.coarse_path
  end
  return objective
end

GroupAIStateBesiege._assign_groups_to_retire = function(l_66_0, l_66_1, l_66_2)
  for group_id,group in pairs(l_66_0._groups) do
    if not l_66_1[group.type] and group.objective.type ~= "reenforce_area" and group.objective.type ~= "retire" then
      l_66_0:_assign_group_to_retire(group)
      for (for control),group_id in (for generator) do
      end
      if l_66_2 and l_66_1[group.type] then
        l_66_2(group)
      end
    end
     -- Warning: missing end command somewhere! Added here
  end
end

GroupAIStateBesiege._assign_group_to_retire = function(l_67_0, l_67_1)
  local retire_area, retire_pos = nil, nil
  local to_search_areas = {l_67_1.objective.area}
  local found_areas = {l_67_1.objective.area = true}
  repeat
    do
      local search_area = table.remove(to_search_areas, 1)
      if search_area.flee_points and next(search_area.flee_points) then
        retire_area = search_area
        local flee_point_id, flee_point = next(search_area.flee_points)
        retire_pos = flee_point.pos
        do return end
      else
        for other_area_id,other_area in pairs(search_area.neighbours) do
          if not found_areas[other_area] then
            table.insert(to_search_areas, other_area)
            found_areas[other_area] = true
          end
        end
      end
    until #to_search_areas == 0
  end
  if not retire_area then
    debug_pause("[GroupAIStateBesiege:_assign_group_to_retire] flee point not found. from area:", inspect(l_67_1.objective.area), l_67_1.id)
    return 
  end
   -- DECOMPILER ERROR: Confused while interpreting a jump as a 'while'

end
local grp_objective = {type = "retire", area = l_67_1.objective.area, coarse_path = {{retire_area.pos_nav_seg, retire_area.pos}}, pos = retire_pos}
l_67_0:_set_objective_to_enemy_group(l_67_1, grp_objective)
end

GroupAIStateBesiege._determine_group_leader = function(l_68_0)
  local highest_rank, highest_ranking_u_key, highest_ranking_u_data = nil, nil, nil
  for u_key,u_data in pairs(l_68_0) do
    if u_data.rank and (not highest_rank or highest_rank < u_data.rank) then
      highest_rank = u_data.rank
      highest_ranking_u_key = u_key
      highest_ranking_u_data = u_data
    end
  end
  return highest_ranking_u_key, highest_ranking_u_data
end

GroupAIStateBesiege._get_closest_group_unit_to_pos = function(l_69_0, l_69_1)
  local closest_dis_sq, closest_u_key, closest_u_data = nil, nil, nil
  for u_key,u_data in pairs(l_69_1) do
    local my_dis = mvector3.distance_sq(l_69_0, u_data.m_pos)
    if not closest_dis_sq or my_dis < closest_dis_sq then
      closest_dis_sq = my_dis
      closest_u_key = u_key
      closest_u_data = u_data
    end
  end
  return closest_u_key, closest_u_data, closest_dis_sq
end

GroupAIStateBesiege._chk_group_use_smoke_grenade = function(l_70_0, l_70_1, l_70_2, l_70_3)
  if l_70_2.use_smoke and not l_70_0:is_smoke_grenade_active() then
    local shooter_pos, shooter_u_data = nil, nil
    local duration = 0
    for u_key,u_data in pairs(l_70_1.units) do
      if u_data.tactics_map and u_data.tactics_map.smoke_grenade then
        if not l_70_3 then
          local nav_seg_id = u_data.tracker:nav_segment()
          local nav_seg = managers.navigation._nav_segments[nav_seg_id]
          for neighbour_nav_seg_id,door_list in pairs(nav_seg.neighbours) do
            if l_70_2.target_areas[1].nav_segs[neighbour_nav_seg_id] then
              local random_door_id = door_list[math.random(#door_list)]
              if type(random_door_id) == "number" then
                l_70_3 = managers.navigation._room_doors[random_door_id].center
              else
                l_70_3 = random_door_id:script_data().element:nav_link_end_pos()
              end
              shooter_pos = mvector3.copy(u_data.m_pos)
              shooter_u_data = u_data
          else
            end
          end
          if l_70_3 and shooter_u_data then
            l_70_0:_detonate_smoke_grenade(l_70_3, shooter_pos, duration, false)
            l_70_2.use_smoke_timer = l_70_0._t + math.lerp(10, 40, math.rand(0, 1) ^ 0.5)
            l_70_2.use_smoke = false
            if shooter_u_data.char_tweak.chatter.smoke and not shooter_u_data.unit:sound():speaking(l_70_0._t) then
              l_70_0:chk_say_enemy_chatter(shooter_u_data.unit, shooter_u_data.m_pos, "smoke")
          end
        end
      end
    end
     -- Warning: missing end command somewhere! Added here
  end
end

GroupAIStateBesiege._chk_group_use_flash_grenade = function(l_71_0, l_71_1, l_71_2, l_71_3)
  if l_71_2.use_smoke and not l_71_0:is_smoke_grenade_active() then
    local shooter_pos, shooter_u_data = nil, nil
    local duration = 7.5
    for u_key,u_data in pairs(l_71_1.units) do
      if u_data.tactics_map and u_data.tactics_map.flash_grenade then
        if not l_71_3 then
          local nav_seg_id = u_data.tracker:nav_segment()
          local nav_seg = managers.navigation._nav_segments[nav_seg_id]
          for neighbour_nav_seg_id,door_list in pairs(nav_seg.neighbours) do
            if l_71_2.target_areas[1].nav_segs[neighbour_nav_seg_id] then
              local random_door_id = door_list[math.random(#door_list)]
              if type(random_door_id) == "number" then
                l_71_3 = managers.navigation._room_doors[random_door_id].center
              else
                l_71_3 = random_door_id:script_data().element:nav_link_end_pos()
              end
              shooter_pos = mvector3.copy(u_data.m_pos)
              shooter_u_data = u_data
          else
            end
          end
          if l_71_3 and shooter_u_data then
            l_71_0:_detonate_smoke_grenade(l_71_3, shooter_pos, duration, true)
            l_71_2.use_smoke_timer = l_71_0._t + math.lerp(10, 40, math.random() ^ 0.5)
            l_71_2.use_smoke = false
            if shooter_u_data.char_tweak.chatter.flash_grenade and not shooter_u_data.unit:sound():speaking(l_71_0._t) then
              l_71_0:chk_say_enemy_chatter(shooter_u_data.unit, shooter_u_data.m_pos, "flash_grenade")
          end
        end
      end
    end
     -- Warning: missing end command somewhere! Added here
  end
end

GroupAIStateBesiege._detonate_smoke_grenade = function(l_72_0, l_72_1, l_72_2, l_72_3, l_72_4)
   -- DECOMPILER ERROR: Confused while interpreting a jump as a 'while'

end
managers.network:session():send_to_peers("sync_smoke_grenade", l_72_1, l_72_2, l_72_3, true)
l_72_0:sync_smoke_grenade(l_72_1, l_72_2, l_72_3, l_72_4)
end

GroupAIStateBesiege._assign_assault_groups_to_retire = function(l_73_0)
  local suitable_grp_func = function(l_1_0)
    if l_1_0.objective.type == "assault_area" then
      local regroup_area = nil
      if next(l_1_0.objective.area.criminal.units) then
        for other_area_id,other_area in pairs(l_1_0.objective.area.neighbours) do
          if not next(other_area.criminal.units) then
            regroup_area = other_area
        else
          end
        end
        if not regroup_area then
          regroup_area = l_1_0.objective.area
        end
        local grp_objective = {type = "recon_area", area = regroup_area, attitude = "avoid", stance = "cbt", pose = "crouch"}
        self:_set_objective_to_enemy_group(l_1_0, grp_objective)
      end
       -- Warning: missing end command somewhere! Added here
    end
   end
  l_73_0:_assign_groups_to_retire(tweak_data.group_ai.besiege.recon.groups, suitable_grp_func)
end

GroupAIStateBesiege._assign_recon_groups_to_retire = function(l_74_0)
  local suitable_grp_func = function(l_1_0)
    if l_1_0.objective.type == "recon_area" then
      local grp_objective = {type = "assault_area", area = l_1_0.objective.area, attitude = "avoid", stance = "cbt", pose = "crouch"}
      self:_set_objective_to_enemy_group(l_1_0, grp_objective)
    end
   end
  l_74_0:_assign_groups_to_retire(tweak_data.group_ai.besiege.assault.groups, suitable_grp_func)
end

GroupAIStateBesiege._assign_enemy_groups_to_reenforce = function(l_75_0)
  for group_id,group in pairs(l_75_0._groups) do
    if group.has_spawned and group.objective.type == "reenforce_area" then
      local locked_up_in_area = nil
      if group.objective.moving_out then
        local done_moving = true
        for u_key,u_data in pairs(group.units) do
          local objective = u_data.unit:brain():objective()
          if not objective or objective.is_default or objective.grp_objective and objective.grp_objective ~= group.objective then
            if objective then
              if objective.area then
                locked_up_in_area = objective.area
                for (for control),u_key in (for generator) do
                end
                if objective.nav_seg then
                  locked_up_in_area = l_75_0:get_area_from_nav_seg_id(objective.nav_seg)
                  for (for control),u_key in (for generator) do
                  end
                  locked_up_in_area = l_75_0:get_area_from_nav_seg_id(u_data.tracker:nav_segment())
                  for (for control),u_key in (for generator) do
                  end
                  locked_up_in_area = l_75_0:get_area_from_nav_seg_id(u_data.tracker:nav_segment())
                  for (for control),u_key in (for generator) do
                  end
                  if not objective.in_place then
                    done_moving = false
                  end
                end
                if done_moving then
                  group.objective.moving_out = nil
                  group.in_place_t = l_75_0._t
                  group.objective.moving_in = nil
                  l_75_0:_voice_move_complete(group)
                end
              end
              if not group.objective.moving_in then
                if locked_up_in_area and locked_up_in_area ~= group.objective.area then
                  for (for control),group_id in (for generator) do
                  end
                  if not group.objective.moving_out then
                    l_75_0:_set_reenforce_objective_to_group(group)
                  end
                end
              end
            end
             -- Warning: missing end command somewhere! Added here
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

GroupAIStateBesiege._set_reenforce_objective_to_group = function(l_76_0, l_76_1)
  if not l_76_1.has_spawned then
    return 
  end
  local current_objective = l_76_1.objective
  if current_objective.target_area then
    if current_objective.moving_out and not current_objective.moving_in then
      local forwardmost_i_nav_point = l_76_0:_get_group_forwardmost_coarse_path_index(l_76_1)
      if forwardmost_i_nav_point then
        for i = forwardmost_i_nav_point + 1, #current_objective.coarse_path do
          local nav_point = current_objective.coarse_path[forwardmost_i_nav_point]
          if not l_76_0:is_nav_seg_safe(nav_point[1]) then
            for i = 0, #current_objective.coarse_path - forwardmost_i_nav_point do
              table.remove(current_objective.coarse_path)
            end
            local grp_objective = {type = "reenforce_area", area = l_76_0:get_area_from_nav_seg_id(current_objective.coarse_path[#current_objective.coarse_path][1]), target_area = current_objective.target_area, attitude = "avoid", stance = "hos", pose = "stand", scan = true}
            l_76_0:_set_objective_to_enemy_group(l_76_1, grp_objective)
            return 
          end
        end
      end
    end
    if not current_objective.moving_out and not current_objective.area.neighbours[current_objective.target_area.id] then
      local search_params = {from_seg = current_objective.area.pos_nav_seg, to_seg = current_objective.target_area.pos_nav_seg, id = "GroupAI_reenforce", access_pos = "cop", verify_clbk = callback(l_76_0, l_76_0, "is_nav_seg_safe")}
      local coarse_path = managers.navigation:search_coarse(search_params)
      if coarse_path then
        l_76_0:_merge_coarse_path_by_area(coarse_path)
        table.remove(coarse_path)
        local grp_objective = {type = "reenforce_area", area = l_76_0:get_area_from_nav_seg_id(coarse_path[#coarse_path][1]), target_area = current_objective.target_area, coarse_path = coarse_path, attitude = "avoid", stance = "hos", pose = "stand", scan = true}
        l_76_0:_set_objective_to_enemy_group(l_76_1, grp_objective)
      end
    end
    if not current_objective.moving_out and current_objective.area.neighbours[current_objective.target_area.id] and not next(current_objective.target_area.criminal.units) then
      local grp_objective = {type = "reenforce_area", area = current_objective.target_area, attitude = "engage", stance = "cbt", pose = "crouch", scan = true}
      l_76_0:_set_objective_to_enemy_group(l_76_1, grp_objective)
      l_76_1.objective.moving_in = true
    end
  end
end

GroupAIStateBesiege._get_group_forwardmost_coarse_path_index = function(l_77_0, l_77_1)
  local coarse_path = l_77_1.objective.coarse_path
  local forwardmost_i_nav_point = #coarse_path
  repeat
    if forwardmost_i_nav_point > 0 then
      local nav_seg = coarse_path[forwardmost_i_nav_point][1]
      local area = l_77_0:get_area_from_nav_seg_id(nav_seg)
      for u_key,u_data in pairs(l_77_1.units) do
        if area.nav_segs[u_data.unit:movement():nav_tracker():nav_segment()] then
          return forwardmost_i_nav_point
        end
      end
      forwardmost_i_nav_point = forwardmost_i_nav_point - 1
    else
       -- Warning: missing end command somewhere! Added here
    end
     -- Warning: missing end command somewhere! Added here
  end
end

GroupAIStateBesiege._voice_deathguard_start = function(l_78_0, l_78_1)
  local time = l_78_0._t
  for u_key,unit_data in pairs(l_78_1.units) do
    if not unit_data.unit:sound():speaking(time) then
      unit_data.unit:sound():say("pus", true, nil)
  else
    end
  end
end

GroupAIStateBesiege._voice_open_fire_start = function(l_79_0, l_79_1)
  for u_key,unit_data in pairs(l_79_1.units) do
    if unit_data.char_tweak.chatter.aggressive and l_79_0:chk_say_enemy_chatter(unit_data.unit, unit_data.m_pos, "aggressive") then
      do return end
    end
  end
end

GroupAIStateBesiege._voice_move_in_start = function(l_80_0, l_80_1)
  for u_key,unit_data in pairs(l_80_1.units) do
    if unit_data.char_tweak.chatter.go_go and l_80_0:chk_say_enemy_chatter(unit_data.unit, unit_data.m_pos, "go_go") then
      do return end
    end
  end
end

GroupAIStateBesiege._voice_move_complete = function(l_81_0, l_81_1)
  for u_key,unit_data in pairs(l_81_1.units) do
    if unit_data.char_tweak.chatter.ready and l_81_0:chk_say_enemy_chatter(unit_data.unit, unit_data.m_pos, "ready") then
      do return end
    end
  end
end

GroupAIStateBesiege._voice_delay_assault = function(l_82_0, l_82_1)
  local time = l_82_0._t
  for u_key,unit_data in pairs(l_82_1.units) do
    if not unit_data.unit:sound():speaking(time) then
      unit_data.unit:sound():say("p01", true, nil)
      return true
    end
  end
  return false
end

GroupAIStateBesiege._chk_group_areas_tresspassed = function(l_83_0, l_83_1)
  local objective = l_83_1.objective
  local occupied_areas = {}
  for u_key,u_data in pairs(l_83_1.units) do
    local nav_seg = u_data.tracker:nav_segment()
    for area_id,area in pairs(l_83_0._area_data) do
      if area.nav_segs[nav_seg] then
        occupied_areas[area_id] = area
      end
    end
  end
  for area_id,area in pairs(occupied_areas) do
    if not l_83_0:is_area_safe(area) then
      return area
    end
  end
end

GroupAIStateBesiege._chk_coarse_path_obstructed = function(l_84_0, l_84_1)
  local current_objective = l_84_1.objective
  if not current_objective.coarse_path then
    return 
  end
  local forwardmost_i_nav_point = l_84_0:_get_group_forwardmost_coarse_path_index(l_84_1)
  if forwardmost_i_nav_point then
    for i = forwardmost_i_nav_point + 1, #current_objective.coarse_path do
      local nav_point = current_objective.coarse_path[forwardmost_i_nav_point]
      if not l_84_0:is_nav_seg_safe(nav_point[1]) then
        return i
      end
    end
  end
end

GroupAIStateBesiege._count_criminals_engaged_force = function(l_85_0, l_85_1)
  local count = 0
  do
    local all_enemies = l_85_0._police
    for c_key,c_data in pairs(l_85_0._char_criminals) do
      local c_area = l_85_0:get_area_from_nav_seg_id(c_data.tracker:nav_segment())
      for e_key,e_data_prev in pairs(c_data.engaged) do
        local e_data = all_enemies[e_key]
        if e_data then
          local e_group = e_data.group
          do
            if e_group and e_group.objective.type == "assault_area" then
              local e_area = l_85_0:get_area_from_nav_seg_id(e_data.tracker:nav_segment())
              if e_area == c_area or e_area.neighbours[c_area] then
                count = count + 1
                if l_85_1 and count == l_85_1 then
                  return count
                end
                for (for control),e_key in (for generator) do
                end
                debug_pause_unit(e_data_prev.unit, "non-enemy engaging player", e_key, inspect(e_data_prev), e_data_prev.unit)
                if managers.enemy:all_civilians()[e_key] then
                  print("he is civilian")
                  for (for control),e_key in (for generator) do
                  end
                  if l_85_0._criminals[e_key] then
                    print("he is criminal")
                    for (for control),e_key in (for generator) do
                    end
                    print("unknown unit type")
                  end
                end
              end
            end
          end
          return count
        end
         -- Warning: missing end command somewhere! Added here
      end
       -- Warning: missing end command somewhere! Added here
    end
     -- Warning: missing end command somewhere! Added here
  end
end


