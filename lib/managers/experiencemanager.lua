-- Decompiled using luadec 2.0.1 by sztupy (http://winmo.sztupy.hu)
-- Command line was: F:\SteamLibrary\SteamApps\common\PAYDAY 2\lua\lib\managers\experiencemanager.luac 

if not ExperienceManager then
  ExperienceManager = class()
end
ExperienceManager.LEVEL_CAP = Application:digest_value(100, true)
ExperienceManager.init = function(l_1_0)
  l_1_0:_setup()
end

ExperienceManager._setup = function(l_2_0)
  l_2_0._total_levels = #tweak_data.experience_manager.levels
  if not Global.experience_manager then
    Global.experience_manager = {}
    Global.experience_manager.total = Application:digest_value(0, true)
    Global.experience_manager.level = Application:digest_value(0, true)
  end
  l_2_0._global = Global.experience_manager
  if not l_2_0._global.next_level_data then
    l_2_0:_set_next_level_data(1)
  end
  l_2_0._cash_tousand_separator = managers.localization:text("cash_tousand_separator")
  l_2_0._cash_sign = managers.localization:text("cash_sign")
  l_2_0:present()
end

ExperienceManager._set_next_level_data = function(l_3_0, l_3_1)
  if l_3_0._total_levels < l_3_1 then
    Application:error("Reached the level cap")
    if l_3_0._experience_progress_data then
      table.insert(l_3_0._experience_progress_data, {level = l_3_0._total_levels, current = tweak_data:get_value("experience_manager", "levels", l_3_0._total_levels, "points"), total = tweak_data:get_value("experience_manager", "levels", l_3_0._total_levels, "points")})
    end
    return 
  end
  local level_data = tweak_data.experience_manager.levels[l_3_1]
  l_3_0._global.next_level_data = {}
  l_3_0:_set_next_level_data_points(level_data.points)
  l_3_0:_set_next_level_data_current_points(0)
  if l_3_0._experience_progress_data then
    table.insert(l_3_0._experience_progress_data, {level = l_3_1, current = 0, total = tweak_data:get_value("experience_manager", "levels", l_3_1, "points")})
  end
end

ExperienceManager.next_level_data_points = function(l_4_0)
  return l_4_0._global.next_level_data and Application:digest_value(l_4_0._global.next_level_data.points, false) or 0
end

ExperienceManager._set_next_level_data_points = function(l_5_0, l_5_1)
  l_5_0._global.next_level_data.points = l_5_1
end

ExperienceManager.next_level_data_current_points = function(l_6_0)
  return l_6_0._global.next_level_data and Application:digest_value(l_6_0._global.next_level_data.current_points, false) or 0
end

ExperienceManager._set_next_level_data_current_points = function(l_7_0, l_7_1)
  l_7_0._global.next_level_data.current_points = Application:digest_value(l_7_1, true)
end

ExperienceManager.next_level_data = function(l_8_0)
  return {points = l_8_0:next_level_data_points(), current_points = l_8_0:next_level_data_current_points()}
end

ExperienceManager.perform_action_interact = function(l_9_0, l_9_1)
end

ExperienceManager.perform_action = function(l_10_0, l_10_1)
  if managers.platform:presence() ~= "Playing" and managers.platform:presence() ~= "Mission_end" then
    return 
  end
  if not tweak_data.experience_manager.actions[l_10_1] then
    Application:error("Unknown action \"" .. tostring(l_10_1) .. " in experience manager.")
    return 
  end
  local size = tweak_data.experience_manager.actions[l_10_1]
  local points = tweak_data.experience_manager.values[size]
  if not points then
    Application:error("Unknown size \"" .. tostring(size) .. " in experience manager.")
    return 
  end
  managers.statistics:recieved_experience({action = l_10_1, size = size})
  l_10_0:add_points(points, true)
end

ExperienceManager.debug_add_points = function(l_11_0, l_11_1, l_11_2)
  l_11_0:add_points(l_11_1, l_11_2, true)
end

ExperienceManager.give_experience = function(l_12_0, l_12_1)
  l_12_0._experience_progress_data = {}
  l_12_0._experience_progress_data.gained = l_12_1
  l_12_0._experience_progress_data.start_t = {}
  l_12_0._experience_progress_data.start_t.level = l_12_0:current_level()
  l_12_0._experience_progress_data.start_t.current = l_12_0._global.next_level_data and l_12_0:next_level_data_current_points() or 0
  l_12_0._experience_progress_data.start_t.total = l_12_0._global.next_level_data and l_12_0:next_level_data_points() or 1
  l_12_0._experience_progress_data.start_t.xp = l_12_0:xp_gained()
  table.insert(l_12_0._experience_progress_data, {level = l_12_0:current_level() + 1, current = l_12_0:next_level_data_current_points(), total = l_12_0:next_level_data_points()})
  local level_cap_xp_leftover = l_12_0:add_points(l_12_1, true, false)
  if level_cap_xp_leftover then
    l_12_0._experience_progress_data.gained = l_12_0._experience_progress_data.gained - level_cap_xp_leftover
  end
  l_12_0._experience_progress_data.end_t = {}
  l_12_0._experience_progress_data.end_t.level = l_12_0:current_level()
  l_12_0._experience_progress_data.end_t.current = l_12_0._global.next_level_data and l_12_0:next_level_data_current_points() or 0
  l_12_0._experience_progress_data.end_t.total = l_12_0._global.next_level_data and l_12_0:next_level_data_points() or 1
  l_12_0._experience_progress_data.end_t.xp = l_12_0:xp_gained()
  table.remove(l_12_0._experience_progress_data, #l_12_0._experience_progress_data)
  local return_data = deep_clone(l_12_0._experience_progress_data)
  l_12_0._experience_progress_data = nil
  return return_data
end

ExperienceManager.add_points = function(l_13_0, l_13_1, l_13_2, l_13_3)
  if not l_13_3 and managers.platform:presence() ~= "Playing" and managers.platform:presence() ~= "Mission_end" then
    return 
  end
  if not managers.dlc:has_full_game() and l_13_0:current_level() >= 10 then
    l_13_0:_set_total(l_13_0:total() + l_13_1)
    l_13_0:_set_next_level_data_current_points(0)
    l_13_0:present()
    managers.challenges:aquired_money()
    managers.statistics:aquired_money(l_13_1)
    return l_13_1
  end
  if l_13_0:level_cap() <= l_13_0:current_level() then
    l_13_0:_set_total(l_13_0:total() + l_13_1)
    managers.challenges:aquired_money()
    managers.statistics:aquired_money(l_13_1)
    return l_13_1
  end
  if l_13_2 then
    l_13_0:_present_xp(l_13_1)
  end
  local points_left = l_13_0:next_level_data_points() - l_13_0:next_level_data_current_points()
  if l_13_1 < points_left then
    l_13_0:_set_total(l_13_0:total() + l_13_1)
    l_13_0:_set_xp_gained(l_13_0:total())
    l_13_0:_set_next_level_data_current_points(l_13_0:next_level_data_current_points() + l_13_1)
    l_13_0:present()
    managers.challenges:aquired_money()
    managers.statistics:aquired_money(l_13_1)
    return 
  end
  l_13_0:_set_total(l_13_0:total() + points_left)
  l_13_0:_set_xp_gained(l_13_0:total())
  l_13_0:_set_next_level_data_current_points(l_13_0:next_level_data_current_points() + points_left)
  l_13_0:present()
  l_13_0:_level_up()
  managers.statistics:aquired_money(points_left)
  return l_13_0:add_points(l_13_1 - points_left, l_13_2, l_13_3)
end

ExperienceManager._level_up = function(l_14_0)
  l_14_0:_set_current_level(l_14_0:current_level() + 1)
  l_14_0:_set_next_level_data(l_14_0:current_level() + 1)
  local player = managers.player:player_unit()
  if alive(player) and tweak_data:difficulty_to_index(Global.game_settings.difficulty) < 4 then
    player:base():replenish()
  end
  managers.challenges:check_active_challenges()
  l_14_0:_check_achievements()
  if managers.network:session() then
    managers.network:session():send_to_peers_synched("sync_level_up", managers.network:session():local_peer():id(), l_14_0:current_level())
  end
  if l_14_0:current_level() >= 145 then
    managers.challenges:set_flag("president")
  end
  managers.upgrades:level_up()
  managers.skilltree:level_up()
end

ExperienceManager._check_achievements = function(l_15_0)
  if tweak_data.achievement.you_gotta_start_somewhere <= l_15_0:current_level() then
    managers.achievment:award("you_gotta_start_somewhere")
  end
  if tweak_data.achievement.guilty_of_crime <= l_15_0:current_level() then
    managers.achievment:award("guilty_of_crime")
  end
  if tweak_data.achievement.gone_in_30_seconds <= l_15_0:current_level() then
    managers.achievment:award("gone_in_30_seconds")
  end
  if tweak_data.achievement.armed_and_dangerous <= l_15_0:current_level() then
    managers.achievment:award("armed_and_dangerous")
  end
  if tweak_data.achievement.big_shot <= l_15_0:current_level() then
    managers.achievment:award("big_shot")
  end
  if tweak_data.achievement.most_wanted <= l_15_0:current_level() then
    managers.achievment:award("most_wanted")
  end
end

ExperienceManager.present = function(l_16_0)
end

ExperienceManager._present_xp = function(l_17_0, l_17_1)
  local event = "money_collect_small"
  if l_17_1 > 999 then
    event = "money_collect_large"
  elseif l_17_1 > 101 then
    event = "money_collect_medium"
  end
end

ExperienceManager.current_level = function(l_18_0)
  return l_18_0._global.level and Application:digest_value(l_18_0._global.level, false) or 0
end

ExperienceManager._set_current_level = function(l_19_0, l_19_1)
  l_19_0._global.level = Application:digest_value(l_19_1, true)
end

ExperienceManager.level_to_stars = function(l_20_0)
  local player_stars = math.max(math.ceil(l_20_0:current_level() / 10), 1)
  return player_stars
end

ExperienceManager.xp_gained = function(l_21_0)
  return l_21_0._global.xp_gained and Application:digest_value(l_21_0._global.xp_gained, false) or 0
end

ExperienceManager._set_xp_gained = function(l_22_0, l_22_1)
  l_22_0._global.xp_gained = Application:digest_value(l_22_1, true)
end

ExperienceManager.total = function(l_23_0)
  return Application:digest_value(l_23_0._global.total, false)
end

ExperienceManager._set_total = function(l_24_0, l_24_1)
  l_24_0._global.total = Application:digest_value(l_24_1, true)
end

ExperienceManager.cash_string = function(l_25_0, l_25_1)
  local sign = ""
  if l_25_1 < 0 then
    sign = "-"
  end
  local total = tostring(math.round(math.abs(l_25_1)))
  local reverse = string.reverse(total)
  local s = ""
  for i = 1, string.len(reverse) do
    s = s .. string.sub(reverse, i, i) .. (math.mod(i, 3) == 0 and i ~= string.len(reverse) and l_25_0._cash_tousand_separator or "")
  end
  return sign .. l_25_0._cash_sign .. string.reverse(s)
end

ExperienceManager.total_cash_string = function(l_26_0)
  return l_26_0:cash_string(l_26_0:total()) .. (l_26_0:total() > 0 and l_26_0._cash_tousand_separator .. "000" or "")
end

ExperienceManager.actions = function(l_27_0)
  local t = {}
  for action,_ in pairs(tweak_data.experience_manager.actions) do
    table.insert(t, action)
  end
  table.sort(t)
  return t
end

ExperienceManager.get_job_xp_by_stars = function(l_28_0, l_28_1)
  local amount = tweak_data:get_value("experience_manager", "job_completion", l_28_1)
  return amount
end

ExperienceManager.get_stage_xp_by_stars = function(l_29_0, l_29_1)
  local amount = tweak_data:get_value("experience_manager", "stage_completion", l_29_1)
  return amount
end

ExperienceManager.get_contract_difficulty_multiplier = function(l_30_0, l_30_1)
  local multiplier = tweak_data:get_value("experience_manager", "difficulty_multiplier", l_30_1)
  return multiplier or 0
end

ExperienceManager.get_current_stage_xp_by_stars = function(l_31_0, l_31_1, l_31_2)
  local amount = l_31_0:get_stage_xp_by_stars(l_31_1) + l_31_0:get_stage_xp_by_stars(l_31_1) * l_31_0:get_contract_difficulty_multiplier(l_31_2)
  return amount
end

ExperienceManager.get_current_job_xp_by_stars = function(l_32_0, l_32_1, l_32_2)
  local amount = l_32_0:get_job_xp_by_stars(l_32_1) + l_32_0:get_job_xp_by_stars(l_32_1) * l_32_0:get_contract_difficulty_multiplier(l_32_2)
  return amount
end

ExperienceManager.get_current_job_day_multiplier = function(l_33_0)
  if not managers.job:has_active_job() then
    return 1
  end
  local current_job_day = managers.job:current_stage()
  local is_current_job_professional = managers.job:is_current_job_professional()
  if not is_current_job_professional or not tweak_data:get_value("experience_manager", "pro_day_multiplier", current_job_day) then
    return tweak_data:get_value("experience_manager", "day_multiplier", current_job_day)
  end
end

ExperienceManager.get_on_completion_xp = function(l_34_0)
  local has_active_job = managers.job:has_active_job()
  local job_and_difficulty_stars = has_active_job and managers.job:current_job_and_difficulty_stars() or 1
  local job_stars = has_active_job and managers.job:current_job_stars() or 1
  local difficulty_stars = job_and_difficulty_stars - job_stars
  local on_last_stage = managers.job:on_last_stage()
  local amount = l_34_0:get_current_stage_xp_by_stars(job_stars, difficulty_stars)
  if on_last_stage then
    amount = amount + l_34_0:get_current_job_xp_by_stars(job_stars, difficulty_stars)
  end
  return amount
end

ExperienceManager.get_xp_dissected = function(l_35_0, l_35_1, l_35_2)
  local has_active_job = managers.job:has_active_job()
  local job_and_difficulty_stars = has_active_job and managers.job:current_job_and_difficulty_stars() or 1
  local job_stars = has_active_job and managers.job:current_job_stars() or 1
  local difficulty_stars = job_and_difficulty_stars - job_stars
  local player_stars = managers.experience:level_to_stars()
  local days_multiplier = managers.experience:get_current_job_day_multiplier()
  local is_level_limited = player_stars < job_and_difficulty_stars
  local total_stars = math.min(job_and_difficulty_stars, player_stars)
  local total_difficulty_stars = math.max(0, total_stars - job_stars)
  local xp_multiplier = managers.experience:get_contract_difficulty_multiplier(total_difficulty_stars)
  total_stars = math.min(job_stars, total_stars)
  local contract_xp = 0
  local total_xp = 0
  local stage_xp_dissect = 0
  local job_xp_dissect = 0
  local level_limit_dissect = 0
  local risk_dissect = 0
  local failed_level_dissect = 0
  local alive_crew_dissect = 0
  local skill_dissect = 0
  local base_xp = 0
  local days_dissect = 0
  if l_35_1 and has_active_job and managers.job:on_last_stage() then
    job_xp_dissect = managers.experience:get_job_xp_by_stars(job_stars)
    contract_xp = contract_xp + managers.experience:get_job_xp_by_stars(total_stars)
    level_limit_dissect = level_limit_dissect + job_xp_dissect
  end
  stage_xp_dissect = managers.experience:get_stage_xp_by_stars(job_stars)
  contract_xp = contract_xp + managers.experience:get_stage_xp_by_stars(total_stars)
  level_limit_dissect = level_limit_dissect + stage_xp_dissect
  base_xp = contract_xp
  contract_xp = contract_xp + math.round((contract_xp) * xp_multiplier)
  risk_dissect = math.round((level_limit_dissect) * managers.experience:get_contract_difficulty_multiplier(difficulty_stars))
  level_limit_dissect = math.round(level_limit_dissect + risk_dissect)
  if is_level_limited then
    if managers.experience:current_level() <= tweak_data:get_value("experience_manager", "level_limit", "low_cap_level") then
      contract_xp = contract_xp + (contract_xp) * tweak_data:get_value("experience_manager", "level_limit", "low_cap_multiplier")
      contract_xp = math.round(math.min(contract_xp, level_limit_dissect))
    else
      local diff_in_experience = level_limit_dissect - contract_xp
      local diff_in_stars = job_and_difficulty_stars - player_stars
      local tweak_multiplier = tweak_data:get_value("experience_manager", "level_limit", "pc_difference_multipliers", diff_in_stars) or 0
      contract_xp = contract_xp + diff_in_experience * tweak_multiplier
      contract_xp = math.round(math.min(contract_xp, level_limit_dissect))
    end
  end
  level_limit_dissect = contract_xp - level_limit_dissect
  if not l_35_1 then
    failed_level_dissect = contract_xp
    contract_xp = math.round(contract_xp * (tweak_data:get_value("experience_manager", "stage_failed_multiplier") or 1))
    failed_level_dissect = contract_xp - failed_level_dissect
  end
  total_xp = contract_xp
  do
    if not l_35_2 or not tweak_data:get_value("experience_manager", "alive_humans_multiplier", l_35_2) then
      local num_players_bonus = not l_35_1 or 1
    end
    alive_crew_dissect = math.round(contract_xp * num_players_bonus - contract_xp)
    total_xp = total_xp + alive_crew_dissect
  end
  local multiplier = managers.player:upgrade_value("player", "xp_multiplier", 1)
  multiplier = multiplier * managers.player:upgrade_value("player", "passive_xp_multiplier", 1)
  multiplier = multiplier * managers.player:team_upgrade_value("xp", "multiplier", 1)
  skill_dissect = math.round(contract_xp * (multiplier) - contract_xp)
  total_xp = total_xp + skill_dissect
  days_dissect = math.round(contract_xp * days_multiplier - contract_xp)
  total_xp = total_xp + days_dissect
  {bonus_risk = math.round(risk_dissect), bonus_num_players = math.round(alive_crew_dissect), bonus_failed = math.round(failed_level_dissect), bonus_low_level = math.round(level_limit_dissect), bonus_skill = math.round(skill_dissect), bonus_days = math.round(days_dissect)}.stage_xp = math.round(stage_xp_dissect)
   -- DECOMPILER ERROR: Confused about usage of registers!

  {bonus_risk = math.round(risk_dissect), bonus_num_players = math.round(alive_crew_dissect), bonus_failed = math.round(failed_level_dissect), bonus_low_level = math.round(level_limit_dissect), bonus_skill = math.round(skill_dissect), bonus_days = math.round(days_dissect)}.job_xp = math.round(job_xp_dissect)
   -- DECOMPILER ERROR: Confused about usage of registers!

  {bonus_risk = math.round(risk_dissect), bonus_num_players = math.round(alive_crew_dissect), bonus_failed = math.round(failed_level_dissect), bonus_low_level = math.round(level_limit_dissect), bonus_skill = math.round(skill_dissect), bonus_days = math.round(days_dissect)}.base = math.round(base_xp)
   -- DECOMPILER ERROR: Confused about usage of registers!

  {bonus_risk = math.round(risk_dissect), bonus_num_players = math.round(alive_crew_dissect), bonus_failed = math.round(failed_level_dissect), bonus_low_level = math.round(level_limit_dissect), bonus_skill = math.round(skill_dissect), bonus_days = math.round(days_dissect)}.total = math.round(total_xp)
   -- DECOMPILER ERROR: Confused about usage of registers!

  if l_35_1 and has_active_job then
    {bonus_risk = math.round(risk_dissect), bonus_num_players = math.round(alive_crew_dissect), bonus_failed = math.round(failed_level_dissect), bonus_low_level = math.round(level_limit_dissect), bonus_skill = math.round(skill_dissect), bonus_days = math.round(days_dissect)}.last_stage = managers.job:on_last_stage()
    do
       -- DECOMPILER ERROR: Confused at declaration of local variable

    end
     -- DECOMPILER ERROR: Confused about usage of registers!

     -- DECOMPILER ERROR: Confused about usage of registers!

     -- DECOMPILER ERROR: Confused about usage of registers!

     -- DECOMPILER ERROR: Confused about usage of registers!

     -- DECOMPILER ERROR: Confused about usage of registers!

     -- DECOMPILER ERROR: Confused about usage of registers!

     -- DECOMPILER ERROR: Confused about usage of registers!

     -- DECOMPILER ERROR: Confused about usage of registers!

     -- DECOMPILER ERROR: Confused about usage of registers!

    do
       -- DECOMPILER ERROR: Confused at declaration of local variable

       -- DECOMPILER ERROR: Confused about usage of registers!

      if Application:production_build() then
        {bonus_risk = math.round(risk_dissect), bonus_num_players = math.round(alive_crew_dissect), bonus_failed = math.round(failed_level_dissect), bonus_low_level = math.round(level_limit_dissect), bonus_skill = math.round(skill_dissect), bonus_days = math.round(days_dissect)}.rounding_error = ({bonus_risk = math.round(risk_dissect), bonus_num_players = math.round(alive_crew_dissect), bonus_failed = math.round(failed_level_dissect), bonus_low_level = math.round(level_limit_dissect), bonus_skill = math.round(skill_dissect), bonus_days = math.round(days_dissect)}).total - (({bonus_risk = math.round(risk_dissect), bonus_num_players = math.round(alive_crew_dissect), bonus_failed = math.round(failed_level_dissect), bonus_low_level = math.round(level_limit_dissect), bonus_skill = math.round(skill_dissect), bonus_days = math.round(days_dissect)}).stage_xp + ({bonus_risk = math.round(risk_dissect), bonus_num_players = math.round(alive_crew_dissect), bonus_failed = math.round(failed_level_dissect), bonus_low_level = math.round(level_limit_dissect), bonus_skill = math.round(skill_dissect), bonus_days = math.round(days_dissect)}).job_xp + ({bonus_risk = math.round(risk_dissect), bonus_num_players = math.round(alive_crew_dissect), bonus_failed = math.round(failed_level_dissect), bonus_low_level = math.round(level_limit_dissect), bonus_skill = math.round(skill_dissect), bonus_days = math.round(days_dissect)}).bonus_risk + ({bonus_risk = math.round(risk_dissect), bonus_num_players = math.round(alive_crew_dissect), bonus_failed = math.round(failed_level_dissect), bonus_low_level = math.round(level_limit_dissect), bonus_skill = math.round(skill_dissect), bonus_days = math.round(days_dissect)}).bonus_num_players + ({bonus_risk = math.round(risk_dissect), bonus_num_players = math.round(alive_crew_dissect), bonus_failed = math.round(failed_level_dissect), bonus_low_level = math.round(level_limit_dissect), bonus_skill = math.round(skill_dissect), bonus_days = math.round(days_dissect)}).bonus_failed + ({bonus_risk = math.round(risk_dissect), bonus_num_players = math.round(alive_crew_dissect), bonus_failed = math.round(failed_level_dissect), bonus_low_level = math.round(level_limit_dissect), bonus_skill = math.round(skill_dissect), bonus_days = math.round(days_dissect)}).bonus_low_level + ({bonus_risk = math.round(risk_dissect), bonus_num_players = math.round(alive_crew_dissect), bonus_failed = math.round(failed_level_dissect), bonus_low_level = math.round(level_limit_dissect), bonus_skill = math.round(skill_dissect), bonus_days = math.round(days_dissect)}).bonus_skill + ({bonus_risk = math.round(risk_dissect), bonus_num_players = math.round(alive_crew_dissect), bonus_failed = math.round(failed_level_dissect), bonus_low_level = math.round(level_limit_dissect), bonus_skill = math.round(skill_dissect), bonus_days = math.round(days_dissect)}).bonus_days)
    end
     -- DECOMPILER ERROR: Confused about usage of registers!

    else
      {bonus_risk = math.round(risk_dissect), bonus_num_players = math.round(alive_crew_dissect), bonus_failed = math.round(failed_level_dissect), bonus_low_level = math.round(level_limit_dissect), bonus_skill = math.round(skill_dissect), bonus_days = math.round(days_dissect)}.rounding_error = 0
    end
     -- DECOMPILER ERROR: Confused about usage of registers!

    return math.round(total_xp), {bonus_risk = math.round(risk_dissect), bonus_num_players = math.round(alive_crew_dissect), bonus_failed = math.round(failed_level_dissect), bonus_low_level = math.round(level_limit_dissect), bonus_skill = math.round(skill_dissect), bonus_days = math.round(days_dissect)}
  end
   -- DECOMPILER ERROR: Confused about usage of registers for local variables.

end

ExperienceManager.level_cap = function(l_36_0)
  return Application:digest_value(l_36_0.LEVEL_CAP, false)
end

ExperienceManager.reached_level_cap = function(l_37_0)
  return l_37_0:level_cap() <= l_37_0:current_level()
end

ExperienceManager.save = function(l_38_0, l_38_1)
  local state = {total = l_38_0._global.total, xp_gained = l_38_0._global.xp_gained, next_level_data = l_38_0._global.next_level_data, level = l_38_0._global.level}
  l_38_1.ExperienceManager = state
end

ExperienceManager.load = function(l_39_0, l_39_1)
  local state = l_39_1.ExperienceManager
  if state then
    l_39_0._global.total = state.total
    if not state.xp_gained then
      l_39_0._global.xp_gained = state.total
    end
    l_39_0._global.next_level_data = state.next_level_data
    if not state.level then
      l_39_0._global.level = Application:digest_value(0, true)
    end
    l_39_0:_set_current_level(math.min(l_39_0:current_level(), l_39_0:level_cap()))
    for level = 1, l_39_0:current_level() do
      managers.upgrades:aquire_from_level_tree(level, true)
    end
    if not l_39_0._global.next_level_data or not tweak_data.experience_manager.levels[l_39_0:current_level() + 1] or l_39_0:next_level_data_points() ~= tweak_data:get_value("experience_manager", "levels", l_39_0:current_level() + 1, "points") then
      l_39_0:_set_next_level_data(l_39_0:current_level() + 1)
    end
  end
  managers.network.account:experience_loaded()
end

ExperienceManager.reset = function(l_40_0)
  managers.upgrades:reset()
  managers.player:reset()
  Global.experience_manager = nil
  l_40_0:_setup()
end

ExperienceManager.chk_ask_use_backup = function(l_41_0, l_41_1, l_41_2)
  local savegame_exp_total, backup_savegame_exp_total = nil, nil
  local state = l_41_1.ExperienceManager
  if state then
    savegame_exp_total = state.total
  end
  state = l_41_2.ExperienceManager
  if state then
    backup_savegame_exp_total = state.total
  end
  if savegame_exp_total and backup_savegame_exp_total and Application:digest_value(savegame_exp_total, false) < Application:digest_value(backup_savegame_exp_total, false) then
    return true
  end
end


