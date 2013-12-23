-- Decompiled using luadec 2.0.1 by sztupy (http://winmo.sztupy.hu)
-- Command line was: F:\SteamLibrary\SteamApps\common\PAYDAY 2\lua\lib\managers\objectivesmanager.luac 

if not ObjectivesManager then
  ObjectivesManager = class()
end
ObjectivesManager.PATH = "gamedata/objectives"
ObjectivesManager.FILE_EXTENSION = "objective"
ObjectivesManager.FULL_PATH = ObjectivesManager.PATH .. "." .. ObjectivesManager.FILE_EXTENSION
ObjectivesManager.REMINDER_INTERVAL = 240
ObjectivesManager.init = function(l_1_0)
  l_1_0._objectives = {}
  l_1_0._active_objectives = {}
  l_1_0._remind_objectives = {}
  l_1_0._completed_objectives = {}
  l_1_0._completed_objectives_ordered = {}
  l_1_0._read_objectives = {}
  l_1_0._objectives_level_id = {}
  l_1_0:_parse_objectives()
end

ObjectivesManager._parse_objectives = function(l_2_0)
  do
    local list = PackageManager:script_data(l_2_0.FILE_EXTENSION:id(), l_2_0.PATH:id())
    for _,data in ipairs(list) do
      if data._meta == "objective" then
        l_2_0:_parse_objective(data)
        for (for control),_ in (for generator) do
        end
        Application:error("Unknown node \"" .. tostring(data._meta) .. "\" in \"" .. l_2_0.FULL_PATH .. "\". Expected \"objective\" node.")
      end
    end
     -- Warning: missing end command somewhere! Added here
  end
end

ObjectivesManager._parse_objective = function(l_3_0, l_3_1)
  local id = l_3_1.id
  local text = managers.localization:text(l_3_1.text)
  local description = managers.localization:text(l_3_1.description)
  local prio = l_3_1.prio
  local amount = l_3_1.amount
  if l_3_1.amount_text then
    local amount_text = managers.localization:text(l_3_1.amount_text)
  end
  local level_id = l_3_1.level_id
  local xp_weight = l_3_1.xp_weight
  local sub_objectives = {}
  for _,sub in ipairs(l_3_1) do
    local sub_text = managers.localization:text(sub.text)
    sub_objectives[sub.id] = {id = sub.id, text = sub_text}
  end
   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

  l_3_0._objectives[id], {text = text, description = description, prio = prio, id = id}.xp_weight, {text = text, description = description, prio = prio, id = id}.level_id, {text = text, description = description, prio = prio, id = id}.sub_objectives, {text = text, description = description, prio = prio, id = id}.amount_text, {text = text, description = description, prio = prio, id = id}.current_amount, {text = text, description = description, prio = prio, id = id}.amount = {text = text, description = description, prio = prio, id = id}, xp_weight, level_id, sub_objectives, amount_text, amount and 0 or nil, amount
  if level_id then
    if not l_3_0._objectives_level_id[level_id] then
      l_3_0._objectives_level_id[level_id] = {}
    end
    l_3_0._objectives_level_id[level_id][id] = {xp_weight = xp_weight or 0}
  end
end

ObjectivesManager.update = function(l_4_0, l_4_1, l_4_2)
  for id,data in pairs(l_4_0._remind_objectives) do
    if data.next_t < l_4_1 then
      l_4_0:_remind_objetive(id)
    end
  end
end

ObjectivesManager._remind_objetive = function(l_5_0, l_5_1, l_5_2)
  if not Application:editor() and managers.platform:presence() ~= "Playing" then
    return 
  end
  if l_5_0._remind_objectives[l_5_1] then
    l_5_0._remind_objectives[l_5_1].next_t = Application:time() + l_5_0.REMINDER_INTERVAL
  end
  if managers.user:get_setting("objective_reminder") then
    if not l_5_2 then
      l_5_2 = "hud_objective_reminder"
    end
    local objective = l_5_0._objectives[l_5_1]
    local title_message = managers.localization:text(l_5_2)
    local text = objective.text
    managers.hud:present_mid_text({text = text, title = title_message, time = 4, icon = nil, event = nil})
  end
  managers.hud:remind_objective(l_5_1)
end

ObjectivesManager.update_objective = function(l_6_0, l_6_1, l_6_2)
  l_6_0:activate_objective(l_6_1, l_6_2, {title_message = managers.localization:text("mission_objective_updated")})
end

ObjectivesManager.activate_objective = function(l_7_0, l_7_1, l_7_2, l_7_3)
  if not l_7_1 or not l_7_0._objectives[l_7_1] then
    Application:stack_dump_error("Bad id to activate objective, " .. tostring(l_7_1) .. ".")
    return 
  end
  if l_7_0._active_objectives[l_7_1] or l_7_0._completed_objectives[l_7_1] then
    Application:error("Tried to activate objective " .. tostring(l_7_1) .. ". This objective is already active or completed")
  end
  local objective = l_7_0._objectives[l_7_1]
  for _,sub_objective in pairs(objective.sub_objectives) do
    sub_objective.completed = false
  end
  if (not l_7_2 or not l_7_2.current_amount) and (not l_7_3 or not l_7_3.amount or not 0) then
    objective.current_amount = objective.current_amount
  end
  if (not l_7_2 or not l_7_2.amount) and (not l_7_3 or not l_7_3.amount) then
    objective.amount = objective.amount
  end
  managers.hud:activate_objective({id = l_7_1, text = objective.text, sub_objectives = objective.sub_objectives, amount = objective.amount, current_amount = objective.current_amount, amount_text = objective.amount_text})
  if not l_7_2 then
    if not l_7_3 or not l_7_3.title_message then
      local title_message = managers.localization:text("mission_objective_activated")
    end
    local text = objective.text
    managers.hud:present_mid_text({text = text, title = title_message, time = 4, icon = nil, event = "stinger_objectivecomplete"})
  end
  l_7_0._active_objectives[l_7_1] = objective
  l_7_0._remind_objectives[l_7_1] = {next_t = Application:time() + l_7_0.REMINDER_INTERVAL}
end

ObjectivesManager.remove_objective = function(l_8_0, l_8_1, l_8_2)
  if not l_8_2 then
    if not l_8_1 or not l_8_0._objectives[l_8_1] then
      Application:stack_dump_error("Bad id to remove objective, " .. tostring(l_8_1) .. ".")
      return 
    end
    if not l_8_0._active_objectives[l_8_1] then
      Application:error("Tried to remove objective " .. tostring(l_8_1) .. ". This objective has never been given to the player.")
      return 
    end
  end
  local objective = l_8_0._objectives[l_8_1]
  managers.hud:complete_objective({id = l_8_1, text = objective.text, remove = true})
  l_8_0._active_objectives[l_8_1] = nil
  l_8_0._remind_objectives[l_8_1] = nil
end

ObjectivesManager.complete_objective = function(l_9_0, l_9_1, l_9_2)
  if not l_9_2 then
    if not l_9_1 or not l_9_0._objectives[l_9_1] then
      Application:stack_dump_error("Bad id to complete objective, " .. tostring(l_9_1) .. ".")
      return 
    end
    if not l_9_0._active_objectives[l_9_1] then
      if not l_9_0._completed_objectives[l_9_1] then
        l_9_0._completed_objectives[l_9_1] = l_9_0._objectives[l_9_1]
        table.insert(l_9_0._completed_objectives_ordered, 1, l_9_1)
      end
      Application:error("Tried to complete objective " .. tostring(l_9_1) .. ". This objective has never been given to the player.")
      return 
    end
  end
  local objective = l_9_0._objectives[l_9_1]
  if objective.amount then
    objective.current_amount = objective.current_amount + 1
    managers.hud:update_amount_objective({id = l_9_1, text = objective.text, amount_text = objective.amount_text, amount = objective.amount, current_amount = objective.current_amount})
    if objective.current_amount < objective.amount then
      l_9_0:_remind_objetive(l_9_1, "mission_objective_updated")
      return 
    end
    objective.current_amount = 0
  end
  managers.hud:complete_objective({id = l_9_1, text = objective.text})
  managers.statistics:objective_completed()
  l_9_0._completed_objectives[l_9_1] = objective
  table.insert(l_9_0._completed_objectives_ordered, 1, l_9_1)
  l_9_0._active_objectives[l_9_1] = nil
  l_9_0._remind_objectives[l_9_1] = nil
end

ObjectivesManager.complete_sub_objective = function(l_10_0, l_10_1, l_10_2, l_10_3)
  if not l_10_3 then
    if not l_10_1 or not l_10_0._objectives[l_10_1] then
      Application:stack_dump_error("Bad id to complete objective, " .. tostring(l_10_1) .. ".")
      return 
    end
    if not l_10_0._active_objectives[l_10_1] then
      if not l_10_0._completed_objectives[l_10_1] then
        l_10_0._completed_objectives[l_10_1] = l_10_0._objectives[l_10_1]
        table.insert(l_10_0._completed_objectives_ordered, 1, l_10_1)
      end
      Application:error("Tried to complete objective " .. tostring(l_10_1) .. ". This objective has never been given to the player.")
      return 
    end
  end
  local objective = l_10_0._objectives[l_10_1]
  local sub_objective = objective.sub_objectives[l_10_2]
  if not sub_objective then
    Application:error("No sub objective " .. tostring(l_10_2) .. ". For objective " .. tostring(l_10_1) .. "")
    return 
  end
  sub_objective.completed = true
  managers.hud:complete_sub_objective({text = objective.text, sub_id = l_10_2})
  local completed = true
  for _,sub_objective in pairs(objective.sub_objectives) do
    if not sub_objective.completed then
      completed = false
  else
    end
  end
  if completed then
    l_10_0:complete_objective(l_10_1)
  end
end

ObjectivesManager.objective_is_active = function(l_11_0, l_11_1)
  return l_11_0._active_objectives[l_11_1]
end

ObjectivesManager.objective_is_completed = function(l_12_0, l_12_1)
  return l_12_0._completed_objectives[l_12_1]
end

ObjectivesManager.get_objective = function(l_13_0, l_13_1)
  return l_13_0._objectives[l_13_1]
end

ObjectivesManager.get_all_objectives = function(l_14_0)
  local res = {}
  mix(res, l_14_0._active_objectives, l_14_0._completed_objectives)
  return res
end

ObjectivesManager.get_active_objectives = function(l_15_0)
  return l_15_0._active_objectives
end

ObjectivesManager.get_completed_objectives = function(l_16_0)
  return l_16_0._completed_objectives
end

ObjectivesManager.get_completed_objectives_ordered = function(l_17_0)
  return l_17_0._completed_objectives_ordered
end

ObjectivesManager.objectives_by_name = function(l_18_0)
  local t = {}
  for name,_ in pairs(l_18_0._objectives) do
    table.insert(t, name)
  end
  table.sort(t)
  return t
end

ObjectivesManager.sub_objectives_by_name = function(l_19_0, l_19_1)
  local t = {}
  local objective = l_19_0._objectives[l_19_1]
  if objective then
    for name,_ in pairs(objective.sub_objectives) do
      table.insert(t, name)
    end
  end
  table.sort(t)
  return t
end

ObjectivesManager._get_xp = function(l_20_0, l_20_1, l_20_2)
  if not l_20_0._objectives_level_id[l_20_1] then
    Application:error("Had no xp for level", l_20_1)
    return 0
  end
  if not l_20_0._objectives_level_id[l_20_1][l_20_2] then
    Application:error("Had no xp for objective", l_20_2)
    return 0
  end
  local xp_weight = l_20_0:_get_real_xp_weight(l_20_1, l_20_0._objectives_level_id[l_20_1][l_20_2].xp_weight)
  return math.round(xp_weight * tweak_data:get_value("experience_manager", "total_level_objectives"))
end

ObjectivesManager._get_real_xp_weight = function(l_21_0, l_21_1, l_21_2)
  local total_xp_weight = l_21_0:_total_xp_weight(l_21_1)
  return l_21_2 / total_xp_weight
end

ObjectivesManager._total_xp_weight = function(l_22_0, l_22_1)
  if not l_22_0._objectives_level_id[l_22_1] then
    return 0
  end
  local xp_weight = 0
  for obj,data in pairs(l_22_0._objectives_level_id[l_22_1]) do
    xp_weight = xp_weight + data.xp_weight
  end
  return xp_weight
end

ObjectivesManager._check_xp_weight = function(l_23_0, l_23_1)
  local total_xp = 0
  local total_xp_weight = l_23_0:_total_xp_weight(l_23_1)
  for obj,data in pairs(l_23_0._objectives_level_id[l_23_1]) do
    local xp = math.round(data.xp_weight / total_xp_weight * tweak_data:get_value("experience_manager", "total_level_objectives"))
    total_xp = total_xp + xp
    print(obj, xp)
  end
  print("total", total_xp)
end

ObjectivesManager.total_objectives = function(l_24_0, l_24_1)
  if not l_24_0._objectives_level_id[l_24_1] then
    return 0
  end
  local i = 0
  for _,_ in pairs(l_24_0._objectives_level_id[l_24_1]) do
    i = i + 1
  end
  return i
end

ObjectivesManager.save = function(l_25_0, l_25_1)
  if next(l_25_0._active_objectives) or next(l_25_0._completed_objectives) or next(l_25_0._read_objectives) then
    local state = {}
    local objective_map = {}
    state.completed_objectives_ordered = l_25_0._completed_objectives_ordered
    for name,objective in pairs(l_25_0._objectives) do
      local save_data = {}
      if l_25_0._active_objectives[name] then
        save_data.active = true
        save_data.current_amount = l_25_0._active_objectives[name].current_amount
        save_data.amount = l_25_0._active_objectives[name].amount
        save_data.sub_objective = {}
        for sub_id,sub_objective in pairs(l_25_0._active_objectives[name].sub_objectives) do
          save_data.sub_objective[sub_id] = sub_objective.completed
        end
      end
      if l_25_0._completed_objectives[name] then
        save_data.complete = true
      end
      if l_25_0._read_objectives[name] then
        save_data.read = true
      end
      if next(save_data) then
        objective_map[name] = save_data
      end
    end
    state.objective_map = objective_map
    l_25_1.ObjectivesManager = state
    return true
  else
    return false
  end
end

ObjectivesManager.load = function(l_26_0, l_26_1)
  local state = l_26_1.ObjectivesManager
  if state then
    l_26_0._completed_objectives_ordered = state.completed_objectives_ordered
    for name,save_data in pairs(state.objective_map) do
      local objective_data = l_26_0._objectives[name]
      if save_data.active then
        l_26_0:activate_objective(name, {current_amount = save_data.current_amount, amount = save_data.amount})
        for sub_id,completed in pairs(save_data.sub_objective) do
          if completed then
            l_26_0:complete_sub_objective(name, sub_id, {})
          end
        end
      end
      if save_data.complete then
        l_26_0._completed_objectives[name] = objective_data
      end
      if save_data.read then
        l_26_0._read_objectives[name] = true
      end
    end
  end
end

ObjectivesManager.reset = function(l_27_0)
  l_27_0._active_objectives = {}
  l_27_0._completed_objectives = {}
  l_27_0._completed_objectives_ordered = {}
  l_27_0._read_objectives = {}
  l_27_0._remind_objectives = {}
  l_27_0:_parse_objectives()
  managers.hud:clear_objectives()
end

ObjectivesManager.set_read = function(l_28_0, l_28_1, l_28_2)
  l_28_0._read_objectives[l_28_1] = l_28_2
end

ObjectivesManager.is_read = function(l_29_0, l_29_1)
  return l_29_0._read_objectives[l_29_1]
end


