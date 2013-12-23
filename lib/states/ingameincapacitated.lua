-- Decompiled using luadec 2.0.1 by sztupy (http://winmo.sztupy.hu)
-- Command line was: F:\SteamLibrary\SteamApps\common\PAYDAY 2\lua\lib\states\ingameincapacitated.luac 

require("lib/states/GameState")
if not IngameIncapacitatedState then
  IngameIncapacitatedState = class(IngamePlayerBaseState)
end
IngameIncapacitatedState.init = function(l_1_0, l_1_1)
  IngameIncapacitatedState.super.init(l_1_0, "ingame_incapacitated", l_1_1)
end

IngameIncapacitatedState.update = function(l_2_0, l_2_1, l_2_2)
  local player = managers.player:player_unit()
  if not alive(player) then
    return 
  end
  if player:character_damage():update_incapacitated(l_2_1, l_2_2) then
    managers.player:force_drop_carry()
    managers.statistics:downed({death = true})
    IngameFatalState.on_local_player_dead()
    game_state_machine:change_state_by_name("ingame_waiting_for_respawn")
    player:character_damage():set_invulnerable(true)
    player:character_damage():set_health(0)
    player:base():_unregister()
    player:base():set_slot(player, 0)
  end
end

IngameIncapacitatedState.at_enter = function(l_3_0)
  local players = managers.player:players()
  for k,player in ipairs(players) do
    local vp = player:camera():viewport()
    if vp then
      vp:set_active(true)
      for (for control),k in (for generator) do
      end
      Application:error("No viewport for player " .. tostring(k))
    end
    managers.statistics:downed({incapacitated = true})
    do
      local player = managers.player:player_unit()
      if player then
        player:base():set_enabled(true)
      end
      managers.hud:show(PlayerBase.PLAYER_INFO_HUD)
      managers.hud:show(PlayerBase.PLAYER_INFO_HUD_FULLSCREEN)
      managers.hud:show(PlayerBase.PLAYER_DOWNED_HUD)
    end
     -- Warning: missing end command somewhere! Added here
  end
end

IngameIncapacitatedState.at_exit = function(l_4_0)
  local player = managers.player:player_unit()
  if player then
    player:base():set_enabled(false)
  end
  managers.hud:hide(PlayerBase.PLAYER_INFO_HUD)
  managers.hud:hide(PlayerBase.PLAYER_INFO_HUD_FULLSCREEN)
  managers.hud:hide(PlayerBase.PLAYER_DOWNED_HUD)
end

IngameIncapacitatedState.on_server_left = function(l_5_0)
  IngameCleanState.on_server_left(l_5_0)
end

IngameIncapacitatedState.on_kicked = function(l_6_0)
  IngameCleanState.on_kicked(l_6_0)
end

IngameIncapacitatedState.on_disconnected = function(l_7_0)
  IngameCleanState.on_disconnected(l_7_0)
end


