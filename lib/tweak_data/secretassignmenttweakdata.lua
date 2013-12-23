-- Decompiled using luadec 2.0.1 by sztupy (http://winmo.sztupy.hu)
-- Command line was: F:\SteamLibrary\SteamApps\common\PAYDAY 2\lua\lib\tweak_data\secretassignmenttweakdata.luac 

if not SecretAssignmentTweakData then
  SecretAssignmentTweakData = class()
end
SecretAssignmentTweakData.init = function(l_1_0)
  l_1_0.bank_manager = {}
  l_1_0.bank_manager.type = "kill"
  l_1_0.bank_manager.title_id = "sa_bank_manager_hl"
  l_1_0.bank_manager.description_id = "sa_bank_manager"
  l_1_0.civilian_escape = {}
  l_1_0.civilian_escape.type = "civilian_escape"
  l_1_0.civilian_escape.title_id = "sa_civilian_escape_hl"
  l_1_0.civilian_escape.description_id = "sa_civilian_escape"
  l_1_0.civilian_escape.time_limit = 300
  l_1_0.civilian_escape.time_limit_success = true
  l_1_0.civilian_escape.level_filter = {include = {"bank"}}
end


