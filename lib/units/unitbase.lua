-- Decompiled using luadec 2.0.1 by sztupy (http://winmo.sztupy.hu)
-- Command line was: F:\SteamLibrary\SteamApps\common\PAYDAY 2\lua\lib\units\unitbase.luac 

if not UnitBase then
  UnitBase = class()
end
UnitBase.init = function(l_1_0, l_1_1, l_1_2)
  l_1_0._unit = l_1_1
  if not l_1_2 then
    l_1_1:set_extension_update_enabled(Idstring("base"), false)
  end
  l_1_0._destroy_listener_holder = ListenerHolder:new()
end

UnitBase.add_destroy_listener = function(l_2_0, l_2_1, l_2_2)
  if not l_2_0._destroying then
    l_2_0._destroy_listener_holder:add(l_2_1, l_2_2)
  end
end

UnitBase.remove_destroy_listener = function(l_3_0, l_3_1)
  l_3_0._destroy_listener_holder:remove(l_3_1)
end

UnitBase.save = function(l_4_0, l_4_1)
end

UnitBase.load = function(l_5_0, l_5_1)
  managers.worlddefinition:use_me(l_5_0._unit)
end

UnitBase.pre_destroy = function(l_6_0, l_6_1)
  l_6_0._destroying = true
  l_6_0._destroy_listener_holder:call(l_6_1)
end

UnitBase.destroy = function(l_7_0, l_7_1)
  if l_7_0._destroying then
    return 
  end
  l_7_0._destroy_listener_holder:call(l_7_1)
end

UnitBase.set_slot = function(l_8_0, l_8_1, l_8_2)
  l_8_1:set_slot(l_8_2)
end


