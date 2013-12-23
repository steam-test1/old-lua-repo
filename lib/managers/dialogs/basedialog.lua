-- Decompiled using luadec 2.0.1 by sztupy (http://winmo.sztupy.hu)
-- Command line was: F:\SteamLibrary\SteamApps\common\PAYDAY 2\lua\lib\managers\dialogs\basedialog.luac 

core:module("SystemMenuManager")
core:import("CoreDebug")
if not BaseDialog then
  BaseDialog = class()
end
BaseDialog.init = function(l_1_0, l_1_1, l_1_2)
  l_1_0._manager = l_1_1
  if not l_1_2 then
    l_1_0._data = {}
  end
end

BaseDialog.id = function(l_2_0)
  return l_2_0._data.id
end

BaseDialog.priority = function(l_3_0)
  return l_3_0._data.priority or 0
end

BaseDialog.get_platform_id = function(l_4_0)
  return managers.user:get_platform_id(l_4_0._data.user_index) or 0
end

BaseDialog.is_generic = function(l_5_0)
  return l_5_0._data.is_generic
end

BaseDialog.fade_in = function(l_6_0)
end

BaseDialog.fade_out_close = function(l_7_0)
  l_7_0:close()
end

BaseDialog.fade_out = function(l_8_0)
  l_8_0:close()
end

BaseDialog.close = function(l_9_0)
  l_9_0._manager:event_dialog_closed(l_9_0)
end

BaseDialog.is_closing = function(l_10_0)
  return false
end

BaseDialog.show = function(l_11_0)
  Application:error("[SystemMenuManager] Unable to display dialog since the logic for it hasn't been implemented.")
  return false
end

BaseDialog._get_ws = function(l_12_0)
  return l_12_0._ws
end

BaseDialog._get_controller = function(l_13_0)
  return l_13_0._controller
end

BaseDialog.to_string = function(l_14_0)
  return string.format("Class: %s, Id: %s, User index: %s", CoreDebug.class_name(getmetatable(l_14_0), _M), tostring(l_14_0._data.id), tostring(l_14_0._data.user_index))
end

BaseDialog.blocks_exec = function(l_15_0)
  return true
end


