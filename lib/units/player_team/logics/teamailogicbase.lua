-- Decompiled using luadec 2.0.1 by sztupy (http://winmo.sztupy.hu)
-- Command line was: F:\SteamLibrary\SteamApps\common\PAYDAY 2\lua\lib\units\player_team\logics\teamailogicbase.luac 

require("lib/units/enemies/cop/logics/CopLogicBase")
if not TeamAILogicBase then
  TeamAILogicBase = class(CopLogicBase)
end
TeamAILogicBase.on_long_dis_interacted = function(l_1_0, l_1_1)
end

TeamAILogicBase.on_cop_neutralized = function(l_2_0, l_2_1)
end

TeamAILogicBase.on_recovered = function(l_3_0, l_3_1)
end

TeamAILogicBase.clbk_heat = function(l_4_0)
end

TeamAILogicBase.on_objective_unit_destroyed = function(l_5_0, l_5_1)
  l_5_0.objective.destroy_clbk_key = nil
  l_5_0.objective.death_clbk_key = nil
  managers.groupai:state():on_criminal_objective_failed(l_5_0.unit, l_5_0.objective)
end

TeamAILogicBase._get_logic_state_from_reaction = function(l_6_0, l_6_1)
  if not l_6_1 or l_6_1 <= AIAttentionObject.REACT_SCARED then
    return "idle"
  else
    return "assault"
  end
end

TeamAILogicBase._set_attention_obj = function(l_7_0, l_7_1, l_7_2)
  local old_att_obj = l_7_0.attention_obj
  l_7_0.attention_obj = l_7_1
  if l_7_1 and not l_7_2 then
    l_7_1.reaction = l_7_1.settings.reaction
  end
  if old_att_obj and l_7_1 and old_att_obj.u_key == l_7_1.u_key and l_7_1.stare_expire_t and l_7_1.stare_expire_t < l_7_0.t and l_7_1.settings.pause then
    l_7_1.stare_expire_t = nil
    l_7_1.pause_expire_t = l_7_0.t + math.lerp(l_7_1.settings.pause[1], l_7_1.settings.pause[2], math.random())
    print("[TeamAILogicBase._chk_focus_on_attention_object] pausing for", current_attention.pause_expire_t - l_7_0.t, "sec")
    do return end
    if l_7_1.pause_expire_t and l_7_1.pause_expire_t < l_7_0.t then
      l_7_1.pause_expire_t = nil
      l_7_1.stare_expire_t = l_7_0.t + math.lerp(l_7_1.settings.duration[1], l_7_1.settings.duration[2], math.random())
      do return end
      if l_7_1 and l_7_1.settings.duration then
        l_7_1.stare_expire_t = l_7_0.t + math.lerp(l_7_1.settings.duration[1], l_7_1.settings.duration[2], math.random())
        l_7_1.pause_expire_t = nil
      end
    end
  end
end

TeamAILogicBase._chk_nearly_visible_chk_needed = function(l_8_0, l_8_1, l_8_2)
  return not l_8_0.attention_obj or l_8_0.attention_obj.key == l_8_2
end

TeamAILogicBase._chk_reaction_to_attention_object = function(l_9_0, l_9_1, l_9_2)
  local att_unit = l_9_1.unit
  if not l_9_1.is_person or att_unit:character_damage() and att_unit:character_damage():dead() then
    return l_9_1.settings.reaction
  end
  if l_9_0.cool then
    return math.min(l_9_1.settings.reaction, AIAttentionObject.REACT_SURPRISED)
  elseif l_9_2 then
    return math.min(l_9_1.settings.reaction, AIAttentionObject.REACT_SHOOT)
  else
    return l_9_1.settings.reaction
  end
end


