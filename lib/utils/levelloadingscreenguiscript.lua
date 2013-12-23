-- Decompiled using luadec 2.0.1 by sztupy (http://winmo.sztupy.hu)
-- Command line was: F:\SteamLibrary\SteamApps\common\PAYDAY 2\lua\lib\utils\levelloadingscreenguiscript.luac 

if not LevelLoadingScreenGuiScript then
  LevelLoadingScreenGuiScript = class()
end
LevelLoadingScreenGuiScript.init = function(l_1_0, l_1_1, l_1_2, l_1_3, l_1_4)
  l_1_0._scene_gui = l_1_1
  l_1_0._res = l_1_2
  l_1_0._base_layer = l_1_4
  l_1_0._level_tweak_data = arg.load_level_data.level_tweak_data
  l_1_0._gui_tweak_data = arg.load_level_data.gui_tweak_data
  l_1_0._menu_tweak_data = arg.load_level_data.menu_tweak_data
  l_1_0._scale_tweak_data = arg.load_level_data.scale_tweak_data
  l_1_0._coords = arg.load_level_data.controller_coords or false
  l_1_0._gui_data = arg.load_level_data.gui_data
  l_1_0._workspace_size = l_1_0._gui_data.workspace_size
  l_1_0._saferect_size = l_1_0._gui_data.saferect_size
  local challenges = arg.load_level_data.challenges
  local safe_rect_pixels = l_1_0._gui_data.safe_rect_pixels
  local safe_rect = l_1_0._gui_data.safe_rect
  local aspect_ratio = l_1_0._gui_data.aspect_ratio
  l_1_0._safe_rect_pixels = safe_rect_pixels
  l_1_0._safe_rect = safe_rect
  l_1_0._gui_data_manager = GuiDataManager:new(l_1_0._scene_gui, l_1_2, safe_rect_pixels, safe_rect, aspect_ratio)
  l_1_0._back_drop_gui = MenuBackdropGUI:new(nil, l_1_0._gui_data_manager, true)
  l_1_0._back_drop_gui:set_pattern("guis/textures/loading/loading_foreground", 1)
  local base_panel = l_1_0._back_drop_gui:get_new_base_layer()
  local level_image = base_panel:bitmap({texture = l_1_0._gui_data.bg_texture, layer = 0})
  level_image:set_alpha(0.5)
  print("self._gui_data.bg_texture", l_1_0._gui_data.bg_texture)
  level_image:set_size(level_image:parent():h() * (level_image:texture_width() / level_image:texture_height()), level_image:parent():h())
  level_image:set_position(0, 0)
  local background_fullpanel = l_1_0._back_drop_gui:get_new_background_layer()
  local background_safepanel = l_1_0._back_drop_gui:get_new_background_layer()
  l_1_0._back_drop_gui:set_panel_to_saferect(background_safepanel)
  l_1_0._indicator = background_safepanel:bitmap({name = "indicator", texture = "guis/textures/icon_loading", layer = 0})
   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

  l_1_0._level_title_text, {y = 0, text_id = "debug_loading_level", font = "fonts/font_large_mf", font_size = 36}.h, {y = 0, text_id = "debug_loading_level", font = "fonts/font_large_mf", font_size = 36}.layer, {y = 0, text_id = "debug_loading_level", font = "fonts/font_large_mf", font_size = 36}.vertical, {y = 0, text_id = "debug_loading_level", font = "fonts/font_large_mf", font_size = 36}.halign, {y = 0, text_id = "debug_loading_level", font = "fonts/font_large_mf", font_size = 36}.align, {y = 0, text_id = "debug_loading_level", font = "fonts/font_large_mf", font_size = 36}.color = background_safepanel:text({y = 0, text_id = "debug_loading_level", font = "fonts/font_large_mf", font_size = 36}), 36, 0, "bottom", "left", "left", Color.white
  l_1_0._level_title_text:set_text(utf8.to_upper(l_1_0._level_title_text:text()))
  local _, _, w, h = l_1_0._level_title_text:text_rect()
  l_1_0._level_title_text:set_size(w, h)
  l_1_0._indicator:set_right(l_1_0._indicator:parent():w())
  l_1_0._level_title_text:set_right(l_1_0._indicator:left())
   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

  local bg_loading_text = background_fullpanel:text({y = 0, text_id = "debug_loading_level"})
  bg_loading_text:set_text(utf8.to_upper(bg_loading_text:text()))
  {y = 0, text_id = "debug_loading_level"}.layer, {y = 0, text_id = "debug_loading_level"}.vertical, {y = 0, text_id = "debug_loading_level"}.align, {y = 0, text_id = "debug_loading_level"}.color, {y = 0, text_id = "debug_loading_level"}.h, {y = 0, text_id = "debug_loading_level"}.font_size, {y = 0, text_id = "debug_loading_level"}.font = 0, "top", "right", Color(0.30000001192093, 0.38039216399193, 0.839215695858, 1), 80, 80, "fonts/font_eroded"
  local x, y = l_1_0._level_title_text:world_right(), l_1_0._level_title_text:world_center_y()
  bg_loading_text:set_world_right(x)
  bg_loading_text:set_world_center_y(y)
  bg_loading_text:move(13, 3)
  l_1_0._back_drop_gui:animate_bg_text(bg_loading_text)
  if l_1_0._coords then
    l_1_0._controller = background_safepanel:bitmap({texture = "guis/textures/controller", layer = 1, w = 512, h = 256})
    l_1_0._controller:set_center(background_safepanel:w() / 2, background_safepanel:h() / 2)
    for id,data in pairs(l_1_0._coords) do
      data.text = background_safepanel:text({name = id, text = data.string, font_size = 24, font = "fonts/font_medium_mf", align = data.align, vertical = data.vertical, halign = "center", valign = "center"})
      local _, _, w, h = data.text:text_rect()
      data.text:set_size(w, h)
      if data.x then
        local x = l_1_0._controller:x() + data.x
        local y = l_1_0._controller:y() + data.y
        if data.align == "left" then
          data.text:set_left(x)
        elseif data.align == "right" then
          data.text:set_right(x)
        elseif data.align == "center" then
          data.text:set_center_x(x)
        end
        if data.vertical == "top" then
          data.text:set_top(y)
          for (for control),id in (for generator) do
          end
          if data.vertical == "bottom" then
            data.text:set_bottom(y)
            for (for control),id in (for generator) do
            end
            data.text:set_center_y(y)
          end
        end
      end
       -- Warning: missing end command somewhere! Added here
    end
     -- Warning: missing end command somewhere! Added here
  end
end

LevelLoadingScreenGuiScript.setup = function(l_2_0, l_2_1, l_2_2)
  l_2_0._saferect_bottom_y = l_2_0._saferect_panel:h() - l_2_0._gui_tweak_data.upper_saferect_border
  l_2_0._level_title_text:set_shape(0, 0, l_2_0._safe_rect_pixels.width, l_2_0._gui_tweak_data.upper_saferect_border - l_2_0._gui_tweak_data.border_pad)
  local _, _, w, _ = l_2_0._level_title_text:text_rect()
  l_2_0._level_title_text:set_w(w)
  l_2_0._bg_gui:set_size(l_2_0._bg_gui:parent():h() * (l_2_0._bg_gui:texture_width() / l_2_0._bg_gui:texture_height()), l_2_0._bg_gui:parent():h())
  l_2_0._bg_gui:set_center(l_2_0._bg_gui:parent():center())
  if l_2_0._briefing_text then
    if l_2_0._res and l_2_0._res.y <= 601 then
      l_2_0._briefing_text:set_w(l_2_0._briefing_text:parent():w())
      local _, _, w, h = l_2_0._briefing_text:text_rect()
      l_2_0._briefing_text:set_size(w, h)
      l_2_0._briefing_text:set_lefttop(0, l_2_0._briefing_text:parent():h() / 2)
    else
      l_2_0._briefing_text:set_w(l_2_0._briefing_text:parent():w() * 0.5)
      local _, _, w, h = l_2_0._briefing_text:text_rect()
      l_2_0._briefing_text:set_size(w, h)
      l_2_0._briefing_text:set_rightbottom(l_2_0._briefing_text:parent():w(), l_2_0._saferect_bottom_y - l_2_0._gui_tweak_data.border_pad)
    end
  end
  local border_size = 2
  local bar_size = 2
  l_2_0._stonecold_small_logo:set_righttop(l_2_0._stonecold_small_logo:parent():righttop())
  l_2_0._stonecold_small_logo:set_bottom(l_2_0._gui_tweak_data.upper_saferect_border - l_2_0._gui_tweak_data.border_pad)
  l_2_0._top_y = l_2_0._safe_rect_pixels.y + l_2_0._gui_tweak_data.upper_saferect_border
  l_2_0._bottom_y = l_2_0._safe_rect_pixels.y + l_2_0._saferect_panel:h() - l_2_0._gui_tweak_data.upper_saferect_border
  l_2_0._upper_frame_rect:set_h(l_2_0._screen_y + l_2_0._gui_tweak_data.upper_saferect_border)
  l_2_0._lower_frame_rect:set_h(l_2_0._upper_frame_rect:h())
  l_2_0._lower_frame_rect:set_bottom(l_2_0._lower_frame_rect:parent():h())
  local tip_top = l_2_0._gui_tweak_data.upper_saferect_border + l_2_0._gui_tweak_data.border_pad + 14
  local _, _, w, h = l_2_0._tips_head_line:text_rect()
  l_2_0._tips_head_line:set_size(w, h)
  l_2_0._tips_head_line:set_top(tip_top)
  local offset = 20
  l_2_0._tips_text:set_w(l_2_0._saferect_panel:w() - l_2_0._tips_head_line:w() - offset)
  l_2_0._tips_text:set_top(tip_top)
  l_2_0._tips_text:set_left(l_2_0._tips_head_line:right() + offset)
  if l_2_2 > 0 then
    l_2_0._init_progress = l_2_2
  end
  for i,challenge in ipairs(l_2_0._challenges) do
    local h = challenge.panel:h()
    challenge.panel:set_bottom(l_2_0._saferect_bottom_y - (h + 2) * (#l_2_0._challenges - i))
    challenge.text:set_left(challenge.panel:right() + 8 * l_2_0._scale_tweak_data.loading_challenge_bar_scale)
    challenge.text:set_center_y(challenge.panel:center_y())
  end
   -- DECOMPILER ERROR: Confused while interpreting a jump as a 'while'

end
l_2_0._challenges_topic:set_visible(true)
if l_2_0._challenges[1] then
  l_2_0._challenges_topic:set_bottom(l_2_0._challenges[1].panel:top() - 4)
end
l_2_0._indicator:set_left(l_2_0._level_title_text:right() + 8)
l_2_0._indicator:set_bottom(l_2_0._gui_tweak_data.upper_saferect_border - l_2_0._gui_tweak_data.border_pad)
if l_2_0._coords then
  l_2_0._controller:set_center(l_2_0._saferect_panel:w() / 2, l_2_0._saferect_panel:h() / 2)
  for id,data in pairs(l_2_0._coords) do
    local _, _, w, h = data.text:text_rect()
    data.text:set_size(w, h)
    if data.x then
      local x = l_2_0._controller:x() + data.x
      local y = l_2_0._controller:y() + data.y
      if data.align == "left" then
        data.text:set_left(x)
      elseif data.align == "right" then
        data.text:set_right(x)
      elseif data.align == "center" then
        data.text:set_center_x(x)
      end
      if data.vertical == "top" then
        data.text:set_top(y)
        for (for control),id in (for generator) do
        end
        if data.vertical == "bottom" then
          data.text:set_bottom(y)
          for (for control),id in (for generator) do
          end
          data.text:set_center_y(y)
        end
      end
    end
     -- Warning: missing end command somewhere! Added here
  end
end

LevelLoadingScreenGuiScript.update = function(l_3_0, l_3_1, l_3_2, l_3_3)
  l_3_0._indicator:rotate(180 * l_3_3)
end

LevelLoadingScreenGuiScript.get_loading_text = function(l_4_0, l_4_1)
  return l_4_0._init_text .. string.rep(".", math.floor(l_4_1))
end

LevelLoadingScreenGuiScript.set_text = function(l_5_0, l_5_1)
  l_5_0._text_gui:set_text(l_5_1)
  l_5_0._init_text = l_5_1
end

LevelLoadingScreenGuiScript.destroy = function(l_6_0)
  if alive(l_6_0._saferect) then
    l_6_0._scene_gui:destroy_workspace(l_6_0._saferect)
    l_6_0._saferect = nil
  end
  if alive(l_6_0._fullrect) then
    l_6_0._scene_gui:destroy_workspace(l_6_0._fullrect)
    l_6_0._fullrect = nil
  end
  if alive(l_6_0._ws) then
    l_6_0._scene_gui:destroy_workspace(l_6_0._ws)
    l_6_0._ws = nil
  end
  if l_6_0._back_drop_gui then
    l_6_0._back_drop_gui:destroy()
    l_6_0._back_drop_gui = nil
  end
end

LevelLoadingScreenGuiScript.visible = function(l_7_0)
  return l_7_0._ws:visible()
end

LevelLoadingScreenGuiScript.set_visible = function(l_8_0, l_8_1)
  if l_8_1 then
    l_8_0._ws:show()
  else
    l_8_0._ws:hide()
  end
end


