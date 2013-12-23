-- Decompiled using luadec 2.0.1 by sztupy (http://winmo.sztupy.hu)
-- Command line was: F:\SteamLibrary\SteamApps\common\PAYDAY 2\lua\lib\states\worldcamerastate.luac 

require("lib/states/GameState")
if not WorldCameraState then
  WorldCameraState = class(GameState)
end
WorldCameraState.init = function(l_1_0, l_1_1)
  GameState.init(l_1_0, "world_camera", l_1_1)
end

WorldCameraState.at_enter = function(l_2_0)
end

WorldCameraState.at_exit = function(l_3_0)
end


