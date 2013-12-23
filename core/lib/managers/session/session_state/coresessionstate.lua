-- Decompiled using luadec 2.0.1 by sztupy (http://winmo.sztupy.hu)
-- Command line was: F:\SteamLibrary\SteamApps\common\PAYDAY 2\lua\core\lib\managers\session\session_state\coresessionstate.luac 

core:module("CoreSessionState")
core:import("CorePortableSessionCreator")
core:import("CorePlayerSlots")
core:import("CoreRequester")
core:import("CoreFiniteStateMachine")
core:import("CoreSessionStateInit")
core:import("CoreSessionInfo")
core:import("CoreSessionGenericState")
if not SessionState then
  SessionState = class(CoreSessionGenericState.State)
end
SessionState.init = function(l_1_0, l_1_1, l_1_2, l_1_3)
  l_1_0._factory = l_1_1
  l_1_0._session_creator = CorePortableSessionCreator.Creator:new(l_1_0)
  l_1_0._join_session_requester = CoreRequester.Requester:new()
  l_1_0._quit_session_requester = CoreRequester.Requester:new()
  l_1_0._start_session_requester = CoreRequester.Requester:new()
  l_1_0._player_slots = l_1_2
  l_1_0._game_state = l_1_3
  l_1_0._state = CoreFiniteStateMachine.FiniteStateMachine:new(CoreSessionStateInit.Init, "session_state", l_1_0)
  l_1_0._session_info = CoreSessionInfo.Info:new()
  l_1_0:_set_stable_for_loading()
end

SessionState.transition = function(l_2_0)
  l_2_0._state:transition()
end

SessionState.player_slots = function(l_3_0)
  return l_3_0._player_slots
end

SessionState.join_standard_session = function(l_4_0)
  l_4_0._join_session_requester:request()
end

SessionState.start_session = function(l_5_0)
  l_5_0._state:state():start_session()
end

SessionState.quit_session = function(l_6_0)
  l_6_0._quit_session_requester:request()
end

SessionState.end_session = function(l_7_0)
  l_7_0._state:state():end_session()
end

SessionState.session_info = function(l_8_0)
  return l_8_0._session_info
end


