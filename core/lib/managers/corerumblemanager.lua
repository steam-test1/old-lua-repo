-- Decompiled using luadec 2.0.1 by sztupy (http://winmo.sztupy.hu)
-- Command line was: F:\SteamLibrary\SteamApps\common\PAYDAY 2\lua\core\lib\managers\corerumblemanager.luac 

core:module("CoreRumbleManager")
if not RumbleManager then
  RumbleManager = class()
end
RumbleManager.init = function(l_1_0)
  l_1_0._last_played_ids = {}
  l_1_0._preset_rumbles = {}
  l_1_0._rumbling_controller_types = {}
  l_1_0:initialize_controller_types()
  l_1_0._registered_controllers = {}
  l_1_0._registered_controller_count = {}
  l_1_0._registered_controller_pos_callback_list = {}
  l_1_0._enabled = true
end

RumbleManager.add_preset_rumbles = function(l_2_0, l_2_1, l_2_2)
  l_2_0._preset_rumbles[l_2_1] = l_2_2
end

RumbleManager.initialize_controller_types = function(l_3_0)
  l_3_0._rumbling_controller_types.xbox360 = true
  l_3_0._rumbling_controller_types.ps3 = true
end

RumbleManager.stop = function(l_4_0, l_4_1)
  if l_4_1 then
    if l_4_1 == "all" then
      for _,controller in pairs(l_4_0._registered_controllers) do
        if controller then
          controller:stop_rumble()
        end
      end
    else
      for _,controller in pairs(l_4_1.controllers) do
        controller:stop_rumble(l_4_1[1])
        if l_4_1[2] then
          controller:stop_rumble(l_4_1[2])
        end
      end
    end
  end
end

RumbleManager.register_controller = function(l_5_0, l_5_1, l_5_2)
  if l_5_0._rumbling_controller_types[l_5_1.TYPE] then
    local ctrl = l_5_1:get_controller()
    local key = ctrl:key()
    l_5_0._registered_controllers[key] = ctrl
    l_5_0._registered_controller_count[key] = (l_5_0._registered_controller_count[key] or 0) + 1
    if not l_5_0._registered_controller_pos_callback_list[key] then
      l_5_0._registered_controller_pos_callback_list[key] = {}
    end
    l_5_0._registered_controller_pos_callback_list[key][l_5_2] = true
    return true
  end
end

RumbleManager.unregister_controller = function(l_6_0, l_6_1, l_6_2)
  local ctrl = l_6_1:get_controller()
  local key = ctrl:key()
  l_6_0._registered_controller_count[key] = (l_6_0._registered_controller_count[key] or 0) - 1
  if l_6_0._registered_controller_count[key] <= 0 then
    l_6_0._registered_controllers[key] = nil
    l_6_0._registered_controller_count[key] = nil
  end
  if l_6_0._registered_controller_pos_callback_list[key] then
    l_6_0._registered_controller_pos_callback_list[key][l_6_2] = nil
    if not next(l_6_0._registered_controller_pos_callback_list[key]) then
      l_6_0._registered_controller_pos_callback_list[key] = nil
    end
  end
end

RumbleManager.set_enabled = function(l_7_0, l_7_1)
  l_7_0._enabled = l_7_1
  if not l_7_1 then
    l_7_0:stop("all")
  end
end

RumbleManager.enabled = function(l_8_0)
  return l_8_0._enabled
end

RumbleManager.play = function(l_9_0, l_9_1, l_9_2, l_9_3, l_9_4)
  if not l_9_0._enabled then
    return false
  end
  local rumble_controllers = nil
  if not l_9_2 then
    rumble_controllers = l_9_0._registered_controllers
  else
    if l_9_0._rumbling_controller_types[l_9_2.TYPE] then
      local ctrl = l_9_2:get_controller()
      rumble_controllers[ctrl:key()] = ctrl
    end
  end
  local effect = l_9_0._preset_rumbles[l_9_1]
  if effect then
    local rumble_id = {}
    rumble_id.controllers = rumble_controllers
    rumble_id.name = l_9_1
    if l_9_4 then
      local custom_peak = l_9_4.peak
    end
    if l_9_4 then
      local custom_attack = l_9_4.attack
    end
    if l_9_4 then
      local custom_sustain = l_9_4.sustain
    end
    if l_9_4 then
      local custom_release = l_9_4.release
    end
    for _,controller in pairs(rumble_controllers) do
      if l_9_0._last_played_ids[controller:key()] then
        local redundant_rumble = l_9_0._last_played_ids[controller:key()][l_9_1]
        if redundant_rumble and (controller:is_rumble_playing(redundant_rumble[1]) or controller:is_rumble_playing(redundant_rumble[2])) then
          l_9_0:stop(redundant_rumble)
        end
      end
      local multiplier = l_9_3 or 1
      if not effect.timer then
        local timer = TimerManager:game()
      end
      multiplier = not l_9_3 or type(l_9_3) ~= "table" or not l_9_3.func or l_9_3.func(l_9_0._registered_controller_pos_callback_list[controller:key()], l_9_3.params) or 1
       -- DECOMPILER ERROR: Confused while interpreting a jump as a 'while'

    end
    table.insert(rumble_id, 1, controller:rumble({engine = "left", timer = timer, peak = (effect.engine ~= "hybrid" or 1) * (multiplier), attack = effect.attack.l, sustain = effect.sustain.l, release = effect.release.l}))
    table.insert(rumble_id, 2, controller:rumble({engine = "right", timer = timer, peak = (effect.peak.r or 1) * (multiplier), attack = effect.attack.r, sustain = effect.sustain.r, release = effect.release.r}))
    do return end
    if (not custom_attack and custom_sustain) or not custom_release then
      rumble_id[1] = controller:rumble({engine = effect.engine, timer = timer, peak = (custom_peak or effect.peak or 1) * (multiplier), attack = effect.attack, sustain = effect.sustain, release = effect.release})
      if not effect.cumulative then
        if not l_9_0._last_played_ids[controller:key()] then
          l_9_0._last_played_ids[controller:key()] = {}
        end
        l_9_0._last_played_ids[controller:key()][l_9_1] = rumble_id
      end
    end
    return rumble_id
  else
    Application:error("RumbleManager:: Effect ", l_9_1, " not found.")
  end
end

RumbleManager.set_multiplier = function(l_10_0, l_10_1, l_10_2)
  if not l_10_0._enabled or not l_10_1 or not l_10_2 then
    return false
  end
  do
    local effect = l_10_0._preset_rumbles[l_10_1.name]
    for _,controller in pairs(l_10_1.controllers) do
      if not effect.peak.l then
        controller:set_rumble_peak(l_10_1[1], (not l_10_1[2] or 1) * l_10_2)
      end
      controller:set_rumble_peak(l_10_1[2], (effect.peak.r or 1) * l_10_2)
      for (for control),_ in (for generator) do
        controller:set_rumble_peak(l_10_1[1], (effect.peak or 1) * l_10_2)
      end
    end
     -- Warning: missing end command somewhere! Added here
  end
end

RumbleManager.mult_distance_lerp = function(l_11_0, l_11_1, l_11_2)
  if l_11_1 then
    local closest_pos = nil
    for pos_func in pairs(l_11_1) do
      local next_closest_pos = pos_func(l_11_2)
      if not closest_pos or next_closest_pos - source:lenght() < closest_pos - source:length() then
        closest_pos = next_closest_pos
      end
    end
    if not l_11_2.full_dis then
      local full_dis = not closest_pos or 0
    end
    if not l_11_2.zero_dis then
      local zero_dis = 1000 - full_dis
    end
    local mult = l_11_2.multiplier or 1
    local source = l_11_2.source
    mult = mult * (zero_dis - math.clamp(source - closest_pos:length() - full_dis, 0, zero_dis)) / zero_dis
    return mult
  end
  return 0
end


