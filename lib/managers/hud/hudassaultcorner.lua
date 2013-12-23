-- Decompiled using luadec 2.0.1 by sztupy (http://winmo.sztupy.hu)
-- Command line was: F:\SteamLibrary\SteamApps\common\PAYDAY 2\lua\lib\managers\hud\hudassaultcorner.luac 

if not HUDAssaultCorner then
  HUDAssaultCorner = class()
end
HUDAssaultCorner.init = function(l_1_0, l_1_1, l_1_2)
  l_1_0._hud_panel = l_1_1.panel
  l_1_0._full_hud_panel = l_1_2.panel
  if l_1_0._hud_panel:child("assault_panel") then
    l_1_0._hud_panel:remove(l_1_0._hud_panel:child("assault_panel"))
  end
  local size = 200
  local assault_panel = l_1_0._hud_panel:panel({visible = false, name = "assault_panel", w = 400, h = 100})
  assault_panel:set_top(0)
  assault_panel:set_right(l_1_0._hud_panel:w())
  l_1_0._assault_color = Color(1, 1, 1, 0)
   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

  local icon_assaultbox = assault_panel:bitmap({halign = "right", valign = "top", color = Color.yellow, name = "icon_assaultbox", blend_mode = "add", visible = true, layer = 0, texture = "guis/textures/pd2/hud_icon_assaultbox"})
  icon_assaultbox:set_right(icon_assaultbox:parent():w())
  {halign = "right", valign = "top", color = Color.yellow, name = "icon_assaultbox", blend_mode = "add", visible = true, layer = 0, texture = "guis/textures/pd2/hud_icon_assaultbox"}.h, {halign = "right", valign = "top", color = Color.yellow, name = "icon_assaultbox", blend_mode = "add", visible = true, layer = 0, texture = "guis/textures/pd2/hud_icon_assaultbox"}.w, {halign = "right", valign = "top", color = Color.yellow, name = "icon_assaultbox", blend_mode = "add", visible = true, layer = 0, texture = "guis/textures/pd2/hud_icon_assaultbox"}.y, {halign = "right", valign = "top", color = Color.yellow, name = "icon_assaultbox", blend_mode = "add", visible = true, layer = 0, texture = "guis/textures/pd2/hud_icon_assaultbox"}.x = 24, 24, 0, 0
  l_1_0._bg_box = HUDBGBox_create(assault_panel, {w = 242, h = 38, x = 0, y = 0}, {color = l_1_0._assault_color, blend_mode = "add"})
  l_1_0._bg_box:set_right(icon_assaultbox:left() - 3)
  local yellow_tape = assault_panel:rect({visible = false, name = "yellow_tape", h = tweak_data.hud.location_font_size * 1.5, w = size * 3, color = Color(1, 0.80000001192093, 0), layer = 1})
  yellow_tape:set_center(10, 10)
  yellow_tape:set_rotation(30)
  yellow_tape:set_blend_mode("add")
  assault_panel:panel({name = "text_panel", layer = 1, w = yellow_tape:w()}):set_center(yellow_tape:center())
  if l_1_0._hud_panel:child("hostages_panel") then
    l_1_0._hud_panel:remove(l_1_0._hud_panel:child("hostages_panel"))
  end
  local hostages_panel = l_1_0._hud_panel:panel({name = "hostages_panel", w = size, h = size, x = l_1_0._hud_panel:w() - size})
  l_1_0._hostages_bg_box = HUDBGBox_create(hostages_panel, {w = 38, h = 38, x = 0, y = 0}, {})
  l_1_0._hostages_bg_box:set_right(hostages_panel:w())
   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

  local num_hostages = l_1_0._hostages_bg_box:text({name = "num_hostages", text = "0", valign = "center", align = "center", vertical = "center", w = l_1_0._hostages_bg_box:w(), h = l_1_0._hostages_bg_box:h(), layer = 1, x = 0, y = 0})
  local hostages_icon = hostages_panel:bitmap({name = "hostages_icon", texture = "guis/textures/pd2/hud_icon_hostage", valign = "top", layer = 1, x = 0, y = 0})
  hostages_icon:set_right(l_1_0._hostages_bg_box:left())
  {name = "num_hostages", text = "0", valign = "center", align = "center", vertical = "center", w = l_1_0._hostages_bg_box:w(), h = l_1_0._hostages_bg_box:h(), layer = 1, x = 0, y = 0}.font_size, {name = "num_hostages", text = "0", valign = "center", align = "center", vertical = "center", w = l_1_0._hostages_bg_box:w(), h = l_1_0._hostages_bg_box:h(), layer = 1, x = 0, y = 0}.font, {name = "num_hostages", text = "0", valign = "center", align = "center", vertical = "center", w = l_1_0._hostages_bg_box:w(), h = l_1_0._hostages_bg_box:h(), layer = 1, x = 0, y = 0}.color = tweak_data.hud_corner.numhostages_size, tweak_data.hud_corner.assault_font, Color.white
  hostages_icon:set_center_y(l_1_0._hostages_bg_box:h() / 2)
  if l_1_0._hud_panel:child("point_of_no_return_panel") then
    l_1_0._hud_panel:remove(l_1_0._hud_panel:child("point_of_no_return_panel"))
  end
  local size = 300
  local point_of_no_return_panel = l_1_0._hud_panel:panel({visible = false, name = "point_of_no_return_panel", w = size, h = 40, x = l_1_0._hud_panel:w() - size})
  l_1_0._noreturn_color = Color(1, 1, 0, 0)
   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

  local icon_noreturnbox = point_of_no_return_panel:bitmap({halign = "right", valign = "top", color = l_1_0._noreturn_color, name = "icon_noreturnbox", blend_mode = "add", visible = true, layer = 0, texture = "guis/textures/pd2/hud_icon_noreturnbox"})
  icon_noreturnbox:set_right(icon_noreturnbox:parent():w())
  {halign = "right", valign = "top", color = l_1_0._noreturn_color, name = "icon_noreturnbox", blend_mode = "add", visible = true, layer = 0, texture = "guis/textures/pd2/hud_icon_noreturnbox"}.h, {halign = "right", valign = "top", color = l_1_0._noreturn_color, name = "icon_noreturnbox", blend_mode = "add", visible = true, layer = 0, texture = "guis/textures/pd2/hud_icon_noreturnbox"}.w, {halign = "right", valign = "top", color = l_1_0._noreturn_color, name = "icon_noreturnbox", blend_mode = "add", visible = true, layer = 0, texture = "guis/textures/pd2/hud_icon_noreturnbox"}.y, {halign = "right", valign = "top", color = l_1_0._noreturn_color, name = "icon_noreturnbox", blend_mode = "add", visible = true, layer = 0, texture = "guis/textures/pd2/hud_icon_noreturnbox"}.x = 24, 24, 0, 0
  l_1_0._noreturn_bg_box = HUDBGBox_create(point_of_no_return_panel, {w = 242, h = 38, x = 0, y = 0}, {color = l_1_0._noreturn_color, blend_mode = "add"})
  l_1_0._noreturn_bg_box:set_right(icon_noreturnbox:left() - 3)
  local w = point_of_no_return_panel:w()
  local size = 200 - tweak_data.hud.location_font_size
   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

  local point_of_no_return_text = l_1_0._noreturn_bg_box:text({name = "point_of_no_return_text", text = "", blend_mode = "add", layer = 1, valign = "center", align = "right", vertical = "center", x = 0})
  point_of_no_return_text:set_text(utf8.to_upper(managers.localization:text("hud_assault_point_no_return_in", {time = ""})))
  {name = "point_of_no_return_text", text = "", blend_mode = "add", layer = 1, valign = "center", align = "right", vertical = "center", x = 0}.font, {name = "point_of_no_return_text", text = "", blend_mode = "add", layer = 1, valign = "center", align = "right", vertical = "center", x = 0}.font_size, {name = "point_of_no_return_text", text = "", blend_mode = "add", layer = 1, valign = "center", align = "right", vertical = "center", x = 0}.color, {name = "point_of_no_return_text", text = "", blend_mode = "add", layer = 1, valign = "center", align = "right", vertical = "center", x = 0}.y = tweak_data.hud_corner.assault_font, tweak_data.hud_corner.noreturn_size, l_1_0._noreturn_color, 0
  point_of_no_return_text:set_size(l_1_0._noreturn_bg_box:w(), l_1_0._noreturn_bg_box:h())
   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

  local point_of_no_return_timer = l_1_0._noreturn_bg_box:text({name = "point_of_no_return_timer", text = "", blend_mode = "add", layer = 1, valign = "center", align = "center", vertical = "center", x = 0})
  local _, _, w, h = point_of_no_return_timer:text_rect()
  point_of_no_return_timer:set_size(46, l_1_0._noreturn_bg_box:h())
  {name = "point_of_no_return_timer", text = "", blend_mode = "add", layer = 1, valign = "center", align = "center", vertical = "center", x = 0}.font, {name = "point_of_no_return_timer", text = "", blend_mode = "add", layer = 1, valign = "center", align = "center", vertical = "center", x = 0}.font_size, {name = "point_of_no_return_timer", text = "", blend_mode = "add", layer = 1, valign = "center", align = "center", vertical = "center", x = 0}.color, {name = "point_of_no_return_timer", text = "", blend_mode = "add", layer = 1, valign = "center", align = "center", vertical = "center", x = 0}.y = tweak_data.hud_corner.assault_font, tweak_data.hud_corner.noreturn_size, l_1_0._noreturn_color, 0
  point_of_no_return_timer:set_right(point_of_no_return_timer:parent():w())
  point_of_no_return_text:set_right(math.round(point_of_no_return_timer:left()))
  if l_1_0._hud_panel:child("casing_panel") then
    l_1_0._hud_panel:remove(l_1_0._hud_panel:child("casing_panel"))
  end
  local size = 300
  local casing_panel = l_1_0._hud_panel:panel({visible = false, name = "casing_panel", w = size, h = 40, x = l_1_0._hud_panel:w() - size})
  l_1_0._casing_color = Color.white
   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

  local icon_casingbox = casing_panel:bitmap({halign = "right", valign = "top", color = l_1_0._casing_color, name = "icon_casingbox", blend_mode = "add", visible = true, layer = 0, texture = "guis/textures/pd2/hud_icon_stealthbox"})
  icon_casingbox:set_right(icon_casingbox:parent():w())
  {halign = "right", valign = "top", color = l_1_0._casing_color, name = "icon_casingbox", blend_mode = "add", visible = true, layer = 0, texture = "guis/textures/pd2/hud_icon_stealthbox"}.h, {halign = "right", valign = "top", color = l_1_0._casing_color, name = "icon_casingbox", blend_mode = "add", visible = true, layer = 0, texture = "guis/textures/pd2/hud_icon_stealthbox"}.w, {halign = "right", valign = "top", color = l_1_0._casing_color, name = "icon_casingbox", blend_mode = "add", visible = true, layer = 0, texture = "guis/textures/pd2/hud_icon_stealthbox"}.y, {halign = "right", valign = "top", color = l_1_0._casing_color, name = "icon_casingbox", blend_mode = "add", visible = true, layer = 0, texture = "guis/textures/pd2/hud_icon_stealthbox"}.x = 24, 24, 0, 0
  l_1_0._casing_bg_box = HUDBGBox_create(casing_panel, {w = 242, h = 38, x = 0, y = 0}, {color = l_1_0._casing_color, blend_mode = "add"})
  l_1_0._casing_bg_box:set_right(icon_casingbox:left() - 3)
  local w = casing_panel:w()
  local size = 200 - tweak_data.hud.location_font_size
  casing_panel:panel({name = "text_panel", layer = 1, w = yellow_tape:w()}):set_center(yellow_tape:center())
end

HUDAssaultCorner._animate_assault = function(l_2_0, l_2_1)
  local assault_panel = l_2_0._hud_panel:child("assault_panel")
  local icon_assaultbox = assault_panel:child("icon_assaultbox")
  icon_assaultbox:stop()
  icon_assaultbox:animate(callback(l_2_0, l_2_0, "_show_icon_assaultbox"))
  l_2_0._bg_box:animate(callback(nil, _G, "HUDBGBox_animate_open_left"), 0.75, 242, function()
   end, {attention_color = l_2_0._assault_color, attention_forever = true})
  local text_panel = l_2_0._bg_box:child("text_panel")
  text_panel:stop()
  text_panel:animate(callback(l_2_0, l_2_0, "_animate_text"))
end

HUDAssaultCorner._animate_text = function(l_3_0, l_3_1, l_3_2, l_3_3)
   -- DECOMPILER ERROR: Confused while interpreting a jump as a 'while'

end
local text_list = l_3_0._bg_box:script().text_list
local text_index = 0
local texts = {}
local padding = 10
local create_new_text = function(l_1_0, l_1_1, l_1_2, l_1_3)
  if l_1_3[l_1_2] and l_1_3[l_1_2].text then
    l_1_0:remove(l_1_3[l_1_2].text)
    l_1_3[l_1_2] = nil
  end
   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused while interpreting a jump as a 'while'

end
local text = l_1_0:text({text = utf8.to_upper(managers.localization:text(l_1_1[l_1_2])), layer = 1, align = "center", vertical = "center"})
local _, _, w, h = text:text_rect()
text:set_size(w, h)
{text = utf8.to_upper(managers.localization:text(l_1_1[l_1_2])), layer = 1, align = "center", vertical = "center"}.h, {text = utf8.to_upper(managers.localization:text(l_1_1[l_1_2])), layer = 1, align = "center", vertical = "center"}.w, {text = utf8.to_upper(managers.localization:text(l_1_1[l_1_2])), layer = 1, align = "center", vertical = "center"}.font, {text = utf8.to_upper(managers.localization:text(l_1_1[l_1_2])), layer = 1, align = "center", vertical = "center"}.font_size, {text = utf8.to_upper(managers.localization:text(l_1_1[l_1_2])), layer = 1, align = "center", vertical = "center"}.color, {text = utf8.to_upper(managers.localization:text(l_1_1[l_1_2])), layer = 1, align = "center", vertical = "center"}.blend_mode = 10, 10, tweak_data.hud_corner.assault_font, tweak_data.hud_corner.assault_size, self._assault_color, "add"
l_1_3[l_1_2] = {x = l_1_0:w() + w * 0.5 + padding * 2, text = text}
end

repeat
  local dt = coroutine.yield()
  local last_text = texts[text_index]
   -- DECOMPILER ERROR: unhandled construct in 'if'

  if last_text and last_text.text and last_text.x + last_text.text:w() * 0.5 + padding < l_3_1:w() then
    text_index = text_index % #text_list + 1
    create_new_text(l_3_1, text_list, text_index, texts)
    do return end
    text_index = (text_index) % #text_list + 1
    create_new_text(l_3_1, text_list, text_index, texts)
  end
  do
    local speed = 90
    for i,data in pairs(texts) do
      if data.text then
        data.x = data.x - dt * speed
        data.text:set_center_x(data.x)
        data.text:set_center_y(l_3_1:h() * 0.5)
        if data.x + data.text:w() * 0.5 < 0 then
          l_3_1:remove(data.text)
          data.text = nil
        end
      end
    end
  end
  do return end
end

HUDAssaultCorner.sync_start_assault = function(l_4_0, l_4_1)
  if l_4_0._point_of_no_return then
    return 
  end
  l_4_0:_hide_hostages()
  l_4_0:_start_assault({"hud_assault_assault", "hud_assault_end_line", "hud_assault_assault", "hud_assault_end_line", "hud_assault_assault", "hud_assault_end_line"})
end

HUDAssaultCorner.sync_end_assault = function(l_5_0, l_5_1)
  if l_5_0._point_of_no_return then
    return 
  end
  l_5_0:_end_assault()
end

HUDAssaultCorner._start_assault = function(l_6_0, l_6_1)
  if not l_6_1 then
    l_6_1 = {""}
  end
  local assault_panel = l_6_0._hud_panel:child("assault_panel")
  local text_panel = assault_panel:child("text_panel")
  text_panel:script().text_list = {}
  l_6_0._bg_box:script().text_list = {}
  for _,text_id in ipairs(l_6_1) do
    table.insert(text_panel:script().text_list, text_id)
    table.insert(l_6_0._bg_box:script().text_list, text_id)
  end
  l_6_0._assault = true
  if l_6_0._bg_box:child("text_panel") then
    l_6_0._bg_box:child("text_panel"):stop()
    l_6_0._bg_box:child("text_panel"):clear()
  else
    l_6_0._bg_box:panel({name = "text_panel"})
  end
  l_6_0._bg_box:child("bg"):stop()
  l_6_0._bg_box:stop()
  assault_panel:set_visible(true)
  l_6_0._bg_box:animate(callback(l_6_0, l_6_0, "_animate_assault"))
end

HUDAssaultCorner._end_assault = function(l_7_0)
  if not l_7_0._assault then
    return 
  end
  l_7_0._assault = false
  l_7_0._bg_box:child("text_panel"):stop()
  l_7_0._bg_box:child("text_panel"):clear()
  local close_done = function()
    self._bg_box:set_visible(false)
    local icon_assaultbox = self._hud_panel:child("assault_panel"):child("icon_assaultbox")
    icon_assaultbox:stop()
    icon_assaultbox:animate(callback(self, self, "_hide_icon_assaultbox"))
   end
  l_7_0._bg_box:stop()
  l_7_0._bg_box:animate(callback(nil, _G, "HUDBGBox_animate_close_left"), close_done)
end

HUDAssaultCorner._show_icon_assaultbox = function(l_8_0, l_8_1)
  local TOTAL_T = 2
  do
    local t = TOTAL_T
    repeat
      if t > 0 then
        local dt = coroutine.yield()
        t = t - dt
        local alpha = math.round(math.abs(math.sin((t) * 360 * 2)))
        l_8_1:set_alpha(alpha)
      else
        l_8_1:set_alpha(1)
      end
       -- Warning: missing end command somewhere! Added here
    end
     -- Warning: missing end command somewhere! Added here
  end
end

HUDAssaultCorner._hide_icon_assaultbox = function(l_9_0, l_9_1)
  local TOTAL_T = 1
  do
    local t = TOTAL_T
    repeat
      if t > 0 then
        local dt = coroutine.yield()
        t = t - dt
        local alpha = math.round(math.abs(math.cos((t) * 360 * 2)))
        l_9_1:set_alpha(alpha)
      else
        l_9_1:set_alpha(0)
        l_9_0:_show_hostages()
      end
       -- Warning: missing end command somewhere! Added here
    end
     -- Warning: missing end command somewhere! Added here
  end
end

HUDAssaultCorner._show_hostages = function(l_10_0)
  if not l_10_0._point_of_no_return then
    l_10_0._hud_panel:child("hostages_panel"):show()
  end
end

HUDAssaultCorner._hide_hostages = function(l_11_0)
  l_11_0._hud_panel:child("hostages_panel"):hide()
end

HUDAssaultCorner.set_control_info = function(l_12_0, l_12_1)
  l_12_0._hostages_bg_box:child("num_hostages"):set_text("" .. l_12_1.nr_hostages)
  local bg = l_12_0._hostages_bg_box:child("bg")
  bg:stop()
  bg:animate(callback(nil, _G, "HUDBGBox_animate_bg_attention"), {})
end

HUDAssaultCorner.feed_point_of_no_return_timer = function(l_13_0, l_13_1, l_13_2)
  l_13_1 = math.floor(l_13_1)
  local minutes = math.floor(l_13_1 / 60)
  local seconds = math.round(l_13_1 - minutes * 60)
  local text = (minutes < 10 and "0" .. minutes or minutes) .. ":" .. (seconds < 10 and "0" .. seconds or seconds)
  l_13_0._noreturn_bg_box:child("point_of_no_return_timer"):set_text(text)
end

HUDAssaultCorner.show_point_of_no_return_timer = function(l_14_0)
  local delay_time = l_14_0._assault and 1.2000000476837 or 0
  l_14_0:_end_assault()
  local point_of_no_return_panel = l_14_0._hud_panel:child("point_of_no_return_panel")
  l_14_0._hud_panel:child("hostages_panel"):set_visible(false)
  point_of_no_return_panel:stop()
  point_of_no_return_panel:animate(callback(l_14_0, l_14_0, "_animate_show_noreturn"), delay_time)
  l_14_0._point_of_no_return = true
end

HUDAssaultCorner.hide_point_of_no_return_timer = function(l_15_0)
  l_15_0._noreturn_bg_box:stop()
  l_15_0._hud_panel:child("point_of_no_return_panel"):set_visible(false)
  l_15_0._hud_panel:child("hostages_panel"):set_visible(true)
  l_15_0._point_of_no_return = false
end

HUDAssaultCorner.flash_point_of_no_return_timer = function(l_16_0, l_16_1)
  local flash_timer = function(l_1_0)
    local t = 0
    repeat
      if t < 0.5 then
        t = t + coroutine.yield()
        local n = 1 - math.sin((t) * 180)
         -- DECOMPILER ERROR: Confused while interpreting a jump as a 'while'

      end
      local r = math.lerp(self._point_of_no_return_color.r, 1, n)
       -- DECOMPILER ERROR: Confused while interpreting a jump as a 'while'

    end
    local g = math.lerp(self._point_of_no_return_color.g, 0.80000001192093, n)
     -- DECOMPILER ERROR: Confused while interpreting a jump as a 'while'

  end
  local b = math.lerp(self._point_of_no_return_color.b, 0.20000000298023, n)
  l_1_0:set_color(Color(r, g, b))
  l_1_0:set_font_size(math.lerp(tweak_data.hud_corner.noreturn_size, tweak_data.hud_corner.noreturn_size * 1.25, n))
else
   end
  local point_of_no_return_timer = l_16_0._noreturn_bg_box:child("point_of_no_return_timer")
  point_of_no_return_timer:animate(flash_timer)
end

HUDAssaultCorner.show_casing = function(l_17_0)
  local delay_time = l_17_0._assault and 1.2000000476837 or 0
  l_17_0:_end_assault()
  local casing_panel = l_17_0._hud_panel:child("casing_panel")
  local text_panel = casing_panel:child("text_panel")
  text_panel:script().text_list = {}
  l_17_0._casing_bg_box:script().text_list = {}
  for _,text_id in ipairs({"hud_casing_mode_ticker", "hud_assault_end_line", "hud_casing_mode_ticker", "hud_assault_end_line"}) do
    table.insert(text_panel:script().text_list, text_id)
    table.insert(l_17_0._casing_bg_box:script().text_list, text_id)
  end
  if l_17_0._casing_bg_box:child("text_panel") then
    l_17_0._casing_bg_box:child("text_panel"):stop()
    l_17_0._casing_bg_box:child("text_panel"):clear()
  else
    l_17_0._casing_bg_box:panel({name = "text_panel"})
  end
  l_17_0._casing_bg_box:child("bg"):stop()
  l_17_0._hud_panel:child("hostages_panel"):set_visible(false)
  casing_panel:stop()
  casing_panel:animate(callback(l_17_0, l_17_0, "_animate_show_casing"), delay_time)
  l_17_0._casing = true
end

HUDAssaultCorner.hide_casing = function(l_18_0)
  if l_18_0._casing_bg_box:child("text_panel") then
    l_18_0._casing_bg_box:child("text_panel"):stop()
    l_18_0._casing_bg_box:child("text_panel"):clear()
  end
  local icon_casingbox = l_18_0._hud_panel:child("casing_panel"):child("icon_casingbox")
  icon_casingbox:stop()
  local close_done = function()
    self._casing_bg_box:set_visible(false)
    local icon_casingbox = self._hud_panel:child("casing_panel"):child("icon_casingbox")
    icon_casingbox:stop()
    icon_casingbox:animate(callback(self, self, "_hide_icon_assaultbox"))
   end
  l_18_0._casing_bg_box:stop()
  l_18_0._casing_bg_box:animate(callback(nil, _G, "HUDBGBox_animate_close_left"), close_done)
  l_18_0._casing = false
end

HUDAssaultCorner._animate_simple_text = function(l_19_0, l_19_1)
  local _, _, w, _ = l_19_1:text_rect()
  l_19_1:set_w(w + 10)
  l_19_1:set_visible(true)
  l_19_1:set_x(l_19_1:parent():w())
  local x = l_19_1:x()
  local t = 0
  do
    local speed = 90
    repeat
      repeat
        do
          local dt = coroutine.yield()
          t = t + dt
          x = x - speed * dt
          l_19_1:set_x(x)
        until l_19_1:right() < 0
        l_19_1:set_x(l_19_1:parent():w())
        x = l_19_1:x()
      end
      do return end
    end
     -- Warning: missing end command somewhere! Added here
  end
end

HUDAssaultCorner._animate_show_casing = function(l_20_0, l_20_1, l_20_2)
  local icon_casingbox = l_20_1:child("icon_casingbox")
  wait(l_20_2)
  l_20_1:set_visible(true)
  icon_casingbox:stop()
  icon_casingbox:animate(callback(l_20_0, l_20_0, "_show_icon_assaultbox"))
  local open_done = function()
   end
  l_20_0._casing_bg_box:stop()
  l_20_0._casing_bg_box:animate(callback(nil, _G, "HUDBGBox_animate_open_left"), 0.75, 242, open_done, {attention_color = l_20_0._casing_color, attention_forever = true})
  local text_panel = l_20_0._casing_bg_box:child("text_panel")
  text_panel:stop()
  text_panel:animate(callback(l_20_0, l_20_0, "_animate_text"), l_20_0._casing_bg_box, Color.white)
end

HUDAssaultCorner._animate_show_noreturn = function(l_21_0, l_21_1, l_21_2)
  local icon_noreturnbox = l_21_1:child("icon_noreturnbox")
  local point_of_no_return_text = l_21_0._noreturn_bg_box:child("point_of_no_return_text")
  point_of_no_return_text:set_visible(false)
  local point_of_no_return_timer = l_21_0._noreturn_bg_box:child("point_of_no_return_timer")
  point_of_no_return_timer:set_visible(false)
  wait(l_21_2)
  l_21_1:set_visible(true)
  icon_noreturnbox:stop()
  icon_noreturnbox:animate(callback(l_21_0, l_21_0, "_show_icon_assaultbox"))
  local open_done = function()
    point_of_no_return_text:animate(callback(self, self, "_animate_show_texts"), {point_of_no_return_text, point_of_no_return_timer})
   end
  l_21_0._noreturn_bg_box:stop()
  l_21_0._noreturn_bg_box:animate(callback(nil, _G, "HUDBGBox_animate_open_left"), 0.75, 242, open_done, {attention_color = l_21_0._casing_color, attention_forever = true})
end

HUDAssaultCorner._animate_show_texts = function(l_22_0, l_22_1, l_22_2)
  for _,text in ipairs(l_22_2) do
    text:set_visible(true)
  end
  local TOTAL_T = 0.5
  do
    local t = TOTAL_T
    repeat
      if t > 0 then
        local dt = coroutine.yield()
        t = t - dt
        local alpha = math.round(math.abs(math.sin((t) * 360 * 3)))
        for _,text in ipairs(l_22_2) do
          text:set_alpha(alpha)
        end
      else
        for _,text in ipairs(l_22_2) do
          text:set_alpha(1)
        end
      end
       -- Warning: missing end command somewhere! Added here
    end
     -- Warning: missing end command somewhere! Added here
  end
end

HUDAssaultCorner.test = function(l_23_0)
  l_23_0._hud_panel:child("point_of_no_return_panel"):animate(callback(l_23_0, l_23_0, "_animate_test_point_of_no_return"))
end

HUDAssaultCorner._animate_test_point_of_no_return = function(l_24_0, l_24_1)
  managers.hud:show_point_of_no_return_timer()
  local t = 15
  do
    local prev_time = t
    repeat
      if t > 0 then
        local dt = coroutine.yield()
        t = t - dt
        local sec = math.floor(t)
        if sec < math.floor(prev_time) then
          prev_time = sec
          managers.hud:flash_point_of_no_return_timer(sec <= 10)
        end
        managers.hud:feed_point_of_no_return_timer(math.max(t, 0), false)
      else
        managers.hud:hide_point_of_no_return_timer()
      end
       -- Warning: missing end command somewhere! Added here
    end
     -- Warning: missing end command somewhere! Added here
  end
end


