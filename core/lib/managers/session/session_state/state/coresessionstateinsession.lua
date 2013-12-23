-- Decompiled using luadec 2.0.1 by sztupy (http://winmo.sztupy.hu)
-- Command line was: F:\SteamLibrary\SteamApps\common\PAYDAY 2\lua\core\lib\managers\session\session_state\state\coresessionstateinsession.luac 

core:module("CoreSessionStateInSession")
core:import("CoreSessionStateQuitSession")
if not InSession then
  InSession = class()
end
InSession.init = function(l_1_0, l_1_1)
  assert(l_1_1)
  l_1_0._session = l_1_1
  l_1_0._session._session_handler:joined_session()
  l_1_0.session_state._game_state:request_game()
  l_1_0.session_state:player_slots():create_players()
end

InSession.destroy = function(l_2_0)
  l_2_0.session_state:player_slots():remove_players()
end

InSession.transition = function(l_3_0)
  if l_3_0._start_session then
    return CoreSessionStateInSessionStart, l_3_0._session
  end
  if l_3_0.session_state._quit_session_requester:is_requested() then
    return CoreSessionStateQuitSession.QuitSession, l_3_0._session
  end
end

InSession.start_session = function(l_4_0)
  l_4_0._start_session = true
end


