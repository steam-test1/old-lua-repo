-- Decompiled using luadec 2.0.1 by sztupy (http://winmo.sztupy.hu)
-- Command line was: F:\SteamLibrary\SteamApps\common\PAYDAY 2\lua\lib\managers\crimenetmanager.luac 

require("lib/managers/menu/WalletGuiObject")
if not CrimeNetManager then
  CrimeNetManager = class()
end
CrimeNetManager.init = function(l_1_0)
  l_1_0._tweak_data = tweak_data.gui.crime_net
  l_1_0._active = false
  l_1_0._active_jobs = {}
  l_1_0:_setup_vars()
end

CrimeNetManager._setup_vars = function(l_2_0)
  l_2_0._active_job_time = l_2_0._tweak_data.job_vars.active_job_time
  l_2_0._NEW_JOB_MIN_TIME = l_2_0._tweak_data.job_vars.new_job_min_time
  l_2_0._NEW_JOB_MAX_TIME = l_2_0._tweak_data.job_vars.new_job_max_time
  l_2_0._next_job_timer = (l_2_0._NEW_JOB_MIN_TIME + l_2_0._NEW_JOB_MAX_TIME) / 2
  l_2_0._MAX_ACTIVE_JOBS = l_2_0._tweak_data.job_vars.max_active_jobs
  l_2_0._refresh_server_t = 0
  l_2_0._REFRESH_SERVERS_TIME = l_2_0._tweak_data.job_vars.refresh_servers_time
  l_2_0._debug_mass_spawning = not Application:production_build() or tweak_data.gui.crime_net.debug_options.mass_spawn or false
  l_2_0._active_server_jobs = {}
end

CrimeNetManager._get_jobs_by_jc = function(l_3_0)
  do
    local t = {}
    tweak_data.narrative:get_jobs_index()
    for _,job_id in ipairs(tweak_data.narrative:get_jobs_index()) do
      do
        if managers.job:check_ok_with_cooldown(job_id) then
          local job_data = tweak_data.narrative.jobs[job_id]
          for i = job_data.professional and 1 or 0, 3 do
            if not t[job_data.jc + i * 10] then
              t[job_data.jc + i * 10] = {}
            end
            local difficulty_id = 2 + i
            local difficulty = tweak_data:index_to_difficulty(difficulty_id)
            table.insert(t[job_data.jc + i * 10], {job_id = job_id, difficulty_id = difficulty_id, difficulty = difficulty})
          end
        end
        for (for control),_ in (for generator) do
        end
        print("SKIP DUE TO COOLDOWN", job_id)
      end
      return t
    end
     -- Warning: missing end command somewhere! Added here
  end
end

CrimeNetManager._setup = function(l_4_0)
  if l_4_0._presets then
    return 
  end
  l_4_0._presets = {}
  local plvl = managers.experience:current_level()
  local player_stars = math.clamp(math.ceil((plvl + 1) / 10), 1, 10)
  local stars = player_stars
  local jc = math.lerp(0, 100, stars / 10)
  local jcs = tweak_data.narrative.STARS[stars].jcs
  local no_jcs = #jcs
  local chance_curve = tweak_data.narrative.STARS_CURVES[player_stars]
  local start_chance = tweak_data.narrative.JC_CHANCE
  local jobs_by_jc = l_4_0:_get_jobs_by_jc()
  if not l_4_0._debug_mass_spawning or not tweak_data.gui.crime_net.debug_options.mass_spawn_limit then
    local no_picks = tweak_data.narrative.JC_PICKS
  end
  local j = 0
  do
    local tests = 0
    repeat
      repeat
        repeat
          repeat
            if j < no_picks then
              for i = 1, no_jcs do
                local chance = nil
                if no_jcs - 1 == 0 then
                  chance = 1
                else
                  chance = math.lerp(start_chance, 1, math.pow((i - 1) / (no_jcs - 1), chance_curve))
                end
                local roll = math.rand(1)
                if roll <= chance then
                  if not jobs_by_jc[jcs[i]] then
                    do return end
                  end
                  if #jobs_by_jc[jcs[i]] == 0 then
                    do return end
                  end
                  local job_data = nil
                  if l_4_0._debug_mass_spawning then
                    job_data = jobs_by_jc[jcs[i]][math.random(#jobs_by_jc[jcs[i]])]
                  else
                    job_data = table.remove(jobs_by_jc[jcs[i]], math.random(#jobs_by_jc[jcs[i]]))
                  end
                  table.insert(l_4_0._presets, job_data)
                  j = j + 1
              else
                end
              end
              tests = tests + 1
            until l_4_0._debug_mass_spawning and tweak_data.gui.crime_net.debug_options.mass_spawn_limit <= tests
            do return end
            do return end
          until tests >= 25
          do return end
        else
          print("Jobs:", inspect(l_4_0._presets))
        end
         -- Warning: missing end command somewhere! Added here
      end
       -- Warning: missing end command somewhere! Added here
    end
     -- Warning: missing end command somewhere! Added here
  end
end

CrimeNetManager.reset_seed = function(l_5_0)
  l_5_0._presets = nil
end

CrimeNetManager.update = function(l_6_0, l_6_1, l_6_2)
  if not l_6_0._active then
    return 
  end
  for id,job in pairs(l_6_0._active_jobs) do
    if not job.added then
      job.added = true
      managers.menu_component:add_crimenet_gui_preset_job(id)
    end
    job.active_timer = job.active_timer - l_6_2
    managers.menu_component:update_crimenet_job(id, l_6_1, l_6_2)
    managers.menu_component:feed_crimenet_job_timer(id, job.active_timer, l_6_0._active_job_time)
    if job.active_timer < 0 then
      managers.menu_component:remove_crimenet_gui_job(id)
      l_6_0._active_jobs[id] = nil
    end
  end
  local max_active_jobs = math.min(l_6_0._MAX_ACTIVE_JOBS, #l_6_0._presets)
  if l_6_0._debug_mass_spawning then
    max_active_jobs = math.min(tweak_data.gui.crime_net.debug_options.mass_spawn_limit, #l_6_0._presets)
  end
  if table.size(l_6_0._active_jobs) < max_active_jobs and table.size(l_6_0._active_jobs) + table.size(l_6_0._active_server_jobs) < tweak_data.gui.crime_net.job_vars.total_active_jobs then
    l_6_0._next_job_timer = l_6_0._next_job_timer - l_6_2
    if l_6_0._next_job_timer < 0 then
      l_6_0._next_job_timer = math.rand(l_6_0._NEW_JOB_MIN_TIME, l_6_0._NEW_JOB_MAX_TIME)
      l_6_0:activate_job()
      if l_6_0._debug_mass_spawning then
        l_6_0._next_job_timer = tweak_data.gui.crime_net.debug_options.mass_spawn_timer
      end
    end
  end
  for id,job in pairs(l_6_0._active_server_jobs) do
    job.alive_time = job.alive_time + l_6_2
    managers.menu_component:update_crimenet_job(id, l_6_1, l_6_2)
    managers.menu_component:feed_crimenet_server_timer(id, job.alive_time)
  end
  managers.menu_component:update_crimenet_gui(l_6_1, l_6_2)
   -- DECOMPILER ERROR: unhandled construct in 'if'

  if not l_6_0._skip_servers and l_6_0._refresh_server_t < Application:time() then
    l_6_0:find_online_games(Global.game_settings.search_friends_only)
    l_6_0._refresh_server_t = Application:time() + l_6_0._REFRESH_SERVERS_TIME
    do return end
    if l_6_0._refresh_server_t < Application:time() then
      l_6_0._refresh_server_t = Application:time() + l_6_0._REFRESH_SERVERS_TIME
    end
  end
end

CrimeNetManager.start_no_servers = function(l_7_0)
  l_7_0:start(true)
end

CrimeNetManager.start = function(l_8_0, l_8_1)
  l_8_0:_setup()
  l_8_0._active_jobs = {}
  l_8_0._active = true
  l_8_0._active_server_jobs = {}
  l_8_0._refresh_server_t = 0
  l_8_0._skip_servers = l_8_1
  if #l_8_0._active_jobs == 0 then
    l_8_0._next_job_timer = 1
  end
end

CrimeNetManager.stop = function(l_9_0)
  l_9_0._active = false
  for _,data in pairs(l_9_0._active_jobs) do
    data.added = false
  end
end

CrimeNetManager.deactivate = function(l_10_0)
  l_10_0._active = false
end

CrimeNetManager.activate = function(l_11_0)
  l_11_0._active = true
  l_11_0._refresh_server_t = 0
end

CrimeNetManager.activate_job = function(l_12_0)
  local i = math.random(#l_12_0._presets)
  repeat
    if i ~= i - 1 then
      if not l_12_0._active_jobs[i] and i ~= 0 then
        l_12_0._active_jobs[i] = {added = false, active_timer = l_12_0._active_job_time + math.random(5)}
        return 
      end
      i = 1 + math.mod(i, #l_12_0._presets)
    else
       -- Warning: missing end command somewhere! Added here
    end
     -- Warning: missing end command somewhere! Added here
  end
end

CrimeNetManager.preset = function(l_13_0, l_13_1)
  return l_13_0._presets[l_13_1]
end

CrimeNetManager.find_online_games = function(l_14_0, l_14_1)
  l_14_0:_find_online_games(l_14_1)
end

CrimeNetManager._crimenet_gui = function(l_15_0)
  return managers.menu_component._crimenet_gui
end

local is_win32 = SystemInfo:platform() == Idstring("WIN32")
local is_ps3 = SystemInfo:platform() == Idstring("PS3")
local is_x360 = SystemInfo:platform() == Idstring("X360")
CrimeNetManager._find_online_games = function(l_16_0, l_16_1)
  if is_win32 then
    l_16_0:_find_online_games_win32(l_16_0, l_16_1)
  elseif is_ps3 then
    l_16_0:_find_online_games_ps3(l_16_0, l_16_1)
  elseif is_x360 then
    l_16_0:_find_online_games_xbox360(l_16_0, l_16_1)
  else
    Application:error("[CrimeNetManager] Unknown gaming platform trying to access Crime.net!")
  end
end

CrimeNetManager._find_online_games_xbox360 = function(l_17_0, l_17_1)
  local f = function(l_1_0)
    local friends = managers.network.friends:get_friends_by_name()
    managers.network.matchmake:search_lobby_done()
    local room_list = l_1_0.room_list
    local attribute_list = l_1_0.attribute_list
    local dead_list = {}
    for id,_ in pairs(self._active_server_jobs) do
      dead_list[id] = true
    end
    for i,room in ipairs(room_list) do
      local name_str = tostring(room.owner_name)
      local attributes_numbers = attribute_list[i].numbers
      if managers.network.matchmake:is_server_ok(friends_only, room.owner_id, attributes_numbers) then
        dead_list[room.room_id] = nil
        local host_name = name_str
        local level_id = tweak_data.levels:get_level_name_from_index(attributes_numbers[1] % 1000)
        if level_id and tweak_data.levels[level_id] then
          local name_id = tweak_data.levels[level_id].name_id
        end
        local level_name = name_id and managers.localization:text(name_id) or "LEVEL NAME ERROR"
        local difficulty_id = attributes_numbers[2]
        local difficulty = tweak_data:index_to_difficulty(difficulty_id)
        local job_id = tweak_data.narrative:get_job_name_from_index(math.floor(attributes_numbers[1] / 1000))
        local state_string_id = tweak_data:index_to_server_state(attributes_numbers[4])
        local state_name = state_string_id and managers.localization:text("menu_lobby_server_state_" .. state_string_id) or "UNKNOWN"
        local state = attributes_numbers[4]
        local num_plrs = attributes_numbers[5]
         -- DECOMPILER ERROR: Confused while interpreting a jump as a 'while'

      end
      local is_friend = true
       -- DECOMPILER ERROR: unhandled construct in 'if'

      if name_id and not self._active_server_jobs[room.room_id] and table.size(self._active_jobs) + table.size(self._active_server_jobs) < tweak_data.gui.crime_net.job_vars.total_active_jobs then
        self._active_server_jobs[room.room_id] = {added = false, alive_time = 0}
         -- DECOMPILER ERROR: Confused about usage of registers!

         -- DECOMPILER ERROR: Confused about usage of registers!

         -- DECOMPILER ERROR: Confused about usage of registers!

        managers.menu_component:add_crimenet_server_job({room_id = room.room_id, info = room.info, id = room.room_id, level_id = level_id, difficulty = difficulty, difficulty_id = difficulty_id, num_plrs = num_plrs, host_name = host_name, state_name = state_name, state = state})
        {room_id = room.room_id, info = room.info, id = room.room_id, level_id = level_id, difficulty = difficulty, difficulty_id = difficulty_id, num_plrs = num_plrs, host_name = host_name, state_name = state_name, state = state}.is_friend, {room_id = room.room_id, info = room.info, id = room.room_id, level_id = level_id, difficulty = difficulty, difficulty_id = difficulty_id, num_plrs = num_plrs, host_name = host_name, state_name = state_name, state = state}.job_id, {room_id = room.room_id, info = room.info, id = room.room_id, level_id = level_id, difficulty = difficulty, difficulty_id = difficulty_id, num_plrs = num_plrs, host_name = host_name, state_name = state_name, state = state}.level_name = is_friend, job_id, level_name
        for (for control),i in (for generator) do
           -- DECOMPILER ERROR: Confused about usage of registers!

           -- DECOMPILER ERROR: Confused about usage of registers!

           -- DECOMPILER ERROR: Confused about usage of registers!

          managers.menu_component:update_crimenet_server_job({room_id = room.room_id, info = room.info, id = room.room_id, level_id = level_id, difficulty = difficulty, difficulty_id = difficulty_id, num_plrs = num_plrs, host_name = host_name, state_name = state_name, state = state})
          {room_id = room.room_id, info = room.info, id = room.room_id, level_id = level_id, difficulty = difficulty, difficulty_id = difficulty_id, num_plrs = num_plrs, host_name = host_name, state_name = state_name, state = state}.is_friend, {room_id = room.room_id, info = room.info, id = room.room_id, level_id = level_id, difficulty = difficulty, difficulty_id = difficulty_id, num_plrs = num_plrs, host_name = host_name, state_name = state_name, state = state}.job_id, {room_id = room.room_id, info = room.info, id = room.room_id, level_id = level_id, difficulty = difficulty, difficulty_id = difficulty_id, num_plrs = num_plrs, host_name = host_name, state_name = state_name, state = state}.level_name = is_friend, job_id, level_name
        end
      end
    end
    for id,_ in pairs(dead_list) do
      self._active_server_jobs[id] = nil
      managers.menu_component:remove_crimenet_gui_job(id)
    end
   end
  managers.network.matchmake:register_callback("search_lobby", f)
  managers.network.matchmake:search_lobby(l_17_1)
end

CrimeNetManager._find_online_games_ps3 = function(l_18_0, l_18_1)
  local f = function(l_1_0)
    managers.network.matchmake:search_lobby_done()
    local dead_list = {}
    for id,_ in pairs(self._active_server_jobs) do
      dead_list[id] = true
    end
    local friend_names = managers.network.friends:get_names_friends_list()
    for _,info in ipairs(l_1_0) do
      local room_list = info.room_list
      local attribute_list = info.attribute_list
      for i,room in ipairs(room_list) do
        local name_str = tostring(room.owner_id)
        if room.friend_id then
          local friend_str = tostring(room.friend_id)
        end
        local attributes_numbers = attribute_list[i].numbers
        if managers.network.matchmake:is_server_ok(friends_only, room.owner_id, attributes_numbers) then
          dead_list[name_str] = nil
          local host_name = name_str
          local level_id = tweak_data.levels:get_level_name_from_index(attributes_numbers[1] % 1000)
          if level_id and tweak_data.levels[level_id] then
            local name_id = tweak_data.levels[level_id].name_id
          end
          local level_name = name_id and managers.localization:text(name_id) or "LEVEL NAME ERROR"
          local difficulty_id = attributes_numbers[2]
          local difficulty = tweak_data:index_to_difficulty(difficulty_id)
          local job_id = tweak_data.narrative:get_job_name_from_index(math.floor(attributes_numbers[1] / 1000))
          local state_string_id = tweak_data:index_to_server_state(attributes_numbers[4])
          local state_name = state_string_id and managers.localization:text("menu_lobby_server_state_" .. state_string_id) or "UNKNOWN"
          local state = attributes_numbers[4]
          local num_plrs = attributes_numbers[8]
           -- DECOMPILER ERROR: Confused while interpreting a jump as a 'while'

        end
        local is_friend = true
         -- DECOMPILER ERROR: unhandled construct in 'if'

        if name_id and not self._active_server_jobs[name_str] and table.size(self._active_jobs) + table.size(self._active_server_jobs) < tweak_data.gui.crime_net.job_vars.total_active_jobs then
          self._active_server_jobs[name_str] = {added = false, alive_time = 0}
           -- DECOMPILER ERROR: Confused about usage of registers!

           -- DECOMPILER ERROR: Confused about usage of registers!

           -- DECOMPILER ERROR: Confused about usage of registers!

           -- DECOMPILER ERROR: Confused about usage of registers!

          managers.menu_component:add_crimenet_server_job({room_id = room.room_id, id = name_str, level_id = level_id, difficulty = difficulty, difficulty_id = difficulty_id, num_plrs = num_plrs, host_name = host_name, state_name = state_name})
          {room_id = room.room_id, id = name_str, level_id = level_id, difficulty = difficulty, difficulty_id = difficulty_id, num_plrs = num_plrs, host_name = host_name, state_name = state_name}.is_friend, {room_id = room.room_id, id = name_str, level_id = level_id, difficulty = difficulty, difficulty_id = difficulty_id, num_plrs = num_plrs, host_name = host_name, state_name = state_name}.job_id, {room_id = room.room_id, id = name_str, level_id = level_id, difficulty = difficulty, difficulty_id = difficulty_id, num_plrs = num_plrs, host_name = host_name, state_name = state_name}.level_name, {room_id = room.room_id, id = name_str, level_id = level_id, difficulty = difficulty, difficulty_id = difficulty_id, num_plrs = num_plrs, host_name = host_name, state_name = state_name}.state = is_friend, job_id, level_name, state
          for (for control),i in (for generator) do
             -- DECOMPILER ERROR: Confused about usage of registers!

             -- DECOMPILER ERROR: Confused about usage of registers!

             -- DECOMPILER ERROR: Confused about usage of registers!

             -- DECOMPILER ERROR: Confused about usage of registers!

            managers.menu_component:update_crimenet_server_job({room_id = room.room_id, id = name_str, level_id = level_id, difficulty = difficulty, difficulty_id = difficulty_id, num_plrs = num_plrs, host_name = host_name, state_name = state_name})
            {room_id = room.room_id, id = name_str, level_id = level_id, difficulty = difficulty, difficulty_id = difficulty_id, num_plrs = num_plrs, host_name = host_name, state_name = state_name}.is_friend, {room_id = room.room_id, id = name_str, level_id = level_id, difficulty = difficulty, difficulty_id = difficulty_id, num_plrs = num_plrs, host_name = host_name, state_name = state_name}.job_id, {room_id = room.room_id, id = name_str, level_id = level_id, difficulty = difficulty, difficulty_id = difficulty_id, num_plrs = num_plrs, host_name = host_name, state_name = state_name}.level_name, {room_id = room.room_id, id = name_str, level_id = level_id, difficulty = difficulty, difficulty_id = difficulty_id, num_plrs = num_plrs, host_name = host_name, state_name = state_name}.state = is_friend, job_id, level_name, state
          end
        end
      end
      for id,_ in pairs(dead_list) do
        self._active_server_jobs[id] = nil
        managers.menu_component:remove_crimenet_gui_job(id)
      end
    end
   end
  if #PSN:get_world_list() == 0 then
    return 
  end
  managers.network.matchmake:register_callback("search_lobby", f)
  managers.network.matchmake:start_search_lobbys(l_18_1)
end

CrimeNetManager._find_online_games_win32 = function(l_19_0, l_19_1)
  local f = function(l_1_0)
    managers.network.matchmake:search_lobby_done()
    local room_list = l_1_0.room_list
    local attribute_list = l_1_0.attribute_list
    do
      local dead_list = {}
      for id,_ in pairs(self._active_server_jobs) do
        dead_list[id] = true
      end
      for i,room in ipairs(room_list) do
        local name_str = tostring(room.owner_name)
        local attributes_numbers = attribute_list[i].numbers
        if managers.network.matchmake:is_server_ok(friends_only, room.owner_id, attributes_numbers) then
          dead_list[room.room_id] = nil
          local host_name = name_str
          local level_id = tweak_data.levels:get_level_name_from_index(attributes_numbers[1] % 1000)
          if level_id and tweak_data.levels[level_id] then
            local name_id = tweak_data.levels[level_id].name_id
          end
          local level_name = name_id and managers.localization:text(name_id) or "LEVEL NAME ERROR"
          local difficulty_id = attributes_numbers[2]
          local difficulty = tweak_data:index_to_difficulty(difficulty_id)
          local job_id = tweak_data.narrative:get_job_name_from_index(math.floor(attributes_numbers[1] / 1000))
          local state_string_id = tweak_data:index_to_server_state(attributes_numbers[4])
          local state_name = state_string_id and managers.localization:text("menu_lobby_server_state_" .. state_string_id) or "UNKNOWN"
          local state = attributes_numbers[4]
          local num_plrs = attributes_numbers[5]
          local is_friend = false
          if Steam:logged_on() and Steam:friends() then
            for _,friend in ipairs(Steam:friends()) do
              if friend:id() == room.owner_id then
                is_friend = true
            else
              end
            end
             -- DECOMPILER ERROR: unhandled construct in 'if'

            if name_id and not self._active_server_jobs[room.room_id] and table.size(self._active_jobs) + table.size(self._active_server_jobs) < tweak_data.gui.crime_net.job_vars.total_active_jobs then
              self._active_server_jobs[room.room_id] = {added = false, alive_time = 0}
               -- DECOMPILER ERROR: Confused about usage of registers!

               -- DECOMPILER ERROR: Confused about usage of registers!

               -- DECOMPILER ERROR: Confused about usage of registers!

               -- DECOMPILER ERROR: Confused about usage of registers!

              managers.menu_component:add_crimenet_server_job({room_id = room.room_id, id = room.room_id, level_id = level_id, difficulty = difficulty, difficulty_id = difficulty_id, num_plrs = num_plrs, host_name = host_name, state_name = state_name})
              {room_id = room.room_id, id = room.room_id, level_id = level_id, difficulty = difficulty, difficulty_id = difficulty_id, num_plrs = num_plrs, host_name = host_name, state_name = state_name}.is_friend, {room_id = room.room_id, id = room.room_id, level_id = level_id, difficulty = difficulty, difficulty_id = difficulty_id, num_plrs = num_plrs, host_name = host_name, state_name = state_name}.job_id, {room_id = room.room_id, id = room.room_id, level_id = level_id, difficulty = difficulty, difficulty_id = difficulty_id, num_plrs = num_plrs, host_name = host_name, state_name = state_name}.level_name, {room_id = room.room_id, id = room.room_id, level_id = level_id, difficulty = difficulty, difficulty_id = difficulty_id, num_plrs = num_plrs, host_name = host_name, state_name = state_name}.state = is_friend, job_id, level_name, state
              for (for control),i in (for generator) do
                 -- DECOMPILER ERROR: Confused about usage of registers!

                 -- DECOMPILER ERROR: Confused about usage of registers!

                 -- DECOMPILER ERROR: Confused about usage of registers!

                 -- DECOMPILER ERROR: Confused about usage of registers!

                managers.menu_component:update_crimenet_server_job({room_id = room.room_id, id = room.room_id, level_id = level_id, difficulty = difficulty, difficulty_id = difficulty_id, num_plrs = num_plrs, host_name = host_name, state_name = state_name})
                {room_id = room.room_id, id = room.room_id, level_id = level_id, difficulty = difficulty, difficulty_id = difficulty_id, num_plrs = num_plrs, host_name = host_name, state_name = state_name}.is_friend, {room_id = room.room_id, id = room.room_id, level_id = level_id, difficulty = difficulty, difficulty_id = difficulty_id, num_plrs = num_plrs, host_name = host_name, state_name = state_name}.job_id, {room_id = room.room_id, id = room.room_id, level_id = level_id, difficulty = difficulty, difficulty_id = difficulty_id, num_plrs = num_plrs, host_name = host_name, state_name = state_name}.level_name, {room_id = room.room_id, id = room.room_id, level_id = level_id, difficulty = difficulty, difficulty_id = difficulty_id, num_plrs = num_plrs, host_name = host_name, state_name = state_name}.state = is_friend, job_id, level_name, state
              end
            end
          end
          for id,_ in pairs(dead_list) do
            self._active_server_jobs[id] = nil
            managers.menu_component:remove_crimenet_gui_job(id)
          end
        end
         -- Warning: missing end command somewhere! Added here
      end
       -- Warning: missing end command somewhere! Added here
    end
   end
  managers.network.matchmake:register_callback("search_lobby", f)
  managers.network.matchmake:search_lobby(l_19_1)
  local usrs_f = function(l_2_0, l_2_1)
    print("usrs_f", l_2_0, l_2_1)
    if l_2_0 then
      managers.menu_component:set_crimenet_players_online(l_2_1)
    end
   end
  Steam:sa_handler():concurrent_users_callback(usrs_f)
  Steam:sa_handler():get_concurrent_users()
end

CrimeNetManager.save = function(l_20_0, l_20_1)
  l_20_1.crimenet = l_20_0._global
end

CrimeNetManager.load = function(l_21_0, l_21_1)
  l_21_0._global = l_21_1.crimenet
end

if not CrimeNetGui then
  CrimeNetGui = class()
end
CrimeNetGui.init = function(l_22_0, l_22_1, l_22_2, l_22_3)
  managers.menu_component:test_camera_shutter_tech()
  l_22_0._tweak_data = tweak_data.gui.crime_net
  l_22_0._crimenet_enabled = true
  managers.menu_component:post_event("crime_net_startup")
  managers.menu_component:close_contract_gui()
  local no_servers = l_22_3:parameters().no_servers
  if no_servers then
    managers.crimenet:start_no_servers()
  else
    managers.crimenet:start()
  end
  managers.menu:active_menu().renderer.ws:hide()
  local safe_scaled_size = managers.gui_data:safe_scaled_size()
  l_22_0._ws = l_22_1
  l_22_0._fullscreen_ws = l_22_2
  l_22_0._fullscreen_panel = l_22_0._fullscreen_ws:panel():panel({name = "fullscreen"})
  l_22_0._panel = l_22_0._ws:panel():panel({name = "main"})
  l_22_0._blackborder_workspace = managers.gui_data:create_fullscreen_workspace()
  l_22_0._blackborder_workspace:panel():rect({name = "top_border", layer = 1000, color = Color.black})
  l_22_0._blackborder_workspace:panel():rect({name = "bottom_border", layer = 1000, color = Color.black})
  local top_border = l_22_0._blackborder_workspace:panel():child("top_border")
  local bottom_border = l_22_0._blackborder_workspace:panel():child("bottom_border")
  local border_w = l_22_0._blackborder_workspace:panel():w()
  do
    local border_h = (l_22_0._blackborder_workspace:panel():h() - 720) / 2
    top_border:set_position(0, 0)
    top_border:set_size(border_w, border_h)
    bottom_border:set_position(0, 720 + border_h)
    bottom_border:set_size(border_w, border_h)
  end
  local full_16_9 = managers.gui_data:full_16_9_size(managers.gui_data)
  l_22_0._fullscreen_panel:bitmap({name = "blur_top", texture = "guis/textures/test_blur_df", w = l_22_0._fullscreen_ws:panel():w(), h = full_16_9.convert_y, x = 0, y = 0, render_template = "VertexColorTexturedBlur3D", layer = 26})
  l_22_0._fullscreen_panel:bitmap({name = "blur_right", texture = "guis/textures/test_blur_df", w = full_16_9.convert_x, h = l_22_0._fullscreen_ws:panel():h(), x = l_22_0._fullscreen_ws:panel():w() - full_16_9.convert_x, y = 0, render_template = "VertexColorTexturedBlur3D", layer = 26})
  l_22_0._fullscreen_panel:bitmap({name = "blur_bottom", texture = "guis/textures/test_blur_df", w = l_22_0._fullscreen_ws:panel():w(), h = full_16_9.convert_y, x = 0, y = l_22_0._fullscreen_ws:panel():h() - full_16_9.convert_y, render_template = "VertexColorTexturedBlur3D", layer = 26})
  l_22_0._fullscreen_panel:bitmap({name = "blur_left", texture = "guis/textures/test_blur_df", w = full_16_9.convert_x, h = l_22_0._fullscreen_ws:panel():h(), x = 0, y = 0, render_template = "VertexColorTexturedBlur3D", layer = 26})
  l_22_0._panel:rect({w = l_22_0._panel:w(), h = 2, x = 0, y = 0, layer = 2, color = tweak_data.screen_colors.crimenet_lines, blend_mode = "add"})
  l_22_0._panel:rect({w = l_22_0._panel:w(), h = 2, x = 0, y = 0, layer = 2, color = tweak_data.screen_colors.crimenet_lines, blend_mode = "add"}):set_bottom(l_22_0._panel:h())
  l_22_0._panel:rect({w = 2, h = l_22_0._panel:h(), x = 0, y = 0, layer = 2, color = tweak_data.screen_colors.crimenet_lines, blend_mode = "add"}):set_right(l_22_0._panel:w())
  l_22_0._panel:rect({w = 2, h = l_22_0._panel:h(), x = 0, y = 0, layer = 2, color = tweak_data.screen_colors.crimenet_lines, blend_mode = "add"})
   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

  l_22_0._rasteroverlay, {name = "rasteroverlay", texture = "guis/textures/crimenet_map_rasteroverlay"}.h, {name = "rasteroverlay", texture = "guis/textures/crimenet_map_rasteroverlay"}.w, {name = "rasteroverlay", texture = "guis/textures/crimenet_map_rasteroverlay"}.color, {name = "rasteroverlay", texture = "guis/textures/crimenet_map_rasteroverlay"}.layer, {name = "rasteroverlay", texture = "guis/textures/crimenet_map_rasteroverlay"}.blend_mode, {name = "rasteroverlay", texture = "guis/textures/crimenet_map_rasteroverlay"}.wrap_mode, {name = "rasteroverlay", texture = "guis/textures/crimenet_map_rasteroverlay"}.texture_rect = l_22_0._fullscreen_panel:bitmap({name = "rasteroverlay", texture = "guis/textures/crimenet_map_rasteroverlay"}), l_22_0._fullscreen_panel:h(), l_22_0._fullscreen_panel:w(), Color(1, 1, 1, 1), 3, "mul", "wrap", {0, 0, 32, 256}
  l_22_0._fullscreen_panel:bitmap({name = "vignette", texture = "guis/textures/crimenet_map_vignette", layer = 2, color = Color(1, 1, 1, 1), blend_mode = "mul", w = l_22_0._fullscreen_panel:w(), h = l_22_0._fullscreen_panel:h()})
  local bd_light = l_22_0._fullscreen_panel:bitmap({name = "bd_light", texture = "guis/textures/pd2/menu_backdrop/bd_light", layer = 4})
  bd_light:set_size(l_22_0._fullscreen_panel:size())
  bd_light:set_alpha(0)
  bd_light:set_blend_mode("add")
  local light_flicker_animation = function(l_1_0)
    local alpha = 0
    local acceleration = 0
    local wanted_alpha = math.rand(1) * 0.30000001192093
    do
      local flicker_up = true
      repeat
        wait(0.0089999996125698, self._fixed_dt)
        over(0.045000001788139, function(l_1_0)
        o:set_alpha(math.lerp(alpha, wanted_alpha, l_1_0))
         end, self._fixed_dt)
        flicker_up = not flicker_up
        alpha = l_1_0:alpha()
        wanted_alpha = math.rand(flicker_up and alpha or 0.20000000298023, not flicker_up and alpha or 0.30000001192093)
        do return end
      end
       -- Warning: missing end command somewhere! Added here
    end
   end
  bd_light:animate(light_flicker_animation)
   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

  local back_button = l_22_0._panel:text({name = "back_button", text = managers.localization:to_upper_text("menu_back")})
  l_22_0:make_fine_text(back_button)
  {name = "back_button", text = managers.localization:to_upper_text("menu_back")}.blend_mode, {name = "back_button", text = managers.localization:to_upper_text("menu_back")}.layer, {name = "back_button", text = managers.localization:to_upper_text("menu_back")}.color, {name = "back_button", text = managers.localization:to_upper_text("menu_back")}.font, {name = "back_button", text = managers.localization:to_upper_text("menu_back")}.font_size, {name = "back_button", text = managers.localization:to_upper_text("menu_back")}.vertical, {name = "back_button", text = managers.localization:to_upper_text("menu_back")}.align = "add", 40, tweak_data.screen_colors.button_stage_3, tweak_data.menu.pd2_large_font, tweak_data.menu.pd2_large_font_size, "bottom", "right"
  back_button:set_right(l_22_0._panel:w() - 10)
  back_button:set_bottom(l_22_0._panel:h() - 10)
  back_button:set_visible(managers.menu:is_pc_controller())
  local blur_object = l_22_0._panel:bitmap({name = "controller_legend_blur", texture = "guis/textures/test_blur_df", render_template = "VertexColorTexturedBlur3D", layer = back_button:layer() - 1})
  blur_object:set_shape(back_button:shape())
  if not managers.menu:is_pc_controller() then
    blur_object:set_size(l_22_0._panel:w() * 0.5, tweak_data.menu.pd2_medium_font_size)
    blur_object:set_rightbottom(l_22_0._panel:w() - 2, l_22_0._panel:h() - 2)
  end
  WalletGuiObject.set_wallet(l_22_0._panel)
  WalletGuiObject.set_layer(30)
  WalletGuiObject.move_wallet(10, -10)
  local text_id = Global.game_settings.single_player and "menu_crimenet_offline" or "cn_menu_num_players_offline"
  local num_players_text = l_22_0._panel:text({name = "num_players_text", text = managers.localization:to_upper_text(text_id, {amount = "1"}), align = "left", vertical = "top", font_size = tweak_data.menu.pd2_small_font_size, font = tweak_data.menu.pd2_small_font, color = tweak_data.screen_colors.text, layer = 40})
  l_22_0:make_fine_text(num_players_text)
  num_players_text:set_left(10)
  num_players_text:set_top(10)
  do
    local blur_object = l_22_0._panel:bitmap({name = "num_players_blur", texture = "guis/textures/test_blur_df", render_template = "VertexColorTexturedBlur3D", layer = num_players_text:layer() - 1})
    blur_object:set_shape(num_players_text:shape())
  end
  local legends_button = l_22_0._panel:text({name = "legends_button", text = managers.localization:to_upper_text("menu_cn_legend_show", {BTN_X = managers.localization:btn_macro("menu_toggle_legends")}), font_size = tweak_data.menu.pd2_medium_font_size, font = tweak_data.menu.pd2_medium_font, color = tweak_data.screen_colors.text, layer = 40, blend_mode = "add"})
  l_22_0:make_fine_text(legends_button)
  legends_button:set_left(num_players_text:left())
  legends_button:set_top(num_players_text:bottom())
  do
    local blur_object = l_22_0._panel:bitmap({name = "legends_button_blur", texture = "guis/textures/test_blur_df", render_template = "VertexColorTexturedBlur3D", layer = legends_button:layer() - 1})
    blur_object:set_shape(legends_button:shape())
  end
  if managers.menu:is_pc_controller() then
    legends_button:set_color(tweak_data.screen_colors.button_stage_3)
  end
  local w, h = nil, nil
  local mw, mh = 0, nil
  local legend_panel = l_22_0._panel:panel({name = "legend_panel", layer = 40, visible = false, x = 10, y = legends_button:bottom() + 4})
  local host_icon = legend_panel:bitmap({texture = "guis/textures/pd2/crimenet_legend_host", x = 10, y = 10})
  local host_text = legend_panel:text({font = tweak_data.menu.pd2_small_font, font_size = tweak_data.menu.pd2_small_font_size, x = host_icon:right() + 2, y = host_icon:top(), text = managers.localization:to_upper_text("menu_cn_legend_host"), blend_mode = "add"})
  mw = math.max(mw, l_22_0:make_fine_text(host_text))
  local join_icon = legend_panel:bitmap({texture = "guis/textures/pd2/crimenet_legend_join", x = 10, y = host_text:bottom()})
  local join_text = legend_panel:text({font = tweak_data.menu.pd2_small_font, font_size = tweak_data.menu.pd2_small_font_size, x = host_text:left(), y = join_icon:top(), text = managers.localization:to_upper_text("menu_cn_legend_join"), blend_mode = "add"})
  mw = math.max(mw, l_22_0:make_fine_text(join_text))
  l_22_0:make_color_text(join_text, tweak_data.screen_colors.regular_color)
  local friends_text = legend_panel:text({font = tweak_data.menu.pd2_small_font, font_size = tweak_data.menu.pd2_small_font_size, x = host_text:left(), y = join_text:bottom(), text = managers.localization:to_upper_text("menu_cn_legend_friends"), blend_mode = "add"})
  mw = math.max(mw, l_22_0:make_fine_text(friends_text))
  l_22_0:make_color_text(friends_text, tweak_data.screen_colors.friend_color)
  local pc_icon = legend_panel:bitmap({texture = "guis/textures/pd2/crimenet_legend_payclass", x = 10, y = friends_text:bottom()})
  local pc_text = legend_panel:text({font = tweak_data.menu.pd2_small_font, font_size = tweak_data.menu.pd2_small_font_size, x = host_text:left(), y = pc_icon:top(), text = managers.localization:to_upper_text("menu_cn_legend_pc"), color = tweak_data.screen_colors.text, blend_mode = "add"})
  mw = math.max(mw, l_22_0:make_fine_text(pc_text))
  local risk_icon = legend_panel:bitmap({texture = "guis/textures/pd2/crimenet_legend_risklevel", x = 10, y = pc_text:bottom()})
  local risk_text = legend_panel:text({font = tweak_data.menu.pd2_small_font, font_size = tweak_data.menu.pd2_small_font_size, x = host_text:left(), y = risk_icon:top(), text = managers.localization:to_upper_text("menu_cn_legend_risk"), color = tweak_data.screen_colors.risk, blend_mode = "add"})
  mw = math.max(mw, l_22_0:make_fine_text(risk_text))
  do
    local pro_text = legend_panel:text({font = tweak_data.menu.pd2_small_font, font_size = tweak_data.menu.pd2_small_font_size, x = host_text:left(), y = risk_text:bottom(), text = managers.localization:to_upper_text("menu_cn_legend_pro"), color = tweak_data.screen_colors.pro_color, blend_mode = "add"})
    mw = math.max(mw, l_22_0:make_fine_text(pro_text))
    legend_panel:set_size(host_text:left() + mw + 10, pro_text:bottom() + 10)
    legend_panel:rect({color = Color.black, alpha = 0.40000000596046, layer = -1})
    BoxGuiObject:new(legend_panel, {sides = {1, 1, 1, 1}})
    legend_panel:bitmap({texture = "guis/textures/test_blur_df", w = legend_panel:w(), h = legend_panel:h(), render_template = "VertexColorTexturedBlur3D", layer = -1})
  end
  if not is_x360 or not "menu_cn_friends" then
    local id = no_servers or "menu_cn_filter"
  end
  local filter_button = l_22_0._panel:text({name = "filter_button", text = managers.localization:to_upper_text(id, {BTN_Y = managers.localization:btn_macro("menu_toggle_filters")}), font_size = tweak_data.menu.pd2_medium_font_size, font = tweak_data.menu.pd2_medium_font, color = tweak_data.screen_colors.text, layer = 40, blend_mode = "add"})
  l_22_0:make_fine_text(filter_button)
  filter_button:set_right(l_22_0._panel:w() - 10)
  filter_button:set_top(10)
  do
    local blur_object = l_22_0._panel:bitmap({name = "filter_button_blur", texture = "guis/textures/test_blur_df", render_template = "VertexColorTexturedBlur3D", layer = filter_button:layer() - 1})
    blur_object:set_shape(filter_button:shape())
  end
  if managers.menu:is_pc_controller() then
    filter_button:set_color(tweak_data.screen_colors.button_stage_3)
  end
  if is_ps3 then
    local invites_button = l_22_0._panel:text({name = "invites_button", text = managers.localization:get_default_macro("BTN_BACK") .. " " .. managers.localization:to_upper_text("menu_view_invites"), font_size = tweak_data.menu.pd2_medium_font_size, font = tweak_data.menu.pd2_medium_font, color = tweak_data.screen_colors.text, layer = 40, blend_mode = "add"})
    l_22_0:make_fine_text(invites_button)
    invites_button:set_right(filter_button:right())
    invites_button:set_top(filter_button:bottom())
    do
      local blur_object = l_22_0._panel:bitmap({name = "invites_button_blur", texture = "guis/textures/test_blur_df", render_template = "VertexColorTexturedBlur3D", layer = filter_button:layer() - 1})
      blur_object:set_shape(invites_button:shape())
    end
    if not l_22_0._ps3_invites_controller then
      local invites_cb = callback(l_22_0, l_22_0, "ps3_invites_callback")
      l_22_0._ps3_invites_controller = managers.controller:create_controller("ps3_invites_controller", managers.controller:get_default_wrapper_index(), false)
      l_22_0._ps3_invites_controller:add_trigger("back", invites_cb)
    end
    l_22_0._ps3_invites_controller:set_enabled(true)
  end
  l_22_0._map_size_w = 2048
  l_22_0._map_size_h = 1024
  local aspect = 1.7777777910233
  local sw = math.min(l_22_0._map_size_w, l_22_0._map_size_h * aspect)
  local sh = math.min(l_22_0._map_size_h, l_22_0._map_size_w / aspect)
  local dw = l_22_0._map_size_w / sw
  local dh = l_22_0._map_size_h / sh
  l_22_0._map_size_w = dw * 1280
  l_22_0._map_size_h = dh * 720
  local pw, ph = l_22_0._map_size_w, l_22_0._map_size_h
  l_22_0._pan_panel_border = 2.777777671814
  l_22_0._pan_panel_job_border_x = full_16_9.convert_x + l_22_0._pan_panel_border * 2
  l_22_0._pan_panel_job_border_y = full_16_9.convert_y + l_22_0._pan_panel_border * 2
  l_22_0._pan_panel = l_22_0._panel:panel({name = "pan", w = pw, h = ph, layer = 0})
  l_22_0._pan_panel:set_center(l_22_0._fullscreen_panel:w() / 2, l_22_0._fullscreen_panel:h() / 2)
  l_22_0._jobs = {}
  l_22_0._map_panel = l_22_0._fullscreen_panel:panel({name = "map", w = pw, h = ph})
  l_22_0._map_panel:bitmap({name = "map", texture = "guis/textures/crimenet_map", layer = 0, w = pw, h = ph})
  l_22_0._map_panel:child("map"):set_halign("scale")
  l_22_0._map_panel:child("map"):set_valign("scale")
  l_22_0._map_panel:set_shape(l_22_0._pan_panel:shape())
  l_22_0._map_x, l_22_0._map_y = l_22_0._map_panel:position(), l_22_0._map_panel
  if not managers.menu:is_pc_controller() then
    managers.mouse_pointer:confine_mouse_pointer(l_22_0._panel)
    managers.menu:active_menu().input:activate_controller_mouse()
    managers.mouse_pointer:set_mouse_world_position(managers.gui_data:safe_to_full(l_22_0._panel:world_center()))
  end
  l_22_0.MIN_ZOOM = 1
  l_22_0.MAX_ZOOM = 9
  l_22_0._zoom = 1
   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

  local cross_indicator_h1 = l_22_0._fullscreen_panel:bitmap({name = "cross_indicator_h1", texture = "guis/textures/pd2/skilltree/dottedline"})
   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

  local cross_indicator_h2 = l_22_0._fullscreen_panel:bitmap({name = "cross_indicator_h2", texture = "guis/textures/pd2/skilltree/dottedline"})
   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

  local cross_indicator_v1 = l_22_0._fullscreen_panel:bitmap({name = "cross_indicator_v1", texture = "guis/textures/pd2/skilltree/dottedline"})
   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

  local cross_indicator_v2 = l_22_0._fullscreen_panel:bitmap({name = "cross_indicator_v2", texture = "guis/textures/pd2/skilltree/dottedline"})
  local line_indicator_h1 = l_22_0._fullscreen_panel:rect({name = "line_indicator_h1", w = 0, h = 2, blend_mode = "add", layer = 17, color = tweak_data.screen_colors.crimenet_lines, alpha = 0.10000000149012})
  local line_indicator_h2 = l_22_0._fullscreen_panel:rect({name = "line_indicator_h2", w = 0, h = 2, blend_mode = "add", layer = 17, color = tweak_data.screen_colors.crimenet_lines, alpha = 0.10000000149012})
  local line_indicator_v1 = l_22_0._fullscreen_panel:rect({name = "line_indicator_v1", h = 0, w = 2, blend_mode = "add", layer = 17, color = tweak_data.screen_colors.crimenet_lines, alpha = 0.10000000149012})
  local line_indicator_v2 = l_22_0._fullscreen_panel:rect({name = "line_indicator_v2", h = 0, w = 2, blend_mode = "add", layer = 17, color = tweak_data.screen_colors.crimenet_lines, alpha = 0.10000000149012})
  local fw = l_22_0._fullscreen_panel:w()
  local fh = l_22_0._fullscreen_panel:h()
  cross_indicator_h1:set_texture_coordinates(Vector3(0, 0, 0), Vector3(fw, 0, 0), Vector3(0, 2, 0), Vector3(fw, 2, 0))
  {name = "cross_indicator_v2", texture = "guis/textures/pd2/skilltree/dottedline"}.wrap_mode, {name = "cross_indicator_v2", texture = "guis/textures/pd2/skilltree/dottedline"}.alpha, {name = "cross_indicator_v2", texture = "guis/textures/pd2/skilltree/dottedline"}.color, {name = "cross_indicator_v2", texture = "guis/textures/pd2/skilltree/dottedline"}.layer, {name = "cross_indicator_v2", texture = "guis/textures/pd2/skilltree/dottedline"}.blend_mode, {name = "cross_indicator_v2", texture = "guis/textures/pd2/skilltree/dottedline"}.w, {name = "cross_indicator_v2", texture = "guis/textures/pd2/skilltree/dottedline"}.h, {name = "cross_indicator_v1", texture = "guis/textures/pd2/skilltree/dottedline"}.wrap_mode, {name = "cross_indicator_v1", texture = "guis/textures/pd2/skilltree/dottedline"}.alpha, {name = "cross_indicator_v1", texture = "guis/textures/pd2/skilltree/dottedline"}.color, {name = "cross_indicator_v1", texture = "guis/textures/pd2/skilltree/dottedline"}.layer, {name = "cross_indicator_v1", texture = "guis/textures/pd2/skilltree/dottedline"}.blend_mode, {name = "cross_indicator_v1", texture = "guis/textures/pd2/skilltree/dottedline"}.w, {name = "cross_indicator_v1", texture = "guis/textures/pd2/skilltree/dottedline"}.h, {name = "cross_indicator_h2", texture = "guis/textures/pd2/skilltree/dottedline"}.wrap_mode, {name = "cross_indicator_h2", texture = "guis/textures/pd2/skilltree/dottedline"}.alpha, {name = "cross_indicator_h2", texture = "guis/textures/pd2/skilltree/dottedline"}.color, {name = "cross_indicator_h2", texture = "guis/textures/pd2/skilltree/dottedline"}.layer, {name = "cross_indicator_h2", texture = "guis/textures/pd2/skilltree/dottedline"}.blend_mode, {name = "cross_indicator_h2", texture = "guis/textures/pd2/skilltree/dottedline"}.h, {name = "cross_indicator_h2", texture = "guis/textures/pd2/skilltree/dottedline"}.w, {name = "cross_indicator_h1", texture = "guis/textures/pd2/skilltree/dottedline"}.wrap_mode, {name = "cross_indicator_h1", texture = "guis/textures/pd2/skilltree/dottedline"}.alpha, {name = "cross_indicator_h1", texture = "guis/textures/pd2/skilltree/dottedline"}.color, {name = "cross_indicator_h1", texture = "guis/textures/pd2/skilltree/dottedline"}.layer, {name = "cross_indicator_h1", texture = "guis/textures/pd2/skilltree/dottedline"}.blend_mode, {name = "cross_indicator_h1", texture = "guis/textures/pd2/skilltree/dottedline"}.h, {name = "cross_indicator_h1", texture = "guis/textures/pd2/skilltree/dottedline"}.w = "wrap", 0.10000000149012, tweak_data.screen_colors.crimenet_lines, 17, "add", 2, l_22_0._fullscreen_panel:h(), "wrap", 0.10000000149012, tweak_data.screen_colors.crimenet_lines, 17, "add", 2, l_22_0._fullscreen_panel:h(), "wrap", 0.10000000149012, tweak_data.screen_colors.crimenet_lines, 17, "add", 2, l_22_0._fullscreen_panel:w(), "wrap", 0.10000000149012, tweak_data.screen_colors.crimenet_lines, 17, "add", 2, l_22_0._fullscreen_panel:w()
  cross_indicator_h2:set_texture_coordinates(Vector3(0, 0, 0), Vector3(fw, 0, 0), Vector3(0, 2, 0), Vector3(fw, 2, 0))
  cross_indicator_v1:set_texture_coordinates(Vector3(0, 2, 0), Vector3(0, 0, 0), Vector3(fh, 2, 0), Vector3(fh, 0, 0))
  cross_indicator_v2:set_texture_coordinates(Vector3(0, 2, 0), Vector3(0, 0, 0), Vector3(fh, 2, 0), Vector3(fh, 0, 0))
  l_22_0:_create_locations()
  l_22_0._num_layer_jobs = 0
  local player_level = managers.experience:current_level()
  local positions_tweak_data = tweak_data.gui.crime_net.map_start_positions
  local start_position = nil
  for _,position in ipairs(positions_tweak_data) do
    if player_level <= position.max_level then
      start_position = position
  else
    end
  end
  if start_position then
    l_22_0:_set_zoom("in", fw * 0.5, fh * 0.5)
    l_22_0:_set_zoom("in", fw * 0.5, fh * 0.5)
    l_22_0:_set_zoom("in", fw * 0.5, fh * 0.5)
    l_22_0:_goto_map_position(start_position.x, start_position.y)
  end
  return 
end

CrimeNetGui.make_fine_text = function(l_23_0, l_23_1)
  local x, y, w, h = l_23_1:text_rect()
  l_23_1:set_size(w, h)
  l_23_1:set_position(math.round(l_23_1:x()), math.round(l_23_1:y()))
  return w, h
end

CrimeNetGui.make_color_text = function(l_24_0, l_24_1, l_24_2)
  local text = l_24_1:text()
  local text_dissected = utf8.characters(text)
  local idsp = Idstring("#")
  local start_ci = {}
  local end_ci = {}
  local first_ci = true
  for i,c in ipairs(text_dissected) do
    if Idstring(c) == idsp then
      local next_c = text_dissected[i + 1]
      if next_c and Idstring(next_c) == idsp then
        if first_ci then
          table.insert(start_ci, i)
        else
          table.insert(end_ci, i)
          first_ci = not first_ci
        end
      end
    end
    if #start_ci ~= #end_ci then
      do return end
    end
    for i = 1, #start_ci do
      start_ci[i] = start_ci[i] - ((i - 1) * 4 + 1)
      end_ci[i] = end_ci[i] - (i * 4 - 1)
    end
    text = string.gsub(text, "##", "")
    l_24_1:set_text(text)
    l_24_1:clear_range_color(1, utf8.len(text))
    if #start_ci ~= #end_ci then
      Application:error("CrimeNetGui:make_color_text: Not even amount of ##'s in text", #start_ci, #end_ci)
    else
      for i = 1, #start_ci do
        if not l_24_2 then
          l_24_1:set_range_color(start_ci[i], end_ci[i], tweak_data.screen_colors.resource)
        end
      end
    end
     -- Warning: missing end command somewhere! Added here
  end
end

CrimeNetGui._create_polylines = function(l_25_0)
  local regions = tweak_data.gui.crime_net.regions
  if alive(l_25_0._region_panel) then
    l_25_0._map_panel:remove(l_25_0._region_panel)
    l_25_0._region_panel = nil
  end
  l_25_0._region_panel = l_25_0._map_panel:panel({halign = "scale", valign = "scale"})
  l_25_0._region_locations = {}
  local xs, ys, num, vectors, my_polyline = nil, nil, nil, nil, nil
  local tw = math.max(l_25_0._map_panel:child("map"):texture_width(), 1)
  local th = (math.max(l_25_0._map_panel:child("map"):texture_height(), 1))
  local region_text_data, region_text, x, y = nil, nil, nil, nil
  for _,region in ipairs(regions) do
    xs = region[1]
    ys = region[2]
    num = math.min(#xs, #ys)
    vectors = {}
    my_polyline = l_25_0._region_panel:polyline({line_width = 2, alpha = 0.60000002384186, layer = 1, closed = region.closed, blend_mode = "add", halign = "scale", valign = "scale", color = tweak_data.screen_colors.crimenet_lines})
    for i = 1, num do
      table.insert(vectors, Vector3(xs[i] / tw * l_25_0._map_size_w * l_25_0._zoom, ys[i] / th * l_25_0._map_size_h * l_25_0._zoom, 0))
    end
    my_polyline:set_points(vectors)
    vectors = {}
    my_polyline = l_25_0._region_panel:polyline({line_width = 5, alpha = 0.20000000298023, layer = 1, closed = region.closed, blend_mode = "add", halign = "scale", valign = "scale", color = tweak_data.screen_colors.crimenet_lines})
    for i = 1, num do
      table.insert(vectors, Vector3(xs[i] / tw * l_25_0._map_size_w * l_25_0._zoom, ys[i] / th * l_25_0._map_size_h * l_25_0._zoom, 0))
    end
    my_polyline:set_points(vectors)
    region_text_data = region.text
    if region_text_data then
      x = region_text_data.x / tw * l_25_0._map_size_w * l_25_0._zoom
      y = region_text_data.y / th * l_25_0._map_size_h * l_25_0._zoom
       -- DECOMPILER ERROR: Confused about usage of registers!

       -- DECOMPILER ERROR: Confused about usage of registers!

       -- DECOMPILER ERROR: Confused about usage of registers!

       -- DECOMPILER ERROR: Confused about usage of registers!

       -- DECOMPILER ERROR: Confused about usage of registers!

       -- DECOMPILER ERROR: Confused about usage of registers!

       -- DECOMPILER ERROR: Confused about usage of registers!

      if region_text_data.title_id then
        region_text, {font = tweak_data.menu.pd2_large_font, font_size = tweak_data.menu.pd2_large_font_size}.rotation, {font = tweak_data.menu.pd2_large_font, font_size = tweak_data.menu.pd2_large_font_size}.valign, {font = tweak_data.menu.pd2_large_font, font_size = tweak_data.menu.pd2_large_font_size}.halign, {font = tweak_data.menu.pd2_large_font, font_size = tweak_data.menu.pd2_large_font_size}.blend_mode, {font = tweak_data.menu.pd2_large_font, font_size = tweak_data.menu.pd2_large_font_size}.alpha, {font = tweak_data.menu.pd2_large_font, font_size = tweak_data.menu.pd2_large_font_size}.layer, {font = tweak_data.menu.pd2_large_font, font_size = tweak_data.menu.pd2_large_font_size}.text = l_25_0._region_panel:text({font = tweak_data.menu.pd2_large_font, font_size = tweak_data.menu.pd2_large_font_size}), 0, "scale", "scale", "add", 0.60000002384186, 1, managers.localization:to_upper_text(region_text_data.title_id)
        local _, _, w, h = region_text:text_rect()
        region_text:set_size(w, h)
        region_text:set_center(x, y)
        table.insert(l_25_0._region_locations, {object = region_text, size = region_text:font_size()})
      end
       -- DECOMPILER ERROR: Confused about usage of registers!

       -- DECOMPILER ERROR: Confused about usage of registers!

       -- DECOMPILER ERROR: Confused about usage of registers!

       -- DECOMPILER ERROR: Confused about usage of registers!

       -- DECOMPILER ERROR: Confused about usage of registers!

      if region_text_data.sub_id then
        region_text, {font = tweak_data.menu.pd2_small_font, font_size = tweak_data.menu.pd2_small_font_size, text = managers.localization:to_upper_text(region_text_data.sub_id), align = "center", vertical = "center", layer = 1}.rotation, {font = tweak_data.menu.pd2_small_font, font_size = tweak_data.menu.pd2_small_font_size, text = managers.localization:to_upper_text(region_text_data.sub_id), align = "center", vertical = "center", layer = 1}.valign, {font = tweak_data.menu.pd2_small_font, font_size = tweak_data.menu.pd2_small_font_size, text = managers.localization:to_upper_text(region_text_data.sub_id), align = "center", vertical = "center", layer = 1}.halign, {font = tweak_data.menu.pd2_small_font, font_size = tweak_data.menu.pd2_small_font_size, text = managers.localization:to_upper_text(region_text_data.sub_id), align = "center", vertical = "center", layer = 1}.blend_mode, {font = tweak_data.menu.pd2_small_font, font_size = tweak_data.menu.pd2_small_font_size, text = managers.localization:to_upper_text(region_text_data.sub_id), align = "center", vertical = "center", layer = 1}.alpha = l_25_0._region_panel:text({font = tweak_data.menu.pd2_small_font, font_size = tweak_data.menu.pd2_small_font_size, text = managers.localization:to_upper_text(region_text_data.sub_id), align = "center", vertical = "center", layer = 1}), 0, "scale", "scale", "add", 0.60000002384186
        local _, _, w, h = region_text:text_rect()
        region_text:set_size(w, h)
        if region_text_data.title_id then
          region_text:set_position(l_25_0._region_locations[#l_25_0._region_locations].object:left(), l_25_0._region_locations[#l_25_0._region_locations].object:bottom() - 5)
        else
          region_text:set_center(x, y)
        end
        table.insert(l_25_0._region_locations, {object = region_text, size = region_text:font_size()})
      end
    end
  end
  if Application:production_build() and tweak_data.gui.crime_net.debug_options.regions then
    for _,data in ipairs(tweak_data.gui.crime_net.locations) do
      local location = data[1]
      if location and location.dots then
        for _,dot in ipairs(location.dots) do
          l_25_0._region_panel:rect({w = 1, h = 1, color = Color.red, x = dot[1] / tw * l_25_0._map_size_w * l_25_0._zoom, y = dot[2] / th * l_25_0._map_size_h * l_25_0._zoom, halign = "scale", valign = "scale", layer = 1000})
        end
      end
    end
  end
end

CrimeNetGui.set_players_online = function(l_26_0, l_26_1)
  local players_string = managers.money:add_decimal_marks_to_string(string.format("%.3d", l_26_1))
  local num_players_text = l_26_0._panel:child("num_players_text")
  num_players_text:set_text(managers.localization:to_upper_text("cn_menu_num_players_online", {amount = players_string}))
  l_26_0:make_fine_text(num_players_text)
  l_26_0._panel:child("num_players_blur"):set_shape(num_players_text:shape())
end

CrimeNetGui._create_locations = function(l_27_0)
  if not deep_clone(l_27_0._tweak_data.locations) then
    l_27_0._locations = {}
  end
  l_27_0:_create_polylines()
end

CrimeNetGui._add_location = function(l_28_0, l_28_1, l_28_2)
  return 
  if not l_28_0._locations[l_28_1] then
    l_28_0._locations[l_28_1] = {}
  end
  table.insert(l_28_0._locations[l_28_1], l_28_2)
end

CrimeNetGui._get_contact_locations = function(l_29_0)
  return l_29_0._locations[1]
end

CrimeNetGui._get_random_location = function(l_30_0)
  return l_30_0._pan_panel_job_border_x + math.random(l_30_0._map_size_w - 2 * l_30_0._pan_panel_job_border_x), l_30_0._pan_panel_job_border_y + math.random(l_30_0._map_size_h - 2 * l_30_0._pan_panel_job_border_y)
end

CrimeNetGui._get_job_location = function(l_31_0, l_31_1)
  do
    local locations = l_31_0:_get_contact_locations()
    if locations and #locations > 0 then
      local found_point = false
      local x, y, randomized_location = nil, nil, nil
      local break_limit = 100
      local dots = locations[1].dots
      local randomized_dot = math.random(#dots)
      local choosen_dot = randomized_dot
      randomized_location = dots[choosen_dot]
      repeat
        repeat
          if randomized_location[3] then
            choosen_dot = choosen_dot % #dots + 1
            randomized_location = dots[choosen_dot]
          until choosen_dot == randomized_dot
          Application:error("[CrimeNetGui:_get_job_location] All spawning points are taken!")
          return l_31_0:_get_random_location()
        else
          x = randomized_location[1]
          y = randomized_location[2]
          if x and y then
            local tw = math.max(l_31_0._map_panel:child("map"):texture_width(), 1)
            local th = math.max(l_31_0._map_panel:child("map"):texture_height(), 1)
            x = math.round(x / tw * l_31_0._map_size_w)
            y = math.round(y / th * l_31_0._map_size_h)
            return x, y, randomized_location
          end
        end
        return l_31_0:_get_random_location()
      end
       -- Warning: missing end command somewhere! Added here
    end
     -- Warning: missing end command somewhere! Added here
  end
end

CrimeNetGui.add_preset_job = function(l_32_0, l_32_1)
  l_32_0:remove_job(l_32_1)
  local preset = managers.crimenet:preset(l_32_1)
  local gui_data = l_32_0:_create_job_gui(preset, "preset")
  gui_data.preset_id = l_32_1
  l_32_0._jobs[l_32_1] = gui_data
end

CrimeNetGui.add_server_job = function(l_33_0, l_33_1)
  local gui_data = l_33_0:_create_job_gui(l_33_1, "server")
  gui_data.server = true
  gui_data.host_name = l_33_1.host_name
  l_33_0._jobs[l_33_1.id] = gui_data
end

CrimeNetGui._create_job_gui = function(l_34_0, l_34_1, l_34_2, l_34_3, l_34_4, l_34_5)
  local level_id = l_34_1.level_id
  local level_data = tweak_data.levels[level_id]
  if l_34_1.job_id then
    local narrative_data = tweak_data.narrative.jobs[l_34_1.job_id]
  end
  local is_server = l_34_2 == "server"
  if narrative_data then
    local is_professional = narrative_data.professional
  end
   -- DECOMPILER ERROR: Confused while interpreting a jump as a 'while'

end
local got_job = true
local x = l_34_3
local y = l_34_4
local location = l_34_5
if not x and not y then
  x, y, location = l_34_0:_get_job_location(l_34_1)
end
local color = Color.white
local friend_color = tweak_data.screen_colors.friend_color
local regular_color = tweak_data.screen_colors.regular_color
local pro_color = tweak_data.screen_colors.pro_color
local side_panel = l_34_0._pan_panel:panel({layer = 26, alpha = 0})
local stars_panel = side_panel:panel({name = "stars_panel", layer = -1, visible = true, w = 100})
local num_stars = 0
local star_size = 8
local job_num = 0
local job_cash = 0
local difficulty_name = side_panel:text({name = "difficulty_name", text = "", vertical = "center", font = tweak_data.menu.pd2_small_font, font_size = tweak_data.menu.pd2_small_font_size, color = color, blend_mode = "add", layer = 0})
if l_34_1.job_id then
  local x = 0
  local y = 0
  local job_stars = math.ceil(tweak_data.narrative.jobs[l_34_1.job_id].jc / 10)
  local difficulty_stars = l_34_1.difficulty_id - 2
  local job_and_difficulty_stars = job_stars + difficulty_stars
  for i = 1, 10 do
    stars_panel:bitmap({texture = "guis/textures/pd2/crimenet_paygrade_marker", x = x, y = y, blend_mode = "normal", layer = 0, color = (job_stars + difficulty_stars < i and Color.black) or (job_stars < i and tweak_data.screen_colors.risk) or color})
    x = x + star_size
    num_stars = num_stars + 1
  end
  local money_multiplier = managers.money:get_contract_difficulty_multiplier(difficulty_stars)
  local money_stage_stars = managers.money:get_stage_payout_by_stars(job_stars)
  local money_job_stars = managers.money:get_job_payout_by_stars(job_stars)
  local plvl = managers.experience:current_level()
  local player_stars = math.max(math.ceil(plvl / 10), 1)
  local money_manager = tweak_data.money_manager.level_limit
  if player_stars <= job_and_difficulty_stars + tweak_data:get_value("money_manager", "level_limit", "low_cap_level") then
    local diff_stars = math.clamp(job_and_difficulty_stars - player_stars, 1, #money_manager.pc_difference_multipliers)
    local level_limit_mul = tweak_data:get_value("money_manager", "level_limit", "pc_difference_multipliers", diff_stars)
    local plr_difficulty_stars = math.max(difficulty_stars - diff_stars, 0)
    local plr_money_multiplier = managers.money:get_contract_difficulty_multiplier(plr_difficulty_stars) or 0
    local white_player_stars = player_stars - plr_difficulty_stars
    local cash_plr_stage_stars = managers.money:get_stage_payout_by_stars(white_player_stars, true)
    cash_plr_stage_stars = cash_plr_stage_stars + cash_plr_stage_stars * plr_money_multiplier
    local cash_stage = money_stage_stars + money_stage_stars * money_multiplier
    local diff_stage = cash_stage - (cash_plr_stage_stars)
    local new_cash_stage = cash_plr_stage_stars + diff_stage * level_limit_mul
    money_stage_stars = money_stage_stars * (new_cash_stage / cash_stage)
    local cash_plr_job_stars = managers.money:get_job_payout_by_stars(white_player_stars, true)
    cash_plr_job_stars = cash_plr_job_stars + cash_plr_job_stars * plr_money_multiplier
    local cash_job = money_job_stars + money_job_stars * money_multiplier
    local diff_job = cash_job - (cash_plr_job_stars)
    local new_cash_job = cash_plr_job_stars + diff_job * level_limit_mul
    money_job_stars = money_job_stars * (new_cash_job / cash_job)
  end
  job_num = #tweak_data.narrative.jobs[l_34_1.job_id].chain
  job_cash = managers.experience:cash_string(math.round(money_job_stars + tweak_data:get_value("money_manager", "flat_job_completion") + money_job_stars * money_multiplier + (money_stage_stars + tweak_data:get_value("money_manager", "flat_stage_completion") + money_stage_stars * money_multiplier) * #tweak_data.narrative.jobs[l_34_1.job_id].chain))
  local difficulty_string = managers.localization:to_upper_text(tweak_data.difficulty_name_ids[tweak_data.difficulties[l_34_1.difficulty_id]])
  difficulty_name:set_text(difficulty_string)
  if difficulty_stars <= 0 or not tweak_data.screen_colors.risk then
    difficulty_name:set_color(tweak_data.screen_colors.text)
  end
end
local host_string = l_34_1.host_name or (is_professional and managers.localization:to_upper_text("cn_menu_pro_job")) or " "
local job_string = (l_34_1.job_id and managers.localization:to_upper_text(tweak_data.narrative.jobs[l_34_1.job_id].name_id)) or l_34_1.level_name or "NO JOB"
local contact_string = l_34_1.job_id and utf8.to_upper(managers.localization:text(tweak_data.narrative.contacts[tweak_data.narrative.jobs[l_34_1.job_id].contact].name_id)) or "BAIN"
contact_string = contact_string .. ": "
local info_string = managers.localization:to_upper_text("cn_menu_contract_short_" .. (job_num > 1 and "plural" or "singular"), {days = job_num, money = job_cash})
info_string = info_string .. (l_34_1.state_name and " / " .. l_34_1.state_name or "")
local host_name = side_panel:text({name = "host_name", text = host_string, vertical = "center", font = tweak_data.menu.pd2_small_font, font_size = tweak_data.menu.pd2_small_font_size, color = (l_34_1.is_friend and friend_color) or (is_server and regular_color) or pro_color, blend_mode = "add", layer = 0})
local job_name = side_panel:text({name = "job_name", text = job_string, vertical = "center", font = tweak_data.menu.pd2_small_font, font_size = tweak_data.menu.pd2_small_font_size, color = color, blend_mode = "add", layer = 0})
local contact_name = side_panel:text({name = "contact_name", text = contact_string, vertical = "center", font = tweak_data.menu.pd2_small_font, font_size = tweak_data.menu.pd2_small_font_size, color = color, blend_mode = "add", layer = 0})
local info_name = side_panel:text({name = "info_name", text = info_string, vertical = "center", font = tweak_data.menu.pd2_small_font, font_size = tweak_data.menu.pd2_small_font_size, color = color, blend_mode = "add", layer = 0})
stars_panel:set_w(star_size * math.min(10, #stars_panel:children()))
stars_panel:set_h(star_size)
local focus = l_34_0._pan_panel:bitmap({name = "focus", texture = "guis/textures/crimenet_map_circle", layer = 10, color = color:with_alpha(0.60000002384186), blend_mode = "add"})
do
  local _, _, w, h = host_name:text_rect()
  host_name:set_size(w, h)
  host_name:set_position(0, 0)
do
  end
  if not is_server then
    local _, _, w, h = job_name:text_rect()
    job_name:set_size(w, h)
    job_name:set_position(0, host_name:bottom())
  do
    end
    local _, _, w, h = contact_name:text_rect()
    contact_name:set_size(w, h)
    contact_name:set_top(job_name:top())
    contact_name:set_right(0)
  do
    end
    local _, _, w, h = info_name:text_rect()
    info_name:set_size(w, h)
    info_name:set_top(contact_name:bottom())
    info_name:set_right(0)
  do
    end
    local _, _, w, h = difficulty_name:text_rect()
    difficulty_name:set_size(w, h)
    difficulty_name:set_top(info_name:bottom())
    difficulty_name:set_right(0)
  end
  if not got_job then
    if not l_34_1.state_name then
      job_name:set_text(managers.localization:to_upper_text("menu_lobby_server_state_in_lobby"))
    end
    local _, _, w, h = job_name:text_rect()
    job_name:set_size(w, h)
    job_name:set_position(0, host_name:bottom())
    contact_name:set_text(" ")
    contact_name:set_w(0, 0)
    contact_name:set_position(0, host_name:bottom())
    info_name:set_text(" ")
    info_name:set_size(0, 0)
    info_name:set_position(0, host_name:bottom())
    difficulty_name:set_text(" ")
    difficulty_name:set_w(0, 0)
    difficulty_name:set_position(0, host_name:bottom())
  end
  stars_panel:set_position(0, job_name:bottom())
  side_panel:set_h(math.max(stars_panel:bottom(), difficulty_name:bottom()))
  side_panel:set_w(300)
  l_34_0._num_layer_jobs = (l_34_0._num_layer_jobs + 1) % 1
  local marker_panel = l_34_0._pan_panel:panel({w = 36, h = 66, layer = 11 + l_34_0._num_layer_jobs * 3, alpha = 0})
  local select_panel = marker_panel:panel({name = "select_panel", w = 36, h = 38, x = -2, y = 0})
  local glow_panel = l_34_0._pan_panel:panel({w = 960, h = 192, layer = 10, alpha = 0})
  local glow_center = glow_panel:bitmap({texture = "guis/textures/pd2/crimenet_marker_glow", w = 192, h = 192, blend_mode = "add", alpha = 0.55000001192093, color = is_professional and pro_color or regular_color})
  local glow_stretch = glow_panel:bitmap({texture = "guis/textures/pd2/crimenet_marker_glow", w = 960, h = 50, blend_mode = "add", alpha = 0.55000001192093, color = is_professional and pro_color or regular_color})
  local glow_center_dark = glow_panel:bitmap({texture = "guis/textures/pd2/crimenet_marker_glow", w = 150, h = 150, blend_mode = "normal", alpha = 0.69999998807907, color = Color.black, layer = -1})
  local glow_stretch_dark = glow_panel:bitmap({texture = "guis/textures/pd2/crimenet_marker_glow", w = 990, h = 55, blend_mode = "normal", alpha = 0.69999998807907, color = Color.black, layer = -1})
  glow_center:set_center(glow_panel:w() / 2, glow_panel:h() / 2)
  glow_stretch:set_center(glow_panel:w() / 2, glow_panel:h() / 2)
  glow_center_dark:set_center(glow_panel:w() / 2, glow_panel:h() / 2)
  glow_stretch_dark:set_center(glow_panel:w() / 2, glow_panel:h() / 2)
  local marker_dot = marker_panel:bitmap({name = "marker_dot", texture = "guis/textures/pd2/crimenet_marker_" .. (is_server and "join" or "host") .. (is_professional and "_pro" or ""), color = color, w = 32, h = 64, x = 2, y = 2, layer = 1})
   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

  if is_professional then
    marker_panel:bitmap({name = "marker_pro_outline", texture = "guis/textures/pd2/crimenet_marker_pro_outline", w = 64, h = 64})
    {name = "marker_pro_outline", texture = "guis/textures/pd2/crimenet_marker_pro_outline", w = 64, h = 64}.blend_mode, {name = "marker_pro_outline", texture = "guis/textures/pd2/crimenet_marker_pro_outline", w = 64, h = 64}.alpha, {name = "marker_pro_outline", texture = "guis/textures/pd2/crimenet_marker_pro_outline", w = 64, h = 64}.layer, {name = "marker_pro_outline", texture = "guis/textures/pd2/crimenet_marker_pro_outline", w = 64, h = 64}.rotation, {name = "marker_pro_outline", texture = "guis/textures/pd2/crimenet_marker_pro_outline", w = 64, h = 64}.y, {name = "marker_pro_outline", texture = "guis/textures/pd2/crimenet_marker_pro_outline", w = 64, h = 64}.x = "add", 1, 0, 0, 0, 0
  end
  local timer_rect, peers_panel = nil, nil
  if is_server then
    peers_panel = l_34_0._pan_panel:panel({layer = 11 + l_34_0._num_layer_jobs * 3, visible = true, w = 32, h = 62, alpha = 0})
    local cx = 0
    do
      local cy = 0
      for i = 1, 4 do
        cx = 3 + 6 * (i - 1)
        cy = 8
        local player_marker = peers_panel:bitmap({name = tostring(i), texture = "guis/textures/pd2/crimenet_marker_peerflag", w = 8, h = 16, color = color, layer = 2, blend_mode = "normal", visible = i <= l_34_1.num_plrs})
        player_marker:set_position(cx, cy)
      end
  end
   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

  else
    timer_rect, {name = "timer_rect", texture = "guis/textures/pd2/crimenet_timer"}.layer, {name = "timer_rect", texture = "guis/textures/pd2/crimenet_timer"}.render_template, {name = "timer_rect", texture = "guis/textures/pd2/crimenet_timer"}.y, {name = "timer_rect", texture = "guis/textures/pd2/crimenet_timer"}.x, {name = "timer_rect", texture = "guis/textures/pd2/crimenet_timer"}.h, {name = "timer_rect", texture = "guis/textures/pd2/crimenet_timer"}.w, {name = "timer_rect", texture = "guis/textures/pd2/crimenet_timer"}.color = marker_panel:bitmap({name = "timer_rect", texture = "guis/textures/pd2/crimenet_timer"}), 2, "VertexColorTexturedRadial", 2, 1, 32, 32, Color.white
    timer_rect:set_texture_rect(32, 0, -32, 32)
  end
  marker_panel:set_center(x * l_34_0._zoom, y * l_34_0._zoom)
  focus:set_center(marker_panel:center())
  glow_panel:set_world_center(marker_panel:child("select_panel"):world_center())
  local text_on_right = x < l_34_0._map_size_w - 200
  if text_on_right then
    side_panel:set_left(marker_panel:right())
  else
    job_name:set_text(contact_name:text() .. job_name:text())
    contact_name:set_text("")
    contact_name:set_w(0)
    local _, _, w, h = job_name:text_rect()
    job_name:set_size(w, h)
    host_name:set_right(side_panel:w())
    job_name:set_right(side_panel:w())
    contact_name:set_left(side_panel:w())
    info_name:set_left(side_panel:w())
    difficulty_name:set_left(side_panel:w())
    stars_panel:set_right(side_panel:w())
    side_panel:set_right(marker_panel:left())
  end
  side_panel:set_center_y(marker_panel:top() + 11)
  if peers_panel then
    peers_panel:set_center_x(marker_panel:center_x())
    peers_panel:set_center_y(marker_panel:center_y())
  end
  if not Application:production_build() or peers_panel then
    local callout = nil
  end
  if narrative_data and narrative_data.crimenet_callouts and #narrative_data.crimenet_callouts > 0 then
    local variant = math.random(#narrative_data.crimenet_callouts)
    callout = narrative_data.crimenet_callouts[variant]
  end
  if location then
    location[3] = true
  end
  managers.menu:post_event("job_appear")
  {room_id = l_34_1.room_id, job_id = l_34_1.job_id, level_id = level_id, level_data = level_data, marker_panel = marker_panel, peers_panel = peers_panel, timer_rect = timer_rect, side_panel = side_panel}.focus = focus
   -- DECOMPILER ERROR: Confused about usage of registers!

  {room_id = l_34_1.room_id, job_id = l_34_1.job_id, level_id = level_id, level_data = level_data, marker_panel = marker_panel, peers_panel = peers_panel, timer_rect = timer_rect, side_panel = side_panel}.difficulty = l_34_1.difficulty
   -- DECOMPILER ERROR: Confused about usage of registers!

  {room_id = l_34_1.room_id, job_id = l_34_1.job_id, level_id = level_id, level_data = level_data, marker_panel = marker_panel, peers_panel = peers_panel, timer_rect = timer_rect, side_panel = side_panel}.difficulty_id = l_34_1.difficulty_id
   -- DECOMPILER ERROR: Confused about usage of registers!

  {room_id = l_34_1.room_id, job_id = l_34_1.job_id, level_id = level_id, level_data = level_data, marker_panel = marker_panel, peers_panel = peers_panel, timer_rect = timer_rect, side_panel = side_panel}.num_plrs = l_34_1.num_plrs
   -- DECOMPILER ERROR: Confused about usage of registers!

  {room_id = l_34_1.room_id, job_id = l_34_1.job_id, level_id = level_id, level_data = level_data, marker_panel = marker_panel, peers_panel = peers_panel, timer_rect = timer_rect, side_panel = side_panel}.job_x = x
   -- DECOMPILER ERROR: Confused about usage of registers!

  {room_id = l_34_1.room_id, job_id = l_34_1.job_id, level_id = level_id, level_data = level_data, marker_panel = marker_panel, peers_panel = peers_panel, timer_rect = timer_rect, side_panel = side_panel}.job_y = y
   -- DECOMPILER ERROR: Confused about usage of registers!

  {room_id = l_34_1.room_id, job_id = l_34_1.job_id, level_id = level_id, level_data = level_data, marker_panel = marker_panel, peers_panel = peers_panel, timer_rect = timer_rect, side_panel = side_panel}.state = l_34_1.state
   -- DECOMPILER ERROR: Confused about usage of registers!

  {room_id = l_34_1.room_id, job_id = l_34_1.job_id, level_id = level_id, level_data = level_data, marker_panel = marker_panel, peers_panel = peers_panel, timer_rect = timer_rect, side_panel = side_panel}.layer = 11 + l_34_0._num_layer_jobs * 3
   -- DECOMPILER ERROR: Confused about usage of registers!

  {room_id = l_34_1.room_id, job_id = l_34_1.job_id, level_id = level_id, level_data = level_data, marker_panel = marker_panel, peers_panel = peers_panel, timer_rect = timer_rect, side_panel = side_panel}.glow_panel = glow_panel
   -- DECOMPILER ERROR: Confused about usage of registers!

  {room_id = l_34_1.room_id, job_id = l_34_1.job_id, level_id = level_id, level_data = level_data, marker_panel = marker_panel, peers_panel = peers_panel, timer_rect = timer_rect, side_panel = side_panel}.callout = callout
   -- DECOMPILER ERROR: Confused about usage of registers!

  {room_id = l_34_1.room_id, job_id = l_34_1.job_id, level_id = level_id, level_data = level_data, marker_panel = marker_panel, peers_panel = peers_panel, timer_rect = timer_rect, side_panel = side_panel}.text_on_right = text_on_right
   -- DECOMPILER ERROR: Confused about usage of registers!

  {room_id = l_34_1.room_id, job_id = l_34_1.job_id, level_id = level_id, level_data = level_data, marker_panel = marker_panel, peers_panel = peers_panel, timer_rect = timer_rect, side_panel = side_panel}.location = location
  do
     -- DECOMPILER ERROR: Confused at declaration of local variable

     -- DECOMPILER ERROR: Confused about usage of registers!

    l_34_0:update_job_gui({room_id = l_34_1.room_id, job_id = l_34_1.job_id, level_id = level_id, level_data = level_data, marker_panel = marker_panel, peers_panel = peers_panel, timer_rect = timer_rect, side_panel = side_panel}, 3)
     -- DECOMPILER ERROR: Confused about usage of registers!

    return {room_id = l_34_1.room_id, job_id = l_34_1.job_id, level_id = level_id, level_data = level_data, marker_panel = marker_panel, peers_panel = peers_panel, timer_rect = timer_rect, side_panel = side_panel}
  end
   -- DECOMPILER ERROR: Confused about usage of registers for local variables.

end

CrimeNetGui.remove_job = function(l_35_0, l_35_1)
  do
    local data = l_35_0._jobs[l_35_1]
    if not data then
      return 
    end
    if not alive(l_35_0._panel) then
      return 
    end
    l_35_0._pan_panel:remove(data.marker_panel)
    l_35_0._pan_panel:remove(data.glow_panel)
    l_35_0._pan_panel:remove(data.side_panel)
    l_35_0._pan_panel:remove(data.focus)
    if data.location then
      data.location[3] = nil
    end
    if data.peers_panel then
      l_35_0._pan_panel:remove(data.peers_panel)
    end
    if data.expanded then
      l_35_0._jobs[l_35_1] = nil
    end
     -- Warning: missing end command somewhere! Added here
  end
end

CrimeNetGui.update_server_job = function(l_36_0, l_36_1, l_36_2)
  local job_index = l_36_1.id or l_36_2
  local job = l_36_0._jobs[job_index]
  if not job then
    return 
  end
  local level_id = l_36_1.level_id
  local level_data = tweak_data.levels[level_id]
  local recreate_job = false
  if not recreate_job then
    recreate_job = l_36_0:_update_job_variable(job_index, "room_id", l_36_1.room_id)
  end
  if not recreate_job then
    recreate_job = l_36_0:_update_job_variable(job_index, "job_id", l_36_1.job_id)
  end
  if not recreate_job then
    recreate_job = l_36_0:_update_job_variable(job_index, "level_id", level_id)
  end
  if not recreate_job then
    recreate_job = l_36_0:_update_job_variable(job_index, "level_data", level_data)
  end
  if not recreate_job then
    recreate_job = l_36_0:_update_job_variable(job_index, "difficulty", l_36_1.difficulty)
  end
  if not recreate_job then
    recreate_job = l_36_0:_update_job_variable(job_index, "difficulty_id", l_36_1.difficulty_id)
  end
  if not recreate_job then
    recreate_job = l_36_0:_update_job_variable(job_index, "state", l_36_1.state)
  end
  l_36_0:_update_job_variable(job_index, "state_name", l_36_1.state_name)
  if l_36_0:_update_job_variable(job_index, "num_plrs", l_36_1.num_plrs) and job.peers_panel then
    for i,peer_icon in ipairs(job.peers_panel:children()) do
      peer_icon:set_visible(i <= job.num_plrs)
    end
  end
  if recreate_job then
    print("[CrimeNetGui] update_server_job", "job_index", job_index)
    local is_server = job.server
    local x = job.job_x
    local y = job.job_y
    local location = job.location
    l_36_0:remove_job(job_index)
    local gui_data = l_36_0:_create_job_gui(l_36_1, is_server and "server" or "contract", x, y, location)
    gui_data.server = is_server
    l_36_0._jobs[job_index] = gui_data
  end
end

CrimeNetGui._update_job_variable = function(l_37_0, l_37_1, l_37_2, l_37_3)
  local data = l_37_0._jobs[l_37_1]
  if not data then
    return 
  end
  local updated = data[l_37_2] ~= l_37_3
  data[l_37_2] = l_37_3
  return updated
end

CrimeNetGui.update_job = function(l_38_0, l_38_1, l_38_2, l_38_3)
  local data = l_38_0._jobs[l_38_1]
  if not data then
    return 
  end
  data.focus:set_alpha(data.focus:alpha() - l_38_3 / 2)
  data.focus:set_size(data.focus:w() + l_38_3 * 200, data.focus:h() + l_38_3 * 200)
  data.focus:set_center(data.marker_panel:center())
end

CrimeNetGui.feed_timer = function(l_39_0, l_39_1, l_39_2, l_39_3)
  do
    local data = l_39_0._jobs[l_39_1]
    if not data then
      return 
    end
    if not data.timer_rect then
      return 
    end
    data.timer_rect:set_color(Color(l_39_2 / l_39_3, 1, 1))
    if l_39_3 - l_39_2 < 4 then
      do return end
    end
  end
  if l_39_2 < 4 then
     -- Warning: missing end command somewhere! Added here
  end
end

CrimeNetGui.update = function(l_40_0, l_40_1, l_40_2)
  l_40_0._rasteroverlay:set_texture_rect(0, -math.mod(Application:time() * 5, 32), 32, 640)
  if l_40_0._released_map then
    l_40_0._released_map.dx = math.lerp(l_40_0._released_map.dx, 0, l_40_2 * 2)
    l_40_0._released_map.dy = math.lerp(l_40_0._released_map.dy, 0, l_40_2 * 2)
    l_40_0:_set_map_position(l_40_0._released_map.dx, l_40_0._released_map.dy)
    if l_40_0._map_panel:x() >= -5 or l_40_0._fullscreen_panel:w() - l_40_0._map_panel:right() >= -5 then
      l_40_0._released_map.dx = 0
    end
    if l_40_0._map_panel:y() >= -5 or l_40_0._fullscreen_panel:h() - l_40_0._map_panel:bottom() >= -5 then
      l_40_0._released_map.dy = 0
    end
    l_40_0._released_map.t = l_40_0._released_map.t - l_40_2
    if l_40_0._released_map.t < 0 then
      l_40_0._released_map = nil
    end
  end
  if not l_40_0._grabbed_map then
    local speed = 5
    if -l_40_0:_get_pan_panel_border() < l_40_0._map_panel:x() then
      local mx = math.lerp(0, -l_40_0:_get_pan_panel_border() - l_40_0._map_panel:x(), l_40_2 * speed)
      l_40_0:_set_map_position(mx, 0)
    end
    if -l_40_0:_get_pan_panel_border() < l_40_0._fullscreen_panel:w() - l_40_0._map_panel:right() then
      local mx = math.lerp(0, l_40_0:_get_pan_panel_border() - (l_40_0._map_panel:right() - l_40_0._fullscreen_panel:w()), l_40_2 * speed)
      l_40_0:_set_map_position(mx, 0)
    end
    if -l_40_0:_get_pan_panel_border() < l_40_0._map_panel:y() then
      local my = math.lerp(0, -l_40_0:_get_pan_panel_border() - l_40_0._map_panel:y(), l_40_2 * speed)
      l_40_0:_set_map_position(0, my)
    end
    if -l_40_0:_get_pan_panel_border() < l_40_0._fullscreen_panel:h() - l_40_0._map_panel:bottom() then
      local my = math.lerp(0, l_40_0:_get_pan_panel_border() - (l_40_0._map_panel:bottom() - l_40_0._fullscreen_panel:h()), l_40_2 * speed)
      l_40_0:_set_map_position(0, my)
    end
  end
  if not managers.menu:is_pc_controller() and managers.mouse_pointer:mouse_move_x() == 0 and managers.mouse_pointer:mouse_move_y() == 0 then
    local closest_job = nil
    local closest_dist = 100000000
    local closest_job_x, closest_job_y = 0, 0
    local mouse_pos_x, mouse_pos_y = managers.mouse_pointer:modified_mouse_pos()
    local job_x, job_y = nil, nil
    local dist = 0
    local x, y = nil, nil
    for id,job in pairs(l_40_0._jobs) do
      job_x, job_y = job.marker_panel:child("select_panel"):world_center()
      x = job_x - mouse_pos_x
      y = job_y - mouse_pos_y
      dist = (x) * (x) + (y) * (y)
      if dist < closest_dist then
        closest_job = job
        closest_dist = dist
        closest_job_x = job_x
        closest_job_y = job_y
      end
    end
    if closest_job then
      closest_dist = math.sqrt(closest_dist)
      if closest_dist < l_40_0._tweak_data.controller.snap_distance then
        managers.mouse_pointer:force_move_mouse_pointer(math.lerp(mouse_pos_x, closest_job_x, l_40_2 * l_40_0._tweak_data.controller.snap_speed) - mouse_pos_x, math.lerp(mouse_pos_y, closest_job_y, l_40_2 * l_40_0._tweak_data.controller.snap_speed) - mouse_pos_y)
      end
    end
  end
end

CrimeNetGui.feed_server_timer = function(l_41_0, l_41_1, l_41_2)
  local data = l_41_0._jobs[l_41_1]
  if not data then
    return 
  end
  if not data.timer_rect then
    return 
  end
  if l_41_2 < 4 then
    data.timer_rect:set_visible(true)
    data.timer_rect:set_color(Color(math.sin(l_41_2 * 750), 1, 1))
  else
    data.timer_rect:set_visible(false)
  end
end

CrimeNetGui.toggle_legend = function(l_42_0)
  managers.menu_component:post_event("menu_enter")
  l_42_0._panel:child("legend_panel"):set_visible(not l_42_0._panel:child("legend_panel"):visible())
  l_42_0._panel:child("legends_button"):set_text(managers.localization:to_upper_text(l_42_0._panel:child("legend_panel"):visible() and "menu_cn_legend_hide" or "menu_cn_legend_show", {BTN_X = managers.localization:btn_macro("menu_toggle_legends")}))
  l_42_0:make_fine_text(l_42_0._panel:child("legends_button"))
  l_42_0._panel:child("legends_button_blur"):set_shape(l_42_0._panel:child("legends_button"):shape())
end

CrimeNetGui.mouse_button_click = function(l_43_0, l_43_1)
  return l_43_1 == Idstring("0")
end

CrimeNetGui.button_wheel_scroll_up = function(l_44_0, l_44_1)
  return l_44_1 == Idstring("mouse wheel up")
end

CrimeNetGui.button_wheel_scroll_down = function(l_45_0, l_45_1)
  return l_45_1 == Idstring("mouse wheel down")
end

CrimeNetGui.confirm_pressed = function(l_46_0)
  if not l_46_0._crimenet_enabled then
    return false
  end
  return l_46_0:check_job_pressed(managers.mouse_pointer:modified_mouse_pos())
end

CrimeNetGui.special_btn_pressed = function(l_47_0, l_47_1)
  if not l_47_0._crimenet_enabled then
    return false
  end
  if l_47_1 == Idstring("menu_toggle_legends") then
    l_47_0:toggle_legend()
    return true
  end
  if l_47_0._panel:child("filter_button") and l_47_1 == Idstring("menu_toggle_filters") then
    managers.menu_component:post_event("menu_enter")
    if is_x360 then
      XboxLive:show_friends_ui(managers.user:get_platform_id())
    else
      managers.menu:open_node("crimenet_filters", {})
    end
    return true
  end
  return false
end

CrimeNetGui.previous_page = function(l_48_0)
  if not l_48_0._crimenet_enabled then
    return 
  end
  l_48_0:_set_zoom("out", managers.mouse_pointer:modified_mouse_pos())
  return true
end

CrimeNetGui.next_page = function(l_49_0)
  if not l_49_0._crimenet_enabled then
    return 
  end
  l_49_0:_set_zoom("in", managers.mouse_pointer:modified_mouse_pos())
  return true
end

CrimeNetGui.input_focus = function(l_50_0)
  return not l_50_0._crimenet_enabled or 1
end

CrimeNetGui.check_job_mouse_over = function(l_51_0, l_51_1, l_51_2)
end

CrimeNetGui.check_job_pressed = function(l_52_0, l_52_1, l_52_2)
  for id,job in pairs(l_52_0._jobs) do
    if job.mouse_over == 1 then
      job.expanded = not job.expanded
      {difficulty = job.difficulty, difficulty_id = job.difficulty_id, job_id = job.job_id, level_id = job.level_id}.id = id
       -- DECOMPILER ERROR: Confused about usage of registers!

      {difficulty = job.difficulty, difficulty_id = job.difficulty_id, job_id = job.job_id, level_id = job.level_id}.room_id = job.room_id
       -- DECOMPILER ERROR: Confused about usage of registers!

      {difficulty = job.difficulty, difficulty_id = job.difficulty_id, job_id = job.job_id, level_id = job.level_id}.server = job.server or false
       -- DECOMPILER ERROR: Confused about usage of registers!

      {difficulty = job.difficulty, difficulty_id = job.difficulty_id, job_id = job.job_id, level_id = job.level_id}.num_plrs = job.num_plrs or 0
       -- DECOMPILER ERROR: Confused about usage of registers!

      {difficulty = job.difficulty, difficulty_id = job.difficulty_id, job_id = job.job_id, level_id = job.level_id}.state = job.state
       -- DECOMPILER ERROR: Confused about usage of registers!

      {difficulty = job.difficulty, difficulty_id = job.difficulty_id, job_id = job.job_id, level_id = job.level_id}.host_name = job.host_name
      do
         -- DECOMPILER ERROR: Confused at declaration of local variable

        managers.menu_component:post_event("menu_enter")
         -- DECOMPILER ERROR: Confused about usage of registers!

        managers.menu:open_node((Global.game_settings.single_player and "crimenet_contract_singleplayer") or (job.server and "crimenet_contract_join") or "crimenet_contract_host", {{difficulty = job.difficulty, difficulty_id = job.difficulty_id, job_id = job.job_id, level_id = job.level_id}})
        if job.expanded then
          for id2,job2 in pairs(l_52_0._jobs) do
             -- DECOMPILER ERROR: Confused at declaration of local variable

            if i_3 ~= job then
              i_3.expanded = false
            end
          end
        end
        return true
      end
       -- DECOMPILER ERROR: Confused about usage of registers for local variables.

    end
  end
   -- DECOMPILER ERROR: Confused about usage of registers for local variables.

end

CrimeNetGui.mouse_pressed = function(l_53_0, l_53_1, l_53_2, l_53_3, l_53_4)
  if not l_53_0._crimenet_enabled then
    return 
  end
  if l_53_0:mouse_button_click(l_53_2) then
    if l_53_0._panel:child("back_button"):inside(l_53_3, l_53_4) then
      managers.menu:back()
      return 
    end
    if l_53_0._panel:child("legends_button"):inside(l_53_3, l_53_4) then
      l_53_0:toggle_legend()
      return 
    end
    if l_53_0._panel:child("filter_button") and l_53_0._panel:child("filter_button"):inside(l_53_3, l_53_4) then
      managers.menu_component:post_event("menu_enter")
      managers.menu:open_node("crimenet_filters", {})
      return 
    end
    if l_53_0:check_job_pressed(l_53_3, l_53_4) then
      return true
    end
    if l_53_0._panel:inside(l_53_3, l_53_4) then
      l_53_0._released_map = nil
      l_53_0._grabbed_map = {x = l_53_3, y = l_53_4, dirs = {}}
    else
      if l_53_0:button_wheel_scroll_down(l_53_2) then
        if l_53_0._one_scroll_out_delay then
          l_53_0._one_scroll_out_delay = nil
        end
        l_53_0:_set_zoom("out", l_53_3, l_53_4)
        return true
      else
        if l_53_0:button_wheel_scroll_up(l_53_2) then
          if l_53_0._one_scroll_in_delay then
            l_53_0._one_scroll_in_delay = nil
          end
          l_53_0:_set_zoom("in", l_53_3, l_53_4)
          return true
        end
      end
    end
  end
  return true
end

CrimeNetGui.start_job = function(l_54_0)
  for id,job in pairs(l_54_0._jobs) do
    if job.expanded then
      if job.preset_id then
        MenuCallbackHandler:start_job(job)
        l_54_0:remove_job(job.preset_id)
        return true
        for (for control),id in (for generator) do
        end
        print("Is a server, don't want to join", id, job.side_panel:child("host_name"):text() == "WWWWWWWWWWWW\194\181QQW")
        managers.network.matchmake:join_server_with_check(id)
        return 
      end
    end
     -- Warning: missing end command somewhere! Added here
  end
end

CrimeNetGui.mouse_released = function(l_55_0, l_55_1, l_55_2, l_55_3, l_55_4)
  if not l_55_0._crimenet_enabled then
    return 
  end
  if not l_55_0:mouse_button_click(l_55_2) then
    return 
  end
  if l_55_0._grabbed_map and #l_55_0._grabbed_map.dirs > 0 then
    local dx, dy = 0, 0
    for _,values in ipairs(l_55_0._grabbed_map.dirs) do
      dx = dx + values[1]
      dy = dy + values[2]
    end
    dx = (dx) / #l_55_0._grabbed_map.dirs
    dy = (dy) / #l_55_0._grabbed_map.dirs
    l_55_0._released_map = {t = 2, dx = dx, dy = dy}
    l_55_0._grabbed_map = nil
  end
end

CrimeNetGui._get_pan_panel_border = function(l_56_0)
  return l_56_0._pan_panel_border * l_56_0._zoom
end

CrimeNetGui._set_map_position = function(l_57_0, l_57_1, l_57_2)
  local x = l_57_0._map_x + l_57_1
  local y = l_57_0._map_y + l_57_2
  l_57_0._pan_panel:set_position(x, y)
  if l_57_0._pan_panel:left() > 0 then
    l_57_0._pan_panel:set_left(0)
  end
  if l_57_0._pan_panel:right() < l_57_0._fullscreen_panel:w() then
    l_57_0._pan_panel:set_right(l_57_0._fullscreen_panel:w())
  end
  if l_57_0._pan_panel:top() > 0 then
    l_57_0._pan_panel:set_top(0)
  end
  if l_57_0._pan_panel:bottom() < l_57_0._fullscreen_panel:h() then
    l_57_0._pan_panel:set_bottom(l_57_0._fullscreen_panel:h())
  end
  l_57_0._map_x, l_57_0._map_y = l_57_0._pan_panel:position(), l_57_0._pan_panel
  l_57_0._pan_panel:set_position(math.round(l_57_0._map_x), math.round(l_57_0._map_y))
  x, y = l_57_0._map_x, l_57_0._map_y
  l_57_0._map_panel:set_shape(l_57_0._pan_panel:shape())
  l_57_0._pan_panel:set_position(managers.gui_data:full_16_9_to_safe(managers.gui_data, x, y))
  local full_16_9 = managers.gui_data:full_16_9_size(managers.gui_data)
  local w_ratio = l_57_0._fullscreen_panel:w() / l_57_0._map_panel:w()
  local h_ratio = l_57_0._fullscreen_panel:h() / l_57_0._map_panel:h()
  local panel_x = -(l_57_0._map_panel:x() / l_57_0._fullscreen_panel:w()) * w_ratio
  local panel_y = -(l_57_0._map_panel:y() / l_57_0._fullscreen_panel:h()) * h_ratio
  local cross_indicator_h1 = l_57_0._fullscreen_panel:child("cross_indicator_h1")
  local cross_indicator_h2 = l_57_0._fullscreen_panel:child("cross_indicator_h2")
  local cross_indicator_v1 = l_57_0._fullscreen_panel:child("cross_indicator_v1")
  local cross_indicator_v2 = l_57_0._fullscreen_panel:child("cross_indicator_v2")
  local line_indicator_h1 = l_57_0._fullscreen_panel:child("line_indicator_h1")
  local line_indicator_h2 = l_57_0._fullscreen_panel:child("line_indicator_h2")
  local line_indicator_v1 = l_57_0._fullscreen_panel:child("line_indicator_v1")
  local line_indicator_v2 = l_57_0._fullscreen_panel:child("line_indicator_v2")
  cross_indicator_h1:set_y(full_16_9.convert_y + l_57_0._panel:h() * panel_y)
  cross_indicator_h2:set_bottom(l_57_0._fullscreen_panel:child("cross_indicator_h1"):y() + l_57_0._panel:h() * h_ratio)
  cross_indicator_v1:set_x(full_16_9.convert_x + l_57_0._panel:w() * panel_x)
  cross_indicator_v2:set_right(l_57_0._fullscreen_panel:child("cross_indicator_v1"):x() + l_57_0._panel:w() * w_ratio)
  line_indicator_h1:set_position(cross_indicator_v1:x(), cross_indicator_h1:y())
  line_indicator_h2:set_position(cross_indicator_v1:x(), cross_indicator_h2:y())
  line_indicator_v1:set_position(cross_indicator_v1:x(), cross_indicator_h1:y())
  line_indicator_v2:set_position(cross_indicator_v2:x(), cross_indicator_h1:y())
  line_indicator_h1:set_w(cross_indicator_v2:x() - cross_indicator_v1:x())
  line_indicator_h2:set_w(cross_indicator_v2:x() - cross_indicator_v1:x())
  line_indicator_v1:set_h(cross_indicator_h2:y() - cross_indicator_h1:y())
  line_indicator_v2:set_h(cross_indicator_h2:y() - cross_indicator_h1:y())
end

CrimeNetGui.goto_lobby = function(l_58_0, l_58_1)
  print(l_58_1:id())
  local job = l_58_0._jobs[l_58_1:id()]
  if job then
    local x = job.marker_panel:child("select_panel"):center_x() + job.marker_panel:w() / 2
    local y = job.marker_panel:child("select_panel"):center_y() + job.marker_panel:h() - 2
    job.focus:set_size(job.focus:texture_width(), job.focus:texture_height())
    job.focus:set_color(job.focus:color():with_alpha(1))
    l_58_0:_goto_map_position(x, y)
  end
end

CrimeNetGui.goto_bain = function(l_59_0)
  for _,job in pairs(l_59_0._jobs) do
  end
end

CrimeNetGui._goto_map_position = function(l_60_0, l_60_1, l_60_2)
  local tw = math.max(l_60_0._map_panel:child("map"):texture_width(), 1)
  local th = math.max(l_60_0._map_panel:child("map"):texture_height(), 1)
  local mx = l_60_0._map_panel:x() + l_60_1 / tw * l_60_0._map_size_w * l_60_0._zoom - l_60_0._fullscreen_panel:w() * 0.5
  local my = l_60_0._map_panel:y() + l_60_2 / th * l_60_0._map_size_h * l_60_0._zoom - l_60_0._fullscreen_panel:h() * 0.5
  l_60_0:_set_map_position(-mx, -my)
end

CrimeNetGui._set_zoom = function(l_61_0, l_61_1, l_61_2, l_61_3)
  local w1, h1 = l_61_0._pan_panel:size()
  local wx1 = (-l_61_0._fullscreen_panel:x() - l_61_0._pan_panel:x() + l_61_2) / l_61_0._pan_panel:w()
  local wy1 = (-l_61_0._fullscreen_panel:y() - l_61_0._pan_panel:y() + l_61_3) / l_61_0._pan_panel:h()
  local prev_zoom = l_61_0._zoom
  if l_61_1 == "in" then
    local new_zoom = math.clamp(l_61_0._zoom * 1.1000000238419, l_61_0.MIN_ZOOM, l_61_0.MAX_ZOOM)
    if new_zoom ~= l_61_0._zoom then
      managers.menu_component:post_event("zoom_in")
    end
    l_61_0._zoom = new_zoom
  else
    local new_zoom = math.clamp(l_61_0._zoom / 1.1000000238419, l_61_0.MIN_ZOOM, l_61_0.MAX_ZOOM)
    if new_zoom ~= l_61_0._zoom then
      managers.menu_component:post_event("zoom_out")
    end
    l_61_0._zoom = new_zoom
  end
  l_61_0._pan_panel_border = 6.25 * l_61_0._zoom
  if prev_zoom == l_61_0._zoom then
    if l_61_1 == "in" then
      l_61_0._one_scroll_out_delay = true
    else
      l_61_0._one_scroll_in_delay = true
    end
  end
  local cx, cy = l_61_0._pan_panel:center()
  l_61_0._pan_panel:set_size(l_61_0._map_size_w * l_61_0._zoom, l_61_0._map_size_h * l_61_0._zoom)
  l_61_0._pan_panel:set_center(cx, cy)
  local w2, h2 = l_61_0._pan_panel:size()
  l_61_0:_set_map_position((w1 - w2) * wx1, (h1 - h2) * wy1)
  for id,job in pairs(l_61_0._jobs) do
    job.marker_panel:set_center(job.job_x * l_61_0._zoom, job.job_y * l_61_0._zoom)
    job.glow_panel:set_world_center(job.marker_panel:child("select_panel"):world_center())
    job.focus:set_center(job.marker_panel:center())
    if job.text_on_right then
      job.side_panel:set_left(job.marker_panel:right())
    else
      job.side_panel:set_right(job.marker_panel:left())
    end
    job.side_panel:set_center_y(job.marker_panel:top() + 11)
    if job.peers_panel then
      job.peers_panel:set_center_x(job.marker_panel:center_x())
      job.peers_panel:set_center_y(job.marker_panel:center_y())
    end
  end
  for _,region_location in ipairs(l_61_0._region_locations) do
    region_location.object:set_font_size(l_61_0._zoom * region_location.size)
  end
end

CrimeNetGui.update_job_gui = function(l_62_0, l_62_1, l_62_2)
  if l_62_1.mouse_over ~= l_62_2 then
    l_62_1.mouse_over = l_62_2
    local animate_alpha = function(l_1_0, l_1_1, l_1_2, l_1_3, l_1_4)
      local wanted_alpha = l_1_3[1]
      local wanted_text_alpha = l_1_3[2]
      local start_h = l_1_2.side_panel:h()
      local h = start_h
      local host_name = l_1_2.side_panel:child("host_name")
      local job_name = l_1_2.side_panel:child("job_name")
      local contact_name = l_1_2.side_panel:child("contact_name")
      local info_name = l_1_2.side_panel:child("info_name")
      local difficulty_name = l_1_2.side_panel:child("difficulty_name")
      local stars_panel = l_1_2.side_panel:child("stars_panel")
      local base_h = math.round(host_name:h() + job_name:h() + stars_panel:h())
      local expand_h = math.round(base_h + info_name:h() + difficulty_name:h())
      local start_x = 0
      local max_x = math.round(math.max(contact_name:w(), info_name:w(), difficulty_name:w()))
      if l_1_2.text_on_right then
        start_x = math.round(math.min(contact_name:right(), info_name:right(), difficulty_name:right()))
      else
        start_x = math.round(l_1_2.side_panel:w() - math.min(contact_name:left(), info_name:left(), difficulty_name:left()))
      end
      local x = start_x
      local object_alpha = {}
      local text_alpha = l_1_2.side_panel:alpha()
      local alpha_met = false
      local glow_met = false
      local expand_met = false
      local pushout_met = x == 0
      local dt = nil
      repeat
        repeat
          if not alpha_met or not glow_met or not expand_met or not pushout_met then
            dt = coroutine.yield()
            if not alpha_met then
              alpha_met = true
              for i,object in ipairs(l_1_1) do
                if object and alive(object) then
                  if not object_alpha[i] then
                    object_alpha[i] = object:alpha()
                  end
                  object_alpha[i] = math.step(object_alpha[i], wanted_alpha, dt)
                  object:set_alpha(object_alpha[i])
                  alpha_met = not alpha_met or object_alpha[i] == wanted_alpha
                end
              end
              text_alpha = math.step(text_alpha, wanted_text_alpha, dt * 2)
              l_1_2.side_panel:set_alpha(text_alpha)
              alpha_met = not alpha_met or text_alpha == wanted_text_alpha
            if not alpha_met or l_1_4 then
              end
            end
            if not l_1_4 or not 0.20000000298023 then
              l_1_2.glow_panel:set_alpha(math.step(l_1_2.glow_panel:alpha(), glow_met or 0, dt * 5))
              glow_met = l_1_2.glow_panel:alpha() == l_1_4 and 0.20000000298023 or 0
              if glow_met and l_1_4 then
                local animate_pulse = function(l_1_0)
                repeat
                  over(1, function(l_1_0)
                    o:set_alpha(math.sin(l_1_0 * 180) * 0.40000000596046 + 0.20000000298023)
                           end)
                  do return end
                   -- Warning: missing end command somewhere! Added here
                end
                     end
                l_1_2.glow_panel:animate(animate_pulse)
              end
               -- DECOMPILER ERROR: Confused while interpreting a jump as a 'while'

            end
            h = math.step(h, expand_met or not pushout_met or base_h, base_h * dt * 4)
            l_1_2.side_panel:set_h(h)
            l_1_2.side_panel:set_center_y(l_1_0:top() + 11)
            stars_panel:set_bottom(l_1_2.side_panel:h())
            expand_met = h == l_1_4 and expand_h or base_h
            pushout_met = (l_1_4 and x == not expand_met or 0) or x == not expand_met or 0
          until not pushout_met
          x = math.step(x, l_1_4 and max_x or 0, max_x * dt * 4)
          stars_panel:set_alpha(1 - x / math.min(max_x, 1))
          if l_1_2.text_on_right then
            job_name:set_left(math.round(math.min(x, contact_name:w())))
            contact_name:set_left(math.round(math.min(x - contact_name:w(), 0)))
            info_name:set_left(math.round(math.min(x - info_name:w(), 0)))
            difficulty_name:set_left(math.round(math.min(x - difficulty_name:w(), 0)))
          else
            job_name:set_right(math.round(l_1_2.side_panel:w() - math.min(x, contact_name:w())))
            contact_name:set_right(math.round(l_1_2.side_panel:w() - math.min(x - contact_name:w(), 0)))
            info_name:set_right(math.round(l_1_2.side_panel:w() - math.min(x - info_name:w(), 0)))
            difficulty_name:set_right(math.round(l_1_2.side_panel:w() - math.min(x - difficulty_name:w(), 0)))
          end
          pushout_met = x == l_1_4 and max_x or 0
        elseif l_1_4 and l_1_2.callout and self._crimenet_enabled then
          Application:debug(l_1_2.callout)
          managers.menu_component:post_event(l_1_2.callout, true)
        end
         -- Warning: missing end command somewhere! Added here
      end
      end
    local text_alpha = (l_62_2 == 1 and 1) or (l_62_2 == 2 and 0) or 1
    local object_alpha = (l_62_2 == 1 and 1) or (l_62_2 == 2 and 0.30000001192093) or 1
    local alphas = {object_alpha, text_alpha}
    local objects = {l_62_1.marker_panel, l_62_1.peers_panel}
    l_62_1.glow_panel:stop()
    if l_62_2 == 1 then
      managers.menu_component:post_event("highlight")
      l_62_1.side_panel:child("job_name"):set_blend_mode("normal")
      l_62_1.side_panel:child("contact_name"):set_blend_mode("normal")
      l_62_1.side_panel:child("info_name"):set_blend_mode("normal")
      l_62_1.side_panel:child("difficulty_name"):set_blend_mode("normal")
    else
      l_62_1.side_panel:child("job_name"):set_blend_mode("add")
      l_62_1.side_panel:child("contact_name"):set_blend_mode("add")
      l_62_1.side_panel:child("info_name"):set_blend_mode("add")
      l_62_1.side_panel:child("difficulty_name"):set_blend_mode("normal")
    end
    l_62_1.marker_panel:stop()
    if l_62_1.peers_panel and (l_62_2 ~= 1 or not 20) then
      l_62_1.peers_panel:set_layer(l_62_1.layer)
    end
    if l_62_2 ~= 1 or not 20 then
      l_62_1.marker_panel:set_layer(l_62_1.layer)
    end
    l_62_1.glow_panel:set_layer(l_62_1.marker_panel:layer() - 1)
    l_62_1.marker_panel:animate(animate_alpha, objects, l_62_1, alphas, l_62_2 == 1)
  end
end

CrimeNetGui.mouse_moved = function(l_63_0, l_63_1, l_63_2, l_63_3)
  if not l_63_0._crimenet_enabled then
    return 
  end
  if managers.menu:is_pc_controller() then
    if l_63_0._panel:child("back_button"):inside(l_63_2, l_63_3) then
      if not l_63_0._back_highlighted then
        l_63_0._back_highlighted = true
        l_63_0._panel:child("back_button"):set_color(tweak_data.screen_colors.button_stage_2)
        managers.menu_component:post_event("highlight")
      end
      return false, "arrow"
    elseif l_63_0._back_highlighted then
      l_63_0._back_highlighted = false
      l_63_0._panel:child("back_button"):set_color(tweak_data.screen_colors.button_stage_3)
    end
    if l_63_0._panel:child("legends_button"):inside(l_63_2, l_63_3) then
      if not l_63_0._legend_highlighted then
        l_63_0._legend_highlighted = true
        l_63_0._panel:child("legends_button"):set_color(tweak_data.screen_colors.button_stage_2)
        managers.menu_component:post_event("highlight")
      end
      return false, "arrow"
    elseif l_63_0._legend_highlighted then
      l_63_0._legend_highlighted = false
      l_63_0._panel:child("legends_button"):set_color(tweak_data.screen_colors.button_stage_3)
    end
    if l_63_0._panel:child("filter_button") then
      if l_63_0._panel:child("filter_button"):inside(l_63_2, l_63_3) then
        if not l_63_0._filter_highlighted then
          l_63_0._filter_highlighted = true
          l_63_0._panel:child("filter_button"):set_color(tweak_data.screen_colors.button_stage_2)
          managers.menu_component:post_event("highlight")
        end
        return false, "arrow"
      elseif l_63_0._filter_highlighted then
        l_63_0._filter_highlighted = false
        l_63_0._panel:child("filter_button"):set_color(tweak_data.screen_colors.button_stage_3)
      end
    end
  end
  if l_63_0._grabbed_map.x >= l_63_2 then
    local left = not l_63_0._grabbed_map
  end
  local right = not left
  local up = l_63_0._grabbed_map.y < l_63_3
  local down = not up
  local mx = l_63_2 - l_63_0._grabbed_map.x
  do
    local my = l_63_3 - l_63_0._grabbed_map.y
    if left and -l_63_0:_get_pan_panel_border() < l_63_0._map_panel:x() then
      mx = math.lerp(mx, 0, 1 - l_63_0._map_panel:x() / -l_63_0:_get_pan_panel_border())
    end
    if right and -l_63_0:_get_pan_panel_border() < l_63_0._fullscreen_panel:w() - l_63_0._map_panel:right() then
      mx = math.lerp(mx, 0, 1 - (l_63_0._fullscreen_panel:w() - l_63_0._map_panel:right()) / -l_63_0:_get_pan_panel_border())
    end
    if up and -l_63_0:_get_pan_panel_border() < l_63_0._map_panel:y() then
      my = math.lerp(my, 0, 1 - l_63_0._map_panel:y() / -l_63_0:_get_pan_panel_border())
    end
    if down and -l_63_0:_get_pan_panel_border() < l_63_0._fullscreen_panel:h() - l_63_0._map_panel:bottom() then
      my = math.lerp(my, 0, 1 - (l_63_0._fullscreen_panel:h() - l_63_0._map_panel:bottom()) / -l_63_0:_get_pan_panel_border())
    end
    table.insert(l_63_0._grabbed_map.dirs, 1, {mx, my})
    l_63_0._grabbed_map.dirs[10] = nil
    l_63_0:_set_map_position(mx, my)
    l_63_0._grabbed_map.x = l_63_2
    l_63_0._grabbed_map.y = l_63_3
    return true, "grab"
  end
  local closest_job = nil
  local closest_dist = 100000000
  local closest_job_x, closest_job_y = 0, 0
  local job_x, job_y = nil, nil
  local dist = 0
  local inside_any_job = false
  local math_x, math_y = nil, nil
  for id,job in pairs(l_63_0._jobs) do
    if job.marker_panel:child("select_panel"):inside(l_63_2, l_63_3) then
      local inside = l_63_0._panel:inside(l_63_2, l_63_3)
    end
    if not inside_any_job then
      inside_any_job = inside
    end
    if inside then
      job_x, job_y = job.marker_panel:child("select_panel"):world_center()
      math_x = job_x - l_63_2
      math_y = job_y - l_63_3
      dist = (math_x) * (math_x) + (math_y) * (math_y)
      if dist < closest_dist then
        closest_job = job
        closest_dist = dist
        closest_job_x = job_x
        closest_job_y = job_y
      end
    end
  end
  for id,job in pairs(l_63_0._jobs) do
    local inside = (job == closest_job and 1) or (inside_any_job and 2) or 3
    l_63_0:update_job_gui(job, inside)
  end
  if not managers.menu:is_pc_controller() then
    local to_left = l_63_2
    local to_right = l_63_0._panel:w() - l_63_2 - 19
    local to_top = l_63_3
    local to_bottom = l_63_0._panel:h() - l_63_3 - 23
    local panel_border = l_63_0._pan_panel_border
    to_left = 1 - math.clamp(to_left / panel_border, 0, 1)
    to_right = 1 - math.clamp(to_right / panel_border, 0, 1)
    to_top = 1 - math.clamp(to_top / panel_border, 0, 1)
    to_bottom = 1 - math.clamp(to_bottom / panel_border, 0, 1)
    local mouse_pointer_move_x = managers.mouse_pointer:mouse_move_x()
    local mouse_pointer_move_y = managers.mouse_pointer:mouse_move_y()
    local mp_left = -math.min(0, mouse_pointer_move_x)
    local mp_right = -math.max(0, mouse_pointer_move_x)
    local mp_top = -math.min(0, mouse_pointer_move_y)
    local mp_bottom = -math.max(0, mouse_pointer_move_y)
    local push_x = mp_left * (to_left) + mp_right * (to_right)
    local push_y = mp_top * (to_top) + mp_bottom * (to_bottom)
    if push_x ~= 0 or push_y ~= 0 then
      l_63_0:_set_map_position(push_x, push_y)
    end
  end
  if inside_any_job then
    return false, "arrow"
  end
  if l_63_0._panel:inside(l_63_2, l_63_3) then
    return false, "hand"
  end
end

CrimeNetGui.ps3_invites_callback = function(l_64_0)
  if managers.system_menu and managers.system_menu:is_active() and not managers.system_menu:is_closing() then
    return true
  end
  if managers.menu:active_menu() and managers.menu:active_menu().input:get_accept_input() then
    managers.menu:active_menu().renderer:disable_input(0.20000000298023)
    MenuCallbackHandler:view_invites()
  end
end

CrimeNetGui.enable_crimenet = function(l_65_0)
  l_65_0._crimenet_enabled = true
  managers.crimenet:activate()
  if l_65_0._ps3_invites_controller then
    l_65_0._ps3_invites_controller:set_enabled(true)
  end
end

CrimeNetGui.disable_crimenet = function(l_66_0)
  l_66_0._crimenet_enabled = false
  managers.crimenet:deactivate()
  if l_66_0._ps3_invites_controller then
    l_66_0._ps3_invites_controller:set_enabled(false)
  end
end

CrimeNetGui.close = function(l_67_0)
  managers.crimenet:stop()
  if l_67_0._crimenet_ambience then
    l_67_0._crimenet_ambience:stop()
    l_67_0._crimenet_ambience = nil
  end
  managers.menu_component:stop_event()
  managers.menu:active_menu().renderer.ws:show()
  l_67_0._ws:panel():remove(l_67_0._panel)
  l_67_0._fullscreen_ws:panel():remove(l_67_0._fullscreen_panel)
  Overlay:gui():destroy_workspace(l_67_0._blackborder_workspace)
  l_67_0._blackborder_workspace = nil
  if managers.controller:get_default_wrapper_type() ~= "pc" then
    managers.menu:active_menu().input:deactivate_controller_mouse()
    managers.mouse_pointer:release_mouse_pointer()
  end
  if l_67_0._ps3_invites_controller then
    l_67_0._ps3_invites_controller:set_enabled(false)
    l_67_0._ps3_invites_controller:destroy()
    l_67_0._ps3_invites_controller = nil
  end
end


