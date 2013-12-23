-- Decompiled using luadec 2.0.1 by sztupy (http://winmo.sztupy.hu)
-- Command line was: F:\SteamLibrary\SteamApps\common\PAYDAY 2\lua\core\lib\managers\controller\corecontrollerwrappergamepad.luac 

core:module("CoreControllerWrapperGamepad")
core:import("CoreControllerWrapper")
if not ControllerWrapperGamepad then
  ControllerWrapperGamepad = class(CoreControllerWrapper.ControllerWrapper)
end
ControllerWrapperGamepad.TYPE = "gamepad"
local l_0_0 = ControllerWrapperGamepad
local l_0_1 = {}
 -- DECOMPILER ERROR: No list found. Setlist fails

 -- DECOMPILER ERROR: Overwrote pending register.

 -- DECOMPILER ERROR: Overwrote pending register.

l_0_1, l_0_0, l_0_0.CONTROLLER_TYPE_LIST = Idstring, ControllerWrapperGamepad, l_0_1
l_0_0.IDS_POV_0 = l_0_1
l_0_0 = ControllerWrapperGamepad
l_0_1 = Idstring
l_0_1 = l_0_1("axis")
l_0_0.IDS_AXIS = l_0_1
l_0_0 = ControllerWrapperGamepad
l_0_1 = Idstring
l_0_1 = l_0_1("range")
l_0_0.IDS_RANGE = l_0_1
l_0_0 = ControllerWrapperGamepad
l_0_1 = Idstring
l_0_1 = l_0_1("button")
l_0_0.IDS_BUTTON = l_0_1
l_0_0 = ControllerWrapperGamepad
l_0_1 = Idstring
l_0_1 = l_0_1("direction")
l_0_0.IDS_DIRECTION = l_0_1
l_0_0 = ControllerWrapperGamepad
l_0_1 = Idstring
l_0_1 = l_0_1("rotation")
l_0_0.IDS_ROTATION = l_0_1
l_0_0 = ControllerWrapperGamepad
l_0_1 = function(l_1_0, l_1_1, l_1_2, l_1_3, l_1_4, l_1_5, l_1_6, l_1_7)
  local func_map = {}
  func_map.up = callback(l_1_0, l_1_0, "virtual_connect_up")
  func_map.down = callback(l_1_0, l_1_0, "virtual_connect_down")
  func_map.right = callback(l_1_0, l_1_0, "virtual_connect_right")
  func_map.left = callback(l_1_0, l_1_0, "virtual_connect_left")
  func_map.confirm = callback(l_1_0, l_1_0, "virtual_connect_confirm")
  func_map.cancel = callback(l_1_0, l_1_0, "virtual_connect_cancel")
  func_map.axis1 = callback(l_1_0, l_1_0, "virtual_connect_axis1")
  func_map.axis2 = callback(l_1_0, l_1_0, "virtual_connect_axis2")
  ControllerWrapperGamepad.super.init(l_1_0, l_1_1, l_1_2, l_1_3, {gamepad = l_1_4, keyboard = Input:keyboard(), mouse = Input:mouse()}, "gamepad", l_1_5, l_1_6, l_1_7, {gamepad = func_map})
end

l_0_0.init = l_0_1
l_0_0 = ControllerWrapperGamepad
l_0_1 = function(l_2_0, l_2_1, l_2_2, l_2_3, l_2_4, l_2_5)
  if l_2_2:has_axis(l_2_0.IDS_POV_0) then
    l_2_0._virtual_controller:connect(l_2_2, l_2_0.IDS_AXIS, l_2_0.IDS_POV_0, 1, l_2_0.IDS_RANGE, 0, -1, l_2_0.IDS_BUTTON, Idstring(l_2_4))
  else
    l_2_1, l_2_2, l_2_3, l_2_4, l_2_5 = l_2_0:get_fallback_button(l_2_1, l_2_2, l_2_3, l_2_4, l_2_5)
    l_2_0:virtual_connect2(l_2_0, l_2_1, l_2_2, l_2_3, l_2_4, l_2_5)
  end
end

l_0_0.virtual_connect_up = l_0_1
l_0_0 = ControllerWrapperGamepad
l_0_1 = function(l_3_0, l_3_1, l_3_2, l_3_3, l_3_4, l_3_5)
  if l_3_2:has_axis(l_3_0.IDS_POV_0) then
    l_3_0._virtual_controller:connect(l_3_2, l_3_0.IDS_AXIS, l_3_0.IDS_POV_0, 1, l_3_0.IDS_RANGE, 0, 1, l_3_0.IDS_BUTTON, Idstring(l_3_4))
  else
    l_3_1, l_3_2, l_3_3, l_3_4, l_3_5 = l_3_0:get_fallback_button(l_3_1, l_3_2, l_3_3, l_3_4, l_3_5)
    l_3_0:virtual_connect2(l_3_0, l_3_1, l_3_2, l_3_3, l_3_4, l_3_5)
  end
end

l_0_0.virtual_connect_down = l_0_1
l_0_0 = ControllerWrapperGamepad
l_0_1 = function(l_4_0, l_4_1, l_4_2, l_4_3, l_4_4, l_4_5)
  if l_4_2:has_axis(l_4_0.IDS_POV_0) then
    l_4_0._virtual_controller:connect(l_4_2, l_4_0.IDS_AXIS, l_4_0.IDS_POV_0, 0, l_4_0.IDS_RANGE, 0, 1, l_4_0.IDS_BUTTON, Idstring(l_4_4))
  else
    l_4_1, l_4_2, l_4_3, l_4_4, l_4_5 = l_4_0:get_fallback_button(l_4_1, l_4_2, l_4_3, l_4_4, l_4_5)
    l_4_0:virtual_connect2(l_4_0, l_4_1, l_4_2, l_4_3, l_4_4, l_4_5)
  end
end

l_0_0.virtual_connect_right = l_0_1
l_0_0 = ControllerWrapperGamepad
l_0_1 = function(l_5_0, l_5_1, l_5_2, l_5_3, l_5_4, l_5_5)
  if l_5_2:has_axis(l_5_0.IDS_POV_0) then
    l_5_0._virtual_controller:connect(l_5_2, l_5_0.IDS_AXIS, l_5_0.IDS_POV_0, 0, l_5_0.IDS_RANGE, 0, -1, l_5_0.IDS_BUTTON, Idstring(l_5_4))
  else
    l_5_1, l_5_2, l_5_3, l_5_4, l_5_5 = l_5_0:get_fallback_button(l_5_1, l_5_2, l_5_3, l_5_4, l_5_5)
    l_5_0:virtual_connect2(l_5_0, l_5_1, l_5_2, l_5_3, l_5_4, l_5_5)
  end
end

l_0_0.virtual_connect_left = l_0_1
l_0_0 = ControllerWrapperGamepad
l_0_1 = function(l_6_0, l_6_1, l_6_2, l_6_3, l_6_4, l_6_5)
  if l_6_2:has_button(2) then
    l_6_0:virtual_connect2(l_6_0, l_6_1, l_6_2, 2, l_6_4, l_6_5)
  else
    l_6_1, l_6_2, l_6_3, l_6_4, l_6_5 = l_6_0:get_fallback_button(l_6_1, l_6_2, l_6_3, l_6_4, l_6_5)
    l_6_0:virtual_connect2(l_6_0, l_6_1, l_6_2, l_6_3, l_6_4, l_6_5)
  end
end

l_0_0.virtual_connect_confirm = l_0_1
l_0_0 = ControllerWrapperGamepad
l_0_1 = function(l_7_0, l_7_1, l_7_2, l_7_3, l_7_4, l_7_5)
  if l_7_2:has_button(1) then
    l_7_0:virtual_connect2(l_7_0, l_7_1, l_7_2, 1, l_7_4, l_7_5)
  else
    l_7_1, l_7_2, l_7_3, l_7_4, l_7_5 = l_7_0:get_fallback_button(l_7_1, l_7_2, l_7_3, l_7_4, l_7_5)
    l_7_0:virtual_connect2(l_7_0, l_7_1, l_7_2, l_7_3, l_7_4, l_7_5)
  end
end

l_0_0.virtual_connect_cancel = l_0_1
l_0_0 = ControllerWrapperGamepad
l_0_1 = function(l_8_0, l_8_1, l_8_2, l_8_3, l_8_4, l_8_5)
  l_8_3 = "direction"
  if not l_8_2:has_axis(l_8_0.IDS_DIRECTION) then
    local axes_count = l_8_2:num_axes()
    if axes_count > 0 then
      l_8_3 = l_8_2:axis_name(0)
      if axes_count > 1 and l_8_3 == "rotation" then
        l_8_3 = l_8_2:axis_name(1)
      end
    end
  end
  l_8_0:virtual_connect2(l_8_0, l_8_1, l_8_2, l_8_3, l_8_4, l_8_5)
end

l_0_0.virtual_connect_axis1 = l_0_1
l_0_0 = ControllerWrapperGamepad
l_0_1 = function(l_9_0, l_9_1, l_9_2, l_9_3, l_9_4, l_9_5)
  l_9_3 = "rotation"
  if not l_9_2:has_axis(l_9_0.IDS_ROTATION) then
    local axes_count = l_9_2:num_axes()
    if axes_count > 0 then
      l_9_3 = l_9_2:axis_name(0)
      if axes_count > 1 and l_9_3 == "direction" then
        l_9_3 = l_9_2:axis_name(1)
      end
    end
  end
  l_9_0:virtual_connect2(l_9_0, l_9_1, l_9_2, l_9_3, l_9_4, l_9_5)
end

l_0_0.virtual_connect_axis2 = l_0_1
l_0_0 = ControllerWrapperGamepad
l_0_1 = function(l_10_0, l_10_1, l_10_2, l_10_3, l_10_4, l_10_5)
  if l_10_5:get_connect_src_type() == "axis" and not l_10_2:has_axis(Idstring(l_10_3)) then
    l_10_1, l_10_2, l_10_3, l_10_4, l_10_5 = l_10_0:get_fallback_axis(l_10_1, l_10_2, l_10_3, l_10_4, l_10_5)
    do return end
    local button_index = tonumber(l_10_3)
    if not button_index or not l_10_2:has_button(button_index) then
      l_10_1, l_10_2, l_10_3, l_10_4, l_10_5 = l_10_0:get_fallback_button(l_10_1, l_10_2, l_10_3, l_10_4, l_10_5)
    else
      l_10_3 = button_index
    end
  end
  ControllerWrapperGamepad.super.virtual_connect2(l_10_0, l_10_1, l_10_2, l_10_3, l_10_4, l_10_5)
end

l_0_0.virtual_connect2 = l_0_1
l_0_0 = ControllerWrapperGamepad
l_0_1 = function(l_11_0, l_11_1, l_11_2, l_11_3, l_11_4, l_11_5)
  return "mouse", Input:mouse(), "mouse", l_11_4, l_11_5
end

l_0_0.get_fallback_axis = l_0_1
l_0_0 = ControllerWrapperGamepad
l_0_1 = function(l_12_0, l_12_1, l_12_2, l_12_3, l_12_4, l_12_5)
  l_12_2 = Input:keyboard()
  if l_12_3 == "cancel" then
    l_12_3 = "esc"
  else
    if not l_12_2:has_button(Idstring(l_12_3)) then
      l_12_3 = "enter"
    end
  end
  return "keyboard", l_12_2, l_12_3, l_12_4, l_12_5
end

l_0_0.get_fallback_button = l_0_1
l_0_0 = ControllerWrapperGamepad
l_0_1 = function(l_13_0, l_13_1)
  local cache = ControllerWrapperGamepad.super.get_input_axis(l_13_0, l_13_1)
  if l_13_1 == "look" then
    cache = Vector3(-cache.y, -cache.x, 0)
  end
  return cache
end

l_0_0.get_input_axis = l_0_1

