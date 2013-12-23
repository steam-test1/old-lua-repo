-- Decompiled using luadec 2.0.1 by sztupy (http://winmo.sztupy.hu)
-- Command line was: F:\SteamLibrary\SteamApps\common\PAYDAY 2\lua\lib\managers\mousepointermanager.luac 

if not MousePointerManager then
  MousePointerManager = class()
end
MousePointerManager.init = function(l_1_0)
  l_1_0._tweak_data = tweak_data.gui.mouse_pointer
  l_1_0:_setup()
end

MousePointerManager._setup = function(l_2_0)
  l_2_0._mouse_callbacks = {}
  l_2_0._id = 0
  l_2_0._controller_updater = nil
  l_2_0._controller_x = nil
  l_2_0._controller_y = nil
  l_2_0._test_controller_acc = nil
  l_2_0._enabled = true
  l_2_0._ws = managers.gui_data:create_fullscreen_workspace()
  local x, y = 640, 360
  l_2_0._ws:connect_mouse(Input:mouse())
  l_2_0._ws:feed_mouse_position(x, y)
   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

  l_2_0._mouse, {texture = "guis/textures/mouse_pointer", name_s = "mouse", name = "mouse", texture_rect = {0, 0, 19, 23}}.color, {texture = "guis/textures/mouse_pointer", name_s = "mouse", name = "mouse", texture_rect = {0, 0, 19, 23}}.layer, {texture = "guis/textures/mouse_pointer", name_s = "mouse", name = "mouse", texture_rect = {0, 0, 19, 23}}.h, {texture = "guis/textures/mouse_pointer", name_s = "mouse", name = "mouse", texture_rect = {0, 0, 19, 23}}.w, {texture = "guis/textures/mouse_pointer", name_s = "mouse", name = "mouse", texture_rect = {0, 0, 19, 23}}.y, {texture = "guis/textures/mouse_pointer", name_s = "mouse", name = "mouse", texture_rect = {0, 0, 19, 23}}.x = l_2_0._ws:panel():bitmap({texture = "guis/textures/mouse_pointer", name_s = "mouse", name = "mouse", texture_rect = {0, 0, 19, 23}}), Color(1, 0.69999998807907, 0.69999998807907, 0.69999998807907), tweak_data.gui.MOUSE_LAYER, 23, 19, y, x
  l_2_0._ws:hide()
  l_2_0._resolution_changed_callback_id = managers.viewport:add_resolution_changed_func(callback(l_2_0, l_2_0, "resolution_changed"))
end

MousePointerManager.resolution_changed = function(l_3_0)
  managers.gui_data:layout_fullscreen_workspace(l_3_0._ws)
end

MousePointerManager.set_pointer_image = function(l_4_0, l_4_1)
  local types = {arrow = {0, 0, 19, 23}, hand = {20, 0, 19, 23}, grab = {40, 0, 19, 23}, link = {20, 0, 19, 23}}
  local rect = types[l_4_1]
  if rect then
    l_4_0._mouse:set_texture_rect(rect[1], rect[2], rect[3], rect[4])
  end
end

MousePointerManager._scaled_size = function(l_5_0)
  return managers.gui_data:scaled_size()
end

MousePointerManager._set_size = function(l_6_0)
  local safe_rect = managers.viewport:get_safe_rect_pixels()
  local scaled_size = l_6_0:_scaled_size()
  local res = RenderSettings.resolution
  local w = scaled_size.width
  local h = scaled_size.height
  local y = res.y / 2 - res.x / w * h / 2
  local n = w / math.clamp(res.x, 0, w)
  local m = res.x / res.y
  print("safe_rect.x, y+safe_rect.y", safe_rect.x, y + safe_rect.y)
  l_6_0._ws:set_screen(w, h, 0, 0, 1279)
end

MousePointerManager.get_id = function(l_7_0)
  local id = "mouse_pointer_id" .. tostring(l_7_0._id)
  l_7_0._id = l_7_0._id + 1
  return id
end

MousePointerManager.change_mouse_to_controller = function(l_8_0, l_8_1)
  if not l_8_0._controller_updater then
    l_8_0._ws:disconnect_mouse()
    l_8_0:_deactivate()
    l_8_0._controller_x = 0
    l_8_0._controller_y = 0
    l_8_0._controller_acc_x = 0
    l_8_0._controller_acc_y = 0
    l_8_0._test_controller_acc = nil
    local update_controller_pointer = function(l_1_0, l_1_1)
      local ws = l_1_1._ws
      local mouse = l_1_1._mouse
      local confine_panel = l_1_1._confine_panel
      local convert_mouse_pos = l_1_1.convert_mouse_pos
      local max = math.max
      local min = math.min
      local move_x = 0
      local move_y = 0
      local acc = 0
      local dt = 0
      local tweak_data = l_1_1._tweak_data.controller
      local acc_speed = tweak_data.acceleration_speed
      local max_acc = tweak_data.max_acceleration
      do
        local mouse_speed = tweak_data.mouse_pointer_speed
        repeat
          if l_1_1._enabled and (l_1_1._controller_x ~= 0 or l_1_1._controller_y ~= 0) then
            l_1_1._controller_acc_x = l_1_1._controller_x * max(1, acc)
            l_1_1._controller_acc_y = -(l_1_1._controller_y * max(1, acc))
            acc = min(acc + dt * acc_speed, max_acc)
            move_x = l_1_1._controller_acc_x * mouse_speed * dt
            move_y = l_1_1._controller_acc_y * mouse_speed * dt
            if confine_panel then
              local converted_x, converted_y = convert_mouse_pos(l_1_1, mouse:world_x() + move_x, mouse:world_y() + move_y)
              local outside_left = math.max(0, confine_panel:world_left() - converted_x + 1)
              local outside_right = math.max(0, converted_x - confine_panel:world_right() + l_1_0:w() + 1)
              local outside_top = math.max(0, confine_panel:world_top() - converted_y + 1)
              local outside_bottom = math.max(0, converted_y - confine_panel:world_bottom() + l_1_0:h() + 1)
              mouse:move(outside_left - outside_right, outside_top - outside_bottom)
            end
            mouse:move(move_x, move_y)
            if l_1_1._mouse_callbacks[#l_1_1._mouse_callbacks] and l_1_1._mouse_callbacks[#l_1_1._mouse_callbacks].mouse_move then
              l_1_1._mouse_callbacks[#l_1_1._mouse_callbacks].mouse_move(mouse, mouse:x(), mouse:y(), ws)
            else
              l_1_1._controller_acc_x = 0
              l_1_1._controller_acc_y = 0
              acc = 0
            end
          end
          dt = coroutine.yield()
          do return end
        end
         -- Warning: missing end command somewhere! Added here
      end
      end
    l_8_0._ws:connect_controller(l_8_1, true)
    l_8_0._controller_updater = l_8_0._mouse:animate(update_controller_pointer, l_8_0)
    return true
  end
end

MousePointerManager.change_controller_to_mouse = function(l_9_0)
  if l_9_0._controller_updater then
    l_9_0._mouse:stop(l_9_0._controller_updater)
    l_9_0._ws:disconnect_all_controllers()
    l_9_0:_deactivate()
    l_9_0._ws:connect_mouse(Input:mouse())
    l_9_0._controller_updater = nil
    l_9_0._controller_acc_x = 0
    l_9_0._controller_acc_y = 0
    return true
  end
end

MousePointerManager.use_mouse = function(l_10_0, l_10_1, l_10_2)
  if l_10_2 then
    table.insert(l_10_0._mouse_callbacks, l_10_2, l_10_1)
  else
    table.insert(l_10_0._mouse_callbacks, l_10_1)
  end
  l_10_0:_activate()
end

MousePointerManager.remove_mouse = function(l_11_0, l_11_1)
  local removed = false
  if l_11_1 then
    for i,params in ipairs(l_11_0._mouse_callbacks) do
      if params.id == l_11_1 then
        removed = true
        table.remove(l_11_0._mouse_callbacks, i)
    else
      end
    end
    if not removed then
      table.remove(l_11_0._mouse_callbacks)
    end
    if #l_11_0._mouse_callbacks <= 0 then
      l_11_0:_deactivate()
    end
     -- Warning: missing end command somewhere! Added here
  end
end

MousePointerManager._activate = function(l_12_0)
  if l_12_0._active then
    return 
  end
  l_12_0._active = true
  l_12_0._enabled = true
  l_12_0._ws:show()
  l_12_0._ws:feed_mouse_position(l_12_0._mouse:world_position())
  if not l_12_0._controller_updater then
    l_12_0._mouse:mouse_move(callback(l_12_0, l_12_0, "_mouse_move"))
    l_12_0._mouse:mouse_press(callback(l_12_0, l_12_0, "_mouse_press"))
    l_12_0._mouse:mouse_release(callback(l_12_0, l_12_0, "_mouse_release"))
    l_12_0._mouse:mouse_click(callback(l_12_0, l_12_0, "_mouse_click"))
    l_12_0._mouse:mouse_double_click(callback(l_12_0, l_12_0, "_mouse_double_click"))
  else
    l_12_0._mouse:axis_move(callback(l_12_0, l_12_0, "_axis_move"))
    l_12_0._mouse:button_press(nil)
    l_12_0._mouse:button_release(nil)
    l_12_0._mouse:button_click(nil)
  end
end

MousePointerManager._deactivate = function(l_13_0)
  l_13_0._active = false
  l_13_0._enabled = nil
  l_13_0._ws:hide()
  l_13_0._mouse:mouse_move(nil)
  l_13_0._mouse:mouse_press(nil)
  l_13_0._mouse:mouse_release(nil)
  l_13_0._mouse:mouse_click(nil)
  l_13_0._mouse:mouse_double_click(nil)
  l_13_0._mouse:axis_move(nil)
  l_13_0._mouse:button_press(nil)
  l_13_0._mouse:button_release(nil)
  l_13_0._mouse:button_click(nil)
end

MousePointerManager.enable = function(l_14_0)
  if l_14_0._active then
    l_14_0._ws:show()
  end
  l_14_0._enabled = true
end

MousePointerManager.disable = function(l_15_0)
  if l_15_0._active then
    l_15_0._ws:hide()
  end
  l_15_0._enabled = false
end

MousePointerManager.confine_mouse_pointer = function(l_16_0, l_16_1)
  l_16_0._confine_panel = l_16_1
end

MousePointerManager.release_mouse_pointer = function(l_17_0)
  l_17_0._confine_panel = nil
end

MousePointerManager.mouse_move_x = function(l_18_0)
  return l_18_0._controller_acc_x
end

MousePointerManager.mouse_move_y = function(l_19_0)
  return l_19_0._controller_acc_y
end

MousePointerManager._mouse_move = function(l_20_0, l_20_1, l_20_2, l_20_3)
  l_20_1:set_position(l_20_2, l_20_3)
  if l_20_0._mouse_callbacks[#l_20_0._mouse_callbacks] and l_20_0._mouse_callbacks[#l_20_0._mouse_callbacks].mouse_move then
    l_20_0._mouse_callbacks[#l_20_0._mouse_callbacks].mouse_move(l_20_1, l_20_2, l_20_3, l_20_0._ws)
  end
end

MousePointerManager._mouse_press = function(l_21_0, l_21_1, l_21_2, l_21_3, l_21_4)
  if l_21_0._mouse_callbacks[#l_21_0._mouse_callbacks] and l_21_0._mouse_callbacks[#l_21_0._mouse_callbacks].mouse_press then
    l_21_0._mouse_callbacks[#l_21_0._mouse_callbacks].mouse_press(l_21_1, l_21_2, l_21_3, l_21_4)
  end
end

MousePointerManager._mouse_release = function(l_22_0, l_22_1, l_22_2, l_22_3, l_22_4)
  if l_22_0._mouse_callbacks[#l_22_0._mouse_callbacks] and l_22_0._mouse_callbacks[#l_22_0._mouse_callbacks].mouse_release then
    l_22_0._mouse_callbacks[#l_22_0._mouse_callbacks].mouse_release(l_22_1, l_22_2, l_22_3, l_22_4)
  end
end

MousePointerManager._mouse_click = function(l_23_0, l_23_1, l_23_2, l_23_3, l_23_4)
  if l_23_0._mouse_callbacks[#l_23_0._mouse_callbacks] and l_23_0._mouse_callbacks[#l_23_0._mouse_callbacks].mouse_click then
    l_23_0._mouse_callbacks[#l_23_0._mouse_callbacks].mouse_click(l_23_1, l_23_2, l_23_3, l_23_4)
  end
end

MousePointerManager._mouse_double_click = function(l_24_0, l_24_1, l_24_2, l_24_3, l_24_4)
  if l_24_0._mouse_callbacks[#l_24_0._mouse_callbacks] and l_24_0._mouse_callbacks[#l_24_0._mouse_callbacks].mouse_double_click then
    l_24_0._mouse_callbacks[#l_24_0._mouse_callbacks].mouse_double_click(l_24_1, l_24_2, l_24_3, l_24_4)
  end
end

MousePointerManager._axis_move = function(l_25_0, l_25_1, l_25_2, l_25_3, l_25_4)
  if not l_25_0._test_controller_acc then
    l_25_0._test_controller_acc = {}
  end
  l_25_0._test_controller_acc[l_25_2:key()] = l_25_3
  l_25_0._controller_x = 0
  l_25_0._controller_y = 0
  for i,axis in pairs(l_25_0._test_controller_acc) do
    l_25_0._controller_x = l_25_0._controller_x + axis.x
    l_25_0._controller_y = l_25_0._controller_y + axis.y
  end
end

MousePointerManager._button_press = function(l_26_0, l_26_1, l_26_2, l_26_3)
  if l_26_0._mouse_callbacks[#l_26_0._mouse_callbacks] and l_26_0._mouse_callbacks[#l_26_0._mouse_callbacks].mouse_press then
    l_26_0._mouse_callbacks[#l_26_0._mouse_callbacks].mouse_press(l_26_1, l_26_2, l_26_1:x(), l_26_1:y())
  end
end

MousePointerManager._button_release = function(l_27_0, l_27_1, l_27_2, l_27_3)
  if l_27_0._mouse_callbacks[#l_27_0._mouse_callbacks] and l_27_0._mouse_callbacks[#l_27_0._mouse_callbacks].mouse_release then
    l_27_0._mouse_callbacks[#l_27_0._mouse_callbacks].mouse_release(l_27_1, l_27_2, l_27_1:x(), l_27_1:y())
  end
end

MousePointerManager._button_click = function(l_28_0, l_28_1, l_28_2, l_28_3)
  if l_28_0._mouse_callbacks[#l_28_0._mouse_callbacks] and l_28_0._mouse_callbacks[#l_28_0._mouse_callbacks].mouse_click then
    l_28_0._mouse_callbacks[#l_28_0._mouse_callbacks].mouse_click(l_28_1, l_28_2, l_28_1:x(), l_28_1:y())
  end
end

MousePointerManager.set_mouse_world_position = function(l_29_0, l_29_1, l_29_2)
  l_29_0._mouse:set_world_position(l_29_1, l_29_2)
  l_29_0._ws:feed_mouse_position(l_29_0._mouse:world_position())
end

MousePointerManager.force_move_mouse_pointer = function(l_30_0, l_30_1, l_30_2)
  l_30_0._mouse:move(l_30_1, l_30_2)
  l_30_0._ws:feed_mouse_position(l_30_0._mouse:world_position())
end

MousePointerManager.mouse = function(l_31_0)
  return l_31_0._mouse
end

MousePointerManager.world_position = function(l_32_0)
  return l_32_0._mouse:world_position()
end

MousePointerManager.convert_mouse_pos = function(l_33_0, l_33_1, l_33_2)
  return managers.gui_data:full_to_safe(l_33_1, l_33_2)
end

MousePointerManager.modified_mouse_pos = function(l_34_0)
  local x, y = l_34_0._mouse:world_position()
  return l_34_0:convert_mouse_pos(x, y)
end

MousePointerManager.convert_fullscreen_mouse_pos = function(l_35_0, l_35_1, l_35_2)
  return l_35_1, l_35_2
end

MousePointerManager.convert_fullscreen_16_9_mouse_pos = function(l_36_0, l_36_1, l_36_2)
  l_36_2 = l_36_2 - managers.gui_data:full_16_9_size(managers.gui_data).y
  return l_36_1, l_36_2
end

MousePointerManager.modified_fullscreen_mouse_pos = function(l_37_0, l_37_1, l_37_2)
  local x, y = l_37_0._mouse:world_position()
  return l_37_0:convert_fullscreen_mouse_pos(x, y)
end

MousePointerManager.modified_fullscreen_16_9_mouse_pos = function(l_38_0, l_38_1, l_38_2)
  local x, y = l_38_0._mouse:world_position()
  return l_38_0:convert_fullscreen_16_9_mouse_pos(l_38_0, x, y)
end


