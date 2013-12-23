-- Decompiled using luadec 2.0.1 by sztupy (http://winmo.sztupy.hu)
-- Command line was: F:\SteamLibrary\SteamApps\common\PAYDAY 2\lua\core\lib\managers\session\session_state\state\coresessionstatejoinsession.luac 

core:module("CoreSessionStateJoinSession")
core:import("CoreSessionStateInSession")
if not JoinSession then
  JoinSession = class()
end
JoinSession.init = function(l_1_0, l_1_1)
  l_1_0.session_state._join_session_requester:task_started()
  l_1_0._session = l_1_0.session_state._session_creator:join_session(l_1_1)
  l_1_0._session._session_handler = l_1_0.session_state._factory:create_session_handler()
  l_1_0._session._session_handler._core_session_control = l_1_0.session_state
end

JoinSession.destroy = function(l_2_0)
  l_2_0.session_state._join_session_requester:task_completed()
end

JoinSession.transition = function(l_3_0)
  return CoreSessionStateInSession.InSession, l_3_0._session
end


