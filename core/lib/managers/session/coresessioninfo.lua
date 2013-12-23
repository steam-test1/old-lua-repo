-- Decompiled using luadec 2.0.1 by sztupy (http://winmo.sztupy.hu)
-- Command line was: F:\SteamLibrary\SteamApps\common\PAYDAY 2\lua\core\lib\managers\session\coresessioninfo.luac 

core:module("CoreSessionInfo")
if not Info then
  Info = class()
end
Info.init = function(l_1_0)
end

Info.is_ranked = function(l_2_0)
  return l_2_0._is_ranked
end

Info.can_join_in_progress = function(l_3_0)
  return l_3_0._can_join_in_progress
end

Info.set_can_join_in_progress = function(l_4_0, l_4_1)
  l_4_0._can_join_in_progress = l_4_1
end

Info.set_level_name = function(l_5_0, l_5_1)
  l_5_0._level_name = l_5_1
end

Info.level_name = function(l_6_0)
  return l_6_0._level_name
end

Info.set_stage_name = function(l_7_0, l_7_1)
  l_7_0._stage_name = l_7_1
end

Info.stage_name = function(l_8_0)
  return l_8_0._stage_name
end

Info.set_run_mission_script = function(l_9_0, l_9_1)
  l_9_0._run_mission_script = l_9_1
end

Info.should_run_mission_script = function(l_10_0)
  return l_10_0._run_mission_script
end

Info.set_should_load_level = function(l_11_0, l_11_1)
  l_11_0._should_load_level = l_11_1
end

Info.should_load_level = function(l_12_0)
  return l_12_0._should_load_level
end


