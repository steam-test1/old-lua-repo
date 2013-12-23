-- Decompiled using luadec 2.0.1 by sztupy (http://winmo.sztupy.hu)
-- Command line was: F:\SteamLibrary\SteamApps\common\PAYDAY 2\lua\lib\managers\challengesmanager.luac 

if not ChallengesManager then
  ChallengesManager = class()
end
ChallengesManager.init = function(l_1_0)
  l_1_0:_setup()
  tweak_data:add_reload_callback(l_1_0, callback(l_1_0, l_1_0, "reloaded"))
end

ChallengesManager.reloaded = function(l_2_0)
  l_2_0:_setup()
end

ChallengesManager.reset_challenges = function(l_3_0)
  l_3_0:_setup(true)
end

ChallengesManager._setup = function(l_4_0, l_4_1)
  l_4_0._counter_map = {}
  l_4_0._flag_map = {}
  l_4_0._challenges_map = {}
  l_4_0._reset_map = {}
  l_4_0._session_stopped_map = {}
  for category,challenges in pairs(tweak_data.challenges) do
    for name,challenge in pairs(challenges) do
      if managers.dlc:has_full_game() or not challenge.awards_achievment and challenge.in_trial then
        l_4_0._challenges_map[name] = challenge
        if challenge.counter_id then
          if not l_4_0._counter_map[challenge.counter_id] then
            l_4_0._counter_map[challenge.counter_id] = {}
          end
          table.insert(l_4_0._counter_map[challenge.counter_id], name)
        end
        if challenge.flag_id then
          if not l_4_0._flag_map[challenge.flag_id] then
            l_4_0._flag_map[challenge.flag_id] = {}
          end
          table.insert(l_4_0._flag_map[challenge.flag_id], name)
        end
        if challenge.reset_criterias then
          for _,criteria in ipairs(challenge.reset_criterias) do
            if not l_4_0._reset_map[criteria] then
              l_4_0._reset_map[criteria] = {}
            end
            table.insert(l_4_0._reset_map[criteria], name)
          end
        end
        if challenge.session_stopped then
          table.insert(l_4_0._session_stopped_map, name)
        end
      end
    end
  end
  if not Global.challenges_manager or l_4_1 then
    Global.challenges_manager = {}
    Global.challenges_manager.active = {}
    Global.challenges_manager.completed = {}
    l_4_0._global = Global.challenges_manager
    l_4_0:check_active_challenges()
  end
  l_4_0._global = Global.challenges_manager
end

ChallengesManager.challenge = function(l_5_0, l_5_1)
  return l_5_0._challenges_map[l_5_1]
end

ChallengesManager.active_challenge = function(l_6_0, l_6_1)
  return l_6_0._global.active[l_6_1]
end

ChallengesManager.add_already_awarded_challenge = function(l_7_0, l_7_1)
  local challenge = l_7_0._challenges_map[l_7_1]
  if challenge and not l_7_0._global.active[l_7_1] and challenge.unlock_level <= managers.experience:current_level() and l_7_0:_check_depends_on(l_7_1) then
    local t = {}
    if challenge.counter_id then
      t.amount = 0
    end
    if challenge.flag_id then
      t.flag = false
    end
    t.already_awarded = true
    l_7_0._global.active[l_7_1] = t
    if challenge.counter_id then
      for _,sub_challenge in ipairs(managers.challenges:get_completed()) do
        if l_7_0._challenges_map[sub_challenge.id].increment_counter == challenge.counter_id then
          l_7_0:add_already_awarded_challenge(sub_challenge.id)
        end
      end
    end
  end
end

ChallengesManager.check_active_challenges = function(l_8_0)
  local added = false
  do
    local current_level = managers.experience:current_level()
    for name,challenge in pairs(l_8_0._challenges_map) do
      if not l_8_0._global.active[name] and not l_8_0._global.completed[name] and challenge.unlock_level <= current_level and l_8_0:_check_depends_on(name) then
        local t = {}
        if challenge.counter_id then
          t.amount = 0
        end
        if challenge.flag_id then
          t.flag = false
        end
        l_8_0._global.active[name] = t
        added = true
      end
    end
  end
  if not added or managers.hud then
     -- Warning: missing end command somewhere! Added here
  end
end

ChallengesManager._check_depends_on = function(l_9_0, l_9_1)
  if not l_9_0._challenges_map[l_9_1].depends_on then
    return true
  end
  if l_9_0._challenges_map[l_9_1].depends_on.challenges then
    for _,challenge in ipairs(l_9_0._challenges_map[l_9_1].depends_on.challenges) do
      if not l_9_0._global.completed[challenge] then
        return false
      end
    end
  end
  if l_9_0._challenges_map[l_9_1].depends_on.weapons then
    for _,weapon in ipairs(l_9_0._challenges_map[l_9_1].depends_on.weapons) do
      if not managers.player:has_weapon(weapon) then
        return false
      end
    end
  end
  if l_9_0._challenges_map[l_9_1].depends_on.equipment then
    for _,equipment in ipairs(l_9_0._challenges_map[l_9_1].depends_on.equipment) do
      if not managers.player:has_aquired_equipment(equipment) then
        return false
      end
    end
  end
  return true
end

ChallengesManager.add_by_name = function(l_10_0, l_10_1)
  if not l_10_0._challenges_map[l_10_1] then
    Application:error("No challenges named", l_10_1)
    return 
  end
  if l_10_0._global.active[l_10_1] then
    l_10_0._global.active[l_10_1].amount = l_10_0._global.active[l_10_1].amount + 1
    l_10_0:_check_completed(l_10_1)
  end
end

ChallengesManager.count_up = function(l_11_0, l_11_1)
  if not l_11_0._counter_map[l_11_1] then
    return 
  end
  local actives = clone(l_11_0._global.active)
  for _,name in ipairs(l_11_0._counter_map[l_11_1]) do
    if actives[name] and (not l_11_0._global.completed[name] or actives[name].already_awarded) then
      l_11_0._global.active[name].amount = l_11_0._global.active[name].amount + 1
      l_11_0:_check_completed(name)
    end
  end
end

ChallengesManager.reset_counter = function(l_12_0, l_12_1)
  if not l_12_0._counter_map[l_12_1] then
    return 
  end
  local actives = clone(l_12_0._global.active)
  for _,name in ipairs(l_12_0._counter_map[l_12_1]) do
    if actives[name] and (not l_12_0._global.completed[name] or actives[name].already_awarded) then
      l_12_0._global.active[name].amount = 0
    end
  end
end

ChallengesManager.set_flag = function(l_13_0, l_13_1)
  if not l_13_0._flag_map[l_13_1] then
    Application:error("No flag id named", l_13_1)
    return 
  end
  for _,name in ipairs(l_13_0._flag_map[l_13_1]) do
    if l_13_0._global.active[name] and (not l_13_0._global.completed[name] or l_13_0._global.active[name].already_awarded) then
      l_13_0._global.active[name].flag = true
      l_13_0:_check_completed(name)
    end
  end
end

ChallengesManager.session_stopped = function(l_14_0, ...)
  do
    local actives = clone(l_14_0._global.active)
    for _,name in ipairs(l_14_0._session_stopped_map) do
      if actives[name] and (not l_14_0._global.completed[name] or actives[name].already_awarded) then
        local function_name = l_14_0._challenges_map[name].session_stopped.callback
        if l_14_0[function_name](l_14_0, name, ...) then
          l_14_0:_completed_challenge(name)
        end
      end
    end
  end
   -- DECOMPILER ERROR: Confused about usage of registers for local variables.

end

ChallengesManager._check_completed = function(l_15_0, l_15_1)
  local counter_ok = not l_15_0._global.active[l_15_1].amount or l_15_0._challenges_map[l_15_1].count <= l_15_0._global.active[l_15_1].amount
  local flag_ok = (l_15_0._global.active[l_15_1].flag ~= nil and l_15_0._global.active[l_15_1].flag)
  if counter_ok and flag_ok then
    l_15_0:_completed_challenge(l_15_1)
  end
end

ChallengesManager._completed_challenge = function(l_16_0, l_16_1)
  local already_awarded = l_16_0._global.active[l_16_1].already_awarded
  l_16_0._global.completed[l_16_1] = true
  l_16_0._global.active[l_16_1] = nil
  if not already_awarded then
    l_16_0._global.last_completed = l_16_1
    if managers.hud then
      local title = managers.localization:text("present_challenge_completed_title")
      local text = l_16_0:get_title_text(l_16_1)
      managers.hud:present_mid_text({title = title, text = text, time = 4, icon = nil, event = "stinger_objectivecomplete", type = "challenge"})
    end
  end
  if l_16_0._challenges_map[l_16_1].increment_counter then
    l_16_0:count_up(l_16_0._challenges_map[l_16_1].increment_counter)
  end
  local achievement = l_16_0:get_awarded_achievment(l_16_1)
  if achievement then
    managers.achievment:award(achievement)
  end
  l_16_0:check_active_challenges()
end

ChallengesManager.reset = function(l_17_0, l_17_1)
  if not l_17_0._reset_map[l_17_1] then
    return 
  end
  for _,name in ipairs(l_17_0._reset_map[l_17_1]) do
    if l_17_0._global.active[name] then
      if l_17_0._global.active[name].amount then
        l_17_0._global.active[name].amount = 0
      end
      if l_17_0._global.active[name].flag ~= nil then
        l_17_0._global.active[name].flag = false
      end
    end
  end
end

ChallengesManager.get_near_completion = function(l_18_0)
  local t = {}
  for id,data in pairs(l_18_0._global.active) do
    if l_18_0._challenges_map[id] and not data.already_awarded then
      local progress, count, amount = nil, nil, nil
      if data.amount then
        progress = data.amount / l_18_0._challenges_map[id].count
        count = l_18_0._challenges_map[id].count
        amount = data.amount
      else
        progress = 0
        count = 1
        amount = 0
      end
      local name = l_18_0:get_title_text(id)
      local description = l_18_0:get_description_text(id)
      table.insert(t, {id = id, progress = progress, count = count, amount = amount, name = name, description = description})
    end
  end
  local sort_func = function(l_1_0, l_1_1)
    if l_1_0.id >= l_1_1.id then
      return l_1_0.progress ~= l_1_1.progress
    end
    return l_1_1.progress < l_1_0.progress
   end
  table.sort(t, sort_func)
  return t
end

ChallengesManager.is_completed = function(l_19_0, l_19_1)
  return l_19_0._global.completed[l_19_1]
end

ChallengesManager.get_completed = function(l_20_0)
  local t = {}
  for id,data in pairs(l_20_0._global.completed) do
    if l_20_0._challenges_map[id] then
      local name = l_20_0:get_title_text(id)
      local description = l_20_0:get_description_text(id)
      table.insert(t, {id = id, name = name, description = description})
    end
  end
  local sort_func = function(l_1_0, l_1_1)
    return l_1_0.id < l_1_1.id
   end
  table.sort(t, sort_func)
  return t
end

ChallengesManager.get_last_comleted_title_text = function(l_21_0)
  if not l_21_0._global.last_completed or not l_21_0._challenges_map[l_21_0._global.last_completed] then
    return ""
  end
  return l_21_0:get_title_text(l_21_0._global.last_completed)
end

ChallengesManager.get_last_comleted_description_text = function(l_22_0)
  if not l_22_0._global.last_completed or not l_22_0._challenges_map[l_22_0._global.last_completed] then
    return ""
  end
  return l_22_0:get_description_text(l_22_0._global.last_completed, true)
end

ChallengesManager.get_title_text = function(l_23_0, l_23_1)
  if l_23_0._challenges_map[l_23_1].title_id then
    return l_23_0:_get_localized_string(l_23_1, l_23_0._challenges_map[l_23_1].title_id)
  else
    return l_23_1
  end
end

ChallengesManager.get_description_text = function(l_24_0, l_24_1, l_24_2)
  if l_24_0._challenges_map[l_24_1].description_id then
    local description = l_24_0:_get_localized_string(l_24_1, l_24_0._challenges_map[l_24_1].description_id)
    local achievment = l_24_0:get_awarded_achievment(l_24_1)
    if achievment and not l_24_2 then
      local adata = managers.achievment:get_info(achievment)
      description = description .. managers.localization:text("debug_challenge_reward", {ACHIEVMENT = managers.localization:text(adata.name)})
    end
    return description
  else
    return l_24_1
  end
end

ChallengesManager.get_awarded_achievment = function(l_25_0, l_25_1)
  local achievment = l_25_0._challenges_map[l_25_1].awards_achievment
  if managers.achievment:exists(achievment) then
    return achievment
  end
  return nil
end

ChallengesManager._get_localized_string = function(l_26_0, l_26_1, l_26_2)
  local text = managers.localization:text(l_26_2)
  if l_26_0._challenges_map[l_26_1].count then
    local pattern = "##" .. l_26_0._challenges_map[l_26_1].counter_id .. "##"
    text = string.gsub(text, pattern, l_26_0._challenges_map[l_26_1].count)
  end
  return text
end

ChallengesManager.check_text = function(l_27_0)
  for name,_ in pairs(l_27_0._challenges_map) do
    print(l_27_0:get_title_text(name))
    print(l_27_0:get_description_text(name) .. "\n")
  end
end

ChallengesManager.amount_of_challenges = function(l_28_0)
  local i = 0
  for _,_ in pairs(l_28_0._challenges_map) do
    i = i + 1
  end
  return i
end

ChallengesManager.amount_of_completed_challenges = function(l_29_0)
  local i = 0
  for id,_ in pairs(l_29_0._global.completed) do
    if l_29_0._challenges_map[id] then
      i = i + 1
    end
  end
  return i
end

ChallengesManager._check_level_completed = function(l_30_0, l_30_1)
  if not l_30_1.success then
    return false
  end
  if not l_30_1.from_beginning then
    return false
  end
  return true
end

ChallengesManager._correct_level = function(l_31_0, l_31_1)
  if not Global.level_data or not Global.level_data.level_id then
    return false
  end
  return Global.level_data.level_id == l_31_1
end

ChallengesManager._correct_difficulty = function(l_32_0, l_32_1)
  local curr_diff = Global.game_settings.difficulty
  if type(l_32_1) == "table" then
    for _,diff in ipairs(l_32_1) do
      if diff == curr_diff then
        return true
      end
    end
    return false
  end
  if l_32_1 ~= curr_diff then
    return false
  end
  return true
end

ChallengesManager.never_downed = function(l_33_0, l_33_1, l_33_2)
  if not l_33_0:_check_level_completed(l_33_2) then
    return 
  end
  if l_33_2.last_session.downed.bleed_out > 0 then
    return 
  end
  return true
end

ChallengesManager.aquired_money = function(l_34_0)
  local ach_name = nil
  for name,challenge in pairs(l_34_0._challenges_map) do
    if challenge.id == "aquired_money" and l_34_0._global.active[name] then
      ach_name = name
  else
    end
  end
  if not ach_name then
    return 
  end
  if managers.experience:total() < l_34_0._challenges_map[ach_name].amount then
    return 
  end
  l_34_0:_completed_challenge(ach_name)
end

ChallengesManager.no_civilians_killed = function(l_35_0, l_35_1, l_35_2)
  if not l_35_0:_correct_level(l_35_0._challenges_map[l_35_1].level_id) then
    return 
  end
  if not l_35_0:_correct_difficulty(l_35_0._challenges_map[l_35_1].difficulty) then
    return 
  end
  if not l_35_0:_check_level_completed(l_35_2) then
    return 
  end
  if managers.statistics:session_total_civilian_kills() > 0 then
    return 
  end
  return true
end

ChallengesManager.never_died = function(l_36_0, l_36_1, l_36_2)
  if not l_36_0:_correct_level(l_36_0._challenges_map[l_36_1].level_id) then
    return 
  end
  if not l_36_0:_correct_difficulty(l_36_0._challenges_map[l_36_1].difficulty) then
    return 
  end
  if not l_36_0:_check_level_completed(l_36_2) then
    return 
  end
  if l_36_2.last_session.downed.death > 0 then
    return 
  end
  return true
end

ChallengesManager.never_bleedout = function(l_37_0, l_37_1, l_37_2)
  if not l_37_0:_correct_level(l_37_0._challenges_map[l_37_1].level_id) then
    return 
  end
  if not l_37_0:_correct_difficulty(l_37_0._challenges_map[l_37_1].difficulty) then
    return 
  end
  if not l_37_0:_check_level_completed(l_37_2) then
    return 
  end
  if l_37_2.last_session.downed.bleed_out > 0 then
    return 
  end
  return true
end

ChallengesManager.overkill_success = function(l_38_0, l_38_1, l_38_2)
  if not l_38_0:_correct_level(l_38_0._challenges_map[l_38_1].level_id) then
    return 
  end
  if not l_38_0:_check_level_completed(l_38_2) then
    return 
  end
  if not l_38_0:_correct_difficulty(l_38_0._challenges_map[l_38_1].difficulty) then
    return 
  end
  return true
end

ChallengesManager.overkill_no_trade = function(l_39_0, l_39_1, l_39_2)
  if not l_39_0:_correct_level(l_39_0._challenges_map[l_39_1].level_id) then
    return 
  end
  if not l_39_0:_check_level_completed(l_39_2) then
    return 
  end
  if not l_39_0:_correct_difficulty(l_39_0._challenges_map[l_39_1].difficulty) then
    return 
  end
  if managers.trade._num_trades > 0 then
    return 
  end
  return true
end

ChallengesManager.check_still_active_available = function(l_40_0)
  local actives = clone(l_40_0._global.active)
  for name,data in pairs(actives) do
    if not l_40_0._challenges_map[name] then
      l_40_0._global.active[name] = nil
    end
  end
end

ChallengesManager.save = function(l_41_0, l_41_1)
  local active = {}
  for i,k in pairs(l_41_0._global.active) do
    if not k.already_awarded then
      active[i] = k
    end
  end
  local state = {active = active, completed = l_41_0._global.completed, last_completed = l_41_0._global.last_completed}
  l_41_1.ChallengesManager = state
end

ChallengesManager.load = function(l_42_0, l_42_1)
  local state = l_42_1.ChallengesManager
  if state then
    l_42_0._global.active = state.active
    l_42_0._global.completed = state.completed
    l_42_0._global.last_completed = state.last_completed
    l_42_0:check_active_challenges()
    l_42_0:check_still_active_available()
  end
  managers.network.account:challenges_loaded()
end

ChallengesManager.debug_set_amount = function(l_43_0, l_43_1, l_43_2)
  if not l_43_0._global.active[l_43_1] then
    return 
  end
  l_43_0._global.active[l_43_1].amount = l_43_2
end


