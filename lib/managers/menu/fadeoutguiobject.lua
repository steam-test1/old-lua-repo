-- Decompiled using luadec 2.0.1 by sztupy (http://winmo.sztupy.hu)
-- Command line was: F:\SteamLibrary\SteamApps\common\PAYDAY 2\lua\lib\managers\menu\fadeoutguiobject.luac 

if not FadeoutGuiObject then
  FadeoutGuiObject = class()
end
FadeoutGuiObject.init = function(l_1_0, l_1_1)
  if not Global.FadeoutObjects then
    Global.FadeoutObjects = {}
  end
  table.insert(Global.FadeoutObjects, l_1_0)
  if not l_1_1 then
    l_1_1 = {}
  end
  local sustain = l_1_1.sustain or 0
  local fade_out_t = l_1_1.fade_out or 0
  if not l_1_1.color then
    local fade_color = Color.black
  end
  local show_loding_icon = l_1_1.show_loading_icon or true
  local loading_texture = l_1_1.loading_texture or "guis/textures/icon_loading"
  l_1_0._ws = managers.gui_data:create_fullscreen_workspace()
  l_1_0._panel = l_1_0._ws:panel()
  l_1_0._panel:set_layer(1000)
  if show_loding_icon then
    local loading_icon = l_1_0._panel:bitmap({name = "loading_icon", texture = loading_texture})
    loading_icon:set_position(managers.gui_data:safe_to_full(0, 0))
    loading_icon:set_center_y(l_1_0._panel:h() / 2)
    local spin_forever_animation = function(l_1_0)
      local dt = nil
      repeat
        dt = coroutine.yield()
        l_1_0:rotate(dt * 180)
        do return end
         -- Warning: missing end command somewhere! Added here
      end
      end
    loading_icon:animate(spin_forever_animation)
  end
  local fade_out_animation = function(l_2_0)
    local loading_icon = l_2_0:child("loading_icon")
    wait(sustain)
    over(fade_out_t, function(l_1_0)
      panel:set_alpha(1 - l_1_0)
      if alive(loading_icon) then
        loading_icon:set_alpha(1 - l_1_0)
      end
      end)
    Application:debug("FadeoutGuiObject: Destroy")
    Overlay:gui():destroy_workspace(self._ws)
    table.delete(Global.FadeoutObjects, self)
   end
  Application:debug("FadeoutGuiObject: Fadeout")
  l_1_0._panel:animate(fade_out_animation)
end


