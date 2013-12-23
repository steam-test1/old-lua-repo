-- Decompiled using luadec 2.0.1 by sztupy (http://winmo.sztupy.hu)
-- Command line was: F:\SteamLibrary\SteamApps\common\PAYDAY 2\lua\lib\units\civilians\civilianbase.luac 

if not CivilianBase then
  CivilianBase = class(CopBase)
end
CivilianBase.post_init = function(l_1_0)
  l_1_0._ext_movement = l_1_0._unit:movement()
  local spawn_state = l_1_0._spawn_state or "civilian/spawn/loop"
  l_1_0._ext_movement:play_state(spawn_state)
  l_1_0._unit:anim_data().idle_full_blend = true
  l_1_0._ext_movement:post_init()
  l_1_0._unit:brain():post_init()
  managers.enemy:register_civilian(l_1_0._unit)
end

CivilianBase.default_weapon_name = function(l_2_0)
end


