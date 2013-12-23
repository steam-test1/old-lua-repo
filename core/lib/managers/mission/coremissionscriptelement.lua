-- Decompiled using luadec 2.0.1 by sztupy (http://winmo.sztupy.hu)
-- Command line was: F:\SteamLibrary\SteamApps\common\PAYDAY 2\lua\core\lib\managers\mission\coremissionscriptelement.luac 

core:module("CoreMissionScriptElement")
core:import("CoreXml")
core:import("CoreCode")
core:import("CoreClass")
if not MissionScriptElement then
  MissionScriptElement = class()
end
MissionScriptElement.init = function(l_1_0, l_1_1, l_1_2)
  l_1_0._mission_script = l_1_1
  l_1_0._id = l_1_2.id
  l_1_0._editor_name = l_1_2.editor_name
  l_1_0._values = l_1_2.values
end

MissionScriptElement.on_created = function(l_2_0)
end

MissionScriptElement.on_script_activated = function(l_3_0)
end

MissionScriptElement.get_mission_element = function(l_4_0, l_4_1)
  return l_4_0._mission_script:element(l_4_1)
end

MissionScriptElement.editor_name = function(l_5_0)
  return l_5_0._editor_name
end

MissionScriptElement.values = function(l_6_0)
  return l_6_0._values
end

MissionScriptElement.value = function(l_7_0, l_7_1)
  return l_7_0._values[l_7_1]
end

MissionScriptElement.enabled = function(l_8_0)
  return l_8_0._values.enabled
end

MissionScriptElement._check_instigator = function(l_9_0, l_9_1)
  if CoreClass.type_name(l_9_1) == "Unit" then
    return l_9_1
  end
  return managers.player:player_unit()
end

MissionScriptElement.on_executed = function(l_10_0, l_10_1)
  if not l_10_0._values.enabled then
    return 
  end
  l_10_1 = l_10_0:_check_instigator(l_10_1)
  if Network:is_server() then
    if l_10_1 and alive(l_10_1) and l_10_1:id() ~= -1 then
      managers.network:session():send_to_peers_synched("run_mission_element", l_10_0._id, l_10_1)
    else
      managers.network:session():send_to_peers_synched("run_mission_element_no_instigator", l_10_0._id)
    end
  end
  l_10_0:_print_debug_on_executed(l_10_1)
  l_10_0:_reduce_trigger_times()
  if l_10_0._values.base_delay > 0 then
    l_10_0._mission_script:add(callback(l_10_0, l_10_0, "execute_on_executed", l_10_1), l_10_0._values.base_delay, 1)
  else
    l_10_0:execute_on_executed(l_10_1)
  end
end

MissionScriptElement._print_debug_on_executed = function(l_11_0, l_11_1)
  if l_11_0:is_debug() then
    l_11_0:_print_debug("Element '" .. l_11_0._editor_name .. "' executed.", l_11_1)
  if l_11_1 then
    end
  end
end

MissionScriptElement._print_debug = function(l_12_0, l_12_1, l_12_2)
  if l_12_0:is_debug() then
    l_12_0._mission_script:debug_output(l_12_1)
  end
end

MissionScriptElement._reduce_trigger_times = function(l_13_0)
  if l_13_0._values.trigger_times > 0 then
    l_13_0._values.trigger_times = l_13_0._values.trigger_times - 1
    if l_13_0._values.trigger_times <= 0 then
      l_13_0._values.enabled = false
    end
  end
end

MissionScriptElement.execute_on_executed = function(l_14_0, l_14_1)
  for _,params in ipairs(l_14_0._values.on_executed) do
    local element = l_14_0:get_mission_element(params.id)
    if element then
      if params.delay > 0 then
        if l_14_0:is_debug() or element:is_debug() then
          l_14_0._mission_script:debug_output("  Executing element '" .. element:editor_name() .. "' in " .. params.delay .. " seconds ...", Color(1, 0.75, 0.75, 0.75))
        end
        l_14_0._mission_script:add(callback(element, element, "on_executed", l_14_1), params.delay, 1)
        for (for control),_ in (for generator) do
        end
        if l_14_0:is_debug() or element:is_debug() then
          l_14_0._mission_script:debug_output("  Executing element '" .. element:editor_name() .. "' ...", Color(1, 0.75, 0.75, 0.75))
        end
        element:on_executed(l_14_1)
      end
    end
     -- Warning: missing end command somewhere! Added here
  end
end

MissionScriptElement.on_execute_element = function(l_15_0, l_15_1, l_15_2)
  l_15_1:on_executed(l_15_2)
end

MissionScriptElement.set_enabled = function(l_16_0, l_16_1)
  l_16_0._values.enabled = l_16_1
end

MissionScriptElement.on_toggle = function(l_17_0, l_17_1)
end

MissionScriptElement.set_trigger_times = function(l_18_0, l_18_1)
  l_18_0._values.trigger_times = l_18_1
end

MissionScriptElement.is_debug = function(l_19_0)
  if not l_19_0._values.debug then
    return l_19_0._mission_script:is_debug()
  end
end

MissionScriptElement.stop_simulation = function(l_20_0, ...)
   -- DECOMPILER ERROR: Confused about usage of registers for local variables.

end

MissionScriptElement.operation_add = function(l_21_0)
  if Application:editor() then
    managers.editor:output_error("Element " .. l_21_0:editor_name() .. " doesn't have an 'add' operator implemented.")
  end
end

MissionScriptElement.operation_remove = function(l_22_0)
  if Application:editor() then
    managers.editor:output_error("Element " .. l_22_0:editor_name() .. " doesn't have a 'remove' operator implemented.")
  end
end

MissionScriptElement.apply_job_value = function(l_23_0)
  if Application:editor() then
    managers.editor:output_error("Element " .. l_23_0:editor_name() .. " doesn't have a 'apply_job_value' function implemented.")
  end
end

MissionScriptElement.pre_destroy = function(l_24_0)
end

MissionScriptElement.destroy = function(l_25_0)
end


