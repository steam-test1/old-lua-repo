-- Decompiled using luadec 2.0.1 by sztupy (http://winmo.sztupy.hu)
-- Command line was: F:\SteamLibrary\SteamApps\common\PAYDAY 2\lua\lib\managers\hud\hudblackscreen.luac 

if not HUDBlackScreen then
  HUDBlackScreen = class()
end
HUDBlackScreen.init = function(l_1_0, l_1_1)
  l_1_0._hud_panel = l_1_1.panel
  if l_1_0._hud_panel:child("blackscreen_panel") then
    l_1_0._hud_panel:remove(l_1_0._hud_panel:child("blackscreen_panel"))
  end
  l_1_0._blackscreen_panel = l_1_0._hud_panel:panel({visible = true, name = "blackscreen_panel", y = 0, valign = "grow", halign = "grow", layer = 0})
   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

  local mid_text = l_1_0._blackscreen_panel:text({name = "mid_text", visible = true, text = "000", layer = 1, color = Color.white, y = 0, valign = {0.40000000596046, 0}, align = "center"})
  local _, _, _, h = mid_text:text_rect()
  mid_text:set_h(h)
  {name = "mid_text", visible = true, text = "000", layer = 1, color = Color.white, y = 0, valign = {0.40000000596046, 0}, align = "center"}.w, {name = "mid_text", visible = true, text = "000", layer = 1, color = Color.white, y = 0, valign = {0.40000000596046, 0}, align = "center"}.font, {name = "mid_text", visible = true, text = "000", layer = 1, color = Color.white, y = 0, valign = {0.40000000596046, 0}, align = "center"}.font_size, {name = "mid_text", visible = true, text = "000", layer = 1, color = Color.white, y = 0, valign = {0.40000000596046, 0}, align = "center"}.vertical = l_1_0._blackscreen_panel:w(), tweak_data.hud.medium_font, tweak_data.hud.default_font_size, "center"
  mid_text:set_center_x(l_1_0._blackscreen_panel:center_x())
  mid_text:set_center_y(l_1_0._blackscreen_panel:h() / 2.5)
  local is_server = Network:is_server()
  local text = utf8.to_upper(managers.localization:text("hud_skip_blackscreen", {BTN_ACCEPT = managers.localization:btn_macro("continue")}))
   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

  local skip_text = l_1_0._blackscreen_panel:text({name = "skip_text", visible = is_server, text = text, layer = 1})
  l_1_0._circle_radius, {name = "skip_text", visible = is_server, text = text, layer = 1}.font, {name = "skip_text", visible = is_server, text = text, layer = 1}.font_size, {name = "skip_text", visible = is_server, text = text, layer = 1}.vertical, {name = "skip_text", visible = is_server, text = text, layer = 1}.align, {name = "skip_text", visible = is_server, text = text, layer = 1}.y, {name = "skip_text", visible = is_server, text = text, layer = 1}.color = 16, tweak_data.hud.medium_font_noshadow, nil, "bottom", "right", 0, Color.white
  l_1_0._sides = 64
  skip_text:set_x(skip_text:x() - l_1_0._circle_radius * 3)
  skip_text:set_y(skip_text:y() - l_1_0._circle_radius)
  l_1_0._skip_circle = CircleBitmapGuiObject:new(l_1_0._blackscreen_panel, {image = "guis/textures/pd2/hud_progress_32px", radius = l_1_0._circle_radius, sides = l_1_0._sides, current = l_1_0._sides, total = l_1_0._sides, blend_mode = "normal", color = Color.white, layer = 2})
  l_1_0._skip_circle:set_position(l_1_0._blackscreen_panel:w() - l_1_0._circle_radius * 3, l_1_0._blackscreen_panel:h() - l_1_0._circle_radius * 3)
end

HUDBlackScreen.set_skip_circle = function(l_2_0, l_2_1, l_2_2)
  l_2_0._skip_circle:set_current(l_2_1 / l_2_2)
end

HUDBlackScreen.skip_circle_done = function(l_3_0)
  l_3_0._blackscreen_panel:child("skip_text"):set_visible(false)
  local bitmap = l_3_0._blackscreen_panel:bitmap({texture = "guis/textures/pd2/hud_progress_32px", w = l_3_0._circle_radius * 2, h = l_3_0._circle_radius * 2, blend_mode = "add", align = "center", valign = "center", layer = 2})
  bitmap:set_position(l_3_0._skip_circle:position())
  local circle = CircleBitmapGuiObject:new(l_3_0._blackscreen_panel, {image = "guis/textures/pd2/hud_progress_32px", radius = l_3_0._circle_radius, sides = 64, current = 64, total = 64, color = Color.white:with_alpha(1), blend_mode = "normal", layer = 3})
  circle:set_position(l_3_0._skip_circle:position())
  bitmap:animate(callback(l_3_0, HUDInteraction, "_animate_interaction_complete"), circle)
end

HUDBlackScreen.set_job_data = function(l_4_0)
  if not managers.job:has_active_job() then
    return 
  end
  local job_panel = l_4_0._blackscreen_panel:panel({visible = true, name = "job_panel", y = 0, valign = "grow", halign = "grow", layer = 1})
  local risk_panel = (job_panel:panel({}))
  local last_risk_level = nil
  for i = 1, managers.job:current_difficulty_stars() do
    last_risk_level = risk_panel:bitmap({texture = "guis/textures/pd2/risklevel_blackscreen", color = tweak_data.screen_colors.risk})
    last_risk_level:move((i - 1) * last_risk_level:w(), 0)
  end
  if last_risk_level then
    risk_panel:set_size(last_risk_level:right(), last_risk_level:bottom())
    risk_panel:set_center(job_panel:w() / 2, job_panel:h() / 2)
    risk_panel:set_position(math.round(risk_panel:x()), math.round(risk_panel:y()))
    local risk_text = job_panel:text({text = managers.localization:to_upper_text(tweak_data.difficulty_name_id), font = tweak_data.menu.pd2_large_font, font_size = tweak_data.menu.pd2_small_large_size, align = "center", vertical = "bottom", color = tweak_data.screen_colors.risk})
    risk_text:set_bottom(risk_panel:top())
    risk_text:set_center_x(risk_panel:center_x())
  end
  return 
  local contact_data = managers.job:current_contact_data()
  local job_data = managers.job:current_job_data()
  if l_4_0._blackscreen_panel:child("job_panel") then
    l_4_0._blackscreen_panel:remove(l_4_0._blackscreen_panel:child("job_panel"))
  end
  local job_panel = l_4_0._blackscreen_panel:panel({visible = true, name = "job_panel", y = 0, valign = "grow", halign = "grow", layer = 0})
  job_panel:hide()
   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

  job_panel:text({name = "title", text = managers.localization:text(job_data.name_id)})
  {name = "title", text = managers.localization:text(job_data.name_id)}.h, {name = "title", text = managers.localization:text(job_data.name_id)}.w, {name = "title", text = managers.localization:text(job_data.name_id)}.font, {name = "title", text = managers.localization:text(job_data.name_id)}.font_size, {name = "title", text = managers.localization:text(job_data.name_id)}.vertical, {name = "title", text = managers.localization:text(job_data.name_id)}.align, {name = "title", text = managers.localization:text(job_data.name_id)}.layer = 32, job_panel:w(), tweak_data.hud.medium_font, tweak_data.hud.default_font_size, "top", "center", 1
   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

  local contact_name = job_panel:text({name = "contact_name", text = managers.localization:text(contact_data.name_id), layer = 1, align = "left"})
  local portrait = job_panel:bitmap({name = "portrait", texture = contact_data.image, y = contact_name:bottom()})
   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

  job_panel:text({name = "payout", text = "Payout: $1.000.000", layer = 1, align = "left"})
  {name = "payout", text = "Payout: $1.000.000", layer = 1, align = "left"}.y, {name = "payout", text = "Payout: $1.000.000", layer = 1, align = "left"}.h, {name = "payout", text = "Payout: $1.000.000", layer = 1, align = "left"}.w, {name = "payout", text = "Payout: $1.000.000", layer = 1, align = "left"}.font, {name = "payout", text = "Payout: $1.000.000", layer = 1, align = "left"}.font_size, {name = "payout", text = "Payout: $1.000.000", layer = 1, align = "left"}.vertical, {name = "contact_name", text = managers.localization:text(contact_data.name_id), layer = 1, align = "left"}.y, {name = "contact_name", text = managers.localization:text(contact_data.name_id), layer = 1, align = "left"}.h, {name = "contact_name", text = managers.localization:text(contact_data.name_id), layer = 1, align = "left"}.w, {name = "contact_name", text = managers.localization:text(contact_data.name_id), layer = 1, align = "left"}.font, {name = "contact_name", text = managers.localization:text(contact_data.name_id), layer = 1, align = "left"}.font_size, {name = "contact_name", text = managers.localization:text(contact_data.name_id), layer = 1, align = "left"}.vertical = portrait:bottom() + 32, 32, job_panel:w(), tweak_data.hud.medium_font, tweak_data.hud.default_font_size, "top", 50, 32, job_panel:w(), tweak_data.hud.medium_font, tweak_data.hud.default_font_size, "top"
  l_4_0:_create_stages()
  local level_data = managers.job:current_level_data()
   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

  local objective_title = job_panel:text({name = "objective_title", text = managers.localization:text("hud_objectives"), layer = 1, align = "left"})
   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

  do
    local objective_text = job_panel:text({name = "objective_text", text = managers.localization:text(level_data.briefing_id), layer = 1, align = "left", vertical = "top", font_size = tweak_data.hud.small_font_size, font = tweak_data.hud.small_font, w = job_panel:w()})
  end
  {name = "objective_text", text = managers.localization:text(level_data.briefing_id), layer = 1, align = "left", vertical = "top", font_size = tweak_data.hud.small_font_size, font = tweak_data.hud.small_font, w = job_panel:w()}.word_wrap, {name = "objective_text", text = managers.localization:text(level_data.briefing_id), layer = 1, align = "left", vertical = "top", font_size = tweak_data.hud.small_font_size, font = tweak_data.hud.small_font, w = job_panel:w()}.wrap, {name = "objective_text", text = managers.localization:text(level_data.briefing_id), layer = 1, align = "left", vertical = "top", font_size = tweak_data.hud.small_font_size, font = tweak_data.hud.small_font, w = job_panel:w()}.y, {name = "objective_text", text = managers.localization:text(level_data.briefing_id), layer = 1, align = "left", vertical = "top", font_size = tweak_data.hud.small_font_size, font = tweak_data.hud.small_font, w = job_panel:w()}.h, {name = "objective_title", text = managers.localization:text("hud_objectives"), layer = 1, align = "left"}.y, {name = "objective_title", text = managers.localization:text("hud_objectives"), layer = 1, align = "left"}.h, {name = "objective_title", text = managers.localization:text("hud_objectives"), layer = 1, align = "left"}.w, {name = "objective_title", text = managers.localization:text("hud_objectives"), layer = 1, align = "left"}.font, {name = "objective_title", text = managers.localization:text("hud_objectives"), layer = 1, align = "left"}.font_size, {name = "objective_title", text = managers.localization:text("hud_objectives"), layer = 1, align = "left"}.vertical = true, true, job_panel:h() / 2 + 50, 32, job_panel:h() / 2, 32, job_panel:w(), tweak_data.hud.medium_font, tweak_data.hud.default_font_size, "top"
end

HUDBlackScreen._create_stages = function(l_5_0)
  local job_data = managers.job:current_job_data()
  local job_panel = l_5_0._blackscreen_panel:child("job_panel")
  local stages_panel = job_panel:panel({visible = true, name = "stages_panel", y = job_panel:child("contact_name"):bottom(), x = 320, h = 256})
  local types = {a = {256, 0, 64, 64}, b = {192, 0, 64, 64}, c = {128, 0, 64, 64}, d = {64, 0, 64, 64}, e = {0, 0, 64, 64}}
  local level_rects = {{0, 0, 256, 256}, {768, 0, 256, 256}, {512, 0, 256, 256}, {256, 0, 256, 256}}
  local x = 0
  for i,heist in ipairs(job_data.chain) do
    local is_current_stage = managers.job:current_stage() == i
    local is_completed = i < managers.job:current_stage()
    local panel = stages_panel:panel({visible = true, name = "panel", y = 0, x = x, w = is_current_stage and 256 or 80})
    if not is_completed and not is_current_stage then
      local image = panel:bitmap({texture = "guis/textures/pd2/icon_mission_overview_unknown", layer = 1, blend_mode = "normal"})
      image:set_center(panel:w() / 2, panel:h() / 2)
    else
      local image = panel:bitmap({texture = "guis/textures/pd2/icon_mission_overview", layer = 1, texture_rect = level_rects[i], blend_mode = "normal"})
      image:set_center(panel:w() / 2, panel:h() / 2)
    end
    local badge = panel:bitmap({texture = "guis/textures/pd2/gui_grade_badges", layer = 4, texture_rect = types[heist.type]})
    badge:set_right(panel:w() - 8)
    badge:set_bottom(panel:h() - 8)
     -- DECOMPILER ERROR: Overwrote pending register.

     -- DECOMPILER ERROR: Overwrote pending register.

     -- DECOMPILER ERROR: Overwrote pending register.

     -- DECOMPILER ERROR: Overwrote pending register.

     -- DECOMPILER ERROR: Overwrote pending register.

     -- DECOMPILER ERROR: Overwrote pending register.

     -- DECOMPILER ERROR: Overwrote pending register.

     -- DECOMPILER ERROR: Overwrote pending register.

    if (not is_completed or not {}) and (not is_current_stage or not {}) then
      local gradient_points = {}
    end
     -- DECOMPILER ERROR: Overwrote pending register.

     -- DECOMPILER ERROR: Overwrote pending register.

     -- DECOMPILER ERROR: Overwrote pending register.

    0(Color(120, 255, 120) / 255:with_alpha(0.25)(1, Color(120, 255, 120) / 255:with_alpha(0), 150) / 255:with_alpha(0.5).black:with_alpha(Color(230, 200, 150) / 255:with_alpha(0)), {layer = 3, gradient_points = gradient_points, orientation = "vertical", h = Color.black:with_alpha(0)(panel) / 2})
    x = x + panel:w() + 10
    local level_data = tweak_data.levels[heist.level_id]
    if is_current_stage then
      local pad = 8
       -- DECOMPILER ERROR: Confused about usage of registers!

       -- DECOMPILER ERROR: Confused about usage of registers!

       -- DECOMPILER ERROR: Confused about usage of registers!

       -- DECOMPILER ERROR: Confused about usage of registers!

      panel:text({name = "stage_name", text = utf8.to_upper(managers.localization:text(level_data.name_id)), layer = 0, align = "left", vertical = "top", font_size = tweak_data.hud.small_font_size, font = tweak_data.hud.small_font, w = panel:w()})
      {name = "stage_name", text = utf8.to_upper(managers.localization:text(level_data.name_id)), layer = 0, align = "left", vertical = "top", font_size = tweak_data.hud.small_font_size, font = tweak_data.hud.small_font, w = panel:w()}.layer, {name = "stage_name", text = utf8.to_upper(managers.localization:text(level_data.name_id)), layer = 0, align = "left", vertical = "top", font_size = tweak_data.hud.small_font_size, font = tweak_data.hud.small_font, w = panel:w()}.y, {name = "stage_name", text = utf8.to_upper(managers.localization:text(level_data.name_id)), layer = 0, align = "left", vertical = "top", font_size = tweak_data.hud.small_font_size, font = tweak_data.hud.small_font, w = panel:w()}.x, {name = "stage_name", text = utf8.to_upper(managers.localization:text(level_data.name_id)), layer = 0, align = "left", vertical = "top", font_size = tweak_data.hud.small_font_size, font = tweak_data.hud.small_font, w = panel:w()}.h = 4, pad, pad, 24
       -- DECOMPILER ERROR: Confused about usage of registers!

       -- DECOMPILER ERROR: Confused about usage of registers!

       -- DECOMPILER ERROR: Confused about usage of registers!

       -- DECOMPILER ERROR: Confused about usage of registers!

      panel:text({name = "type", text = utf8.to_upper(managers.localization:text(heist.type_id)), layer = 0, align = "left", vertical = "top", font_size = tweak_data.hud.small_font_size, font = tweak_data.hud.small_font, w = panel:w()})
      {name = "type", text = utf8.to_upper(managers.localization:text(heist.type_id)), layer = 0, align = "left", vertical = "top", font_size = tweak_data.hud.small_font_size, font = tweak_data.hud.small_font, w = panel:w()}.layer, {name = "type", text = utf8.to_upper(managers.localization:text(heist.type_id)), layer = 0, align = "left", vertical = "top", font_size = tweak_data.hud.small_font_size, font = tweak_data.hud.small_font, w = panel:w()}.y, {name = "type", text = utf8.to_upper(managers.localization:text(heist.type_id)), layer = 0, align = "left", vertical = "top", font_size = tweak_data.hud.small_font_size, font = tweak_data.hud.small_font, w = panel:w()}.x, {name = "type", text = utf8.to_upper(managers.localization:text(heist.type_id)), layer = 0, align = "left", vertical = "top", font_size = tweak_data.hud.small_font_size, font = tweak_data.hud.small_font, w = panel:w()}.h = 4, pad + 24, pad, 24
    end
    stages_panel:set_w(panel:right())
  end
  stages_panel:set_center_x(math.round(job_panel:child("portrait"):w() + (job_panel:w() - job_panel:child("portrait"):w()) / 2))
end

HUDBlackScreen.set_mid_text = function(l_6_0, l_6_1)
  local mid_text = l_6_0._blackscreen_panel:child("mid_text")
  mid_text:set_alpha(0)
  mid_text:set_text(utf8.to_upper(l_6_1))
end

HUDBlackScreen.fade_in_mid_text = function(l_7_0)
  l_7_0._blackscreen_panel:child("mid_text"):animate(callback(l_7_0, l_7_0, "_animate_fade_in"))
end

HUDBlackScreen.fade_out_mid_text = function(l_8_0)
  l_8_0._blackscreen_panel:child("mid_text"):animate(callback(l_8_0, l_8_0, "_animate_fade_out"))
end

HUDBlackScreen._animate_fade_in = function(l_9_0, l_9_1)
  local job_panel = l_9_0._blackscreen_panel:child("job_panel")
  local t = 1
  do
    local d = t
    repeat
      if t > 0 then
        local dt = coroutine.yield()
        t = t - dt
        local a = (d - (t)) / d
        l_9_1:set_alpha(a)
        if job_panel then
          job_panel:set_alpha(a)
        end
        l_9_0._blackscreen_panel:set_alpha(a)
      else
        l_9_1:set_alpha(1)
        if job_panel then
          job_panel:set_alpha(1)
        end
        l_9_0._blackscreen_panel:set_alpha(1)
      end
       -- Warning: missing end command somewhere! Added here
    end
     -- Warning: missing end command somewhere! Added here
  end
end

HUDBlackScreen._animate_fade_out = function(l_10_0, l_10_1)
  local job_panel = l_10_0._blackscreen_panel:child("job_panel")
  local t = 1
  do
    local d = t
    repeat
      if t > 0 then
        local dt = coroutine.yield()
        t = t - dt
        local a = (t) / d
        l_10_1:set_alpha(a)
        if job_panel then
          job_panel:set_alpha(a)
        end
        l_10_0._blackscreen_panel:set_alpha(a)
      else
        l_10_1:set_alpha(0)
        if job_panel then
          job_panel:set_alpha(0)
        end
        l_10_0._blackscreen_panel:set_alpha(0)
      end
       -- Warning: missing end command somewhere! Added here
    end
     -- Warning: missing end command somewhere! Added here
  end
end


