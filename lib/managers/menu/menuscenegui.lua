-- Decompiled using luadec 2.0.1 by sztupy (http://winmo.sztupy.hu)
-- Command line was: F:\SteamLibrary\SteamApps\common\PAYDAY 2\lua\lib\managers\menu\menuscenegui.luac 

if not MenuSceneGui then
  MenuSceneGui = class()
end
MenuSceneGui.init = function(l_1_0, l_1_1, l_1_2, l_1_3)
  l_1_0._ws = l_1_1
  l_1_0._fullscreen_ws = l_1_2
  l_1_0._node = l_1_3
  l_1_0._panel = l_1_0._ws:panel():panel()
  l_1_0._fullscreen_panel = l_1_0._fullscreen_ws:panel():panel()
  if not managers.menu:is_pc_controller() then
    l_1_0:_setup_controller_input()
  end
end

MenuSceneGui._setup_controller_input = function(l_2_0)
  l_2_0._left_axis_vector = Vector3()
  l_2_0._right_axis_vector = Vector3()
  l_2_0._ws:connect_controller(managers.menu:active_menu().input:get_controller(), true)
  l_2_0._panel:axis_move(callback(l_2_0, l_2_0, "_axis_move"))
end

MenuSceneGui._destroy_controller_input = function(l_3_0)
  l_3_0._ws:disconnect_all_controllers()
  if alive(l_3_0._panel) then
    l_3_0._panel:axis_move(nil)
  end
end

MenuSceneGui._axis_move = function(l_4_0, l_4_1, l_4_2, l_4_3, l_4_4)
  if l_4_2 == Idstring("left") then
    mvector3.set(l_4_0._left_axis_vector, l_4_3)
  else
    if l_4_2 == Idstring("right") then
      mvector3.set(l_4_0._right_axis_vector, l_4_3)
    end
  end
end

MenuSceneGui.update = function(l_5_0, l_5_1, l_5_2)
  if managers.menu:is_pc_controller() then
    return 
  end
  if mvector3.is_zero(l_5_0._left_axis_vector) then
    managers.menu_scene:stop_controller_move()
  else
    local x = mvector3.x(l_5_0._left_axis_vector)
    local y = mvector3.y(l_5_0._left_axis_vector)
    managers.menu_scene:controller_move(x * l_5_2, y * l_5_2)
  end
  if mvector3.is_zero(l_5_0._right_axis_vector) then
    do return end
  end
  local y = mvector3.y(l_5_0._right_axis_vector)
  managers.menu_scene:controller_zoom(y * l_5_2)
end

MenuSceneGui.close = function(l_6_0)
  l_6_0:_destroy_controller_input()
  if alive(l_6_0._panel) then
    l_6_0._ws:panel():remove(l_6_0._panel)
    l_6_0._panel = nil
  end
  if alive(l_6_0._fullscreen_panel) then
    l_6_0._fullscreen_ws:panel():remove(l_6_0._fullscreen_panel)
    l_6_0._fullscreen_panel = nil
  end
end


