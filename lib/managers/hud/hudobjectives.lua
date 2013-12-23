-- Decompiled using luadec 2.0.1 by sztupy (http://winmo.sztupy.hu)
-- Command line was: F:\SteamLibrary\SteamApps\common\PAYDAY 2\lua\lib\managers\hud\hudobjectives.luac 

HUDBGBox_create = function(l_1_0, l_1_1, l_1_2)
  local box_panel = l_1_0:panel(l_1_1)
  if l_1_2 then
    local color = l_1_2.color
  end
  if l_1_2 then
    local blend_mode = l_1_2.blend_mode
  end
  box_panel:rect({name = "bg", halign = "grow", valign = "grow", blend_mode = "normal", alpha = 0.25, color = Color(1, 0, 0, 0), layer = -1})
   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

  local left_top = box_panel:bitmap({halign = "left", valign = "top", name = "left_top", color = color})
   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

  local left_bottom = box_panel:bitmap({halign = "left", valign = "bottom", color = color, rotation = -90, name = "left_bottom", blend_mode = blend_mode})
  left_bottom:set_bottom(box_panel:h())
  {halign = "left", valign = "bottom", color = color, rotation = -90, name = "left_bottom", blend_mode = blend_mode}.y, {halign = "left", valign = "bottom", color = color, rotation = -90, name = "left_bottom", blend_mode = blend_mode}.x, {halign = "left", valign = "bottom", color = color, rotation = -90, name = "left_bottom", blend_mode = blend_mode}.texture, {halign = "left", valign = "bottom", color = color, rotation = -90, name = "left_bottom", blend_mode = blend_mode}.layer, {halign = "left", valign = "bottom", color = color, rotation = -90, name = "left_bottom", blend_mode = blend_mode}.visible, {halign = "left", valign = "top", name = "left_top", color = color}.y, {halign = "left", valign = "top", name = "left_top", color = color}.x, {halign = "left", valign = "top", name = "left_top", color = color}.texture, {halign = "left", valign = "top", name = "left_top", color = color}.layer, {halign = "left", valign = "top", name = "left_top", color = color}.visible, {halign = "left", valign = "top", name = "left_top", color = color}.blend_mode = 0, 0, "guis/textures/pd2/hud_corner", 0, true, 0, 0, "guis/textures/pd2/hud_corner", 0, true, blend_mode
   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

  local right_top = box_panel:bitmap({halign = "right", valign = "top", color = color, rotation = 90, name = "right_top", blend_mode = blend_mode})
  right_top:set_right(box_panel:w())
  {halign = "right", valign = "top", color = color, rotation = 90, name = "right_top", blend_mode = blend_mode}.y, {halign = "right", valign = "top", color = color, rotation = 90, name = "right_top", blend_mode = blend_mode}.x, {halign = "right", valign = "top", color = color, rotation = 90, name = "right_top", blend_mode = blend_mode}.texture, {halign = "right", valign = "top", color = color, rotation = 90, name = "right_top", blend_mode = blend_mode}.layer, {halign = "right", valign = "top", color = color, rotation = 90, name = "right_top", blend_mode = blend_mode}.visible = 0, 0, "guis/textures/pd2/hud_corner", 0, true
   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

  local right_bottom = box_panel:bitmap({halign = "right", valign = "bottom", color = color, rotation = 180, name = "right_bottom", blend_mode = blend_mode})
  right_bottom:set_right(box_panel:w())
  {halign = "right", valign = "bottom", color = color, rotation = 180, name = "right_bottom", blend_mode = blend_mode}.y, {halign = "right", valign = "bottom", color = color, rotation = 180, name = "right_bottom", blend_mode = blend_mode}.x, {halign = "right", valign = "bottom", color = color, rotation = 180, name = "right_bottom", blend_mode = blend_mode}.texture, {halign = "right", valign = "bottom", color = color, rotation = 180, name = "right_bottom", blend_mode = blend_mode}.layer, {halign = "right", valign = "bottom", color = color, rotation = 180, name = "right_bottom", blend_mode = blend_mode}.visible = 0, 0, "guis/textures/pd2/hud_corner", 0, true
  right_bottom:set_bottom(box_panel:h())
  return box_panel
end

local box_speed = 1000
HUDBGBox_animate_open_right = function(l_2_0, l_2_1, l_2_2, l_2_3)
  l_2_0:set_visible(false)
  l_2_0:set_w(0)
  if l_2_1 then
    wait(l_2_1)
  end
  l_2_0:set_visible(true)
  local speed = box_speed
  local bg = l_2_0:child("bg")
  bg:stop()
  bg:animate(callback(nil, _G, "HUDBGBox_animate_bg_attention"))
  local TOTAL_T = l_2_2 / speed
  do
    local t = TOTAL_T
    repeat
      if t > 0 then
        local dt = coroutine.yield()
        t = t - dt
        l_2_0:set_w((1 - (t) / TOTAL_T) * l_2_2)
      else
        l_2_0:set_w(l_2_2)
        l_2_3()
      end
       -- Warning: missing end command somewhere! Added here
    end
     -- Warning: missing end command somewhere! Added here
  end
end

HUDBGBox_animate_close_right = function(l_3_0, l_3_1)
  local speed = box_speed
  local cw = l_3_0:w()
  local TOTAL_T = cw / speed
  do
    local t = TOTAL_T
    repeat
      if t > 0 then
        local dt = coroutine.yield()
        t = t - dt
        l_3_0:set_w((t) / TOTAL_T * cw)
      else
        l_3_0:set_w(0)
        l_3_1()
      end
       -- Warning: missing end command somewhere! Added here
    end
     -- Warning: missing end command somewhere! Added here
  end
end

HUDBGBox_animate_open_left = function(l_4_0, l_4_1, l_4_2, l_4_3, l_4_4)
  if not l_4_4 then
    l_4_4 = {}
  end
  l_4_0:set_visible(false)
  local right = l_4_0:right()
  l_4_0:set_w(0)
  l_4_0:set_right(right)
  if l_4_1 then
    wait(l_4_1)
  end
  l_4_0:set_visible(true)
  local speed = box_speed
  local bg = l_4_0:child("bg")
  bg:stop()
  bg:animate(callback(nil, _G, "HUDBGBox_animate_bg_attention"), {color = l_4_4.attention_color, forever = l_4_4.attention_forever})
  local TOTAL_T = l_4_2 / speed
  do
    local t = TOTAL_T
    repeat
      if t > 0 then
        local dt = coroutine.yield()
        t = t - dt
        l_4_0:set_w((1 - (t) / TOTAL_T) * l_4_2)
        l_4_0:set_right(right)
      else
        l_4_0:set_w(l_4_2)
        l_4_0:set_right(right)
        l_4_3()
      end
       -- Warning: missing end command somewhere! Added here
    end
     -- Warning: missing end command somewhere! Added here
  end
end

HUDBGBox_animate_close_left = function(l_5_0, l_5_1)
  local speed = box_speed
  local cw = l_5_0:w()
  local right = l_5_0:right()
  local TOTAL_T = cw / speed
  do
    local t = TOTAL_T
    repeat
      if t > 0 then
        local dt = coroutine.yield()
        t = t - dt
        l_5_0:set_w((t) / TOTAL_T * cw)
        l_5_0:set_right(right)
      else
        l_5_0:set_w(0)
        l_5_0:set_right(right)
        l_5_1()
      end
       -- Warning: missing end command somewhere! Added here
    end
     -- Warning: missing end command somewhere! Added here
  end
end

HUDBGBox_animate_open_center = function(l_6_0, l_6_1, l_6_2, l_6_3, l_6_4)
  if not l_6_4 then
    l_6_4 = {}
  end
  l_6_0:set_visible(false)
  local center_x = l_6_0:center_x()
  l_6_0:set_w(0)
  if l_6_1 then
    wait(l_6_1)
  end
  l_6_0:set_visible(true)
  local speed = box_speed
  local bg = l_6_0:child("bg")
  bg:stop()
  bg:animate(callback(nil, _G, "HUDBGBox_animate_bg_attention"), {color = l_6_4.attention_color, forever = l_6_4.attention_forever})
  local TOTAL_T = l_6_2 / speed
  local t = TOTAL_T
  repeat
    if t > 0 then
      local dt = coroutine.yield()
      t = t - dt
      l_6_0:set_w((1 - (t) / TOTAL_T) * l_6_2)
      l_6_0:set_center_x(center_x)
    else
      l_6_0:set_w(l_6_2)
      l_6_0:set_center_x(center_x)
      if l_6_3 then
        l_6_3()
      end
       -- Warning: missing end command somewhere! Added here
    end
     -- Warning: missing end command somewhere! Added here
  end
end

HUDBGBox_animate_close_center = function(l_7_0, l_7_1)
  local center_x = l_7_0:center_x()
  local cw = l_7_0:w()
  local speed = box_speed
  local TOTAL_T = cw / speed
  local t = TOTAL_T
  repeat
    if t > 0 then
      local dt = coroutine.yield()
      t = t - dt
      l_7_0:set_w((t) / TOTAL_T * cw)
      l_7_0:set_center_x(center_x)
    else
      l_7_0:set_w(0)
      l_7_0:set_center_x(center_x)
      if l_7_1 then
        l_7_1()
      end
       -- Warning: missing end command somewhere! Added here
    end
     -- Warning: missing end command somewhere! Added here
  end
end

HUDBGBox_animate_bg_attention = function(l_8_0, l_8_1)
  if not l_8_1 or not l_8_1.color then
    local color = Color.white
  end
  local forever = l_8_1 and l_8_1.forever or false
  local TOTAL_T = 3
  do
    local t = TOTAL_T
    repeat
      if t > 0 or forever then
        local dt = coroutine.yield()
        t = t - dt
        local cv = math.abs(math.sin((t) * 180 * 1))
        l_8_0:set_color(Color(1, color.red * cv, color.green * cv, color.blue * cv))
      else
        l_8_0:set_color(Color(1, 0, 0, 0))
      end
       -- Warning: missing end command somewhere! Added here
    end
     -- Warning: missing end command somewhere! Added here
  end
end

if not HUDObjectives then
  HUDObjectives = class()
end
HUDObjectives.init = function(l_9_0, l_9_1)
  l_9_0._hud_panel = l_9_1.panel
  if l_9_0._hud_panel:child("objectives_panel") then
    l_9_0._hud_panel:remove(l_9_0._hud_panel:child("objectives_panel"))
  end
  local objectives_panel = l_9_0._hud_panel:panel({visible = false, name = "objectives_panel", x = 0, y = 0, h = 100, w = 500, valign = "top"})
   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

  local icon_objectivebox = objectives_panel:bitmap({halign = "left", valign = "top", name = "icon_objectivebox", blend_mode = "normal", visible = true, layer = 0})
  l_9_0._bg_box, {halign = "left", valign = "top", name = "icon_objectivebox", blend_mode = "normal", visible = true, layer = 0}.h, {halign = "left", valign = "top", name = "icon_objectivebox", blend_mode = "normal", visible = true, layer = 0}.w, {halign = "left", valign = "top", name = "icon_objectivebox", blend_mode = "normal", visible = true, layer = 0}.y, {halign = "left", valign = "top", name = "icon_objectivebox", blend_mode = "normal", visible = true, layer = 0}.x, {halign = "left", valign = "top", name = "icon_objectivebox", blend_mode = "normal", visible = true, layer = 0}.texture = HUDBGBox_create(objectives_panel, {w = 200, h = 38, x = 26, y = 0}), 24, 24, 0, 0, "guis/textures/pd2/hud_icon_objectivebox"
   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

  local objective_text = objectives_panel:text({name = "objective_text", visible = false, layer = 2, color = Color.white, text = "", font_size = tweak_data.hud.active_objective_title_font_size})
  objective_text:set_x(l_9_0._bg_box:x() + 8)
  {name = "objective_text", visible = false, layer = 2, color = Color.white, text = "", font_size = tweak_data.hud.active_objective_title_font_size}.vertical, {name = "objective_text", visible = false, layer = 2, color = Color.white, text = "", font_size = tweak_data.hud.active_objective_title_font_size}.align, {name = "objective_text", visible = false, layer = 2, color = Color.white, text = "", font_size = tweak_data.hud.active_objective_title_font_size}.y, {name = "objective_text", visible = false, layer = 2, color = Color.white, text = "", font_size = tweak_data.hud.active_objective_title_font_size}.x, {name = "objective_text", visible = false, layer = 2, color = Color.white, text = "", font_size = tweak_data.hud.active_objective_title_font_size}.font = "top", "left", 8, 0, tweak_data.hud.medium_font_noshadow
  objective_text:set_y(6)
   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

  local amount_text = objectives_panel:text({name = "amount_text", visible = true, layer = 2, color = Color.white, text = "1/4", font_size = tweak_data.hud.active_objective_title_font_size})
  amount_text:set_x(objective_text:x())
  {name = "amount_text", visible = true, layer = 2, color = Color.white, text = "1/4", font_size = tweak_data.hud.active_objective_title_font_size}.vertical, {name = "amount_text", visible = true, layer = 2, color = Color.white, text = "1/4", font_size = tweak_data.hud.active_objective_title_font_size}.align, {name = "amount_text", visible = true, layer = 2, color = Color.white, text = "1/4", font_size = tweak_data.hud.active_objective_title_font_size}.y, {name = "amount_text", visible = true, layer = 2, color = Color.white, text = "1/4", font_size = tweak_data.hud.active_objective_title_font_size}.x, {name = "amount_text", visible = true, layer = 2, color = Color.white, text = "1/4", font_size = tweak_data.hud.active_objective_title_font_size}.font = "top", "left", 0, 6, tweak_data.hud.medium_font_noshadow
  amount_text:set_y(objective_text:y() + objective_text:font_size() - 2)
end

HUDObjectives.activate_objective = function(l_10_0, l_10_1)
  l_10_0._active_objective_id = l_10_1.id
  local objectives_panel = l_10_0._hud_panel:child("objectives_panel")
  local objective_text = objectives_panel:child("objective_text")
  objective_text:set_text(utf8.to_upper(l_10_1.text))
  local _, _, w, _ = objective_text:text_rect()
  objectives_panel:set_visible(true)
  l_10_0._bg_box:set_h(l_10_1.amount and 60 or 38)
  objective_text:set_visible(false)
  l_10_0._bg_box:stop()
   -- DECOMPILER ERROR: Confused while interpreting a jump as a 'while'

end
l_10_0._bg_box:animate(callback(nil, _G, "HUDBGBox_animate_open_right"), 0.66000002622604, w + 16, callback(l_10_0, l_10_0, "open_right_done", true))
objectives_panel:stop()
objectives_panel:animate(callback(l_10_0, l_10_0, "_animate_activate_objective"))
objectives_panel:child("amount_text"):set_visible(false)
if l_10_1.amount then
  l_10_0:update_amount_objective(l_10_1)
end
end

HUDObjectives.remind_objective = function(l_11_0, l_11_1)
  if l_11_1 ~= l_11_0._active_objective_id then
    return 
  end
  local objectives_panel = l_11_0._hud_panel:child("objectives_panel")
  objectives_panel:stop()
  objectives_panel:animate(callback(l_11_0, l_11_0, "_animate_activate_objective"))
  local bg = l_11_0._bg_box:child("bg")
  bg:stop()
  bg:animate(callback(nil, _G, "HUDBGBox_animate_bg_attention"))
end

HUDObjectives.complete_objective = function(l_12_0, l_12_1)
  if l_12_1.id ~= l_12_0._active_objective_id then
    return 
  end
  local objectives_panel = l_12_0._hud_panel:child("objectives_panel")
  objectives_panel:stop()
  objectives_panel:animate(callback(l_12_0, l_12_0, "_animate_complete_objective"))
end

HUDObjectives.update_amount_objective = function(l_13_0, l_13_1)
  if l_13_1.id ~= l_13_0._active_objective_id then
    return 
  end
  local current = l_13_1.current_amount or 0
  local amount = l_13_1.amount
  local objectives_panel = l_13_0._hud_panel:child("objectives_panel")
  objectives_panel:child("amount_text"):set_text(current .. "/" .. amount)
end

HUDObjectives.open_right_done = function(l_14_0, l_14_1)
  local objectives_panel = l_14_0._hud_panel:child("objectives_panel")
  local objective_text = objectives_panel:child("objective_text")
  local amount_text = objectives_panel:child("amount_text")
  amount_text:set_visible(l_14_1)
  objective_text:set_visible(true)
  objective_text:stop()
  objective_text:animate(callback(l_14_0, l_14_0, "_animate_show_text"), amount_text)
end

HUDObjectives._animate_show_text = function(l_15_0, l_15_1, l_15_2)
  local TOTAL_T = 0.5
  do
    local t = TOTAL_T
    repeat
      if t > 0 then
        local dt = coroutine.yield()
        t = t - dt
        local alpha = math.round(math.abs(math.sin((t) * 360 * 3)))
        l_15_1:set_alpha(alpha)
        l_15_2:set_alpha(alpha)
      else
        l_15_1:set_alpha(1)
        l_15_2:set_alpha(1)
      end
       -- Warning: missing end command somewhere! Added here
    end
     -- Warning: missing end command somewhere! Added here
  end
end

HUDObjectives._animate_complete_objective = function(l_16_0, l_16_1)
  local objective_text = l_16_1:child("objective_text")
  local amount_text = l_16_1:child("amount_text")
  local icon_objectivebox = l_16_1:child("icon_objectivebox")
  icon_objectivebox:set_y(0)
  local TOTAL_T = 0.5
  local t = TOTAL_T
  repeat
    if t > 0 then
      local dt = coroutine.yield()
      t = t - dt
      local vis = math.round(math.abs(math.cos((t) * 360 * 3)))
      objective_text:set_alpha(vis)
      amount_text:set_alpha(vis)
    else
      objective_text:set_alpha(1)
      amount_text:set_alpha(1)
      objective_text:set_visible(false)
      amount_text:set_visible(false)
      do
        local done_cb = function()
        objectives_panel:child("objective_text"):set_text(utf8.to_upper(""))
        objectives_panel:set_visible(false)
         end
        l_16_0._bg_box:stop()
        l_16_0._bg_box:animate(callback(nil, _G, "HUDBGBox_animate_close_right"), done_cb)
      end
       -- Warning: missing end command somewhere! Added here
    end
     -- Warning: missing end command somewhere! Added here
  end
end

HUDObjectives._animate_activate_objective = function(l_17_0, l_17_1)
  local icon_objectivebox = l_17_1:child("icon_objectivebox")
  icon_objectivebox:stop()
  icon_objectivebox:animate(callback(l_17_0, l_17_0, "_animate_icon_objectivebox"))
end

HUDObjectives._animate_icon_objectivebox = function(l_18_0, l_18_1)
  local TOTAL_T = 5
  do
    local t = TOTAL_T
    l_18_1:set_y(0)
    repeat
      if t > 0 then
        local dt = coroutine.yield()
        t = t - dt
        l_18_1:set_y(math.round((1 + math.sin((TOTAL_T - (t)) * 450 * 2)) * (12 * ((t) / TOTAL_T))))
      else
        l_18_1:set_y(0)
      end
       -- Warning: missing end command somewhere! Added here
    end
     -- Warning: missing end command somewhere! Added here
  end
end


