-- Decompiled using luadec 2.0.1 by sztupy (http://winmo.sztupy.hu)
-- Command line was: F:\SteamLibrary\SteamApps\common\PAYDAY 2\lua\lib\units\weapons\shotgun\shotgunbase.luac 

if not ShotgunBase then
  ShotgunBase = class(RaycastWeaponBase)
end
ShotgunBase.init = function(l_1_0, ...)
  ShotgunBase.super.init(l_1_0, ...)
  l_1_0._damage_near = tweak_data.weapon[l_1_0._name_id].damage_near
  l_1_0._damage_far = tweak_data.weapon[l_1_0._name_id].damage_far
  l_1_0._range = l_1_0._damage_far
   -- DECOMPILER ERROR: Confused about usage of registers for local variables.

end

ShotgunBase._create_use_setups = function(l_2_0)
  local use_data = {}
  local player_setup = {}
  player_setup.selection_index = tweak_data.weapon[l_2_0._name_id].use_data.selection_index
  player_setup.equip = {align_place = tweak_data.weapon[l_2_0._name_id].use_data.align_place or "left_hand"}
  player_setup.unequip = {align_place = "back"}
  use_data.player = player_setup
  l_2_0._use_data = use_data
end

local mvec_to = Vector3()
local mvec_spread_direction = Vector3()
ShotgunBase._fire_raycast = function(l_3_0, l_3_1, l_3_2, l_3_3, l_3_4, l_3_5, l_3_6, l_3_7, l_3_8)
  local result = {}
  local hit_enemies = {}
  local hit_something, col_rays = nil, nil
  if l_3_0._alert_events then
    col_rays = {}
  end
  local damage = l_3_0:_get_current_damage(l_3_4)
  local autoaim, dodge_enemies = l_3_0:check_autoaim(l_3_2, l_3_3, l_3_0._range)
  local weight = 0.10000000149012
  local enemy_died = false
  local hit_enemy = function(l_1_0)
    if l_1_0.unit:character_damage() and l_1_0.unit:character_damage().is_head then
      local enemy_key = l_1_0.unit:key()
      if not hit_enemies[enemy_key] or l_1_0.unit:character_damage():is_head(l_1_0.body) then
        hit_enemies[enemy_key] = l_1_0
      else
        InstantBulletBase:on_collision(l_1_0, self._unit, user_unit, damage)
      end
    end
   end
  for i = 1, 6 do
    local spread = l_3_0:_get_spread(l_3_1)
    mvector3.set(mvec_spread_direction, l_3_3)
    if not l_3_6 then
      mvector3.spread(mvec_spread_direction, spread * (not spread or 1))
    end
    mvector3.set(mvec_to, mvec_spread_direction)
    mvector3.multiply(mvec_to, 20000)
    mvector3.add(mvec_to, l_3_2)
    local col_ray = World:raycast("ray", l_3_2, mvec_to, "slot_mask", l_3_0._bullet_slotmask, "ignore_unit", l_3_0._setup.ignore_units)
    if col_rays then
      if col_ray then
        table.insert(col_rays, col_ray)
      else
        local ray_to = mvector3.copy(mvec_to)
        local spread_direction = mvector3.copy(mvec_spread_direction)
        table.insert(col_rays, {position = ray_to, ray = spread_direction})
      end
    end
    if l_3_0._autoaim and autoaim then
      if col_ray and col_ray.unit:in_slot(managers.slot:get_mask("enemies")) then
        l_3_0._autohit_current = (l_3_0._autohit_current + weight) / (1 + weight)
        hit_enemy(col_ray)
        autoaim = false
      else
        autoaim = false
        local autohit = l_3_0:check_autoaim(l_3_2, l_3_3, l_3_0._range)
        if autohit then
          local autohit_chance = 1 - math.clamp((l_3_0._autohit_current - l_3_0._autohit_data.MIN_RATIO) / (l_3_0._autohit_data.MAX_RATIO - l_3_0._autohit_data.MIN_RATIO), 0, 1)
          if math.random() < autohit_chance then
            l_3_0._autohit_current = (l_3_0._autohit_current + weight) / (1 + weight)
            hit_something = true
            hit_enemy(autohit)
          else
            l_3_0._autohit_current = l_3_0._autohit_current / (1 + weight)
          end
        elseif col_ray then
          hit_something = true
          hit_enemy(col_ray)
        elseif col_ray then
          hit_something = true
          hit_enemy(col_ray)
        end
      end
    end
  end
  for _,col_ray in pairs(hit_enemies) do
    local dist = mvector3.distance(col_ray.unit:position(), l_3_1:position())
    damage = (1 - math.min(1, math.max(0, dist - l_3_0._damage_near) / l_3_0._damage_far)) * damage
    local result = InstantBulletBase:on_collision(col_ray, l_3_0._unit, l_3_1, damage)
    if result and result.type == "death" and col_ray.distance < 500 then
      if col_ray.unit:movement()._active_actions[1] and col_ray.unit:movement()._active_actions[1]:type() == "hurt" then
        col_ray.unit:movement()._active_actions[1]:force_ragdoll()
      end
      local scale = math.clamp(1 - col_ray.distance / 500, 0.5, 1)
      local unit = col_ray.unit
      local height = mvector3.distance(col_ray.position, col_ray.unit:position()) - 100
      local twist_dir = math.random(2) == 1 and 1 or -1
      local rot_acc = (col_ray.ray:cross(math.UP) + math.UP * (0.5 * twist_dir)) * (-1000 * math.sign(height))
      local rot_time = 1 + math.rand(2)
      local nr_u_bodies = unit:num_bodies()
      local i_u_body = 0
      repeat
        if i_u_body < nr_u_bodies then
          local u_body = unit:body(i_u_body)
          if u_body:enabled() and u_body:dynamic() then
            local body_mass = u_body:mass()
            World:play_physic_effect(Idstring("physic_effects/shotgun_hit"), u_body, Vector3(col_ray.ray.x, col_ray.ray.y, col_ray.ray.z + 0.5) * 600 * scale, 4 * body_mass / math.random(2), rot_acc, rot_time)
          end
          i_u_body = i_u_body + 1
      end
    end
    if dodge_enemies and l_3_0._suppression then
      for enemy_data,dis_error in pairs(dodge_enemies) do
        enemy_data.unit:character_damage():build_suppression(l_3_8 * dis_error * l_3_0._suppression)
      end
    end
     -- DECOMPILER ERROR: Confused while interpreting a jump as a 'while'

  end
  result.hit_enemy = true
  result.rays = l_3_0._alert_events and ((#col_rays > 0 and col_rays))
  managers.statistics:shot_fired({hit = result.hit_enemy, weapon_unit = l_3_0._unit})
  return result
end

ShotgunBase.reload_expire_t = function(l_4_0)
  local ammo_remaining_in_clip = l_4_0:get_ammo_remaining_in_clip()
  return math.min(l_4_0:get_ammo_total() - ammo_remaining_in_clip, l_4_0:get_ammo_max_per_clip() - ammo_remaining_in_clip) * 20 / 30
end

ShotgunBase.reload_enter_expire_t = function(l_5_0)
  return 0.30000001192093
end

ShotgunBase.reload_exit_expire_t = function(l_6_0)
  return 1.2999999523163
end

ShotgunBase.reload_not_empty_exit_expire_t = function(l_7_0)
  return 1
end

ShotgunBase.start_reload = function(l_8_0, ...)
  ShotgunBase.super.start_reload(l_8_0, ...)
  l_8_0._started_reload_empty = l_8_0:clip_empty()
  do
    local speed_multiplier = l_8_0:reload_speed_multiplier()
    l_8_0._next_shell_reloded_t = Application:time() + 0.33666667342186 / speed_multiplier
  end
   -- DECOMPILER ERROR: Confused about usage of registers for local variables.

end

ShotgunBase.started_reload_empty = function(l_9_0)
  return l_9_0._started_reload_empty
end

ShotgunBase.update_reloading = function(l_10_0, l_10_1, l_10_2, l_10_3)
  if l_10_0._next_shell_reloded_t < l_10_1 then
    local speed_multiplier = l_10_0:reload_speed_multiplier()
    l_10_0._next_shell_reloded_t = l_10_0._next_shell_reloded_t + 0.66666668653488 / speed_multiplier
    l_10_0:set_ammo_remaining_in_clip(math.min(l_10_0:get_ammo_max_per_clip(), l_10_0:get_ammo_remaining_in_clip() + 1))
    return true
  end
end

ShotgunBase.reload_interuptable = function(l_11_0)
  return true
end


