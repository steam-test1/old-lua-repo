-- Decompiled using luadec 2.0.1 by sztupy (http://winmo.sztupy.hu)
-- Command line was: F:\SteamLibrary\SteamApps\common\PAYDAY 2\lua\lib\managers\hud\hudhitconfirm.luac 

if not HUDHitConfirm then
  HUDHitConfirm = class()
end
HUDHitConfirm.init = function(l_1_0, l_1_1)
  l_1_0._hud_panel = l_1_1.panel
  if l_1_0._hud_panel:child("hit_confirm") then
    l_1_0._hud_panel:remove(l_1_0._hud_panel:child("hit_confirm"))
  end
  l_1_0._hit_confirm = l_1_0._hud_panel:bitmap({valign = "center", halign = "center", visible = false, name = "hit_confirm", texture = "guis/textures/pd2/hitconfirm", color = Color.white, layer = 0, blend_mode = "add"})
  l_1_0._hit_confirm:set_center(l_1_0._hud_panel:w() / 2, l_1_0._hud_panel:h() / 2)
end

HUDHitConfirm.on_hit_confirmed = function(l_2_0)
  l_2_0._hit_confirm:stop()
  l_2_0._hit_confirm:animate(callback(l_2_0, l_2_0, "_animate_show"), callback(l_2_0, l_2_0, "show_done"), 0.25)
end

HUDHitConfirm._animate_show = function(l_3_0, l_3_1, l_3_2, l_3_3)
  l_3_1:set_visible(true)
  l_3_1:set_alpha(1)
  do
    local t = l_3_3
    repeat
      if t > 0 then
        local dt = coroutine.yield()
        t = t - dt
        l_3_1:set_alpha((t) / l_3_3)
      else
        l_3_1:set_visible(false)
        l_3_2()
      end
       -- Warning: missing end command somewhere! Added here
    end
     -- Warning: missing end command somewhere! Added here
  end
end

HUDHitConfirm.show_done = function(l_4_0)
end


