-- Decompiled using luadec 2.0.1 by sztupy (http://winmo.sztupy.hu)
-- Command line was: F:\SteamLibrary\SteamApps\common\PAYDAY 2\lua\lib\managers\secretassignmentmanager.luac 

if not SecretAssignmentManager then
  SecretAssignmentManager = class()
end
SecretAssignmentManager.init = function(l_1_0)
  l_1_0._enabled = true
  l_1_0:_setup()
end

SecretAssignmentManager._setup = function(l_2_0)
  l_2_0._debug = false
  l_2_0._assignments = {}
  l_2_0._has_delegated = nil
  l_2_0._current_assignment = nil
  for name,data in pairs(tweak_data.secret_assignment_manager) do
    l_2_0._assignments[name] = {can_be_activated = false, enabled = true}
  end
  l_2_0._chance = {}
  l_2_0._chance.test_interval = 60
  l_2_0._chance.interval_timer = l_2_0._chance.test_interval
  l_2_0._chance.chance = 5
end

SecretAssignmentManager.assignments = function(l_3_0)
  return l_3_0._assignments
end

SecretAssignmentManager.update = function(l_4_0, l_4_1, l_4_2)
  return 
  if l_4_0._current_assignment and l_4_0._current_assignment.timer then
    l_4_0._current_assignment.timer = l_4_0._current_assignment.timer - l_4_2
    managers.hud:feed_secret_assignment_timer(l_4_0._current_assignment.timer)
    if l_4_0._current_assignment.timer < 0 then
      l_4_0._current_assignment.timer = nil
      if tweak_data.secret_assignment_manager[l_4_0._current_assignment.name].time_limit_success then
        l_4_0:_complete_assignment(l_4_0._current_assignment.name)
      else
        l_4_0:_fail_assignment(l_4_0._current_assignment.name)
      end
    end
  end
  if Network:is_client() then
    return 
  end
  if not l_4_0._enabled then
    return 
  end
  if l_4_0._has_delegated then
    return 
  end
  l_4_0._chance.interval_timer = l_4_0._chance.interval_timer - l_4_2
  if l_4_0._chance.interval_timer <= 0 then
    l_4_0._chance.interval_timer = l_4_0._chance.test_interval
    if math.random(l_4_0._chance.chance) == 1 then
      l_4_0:delegate_assignment()
    end
  end
end

SecretAssignmentManager.set_enabled = function(l_5_0, l_5_1)
  l_5_0._enabled = l_5_1
end

SecretAssignmentManager.set_assignment_enabled = function(l_6_0, l_6_1, l_6_2)
  if l_6_0._assignments[l_6_1] then
    l_6_0._assignments[l_6_1].enabled = l_6_2
  else
    Application:error("Can't set enabled state for secret assignment " .. l_6_1)
  end
end

SecretAssignmentManager.register_unit = function(l_7_0, l_7_1)
  if not l_7_1:unit_data().secret_assignment_id then
    return 
  end
  local id = l_7_1:unit_data().secret_assignment_id
  for name,data in pairs(tweak_data.secret_assignment_manager) do
    if name == id then
      l_7_0._assignments[name].can_be_activated = true
      if data.type == "interact" then
        if not l_7_0._assignments[name].available_units then
          l_7_0._assignments[name].available_units = {}
        end
        table.insert(l_7_0._assignments[name].available_units, l_7_1)
        if data.amount > #l_7_0._assignments[name].available_units then
          l_7_0._assignments[name].can_be_activated = not data.amount
        elseif data.type == "kill" then
          l_7_0._assignments[name].unit = l_7_1
          l_7_1:unit_data().mission_element:add_event_callback("death", callback(l_7_0, l_7_0, "unregister_unit"))
      else
        end
      end
       -- Warning: missing end command somewhere! Added here
    end
     -- Warning: missing end command somewhere! Added here
  end
end

SecretAssignmentManager.register_civilian = function(l_8_0, l_8_1)
  local name = "civilian_escape"
  l_8_0._assignments[name].amount_of_units = (l_8_0._assignments[name].amount_of_units or 0) + 1
  l_8_0._assignments[name].can_be_activated = l_8_0._assignments[name].amount_of_units > 0
  l_8_1:unit_data().mission_element:add_event_callback("death", callback(l_8_0, l_8_0, "unregister_civilian"))
  l_8_1:unit_data().mission_element:add_event_callback("fled", callback(l_8_0, l_8_0, "unregister_civilian"))
end

SecretAssignmentManager.unregister_civilian = function(l_9_0, l_9_1)
  local name = "civilian_escape"
  l_9_0._assignments[name].amount_of_units = l_9_0._assignments[name].amount_of_units - 1
  l_9_0._assignments[name].can_be_activated = l_9_0._assignments[name].amount_of_units > 0
end

SecretAssignmentManager.unregister_unit = function(l_10_0, l_10_1, l_10_2)
  if not l_10_1:unit_data().secret_assignment_id then
    return 
  end
  local id = l_10_1:unit_data().secret_assignment_id
  for name,data in pairs(tweak_data.secret_assignment_manager) do
    if name == id then
      if data.type == "interact" then
        for i,u in ipairs(l_10_0._assignments[name].available_units) do
          if u == l_10_1 then
            table.remove(l_10_0._assignments[name].available_units, i)
        else
          end
        end
        l_10_0._assignments[name].can_be_activated = data.amount or 0 < #l_10_0._assignments[name].available_units
      elseif data.type == "kill" and l_10_0._assignments[name].unit == l_10_1 then
        if l_10_2 and l_10_0._assignments[name].assigned then
          l_10_0._assignments[name].peer:send_queued_sync("failed_secret_assignment", name)
        end
        l_10_0._assignments[name].unit = nil
        l_10_0._assignments[name].can_be_activated = false
    else
      end
    end
     -- Warning: missing end command somewhere! Added here
  end
end

SecretAssignmentManager.interacted = function(l_11_0, l_11_1)
  if not l_11_0._assignments[l_11_1].assigned then
    Application:error("Assignment", l_11_1, "has not been given!")
    return 
  end
  if l_11_0._current_assignment.counter then
    l_11_0._current_assignment.counter = l_11_0._current_assignment.counter + 1
    managers.hud:feed_secret_assignment_counter(l_11_0._current_assignment.counter, tweak_data.secret_assignment_manager[l_11_1].amount)
    if l_11_0._current_assignment.counter ~= tweak_data.secret_assignment_manager[l_11_1].amount then
      return 
    end
  end
  l_11_0:_complete_assignment(l_11_1)
end

SecretAssignmentManager.target_killed = function(l_12_0, l_12_1)
  local name = l_12_1:unit_data().secret_assignment_id
  l_12_0._assignments[name].peer:send_queued_sync("complete_secret_assignment", name)
end

SecretAssignmentManager.civilian_escaped = function(l_13_0)
  if not l_13_0._has_delegated then
    return 
  end
  local name = "civilian_escape"
  if l_13_0._has_delegated == name then
    l_13_0._assignments[name].peer:send_queued_sync("failed_secret_assignment", name)
  end
end

SecretAssignmentManager.complete_secret_assignment = function(l_14_0, l_14_1)
  if not l_14_0._current_assignment then
    Application:error("Didn't have a current secret assignment")
    return 
  end
  l_14_0:_complete_assignment(l_14_1)
end

SecretAssignmentManager.failed_secret_assignment = function(l_15_0, l_15_1)
  if not l_15_0._current_assignment then
    Application:error("Didn't have a current secret assignment")
    return 
  end
  l_15_0:_fail_assignment(l_15_1)
end

SecretAssignmentManager._complete_assignment = function(l_16_0, l_16_1)
  local data = tweak_data.secret_assignment_manager[l_16_1]
  local title = managers.localization:text("sa_prefix_completed")
  local text = managers.localization:text(data.title_id)
  managers.hud:present_mid_text({title = title, text = text, time = 4, icon = nil, event = "stinger_feedback_positive"})
  managers.hud:complete_secret_assignment({success = true})
  l_16_0._assignments[l_16_1].completed = true
  l_16_0._assignments[l_16_1].assigned = false
  l_16_0._current_assignment = nil
  if Network:is_server() then
    l_16_0:secret_assignment_done(l_16_1, true)
  else
    managers.network:session():send_to_host("secret_assignment_done", l_16_1, true)
  end
end

SecretAssignmentManager._fail_assignment = function(l_17_0, l_17_1)
  local data = tweak_data.secret_assignment_manager[l_17_1]
  local title = managers.localization:text("sa_prefix_failed")
  local text = managers.localization:text(data.title_id)
  managers.hud:present_mid_text({title = title, text = text, time = 4, icon = nil, event = "stinger_feedback_negative"})
  managers.hud:complete_secret_assignment({success = false})
  l_17_0._assignments[l_17_1].completed = true
  l_17_0._assignments[l_17_1].assigned = false
  if tweak_data.secret_assignment_manager[l_17_1].type == "interact" then
    for _,unit in ipairs(l_17_0._current_assignment.units) do
      unit:interaction():set_assignment(nil)
      unit:interaction():set_active(false)
    end
  end
  l_17_0._current_assignment = nil
  if Network:is_server() then
    l_17_0:secret_assignment_done(l_17_1, false)
  else
    managers.network:session():send_to_host("secret_assignment_done", l_17_1, false)
  end
end

SecretAssignmentManager.secret_assignment_done = function(l_18_0, l_18_1, l_18_2)
  l_18_0._assignments[l_18_1].completed = l_18_2
  l_18_0._assignments[l_18_1].assigned = false
  l_18_0._has_delegated = false
end

SecretAssignmentManager.delegate_assignment = function(l_19_0)
  local can_be_activated = l_19_0:_get_available_assignments()
  if #can_be_activated == 0 then
    return 
  end
  local name = can_be_activated[math.random(#can_be_activated)]
  local peer = l_19_0:_get_peer()
  if not peer then
    return 
  end
  l_19_0._assignments[name].peer = peer
  l_19_0._assignments[name].assigned = true
  if tweak_data.secret_assignment_manager[name].type == "kill" then
    l_19_0._assignments[name].unit:unit_data().mission_element:add_event_callback("death", callback(l_19_0, l_19_0, "target_killed"))
  end
  peer:send_queued_sync("assign_secret_assignment", name)
  l_19_0._has_delegated = name
end

SecretAssignmentManager._get_available_assignments = function(l_20_0)
  if managers.groupai:state():get_assault_mode() then
    return {}
  end
  local t = {}
  for name,data in pairs(l_20_0._assignments) do
    local level_filter = l_20_0:_check_level_filter(name)
    if data.can_be_activated and not l_20_0._debug and not data.assigned and not data.completed and data.enabled and level_filter then
      table.insert(t, name)
    end
  end
  return t
end

SecretAssignmentManager._check_level_filter = function(l_21_0, l_21_1)
  if not Global.level_data.level_id then
    return true
  end
  local level_filter = tweak_data.secret_assignment_manager[l_21_1].level_filter
  if not level_filter then
    return true
  end
  if level_filter.include then
    for _,lvl_id in ipairs(level_filter.include) do
      if lvl_id == Global.level_data.level_id then
        return true
      end
    end
    return false
  end
  if level_filter.exclude then
    for _,lvl_id in ipairs(level_filter.exclude) do
      if lvl_id == Global.level_data.level_id then
        return false
      end
    end
    return true
  end
  return true
end

SecretAssignmentManager._get_peer = function(l_22_0)
  if not managers.network:game() then
    return nil
  end
  local members = {}
  for id,member in pairs(managers.network:game():all_members()) do
    if member:unit() and member:unit():movement():current_state_name() ~= "mask_off" then
      table.insert(members, id)
    end
  end
  if #members > 0 then
    return managers.network:session():peer(members[math.random(#members)])
  end
  return nil
end

SecretAssignmentManager.assign = function(l_23_0, l_23_1)
  local data = tweak_data.secret_assignment_manager[l_23_1]
  l_23_0._current_assignment = l_23_0._assignments[l_23_1]
  l_23_0._current_assignment.name = l_23_1
  l_23_0._current_assignment.timer = data.time_limit
  l_23_0._current_assignment.counter = data.amount and 0 or nil
  l_23_0._assignments[l_23_1].assigned = true
  local title = managers.localization:text("sa_prefix_assign")
  local text = managers.localization:text(data.title_id)
  managers.hud:present_mid_text({title = title, text = text, time = 4, icon = nil, event = "stinger_levelup"})
  local assignment = managers.localization:text(data.title_id)
  local description = managers.localization:text(data.description_id)
  local status_time = not l_23_0._current_assignment.timer or true
  local status_counter = not l_23_0._current_assignment.counter or true
  managers.hud:present_secret_assignment({assignment = assignment, description = description, status_time = status_time, status_counter = status_counter})
  if l_23_0._current_assignment.counter then
    managers.hud:feed_secret_assignment_counter(l_23_0._current_assignment.counter, data.amount)
  end
  if data.type == "interact" then
    l_23_0:_start_interact_assignment(l_23_1)
  elseif data.type == "kill" then
     -- Warning: missing end command somewhere! Added here
  end
end

SecretAssignmentManager._start_interact_assignment = function(l_24_0, l_24_1)
  l_24_0._current_assignment.units = {}
  local counter = tweak_data.secret_assignment_manager[l_24_1].amount or 1
  local t = {}
  for i = 1, #l_24_0._assignments[l_24_1].available_units do
    t[i] = i
  end
  for i = 1, counter do
    local t_val = math.random(#t)
    local val = table.remove(t, t_val)
    local unit = l_24_0._assignments[l_24_1].available_units[val]
    unit:interaction():set_assignment(l_24_1)
    unit:interaction():set_active(true)
    table.insert(l_24_0._current_assignment.units, unit)
  end
end

SecretAssignmentManager.assignment_names = function(l_25_0)
  local t = {}
  for name,_ in pairs(tweak_data.secret_assignment_manager) do
    table.insert(t, name)
  end
  table.sort(t)
  return t
end

SecretAssignmentManager.reset = function(l_26_0)
  l_26_0:_setup()
  managers.hud:complete_secret_assignment({})
end


