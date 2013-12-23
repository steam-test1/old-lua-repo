-- Decompiled using luadec 2.0.1 by sztupy (http://winmo.sztupy.hu)
-- Command line was: F:\SteamLibrary\SteamApps\common\PAYDAY 2\lua\lib\units\equipment\ecm_jammer\ecmjammerbase.luac 

local tmp_vec1 = Vector3()
if not ECMJammerBase then
  ECMJammerBase = class(UnitBase)
end
ECMJammerBase._NET_EVENTS = {battery_low = 1, battery_empty = 2, feedback_start = 3, feedback_stop = 4, jammer_active = 5}
ECMJammerBase.spawn = function(l_1_0, l_1_1, l_1_2, l_1_3)
  local unit = World:spawn_unit(Idstring("units/payday2/equipment/gen_equipment_jammer/gen_equipment_jammer"), l_1_0, l_1_1)
  unit:base():setup(l_1_2, l_1_3)
  return unit
end

ECMJammerBase.set_server_information = function(l_2_0, l_2_1)
  l_2_0._server_information = {owner_peer_id = l_2_1}
  managers.network:game():member(l_2_1):peer():set_used_deployable(true)
end

ECMJammerBase.server_information = function(l_3_0)
  return l_3_0._server_information
end

ECMJammerBase.init = function(l_4_0, l_4_1)
  UnitBase.init(l_4_0, l_4_1, true)
  l_4_0._unit = l_4_1
  l_4_0._position = l_4_0._unit:position()
  l_4_0._rotation = l_4_0._unit:rotation()
  l_4_0._g_glow_jammer_green = l_4_0._unit:get_object(Idstring("g_glow_func1_green"))
  l_4_0._g_glow_jammer_red = l_4_0._unit:get_object(Idstring("g_glow_func1_red"))
  l_4_0._g_glow_feedback_green = l_4_0._unit:get_object(Idstring("g_glow_func2_green"))
  l_4_0._g_glow_feedback_red = l_4_0._unit:get_object(Idstring("g_glow_func2_red"))
  l_4_0._max_battery_life = tweak_data.upgrades.ecm_jammer_base_battery_life
  l_4_0._battery_life = l_4_0._max_battery_life
  l_4_0._low_battery_life = tweak_data.upgrades.ecm_jammer_base_low_battery_life
  l_4_0._feedback_active = false
  l_4_0._jammer_active = false
end

ECMJammerBase.get_name_id = function(l_5_0)
  return "ecm_jammer"
end

ECMJammerBase.set_owner = function(l_6_0, l_6_1)
  l_6_0._owner = l_6_1
end

ECMJammerBase.owner = function(l_7_0)
  return l_7_0._owner
end

ECMJammerBase.battery_life = function(l_8_0)
  return l_8_0._battery_life or 0
end

ECMJammerBase.sync_net_event = function(l_9_0, l_9_1)
  local net_events = l_9_0._NET_EVENTS
  if l_9_1 == net_events.battery_low then
    l_9_0:_set_battery_low()
  elseif l_9_1 == net_events.battery_empty then
    l_9_0:_set_battery_empty()
  elseif l_9_1 == net_events.feedback_start then
    l_9_0:_set_feedback_active(true)
  elseif l_9_1 == net_events.feedback_stop then
    l_9_0:_set_feedback_active(false)
  elseif l_9_1 == net_events.jammer_active then
    l_9_0:set_active(true)
  end
end

ECMJammerBase._send_net_event = function(l_10_0, l_10_1)
  managers.network:session():send_to_peers_synched("sync_unit_event_id_8", l_10_0._unit, "base", l_10_1)
end

ECMJammerBase._send_net_event_to_host = function(l_11_0, l_11_1)
  managers.network:session():send_to_host("sync_unit_event_id_8", l_11_0._unit, "base", l_11_1)
end

ECMJammerBase.setup = function(l_12_0, l_12_1, l_12_2)
  l_12_0._slotmask = managers.slot:get_mask("trip_mine_targets")
  l_12_0._max_battery_life = tweak_data.upgrades.ecm_jammer_base_battery_life * l_12_1
  l_12_0._battery_life = l_12_0._max_battery_life
  l_12_0._owner = l_12_2
end

ECMJammerBase.set_active = function(l_13_0, l_13_1)
  if l_13_1 then
    l_13_1 = true
  end
  if l_13_0._jammer_active == l_13_1 then
    return 
  end
  if Network:is_server() then
    if l_13_1 then
      l_13_0._owner_peer_id = managers.network:session():local_peer():id()
      local from_pos = l_13_0._unit:position() + l_13_0._unit:rotation():y() * 10
      local to_pos = l_13_0._unit:position() + l_13_0._unit:rotation():y() * -10
      local ray = l_13_0._unit:raycast("ray", from_pos, to_pos, "slot_mask", managers.slot:get_mask("trip_mine_placeables"))
      if ray then
        l_13_0._attached_data = {}
        l_13_0._attached_data.body = ray.body
        l_13_0._attached_data.position = ray.body:position()
        l_13_0._attached_data.rotation = ray.body:rotation()
        l_13_0._attached_data.index = 1
        l_13_0._attached_data.max_index = 3
      end
      l_13_0._alert_filter = l_13_0._owner:movement():SO_access()
      local jam_cameras = nil
      if managers.network:game():member_from_unit(l_13_0._owner):peer():id() == 1 then
        jam_cameras = managers.player:has_category_upgrade("ecm_jammer", "affects_cameras")
      else
        jam_cameras = l_13_0._owner:base():upgrade_value("ecm_jammer", "affects_cameras")
      end
      managers.groupai:state():register_ecm_jammer(l_13_0._unit, {call = true, camera = jam_cameras})
      l_13_0:_send_net_event(l_13_0._NET_EVENTS.jammer_active)
    else
      managers.groupai:state():register_ecm_jammer(l_13_0._unit, false)
    end
  end
  if l_13_1 and not l_13_0._jam_sound_event then
    l_13_0._jam_sound_event = l_13_0._unit:sound_source():post_event("ecm_jammer_jam_signal")
    do return end
    if l_13_0._jam_sound_event then
      l_13_0._jam_sound_event:stop()
      l_13_0._jam_sound_event = nil
      l_13_0._unit:sound_source():post_event("ecm_jammer_jam_signal_stop")
    end
  end
  l_13_0._jammer_active = l_13_1
end

ECMJammerBase.active = function(l_14_0)
  return l_14_0._jammer_active
end

ECMJammerBase.update = function(l_15_0, l_15_1, l_15_2, l_15_3)
  if l_15_0._battery_life > 0 then
    l_15_0._battery_life = l_15_0._battery_life - l_15_3
    l_15_0:check_battery()
  end
  l_15_0:_check_body()
end

ECMJammerBase.check_battery = function(l_16_0)
  if l_16_0._battery_life <= 0 then
    l_16_0:set_battery_empty()
  else
    if l_16_0._battery_life <= l_16_0._low_battery_life then
      l_16_0:set_battery_low()
    end
  end
end

ECMJammerBase.set_battery_empty = function(l_17_0)
  if l_17_0._battery_empty then
    return 
  end
  l_17_0._battery_life = 0
  l_17_0:_set_battery_empty()
end

ECMJammerBase._set_battery_empty = function(l_18_0)
  l_18_0._battery_empty = true
  l_18_0._g_glow_jammer_green:set_visibility(false)
  l_18_0._g_glow_jammer_red:set_visibility(false)
  l_18_0:set_active(false)
  if Network:is_server() then
    l_18_0:_send_net_event(l_18_0._NET_EVENTS.battery_empty)
  end
end

ECMJammerBase.set_battery_low = function(l_19_0)
  if l_19_0._battery_low then
    return 
  end
  l_19_0._battery_life = l_19_0._low_battery_life
  l_19_0:_set_battery_low()
end

ECMJammerBase._set_battery_low = function(l_20_0)
  l_20_0._battery_low = true
  l_20_0._g_glow_jammer_red:set_visibility(true)
  if Network:is_server() then
    l_20_0:_send_net_event(l_20_0._NET_EVENTS.battery_low)
  end
end

ECMJammerBase.sync_set_battery_life = function(l_21_0, l_21_1)
  l_21_0._battery_life = l_21_1
  l_21_0:check_battery()
end

ECMJammerBase._check_body = function(l_22_0)
  if not l_22_0._attached_data then
    return 
  end
  if l_22_0._attached_data.index == 1 and (not alive(l_22_0._attached_data.body) or not l_22_0._attached_data.body:enabled()) then
    l_22_0:_force_remove()
    do return end
    if l_22_0._attached_data.index == 2 and (not alive(l_22_0._attached_data.body) or not mrotation.equal(l_22_0._attached_data.rotation, l_22_0._attached_data.body:rotation())) then
      l_22_0:_force_remove()
      do return end
      if l_22_0._attached_data.index == 3 and (not alive(l_22_0._attached_data.body) or mvector3.not_equal(l_22_0._attached_data.position, l_22_0._attached_data.body:position())) then
        l_22_0:_force_remove()
      end
    end
  end
  l_22_0._attached_data.index = (l_22_0._attached_data.index < l_22_0._attached_data.max_index and l_22_0._attached_data.index or 0) + 1
end

ECMJammerBase.feedback_active = function(l_23_0)
  return l_23_0._feedback_active
end

ECMJammerBase.set_feedback_active = function(l_24_0)
  if not managers.network:session() then
    return 
  end
  if Network:is_client() then
    l_24_0:_send_net_event_to_host(l_24_0._NET_EVENTS.feedback_start)
  else
    l_24_0:_set_feedback_active(true)
  end
end

ECMJammerBase._set_feedback_active = function(l_25_0, l_25_1)
  if l_25_1 then
    l_25_1 = true
  end
  if l_25_1 == l_25_0._feedback_active then
    return 
  end
  if Network:is_server() then
    if l_25_1 then
      l_25_0._unit:interaction():set_active(false, true)
      local t = TimerManager:game():time()
      l_25_0._feedback_clbk_id = "ecm_feedback" .. tostring(l_25_0._unit:key())
      l_25_0._feedback_interval = 1.5
      l_25_0._feedback_range = 1000
      local duration_mul = 1
      if managers.network:game():member_from_unit(l_25_0._owner):peer():id() == 1 then
        duration_mul = duration_mul * managers.player:upgrade_value("ecm_jammer", "feedback_duration_boost", 1)
        duration_mul = duration_mul * managers.player:upgrade_value("ecm_jammer", "feedback_duration_boost_2", 1)
      else
        duration_mul = duration_mul * (l_25_0._owner:base():upgrade_value("ecm_jammer", "feedback_duration_boost") or 1)
        duration_mul = duration_mul * (l_25_0._owner:base():upgrade_value("ecm_jammer", "feedback_duration_boost_2") or 1)
      end
      l_25_0._feedback_duration = math.lerp(15, 20, math.random()) * (duration_mul)
      l_25_0._feedback_expire_t = t + l_25_0._feedback_duration
      local first_impact_t = t + math.lerp(0.10000000149012, 1, math.random())
      managers.enemy:add_delayed_clbk(l_25_0._feedback_clbk_id, callback(l_25_0, l_25_0, "clbk_feedback"), first_impact_t)
      l_25_0:_send_net_event(l_25_0._NET_EVENTS.feedback_start)
    elseif l_25_0._feedback_clbk_id then
      managers.enemy:remove_delayed_clbk(l_25_0._feedback_clbk_id)
      l_25_0._feedback_clbk_id = nil
    end
    l_25_0:_send_net_event(l_25_0._NET_EVENTS.feedback_stop)
  end
  if l_25_1 then
    l_25_0._g_glow_feedback_green:set_visibility(true)
    l_25_0._g_glow_feedback_red:set_visibility(false)
    if not l_25_0._puke_sound_event then
      l_25_0._puke_sound_event = l_25_0._unit:sound_source():post_event("ecm_jammer_puke_signal")
    else
      l_25_0._g_glow_feedback_green:set_visibility(false)
      l_25_0._g_glow_feedback_red:set_visibility(false)
      if l_25_0._puke_sound_event then
        l_25_0._puke_sound_event:stop()
        l_25_0._puke_sound_event = nil
        l_25_0._unit:sound_source():post_event("ecm_jammer_puke_stop")
      end
    end
  end
  l_25_0._feedback_active = l_25_1
end

ECMJammerBase.sync_set_feedback_active = function(l_26_0)
  l_26_0:_set_feedback_active()
end

ECMJammerBase.clbk_feedback = function(l_27_0)
  local t = TimerManager:game():time()
  l_27_0._feedback_clbk_id = "ecm_feedback" .. tostring(l_27_0._unit:key())
  if not managers.groupai:state():enemy_weapons_hot() then
    managers.groupai:state():propagate_alert({"vo_cbt", l_27_0._position, 10000, l_27_0._alert_filter, l_27_0._unit})
  end
  l_27_0._detect_and_give_dmg(l_27_0._position + l_27_0._unit:rotation():y() * 15, l_27_0._unit, l_27_0._owner, l_27_0._feedback_range)
  if l_27_0._feedback_expire_t < t then
    l_27_0._feedback_clbk_id = nil
    l_27_0:_set_feedback_active(false)
  else
    if l_27_0._feedback_expire_t - t < l_27_0._feedback_duration * 0.10000000149012 then
      l_27_0._g_glow_feedback_red:set_visibility(true)
      l_27_0._g_glow_feedback_green:set_visibility(false)
    end
    managers.enemy:add_delayed_clbk(l_27_0._feedback_clbk_id, callback(l_27_0, l_27_0, "clbk_feedback"), t + l_27_0._feedback_interval + math.random() * 0.30000001192093)
  end
end

ECMJammerBase._detect_and_give_dmg = function(l_28_0, l_28_1, l_28_2, l_28_3)
  local mvec3_dis_sq = mvector3.distance_sq
  local slotmask = managers.slot:get_mask("bullet_impact_targets")
   -- DECOMPILER ERROR: No list found. Setlist fails

  local splinters = {}
  local dirs = {}
   -- DECOMPILER ERROR: Overwrote pending register.

  local pos = Vector3(l_28_3, 0, 0)
   -- DECOMPILER ERROR: Overwrote pending register.

   -- DECOMPILER ERROR: Overwrote pending register.

  for _,dir in Vector3(-l_28_3, 0, 0)(Vector3(0, l_28_3, 0)) do
    mvector3.set(pos, dir)
    mvector3.add(pos, l_28_0)
    local splinter_ray = World:raycast("ray", l_28_0, pos, "slot_mask", slotmask)
    local near_splinter = false
    for _,s_pos in ipairs(splinters) do
      if mvector3.distance_sq(pos, s_pos) < 300 then
        do return end
      end
    end
    if not near_splinter then
      table.insert(splinters, mvector3.copy(pos))
    end
  end
  local range_sq = l_28_3 * l_28_3
  local half_range_sq = l_28_3 * 0.5
  local _chk_apply_dmg_to_char = function(l_1_0)
    if not l_1_0.char_tweak.ecm_vulnerability then
      return 
    end
    if l_1_0.char_tweak.ecm_vulnerability <= math.random() then
      return 
    end
    local head_pos = l_1_0.unit:movement():m_head_pos()
    local dis_sq = mvec3_dis_sq(head_pos, hit_pos)
    if range_sq < dis_sq then
      return 
    end
    for i_splinter,s_pos in ipairs(splinters) do
      local ray_hit = World:raycast("ray", s_pos, head_pos, "slot_mask", slotmask, "ignore_unit", l_1_0.unit, "report")
      if not ray_hit and (i_splinter == 1 or dis_sq < half_range_sq) then
        local attack_data = {variant = "stun", damage = 0, attacker_unit = user_unit, weapon_unit = device_unit, col_ray = {position = mvector3.copy(head_pos), ray = head_pos - s_pos:normalized()}}
        l_1_0.unit:character_damage():damage_explosion(attack_data)
    else
      end
    end
   end
  for u_key,u_data in pairs(managers.enemy:all_enemies()) do
    half_range_sq, near_splinter, pos = half_range_sq * half_range_sq, true, (splinter_ray and splinter_ray.position or pos) - dir:normalized() * math.min(splinter_ray and splinter_ray.distance or 0, 10)
    _chk_apply_dmg_to_char(u_data)
  end
  for u_key,u_data in pairs(managers.enemy:all_civilians()) do
    _chk_apply_dmg_to_char(u_data)
  end
end

ECMJammerBase._force_remove = function(l_29_0)
  l_29_0._unit:set_slot(0)
end

ECMJammerBase.save = function(l_30_0, l_30_1)
  local state = {jammer_active = l_30_0._jammer_active or nil, feedback_active = l_30_0._feedback_active or nil, low_battery = l_30_0._battery_low or nil}
  l_30_1.ECMJammerBase = state
end

ECMJammerBase.load = function(l_31_0, l_31_1)
  local state = l_31_1.ECMJammerBase
  if state.jammer_active then
    l_31_0:set_active(true)
    if state.low_battery then
      l_31_0:_set_battery_low()
    else
      l_31_0:_set_battery_empty()
    end
  end
  if state.feedback_active then
    l_31_0:_set_feedback_active(true)
  end
end

ECMJammerBase.destroy = function(l_32_0)
  l_32_0:set_active(false)
  l_32_0:_set_feedback_active(false)
end


