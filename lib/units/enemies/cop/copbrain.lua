-- Decompiled using luadec 2.0.1 by sztupy (http://winmo.sztupy.hu)
-- Command line was: F:\SteamLibrary\SteamApps\common\PAYDAY 2\lua\lib\units\enemies\cop\copbrain.luac 

require("lib/units/enemies/cop/logics/CopLogicBase")
require("lib/units/enemies/cop/logics/CopLogicInactive")
require("lib/units/enemies/cop/logics/CopLogicIdle")
require("lib/units/enemies/cop/logics/CopLogicAttack")
require("lib/units/enemies/cop/logics/CopLogicIntimidated")
require("lib/units/enemies/cop/logics/CopLogicTravel")
require("lib/units/enemies/cop/logics/CopLogicArrest")
require("lib/units/enemies/cop/logics/CopLogicGuard")
require("lib/units/enemies/cop/logics/CopLogicFlee")
require("lib/units/enemies/cop/logics/CopLogicSniper")
require("lib/units/enemies/cop/logics/CopLogicTrade")
require("lib/units/enemies/tank/logics/TankCopLogicAttack")
require("lib/units/enemies/shield/logics/ShieldLogicAttack")
require("lib/units/enemies/spooc/logics/SpoocLogicAttack")
require("lib/units/enemies/taser/logics/TaserLogicAttack")
if not CopBrain then
  CopBrain = class()
end
{idle = CopLogicIdle, attack = CopLogicAttack, travel = CopLogicTravel, inactive = CopLogicInactive}.intimidated = CopLogicIntimidated
 -- DECOMPILER ERROR: Confused about usage of registers!

{idle = CopLogicIdle, attack = CopLogicAttack, travel = CopLogicTravel, inactive = CopLogicInactive}.arrest = CopLogicArrest
 -- DECOMPILER ERROR: Confused about usage of registers!

{idle = CopLogicIdle, attack = CopLogicAttack, travel = CopLogicTravel, inactive = CopLogicInactive}.guard = CopLogicGuard
 -- DECOMPILER ERROR: Confused about usage of registers!

{idle = CopLogicIdle, attack = CopLogicAttack, travel = CopLogicTravel, inactive = CopLogicInactive}.flee = CopLogicFlee
 -- DECOMPILER ERROR: Confused about usage of registers!

{idle = CopLogicIdle, attack = CopLogicAttack, travel = CopLogicTravel, inactive = CopLogicInactive}.sniper = CopLogicSniper
 -- DECOMPILER ERROR: Confused about usage of registers!

{idle = CopLogicIdle, attack = CopLogicAttack, travel = CopLogicTravel, inactive = CopLogicInactive}.trade = CopLogicTrade
 -- DECOMPILER ERROR: Confused about usage of registers!

local logic_variants = {security = {idle = CopLogicIdle, attack = CopLogicAttack, travel = CopLogicTravel, inactive = CopLogicInactive}}
local security_variant = logic_variants.security
logic_variants.patrol = security_variant
logic_variants.cop = security_variant
logic_variants.fbi = security_variant
logic_variants.swat = security_variant
logic_variants.heavy_swat = security_variant
logic_variants.fbi_swat = security_variant
logic_variants.fbi_heavy_swat = security_variant
logic_variants.nathan = security_variant
logic_variants.sniper = security_variant
logic_variants.gangster = security_variant
logic_variants.dealer = security_variant
logic_variants.biker_escape = security_variant
logic_variants.murky = security_variant
for _,tweak_table_name in pairs({"shield", "tank", "spooc", "taser"}) do
  logic_variants[tweak_table_name] = clone(security_variant)
end
logic_variants.shield.attack = ShieldLogicAttack
logic_variants.shield.intimidated = nil
logic_variants.shield.flee = nil
logic_variants.tank.attack = TankCopLogicAttack
logic_variants.spooc.attack = SpoocLogicAttack
logic_variants.taser.attack = TaserLogicAttack
security_variant = nil
CopBrain._logic_variants = logic_variants
logic_varaints = nil
local reload = nil
if CopBrain._reload_clbks then
  reload = true
else
  CopBrain._reload_clbks = {}
end
CopBrain.init = function(l_1_0, l_1_1)
  l_1_0._unit = l_1_1
  l_1_0._timer = TimerManager:game()
  l_1_0:set_update_enabled_state(false)
  l_1_0._current_logic = nil
  l_1_0._current_logic_name = nil
  l_1_0._active = true
  l_1_0._SO_access = managers.navigation:convert_access_flag(tweak_data.character[l_1_1:base()._tweak_table].access)
  l_1_0._slotmask_enemies = managers.slot:get_mask("criminals")
  l_1_0._reload_clbks[l_1_1:key()] = callback(l_1_0, l_1_0, "on_reload")
end

CopBrain.post_init = function(l_2_0)
  l_2_0._logics = CopBrain._logic_variants[l_2_0._unit:base()._tweak_table]
  l_2_0:_reset_logic_data()
  local my_key = tostring(l_2_0._unit:key())
  l_2_0._unit:character_damage():add_listener("CopBrain_hurt" .. my_key, {"hurt", "light_hurt", "heavy_hurt", "hurt_sick", "shield_knock", "counter_tased"}, callback(l_2_0, l_2_0, "clbk_damage"))
  l_2_0._unit:character_damage():add_listener("CopBrain_death" .. my_key, {"death"}, callback(l_2_0, l_2_0, "clbk_death"))
  l_2_0:_setup_attention_handler()
  if not l_2_0._current_logic then
    l_2_0:set_init_logic("idle")
  end
end

CopBrain.update = function(l_3_0, l_3_1, l_3_2, l_3_3)
  local logic = l_3_0._current_logic
  if logic.update then
    local l_data = l_3_0._logic_data
    l_data.t = l_3_2
    l_data.dt = l_3_3
    logic.update(l_data)
  end
end

CopBrain.set_update_enabled_state = function(l_4_0, l_4_1)
  l_4_0._unit:set_extension_update_enabled(Idstring("brain"), l_4_1)
end

CopBrain.set_spawn_ai = function(l_5_0, l_5_1)
  l_5_0._spawn_ai = l_5_1
  l_5_0:set_update_enabled_state(true)
  if l_5_1.init_state then
    l_5_0:set_logic(l_5_1.init_state, l_5_1.params)
  end
  if l_5_1.stance then
    l_5_0._unit:movement():set_stance(l_5_1.stance)
  end
  if l_5_1.objective then
    l_5_0:set_objective(l_5_1.objective)
  end
end

CopBrain.set_spawn_entry = function(l_6_0, l_6_1, l_6_2)
  l_6_0._logic_data.tactics = l_6_2
  l_6_0._logic_data.rank = l_6_1.rank
end

CopBrain.set_tactic = function(l_7_0, l_7_1)
  local old_tactic = l_7_0._logic_data.tactic
  l_7_0._logic_data.tactic = l_7_1
  if l_7_0._current_logic.on_new_tactic then
    l_7_0._current_logic.on_new_tactic(l_7_0._logic_data, old_tactic)
  end
end

CopBrain.set_objective = function(l_8_0, l_8_1)
  local old_objective = l_8_0._logic_data.objective
  l_8_0._logic_data.objective = l_8_1
  if l_8_1 and l_8_1.followup_objective and l_8_1.followup_objective.interaction_voice then
    l_8_0._unit:network():send("set_interaction_voice", l_8_1.followup_objective.interaction_voice)
  elseif old_objective and old_objective.followup_objective and old_objective.followup_objective.interaction_voice then
    l_8_0._unit:network():send("set_interaction_voice", "")
  end
  l_8_0._current_logic.on_new_objective(l_8_0._logic_data, old_objective)
end

CopBrain.set_followup_objective = function(l_9_0, l_9_1)
  local old_followup = l_9_0._logic_data.objective.followup_objective
  l_9_0._logic_data.objective.followup_objective = l_9_1
  if l_9_1 and l_9_1.interaction_voice then
    l_9_0._unit:network():send("set_interaction_voice", l_9_1.interaction_voice)
  elseif old_followup and old_followup.interaction_voice then
    l_9_0._unit:network():send("set_interaction_voice", "")
  end
end

CopBrain.save = function(l_10_0, l_10_1)
  local my_save_data = {}
  if l_10_0._logic_data.objective and l_10_0._logic_data.objective.followup_objective and l_10_0._logic_data.objective.followup_objective.interaction_voice then
    my_save_data.interaction_voice = l_10_0._logic_data.objective.followup_objective.interaction_voice
  else
    my_save_data.interaction_voice = nil
  end
  if l_10_0._logic_data.internal_data.weapon_laser_on then
    my_save_data.weapon_laser_on = true
  end
  l_10_1.brain = my_save_data
end

CopBrain.objective = function(l_11_0)
  return l_11_0._logic_data.objective
end

CopBrain.is_hostage = function(l_12_0)
  return l_12_0._logic_data.is_hostage
end

CopBrain.is_available_for_assignment = function(l_13_0, l_13_1)
  return l_13_0._current_logic.is_available_for_assignment(l_13_0._logic_data, l_13_1)
end

CopBrain._reset_logic_data = function(l_14_0)
  {unit = l_14_0._unit, active_searches = {}, m_pos = l_14_0._unit:movement():m_pos(), char_tweak = tweak_data.character[l_14_0._unit:base()._tweak_table], key = l_14_0._unit:key(), pos_rsrv_id = l_14_0._unit:movement():pos_rsrv_id(), SO_access = l_14_0._SO_access, SO_access_str = tweak_data.character[l_14_0._unit:base()._tweak_table].access, detected_attention_objects = {}, attention_handler = l_14_0._attention_handler}.visibility_slotmask = managers.slot:get_mask("AI_visibility")
   -- DECOMPILER ERROR: Confused about usage of registers!

  {unit = l_14_0._unit, active_searches = {}, m_pos = l_14_0._unit:movement():m_pos(), char_tweak = tweak_data.character[l_14_0._unit:base()._tweak_table], key = l_14_0._unit:key(), pos_rsrv_id = l_14_0._unit:movement():pos_rsrv_id(), SO_access = l_14_0._SO_access, SO_access_str = tweak_data.character[l_14_0._unit:base()._tweak_table].access, detected_attention_objects = {}, attention_handler = l_14_0._attention_handler}.enemy_slotmask = l_14_0._slotmask_enemies
   -- DECOMPILER ERROR: Confused about usage of registers!

  {unit = l_14_0._unit, active_searches = {}, m_pos = l_14_0._unit:movement():m_pos(), char_tweak = tweak_data.character[l_14_0._unit:base()._tweak_table], key = l_14_0._unit:key(), pos_rsrv_id = l_14_0._unit:movement():pos_rsrv_id(), SO_access = l_14_0._SO_access, SO_access_str = tweak_data.character[l_14_0._unit:base()._tweak_table].access, detected_attention_objects = {}, attention_handler = l_14_0._attention_handler}.cool = l_14_0._unit:movement():cool()
   -- DECOMPILER ERROR: Confused about usage of registers!

  l_14_0._logic_data = {unit = l_14_0._unit, active_searches = {}, m_pos = l_14_0._unit:movement():m_pos(), char_tweak = tweak_data.character[l_14_0._unit:base()._tweak_table], key = l_14_0._unit:key(), pos_rsrv_id = l_14_0._unit:movement():pos_rsrv_id(), SO_access = l_14_0._SO_access, SO_access_str = tweak_data.character[l_14_0._unit:base()._tweak_table].access, detected_attention_objects = {}, attention_handler = l_14_0._attention_handler}
  if Application:production_build() then
    l_14_0._logic_data.debug_name = l_14_0._unit:name()
  end
end

CopBrain.set_init_logic = function(l_15_0, l_15_1, l_15_2)
  local logic = l_15_0._logics[l_15_1]
  local l_data = l_15_0._logic_data
  l_data.t = l_15_0._timer:time()
  l_data.dt = l_15_0._timer:delta_time()
  l_data.name = l_15_1
  l_data.logic = logic
  l_15_0._current_logic = logic
  l_15_0._current_logic_name = l_15_1
  logic.enter(l_data, l_15_1, l_15_2)
end

CopBrain.set_logic = function(l_16_0, l_16_1, l_16_2)
  local logic = l_16_0._logics[l_16_1]
  local l_data = l_16_0._logic_data
  l_data.t = l_16_0._timer:time()
  l_data.dt = l_16_0._timer:delta_time()
  l_16_0._current_logic.exit(l_data, l_16_1, l_16_2)
  l_data.name = l_16_1
  l_data.logic = logic
  l_16_0._current_logic = logic
  l_16_0._current_logic_name = l_16_1
  logic.enter(l_data, l_16_1, l_16_2)
end

CopBrain.search_for_path_to_unit = function(l_17_0, l_17_1, l_17_2, l_17_3)
  local enemy_tracker = l_17_2:movement():nav_tracker()
  local pos_to = enemy_tracker:field_position()
  local params = {tracker_from = l_17_0._unit:movement():nav_tracker(), tracker_to = enemy_tracker, result_clbk = callback(l_17_0, l_17_0, "clbk_pathing_results", l_17_1), id = l_17_1, access_pos = l_17_0._SO_access, access_neg = l_17_3}
  l_17_0._logic_data.active_searches[l_17_1] = true
  managers.navigation:search_pos_to_pos(params)
  return true
end

CopBrain.search_for_path = function(l_18_0, l_18_1, l_18_2, l_18_3, l_18_4, l_18_5)
  local params = {tracker_from = l_18_0._unit:movement():nav_tracker(), pos_to = l_18_2, result_clbk = callback(l_18_0, l_18_0, "clbk_pathing_results", l_18_1), id = l_18_1, prio = l_18_3, access_pos = l_18_0._SO_access, access_neg = l_18_4, nav_segs = l_18_5}
  l_18_0._logic_data.active_searches[l_18_1] = true
  managers.navigation:search_pos_to_pos(params)
  return true
end

CopBrain.search_for_path_from_pos = function(l_19_0, l_19_1, l_19_2, l_19_3, l_19_4, l_19_5, l_19_6)
  local params = {pos_from = l_19_2, pos_to = l_19_3, result_clbk = callback(l_19_0, l_19_0, "clbk_pathing_results", l_19_1), id = l_19_1, prio = l_19_4, access_pos = l_19_0._SO_access, access_neg = l_19_5, nav_segs = l_19_6}
  l_19_0._logic_data.active_searches[l_19_1] = true
  managers.navigation:search_pos_to_pos(params)
  return true
end

CopBrain.search_for_path_to_cover = function(l_20_0, l_20_1, l_20_2, l_20_3, l_20_4)
  local params = {tracker_from = l_20_0._unit:movement():nav_tracker(), tracker_to = l_20_2[3], result_clbk = callback(l_20_0, l_20_0, "clbk_pathing_results", l_20_1), id = l_20_1, access_pos = l_20_0._SO_access, access_neg = l_20_4}
  l_20_0._logic_data.active_searches[l_20_1] = true
  managers.navigation:search_pos_to_pos(params)
  return true
end

CopBrain.search_for_coarse_path = function(l_21_0, l_21_1, l_21_2, l_21_3, l_21_4)
  local params = {from_tracker = l_21_0._unit:movement():nav_tracker(), to_seg = l_21_2, access = {"walk"}, id = l_21_1, results_clbk = callback(l_21_0, l_21_0, "clbk_coarse_pathing_results", l_21_1), verify_clbk = l_21_3, access_pos = l_21_0._logic_data.char_tweak.access, access_neg = l_21_4}
  l_21_0._logic_data.active_searches[l_21_1] = 2
  managers.navigation:search_coarse(params)
  return true
end

CopBrain.action_request = function(l_22_0, l_22_1)
  return l_22_0._unit:movement():action_request(l_22_1)
end

CopBrain.action_complete_clbk = function(l_23_0, l_23_1)
  l_23_0._current_logic.action_complete_clbk(l_23_0._logic_data, l_23_1)
end

CopBrain.clbk_coarse_pathing_results = function(l_24_0, l_24_1, l_24_2)
  l_24_0:_add_pathing_result(l_24_1, l_24_2)
end

CopBrain.clbk_pathing_results = function(l_25_0, l_25_1, l_25_2)
  l_25_0:_add_pathing_result(l_25_1, l_25_2)
  if l_25_2 then
    local t = nil
    for i,nav_point in ipairs(l_25_2) do
      if not nav_point.x and nav_point:script_data().element:nav_link_delay() > 0 then
        if not t then
          t = TimerManager:game():time()
        end
        nav_point:set_delay_time(t + nav_point:script_data().element:nav_link_delay())
      end
    end
  end
end

CopBrain._add_pathing_result = function(l_26_0, l_26_1, l_26_2)
  l_26_0._logic_data.active_searches[l_26_1] = nil
  if not l_26_0._logic_data.pathing_results then
    l_26_0._logic_data.pathing_results = {}
  end
  l_26_0._logic_data.pathing_results[l_26_1] = l_26_2 or "failed"
end

CopBrain.cancel_all_pathing_searches = function(l_27_0)
  for search_id,search_type in pairs(l_27_0._logic_data.active_searches) do
    if search_type == 2 then
      managers.navigation:cancel_coarse_search(search_id)
      for (for control),search_id in (for generator) do
      end
      managers.navigation:cancel_pathing_search(search_id)
    end
    l_27_0._logic_data.active_searches = {}
    l_27_0._logic_data.pathing_results = nil
     -- Warning: missing end command somewhere! Added here
  end
end

CopBrain.clbk_damage = function(l_28_0, l_28_1, l_28_2)
  if l_28_2.attacker_unit and l_28_2.attacker_unit:in_slot(l_28_0._slotmask_enemies) then
    l_28_0._current_logic.damage_clbk(l_28_0._logic_data, l_28_2)
  end
end

CopBrain.clbk_death = function(l_29_0, l_29_1, l_29_2)
  l_29_0._current_logic.death_clbk(l_29_0._logic_data, l_29_2)
  l_29_0:set_active(false)
  if l_29_0._alert_listen_key then
    managers.groupai:state():remove_alert_listener(l_29_0._alert_listen_key)
    l_29_0._alert_listen_key = nil
  end
end

CopBrain.is_active = function(l_30_0)
  return l_30_0._active
end

CopBrain.set_active = function(l_31_0, l_31_1)
  l_31_0._active = l_31_1
  if l_31_1 then
    l_31_0:set_logic("idle")
  elseif l_31_0._current_logic_name ~= "inactive" then
    l_31_0:set_logic("inactive")
  end
end

CopBrain.cancel_trade = function(l_32_0)
  l_32_0:set_logic("intimidated")
end

CopBrain.interaction_voice = function(l_33_0)
  if l_33_0._logic_data.objective and l_33_0._logic_data.objective.followup_objective and l_33_0._logic_data.objective.followup_objective.trigger_on == "interact" and (not l_33_0._logic_data.objective or not l_33_0._logic_data.objective.nav_seg or not not l_33_0._logic_data.objective.in_place) and not l_33_0._unit:anim_data().unintimidateable then
    return l_33_0._logic_data.objective.followup_objective.interaction_voice
  end
end

CopBrain.on_intimidated = function(l_34_0, l_34_1, l_34_2)
  if l_34_0._logic_data.objective and l_34_0._logic_data.objective.followup_objective and l_34_0._logic_data.objective.followup_objective.trigger_on == "interact" and (not l_34_0._logic_data.objective or not l_34_0._logic_data.objective.nav_seg or not not l_34_0._logic_data.objective.in_place) and not l_34_0._unit:anim_data().unintimidateable then
    l_34_0:set_objective(l_34_0._logic_data.objective.followup_objective)
    return l_34_0._logic_data.objective.interaction_voice
  else
    l_34_0._current_logic.on_intimidated(l_34_0._logic_data, l_34_1, l_34_2)
  end
end

CopBrain.on_tied = function(l_35_0, l_35_1, l_35_2)
  return l_35_0._current_logic.on_tied(l_35_0._logic_data, l_35_1, l_35_2)
end

CopBrain.on_trade = function(l_36_0, l_36_1)
  return l_36_0._current_logic.on_trade(l_36_0._logic_data, l_36_1)
end

CopBrain.on_detected_enemy_destroyed = function(l_37_0, l_37_1)
  l_37_0._current_logic.on_detected_enemy_destroyed(l_37_0._logic_data, l_37_1)
end

CopBrain.on_detected_attention_obj_modified = function(l_38_0, l_38_1)
  l_38_0._current_logic.on_detected_attention_obj_modified(l_38_0._logic_data, l_38_1)
end

CopBrain.on_criminal_neutralized = function(l_39_0, l_39_1)
  l_39_0._current_logic.on_criminal_neutralized(l_39_0._logic_data, l_39_1)
end

CopBrain.on_alert = function(l_40_0, l_40_1)
  if l_40_1[5] == l_40_0._unit then
    return 
  end
  l_40_0._current_logic.on_alert(l_40_0._logic_data, l_40_1)
end

CopBrain.filter_area_unsafe = function(l_41_0, l_41_1)
  return not managers.groupai:state():is_nav_seg_safe(l_41_1)
end

CopBrain.on_area_safety = function(l_42_0, ...)
  l_42_0._current_logic.on_area_safety(l_42_0._logic_data, ...)
   -- DECOMPILER ERROR: Confused about usage of registers for local variables.

end

CopBrain.draw_reserved_positions = function(l_43_0)
  l_43_0._current_logic.draw_reserved_positions(l_43_0._logic_data)
end

CopBrain.draw_reserved_covers = function(l_44_0)
  l_44_0._current_logic.draw_reserved_covers(l_44_0._logic_data)
end

CopBrain.set_important = function(l_45_0, l_45_1)
  l_45_0._important = l_45_1
  l_45_0._logic_data.important = l_45_1
  l_45_0._current_logic.on_importance(l_45_0._logic_data)
end

CopBrain.is_important = function(l_46_0)
  return l_46_0._important
end

CopBrain.on_alarm_pager_interaction = function(l_47_0, l_47_1, l_47_2)
  if l_47_0._current_logic.on_alarm_pager_interaction then
    l_47_0._current_logic.on_alarm_pager_interaction(l_47_0._logic_data, l_47_1, l_47_2)
  end
end

CopBrain.on_reload = function(l_48_0)
  l_48_0._logic_data.char_tweak = tweak_data.character[l_48_0._unit:base()._tweak_table]
  l_48_0._logics = CopBrain._logic_variants[l_48_0._unit:base()._tweak_table]
  l_48_0._current_logic = l_48_0._logics[l_48_0._current_logic_name]
  l_48_0._logic_data.char_tweak = tweak_data.character[l_48_0._unit:base()._tweak_table]
end

CopBrain.on_rescue_allowed_state = function(l_49_0, l_49_1)
  if l_49_0._current_logic.on_rescue_allowed_state then
    l_49_0._current_logic.on_rescue_allowed_state(l_49_0._logic_data, l_49_1)
  end
end

CopBrain.on_objective_unit_destroyed = function(l_50_0, l_50_1)
  return l_50_0._current_logic.on_objective_unit_destroyed(l_50_0._logic_data, l_50_1)
end

CopBrain.on_objective_unit_damaged = function(l_51_0, l_51_1, l_51_2)
  if l_51_1:character_damage().dead and l_51_1:character_damage():dead() then
    return l_51_0._current_logic.on_objective_unit_damaged(l_51_0._logic_data, l_51_1, l_51_2.attacker_unit)
  end
end

CopBrain.is_advancing = function(l_52_0)
  return l_52_0._current_logic.is_advancing(l_52_0._logic_data)
end

CopBrain.anim_clbk = function(l_53_0, l_53_1, ...)
  l_53_0._current_logic.anim_clbk(l_53_0._logic_data, ...)
   -- DECOMPILER ERROR: Confused about usage of registers for local variables.

end

CopBrain.on_nav_link_unregistered = function(l_54_0, l_54_1)
  if l_54_0._logic_data.pathing_results then
    local failed_search_ids = nil
    for path_name,path in pairs(l_54_0._logic_data.pathing_results) do
      if type(path) == "table" and path[1] and type(path[1]) ~= "table" then
        for i,nav_point in ipairs(path) do
          if not nav_point.x and nav_point:script_data().element._id == l_54_1 then
            if not failed_search_ids then
              failed_search_ids = {}
            end
            failed_search_ids[path_name] = true
            for (for control),path_name in (for generator) do
            end
          end
        end
      end
      if failed_search_ids then
        for search_id,_ in pairs(failed_search_ids) do
          l_54_0._logic_data.pathing_results[search_id] = "failed"
        end
      end
    end
    if l_54_0._current_logic._get_all_paths then
      local paths = l_54_0._current_logic._get_all_paths(l_54_0._logic_data)
    end
    if not paths then
      return 
    end
    do
      local verified_paths = {}
      for path_name,path in pairs(paths) do
        local path_is_ok = true
        for i,nav_point in ipairs(path) do
          if not nav_point.x and nav_point:script_data().element._id == l_54_1 then
            path_is_ok = false
        else
          end
        end
        if path_is_ok then
          verified_paths[path_name] = path
        end
      end
      l_54_0._current_logic._set_verified_paths(l_54_0._logic_data, verified_paths)
    end
     -- Warning: missing end command somewhere! Added here
  end
end

CopBrain.SO_access = function(l_55_0)
  return l_55_0._SO_access
end

CopBrain._setup_attention_handler = function(l_56_0)
  l_56_0._attention_handler = CharacterAttentionObject:new(l_56_0._unit)
end

CopBrain.attention_handler = function(l_57_0)
  return l_57_0._attention_handler
end

CopBrain.set_attention_settings = function(l_58_0, l_58_1)
   -- DECOMPILER ERROR: Confused at declaration of local variable

  if l_58_1 then
    if l_58_1.peaceful then
      do return end
    end
     -- DECOMPILER ERROR: Overwrote pending register.

    if l_58_1.cbt then
      if managers.groupai:state():enemy_weapons_hot() then
        do return end
      end
       -- DECOMPILER ERROR: Overwrote pending register.

      if not l_58_0._enemy_weapons_hot_listen_id then
        managers.groupai:state():add_listener(l_58_0._enemy_weapons_hot_listen_id, {"enemy_weapons_hot"}, callback(l_58_0, l_58_0, "clbk_enemy_weapons_hot"))
       -- DECOMPILER ERROR: Overwrote pending register.

      elseif l_58_1.corpse_cbt then
        do return end
      end
       -- DECOMPILER ERROR: Overwrote pending register.

    if l_58_1.corpse_sneak then
      end
    end
  end
  PlayerMovement.set_attention_settings(l_58_0, {"enemy_team_idle"})
  l_58_0._attention_params, l_58_0._enemy_weapons_hot_listen_id = l_58_1, "CopBrain" .. tostring(l_58_0._unit:key())
   -- DECOMPILER ERROR: Confused about usage of registers for local variables.

end

CopBrain._create_attention_setting_from_descriptor = function(l_59_0, l_59_1, l_59_2)
  return PlayerMovement._create_attention_setting_from_descriptor(l_59_0, l_59_1, l_59_2)
end

CopBrain.clbk_attention_notice_corpse = function(l_60_0, l_60_1, l_60_2)
end

CopBrain.on_cool_state_changed = function(l_61_0, l_61_1)
  if l_61_0._logic_data then
    l_61_0._logic_data.cool = l_61_1
  end
  if l_61_0._alert_listen_key then
    managers.groupai:state():remove_alert_listener(l_61_0._alert_listen_key)
  else
    l_61_0._alert_listen_key = "CopBrain" .. tostring(l_61_0._unit:key())
  end
  local alert_listen_filter, alert_types = nil, nil
  if l_61_1 then
    alert_listen_filter = managers.groupai:state():get_unit_type_filter("criminals_enemies_civilians")
    alert_types = {footstep = true, bullet = true, vo_cbt = true, vo_intimidate = true, vo_distress = true, aggression = true}
  else
    alert_listen_filter = managers.groupai:state():get_unit_type_filter("criminal")
    alert_types = {bullet = true, aggression = true}
  end
  managers.groupai:state():add_alert_listener(l_61_0._alert_listen_key, callback(l_61_0, l_61_0, "on_alert"), alert_listen_filter, alert_types, l_61_0._unit:movement():m_head_pos())
end

CopBrain.on_suppressed = function(l_62_0, l_62_1)
  l_62_0._logic_data.is_suppressed = l_62_1 or nil
  if l_62_0._current_logic.on_suppressed_state then
    l_62_0._current_logic.on_suppressed_state(l_62_0._logic_data)
  end
end

CopBrain.attention_objects = function(l_63_0)
  if l_63_0._logic_data.attention_obj then
    print("attention_obj")
    print(inspect(l_63_0._logic_data.attention_obj))
  end
  for u_key,attention_data in pairs(l_63_0._logic_data.detected_attention_objects) do
    if l_63_0._logic_data.attention_obj ~= attention_data then
      print(inspect(attention_data))
    end
  end
end

CopBrain.clbk_enemy_weapons_hot = function(l_64_0)
  managers.groupai:state():remove_listener(l_64_0._enemy_weapons_hot_listen_id)
  l_64_0._enemy_weapons_hot_listen_id = nil
  l_64_0:set_attention_settings(l_64_0._attention_params)
  l_64_0._attention_params = nil
end

CopBrain.set_group = function(l_65_0, l_65_1)
  l_65_0._logic_data.group = l_65_1
end

CopBrain.on_new_group_objective = function(l_66_0, l_66_1)
  if l_66_0._current_logic.on_new_group_objective then
    l_66_0._current_logic.on_new_group_objective(l_66_0._logic_data, l_66_1)
  end
end

CopBrain.clbk_group_member_attention_identified = function(l_67_0, l_67_1, l_67_2)
  l_67_0._current_logic.identify_attention_obj_instant(l_67_0._logic_data, l_67_2)
end

CopBrain.convert_to_criminal = function(l_68_0, l_68_1)
  l_68_0._logic_data.is_converted = true
  l_68_0._logic_data.group = nil
  local mover_col_body = l_68_0._unit:body("mover_blocker")
  mover_col_body:set_enabled(false)
  local attention_preset = PlayerMovement._create_attention_setting_from_descriptor(l_68_0, tweak_data.attention.settings.team_enemy_cbt, "team_enemy_cbt")
  l_68_0._attention_handler:override_attention("enemy_team_cbt", attention_preset)
  local health_multiplier = 1
  local damage_multiplier = 1
  if not l_68_1:base():upgrade_value("player", "convert_enemies_health_multiplier") then
    health_multiplier = health_multiplier * (not alive(l_68_1) or 1)
  end
  health_multiplier = health_multiplier * (l_68_1:base():upgrade_value("player", "passive_convert_enemies_health_multiplier") or 1)
  damage_multiplier = damage_multiplier * (l_68_1:base():upgrade_value("player", "convert_enemies_damage_multiplier") or 1)
  damage_multiplier = damage_multiplier * (l_68_1:base():upgrade_value("player", "passive_convert_enemies_damage_multiplier") or 1)
  do return end
  health_multiplier = health_multiplier * managers.player:upgrade_value("player", "convert_enemies_health_multiplier", 1)
  health_multiplier = health_multiplier * managers.player:upgrade_value("player", "passive_convert_enemies_health_multiplier", 1)
  damage_multiplier = damage_multiplier * managers.player:upgrade_value("player", "convert_enemies_damage_multiplier", 1)
  damage_multiplier = damage_multiplier * managers.player:upgrade_value("player", "passive_convert_enemies_damage_multiplier", 1)
  l_68_0._unit:character_damage():convert_to_criminal(health_multiplier)
  l_68_0._logic_data.attention_obj = nil
  CopLogicBase._destroy_all_detected_attention_object_data(l_68_0._logic_data)
  l_68_0._SO_access = managers.navigation:convert_access_flag(tweak_data.character.russian.access)
  l_68_0._logic_data.SO_access = l_68_0._SO_access
  l_68_0._logic_data.SO_access_str = tweak_data.character.russian.access
  l_68_0._slotmask_enemies = managers.slot:get_mask("enemies")
  l_68_0._logic_data.enemy_slotmask = l_68_0._slotmask_enemies
  local equipped_w_selection = l_68_0._unit:inventory():equipped_selection()
  if equipped_w_selection then
    l_68_0._unit:inventory():remove_selection(equipped_w_selection, true)
  end
  local weap_name = l_68_0._unit:base():default_weapon_name()
  TeamAIInventory.add_unit_by_name(l_68_0._unit:inventory(), weap_name, true)
  local weapon_unit = l_68_0._unit:inventory():equipped_unit()
  weapon_unit:base():add_damage_multiplier(damage_multiplier)
  l_68_0:set_objective(nil)
  l_68_0:set_logic("idle", nil)
  managers.groupai:state():on_criminal_jobless(l_68_0._unit)
  l_68_0._unit:base():set_slot(l_68_0._unit, 16)
  l_68_0._unit:movement():set_stance("hos")
  local action_data = {type = "act", body_part = 1, variant = "attached_collar_enter", clamp_to_graph = true, blocks = {light_hurt = -1, hurt = -1, heavy_hurt = -1, action = -1, walk = -1}}
  l_68_0._unit:brain():action_request(action_data)
  l_68_0._unit:sound():say("cn1", true, nil)
end

CopBrain.on_surrender_chance = function(l_69_0)
  local t = TimerManager:game():time()
  if l_69_0._logic_data.surrender_window then
    l_69_0._logic_data.surrender_window.expire_t = t + l_69_0._logic_data.surrender_window.timeout_duration
    managers.enemy:reschedule_delayed_clbk(l_69_0._logic_data.surrender_window.expire_clbk_id, l_69_0._logic_data.surrender_window.expire_t)
    l_69_0._logic_data.surrender_window.chance_mul = math.pow(l_69_0._logic_data.surrender_window.chance_mul, 0.93000000715256)
    return 
  end
  local window_duration = 5 + 4 * math.random()
  local timeout_duration = 5 + 5 * math.random()
  l_69_0._logic_data.surrender_window = {expire_clbk_id = "CopBrain_sur_op" .. tostring(l_69_0._unit:key()), window_expire_t = t + window_duration, expire_t = t + window_duration + timeout_duration, window_duration = window_duration, timeout_duration = timeout_duration, chance_mul = 0.050000000745058}
  managers.enemy:add_delayed_clbk(l_69_0._logic_data.surrender_window.expire_clbk_id, callback(l_69_0, l_69_0, "clbk_surrender_chance_expired"), l_69_0._logic_data.surrender_window.expire_t)
end

CopBrain.clbk_surrender_chance_expired = function(l_70_0)
  l_70_0._logic_data.surrender_window = nil
end

CopBrain.pre_destroy = function(l_71_0, l_71_1)
  l_71_0:set_active(false)
  l_71_0._reload_clbks[l_71_1:key()] = nil
  l_71_0._attention_handler:set_attention(nil)
  if l_71_0._current_logic.pre_destroy then
    l_71_0._current_logic.pre_destroy(l_71_0._logic_data)
  end
  if l_71_0._alert_listen_key then
    managers.groupai:state():remove_alert_listener(l_71_0._alert_listen_key)
    l_71_0._alert_listen_key = nil
  end
  if l_71_0._enemy_weapons_hot_listen_id then
    managers.groupai:state():remove_listener(l_71_0._enemy_weapons_hot_listen_id)
    l_71_0._enemy_weapons_hot_listen_id = nil
  end
  if l_71_0._logic_data.surrender_window then
    managers.enemy:remove_delayed_clbk(l_71_0._logic_data.surrender_window.expire_clbk_id)
    l_71_0._logic_data.surrender_window = nil
  end
end

if reload then
  for k,clbk in pairs(CopBrain._reload_clbks) do
    clbk()
  end
end

