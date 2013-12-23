-- Decompiled using luadec 2.0.1 by sztupy (http://winmo.sztupy.hu)
-- Command line was: F:\SteamLibrary\SteamApps\common\PAYDAY 2\lua\lib\units\weapons\npcsniperriflebase.luac 

if not NPCSniperRifleBase then
  NPCSniperRifleBase = class(NPCRaycastWeaponBase)
end
NPCSniperRifleBase.TRAIL_EFFECT = Idstring("effects/particles/weapons/sniper_trail")
local idstr_trail = Idstring("trail")
local idstr_simulator_length = Idstring("simulator_length")
local idstr_size = Idstring("size")
NPCSniperRifleBase.init = function(l_1_0, l_1_1)
  NPCSniperRifleBase.super.init(l_1_0, l_1_1)
  l_1_0._trail_length = World:effect_manager():get_initial_simulator_var_vector2(World:effect_manager(), l_1_0.TRAIL_EFFECT, idstr_trail, idstr_simulator_length, idstr_size)
end

NPCSniperRifleBase._spawn_trail_effect = function(l_2_0, l_2_1, l_2_2)
  l_2_0._obj_fire:m_position(l_2_0._trail_effect_table.position)
  mvector3.set(l_2_0._trail_effect_table.normal, l_2_1)
  local trail = World:effect_manager():spawn(l_2_0._trail_effect_table)
  if l_2_2 then
    mvector3.set_y(l_2_0._trail_length, l_2_2.distance)
    World:effect_manager():set_simulator_var_vector2(World:effect_manager(), trail, idstr_trail, idstr_simulator_length, idstr_size, l_2_0._trail_length)
  end
end


