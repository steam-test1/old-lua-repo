-- Decompiled using luadec 2.0.1 by sztupy (http://winmo.sztupy.hu)
-- Command line was: F:\SteamLibrary\SteamApps\common\PAYDAY 2\lua\core\lib\managers\menu\reference_input\coremenuinput.luac 

core:module("CoreMenuInput")
core:import("CoreDebug")
core:import("CoreMenuItem")
core:import("CoreMenuItemSlider")
core:import("CoreMenuItemToggle")
if not MenuInput then
  MenuInput = class()
end
MenuInput.init = function(l_1_0, l_1_1, l_1_2)
  l_1_0._logic = l_1_1
  l_1_0._menu_name = l_1_2
  l_1_0._accept_input = true
  l_1_0._logic:register_callback("input_accept_input", callback(l_1_0, l_1_0, "accept_input"))
  l_1_0._axis_delay_timer = {}
  l_1_0._axis_delay_timer.x = 0
  l_1_0._axis_delay_timer.y = 0
  l_1_0._item_input_action_map = {}
  l_1_0._item_input_action_map[CoreMenuItem.Item.TYPE] = callback(l_1_0, l_1_0, "input_item")
  l_1_0._item_input_action_map[CoreMenuItemSlider.ItemSlider.TYPE] = callback(l_1_0, l_1_0, "input_slider")
  l_1_0._item_input_action_map[CoreMenuItemToggle.ItemToggle.TYPE] = callback(l_1_0, l_1_0, "input_toggle")
end

MenuInput.open = function(l_2_0, ...)
  l_2_0:create_controller()
   -- DECOMPILER ERROR: Confused about usage of registers for local variables.

end

MenuInput.close = function(l_3_0)
  l_3_0:destroy_controller()
end

MenuInput.axis_timer = function(l_4_0)
  return l_4_0._axis_delay_timer
end

MenuInput.set_axis_x_timer = function(l_5_0, l_5_1)
  l_5_0._axis_delay_timer.x = l_5_1
end

MenuInput.set_axis_y_timer = function(l_6_0, l_6_1)
  l_6_0._axis_delay_timer.y = l_6_1
end

MenuInput._input_hijacked = function(l_7_0)
  local active_menu = managers.menu:active_menu()
  if active_menu then
    return active_menu.renderer:input_focus()
  end
end

MenuInput.input_item = function(l_8_0, l_8_1, l_8_2, l_8_3)
  if l_8_2:get_input_pressed("confirm") or l_8_3 then
    if l_8_1:parameters().sign_in then
      print("requires sign in")
      local f = function(l_1_0)
        print(l_1_0)
        if l_1_0 then
          self._logic:trigger_item(true, item)
          self:select_node()
        end
         end
      managers.menu:open_sign_in_menu(f)
    else
      local node_gui = managers.menu:active_menu().renderer:active_node_gui()
      if node_gui and node_gui._listening_to_input then
        return 
      end
      l_8_0._logic:trigger_item(true, l_8_1)
      l_8_0:select_node()
    end
  end
end

MenuInput.input_slider = function(l_9_0, l_9_1, l_9_2)
  local slider_delay_down = 0.10000000149012
  local slider_delay_pressed = 0.20000000298023
  if l_9_0:menu_right_input_bool() then
    l_9_1:increase()
    l_9_0._logic:trigger_item(true, l_9_1)
    l_9_0:set_axis_x_timer(slider_delay_down)
    if l_9_0:menu_right_pressed() then
      local percentage = l_9_1:percentage()
      if percentage > 0 and percentage < 100 then
        l_9_0:post_event("slider_increase")
      end
      l_9_0:set_axis_x_timer(slider_delay_pressed)
    else
      if l_9_0:menu_left_input_bool() then
        l_9_1:decrease()
        l_9_0._logic:trigger_item(true, l_9_1)
        l_9_0:set_axis_x_timer(slider_delay_down)
        if l_9_0:menu_left_pressed() then
          l_9_0:set_axis_x_timer(slider_delay_pressed)
          local percentage = l_9_1:percentage()
          if percentage > 0 and percentage < 100 then
            l_9_0:post_event("slider_decrease")
          end
        end
      end
    end
  end
end

MenuInput.input_toggle = function(l_10_0, l_10_1, l_10_2, l_10_3)
  local toggle_delay_down = 0.30000001192093
  local toggle_delay_pressed = 0.60000002384186
  if l_10_2:get_input_pressed("confirm") or l_10_3 then
    l_10_1:toggle()
    l_10_0._logic:trigger_item(true, l_10_1)
  end
end

MenuInput.update = function(l_11_0, l_11_1, l_11_2)
  l_11_0:_check_releases()
  l_11_0:any_keyboard_used()
  local axis_timer = l_11_0:axis_timer()
  if axis_timer.y > 0 then
    l_11_0:set_axis_y_timer(axis_timer.y - l_11_2)
  end
  if axis_timer.x > 0 then
    l_11_0:set_axis_x_timer(axis_timer.x - l_11_2)
  end
  if l_11_0:_input_hijacked() then
    return false
  end
  if l_11_0._accept_input and l_11_0._controller then
    if axis_timer.y <= 0 then
      if l_11_0:menu_up_input_bool() then
        l_11_0:prev_item()
        l_11_0:set_axis_y_timer(0.11999999731779)
        if l_11_0:menu_up_pressed() then
          l_11_0:set_axis_y_timer(0.30000001192093)
        else
          if l_11_0:menu_down_input_bool() then
            l_11_0:next_item()
            l_11_0:set_axis_y_timer(0.11999999731779)
            if l_11_0:menu_down_pressed() then
              l_11_0:set_axis_y_timer(0.30000001192093)
            end
          end
        end
      end
    end
    if axis_timer.x <= 0 then
      local item = l_11_0._logic:selected_item()
      if item then
        l_11_0._item_input_action_map[item.TYPE](item, l_11_0._controller)
      end
    end
    if l_11_0._controller:get_input_pressed("menu_update") then
      print("update something")
      l_11_0._logic:update_node()
    end
  end
  return true
end

MenuInput.menu_up_input_bool = function(l_12_0)
  if l_12_0._controller then
    return l_12_0._controller:get_input_bool("menu_up")
  end
  return false
end

MenuInput.menu_up_pressed = function(l_13_0)
  if l_13_0._controller then
    return l_13_0._controller:get_input_pressed("menu_up")
  end
  return false
end

MenuInput.menu_up_released = function(l_14_0)
  if l_14_0._controller then
    return l_14_0._controller:get_input_released("menu_up")
  end
  return false
end

MenuInput.menu_down_input_bool = function(l_15_0)
  if l_15_0._controller then
    return l_15_0._controller:get_input_bool("menu_down")
  end
  return false
end

MenuInput.menu_down_pressed = function(l_16_0)
  if l_16_0._controller then
    return l_16_0._controller:get_input_pressed("menu_down")
  end
  return false
end

MenuInput.menu_down_released = function(l_17_0)
  if l_17_0._controller then
    return l_17_0._controller:get_input_released("menu_down")
  end
  return false
end

MenuInput.menu_left_input_bool = function(l_18_0)
  if l_18_0._controller then
    return l_18_0._controller:get_input_bool("menu_left")
  end
  return false
end

MenuInput.menu_left_pressed = function(l_19_0)
  if l_19_0._controller then
    return l_19_0._controller:get_input_pressed("menu_left")
  end
  return false
end

MenuInput.menu_left_released = function(l_20_0)
  if l_20_0._controller then
    return l_20_0._controller:get_input_released("menu_left")
  end
  return false
end

MenuInput.menu_right_input_bool = function(l_21_0)
  if l_21_0._controller then
    return l_21_0._controller:get_input_bool("menu_right")
  end
  return false
end

MenuInput.menu_right_pressed = function(l_22_0)
  if l_22_0._controller then
    return l_22_0._controller:get_input_pressed("menu_right")
  end
  return false
end

MenuInput.menu_right_released = function(l_23_0)
  if l_23_0._controller then
    return l_23_0._controller:get_input_released("menu_right")
  end
  return false
end

MenuInput._check_releases = function(l_24_0)
  if l_24_0:menu_left_released() or l_24_0:menu_right_released() then
    l_24_0:set_axis_x_timer(0.0099999997764826)
  end
  if l_24_0:menu_up_released() or l_24_0:menu_down_released() then
    l_24_0:set_axis_y_timer(0.0099999997764826)
  end
end

MenuInput.accept_input = function(l_25_0, l_25_1)
  l_25_0._accept_input = l_25_1
end

MenuInput.focus = function(l_26_0, l_26_1)
  if l_26_1 then
    l_26_0:create_controller()
  else
    l_26_0:destroy_controller()
  end
end

MenuInput.create_controller = function(l_27_0)
  if not l_27_0._controller then
    local controller = managers.controller:create_controller("" .. tostring(TimerManager:wall():time()), nil, false)
    controller:add_trigger("cancel", callback(l_27_0, l_27_0, "back"))
    controller:set_enabled(true)
    l_27_0._controller = controller
  end
end

MenuInput.destroy_controller = function(l_28_0)
  if l_28_0._controller then
    l_28_0._controller:destroy()
    l_28_0._controller = nil
  end
end

MenuInput.logic_changed = function(l_29_0)
end

MenuInput.next_item = function(l_30_0)
  if not l_30_0._accept_input then
    return 
  end
  local current_item = l_30_0._logic:selected_item()
  if current_item then
    local current_item_name = current_item:parameters().name
    local items = (l_30_0._logic:selected_node():items())
    local done = nil
    for i,v in ipairs(items) do
      if v:parameters().name == current_item_name then
        for check = 1, #items - 1 do
          local next_item = items[(i + check - 1) % #items + 1]
          if next_item:visible() and next_item.TYPE ~= "divider" then
            l_30_0._logic:select_item(next_item:parameters().name, true)
            done = true
        else
          end
        end
    else
      if done then
        end
      end
       -- Warning: missing end command somewhere! Added here
    end
     -- Warning: missing end command somewhere! Added here
  end
end

MenuInput.prev_item = function(l_31_0)
  local current_item = l_31_0._logic:selected_item()
  if current_item then
    local current_item_name = current_item:parameters().name
    local items = (l_31_0._logic:selected_node():items())
    local done = nil
    for i,v in ipairs(items) do
      if v:parameters().name == current_item_name then
        for check = 1, #items - 1 do
          local prev_item = items[(i - check - 1) % #items + 1]
          if prev_item:visible() and prev_item.TYPE ~= "divider" then
            l_31_0._logic:select_item(prev_item:parameters().name, true)
            done = true
        else
          end
        end
    else
      if done then
        end
      end
       -- Warning: missing end command somewhere! Added here
    end
     -- Warning: missing end command somewhere! Added here
  end
end

MenuInput.back = function(l_32_0, l_32_1, l_32_2)
  if l_32_0:_input_hijacked() == true then
    return 
  end
  if l_32_0._logic:selected_node() and l_32_0._logic:selected_node():parameters().block_back then
    return 
  end
  l_32_0._logic:navigate_back((l_32_1 ~= true and false), type(l_32_2) == "number" and l_32_2 or false)
end

MenuInput.select_node = function(l_33_0)
  local item = l_33_0._logic:selected_item()
  if item and item:visible() then
    local parameters = item:parameters()
    if parameters.next_node then
      if not parameters.next_node_parameters then
        l_33_0._logic:select_node(parameters.next_node, true, unpack({}))
      end
    end
    if parameters.previous_node then
      l_33_0:back()
    end
  end
end

MenuInput.any_keyboard_used = function(l_34_0)
  if l_34_0._keyboard_used or not l_34_0._controller or managers.controller:get_default_wrapper_type() ~= "pc" then
    return 
  end
  for _,key in ipairs({"menu_right", "menu_left", "menu_up", "menu_down", "confirm"}) do
    if l_34_0._controller:get_input_bool(key) then
      l_34_0._keyboard_used = true
      return 
    end
  end
end


