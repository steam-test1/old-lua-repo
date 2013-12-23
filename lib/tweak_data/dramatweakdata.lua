-- Decompiled using luadec 2.0.1 by sztupy (http://winmo.sztupy.hu)
-- Command line was: F:\SteamLibrary\SteamApps\common\PAYDAY 2\lua\lib\tweak_data\dramatweakdata.luac 

if not DramaTweakData then
  DramaTweakData = class()
end
DramaTweakData.init = function(l_1_0)
  l_1_0:_create_table_structure()
  l_1_0.drama_actions = {criminal_dead = 0.20000000298023, criminal_disabled = 0.10000000149012, criminal_hurt = 0.5}
  l_1_0.decay_period = 30
  l_1_0.max_dis = 6000
  l_1_0.max_dis_mul = 0.5
  l_1_0.low = 0.10000000149012
  l_1_0.peak = 0.94999998807907
  l_1_0.assault_fade_end = 0.25
end

DramaTweakData._create_table_structure = function(l_2_0)
end


