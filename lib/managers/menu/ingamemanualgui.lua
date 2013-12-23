-- Decompiled using luadec 2.0.1 by sztupy (http://winmo.sztupy.hu)
-- Command line was: F:\SteamLibrary\SteamApps\common\PAYDAY 2\lua\lib\managers\menu\ingamemanualgui.luac 

if not IngameManualGui then
  IngameManualGui = class()
end
IngameManualGui.PAGES = 8
IngameManualGui.init = function(l_1_0, l_1_1, l_1_2)
  l_1_0._ws = l_1_1
  l_1_0._fullscreen_ws = l_1_2
  l_1_0._manual_panel = l_1_0._ws:panel():panel()
  l_1_0._fullscreen_panel = l_1_0._fullscreen_ws:panel():panel()
  l_1_0._active = true
  l_1_0:_setup_controller_input()
  local black_bg = l_1_0._fullscreen_panel:rect({color = Color.black, layer = 0, halign = "scale", valign = "scale", alpha = 0})
  local fade_in_anim = function(l_1_0)
    over(0.34999999403954, function(l_1_0)
      o:set_alpha(l_1_0)
      end)
   end
  black_bg:animate(fade_in_anim)
  local width = math.round(l_1_0._manual_panel:w())
  local height = math.round((l_1_0._manual_panel:h() - l_1_0._manual_panel:w() / 2) * 0.5)
  l_1_0._manual_panel:rect({w = width, h = 1, x = 0, y = height, layer = 4})
  l_1_0._manual_panel:rect({w = width, h = 1, x = 0, y = l_1_0._manual_panel:h() - height - 1, layer = 4})
  l_1_0._manual_panel:rect({w = 1, h = l_1_0._manual_panel:h() - height * 2 - 2, x = 0, y = height + 1, layer = 4})
  l_1_0._manual_panel:rect({w = 1, h = l_1_0._manual_panel:h() - height * 2 - 2, x = l_1_0._manual_panel:w() - 1, y = height + 1, layer = 4})
  l_1_0._manual_y = height
  l_1_0._page_counter = l_1_0._manual_panel:text({font = tweak_data.menu.pd2_medium_font, font_size = tweak_data.menu.pd2_medium_font_size, text = "1/" .. tostring(l_1_0.PAGES), layer = 4, align = "center"})
  l_1_0._zoom = 1
  l_1_0:open_manual_page(1)
end

IngameManualGui._setup_controller_input = function(l_2_0)
  l_2_0._left_axis_vector = Vector3()
  l_2_0._right_axis_vector = Vector3()
  l_2_0._ws:connect_controller(managers.menu:active_menu().input:get_controller(), true)
  l_2_0._manual_panel:axis_move(callback(l_2_0, l_2_0, "_axis_move"))
end

IngameManualGui._destroy_controller_unput = function(l_3_0)
  l_3_0._ws:disconnect_all_controllers()
  if alive(l_3_0._panel) then
    l_3_0._manual_panel:axis_move(nil)
  end
end

IngameManualGui._axis_move = function(l_4_0, l_4_1, l_4_2, l_4_3, l_4_4)
  if l_4_2 == Idstring("left") then
    mvector3.set(l_4_0._left_axis_vector, l_4_3)
  else
    if l_4_2 == Idstring("right") then
      mvector3.set(l_4_0._right_axis_vector, l_4_3)
    end
  end
end

IngameManualGui.update = function(l_5_0, l_5_1, l_5_2)
  if managers.menu:is_pc_controller() then
    return 
  end
  if mvector3.is_zero(l_5_0._left_axis_vector) then
    do return end
  end
  local x = mvector3.x(l_5_0._left_axis_vector)
  do
    local y = mvector3.y(l_5_0._left_axis_vector)
    l_5_0:controller_move(-x * l_5_2, y * l_5_2)
  end
  if mvector3.is_zero(l_5_0._right_axis_vector) then
    do return end
  end
  local y = mvector3.y(l_5_0._right_axis_vector)
  l_5_0:controller_zoom(y * l_5_2)
end

IngameManualGui.correct_position = function(l_6_0)
  if l_6_0._page:left() > 0 then
    l_6_0._page:set_left(0)
  else
    if l_6_0._page:right() < l_6_0._page_panel:w() then
      l_6_0._page:set_right(l_6_0._page_panel:w())
    end
  end
  if l_6_0._page:top() > 0 then
    l_6_0._page:set_top(0)
  else
    if l_6_0._page:bottom() < l_6_0._page_panel:h() then
      l_6_0._page:set_bottom(l_6_0._page_panel:h())
    end
  end
end

IngameManualGui.controller_move = function(l_7_0, l_7_1, l_7_2)
  if l_7_0._loading then
    return 
  end
  if not alive(l_7_0._page) then
    return 
  end
  local speed = 512
  l_7_0._page:move(l_7_1 * speed, l_7_2 * speed)
  l_7_0:correct_position()
end

IngameManualGui.controller_zoom = function(l_8_0, l_8_1)
  if l_8_0._loading then
    return 
  end
  if not alive(l_8_0._page) then
    return 
  end
  l_8_0._zoom = math.clamp(l_8_0._zoom + l_8_1 * 2, 1, 2)
  local w, h = l_8_0._manual_panel:size()
  local px, py = l_8_0._page:position()
  local x = w / 2 - px
  local y = h / 2 - py
  local sx = x / l_8_0._page:w()
  local sy = y / l_8_0._page:h()
  local aspect = l_8_0._page:texture_height() / math.max(l_8_0._page:texture_width(), 1)
  local width = l_8_0._page_panel:w()
  local height = l_8_0._page_panel:h()
  l_8_0._page:set_size(width * l_8_0._zoom, width * aspect * l_8_0._zoom)
  l_8_0._page:set_position(w / 2 - sx * l_8_0._page:w(), h / 2 - sy * l_8_0._page:h())
  l_8_0:correct_position()
end

IngameManualGui.next_page = function(l_9_0)
  l_9_0:open_manual_page(l_9_0._current_page + 1)
end

IngameManualGui.previous_page = function(l_10_0)
  l_10_0:open_manual_page(l_10_0._current_page - 1)
end

IngameManualGui.input_focus = function(l_11_0)
  return 1
end

IngameManualGui.open_manual_page = function(l_12_0, l_12_1)
  local new_page = math.clamp(l_12_1, 1, l_12_0.PAGES)
  if new_page == l_12_0._current_page then
    return 
  end
  local path = "guis/textures/pd2/ingame_manual/page_"
  local lang_key = SystemInfo:language():key()
  local files = {Idstring("french"):key() = "_fr", Idstring("spanish"):key() = "_es"}
  l_12_0._zoom = 1
  l_12_0._current_page = new_page
  l_12_0._page_counter:set_text(tostring(l_12_0._current_page) .. "/" .. tostring(l_12_0.PAGES))
  local new_page = path .. tostring(l_12_1) .. (files[lang_key] or "")
  print(new_page)
  if DB:has(Idstring("texture"), new_page) then
    l_12_0._loading = new_page
    TextureCache:request(new_page, "NORMAL", callback(managers.menu_component, managers.menu_component, "ingame_manual_texture_done"))
  end
  l_12_0:remove_page()
  l_12_0._page = l_12_0._manual_panel:panel()
  local loading_text = l_12_0._page:text({font = tweak_data.menu.pd2_large_font, font_size = tweak_data.menu.pd2_large_font_size, text = managers.localization:to_upper_text("debug_loading_level")})
  local x, y, w, h = loading_text:text_rect()
  loading_text:set_size(w, h)
  local spinning_item = l_12_0._page:bitmap({w = 32, h = 32, texture = "guis/textures/icon_loading"})
  loading_text:set_position(10, l_12_0._manual_y + 10)
  spinning_item:set_left(loading_text:right())
  spinning_item:set_center_y(loading_text:center_y())
  local spin_anim = function(l_1_0)
    local dt = nil
    repeat
      dt = coroutine.yield()
      l_1_0:rotate(360 * dt)
      do return end
       -- Warning: missing end command somewhere! Added here
    end
   end
  spinning_item:animate(spin_anim)
end

IngameManualGui.remove_page = function(l_13_0)
  if l_13_0._page_panel then
    l_13_0._page_panel:parent():remove(l_13_0._page_panel)
    l_13_0._page_panel = nil
    l_13_0._page = nil
  end
  if l_13_0._page then
    l_13_0._page:parent():remove(l_13_0._page)
    l_13_0._page = nil
  end
end

IngameManualGui.create_page = function(l_14_0, l_14_1)
  local new_page_panel = l_14_0._manual_panel:panel({visible = false})
  local texture = new_page_panel:bitmap({name = "texture", texture = l_14_1, layer = 1})
  if not l_14_0._loading or Idstring(l_14_0._loading) ~= l_14_1 then
    new_page_panel:parent():remove(new_page_panel)
    return 
  end
  new_page_panel:show()
  l_14_0:remove_page()
  l_14_0._page_panel = new_page_panel
  l_14_0._page = texture
  local aspect = l_14_0._page:texture_height() / math.max(l_14_0._page:texture_width(), 1)
  local width = l_14_0._manual_panel:w()
  local height = l_14_0._manual_panel:h()
  new_page_panel:set_h(width * aspect)
  new_page_panel:set_w(width)
  new_page_panel:set_center(l_14_0._manual_panel:w() / 2, l_14_0._manual_panel:h() / 2)
  l_14_0._page:set_w(new_page_panel:w())
  l_14_0._page:set_h(new_page_panel:h())
  texture:set_size(l_14_0._page:w(), l_14_0._page:h())
  l_14_0._loading = nil
end

IngameManualGui.set_layer = function(l_15_0, l_15_1)
end

IngameManualGui.close = function(l_16_0)
  l_16_0:_destroy_controller_unput()
  l_16_0._ws:panel():remove(l_16_0._manual_panel)
  l_16_0._fullscreen_ws:panel():remove(l_16_0._fullscreen_panel)
end


