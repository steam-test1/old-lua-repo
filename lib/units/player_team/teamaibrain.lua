-- Decompiled using luadec 2.0.1 by sztupy (http://winmo.sztupy.hu)
-- Command line was: F:\SteamLibrary\SteamApps\common\PAYDAY 2\lua\lib\units\player_team\teamaibrain.luac 

require("lib/units/player_team/logics/TeamAILogicBase")
require("lib/units/player_team/logics/TeamAILogicInactive")
require("lib/units/player_team/logics/TeamAILogicIdle")
require("lib/units/player_team/logics/TeamAILogicAssault")
require("lib/units/player_team/logics/TeamAILogicTravel")
require("lib/units/player_team/logics/TeamAILogicDisabled")
require("lib/units/player_team/logics/TeamAILogicSurrender")
if not TeamAIBrain then
  TeamAIBrain = class(CopBrain)
end
TeamAIBrain._create_attention_setting_from_descriptor = PlayerMovement._create_attention_setting_from_descriptor
TeamAIBrain._logics = {inactive = TeamAILogicInactive, idle = TeamAILogicIdle, surrender = TeamAILogicSurrender, travel = TeamAILogicTravel, assault = TeamAILogicAssault, disabled = TeamAILogicDisabled}
local reload = nil
if TeamAIBrain._reload_clbks then
  reload = true
else
  TeamAIBrain._reload_clbks = {}
end
TeamAIBrain.init = function(l_1_0, l_1_1)
  l_1_0._unit = l_1_1
  l_1_0._timer = TimerManager:game()
  l_1_0:set_update_enabled_state(false)
  l_1_0._current_logic = nil
  l_1_0._current_logic_name = nil
  l_1_0._active = true
  l_1_0._SO_access = managers.navigation:convert_access_flag(tweak_data.character[l_1_1:base()._tweak_table].access)
  l_1_0._reload_clbks[l_1_1:key()] = callback(l_1_0, l_1_0, "on_reload")
end

TeamAIBrain.post_init = function(l_2_0)
  l_2_0:_reset_logic_data()
  local my_key = tostring(l_2_0._unit:key())
  l_2_0._unit:character_damage():add_listener("TeamAIBrain_hurt" .. my_key, {"bleedout", "hurt", "light_hurt", "heavy_hurt", "fatal", "none"}, callback(l_2_0, l_2_0, "clbk_damage"))
  l_2_0._unit:character_damage():add_listener("TeamAIBrain_death" .. my_key, {"death"}, callback(l_2_0, l_2_0, "clbk_death"))
  managers.groupai:state():add_listener("TeamAIBrain" .. my_key, {"enemy_weapons_hot"}, callback(l_2_0, l_2_0, "clbk_heat"))
  if not l_2_0._current_logic then
    l_2_0:set_init_logic("idle")
  end
  l_2_0:_setup_attention_handler()
  l_2_0._alert_listen_key = "TeamAIBrain" .. tostring(l_2_0._unit:key())
  local alert_listen_filter = managers.groupai:state():get_unit_type_filter("all_enemy")
  managers.groupai:state():add_alert_listener(l_2_0._alert_listen_key, callback(l_2_0, l_2_0, "on_alert"), alert_listen_filter, {bullet = true, vo_intimidate = true}, l_2_0._unit:movement():m_head_pos())
end

TeamAIBrain._reset_logic_data = function(l_3_0)
  TeamAIBrain.super._reset_logic_data(l_3_0)
  l_3_0._logic_data.enemy_slotmask = managers.slot:get_mask("enemies")
end

TeamAIBrain.set_spawn_ai = function(l_4_0, l_4_1)
  TeamAIBrain.super.set_spawn_ai(l_4_0, l_4_1)
  if managers.groupai:state():enemy_weapons_hot() then
    l_4_0:clbk_heat()
  end
end

TeamAIBrain.clbk_damage = function(l_5_0, l_5_1, l_5_2)
  l_5_0._current_logic.damage_clbk(l_5_0._logic_data, l_5_2)
end

TeamAIBrain.clbk_death = function(l_6_0, l_6_1, l_6_2)
  TeamAIBrain.super.clbk_death(l_6_0, l_6_1, l_6_2)
  l_6_0:set_objective()
end

TeamAIBrain.on_cop_neutralized = function(l_7_0, l_7_1)
  return l_7_0._current_logic.on_cop_neutralized(l_7_0._logic_data, l_7_1)
end

TeamAIBrain.on_long_dis_interacted = function(l_8_0, l_8_1, l_8_2)
  l_8_0._unit:movement():set_cool(false)
  return l_8_0._current_logic.on_long_dis_interacted(l_8_0._logic_data, l_8_2)
end

TeamAIBrain.on_recovered = function(l_9_0, l_9_1)
  l_9_0._current_logic.on_recovered(l_9_0._logic_data, l_9_1)
end

TeamAIBrain.clbk_heat = function(l_10_0)
  l_10_0._current_logic.clbk_heat(l_10_0._logic_data)
end

TeamAIBrain.pre_destroy = function(l_11_0, l_11_1)
  TeamAIBrain.super.pre_destroy(l_11_0, l_11_1)
  managers.groupai:state():remove_listener("TeamAIBrain" .. tostring(l_11_0._unit:key()))
end

TeamAIBrain.set_active = function(l_12_0, l_12_1)
  TeamAIBrain.super.set_active(l_12_0, l_12_1)
  if not l_12_1 then
    l_12_0:set_objective()
  end
  l_12_0._unit:character_damage():disable()
end

TeamAIBrain._setup_attention_handler = function(l_13_0)
  TeamAIBrain.super._setup_attention_handler(l_13_0)
  l_13_0:on_cool_state_changed(l_13_0._unit:movement():cool())
end

TeamAIBrain.on_cool_state_changed = function(l_14_0, l_14_1)
  if l_14_0._logic_data then
    l_14_0._logic_data.cool = l_14_1
  end
  if not l_14_0._attention_handler then
    return 
  end
  local att_settings = nil
  if l_14_1 then
    att_settings = {"team_team_idle"}
  else
    att_settings = {"team_enemy_cbt"}
  end
  PlayerMovement.set_attention_settings(l_14_0, att_settings, "team_AI")
end

TeamAIBrain.clbk_attention_notice_sneak = function(l_15_0, l_15_1, l_15_2)
end


