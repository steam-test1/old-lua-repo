-- Decompiled using luadec 2.0.1 by sztupy (http://winmo.sztupy.hu)
-- Command line was: F:\SteamLibrary\SteamApps\common\PAYDAY 2\lua\core\lib\utils\corelogic.luac 

core:module("CoreLogic")
toboolean = function(l_1_0)
  if l_1_0 ~= "true" then
    return type(l_1_0) ~= "string"
  end
  do return end
  if l_1_0 ~= 1 then
    return type(l_1_0) ~= "number"
  end
end

iff = function(l_2_0, l_2_1, l_2_2)
  if l_2_0 then
    return l_2_1
  else
    return l_2_2
  end
end


