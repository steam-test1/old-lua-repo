-- Decompiled using luadec 2.0.1 by sztupy (http://winmo.sztupy.hu)
-- Command line was: F:\SteamLibrary\SteamApps\common\PAYDAY 2\lua\lib\managers\dialogs\dialog.luac 

core:module("SystemMenuManager")
require("lib/managers/dialogs/BaseDialog")
if not Dialog then
  Dialog = class(BaseDialog)
end
Dialog.init = function(l_1_0, l_1_1, l_1_2)
  BaseDialog.init(l_1_0, l_1_1, l_1_2)
  l_1_0._button_text_list = {}
  l_1_0:init_button_text_list()
end

Dialog.init_button_text_list = function(l_2_0)
  local button_list = l_2_0._data.button_list
  if button_list then
    for _,button in ipairs(button_list) do
      table.insert(l_2_0._button_text_list, button.text or "ERROR")
    end
  end
  if #l_2_0._button_text_list == 0 and not l_2_0._data.no_buttons then
    Application:error("[SystemMenuManager] Invalid dialog with no button texts. Adds an ok-button.")
    if not l_2_0._data.button_list then
      l_2_0._data.button_list = {}
    end
    if not l_2_0._data.button_list[1] then
      l_2_0._data.button_list[1] = {}
    end
    l_2_0._data.button_list[1].text = "ERROR: OK"
    table.insert(l_2_0._button_text_list, l_2_0._data.button_list[1].text)
  end
end

Dialog.title = function(l_3_0)
  return l_3_0._data.title
end

Dialog.text = function(l_4_0)
  return l_4_0._data.text
end

Dialog.focus_button = function(l_5_0)
  return l_5_0._data.focus_button
end

Dialog.button_pressed = function(l_6_0, l_6_1)
  cat_print("dialog_manager", "[SystemMenuManager] Button index pressed: " .. tostring(l_6_1))
  local button_list = l_6_0._data.button_list
  l_6_0:fade_out_close()
  if button_list then
    local button = button_list[l_6_1]
    if button and button.callback_func then
      button.callback_func(l_6_1, button)
    end
  end
  local callback_func = l_6_0._data.callback_func
  if callback_func then
    callback_func(l_6_1, l_6_0._data)
  end
end

Dialog.button_text_list = function(l_7_0)
  return l_7_0._button_text_list
end

Dialog.to_string = function(l_8_0)
  local buttons = ""
  if l_8_0._data.button_list then
    for _,button in ipairs(l_8_0._data.button_list) do
      buttons = buttons .. "[" .. tostring(button.text) .. "]"
    end
  end
  return string.format("%s, Title: %s, Text: %s, Buttons: %s", tostring(BaseDialog.to_string(l_8_0)), tostring(l_8_0._data.title), tostring(l_8_0:_strip_to_string_text(l_8_0._data.text)), buttons)
end

Dialog._strip_to_string_text = function(l_9_0, l_9_1)
  return string.gsub(tostring(l_9_1), "\n", "\\n")
end


