-- Decompiled using luadec 2.0.1 by sztupy (http://winmo.sztupy.hu)
-- Command line was: F:\SteamLibrary\SteamApps\common\PAYDAY 2\lua\lib\managers\feedbackmanager.luac 

if not FeedBackManager then
  FeedBackManager = class()
end
FeedBackManager.init = function(l_1_0)
  l_1_0._effect_types = {rumble = FeedBackrumble, camera_shake = FeedBackCameraShake, above_camera_effect = FeedBackAboveCameraEffect}
  l_1_0:setup_preset_effects()
  l_1_0._feedback_map = {}
end

FeedBackManager.setup_preset_effects = function(l_2_0)
  l_2_0._feedback = {}
  l_2_0._feedback.mission_triggered = {}
  l_2_0._feedback.mission_triggered.camera_shake = {name = "mission_triggered"}
  l_2_0._feedback.mission_triggered.rumble = {name = "mission_triggered"}
  l_2_0._feedback.mission_triggered.above_camera_effect = {effect = "none"}
end

FeedBackManager.get_effect_names = function(l_3_0)
  local names = {}
  for name,_ in pairs(l_3_0._feedback) do
    table.insert(names, name)
  end
  return names
end

FeedBackManager.create = function(l_4_0, l_4_1, ...)
  local extra_params = {...}
  do
    local f = FeedBack:new(l_4_1, l_4_0._feedback[l_4_1])
    if not f then
      Application:stack_dump_error("no effect called " .. tostring(l_4_1))
      return nil
    end
    for i = 1, #extra_params, 2 do
      if extra_params[i] and extra_params[i + 1] and f.set_" .. extra_params[i then
        f.set_" .. extra_params[i(f, extra_params[i + 1])
      else
        Application:stack_dump_error("bad params to create_feedback " .. tostring(extra_params[i]) .. " " .. tostring(extra_params[i + 1]))
      end
    end
    return f
  end
   -- DECOMPILER ERROR: Confused about usage of registers for local variables.

end

FeedBackManager.reload = function(l_5_0, l_5_1)
  l_5_0:setup_preset_effects()
end

FeedBackManager.get_effect_table = function(l_6_0, l_6_1)
  return l_6_0._feedback[l_6_1]
end

FeedBackManager.stop_all = function(l_7_0, l_7_1)
  managers.rumble:stop("all")
end

if not FeedBack then
  FeedBack = class()
end
FeedBack.init = function(l_8_0, l_8_1, l_8_2)
  l_8_0._name = l_8_1
  l_8_0._feedback = {}
  for name,param in pairs(l_8_2) do
    l_8_0._feedback[name] = managers.feedback._effect_types[name]:new(l_8_0._name)
  end
end

FeedBack.set_enabled = function(l_9_0, l_9_1, l_9_2)
  if l_9_0._feedback[l_9_1] then
    l_9_0._feedback[l_9_1]:set_enabled(l_9_2)
  end
end

FeedBack.is_enabled = function(l_10_0, l_10_1)
  local effect = l_10_0._feedback[l_10_1]
  if effect then
    return effect:is_enabled()
  end
end

FeedBack.set_unit = function(l_11_0, l_11_1, l_11_2)
  if not l_11_2 then
    for _,effect in pairs(l_11_0._feedback) do
      effect:set_unit(l_11_1)
    end
  else
    if l_11_0._feedback[l_11_2] then
      l_11_0._feedback[l_11_2]:set_unit(l_11_1)
    end
  end
end

FeedBack.set_viewport = function(l_12_0, l_12_1, l_12_2)
  if l_12_2 then
    l_12_0._feedback[l_12_2]:set_viewport(l_12_1)
  else
    for _,effect in pairs(l_12_0._feedback) do
      effect:set_viewport(l_12_1)
    end
  end
end

FeedBack.set_param = function(l_13_0, l_13_1, l_13_2, l_13_3)
  if l_13_0._feedback[l_13_1] then
    l_13_0._feedback[l_13_1]:set_param(l_13_2, l_13_3)
  end
end

FeedBack.reset_params = function(l_14_0, l_14_1)
  if l_14_0._feedback[l_14_1] then
    l_14_0._feedback[l_14_1]:reset_params()
  end
end

FeedBack.extra_params = function(l_15_0, l_15_1)
  return l_15_0._extra_params[l_15_1]
end

FeedBack.play = function(l_16_0, ...)
  do
    local extra_params = {...}
    l_16_0._extra_params = {}
    for i = 1, #extra_params, 3 do
      if extra_params[i] and extra_params[i + 1] and extra_params[i + 2] and l_16_0._feedback[extra_params[i]] then
        if not l_16_0._extra_params[extra_params[i]] then
          l_16_0._extra_params[extra_params[i]] = {}
        end
        l_16_0._extra_params[extra_params[i]][extra_params[i + 1]] = extra_params[i + 2]
      end
    end
    for name in pairs(managers.feedback:get_effect_table(l_16_0._name)) do
      local effect = l_16_0._feedback[name]
      if effect:is_enabled() then
        if effect then
          effect:play(l_16_0._extra_params[name])
          for (for control) in (for generator) do
          end
          l_16_0._feedback[name] = managers.feedback._effect_types[name]:new(l_16_0._name)
        end
      end
      for i = 1, #extra_params, 3 do
        if extra_params[i] and extra_params[i + 1] and extra_params[i + 2] and l_16_0._feedback[extra_params[i]] and l_16_0._feedback[extra_params[i]]:is_enabled() then
          l_16_0._feedback[extra_params[i]]:set_param(extra_params[i + 1], extra_params[i + 2])
        else
          local msg = ""
          if not l_16_0._feedback[extra_params[i]] then
            msg = "no effect called " .. tostring(extra_params[i])
        end
      end
    end
     -- DECOMPILER ERROR: Confused about usage of registers for local variables.

     -- Warning: missing end command somewhere! Added here
  end
end

FeedBack.stop = function(l_17_0, l_17_1, ...)
  do
    local extra_params = {...}
    for i = 1, #extra_params, 2 do
      if extra_params[i] and extra_params[i + 1] and f.set_" .. extra_params[i then
        f.set_" .. extra_params[i(f, extra_params[i + 1])
      else
        Application:stack_dump_error("bad params to create_feedback " .. tostring(extra_params[i]) .. " " .. tostring(extra_params[i + 1]))
      end
    end
    if not l_17_1 then
      for name,effect in pairs(l_17_0._feedback) do
        effect:stop()
      end
    else
      l_17_0._feedback[l_17_1]:stop()
    end
     -- DECOMPILER ERROR: Confused about usage of registers for local variables.

  end
end

FeedBack.is_playing = function(l_18_0, l_18_1)
  if not l_18_1 then
    for name,effect in pairs(l_18_0._feedback) do
      if effect:is_playing() then
        return true
      end
    end
    return false
  else
    return l_18_0._feedback[l_18_1]:is_playing()
  end
end

if not FeedBackEffect then
  FeedBackEffect = class()
end
FeedBackEffect.init = function(l_19_0, l_19_1)
  l_19_0._params = {}
  l_19_0._name = l_19_1
  l_19_0._enabled = true
end

FeedBackEffect.set_enabled = function(l_20_0, l_20_1)
  if not l_20_0._enabled ~= not l_20_1 then
    if l_20_0._enabled then
      l_20_0:stop()
    end
    l_20_0._enabled = l_20_1
  end
end

FeedBackEffect.is_enabled = function(l_21_0)
  return l_21_0._enabled
end

FeedBackEffect.set_unit = function(l_22_0, l_22_1)
end

FeedBackEffect.set_viewport = function(l_23_0, l_23_1)
end

FeedBackEffect.set_static_param = function(l_24_0, l_24_1, l_24_2)
  l_24_0._params[l_24_1] = l_24_2
end

FeedBackEffect.set_param = function(l_25_0, l_25_1, l_25_2)
  l_25_0._params[l_25_1] = l_25_2
end

FeedBackEffect.reset_params = function(l_26_0)
  l_26_0._params = {}
end

FeedBackEffect.play = function(l_27_0)
  local params = managers.feedback:get_effect_table(l_27_0._name)[l_27_0._type]
  mixin(params, params, l_27_0._params)
  return params
end

FeedBackEffect.stop = function(l_28_0)
end

FeedBackEffect.is_playing = function(l_29_0)
  return false
end

if not FeedBackrumble then
  FeedBackrumble = class(FeedBackEffect)
end
FeedBackrumble.init = function(l_30_0, l_30_1)
  FeedBackEffect.init(l_30_0, l_30_1)
  l_30_0._type = "rumble"
end

FeedBackrumble.set_unit = function(l_31_0, l_31_1)
  l_31_0._unit = l_31_1
end

FeedBackrumble.set_param = function(l_32_0, l_32_1, l_32_2)
  if l_32_1 ~= "multiplier_data" and l_32_0._id then
    managers.rumble:set_multiplier(l_32_0._id, l_32_2)
  end
end

FeedBackrumble.play = function(l_33_0, l_33_1)
  local params = FeedBackEffect.play(l_33_0)
  if l_33_0._unit then
    l_33_0._id = managers.rumble:play(params.name, nil, params.multiplier_data, l_33_1)
  elseif not l_33_0._unit then
    Application:stack_dump_error("no unit set to rumble in feedbackRumble use either set_unit or send unit at create")
  end
end

FeedBackrumble.stop = function(l_34_0)
  managers.rumble:stop(l_34_0._id)
  l_34_0._id = nil
end

FeedBackrumble.is_playing = function(l_35_0)
  local rumble = nil
  if not l_35_0._id then
    return false
  end
  for _,controller in pairs(l_35_0._id.controllers) do
    rumble = controller:is_rumble_playing(l_35_0._id[1])
    if l_35_0._id[2] and not rumble then
      rumble = controller:is_rumble_playing(l_35_0._id[2])
    end
    if rumble then
      return rumble
    end
  end
  return rumble
end

if not FeedBackCameraShake then
  FeedBackCameraShake = class(FeedBackEffect)
end
FeedBackCameraShake.init = function(l_36_0, l_36_1)
  FeedBackEffect.init(l_36_0, l_36_1)
  l_36_0._type = "camera_shake"
end

FeedBackEffect.set_viewport = function(l_37_0, l_37_1)
  l_37_0._camera = l_37_1:director():shaker()
  l_37_0._playing_camera = l_37_0._camera
end

FeedBackEffect.set_unit = function(l_38_0, l_38_1)
  l_38_0._unit_camera = l_38_1:camera()
end

FeedBackCameraShake.set_param = function(l_39_0, l_39_1, l_39_2)
  if l_39_1 == "multiplier" then
    return 
  end
  if l_39_1 == "amplitude" then
    l_39_2 = l_39_2 * l_39_0._multiplier
  end
  if l_39_0._unit_camera then
    l_39_0._unit_camera:shaker():set_parameter(l_39_0._id, l_39_1, l_39_2)
  else
    if alive(l_39_0._playing_camera) then
      l_39_0._playing_camera:set_parameter(l_39_0._id, l_39_1, l_39_2)
    end
  end
end

FeedBackCameraShake.play = function(l_40_0, l_40_1)
  local params = managers.feedback:get_effect_table(l_40_0._name)[l_40_0._type]
  local name = params.name
  l_40_0._multiplier = l_40_1.multiplier or 1
  l_40_0._id = l_40_0._unit_camera:play_shaker(name, not l_40_0._unit_camera or 1, params.frequency or params.frequency or 1, params.offset or 0)
  do return end
  if not alive(l_40_0._camera) or not l_40_0._camera then
    l_40_0._playing_camera = managers.viewport:get_current_shaker()
  end
  if l_40_0._playing_camera then
    l_40_0._id = l_40_0._playing_camera:play(name)
    if l_40_0._playing_camera:is_playing(l_40_0._id) then
      local t = {}
      mixin(t, params, l_40_0._params)
      t.name = nil
      for param,value in pairs(t) do
        l_40_0._playing_camera:set_parameter(l_40_0._id, param, value)
      end
    end
  end
end

FeedBackCameraShake.stop = function(l_41_0)
  if l_41_0._unit_camera then
    l_41_0._unit_camera:stop_shaker(l_41_0._id)
  else
    managers.viewport:get_current_shaker():stop(l_41_0._id)
  end
  l_41_0._id = nil
end

FeedBackCameraShake.is_playing = function(l_42_0)
  if l_42_0._unit_camera and l_42_0._id then
    return l_42_0._unit_camera:shaker():is_playing(l_42_0._id)
  elseif l_42_0._playing_camera and l_42_0._id then
    return l_42_0._playing_camera:is_playing(l_42_0._id)
  else
    return false
  end
end

if not FeedBackAboveCameraEffect then
  FeedBackAboveCameraEffect = class(FeedBackEffect)
end
FeedBackAboveCameraEffect.init = function(l_43_0, l_43_1)
  FeedBackAboveCameraEffect.super.init(l_43_0, l_43_1)
  l_43_0._type = "above_camera_effect"
  l_43_0._offset = Vector3(0, 0, 100)
end

FeedBackAboveCameraEffect.set_unit = function(l_44_0, l_44_1)
  l_44_0._unit_camera = l_44_1:camera()
end

FeedBackAboveCameraEffect.set_param = function(l_45_0, l_45_1, l_45_2)
  l_45_0._params[l_45_1] = l_45_2
end

FeedBackAboveCameraEffect.play = function(l_46_0, l_46_1)
  local params = FeedBackAboveCameraEffect.super.play(l_46_0)
  if not l_46_1 or not l_46_1.effect then
    local name = params.effect
  end
  if name == "none" then
    return 
  end
  local effect_params = {}
  effect_params.effect = Idstring(name)
  effect_params.position = l_46_0._unit_camera:position() + l_46_0._offset
  effect_params.rotation = l_46_0._unit_camera:rotation()
  l_46_0._id = World:effect_manager():spawn(effect_params)
end

FeedBackAboveCameraEffect.stop = function(l_47_0)
  if l_47_0._id then
    World:effect_manager():kill(l_47_0._id)
  end
end


