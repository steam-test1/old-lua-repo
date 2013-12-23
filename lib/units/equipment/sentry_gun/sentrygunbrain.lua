-- Decompiled using luadec 2.0.1 by sztupy (http://winmo.sztupy.hu)
-- Command line was: F:\SteamLibrary\SteamApps\common\PAYDAY 2\lua\lib\units\equipment\sentry_gun\sentrygunbrain.luac 

local mvec3_dir = mvector3.direction
local mvec3_dot = mvector3.dot
local math_max = math.max
local tmp_vec1 = Vector3()
if not SentryGunBrain then
  SentryGunBrain = class()
end
SentryGunBrain._create_attention_setting_from_descriptor = PlayerMovement._create_attention_setting_from_descriptor
SentryGunBrain.init = function(l_1_0, l_1_1)
  l_1_0._unit = l_1_1
  l_1_0._active = false
  l_1_0._unit:set_extension_update_enabled(Idstring("brain"), false)
  l_1_0._AI_data = {detected_enemies = {}, detection = {dis_max = tweak_data.weapon.sentry_gun.DETECTION_RANGE}}
  l_1_0._eye_object_pos = l_1_0._unit:get_object(Idstring("a_detect")):position()
  l_1_0._visibility_slotmask = managers.slot:get_mask("AI_visibility_sentry_gun")
  l_1_0._firing = false
  l_1_0._SO_access = managers.navigation:convert_access_flag("teamAI1")
end

SentryGunBrain.post_init = function(l_2_0)
  l_2_0._ext_movement = l_2_0._unit:movement()
  l_2_0._m_head_object_pos = l_2_0._ext_movement:m_head_pos()
end

SentryGunBrain.update = function(l_3_0, l_3_1, l_3_2, l_3_3)
  if Network:is_server() then
    l_3_0:_chk_enemies_valid(l_3_2)
    l_3_0:_chk_focus_enemy_valid()
    l_3_0:_choose_focus_enemy()
  end
  l_3_0:_check_fire(l_3_2)
end

SentryGunBrain.setup = function(l_4_0, l_4_1)
  l_4_0._shaprness_mul = l_4_1
  if Network:is_server() then
    l_4_0:_setup_attention_handler()
  end
end

SentryGunBrain.is_active = function(l_5_0)
  return l_5_0._active
end

SentryGunBrain.set_active = function(l_6_0, l_6_1)
   -- DECOMPILER ERROR: Confused while interpreting a jump as a 'while'

end
l_6_1 = true
if l_6_0._active == l_6_1 then
  return 
end
l_6_0._unit:set_extension_update_enabled(Idstring("brain"), l_6_1)
l_6_0._active = l_6_1
if not l_6_1 and l_6_0._firing then
  l_6_0._unit:weapon():stop_autofire()
  l_6_0._firing = false
  if Network:is_server() then
    l_6_0._unit:network():send("cop_forbid_fire")
  end
end
if not l_6_1 and Network:is_server() then
  PlayerMovement.set_attention_settings(l_6_0, nil)
end
end

SentryGunBrain._chk_focus_enemy_valid = function(l_7_0)
  local focus_enemy = l_7_0._AI_data.focus_enemy
  if not focus_enemy then
    return 
  end
  if ((not focus_enemy.verified and not focus_enemy.verified_t) or tweak_data.weapon.sentry_gun.LOST_SIGHT_VERIFICATION * l_7_0._shaprness_mul < t - focus_enemy.verified_t or focus_enemy.unit:brain()._current_logic_name == "trade") then
    l_7_0._AI_data.focus_enemy = nil
    l_7_0._ext_movement:set_attention()
  end
end

SentryGunBrain._chk_enemies_valid = function(l_8_0, l_8_1)
  for e_key,enemy_data in pairs(l_8_0._AI_data.detected_enemies) do
    if enemy_data.death_verify_t and enemy_data.death_verify_t < l_8_1 then
      l_8_0._AI_data.detected_enemies[e_key] = nil
      if enemy_data == l_8_0._AI_data.focus_enemy then
        l_8_0._AI_data.focus_enemy = nil
        l_8_0._ext_movement:set_attention()
      end
    end
  end
end

SentryGunBrain._choose_focus_enemy = function(l_9_0, l_9_1)
  local delay = 1
  local enemies = managers.enemy:all_enemies()
  local my_tracker = l_9_0._unit:movement():nav_tracker()
  local chk_vis_func = my_tracker.check_visibility
  local my_pos = l_9_0._m_head_object_pos
  for e_key,enemy_data in pairs(enemies) do
    local enemy_unit = enemy_data.unit
    if enemy_data.is_converted or enemy_unit:brain()._current_logic_name == "trade" then
      l_9_0._AI_data.detected_enemies[e_key] = nil
      for (for control),e_key in (for generator) do
      end
      if l_9_0._AI_data.detected_enemies[e_key] then
        local enemy_data = l_9_0._AI_data.detected_enemies[e_key]
        local visible = nil
        local enemy_pos = enemy_data.m_com
        do
          local vis_ray = World:raycast("ray", my_pos, enemy_pos, "slot_mask", l_9_0._visibility_slotmask, "ray_type", "ai_vision", "report")
          if not vis_ray then
            visible = true
          end
          enemy_data.verified = visible
          if visible then
            delay = math.min(0.60000002384186, delay)
            enemy_data.verified_t = l_9_1
            enemy_data.verified_dis = mvector3.distance(enemy_pos, my_pos)
            for (for control),e_key in (for generator) do
            end
            if not enemy_data.verified_t or l_9_1 - enemy_data.verified_t > 3 then
              enemy_unit:base():remove_destroy_listener(enemy_data.destroy_clbk_key)
              enemy_unit:character_damage():remove_listener(enemy_data.death_clbk_key)
              l_9_0._AI_data.detected_enemies[e_key] = nil
            end
            for (for control),e_key in (for generator) do
            end
            if chk_vis_func(my_tracker, enemy_data.tracker) then
              local my_pos = l_9_0._m_head_object_pos
              local enemy_pos = enemy_unit:movement():m_head_pos()
              local enemy_dis = (mvector3.distance(enemy_pos, my_pos))
              local dis_multiplier = nil
              dis_multiplier = enemy_dis / l_9_0._AI_data.detection.dis_max
              if dis_multiplier < 1 then
                delay = math.min(delay, dis_multiplier)
                if not World:raycast("ray", my_pos, enemy_pos, "slot_mask", l_9_0._visibility_slotmask, "ray_type", "ai_vision", "report") then
                  local enemy_data = l_9_0:_create_enemy_detection_data(enemy_unit)
                  enemy_data.verified_t = l_9_1
                  enemy_data.verified = true
                  l_9_0._AI_data.detected_enemies[e_key] = enemy_data
                end
              end
            end
          end
        end
        local focus_enemy = l_9_0._AI_data.focus_enemy
        local cam_fwd = nil
        if focus_enemy then
          cam_fwd = tmp_vec1
          mvec3_dir(cam_fwd, my_pos, focus_enemy.m_com)
        else
          cam_fwd = l_9_0._ext_movement:m_head_fwd()
        end
        local max_dis = 15000
        local _get_weight = function(l_1_0)
          local dis = mvec3_dir(tmp_vec1, my_pos, l_1_0.m_com)
          local dis_weight = math_max(0, (max_dis - dis) / max_dis)
          local dot_weight = 1 + mvec3_dot(tmp_vec1, cam_fwd)
          return dot_weight * dot_weight * dot_weight * dis_weight
            end
        do
          local focus_enemy_weight = nil
          if focus_enemy then
            focus_enemy_weight = _get_weight(focus_enemy) * 4
          end
          for e_key,enemy_data in pairs(l_9_0._AI_data.detected_enemies) do
            if not enemy_data.death_verify_t then
              local weight = _get_weight(enemy_data)
              if not focus_enemy_weight or focus_enemy_weight < weight then
                focus_enemy_weight = weight
                focus_enemy = enemy_data
              end
            end
          end
          if l_9_0._AI_data.focus_enemy ~= focus_enemy then
            if focus_enemy then
              local attention = {unit = focus_enemy.unit}
              l_9_0._ext_movement:set_attention(attention)
            else
              l_9_0._ext_movement:set_attention()
            end
            l_9_0._AI_data.focus_enemy = focus_enemy
          end
          return delay
        end
         -- Warning: missing end command somewhere! Added here
      end
       -- Warning: missing end command somewhere! Added here
    end
     -- Warning: missing end command somewhere! Added here
  end
end

SentryGunBrain._create_enemy_detection_data = function(l_10_0, l_10_1, l_10_2)
  local destroy_clbk_key = "SentryGunBase" .. tostring(l_10_0._unit:key())
  l_10_1:base():add_destroy_listener(destroy_clbk_key, callback(l_10_0, l_10_0, "on_enemy_destroyed"))
  l_10_1:character_damage():add_listener(destroy_clbk_key, {"death"}, callback(l_10_0, l_10_0, "on_enemy_killed"))
  local enemy_m_pos = l_10_1:movement():m_pos()
  local enemy_m_head_pos = l_10_1:movement():m_head_pos()
  {key = l_10_1:key(), unit = l_10_1}.m_pos = enemy_m_pos
   -- DECOMPILER ERROR: Confused about usage of registers!

  {key = l_10_1:key(), unit = l_10_1}.m_head_pos = enemy_m_head_pos
   -- DECOMPILER ERROR: Confused about usage of registers!

  {key = l_10_1:key(), unit = l_10_1}.m_com = l_10_1:movement():m_com()
   -- DECOMPILER ERROR: Confused about usage of registers!

  {key = l_10_1:key(), unit = l_10_1}.verified_t = false
   -- DECOMPILER ERROR: Confused about usage of registers!

  {key = l_10_1:key(), unit = l_10_1}.verified = false
   -- DECOMPILER ERROR: Confused about usage of registers!

  {key = l_10_1:key(), unit = l_10_1}.destroy_clbk_key = destroy_clbk_key
   -- DECOMPILER ERROR: Confused about usage of registers!

  {key = l_10_1:key(), unit = l_10_1}.death_clbk_key = destroy_clbk_key
  do
     -- DECOMPILER ERROR: Confused at declaration of local variable

     -- DECOMPILER ERROR: Confused about usage of registers!

    return {key = l_10_1:key(), unit = l_10_1}
  end
   -- DECOMPILER ERROR: Confused about usage of registers for local variables.

end

SentryGunBrain._check_fire = function(l_11_0, l_11_1)
  if Network:is_client() and l_11_0._firing then
    l_11_0._unit:weapon():trigger_held(true, false)
  end
  return 
  local focus_enemy = l_11_0._AI_data.focus_enemy
  if l_11_0._unit:weapon():out_of_ammo() then
    l_11_0:switch_off()
  elseif focus_enemy and not l_11_0._ext_movement:warming_up(l_11_1) then
    if l_11_0._firing then
      l_11_0._unit:weapon():trigger_held(false, true)
    else
      mvec3_dir(tmp_vec1, l_11_0._eye_object_pos, focus_enemy.m_com)
      local max_dot = tweak_data.weapon.sentry_gun.KEEP_FIRE_ANGLE
      max_dot = math.min(0.99000000953674, 1 - (1 - max_dot) * l_11_0._shaprness_mul)
      if max_dot < mvec3_dot(tmp_vec1, l_11_0._ext_movement:m_head_fwd()) then
        l_11_0._unit:weapon():start_autofire()
        l_11_0._unit:weapon():trigger_held(false, true)
        l_11_0._firing = true
        l_11_0._unit:network():send("cop_allow_fire")
      elseif l_11_0._firing then
        l_11_0._unit:weapon():stop_autofire()
        l_11_0._firing = false
        l_11_0._unit:network():send("cop_forbid_fire")
      end
    end
  end
end

SentryGunBrain.on_enemy_destroyed = function(l_12_0, l_12_1)
  local destroyed_unit_key = l_12_1:key()
  l_12_0._AI_data.detected_enemies[destroyed_unit_key] = nil
  if l_12_0._AI_data.focus_enemy and l_12_0._AI_data.focus_enemy.key == destroyed_unit_key then
    l_12_0._AI_data.focus_enemy = nil
  end
end

SentryGunBrain.on_enemy_killed = function(l_13_0, l_13_1)
  local killed_unit_key = l_13_1:key()
  if l_13_0._AI_data.detected_enemies[killed_unit_key] then
    local verif_data = tweak_data.weapon.sentry_gun.DEATH_VERIFICATION
    l_13_0._AI_data.detected_enemies[killed_unit_key].death_verify_t = TimerManager:game():time() + math.lerp(verif_data[1], verif_data[2], math.random())
  end
end

SentryGunBrain.synch_allow_fire = function(l_14_0, l_14_1)
  if l_14_1 and not l_14_0._firing then
    l_14_0._unit:weapon():start_autofire()
    l_14_0._unit:weapon():trigger_held(true, false)
  elseif not l_14_1 then
    if l_14_0._unit:weapon():out_of_ammo() then
      l_14_0:switch_off()
    elseif l_14_0._firing then
      l_14_0._unit:weapon():stop_autofire()
    end
  end
  l_14_0._firing = l_14_1
end

SentryGunBrain.switch_off = function(l_15_0)
  l_15_0._unit:damage():run_sequence_simple("laser_off")
  local is_server = Network:is_server()
  if is_server then
    l_15_0._ext_movement:set_attention()
  end
  l_15_0:set_active(false)
  l_15_0._ext_movement:switch_off()
  l_15_0._unit:set_slot(26)
  managers.groupai:state():on_criminal_neutralized(l_15_0._unit)
  if Network:is_server() then
    PlayerMovement.set_attention_settings(l_15_0, nil)
  end
  l_15_0._unit:base():unregister()
end

SentryGunBrain._setup_attention_handler = function(l_16_0)
  l_16_0._attention_handler = CharacterAttentionObject:new(l_16_0._unit)
  PlayerMovement.set_attention_settings(l_16_0, {"sentry_gun_enemy_cbt"})
end

SentryGunBrain.attention_handler = function(l_17_0)
  return l_17_0._attention_handler
end

SentryGunBrain.SO_access = function(l_18_0)
  return l_18_0._SO_access
end

SentryGunBrain.save = function(l_19_0, l_19_1)
  local my_save_data = {}
  if l_19_0._firing then
    my_save_data.firing = true
  end
  if l_19_0._shaprness_mul ~= 1 then
    my_save_data.shaprness_mul = l_19_0._shaprness_mul
  end
  if next(my_save_data) then
    l_19_1.brain = my_save_data
  end
end

SentryGunBrain.load = function(l_20_0, l_20_1)
  if not l_20_1 or not l_20_1.brain then
    return 
  end
  l_20_0._shaprness_mul = l_20_1.brain.shaprness_mul or 1
  if l_20_1.brain.firing then
    l_20_0:synch_allow_fire(true)
  end
end

SentryGunBrain.pre_destroy = function(l_21_0)
  for key,enemy_data in pairs(l_21_0._AI_data.detected_enemies) do
    enemy_data.unit:base():remove_destroy_listener(enemy_data.destroy_clbk_key)
  end
  l_21_0:set_active(false)
  if Network:is_server() then
    PlayerMovement.set_attention_settings(l_21_0, nil)
  end
end


