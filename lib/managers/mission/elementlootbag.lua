-- Decompiled using luadec 2.0.1 by sztupy (http://winmo.sztupy.hu)
-- Command line was: F:\SteamLibrary\SteamApps\common\PAYDAY 2\lua\lib\managers\mission\elementlootbag.luac 

core:import("CoreMissionScriptElement")
if not ElementLootBag then
  ElementLootBag = class(CoreMissionScriptElement.MissionScriptElement)
end
ElementLootBag.init = function(l_1_0, ...)
  ElementLootBag.super.init(l_1_0, ...)
  l_1_0._triggers = {}
   -- DECOMPILER ERROR: Confused about usage of registers for local variables.

end

ElementLootBag.client_on_executed = function(l_2_0, ...)
   -- DECOMPILER ERROR: Confused about usage of registers for local variables.

end

ElementLootBag.on_executed = function(l_3_0, l_3_1)
  if not l_3_0._values.enabled then
    return 
  end
  local unit = nil
  if l_3_0._values.carry_id ~= "none" then
    local dir = l_3_0._values.spawn_dir * l_3_0._values.push_multiplier
    local value = managers.money:get_bag_value(l_3_0._values.carry_id)
    unit = managers.player:server_drop_carry(l_3_0._values.carry_id, value, true, false, 1, l_3_0._values.position, l_3_0._values.rotation, dir, 0)
  else
    if l_3_0._values.from_respawn then
      local loot = managers.loot:get_respawn()
      if loot then
        local dir = l_3_0._values.spawn_dir * l_3_0._values.push_multiplier
        unit = managers.player:server_drop_carry(loot.carry_id, loot.value, true, false, 1, l_3_0._values.position, l_3_0._values.rotation, dir, 0)
      else
        print("NO MORE LOOT TO RESPAWN")
      end
    else
      local loot = managers.loot:get_distribute()
      if loot then
        local dir = l_3_0._values.spawn_dir * l_3_0._values.push_multiplier
        unit = managers.player:server_drop_carry(loot.carry_id, loot.value, true, false, 1, l_3_0._values.position, l_3_0._values.rotation, dir, 0)
      else
        print("NO MORE LOOT TO DISTRIBUTE")
      end
    end
  end
  if alive(unit) then
    l_3_0:_check_triggers("spawn", unit)
    unit:carry_data():set_mission_element(l_3_0)
  end
  ElementLootBag.super.on_executed(l_3_0, l_3_1)
end

ElementLootBag.add_trigger = function(l_4_0, l_4_1, l_4_2, l_4_3)
  if not l_4_0._triggers[l_4_2] then
    l_4_0._triggers[l_4_2] = {}
  end
  l_4_0._triggers[l_4_2][l_4_1] = {callback = l_4_3}
end

ElementLootBag._check_triggers = function(l_5_0, l_5_1, l_5_2)
  if not l_5_0._triggers[l_5_1] then
    return 
  end
  for id,cb_data in pairs(l_5_0._triggers[l_5_1]) do
    cb_data.callback(l_5_2)
  end
end

ElementLootBag.trigger = function(l_6_0, l_6_1, l_6_2)
  l_6_0:_check_triggers(l_6_1, l_6_2)
end

if not ElementLootBagTrigger then
  ElementLootBagTrigger = class(CoreMissionScriptElement.MissionScriptElement)
end
ElementLootBagTrigger.init = function(l_7_0, ...)
  ElementLootBagTrigger.super.init(l_7_0, ...)
   -- DECOMPILER ERROR: Confused about usage of registers for local variables.

end

ElementLootBagTrigger.on_script_activated = function(l_8_0)
  for _,id in ipairs(l_8_0._values.elements) do
    local element = l_8_0:get_mission_element(id)
    element:add_trigger(l_8_0._id, l_8_0._values.trigger_type, callback(l_8_0, l_8_0, "on_executed"))
  end
end

ElementLootBagTrigger.client_on_executed = function(l_9_0, ...)
   -- DECOMPILER ERROR: Confused about usage of registers for local variables.

end

ElementLootBagTrigger.on_executed = function(l_10_0, l_10_1)
  if not l_10_0._values.enabled then
    return 
  end
  ElementLootBagTrigger.super.on_executed(l_10_0, l_10_1)
end


