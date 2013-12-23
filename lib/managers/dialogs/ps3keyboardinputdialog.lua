-- Decompiled using luadec 2.0.1 by sztupy (http://winmo.sztupy.hu)
-- Command line was: F:\SteamLibrary\SteamApps\common\PAYDAY 2\lua\lib\managers\dialogs\ps3keyboardinputdialog.luac 

core:module("SystemMenuManager")
require("lib/managers/dialogs/KeyboardInputDialog")
if not PS3KeyboardInputDialog then
  PS3KeyboardInputDialog = class(KeyboardInputDialog)
end
PS3KeyboardInputDialog.show = function(l_1_0)
  local data = {}
  data.title = l_1_0:title()
  data.text = l_1_0:input_text()
  data.filter = l_1_0:filter()
  data.limit = l_1_0:max_count() or 0
  data.callback = callback(l_1_0, l_1_0, "done_callback")
  PS3:display_keyboard(data)
  local success = PS3:is_displaying_box()
  if success then
    l_1_0._manager:event_dialog_shown(l_1_0)
  end
  return success
end

PS3KeyboardInputDialog.done_callback = function(l_2_0, l_2_1, l_2_2)
  KeyboardInputDialog.done_callback(l_2_0, l_2_2, l_2_1)
end


