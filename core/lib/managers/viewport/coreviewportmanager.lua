-- Decompiled using luadec 2.0.1 by sztupy (http://winmo.sztupy.hu)
-- Command line was: F:\SteamLibrary\SteamApps\common\PAYDAY 2\lua\core\lib\managers\viewport\coreviewportmanager.luac 

core:module("CoreViewportManager")
core:import("CoreApp")
core:import("CoreCode")
core:import("CoreEvent")
core:import("CoreManagerBase")
core:import("CoreScriptViewport")
core:import("CoreEnvironmentCache")
if not ViewportManager then
  ViewportManager = class(CoreManagerBase.ManagerBase)
end
ViewportManager.init = function(l_1_0, l_1_1)
  ViewportManager.super.init(l_1_0, "viewport")
  assert(type(l_1_1) == "number")
  l_1_0._aspect_ratio = l_1_1
  l_1_0._resolution_changed_event_handler = CoreEvent.CallbackEventHandler:new()
  l_1_0._environment_cache = CoreEnvironmentCache.EnvironmentCache:new()
  Global.render_debug.render_sky = true
  l_1_0._current_camera_position = Vector3()
end

ViewportManager.update = function(l_2_0, l_2_1, l_2_2)
  for i,svp in ipairs(l_2_0:_all_really_active()) do
    svp:_update(i, l_2_1, l_2_2)
  end
end

ViewportManager.paused_update = function(l_3_0, l_3_1, l_3_2)
  l_3_0:update(l_3_1, l_3_2)
end

ViewportManager.render = function(l_4_0)
  for i,svp in ipairs(l_4_0:_all_really_active()) do
    svp:_render(i)
  end
end

ViewportManager.end_frame = function(l_5_0, l_5_1, l_5_2)
  if l_5_0._render_settings_change_map.resolution == nil then
    local is_resolution_changed = not l_5_0._render_settings_change_map
  end
  for setting_name,setting_value in pairs(l_5_0._render_settings_change_map) do
    RenderSettings[setting_name] = setting_value
  end
  l_5_0._render_settings_change_map = nil
  Application:apply_render_settings()
  Application:save_render_settings()
  if is_resolution_changed then
    l_5_0:resolution_changed()
  end
  l_5_0._current_camera = nil
  l_5_0._current_camera_position_updated = nil
  l_5_0._current_camera_rotation = nil
end

ViewportManager.destroy = function(l_6_0)
  for _,svp in pairs(l_6_0:_all_ao()) do
    svp:destroy()
  end
end

ViewportManager.new_vp = function(l_7_0, l_7_1, l_7_2, l_7_3, l_7_4, l_7_5, l_7_6)
  local name = l_7_5 or ""
  if not l_7_6 then
    local prio = CoreManagerBase.PRIO_DEFAULT
  end
  local svp = CoreScriptViewport._ScriptViewport:new(l_7_1, l_7_2, l_7_3, l_7_4, l_7_0, name)
  l_7_0:_add_accessobj(svp, prio)
  return svp
end

ViewportManager.vp_by_name = function(l_8_0, l_8_1)
  return l_8_0:_ao_by_name(l_8_1)
end

ViewportManager.active_viewports = function(l_9_0)
  return l_9_0:_all_active_requested_by_prio(CoreManagerBase.PRIO_DEFAULT)
end

ViewportManager.all_really_active_viewports = function(l_10_0)
  return l_10_0:_all_really_active()
end

ViewportManager.num_active_viewports = function(l_11_0)
  return #l_11_0:active_viewports()
end

ViewportManager.first_active_viewport = function(l_12_0)
  local all_active = l_12_0:_all_really_active()
  return #all_active > 0 and all_active[1] or nil
end

ViewportManager.viewports = function(l_13_0)
  return l_13_0:_all_ao()
end

ViewportManager.add_resolution_changed_func = function(l_14_0, l_14_1)
  l_14_0._resolution_changed_event_handler:add(l_14_1)
  return l_14_1
end

ViewportManager.remove_resolution_changed_func = function(l_15_0, l_15_1)
  l_15_0._resolution_changed_event_handler:remove(l_15_1)
end

ViewportManager.resolution_changed = function(l_16_0)
  managers.gui_data:resolution_changed()
  if rawget(_G, "tweak_data").resolution_changed then
    rawget(_G, "tweak_data"):resolution_changed()
  end
  for i,svp in ipairs(l_16_0:viewports()) do
    svp:_resolution_changed(i)
  end
  l_16_0._resolution_changed_event_handler:dispatch()
end

ViewportManager.preload_environment = function(l_17_0, l_17_1)
  l_17_0._environment_cache:preload_environment(l_17_1)
end

ViewportManager.get_environment_cache = function(l_18_0)
  return l_18_0._environment_cache
end

ViewportManager._viewport_destroyed = function(l_19_0, l_19_1)
  l_19_0:_del_accessobj(l_19_1)
end

ViewportManager._get_environment_cache = function(l_20_0)
  return l_20_0._environment_cache
end

ViewportManager.first_active_world_viewport = function(l_21_0)
  for _,vp in ipairs(l_21_0:active_viewports()) do
    if vp:is_rendering_scene("World") then
      return vp
    end
  end
end

ViewportManager.get_current_camera = function(l_22_0)
  if l_22_0._current_camera then
    return l_22_0._current_camera
  end
  local vps = l_22_0:_all_really_active()
  l_22_0._current_camera = (#vps > 0 and vps[1]:camera())
  return l_22_0._current_camera
end

ViewportManager.get_current_camera_position = function(l_23_0)
  if l_23_0._current_camera_position_updated then
    return l_23_0._current_camera_position
  end
  if l_23_0:get_current_camera() then
    l_23_0:get_current_camera():m_position(l_23_0._current_camera_position)
    l_23_0._current_camera_position_updated = true
  end
  return l_23_0._current_camera_position
end

ViewportManager.get_current_camera_rotation = function(l_24_0)
  if l_24_0._current_camera_rotation then
    return l_24_0._current_camera_rotation
  end
  if l_24_0:get_current_camera() then
    l_24_0._current_camera_rotation = l_24_0:get_current_camera():rotation()
  end
  return l_24_0._current_camera_rotation
end

ViewportManager.get_active_vp = function(l_25_0)
  return l_25_0:active_vp():vp()
end

ViewportManager.active_vp = function(l_26_0)
  local vps = l_26_0:active_viewports()
  return (#vps > 0 and vps[1])
end

local is_win32 = SystemInfo:platform() == Idstring("WIN32")
ViewportManager.get_safe_rect = function(l_27_0)
  local a = is_win32 and 0.032000001519918 or 0.075000002980232
  local b = 1 - a * 2
  return {x = a, y = a, width = b, height = b}
end

ViewportManager.get_safe_rect_pixels = function(l_28_0)
  local res = RenderSettings.resolution
  local safe_rect_scale = l_28_0:get_safe_rect()
  local safe_rect_pixels = {}
  safe_rect_pixels.x = math.round(safe_rect_scale.x * res.x)
  safe_rect_pixels.y = math.round(safe_rect_scale.y * res.y)
  safe_rect_pixels.width = math.round(safe_rect_scale.width * res.x)
  safe_rect_pixels.height = math.round(safe_rect_scale.height * res.y)
  return safe_rect_pixels
end

ViewportManager.set_resolution = function(l_29_0, l_29_1)
  if RenderSettings.resolution ~= l_29_1 or l_29_0._render_settings_change_map and l_29_0._render_settings_change_map.resolution ~= l_29_1 then
    if not l_29_0._render_settings_change_map then
      l_29_0._render_settings_change_map = {}
    end
    l_29_0._render_settings_change_map.resolution = l_29_1
  end
end

ViewportManager.set_fullscreen = function(l_30_0, l_30_1)
  if not RenderSettings.fullscreen ~= not l_30_1 or l_30_0._render_settings_change_map and not l_30_0._render_settings_change_map.fullscreen ~= not l_30_1 then
    if not l_30_0._render_settings_change_map then
      l_30_0._render_settings_change_map = {}
    end
    l_30_0._render_settings_change_map.fullscreen = not not l_30_1
  end
end

ViewportManager.set_aspect_ratio = function(l_31_0, l_31_1)
  if RenderSettings.aspect_ratio ~= l_31_1 or l_31_0._render_settings_change_map and l_31_0._render_settings_change_map.aspect_ratio ~= l_31_1 then
    if not l_31_0._render_settings_change_map then
      l_31_0._render_settings_change_map = {}
    end
    l_31_0._render_settings_change_map.aspect_ratio = l_31_1
    l_31_0._aspect_ratio = l_31_1
  end
end

ViewportManager.set_vsync = function(l_32_0, l_32_1)
  if RenderSettings.v_sync ~= l_32_1 or l_32_0._render_settings_change_map and l_32_0._render_settings_change_map.v_sync ~= l_32_1 then
    if not l_32_0._render_settings_change_map then
      l_32_0._render_settings_change_map = {}
    end
    l_32_0._render_settings_change_map.v_sync = l_32_1
    l_32_0._v_sync = l_32_1
  end
end

ViewportManager.aspect_ratio = function(l_33_0)
  return l_33_0._aspect_ratio
end

ViewportManager.set_aspect_ratio2 = function(l_34_0, l_34_1)
  l_34_0._aspect_ratio = l_34_1
end


