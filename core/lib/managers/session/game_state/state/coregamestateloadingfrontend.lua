-- Decompiled using luadec 2.0.1 by sztupy (http://winmo.sztupy.hu)
-- Command line was: F:\SteamLibrary\SteamApps\common\PAYDAY 2\lua\core\lib\managers\session\game_state\state\coregamestateloadingfrontend.luac 

core:module("CoreGameStateLoadingFrontEnd")
core:import("CoreGameStatePreFrontEnd")
if not LoadingFrontEnd then
  LoadingFrontEnd = class()
end
LoadingFrontEnd.init = function(l_1_0)
  l_1_0._debug_time = l_1_0.game_state._session_manager:_debug_time()
  for _,unit in ipairs(World:find_units_quick("all")) do
    unit:set_slot(0)
  end
end

LoadingFrontEnd.destroy = function(l_2_0)
end

LoadingFrontEnd.transition = function(l_3_0)
  local current_time = l_3_0.game_state._session_manager:_debug_time()
  if l_3_0._debug_time + 2 < current_time then
    return CoreGameStatePreFrontEnd.PreFrontEnd
  end
end


