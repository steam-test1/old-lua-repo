-- Decompiled using luadec 2.0.1 by sztupy (http://winmo.sztupy.hu)
-- Command line was: F:\SteamLibrary\SteamApps\common\PAYDAY 2\lua\core\lib\managers\session\session_creator\fake\corefakesessioncreator.luac 

core:module("CoreFakeSessionCreator")
core:import("CoreFakeSession")
if not Creator then
  Creator = class()
end
Creator.init = function(l_1_0)
end

Creator.create_session = function(l_2_0, l_2_1, l_2_2)
  if l_2_1:is_ranked() then
    cat_print("debug", "create_session: is_ranked")
  end
  if l_2_1:can_join_in_progress() then
    cat_print("debug", "create_session: is_ranked")
  end
  return CoreFakeSession.Session:new()
end

Creator.join_session = function(l_3_0, l_3_1)
  return CoreFakeSession.Session:new()
end

Creator.find_session = function(l_4_0, l_4_1, l_4_2)
  local fake_sessions = {{info = 2}, {info = 3}}
  l_4_2(fake_sessions)
end


