-- Decompiled using luadec 2.0.1 by sztupy (http://winmo.sztupy.hu)
-- Command line was: F:\SteamLibrary\SteamApps\common\PAYDAY 2\lua\lib\states\ingameclean.luac 

require("lib/states/GameState")
if not IngameCleanState then
  IngameCleanState = class(IngamePlayerBaseState)
end
IngameCleanState.init = function(l_1_0, l_1_1)
  IngameCleanState.super.init(l_1_0, "ingame_clean", l_1_1)
end

IngameCleanState.at_enter = function(l_2_0)
  local players = managers.player:players()
  for k,player in ipairs(players) do
    local vp = player:camera():viewport()
    if vp then
      vp:set_active(true)
      for (for control),k in (for generator) do
      end
      Application:error("No viewport for player " .. tostring(k))
    end
    managers.hud:show(PlayerBase.PLAYER_INFO_HUD)
    managers.hud:show(PlayerBase.PLAYER_INFO_HUD_FULLSCREEN)
    local player = managers.player:player_unit()
    if player then
      player:base():set_enabled(true)
      player:character_damage():set_invulnerable(true)
    end
     -- Warning: missing end command somewhere! Added here
  end
end

IngameCleanState.at_exit = function(l_3_0)
  local player = managers.player:player_unit()
  if player then
    player:base():set_enabled(false)
    player:character_damage():set_invulnerable(false)
  end
  managers.hud:hide(PlayerBase.PLAYER_INFO_HUD)
  managers.hud:hide(PlayerBase.PLAYER_INFO_HUD_FULLSCREEN)
end

IngameCleanState.on_server_left = function(l_4_0)
  print("[IngameCleanState:on server_left]")
  game_state_machine:change_state_by_name("server_left")
end

IngameCleanState.on_kicked = function(l_5_0)
  print("[IngameCleanState:on on_kicked]")
  game_state_machine:change_state_by_name("kicked")
end

IngameCleanState.on_disconnected = function(l_6_0)
  game_state_machine:change_state_by_name("disconnected")
end


