-- Decompiled using luadec 2.0.1 by sztupy (http://winmo.sztupy.hu)
-- Command line was: F:\SteamLibrary\SteamApps\common\PAYDAY 2\lua\lib\managers\dialogs\newunlockdialog.luac 

core:module("SystemMenuManager")
require("lib/managers/dialogs/GenericDialog")
if not NewUnlockDialog then
  NewUnlockDialog = class(GenericDialog)
end
NewUnlockDialog.init = function(l_1_0, l_1_1, l_1_2, l_1_3)
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
  if not l_1_2.indicator then
    {w = 420, h = 400, no_close_legend = true, no_scroll_legend = true}.use_indicator = l_1_2.no_buttons
     -- DECOMPILER ERROR: Confused about usage of registers!

  end
  {w = 420, h = 400, no_close_legend = true, no_scroll_legend = true}.is_title_outside = l_1_3
   -- DECOMPILER ERROR: Confused about usage of registers!

  {w = 420, h = 400, no_close_legend = true, no_scroll_legend = true}.use_text_formating = l_1_2.use_text_formating
   -- DECOMPILER ERROR: Confused about usage of registers!

  {w = 420, h = 400, no_close_legend = true, no_scroll_legend = true}.text_formating_color = l_1_2.text_formating_color
   -- DECOMPILER ERROR: Confused about usage of registers!

  {w = 420, h = 400, no_close_legend = true, no_scroll_legend = true}.text_formating_color_table = l_1_2.text_formating_color_table
   -- DECOMPILER ERROR: Confused about usage of registers!

  {w = 420, h = 400, no_close_legend = true, no_scroll_legend = true}.text_blend_mode = l_1_2.text_blend_mode
   -- DECOMPILER ERROR: Confused at declaration of local variable

  do
     -- DECOMPILER ERROR: Confused at declaration of local variable

     -- DECOMPILER ERROR: Confused about usage of registers!

    l_1_0._panel_script = _G.ImageBoxGui:new(l_1_0._ws, not l_1_2.texture and not l_1_2.shapes and l_1_0._data.title or "", l_1_0._data.text or "", l_1_0._data, {w = 420, h = 400, no_close_legend = true, no_scroll_legend = true}, {w = 128, h = 128, padding = 10, layer = 2, keep_ratio = true, texture = l_1_2.texture, render_template = l_1_2.render_template, shapes = l_1_2.shapes, w = 0, h = 0})
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
    l_1_0._sound_event = l_1_2.sound_event
  end
   -- DECOMPILER ERROR: Confused about usage of registers for local variables.

end

NewUnlockDialog.fade_in = function(l_2_0)
  NewUnlockDialog.super.fade_in(l_2_0)
  l_2_0._start_sound_t = TimerManager:main():time() + 0.20000000298023
end

NewUnlockDialog.update = function(l_3_0, l_3_1, l_3_2)
  NewUnlockDialog.super.update(l_3_0, l_3_1, l_3_2)
  if l_3_0._start_sound_t and l_3_0._start_sound_t < l_3_1 then
    managers.menu_component:post_event(l_3_0._sound_event)
    l_3_0._start_sound_t = nil
  end
end


