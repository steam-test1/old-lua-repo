-- Decompiled using luadec 2.0.1 by sztupy (http://winmo.sztupy.hu)
-- Command line was: F:\SteamLibrary\SteamApps\common\PAYDAY 2\lua\lib\units\weapons\grenades\quickflashgrenade.luac 

if not QuickFlashGrenade then
  QuickFlashGrenade = class(QuickSmokeGrenade)
end
QuickFlashGrenade.preemptive_kill = function(l_1_0)
  l_1_0._unit:set_slot(0)
end

QuickFlashGrenade._play_sound_and_effects = function(l_2_0)
  if l_2_0._state == 1 then
    local sound_source = SoundDevice:create_source("grenade_fire_source")
    sound_source:set_position(l_2_0._shoot_position)
    sound_source:post_event("grenade_gas_npc_fire")
  elseif l_2_0._state == 2 then
    local bounce_point = Vector3()
    mvector3.lerp(bounce_point, l_2_0._shoot_position, l_2_0._unit:position(), 0.64999997615814)
    local sound_source = SoundDevice:create_source("grenade_bounce_source")
    sound_source:set_position(bounce_point)
    sound_source:post_event("grenade_gas_bounce")
  elseif l_2_0._state == 3 then
    l_2_0._unit:sound_source():post_event("flashbang_explosion")
    local parent = l_2_0._unit:orientation_object()
    local detonate_pos = l_2_0._unit:position()
    local range = 1000
    local affected, line_of_sight, travel_dis, linear_dis = l_2_0:_chk_dazzle_local_player(detonate_pos, range)
    if affected then
      managers.environment_controller:set_flashbang(detonate_pos, line_of_sight, travel_dis, linear_dis)
      local sound_eff_mul = math.clamp(1 - (travel_dis or linear_dis) / range, 0.30000001192093, 1)
      managers.player:player_unit():character_damage():on_flashbanged(sound_eff_mul)
    end
    managers.groupai:state():propagate_alert({"aggression", detonate_pos, 10000, (managers.groupai:state():get_unit_type_filter("civilians_enemies")), nil})
  end
end

QuickFlashGrenade._chk_dazzle_local_player = function(l_3_0, l_3_1, l_3_2)
  local player = managers.player:player_unit()
  if not alive(player) then
    return 
  end
  if not l_3_1 then
    local detonate_pos = l_3_0._unit:position() + math.UP * 150
  end
  local m_pl_head_pos = player:movement():m_head_pos()
  local linear_dis = mvector3.distance(detonate_pos, m_pl_head_pos)
  if l_3_2 < linear_dis then
    return 
  end
  local slotmask = managers.slot:get_mask("bullet_impact_targets")
  local _vis_ray_func = function(l_1_0, l_1_1, l_1_2)
    return World:raycast("ray", l_1_0, l_1_1, "slot_mask", slotmask, l_1_2 and "report" or nil)
   end
  if not _vis_ray_func(m_pl_head_pos, detonate_pos, true) then
    return true, true, nil, linear_dis
  end
  local random_rotation = Rotation(360 * math.random(), 360 * math.random(), 360 * math.random())
  local raycast_dir = Vector3()
  local bounce_pos = Vector3()
  for _,axis in ipairs({"x", "y", "z"}) do
    for _,polarity in ipairs({1, -1}) do
      mvector3.set_zero(raycast_dir)
      mvector3.set_" .. axi(raycast_dir, polarity)
      mvector3.rotate_with(raycast_dir, random_rotation)
      mvector3.set(bounce_pos, raycast_dir)
      mvector3.multiply(bounce_pos, l_3_2)
      mvector3.add(bounce_pos, detonate_pos)
      local bounce_ray = _vis_ray_func(detonate_pos, bounce_pos)
      if bounce_ray then
        mvector3.set(bounce_pos, raycast_dir)
        mvector3.multiply(bounce_pos, -1 * math.min(bounce_ray.distance, 10))
        mvector3.add(bounce_pos, bounce_ray.position)
        local return_ray = _vis_ray_func(m_pl_head_pos, bounce_pos, true)
        if not return_ray then
          local travel_dis = bounce_ray.distance + mvector3.distance(m_pl_head_pos, bounce_pos)
          if travel_dis < l_3_2 then
            return true, false, travel_dis, linear_dis
          end
        end
      end
    end
  end
end

QuickFlashGrenade.destroy = function(l_4_0)
end


