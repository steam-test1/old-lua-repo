-- Decompiled using luadec 2.0.1 by sztupy (http://winmo.sztupy.hu)
-- Command line was: F:\SteamLibrary\SteamApps\common\PAYDAY 2\lua\lib\managers\hud\hudteammate.luac 

if not HUDTeammate then
  HUDTeammate = class()
end
HUDTeammate.init = function(l_1_0, l_1_1, l_1_2, l_1_3, l_1_4)
  l_1_0._id = l_1_1
  local small_gap = 8
  local gap = 0
  local pad = 4
  local main_player = l_1_1 == HUDManager.PLAYER_PANEL
  l_1_0._main_player = main_player
  local names = {"WWWWWWWWWWWWQWWW", "AI Teammate", "FutureCatCar", "WWWWWWWWWWWWQWWW"}
  local teammate_panel = l_1_2:panel({visible = false, name = "" .. l_1_1, w = math.round(l_1_4), x = 0})
  if not main_player then
    teammate_panel:set_h(84)
    teammate_panel:set_bottom(l_1_2:h())
  end
  l_1_0._player_panel = teammate_panel:panel({name = "player"})
  local name = teammate_panel:text({name = "name", text = " " .. utf8.to_upper(names[l_1_1]), layer = 1, color = Color.white, y = 0, vertical = "bottom", font_size = tweak_data.hud_players.name_size, font = tweak_data.hud_players.name_font})
  local _, _, name_w, _ = name:text_rect()
  managers.hud:make_fine_text(name)
  name:set_leftbottom(name:h(), teammate_panel:h() - 70)
  if not main_player then
    name:set_x(48 + name:h() + 4)
    name:set_bottom(teammate_panel:h() - 30)
  end
  local tabs_texture = "guis/textures/pd2/hud_tabs"
  local bg_rect = {84, 0, 44, 32}
  local cs_rect = {84, 34, 19, 19}
  local csbg_rect = {105, 34, 19, 19}
  local bg_color = Color.white / 3
   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

  teammate_panel:bitmap({name = "name_bg", texture = tabs_texture, texture_rect = bg_rect, visible = true})
  {name = "name_bg", texture = tabs_texture, texture_rect = bg_rect, visible = true}.h, {name = "name_bg", texture = tabs_texture, texture_rect = bg_rect, visible = true}.w, {name = "name_bg", texture = tabs_texture, texture_rect = bg_rect, visible = true}.y, {name = "name_bg", texture = tabs_texture, texture_rect = bg_rect, visible = true}.x, {name = "name_bg", texture = tabs_texture, texture_rect = bg_rect, visible = true}.color, {name = "name_bg", texture = tabs_texture, texture_rect = bg_rect, visible = true}.layer = name:h(), name_w + 4, name:y() - 1, name:x(), bg_color, 0
   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

  teammate_panel:bitmap({name = "callsign_bg", texture = tabs_texture, texture_rect = csbg_rect, layer = 0})
  {name = "callsign_bg", texture = tabs_texture, texture_rect = csbg_rect, layer = 0}.h, {name = "callsign_bg", texture = tabs_texture, texture_rect = csbg_rect, layer = 0}.w, {name = "callsign_bg", texture = tabs_texture, texture_rect = csbg_rect, layer = 0}.y, {name = "callsign_bg", texture = tabs_texture, texture_rect = csbg_rect, layer = 0}.x, {name = "callsign_bg", texture = tabs_texture, texture_rect = csbg_rect, layer = 0}.blend_mode, {name = "callsign_bg", texture = tabs_texture, texture_rect = csbg_rect, layer = 0}.color = name:h() - 2, name:h() - 2, name:y() + 1, name:x() - name:h(), "normal", bg_color
   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

  teammate_panel:bitmap({name = "callsign", texture = tabs_texture, texture_rect = cs_rect, layer = 1})
  {name = "callsign", texture = tabs_texture, texture_rect = cs_rect, layer = 1}.h, {name = "callsign", texture = tabs_texture, texture_rect = cs_rect, layer = 1}.w, {name = "callsign", texture = tabs_texture, texture_rect = cs_rect, layer = 1}.y, {name = "callsign", texture = tabs_texture, texture_rect = cs_rect, layer = 1}.x, {name = "callsign", texture = tabs_texture, texture_rect = cs_rect, layer = 1}.blend_mode, {name = "callsign", texture = tabs_texture, texture_rect = cs_rect, layer = 1}.color = name:h() - 2, name:h() - 2, name:y() + 1, name:x() - name:h(), "normal", tweak_data.chat_colors[l_1_1]:with_alpha(1)
  local box_ai_bg = teammate_panel:bitmap({visible = false, name = "box_ai_bg", texture = "guis/textures/pd2/box_ai_bg", color = Color.white, alpha = 0, y = 0, w = teammate_panel:w()})
  box_ai_bg:set_bottom(name:top())
  local box_bg = teammate_panel:bitmap({visible = false, name = "box_bg", texture = "guis/textures/pd2/box_bg", color = Color.white, y = 0, w = teammate_panel:w()})
  box_bg:set_bottom(name:top())
  local texture, rect = tweak_data.hud_icons:get_icon_data("pd2_mask_" .. l_1_1)
  local size = 64
  local mask_pad = 2
  local mask_pad_x = 3
  local y = teammate_panel:h() - name:h() - size + mask_pad
   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

  local mask = teammate_panel:bitmap({visible = false, name = "mask", layer = 1, color = Color.white})
  {visible = false, name = "mask", layer = 1, color = Color.white}.y, {visible = false, name = "mask", layer = 1, color = Color.white}.h, {visible = false, name = "mask", layer = 1, color = Color.white}.w, {visible = false, name = "mask", layer = 1, color = Color.white}.x, {visible = false, name = "mask", layer = 1, color = Color.white}.texture_rect, {visible = false, name = "mask", layer = 1, color = Color.white}.texture = y, size, size, -mask_pad_x, rect, texture
  local radial_size = main_player and 64 or 48
  local radial_health_panel = l_1_0._player_panel:panel({name = "radial_health_panel", layer = 1, w = radial_size + 4, h = radial_size + 4, x = 0, y = mask:y()})
  radial_health_panel:set_bottom(l_1_0._player_panel:h())
  local radial_bg = radial_health_panel:bitmap({name = "radial_bg", texture = "guis/textures/pd2/hud_radialbg", alpha = 1, w = radial_health_panel:w(), h = radial_health_panel:h(), layer = 0})
   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

  local radial_health = radial_health_panel:bitmap({name = "radial_health", texture = "guis/textures/pd2/hud_health"})
  radial_health:set_color(Color(1, 1, 0, 0))
  {name = "radial_health", texture = "guis/textures/pd2/hud_health"}.layer, {name = "radial_health", texture = "guis/textures/pd2/hud_health"}.h, {name = "radial_health", texture = "guis/textures/pd2/hud_health"}.w, {name = "radial_health", texture = "guis/textures/pd2/hud_health"}.alpha, {name = "radial_health", texture = "guis/textures/pd2/hud_health"}.blend_mode, {name = "radial_health", texture = "guis/textures/pd2/hud_health"}.render_template, {name = "radial_health", texture = "guis/textures/pd2/hud_health"}.texture_rect = 2, radial_health_panel:h(), radial_health_panel:w(), 1, "add", "VertexColorTexturedRadial", {64, 0, -64, 64}
   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

  local radial_shield = radial_health_panel:bitmap({name = "radial_shield", texture = "guis/textures/pd2/hud_shield"})
  radial_shield:set_color(Color(1, 1, 0, 0))
  {name = "radial_shield", texture = "guis/textures/pd2/hud_shield"}.layer, {name = "radial_shield", texture = "guis/textures/pd2/hud_shield"}.h, {name = "radial_shield", texture = "guis/textures/pd2/hud_shield"}.w, {name = "radial_shield", texture = "guis/textures/pd2/hud_shield"}.alpha, {name = "radial_shield", texture = "guis/textures/pd2/hud_shield"}.blend_mode, {name = "radial_shield", texture = "guis/textures/pd2/hud_shield"}.render_template, {name = "radial_shield", texture = "guis/textures/pd2/hud_shield"}.texture_rect = 1, radial_health_panel:h(), radial_health_panel:w(), 1, "add", "VertexColorTexturedRadial", {64, 0, -64, 64}
  local damage_indicator = radial_health_panel:bitmap({name = "damage_indicator", texture = "guis/textures/pd2/hud_radial_rim", blend_mode = "add", alpha = 0, w = radial_health_panel:w(), h = radial_health_panel:h(), layer = 1})
  damage_indicator:set_color(Color(1, 1, 1, 1))
  local x, y, w, h = radial_health_panel:shape()
  teammate_panel:bitmap({name = "condition_icon", layer = 4, visible = false, color = Color.white, x = x, y = y, w = w, h = h})
   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

  local condition_timer = teammate_panel:text({name = "condition_timer", visible = false, text = "000", layer = 5})
  condition_timer:set_shape(radial_health_panel:shape())
  {name = "condition_timer", visible = false, text = "000", layer = 5}.font, {name = "condition_timer", visible = false, text = "000", layer = 5}.font_size, {name = "condition_timer", visible = false, text = "000", layer = 5}.vertical, {name = "condition_timer", visible = false, text = "000", layer = 5}.align, {name = "condition_timer", visible = false, text = "000", layer = 5}.y, {name = "condition_timer", visible = false, text = "000", layer = 5}.color = tweak_data.hud_players.timer_font, tweak_data.hud_players.timer_size, "center", "center", 0, Color.white
  local w_selection_w = 13
  local weapon_panel_w = 80
  local extra_clip_w = 4
  local ammo_text_w = (weapon_panel_w - w_selection_w) / 2
  local font_bottom_align_correction = 3
  local tabs_texture = "guis/textures/pd2/hud_tabs"
  local bg_rect = {0, 0, 67, 32}
  local weapon_selection_rect1 = {67, 0, 13, 32}
  local weapon_selection_rect2 = {67, 32, 13, 32}
  local weapons_panel = l_1_0._player_panel:panel({name = "weapons_panel", visible = true, layer = 0, w = weapon_panel_w, h = radial_health_panel:h(), x = radial_health_panel:right() + 4, y = radial_health_panel:y()})
  local primary_weapon_panel = weapons_panel:panel({name = "primary_weapon_panel", visible = false, layer = 1, w = weapon_panel_w, h = 32, x = 0, y = 0})
  primary_weapon_panel:bitmap({name = "bg", texture = tabs_texture, texture_rect = bg_rect, visible = true, layer = 0, color = bg_color, w = weapon_panel_w, x = 0})
   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

  primary_weapon_panel:text({name = "ammo_clip", visible = not main_player or true, text = "0" .. math.random(40), color = Color.white, blend_mode = "normal", layer = 1, w = ammo_text_w + extra_clip_w, h = primary_weapon_panel:h(), x = 0, y = 0 + font_bottom_align_correction, vertical = "bottom", align = "center"})
  {name = "ammo_clip", visible = not main_player or true, text = "0" .. math.random(40), color = Color.white, blend_mode = "normal", layer = 1, w = ammo_text_w + extra_clip_w, h = primary_weapon_panel:h(), x = 0, y = 0 + font_bottom_align_correction, vertical = "bottom", align = "center"}.font, {name = "ammo_clip", visible = not main_player or true, text = "0" .. math.random(40), color = Color.white, blend_mode = "normal", layer = 1, w = ammo_text_w + extra_clip_w, h = primary_weapon_panel:h(), x = 0, y = 0 + font_bottom_align_correction, vertical = "bottom", align = "center"}.font_size = tweak_data.hud_players.ammo_font, 32
   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

  primary_weapon_panel:text({name = "ammo_total", visible = true, text = "000", color = Color.white, blend_mode = "normal", layer = 1, w = ammo_text_w - extra_clip_w, h = primary_weapon_panel:h(), x = ammo_text_w + extra_clip_w, y = 0 + font_bottom_align_correction, vertical = "bottom", align = "center"})
  {name = "ammo_total", visible = true, text = "000", color = Color.white, blend_mode = "normal", layer = 1, w = ammo_text_w - extra_clip_w, h = primary_weapon_panel:h(), x = ammo_text_w + extra_clip_w, y = 0 + font_bottom_align_correction, vertical = "bottom", align = "center"}.font, {name = "ammo_total", visible = true, text = "000", color = Color.white, blend_mode = "normal", layer = 1, w = ammo_text_w - extra_clip_w, h = primary_weapon_panel:h(), x = ammo_text_w + extra_clip_w, y = 0 + font_bottom_align_correction, vertical = "bottom", align = "center"}.font_size = tweak_data.hud_players.ammo_font, 24
  primary_weapon_panel:bitmap({name = "weapon_selection", texture = tabs_texture, texture_rect = weapon_selection_rect1, visible = not main_player or true, layer = 1, color = Color.white, w = w_selection_w, x = weapon_panel_w - w_selection_w})
  if not main_player then
    local ammo_total = primary_weapon_panel:child("ammo_total")
    local _x, _y, _w, _h = ammo_total:text_rect()
    primary_weapon_panel:set_size(_w + 8, _h)
    ammo_total:set_shape(0, 0, primary_weapon_panel:size())
    ammo_total:move(0, font_bottom_align_correction)
    primary_weapon_panel:set_x(0)
    primary_weapon_panel:set_bottom(weapons_panel:h())
    local eq_rect = {84, 0, 44, 32}
    primary_weapon_panel:child("bg"):set_image(tabs_texture, eq_rect[1], eq_rect[2], eq_rect[3], eq_rect[4])
    primary_weapon_panel:child("bg"):set_size(primary_weapon_panel:size())
  end
  local secondary_weapon_panel = weapons_panel:panel({name = "secondary_weapon_panel", visible = false, layer = 1, w = weapon_panel_w, h = 32, x = 0, y = primary_weapon_panel:bottom()})
  secondary_weapon_panel:bitmap({name = "bg", texture = tabs_texture, texture_rect = bg_rect, visible = true, layer = 0, color = bg_color, w = weapon_panel_w, x = 0})
   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

  secondary_weapon_panel:text({name = "ammo_clip", visible = not main_player or true, text = "" .. math.random(40), color = Color.white, blend_mode = "normal", layer = 1, w = ammo_text_w + extra_clip_w, h = secondary_weapon_panel:h(), x = 0, y = 0 + font_bottom_align_correction, vertical = "bottom", align = "center"})
  {name = "ammo_clip", visible = not main_player or true, text = "" .. math.random(40), color = Color.white, blend_mode = "normal", layer = 1, w = ammo_text_w + extra_clip_w, h = secondary_weapon_panel:h(), x = 0, y = 0 + font_bottom_align_correction, vertical = "bottom", align = "center"}.font, {name = "ammo_clip", visible = not main_player or true, text = "" .. math.random(40), color = Color.white, blend_mode = "normal", layer = 1, w = ammo_text_w + extra_clip_w, h = secondary_weapon_panel:h(), x = 0, y = 0 + font_bottom_align_correction, vertical = "bottom", align = "center"}.font_size = tweak_data.hud_players.ammo_font, 32
   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

  secondary_weapon_panel:text({name = "ammo_total", visible = true, text = "000", color = Color.white, blend_mode = "normal", layer = 1, w = ammo_text_w - extra_clip_w, h = secondary_weapon_panel:h(), x = ammo_text_w + extra_clip_w, y = 0 + font_bottom_align_correction, vertical = "bottom", align = "center"})
  {name = "ammo_total", visible = true, text = "000", color = Color.white, blend_mode = "normal", layer = 1, w = ammo_text_w - extra_clip_w, h = secondary_weapon_panel:h(), x = ammo_text_w + extra_clip_w, y = 0 + font_bottom_align_correction, vertical = "bottom", align = "center"}.font, {name = "ammo_total", visible = true, text = "000", color = Color.white, blend_mode = "normal", layer = 1, w = ammo_text_w - extra_clip_w, h = secondary_weapon_panel:h(), x = ammo_text_w + extra_clip_w, y = 0 + font_bottom_align_correction, vertical = "bottom", align = "center"}.font_size = tweak_data.hud_players.ammo_font, 24
  secondary_weapon_panel:bitmap({name = "weapon_selection", texture = tabs_texture, texture_rect = weapon_selection_rect2, visible = not main_player or true, layer = 1, color = Color.white, w = w_selection_w, x = weapon_panel_w - w_selection_w})
  secondary_weapon_panel:set_bottom(weapons_panel:h())
  if not main_player then
    local ammo_total = secondary_weapon_panel:child("ammo_total")
    local _x, _y, _w, _h = ammo_total:text_rect()
    secondary_weapon_panel:set_size(_w + 8, _h)
    ammo_total:set_shape(0, 0, secondary_weapon_panel:size())
    ammo_total:move(0, font_bottom_align_correction)
    secondary_weapon_panel:set_x(primary_weapon_panel:right())
    secondary_weapon_panel:set_bottom(weapons_panel:h())
    local eq_rect = {84, 0, 44, 32}
    secondary_weapon_panel:child("bg"):set_image(tabs_texture, eq_rect[1], eq_rect[2], eq_rect[3], eq_rect[4])
    secondary_weapon_panel:child("bg"):set_size(secondary_weapon_panel:size())
  end
  local eq_rect = {84, 0, 44, 32}
  local temp_scale = 1
  local deployable_equipment_panel = l_1_0._player_panel:panel({name = "deployable_equipment_panel", layer = 1, w = 48, h = 32, x = weapons_panel:right() + 4, y = weapons_panel:y()})
  deployable_equipment_panel:bitmap({name = "bg", texture = tabs_texture, texture_rect = eq_rect, visible = true, layer = 0, color = bg_color, w = deployable_equipment_panel:w(), x = 0})
  local equipment = deployable_equipment_panel:bitmap({name = "equipment", visible = false, layer = 1, color = Color.white, w = deployable_equipment_panel:h() * temp_scale, h = deployable_equipment_panel:h() * temp_scale, x = -(deployable_equipment_panel:h() * temp_scale - deployable_equipment_panel:h()) / 2, y = -(deployable_equipment_panel:h() * temp_scale - deployable_equipment_panel:h()) / 2})
   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

  local amount = deployable_equipment_panel:text({name = "amount", visible = false, text = tostring(12), font = "fonts/font_medium_mf", font_size = 22, color = Color.white, align = "right", vertical = "center", layer = 2, x = -2})
  {name = "amount", visible = false, text = tostring(12), font = "fonts/font_medium_mf", font_size = 22, color = Color.white, align = "right", vertical = "center", layer = 2, x = -2}.h, {name = "amount", visible = false, text = tostring(12), font = "fonts/font_medium_mf", font_size = 22, color = Color.white, align = "right", vertical = "center", layer = 2, x = -2}.w, {name = "amount", visible = false, text = tostring(12), font = "fonts/font_medium_mf", font_size = 22, color = Color.white, align = "right", vertical = "center", layer = 2, x = -2}.y = deployable_equipment_panel:h(), deployable_equipment_panel:w(), 2
  if not main_player then
    local scale = 0.75
    deployable_equipment_panel:set_size(deployable_equipment_panel:w() * 0.89999997615814, deployable_equipment_panel:h() * scale)
    equipment:set_size(equipment:w() * scale, equipment:h() * scale)
    equipment:set_center_y(deployable_equipment_panel:h() / 2)
    equipment:set_x(equipment:x() + 4)
    amount:set_center_y(deployable_equipment_panel:h() / 2)
    amount:set_right(deployable_equipment_panel:w() - 4)
    deployable_equipment_panel:set_x(weapons_panel:right() - 8)
    deployable_equipment_panel:set_bottom(weapons_panel:bottom())
    local bg = deployable_equipment_panel:child("bg")
    bg:set_size(deployable_equipment_panel:size())
  end
  local texture, rect = tweak_data.hud_icons:get_icon_data(tweak_data.equipments.specials.cable_tie.icon)
  local cable_ties_panel = l_1_0._player_panel:panel({name = "cable_ties_panel", visible = true, layer = 1, w = 48, h = 32, x = weapons_panel:right() + 4, y = weapons_panel:y()})
  cable_ties_panel:bitmap({name = "bg", texture = tabs_texture, texture_rect = eq_rect, visible = true, layer = 0, color = bg_color, w = deployable_equipment_panel:w(), x = 0})
   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

  local cable_ties = cable_ties_panel:bitmap({name = "cable_ties", visible = false, texture = texture, texture_rect = rect})
   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

  local amount = cable_ties_panel:text({name = "amount", visible = false, text = tostring(12), font = "fonts/font_medium_mf", font_size = 22, color = Color.white, align = "right", vertical = "center", layer = 2, x = -2})
  cable_ties_panel:set_bottom(weapons_panel:bottom())
  {name = "amount", visible = false, text = tostring(12), font = "fonts/font_medium_mf", font_size = 22, color = Color.white, align = "right", vertical = "center", layer = 2, x = -2}.h, {name = "amount", visible = false, text = tostring(12), font = "fonts/font_medium_mf", font_size = 22, color = Color.white, align = "right", vertical = "center", layer = 2, x = -2}.w, {name = "amount", visible = false, text = tostring(12), font = "fonts/font_medium_mf", font_size = 22, color = Color.white, align = "right", vertical = "center", layer = 2, x = -2}.y, {name = "cable_ties", visible = false, texture = texture, texture_rect = rect}.y, {name = "cable_ties", visible = false, texture = texture, texture_rect = rect}.x, {name = "cable_ties", visible = false, texture = texture, texture_rect = rect}.h, {name = "cable_ties", visible = false, texture = texture, texture_rect = rect}.w, {name = "cable_ties", visible = false, texture = texture, texture_rect = rect}.color, {name = "cable_ties", visible = false, texture = texture, texture_rect = rect}.layer = deployable_equipment_panel:h(), deployable_equipment_panel:w(), 2, -(deployable_equipment_panel:h() * temp_scale - deployable_equipment_panel:h()) / 2, -(deployable_equipment_panel:h() * temp_scale - deployable_equipment_panel:h()) / 2, deployable_equipment_panel:h() * temp_scale, deployable_equipment_panel:h() * temp_scale, Color.white, 1
  if not main_player then
    local scale = 0.75
    cable_ties_panel:set_size(cable_ties_panel:w() * 0.89999997615814, cable_ties_panel:h() * scale)
    cable_ties:set_size(cable_ties:w() * scale, cable_ties:h() * scale)
    cable_ties:set_center_y(cable_ties_panel:h() / 2)
    cable_ties:set_x(cable_ties:x() + 4)
    amount:set_center_y(cable_ties_panel:h() / 2)
    amount:set_right(cable_ties_panel:w() - 4)
    cable_ties_panel:set_x(deployable_equipment_panel:right())
    cable_ties_panel:set_bottom(deployable_equipment_panel:bottom())
    local bg = cable_ties_panel:child("bg")
    bg:set_size(cable_ties_panel:size())
  end
  local bag_rect = {32, 33, 32, 31}
  local bg_rect = {84, 0, 44, 32}
  local bag_w = bag_rect[3]
  local bag_h = bag_rect[4]
  local carry_panel = l_1_0._player_panel:panel({name = "carry_panel", visible = false, layer = 1, w = bag_w, h = bag_h + 2, x = 0, y = radial_health_panel:top() - bag_h})
  carry_panel:set_x(24 - bag_w / 2)
  carry_panel:set_center_x(radial_health_panel:center_x())
   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

  carry_panel:bitmap({name = "bg", texture = tabs_texture, texture_rect = bg_rect, visible = false})
  {name = "bg", texture = tabs_texture, texture_rect = bg_rect, visible = false}.h, {name = "bg", texture = tabs_texture, texture_rect = bg_rect, visible = false}.w, {name = "bg", texture = tabs_texture, texture_rect = bg_rect, visible = false}.y, {name = "bg", texture = tabs_texture, texture_rect = bg_rect, visible = false}.x, {name = "bg", texture = tabs_texture, texture_rect = bg_rect, visible = false}.color, {name = "bg", texture = tabs_texture, texture_rect = bg_rect, visible = false}.layer = carry_panel:h(), 100, 0, 0, bg_color, 0
   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

  carry_panel:bitmap({name = "bag", texture = tabs_texture, w = bag_w, h = bag_h})
  {name = "bag", texture = tabs_texture, w = bag_w, h = bag_h}.y, {name = "bag", texture = tabs_texture, w = bag_w, h = bag_h}.x, {name = "bag", texture = tabs_texture, w = bag_w, h = bag_h}.color, {name = "bag", texture = tabs_texture, w = bag_w, h = bag_h}.layer, {name = "bag", texture = tabs_texture, w = bag_w, h = bag_h}.visible, {name = "bag", texture = tabs_texture, w = bag_w, h = bag_h}.texture_rect = 1, 1, Color.white, 0, true, bag_rect
   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

  carry_panel:text({name = "value", visible = false, text = "", layer = 0})
  {name = "value", visible = false, text = "", layer = 0}.font, {name = "value", visible = false, text = "", layer = 0}.font_size, {name = "value", visible = false, text = "", layer = 0}.vertical, {name = "value", visible = false, text = "", layer = 0}.y, {name = "value", visible = false, text = "", layer = 0}.x, {name = "value", visible = false, text = "", layer = 0}.color = "fonts/font_small_mf", tweak_data.hud.small_font_size, "center", 0, bag_rect[3] + 4, Color.white
  local interact_panel = l_1_0._player_panel:panel({name = "interact_panel", visible = false, layer = 3})
  interact_panel:set_shape(weapons_panel:shape())
  interact_panel:set_shape(radial_health_panel:shape())
  interact_panel:set_size(radial_size * 1.25, radial_size * 1.25)
  interact_panel:set_center(radial_health_panel:center())
  local radius = interact_panel:h() / 2 - 4
  l_1_0._interact = CircleBitmapGuiObject:new(interact_panel, {use_bg = true, rotation = 360, radius = radius, blend_mode = "add", color = Color.white, layer = 0})
  l_1_0._interact:set_position(4, 4)
  l_1_0._special_equipment = {}
  l_1_0._panel = teammate_panel
end

HUDTeammate._rec_round_object = function(l_2_0, l_2_1)
  if l_2_1.children then
    for i,d in ipairs(l_2_1:children()) do
      l_2_0:_rec_round_object(d)
    end
  end
  local x, y = l_2_1:position()
  l_2_1:set_position(math.round(x), math.round(y))
end

HUDTeammate.panel = function(l_3_0)
  return l_3_0._panel
end

HUDTeammate.add_panel = function(l_4_0)
  local teammate_panel = l_4_0._panel
  teammate_panel:set_visible(true)
end

HUDTeammate.remove_panel = function(l_5_0)
  local teammate_panel = l_5_0._panel
  teammate_panel:set_visible(false)
  local special_equipment = l_5_0._special_equipment
  repeat
    if special_equipment[1] then
      teammate_panel:remove(table.remove(special_equipment))
    else
      l_5_0:set_condition("mugshot_normal")
      l_5_0._player_panel:child("weapons_panel"):child("secondary_weapon_panel"):set_visible(false)
      l_5_0._player_panel:child("weapons_panel"):child("primary_weapon_panel"):set_visible(false)
      local deployable_equipment_panel = l_5_0._player_panel:child("deployable_equipment_panel")
      deployable_equipment_panel:child("equipment"):set_visible(false)
      deployable_equipment_panel:child("amount"):set_visible(false)
      do
        local cable_ties_panel = l_5_0._player_panel:child("cable_ties_panel")
        cable_ties_panel:child("cable_ties"):set_visible(false)
        cable_ties_panel:child("amount"):set_visible(false)
        l_5_0._player_panel:child("carry_panel"):set_visible(false)
        l_5_0._player_panel:child("carry_panel"):child("value"):set_text("")
        l_5_0:stop_timer()
        l_5_0:teammate_progress(false, false, false, false)
        l_5_0._peer_id = nil
        l_5_0._ai = nil
      end
       -- Warning: missing end command somewhere! Added here
    end
     -- Warning: missing end command somewhere! Added here
  end
end

HUDTeammate.set_peer_id = function(l_6_0, l_6_1)
  l_6_0._peer_id = l_6_1
end

HUDTeammate.set_ai = function(l_7_0, l_7_1)
  l_7_0._ai = l_7_1
end

HUDTeammate._set_weapon_selected = function(l_8_0, l_8_1, l_8_2)
  local is_secondary = l_8_1 == 1
  local secondary_weapon_panel = l_8_0._player_panel:child("weapons_panel"):child("secondary_weapon_panel")
  local primary_weapon_panel = l_8_0._player_panel:child("weapons_panel"):child("primary_weapon_panel")
  primary_weapon_panel:set_alpha(is_secondary and 0.5 or 1)
  secondary_weapon_panel:set_alpha(is_secondary and 1 or 0.5)
end

HUDTeammate.set_weapon_selected = function(l_9_0, l_9_1, l_9_2)
  l_9_0:_set_weapon_selected(l_9_1, l_9_2)
end

HUDTeammate.set_ammo_amount_by_type = function(l_10_0, l_10_1, l_10_2, l_10_3, l_10_4, l_10_5)
  local weapon_panel = l_10_0._player_panel:child("weapons_panel"):child(l_10_1 .. "_weapon_panel")
  weapon_panel:set_visible(true)
  local low_ammo = l_10_4 <= math.round(l_10_2 / 2)
  local low_ammo_clip = l_10_3 <= math.round(l_10_2 / 4)
  local out_of_ammo_clip = l_10_3 <= 0
  local out_of_ammo = l_10_4 <= 0
  if out_of_ammo then
    local color_total = Color(1, 0.89999997615814, 0.30000001192093, 0.30000001192093)
  end
  if not color_total and low_ammo then
    color_total = Color(1, 0.89999997615814, 0.89999997615814, 0.30000001192093)
  end
  if not color_total then
    color_total = Color.white
  end
  if out_of_ammo_clip then
    local color_clip = Color(1, 0.89999997615814, 0.30000001192093, 0.30000001192093)
  end
  if not color_clip and low_ammo_clip then
    color_clip = Color(1, 0.89999997615814, 0.89999997615814, 0.30000001192093)
  end
  if not color_clip then
    color_clip = Color.white
  end
  local ammo_clip = weapon_panel:child("ammo_clip")
  local zero = (l_10_3 < 10 and "00") or (l_10_3 < 100 and "0") or ""
  ammo_clip:set_text(zero .. tostring(l_10_3))
  ammo_clip:set_color(color_clip)
  ammo_clip:set_range_color(0, string.len(zero), color_clip:with_alpha(0.5))
  local ammo_total = weapon_panel:child("ammo_total")
  local zero = (l_10_4 < 10 and "00") or (l_10_4 < 100 and "0") or ""
  ammo_total:set_text(zero .. tostring(l_10_4))
  ammo_total:set_color(color_total)
  ammo_total:set_range_color(0, string.len(zero), color_total:with_alpha(0.5))
end

HUDTeammate.set_health = function(l_11_0, l_11_1)
  local teammate_panel = l_11_0._panel:child("player")
  local radial_health_panel = teammate_panel:child("radial_health_panel")
  local radial_health = radial_health_panel:child("radial_health")
  local red = l_11_1.current / l_11_1.total
  if red < radial_health:color().red then
    l_11_0:_damage_taken()
  end
  radial_health:set_color(Color(1, red, 1, 1))
end

HUDTeammate.set_armor = function(l_12_0, l_12_1)
  local teammate_panel = l_12_0._panel:child("player")
  local radial_health_panel = teammate_panel:child("radial_health_panel")
  local radial_shield = radial_health_panel:child("radial_shield")
  local red = l_12_1.current / l_12_1.total
  if red < radial_shield:color().red then
    l_12_0:_damage_taken()
  end
  radial_shield:set_color(Color(1, red, 1, 1))
end

HUDTeammate._damage_taken = function(l_13_0)
  local teammate_panel = l_13_0._panel:child("player")
  local radial_health_panel = teammate_panel:child("radial_health_panel")
  local damage_indicator = radial_health_panel:child("damage_indicator")
  damage_indicator:stop()
  damage_indicator:animate(callback(l_13_0, l_13_0, "_animate_damage_taken"))
end

HUDTeammate._animate_damage_taken = function(l_14_0, l_14_1)
  l_14_1:set_alpha(1)
  local st = 3
  local t = st
  local st_red_t = 0.5
  do
    local red_t = st_red_t
    repeat
      if t > 0 then
        local dt = coroutine.yield()
        t = t - dt
        red_t = math.clamp(red_t - dt, 0, 1)
        l_14_1:set_color(Color(1, red_t / st_red_t, red_t / st_red_t))
        l_14_1:set_alpha((t) / st)
      else
        l_14_1:set_alpha(0)
      end
       -- Warning: missing end command somewhere! Added here
    end
     -- Warning: missing end command somewhere! Added here
  end
end

HUDTeammate.set_name = function(l_15_0, l_15_1)
  local teammate_panel = l_15_0._panel
  local name = teammate_panel:child("name")
  local name_bg = teammate_panel:child("name_bg")
  local callsign = teammate_panel:child("callsign")
  name:set_text(utf8.to_upper(" " .. l_15_1))
  local h = name:h()
  managers.hud:make_fine_text(name)
  name:set_h(h)
  name_bg:set_w(name:w() + 4)
end

HUDTeammate.set_callsign = function(l_16_0, l_16_1)
  local teammate_panel = l_16_0._panel
  print("id", l_16_1)
  Application:stack_dump()
  local callsign = teammate_panel:child("callsign")
  local alpha = callsign:color().a
  callsign:set_color(tweak_data.chat_colors[l_16_1]:with_alpha(alpha))
end

HUDTeammate.set_cable_tie = function(l_17_0, l_17_1)
  local teammate_panel = l_17_0._panel:child("player")
  local icon, texture_rect = tweak_data.hud_icons:get_icon_data(l_17_1.icon)
  local cable_ties_panel = l_17_0._player_panel:child("cable_ties_panel")
  local cable_ties2 = cable_ties_panel:child("cable_ties")
  cable_ties2:set_image(icon, unpack(texture_rect))
  cable_ties2:set_visible(true)
  l_17_0:set_cable_ties_amount(l_17_1.amount)
  return nil
end

HUDTeammate.set_cable_ties_amount = function(l_18_0, l_18_1)
  local visible = l_18_1 ~= 0
  local cable_ties_panel = l_18_0._player_panel:child("cable_ties_panel")
  local cable_ties_amount = cable_ties_panel:child("amount")
  cable_ties_amount:set_visible(visible)
  if l_18_1 ~= -1 or not "--" then
    cable_ties_amount:set_text(tostring(l_18_1))
  end
  local cable_ties = cable_ties_panel:child("cable_ties")
  cable_ties:set_visible(visible)
end

HUDTeammate.set_state = function(l_19_0, l_19_1)
  local teammate_panel = l_19_0._panel
  local is_player = l_19_1 == "player"
  teammate_panel:child("player"):set_alpha(is_player and 1 or 0)
  local name = teammate_panel:child("name")
  local name_bg = teammate_panel:child("name_bg")
  local callsign_bg = teammate_panel:child("callsign_bg")
  local callsign = teammate_panel:child("callsign")
  if not l_19_0._main_player then
    if is_player then
      name:set_x(48 + name:h() + 4)
      name:set_bottom(teammate_panel:h() - 30)
    else
      name:set_x(48 + name:h() + 4)
      name:set_bottom(teammate_panel:h())
    end
    name_bg:set_position(name:x(), name:y() - 1)
    callsign_bg:set_position(name:x() - name:h(), name:y() + 1)
    callsign:set_position(name:x() - name:h(), name:y() + 1)
  end
end

HUDTeammate.set_perk_equipment = function(l_20_0, l_20_1)
end

HUDTeammate.set_deployable_equipment = function(l_21_0, l_21_1)
  local icon, texture_rect = tweak_data.hud_icons:get_icon_data(l_21_1.icon)
  local deployable_equipment_panel = l_21_0._player_panel:child("deployable_equipment_panel")
  local equipment = deployable_equipment_panel:child("equipment")
  equipment:set_visible(true)
  equipment:set_image(icon, unpack(texture_rect))
  l_21_0:set_deployable_equipment_amount(1, l_21_1)
end

HUDTeammate.set_deployable_equipment_amount = function(l_22_0, l_22_1, l_22_2)
  local teammate_panel = l_22_0._panel:child("player")
  local deployable_equipment_panel = l_22_0._player_panel:child("deployable_equipment_panel")
  local amount = deployable_equipment_panel:child("amount")
  deployable_equipment_panel:child("equipment"):set_visible(l_22_2.amount ~= 0)
  amount:set_text(tostring(l_22_2.amount))
  amount:set_visible(l_22_2.amount ~= 0)
end

HUDTeammate.set_carry_info = function(l_23_0, l_23_1, l_23_2)
  local carry_panel = l_23_0._player_panel:child("carry_panel")
  carry_panel:set_visible(true)
  local value_text = carry_panel:child("value")
  value_text:set_text(managers.experience:cash_string(l_23_2))
  local _, _, w, _ = value_text:text_rect()
  local bg = carry_panel:child("bg")
  bg:set_w(carry_panel:child("bag"):w() + w + 4)
end

HUDTeammate.remove_carry_info = function(l_24_0)
  local carry_panel = l_24_0._player_panel:child("carry_panel")
  carry_panel:set_visible(false)
end

HUDTeammate.add_special_equipment = function(l_25_0, l_25_1)
  local teammate_panel = l_25_0._panel
  local special_equipment = l_25_0._special_equipment
  local id = l_25_1.id
  local equipment_panel = teammate_panel:panel({name = id, layer = 0, y = 0})
  local icon, texture_rect = tweak_data.hud_icons:get_icon_data(l_25_1.icon)
  equipment_panel:set_size(32, 32)
  local bitmap = (equipment_panel:bitmap({name = "bitmap", texture = icon, color = Color.white, layer = 1, texture_rect = texture_rect, w = equipment_panel:w(), h = equipment_panel:w()}))
  local amount, amount_bg = nil, nil
   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

  if l_25_1.amount then
    if not equipment_panel:child("amount") then
      amount, {name = "amount", text = tostring(l_25_1.amount), font = "fonts/font_small_noshadow_mf", font_size = 12}.h, {name = "amount", text = tostring(l_25_1.amount), font = "fonts/font_small_noshadow_mf", font_size = 12}.w, {name = "amount", text = tostring(l_25_1.amount), font = "fonts/font_small_noshadow_mf", font_size = 12}.layer, {name = "amount", text = tostring(l_25_1.amount), font = "fonts/font_small_noshadow_mf", font_size = 12}.vertical, {name = "amount", text = tostring(l_25_1.amount), font = "fonts/font_small_noshadow_mf", font_size = 12}.align, {name = "amount", text = tostring(l_25_1.amount), font = "fonts/font_small_noshadow_mf", font_size = 12}.color = equipment_panel:text({name = "amount", text = tostring(l_25_1.amount), font = "fonts/font_small_noshadow_mf", font_size = 12}), equipment_panel:h(), equipment_panel:w(), 4, "center", "center", Color.black
    end
    amount:set_visible(l_25_1.amount > 1)
    if not equipment_panel:child("amount_bg") then
      amount_bg = equipment_panel:bitmap({name = "amount_bg", texture = "guis/textures/pd2/equip_count", color = Color.white, layer = 3})
    end
    amount_bg:set_visible(l_25_1.amount > 1)
  end
  local flash_icon = equipment_panel:bitmap({name = "bitmap", texture = icon, color = tweak_data.hud.prime_color, layer = 2, texture_rect = texture_rect, w = equipment_panel:w() + 2, h = equipment_panel:w() + 2})
  table.insert(special_equipment, equipment_panel)
  local w = teammate_panel:w()
  equipment_panel:set_x(w - (equipment_panel:w() + 0) * #special_equipment)
  if amount then
    amount_bg:set_center(bitmap:center())
    amount_bg:move(7, 7)
    amount:set_center(amount_bg:center())
  end
  local hud = managers.hud:script(PlayerBase.PLAYER_INFO_HUD_PD2)
  flash_icon:set_center(bitmap:center())
  flash_icon:animate(hud.flash_icon, nil, equipment_panel)
  l_25_0:layout_special_equipments()
end

HUDTeammate.remove_special_equipment = function(l_26_0, l_26_1)
  local teammate_panel = l_26_0._panel
  local special_equipment = l_26_0._special_equipment
  for i,panel in ipairs(special_equipment) do
    if panel:name() == l_26_1 then
      local data = table.remove(special_equipment, i)
      teammate_panel:remove(panel)
      l_26_0:layout_special_equipments()
      return 
    end
  end
end

HUDTeammate.set_special_equipment_amount = function(l_27_0, l_27_1, l_27_2)
  local teammate_panel = l_27_0._panel
  local special_equipment = l_27_0._special_equipment
  for i,panel in ipairs(special_equipment) do
    if panel:name() == l_27_1 then
      panel:child("amount"):set_text(tostring(l_27_2))
      panel:child("amount"):set_visible(l_27_2 > 1)
      panel:child("amount_bg"):set_visible(l_27_2 > 1)
      return 
    end
  end
end

HUDTeammate.clear_special_equipment = function(l_28_0)
  l_28_0:remove_panel()
  l_28_0:add_panel()
end

HUDTeammate.layout_special_equipments = function(l_29_0)
  local teammate_panel = l_29_0._panel
  local special_equipment = l_29_0._special_equipment
  local name = teammate_panel:child("name")
  do
    local w = teammate_panel:w()
    for i,panel in ipairs(special_equipment) do
      if l_29_0._main_player then
        panel:set_x(w - (panel:w() + 0) * i)
        panel:set_y(0)
        for (for control),i in (for generator) do
        end
        panel:set_x(48 + panel:w() * (i - 1))
        panel:set_y(0)
      end
    end
     -- Warning: missing end command somewhere! Added here
  end
end

HUDTeammate.set_condition = function(l_30_0, l_30_1, l_30_2)
  local condition_icon = l_30_0._panel:child("condition_icon")
  if l_30_1 == "mugshot_normal" then
    condition_icon:set_visible(false)
  else
    condition_icon:set_visible(true)
    local icon, texture_rect = tweak_data.hud_icons:get_icon_data(l_30_1)
    condition_icon:set_image(icon, texture_rect[1], texture_rect[2], texture_rect[3], texture_rect[4])
  end
end

HUDTeammate.teammate_progress = function(l_31_0, l_31_1, l_31_2, l_31_3, l_31_4)
  l_31_0._player_panel:child("radial_health_panel"):set_alpha(l_31_1 and 0.20000000298023 or 1)
  l_31_0._player_panel:child("interact_panel"):stop()
  l_31_0._player_panel:child("interact_panel"):set_visible(l_31_1)
  if l_31_1 then
    l_31_0._player_panel:child("interact_panel"):animate(callback(HUDManager, HUDManager, "_animate_label_interact"), l_31_0._interact, l_31_3)
  elseif l_31_4 then
    local panel = l_31_0._player_panel
    local bitmap = panel:bitmap({rotation = 360, texture = "guis/textures/pd2/hud_progress_active", blend_mode = "add", align = "center", valign = "center", layer = 2})
    bitmap:set_size(l_31_0._interact:size())
    bitmap:set_position(l_31_0._player_panel:child("interact_panel"):x() + 4, l_31_0._player_panel:child("interact_panel"):y() + 4)
    local radius = l_31_0._interact:radius()
    local circle = CircleBitmapGuiObject:new(panel, {rotation = 360, radius = radius, color = Color.white:with_alpha(1), blend_mode = "normal", layer = 3})
    circle:set_position(bitmap:position())
    bitmap:animate(callback(HUDInteraction, HUDInteraction, "_animate_interaction_complete"), circle)
  end
end

HUDTeammate.start_timer = function(l_32_0, l_32_1)
  l_32_0._timer_paused = 0
  l_32_0._timer = l_32_1
  l_32_0._panel:child("condition_timer"):set_font_size(tweak_data.hud_players.timer_size)
  l_32_0._panel:child("condition_timer"):set_color(Color.white)
  l_32_0._panel:child("condition_timer"):stop()
  l_32_0._panel:child("condition_timer"):set_visible(true)
  l_32_0._panel:child("condition_timer"):animate(callback(l_32_0, l_32_0, "_animate_timer"))
end

HUDTeammate.set_pause_timer = function(l_33_0, l_33_1)
  if not l_33_0._timer_paused then
    return 
  end
  l_33_0._timer_paused = l_33_0._timer_paused + (l_33_1 and 1 or -1)
end

HUDTeammate.stop_timer = function(l_34_0)
  if not alive(l_34_0._panel) then
    return 
  end
  l_34_0._panel:child("condition_timer"):set_visible(false)
  l_34_0._panel:child("condition_timer"):stop()
end

HUDTeammate.is_timer_running = function(l_35_0)
  return l_35_0._panel:child("condition_timer"):visible()
end

HUDTeammate._animate_timer = function(l_36_0)
  local rounded_timer = math.round(l_36_0._timer)
  repeat
    repeat
      repeat
        repeat
          if l_36_0._timer >= 0 then
            local dt = coroutine.yield()
          until l_36_0._timer_paused == 0
          l_36_0._timer = l_36_0._timer - dt
           -- DECOMPILER ERROR: Confused while interpreting a jump as a 'while'

        end
        local text = (l_36_0._timer < 0 and "00" or "") .. math.round(l_36_0._timer)
        l_36_0._panel:child("condition_timer"):set_text(text)
      until math.round(l_36_0._timer) < rounded_timer
      rounded_timer = math.round(l_36_0._timer)
    until rounded_timer < 11
    l_36_0._panel:child("condition_timer"):animate(callback(l_36_0, l_36_0, "_animate_timer_flash"))
  else
     -- Warning: missing end command somewhere! Added here
  end
end

HUDTeammate._animate_timer_flash = function(l_37_0)
  local t = 0
  local condition_timer = l_37_0._panel:child("condition_timer")
  repeat
    if t < 0.5 then
      t = t + coroutine.yield()
      local n = 1 - math.sin((t) * 180)
       -- DECOMPILER ERROR: Confused while interpreting a jump as a 'while'

    end
    local r = math.lerp(l_37_0._point_of_no_return_color.r, 1, n)
     -- DECOMPILER ERROR: Confused while interpreting a jump as a 'while'

  end
  local g = math.lerp(l_37_0._point_of_no_return_color.g, 0.80000001192093, n)
   -- DECOMPILER ERROR: Confused while interpreting a jump as a 'while'

end
local b = math.lerp(l_37_0._point_of_no_return_color.b, 0.20000000298023, n)
condition_timer:set_color(Color(r, g, b))
condition_timer:set_font_size(math.lerp(tweak_data.hud_players.timer_size, tweak_data.hud_players.timer_flash_size, n))
else
condition_timer:set_font_size(30)
end


