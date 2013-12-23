-- Decompiled using luadec 2.0.1 by sztupy (http://winmo.sztupy.hu)
-- Command line was: F:\SteamLibrary\SteamApps\common\PAYDAY 2\lua\lib\managers\hud\hudmissionbriefing.luac 

require("lib/managers/menu/MenuBackdropGUI")
if not HUDMissionBriefing then
  HUDMissionBriefing = class()
end
HUDMissionBriefing.init = function(l_1_0, l_1_1, l_1_2)
  l_1_0._backdrop = MenuBackdropGUI:new(l_1_2)
  l_1_0._backdrop:create_black_borders()
  l_1_0._hud = l_1_1
  l_1_0._workspace = l_1_2
  l_1_0._singleplayer = Global.game_settings.single_player
  local bg_font = tweak_data.menu.pd2_massive_font
  local title_font = tweak_data.menu.pd2_large_font
  local content_font = tweak_data.menu.pd2_medium_font
  local text_font = tweak_data.menu.pd2_small_font
  local bg_font_size = tweak_data.menu.pd2_massive_font_size
  local title_font_size = tweak_data.menu.pd2_large_font_size
  local content_font_size = tweak_data.menu.pd2_medium_font_size
  local text_font_size = tweak_data.menu.pd2_small_font_size
  local interupt_stage = managers.job:interupt_stage()
  l_1_0._background_layer_one = l_1_0._backdrop:get_new_background_layer()
  l_1_0._background_layer_two = l_1_0._backdrop:get_new_background_layer()
  l_1_0._background_layer_three = l_1_0._backdrop:get_new_background_layer()
  l_1_0._foreground_layer_one = l_1_0._backdrop:get_new_foreground_layer()
  l_1_0._backdrop:set_panel_to_saferect(l_1_0._background_layer_one)
  l_1_0._backdrop:set_panel_to_saferect(l_1_0._foreground_layer_one)
  l_1_0._ready_slot_panel = l_1_0._foreground_layer_one:panel({name = "player_slot_panel", w = l_1_0._foreground_layer_one:w() / 2, h = text_font_size * 4 + 20})
  l_1_0._ready_slot_panel:set_bottom(l_1_0._foreground_layer_one:h() - 70)
  l_1_0._ready_slot_panel:set_right(l_1_0._foreground_layer_one:w())
  if not l_1_0._singleplayer then
    local voice_icon, voice_texture_rect = tweak_data.hud_icons:get_icon_data("mugshot_talk")
    for i = 1, 4 do
      local color_id = i
      local color = tweak_data.chat_colors[color_id]
      local slot_panel = l_1_0._ready_slot_panel:panel({name = "slot_" .. tostring(i), h = text_font_size, y = (i - 1) * text_font_size + 10, x = 10, w = l_1_0._ready_slot_panel:w() - 20})
      local criminal = slot_panel:text({name = "criminal", font_size = text_font_size, font = text_font, color = color, text = "HOXTON", blend_mode = "add", align = "left", vertical = "center"})
       -- DECOMPILER ERROR: Confused about usage of registers!

       -- DECOMPILER ERROR: Confused about usage of registers!

       -- DECOMPILER ERROR: Confused about usage of registers!

       -- DECOMPILER ERROR: Confused about usage of registers!

       -- DECOMPILER ERROR: Confused about usage of registers!

       -- DECOMPILER ERROR: Confused about usage of registers!

       -- DECOMPILER ERROR: Confused about usage of registers!

      local voice = slot_panel:bitmap({name = "voice", texture = voice_icon})
       -- DECOMPILER ERROR: Confused about usage of registers!

       -- DECOMPILER ERROR: Confused about usage of registers!

       -- DECOMPILER ERROR: Confused about usage of registers!

       -- DECOMPILER ERROR: Confused about usage of registers!

       -- DECOMPILER ERROR: Confused about usage of registers!

      local name = slot_panel:text({name = "name", text = managers.localization:text("menu_lobby_player_slot_available") .. "  ", font = text_font, font_size = text_font_size, color = color:with_alpha(0.5), align = "left"})
       -- DECOMPILER ERROR: Confused about usage of registers!

       -- DECOMPILER ERROR: Confused about usage of registers!

       -- DECOMPILER ERROR: Confused about usage of registers!

       -- DECOMPILER ERROR: Confused about usage of registers!

      local status = slot_panel:text({name = "status", visible = true, text = "  ", font = text_font, font_size = text_font_size, align = "left", vertical = "center", w = 256})
      local _, _, w, _ = criminal:text_rect()
      voice:set_left(w + 2)
      {name = "status", visible = true, text = "  ", font = text_font, font_size = text_font_size, align = "left", vertical = "center", w = 256}.color, {name = "status", visible = true, text = "  ", font = text_font, font_size = text_font_size, align = "left", vertical = "center", w = 256}.blend_mode, {name = "status", visible = true, text = "  ", font = text_font, font_size = text_font_size, align = "left", vertical = "center", w = 256}.layer, {name = "status", visible = true, text = "  ", font = text_font, font_size = text_font_size, align = "left", vertical = "center", w = 256}.h, {name = "name", text = managers.localization:text("menu_lobby_player_slot_available") .. "  ", font = text_font, font_size = text_font_size, color = color:with_alpha(0.5), align = "left"}.blend_mode, {name = "name", text = managers.localization:text("menu_lobby_player_slot_available") .. "  ", font = text_font, font_size = text_font_size, color = color:with_alpha(0.5), align = "left"}.layer, {name = "name", text = managers.localization:text("menu_lobby_player_slot_available") .. "  ", font = text_font, font_size = text_font_size, color = color:with_alpha(0.5), align = "left"}.h, {name = "name", text = managers.localization:text("menu_lobby_player_slot_available") .. "  ", font = text_font, font_size = text_font_size, color = color:with_alpha(0.5), align = "left"}.w, {name = "name", text = managers.localization:text("menu_lobby_player_slot_available") .. "  ", font = text_font, font_size = text_font_size, color = color:with_alpha(0.5), align = "left"}.vertical, {name = "voice", texture = voice_icon}.x, {name = "voice", texture = voice_icon}.color, {name = "voice", texture = voice_icon}.h, {name = "voice", texture = voice_icon}.w, {name = "voice", texture = voice_icon}.texture_rect, {name = "voice", texture = voice_icon}.layer, {name = "voice", texture = voice_icon}.visible = tweak_data.screen_colors.text:with_alpha(0.5), "add", 1, text_font_size, "add", 1, text_font_size, 256, "center", 10, color, voice_texture_rect[4], voice_texture_rect[3], voice_texture_rect, 2, false
      criminal:set_w(w)
      criminal:set_align("right")
      criminal:set_text("")
      name:set_left(voice:right() + 2)
      local x, y, w, h = name:text_rect()
      status:set_left(name:x() + w)
    end
    BoxGuiObject:new(l_1_0._ready_slot_panel, {sides = {1, 1, 1, 1}})
  end
  if not managers.job:has_active_job() then
    return 
  end
  l_1_0._current_contact_data = managers.job:current_contact_data()
  l_1_0._current_level_data = managers.job:current_level_data()
  l_1_0._current_stage_data = managers.job:current_stage_data()
  l_1_0._current_job_data = managers.job:current_job_data()
  l_1_0._job_class = l_1_0._current_job_data and l_1_0._current_job_data.jc or 0
  local contact_gui = l_1_0._background_layer_two:gui(l_1_0._current_contact_data.assets_gui, {})
  if contact_gui:has_script() then
    local contact_pattern = contact_gui:script().pattern
  end
  if contact_pattern then
    l_1_0._backdrop:set_pattern(contact_pattern, 0.10000000149012, "add")
  end
  local padding_y = 70
  l_1_0._paygrade_panel = l_1_0._background_layer_one:panel({h = 70, w = 210, y = padding_y})
   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

  local pg_text = l_1_0._foreground_layer_one:text({name = "pg_text", text = utf8.to_upper(managers.localization:text("cn_menu_contract_paygrade_header")) .. " "})
  local _, _, w, h = pg_text:text_rect()
  pg_text:set_size(w, h)
  {name = "pg_text", text = utf8.to_upper(managers.localization:text("cn_menu_contract_paygrade_header")) .. " "}.color, {name = "pg_text", text = utf8.to_upper(managers.localization:text("cn_menu_contract_paygrade_header")) .. " "}.font, {name = "pg_text", text = utf8.to_upper(managers.localization:text("cn_menu_contract_paygrade_header")) .. " "}.font_size, {name = "pg_text", text = utf8.to_upper(managers.localization:text("cn_menu_contract_paygrade_header")) .. " "}.vertical, {name = "pg_text", text = utf8.to_upper(managers.localization:text("cn_menu_contract_paygrade_header")) .. " "}.align, {name = "pg_text", text = utf8.to_upper(managers.localization:text("cn_menu_contract_paygrade_header")) .. " "}.h, {name = "pg_text", text = utf8.to_upper(managers.localization:text("cn_menu_contract_paygrade_header")) .. " "}.y = tweak_data.screen_colors.text, content_font, content_font_size, "center", "right", 32, padding_y
  local job_stars = managers.job:current_job_stars()
  local job_and_difficulty_stars = managers.job:current_job_and_difficulty_stars()
  local difficulty_stars = job_and_difficulty_stars - job_stars
  local filled_star_rect = {0, 32, 32, 32}
  local empty_star_rect = {32, 32, 32, 32}
  local num_stars = 0
  local x = 0
  local y = 4
  local star_size = 18
  local risk_color = tweak_data.screen_colors.risk
  local level_data = {texture = "guis/textures/pd2/mission_briefing/difficulty_icons", texture_rect = filled_star_rect, w = 16, h = 16, color = tweak_data.screen_colors.text, alpha = 1}
  local risk_data = {texture = "guis/textures/pd2/crimenet_skull", w = 16, h = 16, color = risk_color, alpha = 1}
  for i = 1, job_and_difficulty_stars do
    local is_risk = job_stars < i
    local star_data = is_risk and risk_data or level_data
    local star = l_1_0._paygrade_panel:bitmap(star_data)
    star:set_position(x, y)
    x = x + star_size
    num_stars = num_stars + 1
  end
  l_1_0._paygrade_panel:set_w(10 * star_size)
  l_1_0._paygrade_panel:set_right(l_1_0._background_layer_one:w())
  pg_text:set_right(l_1_0._paygrade_panel:left())
  l_1_0._job_schedule_panel = l_1_0._background_layer_one:panel({h = 70, w = l_1_0._background_layer_one:w() / 2})
  l_1_0._job_schedule_panel:set_right(l_1_0._foreground_layer_one:w())
  l_1_0._job_schedule_panel:set_top(padding_y + content_font_size + 15)
  if interupt_stage then
    l_1_0._job_schedule_panel:set_alpha(0.20000000298023)
    l_1_0._interupt_panel = l_1_0._background_layer_one:panel({h = 125, w = l_1_0._background_layer_one:w() / 2})
     -- DECOMPILER ERROR: Confused about usage of registers!

     -- DECOMPILER ERROR: Confused about usage of registers!

     -- DECOMPILER ERROR: Confused about usage of registers!

     -- DECOMPILER ERROR: Confused about usage of registers!

     -- DECOMPILER ERROR: Confused about usage of registers!

     -- DECOMPILER ERROR: Confused about usage of registers!

     -- DECOMPILER ERROR: Confused about usage of registers!

    local interupt_text = l_1_0._interupt_panel:text({name = "job_text", text = utf8.to_upper(managers.localization:text("menu_escape"))})
    local _, _, w, h = interupt_text:text_rect()
    interupt_text:set_size(w, h)
    {name = "job_text", text = utf8.to_upper(managers.localization:text("menu_escape"))}.layer, {name = "job_text", text = utf8.to_upper(managers.localization:text("menu_escape"))}.color, {name = "job_text", text = utf8.to_upper(managers.localization:text("menu_escape"))}.font, {name = "job_text", text = utf8.to_upper(managers.localization:text("menu_escape"))}.font_size, {name = "job_text", text = utf8.to_upper(managers.localization:text("menu_escape"))}.vertical, {name = "job_text", text = utf8.to_upper(managers.localization:text("menu_escape"))}.align, {name = "job_text", text = utf8.to_upper(managers.localization:text("menu_escape"))}.h = 5, tweak_data.screen_colors.important_1, bg_font, 70, "top", "left", 80
    interupt_text:rotate(-15)
    interupt_text:set_center(l_1_0._interupt_panel:w() / 2, l_1_0._interupt_panel:h() / 2)
    l_1_0._interupt_panel:set_shape(l_1_0._job_schedule_panel:shape())
  end
  local num_stages = l_1_0._current_job_data and #l_1_0._current_job_data.chain or 0
  local day_color = tweak_data.screen_colors.item_stage_1
  local js_w = l_1_0._job_schedule_panel:w() / 7
  local js_h = l_1_0._job_schedule_panel:h()
  for i = 1, 7 do
    local day_font = text_font
    local day_font_size = text_font_size
    day_color = tweak_data.screen_colors.item_stage_1
    if num_stages < i then
      day_color = tweak_data.screen_colors.item_stage_3
    else
      if i == managers.job:current_stage() then
        day_font = content_font
        day_font_size = content_font_size
      end
    end
     -- DECOMPILER ERROR: Confused about usage of registers!

     -- DECOMPILER ERROR: Confused about usage of registers!

     -- DECOMPILER ERROR: Confused about usage of registers!

     -- DECOMPILER ERROR: Confused about usage of registers!

     -- DECOMPILER ERROR: Confused about usage of registers!

     -- DECOMPILER ERROR: Confused about usage of registers!

    local day_text = l_1_0._job_schedule_panel:text({name = "day_" .. tostring(i), text = utf8.to_upper(managers.localization:text("menu_day_short", {day = tostring(i)})), align = "center", vertical = "center"})
    if i ~= 1 or not 0 then
      day_text:set_left(l_1_0._job_schedule_panel:child("day_" .. tostring(i - 1)):right())
      {name = "day_" .. tostring(i), text = utf8.to_upper(managers.localization:text("menu_day_short", {day = tostring(i)})), align = "center", vertical = "center"}.blend_mode, {name = "day_" .. tostring(i), text = utf8.to_upper(managers.localization:text("menu_day_short", {day = tostring(i)})), align = "center", vertical = "center"}.color, {name = "day_" .. tostring(i), text = utf8.to_upper(managers.localization:text("menu_day_short", {day = tostring(i)})), align = "center", vertical = "center"}.h, {name = "day_" .. tostring(i), text = utf8.to_upper(managers.localization:text("menu_day_short", {day = tostring(i)})), align = "center", vertical = "center"}.w, {name = "day_" .. tostring(i), text = utf8.to_upper(managers.localization:text("menu_day_short", {day = tostring(i)})), align = "center", vertical = "center"}.font, {name = "day_" .. tostring(i), text = utf8.to_upper(managers.localization:text("menu_day_short", {day = tostring(i)})), align = "center", vertical = "center"}.font_size = "add", day_color, js_h, js_w, day_font, day_font_size
    end
  end
  for i = 1, managers.job:current_stage() or 0 do
    local stage_marker = l_1_0._job_schedule_panel:bitmap({name = "stage_done_" .. tostring(i), texture = "guis/textures/pd2/mission_briefing/calendar_xo", texture_rect = {i == managers.job:current_stage() and 80 or 0, 0, 80, 64}, w = 80, h = 64, layer = 1, rotation = math.rand(-10, 10)})
    stage_marker:set_center(l_1_0._job_schedule_panel:child("day_" .. tostring(i)):center())
    stage_marker:move(math.random(4) - 2, math.random(4) - 2)
  end
  if managers.job:has_active_job() then
    local payday_stamp = l_1_0._job_schedule_panel:bitmap({name = "payday_stamp", texture = "guis/textures/pd2/mission_briefing/calendar_xo", texture_rect = {160, 0, 96, 64}, w = 96, h = 64, layer = 2, rotation = math.rand(-5, 5)})
    payday_stamp:set_center(l_1_0._job_schedule_panel:child("day_" .. tostring(num_stages)):center())
    payday_stamp:move(math.random(4) - 2 - 7, math.random(4) - 2 + 8)
    if payday_stamp:rotation() == 0 then
      payday_stamp:set_rotation(1)
    end
  end
  local job_overview_text = l_1_0._foreground_layer_one:text({name = "job_overview_text", text = utf8.to_upper(managers.localization:text("menu_job_overview")), h = content_font_size, align = "left", vertical = "bottom", font_size = content_font_size, font = content_font, color = tweak_data.screen_colors.text})
  local _, _, w, h = job_overview_text:text_rect()
  job_overview_text:set_size(w, h)
  job_overview_text:set_leftbottom(l_1_0._job_schedule_panel:left(), pg_text:bottom())
  if pg_text:left() <= job_overview_text:right() + 15 then
    pg_text:move(0, -pg_text:h())
    l_1_0._paygrade_panel:move(0, -pg_text:h())
  end
  local job_text = l_1_0._foreground_layer_one:text({name = "job_text", text = utf8.to_upper(managers.localization:text(l_1_0._current_contact_data.name_id) .. ": " .. managers.localization:text(l_1_0._current_job_data.name_id)), align = "left", vertical = "center", font_size = title_font_size, font = title_font, color = tweak_data.screen_colors.text})
  local _, _, w, h = job_text:text_rect()
  job_text:set_size(w, h)
  local big_text = l_1_0._background_layer_three:text({name = "job_text", text = utf8.to_upper(managers.localization:text(l_1_0._current_job_data.name_id)), align = "left", vertical = "top", font_size = bg_font_size, font = bg_font, color = tweak_data.screen_colors.button_stage_1, alpha = 0.40000000596046})
  local _, _, w, h = big_text:text_rect()
  big_text:set_size(w, h)
  big_text:set_world_center_y(l_1_0._foreground_layer_one:child("job_text"):world_center_y())
  big_text:set_world_x(l_1_0._foreground_layer_one:child("job_text"):world_x())
  big_text:move(-13, 9)
  l_1_0._backdrop:animate_bg_text(big_text)
end

HUDMissionBriefing.hide = function(l_2_0)
  l_2_0._backdrop:hide()
  if alive(l_2_0._background_layer_two) then
    l_2_0._background_layer_two:clear()
  end
end

HUDMissionBriefing.set_player_slot = function(l_3_0, l_3_1, l_3_2)
  print("set_player_slot( nr, params )", l_3_1, l_3_2)
  local slot = l_3_0._ready_slot_panel:child("slot_" .. tostring(l_3_1))
  if not slot or not alive(slot) then
    return 
  end
  slot:child("status"):stop()
  slot:child("status"):set_alpha(1)
  slot:child("status"):set_color(slot:child("status"):color():with_alpha(1))
  slot:child("status"):set_font_size(tweak_data.menu.pd2_small_font_size)
  slot:child("name"):set_color(slot:child("name"):color():with_alpha(1))
  slot:child("name"):set_text(l_3_2.name)
  slot:child("criminal"):set_color(slot:child("criminal"):color():with_alpha(1))
  if not CriminalsManager.convert_old_to_new_character_workname(l_3_2.character) then
    slot:child("criminal"):set_text(utf8.to_upper(l_3_2.character))
  end
  local name_len = utf8.len(slot:child("name"):text())
  slot:child("name"):set_text(slot:child("name"):text() .. " (" .. tostring(l_3_2.level) .. ")  ")
  if l_3_2.status then
    slot:child("status"):set_text(l_3_2.status)
  end
  local x, y, w, h = slot:child("name"):text_rect()
  slot:child("status"):set_left(slot:child("name"):x() + w)
end

HUDMissionBriefing.set_slot_joining = function(l_4_0, l_4_1, l_4_2)
  print("set_slot_joining( peer, peer_id )", l_4_1, l_4_2)
  local slot = l_4_0._ready_slot_panel:child("slot_" .. tostring(l_4_2))
  if not slot or not alive(slot) then
    return 
  end
  slot:child("status"):stop()
  slot:child("status"):set_alpha(1)
  slot:child("status"):set_color(slot:child("status"):color():with_alpha(1))
  slot:child("criminal"):set_color(slot:child("criminal"):color():with_alpha(1))
  if not CriminalsManager.convert_old_to_new_character_workname(l_4_1:character()) then
    slot:child("criminal"):set_text(utf8.to_upper(l_4_1:character()))
  end
  slot:child("name"):set_text(l_4_1:name() .. "  ")
  slot:child("status"):set_visible(true)
  slot:child("status"):set_text(managers.localization:text("menu_waiting_is_joining"))
  local x, y, w, h = slot:child("name"):text_rect()
  slot:child("status"):set_left(slot:child("name"):x() + w)
  slot:child("status"):set_font_size(tweak_data.menu.pd2_small_font_size)
  local animate_joining = function(l_1_0)
    do
      local t = 0
      repeat
        t = (t + coroutine.yield()) % 1
        l_1_0:set_alpha(0.30000001192093 + 0.69999998807907 * math.sin(t * 180))
        do return end
      end
       -- Warning: missing end command somewhere! Added here
    end
   end
  slot:child("status"):animate(animate_joining)
end

HUDMissionBriefing.set_slot_ready = function(l_5_0, l_5_1, l_5_2)
  print("set_slot_ready( peer, peer_id )", l_5_1, l_5_2)
  local slot = l_5_0._ready_slot_panel:child("slot_" .. tostring(l_5_2))
  if not slot or not alive(slot) then
    return 
  end
  slot:child("status"):stop()
  slot:child("status"):set_blend_mode("add")
  slot:child("status"):set_visible(true)
  slot:child("status"):set_alpha(1)
  slot:child("status"):set_color(slot:child("status"):color():with_alpha(1))
  slot:child("status"):set_text(managers.localization:text("menu_waiting_is_ready"))
  local x, y, w, h = slot:child("name"):text_rect()
  slot:child("status"):set_left(slot:child("name"):x() + w)
  slot:child("status"):set_font_size(tweak_data.menu.pd2_small_font_size)
  managers.menu_component:flash_ready_mission_briefing_gui()
end

HUDMissionBriefing.set_slot_not_ready = function(l_6_0, l_6_1, l_6_2)
  print("set_slot_not_ready( peer, peer_id )", l_6_1, l_6_2)
  local slot = l_6_0._ready_slot_panel:child("slot_" .. tostring(l_6_2))
  if not slot or not alive(slot) then
    return 
  end
  slot:child("status"):stop()
  slot:child("status"):set_visible(true)
  slot:child("status"):set_alpha(1)
  slot:child("status"):set_color(slot:child("status"):color():with_alpha(1))
  slot:child("status"):set_text(managers.localization:text("menu_waiting_is_not_ready"))
  local x, y, w, h = slot:child("name"):text_rect()
  slot:child("status"):set_left(slot:child("name"):x() + w)
  slot:child("status"):set_font_size(tweak_data.menu.pd2_small_font_size)
end

HUDMissionBriefing.set_dropin_progress = function(l_7_0, l_7_1, l_7_2)
  print("set_dropin_progress( peer_id, progress_percentage )", l_7_1, l_7_2)
  local slot = l_7_0._ready_slot_panel:child("slot_" .. tostring(l_7_1))
  if not slot or not alive(slot) then
    return 
  end
  slot:child("status"):stop()
  slot:child("status"):set_visible(true)
  slot:child("status"):set_alpha(1)
  slot:child("status"):set_text(managers.localization:text("menu_waiting_is_joining") .. " " .. tostring(l_7_2) .. "%")
  local x, y, w, h = slot:child("name"):text_rect()
  slot:child("status"):set_left(slot:child("name"):x() + w)
  slot:child("status"):set_font_size(tweak_data.menu.pd2_small_font_size)
end

HUDMissionBriefing.set_kit_selection = function(l_8_0, l_8_1, l_8_2, l_8_3, l_8_4)
  print("set_kit_selection( peer_id, category, id, slot )", l_8_1, l_8_2, l_8_3, l_8_4)
end

HUDMissionBriefing.set_slot_voice = function(l_9_0, l_9_1, l_9_2, l_9_3)
  print("set_slot_voice( peer, peer_id, active )", l_9_1, l_9_2, l_9_3)
  local slot = l_9_0._ready_slot_panel:child("slot_" .. tostring(l_9_2))
  if not slot or not alive(slot) then
    return 
  end
  slot:child("voice"):set_visible(l_9_3)
end

HUDMissionBriefing.remove_player_slot_by_peer_id = function(l_10_0, l_10_1, l_10_2)
  print("remove_player_slot_by_peer_id( peer, reason )", l_10_1, l_10_2)
  local slot = l_10_0._ready_slot_panel:child("slot_" .. tostring(l_10_1:id()))
  if not slot or not alive(slot) then
    return 
  end
  slot:child("status"):stop()
  slot:child("status"):set_alpha(1)
  slot:child("criminal"):set_text("")
  slot:child("name"):set_text(utf8.to_upper(managers.localization:text("menu_lobby_player_slot_available")))
  slot:child("status"):set_text("")
  slot:child("status"):set_visible(false)
  slot:child("voice"):set_visible(false)
  local x, y, w, h = slot:child("name"):text_rect()
  slot:child("status"):set_left(slot:child("name"):x() + w)
  slot:child("status"):set_font_size(tweak_data.menu.pd2_small_font_size)
end

HUDMissionBriefing.update_layout = function(l_11_0)
  l_11_0._backdrop:_set_black_borders()
end

HUDMissionBriefing.reload = function(l_12_0)
  l_12_0._backdrop:close()
  l_12_0._backdrop = nil
  HUDMissionBriefing.init(l_12_0, l_12_0._hud, l_12_0._workspace)
end


