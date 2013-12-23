-- Decompiled using luadec 2.0.1 by sztupy (http://winmo.sztupy.hu)
-- Command line was: F:\SteamLibrary\SteamApps\common\PAYDAY 2\lua\lib\units\weapons\trip_mine\tripminebase.luac 

if not TripMineBase then
  TripMineBase = class(UnitBase)
end
TripMineBase.spawn = function(l_1_0, l_1_1, l_1_2)
  local unit = World:spawn_unit(Idstring("units/payday2/equipment/gen_equipment_tripmine/gen_equipment_tripmine"), l_1_0, l_1_1)
  managers.network:session():send_to_peers_synched("sync_trip_mine_setup", unit, l_1_2)
  unit:base():setup(l_1_2)
  return unit
end

TripMineBase.set_server_information = function(l_2_0, l_2_1)
  l_2_0._server_information = {owner_peer_id = l_2_1}
  managers.network:game():member(l_2_1):peer():set_used_deployable(true)
end

TripMineBase.server_information = function(l_3_0)
  return l_3_0._server_information
end

TripMineBase.init = function(l_4_0, l_4_1)
  UnitBase.init(l_4_0, l_4_1, false)
  l_4_0._unit = l_4_1
  l_4_0._position = l_4_0._unit:position()
  l_4_0._rotation = l_4_0._unit:rotation()
  l_4_0._forward = l_4_0._rotation:y()
  l_4_0._ray_from_pos = Vector3()
  l_4_0._ray_to_pos = Vector3()
  l_4_0._init_length = 500
  l_4_0._length = l_4_0._init_length
  l_4_0._ids_laser = Idstring("laser")
  l_4_0._g_laser = l_4_0._unit:get_object(Idstring("g_laser"))
  l_4_0._g_laser_sensor = l_4_0._unit:get_object(Idstring("g_laser_sensor"))
  l_4_0._use_draw_laser = SystemInfo:platform() == Idstring("PS3")
  if l_4_0._use_draw_laser then
    l_4_0._laser_color = Color(0.15000000596046, 1, 0, 0)
    l_4_0._laser_sensor_color = Color(0.15000000596046, 0.10000000149012, 0.10000000149012, 1)
    l_4_0._laser_brush = Draw:brush(l_4_0._laser_color)
    l_4_0._laser_brush:set_blend_mode("opacity_add")
  end
end

TripMineBase.get_name_id = function(l_5_0)
  return "trip_mine"
end

TripMineBase.interaction_text_id = function(l_6_0)
  return l_6_0._sensor_upgrade and "hud_int_equipment_sensor_trip_mine" or "debug_interact_trip_mine"
end

TripMineBase.sync_setup = function(l_7_0, l_7_1)
  l_7_0:setup(l_7_1)
end

TripMineBase.setup = function(l_8_0, l_8_1)
  l_8_0._slotmask = managers.slot:get_mask("trip_mine_targets")
  l_8_0._first_armed = false
  l_8_0._armed = false
  l_8_0._sensor_upgrade = l_8_1
  l_8_0:set_active(false)
  l_8_0._unit:sound_source():post_event("trip_mine_attach")
end

TripMineBase.set_active = function(l_9_0, l_9_1, l_9_2)
  l_9_0._active = l_9_1
  if not l_9_0._active then
    l_9_0._unit:set_extension_update_enabled(Idstring("base"), l_9_0._use_draw_laser)
  end
  if l_9_0._active then
    l_9_0._owner = l_9_2
    l_9_0._owner_peer_id = managers.network:session():local_peer():id()
    local from_pos = l_9_0._unit:position() + l_9_0._unit:rotation():y() * 10
    local to_pos = from_pos + l_9_0._unit:rotation():y() * l_9_0._init_length
    local ray = l_9_0._unit:raycast("ray", from_pos, to_pos, "slot_mask", managers.slot:get_mask("world_geometry"))
     -- DECOMPILER ERROR: Confused while interpreting a jump as a 'while'

  end
  l_9_0._length = math.clamp(l_9_0._init_length, 0, l_9_0._init_length)
  l_9_0._unit:anim_set_time(l_9_0._ids_laser, l_9_0._length / l_9_0._init_length)
  l_9_0._activate_timer = 3
  mvector3.set(l_9_0._ray_from_pos, l_9_0._position)
  mvector3.set(l_9_0._ray_to_pos, l_9_0._forward)
  mvector3.multiply(l_9_0._ray_to_pos, l_9_0._length)
  mvector3.add(l_9_0._ray_to_pos, l_9_0._ray_from_pos)
  local from_pos = l_9_0._unit:position() + l_9_0._unit:rotation():y() * 10
  local to_pos = l_9_0._unit:position() + l_9_0._unit:rotation():y() * -10
  local ray = l_9_0._unit:raycast("ray", from_pos, to_pos, "slot_mask", managers.slot:get_mask("world_geometry"))
  if ray then
    l_9_0._attached_data = {}
    l_9_0._attached_data.body = ray.body
    l_9_0._attached_data.position = ray.body:position()
    l_9_0._attached_data.rotation = ray.body:rotation()
    l_9_0._attached_data.index = 1
    l_9_0._attached_data.max_index = 3
  end
  l_9_0._alert_filter = l_9_2:movement():SO_access()
elseif l_9_0._use_draw_laser then
  local from_pos = l_9_0._unit:position() + l_9_0._unit:rotation():y() * 10
  local to_pos = from_pos + l_9_0._unit:rotation():y() * l_9_0._init_length
  local ray = l_9_0._unit:raycast("ray", from_pos, to_pos, "slot_mask", managers.slot:get_mask("world_geometry"))
   -- DECOMPILER ERROR: Confused while interpreting a jump as a 'while'

end
l_9_0._length = math.clamp(l_9_0._init_length, 0, l_9_0._init_length)
mvector3.set(l_9_0._ray_from_pos, l_9_0._position)
mvector3.set(l_9_0._ray_to_pos, l_9_0._forward)
mvector3.multiply(l_9_0._ray_to_pos, l_9_0._length)
mvector3.add(l_9_0._ray_to_pos, l_9_0._ray_from_pos)
end
end

TripMineBase.active = function(l_10_0)
  return l_10_0._active
end

TripMineBase.armed = function(l_11_0)
  return l_11_0._armed
end

TripMineBase._set_armed = function(l_12_0, l_12_1)
  l_12_0._armed = (not l_12_0._activate_timer and l_12_1)
  l_12_0._g_laser:set_visibility(l_12_0._armed)
  if l_12_0._sensor_upgrade then
    l_12_0._g_laser_sensor:set_visibility(not l_12_0._armed)
  end
  if l_12_0._use_draw_laser and (not l_12_0._armed or not l_12_0._laser_color) and (not l_12_0._sensor_upgrade or not l_12_0._laser_sensor_color) then
    l_12_0._laser_brush:set_color(l_12_0._laser_color)
  end
  if not l_12_0._first_armed then
    l_12_0._first_armed = true
    l_12_0._activate_timer = nil
    l_12_0._unit:sound_source():post_event("trip_mine_beep_armed")
  end
  l_12_0._unit:sound_source():post_event(l_12_0._armed and "trip_mine_arm" or "trip_mine_disarm")
end

TripMineBase.set_armed = function(l_13_0, l_13_1)
  if not managers.network:session() then
    return 
  end
  l_13_0:_set_armed(l_13_1)
  if managers.network:session() then
    managers.network:session():send_to_peers_synched("sync_trip_mine_set_armed", l_13_0._unit, l_13_0._armed, l_13_0._length)
  end
end

TripMineBase.sync_trip_mine_set_armed = function(l_14_0, l_14_1, l_14_2)
  l_14_0._length = l_14_2
  l_14_0._unit:anim_set_time(l_14_0._ids_laser, l_14_2 / l_14_0._init_length)
  l_14_0:_set_armed(l_14_1)
end

TripMineBase._update_draw_laser = function(l_15_0)
  if l_15_0._use_draw_laser and l_15_0._first_armed and (l_15_0._armed or l_15_0._sensor_upgrade) then
    l_15_0._laser_brush:cylinder(l_15_0._ray_from_pos, l_15_0._ray_to_pos, 0.5)
  end
end

TripMineBase.update = function(l_16_0, l_16_1, l_16_2, l_16_3)
  l_16_0:_update_draw_laser()
  if not l_16_0._owner then
    return 
  end
  l_16_0:_check_body()
  if l_16_0._explode_timer then
    l_16_0._explode_timer = l_16_0._explode_timer - l_16_3
    if l_16_0._explode_timer <= 0 then
      l_16_0:_explode(l_16_0._explode_ray)
      return 
    end
  end
  if l_16_0._activate_timer then
    l_16_0._activate_timer = l_16_0._activate_timer - l_16_3
    if l_16_0._activate_timer <= 0 then
      l_16_0._activate_timer = nil
      l_16_0:set_armed(true)
    end
    return 
  end
  if l_16_0._deactive_timer then
    l_16_0._deactive_timer = l_16_0._deactive_timer - l_16_3
    if l_16_0._deactive_timer <= 0 then
      l_16_0._deactive_timer = nil
    end
    return 
  end
  if not l_16_0._armed and l_16_0._sensor_upgrade then
    l_16_0:_sensor(l_16_2)
    if l_16_0._sensor_units_detected and l_16_0._sensor_last_unit_time and l_16_0._sensor_last_unit_time < l_16_2 then
      l_16_0._sensor_units_detected = nil
      l_16_0._sensor_last_unit_time = nil
    end
  end
  return 
  if not l_16_0._explode_timer then
    l_16_0:_check()
  end
end

TripMineBase._raycast = function(l_17_0)
  return l_17_0._unit:raycast("ray", l_17_0._ray_from_pos, l_17_0._ray_to_pos, "slot_mask", l_17_0._slotmask, "ray_type", "trip_mine body")
end

TripMineBase._sensor = function(l_18_0, l_18_1)
  local ray = l_18_0:_raycast()
  if ray and ray.unit and not tweak_data.character[ray.unit:base()._tweak_table].is_escort then
    if not l_18_0._sensor_units_detected then
      l_18_0._sensor_units_detected = {}
    end
    if not l_18_0._sensor_units_detected[ray.unit:key()] then
      l_18_0._sensor_units_detected[ray.unit:key()] = true
      l_18_0:_emit_sensor_sound_and_effect()
      if managers.network:session() then
        managers.network:session():send_to_peers_synched("sync_trip_mine_beep_sensor", l_18_0._unit)
      end
      l_18_0._sensor_last_unit_time = l_18_1 + 5
    end
  end
end

TripMineBase.sync_trip_mine_beep_sensor = function(l_19_0)
  l_19_0:_emit_sensor_sound_and_effect()
end

TripMineBase._check_body = function(l_20_0)
  if not l_20_0._attached_data then
    return 
  end
  if l_20_0._attached_data.index == 1 and (not alive(l_20_0._attached_data.body) or not l_20_0._attached_data.body:enabled()) then
    l_20_0:explode()
    do return end
    if l_20_0._attached_data.index == 2 and (not alive(l_20_0._attached_data.body) or not mrotation.equal(l_20_0._attached_data.rotation, l_20_0._attached_data.body:rotation())) then
      l_20_0:explode()
      do return end
      if l_20_0._attached_data.index == 3 and (not alive(l_20_0._attached_data.body) or mvector3.not_equal(l_20_0._attached_data.position, l_20_0._attached_data.body:position())) then
        l_20_0:explode()
      end
    end
  end
  l_20_0._attached_data.index = (l_20_0._attached_data.index < l_20_0._attached_data.max_index and l_20_0._attached_data.index or 0) + 1
end

TripMineBase._check = function(l_21_0)
  if not managers.network:session() then
    return 
  end
  local ray = l_21_0:_raycast()
  if ray and ray.unit and not tweak_data.character[ray.unit:base()._tweak_table].is_escort then
    l_21_0._explode_timer = tweak_data.weapon.trip_mines.delay + managers.player:upgrade_value("trip_mine", "explode_timer_delay", 0)
    l_21_0._explode_ray = ray
    l_21_0._unit:sound_source():post_event("trip_mine_beep_explode")
    if managers.network:session() then
      managers.network:session():send_to_peers_synched("sync_trip_mine_beep_explode", l_21_0._unit)
    end
  end
end

TripMineBase.sync_trip_mine_beep_explode = function(l_22_0)
  l_22_0._unit:sound_source():post_event("trip_mine_beep_explode")
end

TripMineBase.explode = function(l_23_0)
  if not l_23_0._active then
    return 
  end
  l_23_0._active = false
  local col_ray = {}
  col_ray.ray = l_23_0._forward
  col_ray.position = l_23_0._position
  l_23_0:_explode(col_ray)
end

TripMineBase._explode = function(l_24_0, l_24_1)
  if not managers.network:session() then
    return 
  end
  local damage_size = tweak_data.weapon.trip_mines.damage_size * managers.player:upgrade_value("trip_mine", "explosion_size_multiplier", 1) * managers.player:upgrade_value("trip_mine", "damage_multiplier", 1)
  local player = managers.player:player_unit()
  if alive(player) then
    player:character_damage():damage_explosion({position = l_24_0._position, range = damage_size, damage = 6})
  else
    player = nil
  end
  l_24_0._unit:set_extension_update_enabled(Idstring("base"), false)
  l_24_0._deactive_timer = 5
  l_24_0:_play_sound_and_effects()
  local slotmask = managers.slot:get_mask("bullet_impact_targets")
  local bodies = World:find_bodies("intersect", "cylinder", l_24_0._ray_from_pos, l_24_0._ray_to_pos, damage_size, slotmask)
  local damage = tweak_data.weapon.trip_mines.damage * managers.player:upgrade_value("trip_mine", "damage_multiplier", 1)
  local amount = 0
  local characters_hit = {}
  for _,hit_body in ipairs(bodies) do
    if hit_body:unit():character_damage() then
      local character = hit_body:unit():character_damage().damage_explosion
    end
    if hit_body:extension() then
      local apply_dmg = hit_body:extension().damage
    end
    local dir, ray_hit = nil, nil
    if character and not characters_hit[hit_body:unit():key()] then
      local com = hit_body:center_of_mass()
      local ray_from = math.point_on_line(l_24_0._ray_from_pos, l_24_0._ray_to_pos, com)
       -- DECOMPILER ERROR: No list found. Setlist fails

       -- DECOMPILER ERROR: Overwrote pending register.

      ray_hit = not World:raycast("ray", ray_from, com, "slot_mask", slotmask, "ignore_unit", {}, hit_body:unit())
      if ray_hit then
        characters_hit[hit_body:unit():key()] = true
      elseif apply_dmg or hit_body:dynamic() then
        ray_hit = true
      end
    end
    if ray_hit then
      dir = hit_body:center_of_mass()
      mvector3.direction(dir, l_24_0._ray_from_pos, dir)
      if apply_dmg then
        local normal = dir
        hit_body:extension().damage:damage_explosion(player, normal, hit_body:position(), dir, damage)
        hit_body:extension().damage:damage_damage(player, normal, hit_body:position(), dir, damage)
        if hit_body:unit():id() ~= -1 then
          if player then
            managers.network:session():send_to_peers_synched("sync_body_damage_explosion", hit_body, player, normal, hit_body:position(), dir, damage)
          else
            managers.network:session():send_to_peers_synched("sync_body_damage_explosion_no_attacker", hit_body, normal, hit_body:position(), dir, damage)
          end
        end
      end
      if hit_body:unit():in_slot(managers.game_play_central._slotmask_physics_push) then
        hit_body:unit():push(5, dir * 500)
      end
      if character then
        l_24_0:_give_explosion_damage(l_24_1, hit_body:unit(), damage)
        amount = amount + 1
      end
    end
  end
  if amount >= 2 then
    managers.challenges:count_up("dual_tripmine")
  end
  if amount >= 3 then
    managers.challenges:count_up("tris_tripmine")
  end
  if amount >= 4 then
    managers.challenges:count_up("quad_tripmine")
  end
  if managers.network:session() then
    if player then
      managers.network:session():send_to_peers_synched("sync_trip_mine_explode", l_24_0._unit, player, l_24_0._ray_from_pos, l_24_0._ray_to_pos, damage_size, damage)
    else
      managers.network:session():send_to_peers_synched("sync_trip_mine_explode_no_user", l_24_0._unit, l_24_0._ray_from_pos, l_24_0._ray_to_pos, damage_size, damage)
    end
  end
  if Network:is_server() then
    local alert_event = {"aggression", l_24_0._position, tweak_data.weapon.trip_mines.alert_radius, l_24_0._alert_filter, l_24_0._unit}
    managers.groupai:state():propagate_alert(alert_event)
  end
  l_24_0._unit:set_slot(0)
end

TripMineBase.sync_trip_mine_explode = function(l_25_0, l_25_1, l_25_2, l_25_3, l_25_4, l_25_5)
  l_25_0:_play_sound_and_effects()
  l_25_0._unit:set_slot(0)
  local bodies = World:find_bodies("intersect", "cylinder", l_25_2, l_25_3, l_25_4, managers.slot:get_mask("bullet_impact_targets"))
  for _,hit_body in ipairs(bodies) do
    if hit_body:extension() then
      local apply_dmg = hit_body:extension().damage
    end
    local dir = nil
    if apply_dmg or hit_body:dynamic() then
      dir = hit_body:center_of_mass()
      mvector3.direction(dir, l_25_2, dir)
      if apply_dmg then
        local normal = dir
        if hit_body:unit():id() == -1 then
          hit_body:extension().damage:damage_explosion(l_25_1, normal, hit_body:position(), dir, l_25_5)
          hit_body:extension().damage:damage_damage(l_25_1, normal, hit_body:position(), dir, l_25_5)
        end
      end
      if hit_body:unit():in_slot(managers.game_play_central._slotmask_physics_push) then
        hit_body:unit():push(5, dir * 500)
      end
    end
  end
end

TripMineBase._play_sound_and_effects = function(l_26_0)
  World:effect_manager():spawn({effect = Idstring("effects/particles/explosions/explosion_grenade"), position = l_26_0._unit:position(), normal = l_26_0._unit:rotation():y()})
  local sound_source = SoundDevice:create_source("TripMineBase")
  sound_source:set_position(l_26_0._unit:position())
  sound_source:post_event("trip_mine_explode")
  managers.enemy:add_delayed_clbk("TrMiexpl", callback(TripMineBase, TripMineBase, "_dispose_of_sound", {sound_source = sound_source}), TimerManager:game():time() + 2)
end

TripMineBase._emit_sensor_sound_and_effect = function(l_27_0)
  l_27_0._unit:sound_source():post_event("trip_mine_sensor_alarm")
end

TripMineBase._dispose_of_sound = function(...)
   -- DECOMPILER ERROR: Confused about usage of registers for local variables.

end

TripMineBase._give_explosion_damage = function(l_29_0, l_29_1, l_29_2, l_29_3)
  local action_data = {}
  action_data.variant = "explosion"
  action_data.damage = l_29_3
  action_data.weapon_unit = l_29_0._unit
  action_data.attacker_unit = managers.player:player_unit()
  action_data.col_ray = l_29_1
  action_data.owner = managers.player:player_unit()
  action_data.owner_peer_id = l_29_0._owner_peer_id
  local defense_data = l_29_2:character_damage():damage_explosion(action_data)
  return defense_data
end

TripMineBase.save = function(l_30_0, l_30_1)
  local state = {}
  state.armed = l_30_0._armed
  state.length = l_30_0._length
  state.first_armed = l_30_0._first_armed
  state.sensor_upgrade = l_30_0._sensor_upgrade
  state.ray_from_pos = l_30_0._ray_from_pos
  state.ray_to_pos = l_30_0._ray_to_pos
  l_30_1.TripMineBase = state
end

TripMineBase.load = function(l_31_0, l_31_1)
  local state = l_31_1.TripMineBase
  l_31_0._init_length = 500
  l_31_0._first_armed = state.first_armed
  l_31_0._sensor_upgrade = state.sensor_upgrade
  l_31_0._ray_from_pos = state.ray_from_pos
  l_31_0._ray_to_pos = state.ray_to_pos
  if l_31_0._use_draw_laser then
    l_31_0._unit:set_extension_update_enabled(Idstring("base"), l_31_0._use_draw_laser)
  end
  l_31_0:sync_trip_mine_set_armed(state.armed, state.length)
end

TripMineBase._debug_draw = function(l_32_0, l_32_1, l_32_2)
  local brush = Draw:brush(Color.red:with_alpha(0.5))
  brush:cylinder(l_32_1, l_32_2, 1)
end

TripMineBase.destroy = function(l_33_0)
end


