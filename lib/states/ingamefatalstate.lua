-- Decompiled using luadec 2.0.1 by sztupy (http://winmo.sztupy.hu)
-- Command line was: F:\SteamLibrary\SteamApps\common\PAYDAY 2\lua\lib\states\ingamefatalstate.luac 

require("lib/states/GameState")
if not IngameFatalState then
  IngameFatalState = class(IngamePlayerBaseState)
end
IngameFatalState.init = function(l_1_0, l_1_1)
  IngameFatalState.super.init(l_1_0, "ingame_fatal", l_1_1)
end

IngameFatalState.on_local_player_dead = function()
  local peer_id = managers.network:session():local_peer():id()
  local player = managers.player:player_unit()
  player:network():send("sync_player_movement_state", "dead", player:character_damage():down_time(), player:id())
  managers.groupai:state():on_player_criminal_death(peer_id)
end

IngameFatalState.update = function(l_3_0, l_3_1, l_3_2)
  local player = managers.player:player_unit()
  if not alive(player) then
    return 
  end
  if player:character_damage():update_downed(l_3_1, l_3_2) then
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

IngameFatalState.at_enter = function(l_4_0)
  local players = managers.player:players()
  for k,player in ipairs(players) do
    local vp = player:camera():viewport()
    if vp then
      vp:set_active(true)
      for (for control),k in (for generator) do
      end
      Application:error("No viewport for player " .. tostring(k))
    end
    managers.statistics:downed({fatal = true})
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

IngameFatalState.at_exit = function(l_5_0)
  local player = managers.player:player_unit()
  if player then
    player:base():set_enabled(false)
  end
  managers.hud:hide(PlayerBase.PLAYER_INFO_HUD)
  managers.hud:hide(PlayerBase.PLAYER_INFO_HUD_FULLSCREEN)
  managers.hud:hide(PlayerBase.PLAYER_DOWNED_HUD)
end

IngameFatalState.on_server_left = function(l_6_0)
  IngameCleanState.on_server_left(l_6_0)
end

IngameFatalState.on_kicked = function(l_7_0)
  IngameCleanState.on_kicked(l_7_0)
end

IngameFatalState.on_disconnected = function(l_8_0)
  IngameCleanState.on_disconnected(l_8_0)
end


