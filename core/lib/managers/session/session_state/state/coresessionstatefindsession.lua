-- Decompiled using luadec 2.0.1 by sztupy (http://winmo.sztupy.hu)
-- Command line was: F:\SteamLibrary\SteamApps\common\PAYDAY 2\lua\core\lib\managers\session\session_state\state\coresessionstatefindsession.luac 

core:module("CoreSessionStateFindSession")
core:import("CoreSessionStateCreateSession")
core:import("CoreSessionStateJoinSession")
if not FindSession then
  FindSession = class()
end
FindSession.init = function(l_1_0)
  l_1_0.session_state._session_creator:find_session(l_1_0.session_state._session_info, callback(l_1_0, l_1_0, "_sessions_found"))
end

FindSession.destroy = function(l_2_0)
end

FindSession._sessions_found = function(l_3_0, l_3_1)
  if not l_3_1 then
    l_3_0._session_to_join = false
  end
  l_3_0._session_id_to_join = l_3_1[1].info
end

FindSession.transition = function(l_4_0)
  if l_4_0._session_id_to_join == false then
    return CoreSessionStateCreateSession.CreateSession
  elseif l_4_0._session_id_to_join ~= nil then
    return CoreSessionStateJoinSession.JoinSession, l_4_0._session_id_to_join
  end
end


