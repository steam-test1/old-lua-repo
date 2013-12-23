-- Decompiled using luadec 2.0.1 by sztupy (http://winmo.sztupy.hu)
-- Command line was: F:\SteamLibrary\SteamApps\common\PAYDAY 2\lua\core\lib\utils\dev\ews\corecameradistancepicker.luac 

if not CoreCameraDistancePicker then
  CoreCameraDistancePicker = class()
end
CoreCameraDistancePicker.init = function(l_1_0, l_1_1, l_1_2, l_1_3)
  local sizer = EWS:BoxSizer("HORIZONTAL")
  l_1_0.__panel = EWS:Panel(l_1_1)
  l_1_0.__panel:set_sizer(sizer)
  l_1_0.__field = EWS:SpinCtrl(l_1_0.__panel, l_1_2 or "", "", "")
  l_1_0.__field:set_range(0, 100000)
  l_1_0.__field:set_min_size(l_1_0.__field:get_min_size():with_x(0))
  l_1_0.__button = EWS:Button(l_1_0.__panel, l_1_3 or "Pick", "", "BU_EXACTFIT")
  l_1_0.__button:fit_inside()
  sizer:add(l_1_0.__field, 1, 0, "EXPAND")
  sizer:add(l_1_0.__button, 0, 5, "LEFT")
  l_1_0.__button:connect("EVT_COMMAND_BUTTON_CLICKED", callback(l_1_0, l_1_0, "_enter_pick_mode"))
end

CoreCameraDistancePicker.panel = function(l_2_0)
  return l_2_0.__panel
end

CoreCameraDistancePicker.update = function(l_3_0, l_3_1, l_3_2)
  if l_3_0.__is_picking and managers.viewport then
    local picking_camera = managers.viewport:get_current_camera()
  end
  if picking_camera then
    local ray_start = picking_camera:position()
    local ray_end = l_3_0:_screen_to_world(managers.editor:cursor_pos():with_z(picking_camera:far_range()))
    local raycast = World:raycast(ray_start, ray_end)
    if raycast then
      local focus_point = Draw:pen()
      local screen_position = l_3_0:_world_to_screen(raycast.position)
      focus_point:set("screen")
      focus_point:set(Color("ff0000"))
      focus_point:circle(screen_position, 0.10000000149012)
      focus_point:line(screen_position:with_x(-1), screen_position:with_x(screen_position.x - 0.10000000149012))
      focus_point:line(screen_position:with_x(screen_position.x + 0.10000000149012), screen_position:with_x(1))
      focus_point:line(screen_position:with_y(-1), screen_position:with_y(screen_position.y - 0.10000000149012))
      focus_point:line(screen_position:with_y(screen_position.y + 0.10000000149012), screen_position:with_y(1))
      l_3_0.__field:set_value(string.format("%i", math.max(0, math.round(raycast.distance - 10))))
    end
    if EWS:MouseEvent("EVT_MOTION"):left_is_down() then
      l_3_0:_exit_pick_mode()
    end
  end
end

CoreCameraDistancePicker._screen_to_world = function(l_4_0, l_4_1)
  if managers.viewport then
    local camera = assert(managers.viewport:get_current_camera())
  end
  if managers.viewport then
    local viewport = assert(managers.viewport:get_active_vp())
  end
  local viewport_rect = viewport:get_rect()
  local viewport_position = l_4_1:with_x(l_4_1.x * 2 * viewport:get_width_multiplier() / viewport_rect.w):with_y(l_4_1.y * 2 / viewport_rect.h)
  return camera:screen_to_world(viewport_position)
end

CoreCameraDistancePicker._world_to_screen = function(l_5_0, l_5_1)
  if managers.viewport then
    local camera = assert(managers.viewport:get_current_camera())
  end
  if managers.viewport then
    local viewport = assert(managers.viewport:get_active_vp())
  end
  local viewport_rect = viewport:get_rect()
  local viewport_position = camera:world_to_screen(l_5_1)
  local screen_position = viewport_position:with_x(viewport_position.x * 2 * viewport:get_width_multiplier() / viewport_rect.w):with_y(-viewport_position.y / 2 * viewport_rect.h)
  return screen_position
end

CoreCameraDistancePicker.connect = function(l_6_0, l_6_1, l_6_2, l_6_3)
  if l_6_3 then
    l_6_0.__field:connect(l_6_1, l_6_2, l_6_3)
  else
    l_6_0.__field:connect(l_6_1, l_6_2)
  end
end

CoreCameraDistancePicker.disconnect = function(l_7_0, l_7_1, l_7_2, l_7_3)
  if l_7_3 then
    l_7_0.__field:disconnect(l_7_1, l_7_2, l_7_3)
  else
    l_7_0.__field:disconnect(l_7_1, l_7_2)
  end
end

CoreCameraDistancePicker.get_value = function(l_8_0, l_8_1)
  return l_8_0.__field:get_value(l_8_1)
end

CoreCameraDistancePicker.set_value = function(l_9_0, l_9_1)
  l_9_0.__field:set_value(l_9_1)
end

CoreCameraDistancePicker.change_value = function(l_10_0, l_10_1)
  l_10_0.__field:change_value(l_10_1)
end

CoreCameraDistancePicker.set_background_colour = function(l_11_0, l_11_1, l_11_2, l_11_3)
  l_11_0.__field:set_background_colour(l_11_1, l_11_2, l_11_3)
  l_11_0.__field:refresh()
  l_11_0.__field:update()
end

CoreCameraDistancePicker.enabled = function(l_12_0)
  return l_12_0.__field:enabled()
end

CoreCameraDistancePicker.set_enabled = function(l_13_0, l_13_1)
  l_13_0.__field:set_enabled(l_13_1)
  if l_13_1 then
    l_13_0.__button:set_enabled(not l_13_0.__pick_button_disabled)
  end
end

CoreCameraDistancePicker.set_pick_button_enabled = function(l_14_0, l_14_1)
  l_14_0.__pick_button_disabled = (l_14_1 and nil)
  if l_14_0:enabled() then
    l_14_0.__button:set_enabled(not l_14_0.__pick_button_disabled)
  end
end

CoreCameraDistancePicker.has_focus = function(l_15_0)
  return l_15_0.__is_picking or EWS:get_window_in_focus() == l_15_0.__field
end

CoreCameraDistancePicker._enter_pick_mode = function(l_16_0)
  l_16_0.__is_picking = true
end

CoreCameraDistancePicker._exit_pick_mode = function(l_17_0)
  l_17_0.__is_picking = nil
end


