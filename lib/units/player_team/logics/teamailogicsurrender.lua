-- Decompiled using luadec 2.0.1 by sztupy (http://winmo.sztupy.hu)
-- Command line was: F:\SteamLibrary\SteamApps\common\PAYDAY 2\lua\lib\units\player_team\logics\teamailogicsurrender.luac 

TeamAILogicSurrender = class(TeamAILogicBase)
TeamAILogicSurrender.on_cop_neutralized = TeamAILogicIdle.on_cop_neutralized
TeamAILogicSurrender.on_alert = TeamAILogicIdle.on_alert
TeamAILogicSurrender.on_recovered = TeamAILogicDisabled.on_recovered
TeamAILogicSurrender.enter = function(l_1_0, l_1_1, l_1_2)
  TeamAILogicBase.enter(l_1_0, l_1_1, l_1_2)
  l_1_0.unit:brain():cancel_all_pathing_searches()
  local old_internal_data = l_1_0.internal_data
  local my_data = {unit = l_1_0.unit}
  my_data.enemy_detect_slotmask = managers.slot:get_mask("enemies")
  my_data.rsrv_pos = {}
  if old_internal_data then
    if not old_internal_data.rsrv_pos then
      my_data.rsrv_pos = my_data.rsrv_pos
    end
    if old_internal_data.nearest_cover then
      my_data.nearest_cover = old_internal_data.nearest_cover
      managers.navigation:reserve_cover(my_data.nearest_cover[1], l_1_0.pos_rsrv_id)
    end
  end
  local action_data = {type = "act", body_part = 1, variant = "tied"}
  l_1_0.unit:brain():action_request(action_data)
  l_1_0.unit:brain():set_update_enabled_state(false)
  l_1_0.internal_data = my_data
  l_1_0.unit:movement():set_allow_fire(false)
  l_1_0.unit:interaction():set_tweak_data("free")
  l_1_0.unit:interaction():set_active(true, false)
  l_1_0.unit:character_damage():set_invulnerable(true)
  l_1_0.unit:character_damage():stop_bleedout()
  l_1_0.unit:base():set_slot(l_1_0.unit, 24)
  managers.groupai:state():on_criminal_neutralized(l_1_0.unit)
  TeamAILogicDisabled._register_revive_SO(l_1_0, my_data, "untie")
  if l_1_0.objective then
    managers.groupai:state():on_criminal_objective_failed(l_1_0.unit, l_1_0.objective, true)
    l_1_0.unit:brain():set_objective(nil)
  end
end

TeamAILogicSurrender.exit = function(l_2_0, l_2_1, l_2_2)
  TeamAILogicBase.exit(l_2_0, l_2_1, l_2_2)
  local my_data = l_2_0.internal_data
  my_data.exiting = true
  if my_data.nearest_cover then
    managers.navigation:release_cover(my_data.nearest_cover[1])
  end
  TeamAILogicDisabled._unregister_revive_SO(my_data)
  if l_2_1 ~= "inactive" then
    l_2_0.unit:brain():set_update_enabled_state(true)
    managers.groupai:state():on_criminal_recovered(l_2_0.unit)
    l_2_0.unit:base():set_slot(l_2_0.unit, 16)
    l_2_0.unit:character_damage():set_invulnerable(nil)
  end
  l_2_0.unit:interaction():set_active(false, false)
end

TeamAILogicSurrender.action_complete_clbk = function(l_3_0, l_3_1)
end

TeamAILogicSurrender.can_activate = function()
end

TeamAILogicSurrender.on_detected_enemy_destroyed = function(l_5_0, l_5_1)
  TeamAILogicIdle.on_cop_neutralized(l_5_0, l_5_1:key())
end

TeamAILogicSurrender.is_available_for_assignment = function(l_6_0)
end


