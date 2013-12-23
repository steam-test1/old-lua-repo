-- Decompiled using luadec 2.0.1 by sztupy (http://winmo.sztupy.hu)
-- Command line was: F:\SteamLibrary\SteamApps\common\PAYDAY 2\lua\core\lib\managers\coreenvironmentcontrollermanager.luac 

local tmp_vec1 = Vector3()
local tmp_vec2 = Vector3()
local tmp_vec3 = Vector3()
local flashbang_test_offset = Vector3(0, 0, 150)
local debug_vec1 = Vector3()
if not CoreEnvironmentControllerManager then
  CoreEnvironmentControllerManager = class()
end
CoreEnvironmentControllerManager.init = function(l_1_0)
  l_1_0._DEFAULT_DOF_DISTANCE = 10
  l_1_0._dof_distance = l_1_0._DEFAULT_DOF_DISTANCE
  l_1_0._current_dof_distance = l_1_0._dof_distance
  l_1_0._hurt_value = 1
  l_1_0._taser_value = 1
  l_1_0._health_effect_value = 1
  l_1_0._suppression_value = 0
  l_1_0._current_suppression_value = 0
  l_1_0._old_suppression_value = 0
  l_1_0._supression_start_flash = 0
  l_1_0._old_health_effect_value = 1
  l_1_0._health_effect_value_diff = 0
  l_1_0._GAME_DEFAULT_COLOR_GRADING = "color_off"
  l_1_0._default_color_grading = l_1_0._GAME_DEFAULT_COLOR_GRADING
  l_1_0._blurzone = -1
  l_1_0._pos = nil
  l_1_0._radius = 0
  l_1_0._height = 0
  l_1_0._opacity = 0
  l_1_0._blurzone_update = nil
  l_1_0._blurzone_check = nil
  l_1_0._hit_right = 0
  l_1_0._hit_left = 0
  l_1_0._hit_up = 0
  l_1_0._hit_down = 0
  l_1_0._hit_front = 0
  l_1_0._hit_back = 0
  l_1_0._hit_some = 0
  l_1_0._hit_amount = 0.30000001192093
  l_1_0._hit_cap = 1
  l_1_0._current_flashbang = 0
  l_1_0._current_flashbang_flash = 0
  l_1_0._flashbang_multiplier = 1
  l_1_0._HE_blinding = 0
  l_1_0._downed_value = 0
  l_1_0._last_life = false
  l_1_0:_create_dof_tweak_data()
  l_1_0._current_dof_setting = "standard"
  l_1_0._near_plane_x = l_1_0._dof_tweaks[l_1_0._current_dof_setting].steelsight.near_plane_x
  l_1_0._near_plane_y = l_1_0._dof_tweaks[l_1_0._current_dof_setting].steelsight.near_plane_y
  l_1_0._far_plane_x = l_1_0._dof_tweaks[l_1_0._current_dof_setting].steelsight.far_plane_x
  l_1_0._far_plane_y = l_1_0._dof_tweaks[l_1_0._current_dof_setting].steelsight.far_plane_y
  l_1_0._dof_override = false
  l_1_0._dof_override_near = 5
  l_1_0._dof_override_near_pad = 5
  l_1_0._dof_override_far = 5000
  l_1_0._dof_override_far_pad = 1000
  l_1_0:set_dome_occ_default()
end

CoreEnvironmentControllerManager.update = function(l_2_0, l_2_1, l_2_2)
  l_2_0:_update_values(l_2_1, l_2_2)
  l_2_0:set_post_composite(l_2_1, l_2_2)
end

CoreEnvironmentControllerManager._update_values = function(l_3_0, l_3_1, l_3_2)
  if l_3_0._current_dof_distance ~= l_3_0._dof_distance then
    l_3_0._current_dof_distance = math.lerp(l_3_0._current_dof_distance, l_3_0._dof_distance, 5 * l_3_2)
  end
  if Global.debug_post_effects_enabled and l_3_0._current_suppression_value ~= l_3_0._suppression_value then
    l_3_0._current_suppression_value = math.step(l_3_0._current_suppression_value, l_3_0._suppression_value, 2 * l_3_2)
  end
end

CoreEnvironmentControllerManager.set_dof_distance = function(l_4_0, l_4_1, l_4_2, l_4_3)
  if not l_4_1 then
    l_4_0._dof_distance = math.max(l_4_0._DEFAULT_DOF_DISTANCE, l_4_0._DEFAULT_DOF_DISTANCE)
    l_4_0._in_steelsight = l_4_2
     -- Warning: missing end command somewhere! Added here
  end
end

CoreEnvironmentControllerManager.set_default_color_grading = function(l_5_0, l_5_1)
  if not l_5_1 then
    l_5_0._default_color_grading = l_5_0._GAME_DEFAULT_COLOR_GRADING
  end
end

CoreEnvironmentControllerManager.game_default_color_grading = function(l_6_0)
  return l_6_0._GAME_DEFAULT_COLOR_GRADING
end

CoreEnvironmentControllerManager.default_color_grading = function(l_7_0)
  return l_7_0._default_color_grading
end

CoreEnvironmentControllerManager.set_hurt_value = function(l_8_0, l_8_1)
  l_8_0._hurt_value = l_8_1
end

CoreEnvironmentControllerManager.set_health_effect_value = function(l_9_0, l_9_1)
  l_9_0._health_effect_value = l_9_1
end

CoreEnvironmentControllerManager.set_downed_value = function(l_10_0, l_10_1)
  l_10_0._downed_value = l_10_1
end

CoreEnvironmentControllerManager.set_last_life = function(l_11_0, l_11_1)
  l_11_0._last_life = l_11_1
end

CoreEnvironmentControllerManager.hurt_value = function(l_12_0)
  return l_12_0._hurt_value
end

CoreEnvironmentControllerManager.set_taser_value = function(l_13_0, l_13_1)
  l_13_0._taser_value = l_13_1
end

CoreEnvironmentControllerManager.taser_value = function(l_14_0)
  return l_14_0._taser_value
end

CoreEnvironmentControllerManager.set_suppression_value = function(l_15_0, l_15_1, l_15_2)
  l_15_0._suppression_value = l_15_1 > 0 and 1 or 0
end

CoreEnvironmentControllerManager.hit_feedback_front = function(l_16_0)
  l_16_0._hit_front = math.min(l_16_0._hit_front + l_16_0._hit_amount, 1)
  l_16_0._hit_some = math.min(l_16_0._hit_some + l_16_0._hit_amount, 1)
end

CoreEnvironmentControllerManager.hit_feedback_back = function(l_17_0)
  l_17_0._hit_back = math.min(l_17_0._hit_back + l_17_0._hit_amount, 1)
  l_17_0._hit_some = math.min(l_17_0._hit_some + l_17_0._hit_amount, 1)
end

CoreEnvironmentControllerManager.hit_feedback_right = function(l_18_0)
  l_18_0._hit_right = math.min(l_18_0._hit_right + l_18_0._hit_amount, 1)
  l_18_0._hit_some = math.min(l_18_0._hit_some + l_18_0._hit_amount, 1)
end

CoreEnvironmentControllerManager.hit_feedback_left = function(l_19_0)
  l_19_0._hit_left = math.min(l_19_0._hit_left + l_19_0._hit_amount, 1)
  l_19_0._hit_some = math.min(l_19_0._hit_some + l_19_0._hit_amount, 1)
end

CoreEnvironmentControllerManager.hit_feedback_up = function(l_20_0)
  l_20_0._hit_up = math.min(l_20_0._hit_up + l_20_0._hit_amount, 1)
  l_20_0._hit_some = math.min(l_20_0._hit_some + l_20_0._hit_amount, 1)
end

CoreEnvironmentControllerManager.hit_feedback_down = function(l_21_0)
  l_21_0._hit_down = math.min(l_21_0._hit_down + l_21_0._hit_amount, 1)
  l_21_0._hit_some = math.min(l_21_0._hit_some + l_21_0._hit_amount, 1)
end

CoreEnvironmentControllerManager.set_blurzone = function(l_22_0, l_22_1, l_22_2, l_22_3, l_22_4)
  if l_22_1 > 0 then
    l_22_0._blurzone = l_22_1
    l_22_0._pos = l_22_2
    l_22_0._radius = l_22_3
    l_22_0._height = l_22_4
    if l_22_1 == 2 then
      l_22_0._opacity = 2
      l_22_0._blurzone = 1
      l_22_0._blurzone_update = l_22_0.blurzone_flash_in_line_of_sight
    elseif l_22_1 == 3 then
      l_22_0._opacity = 2
      l_22_0._blurzone = 1
      l_22_0._blurzone_update = l_22_0.blurzone_flash_in
    else
      l_22_0._opacity = 0
      l_22_0._blurzone_update = l_22_0.blurzone_fade_in
    end
    if l_22_4 > 0 then
      l_22_0._blurzone_check = l_22_0.blurzone_check_cylinder
    else
      l_22_0._blurzone_check = l_22_0.blurzone_check_sphere
    end
  elseif l_22_0._blurzone > 0 then
    l_22_0._blurzone = l_22_1
    l_22_0._pos = l_22_0._pos or l_22_2
    l_22_0._radius = l_22_0._radius or l_22_3
    l_22_0._height = l_22_0._height or l_22_4
    l_22_0._opacity = 1
    l_22_0._blurzone_update = l_22_0.blurzone_fade_out
    if l_22_0._height > 0 then
      l_22_0._blurzone_check = l_22_0.blurzone_check_cylinder
    else
      l_22_0._blurzone_check = l_22_0.blurzone_check_sphere
    end
  end
end

CoreEnvironmentControllerManager.blurzone_flash_in_line_of_sight = function(l_23_0, l_23_1, l_23_2, l_23_3)
  l_23_0._opacity = l_23_0._opacity - l_23_2 * 0.30000001192093
  l_23_0._HE_blinding = l_23_0.test_line_of_sight(l_23_0._pos, 150, 1000, 2000)
  if l_23_0._opacity < 1 then
    l_23_0._opacity = 1
    l_23_0._blurzone_update = l_23_0.blurzone_fade_idle_line_of_sight
  end
  return l_23_0:_blurzone_check(l_23_3) * (1 + 11 * (l_23_0._opacity - 1))
end

CoreEnvironmentControllerManager.blurzone_flash_in = function(l_24_0, l_24_1, l_24_2, l_24_3)
  l_24_0._opacity = l_24_0._opacity - l_24_2 * 0.30000001192093
  if l_24_0._opacity < 1 then
    l_24_0._opacity = 1
    l_24_0._blurzone_update = l_24_0.blurzone_fade_idle
  end
  return l_24_0:_blurzone_check(l_24_3) * (1 + 11 * (l_24_0._opacity - 1))
end

CoreEnvironmentControllerManager.blurzone_fade_in = function(l_25_0, l_25_1, l_25_2, l_25_3)
  l_25_0._opacity = l_25_0._opacity + l_25_2
  if l_25_0._opacity > 1 then
    l_25_0._opacity = 1
    l_25_0._blurzone_update = l_25_0.blurzone_fade_idle
  end
  return l_25_0:_blurzone_check(l_25_3)
end

CoreEnvironmentControllerManager.blurzone_fade_out = function(l_26_0, l_26_1, l_26_2, l_26_3)
  l_26_0._opacity = l_26_0._opacity - l_26_2
  if l_26_0._opacity < 0 then
    l_26_0._opacity = 0
    l_26_0._blurzone = -1
    l_26_0._blurzone_update = l_26_0.blurzone_fade_idle
  end
  return l_26_0:_blurzone_check(l_26_3)
end

CoreEnvironmentControllerManager.blurzone_fade_idle_line_of_sight = function(l_27_0, l_27_1, l_27_2, l_27_3)
  l_27_0._HE_blinding = l_27_0.test_line_of_sight(l_27_0._pos, 150, 1000, 2000)
  return l_27_0:_blurzone_check(l_27_3)
end

CoreEnvironmentControllerManager.blurzone_fade_idle = function(l_28_0, l_28_1, l_28_2, l_28_3)
  return l_28_0:_blurzone_check(l_28_3)
end

CoreEnvironmentControllerManager.blurzone_fade_out_switch = function(l_29_0, l_29_1, l_29_2, l_29_3)
  return l_29_0:_blurzone_check(l_29_3)
end

CoreEnvironmentControllerManager.blurzone_check_cylinder = function(l_30_0, l_30_1)
  local pos_z = l_30_0._pos.z
  local cam_z = l_30_1.z
  local len = nil
  if cam_z < pos_z then
    len = l_30_0._pos - l_30_1:length()
  else
    if pos_z + l_30_0._height < cam_z then
      len = l_30_0._pos:with_z(pos_z + l_30_0._height) - l_30_1:length()
    else
      len = l_30_0._pos:with_z(cam_z) - l_30_1:length()
    end
  end
  local result = math.min(len / l_30_0._radius, 1)
  result = result * result
  return (1 - result) * l_30_0._opacity
end

CoreEnvironmentControllerManager.blurzone_check_sphere = function(l_31_0, l_31_1)
  local len = l_31_0._pos - l_31_1:length()
  local result = math.min(len / l_31_0._radius, 1)
  result = result * result
  return (1 - result) * l_31_0._opacity
end

local ids_dof_near_plane = Idstring("near_plane")
local ids_dof_far_plane = Idstring("far_plane")
local ids_dof_settings = Idstring("settings")
local ids_radial_pos = Idstring("radial_pos")
local ids_radial_offset = Idstring("radial_offset")
local ids_tgl_r = Idstring("tgl_r")
local hit_feedback_rlu = Idstring("hit_feedback_rlu")
local hit_feedback_d = Idstring("hit_feedback_d")
local ids_hdr_post_processor = Idstring("hdr_post_processor")
local ids_hdr_post_composite = Idstring("post_DOF")
local mvec1 = Vector3()
local mvec2 = Vector3()
local new_cam_fwd = Vector3()
local new_cam_up = Vector3()
local new_cam_right = Vector3()
local ids_LUT_post = Idstring("color_grading_post")
local ids_LUT_settings = Idstring("lut_settings")
local ids_LUT_settings_a = Idstring("LUT_settings_a")
local ids_LUT_settings_b = Idstring("LUT_settings_b")
local ids_LUT_contrast = Idstring("contrast")
CoreEnvironmentControllerManager.refresh_render_settings = function(l_32_0, l_32_1)
  if not alive(l_32_0._vp) then
    return 
  end
  if Global.level_data and Global.level_data.level_id then
    local lvl_tweak_data = tweak_data.levels[Global.level_data.level_id]
  end
  local cubemap_name = lvl_tweak_data and lvl_tweak_data.cube or "cube_apply_empty"
  l_32_0._vp:vp():set_post_processor_effect("World", Idstring("color_grading_post"), Idstring(l_32_0._default_color_grading))
  l_32_0._vp:vp():set_post_processor_effect("World", ids_hdr_post_processor, Idstring(managers.user:get_setting("light_adaption") and "default" or "no_light_adaption"))
end

CoreEnvironmentControllerManager.set_post_composite = function(l_33_0, l_33_1, l_33_2)
  local vp = managers.viewport:first_active_viewport()
  if not vp then
    return 
  end
  if l_33_0._occ_dirty then
    l_33_0._occ_dirty = false
    l_33_0:_refresh_occ_params(vp)
  end
  if l_33_0._vp ~= vp then
    local hdr_post_processor = vp:vp():get_post_processor_effect("World", ids_hdr_post_processor)
    if hdr_post_processor then
      local post_composite = hdr_post_processor:modifier(ids_hdr_post_composite)
      if not post_composite then
        return 
      end
      l_33_0._material = post_composite:material()
      if not l_33_0._material then
        return 
      end
      l_33_0._vp = vp
    end
  end
  local camera = vp:camera()
  local color_tweak = mvec1
   -- DECOMPILER ERROR: unhandled construct in 'if'

  if not camera or l_33_0._old_vp ~= vp then
    l_33_0._occ_dirty = true
    l_33_0:refresh_render_settings()
    l_33_0._old_vp = vp
  end
  local blur_zone_val = 0
  if l_33_0._blurzone >= 0 then
    blur_zone_val = l_33_0:_blurzone_update(l_33_1, l_33_2, camera:position())
  end
  if l_33_0._hit_some > 0 then
    local hit_fade = l_33_2 * 1.5
    l_33_0._hit_some = math.max(l_33_0._hit_some - hit_fade, 0)
    l_33_0._hit_right = math.max(l_33_0._hit_right - hit_fade, 0)
    l_33_0._hit_left = math.max(l_33_0._hit_left - hit_fade, 0)
    l_33_0._hit_up = math.max(l_33_0._hit_up - hit_fade, 0)
    l_33_0._hit_down = math.max(l_33_0._hit_down - hit_fade, 0)
    l_33_0._hit_front = math.max(l_33_0._hit_front - hit_fade, 0)
    l_33_0._hit_back = math.max(l_33_0._hit_back - hit_fade, 0)
  end
  local flashbang = 0
  local flashbang_flash = 0
  if l_33_0._current_flashbang > 0 then
    l_33_0._current_flashbang = math.max(l_33_0._current_flashbang - l_33_2 * 0.079999998211861 * l_33_0._flashbang_multiplier, 0)
    flashbang = math.min(l_33_0._current_flashbang, 1)
    l_33_0._current_flashbang_flash = math.max(l_33_0._current_flashbang_flash - l_33_2 * 0.89999997615814, 0)
    flashbang_flash = math.min(l_33_0._current_flashbang_flash, 1)
  end
  local hit_some_mod = 1 - l_33_0._hit_some
  hit_some_mod = hit_some_mod * hit_some_mod * hit_some_mod
  hit_some_mod = 1 - hit_some_mod
  local downed_value = l_33_0._downed_value / 100
  local death_mod = math.max(1 - l_33_0._health_effect_value - 0.5, 0) * 2
  local blur_zone_flashbang = blur_zone_val + flashbang
  local flash_1 = math.pow(flashbang, 0.40000000596046)
  local flash_2 = math.pow(flashbang, 16) + flashbang_flash
  if flash_1 > 0 then
    l_33_0._material:set_variable(ids_dof_settings, Vector3(math.min(l_33_0._hit_some * 10, 1) + blur_zone_flashbang * 0.40000000596046, math.min(blur_zone_val + downed_value * 2 + flash_1, 1), 10 + math.abs(math.sin(l_33_1 * 10) * 40) + downed_value * 3))
  else
    l_33_0._material:set_variable(ids_dof_settings, Vector3(math.min(l_33_0._hit_some * 10, 1) + blur_zone_flashbang * 0.40000000596046, math.min(blur_zone_val + downed_value * 2, 1), 1 + downed_value * 3))
  end
  l_33_0._material:set_variable(ids_radial_offset, Vector3((l_33_0._hit_left - l_33_0._hit_right) * 0.20000000298023, (l_33_0._hit_up - l_33_0._hit_down) * 0.20000000298023, l_33_0._hit_front - l_33_0._hit_back + blur_zone_flashbang * 0.10000000149012))
  l_33_0._material:set_variable(Idstring("contrast"), 0.10000000149012 + l_33_0._hit_some * 0.25)
  l_33_0._material:set_variable(Idstring("chromatic_amount"), 0.15000000596046 + blur_zone_val * 0.30000001192093 + flash_1 * 0.5)
  l_33_0:_update_dof(l_33_1, l_33_2)
  local lut_post = vp:vp():get_post_processor_effect("World", ids_LUT_post)
  if lut_post then
    local lut_modifier = lut_post:modifier(ids_LUT_settings)
    if lut_modifier then
      do return end
    end
    return 
    l_33_0._lut_modifier_material = lut_modifier:material()
    if not l_33_0._lut_modifier_material then
      return 
    end
  end
  local hurt_mod = 1 - l_33_0._health_effect_value
  local health_diff = math.clamp((l_33_0._old_health_effect_value - l_33_0._health_effect_value) * 4, 0, 1)
  l_33_0._old_health_effect_value = l_33_0._health_effect_value
  if l_33_0._health_effect_value_diff < health_diff then
    l_33_0._health_effect_value_diff = health_diff
  end
  l_33_0._health_effect_value_diff = math.max(l_33_0._health_effect_value_diff - l_33_2 * 0.5, 0)
  l_33_0._lut_modifier_material:set_variable(ids_LUT_settings_a, Vector3(math.clamp(l_33_0._health_effect_value_diff * 1.2999999523163 * (1 + hurt_mod * 1.2999999523163), 0, 1.2000000476837), 0, math.min(blur_zone_val + l_33_0._HE_blinding, 1)))
  local last_life = 0
  if l_33_0._last_life then
    last_life = math.clamp((hurt_mod - 0.5) * 2, 0, 1)
  end
  l_33_0._lut_modifier_material:set_variable(ids_LUT_settings_b, Vector3(last_life, flash_2 + math.clamp((hit_some_mod) * 2, 0, 1) * 0.25 + blur_zone_val * 0.15000000596046, 0))
  l_33_0._lut_modifier_material:set_variable(ids_LUT_contrast, flashbang * 0.5)
end

CoreEnvironmentControllerManager._create_dof_tweak_data = function(l_34_0)
  local new_dof_settings = {}
  new_dof_settings.none = {use_no_dof = true}
  new_dof_settings.standard = {}
  new_dof_settings.standard.steelsight = {}
  new_dof_settings.standard.steelsight.near_plane_x = 2500
  new_dof_settings.standard.steelsight.near_plane_y = 2500
  new_dof_settings.standard.steelsight.far_plane_x = 500
  new_dof_settings.standard.steelsight.far_plane_y = 2000
  new_dof_settings.standard.other = {}
  new_dof_settings.standard.other.near_plane_x = 10
  new_dof_settings.standard.other.near_plane_y = 12
  new_dof_settings.standard.other.far_plane_x = 4000
  new_dof_settings.standard.other.far_plane_y = 5000
  l_34_0._dof_tweaks = new_dof_settings
end

CoreEnvironmentControllerManager.set_dof_setting = function(l_35_0, l_35_1)
  if not l_35_0._dof_tweaks[l_35_1] then
    Application:error("[CoreEnvironmentControllerManager:set_dof_setting] DOF setting do not exist!", l_35_1)
    return 
  end
  l_35_0._current_dof_setting = l_35_1
  if l_35_0._material then
    l_35_0:_update_dof(1, 1)
  end
end

CoreEnvironmentControllerManager.remove_dof_tweak_data = function(l_36_0, l_36_1)
  if not l_36_0._dof_tweaks[new_setting_name] then
    Application:error("[CoreEnvironmentControllerManager:remove_dof_tweak_data] DOF setting do not exist!", l_36_1)
    return 
  end
  l_36_0._dof_tweaks[l_36_1] = nil
  if l_36_0._current_dof_setting == l_36_1 then
    if l_36_0._dof_tweaks.standard then
      l_36_0._current_dof_setting = "standard"
    else
      l_36_0._current_dof_setting = next(l_36_0._dof_tweaks)
    end
  end
end

CoreEnvironmentControllerManager.add_dof_tweak_data = function(l_37_0, l_37_1, l_37_2)
  if l_37_0._dof_tweaks[l_37_1] then
    Application:error("[CoreEnvironmentControllerManager:add_dof_tweak_data] DOF setting already exists!", l_37_1)
    return 
  end
  l_37_0._dof_tweaks[l_37_1] = l_37_2
end

CoreEnvironmentControllerManager._update_dof = function(l_38_0, l_38_1, l_38_2)
  local mvec_set = mvector3.set_static
  local mvec = mvec1
  if l_38_0._dof_override then
    mvec_set(mvec, l_38_0._dof_override_near, l_38_0._dof_override_near + l_38_0._dof_override_near_pad, 0)
    l_38_0._material:set_variable(ids_dof_near_plane, mvec)
    mvec_set(mvec, l_38_0._dof_override_far - l_38_0._dof_override_far_pad, l_38_0._dof_override_far, 1)
    l_38_0._material:set_variable(ids_dof_far_plane, mvec)
  else
    local dof_settings = l_38_0._dof_tweaks[l_38_0._current_dof_setting]
    if dof_settings.use_no_dof == true then
      mvec_set(mvec, 0, 0, 0)
      l_38_0._material:set_variable(ids_dof_near_plane, mvec)
      mvec_set(mvec, 10000, 10000, 1)
      l_38_0._material:set_variable(ids_dof_far_plane, mvec)
    elseif l_38_0._in_steelsight then
      dof_settings = dof_settings.steelsight
      local dof_plane_v = math.clamp(l_38_0._current_dof_distance / 5000, 0, 1)
      l_38_0._near_plane_x = math.lerp(500, dof_settings.near_plane_x, dof_plane_v)
      l_38_0._near_plane_y = math.lerp(20, dof_settings.near_plane_y, dof_plane_v)
      l_38_0._far_plane_x = math.lerp(100, dof_settings.far_plane_x, dof_plane_v)
      l_38_0._far_plane_y = math.lerp(500, dof_settings.far_plane_y, dof_plane_v)
      mvec_set(mvec, math.max(l_38_0._current_dof_distance - l_38_0._near_plane_x, 5), l_38_0._near_plane_y, 0)
      l_38_0._material:set_variable(ids_dof_near_plane, mvec)
      mvec_set(mvec, l_38_0._current_dof_distance + l_38_0._far_plane_x, l_38_0._far_plane_y, 1)
      l_38_0._material:set_variable(ids_dof_far_plane, mvec)
    else
      dof_settings = dof_settings.other
      local dof_speed = math.min(10 * l_38_2, 1)
      l_38_0._near_plane_x = math.lerp(l_38_0._near_plane_x, dof_settings.near_plane_x, dof_speed)
      l_38_0._near_plane_y = math.lerp(l_38_0._near_plane_y, dof_settings.near_plane_y, dof_speed)
      l_38_0._far_plane_x = math.lerp(l_38_0._far_plane_x, dof_settings.far_plane_x, dof_speed)
      l_38_0._far_plane_y = math.lerp(l_38_0._far_plane_y, dof_settings.far_plane_y, dof_speed)
      mvec_set(mvec, l_38_0._near_plane_x, l_38_0._near_plane_y, 0)
      l_38_0._material:set_variable(ids_dof_near_plane, mvec)
      mvec_set(mvec, l_38_0._far_plane_x, l_38_0._far_plane_y, 1)
      l_38_0._material:set_variable(ids_dof_far_plane, mvec)
    end
  end
end

CoreEnvironmentControllerManager.set_flashbang = function(l_39_0, l_39_1, l_39_2, l_39_3, l_39_4)
  local flash = l_39_0.test_line_of_sight(l_39_1 + flashbang_test_offset, 200, 1000, 3000)
  if flash > 0 then
    l_39_0._current_flashbang = math.min(l_39_0._current_flashbang + flash, 1.5)
    l_39_0._current_flashbang_flash = math.min(l_39_0._current_flashbang_flash + flash, 1.5)
  end
  World:effect_manager():spawn({effect = Idstring("effects/particles/explosions/explosion_grenade"), position = l_39_1, normal = Vector3(0, 0, 1)})
end

CoreEnvironmentControllerManager.set_flashbang_multiplier = function(l_40_0, l_40_1)
  l_40_0._flashbang_multiplier = l_40_1 or 1
  l_40_0._flashbang_multiplier = 1 + (1 - l_40_0._flashbang_multiplier) * 2
end

CoreEnvironmentControllerManager.test_line_of_sight = function(l_41_0, l_41_1, l_41_2, l_41_3)
  local vp = managers.viewport:first_active_viewport()
  if not vp then
    return 0
  end
  local camera = vp:camera()
  local cam_pos = tmp_vec1
  camera:m_position(cam_pos)
  local test_vec = tmp_vec2
  local dis = mvector3.direction(test_vec, cam_pos, l_41_0)
  if l_41_3 < dis then
    return 0
  end
  if dis < l_41_1 then
    return 1
  end
  local dot_mul = 1
  local max_dot = math.cos(75)
  local cam_rot = camera:rotation()
  local cam_fwd = camera:rotation():y()
  if mvector3.dot(cam_fwd, test_vec) < max_dot then
    if dis < l_41_2 then
      dot_mul = 0.5
    else
      return 0
    end
  end
  local ray_hit = World:raycast("ray", cam_pos, l_41_0, "slot_mask", managers.slot:get_mask("AI_visibility"), "ray_type", "ai_vision", "report")
  if ray_hit then
    return 0
  end
  local flash = math.max(dis - l_41_1, 0) / (l_41_3 - l_41_1)
  flash = (1 - flash) * dot_mul
  return flash
end

CoreEnvironmentControllerManager.set_dof_override = function(l_42_0, l_42_1)
  l_42_0._dof_override = l_42_1
end

CoreEnvironmentControllerManager.set_dof_override_ranges = function(l_43_0, l_43_1, l_43_2, l_43_3, l_43_4)
  l_43_0._dof_override_near = l_43_1
  l_43_0._dof_override_near_pad = l_43_2
  l_43_0._dof_override_far = l_43_3
  l_43_0._dof_override_far_pad = l_43_4
end

CoreEnvironmentControllerManager.set_dome_occ_default = function(l_44_0)
  local area = 20000
  local occ_texture = "core/textures/dome_occ_test"
  l_44_0:set_dome_occ_params(Vector3(-(area * 0.5), -(area * 0.5), 0), Vector3(area, area, 1200), occ_texture)
end

CoreEnvironmentControllerManager.set_dome_occ_params = function(l_45_0, l_45_1, l_45_2, l_45_3)
  l_45_0._occ_dirty = true
  l_45_0._occ_pos = l_45_1
  l_45_0._occ_pos = Vector3(l_45_0._occ_pos.x, l_45_0._occ_pos.y - l_45_2.y, l_45_0._occ_pos.z)
  l_45_0._occ_size = l_45_2
  l_45_0._occ_texture = l_45_3
end

CoreEnvironmentControllerManager._refresh_occ_params = function(l_46_0, l_46_1)
   -- DECOMPILER ERROR: Confused while interpreting a jump as a 'while'

end
local deferred_processor = l_46_0._vp:vp():get_post_processor_effect("World", Idstring("deferred"))
if deferred_processor then
  local apply_ambient = deferred_processor:modifier(Idstring("apply_ambient"))
  if apply_ambient then
    local dome_occ_feed = apply_ambient:material()
    if dome_occ_feed then
      dome_occ_feed:set_variable(Idstring("dome_occ_pos"), l_46_0._occ_pos)
      dome_occ_feed:set_variable(Idstring("dome_occ_size"), l_46_0._occ_size)
      Application:set_material_texture(dome_occ_feed, Idstring("filter_color_texture"), Idstring(l_46_0._occ_texture), Idstring("normal"))
    end
  end
  local shadow = deferred_processor:modifier(Idstring("move_global_occ"))
  if shadow then
    local dome_occ_feed_ps3 = shadow:material()
    if dome_occ_feed_ps3 then
      Application:set_material_texture(dome_occ_feed_ps3, Idstring("filter_color_texture"), Idstring(l_46_0._occ_texture), Idstring("normal"))
    end
  end
end
end

local ids_d_sun = Idstring("d_sun")
CoreEnvironmentControllerManager.feed_params = function(l_47_0)
end

CoreEnvironmentControllerManager.feed_param_underlay = function(l_48_0, l_48_1, l_48_2, l_48_3)
  local material = Underlay:material(Idstring(l_48_1))
  material:set_variable(Idstring(l_48_2), l_48_3)
end

CoreEnvironmentControllerManager.set_global_param = function(l_49_0, l_49_1, l_49_2)
end


