-- Decompiled using luadec 2.0.1 by sztupy (http://winmo.sztupy.hu)
-- Command line was: F:\SteamLibrary\SteamApps\common\PAYDAY 2\lua\lib\network\extensions\player_team\huskteamaimovement.luac 

if not HuskTeamAIMovement then
  HuskTeamAIMovement = class(TeamAIMovement)
end
HuskTeamAIMovement.init = function(l_1_0, l_1_1)
  HuskTeamAIMovement.super.init(l_1_0, l_1_1)
  l_1_0._queued_actions = {}
  l_1_0._m_host_stop_pos = mvector3.copy(l_1_0._m_pos)
end

HuskTeamAIMovement._post_init = function(l_2_0)
  l_2_0:play_redirect("idle")
end

HuskTeamAIMovement.sync_arrested = function(l_3_0)
  l_3_0._unit:interaction():set_tweak_data("free")
  l_3_0._unit:interaction():set_active(true, false)
  managers.hud:set_mugshot_cuffed(l_3_0._unit:unit_data().mugshot_id)
  l_3_0._unit:base():set_slot(l_3_0._unit, 24)
end

HuskTeamAIMovement._upd_actions = function(l_4_0, l_4_1)
  TeamAIMovement._upd_actions(l_4_0, l_4_1)
  HuskCopMovement._chk_start_queued_action(l_4_0)
end

HuskTeamAIMovement.action_request = function(l_5_0, l_5_1)
  return HuskCopMovement.action_request(l_5_0, l_5_1)
end

HuskTeamAIMovement.chk_action_forbidden = function(l_6_0, l_6_1)
  return HuskCopMovement.chk_action_forbidden(l_6_0, l_6_1)
end


