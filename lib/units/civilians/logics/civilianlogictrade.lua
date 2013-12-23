-- Decompiled using luadec 2.0.1 by sztupy (http://winmo.sztupy.hu)
-- Command line was: F:\SteamLibrary\SteamApps\common\PAYDAY 2\lua\lib\units\civilians\logics\civilianlogictrade.luac 

CivilianLogicTrade = class(CopLogicTrade)
CivilianLogicTrade._chk_request_action_walk_to_flee_pos = function(l_1_0, l_1_1, l_1_2)
  local new_action_data = {}
  new_action_data.type = "walk"
  new_action_data.nav_path = l_1_1.flee_path
  new_action_data.variant = "run"
  new_action_data.body_part = 2
  l_1_1.walking_to_flee_pos = l_1_0.unit:brain():action_request(new_action_data)
  l_1_1.flee_path = nil
end


