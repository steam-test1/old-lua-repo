-- Decompiled using luadec 2.0.1 by sztupy (http://winmo.sztupy.hu)
-- Command line was: F:\SteamLibrary\SteamApps\common\PAYDAY 2\lua\core\lib\managers\session\local_user\storage\corelocaluserstorage.luac 

core:module("CoreLocalUserStorage")
core:import("CoreRequester")
core:import("CoreFiniteStateMachine")
core:import("CoreLocalUserStorageStates")
core:import("CoreSessionGenericState")
if not Storage then
  Storage = class(CoreSessionGenericState.State)
end
Storage.init = function(l_1_0, l_1_1, l_1_2, l_1_3, l_1_4)
  l_1_0._load = CoreRequester.Requester:new()
  l_1_0._state = CoreFiniteStateMachine.FiniteStateMachine:new(CoreLocalUserStorageStates.Init, "storage", l_1_0)
  l_1_0._local_user = l_1_1
  l_1_0._user_index = l_1_0._local_user._user_index
  l_1_0._settings_handler = l_1_2
  l_1_0._progress_handler = l_1_3
  l_1_0._profile_data_loaded_callback = l_1_4
end

Storage.transition = function(l_2_0)
  l_2_0._state:transition()
end

Storage.request_load = function(l_3_0)
  l_3_0._load:request()
end

Storage.request_save = function(l_4_0)
end

Storage._common_save_params = function(l_5_0)
  return {save_slots = {1}, preview = false, user_index = l_5_0._user_index}
end

Storage._start_load_task = function(l_6_0)
  local save_param = (l_6_0:_common_save_params())
  local callback = nil
  l_6_0._load_task = NewSave:load(save_param, callback)
  l_6_0._load:task_started()
end

Storage._load_status = function(l_7_0)
  if not l_7_0._load_task:has_next() then
    return 
  end
  local profile_data = l_7_0._load_task:next()
  if profile_data:status() == SaveData.OK then
    l_7_0:_profile_data_loaded(profile_data:information())
  end
  return profile_data:status()
end

Storage._close_load_task = function(l_8_0)
  l_8_0._load_task = nil
  l_8_0._load:task_completed()
end

Storage._fast_forward_profile_data = function(l_9_0, l_9_1, l_9_2, l_9_3)
  local func = nil
  repeat
    do
      local function_name = "convert_from_" .. tostring(l_9_3) .. "_to_" .. tostring(l_9_3 + 1)
      func = l_9_1[function_name]
      if func ~= nil then
        l_9_2 = func(l_9_1, l_9_2)
        l_9_3 = l_9_3 + 1
      end
    until func == nil
  end
  return l_9_2, l_9_3
end

Storage._profile_data_loaded = function(l_10_0, l_10_1)
  l_10_1.settings, l_10_1.settings.version = l_10_0:_fast_forward_profile_data(l_10_0._settings_handler, l_10_1.settings.title_data, l_10_1.settings.version), l_10_0
  l_10_1.progress, l_10_1.progress.version = l_10_0:_fast_forward_profile_data(l_10_0._progress_handler, l_10_1.progress.title_data, l_10_1.progress.version), l_10_0
  l_10_0._profile_data = l_10_1
  l_10_0._local_user:local_user_handler():profile_data_loaded()
end

Storage.profile_data_is_loaded = function(l_11_0)
  return l_11_0._profile_data ~= nil
end

Storage._create_profile_data = function(l_12_0)
  local profile_data = {}
  profile_data.settings = {}
  profile_data.settings.title_data = {}
  profile_data.settings.version = 0
  profile_data.progress = {}
  profile_data.progress.title_data = {}
  profile_data.progress.version = 0
  l_12_0:_profile_data_loaded(profile_data)
end

Storage.profile_settings = function(l_13_0)
  return l_13_0._profile_data.settings.title_data
end

Storage.profile_progress = function(l_14_0)
  return l_14_0._profile_data.progress.title_data
end


