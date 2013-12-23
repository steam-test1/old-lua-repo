-- Decompiled using luadec 2.0.1 by sztupy (http://winmo.sztupy.hu)
-- Command line was: F:\SteamLibrary\SteamApps\common\PAYDAY 2\lua\core\lib\utils\dev\smoketest\suites\coresmoketestloadlevelsuite.luac 

core:module("CoreSmoketestLoadLevelSuite")
core:import("CoreClass")
core:import("CoreSmoketestCommonSuite")
if not LoadLevelSuite then
  LoadLevelSuite = class(CoreSmoketestCommonSuite.CommonSuite)
end
LoadLevelSuite.init = function(l_1_0)
  LoadLevelSuite.super.init(l_1_0)
  l_1_0:add_step("load_level", CoreSmoketestCommonSuite.CallAndWaitEventSubstep, CoreSmoketestCommonSuite.CallAndWaitEventSubstep.step_arguments(callback(l_1_0, l_1_0, "load_level"), Idstring("game_state_ingame")))
  l_1_0:add_step("in_game", CoreSmoketestCommonSuite.DelaySubstep, CoreSmoketestCommonSuite.DelaySubstep.step_arguments(1))
end

LoadLevelSuite.load_level = function(l_2_0)
  local session_info = l_2_0._session_state:session_info()
  session_info:set_level_name(l_2_0:get_argument("level"))
  l_2_0._session_state:player_slots():primary_slot():request_debug_local_user_binding()
  l_2_0._session_state:join_standard_session()
end


