-- Decompiled using luadec 2.0.1 by sztupy (http://winmo.sztupy.hu)
-- Command line was: F:\SteamLibrary\SteamApps\common\PAYDAY 2\lua\lib\managers\mission\elementenableunit.luac 

core:import("CoreMissionScriptElement")
if not ElementEnableUnit then
  ElementEnableUnit = class(CoreMissionScriptElement.MissionScriptElement)
end
ElementEnableUnit.init = function(l_1_0, ...)
  ElementEnableUnit.super.init(l_1_0, ...)
  l_1_0._units = {}
   -- DECOMPILER ERROR: Confused about usage of registers for local variables.

end

ElementEnableUnit.on_script_activated = function(l_2_0)
  print(inspect(l_2_0._values.unit_ids))
  for _,id in ipairs(l_2_0._values.unit_ids) do
    if Global.running_simulation then
      table.insert(l_2_0._units, managers.editor:unit_with_id(id))
      for (for control),_ in (for generator) do
      end
      local unit = managers.worlddefinition:get_unit_on_load(id, callback(l_2_0, l_2_0, "_load_unit"))
      if unit then
        table.insert(l_2_0._units, unit)
      end
    end
    l_2_0._has_fetched_units = true
    l_2_0._mission_script:add_save_state_cb(l_2_0._id)
     -- Warning: missing end command somewhere! Added here
  end
end

ElementEnableUnit._load_unit = function(l_3_0, l_3_1)
  Application:stack_dump()
  table.insert(l_3_0._units, l_3_1)
end

ElementEnableUnit.client_on_executed = function(l_4_0, ...)
  l_4_0:on_executed(...)
   -- DECOMPILER ERROR: Confused about usage of registers for local variables.

end

ElementEnableUnit.on_executed = function(l_5_0, l_5_1)
  if not l_5_0._values.enabled then
    return 
  end
  for _,unit in ipairs(l_5_0._units) do
    managers.game_play_central:mission_enable_unit(unit)
  end
  ElementEnableUnit.super.on_executed(l_5_0, l_5_1)
end

ElementEnableUnit.save = function(l_6_0, l_6_1)
  l_6_1.save_me = true
  l_6_1.enabled = l_6_0._values.enabled
end

ElementEnableUnit.load = function(l_7_0, l_7_1)
  if not l_7_0._has_fetched_units then
    l_7_0:on_script_activated()
  end
  l_7_0:set_enabled(l_7_1.enabled)
end


