-- Decompiled using luadec 2.0.1 by sztupy (http://winmo.sztupy.hu)
-- Command line was: F:\SteamLibrary\SteamApps\common\PAYDAY 2\lua\core\lib\managers\session\session_state\state\coresessionstateinit.luac 

core:module("CoreSessionStateInit")
core:import("CoreSessionStateFindSession")
if not Init then
  Init = class()
end
Init.init = function(l_1_0)
  assert(not l_1_0.session_state._quit_session_requester:is_requested())
end

Init.transition = function(l_2_0)
  if l_2_0.session_state._join_session_requester:is_requested() and l_2_0.session_state:player_slots():has_primary_local_user() then
    return CoreSessionStateFindSession.FindSession
  end
end


