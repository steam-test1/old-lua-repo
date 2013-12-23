-- Decompiled using luadec 2.0.1 by sztupy (http://winmo.sztupy.hu)
-- Command line was: F:\SteamLibrary\SteamApps\common\PAYDAY 2\lua\lib\managers\hud\hudplayercustody.luac 

if not HUDPlayerCustody then
  HUDPlayerCustody = class()
end
HUDPlayerCustody.init = function(l_1_0, l_1_1)
  l_1_0._hud = l_1_1
  l_1_0._hud_panel = l_1_1.panel
  if l_1_0._hud_panel:child("custody_panel") then
    l_1_0._hud_panel:remove(l_1_0._hud_panel:child("custody_panel"))
  end
  local custody_panel = l_1_0._hud_panel:panel({name = "custody_panel", halign = "grow", valign = "grow"})
  local timer_msg = custody_panel:text({name = "timer_msg", text = "something IN", align = "center", vertical = "center", w = 400, h = 40, font = tweak_data.hud_custody.custody_font, font_size = tweak_data.hud_downed.timer_message_size})
  timer_msg:set_text(utf8.to_upper(managers.localization:text("hud_respawning_in")))
  local _, _, w, h = timer_msg:text_rect()
  timer_msg:set_h(h)
  timer_msg:set_x(math.round(l_1_0._hud_panel:center_x() - timer_msg:w() / 2))
  timer_msg:set_y(28)
  local timer = custody_panel:text({name = "timer", text = "00:00", align = "center", vertical = "bottom", w = 400, h = 32, font = tweak_data.hud_custody.custody_font_large, font_size = 42})
  local _, _, w, h = timer:text_rect()
  timer:set_h(h)
  timer:set_y(math.round(timer_msg:bottom() - 6))
  timer:set_center_x(l_1_0._hud_panel:center_x())
  l_1_0._timer = timer
  l_1_0._last_time = -1
  l_1_0._last_trade_delay_time = -1
   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

  local civilians_killed = custody_panel:text({name = "civilians_killed", text = "Civilians killed"})
   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

  local trade_delay = custody_panel:text({name = "trade_delay", text = "Trade delay"})
  if not l_1_0._hud_panel:child("text_title") then
    l_1_0._hud_panel:script().text_title, {name = "trade_delay", text = "Trade delay"}.font_size, {name = "trade_delay", text = "Trade delay"}.font, {name = "trade_delay", text = "Trade delay"}.h, {name = "trade_delay", text = "Trade delay"}.w, {name = "trade_delay", text = "Trade delay"}.valign, {name = "trade_delay", text = "Trade delay"}.vertical, {name = "trade_delay", text = "Trade delay"}.align, {name = "civilians_killed", text = "Civilians killed"}.font_size, {name = "civilians_killed", text = "Civilians killed"}.font, {name = "civilians_killed", text = "Civilians killed"}.h, {name = "civilians_killed", text = "Civilians killed"}.w, {name = "civilians_killed", text = "Civilians killed"}.valign, {name = "civilians_killed", text = "Civilians killed"}.vertical, {name = "civilians_killed", text = "Civilians killed"}.align = l_1_0._hud_panel:text({name = "text_title", color = Color.white, font_size = 28, font = "fonts/font_medium_shadow_mf", text = "", align = "right", vertical = "top", h = "32"}), tweak_data.hud_custody.small_font_size, tweak_data.hud_custody.custody_font, 32, 400, "bottom", "top", "right", tweak_data.hud_custody.small_font_size, tweak_data.hud_custody.custody_font, 32, 400, "bottom", "top", "right"
  end
  if not l_1_0._hud_panel:child("text_next_player") then
    l_1_0._hud_panel:script().text_next_player = l_1_0._hud_panel:text({name = "text_next_player", color = Color.white, font_size = 28, font = "fonts/font_medium_shadow_mf", text = "", align = "right", vertical = "top", h = "32"})
  end
  local text_next_player = l_1_0._hud.text_next_player
  text_next_player:set_font(Idstring(tweak_data.hud_custody.custody_font))
  text_next_player:set_font_size(tweak_data.hud.next_player_font_size)
  local primary_attack, secondary_attack = l_1_0:_next_player_text()
  local next_player = managers.localization:text("menu_spectator_next_player", {BTN_PRIMARY = primary_attack, BTN_SECONDARY = secondary_attack})
  text_next_player:set_text(utf8.to_upper(next_player))
  local _, _, w, h = text_next_player:text_rect()
  text_next_player:set_h(h)
  text_next_player:set_right(text_next_player:parent():w())
  text_next_player:set_top(68)
  local text_title = l_1_0._hud.text_title
  text_title:set_visible(true)
  text_title:set_text(utf8.to_upper(managers.localization:text("menu_spectator_spactating")))
  local _, _, w, h = text_title:text_rect()
  text_title:set_h(h)
  text_title:set_font(Idstring(tweak_data.hud_custody.custody_font))
  text_title:set_font_size(tweak_data.hud.next_player_font_size)
  text_title:set_rightbottom(text_next_player:righttop())
  text_title:set_bottom(text_title:bottom() + 4)
  local trade_text1 = l_1_0._hud.trade_text1
  trade_text1:set_font(Idstring(tweak_data.hud_custody.custody_font))
  trade_text1:set_font_size(tweak_data.hud_custody.font_size)
  trade_text1:set_visible(true)
  trade_text1:set_align("right")
  trade_text1:set_valign("bottom")
  trade_text1:set_text(utf8.to_upper(managers.localization:text("menu_spectator_being_traded")))
  local _, _, w, h = trade_text1:text_rect()
  trade_text1:set_h(h)
  trade_text1:set_y(l_1_0._hud_panel:h() - 152 - 80)
  local trade_text2 = l_1_0._hud.trade_text2
  trade_text2:set_font(Idstring(tweak_data.hud_custody.custody_font))
  trade_text2:set_font_size(tweak_data.hud_custody.font_size)
  trade_text2:set_visible(true)
  trade_text2:set_align("right")
  trade_text2:set_valign("bottom")
  trade_text2:set_text(utf8.to_upper(managers.localization:text("menu_spectator_being_traded_hesitant")))
  local _, _, w, h = trade_text2:text_rect()
  trade_text2:set_h(h)
  trade_text2:set_y(trade_text1:y())
  local _, _, w, h = civilians_killed:text_rect()
  civilians_killed:set_h(h)
  civilians_killed:set_right(civilians_killed:parent():w())
  civilians_killed:set_y(trade_text1:bottom())
  local _, _, w, h = trade_delay:text_rect()
  trade_delay:set_h(h)
  trade_delay:set_right(trade_delay:parent():w())
  trade_delay:set_y(civilians_killed:bottom())
end

HUDPlayerCustody._next_player_text = function(l_2_0)
  if not managers.menu:is_pc_controller() then
    return nil, nil
  end
  local type = managers.controller:get_default_wrapper_type()
  local primary_attack = "[" .. managers.controller:get_settings(type):get_connection("primary_attack"):get_input_name_list()[1] .. "]"
  local secondary_attack = "[" .. managers.controller:get_settings(type):get_connection("secondary_attack"):get_input_name_list()[1] .. "]"
  return primary_attack, secondary_attack
end

HUDPlayerCustody.set_timer_visibility = function(l_3_0, l_3_1)
  l_3_0._timer:set_visible(l_3_1)
  l_3_0._hud_panel:child("custody_panel"):child("timer_msg"):set_visible(l_3_1)
end

HUDPlayerCustody.set_respawn_time = function(l_4_0, l_4_1)
  if math.floor(l_4_1) == math.floor(l_4_0._last_time) then
    return 
  end
  l_4_0._last_time = l_4_1
  local time_text = l_4_0:_get_time_text(l_4_1)
  l_4_0._timer:set_text(utf8.to_upper(tostring(time_text)))
end

HUDPlayerCustody.set_civilians_killed = function(l_5_0, l_5_1)
  local amount_text = (l_5_1 < 10 and "0" or "") .. l_5_1
  local civilians_killed = l_5_0._hud_panel:child("custody_panel"):child("civilians_killed")
  civilians_killed:set_text(utf8.to_upper(managers.localization:text("hud_civilians_killed", {AMOUNT = tostring(amount_text)})))
end

HUDPlayerCustody.set_trade_delay = function(l_6_0, l_6_1)
  if math.floor(l_6_1) == math.floor(l_6_0._last_trade_delay_time) then
    return 
  end
  l_6_0._last_trade_delay_time = l_6_1
  local time_text = l_6_0:_get_time_text(l_6_1)
  local trade_delay = l_6_0._hud_panel:child("custody_panel"):child("trade_delay")
  trade_delay:set_text(utf8.to_upper(managers.localization:text("hud_trade_delay", {TIME = tostring(time_text)})))
end

HUDPlayerCustody.set_trade_delay_visible = function(l_7_0, l_7_1)
  l_7_0._hud_panel:child("custody_panel"):child("trade_delay"):set_visible(l_7_1)
  l_7_0._hud_panel:child("custody_panel"):child("civilians_killed"):set_visible(l_7_1)
end

HUDPlayerCustody.set_negotiating_visible = function(l_8_0, l_8_1)
  l_8_0._hud.trade_text2:set_visible(l_8_1)
  l_8_0._hud.trade_text2:stop()
  if l_8_1 then
    l_8_0._hud.trade_text2:animate(callback(l_8_0, l_8_0, "_animate_text_pulse"))
  end
end

HUDPlayerCustody.set_can_be_trade_visible = function(l_9_0, l_9_1)
  l_9_0._hud.trade_text1:set_visible(l_9_1)
  l_9_0._hud.trade_text1:stop()
  if l_9_1 then
    l_9_0._hud.trade_text1:animate(callback(l_9_0, l_9_0, "_animate_text_pulse"))
  end
end

HUDPlayerCustody._get_time_text = function(l_10_0, l_10_1)
  l_10_1 = math.max(math.floor(l_10_1), 0)
  local minutes = math.floor(l_10_1 / 60)
  l_10_1 = l_10_1 - minutes * 60
  local seconds = math.round(l_10_1)
  local text = ""
  return text .. (minutes < 10 and "0" .. minutes or minutes) .. ":" .. (seconds < 10 and "0" .. seconds or seconds)
end

HUDPlayerCustody._animate_text_pulse = function(l_11_0, l_11_1)
  do
    local t = 0
    repeat
      local dt = coroutine.yield()
      t = t + dt
      do
        local alpha = 0.5 + math.abs(math.sin((t) * 360 * 0.5)) / 2
        l_11_1:set_alpha(alpha)
      end
      do return end
    end
     -- Warning: missing end command somewhere! Added here
  end
end


