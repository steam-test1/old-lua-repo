-- Decompiled using luadec 2.0.1 by sztupy (http://winmo.sztupy.hu)
-- Command line was: F:\SteamLibrary\SteamApps\common\PAYDAY 2\lua\lib\units\civilians\civilianbrain.luac 

require("lib/units/enemies/cop/logics/CopLogicBase")
require("lib/units/civilians/logics/CivilianLogicInactive")
require("lib/units/civilians/logics/CivilianLogicIdle")
require("lib/units/civilians/logics/CivilianLogicFlee")
require("lib/units/civilians/logics/CivilianLogicSurrender")
require("lib/units/civilians/logics/CivilianLogicEscort")
require("lib/units/civilians/logics/CivilianLogicTravel")
require("lib/units/civilians/logics/CivilianLogicTrade")
if not CivilianBrain then
  CivilianBrain = class(CopBrain)
end
local l_0_0 = CivilianBrain
local l_0_1 = {}
l_0_1.inactive = CivilianLogicInactive
l_0_1.idle = CivilianLogicIdle
l_0_1.surrender = CivilianLogicSurrender
l_0_1.flee = CivilianLogicFlee
l_0_1.escort = CivilianLogicEscort
l_0_1.travel = CivilianLogicTravel
l_0_1.trade = CivilianLogicTrade
l_0_0._logics = l_0_1
l_0_0 = CivilianBrain
l_0_1 = function(l_1_0, l_1_1)
  l_1_0._unit = l_1_1
  l_1_0._timer = TimerManager:game()
  l_1_0:set_update_enabled_state(false)
  l_1_0._current_logic = nil
  l_1_0._current_logic_name = nil
  l_1_0._active = true
  l_1_0._SO_access = managers.navigation:convert_access_flag(tweak_data.character[l_1_1:base()._tweak_table].access)
  l_1_0._slotmask_enemies = managers.slot:get_mask("criminals")
  CopBrain._reload_clbks[l_1_1:key()] = callback(l_1_0, l_1_0, "on_reload")
end

l_0_0.init = l_0_1
l_0_0 = CivilianBrain
l_0_1 = function(l_2_0, l_2_1, l_2_2, l_2_3)
  local logic = l_2_0._current_logic
  if logic.update then
    local l_data = l_2_0._logic_data
    l_data.t = l_2_2
    l_data.dt = l_2_3
    logic.update(l_data)
  end
end

l_0_0.update = l_0_1
l_0_0 = CivilianBrain
l_0_1 = function(l_3_0)
  CopBrain._reset_logic_data(l_3_0)
  l_3_0._logic_data.enemy_slotmask = nil
end

l_0_0._reset_logic_data = l_0_1
l_0_0 = CivilianBrain
l_0_1 = function(l_4_0, l_4_1)
  return l_4_0._current_logic.is_available_for_assignment(l_4_0._logic_data, l_4_1)
end

l_0_0.is_available_for_assignment = l_0_1
l_0_0 = CivilianBrain
l_0_1 = function(l_5_0)
  l_5_0:set_logic("surrender")
end

l_0_0.cancel_trade = l_0_1
l_0_0 = CivilianBrain
l_0_1 = function(l_6_0, l_6_1)
  if l_6_0._current_logic.on_rescue_allowed_state then
    l_6_0._current_logic.on_rescue_allowed_state(l_6_0._logic_data, l_6_1)
  end
end

l_0_0.on_rescue_allowed_state = l_0_1
l_0_0 = CivilianBrain
l_0_1 = function(l_7_0)
  if l_7_0._current_logic.wants_rescue then
    return l_7_0._current_logic.wants_rescue(l_7_0._logic_data)
  end
end

l_0_0.wants_rescue = l_0_1
l_0_0 = CivilianBrain
l_0_1 = function(l_8_0, l_8_1)
  if l_8_0._logic_data then
    l_8_0._logic_data.cool = l_8_1
  end
  if l_8_0._alert_listen_key then
    managers.groupai:state():remove_alert_listener(l_8_0._alert_listen_key)
  else
    l_8_0._alert_listen_key = "CopBrain" .. tostring(l_8_0._unit:key())
  end
  local alert_listen_filter, alert_types = nil, nil
  if l_8_1 then
    alert_listen_filter = managers.groupai:state():get_unit_type_filter("criminals_enemies_civilians")
    alert_types = {footstep = true, bullet = true, vo_cbt = true, vo_intimidate = true, vo_distress = true, aggression = true}
  else
    alert_listen_filter = managers.groupai:state():get_unit_type_filter("criminal")
    alert_types = {bullet = true}
  end
  managers.groupai:state():add_alert_listener(l_8_0._alert_listen_key, callback(l_8_0, l_8_0, "on_alert"), alert_listen_filter, alert_types, l_8_0._unit:movement():m_head_pos())
end

l_0_0.on_cool_state_changed = l_0_1
l_0_0 = CivilianBrain
l_0_1 = function(l_9_0, l_9_1)
  PlayerMovement.set_attention_settings(l_9_0, l_9_1)
end

l_0_0.set_attention_settings = l_0_1

