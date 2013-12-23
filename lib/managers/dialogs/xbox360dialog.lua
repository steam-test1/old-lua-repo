-- Decompiled using luadec 2.0.1 by sztupy (http://winmo.sztupy.hu)
-- Command line was: F:\SteamLibrary\SteamApps\common\PAYDAY 2\lua\lib\managers\dialogs\xbox360dialog.luac 

core:module("SystemMenuManager")
require("lib/managers/dialogs/Dialog")
if not Xbox360Dialog then
  Xbox360Dialog = class(Dialog)
end
Xbox360Dialog.show = function(l_1_0)
  local focus_button = l_1_0:focus_button()
  if focus_button then
    focus_button = focus_button - 1
  else
    focus_button = 0
  end
  local button_text_list = l_1_0:button_text_list()
  local success = Application:display_message_box_dialog(l_1_0:get_platform_id(), l_1_0:title(), l_1_0:text(), focus_button, callback(l_1_0, l_1_0, "button_pressed"), false, unpack(button_text_list))
  if success then
    l_1_0._manager:event_dialog_shown(l_1_0)
  end
  return success
end

Xbox360Dialog.button_pressed = function(l_2_0, l_2_1)
  if not l_2_0:focus_button() then
    l_2_1 = l_2_1 ~= -1 or 1
  end
  cat_print("dialog_manager", "[SystemMenuManager] Dialog aborted. Defaults to focus button.")
  Dialog.button_pressed(l_2_0, (l_2_1) + 1)
end

Xbox360Dialog.blocks_exec = function(l_3_0)
  return false
end


