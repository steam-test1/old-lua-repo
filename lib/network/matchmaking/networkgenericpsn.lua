-- Decompiled using luadec 2.0.1 by sztupy (http://winmo.sztupy.hu)
-- Command line was: F:\SteamLibrary\SteamApps\common\PAYDAY 2\lua\lib\network\matchmaking\networkgenericpsn.luac 

if not NetworkGenericPSN then
  NetworkGenericPSN = class()
end
NetworkGenericPSN.init = function(l_1_0)
  cat_print("lobby", "generic = NetworkGenericPSN")
  local f = function()
   end
  PSN:set_matchmaking_callback("room_invitation", f)
  local psn_left = function(...)
    self:psn_member_left(...)
     -- DECOMPILER ERROR: Confused about usage of registers for local variables.

   end
  PSN:set_matchmaking_callback("member_left", psn_left)
  local psn_join = function(...)
    self:psn_member_joined(...)
     -- DECOMPILER ERROR: Confused about usage of registers for local variables.

   end
  PSN:set_matchmaking_callback("member_joined", psn_join)
  local psn_destroyed = function(...)
    self:psn_session_destroyed(...)
     -- DECOMPILER ERROR: Confused about usage of registers for local variables.

   end
  PSN:set_matchmaking_callback("session_destroyed", psn_destroyed)
end

NetworkGenericPSN.update = function(l_2_0, l_2_1)
  managers.network.voice_chat:update()
end

NetworkGenericPSN.start_game = function(l_3_0)
  Global.rendezvous = {}
  Global.rendezvous.rendevous = managers.network.shared_rdv:rendezvousonline()
  Global.rendezvous.is_online = managers.network.shared_rdv:is_online()
  managers.network.voice_chat:_save_globals(true)
  managers.network.group:_save_global()
  managers.network.matchmake:_save_global()
end

NetworkGenericPSN.end_game = function(l_4_0)
  Global.rendezvous = {}
  Global.rendezvous.rendevous = managers.network.shared_rdv:rendezvousonline()
  Global.rendezvous.is_online = managers.network.shared_rdv:is_online()
  managers.network.generic:set_entermenu(true)
  managers.network.voice_chat:_save_globals(managers.network.group:room_id() or false)
  managers.network.group:_save_global()
end

NetworkGenericPSN.psn_member_joined = function(l_5_0, l_5_1)
  managers.network.matchmake:psn_member_joined(l_5_1)
end

NetworkGenericPSN.psn_member_left = function(l_6_0, l_6_1)
  managers.network.matchmake:psn_member_left(l_6_1)
end

NetworkGenericPSN.psn_session_destroyed = function(l_7_0, l_7_1)
  cat_print("lobby", "NetworkGenericPSN:_session_destroyed_cb")
  cat_print_inspect("lobby", l_7_1)
  managers.network.voice_chat:psn_session_destroyed(l_7_1.room_id)
  managers.network.matchmake:_session_destroyed_cb(l_7_1.room_id)
  managers.network.group:_session_destroyed_cb(l_7_1.room_id)
end


