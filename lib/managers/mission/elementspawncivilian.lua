-- Decompiled using luadec 2.0.1 by sztupy (http://winmo.sztupy.hu)
-- Command line was: F:\SteamLibrary\SteamApps\common\PAYDAY 2\lua\lib\managers\mission\elementspawncivilian.luac 

core:import("CoreMissionScriptElement")
if not ElementSpawnCivilian then
  ElementSpawnCivilian = class(CoreMissionScriptElement.MissionScriptElement)
end
ElementSpawnCivilian.init = function(l_1_0, ...)
  ElementSpawnCivilian.super.init(l_1_0, ...)
  if not l_1_0._values.enemy or not Idstring(l_1_0._values.enemy) then
    l_1_0._enemy_name = Idstring("units/characters/civilians/dummy_civilian_1/dummy_civilian_1")
  end
  l_1_0._units = {}
  l_1_0._events = {}
   -- DECOMPILER ERROR: Confused about usage of registers for local variables.

end

ElementSpawnCivilian.enemy_name = function(l_2_0)
  return l_2_0._enemy_name
end

ElementSpawnCivilian.units = function(l_3_0)
  return l_3_0._units
end

ElementSpawnCivilian.produce = function(l_4_0)
  if not managers.groupai:state():is_AI_enabled() then
    return 
  end
  local unit = safe_spawn_unit(l_4_0._enemy_name, l_4_0._values.position, l_4_0._values.rotation)
  unit:unit_data().mission_element = l_4_0
  table.insert(l_4_0._units, unit)
  if l_4_0._values.state ~= "none" then
    if unit:brain() then
      local action_data = {type = "act", variant = l_4_0._values.state, body_part = 1, align_sync = true}
      local spawn_ai = {init_state = "idle", objective = {type = "act", action = action_data, interrupt_dis = -1, interrupt_health = 1}}
      unit:brain():set_spawn_ai(spawn_ai)
    else
      unit:base():play_state(l_4_0._values.state)
    end
  end
  if l_4_0._values.force_pickup and l_4_0._values.force_pickup ~= "none" then
    unit:character_damage():set_pickup(l_4_0._values.force_pickup)
  end
  if unit:unit_data().secret_assignment_id then
    managers.secret_assignment:register_unit(unit)
  else
    managers.secret_assignment:register_civilian(unit)
  end
  l_4_0:event("spawn", unit)
  return unit
end

ElementSpawnCivilian.event = function(l_5_0, l_5_1, l_5_2)
  if l_5_0._events[l_5_1] then
    for _,callback in ipairs(l_5_0._events[l_5_1]) do
      callback(l_5_2)
    end
  end
end

ElementSpawnCivilian.add_event_callback = function(l_6_0, l_6_1, l_6_2)
  if not l_6_0._events[l_6_1] then
    l_6_0._events[l_6_1] = {}
  end
  table.insert(l_6_0._events[l_6_1], l_6_2)
end

ElementSpawnCivilian.on_executed = function(l_7_0, l_7_1)
  if not l_7_0._values.enabled then
    return 
  end
  if not managers.groupai:state():is_AI_enabled() and not Application:editor() then
    return 
  end
  local unit = l_7_0:produce()
  ElementSpawnCivilian.super.on_executed(l_7_0, unit)
end

ElementSpawnCivilian.unspawn_all_units = function(l_8_0)
  ElementSpawnEnemyDummy.unspawn_all_units(l_8_0)
end

ElementSpawnCivilian.kill_all_units = function(l_9_0)
  ElementSpawnEnemyDummy.kill_all_units(l_9_0)
end

ElementSpawnCivilian.execute_on_all_units = function(l_10_0, l_10_1)
  ElementSpawnEnemyDummy.execute_on_all_units(l_10_0, l_10_1)
end


