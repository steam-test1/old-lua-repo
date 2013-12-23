-- Decompiled using luadec 2.0.1 by sztupy (http://winmo.sztupy.hu)
-- Command line was: F:\SteamLibrary\SteamApps\common\PAYDAY 2\lua\lib\managers\hud\hudaccesscamera.luac 

if not HUDAccessCamera then
  HUDAccessCamera = class()
end
HUDAccessCamera.init = function(l_1_0, l_1_1, l_1_2)
  l_1_0._hud_panel = l_1_1.panel
  l_1_0._full_hud_panel = l_1_2.panel
  l_1_0._hud_panel:clear()
  l_1_0._full_hud_panel:clear()
  l_1_0._markers = {}
  local legend_rect_bg = l_1_0._hud_panel:rect({name = "legend_rect_bg", color = Color.black, layer = 0, h = 32, w = l_1_0._hud_panel:w() / 2, x = l_1_0._hud_panel:w() / 4, y = l_1_1.panel:h() - 64, valign = "bottom"})
   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

  local legend_prev = l_1_0._hud_panel:text({name = "legend_prev", text_id = "hud_prev_camera", x = legend_rect_bg:x() + 10, y = -32, font_size = 28, font = tweak_data.hud.medium_font, color = Color.white, align = "left", vertical = "bottom", valign = "bottom"})
   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

  local legend_next = l_1_0._hud_panel:text({name = "legend_next", text = "[MOUSE 1]>", x = legend_rect_bg:right() - 10, y = -32, font_size = 28, font = tweak_data.hud.medium_font, color = Color.white, align = "right", vertical = "bottom", valign = "bottom"})
  legend_next:set_right(legend_rect_bg:right() - 10)
  {name = "legend_next", text = "[MOUSE 1]>", x = legend_rect_bg:right() - 10, y = -32, font_size = 28, font = tweak_data.hud.medium_font, color = Color.white, align = "right", vertical = "bottom", valign = "bottom"}.word_wrap, {name = "legend_next", text = "[MOUSE 1]>", x = legend_rect_bg:right() - 10, y = -32, font_size = 28, font = tweak_data.hud.medium_font, color = Color.white, align = "right", vertical = "bottom", valign = "bottom"}.wrap, {name = "legend_next", text = "[MOUSE 1]>", x = legend_rect_bg:right() - 10, y = -32, font_size = 28, font = tweak_data.hud.medium_font, color = Color.white, align = "right", vertical = "bottom", valign = "bottom"}.layer, {name = "legend_prev", text_id = "hud_prev_camera", x = legend_rect_bg:x() + 10, y = -32, font_size = 28, font = tweak_data.hud.medium_font, color = Color.white, align = "left", vertical = "bottom", valign = "bottom"}.word_wrap, {name = "legend_prev", text_id = "hud_prev_camera", x = legend_rect_bg:x() + 10, y = -32, font_size = 28, font = tweak_data.hud.medium_font, color = Color.white, align = "left", vertical = "bottom", valign = "bottom"}.wrap, {name = "legend_prev", text_id = "hud_prev_camera", x = legend_rect_bg:x() + 10, y = -32, font_size = 28, font = tweak_data.hud.medium_font, color = Color.white, align = "left", vertical = "bottom", valign = "bottom"}.layer = false, false, 1, false, false, 1
   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

  local legend_exit = l_1_0._hud_panel:text({name = "legend_exit", text = "EXIT[SPACE]", x = 0, y = -32, font_size = 28, font = tweak_data.hud.medium_font, color = Color.white, align = "center", vertical = "bottom", valign = "bottom"})
  legend_exit:set_center_x(legend_rect_bg:center_x())
  {name = "legend_exit", text = "EXIT[SPACE]", x = 0, y = -32, font_size = 28, font = tweak_data.hud.medium_font, color = Color.white, align = "center", vertical = "bottom", valign = "bottom"}.word_wrap, {name = "legend_exit", text = "EXIT[SPACE]", x = 0, y = -32, font_size = 28, font = tweak_data.hud.medium_font, color = Color.white, align = "center", vertical = "bottom", valign = "bottom"}.wrap, {name = "legend_exit", text = "EXIT[SPACE]", x = 0, y = -32, font_size = 28, font = tweak_data.hud.medium_font, color = Color.white, align = "center", vertical = "bottom", valign = "bottom"}.layer = false, false, 1
   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

  l_1_0._hud_panel:text({x = 10, name = "camera_name", text = "", font_size = 32, font = tweak_data.hud.medium_font, color = Color.white, align = "left", vertical = "bottom"})
  {x = 10, name = "camera_name", text = "", font_size = 32, font = tweak_data.hud.medium_font, color = Color.white, align = "left", vertical = "bottom"}.word_wrap, {x = 10, name = "camera_name", text = "", font_size = 32, font = tweak_data.hud.medium_font, color = Color.white, align = "left", vertical = "bottom"}.wrap, {x = 10, name = "camera_name", text = "", font_size = 32, font = tweak_data.hud.medium_font, color = Color.white, align = "left", vertical = "bottom"}.layer, {x = 10, name = "camera_name", text = "", font_size = 32, font = tweak_data.hud.medium_font, color = Color.white, align = "left", vertical = "bottom"}.valign = false, false, 1, "bottom"
   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

  l_1_0._hud_panel:text({x = -10, name = "date", text = "", font_size = 32, font = tweak_data.hud.medium_font, color = Color.white, align = "right", vertical = "bottom"})
  {x = -10, name = "date", text = "", font_size = 32, font = tweak_data.hud.medium_font, color = Color.white, align = "right", vertical = "bottom"}.word_wrap, {x = -10, name = "date", text = "", font_size = 32, font = tweak_data.hud.medium_font, color = Color.white, align = "right", vertical = "bottom"}.wrap, {x = -10, name = "date", text = "", font_size = 32, font = tweak_data.hud.medium_font, color = Color.white, align = "right", vertical = "bottom"}.layer, {x = -10, name = "date", text = "", font_size = 32, font = tweak_data.hud.medium_font, color = Color.white, align = "right", vertical = "bottom"}.valign = false, false, 1, "bottom"
  l_1_0._hud_panel:rect({name = "rect_bg", color = Color.black, layer = 0, h = 32, y = l_1_1.panel:h() - 32, valign = "bottom"})
  l_1_0._hud_panel:rect({name = "destroyed_rect_bg", visible = false, color = Color.black, layer = 0, h = 32})
   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

  l_1_0._hud_panel:text({x = 10, name = "destroyed_text", visible = false, text = "FEED LOST", font_size = 32, font = tweak_data.hud.medium_font, color = Color.white, align = "left"})
  {x = 10, name = "destroyed_text", visible = false, text = "FEED LOST", font_size = 32, font = tweak_data.hud.medium_font, color = Color.white, align = "left"}.word_wrap, {x = 10, name = "destroyed_text", visible = false, text = "FEED LOST", font_size = 32, font = tweak_data.hud.medium_font, color = Color.white, align = "left"}.wrap, {x = 10, name = "destroyed_text", visible = false, text = "FEED LOST", font_size = 32, font = tweak_data.hud.medium_font, color = Color.white, align = "left"}.layer, {x = 10, name = "destroyed_text", visible = false, text = "FEED LOST", font_size = 32, font = tweak_data.hud.medium_font, color = Color.white, align = "left"}.vertical = false, false, 1, "top"
  l_1_0._full_hud_panel:rect({name = "destroyed_rect", visible = false, color = Color(0.5, 0.5, 0.5), layer = -1, valign = "scale"})
  local size = l_1_0._full_hud_panel:w() + 50
   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

  l_1_0._full_hud_panel:bitmap({name = "noise", texture = "core/textures/noise"})
  {name = "noise", texture = "core/textures/noise"}.halign, {name = "noise", texture = "core/textures/noise"}.valign, {name = "noise", texture = "core/textures/noise"}.h, {name = "noise", texture = "core/textures/noise"}.w, {name = "noise", texture = "core/textures/noise"}.wrap_mode, {name = "noise", texture = "core/textures/noise"}.layer, {name = "noise", texture = "core/textures/noise"}.color = "scale", "scale", size, size, "wrap", 3, Color(0.20000000298023, 0, 0, 0)
  l_1_0._full_hud_panel:child("noise"):set_texture_rect(0, 0, size, size)
   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

  l_1_0._full_hud_panel:bitmap({x = 0, y = 0, name = "noise2", texture = "core/textures/noise", color = Color(0.20000000298023, 0, 0, 0), layer = 3})
  {x = 0, y = 0, name = "noise2", texture = "core/textures/noise", color = Color(0.20000000298023, 0, 0, 0), layer = 3}.halign, {x = 0, y = 0, name = "noise2", texture = "core/textures/noise", color = Color(0.20000000298023, 0, 0, 0), layer = 3}.valign, {x = 0, y = 0, name = "noise2", texture = "core/textures/noise", color = Color(0.20000000298023, 0, 0, 0), layer = 3}.h, {x = 0, y = 0, name = "noise2", texture = "core/textures/noise", color = Color(0.20000000298023, 0, 0, 0), layer = 3}.w, {x = 0, y = 0, name = "noise2", texture = "core/textures/noise", color = Color(0.20000000298023, 0, 0, 0), layer = 3}.wrap_mode = "scale", "scale", size, size, "wrap"
  l_1_0._full_hud_panel:child("noise2"):set_texture_rect(0, 0, size, size)
end

HUDAccessCamera.start = function(l_2_0)
  local prev = "hud_prev_camera"
  local next = "hud_next_camera"
  l_2_0._hud_panel:child("legend_prev"):set_text(utf8.to_upper(managers.localization:text(prev, {BTN_PRIMARY = managers.localization:btn_macro("primary_attack")})))
  l_2_0._hud_panel:child("legend_next"):set_text(utf8.to_upper(managers.localization:text(next, {BTN_SECONDARY = managers.localization:btn_macro("secondary_attack")})))
  l_2_0._hud_panel:child("legend_exit"):set_text(utf8.to_upper(managers.localization:text("hud_exit_camera", {BTN_JUMP = managers.localization:btn_macro("jump")})))
  l_2_0._active = true
  l_2_0._hud_panel:animate(callback(l_2_0, l_2_0, "_animate_date"))
end

HUDAccessCamera.stop = function(l_3_0)
  l_3_0._active = false
end

HUDAccessCamera.set_destroyed = function(l_4_0, l_4_1, l_4_2)
  l_4_0._full_hud_panel:child("destroyed_rect"):set_visible(l_4_1)
  l_4_0._hud_panel:child("destroyed_rect_bg"):set_visible(l_4_1)
  l_4_0._hud_panel:child("destroyed_text"):set_text(managers.localization:text(l_4_2 and "hud_access_camera_no_feed" or "hud_access_camera_feed_lost"))
  l_4_0._hud_panel:child("destroyed_text"):set_visible(l_4_1)
end

HUDAccessCamera.set_camera_name = function(l_5_0, l_5_1)
  l_5_0._hud_panel:child("camera_name"):set_text(utf8.to_upper(l_5_1))
end

HUDAccessCamera.set_date = function(l_6_0, l_6_1)
  l_6_0._hud_panel:child("date"):set_text(l_6_1)
end

HUDAccessCamera._animate_date = function(l_7_0)
  repeat
    if l_7_0._active then
      local dt = coroutine.yield()
      l_7_0:set_date(Application:date("%Y-%m-%d %H:%M:%S"))
      l_7_0._full_hud_panel:child("noise"):set_x(-math.random(50))
      l_7_0._full_hud_panel:child("noise"):set_y(-math.random(50))
    else
       -- Warning: missing end command somewhere! Added here
    end
     -- Warning: missing end command somewhere! Added here
  end
end

HUDAccessCamera.draw_marker = function(l_8_0, l_8_1, l_8_2)
  if not l_8_0._markers then
    l_8_0._markers = {}
  end
  if not l_8_0._markers[l_8_1] then
    l_8_0._markers[l_8_1] = l_8_0._full_hud_panel:bitmap({texture = "guis/textures/access_camera_marker", color = Color.white, layer = -2, x = l_8_2.x, y = l_8_2.y})
  end
  l_8_0._markers[l_8_1]:set_center(l_8_2.x, l_8_2.y)
end

HUDAccessCamera.max_markers = function(l_9_0, l_9_1)
  repeat
    if l_9_1 < #l_9_0._markers then
      local obj = table.remove(l_9_0._markers, l_9_1 + 1)
      l_9_0._full_hud_panel:remove(obj)
    else
       -- Warning: missing end command somewhere! Added here
    end
     -- Warning: missing end command somewhere! Added here
  end
end


