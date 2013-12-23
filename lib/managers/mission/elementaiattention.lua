-- Decompiled using luadec 2.0.1 by sztupy (http://winmo.sztupy.hu)
-- Command line was: F:\SteamLibrary\SteamApps\common\PAYDAY 2\lua\lib\managers\mission\elementaiattention.luac 

core:import("CoreMissionScriptElement")
if not ElementAIAttention then
  ElementAIAttention = class(CoreMissionScriptElement.MissionScriptElement)
end
ElementAIAttention.init = function(l_1_0, ...)
  ElementAIAttention.super.init(l_1_0, ...)
   -- DECOMPILER ERROR: Confused about usage of registers for local variables.

end

ElementAIAttention.on_executed = function(l_2_0, l_2_1)
  if not l_2_0._values.enabled or Network:is_client() then
    return 
  end
  if l_2_0._values.use_instigator then
    l_2_0:_apply_attention_on_unit(l_2_1, nil)
  else
    if l_2_0._values.instigator_ids then
      local units = l_2_0:_select_units_from_spawners()
      if units then
        for _,unit in ipairs(units) do
          l_2_0:_apply_attention_on_unit(unit, nil)
        end
      else
        if l_2_0._values.att_obj_u_id then
          local unit = l_2_0:_fetch_unit_by_unit_id(l_2_0._values.att_obj_u_id)
          if unit then
            local handler = unit:attention()
            l_2_0:_chk_link_att_object(unit, handler)
            l_2_0:_apply_attention_on_unit(unit, handler)
        end
      end
    end
  end
  ElementSpecialObjective.super.on_executed(l_2_0, l_2_1)
end

ElementAIAttention.operation_remove = function(l_3_0)
end

ElementAIAttention._select_units_from_spawners = function(l_4_0)
  local candidates = {}
  for _,element_id in ipairs(l_4_0._values.instigator_ids) do
    local spawn_element = managers.mission:get_element_by_id(element_id)
    for _,unit in ipairs(spawn_element:units()) do
      if alive(unit) and managers.navigation:check_access(l_4_0._values.SO_access, unit:brain():SO_access(), 0) and unit:brain():is_available_for_assignment() then
        table.insert(candidates, unit)
      end
    end
  end
  local wanted_nr_units = nil
  if l_4_0._values.trigger_times <= 0 then
    wanted_nr_units = 1
  else
    wanted_nr_units = l_4_0._values.trigger_times
  end
  wanted_nr_units = math.min(wanted_nr_units, #candidates)
  local chosen_units = {}
  for i = 1, wanted_nr_units do
    local chosen_unit = table.remove(candidates, math.random(#candidates))
    table.insert(chosen_units, chosen_unit)
  end
  return chosen_units
end

ElementAIAttention._get_attention_handler_from_unit = function(l_5_0, l_5_1)
  if alive(l_5_1) and (not l_5_1:movement() or not l_5_1:movement():attention_handler()) and l_5_1:brain() then
    return l_5_1:brain():attention_handler()
  end
end

ElementAIAttention._create_attention_settings = function(l_6_0)
  local preset = l_6_0._values.preset
  if preset == "none" then
    return 
  end
  local setting_desc = tweak_data.attention.settings[preset]
  if setting_desc then
    local settings = PlayerMovement._create_attention_setting_from_descriptor(l_6_0, setting_desc, preset)
    return settings
  else
    debug_pause("[ElementAIAttention:_get_attention_settings] inexistent preset", preset, "element ID", l_6_0._id)
  end
end

ElementAIAttention._create_override_attention_settings = function(l_7_0, l_7_1)
  local preset = l_7_0._values.override
  if preset == "none" then
    return 
  end
  local setting_desc = tweak_data.attention.settings[preset]
  if setting_desc then
    local clbk_receiver_class = nil
    if l_7_1:base().is_local_player or l_7_1:base().is_husk_player then
      clbk_receiver_class = l_7_1:movement()
    else
      clbk_receiver_class = l_7_1:brain()
    end
    if not clbk_receiver_class then
      debug_pause_unit(l_7_1, "[ElementAIAttention:_create_override_attention_settings] cannot override attention for:", l_7_1)
      return 
    end
    local settings = PlayerMovement._create_attention_setting_from_descriptor(clbk_receiver_class, setting_desc, l_7_0._values.preset)
    return settings
  else
    debug_pause("[ElementAIAttention:_get_attention_settings] inexistent preset", preset, "element ID", l_7_0._id)
  end
end

ElementAIAttention._apply_attention_on_unit = function(l_8_0, l_8_1, l_8_2)
  if not l_8_2 then
    local handler = l_8_0:_get_attention_handler_from_unit(l_8_1)
  end
  if handler then
    if l_8_0._values.operation == "add" then
      local settings = l_8_0:_create_attention_settings()
      if settings then
        handler:add_attention(settings)
      else
        debug_pause("[ElementAIAttention:_apply_attention_on_unit] inexistent preset", l_8_0._values.preset, "element ID", l_8_0._id)
      end
    else
      if l_8_0._values.operation == "set" then
        if l_8_0._values.preset == "none" then
          handler:set_attention(nil)
        else
          local settings = l_8_0:_create_attention_settings()
          if settings then
            handler:set_attention(settings)
          else
            debug_pause("[ElementAIAttention:_apply_attention_on_unit] inexistent preset", l_8_0._values.preset, "element ID", l_8_0._id)
          end
        else
          if l_8_0._values.operation == "override" then
            if l_8_0._values.preset == "none" then
              debug_pause("[ElementAIAttention:_apply_attention_on_unit] override operation missing preset param", l_8_0._values.preset, l_8_0._values.override)
            else
              local settings = (l_8_0._values.override ~= "none" and l_8_0:_create_override_attention_settings(l_8_1))
              handler:override_attention(l_8_0._values.preset, settings)
            end
          else
            if alive(l_8_1) then
              debug_pause("[ElementAIAttention:_apply_attention_on_unit] unit missing attention handler", instigator, "element ID", l_8_0._id)
            end
          end
        end
      end
    end
  end
end
end

ElementAIAttention._chk_link_att_object = function(l_9_0, l_9_1, l_9_2)
  if not l_9_0._values.parent_u_id then
    return 
  end
  local parent_unit = l_9_0:_fetch_unit_by_unit_id(l_9_0._values.parent_u_id)
  if not parent_unit then
    debug_pause("[ElementAIAttention:_chk_link_att_object] could not find parent unit. element ID", l_9_0._id)
    return 
  end
  l_9_2:link(parent_unit, l_9_0._values.parent_obj_name, l_9_0._values.local_pos)
end

ElementAIAttention._fetch_unit_by_unit_id = function(l_10_0, l_10_1)
  local unit = nil
  if Application:editor() then
    unit = managers.editor:unit_with_id(tonumber(l_10_1))
  else
    unit = managers.worlddefinition:get_unit_on_load(tonumber(l_10_1), callback(l_10_0, l_10_0, "_load_unit"))
  end
  return unit
end

ElementAIAttention._load_unit = function(l_11_0)
end


