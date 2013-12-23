-- Decompiled using luadec 2.0.1 by sztupy (http://winmo.sztupy.hu)
-- Command line was: F:\SteamLibrary\SteamApps\common\PAYDAY 2\lua\core\lib\managers\session\game_state\state\coregamestateprefrontend.luac 

core:module("CoreGameStatePreFrontEnd")
core:import("CoreGameStateFrontEnd")
if not PreFrontEnd then
  PreFrontEnd = class()
end
PreFrontEnd.init = function(l_1_0)
  local player_slot = l_1_0.game_state:player_slots():primary_slot()
  player_slot:_release_user_from_slot()
  l_1_0.game_state._is_in_pre_front_end = true
end

PreFrontEnd.destroy = function(l_2_0)
  l_2_0.game_state._is_in_pre_front_end = false
end

PreFrontEnd.transition = function(l_3_0)
  if not l_3_0.game_state:player_slots():has_primary_local_user() then
    return 
  end
  local local_user = l_3_0.game_state:player_slots():primary_local_user()
  if local_user:profile_data_is_loaded() then
    return CoreGameStateFrontEnd.FrontEnd
  end
end


