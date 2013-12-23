-- Decompiled using luadec 2.0.1 by sztupy (http://winmo.sztupy.hu)
-- Command line was: F:\SteamLibrary\SteamApps\common\PAYDAY 2\lua\core\lib\managers\viewport\coreenvironmentmixer.luac 

core:module("CoreEnvironmentMixer")
core:import("CoreClass")
core:import("CoreEnvironmentData")
core:import("CoreEnvironmentHandle")
core:import("CoreEnvironmentDebugInterface")
core:import("CoreEnvironmentSkyOrientationInterface")
core:import("CoreEnvironmentRadialBlurInterface")
core:import("CoreEnvironmentFogInterface")
core:import("CoreEnvironmentDOFInterface")
core:import("CoreEnvironmentDOFSharedInterface")
core:import("CoreEnvironmentShadowInterface")
core:import("CoreEnvironmentShadowSharedInterface")
if not EnvironmentMixer then
  EnvironmentMixer = CoreClass.class()
end
EnvironmentMixer.set_environment = function(l_1_0, l_1_1, l_1_2)
  if not l_1_2 or l_1_2 == 0 then
    l_1_0._from_env = l_1_0._cache:load_environment(l_1_1)
    l_1_0._target_env = l_1_0._cache:copy_environment(l_1_1)
  else
    l_1_0._from_env = l_1_0._to_env
  end
  l_1_0._blend = 0
  l_1_0._blend_time = l_1_2 or 0
  l_1_0._to_env = l_1_0._cache:load_environment(l_1_1)
  l_1_0._feed_params = 3
end

EnvironmentMixer.current_environment = function(l_2_0)
  if l_2_0:is_mixing() then
    return l_2_0._from_env:name(), l_2_0._to_env:name(), l_2_0._scale
  else
    return l_2_0._to_env:name()
  end
end

EnvironmentMixer.is_mixing = function(l_3_0)
  return l_3_0._is_mixing or false
end

EnvironmentMixer.create_modifier = function(l_4_0, l_4_1, l_4_2, l_4_3)
  return l_4_0:_create_modifier(l_4_1, l_4_2, l_4_3)
end

EnvironmentMixer.modifier_owner = function(l_5_0, l_5_1)
  local interface = l_5_0._interfaces[l_5_1]
  if interface then
    local handle_name = l_5_0:_create_handle_name_from_params(unpack(interface.DATA_PATH))
    if not l_5_0._full_control_handles[handle_name] and not l_5_0._part_control_handles[handle_name] then
      local handle = l_5_0._cache:shared_handle(nil, handle_name)
    end
    if handle then
      return handle:traceback()
    else
      Application:error("[EnvironmentMixer] No modifier created!")
    end
  else
    Application:error("[EnvironmentMixer] No interface with name: " .. l_5_1)
  end
end

EnvironmentMixer.destroy_modifier = function(l_6_0, l_6_1)
  if not l_6_0._full_control_handles[l_6_1] then
    local handle = l_6_0._part_control_handles[l_6_1]
  end
  if not handle then
    l_6_0._cache:destroy_shared_handle(l_6_1)
    return 
  end
  l_6_0._full_control_handles[l_6_1] = nil
  l_6_0._part_control_handles[l_6_1] = nil
end

EnvironmentMixer.modifier_interface_names = function(l_7_0)
  local t = {}
  for name,_ in pairs(l_7_0._interfaces) do
    table.insert(t, name)
  end
  return unpack(t)
end

EnvironmentMixer.static_parameters = function(l_8_0, l_8_1, ...)
  do
    local env = l_8_0._cache:load_environment(l_8_1)
    return env:parameter_block(...)
  end
   -- DECOMPILER ERROR: Confused about usage of registers for local variables.

end

EnvironmentMixer.init = function(l_9_0, l_9_1, l_9_2)
  l_9_0._cache = l_9_1
  l_9_0._target_env = l_9_0._cache:copy_environment(l_9_2)
  l_9_0:set_environment(l_9_2)
  l_9_0._full_control_handles = {}
  l_9_0._part_control_handles = {}
  l_9_0._ref_fov_stack = {}
  l_9_0._interfaces = {debug = CoreEnvironmentDebugInterface.EnvironmentDebugInterface, sky_orientation = CoreEnvironmentSkyOrientationInterface.EnvironmentSkyOrientationInterface, radial_blur = CoreEnvironmentRadialBlurInterface.EnvironmentRadialBlurInterface, fog = CoreEnvironmentFogInterface.EnvironmentFogInterface, dof = CoreEnvironmentDOFInterface.EnvironmentDOFInterface, shared_dof = CoreEnvironmentDOFSharedInterface.EnvironmentDOFSharedInterface, shadow = CoreEnvironmentShadowInterface.EnvironmentShadowInterface, shared_shadow = CoreEnvironmentShadowSharedInterface.EnvironmentShadowSharedInterface}
  l_9_0._visualization_modes = {"glossiness_visualization", "specular_visualization", "normal_visualization", "albedo_visualization", "deferred_lighting", "depth_visualization"}
end

EnvironmentMixer.internal_push_ref_fov = function(l_10_0, l_10_1, l_10_2, l_10_3)
  if not l_10_2:camera() or l_10_1 < math.rad(l_10_2:camera():fov()) then
    return false
  end
  local sh_pro = l_10_2:get_post_processor_effect(l_10_3, Idstring("shadow_processor"), Idstring("shadow_rendering"))
  if sh_pro then
    local sh_mod = sh_pro:modifier(Idstring("shadow_modifier"))
    if sh_mod then
      table.insert(l_10_0._ref_fov_stack, sh_mod:reference_fov())
      sh_mod:set_reference_fov(math.rad(l_10_1))
      return true
    end
  end
  return false
end

EnvironmentMixer.internal_pop_ref_fov = function(l_11_0, l_11_1, l_11_2)
  local sh_pro = l_11_1:get_post_processor_effect(l_11_2, Idstring("shadow_processor"), Idstring("shadow_rendering"))
  if sh_pro then
    local sh_mod = sh_pro:modifier(Idstring("shadow_modifier"))
    if sh_mod and #l_11_0._ref_fov_stack > 0 then
      local last = l_11_0._ref_fov_stack[#l_11_0._ref_fov_stack]
      if not l_11_1:camera() or math.rad(l_11_1:camera():fov()) <= last then
        sh_mod:set_reference_fov(l_11_0._ref_fov_stack[#l_11_0._ref_fov_stack])
        table.remove(l_11_0._ref_fov_stack, #l_11_0._ref_fov_stack)
        return true
      end
    end
  end
  return false
end

EnvironmentMixer.internal_ref_fov = function(l_12_0, l_12_1, l_12_2)
  local fov = -1
  local sh_pro = l_12_1:get_post_processor_effect(l_12_2, Idstring("shadow_processor"), Idstring("shadow_rendering"))
  if sh_pro then
    local sh_mod = sh_pro:modifier(Idstring("shadow_modifier"))
    if sh_mod then
      fov = math.deg(sh_mod:reference_fov())
    end
  end
  return fov
end

EnvironmentMixer.internal_set_visualization_mode = function(l_13_0, l_13_1, l_13_2, l_13_3)
  if l_13_1 ~= "deferred_lighting" or l_13_1 ~= "deferred_lighting" then
    l_13_2:set_post_processor_effect(l_13_3, Idstring("hdr_post_processor"), Idstring("empty")):set_visibility(not table.contains(l_13_0._visualization_modes, l_13_1))
  end
  l_13_2:set_post_processor_effect(l_13_3, Idstring("deferred"), Idstring(l_13_1)):set_visibility(true)
  do return end
  local error_msg = "[EnvironmentMixer] " .. l_13_1 .. " is not a valid visualization mode! Available modes are:"
   -- DECOMPILER ERROR: No list found. Setlist fails

  for _,mode in ipairs({}) do
    error_msg = error_msg .. "\t" .. mode
  end
  Application:error(error_msg)
end

EnvironmentMixer.internal_visualization_modes = function(l_14_0)
  return unpack(l_14_0._visualization_modes)
end

EnvironmentMixer.set_feed_params = function(l_15_0)
  l_15_0._feed_params = 1
end

EnvironmentMixer.internal_update = function(l_16_0, l_16_1, l_16_2, l_16_3)
  local id = Profiler:start("Environment Mixer")
  local return_value = not l_16_0._feed_params or true
  if l_16_0._feed_params then
    l_16_0._target_env:for_each(function(l_1_0, ...)
    self:_process_block(nr == 1, l_1_0, ...)
     -- DECOMPILER ERROR: Confused about usage of registers for local variables.

   end)
    l_16_0._feed_params = l_16_0._feed_params - 1
    if l_16_0._feed_params <= 0 then
      l_16_0._feed_params = nil
    end
    managers.environment_controller:feed_params()
  end
  Profiler:stop(id)
  return return_value
end

EnvironmentMixer.internal_output = function(l_17_0, ...)
  if select("#", ...) <= 0 or not l_17_0._target_env:parameter_block(...) then
    return l_17_0._target_env
     -- DECOMPILER ERROR: Confused about usage of registers for local variables.

  end
end

EnvironmentMixer._create_modifier = function(l_18_0, l_18_1, l_18_2, l_18_3, l_18_4, ...)
  local interface = assert(l_18_0._interfaces[l_18_2], "[EnvironmentMixer] Could not find interface with name: " .. l_18_2)
  if not interface.DATA_PATH then
    local path = {...}
  end
  local is_shared = interface.SHARED or l_18_4
  local name = l_18_0:_create_handle_name_from_params(unpack(path))
  do
    if not l_18_0:_get_handle_by_name(name) then
      local handle = l_18_0._cache:shared_handle(nil, name)
    end
    if not handle then
      handle = CoreEnvironmentHandle.EnvironmentHandle:new(l_18_0, interface, l_18_1, l_18_3, name, is_shared, unpack(path))
      if is_shared then
        l_18_0._cache:set_shared_handle(l_18_1, name, handle)
      elseif l_18_1 then
        l_18_0._full_control_handles[name] = handle
      else
        l_18_0._part_control_handles[name] = handle
      end
    end
    return name
  end
   -- DECOMPILER ERROR: Confused about usage of registers for local variables.

end

EnvironmentMixer._get_handle_by_params = function(l_19_0, ...)
  do
    local handle_name = l_19_0:_create_handle_name_from_params(...)
    return l_19_0:_get_handle_by_name(handle_name)
  end
   -- DECOMPILER ERROR: Confused about usage of registers for local variables.

end

EnvironmentMixer._get_handle_by_name = function(l_20_0, l_20_1)
  for _,handle in pairs(l_20_0._full_control_handles) do
    if handle:name() == l_20_1 then
      return handle
    end
  end
  for _,handle in pairs(l_20_0._part_control_handles) do
    if handle:name() == l_20_1 then
      return handle
    end
  end
end

EnvironmentMixer._process_block = function(l_21_0, l_21_1, l_21_2, ...)
  local handle_name = l_21_0:_create_handle_name_from_params(...)
  do
    if not l_21_1 or not l_21_0._full_control_handles[handle_name] and not l_21_0._cache:shared_handle(true, handle_name) then
      local handle = l_21_0._full_control_handles[handle_name]
    end
    if handle then
      l_21_0._target_env:set_parameter_block(handle:do_callback(), ...)
      return 
    end
    if l_21_0:is_mixing() then
      l_21_0:_do_mix(l_21_2, ...)
    end
    if not l_21_1 or not l_21_0._part_control_handles[handle_name] and not l_21_0._cache:shared_handle(false, handle_name) then
      handle = l_21_0._part_control_handles[handle_name]
    end
    if handle then
      l_21_0._target_env:set_parameter_block(handle:do_callback(), ...)
    end
     -- DECOMPILER ERROR: Confused about usage of registers for local variables.

  end
end

EnvironmentMixer._create_handle_name_from_params = function(l_22_0, ...)
  do
    local str = ""
    for _,v in ipairs({...}) do
      str = str .. v
    end
    return str
  end
   -- DECOMPILER ERROR: Confused about usage of registers for local variables.

end

EnvironmentMixer._do_mix = function(l_23_0, l_23_1, ...)
  l_23_0:_mix(l_23_1, l_23_0._from_env:parameter_block(...), l_23_0._to_env:parameter_block(...), l_23_0._scale)
   -- DECOMPILER ERROR: Confused about usage of registers for local variables.

end

EnvironmentMixer._mix = function(l_24_0, l_24_1, l_24_2, l_24_3, l_24_4)
  for key,value in pairs(l_24_2) do
    if l_24_1[key] then
      assert(l_24_3[key], "[EnvironmentMixer] Mixing failed, parameters does not match.")
    end
     -- DECOMPILER ERROR: unhandled construct in 'if'

    if type(value) == "string" and l_24_4 >= 0.5 then
      l_24_1[key] = value
      for (for control),key in (for generator) do
        local invscale = 1 - l_24_4
        l_24_1[key] = value * invscale + l_24_3[key] * l_24_4
      end
    end
     -- Warning: missing end command somewhere! Added here
  end
end


