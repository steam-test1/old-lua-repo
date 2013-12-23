-- Decompiled using luadec 2.0.1 by sztupy (http://winmo.sztupy.hu)
-- Command line was: F:\SteamLibrary\SteamApps\common\PAYDAY 2\lua\lib\units\props\tvgui.luac 

if not TvGui then
  TvGui = class()
end
TvGui.init = function(l_1_0, l_1_1)
  l_1_0._unit = l_1_1
  l_1_0._visible = true
  l_1_0._video = l_1_0._video or "movies/level_alaska"
  l_1_0._gui_object = l_1_0._gui_object or "gui_name"
  l_1_0._new_gui = World:newgui()
  l_1_0:add_workspace(l_1_0._unit:get_object(Idstring(l_1_0._gui_object)))
  l_1_0:setup()
  l_1_0._unit:set_extension_update_enabled(Idstring("tv_gui"), false)
end

TvGui.add_workspace = function(l_2_0, l_2_1)
  l_2_0._ws = l_2_0._new_gui:create_object_workspace(0, 0, l_2_1, Vector3(0, 0, 0))
end

TvGui.setup = function(l_3_0)
  l_3_0._ws:panel():video({layer = 10, visible = true, video = l_3_0._video, loop = true})
end

TvGui._start = function(l_4_0)
end

TvGui.start = function(l_5_0)
end

TvGui.sync_start = function(l_6_0)
  l_6_0:_start()
end

TvGui.set_visible = function(l_7_0, l_7_1)
  l_7_0._visible = l_7_1
  l_7_0._gui:set_visible(l_7_1)
end

TvGui.lock_gui = function(l_8_0)
  l_8_0._ws:set_cull_distance(l_8_0._cull_distance)
  l_8_0._ws:set_frozen(true)
end

TvGui.destroy = function(l_9_0)
  if alive(l_9_0._new_gui) and alive(l_9_0._ws) then
    l_9_0._new_gui:destroy_workspace(l_9_0._ws)
    l_9_0._ws = nil
    l_9_0._new_gui = nil
  end
end


