-- Decompiled using luadec 2.0.1 by sztupy (http://winmo.sztupy.hu)
-- Command line was: F:\SteamLibrary\SteamApps\common\PAYDAY 2\lua\lib\managers\dialogs\keyboardinputdialog.luac 

core:module("SystemMenuManager")
require("lib/managers/dialogs/BaseDialog")
if not KeyboardInputDialog then
  KeyboardInputDialog = class(BaseDialog)
end
KeyboardInputDialog.title = function(l_1_0)
  return l_1_0._data.title or ""
end

KeyboardInputDialog.text = function(l_2_0)
  return l_2_0._data.text or ""
end

KeyboardInputDialog.input_text = function(l_3_0)
  return l_3_0._data.input_text
end

KeyboardInputDialog.input_type = function(l_4_0)
  return l_4_0._data.input_type or "default"
end

KeyboardInputDialog.max_count = function(l_5_0)
  return l_5_0._data.max_count
end

KeyboardInputDialog.filter = function(l_6_0)
  return l_6_0._data.filter
end

KeyboardInputDialog.done_callback = function(l_7_0, l_7_1, l_7_2)
  if l_7_0._data.callback_func then
    l_7_0._data.callback_func(l_7_1, l_7_2)
  end
  l_7_0:fade_out_close()
end

KeyboardInputDialog.to_string = function(l_8_0)
  return string.format("%s, Title: %s, Text: %s, Input text: %s, Max count: %s, Filter: %s", tostring(BaseDialog.to_string(l_8_0)), tostring(l_8_0._data.title), tostring(l_8_0._data.text), tostring(l_8_0._data.input_text), tostring(l_8_0._data.max_count), tostring(l_8_0._data.filter))
end


