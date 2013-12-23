-- Decompiled using luadec 2.0.1 by sztupy (http://winmo.sztupy.hu)
-- Command line was: F:\SteamLibrary\SteamApps\common\PAYDAY 2\lua\lib\units\cameras\animatedcamera.luac 

if not AnimatedCamera then
  AnimatedCamera = class()
end
AnimatedCamera.init = function(l_1_0, l_1_1)
  l_1_0._unit = l_1_1
end

AnimatedCamera.update = function(l_2_0, l_2_1, l_2_2, l_2_3)
end

AnimatedCamera.set_position = function(l_3_0, l_3_1)
  l_3_0._unit:set_position(l_3_1)
end

AnimatedCamera.set_rotation = function(l_4_0, l_4_1)
  l_4_0._unit:set_rotation(l_4_1)
end

AnimatedCamera.position = function(l_5_0, l_5_1)
  return l_5_0._unit:position()
end

AnimatedCamera.rotation = function(l_6_0, l_6_1)
  return l_6_0._unit:rotation()
end

AnimatedCamera.play_redirect = function(l_7_0, l_7_1)
  local result = l_7_0._unit:play_redirect(l_7_1)
  return (result ~= "" and result)
end

AnimatedCamera.play_state = function(l_8_0, l_8_1)
  local result = l_8_0._unit:play_state(l_8_1)
  return (result ~= "" and result)
end

AnimatedCamera.destroy = function(l_9_0)
end


