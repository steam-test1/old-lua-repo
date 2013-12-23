-- Decompiled using luadec 2.0.1 by sztupy (http://winmo.sztupy.hu)
-- Command line was: F:\SteamLibrary\SteamApps\common\PAYDAY 2\lua\lib\managers\hud\hudtemp.luac 

if not HUDTemp then
  HUDTemp = class()
end
HUDTemp.init = function(l_1_0, l_1_1)
  l_1_0._hud_panel = l_1_1.panel
  if l_1_0._hud_panel:child("temp_panel") then
    l_1_0._hud_panel:remove(l_1_0._hud_panel:child("temp_panel"))
  end
  l_1_0._temp_panel = l_1_0._hud_panel:panel({visible = true, name = "temp_panel", y = 0, valign = "scale", layer = 0})
  local throw_instruction = l_1_0._temp_panel:text({name = "throw_instruction", text = "", visible = false, alpha = 0.85000002384186, align = "right", vertical = "bottom", halign = "right", valign = "bottom", w = 300, h = 40, layer = 1, x = 8, y = 2, color = Color.white, font = "fonts/font_medium_mf", font_size = 24})
  l_1_0:set_throw_bag_text()
  local bag_panel = l_1_0._temp_panel:panel({visible = false, name = "bag_panel", halign = "right", valign = "bottom", layer = 10})
  l_1_0._bg_box = HUDBGBox_create(bag_panel, {w = 142, h = 56, x = 0, y = 0})
  bag_panel:set_size(l_1_0._bg_box:size())
   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

  l_1_0._bg_box:text({name = "bag_text", text = "CARRYING:\nCIRCUIT BOARDS", vertical = "left", valign = "center"})
  {name = "bag_text", text = "CARRYING:\nCIRCUIT BOARDS", vertical = "left", valign = "center"}.font_size, {name = "bag_text", text = "CARRYING:\nCIRCUIT BOARDS", vertical = "left", valign = "center"}.font, {name = "bag_text", text = "CARRYING:\nCIRCUIT BOARDS", vertical = "left", valign = "center"}.color, {name = "bag_text", text = "CARRYING:\nCIRCUIT BOARDS", vertical = "left", valign = "center"}.y, {name = "bag_text", text = "CARRYING:\nCIRCUIT BOARDS", vertical = "left", valign = "center"}.x, {name = "bag_text", text = "CARRYING:\nCIRCUIT BOARDS", vertical = "left", valign = "center"}.layer = 24, "fonts/font_medium_mf", Color.white, 2, 8, 1
   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

  local bag_text = bag_panel:text({name = "bag_text", visible = false, text = "HEJ", font = "fonts/font_large_mf", align = "center", vertical = "center", font_size = 42, halign = "scale"})
  bag_text:set_size(bag_panel:size())
  {name = "bag_text", visible = false, text = "HEJ", font = "fonts/font_large_mf", align = "center", vertical = "center", font_size = 42, halign = "scale"}.h, {name = "bag_text", visible = false, text = "HEJ", font = "fonts/font_large_mf", align = "center", vertical = "center", font_size = 42, halign = "scale"}.w, {name = "bag_text", visible = false, text = "HEJ", font = "fonts/font_large_mf", align = "center", vertical = "center", font_size = 42, halign = "scale"}.color, {name = "bag_text", visible = false, text = "HEJ", font = "fonts/font_large_mf", align = "center", vertical = "center", font_size = 42, halign = "scale"}.valign = 128, 256, Color.black, "scale"
  bag_text:set_position(0, 4)
  l_1_0._bag_panel_w = bag_panel:w()
  l_1_0._bag_panel_h = bag_panel:h()
  bag_panel:set_right(l_1_0._temp_panel:w())
  bag_panel:set_bottom(l_1_0:_bag_panel_bottom())
  throw_instruction:set_bottom(bag_panel:top())
  throw_instruction:set_right(bag_panel:right())
  l_1_0._curr_stamina = 0
  l_1_0._max_stamina = 0
  l_1_0._stamina_panel = l_1_0._temp_panel:panel({visable = true, name = "stamina_panel", layer = 0, w = 16, h = 128, halign = "right", valign = "center", alpha = 0})
  local stamina_bar_bg = l_1_0._stamina_panel:rect({name = "stamina_bar_bg", color = Color(0.60000002384186, 0.60000002384186, 0.60000002384186), alpha = 0.25})
  local low_stamina_bar = l_1_0._stamina_panel:rect({name = "low_stamina_bar", color = Color(0.60000002384186, 0.60000002384186, 0.60000002384186), alpha = 0})
  local stamina_bar = l_1_0._stamina_panel:rect({name = "stamina_bar", color = Color(0.60000002384186, 0.60000002384186, 0.60000002384186), layer = 1})
  local stamina_threshold = l_1_0._stamina_panel:rect({name = "stamina_threshold", color = Color(1, 1, 1), layer = 2, h = 2})
  l_1_0._stamina_panel:rect({name = "top_border", color = Color(), layer = 3, h = 2}):set_top(0)
  l_1_0._stamina_panel:rect({name = "bottom_border", color = Color(), layer = 3, h = 2}):set_bottom(128)
  l_1_0._stamina_panel:rect({name = "left_border", color = Color(), layer = 3, w = 2}):set_left(0)
  l_1_0._stamina_panel:rect({name = "right_border", color = Color(), layer = 3, w = 2}):set_right(16)
  l_1_0._stamina_panel:set_right(l_1_0._temp_panel:w())
  l_1_0._stamina_panel:set_center_y(l_1_0._temp_panel:center_y())
end

HUDTemp.set_throw_bag_text = function(l_2_0)
  l_2_0._temp_panel:child("throw_instruction"):set_text(utf8.to_upper(managers.localization:text("hud_instruct_throw_bag", {BTN_USE_ITEM = managers.localization:btn_macro("use_item")})))
end

HUDTemp._bag_panel_bottom = function(l_3_0)
  return l_3_0._temp_panel:h() - managers.hud:teampanels_height()
end

HUDTemp.show_carry_bag = function(l_4_0, l_4_1, l_4_2)
  local bag_panel = l_4_0._temp_panel:child("bag_panel")
  local carry_data = tweak_data.carry[l_4_1]
  if carry_data.name_id then
    local type_text = managers.localization:text(carry_data.name_id)
  end
  local bag_text = bag_panel:child("bag_text")
  bag_text:set_text(utf8.to_upper(type_text .. " \n " .. managers.experience:cash_string(l_4_2)))
  bag_panel:set_x(l_4_0._temp_panel:parent():w() / 2)
  bag_panel:set_visible(true)
  l_4_0._bg_box:child("bag_text"):set_visible(false)
  local carrying_text = managers.localization:text("hud_carrying")
  l_4_0._bg_box:child("bag_text"):set_text(utf8.to_upper(carrying_text .. "\n" .. type_text))
  l_4_0._bg_box:set_w(l_4_0._bag_panel_w, l_4_0._bag_panel_h)
  l_4_0._bg_box:set_position(0, 0)
  bag_panel:stop()
  bag_panel:animate(callback(l_4_0, l_4_0, "_animate_show_bag_panel"))
end

HUDTemp.hide_carry_bag = function(l_5_0)
  local bag_panel = l_5_0._temp_panel:child("bag_panel")
  bag_panel:stop()
  l_5_0._temp_panel:child("throw_instruction"):set_visible(false)
  bag_panel:animate(callback(l_5_0, l_5_0, "_animate_hide_bag_panel"))
end

HUDTemp._animate_hide_bag_panel = function(l_6_0, l_6_1)
  local bag_text = l_6_0._bg_box:child("bag_text")
  bag_text:stop()
  bag_text:animate(callback(l_6_0, l_6_0, "_animate_hide_text"))
  wait(0.5)
  local close_done = function()
    bag_panel:set_visible(false)
   end
  l_6_0._bg_box:animate(callback(nil, _G, "HUDBGBox_animate_close_left"), close_done)
end

HUDTemp._animate_show_bag_panel = function(l_7_0, l_7_1)
  local w, h = l_7_0._bag_panel_w, l_7_0._bag_panel_h
  local scx = l_7_0._temp_panel:w() / 2
  local ecx = l_7_0._temp_panel:w() - w / 2
  local scy = l_7_0._temp_panel:h() / 2
  local ecy = l_7_0:_bag_panel_bottom() - l_7_0._bag_panel_h / 2
  local bottom = l_7_1:bottom()
  local center_y = l_7_1:center_y()
  local bag_text = l_7_0._bg_box:child("bag_text")
  local open_done = function()
    bag_text:stop()
    bag_text:set_visible(true)
    bag_text:animate(callback(self, self, "_animate_show_text"))
   end
  l_7_0._bg_box:stop()
  l_7_0._bg_box:animate((callback(nil, _G, "HUDBGBox_animate_open_center")), nil, w, open_done)
  l_7_1:set_size(w, h)
  l_7_1:set_center_x(scx)
  l_7_1:set_center_y(scy)
  wait(1)
  local TOTAL_T = 0.5
  do
    local t = TOTAL_T
    repeat
      if t > 0 then
        local dt = coroutine.yield()
        t = t - dt
        l_7_1:set_center_x(math.lerp(scx, ecx, 1 - (t) / TOTAL_T))
        l_7_1:set_center_y(math.lerp(scy, ecy, 1 - (t) / TOTAL_T))
      else
        l_7_0._temp_panel:child("throw_instruction"):set_visible(true)
        l_7_1:set_size(w, h)
        l_7_1:set_center_x(ecx)
        l_7_1:set_center_y(ecy)
      end
       -- Warning: missing end command somewhere! Added here
    end
     -- Warning: missing end command somewhere! Added here
  end
end

HUDTemp._animate_show_bag_panel_old = function(l_8_0, l_8_1)
  local w, h = l_8_0._bag_panel_w, l_8_0._bag_panel_h
  local scx = l_8_0._temp_panel:w() / 2
  local ecx = l_8_0._temp_panel:w() - w / 2
  local scy = l_8_0._temp_panel:h() / 2
  local ecy = l_8_0:_bag_panel_bottom() - l_8_0._bag_panel_h / 2
  local bottom = l_8_1:bottom()
  local center_y = l_8_1:center_y()
  local scale = 2
  l_8_1:set_size(w * scale, h * scale)
  local font_size = 24
  local bag_text = l_8_1:child("bag_text")
  bag_text:set_font_size(font_size * scale)
  bag_text:set_rotation(360)
  local _, _, tw, th = bag_text:text_rect()
  font_size = font_size * math.min(1, l_8_1:w() / (tw * 1.1499999761581))
  local TOTAL_T = 0.25
  local t = TOTAL_T
  repeat
    if t > 0 then
      local dt = coroutine.yield()
      t = t - dt
      local wm = math.lerp(0, w * scale, 1 - (t) / TOTAL_T)
      local hm = math.lerp(0, h * scale, 1 - (t) / TOTAL_T)
      l_8_1:set_size(wm, hm)
      l_8_1:set_center_x(scx)
      l_8_1:set_center_y(scy)
      bag_text:set_font_size(math.lerp(0, font_size * scale, 1 - (t) / TOTAL_T))
    else
      wait(0.5)
      local TOTAL_T = 0.5
      do
        local t = TOTAL_T
        repeat
          if t > 0 then
            local dt = coroutine.yield()
            t = t - dt
            local wm = math.lerp(w * scale, w, 1 - (t) / TOTAL_T)
            local hm = math.lerp(h * scale, h, 1 - (t) / TOTAL_T)
            l_8_1:set_size(wm, hm)
            l_8_1:set_center_x(math.lerp(scx, ecx, 1 - (t) / TOTAL_T))
            l_8_1:set_center_y(math.lerp(scy, ecy, 1 - (t) / TOTAL_T))
            bag_text:set_font_size(math.lerp(font_size * scale, font_size, 1 - (t) / TOTAL_T))
          else
            l_8_1:set_size(w, h)
            l_8_1:set_center_x(ecx)
            l_8_1:set_center_y(ecy)
            bag_text:set_font_size(font_size)
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

HUDTemp._animate_show_text = function(l_9_0, l_9_1)
  local TOTAL_T = 0.5
  do
    local t = TOTAL_T
    repeat
      if t > 0 then
        local dt = coroutine.yield()
        t = t - dt
        local alpha = math.round(math.abs(math.sin((t) * 360 * 3)))
        l_9_1:set_alpha(alpha)
      else
        l_9_1:set_alpha(1)
      end
       -- Warning: missing end command somewhere! Added here
    end
     -- Warning: missing end command somewhere! Added here
  end
end

HUDTemp._animate_hide_text = function(l_10_0, l_10_1)
  local TOTAL_T = 0.5
  do
    local t = TOTAL_T
    repeat
      if t > 0 then
        local dt = coroutine.yield()
        t = t - dt
        local vis = math.round(math.abs(math.cos((t) * 360 * 3)))
        l_10_1:set_alpha(vis)
      else
        l_10_1:set_alpha(1)
        l_10_1:set_visible(false)
      end
       -- Warning: missing end command somewhere! Added here
    end
     -- Warning: missing end command somewhere! Added here
  end
end

HUDTemp.set_stamina_value = function(l_11_0, l_11_1)
  l_11_0._curr_stamina = l_11_1
  l_11_0._stamina_panel:child("stamina_bar"):set_h(l_11_1 / math.max(1, l_11_0._max_stamina) * l_11_0._stamina_panel:h())
  l_11_0._stamina_panel:child("stamina_bar"):set_bottom(l_11_0._stamina_panel:h())
  if l_11_0._curr_stamina < tweak_data.player.movement_state.stamina.MIN_STAMINA_THRESHOLD then
    l_11_0._stamina_panel:animate(callback(l_11_0, l_11_0, "_animate_low_stamina"))
  else
    l_11_0._stamina_panel:child("low_stamina_bar"):set_alpha(0)
    l_11_0._stamina_panel:stop()
  end
end

HUDTemp.set_max_stamina = function(l_12_0, l_12_1)
  l_12_0._max_stamina = l_12_1
  l_12_0._stamina_panel:child("stamina_threshold"):set_center_y(l_12_0._stamina_panel:h() - tweak_data.player.movement_state.stamina.MIN_STAMINA_THRESHOLD / math.max(1, l_12_0._max_stamina) * l_12_0._stamina_panel:h())
end

HUDTemp._animate_low_stamina = function(l_13_0, l_13_1)
  do
    local low_stamina_bar = l_13_1:child("low_stamina_bar")
    repeat
      do
        local a = 0.25 + (math.sin(Application:time() * 750) + 1) / 4
        low_stamina_bar:set_alpha(a)
        low_stamina_bar:set_color(Color(a, 0, 0.80000001192093 - a))
        coroutine.yield()
      end
      do return end
    end
     -- Warning: missing end command somewhere! Added here
  end
end


