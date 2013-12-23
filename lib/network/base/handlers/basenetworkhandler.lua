-- Decompiled using luadec 2.0.1 by sztupy (http://winmo.sztupy.hu)
-- Command line was: F:\SteamLibrary\SteamApps\common\PAYDAY 2\lua\lib\network\base\handlers\basenetworkhandler.luac 

if not BaseNetworkHandler then
  BaseNetworkHandler = class()
end
local l_0_0 = BaseNetworkHandler
local l_0_1 = {}
local l_0_2 = {}
l_0_2.ingame_standard = true
l_0_2.ingame_mask_off = true
l_0_2.ingame_clean = true
l_0_2.ingame_bleed_out = true
l_0_2.ingame_fatal = true
l_0_2.ingame_arrested = true
l_0_2.ingame_electrified = true
l_0_2.ingame_incapacitated = true
l_0_2.ingame_waiting_for_players = true
l_0_2.ingame_waiting_for_respawn = true
l_0_2.ingame_access_camera = true
l_0_1.any_ingame = l_0_2
l_0_2 = {ingame_standard = true, ingame_mask_off = true, ingame_clean = true, ingame_bleed_out = true}
l_0_2.ingame_fatal = true
l_0_2.ingame_arrested = true
l_0_2.ingame_electrified = true
l_0_2.ingame_incapacitated = true
l_0_2.ingame_waiting_for_respawn = true
l_0_2.ingame_access_camera = true
l_0_1.any_ingame_playing = l_0_2
l_0_2 = {ingame_bleed_out = true, ingame_fatal = true, ingame_incapacitated = true}
l_0_1.downed = l_0_2
l_0_2 = {ingame_bleed_out = true, ingame_fatal = true, ingame_arrested = true, ingame_incapacitated = true}
l_0_1.need_revive = l_0_2
l_0_2 = {ingame_arrested = true}
l_0_1.arrested = l_0_2
l_0_2 = {gameoverscreen = true}
l_0_1.game_over = l_0_2
l_0_2 = {gameoverscreen = true, victoryscreen = true}
l_0_1.any_end_game = l_0_2
l_0_2 = {ingame_waiting_for_players = true}
l_0_1.waiting_for_players = l_0_2
l_0_2 = {ingame_waiting_for_respawn = true}
l_0_1.waiting_for_respawn = l_0_2
l_0_2 = {menu_main = true}
l_0_1.menu = l_0_2
l_0_2 = {menu_main = true, ingame_waiting_for_players = true, ingame_lobby_menu = true}
l_0_1.player_slot = l_0_2
l_0_2 = {menu_main = true, ingame_lobby_menu = true}
l_0_1.lobby = l_0_2
l_0_0._gamestate_filter = l_0_1
l_0_0 = BaseNetworkHandler
l_0_1 = function()
  local session = managers.network:session()
  if not session then
    print("[BaseNetworkHandler._verify_in_session] Discarding message")
    Application:stack_dump()
  end
  return session
end

l_0_0._verify_in_session = l_0_1
l_0_0 = BaseNetworkHandler
l_0_1 = function()
  local session = managers.network:session()
  if session then
    session = session:is_host()
  end
  if not session then
    print("[BaseNetworkHandler._verify_in_server_session] Discarding message")
    Application:stack_dump()
  end
  return session
end

l_0_0._verify_in_server_session = l_0_1
l_0_0 = BaseNetworkHandler
l_0_1 = function()
  local session = managers.network:session()
  if session then
    session = session:is_client()
  end
  if not session then
    print("[BaseNetworkHandler._verify_in_client_session] Discarding message")
    Application:stack_dump()
  end
  return session
end

l_0_0._verify_in_client_session = l_0_1
l_0_0 = BaseNetworkHandler
l_0_1 = function(l_4_0)
  local session = (managers.network:session())
  local peer = nil
  if session then
    if l_4_0:protocol_at_index(0) == "STEAM" then
      peer = session:peer_by_user_id(l_4_0:ip_at_index(0))
    else
      peer = session:peer_by_ip(l_4_0:ip_at_index(0))
    end
    if peer then
      return peer
    end
  end
  if peer then
    print("[BaseNetworkHandler._verify_sender] Discarding message", session, peer:id())
  end
  Application:stack_dump()
end

l_0_0._verify_sender = l_0_1
l_0_0 = BaseNetworkHandler
l_0_1 = function(l_5_0, l_5_1)
  if BaseNetworkHandler._verify_sender(l_5_1) then
    return BaseNetworkHandler._verify_character(l_5_0)
  end
end

l_0_0._verify_character_and_sender = l_0_1
l_0_0 = BaseNetworkHandler
l_0_1 = function(l_6_0)
  if alive(l_6_0) then
    return not l_6_0:character_damage():dead()
  end
end

l_0_0._verify_character = l_0_1
l_0_0 = BaseNetworkHandler
l_0_1 = function(l_7_0)
  local correct_state = l_7_0[game_state_machine:last_queued_state_name()]
  if correct_state then
    return true
  end
  print("[BaseNetworkHandler._verify_gamestate] Discarding message. current state:", game_state_machine:last_queued_state_name(), "acceptable:", inspect(l_7_0))
  Application:stack_dump()
end

l_0_0._verify_gamestate = l_0_1
l_0_0 = BaseNetworkHandler
l_0_1 = function(l_8_0, l_8_1)
  if l_8_0._flushing_unit_too_early_packets then
    return 
  end
  if not alive(l_8_1) then
    return 
  end
  local unit_id = l_8_1:id()
  if unit_id == -1 then
    return 
  end
  if not l_8_0._unit_too_early_queue then
    return 
  end
  local unit_rpcs = l_8_0._unit_too_early_queue[unit_id]
  if not unit_rpcs then
    return 
  end
  print("[BaseNetworkHandler:_chk_flush_unit_too_early_packets]", unit_id)
  l_8_0._flushing_unit_too_early_packets = true
  for _,rpc_info in ipairs(unit_rpcs) do
    print(" calling", rpc_info.fun_name)
    rpc_info.params[rpc_info.unit_param_index] = l_8_1
    l_8_0[rpc_info.fun_name](l_8_0, unpack(rpc_info.params))
  end
  l_8_0._unit_too_early_queue[unit_id] = nil
  if not next(l_8_0._unit_too_early_queue) then
    l_8_0._unit_too_early_queue = nil
  end
  l_8_0._flushing_unit_too_early_packets = nil
end

l_0_0._chk_flush_unit_too_early_packets = l_0_1
l_0_0 = BaseNetworkHandler
l_0_1 = function(l_9_0, l_9_1, l_9_2, l_9_3, l_9_4, ...)
  if l_9_0._flushing_unit_too_early_packets then
    return 
  end
  if alive(l_9_1) then
    return 
  end
  if not l_9_0._unit_too_early_queue then
    l_9_0._unit_too_early_queue = {}
  end
  local data = {unit_param_index = l_9_4, fun_name = l_9_3, params = {...}}
  do
    local unit_id = tonumber(l_9_2)
    if not l_9_0._unit_too_early_queue[unit_id] then
      l_9_0._unit_too_early_queue[unit_id] = {}
    end
    table.insert(l_9_0._unit_too_early_queue[unit_id], data)
    print("[BaseNetworkHandler:_chk_unit_too_early]", l_9_2, l_9_3)
    return true
  end
   -- DECOMPILER ERROR: Confused about usage of registers for local variables.

end

l_0_0._chk_unit_too_early = l_0_1

