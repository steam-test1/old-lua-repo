-- Decompiled using luadec 2.0.1 by sztupy (http://winmo.sztupy.hu)
-- Command line was: F:\SteamLibrary\SteamApps\common\PAYDAY 2\lua\lib\managers\groupaimanager.luac 

require("lib/managers/group_ai_states/GroupAIStateBase")
require("lib/managers/group_ai_states/GroupAIStateEmpty")
require("lib/managers/group_ai_states/GroupAIStateBesiege")
if not GroupAIManager then
  GroupAIManager = class()
end
GroupAIManager.init = function(l_1_0)
  l_1_0:set_state("empty")
end

GroupAIManager.update = function(l_2_0, l_2_1, l_2_2)
  l_2_0._state:update(l_2_1, l_2_2)
end

GroupAIManager.paused_update = function(l_3_0, l_3_1, l_3_2)
  l_3_0._state:paused_update(l_3_1, l_3_2)
end

GroupAIManager.set_state = function(l_4_0, l_4_1)
  if l_4_1 == "empty" then
    l_4_0._state = GroupAIStateEmpty:new()
  elseif l_4_1 == "besiege" then
    l_4_0._state = GroupAIStateBesiege:new()
  elseif l_4_1 == "street" then
    l_4_0._state = GroupAIStateStreet:new()
  elseif l_4_1 == "airport" then
    l_4_0._state = GroupAIStateAirport:new()
  elseif l_4_1 == "zombie_apocalypse" then
    l_4_0._state = GroupAIStateZombieApocalypse:new()
  else
    Application:error("[GroupAIManager:set_state] inexistent state name", l_4_1)
    return 
  end
  l_4_0._state_name = l_4_1
end

GroupAIManager.state = function(l_5_0)
  return l_5_0._state
end

GroupAIManager.state_name = function(l_6_0)
  return l_6_0._state_name
end

GroupAIManager.state_names = function(l_7_0)
  return {"empty", "airport", "besiege", "street", "zombie_apocalypse"}
end

GroupAIManager.on_simulation_started = function(l_8_0)
  l_8_0._state:on_simulation_started()
end

GroupAIManager.on_simulation_ended = function(l_9_0)
  l_9_0._state:on_simulation_ended()
end

GroupAIManager.visualization_enabled = function(l_10_0)
  return l_10_0._state._draw_enabled
end


