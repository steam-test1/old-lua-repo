-- Decompiled using luadec 2.0.1 by sztupy (http://winmo.sztupy.hu)
-- Command line was: F:\SteamLibrary\SteamApps\common\PAYDAY 2\lua\lib\managers\menu\crimenetfiltersgui.luac 

if not CrimeNetFiltersGui then
  CrimeNetFiltersGui = class()
end
CrimeNetFiltersGui.init = function(l_1_0, l_1_1, l_1_2, l_1_3)
  l_1_0._ws = l_1_1
  l_1_0._fullscreen_ws = l_1_2
  l_1_0._panel = l_1_0._ws:panel():panel({layer = 51})
  l_1_0._fullscreen_panel = l_1_0._fullscreen_ws:panel():panel({layer = 50})
  l_1_0._node = l_1_3
  local blur = l_1_0._fullscreen_panel:bitmap({texture = "guis/textures/test_blur_df", w = l_1_0._fullscreen_ws:panel():w(), h = l_1_0._fullscreen_ws:panel():h(), render_template = "VertexColorTexturedBlur3D"})
  local func = function(l_1_0)
    local start_blur = 0
    over(0.60000002384186, function(l_1_0)
      o:set_alpha(math.lerp(start_blur, 1, l_1_0))
      end)
   end
  blur:animate(func)
  managers.menu:active_menu().input:deactivate_controller_mouse()
end

CrimeNetFiltersGui.close = function(l_2_0)
  if not managers.menu:is_pc_controller() then
    managers.menu:active_menu().input:activate_controller_mouse()
  end
  l_2_0._ws:panel():remove(l_2_0._panel)
  l_2_0._fullscreen_ws:panel():remove(l_2_0._fullscreen_panel)
end


