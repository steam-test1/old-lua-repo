-- Decompiled using luadec 2.0.1 by sztupy (http://winmo.sztupy.hu)
-- Command line was: F:\SteamLibrary\SteamApps\common\PAYDAY 2\lua\core\lib\managers\session\player_slot\coreplayerslot.luac 

core:module("CorePlayerSlot")
core:import("CoreRequester")
core:import("CoreFiniteStateMachine")
core:import("CorePlayerSlotStateInit")
core:import("CorePlayer")
if not PlayerSlot then
  PlayerSlot = class()
end
PlayerSlot.init = function(l_1_0, l_1_1, l_1_2)
  l_1_0._perform_local_user_binding = CoreRequester.Requester:new()
  l_1_0._perform_debug_local_user_binding = CoreRequester.Requester:new()
  l_1_0._init = CoreRequester.Requester:new()
  l_1_0._user_state = CoreFiniteStateMachine.FiniteStateMachine:new(CorePlayerSlotStateInit.Init, "player_slot", l_1_0)
  l_1_0._player_slots_parent = l_1_1
  l_1_0._local_user_manager = l_1_2
end

PlayerSlot.destroy = function(l_2_0)
  l_2_0._player_slots_parent:_remove_player_slot(l_2_0)
  if l_2_0._player then
    l_2_0._player:destroy()
  end
end

PlayerSlot.clear_session = function(l_3_0)
  if l_3_0._player then
    l_3_0._player:destroy()
    l_3_0._player = nil
  end
end

PlayerSlot.remove = function(l_4_0)
  l_4_0:destroy()
end

PlayerSlot._release_user_from_slot = function(l_5_0)
  if l_5_0._assigned_user then
    l_5_0._assigned_user:_player_slot_lost(l_5_0)
  end
  l_5_0._assigned_user = nil
  l_5_0._init:request()
end

PlayerSlot.request_local_user_binding = function(l_6_0)
  l_6_0._perform_local_user_binding:request()
end

PlayerSlot.stop_local_user_binding = function(l_7_0)
  l_7_0._perform_local_user_binding:cancel_request()
end

PlayerSlot.request_debug_local_user_binding = function(l_8_0)
  l_8_0._perform_debug_local_user_binding:request()
end

PlayerSlot.has_assigned_user = function(l_9_0)
  return l_9_0._assigned_user ~= nil
end

PlayerSlot.assigned_user = function(l_10_0)
  return l_10_0._assigned_user
end

PlayerSlot.assign_local_user = function(l_11_0, l_11_1)
  assert(l_11_1, "Must specify a valid user")
  assert(l_11_0._assigned_user == nil, "A user has already been assigned to this slot")
  l_11_0._assigned_user = l_11_1
  l_11_0._assigned_user:_player_slot_assigned(l_11_0)
end

PlayerSlot.transition = function(l_12_0)
  l_12_0._user_state:transition()
end

PlayerSlot.create_player = function(l_13_0)
  assert(l_13_0._player == nil, "Player already created for this slot")
  local factory = l_13_0._player_slots_parent._factory
  local player_handler = factory:create_player_handler()
  l_13_0._player = CorePlayer.Player:new(l_13_0, player_handler)
  player_handler.core_player = l_13_0._player
  if l_13_0._assigned_user then
    l_13_0._assigned_user:assign_player(l_13_0._player)
  end
end

PlayerSlot.remove_player = function(l_14_0)
  if l_14_0._assigned_user then
    l_14_0._assigned_user:release_player(l_14_0._player)
  end
  l_14_0._player:destroy()
  l_14_0._player = nil
end

PlayerSlot.has_player = function(l_15_0)
  return l_15_0._player ~= nil
end

PlayerSlot.player = function(l_16_0)
  return l_16_0._player
end


