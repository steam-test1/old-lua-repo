-- Decompiled using luadec 2.0.1 by sztupy (http://winmo.sztupy.hu)
-- Command line was: F:\SteamLibrary\SteamApps\common\PAYDAY 2\lua\core\lib\utils\game_state_machine\coreinitstate.luac 

core:module("CoreInitState")
core:import("CoreInternalGameState")
if not _InitState then
  _InitState = class(CoreInternalGameState.GameState)
end
_InitState.init = function(l_1_0, l_1_1)
  CoreInternalGameState.GameState.init(l_1_0, "init", l_1_1)
end

_InitState.at_enter = function(l_2_0)
  error("[GameStateMachine] ERROR, you are not allowed to enter the init state")
end


