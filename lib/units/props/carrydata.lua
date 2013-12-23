-- Decompiled using luadec 2.0.1 by sztupy (http://winmo.sztupy.hu)
-- Command line was: F:\SteamLibrary\SteamApps\common\PAYDAY 2\lua\lib\units\props\carrydata.luac 

if not CarryData then
  CarryData = class()
end
CarryData.init = function(l_1_0, l_1_1)
  l_1_0._unit = l_1_1
  l_1_0._dye_initiated = false
  l_1_0._has_dye_pack = false
  l_1_0._dye_value_multiplier = 100
  if l_1_0._carry_id then
    l_1_0._value = managers.money:get_bag_value(l_1_0._carry_id)
  else
    l_1_0._value = tweak_data:get_value("money_manager", "bag_values", "default")
  end
end

CarryData.set_mission_element = function(l_2_0, l_2_1)
  l_2_0._mission_element = l_2_1
end

CarryData.trigger_load = function(l_3_0, l_3_1)
  if not l_3_0._mission_element then
    return 
  end
  l_3_0._mission_element:trigger("load", l_3_1)
end

CarryData.update = function(l_4_0, l_4_1, l_4_2, l_4_3)
  if not Network:is_server() then
    return 
  end
  if l_4_0._dye_risk and l_4_0._dye_risk.next_t < l_4_2 then
    l_4_0:_check_dye_explode()
  end
end

CarryData._check_dye_explode = function(l_5_0)
  local chance = math.rand(1)
  if chance < 0.25 then
    l_5_0._dye_risk = nil
    l_5_0:_dye_exploded()
    managers.network:session():send_to_peers_synched("sync_bag_dye_pack_exploded", l_5_0._unit)
    return 
  end
  l_5_0._dye_risk.next_t = Application:time() + 2 + math.random(3)
end

CarryData.sync_dye_exploded = function(l_6_0)
  l_6_0:_dye_exploded()
end

CarryData._dye_exploded = function(l_7_0)
  print("CarryData DYE BOOM")
  l_7_0._value = l_7_0._value * (1 - l_7_0._dye_value_multiplier / 100)
  l_7_0._value = math.round(l_7_0._value)
  l_7_0._has_dye_pack = false
  World:effect_manager():spawn({effect = Idstring("effects/payday2/particles/dye_pack/dye_pack_smoke"), parent = l_7_0._unit:orientation_object()})
end

CarryData.clbk_out_of_world = function(l_8_0)
  if l_8_0._bodies_to_revert then
    for i_body,body in ipairs(l_8_0._bodies_to_revert) do
      body:set_dynamic()
    end
    l_8_0._bodies_to_revert = nil
    l_8_0._register_out_of_world_dynamic_clbk_id = nil
    return 
  else
    if l_8_0._unit:position().z < PlayerMovement.OUT_OF_WORLD_Z then
      l_8_0._bodies_to_revert = {}
      local bodies = l_8_0._unit:num_bodies()
      for i_body = 0, bodies - 1 do
        local body = l_8_0._unit:body(i_body)
        if body:enabled() and body:dynamic() then
          table.insert(l_8_0._bodies_to_revert, body)
          body:set_keyframed()
        end
      end
      local tracker = managers.navigation:create_nav_tracker(l_8_0._unit:position(), false)
      l_8_0._unit:set_position(tracker:field_position())
      managers.navigation:destroy_nav_tracker(tracker)
      l_8_0._register_out_of_world_dynamic_clbk_id = "BagOutOfWorldDynamic" .. tostring(l_8_0._unit:key())
      managers.enemy:add_delayed_clbk(l_8_0._register_out_of_world_dynamic_clbk_id, callback(l_8_0, l_8_0, "clbk_out_of_world"), TimerManager:game():time() + 0.20000000298023)
      l_8_0._register_out_of_world_clbk_id = nil
      return 
    end
  end
  managers.enemy:add_delayed_clbk(l_8_0._register_out_of_world_clbk_id, callback(l_8_0, l_8_0, "clbk_out_of_world"), TimerManager:game():time() + 2)
end

CarryData.carry_id = function(l_9_0)
  return l_9_0._carry_id
end

CarryData.set_carry_id = function(l_10_0, l_10_1)
  l_10_0._carry_id = l_10_1
  l_10_0._register_steal_SO_clbk_id = "CarryDataregiserSO" .. tostring(l_10_0._unit:key())
  managers.enemy:add_delayed_clbk(l_10_0._register_steal_SO_clbk_id, callback(l_10_0, l_10_0, "clbk_register_steal_SO"), 0)
end

CarryData.clbk_register_steal_SO = function(l_11_0, l_11_1)
  l_11_0._register_steal_SO_clbk_id = nil
  l_11_0:_chk_register_steal_SO()
end

CarryData.set_dye_initiated = function(l_12_0, l_12_1)
  l_12_0._dye_initiated = l_12_1
end

CarryData.dye_initiated = function(l_13_0)
  return l_13_0._dye_initiated
end

CarryData.has_dye_pack = function(l_14_0)
  return l_14_0._has_dye_pack
end

CarryData.dye_value_multiplier = function(l_15_0)
  return l_15_0._dye_value_multiplier
end

CarryData.set_dye_pack_data = function(l_16_0, l_16_1, l_16_2, l_16_3)
  l_16_0._dye_initiated = l_16_1
  l_16_0._has_dye_pack = l_16_2
  l_16_0._dye_value_multiplier = l_16_3
  if not Network:is_server() then
    return 
  end
  if l_16_0._has_dye_pack then
    l_16_0._dye_risk = {}
    l_16_0._dye_risk.next_t = Application:time() + 2 + math.random(3)
  end
end

CarryData.dye_pack_data = function(l_17_0)
  return l_17_0._dye_initiated, l_17_0._has_dye_pack, l_17_0._dye_value_multiplier
end

CarryData._disable_dye_pack = function(l_18_0)
  l_18_0._dye_risk = false
end

CarryData.value = function(l_19_0)
  return l_19_0._value
end

CarryData.set_value = function(l_20_0, l_20_1)
  l_20_0._value = l_20_1
end

CarryData.sequence_clbk_secured = function(l_21_0)
  l_21_0:_disable_dye_pack()
end

CarryData._unregister_steal_SO = function(l_22_0)
  if not l_22_0._steal_SO_data then
    return 
  end
  if l_22_0._steal_SO_data.SO_registered then
    managers.groupai:state():remove_special_objective(l_22_0._steal_SO_data.SO_id)
    managers.groupai:state():unregister_loot(l_22_0._unit:key())
  else
    if l_22_0._steal_SO_data.thief then
      local thief = l_22_0._steal_SO_data.thief
      l_22_0._steal_SO_data.thief = nil
      if l_22_0._steal_SO_data.picked_up then
        l_22_0:unlink()
      end
      if alive(thief) then
        thief:brain():set_objective(nil)
      end
    end
  end
  l_22_0._steal_SO_data = nil
end

CarryData._chk_register_steal_SO = function(l_23_0)
  if not Network:is_server() or not managers.navigation:is_data_ready() then
    return 
  end
  local tweak_info = tweak_data.carry[l_23_0._carry_id]
  local AI_carry = tweak_info.AI_carry
  if not AI_carry then
    return 
  end
  if l_23_0._steal_SO_data then
    return 
  end
  if not l_23_0._unit:body("hinge_body_1") then
    local body = l_23_0._unit:body(0)
  end
  if not l_23_0._has_body_activation_clbk then
    l_23_0._has_body_activation_clbk = {body:key() = true}
    l_23_0._unit:add_body_activation_callback(callback(l_23_0, l_23_0, "clbk_body_active_state"))
    body:set_activate_tag(Idstring("bag_moving"))
    body:set_deactivate_tag(Idstring("bag_still"))
  end
  local is_body_active = body:active()
  if is_body_active then
    return 
  end
  local SO_category = AI_carry.SO_category
  local SO_filter = managers.navigation:convert_SO_AI_group_to_access(SO_category)
  local tracker_pickup = managers.navigation:create_nav_tracker(l_23_0._unit:position(), false)
  local pickup_nav_seg = tracker_pickup:nav_segment()
  local pickup_pos = tracker_pickup:field_position()
  local pickup_area = managers.groupai:state():get_area_from_nav_seg_id(pickup_nav_seg)
  managers.navigation:destroy_nav_tracker(tracker_pickup)
  if pickup_area.enemy_loot_drop_points then
    return 
  end
  local drop_pos, drop_nav_seg, drop_area = nil, nil, nil
  local drop_point = managers.groupai:state():get_safe_enemy_loot_drop_point(pickup_nav_seg)
  if drop_point then
    drop_pos = mvector3.copy(drop_point.pos)
    drop_nav_seg = drop_point.nav_seg
    drop_area = drop_point.area
  elseif not l_23_0._register_steal_SO_clbk_id then
    l_23_0._register_steal_SO_clbk_id = "CarryDataregiserSO" .. tostring(l_23_0._unit:key())
    managers.enemy:add_delayed_clbk(l_23_0._register_steal_SO_clbk_id, callback(l_23_0, l_23_0, "clbk_register_steal_SO"), TimerManager:game():time() + 10)
    return 
  end
  {type = "act", pose = "crouch", haste = "walk", nav_seg = drop_nav_seg, pos = drop_pos, area = drop_area, interrupt_dis = 700, interrupt_health = 0.89999997615814}.fail_clbk = callback(l_23_0, l_23_0, "on_secure_SO_failed")
   -- DECOMPILER ERROR: Confused about usage of registers!

  {type = "act", pose = "crouch", haste = "walk", nav_seg = drop_nav_seg, pos = drop_pos, area = drop_area, interrupt_dis = 700, interrupt_health = 0.89999997615814}.complete_clbk = callback(l_23_0, l_23_0, "on_secure_SO_completed")
   -- DECOMPILER ERROR: Confused about usage of registers!

  {type = "act", pose = "crouch", haste = "walk", nav_seg = drop_nav_seg, pos = drop_pos, area = drop_area, interrupt_dis = 700, interrupt_health = 0.89999997615814}.action = {type = "act", variant = "untie", body_part = 1, align_sync = true}
   -- DECOMPILER ERROR: Confused about usage of registers!

  {type = "act", pose = "crouch", haste = "walk", nav_seg = drop_nav_seg, pos = drop_pos, area = drop_area, interrupt_dis = 700, interrupt_health = 0.89999997615814}.action_duration = 2
   -- DECOMPILER ERROR: Confused at declaration of local variable

  {type = "act", haste = "run", pose = "crouch", destroy_clbk_key = false, nav_seg = pickup_nav_seg, area = pickup_area, pos = pickup_pos, interrupt_dis = 700, interrupt_health = 0.89999997615814, fail_clbk = callback(l_23_0, l_23_0, "on_pickup_SO_failed"), complete_clbk = callback(l_23_0, l_23_0, "on_pickup_SO_completed"), action = {type = "act", variant = "untie", body_part = 1, align_sync = true}}.action_duration = math.lerp(1, 2.5, math.random())
   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

  {type = "act", haste = "run", pose = "crouch", destroy_clbk_key = false, nav_seg = pickup_nav_seg, area = pickup_area, pos = pickup_pos, interrupt_dis = 700, interrupt_health = 0.89999997615814, fail_clbk = callback(l_23_0, l_23_0, "on_pickup_SO_failed"), complete_clbk = callback(l_23_0, l_23_0, "on_pickup_SO_completed"), action = {type = "act", variant = "untie", body_part = 1, align_sync = true}}.followup_objective = {type = "act", pose = "crouch", haste = "walk", nav_seg = drop_nav_seg, pos = drop_pos, area = drop_area, interrupt_dis = 700, interrupt_health = 0.89999997615814}
   -- DECOMPILER ERROR: Confused at declaration of local variable

   -- DECOMPILER ERROR: Confused about usage of registers!

  {objective = {type = "act", haste = "run", pose = "crouch", destroy_clbk_key = false, nav_seg = pickup_nav_seg, area = pickup_area, pos = pickup_pos, interrupt_dis = 700, interrupt_health = 0.89999997615814, fail_clbk = callback(l_23_0, l_23_0, "on_pickup_SO_failed"), complete_clbk = callback(l_23_0, l_23_0, "on_pickup_SO_completed"), action = {type = "act", variant = "untie", body_part = 1, align_sync = true}}, base_chance = 1}.chance_inc = 0
   -- DECOMPILER ERROR: Confused about usage of registers!

  {objective = {type = "act", haste = "run", pose = "crouch", destroy_clbk_key = false, nav_seg = pickup_nav_seg, area = pickup_area, pos = pickup_pos, interrupt_dis = 700, interrupt_health = 0.89999997615814, fail_clbk = callback(l_23_0, l_23_0, "on_pickup_SO_failed"), complete_clbk = callback(l_23_0, l_23_0, "on_pickup_SO_completed"), action = {type = "act", variant = "untie", body_part = 1, align_sync = true}}, base_chance = 1}.interval = 0
   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

  {objective = {type = "act", haste = "run", pose = "crouch", destroy_clbk_key = false, nav_seg = pickup_nav_seg, area = pickup_area, pos = pickup_pos, interrupt_dis = 700, interrupt_health = 0.89999997615814, fail_clbk = callback(l_23_0, l_23_0, "on_pickup_SO_failed"), complete_clbk = callback(l_23_0, l_23_0, "on_pickup_SO_completed"), action = {type = "act", variant = "untie", body_part = 1, align_sync = true}}, base_chance = 1}.search_pos = ({type = "act", haste = "run", pose = "crouch", destroy_clbk_key = false, nav_seg = pickup_nav_seg, area = pickup_area, pos = pickup_pos, interrupt_dis = 700, interrupt_health = 0.89999997615814, fail_clbk = callback(l_23_0, l_23_0, "on_pickup_SO_failed"), complete_clbk = callback(l_23_0, l_23_0, "on_pickup_SO_completed"), action = {type = "act", variant = "untie", body_part = 1, align_sync = true}}).pos
   -- DECOMPILER ERROR: Confused about usage of registers!

  {objective = {type = "act", haste = "run", pose = "crouch", destroy_clbk_key = false, nav_seg = pickup_nav_seg, area = pickup_area, pos = pickup_pos, interrupt_dis = 700, interrupt_health = 0.89999997615814, fail_clbk = callback(l_23_0, l_23_0, "on_pickup_SO_failed"), complete_clbk = callback(l_23_0, l_23_0, "on_pickup_SO_completed"), action = {type = "act", variant = "untie", body_part = 1, align_sync = true}}, base_chance = 1}.verification_clbk = callback(l_23_0, l_23_0, "clbk_pickup_SO_verification")
   -- DECOMPILER ERROR: Confused about usage of registers!

  {objective = {type = "act", haste = "run", pose = "crouch", destroy_clbk_key = false, nav_seg = pickup_nav_seg, area = pickup_area, pos = pickup_pos, interrupt_dis = 700, interrupt_health = 0.89999997615814, fail_clbk = callback(l_23_0, l_23_0, "on_pickup_SO_failed"), complete_clbk = callback(l_23_0, l_23_0, "on_pickup_SO_completed"), action = {type = "act", variant = "untie", body_part = 1, align_sync = true}}, base_chance = 1}.usage_amount = 1
   -- DECOMPILER ERROR: Confused about usage of registers!

  {objective = {type = "act", haste = "run", pose = "crouch", destroy_clbk_key = false, nav_seg = pickup_nav_seg, area = pickup_area, pos = pickup_pos, interrupt_dis = 700, interrupt_health = 0.89999997615814, fail_clbk = callback(l_23_0, l_23_0, "on_pickup_SO_failed"), complete_clbk = callback(l_23_0, l_23_0, "on_pickup_SO_completed"), action = {type = "act", variant = "untie", body_part = 1, align_sync = true}}, base_chance = 1}.AI_group = AI_carry.SO_category
   -- DECOMPILER ERROR: Confused about usage of registers!

  {objective = {type = "act", haste = "run", pose = "crouch", destroy_clbk_key = false, nav_seg = pickup_nav_seg, area = pickup_area, pos = pickup_pos, interrupt_dis = 700, interrupt_health = 0.89999997615814, fail_clbk = callback(l_23_0, l_23_0, "on_pickup_SO_failed"), complete_clbk = callback(l_23_0, l_23_0, "on_pickup_SO_completed"), action = {type = "act", variant = "untie", body_part = 1, align_sync = true}}, base_chance = 1}.admin_clbk = callback(l_23_0, l_23_0, "on_pickup_SO_administered")
   -- DECOMPILER ERROR: Confused at declaration of local variable

  do
     -- DECOMPILER ERROR: Confused at declaration of local variable

     -- DECOMPILER ERROR: Confused about usage of registers!

    l_23_0._steal_SO_data = {SO_id = "carrysteal" .. tostring(l_23_0._unit:key()), SO_registered = true, pickup_area = pickup_area, picked_up = false, pickup_objective = {type = "act", haste = "run", pose = "crouch", destroy_clbk_key = false, nav_seg = pickup_nav_seg, area = pickup_area, pos = pickup_pos, interrupt_dis = 700, interrupt_health = 0.89999997615814, fail_clbk = callback(l_23_0, l_23_0, "on_pickup_SO_failed"), complete_clbk = callback(l_23_0, l_23_0, "on_pickup_SO_completed"), action = {type = "act", variant = "untie", body_part = 1, align_sync = true}}}
     -- DECOMPILER ERROR: Confused about usage of registers!

     -- DECOMPILER ERROR: Confused about usage of registers!

    managers.groupai:state():add_special_objective("carrysteal" .. tostring(l_23_0._unit:key()), {objective = {type = "act", haste = "run", pose = "crouch", destroy_clbk_key = false, nav_seg = pickup_nav_seg, area = pickup_area, pos = pickup_pos, interrupt_dis = 700, interrupt_health = 0.89999997615814, fail_clbk = callback(l_23_0, l_23_0, "on_pickup_SO_failed"), complete_clbk = callback(l_23_0, l_23_0, "on_pickup_SO_completed"), action = {type = "act", variant = "untie", body_part = 1, align_sync = true}}, base_chance = 1})
    managers.groupai:state():register_loot(l_23_0._unit, pickup_area)
  end
   -- DECOMPILER ERROR: Confused about usage of registers for local variables.

end

CarryData.clbk_pickup_SO_verification = function(l_24_0, l_24_1)
  if not l_24_0._steal_SO_data or not l_24_0._steal_SO_data.SO_id then
    debug_pause_unit(l_24_0._unit, "[CarryData:clbk_pickup_SO_verification] SO is not registered", l_24_0._unit, l_24_1, inspect(l_24_0._steal_SO_data))
    return 
  end
  if l_24_1:movement():cool() then
    return 
  end
  local nav_seg = l_24_1:movement():nav_tracker():nav_segment()
  if not l_24_0._steal_SO_data.pickup_area.nav_segs[nav_seg] then
    return 
  end
  return true
end

CarryData.on_pickup_SO_administered = function(l_25_0, l_25_1)
  if l_25_0._steal_SO_data.thief then
    debug_pause("[CarryData:on_pickup_SO_administered] Already had a thief!!!!", l_25_1, l_25_0._steal_SO_data.thief)
  end
  l_25_0._steal_SO_data.thief = l_25_1
  l_25_0._steal_SO_data.SO_registered = false
  managers.groupai:state():unregister_loot(l_25_0._unit:key())
end

CarryData.on_pickup_SO_completed = function(l_26_0, l_26_1)
  if l_26_1 ~= l_26_0._steal_SO_data.thief then
    debug_pause_unit(l_26_1, "[CarryData:on_pickup_SO_completed] idiot thinks he is stealing", l_26_1)
    return 
  end
  l_26_0._steal_SO_data.picked_up = true
  l_26_0:link_to(l_26_1)
end

CarryData.on_pickup_SO_failed = function(l_27_0, l_27_1)
  if not l_27_0._steal_SO_data.thief then
    return 
  end
  if l_27_1 ~= l_27_0._steal_SO_data.thief then
    debug_pause_unit(l_27_1, "[CarryData:on_pickup_SO_failed] idiot thinks he is stealing", l_27_1)
    return 
  end
  l_27_0._steal_SO_data = nil
  l_27_0:_chk_register_steal_SO()
end

CarryData.on_secure_SO_completed = function(l_28_0, l_28_1)
  if l_28_1 ~= l_28_0._steal_SO_data.thief then
    debug_pause_unit(sympathy_civ, "[CarryData:on_secure_SO_completed] idiot thinks he is stealing", l_28_1)
    return 
  end
  l_28_0._steal_SO_data = nil
  managers.mission:call_global_event("loot_lost")
  l_28_0._steal_SO_data = nil
  l_28_0:unlink()
end

CarryData.on_secure_SO_failed = function(l_29_0, l_29_1)
  if not l_29_0._steal_SO_data.thief then
    return 
  end
  if l_29_1 ~= l_29_0._steal_SO_data.thief then
    debug_pause_unit(l_29_1, "[CarryData:on_pickup_SO_failed] idiot thinks he is stealing", l_29_1)
    return 
  end
  l_29_0._steal_SO_data = nil
  l_29_0:_chk_register_steal_SO()
  l_29_0:unlink()
end

CarryData.link_to = function(l_30_0, l_30_1)
  if not l_30_0._unit:body("hinge_body_1") then
    local body = l_30_0._unit:body(0)
  end
  body:set_keyframed()
  local parent_obj_name = Idstring("Neck")
  l_30_1:link(parent_obj_name, l_30_0._unit)
  local parent_obj = l_30_1:get_object(parent_obj_name)
  local parent_obj_rot = parent_obj:rotation()
  local world_pos = parent_obj:position() - parent_obj_rot:z() * 30 - parent_obj_rot:y() * 10
  l_30_0._unit:set_position(world_pos)
  local world_rot = Rotation(parent_obj_rot:x(), -parent_obj_rot:z())
  l_30_0._unit:set_rotation(world_rot)
  l_30_0._disabled_collisions = {}
  local nr_bodies = l_30_0._unit:num_bodies()
  for i_body = 0, nr_bodies - 1 do
    local body = l_30_0._unit:body(i_body)
    if body:collisions_enabled() then
      table.insert(l_30_0._disabled_collisions, body)
      body:set_collisions_enabled(false)
    end
  end
  if Network:is_server() then
    managers.network:session():send_to_peers_synched("loot_link", l_30_0._unit, l_30_1)
  end
end

CarryData.unlink = function(l_31_0)
  l_31_0._unit:unlink()
  if not l_31_0._unit:body("hinge_body_1") then
    local body = l_31_0._unit:body(0)
  end
  body:set_dynamic()
  if l_31_0._disabled_collisions then
    for _,body in ipairs(l_31_0._disabled_collisions) do
      body:set_collisions_enabled(true)
    end
    l_31_0._disabled_collisions = nil
  end
  if Network:is_server() then
    managers.network:session():send_to_peers_synched("loot_link", l_31_0._unit, l_31_0._unit)
  end
end

CarryData.clbk_body_active_state = function(l_32_0, l_32_1, l_32_2, l_32_3, l_32_4)
  if not l_32_0._has_body_activation_clbk[l_32_3:key()] then
    return 
  end
  if l_32_4 then
    if not l_32_0._steal_SO_data or not l_32_0._steal_SO_data.picked_up then
      l_32_0:_unregister_steal_SO()
    end
    if not l_32_0._register_out_of_world_clbk_id then
      l_32_0._register_out_of_world_clbk_id = "BagOutOfWorld" .. tostring(l_32_0._unit:key())
      managers.enemy:add_delayed_clbk(l_32_0._register_out_of_world_clbk_id, callback(l_32_0, l_32_0, "clbk_out_of_world"), TimerManager:game():time() + 2)
    else
      l_32_0:_chk_register_steal_SO()
      if l_32_0._register_out_of_world_clbk_id then
        managers.enemy:remove_delayed_clbk(l_32_0._register_out_of_world_clbk_id)
        l_32_0._register_out_of_world_clbk_id = nil
      end
    end
  end
end

CarryData.clbk_send_link = function(l_33_0)
  if (alive(l_33_0._unit) and l_33_0._steal_SO_data) or not l_33_0._steal_SO_data.thief and l_33_0._steal_SO_data.picked_up then
    managers.network:session():send_to_peers_synched("loot_link", l_33_0._unit, l_33_0._steal_SO_data.thief)
  end
end

CarryData.save = function(l_34_0, l_34_1)
  local state = {}
  state.carry_id = l_34_0._carry_id
  state.value = l_34_0._value
  state.dye_initiated = l_34_0._dye_initiated
  state.has_dye_pack = l_34_0._has_dye_pack
  state.dye_value_multiplier = l_34_0._dye_value_multiplier
  if l_34_0._steal_SO_data and l_34_0._steal_SO_data.picked_up then
    managers.enemy:add_delayed_clbk("send_loot_link" .. tostring(l_34_0._unit:key()), callback(l_34_0, l_34_0, "clbk_send_link"), TimerManager:game():time() + 0.10000000149012)
  end
  l_34_1.CarryData = state
end

CarryData.load = function(l_35_0, l_35_1)
  local state = l_35_1.CarryData
  l_35_0._carry_id = state.carry_id
  l_35_0._value = state.value
  l_35_0._dye_initiated = state.dye_initiated
  l_35_0._has_dye_pack = state.has_dye_pack
  l_35_0._dye_value_multiplier = state.dye_value_multiplier
end

CarryData.destroy = function(l_36_0)
  if l_36_0._register_steal_SO_clbk_id then
    managers.enemy:remove_delayed_clbk(l_36_0._register_steal_SO_clbk_id)
    l_36_0._register_steal_SO_clbk_id = nil
  end
  if l_36_0._register_out_of_world_clbk_id then
    managers.enemy:remove_delayed_clbk(l_36_0._register_out_of_world_clbk_id)
    l_36_0._register_out_of_world_clbk_id = nil
  end
  if l_36_0._register_out_of_world_dynamic_clbk_id then
    managers.enemy:remove_delayed_clbk(l_36_0._register_out_of_world_dynamic_clbk_id)
    l_36_0._register_out_of_world_dynamic_clbk_id = nil
  end
  l_36_0:_unregister_steal_SO()
end


