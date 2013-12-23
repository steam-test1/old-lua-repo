-- Decompiled using luadec 2.0.1 by sztupy (http://winmo.sztupy.hu)
-- Command line was: F:\SteamLibrary\SteamApps\common\PAYDAY 2\lua\lib\managers\enemymanager.luac 

local mvec3_set = mvector3.set
local mvec3_sub = mvector3.subtract
local mvec3_dir = mvector3.direction
local mvec3_dot = mvector3.dot
local mvec3_dis = mvector3.distance
local t_rem = table.remove
local t_ins = table.insert
local m_min = math.min
local tmp_vec1 = Vector3()
if not EnemyManager then
  EnemyManager = class()
end
EnemyManager._MAX_NR_CORPSES = 8
EnemyManager._nr_i_lod = {{2, 2}, {5, 2}, {10, 5}}
EnemyManager.init = function(l_1_0)
  l_1_0:_init_enemy_data()
  l_1_0._unit_clbk_key = "EnemyManager"
  l_1_0._corpse_disposal_upd_interval = 5
end

EnemyManager.update = function(l_2_0, l_2_1, l_2_2)
  l_2_0._t = l_2_1
  l_2_0._queued_task_executed = nil
  l_2_0:_update_gfx_lod()
  l_2_0:_update_queued_tasks(l_2_1)
end

EnemyManager._update_gfx_lod = function(l_3_0)
  if l_3_0._gfx_lod_data.enabled and managers.navigation:is_data_ready() then
    local camera_rot = managers.viewport:get_current_camera_rotation()
    if camera_rot then
      local pl_tracker, cam_pos = nil, nil
      local pl_fwd = camera_rot:y()
      local player = managers.player:player_unit()
      if player then
        pl_tracker = player:movement():nav_tracker()
        cam_pos = player:movement():m_head_pos()
      else
        pl_tracker = false
        cam_pos = managers.viewport:get_current_camera_position()
      end
      local entries = l_3_0._gfx_lod_data.entries
      local units = entries.units
      local states = entries.states
      local move_ext = entries.move_ext
      local trackers = entries.trackers
      local com = entries.com
      if pl_tracker then
        local chk_vis_func = pl_tracker.check_visibility
      end
      local unit_occluded = Unit.occluded
      local occ_skip_units = managers.occlusion._skip_occlusion
      local world_in_view_with_options = World.in_view_with_options
      for i,state in ipairs(states) do
        if not state and (occ_skip_units[units[i]:key()] or (pl_tracker and not chk_vis_func(pl_tracker, trackers[i])) or not unit_occluded(units[i])) then
          local distance = mvec3_dir(tmp_vec1, cam_pos, com[i])
          if world_in_view_with_options(World, com[i], 0, 110, 18000) then
            states[i] = 1
            units[i]:base():set_visibility_state(1)
          end
        end
      end
      if #states > 0 then
        local anim_lod = managers.user:get_setting("video_animation_lod")
        local nr_lod_1 = l_3_0._nr_i_lod[anim_lod][1]
        local nr_lod_2 = l_3_0._nr_i_lod[anim_lod][2]
        local nr_lod_total = nr_lod_1 + nr_lod_2
        local imp_i_list = l_3_0._gfx_lod_data.prio_i
        local imp_wgt_list = l_3_0._gfx_lod_data.prio_weights
        local nr_entries = #states
        local i = l_3_0._gfx_lod_data.next_chk_prio_i
        if nr_entries < i then
          i = 1
        end
        local start_i = i
        repeat
          if states[i] then
            if (pl_tracker and not chk_vis_func(pl_tracker, trackers[i])) or unit_occluded(units[i]) then
              states[i] = false
              units[i]:base():set_visibility_state(false)
              l_3_0:_remove_i_from_lod_prio(i, anim_lod)
              l_3_0._gfx_lod_data.next_chk_prio_i = i + 1
              do return end
            else
              if not world_in_view_with_options(World, com[i], 0, 120, 18000) then
                states[i] = false
                units[i]:base():set_visibility_state(false)
                l_3_0:_remove_i_from_lod_prio(i, anim_lod)
                l_3_0._gfx_lod_data.next_chk_prio_i = i + 1
                do return end
              else
                local my_wgt = mvec3_dir(tmp_vec1, cam_pos, com[i])
                local dot = (mvec3_dot(tmp_vec1, pl_fwd))
                local previous_prio = nil
                for prio,i_entry in ipairs(imp_i_list) do
                  if i == i_entry then
                    previous_prio = prio
                else
                  end
                end
                my_wgt = my_wgt * my_wgt * (1 - dot)
                local i_wgt = #imp_wgt_list
                repeat
                  if i_wgt > 0 then
                    if previous_prio ~= i_wgt and imp_wgt_list[i_wgt] <= my_wgt then
                      do return end
                    end
                    i_wgt = i_wgt - 1
                  elseif not previous_prio or i_wgt <= previous_prio then
                    i_wgt = i_wgt + 1
                  end
                  if i_wgt ~= previous_prio then
                    if previous_prio then
                      t_rem(imp_i_list, previous_prio)
                      t_rem(imp_wgt_list, previous_prio)
                      if previous_prio <= nr_lod_1 and nr_lod_1 < i_wgt and nr_lod_1 <= #imp_i_list then
                        local promote_i = imp_i_list[nr_lod_1]
                        states[promote_i] = 1
                        units[promote_i]:base():set_visibility_state(1)
                      elseif nr_lod_1 < previous_prio and i_wgt <= nr_lod_1 then
                        local denote_i = imp_i_list[nr_lod_1]
                        states[denote_i] = 2
                        units[denote_i]:base():set_visibility_state(2)
                      elseif i_wgt <= nr_lod_total and #imp_i_list == nr_lod_total then
                        local kick_i = imp_i_list[nr_lod_total]
                        states[kick_i] = 3
                        units[kick_i]:base():set_visibility_state(3)
                        t_rem(imp_wgt_list)
                        t_rem(imp_i_list)
                      end
                    end
                    local lod_stage = nil
                    if i_wgt <= nr_lod_total then
                      t_ins(imp_wgt_list, i_wgt, my_wgt)
                      t_ins(imp_i_list, i_wgt, i)
                      lod_stage = i_wgt <= nr_lod_1 and 1 or 2
                    else
                      lod_stage = 3
                      l_3_0:_remove_i_from_lod_prio(i, anim_lod)
                    end
                    if states[i] ~= lod_stage then
                      states[i] = lod_stage
                      units[i]:base():set_visibility_state(lod_stage)
                    end
                  end
                  l_3_0._gfx_lod_data.next_chk_prio_i = i + 1
              end
            end
            if i == nr_entries then
              i = 1
            else
              i = i + 1
            end
          until i == start_i
        end
      end
    end
     -- Warning: missing end command somewhere! Added here
  end
end

EnemyManager._remove_i_from_lod_prio = function(l_4_0, l_4_1, l_4_2)
  if not l_4_2 then
    l_4_2 = managers.user:get_setting("video_animation_lod")
  end
  local nr_i_lod1 = l_4_0._nr_i_lod[l_4_2][1]
  for prio,i_entry in ipairs(l_4_0._gfx_lod_data.prio_i) do
    if l_4_1 == i_entry then
      table.remove(l_4_0._gfx_lod_data.prio_i, prio)
      table.remove(l_4_0._gfx_lod_data.prio_weights, prio)
      if prio <= nr_i_lod1 and nr_i_lod1 < #l_4_0._gfx_lod_data.prio_i then
        local promoted_i_entry = l_4_0._gfx_lod_data.prio_i[prio]
        l_4_0._gfx_lod_data.entries.states[promoted_i_entry] = 1
        l_4_0._gfx_lod_data.entries.units[promoted_i_entry]:base():set_visibility_state(1)
      end
      return 
    end
  end
end

EnemyManager._create_unit_gfx_lod_data = function(l_5_0, l_5_1)
  local lod_entries = l_5_0._gfx_lod_data.entries
  table.insert(lod_entries.units, l_5_1)
  table.insert(lod_entries.states, 1)
  table.insert(lod_entries.move_ext, l_5_1:movement())
  table.insert(lod_entries.trackers, l_5_1:movement():nav_tracker())
  table.insert(lod_entries.com, l_5_1:movement():m_com())
end

EnemyManager._destroy_unit_gfx_lod_data = function(l_6_0, l_6_1)
  local lod_entries = l_6_0._gfx_lod_data.entries
  for i,unit in ipairs(lod_entries.units) do
    if l_6_1 == unit:key() then
      if not lod_entries.states[i] then
        unit:base():set_visibility_state(1)
      end
      local nr_entries = #lod_entries.units
      l_6_0:_remove_i_from_lod_prio(i)
      for prio,i_entry in ipairs(l_6_0._gfx_lod_data.prio_i) do
        if i_entry == nr_entries then
          l_6_0._gfx_lod_data.prio_i[prio] = i
      else
        end
      end
      lod_entries.units[i] = lod_entries.units[nr_entries]
      table.remove(lod_entries.units)
      lod_entries.states[i] = lod_entries.states[nr_entries]
      table.remove(lod_entries.states)
      lod_entries.move_ext[i] = lod_entries.move_ext[nr_entries]
      table.remove(lod_entries.move_ext)
      lod_entries.trackers[i] = lod_entries.trackers[nr_entries]
      table.remove(lod_entries.trackers)
      lod_entries.com[i] = lod_entries.com[nr_entries]
      table.remove(lod_entries.com)
  else
    end
  end
end

EnemyManager.set_gfx_lod_enabled = function(l_7_0, l_7_1)
  if l_7_1 then
    l_7_0._gfx_lod_data.enabled = l_7_1
  else
    if l_7_0._gfx_lod_data.enabled then
      l_7_0._gfx_lod_data.enabled = l_7_1
      local entries = l_7_0._gfx_lod_data.entries
      local units = entries.units
      local states = entries.states
      for i,state in ipairs(states) do
        states[i] = 1
        units[i]:base():set_visibility_state(1)
      end
    end
  end
end

EnemyManager.chk_any_unit_in_slotmask_visible = function(l_8_0, l_8_1, l_8_2, l_8_3)
  if l_8_0._gfx_lod_data.enabled and managers.navigation:is_data_ready() then
    local camera_rot = managers.viewport:get_current_camera_rotation()
    local entries = l_8_0._gfx_lod_data.entries
    local units = entries.units
    local states = entries.states
    local trackers = entries.trackers
    local move_exts = entries.move_ext
    local com = entries.com
    if l_8_3 then
      local chk_vis_func = l_8_3.check_visibility
    end
    local unit_occluded = Unit.occluded
    local occ_skip_units = managers.occlusion._skip_occlusion
    local vis_slotmask = managers.slot:get_mask("AI_visibility")
    for i,state in ipairs(states) do
      local unit = units[i]
      if unit:in_slot(l_8_1) and (occ_skip_units[unit:key()] or (l_8_3 and not chk_vis_func(l_8_3, trackers[i])) or not unit_occluded(unit)) then
        local distance = mvec3_dir(tmp_vec1, l_8_2, com[i])
        if distance < 300 then
          return true
          for (for control),i in (for generator) do
          end
          if distance < 2000 then
            local u_m_head_pos = move_exts[i]:m_head_pos()
            local ray = World:raycast("ray", l_8_2, u_m_head_pos, "slot_mask", vis_slotmask, "report")
            if not ray then
              return true
              for (for control),i in (for generator) do
              end
              ray = World:raycast("ray", l_8_2, com[i], "slot_mask", vis_slotmask, "report")
              if not ray then
                return true
              end
            end
          end
        end
      end
       -- Warning: missing end command somewhere! Added here
    end
     -- Warning: missing end command somewhere! Added here
  end
end

EnemyManager._init_enemy_data = function(l_9_0)
  local enemy_data = {}
  local unit_data = {}
  l_9_0._enemy_data = enemy_data
  enemy_data.unit_data = unit_data
  enemy_data.nr_units = 0
  enemy_data.nr_active_units = 0
  enemy_data.nr_inactive_units = 0
  enemy_data.inactive_units = {}
  enemy_data.max_nr_active_units = 20
  enemy_data.corpses = {}
  enemy_data.nr_corpses = 0
  l_9_0._civilian_data = {unit_data = {}}
  l_9_0._queued_tasks = {}
  l_9_0._queued_task_executed = nil
  l_9_0._delayed_clbks = {}
  l_9_0._t = 0
  l_9_0._gfx_lod_data = {}
  l_9_0._gfx_lod_data.enabled = true
  l_9_0._gfx_lod_data.prio_i = {}
  l_9_0._gfx_lod_data.prio_weights = {}
  l_9_0._gfx_lod_data.next_chk_prio_i = 1
  l_9_0._gfx_lod_data.entries = {}
  local lod_entries = l_9_0._gfx_lod_data.entries
  lod_entries.units = {}
  lod_entries.states = {}
  lod_entries.move_ext = {}
  lod_entries.trackers = {}
  lod_entries.com = {}
  l_9_0._corpse_disposal_enabled = 0
end

EnemyManager.all_enemies = function(l_10_0)
  return l_10_0._enemy_data.unit_data
end

EnemyManager.all_civilians = function(l_11_0)
  return l_11_0._civilian_data.unit_data
end

EnemyManager.is_civilian = function(l_12_0, l_12_1)
   -- DECOMPILER ERROR: Confused while interpreting a jump as a 'while'

end
return true
end

EnemyManager.queue_task = function(l_13_0, l_13_1, l_13_2, l_13_3, l_13_4, l_13_5, l_13_6)
  local task_data = {clbk = l_13_2, id = l_13_1, data = l_13_3, t = l_13_4, v_cb = l_13_5, asap = l_13_6}
  table.insert(l_13_0._queued_tasks, task_data)
  if not l_13_4 and #l_13_0._queued_tasks <= 1 and not l_13_0._queued_task_executed then
    l_13_0:_execute_queued_task(1)
  end
end

EnemyManager.unqueue_task = function(l_14_0, l_14_1)
  local tasks = l_14_0._queued_tasks
  do
    local i = #tasks
    repeat
      if i > 0 then
        if tasks[i].id == l_14_1 then
          table.remove(tasks, i)
          return 
        end
        i = i - 1
      else
        debug_pause("[EnemyManager:unqueue_task] task", l_14_1, "was not queued!!!")
      end
       -- Warning: missing end command somewhere! Added here
    end
     -- Warning: missing end command somewhere! Added here
  end
end

EnemyManager.unqueue_task_debug = function(l_15_0, l_15_1)
  if not l_15_1 then
    Application:stack_dump()
  end
  local tasks = l_15_0._queued_tasks
  local i = #tasks
  local removed = nil
  repeat
    if i > 0 then
      if tasks[i].id == l_15_1 then
        if removed then
          debug_pause("DOUBLE TASK AT ", i, l_15_1)
        else
          table.remove(tasks, i)
          removed = true
        end
        i = i - 1
      elseif not removed then
        debug_pause("[EnemyManager:unqueue_task] task", l_15_1, "was not queued!!!")
      end
       -- Warning: missing end command somewhere! Added here
    end
     -- Warning: missing end command somewhere! Added here
  end
end

EnemyManager.has_task = function(l_16_0, l_16_1)
  local tasks = l_16_0._queued_tasks
  local i = #tasks
  local count = 0
  repeat
    if i > 0 then
      if tasks[i].id == l_16_1 then
        count = count + 1
      end
      i = i - 1
    elseif (count <= 0 or not count) then
       -- DECOMPILER ERROR: Attempted to build a boolean expression without a pending context

      return error_maybe_false
    end
     -- Warning: missing end command somewhere! Added here
  end
end

EnemyManager._execute_queued_task = function(l_17_0, l_17_1)
  local task = table.remove(l_17_0._queued_tasks, l_17_1)
  l_17_0._queued_task_executed = true
  if task.data and task.data.unit and not alive(task.data.unit) then
    print("[EnemyManager:_execute_queued_task] dead unit", inspect(task))
    Application:stack_dump()
  end
  if task.v_cb then
    task.v_cb(task.id)
  end
  task.clbk(task.data)
end

EnemyManager._update_queued_tasks = function(l_18_0, l_18_1)
  local i_asap_task, asp_task_t = nil, nil
  for i_task,task_data in ipairs(l_18_0._queued_tasks) do
    if not task_data.t or task_data.t < l_18_1 then
      l_18_0:_execute_queued_task(i_task)
      do return end
      for (for control),i_task in (for generator) do
      end
      if task_data.asap and (not asp_task_t or task_data.t < asp_task_t) then
        i_asap_task = i_task
        asp_task_t = task_data.t
      end
    end
    if i_asap_task and not l_18_0._queued_task_executed then
      l_18_0:_execute_queued_task(i_asap_task)
    end
    local all_clbks = l_18_0._delayed_clbks
    if all_clbks[1] and all_clbks[1][2] < l_18_1 then
      local clbk = table.remove(all_clbks, 1)[3]
      clbk()
    end
     -- Warning: missing end command somewhere! Added here
  end
end

EnemyManager.add_delayed_clbk = function(l_19_0, l_19_1, l_19_2, l_19_3)
  if not l_19_2 then
    debug_pause("[EnemyManager:add_delayed_clbk] Empty callback object!!!")
  end
  local clbk_data = {l_19_1, l_19_3, l_19_2}
  local all_clbks = l_19_0._delayed_clbks
  do
    local i = #all_clbks
    repeat
      if i > 0 and l_19_3 < all_clbks[i][2] then
        i = i - 1
      else
        table.insert(all_clbks, i + 1, clbk_data)
      end
       -- Warning: missing end command somewhere! Added here
    end
     -- Warning: missing end command somewhere! Added here
  end
end

EnemyManager.remove_delayed_clbk = function(l_20_0, l_20_1)
  local all_clbks = l_20_0._delayed_clbks
  for i,clbk_data in ipairs(all_clbks) do
    if clbk_data[1] == l_20_1 then
      table.remove(all_clbks, i)
      return 
    end
  end
  debug_pause("[EnemyManager:remove_delayed_clbk] id", l_20_1, "was not scheduled!!!")
end

EnemyManager.reschedule_delayed_clbk = function(l_21_0, l_21_1, l_21_2)
  local all_clbks = l_21_0._delayed_clbks
  do
    local clbk_data = nil
    for i,clbk_d in ipairs(all_clbks) do
      if clbk_d[1] == l_21_1 then
        clbk_data = table.remove(all_clbks, i)
    else
      end
    end
    if clbk_data then
      clbk_data[2] = l_21_2
      local i = #all_clbks
      repeat
        if i > 0 and l_21_2 < all_clbks[i][2] then
          i = i - 1
        else
          table.insert(all_clbks, i + 1, clbk_data)
          return 
        end
        debug_pause("[EnemyManager:reschedule_delayed_clbk] id", l_21_1, "was not scheduled!!!")
      end
       -- Warning: missing end command somewhere! Added here
    end
     -- Warning: missing end command somewhere! Added here
  end
end

EnemyManager.force_delayed_clbk = function(l_22_0, l_22_1)
  local all_clbks = l_22_0._delayed_clbks
  for i,clbk_data in ipairs(all_clbks) do
    if clbk_data[1] == l_22_1 then
      local clbk = table.remove(all_clbks, 1)[3]
      clbk()
      return 
    end
  end
  debug_pause("[EnemyManager:force_delayed_clbk] id", l_22_1, "was not scheduled!!!")
end

EnemyManager.queued_tasks_by_callback = function(l_23_0)
  local t = TimerManager:game():time()
  local categorised_queued_tasks = {}
  local congestion = 0
  for i_task,task_data in ipairs(l_23_0._queued_tasks) do
    if categorised_queued_tasks[task_data.clbk] then
      categorised_queued_tasks[task_data.clbk].amount = categorised_queued_tasks[task_data.clbk].amount + 1
    else
      categorised_queued_tasks[task_data.clbk] = {amount = 1, key = task_data.id}
    end
    if not task_data.t or task_data.t < t then
      congestion = congestion + 1
    end
  end
  print("congestion", congestion)
  for clbk,data in pairs(categorised_queued_tasks) do
    print(data.key, data.amount)
  end
end

EnemyManager.register_enemy = function(l_24_0, l_24_1)
  local char_tweak = tweak_data.character[l_24_1:base()._tweak_table]
  local u_data = {unit = l_24_1, m_pos = l_24_1:movement():m_pos(), tracker = l_24_1:movement():nav_tracker(), importance = 0, char_tweak = char_tweak, so_access = managers.navigation:convert_access_flag(char_tweak.access)}
  l_24_0._enemy_data.unit_data[l_24_1:key()] = u_data
  l_24_1:base():add_destroy_listener(l_24_0._unit_clbk_key, callback(l_24_0, l_24_0, "on_enemy_destroyed"))
  l_24_0:on_enemy_registered(l_24_1)
end

EnemyManager.on_enemy_died = function(l_25_0, l_25_1, l_25_2)
  local u_key = l_25_1:key()
  local enemy_data = l_25_0._enemy_data
  local u_data = enemy_data.unit_data[u_key]
  l_25_0:on_enemy_unregistered(l_25_1)
  enemy_data.unit_data[u_key] = nil
  if enemy_data.nr_corpses == 0 and l_25_0:is_corpse_disposal_enabled() then
    l_25_0:queue_task("EnemyManager._upd_corpse_disposal", EnemyManager._upd_corpse_disposal, l_25_0, l_25_0._t + l_25_0._corpse_disposal_upd_interval)
  end
  enemy_data.nr_corpses = enemy_data.nr_corpses + 1
  enemy_data.corpses[u_key] = u_data
  u_data.death_t = l_25_0._t
  l_25_0:_destroy_unit_gfx_lod_data(u_key)
  u_data.u_id = l_25_1:id()
  Network:detach_unit(l_25_1)
end

EnemyManager.on_enemy_destroyed = function(l_26_0, l_26_1)
  local u_key = l_26_1:key()
  local enemy_data = l_26_0._enemy_data
  if enemy_data.unit_data[u_key] then
    l_26_0:on_enemy_unregistered(l_26_1)
    enemy_data.unit_data[u_key] = nil
    l_26_0:_destroy_unit_gfx_lod_data(u_key)
  else
    if enemy_data.corpses[u_key] then
      enemy_data.nr_corpses = enemy_data.nr_corpses - 1
      enemy_data.corpses[u_key] = nil
      if enemy_data.nr_corpses == 0 and l_26_0:is_corpse_disposal_enabled() then
        l_26_0:unqueue_task("EnemyManager._upd_corpse_disposal")
      end
    end
  end
end

EnemyManager.on_enemy_registered = function(l_27_0, l_27_1)
  l_27_0._enemy_data.nr_units = l_27_0._enemy_data.nr_units + 1
  l_27_0:_create_unit_gfx_lod_data(l_27_1, true)
  managers.groupai:state():on_enemy_registered(l_27_1)
end

EnemyManager.on_enemy_unregistered = function(l_28_0, l_28_1)
  l_28_0._enemy_data.nr_units = l_28_0._enemy_data.nr_units - 1
  managers.groupai:state():on_enemy_unregistered(l_28_1)
end

EnemyManager.register_civilian = function(l_29_0, l_29_1)
  l_29_1:base():add_destroy_listener(l_29_0._unit_clbk_key, callback(l_29_0, l_29_0, "on_civilian_destroyed"))
  l_29_0:_create_unit_gfx_lod_data(l_29_1, true)
  local char_tweak = tweak_data.character[l_29_1:base()._tweak_table]
  l_29_0._civilian_data.unit_data[l_29_1:key()] = {unit = l_29_1, m_pos = l_29_1:movement():m_pos(), tracker = l_29_1:movement():nav_tracker(), char_tweak = char_tweak, so_access = managers.navigation:convert_access_flag(char_tweak.access), is_civilian = true}
end

EnemyManager.on_civilian_died = function(l_30_0, l_30_1, l_30_2)
  local u_key = l_30_1:key()
  managers.groupai:state():on_civilian_unregistered(l_30_1)
  if Network:is_server() and l_30_2.attacker_unit and not l_30_1:base().enemy then
    managers.groupai:state():hostage_killed(l_30_2.attacker_unit)
  end
  local u_data = l_30_0._civilian_data.unit_data[u_key]
  local enemy_data = l_30_0._enemy_data
  if enemy_data.nr_corpses == 0 and l_30_0:is_corpse_disposal_enabled() then
    l_30_0:queue_task("EnemyManager._upd_corpse_disposal", EnemyManager._upd_corpse_disposal, l_30_0, l_30_0._t + l_30_0._corpse_disposal_upd_interval)
  end
  enemy_data.nr_corpses = enemy_data.nr_corpses + 1
  enemy_data.corpses[u_key] = u_data
  u_data.death_t = TimerManager:game():time()
  l_30_0._civilian_data.unit_data[u_key] = nil
  l_30_0:_destroy_unit_gfx_lod_data(u_key)
  u_data.u_id = l_30_1:id()
  Network:detach_unit(l_30_1)
end

EnemyManager.on_civilian_destroyed = function(l_31_0, l_31_1)
  local u_key = l_31_1:key()
  local enemy_data = l_31_0._enemy_data
  if enemy_data.corpses[u_key] then
    enemy_data.nr_corpses = enemy_data.nr_corpses - 1
    enemy_data.corpses[u_key] = nil
    if enemy_data.nr_corpses == 0 and l_31_0:is_corpse_disposal_enabled() then
      l_31_0:unqueue_task("EnemyManager._upd_corpse_disposal")
    else
      managers.groupai:state():on_civilian_unregistered(l_31_1)
      l_31_0._civilian_data.unit_data[u_key] = nil
      l_31_0:_destroy_unit_gfx_lod_data(u_key)
    end
  end
end

EnemyManager.on_criminal_registered = function(l_32_0, l_32_1)
  l_32_0:_create_unit_gfx_lod_data(l_32_1, false)
end

EnemyManager.on_criminal_unregistered = function(l_33_0, l_33_1)
  l_33_0:_destroy_unit_gfx_lod_data(l_33_1)
end

EnemyManager._upd_corpse_disposal = function(l_34_0)
  local t = TimerManager:game():time()
  local enemy_data = l_34_0._enemy_data
  local nr_corpses = enemy_data.nr_corpses
  local disposals_needed = nr_corpses - l_34_0._MAX_NR_CORPSES
  local corpses = enemy_data.corpses
  local nav_mngr = managers.navigation
  local player = (managers.player:player_unit())
  local pl_tracker, cam_pos, cam_fwd = nil, nil, nil
  if player then
    pl_tracker = player:movement():nav_tracker()
    cam_pos = player:movement():m_head_pos()
    cam_fwd = player:camera():forward()
  else
    if managers.viewport:get_current_camera() then
      cam_pos = managers.viewport:get_current_camera_position()
      cam_fwd = managers.viewport:get_current_camera_rotation():y()
    end
  end
  local to_dispose = {}
  local nr_found = 0
  if pl_tracker then
    for u_key,u_data in pairs(corpses) do
      local u_tracker = u_data.tracker
      if u_tracker and not pl_tracker:check_visibility(u_tracker) then
        to_dispose[u_key] = true
        nr_found = nr_found + 1
      end
    end
  end
  if #to_dispose < disposals_needed then
    if cam_pos then
      for u_key,u_data in pairs(corpses) do
        local u_pos = u_data.m_pos
        if not to_dispose[u_key] and mvec3_dis(cam_pos, u_pos) > 300 and mvector3.dot(cam_fwd, u_pos - cam_pos) < 0 then
          to_dispose[u_key] = true
          nr_found = nr_found + 1
      else
        if nr_found == disposals_needed then
          end
        end
        if nr_found < disposals_needed then
          local oldest_u_key, oldest_t = nil, nil
          for u_key,u_data in pairs(corpses) do
            if (not oldest_t or u_data.death_t < oldest_t) and not to_dispose[u_key] then
              oldest_u_key = u_key
              oldest_t = u_data.death_t
            end
          end
          if oldest_u_key then
            to_dispose[oldest_u_key] = true
            nr_found = nr_found + 1
          end
        end
      end
      for u_key,_ in pairs(to_dispose) do
        local u_data = corpses[u_key]
        if alive(u_data.unit) then
          u_data.unit:base():set_slot(u_data.unit, 0)
        end
        corpses[u_key] = nil
      end
      enemy_data.nr_corpses = nr_corpses - (nr_found)
      if nr_corpses > 0 then
        if l_34_0._MAX_NR_CORPSES >= enemy_data.nr_corpses or not 0 then
          local delay = l_34_0._corpse_disposal_upd_interval
        end
        l_34_0:queue_task("EnemyManager._upd_corpse_disposal", EnemyManager._upd_corpse_disposal, l_34_0, t + delay)
      end
       -- Warning: missing end command somewhere! Added here
    end
     -- Warning: missing end command somewhere! Added here
  end
end

EnemyManager.set_corpse_disposal_enabled = function(l_35_0, l_35_1)
  local was_enabled = l_35_0._corpse_disposal_enabled > 0
  l_35_0._corpse_disposal_enabled = l_35_0._corpse_disposal_enabled + (l_35_1 and 1 or 0)
  if was_enabled and l_35_0._corpse_disposal_enabled < 0 then
    l_35_0:unqueue_task("EnemyManager._upd_corpse_disposal")
  elseif not was_enabled and l_35_0._corpse_disposal_enabled > 0 and l_35_0._enemy_data.nr_corpses > 0 then
    l_35_0:queue_task("EnemyManager._upd_corpse_disposal", EnemyManager._upd_corpse_disposal, l_35_0, TimerManager:game():time() + l_35_0._corpse_disposal_upd_interval)
  end
end

EnemyManager.is_corpse_disposal_enabled = function(l_36_0)
  return (l_36_0._corpse_disposal_enabled > 0 and true)
end

EnemyManager.on_simulation_ended = function(l_37_0)
end

EnemyManager.dispose_all_corpses = function(l_38_0)
  local u_key, corpse_data = next(l_38_0._enemy_data.corpses)
  if u_key then
    World:delete_unit(corpse_data.unit)
  end
end

EnemyManager.save = function(l_39_0, l_39_1)
  local my_data = nil
  if not managers.groupai:state():enemy_weapons_hot() then
    if not my_data then
      my_data = {}
    end
    for u_key,u_data in pairs(l_39_0._enemy_data.corpses) do
      if not my_data.corpses then
        my_data.corpses = {}
      end
       -- DECOMPILER ERROR: Confused while interpreting a jump as a 'while'

    end
    local corpse_data = {u_data.unit:movement():m_pos(), true, true, u_data.unit:interaction().tweak_data, u_data.u_id}
    table.insert(my_data.corpses, corpse_data)
  end
end
l_39_1.enemy_manager = my_data
end

EnemyManager.load = function(l_40_0, l_40_1)
  local my_data = l_40_1.enemy_manager
  if not my_data then
    return 
  end
  if my_data.corpses then
    local civ_spawn_state = Idstring("civilian_death_dummy")
    local ene_spawn_state = Idstring("enemy_death_dummy")
    local civ_corpse_u_name = Idstring("units/payday2/characters/civ_male_dummy_corpse/civ_male_dummy_corpse")
    local ene_corpse_u_name = Idstring("units/payday2/characters/ene_dummy_corpse/ene_dummy_corpse")
    for _,corpse_data in pairs(my_data.corpses) do
      local corpse = World:spawn_unit(corpse_data[2] and civ_corpse_u_name or ene_corpse_u_name, corpse_data[1], Rotation(math.random() * 360, 0, 0))
      if not corpse_data[2] or not civ_spawn_state then
        corpse:play_state(not corpse or ene_spawn_state)
      end
      corpse:interaction():set_tweak_data(corpse_data[4])
      corpse:interaction():set_active(corpse_data[3])
      corpse:base():add_destroy_listener("EnemyManager_corpse_dummy" .. tostring(corpse:key()), callback(l_40_0, l_40_0, corpse_data[2] and "on_civilian_destroyed" or "on_enemy_destroyed"))
      l_40_0._enemy_data.corpses[corpse:key()] = {death_t = 0, unit = corpse, u_id = corpse_data[5], m_pos = corpse:position()}
      l_40_0._enemy_data.nr_corpses = l_40_0._enemy_data.nr_corpses + 1
    end
  end
end

EnemyManager.get_corpse_unit_data_from_key = function(l_41_0, l_41_1)
  return l_41_0._enemy_data.corpses[l_41_1]
end

EnemyManager.get_corpse_unit_data_from_id = function(l_42_0, l_42_1)
  for u_key,u_data in pairs(l_42_0._enemy_data.corpses) do
    if l_42_1 == u_data.u_id then
      return u_data
    end
  end
end

EnemyManager.remove_corpse_by_id = function(l_43_0, l_43_1)
  for u_key,u_data in pairs(l_43_0._enemy_data.corpses) do
    if l_43_1 == u_data.u_id then
      u_data.unit:set_slot(0)
  else
    end
  end
end


