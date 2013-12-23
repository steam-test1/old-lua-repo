-- Decompiled using luadec 2.0.1 by sztupy (http://winmo.sztupy.hu)
-- Command line was: F:\SteamLibrary\SteamApps\common\PAYDAY 2\lua\lib\units\enemies\cop\logics\coplogictrade.luac 

CopLogicTrade = class(CopLogicBase)
CopLogicTrade.butchers_traded = 0
CopLogicTrade.enter = function(l_1_0, l_1_1, l_1_2)
  CopLogicBase.enter(l_1_0, l_1_1, l_1_2)
  l_1_0.unit:brain():cancel_all_pathing_searches()
  local old_internal_data = l_1_0.internal_data
  local my_data = {unit = l_1_0.unit}
  my_data.rsrv_pos = {}
  if old_internal_data and not old_internal_data.rsrv_pos then
    my_data.rsrv_pos = my_data.rsrv_pos
  end
  l_1_0.internal_data = my_data
  l_1_0.unit:movement():set_allow_fire(false)
  CopLogicBase._reset_attention(l_1_0)
  my_data._trade_enabled = true
  l_1_0.unit:network():send("hostage_trade", true, false)
  CopLogicTrade.hostage_trade(l_1_0.unit, true, false)
  l_1_0.unit:brain():set_update_enabled_state(true)
  managers.groupai:state():on_hostage_state(true, l_1_0.key)
  managers.secret_assignment:unregister_unit(l_1_0.unit, true)
  l_1_0.unit:brain():set_attention_settings({peaceful = true})
end

local is_win32 = SystemInfo:platform() == Idstring("WIN32")
CopLogicTrade.hostage_trade = function(l_2_0, l_2_1, l_2_2)
  local wp_id = "wp_hostage_trade"
  print("[CopLogicTrade.hostage_trade]", l_2_0, l_2_1, l_2_2)
  if l_2_1 then
    local text = managers.localization:text("debug_trade_hostage")
    managers.hud:add_waypoint(wp_id, {text = text, icon = "wp_trade", position = l_2_0:movement():m_pos(), distance = is_win32})
    if managers.network:session() and not managers.trade:is_peer_in_custody(managers.network:session():local_peer():id()) then
      managers.hint:show_hint("trade_offered")
    end
    l_2_0:base():set_allow_invisible(false)
    l_2_0:character_damage():set_invulnerable(true)
    l_2_0:base():swap_material_config()
    l_2_0:interaction():set_tweak_data("hostage_trade")
    l_2_0:interaction():set_active(true, false)
  else
    managers.hud:remove_waypoint(wp_id)
    if l_2_2 then
      l_2_0:interaction():set_active(false, false)
      l_2_0:interaction():set_contour("standard_color", 1)
      l_2_0:interaction():set_contour_override(true)
      managers.occlusion:remove_occlusion(l_2_0)
    else
      l_2_0:base():swap_material_config()
      l_2_0:interaction():set_tweak_data("intimidate")
      l_2_0:interaction():set_active(false, false)
      l_2_0:base():set_allow_invisible(true)
    end
  end
end

CopLogicTrade.exit = function(l_3_0, l_3_1, l_3_2)
  CopLogicBase.exit(l_3_0, l_3_1, l_3_2)
  local my_data = l_3_0.internal_data
  if my_data._trade_enabled then
    my_data._trade_enabled = false
    l_3_0.unit:network():send("hostage_trade", false, false)
    CopLogicTrade.hostage_trade(l_3_0.unit, false, false)
    managers.groupai:state():on_hostage_state(false, l_3_0.key)
  end
  l_3_0.unit:character_damage():set_invulnerable(false)
  l_3_0.unit:network():send("set_unit_invulnerable", false)
end

CopLogicTrade.on_trade = function(l_4_0, l_4_1)
  if not l_4_0.internal_data._trade_enabled then
    return 
  end
  managers.trade:on_hostage_traded(l_4_1)
  if l_4_0.unit:base().butcher then
    CopLogicTrade.butchers_traded = CopLogicTrade.butchers_traded + 1
    if CopLogicTrade.butchers_traded >= 3 then
      managers.challenges:set_flag("blood_in_blood_out")
      managers.network:session():send_to_peers_synched("award_achievment", "blood_in_blood_out")
    end
  end
  l_4_0.internal_data._trade_enabled = false
  l_4_0.unit:network():send("hostage_trade", false, true)
  CopLogicTrade.hostage_trade(l_4_0.unit, false, true)
  managers.groupai:state():on_hostage_state(false, l_4_0.key)
  local flee_pos = managers.groupai:state():flee_point(l_4_0.unit:movement():nav_tracker():nav_segment())
  if flee_pos then
    l_4_0.internal_data.flee_pos = flee_pos
    if l_4_0.unit:anim_data().hands_tied or l_4_0.unit:anim_data().tied then
      local new_action = {type = "act", variant = "stand", body_part = 1}
      l_4_0.unit:brain():action_request(new_action)
    else
      l_4_0.unit:set_slot(0)
    end
  end
end

CopLogicTrade.update = function(l_5_0)
  local my_data = l_5_0.internal_data
  CopLogicTrade._process_pathing_results(l_5_0, my_data)
  if my_data.pathing_to_flee_pos then
    do return end
  end
  if my_data.flee_path and not l_5_0.unit:movement():chk_action_forbidden("walk") and l_5_0.unit:anim_data().idle_full_blend then
    l_5_0.unit:brain()._current_logic._chk_request_action_walk_to_flee_pos(l_5_0, my_data)
    do return end
    if my_data.flee_pos then
      local to_pos = my_data.flee_pos
      my_data.flee_pos = nil
      my_data.pathing_to_flee_pos = true
      my_data.flee_path_search_id = tostring(l_5_0.unit:key()) .. "flee"
      l_5_0.unit:brain():search_for_path(my_data.flee_path_search_id, to_pos)
    end
  end
end

CopLogicTrade._process_pathing_results = function(l_6_0, l_6_1)
  if l_6_0.pathing_results then
    local pathing_results = l_6_0.pathing_results
    l_6_0.pathing_results = nil
    local path = pathing_results[l_6_1.flee_path_search_id]
    if path then
      if path ~= "failed" then
        l_6_1.flee_path = path
      else
        l_6_0.unit:set_slot(0)
      end
      l_6_1.pathing_to_flee_pos = nil
      l_6_1.flee_path_search_id = nil
    end
  end
end

CopLogicTrade._chk_request_action_walk_to_flee_pos = function(l_7_0, l_7_1, l_7_2)
  local new_action_data = {}
  new_action_data.type = "walk"
  new_action_data.nav_path = l_7_1.flee_path
  new_action_data.variant = "run"
  new_action_data.body_part = 2
  l_7_1.flee_path = nil
  l_7_1.walking_to_flee_pos = l_7_0.unit:brain():action_request(new_action_data)
end

CopLogicTrade.action_complete_clbk = function(l_8_0, l_8_1)
  local my_data = l_8_0.internal_data
  local action_type = l_8_1:type()
  if action_type == "walk" and my_data.walking_to_flee_pos then
    my_data.walking_to_flee_pos = nil
    l_8_0.unit:set_slot(0)
  end
end

CopLogicTrade.can_activate = function()
  return false
end

CopLogicTrade.is_available_for_assignment = function(l_10_0)
  return false
end

CopLogicTrade._get_all_paths = function(l_11_0)
  return {flee_path = l_11_0.internal_data.flee_path}
end

CopLogicTrade._set_verified_paths = function(l_12_0, l_12_1)
  l_12_0.internal_data.flee_path = l_12_1.flee_path
end

CopLogicTrade.pre_destroy = function(l_13_0)
  managers.trade:change_hostage()
end


