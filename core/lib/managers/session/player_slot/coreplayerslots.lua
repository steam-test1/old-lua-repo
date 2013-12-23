-- Decompiled using luadec 2.0.1 by sztupy (http://winmo.sztupy.hu)
-- Command line was: F:\SteamLibrary\SteamApps\common\PAYDAY 2\lua\core\lib\managers\session\player_slot\coreplayerslots.luac 

core:module("CorePlayerSlots")
core:import("CorePlayerSlot")
core:import("CoreSessionGenericState")
if not PlayerSlots then
  PlayerSlots = class(CoreSessionGenericState.State)
end
PlayerSlots.init = function(l_1_0, l_1_1, l_1_2)
  l_1_0._slots = {}
  l_1_0._local_user_manager = l_1_1
  l_1_0:_set_stable_for_loading()
  l_1_0._factory = l_1_2
end

PlayerSlots.clear = function(l_2_0)
  l_2_0._slots = {}
end

PlayerSlots.clear_session = function(l_3_0)
  for _,slot in pairs(l_3_0._slots) do
    slot:clear_session()
  end
end

PlayerSlots.add_player_slot = function(l_4_0)
  local new_index = #l_4_0._slots + 1
  local new_slot = CorePlayerSlot.PlayerSlot:new(l_4_0, l_4_0._local_user_manager)
  l_4_0._slots[new_index] = new_slot
  return new_slot
end

PlayerSlots._remove_player_slot = function(l_5_0, l_5_1)
  for index,slot in pairs(l_5_0._slots) do
    if slot == l_5_1 then
      l_5_0._slots[index] = nil
      return 
    end
  end
  assert(false, "couldn't find that player slot")
end

PlayerSlots.slots = function(l_6_0)
  return l_6_0._slots
end

PlayerSlots.transition = function(l_7_0)
  for _,slot in pairs(l_7_0._slots) do
    slot:transition()
  end
end

PlayerSlots.primary_slot = function(l_8_0)
  local primary_slot = l_8_0._slots[1]
  assert(primary_slot, "No primary slot defined")
  return primary_slot
end

PlayerSlots.has_primary_local_user = function(l_9_0)
  local primary_slot = l_9_0._slots[1]
  return (primary_slot ~= nil and primary_slot:has_assigned_user())
end

PlayerSlots.primary_local_user = function(l_10_0)
  local primary_slot = l_10_0._slots[1]
  assert(primary_slot, "No primary slot defined")
  assert(primary_slot:has_assigned_user(), "No user assigned to primary slot")
  return primary_slot:assigned_user()
end

PlayerSlots.create_players = function(l_11_0)
  for index,slot in pairs(l_11_0._slots) do
    if slot:has_assigned_user() then
      slot:create_player()
    end
  end
end

PlayerSlots.remove_players = function(l_12_0)
  for index,slot in pairs(l_12_0._slots) do
    if slot:has_player() then
      slot:remove_player()
    end
  end
end

PlayerSlots.enter_level_handler = function(l_13_0, l_13_1)
  for index,slot in pairs(l_13_0._slots) do
    local player = slot:player()
    if player then
      player:enter_level(l_13_1)
    end
  end
end

PlayerSlots.leave_level_handler = function(l_14_0, l_14_1)
  for index,slot in pairs(l_14_0._slots) do
    local player = slot:player()
    if player then
      player:leave_level(l_14_1)
    end
  end
end


