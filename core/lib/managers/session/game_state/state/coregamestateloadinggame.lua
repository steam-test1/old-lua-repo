-- Decompiled using luadec 2.0.1 by sztupy (http://winmo.sztupy.hu)
-- Command line was: F:\SteamLibrary\SteamApps\common\PAYDAY 2\lua\core\lib\managers\session\game_state\state\coregamestateloadinggame.luac 

require("core/lib/utils/dev/editor/WorldHolder")
core:module("CoreGameStateLoadingGame")
core:import("CoreGameStateInGame")
if not LoadingGame then
  LoadingGame = class()
end
LoadingGame.init = function(l_1_0)
  l_1_0._debug_time = l_1_0.game_state._session_manager:_debug_time()
  for _,unit in ipairs(World:find_units_quick("all")) do
    unit:set_slot(0)
  end
  local session_info = l_1_0.game_state._session_manager:session():session_info()
  local factory = l_1_0.game_state._session_manager._factory
  local level_name = session_info:level_name()
  local stage_name = session_info:stage_name() or "stage1"
  local level = Level:load(level_name)
  level:create("dynamics", "statics")
  managers.mission:parse(level_name, stage_name, nil, "mission")
  l_1_0._level_handler = factory:create_level_handler()
  l_1_0._level_handler:set_player_slots(l_1_0.game_state:player_slots())
  l_1_0.game_state:player_slots():enter_level_handler(l_1_0._level_handler)
  local local_user_manager = l_1_0.game_state._session_manager._local_user_manager
  local_user_manager:enter_level_handler(l_1_0._level_handler)
end

LoadingGame.destroy = function(l_2_0)
end

LoadingGame.transition = function(l_3_0)
  local current_time = l_3_0.game_state._session_manager:_debug_time()
  if l_3_0._debug_time + 2 < current_time then
    return CoreGameStateInGame.InGame, l_3_0._level_handler
  end
end


