-- Decompiled using luadec 2.0.1 by sztupy (http://winmo.sztupy.hu)
-- Command line was: F:\SteamLibrary\SteamApps\common\PAYDAY 2\lua\core\lib\managers\mission\coreelementplayeffect.luac 

core:module("CoreElementPlayEffect")
core:import("CoreEngineAccess")
core:import("CoreMissionScriptElement")
if not ElementPlayEffect then
  ElementPlayEffect = class(CoreMissionScriptElement.MissionScriptElement)
end
ElementPlayEffect.IDS_EFFECT = Idstring("effect")
ElementPlayEffect.init = function(l_1_0, ...)
  ElementPlayEffect.super.init(l_1_0, ...)
  if Application:editor() then
    if l_1_0._values.effect ~= "none" then
      CoreEngineAccess._editor_load(l_1_0.IDS_EFFECT, l_1_0._values.effect:id())
    else
      managers.editor:output_error("Cant load effect named \"none\" [" .. l_1_0._editor_name .. "]")
       -- DECOMPILER ERROR: Confused about usage of registers for local variables.

    end
  end
end

ElementPlayEffect.client_on_executed = function(l_2_0, ...)
  l_2_0:on_executed(...)
   -- DECOMPILER ERROR: Confused about usage of registers for local variables.

end

ElementPlayEffect.on_executed = function(l_3_0, l_3_1)
  if not l_3_0._values.enabled then
    return 
  end
  l_3_0:play_effect()
  ElementPlayEffect.super.on_executed(l_3_0, l_3_1)
end

ElementPlayEffect.play_effect = function(l_4_0)
  if l_4_0._values.effect ~= "none" then
    local params = {}
    params.effect = Idstring(l_4_0._values.effect)
    if not l_4_0._values.screen_space or not Vector3() then
      params.position = l_4_0._values.position
    end
    if not l_4_0._values.screen_space or not Rotation() then
      params.rotation = l_4_0._values.rotation
    end
    params.base_time = l_4_0._values.base_time or 0
    params.random_time = l_4_0._values.random_time or 0
    params.max_amount = l_4_0._values.max_amount ~= 0 and l_4_0._values.max_amount or nil
    managers.environment_effects:spawn_mission_effect(l_4_0._id, params)
  else
    if Application:editor() then
      managers.editor:output_error("Cant spawn effect named \"none\" [" .. l_4_0._editor_name .. "]")
    end
  end
end

ElementPlayEffect.kill = function(l_5_0)
  managers.environment_effects:kill_mission_effect(l_5_0._id)
end

ElementPlayEffect.fade_kill = function(l_6_0)
  managers.environment_effects:fade_kill_mission_effect(l_6_0._id)
end

if not ElementStopEffect then
  ElementStopEffect = class(CoreMissionScriptElement.MissionScriptElement)
end
ElementStopEffect.init = function(l_7_0, ...)
  ElementStopEffect.super.init(l_7_0, ...)
   -- DECOMPILER ERROR: Confused about usage of registers for local variables.

end

ElementStopEffect.client_on_executed = function(l_8_0, ...)
  l_8_0:on_executed(...)
   -- DECOMPILER ERROR: Confused about usage of registers for local variables.

end

ElementStopEffect.on_executed = function(l_9_0, l_9_1)
  if not l_9_0._values.enabled then
    return 
  end
  for _,id in ipairs(l_9_0._values.elements) do
    local element = l_9_0:get_mission_element(id)
    if element then
      if l_9_0._values.operation == "kill" then
        element:kill()
        for (for control),_ in (for generator) do
        end
        if l_9_0._values.operation == "fade_kill" then
          element:fade_kill()
        end
      end
    end
    ElementStopEffect.super.on_executed(l_9_0, l_9_1)
     -- Warning: missing end command somewhere! Added here
  end
end


