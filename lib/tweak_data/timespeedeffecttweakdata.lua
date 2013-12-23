-- Decompiled using luadec 2.0.1 by sztupy (http://winmo.sztupy.hu)
-- Command line was: F:\SteamLibrary\SteamApps\common\PAYDAY 2\lua\lib\tweak_data\timespeedeffecttweakdata.luac 

if not TimeSpeedEffectTweakData then
  TimeSpeedEffectTweakData = class()
end
TimeSpeedEffectTweakData.init = function(l_1_0)
  l_1_0:_init_base_effects()
  l_1_0:_init_mission_effects()
end

TimeSpeedEffectTweakData._init_base_effects = function(l_2_0)
  l_2_0.mask_on = {speed = 0.20000000298023, fade_in_delay = 1.3500000238419, fade_in = 0.25, sustain = 5, fade_out = 0.80000001192093, timer = "pausable"}
  l_2_0.mask_on_player = {speed = 0.5, fade_in_delay = l_2_0.mask_on.fade_in_delay, fade_in = l_2_0.mask_on.fade_in, sustain = l_2_0.mask_on.sustain, fade_out = l_2_0.mask_on.fade_out, timer = l_2_0.mask_on.timer, affect_timer = Idstring("player")}
  l_2_0.downed = {speed = 0.30000001192093, fade_in = 0.25, sustain = 3, fade_out = 0.80000001192093, timer = "pausable"}
  l_2_0.downed_player = {speed = l_2_0.downed.speed, fade_in = l_2_0.downed.fade_in, sustain = l_2_0.downed.sustain, fade_out = l_2_0.downed.fade_out, timer = l_2_0.downed.timer, affect_timer = Idstring("player")}
end

TimeSpeedEffectTweakData._init_mission_effects = function(l_3_0)
end


