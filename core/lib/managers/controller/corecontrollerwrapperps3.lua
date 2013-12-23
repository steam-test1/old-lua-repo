-- Decompiled using luadec 2.0.1 by sztupy (http://winmo.sztupy.hu)
-- Command line was: F:\SteamLibrary\SteamApps\common\PAYDAY 2\lua\core\lib\managers\controller\corecontrollerwrapperps3.luac 

core:module("CoreControllerWrapperPS3")
core:import("CoreControllerWrapper")
if not ControllerWrapperPS3 then
  ControllerWrapperPS3 = class(CoreControllerWrapper.ControllerWrapper)
end
ControllerWrapperPS3.TYPE = "ps3"
ControllerWrapperPS3.CONTROLLER_TYPE_LIST = {"ps3_controller"}
ControllerWrapperPS3.init = function(l_1_0, l_1_1, l_1_2, l_1_3, l_1_4, l_1_5, l_1_6, l_1_7)
  local func_map = {}
  func_map.confirm = callback(l_1_0, l_1_0, "virtual_connect_confirm")
  func_map.cancel = callback(l_1_0, l_1_0, "virtual_connect_cancel")
  ControllerWrapperPS3.super.init(l_1_0, l_1_1, l_1_2, l_1_3, {ps3pad = l_1_4}, "ps3pad", l_1_5, l_1_6, l_1_7, {ps3pad = func_map})
end

ControllerWrapperPS3.virtual_connect_confirm = function(l_2_0, l_2_1, l_2_2, l_2_3, l_2_4, l_2_5)
  if l_2_0:is_confirm_cancel_inverted() then
    l_2_3 = "circle"
  else
    l_2_3 = "cross"
  end
  l_2_0:virtual_connect2(l_2_0, l_2_1, l_2_2, l_2_3, l_2_4, l_2_5)
end

ControllerWrapperPS3.virtual_connect_cancel = function(l_3_0, l_3_1, l_3_2, l_3_3, l_3_4, l_3_5)
  if l_3_0:is_confirm_cancel_inverted() then
    l_3_3 = "cross"
  else
    l_3_3 = "circle"
  end
  l_3_0:virtual_connect2(l_3_0, l_3_1, l_3_2, l_3_3, l_3_4, l_3_5)
end

local is_PS3 = SystemInfo:platform() == Idstring("PS3")
ControllerWrapperPS3.is_confirm_cancel_inverted = function(l_4_0)
  if is_PS3 then
    return PS3:pad_cross_circle_inverted()
  end
end


