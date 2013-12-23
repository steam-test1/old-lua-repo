-- Decompiled using luadec 2.0.1 by sztupy (http://winmo.sztupy.hu)
-- Command line was: F:\SteamLibrary\SteamApps\common\PAYDAY 2\lua\lib\managers\mission\elementjobvalue.luac 

core:import("CoreMissionScriptElement")
if not ElementJobValue then
  ElementJobValue = class(CoreMissionScriptElement.MissionScriptElement)
end
ElementJobValue.init = function(l_1_0, ...)
  ElementJobValue.super.init(l_1_0, ...)
   -- DECOMPILER ERROR: Confused about usage of registers for local variables.

end

ElementJobValue.client_on_executed = function(l_2_0, ...)
  if l_2_0._values.save then
    l_2_0:on_executed(...)
     -- DECOMPILER ERROR: Confused about usage of registers for local variables.

  end
end

ElementJobValue.on_executed = function(l_3_0, l_3_1)
  if not l_3_0._values.enabled then
    return 
  end
  if l_3_0._values.key ~= "none" then
    if l_3_0._values.save then
      managers.mission:set_saved_job_value(l_3_0._values.key, l_3_0._values.value)
    else
      managers.mission:set_job_value(l_3_0._values.key, l_3_0._values.value)
    end
  else
    if Application:editor() then
      managers.editor:output_error("Cant set job value with key none.")
    end
  end
  ElementJobValue.super.on_executed(l_3_0, l_3_1)
end

if not ElementJobValueFilter then
  ElementJobValueFilter = class(CoreMissionScriptElement.MissionScriptElement)
end
ElementJobValueFilter.init = function(l_4_0, ...)
  ElementJobValueFilter.super.init(l_4_0, ...)
   -- DECOMPILER ERROR: Confused about usage of registers for local variables.

end

ElementJobValueFilter.client_on_executed = function(l_5_0, ...)
   -- DECOMPILER ERROR: Confused about usage of registers for local variables.

end

ElementJobValueFilter.on_executed = function(l_6_0, l_6_1)
  if not l_6_0._values.enabled then
    return 
  end
  local value = nil
  if l_6_0._values.save then
    value = managers.mission:get_saved_job_value(l_6_0._values.key)
  else
    value = managers.mission:get_job_value(l_6_0._values.key)
  end
  if not l_6_0:_check_value(value) then
    return 
  end
  ElementJobValueFilter.super.on_executed(l_6_0, l_6_1)
end

ElementJobValueFilter._check_value = function(l_7_0, l_7_1)
  if l_7_0._values.check_type == "not_has_key" then
    return not l_7_1
  end
  if not l_7_1 then
    return false
  end
  if l_7_0._values.check_type == "has_key" then
    return true
  end
  if l_7_1 ~= l_7_0._values.value then
    return l_7_0._values.check_type and l_7_0._values.check_type ~= "equal"
  end
  if l_7_1 > l_7_0._values.value then
    return l_7_0._values.check_type ~= "less_or_equal"
  end
  if l_7_0._values.value > l_7_1 then
    return l_7_0._values.check_type ~= "greater_or_equal"
  end
  if l_7_1 >= l_7_0._values.value then
    return l_7_0._values.check_type ~= "less_than"
  end
  if l_7_0._values.value >= l_7_1 then
    return l_7_0._values.check_type ~= "greater_than"
  end
end

if not ElementApplyJobValue then
  ElementApplyJobValue = class(CoreMissionScriptElement.MissionScriptElement)
end
ElementApplyJobValue.init = function(l_8_0, ...)
  ElementApplyJobValue.super.init(l_8_0, ...)
   -- DECOMPILER ERROR: Confused about usage of registers for local variables.

end

ElementApplyJobValue.client_on_executed = function(l_9_0, ...)
   -- DECOMPILER ERROR: Confused about usage of registers for local variables.

end

ElementApplyJobValue.on_executed = function(l_10_0, l_10_1)
  if not l_10_0._values.enabled then
    return 
  end
  local value = nil
  if l_10_0._values.save then
    value = managers.mission:get_saved_job_value(l_10_0._values.key)
  else
    value = managers.mission:get_job_value(l_10_0._values.key)
  end
  for _,id in ipairs(l_10_0._values.elements) do
    local element = l_10_0:get_mission_element(id)
    if element then
      element:apply_job_value(value)
    end
  end
  ElementApplyJobValue.super.on_executed(l_10_0, l_10_1)
end


