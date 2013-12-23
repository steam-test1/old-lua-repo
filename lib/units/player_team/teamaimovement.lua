-- Decompiled using luadec 2.0.1 by sztupy (http://winmo.sztupy.hu)
-- Command line was: F:\SteamLibrary\SteamApps\common\PAYDAY 2\lua\lib\units\player_team\teamaimovement.luac 

if not TeamAIMovement then
  TeamAIMovement = class(CopMovement)
end
TeamAIMovement._char_name_to_index = HuskPlayerMovement._char_name_to_index
TeamAIMovement._char_model_names = HuskPlayerMovement._char_model_names
TeamAIMovement._post_init = function(l_1_0)
  if managers.groupai:state():whisper_mode() then
    if not l_1_0._heat_listener_clbk and Network:is_server() then
      l_1_0._heat_listener_clbk = "TeamAIMovement" .. tostring(l_1_0._unit:key())
      managers.groupai:state():add_listener(l_1_0._heat_listener_clbk, {"whisper_mode"}, callback(l_1_0, l_1_0, "heat_clbk"))
    end
    l_1_0._unit:base():set_slot(l_1_0._unit, 24)
  else
    l_1_0:set_cool(false)
  end
  l_1_0._standing_nav_seg_id = l_1_0._nav_tracker:nav_segment()
  l_1_0:play_redirect("idle")
end

TeamAIMovement.set_character_anim_variables = function(l_2_0)
  local char_name = managers.criminals:character_name_by_unit(l_2_0._unit)
  if char_name and l_2_0._unit:damage() then
    local ai_character_id = managers.criminals:character_static_data_by_name(char_name).ai_character_id
    local sequence = tweak_data.blackmarket.characters[ai_character_id].sequence
    l_2_0._unit:damage():run_sequence_simple(sequence)
    managers.game_play_central:change_contour_material_by_unit(l_2_0._unit)
  end
  HuskPlayerMovement.set_character_anim_variables(l_2_0)
end

TeamAIMovement.check_visual_equipment = function(l_3_0)
end

TeamAIMovement.m_detect_pos = function(l_4_0)
  return l_4_0._m_head_pos
end

TeamAIMovement.set_position = function(l_5_0, l_5_1)
  CopMovement.set_position(l_5_0, l_5_1)
  l_5_0:_upd_location()
end

TeamAIMovement.set_m_pos = function(l_6_0, l_6_1)
  CopMovement.set_m_pos(l_6_0, l_6_1)
  l_6_0:_upd_location()
end

TeamAIMovement._upd_location = function(l_7_0)
  local nav_seg_id = l_7_0._nav_tracker:nav_segment()
  if l_7_0._standing_nav_seg_id ~= nav_seg_id then
    l_7_0._standing_nav_seg_id = nav_seg_id
    local metadata = managers.navigation:get_nav_seg_metadata(nav_seg_id)
    local location_id = metadata.location_id
    managers.hud:set_mugshot_location(l_7_0._unit:unit_data().mugshot_id, location_id)
    managers.groupai:state():on_criminal_nav_seg_change(l_7_0._unit, nav_seg_id)
  end
end

TeamAIMovement.get_location_id = function(l_8_0)
  return managers.navigation:get_nav_seg_metadata(l_8_0._standing_nav_seg_id).location_id
end

TeamAIMovement.on_cuffed = function(l_9_0)
  l_9_0._unit:brain():set_logic("surrender")
  l_9_0._unit:network():send("arrested")
  l_9_0._unit:character_damage():on_arrested()
end

TeamAIMovement.on_SPOOCed = function(l_10_0)
  l_10_0._unit:brain():set_logic("surrender")
  l_10_0._unit:network():send("arrested")
  l_10_0._unit:character_damage():on_arrested()
end

TeamAIMovement.on_discovered = function(l_11_0)
  if l_11_0._cool then
    l_11_0:_switch_to_not_cool()
  end
end

TeamAIMovement.on_tase_ended = function(l_12_0)
  l_12_0._unit:character_damage():on_tase_ended()
end

TeamAIMovement.tased = function(l_13_0)
  return l_13_0._unit:anim_data().tased
end

TeamAIMovement.cool = function(l_14_0)
  return l_14_0._cool
end

TeamAIMovement.downed = function(l_15_0)
  return l_15_0._unit:interaction()._active
end

TeamAIMovement.set_cool = function(l_16_0, l_16_1)
   -- DECOMPILER ERROR: Confused while interpreting a jump as a 'while'

end
l_16_1 = true
if l_16_1 == l_16_0._cool then
  return 
end
local old_state = l_16_0._cool
if l_16_1 then
  l_16_0._cool = true
  if not l_16_0._heat_listener_clbk and Network:is_server() then
    l_16_0._heat_listener_clbk = "TeamAIMovement" .. tostring(l_16_0._unit:key())
    managers.groupai:state():add_listener(l_16_0._heat_listener_clbk, {"whisper_mode"}, callback(l_16_0, l_16_0, "heat_clbk"))
  end
  l_16_0._unit:base():set_slot(l_16_0._unit, 24)
  if l_16_0._unit:brain().on_cool_state_changed then
    l_16_0._unit:brain():on_cool_state_changed(true)
  end
  l_16_0:set_stance_by_code(1)
else
  l_16_0:_switch_to_not_cool(true)
end
end

TeamAIMovement.heat_clbk = function(l_17_0, l_17_1)
  if l_17_0._cool and not l_17_1 then
    l_17_0:_switch_to_not_cool()
  end
end

TeamAIMovement._switch_to_not_cool = function(l_18_0, l_18_1)
  if not Network:is_server() then
    return 
  end
  if l_18_0._heat_listener_clbk then
    managers.groupai:state():remove_listener(l_18_0._heat_listener_clbk)
    l_18_0._heat_listener_clbk = nil
  end
  if l_18_1 then
    if l_18_0._switch_to_not_cool_clbk_id then
      managers.enemy:remove_delayed_clbk(l_18_0._switch_to_not_cool_clbk_id)
    end
    l_18_0._switch_to_not_cool_clbk_id = "dummy"
    l_18_0:_switch_to_not_cool_clbk_func()
  elseif not l_18_0._switch_to_not_cool_clbk_id then
    l_18_0._switch_to_not_cool_clbk_id = "switch_to_not_cool_clbk" .. tostring(l_18_0._unit:key())
    managers.enemy:add_delayed_clbk(l_18_0._switch_to_not_cool_clbk_id, callback(l_18_0, l_18_0, "_switch_to_not_cool_clbk_func"), Application:time() + math.random() * 1 + 0.5)
  end
end

TeamAIMovement._switch_to_not_cool_clbk_func = function(l_19_0)
  if l_19_0._switch_to_not_cool_clbk_id and l_19_0._cool then
    l_19_0._switch_to_not_cool_clbk_id = nil
    l_19_0._cool = false
    l_19_0._unit:base():set_slot(l_19_0._unit, 16)
    if l_19_0._unit:brain()._logic_data and l_19_0._unit:brain():is_available_for_assignment() then
      l_19_0._unit:brain():set_objective()
      l_19_0._unit:movement():action_request({type = "idle", body_part = 1, sync = true})
    end
    l_19_0:set_stance_by_code(2)
    l_19_0._unit:brain():on_cool_state_changed(false)
  end
end

TeamAIMovement.pre_destroy = function(l_20_0)
  if l_20_0._heat_listener_clbk then
    managers.groupai:state():remove_listener(l_20_0._heat_listener_clbk)
    l_20_0._heat_listener_clbk = nil
  end
  if l_20_0._nav_tracker then
    managers.navigation:destroy_nav_tracker(l_20_0._nav_tracker)
    l_20_0._nav_tracker = nil
  end
  if l_20_0._switch_to_not_cool_clbk_id then
    managers.enemy:remove_delayed_clbk(l_20_0._switch_to_not_cool_clbk_id)
    l_20_0._switch_to_not_cool_clbk_id = nil
  end
  if l_20_0._link_data then
    l_20_0._link_data.parent:base():remove_destroy_listener("CopMovement" .. tostring(unit:key()))
  end
  if alive(l_20_0._rope) then
    l_20_0._rope:base():retract()
    l_20_0._rope = nil
  end
  l_20_0:_destroy_gadgets()
  for i_action,action in ipairs(l_20_0._active_actions) do
    if action and action.on_destroy then
      action:on_destroy()
    end
  end
  if l_20_0._attention and l_20_0._attention.destroy_listener_key then
    l_20_0._attention.unit:base():remove_destroy_listener(l_20_0._attention.destroy_listener_key)
    l_20_0._attention.destroy_listener_key = nil
  end
end


