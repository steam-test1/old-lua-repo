-- Decompiled using luadec 2.0.1 by sztupy (http://winmo.sztupy.hu)
-- Command line was: F:\SteamLibrary\SteamApps\common\PAYDAY 2\lua\lib\managers\menu\debugdrawfonts.luac 

if not DebugDrawFonts then
  DebugDrawFonts = class()
end
DebugDrawFonts.init = function(l_1_0, l_1_1)
  l_1_0._ws = l_1_1
  l_1_0._panel = l_1_1:panel():panel({layer = 1000})
  l_1_0._toggle = false
  local massive_font = tweak_data.menu.pd2_massive_font
  local large_font = tweak_data.menu.pd2_large_font
  local medium_font = tweak_data.menu.pd2_medium_font
  local small_font = tweak_data.menu.pd2_small_font
  local massive_font_size = tweak_data.menu.pd2_massive_font_size
  local large_font_size = tweak_data.menu.pd2_large_font_size
  local medium_font_size = tweak_data.menu.pd2_medium_font_size
  local small_font_size = tweak_data.menu.pd2_small_font_size
  local text_of_texts_id = "debug_debug_font_draw_text"
  local macroes_of_texts = {}
  local localized_text = managers.localization:text(text_of_texts_id, macroes_of_texts)
  local width = l_1_0._panel:w() - 60
  local height = l_1_0._panel:h() - 60
  local left_side = l_1_0._panel:panel()
  left_side:set_size(width / 2 - 5, height)
  left_side:set_position(40, 40)
  left_side:rect({color = Color.black, alpha = 0.40000000596046})
  local right_side = l_1_0._panel:panel()
  right_side:set_size(width / 2 - 5, height)
  right_side:set_righttop(l_1_0._panel:w() - 40, 40)
  right_side:rect({color = Color.white, alpha = 0.40000000596046})
  local blur = l_1_0._panel:bitmap({texture = "guis/textures/test_blur_df", w = l_1_0._panel:w(), h = l_1_0._panel:h(), render_template = "VertexColorTexturedBlur3D", layer = -1})
  local func = function(l_1_0)
    over(0.60000002384186, function(l_1_0)
      o:set_alpha(l_1_0)
      end)
   end
  blur:animate(func)
  local fonts = {{large_font, large_font_size}, {medium_font, medium_font_size}, {small_font, small_font_size}}
  local sides = {left_side, right_side}
  local x = 10
  for i,side in pairs(sides) do
    local y = 10
    for _,font_data in ipairs(fonts) do
       -- DECOMPILER ERROR: Confused about usage of registers!

       -- DECOMPILER ERROR: Confused about usage of registers!

       -- DECOMPILER ERROR: Confused about usage of registers!

       -- DECOMPILER ERROR: Confused about usage of registers!

       -- DECOMPILER ERROR: Confused about usage of registers!

       -- DECOMPILER ERROR: Confused about usage of registers!

       -- DECOMPILER ERROR: Confused about usage of registers!

      local text = side:text({font = font_data[1], font_size = font_data[2]})
      {font = font_data[1], font_size = font_data[2]}.w, {font = font_data[1], font_size = font_data[2]}.word_wrap, {font = font_data[1], font_size = font_data[2]}.wrap, {font = font_data[1], font_size = font_data[2]}.layer, {font = font_data[1], font_size = font_data[2]}.text, {font = font_data[1], font_size = font_data[2]}.y, {font = font_data[1], font_size = font_data[2]}.x = side:w() - 2 * x, true, true, 2, localized_text, y, x
      if i == 2 then
        text:set_text(utf8.to_upper(text:text()))
      end
      local _, _, tw, th = text:text_rect()
      y = y + math.round(th + 0)
       -- DECOMPILER ERROR: Confused about usage of registers!

       -- DECOMPILER ERROR: Confused about usage of registers!

       -- DECOMPILER ERROR: Confused about usage of registers!

       -- DECOMPILER ERROR: Confused about usage of registers!

       -- DECOMPILER ERROR: Confused about usage of registers!

       -- DECOMPILER ERROR: Confused about usage of registers!

       -- DECOMPILER ERROR: Confused about usage of registers!

      local text = side:text({font = font_data[1], font_size = font_data[2]})
      {font = font_data[1], font_size = font_data[2]}.w, {font = font_data[1], font_size = font_data[2]}.word_wrap, {font = font_data[1], font_size = font_data[2]}.wrap, {font = font_data[1], font_size = font_data[2]}.layer, {font = font_data[1], font_size = font_data[2]}.text, {font = font_data[1], font_size = font_data[2]}.y, {font = font_data[1], font_size = font_data[2]}.x = side:w() - 2 * x, true, true, 2, localized_text, y, x
      if i == 2 then
        text:set_text(utf8.to_upper(text:text()))
      end
      local _, _, tw, th = text:text_rect()
      text:set_size(tw, th)
       -- DECOMPILER ERROR: Confused while interpreting a jump as a 'while'

    end
    side:rect({color = Color.black, alpha = 0.60000002384186, layer = 1}):set_shape(text:shape())
    y = y + math.round(th + 20)
  end
end
end

DebugDrawFonts.toggle_debug = function(l_2_0)
  l_2_0._toggle = not l_2_0._toggle
  l_2_0._panel:set_debug(l_2_0._toggle)
end

DebugDrawFonts.reload = function(l_3_0)
  l_3_0:close()
  l_3_0.init(l_3_0, l_3_0._ws)
end

DebugDrawFonts.set_enabled = function(l_4_0, l_4_1)
  l_4_0._panel:set_visible(l_4_1)
end

DebugDrawFonts.close = function(l_5_0)
  l_5_0._panel:parent():remove(l_5_0._panel)
end


