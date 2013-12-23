-- Decompiled using luadec 2.0.1 by sztupy (http://winmo.sztupy.hu)
-- Command line was: F:\SteamLibrary\SteamApps\common\PAYDAY 2\lua\lib\units\enemies\cop\actions\upper_body\copactiontase.luac 

if not CopActionTase then
  CopActionTase = class()
end
local temp_vec1 = Vector3()
local temp_vec2 = Vector3()
CopActionTase.init = function(l_1_0, l_1_1, l_1_2)
  l_1_0._common_data = l_1_2
  l_1_0._unit = l_1_2.unit
  l_1_0._ext_movement = l_1_2.ext_movement
  l_1_0._ext_anim = l_1_2.ext_anim
  l_1_0._ext_brain = l_1_2.ext_brain
  l_1_0._ext_inventory = l_1_2.ext_inventory
  l_1_0._body_part = l_1_1.body_part
  l_1_0._machine = l_1_2.machine
  l_1_0._modifier_name = Idstring("action_upper_body")
  l_1_0._modifier = l_1_0._machine:get_modifier(l_1_0._modifier_name)
  local attention = l_1_2.attention
  if (not attention or not attention.unit) and Network:is_server() then
    debug_pause("[CopActionTase:init] no attention", inspect(l_1_1))
    return 
  end
  local weapon_unit = l_1_0._ext_inventory:equipped_unit()
  l_1_0:on_attention(attention)
  if Network:is_server() then
    l_1_0._ext_movement:set_stance_by_code(3)
  end
  CopActionAct._create_blocks_table(l_1_0, l_1_1.block_desc)
  return true
end

CopActionTase.expired = function(l_2_0)
  return l_2_0._expired
end

CopActionTase.on_attention = function(l_3_0, l_3_1)
  if l_3_0._expired then
    l_3_0._attention = l_3_1
  else
    if Network:is_server() and l_3_0._attention then
      if l_3_0._discharging then
        l_3_0._tasing_local_unit:movement():on_tase_ended()
        l_3_0._discharging = nil
      end
      if l_3_0._tasing_local_unit and l_3_0._tasing_player then
        l_3_0._attention.unit:movement():on_targetted_for_attack(false, l_3_0._unit)
      end
      l_3_0._tasing_player = nil
      l_3_0._tasing_local_unit = nil
      l_3_0._expired = true
      l_3_0.update = l_3_0._upd_empty
      l_3_0._attention = l_3_1
      return 
      do return end
      if l_3_0._client_attention_set or not l_3_1 or not l_3_1.unit then
        if l_3_0._discharging then
          l_3_0._tasing_local_unit:movement():on_tase_ended()
          l_3_0._discharging = nil
        end
        if l_3_0._tasing_local_unit and l_3_0._tasing_player then
          l_3_0._tasing_local_unit:movement():on_targetted_for_attack(false, l_3_0._unit)
        end
        l_3_0._tasing_player = nil
        l_3_0._tasing_local_unit = nil
        l_3_0._attention = l_3_1
        l_3_0.update = l_3_0._upd_empty
        return 
      end
      l_3_0._client_attention_set = true
    end
  end
  local attention_unit = l_3_1.unit
  l_3_0.update = nil
  local weapon_unit = l_3_0._ext_inventory:equipped_unit()
  local weap_tweak = weapon_unit:base():weapon_tweak_data()
  local weapon_usage_tweak = l_3_0._common_data.char_tweak.weapon[weap_tweak.usage]
  l_3_0._weap_tweak = weap_tweak
  l_3_0._w_usage_tweak = weapon_usage_tweak
  l_3_0._falloff = weapon_usage_tweak.FALLOFF
  l_3_0._turn_allowed = Network:is_client()
  l_3_0._attention = l_3_1
  local t = TimerManager:game():time()
  if not l_3_1.handler or not l_3_1.handler:get_attention_m_pos() then
    local target_pos = attention_unit:movement():m_head_pos()
  end
  local shoot_from_pos = l_3_0._ext_movement:m_head_pos()
  local target_vec = target_pos - shoot_from_pos
  l_3_0._modifier:set_target_y(target_vec)
  if not weapon_usage_tweak.aim_delay_tase then
    local aim_delay = weapon_usage_tweak.aim_delay
  end
  local lerp_dis = math.min(1, target_vec:length() / l_3_0._falloff[#l_3_0._falloff].r)
  local shoot_delay = math.lerp(aim_delay[1], aim_delay[2], lerp_dis)
  l_3_0._mod_enable_t = t + shoot_delay
  l_3_0._tasing_local_unit = nil
  l_3_0._tasing_player = nil
  if Network:is_server() then
    l_3_0._common_data.ext_network:send("action_tase_start")
    if not attention_unit:base().is_husk_player then
      l_3_0._shoot_t = TimerManager:game():time() + shoot_delay
      l_3_0._tasing_local_unit = attention_unit
      l_3_0._line_of_fire_slotmask = managers.slot:get_mask("bullet_impact_targets_no_criminals")
      l_3_0._tasing_player = attention_unit:base().is_local_player
    else
      if attention_unit:base().is_local_player then
        l_3_0._shoot_t = TimerManager:game():time() + shoot_delay
        l_3_0._tasing_local_unit = attention_unit
        l_3_0._line_of_fire_slotmask = managers.slot:get_mask("bullet_impact_targets")
        l_3_0._tasing_player = true
      end
    end
  end
  if l_3_0._tasing_local_unit and l_3_0._tasing_player then
    l_3_0._tasing_local_unit:movement():on_targetted_for_attack(true, l_3_0._unit)
  end
end

CopActionTase.save = function(l_4_0, l_4_1)
  l_4_1.type = "tase"
  l_4_1.body_part = l_4_0._body_part
end

CopActionTase.on_exit = function(l_5_0)
  if l_5_0._tase_effect then
    World:effect_manager():fade_kill(l_5_0._tase_effect)
  end
  if l_5_0._discharging then
    l_5_0._tasing_local_unit:movement():on_tase_ended()
  end
  if Network:is_server() then
    l_5_0._ext_movement:set_stance_by_code(2)
  end
  if l_5_0._modifier_on then
    l_5_0._machine:allow_modifier(l_5_0._modifier_name)
  end
  if Network:is_server() then
    l_5_0._unit:network():send("action_tase_end")
    if l_5_0._expired then
      l_5_0._ext_movement:action_request({type = "idle", body_part = 3})
    end
  end
  if l_5_0._tasered_sound then
    l_5_0._tasered_sound:stop()
    l_5_0._unit:sound():play("tasered_3rd_stop", nil)
  end
  if l_5_0._tasing_local_unit and l_5_0._tasing_player then
    l_5_0._attention.unit:movement():on_targetted_for_attack(false, l_5_0._unit)
  end
  if l_5_0._malfunction_clbk_id then
    managers.enemy:remove_delayed_clbk(l_5_0._malfunction_clbk_id)
    l_5_0._malfunction_clbk_id = nil
  end
end

CopActionTase.update = function(l_6_0, l_6_1)
  if l_6_0._expired then
    return 
  end
  local shoot_from_pos = (l_6_0._ext_movement:m_head_pos())
  local target_dis = nil
  local target_vec = temp_vec1
  local target_pos = temp_vec2
  l_6_0._attention.unit:character_damage():shoot_pos_mid(target_pos)
  target_dis = mvector3.direction(target_vec, shoot_from_pos, target_pos)
  local target_vec_flat = target_vec:with_z(0)
  mvector3.normalize(target_vec_flat)
  local fwd_dot = mvector3.dot(l_6_0._common_data.fwd, target_vec_flat)
  if fwd_dot > 0.69999998807907 then
    if not l_6_0._modifier_on then
      l_6_0._modifier_on = true
      l_6_0._machine:force_modifier(l_6_0._modifier_name)
      l_6_0._mod_enable_t = l_6_1 + 0.5
    end
    l_6_0._modifier:set_target_y(target_vec)
  elseif l_6_0._modifier_on then
    l_6_0._modifier_on = nil
    l_6_0._machine:allow_modifier(l_6_0._modifier_name)
  end
  if l_6_0._turn_allowed and not l_6_0._ext_anim.walk and not l_6_0._ext_anim.turn and not l_6_0._ext_movement:chk_action_forbidden("walk") then
    local spin = target_vec:to_polar_with_reference(l_6_0._common_data.fwd, math.UP).spin
    local abs_spin = math.abs(spin)
    if abs_spin > 27 then
      local new_action_data = {}
      new_action_data.type = "turn"
      new_action_data.body_part = 2
      new_action_data.angle = spin
      l_6_0._ext_movement:action_request(new_action_data)
    end
  end
  target_vec = nil
  if not l_6_0._ext_anim.reload then
    if l_6_0._ext_anim.equip then
      do return end
    end
    if l_6_0._discharging then
      local vis_ray = l_6_0._unit:raycast("ray", shoot_from_pos, target_pos, "slot_mask", l_6_0._line_of_fire_slotmask, "ignore_unit", l_6_0._tasing_local_unit, "report")
      if not l_6_0._tasing_local_unit:movement():tased() or vis_ray then
        if Network:is_server() then
          l_6_0._expired = true
        else
          l_6_0._tasing_local_unit:movement():on_tase_ended()
          l_6_0._attention.unit:movement():on_targetted_for_attack(false, l_6_0._unit)
          l_6_0._discharging = nil
          l_6_0._tasing_player = nil
          l_6_0._tasing_local_unit = nil
          l_6_0.update = l_6_0._upd_empty
        end
      elseif l_6_0._shoot_t and target_vec and l_6_0._common_data.allow_fire and l_6_0._shoot_t < l_6_1 and l_6_0._mod_enable_t < l_6_1 then
        if l_6_0._tase_effect then
          World:effect_manager():fade_kill(l_6_0._tase_effect)
        end
        l_6_0._tase_effect = World:effect_manager():spawn({effect = Idstring("effects/payday2/particles/character/taser_thread"), parent = l_6_0._ext_inventory:equipped_unit():get_object(Idstring("fire")), force_synch = true})
        if l_6_0._tasing_local_unit and mvector3.distance(shoot_from_pos, target_pos) < l_6_0._w_usage_tweak.tase_distance then
          local record = managers.groupai:state():criminal_record(l_6_0._tasing_local_unit:key())
          if (not record or record.status or l_6_0._tasing_local_unit:movement():chk_action_forbidden("hurt")) and Network:is_server() then
            l_6_0._expired = true
            do return end
            local vis_ray = l_6_0._unit:raycast("ray", shoot_from_pos, target_pos, "slot_mask", l_6_0._line_of_fire_slotmask, "ignore_unit", l_6_0._tasing_local_unit, "report")
            if not vis_ray then
              l_6_0._common_data.ext_network:send("action_tase_fire")
              local attack_data = {attacker_unit = l_6_0._unit}
              l_6_0._attention.unit:character_damage():damage_tase(attack_data)
              l_6_0._discharging = true
              if not l_6_0._tasing_local_unit:base().is_local_player then
                l_6_0._tasered_sound = l_6_0._unit:sound():play("tasered_3rd", nil)
              end
              local redir_res = l_6_0._ext_movement:play_redirect("recoil")
              if redir_res then
                l_6_0._machine:set_parameter(redir_res, "hvy", 0)
              end
              l_6_0._shoot_t = nil
              if managers.player:has_category_upgrade("player", "taser_malfunction") then
                l_6_0._malfunction_clbk_id = "tase_malf" .. tostring(l_6_0._unit:key())
                local delay = math.random() * 2 + 1
                managers.enemy:add_delayed_clbk(l_6_0._malfunction_clbk_id, callback(l_6_0, l_6_0, "clbk_malfunction"), l_6_1 + delay)
              elseif not l_6_0._tasing_local_unit then
                l_6_0._tasered_sound = l_6_0._unit:sound():play("tasered_3rd", nil)
                local redir_res = l_6_0._ext_movement:play_redirect("recoil")
                if redir_res then
                  l_6_0._machine:set_parameter(redir_res, "hvy", 0)
                end
                l_6_0._shoot_t = nil
              end
            end
          end
        end
      end
    end
  end
end
end

CopActionTase.type = function(l_7_0)
  return "tase"
end

CopActionTase.fire_taser = function(l_8_0)
  l_8_0._shoot_t = 0
end

CopActionTase.chk_block = function(l_9_0, l_9_1, l_9_2)
  return CopActionAct.chk_block(l_9_0, l_9_1, l_9_2)
end

CopActionTase._upd_empty = function(l_10_0, l_10_1)
end

CopActionTase.need_upd = function(l_11_0)
  return true
end

CopActionTase.get_husk_interrupt_desc = function(l_12_0)
  local action_desc = {type = "tase", body_part = 3, block_type = "action"}
  return action_desc
end

CopActionTase.clbk_malfunction = function(l_13_0)
  l_13_0._malfunction_clbk_id = nil
  if l_13_0._expired then
    return 
  end
  local action_data = {variant = "melee", damage = 0, damage_effect = l_13_0._unit:character_damage()._HEALTH_INIT * 0.20000000298023, attacker_unit = l_13_0._unit, attack_dir = -l_13_0._common_data.fwd, col_ray = {position = mvector3.copy(l_13_0._ext_movement:m_head_pos()), body = l_13_0._unit:body("body")}}
  l_13_0._unit:character_damage():damage_melee(action_data)
end


