-- Decompiled using luadec 2.0.1 by sztupy (http://winmo.sztupy.hu)
-- Command line was: F:\SteamLibrary\SteamApps\common\PAYDAY 2\lua\core\lib\managers\coreenvironmenteffectsmanager.luac 

core:module("CoreEnvironmentEffectsManager")
core:import("CoreTable")
if not EnvironmentEffectsManager then
  EnvironmentEffectsManager = class()
end
EnvironmentEffectsManager.init = function(l_1_0)
  l_1_0._effects = {}
  l_1_0._current_effects = {}
  l_1_0._mission_effects = {}
  l_1_0._repeat_mission_effects = {}
end

EnvironmentEffectsManager.add_effect = function(l_2_0, l_2_1, l_2_2)
  l_2_0._effects[l_2_1] = l_2_2
  if l_2_2:default() then
    l_2_0:use(l_2_1)
  end
end

EnvironmentEffectsManager.effect = function(l_3_0, l_3_1)
  return l_3_0._effects[l_3_1]
end

EnvironmentEffectsManager.effects = function(l_4_0)
  return l_4_0._effects
end

EnvironmentEffectsManager.effects_names = function(l_5_0)
  local t = {}
  for name,effect in pairs(l_5_0._effects) do
    if not effect:default() then
      table.insert(t, name)
    end
  end
  table.sort(t)
  return t
end

EnvironmentEffectsManager.use = function(l_6_0, l_6_1)
  if l_6_0._effects[l_6_1] and not table.contains(l_6_0._current_effects, l_6_0._effects[l_6_1]) then
    l_6_0._effects[l_6_1]:load_effects()
    l_6_0._effects[l_6_1]:start()
    table.insert(l_6_0._current_effects, l_6_0._effects[l_6_1])
    do return end
    Application:error("No effect named, " .. l_6_1 .. " availible to use")
  end
end

EnvironmentEffectsManager.load_effects = function(l_7_0, l_7_1)
  if l_7_0._effects[l_7_1] then
    l_7_0._effects[l_7_1]:load_effects()
  end
end

EnvironmentEffectsManager.stop = function(l_8_0, l_8_1)
  if l_8_0._effects[l_8_1] then
    l_8_0._effects[l_8_1]:stop()
    table.delete(l_8_0._current_effects, l_8_0._effects[l_8_1])
  end
end

EnvironmentEffectsManager.stop_all = function(l_9_0)
  for _,effect in ipairs(l_9_0._current_effects) do
    effect:stop()
  end
  l_9_0._current_effects = {}
end

EnvironmentEffectsManager.update = function(l_10_0, l_10_1, l_10_2)
  for _,effect in ipairs(l_10_0._current_effects) do
    effect:update(l_10_1, l_10_2)
  end
  for name,params in pairs(l_10_0._repeat_mission_effects) do
    params.next_time = params.next_time - l_10_2
    if params.next_time <= 0 then
      params.next_time = params.base_time + math.rand(params.random_time)
      params.effect_id = World:effect_manager():spawn(params)
      if params.max_amount then
        params.max_amount = params.max_amount - 1
        if params.max_amount <= 0 then
          l_10_0._repeat_mission_effects[name] = nil
        end
      end
    end
  end
end

EnvironmentEffectsManager.gravity_and_wind_dir = function(l_11_0)
  local wind_importance = 0.5
  return Vector3(0, 0, -982) + Wind:wind_at(Vector3()) * wind_importance
end

EnvironmentEffectsManager.spawn_mission_effect = function(l_12_0, l_12_1, l_12_2)
  if l_12_2.base_time > 0 or l_12_2.random_time > 0 then
    if l_12_0._repeat_mission_effects[l_12_1] then
      l_12_0:kill_mission_effect(l_12_1)
    end
    l_12_2.next_time = 0
    l_12_2.effect_id = nil
    l_12_0._repeat_mission_effects[l_12_1] = l_12_2
    return 
  end
  l_12_2.effect_id = World:effect_manager():spawn(l_12_2)
  if not l_12_0._mission_effects[l_12_1] then
    l_12_0._mission_effects[l_12_1] = {}
  end
  table.insert(l_12_0._mission_effects[l_12_1], l_12_2)
end

EnvironmentEffectsManager.kill_all_mission_effects = function(l_13_0)
  for _,params in pairs(l_13_0._repeat_mission_effects) do
    if params.effect_id then
      World:effect_manager():kill(params.effect_id)
    end
  end
  l_13_0._repeat_mission_effects = {}
  for _,effects in pairs(l_13_0._mission_effects) do
    for _,params in ipairs(effects) do
      World:effect_manager():kill(params.effect_id)
    end
  end
  l_13_0._mission_effects = {}
end

EnvironmentEffectsManager.kill_mission_effect = function(l_14_0, l_14_1)
  l_14_0:_kill_mission_effect(l_14_1, "kill")
end

EnvironmentEffectsManager.fade_kill_mission_effect = function(l_15_0, l_15_1)
  l_15_0:_kill_mission_effect(l_15_1, "fade_kill")
end

EnvironmentEffectsManager._kill_mission_effect = function(l_16_0, l_16_1, l_16_2)
  local kill = callback(World:effect_manager(), World:effect_manager(), l_16_2)
  local params = l_16_0._repeat_mission_effects[l_16_1]
  if params then
    if params.effect_id then
      kill(params.effect_id)
    end
    l_16_0._repeat_mission_effects[l_16_1] = nil
    return 
  end
  local effects = l_16_0._mission_effects[l_16_1]
  if not effects then
    return 
  end
  for _,params in ipairs(effects) do
    kill(params.effect_id)
  end
  l_16_0._mission_effects[l_16_1] = nil
end

EnvironmentEffectsManager.save = function(l_17_0, l_17_1)
  local state = {mission_effects = {}}
  for name,effects in pairs(l_17_0._mission_effects) do
    state.mission_effects[name] = {}
    for _,params in pairs(effects) do
      if World:effect_manager():alive(params.effect_id) then
        table.insert(state.mission_effects[name], params)
      end
    end
  end
  l_17_1.EnvironmentEffectsManager = state
end

EnvironmentEffectsManager.load = function(l_18_0, l_18_1)
  local state = l_18_1.EnvironmentEffectsManager
  for name,effects in pairs(state.mission_effects) do
    for _,params in ipairs(effects) do
      l_18_0:spawn_mission_effect(name, params)
    end
  end
end

if not EnvironmentEffect then
  EnvironmentEffect = class()
end
EnvironmentEffect.init = function(l_19_0, l_19_1)
  l_19_0._default = l_19_1
end

EnvironmentEffect.load_effects = function(l_20_0)
end

EnvironmentEffect.update = function(l_21_0, l_21_1, l_21_2)
end

EnvironmentEffect.start = function(l_22_0)
end

EnvironmentEffect.stop = function(l_23_0)
end

EnvironmentEffect.default = function(l_24_0)
  return l_24_0._default
end


