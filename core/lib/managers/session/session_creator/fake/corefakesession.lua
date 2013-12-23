-- Decompiled using luadec 2.0.1 by sztupy (http://winmo.sztupy.hu)
-- Command line was: F:\SteamLibrary\SteamApps\common\PAYDAY 2\lua\core\lib\managers\session\session_creator\fake\corefakesession.luac 

core:module("CoreFakeSession")
core:import("CoreSession")
if not Session then
  Session = class()
end
Session.init = function(l_1_0)
end

Session.delete_session = function(l_2_0)
  cat_print("debug", "FakeSession: delete_session")
end

Session.start_session = function(l_3_0)
  cat_print("debug", "FakeSession: start_session")
end

Session.end_session = function(l_4_0)
  cat_print("debug", "FakeSession: end_session")
end

Session.join_local_user = function(l_5_0, l_5_1)
  cat_print("debug", "FakeSession: Local user:'" .. l_5_1:gamer_name() .. "' joined!")
end

Session.join_remote_user = function(l_6_0, l_6_1)
  cat_print("debug", "FakeSession: Remote user:'" .. l_6_1:gamer_name() .. "' joined!")
end


