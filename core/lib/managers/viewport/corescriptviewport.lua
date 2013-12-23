-- Decompiled using luadec 2.0.1 by sztupy (http://winmo.sztupy.hu)
-- Command line was: F:\SteamLibrary\SteamApps\common\PAYDAY 2\lua\core\lib\managers\viewport\corescriptviewport.luac 

core:module("CoreScriptViewport")
core:import("CoreApp")
core:import("CoreMath")
core:import("CoreCode")
core:import("CoreAccessObjectBase")
core:import("CoreEnvironmentMixer")
core:import("CoreEnvironmentFeeder")
if not _ScriptViewport then
  _ScriptViewport = class(CoreAccessObjectBase.AccessObjectBase)
end
DEFAULT_NETWORK_PORT = 31254
DEFAULT_NETWORK_LSPORT = 31255
VPSLAVE_ARG_NAME = "-vpslave"
NETWORK_SLAVE_RECEIVER = Idstring("scriptviewport_slave")
NETWORK_MASTER_RECEIVER = Idstring("scriptviewport_master")
_ScriptViewport.init = function(l_1_0, l_1_1, l_1_2, l_1_3, l_1_4, l_1_5, l_1_6)
  _ScriptViewport.super.init(l_1_0, l_1_5, l_1_6)
  l_1_0._vp = Application:create_world_viewport(l_1_1, l_1_2, l_1_3, l_1_4)
  l_1_0._vpm = l_1_5
  l_1_0._slave = false
  l_1_0._master = false
  l_1_0._manual_net_pumping = false
  l_1_0._pump_net = false
  l_1_0._replaced_vp = false
  l_1_0._width_mul_enabled = true
  l_1_0._mixer = CoreEnvironmentMixer.EnvironmentMixer:new(l_1_5:_get_environment_cache(), "core/environments/default")
  l_1_0._feeder = CoreEnvironmentFeeder.EnvironmentFeeder:new()
  if not Global.render_debug.render_sky or not {"World", l_1_0._vp, nil, "Underlay", l_1_0._vp} then
    l_1_0._render_params = {"World", l_1_0._vp, nil}
  end
  if CoreApp.arg_supplied(VPSLAVE_ARG_NAME) then
    local port = CoreApp.arg_value(VPSLAVE_ARG_NAME)
    if port then
      port = string.lower(port)
      if port ~= "default" or not DEFAULT_NETWORK_PORT then
        port = tonumber(port)
      end
    end
    l_1_0:enable_slave(port)
  end
  l_1_0._editor_callback = nil
  l_1_0._init_trace = debug.traceback()
end

_ScriptViewport.pump_network = function(l_2_0)
  if l_2_0._manual_net_pumping then
    l_2_0._pump_net = true
  end
end

_ScriptViewport.enable_slave = function(l_3_0, l_3_1)
  Network:bind(l_3_1 or DEFAULT_NETWORK_PORT, l_3_0)
  Network:set_receiver(NETWORK_SLAVE_RECEIVER, l_3_0)
  l_3_0._slave = true
end

_ScriptViewport.enable_master = function(l_4_0, l_4_1, l_4_2, l_4_3, l_4_4)
  l_4_0._remote_slave = Network:handshake(l_4_1 or "localhost", l_4_2 or DEFAULT_NETWORK_PORT)
  if l_4_0._remote_slave then
    l_4_0._master = true
    l_4_0._manual_net_pumping = l_4_4
    Network:bind(l_4_3 or DEFAULT_NETWORK_LSPORT, l_4_0)
    Network:set_receiver(NETWORK_MASTER_RECEIVER, l_4_0)
    assert(l_4_0._vp:camera())
    l_4_0:remote_update("scriptviewport_update_camera_settings", l_4_0._vp:camera():near_range(), l_4_0._vp:camera():far_range(), l_4_0._vp:camera():fov())
  end
end

_ScriptViewport.disable_slave_or_master = function(l_5_0)
  Network:unbind()
  l_5_0._slave = false
  l_5_0._master = false
  l_5_0._manual_net_pumping = false
  l_5_0._pump_net = false
end

_ScriptViewport.render_params = function(l_6_0)
  return l_6_0._render_params
end

_ScriptViewport.set_render_params = function(l_7_0, ...)
  l_7_0._render_params = {...}
   -- DECOMPILER ERROR: Confused about usage of registers for local variables.

end

_ScriptViewport.destroy = function(l_8_0)
  l_8_0:set_active(false)
  local vp = (not l_8_0._replaced_vp and l_8_0._vp)
  if CoreCode.alive(vp) then
    Application:destroy_viewport(vp)
  end
  l_8_0._vpm:_viewport_destroyed(l_8_0)
end

_ScriptViewport.set_width_mul_enabled = function(l_9_0, l_9_1)
  l_9_0._width_mul_enabled = l_9_1
end

_ScriptViewport.width_mul_enabled = function(l_10_0)
  return l_10_0._width_mul_enabled
end

_ScriptViewport.environment_mixer = function(l_11_0)
  return l_11_0._mixer
end

_ScriptViewport.set_camera = function(l_12_0, l_12_1)
  l_12_0._vp:set_camera(l_12_1)
  l_12_0:_set_width_multiplier()
end

_ScriptViewport.camera = function(l_13_0)
  return l_13_0._vp:camera()
end

_ScriptViewport.director = function(l_14_0)
  return l_14_0._vp:director()
end

_ScriptViewport.shaker = function(l_15_0)
  return l_15_0:director():shaker()
end

_ScriptViewport.vp = function(l_16_0)
  return l_16_0._vp
end

_ScriptViewport.alive = function(l_17_0)
  return CoreCode.alive(l_17_0._vp)
end

_ScriptViewport.reference_fov = function(l_18_0)
  return l_18_0._mixer:internal_ref_fov(l_18_0._vp, l_18_0._render_params[1])
end

_ScriptViewport.push_ref_fov = function(l_19_0, l_19_1)
  return l_19_0._mixer:internal_push_ref_fov(l_19_1, l_19_0._vp, l_19_0._render_params[1])
end

_ScriptViewport.pop_ref_fov = function(l_20_0)
  return l_20_0._mixer:internal_pop_ref_fov(l_20_0._vp, l_20_0._render_params[1])
end

_ScriptViewport.set_visualization_mode = function(l_21_0, l_21_1)
  l_21_0._mixer:internal_set_visualization_mode(l_21_1, l_21_0._vp, l_21_0._render_params[1])
end

_ScriptViewport.visualization_modes = function(l_22_0)
  return l_22_0._mixer:internal_visualization_modes()
end

_ScriptViewport.is_rendering_scene = function(l_23_0, l_23_1)
  for _,param in ipairs(l_23_0:render_params()) do
    if param == l_23_1 then
      return true
    end
  end
  return false
end

_ScriptViewport.set_dof = function(l_24_0, l_24_1, l_24_2, l_24_3, l_24_4, l_24_5)
end

_ScriptViewport.replace_engine_vp = function(l_25_0, l_25_1)
  l_25_0:destroy()
  l_25_0._replaced_vp = true
  l_25_0._vp = l_25_1
end

_ScriptViewport.feed_now = function(l_26_0, l_26_1)
  if l_26_0._editor_callback then
    l_26_0._editor_callback(l_26_0._mixer._target_env)
  end
  if not l_26_0._remote_editor then
    l_26_0._feeder:set_slaving(l_26_0._editor_callback)
  end
  local id = Profiler:start("Environment Feeders")
  l_26_0._feeder:feed(l_26_0._mixer:internal_output(), l_26_1 or 1, l_26_0._render_params[1], l_26_0._vp)
  Profiler:stop(id)
end

_ScriptViewport.reset_network_cache = function(l_27_0)
  if l_27_0._master then
    l_27_0:remote_update("scriptviewport_reset_network_cache", l_27_0._editor_callback)
  end
end

_ScriptViewport.scriptviewport_update_position = function(l_28_0, l_28_1)
  if l_28_0._vp:camera() then
    l_28_0._vp:camera():set_position(l_28_1)
  end
end

_ScriptViewport.scriptviewport_update_rotation = function(l_29_0, l_29_1)
  if l_29_0._vp:camera() then
    l_29_0._vp:camera():set_rotation(l_29_1)
  end
end

_ScriptViewport.scriptviewport_update_environment = function(l_30_0, l_30_1, l_30_2, l_30_3)
  if not l_30_0._env_net_cache or not l_30_0._sky_rot_cache or l_30_0._env_net_cache ~= l_30_1 or l_30_0._sky_rot_cache ~= l_30_2 then
    l_30_0._env_net_cache = l_30_1
    l_30_0._sky_rot_cache = l_30_2
    l_30_0._mixer:set_environment(l_30_1)
    if managers.worlddefinition and managers.worlddefinition.release_sky_orientation_modifier then
      managers.worlddefinition:release_sky_orientation_modifier()
    end
    l_30_0._sky_yaw = l_30_2
    if not l_30_0._environment_modifier_id then
      l_30_0._environment_modifier_id = l_30_0:create_environment_modifier(false, function()
      return self._sky_yaw
      end, "sky_orientation")
    end
  end
  l_30_3:scriptviewport_verify_environment(l_30_1, l_30_2)
end

_ScriptViewport.scriptviewport_update_camera_settings = function(l_31_0, l_31_1, l_31_2, l_31_3)
  if l_31_0._vp:camera() then
    l_31_0._vp:camera():set_near_range(l_31_1)
    l_31_0._vp:camera():set_far_range(l_31_2)
    l_31_0._vp:camera():set_fov(l_31_3)
  end
end

_ScriptViewport.scriptviewport_verify_environment = function(l_32_0, l_32_1, l_32_2)
  l_32_0._env_net_cache = l_32_1
  l_32_0._sky_rot_cache = l_32_2
end

_ScriptViewport.scriptviewport_reset_network_cache = function(l_33_0, l_33_1, l_33_2)
  l_33_0._env_net_cache = nil
  l_33_0._sky_rot_cache = nil
  l_33_0._remote_editor = l_33_1
  l_33_0:feed_now(1)
  l_33_2:scriptviewport_verify_reset_network_cache()
end

_ScriptViewport.scriptviewport_verify_reset_network_cache = function(l_34_0)
  l_34_0._env_net_cache = nil
  l_34_0._sky_rot_cache = nil
end

_ScriptViewport._update = function(l_35_0, l_35_1, l_35_2, l_35_3)
  l_35_0._vp:update()
  l_35_0._feed = l_35_0._mixer:internal_update(l_35_1, l_35_2, l_35_3)
  if l_35_0._master and (not l_35_0._manual_net_pumping or l_35_0._pump_net) then
    if not l_35_0._vp:camera() or not l_35_0._vp:camera():position() then
      l_35_0:remote_update("scriptviewport_update_position", Vector3())
    end
    if not l_35_0._vp:camera() or not l_35_0._vp:camera():rotation() then
      l_35_0:remote_update("scriptviewport_update_rotation", Rotation())
    end
    if not Underlay:get_object(Idstring("skysphere")) then
      local object = Underlay:get_object(Idstring("g_skysphere"))
    end
    if not object then
      return 
    end
    local sky_yaw = -object:rotation():yaw()
    local current_env = l_35_0._mixer:current_environment()
    if not l_35_0._env_net_cache or not l_35_0._sky_rot_cache or l_35_0._env_net_cache ~= current_env or l_35_0._sky_rot_cache ~= sky_yaw then
      l_35_0:remote_update("scriptviewport_update_environment", current_env, sky_yaw)
    end
    l_35_0._pump_net = false
  end
end

_ScriptViewport.remote_update = function(l_36_0, l_36_1, ...)
  if l_36_0._master then
    l_36_0._remote_slave[l_36_1](l_36_0._remote_slave, ...)
     -- DECOMPILER ERROR: Confused about usage of registers for local variables.

  end
end

_ScriptViewport._render = function(l_37_0, l_37_1)
  if Global.render_debug.render_world then
    if l_37_0._feed then
      l_37_0:feed_now(l_37_1)
    end
    Application:render(unpack(l_37_0._render_params))
  end
end

_ScriptViewport._resolution_changed = function(l_38_0)
  l_38_0:_set_width_multiplier()
end

_ScriptViewport._set_width_multiplier = function(l_39_0)
  local camera = l_39_0:camera()
  if CoreCode.alive(camera) and l_39_0._width_mul_enabled then
    local screen_res = Application:screen_resolution()
    local screen_pixel_aspect = screen_res.x / screen_res.y
    local rect = l_39_0._vp:get_rect()
    local vp_pixel_aspect = screen_pixel_aspect
    if rect.ph > 0 then
      vp_pixel_aspect = rect.pw / rect.ph
    end
    camera:set_width_multiplier(CoreMath.width_mul(l_39_0._vpm:aspect_ratio()) * (vp_pixel_aspect / screen_pixel_aspect))
  end
end

_ScriptViewport._create_environment_modifier_debug = function(l_40_0, l_40_1, l_40_2, l_40_3, ...)
  return l_40_0._mixer:create_modifier(l_40_1, "debug", l_40_2, l_40_3, ...)
   -- DECOMPILER ERROR: Confused about usage of registers for local variables.

end

_ScriptViewport.feed_params = function(l_41_0)
  l_41_0._mixer:set_feed_params()
end

_ScriptViewport.editor_callback = function(l_42_0, l_42_1)
  l_42_0._editor_callback = l_42_1
end

_ScriptViewport.set_environment = function(l_43_0, l_43_1, l_43_2)
  l_43_0._mixer:set_environment(l_43_1, l_43_2)
end

_ScriptViewport.environment = function(l_44_0)
  return l_44_0._mixer:current_environment()
end

_ScriptViewport.create_environment_modifier = function(l_45_0, l_45_1, l_45_2, l_45_3)
  return l_45_0._mixer:create_modifier(l_45_1, l_45_3, l_45_2)
end

_ScriptViewport.destroy_environment_modifier = function(l_46_0, l_46_1)
  return l_46_0._mixer:destroy_modifier(l_46_1)
end


