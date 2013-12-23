-- Decompiled using luadec 2.0.1 by sztupy (http://winmo.sztupy.hu)
-- Command line was: F:\SteamLibrary\SteamApps\common\PAYDAY 2\lua\core\lib\units\coreunitdamage.luac 

core:import("CoreSequenceManager")
if not CoreUnitDamage then
  CoreUnitDamage = class()
end
if not UnitDamage then
  UnitDamage = class(CoreUnitDamage)
end
CoreUnitDamage.init = function(l_1_0, l_1_1, l_1_2, l_1_3, l_1_4, l_1_5, l_1_6)
  l_1_0._unit = l_1_1
  l_1_0._unit_element = managers.sequence:get(l_1_1:name(), false, true)
  l_1_0._damage = 0
  l_1_0._variables = {}
  for k,v in pairs(l_1_0._unit_element._set_variables) do
    l_1_0._variables[k] = v
  end
  l_1_0._ids_damage = Idstring("damage")
  l_1_0._unit:set_extension_update_enabled(l_1_0._ids_damage, l_1_0._update_func_map ~= nil)
  for name,element in pairs(l_1_0._unit_element:get_proximity_element_map()) do
    local data = {}
    data.name = name
    data.enabled = element:get_enabled()
    if element:get_ref_object() then
      data.ref_object = l_1_0._unit:get_object(Idstring(element:get_ref_object()))
    end
    data.interval = element:get_interval()
    data.quick = element:is_quick()
    data.is_within = element:get_start_within()
    data.slotmask = element:get_slotmask()
    data.last_check_time = TimerManager:game():time() + math.rand(math.min(data.interval, 0))
    l_1_0:populate_proximity_range_data(data, "within_data", element:get_within_element())
    l_1_0:populate_proximity_range_data(data, "outside_data", element:get_outside_element())
    if not l_1_0._proximity_map then
      l_1_0._proximity_map = {}
    end
    l_1_0._proximity_map[name] = data
    l_1_0._proximity_count = (l_1_0._proximity_count or 0) + 1
    if data.enabled then
      if not l_1_0._proximity_enabled_count then
        l_1_0._proximity_enabled_count = 0
        l_1_0:set_update_callback("update_proximity_list", true)
      end
      l_1_0._proximity_enabled_count = l_1_0._proximity_enabled_count + 1
    end
  end
  for trigger_name in pairs(l_1_0._unit_element:get_trigger_name_map()) do
    if not l_1_0._trigger_func_list then
      l_1_0._trigger_func_list = {}
    end
    l_1_0._trigger_func_list[trigger_name] = {}
  end
  l_1_0._mover_collision_ignore_duration = l_1_6
  if not l_1_3 then
    l_1_3 = {}
  end
  if not l_1_2 then
    l_1_2 = CoreBodyDamage
  end
  local inflict_updator_damage_type_map = get_core_or_local("InflictUpdator").INFLICT_UPDATOR_DAMAGE_TYPE_MAP
  local unit_key = l_1_0._unit:key()
  for _,body_element in pairs(l_1_0._unit_element._bodies) do
    local body = l_1_0._unit:body(body_element._name)
    if body then
      if not body:extension() then
        body:set_extension({})
      end
      local body_ext = l_1_3[body_element._name] or l_1_2:new(l_1_0._unit, l_1_0, body, body_element)
      body:extension().damage = body_ext
      do
        local body_key = nil
        for _,damage_type in pairs(body_ext:get_endurance_map()) do
          if inflict_updator_damage_type_map[damage_type] then
            if not body_key then
              body_key = body:key()
            end
            if not l_1_0._added_inflict_updator_damage_type_map then
              l_1_0._added_inflict_updator_damage_type_map = {}
            end
            l_1_0._added_inflict_updator_damage_type_map[damage_type] = {}
            l_1_0._added_inflict_updator_damage_type_map[damage_type][body_key] = body_ext
            managers.sequence:add_inflict_updator_body(damage_type, unit_key, body_key, body_ext)
          end
        end
      end
      for (for control),_ in (for generator) do
      end
      Application:throw_exception("Unit \"" .. l_1_0._unit:name():t() .. "\" doesn't have the body \"" .. body_element._name .. "\" that was loaded into the SequenceManager.")
    end
    if not l_1_4 then
      l_1_0._unit:set_body_collision_callback(callback(l_1_0, l_1_0, "body_collision_callback"))
    end
    if l_1_0._unit:mover() and not l_1_5 then
      l_1_0._unit:set_mover_collision_callback(callback(l_1_0, l_1_0, "mover_collision_callback"))
    end
    l_1_0._water_check_element_map = l_1_0._unit_element:get_water_element_map()
    if l_1_0._water_check_element_map then
      for name,water_element in pairs(l_1_0._water_check_element_map) do
        l_1_0:set_water_check(name, water_element:get_enabled(), water_element:get_interval(), water_element:get_ref_object(), water_element:get_ref_body(), water_element:get_body_depth(), water_element:get_physic_effect())
      end
    end
    l_1_0._startup_sequence_map = l_1_0._unit_element:get_startup_sequence_map(l_1_0._unit, l_1_0)
    if l_1_0._startup_sequence_map then
      l_1_0._startup_sequence_callback_id = managers.sequence:add_time_callback(callback(l_1_0, l_1_0, "run_startup_sequences"))
    end
    if Application:editor() then
      l_1_0._editor_startup_sequence_map = l_1_0._unit_element:get_editor_startup_sequence_map(l_1_0._unit, l_1_0)
      if l_1_0._editor_startup_sequence_map then
        l_1_0._editor_startup_sequence_callback_id = managers.sequence:add_time_callback(callback(l_1_0, l_1_0, "run_editor_startup_sequences"))
      end
    end
     -- Warning: missing end command somewhere! Added here
  end
end

CoreUnitDamage.get_sound_source = function(l_2_0, l_2_1)
  if not l_2_0._sound_sources then
    l_2_0._sound_sources = {}
  end
  local sound_source = l_2_0._sound_sources[l_2_1]
  if not sound_source then
    sound_source = SoundDevice:create_source(l_2_1)
    local obj = l_2_0._unit:get_object(Idstring(l_2_1))
    if obj then
      sound_source:link(obj)
    else
      return 
    end
    l_2_0._sound_sources[l_2_1] = sound_source
  end
  return sound_source
end

CoreUnitDamage.destroy = function(l_3_0)
  if l_3_0._added_inflict_updator_damage_type_map then
    local unit_key = l_3_0._unit:key()
    for damage_type,body_map in pairs(l_3_0._added_inflict_updator_damage_type_map) do
      for body_key in pairs(body_map) do
        managers.sequence:remove_inflict_updator_body(damage_type, unit_key, body_key)
      end
    end
  end
  if l_3_0._water_check_map then
    for name in pairs(l_3_0._water_check_map) do
      l_3_0:set_water_check_active(, false)
    end
  end
  if l_3_0._inherit_destroy_unit_list then
    for _,unit in ipairs(l_3_0._inherit_destroy_unit_list) do
      if alive(unit) then
        unit:set_slot(0)
      end
    end
  end
end

CoreUnitDamage.update = function(l_4_0, l_4_1, l_4_2, l_4_3)
  if l_4_0._update_func_map then
    for func_name,data in pairs(l_4_0._update_func_map) do
      l_4_0[func_name](l_4_0, l_4_1, l_4_2, l_4_3, data)
    end
  else
    Application:error("Some scripter tried to enable the damage extension on unit \"" .. tostring(l_4_1:name()) .. "\" or an artist have specified more than one damage-extension in the unit xml. This would have resulted in a crash, so fix it!")
    l_4_0._unit:set_extension_update_enabled(l_4_0._ids_damage, false)
  end
end

CoreUnitDamage.set_update_callback = function(l_5_0, l_5_1, l_5_2)
  if l_5_2 then
    if not l_5_0._update_func_map then
      l_5_0._update_func_map = {}
    end
    if not l_5_0._update_func_map[l_5_1] then
      if not l_5_0._update_func_count then
        l_5_0._update_func_count = 0
        l_5_0._unit:set_extension_update_enabled(l_5_0._ids_damage, true)
      end
      l_5_0._update_func_count = l_5_0._update_func_count + 1
    end
    l_5_0._update_func_map[l_5_1] = l_5_2
  elseif l_5_0._update_func_map and l_5_0._update_func_map[l_5_1] then
    l_5_0._update_func_count = l_5_0._update_func_count - 1
    l_5_0._update_func_map[l_5_1] = nil
    if l_5_0._update_func_count == 0 then
      l_5_0._unit:set_extension_update_enabled(l_5_0._ids_damage, false)
      l_5_0._update_func_map = nil
      l_5_0._update_func_count = nil
    end
  end
end

CoreUnitDamage.populate_proximity_range_data = function(l_6_0, l_6_1, l_6_2, l_6_3)
  if l_6_3 then
    l_6_1[l_6_2] = {}
    l_6_1[l_6_2].element = l_6_3
    l_6_1[l_6_2].activation_count = 0
    l_6_1[l_6_2].max_activation_count = l_6_3:get_max_activation_count()
    l_6_1[l_6_2].delay = l_6_3:get_delay()
    l_6_1[l_6_2].range = l_6_3:get_range()
    l_6_1[l_6_2].count = l_6_3:get_count()
    l_6_1[l_6_2].is_within = l_6_2 == "within_data"
  end
end

CoreUnitDamage.set_proximity_enabled = function(l_7_0, l_7_1, l_7_2)
  if l_7_0._proximity_map then
    local data = l_7_0._proximity_map[l_7_1]
  end
  if data and not data.enabled ~= not l_7_2 then
    data.enabled = l_7_2
    if l_7_2 then
      if not l_7_0._proximity_enabled_count then
        l_7_0:set_update_callback("update_proximity_list", true)
        l_7_0._proximity_enabled_count = 0
      end
      l_7_0._proximity_enabled_count = l_7_0._proximity_enabled_count + 1
    else
      l_7_0._proximity_enabled_count = l_7_0._proximity_enabled_count - 1
      if l_7_0._proximity_enabled_count <= 0 then
        l_7_0._proximity_enabled_count = nil
        l_7_0:set_update_callback("update_proximity_list", nil)
      end
    end
  end
end

CoreUnitDamage.update_proximity_list = function(l_8_0, l_8_1, l_8_2, l_8_3)
  if managers.sequence:is_proximity_enabled() then
    for name,data in pairs(l_8_0._proximity_map) do
      if data.enabled and data.last_check_time + data.interval <= l_8_2 then
        local range_data, reversed = nil, nil
        if data.is_within then
          range_data = data.outside_data
          if not range_data then
            range_data = data.within_data
            reversed = true
          else
            reversed = false
          end
        else
          range_data = data.within_data
          if not range_data then
            range_data = data.outside_data
            reversed = true
          else
            reversed = false
          end
        end
        if l_8_0:check_proximity_activation_count(data) and data.last_check_time + range_data.delay <= l_8_2 and l_8_0:update_proximity(l_8_1, l_8_2, l_8_3, data, range_data) ~= reversed then
          data.last_check_time = l_8_2
          data.is_within = not data.is_within
          if not reversed and l_8_0:is_proximity_range_active(range_data) then
            range_data.activation_count = range_data.activation_count + 1
            if not l_8_0._proximity_env then
              l_8_0._proximity_env = CoreSequenceManager.SequenceEnvironment:new("proximity", l_8_0._unit, l_8_0._unit, nil, Vector3(0, 0, 0), Vector3(0, 0, 0), Vector3(0, 0, 0), 0, (Vector3(0, 0, 0)), nil, l_8_0._unit_element)
            end
            range_data.element:activate_elements(l_8_0._proximity_env)
            l_8_0:check_proximity_activation_count(data)
          end
        end
      end
    end
  end
end

CoreUnitDamage.is_proximity_range_active = function(l_9_0, l_9_1)
  return not l_9_1 or l_9_1.max_activation_count < 0 or l_9_1.activation_count < l_9_1.max_activation_count
end

CoreUnitDamage.check_proximity_activation_count = function(l_10_0, l_10_1)
  if not l_10_0:is_proximity_range_active(l_10_1.within_data) and not l_10_0:is_proximity_range_active(l_10_1.outside_data) then
    l_10_0:set_proximity_enabled(l_10_1.name, false)
    return false
  else
    return true
  end
end

CoreUnitDamage.update_proximity = function(l_11_0, l_11_1, l_11_2, l_11_3, l_11_4, l_11_5)
  local pos = nil
  if l_11_4.ref_object then
    pos = l_11_4.ref_object:position()
  else
    pos = l_11_0._unit:position()
  end
  local unit_list = nil
  if l_11_5.quick then
    unit_list = l_11_0._unit:find_units_quick("sphere", pos, l_11_5.range, l_11_4.slotmask)
  else
    unit_list = l_11_0._unit:find_units("sphere", pos, l_11_5.range, l_11_4.slotmask)
  end
  if #unit_list > l_11_5.count then
    return (not l_11_4.is_within or l_11_5.is_within == l_11_4.is_within) and l_11_4.is_within or l_11_5.is_within ~= l_11_4.is_within
  end
  do return end
  return l_11_5.count <= #unit_list
end

CoreUnitDamage.get_proximity_map = function(l_12_0)
  if not l_12_0._proximity_map then
    return {}
  end
end

CoreUnitDamage.set_proximity_slotmask = function(l_13_0, l_13_1, l_13_2)
  l_13_0._proximity_map[l_13_1].slotmask = l_13_2
end

CoreUnitDamage.set_proximity_ref_obj_name = function(l_14_0, l_14_1, l_14_2)
  if l_14_2 then
    l_14_0._proximity_map[l_14_1].ref_object = l_14_0._unit:get_object(Idstring(l_14_2))
  end
end

CoreUnitDamage.set_proximity_interval = function(l_15_0, l_15_1, l_15_2)
  l_15_0._proximity_map[l_15_1].interval = l_15_2
end

CoreUnitDamage.set_proximity_is_within = function(l_16_0, l_16_1, l_16_2)
  l_16_0._proximity_map[l_16_1].is_within = l_16_2
end

CoreUnitDamage.set_proximity_within_activations = function(l_17_0, l_17_1, l_17_2)
  local data = l_17_0._proximity_map[l_17_1]
  local within_data = data.within_data
  if within_data then
    within_data.activations = l_17_2
    return l_17_0:check_proximity_activation_count(data)
  end
end

CoreUnitDamage.set_proximity_within_max_activations = function(l_18_0, l_18_1, l_18_2)
  local data = l_18_0._proximity_map[l_18_1]
  local within_data = data.within_data
  if within_data then
    within_data.max_activations = l_18_2
    return l_18_0:check_proximity_activation_count(data)
  end
end

CoreUnitDamage.set_proximity_within_delay = function(l_19_0, l_19_1, l_19_2)
  local within_data = l_19_0._proximity_map[l_19_1].within_data
  if within_data then
    within_data.delay = l_19_2
  end
end

CoreUnitDamage.set_proximity_within_range = function(l_20_0, l_20_1, l_20_2)
  local within_data = l_20_0._proximity_map[l_20_1].within_data
  if within_data then
    within_data.range = l_20_2
  end
end

CoreUnitDamage.set_proximity_inside_count = function(l_21_0, l_21_1, l_21_2)
  local within_data = l_21_0._proximity_map[l_21_1].within_data
  if within_data then
    within_data.count = l_21_2
  end
end

CoreUnitDamage.set_proximity_outside_activations = function(l_22_0, l_22_1, l_22_2)
  local data = l_22_0._proximity_map[l_22_1]
  local outside_data = data.outside_data
  if outside_data then
    outside_data.activations = l_22_2
    return l_22_0:check_proximity_activation_count(data)
  end
end

CoreUnitDamage.set_proximity_outside_max_activations = function(l_23_0, l_23_1, l_23_2)
  local data = l_23_0._proximity_map[l_23_1]
  local outside_data = data.outside_data
  if outside_data then
    outside_data.max_activations = l_23_2
    return l_23_0:check_proximity_activation_count(data)
  end
end

CoreUnitDamage.set_proximity_outside_delay = function(l_24_0, l_24_1, l_24_2)
  local outside_data = l_24_0._proximity_map[l_24_1].outside_data
  if outside_data then
    outside_data.delay = l_24_2
  end
end

CoreUnitDamage.set_proximity_outside_range = function(l_25_0, l_25_1, l_25_2)
  local outside_data = l_25_0._proximity_map[l_25_1].outside_data
  if outside_data then
    outside_data.range = l_25_2
  end
end

CoreUnitDamage.set_proximity_outside_range = function(l_26_0, l_26_1, l_26_2)
  local outside_data = l_26_0._proximity_map[l_26_1].outside_data
  if outside_data then
    outside_data.range = count
  end
end

CoreUnitDamage.get_water_check_map = function(l_27_0)
  return l_27_0._water_check_map
end

CoreUnitDamage.set_water_check = function(l_28_0, l_28_1, l_28_2, l_28_3, l_28_4, l_28_5, l_28_6, l_28_7)
  if not l_28_0._water_check_map then
    l_28_0._water_check_map = {}
  end
  local water_check = l_28_0._water_check_map[l_28_1]
  if l_28_4 then
    local ref_object = l_28_0._unit:get_object(Idstring(l_28_4))
  end
  if l_28_5 then
    local ref_body = l_28_0._unit:body(l_28_5)
  end
  if not water_check then
    water_check = CoreDamageWaterCheck:new(l_28_0._unit, l_28_0, l_28_1, l_28_3, ref_object, ref_body, l_28_6, l_28_7)
    l_28_0._water_check_map[l_28_1] = water_check
  else
    water_check:set_interval(l_28_3)
    water_check:set_body_depth(l_28_6)
    if ref_object then
      water_check:set_ref_object(ref_object)
    elseif ref_body then
      water_check:set_ref_body(ref_body)
    end
  end
  l_28_0:set_water_check_active(l_28_1, l_28_2)
  if not water_check:is_valid() then
    Application:error("Invalid water check \"" .. tostring(l_28_1) .. "\" in unit \"" .. tostring(l_28_0._unit:name()) .. "\". Neither ref_body nor ref_object is speicified in it.")
    l_28_0:remove_water_check(l_28_1)
  end
end

CoreUnitDamage.remove_water_check = function(l_29_0, l_29_1)
  if l_29_0._water_check_map then
    local water_check = l_29_0._water_check_map[l_29_1]
    if water_check then
      l_29_0:set_water_check_active(l_29_1, false)
      l_29_0._water_check_map[l_29_1] = nil
    end
  end
end

CoreUnitDamage.exists_water_check = function(l_30_0, l_30_1)
  return not l_30_0._water_check_map or l_30_0._water_check_map[l_30_1] ~= nil
end

CoreUnitDamage.is_water_check_active = function(l_31_0, l_31_1)
  return not l_31_0._active_water_check_map or l_31_0._active_water_check_map[l_31_1] ~= nil
end

CoreUnitDamage.set_water_check_active = function(l_32_0, l_32_1, l_32_2)
  if l_32_0._water_check_map then
    local water_check = l_32_0._water_check_map[l_32_1]
  end
  if water_check and l_32_2 and (not l_32_0._active_water_check_map or not l_32_0._active_water_check_map[l_32_1]) then
    if not l_32_0._active_water_check_map then
      l_32_0._active_water_check_map = {}
    end
    l_32_0._active_water_check_map[l_32_1] = water_check
    l_32_0._active_water_check_count = (l_32_0._active_water_check_count or 0) + 1
    if l_32_0._active_water_check_count == 1 then
      l_32_0._water_check_func_id = managers.sequence:add_callback(callback(l_32_0, l_32_0, "update_water_checks"))
      do return end
      water_check:set_activation_callbacks_enabled(false)
      if l_32_0._active_water_check_map and l_32_0._active_water_check_map[l_32_1] then
        l_32_0._active_water_check_map[l_32_1] = nil
        l_32_0._active_water_check_count = l_32_0._active_water_check_count - 1
        if l_32_0._active_water_check_count == 0 then
          managers.sequence:remove_callback(l_32_0._water_check_func_id)
          l_32_0._water_check_func_id = nil
          l_32_0._active_water_check_map = nil
          l_32_0._active_water_check_count = nil
        end
      end
    end
  end
end

CoreUnitDamage.update_water_checks = function(l_33_0, l_33_1, l_33_2)
  for name,water_check in pairs(l_33_0._active_water_check_map) do
    water_check:update(l_33_1, l_33_2)
  end
end

CoreUnitDamage.water_check_enter = function(l_34_0, l_34_1, l_34_2, l_34_3, l_34_4, l_34_5, l_34_6, l_34_7, l_34_8, l_34_9, l_34_10)
  local element = l_34_0._water_check_element_map[l_34_1]
  if element then
    local env = CoreSequenceManager.SequenceEnvironment:new("water", l_34_3, l_34_0._unit, l_34_4, l_34_5, l_34_6, l_34_7, l_34_8, l_34_9, {water_depth = l_34_10}, l_34_0._unit_element)
    element:activate_enter(env)
  end
end

CoreUnitDamage.water_check_exit = function(l_35_0, l_35_1, l_35_2, l_35_3, l_35_4, l_35_5, l_35_6, l_35_7, l_35_8, l_35_9, l_35_10)
  local element = l_35_0._water_check_element_map[l_35_1]
  if element then
    local env = CoreSequenceManager.SequenceEnvironment:new("water", l_35_3, l_35_0._unit, l_35_4, l_35_5, l_35_6, l_35_7, l_35_8, l_35_9, {water_depth = l_35_10}, l_35_0._unit_element)
    element:activate_exit(env)
  end
end

CoreUnitDamage.save = function(l_36_0, l_36_1)
  local state = {}
  local changed = false
  if l_36_0._runned_sequences then
    for k,v in pairs(l_36_0._runned_sequences) do
      state.runned_sequences = table.map_copy(l_36_0._runned_sequences)
      changed = true
      do return end
    end
  end
  if l_36_0._state then
    for k,v in pairs(l_36_0._state) do
      state.state = deep_clone(l_36_0._state)
      changed = true
      do return end
    end
  end
  if l_36_0._damage ~= 0 then
    state.damage = l_36_0._damage
    changed = true
  end
  for k,v in pairs(l_36_0._variables) do
    if l_36_0._unit_element._set_variables[k] ~= v and (k ~= "damage" or v ~= l_36_0._damage) then
      state.variables = table.map_copy(l_36_0._variables)
      changed = true
  else
    end
  end
  if l_36_0._proximity_count then
    changed = true
    state.proximity_count = l_36_0._proximity_count
    state.proximity_enabled_count = l_36_0._proximity_enabled_count
    if not l_36_0._proximity_map then
      for name,data in pairs({}) do
      end
      if not state.proximity_map then
        state.proximity_map = {}
      end
      state.proximity_map[name] = {}
      for attribute_name,attribute_value in pairs(data) do
        if attribute_name == "ref_object" then
          if attribute_value then
            state.proximity_map[name][attribute_name] = attribute_value:name()
            for (for control),attribute_name in (for generator) do
            end
          end
          if attribute_name == "slotmask" then
            state.proximity_map[name][attribute_name] = managers.slot:get_mask_name(attribute_value)
            for (for control),attribute_name in (for generator) do
            end
            if attribute_name == "last_check_time" then
              state.proximity_map[name][attribute_name] = TimerManager:game():time() - attribute_value
              for (for control),attribute_name in (for generator) do
              end
              if attribute_name == "within_data" or attribute_name == "outside_data" then
                state.proximity_map[name][attribute_name] = {}
                for range_attribute_name,range_attribute_value in pairs(attribute_value) do
                  if range_attribute_name ~= "element" then
                    state.proximity_map[name][attribute_name][range_attribute_name] = range_attribute_value
                  end
                end
                for (for control),attribute_name in (for generator) do
                end
                state.proximity_map[name][attribute_name] = attribute_value
              end
            end
          end
          for _,anim_name in ipairs(l_36_0._unit:anim_groups()) do
            if not state.anim then
              state.anim = {}
            end
            local anim_time = l_36_0._unit:anim_time(anim_name)
            table.insert(state.anim, {name = anim_name, time = anim_time})
            changed = true
          end
          if not l_36_0._skip_save_anim_state_machine then
            local state_machine = l_36_0._unit:anim_state_machine()
            if state_machine then
              if not state.state_machine then
                state.state_machine = {}
              end
              for _,segment in ipairs(state_machine:config():segments()) do
                local anim_state = state_machine:segment_state(segment)
                if anim_state ~= Idstring("") then
                  local anim_time = state_machine:segment_real_time(segment)
                  table.insert(state.state_machine, {anim_state = anim_state, anim_time = anim_time})
                end
              end
            end
          end
          if l_36_0._unit_element:save_by_unit(l_36_0._unit, state) or changed then
            l_36_1.CoreUnitDamage = state
          end
           -- Warning: missing end command somewhere! Added here
        end
         -- Warning: missing end command somewhere! Added here
      end
       -- Warning: missing end command somewhere! Added here
    end
     -- Warning: missing end command somewhere! Added here
  end
end

CoreUnitDamage.get_unit_element = function(l_37_0)
  return l_37_0._unit_element
end

CoreUnitDamage.load = function(l_38_0, l_38_1)
  do
    local state = l_38_1.CoreUnitDamage
    if l_38_0._unit:name() == Idstring("units/payday2/vehicles/air_vehicle_blackhawk/helicopter_cops_ref") then
      print("[CoreUnitDamage:load]", l_38_0._unit)
    end
    if l_38_0._startup_sequence_callback_id then
      managers.sequence:remove_time_callback(l_38_0._startup_sequence_callback_id)
      l_38_0:run_startup_sequences()
    end
    if l_38_0._editor_startup_sequence_callback_id then
      managers.sequence:remove_time_callback(l_38_0._editor_startup_sequence_callback_id)
      l_38_0:run_editor_startup_sequences()
    end
    if state then
      if state.runned_sequences then
        l_38_0._runned_sequences = table.map_copy(state.runned_sequences)
      end
      if state.state then
        l_38_0._state = deep_clone(state.state)
      end
      if not state.damage then
        l_38_0._damage = l_38_0._damage
      end
      if state.variables then
        l_38_0._variables = table.map_copy(state.variables)
      end
      if state.proximity_map then
        l_38_0._proximity_count = state.proximity_count
        l_38_0._proximity_enabled_count = state.proximity_enabled_count
        for name,data in pairs(state.proximity_map) do
          if not l_38_0._proximity_map then
            l_38_0._proximity_map = {}
          end
          for attribute_name,attribute_value in pairs(data) do
            if attribute_name == "ref_object" then
              if attribute_value then
                l_38_0._proximity_map[name][attribute_name] = l_38_0._unit:get_object(Idstring(attribute_value))
                for (for control),attribute_name in (for generator) do
                end
              end
              if attribute_name == "slotmask" then
                l_38_0._proximity_map[name][attribute_name] = managers.slot:get_mask(attribute_value)
                for (for control),attribute_name in (for generator) do
                end
                if attribute_name == "last_check_time" then
                  l_38_0._proximity_map[name][attribute_name] = TimerManager:game():time() - attribute_value
                  for (for control),attribute_name in (for generator) do
                  end
                  if attribute_name == "within_data" or attribute_name == "outside_data" then
                    for range_attribute_name,range_attribute_value in pairs(attribute_value) do
                      l_38_0._proximity_map[name][attribute_name][range_attribute_name] = range_attribute_value
                    end
                    for (for control),attribute_name in (for generator) do
                    end
                    l_38_0._proximity_map[name][attribute_name] = attribute_value
                  end
                end
                if l_38_0._proximity_enabled_count then
                  l_38_0:set_update_callback("update_proximity_list", true)
                end
              end
              if state.anim then
                for _,anim_data in ipairs(state.anim) do
                  l_38_0._unit:anim_set_time(anim_data.name, anim_data.time)
                end
              end
              if state.state_machine then
                for _,anim_data in ipairs(state.state_machine) do
                  l_38_0._unit:play_state(anim_data.anim_state, anim_data.anim_time)
                end
              end
              if l_38_0._state then
                for element_name,data in pairs(l_38_0._state) do
                  managers.sequence:load_element_data(l_38_0._unit, element_name, data)
                end
              end
              l_38_0._unit_element:load_by_unit(l_38_0._unit, state)
            end
            managers.worlddefinition:use_me(l_38_0._unit)
            managers.worlddefinition:external_set_only_visible_in_editor(l_38_0._unit)
          end
           -- Warning: missing end command somewhere! Added here
        end
         -- Warning: missing end command somewhere! Added here
      end
       -- Warning: missing end command somewhere! Added here
    end
     -- Warning: missing end command somewhere! Added here
  end
end

CoreUnitDamage.run_startup_sequences = function(l_39_0)
  local nil_vector = Vector3(0, 0, 0)
  l_39_0._startup_sequence_callback_id = nil
  for name in pairs(l_39_0._startup_sequence_map) do
    if alive(l_39_0._unit) then
      managers.sequence:run_sequence(name, "startup", l_39_0._unit, l_39_0._unit, nil, nil_vector, nil_vector, nil_vector, 0, nil_vector)
      for (for control) in (for generator) do
        do return end
      end
    end
     -- Warning: missing end command somewhere! Added here
  end
end

CoreUnitDamage.run_editor_startup_sequences = function(l_40_0)
  local nil_vector = Vector3(0, 0, 0)
  l_40_0._editor_startup_sequence_callback_id = nil
  for name in pairs(l_40_0._editor_startup_sequence_map) do
    if alive(l_40_0._unit) then
      managers.sequence:run_sequence(name, "editor_startup", l_40_0._unit, l_40_0._unit, nil, nil_vector, nil_vector, nil_vector, 0, nil_vector)
      for (for control) in (for generator) do
        do return end
      end
    end
     -- Warning: missing end command somewhere! Added here
  end
end

CoreUnitDamage.remove_trigger_func = function(l_41_0, l_41_1, l_41_2, l_41_3)
  if l_41_0:verify_trigger_name(l_41_1) then
    l_41_0._trigger_func_list[l_41_1][l_41_2] = nil
    if l_41_3 then
      for index,data in ipairs(l_41_0._editor_trigger_data) do
        if data.id == l_41_2 then
          table.remove(l_41_0._editor_trigger_data, index)
      else
        end
      end
    end
     -- Warning: missing end command somewhere! Added here
  end
end

CoreUnitDamage.clear_trigger_func_list = function(l_42_0, l_42_1, l_42_2)
  if l_42_1 and l_42_0._trigger_func_list then
    l_42_0._trigger_func_list[l_42_1] = {}
    if l_42_0._editor_trigger_data then
      for i = #l_42_0._editor_trigger_data, 1 do
        local data = l_42_0._editor_trigger_data[i]
        if data.trigger_name == l_42_1 then
          table.remove(l_42_0._editor_trigger_data, i)
        end
      end
    else
      l_42_0._editor_trigger_data = nil
    end
  end
end

CoreUnitDamage.add_trigger_sequence = function(l_43_0, l_43_1, l_43_2, l_43_3, l_43_4, l_43_5, l_43_6, l_43_7)
  l_43_0._last_trigger_id = (l_43_0._last_trigger_id or 0) + 1
  return l_43_0:set_trigger_sequence(l_43_0._last_trigger_id, l_43_1, l_43_2, l_43_3, l_43_4, l_43_5, l_43_6, l_43_7)
end

CoreUnitDamage.set_trigger_sequence_name = function(l_44_0, l_44_1, l_44_2, l_44_3)
  if l_44_0._trigger_func_list and l_44_0._trigger_func_list[l_44_2][l_44_1] then
    for _,data in ipairs(l_44_0._editor_trigger_data) do
      if data.id == l_44_1 then
        return l_44_0:set_trigger_sequence(l_44_1, l_44_2, l_44_3, data.notify_unit, data.time, data.repeat_nr, data.params, true)
      end
    end
  end
  return nil
end

CoreUnitDamage.set_trigger_sequence_unit = function(l_45_0, l_45_1, l_45_2, l_45_3)
  if l_45_0._trigger_func_list and l_45_0._trigger_func_list[l_45_2][l_45_1] then
    for _,data in ipairs(l_45_0._editor_trigger_data) do
      if data.id == l_45_1 then
        return l_45_0:set_trigger_sequence(l_45_1, l_45_2, data.notify_unit_sequence, l_45_3, data.time, data.repeat_nr, data.params, true)
      end
    end
  end
  return nil
end

CoreUnitDamage.set_trigger_sequence_time = function(l_46_0, l_46_1, l_46_2, l_46_3)
  if l_46_0._trigger_func_list and l_46_0._trigger_func_list[l_46_2][l_46_1] then
    for _,data in ipairs(l_46_0._editor_trigger_data) do
      if data.id == l_46_1 then
        return l_46_0:set_trigger_sequence(l_46_1, l_46_2, data.notify_unit_sequence, data.notify_unit, l_46_3, data.repeat_nr, data.params, true)
      end
    end
  end
  return nil
end

CoreUnitDamage.set_trigger_sequence_repeat_nr = function(l_47_0, l_47_1, l_47_2, l_47_3)
  if l_47_0._trigger_func_list and l_47_0._trigger_func_list[l_47_2][l_47_1] then
    for _,data in ipairs(l_47_0._editor_trigger_data) do
      if data.id == l_47_1 then
        return l_47_0:set_trigger_sequence(l_47_1, l_47_2, data.notify_unit_sequence, data.notify_unit, data.time, l_47_3, data.params, true)
      end
    end
  end
  return nil
end

CoreUnitDamage.set_trigger_sequence_params = function(l_48_0, l_48_1, l_48_2, l_48_3)
  if l_48_0._trigger_func_list and l_48_0._trigger_func_list[l_48_2][l_48_1] then
    for _,data in ipairs(l_48_0._editor_trigger_data) do
      if data.id == l_48_1 then
        return l_48_0:set_trigger_sequence(l_48_1, l_48_2, data.notify_unit_sequence, data.notify_unit, data.time, data.repeat_nr, l_48_3, true)
      end
    end
  end
  return nil
end

CoreUnitDamage.set_trigger_sequence = function(l_49_0, l_49_1, l_49_2, l_49_3, l_49_4, l_49_5, l_49_6, l_49_7, l_49_8)
  do
    local func = function(l_1_0)
    if l_1_0 and params and getmetatable(l_1_0) ~= CoreSequenceManager.SequenceEnvironment then
      if getmetatable(params) == CoreSequenceManager.SequenceEnvironment then
        for k,v in pairs(l_1_0) do
          params.params[k] = v
        end
      else
        for k,v in pairs(l_1_0) do
          params[k] = v
        end
      end
    else
      params = l_1_0
    end
  end
  if getmetatable(params) == CoreSequenceManager.SequenceEnvironment then
    managers.sequence:run_sequence(notify_unit_sequence, "trigger", self._unit, notify_unit, nil, params.dest_normal, params.pos, params.dir, params.damage, params.velocity, params.params)
  else
    managers.sequence:run_sequence_simple3(managers.sequence, notify_unit_sequence, "trigger", self._unit, notify_unit, params)
  end
   end
    if l_49_8 then
      local data = nil
      if not l_49_0._editor_trigger_data then
        l_49_0._editor_trigger_data = {}
      end
      if l_49_0._trigger_func_list and l_49_0._trigger_func_list[l_49_2] and l_49_0._trigger_func_list[l_49_2][l_49_1] then
        for _,data2 in ipairs(l_49_0._editor_trigger_data) do
          if data2.id == l_49_1 then
            data = data2
        else
          end
        end
        if not data then
          data = {}
          table.insert(l_49_0._editor_trigger_data, data)
        end
        data.id = l_49_1
        data.trigger_name = l_49_2
        data.notify_unit_sequence = l_49_3
        data.notify_unit = l_49_4
        data.time = l_49_5
        data.repeat_nr = l_49_6
        data.params = l_49_7
      end
      return l_49_0:set_trigger_func(l_49_1, l_49_2, func, l_49_5, l_49_6, l_49_8)
    end
     -- Warning: missing end command somewhere! Added here
  end
end

CoreUnitDamage.get_editor_trigger_data = function(l_50_0)
  if l_50_0._editor_trigger_data then
    for i = #l_50_0._editor_trigger_data, 1, -1 do
      local data = l_50_0._editor_trigger_data[i]
      if not alive(data.notify_unit) then
        l_50_0:remove_trigger_func(data.trigger_name, data.id, true)
      end
    end
  end
  return l_50_0._editor_trigger_data
end

CoreUnitDamage.add_trigger_func = function(l_51_0, l_51_1, l_51_2, l_51_3, l_51_4, l_51_5)
  l_51_0._last_trigger_id = (l_51_0._last_trigger_id or 0) + 1
  return l_51_0:set_trigger_func(l_51_0._last_trigger_id, l_51_1, l_51_2, l_51_3, l_51_4, l_51_5)
end

CoreUnitDamage.set_trigger_func = function(l_52_0, l_52_1, l_52_2, l_52_3, l_52_4, l_52_5, l_52_6)
  if l_52_0:verify_trigger_name(l_52_2) then
    local trigger_func = nil
    if l_52_4 then
      trigger_func = function(l_1_0)
      managers.sequence:add_time_callback(func, time, repeat_nr, l_1_0)
      end
    elseif l_52_5 and l_52_5 > 1 then
      trigger_func = function(l_2_0)
      for i = 1, repeat_nr do
        func(l_2_0)
      end
      end
    else
      trigger_func = l_52_3
    end
    l_52_0._trigger_func_list[l_52_2][l_52_1] = trigger_func
    return l_52_1
  end
  return nil
end

CoreUnitDamage.activate_trigger = function(l_53_0, l_53_1, l_53_2)
  if l_53_0:verify_trigger_name(l_53_1) then
    for _,func in pairs(l_53_0._trigger_func_list[l_53_1]) do
      func(l_53_2)
    end
  end
end

CoreUnitDamage.verify_trigger_name = function(l_54_0, l_54_1)
  if l_54_1 and l_54_0._trigger_func_list and l_54_0._trigger_func_list[l_54_1] then
    return true
  else
    Application:error("Trigger \"" .. tostring(l_54_1) .. "\" doesn't exist. Only the following triggers are available: " .. managers.sequence:get_keys_as_string(l_54_0._unit_element:get_trigger_name_map(), "[None]", true))
    return false
  end
end

CoreUnitDamage.inflict_damage = function(l_55_0, l_55_1, l_55_2, l_55_3, l_55_4, l_55_5, l_55_6, l_55_7)
  local damage = nil
  local body_ext = (l_55_3:extension())
  local damage_ext = nil
  if body_ext then
    damage_ext = body_ext.damage
    if damage_ext then
      return damage_ext:inflict_damage(l_55_1, l_55_0._unit, l_55_2, l_55_4, l_55_5, l_55_6)
    end
  end
  return nil, false
end

CoreUnitDamage.damage_damage = function(l_56_0, l_56_1, l_56_2, l_56_3, l_56_4, l_56_5, l_56_6, l_56_7)
  return l_56_0:add_damage("damage", l_56_1, l_56_2, l_56_3, l_56_4, l_56_5, l_56_6, Vector3(0, 0, 0), l_56_7)
end

CoreUnitDamage.damage_bullet = function(l_57_0, l_57_1, l_57_2, l_57_3, l_57_4, l_57_5, l_57_6, l_57_7)
  return l_57_0:add_damage("bullet", l_57_1, l_57_2, l_57_3, l_57_4, l_57_5, l_57_6, Vector3(0, 0, 0), l_57_7)
end

CoreUnitDamage.damage_lock = function(l_58_0, l_58_1, l_58_2, l_58_3, l_58_4, l_58_5, l_58_6, l_58_7)
  return l_58_0:add_damage("lock", l_58_1, l_58_2, l_58_3, l_58_4, l_58_5, l_58_6, Vector3(0, 0, 0), l_58_7)
end

CoreUnitDamage.damage_explosion = function(l_59_0, l_59_1, l_59_2, l_59_3, l_59_4, l_59_5, l_59_6)
  return l_59_0:add_damage("explosion", l_59_1, l_59_2, l_59_3, l_59_4, l_59_5, l_59_6, Vector3(0, 0, 0))
end

CoreUnitDamage.damage_collision = function(l_60_0, l_60_1, l_60_2, l_60_3, l_60_4, l_60_5, l_60_6, l_60_7)
  return l_60_0:add_damage("collision", l_60_1, l_60_2, l_60_3, l_60_4, l_60_5, l_60_6, l_60_7)
end

CoreUnitDamage.damage_melee = function(l_61_0, l_61_1, l_61_2, l_61_3, l_61_4, l_61_5, l_61_6)
  return l_61_0:add_damage("melee", l_61_1, l_61_2, l_61_3, l_61_4, l_61_5, l_61_6, Vector3(0, 0, 0))
end

CoreUnitDamage.damage_electricity = function(l_62_0, l_62_1, l_62_2, l_62_3, l_62_4, l_62_5, l_62_6)
  return l_62_0:add_damage("electricity", l_62_1, l_62_2, l_62_3, l_62_4, l_62_5, l_62_6, Vector3(0, 0, 0))
end

CoreUnitDamage.damage_fire = function(l_63_0, l_63_1, l_63_2, l_63_3, l_63_4, l_63_5, l_63_6, l_63_7)
  return l_63_0:add_damage("fire", l_63_1, l_63_2, l_63_3, l_63_4, l_63_5, l_63_6, l_63_7)
end

CoreUnitDamage.damage_by_area = function(l_64_0, l_64_1, l_64_2, l_64_3, l_64_4, l_64_5, l_64_6, l_64_7, l_64_8)
  local damage_func = l_64_0.damage_" .. l_64_
  if damage_func then
    return damage_func(l_64_0, l_64_2, l_64_3, l_64_4, l_64_5, l_64_6, l_64_7, l_64_8)
  else
    Application:error("Unit \"" .. tostring(l_64_0._unit:name()) .. "\" doesn't have a \"damage_" .. tostring(l_64_1) .. "\"-function on its unit damage extension.")
    return false, nil
  end
end

CoreUnitDamage.add_damage = function(l_65_0, l_65_1, l_65_2, l_65_3, l_65_4, l_65_5, l_65_6, l_65_7, l_65_8)
  if l_65_0._unit_element then
    l_65_0._damage = l_65_0._damage + l_65_7
    if l_65_0._unit_element._global_vars.endurance <= l_65_0._damage then
      return true, l_65_7
    else
      return false, l_65_7
    end
  else
    return false, 0
  end
end

CoreUnitDamage.damage_effect = function(l_66_0, l_66_1, l_66_2, l_66_3, l_66_4, l_66_5, l_66_6, l_66_7, l_66_8)
end

CoreUnitDamage.run_sequence_simple = function(l_67_0, l_67_1, l_67_2)
  l_67_0:run_sequence_simple2(l_67_0, l_67_1, "", l_67_2)
end

CoreUnitDamage.run_sequence_simple2 = function(l_68_0, l_68_1, l_68_2, l_68_3)
  l_68_0:run_sequence_simple3(l_68_0, l_68_1, l_68_2, l_68_0._unit, l_68_3)
end

CoreUnitDamage.run_sequence_simple3 = function(l_69_0, l_69_1, l_69_2, l_69_3, l_69_4)
  l_69_0:run_sequence(l_69_1, l_69_2, l_69_3, nil, Vector3(0, 0, 1), l_69_0._unit:position(), Vector3(0, 0, -1), 0, Vector3(0, 0, 0), l_69_4)
end

CoreUnitDamage.run_sequence = function(l_70_0, l_70_1, l_70_2, l_70_3, l_70_4, l_70_5, l_70_6, l_70_7, l_70_8, l_70_9, l_70_10)
  l_70_0._unit_element:run_sequence(l_70_1, l_70_2, l_70_3, l_70_0._unit, l_70_4, l_70_5, l_70_6, l_70_7, l_70_8, l_70_9, l_70_10)
end

CoreUnitDamage.get_damage = function(l_71_0)
  return l_71_0._damage
end

CoreUnitDamage.get_endurance = function(l_72_0)
  if l_72_0._unit_element then
    return l_72_0._unit_element:get_endurance()
  else
    return 0
  end
end

CoreUnitDamage.get_damage_ratio = function(l_73_0)
  if l_73_0._unit_element and l_73_0._unit_element:get_endurance() > 0 then
    return l_73_0._damage / l_73_0._unit_element:get_endurance()
  else
    return 0
  end
end

CoreUnitDamage.update_inflict_damage = function(l_74_0, l_74_1, l_74_2)
  if l_74_0._inflict_dest_body then
    for damage_type,dest_body in pairs(l_74_0._inflict_dest_body) do
      if not l_74_0._inflict_done or not l_74_0._inflict_done[damage_type] then
        if l_74_0._inflict_src_body then
          local src_body = l_74_0._inflict_src_body[damage_type]
        end
        if alive(src_body) and alive(dest_body) then
          l_74_0:exit_inflict_damage(damage_type, src_body, dest_body)
        end
        if l_74_0._inflict_src_body then
          l_74_0._inflict_src_body[damage_type] = nil
        end
        if l_74_0._inflict_dest_body then
          l_74_0._inflict_dest_body[damage_type] = nil
        end
      end
    end
  end
  l_74_0._inflict_done = nil
end

CoreUnitDamage.check_inflict_damage = function(l_75_0, l_75_1, l_75_2, l_75_3, l_75_4, l_75_5, l_75_6, l_75_7)
  local can_inflict, delayed = l_75_0:can_receive_inflict_damage(l_75_1, l_75_3)
  if not l_75_0._inflict_done then
    l_75_0._inflict_done = {}
  end
  l_75_0._inflict_done[l_75_1] = l_75_0._inflict_done[l_75_1] or can_inflict or delayed
  if can_inflict then
    if not l_75_0._inflict_dest_body then
      l_75_0._inflict_dest_body = {}
    end
    if not l_75_0._inflict_src_body then
      l_75_0._inflict_src_body = {}
    end
    local old_dest_body = l_75_0._inflict_dest_body[l_75_1]
    if alive(old_dest_body) and old_dest_body:key() ~= l_75_3:key() then
      l_75_0:exit_inflict_damage(l_75_1, l_75_0._inflict_src_body[l_75_1], old_dest_body, l_75_4, l_75_5, l_75_6, l_75_7)
    end
    l_75_0._inflict_dest_body[l_75_1] = l_75_3
    l_75_0._inflict_src_body[l_75_1] = l_75_2
    local entered = l_75_0:enter_inflict_damage(l_75_1, l_75_2, l_75_3, l_75_4, l_75_5, l_75_6, l_75_7)
    if not entered or l_75_3:extension().damage:get_inflict_instant(l_75_1) then
      return l_75_0:inflict_damage(l_75_1, l_75_2, l_75_3, l_75_4, l_75_5, l_75_6, l_75_7)
    else
      return false, 0
    end
  end
  return false, nil
end

CoreUnitDamage.can_receive_inflict_damage = function(l_76_0, l_76_1, l_76_2)
  if alive(l_76_2) then
    local body_ext = l_76_2:extension()
    if body_ext then
      local damage_ext = body_ext.damage
      if damage_ext then
        return damage_ext:can_inflict_damage(l_76_1, l_76_0._unit)
      end
    end
  end
  return false, false
end

CoreUnitDamage.enter_inflict_damage = function(l_77_0, l_77_1, l_77_2, l_77_3, l_77_4, l_77_5, l_77_6, l_77_7)
  return l_77_3:extension().damage:enter_inflict_damage(l_77_1, l_77_0._unit, l_77_2, l_77_4, l_77_5, l_77_6, l_77_7)
end

CoreUnitDamage.inflict_damage = function(l_78_0, l_78_1, l_78_2, l_78_3, l_78_4, l_78_5, l_78_6, l_78_7)
  return l_78_3:extension().damage:inflict_damage(l_78_1, l_78_0._unit, l_78_2, l_78_4, l_78_5, l_78_6, l_78_7)
end

CoreUnitDamage.exit_inflict_damage = function(l_79_0, l_79_1, l_79_2, l_79_3, l_79_4, l_79_5, l_79_6, l_79_7)
  l_79_3:extension().damage:exit_inflict_damage(l_79_1, l_79_2, l_79_4, l_79_5, l_79_6, l_79_7)
end

CoreUnitDamage.set_direct_attack_unit = function(l_80_0, l_80_1)
  l_80_0._direct_attack_unit = l_80_1
end

CoreUnitDamage.get_direct_attack_unit = function(l_81_0)
  return l_81_0._direct_attack_unit
end

CoreUnitDamage.add_body_collision_callback = function(l_82_0, l_82_1)
  l_82_0._last_body_collision_callback_id = (l_82_0._last_body_collision_callback_id or 0) + 1
  if not l_82_0._body_collision_callback_list then
    l_82_0._body_collision_callback_list = {}
  end
  l_82_0._body_collision_callback_list[l_82_0._last_body_collision_callback_id] = l_82_1
  return l_82_0._last_body_collision_callback_id
end

CoreUnitDamage.remove_body_collision_callback = function(l_83_0, l_83_1)
  if l_83_0._body_collision_callback_list then
    l_83_0._body_collision_callback_list[l_83_1] = nil
  end
end

CoreUnitDamage.add_mover_collision_callback = function(l_84_0, l_84_1)
  l_84_0._last_mover_collision_callback_id = (l_84_0._last_mover_collision_callback_id or 0) + 1
  if not l_84_0._mover_collision_callback_list then
    l_84_0._mover_collision_callback_list = {}
  end
  l_84_0._mover_collision_callback_list[l_84_0._last_mover_collision_callback_id] = l_84_1
  return l_84_0._last_mover_collision_callback_id
end

CoreUnitDamage.remove_mover_collision_callback = function(l_85_0, l_85_1)
  if l_85_0._mover_collision_callback_list then
    l_85_0._mover_collision_callback_list[l_85_1] = nil
  end
end

CoreUnitDamage.set_ignore_mover_collision_unit = function(l_86_0, l_86_1, l_86_2)
  if not l_86_0._ignore_mover_collision_unit_map then
    l_86_0._ignore_mover_collision_unit_map = {}
  end
  l_86_0._ignore_mover_collision_unit_map[l_86_1] = l_86_2
end

CoreUnitDamage.set_ignore_mover_collision_body = function(l_87_0, l_87_1, l_87_2)
  if not l_87_0._ignore_mover_collision_body_map then
    l_87_0._ignore_mover_collision_body_map = {}
  end
  l_87_0._ignore_mover_collision_body_map[l_87_1] = l_87_2
end

CoreUnitDamage.clear_ignore_mover_collision_units = function(l_88_0)
  l_88_0._ignore_mover_collision_unit_map = nil
end

CoreUnitDamage.clear_ignore_mover_collision_bodies = function(l_89_0)
  l_89_0._ignore_mover_collision_body_map = nil
end

CoreUnitDamage.set_ignore_body_collision_unit = function(l_90_0, l_90_1, l_90_2)
  if not l_90_0._ignore_body_collision_unit_map then
    l_90_0._ignore_body_collision_unit_map = {}
  end
  l_90_0._ignore_body_collision_unit_map[l_90_1] = l_90_2
end

CoreUnitDamage.clear_ignore_body_collision_units = function(l_91_0)
  l_91_0._ignore_body_collision_unit_map = nil
end

CoreUnitDamage.set_ignore_mover_on_mover_collisions = function(l_92_0, l_92_1)
  if l_92_1 then
    l_92_0._ignore_mover_on_mover_collisions = true
  else
    l_92_0._ignore_mover_on_mover_collisions = nil
  end
end

CoreUnitDamage.get_ignore_mover_on_mover_collisions = function(l_93_0)
  return not not l_93_0._ignore_mover_on_mover_collisions
end

CoreUnitDamage.give_body_collision_velocity = function(l_94_0)
  return not l_94_0._skip_give_body_collision_velocity
end

CoreUnitDamage.set_give_body_collision_velocity = function(l_95_0, l_95_1)
  l_95_0._skip_give_body_collision_velocity = not l_95_1
end

CoreUnitDamage.give_mover_collision_velocity = function(l_96_0)
  return not l_96_0._skip_give_mover_collision_velocity
end

CoreUnitDamage.set_give_mover_collision_velocity = function(l_97_0, l_97_1)
  l_97_0._skip_give_mover_collision_velocity = not l_97_1
end

CoreUnitDamage.give_body_collision_damage = function(l_98_0)
  return not l_98_0._skip_give_body_collision_damage
end

CoreUnitDamage.set_give_body_collision_damage = function(l_99_0, l_99_1)
  l_99_0._skip_give_body_collision_damage = not l_99_1
end

CoreUnitDamage.give_mover_collision_damage = function(l_100_0)
  return not l_100_0._skip_give_mover_collision_damage
end

CoreUnitDamage.set_give_mover_collision_damage = function(l_101_0, l_101_1)
  l_101_0._skip_give_mover_collision_damage = not l_101_1
end

CoreUnitDamage.receive_body_collision_damage = function(l_102_0)
  return not l_102_0._skip_receive_body_collision_damage
end

CoreUnitDamage.set_receive_body_collision_damage = function(l_103_0, l_103_1)
  l_103_0._skip_receive_body_collision_damage = not l_103_1
end

CoreUnitDamage.receive_mover_collision_damage = function(l_104_0)
  return not l_104_0._skip_receive_mover_collision_damage
end

CoreUnitDamage.set_receive_mover_collision_damage = function(l_105_0, l_105_1)
  l_105_0._skip_receive_mover_collision_damage = not l_105_1
end

CoreUnitDamage.can_mover_collide = function(l_106_0, l_106_1, l_106_2, l_106_3, l_106_4, l_106_5, l_106_6, l_106_7, l_106_8, l_106_9)
  local alive_other_body = alive(l_106_4)
  local damage_ext = l_106_3:damage()
  return (damage_ext and not damage_ext:give_mover_collision_damage()) or (l_106_0._skip_receive_mover_collision_damage or ((not l_106_0._ignore_mover_collision_unit_map or not l_106_0._ignore_mover_collision_unit_map[l_106_3:key()] or l_106_0._ignore_mover_collision_unit_map[l_106_3:key()] < l_106_1) and not alive_other_body or not l_106_0._ignore_mover_collision_body_map or not l_106_0._ignore_mover_collision_body_map[l_106_4:key()] or l_106_0._ignore_mover_collision_body_map[l_106_4:key()] < l_106_1))
end

CoreUnitDamage.can_body_collide = function(l_107_0, l_107_1, l_107_2, l_107_3, l_107_4, l_107_5, l_107_6, l_107_7, l_107_8, l_107_9, l_107_10, l_107_11)
  local damage_ext = l_107_5:damage()
  return (damage_ext and not damage_ext:give_body_collision_damage()) or (not l_107_0._skip_receive_body_collision_damage and not managers.sequence:is_collisions_enabled() or l_107_0._ignore_body_collision_unit_map and l_107_0._ignore_body_collision_unit_map[l_107_5:key()] and l_107_0._ignore_body_collision_unit_map[l_107_5:key()] < l_107_1)
end

CoreUnitDamage.get_collision_velocity = function(l_108_0, l_108_1, l_108_2, l_108_3, l_108_4, l_108_5, l_108_6, l_108_7, l_108_8, l_108_9)
  local damage_ext = l_108_4:damage()
  local is_other_mover = not alive(l_108_3)
  if damage_ext and is_other_mover and not damage_ext:give_mover_collision_velocity() then
    l_108_9 = Vector3()
    do return end
    if not damage_ext:give_body_collision_velocity() then
      l_108_9 = Vector3()
    end
  end
  if l_108_7 then
    local other_velocity_dir = l_108_9:normalized()
    local other_velocity_length = l_108_9:length()
    l_108_8 = other_velocity_dir * math.clamp(math.dot(l_108_8, other_velocity_dir), 0, other_velocity_length)
  end
  l_108_5 = l_108_8 - l_108_9
  if l_108_8:length() < l_108_9:length() then
    l_108_5 = -(l_108_5)
  end
  local direction = l_108_5:normalized()
  if direction:length() == 0 then
    direction = -l_108_6
  end
  return l_108_0:add_angular_velocity(l_108_1, direction, l_108_2, l_108_3, l_108_4, l_108_5, l_108_7)
end

CoreUnitDamage.add_angular_velocity = function(l_109_0, l_109_1, l_109_2, l_109_3, l_109_4, l_109_5, l_109_6, l_109_7)
  local angular_velocity_addition = Vector3()
  if alive(l_109_3) then
    local body_ang_vel = l_109_3:angular_velocity()
    angular_velocity_addition = l_109_2 * 200 * body_ang_vel:length() * (1 + math.abs(math.dot(body_ang_vel:normalized(), l_109_2))) / (10 * math.pi)
  end
  if alive(l_109_4) then
    local other_body_ang_vel = l_109_4:angular_velocity()
    angular_velocity_addition = angular_velocity_addition + l_109_2 * 200 * other_body_ang_vel:length() * (1 + math.abs(math.dot(other_body_ang_vel:normalized(), l_109_2))) / (10 * math.pi)
    angular_velocity_addition = l_109_2 * math.clamp(angular_velocity_addition:length(), 0, 200)
  end
  return l_109_6 + angular_velocity_addition, l_109_2
end

CoreUnitDamage.get_collision_damage = function(l_110_0, l_110_1, l_110_2, l_110_3, l_110_4, l_110_5, l_110_6, l_110_7, l_110_8)
  return math.clamp((l_110_7:length() - 400) / 100, 0, 75)
end

CoreUnitDamage.body_collision_callback = function(l_111_0, l_111_1, l_111_2, l_111_3, l_111_4, l_111_5, l_111_6, l_111_7, l_111_8, l_111_9, l_111_10)
  local time = (TimerManager:game():time())
  local new_velocity, direction, damage = nil, nil, nil
  if l_111_0:can_body_collide(time, l_111_1, l_111_2, l_111_3, l_111_4, l_111_5, l_111_6, l_111_7, l_111_8, l_111_9, l_111_10) then
    new_velocity, direction = l_111_0:get_collision_velocity(l_111_6, l_111_3, l_111_5, l_111_4, l_111_8, l_111_7, false, l_111_9, l_111_10)
    damage = l_111_0:get_collision_damage(l_111_1, l_111_3, l_111_4, l_111_5, l_111_6, l_111_7, new_velocity, false)
    l_111_0:collision(l_111_1, l_111_2, l_111_3, l_111_4, l_111_5, l_111_6, l_111_7, direction, damage, new_velocity, false)
  end
  if l_111_0._body_collision_callback_list then
    for _,func in pairs(l_111_0._body_collision_callback_list) do
      func(l_111_1, l_111_2, l_111_3, l_111_4, l_111_5, l_111_6, l_111_7, l_111_8, l_111_9, l_111_10, new_velocity, direction, damage)
    end
  end
end

CoreUnitDamage.mover_collision_callback = function(l_112_0, l_112_1, l_112_2, l_112_3, l_112_4, l_112_5, l_112_6, l_112_7, l_112_8)
  local time = (TimerManager:game():time())
  local new_velocity, direction, damage = nil, nil, nil
  if l_112_0:can_mover_collide(time, l_112_1, l_112_2, l_112_3, l_112_4, l_112_5, l_112_6, l_112_7, l_112_8) then
    new_velocity, direction = l_112_0:get_collision_velocity(l_112_4, nil, l_112_3, l_112_2, l_112_6, l_112_5, true, l_112_7, l_112_8)
    damage = l_112_0:get_collision_damage(nil, nil, l_112_2, l_112_3, l_112_4, l_112_5, new_velocity, true)
    if damage > 0 then
      if alive(l_112_3) then
        local body_list = l_112_3:constrained_bodies()
        table.insert(body_list, l_112_3)
        for _,body in ipairs(body_list) do
          l_112_0:set_ignore_mover_collision_body(body:key(), time + (l_112_0._mover_collision_ignore_duration or 1))
        end
      else
        if not l_112_0._mover_collision_ignore_duration then
          l_112_0:set_ignore_mover_collision_unit(l_112_2:key(), time + (not alive(l_112_2) or 1))
        end
      end
    end
    l_112_0:collision(nil, l_112_1, nil, l_112_2, l_112_3, l_112_4, l_112_5, direction, damage, new_velocity, true)
  end
  if l_112_0._mover_collision_callback_list then
    for _,func in pairs(l_112_0._mover_collision_callback_list) do
      func(l_112_1, l_112_2, l_112_3, l_112_4, l_112_5, l_112_6, l_112_7, l_112_8, new_velocity, direction, damage)
    end
  end
end

CoreUnitDamage.collision = function(l_113_0, l_113_1, l_113_2, l_113_3, l_113_4, l_113_5, l_113_6, l_113_7, l_113_8, l_113_9, l_113_10, l_113_11)
  if l_113_9 > 0 then
    if l_113_3 then
      local body_ext = l_113_3:extension()
      if body_ext and body_ext.damage then
        body_ext.damage:damage_collision(l_113_4, l_113_7, l_113_6, l_113_8, l_113_9, l_113_10)
      else
        l_113_0:damage_collision(l_113_4, l_113_3, l_113_7, l_113_6, l_113_8, l_113_9, l_113_10)
      end
    end
  end
end

CoreUnitDamage.toggle_debug_collision_all = function(l_114_0)
  l_114_0:toggle_debug_collision_body()
  l_114_0:toggle_debug_collision_mover()
end

CoreUnitDamage.set_debug_collision_all = function(l_115_0, l_115_1)
  l_115_0:toggle_debug_collision_body(l_115_1)
  l_115_0:toggle_debug_collision_mover(l_115_1)
end

CoreUnitDamage.toggle_debug_collision_body = function(l_116_0)
  l_116_0:set_debug_collision_body(not l_116_0._debug_collision_body_id)
end

CoreUnitDamage.set_debug_collision_body = function(l_117_0, l_117_1)
  if not l_117_0._debug_collision_body_id ~= not l_117_1 then
    if l_117_1 then
      l_117_0._debug_collision_body_id = l_117_0:add_body_collision_callback(callback(l_117_0, l_117_0, "debug_collision_body"))
    else
      l_117_0:remove_body_collision_callback(l_117_0._debug_collision_body_id)
      l_117_0._debug_collision_body_id = nil
    end
    cat_debug("debug", "Body collision debugging " .. tostring(l_117_0._unit) .. " enabled: " .. tostring(not not l_117_1))
  end
end

CoreUnitDamage.toggle_debug_collision_mover = function(l_118_0)
  l_118_0:set_debug_collision_mover(not l_118_0._debug_collision_mover_id)
end

CoreUnitDamage.set_debug_collision_mover = function(l_119_0, l_119_1)
  if not l_119_0._debug_collision_mover_id ~= not l_119_1 then
    if l_119_1 then
      l_119_0._debug_collision_mover_id = l_119_0:add_mover_collision_callback(callback(l_119_0, l_119_0, "debug_collision_mover"))
    else
      l_119_0:remove_mover_collision_callback(l_119_0._debug_collision_mover_id)
      l_119_0._debug_collision_mover_id = nil
    end
    cat_debug("debug", "Mover collision debugging " .. tostring(l_119_0._unit) .. " enabled: " .. tostring(not not l_119_1))
  end
end

CoreUnitDamage.debug_collision_body = function(l_120_0, l_120_1, l_120_2, l_120_3, l_120_4, l_120_5, l_120_6, l_120_7, l_120_8, l_120_9, l_120_10, l_120_11, l_120_12, l_120_13)
  local time = TimerManager:game():time()
  cat_debug("debug", string.format("[B %g] Velocity: %g, Damage: %g, Ignored: %s", time, l_120_11 and l_120_11:length() or 0, l_120_13 or 0, tostring(not l_120_11)))
  if managers.debug then
    managers.debug.gui:set_color(1, 1, 1, 1)
    managers.debug.gui:set(1, "[B] \"" .. tostring(alive(l_120_0._unit) and l_120_0._unit:name() or nil) .. "\" by \"" .. tostring(alive(l_120_4) and l_120_4:name() or nil) .. "\"")
    l_120_0:debug_draw_velocity(2, "[B] Own velocity", l_120_6, l_120_9, 0, 0, 1)
    l_120_0:debug_draw_velocity(3, "[B] Other velocity", l_120_6, l_120_10, 1, 0, 0)
    l_120_0:debug_draw_velocity(4, "[B] Collision velocity", l_120_6, l_120_8, 0, 1, 1)
    l_120_0:debug_draw_velocity(5, "[B] Damage velocity", l_120_6, l_120_11, 0, 1, 0)
    managers.debug.gui:set_color(6, 1, 0.5, 0.5)
    managers.debug.gui:set(6, "[B] Damage: " .. tostring(l_120_13))
    managers.debug.gui:set_color(7, 0.5, 0.5, 0.5)
    managers.debug.gui:set(7, "[B] Ignored: " .. tostring(not l_120_11))
  end
end

CoreUnitDamage.debug_collision_mover = function(l_121_0, l_121_1, l_121_2, l_121_3, l_121_4, l_121_5, l_121_6, l_121_7, l_121_8, l_121_9, l_121_10, l_121_11)
  local time = TimerManager:game():time()
  cat_debug("debug", string.format("[M %g] Velocity: %g, Damage: %g, Ignored: %s", time, l_121_9 and l_121_9:length() or 0, l_121_11 or 0, tostring(not l_121_9)))
  if managers.debug then
    managers.debug.gui:set_color(1, 1, 1, 1)
    managers.debug.gui:set(1, "[M] \"" .. tostring(alive(l_121_0._unit) and l_121_0._unit:name() or nil) .. "\" by \"" .. tostring(alive(l_121_2) and l_121_2:name() or nil) .. "\"")
    l_121_0:debug_draw_velocity(2, "[M] Own velocity", l_121_4, l_121_7, 0, 0, 1)
    l_121_0:debug_draw_velocity(3, "[M] Other velocity", l_121_4, l_121_8, 1, 0, 0)
    l_121_0:debug_draw_velocity(4, "[M] Collision velocity", l_121_4, l_121_6, 0, 1, 1)
    l_121_0:debug_draw_velocity(5, "[M] Damage velocity", l_121_4, l_121_9, 0, 1, 0)
    managers.debug.gui:set_color(6, 1, 0.5, 0.5)
    managers.debug.gui:set(6, "[M] Damage: " .. tostring(l_121_11))
    managers.debug.gui:set_color(7, 0.5, 0.5, 0.5)
    managers.debug.gui:set(7, "[M] Ignored: " .. tostring(not l_121_9))
  end
end

CoreUnitDamage.debug_draw_velocity = function(l_122_0, l_122_1, l_122_2, l_122_3, l_122_4, l_122_5, l_122_6, l_122_7)
  managers.debug.gui:set_color(l_122_1, l_122_5, l_122_6, l_122_7)
  if l_122_4 then
    managers.debug.gui:set(l_122_1, string.format("%s: %g   (%g, %g, %g)", l_122_2, l_122_4:length(), l_122_4.x, l_122_4.y, l_122_4.z))
  else
    managers.debug.gui:set(l_122_1, string.format("%s: nil", l_122_2))
  end
  managers.debug.pos:set(1, l_122_3 + Vector3(0, 0, l_122_1 - 2), "debug_collision_body_" .. l_122_1 - 1, l_122_5, l_122_6, l_122_7)
   -- DECOMPILER ERROR: Confused while interpreting a jump as a 'while'

end
managers.debug.pos:set(2, l_122_3 + Vector3(0, 0, l_122_1 - 2) + Vector3(), "debug_collision_body_" .. l_122_1 - 1, l_122_5, l_122_6, l_122_7)
end

CoreUnitDamage.outside_worlds_bounding_box = function(l_123_0)
  if alive(l_123_0._unit) then
    l_123_0:kill("collision", l_123_0._unit, nil, math.UP, l_123_0._unit:position(), math.DOWN, 0, l_123_0._unit:sampled_velocity())
  end
end

CoreUnitDamage.report_enemy_killed = function(l_124_0)
  if not l_124_0._enemy_killed_reported then
    local enemy_data = l_124_0._unit:enemy_data()
    if enemy_data then
      local group = enemy_data.enemy_group
      if group then
        group:unit_killed()
        l_124_0._enemy_killed_reported = true
      end
    end
  end
end

CoreUnitDamage.kill = function(l_125_0, l_125_1, l_125_2, l_125_3, l_125_4, l_125_5, l_125_6, l_125_7, l_125_8)
  if alive(l_125_0._unit) then
    l_125_0:report_enemy_killed()
  end
end

CoreUnitDamage.remove = function(l_126_0)
  if alive(l_126_0._unit) then
    l_126_0:report_enemy_killed()
    l_126_0._unit:set_slot(0)
  end
end

CoreUnitDamage.add_inherit_destroy_unit = function(l_127_0, l_127_1)
  if not l_127_0._inherit_destroy_unit_list then
    l_127_0._inherit_destroy_unit_list = {}
  end
  table.insert(l_127_0._inherit_destroy_unit_list, l_127_1)
end

CoreUnitDamage.has_sequence = function(l_128_0, l_128_1)
  if l_128_0._unit_element then
    return l_128_0._unit_element:has_sequence(l_128_1)
  end
end

if not CoreBodyDamage then
  CoreBodyDamage = class()
end
CoreBodyDamage.init = function(l_129_0, l_129_1, l_129_2, l_129_3, l_129_4)
  l_129_0._unit = l_129_1
  l_129_0._unit_extension = l_129_2
  l_129_0._body = l_129_3
  l_129_0._body_index = l_129_0._unit:get_body_index(l_129_0._body:name())
  l_129_0._body_element = l_129_4
  l_129_0._unit_element = l_129_2:get_unit_element()
  l_129_0._endurance = {}
  l_129_0._damage = {}
  if l_129_4 then
    for k,v in pairs(l_129_4._first_endurance) do
      if k == "collision" then
        l_129_0._body:set_collision_script_tag(Idstring("core"))
      end
      l_129_0._endurance[k] = v
      l_129_0._damage[k] = 0
    end
  end
  l_129_0._inflict = {}
  l_129_0._original_inflict = {}
  l_129_0._inflict_time = {}
  l_129_0._run_exit_inflict_sequences = {}
  l_129_0._inflict_updator_map = {}
  if l_129_0._body_element then
    local inflict_element_list = l_129_0._body_element:get_inflict_element_list()
    if inflict_element_list then
      local updator_class = get_core_or_local("InflictUpdator")
      for damage_type,inflict_element in pairs(inflict_element_list) do
        local updator_type_class = updator_class.INFLICT_UPDATOR_DAMAGE_TYPE_MAP[damage_type]
        do
          if updator_type_class then
            local updator = updator_type_class:new(l_129_1, l_129_3, l_129_0, inflict_element, l_129_0._unit_element)
            if updator:is_valid() then
              l_129_0._inflict_updator_map[damage_type] = updator
            end
            for (for control),damage_type in (for generator) do
            end
            local inflict_data = {}
            l_129_0._inflict[damage_type] = inflict_data
            inflict_data.damage = inflict_element:get_damage() or 0
            inflict_data.interval = inflict_element:get_interval() or 0
            inflict_data.instant = inflict_element:get_instant()
            inflict_data.enabled = inflict_element:get_enabled()
            inflict_data = {}
            l_129_0._original_inflict[damage_type] = inflict_data
            for k,v in pairs(inflict_data) do
              inflict_data[k] = v
            end
            l_129_0._inflict_time[damage_type] = {}
            l_129_0._run_exit_inflict_sequences[damage_type] = inflict_element:exit_sequence_count() > 0
          end
        end
      end
    end
     -- Warning: missing end command somewhere! Added here
  end
end

CoreBodyDamage.set_damage = function(l_130_0, l_130_1, l_130_2)
  l_130_0._damage[l_130_1] = l_130_2
  do
    local element = l_130_0._body_element._first_endurance[l_130_1]
    repeat
      if element and element._endurance[l_130_1] <= l_130_0._damage[l_130_1] then
        element = element._next[l_130_1]
      else
        l_130_0._endurance[l_130_1] = element
      end
       -- Warning: missing end command somewhere! Added here
    end
     -- Warning: missing end command somewhere! Added here
  end
end

CoreBodyDamage.get_body = function(l_131_0)
  return l_131_0._body
end

CoreBodyDamage.get_inflict_updator_map = function(l_132_0)
  return l_132_0._inflict_updator_map
end

CoreBodyDamage.get_endurance_map = function(l_133_0)
  return l_133_0._endurance
end

CoreBodyDamage.get_inflict_time = function(l_134_0, l_134_1, l_134_2)
  return l_134_0._inflict_time[l_134_1][l_134_2]
end

CoreBodyDamage.can_inflict_damage = function(l_135_0, l_135_1, l_135_2)
  if l_135_0._inflict[l_135_1] and l_135_0._inflict[l_135_1].enabled then
    local last_time = l_135_0._inflict_time[l_135_1][l_135_2:key()]
    if TimerManager:game():time() >= last_time + l_135_0._inflict[l_135_1].interval then
      local delayed = not last_time
    end
    return not delayed, delayed
  end
  return false, false
end

CoreBodyDamage.enter_inflict_damage = function(l_136_0, l_136_1, l_136_2, l_136_3, l_136_4, l_136_5, l_136_6, l_136_7)
  local unit_key = l_136_2:key()
  local list = l_136_0._inflict_time[l_136_1]
  if not list[unit_key] then
    list[unit_key] = TimerManager:game():time()
    local damage = l_136_0._inflict[l_136_1].damage
    local env = CoreSequenceManager.SequenceEnvironment:new(l_136_1, l_136_2, l_136_0._unit, l_136_0._body, l_136_4, l_136_5, l_136_6, damage, l_136_7, nil, l_136_0._unit_element)
    l_136_0._body_element:activate_inflict_enter(env)
    return true
  else
    return false
  end
end

CoreBodyDamage.exit_inflict_damage = function(l_137_0, l_137_1, l_137_2, l_137_3, l_137_4, l_137_5, l_137_6)
  if alive(l_137_2) then
    local src_unit = l_137_2:unit()
    local unit_key = src_unit:key()
    local list = l_137_0._inflict_time[l_137_1]
    if list[unit_key] then
      list[unit_key] = nil
      if l_137_0._run_exit_inflict_sequences[l_137_1] then
        local env = CoreSequenceManager.SequenceEnvironment:new(l_137_1, src_unit, l_137_0._unit, l_137_0._body, l_137_3, l_137_4, l_137_5, 0, l_137_6, nil, l_137_0._unit_element)
        l_137_0._body_element:activate_inflict_exit(env)
      end
    end
  end
end

CoreBodyDamage.inflict_damage = function(l_138_0, l_138_1, l_138_2, l_138_3, l_138_4, l_138_5, l_138_6, l_138_7)
  local unit_key = l_138_2:key()
  l_138_0._inflict_time[l_138_1][unit_key] = TimerManager:game():time()
  local damage = l_138_0._inflict[l_138_1].damage
  local env = CoreSequenceManager.SequenceEnvironment:new(l_138_1, l_138_2, l_138_0._unit, l_138_0._body, l_138_4, l_138_5, l_138_6, damage, l_138_7, nil, l_138_0._unit_element)
  l_138_0._body_element:activate_inflict_damage(env)
  local damage_ext = l_138_3:extension().damage
  return damage_ext.damage_" .. l_138_(damage_ext, l_138_0._unit, l_138_4, l_138_5, l_138_6, damage, l_138_7)
end

CoreBodyDamage.damage_damage = function(l_139_0, l_139_1, l_139_2, l_139_3, l_139_4, l_139_5, l_139_6)
  l_139_5 = l_139_0:damage_endurance("damage", l_139_1, l_139_2, l_139_3, l_139_4, l_139_5, Vector3(0, 0, 0))
  return l_139_0._unit_extension:damage_damage(l_139_1, l_139_0._body, l_139_2, l_139_3, l_139_4, l_139_5, l_139_6)
end

CoreBodyDamage.damage_bullet = function(l_140_0, l_140_1, l_140_2, l_140_3, l_140_4, l_140_5, l_140_6)
  l_140_5 = l_140_0:damage_endurance("bullet", l_140_1, l_140_2, l_140_3, l_140_4, l_140_5, Vector3(0, 0, 0))
  return l_140_0._unit_extension:damage_bullet(l_140_1, l_140_0._body, l_140_2, l_140_3, l_140_4, l_140_5, l_140_6)
end

CoreBodyDamage.damage_lock = function(l_141_0, l_141_1, l_141_2, l_141_3, l_141_4, l_141_5, l_141_6)
  l_141_5 = l_141_0:damage_endurance("lock", l_141_1, l_141_2, l_141_3, l_141_4, l_141_5, Vector3(0, 0, 0))
  return l_141_0._unit_extension:damage_lock(l_141_1, l_141_0._body, l_141_2, l_141_3, l_141_4, l_141_5, l_141_6)
end

CoreBodyDamage.damage_explosion = function(l_142_0, l_142_1, l_142_2, l_142_3, l_142_4, l_142_5)
  l_142_5 = l_142_0:damage_endurance("explosion", l_142_1, l_142_2, l_142_3, l_142_4, l_142_5, Vector3(0, 0, 0))
  return false, 0
end

CoreBodyDamage.damage_collision = function(l_143_0, l_143_1, l_143_2, l_143_3, l_143_4, l_143_5, l_143_6)
  l_143_5 = l_143_0:damage_endurance("collision", l_143_1, l_143_2, l_143_3, l_143_4, l_143_5, l_143_6)
  return l_143_0._unit_extension:damage_collision(l_143_1, l_143_0._body, l_143_2, l_143_3, l_143_4, l_143_5, l_143_6)
end

CoreBodyDamage.damage_melee = function(l_144_0, l_144_1, l_144_2, l_144_3, l_144_4, l_144_5)
  l_144_5 = l_144_0:damage_endurance("melee", l_144_1, l_144_2, l_144_3, l_144_4, l_144_5, Vector3(0, 0, 0))
  return l_144_0._unit_extension:damage_melee(l_144_1, l_144_0._body, l_144_2, l_144_3, l_144_4, l_144_5)
end

CoreBodyDamage.damage_electricity = function(l_145_0, l_145_1, l_145_2, l_145_3, l_145_4, l_145_5)
  l_145_5 = l_145_0:damage_endurance("electricity", l_145_1, l_145_2, l_145_3, l_145_4, l_145_5, Vector3(0, 0, 0))
  return l_145_0._unit_extension:damage_electricity(l_145_1, l_145_0._body, l_145_2, l_145_3, l_145_4, l_145_5)
end

CoreBodyDamage.damage_fire = function(l_146_0, l_146_1, l_146_2, l_146_3, l_146_4, l_146_5, l_146_6)
  l_146_5 = l_146_0:damage_endurance("fire", l_146_1, l_146_2, l_146_3, l_146_4, l_146_5, l_146_6)
  return l_146_0._unit_extension:damage_fire(l_146_1, l_146_0._body, l_146_2, l_146_3, l_146_4, l_146_5, l_146_6)
end

CoreBodyDamage.damage_by_area = function(l_147_0, l_147_1, l_147_2, l_147_3, l_147_4, l_147_5, l_147_6, l_147_7)
  local damage_func = l_147_0.damage_" .. l_147_
  if damage_func then
    return damage_func(l_147_0, l_147_2, l_147_3, l_147_4, l_147_5, l_147_6, l_147_7)
  else
    Application:error("Unit \"" .. tostring(l_147_0._unit:name()) .. "\" doesn't have a \"damage_" .. tostring(l_147_1) .. "\"-function on its body damage extension.")
    return false, nil
  end
end

CoreBodyDamage.damage_effect = function(l_148_0, l_148_1, l_148_2, l_148_3, l_148_4, l_148_5, l_148_6, l_148_7)
  return l_148_0._unit_extension:damage_effect(l_148_1, l_148_2, l_148_0._body, l_148_3, l_148_4, l_148_5, l_148_6, l_148_7)
end

CoreBodyDamage.endurance_exists = function(l_149_0, l_149_1)
  return l_149_0._endurance[l_149_1] ~= nil
end

CoreBodyDamage.damage_endurance = function(l_150_0, l_150_1, l_150_2, l_150_3, l_150_4, l_150_5, l_150_6, l_150_7)
  if l_150_0._body_element then
    l_150_6 = l_150_6 * l_150_0._body_element._damage_multiplier
  end
  if l_150_0._endurance[l_150_1] then
    local env = CoreSequenceManager.SequenceEnvironment:new(l_150_1, l_150_2, l_150_0._unit, l_150_0._body, l_150_3, l_150_4, l_150_5, l_150_6, l_150_7, nil, l_150_0._unit_element)
    l_150_0._endurance[l_150_1]:damage(env)
  end
  return l_150_6
end

CoreBodyDamage.get_body_param = function(l_151_0, l_151_1)
  if l_151_0._body_element then
    return l_151_0._body_element:get_body_param(l_151_1)
  else
    return nil
  end
end

CoreBodyDamage.set_inflict_damage = function(l_152_0, l_152_1, l_152_2)
  l_152_0:set_inflict_attribute(l_152_1, "damage", l_152_2)
end

CoreBodyDamage.set_inflict_interval = function(l_153_0, l_153_1, l_153_2)
  l_153_0:set_inflict_attribute(l_153_1, "interval", l_153_2)
end

CoreBodyDamage.set_inflict_instant = function(l_154_0, l_154_1, l_154_2)
  l_154_0:set_inflict_attribute(l_154_1, "instant", l_154_2)
end

CoreBodyDamage.set_inflict_enabled = function(l_155_0, l_155_1, l_155_2)
  l_155_0:set_inflict_attribute(l_155_1, "enabled", l_155_2)
end

CoreBodyDamage.get_inflict_damage = function(l_156_0, l_156_1)
  return l_156_0:get_inflict_attribute(l_156_1, "damage")
end

CoreBodyDamage.get_inflict_interval = function(l_157_0, l_157_1)
  return l_157_0:get_inflict_attribute(l_157_1, "interval")
end

CoreBodyDamage.get_inflict_instant = function(l_158_0, l_158_1)
  return l_158_0:get_inflict_attribute(l_158_1, "instant")
end

CoreBodyDamage.get_inflict_enabled = function(l_159_0, l_159_1)
  return l_159_0:get_inflict_attribute(l_159_1, "enabled")
end

CoreBodyDamage.set_inflict_attribute = function(l_160_0, l_160_1, l_160_2, l_160_3)
  local inflict = l_160_0._inflict[l_160_1]
  if inflict then
    if l_160_3 ~= nil then
      inflict[l_160_2] = l_160_3
      return true, true
    else
      return false, true
    end
  else
    local updator = l_160_0._inflict_updator_map[l_160_1]
    if updator then
      return updator:set_attribute(l_160_2, l_160_3), true
    else
      return false, false
    end
  end
end

CoreBodyDamage.get_inflict_attribute = function(l_161_0, l_161_1, l_161_2)
  local inflict = l_161_0._inflict[l_161_1]
  if inflict then
    return inflict[l_161_2]
  else
    local updator = l_161_0._inflict_updator_map[l_161_1]
    if updator then
      return updator:get_attribute(l_161_2)
    else
       -- DECOMPILER ERROR: Confused while interpreting a jump as a 'while'

    end
    error("Tried to get " .. tostring(l_161_2) .. " on non-existing \"" .. tostring(l_161_1) .. "\"-inflict on body \"" .. tostring(l_161_0._body:name()) .. "\" that exist on unit \"" .. tostring(l_161_0._unit:name()) .. "\".")
  end
end
return nil
end

CoreBodyDamage.save = function(l_162_0, l_162_1)
  local state = {}
  local changed = false
  for k,v in pairs(l_162_0._damage) do
    if v ~= 0 then
      state.damage = table.map_copy(l_162_0._damage)
      changed = true
  else
    end
  end
  for damage_type,inflict_data in pairs(l_162_0._inflict) do
    for k,v in pairs(inflict_data) do
      if v ~= l_162_0._original_inflict[damage_type][k] then
        if not state.inflict then
          state.inflict = {}
        end
        if not state.inflict[damage_type] then
          state.inflict[damage_type] = {}
        end
        state.inflict[damage_type][k] = v
        changed = true
      end
    end
  end
  local updator_state = nil
  for damage_type,updator in pairs(l_162_0._inflict_updator_map) do
    local sub_updator_state = {}
    if updator:save(sub_updator_state) then
      if not updator_state then
        updator_state = {}
      end
      updator_state[damage_type] = sub_updator_state
      changed = true
    end
  end
  state.InflictUpdatorMap = updator_state
  if changed then
    l_162_1[l_162_0._body_index] = state
  end
  return changed
end

CoreBodyDamage.load = function(l_163_0, l_163_1)
  local state = l_163_1[l_163_0._body_index]
  if state then
    if state.damage then
      for damage_type,damage in pairs(state.damage) do
        l_163_0:set_damage(damage_type, damage)
      end
    end
    if state.inflict then
      for damage_type,inflict_data in pairs(state.inflict) do
        for k,v in pairs(state.inflict) do
          l_163_0._inflict[damage_type][k] = v
        end
      end
    end
    local updator_state = state.InflictUpdatorMap
    if updator_state then
      for damage_type,updator in pairs(l_163_0._inflict_updator_map) do
        local sub_updator_state = updator_state[damage_type]
        if sub_updator_state then
          updator:load(sub_updator_state)
        end
      end
    end
  end
end

if not CoreAfroBodyDamage then
  CoreAfroBodyDamage = class(CoreBodyDamage)
end
CoreAfroBodyDamage.init = function(l_164_0, l_164_1, l_164_2, l_164_3, l_164_4)
  CoreBodyDamage.init(l_164_0, l_164_1, l_164_2, l_164_3, l_164_4)
end

CoreAfroBodyDamage.damage_bullet = function(l_165_0, l_165_1, l_165_2, l_165_3, l_165_4, l_165_5)
  return l_165_0:damage("bullet", l_165_1, l_165_2, l_165_3, l_165_4, l_165_5, Vector3(0, 0, 0))
end

CoreAfroBodyDamage.damage_explosion = function(l_166_0, l_166_1, l_166_2, l_166_3, l_166_4, l_166_5)
  return l_166_0:damage("explosion", l_166_1, l_166_2, l_166_3, l_166_4, l_166_5, Vector3(0, 0, 0))
end

CoreAfroBodyDamage.damage_collision = function(l_167_0, l_167_1, l_167_2, l_167_3, l_167_4, l_167_5, l_167_6)
  return l_167_0:damage("collision", l_167_1, l_167_2, l_167_3, l_167_4, l_167_5, l_167_6)
end

CoreAfroBodyDamage.damage_melee = function(l_168_0, l_168_1, l_168_2, l_168_3, l_168_4, l_168_5)
  return l_168_0:damage("melee", l_168_1, l_168_2, l_168_3, l_168_4, l_168_5, Vector3(0, 0, 0))
end

CoreAfroBodyDamage.damage_electricity = function(l_169_0, l_169_1, l_169_2, l_169_3, l_169_4, l_169_5)
  return l_169_0:damage("electricity", l_169_1, l_169_2, l_169_3, l_169_4, l_169_5, Vector3(0, 0, 0))
end

CoreAfroBodyDamage.damage_fire = function(l_170_0, l_170_1, l_170_2, l_170_3, l_170_4, l_170_5, l_170_6)
  return l_170_0:damage("fire", l_170_1, l_170_2, l_170_3, l_170_4, l_170_5, l_170_6)
end

CoreAfroBodyDamage.damage = function(l_171_0, l_171_1, l_171_2, l_171_3, l_171_4, l_171_5, l_171_6, l_171_7)
  l_171_6 = l_171_0:damage_endurance(l_171_1, l_171_2, l_171_3, l_171_4, l_171_5, l_171_6, l_171_7)
  return false, 0
end

if not CoreDamageWaterCheck then
  CoreDamageWaterCheck = class()
end
CoreDamageWaterCheck.MIN_INTERVAL = 0.20000000298023
CoreDamageWaterCheck.DEFAULT_PHYSIC_EFFECT = "water_box"
CoreDamageWaterCheck.init = function(l_172_0, l_172_1, l_172_2, l_172_3, l_172_4, l_172_5, l_172_6, l_172_7, l_172_8)
  l_172_0._unit = l_172_1
  l_172_0._damage_ext = l_172_2
  l_172_0._name = l_172_3
  l_172_0._activation_callbacks_enabled = false
  l_172_0._activation_listener_enabled = false
  l_172_0._current_ref_body_depth = nil
  l_172_0:set_interval(l_172_4)
  l_172_0:set_ref_object(l_172_5)
  l_172_0:set_body_depth(l_172_7)
  l_172_0:set_ref_body(l_172_6)
  if not l_172_8 then
    l_172_0._physic_effect = l_172_0.DEFAULT_PHYSIC_EFFECT
  end
  l_172_0._body_activation_func = callback(l_172_0, l_172_0, "body_activated")
  l_172_0._water_callback_func = callback(l_172_0, l_172_0, "water_collision")
  l_172_0._check_time = TimerManager:game():time() + math.random() * l_172_0._interval
  l_172_0._enter_water = false
end

CoreDamageWaterCheck.is_valid = function(l_173_0)
  if not l_173_0._ref_object then
    return l_173_0._ref_body
  end
end

CoreDamageWaterCheck.update = function(l_174_0, l_174_1, l_174_2)
  if l_174_0._check_time <= l_174_1 and l_174_0:check_active_body() then
    local enter_water = l_174_0._in_water_check_func()
    if not l_174_0._enter_water ~= not enter_water then
      l_174_0._enter_water = enter_water
      if enter_water then
        l_174_0._damage_ext:water_check_enter(l_174_0._name, l_174_0, l_174_0:get_env_variables(enter_water))
      else
        l_174_0._damage_ext:water_check_exit(l_174_0._name, l_174_0, l_174_0:get_env_variables(enter_water))
      end
    end
  end
end

CoreDamageWaterCheck.get_env_variables = function(l_175_0, l_175_1)
   -- DECOMPILER ERROR: Confused at declaration of local variable

  if l_175_1 then
    do return end
  end
   -- DECOMPILER ERROR: Overwrote pending register.

  if l_175_0._ref_object then
    if alive(l_175_0._ref_body) then
      do return end
    end
     -- DECOMPILER ERROR: Overwrote pending register.

     -- DECOMPILER ERROR: Overwrote pending register.

   -- DECOMPILER ERROR: Overwrote pending register.

   -- DECOMPILER ERROR: Overwrote pending register.

   -- DECOMPILER ERROR: Overwrote pending register.

  else
    if alive(l_175_0._ref_body) then
      do return end
    end
     -- DECOMPILER ERROR: Overwrote pending register.

  end
   -- DECOMPILER ERROR: Confused about usage of registers!

  return l_175_0._unit, l_175_0._ref_body, Vector3(0, 0, 1), l_175_0._ref_object:position(), l_175_0._ref_body:velocity():normalized(), 0, l_175_0._ref_body:velocity(), l_175_0._ref_body:in_water()
   -- DECOMPILER ERROR: Confused about usage of registers for local variables.

end

CoreDamageWaterCheck.set_update_variables = function(l_176_0)
  if l_176_0._ref_object then
    l_176_0._in_water_check_func = callback(l_176_0, l_176_0, "is_ref_object_in_water")
  else
    if alive(l_176_0._ref_body) then
      l_176_0._in_water_check_func = callback(l_176_0, l_176_0, "is_ref_body_in_water_depth")
    end
  end
end

CoreDamageWaterCheck.check_active_body = function(l_177_0)
  l_177_0._check_time = l_177_0._check_time + l_177_0._interval
  if alive(l_177_0._ref_body) then
    l_177_0._current_ref_body_depth = l_177_0._ref_body:in_water()
  end
  local static = (l_177_0._current_ref_body_depth and not l_177_0._ref_body:dynamic())
  if l_177_0._current_ref_body_depth > 0 or static or l_177_0._ref_body:active() == l_177_0._enter_water then
    l_177_0:set_activation_listener_enabled(true)
    return false
  end
  return true
end

CoreDamageWaterCheck.set_activation_callbacks_enabled = function(l_178_0, l_178_1)
  if l_178_0._activation_callbacks_enabled ~= l_178_1 then
    l_178_0._activation_callbacks_enabled = l_178_1
    if l_178_1 then
      l_178_0._unit:add_body_activation_callback(l_178_0._body_activation_func)
      l_178_0._unit:add_water_collision_callback(l_178_0._water_callback_func)
    else
      l_178_0._unit:remove_body_activation_callback(l_178_0._body_activation_func)
      l_178_0._unit:remove_water_collision_callback(l_178_0._water_callback_func)
      l_178_0._check_time = TimerManager:game():time() + l_178_0._interval
    end
  end
end

CoreDamageWaterCheck.set_activation_listener_enabled = function(l_179_0, l_179_1)
  if l_179_0._activation_listener_enabled ~= l_179_1 then
    l_179_0._activation_listener_enabled = l_179_1
    l_179_0._damage_ext:set_water_check_active(l_179_0._name, not l_179_1)
    l_179_0:set_activation_callbacks_enabled(l_179_1)
  end
end

CoreDamageWaterCheck.is_ref_object_in_water = function(l_180_0)
  return World:in_physic_effect(l_180_0._physic_effect, l_180_0._ref_object:position())
end

CoreDamageWaterCheck.is_ref_body_in_water_depth = function(l_181_0)
  return not l_181_0._current_ref_body_depth or body_depth < l_181_0._current_ref_body_depth
end

CoreDamageWaterCheck.get_interval = function(l_182_0)
  return l_182_0._interval
end

CoreDamageWaterCheck.set_interval = function(l_183_0, l_183_1)
  if not l_183_1 then
    l_183_0._interval = math.max(l_183_0.MIN_INTERVAL, l_183_0.MIN_INTERVAL)
     -- Warning: missing end command somewhere! Added here
  end
end

CoreDamageWaterCheck.get_ref_object = function(l_184_0)
  return l_184_0._ref_object
end

CoreDamageWaterCheck.set_ref_object = function(l_185_0, l_185_1)
  l_185_0._ref_object = l_185_1
  l_185_0:set_activation_listener_enabled(false)
  l_185_0:set_update_variables()
end

CoreDamageWaterCheck.get_ref_body = function(l_186_0)
  return l_186_0._ref_body
end

CoreDamageWaterCheck.set_ref_body = function(l_187_0, l_187_1)
  l_187_0._ref_body = l_187_1
  l_187_0:set_activation_listener_enabled(false)
  if l_187_0._ref_body then
    l_187_0._ref_body_key = l_187_0._ref_body:key()
    l_187_0._ref_body:set_activate_tag("CoreDamageWaterCheck")
    l_187_0._ref_body:set_deactivate_tag("CoreDamageWaterCheck")
    local water_tag = l_187_0._ref_body:enter_water_script_tag()
    if not water_tag or #water_tag == 0 then
      water_tag = "CoreDamageWaterCheck"
    end
    l_187_0._ref_body:set_enter_water_script_tag(water_tag)
    l_187_0._ref_body:set_exit_water_script_tag("CoreDamageWaterCheck")
    l_187_0._ref_body:set_enter_water_script_filter(0)
    l_187_0._ref_body:set_exit_water_script_filter(0)
  end
  l_187_0:set_update_variables()
end

CoreDamageWaterCheck.get_body_depth = function(l_188_0)
  return l_188_0._body_depth
end

CoreDamageWaterCheck.set_body_depth = function(l_189_0, l_189_1)
  l_189_0._body_depth = math.max(l_189_1 or 0, 0)
end

CoreDamageWaterCheck.water_collision = function(l_190_0, l_190_1, l_190_2, l_190_3, l_190_4, l_190_5, l_190_6, l_190_7, l_190_8)
  if not l_190_5 ~= not l_190_0._enter_water and l_190_3:key() == l_190_0._ref_body_key then
    l_190_0:set_activation_listener_enabled(false)
  end
end

CoreDamageWaterCheck.body_activated = function(l_191_0, l_191_1, l_191_2, l_191_3, l_191_4)
  if l_191_4 and l_191_3:key() == l_191_0._ref_body_key then
    l_191_0:set_activation_listener_enabled(false)
  end
end

CoreDamageWaterCheck.to_string = function(l_192_0)
  return string.format("[Unit: %s, Name: %s, Enabled: %s, Interval: %g, Object: %s, Body: %s, Body depth: %g]", l_192_0._unit:name(), l_192_0._name, tostring(l_192_0._damage_ext:is_water_check_active(l_192_0._name)), l_192_0._interval, tostring(alive(l_192_0._ref_object) and l_192_0._ref_object:name() or nil), tostring(alive(l_192_0._ref_body) and l_192_0._ref_body:name() or nil), l_192_0._body_depth)
end

if not CoreInflictUpdator then
  CoreInflictUpdator = class()
end
if not CoreInflictUpdator.INFLICT_UPDATOR_DAMAGE_TYPE_MAP then
  CoreInflictUpdator.INFLICT_UPDATOR_DAMAGE_TYPE_MAP = {}
end
CoreInflictUpdator.MIN_INTERVAL = 0.20000000298023
CoreInflictUpdator.init = function(l_193_0, l_193_1, l_193_2, l_193_3, l_193_4, l_193_5)
  l_193_0._unit = l_193_1
  l_193_0._body = l_193_2
  l_193_0._body_damage_ext = l_193_3
  l_193_0._inflict_element = l_193_4
  l_193_0._unit_element = l_193_5
  l_193_0._update_func = callback(l_193_0, l_193_0, "update")
  l_193_0:set_damage(l_193_4:get_damage() or 0)
  l_193_0:set_interval(l_193_4:get_interval() or 1)
  l_193_0:set_instant(l_193_4:get_instant())
  l_193_0:set_enabled(l_193_4:get_enabled())
  l_193_0._original_damage = l_193_0._damage
  l_193_0._original_interval = l_193_0._interval
  l_193_0._original_instant = l_193_0._instant
  l_193_0._original_enabled = l_193_0._enabled
  l_193_0._check_time = TimerManager:game():time() + l_193_0._interval * math.random()
  l_193_0._is_inflicting = false
  l_193_0._set_attribute_func_map = {}
  l_193_0._set_attribute_func_map.damage = callback(l_193_0, l_193_0, "set_damage")
  l_193_0._set_attribute_func_map.interval = callback(l_193_0, l_193_0, "set_interval")
  l_193_0._set_attribute_func_map.instant = callback(l_193_0, l_193_0, "set_instant")
  l_193_0._set_attribute_func_map.enabled = callback(l_193_0, l_193_0, "set_enabled")
  l_193_0._get_attribute_func_map = {}
  l_193_0._get_attribute_func_map.damage = function()
    return self._damage
   end
  l_193_0._get_attribute_func_map.interval = function()
    return self._interval
   end
  l_193_0._get_attribute_func_map.instant = function()
    return self._instant
   end
  l_193_0._get_attribute_func_map.enabled = function()
    return self._enabled
   end
end

CoreInflictUpdator.is_valid = function(l_194_0)
  return true
end

CoreInflictUpdator.set_damage = function(l_195_0, l_195_1)
  if not l_195_1 then
    l_195_0._damage = l_195_0._damage
  end
end

CoreInflictUpdator.set_interval = function(l_196_0, l_196_1)
  local old_interval = l_196_0._interval
  if not l_196_1 then
    l_196_0._interval = math.max(l_196_0._interval, l_196_0.MIN_INTERVAL)
    if old_interval then
      l_196_0._check_time = math.clamp(l_196_0._check_time, l_196_0._check_time - old_interval, TimerManager:game():time() + l_196_0._interval)
    end
     -- Warning: missing end command somewhere! Added here
  end
end

CoreInflictUpdator.set_instant = function(l_197_0, l_197_1)
  l_197_0._instant = not not l_197_1
end

CoreInflictUpdator.set_enabled = function(l_198_0, l_198_1)
  l_198_1 = not not l_198_1
  if l_198_0._enabled ~= l_198_1 then
    l_198_0._enabled = l_198_1
    if l_198_1 then
      l_198_0._id = managers.sequence:add_callback(l_198_0._update_func)
    elseif l_198_0._id then
      managers.sequence:remove_callback(l_198_0._id)
      l_198_0._id = nil
    end
  end
end

CoreInflictUpdator.save = function(l_199_0, l_199_1)
  local state = {}
  local changed = false
  if l_199_0._original_damage ~= l_199_0._damage then
    state.damage = l_199_0._damage
    changed = true
  end
  if l_199_0._original_interval ~= l_199_0._interval then
    state.interval = l_199_0._interval
    changed = true
  end
  if not l_199_0._original_instant ~= not l_199_0._instant then
    state.instant = l_199_0._instant
    changed = true
  end
  if not l_199_0._original_enabled ~= not l_199_0._enabled then
    state.enabled = l_199_0._enabled
    changed = true
  end
  if changed then
    l_199_1.CoreInflictUpdator = state
  end
  return changed
end

CoreInflictUpdator.load = function(l_200_0, l_200_1)
  local state = l_200_1.CoreInflictUpdator
  if state then
    if not state.damage then
      l_200_0._damage = l_200_0._damage
    end
    if not state.interval then
      l_200_0._interval = l_200_0._interval
    end
    if state.instant ~= nil then
      l_200_0:set_instant(state.instant)
    end
    if state.enabled ~= nil then
      l_200_0:set_enabled(state.enabled)
    end
  end
end

CoreInflictUpdator.update = function(l_201_0, l_201_1, l_201_2)
  if l_201_0._check_time <= l_201_1 then
    if alive(l_201_0._unit) then
      l_201_0._check_time = l_201_0._check_time + l_201_0._interval
      l_201_0:check_damage(l_201_1, l_201_2)
    else
      l_201_0:set_enabled(false)
    end
  end
end

CoreInflictUpdator.set_attribute = function(l_202_0, l_202_1, l_202_2)
  if l_202_2 ~= nil then
    local func = l_202_0._set_attribute_func_map[l_202_1]
    if func then
      func(l_202_2)
      return true
    end
  end
  return false
end

CoreInflictUpdator.get_attribute = function(l_203_0, l_203_1)
  if l_203_1 then
    local func = l_203_0._get_attribute_func_map[l_203_1]
    if func then
      return func()
    end
  end
   -- DECOMPILER ERROR: Confused while interpreting a jump as a 'while'

end
error("Tried to get non existing attribute \"" .. tostring(l_203_1) .. "\" on body \"" .. tostring(l_203_0._body:name()) .. "\" that exist on unit \"" .. tostring(l_203_0._unit:name()) .. "\".")
return nil
end

if not CoreInflictFireUpdator then
  CoreInflictFireUpdator = class(CoreInflictUpdator)
end
CoreInflictUpdator.INFLICT_UPDATOR_DAMAGE_TYPE_MAP.fire = CoreInflictFireUpdator
CoreInflictFireUpdator.SPHERE_CHECK_SLOTMASK = "fire_damage"
CoreInflictFireUpdator.SPHERE_CHECK_PADDING = 200
CoreInflictFireUpdator.DAMAGE_TYPE = "fire"
CoreInflictFireUpdator.init = function(l_204_0, l_204_1, l_204_2, l_204_3, l_204_4, l_204_5)
  CoreInflictUpdator.init(l_204_0, l_204_1, l_204_2, l_204_3, l_204_4, l_204_5)
  l_204_0._slotmask = managers.slot:get_mask(l_204_0.SPHERE_CHECK_SLOTMASK)
  if not l_204_0._inflict_element:get_velocity() then
    l_204_0._velocity = Vector3()
  end
  l_204_0._falloff = l_204_0._inflict_element:get_falloff()
  l_204_0._fire_height = math.max(l_204_4:get_fire_height() or 0, 0)
  l_204_0._original_fire_object_name = l_204_4:get_fire_object_name()
  l_204_0:set_fire_object_name(l_204_0._original_fire_object_name)
  l_204_0._original_velocity = l_204_0._velocity
  l_204_0._original_falloff = l_204_0._falloff
  l_204_0._original_fire_height = l_204_0._fire_height
  local enter_element = l_204_4:get_enter_element()
  if enter_element then
    l_204_0._enter_element_func = callback(enter_element, enter_element, "activate")
  end
  local exit_element = l_204_4:get_exit_element()
  if exit_element then
    l_204_0._exit_element_func = callback(exit_element, exit_element, "activate")
  end
  local damage_element = l_204_4:get_damage_element()
  if damage_element then
    l_204_0._damage_element_func = callback(damage_element, damage_element, "activate")
  end
  l_204_0._set_attribute_func_map.fire_object = callback(l_204_0, l_204_0, "set_fire_object_name")
  l_204_0._set_attribute_func_map.fire_height = callback(l_204_0, l_204_0, "set_fire_height")
  l_204_0._set_attribute_func_map.velocity = callback(l_204_0, l_204_0, "set_velocity")
  l_204_0._set_attribute_func_map.falloff = callback(l_204_0, l_204_0, "set_falloff")
  l_204_0._get_attribute_func_map.fire_object = function()
    return self._fire_object
   end
  l_204_0._get_attribute_func_map.fire_height = function()
    return self._fire_height
   end
  l_204_0._get_attribute_func_map.velocity = function()
    return self._velocity
   end
  l_204_0._get_attribute_func_map.falloff = function()
    return self._falloff
   end
end

CoreInflictFireUpdator.is_valid = function(l_205_0)
  return not CoreInflictUpdator.is_valid(l_205_0) or l_205_0._fire_object ~= nil
end

CoreInflictFireUpdator.set_fire_object_name = function(l_206_0, l_206_1)
  if l_206_1 then
    l_206_0._fire_object = l_206_0._unit:get_object(Idstring(l_206_1))
  end
  if not l_206_0._fire_object then
    l_206_0:set_enabled(false)
    Application:error("Invalid inflict fire element object \"" .. tostring(l_206_1) .. "\".")
    l_206_0._body_damage_ext:get_inflict_updator_map()[l_206_0.DAMAGE_TYPE] = nil
    return 
  end
  l_206_0:set_fire_height(l_206_0._fire_height)
end

CoreInflictFireUpdator.set_fire_height = function(l_207_0, l_207_1)
  l_207_0._fire_height = l_207_1
  l_207_0._sphere_check_range = l_207_0._fire_object:oobb():size() / 2:length() + l_207_0._fire_height + l_207_0.SPHERE_CHECK_PADDING
end

CoreInflictFireUpdator.set_velocity = function(l_208_0, l_208_1)
  l_208_0._velocity = l_208_1
end

CoreInflictFireUpdator.set_falloff = function(l_209_0, l_209_1)
  l_209_0._falloff = l_209_1
end

CoreInflictFireUpdator.save = function(l_210_0, l_210_1)
  local state = {}
  local changed = CoreInflictUpdator.save(l_210_0, l_210_1)
  if l_210_0._original_fire_object_name ~= l_210_0._fire_object:name() then
    state.fire_object_name = l_210_0._fire_object:name()
    changed = true
  end
  if l_210_0._original_velocity ~= l_210_0._velocity then
    state.velocity = l_210_0._velocity
    changed = true
  end
  if l_210_0._original_falloff ~= l_210_0._falloff then
    state.falloff = l_210_0._falloff
    changed = true
  end
  if l_210_0._original_fire_height ~= l_210_0._fire_height then
    state.fire_height = l_210_0._fire_height
    changed = true
  end
  if changed then
    l_210_1.CoreInflictFireUpdator = state
  end
  return changed
end

CoreInflictFireUpdator.load = function(l_211_0, l_211_1)
  CoreInflictUpdator.load(l_211_0, l_211_1)
  local state = l_211_1.CoreInflictUpdator
  if state then
    if state.fire_object_name then
      l_211_0:set_fire_object_name(state.fire_object_name)
    end
    if state.fire_height then
      l_211_0:set_fire_height(state.fire_height)
    end
    if not state.velocity then
      l_211_0._velocity = l_211_0._velocity
    end
    if not state.falloff then
      l_211_0._falloff = l_211_0._falloff
    end
  end
end

CoreInflictFireUpdator.check_damage = function(l_212_0, l_212_1, l_212_2)
  local oobb = l_212_0._fire_object:oobb()
  local oobb_center = oobb:center()
  local unit_list = (l_212_0._unit:find_units_quick("sphere", oobb_center, l_212_0._sphere_check_range, l_212_0._slotmask))
  local inflicted_damage, exit_inflict_env = nil, nil
  for _,unit in ipairs(unit_list) do
    local unit_key = unit:key()
    local inflict_body_map = managers.sequence:get_inflict_updator_body_map(l_212_0.DAMAGE_TYPE, unit_key)
    if inflict_body_map then
      for body_key,body_ext in pairs(inflict_body_map) do
        local body = body_ext:get_body()
        if alive(body) then
          local body_center = body:center_of_mass()
          local distance = (oobb:principal_distance(body:oobb()))
          local position, normal = nil, nil
          local direction = (oobb_center - body_center:normalized())
          do
            local damage = nil
            if distance > 0 then
              position, normal = oobb:raycast(body_center, body_center - Vector3(0, 0, l_212_0._fire_height))
              if position then
                if l_212_0._falloff and l_212_0._fire_height > 0 then
                  damage = l_212_0._damage * math.clamp(1 - distance / l_212_0._fire_height, 0, 1)
                else
                  damage = l_212_0._damage
                end
              else
                position, normal = body_center, -direction
                damage = l_212_0._damage
              end
              do
                if position then
                  local was_inflicting = l_212_0._is_inflicting
                  inflicted_damage = true
                  if not l_212_0._is_inflicting then
                    l_212_0._is_inflicting = true
                    if l_212_0._enter_element_func then
                      local env = CoreSequenceManager.SequenceEnvironment:new(l_212_0.DAMAGE_TYPE, unit, l_212_0._unit, l_212_0._body, normal, position, direction, damage, l_212_0._velocity, {distance = distance}, l_212_0._unit_element)
                      l_212_0._enter_element_func(env)
                    end
                  end
                  if was_inflicting or l_212_0._instant then
                    if l_212_0._damage_element_func then
                      local env = CoreSequenceManager.SequenceEnvironment:new(l_212_0.DAMAGE_TYPE, unit, l_212_0._unit, l_212_0._body, normal, position, direction, damage, l_212_0._velocity, {distance = distance}, l_212_0._unit_element)
                      l_212_0._damage_element_func(env)
                    end
                    body_ext:damage_fire(l_212_0._unit, normal, position, direction, damage, l_212_0._velocity)
                  end
                  for (for control),body_key in (for generator) do
                  end
                  if l_212_0._exit_element_func and not exit_inflict_env then
                    exit_inflict_env = CoreSequenceManager.SequenceEnvironment:new(l_212_0.DAMAGE_TYPE, unit, l_212_0._unit, l_212_0._body, -direction, body_center, direction, damage, l_212_0._velocity, {distance = distance}, l_212_0._unit_element)
                  end
                  for (for control),body_key in (for generator) do
                  end
                  managers.sequence:remove_inflict_updator_body(l_212_0.DAMAGE_TYPE, unit_key, body_key)
                end
              end
            end
          end
        end
        if not inflicted_damage and l_212_0._is_inflicting then
          l_212_0._is_inflicting = false
          if exit_inflict_env then
            l_212_0._exit_element_func(exit_inflict_env)
          end
        end
         -- Warning: missing end command somewhere! Added here
      end
       -- Warning: missing end command somewhere! Added here
    end
     -- Warning: missing end command somewhere! Added here
  end
end


