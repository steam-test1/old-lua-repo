-- Decompiled using luadec 2.0.1 by sztupy (http://winmo.sztupy.hu)
-- Command line was: F:\SteamLibrary\SteamApps\common\PAYDAY 2\lua\lib\units\enemies\cop\actions\upper_body\copactionshoot.luac 

local mvec3_set = mvector3.set
local mvec3_set_z = mvector3.set_z
local mvec3_sub = mvector3.subtract
local mvec3_norm = mvector3.normalize
local mvec3_dir = mvector3.direction
local mvec3_set_l = mvector3.set_length
local mvec3_add = mvector3.add
local mvec3_dot = mvector3.dot
local mvec3_cross = mvector3.cross
local mvec3_rot = mvector3.rotate_with
local mvec3_rand_orth = mvector3.random_orthogonal
local mvec3_lerp = mvector3.lerp
local mrot_axis_angle = mrotation.set_axis_angle
local temp_vec1 = Vector3()
local temp_vec2 = Vector3()
local temp_vec3 = Vector3()
local temp_rot1 = Rotation()
local bezier_curve = {0, 0, 1, 1}
if not CopActionShoot then
  CopActionShoot = class()
end
CopActionShoot._ik_presets = {spine = {start = "_begin_ik_spine", stop = "_stop_ik_spine", update = "_update_ik_spine", get_blend = "_get_blend_ik_spine"}, r_arm = {start = "_begin_ik_r_arm", stop = "_stop_ik_r_arm", update = "_update_ik_r_arm", get_blend = "_get_blend_ik_r_arm"}}
CopActionShoot.init = function(l_1_0, l_1_1, l_1_2)
  l_1_0._common_data = l_1_2
  local t = TimerManager:game():time()
  l_1_0._ext_movement = l_1_2.ext_movement
  l_1_0._ext_anim = l_1_2.ext_anim
  l_1_0._ext_brain = l_1_2.ext_brain
  l_1_0._ext_inventory = l_1_2.ext_inventory
  l_1_0._ext_base = l_1_2.ext_base
  l_1_0._body_part = l_1_1.body_part
  l_1_0._machine = l_1_2.machine
  l_1_0._unit = l_1_2.unit
  local preset_name = l_1_0._ext_anim.base_aim_ik or "spine"
  local preset_data = l_1_0._ik_presets[preset_name]
  l_1_0._ik_preset = preset_data
  l_1_0[preset_data.start](l_1_0)
  local weapon_unit = l_1_0._ext_inventory:equipped_unit()
  local weap_tweak = weapon_unit:base():weapon_tweak_data()
  local weapon_usage_tweak = l_1_2.char_tweak.weapon[weap_tweak.usage]
  l_1_0._weapon_unit = weapon_unit
  l_1_0._weapon_base = weapon_unit:base()
  l_1_0._weap_tweak = weap_tweak
  l_1_0._w_usage_tweak = weapon_usage_tweak
  l_1_0._reload_speed = weapon_usage_tweak.RELOAD_SPEED
  l_1_0._spread = weapon_usage_tweak.spread
  l_1_0._falloff = weapon_usage_tweak.FALLOFF
  l_1_0._variant = l_1_1.variant
  l_1_0._body_part = l_1_1.body_part
  l_1_0._turn_allowed = Network:is_client()
  l_1_0._automatic_weap = not weap_tweak.auto or true
  l_1_0._shoot_t = 0
  l_1_0._melee_timeout_t = t + 1
  local aim_delay = weapon_usage_tweak.aim_delay
  local shoot_from_pos = l_1_0._ext_movement:m_head_pos()
  l_1_0._shoot_from_pos = shoot_from_pos
  l_1_0:on_attention(l_1_2.attention)
  if Network:is_server() then
    l_1_0._ext_movement:set_stance_by_code(3)
  end
  CopActionAct._create_blocks_table(l_1_0, l_1_1.blocks)
  if Network:is_server() then
    l_1_2.ext_network:send("action_aim_start")
  end
  l_1_0._skipped_frames = 1
  return true
end

CopActionShoot.on_inventory_event = function(l_2_0, l_2_1)
  if l_2_0._weapon_unit and l_2_0._autofiring then
    l_2_0._weapon_base:stop_autofire()
    if l_2_0._ext_anim.recoil then
      l_2_0._ext_movement:play_redirect("up_idle")
    end
  end
  local weapon_unit = l_2_0._ext_inventory:equipped_unit()
  l_2_0._weapon_unit = weapon_unit
  if weapon_unit then
    local weap_tweak = weapon_unit:base():weapon_tweak_data()
    local weapon_usage_tweak = l_2_0._common_data.char_tweak.weapon[weap_tweak.usage]
    l_2_0._weapon_base = weapon_unit:base()
    l_2_0._weap_tweak = weap_tweak
    l_2_0._w_usage_tweak = weapon_usage_tweak
    l_2_0._reload_speed = weapon_usage_tweak.RELOAD_SPEED
    l_2_0._spread = weapon_usage_tweak.spread
    l_2_0._falloff = weapon_usage_tweak.FALLOFF
    l_2_0._automatic_weap = not weap_tweak.auto or true
  else
    l_2_0._weapon_base = nil
    l_2_0._weap_tweak = nil
    l_2_0._w_usage_tweak = nil
    l_2_0._reload_speed = nil
    l_2_0._spread = nil
    l_2_0._falloff = nil
    l_2_0._automatic_weap = nil
  end
  l_2_0._autofiring = nil
  l_2_0._autoshots_fired = nil
  if l_2_0._weapon_unit then
    l_2_0.update = nil
  else
    l_2_0.update = l_2_0._upd_empty()
  end
end

CopActionShoot.on_attention = function(l_3_0, l_3_1, l_3_2)
  if l_3_0._shooting_player and l_3_2 and alive(l_3_2.unit) then
    l_3_2.unit:movement():on_targetted_for_attack(false, l_3_0._common_data.unit)
  end
  l_3_0._shooting_player = nil
  l_3_0._shooting_husk_player = nil
  l_3_0._next_vis_ray_t = nil
  if l_3_1 then
    l_3_0[l_3_0._ik_preset.start](l_3_0)
    local vis_state = l_3_0._ext_base:lod_stage()
    if vis_state and vis_state < 3 and l_3_0[l_3_0._ik_preset.get_blend](l_3_0) > 0 then
      local t = TimerManager:game():time()
      l_3_0._aim_transition = {start_t = t, duration = 0.33300000429153, start_vec = mvector3.copy(l_3_0._common_data.look_vec)}
      l_3_0._get_target_pos = l_3_0._get_transition_target_pos
    else
      l_3_0._aim_transition = nil
      l_3_0._get_target_pos = nil
    end
    l_3_0._mod_enable_t = TimerManager:game():time() + 0.5
    if l_3_1.unit then
      if l_3_1.unit:base() then
        l_3_0._shooting_player = l_3_1.unit:base().is_local_player
      end
      if Network:is_client() then
        if l_3_1.unit:base() then
          l_3_0._shooting_husk_player = l_3_1.unit:base().is_husk_player
        end
        if l_3_0._shooting_husk_player then
          l_3_0._next_vis_ray_t = TimerManager:game():time()
        end
      end
      if l_3_0._shooting_player or l_3_0._shooting_husk_player then
        l_3_0._verif_slotmask = managers.slot:get_mask("AI_visibility")
        l_3_0._line_of_sight_t = -100
        if l_3_0._shooting_player then
          l_3_1.unit:movement():on_targetted_for_attack(true, l_3_0._common_data.unit)
        else
          l_3_0._verif_slotmask = nil
        end
      end
      local usage_tweak = l_3_0._w_usage_tweak
      if not l_3_1.handler or not l_3_1.handler:get_attention_m_pos() then
        local target_pos = l_3_1.unit:movement():m_head_pos()
      end
      local focus_error_roll = math.random(360)
      local shoot_hist = l_3_0._shoot_history
      if shoot_hist then
        shoot_hist.focus_error_roll = focus_error_roll
        local displacement = mvector3.distance(target_pos, shoot_hist.m_last_pos)
        local focus_delay = usage_tweak.focus_delay * math.min(1, displacement / usage_tweak.focus_dis)
        shoot_hist.focus_start_t = TimerManager:game():time()
        shoot_hist.focus_delay = focus_delay
        shoot_hist.m_last_pos = mvector3.copy(target_pos)
      else
        shoot_hist = {focus_error_roll = focus_error_roll, focus_start_t = TimerManager:game():time(), focus_delay = usage_tweak.focus_delay, m_last_pos = mvector3.copy(target_pos)}
        l_3_0._shoot_history = shoot_hist
      end
    else
      l_3_0[l_3_0._ik_preset.stop](l_3_0)
      if l_3_0._aim_transition then
        l_3_0._aim_transition = nil
        l_3_0._get_target_pos = nil
      end
    end
  end
end
l_3_0._attention = l_3_1
end

CopActionShoot.save = function(l_4_0, l_4_1)
  l_4_1.type = "shoot"
  l_4_1.body_part = 3
end

CopActionShoot.get_husk_interrupt_desc = function(l_5_0)
  local desc = {type = "shoot", body_part = 3}
  return desc
end

CopActionShoot.on_exit = function(l_6_0)
  if Network:is_server() then
    l_6_0._ext_movement:set_stance("hos")
  end
  if l_6_0._modifier_on then
    l_6_0[l_6_0._ik_preset.stop](l_6_0)
  end
  if l_6_0._autofiring then
    l_6_0._weapon_base:stop_autofire()
  end
  if l_6_0._ext_anim.recoil then
    l_6_0._ext_movement:play_redirect("up_idle")
  end
  if Network:is_server() then
    l_6_0._common_data.unit:network():send("action_aim_end")
  end
  if l_6_0._shooting_player and alive(l_6_0._attention.unit) then
    l_6_0._attention.unit:movement():on_targetted_for_attack(false, l_6_0._common_data.unit)
  end
end

CopActionShoot.update = function(l_7_0, l_7_1)
  local vis_state = l_7_0._ext_base:lod_stage()
  if not vis_state then
    vis_state = 4
  end
  if vis_state == 1 then
    do return end
  end
  if l_7_0._skipped_frames < vis_state * 3 then
    l_7_0._skipped_frames = l_7_0._skipped_frames + 1
    return 
  else
    l_7_0._skipped_frames = 1
  end
  local shoot_from_pos = l_7_0._shoot_from_pos
  local ext_anim = l_7_0._ext_anim
  local target_vec, target_dis, autotarget, target_pos = nil, nil, nil, nil
  if l_7_0._attention then
    target_pos, target_vec, target_dis, autotarget = l_7_0:_get_target_pos(shoot_from_pos, l_7_0._attention, l_7_1)
    local tar_vec_flat = temp_vec2
    mvec3_set(tar_vec_flat, target_vec)
    mvec3_set_z(tar_vec_flat, 0)
    mvec3_norm(tar_vec_flat)
    local fwd = l_7_0._common_data.fwd
    local fwd_dot = mvec3_dot(fwd, tar_vec_flat)
    if l_7_0._turn_allowed then
      local active_actions = l_7_0._common_data.active_actions
      local queued_actions = l_7_0._common_data.queued_actions
      if ((active_actions[2] and active_actions[2]:type() ~= "idle") or (queued_actions and not queued_actions[1] and queued_actions[2]) or not l_7_0._ext_movement:chk_action_forbidden("walk")) then
        local fwd_dot_flat = mvec3_dot(tar_vec_flat, fwd)
        if fwd_dot_flat < 0.95999997854233 then
          local spin = tar_vec_flat:to_polar_with_reference(fwd, math.UP).spin
          local new_action_data = {type = "turn", body_part = 2, angle = spin}
          l_7_0._ext_movement:action_request(new_action_data)
        end
      end
    end
    target_vec = l_7_0:_upd_ik(target_vec, fwd_dot, l_7_1)
  end
  if not ext_anim.reload and not ext_anim.equip and not ext_anim.melee then
    if ext_anim.equip then
      do return end
    end
    if l_7_0._weapon_base:clip_empty() then
      if l_7_0._autofiring then
        l_7_0._weapon_base:stop_autofire()
        if ext_anim.recoil then
          l_7_0._ext_movement:play_redirect("up_idle")
        end
        l_7_0._autofiring = nil
        l_7_0._autoshots_fired = nil
      end
      if not ext_anim.recoil then
        if l_7_0._ext_anim.base_no_reload then
          l_7_0._weapon_unit:base():on_reload()
        else
          local res = CopActionReload._play_reload(l_7_0)
          if res then
            l_7_0._machine:set_speed(res, l_7_0._reload_speed)
          elseif l_7_0._autofiring then
            if not target_vec or not l_7_0._common_data.allow_fire then
              l_7_0._weapon_base:stop_autofire()
              l_7_0._shoot_t = l_7_1 + 0.60000002384186
              l_7_0._autofiring = nil
              l_7_0._autoshots_fired = nil
              if ext_anim.recoil then
                l_7_0._ext_movement:play_redirect("up_idle")
              else
                local spread = l_7_0._spread
                local falloff, i_range = l_7_0:_get_shoot_falloff(target_dis, l_7_0._falloff)
                if l_7_0._shoot_history then
                  local new_target_pos = l_7_0:_get_unit_shoot_pos(l_7_1, target_pos, target_dis, l_7_0._w_usage_tweak, falloff, i_range, autotarget)
                end
                if new_target_pos then
                  target_pos = new_target_pos
                else
                  spread = math.min(20, spread)
                end
                local spread_pos = temp_vec2
                mvec3_rand_orth(spread_pos, target_vec)
                mvec3_set_l(spread_pos, spread)
                mvec3_add(spread_pos, target_pos)
                target_dis = mvec3_dir(target_vec, shoot_from_pos, spread_pos)
                local fired = l_7_0._weapon_base:trigger_held(shoot_from_pos, target_vec, falloff.dmg_mul, l_7_0._shooting_player, nil, nil, nil, l_7_0._attention.unit)
                if fired then
                  if not ext_anim.recoil and vis_state == 1 and not ext_anim.base_no_recoil then
                    l_7_0._ext_movement:play_redirect("recoil_auto")
                  end
                  if not l_7_0._autofiring or l_7_0._autoshots_fired == l_7_0._autofiring - 1 then
                    l_7_0._autofiring = nil
                    l_7_0._autoshots_fired = nil
                    l_7_0._weapon_base:stop_autofire()
                    if ext_anim.recoil then
                      l_7_0._ext_movement:play_redirect("up_idle")
                    end
                     -- DECOMPILER ERROR: Confused while interpreting a jump as a 'while'

                  end
                  l_7_0._shoot_t = l_7_1 + (vis_state ~= 1 or 1) * math.lerp(falloff.recoil[1], falloff.recoil[2], math.random())
                  do return end
                  l_7_0._shoot_t = l_7_1 + falloff.recoil[2]
                else
                  l_7_0._autoshots_fired = l_7_0._autoshots_fired + 1
                end
              elseif target_vec and l_7_0._common_data.allow_fire and l_7_0._shoot_t < l_7_1 and l_7_0._mod_enable_t < l_7_1 then
                local shoot = nil
                if autotarget or l_7_0._shooting_husk_player and l_7_0._next_vis_ray_t < l_7_1 then
                  if l_7_0._shooting_husk_player then
                    l_7_0._next_vis_ray_t = l_7_1 + 2
                  end
                  local fire_line = World:raycast("ray", shoot_from_pos, target_pos, "slot_mask", l_7_0._verif_slotmask, "ray_type", "ai_vision")
                  if fire_line then
                    if l_7_1 - l_7_0._line_of_sight_t > 3 then
                      local aim_delay_minmax = l_7_0._w_usage_tweak.aim_delay
                      local lerp_dis = math.min(1, target_vec:length() / l_7_0._falloff[#l_7_0._falloff].r)
                      local aim_delay = math.lerp(aim_delay_minmax[1], aim_delay_minmax[2], lerp_dis)
                      aim_delay = aim_delay + math.random() * aim_delay * 0.30000001192093
                      if l_7_0._common_data.is_suppressed then
                        aim_delay = (aim_delay) * 1.5
                      end
                      l_7_0._shoot_t = l_7_1 + aim_delay
                    elseif fire_line.distance > 300 then
                      shoot = true
                    else
                      if l_7_1 - l_7_0._line_of_sight_t > 1 and not l_7_0._last_vis_check_status then
                        local shoot_hist = l_7_0._shoot_history
                        local displacement = mvector3.distance(target_pos, shoot_hist.m_last_pos)
                        local focus_delay = l_7_0._w_usage_tweak.focus_delay * math.min(1, displacement / l_7_0._w_usage_tweak.focus_dis)
                        shoot_hist.focus_start_t = l_7_1
                        shoot_hist.focus_delay = focus_delay
                        shoot_hist.m_last_pos = mvector3.copy(target_pos)
                      end
                      l_7_0._line_of_sight_t = l_7_1
                      shoot = true
                    end
                  end
                  l_7_0._last_vis_check_status = shoot
                elseif l_7_0._shooting_husk_player then
                  shoot = l_7_0._last_vis_check_status
                else
                  shoot = true
                end
                if shoot then
                  local melee = nil
                  if autotarget and target_dis < 130 and l_7_0._w_usage_tweak.melee_speed and l_7_0._melee_timeout_t < l_7_1 then
                    melee = l_7_0:_chk_start_melee(target_vec, target_dis, autotarget, target_pos)
                  end
                  if not melee then
                    local falloff, i_range = l_7_0:_get_shoot_falloff(target_dis, l_7_0._falloff)
                    local firemode = nil
                    if l_7_0._automatic_weap then
                      local random_mode = math.random()
                      for i_mode,mode_chance in ipairs(falloff.mode) do
                        if random_mode <= mode_chance then
                          firemode = i_mode
                      else
                        end
                      end
                    else
                      firemode = 1
                    end
                  end
                  l_7_0._weapon_base:start_autofire((firemode < 4 and firemode))
                  if firemode >= 4 or not firemode then
                    l_7_0._autofiring = 5 + math.random(6)
                  end
                  l_7_0._autoshots_fired = 0
                  if vis_state == 1 and not ext_anim.base_no_recoil then
                    l_7_0._ext_movement:play_redirect("recoil_auto")
                    do return end
                    local spread = l_7_0._spread
                    if autotarget then
                      if l_7_0._shoot_history then
                        local new_target_pos = l_7_0:_get_unit_shoot_pos(l_7_1, target_pos, target_dis, l_7_0._w_usage_tweak, falloff, i_range, autotarget)
                      end
                      if new_target_pos then
                        target_pos = new_target_pos
                      else
                        spread = math.min(20, spread)
                      end
                    end
                    local spread_pos = temp_vec2
                    mvec3_rand_orth(spread_pos, target_vec)
                    mvec3_set_l(spread_pos, spread)
                    mvec3_add(spread_pos, target_pos)
                    target_dis = mvec3_dir(target_vec, shoot_from_pos, spread_pos)
                    l_7_0._weapon_base:singleshot(shoot_from_pos, target_vec, falloff.dmg_mul, l_7_0._shooting_player, nil, nil, nil, l_7_0._attention.unit)
                    if vis_state == 1 then
                      if not ext_anim.base_no_recoil then
                        l_7_0._ext_movement:play_redirect("recoil_single")
                      end
                      l_7_0._shoot_t = l_7_1 + (l_7_0._common_data.is_suppressed and 1.5 or 1) * math.lerp(falloff.recoil[1], falloff.recoil[2], math.random())
                    else
                      l_7_0._shoot_t = l_7_1 + falloff.recoil[2]
                    end
                  end
                end
              end
            end
          end
        end
      end
    end
  end
end
end
if l_7_0._ext_anim.base_need_upd then
l_7_0._ext_movement:upd_m_head_pos()
end
end

CopActionShoot._upd_empty = function(l_8_0, l_8_1)
end

CopActionShoot.type = function(l_9_0)
  return "shoot"
end

CopActionShoot._get_shoot_falloff = function(l_10_0, l_10_1, l_10_2)
  for i_range,range_data in ipairs(l_10_2) do
    if l_10_1 < range_data.r then
      return range_data, i_range
    end
  end
  return l_10_2[#l_10_2], #l_10_2
end

CopActionShoot._get_unit_shoot_pos = function(l_11_0, l_11_1, l_11_2, l_11_3, l_11_4, l_11_5, l_11_6, l_11_7)
  local shoot_hist = l_11_0._shoot_history
  local focus_delay, focus_prog = nil, nil
  if not l_11_7 or not l_11_0._attention.unit:character_damage():focus_delay_mul() then
    focus_delay = (not shoot_hist.focus_delay or 1) * shoot_hist.focus_delay
    if focus_delay > 0 then
      focus_prog = (l_11_1 - shoot_hist.focus_start_t) / (focus_delay)
    else
      focus_prog = false
    end
    if not focus_prog or focus_prog >= 1 then
      shoot_hist.focus_delay = nil
      focus_prog = 1
      do return end
      focus_prog = 1
    end
    local dis_lerp = nil
    local hit_chances = l_11_5.acc
    local hit_chance = nil
    if l_11_6 == 1 then
      dis_lerp = l_11_3 / l_11_5.r
      hit_chance = math.lerp(hit_chances[1], hit_chances[2], focus_prog)
    else
      local prev_falloff = l_11_4.FALLOFF[l_11_6 - 1]
      dis_lerp = math.min(1, (l_11_3 - prev_falloff.r) / (l_11_5.r - prev_falloff.r))
      local prev_range_hit_chance = math.lerp(prev_falloff.acc[1], prev_falloff.acc[2], focus_prog)
      hit_chance = math.lerp(prev_range_hit_chance, math.lerp(hit_chances[1], hit_chances[2], focus_prog), dis_lerp)
    end
    if l_11_0._common_data.is_suppressed then
      hit_chance = hit_chance * 0.5
    end
    if math.random() < hit_chance then
      mvec3_set(shoot_hist.m_last_pos, l_11_2)
    else
      local enemy_vec = temp_vec2
      mvec3_set(enemy_vec, l_11_2)
      mvec3_sub(enemy_vec, l_11_0._common_data.pos)
      local error_vec = Vector3()
      mvec3_cross(error_vec, enemy_vec, math.UP)
      mrot_axis_angle(temp_rot1, enemy_vec, shoot_hist.focus_error_roll)
      mvec3_rot(error_vec, temp_rot1)
      local miss_min_dis = l_11_7 and 31 or 150
      local error_vec_len = miss_min_dis + l_11_4.spread + l_11_4.miss_dis * (1 - focus_prog)
      mvec3_set_l(error_vec, error_vec_len)
      mvec3_add(error_vec, l_11_2)
      mvec3_set(shoot_hist.m_last_pos, error_vec)
      return error_vec
    end
     -- Warning: missing end command somewhere! Added here
  end
end

CopActionShoot.on_death_drop = function(l_12_0)
  if l_12_0._weapon_dropped then
    return 
  end
   -- DECOMPILER ERROR: unhandled construct in 'if'

  if l_12_0._shooting_hurt and stage == 2 then
    l_12_0._weapon_base:stop_autofire()
    l_12_0._ext_inventory:drop_weapon()
    l_12_0._weapon_dropped = true
    l_12_0._shooting_hurt = false
    do return end
    if l_12_0._ext_inventory then
      l_12_0._ext_inventory:drop_weapon()
      l_12_0._weapon_dropped = true
    end
  end
end

CopActionShoot.get_husk_interrupt_desc = function(l_13_0)
  local old_action_desc = {type = "shoot", body_part = 3, block_type = "action"}
  return old_action_desc
end

CopActionShoot.need_upd = function(l_14_0)
  return true
end

CopActionShoot._get_transition_target_pos = function(l_15_0, l_15_1, l_15_2, l_15_3)
  local transition = l_15_0._aim_transition
  local prog = (l_15_3 - transition.start_t) / transition.duration
  if prog > 1 then
    l_15_0._aim_transition = nil
    l_15_0._get_target_pos = nil
    return l_15_0:_get_target_pos(l_15_1, l_15_2)
  end
  prog = math.bezier(bezier_curve, prog)
  local target_pos, target_vec, target_dis, autotarget = nil, nil, nil, nil
  if l_15_2.handler then
    target_pos = temp_vec1
    mvector3.set(target_pos, l_15_2.handler:get_attention_m_pos())
    if l_15_0._shooting_player then
      autotarget = true
    elseif l_15_2.unit then
      if l_15_0._shooting_player then
        autotarget = true
      end
      target_pos = temp_vec1
      l_15_2.unit:character_damage():shoot_pos_mid(target_pos)
    else
      target_pos = l_15_2.pos
    end
  end
  target_vec = temp_vec3
  target_dis = mvec3_dir(target_vec, l_15_1, target_pos)
  mvec3_lerp(target_vec, transition.start_vec, target_vec, prog)
  return target_pos, target_vec, target_dis, autotarget
end

CopActionShoot._get_target_pos = function(l_16_0, l_16_1, l_16_2)
  local target_pos, target_vec, target_dis, autotarget = nil, nil, nil, nil
  if l_16_2.handler then
    target_pos = temp_vec1
    mvector3.set(target_pos, l_16_2.handler:get_attention_m_pos())
    if l_16_0._shooting_player then
      autotarget = true
    elseif l_16_2.unit then
      if l_16_0._shooting_player then
        autotarget = true
      end
      target_pos = temp_vec1
      l_16_2.unit:character_damage():shoot_pos_mid(target_pos)
    else
      target_pos = l_16_2.pos
    end
  end
  target_vec = temp_vec3
  target_dis = mvec3_dir(target_vec, l_16_1, target_pos)
  return target_pos, target_vec, target_dis, autotarget
end

CopActionShoot.set_ik_preset = function(l_17_0, l_17_1)
  l_17_0[l_17_0._ik_preset.stop](l_17_0)
  local preset_data = l_17_0._ik_presets[l_17_1]
  l_17_0._ik_preset = preset_data
  l_17_0[preset_data.start](l_17_0)
end

CopActionShoot._begin_ik_spine = function(l_18_0)
  if l_18_0._modifier then
    return 
  end
  l_18_0._modifier_name = Idstring("action_upper_body")
  l_18_0._modifier = l_18_0._machine:get_modifier(l_18_0._modifier_name)
  l_18_0:_set_ik_updator("_upd_ik_spine")
  l_18_0._modifier_on = nil
  l_18_0._mod_enable_t = nil
end

CopActionShoot._stop_ik_spine = function(l_19_0)
  if not l_19_0._modifier then
    return 
  end
  l_19_0._machine:allow_modifier(l_19_0._modifier_name)
  l_19_0._modifier_name = nil
  l_19_0._modifier = nil
  l_19_0._modifier_on = nil
end

CopActionShoot._upd_ik_spine = function(l_20_0, l_20_1, l_20_2, l_20_3)
  if l_20_2 > 0.5 then
    if not l_20_0._modifier_on then
      l_20_0._modifier_on = true
      l_20_0._machine:force_modifier(l_20_0._modifier_name)
      l_20_0._mod_enable_t = l_20_3 + 0.5
    end
    l_20_0._modifier:set_target_y(l_20_1)
    mvec3_set(l_20_0._common_data.look_vec, l_20_1)
    return l_20_1
  elseif l_20_0._modifier_on then
    l_20_0._modifier_on = nil
    l_20_0._machine:allow_modifier(l_20_0._modifier_name)
  end
  return nil
end

CopActionShoot._get_blend_ik_spine = function(l_21_0)
  return l_21_0._modifier:blend()
end

CopActionShoot._begin_ik_r_arm = function(l_22_0)
  if l_22_0._head_modifier then
    return 
  end
  l_22_0._head_modifier_name = Idstring("look_head")
  l_22_0._head_modifier = l_22_0._machine:get_modifier(l_22_0._head_modifier_name)
  l_22_0._r_arm_modifier_name = Idstring("aim_r_arm")
  l_22_0._r_arm_modifier = l_22_0._machine:get_modifier(l_22_0._r_arm_modifier_name)
  l_22_0._modifier_on = nil
  l_22_0._mod_enable_t = false
  l_22_0:_set_ik_updator("_upd_ik_r_arm")
end

CopActionShoot._stop_ik_r_arm = function(l_23_0)
  if not l_23_0._head_modifier then
    return 
  end
  l_23_0._machine:allow_modifier(l_23_0._head_modifier_name)
  l_23_0._machine:allow_modifier(l_23_0._r_arm_modifier_name)
  l_23_0._head_modifier_name = nil
  l_23_0._head_modifier = nil
  l_23_0._r_arm_modifier_name = nil
  l_23_0._r_arm_modifier = nil
  l_23_0._modifier_on = nil
end

CopActionShoot._upd_ik_r_arm = function(l_24_0, l_24_1, l_24_2, l_24_3)
  if l_24_2 > 0.5 then
    if not l_24_0._modifier_on then
      l_24_0._modifier_on = true
      l_24_0._machine:force_modifier(l_24_0._head_modifier_name)
      l_24_0._machine:force_modifier(l_24_0._r_arm_modifier_name)
      l_24_0._mod_enable_t = l_24_3 + 0.5
    end
    l_24_0._head_modifier:set_target_z(l_24_1)
    l_24_0._r_arm_modifier:set_target_y(l_24_1)
    mvec3_set(l_24_0._common_data.look_vec, l_24_1)
    return l_24_1
  elseif l_24_0._modifier_on then
    l_24_0._modifier_on = nil
    l_24_0._machine:allow_modifier(l_24_0._head_modifier_name)
    l_24_0._machine:allow_modifier(l_24_0._r_arm_modifier_name)
  end
  return nil
end

CopActionShoot._get_blend_ik_r_arm = function(l_25_0)
  return l_25_0._r_arm_modifier:blend()
end

CopActionShoot._set_ik_updator = function(l_26_0, l_26_1)
  l_26_0._upd_ik = l_26_0[l_26_1]
end

CopActionShoot._chk_start_melee = function(l_27_0, l_27_1, l_27_2, l_27_3, l_27_4)
  local state = l_27_0._ext_movement:play_redirect("melee")
  if state then
    local anim_speed = l_27_0._w_usage_tweak.melee_speed
    l_27_0._common_data.machine:set_speed(state, anim_speed)
    l_27_0._melee_timeout_t = TimerManager:game():time() + 1 + math.random() * 1
  else
    debug_pause_unit(l_27_0._common_data.unit, "[CopActionShoot:_chk_start_melee] redirect failed in state", l_27_0._common_data.machine:segment_state(Idstring("base")), l_27_0._common_data.unit)
  end
  return not state or true
end

CopActionShoot.anim_clbk_melee_strike = function(l_28_0)
  if not l_28_0._attention then
    return 
  end
  local shoot_from_pos = l_28_0._shoot_from_pos
  local ext_anim = l_28_0._ext_anim
  local max_dix = 165
  local target_pos, target_vec, target_dis, autotarget = l_28_0:_get_target_pos(shoot_from_pos, l_28_0._attention, TimerManager:game():time())
  if not autotarget or target_dis >= max_dix then
    return 
  end
  local min_dot = math.lerp(0, 0.40000000596046, target_dis / max_dix)
  local tar_vec_flat = temp_vec2
  mvec3_set(tar_vec_flat, target_vec)
  mvec3_set_z(tar_vec_flat, 0)
  mvec3_norm(tar_vec_flat)
  local fwd = l_28_0._common_data.fwd
  local fwd_dot = mvec3_dot(fwd, tar_vec_flat)
  if fwd_dot < min_dot then
    return 
  end
  local push_vel = target_vec:with_z(0):normalized() * 600
  local action_data = {variant = "melee", damage = l_28_0._w_usage_tweak.melee_dmg, weapon_unit = l_28_0._weapon_unit, attacker_unit = l_28_0._common_data.unit, push_vel = push_vel, col_ray = {position = shoot_from_pos + fwd * 50, ray = mvector3.copy(target_vec)}}
  local defense_data = l_28_0._attention.unit:character_damage():damage_melee(action_data)
  l_28_0._common_data.unit:sound():play("melee_hit_body", nil, nil)
end


