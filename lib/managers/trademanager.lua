-- Decompiled using luadec 2.0.1 by sztupy (http://winmo.sztupy.hu)
-- Command line was: F:\SteamLibrary\SteamApps\common\PAYDAY 2\lua\lib\managers\trademanager.luac 

if not TradeManager then
  TradeManager = class()
end
TradeManager.init = function(l_1_0)
  l_1_0._criminals_to_respawn = {}
  l_1_0._criminals_to_add = {}
  l_1_0._trade_counter_tick = 1
  l_1_0._num_trades = 0
  l_1_0:set_trade_countdown(true)
end

TradeManager.save = function(l_2_0, l_2_1)
  if not next(l_2_0._criminals_to_respawn) then
    return 
  end
  local my_save_data = {}
  l_2_1.trade = my_save_data
  my_save_data.criminals = l_2_0._criminals_to_respawn
  my_save_data.outfits = {}
  for _,crim in ipairs(l_2_0._criminals_to_respawn) do
    if crim.peer_id then
      my_save_data.outfits[crim.peer_id] = managers.network:session():peer(crim.peer_id):profile("outfit_string")
    end
  end
end

TradeManager.load = function(l_3_0, l_3_1)
  do
    local my_load_data = l_3_1.trade
    if not my_load_data then
      return 
    end
    l_3_0._criminals_to_respawn = my_load_data.criminals
    l_3_0._criminals_to_add = {}
    for _,crim in ipairs(l_3_0._criminals_to_respawn) do
      if not crim.ai and not managers.network:session():peer(crim.peer_id) and crim.peer_id then
        l_3_0._criminals_to_add[crim.peer_id] = crim
        local peer = managers.network:session():peer(crim.peer_id)
        do
          local outfit = my_load_data.outfits[crim.peer_id]
          crim.outfit = outfit
        end
        for (for control),_ in (for generator) do
          if crim.peer_id then
            local peer = managers.network:session():peer(crim.peer_id)
            local outfit = my_load_data.outfits[crim.peer_id]
            peer:set_outfit_string(outfit)
          end
          managers.criminals:add_character(crim.id, nil, crim.peer_id, crim.ai)
        end
      end
    end
     -- Warning: missing end command somewhere! Added here
  end
end

TradeManager.handshake_complete = function(l_4_0, l_4_1)
  local crim = l_4_0._criminals_to_add[l_4_1]
  if crim then
    local peer = managers.network:session():peer(l_4_1)
    peer:set_outfit_string(crim.outfit)
    managers.criminals:add_character(crim.id, nil, crim.peer_id, crim.ai)
    l_4_0._criminals_to_add[l_4_1] = nil
  end
end

TradeManager.is_peer_in_custody = function(l_5_0, l_5_1)
  for _,crim in ipairs(l_5_0._criminals_to_respawn) do
    if crim.peer_id == l_5_1 then
      return true
    end
  end
end

TradeManager.is_criminal_in_custody = function(l_6_0, l_6_1)
  for _,crim in ipairs(l_6_0._criminals_to_respawn) do
    if crim.id == l_6_1 then
      return true
    end
  end
end

TradeManager.respawn_delay_by_name = function(l_7_0, l_7_1)
  for _,crim in ipairs(l_7_0._criminals_to_respawn) do
    if crim.id == l_7_1 then
      return crim.respawn_penalty
    end
  end
  return 0
end

TradeManager.hostages_killed_by_name = function(l_8_0, l_8_1)
  for _,crim in ipairs(l_8_0._criminals_to_respawn) do
    if crim.id == l_8_1 then
      return crim.hostages_killed
    end
  end
  return 0
end

TradeManager.update = function(l_9_0, l_9_1, l_9_2)
  l_9_0._t = l_9_1
  if not managers.criminals or not managers.hud then
    return 
  end
  if not l_9_0._hostage_remind_t or l_9_0._hostage_remind_t < l_9_1 then
    if not l_9_0._trading_hostage and not l_9_0._hostage_trade_clbk and #l_9_0._criminals_to_respawn > 0 and managers.groupai:state():hostage_count() <= 0 and managers.groupai:state():is_AI_enabled() and managers.groupai:state():bain_state() then
      local cable_tie_data = managers.player:has_special_equipment("cable_tie")
      if cable_tie_data and Application:digest_value(cable_tie_data.amount, false) > 0 then
        managers.dialog:queue_dialog("ban_h01x", {})
      else
        if l_9_0:get_criminal_to_trade() ~= nil then
          managers.dialog:queue_dialog("Play_ban_h22x", {})
        end
      end
    end
    l_9_0._hostage_remind_t = l_9_1 + math.random(60, 120)
  end
  l_9_0._trade_counter_tick = l_9_0._trade_counter_tick - l_9_2
  if l_9_0._trade_counter_tick <= 0 then
    l_9_0._trade_counter_tick = l_9_0._trade_counter_tick + 1
    if l_9_0._hostage_to_trade and not alive(l_9_0._hostage_to_trade.unit) then
      l_9_0:cancel_trade()
    end
    for _,crim in ipairs(l_9_0._criminals_to_respawn) do
      local crim_data = managers.criminals:character_data_by_name(crim.id)
      if crim_data then
        local mugshot_id = crim_data.mugshot_id
      end
      if mugshot_id then
        local mugshot_data = managers.hud:_get_mugshot_data(mugshot_id)
      end
      if mugshot_data and not mugshot_data.state_name ~= "mugshot_in_custody" then
        managers.hud:set_mugshot_custody(mugshot_id)
        if crim.respawn_penalty > 0 then
          managers.hud:show_mugshot_timer(mugshot_id)
        end
      end
      if crim.respawn_penalty > 0 then
        if not l_9_0._trade_countdown or not crim.respawn_penalty - 1 then
          crim.respawn_penalty = crim.respawn_penalty
        end
        managers.hud:set_mugshot_timer(mugshot_id, crim.respawn_penalty)
        if crim.respawn_penalty <= 0 then
          crim.respawn_penalty = 0
          managers.hud:hide_mugshot_timer(mugshot_id)
        end
      end
    end
  end
  if l_9_0._trade_countdown and Network:is_server() and not l_9_0._trading_hostage and not l_9_0._hostage_trade_clbk and #l_9_0._criminals_to_respawn > 0 and not Global.game_settings.single_player and l_9_0:get_criminal_to_trade() then
    if managers.groupai:state():hostage_count() <= 0 then
      do return end
    end
    l_9_0._cancel_trade = nil
    local respawn_t = l_9_0._t + math.random(2, 5)
    local clbk_id = "begin_hostage_trade_dialog"
    l_9_0._hostage_trade_clbk = clbk_id
    managers.enemy:add_delayed_clbk(clbk_id, callback(l_9_0, l_9_0, "begin_hostage_trade_dialog", 1), respawn_t)
  end
end

TradeManager.num_in_trade_queue = function(l_10_0)
  return #l_10_0._criminals_to_respawn
end

TradeManager.get_criminal_to_trade = function(l_11_0)
  for _,crim in ipairs(l_11_0._criminals_to_respawn) do
    if crim.respawn_penalty <= 0 then
      return crim
    end
  end
end

TradeManager.sync_set_trade_death = function(l_12_0, l_12_1, l_12_2, l_12_3, l_12_4)
  if not l_12_4 then
    local crim_data = managers.criminals:character_data_by_name(l_12_1)
    if not crim_data then
      return 
    end
    if crim_data.ai then
      l_12_0:on_AI_criminal_death(l_12_1, l_12_2, l_12_3)
    else
      l_12_0:on_player_criminal_death(l_12_1, l_12_2, l_12_3)
    end
  end
  l_12_0:play_custody_voice(l_12_1)
  if managers.criminals:local_character_name() == l_12_1 and not Network:is_server() and game_state_machine:current_state_name() == "ingame_waiting_for_respawn" then
    game_state_machine:current_state():trade_death(l_12_2, l_12_3)
  end
end

TradeManager._announce_spawn = function(l_13_0, l_13_1)
  if not managers.groupai:state():bain_state() then
    return 
  end
  local character_code = managers.criminals:character_static_data_by_name(l_13_1).ssuffix
  managers.dialog:queue_dialog("ban_q02" .. character_code, {})
end

TradeManager.sync_set_trade_spawn = function(l_14_0, l_14_1)
  local crim_data = managers.criminals:character_data_by_name(l_14_1)
  l_14_0:_announce_spawn(l_14_1)
  l_14_0._num_trades = l_14_0._num_trades + 1
  if crim_data then
    managers.hud:hide_mugshot_timer(crim_data.mugshot_id)
    managers.hud:set_mugshot_normal(crim_data.mugshot_id)
  end
  for i,crim in ipairs(l_14_0._criminals_to_respawn) do
    if crim.id == l_14_1 then
      table.remove(l_14_0._criminals_to_respawn, i)
  else
    end
  end
end

TradeManager.sync_set_trade_replace = function(l_15_0, l_15_1, l_15_2, l_15_3, l_15_4)
  if l_15_1 then
    l_15_0:replace_ai_with_player(l_15_2, l_15_3, l_15_4)
  else
    l_15_0:replace_player_with_ai(l_15_2, l_15_3, l_15_4)
  end
end

TradeManager.play_custody_voice = function(l_16_0, l_16_1)
  if managers.criminals:local_character_name() == l_16_1 then
    return 
  end
  if #l_16_0._criminals_to_respawn == 3 then
    local criminal_left = nil
    for _,crim_data in pairs(managers.groupai:state():all_char_criminals()) do
      if not crim_data.unit:movement():downed() then
        criminal_left = managers.criminals:character_name_by_unit(crim_data.unit)
    else
      end
    end
    if managers.criminals:local_character_name() == criminal_left then
      managers.achievment:set_script_data("last_man_standing", true)
      if managers.groupai:state():bain_state() then
        local character_code = managers.criminals:character_static_data_by_name(criminal_left).ssuffix
        managers.dialog:queue_dialog("Play_ban_i20" .. character_code, {})
      end
      return 
    end
  end
  if managers.groupai:state():bain_state() then
    local character_code = managers.criminals:character_static_data_by_name(l_16_1).ssuffix
    managers.dialog:queue_dialog("Play_ban_h11" .. character_code, {})
  end
end

TradeManager.on_AI_criminal_death = function(l_17_0, l_17_1, l_17_2, l_17_3, l_17_4)
  print("[TradeManager:on_AI_criminal_death]", l_17_1, l_17_2, l_17_3, l_17_4)
  if not managers.hud then
    return 
  end
  local crim_data = managers.criminals:character_data_by_name(l_17_1)
  if crim_data then
    managers.hud:set_mugshot_custody(crim_data.mugshot_id)
    managers.hud:set_mugshot_timer(crim_data.mugshot_id, l_17_2)
    managers.hud:show_mugshot_timer(crim_data.mugshot_id)
  end
  local crim = {id = l_17_1, ai = true, respawn_penalty = l_17_2, hostages_killed = l_17_3}
  table.insert(l_17_0._criminals_to_respawn, crim)
  if Network:is_server() and not l_17_4 then
    managers.network:session():send_to_peers("set_trade_death", l_17_1, l_17_2, l_17_3)
    l_17_0:sync_set_trade_death(l_17_1, l_17_2, l_17_3, true)
  end
  return crim
end

TradeManager.on_player_criminal_death = function(l_18_0, l_18_1, l_18_2, l_18_3, l_18_4)
  for _,crim in ipairs(l_18_0._criminals_to_respawn) do
    if crim.id == l_18_1 then
      debug_pause("[TradeManager:on_player_criminal_death] criminal already dead", l_18_1)
      return 
    end
  end
  if tweak_data.player.damage.automatic_respawn_time then
    l_18_2 = math.min(l_18_2, tweak_data.player.damage.automatic_respawn_time)
  end
  local crim_data = managers.criminals:character_data_by_name(l_18_1)
  if crim_data then
    if managers.hud then
      managers.hud:set_mugshot_custody(crim_data.mugshot_id)
      managers.hud:set_mugshot_timer(crim_data.mugshot_id, l_18_2)
      managers.hud:show_mugshot_timer(crim_data.mugshot_id)
    else
      debug_pause("[TradeManager:on_player_criminal_death] no hud manager! criminal_name:", l_18_1)
    end
  end
  local crim = {id = l_18_1, ai = false, respawn_penalty = l_18_2, hostages_killed = l_18_3, peer_id = managers.criminals:character_peer_id_by_name(l_18_1)}
  local inserted = false
  for i,crim_to_respawn in ipairs(l_18_0._criminals_to_respawn) do
    if crim_to_respawn.ai or l_18_2 < crim_to_respawn.respawn_penalty then
      table.insert(l_18_0._criminals_to_respawn, i, crim)
      inserted = true
  else
    end
  end
  if not inserted then
    table.insert(l_18_0._criminals_to_respawn, crim)
  end
  if Network:is_server() and not l_18_4 then
    managers.network:session():send_to_peers("set_trade_death", l_18_1, l_18_2, l_18_3)
    l_18_0:sync_set_trade_death(l_18_1, l_18_2, l_18_3, true)
  end
  print("[TradeManager:on_player_criminal_death]", l_18_1, ". Respawn queue:")
  for i,crim_to_respawn in ipairs(l_18_0._criminals_to_respawn) do
    print(inspect(crim_to_respawn))
  end
  return crim
end

TradeManager.set_trade_countdown = function(l_19_0, l_19_1)
  l_19_0._trade_countdown = l_19_1
  if Network:is_server() and managers.network then
    managers.network:session():send_to_peers("set_trade_countdown", l_19_1)
  end
end

TradeManager.replace_ai_with_player = function(l_20_0, l_20_1, l_20_2, l_20_3)
  print("[TradeManager:replace_ai_with_player]", l_20_1)
  local first_crim = l_20_0._criminals_to_respawn[1]
  if first_crim and first_crim.id == l_20_1 then
    l_20_0:cancel_trade()
  end
  local respawn_penalty, hostages_killed = nil, nil
  for i,c in ipairs(l_20_0._criminals_to_respawn) do
    if c.id == l_20_1 then
      if not l_20_3 then
        respawn_penalty = c.respawn_penalty
      end
      hostages_killed = c.hostages_killed
      table.remove(l_20_0._criminals_to_respawn, i)
  else
    end
  end
  if respawn_penalty then
    if respawn_penalty <= 0 then
      respawn_penalty = 1
    end
    return l_20_0:on_player_criminal_death(l_20_2, respawn_penalty, hostages_killed, true)
  end
end

TradeManager.replace_player_with_ai = function(l_21_0, l_21_1, l_21_2, l_21_3)
  print("[TradeManager:replace_player_with_ai] replacing", l_21_1, "with", l_21_2, "penalty", l_21_3, "\n respawn queue:", inspect(l_21_0._criminals_to_respawn))
  local first_crim = l_21_0._criminals_to_respawn[1]
  if first_crim and first_crim.id == l_21_1 then
    l_21_0:cancel_trade()
  end
  local respawn_penalty, hostages_killed = nil, nil
  for i,c in ipairs(l_21_0._criminals_to_respawn) do
    if c.id == l_21_1 then
      if not l_21_3 then
        respawn_penalty = c.respawn_penalty
      end
      hostages_killed = c.hostages_killed
      print("replacing player in custody. respawn_penalty", respawn_penalty, ". hostages_killed", hostages_killed)
      table.remove(l_21_0._criminals_to_respawn, i)
  else
    end
  end
  if respawn_penalty then
    if respawn_penalty <= 0 then
      respawn_penalty = 1
    end
    print("managers.criminals:nr_AI_criminals()", managers.criminals:nr_AI_criminals())
    if managers.groupai:state():team_ai_enabled() and managers.groupai:state():is_AI_enabled() and managers.criminals:nr_AI_criminals() <= CriminalsManager.MAX_NR_TEAM_AI then
      return l_21_0:on_AI_criminal_death(l_21_2, respawn_penalty, hostages_killed, true)
    end
  end
end

TradeManager.remove_from_trade = function(l_22_0, l_22_1)
  local first_crim = l_22_0._criminals_to_respawn[1]
  if first_crim and first_crim.id == l_22_1 then
    l_22_0:cancel_trade()
  end
  for i,c in ipairs(l_22_0._criminals_to_respawn) do
    if c.id == l_22_1 then
      table.remove(l_22_0._criminals_to_respawn, i)
  else
    end
  end
end

TradeManager._send_finish_trade = function(l_23_0, l_23_1, l_23_2, l_23_3)
  if l_23_1.ai == true then
    return 
  end
  local peer_id = managers.criminals:character_peer_id_by_name(l_23_1.id)
   -- DECOMPILER ERROR: unhandled construct in 'if'

  if peer_id == 1 and game_state_machine:current_state_name() == "ingame_waiting_for_respawn" then
    game_state_machine:current_state():finish_trade()
    do return end
    local peer = managers.network:session():peer(peer_id)
    if peer then
      peer:send_queued_sync("finish_trade")
    end
  end
end

TradeManager._send_begin_trade = function(l_24_0, l_24_1)
  if l_24_1.ai == true then
    return 
  end
  local peer_id = managers.criminals:character_peer_id_by_name(l_24_1.id)
   -- DECOMPILER ERROR: unhandled construct in 'if'

  if peer_id == 1 and game_state_machine:current_state_name() == "ingame_waiting_for_respawn" then
    game_state_machine:current_state():begin_trade()
    do return end
    local peer = managers.network:session():peer(peer_id)
    if peer then
      peer:send_queued_sync("begin_trade")
    end
  end
end

TradeManager._send_cancel_trade = function(l_25_0, l_25_1)
  if l_25_1.ai == true then
    return 
  end
  local peer_id = managers.criminals:character_peer_id_by_name(l_25_1.id)
   -- DECOMPILER ERROR: unhandled construct in 'if'

  if peer_id == 1 and game_state_machine:current_state_name() == "ingame_waiting_for_respawn" then
    game_state_machine:current_state():cancel_trade()
    do return end
    local peer = managers.network:session():peer(peer_id)
    if peer then
      peer:send_queued_sync("cancel_trade")
    end
  end
end

TradeManager.change_hostage = function(l_26_0)
  l_26_0:sync_hostage_trade_dialog(6)
  managers.network:session():send_to_peers("hostage_trade_dialog", 6)
  l_26_0:cancel_trade()
end

TradeManager.cancel_trade = function(l_27_0)
  if not next(managers.groupai:state():all_player_criminals()) then
    return 
  end
  l_27_0._trading_hostage = nil
  if #l_27_0._criminals_to_respawn > 0 then
    l_27_0:_send_cancel_trade(l_27_0._criminals_to_respawn[1])
  end
  if l_27_0._hostage_trade_clbk then
    l_27_0._cancel_trade = true
  end
  if l_27_0._hostage_to_trade and alive(l_27_0._hostage_to_trade.unit) then
    l_27_0._hostage_to_trade.unit:brain():cancel_trade()
  end
  l_27_0._hostage_to_trade = nil
end

TradeManager._get_megaphone_sound_source = function(l_28_0)
  local level_id = Global.level_data.level_id
  local pos = nil
  if not level_id then
    pos = Vector3(0, 0, 0)
    Application:error("[TradeManager:_get_megaphone_sound_source] This level has no megaphone position!")
  else
    if not tweak_data.levels[level_id].megaphone_pos then
      pos = Vector3(0, 0, 0)
    else
      pos = tweak_data.levels[level_id].megaphone_pos
    end
  end
  local sound_source = SoundDevice:create_source("megaphone")
  sound_source:set_position(pos)
  return sound_source
end

TradeManager.sync_hostage_trade_dialog = function(l_29_0, l_29_1)
  if game_state_machine:current_state_name() == "ingame_waiting_for_respawn" or not managers.groupai:state():bain_state() then
    return 
  end
  if l_29_1 == 1 then
    print("Playing mga_t01a_con_plu")
    l_29_0:_get_megaphone_sound_source():post_event("mga_t01a_con_plu")
  elseif l_29_1 == 2 then
    managers.dialog:queue_dialog("ban_h02a", {})
  elseif l_29_1 == 3 then
    managers.dialog:queue_dialog("ban_h02b", {})
  elseif l_29_1 == 4 then
    managers.dialog:queue_dialog("ban_h02c", {})
  elseif l_29_1 == 5 then
    managers.dialog:queue_dialog("ban_h02d", {})
  elseif l_29_1 == 6 then
    managers.dialog:queue_dialog("Play_ban_h50x", {})
  end
end

TradeManager.begin_hostage_trade_dialog = function(l_30_0, l_30_1)
  print("begin_hostage_trade_dialog", l_30_1)
  if l_30_0._cancel_trade then
    l_30_0._hostage_trade_clbk = nil
    l_30_0._cancel_trade = nil
    return 
  end
  local respawn_criminal = l_30_0:get_criminal_to_trade()
  if not respawn_criminal then
    return 
  end
  if l_30_1 == 1 then
    l_30_0._megaphone_sound_source = l_30_0:_get_megaphone_sound_source()
    print("Snd: megaphone", l_30_0._megaphone_sound_source)
    if not l_30_0._megaphone_sound_source:post_event("mga_t01a_con_plu", (callback(l_30_0, l_30_0, "begin_hostage_trade_dialog", 2)), nil, "end_of_event") then
      l_30_0:begin_hostage_trade_dialog(2)
      print("Megaphone fail")
    elseif l_30_1 == 2 then
      local ssuffix = managers.criminals:character_static_data_by_name(respawn_criminal.id).ssuffix
      if ssuffix == "a" then
        l_30_1 = 2
      elseif ssuffix == "b" then
        l_30_1 = 3
      elseif ssuffix == "c" then
        l_30_1 = 4
      elseif ssuffix == "d" then
        l_30_1 = 5
      end
      l_30_0:sync_hostage_trade_dialog(l_30_1)
      local respawn_t = l_30_0._t + 5
      managers.enemy:add_delayed_clbk(l_30_0._hostage_trade_clbk, callback(l_30_0, l_30_0, "begin_hostage_trade"), respawn_t)
    end
  end
  managers.network:session():send_to_peers("hostage_trade_dialog", l_30_1)
end

TradeManager.begin_hostage_trade = function(l_31_0)
  if l_31_0._cancel_trade then
    l_31_0._hostage_trade_clbk = nil
    l_31_0._cancel_trade = nil
    return 
  end
  l_31_0._hostage_trade_clbk = nil
  l_31_0:_send_begin_trade(l_31_0._criminals_to_respawn[1])
  local possible_criminals = {}
  for u_key,u_data in pairs(managers.groupai:state():all_player_criminals()) do
    if u_data.status ~= "dead" then
      table.insert(possible_criminals, u_key)
    end
  end
  local rescuing_criminal = possible_criminals[math.random(1, #possible_criminals)]
  rescuing_criminal = managers.groupai:state():all_criminals()[rescuing_criminal]
  local rescuing_criminal_pos = nil
  local civilians = managers.enemy:all_civilians()
  if rescuing_criminal then
    rescuing_criminal_pos = rescuing_criminal.m_pos
  else
    local _, first_civ = next(civilians)
    if first_civ then
      rescuing_criminal_pos = first_civ.m_pos
    end
  end
  local trade_dist = tweak_data.group_ai.optimal_trade_distance
  local optimal_trade_dist = math.random(trade_dist[1], trade_dist[2])
  optimal_trade_dist = optimal_trade_dist * optimal_trade_dist
  do
    local best_hostage_d, best_hostage = nil, nil
    for _,h_key in ipairs(managers.groupai:state():all_hostages()) do
      local civ = civilians[h_key]
      if civ and civ.unit:character_damage():pickup() then
        civ = nil
      end
      if not civ then
        local hostage = managers.enemy:all_enemies()[h_key]
      end
      if hostage then
        local d = math.abs(mvector3.distance_sq(hostage.m_pos, rescuing_criminal_pos) - optimal_trade_dist)
        if not best_hostage_d or d < best_hostage_d then
          best_hostage_d = d
          best_hostage = hostage
        end
      end
    end
    if best_hostage then
      l_31_0._trading_hostage = true
      l_31_0._hostage_to_trade = best_hostage
      best_hostage.unit:brain():set_logic("trade")
  end
  if not rescuing_criminal then
    end
  end
end

TradeManager.on_hostage_traded = function(l_32_0, l_32_1)
  print("RC: Traded hostage!!")
  if l_32_0._criminal_respawn_clbk then
    return 
  end
  l_32_0._hostage_to_trade = nil
  local respawn_criminal = l_32_0:get_criminal_to_trade()
  local respawn_delay = respawn_criminal.respawn_penalty
  l_32_0:_send_finish_trade(respawn_criminal, respawn_delay, respawn_criminal.hostages_killed)
  local respawn_t = l_32_0._t + 2
  local clbk_id = "Respawn_criminal_on_trade"
  l_32_0._criminal_respawn_clbk = clbk_id
  managers.enemy:add_delayed_clbk(clbk_id, callback(l_32_0, l_32_0, "clbk_respawn_criminal", l_32_1), respawn_t)
end

TradeManager.clbk_respawn_criminal = function(l_33_0, l_33_1)
  l_33_0._criminal_respawn_clbk = nil
  l_33_0._trading_hostage = nil
  local spawn_on_unit = l_33_1
  if not alive(spawn_on_unit) then
    local possible_criminals = {}
    for u_key,u_data in pairs(managers.groupai:state():all_char_criminals()) do
      if u_data.status ~= "dead" then
        table.insert(possible_criminals, u_data.unit)
      end
    end
    if #possible_criminals <= 0 then
      return 
    end
    spawn_on_unit = possible_criminals[math.random(1, #possible_criminals)]
  end
  local respawn_criminal = l_33_0:get_criminal_to_trade()
  if not respawn_criminal then
    return 
  end
  print("!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!")
  if respawn_criminal then
    print("Found criminal to respawn ", inspect(respawn_criminal))
  end
  for i,crim in ipairs(l_33_0._criminals_to_respawn) do
    if crim == respawn_criminal then
      print("Removing from list")
      table.remove(l_33_0._criminals_to_respawn, i)
  else
    end
  end
  l_33_0._num_trades = l_33_0._num_trades + 1
  managers.network:session():send_to_peers_synched("set_trade_spawn", respawn_criminal.id)
  l_33_0:_announce_spawn(respawn_criminal.id)
  local spawned_unit = nil
  if respawn_criminal.ai then
    print("RC: respawn AI", respawn_criminal.id)
    spawned_unit = managers.groupai:state():spawn_one_teamAI(false, respawn_criminal.id, spawn_on_unit)
  else
    print("RC: respawn human", respawn_criminal.id)
    local sp_id = "clbk_respawn_criminal"
    local spawn_point = {position = spawn_on_unit:position(), rotation = spawn_on_unit:rotation()}
    managers.network:register_spawn_point(sp_id, spawn_point)
    local peer_id = managers.criminals:character_peer_id_by_name(respawn_criminal.id)
    spawned_unit = managers.network:game():spawn_member_by_id(peer_id, sp_id, true)
    managers.network:unregister_spawn_point(sp_id)
  end
  if alive(spawned_unit) and alive(l_33_1) then
    l_33_0:sync_teammate_helped_hint(spawned_unit, l_33_1, 1)
    managers.network:session():send_to_peers_synched("sync_teammate_helped_hint", 1, spawned_unit, l_33_1)
  end
end

TradeManager.sync_teammate_helped_hint = function(l_34_0, l_34_1, l_34_2, l_34_3)
  if not alive(l_34_1) or not alive(l_34_2) then
    return 
  end
  local peer_id = managers.network:session():local_peer():id()
  if not managers.network:game():member(peer_id) then
    debug_pause("[TradeManager:sync_teammate_helped_hint] Couldn't get local unit! ", peer_id)
  end
  local local_unit = managers.criminals:character_unit_by_name(managers.criminals:local_character_name())
  local hint_id = "teammate"
  if local_unit == l_34_1 then
    hint_id = "you_were"
  elseif local_unit == l_34_2 then
    hint_id = "you"
  end
  if not l_34_3 or l_34_3 == 1 then
    hint_id = hint_id .. "_revived"
  elseif l_34_3 == 2 then
    hint_id = hint_id .. "_helpedup"
  elseif l_34_3 == 3 then
    hint_id = hint_id .. "_rescued"
  end
  if hint_id then
    managers.hint:show_hint(hint_id, nil, false, {TEAMMATE = l_34_1:base():nick_name(), HELPER = l_34_2:base():nick_name()})
  end
end


