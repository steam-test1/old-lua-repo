-- Decompiled using luadec 2.0.1 by sztupy (http://winmo.sztupy.hu)
-- Command line was: F:\SteamLibrary\SteamApps\common\PAYDAY 2\lua\lib\network\networkspawnpointext.luac 

if not NetworkSpawnPointExt then
  NetworkSpawnPointExt = class()
end
NetworkSpawnPointExt.init = function(l_1_0, l_1_1)
  if managers.network then
     -- Warning: missing end command somewhere! Added here
  end
end

NetworkSpawnPointExt.get_data = function(l_2_0, l_2_1)
  return {position = l_2_1:position(), rotation = l_2_1:rotation()}
end

NetworkSpawnPointExt.destroy = function(l_3_0, l_3_1)
end


