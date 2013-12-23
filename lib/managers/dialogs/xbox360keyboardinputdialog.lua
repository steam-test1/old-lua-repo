-- Decompiled using luadec 2.0.1 by sztupy (http://winmo.sztupy.hu)
-- Command line was: F:\SteamLibrary\SteamApps\common\PAYDAY 2\lua\lib\managers\dialogs\xbox360keyboardinputdialog.luac 

core:module("SystemMenuManager")
require("lib/managers/dialogs/KeyboardInputDialog")
if not Xbox360KeyboardInputDialog then
  Xbox360KeyboardInputDialog = class(KeyboardInputDialog)
end
Xbox360KeyboardInputDialog.show = function(l_1_0)
  l_1_0._manager:event_dialog_shown(l_1_0)
  local end_parameter_list = {}
  table.insert(end_parameter_list, l_1_0:max_count())
  table.insert(end_parameter_list, callback(l_1_0, l_1_0, "done_callback"))
  XboxLive:show_keyboard_ui(l_1_0:get_platform_id(), l_1_0:input_type(), l_1_0:input_text(), l_1_0:title(), l_1_0:text(), unpack(end_parameter_list))
  return true
end

Xbox360KeyboardInputDialog.done_callback = function(l_2_0, l_2_1)
  KeyboardInputDialog.done_callback(l_2_0, true, l_2_1)
end


