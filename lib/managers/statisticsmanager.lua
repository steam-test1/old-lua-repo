-- Decompiled using luadec 2.0.1 by sztupy (http://winmo.sztupy.hu)
-- Command line was: F:\SteamLibrary\SteamApps\common\PAYDAY 2\lua\lib\managers\statisticsmanager.luac 

if not StatisticsManager then
  StatisticsManager = class()
end
StatisticsManager.init = function(l_1_0)
  l_1_0:_setup()
  l_1_0:_reset_session()
end

StatisticsManager._setup = function(l_2_0, l_2_1)
  l_2_0._defaults = {}
   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

  l_2_0._defaults.killed, {other = {count = 0, head_shots = 0, melee = 0, explosion = 0, tied = 0}, civilian = {count = 0, head_shots = 0, melee = 0, explosion = 0, tied = 0}, civilian_female = {count = 0, head_shots = 0, melee = 0, explosion = 0, tied = 0}, security = {count = 0, head_shots = 0, melee = 0, explosion = 0, tied = 0}}.patrol, {other = {count = 0, head_shots = 0, melee = 0, explosion = 0, tied = 0}, civilian = {count = 0, head_shots = 0, melee = 0, explosion = 0, tied = 0}, civilian_female = {count = 0, head_shots = 0, melee = 0, explosion = 0, tied = 0}, security = {count = 0, head_shots = 0, melee = 0, explosion = 0, tied = 0}}.murky, {other = {count = 0, head_shots = 0, melee = 0, explosion = 0, tied = 0}, civilian = {count = 0, head_shots = 0, melee = 0, explosion = 0, tied = 0}, civilian_female = {count = 0, head_shots = 0, melee = 0, explosion = 0, tied = 0}, security = {count = 0, head_shots = 0, melee = 0, explosion = 0, tied = 0}}.sniper, {other = {count = 0, head_shots = 0, melee = 0, explosion = 0, tied = 0}, civilian = {count = 0, head_shots = 0, melee = 0, explosion = 0, tied = 0}, civilian_female = {count = 0, head_shots = 0, melee = 0, explosion = 0, tied = 0}, security = {count = 0, head_shots = 0, melee = 0, explosion = 0, tied = 0}}.fbi, {other = {count = 0, head_shots = 0, melee = 0, explosion = 0, tied = 0}, civilian = {count = 0, head_shots = 0, melee = 0, explosion = 0, tied = 0}, civilian_female = {count = 0, head_shots = 0, melee = 0, explosion = 0, tied = 0}, security = {count = 0, head_shots = 0, melee = 0, explosion = 0, tied = 0}}.gangster, {other = {count = 0, head_shots = 0, melee = 0, explosion = 0, tied = 0}, civilian = {count = 0, head_shots = 0, melee = 0, explosion = 0, tied = 0}, civilian_female = {count = 0, head_shots = 0, melee = 0, explosion = 0, tied = 0}, security = {count = 0, head_shots = 0, melee = 0, explosion = 0, tied = 0}}.taser, {other = {count = 0, head_shots = 0, melee = 0, explosion = 0, tied = 0}, civilian = {count = 0, head_shots = 0, melee = 0, explosion = 0, tied = 0}, civilian_female = {count = 0, head_shots = 0, melee = 0, explosion = 0, tied = 0}, security = {count = 0, head_shots = 0, melee = 0, explosion = 0, tied = 0}}.tank, {other = {count = 0, head_shots = 0, melee = 0, explosion = 0, tied = 0}, civilian = {count = 0, head_shots = 0, melee = 0, explosion = 0, tied = 0}, civilian_female = {count = 0, head_shots = 0, melee = 0, explosion = 0, tied = 0}, security = {count = 0, head_shots = 0, melee = 0, explosion = 0, tied = 0}}.spooc, {other = {count = 0, head_shots = 0, melee = 0, explosion = 0, tied = 0}, civilian = {count = 0, head_shots = 0, melee = 0, explosion = 0, tied = 0}, civilian_female = {count = 0, head_shots = 0, melee = 0, explosion = 0, tied = 0}, security = {count = 0, head_shots = 0, melee = 0, explosion = 0, tied = 0}}.shield, {other = {count = 0, head_shots = 0, melee = 0, explosion = 0, tied = 0}, civilian = {count = 0, head_shots = 0, melee = 0, explosion = 0, tied = 0}, civilian_female = {count = 0, head_shots = 0, melee = 0, explosion = 0, tied = 0}, security = {count = 0, head_shots = 0, melee = 0, explosion = 0, tied = 0}}.total, {other = {count = 0, head_shots = 0, melee = 0, explosion = 0, tied = 0}, civilian = {count = 0, head_shots = 0, melee = 0, explosion = 0, tied = 0}, civilian_female = {count = 0, head_shots = 0, melee = 0, explosion = 0, tied = 0}, security = {count = 0, head_shots = 0, melee = 0, explosion = 0, tied = 0}}.heavy_swat, {other = {count = 0, head_shots = 0, melee = 0, explosion = 0, tied = 0}, civilian = {count = 0, head_shots = 0, melee = 0, explosion = 0, tied = 0}, civilian_female = {count = 0, head_shots = 0, melee = 0, explosion = 0, tied = 0}, security = {count = 0, head_shots = 0, melee = 0, explosion = 0, tied = 0}}.swat, {other = {count = 0, head_shots = 0, melee = 0, explosion = 0, tied = 0}, civilian = {count = 0, head_shots = 0, melee = 0, explosion = 0, tied = 0}, civilian_female = {count = 0, head_shots = 0, melee = 0, explosion = 0, tied = 0}, security = {count = 0, head_shots = 0, melee = 0, explosion = 0, tied = 0}}.cop = {other = {count = 0, head_shots = 0, melee = 0, explosion = 0, tied = 0}, civilian = {count = 0, head_shots = 0, melee = 0, explosion = 0, tied = 0}, civilian_female = {count = 0, head_shots = 0, melee = 0, explosion = 0, tied = 0}, security = {count = 0, head_shots = 0, melee = 0, explosion = 0, tied = 0}}, {count = 0, head_shots = 0, melee = 0, explosion = 0, tied = 0}, {count = 0, head_shots = 0, melee = 0, explosion = 0, tied = 0}, {count = 0, head_shots = 0, melee = 0, explosion = 0, tied = 0}, {count = 0, head_shots = 0, melee = 0, explosion = 0, tied = 0}, {count = 0, head_shots = 0, melee = 0, explosion = 0, tied = 0}, {count = 0, head_shots = 0, melee = 0, explosion = 0, tied = 0}, {count = 0, head_shots = 0, melee = 0, explosion = 0, tied = 0}, {count = 0, head_shots = 0, melee = 0, explosion = 0, tied = 0}, {count = 0, head_shots = 0, melee = 0, explosion = 0, tied = 0}, {count = 0, head_shots = 0, melee = 0, explosion = 0, tied = 0}, {count = 0, head_shots = 0, melee = 0, explosion = 0, tied = 0}, {count = 0, head_shots = 0, melee = 0, explosion = 0, tied = 0}, {count = 0, head_shots = 0, melee = 0, explosion = 0, tied = 0}
  l_2_0._defaults.killed_by_weapon = {}
  l_2_0._defaults.shots_by_weapon = {}
  l_2_0._defaults.sessions = {count = 0, time = 0}
  l_2_0._defaults.sessions.levels = {}
  for _,lvl in ipairs(tweak_data.levels._level_index) do
    l_2_0._defaults.sessions.levels[lvl] = {started = 0, completed = 0, quited = 0, drop_in = 0, from_beginning = 0, time = 0}
  end
  l_2_0._defaults.revives = {npc_count = 0, player_count = 0}
  l_2_0._defaults.cameras = {count = 0}
  l_2_0._defaults.objectives = {count = 0}
  l_2_0._defaults.shots_fired = {total = 0, hits = 0}
  l_2_0._defaults.downed = {bleed_out = 0, fatal = 0, incapacitated = 0, death = 0}
  l_2_0._defaults.reloads = {count = 0}
  l_2_0._defaults.health = {amount_lost = 0}
  l_2_0._defaults.experience = {}
  l_2_0._defaults.misc = {}
  if not Global.statistics_manager or l_2_1 then
    Global.statistics_manager = deep_clone(l_2_0._defaults)
    l_2_0._global = Global.statistics_manager
    l_2_0._global.session = deep_clone(l_2_0._defaults)
    l_2_0:_calculate_average()
  end
  if not l_2_0._global then
    l_2_0._global = Global.statistics_manager
  end
  l_2_0._m14_shots = 0
  l_2_0._m14_kills = 0
  l_2_0._last_kill = nil
  l_2_0._fbi_kills = 0
  l_2_0._patrol_bombed = 0
end

StatisticsManager.reset = function(l_3_0)
  l_3_0:_setup(true)
end

StatisticsManager._reset_session = function(l_4_0)
  if l_4_0._global then
    l_4_0._global.session = deep_clone(l_4_0._defaults)
  end
end

StatisticsManager._write_log_header = function(l_5_0)
  local file_handle = SystemFS:open(l_5_0._data_log_name, "w")
  file_handle:puts(managers.network.account:username())
  file_handle:puts(Network:is_server() and "true" or "false")
end

StatisticsManager._flush_log = function(l_6_0)
  if not l_6_0._data_log or #l_6_0._data_log == 0 then
    return 
  end
  do
    local file_handle = SystemFS:open(l_6_0._data_log_name, "a")
    for _,line in ipairs(l_6_0._data_log) do
      local type = line[1]
      local time = line[2]
      local pos = line[3]
      if type == 1 then
        file_handle:puts("1 " .. time .. " " .. pos.x .. " " .. pos.y .. " " .. pos.z .. " " .. line[4])
        for (for control),_ in (for generator) do
        end
        if type == 2 then
          file_handle:puts("2 " .. time .. " " .. pos.x .. " " .. pos.y .. " " .. pos.z .. " " .. line[4] .. " " .. tostring(line[5]))
          for (for control),_ in (for generator) do
          end
          if type == 3 then
            file_handle:puts("3 " .. time .. " " .. pos.x .. " " .. pos.y .. " " .. pos.z .. " " .. line[4] .. " " .. line[5])
          end
        end
        l_6_0._data_log = {}
      end
       -- Warning: missing end command somewhere! Added here
    end
     -- Warning: missing end command somewhere! Added here
  end
end

StatisticsManager.update = function(l_7_0, l_7_1, l_7_2)
  if l_7_0._data_log then
    l_7_0._log_timer = l_7_0._log_timer - l_7_2
    if l_7_0._log_timer <= 0 and alive(managers.player:player_unit()) then
      l_7_0._log_timer = 0.25
      table.insert(l_7_0._data_log, {1, Application:time(), managers.player:player_unit():position(), 1 / l_7_2})
      if Network:is_server() then
        for u_key,u_data in pairs(managers.enemy:all_enemies()) do
          table.insert(l_7_0._data_log, {2, Application:time(), u_data.unit:position(), 1, u_key})
        end
        for u_key,u_data in pairs(managers.groupai:state()._ai_criminals) do
          table.insert(l_7_0._data_log, {2, Application:time(), u_data.unit:position(), 2, u_key})
        end
        for u_key,u_data in pairs(managers.enemy:all_civilians()) do
          table.insert(l_7_0._data_log, {2, Application:time(), u_data.unit:position(), 3, u_key})
        end
      end
      if #l_7_0._data_log > 5000 then
        l_7_0:_flush_log()
      end
    end
  end
end

StatisticsManager.start_session = function(l_8_0, l_8_1)
  if l_8_0._session_started then
    return 
  end
  if Global.level_data.level_id then
    l_8_0._global.sessions.levels[Global.level_data.level_id].started = l_8_0._global.sessions.levels[Global.level_data.level_id].started + 1
    l_8_0._global.sessions.levels[Global.level_data.level_id].from_beginning = l_8_0._global.sessions.levels[Global.level_data.level_id].from_beginning + (l_8_1.from_beginning and 1 or 0)
    l_8_0._global.sessions.levels[Global.level_data.level_id].drop_in = l_8_0._global.sessions.levels[Global.level_data.level_id].drop_in + (l_8_1.drop_in and 1 or 0)
  end
  l_8_0._global.session = deep_clone(l_8_0._defaults)
  l_8_0._global.sessions.count = l_8_0._global.sessions.count + 1
  l_8_0._start_session_time = Application:time()
  l_8_0._start_session_from_beginning = l_8_1.from_beginning
  l_8_0._start_session_drop_in = l_8_1.drop_in
  l_8_0._session_started = true
end

StatisticsManager.stop_session = function(l_9_0, l_9_1)
  if not l_9_0._session_started then
    return 
  end
  l_9_0:_flush_log()
  l_9_0._data_log = nil
  l_9_0._session_started = nil
  if l_9_1 then
    local success = l_9_1.success
  end
  local session_time = Application:time() - l_9_0._start_session_time
  if Global.level_data.level_id then
    l_9_0._global.sessions.levels[Global.level_data.level_id].time = l_9_0._global.sessions.levels[Global.level_data.level_id].time + session_time
    if success then
      l_9_0._global.sessions.levels[Global.level_data.level_id].completed = l_9_0._global.sessions.levels[Global.level_data.level_id].completed + 1
    else
      l_9_0._global.sessions.levels[Global.level_data.level_id].quited = l_9_0._global.sessions.levels[Global.level_data.level_id].quited + 1
    end
  end
  l_9_0._global.sessions.time = l_9_0._global.sessions.time + session_time
  l_9_0._global.session.sessions.time = session_time
  l_9_0._global.last_session = deep_clone(l_9_0._global.session)
  l_9_0:_calculate_average()
  managers.challenges:session_stopped({success = success, from_beginning = l_9_0._start_session_from_beginning, drop_in = l_9_0._start_session_drop_in, last_session = l_9_0._global.last_session})
  managers.challenges:reset("session")
  if SystemInfo:platform() == Idstring("WIN32") then
    l_9_0:publish_to_steam(l_9_0._global.session, success)
  end
end

StatisticsManager.started_session_from_beginning = function(l_10_0)
  return l_10_0._start_session_from_beginning
end

StatisticsManager._increment_misc = function(l_11_0, l_11_1, l_11_2)
  if not l_11_0._global.misc then
    l_11_0._global.misc = {}
  end
  l_11_0._global.misc[l_11_1] = (l_11_0._global.misc[l_11_1] or 0) + l_11_2
  l_11_0._global.session.misc[l_11_1] = (l_11_0._global.session.misc[l_11_1] or 0) + l_11_2
  if l_11_0._data_log and alive(managers.player:player_unit()) then
    table.insert(l_11_0._data_log, {3, Application:time(), managers.player:player_unit():position(), l_11_1, l_11_2})
  end
end

StatisticsManager.use_trip_mine = function(l_12_0)
  l_12_0:_increment_misc("deploy_trip", 1)
end

StatisticsManager.use_ammo_bag = function(l_13_0)
  l_13_0:_increment_misc("deploy_ammo", 1)
end

StatisticsManager.use_doctor_bag = function(l_14_0)
  l_14_0:_increment_misc("deploy_medic", 1)
end

StatisticsManager.use_ecm_jammer = function(l_15_0)
  l_15_0:_increment_misc("deploy_jammer", 1)
end

StatisticsManager.in_custody = function(l_16_0)
  l_16_0:_increment_misc("in_custody", 1)
end

StatisticsManager.trade = function(l_17_0, l_17_1)
  l_17_0:_increment_misc("trade", 1)
end

StatisticsManager.aquired_money = function(l_18_0, l_18_1)
  l_18_0:_increment_misc("cash", l_18_1 * 1000)
end

StatisticsManager.publish_to_steam = function(l_19_0, l_19_1, l_19_2)
  if Application:editor() or not managers.criminals:local_character_name() then
    return 
  end
  local session_time_seconds = Application:time() - l_19_0._start_session_time
  local session_time_minutes = session_time_seconds / 60
  local session_time = session_time_minutes / 60
  if session_time_seconds == 0 or session_time_minutes == 0 or session_time == 0 then
    return 
  end
  local stats = {}
  for weapon,data in pairs(l_19_1.shots_by_weapon) do
    if data.total > 0 then
      stats[weapon .. "_shots"] = {type = "int", value = data.total}
      stats[weapon .. "_accuracy"] = {type = "avgrate", value = data.hits / data.total * 100, hours = session_time}
      stats[weapon .. "_kills"] = {type = "int", value = l_19_1.killed_by_weapon[weapon] and l_19_1.killed_by_weapon[weapon].count or 0}
      stats[weapon .. "_headshots"] = {type = "int", value = l_19_1.killed_by_weapon[weapon] and l_19_1.killed_by_weapon[weapon].headshots or 0}
    end
  end
  for unit,data in pairs(l_19_1.killed) do
    if unit ~= "civilian" and unit ~= "civilian_female" and unit ~= "other" and unit ~= "total" then
      stats[unit .. "_kills"] = {type = "int", value = data.count}
      stats[unit .. "_headshots"] = {type = "int", value = data.head_shots}
      stats[unit .. "_tied"] = {type = "int", value = data.tied}
      stats[unit .. "_melee"] = {type = "int", value = data.melee}
    end
  end
  local civ_kills = l_19_1.killed.civilian.count + l_19_1.killed.civilian_female.count
  local civ_headshots = l_19_1.killed.civilian.head_shots + l_19_1.killed.civilian_female.head_shots
  local civ_tied = l_19_1.killed.civilian.tied + l_19_1.killed.civilian_female.tied
  local civ_melee = l_19_1.killed.civilian.melee + l_19_1.killed.civilian_female.melee
  stats.civilian_kills = {type = "int", value = civ_kills}
  stats.civilian_tied = {type = "int", value = civ_tied}
  stats.civilian_melee = {type = "int", value = civ_melee}
  stats.civilian_headshots = {type = "int", value = civ_headshots}
  local downs = l_19_1.downed.bleed_out + l_19_1.downed.incapacitated
  stats[Global.game_settings.difficulty .. "_" .. Global.level_data.level_id .. "_" .. "plays"] = {type = "int", value = 1}
  stats[Global.game_settings.difficulty .. "_" .. Global.level_data.level_id .. "_" .. "wins"] = {type = "int", value = l_19_2 and 1 or 0}
  stats[Global.game_settings.difficulty .. "_" .. Global.level_data.level_id .. "_" .. "shots"] = {type = "int", value = l_19_1.shots_fired.total}
  stats[Global.game_settings.difficulty .. "_" .. Global.level_data.level_id .. "_" .. "shots_per_minute"] = {type = "avgrate", value = l_19_1.shots_fired.total / session_time_minutes, hours = session_time}
  stats[Global.game_settings.difficulty .. "_" .. Global.level_data.level_id .. "_" .. "kills"] = {type = "int", value = l_19_1.killed.total.count}
  stats[Global.game_settings.difficulty .. "_" .. Global.level_data.level_id .. "_" .. "kills_per_minute"] = {type = "avgrate", value = l_19_1.killed.total.count / session_time_minutes, hours = session_time}
  stats[Global.game_settings.difficulty .. "_" .. Global.level_data.level_id .. "_" .. "accuracy"] = {type = "avgrate", value = l_19_1.shots_fired.total > 0 and l_19_1.shots_fired.hits / l_19_1.shots_fired.total * 100 or 0, hours = session_time}
  stats[Global.game_settings.difficulty .. "_" .. Global.level_data.level_id .. "_" .. "health_lost"] = {type = "int", value = l_19_1.health.amount_lost}
  stats[Global.game_settings.difficulty .. "_" .. Global.level_data.level_id .. "_" .. "health_lost_per_minute"] = {type = "avgrate", value = l_19_1.health.amount_lost / session_time_minutes, hours = session_time}
  stats[Global.game_settings.difficulty .. "_" .. Global.level_data.level_id .. "_" .. "downs"] = {type = "int", value = downs}
  stats[Global.game_settings.difficulty .. "_" .. Global.level_data.level_id .. "_" .. "downs_per_minute"] = {type = "avgrate", value = downs / session_time_minutes, hours = session_time}
  if l_19_2 and not managers.statistics:is_dropin() then
    stats[Global.game_settings.difficulty .. "_" .. Global.level_data.level_id .. "_" .. "time"] = {type = "int", method = "lowest", value = session_time_seconds}
  end
  stats[Global.game_settings.difficulty .. "_" .. Global.level_data.level_id .. "_" .. "custody"] = {type = "int", value = l_19_1.misc.in_custody or 0}
  stats[Global.game_settings.difficulty .. "_" .. Global.level_data.level_id .. "_" .. "cash"] = {type = "int", value = l_19_1.misc.cash or 0}
  stats.current_level = {type = "int", method = "set", value = managers.experience._global.level}
  stats.current_assault = {type = "int", method = "set", value = managers.upgrades._global.progress[1]}
  stats.current_sharpshooter = {type = "int", method = "set", value = managers.upgrades._global.progress[2]}
  stats.current_support = {type = "int", method = "set", value = managers.upgrades._global.progress[3]}
  stats.plays_" .. managers.criminals:local_character_name( = {type = "int", value = 1}
  stats.total_accuracy = {type = "avgrate", value = l_19_1.shots_fired.total > 0 and l_19_1.shots_fired.hits / l_19_1.shots_fired.total * 100 or 0, hours = session_time}
  stats.allies_revived = {type = "int", value = l_19_1.revives.npc_count + l_19_1.revives.player_count}
  stats.allies_traded = {type = "int", value = l_19_1.misc.trade or 0}
  stats.deployed_medic = {type = "int", value = l_19_1.misc.deploy_medic or 0}
  stats.deployed_ammo = {type = "int", value = l_19_1.misc.deploy_ammo or 0}
  stats.deployed_trip_mine = {type = "int", value = l_19_1.misc.deploy_trip or 0}
  stats.deployed_ecm_jammer = {type = "int", value = l_19_1.misc.deploy_jammer or 0}
  managers.network.account:publish_statistics(stats, l_19_2)
end

StatisticsManager._calculate_average = function(l_20_0)
  local t = l_20_0._global.sessions.count ~= 0 and l_20_0._global.sessions.count or 1
  l_20_0._global.average = {}
  l_20_0._global.average.killed = deep_clone(l_20_0._global.killed)
  l_20_0._global.average.sessions = deep_clone(l_20_0._global.sessions)
  l_20_0._global.average.revives = deep_clone(l_20_0._global.revives)
  for _,data in pairs(l_20_0._global.average.killed) do
    data.count = math.round(data.count / t)
    data.head_shots = math.round(data.head_shots / t)
    data.melee = math.round(data.melee / t)
    data.explosion = math.round(data.explosion / t)
  end
  l_20_0._global.average.sessions.time = l_20_0._global.average.sessions.time / t
  for lvl,data in pairs(l_20_0._global.average.sessions.levels) do
    data.time = data.time / t
  end
  for counter,value in pairs(l_20_0._global.average.revives) do
    l_20_0._global.average.revives[counter] = math.round(value / t)
  end
  l_20_0._global.average.shots_fired = deep_clone(l_20_0._global.shots_fired)
  l_20_0._global.average.shots_fired.total = math.round(l_20_0._global.average.shots_fired.total / t)
  l_20_0._global.average.shots_fired.hits = math.round(l_20_0._global.average.shots_fired.hits / t)
  l_20_0._global.average.downed = deep_clone(l_20_0._global.downed)
  l_20_0._global.average.downed.bleed_out = math.round(l_20_0._global.average.downed.bleed_out / t)
  l_20_0._global.average.downed.fatal = math.round(l_20_0._global.average.downed.fatal / t)
  l_20_0._global.average.downed.incapacitated = math.round(l_20_0._global.average.downed.incapacitated / t)
  l_20_0._global.average.downed.death = math.round(l_20_0._global.average.downed.death / t)
  l_20_0._global.average.reloads = deep_clone(l_20_0._global.reloads)
  l_20_0._global.average.reloads.count = math.round(l_20_0._global.average.reloads.count / t)
  l_20_0._global.average.experience = deep_clone(l_20_0._global.experience)
  for size,data in pairs(l_20_0._global.average.experience) do
    if data.actions then
      data.count = math.round(data.count / t)
      for action,count in pairs(data.actions) do
        data.actions[action] = math.round(count / t)
      end
    end
  end
end

StatisticsManager.killed_by_anyone = function(l_21_0, l_21_1)
  local by_explosion = l_21_1.variant == "explosion"
  if l_21_1.weapon_unit then
    local name_id = l_21_1.weapon_unit:base():get_name_id()
  end
  managers.achievment:set_script_data("pacifist_fail", true)
  if name_id ~= "m79" and name_id ~= "m79_npc" then
    managers.achievment:set_script_data("blow_out_fail", true)
  end
  if by_explosion and l_21_1.name == "patrol" and name_id ~= "m79" then
    l_21_0._patrol_bombed = l_21_0._patrol_bombed + 1
    if l_21_0._patrol_bombed >= 12 and Global.level_data.level_id == "diamond_heist" then
      managers.challenges:set_flag("bomb_man")
    end
  end
end

StatisticsManager.killed = function(l_22_0, l_22_1)
  if tweak_data.character[l_22_1.name] then
    l_22_1.type = tweak_data.character[l_22_1.name].challenges.type
  end
  if not l_22_0._global.killed[l_22_1.name] then
    Application:error("Bad name id applied to killed, " .. tostring(l_22_1.name) .. ". Defaulting to 'other'")
    l_22_1.name = "other"
  end
  local by_bullet = l_22_1.variant == "bullet"
  local by_melee = l_22_1.variant == "melee"
  local by_explosion = l_22_1.variant == "explosion"
  local type = l_22_0._global.killed[l_22_1.name]
  type.count = type.count + 1
  type.head_shots = type.head_shots + (l_22_1.head_shot and 1 or 0)
  type.melee = type.melee + (by_melee and 1 or 0)
  type.explosion = type.explosion + (by_explosion and 1 or 0)
  l_22_0._global.killed.total.count = l_22_0._global.killed.total.count + 1
  l_22_0._global.killed.total.head_shots = l_22_0._global.killed.total.head_shots + (l_22_1.head_shot and 1 or 0)
  l_22_0._global.killed.total.melee = l_22_0._global.killed.total.melee + (by_melee and 1 or 0)
  l_22_0._global.killed.total.explosion = l_22_0._global.killed.total.explosion + (by_explosion and 1 or 0)
  local type = l_22_0._global.session.killed[l_22_1.name]
  type.count = type.count + 1
  type.head_shots = type.head_shots + (l_22_1.head_shot and 1 or 0)
  type.melee = type.melee + (by_melee and 1 or 0)
  type.explosion = type.explosion + (by_explosion and 1 or 0)
  l_22_0._global.session.killed.total.count = l_22_0._global.session.killed.total.count + 1
  l_22_0._global.session.killed.total.head_shots = l_22_0._global.session.killed.total.head_shots + (l_22_1.head_shot and 1 or 0)
  l_22_0._global.session.killed.total.melee = l_22_0._global.session.killed.total.melee + (by_melee and 1 or 0)
  l_22_0._global.session.killed.total.explosion = l_22_0._global.session.killed.total.explosion + (by_explosion and 1 or 0)
  if by_bullet then
    local name_id = l_22_1.weapon_unit:base():get_name_id()
    if not l_22_0._global.session.killed_by_weapon[name_id] then
      l_22_0._global.session.killed_by_weapon[name_id] = {count = 0, headshots = 0}
    end
    l_22_0._global.session.killed_by_weapon[name_id].count = l_22_0._global.session.killed_by_weapon[name_id].count + 1
    l_22_0._global.session.killed_by_weapon[name_id].headshots = l_22_0._global.session.killed_by_weapon[name_id].headshots + (l_22_1.head_shot and 1 or 0)
    if not l_22_0._global.killed_by_weapon[name_id] then
      l_22_0._global.killed_by_weapon[name_id] = {count = 0, headshots = 0}
    end
    l_22_0._global.killed_by_weapon[name_id].count = l_22_0._global.killed_by_weapon[name_id].count + 1
    l_22_0._global.killed_by_weapon[name_id].headshots = (l_22_0._global.killed_by_weapon[name_id].headshots or 0) + (l_22_1.head_shot and 1 or 0)
    l_22_0:_bullet_challenges(l_22_1)
    if name_id == "sentry_gun" then
      managers.challenges:count_up("sentry_gun_law_row_kills")
      if game_state_machine:last_queued_state_name() == "ingame_waiting_for_respawn" then
        managers.challenges:count_up("grim_reaper")
      else
        managers.challenges:reset_counter("sentry_gun_law_row_kills")
      end
    end
    if l_22_1.name == "tank" then
      managers.achievment:set_script_data("dodge_this_active", true)
      if name_id == "r870_shotgun" or name_id == "mossberg" then
        managers.challenges:set_flag("cheney")
      end
    end
    if name_id == "m14" then
       -- DECOMPILER ERROR: unhandled construct in 'if'

      if l_22_0._m14_kills == l_22_0._m14_shots and l_22_0._m14_kills == 29 then
        managers.challenges:set_flag("one_shot_one_kill")
        do return end
        l_22_0._m14_kills = 0
        l_22_0._m14_shots = 0
      end
      l_22_0._m14_kills = l_22_0._m14_kills + 1
    elseif by_melee then
      l_22_0:_melee_challenges(l_22_1)
      managers.challenges:reset_counter("sentry_gun_law_row_kills")
    elseif by_explosion then
      if l_22_1.weapon_unit then
        local name_id = l_22_1.weapon_unit:base():get_name_id()
      end
      if name_id == "m79" then
        if not l_22_0._global.session.killed_by_weapon[name_id] then
          l_22_0._global.session.killed_by_weapon[name_id] = {count = 0, headshots = 0}
        end
        l_22_0._global.session.killed_by_weapon[name_id].count = l_22_0._global.session.killed_by_weapon[name_id].count + 1
        l_22_0._global.session.killed_by_weapon[name_id].headshots = l_22_0._global.session.killed_by_weapon[name_id].headshots + (l_22_1.head_shot and 1 or 0)
        if not l_22_0._global.killed_by_weapon[name_id] then
          l_22_0._global.killed_by_weapon[name_id] = {count = 0, headshots = 0}
        end
        l_22_0._global.killed_by_weapon[name_id].count = l_22_0._global.killed_by_weapon[name_id].count + 1
        l_22_0._global.killed_by_weapon[name_id].headshots = (l_22_0._global.killed_by_weapon[name_id].headshots or 0) + (l_22_1.head_shot and 1 or 0)
        l_22_0:_bullet_challenges(l_22_1)
      end
      l_22_0:_explosion_challenges(l_22_1)
      managers.challenges:reset_counter("sentry_gun_law_row_kills")
    end
  end
  l_22_0._last_kill = l_22_1.name
  if l_22_0:session_total_law_enforcer_kills() >= 100 then
    managers.challenges:set_flag("civil_disobedience")
  end
  if l_22_1.name == "fbi" then
    l_22_0._fbi_kills = l_22_0._fbi_kills + 1
    if l_22_0._fbi_kills >= 25 then
      managers.challenges:set_flag("federal_crime")
    else
      l_22_0._fbi_kills = 0
    end
  end
end

StatisticsManager._bullet_challenges = function(l_23_0, l_23_1)
  managers.challenges:count_up(l_23_1.type .. "_kill")
  managers.challenges:count_up(l_23_1.name .. "_kill")
  if l_23_1.head_shot then
    managers.challenges:count_up(l_23_1.type .. "_head_shot")
  else
    managers.challenges:count_up(l_23_1.type .. "_body_shot")
  end
  if l_23_1.attacker_state and l_23_1.attacker_state == "bleed_out" then
    local weapon_name_id = l_23_1.weapon_unit:base():get_name_id()
    if weapon_name_id ~= "sentry_gun" then
      managers.challenges:count_up("bleed_out_kill")
      managers.challenges:count_up("bleed_out_multikill")
    end
  end
  local weapon_tweak_data = l_23_1.weapon_unit:base():weapon_tweak_data()
  if weapon_tweak_data.challenges then
    if weapon_tweak_data.challenges.weapon then
      managers.challenges:count_up(weapon_tweak_data.challenges.weapon .. "_" .. l_23_1.type .. "_kill")
      managers.challenges:count_up(weapon_tweak_data.challenges.weapon .. "_" .. l_23_1.name .. "_kill")
    else
      if not weapon_tweak_data.challenges.group then
        managers.challenges:count_up(weapon_tweak_data.challenges.prefix .. "_kill")
      end
      if l_23_1.head_shot then
        if weapon_tweak_data.challenges.weapon then
          managers.challenges:count_up(weapon_tweak_data.challenges.weapon .. "_" .. l_23_1.type .. "_head_shot")
          managers.challenges:count_up(weapon_tweak_data.challenges.weapon .. "_" .. l_23_1.name .. "_head_shot")
        else
          if not weapon_tweak_data.challenges.group then
            managers.challenges:count_up(weapon_tweak_data.challenges.prefix .. "_head_shot")
          else
            if weapon_tweak_data.challenges.weapon then
              managers.challenges:count_up(weapon_tweak_data.challenges.weapon .. "_" .. l_23_1.type .. "_body_shot")
              managers.challenges:count_up(weapon_tweak_data.challenges.weapon .. "_" .. l_23_1.name .. "_body_shot")
            else
              if not weapon_tweak_data.challenges.group then
                managers.challenges:count_up(weapon_tweak_data.challenges.prefix .. "_body_shot")
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
end

StatisticsManager._melee_challenges = function(l_24_0, l_24_1)
  if l_24_1.type == "law" then
    managers.challenges:count_up("melee_law_kill")
  end
end

StatisticsManager._explosion_challenges = function(l_25_0, l_25_1)
  if game_state_machine:last_queued_state_name() == "ingame_waiting_for_respawn" then
    managers.challenges:count_up("grim_reaper")
  end
  if l_25_1.weapon_unit then
    local weapon_id = l_25_1.weapon_unit:base():get_name_id()
  end
  if weapon_id == "m79" then
    managers.challenges:count_up("m79_law_simultaneous_kills")
    if l_25_1.name == "shield" or l_25_1.name == "spooc" or l_25_1.name == "tank" or l_25_1.name == "taser" then
      managers.challenges:count_up("m79_simultaneous_specials")
    elseif weapon_id == "trip_mine" and l_25_1.type == "law" then
      managers.challenges:count_up("trip_mine_law_kill")
    end
  end
end

StatisticsManager.tied = function(l_26_0, l_26_1)
  if tweak_data.character[l_26_1.name] then
    l_26_1.type = tweak_data.character[l_26_1.name].challenges.type
  end
  if not l_26_0._global.killed[l_26_1.name] then
    Application:error("Bad name id applied to tied, " .. tostring(l_26_1.name) .. ". Defaulting to 'other'")
    l_26_1.name = "other"
  end
  if l_26_1.name == "heavy_swat" then
    managers.challenges:set_flag("intimidating")
  end
  l_26_0._global.killed[l_26_1.name].tied = (l_26_0._global.killed[l_26_1.name].tied or 0) + 1
  l_26_0._global.session.killed[l_26_1.name].tied = l_26_0._global.session.killed[l_26_1.name].tied + 1
  if tweak_data.character[l_26_1.name] then
    local type = tweak_data.character[l_26_1.name].challenges.type
  end
  if type then
    managers.challenges:count_up("tiedown_" .. type)
  end
  managers.challenges:count_up("tiedown_" .. l_26_1.name)
  if l_26_0._data_log and alive(managers.player:player_unit()) then
    table.insert(l_26_0._data_log, {3, Application:time(), managers.player:player_unit():position(), "tiedown", 1})
  end
end

StatisticsManager.revived = function(l_27_0, l_27_1)
  if not l_27_1.reviving_unit or l_27_1.reviving_unit ~= managers.player:player_unit() then
    return 
  end
  local counter = l_27_1.npc and "npc_count" or "player_count"
  l_27_0._global.revives[counter] = l_27_0._global.revives[counter] + 1
  l_27_0._global.session.revives[counter] = l_27_0._global.session.revives[counter] + 1
  managers.challenges:count_up("revive")
  if l_27_0._data_log and alive(managers.player:player_unit()) then
    table.insert(l_27_0._data_log, {3, Application:time(), managers.player:player_unit():position(), "revive", 1})
  end
end

StatisticsManager.camera_destroyed = function(l_28_0, l_28_1)
  l_28_0._global.cameras.count = l_28_0._global.cameras.count + 1
  l_28_0._global.session.cameras.count = l_28_0._global.session.cameras.count + 1
end

StatisticsManager.objective_completed = function(l_29_0, l_29_1)
  if managers.platform:presence() ~= "Playing" and managers.platform:presence() ~= "Mission_end" then
    return 
  end
  l_29_0._global.objectives.count = l_29_0._global.objectives.count + 1
  l_29_0._global.session.objectives.count = l_29_0._global.session.objectives.count + 1
end

StatisticsManager.health_subtracted = function(l_30_0, l_30_1)
  l_30_0._global.health.amount_lost = l_30_0._global.health.amount_lost + l_30_1
  l_30_0._global.session.health.amount_lost = l_30_0._global.session.health.amount_lost + l_30_1
end

StatisticsManager.shot_fired = function(l_31_0, l_31_1)
  l_31_0._global.shots_fired.total = l_31_0._global.shots_fired.total + 1
  l_31_0._global.session.shots_fired.total = l_31_0._global.session.shots_fired.total + 1
  local name_id = l_31_1.weapon_unit:base():get_name_id()
  if not l_31_0._global.session.shots_by_weapon[name_id] then
    l_31_0._global.session.shots_by_weapon[name_id] = {hits = 0, total = 0}
  end
  l_31_0._global.session.shots_by_weapon[name_id].total = l_31_0._global.session.shots_by_weapon[name_id].total + 1
  if not l_31_0._global.shots_by_weapon[name_id] then
    l_31_0._global.shots_by_weapon[name_id] = {hits = 0, total = 0}
  end
  l_31_0._global.shots_by_weapon[name_id].total = l_31_0._global.shots_by_weapon[name_id].total + 1
  if l_31_1.hit then
    l_31_0._global.shots_fired.hits = l_31_0._global.shots_fired.hits + 1
    l_31_0._global.session.shots_fired.hits = l_31_0._global.session.shots_fired.hits + 1
    l_31_0._global.session.shots_by_weapon[name_id].hits = l_31_0._global.session.shots_by_weapon[name_id].hits + 1
    l_31_0._global.shots_by_weapon[name_id].hits = l_31_0._global.shots_by_weapon[name_id].hits + 1
  end
  if name_id == "m14" then
    l_31_0._m14_shots = l_31_0._m14_shots + 1
  end
end

StatisticsManager.downed = function(l_32_0, l_32_1)
  managers.achievment:set_script_data("stand_together_fail", true)
  local counter = ((not l_32_1.bleed_out or not "bleed_out") and (not l_32_1.fatal or not "fatal") and (l_32_1.incapacitated and "incapacitated")) or "death"
  l_32_0._global.downed[counter] = l_32_0._global.downed[counter] + 1
  l_32_0._global.session.downed[counter] = l_32_0._global.session.downed[counter] + 1
  if l_32_1.bleed_out then
    managers.challenges:reset("bleed_out")
  end
  if l_32_0._data_log and alive(managers.player:player_unit()) then
    table.insert(l_32_0._data_log, {3, Application:time(), managers.player:player_unit():position(), "downed", 1})
  end
end

StatisticsManager.reloaded = function(l_33_0, l_33_1)
  l_33_0._global.reloads.count = l_33_0._global.reloads.count + 1
  l_33_0._global.session.reloads.count = l_33_0._global.session.reloads.count + 1
  if l_33_0._data_log and alive(managers.player:player_unit()) then
    table.insert(l_33_0._data_log, {3, Application:time(), managers.player:player_unit():position(), "reloaded", 1})
  end
end

StatisticsManager.recieved_experience = function(l_34_0, l_34_1)
  if not l_34_0._global.experience[l_34_1.size] then
    l_34_0._global.experience[l_34_1.size] = {count = 0, actions = {}}
  end
  l_34_0._global.experience[l_34_1.size].count = l_34_0._global.experience[l_34_1.size].count + 1
  l_34_0._global.experience[l_34_1.size].actions[l_34_1.action] = l_34_0._global.experience[l_34_1.size].actions[l_34_1.action] or 0
  l_34_0._global.experience[l_34_1.size].actions[l_34_1.action] = l_34_0._global.experience[l_34_1.size].actions[l_34_1.action] + 1
  if not l_34_0._global.session.experience[l_34_1.size] then
    l_34_0._global.session.experience[l_34_1.size] = {count = 0, actions = {}}
  end
  l_34_0._global.session.experience[l_34_1.size].count = l_34_0._global.session.experience[l_34_1.size].count + 1
  l_34_0._global.session.experience[l_34_1.size].actions[l_34_1.action] = l_34_0._global.session.experience[l_34_1.size].actions[l_34_1.action] or 0
  l_34_0._global.session.experience[l_34_1.size].actions[l_34_1.action] = l_34_0._global.session.experience[l_34_1.size].actions[l_34_1.action] + 1
end

StatisticsManager.get_killed = function(l_35_0)
  return l_35_0._global.killed
end

StatisticsManager.count_up = function(l_36_0, l_36_1)
  if not l_36_0._statistics[l_36_1] then
    Application:stack_dump_error("Bad id to count up, " .. tostring(l_36_1) .. ".")
    return 
  end
  l_36_0._statistics[l_36_1].count = l_36_0._statistics[l_36_1].count + 1
end

StatisticsManager.print_stats = function(l_37_0)
  local time_text = l_37_0:_time_text(math.round(l_37_0._global.sessions.time))
  local time_average_text = l_37_0:_time_text(math.round(l_37_0._global.average.sessions.time))
  local t = l_37_0._global.sessions.count ~= 0 and l_37_0._global.sessions.count or 1
  print("- Sessions \t\t-")
  print("Total sessions:\t", l_37_0._global.sessions.count)
  print("Total time:\t\t", time_text)
  print("Average time:\t", time_average_text)
  print("\n- Levels \t\t-")
  for name,data in pairs(l_37_0._global.sessions.levels) do
    local time_text = l_37_0:_time_text(math.round(data.time))
    print("Started: " .. data.started .. "\tBeginning: " .. data.from_beginning .. "\tDrop in: " .. data.drop_in .. "\tCompleted: " .. data.completed .. "\tQuited: " .. data.quited .. "\tTime: " .. time_text .. "\t- " .. name)
  end
  print("\n- Kills \t\t-")
  for name,data in pairs(l_37_0._global.killed) do
    print("Count: " .. l_37_0:_amount_format(data.count) .. "/" .. l_37_0:_amount_format(l_37_0._global.average.killed[name].count, true) .. " Head shots: " .. l_37_0:_amount_format(data.head_shots) .. "/" .. l_37_0:_amount_format(l_37_0._global.average.killed[name].head_shots, true) .. " Melee: " .. l_37_0:_amount_format(data.melee) .. "/" .. l_37_0:_amount_format(l_37_0._global.average.killed[name].melee, true) .. " Explosion: " .. l_37_0:_amount_format(data.explosion) .. "/" .. l_37_0:_amount_format(l_37_0._global.average.killed[name].explosion, true) .. " " .. name)
  end
  print("\n- Revives \t\t-")
  print("Count: " .. l_37_0._global.revives.npc_count .. "/" .. l_37_0._global.average.revives.npc_count .. "\t- Npcs")
  print("Count: " .. l_37_0._global.revives.player_count .. "/" .. l_37_0._global.average.revives.player_count .. "\t- Players")
  print("\n- Cameras \t\t-")
  print("Count: " .. l_37_0._global.cameras.count)
  print("\n- Objectives \t-")
  print("Count: " .. l_37_0._global.objectives.count)
  print("\n- Shots fired \t-")
  print("Total: " .. l_37_0._global.shots_fired.total .. "/" .. l_37_0._global.average.shots_fired.total)
  print("Hits: " .. l_37_0._global.shots_fired.hits .. "/" .. l_37_0._global.average.shots_fired.hits)
  print("Hit percentage: " .. math.round(l_37_0._global.shots_fired.hits / (l_37_0._global.shots_fired.total ~= 0 and l_37_0._global.shots_fired.total or 1) * 100) .. "%")
  print("\n- Downed \t-")
  print("Bleed out: " .. l_37_0._global.downed.bleed_out .. "/" .. l_37_0._global.average.downed.bleed_out)
  print("Fatal: " .. l_37_0._global.downed.fatal .. "/" .. l_37_0._global.average.downed.fatal)
  print("Incapacitated: " .. l_37_0._global.downed.incapacitated .. "/" .. l_37_0._global.average.downed.incapacitated)
  print("Death: " .. l_37_0._global.downed.death .. "/" .. l_37_0._global.average.downed.death)
  print("\n- Reloads \t-")
  print("Count: " .. l_37_0._global.reloads.count .. "/" .. l_37_0._global.average.reloads.count)
  l_37_0:_print_experience_stats()
end

StatisticsManager.is_dropin = function(l_38_0)
  return l_38_0._start_session_drop_in
end

StatisticsManager._print_experience_stats = function(l_39_0)
  local t = l_39_0._global.sessions.count ~= 0 and l_39_0._global.sessions.count or 1
  local average = l_39_0._global.average.experience
  local total = 0
  print("\n- Experience -")
  for size,data in pairs(l_39_0._global.experience) do
    local exp = tweak_data.experience_manager.values[size]
    local average_count = average[size] and l_39_0:_amount_format(average[size].count, true) or "-"
    local average_exp = average[size] and l_39_0:_amount_format(exp * average[size].count, true) or "-"
    total = total + exp * data.count
    print("\nSize: " .. size .. " " .. l_39_0:_amount_format(exp, true) .. "" .. l_39_0:_amount_format(data.count) .. "/" .. average_count .. " " .. l_39_0:_amount_format(exp * data.count) .. "/" .. average_exp)
    for action,count in pairs(data.actions) do
      local average_count = average[size] and average[size].actions[action] and l_39_0:_amount_format(average[size].actions[action], true) or "-"
      local average_exp = average[size] and average[size].actions[action] and l_39_0:_amount_format(exp * average[size].actions[action], true) or "-"
      print("\tAction: " .. action)
      print("\t\tCount:" .. l_39_0:_amount_format(count) .. "/" .. average_count .. l_39_0:_amount_format(exp * count) .. "/" .. average_exp)
    end
  end
  print("\nTotal:" .. l_39_0:_amount_format(total) .. "/" .. l_39_0:_amount_format((total) / t, true))
end

StatisticsManager._amount_format = function(l_40_0, l_40_1, l_40_2)
  l_40_1 = math.round(l_40_1)
  local s = ""
  for i = 6 - string.len(l_40_1), 0, -1 do
    s = s .. " "
  end
  if not l_40_2 or not l_40_1 .. s then
    return s .. l_40_1
  end
end

StatisticsManager._time_text = function(l_41_0, l_41_1, l_41_2)
  if l_41_2 then
    local no_days = l_41_2.no_days
  end
  if not no_days or not 0 then
    local days = math.floor(l_41_1 / 86400)
  end
  l_41_1 = l_41_1 - days * 86400
  local hours = math.floor((l_41_1) / 3600)
  l_41_1 = l_41_1 - hours * 3600
  local minutes = math.floor((l_41_1) / 60)
  l_41_1 = l_41_1 - minutes * 60
  local seconds = math.round(l_41_1)
  if seconds >= 10 or not "0" .. seconds then
    return (no_days and "" or days) .. ":" .. hours .. ":" .. minutes .. ":" .. seconds
  end
end

StatisticsManager._check_loaded_data = function(l_42_0)
  if not l_42_0._global.downed.incapacitated then
    l_42_0._global.downed.incapacitated = 0
  end
  for name,data in pairs(l_42_0._defaults.killed) do
    if not l_42_0._global.killed[name] then
      l_42_0._global.killed[name] = deep_clone(l_42_0._defaults.killed[name])
    end
  end
  for name,data in pairs(l_42_0._global.killed) do
    data.melee = data.melee or 0
    data.explosion = data.explosion or 0
  end
  for name,lvl in pairs(l_42_0._defaults.sessions.levels) do
    if not l_42_0._global.sessions.levels[name] then
      l_42_0._global.sessions.levels[name] = deep_clone(lvl)
    end
  end
  for _,lvl in pairs(l_42_0._global.sessions.levels) do
    lvl.drop_in = lvl.drop_in or 0
    lvl.from_beginning = lvl.from_beginning or 0
  end
  if not l_42_0._global.experience then
    l_42_0._global.experience = deep_clone(l_42_0._defaults.experience)
  end
end

StatisticsManager.time_played = function(l_43_0)
  local time = math.round(l_43_0._global.sessions.time)
  local time_text = l_43_0:_time_text(time)
  return time_text, time
end

StatisticsManager.favourite_level = function(l_44_0)
  local started = 0
  local c_name = nil
  for name,data in pairs(l_44_0._global.sessions.levels) do
  end
  if (((started >= data.started or not name) and started >= data.started) or not data.started) then
    end
    if not c_name or not tweak_data.levels:get_localized_level_name_from_level_id(c_name) then
      return managers.localization:text("debug_undecided")
    end
     -- Warning: missing end command somewhere! Added here
  end
end

StatisticsManager.total_completed_campaigns = function(l_45_0)
  local i = 0
  for name,data in pairs(l_45_0._global.sessions.levels) do
    i = i + data.completed
  end
  return i
end

StatisticsManager.favourite_weapon = function(l_46_0)
  local weapon_id = nil
  local count = 0
  for id,data in pairs(l_46_0._global.killed_by_weapon) do
    if count < data.count then
      count = data.count
      weapon_id = id
    end
  end
  if not weapon_id or not managers.localization:text(tweak_data.weapon[weapon_id].name_id) then
    return managers.localization:text("debug_undecided")
  end
end

StatisticsManager.total_kills = function(l_47_0)
  return l_47_0._global.killed.total.count
end

StatisticsManager.total_head_shots = function(l_48_0)
  return l_48_0._global.killed.total.head_shots
end

StatisticsManager.hit_accuracy = function(l_49_0)
  if l_49_0._global.shots_fired.total == 0 then
    return 0
  end
  return math.floor(l_49_0._global.shots_fired.hits / l_49_0._global.shots_fired.total * 100)
end

StatisticsManager.total_completed_objectives = function(l_50_0)
  return l_50_0._global.objectives.count
end

StatisticsManager.total_downed = function(l_51_0)
  return l_51_0._global.session.downed.bleed_out + l_51_0._global.session.downed.incapacitated
end

StatisticsManager.session_time_played = function(l_52_0)
  local time = math.round(l_52_0._global.session.sessions.time)
  local time_text = l_52_0:_time_text(time, {no_days = true})
  return time_text, time
end

StatisticsManager.completed_objectives = function(l_53_0)
  return l_53_0._global.session.objectives.count
end

StatisticsManager.session_favourite_weapon = function(l_54_0)
  local weapon_id = nil
  local count = 0
  for id,data in pairs(l_54_0._global.session.killed_by_weapon) do
    if count < data.count then
      count = data.count
      weapon_id = id
    end
  end
  if not weapon_id or not managers.localization:text(tweak_data.weapon[weapon_id].name_id) then
    return managers.localization:text("debug_undecided")
  end
end

StatisticsManager.session_total_kills = function(l_55_0)
  return l_55_0._global.session.killed.total.count
end

StatisticsManager.session_total_specials_kills = function(l_56_0)
  return l_56_0._global.session.killed.shield.count + l_56_0._global.session.killed.spooc.count + l_56_0._global.session.killed.tank.count + l_56_0._global.session.killed.taser.count
end

StatisticsManager.session_total_head_shots = function(l_57_0)
  return l_57_0._global.session.killed.total.head_shots
end

StatisticsManager.session_hit_accuracy = function(l_58_0)
  if l_58_0._global.session.shots_fired.total == 0 then
    return 0
  end
  return math.floor(l_58_0._global.session.shots_fired.hits / l_58_0._global.session.shots_fired.total * 100)
end

StatisticsManager.session_total_civilian_kills = function(l_59_0)
  return l_59_0._global.session.killed.civilian.count + l_59_0._global.session.killed.civilian_female.count
end

StatisticsManager.session_total_law_enforcer_kills = function(l_60_0)
  return l_60_0._global.session.killed.total.count - l_60_0._global.session.killed.civilian.count - l_60_0._global.session.killed.civilian_female.count - l_60_0._global.session.killed.gangster.count - l_60_0._global.session.killed.other.count
end

StatisticsManager.send_statistics = function(l_61_0)
  if not managers.network:session() then
    return 
  end
  local peer_id = managers.network:session():local_peer():id()
  local total_kills = l_61_0:session_total_kills()
  local total_specials_kills = l_61_0:session_total_specials_kills()
  local total_head_shots = l_61_0:session_total_head_shots()
  local accuracy = l_61_0:session_hit_accuracy()
  local downs = l_61_0:total_downed()
  if Network:is_server() then
    managers.network:game():on_statistics_recieved(peer_id, total_kills, total_specials_kills, total_head_shots, accuracy, downs)
  else
    managers.network:session():send_to_host("send_statistics", peer_id, total_kills, total_specials_kills, total_head_shots, accuracy, downs)
  end
end

StatisticsManager.save = function(l_62_0, l_62_1)
  {camera = l_62_0._global.cameras, downed = l_62_0._global.downed, killed = l_62_0._global.killed, objectives = l_62_0._global.objectives, reloads = l_62_0._global.reloads, revives = l_62_0._global.revives, sessions = l_62_0._global.sessions, shots_fired = l_62_0._global.shots_fired, experience = l_62_0._global.experience, killed_by_weapon = l_62_0._global.killed_by_weapon}.shots_by_weapon = l_62_0._global.shots_by_weapon
   -- DECOMPILER ERROR: Confused about usage of registers!

  {camera = l_62_0._global.cameras, downed = l_62_0._global.downed, killed = l_62_0._global.killed, objectives = l_62_0._global.objectives, reloads = l_62_0._global.reloads, revives = l_62_0._global.revives, sessions = l_62_0._global.sessions, shots_fired = l_62_0._global.shots_fired, experience = l_62_0._global.experience, killed_by_weapon = l_62_0._global.killed_by_weapon}.health = l_62_0._global.health
   -- DECOMPILER ERROR: Confused about usage of registers!

  {camera = l_62_0._global.cameras, downed = l_62_0._global.downed, killed = l_62_0._global.killed, objectives = l_62_0._global.objectives, reloads = l_62_0._global.reloads, revives = l_62_0._global.revives, sessions = l_62_0._global.sessions, shots_fired = l_62_0._global.shots_fired, experience = l_62_0._global.experience, killed_by_weapon = l_62_0._global.killed_by_weapon}.misc = l_62_0._global.misc
  do
     -- DECOMPILER ERROR: Confused at declaration of local variable

     -- DECOMPILER ERROR: Confused about usage of registers!

    l_62_1.StatisticsManager = {camera = l_62_0._global.cameras, downed = l_62_0._global.downed, killed = l_62_0._global.killed, objectives = l_62_0._global.objectives, reloads = l_62_0._global.reloads, revives = l_62_0._global.revives, sessions = l_62_0._global.sessions, shots_fired = l_62_0._global.shots_fired, experience = l_62_0._global.experience, killed_by_weapon = l_62_0._global.killed_by_weapon}
  end
   -- DECOMPILER ERROR: Confused about usage of registers for local variables.

end

StatisticsManager.load = function(l_63_0, l_63_1)
  local state = l_63_1.StatisticsManager
  if state then
    for name,stats in pairs(state) do
      l_63_0._global[name] = stats
    end
    l_63_0:_check_loaded_data()
    l_63_0:_calculate_average()
  end
end


