-- Decompiled using luadec 2.0.1 by sztupy (http://winmo.sztupy.hu)
-- Command line was: F:\SteamLibrary\SteamApps\common\PAYDAY 2\lua\lib\managers\hud\hudsuspicion.luac 

if not HUDSuspicion then
  HUDSuspicion = class()
end
HUDSuspicion.init = function(l_1_0, l_1_1, l_1_2)
  l_1_0._hud_panel = l_1_1.panel
  l_1_0._sound_source = l_1_2
  if l_1_0._hud_panel:child("suspicion_panel") then
    l_1_0._hud_panel:remove(l_1_0._hud_panel:child("suspicion_panel"))
  end
  l_1_0._suspicion_panel = l_1_0._hud_panel:panel({visible = false, name = "suspicion_panel", y = 0, valign = "center", layer = 1})
  l_1_0._misc_panel = l_1_0._suspicion_panel:panel({name = "misc_panel"})
  l_1_0._suspicion_panel:set_size(200, 200)
  l_1_0._suspicion_panel:set_center(l_1_0._suspicion_panel:parent():w() / 2, l_1_0._suspicion_panel:parent():h() / 2)
  local scale = 1.1749999523163
   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

  local suspicion_left = l_1_0._suspicion_panel:bitmap({name = "suspicion_left", visible = true, texture = "guis/textures/pd2/hud_stealthmeter", color = Color(0, 1, 1), alpha = 1, valign = "center"})
  suspicion_left:set_size(suspicion_left:w() * scale, suspicion_left:h() * scale)
  {name = "suspicion_left", visible = true, texture = "guis/textures/pd2/hud_stealthmeter", color = Color(0, 1, 1), alpha = 1, valign = "center"}.layer, {name = "suspicion_left", visible = true, texture = "guis/textures/pd2/hud_stealthmeter", color = Color(0, 1, 1), alpha = 1, valign = "center"}.render_template, {name = "suspicion_left", visible = true, texture = "guis/textures/pd2/hud_stealthmeter", color = Color(0, 1, 1), alpha = 1, valign = "center"}.blend_mode, {name = "suspicion_left", visible = true, texture = "guis/textures/pd2/hud_stealthmeter", color = Color(0, 1, 1), alpha = 1, valign = "center"}.h, {name = "suspicion_left", visible = true, texture = "guis/textures/pd2/hud_stealthmeter", color = Color(0, 1, 1), alpha = 1, valign = "center"}.w = 1, "VertexColorTexturedRadial", "add", 128, 128
  suspicion_left:set_center_x(l_1_0._suspicion_panel:w() / 2)
  suspicion_left:set_center_y(l_1_0._suspicion_panel:h() / 2)
   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

  local suspicion_right = l_1_0._suspicion_panel:bitmap({name = "suspicion_right", visible = true, texture = "guis/textures/pd2/hud_stealthmeter", color = Color(0, 1, 1), alpha = 1, valign = "center"})
  suspicion_right:set_size(suspicion_right:w() * scale, suspicion_right:h() * scale)
  {name = "suspicion_right", visible = true, texture = "guis/textures/pd2/hud_stealthmeter", color = Color(0, 1, 1), alpha = 1, valign = "center"}.layer, {name = "suspicion_right", visible = true, texture = "guis/textures/pd2/hud_stealthmeter", color = Color(0, 1, 1), alpha = 1, valign = "center"}.render_template, {name = "suspicion_right", visible = true, texture = "guis/textures/pd2/hud_stealthmeter", color = Color(0, 1, 1), alpha = 1, valign = "center"}.blend_mode, {name = "suspicion_right", visible = true, texture = "guis/textures/pd2/hud_stealthmeter", color = Color(0, 1, 1), alpha = 1, valign = "center"}.h, {name = "suspicion_right", visible = true, texture = "guis/textures/pd2/hud_stealthmeter", color = Color(0, 1, 1), alpha = 1, valign = "center"}.w = 1, "VertexColorTexturedRadial", "add", 128, 128
  suspicion_right:set_center(suspicion_left:center())
  suspicion_left:set_texture_rect(128, 0, -128, 128)
   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

  local hud_stealthmeter_bg = l_1_0._misc_panel:bitmap({name = "hud_stealthmeter_bg", visible = true})
  hud_stealthmeter_bg:set_size(hud_stealthmeter_bg:w() * scale, hud_stealthmeter_bg:h() * scale)
  {name = "hud_stealthmeter_bg", visible = true}.blend_mode, {name = "hud_stealthmeter_bg", visible = true}.h, {name = "hud_stealthmeter_bg", visible = true}.w, {name = "hud_stealthmeter_bg", visible = true}.valign, {name = "hud_stealthmeter_bg", visible = true}.alpha, {name = "hud_stealthmeter_bg", visible = true}.color, {name = "hud_stealthmeter_bg", visible = true}.texture = "normal", 128, 128, {0.5, 0}, 0, Color(0.20000000298023, 1, 1, 1), "guis/textures/pd2/hud_stealthmeter_bg"
  hud_stealthmeter_bg:set_center(suspicion_left:center())
  local suspicion_detected = l_1_0._suspicion_panel:text({name = "suspicion_detected", text = managers.localization:to_upper_text("hud_detected"), font_size = tweak_data.menu.pd2_medium_font_size, font = tweak_data.menu.pd2_medium_font, layer = 2, align = "center", vertical = "center", alpha = 0})
  suspicion_detected:set_text(utf8.to_upper(managers.localization:text("hud_suspicion_detected")))
  suspicion_detected:set_center(suspicion_left:center())
   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

  local hud_stealth_eye = l_1_0._misc_panel:bitmap({name = "hud_stealth_eye", visible = true})
  hud_stealth_eye:set_center(suspicion_left:center_x(), suspicion_left:bottom() - 4)
  {name = "hud_stealth_eye", visible = true}.layer, {name = "hud_stealth_eye", visible = true}.blend_mode, {name = "hud_stealth_eye", visible = true}.valign, {name = "hud_stealth_eye", visible = true}.h, {name = "hud_stealth_eye", visible = true}.w, {name = "hud_stealth_eye", visible = true}.alpha, {name = "hud_stealth_eye", visible = true}.texture = 1, "add", "center", 32, 32, 0, "guis/textures/pd2/hud_stealth_eye"
   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

  local hud_stealth_exclam = l_1_0._misc_panel:bitmap({name = "hud_stealth_exclam", visible = true})
  hud_stealth_exclam:set_center(suspicion_left:center_x(), suspicion_left:top() - 4)
  {name = "hud_stealth_exclam", visible = true}.layer, {name = "hud_stealth_exclam", visible = true}.blend_mode, {name = "hud_stealth_exclam", visible = true}.valign, {name = "hud_stealth_exclam", visible = true}.h, {name = "hud_stealth_exclam", visible = true}.w, {name = "hud_stealth_exclam", visible = true}.alpha, {name = "hud_stealth_exclam", visible = true}.texture = 1, "add", "center", 32, 32, 0, "guis/textures/pd2/hud_stealth_exclam"
  l_1_0._eye_animation = nil
  l_1_0._suspicion_value = 0
end

HUDSuspicion.animate_eye = function(l_2_0)
  if l_2_0._eye_animation then
    return 
  end
  l_2_0._suspicion_value = 0
  l_2_0._discovered = nil
  l_2_0._back_to_stealth = nil
  local animate_func = function(l_1_0, l_1_1)
    local wanted_value = 0
    local value = wanted_value
    local suspicion_left = l_1_0:child("suspicion_left")
    local suspicion_right = l_1_0:child("suspicion_right")
    local suspicion_detected = l_1_0:child("suspicion_detected")
    local misc_panel = l_1_0:child("misc_panel")
    local animate_hide_misc = function(l_1_0)
      local hud_stealthmeter_bg = l_1_0:child("hud_stealthmeter_bg")
      local hud_stealth_eye = l_1_0:child("hud_stealth_eye")
      local start_alpha = hud_stealth_eye:alpha()
      wait(1.7999999523163)
      over(0.10000000149012, function(l_1_0)
        hud_stealthmeter_bg:set_alpha(math.lerp(start_alpha, 0, l_1_0))
        hud_stealth_eye:set_alpha(math.lerp(start_alpha, 0, l_1_0))
         end)
      end
    local animate_show_misc = function(l_2_0)
      local hud_stealthmeter_bg = l_2_0:child("hud_stealthmeter_bg")
      local hud_stealth_eye = l_2_0:child("hud_stealth_eye")
      local start_alpha = hud_stealth_eye:alpha()
      over(0.10000000149012, function(l_1_0)
        hud_stealthmeter_bg:set_alpha(math.lerp(start_alpha, 1, l_1_0))
        hud_stealth_eye:set_alpha(math.lerp(start_alpha, 1, l_1_0))
         end)
      end
    misc_panel:stop()
    misc_panel:animate(animate_show_misc)
    local c = (math.lerp(1, 0, math.clamp((value - 0.75) * 4, 0, 1)))
    local dt = nil
    local detect_me = false
    do
      local time_to_end = 4
      repeat
        repeat
          repeat
            repeat
              repeat
                repeat
                  if not alive(l_1_0) then
                    return 
                  end
                  dt = coroutine.yield()
                  if l_1_1._discovered then
                    l_1_1._discovered = nil
                    if not detect_me then
                      detect_me = true
                      wanted_value = 1
                      l_1_1._suspicion_value = wanted_value
                      l_1_1._sound_source:post_event("hud_suspicion_discovered")
                      local animate_detect_text = function(l_3_0)
                      local c = 0
                      local s = 0
                      local a = 0
                      local font_scale = l_3_0:font_scale()
                      over(0.80000001192093, function(l_1_0)
                        c = math.lerp(1, 0, math.clamp((l_1_0 - 0.75) * 6, 0, 1))
                        upvalue_512 = math.lerp(0, 1, math.min(1, l_1_0 * 2))
                        upvalue_1024 = math.lerp(0, 1, math.min(1, l_1_0 * 3))
                        o:set_alpha(a)
                        o:set_font_scale(font_scale * s)
                        o:set_color(Color(1, c, c))
                                 end)
                              end
                      suspicion_detected:stop()
                      suspicion_detected:animate(animate_detect_text)
                    end
                  end
                  if not detect_me and wanted_value ~= l_1_1._suspicion_value then
                    wanted_value = l_1_1._suspicion_value
                  end
                  if (not detect_me or time_to_end < 2) and l_1_1._back_to_stealth then
                    l_1_1._back_to_stealth = nil
                    detect_me = false
                    wanted_value = 0
                    l_1_1._suspicion_value = wanted_value
                    misc_panel:stop()
                    misc_panel:animate(animate_hide_misc)
                  end
                  value = math.lerp(value, wanted_value, 0.89999997615814)
                  c = math.lerp(1, 0, value)
                  if math.abs(value - wanted_value) < 0.0099999997764826 then
                    value = wanted_value
                  end
                  suspicion_left:set_color(Color(0.5 + value * 0.5, 1, 1))
                  suspicion_right:set_color(Color(0.5 + value * 0.5, 1, 1))
                  local misc_panel = l_1_0:child("misc_panel")
                  do
                    local hud_stealth_exclam = misc_panel:child("hud_stealth_exclam")
                    hud_stealth_exclam:set_alpha(math.clamp((value - 0.5) * 2, 0, 1))
                    if value == 1 then
                      time_to_end = time_to_end - dt
                    until time_to_end <= 0
                    l_1_1._eye_animation = nil
                    l_1_1:hide()
                    return 
                  elseif value == 0 then
                    time_to_end = time_to_end - dt * 2
                  until time_to_end <= 0
                  l_1_1._eye_animation = nil
                  l_1_1:hide()
                  return 
              until time_to_end ~= 4
              else
                time_to_end = 4
                misc_panel:stop()
                misc_panel:animate(animate_show_misc)
              end
              do return end
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
  l_2_0._sound_source:post_event("hud_suspicion_start")
  l_2_0._eye_animation = l_2_0._suspicion_panel:animate(animate_func, l_2_0)
end

HUDSuspicion.show = function(l_3_0)
  l_3_0:animate_eye()
  l_3_0._suspicion_panel:set_visible(true)
end

HUDSuspicion.hide = function(l_4_0)
  if l_4_0._eye_animation then
    l_4_0._eye_animation:stop()
    l_4_0._eye_animation = nil
    l_4_0._sound_source:post_event("hud_suspicion_end")
  end
  l_4_0._suspicion_value = 0
  l_4_0._discovered = nil
  l_4_0._back_to_stealth = nil
  if alive(l_4_0._misc_panel) then
    l_4_0._misc_panel:stop()
    l_4_0._misc_panel:child("hud_stealth_eye"):set_alpha(0)
    l_4_0._misc_panel:child("hud_stealth_exclam"):set_alpha(0)
    l_4_0._misc_panel:child("hud_stealthmeter_bg"):set_alpha(0)
  end
  if alive(l_4_0._suspicion_panel) then
    l_4_0._suspicion_panel:set_visible(false)
    l_4_0._suspicion_panel:child("suspicion_detected"):stop()
    l_4_0._suspicion_panel:child("suspicion_detected"):set_alpha(0)
  end
end

HUDSuspicion.feed_value = function(l_5_0, l_5_1)
  l_5_0:show()
  l_5_0._suspicion_value = l_5_1
end

HUDSuspicion.back_to_stealth = function(l_6_0)
  l_6_0._back_to_stealth = true
  if not l_6_0._eye_animation then
    l_6_0:hide()
  end
end

HUDSuspicion.discovered = function(l_7_0)
  l_7_0._discovered = true
end


