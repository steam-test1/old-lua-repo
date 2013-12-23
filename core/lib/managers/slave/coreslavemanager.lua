-- Decompiled using luadec 2.0.1 by sztupy (http://winmo.sztupy.hu)
-- Command line was: F:\SteamLibrary\SteamApps\common\PAYDAY 2\lua\core\lib\managers\slave\coreslavemanager.luac 

core:module("CoreSlaveManager")
core:import("CoreCode")
core:import("CoreSlaveUpdators")
if not SlaveManager then
  SlaveManager = class()
end
SlaveManager.init = function(l_1_0)
  l_1_0._updator = nil
  l_1_0._status = false
end

SlaveManager.update = function(l_2_0, l_2_1, l_2_2)
  if l_2_0._status then
    l_2_0._updator:update(l_2_1, l_2_2)
  end
end

SlaveManager.paused_update = function(l_3_0, l_3_1, l_3_2)
  l_3_0:update(l_3_1, l_3_2)
end

SlaveManager.start = function(l_4_0, l_4_1, l_4_2)
  assert(not l_4_0._status, "[SlaveManager] Already started!")
  l_4_0._updator, l_4_0._status = CoreSlaveUpdators.SlaveUpdator:new(l_4_1, l_4_2), CoreSlaveUpdators.SlaveUpdator
  return l_4_0._status
end

SlaveManager.act_master = function(l_5_0, l_5_1, l_5_2, l_5_3, l_5_4)
  l_5_0._updator, l_5_0._status = CoreSlaveUpdators.MasterUpdator:new(assert(managers.viewport:first_active_viewport()), l_5_1, l_5_2, l_5_3, l_5_4), CoreSlaveUpdators.MasterUpdator
  return l_5_0._status
end

SlaveManager.set_batch_count = function(l_6_0, l_6_1)
  assert(not l_6_1 or l_6_1 > 0, "[SlaveManager] Batch count must be more then 0!")
  l_6_0._updator:set_batch_count(l_6_1)
end

SlaveManager.connected = function(l_7_0)
  return l_7_0._status
end

SlaveManager.type = function(l_8_0)
  return l_8_0._updator and l_8_0._updator:type() or nil
end

SlaveManager.peer = function(l_9_0)
  return l_9_0._updator and l_9_0._updator:peer() or nil
end


