-- Decompiled using luadec 2.0.1 by sztupy (http://winmo.sztupy.hu)
-- Command line was: F:\SteamLibrary\SteamApps\common\PAYDAY 2\lua\lib\units\weapons\grenades\m79grenadebase.luac 

if not M79GrenadeBase then
  M79GrenadeBase = class()
end
M79GrenadeBase.spawn = function(l_1_0, l_1_1, l_1_2)
  local unit = World:spawn_unit(Idstring(l_1_0), l_1_1, l_1_2)
  return unit
end

M79GrenadeBase.init = function(l_2_0, l_2_1)
  l_2_0._unit = l_2_1
  l_2_0._new_pos = l_2_1:position()
  l_2_0._collision_slotmask = managers.slot:get_mask("bullet_impact_targets")
  l_2_0._spawn_pos = l_2_1:position()
  l_2_0._hidden = true
  l_2_0._unit:set_visible(false)
  l_2_0._player_damage = 9
end

M79GrenadeBase.launch = function(l_3_0, l_3_1)
  l_3_0._owner = l_3_1.owner
  l_3_0._user = l_3_1.user
  l_3_0._damage = l_3_1.damage
  l_3_0._range = l_3_1.range
  l_3_0._curve_pow = l_3_1.curve_pow
  l_3_0._velocity = l_3_1.dir * 4000
  l_3_0._last_pos = l_3_0._unit:position()
  l_3_0._last_last_pos = mvector3.copy(l_3_0._last_pos)
  l_3_0._upd_interval = 0.10000000149012
  l_3_0._last_upd_t = TimerManager:game():time()
  l_3_0._next_upd_t = l_3_0._last_upd_t + l_3_0._upd_interval
  l_3_0._auto_explode_t = l_3_0._last_upd_t + 3
end

M79GrenadeBase.update = function(l_4_0, l_4_1, l_4_2, l_4_3)
  if l_4_0._auto_explode_t < l_4_2 then
    l_4_0:_detonate()
    return 
  end
  if l_4_2 < l_4_0._next_upd_t then
    return 
  end
  local dt = l_4_2 - l_4_0._last_upd_t
  mvector3.set(l_4_0._last_last_pos, l_4_0._last_pos)
  mvector3.set(l_4_0._last_pos, l_4_0._new_pos)
  l_4_0:_upd_velocity(dt)
  if l_4_0:_chk_collision() then
    l_4_0:_detonate()
    return 
  end
  l_4_0:_upd_position()
  if l_4_0._hidden then
    local safe_dis_sq = 120
    safe_dis_sq = safe_dis_sq * safe_dis_sq
    if safe_dis_sq < mvector3.distance_sq(l_4_0._spawn_pos, l_4_0._last_pos) then
      l_4_0._hidden = false
      l_4_0._unit:set_visible(true)
    end
  end
  l_4_0._last_upd_t = l_4_2
  l_4_0._next_upd_t = l_4_2 + l_4_0._upd_interval
end

M79GrenadeBase._upd_velocity = function(l_5_0, l_5_1)
  local new_vel_z = mvector3.z(l_5_0._velocity) - l_5_1 * 981
  mvector3.set_z(l_5_0._velocity, new_vel_z)
  mvector3.set(l_5_0._new_pos, l_5_0._velocity)
  mvector3.multiply(l_5_0._new_pos, l_5_1)
  mvector3.add(l_5_0._new_pos, l_5_0._last_pos)
end

M79GrenadeBase._upd_position = function(l_6_0)
  l_6_0._unit:set_position(l_6_0._new_pos)
end

M79GrenadeBase._chk_collision = function(l_7_0)
  local col_ray = World:raycast("ray", l_7_0._last_pos, l_7_0._new_pos, "slot_mask", l_7_0._collision_slotmask)
  if not col_ray then
    col_ray = World:raycast("ray", l_7_0._last_last_pos, l_7_0._new_pos, "slot_mask", l_7_0._collision_slotmask)
  end
  if col_ray then
    l_7_0._col_ray = col_ray
    return true
  end
end

M79GrenadeBase._detonate = function(l_8_0)
  if l_8_0._detonated then
    if alive(l_8_0._unit) then
      debug_pause("[M79GrenadeBase:_detonate] grenade has already detonated", l_8_0._unit, l_8_0._unit:slot())
    end
    if l_8_0._unit:slot() == 0 then
      l_8_0._unit:set_slot(14)
    end
    l_8_0._unit:set_slot(0)
    return 
  end
  l_8_0._detonated = true
  local expl_normal = mvector3.copy(l_8_0._velocity)
  mvector3.negate(expl_normal)
  mvector3.normalize(expl_normal)
  local expl_pos = mvector3.copy(expl_normal)
  mvector3.multiply(expl_pos, 30)
  if l_8_0._col_ray then
    mvector3.add(expl_pos, l_8_0._col_ray.position)
  else
    mvector3.add(expl_pos, l_8_0._new_pos)
  end
  GrenadeBase._play_sound_and_effects(expl_pos, expl_normal, l_8_0._range)
  l_8_0._unit:set_slot(0)
  if not alive(l_8_0._owner) or not alive(l_8_0._user) then
    return 
  end
  GrenadeBase._detect_and_give_dmg(l_8_0, expl_pos)
  managers.network:session():send_to_peers_synched("m79grenade_explode_on_client", expl_pos, expl_normal, l_8_0._user, l_8_0._damage, l_8_0._range, l_8_0._curve_pow)
end


