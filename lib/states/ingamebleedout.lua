-- Decompiled using luadec 2.0.1 by sztupy (http://winmo.sztupy.hu)
-- Command line was: F:\SteamLibrary\SteamApps\common\PAYDAY 2\lua\lib\states\ingamebleedout.luac 

require("lib/states/GameState")
if not IngameBleedOutState then
  IngameBleedOutState = class(IngamePlayerBaseState)
end
IngameBleedOutState.init = function(l_1_0, l_1_1)
  IngameBleedOutState.super.init(l_1_0, "ingame_bleed_out", l_1_1)
end

IngameBleedOutState.update = function(l_2_0, l_2_1, l_2_2)
  local player = managers.player:player_unit()
  if not alive(player) then
    return 
  end
  if player:movement():nav_tracker() and player:character_damage():update_downed(l_2_1, l_2_2) then
    managers.player:force_drop_carry()
    managers.statistics:downed({death = true})
    IngameFatalState.on_local_player_dead()
    player:base():set_enabled(false)
    game_state_machine:change_state_by_name("ingame_waiting_for_respawn")
    player:character_damage():set_invulnerable(true)
    player:character_damage():set_health(0)
    player:base():_unregister()
    player:base():set_slot(player, 0)
  end
end

IngameBleedOutState.at_enter = function(l_3_0)
  local players = managers.player:players()
  for k,player in ipairs(players) do
    local vp = player:camera():viewport()
    if vp then
      vp:set_active(true)
      for (for control),k in (for generator) do
      end
      Application:error("No viewport for player " .. tostring(k))
    end
    managers.statistics:downed({bleed_out = true})
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

IngameBleedOutState.at_exit = function(l_4_0)
  managers.challenges:reset("exit_bleed_out")
  local player = managers.player:player_unit()
  if player then
    player:base():set_enabled(false)
  end
  managers.hud:hide(PlayerBase.PLAYER_INFO_HUD)
  managers.hud:hide(PlayerBase.PLAYER_INFO_HUD_FULLSCREEN)
  managers.hud:hide(PlayerBase.PLAYER_DOWNED_HUD)
end

IngameBleedOutState.on_server_left = function(l_5_0)
  IngameCleanState.on_server_left(l_5_0)
end

IngameBleedOutState.on_kicked = function(l_6_0)
  IngameCleanState.on_kicked(l_6_0)
end

IngameBleedOutState.on_disconnected = function(l_7_0)
  IngameCleanState.on_disconnected(l_7_0)
end


