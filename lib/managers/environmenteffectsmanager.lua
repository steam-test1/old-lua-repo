-- Decompiled using luadec 2.0.1 by sztupy (http://winmo.sztupy.hu)
-- Command line was: F:\SteamLibrary\SteamApps\common\PAYDAY 2\lua\lib\managers\environmenteffectsmanager.luac 

core:import("CoreEnvironmentEffectsManager")
if not EnvironmentEffectsManager then
  EnvironmentEffectsManager = class(CoreEnvironmentEffectsManager.EnvironmentEffectsManager)
end
EnvironmentEffectsManager.init = function(l_1_0)
  EnvironmentEffectsManager.super.init(l_1_0)
  l_1_0:add_effect("rain", RainEffect:new())
  l_1_0:add_effect("raindrop_screen", RainDropScreenEffect:new())
  l_1_0:add_effect("lightning", LightningEffect:new())
  l_1_0._camera_position = Vector3()
  l_1_0._camera_rotation = Rotation()
end

EnvironmentEffectsManager.update = function(l_2_0, l_2_1, l_2_2)
  l_2_0._camera_position = managers.viewport:get_current_camera_position()
  l_2_0._camera_rotation = managers.viewport:get_current_camera_rotation()
  EnvironmentEffectsManager.super.update(l_2_0, l_2_1, l_2_2)
end

EnvironmentEffectsManager.camera_position = function(l_3_0)
  return l_3_0._camera_position
end

EnvironmentEffectsManager.camera_rotation = function(l_4_0)
  return l_4_0._camera_rotation
end

if not EnvironmentEffect then
  EnvironmentEffect = class()
end
EnvironmentEffect.init = function(l_5_0, l_5_1)
  l_5_0._default = l_5_1
end

EnvironmentEffect.load_effects = function(l_6_0)
end

EnvironmentEffect.update = function(l_7_0, l_7_1, l_7_2)
end

EnvironmentEffect.start = function(l_8_0)
end

EnvironmentEffect.stop = function(l_9_0)
end

EnvironmentEffect.default = function(l_10_0)
  return l_10_0._default
end

if not RainEffect then
  RainEffect = class(EnvironmentEffect)
end
RainEffect.init = function(l_11_0)
  EnvironmentEffect.init(l_11_0)
  l_11_0._effect_name = Idstring("effects/particles/rain/rain_01_a")
end

RainEffect.load_effects = function(l_12_0)
end

RainEffect.update = function(l_13_0, l_13_1, l_13_2)
  local vp = managers.viewport:first_active_viewport()
  if vp and l_13_0._vp ~= vp then
    vp:vp():set_post_processor_effect("World", Idstring("streaks"), Idstring("streaks_rain"))
    if alive(l_13_0._vp) then
      l_13_0._vp:vp():set_post_processor_effect("World", Idstring("streaks"), Idstring("streaks"))
    end
    l_13_0._vp = vp
  end
  local c_rot = managers.environment_effects:camera_rotation()
  if not c_rot then
    return 
  end
  local c_pos = managers.environment_effects:camera_position()
  if not c_pos then
    return 
  end
  World:effect_manager():move_rotate(l_13_0._effect, c_pos, c_rot)
end

RainEffect.start = function(l_14_0)
  l_14_0._effect = World:effect_manager():spawn({effect = l_14_0._effect_name, position = Vector3(), rotation = Rotation()})
end

RainEffect.stop = function(l_15_0)
  World:effect_manager():kill(l_15_0._effect)
  l_15_0._effect = nil
  if alive(l_15_0._vp) then
    l_15_0._vp:vp():set_post_processor_effect("World", Idstring("streaks"), Idstring("streaks"))
    l_15_0._vp = nil
  end
end

if not LightningEffect then
  LightningEffect = class(EnvironmentEffect)
end
LightningEffect.init = function(l_16_0)
  EnvironmentEffect.init(l_16_0)
end

LightningEffect.load_effects = function(l_17_0)
end

LightningEffect._update_wait_start = function(l_18_0)
  if Underlay:loaded() then
    l_18_0:start()
  end
end

LightningEffect._update = function(l_19_0, l_19_1, l_19_2)
  if l_19_0._flashing then
    l_19_0:_update_function(l_19_1, l_19_2)
  end
  if l_19_0._sound_delay then
    l_19_0._sound_delay = l_19_0._sound_delay - l_19_2
    if l_19_0._sound_delay <= 0 then
      l_19_0._sound_source:post_event("thunder")
      l_19_0._sound_delay = nil
    end
  end
  l_19_0._next = l_19_0._next - l_19_2
  if l_19_0._next <= 0 then
    l_19_0:_set_lightning_values()
    l_19_0:_make_lightning()
    l_19_0._update_function = l_19_0._update_first
    l_19_0:_set_next_timer()
    l_19_0._flashing = true
  end
end

LightningEffect.start = function(l_20_0)
  if not Underlay:loaded() then
    l_20_0.update = l_20_0._update_wait_start
    return 
  end
  l_20_0.update = l_20_0._update
  l_20_0._sky_material = Underlay:material(Idstring("sky"))
  l_20_0._original_color0 = l_20_0._sky_material:get_variable(Idstring("color0"))
  l_20_0._original_light_color = Global._global_light:color()
  l_20_0._original_sun_horizontal = Underlay:time(Idstring("sun_horizontal"))
  l_20_0._min_interval = 2
  l_20_0._rnd_interval = 10
  l_20_0._sound_source = SoundDevice:create_source("thunder")
  l_20_0:_set_next_timer()
end

LightningEffect.stop = function(l_21_0)
end

LightningEffect._update_first = function(l_22_0, l_22_1, l_22_2)
  l_22_0._first_flash_time = l_22_0._first_flash_time - l_22_2
  if l_22_0._first_flash_time <= 0 then
    l_22_0:_set_original_values()
    l_22_0._update_function = l_22_0._update_pause
  end
end

LightningEffect._update_pause = function(l_23_0, l_23_1, l_23_2)
  l_23_0._pause_flash_time = l_23_0._pause_flash_time - l_23_2
  if l_23_0._pause_flash_time <= 0 then
    l_23_0:_make_lightning()
    l_23_0._update_function = l_23_0._update_second
  end
end

LightningEffect._update_second = function(l_24_0, l_24_1, l_24_2)
  l_24_0._second_flash_time = l_24_0._second_flash_time - l_24_2
  if l_24_0._second_flash_time <= 0 then
    l_24_0:_set_original_values()
    l_24_0._flashing = false
  end
end

LightningEffect._set_original_values = function(l_25_0)
  l_25_0._sky_material:set_variable(Idstring("color0"), l_25_0._original_color0)
  Global._global_light:set_color(l_25_0._original_light_color)
  Underlay:set_time(Idstring("sun_horizontal"), l_25_0._original_sun_horizontal)
end

LightningEffect._make_lightning = function(l_26_0)
  l_26_0._sky_material:set_variable(Idstring("color0"), l_26_0._intensity_value)
  Global._global_light:set_color(l_26_0._intensity_value)
  Underlay:set_time(Idstring("sun_horizontal"), l_26_0._flash_anim_time)
end

LightningEffect._set_lightning_values = function(l_27_0)
  l_27_0._first_flash_time = 0.10000000149012
  l_27_0._pause_flash_time = 0.10000000149012
  l_27_0._second_flash_time = 0.30000001192093
  l_27_0._flash_roll = math.rand(360)
  l_27_0._flash_dir = Rotation(0, 0, l_27_0._flash_roll):y()
  l_27_0._flash_anim_time = math.rand(0, 1)
  l_27_0._distance = math.rand(1)
  l_27_0._intensity_value = math.lerp(Vector3(2, 2, 2), Vector3(5, 5, 5), l_27_0._distance)
  local c_pos = managers.environment_effects:camera_position()
  if c_pos then
    local sound_speed = 30000
    l_27_0._sound_delay = l_27_0._distance * 2
    l_27_0._sound_source:set_rtpc("lightning_distance", l_27_0._distance * 4000)
  end
end

LightningEffect._set_next_timer = function(l_28_0)
  l_28_0._next = l_28_0._min_interval + math.rand(l_28_0._rnd_interval)
end

if not RainDropEffect then
  RainDropEffect = class(EnvironmentEffect)
end
RainDropEffect.init = function(l_29_0)
  EnvironmentEffect.init(l_29_0)
  l_29_0._under_roof = false
  l_29_0._slotmask = managers.slot:get_mask("statics")
end

RainDropEffect.load_effects = function(l_30_0)
end

RainDropEffect.update = function(l_31_0, l_31_1, l_31_2)
end

RainDropEffect.start = function(l_32_0)
  local t = {effect = l_32_0._effect_name, position = Vector3(), rotation = Rotation()}
  l_32_0._raindrops = World:effect_manager():spawn(t)
  l_32_0._extra_raindrops = World:effect_manager():spawn(t)
end

RainDropEffect.stop = function(l_33_0)
  if l_33_0._raindrops then
    World:effect_manager():fade_kill(l_33_0._raindrops)
    World:effect_manager():fade_kill(l_33_0._extra_raindrops)
    l_33_0._raindrops = nil
  end
end

if not RainDropScreenEffect then
  RainDropScreenEffect = class(RainDropEffect)
end
RainDropScreenEffect.init = function(l_34_0)
  RainDropEffect.init(l_34_0)
  l_34_0._effect_name = Idstring("effects/particles/rain/raindrop_screen")
end

CoreClass.override_class(CoreEnvironmentEffectsManager.EnvironmentEffectsManager, EnvironmentEffectsManager)

