-- Decompiled using luadec 2.0.1 by sztupy (http://winmo.sztupy.hu)
-- Command line was: F:\SteamLibrary\SteamApps\common\PAYDAY 2\lua\lib\states\missionendstate.luac 

require("lib/states/GameState")
if not MissionEndState then
  MissionEndState = class(GameState)
end
MissionEndState.GUI_ENDSCREEN = Idstring("guis/victoryscreen/stage_endscreen")
MissionEndState.init = function(l_1_0, l_1_1, l_1_2, l_1_3)
  GameState.init(l_1_0, l_1_1, l_1_2)
  l_1_0._type = ""
  l_1_0._completion_bonus_done = false
  l_1_0._continue_cb = callback(l_1_0, l_1_0, "_continue")
  l_1_0._controller = nil
  l_1_0._continue_block_timer = 0
end

MissionEndState.setup_controller = function(l_2_0)
  if not l_2_0._controller then
    l_2_0._controller = managers.controller:create_controller("victoryscreen", managers.controller:get_default_wrapper_index(), false)
     -- DECOMPILER ERROR: Confused while interpreting a jump as a 'while'

  end
  l_2_0._controller:set_enabled(true)
end
end

MissionEndState.set_controller_enabled = function(l_3_0, l_3_1)
  if l_3_0._controller then
     -- Warning: missing end command somewhere! Added here
  end
end

MissionEndState.at_enter = function(l_4_0, l_4_1, l_4_2)
  managers.platform:set_presence("Mission_end")
  managers.platform:set_rich_presence(Global.game_settings.single_player and "SPEnd" or "MPEnd")
  managers.hud:remove_updator("point_of_no_return")
  managers.hud:hide_stats_screen()
  l_4_0._continue_block_timer = Application:time() + 1.5
  if Network:is_server() then
    managers.network.matchmake:set_server_joinable(false)
    if l_4_0._success then
      for peer_id,data in pairs(managers.player:get_all_synced_carry()) do
        if not tweak_data.carry[data.carry_id].skip_exit_secure then
          print("Secure loot for", peer_id, data.carry_id, data.value)
          managers.loot:secure(data.carry_id, data.value)
        end
      end
    end
  end
  local player = managers.player:player_unit()
  if player then
    player:camera():remove_sound_listener()
  end
  Application:debug("1 second to managers.mission:pre_destroy()")
  l_4_0._mission_destroy_t = Application:time() + 1
  if not l_4_0._success then
    managers.job:set_stage_success(false)
  end
  if l_4_0._success then
    print("MissionEndState:at_enter", managers.job:on_last_stage())
    managers.job:set_stage_success(true)
    if l_4_0._type == "victory" then
      managers.money:on_mission_completed(l_4_2.num_winners)
    end
  end
  if SystemInfo:platform() == Idstring("WIN32") and managers.network.account:has_alienware() then
    LightFX:set_lamps(0, 255, 0, 255)
  end
  l_4_0._completion_bonus_done = l_4_0._completion_bonus_done or false
  l_4_0:setup_controller()
  if not l_4_0._setup then
    l_4_0._setup = true
    managers.hud:load_hud(l_4_0.GUI_ENDSCREEN, false, true, false, {}, nil, nil, true)
    managers.menu:open_menu("mission_end_menu", 1)
    l_4_0._mission_end_menu = managers.menu:get_menu("mission_end_menu")
  end
  l_4_0._old_state = l_4_1
  managers.menu_component:set_max_lines_game_chat(7)
  for _,component in ipairs(managers.hud:script(PlayerBase.PLAYER_INFO_HUD).panel:children()) do
     -- DECOMPILER ERROR: unhandled construct in 'if'

    if (component:name() == "title_mid_text" or component:name() == "present_mid_text" or component:name() == "present_mid_icon") and (not managers.hud._mid_text_presenting or managers.hud._mid_text_presenting.type ~= "challenge") then
      component:set_visible(false)
      for (for control),_ in (for generator) do
        component:set_visible(false)
      end
    end
    if not managers.hud._mid_text_presenting or managers.hud._mid_text_presenting.type ~= "challenge" then
      managers.hud:script(PlayerBase.PLAYER_INFO_HUD_FULLSCREEN).present_background:set_visible(false)
    end
    managers.hud:set_success_endscreen_hud(l_4_0._success, l_4_0._server_left)
    managers.hud:show_endscreen_hud()
    managers.groupai:state():set_AI_enabled(false)
    local player = managers.player:player_unit()
    if player then
      player:character_damage():set_invulnerable(true)
      player:character_damage():stop_heartbeat()
      player:base():set_stats_screen_visible(false)
      if player:movement():current_state():shooting() then
        player:movement():current_state()._equipped_unit:base():stop_shooting()
      end
      if player:movement():current_state()._interupt_action_interact then
        player:movement():current_state():_interupt_action_interact()
      end
    end
    l_4_0._sound_listener = SoundDevice:create_listener("lobby_menu")
    l_4_0._sound_listener:set_position(Vector3(0, -50000, 0))
    l_4_0._sound_listener:activate(true)
    if l_4_0._success then
      if l_4_2.personal_win then
        if managers.achievment:get_script_data("last_man_standing") then
          managers.challenges:set_flag("last_man_standing")
        end
        if not managers.statistics:is_dropin() then
          if managers.achievment:get_script_data("dodge_this_active") and not managers.achievment:get_script_data("dodge_this_fail") and tweak_data:difficulty_to_index(Global.game_settings.difficulty) >= 2 then
            managers.challenges:set_flag("dodge_this")
          end
          if not managers.achievment:get_script_data("pacifist_fail") and Global.level_data.level_id == "suburbia" and tweak_data:difficulty_to_index(Global.game_settings.difficulty) >= 3 then
            managers.challenges:set_flag("pacifist")
          end
          if not managers.achievment:get_script_data("blow_out_fail") and Global.level_data.level_id == "secret_stash" then
            managers.challenges:set_flag("blow_out")
          end
          if tweak_data:difficulty_to_index(Global.game_settings.difficulty) >= 4 then
            local noob_lubes = 0
            for _,data in ipairs(Global.player_manager.synced_bonuses) do
              if data.upgrade == "welcome_to_the_gang" then
                noob_lubes = noob_lubes + 1
              end
            end
            if noob_lubes >= 3 then
              managers.challenges:set_flag("noob_herder")
            end
          end
          if not managers.achievment:get_script_data("stand_together_fail") and tweak_data:difficulty_to_index(Global.game_settings.difficulty) >= 2 and Global.level_data.level_id == "heat_street" then
            managers.challenges:set_flag("stand_together")
          elseif l_4_2.num_winners == 3 and not alive(managers.player:player_unit()) then
            managers.challenges:set_flag("left_for_dead")
          end
        end
      end
    end
    l_4_0._criminals_completed = l_4_0._success and l_4_2.num_winners or 0
    managers.statistics:stop_session({success = l_4_0._success})
    managers.statistics:send_statistics()
    managers.hud:set_statistics_endscreen_hud(l_4_0._criminals_completed, l_4_0._success)
    managers.music:post_event(l_4_0._success and "resultscreen_win" or "resultscreen_lose")
    managers.enemy:add_delayed_clbk("play_finishing_sound", callback(l_4_0, l_4_0, "play_finishing_sound", l_4_0._success), Application:time() + 2)
    if l_4_0._type == "victory" or l_4_0._type == "gameover" then
      if l_4_2 then
        local total_xp_bonus, bonuses = l_4_0:_get_xp_dissected(l_4_0._success, l_4_2.num_winners)
      end
      l_4_0._bonuses = bonuses
      l_4_0:completion_bonus_done(total_xp_bonus)
    end
    if Network:is_server() then
      managers.network:session():set_state("game_end")
    end
     -- Warning: missing end command somewhere! Added here
  end
end

MissionEndState.is_success = function(l_5_0)
  return l_5_0._success
end

MissionEndState._get_xp_dissected = function(l_6_0, l_6_1, l_6_2)
  local total_xp, dissection_table = managers.experience:get_xp_dissected(l_6_1, l_6_2)
  if managers.job:has_active_job() then
    local job_stars = managers.job:current_job_stars()
    local job_and_difficulty_stars = managers.job:current_job_and_difficulty_stars()
    local difficulty_stars = job_and_difficulty_stars - job_stars
    local xp_multiplier = managers.experience:get_contract_difficulty_multiplier(difficulty_stars)
    local xp_stage_stars = dissection_table.stage_xp
    local xp_job_stars = dissection_table.job_xp
    local xp_risk_stars = dissection_table.bonus_risk
    local xp_total_diff_pre = xp_stage_stars + xp_job_stars + xp_risk_stars + dissection_table.bonus_low_level
    local plvl = managers.experience:current_level()
    local player_stars = math.max(math.ceil(plvl / 10), 1)
    local experience_manager = tweak_data.experience_manager.level_limit
    if player_stars <= job_and_difficulty_stars + tweak_data:get_value("experience_manager", "level_limit", "low_cap_level") then
      local diff_stars = math.clamp(job_and_difficulty_stars - player_stars, 1, #experience_manager.pc_difference_multipliers)
      local level_limit_mul = tweak_data:get_value("experience_manager", "level_limit", "pc_difference_multipliers", diff_stars)
      local plr_difficulty_stars = math.max(difficulty_stars - diff_stars, 0)
      local plr_xp_multiplier = managers.experience:get_contract_difficulty_multiplier(plr_difficulty_stars) or 0
      local white_player_stars = player_stars - plr_difficulty_stars
      local xp_plr_stage_stars = managers.experience:get_stage_xp_by_stars(white_player_stars)
      xp_plr_stage_stars = xp_plr_stage_stars + xp_plr_stage_stars * plr_xp_multiplier
      local xp_stage = xp_stage_stars + xp_stage_stars * xp_multiplier
      local diff_stage = xp_stage - (xp_plr_stage_stars)
      local new_xp_stage = xp_plr_stage_stars + diff_stage * level_limit_mul
      xp_stage_stars = xp_stage_stars * (new_xp_stage / xp_stage)
      if l_6_1 and managers.job:on_last_stage() then
        local xp_plr_job_stars = managers.experience:get_job_xp_by_stars(white_player_stars)
        xp_plr_job_stars = xp_plr_job_stars + xp_plr_job_stars * plr_xp_multiplier
        local xp_job = xp_job_stars + xp_job_stars * xp_multiplier
        local diff_job = xp_job - (xp_plr_job_stars)
        local new_xp_job = xp_plr_job_stars + diff_job * level_limit_mul
        xp_job_stars = xp_job_stars * (new_xp_job / xp_job)
      end
      xp_risk_stars = (xp_stage_stars + xp_job_stars) * xp_multiplier
    end
    dissection_table.stage_xp = math.round(xp_stage_stars)
    dissection_table.job_xp = math.round(xp_job_stars)
    dissection_table.bonus_risk = math.round(xp_risk_stars)
    local xp_total_diff_post = dissection_table.stage_xp + dissection_table.job_xp + dissection_table.bonus_risk
    local diff_in_xp = xp_total_diff_post - xp_total_diff_pre
    total_xp = total_xp + diff_in_xp
    dissection_table.total = dissection_table.total + diff_in_xp
  end
  return total_xp, dissection_table
end

MissionEndState._get_contract_xp = function(l_7_0, l_7_1)
  local has_active_job = managers.job:has_active_job()
  local job_and_difficulty_stars = has_active_job and managers.job:current_job_and_difficulty_stars() or 1
  local job_stars = has_active_job and managers.job:current_job_stars() or 1
  local difficulty_stars = job_and_difficulty_stars - job_stars
  local player_stars = managers.experience:level_to_stars()
  local total_stars = math.min(job_and_difficulty_stars, player_stars + 1)
  if total_stars < job_and_difficulty_stars then
    l_7_0._bonuses[5] = true
  end
  local total_difficulty_stars = math.max(0, total_stars - job_stars)
  local xp_multiplier = managers.experience:get_contract_difficulty_multiplier(total_difficulty_stars)
  l_7_0._bonuses[1] = difficulty_stars > 0 and difficulty_stars or false
  total_stars = math.min(job_stars, total_stars)
  l_7_0._bonuses[3] = has_active_job and managers.job:on_last_stage() or false
  local contract_xp = 0
  if l_7_1 and has_active_job and managers.job:on_last_stage() then
    contract_xp = contract_xp + managers.experience:get_job_xp_by_stars(total_stars)
  else
    contract_xp = contract_xp + managers.experience:get_stage_xp_by_stars(total_stars)
  end
  contract_xp = contract_xp + (contract_xp) * xp_multiplier
  contract_xp = (contract_xp) * (not l_7_1 and tweak_data:get_value("experience_manager", "stage_failed_multiplier") or 1)
  if not l_7_1 then
    l_7_0._bonuses[4] = true
  end
  return contract_xp
end

MissionEndState.set_continue_button_text = function(l_8_0)
  if l_8_0._completion_bonus_done then
    l_8_0:_set_continue_button_text()
  end
end

MissionEndState._set_continue_button_text = function(l_9_0)
  local text_id = "failed_disconnected_continue"
  local not_clickable = false
  if l_9_0._continue_block_timer and Application:time() < l_9_0._continue_block_timer then
    text_id = "menu_es_calculating_experience"
    not_clickable = true
  else
    if managers.job:stage_success() and managers.job:on_last_stage() then
      text_id = "menu_victory_goto_payday"
    end
  end
  local text = utf8.to_upper(managers.localization:text(text_id, {CONTINUE = managers.localization:btn_macro("continue")}))
  managers.menu_component:set_endscreen_continue_button_text(text, not_clickable)
end

MissionEndState.play_finishing_sound = function(l_10_0, l_10_1)
  if l_10_0._server_left then
    return 
  end
  if managers.groupai:state():bain_state() then
     -- Warning: missing end command somewhere! Added here
  end
end

MissionEndState.completion_bonus_done = function(l_11_0, l_11_1)
  l_11_0._total_xp_bonus = l_11_1
  l_11_0._completion_bonus_done = false
end

MissionEndState.at_exit = function(l_12_0, l_12_1)
  managers.briefing:stop_event(true)
  managers.hud:hide(l_12_0.GUI_ENDSCREEN)
  managers.menu_component:hide_game_chat_gui()
  l_12_0:_clear_controller()
  if not l_12_0._debug_continue and not Application:editor() then
    managers.savefile:save_progress()
    if Network:multiplayer() then
      l_12_0:_shut_down_network()
    end
    local player = managers.player:player_unit()
    if player then
      player:camera():remove_sound_listener()
    end
    if l_12_0._sound_listener then
      l_12_0._sound_listener:delete()
      l_12_0._sound_listener = nil
    end
    if l_12_1:name() ~= "disconnected" then
      l_12_0:_load_start_menu(l_12_1)
    else
      l_12_0._debug_continue = nil
      managers.groupai:state():set_AI_enabled(true)
      local player = managers.player:player_unit()
      if player then
        player:character_damage():set_invulnerable(false)
      end
    end
  end
  managers.menu:close_menu("mission_end_menu")
end

MissionEndState._shut_down_network = function(l_13_0)
  Network:set_multiplayer(false)
  managers.network:queue_stop_network()
  managers.network.matchmake:destroy_game()
  managers.network.voice_chat:destroy_voice()
end

MissionEndState._load_start_menu = function(l_14_0, l_14_1)
  if l_14_1:name() == "disconnected" then
    return 
  end
  if managers.dlc:is_trial() then
    Global.open_trial_buy = true
  end
  managers.job:deactivate_current_job()
  setup:load_start_menu()
end

MissionEndState.on_statistics_result = function(l_15_0, l_15_1, l_15_2, l_15_3, l_15_4, l_15_5, l_15_6, l_15_7, l_15_8, l_15_9, l_15_10, l_15_11, l_15_12, l_15_13)
  print("on_statistics_result begin")
  if managers.network and managers.network:session() and managers.network:session():peer(l_15_1) then
    local best_kills = managers.network:session():peer(l_15_1):name()
    local best_special_kills = managers.network:session():peer(l_15_3):name()
    local best_accuracy = managers.network:session():peer(l_15_5):name()
    local most_downs = (managers.network:session():peer(l_15_7):name())
    local stage_cash_summary_string = nil
    if l_15_0._success then
      local stage_payout, job_payout, bag_payout, small_loot_payout, crew_payout = managers.money:get_payouts()
      local bonus_bags = managers.loot:get_secured_bonus_bags_amount() + managers.loot:get_secured_mandatory_bags_amount()
      local bag_cash = bag_payout
      local loose_cash = small_loot_payout or 0
      local cleaner_cost = 0
      local assets_cost = 0
      local current_total_money = managers.money:total()
      if job_payout > 0 then
        local job_string = managers.localization:text("victory_stage_cash_summary_name_job", {stage_cash = managers.experience:cash_string(stage_payout), job_cash = managers.experience:cash_string(job_payout)})
        stage_cash_summary_string = job_string
      else
        local stage_string = managers.localization:text("victory_stage_cash_summary_name", {stage_cash = managers.experience:cash_string(stage_payout)})
        stage_cash_summary_string = stage_string
      end
      if bonus_bags > 0 and bag_cash > 0 then
        stage_cash_summary_string = stage_cash_summary_string .. " " .. managers.localization:text("victory_stage_cash_summary_name_bags", {bag_cash = managers.experience:cash_string(bag_cash), bag_amount = bonus_bags, bonus_bags = bonus_bags})
      end
      if l_15_0._criminals_completed and crew_payout > 0 then
        stage_cash_summary_string = stage_cash_summary_string .. " " .. managers.localization:text("victory_stage_cash_summary_name_crew", {winners = tostring(l_15_0._criminals_completed), crew_cash = managers.experience:cash_string(crew_payout)})
      end
      if loose_cash > 0 then
        stage_cash_summary_string = stage_cash_summary_string .. " " .. managers.localization:text("victory_stage_cash_summary_name_loose", {loose_cash = managers.experience:cash_string(loose_cash)})
      end
      stage_cash_summary_string = stage_cash_summary_string .. "\n"
      if cleaner_cost > 0 then
        stage_cash_summary_string = stage_cash_summary_string .. managers.localization:text("victory_stage_cash_summary_name_civ_kill", {civ_killed_cash = managers.experience:cash_string(cleaner_cost)}) .. " "
      end
      if assets_cost > 0 then
        stage_cash_summary_string = stage_cash_summary_string .. managers.localization:text("victory_stage_cash_summary_name_assets", {asset_cash = managers.experience:cash_string(assets_cost)}) .. " "
      end
      if cleaner_cost > 0 or assets_cost > 0 then
        stage_cash_summary_string = stage_cash_summary_string .. "\n"
      end
      stage_cash_summary_string = stage_cash_summary_string .. "\n"
      local offshore_string = managers.localization:text("victory_stage_cash_summary_name_offshore", {offshore = managers.localization:text("hud_offshore_account"), cash = managers.experience:cash_string(managers.money:heist_offshore())})
      local spending_string = managers.localization:text("victory_stage_cash_summary_name_spending", {cash = "##" .. managers.experience:cash_string(managers.money:heist_spending()) .. "##"})
      stage_cash_summary_string = stage_cash_summary_string .. offshore_string .. "\n"
      stage_cash_summary_string = stage_cash_summary_string .. spending_string .. "\n"
    else
      stage_cash_summary_string = managers.localization:text("failed_summary_name")
    end
    {best_killer = managers.localization:text("victory_best_killer_name", {PLAYER_NAME = best_kills, SCORE = l_15_2}), best_special = managers.localization:text("victory_best_special_name", {PLAYER_NAME = best_special_kills, SCORE = l_15_4}), best_accuracy = managers.localization:text("victory_best_accuracy_name", {PLAYER_NAME = best_accuracy, SCORE = l_15_6}), most_downs = managers.localization:text("victory_most_downs_name", {PLAYER_NAME = most_downs, SCORE = l_15_8})}.total_kills = l_15_9
     -- DECOMPILER ERROR: Confused about usage of registers!

    {best_killer = managers.localization:text("victory_best_killer_name", {PLAYER_NAME = best_kills, SCORE = l_15_2}), best_special = managers.localization:text("victory_best_special_name", {PLAYER_NAME = best_special_kills, SCORE = l_15_4}), best_accuracy = managers.localization:text("victory_best_accuracy_name", {PLAYER_NAME = best_accuracy, SCORE = l_15_6}), most_downs = managers.localization:text("victory_most_downs_name", {PLAYER_NAME = most_downs, SCORE = l_15_8})}.total_specials_kills = l_15_10
     -- DECOMPILER ERROR: Confused about usage of registers!

    {best_killer = managers.localization:text("victory_best_killer_name", {PLAYER_NAME = best_kills, SCORE = l_15_2}), best_special = managers.localization:text("victory_best_special_name", {PLAYER_NAME = best_special_kills, SCORE = l_15_4}), best_accuracy = managers.localization:text("victory_best_accuracy_name", {PLAYER_NAME = best_accuracy, SCORE = l_15_6}), most_downs = managers.localization:text("victory_most_downs_name", {PLAYER_NAME = most_downs, SCORE = l_15_8})}.total_head_shots = l_15_11
     -- DECOMPILER ERROR: Confused about usage of registers!

    {best_killer = managers.localization:text("victory_best_killer_name", {PLAYER_NAME = best_kills, SCORE = l_15_2}), best_special = managers.localization:text("victory_best_special_name", {PLAYER_NAME = best_special_kills, SCORE = l_15_4}), best_accuracy = managers.localization:text("victory_best_accuracy_name", {PLAYER_NAME = best_accuracy, SCORE = l_15_6}), most_downs = managers.localization:text("victory_most_downs_name", {PLAYER_NAME = most_downs, SCORE = l_15_8})}.group_hit_accuracy = l_15_12 .. "%"
     -- DECOMPILER ERROR: Confused about usage of registers!

    {best_killer = managers.localization:text("victory_best_killer_name", {PLAYER_NAME = best_kills, SCORE = l_15_2}), best_special = managers.localization:text("victory_best_special_name", {PLAYER_NAME = best_special_kills, SCORE = l_15_4}), best_accuracy = managers.localization:text("victory_best_accuracy_name", {PLAYER_NAME = best_accuracy, SCORE = l_15_6}), most_downs = managers.localization:text("victory_most_downs_name", {PLAYER_NAME = most_downs, SCORE = l_15_8})}.group_total_downed = l_15_13
     -- DECOMPILER ERROR: Confused about usage of registers!

    {best_killer = managers.localization:text("victory_best_killer_name", {PLAYER_NAME = best_kills, SCORE = l_15_2}), best_special = managers.localization:text("victory_best_special_name", {PLAYER_NAME = best_special_kills, SCORE = l_15_4}), best_accuracy = managers.localization:text("victory_best_accuracy_name", {PLAYER_NAME = best_accuracy, SCORE = l_15_6}), most_downs = managers.localization:text("victory_most_downs_name", {PLAYER_NAME = most_downs, SCORE = l_15_8})}.stage_cash_summary = stage_cash_summary_string
     -- DECOMPILER ERROR: Confused about usage of registers!

    l_15_0._statistics_data = {best_killer = managers.localization:text("victory_best_killer_name", {PLAYER_NAME = best_kills, SCORE = l_15_2}), best_special = managers.localization:text("victory_best_special_name", {PLAYER_NAME = best_special_kills, SCORE = l_15_4}), best_accuracy = managers.localization:text("victory_best_accuracy_name", {PLAYER_NAME = best_accuracy, SCORE = l_15_6}), most_downs = managers.localization:text("victory_most_downs_name", {PLAYER_NAME = most_downs, SCORE = l_15_8})}
  end
  print("on_statistics_result end")
  if Network:is_server() and l_15_0._success and not managers.achievment:get_script_data("cant_touch_fail") and tweak_data:difficulty_to_index(Global.game_settings.difficulty) >= 4 and Global.level_data.level_id == "heat_street" and l_15_12 >= 60 then
    managers.challenges:set_flag("cant_touch")
    managers.network:session():send_to_peers("award_achievment", "cant_touch")
  end
end

MissionEndState._continue_blocked = function(l_16_0)
  local in_focus = managers.menu:active_menu() == l_16_0._mission_end_menu
  if not in_focus then
    return true
  end
  if managers.hud:showing_stats_screen() then
    return true
  end
  if managers.system_menu:is_active() then
    return true
  end
  if not l_16_0._completion_bonus_done then
    return true
  end
  if managers.menu_component:input_focus() == 1 then
    return true
  end
  if l_16_0._continue_block_timer and Application:time() < l_16_0._continue_block_timer then
    return true
  end
  return false
end

MissionEndState._continue = function(l_17_0)
  l_17_0:continue()
end

MissionEndState.continue = function(l_18_0)
  if l_18_0:_continue_blocked() then
    return 
  end
  if managers.job:stage_success() and managers.job:on_last_stage() then
    Application:debug(managers.job:stage_success(), managers.job:on_last_stage(), managers.job:is_job_finished())
    l_18_0:_clear_controller()
    managers.menu_component:close_stage_endscreen_gui()
    l_18_0:gsm():change_state_by_name("ingame_lobby_menu")
  elseif l_18_0._old_state then
    l_18_0:_clear_controller()
    l_18_0:gsm():change_state_by_name("empty")
  else
    Application:error("Trying to continue from victory screen, but I have no state to goto")
  end
end

MissionEndState._clear_controller = function(l_19_0)
  if not l_19_0._controller then
    return 
  end
   -- DECOMPILER ERROR: Confused while interpreting a jump as a 'while'

end
l_19_0._controller:set_enabled(false)
l_19_0._controller:destroy()
l_19_0._controller = nil
end

MissionEndState.debug_continue = function(l_20_0)
  if not l_20_0._success then
    return 
  end
  if not l_20_0._completion_bonus_done then
    return 
  end
  if l_20_0._old_state then
    l_20_0._debug_continue = true
    l_20_0:_clear_controller()
    l_20_0:gsm():change_state_by_name(l_20_0._old_state:name())
  end
end

MissionEndState.set_completion_bonus_done = function(l_21_0, l_21_1)
  l_21_0._completion_bonus_done = l_21_1
  l_21_0:_set_continue_button_text()
end

MissionEndState.update = function(l_22_0, l_22_1, l_22_2)
  managers.hud:update_endscreen_hud(l_22_1, l_22_2)
  if l_22_0._mission_destroy_t and l_22_0._mission_destroy_t <= Application:time() then
    Application:debug("managers.mission:pre_destroy()")
    managers.mission:pre_destroy()
    l_22_0._mission_destroy_t = nil
  end
  if l_22_0._total_xp_bonus then
    if l_22_0._total_xp_bonus > 0 then
      local data = managers.experience:give_experience(l_22_0._total_xp_bonus)
      data.bonuses = l_22_0._bonuses
      managers.hud:send_xp_data_endscreen_hud(data, callback(l_22_0, l_22_0, "set_completion_bonus_done"))
      if SystemInfo:platform() == Idstring("WIN32") and Global.level_data.level_id then
        local stats = {}
        stats[Global.game_settings.difficulty .. "_" .. Global.level_data.level_id .. "_" .. "exp"] = {type = "int", value = l_22_0._total_xp_bonus}
        managers.network.account:publish_statistics(stats)
      else
        l_22_0:set_completion_bonus_done(true)
      end
      l_22_0._total_xp_bonus = nil
    end
    if l_22_0._continue_block_timer and l_22_0._continue_block_timer <= l_22_1 then
      l_22_0._continue_block_timer = nil
      l_22_0:_set_continue_button_text()
    end
    do
      local in_focus = managers.menu:active_menu() == l_22_0._mission_end_menu
      if in_focus and not l_22_0._in_focus then
        l_22_0:_set_continue_button_text()
        l_22_0._statistics_feeded = nil
      end
      if not l_22_0._statistics_feeded and l_22_0._statistics_data then
        l_22_0._statistics_data.success = l_22_0._success
        l_22_0._statistics_data.criminals_finished = l_22_0._criminals_completed
        managers.menu_component:feed_endscreen_statistics(l_22_0._statistics_data)
        l_22_0._statistics_feeded = true
      end
      l_22_0._in_focus = in_focus
    end
     -- Warning: missing end command somewhere! Added here
  end
end

MissionEndState.game_ended = function(l_23_0)
  return true
end

MissionEndState.on_server_left = function(l_24_0)
  IngameCleanState.on_server_left(l_24_0)
end

MissionEndState.on_kicked = function(l_25_0)
  IngameCleanState.on_kicked(l_25_0)
end

MissionEndState.on_disconnected = function(l_26_0)
  IngameCleanState.on_disconnected(l_26_0)
end


