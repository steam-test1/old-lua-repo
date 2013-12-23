-- Decompiled using luadec 2.0.1 by sztupy (http://winmo.sztupy.hu)
-- Command line was: F:\SteamLibrary\SteamApps\common\PAYDAY 2\lua\lib\units\equipment\doctor_bag\doctorbagbase.luac 

if not DoctorBagBase then
  DoctorBagBase = class(UnitBase)
end
DoctorBagBase.spawn = function(l_1_0, l_1_1, l_1_2)
  local unit_name = "units/payday2/equipment/gen_equipment_medicbag/gen_equipment_medicbag"
  local unit = World:spawn_unit(Idstring(unit_name), l_1_0, l_1_1)
  managers.network:session():send_to_peers_synched("sync_doctor_bag_setup", unit, l_1_2)
  unit:base():setup(l_1_2)
  return unit
end

DoctorBagBase.set_server_information = function(l_2_0, l_2_1)
  l_2_0._server_information = {owner_peer_id = l_2_1}
  managers.network:game():member(l_2_1):peer():set_used_deployable(true)
end

DoctorBagBase.server_information = function(l_3_0)
  return l_3_0._server_information
end

DoctorBagBase.init = function(l_4_0, l_4_1)
  UnitBase.init(l_4_0, l_4_1, false)
  l_4_0._unit = l_4_1
  l_4_0._unit:sound_source():post_event("ammo_bag_drop")
  l_4_0._max_amount = tweak_data.upgrades.doctor_bag_base + managers.player:upgrade_value_by_level("doctor_bag", "amount_increase", 1)
end

DoctorBagBase.sync_setup = function(l_5_0, l_5_1)
  l_5_0:setup(l_5_1)
end

DoctorBagBase.setup = function(l_6_0, l_6_1)
  l_6_0._amount = tweak_data.upgrades.doctor_bag_base + managers.player:upgrade_value_by_level("doctor_bag", "amount_increase", l_6_1)
  l_6_0:_set_visual_stage()
  if Network:is_server() then
    local from_pos = l_6_0._unit:position() + l_6_0._unit:rotation():z() * 10
    local to_pos = l_6_0._unit:position() + l_6_0._unit:rotation():z() * -10
    local ray = l_6_0._unit:raycast("ray", from_pos, to_pos, "slot_mask", managers.slot:get_mask("world_geometry"))
    if ray then
      l_6_0._attached_data = {}
      l_6_0._attached_data.body = ray.body
      l_6_0._attached_data.position = ray.body:position()
      l_6_0._attached_data.rotation = ray.body:rotation()
      l_6_0._attached_data.index = 1
      l_6_0._attached_data.max_index = 3
      l_6_0._unit:set_extension_update_enabled(Idstring("base"), true)
    end
  end
end

DoctorBagBase.update = function(l_7_0, l_7_1, l_7_2, l_7_3)
  l_7_0:_check_body()
end

DoctorBagBase._check_body = function(l_8_0)
  if l_8_0._is_dynamic then
    return 
  end
  if not alive(l_8_0._attached_data.body) then
    l_8_0:server_set_dynamic()
    return 
  end
  if l_8_0._attached_data.index == 1 and not l_8_0._attached_data.body:enabled() then
    l_8_0:server_set_dynamic()
    do return end
    if l_8_0._attached_data.index == 2 and not mrotation.equal(l_8_0._attached_data.rotation, l_8_0._attached_data.body:rotation()) then
      l_8_0:server_set_dynamic()
      do return end
      if l_8_0._attached_data.index == 3 and mvector3.not_equal(l_8_0._attached_data.position, l_8_0._attached_data.body:position()) then
        l_8_0:server_set_dynamic()
      end
    end
  end
  l_8_0._attached_data.index = (l_8_0._attached_data.index < l_8_0._attached_data.max_index and l_8_0._attached_data.index or 0) + 1
end

DoctorBagBase.server_set_dynamic = function(l_9_0)
  l_9_0:_set_dynamic()
  if managers.network:session() then
    managers.network:session():send_to_peers_synched("sync_unit_event_id_8", l_9_0._unit, "base", 1)
  end
end

DoctorBagBase.sync_net_event = function(l_10_0, l_10_1)
  l_10_0:_set_dynamic()
end

DoctorBagBase._set_dynamic = function(l_11_0)
  l_11_0._is_dynamic = true
  l_11_0._unit:body("dynamic"):set_enabled(true)
end

DoctorBagBase.take = function(l_12_0, l_12_1)
  if l_12_0._empty then
    return 
  end
  local taken = l_12_0:_take(l_12_1)
  if taken > 0 then
    l_12_1:sound():play("pickup_ammo")
    managers.network:session():send_to_peers_synched("sync_doctor_bag_taken", l_12_0._unit, taken)
  end
  if l_12_0._amount <= 0 then
    l_12_0:_set_empty()
  else
    l_12_0:_set_visual_stage()
  end
  return taken > 0
end

DoctorBagBase._set_visual_stage = function(l_13_0)
  local percentage = l_13_0._amount / l_13_0._max_amount
  if l_13_0._unit:damage() then
    local state = "state_" .. math.ceil(percentage * 4)
    if l_13_0._unit:damage():has_sequence(state) then
      l_13_0._unit:damage():run_sequence_simple(state)
    end
  end
end

DoctorBagBase.sync_taken = function(l_14_0, l_14_1)
  l_14_0._amount = l_14_0._amount - l_14_1
  if l_14_0._amount <= 0 then
    l_14_0:_set_empty()
  else
    l_14_0:_set_visual_stage()
  end
end

DoctorBagBase._take = function(l_15_0, l_15_1)
  local taken = 1
  l_15_0._amount = l_15_0._amount - taken
  l_15_1:character_damage():recover_health()
  return taken
end

DoctorBagBase._set_empty = function(l_16_0)
  l_16_0._empty = true
  l_16_0._unit:set_slot(0)
end

DoctorBagBase.save = function(l_17_0, l_17_1)
  local state = {}
  state.amount = l_17_0._amount
  state.is_dynamic = l_17_0._is_dynamic
  l_17_1.DoctorBagBase = state
end

DoctorBagBase.load = function(l_18_0, l_18_1)
  local state = l_18_1.DoctorBagBase
  l_18_0._amount = state.amount
  if state.is_dynamic then
    l_18_0:_set_dynamic()
  end
  l_18_0:_set_visual_stage()
end

DoctorBagBase.destroy = function(l_19_0)
end


