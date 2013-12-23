-- Decompiled using luadec 2.0.1 by sztupy (http://winmo.sztupy.hu)
-- Command line was: F:\SteamLibrary\SteamApps\common\PAYDAY 2\lua\lib\units\props\missiondoor.luac 

if not MissionDoor then
  MissionDoor = class(UnitBase)
end
MissionDoor.init = function(l_1_0, l_1_1)
  MissionDoor.super.init(l_1_0, l_1_1, false)
  l_1_0._unit = l_1_1
  l_1_0._devices = {}
  l_1_0._powered = true
end

MissionDoor.update = function(l_2_0, l_2_1, l_2_2, l_2_3)
  if l_2_0._explode_t and l_2_0._explode_t < l_2_2 then
    l_2_0:_c4_sequence_done(l_2_0)
  end
end

MissionDoor.activate = function(l_3_0)
  if Network:is_client() then
    return 
  end
  if l_3_0._active then
    Application:error("[MissionDoor:activate()] allready active", l_3_0._unit)
    return 
  end
  l_3_0._active = true
  CoreDebug.cat_debug("gaspode", "MissionDoor:activate", l_3_0.tweak_data)
  local devices_data = tweak_data.mission_door[l_3_0.tweak_data].devices
  for type,device_data in pairs(devices_data) do
    local amount = #device_data
    l_3_0._devices[type] = {units = {}, placed = false, completed = false, amount = amount, placed_counter = 0, completed_counter = 0}
    for _,unit_data in ipairs(device_data) do
      local a_obj = l_3_0._unit:get_object(Idstring(unit_data.align))
      local position = a_obj:position()
      local rotation = a_obj:rotation()
      local unit = World:spawn_unit(unit_data.unit, position, rotation)
      unit:mission_door_device():set_parent_data(l_3_0._unit, type)
      if unit_data.can_jam ~= nil then
        unit:timer_gui():set_can_jam(unit_data.can_jam)
      end
      if unit_data.timer then
        unit:timer_gui():set_override_timer(unit_data.timer)
      end
      MissionDoor.run_mission_door_device_sequence(unit, "activate")
      if managers.network:session() then
        managers.network:session():send_to_peers_synched("run_mission_door_device_sequence", unit, "activate")
      end
      table.insert(l_3_0._devices[type].units, {unit = unit, placed = false, completed = false})
    end
  end
end

MissionDoor.run_mission_door_device_sequence = function(l_4_0, l_4_1)
  if l_4_0:damage():has_sequence(l_4_1) then
    l_4_0:damage():run_sequence_simple(l_4_1)
  end
end

MissionDoor.deactivate = function(l_5_0)
  CoreDebug.cat_debug("gaspode", "MissionDoor:deactivate")
  l_5_0._active = nil
  l_5_0:_destroy_devices()
end

MissionDoor.set_mission_door_device_powered = function(l_6_0, l_6_1, l_6_2)
  l_6_0:timer_gui():set_powered(l_6_1, l_6_2)
end

MissionDoor.set_powered = function(l_7_0, l_7_1)
  l_7_0._powered = l_7_1
  local drills = l_7_0._devices.drill
  if drills then
    for _,unit_data in ipairs(drills.units) do
      if unit_data.placed and alive(unit_data.unit) then
        unit_data.unit:timer_gui():set_powered(l_7_1)
        if managers.network:session() then
          managers.network:session():send_to_peers_synched("set_mission_door_device_powered", unit_data.unit, l_7_1, false)
        end
      end
    end
  end
end

MissionDoor.set_on = function(l_8_0, l_8_1)
  local drills = l_8_0._devices.drill
  if drills then
    for _,unit_data in ipairs(drills.units) do
      if unit_data.placed and alive(unit_data.unit) then
        unit_data.unit:timer_gui():set_powered(l_8_1, true)
        if managers.network:session() then
          managers.network:session():send_to_peers_synched("set_mission_door_device_powered", unit_data.unit, l_8_1, true)
        end
      end
    end
  end
end

MissionDoor._get_device_unit_data = function(l_9_0, l_9_1, l_9_2)
  for _,unit_data in ipairs(l_9_0._devices[l_9_2].units) do
    if unit_data.unit == l_9_1 then
      return unit_data
    end
  end
end

MissionDoor.device_placed = function(l_10_0, l_10_1, l_10_2)
  local device_unit_data = l_10_0:_get_device_unit_data(l_10_1, l_10_2)
  if device_unit_data.placed then
    CoreDebug.cat_debug("gaspode", "MissionDoor:device_placed", "Allready placed")
    return 
  end
  l_10_0._devices[l_10_2].placed_counter = l_10_0._devices[l_10_2].placed_counter + 1
  device_unit_data.placed = true
  l_10_0:trigger_sequence(l_10_2 .. "_placed")
  l_10_0:_check_placed_counter(l_10_2)
end

MissionDoor.device_completed = function(l_11_0, l_11_1)
  l_11_0._devices[l_11_1].completed = true
  l_11_0._devices[l_11_1].completed_counter = l_11_0._devices[l_11_1].completed_counter + 1
  l_11_0:trigger_sequence(l_11_1 .. "_completed")
  l_11_0:_check_completed_counter(l_11_1)
end

MissionDoor.device_jammed = function(l_12_0, l_12_1)
  l_12_0:trigger_sequence(l_12_1 .. "_jammed")
end

MissionDoor.device_resumed = function(l_13_0, l_13_1)
  l_13_0:trigger_sequence(l_13_1 .. "_resumed")
end

MissionDoor._check_placed_counter = function(l_14_0, l_14_1)
  if l_14_0._devices[l_14_1].placed_counter ~= l_14_0._devices[l_14_1].amount then
    CoreDebug.cat_debug("gaspode", "MissionDoor:_check_placed_counter", "All", l_14_1, "are not placed yet")
    return 
  end
  CoreDebug.cat_debug("gaspode", "MissionDoor:_check_placed_counter", "All of type", l_14_1, "has been placed")
  l_14_0:trigger_sequence("all_" .. l_14_1 .. "_placed")
  if l_14_1 == "c4" and l_14_0._devices[l_14_1].placed_counter == l_14_0._devices[l_14_1].amount then
    l_14_0:_initiate_c4_sequence(l_14_0)
    return 
  end
  if (l_14_1 == "key" or l_14_1 == "ecm") and l_14_0._devices[l_14_1].placed_counter == l_14_0._devices[l_14_1].amount then
    for _,unit_data in ipairs(l_14_0._devices[l_14_1].units) do
      l_14_0:device_completed(l_14_1)
    end
    return 
  end
end

MissionDoor._check_completed_counter = function(l_15_0, l_15_1)
  if l_15_0._devices[l_15_1].completed_counter == l_15_0._devices[l_15_1].amount then
    l_15_0:_destroy_devices()
    l_15_0:trigger_sequence("door_opened")
    local sequence_name = "open_door"
    if l_15_1 == "drill" then
      do return end
    end
    if l_15_1 == "c4" then
      sequence_name = "explode_door"
      if Network:is_server() then
        if l_15_0._unit:base() then
          l_15_0._unit:base().c4 = true
        end
        local alert_event = {"aggression", l_15_0._unit:position(), tweak_data.weapon.trip_mines.alert_radius, managers.groupai:state():get_unit_type_filter("civilians_enemies"), l_15_0._unit}
        managers.groupai:state():propagate_alert(alert_event)
      elseif l_15_1 == "key" then
        sequence_name = "open_door_keycard"
      elseif l_15_1 == "ecm" then
        sequence_name = "open_door_ecm"
      end
    end
    if managers.network:session() then
      managers.network:session():send_to_peers_synched("run_mission_door_sequence", l_15_0._unit, sequence_name)
    end
    l_15_0:run_sequence_simple(sequence_name)
  end
end

MissionDoor._initiate_c4_sequence = function(l_16_0)
  for type,device in pairs(l_16_0._devices) do
    if type ~= "c4" then
      for _,unit_data in ipairs(device.units) do
        if alive(unit_data.unit) then
          unit_data.unit:set_slot(0)
        end
      end
    end
  end
  for _,unit_data in ipairs(l_16_0._devices.c4.units) do
    MissionDoor.run_mission_door_device_sequence(unit_data.unit, "activate_explode_sequence")
    if managers.network:session() then
      managers.network:session():send_to_peers_synched("run_mission_door_device_sequence", unit_data.unit, "activate_explode_sequence")
    end
  end
  l_16_0._explode_t = Application:time() + 5
  l_16_0._unit:set_extension_update_enabled(Idstring("base"), true)
end

MissionDoor._c4_sequence_done = function(l_17_0)
  l_17_0._explode_t = nil
  l_17_0._unit:set_extension_update_enabled(Idstring("base"), false)
  if not l_17_0._devices.c4 then
    return 
  end
  for _,unit_data in ipairs(l_17_0._devices.c4.units) do
    l_17_0:device_completed("c4")
  end
end

MissionDoor.run_sequence_simple = function(l_18_0, l_18_1)
  l_18_0:_run_sequence_simple(l_18_1)
end

MissionDoor.trigger_sequence = function(l_19_0, l_19_1)
  CoreDebug.cat_debug("gaspode", "MissionDoor:trigger_sequence", l_19_1)
  l_19_0:_run_sequence_simple(l_19_1)
end

MissionDoor._run_sequence_simple = function(l_20_0, l_20_1)
  l_20_0._unit:damage():run_sequence_simple(l_20_1)
end

MissionDoor._destroy_devices = function(l_21_0)
  for _,device in pairs(l_21_0._devices) do
    for _,unit_data in ipairs(device.units) do
      if alive(unit_data.unit) then
        unit_data.unit:set_slot(0)
      end
    end
  end
  l_21_0._devices = {}
end

MissionDoor.destroy = function(l_22_0)
  for _,device in pairs(l_22_0._devices) do
    for _,unit_data in ipairs(device.units) do
      if alive(unit_data.unit) then
        unit_data.unit:set_slot(0)
      end
    end
  end
end

if not MissionDoorDevice then
  MissionDoorDevice = class()
end
MissionDoorDevice.init = function(l_23_0, l_23_1)
  l_23_0._unit = l_23_1
end

MissionDoorDevice.set_parent_data = function(l_24_0, l_24_1, l_24_2)
  l_24_0._parent_door = l_24_1
  l_24_0._device_type = l_24_2
end

MissionDoorDevice.placed = function(l_25_0)
  if not alive(l_25_0._parent_door) then
    CoreDebug.cat_debug("gaspode", "MissionDoor:placed", "Had no parent door unit")
    return 
  end
  l_25_0._placed = true
  l_25_0._parent_door:base():device_placed(l_25_0._unit, l_25_0._device_type)
end

MissionDoorDevice.can_place = function(l_26_0)
  return not l_26_0._placed
end

MissionDoorDevice.report_jammed_state = function(l_27_0, l_27_1)
  if not alive(l_27_0._parent_door) then
    CoreDebug.cat_debug("gaspode", "MissionDoor:report_jammed_state", "Had no parent door unit")
    return 
  end
  if l_27_1 then
    l_27_0._parent_door:base():device_jammed(l_27_0._device_type)
  else
    l_27_0._parent_door:base():device_resumed(l_27_0._device_type)
  end
end

MissionDoorDevice.report_resumed = function(l_28_0)
  if not alive(l_28_0._parent_door) then
    CoreDebug.cat_debug("gaspode", "MissionDoor:report_jammed_state", "Had no parent door unit")
    return 
  end
  l_28_0._parent_door:base():device_resumed(l_28_0._device_type)
end

MissionDoorDevice.report_completed = function(l_29_0)
  if not alive(l_29_0._parent_door) then
    CoreDebug.cat_debug("gaspode", "MissionDoor:report_completed", "Had no parent door unit")
    return 
  end
  l_29_0._parent_door:base():device_completed(l_29_0._device_type)
end

MissionDoorDevice.report_trigger_sequence = function(l_30_0, l_30_1)
  CoreDebug.cat_debug("gaspode", "MissionDoor:report_trigger_sequence", l_30_1)
  if not alive(l_30_0._parent_door) then
    CoreDebug.cat_debug("gaspode", "MissionDoor:report_trigger_sequence", "Had no parent door unit")
    return 
  end
  l_30_0._parent_door:base():trigger_sequence(l_30_1)
end

MissionDoorDevice.destroy = function(l_31_0)
end


