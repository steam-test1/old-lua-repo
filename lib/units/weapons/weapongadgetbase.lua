-- Decompiled using luadec 2.0.1 by sztupy (http://winmo.sztupy.hu)
-- Command line was: F:\SteamLibrary\SteamApps\common\PAYDAY 2\lua\lib\units\weapons\weapongadgetbase.luac 

if not WeaponGadgetBase then
  WeaponGadgetBase = class(UnitBase)
end
WeaponGadgetBase.init = function(l_1_0, l_1_1)
  WeaponGadgetBase.super.init(l_1_0, l_1_1)
  l_1_0._on = false
end

WeaponGadgetBase.set_npc = function(l_2_0)
end

WeaponGadgetBase.set_state = function(l_3_0, l_3_1, l_3_2)
  if l_3_0._on ~= l_3_1 then
    if l_3_2 and (not l_3_1 or not l_3_0._on_event) then
      l_3_2:post_event(l_3_0._off_event)
    end
  end
  l_3_0._on = l_3_1
  l_3_0:_check_state()
end

WeaponGadgetBase.set_on = function(l_4_0)
  l_4_0._on = true
  l_4_0:_check_state()
end

WeaponGadgetBase.set_off = function(l_5_0)
  l_5_0._on = false
  l_5_0:_check_state()
end

WeaponGadgetBase.toggle = function(l_6_0)
  l_6_0._on = not l_6_0._on
  l_6_0:_check_state()
end

WeaponGadgetBase.is_on = function(l_7_0)
  return l_7_0._on
end

WeaponGadgetBase._check_state = function(l_8_0)
end

WeaponGadgetBase.destroy = function(l_9_0, l_9_1)
  WeaponGadgetBase.super.pre_destroy(l_9_0, l_9_1)
end


