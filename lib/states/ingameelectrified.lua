-- Decompiled using luadec 2.0.1 by sztupy (http://winmo.sztupy.hu)
-- Command line was: F:\SteamLibrary\SteamApps\common\PAYDAY 2\lua\lib\states\ingameelectrified.luac 

require("lib/states/GameState")
if not IngameElectrifiedState then
  IngameElectrifiedState = class(IngamePlayerBaseState)
end
IngameElectrifiedState.init = function(l_1_0, l_1_1)
  IngamePlayerBaseState.super.init(l_1_0, "ingame_electrified", l_1_1)
end

IngameElectrifiedState.update = function(l_2_0, l_2_1, l_2_2)
end

IngameElectrifiedState.at_enter = function(l_3_0)
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
      managers.hud:show(PlayerBase.PLAYER_INFO_HUD)
      managers.hud:show(PlayerBase.PLAYER_INFO_HUD_FULLSCREEN)
    end
     -- Warning: missing end command somewhere! Added here
  end
end

IngameElectrifiedState.at_exit = function(l_4_0)
  local player = managers.player:player_unit()
  if player then
    player:base():set_enabled(false)
  end
  managers.hud:hide(PlayerBase.PLAYER_INFO_HUD)
  managers.hud:hide(PlayerBase.PLAYER_INFO_HUD_FULLSCREEN)
end

IngameElectrifiedState.on_server_left = function(l_5_0)
  IngameCleanState.on_server_left(l_5_0)
end

IngameElectrifiedState.on_kicked = function(l_6_0)
  IngameCleanState.on_kicked(l_6_0)
end

IngameElectrifiedState.on_disconnected = function(l_7_0)
  IngameCleanState.on_disconnected(l_7_0)
end


