-- Decompiled using luadec 2.0.1 by sztupy (http://winmo.sztupy.hu)
-- Command line was: F:\SteamLibrary\SteamApps\common\PAYDAY 2\lua\lib\states\ingamestandard.luac 

require("lib/states/GameState")
if not IngameStandardState then
  IngameStandardState = class(IngamePlayerBaseState)
end
IngameStandardState.init = function(l_1_0, l_1_1)
  IngameStandardState.super.init(l_1_0, "ingame_standard", l_1_1)
end

IngameStandardState.at_enter = function(l_2_0)
  local players = managers.player:players()
  for k,player in ipairs(players) do
    local vp = player:camera():viewport()
    if vp then
      vp:set_active(true)
      for (for control),k in (for generator) do
      end
      Application:error("No viewport for player " .. tostring(k))
    end
    do
      local player = managers.player:player_unit()
      if player then
        player:base():set_enabled(true)
      end
      managers.hud:show(PlayerBase.PLAYER_HUD)
      managers.hud:show(PlayerBase.PLAYER_INFO_HUD)
      managers.hud:show(PlayerBase.PLAYER_INFO_HUD_FULLSCREEN)
    end
     -- Warning: missing end command somewhere! Added here
  end
end

IngameStandardState.at_exit = function(l_3_0)
  managers.environment_controller:set_dof_distance()
  managers.hud:hide(PlayerBase.PLAYER_HUD)
  managers.hud:hide(PlayerBase.PLAYER_INFO_HUD)
  managers.hud:hide(PlayerBase.PLAYER_INFO_HUD_FULLSCREEN)
  local player = managers.player:player_unit()
  if player then
    player:base():set_enabled(false)
  end
end

IngameStandardState.on_server_left = function(l_4_0)
  IngameCleanState.on_server_left(l_4_0)
end

IngameStandardState.on_kicked = function(l_5_0)
  IngameCleanState.on_kicked(l_5_0)
end

IngameStandardState.on_disconnected = function(l_6_0)
  IngameCleanState.on_disconnected(l_6_0)
end


