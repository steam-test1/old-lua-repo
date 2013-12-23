-- Decompiled using luadec 2.0.1 by sztupy (http://winmo.sztupy.hu)
-- Command line was: F:\SteamLibrary\SteamApps\common\PAYDAY 2\lua\core\lib\managers\session\player_slot\state\coreplayerslotstatedetectlocaluser.luac 

core:module("CorePlayerSlotStateDetectLocalUser")
core:import("CorePlayerSlotStateLocalUserBound")
core:import("CorePlayerSlotStateInit")
if not DetectLocalUser then
  DetectLocalUser = class()
end
DetectLocalUser.init = function(l_1_0)
  l_1_0.player_slot._perform_local_user_binding:task_started()
end

DetectLocalUser.destroy = function(l_2_0)
  l_2_0.player_slot._perform_local_user_binding:task_completed()
end

DetectLocalUser.transition = function(l_3_0)
  if l_3_0.player_slot._init:is_requested() then
    return CorePlayerSlotStateInit.Init
  end
  local input_provider_ids_pressed_start = l_3_0._input_manager:input_provider_id_that_presses_start()
  for _,input_provider_id in pairs(input_provider_ids_pressed_start) do
    local has_id = l_3_0.player_slot._local_user_manager:has_local_user_with_input_provider_id(input_provider_id)
    if not has_id then
      l_3_0.player_slot._local_user_manager:bind_local_user(l_3_0.player_slot, input_provider_id)
      return CorePlayerSlotStateLocalUserBound.LocalUserBound, l_3_0.player_slot:assigned_user()
    end
  end
end


