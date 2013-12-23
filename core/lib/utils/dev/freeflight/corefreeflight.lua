-- Decompiled using luadec 2.0.1 by sztupy (http://winmo.sztupy.hu)
-- Command line was: F:\SteamLibrary\SteamApps\common\PAYDAY 2\lua\core\lib\utils\dev\freeflight\corefreeflight.luac 

core:module("CoreFreeFlight")
core:import("CoreEvent")
core:import("CoreApp")
core:import("CoreFreeFlightAction")
core:import("CoreFreeFlightModifier")
core:from_module_import("CoreManagerBase", "PRIO_FREEFLIGHT")
local FF_ON, FF_OFF, FF_ON_NOCON = 0, 1, 2
local MOVEMENT_SPEED_BASE = 1000
local TURN_SPEED_BASE = 1
local FAR_RANGE_MAX = 250000
local PITCH_LIMIT_MIN = -80
local PITCH_LIMIT_MAX = 80
local TEXT_FADE_TIME = 0.30000001192093
local TEXT_ON_SCREEN_TIME = 2
local FREEFLIGHT_HEADER_TEXT = "FREEFLIGHT, PRESS 'F' OR 'C'"
local DESELECTED = Color(0.5, 0.5, 0.5)
local SELECTED = Color(1, 1, 1)
if not FreeFlight then
  FreeFlight = class()
end
FreeFlight.init = function(l_1_0, l_1_1, l_1_2, l_1_3)
  assert(l_1_1)
  assert(l_1_2)
  assert(l_1_3)
  l_1_0._state = FF_OFF
  l_1_0._gsm = l_1_1
  l_1_0._vpm = l_1_2
  l_1_0._keyboard = Input:keyboard()
  l_1_0._mouse = Input:mouse()
  l_1_0._rot = Rotation()
  l_1_0._pos = Vector3(0, 0, 1000)
  l_1_0:_setup_F9_key(l_1_0)
  l_1_0:_setup_modifiers()
  l_1_0:_setup_actions()
  l_1_0:_setup_viewport(l_1_2)
  l_1_0:_setup_controller(l_1_3)
  l_1_0:_setup_gui()
end

FreeFlight._setup_F9_key = function(l_2_0)
  if Global.DEBUG_MENU_ON or Application:production_build() then
    local keyboard = Input:keyboard()
    if keyboard and keyboard:has_button(Idstring("f9")) then
      l_2_0._f9_con = Input:create_virtual_controller()
      l_2_0._f9_con:connect(keyboard, Idstring("f9"), Idstring("btn_toggle"))
      l_2_0._f9_con:add_trigger(Idstring("btn_toggle"), callback(l_2_0, l_2_0, "_on_F9"))
    end
  end
end

FreeFlight._setup_modifiers = function(l_3_0)
  local FFM = CoreFreeFlightModifier.FreeFlightModifier
  local ms = FFM:new("MOVE SPEED", {0.019999999552965, 0.050000000745058, 0.10000000149012, 0.20000000298023, 0.30000001192093, 0.40000000596046, 0.5, 1, 2, 3, 4, 5, 8, 11, 14, 18, 25, 30, 40, 50, 60, 70, 80, 100, 120, 140, 160, 180, 200}, 9)
  local ts = FFM:new("TURN SPEED", {1, 2, 3, 4, 5, 6, 7, 8, 9, 10}, 5)
  local gt = FFM:new("GAME TIMER", {0.10000000149012, 0.20000000298023, 0.30000001192093, 0.40000000596046, 0.5, 0.60000002384186, 0.69999998807907, 0.80000001192093, 0.89999997615814, 1, 1.1000000238419, 1.2000000476837, 1.2999999523163, 1.3999999761581, 1.5, 1.6000000238419, 1.7000000476837, 1.7999999523163, 1.8999999761581, 2, 2.5, 3, 3.5, 4, 4.5, 5}, 10, callback(l_3_0, l_3_0, "_set_game_timer"))
  local fov = FFM:new("FOV", {2, 5, 7, 10, 20, 30, 40, 50, 55, 60, 65, 70, 75}, 13, callback(l_3_0, l_3_0, "_set_fov"))
  l_3_0._modifiers = {ms, ts, gt, fov}
  l_3_0._modifier_index = 1
  l_3_0._fov = fov
  l_3_0._move_speed = ms
  l_3_0._turn_speed = ts
end

FreeFlight._setup_actions = function(l_4_0)
  local FFA = CoreFreeFlightAction.FreeFlightAction
  local FFAT = CoreFreeFlightAction.FreeFlightActionToggle
  local dp = FFA:new("DROP PLAYER", callback(l_4_0, l_4_0, "_drop_player"))
  local au = FFA:new("ATTACH TO UNIT", callback(l_4_0, l_4_0, "_attach_unit"))
  local pd = FFA:new("POSITION DEBUG", callback(l_4_0, l_4_0, "_position_debug"))
  local yc = FFA:new("YIELD CONTROL (F9 EXIT)", callback(l_4_0, l_4_0, "_yield_control"))
  local ef = FFA:new("EXIT FREEFLIGHT", callback(l_4_0, l_4_0, "_exit_freeflight"))
  local ps = FFAT:new("PAUSE", "UNPAUSE", callback(l_4_0, l_4_0, "_pause"), callback(l_4_0, l_4_0, "_unpause"))
  local ff = FFAT:new("FRUSTUM FREEZE", "FRUSTUM UNFREEZE", callback(l_4_0, l_4_0, "_frustum_freeze"), callback(l_4_0, l_4_0, "_frustum_unfreeze"))
  l_4_0._actions = {ps, dp, au, pd, yc, ff, ef}
  l_4_0._action_index = 1
end

FreeFlight._setup_viewport = function(l_5_0, l_5_1)
  l_5_0._camera_object = World:create_camera()
  l_5_0._camera_object:set_far_range(FAR_RANGE_MAX)
  l_5_0._camera_object:set_fov(l_5_0._fov:value())
  l_5_0._vp = l_5_1:new_vp(0, 0, 1, 1, "freeflight", PRIO_FREEFLIGHT)
  l_5_0._vp:set_camera(l_5_0._camera_object)
  l_5_0._camera_pos = l_5_0._camera_object:position()
  l_5_0._camera_rot = l_5_0._camera_object:rotation()
end

FreeFlight._setup_controller = function(l_6_0, l_6_1)
  l_6_0._con = l_6_1:create_controller("freeflight", nil, true, PRIO_FREEFLIGHT)
  l_6_0._con:add_trigger("freeflight_action_toggle", callback(l_6_0, l_6_0, "_action_toggle"))
  l_6_0._con:add_trigger("freeflight_action_execute", callback(l_6_0, l_6_0, "_action_execute"))
  l_6_0._con:add_trigger("freeflight_quick_action_execute", callback(l_6_0, l_6_0, "_quick_action_execute"))
  l_6_0._con:add_trigger("freeflight_modifier_toggle", callback(l_6_0, l_6_0, "_next_modifier_toggle"))
  l_6_0._con:add_trigger("freeflight_modifier_up", callback(l_6_0, l_6_0, "_curr_modifier_up"))
  l_6_0._con:add_trigger("freeflight_modifier_down", callback(l_6_0, l_6_0, "_curr_modifier_down"))
end

FreeFlight._setup_gui = function(l_7_0)
  local gui_scene = Overlay:gui()
  local res = RenderSettings.resolution
  l_7_0._workspace = gui_scene:create_screen_workspace()
  l_7_0._workspace:set_timer(TimerManager:main())
  l_7_0._panel = l_7_0._workspace:panel()
  local SCREEN_RIGHT_OFFSET = 420
  local TEXT_HEIGHT_OFFSET = 27
  local config = {}
  config.font = "core/fonts/system_font"
  config.font_scale = 0.89999997615814
  config.color = DESELECTED
  config.x = 45
  config.y = 25
  config.layer = 1000000
  local anim_fade_out_func = function(l_1_0)
    CoreEvent.over(TEXT_FADE_TIME, function(l_1_0)
      o:set_color(o:color():with_alpha(1 - l_1_0))
      end)
   end
  local anim_fade_in_func = function(l_2_0)
    CoreEvent.over(TEXT_FADE_TIME, function(l_1_0)
      o:set_color(o:color():with_alpha(l_1_0))
      end)
   end
  local text_script = {fade_out = anim_fade_out_func, fade_in = anim_fade_in_func}
  l_7_0._action_gui = {}
  l_7_0._action_vis_time = nil
  for i,a in ipairs(l_7_0._actions) do
    local text = l_7_0._panel:text(config)
    text:set_script(text_script)
    text:set_text(a:name())
    text:set_y(text:y() + i * TEXT_HEIGHT_OFFSET)
    if i == l_7_0._action_index then
      text:set_color(SELECTED)
    end
    text:set_color(text:color():with_alpha(0))
    table.insert(l_7_0._action_gui, text)
  end
  l_7_0._modifier_gui = {}
  l_7_0._modifier_vis_time = nil
  for i,m in ipairs(l_7_0._modifiers) do
    local text = l_7_0._panel:text(config)
    text:set_script(text_script)
    text:set_text(m:name_value())
    text:set_y(text:y() + i * TEXT_HEIGHT_OFFSET)
    text:set_x(res.x - SCREEN_RIGHT_OFFSET)
    if i == l_7_0._modifier_index then
      text:set_color(SELECTED)
    end
    text:set_color(text:color():with_alpha(0))
    table.insert(l_7_0._modifier_gui, text)
  end
  l_7_0._workspace:hide()
end

FreeFlight.enable = function(l_8_0)
  if l_8_0._gsm:current_state():allow_freeflight() then
    local active_vp = l_8_0._vpm:first_active_viewport()
    if active_vp then
      local env = active_vp:environment_mixer():current_environment()
      l_8_0._vp:environment_mixer():set_environment(env)
      l_8_0._start_cam = active_vp:camera()
      if l_8_0._start_cam then
        if not alive(l_8_0._attached_to_unit) or not l_8_0._attached_to_unit:position() then
          local pos = l_8_0._start_cam:position() - Vector3()
        end
        l_8_0:_set_camera(pos, l_8_0._start_cam:rotation())
      end
    end
    l_8_0._state = FF_ON
    l_8_0._vp:set_active(true)
    l_8_0._con:enable()
    l_8_0._workspace:show()
    l_8_0:_draw_actions()
    l_8_0:_draw_modifiers()
    if managers.enemy then
      managers.enemy:set_gfx_lod_enabled(false)
    end
  end
end

FreeFlight.disable = function(l_9_0)
  for _,a in ipairs(l_9_0._actions) do
    a:reset()
  end
  l_9_0._state = FF_OFF
  l_9_0._con:disable()
  l_9_0._workspace:hide()
  l_9_0._vp:set_active(false)
  if managers.enemy then
    managers.enemy:set_gfx_lod_enabled(true)
  end
end

FreeFlight.enabled = function(l_10_0)
  return l_10_0._state ~= FF_OFF
end

FreeFlight._on_F9 = function(l_11_0)
  if l_11_0._state == FF_ON then
    l_11_0:disable()
  else
    if l_11_0._state == FF_OFF then
      l_11_0:enable()
    else
      if l_11_0._state == FF_ON_NOCON then
        l_11_0._state = FF_ON
        l_11_0._con:enable()
      end
    end
  end
end

FreeFlight._action_toggle = function(l_12_0)
  if l_12_0:_actions_are_visible() then
    l_12_0._action_gui[l_12_0._action_index]:set_color(DESELECTED)
    l_12_0._action_index = l_12_0._action_index % #l_12_0._actions + 1
    l_12_0._action_gui[l_12_0._action_index]:set_color(SELECTED)
  end
  l_12_0:_draw_actions()
end

FreeFlight._action_execute = function(l_13_0)
  if l_13_0:_actions_are_visible() then
    l_13_0:_current_action():do_action()
  end
  l_13_0:_draw_actions()
end

FreeFlight._quick_action_execute = function(l_14_0)
  print("_quick_action_execute")
  l_14_0:_current_action():do_action()
end

FreeFlight._exit_freeflight = function(l_15_0)
  l_15_0:disable()
end

FreeFlight._yield_control = function(l_16_0)
  assert(l_16_0._state == FF_ON)
  l_16_0._state = FF_ON_NOCON
  l_16_0._con:disable()
end

FreeFlight._drop_player = function(l_17_0)
  local rot_new = Rotation(l_17_0._camera_rot:yaw(), 0, 0)
  l_17_0._gsm:current_state():freeflight_drop_player(l_17_0._camera_pos, rot_new)
end

FreeFlight._position_debug = function(l_18_0)
  local p = l_18_0._camera_pos
  cat_print("debug", "CAMERA POSITION: Vector3(" .. p.x .. "," .. p.y .. "," .. p.z .. ")")
end

FreeFlight._pause = function(l_19_0)
  Application:set_pause(true)
end

FreeFlight._unpause = function(l_20_0)
  Application:set_pause(false)
end

FreeFlight._frustum_freeze = function(l_21_0)
  local old_cam = l_21_0._camera_object
  local new_cam = World:create_camera()
  new_cam:set_fov(old_cam:fov())
  new_cam:set_position(old_cam:position())
  new_cam:set_rotation(old_cam:rotation())
  new_cam:set_far_range(old_cam:far_range())
  new_cam:set_near_range(old_cam:near_range())
  new_cam:set_aspect_ratio(old_cam:aspect_ratio())
  new_cam:set_width_multiplier(old_cam:width_multiplier())
  if l_21_0._start_cam then
    old_cam:set_far_range(l_21_0._start_cam:far_range())
  end
  Application:set_frustum_freeze_camera(old_cam, new_cam)
  l_21_0._frozen_camera = old_cam
  l_21_0._camera_object = new_cam
end

FreeFlight._frustum_unfreeze = function(l_22_0)
  local old_cam = l_22_0._frozen_camera
  old_cam:set_far_range(FAR_RANGE_MAX)
  Application:set_frustum_freeze_camera(old_cam, old_cam)
  l_22_0._camera_object = old_cam
  l_22_0._frozen_camera = nil
end

FreeFlight._next_modifier_toggle = function(l_23_0)
  if l_23_0:_modifiers_are_visible() then
    l_23_0._modifier_gui[l_23_0._modifier_index]:set_color(DESELECTED)
    l_23_0._modifier_index = l_23_0._modifier_index % #l_23_0._modifiers + 1
    l_23_0._modifier_gui[l_23_0._modifier_index]:set_color(SELECTED)
  end
  l_23_0:_draw_modifiers()
end

FreeFlight._curr_modifier_up = function(l_24_0)
  if l_24_0:_modifiers_are_visible() then
    l_24_0:_current_modifier():step_up()
    l_24_0._modifier_gui[l_24_0._modifier_index]:set_text(l_24_0:_current_modifier():name_value())
  end
  l_24_0:_draw_modifiers()
end

FreeFlight._curr_modifier_down = function(l_25_0)
  if l_25_0:_modifiers_are_visible() then
    l_25_0:_current_modifier():step_down()
    l_25_0._modifier_gui[l_25_0._modifier_index]:set_text(l_25_0:_current_modifier():name_value())
  end
  l_25_0:_draw_modifiers()
end

FreeFlight._set_fov = function(l_26_0, l_26_1)
  l_26_0._camera_object:set_fov(l_26_1)
end

FreeFlight._set_game_timer = function(l_27_0, l_27_1)
  TimerManager:game():set_multiplier(l_27_1)
  TimerManager:game_animation():set_multiplier(l_27_1)
end

FreeFlight._current_action = function(l_28_0)
  return l_28_0._actions[l_28_0._action_index]
end

FreeFlight._current_modifier = function(l_29_0)
  return l_29_0._modifiers[l_29_0._modifier_index]
end

FreeFlight._actions_are_visible = function(l_30_0)
  local t = TimerManager:main():time()
  return not l_30_0._action_vis_time or t + TEXT_FADE_TIME < l_30_0._action_vis_time
end

FreeFlight._modifiers_are_visible = function(l_31_0)
  local t = TimerManager:main():time()
  return not l_31_0._modifier_vis_time or t + TEXT_FADE_TIME < l_31_0._modifier_vis_time
end

FreeFlight._draw_actions = function(l_32_0)
  if not l_32_0:_actions_are_visible() then
    for i,text in ipairs(l_32_0._action_gui) do
      text:stop()
      text:animate(text:script().fade_in)
    end
  end
  for i,_ in ipairs(l_32_0._actions) do
    l_32_0._action_gui[i]:set_text(l_32_0._actions[i]:name())
  end
  l_32_0._action_vis_time = TimerManager:main():time() + TEXT_ON_SCREEN_TIME
end

FreeFlight._draw_modifiers = function(l_33_0)
  if not l_33_0:_modifiers_are_visible() then
    for _,text in ipairs(l_33_0._modifier_gui) do
      text:stop()
      text:animate(text:script().fade_in)
    end
  end
  l_33_0._modifier_vis_time = TimerManager:main():time() + TEXT_ON_SCREEN_TIME
end

FreeFlight._set_camera = function(l_34_0, l_34_1, l_34_2)
  if not alive(l_34_0._attached_to_unit) or not l_34_0._attached_to_unit:position() then
    l_34_0._camera_object:set_position(Vector3() + l_34_1)
  end
  l_34_0._camera_object:set_rotation(l_34_2)
  l_34_0._camera_pos = l_34_1
  l_34_0._camera_rot = l_34_2
end

FreeFlight.update = function(l_35_0, l_35_1, l_35_2)
  local main_t = TimerManager:main():time()
  local main_dt = TimerManager:main():delta_time()
  if l_35_0:enabled() then
    l_35_0:_update_controller(main_t, main_dt)
    l_35_0:_update_gui(main_t, main_dt)
    l_35_0:_update_camera(main_t, main_dt)
    l_35_0:_update_frustum_debug_box(main_t, main_dt)
  end
end

FreeFlight._update_controller = function(l_36_0, l_36_1, l_36_2)
end

FreeFlight._update_gui = function(l_37_0, l_37_1, l_37_2)
  if l_37_0._action_vis_time and l_37_0._action_vis_time < l_37_1 then
    for _,text in ipairs(l_37_0._action_gui) do
      text:stop()
      text:animate(text:script().fade_out)
    end
    l_37_0._action_vis_time = nil
  end
  if l_37_0._modifier_vis_time and l_37_0._modifier_vis_time < l_37_1 then
    for _,text in ipairs(l_37_0._modifier_gui) do
      text:stop()
      text:animate(text:script().fade_out)
    end
    l_37_0._modifier_vis_time = nil
  end
end

FreeFlight._update_camera = function(l_38_0, l_38_1, l_38_2)
  local axis_move = l_38_0._con:get_input_axis("freeflight_axis_move")
  local axis_look = l_38_0._con:get_input_axis("freeflight_axis_look")
  local btn_move_up = l_38_0._con:get_input_float("freeflight_move_up")
  local btn_move_down = l_38_0._con:get_input_float("freeflight_move_down")
  local move_dir = l_38_0._camera_rot:x() * axis_move.x + l_38_0._camera_rot:y() * axis_move.y
  move_dir = move_dir + btn_move_up * Vector3(0, 0, 1) + btn_move_down * Vector3(0, 0, -1)
  local move_delta = (move_dir) * l_38_0._move_speed:value() * MOVEMENT_SPEED_BASE * l_38_2
  local pos_new = l_38_0._camera_pos + move_delta
  local yaw_new = l_38_0._camera_rot:yaw() + axis_look.x * -1 * l_38_0._turn_speed:value() * TURN_SPEED_BASE
  local pitch_new = math.clamp(l_38_0._camera_rot:pitch() + axis_look.y * l_38_0._turn_speed:value() * TURN_SPEED_BASE, PITCH_LIMIT_MIN, PITCH_LIMIT_MAX)
  local rot_new = Rotation(yaw_new, pitch_new, 0)
  if not CoreApp.arg_supplied("-vpslave") then
    l_38_0:_set_camera(pos_new, rot_new)
  end
end

FreeFlight._attach_unit = function(l_39_0)
  local cam = l_39_0._camera_object
  local ray = World:raycast("ray", cam:position(), cam:position() + cam:rotation():y() * 10000)
  if ray then
    print("ray hit", ray.unit:name():s(), ray.body:name())
    if alive(l_39_0._attached_to_unit) and l_39_0._attached_to_unit == ray.unit then
      print("[FreeFlight] Detach")
      l_39_0:attach_to_unit(nil)
    else
      print("[FreeFlight] Attach")
      l_39_0:attach_to_unit(ray.unit)
    end
  end
end

FreeFlight.attach_to_unit = function(l_40_0, l_40_1)
  if not alive(l_40_1) or alive(l_40_0._attached_to_unit) and l_40_1 ~= l_40_0._attached_to_unit then
    local pos = l_40_0._camera_pos + l_40_0._attached_to_unit:position()
    l_40_0:_set_camera(pos, l_40_0._camera_rot)
  end
  if alive(l_40_1) and l_40_1 ~= l_40_0._attached_to_unit then
    l_40_0._attached_to_unit_pos = l_40_1:position()
    local pos = l_40_0._camera_pos - l_40_0._attached_to_unit_pos
    l_40_0:_set_camera(pos, l_40_0._camera_rot)
  end
  l_40_0._attached_to_unit = l_40_1
end

FreeFlight._update_frustum_debug_box = function(l_41_0, l_41_1, l_41_2)
  if l_41_0._frozen_camera then
    local near = l_41_0._frozen_camera:near_range()
    local far = l_41_0._frozen_camera:far_range()
    local R, G, B = 1, 0, 1
    local n1 = l_41_0._frozen_camera:screen_to_world(Vector3(-1, -1, near))
    local n2 = l_41_0._frozen_camera:screen_to_world(Vector3(1, -1, near))
    local n3 = l_41_0._frozen_camera:screen_to_world(Vector3(1, 1, near))
    local n4 = l_41_0._frozen_camera:screen_to_world(Vector3(-1, 1, near))
    local f1 = l_41_0._frozen_camera:screen_to_world(Vector3(-1, -1, far))
    local f2 = l_41_0._frozen_camera:screen_to_world(Vector3(1, -1, far))
    local f3 = l_41_0._frozen_camera:screen_to_world(Vector3(1, 1, far))
    local f4 = l_41_0._frozen_camera:screen_to_world(Vector3(-1, 1, far))
    Application:draw_line(n1, n2, R, G, B)
    Application:draw_line(n2, n3, R, G, B)
    Application:draw_line(n3, n4, R, G, B)
    Application:draw_line(n4, n1, R, G, B)
    Application:draw_line(n1, f1, R, G, B)
    Application:draw_line(n2, f2, R, G, B)
    Application:draw_line(n3, f3, R, G, B)
    Application:draw_line(n4, f4, R, G, B)
    Application:draw_line(f1, f2, R, G, B)
    Application:draw_line(f2, f3, R, G, B)
    Application:draw_line(f3, f4, R, G, B)
    Application:draw_line(f4, f1, R, G, B)
  end
end

FreeFlight.destroy = function(l_42_0)
  if alive(l_42_0._con_toggle) then
    Input:destroy_virtual_controller(l_42_0._con_toggle)
    l_42_0._con_toggle = nil
  end
  if alive(l_42_0._con) then
    l_42_0._con:destroy()
    l_42_0._con = nil
  end
  l_42_0._vp:destroy()
  l_42_0._vp = nil
end


