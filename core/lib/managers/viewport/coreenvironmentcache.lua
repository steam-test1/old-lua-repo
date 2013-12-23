-- Decompiled using luadec 2.0.1 by sztupy (http://winmo.sztupy.hu)
-- Command line was: F:\SteamLibrary\SteamApps\common\PAYDAY 2\lua\core\lib\managers\viewport\coreenvironmentcache.luac 

core:module("CoreEnvironmentCache")
core:import("CoreClass")
core:import("CoreEnvironmentData")
if not EnvironmentCache then
  EnvironmentCache = CoreClass.class()
end
EnvironmentCache.init = function(l_1_0)
  l_1_0._full_control_handles = {}
  l_1_0._part_control_handles = {}
  l_1_0._preloaded_environments = {}
end

EnvironmentCache.set_shared_handle = function(l_2_0, l_2_1, l_2_2, l_2_3)
  if l_2_1 then
    l_2_0._full_control_handles[l_2_2] = l_2_3
  else
    l_2_0._part_control_handles[l_2_2] = l_2_3
  end
  return l_2_2
end

EnvironmentCache.destroy_shared_handle = function(l_3_0, l_3_1)
  if not l_3_0._full_control_handles[l_3_1] then
    local handle = l_3_0._part_control_handles[l_3_1]
  end
  l_3_0._full_control_handles[l_3_1] = nil
  l_3_0._part_control_handles[l_3_1] = nil
  assert(handle, "[EnvironmentMixer] No handle!")
end

EnvironmentCache.shared_handle = function(l_4_0, l_4_1, l_4_2)
  if l_4_1 == true then
    return l_4_0._full_control_handles[l_4_2]
  elseif l_4_1 == false then
    return l_4_0._part_control_handles[l_4_2]
  else
    if not l_4_0._full_control_handles[l_4_2] then
      return l_4_0._part_control_handles[l_4_2]
    end
  end
end

EnvironmentCache.load_environment = function(l_5_0, l_5_1)
  local env = l_5_0._preloaded_environments[l_5_1]
  if not env then
    if not Application:editor() then
      Application:error("[EnvironmentCache] WARNING! Environment was not preloaded: " .. l_5_1)
    end
    l_5_0:preload_environment(l_5_1)
    env = l_5_0._preloaded_environments[l_5_1]
  end
  return env
end

EnvironmentCache.copy_environment = function(l_6_0, l_6_1)
  local env = l_6_0:load_environment(l_6_1)
  return env:copy()
end

EnvironmentCache.preload_environment = function(l_7_0, l_7_1)
  if not l_7_0._preloaded_environments[l_7_1] then
    l_7_0._preloaded_environments[l_7_1] = CoreEnvironmentData.EnvironmentData:new(l_7_1)
  end
end

EnvironmentCache.environment = function(l_8_0, l_8_1)
  return l_8_0:load_environment(l_8_1)
end


