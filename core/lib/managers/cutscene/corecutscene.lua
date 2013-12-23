-- Decompiled using luadec 2.0.1 by sztupy (http://winmo.sztupy.hu)
-- Command line was: F:\SteamLibrary\SteamApps\common\PAYDAY 2\lua\core\lib\managers\cutscene\corecutscene.luac 

require("core/lib/managers/cutscene/CoreCutsceneKeys")
require("core/lib/managers/cutscene/CoreCutsceneKeyCollection")
if not CoreCutscene then
  CoreCutscene = frozen_class()
end
mixin(CoreCutscene, CoreCutsceneKeyCollection)
local CUTSCENE_FRAMES_PER_SECOND = 30
CoreCutscene._all_keys_sorted_by_time = function(l_1_0)
  if not l_1_0._keys then
    return {}
  end
end

CoreCutscene.init = function(l_2_0, l_2_1, l_2_2)
  assert(l_2_1, "No cutscene XML node supplied.")
  assert(l_2_2, "Must supply a reference to the CutsceneManager.")
  l_2_0._name = l_2_1:parameter("name")
  l_2_0._unit_name = l_2_1:parameter("unit")
  l_2_0._frame_count = tonumber(l_2_1:parameter("frames"))
  l_2_0._keys = {}
  l_2_0._unit_types = {}
  l_2_0._unit_animations = {}
  l_2_0._unit_blend_sets = {}
  l_2_0._camera_names = {}
  l_2_0._animation_blobs = l_2_0:_parse_animation_blobs(l_2_1)
  for collection_node in l_2_1:children() do
    if collection_node:name() == "controlled_units" then
      for child_node in collection_node:children() do
        local unit_name = child_node:parameter("name")
        l_2_0._unit_types[unit_name] = l_2_2:cutscene_actor_unit_type(l_2_0:_cutscene_specific_unit_type(child_node:parameter("type")))
        l_2_0._unit_animations[unit_name] = child_node:parameter("animation")
        l_2_0._unit_blend_sets[unit_name] = child_node:parameter("blend_set")
        if string.begins(unit_name, "camera") then
          table.insert(l_2_0._camera_names, unit_name)
        end
      end
      for (for control) in (for generator) do
      end
      if collection_node:name() == "keys" then
        for child_node in collection_node:children() do
          local cutscene_key = CoreCutsceneKey:create(child_node:name(), l_2_0)
          cutscene_key:load(child_node)
          table.insert(l_2_0._keys, freeze(cutscene_key))
        end
      end
    end
    table.sort(l_2_0._camera_names)
    table.sort(l_2_0._keys, function(l_1_0, l_1_1)
      return l_1_0:frame() < l_1_1:frame()
      end)
    freeze(l_2_0._keys, l_2_0._unit_types, l_2_0._unit_animations, l_2_0._unit_blend_sets, l_2_0._camera_names)
     -- Warning: missing end command somewhere! Added here
  end
end

CoreCutscene.is_valid = function(l_3_0)
  if not table.empty(l_3_0._unit_types) then
    return DB:has("unit", l_3_0:unit_name())
  end
end

CoreCutscene.name = function(l_4_0)
  return l_4_0._name or ""
end

CoreCutscene.unit_name = function(l_5_0)
  return l_5_0._unit_name or ""
end

CoreCutscene.frames_per_second = function(l_6_0)
  return CUTSCENE_FRAMES_PER_SECOND
end

CoreCutscene.frame_count = function(l_7_0)
  return l_7_0._frame_count or 1
end

CoreCutscene.duration = function(l_8_0)
  return l_8_0:frame_count() / l_8_0:frames_per_second()
end

CoreCutscene.is_optimized = function(l_9_0)
  return table.empty(l_9_0._unit_animations)
end

CoreCutscene.has_cameras = function(l_10_0)
  return not table.empty(l_10_0._camera_names)
end

CoreCutscene.has_unit = function(l_11_0, l_11_1, l_11_2)
  if l_11_0:controlled_unit_types()[l_11_1] ~= nil then
    return true
  end
  if l_11_2 then
    for spawn_key in l_11_0:keys(CoreSpawnUnitCutsceneKey.ELEMENT_NAME) do
      if spawn_key:name() == l_11_1 then
        return true
      end
    end
  end
  return false
end

CoreCutscene.controlled_unit_types = function(l_12_0)
  return l_12_0._unit_types
end

CoreCutscene.camera_names = function(l_13_0)
  return l_13_0._camera_names
end

CoreCutscene.default_camera = function(l_14_0)
  for _,name in ipairs(l_14_0:camera_names()) do
    return name
  end
end

CoreCutscene.objects_in_unit = function(l_15_0, l_15_1)
  return l_15_0:_actor_database_info(l_15_1):object_names()
end

CoreCutscene.extensions_on_unit = function(l_16_0, l_16_1)
  return l_16_0:_actor_database_info(l_16_1):extensions()
end

CoreCutscene.animation_for_unit = function(l_17_0, l_17_1)
  return l_17_0._unit_animations[l_17_1]
end

CoreCutscene.blend_set_for_unit = function(l_18_0, l_18_1)
  return l_18_0._unit_blend_sets[l_18_1] or "all"
end

CoreCutscene.animation_blobs = function(l_19_0)
  return l_19_0._animation_blobs
end

CoreCutscene.find_spawned_orientation_unit = function(l_20_0)
  local spawned_cutscene_units = World:unit_manager():get_units(managers.slot:get_mask("cutscenes"))
  for _,unit in ipairs(spawned_cutscene_units) do
    if unit:name() == l_20_0:unit_name() then
      return unit
    end
  end
end

CoreCutscene._parse_animation_blobs = function(l_21_0, l_21_1)
  if not l_21_0:_parse_animation_blob_list(l_21_1) then
    return l_21_0:_parse_single_animation_blob(l_21_1)
  end
end

CoreCutscene._parse_animation_blob_list = function(l_22_0, l_22_1)
  for collection_node in l_22_1:children() do
    if collection_node:name() == "animation_blobs" then
      local animation_blobs = {}
      for animation_blob_node in collection_node:children() do
        local value = animation_blob_node:name() == "part" and animation_blob_node:parameter("animation_blob") or nil
        if value then
          table.insert(animation_blobs, value)
        end
      end
      return animation_blobs
    end
  end
  return nil
end

CoreCutscene._parse_single_animation_blob = function(l_23_0, l_23_1)
  for collection_node in l_23_1:children() do
    if collection_node:name() == "controlled_units" then
      local animation_blob = collection_node:parameter("animation_blob")
      if animation_blob then
        return {animation_blob}
      end
    end
  end
  return nil
end

CoreCutscene._actor_database_info = function(l_24_0, l_24_1)
  local unit_type = assert(l_24_0:controlled_unit_types()[l_24_1], string.format("Unit \"%s\" is not in cutscene \"%s\".", l_24_1, l_24_0:name()))
  local unit_info = assert(managers.cutscene:actor_database():unit_type_info(unit_type), string.format("Unit type \"%s\", used in cutscene \"%s\", is not registered in the actor database.", unit_type, l_24_0:name()))
  return unit_info
end

CoreCutscene._cutscene_specific_unit_type = function(l_25_0, l_25_1)
  if l_25_1 ~= "locator" and DB:has("unit", l_25_1 .. "_cutscene") then
    l_25_1 = l_25_1 .. "_cutscene"
  end
  return l_25_1
end

CoreCutscene._debug_persistent_keys = function(l_26_0)
  local persistent_keys = {}
  local unit_types = l_26_0:controlled_unit_types()
  for sequence_key in l_26_0:keys(CoreSequenceCutsceneKey.ELEMENT_NAME) do
    local unit_type = unit_types[sequence_key:unit_name()]
     -- DECOMPILER ERROR: Confused while interpreting a jump as a 'while'

  end
  persistent_keys[string.format("Sequence %s.%s", "\"" .. sequence_key:unit_name() .. "\"", sequence_key:name())] = true
end
for callback_key in l_26_0:keys(CoreUnitCallbackCutsceneKey.ELEMENT_NAME) do
  local unit_type = unit_types[callback_key:unit_name()]
   -- DECOMPILER ERROR: Confused while interpreting a jump as a 'while'

end
persistent_keys[string.format("Callback %s:%s():%s()", "\"" .. callback_key:unit_name() .. "\"", callback_key:extension(), callback_key:method())] = true
end
return persistent_keys
end


