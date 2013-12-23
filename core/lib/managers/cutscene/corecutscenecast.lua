-- Decompiled using luadec 2.0.1 by sztupy (http://winmo.sztupy.hu)
-- Command line was: F:\SteamLibrary\SteamApps\common\PAYDAY 2\lua\core\lib\managers\cutscene\corecutscenecast.luac 

if not CoreCutsceneCast then
  CoreCutsceneCast = class()
end
CoreCutsceneCast.prime = function(l_1_0, l_1_1)
  if l_1_1 then
    assert(l_1_1:is_valid(), "Attempting to prime invalid cutscene.")
  end
  local preload = true
  l_1_0:_actor_units_in_cutscene(l_1_1)
  l_1_0:_animation_blob_controller(l_1_1, preload)
end

CoreCutsceneCast.unload = function(l_2_0)
  if not l_2_0._animation_blob_controllers then
    for _,blob_controller in pairs({}) do
    end
    if blob_controller ~= false and alive(blob_controller) then
      if blob_controller:is_playing() then
        blob_controller:stop()
      end
      blob_controller:destroy()
    end
  end
  l_2_0._animation_blob_controllers = nil
  if not l_2_0._spawned_units then
    for _,unit in pairs({}) do
    end
    if alive(unit) then
      local unit_type = unit:name()
      World:delete_unit(unit)
    end
  end
  l_2_0._spawned_units = nil
  if alive(l_2_0.__root_unit) then
    World:delete_unit(l_2_0.__root_unit)
  end
  l_2_0.__root_unit = nil
end

CoreCutsceneCast.is_ready = function(l_3_0, l_3_1)
  if l_3_1 then
    local blob_controller = l_3_0:_animation_blob_controller(l_3_1)
  end
  return (blob_controller ~= nil and blob_controller:ready())
end

CoreCutsceneCast.set_timer = function(l_4_0, l_4_1)
  if not l_4_0._spawned_units then
    for _,unit in pairs({}) do
    end
    if alive(unit) then
      unit:set_timer(l_4_1)
      unit:set_animation_timer(l_4_1)
    end
  end
end

CoreCutsceneCast.set_cutscene_visible = function(l_5_0, l_5_1, l_5_2)
  if not l_5_0._spawned_units then
    for unit_name,unit in pairs({}) do
    end
    if l_5_1:has_unit(unit_name, true) and l_5_2 then
      l_5_0:_set_unit_and_children_visible(unit, l_5_0:unit_visible(unit_name))
    end
  end
end

CoreCutsceneCast.set_unit_visible = function(l_6_0, l_6_1, l_6_2)
  l_6_2 = not not l_6_2
  if not l_6_0._hidden_units then
    l_6_0._hidden_units = {}
  end
  local current_visibility = not l_6_0._hidden_units[l_6_1]
  l_6_0._hidden_units[l_6_1] = (l_6_2 and nil)
  local unit = l_6_0:unit(l_6_1)
  if unit then
    l_6_0:_set_unit_and_children_visible(unit, l_6_2)
  end
end

CoreCutsceneCast.unit_visible = function(l_7_0, l_7_1)
  return l_7_0._hidden_units and l_7_0._hidden_units[l_7_1] == nil
end

CoreCutsceneCast.unit = function(l_8_0, l_8_1)
  if l_8_0._spawned_units then
    return l_8_0._spawned_units[l_8_1]
  end
end

CoreCutsceneCast.actor_unit = function(l_9_0, l_9_1, l_9_2)
  local unit = l_9_0:unit(l_9_1)
  if unit and l_9_2:has_unit(l_9_1) then
    return unit
  else
    return l_9_0:_actor_units_in_cutscene(l_9_2)[l_9_1]
  end
end

CoreCutsceneCast.unit_names = function(l_10_0)
  if not l_10_0._spawned_units or not table.map_keys(l_10_0._spawned_units) then
    return {}
  end
end

CoreCutsceneCast.evaluate_cutscene_at_time = function(l_11_0, l_11_1, l_11_2)
  l_11_0._last_evaluated_cutscene = l_11_0._last_evaluated_cutscene or l_11_1
  if l_11_1 ~= l_11_0._last_evaluated_cutscene then
    l_11_0:_stop_animations_on_actor_units_in_cutscene(l_11_0._last_evaluated_cutscene)
  end
  local orientation_unit = l_11_1:find_spawned_orientation_unit()
  if orientation_unit and l_11_0:_root_unit():parent() ~= orientation_unit then
    l_11_0:_reparent_to_locator_unit(orientation_unit, l_11_0:_root_unit())
  end
  local blob_controller = l_11_0:_animation_blob_controller(l_11_1)
  if blob_controller and blob_controller:ready() then
    if not blob_controller:is_playing() then
      local actor_units = l_11_0:_actor_units_in_cutscene(l_11_1)
      local blend_sets = table.remap(actor_units, function(l_1_0)
        return l_1_0, cutscene:blend_set_for_unit(l_1_0)
         end)
      blob_controller:play(actor_units, blend_sets)
      blob_controller:pause()
    end
    blob_controller:set_time(l_11_2)
    do return end
    for unit_name,unit in pairs(l_11_0:_actor_units_in_cutscene(l_11_1)) do
      local unit_animation = l_11_1:animation_for_unit(unit_name)
      if unit_animation then
        local machine = unit:anim_state_machine()
        if not machine:enabled() then
          machine:set_enabled(true)
          if not l_11_0:_state_machine_is_playing_raw_animation(machine, unit_animation) then
            machine:play_raw(unit_animation)
          end
        end
        local anim_length = l_11_1:duration()
        if anim_length ~= 0 or not 0 then
          local normalized_time = l_11_2 / anim_length
        end
        machine:set_parameter(unit_animation, "t", normalized_time)
      end
    end
  end
  l_11_0._last_evaluated_cutscene = l_11_1
end

CoreCutsceneCast.evaluate_object_at_time = function(l_12_0, l_12_1, l_12_2, l_12_3, l_12_4)
  assert(l_12_1:is_optimized(), "Currently only supported with optimized cutscenes.")
  local blob_controller = l_12_0:_animation_blob_controller(l_12_1)
  if alive(blob_controller) and blob_controller:ready() and blob_controller:is_playing() then
    local bone_name = l_12_2 .. l_12_3
    return blob_controller:position(bone_name, l_12_4), blob_controller:rotation(bone_name, l_12_4)
  else
    return Vector3(0, 0, 0), Rotation()
  end
end

CoreCutsceneCast.spawn_unit = function(l_13_0, l_13_1, l_13_2)
  if DB:has("unit", l_13_2) then
    cat_print("cutscene", string.format("[CoreCutsceneCast] Spawning \"%s\" named \"%s\".", l_13_2, l_13_1))
    World:effect_manager():set_spawns_enabled(false)
    local unit = safe_spawn_unit(l_13_2, Vector3(0, 0, 0), Rotation())
    World:effect_manager():set_spawns_enabled(true)
    unit:set_timer(managers.cutscene:timer())
    unit:set_animation_timer(managers.cutscene:timer())
    l_13_0:_reparent_to_locator_unit(l_13_0:_root_unit(), unit)
    l_13_0:_set_unit_and_children_visible(unit, false)
    unit:set_animation_lod(1, 100000, 10000000, 10000000)
    if unit:cutscene() and unit:cutscene().setup then
      unit:cutscene():setup()
    end
    if unit:anim_state_machine() then
      unit:anim_state_machine():set_enabled(false)
    end
    managers.cutscene:actor_database():append_unit_info(unit)
    if not l_13_0._spawned_units then
      l_13_0._spawned_units = {}
    end
    l_13_0._spawned_units[l_13_1] = unit
    return unit
  else
    error("Unit type \"" .. tostring(l_13_2) .. "\" not found.")
  end
end

CoreCutsceneCast.delete_unit = function(l_14_0, l_14_1)
  local unit = l_14_0:unit(l_14_1)
  if unit and alive(unit) then
    local unit_type = unit:name()
    World:delete_unit(unit)
  end
  if l_14_0._spawned_units then
    l_14_0._spawned_units[l_14_1] = nil
  end
  if l_14_0._hidden_units then
    l_14_0._hidden_units[l_14_1] = nil
  end
  return unit ~= nil
end

CoreCutsceneCast.rename_unit = function(l_15_0, l_15_1, l_15_2)
  local unit = l_15_0:unit(l_15_1)
  if unit then
    l_15_0._spawned_units[l_15_1] = nil
    l_15_0._spawned_units[l_15_2] = unit
    if l_15_0._hidden_units and l_15_0._hidden_units[l_15_1] then
      l_15_0._hidden_units[l_15_1] = nil
      l_15_0._hidden_units[l_15_2] = true
    end
    return true
  end
  return false
end

CoreCutsceneCast._stop_animations_on_actor_units_in_cutscene = function(l_16_0, l_16_1)
  local blob_controller = l_16_0:_animation_blob_controller(l_16_1)
  if blob_controller then
    blob_controller:stop()
  else
    for unit_name,unit in pairs(l_16_0:_actor_units_in_cutscene(l_16_1)) do
      local machine = unit:anim_state_machine()
      if machine then
        machine:set_enabled(false)
      end
    end
  end
end

CoreCutsceneCast._state_machine_is_playing_raw_animation = function(l_17_0, l_17_1, l_17_2)
  local state_names = table.collect(l_17_1:config():states(), function(l_1_0)
    return l_1_0:name()
   end)
  if table.contains(state_names, l_17_2) then
    return l_17_1:is_playing(l_17_2)
  end
end

CoreCutsceneCast._reparent_to_locator_unit = function(l_18_0, l_18_1, l_18_2)
  local parent_locator = assert(l_18_1:get_object("locator"), "Parent does not have an Object named \"locator\".")
  l_18_2:unlink()
  l_18_1:link(parent_locator:name(), l_18_2, l_18_2:orientation_object():name())
end

CoreCutsceneCast._set_unit_and_children_visible = function(l_19_0, l_19_1, l_19_2, l_19_3)
  l_19_1:set_visible(l_19_2)
  l_19_1:set_enabled(l_19_2)
  if not l_19_3 then
    if not l_19_0._spawned_units then
      l_19_3 = table.remap({}, function(l_1_0, l_1_1)
    return l_1_1, true
   end)
    end
    for _,child in ipairs(l_19_1:children()) do
      if not l_19_3[child] then
        l_19_0:_set_unit_and_children_visible(child, l_19_2, l_19_3)
      end
    end
     -- Warning: missing end command somewhere! Added here
  end
end

CoreCutsceneCast._animation_blob_controller = function(l_20_0, l_20_1, l_20_2)
  if l_20_1:animation_blobs() == nil then
    return nil
  end
  if not l_20_0._animation_blob_controllers then
    l_20_0._animation_blob_controllers = {}
  end
  local blob_controller = l_20_0._animation_blob_controllers[l_20_1]
  if blob_controller == nil then
    if not l_20_2 then
      Application:error("The cutscene \"" .. l_20_1:name() .. "\" was not preloaded, causing a performance spike.")
    end
    blob_controller = CutScene:load(l_20_1:animation_blobs())
    l_20_0._animation_blob_controllers[l_20_1] = blob_controller
  end
  return blob_controller
end

CoreCutsceneCast._actor_units_in_cutscene = function(l_21_0, l_21_1)
  if not l_21_0._spawned_units then
    l_21_0._spawned_units = {}
  end
  local result = {}
  for unit_name,unit_type in pairs(l_21_1:controlled_unit_types()) do
    local unit = l_21_0._spawned_units[unit_name]
    if unit == nil then
      unit = l_21_0:spawn_unit(unit_name, unit_type)
    else
      if not alive(unit) then
        cat_print("debug", string.format("[CoreCutsceneCast] Zombie Unit detected! Actor \"%s\" of unit type \"%s\" in cutscene \"%s\".", unit_name, unit_type, l_21_1:name()))
        unit = nil
      else
        assert(unit:name() == unit_type, "Named unit type mismatch.")
      end
    end
    result[unit_name] = unit
  end
  return result
end

CoreCutsceneCast._root_unit = function(l_22_0)
  if l_22_0.__root_unit == nil then
    l_22_0.__root_unit = World:spawn_unit(Idstring("core/units/locator/locator"), Vector3(0, 0, 0), Rotation())
  end
  return l_22_0.__root_unit
end


