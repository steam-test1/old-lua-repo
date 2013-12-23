-- Decompiled using luadec 2.0.1 by sztupy (http://winmo.sztupy.hu)
-- Command line was: F:\SteamLibrary\SteamApps\common\PAYDAY 2\lua\lib\units\enemies\cop\actions\lower_body\copactionidle.luac 

if not CopActionIdle then
  CopActionIdle = class()
end
local mvec3_dir = mvector3.direction
local mvec3_rot = mvector3.rotate_with
local mvec3_dot = mvector3.dot
local mrot_set_lookat = mrotation.set_look_at
local mrot_slerp = mrotation.slerp
local mrot_y = mrotation.y
local tmp_rot = Rotation()
local idstr_look_upper_body = Idstring("look_upper_body")
local idstr_look_head = Idstring("look_head")
local idstr_head = Idstring("Head")
CopActionIdle.init = function(l_1_0, l_1_1, l_1_2)
  if l_1_1.non_persistent then
    return 
  end
  l_1_0._common_data = l_1_2
  l_1_0._unit = l_1_2.unit
  l_1_0._ext_movement = l_1_2.ext_movement
  l_1_0._ext_anim = l_1_2.ext_anim
  l_1_0._body_part = l_1_1.body_part
  l_1_0._machine = l_1_2.machine
  if Network:is_client() then
    l_1_0._turn_allowed = true
    l_1_0._start_fwd = l_1_2.rot:y()
  end
  local res = nil
  if l_1_0._body_part == 3 and l_1_0._ext_anim.upper_body_active and not l_1_0._ext_anim.upper_body_empty then
    res = l_1_0._ext_movement:play_redirect("up_idle")
    do return end
    if l_1_1.anim then
      local state_name = l_1_0._machine:index_to_state_name(l_1_1.anim)
      local redir_res = l_1_0._ext_movement:play_state_idstr(state_name)
      if not redir_res then
        print("[CopActionIdle:init] state", state_name, "failed in", l_1_0._machine:segment_state(Idstring("base")), l_1_2.unit)
      else
        if not l_1_0._ext_anim.idle then
          res = l_1_0._ext_movement:play_redirect("idle")
          l_1_0._ext_movement:enable_update()
        end
      end
    end
  end
  if res == false then
    debug_pause_unit(l_1_0._unit, "[CopActionIdle:init] idle failed in", l_1_0._machine:segment_state(Idstring("base")), l_1_0._machine:segment_state(Idstring("upper_body")), l_1_0._unit)
    return 
  end
  l_1_0._modifier_name = l_1_0._unit:anim_data().ik_type == "head" and idstr_look_head or idstr_look_upper_body
  l_1_0._modifier = l_1_0._machine:get_modifier(l_1_0._modifier_name)
  l_1_0:on_attention(l_1_2.attention)
  if l_1_1.sync then
    l_1_0._common_data.ext_network:send("action_idle_start", l_1_0._body_part)
  end
  CopActionAct._create_blocks_table(l_1_0, l_1_1.blocks)
  return true
end

CopActionIdle.on_exit = function(l_2_0)
  if l_2_0._modifier_on then
    l_2_0._modifier_on = nil
    l_2_0._machine:forbid_modifier(l_2_0._modifier_name)
  end
  if l_2_0._modifier:blend() > 0 and l_2_0._look_vec then
    mvector3.set(l_2_0._common_data.look_vec, l_2_0._look_vec)
  end
end

CopActionIdle.update = function(l_3_0, l_3_1)
  if l_3_0._attention then
    local ik_enable = true
    local look_from_pos = l_3_0._ext_movement:m_head_pos()
    local target_vec = l_3_0._look_vec
    if l_3_0._attention.handler then
      mvec3_dir(target_vec, look_from_pos, l_3_0._attention.handler:get_detection_m_pos())
    else
      if l_3_0._attention.unit then
        mvec3_dir(target_vec, look_from_pos, l_3_0._attention.unit:movement():m_head_pos())
      else
        mvec3_dir(target_vec, look_from_pos, l_3_0._attention.pos)
      end
    end
    if l_3_0._look_trans then
      local look_trans = l_3_0._look_trans
      local prog = (l_3_1 - look_trans.start_t) / look_trans.duration
      if prog > 1 then
        l_3_0._look_trans = nil
      else
        local prog_smooth = math.bezier({0, 0, 1, 1}, prog)
        mrot_set_lookat(tmp_rot, target_vec, math.UP)
        mrot_slerp(tmp_rot, look_trans.start_rot, tmp_rot, prog_smooth)
        mrot_y(tmp_rot, target_vec)
        if mvec3_dot(target_vec, l_3_0._common_data.fwd) < 0.20000000298023 then
          ik_enable = false
        else
          if mvec3_dot(target_vec, l_3_0._common_data.fwd) < 0.20000000298023 then
            ik_enable = false
          end
        end
      end
    end
    if ik_enable then
      if not l_3_0._modifier_on then
        l_3_0._modifier_on = true
        l_3_0._machine:force_modifier(l_3_0._modifier_name)
      end
      if l_3_0._turn_allowed then
        local active_actions = l_3_0._common_data.active_actions
        local queued_actions = l_3_0._common_data.queued_actions
        if not active_actions[1] and not active_actions[2] and (not queued_actions or queued_actions[1] or not queued_actions[2]) and not l_3_0._ext_movement:chk_action_forbidden("walk") then
          local spin = target_vec:to_polar_with_reference(l_3_0._common_data.fwd, math.UP).spin
          if math.abs(spin) > 70 then
            l_3_0._rot_offset = -spin
            local new_action_data = {type = "turn", body_part = 2, angle = spin}
            l_3_0._ext_movement:action_request(new_action_data)
          elseif l_3_0._modifier_on then
            l_3_0._modifier_on = false
            l_3_0._machine:forbid_modifier(l_3_0._modifier_name)
          end
        end
      end
    end
    l_3_0._modifier:set_target_z(target_vec)
  elseif l_3_0._rot_offset then
    local new_action_data = {type = "turn", body_part = 2, angle = l_3_0._start_fwd:to_polar_with_reference(l_3_0._common_data.fwd, math.UP).spin}
    l_3_0._ext_movement:action_request(new_action_data)
    l_3_0._rot_offset = nil
  end
  if l_3_0._ext_anim.base_need_upd then
    l_3_0._ext_movement:upd_m_head_pos()
  end
end

CopActionIdle.type = function(l_4_0)
  return "idle"
end

CopActionIdle.on_attention = function(l_5_0, l_5_1)
  if l_5_0._body_part ~= 1 and l_5_0._body_part ~= 3 then
    return 
  end
  if l_5_1 then
    local shoot_from_pos = l_5_0._ext_movement:m_head_pos()
    local target_vec = Vector3()
    if l_5_1 then
      if l_5_1.handler then
        mvec3_dir(target_vec, shoot_from_pos, l_5_1.handler:get_detection_m_pos())
      elseif l_5_1.unit then
        mvec3_dir(target_vec, shoot_from_pos, l_5_1.unit:movement():m_head_pos())
      else
        mvec3_dir(target_vec, shoot_from_pos, l_5_1.pos)
      end
    end
    local start_vec = nil
    if l_5_0._modifier:blend() > 0 then
      if not l_5_0._look_vec then
        start_vec = l_5_0._common_data.look_vec
      end
    else
      start_vec = l_5_0._unit:get_object(idstr_head):rotation():z()
    end
    local duration = math.lerp(0.34999999403954, 1, target_vec:angle(start_vec) / 180)
    local start_rot = Rotation()
    mrot_set_lookat(start_rot, start_vec, math.UP)
    l_5_0._look_trans = {start_t = TimerManager:game():time(), duration = duration, start_rot = start_rot}
    l_5_0._ext_movement:enable_update()
    l_5_0._look_vec = mvector3.copy(start_vec)
  else
    l_5_0._modifier_on = nil
    l_5_0._machine:forbid_modifier(l_5_0._modifier_name)
    if l_5_0._modifier:blend() > 0 and l_5_0._look_vec then
      mvector3.set(l_5_0._common_data.look_vec, l_5_0._look_vec)
    end
  end
  l_5_0._attention = l_5_1
  l_5_0._ext_movement:enable_update()
end

CopActionIdle.need_upd = function(l_6_0)
  if l_6_0._attention and not l_6_0._attention.unit then
     -- DECOMPILER ERROR: Confused while interpreting a jump as a 'while'

  end
  return true
end
end

CopActionIdle.save = function(l_7_0, l_7_1)
  if l_7_0._body_part == 1 then
    l_7_1.is_save = true
    l_7_1.type = "idle"
    l_7_1.body_part = 1
    local state_name = l_7_0._machine:segment_state(Idstring("base"))
    local state_index = l_7_0._machine:state_name_to_index(state_name)
    l_7_1.anim = state_index
  end
end


