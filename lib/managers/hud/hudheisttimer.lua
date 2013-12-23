-- Decompiled using luadec 2.0.1 by sztupy (http://winmo.sztupy.hu)
-- Command line was: F:\SteamLibrary\SteamApps\common\PAYDAY 2\lua\lib\managers\hud\hudheisttimer.luac 

if not HUDHeistTimer then
  HUDHeistTimer = class()
end
HUDHeistTimer.init = function(l_1_0, l_1_1)
  l_1_0._hud_panel = l_1_1.panel
  if l_1_0._hud_panel:child("heist_timer_panel") then
    l_1_0._hud_panel:remove(l_1_0._hud_panel:child("heist_timer_panel"))
  end
  l_1_0._heist_timer_panel = l_1_0._hud_panel:panel({visible = true, name = "heist_timer_panel", h = 40, y = 0, valign = "top", layer = 0})
   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

  l_1_0._timer_text, {name = "timer_text", text = "00:00", font_size = 28, font = tweak_data.hud.medium_font_noshadow}.word_wrap, {name = "timer_text", text = "00:00", font_size = 28, font = tweak_data.hud.medium_font_noshadow}.wrap, {name = "timer_text", text = "00:00", font_size = 28, font = tweak_data.hud.medium_font_noshadow}.layer, {name = "timer_text", text = "00:00", font_size = 28, font = tweak_data.hud.medium_font_noshadow}.vertical, {name = "timer_text", text = "00:00", font_size = 28, font = tweak_data.hud.medium_font_noshadow}.align, {name = "timer_text", text = "00:00", font_size = 28, font = tweak_data.hud.medium_font_noshadow}.color = l_1_0._heist_timer_panel:text({name = "timer_text", text = "00:00", font_size = 28, font = tweak_data.hud.medium_font_noshadow}), false, false, 1, "top", "center", Color.white
  l_1_0._last_time = 0
end

HUDHeistTimer.set_time = function(l_2_0, l_2_1)
  if math.floor(l_2_1) < l_2_0._last_time then
    return 
  end
  l_2_0._last_time = l_2_1
  l_2_1 = math.floor(l_2_1)
  local hours = math.floor(l_2_1 / 3600)
  l_2_1 = l_2_1 - hours * 3600
  local minutes = math.floor((l_2_1) / 60)
  l_2_1 = l_2_1 - minutes * 60
  local seconds = math.round(l_2_1)
  local text = (hours < 10 and (hours <= 0 or hours) .. ":") or (hours <= 0 or hours) .. ":" or ""
  local text = text .. (minutes < 10 and "0" .. minutes or minutes) .. ":" .. (seconds < 10 and "0" .. seconds or seconds)
  l_2_0._timer_text:set_text(text)
end


