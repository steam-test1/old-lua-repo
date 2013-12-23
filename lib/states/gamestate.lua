-- Decompiled using luadec 2.0.1 by sztupy (http://winmo.sztupy.hu)
-- Command line was: F:\SteamLibrary\SteamApps\common\PAYDAY 2\lua\lib\states\gamestate.luac 

core:import("CoreInternalGameState")
if not GameState then
  GameState = class(CoreInternalGameState.GameState)
end
GameState.freeflight_drop_player = function(l_1_0, l_1_1, l_1_2)
  if managers.player then
    managers.player:warp_to(l_1_1, l_1_2)
  end
end

GameState.set_controller_enabled = function(l_2_0, l_2_1)
end

GameState.default_transition = function(l_3_0, l_3_1, l_3_2)
  l_3_0:at_exit(l_3_1, l_3_2)
  l_3_0:set_controller_enabled(false)
  if l_3_0:gsm():is_controller_enabled() then
    l_3_1:set_controller_enabled(true)
  end
  l_3_1:at_enter(l_3_0, l_3_2)
end

GameState.on_disconnected = function(l_4_0)
  game_state_machine:change_state_by_name("disconnected")
end

GameState.on_server_left = function(l_5_0)
  game_state_machine:change_state_by_name("server_left")
end

CoreClass.override_class(CoreInternalGameState.GameState, GameState)

