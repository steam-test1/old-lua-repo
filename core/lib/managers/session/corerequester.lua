-- Decompiled using luadec 2.0.1 by sztupy (http://winmo.sztupy.hu)
-- Command line was: F:\SteamLibrary\SteamApps\common\PAYDAY 2\lua\core\lib\managers\session\corerequester.luac 

core:module("CoreRequester")
if not Requester then
  Requester = class()
end
Requester.request = function(l_1_0)
  l_1_0._requested = true
end

Requester.cancel_request = function(l_2_0)
  l_2_0._requested = nil
end

Requester.is_requested = function(l_3_0)
  return l_3_0._requested == true
end

Requester.task_started = function(l_4_0)
  l_4_0._task_is_running = true
end

Requester.task_completed = function(l_5_0)
  assert(l_5_0._task_is_running ~= nil, "The task can not be completed, since it hasn't started")
  l_5_0._task_is_running = nil
  l_5_0._requested = nil
end

Requester.is_task_running = function(l_6_0)
  return l_6_0._task_is_running
end

Requester.force_task_completed = function(l_7_0)
  l_7_0._task_is_running = nil
  l_7_0._requested = nil
end


