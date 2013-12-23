-- Decompiled using luadec 2.0.1 by sztupy (http://winmo.sztupy.hu)
-- Command line was: F:\SteamLibrary\SteamApps\common\PAYDAY 2\lua\core\lib\managers\slave\coreslaveupdators.luac 

core:module("CoreSlaveUpdators")
core:import("CoreTable")
core:import("CoreCode")
core:import("CoreEngineAccess")
NETWORK_SLAVE_RECEIVER = Idstring("slaveupdator")
NETWORK_MASTER_RECEIVER = Idstring("masterupdator")
DEFAULT_NETWORK_PORT = 31254
DEFAULT_NETWORK_LSPORT = 31255
UNITS_PER_FRAME = 1
if not SlaveManager then
  SlaveManager = class()
end
if not Updator then
  Updator = class()
end
Updator.init = function(l_1_0)
end

Updator.peer = function(l_2_0)
  return l_2_0._peer
end

Updator.update = function(l_3_0)
end

Updator.set_batch_count = function(l_4_0)
end

if not SlaveUpdator then
  SlaveUpdator = class(Updator)
end
SlaveUpdator.init = function(l_5_0, l_5_1, l_5_2)
  Network:bind(l_5_2 or DEFAULT_NETWORK_PORT, l_5_0)
  Network:set_receiver(NETWORK_SLAVE_RECEIVER, l_5_0)
  l_5_0._units = {}
  l_5_0._pings = {}
  l_5_1:enable_slave(l_5_2)
  return true
end

SlaveUpdator.type = function(l_6_0)
  return "slave"
end

SlaveUpdator.slaveupdators_sync = function(l_7_0, l_7_1, l_7_2, l_7_3, l_7_4, l_7_5)
  local unit = l_7_0._units[l_7_1]
  if CoreCode.alive(unit) then
    unit:set_position(l_7_3)
    unit:set_rotation(l_7_4)
    l_7_0._pings[l_7_1] = nil
  else
    CoreEngineAccess._editor_load(Idstring("unit"), l_7_2:id())
    unit = World:spawn_unit_without_extensions(l_7_2:id(), l_7_3, l_7_4)
    l_7_0._units[l_7_1] = unit
  end
  l_7_5:slaveupdators_ready_to_send()
end

SlaveUpdator.slaveupdators_reset = function(l_8_0, l_8_1)
  for _,unit in pairs(l_8_0._pings) do
    if CoreCode.alive(unit) then
      World:delete_unit(unit)
    end
  end
  l_8_0._pings = table.map_copy(l_8_0._units)
  l_8_1:slaveupdators_ready_to_send()
end

SlaveUpdator.slaveupdators_init = function(l_9_0)
  for _,unit in ipairs(World:find_units_quick("all")) do
    if CoreCode.alive(unit) then
      World:delete_unit(unit)
    end
  end
  l_9_0._units = {}
  l_9_0._pings = {}
end

if not MasterUpdator then
  MasterUpdator = class(Updator)
end
MasterUpdator.init = function(l_10_0, l_10_1, l_10_2, l_10_3, l_10_4, l_10_5)
  l_10_0._peer = Network:handshake(l_10_2 or "localhost", l_10_3 or DEFAULT_NETWORK_PORT)
  if not l_10_0._peer then
    return false
  end
  Network:bind(l_10_4 or DEFAULT_NETWORK_LSPORT, l_10_0)
  Network:set_receiver(NETWORK_MASTER_RECEIVER, l_10_0)
  l_10_0._unitqueue = {}
  l_10_0._ready_to_send = true
  l_10_1:enable_master(l_10_2, l_10_3, l_10_4, l_10_5)
  l_10_0:set_batch_count()
  l_10_0._peer:slaveupdators_init()
  return true
end

MasterUpdator.type = function(l_11_0)
  return "master"
end

MasterUpdator.set_batch_count = function(l_12_0, l_12_1)
  l_12_0._units_per_frame = l_12_1 or UNITS_PER_FRAME
end

MasterUpdator.update = function(l_13_0, l_13_1, l_13_2)
  if #l_13_0._unitqueue == 0 then
    l_13_0._peer:slaveupdators_reset()
    l_13_0._unitqueue = World:find_units_quick("all")
  end
  if not l_13_0._ready_to_send then
    return 
  end
  local num_sent = 0
  for i = #l_13_0._unitqueue, 1, -1 do
    local unit = l_13_0._unitqueue[i]
    table.remove(l_13_0._unitqueue, i)
    if CoreCode.alive(unit) and unit:visible() and unit:enabled() and not unit:mover() then
      l_13_0._peer:slaveupdators_sync(tostring(unit:key()), assert(unit:name():s()), unit:position(), unit:rotation())
      l_13_0._ready_to_send = false
      num_sent = num_sent + 1
  else
    if l_13_0._units_per_frame <= num_sent then
      end
    end
  end
end

MasterUpdator.slaveupdators_ready_to_send = function(l_14_0)
  l_14_0._ready_to_send = true
end


