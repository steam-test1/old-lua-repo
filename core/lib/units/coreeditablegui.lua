-- Decompiled using luadec 2.0.1 by sztupy (http://winmo.sztupy.hu)
-- Command line was: F:\SteamLibrary\SteamApps\common\PAYDAY 2\lua\core\lib\units\coreeditablegui.luac 

if not CoreEditableGui then
  CoreEditableGui = class()
end
CoreEditableGui.init = function(l_1_0, l_1_1)
  l_1_0._unit = l_1_1
  l_1_0._text = l_1_0._text or "Default Text"
  l_1_0._cull_distance = l_1_0._cull_distance or 5000
  l_1_0._sides = l_1_0._sides or 1
  l_1_0._gui_movie = l_1_0._gui_movie or "default_text"
  l_1_0._gui_object = l_1_0._gui_object or "gui_name"
  l_1_0._font = l_1_0._font or "core/fonts/diesel"
  l_1_0._gui = World:newgui()
  l_1_0._guis = {}
  if l_1_0._sides == 1 then
    l_1_0:add_workspace(l_1_0._unit:get_object(Idstring(l_1_0._gui_object)))
  else
    for i = 1, l_1_0._sides do
      l_1_0:add_workspace(l_1_0._unit:get_object(Idstring(l_1_0._gui_object .. i)))
    end
  end
  local text_object = l_1_0._guis[1].gui:child("std_text")
  l_1_0._font_size = text_object:font_size()
  l_1_0:set_font_size(l_1_0._font_size)
  l_1_0._font_color = Vector3(text_object:color().red, text_object:color().green, text_object:color().blue)
end

CoreEditableGui.add_workspace = function(l_2_0, l_2_1)
  local ws = l_2_0._gui:create_object_workspace(0, 0, l_2_1, Vector3(0, 0, 0))
  local gui = ws:panel():gui(Idstring("core/guis/core_editable_gui"))
  local panel = gui:panel()
  gui:child("std_text"):set_font(Idstring(l_2_0._font))
  gui:child("std_text"):set_text(l_2_0._text)
  table.insert(l_2_0._guis, {workspace = ws, gui = gui, panel = panel})
end

CoreEditableGui.text = function(l_3_0)
  return l_3_0._text
end

CoreEditableGui.set_text = function(l_4_0, l_4_1)
  l_4_0._text = l_4_1
  for _,gui in ipairs(l_4_0._guis) do
    gui.gui:child("std_text"):set_text(l_4_0._text)
  end
end

CoreEditableGui.font_size = function(l_5_0)
  return l_5_0._font_size
end

CoreEditableGui.set_font_size = function(l_6_0, l_6_1)
  l_6_0._font_size = l_6_1
  for _,gui in ipairs(l_6_0._guis) do
    gui.gui:child("std_text"):set_font_size(l_6_0._font_size * (10 * gui.gui:child("std_text"):height() / 100))
  end
end

CoreEditableGui.font_color = function(l_7_0)
  return l_7_0._font_color
end

CoreEditableGui.set_font_color = function(l_8_0, l_8_1)
  l_8_0._font_color = l_8_1
  for _,gui in ipairs(l_8_0._guis) do
    gui.gui:child("std_text"):set_color(Color(1, l_8_1.x, l_8_1.y, l_8_1.z))
  end
end

CoreEditableGui.lock_gui = function(l_9_0)
  for _,gui in ipairs(l_9_0._guis) do
    gui.workspace:set_cull_distance(l_9_0._cull_distance)
    gui.workspace:set_frozen(true)
  end
end

CoreEditableGui.destroy = function(l_10_0)
  for _,gui in ipairs(l_10_0._guis) do
    if alive(l_10_0._gui) and alive(gui.workspace) then
      l_10_0._gui:destroy_workspace(gui.workspace)
    end
  end
  l_10_0._guis = nil
end


