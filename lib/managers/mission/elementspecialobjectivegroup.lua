-- Decompiled using luadec 2.0.1 by sztupy (http://winmo.sztupy.hu)
-- Command line was: F:\SteamLibrary\SteamApps\common\PAYDAY 2\lua\lib\managers\mission\elementspecialobjectivegroup.luac 

core:import("CoreMissionScriptElement")
if not ElementSpecialObjectiveGroup then
  ElementSpecialObjectiveGroup = class(CoreMissionScriptElement.MissionScriptElement)
end
ElementSpecialObjectiveGroup.init = function(l_1_0, ...)
  ElementSpecialObjectiveGroup.super.init(l_1_0, ...)
  do
    if not l_1_0._values.access_flag_version then
      local access_filter_version = not l_1_0._values.SO_access or 1
    end
    if access_filter_version ~= managers.navigation.ACCESS_FLAGS_VERSION then
      print("[ElementSpecialObjectiveGroup:init] converting access flag", access_filter_version, l_1_0._values.SO_access)
      l_1_0._values.SO_access = managers.navigation:upgrade_access_filter(tonumber(l_1_0._values.SO_access), access_filter_version)
      print("[ElementSpecialObjectiveGroup:init] converted to", l_1_0._values.SO_access)
    else
      l_1_0._values.SO_access = tonumber(l_1_0._values.SO_access)
    end
     -- DECOMPILER ERROR: Confused about usage of registers for local variables.

  end
end

ElementSpecialObjectiveGroup.clbk_verify_administration = function(l_2_0, l_2_1)
  return ElementSpecialObjective.clbk_verify_administration(l_2_0, l_2_1)
end

ElementSpecialObjectiveGroup.on_executed = function(l_3_0, l_3_1)
  if not l_3_0._values.enabled or Network:is_client() then
    return 
  end
  if not managers.groupai:state():is_AI_enabled() and not Application:editor() then
    do return end
  end
  if l_3_0._values.spawn_instigator_ids and next(l_3_0._values.spawn_instigator_ids) then
    local chosen_units = l_3_0:_select_units_from_spawners()
    if chosen_units then
      for _,chosen_unit in ipairs(chosen_units) do
        l_3_0:_execute_random_SO(chosen_unit)
      end
    else
      if l_3_0._values.use_instigator and alive(l_3_1) and l_3_1:brain() and (not l_3_1:character_damage() or not l_3_1:character_damage():dead()) then
        l_3_0:_execute_random_SO(l_3_1)
        do return end
        Application:error("[ElementSpecialObjectiveGroup:on_executed] Special Objective instigator is not an AI unit. Possibly improper \"use instigator\" flag use. Element id:", l_3_0._id)
        do return end
        if not l_3_1 then
          Application:error("[ElementSpecialObjectiveGroup:on_executed] Special Objective missing instigator. Possibly improper \"use instigator\" flag use. Element id:", l_3_0._id)
          do return end
          l_3_0:_execute_random_SO(nil)
        end
      end
    end
  end
  ElementSpecialObjectiveGroup.super.on_executed(l_3_0, l_3_1)
end

ElementSpecialObjectiveGroup.operation_remove = function(l_4_0)
  for _,followup_element_id in ipairs(l_4_0._values.followup_elements) do
    managers.groupai:state():remove_special_objective(followup_element_id)
  end
end

ElementSpecialObjectiveGroup._select_units_from_spawners = function(l_5_0)
  return ElementSpecialObjective._select_units_from_spawners(l_5_0)
end

ElementSpecialObjectiveGroup.choose_followup_SO = function(l_6_0, l_6_1, l_6_2)
  if l_6_2 and l_6_2[l_6_0._id] then
    return 
  end
  l_6_2[l_6_0._id] = true
  return ElementSpecialObjective.choose_followup_SO(l_6_0, l_6_1, l_6_2)
end

ElementSpecialObjectiveGroup.get_as_followup = function(l_7_0, l_7_1, l_7_2)
  if l_7_2[l_7_0._id] then
    return 
  end
  l_7_2[l_7_0._id] = true
  return ElementSpecialObjective.choose_followup_SO(l_7_0, l_7_1, l_7_2), l_7_0._values.base_chance
end

ElementSpecialObjectiveGroup._execute_random_SO = function(l_8_0, l_8_1)
  local random_SO = ElementSpecialObjective.choose_followup_SO(l_8_0, l_8_1, {l_8_0._id = true})
  if random_SO then
    random_SO:on_executed(l_8_1)
  end
end


