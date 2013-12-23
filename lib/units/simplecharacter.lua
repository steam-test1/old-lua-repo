-- Decompiled using luadec 2.0.1 by sztupy (http://winmo.sztupy.hu)
-- Command line was: F:\SteamLibrary\SteamApps\common\PAYDAY 2\lua\lib\units\simplecharacter.luac 

if not SimpleCharacter then
  SimpleCharacter = class()
end
SimpleCharacter.SPEED = 150
SimpleCharacter.init = function(l_1_0, l_1_1)
  l_1_0._unit = l_1_1
end

SimpleCharacter.update = function(l_2_0, l_2_1, l_2_2, l_2_3)
  l_2_0:move(l_2_2, l_2_3)
end

SimpleCharacter.paused_update = function(l_3_0, l_3_1, l_3_2, l_3_3)
  l_3_0:move(l_3_2, l_3_3)
end

SimpleCharacter.move = function(l_4_0, l_4_1, l_4_2)
  local move_vec = Vector3(0, 0, 0)
  local keyboard = Input:keyboard()
  local viewport = managers.viewport:first_active_viewport()
  if viewport == nil then
    return 
  end
  local camera = viewport:camera()
  local cam_rot = camera:rotation()
  local rotation = Rotation(90, cam_rot:pitch(), cam_rot:roll())
  if l_4_0._unit:mover() then
    if keyboard:down(Idstring("t")) then
      move_vec = move_vec - rotation:z()
    end
    if keyboard:down(Idstring("g")) then
      move_vec = move_vec + rotation:z()
    end
    if keyboard:down(Idstring("f")) then
      move_vec = move_vec - rotation:x()
    end
    if keyboard:down(Idstring("h")) then
      move_vec = move_vec + rotation:x()
    end
    local length = move_vec:length()
    if length > 0.0010000000474975 then
      move_vec = (move_vec) / length
    end
    move_vec = move_vec * l_4_0.SPEED * l_4_2
    if keyboard:down(Idstring("c")) then
      l_4_0._unit:mover():jump()
    end
    if keyboard:down(Idstring("k")) then
      l_4_0._unit:mover():set_stiff(true)
    end
    if keyboard:down(Idstring("l")) then
      l_4_0._unit:mover():set_stiff(false)
    end
  end
  l_4_0._unit:move(move_vec)
end


