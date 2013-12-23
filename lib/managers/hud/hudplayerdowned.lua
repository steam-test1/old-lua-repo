-- Decompiled using luadec 2.0.1 by sztupy (http://winmo.sztupy.hu)
-- Command line was: F:\SteamLibrary\SteamApps\common\PAYDAY 2\lua\lib\managers\hud\hudplayerdowned.luac 

if not HUDPlayerDowned then
  HUDPlayerDowned = class()
end
HUDPlayerDowned.init = function(l_1_0, l_1_1)
  l_1_0._hud = l_1_1
  l_1_0._hud_panel = l_1_1.panel
  if l_1_0._hud_panel:child("downed_panel") then
    l_1_0._hud_panel:remove(l_1_0._hud_panel:child("downed_panel"))
  end
  local downed_panel = l_1_0._hud_panel:panel({name = "downed_panel"})
  local timer_msg = downed_panel:text({name = "timer_msg", text = "BLEH BLEH IN", align = "center", vertical = "center", w = 400, h = 40, font = tweak_data.hud.medium_font_noshadow, font_size = tweak_data.hud_downed.timer_message_size})
  local _, _, w, h = timer_msg:text_rect()
  timer_msg:set_h(h)
  timer_msg:set_x(math.round(l_1_0._hud_panel:center_x() - timer_msg:w() / 2))
  timer_msg:set_y(28)
  l_1_0._hud.timer:set_font(tweak_data.menu.pd2_large_font_id)
  l_1_0._hud.timer:set_font_size(42)
  local _, _, w, h = l_1_0._hud.timer:text_rect()
  l_1_0._hud.timer:set_h(h)
  l_1_0._hud.timer:set_y(math.round(timer_msg:bottom() - 6))
  l_1_0._hud.timer:set_center_x(l_1_0._hud_panel:center_x())
  l_1_0._hud.arrest_finished_text:set_font(Idstring(tweak_data.hud.medium_font_noshadow))
  l_1_0._hud.arrest_finished_text:set_font_size(tweak_data.hud_mask_off.text_size)
  l_1_0:set_arrest_finished_text()
  local _, _, w, h = l_1_0._hud.arrest_finished_text:text_rect()
  l_1_0._hud.arrest_finished_text:set_h(h)
  l_1_0._hud.arrest_finished_text:set_y(28)
  l_1_0._hud.arrest_finished_text:set_center_x(l_1_0._hud_panel:center_x())
end

HUDPlayerDowned.set_arrest_finished_text = function(l_2_0)
  l_2_0._hud.arrest_finished_text:set_text(utf8.to_upper(managers.localization:text("hud_instruct_finish_arrest", {BTN_INTERACT = managers.localization:btn_macro("interact")})))
end

HUDPlayerDowned.on_downed = function(l_3_0)
  local downed_panel = l_3_0._hud_panel:child("downed_panel")
  local timer_msg = downed_panel:child("timer_msg")
  timer_msg:set_text(utf8.to_upper(managers.localization:text("hud_custody_in")))
end

HUDPlayerDowned.on_arrested = function(l_4_0)
  local downed_panel = l_4_0._hud_panel:child("downed_panel")
  local timer_msg = downed_panel:child("timer_msg")
  timer_msg:set_text(utf8.to_upper(managers.localization:text("hud_uncuffed_in")))
end

HUDPlayerDowned.show_timer = function(l_5_0)
  local downed_panel = l_5_0._hud_panel:child("downed_panel")
  local timer_msg = downed_panel:child("timer_msg")
  timer_msg:set_visible(true)
  l_5_0._hud.timer:set_visible(true)
  timer_msg:set_alpha(1)
  l_5_0._hud.timer:set_alpha(1)
end

HUDPlayerDowned.hide_timer = function(l_6_0)
  local downed_panel = l_6_0._hud_panel:child("downed_panel")
  local timer_msg = downed_panel:child("timer_msg")
  timer_msg:set_alpha(0.64999997615814)
  l_6_0._hud.timer:set_alpha(0.64999997615814)
end

HUDPlayerDowned.show_arrest_finished = function(l_7_0)
  l_7_0._hud.arrest_finished_text:set_visible(true)
  local downed_panel = l_7_0._hud_panel:child("downed_panel")
  local timer_msg = downed_panel:child("timer_msg")
  timer_msg:set_visible(false)
  l_7_0._hud.timer:set_visible(false)
end

HUDPlayerDowned.hide_arrest_finished = function(l_8_0)
  l_8_0._hud.arrest_finished_text:set_visible(false)
end


