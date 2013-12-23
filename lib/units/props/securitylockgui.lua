-- Decompiled using luadec 2.0.1 by sztupy (http://winmo.sztupy.hu)
-- Command line was: F:\SteamLibrary\SteamApps\common\PAYDAY 2\lua\lib\units\props\securitylockgui.luac 

if not SecurityLockGui then
  SecurityLockGui = class()
end
SecurityLockGui.init = function(l_1_0, l_1_1)
  l_1_0._unit = l_1_1
  l_1_0._visible = true
  l_1_0._powered = true
  l_1_0._gui_start = l_1_0._gui_start or "prop_timer_gui_start"
  l_1_0._gui_working = "prop_timer_gui_working"
  l_1_0._gui_done = "prop_timer_gui_done"
  l_1_0._cull_distance = l_1_0._cull_distance or 5000
  l_1_0._size_multiplier = l_1_0._size_multiplier or 1
  l_1_0._gui_object = l_1_0._gui_object or "gui_name"
  l_1_0._bars = l_1_0._bars or 3
  l_1_0._done_bars = {}
  l_1_0._5sec_bars = {}
  l_1_0._new_gui = World:newgui()
  l_1_0:add_workspace(l_1_0._unit:get_object(Idstring(l_1_0._gui_object)))
  l_1_0:setup()
  l_1_0._unit:set_extension_update_enabled(Idstring("timer_gui"), false)
  l_1_0._update_enabled = false
end

SecurityLockGui.add_workspace = function(l_2_0, l_2_1)
  l_2_0._ws = l_2_0._new_gui:create_object_workspace(0, 0, l_2_1, Vector3(0, 0, 0))
  l_2_0._gui = l_2_0._ws:panel():gui(Idstring("guis/security_lock_gui"))
  l_2_0._gui_script = l_2_0._gui:script()
end

SecurityLockGui.setup = function(l_3_0)
  l_3_0._gui_script.working_text:set_render_template(Idstring("VertexColorTextured"))
  l_3_0._gui_script.time_header_text:set_render_template(Idstring("VertexColorTextured"))
  l_3_0._gui_script.time_text:set_render_template(Idstring("VertexColorTextured"))
  l_3_0._gui_script.screen_background:set_size(l_3_0._gui_script.screen_background:parent():size())
  local gui_w, gui_h = l_3_0._gui_script.screen_background:parent():size()
  local pad = 64
  local bar_pad = 16
  for i = 1, 3 do
    local icon = l_3_0._gui_script.timer_icon" .. 
    local timer_bg = l_3_0._gui_script.timer" .. i .. "_background
    local timer = l_3_0._gui_script.timer" .. 
    local title = l_3_0._gui_script.timer" .. i .. "_title
    local visible = i <= l_3_0._bars
    icon:set_visible(visible)
    timer_bg:set_visible(visible)
    timer:set_visible(visible)
    title:set_visible(visible)
    title:set_render_template(Idstring("VertexColorTextured"))
    icon:set_size(132, 132)
    icon:set_x(pad)
    icon:set_y(pad + icon:h() * (i - 1) + pad * (i - 1) + 350)
    local w, h = icon:size()
    timer_bg:set_h(h / 2)
    timer:set_h(timer_bg:h() - 8)
    title:set_h(h / 2)
    title:set_text(managers.localization:text("prop_security_lock_title", {NR = i}))
    title:set_font_size(h / 2 * l_3_0._size_multiplier)
    title:set_top(icon:top())
    title:set_left(icon:right() + pad)
    title:set_w(gui_w - (pad * 3 + w))
    timer_bg:set_bottom(icon:bottom())
    timer_bg:set_left(icon:right() + pad / 2)
    timer_bg:set_w(gui_w - (pad * 3 + w))
    timer:set_h(timer_bg:h() - bar_pad)
    timer:set_w(timer_bg:w() - bar_pad)
    timer:set_center(timer_bg:center())
    l_3_0._timer_lenght = timer:w()
    timer:set_w(0)
  end
  l_3_0._gui_script.working_text:set_center_x(l_3_0._gui_script.working_text:parent():w() / 2)
  l_3_0._gui_script.working_text:set_center_y(l_3_0._gui_script.working_text:parent():h() / 1.25)
  l_3_0._gui_script.working_text:set_font_size(80 * l_3_0._size_multiplier)
  l_3_0._gui_script.working_text:set_text(managers.localization:text(l_3_0._gui_start))
  l_3_0._gui_script.working_text:set_visible(true)
  l_3_0._gui_script.time_header_text:set_font_size(80 * l_3_0._size_multiplier)
  l_3_0._gui_script.time_header_text:set_visible(false)
  l_3_0._gui_script.time_header_text:set_center_x(l_3_0._gui_script.working_text:parent():w() / 2)
  l_3_0._gui_script.time_header_text:set_center_y(l_3_0._gui_script.working_text:parent():h() / 1.25)
  l_3_0._gui_script.time_text:set_font_size(110 * l_3_0._size_multiplier)
  l_3_0._gui_script.time_text:set_visible(false)
  l_3_0._gui_script.time_text:set_center_x(l_3_0._gui_script.working_text:parent():w() / 2)
  l_3_0._gui_script.time_text:set_center_y(l_3_0._gui_script.working_text:parent():h() / 1.1499999761581)
  l_3_0._original_colors = {}
  for _,child in ipairs(l_3_0._gui_script.panel:children()) do
    l_3_0._original_colors[child:key()] = child:color()
  end
end

SecurityLockGui._start = function(l_4_0, l_4_1, l_4_2, l_4_3)
  l_4_0._current_bar = l_4_1
  l_4_0._started = true
  l_4_0._done = false
  l_4_0._timer = l_4_2 or 5
  if not l_4_3 then
    l_4_0._current_timer = l_4_0._timer
  end
  l_4_0._gui_script.timer_icon" .. l_4_0._current_ba:set_image("units/world/architecture/secret_stash/props_textures/security_station_locked_df")
  l_4_0._gui_script.timer" .. l_4_0._current_ba:set_w(l_4_0._timer_lenght * (1 - l_4_0._current_timer / l_4_0._timer))
  l_4_0._gui_script.working_text:set_visible(false)
  l_4_0._unit:set_extension_update_enabled(Idstring("timer_gui"), true)
  l_4_0._update_enabled = true
  l_4_0:post_event(l_4_0._start_event)
  l_4_0._gui_script.time_header_text:set_visible(true)
  l_4_0._gui_script.time_text:set_visible(true)
  l_4_0._gui_script.time_text:set_text(math.floor(l_4_0._current_timer) .. " " .. managers.localization:text("prop_timer_gui_seconds"))
  if Network:is_client() then
    return 
  end
end

SecurityLockGui.restart = function(l_5_0, l_5_1, l_5_2)
  l_5_0:start(l_5_1, l_5_2, true)
end

SecurityLockGui.start = function(l_6_0, l_6_1, l_6_2, l_6_3)
  if not l_6_3 and l_6_0._started then
    return 
  end
  l_6_0:_start(l_6_1, l_6_2)
  if managers.network:session() then
     -- Warning: missing end command somewhere! Added here
  end
end

SecurityLockGui.sync_start = function(l_7_0, l_7_1, l_7_2)
  l_7_0:_start(l_7_1, l_7_2)
end

SecurityLockGui.update = function(l_8_0, l_8_1, l_8_2, l_8_3)
  if not l_8_0._powered then
    return 
  end
  l_8_0._current_timer = l_8_0._current_timer - l_8_3
  if not l_8_0._5sec_bars[l_8_0._current_bar] and l_8_0._current_timer < 5 then
    l_8_0._5sec_bars[l_8_0._current_bar] = true
    if l_8_0._unit:damage() then
      l_8_0._unit:damage():run_sequence_simple("5sec_" .. l_8_0._current_bar)
    end
  end
  l_8_0._gui_script.time_text:set_text(math.floor(l_8_0._current_timer) .. " " .. managers.localization:text("prop_timer_gui_seconds"))
  l_8_0._gui_script.timer" .. l_8_0._current_ba:set_w(l_8_0._timer_lenght * (1 - l_8_0._current_timer / l_8_0._timer))
  if l_8_0._current_timer <= 0 then
    l_8_0._unit:set_extension_update_enabled(Idstring("timer_gui"), false)
    l_8_0._update_enabled = false
    l_8_0:done()
  else
    l_8_0._gui_script.working_text:set_color(l_8_0._gui_script.working_text:color():with_alpha(0.5 + (math.sin(l_8_2 * 750) + 1) / 4))
  end
end

SecurityLockGui.set_visible = function(l_9_0, l_9_1)
  l_9_0._visible = l_9_1
  l_9_0._gui:set_visible(l_9_1)
end

SecurityLockGui.set_powered = function(l_10_0, l_10_1)
  l_10_0:_set_powered(l_10_1)
end

SecurityLockGui._set_powered = function(l_11_0, l_11_1)
  l_11_0._powered = l_11_1
  if not l_11_0._powered then
    for _,child in ipairs(l_11_0._gui_script.panel:children()) do
      local color = l_11_0._original_colors[child:key()]
      local c = Color(0, 0, 0, 0)
      child:set_color(c)
    end
  else
    for _,child in ipairs(l_11_0._gui_script.panel:children()) do
      child:set_color(l_11_0._original_colors[child:key()])
    end
  end
end

SecurityLockGui.done = function(l_12_0)
  l_12_0:_set_done()
  if l_12_0._unit:damage() then
    l_12_0._unit:damage():run_sequence_simple("done_" .. l_12_0._current_bar)
  end
  l_12_0:post_event(l_12_0._done_event)
end

SecurityLockGui._set_done = function(l_13_0, l_13_1)
  if not l_13_1 then
    l_13_1 = l_13_0._current_bar
  end
  l_13_0._done_bars[l_13_1] = true
  l_13_0._done = true
  l_13_0._gui_script.timer_icon" .. l_13_:set_image("units/world/architecture/secret_stash/props_textures/security_station_unlocked_df")
  l_13_0._gui_script.timer" .. l_13_:set_w(l_13_0._timer_lenght)
  l_13_0._gui_script.working_text:set_color(l_13_0._gui_script.working_text:color():with_alpha(1))
  l_13_0._gui_script.working_text:set_visible(true)
  if l_13_0._bars == l_13_1 then
    l_13_0._gui_script.working_text:set_text(managers.localization:text(l_13_0._gui_done))
  else
    l_13_0._started = false
  end
  l_13_0._gui_script.time_header_text:set_visible(false)
  l_13_0._gui_script.time_text:set_visible(false)
end

SecurityLockGui.post_event = function(l_14_0, l_14_1)
  if not l_14_1 then
    return 
  end
  l_14_0._unit:sound_source():post_event(l_14_1)
end

SecurityLockGui.lock_gui = function(l_15_0)
  l_15_0._ws:set_cull_distance(l_15_0._cull_distance)
  l_15_0._ws:set_frozen(true)
end

SecurityLockGui.destroy = function(l_16_0)
  if alive(l_16_0._new_gui) and alive(l_16_0._ws) then
    l_16_0._new_gui:destroy_workspace(l_16_0._ws)
    l_16_0._ws = nil
    l_16_0._new_gui = nil
  end
end

SecurityLockGui.save = function(l_17_0, l_17_1)
  local state = {}
  state.update_enabled = l_17_0._update_enabled
  state.timer = l_17_0._timer
  state.current_bar = l_17_0._current_bar
  state.current_timer = l_17_0._current_timer
  state.powered = l_17_0._powered
  state.done = l_17_0._done
  state.done_bars = l_17_0._done_bars
  state.visible = l_17_0._visible
  l_17_1.SecurityLockGui = state
end

SecurityLockGui.load = function(l_18_0, l_18_1)
  local state = l_18_1.SecurityLockGui
  for bar,_ in pairs(state.done_bars) do
    l_18_0:_set_done(bar)
  end
  if state.update_enabled then
    l_18_0:_start(state.current_bar, state.timer, state.current_timer)
    if not state.powered then
      l_18_0:_set_powered(state.powered)
    end
  end
  l_18_0:set_visible(state.visible)
end


