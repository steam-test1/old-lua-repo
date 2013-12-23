-- Decompiled using luadec 2.0.1 by sztupy (http://winmo.sztupy.hu)
-- Command line was: F:\SteamLibrary\SteamApps\common\PAYDAY 2\lua\core\lib\managers\session\coresessionresponse.luac 

core:module("CoreSessionResponse")
if not Done then
  Done = class()
end
Done.DONE = 1
Done.done = function(l_1_0)
  l_1_0:_set_response(Done.DONE)
end

Done._is_response_value = function(l_2_0, l_2_1)
  assert(not l_2_0._is_destroyed, "You can not check a destroyed response object!")
  return l_2_0._response == l_2_1
end

Done.is_done = function(l_3_0)
  return l_3_0:_is_response_value(Done.DONE)
end

Done._set_response = function(l_4_0, l_4_1)
  assert(not l_4_0._is_destroyed, "You can not respond to a destroyed response object!")
  assert(l_4_0._response == nil, "Response has already been set!")
  l_4_0._response = l_4_1
end

Done.destroy = function(l_5_0)
  l_5_0._is_destroyed = true
end

if not DoneOrFinished then
  DoneOrFinished = class(Done)
end
DoneOrFinished.FINISHED = 2
DoneOrFinished.finished = function(l_6_0)
  l_6_0:_set_response(DoneOrFinished.FINISHED)
end

DoneOrFinished.is_finished = function(l_7_0)
  return l_7_0:_is_response_value(DoneOrFinished.FINISHED)
end


