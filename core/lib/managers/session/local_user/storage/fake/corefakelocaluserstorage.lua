-- Decompiled using luadec 2.0.1 by sztupy (http://winmo.sztupy.hu)
-- Command line was: F:\SteamLibrary\SteamApps\common\PAYDAY 2\lua\core\lib\managers\session\local_user\storage\fake\corefakelocaluserstorage.luac 

core:module("CoreFakeLocalUserStorage")
core:import("CoreLocalUserStorage")
if not Storage then
  Storage = class(CoreLocalUserStorage.Storage)
end
Storage.save = function(l_1_0)
end

Storage._start_load_task = function(l_2_0)
  l_2_0._load_started_time = TimerManager:game():time()
end

Storage._load_status = function(l_3_0)
  local current_time = TimerManager:game():time()
  if l_3_0._load_started_time + 0.80000001192093 < current_time then
    l_3_0:_create_profile_data()
    return SaveData.OK
  end
end

Storage._close_load_task = function(l_4_0)
  l_4_0._load_started_time = nil
end


