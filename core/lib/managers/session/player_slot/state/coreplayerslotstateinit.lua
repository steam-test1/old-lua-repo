-- Decompiled using luadec 2.0.1 by sztupy (http://winmo.sztupy.hu)
-- Command line was: F:\SteamLibrary\SteamApps\common\PAYDAY 2\lua\core\lib\managers\session\player_slot\state\coreplayerslotstateinit.luac 

core:module("CorePlayerSlotStateInit")
core:import("CorePlayerSlotStateDetectLocalUser")
core:import("CorePlayerSlotStateLocalUserDebugBind")
if not Init then
  Init = class()
end
Init.init = function(l_1_0)
  l_1_0.player_slot._init:task_started()
end

Init.destroy = function(l_2_0)
  l_2_0.player_slot._init:task_completed()
end

Init.transition = function(l_3_0)
  if l_3_0.player_slot._perform_debug_local_user_binding:is_requested() then
    return CorePlayerSlotStateLocalUserDebugBind.LocalUserDebugBind
  else
    if l_3_0.player_slot._perform_local_user_binding:is_requested() then
      return CorePlayerSlotStateDetectLocalUser.DetectLocalUser
    end
  end
end


