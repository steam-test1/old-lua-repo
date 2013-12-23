-- Decompiled using luadec 2.0.1 by sztupy (http://winmo.sztupy.hu)
-- Command line was: F:\SteamLibrary\SteamApps\common\PAYDAY 2\lua\core\lib\managers\managerbase\coreaccessobjectbase.luac 

core:module("CoreAccessObjectBase")
if not AccessObjectBase then
  AccessObjectBase = class()
end
AccessObjectBase.init = function(l_1_0, l_1_1, l_1_2)
  l_1_0.__manager = l_1_1
  l_1_0.__name = l_1_2
  l_1_0.__active_requested = false
  l_1_0.__really_activated = false
end

AccessObjectBase.name = function(l_2_0)
  return l_2_0.__name
end

AccessObjectBase.active = function(l_3_0)
  return l_3_0.__active_requested
end

AccessObjectBase.active_requested = function(l_4_0)
  return l_4_0.__active_requested
end

AccessObjectBase.really_active = function(l_5_0)
  return l_5_0.__really_activated
end

AccessObjectBase.set_active = function(l_6_0, l_6_1)
  if l_6_0.__active_requested ~= l_6_1 then
    l_6_0.__active_requested = l_6_1
    l_6_0.__manager:_prioritize_and_activate()
  end
end

AccessObjectBase._really_activate = function(l_7_0)
  l_7_0.__really_activated = true
end

AccessObjectBase._really_deactivate = function(l_8_0)
  l_8_0.__really_activated = false
end


