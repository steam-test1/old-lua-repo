-- Decompiled using luadec 2.0.1 by sztupy (http://winmo.sztupy.hu)
-- Command line was: F:\SteamLibrary\SteamApps\common\PAYDAY 2\lua\core\lib\managers\coreoverlayeffectmanager.luac 

core:module("CoreOverlayEffectManager")
core:import("CoreCode")
if not OverlayEffectManager then
  OverlayEffectManager = class()
end
OverlayEffectManager.init = function(l_1_0)
  local gui = Overlay:newgui()
  l_1_0._vp_overlay = Application:create_scene_viewport(0, 0, 1, 1)
  l_1_0._overlay_camera = Overlay:create_camera()
  l_1_0._vp_overlay:set_camera(l_1_0._overlay_camera)
  l_1_0._ws = gui:create_screen_workspace()
  l_1_0._ws:set_timer(TimerManager:main())
  l_1_0._playing_effects = {}
  l_1_0._paused = nil
  l_1_0._presets = {}
  l_1_0:add_preset("custom", {blend_mode = "normal", sustain = 0, fade_in = 0, fade_out = 0, color = Color(1, 0, 0, 0)})
  l_1_0:set_default_layer(30)
  managers.viewport:add_resolution_changed_func(callback(l_1_0, l_1_0, "change_resolution"))
end

OverlayEffectManager.set_visible = function(l_2_0, l_2_1)
  l_2_0._ws:panel():set_visible(l_2_1)
end

OverlayEffectManager.add_preset = function(l_3_0, l_3_1, l_3_2)
  l_3_0._presets[l_3_1] = l_3_2
end

OverlayEffectManager.presets = function(l_4_0)
  return l_4_0._presets
end

OverlayEffectManager.set_default_layer = function(l_5_0, l_5_1)
  l_5_0._default_layer = l_5_1
end

OverlayEffectManager.update = function(l_6_0, l_6_1, l_6_2)
  l_6_0._vp_overlay:update()
  l_6_0:check_pause_state()
  l_6_0:progress_effects(l_6_1, l_6_2)
end

OverlayEffectManager.destroy = function(l_7_0)
  if CoreCode.alive(l_7_0._overlay_camera) then
    Overlay:delete_camera(l_7_0._overlay_camera)
    l_7_0._overlay_camera = nil
  end
  if l_7_0._vp_overlay then
    Application:destroy_viewport(l_7_0._vp_overlay)
    l_7_0._vp_overlay = nil
  end
  if CoreCode.alive(l_7_0._ws) then
    Overlay:newgui():destroy_workspace(l_7_0._ws)
    l_7_0._ws = nil
  end
end

OverlayEffectManager.render = function(l_8_0)
  if Global.render_debug.render_overlay then
    Application:render("Overlay", l_8_0._vp_overlay)
  end
end

OverlayEffectManager.progress_effects = function(l_9_0, l_9_1, l_9_2, l_9_3)
  for key,effect in pairs(l_9_0._playing_effects) do
    local data = effect.data
    if (not data.timer or not data.timer:time()) and (not l_9_3 or not TimerManager:game():time()) then
      local eff_t = l_9_3 and not data.play_paused or l_9_1
    end
    local fade_in_end_t = effect.start_t + data.fade_in
    if data.sustain then
      local sustain_end_t = fade_in_end_t + data.sustain
    end
    if sustain_end_t then
      local effect_end_t = sustain_end_t + data.fade_out
    end
    local new_alpha = nil
    if eff_t < fade_in_end_t then
      new_alpha = (eff_t - effect.start_t) / data.fade_in
    elseif not sustain_end_t or eff_t < sustain_end_t then
      new_alpha = 1
    elseif eff_t < effect_end_t then
      new_alpha = 1 - (eff_t - sustain_end_t) / data.fade_out
    else
      l_9_0._ws:panel():remove(effect.rectangle)
      l_9_0._playing_effects[key] = nil
    end
    if new_alpha then
      new_alpha = (new_alpha) * data.color.alpha
      effect.current_alpha = new_alpha
      if effect.gradient_points then
        for i = 2, #effect.gradient_points, 2 do
          effect.gradient_points[i] = effect.gradient_points[i]:with_alpha(new_alpha)
        end
        effect.rectangle:set_gradient_points(effect.gradient_points)
        for (for control),key in (for generator) do
        end
        effect.rectangle:set_color(data.color:with_alpha(new_alpha))
      end
    end
     -- Warning: missing end command somewhere! Added here
  end
end

OverlayEffectManager.paused_update = function(l_10_0, l_10_1, l_10_2)
  l_10_0:check_pause_state(true)
  l_10_0:progress_effects(l_10_1, l_10_2, true)
end

OverlayEffectManager.check_pause_state = function(l_11_0, l_11_1)
  if l_11_0._paused and not l_11_1 then
    for key,effect in pairs(l_11_0._playing_effects) do
      effect.rectangle:show()
    end
    l_11_0._paused = nil
    do return end
    if l_11_1 then
      for _,effect in pairs(l_11_0._playing_effects) do
        if not effect.data.play_paused then
          effect.rectangle:hide()
        end
      end
      l_11_0._paused = true
    end
  end
end

OverlayEffectManager.play_effect = function(l_12_0, l_12_1)
  if l_12_1.fade_in <= 0 or not 0 then
    local spawn_alpha = l_12_1.color.alpha * (not l_12_1 or 1)
  end
  local rectangle = nil
  if l_12_1.gradient_points then
    rectangle = l_12_0._ws:panel():gradient({w = RenderSettings.resolution.x, h = RenderSettings.resolution.y, color = l_12_1.color:with_alpha(spawn_alpha), gradient_points = l_12_1.gradient_points, orientation = l_12_1.orientation})
  else
    rectangle = l_12_0._ws:panel():rect({w = RenderSettings.resolution.x, h = RenderSettings.resolution.y, color = l_12_1.color:with_alpha(spawn_alpha)})
  end
  rectangle:set_layer(l_12_0._default_layer)
  rectangle:set_blend_mode(l_12_1.blend_mode)
  if l_12_1.play_paused or not l_12_0._paused then
    rectangle:show()
  else
    rectangle:hide()
  end
   -- DECOMPILER ERROR: Confused while interpreting a jump as a 'while'

end
local effect = {rectangle = rectangle, start_t = TimerManager:game():time(), data = {}, current_alpha = spawn_alpha, gradient_points = l_12_1.gradient_points}
for key,value in pairs(l_12_1) do
  effect.data[key] = value
end
do
  local id = 1
  repeat
    if l_12_0._playing_effects[id] then
      id = id + 1
    else
      table.insert(l_12_0._playing_effects, id, effect)
      return id
    end
    do return end
    cat_error("georgios", "OverlayEffectManager, no effect_data sent to play_effect")
     -- Warning: missing end command somewhere! Added here
  end
end

OverlayEffectManager.stop_effect = function(l_13_0, l_13_1)
  if l_13_1 and l_13_0._playing_effects[l_13_1] then
    l_13_0._ws:panel():remove(l_13_0._playing_effects[l_13_1].rectangle)
    l_13_0._playing_effects[l_13_1] = nil
    do return end
    for key,effect in pairs(l_13_0._playing_effects) do
      l_13_0._ws:panel():remove(effect.rectangle)
      l_13_0._playing_effects[key] = nil
    end
  end
end

OverlayEffectManager.fade_out_effect = function(l_14_0, l_14_1)
  if l_14_1 then
    local effect = l_14_0._playing_effects[l_14_1]
    if effect then
      if not effect.data.timer then
        effect.start_t = TimerManager:game():time()
        effect.data.sustain = 0
        effect.data.fade_in = 0
        effect.data.color = effect.data.color:with_alpha(effect.current_alpha)
      else
        for key,effect in pairs(l_14_0._playing_effects) do
          if not effect.data.timer then
            effect.start_t = TimerManager:game():time()
            effect.data.sustain = 0
            effect.data.fade_in = 0
            effect.data.color = effect.data.color:with_alpha(effect.current_alpha)
          end
        end
      end
       -- Warning: missing end command somewhere! Added here
    end
     -- Warning: missing end command somewhere! Added here
  end
end

OverlayEffectManager.change_resolution = function(l_15_0)
  local res = RenderSettings.resolution
  for _,effect in pairs(l_15_0._playing_effects) do
    effect.rectangle:configure({w = res.x, h = res.y})
  end
end


