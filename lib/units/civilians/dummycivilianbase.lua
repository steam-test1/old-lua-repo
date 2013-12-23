-- Decompiled using luadec 2.0.1 by sztupy (http://winmo.sztupy.hu)
-- Command line was: F:\SteamLibrary\SteamApps\common\PAYDAY 2\lua\lib\units\civilians\dummycivilianbase.luac 

if not DummyCivilianBase then
  DummyCivilianBase = class()
end
DummyCivilianBase.init = function(l_1_0, l_1_1)
  l_1_0._unit = l_1_1
  l_1_1:set_driving("animation")
  l_1_1:set_animation_lod(1, 500000, 500, 500000)
end

DummyCivilianBase.play_state = function(l_2_0, l_2_1, l_2_2)
  local result = l_2_0._unit:play_state(Idstring(l_2_1), l_2_2)
  return (result ~= Idstring("") and result)
end

DummyCivilianBase.anim_clbk_spear_spawn = function(l_3_0, l_3_1)
  l_3_0:_spawn_spear()
end

DummyCivilianBase.anim_clbk_spear_unspawn = function(l_4_0, l_4_1)
  l_4_0:_unspawn_spear()
end

DummyCivilianBase._spawn_spear = function(l_5_0)
  if not alive(l_5_0._spear) then
    l_5_0._spear = World:spawn_unit(Idstring("units/test/beast/weapon/native_spear"), Vector3(), Rotation())
    l_5_0._unit:link(Idstring("a_weapon_right_front"), l_5_0._spear, l_5_0._spear:orientation_object():name())
  end
end

DummyCivilianBase._unspawn_spear = function(l_6_0)
  if alive(l_6_0._spear) then
    l_6_0._spear:set_slot(0)
    l_6_0._spear = nil
  end
end

DummyCivilianBase.destroy = function(l_7_0, l_7_1)
  l_7_0:_unspawn_spear()
end


