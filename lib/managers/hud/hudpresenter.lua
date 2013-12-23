-- Decompiled using luadec 2.0.1 by sztupy (http://winmo.sztupy.hu)
-- Command line was: F:\SteamLibrary\SteamApps\common\PAYDAY 2\lua\lib\managers\hud\hudpresenter.luac 

if not HUDPresenter then
  HUDPresenter = class()
end
HUDPresenter.init = function(l_1_0, l_1_1)
  l_1_0._hud_panel = l_1_1.panel
  if l_1_0._hud_panel:child("present_panel") then
    l_1_0._hud_panel:remove(l_1_0._hud_panel:child("present_panel"))
  end
  local h = 68
  local w = 450
  local x = math.round(l_1_0._hud_panel:w() / 2 - w / 2)
  local y = math.round(l_1_0._hud_panel:h() / 14)
  local present_panel = l_1_0._hud_panel:panel({visible = false, name = "present_panel", layer = 10})
  l_1_0._bg_box = HUDBGBox_create(present_panel, {w = w, h = h, x = x, y = y, valign = {0.20000000298023, 0}})
  l_1_0._bg_box:set_center_y(math.round(l_1_0._hud_panel:h() / 5))
   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

  local title = l_1_0._bg_box:text({name = "title", text = "TITLE"})
  local _, _, _, h = title:text_rect()
  title:set_h(h)
  {name = "title", text = "TITLE"}.font_size, {name = "title", text = "TITLE"}.font, {name = "title", text = "TITLE"}.color, {name = "title", text = "TITLE"}.x, {name = "title", text = "TITLE"}.layer, {name = "title", text = "TITLE"}.valign, {name = "title", text = "TITLE"}.vertical = tweak_data.hud_present.title_size, tweak_data.hud_present.title_font, Color.white:with_alpha(1), 8, 1, "bottom", "bottom"
  title:set_bottom(math.floor(l_1_0._bg_box:h() / 2) + 2)
   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

  local text = l_1_0._bg_box:text({name = "text", text = "TEXT"})
  local _, _, _, h = text:text_rect()
  text:set_h(h)
  {name = "text", text = "TEXT"}.font_size, {name = "text", text = "TEXT"}.font, {name = "text", text = "TEXT"}.color, {name = "text", text = "TEXT"}.x, {name = "text", text = "TEXT"}.layer, {name = "text", text = "TEXT"}.valign, {name = "text", text = "TEXT"}.vertical = tweak_data.hud_present.text_size, tweak_data.hud_present.text_font, Color.white, 8, 1, "top", "top"
  text:set_top(math.ceil(l_1_0._bg_box:h() / 2) - 2)
end

HUDPresenter.present = function(l_2_0, l_2_1)
  if not l_2_0._present_queue then
    l_2_0._present_queue = {}
  end
  if l_2_0._presenting then
    table.insert(l_2_0._present_queue, l_2_1)
    return 
  end
  if l_2_1.present_mid_text then
    l_2_0:_present_information(l_2_1)
  end
end

HUDPresenter._present_information = function(l_3_0, l_3_1)
  local present_panel = l_3_0._hud_panel:child("present_panel")
  local title = l_3_0._bg_box:child("title")
  local text = l_3_0._bg_box:child("text")
  title:set_text(utf8.to_upper(l_3_1.title or "ERROR"))
  text:set_text(utf8.to_upper(l_3_1.text))
  title:set_visible(false)
  text:set_visible(false)
  local _, _, w, _ = title:text_rect()
  title:set_w(w)
  local _, _, w2, _ = text:text_rect()
  text:set_w(w2)
  local tw = math.max(w, w2)
  l_3_0._bg_box:set_w(tw + 16)
  l_3_0._bg_box:set_left(math.round(l_3_0._bg_box:parent():w() / 2 - l_3_0._bg_box:w() / 2))
  if not l_3_1.icon or l_3_1.event then
    managers.hud._sound_source:post_event(l_3_1.event)
  end
  present_panel:animate(callback(l_3_0, l_3_0, "_animate_present_information"), {done_cb = callback(l_3_0, l_3_0, "_present_done"), seconds = l_3_1.time or 4, use_icon = l_3_1.icon})
  l_3_0._presenting = true
end

HUDPresenter._present_done = function(l_4_0)
  print(Application:time(), ":_present_done()")
  l_4_0._presenting = false
  local queued = table.remove(l_4_0._present_queue, 1)
  if queued and queued.present_mid_text then
    setup:add_end_frame_clbk(callback(l_4_0, l_4_0, "_do_it", queued))
  end
end

HUDPresenter._do_it = function(l_5_0, l_5_1)
  print("do_it", inspect(l_5_1))
  l_5_0:_present_information(l_5_1)
end

HUDPresenter._animate_present_information = function(l_6_0, l_6_1, l_6_2)
  l_6_1:set_visible(true)
  l_6_1:set_alpha(1)
  local title = l_6_0._bg_box:child("title")
  local text = l_6_0._bg_box:child("text")
  local open_done = function()
    title:set_visible(true)
    text:set_visible(true)
    title:animate(callback(self, self, "_animate_show_text"), text)
    wait(params.seconds)
    title:animate(callback(self, self, "_animate_hide_text"), text)
    wait(0.5)
    local close_done = function()
      present_panel:set_visible(false)
      self:_present_done()
      end
    self._bg_box:animate(callback(nil, _G, "HUDBGBox_animate_close_center"), close_done)
   end
  l_6_0._bg_box:stop()
  l_6_0._bg_box:animate((callback(nil, _G, "HUDBGBox_animate_open_center")), nil, l_6_0._bg_box:w(), open_done)
end

HUDPresenter._animate_show_text = function(l_7_0, l_7_1, l_7_2)
  local TOTAL_T = 0.5
  do
    local t = TOTAL_T
    repeat
      if t > 0 then
        local dt = coroutine.yield()
        t = t - dt
        local alpha = math.round(math.abs(math.sin((t) * 360 * 3)))
        l_7_1:set_alpha(alpha)
        l_7_2:set_alpha(alpha)
      else
        l_7_1:set_alpha(1)
        l_7_2:set_alpha(1)
      end
       -- Warning: missing end command somewhere! Added here
    end
     -- Warning: missing end command somewhere! Added here
  end
end

HUDPresenter._animate_hide_text = function(l_8_0, l_8_1, l_8_2)
  local TOTAL_T = 0.5
  do
    local t = TOTAL_T
    repeat
      if t > 0 then
        local dt = coroutine.yield()
        t = t - dt
        local vis = math.round(math.abs(math.cos((t) * 360 * 3)))
        l_8_1:set_alpha(vis)
        l_8_2:set_alpha(vis)
      else
        l_8_1:set_alpha(1)
        l_8_2:set_alpha(1)
        l_8_1:set_visible(false)
        l_8_2:set_visible(false)
      end
       -- Warning: missing end command somewhere! Added here
    end
     -- Warning: missing end command somewhere! Added here
  end
end


