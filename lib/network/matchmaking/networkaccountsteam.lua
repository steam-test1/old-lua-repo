-- Decompiled using luadec 2.0.1 by sztupy (http://winmo.sztupy.hu)
-- Command line was: F:\SteamLibrary\SteamApps\common\PAYDAY 2\lua\lib\network\matchmaking\networkaccountsteam.luac 

require("lib/network/matchmaking/NetworkAccount")
if not NetworkAccountSTEAM then
  NetworkAccountSTEAM = class(NetworkAccount)
end
local l_0_0 = NetworkAccountSTEAM
local l_0_1 = {}
l_0_1.easy = "Easy"
l_0_1.normal = "Normal"
l_0_1.hard = "Hard"
l_0_1.overkill = "Overkill"
l_0_1.overkill_145 = "Overkill 145+"
l_0_0.lb_diffs = l_0_1
l_0_0 = NetworkAccountSTEAM
l_0_1 = {bank = "First World Bank", heat_street = "Heat Street"}
l_0_1.bridge = "Green Bridge"
l_0_1.apartment = "Panic Room"
l_0_1.slaughter_house = "Slaughterhouse"
l_0_1.diamond_heist = "Diamond Heist"
l_0_1.suburbia = "Counterfeit"
l_0_1.secret_stash = "Undercover"
l_0_1.hospital = "No Mercy"
l_0_0.lb_levels = l_0_1
l_0_0 = NetworkAccountSTEAM
l_0_1 = function(l_1_0)
  NetworkAccount.init(l_1_0)
  Steam:init()
  Steam:request_listener(NetworkAccountSTEAM._on_join_request, NetworkAccountSTEAM._on_server_request)
  Steam:error_listener(NetworkAccountSTEAM._on_disconnected, NetworkAccountSTEAM._on_ipc_fail, NetworkAccountSTEAM._on_connect_fail)
  Steam:overlay_listener(callback(l_1_0, l_1_0, "_on_open_overlay"), callback(l_1_0, l_1_0, "_on_close_overlay"))
  if Steam:overlay_open() then
    l_1_0:_on_open_overlay()
  end
  Steam:sa_handler():stats_store_callback(NetworkAccountSTEAM._on_stats_stored)
  Steam:sa_handler():init()
  l_1_0._masks = {}
  Steam:http_request("http://steamcommunity.com/gid/103582791433201592/memberslistxml/?xml=1", NetworkAccountSTEAM._on_troll_group_recieved)
  l_1_0:_set_presences()
  managers.savefile:add_load_done_callback(callback(l_1_0, l_1_0, "_load_done"))
  Steam:lb_handler():register_storage_done_callback(NetworkAccountSTEAM._on_leaderboard_stored)
  Steam:lb_handler():register_mappings_done_callback(NetworkAccountSTEAM._on_leaderboard_mapped)
  l_1_0:set_lightfx()
end

l_0_0.init = l_0_1
l_0_0 = NetworkAccountSTEAM
l_0_1 = function(l_2_0, ...)
  print("NetworkAccountSTEAM:_load_done()", ...)
  l_2_0:_set_presences()
   -- DECOMPILER ERROR: Confused about usage of registers for local variables.

end

l_0_0._load_done = l_0_1
l_0_0 = NetworkAccountSTEAM
l_0_1 = function(l_3_0)
  Steam:set_rich_presence("level", managers.experience:current_level())
  Steam:set_rich_presence("outfit", managers.blackmarket:outfit_string())
  Steam:set_rich_presence("pung", "ballers")
end

l_0_0._set_presences = l_0_1
l_0_0 = NetworkAccountSTEAM
l_0_1 = function(l_4_0, l_4_1)
  Steam:set_rich_presence("peer_id", l_4_1)
end

l_0_0.set_presences_peer_id = l_0_1
l_0_0 = NetworkAccountSTEAM
l_0_1 = function(l_5_0, l_5_1, l_5_2)
  local plays = Steam:sa_handler():get_global_stat(l_5_1 .. "_" .. l_5_2 .. "_plays", 30)
  local wins = Steam:sa_handler():get_global_stat(l_5_1 .. "_" .. l_5_2 .. "_wins", 30)
  local ratio = {}
  if #plays == 0 or #wins == 0 then
    return 
  end
  for i,plays_n in pairs(plays) do
    ratio[i] = wins[i] / (plays_n == 0 and 1 or plays_n)
  end
  table.sort(ratio)
  return ratio[#ratio / 2]
end

l_0_0.get_win_ratio = l_0_1
l_0_0 = NetworkAccountSTEAM
l_0_1 = function(l_6_0)
  if managers.user:get_setting("use_lightfx") then
    print("[NetworkAccountSTEAM:init] Initializing LightFX...")
    if LightFX:initialize() then
      l_6_0._has_alienware = LightFX:has_lamps()
    end
    if l_6_0._has_alienware then
      l_6_0._masks.alienware = true
      LightFX:set_lamps(0, 255, 0, 255)
    end
    print("[NetworkAccountSTEAM:init] Initializing LightFX done")
  else
    l_6_0._has_alienware = nil
    l_6_0._masks.alienware = nil
  end
end

l_0_0.set_lightfx = l_0_1
l_0_0 = NetworkAccountSTEAM
l_0_1 = function(l_7_0, l_7_1)
  return l_7_0._masks[l_7_1]
end

l_0_0.has_mask = l_0_1
l_0_0 = NetworkAccountSTEAM
l_0_1 = function(l_8_0, l_8_1)
  if l_8_0 and string.find(l_8_1, "<steamID64>" .. Steam:userid() .. "</steamID64>") then
    managers.network.account._masks.troll = true
  end
  Steam:http_request("http://steamcommunity.com/gid/103582791432592205/memberslistxml/?xml=1", NetworkAccountSTEAM._on_com_group_recieved)
end

l_0_0._on_troll_group_recieved = l_0_1
l_0_0 = NetworkAccountSTEAM
l_0_1 = function(l_9_0, l_9_1)
  if l_9_0 and string.find(l_9_1, "<steamID64>" .. Steam:userid() .. "</steamID64>") then
    managers.network.account._masks.hockey_com = true
  end
  Steam:http_request("http://steamcommunity.com/gid/103582791432508229/memberslistxml/?xml=1", NetworkAccountSTEAM._on_dev_group_recieved)
end

l_0_0._on_com_group_recieved = l_0_1
l_0_0 = NetworkAccountSTEAM
l_0_1 = function(l_10_0, l_10_1)
  if l_10_0 and string.find(l_10_1, "<steamID64>" .. Steam:userid() .. "</steamID64>") then
    managers.network.account._masks.developer = true
  end
end

l_0_0._on_dev_group_recieved = l_0_1
l_0_0 = NetworkAccountSTEAM
l_0_1 = function(l_11_0)
  return l_11_0._has_alienware
end

l_0_0.has_alienware = l_0_1
l_0_0 = NetworkAccountSTEAM
l_0_1 = function(l_12_0)
  if l_12_0._overlay_opened then
    return 
  end
  l_12_0._overlay_opened = true
  game_state_machine:_set_controller_enabled(false)
end

l_0_0._on_open_overlay = l_0_1
l_0_0 = NetworkAccountSTEAM
l_0_1 = function(l_13_0)
  if not l_13_0._overlay_opened then
    return 
  end
  l_13_0._overlay_opened = false
  game_state_machine:_set_controller_enabled(true)
end

l_0_0._on_close_overlay = l_0_1
l_0_0 = NetworkAccountSTEAM
l_0_1 = function(l_14_0)
  l_14_0._achievements_fetched = true
  l_14_0:_check_for_unawarded_achievements()
end

l_0_0.achievements_fetched = l_0_1
l_0_0 = NetworkAccountSTEAM
l_0_1 = function(l_15_0)
  l_15_0._challenges_loaded = true
  l_15_0:_check_for_unawarded_achievements()
end

l_0_0.challenges_loaded = l_0_1
l_0_0 = NetworkAccountSTEAM
l_0_1 = function(l_16_0)
  l_16_0._experience_loaded = true
  l_16_0:_check_for_unawarded_achievements()
end

l_0_0.experience_loaded = l_0_1
l_0_0 = NetworkAccountSTEAM
l_0_1 = function(l_17_0)
end

l_0_0._check_for_unawarded_achievements = l_0_1
l_0_0 = NetworkAccountSTEAM
l_0_1 = function(l_18_0)
  print("[NetworkAccountSTEAM:_on_leaderboard_stored] Leaderboard stored, ", l_18_0, ".")
end

l_0_0._on_leaderboard_stored = l_0_1
l_0_0 = NetworkAccountSTEAM
l_0_1 = function()
  print("[NetworkAccountSTEAM:_on_leaderboard_stored] Leaderboard mapped.")
  Steam:lb_handler():request_storage()
end

l_0_0._on_leaderboard_mapped = l_0_1
l_0_0 = NetworkAccountSTEAM
l_0_1 = function(l_20_0)
  print("[NetworkAccountSTEAM:_on_stats_stored] Statistics stored, ", l_20_0, ". Publishing leaderboard score to Steam!")
  local leaderboard_to_publish = managers.network.account._leaderboard_to_publish
  if not leaderboard_to_publish then
    return 
  end
  local diff_id = leaderboard_to_publish[1]
  local lvl_id = leaderboard_to_publish[2]
  local diff_name = NetworkAccountSTEAM.lb_diffs[diff_id]
  local lvl_name = NetworkAccountSTEAM.lb_levels[lvl_id]
  Steam:lb_handler():register_mappings({lvl_name .. ": " .. diff_name = diff_id .. "_" .. lvl_id .. "_time"})
  managers.network.account._leaderboard_to_publish = nil
end

l_0_0._on_stats_stored = l_0_1
l_0_0 = NetworkAccountSTEAM
l_0_1 = function(l_21_0, l_21_1, l_21_2)
  do return end
  if managers.dlc:is_trial() then
    return 
  end
  local handler = Steam:sa_handler()
  print("[NetworkAccountSTEAM:publish_statistics] Publishing statistics to Steam!")
  if not handler:initialized() then
    print("[NetworkAccountSTEAM:publish_statistics] Error, SA handler not initialized! Not sending stats.")
    return 
  end
  if l_21_2 and not managers.statistics:is_dropin() then
    l_21_0._leaderboard_to_publish = {Global.game_settings.difficulty, Global.level_data.level_id}
  end
  local err = false
  for key,stat in pairs(l_21_1) do
    local res = nil
    if stat.type == "int" then
      local val = handler:get_stat(key)
      if stat.method == "lowest" then
        if stat.value < val then
          res = handler:set_stat(key, stat.value)
        else
          res = true
        end
      elseif stat.method == "highest" then
        if val < stat.value then
          res = handler:set_stat(key, stat.value)
        else
          res = true
        end
      elseif stat.method == "set" then
        res = handler:set_stat(key, stat.value)
      elseif stat.value > 0 then
        local mval = val / 1000 + stat.value / 1000
        if mval >= 2147483 then
          Application:error("[NetworkAccountSTEAM:publish_statistics] Warning, trying to set too high a value on stat " .. key)
          res = handler:set_stat(key, 2147483008)
        else
          res = handler:set_stat(key, val + stat.value)
        end
      else
        res = true
      end
    elseif stat.type == "float" then
      if stat.value > 0 then
        local val = handler:get_stat_float(key)
        res = handler:set_stat_float(key, val + stat.value)
      else
        res = true
      end
    elseif stat.type == "avgrate" then
      res = handler:set_stat_float(key, stat.value, stat.hours)
    end
    if not res then
      Application:error("[NetworkAccountSTEAM:publish_statistics] Error, could not set stat " .. key)
      err = true
    end
  end
  if Application:production_build() then
    l_21_0._leaderboard_to_publish = nil
    return 
  end
  if not err then
    handler:store_data()
  end
end

l_0_0.publish_statistics = l_0_1
l_0_0 = NetworkAccountSTEAM
l_0_1 = function(l_22_0, l_22_1)
  print("[NetworkAccountSTEAM._on_disconnected]", l_22_0, l_22_1)
  Application:warn("Disconnected from Steam!! Please wait", 12)
end

l_0_0._on_disconnected = l_0_1
l_0_0 = NetworkAccountSTEAM
l_0_1 = function(l_23_0, l_23_1)
  print("[NetworkAccountSTEAM._on_ipc_fail]")
end

l_0_0._on_ipc_fail = l_0_1
l_0_0 = NetworkAccountSTEAM
l_0_1 = function(l_24_0, l_24_1)
  print("[NetworkAccountSTEAM._on_join_request]")
  if managers.network:session() and (managers.network:session():_local_peer_in_lobby() or managers.network:game()) then
    managers.menu:show_cant_join_from_game_dialog()
  else
    if not Global.user_manager.user_index or not Global.user_manager.active_user_state_change_quit then
      print("BOOT UP INVITE")
      Global.boot_invite = l_24_0
      return 
    end
    Global.game_settings.single_player = false
    managers.network.matchmake:join_server_with_check(l_24_0, true)
  end
end

l_0_0._on_join_request = l_0_1
l_0_0 = NetworkAccountSTEAM
l_0_1 = function(l_25_0, l_25_1)
  print("[NetworkAccountSTEAM._on_server_request]")
end

l_0_0._on_server_request = l_0_1
l_0_0 = NetworkAccountSTEAM
l_0_1 = function(l_26_0, l_26_1)
  print("[NetworkAccountSTEAM._on_connect_fail]")
end

l_0_0._on_connect_fail = l_0_1
l_0_0 = NetworkAccountSTEAM
l_0_1 = function(l_27_0)
  if l_27_0:local_signin_state() == true then
    return "signed in"
  end
  return "not signed in"
end

l_0_0.signin_state = l_0_1
l_0_0 = NetworkAccountSTEAM
l_0_1 = function(l_28_0)
  return Steam:logged_on()
end

l_0_0.local_signin_state = l_0_1
l_0_0 = NetworkAccountSTEAM
l_0_1 = function(l_29_0)
  return Steam:username()
end

l_0_0.username_id = l_0_1
l_0_0 = NetworkAccountSTEAM
l_0_1 = function(l_30_0)
  return Steam:userid()
end

l_0_0.player_id = l_0_1
l_0_0 = NetworkAccountSTEAM
l_0_1 = function(l_31_0)
  return true
end

l_0_0.is_connected = l_0_1
l_0_0 = NetworkAccountSTEAM
l_0_1 = function(l_32_0)
  return true
end

l_0_0.lan_connection = l_0_1
l_0_0 = NetworkAccountSTEAM
l_0_1 = function(l_33_0)
  local num_days = 100
  local sa = Steam:sa_handler()
  local invalid = sa:get_global_stat("easy_slaughter_house_plays", num_days)
  invalid[1] = 1
  invalid[3] = 1
  invalid[11] = 1
  invalid[12] = 1
  invalid[19] = 1
  invalid[28] = 1
  invalid[51] = 1
  invalid[57] = 1
  local get_lvl_stat = function(l_1_0, l_1_1, l_1_2, l_1_3)
    if l_1_3 == 0 then
      local st = NetworkAccountSTEAM.lb_levels[l_1_1] .. ", " .. NetworkAccountSTEAM.lb_diffs[l_1_0] .. " - "
      if type(l_1_2) == "string" then
        return st .. l_1_2
      else
        return st .. l_1_2[1] .. "/" .. l_1_2[2]
      end
    end
    local num = nil
    if not sa:get_global_stat(l_1_0 .. "_" .. l_1_1 .. "_" .. l_1_2, num_days)[l_1_3] then
      num = type(l_1_2) ~= "string" or 0
    end
    do return end
    local f = sa:get_global_stat(l_1_0 .. "_" .. l_1_1 .. "_" .. l_1_2[1], num_days)[l_1_3] or 0
    do
      local s = sa:get_global_stat(l_1_0 .. "_" .. l_1_1 .. "_" .. l_1_2[2], num_days)[l_1_3] or 1
      num = f / (s == 0 and 1 or s)
    end
    return num
   end
  local get_weapon_stat = function(l_2_0, l_2_1, l_2_2)
    if l_2_2 == 0 then
      local st = l_2_0 .. " - "
      if type(l_2_1) == "string" then
        return st .. l_2_1
      else
        return st .. l_2_1[1] .. "/" .. l_2_1[2]
      end
    end
    local num = nil
    if not sa:get_global_stat(l_2_0 .. "_" .. l_2_1, num_days)[l_2_2] then
      num = type(l_2_1) ~= "string" or 0
    end
    do return end
    local f = sa:get_global_stat(l_2_0 .. "_" .. l_2_1[1], num_days)[l_2_2] or 0
    do
      local s = sa:get_global_stat(l_2_0 .. "_" .. l_2_1[2], num_days)[l_2_2] or 1
      num = f / (s == 0 and 1 or s)
    end
    return num
   end
  local diffs = {"easy", "normal", "hard", "overkill", "overkill_145"}
  local heists = {"bank", "heat_street", "bridge", "apartment", "slaughter_house", "diamond_heist"}
  local weapons = {"beretta92", "c45", "raging_bull", "r870_shotgun", "mossberg", "m4", "mp5", "mac11", "m14", "hk21"}
  local lvl_stats = {"plays", {"wins", "plays"}, {"kills", "plays"}}
  local wep_stats = {"kills", {"kills", "shots"}, {"headshots", "shots"}}
  local lines = {}
  for i = 0, #invalid do
    if i == 0 or invalid[i] == 0 then
      local out = "" .. i
      for _,lvl_stat in ipairs(lvl_stats) do
        for _,diff in ipairs(diffs) do
          for _,heist in ipairs(heists) do
            out = out .. ";" .. get_lvl_stat(diff, heist, lvl_stat, i)
          end
        end
      end
      for _,wep_stat in ipairs(wep_stats) do
        for _,weapon in ipairs(weapons) do
          out = out .. ";" .. get_weapon_stat(weapon, wep_stat, i)
        end
      end
      table.insert(lines, out)
    end
  end
  local file_handle = SystemFS:open(l_33_0, "w")
  for i = 1, #lines do
    if i ~= 1 or not 1 then
      file_handle:puts(lines[#lines - i + 2])
    end
  end
end

l_0_0.output_global_stats = l_0_1

