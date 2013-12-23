-- Decompiled using luadec 2.0.1 by sztupy (http://winmo.sztupy.hu)
-- Command line was: F:\SteamLibrary\SteamApps\common\PAYDAY 2\lua\lib\units\vehicles\helicopter\animatedhelibase.luac 

if not AnimatedHeliBase then
  AnimatedHeliBase = class(UnitBase)
end
AnimatedHeliBase.init = function(l_1_0, l_1_1)
  AnimatedHeliBase.super.init(l_1_0, l_1_1, false)
  l_1_0._unit = l_1_1
  l_1_0:_set_anim_lod(0)
end

AnimatedHeliBase.update = function(l_2_0, l_2_1, l_2_2, l_2_3)
  local new_pos = l_2_0._obj_com:position()
  if new_pos ~= l_2_0._last_pos and alive(l_2_0._listener_obj) then
    local new_vel = new_pos - l_2_0._last_pos
    mvector3.divide(new_vel, l_2_3)
    l_2_0._last_pos = new_pos
    local listener_pos = l_2_0._listener_obj:position()
    local listener_vec = listener_pos - new_pos
    local listener_dis = mvector3.normalize(listener_vec)
    local vel_dot = mvector3.dot(listener_vec, new_vel)
    vel_dot = math.clamp(vel_dot / 15000, -1, 1)
    l_2_0._sound_source:set_rtpc("vel_to_listener", vel_dot)
    l_2_0:_set_anim_lod(listener_dis)
  end
end

AnimatedHeliBase._set_anim_lod = function(l_3_0, l_3_1)
  if l_3_1 > 9000 and l_3_0._lod_high then
    l_3_0._lod_high = false
    l_3_0._unit:set_animation_lod(2, 0, 0, 0)
    do return end
    if l_3_1 < 8000 and not l_3_0._lod_high then
      l_3_0._lod_high = true
      l_3_0._unit:set_animation_lod(1, 1000000, 1000000, 1000000)
    end
  end
end

AnimatedHeliBase.start_doppler = function(l_4_0)
  l_4_0:set_enabled(true)
  l_4_0._obj_com = l_4_0._unit:get_object(Idstring("a_body"))
  l_4_0._last_pos = l_4_0._obj_com:position()
  l_4_0._listener_obj = managers.listener:active_listener_obj()
  l_4_0._sound_source = l_4_0._unit:sound_source()
end

AnimatedHeliBase.stop_doppler = function(l_5_0)
  l_5_0:set_enabled(false)
  l_5_0._listener_obj = nil
  l_5_0._sound_source = nil
end

AnimatedHeliBase.set_enabled = function(l_6_0, l_6_1)
  if l_6_1 then
    if l_6_0._ext_enabled_count then
      l_6_0._ext_enabled_count = l_6_0._ext_enabled_count + 1
    else
      l_6_0._ext_enabled_count = 1
      l_6_0._unit:set_extension_update_enabled(Idstring("base"), true)
    end
  elseif l_6_0._ext_enabled_count and l_6_0._ext_enabled_count > 1 then
    l_6_0._ext_enabled_count = l_6_0._ext_enabled_count - 1
  else
    l_6_0._ext_enabled_count = nil
    l_6_0._unit:set_extension_update_enabled(Idstring("base"), false)
  end
end
end

AnimatedHeliBase.anim_clbk_empty_full_blend = function(l_7_0, l_7_1)
  l_7_0:stop_doppler()
  l_7_1:set_animations_enabled(false)
end

AnimatedHeliBase.anim_clbk_empty_exit = function(l_8_0, l_8_1)
  l_8_0:start_doppler()
  l_8_1:set_animations_enabled(true)
end


