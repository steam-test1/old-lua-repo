-- Decompiled using luadec 2.0.1 by sztupy (http://winmo.sztupy.hu)
-- Command line was: F:\SteamLibrary\SteamApps\common\PAYDAY 2\lua\lib\tweak_data\statisticstweakdata.luac 

if not StatisticsTweakData then
  StatisticsTweakData = class()
end
StatisticsTweakData.init = function(l_1_0)
  l_1_0.session = {}
  l_1_0.killed = {civilian = {total = {count = 0, type = "normal"}, head_shots = {count = 0, type = "normal"}, session = {count = 0, type = "session"}}, civilian = {count = 0, head_shots = 0}, security = {count = 0, head_shots = 0}, cop = {count = 0, head_shots = 0}, swat = {count = 0, head_shots = 0}, total = {count = 0, head_shots = 0}}
end


