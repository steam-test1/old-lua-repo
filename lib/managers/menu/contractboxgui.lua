-- Decompiled using luadec 2.0.1 by sztupy (http://winmo.sztupy.hu)
-- Command line was: F:\SteamLibrary\SteamApps\common\PAYDAY 2\lua\lib\managers\menu\contractboxgui.luac 

if not ContractBoxGui then
  ContractBoxGui = class()
end
ContractBoxGui.init = function(l_1_0, l_1_1, l_1_2)
  l_1_0._ws = l_1_1
  l_1_0._fullscreen_ws = l_1_2
  l_1_0._panel = l_1_0._ws:panel():panel()
  l_1_0._fullscreen_panel = l_1_0._fullscreen_ws:panel():panel()
  local crewpage_text = l_1_0._panel:text({name = "crewpage_text", text = managers.localization:to_upper_text("menu_crewpage"), align = "left", vertical = "top", font_size = tweak_data.menu.pd2_large_font_size, font = tweak_data.menu.pd2_large_font, color = tweak_data.screen_colors.text})
  local _, _, w, h = crewpage_text:text_rect()
  crewpage_text:set_size(w, h)
  local wfs_text = nil
  if not Network:is_server() then
    wfs_text = l_1_0._panel:text({name = "wfs", text = managers.localization:to_upper_text("victory_client_waiting_for_server"), align = "right", vertical = "bottom", font_size = tweak_data.menu.pd2_medium_font_size, font = tweak_data.menu.pd2_medium_font, color = tweak_data.screen_colors.text})
    local _, _, w, h = wfs_text:text_rect()
    wfs_text:set_size(w, h)
    wfs_text:set_rightbottom(l_1_0._panel:w(), l_1_0._panel:h())
  else
    if not managers.job:has_active_job() then
      wfs_text = l_1_0._panel:text({name = "wfs", text = managers.localization:to_upper_text("menu_choose_new_contract"), align = "right", vertical = "bottom", font_size = tweak_data.menu.pd2_medium_font_size, font = tweak_data.menu.pd2_medium_font, color = tweak_data.screen_colors.text})
      local _, _, w, h = wfs_text:text_rect()
      wfs_text:set_size(w, h)
      wfs_text:set_rightbottom(l_1_0._panel:w(), l_1_0._panel:h())
    end
  end
  if not managers.menu:is_pc_controller() and wfs_text then
    wfs_text:set_rightbottom(l_1_0._panel:w() - 40, l_1_0._panel:h() - 150)
  end
   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

  if MenuBackdropGUI then
    if crewpage_text then
      local bg_text = l_1_0._fullscreen_panel:text({name = "crewpage_text", text = managers.localization:to_upper_text("menu_crewpage"), h = 90, align = "left"})
      local x, y = managers.gui_data:safe_to_full_16_9(managers.gui_data, crewpage_text:world_x(), crewpage_text:world_center_y())
      bg_text:set_world_left(x)
      {name = "crewpage_text", text = managers.localization:to_upper_text("menu_crewpage"), h = 90, align = "left"}.layer, {name = "crewpage_text", text = managers.localization:to_upper_text("menu_crewpage"), h = 90, align = "left"}.alpha, {name = "crewpage_text", text = managers.localization:to_upper_text("menu_crewpage"), h = 90, align = "left"}.color, {name = "crewpage_text", text = managers.localization:to_upper_text("menu_crewpage"), h = 90, align = "left"}.font, {name = "crewpage_text", text = managers.localization:to_upper_text("menu_crewpage"), h = 90, align = "left"}.font_size, {name = "crewpage_text", text = managers.localization:to_upper_text("menu_crewpage"), h = 90, align = "left"}.vertical = 1, 0.40000000596046, tweak_data.screen_colors.button_stage_3, tweak_data.menu.pd2_massive_font, tweak_data.menu.pd2_massive_font_size, "top"
      bg_text:set_world_center_y(y)
      bg_text:move(-13, 9)
      MenuBackdropGUI.animate_bg_text(l_1_0, bg_text)
    end
    if managers.menu:is_pc_controller() and wfs_text then
      do return end
       -- DECOMPILER ERROR: Confused about usage of registers!

       -- DECOMPILER ERROR: Confused about usage of registers!

       -- DECOMPILER ERROR: Confused about usage of registers!

       -- DECOMPILER ERROR: Confused about usage of registers!

       -- DECOMPILER ERROR: Confused about usage of registers!

       -- DECOMPILER ERROR: Confused about usage of registers!

       -- DECOMPILER ERROR: Confused about usage of registers!

      local bg_text = l_1_0._fullscreen_panel:text({text = wfs_text:text(), h = 90})
      local x, y = managers.gui_data:safe_to_full_16_9(managers.gui_data, wfs_text:world_right(), wfs_text:world_center_y())
      bg_text:set_world_right(x)
      {text = wfs_text:text(), h = 90}.layer, {text = wfs_text:text(), h = 90}.alpha, {text = wfs_text:text(), h = 90}.color, {text = wfs_text:text(), h = 90}.font, {text = wfs_text:text(), h = 90}.font_size, {text = wfs_text:text(), h = 90}.vertical, {text = wfs_text:text(), h = 90}.align = 1, 0.40000000596046, tweak_data.screen_colors.button_stage_3, tweak_data.menu.pd2_massive_font, tweak_data.menu.pd2_massive_font_size, "bottom", "right"
      bg_text:set_world_center_y(y)
      bg_text:move(13, -9)
      MenuBackdropGUI.animate_bg_text(l_1_0, bg_text)
    end
  end
  l_1_0:create_contract_box()
end

ContractBoxGui.create_contract_box = function(l_2_0)
  if not managers.network:session() then
    return 
  end
  if l_2_0._contract_panel and alive(l_2_0._contract_panel) then
    l_2_0._panel:remove(l_2_0._contract_panel)
  end
  if l_2_0._contract_text_header and alive(l_2_0._contract_text_header) then
    l_2_0._panel:remove(l_2_0._contract_text_header)
  end
  l_2_0._contract_panel = nil
  l_2_0._contract_text_header = nil
  local contact_data = managers.job:current_contact_data()
  local job_data = managers.job:current_job_data()
  l_2_0._contract_panel = l_2_0._panel:panel({name = "contract_box_panel", w = 350, h = 100, layer = 0})
  l_2_0._contract_panel:rect({color = Color(0.5, 0, 0, 0), layer = -1, halign = "grow", valign = "grow"})
  local font = tweak_data.menu.pd2_small_font
  local font_size = tweak_data.menu.pd2_small_font_size
  if contact_data then
    l_2_0._contract_text_header = l_2_0._panel:text({text = utf8.to_upper(managers.localization:text(contact_data.name_id) .. ": " .. managers.localization:text(job_data.name_id)), font_size = tweak_data.menu.pd2_medium_font_size, font = tweak_data.menu.pd2_medium_font, color = tweak_data.screen_colors.text, blend_mode = "add"})
    local length_text_header = l_2_0._contract_panel:text({text = managers.localization:to_upper_text("cn_menu_contract_length_header"), font_size = font_size, font = font, color = tweak_data.screen_colors.text})
    local paygrade_text_header = l_2_0._contract_panel:text({text = managers.localization:to_upper_text("cn_menu_contract_paygrade_header"), font_size = font_size, font = font, color = tweak_data.screen_colors.text})
    local exp_text_header = l_2_0._contract_panel:text({text = managers.localization:to_upper_text("menu_experience"), font_size = font_size, font = font, color = tweak_data.screen_colors.text})
    local payout_text_header = l_2_0._contract_panel:text({text = managers.localization:to_upper_text("cn_menu_contract_payout_header"), font_size = font_size, font = font, color = tweak_data.screen_colors.text})
    do
      local _, _, tw, th = l_2_0._contract_text_header:text_rect()
      l_2_0._contract_text_header:set_size(tw, th)
    end
    local w = 0
    do
      local _, _, tw, th = length_text_header:text_rect()
      w = math.max(w, tw)
      length_text_header:set_size(tw, th)
    do
      end
      local _, _, tw, th = paygrade_text_header:text_rect()
      w = math.max(w, tw)
      paygrade_text_header:set_size(tw, th)
    do
      end
      local _, _, tw, th = exp_text_header:text_rect()
      w = math.max(w, tw)
      exp_text_header:set_size(tw, th)
    do
      end
      local _, _, tw, th = payout_text_header:text_rect()
      w = math.max(w, tw)
      payout_text_header:set_size(tw, th)
    end
    w = w + 10
    length_text_header:set_right(w)
    paygrade_text_header:set_right(w)
    exp_text_header:set_right(w)
    payout_text_header:set_right(w)
    paygrade_text_header:set_top(10)
    length_text_header:set_top(paygrade_text_header:bottom())
    exp_text_header:set_top(length_text_header:bottom())
    payout_text_header:set_top(exp_text_header:bottom())
    local length_text = l_2_0._contract_panel:text({text = managers.localization:to_upper_text("cn_menu_contract_length", {stages = #job_data.chain}), align = "left", vertical = "top", font_size = font_size, font = font, color = tweak_data.screen_colors.text})
    length_text:set_position(length_text_header:right() + 5, length_text_header:top())
    local filled_star_rect = {0, 32, 32, 32}
    local empty_star_rect = {32, 32, 32, 32}
    local job_stars = managers.job:current_job_stars()
    local job_and_difficulty_stars = managers.job:current_job_and_difficulty_stars()
    local difficulty_stars = job_and_difficulty_stars - job_stars
    local risk_color = tweak_data.screen_colors.risk
    local cy = paygrade_text_header:center_y()
    local sx = paygrade_text_header:right() + 5
    local level_data = {texture = "guis/textures/pd2/mission_briefing/difficulty_icons", texture_rect = filled_star_rect, w = 16, h = 16, color = tweak_data.screen_colors.text, alpha = 1}
    local risk_data = {texture = "guis/textures/pd2/crimenet_skull", w = 16, h = 16, color = risk_color, alpha = 1}
    for i = 1, job_and_difficulty_stars do
      local x = sx + (i - 1) * 18
      local is_risk = job_stars < i
      local star_data = is_risk and risk_data or level_data
      local star = l_2_0._contract_panel:bitmap(star_data)
      star:set_x(x)
      star:set_center_y(math.round(cy))
    end
    local plvl = managers.experience:current_level()
    local player_stars = math.max(math.ceil(plvl / 10), 1)
    local days_multiplier = 0
    for i = 1, #job_data.chain do
      if not job_data.professional or not tweak_data:get_value("experience_manager", "pro_day_multiplier", i) then
        local day_mul = tweak_data:get_value("experience_manager", "day_multiplier", i)
      end
      days_multiplier = days_multiplier + (day_mul - 1)
    end
    days_multiplier = 1 + (days_multiplier) / #job_data.chain
    if not job_data.professional or not tweak_data:get_value("experience_manager", "pro_day_multiplier", #job_data.chain) then
      local last_day_mul = tweak_data:get_value("experience_manager", "day_multiplier", #job_data.chain)
    end
    local xp_stage_stars = managers.experience:get_stage_xp_by_stars(job_stars)
    local xp_job_stars = managers.experience:get_job_xp_by_stars(job_stars)
    local xp_multiplier = managers.experience:get_contract_difficulty_multiplier(difficulty_stars)
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
      local xp_plr_job_stars = managers.experience:get_job_xp_by_stars(white_player_stars)
      xp_plr_job_stars = xp_plr_job_stars + xp_plr_job_stars * plr_xp_multiplier
      local xp_job = xp_job_stars + xp_job_stars * xp_multiplier
      local diff_job = xp_job - (xp_plr_job_stars)
      local new_xp_job = xp_plr_job_stars + diff_job * level_limit_mul
      xp_job_stars = xp_job_stars * (new_xp_job / xp_job)
    end
    local pure_job_experience = xp_job_stars * last_day_mul + xp_stage_stars + xp_stage_stars * (#job_data.chain - 1) * (days_multiplier)
    local job_experience = math.round(pure_job_experience)
    local job_xp = l_2_0._contract_panel:text({font = font, font_size = font_size, text = tostring(job_experience), color = tweak_data.screen_colors.text})
    do
      local _, _, tw, th = job_xp:text_rect()
      job_xp:set_size(tw, th)
    end
    job_xp:set_position(math.round(exp_text_header:right() + 5), math.round(exp_text_header:top()))
    local risk_xp = l_2_0._contract_panel:text({font = font, font_size = font_size, text = " +" .. tostring(math.round(pure_job_experience * xp_multiplier)), color = risk_color})
    do
      local _, _, tw, th = risk_xp:text_rect()
      risk_xp:set_size(tw, th)
    end
    risk_xp:set_position(math.round(job_xp:right()), job_xp:top())
    local money_stage_stars = managers.money:get_stage_payout_by_stars(job_stars)
    local money_job_stars = managers.money:get_job_payout_by_stars(job_stars)
    local money_multiplier = managers.money:get_contract_difficulty_multiplier(difficulty_stars)
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
    local job_money = l_2_0._contract_panel:text({font = font, font_size = font_size, text = managers.experience:cash_string(math.round(money_job_stars + tweak_data:get_value("money_manager", "flat_job_completion") + (money_stage_stars + tweak_data:get_value("money_manager", "flat_stage_completion")) * #job_data.chain)), color = tweak_data.screen_colors.text})
    do
      local _, _, tw, th = job_money:text_rect()
      job_money:set_size(tw, th)
    end
    job_money:set_position(math.round(payout_text_header:right() + 5), math.round(payout_text_header:top()))
    local risk_money = l_2_0._contract_panel:text({font = font, font_size = font_size, text = " +" .. managers.experience:cash_string(math.round((money_job_stars + money_stage_stars * #job_data.chain) * money_multiplier)), color = risk_color})
    do
      local _, _, tw, th = risk_money:text_rect()
      risk_money:set_size(tw, th)
    end
    risk_money:set_position(math.round(job_money:right()), job_money:top())
    l_2_0._contract_panel:set_h(payout_text_header:bottom() + 10)
  else
    if managers.menu:debug_menu_enabled() then
      local debug_start = l_2_0._contract_panel:text({text = "Use DEBUG START to start your level", font_size = font_size, font = font, color = tweak_data.screen_colors.text, x = 10, y = 10, wrap = true, word_wrap = true})
      debug_start:grow(-debug_start:x() - 10, debug_start:y() - 10)
    end
  end
  l_2_0._contract_panel:set_rightbottom(l_2_0._panel:w() - 10, l_2_0._panel:h() - 50)
  if l_2_0._contract_text_header then
    l_2_0._contract_text_header:set_bottom(l_2_0._contract_panel:top())
    l_2_0._contract_text_header:set_left(l_2_0._contract_panel:left())
    local wfs_text = l_2_0._panel:child("wfs")
    if wfs_text and not managers.menu:is_pc_controller() then
      wfs_text:set_rightbottom(l_2_0._panel:w() - 20, l_2_0._contract_text_header:top())
    end
  end
  local wfs = l_2_0._panel:child("wfs")
  if wfs then
    l_2_0._contract_panel:grow(0, wfs:h() + 5)
    l_2_0._contract_panel:move(0, -(wfs:h() + 5))
    if l_2_0._contract_text_header then
      l_2_0._contract_text_header:move(0, -(wfs:h() + 5))
    end
    wfs:set_world_rightbottom(l_2_0._contract_panel:world_right() - 5, l_2_0._contract_panel:world_bottom())
  end
  BoxGuiObject:new(l_2_0._contract_panel, {sides = {1, 1, 1, 1}})
  for i = 1, 4 do
    local peer = managers.network:session():peer(i)
    if peer then
      local peer_pos = managers.menu_scene:character_screen_position(i)
      local peer_name = peer:name()
      if peer_pos then
        l_2_0:create_character_text(i, peer_pos.x, peer_pos.y, peer_name)
      end
    end
  end
  l_2_0._enabled = true
end

ContractBoxGui.refresh = function(l_3_0)
  l_3_0:create_contract_box()
end

ContractBoxGui.update = function(l_4_0, l_4_1, l_4_2)
  for i = 1, 4 do
    l_4_0:update_character(i)
  end
end

ContractBoxGui.create_character_text = function(l_5_0, l_5_1, l_5_2, l_5_3, l_5_4)
  if not l_5_0._peers then
    l_5_0._peers = {}
  end
  local color_id = l_5_1
  local color = tweak_data.chat_colors[color_id]
   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

  if not l_5_0._peers[l_5_1] then
    l_5_0._peers[l_5_1], {name = tostring(l_5_1), text = ""}.blend_mode, {name = tostring(l_5_1), text = ""}.color, {name = tostring(l_5_1), text = ""}.layer, {name = tostring(l_5_1), text = ""}.font, {name = tostring(l_5_1), text = ""}.font_size, {name = tostring(l_5_1), text = ""}.vertical, {name = tostring(l_5_1), text = ""}.align = l_5_0._panel:text({name = tostring(l_5_1), text = ""}), "add", color, 0, tweak_data.menu.pd2_medium_font, tweak_data.menu.pd2_medium_font_size, "center", "center"
  end
  l_5_0._peers[l_5_1]:set_text(l_5_4 or "")
  l_5_0._peers[l_5_1]:set_visible(l_5_0._enabled)
  local _, _, w, h = l_5_0._peers[l_5_1]:text_rect()
  l_5_0._peers[l_5_1]:set_size(w, h)
  l_5_0._peers[l_5_1]:set_center(l_5_2, l_5_3)
  if not l_5_0._peers_state then
    l_5_0._peers_state = {}
  end
   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

  if not l_5_0._peers_state[l_5_1] then
    l_5_0._peers_state[l_5_1], {name = tostring(l_5_1) .. "_state", text = ""}.blend_mode, {name = tostring(l_5_1) .. "_state", text = ""}.color, {name = tostring(l_5_1) .. "_state", text = ""}.layer, {name = tostring(l_5_1) .. "_state", text = ""}.font, {name = tostring(l_5_1) .. "_state", text = ""}.font_size, {name = tostring(l_5_1) .. "_state", text = ""}.vertical, {name = tostring(l_5_1) .. "_state", text = ""}.align = l_5_0._panel:text({name = tostring(l_5_1) .. "_state", text = ""}), "add", tweak_data.screen_colors.text, 0, tweak_data.menu.pd2_medium_font, tweak_data.menu.pd2_medium_font_size, "top", "center"
  end
  l_5_0._peers_state[l_5_1]:set_top(l_5_0._peers[l_5_1]:bottom())
  l_5_0._peers_state[l_5_1]:set_center_x(l_5_0._peers[l_5_1]:center_x())
end

ContractBoxGui.update_character = function(l_6_0, l_6_1)
  if not l_6_1 or not managers.network:session() then
    return 
  end
  local x = 0
  local y = 0
  local text = ""
  do
    local peer = managers.network:session():peer(l_6_1)
    if peer then
      if managers.network:session() then
        local local_peer = managers.network:session():local_peer()
      end
      local peer_pos = managers.menu_scene:character_screen_position(l_6_1)
      x = peer_pos.x
      y = peer_pos.y
      if peer ~= local_peer or not managers.experience:current_level() then
        text = peer:name() .. " (" .. tostring(peer:level()) .. ")"
      end
      l_6_0:create_character_text(l_6_1, x, y, text)
    end
     -- Warning: missing end command somewhere! Added here
  end
end

ContractBoxGui.update_character_menu_state = function(l_7_0, l_7_1, l_7_2)
  if not l_7_0._peers_state then
    return 
  end
  if not l_7_0._peers_state[l_7_1] then
    return 
  end
  l_7_0._peers_state[l_7_1]:set_text(l_7_2 and managers.localization:to_upper_text("menu_lobby_menu_state_" .. l_7_2) or "")
end

ContractBoxGui._create_text_box = function(l_8_0, l_8_1, l_8_2, l_8_3, l_8_4, l_8_5)
end

ContractBoxGui._create_lower_static_panel = function(l_9_0, l_9_1)
end

ContractBoxGui.mouse_pressed = function(l_10_0, l_10_1, l_10_2, l_10_3)
  if not l_10_0:can_take_input() then
    return 
  end
  if l_10_1 == Idstring("0") then
     -- Warning: missing end command somewhere! Added here
  end
end

ContractBoxGui.mouse_moved = function(l_11_0, l_11_1, l_11_2)
  if not l_11_0:can_take_input() then
    return 
  end
  return false, nil
end

ContractBoxGui.can_take_input = function(l_12_0)
  return false
end

ContractBoxGui.moved_scroll_bar = function(l_13_0)
end

ContractBoxGui.mouse_wheel_down = function(l_14_0)
end

ContractBoxGui.mouse_wheel_up = function(l_15_0)
end

ContractBoxGui.check_minimize = function(l_16_0)
  return false
end

ContractBoxGui.check_grab_scroll_bar = function(l_17_0)
  return false
end

ContractBoxGui.release_scroll_bar = function(l_18_0)
  return false
end

ContractBoxGui.set_enabled = function(l_19_0, l_19_1)
  l_19_0._enabled = l_19_1
  if not l_19_1 or l_19_0._contract_panel then
    l_19_0._contract_panel:set_visible(l_19_1)
  end
  if l_19_0._contract_text_header then
    l_19_0._contract_text_header:set_visible(l_19_1)
  end
  if l_19_0._panel:child("wfs") then
    l_19_0._panel:child("wfs"):set_visible(l_19_1)
  end
end

ContractBoxGui.set_size = function(l_20_0, l_20_1, l_20_2)
end

ContractBoxGui.set_visible = function(l_21_0, l_21_1)
end

ContractBoxGui.close = function(l_22_0)
  l_22_0._ws:panel():remove(l_22_0._panel)
  l_22_0._fullscreen_ws:panel():remove(l_22_0._fullscreen_panel)
end


