-- Decompiled using luadec 2.0.1 by sztupy (http://winmo.sztupy.hu)
-- Command line was: F:\SteamLibrary\SteamApps\common\PAYDAY 2\lua\lib\units\player_team\logics\teamailogicinactive.luac 

TeamAILogicInactive = class(TeamAILogicBase)
TeamAILogicInactive.enter = function(l_1_0, l_1_1, l_1_2)
  TeamAILogicBase.enter(l_1_0, l_1_1, l_1_2)
  local my_data = l_1_0.internal_data
  if my_data then
    local rsrv_pos = my_data.rsrv_pos
    if rsrv_pos.path then
      managers.navigation:unreserve_pos(rsrv_pos.path)
      rsrv_pos.path = nil
    end
    if rsrv_pos.move_dest then
      managers.navigation:unreserve_pos(rsrv_pos.move_dest)
      rsrv_pos.move_dest = nil
    end
    if rsrv_pos.stand then
      managers.navigation:unreserve_pos(rsrv_pos.stand)
      rsrv_pos.stand = nil
    end
  end
  CopLogicBase._set_attention_obj(l_1_0, nil, nil)
  CopLogicBase._destroy_all_detected_attention_object_data(l_1_0)
  CopLogicBase._reset_attention(l_1_0)
  l_1_0.internal_data = {}
  l_1_0.unit:brain():set_update_enabled_state(false)
  if l_1_0.objective then
    managers.groupai:state():on_criminal_objective_failed(l_1_0.unit, l_1_0.objective, true)
    l_1_0.unit:brain():set_objective(nil)
  end
end

TeamAILogicInactive.is_available_for_assignment = function(l_2_0)
  return false
end


