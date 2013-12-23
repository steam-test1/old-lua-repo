-- Decompiled using luadec 2.0.1 by sztupy (http://winmo.sztupy.hu)
-- Command line was: F:\SteamLibrary\SteamApps\common\PAYDAY 2\lua\lib\utils\lightloadingscreenguiscript.luac 

if not LightLoadingScreenGuiScript then
  LightLoadingScreenGuiScript = class()
end
LightLoadingScreenGuiScript.init = function(l_1_0, l_1_1, l_1_2, l_1_3, l_1_4, l_1_5)
  l_1_0._base_layer = l_1_4
  l_1_0._is_win32 = l_1_5
  l_1_0._scene_gui = l_1_1
  l_1_0._res = l_1_2
  l_1_0._ws = l_1_1:create_screen_workspace()
  l_1_0._safe_rect_pixels = l_1_0:get_safe_rect_pixels(l_1_2)
  l_1_0._saferect = l_1_0._scene_gui:create_screen_workspace()
  l_1_0:layout_saferect()
  local panel = l_1_0._ws:panel()
  l_1_0._panel = panel
  l_1_0._bg_gui = panel:rect({visible = true, color = Color.black, layer = l_1_4})
  l_1_0._saferect_panel = l_1_0._saferect:panel()
  l_1_0._gui_tweak_data = {}
  l_1_0._gui_tweak_data.upper_saferect_border = 64
  l_1_0._gui_tweak_data.border_pad = 8
   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

  l_1_0._title_text, {y = 0, text_id = "debug_loading_level", font = "fonts/font_medium_shadow_mf", font_size = 32}.h, {y = 0, text_id = "debug_loading_level", font = "fonts/font_medium_shadow_mf", font_size = 32}.layer, {y = 0, text_id = "debug_loading_level", font = "fonts/font_medium_shadow_mf", font_size = 32}.vertical, {y = 0, text_id = "debug_loading_level", font = "fonts/font_medium_shadow_mf", font_size = 32}.halign, {y = 0, text_id = "debug_loading_level", font = "fonts/font_medium_shadow_mf", font_size = 32}.align, {y = 0, text_id = "debug_loading_level", font = "fonts/font_medium_shadow_mf", font_size = 32}.color = l_1_0._saferect_panel:text({y = 0, text_id = "debug_loading_level", font = "fonts/font_medium_shadow_mf", font_size = 32}), 24, l_1_0._base_layer + 1, "bottom", "left", "left", Color.white
  l_1_0._title_text:set_text(string.upper(l_1_0._title_text:text()))
  l_1_0._stonecold_small_logo = l_1_0._saferect_panel:bitmap({name = "stonecold_small_logo", texture = "guis/textures/game_small_logo", texture_rect = {0, 0, 256, 56}, layer = l_1_0._base_layer + 1, h = 56})
  l_1_0._stonecold_small_logo:set_size(256, 56)
  l_1_0._indicator = l_1_0._saferect_panel:bitmap({name = "indicator", texture = "guis/textures/icon_loading", layer = l_1_0._base_layer + 1})
  l_1_0._dot_count = 0
  l_1_0._max_dot_count = 4
  l_1_0._init_progress = 0
  l_1_0._fake_progress = 0
  l_1_0._max_bar_width = 0
  l_1_0:setup(l_1_2, l_1_3)
end

LightLoadingScreenGuiScript.layout_saferect = function(l_2_0)
  local scaled_size = {width = 1198, height = 674, x = 0, y = 0}
  local w = scaled_size.width
  local h = scaled_size.height
  local sh = math.min(l_2_0._safe_rect_pixels.height, l_2_0._safe_rect_pixels.width / (w / h))
  local sw = math.min(l_2_0._safe_rect_pixels.width, l_2_0._safe_rect_pixels.height * (w / h))
  local x = math.round(l_2_0._res.x / 2 - sh * (w / h) / 2)
  local y = math.round(l_2_0._res.y / 2 - sw / (w / h) / 2)
  l_2_0._saferect:set_screen(w, h, x, y, sw)
end

LightLoadingScreenGuiScript.get_safe_rect = function(l_3_0)
  local a = l_3_0._is_win32 and 0.032000001519918 or 0.075000002980232
  local b = 1 - a * 2
  return {x = a, y = a, width = b, height = b}
end

LightLoadingScreenGuiScript.get_safe_rect_pixels = function(l_4_0, l_4_1)
  local safe_rect_scale = l_4_0:get_safe_rect()
  local safe_rect_pixels = {}
  safe_rect_pixels.x = safe_rect_scale.x * l_4_1.x
  safe_rect_pixels.y = safe_rect_scale.y * l_4_1.y
  safe_rect_pixels.width = safe_rect_scale.width * l_4_1.x
  safe_rect_pixels.height = safe_rect_scale.height * l_4_1.y
  return safe_rect_pixels
end

LightLoadingScreenGuiScript.setup = function(l_5_0, l_5_1, l_5_2)
  l_5_0._gui_tweak_data = {}
  l_5_0._gui_tweak_data.upper_saferect_border = 64
  l_5_0._gui_tweak_data.border_pad = 8
  l_5_0._title_text:set_font_size(32)
  l_5_0._stonecold_small_logo:set_size(256, 56)
  l_5_0._title_text:set_shape(0, 0, l_5_0._safe_rect_pixels.width, l_5_0._gui_tweak_data.upper_saferect_border - l_5_0._gui_tweak_data.border_pad)
  local _, _, w, _ = l_5_0._title_text:text_rect()
  l_5_0._title_text:set_w(w)
  l_5_0._stonecold_small_logo:set_right(l_5_0._stonecold_small_logo:parent():w())
  l_5_0._stonecold_small_logo:set_bottom(l_5_0._gui_tweak_data.upper_saferect_border - l_5_0._gui_tweak_data.border_pad)
  l_5_0._indicator:set_left(l_5_0._title_text:right() + 8)
  l_5_0._indicator:set_bottom(l_5_0._gui_tweak_data.upper_saferect_border - l_5_0._gui_tweak_data.border_pad)
  l_5_0._bg_gui:set_size(l_5_1.x, l_5_1.y)
  if l_5_2 > 0 then
    l_5_0._init_progress = l_5_2
  end
end

LightLoadingScreenGuiScript.update = function(l_6_0, l_6_1, l_6_2)
  l_6_0._indicator:rotate(180 * l_6_2)
  if l_6_0._init_progress < 100 and l_6_1 == -1 then
    l_6_0._fake_progress = l_6_0._fake_progress + 20 * l_6_2
    if l_6_0._fake_progress > 100 then
      l_6_0._fake_progress = 100
    end
    l_6_1 = l_6_0._fake_progress
  end
end

LightLoadingScreenGuiScript.set_text = function(l_7_0, l_7_1)
end

LightLoadingScreenGuiScript.destroy = function(l_8_0)
  if alive(l_8_0._ws) then
    l_8_0._scene_gui:destroy_workspace(l_8_0._ws)
    l_8_0._scene_gui:destroy_workspace(l_8_0._saferect)
    l_8_0._ws = nil
    l_8_0._saferect = nil
  end
end

LightLoadingScreenGuiScript.visible = function(l_9_0)
  return l_9_0._ws:visible()
end

LightLoadingScreenGuiScript.set_visible = function(l_10_0, l_10_1, l_10_2)
  if l_10_2 then
    l_10_0._res = l_10_2
    l_10_0._safe_rect_pixels = l_10_0:get_safe_rect_pixels(l_10_2)
    l_10_0:layout_saferect()
    l_10_0:setup(l_10_2, -1)
  end
  if l_10_1 then
    l_10_0._ws:show()
    l_10_0._saferect:show()
  else
    l_10_0._ws:hide()
    l_10_0._saferect:hide()
  end
end


