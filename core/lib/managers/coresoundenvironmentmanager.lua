-- Decompiled using luadec 2.0.1 by sztupy (http://winmo.sztupy.hu)
-- Command line was: F:\SteamLibrary\SteamApps\common\PAYDAY 2\lua\core\lib\managers\coresoundenvironmentmanager.luac 

core:import("CoreShapeManager")
if not CoreSoundEnvironmentManager then
  CoreSoundEnvironmentManager = class()
end
CoreSoundEnvironmentManager.init = function(l_1_0)
  l_1_0._areas = {}
  l_1_0._areas_per_frame = 1
  l_1_0._check_objects = {}
  l_1_0._check_object_id = 0
  l_1_0._emitters = {}
  l_1_0._area_emitters = {}
  l_1_0._ambience_changed_callback = {}
  l_1_0._ambience_changed_callbacks = {}
  l_1_0._environment_changed_callback = {}
  l_1_0.GAME_DEFAULT_ENVIRONMENT = "padded_cell"
  l_1_0._default_environment = l_1_0.GAME_DEFAULT_ENVIRONMENT
  l_1_0._current_environment = l_1_0.GAME_DEFAULT_ENVIRONMENT
  l_1_0:_set_environment(l_1_0.GAME_DEFAULT_ENVIRONMENT)
  local in_editor = Application:editor()
  if in_editor then
    l_1_0._environments = l_1_0:_environment_effects()
    l_1_0.GAME_DEFAULT_ENVIRONMENT = l_1_0._environments[1] or nil
    l_1_0._default_environment = l_1_0.GAME_DEFAULT_ENVIRONMENT
    l_1_0._current_environment = l_1_0.GAME_DEFAULT_ENVIRONMENT
    l_1_0:_set_environment(l_1_0.GAME_DEFAULT_ENVIRONMENT)
  else
    l_1_0:_set_environment(l_1_0.GAME_DEFAULT_ENVIRONMENT)
  end
  if in_editor then
    l_1_0:_find_emitter_events()
    l_1_0:_find_ambience_events()
    l_1_0:_find_scene_events()
    l_1_0:_find_occasional_events()
    l_1_0.GAME_DEFAULT_EMITTER_PATH = l_1_0._emitter.paths[1]
    l_1_0.GAME_DEFAULT_AMBIENCE = l_1_0._ambience.events[1]
    l_1_0._default_ambience = l_1_0.GAME_DEFAULT_AMBIENCE
    l_1_0.GAME_DEFAULT_OCCASIONAL = l_1_0._occasional.events[1]
    l_1_0._default_occasional = l_1_0.GAME_DEFAULT_OCCASIONAL
    l_1_0.GAME_DEFAULT_SCENE_PATH = l_1_0._scene.paths[1]
  end
  l_1_0._ambience_enabled = false
  l_1_0._occasional_blocked_by_platform = SystemInfo:platform() == Idstring("X360")
  l_1_0._ambience_sources_count = SystemInfo:platform() == Idstring("X360") and 1 or 4
  l_1_0.POSITION_OFFSET = 50
  l_1_0._active_ambience_soundbanks = {}
  l_1_0._occasional_sound_source = SoundDevice:create_source("occasional")
end

CoreSoundEnvironmentManager._find_emitter_events = function(l_2_0)
  l_2_0._emitter = {events = {}, paths = {}, soundbanks = {}}
  for _,soundbank in ipairs(SoundDevice:sound_banks()) do
    for event,data in pairs(SoundDevice:events(soundbank)) do
      if string.match(event, "emitter") then
        if not table.contains(l_2_0._emitter.paths, data.path) then
          table.insert(l_2_0._emitter.paths, data.path)
        end
        if not l_2_0._emitter.events[data.path] then
          l_2_0._emitter.events[data.path] = {}
        end
        table.insert(l_2_0._emitter.events[data.path], event)
        l_2_0._emitter.soundbanks[event] = soundbank
      end
    end
  end
  table.sort(l_2_0._emitter.paths)
end

CoreSoundEnvironmentManager._find_ambience_events = function(l_3_0)
  l_3_0._ambience = {events = {}, soundbanks = {}}
  for _,soundbank in ipairs(SoundDevice:sound_banks()) do
    for event,data in pairs(SoundDevice:events(soundbank)) do
      if string.match(event, "ambience") then
        table.insert(l_3_0._ambience.events, event)
        l_3_0._ambience.soundbanks[event] = soundbank
      end
    end
  end
  table.sort(l_3_0._ambience.events)
end

CoreSoundEnvironmentManager._find_scene_events = function(l_4_0)
  l_4_0._scene = {events = {}, paths = {}, soundbanks = {}}
  for _,soundbank in ipairs(SoundDevice:sound_banks()) do
    for event,data in pairs(SoundDevice:events(soundbank)) do
      if not table.contains(l_4_0._scene.paths, data.path) then
        table.insert(l_4_0._scene.paths, data.path)
      end
      if not l_4_0._scene.events[data.path] then
        l_4_0._scene.events[data.path] = {}
      end
      table.insert(l_4_0._scene.events[data.path], event)
      l_4_0._scene.soundbanks[event] = soundbank
    end
  end
  table.sort(l_4_0._scene.paths)
end

CoreSoundEnvironmentManager._find_occasional_events = function(l_5_0)
  l_5_0._occasional = {events = {}, soundbanks = {}}
  for _,soundbank in ipairs(SoundDevice:sound_banks()) do
    for event,data in pairs(SoundDevice:events(soundbank)) do
      if string.match(event, "occasional") then
        table.insert(l_5_0._occasional.events, event)
        l_5_0._occasional.soundbanks[event] = soundbank
      end
    end
  end
  table.sort(l_5_0._occasional.events)
end

CoreSoundEnvironmentManager.areas = function(l_6_0)
  return l_6_0._areas
end

CoreSoundEnvironmentManager.game_default_ambience = function(l_7_0)
  return l_7_0.GAME_DEFAULT_AMBIENCE
end

CoreSoundEnvironmentManager.game_default_occasional = function(l_8_0)
  return l_8_0.GAME_DEFAULT_OCCASIONAL
end

CoreSoundEnvironmentManager.game_default_emitter_path = function(l_9_0)
  return l_9_0.GAME_DEFAULT_EMITTER_PATH
end

CoreSoundEnvironmentManager.emitter_paths = function(l_10_0)
  return l_10_0._emitter.paths
end

CoreSoundEnvironmentManager.emitter_events = function(l_11_0, l_11_1)
  if not l_11_1 or not l_11_0._emitter.events[l_11_1] then
    return l_11_0._emitter.events
  end
end

CoreSoundEnvironmentManager.emitter_soundbank = function(l_12_0, l_12_1)
  if not l_12_0._emitter then
    return 
  end
  return l_12_0._emitter.soundbanks[l_12_1]
end

CoreSoundEnvironmentManager.emitter_soundbanks = function(l_13_0)
  if not l_13_0._emitter then
    return 
  end
  return l_13_0._emitter.soundbanks
end

CoreSoundEnvironmentManager.ambience_events = function(l_14_0)
  return l_14_0._ambience.events
end

CoreSoundEnvironmentManager.ambience_soundbank = function(l_15_0, l_15_1)
  if not l_15_0._ambience then
    return 
  end
  return l_15_0._ambience.soundbanks[l_15_1]
end

CoreSoundEnvironmentManager.ambience_soundbanks = function(l_16_0)
  if not l_16_0._ambience then
    return 
  end
  return l_16_0._ambience.soundbanks
end

CoreSoundEnvironmentManager.occasional_events = function(l_17_0)
  if not l_17_0._occasional then
    return 
  end
  return l_17_0._occasional.events
end

CoreSoundEnvironmentManager.occasional_soundbank = function(l_18_0, l_18_1)
  if not l_18_0._occasional then
    return 
  end
  return l_18_0._occasional.soundbanks[l_18_1]
end

CoreSoundEnvironmentManager.occasional_soundbanks = function(l_19_0)
  if not l_19_0._occasional then
    return 
  end
  return l_19_0._occasional.soundbanks
end

CoreSoundEnvironmentManager.game_default_scene_path = function(l_20_0)
  return l_20_0.GAME_DEFAULT_SCENE_PATH
end

CoreSoundEnvironmentManager.scene_paths = function(l_21_0)
  return l_21_0._scene.paths
end

CoreSoundEnvironmentManager.scene_events = function(l_22_0, l_22_1)
  if not l_22_1 or not l_22_0._scene.events[l_22_1] then
    return l_22_0._scene.events
  end
end

CoreSoundEnvironmentManager.scene_soundbank = function(l_23_0, l_23_1)
  return l_23_0._scene.soundbanks[l_23_1]
end

CoreSoundEnvironmentManager.scene_soundbanks = function(l_24_0)
  return l_24_0._scene.soundbanks
end

CoreSoundEnvironmentManager.scene_path = function(l_25_0, l_25_1)
  for path,events in pairs(l_25_0._scene.events) do
    if table.contains(events, l_25_1) then
      return path
    end
  end
end

CoreSoundEnvironmentManager.emitters = function(l_26_0)
  return l_26_0._emitters
end

CoreSoundEnvironmentManager.area_emitters = function(l_27_0)
  return l_27_0._area_emitters
end

CoreSoundEnvironmentManager._environment_effects = function(l_28_0)
  local effects = {}
  for name,_ in pairs(SoundDevice:effects()) do
    table.insert(effects, name)
  end
  table.sort(effects)
  return effects
end

CoreSoundEnvironmentManager.environments = function(l_29_0)
  return l_29_0._environments
end

CoreSoundEnvironmentManager.game_default_environment = function(l_30_0)
  return l_30_0.GAME_DEFAULT_ENVIRONMENT
end

CoreSoundEnvironmentManager.default_environment = function(l_31_0)
  return l_31_0._default_environment
end

CoreSoundEnvironmentManager.set_default_environment = function(l_32_0, l_32_1)
  l_32_0._default_environment = l_32_1
  l_32_0:_set_environment(l_32_0._default_environment)
  l_32_0:_change_acoustic(l_32_0._default_environment)
end

CoreSoundEnvironmentManager._set_environment = function(l_33_0, l_33_1)
  for _,func in ipairs(l_33_0._environment_changed_callback) do
    func(l_33_1)
  end
  l_33_0._current_environment = l_33_1
  SoundDevice:set_default_environment({effect = l_33_1, gain = 1})
end

CoreSoundEnvironmentManager.current_environment = function(l_34_0)
  return l_34_0._current_environment
end

CoreSoundEnvironmentManager.set_default_ambience = function(l_35_0, l_35_1)
  if not l_35_1 then
    return 
  end
  l_35_0._default_ambience = l_35_1
  if Application:editor() then
    l_35_0:add_soundbank(l_35_0:ambience_soundbank(l_35_0._default_ambience))
  end
  for id,data in pairs(l_35_0._check_objects) do
    l_35_0:_change_ambience(data)
  end
end

CoreSoundEnvironmentManager.default_ambience = function(l_36_0)
  return l_36_0._default_ambience
end

CoreSoundEnvironmentManager.set_default_occasional = function(l_37_0, l_37_1)
  if not l_37_1 then
    return 
  end
  if l_37_1 and Application:editor() and not table.contains(managers.sound_environment:occasional_events(), l_37_1) then
    if managers.editor then
      managers.editor:output_error("Default occasional event " .. l_37_1 .. " no longer exits. Falls back on default.")
    end
    l_37_1 = managers.sound_environment:game_default_occasional()
  end
  l_37_0._default_occasional = l_37_1
  if Application:editor() then
    l_37_0:add_soundbank(l_37_0:occasional_soundbank(l_37_0._default_occasional))
  end
end

CoreSoundEnvironmentManager.default_occasional = function(l_38_0)
  return l_38_0._default_occasional
end

CoreSoundEnvironmentManager.add_soundbank = function(l_39_0, l_39_1)
  if not l_39_1 then
    Application:error("Cant load nil soundbank")
    return 
  end
  if Application:editor() then
    CoreEngineAccess._editor_load("bnk":id(), l_39_1:id())
  end
end

CoreSoundEnvironmentManager.set_to_default = function(l_40_0)
  l_40_0:set_default_environment(l_40_0.GAME_DEFAULT_ENVIRONMENT)
  l_40_0:set_default_ambience(l_40_0.GAME_DEFAULT_AMBIENCE)
  l_40_0:set_default_occasional(l_40_0.GAME_DEFAULT_OCCASIONAL)
  l_40_0:set_ambience_enabled(false)
end

CoreSoundEnvironmentManager.add_area = function(l_41_0, l_41_1)
  local area = SoundEnvironmentArea:new(l_41_1)
  table.insert(l_41_0._areas, area)
  return area
end

CoreSoundEnvironmentManager.remove_area = function(l_42_0, l_42_1)
  l_42_1:remove()
  for _,data in pairs(l_42_0._check_objects) do
    if l_42_1 == data.area then
      data.area = nil
      l_42_0:_change_ambience(data)
    end
    data.sound_area_counter = 1
  end
  table.delete(l_42_0._areas, l_42_1)
end

CoreSoundEnvironmentManager.add_emitter = function(l_43_0, l_43_1)
  local emitter = SoundEnvironmentEmitter:new(l_43_1)
  table.insert(l_43_0._emitters, emitter)
  return emitter
end

CoreSoundEnvironmentManager.remove_emitter = function(l_44_0, l_44_1)
  l_44_1:destroy()
  table.delete(l_44_0._emitters, l_44_1)
end

CoreSoundEnvironmentManager.add_area_emitter = function(l_45_0, l_45_1)
  local emitter = SoundEnvironmentAreaEmitter:new(l_45_1)
  table.insert(l_45_0._area_emitters, emitter)
  return emitter
end

CoreSoundEnvironmentManager.remove_area_emitter = function(l_46_0, l_46_1)
  l_46_1:destroy()
  table.delete(l_46_0._area_emitters, l_46_1)
end

CoreSoundEnvironmentManager.add_listener = function(l_47_0, l_47_1)
  Application:throw_exception("add_listener function is no longer working because of new sound implementation. Use add_check_object instead.")
  local distance, orientation, occlusion = Sound:listener(l_47_1.listener)
  l_47_1.object = distance
  return l_47_0:add_check_object(l_47_1)
end

CoreSoundEnvironmentManager.add_check_object = function(l_48_0, l_48_1)
  if not l_48_1.object then
    Application:error("Must use an Object3D when adding check objects to sound environment manager.")
    return nil
  end
  l_48_0:_disable_fallback()
  l_48_0._check_object_id = l_48_0._check_object_id + 1
  local soundsource = SoundDevice:create_source("ambience_source")
  soundsource:enable_env(false)
  local surround = {}
  for i = 1, l_48_0._ambience_sources_count do
    local source = SoundDevice:create_source("ambience_surround_" .. i)
    source:enable_env(false)
    local distance = 15000
    local x = (i == 1 or i == 4) and -distance or distance
    if (i ~= 1 and i ~= 2) or not distance then
      local y = -distance
    end
    local offset = Vector3(x, y, 0)
    source:set_position(l_48_1.object:position() + offset)
    table.insert(surround, {source = source, offset = offset})
  end
  {object = l_48_1.object, area = nil, soundsource = soundsource, surround = surround, surround_iterator = surround and 0 or nil, active = l_48_1.active}.listener = l_48_1.listener
   -- DECOMPILER ERROR: Confused about usage of registers!

  {object = l_48_1.object, area = nil, soundsource = soundsource, surround = surround, surround_iterator = surround and 0 or nil, active = l_48_1.active}.primary = l_48_1.primary
   -- DECOMPILER ERROR: Confused about usage of registers!

  {object = l_48_1.object, area = nil, soundsource = soundsource, surround = surround, surround_iterator = surround and 0 or nil, active = l_48_1.active}.id = l_48_0._check_object_id
   -- DECOMPILER ERROR: Confused about usage of registers!

  {object = l_48_1.object, area = nil, soundsource = soundsource, surround = surround, surround_iterator = surround and 0 or nil, active = l_48_1.active}.next_occasional = l_48_0:_next_occasional()
   -- DECOMPILER ERROR: Confused about usage of registers!

  {object = l_48_1.object, area = nil, soundsource = soundsource, surround = surround, surround_iterator = surround and 0 or nil, active = l_48_1.active}.sound_area_counter = 1
  do
     -- DECOMPILER ERROR: Confused at declaration of local variable

     -- DECOMPILER ERROR: Confused about usage of registers!

    l_48_0:_change_ambience({object = l_48_1.object, area = nil, soundsource = soundsource, surround = surround, surround_iterator = surround and 0 or nil, active = l_48_1.active})
     -- DECOMPILER ERROR: Confused about usage of registers!

    l_48_0._check_objects[l_48_0._check_object_id] = {object = l_48_1.object, area = nil, soundsource = soundsource, surround = surround, surround_iterator = surround and 0 or nil, active = l_48_1.active}
    return l_48_0._check_object_id
  end
   -- DECOMPILER ERROR: Confused about usage of registers for local variables.

end

CoreSoundEnvironmentManager.remove_check_object = function(l_49_0, l_49_1)
  local remove_object = l_49_0._check_objects[l_49_1]
  remove_object.soundsource:stop()
  if remove_object.surround then
    for _,surround_data in ipairs(remove_object.surround) do
      surround_data.source:stop()
    end
  end
  l_49_0._check_objects[l_49_1] = nil
  l_49_0:_enable_fallback()
end

CoreSoundEnvironmentManager.set_check_object_active = function(l_50_0, l_50_1, l_50_2)
  local object = l_50_0._check_objects[l_50_1]
  if object.active == l_50_2 then
    return 
  end
  object.active = l_50_2
  if not l_50_2 then
    object.soundsource:stop()
    if object.surround then
      for _,surround_data in ipairs(object.surround) do
        surround_data.source:stop()
      end
    else
      l_50_0:_check_inside(object)
      if not object.area then
        l_50_0:_change_ambience(object, 1)
      end
    end
  end
end

CoreSoundEnvironmentManager.obj_alive = function(l_51_0, l_51_1)
  local data = l_51_0._check_objects[l_51_1]
  if data then
    return alive(data.object)
  end
end

CoreSoundEnvironmentManager.check_object = function(l_52_0, l_52_1)
  return l_52_0._check_objects[l_52_1]
end

CoreSoundEnvironmentManager._disable_fallback = function(l_53_0)
  local fallback = l_53_0._check_objects[l_53_0._fallback_id]
  if fallback then
    l_53_0:set_check_object_active(l_53_0._fallback_id, false)
  end
end

CoreSoundEnvironmentManager._enable_fallback = function(l_54_0)
  local fallback = l_54_0._check_objects[l_54_0._fallback_id]
  if fallback and not fallback.active then
    for id,object in pairs(l_54_0._check_objects) do
      if object ~= fallback then
        return 
      end
    end
    l_54_0:set_check_object_active(l_54_0._fallback_id, true)
  end
end

CoreSoundEnvironmentManager._next_occasional = function(l_55_0)
  return Application:time() + (6 + math.rand(4))
end

local check_pos = Vector3()
local mvec_surround_pos = Vector3()
CoreSoundEnvironmentManager._update_object = function(l_56_0, l_56_1, l_56_2, l_56_3, l_56_4)
  l_56_4.object:m_position(check_pos)
  local still_inside = nil
  if l_56_4.surround then
    local surround_data = l_56_4.surround[l_56_4.surround_iterator + 1]
    mvector3.set(mvec_surround_pos, check_pos)
    mvector3.add(mvec_surround_pos, surround_data.offset)
    surround_data.source:set_position(mvec_surround_pos)
    l_56_4.surround_iterator = math.mod(l_56_4.surround_iterator + 1, l_56_0._ambience_sources_count)
  end
  if l_56_4.next_occasional < l_56_1 then
    l_56_4.next_occasional = l_56_0:_next_occasional()
    if l_56_0._ambience_enabled and not l_56_0._occasional_blocked_by_platform then
      if not l_56_4.area or not l_56_4.area:use_occasional() or not l_56_4.area:occasional_event() then
        local event = l_56_0._default_occasional
      end
      if event then
        local x = math.rand(2) - 1
        local y = math.rand(2) - 1
        local pos = check_pos + Vector3(x, y, 0):normalized() * 7500
        l_56_0._occasional_sound_source:set_position(pos)
        l_56_0._occasional_sound_source:post_event(event)
      end
    end
  end
  if l_56_4.area then
    still_inside = l_56_4.area:still_inside(check_pos)
    if still_inside then
      return l_56_4.area
    end
    if l_56_0:_check_inside(l_56_4) then
      return l_56_4.area
    end
    l_56_0:_change_acoustic(l_56_0._default_environment)
    l_56_0:_change_ambience(l_56_4)
  end
  if l_56_0:_check_inside(l_56_4) then
    return l_56_4.area
  end
  return nil
end

CoreSoundEnvironmentManager._fallback_on_camera = function(l_57_0)
  if not l_57_0._use_fallback_on_camera then
    return 
  end
  local vps = managers.viewport:active_viewports()
  if #vps == 0 then
    return 
  end
  local camera = vps[1]:camera()
  if not camera then
    return 
  end
  local fallback = l_57_0._check_objects[l_57_0._fallback_id]
   -- DECOMPILER ERROR: unhandled construct in 'if'

  if fallback and fallback.object ~= camera then
    fallback.object = camera
    do return end
    if not next(l_57_0._check_objects) then
      l_57_0._fallback_id = l_57_0:add_check_object({object = camera, primary = true, active = true})
      l_57_0:check_object(l_57_0._fallback_id).fallback = true
    end
  end
end

CoreSoundEnvironmentManager.update = function(l_58_0, l_58_1, l_58_2)
  for id,data in pairs(l_58_0._check_objects) do
    if data.active then
      l_58_0:_update_object(l_58_1, l_58_2, id, data)
    end
  end
end

CoreSoundEnvironmentManager._change_ambience = function(l_59_0, l_59_1, l_59_2)
  local area = l_59_1.area
  if not area or not area:ambience_event() then
    local ambience_event = l_59_0._default_ambience
  end
  if l_59_0._ambience_changed_callbacks[l_59_1.id] then
    for _,func in ipairs(l_59_0._ambience_changed_callbacks[l_59_1.id]) do
      func(ambience_event)
    end
  end
  for _,func in ipairs(l_59_0._ambience_changed_callback) do
    func(ambience_event)
  end
  if not l_59_0._ambience_enabled then
    return 
  end
  if l_59_1.surround then
    for _,surround_data in ipairs(l_59_1.surround) do
      surround_data.source:post_event(ambience_event)
    end
  end
end

CoreSoundEnvironmentManager._change_acoustic = function(l_60_0, l_60_1)
  l_60_0._acoustic = l_60_1
  if tweak_data.sound.acoustics[l_60_1] and tweak_data.sound.acoustics[l_60_1].states then
    for state,value in pairs(tweak_data.sound.acoustics[l_60_1].states) do
      SoundDevice:set_state(state, value)
    end
  end
end

local check_pos2 = Vector3()
CoreSoundEnvironmentManager._check_inside = function(l_61_0, l_61_1)
  if #l_61_0._areas > 0 then
    local check_pos = check_pos2
    l_61_1.object:m_position(check_pos)
    for i = 1, l_61_0._areas_per_frame do
      local area = l_61_0._areas[l_61_1.sound_area_counter]
      l_61_1.sound_area_counter = math.mod(l_61_1.sound_area_counter, #l_61_0._areas) + 1
      if area:is_inside(check_pos) then
        l_61_1.area = area
        l_61_0:_change_acoustic(l_61_1.area:environment())
        l_61_0:_change_ambience(l_61_1)
        return area
      end
    end
  end
  l_61_1.area = nil
  return l_61_1.area
end

CoreSoundEnvironmentManager.ambience_enabled = function(l_62_0)
  return l_62_0._ambience_enabled
end

CoreSoundEnvironmentManager.set_ambience_enabled = function(l_63_0, l_63_1)
  l_63_0._ambience_enabled = l_63_1
  if not l_63_0._default_ambience then
    return 
  end
  for _,data in pairs(l_63_0._check_objects) do
    if l_63_0._ambience_enabled and data.active then
      l_63_0:_change_ambience(data)
      for (for control),_ in (for generator) do
      end
      data.soundsource:stop()
      if data.surround then
        for _,surround_data in ipairs(data.surround) do
          surround_data.source:stop()
        end
      end
    end
     -- Warning: missing end command somewhere! Added here
  end
end

CoreSoundEnvironmentManager.environment_at_position = function(l_64_0, l_64_1)
  local environment = l_64_0._default_environment
  local ambience = l_64_0._default_ambience
  local occasional = l_64_0._default_occasional
  for _,area in ipairs(l_64_0._areas) do
    if area:is_inside(l_64_1) then
      environment = area:environment()
      ambience = area:ambience_event()
      occasional = area:occasional_event()
  else
    end
  end
  return environment, ambience, occasional
end

CoreSoundEnvironmentManager.add_ambience_changed_callback = function(l_65_0, l_65_1, l_65_2)
  if l_65_2 then
    if not l_65_0._ambience_changed_callbacks[l_65_2] then
      l_65_0._ambience_changed_callbacks[l_65_2] = {}
    end
    table.insert(l_65_0._ambience_changed_callbacks[l_65_2], l_65_1)
    return 
  end
  table.insert(l_65_0._ambience_changed_callback, l_65_1)
end

CoreSoundEnvironmentManager.remove_ambience_changed_callback = function(l_66_0, l_66_1, l_66_2)
  if l_66_2 and l_66_0._ambience_changed_callbacks[l_66_2] then
    table.delete(l_66_0._ambience_changed_callbacks[l_66_2], l_66_1)
    return 
  end
  table.delete(l_66_0._ambience_changed_callback, l_66_1)
end

CoreSoundEnvironmentManager.add_environment_changed_callback = function(l_67_0, l_67_1)
  table.insert(l_67_0._environment_changed_callback, l_67_1)
end

CoreSoundEnvironmentManager.remove_environment_changed_callback = function(l_68_0, l_68_1)
  table.delete(l_68_0._environment_changed_callback, l_68_1)
end

CoreSoundEnvironmentManager.destroy = function(l_69_0)
  for i,emitter in ipairs(l_69_0._emitters) do
    emitter:destroy()
  end
  l_69_0._emitters = {}
  for _,env_area in ipairs(l_69_0._areas) do
    env_area:remove()
  end
  l_69_0._areas = {}
  l_69_0._occasional_sound_source:stop()
end

if not SoundEnvironmentArea then
  SoundEnvironmentArea = class(CoreShapeManager.ShapeBox)
end
SoundEnvironmentArea.init = function(l_70_0, l_70_1)
  l_70_1.type = "box"
  SoundEnvironmentArea.super.init(l_70_0, l_70_1)
  if not l_70_1.environment then
    l_70_0._environment = managers.sound_environment:game_default_environment()
  end
  if not l_70_1.ambience_event then
    l_70_0._ambience_event = managers.sound_environment:game_default_ambience()
  end
  if not l_70_1.occasional_event then
    l_70_0._occasional_event = managers.sound_environment:game_default_occasional()
  end
  l_70_0._use_environment = not l_70_1.use_environment and ((l_70_1.use_environment == nil and true))
  l_70_0._use_ambience = not l_70_1.use_ambience and ((l_70_1.use_ambience == nil and true))
  l_70_0._use_occasional = not l_70_1.use_occasional and ((l_70_1.use_occasional == nil and true))
  l_70_0._gain = l_70_1.gain or 0
  l_70_0._name = l_70_1.name or ""
  l_70_0:_init_environment_effect()
  l_70_0:_init_event()
  l_70_0._environment_shape = EnvironmentShape(l_70_0:position(), l_70_0:size(), l_70_0:rotation())
  l_70_0:_add_environment()
  if Application:editor() then
    managers.sound_environment:add_soundbank(managers.sound_environment:ambience_soundbank(l_70_0._ambience_event))
    managers.sound_environment:add_soundbank(managers.sound_environment:occasional_soundbank(l_70_0._occasional_event))
  end
end

SoundEnvironmentArea._init_event = function(l_71_0)
  if Application:editor() then
    if not table.contains(managers.sound_environment:ambience_events(), l_71_0._ambience_event) then
      managers.editor:output_error("Ambience event " .. l_71_0._ambience_event .. " no longer exits. Falls back on default.")
      l_71_0:set_environment_ambience(managers.sound_environment:game_default_ambience())
    end
    if l_71_0._occasional_event and not table.contains(managers.sound_environment:occasional_events(), l_71_0._occasional_event) then
      managers.editor:output_error("Occasional event " .. l_71_0._occasional_event .. " no longer exits. Falls back on default.")
      l_71_0:set_environment_occasional(managers.sound_environment:game_default_occasional())
    end
  end
end

SoundEnvironmentArea._init_environment_effect = function(l_72_0)
  if Application:editor() and not table.contains(managers.sound_environment:environments(), l_72_0._environment) then
    managers.editor:output_error("Environment effect " .. l_72_0._environment .. " no longer exits. Falls back on default.")
    l_72_0:set_environment(managers.sound_environment:game_default_environment())
  end
end

SoundEnvironmentArea._add_environment = function(l_73_0)
  if l_73_0._use_environment and not l_73_0._environment_id then
    l_73_0._environment_id = SoundDevice:add_environment({effect = l_73_0._environment, gain = l_73_0._gain, shape = l_73_0._environment_shape})
  end
end

SoundEnvironmentArea._remove_environment = function(l_74_0)
  if l_74_0._environment_id then
    SoundDevice:remove_environment(l_74_0._environment_id)
    l_74_0._environment_id = nil
  end
end

SoundEnvironmentArea.name = function(l_75_0)
  if not l_75_0._unit or not l_75_0._unit:unit_data().name_id then
    return l_75_0._name
  end
end

SoundEnvironmentArea.environment = function(l_76_0)
  return l_76_0._environment
end

SoundEnvironmentArea.set_environment = function(l_77_0, l_77_1)
  l_77_0._environment = l_77_1
  l_77_0:_update_environment()
end

SoundEnvironmentArea.ambience_event = function(l_78_0)
  return l_78_0._ambience_event
end

SoundEnvironmentArea.set_environment_ambience = function(l_79_0, l_79_1)
  if not l_79_1 then
    return 
  end
  l_79_0._ambience_event = l_79_1
  if Application:editor() then
    managers.sound_environment:add_soundbank(managers.sound_environment:ambience_soundbank(l_79_0._ambience_event))
  end
end

SoundEnvironmentArea.set_use_ambience = function(l_80_0, l_80_1)
  l_80_0._use_ambience = l_80_1
end

SoundEnvironmentArea.use_ambience = function(l_81_0)
  return l_81_0._use_ambience
end

SoundEnvironmentArea.occasional_event = function(l_82_0)
  return l_82_0._occasional_event
end

SoundEnvironmentArea.set_environment_occasional = function(l_83_0, l_83_1)
  l_83_0._occasional_event = l_83_1
  if not l_83_1 then
    return 
  end
  if Application:editor() then
    managers.sound_environment:add_soundbank(managers.sound_environment:occasional_soundbank(l_83_0._occasional_event))
  end
end

SoundEnvironmentArea.set_use_occasional = function(l_84_0, l_84_1)
  l_84_0._use_occasional = l_84_1
end

SoundEnvironmentArea.use_occasional = function(l_85_0)
  return l_85_0._use_occasional
end

SoundEnvironmentArea.set_use_environment = function(l_86_0, l_86_1)
  l_86_0._use_environment = l_86_1
  if l_86_0._use_environment then
    l_86_0:_add_environment()
  else
    l_86_0:_remove_environment()
  end
end

SoundEnvironmentArea.use_environment = function(l_87_0)
  return l_87_0._use_environment
end

SoundEnvironmentArea.set_unit = function(l_88_0, l_88_1)
  SoundEnvironmentArea.super.set_unit(l_88_0, l_88_1)
  l_88_0._environment_shape:link(l_88_1:orientation_object())
end

SoundEnvironmentArea._update_environment = function(l_89_0)
  if l_89_0._environment_id then
    SoundDevice:update_environment(l_89_0._environment_id, {effect = l_89_0._environment, gain = l_89_0._gain, shape = l_89_0._environment_shape})
  end
end

SoundEnvironmentArea._update_environment_size = function(l_90_0)
  l_90_0._environment_shape:set_size(l_90_0:size())
  l_90_0:_update_environment()
end

SoundEnvironmentArea.set_property = function(l_91_0, l_91_1, l_91_2)
  SoundEnvironmentArea.super.set_property(l_91_0, l_91_1, l_91_2)
  l_91_0:_update_environment_size()
end

SoundEnvironmentArea.set_width = function(l_92_0, l_92_1)
  SoundEnvironmentArea.super.set_width(l_92_0, l_92_1)
  l_92_0:_update_environment_size()
end

SoundEnvironmentArea.set_depth = function(l_93_0, l_93_1)
  SoundEnvironmentArea.super.set_depth(l_93_0, l_93_1)
  l_93_0:_update_environment_size()
end

SoundEnvironmentArea.set_height = function(l_94_0, l_94_1)
  SoundEnvironmentArea.super.set_height(l_94_0, l_94_1)
  l_94_0:_update_environment_size()
end

SoundEnvironmentArea.remove = function(l_95_0)
  l_95_0:_remove_environment()
end

SoundEnvironmentArea.still_inside = function(l_96_0, l_96_1)
  if not l_96_0._use_ambience then
    return false
  end
  return SoundEnvironmentArea.super.still_inside(l_96_0, l_96_1)
end

SoundEnvironmentArea.is_inside = function(l_97_0, l_97_1)
  if not l_97_0._use_ambience then
    return false
  end
  return SoundEnvironmentArea.super.is_inside(l_97_0, l_97_1)
end

if not SoundEnvironmentEmitter then
  SoundEnvironmentEmitter = class()
end
SoundEnvironmentEmitter.init = function(l_98_0, l_98_1)
  if not l_98_1.position then
    l_98_0._position = Vector3()
  end
  if not l_98_1.rotation then
    l_98_0._rotation = Rotation()
  end
  l_98_0._name = l_98_1.name or ""
  l_98_0._soundsource = SoundDevice:create_source(l_98_0._name)
  local emitter_path = managers.sound_environment:game_default_emitter_path()
  if not l_98_1.emitter_event then
    l_98_0:set_emitter_event(managers.sound_environment:emitter_events(emitter_path)[1])
  end
end

SoundEnvironmentEmitter.save_xml = function(l_99_0, l_99_1)
  local properties = {}
  properties.name = l_99_0:name()
  properties.position = l_99_0:position()
  properties.rotation = l_99_0:rotation()
  properties.emitter_event = l_99_0._emitter_event
  return simple_value_string("properties", properties, l_99_1)
end

SoundEnvironmentEmitter.name = function(l_100_0)
  if not l_100_0._unit or not l_100_0._unit:unit_data().name_id then
    return l_100_0._name
  end
end

SoundEnvironmentEmitter.emitter_path = function(l_101_0)
  for path,events in pairs(managers.sound_environment:emitter_events()) do
    if table.contains(events, l_101_0._emitter_event) then
      return path
    end
  end
end

SoundEnvironmentEmitter.emitter_event = function(l_102_0)
  return l_102_0._emitter_event
end

SoundEnvironmentEmitter.set_emitter_path = function(l_103_0, l_103_1)
  if not l_103_1 then
    return 
  end
  local current_path = l_103_0:emitter_path()
  if l_103_1 == current_path then
    return 
  end
  l_103_0:set_emitter_event(managers.sound_environment:emitter_events(l_103_1)[1])
end

SoundEnvironmentEmitter.set_emitter_event = function(l_104_0, l_104_1)
  l_104_0._emitter_event = l_104_1
  if Application:editor() then
    managers.sound_environment:add_soundbank(managers.sound_environment:emitter_soundbank(l_104_0._emitter_event))
  end
  l_104_0:play_sound()
end

SoundEnvironmentEmitter.set_unit = function(l_105_0, l_105_1)
  l_105_0._unit = l_105_1
  l_105_0._soundsource:link(l_105_0._unit:orientation_object())
end

SoundEnvironmentEmitter.position = function(l_106_0)
  if not l_106_0._unit or not l_106_0._unit:position() then
    return l_106_0._position
  end
end

SoundEnvironmentEmitter.set_position = function(l_107_0, l_107_1)
  l_107_0._position = l_107_1
end

SoundEnvironmentEmitter.rotation = function(l_108_0)
  if not l_108_0._unit or not l_108_0._unit:rotation() then
    return l_108_0._rotation
  end
end

SoundEnvironmentEmitter.set_rotation = function(l_109_0, l_109_1)
  l_109_0._rotation = l_109_1
end

SoundEnvironmentEmitter.play_sound = function(l_110_0)
  if l_110_0._sound_event then
    l_110_0._sound_event:stop()
  end
  l_110_0._soundsource:stop()
  if l_110_0._unit then
    l_110_0._soundsource:link(l_110_0._unit:orientation_object())
  else
    l_110_0._soundsource:set_position(l_110_0:position())
  end
  l_110_0._sound_event = l_110_0._soundsource:post_event(l_110_0._emitter_event)
end

SoundEnvironmentEmitter.restart = function(l_111_0)
  l_111_0:play_sound()
end

SoundEnvironmentEmitter.draw = function(l_112_0, l_112_1, l_112_2, l_112_3, l_112_4, l_112_5)
  Application:draw_sphere(l_112_0:position(), 75, l_112_3, l_112_4, l_112_5)
  Application:draw_cone(l_112_0:position(), l_112_0:position() + l_112_0:rotation():y() * 500, 500, l_112_3, l_112_4, l_112_5)
  Application:draw_cone(l_112_0:position(), l_112_0:position() - l_112_0:rotation():y() * 500, 500, l_112_3, l_112_4, l_112_5)
end

SoundEnvironmentEmitter.destroy = function(l_113_0)
  if l_113_0._sound_event then
    l_113_0._sound_event:stop()
    l_113_0._sound_event = nil
  end
  l_113_0._soundsource:delete()
  l_113_0._soundsource = nil
end

if not SoundEnvironmentAreaEmitter then
  SoundEnvironmentAreaEmitter = class(CoreShapeManager.ShapeBoxMiddle)
end
SoundEnvironmentAreaEmitter.init = function(l_114_0, l_114_1)
  l_114_1.type = "box_middle"
  SoundEnvironmentAreaEmitter.super.init(l_114_0, l_114_1)
  l_114_0._properties.name = l_114_1.name or ""
  l_114_0._soundsource = SoundDevice:create_source(l_114_0._properties.name)
  local emitter_path = managers.sound_environment:game_default_emitter_path()
  if not l_114_1.emitter_event then
    l_114_0:set_emitter_event(managers.sound_environment:emitter_events(emitter_path)[1])
  end
end

SoundEnvironmentAreaEmitter.save = function(l_115_0, ...)
  l_115_0._properties.name = l_115_0:name()
  return SoundEnvironmentAreaEmitter.super.save(l_115_0, ...)
   -- DECOMPILER ERROR: Confused about usage of registers for local variables.

end

SoundEnvironmentAreaEmitter.name = function(l_116_0)
  if not l_116_0._unit or not l_116_0._unit:unit_data().name_id then
    return l_116_0._name
  end
end

SoundEnvironmentAreaEmitter.emitter_path = function(l_117_0)
  for path,events in pairs(managers.sound_environment:emitter_events()) do
    if table.contains(events, l_117_0._properties.emitter_event) then
      return path
    end
  end
end

SoundEnvironmentAreaEmitter.emitter_event = function(l_118_0)
  return l_118_0._properties.emitter_event
end

SoundEnvironmentAreaEmitter.set_emitter_path = function(l_119_0, l_119_1)
  if not l_119_1 then
    return 
  end
  local current_path = l_119_0:emitter_path()
  if l_119_1 == current_path then
    return 
  end
  l_119_0:set_emitter_event(managers.sound_environment:emitter_events(l_119_1)[1])
end

SoundEnvironmentAreaEmitter.set_emitter_event = function(l_120_0, l_120_1)
  l_120_0._properties.emitter_event = l_120_1
  if Application:editor() then
    managers.sound_environment:add_soundbank(managers.sound_environment:emitter_soundbank(l_120_0._properties.emitter_event))
  end
  l_120_0:play_sound()
end

SoundEnvironmentAreaEmitter.play_sound = function(l_121_0)
  if l_121_0._sound_event then
    l_121_0._sound_event:stop()
  end
  if l_121_0._unit then
    l_121_0._soundsource:link(l_121_0._unit:orientation_object())
  else
    l_121_0._soundsource:set_position(l_121_0:position())
  end
  l_121_0._sound_event = l_121_0._soundsource:post_event(l_121_0._properties.emitter_event)
end

SoundEnvironmentAreaEmitter.set_extent = function(l_122_0)
end

SoundEnvironmentAreaEmitter.extent = function(l_123_0)
  return Vector3(l_123_0._properties.width / 2, l_123_0._properties.depth / 2, l_123_0._properties.height / 2)
end

SoundEnvironmentAreaEmitter.set_property = function(l_124_0, ...)
  SoundEnvironmentAreaEmitter.super.set_property(l_124_0, ...)
  l_124_0:set_extent()
   -- DECOMPILER ERROR: Confused about usage of registers for local variables.

end

SoundEnvironmentAreaEmitter.set_unit = function(l_125_0, l_125_1)
  SoundEnvironmentAreaEmitter.super.set_unit(l_125_0, l_125_1)
  l_125_0._soundsource:link(l_125_0._unit:orientation_object())
end

SoundEnvironmentAreaEmitter.restart = function(l_126_0)
  l_126_0:play_sound()
end

SoundEnvironmentAreaEmitter.destroy = function(l_127_0)
  if l_127_0._sound_event then
    l_127_0._sound_event:stop()
    l_127_0._sound_event = nil
  end
  l_127_0._soundsource:delete()
  l_127_0._soundsource = nil
end


