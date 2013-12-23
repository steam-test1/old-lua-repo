-- Decompiled using luadec 2.0.1 by sztupy (http://winmo.sztupy.hu)
-- Command line was: F:\SteamLibrary\SteamApps\common\PAYDAY 2\lua\lib\managers\hud\hudinteraction.luac 

if not HUDInteraction then
  HUDInteraction = class()
end
HUDInteraction.init = function(l_1_0, l_1_1, l_1_2)
  l_1_0._hud_panel = l_1_1.panel
  l_1_0._circle_radius = 64
  l_1_0._sides = 64
  l_1_0._child_name_text = (l_1_2 or "interact") .. "_text"
  l_1_0._child_ivalid_name_text = (l_1_2 or "interact") .. "_invalid_text"
  if l_1_0._hud_panel:child(l_1_0._child_name_text) then
    l_1_0._hud_panel:remove(l_1_0._hud_panel:child(l_1_0._child_name_text))
  end
  if l_1_0._hud_panel:child(l_1_0._child_ivalid_name_text) then
    l_1_0._hud_panel:remove(l_1_0._hud_panel:child(l_1_0._child_ivalid_name_text))
  end
   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

  local interact_text = l_1_0._hud_panel:text({name = l_1_0._child_name_text, visible = false, text = "HELLO", valign = "center"})
   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

  local invalid_text = l_1_0._hud_panel:text({name = l_1_0._child_ivalid_name_text, visible = false, text = "HELLO", valign = "center", align = "center", layer = 3})
  interact_text:set_y(l_1_0._hud_panel:h() / 2 + 64 + 16)
  {name = l_1_0._child_ivalid_name_text, visible = false, text = "HELLO", valign = "center", align = "center", layer = 3}.h, {name = l_1_0._child_ivalid_name_text, visible = false, text = "HELLO", valign = "center", align = "center", layer = 3}.font_size, {name = l_1_0._child_ivalid_name_text, visible = false, text = "HELLO", valign = "center", align = "center", layer = 3}.font, {name = l_1_0._child_ivalid_name_text, visible = false, text = "HELLO", valign = "center", align = "center", layer = 3}.blend_mode, {name = l_1_0._child_ivalid_name_text, visible = false, text = "HELLO", valign = "center", align = "center", layer = 3}.color, {name = l_1_0._child_name_text, visible = false, text = "HELLO", valign = "center"}.h, {name = l_1_0._child_name_text, visible = false, text = "HELLO", valign = "center"}.font_size, {name = l_1_0._child_name_text, visible = false, text = "HELLO", valign = "center"}.font, {name = l_1_0._child_name_text, visible = false, text = "HELLO", valign = "center"}.color, {name = l_1_0._child_name_text, visible = false, text = "HELLO", valign = "center"}.layer, {name = l_1_0._child_name_text, visible = false, text = "HELLO", valign = "center"}.align = 64, tweak_data.hud_present.text_size, tweak_data.hud_present.text_font, "normal", Color(1, 0.30000001192093, 0.30000001192093), 64, tweak_data.hud_present.text_size, tweak_data.hud_present.text_font, Color.white, 1, "center"
  invalid_text:set_center_y(interact_text:center_y())
end

HUDInteraction.show_interact = function(l_2_0, l_2_1)
  l_2_0:remove_interact()
  local text = utf8.to_upper(l_2_1.text or "Press 'F' to interact")
  l_2_0._hud_panel:child(l_2_0._child_name_text):set_visible(true)
  l_2_0._hud_panel:child(l_2_0._child_name_text):set_text(text)
end

HUDInteraction.remove_interact = function(l_3_0)
  if not alive(l_3_0._hud_panel) then
    return 
  end
  l_3_0._hud_panel:child(l_3_0._child_name_text):set_visible(false)
  l_3_0._hud_panel:child(l_3_0._child_ivalid_name_text):set_visible(false)
end

HUDInteraction.show_interaction_bar = function(l_4_0, l_4_1, l_4_2)
  if l_4_0._interact_circle then
    l_4_0._interact_circle:remove()
    l_4_0._interact_circle = nil
  end
  l_4_0._interact_circle = CircleBitmapGuiObject:new(l_4_0._hud_panel, {use_bg = true, radius = l_4_0._circle_radius, sides = l_4_0._sides, current = l_4_0._sides, total = l_4_0._sides, color = Color.white:with_alpha(1), blend_mode = "add", layer = 2})
  l_4_0._interact_circle:set_position(l_4_0._hud_panel:w() / 2 - l_4_0._circle_radius, l_4_0._hud_panel:h() / 2 - l_4_0._circle_radius)
end

HUDInteraction.set_interaction_bar_width = function(l_5_0, l_5_1, l_5_2)
  if not l_5_0._interact_circle then
    return 
  end
  l_5_0._interact_circle:set_current(l_5_1 / l_5_2)
end

HUDInteraction.hide_interaction_bar = function(l_6_0, l_6_1)
  if l_6_1 then
    local bitmap = l_6_0._hud_panel:bitmap({texture = "guis/textures/pd2/hud_progress_active", blend_mode = "add", align = "center", valign = "center", layer = 2})
    bitmap:set_position(bitmap:parent():w() / 2 - bitmap:w() / 2, bitmap:parent():h() / 2 - bitmap:h() / 2)
    local radius = 64
    local circle = CircleBitmapGuiObject:new(l_6_0._hud_panel, {radius = radius, sides = 64, current = 64, total = 64, color = Color.white:with_alpha(1), blend_mode = "normal", layer = 3})
    circle:set_position(l_6_0._hud_panel:w() / 2 - radius, l_6_0._hud_panel:h() / 2 - radius)
    bitmap:animate(callback(l_6_0, l_6_0, "_animate_interaction_complete"), circle)
  end
  if l_6_0._interact_circle then
    l_6_0._interact_circle:remove()
    l_6_0._interact_circle = nil
  end
end

HUDInteraction.set_bar_valid = function(l_7_0, l_7_1, l_7_2)
  local texture = l_7_1 and "guis/textures/pd2/hud_progress_active" or "guis/textures/pd2/hud_progress_invalid"
  l_7_0._interact_circle:set_image(texture)
  l_7_0._hud_panel:child(l_7_0._child_name_text):set_visible(l_7_1)
  local invalid_text = l_7_0._hud_panel:child(l_7_0._child_ivalid_name_text)
  if l_7_2 then
    invalid_text:set_text(managers.localization:to_upper_text(l_7_2))
  end
  invalid_text:set_visible(not l_7_1)
end

HUDInteraction.destroy = function(l_8_0)
  l_8_0._hud_panel:remove(l_8_0._hud_panel:child(l_8_0._child_name_text))
  l_8_0._hud_panel:remove(l_8_0._hud_panel:child(l_8_0._child_ivalid_name_text))
  if l_8_0._interact_circle then
    l_8_0._interact_circle:remove()
    l_8_0._interact_circle = nil
  end
end

HUDInteraction._animate_interaction_complete = function(l_9_0, l_9_1, l_9_2)
  local TOTAL_T = 0.60000002384186
  local t = TOTAL_T
  local mul = 1
  local c_x, c_y = l_9_1:center()
  do
    local size = l_9_1:w()
    repeat
      if t > 0 then
        local dt = coroutine.yield()
        t = t - dt
        mul = mul + dt * 0.75
        l_9_1:set_size(size * (mul), size * (mul))
        l_9_1:set_center(c_x, c_y)
        l_9_1:set_alpha(math.max((t) / TOTAL_T, 0))
        l_9_2._circle:set_size(size * (mul), size * (mul))
        l_9_2._circle:set_center(c_x, c_y)
        l_9_2:set_current(1 - (t) / TOTAL_T)
        l_9_2:set_alpha(math.max((t) / TOTAL_T, 0))
      else
        l_9_1:parent():remove(l_9_1)
        l_9_2:remove()
      end
       -- Warning: missing end command somewhere! Added here
    end
     -- Warning: missing end command somewhere! Added here
  end
end


