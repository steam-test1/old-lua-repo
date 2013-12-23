-- Decompiled using luadec 2.0.1 by sztupy (http://winmo.sztupy.hu)
-- Command line was: F:\SteamLibrary\SteamApps\common\PAYDAY 2\lua\lib\units\weapons\grenades\grenadebase.luac 

local tmp_vec3 = Vector3()
if not GrenadeBase then
  GrenadeBase = class(UnitBase)
end
GrenadeBase.spawn = function(l_1_0, l_1_1, l_1_2)
  local unit = World:spawn_unit(Idstring(l_1_0), l_1_1, l_1_2)
  return unit
end

GrenadeBase.init = function(l_2_0, l_2_1)
  UnitBase.init(l_2_0, l_2_1, true)
  l_2_0._unit = l_2_1
  l_2_0:_setup()
end

GrenadeBase._setup = function(l_3_0)
  l_3_0._slotmask = managers.slot:get_mask("trip_mine_targets")
  l_3_0._timer = l_3_0._init_timer or 3
end

GrenadeBase.set_active = function(l_4_0, l_4_1)
  l_4_0._active = l_4_1
  l_4_0._unit:set_extension_update_enabled(Idstring("base"), l_4_0._active)
end

GrenadeBase.active = function(l_5_0)
  return l_5_0._active
end

GrenadeBase._detect_and_give_dmg = function(l_6_0, l_6_1)
  local slotmask = l_6_0._collision_slotmask
  local user_unit = l_6_0._user
  local dmg = l_6_0._damage
  local player_dmg = l_6_0._player_damage or dmg
  local range = l_6_0._range
  local player = managers.player:player_unit()
  if alive(player) and player_dmg ~= 0 then
    player:character_damage():damage_explosion({position = l_6_1, range = range, damage = player_dmg})
  end
  local bodies = World:find_bodies("intersect", "sphere", l_6_1, range, slotmask)
  if user_unit then
    managers.groupai:state():propagate_alert({"aggression", l_6_1, 10000, l_6_0._alert_filter, user_unit})
  end
   -- DECOMPILER ERROR: No list found. Setlist fails

  local splinters = {}
  local dirs = {}
   -- DECOMPILER ERROR: Overwrote pending register.

  local pos = Vector3(range, 0, 0)()
   -- DECOMPILER ERROR: Overwrote pending register.

   -- DECOMPILER ERROR: Overwrote pending register.

  for _,dir in Vector3(-range, 0, 0)(Vector3(0, range, 0)) do
    mvector3.set(pos, dir)
    mvector3.add(pos, l_6_1)
    local splinter_ray = World:raycast("ray", l_6_1, pos, "slot_mask", slotmask)
    local near_splinter = false
    for _,s_pos in ipairs(splinters) do
      if mvector3.distance_sq(pos, s_pos) < 900 then
        do return end
      end
    end
    if not near_splinter then
      table.insert(splinters, mvector3.copy(pos))
    end
  end
  local characters_hit = {}
  local units_to_push = {}
  for _,hit_body in ipairs(bodies) do
    near_splinter, pos = true, (splinter_ray and splinter_ray.position or pos) - dir:normalized() * math.min(splinter_ray and splinter_ray.distance or 0, 10)
    if hit_body:unit():character_damage() then
      local character = hit_body:unit():character_damage().damage_explosion
    end
    if hit_body:extension() then
      local apply_dmg = hit_body:extension().damage
    end
    units_to_push[hit_body:unit():key()] = hit_body:unit()
    local dir, len, damage, ray_hit = nil, nil, nil, nil
    if character and not characters_hit[hit_body:unit():key()] then
      for i_splinter,s_pos in ipairs(splinters) do
         -- DECOMPILER ERROR: No list found. Setlist fails

         -- DECOMPILER ERROR: Overwrote pending register.

        ray_hit = not World:raycast("ray", s_pos, hit_body:center_of_mass(), "slot_mask", slotmask, "ignore_unit", {}, hit_body:unit())
        if ray_hit then
          characters_hit[hit_body:unit():key()] = true
      else
        end
      end
    elseif apply_dmg or hit_body:dynamic() then
      ray_hit = true
    end
  end
  if ray_hit then
    dir = hit_body:center_of_mass()
    len = mvector3.direction(dir, l_6_1, dir)
    damage = dmg * math.pow(math.clamp(1 - len / range, 0, 1), l_6_0._curve_pow)
    damage = math.max(damage, 1)
    local hit_unit = hit_body:unit()
    if apply_dmg then
      local normal = dir
      hit_body:extension().damage:damage_explosion(user_unit, normal, hit_body:position(), dir, damage)
      hit_body:extension().damage:damage_damage(user_unit, normal, hit_body:position(), dir, damage)
      if hit_unit:id() ~= -1 then
        if alive(user_unit) then
          managers.network:session():send_to_peers_synched("sync_body_damage_explosion", hit_body, user_unit, normal, hit_body:position(), dir, damage)
        else
          managers.network:session():send_to_peers_synched("sync_body_damage_explosion_no_attacker", hit_body, normal, hit_body:position(), dir, damage)
        end
      end
    end
    if character then
      local action_data = {}
      action_data.variant = "explosion"
      action_data.damage = damage
      action_data.attacker_unit = user_unit
      action_data.weapon_unit = l_6_0._owner
      if not l_6_0._col_ray then
        action_data.col_ray = {position = hit_body:position(), ray = dir}
      end
      hit_unit:character_damage():damage_explosion(action_data)
    end
  end
end
GrenadeBase._units_to_push(units_to_push, l_6_1, range)
if l_6_0._owner then
  managers.challenges:reset_counter("m79_law_simultaneous_kills")
  managers.challenges:reset_counter("m79_simultaneous_specials")
   -- DECOMPILER ERROR: Confused while interpreting a jump as a 'while'

end
managers.statistics:shot_fired({hit = true, weapon_unit = l_6_0._owner})
end
end

GrenadeBase._units_to_push = function(l_7_0, l_7_1, l_7_2)
  for u_key,unit in pairs(l_7_0) do
    if alive(unit) then
      if unit:character_damage() then
        local is_character = unit:character_damage().damage_explosion
      end
      if not is_character or unit:character_damage():dead() then
        if is_character and unit:movement()._active_actions[1] and unit:movement()._active_actions[1]:type() == "hurt" then
          unit:movement()._active_actions[1]:force_ragdoll()
        end
        local nr_u_bodies = unit:num_bodies()
        local i_u_body = 0
        repeat
          if i_u_body < nr_u_bodies then
            local u_body = unit:body(i_u_body)
            if u_body:enabled() and u_body:dynamic() then
              local body_mass = u_body:mass()
              local len = mvector3.direction(tmp_vec3, l_7_1, u_body:center_of_mass())
              local body_vel = u_body:velocity()
              local vel_dot = mvector3.dot(body_vel, tmp_vec3)
              local max_vel = 800
              if vel_dot < max_vel then
                local push_vel = (1 - len / l_7_2) * (max_vel - math.max(vel_dot, 0))
                mvector3.multiply(tmp_vec3, push_vel)
                u_body:push_at(body_mass / math.random(2), tmp_vec3, u_body:position())
              end
            end
            i_u_body = i_u_body + 1
        end
      end
    end
     -- Warning: missing end command somewhere! Added here
  end
end

GrenadeBase._explode_on_client = function(l_8_0, l_8_1, l_8_2, l_8_3, l_8_4, l_8_5)
  GrenadeBase._play_sound_and_effects(l_8_0, l_8_1, l_8_4)
  GrenadeBase._client_damage_and_push(l_8_0, l_8_1, l_8_2, l_8_3, l_8_4, l_8_5)
end

GrenadeBase._client_damage_and_push = function(l_9_0, l_9_1, l_9_2, l_9_3, l_9_4, l_9_5)
  local bodies = World:find_bodies("intersect", "sphere", l_9_0, l_9_4, managers.slot:get_mask("bullet_impact_targets"))
  local units_to_push = {}
  for _,hit_body in ipairs(bodies) do
    units_to_push[hit_body:unit():key()] = hit_body:unit()
    local apply_dmg = not hit_body:extension() or not hit_body:extension().damage or hit_body:unit():id() == -1
    local dir, len, damage = nil, nil, nil
    if apply_dmg then
      dir = hit_body:center_of_mass()
      len = mvector3.direction(dir, l_9_0, dir)
      damage = l_9_3 * math.pow(math.clamp(1 - len / l_9_4, 0, 1), l_9_5)
      damage = math.max(damage, 1)
      local normal = dir
      hit_body:extension().damage:damage_explosion(l_9_2, normal, hit_body:position(), dir, damage)
      hit_body:extension().damage:damage_damage(l_9_2, normal, hit_body:position(), dir, damage)
    end
  end
  GrenadeBase._units_to_push(units_to_push, l_9_0, l_9_4)
end

GrenadeBase._play_sound_and_effects = function(l_10_0, l_10_1, l_10_2)
  GrenadeBase._player_feedback(l_10_0, l_10_1, l_10_2)
  GrenadeBase._spawn_sound_and_effects(l_10_0, l_10_1, l_10_2)
end

GrenadeBase._player_feedback = function(l_11_0, l_11_1, l_11_2)
  local player = managers.player:player_unit()
  if player then
    local feedback = managers.feedback:create("mission_triggered")
    local distance = mvector3.distance_sq(l_11_0, player:position())
    local mul = math.clamp(1 - distance / (l_11_2 * l_11_2), 0, 1)
    feedback:set_unit(player)
    feedback:set_enabled("camera_shake", true)
    feedback:set_enabled("rumble", true)
    feedback:set_enabled("above_camera_effect", false)
    local params = {"camera_shake", "multiplier", mul, "camera_shake", "amplitude", 0.5, "camera_shake", "attack", 0.050000000745058, "camera_shake", "sustain", 0.15000000596046, "camera_shake", "decay", 0.5, "rumble", "multiplier_data", mul, "rumble", "peak", 0.5, "rumble", "attack", 0.050000000745058, "rumble", "sustain", 0.15000000596046, "rumble", "release", 0.5}
    feedback:play(unpack(params))
  end
end

GrenadeBase._spawn_sound_and_effects = function(l_12_0, l_12_1, l_12_2, l_12_3)
  if not l_12_3 then
    l_12_3 = "effects/particles/explosions/explosion_grenade_launcher"
  end
  if l_12_3 ~= "none" then
    World:effect_manager():spawn({effect = Idstring(l_12_3), position = l_12_0, normal = l_12_1})
  end
  local sound_source = SoundDevice:create_source("M79GrenadeBase")
  sound_source:set_position(l_12_0)
  sound_source:post_event("trip_mine_explode")
  managers.enemy:add_delayed_clbk("M79expl", callback(GrenadeBase, GrenadeBase, "_dispose_of_sound", {sound_source = sound_source}), TimerManager:game():time() + 2)
end

GrenadeBase._dispose_of_sound = function(...)
   -- DECOMPILER ERROR: Confused about usage of registers for local variables.

end

GrenadeBase.throw = function(l_14_0, l_14_1)
  l_14_0._owner = l_14_1.owner
  local velocity = l_14_1.dir * 1000
  velocity = Vector3(velocity.x, velocity.y, velocity.z + 100)
  local mass = math.max(2 * (1 - math.abs(l_14_1.dir.z)), 1)
  l_14_0._unit:push_at(mass, velocity, l_14_0._unit:position())
end

GrenadeBase._bounce = function(l_15_0, ...)
  print("_bounce", ...)
   -- DECOMPILER ERROR: Confused about usage of registers for local variables.

end

GrenadeBase.update = function(l_16_0, l_16_1, l_16_2, l_16_3)
  if l_16_0._timer then
    l_16_0._timer = l_16_0._timer - l_16_3
    if l_16_0._timer <= 0 then
      l_16_0._timer = nil
      l_16_0:__detonate()
    end
  end
end

GrenadeBase.detonate = function(l_17_0)
  if not l_17_0._active then
    return 
  end
end

GrenadeBase.__detonate = function(l_18_0)
  if not l_18_0._owner then
    return 
  end
  l_18_0:_detonate()
end

GrenadeBase._detonate = function(l_19_0)
  print("no detonate function for grenade")
end

GrenadeBase.save = function(l_20_0, l_20_1)
  local state = {}
  state.timer = l_20_0._timer
  l_20_1.GrenadeBase = state
end

GrenadeBase.load = function(l_21_0, l_21_1)
  local state = l_21_1.GrenadeBase
  l_21_0._timer = state.timer
end

GrenadeBase.destroy = function(l_22_0)
end


