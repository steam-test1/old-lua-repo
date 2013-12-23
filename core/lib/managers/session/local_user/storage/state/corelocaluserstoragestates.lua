-- Decompiled using luadec 2.0.1 by sztupy (http://winmo.sztupy.hu)
-- Command line was: F:\SteamLibrary\SteamApps\common\PAYDAY 2\lua\core\lib\managers\session\local_user\storage\state\corelocaluserstoragestates.luac 

core:module("CoreLocalUserStorageStates")
if not Init then
  Init = class()
end
Init.transition = function(l_1_0)
  if l_1_0.storage._load:is_requested() then
    return Loading
  end
end

if not DetectSignOut then
  DetectSignOut = class()
end
DetectSignOut.init = function(l_2_0)
end

if not Loading then
  Loading = class(DetectSignOut)
end
Loading.init = function(l_3_0)
  DetectSignOut.init(l_3_0)
  l_3_0.storage:_start_load_task()
end

Loading.destroy = function(l_4_0)
  l_4_0.storage:_close_load_task()
end

Loading.transition = function(l_5_0)
  local status = l_5_0.storage:_load_status()
  if not status then
    return 
  end
  if status == SaveData.OK then
    return Ready
  else
    if status == SaveData.FILE_NOT_FOUND then
      return NoSaveGameFound
    else
      return LoadError
    end
  end
end

if not Ready then
  Ready = class()
end
Ready.init = function(l_6_0)
  l_6_0.storage:_set_stable_for_loading()
end

Ready.destroy = function(l_7_0)
  l_7_0.storage:_not_stable_for_loading()
end

Ready.transition = function(l_8_0)
end

if not NoSaveGameFound then
  NoSaveGameFound = class()
end
NoSaveGameFound.init = function(l_9_0)
  l_9_0.storage:_set_stable_for_loading()
end

NoSaveGameFound.transition = function(l_10_0)
  l_10_0.storage:_not_stable_for_loading()
end

if not LoadError then
  LoadError = class()
end
LoadError.transition = function(l_11_0)
end


