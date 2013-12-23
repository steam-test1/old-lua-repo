-- Decompiled using luadec 2.0.1 by sztupy (http://winmo.sztupy.hu)
-- Command line was: F:\SteamLibrary\SteamApps\common\PAYDAY 2\lua\core\lib\managers\session\session_state\state\coresessionstatequitsession.luac 

core:module("CoreSessionStateQuitSession")
core:import("CoreSessionStateInit")
if not QuitSession then
  QuitSession = class()
end
QuitSession.init = function(l_1_0, l_1_1)
  l_1_0._session = l_1_1
  l_1_0.session_state._quit_session_requester:task_started()
  l_1_0.session_state:player_slots():clear_session()
  l_1_0.session_state._game_state:request_front_end()
  l_1_0._session:delete_session()
end

QuitSession.destroy = function(l_2_0)
  l_2_0.session_state._quit_session_requester:task_completed()
  l_2_0.session_state._session = nil
end

QuitSession.transition = function(l_3_0)
  return CoreSessionStateInit.Init, l_3_0._session
end


