-- Decompiled using luadec 2.0.1 by sztupy (http://winmo.sztupy.hu)
-- Command line was: F:\SteamLibrary\SteamApps\common\PAYDAY 2\lua\lib\managers\mission\elementnavobstacle.luac 

core:import("CoreMissionScriptElement")
if not ElementNavObstacle then
  ElementNavObstacle = class(CoreMissionScriptElement.MissionScriptElement)
end
ElementNavObstacle.init = function(l_1_0, ...)
  ElementDisableUnit.super.init(l_1_0, ...)
  l_1_0._obstacle_units = {}
   -- DECOMPILER ERROR: Confused about usage of registers for local variables.

end

ElementNavObstacle.on_script_activated = function(l_2_0)
  if not l_2_0._values.obstacle_list then
    l_2_0._values.obstacle_list = {{unit_id = l_2_0._values.obstacle_unit_id, obj_name = l_2_0._values.obstacle_obj_name}}
  end
  for _,data in ipairs(l_2_0._values.obstacle_list) do
    if Global.running_simulation then
      table.insert(l_2_0._obstacle_units, {unit = managers.editor:unit_with_id(data.unit_id), obj_name = data.obj_name})
      for (for control),_ in (for generator) do
      end
      local unit = managers.worlddefinition:get_unit_on_load(data.unit_id, callback(l_2_0, l_2_0, "_load_unit", data.obj_name))
      if unit then
        print("ElementNavObstacle:on_script_activated()", unit, data.obj_name)
        table.insert(l_2_0._obstacle_units, {unit = unit, obj_name = data.obj_name})
      end
    end
    l_2_0._has_fetched_units = true
    l_2_0._mission_script:add_save_state_cb(l_2_0._id)
     -- Warning: missing end command somewhere! Added here
  end
end

ElementNavObstacle._load_unit = function(l_3_0, l_3_1, l_3_2)
  table.insert(l_3_0._obstacle_units, {unit = l_3_2, obj_name = l_3_1})
end

ElementNavObstacle.client_on_executed = function(l_4_0, ...)
  l_4_0:on_executed(...)
   -- DECOMPILER ERROR: Confused about usage of registers for local variables.

end

ElementNavObstacle.on_executed = function(l_5_0, l_5_1)
  if not l_5_0._values.enabled then
    return 
  end
  for _,data in ipairs(l_5_0._obstacle_units) do
    if not alive(data.unit) then
      debug_pause("[ElementNavObstacle:on_executed] dead obstacle unit. element_id:", l_5_0._id)
      for (for control),_ in (for generator) do
      end
      if not data.unit:get_object(data.obj_name) then
        debug_pause("[ElementNavObstacle:on_executed] object missing from unit. element_id:", l_5_0._id, "unit", data.unit, "Objec3D", data.obj_name)
        for (for control),_ in (for generator) do
        end
        if l_5_0._values.operation == "add" then
          managers.navigation:add_obstacle(data.unit, data.obj_name)
          for (for control),_ in (for generator) do
          end
          managers.navigation:remove_obstacle(data.unit, data.obj_name)
        end
        ElementNavObstacle.super.on_executed(l_5_0, l_5_1)
         -- Warning: missing end command somewhere! Added here
      end
       -- Warning: missing end command somewhere! Added here
    end
     -- Warning: missing end command somewhere! Added here
  end
end

ElementNavObstacle.save = function(l_6_0, l_6_1)
  l_6_1.save_me = true
end

ElementNavObstacle.load = function(l_7_0, l_7_1)
  if not l_7_0._has_fetched_units then
    l_7_0:on_script_activated()
  end
end


