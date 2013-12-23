-- Decompiled using luadec 2.0.1 by sztupy (http://winmo.sztupy.hu)
-- Command line was: F:\SteamLibrary\SteamApps\common\PAYDAY 2\lua\lib\managers\hud\hudhitdirection.luac 

if not HUDHitDirection then
  HUDHitDirection = class()
end
HUDHitDirection.init = function(l_1_0, l_1_1)
  l_1_0._hud_panel = l_1_1.panel
  if l_1_0._hud_panel:child("hit_direction_panel") then
    l_1_0._hud_panel:remove(l_1_0._hud_panel:child("hit_direction_panel"))
  end
  l_1_0._hit_direction_panel = l_1_0._hud_panel:panel({visible = true, name = "hit_direction_panel", w = 256, h = 256, valign = "center", halign = "center", layer = -5})
  l_1_0._hit_direction_panel:set_center(l_1_0._hit_direction_panel:parent():w() / 2, l_1_0._hit_direction_panel:parent():h() / 2)
  local right = l_1_0._hit_direction_panel:bitmap({name = "right", visible = true, texture = "guis/textures/pd2/hitdirection", color = Color.white, blend_mode = "add", alpha = 0, halign = "right"})
  right:set_right(right:parent():w())
  local tw = right:texture_width()
  local th = right:texture_height()
  local left = l_1_0._hit_direction_panel:bitmap({name = "left", rotation = 180, visible = true, texture = "guis/textures/pd2/hitdirection", color = Color.white, blend_mode = "add", alpha = 0, halign = "right"})
  left:set_left(0)
  local up = l_1_0._hit_direction_panel:bitmap({name = "up", rotation = -90, visible = true, texture = "guis/textures/pd2/hitdirection", color = Color.white, blend_mode = "add", alpha = 0, halign = "right"})
  up:set_top(-tw * 1.5)
  up:set_center_x(up:parent():w() / 2)
  local down = l_1_0._hit_direction_panel:bitmap({name = "down", rotation = 90, visible = true, texture = "guis/textures/pd2/hitdirection", color = Color.white, blend_mode = "add", alpha = 0, halign = "right"})
  down:set_y(tw * 1.5)
  down:set_center_x(down:parent():w() / 2)
end

HUDHitDirection.on_hit_direction = function(l_2_0, l_2_1)
  local direction = l_2_0._hit_direction_panel:child(l_2_1)
  direction:stop()
  direction:animate(callback(l_2_0, l_2_0, "_animate_hit_direction"))
end

HUDHitDirection._animate_hit_direction = function(l_3_0, l_3_1)
  l_3_1:set_alpha(1)
  local st = 0.60000002384186
  local t = st
  local st_red_t = 0.40000000596046
  do
    local red_t = st_red_t
    repeat
      if t > 0 then
        local dt = coroutine.yield()
        t = t - dt
        red_t = math.clamp(red_t - dt, 0, 1)
        l_3_1:set_color(Color(1, red_t / st_red_t, red_t / st_red_t))
        l_3_1:set_alpha((t) / st)
      else
        l_3_1:set_alpha(0)
      end
       -- Warning: missing end command somewhere! Added here
    end
     -- Warning: missing end command somewhere! Added here
  end
end


