-- Decompiled using luadec 2.0.1 by sztupy (http://winmo.sztupy.hu)
-- Command line was: F:\SteamLibrary\SteamApps\common\PAYDAY 2\lua\core\lib\managers\input\coreinputtargetdescription.luac 

core:module("CoreInputTargetDescription")
if not TargetDescription then
  TargetDescription = class()
end
TargetDescription.init = function(l_1_0, l_1_1, l_1_2)
  l_1_0._name = l_1_1
  assert(l_1_2 == "bool" or l_1_2 == "vector")
  l_1_0._type_name = l_1_2
end

TargetDescription.target_name = function(l_2_0)
  return l_2_0._name
end

TargetDescription.target_type_name = function(l_3_0)
  return l_3_0._type_name
end


