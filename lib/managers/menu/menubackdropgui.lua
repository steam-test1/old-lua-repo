-- Decompiled using luadec 2.0.1 by sztupy (http://winmo.sztupy.hu)
-- Command line was: F:\SteamLibrary\SteamApps\common\PAYDAY 2\lua\lib\managers\menu\menubackdropgui.luac 

if not MenuBackdropGUI then
  MenuBackdropGUI = class()
end
local l_0_0 = MenuBackdropGUI
local l_0_1 = {}
l_0_1.w = 1280
l_0_1.h = 720
l_0_0.BASE_RES = l_0_1
l_0_0 = MenuBackdropGUI
l_0_1 = function(l_1_0, l_1_1, l_1_2, l_1_3)
  l_1_0._fixed_dt = l_1_3
  l_1_0._gui_data_manager = l_1_2
  if not l_1_1 then
    if not l_1_0._gui_data_manager then
      l_1_0._workspace = managers.gui_data:create_fullscreen_16_9_workspace(managers.gui_data)
    end
    if not l_1_1 then
      if not l_1_0._gui_data_manager then
        l_1_0._blackborder_workspace = managers.gui_data:create_fullscreen_workspace()
        l_1_0._blackborder_workspace:panel():rect({name = "top_border", layer = 1000, color = Color.black})
        l_1_0._blackborder_workspace:panel():rect({name = "bottom_border", layer = 1000, color = Color.black})
        l_1_0:_set_black_borders()
        if managers and managers.viewport then
          l_1_0._resolution_changed_callback_id = managers.viewport:add_resolution_changed_func(callback(l_1_0, l_1_0, "resolution_changed"))
        end
        l_1_0._my_workspace = true
      end
      l_1_0._panel = l_1_0._workspace:panel():panel({name = "panel", halign = "grow", valign = "grow", layer = 0})
      l_1_0._panel:panel({name = "base_layer", halign = "grow", valign = "grow", layer = 0})
      l_1_0._panel:panel({name = "pattern_layer", halign = "grow", valign = "grow", layer = 1})
      l_1_0._panel:panel({name = "item_background_layer", halign = "grow", valign = "grow", layer = 2})
      l_1_0._panel:panel({name = "particles_layer", halign = "grow", valign = "grow", layer = 3})
      l_1_0._panel:panel({name = "light_layer", halign = "grow", valign = "grow", layer = 4})
      l_1_0._panel:panel({name = "item_foreground_layer", halign = "grow", valign = "grow", layer = 5})
      l_1_0:setup_saferect_shape()
      l_1_0._layer_layers = {}
      for i = 1, 6 do
        table.insert(l_1_0._layer_layers, 0)
      end
      l_1_0:_create_base_layer()
      l_1_0:set_particles_object("guis/textures/pd2/menu_backdrop/bd_particles", 2, 2, 6)
      l_1_0:enable_light(true)
       -- Warning: missing end command somewhere! Added here
    end
     -- Warning: missing end command somewhere! Added here
  end
end

l_0_0.init = l_0_1
l_0_0 = MenuBackdropGUI
l_0_1 = function(l_2_0)
  local saferect_shape = {}
  if not l_2_0._gui_data_manager then
    local safe_scaled_size = managers.gui_data:safe_scaled_size()
    do
      local temp_saferect_panel = l_2_0._panel:panel({name = "temp_saferect_panel", w = safe_scaled_size.w, h = safe_scaled_size.h})
      temp_saferect_panel:set_center(l_2_0._panel:w() * 0.5, l_2_0._panel:h() * 0.5)
       -- DECOMPILER ERROR: No list found. Setlist fails

       -- DECOMPILER ERROR: Overwrote pending register.

      l_2_0._panel:remove(temp_saferect_panel)
      saferect_shape.height, saferect_shape.width, saferect_shape.h, saferect_shape.w, saferect_shape.y, saferect_shape.x, saferect_shape = saferect_shape.h, saferect_shape.w, saferect_shape[4], saferect_shape[3], saferect_shape[2], saferect_shape[1], {}
      l_2_0._saferect_shape = saferect_shape
    end
     -- Warning: missing end command somewhere! Added here
  end
end

l_0_0.setup_saferect_shape = l_0_1
l_0_0 = MenuBackdropGUI
l_0_1 = function(l_3_0)
  l_3_0._blackborder_workspace = managers.gui_data:create_fullscreen_workspace()
  l_3_0._blackborder_workspace:panel():rect({name = "top_border", layer = 49, color = Color.black})
  l_3_0._blackborder_workspace:panel():rect({name = "bottom_border", layer = 49, color = Color.black})
  l_3_0:_set_black_borders()
  local one_frame_wait_anim = function(l_1_0)
    l_1_0:hide()
    coroutine.yield()
    l_1_0:show()
   end
  l_3_0._blackborder_workspace:panel():animate(one_frame_wait_anim)
end

l_0_0.create_black_borders = l_0_1
l_0_0 = MenuBackdropGUI
l_0_1 = function(l_4_0, l_4_1)
  if not l_4_0._gui_data_manager then
    local manager = managers.gui_data
  end
  manager:layout_fullscreen_workspace(l_4_0._blackborder_workspace)
  local top_border = l_4_0._blackborder_workspace:panel():child("top_border")
  local bottom_border = l_4_0._blackborder_workspace:panel():child("bottom_border")
  local border_w = l_4_0._blackborder_workspace:panel():w()
  local border_h = (l_4_0._blackborder_workspace:panel():h() - l_4_0.BASE_RES.h) / 2
  top_border:set_position(0, -2)
  top_border:set_size(border_w, border_h + 2)
  bottom_border:set_position(0, l_4_0.BASE_RES.h + border_h - 2)
  bottom_border:set_size(border_w, border_h + 2)
end

l_0_0._set_black_borders = l_0_1
l_0_0 = MenuBackdropGUI
l_0_1 = function(l_5_0)
  if not l_5_0._gui_data_manager then
    local manager = managers.gui_data
  end
  manager:layout_fullscreen_16_9_workspace(manager, l_5_0._workspace)
  l_5_0:_set_black_borders(manager)
end

l_0_0.resolution_changed = l_0_1
l_0_0 = MenuBackdropGUI
l_0_1 = function(l_6_0, l_6_1, l_6_2)
  local aspect = l_6_0.BASE_RES.w / l_6_0.BASE_RES.h
  local sw = math.min(l_6_1, l_6_2 * aspect)
  local sh = math.min(l_6_2, l_6_1 / aspect)
  local dw = l_6_1 / sw
  local dh = l_6_2 / sh
  return dw * l_6_0.BASE_RES.w, dh * l_6_0.BASE_RES.h
end

l_0_0._get_correct_fullscreen_texture_size = l_0_1
l_0_0 = MenuBackdropGUI
l_0_1 = function(l_7_0, l_7_1, l_7_2)
  local dw, dh = l_7_0:_get_correct_fullscreen_texture_size(l_7_1:texture_width(), l_7_1:texture_height())
  l_7_1:set_size(dw * l_7_2, dh * l_7_2)
  l_7_1:set_center(l_7_0.BASE_RES.w * 0.5, l_7_0.BASE_RES.h * 0.5)
end

l_0_0.set_fullscreen_bitmap_shape = l_0_1
l_0_0 = MenuBackdropGUI
l_0_1 = function(l_8_0, l_8_1, l_8_2)
  l_8_0._layer_layers[l_8_1] = l_8_2
  l_8_0:_update_layers()
end

l_0_0._set_layers_of_layer = l_0_1
l_0_0 = MenuBackdropGUI
l_0_1 = function(l_9_0)
  local layers_name_table = {"base_layer", "pattern_layer", "item_background_layer", "particles_layer", "light_layer", "item_foreground_layer"}
  local num_layers = 0
  local layer = nil
  for i,layer_name in ipairs(layers_name_table) do
    layer = l_9_0._panel:child(layer_name)
    layer:set_layer(num_layers)
    num_layers = num_layers + l_9_0._layer_layers[i]
  end
  layer:set_layer(num_layers)
end

l_0_0._update_layers = l_0_1
l_0_0 = MenuBackdropGUI
l_0_1 = function(l_10_0)
  local base_layer = l_10_0._panel:child("base_layer")
  base_layer:clear()
  l_10_0:_set_layers_of_layer(1, 1)
  local bd_base_layer = base_layer:bitmap({name = "bd_base_layer", texture = "guis/textures/pd2/menu_backdrop/bd_baselayer"})
  l_10_0:set_fullscreen_bitmap_shape(bd_base_layer, 1)
end

l_0_0._create_base_layer = l_0_1
l_0_0 = MenuBackdropGUI
l_0_1 = function(l_11_0, l_11_1)
  local light_layer = l_11_0._panel:child("light_layer")
  light_layer:clear()
  if not l_11_1 then
    l_11_0:_set_layers_of_layer(5, 0)
    return 
  end
  l_11_0:_set_layers_of_layer(5, 1)
  local bd_light = light_layer:bitmap({name = "bd_light", texture = "guis/textures/pd2/menu_backdrop/bd_light"})
  bd_light:set_size(light_layer:size())
  bd_light:set_alpha(0)
  bd_light:set_blend_mode("add")
  local light_flicker_animation = function(l_1_0)
    local alpha = 0
    local acceleration = 0
    local wanted_alpha = math.rand(1) * 0.30000001192093
    do
      local flicker_up = true
      repeat
        wait(math.rand(0.10000000149012), self._fixed_dt)
        over(math.rand(0.30000001192093), function(l_1_0)
        o:set_alpha(math.lerp(alpha, wanted_alpha, l_1_0))
         end, self._fixed_dt)
        flicker_up = not flicker_up
        alpha = l_1_0:alpha()
        wanted_alpha = math.rand(flicker_up and alpha or 0, not flicker_up and alpha or 0.30000001192093)
        do return end
      end
       -- Warning: missing end command somewhere! Added here
    end
   end
  bd_light:animate(light_flicker_animation)
end

l_0_0.enable_light = l_0_1
l_0_0 = MenuBackdropGUI
l_0_1 = function(l_12_0, l_12_1, l_12_2, l_12_3)
  local bg_layer = l_12_0._panel:child("pattern_layer")
  bg_layer:clear()
  l_12_0:_set_layers_of_layer(2, 1)
  if not l_12_1 then
    return bg_layer
  end
  local object = bg_layer:bitmap({name = "object", texture = l_12_1, blend_mode = l_12_3})
  l_12_0:set_fullscreen_bitmap_shape(object, 1.25)
  object:set_alpha(l_12_2 or 0.20000000298023)
  local mechanic_animation = function(l_1_0)
    local corner_left = -bg_layer:w() * 0.20000000298023
    local corner_right = -bg_layer:w() * 0.050000000745058
    local corner_top = -bg_layer:h() * 0.20000000298023
    local corner_bottom = -bg_layer:h() * 0.050000000745058
    local start_x = l_1_0:x()
    local start_y = l_1_0:y()
    math.random()
    math.random()
    math.random()
    math.random()
    local wanted_x = math.random(corner_left, corner_right)
    local wanted_y = math.random(corner_top, corner_bottom)
    local move_on_x_axis = wanted_x < wanted_y
    if not move_on_x_axis or not wanted_x - start_x then
      local diff = wanted_y - start_y
    end
    if diff ~= 0 or not 0 then
      local dir = diff / math.abs(diff)
    end
    if not move_on_x_axis or not math.rand(bg_layer:w() * 0.019999999552965) then
      local overshoot = math.rand(bg_layer:h() * 0.019999999552965) * dir
    end
    local dir_moved = 0
    local move_one_axis = function(l_1_0)
      if move_on_x_axis then
        o:set_x(math.lerp(start_x, wanted_x, l_1_0))
      else
        o:set_y(math.lerp(start_y, wanted_y, l_1_0))
      end
      end
    local overshoot_one_axis = function(l_2_0)
      if move_on_x_axis then
        o:set_x(math.lerp(wanted_x, wanted_x + overshoot, l_2_0))
      else
        o:set_y(math.lerp(wanted_y, wanted_y + overshoot, l_2_0))
      end
      end
    do
      local bringback_one_axis = function(l_3_0)
      if move_on_x_axis then
        o:set_x(math.lerp(wanted_x + overshoot, wanted_x, l_3_0))
      else
        o:set_y(math.lerp(wanted_y + overshoot, wanted_y, l_3_0))
      end
      end
      math.random()
      math.random()
      repeat
        wait(math.rand(0.10000000149012), self._fixed_dt)
        over(math.abs(diff / 20), move_one_axis, self._fixed_dt)
        over(math.abs(overshoot / 20), overshoot_one_axis, self._fixed_dt)
        wait(math.rand(0.10000000149012), self._fixed_dt)
        over(math.abs(overshoot / 200), bringback_one_axis, self._fixed_dt)
        dir_moved = dir_moved + 1
        if dir_moved == 2 then
          start_x = wanted_x
          start_y = wanted_y
          wanted_x = math.random(corner_left, corner_right)
          wanted_y = math.random(corner_top, corner_bottom)
          dir_moved = 0
        end
        move_on_x_axis = not move_on_x_axis
        if not move_on_x_axis or not wanted_x - start_x then
          diff = wanted_y - start_y
        end
        if diff ~= 0 or not 0 then
          dir = (diff) / math.abs(diff)
        end
        if not move_on_x_axis or not math.random(bg_layer:w() * 0.0080000003799796) then
          overshoot = math.random(bg_layer:h() * 0.0080000003799796) * (dir)
        end
        do return end
      end
       -- Warning: missing end command somewhere! Added here
    end
   end
  object:animate(mechanic_animation)
  return object
end

l_0_0.set_pattern = l_0_1
l_0_0 = MenuBackdropGUI
l_0_1 = function(l_13_0, l_13_1, l_13_2, l_13_3, l_13_4)
  local particles_layer = l_13_0._panel:child("particles_layer")
  particles_layer:clear()
  l_13_0._row = l_13_2
  l_13_0._column = l_13_3
  l_13_0._bitmap_texture = l_13_1
  l_13_0:_set_layers_of_layer(4, 1)
  for i = 1, l_13_4 do
    l_13_0:_create_particle()
  end
end

l_0_0.set_particles_object = l_0_1
l_0_0 = MenuBackdropGUI
l_0_1 = function(l_14_0)
  local particles_layer = l_14_0._panel:child("particles_layer")
  local texture_rect_x = (math.random(l_14_0._row) - 1) * 32
  local texture_rect_y = (math.random(l_14_0._column) - 1) * 32
  local particle = particles_layer:bitmap({w = 32, h = 32, texture = l_14_0._bitmap_texture, texture_rect = {texture_rect_x, texture_rect_y, 32, 32}})
  local from_longside = math.random(2) == 1
  local otherside_start = math.random(2) == 1
  local cx = (from_longside and math.random(1280)) or (otherside_start and -32) or 1312
  local cy = (not from_longside and math.random(720)) or (otherside_start and -32) or 752
  particle:set_center(cx, cy)
  particle:rotate(math.rand(180))
  local particle_animation = function(l_1_0, l_1_1)
    local start_x = l_1_0:center_x()
    local start_y = l_1_0:center_y()
    otherside_start = not otherside_start
    local end_x = (from_longside and math.random(1280)) or (otherside_start and -32) or 1312
    local end_y = (not from_longside and math.random(720)) or (otherside_start and -32) or 752
    local diff_x = end_x - start_x
    local diff_y = end_y - start_y
    local distance = diff_x * diff_x + diff_y * diff_y
    distance = math.sqrt(distance)
    local dir_x = diff_x * (1 / distance)
    local dir_y = diff_y * (1 / distance)
    local dt = 0
    local t = 0
    local seconds = distance / math.random(20, 26)
    local wave_t = 0
    local wave_length = math.random(5, 15)
    local alpha_t = math.random(90)
    local start_alpha = math.sin(alpha_t * 90) * 0.60000002384186 + 0.30000001192093
    do
      local next_alpha = start_alpha
      wait(math.rand(2), l_1_1._fixed_dt)
      repeat
        dt = coroutine.yield()
        t = t + (l_1_1._fixed_dt and 0.033333335071802 or dt)
        if seconds <= t then
          do return end
        end
        wave_t = wave_t + dt * math.rand(0.5, 1.5)
        alpha_t = alpha_t + dt * math.rand(0.25, 0.75)
        l_1_0:set_center(math.lerp(start_x, end_x, (t) / seconds), math.lerp(start_y, end_y, (t) / seconds))
        l_1_0:move(math.sin((wave_t) * 90) * -dir_y * wave_length, math.sin((wave_t) * 90) * dir_x * wave_length)
        l_1_0:set_alpha(next_alpha)
        next_alpha = math.abs(math.sin((alpha_t) * 90)) * 0.5 + 0.5
        l_1_0:set_blend_mode("add")
        do return end
        l_1_1:_remove_particle(l_1_0)
      end
       -- Warning: missing end command somewhere! Added here
    end
   end
  particle:animate(particle_animation, l_14_0)
end

l_0_0._create_particle = l_0_1
l_0_0 = MenuBackdropGUI
l_0_1 = function(l_15_0, l_15_1)
  local particles_layer = l_15_0._panel:child("particles_layer")
  particles_layer:remove(l_15_1)
  l_15_0:_create_particle()
end

l_0_0._remove_particle = l_0_1
l_0_0 = MenuBackdropGUI
l_0_1 = function(l_16_0)
  local new_layer = l_16_0._panel:child("base_layer"):panel({layer = l_16_0._layer_layers[1]})
  l_16_0:_set_layers_of_layer(1, l_16_0._layer_layers[1] + 1)
  return new_layer
end

l_0_0.get_new_base_layer = l_0_1
l_0_0 = MenuBackdropGUI
l_0_1 = function(l_17_0)
  local new_layer = l_17_0._panel:child("item_background_layer"):panel({layer = l_17_0._layer_layers[3]})
  l_17_0:_set_layers_of_layer(3, l_17_0._layer_layers[3] + 1)
  return new_layer
end

l_0_0.get_new_background_layer = l_0_1
l_0_0 = MenuBackdropGUI
l_0_1 = function(l_18_0)
  local new_layer = l_18_0._panel:child("item_foreground_layer"):panel({layer = l_18_0._layer_layers[3]})
  l_18_0:_set_layers_of_layer(6, l_18_0._layer_layers[6] + 1)
  return new_layer
end

l_0_0.get_new_foreground_layer = l_0_1
l_0_0 = MenuBackdropGUI
l_0_1 = function(l_19_0, l_19_1)
  l_19_0:_set_layers_of_layer(3, l_19_1)
end

l_0_0.set_abstract_background_layers = l_0_1
l_0_0 = MenuBackdropGUI
l_0_1 = function(l_20_0, l_20_1)
  l_20_0:_set_layers_of_layer(6, l_20_1)
end

l_0_0.set_abstract_foreground_layers = l_0_1
l_0_0 = MenuBackdropGUI
l_0_1 = function(l_21_0)
  local num_layers = l_21_0._layer_layers[1] + l_21_0._layer_layers[2]
  return num_layers, l_21_0._layer_layers[3]
end

l_0_0.background_layers = l_0_1
l_0_0 = MenuBackdropGUI
l_0_1 = function(l_22_0)
  local num_layers = l_22_0._layer_layers[1] + l_22_0._layer_layers[2] + l_22_0._layer_layers[3] + l_22_0._layer_layers[4] + l_22_0._layer_layers[5]
  return num_layers, l_22_0._layer_layers[6]
end

l_0_0.foreground_layers = l_0_1
l_0_0 = MenuBackdropGUI
l_0_1 = function(l_23_0)
  return l_23_0._panel:layer()
end

l_0_0.layer = l_0_1
l_0_0 = MenuBackdropGUI
l_0_1 = function(l_24_0, l_24_1)
  return l_24_0._panel:set_layer(l_24_1)
end

l_0_0.set_layer = l_0_1
l_0_0 = MenuBackdropGUI
l_0_1 = function(l_25_0)
  if l_25_0._panel then
    l_25_0._panel:show()
  end
  if l_25_0._blackborder_workspace then
    l_25_0._blackborder_workspace:show()
  end
end

l_0_0.show = l_0_1
l_0_0 = MenuBackdropGUI
l_0_1 = function(l_26_0)
  if l_26_0._panel then
    l_26_0._panel:hide()
  end
  if l_26_0._blackborder_workspace then
    l_26_0._blackborder_workspace:hide()
  end
end

l_0_0.hide = l_0_1
l_0_0 = MenuBackdropGUI
l_0_1 = function(l_27_0, l_27_1)
  local layer_panel = l_27_0._panel:child(l_27_1)
  if layer_panel then
    layer_panel:show()
  else
    print("MenuBackdropGUI:show_layer: Trying to show non-existing panel '" .. tostring(l_27_1) .. "'.")
  end
end

l_0_0.show_layer = l_0_1
l_0_0 = MenuBackdropGUI
l_0_1 = function(l_28_0, l_28_1)
  local layer_panel = l_28_0._panel:child(l_28_1)
  if layer_panel then
    layer_panel:hide()
  else
    print("MenuBackdropGUI:show_layer: Trying to hide non-existing panel '" .. tostring(l_28_1) .. "'.")
  end
end

l_0_0.hide_layer = l_0_1
l_0_0 = MenuBackdropGUI
l_0_1 = function(l_29_0)
  return l_29_0._panel
end

l_0_0.panel = l_0_1
l_0_0 = MenuBackdropGUI
l_0_1 = function(l_30_0)
  return l_30_0._workspace
end

l_0_0.workspace = l_0_1
l_0_0 = MenuBackdropGUI
l_0_1 = function(l_31_0)
  return l_31_0._saferect_shape
end

l_0_0.saferect_shape = l_0_1
l_0_0 = MenuBackdropGUI
l_0_1 = function(l_32_0, l_32_1)
  if not l_32_1 then
    return 
  end
  local shape = l_32_0:saferect_shape()
  l_32_1:set_shape(shape.x, shape.y, shape.w, shape.h)
end

l_0_0.set_panel_to_saferect = l_0_1
l_0_0 = MenuBackdropGUI
l_0_1 = function(l_33_0, l_33_1)
  local animate_text = function(l_1_0)
    local left = true
    local target_speed = 10
    local speed = 15
    local dt = 0
    local start_x = l_1_0:x()
    repeat
      repeat
        dt = coroutine.yield()
         -- DECOMPILER ERROR: Confused while interpreting a jump as a 'while'

      end
      speed = speed + (target_speed - speed) * dt * 20
      l_1_0:move((speed) * dt * (left and -1 or 1), 0)
    until math.abs(l_1_0:x() - start_x) > 10
    left = not left
    speed = 50
    do return end
   end
end

l_0_0.animate_bg_text = l_0_1
l_0_0 = MenuBackdropGUI
l_0_1 = function(l_34_0, l_34_1, l_34_2)
end

l_0_0.update = l_0_1
l_0_0 = MenuBackdropGUI
l_0_1 = function(l_35_0, l_35_1, l_35_2)
  local particles = l_35_0._panel:child("particles_layer")
  local fx, fy = managers.gui_data:safe_to_full_16_9(managers.gui_data, l_35_1, l_35_2)
  for _,particle in ipairs(particles:children()) do
    if not particle:has_script() and particle:inside(fx, fy) then
      particle:stop()
      local fade_anim = function(l_1_0, l_1_1)
        local alpha = l_1_0:alpha()
        over(0.20000000298023, function(l_1_0)
          o:set_alpha(math.lerp(alpha, 0, l_1_0))
            end)
        l_1_1:_remove_particle(l_1_0)
         end
      particle:animate(fade_anim, l_35_0)
      particle:script()
      return 
    end
  end
end

l_0_0.mouse_moved = l_0_1
l_0_0 = MenuBackdropGUI
l_0_1 = function(l_36_0)
  l_36_0:destroy()
end

l_0_0.close = l_0_1
l_0_0 = MenuBackdropGUI
l_0_1 = function(l_37_0)
  if l_37_0._blackborder_workspace then
    Overlay:gui():destroy_workspace(l_37_0._blackborder_workspace)
  end
  if l_37_0._my_workspace then
    Overlay:gui():destroy_workspace(l_37_0._workspace)
  else
    l_37_0._workspace:panel():remove(l_37_0._panel)
  end
  if l_37_0._resolution_changed_callback_id then
    managers.viewport:remove_resolution_changed_func(l_37_0._resolution_changed_callback_id)
  end
end

l_0_0.destroy = l_0_1

