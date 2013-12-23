-- Decompiled using luadec 2.0.1 by sztupy (http://winmo.sztupy.hu)
-- Command line was: F:\SteamLibrary\SteamApps\common\PAYDAY 2\lua\core\lib\managers\session\player_slot\state\coreplayerslotstatelocaluserbound.luac 

core:module("CorePlayerSlotStateLocalUserBound")
core:import("CorePlayerSlotStateInit")
if not LocalUserBound then
  LocalUserBound = class()
end
LocalUserBound.init = function(l_1_0, l_1_1)
  l_1_0._local_user = l_1_1
end

LocalUserBound.destroy = function(l_2_0)
end

LocalUserBound.transition = function(l_3_0)
  if l_3_0.player_slot._init:is_requested() then
    return CorePlayerSlotStateInit.Init
  end
end


