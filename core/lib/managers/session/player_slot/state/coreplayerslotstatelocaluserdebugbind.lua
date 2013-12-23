-- Decompiled using luadec 2.0.1 by sztupy (http://winmo.sztupy.hu)
-- Command line was: F:\SteamLibrary\SteamApps\common\PAYDAY 2\lua\core\lib\managers\session\player_slot\state\coreplayerslotstatelocaluserdebugbind.luac 

core:module("CorePlayerSlotStateLocalUserDebugBind")
core:import("CorePlayerSlotStateLocalUserBound")
if not UserDebugBind then
  LocalUserDebugBind = class()
end
LocalUserDebugBind.init = function(l_1_0)
  l_1_0.player_slot._local_user_manager:debug_bind_primary_input_provider_id(l_1_0.player_slot)
end

LocalUserDebugBind.transition = function(l_2_0)
  return CorePlayerSlotStateLocalUserBound.LocalUserBound, l_2_0.player_slot:assigned_user()
end


