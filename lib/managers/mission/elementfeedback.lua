-- Decompiled using luadec 2.0.1 by sztupy (http://winmo.sztupy.hu)
-- Command line was: F:\SteamLibrary\SteamApps\common\PAYDAY 2\lua\lib\managers\mission\elementfeedback.luac 

core:import("CoreMissionScriptElement")
if not ElementFeedback then
  ElementFeedback = class(CoreMissionScriptElement.MissionScriptElement)
end
ElementFeedback.IDS_EFFECT = Idstring("effect")
ElementFeedback.init = function(l_1_0, ...)
  ElementFeedback.super.init(l_1_0, ...)
  l_1_0._feedback = managers.feedback:create(l_1_0._values.effect)
  if Application:editor() and l_1_0._values.above_camera_effect ~= "none" then
    CoreEngineAccess._editor_load(l_1_0.IDS_EFFECT, l_1_0._values.above_camera_effect:id())
     -- DECOMPILER ERROR: Confused about usage of registers for local variables.

  end
end

ElementFeedback.client_on_executed = function(l_2_0, ...)
  l_2_0:on_executed(...)
   -- DECOMPILER ERROR: Confused about usage of registers for local variables.

end

ElementFeedback.on_executed = function(l_3_0, l_3_1)
  if not l_3_0._values.enabled then
    return 
  end
  local player = managers.player:player_unit()
  if player then
    l_3_0._feedback:set_unit(player)
    l_3_0._feedback:set_enabled("rumble", l_3_0._values.use_rumble)
    l_3_0._feedback:set_enabled("camera_shake", l_3_0._values.use_camera_shake)
    local multiplier = l_3_0:_calc_multiplier(player)
    local params = {}
    l_3_0:_check_value(params, "camera_shake", "multiplier", multiplier)
    l_3_0:_check_value(params, "camera_shake", "amplitude", l_3_0._values.camera_shake_amplitude)
    l_3_0:_check_value(params, "camera_shake", "attack", l_3_0._values.camera_shake_attack)
    l_3_0:_check_value(params, "camera_shake", "sustain", l_3_0._values.camera_shake_sustain)
    l_3_0:_check_value(params, "camera_shake", "decay", l_3_0._values.camera_shake_decay)
    l_3_0:_check_value(params, "rumble", "multiplier_data", multiplier)
    l_3_0:_check_value(params, "rumble", "peak", l_3_0._values.rumble_peak)
    l_3_0:_check_value(params, "rumble", "attack", l_3_0._values.rumble_attack)
    l_3_0:_check_value(params, "rumble", "sustain", l_3_0._values.rumble_sustain)
    l_3_0:_check_value(params, "rumble", "release", l_3_0._values.rumble_release)
    l_3_0._feedback:set_enabled("above_camera_effect", 1 - l_3_0._values.above_camera_effect_distance <= multiplier)
    table.insert(params, "above_camera_effect")
    table.insert(params, "effect")
    table.insert(params, l_3_0._values.above_camera_effect)
    l_3_0._feedback:play(unpack(params))
  end
  ElementFeedback.super.on_executed(l_3_0, l_3_1)
end

ElementFeedback._check_value = function(l_4_0, l_4_1, l_4_2, l_4_3, l_4_4)
  if l_4_4 >= 0 then
    table.insert(l_4_1, l_4_2)
    table.insert(l_4_1, l_4_3)
    table.insert(l_4_1, l_4_4)
  end
end

ElementFeedback._calc_multiplier = function(l_5_0, l_5_1)
  if l_5_0._values.range == 0 then
    return 1
  end
  local distance = l_5_0._values.position - l_5_1:position():length()
  local mul = math.clamp(1 - distance / l_5_0._values.range, 0, 1)
  return mul
end


