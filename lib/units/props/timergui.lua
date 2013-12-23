-- Decompiled using luadec 2.0.1 by sztupy (http://winmo.sztupy.hu)
-- Command line was: F:\SteamLibrary\SteamApps\common\PAYDAY 2\lua\lib\units\props\timergui.luac 

if not TimerGui then
  TimerGui = class()
end
TimerGui.init = function(l_1_0, l_1_1)
  l_1_0._unit = l_1_1
  l_1_0._visible = true
  l_1_0._powered = true
  l_1_0._jam_times = 3
  l_1_0._jammed = false
  l_1_0._can_jam = false
  l_1_0._gui_start = l_1_0._gui_start or "prop_timer_gui_start"
  l_1_0._gui_working = "prop_timer_gui_working"
  l_1_0._gui_malfunction = "prop_timer_gui_malfunction"
  l_1_0._gui_done = "prop_timer_gui_done"
  l_1_0._cull_distance = l_1_0._cull_distance or 5000
  l_1_0._size_multiplier = l_1_0._size_multiplier or 1
  l_1_0._gui_object = l_1_0._gui_object or "gui_name"
  l_1_0._new_gui = World:newgui()
  l_1_0:add_workspace(l_1_0._unit:get_object(Idstring(l_1_0._gui_object)))
  l_1_0:setup()
  l_1_0._unit:set_extension_update_enabled(Idstring("timer_gui"), false)
  l_1_0._update_enabled = false
end

TimerGui.set_can_jam = function(l_2_0, l_2_1)
  l_2_0._can_jam = l_2_1
end

TimerGui.set_override_timer = function(l_3_0, l_3_1)
  l_3_0._override_timer = l_3_1
end

TimerGui.add_workspace = function(l_4_0, l_4_1)
  l_4_0._ws = l_4_0._new_gui:create_object_workspace(0, 0, l_4_1, Vector3(0, 0, 0))
  l_4_0._gui = l_4_0._ws:panel():gui(Idstring("guis/timer_gui"))
  l_4_0._gui_script = l_4_0._gui:script()
end

TimerGui.setup = function(l_5_0)
  l_5_0._gui_script.panel:set_alpha(0.60000002384186)
  l_5_0._gui_script.working_text:set_render_template(Idstring("VertexColorTextured"))
  l_5_0._gui_script.time_header_text:set_render_template(Idstring("VertexColorTextured"))
  l_5_0._gui_script.time_text:set_render_template(Idstring("VertexColorTextured"))
  l_5_0._gui_script.drill_screen_background:set_size(l_5_0._gui_script.drill_screen_background:parent():size())
  l_5_0._gui_script.timer:set_h(120 * l_5_0._size_multiplier)
  l_5_0._gui_script.timer:set_w(l_5_0._gui_script.timer:parent():w() - l_5_0._gui_script.timer:parent():w() / 5)
  l_5_0._gui_script.timer:set_center_x(l_5_0._gui_script.timer:parent():w() / 2)
  l_5_0._gui_script.timer:set_center_y(l_5_0._gui_script.timer:parent():h() / 2)
  l_5_0._timer_lenght = l_5_0._gui_script.timer:w()
  l_5_0._gui_script.timer_background:set_h(l_5_0._gui_script.timer:h() + 20 * l_5_0._size_multiplier)
  l_5_0._gui_script.timer_background:set_w(l_5_0._gui_script.timer:w() + 20 * l_5_0._size_multiplier)
  l_5_0._gui_script.timer_background:set_center(l_5_0._gui_script.timer:center())
  l_5_0._gui_script.timer:set_w(0)
  l_5_0._gui_script.working_text:set_center_x(l_5_0._gui_script.working_text:parent():w() / 2)
  l_5_0._gui_script.working_text:set_center_y(l_5_0._gui_script.working_text:parent():h() / 4)
  l_5_0._gui_script.working_text:set_font_size(110 * l_5_0._size_multiplier)
  l_5_0._gui_script.working_text:set_text(managers.localization:text(l_5_0._gui_start))
  l_5_0._gui_script.working_text:set_visible(true)
  l_5_0._gui_script.time_header_text:set_font_size(80 * l_5_0._size_multiplier)
  l_5_0._gui_script.time_header_text:set_visible(false)
  l_5_0._gui_script.time_header_text:set_center_x(l_5_0._gui_script.working_text:parent():w() / 2)
  l_5_0._gui_script.time_header_text:set_center_y(l_5_0._gui_script.working_text:parent():h() / 1.3500000238419)
  l_5_0._gui_script.time_text:set_font_size(110 * l_5_0._size_multiplier)
  l_5_0._gui_script.time_text:set_visible(false)
  l_5_0._gui_script.time_text:set_center_x(l_5_0._gui_script.working_text:parent():w() / 2)
  l_5_0._gui_script.time_text:set_center_y(l_5_0._gui_script.working_text:parent():h() / 1.1499999761581)
  l_5_0._original_colors = {}
  for _,child in ipairs(l_5_0._gui_script.panel:children()) do
    l_5_0._original_colors[child:key()] = child:color()
  end
end

TimerGui._start = function(l_6_0, l_6_1, l_6_2)
  l_6_0._started = true
  l_6_0._done = false
  l_6_0._timer = l_6_1 or 5
  if not l_6_2 then
    l_6_0._current_timer = l_6_0._timer
  end
  l_6_0._gui_script.timer:set_w(l_6_0._timer_lenght * (1 - l_6_0._current_timer / l_6_0._timer))
  l_6_0._gui_script.working_text:set_text(managers.localization:text(l_6_0._gui_working))
  l_6_0._unit:set_extension_update_enabled(Idstring("timer_gui"), true)
  l_6_0._update_enabled = true
  l_6_0:post_event(l_6_0._start_event)
  l_6_0._gui_script.time_header_text:set_visible(true)
  l_6_0._gui_script.time_text:set_visible(true)
  l_6_0._gui_script.time_text:set_text(math.floor(l_6_0._current_timer) .. " " .. managers.localization:text("prop_timer_gui_seconds"))
  l_6_0._unit:base():start()
  if Network:is_client() then
    return 
  end
  l_6_0:_set_jamming_values()
end

TimerGui._set_jamming_values = function(l_7_0)
  if not l_7_0._can_jam then
    return 
  end
  l_7_0._jamming_intervals = {}
  local jammed_times = math.random(l_7_0._jam_times)
  local interval = l_7_0._timer / jammed_times
  for i = 1, jammed_times do
    local start = interval / 2
    l_7_0._jamming_intervals[i] = start + math.rand(start / 1.25)
  end
  l_7_0._current_jam_timer = table.remove(l_7_0._jamming_intervals, 1)
end

TimerGui.set_timer_multiplier = function(l_8_0, l_8_1)
  l_8_0._timer_multiplier = l_8_1
end

TimerGui.start = function(l_9_0, l_9_1)
  l_9_1 = (l_9_0._override_timer or l_9_1) * (l_9_0._timer_multiplier or 1)
  if l_9_0._jammed then
    l_9_0:_set_jammed(false)
    return 
  end
  if not l_9_0._powered then
    l_9_0:_set_powered(true)
    return 
  end
  if l_9_0._started then
    return 
  end
  l_9_0:_start(l_9_1)
  if managers.network:session() then
    managers.network:session():send_to_peers_synched("start_timer_gui", l_9_0._unit, l_9_1)
  end
end

TimerGui.sync_start = function(l_10_0, l_10_1)
  l_10_0:_start(l_10_1)
end

TimerGui.update = function(l_11_0, l_11_1, l_11_2, l_11_3)
  if l_11_0._jammed then
    l_11_0._gui_script.drill_screen_background:set_color(l_11_0._gui_script.drill_screen_background:color():with_alpha(0.5 + (math.sin(l_11_2 * 750) + 1) / 4))
    return 
  end
  if not l_11_0._powered then
    return 
  end
  if l_11_0._current_jam_timer then
    l_11_0._current_jam_timer = l_11_0._current_jam_timer - l_11_3
    if l_11_0._current_jam_timer <= 0 then
      l_11_0:set_jammed(true)
      l_11_0._current_jam_timer = table.remove(l_11_0._jamming_intervals, 1)
      return 
    end
  end
  l_11_0._current_timer = l_11_0._current_timer - l_11_3
  l_11_0._gui_script.time_text:set_text(math.floor(l_11_0._current_timer) .. " " .. managers.localization:text("prop_timer_gui_seconds"))
  l_11_0._gui_script.timer:set_w(l_11_0._timer_lenght * (1 - l_11_0._current_timer / l_11_0._timer))
  if l_11_0._current_timer <= 0 then
    l_11_0._unit:set_extension_update_enabled(Idstring("timer_gui"), false)
    l_11_0._update_enabled = false
    l_11_0:done()
  else
    l_11_0._gui_script.working_text:set_color(l_11_0._gui_script.working_text:color():with_alpha(0.5 + (math.sin(l_11_2 * 750) + 1) / 4))
  end
end

TimerGui.set_visible = function(l_12_0, l_12_1)
  l_12_0._visible = l_12_1
  l_12_0._gui:set_visible(l_12_1)
end

TimerGui.sync_set_jammed = function(l_13_0, l_13_1)
  l_13_0:_set_jammed(l_13_1)
end

TimerGui.set_jammed = function(l_14_0, l_14_1)
  if l_14_1 and l_14_0._unit:damage() and l_14_0._unit:damage():has_sequence("jammed_trigger") then
    l_14_0._unit:damage():run_sequence_simple("jammed_trigger")
  end
  if managers.network:session() then
    managers.network:session():send_to_peers_synched("set_jammed_timer_gui", l_14_0._unit, l_14_1)
  end
  l_14_0:_set_jammed(l_14_1)
end

TimerGui._set_jammed = function(l_15_0, l_15_1)
  l_15_0._jammed = l_15_1
  if l_15_0._jammed then
    if l_15_0._unit:damage():has_sequence("set_is_jammed") then
      l_15_0._unit:damage():run_sequence_simple("set_is_jammed")
    end
    for _,child in ipairs(l_15_0._gui_script.panel:children()) do
      local color = l_15_0._original_colors[child:key()]
      local c = Color(color.a, 1, 0, 0)
      child:set_color(c)
    end
    l_15_0._gui_script.working_text:set_text(managers.localization:text(l_15_0._gui_malfunction))
    l_15_0._gui_script.time_text:set_text(managers.localization:text("prop_timer_gui_error"))
    if l_15_0._unit:interaction() then
      if l_15_0._jammed_tweak_data then
        l_15_0._unit:interaction():set_tweak_data(l_15_0._jammed_tweak_data)
      end
      l_15_0._unit:interaction():set_active(true)
    end
    l_15_0:post_event(l_15_0._jam_event)
  else
    for _,child in ipairs(l_15_0._gui_script.panel:children()) do
      child:set_color(l_15_0._original_colors[child:key()])
    end
    l_15_0._gui_script.working_text:set_text(managers.localization:text(l_15_0._gui_working))
    l_15_0._gui_script.time_text:set_text(math.floor(l_15_0._current_timer) .. " " .. managers.localization:text("prop_timer_gui_seconds"))
    l_15_0._gui_script.drill_screen_background:set_color(l_15_0._gui_script.drill_screen_background:color():with_alpha(1))
    l_15_0:post_event(l_15_0._resume_event)
  end
  l_15_0._unit:base():set_jammed(l_15_1)
  if l_15_0._unit:mission_door_device() then
    l_15_0._unit:mission_door_device():report_jammed_state(l_15_1)
  end
end

TimerGui.set_powered = function(l_16_0, l_16_1, l_16_2)
  l_16_0:_set_powered(l_16_1, l_16_2)
end

TimerGui._set_powered = function(l_17_0, l_17_1, l_17_2)
  l_17_0._powered = l_17_1
  if not l_17_0._powered then
    for _,child in ipairs(l_17_0._gui_script.panel:children()) do
      local color = l_17_0._original_colors[child:key()]
      local c = Color(color.a, color.r * 0, color.g * 0, color.b * 0.25)
      child:set_color(c)
    end
    l_17_0:post_event(l_17_0._jam_event)
    if l_17_2 and l_17_0._unit:interaction() then
      l_17_0._powered_interaction_enabled = l_17_2
      if l_17_0._jammed_tweak_data then
        l_17_0._unit:interaction():set_tweak_data(l_17_0._jammed_tweak_data)
      end
      l_17_0._unit:interaction():set_active(true)
    end
    l_17_0:post_event(l_17_0._jam_event)
  else
    for _,child in ipairs(l_17_0._gui_script.panel:children()) do
      child:set_color(l_17_0._original_colors[child:key()])
    end
    l_17_0:post_event(l_17_0._resume_event)
    if l_17_0._powered_interaction_enabled then
      l_17_0._powered_interaction_enabled = nil
      if l_17_0._unit:mission_door_device() then
        l_17_0._unit:mission_door_device():report_resumed()
      end
    end
  end
  l_17_0._unit:base():set_powered(l_17_1)
end

TimerGui.done = function(l_18_0)
  l_18_0:_set_done()
  if l_18_0._unit:damage() then
    l_18_0._unit:damage():run_sequence_simple("timer_done")
  end
  l_18_0:post_event(l_18_0._done_event)
  if l_18_0._unit:mission_door_device() then
    l_18_0._unit:mission_door_device():report_completed()
  end
end

TimerGui._set_done = function(l_19_0)
  l_19_0._done = true
  l_19_0._gui_script.timer:set_w(l_19_0._timer_lenght)
  l_19_0._gui_script.working_text:set_color(l_19_0._gui_script.working_text:color():with_alpha(1))
  l_19_0._gui_script.working_text:set_text(managers.localization:text(l_19_0._gui_done))
  l_19_0._gui_script.time_header_text:set_visible(false)
  l_19_0._gui_script.time_text:set_visible(false)
  l_19_0._unit:base():done()
end

TimerGui.post_event = function(l_20_0, l_20_1)
  if not l_20_1 then
    return 
  end
  l_20_0._unit:sound_source():post_event(l_20_1)
end

TimerGui.lock_gui = function(l_21_0)
  l_21_0._ws:set_cull_distance(l_21_0._cull_distance)
  l_21_0._ws:set_frozen(true)
end

TimerGui.destroy = function(l_22_0)
  if alive(l_22_0._new_gui) and alive(l_22_0._ws) then
    l_22_0._new_gui:destroy_workspace(l_22_0._ws)
    l_22_0._ws = nil
    l_22_0._new_gui = nil
  end
end

TimerGui.save = function(l_23_0, l_23_1)
  local state = {}
  state.update_enabled = l_23_0._update_enabled
  state.timer = l_23_0._timer
  state.current_timer = l_23_0._current_timer
  state.jammed = l_23_0._jammed
  state.powered = l_23_0._powered
  state.powered_interaction_enabled = l_23_0._powered_interaction_enabled
  state.done = l_23_0._done
  state.visible = l_23_0._visible
  l_23_1.TimerGui = state
end

TimerGui.load = function(l_24_0, l_24_1)
  local state = l_24_1.TimerGui
  if state.done then
    l_24_0:_set_done()
  elseif state.update_enabled then
    l_24_0:_start(state.timer, state.current_timer)
    if state.jammed then
      l_24_0:_set_jammed(state.jammed)
    end
    if not state.powered then
      l_24_0:_set_powered(state.powered, state.powered_interaction_enabled)
    end
  end
  l_24_0:set_visible(state.visible)
end


