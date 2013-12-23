-- Decompiled using luadec 2.0.1 by sztupy (http://winmo.sztupy.hu)
-- Command line was: F:\SteamLibrary\SteamApps\common\PAYDAY 2\lua\lib\managers\hud\hudstatsscreen.luac 

if not HUDStatsScreen then
  HUDStatsScreen = class()
end
HUDStatsScreen.init = function(l_1_0)
  l_1_0._hud_panel = managers.hud:script(managers.hud.STATS_SCREEN_SAFERECT).panel
  l_1_0._full_hud_panel = managers.hud:script(managers.hud.STATS_SCREEN_FULLSCREEN).panel
  l_1_0._full_hud_panel:clear()
  local left_panel = l_1_0._full_hud_panel:panel({name = "left_panel", valign = "scale", w = l_1_0._full_hud_panel:w() / 3})
  left_panel:set_x(-left_panel:w())
  left_panel:rect({name = "rect_bg", color = Color(0, 0, 0):with_alpha(0.75), valign = "scale", blend_mode = "normal"})
  local blur_bg = left_panel:bitmap({name = "blur_bg", texture = "guis/textures/test_blur_df", w = left_panel:w(), h = left_panel:h(), valign = "scale", render_template = "VertexColorTexturedBlur3D", layer = -1})
   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

  local objectives_title = left_panel:text({layer = 1, name = "objectives_title", color = Color.white, font_size = tweak_data.hud_stats.objectives_title_size})
  local x, y = managers.gui_data:corner_safe_to_full(0, 0)
  objectives_title:set_position(math.round(x), math.round(y))
  {layer = 1, name = "objectives_title", color = Color.white, font_size = tweak_data.hud_stats.objectives_title_size}.h, {layer = 1, name = "objectives_title", color = Color.white, font_size = tweak_data.hud_stats.objectives_title_size}.w, {layer = 1, name = "objectives_title", color = Color.white, font_size = tweak_data.hud_stats.objectives_title_size}.vertical, {layer = 1, name = "objectives_title", color = Color.white, font_size = tweak_data.hud_stats.objectives_title_size}.align, {layer = 1, name = "objectives_title", color = Color.white, font_size = tweak_data.hud_stats.objectives_title_size}.text, {layer = 1, name = "objectives_title", color = Color.white, font_size = tweak_data.hud_stats.objectives_title_size}.font = 32, 512, "top", "left", utf8.to_upper(managers.localization:text("hud_objective")), tweak_data.hud_stats.objectives_font
  objectives_title:set_valign({math.round(y) / managers.gui_data:full_scaled_size().h, 0})
  managers.hud:make_fine_text(objectives_title)
  local pad = 8
  local objectives_panel = left_panel:panel({layer = 1, name = "objectives_panel", x = math.round(objectives_title:x() + pad), y = math.round(objectives_title:bottom()), w = left_panel:w() - (objectives_title:x() + pad)})
  objectives_panel:set_valign({math.round(y) / managers.gui_data:full_scaled_size().h, 0})
  local loot_wrapper_panel = left_panel:panel({visible = true, layer = 1, name = "loot_wrapper_panel", x = 0, y = 0 + math.round(managers.gui_data:full_scaled_size().height / 2), h = math.round(managers.gui_data:full_scaled_size().height / 2), w = left_panel:w()})
  loot_wrapper_panel:set_valign("center")
   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

  local secured_loot_title = loot_wrapper_panel:text({layer = 1, valign = "center", name = "secured_loot_title", color = Color.white, font_size = tweak_data.hud_stats.loot_title_size, font = tweak_data.hud_stats.objectives_font})
  secured_loot_title:set_position(math.round(x), 0)
  {layer = 1, valign = "center", name = "secured_loot_title", color = Color.white, font_size = tweak_data.hud_stats.loot_title_size, font = tweak_data.hud_stats.objectives_font}.h, {layer = 1, valign = "center", name = "secured_loot_title", color = Color.white, font_size = tweak_data.hud_stats.loot_title_size, font = tweak_data.hud_stats.objectives_font}.w, {layer = 1, valign = "center", name = "secured_loot_title", color = Color.white, font_size = tweak_data.hud_stats.loot_title_size, font = tweak_data.hud_stats.objectives_font}.vertical, {layer = 1, valign = "center", name = "secured_loot_title", color = Color.white, font_size = tweak_data.hud_stats.loot_title_size, font = tweak_data.hud_stats.objectives_font}.align, {layer = 1, valign = "center", name = "secured_loot_title", color = Color.white, font_size = tweak_data.hud_stats.loot_title_size, font = tweak_data.hud_stats.objectives_font}.text = 32, 512, "top", "left", utf8.to_upper(managers.localization:text("hud_secured_loot"))
  managers.hud:make_fine_text(secured_loot_title)
   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

  local mission_bags_title = loot_wrapper_panel:text({layer = 1, valign = "center", name = "mission_bags_title", color = Color.white, font_size = tweak_data.hud_stats.loot_size, font = tweak_data.hud_stats.objectives_font})
  mission_bags_title:set_position(math.round(x + pad), 32)
  {layer = 1, valign = "center", name = "mission_bags_title", color = Color.white, font_size = tweak_data.hud_stats.loot_size, font = tweak_data.hud_stats.objectives_font}.h, {layer = 1, valign = "center", name = "mission_bags_title", color = Color.white, font_size = tweak_data.hud_stats.loot_size, font = tweak_data.hud_stats.objectives_font}.w, {layer = 1, valign = "center", name = "mission_bags_title", color = Color.white, font_size = tweak_data.hud_stats.loot_size, font = tweak_data.hud_stats.objectives_font}.vertical, {layer = 1, valign = "center", name = "mission_bags_title", color = Color.white, font_size = tweak_data.hud_stats.loot_size, font = tweak_data.hud_stats.objectives_font}.align, {layer = 1, valign = "center", name = "mission_bags_title", color = Color.white, font_size = tweak_data.hud_stats.loot_size, font = tweak_data.hud_stats.objectives_font}.text = 32, 512, "top", "left", utf8.to_upper(managers.localization:text("hud_mission_bags"))
  managers.hud:make_fine_text(mission_bags_title)
  local mission_bags_panel = loot_wrapper_panel:panel({visible = true, name = "mission_bags_panel", x = 0, y = 0, h = 32, w = left_panel:w()})
  mission_bags_panel:set_lefttop(mission_bags_title:leftbottom())
  mission_bags_panel:set_position(mission_bags_panel:x(), mission_bags_panel:y() + 4)
   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

  local bonus_bags_title = loot_wrapper_panel:text({layer = 1, valign = "center", name = "bonus_bags_title", color = Color.white, font_size = tweak_data.hud_stats.loot_size, font = tweak_data.hud_stats.objectives_font})
  bonus_bags_title:set_position(math.round(x + pad), 96)
  {layer = 1, valign = "center", name = "bonus_bags_title", color = Color.white, font_size = tweak_data.hud_stats.loot_size, font = tweak_data.hud_stats.objectives_font}.h, {layer = 1, valign = "center", name = "bonus_bags_title", color = Color.white, font_size = tweak_data.hud_stats.loot_size, font = tweak_data.hud_stats.objectives_font}.w, {layer = 1, valign = "center", name = "bonus_bags_title", color = Color.white, font_size = tweak_data.hud_stats.loot_size, font = tweak_data.hud_stats.objectives_font}.vertical, {layer = 1, valign = "center", name = "bonus_bags_title", color = Color.white, font_size = tweak_data.hud_stats.loot_size, font = tweak_data.hud_stats.objectives_font}.align, {layer = 1, valign = "center", name = "bonus_bags_title", color = Color.white, font_size = tweak_data.hud_stats.loot_size, font = tweak_data.hud_stats.objectives_font}.text = 32, 512, "top", "left", utf8.to_upper(managers.localization:text("hud_bonus_bags"))
  managers.hud:make_fine_text(bonus_bags_title)
  local bonus_bags_panel = loot_wrapper_panel:panel({visible = true, name = "bonus_bags_panel", x = 0, y = 0, h = 20, w = left_panel:w()})
  bonus_bags_panel:set_lefttop(bonus_bags_title:leftbottom())
  bonus_bags_panel:set_position(bonus_bags_panel:x(), bonus_bags_panel:y() + 4)
  bonus_bags_panel:grow(-bonus_bags_panel:x(), 0)
   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

  local bonus_bags_payout = loot_wrapper_panel:text({layer = 1, valign = "center", name = "bonus_bags_payout", color = Color.white, font_size = tweak_data.hud_stats.loot_size, font = tweak_data.hud_stats.objectives_font})
  bonus_bags_payout:set_text(utf8.to_upper(managers.localization:text("hud_bonus_bags_payout", {MONEY = managers.experience:cash_string(0)})))
  {layer = 1, valign = "center", name = "bonus_bags_payout", color = Color.white, font_size = tweak_data.hud_stats.loot_size, font = tweak_data.hud_stats.objectives_font}.h, {layer = 1, valign = "center", name = "bonus_bags_payout", color = Color.white, font_size = tweak_data.hud_stats.loot_size, font = tweak_data.hud_stats.objectives_font}.w, {layer = 1, valign = "center", name = "bonus_bags_payout", color = Color.white, font_size = tweak_data.hud_stats.loot_size, font = tweak_data.hud_stats.objectives_font}.vertical, {layer = 1, valign = "center", name = "bonus_bags_payout", color = Color.white, font_size = tweak_data.hud_stats.loot_size, font = tweak_data.hud_stats.objectives_font}.align, {layer = 1, valign = "center", name = "bonus_bags_payout", color = Color.white, font_size = tweak_data.hud_stats.loot_size, font = tweak_data.hud_stats.objectives_font}.text = 32, 512, "top", "left", ""
  bonus_bags_payout:set_position(bonus_bags_title:left(), bonus_bags_panel:bottom() - 0)
  managers.hud:make_fine_text(bonus_bags_payout)
  bonus_bags_payout:set_w(loot_wrapper_panel:w())
   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

  local instant_cash_title = loot_wrapper_panel:text({layer = 1, valign = "center", name = "instant_cash_title", color = Color.white, font_size = tweak_data.hud_stats.loot_size, font = tweak_data.hud_stats.objectives_font})
  instant_cash_title:set_position(math.round(x + pad), 192)
  {layer = 1, valign = "center", name = "instant_cash_title", color = Color.white, font_size = tweak_data.hud_stats.loot_size, font = tweak_data.hud_stats.objectives_font}.h, {layer = 1, valign = "center", name = "instant_cash_title", color = Color.white, font_size = tweak_data.hud_stats.loot_size, font = tweak_data.hud_stats.objectives_font}.w, {layer = 1, valign = "center", name = "instant_cash_title", color = Color.white, font_size = tweak_data.hud_stats.loot_size, font = tweak_data.hud_stats.objectives_font}.vertical, {layer = 1, valign = "center", name = "instant_cash_title", color = Color.white, font_size = tweak_data.hud_stats.loot_size, font = tweak_data.hud_stats.objectives_font}.align, {layer = 1, valign = "center", name = "instant_cash_title", color = Color.white, font_size = tweak_data.hud_stats.loot_size, font = tweak_data.hud_stats.objectives_font}.text = 32, 512, "top", "left", utf8.to_upper(managers.localization:text("hud_instant_cash"))
  managers.hud:make_fine_text(instant_cash_title)
   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

  local instant_cash_text = loot_wrapper_panel:text({layer = 1, valign = "center", name = "instant_cash_text", color = Color.white, font_size = tweak_data.hud_stats.loot_size, font = tweak_data.hud_stats.objectives_font})
  instant_cash_text:set_position(instant_cash_title:left(), instant_cash_title:bottom())
  {layer = 1, valign = "center", name = "instant_cash_text", color = Color.white, font_size = tweak_data.hud_stats.loot_size, font = tweak_data.hud_stats.objectives_font}.h, {layer = 1, valign = "center", name = "instant_cash_text", color = Color.white, font_size = tweak_data.hud_stats.loot_size, font = tweak_data.hud_stats.objectives_font}.w, {layer = 1, valign = "center", name = "instant_cash_text", color = Color.white, font_size = tweak_data.hud_stats.loot_size, font = tweak_data.hud_stats.objectives_font}.vertical, {layer = 1, valign = "center", name = "instant_cash_text", color = Color.white, font_size = tweak_data.hud_stats.loot_size, font = tweak_data.hud_stats.objectives_font}.align, {layer = 1, valign = "center", name = "instant_cash_text", color = Color.white, font_size = tweak_data.hud_stats.loot_size, font = tweak_data.hud_stats.objectives_font}.text = 32, 512, "top", "left", managers.experience:cash_string(0)
  managers.hud:make_fine_text(instant_cash_text)
  instant_cash_text:set_w(loot_wrapper_panel:w())
  local challenges_wrapper_panel = left_panel:panel({visible = false, layer = 1, valign = {0.5, 0.5}, name = "challenges_wrapper_panel", x = 0, y = y + math.round(managers.gui_data:scaled_size().height / 2), h = math.round(managers.gui_data:scaled_size().height / 2), w = left_panel:w()})
  local _, by = managers.gui_data:corner_safe_to_full(0, managers.gui_data:corner_scaled_size().height)
  challenges_wrapper_panel:set_bottom(by)
  challenges_wrapper_panel:set_valign({by / managers.gui_data:full_scaled_size().h, 0})
   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

  local last_completed_challenge_title = challenges_wrapper_panel:text({layer = 1, valign = "center", name = "last_completed_challenge_title", color = Color.white, font_size = tweak_data.hud_stats.objectives_title_size, font = tweak_data.hud_stats.objectives_font})
  last_completed_challenge_title:set_position(math.round(x), 0)
  {layer = 1, valign = "center", name = "last_completed_challenge_title", color = Color.white, font_size = tweak_data.hud_stats.objectives_title_size, font = tweak_data.hud_stats.objectives_font}.h, {layer = 1, valign = "center", name = "last_completed_challenge_title", color = Color.white, font_size = tweak_data.hud_stats.objectives_title_size, font = tweak_data.hud_stats.objectives_font}.w, {layer = 1, valign = "center", name = "last_completed_challenge_title", color = Color.white, font_size = tweak_data.hud_stats.objectives_title_size, font = tweak_data.hud_stats.objectives_font}.vertical, {layer = 1, valign = "center", name = "last_completed_challenge_title", color = Color.white, font_size = tweak_data.hud_stats.objectives_title_size, font = tweak_data.hud_stats.objectives_font}.align, {layer = 1, valign = "center", name = "last_completed_challenge_title", color = Color.white, font_size = tweak_data.hud_stats.objectives_title_size, font = tweak_data.hud_stats.objectives_font}.text_id = 32, 512, "top", "left", "victory_last_completed_challenge"
  managers.hud:make_fine_text(last_completed_challenge_title)
  local challenges_panel = challenges_wrapper_panel:panel({layer = 1, valign = "center", name = "challenges_panel", x = math.round(objectives_title:x() + pad), y = last_completed_challenge_title:bottom(), w = left_panel:w() - (last_completed_challenge_title:x() + pad)})
   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

  local near_completion_title = challenges_wrapper_panel:text({layer = 1, valign = "center", name = "near_completion_title", color = Color.white, font_size = tweak_data.hud_stats.objectives_title_size, font = tweak_data.hud_stats.objectives_font})
  near_completion_title:set_position(math.round(x), math.round(challenges_wrapper_panel:h() / 3))
  {layer = 1, valign = "center", name = "near_completion_title", color = Color.white, font_size = tweak_data.hud_stats.objectives_title_size, font = tweak_data.hud_stats.objectives_font}.h, {layer = 1, valign = "center", name = "near_completion_title", color = Color.white, font_size = tweak_data.hud_stats.objectives_title_size, font = tweak_data.hud_stats.objectives_font}.w, {layer = 1, valign = "center", name = "near_completion_title", color = Color.white, font_size = tweak_data.hud_stats.objectives_title_size, font = tweak_data.hud_stats.objectives_font}.vertical, {layer = 1, valign = "center", name = "near_completion_title", color = Color.white, font_size = tweak_data.hud_stats.objectives_title_size, font = tweak_data.hud_stats.objectives_font}.align, {layer = 1, valign = "center", name = "near_completion_title", color = Color.white, font_size = tweak_data.hud_stats.objectives_title_size, font = tweak_data.hud_stats.objectives_font}.text_id = 32, 512, "top", "left", "menu_near_completion_challenges"
  managers.hud:make_fine_text(near_completion_title)
  local near_completion_panel = challenges_wrapper_panel:panel({layer = 1, valign = "center", name = "near_completion_panel", x = math.round(objectives_title:x() + pad), y = near_completion_title:bottom(), w = left_panel:w() - (near_completion_title:x() + pad)})
  local right_panel = l_1_0._full_hud_panel:panel({name = "right_panel", valign = "scale", w = l_1_0._full_hud_panel:w() / 3})
  right_panel:set_x(l_1_0._full_hud_panel:w())
  right_panel:rect({name = "rect_bg", color = Color(0, 0, 0):with_alpha(0.75), valign = "scale", blend_mode = "normal"})
  local blur_bg = right_panel:bitmap({name = "blur_bg", texture = "guis/textures/test_blur_df", w = right_panel:w(), h = right_panel:h(), valign = "scale", render_template = "VertexColorTexturedBlur3D", layer = -1})
   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

  local days_title = right_panel:text({layer = 1, x = 20, y = y, name = "days_title", color = Color.white, font_size = tweak_data.hud_stats.loot_size, font = tweak_data.hud_stats.objectives_font, text = "DAY 1 OF 3"})
  managers.hud:make_fine_text(days_title)
  {layer = 1, x = 20, y = y, name = "days_title", color = Color.white, font_size = tweak_data.hud_stats.loot_size, font = tweak_data.hud_stats.objectives_font, text = "DAY 1 OF 3"}.h, {layer = 1, x = 20, y = y, name = "days_title", color = Color.white, font_size = tweak_data.hud_stats.loot_size, font = tweak_data.hud_stats.objectives_font, text = "DAY 1 OF 3"}.w, {layer = 1, x = 20, y = y, name = "days_title", color = Color.white, font_size = tweak_data.hud_stats.loot_size, font = tweak_data.hud_stats.objectives_font, text = "DAY 1 OF 3"}.vertical, {layer = 1, x = 20, y = y, name = "days_title", color = Color.white, font_size = tweak_data.hud_stats.loot_size, font = tweak_data.hud_stats.objectives_font, text = "DAY 1 OF 3"}.align = 32, 512, "top", "left"
  days_title:set_w(right_panel:w())
  local day_wrapper_panel = right_panel:panel({visible = true, layer = 1, name = "day_wrapper_panel", x = 0, y = y + math.round(managers.gui_data:scaled_size().height / 2), h = math.round(managers.gui_data:scaled_size().height / 1.5), w = right_panel:w()})
  day_wrapper_panel:set_position(days_title:x() + pad, days_title:bottom())
  day_wrapper_panel:set_w(right_panel:w() - x - day_wrapper_panel:x())
   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

  local day_title = day_wrapper_panel:text({layer = 0, x = 0, y = 0, name = "day_title", color = Color.white, font_size = tweak_data.hud_stats.objectives_title_size, font = tweak_data.hud_stats.objectives_font, text = "BLUH!"})
  managers.hud:make_fine_text(day_title)
  {layer = 0, x = 0, y = 0, name = "day_title", color = Color.white, font_size = tweak_data.hud_stats.objectives_title_size, font = tweak_data.hud_stats.objectives_font, text = "BLUH!"}.h, {layer = 0, x = 0, y = 0, name = "day_title", color = Color.white, font_size = tweak_data.hud_stats.objectives_title_size, font = tweak_data.hud_stats.objectives_font, text = "BLUH!"}.w, {layer = 0, x = 0, y = 0, name = "day_title", color = Color.white, font_size = tweak_data.hud_stats.objectives_title_size, font = tweak_data.hud_stats.objectives_font, text = "BLUH!"}.vertical, {layer = 0, x = 0, y = 0, name = "day_title", color = Color.white, font_size = tweak_data.hud_stats.objectives_title_size, font = tweak_data.hud_stats.objectives_font, text = "BLUH!"}.align = 32, 512, "top", "left"
  day_title:set_w(day_wrapper_panel:w())
  local paygrade_title = day_wrapper_panel:text({name = "paygrade_title", font = tweak_data.menu.pd2_medium_font, font_size = tweak_data.hud_stats.loot_size, text = managers.localization:to_upper_text("cn_menu_contract_paygrade_header"), color = Color.white})
  managers.hud:make_fine_text(paygrade_title)
  paygrade_title:set_top(math.round(day_title:bottom()))
  local job_data = managers.job:current_job_data()
  if job_data then
    local job_stars = managers.job:current_job_stars()
    local job_and_difficulty_stars = managers.job:current_job_and_difficulty_stars()
    local risk_color = tweak_data.screen_colors.risk
    local filled_star_rect = {0, 32, 32, 32}
    local empty_star_rect = {32, 32, 32, 32}
    local cy = paygrade_title:center_y()
    local sx = paygrade_title:right() + 8
    local level_data = {texture = "guis/textures/pd2/mission_briefing/difficulty_icons", texture_rect = filled_star_rect, w = 16, h = 16, color = tweak_data.screen_colors.text, alpha = 1}
    local risk_data = {texture = "guis/textures/pd2/crimenet_skull", w = 16, h = 16, color = risk_color, alpha = 1}
    for i = 1, job_and_difficulty_stars do
      local x = sx + (i - 1) * 18
      local is_risk = job_stars < i
      local star_data = is_risk and risk_data or level_data
      local star = day_wrapper_panel:bitmap(star_data)
      star:set_x(x)
      star:set_center_y(math.round(cy))
    end
  end
   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

  local day_payout = day_wrapper_panel:text({layer = 0, x = 0, y = 0, name = "day_payout", color = Color.white, font_size = tweak_data.hud_stats.loot_size, font = tweak_data.hud_stats.objectives_font, text = "BLUH!"})
  day_payout:set_text(utf8.to_upper(managers.localization:text("hud_day_payout", {MONEY = managers.experience:cash_string(0)})))
  {layer = 0, x = 0, y = 0, name = "day_payout", color = Color.white, font_size = tweak_data.hud_stats.loot_size, font = tweak_data.hud_stats.objectives_font, text = "BLUH!"}.h, {layer = 0, x = 0, y = 0, name = "day_payout", color = Color.white, font_size = tweak_data.hud_stats.loot_size, font = tweak_data.hud_stats.objectives_font, text = "BLUH!"}.w, {layer = 0, x = 0, y = 0, name = "day_payout", color = Color.white, font_size = tweak_data.hud_stats.loot_size, font = tweak_data.hud_stats.objectives_font, text = "BLUH!"}.vertical, {layer = 0, x = 0, y = 0, name = "day_payout", color = Color.white, font_size = tweak_data.hud_stats.loot_size, font = tweak_data.hud_stats.objectives_font, text = "BLUH!"}.align = 32, 512, "top", "left"
  managers.hud:make_fine_text(day_payout)
  day_payout:set_w(day_wrapper_panel:w())
  day_payout:set_y(math.round(paygrade_title:bottom()))
   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

  local bains_plan = day_wrapper_panel:text({name = "bains_plan", text = managers.localization:to_upper_text("menu_description"), font = tweak_data.hud_stats.objective_desc_font, font_size = tweak_data.hud_stats.day_description_size + 2})
  managers.hud:make_fine_text(bains_plan)
  {name = "bains_plan", text = managers.localization:to_upper_text("menu_description"), font = tweak_data.hud_stats.objective_desc_font, font_size = tweak_data.hud_stats.day_description_size + 2}.h, {name = "bains_plan", text = managers.localization:to_upper_text("menu_description"), font = tweak_data.hud_stats.objective_desc_font, font_size = tweak_data.hud_stats.day_description_size + 2}.word_wrap, {name = "bains_plan", text = managers.localization:to_upper_text("menu_description"), font = tweak_data.hud_stats.objective_desc_font, font_size = tweak_data.hud_stats.day_description_size + 2}.wrap, {name = "bains_plan", text = managers.localization:to_upper_text("menu_description"), font = tweak_data.hud_stats.objective_desc_font, font_size = tweak_data.hud_stats.day_description_size + 2}.vertical, {name = "bains_plan", text = managers.localization:to_upper_text("menu_description"), font = tweak_data.hud_stats.objective_desc_font, font_size = tweak_data.hud_stats.day_description_size + 2}.align, {name = "bains_plan", text = managers.localization:to_upper_text("menu_description"), font = tweak_data.hud_stats.objective_desc_font, font_size = tweak_data.hud_stats.day_description_size + 2}.color = 128, true, true, "top", "left", Color(1, 1, 1, 1)
  bains_plan:set_y(math.round(day_payout:bottom() + 20))
   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

  local day_description = day_wrapper_panel:text({name = "day_description", text = "sdsd", font = tweak_data.hud_stats.objective_desc_font, font_size = tweak_data.hud_stats.day_description_size})
  day_description:set_y(math.round(bains_plan:bottom()))
  {name = "day_description", text = "sdsd", font = tweak_data.hud_stats.objective_desc_font, font_size = tweak_data.hud_stats.day_description_size}.h, {name = "day_description", text = "sdsd", font = tweak_data.hud_stats.objective_desc_font, font_size = tweak_data.hud_stats.day_description_size}.word_wrap, {name = "day_description", text = "sdsd", font = tweak_data.hud_stats.objective_desc_font, font_size = tweak_data.hud_stats.day_description_size}.wrap, {name = "day_description", text = "sdsd", font = tweak_data.hud_stats.objective_desc_font, font_size = tweak_data.hud_stats.day_description_size}.vertical, {name = "day_description", text = "sdsd", font = tweak_data.hud_stats.objective_desc_font, font_size = tweak_data.hud_stats.day_description_size}.align, {name = "day_description", text = "sdsd", font = tweak_data.hud_stats.objective_desc_font, font_size = tweak_data.hud_stats.day_description_size}.color = 128, true, true, "top", "left", Color(1, 1, 1, 1)
  day_description:set_h(day_wrapper_panel:h())
  local profile_wrapper_panel = right_panel:panel({layer = 1, valign = {0.5, 0.5}, name = "profile_wrapper_panel", x = 20, y = y + math.round(managers.gui_data:scaled_size().height / 2), h = math.round(managers.gui_data:scaled_size().height / 2), w = left_panel:w()})
  profile_wrapper_panel:set_w(right_panel:w() - x - profile_wrapper_panel:x())
  local _, by = managers.gui_data:corner_safe_to_full(0, managers.gui_data:corner_scaled_size().height)
  profile_wrapper_panel:set_bottom(by)
  profile_wrapper_panel:set_valign({by / managers.gui_data:full_scaled_size().h, 0})
  l_1_0:_rec_round_object(left_panel)
  l_1_0:_rec_round_object(right_panel)
end

HUDStatsScreen._rec_round_object = function(l_2_0, l_2_1)
  if l_2_1.children then
    for i,d in ipairs(l_2_1:children()) do
      l_2_0:_rec_round_object(d)
    end
  end
  local x, y = l_2_1:position()
  l_2_1:set_position(math.round(x), math.round(y))
end

HUDStatsScreen.show = function(l_3_0)
  local safe = managers.hud.STATS_SCREEN_SAFERECT
  local full = managers.hud.STATS_SCREEN_FULLSCREEN
  managers.hud:show(full)
  local left_panel = l_3_0._full_hud_panel:child("left_panel")
  local right_panel = l_3_0._full_hud_panel:child("right_panel")
  left_panel:stop()
  l_3_0:_create_stats_screen_profile(right_panel:child("profile_wrapper_panel"))
  l_3_0:_create_stats_screen_objectives(left_panel:child("objectives_panel"))
  l_3_0:_update_stats_screen_loot(left_panel:child("loot_wrapper_panel"))
  l_3_0:_update_stats_screen_day(right_panel)
  local teammates_panel = managers.hud:script(PlayerBase.PLAYER_INFO_HUD_PD2).panel:child("teammates_panel")
  local objectives_panel = managers.hud:script(PlayerBase.PLAYER_INFO_HUD_PD2).panel:child("objectives_panel")
  local chat_panel = managers.hud:script(PlayerBase.PLAYER_INFO_HUD_PD2).panel:child("chat_panel")
  left_panel:animate(callback(l_3_0, l_3_0, "_animate_show_stats_left_panel"), right_panel, teammates_panel, objectives_panel, chat_panel)
  l_3_0._showing_stats_screen = true
end

HUDStatsScreen.hide = function(l_4_0)
  l_4_0._showing_stats_screen = false
  local safe = managers.hud.STATS_SCREEN_SAFERECT
  local full = managers.hud.STATS_SCREEN_FULLSCREEN
  if not managers.hud:exists(safe) then
    return 
  end
  managers.hud:hide(safe)
  local left_panel = l_4_0._full_hud_panel:child("left_panel")
  local right_panel = l_4_0._full_hud_panel:child("right_panel")
  left_panel:stop()
  local teammates_panel = managers.hud:script(PlayerBase.PLAYER_INFO_HUD_PD2).panel:child("teammates_panel")
  local objectives_panel = managers.hud:script(PlayerBase.PLAYER_INFO_HUD_PD2).panel:child("objectives_panel")
  local chat_panel = managers.hud:script(PlayerBase.PLAYER_INFO_HUD_PD2).panel:child("chat_panel")
  left_panel:animate(callback(l_4_0, l_4_0, "_animate_hide_stats_left_panel"), right_panel, teammates_panel, objectives_panel, chat_panel)
end

HUDStatsScreen._create_stats_screen_objectives = function(l_5_0, l_5_1)
  l_5_1:clear()
  local x, y = 0, 0
  local panel_w = l_5_1:w() - x
  for i,data in pairs(managers.objectives:get_active_objectives()) do
    local obj_panel = l_5_1:panel({name = "obj_panel", x = x, y = y, w = panel_w})
     -- DECOMPILER ERROR: Confused about usage of registers!

     -- DECOMPILER ERROR: Confused about usage of registers!

     -- DECOMPILER ERROR: Confused about usage of registers!

     -- DECOMPILER ERROR: Confused about usage of registers!

     -- DECOMPILER ERROR: Confused about usage of registers!

     -- DECOMPILER ERROR: Confused about usage of registers!

    local obj_title = obj_panel:text({name = "title", text = utf8.to_upper(data.text), font = tweak_data.hud.medium_font, font_size = tweak_data.hud.active_objective_title_font_size})
    managers.hud:make_fine_text(obj_title)
    {name = "title", text = utf8.to_upper(data.text), font = tweak_data.hud.medium_font, font_size = tweak_data.hud.active_objective_title_font_size}.h, {name = "title", text = utf8.to_upper(data.text), font = tweak_data.hud.medium_font, font_size = tweak_data.hud.active_objective_title_font_size}.word_wrap, {name = "title", text = utf8.to_upper(data.text), font = tweak_data.hud.medium_font, font_size = tweak_data.hud.active_objective_title_font_size}.wrap, {name = "title", text = utf8.to_upper(data.text), font = tweak_data.hud.medium_font, font_size = tweak_data.hud.active_objective_title_font_size}.vertical, {name = "title", text = utf8.to_upper(data.text), font = tweak_data.hud.medium_font, font_size = tweak_data.hud.active_objective_title_font_size}.align, {name = "title", text = utf8.to_upper(data.text), font = tweak_data.hud.medium_font, font_size = tweak_data.hud.active_objective_title_font_size}.color = tweak_data.hud.active_objective_title_font_size, true, true, "top", "left", Color.white
    obj_title:set_w(obj_title:w() + 1)
     -- DECOMPILER ERROR: Confused about usage of registers!

     -- DECOMPILER ERROR: Confused about usage of registers!

     -- DECOMPILER ERROR: Confused about usage of registers!

     -- DECOMPILER ERROR: Confused about usage of registers!

     -- DECOMPILER ERROR: Confused about usage of registers!

     -- DECOMPILER ERROR: Confused about usage of registers!

    local obj_description = obj_panel:text({name = "description", text = data.description, font = tweak_data.hud_stats.objective_desc_font, font_size = 24})
    managers.hud:make_fine_text(obj_description)
    {name = "description", text = data.description, font = tweak_data.hud_stats.objective_desc_font, font_size = 24}.h, {name = "description", text = data.description, font = tweak_data.hud_stats.objective_desc_font, font_size = 24}.word_wrap, {name = "description", text = data.description, font = tweak_data.hud_stats.objective_desc_font, font_size = 24}.wrap, {name = "description", text = data.description, font = tweak_data.hud_stats.objective_desc_font, font_size = 24}.vertical, {name = "description", text = data.description, font = tweak_data.hud_stats.objective_desc_font, font_size = 24}.align, {name = "description", text = data.description, font = tweak_data.hud_stats.objective_desc_font, font_size = 24}.color = 128, true, true, "top", "left", Color(1, 1, 1, 1)
    obj_description:set_h(obj_description:h() + 10)
    obj_panel:set_h(obj_title:h() + obj_description:h())
    obj_description:set_lefttop(obj_title:leftbottom())
    y = math.ceil(y + obj_panel:h())
  end
end

HUDStatsScreen._create_stats_screen_profile = function(l_6_0, l_6_1)
  l_6_1:stop()
  l_6_1:clear()
  if not managers.experience:next_level_data() then
    local next_level_data = {}
  end
  local bg_ring = l_6_1:bitmap({texture = "guis/textures/pd2/level_ring_small", w = 64, h = 64, color = Color.black, alpha = 0.40000000596046})
  local exp_ring = l_6_1:bitmap({texture = "guis/textures/pd2/level_ring_small", rotation = 360, w = 64, h = 64, color = Color((next_level_data.current_points or 1) / (next_level_data.points or 1), 1, 1), render_template = "VertexColorTexturedRadial", blend_mode = "add", layer = 1})
  bg_ring:set_bottom(l_6_1:h())
  exp_ring:set_bottom(l_6_1:h())
  local gain_xp = managers.experience:get_xp_dissected(true, 0)
  local at_max_level = managers.experience:current_level() == managers.experience:level_cap()
  local can_lvl_up = not at_max_level and next_level_data.points - next_level_data.current_points <= gain_xp
  local progress = (next_level_data.current_points or 1) / (next_level_data.points or 1)
  local gain_progress = (gain_xp or 1) / (next_level_data.points or 1)
  local exp_gain_ring = l_6_1:bitmap({texture = "guis/textures/pd2/level_ring_potential_small", rotation = 360, w = 64, h = 64, color = Color(gain_progress, 1, 0), render_template = "VertexColorTexturedRadial", blend_mode = "normal", layer = 2})
  exp_gain_ring:rotate(360 * progress)
  exp_gain_ring:set_center(exp_ring:center())
  local level_text = l_6_1:text({name = "level_text", font = tweak_data.menu.pd2_medium_font, font_size = tweak_data.hud_stats.day_description_size, text = tostring(managers.experience:current_level()), color = tweak_data.screen_colors.text})
  managers.hud:make_fine_text(level_text)
  level_text:set_center(exp_ring:center())
  if at_max_level then
    local text = managers.localization:to_upper_text("hud_at_max_level")
    local at_max_level_text = l_6_1:text({name = "at_max_level_text", text = text, font_size = tweak_data.menu.pd2_small_font_size, font = tweak_data.menu.pd2_small_font, color = tweak_data.hud_stats.potential_xp_color})
    managers.hud:make_fine_text(at_max_level_text)
    at_max_level_text:set_left(math.round(exp_ring:right() + 4))
    at_max_level_text:set_center_y(math.round(exp_ring:center_y()) + 0)
  else
    local next_level_in = l_6_1:text({name = "next_level_in", text = "", font_size = tweak_data.menu.pd2_small_font_size, font = tweak_data.menu.pd2_small_font, color = tweak_data.screen_colors.text})
    local points = next_level_data.points - next_level_data.current_points
    next_level_in:set_text(utf8.to_upper(managers.localization:text("menu_es_next_level") .. " " .. points))
    managers.hud:make_fine_text(next_level_in)
    next_level_in:set_left(math.round(exp_ring:right() + 4))
    next_level_in:set_center_y(math.round(exp_ring:center_y()) - 20)
    local text = managers.localization:to_upper_text("hud_potential_xp", {XP = gain_xp})
    local gain_xp_text = l_6_1:text({name = "gain_xp_text", text = text, font_size = tweak_data.menu.pd2_small_font_size, font = tweak_data.menu.pd2_small_font, color = tweak_data.hud_stats.potential_xp_color})
    managers.hud:make_fine_text(gain_xp_text)
    gain_xp_text:set_left(math.round(exp_ring:right() + 4))
    gain_xp_text:set_center_y(math.round(exp_ring:center_y()) + 0)
    if can_lvl_up then
      local text = managers.localization:to_upper_text("hud_potential_level_up")
       -- DECOMPILER ERROR: Confused about usage of registers!

       -- DECOMPILER ERROR: Confused about usage of registers!

       -- DECOMPILER ERROR: Confused about usage of registers!

       -- DECOMPILER ERROR: Confused about usage of registers!

       -- DECOMPILER ERROR: Confused about usage of registers!

       -- DECOMPILER ERROR: Confused about usage of registers!

      local potential_level_up_text = l_6_1:text({layer = 3, name = "potential_level_up_text", align = "left", vertical = "center"})
      managers.hud:make_fine_text(potential_level_up_text)
      {layer = 3, name = "potential_level_up_text", align = "left", vertical = "center"}.color, {layer = 3, name = "potential_level_up_text", align = "left", vertical = "center"}.font, {layer = 3, name = "potential_level_up_text", align = "left", vertical = "center"}.font_size, {layer = 3, name = "potential_level_up_text", align = "left", vertical = "center"}.text, {layer = 3, name = "potential_level_up_text", align = "left", vertical = "center"}.visible, {layer = 3, name = "potential_level_up_text", align = "left", vertical = "center"}.blend_mode = tweak_data.hud_stats.potential_xp_color, tweak_data.menu.pd2_small_font, tweak_data.menu.pd2_small_font_size, text, can_lvl_up, "normal"
      potential_level_up_text:set_left(math.round(exp_ring:right() + 4))
      potential_level_up_text:set_center_y(math.round(exp_ring:center_y()) + 20)
      potential_level_up_text:animate(callback(l_6_0, l_6_0, "_animate_text_pulse"), exp_gain_ring, exp_ring)
    end
  end
end

HUDStatsScreen._animate_text_pulse = function(l_7_0, l_7_1, l_7_2, l_7_3)
  local t = 0
  local c = l_7_1:color()
  local w, h = l_7_1:size()
  local cx, cy = l_7_1:center()
  do
    local ecx, ecy = l_7_2:center()
    repeat
      local dt = coroutine.yield()
      t = t + dt
      do
        local alpha = math.abs(math.sin((t) * 180 * 1))
        l_7_1:set_size(math.lerp(w * 2, w, alpha), math.lerp(h * 2, h, alpha))
        l_7_1:set_font_size(math.lerp(25, tweak_data.menu.pd2_small_font_size, alpha * alpha))
        l_7_1:set_center_y(cy)
        l_7_2:set_size(math.lerp(72, 64, alpha * alpha), math.lerp(72, 64, alpha * alpha))
        l_7_2:set_center(ecx, ecy)
        l_7_3:set_size(l_7_2:size())
        l_7_3:set_center(l_7_2:center())
      end
      do return end
    end
     -- Warning: missing end command somewhere! Added here
  end
end

HUDStatsScreen._update_stats_screen_loot = function(l_8_0, l_8_1)
  print("HUDStatsScreen:_update_stats_screen_loot")
  local mandatory_bags_data = managers.loot:get_mandatory_bags_data()
  local secured_amount = managers.loot:get_secured_mandatory_bags_amount()
  local mission_bags_panel = l_8_1:child("mission_bags_panel")
  mission_bags_panel:clear()
  local bag_texture, bag_rect = tweak_data.hud_icons:get_icon_data("bag_icon")
  if mandatory_bags_data and mandatory_bags_data.amount then
    for i = 1, mandatory_bags_data.amount do
      local x = (i - 1) * 32
      local alpha = i <= secured_amount and 1 or 0.25
      mission_bags_panel:bitmap({name = "bag" .. i, texture = bag_texture, texture_rect = bag_rect, x = x, alpha = alpha})
    end
  end
  local bonus_amount = managers.loot:get_secured_bonus_bags_amount()
  local bonus_vis = bonus_amount > 0 or secured_amount > 0
  local bonus_bags_title = l_8_1:child("bonus_bags_title")
  bonus_bags_title:set_alpha(bonus_vis and 1 or 0.5)
  local bonus_bags_panel = l_8_1:child("bonus_bags_panel")
  bonus_bags_panel:clear()
  local x = 10
  if x <= bonus_amount then
    local x = 0
    local bag = bonus_bags_panel:bitmap({name = "bag1", texture = bag_texture, texture_rect = bag_rect, x = x})
    local bag_text = bonus_bags_panel:text({name = "bag_amount", text = " x" .. tostring(bonus_amount), font_size = tweak_data.menu.pd2_small_font_size, font = tweak_data.menu.pd2_small_font})
    managers.hud:make_fine_text(bag_text)
    bag_text:set_left(bag:right())
    bag_text:set_center_y(math.round(bag:center_y()))
  else
    for i = 1, bonus_amount do
      local x = (i - 1) * 32
      bonus_bags_panel:bitmap({name = "bag" .. i, texture = bag_texture, texture_rect = bag_rect, x = x})
    end
  end
  local money = managers.money:get_secured_bonus_bags_money()
  local bonus_bags_payout = l_8_1:child("bonus_bags_payout")
  bonus_bags_payout:set_visible(bonus_vis)
  bonus_bags_payout:set_text(utf8.to_upper(managers.localization:text("hud_bonus_bags_payout", {MONEY = managers.experience:cash_string(money)})))
  local instant_cash = managers.loot:get_real_total_small_loot_value()
  local instant_vis = instant_cash > 0
  local instant_cash_title = l_8_1:child("instant_cash_title")
  instant_cash_title:set_alpha(instant_vis and 1 or 0.5)
  local instant_cash_text = l_8_1:child("instant_cash_text")
  instant_cash_text:set_text(utf8.to_upper(managers.experience:cash_string(instant_cash)))
  instant_cash_text:set_alpha(instant_vis and 1 or 0.5)
end

HUDStatsScreen._update_stats_screen_day = function(l_9_0, l_9_1)
  local job_data = managers.job:current_job_data()
  local stage_data = managers.job:current_stage_data()
   -- DECOMPILER ERROR: Confused while interpreting a jump as a 'while'

end
local has_stage_data = true
local days_title = l_9_1:child("days_title")
days_title:set_visible(has_stage_data)
local day_wrapper_panel = l_9_1:child("day_wrapper_panel")
day_wrapper_panel:set_visible(has_stage_data)
if job_data and managers.job:current_job_id() == "safehouse" and Global.mission_manager.saved_job_values.playedSafeHouseBefore then
  l_9_1:set_visible(false)
  return 
end
if not l_9_0._current_job_data or not #l_9_0._current_job_data.chain then
  local num_stages = not has_stage_data or 0
end
local day = managers.job:current_stage()
local days = job_data and #job_data.chain or 0
days_title:set_text(utf8.to_upper(managers.localization:text("hud_days_title", {DAY = day, DAYS = days})))
local payout = managers.money:get_potential_payout_from_current_stage()
local day_payout = day_wrapper_panel:child("day_payout")
day_payout:set_text(utf8.to_upper(managers.localization:text("hud_day_payout", {MONEY = managers.experience:cash_string(payout)})))
local level_data = managers.job:current_level_data()
if level_data then
  local day_title = day_wrapper_panel:child("day_title")
  day_title:set_text(utf8.to_upper(managers.localization:text(level_data.name_id)))
  if not stage_data.briefing_id then
    local briefing_id = level_data.briefing_id
  end
  local day_description = day_wrapper_panel:child("day_description")
  day_description:set_text(managers.localization:text(briefing_id))
end
end

HUDStatsScreen._create_stats_screen_challenges = function(l_10_0, l_10_1, l_10_2)
  l_10_1:clear()
  local last_comleted_title_text = l_10_1:text({name = "last_comleted_title_text", text = utf8.to_upper(managers.challenges:get_last_comleted_title_text()), font_size = tweak_data.menu.loading_challenge_name_font_size, font = tweak_data.hud_stats.objectives_font})
  managers.hud:make_fine_text(last_comleted_title_text)
  local last_comleted_description_text = l_10_1:text({name = "last_comleted_description_text", text = utf8.to_upper(managers.challenges:get_last_comleted_description_text()), font_size = tweak_data.hud.small_font_size, font = tweak_data.hud.small_font, y = last_comleted_title_text:bottom(), wrap = true, word_wrap = true})
  managers.hud:make_fine_text(last_comleted_description_text)
  l_10_2:clear()
  local challenges = managers.challenges:get_near_completion()
  challenges = {challenges[1], challenges[2], challenges[3]}
  local w = l_10_2:w() - 8
  do
    local y = 0
    for i,challenge in ipairs(challenges) do
      local text = l_10_2:text({text = utf8.to_upper(challenge.name), y = y, font = tweak_data.hud.medium_font, font_size = tweak_data.menu.loading_challenge_name_font_size, color = Color.white, align = "left", layer = 1})
      managers.hud:make_fine_text(text)
      y = y + text:h()
      local c_panel = l_10_2:panel({w = w, h = 22, y = y})
       -- DECOMPILER ERROR: Confused about usage of registers!

       -- DECOMPILER ERROR: Confused about usage of registers!

       -- DECOMPILER ERROR: Confused about usage of registers!

       -- DECOMPILER ERROR: Confused about usage of registers!

       -- DECOMPILER ERROR: Confused about usage of registers!

       -- DECOMPILER ERROR: Confused about usage of registers!

       -- DECOMPILER ERROR: Confused about usage of registers!

      local bg_bar = c_panel:rect({x = 0, y = 0})
       -- DECOMPILER ERROR: Overwrote pending register.

       -- DECOMPILER ERROR: Overwrote pending register.

       -- DECOMPILER ERROR: Confused about usage of registers!

       -- DECOMPILER ERROR: Confused about usage of registers!

       -- DECOMPILER ERROR: Confused about usage of registers!

       -- DECOMPILER ERROR: Confused about usage of registers!

       -- DECOMPILER ERROR: Confused about usage of registers!

       -- DECOMPILER ERROR: Confused about usage of registers!

      local bar = c_panel:gradient({orientation = "vertical", gradient_points = {}, x = 2, y = 2})
       -- DECOMPILER ERROR: Confused about usage of registers!

       -- DECOMPILER ERROR: Overwrote pending register.

       -- DECOMPILER ERROR: Confused about usage of registers!

       -- DECOMPILER ERROR: Confused about usage of registers!

      local progress_text = c_panel:text({font_size = tweak_data.menu.loading_challenge_progress_font_size, font = tweak_data.hud.medium_font, x = 0, y = 0, h = bg_bar:h(), w = bg_bar:w(), align = "center", halign = "center", vertical = "center", valign = "center"})
    end
  end
   -- Warning: undefined locals caused missing assignments!
end

HUDStatsScreen.loot_value_updated = function(l_11_0)
  local right_panel = l_11_0._full_hud_panel:child("right_panel")
  local left_panel = l_11_0._full_hud_panel:child("left_panel")
  l_11_0:_update_stats_screen_loot(left_panel:child("loot_wrapper_panel"))
end

HUDStatsScreen._animate_show_stats_left_panel = function(l_12_0, l_12_1, l_12_2, l_12_3, l_12_4, l_12_5)
  local start_x = l_12_1:x()
  local start_a = 1 - start_x / -l_12_1:w()
  local TOTAL_T = 0.33000001311302 * (start_x / -l_12_1:w())
  do
    local t = 0
    repeat
      if t < TOTAL_T then
        local dt = coroutine.yield() * (1 / TimerManager:game():multiplier())
        t = t + dt
        local a = math.lerp(start_a, 1, (t) / TOTAL_T)
        l_12_1:set_alpha(a)
        l_12_1:set_x(math.lerp(start_x, 0, (t) / TOTAL_T))
        l_12_2:set_alpha(a)
        l_12_2:set_x(l_12_2:parent():w() - (l_12_1:x() + l_12_2:w()))
        local a_half = 0.5 + (1 - a) * 0.5
        l_12_3:set_alpha(a_half)
        l_12_4:set_alpha(1 - a)
        l_12_5:set_alpha(a_half)
      else
        l_12_1:set_x(0)
        l_12_1:set_alpha(1)
        l_12_3:set_alpha(0.5)
        l_12_4:set_alpha(0)
        l_12_5:set_alpha(0.5)
        l_12_2:set_alpha(1)
        l_12_2:set_x(l_12_2:parent():w() - l_12_2:w())
      end
       -- Warning: missing end command somewhere! Added here
    end
     -- Warning: missing end command somewhere! Added here
  end
end

HUDStatsScreen._animate_hide_stats_left_panel = function(l_13_0, l_13_1, l_13_2, l_13_3, l_13_4, l_13_5)
  local start_x = l_13_1:x()
  local start_a = 1 - start_x / -l_13_1:w()
  local TOTAL_T = 0.33000001311302 * (1 - start_x / -l_13_1:w())
  do
    local t = 0
    repeat
      if t < TOTAL_T then
        local dt = coroutine.yield() * (1 / TimerManager:game():multiplier())
        t = t + dt
        local a = math.lerp(start_a, 0, (t) / TOTAL_T)
        l_13_1:set_alpha(a)
        l_13_1:set_x(math.lerp(start_x, -l_13_1:w(), (t) / TOTAL_T))
        l_13_2:set_alpha(a)
        l_13_2:set_x(l_13_2:parent():w() - (l_13_1:x() + l_13_2:w()))
        local a_half = 0.5 + (1 - a) * 0.5
        l_13_3:set_alpha(a_half)
        l_13_4:set_alpha(1 - a)
        l_13_5:set_alpha(a_half)
      else
        l_13_1:set_x(-l_13_1:w())
        l_13_1:set_alpha(0)
        l_13_3:set_alpha(1)
        l_13_4:set_alpha(1)
        l_13_5:set_alpha(1)
        l_13_2:set_alpha(0)
        l_13_2:set_x(l_13_2:parent():w())
      end
       -- Warning: missing end command somewhere! Added here
    end
     -- Warning: missing end command somewhere! Added here
  end
end


