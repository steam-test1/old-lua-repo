-- Decompiled using luadec 2.0.1 by sztupy (http://winmo.sztupy.hu)
-- Command line was: F:\SteamLibrary\SteamApps\common\PAYDAY 2\lua\lib\managers\mission\elementobjective.luac 

core:import("CoreMissionScriptElement")
if not ElementObjective then
  ElementObjective = class(CoreMissionScriptElement.MissionScriptElement)
end
ElementObjective.init = function(l_1_0, ...)
  ElementObjective.super.init(l_1_0, ...)
   -- DECOMPILER ERROR: Confused about usage of registers for local variables.

end

ElementObjective.on_script_activated = function(l_2_0)
  l_2_0._mission_script:add_save_state_cb(l_2_0._id)
end

ElementObjective.client_on_executed = function(l_3_0, ...)
  l_3_0:on_executed(...)
   -- DECOMPILER ERROR: Confused about usage of registers for local variables.

end

ElementObjective.on_executed = function(l_4_0, l_4_1)
  if not l_4_0._values.enabled then
    return 
  end
  if l_4_0._values.state == "activate" then
    if not l_4_0._values.amount or l_4_0._values.amount <= 0 or not l_4_0._values.amount then
      local amount = l_4_0._values.objective == "none" or nil
    end
    managers.objectives:activate_objective(l_4_0._values.objective, nil, {amount = amount})
  else
    if l_4_0._values.state == "complete" then
      if l_4_0._values.sub_objective and l_4_0._values.sub_objective ~= "none" then
        managers.objectives:complete_sub_objective(l_4_0._values.objective, l_4_0._values.sub_objective)
      else
        managers.objectives:complete_objective(l_4_0._values.objective)
      end
    else
      if l_4_0._values.state == "update" then
        managers.objectives:update_objective(l_4_0._values.objective)
      else
        if l_4_0._values.state == "remove" then
          managers.objectives:remove_objective(l_4_0._values.objective)
          do return end
          if Application:editor() then
            managers.editor:output_error("Cant operate on objective " .. l_4_0._values.objective .. " in element " .. l_4_0._editor_name .. ".")
          end
        end
      end
    end
  end
  ElementObjective.super.on_executed(l_4_0, l_4_1)
end

ElementObjective.apply_job_value = function(l_5_0, l_5_1)
  local type = CoreClass.type_name(l_5_1)
  if type ~= "number" then
    Application:error("[ElementObjective:apply_job_value] " .. l_5_0._id .. "(" .. l_5_0._editor_name .. ") Can't apply job value of type " .. type)
    return 
  end
  l_5_0._values.amount = l_5_1
end

ElementObjective.save = function(l_6_0, l_6_1)
  l_6_1.enabled = l_6_0._values.enabled
end

ElementObjective.load = function(l_7_0, l_7_1)
  l_7_0:set_enabled(l_7_1.enabled)
end


