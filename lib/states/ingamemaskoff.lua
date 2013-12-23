-- Decompiled using luadec 2.0.1 by sztupy (http://winmo.sztupy.hu)
-- Command line was: F:\SteamLibrary\SteamApps\common\PAYDAY 2\lua\lib\states\ingamemaskoff.luac 

require("lib/states/GameState")
if not IngameMaskOffState then
  IngameMaskOffState = class(IngamePlayerBaseState)
end
IngameMaskOffState.init = function(l_1_0, l_1_1)
  IngameMaskOffState.super.init(l_1_0, "ingame_mask_off", l_1_1)
  l_1_0._MASK_OFF_HUD = Idstring("guis/mask_off_hud")
end

IngameMaskOffState.at_enter = function(l_2_0)
  local players = managers.player:players()
  for k,player in ipairs(players) do
    local vp = player:camera():viewport()
    if vp then
      vp:set_active(true)
      for (for control),k in (for generator) do
      end
      Application:error("No viewport for player " .. tostring(k))
    end
    if not managers.hud:exists(l_2_0._MASK_OFF_HUD) then
      managers.hud:load_hud(l_2_0._MASK_OFF_HUD, false, false, true, {})
    end
    managers.hud:show(l_2_0._MASK_OFF_HUD)
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

IngameMaskOffState.at_exit = function(l_3_0)
  local player = managers.player:player_unit()
  if player then
    player:base():set_enabled(false)
    player:character_damage():set_invulnerable(false)
  end
  managers.hud:hide(l_3_0._MASK_OFF_HUD)
  managers.hud:hide(PlayerBase.PLAYER_INFO_HUD)
  managers.hud:hide(PlayerBase.PLAYER_INFO_HUD_FULLSCREEN)
end

IngameMaskOffState.on_server_left = function(l_4_0)
  IngameCleanState.on_server_left(l_4_0)
end

IngameMaskOffState.on_kicked = function(l_5_0)
  IngameCleanState.on_kicked(l_5_0)
end

IngameMaskOffState.on_disconnected = function(l_6_0)
  IngameCleanState.on_disconnected(l_6_0)
end


