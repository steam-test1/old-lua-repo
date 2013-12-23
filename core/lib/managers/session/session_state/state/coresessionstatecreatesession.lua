-- Decompiled using luadec 2.0.1 by sztupy (http://winmo.sztupy.hu)
-- Command line was: F:\SteamLibrary\SteamApps\common\PAYDAY 2\lua\core\lib\managers\session\session_state\state\coresessionstatecreatesession.luac 

core:module("CoreSessionStateCreateSession")
core:import("CoreSessionStateInSession")
if not CreateSession then
  CreateSession = class()
end
CreateSession.init = function(l_1_0)
  local session_info = l_1_0.session_state._session_info
  local player_slots = l_1_0.session_state._player_slots
  l_1_0._session = l_1_0.session_state._session_creator:create_session(session_info, player_slots)
  l_1_0._session._session_handler = l_1_0.session_state._factory:create_session_handler()
  l_1_0._session._session_handler._core_session_control = l_1_0.session_state
  local local_users = l_1_0.session_state._local_user_manager:users()
  for _,local_user in pairs(local_users) do
    l_1_0._session:join_local_user(local_user)
  end
end

CreateSession.transition = function(l_2_0)
  return CoreSessionStateInSession.InSession, l_2_0._session
end


