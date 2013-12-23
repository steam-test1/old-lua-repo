-- Decompiled using luadec 2.0.1 by sztupy (http://winmo.sztupy.hu)
-- Command line was: F:\SteamLibrary\SteamApps\common\PAYDAY 2\lua\lib\managers\hud\hudhint.luac 

if not HUDHint then
  HUDHint = class()
end
HUDHint.init = function(l_1_0, l_1_1)
  l_1_0._hud_panel = l_1_1.panel
  if l_1_0._hud_panel:child("hint_panel") then
    l_1_0._hud_panel:remove(l_1_0._hud_panel:child("hint_panel"))
  end
  l_1_0._hint_panel = l_1_0._hud_panel:panel({visible = false, name = "hint_panel", h = 30, y = 0, valign = {0.3125, 0}, layer = 3})
  local y = l_1_0._hud_panel:h() / 3.2000000476837
  l_1_0._hint_panel:set_center_y(y)
  local marker = l_1_0._hint_panel:rect({name = "marker", visible = true, color = Color.white:with_alpha(0.75), layer = 2, h = 30, w = 12})
  marker:set_center_y(l_1_0._hint_panel:h() / 2)
  local clip_panel = l_1_0._hint_panel:panel({name = "clip_panel"})
  clip_panel:rect({name = "bg", visible = true, color = Color.black:with_alpha(0.25)})
   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

  clip_panel:text({name = "hint_text", text = "", font_size = 28, font = tweak_data.hud.medium_font_noshadow})
  {name = "hint_text", text = "", font_size = 28, font = tweak_data.hud.medium_font_noshadow}.word_wrap, {name = "hint_text", text = "", font_size = 28, font = tweak_data.hud.medium_font_noshadow}.wrap, {name = "hint_text", text = "", font_size = 28, font = tweak_data.hud.medium_font_noshadow}.layer, {name = "hint_text", text = "", font_size = 28, font = tweak_data.hud.medium_font_noshadow}.vertical, {name = "hint_text", text = "", font_size = 28, font = tweak_data.hud.medium_font_noshadow}.align, {name = "hint_text", text = "", font_size = 28, font = tweak_data.hud.medium_font_noshadow}.color = false, false, 1, "center", "center", Color.white
end

HUDHint.show = function(l_2_0, l_2_1)
  local text = l_2_1.text
  local clip_panel = l_2_0._hint_panel:child("clip_panel")
  clip_panel:child("hint_text"):set_text(utf8.to_upper(""))
  l_2_0._stop = false
  l_2_0._hint_panel:stop()
  l_2_0._hint_panel:animate(callback(l_2_0, l_2_0, "_animate_show"), callback(l_2_0, l_2_0, "show_done"), l_2_1.time or 3, utf8.to_upper(text))
end

HUDHint.stop = function(l_3_0)
  l_3_0._stop = true
end

HUDHint._animate_show = function(l_4_0, l_4_1, l_4_2, l_4_3, l_4_4)
  local clip_panel = l_4_1:child("clip_panel")
  local hint_text = clip_panel:child("hint_text")
  l_4_1:set_visible(true)
  l_4_1:set_alpha(1)
  hint_text:set_text(l_4_4)
  local offset = 32
  local _, _, w, h = hint_text:text_rect()
  hint_text:set_w(w + offset)
  clip_panel:set_w(w + offset)
  clip_panel:set_center_x(clip_panel:parent():w() / 2)
  clip_panel:set_w(0)
  local target_w = w + offset
  local w = 0
  local marker = l_4_1:child("marker")
  marker:set_visible(true)
  local t = l_4_3
  local forever = t == -1
  local st = 1
  local cs = 0
  local speed = 600
  local presenting = true
  repeat
    if presenting then
      local dt = coroutine.yield()
      w = math.clamp(w + dt * speed, 0, target_w)
      presenting = w ~= target_w
      clip_panel:set_w(w)
      hint_text:set_text("")
      hint_text:set_text(l_4_4)
      marker:set_alpha((1 + math.sin(Application:time() * 800)) / 2)
      marker:set_right(clip_panel:right())
    elseif (t > 0 or forever) and not l_4_0._stop then
      local dt = coroutine.yield()
      t = t - dt
      marker:set_alpha((1 + math.sin(Application:time() * 800)) / 2)
      marker:set_right(clip_panel:right())
    else
      l_4_0._stop = false
      do
        local removing = true
        repeat
          if removing then
            local dt = coroutine.yield()
            w = math.clamp(w - dt * speed * 2, 0, target_w)
            clip_panel:set_w(w)
            removing = w ~= 0
            marker:set_alpha((1 + math.sin(Application:time() * 800)) / 2)
            marker:set_right(clip_panel:right())
          else
            l_4_1:set_visible(false)
            l_4_2()
          end
           -- Warning: missing end command somewhere! Added here
        end
         -- Warning: missing end command somewhere! Added here
      end
       -- Warning: missing end command somewhere! Added here
    end
     -- Warning: missing end command somewhere! Added here
  end
end

HUDHint.show_done = function(l_5_0)
end


