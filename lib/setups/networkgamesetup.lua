-- Decompiled using luadec 2.0.1 by sztupy (http://winmo.sztupy.hu)
-- Command line was: F:\SteamLibrary\SteamApps\common\PAYDAY 2\lua\lib\setups\networkgamesetup.luac 

require("lib/setups/GameSetup")
require("lib/network/base/NetworkManager")
require("lib/network/NetworkGame")
if not NetworkGameSetup then
  NetworkGameSetup = class(GameSetup)
end
NetworkGameSetup.init_managers = function(l_1_0, l_1_1)
  GameSetup.init_managers(l_1_0, l_1_1)
  l_1_1.network = NetworkManager:new("NetworkGame")
end

NetworkGameSetup.init_finalize = function(l_2_0)
  GameSetup.init_finalize(l_2_0)
  managers.network:init_finalize()
end

NetworkGameSetup.update = function(l_3_0, l_3_1, l_3_2)
  GameSetup.update(l_3_0, l_3_1, l_3_2)
  managers.network:update(l_3_1, l_3_2)
end

NetworkGameSetup.paused_update = function(l_4_0, l_4_1, l_4_2)
  GameSetup.paused_update(l_4_0, l_4_1, l_4_2)
  managers.network:update(l_4_1, l_4_2)
end

NetworkGameSetup.end_update = function(l_5_0, l_5_1, l_5_2)
  GameSetup.end_update(l_5_0, l_5_1, l_5_2)
  managers.network:end_update()
end

NetworkGameSetup.paused_end_update = function(l_6_0, l_6_1, l_6_2)
  GameSetup.paused_end_update(l_6_0, l_6_1, l_6_2)
  managers.network:end_update()
end

return NetworkGameSetup

