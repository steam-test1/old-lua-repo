-- Decompiled using luadec 2.0.1 by sztupy (http://winmo.sztupy.hu)
-- Command line was: F:\SteamLibrary\SteamApps\common\PAYDAY 2\lua\lib\managers\dialogs\genericdialog.luac 

core:module("SystemMenuManager")
require("lib/managers/dialogs/Dialog")
if not GenericDialog then
  GenericDialog = class(Dialog)
end
GenericDialog.FADE_IN_DURATION = 0.20000000298023
GenericDialog.FADE_OUT_DURATION = 0.20000000298023
GenericDialog.MOVE_AXIS_LIMIT = 0.40000000596046
GenericDialog.MOVE_AXIS_DELAY = 0.40000000596046
GenericDialog.init = function(l_1_0, l_1_1, l_1_2, l_1_3)
  Dialog.init(l_1_0, l_1_1, l_1_2)
  if not l_1_0._data.focus_button then
    if #l_1_0._button_text_list > 0 then
      l_1_0._data.focus_button = #l_1_0._button_text_list
    else
      l_1_0._data.focus_button = 1
    end
  end
  if not l_1_0._data.ws then
    l_1_0._ws = l_1_1:_get_ws()
  end
   -- DECOMPILER ERROR: Confused while interpreting a jump as a 'while'

end
l_1_0._panel_script = _G.TextBoxGui:new(l_1_0._ws, l_1_0._data.title or "", l_1_0._data.text or "", l_1_0._data, {type = "system_menu", no_close_legend = true, use_indicator = l_1_2.no_buttons, is_title_outside = l_1_3})
l_1_0._panel_script:add_background()
l_1_0._panel_script:set_layer(_G.tweak_data.gui.DIALOG_LAYER)
l_1_0._panel_script:set_centered()
l_1_0._panel_script:set_fade(0)
if not l_1_0._data.controller then
  l_1_0._controller = l_1_1:_get_controller()
end
l_1_0._confirm_func = callback(l_1_0, l_1_0, "button_pressed_callback")
l_1_0._cancel_func = callback(l_1_0, l_1_0, "dialog_cancel_callback")
l_1_0._resolution_changed_callback = callback(l_1_0, l_1_0, "resolution_changed_callback")
managers.viewport:add_resolution_changed_func(l_1_0._resolution_changed_callback)
if l_1_2.counter then
  l_1_0._counter = l_1_2.counter
  l_1_0._counter_time = l_1_0._counter[1]
end
end

GenericDialog.set_text = function(l_2_0, l_2_1, l_2_2)
  l_2_0._panel_script:set_text(l_2_1, l_2_2)
end

GenericDialog.set_title = function(l_3_0, l_3_1, l_3_2)
  l_3_0._panel_script:set_title(l_3_1, l_3_2)
end

GenericDialog.mouse_moved = function(l_4_0, l_4_1, l_4_2, l_4_3)
  if l_4_0._panel_script:moved_scroll_bar(l_4_2, l_4_3) then
    return 
  end
  l_4_2, l_4_3 = managers.mouse_pointer:convert_fullscreen_mouse_pos(l_4_2, l_4_3)
  for i,panel in ipairs(l_4_0._panel_script._text_box_buttons_panel:children()) do
    if panel.child and panel:inside(l_4_2, l_4_3) then
      l_4_0._panel_script:set_focus_button(i)
    end
  end
end

GenericDialog.mouse_pressed = function(l_5_0, l_5_1, l_5_2, l_5_3, l_5_4)
  if l_5_2 == Idstring("0") then
    local x, y = managers.mouse_pointer:convert_fullscreen_mouse_pos(l_5_3, l_5_4)
    if l_5_0._panel_script:check_grab_scroll_bar(x, y) then
      return 
    end
    for i,panel in ipairs(l_5_0._panel_script._text_box_buttons_panel:children()) do
      if panel.child and panel:inside(x, y) then
        l_5_0:button_pressed_callback()
        return 
      end
    end
  else
    if l_5_2 == Idstring("mouse wheel down") then
      return l_5_0._panel_script:mouse_wheel_down(l_5_3, l_5_4)
    else
      if l_5_2 == Idstring("mouse wheel up") then
        return l_5_0._panel_script:mouse_wheel_up(l_5_3, l_5_4)
      end
    end
     -- Warning: missing end command somewhere! Added here
  end
end

GenericDialog.mouse_released = function(l_6_0, l_6_1, l_6_2, l_6_3, l_6_4)
  l_6_0._panel_script:release_scroll_bar()
end

GenericDialog.update = function(l_7_0, l_7_1, l_7_2)
  if l_7_0._fade_in_time then
    local alpha = math.clamp((l_7_1 - l_7_0._fade_in_time) / l_7_0.FADE_IN_DURATION, 0, 1)
    l_7_0._panel_script:set_fade(alpha)
    if alpha == 1 then
      l_7_0:set_input_enabled(true)
      l_7_0._fade_in_time = nil
    end
  end
  if l_7_0._fade_out_time then
    local alpha = math.clamp(1 - (l_7_1 - l_7_0._fade_out_time) / l_7_0.FADE_OUT_DURATION, 0, 1)
    l_7_0._panel_script:set_fade(alpha)
    if alpha == 0 then
      l_7_0._fade_out_time = nil
      l_7_0:close()
    end
  end
  if l_7_0._input_enabled then
    l_7_0:update_input(l_7_1, l_7_2)
  end
  l_7_0._panel_script:update_indicator(l_7_1, l_7_2)
  if alive(l_7_0._panel_script.indicator) then
    l_7_0._panel_script.indicator:rotate(180 * l_7_2)
  end
  if l_7_0._counter then
    l_7_0._counter_time = l_7_0._counter_time - l_7_2
    if l_7_0._counter_time < 0 then
      l_7_0._counter_time = l_7_0._counter_time + l_7_0._counter[1]
      l_7_0._counter[2]()
    end
  end
  if managers.menu_component then
    local x, y = managers.menu_component:get_right_controller_axis()
    if y > 0 then
      l_7_0._panel_script:scroll_up(y * 2)
    elseif y < 0 then
      l_7_0._panel_script:scroll_down(math.abs(y) * 2)
    end
  end
end

GenericDialog.update_input = function(l_8_0, l_8_1, l_8_2)
  if l_8_0._data.no_buttons then
    return 
  end
  local dir, move_time = nil, nil
  local move = l_8_0._controller:get_input_axis("menu_move")
  if l_8_0._controller:get_input_bool("menu_down") or l_8_0.MOVE_AXIS_LIMIT < move.y then
    dir = 1
  else
    if l_8_0._controller:get_input_bool("menu_up") or move.y < -l_8_0.MOVE_AXIS_LIMIT then
      dir = -1
    end
  end
  if l_8_0._move_button_dir == dir and l_8_0._move_button_time and l_8_1 < l_8_0._move_button_time + l_8_0.MOVE_AXIS_DELAY then
    if not l_8_0._move_button_time then
      move_time = not dir or l_8_1
    end
  else
    l_8_0._panel_script:change_focus_button(dir)
    move_time = l_8_1
  end
  l_8_0._move_button_dir = dir
  l_8_0._move_button_time = move_time
  local scroll = l_8_0._controller:get_input_axis("menu_scroll")
  if l_8_0.MOVE_AXIS_LIMIT < scroll.y then
    l_8_0._panel_script:scroll_up()
  else
    if scroll.y < -l_8_0.MOVE_AXIS_LIMIT then
      l_8_0._panel_script:scroll_down()
    end
  end
end

GenericDialog.set_input_enabled = function(l_9_0, l_9_1)
  if not l_9_0._input_enabled ~= not l_9_1 then
    if l_9_1 then
      l_9_0._controller:add_trigger("confirm", l_9_0._confirm_func)
      if managers.controller:get_default_wrapper_type() == "pc" then
        l_9_0._controller:add_trigger("toggle_menu", l_9_0._cancel_func)
        l_9_0._mouse_id = managers.mouse_pointer:get_id()
        l_9_0._removed_mouse = nil
        local data = {}
        data.mouse_move = callback(l_9_0, l_9_0, "mouse_moved")
        data.mouse_press = callback(l_9_0, l_9_0, "mouse_pressed")
        data.mouse_release = callback(l_9_0, l_9_0, "mouse_released")
        data.id = l_9_0._mouse_id
        managers.mouse_pointer:use_mouse(data)
      else
        l_9_0._removed_mouse = nil
        l_9_0._controller:add_trigger("cancel", l_9_0._cancel_func)
        managers.mouse_pointer:disable()
      end
    else
      l_9_0._panel_script:release_scroll_bar()
      l_9_0._controller:remove_trigger("confirm", l_9_0._confirm_func)
      if managers.controller:get_default_wrapper_type() == "pc" then
        l_9_0._controller:remove_trigger("toggle_menu", l_9_0._cancel_func)
      else
        l_9_0._controller:remove_trigger("cancel", l_9_0._cancel_func)
      end
      l_9_0:remove_mouse()
    end
  end
  l_9_0._input_enabled = l_9_1
end
end

GenericDialog.fade_in = function(l_10_0)
  l_10_0._fade_in_time = TimerManager:main():time()
end

GenericDialog.fade_out_close = function(l_11_0)
  managers.menu:post_event("prompt_exit")
  l_11_0:fade_out()
end

GenericDialog.fade_out = function(l_12_0)
  l_12_0._fade_out_time = TimerManager:main():time()
  if managers.menu:active_menu() then
    managers.menu:active_menu().renderer:disable_input(0.20000000298023)
  end
  l_12_0:set_input_enabled(false)
end

GenericDialog.is_closing = function(l_13_0)
  return l_13_0._fade_out_time ~= nil
end

GenericDialog.show = function(l_14_0)
  managers.menu:post_event("prompt_enter")
  l_14_0._manager:event_dialog_shown(l_14_0)
  return true
end

GenericDialog.hide = function(l_15_0)
  l_15_0:set_input_enabled(false)
  l_15_0._fade_in_time = nil
  l_15_0._panel_script:set_fade(0)
  l_15_0._manager:event_dialog_hidden(l_15_0)
end

GenericDialog.close = function(l_16_0)
  l_16_0:set_input_enabled(false)
  l_16_0._panel_script:close()
  managers.viewport:remove_resolution_changed_func(l_16_0._resolution_changed_callback)
  Dialog.close(l_16_0)
end

GenericDialog.dialog_cancel_callback = function(l_17_0)
  if SystemInfo:platform() ~= Idstring("WIN32") then
    return 
  end
  if l_17_0._data.no_buttons then
    return 
  end
  if #l_17_0._data.button_list == 1 then
    l_17_0:remove_mouse()
    l_17_0:button_pressed(1)
  end
  for i,btn in ipairs(l_17_0._data.button_list) do
    if btn.cancel_button then
      l_17_0:remove_mouse()
      l_17_0:button_pressed(i)
      return 
    end
  end
end

GenericDialog.button_pressed_callback = function(l_18_0)
  if l_18_0._data.no_buttons then
    return 
  end
  l_18_0:remove_mouse()
  l_18_0:button_pressed(l_18_0._panel_script:get_focus_button())
end

GenericDialog.remove_mouse = function(l_19_0)
  if not l_19_0._removed_mouse then
    l_19_0._removed_mouse = true
    if managers.controller:get_default_wrapper_type() == "pc" then
      managers.mouse_pointer:remove_mouse(l_19_0._mouse_id)
    else
      managers.mouse_pointer:enable()
      l_19_0._mouse_id = nil
    end
     -- Warning: missing end command somewhere! Added here
  end
end

GenericDialog.resolution_changed_callback = function(l_20_0)
end


