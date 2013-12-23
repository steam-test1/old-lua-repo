-- Decompiled using luadec 2.0.1 by sztupy (http://winmo.sztupy.hu)
-- Command line was: F:\SteamLibrary\SteamApps\common\PAYDAY 2\lua\core\lib\managers\session\local_user\corelocaluser.luac 

core:module("CoreLocalUser")
core:import("CorePortableLocalUserStorage")
core:import("CoreSessionGenericState")
if not User then
  User = class(CoreSessionGenericState.State)
end
User.init = function(l_1_0, l_1_1, l_1_2, l_1_3, l_1_4, l_1_5)
  l_1_0._local_user_handler = l_1_1
  l_1_0._input_input_provider = l_1_2
  l_1_0._user_index = l_1_3
  l_1_0._storage = CorePortableLocalUserStorage.Storage:new(l_1_0, l_1_4, l_1_5, profile_data_loaded_callback)
  l_1_0._game_name = "Player #" .. tostring(l_1_0._user_index)
end

User.default_data = function(l_2_0)
end

User.save = function(l_3_0, l_3_1)
end

User.transition = function(l_4_0)
  l_4_0._storage:transition()
end

User._player_slot_assigned = function(l_5_0, l_5_1)
  assert(l_5_0._player_slot == nil, "This user already has an assigned player slot")
  l_5_0._player_slot = l_5_1
  l_5_0._storage:request_load()
end

User._player_slot_lost = function(l_6_0, l_6_1)
  assert(l_6_0._player_slot ~= nil, "This user can get a lost player slot, no slot was assigned to begin with")
  assert(l_6_0._player_slot == l_6_1, "Player has lost a player slot that wasn't assigned")
  l_6_0._player_slot = nil
end

User.profile_data_is_loaded = function(l_7_0)
  return l_7_0._storage:profile_data_is_loaded()
end

User.enter_level = function(l_8_0, l_8_1)
  l_8_0._local_user_handler:enter_level(l_8_1)
end

User.leave_level = function(l_9_0, l_9_1)
  l_9_0._local_user_handler:leave_level(l_9_1)
  l_9_0:release_player()
end

User.gamer_name = function(l_10_0)
  return l_10_0._game_name
end

User.is_stable_for_loading = function(l_11_0)
  return l_11_0._storage:is_stable_for_loading()
end

User.assign_player = function(l_12_0, l_12_1)
  l_12_0._player = l_12_1
  l_12_0._local_user_handler:player_assigned(l_12_0)
end

User.release_player = function(l_13_0)
  l_13_0._local_user_handler:player_removed()
  l_13_0._player = nil
  l_13_0._avatar = nil
end

User.assigned_player = function(l_14_0)
  return l_14_0._player
end

User.local_user_handler = function(l_15_0)
  return l_15_0._local_user_handler
end

User.profile_settings = function(l_16_0)
  return l_16_0._storage:profile_settings()
end

User.profile_progress = function(l_17_0)
  return l_17_0._storage:profile_progress()
end

User.save_profile_settings = function(l_18_0)
  return l_18_0._storage:request_save()
end

User.save_profile_progress = function(l_19_0)
  return l_19_0._storage:request_save()
end

User.engine_input_input_input_provider = function(l_20_0)
  return l_20_0._input_input_provider
end

User.update = function(l_21_0, l_21_1, l_21_2)
  if not l_21_0._avatar and l_21_0._player and l_21_0._player:has_avatar() then
    local input_input_provider = l_21_0:engine_input_input_input_provider()
    local avatar = l_21_0._player:avatar()
    avatar:set_input(input_input_provider)
    l_21_0._avatar = avatar
  end
  l_21_0._local_user_handler:update(l_21_1, l_21_2)
end


