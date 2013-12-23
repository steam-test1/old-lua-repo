-- Decompiled using luadec 2.0.1 by sztupy (http://winmo.sztupy.hu)
-- Command line was: F:\SteamLibrary\SteamApps\common\PAYDAY 2\lua\lib\units\enemies\cop\actions\lower_body\copactionturn.luac 

if not CopActionTurn then
  CopActionTurn = class()
end
local tmp_rot = Rotation()
local mrot_set_ypr = mrotation.set_yaw_pitch_roll
CopActionTurn.init = function(l_1_0, l_1_1, l_1_2)
  l_1_0._common_data = l_1_2
  l_1_0._ext_movement = l_1_2.ext_movement
  l_1_0._ext_anim = l_1_2.ext_anim
  l_1_0._ext_base = l_1_2.ext_base
  l_1_0._machine = l_1_2.machine
  l_1_0._action_desc = l_1_1
  l_1_0._start_pos = mvector3.copy(l_1_2.pos)
  if not l_1_0._ext_anim.idle then
    local redir_res = l_1_0._ext_movement:play_redirect("idle")
    if not redir_res then
      debug_pause("[CopActionTurn:init] idle redirect failed in", l_1_0._machine:segment_state(Idstring("base")))
      return false
    end
  end
  l_1_0.update = l_1_0._upd_wait_full_blend
  l_1_0._ext_movement:enable_update()
  CopActionAct._create_blocks_table(l_1_0, l_1_1.blocks)
  return true
end

CopActionTurn.on_exit = function(l_2_0)
  l_2_0._common_data.unit:set_driving("script")
  l_2_0._ext_movement:set_root_blend(true)
  l_2_0._ext_movement:set_position(l_2_0._start_pos)
  local end_rot = l_2_0._common_data.rot
  mrot_set_ypr(tmp_rot, mrotation.yaw(end_rot), 0, 0)
  l_2_0._ext_movement:set_rotation(tmp_rot)
end

CopActionTurn.update = function(l_3_0, l_3_1)
  if not l_3_0._ext_anim.turn and l_3_0._ext_anim.idle_full_blend then
    l_3_0._expired = true
  end
  l_3_0._ext_movement:set_m_rot(l_3_0._common_data.unit:rotation())
end

CopActionTurn._upd_wait_full_blend = function(l_4_0, l_4_1)
  if l_4_0._ext_anim.idle_full_blend then
    local angle = l_4_0._action_desc.angle
    local dir_str = angle > 0 and "l" or "r"
    local redir_name = "turn_" .. dir_str
    local redir_res = l_4_0._ext_movement:play_redirect(redir_name)
    if redir_res then
      local abs_angle = math.abs(angle)
      if abs_angle > 135 then
        l_4_0._machine:set_parameter(redir_res, "angle135", 1)
      elseif abs_angle > 90 then
        local lerp = (abs_angle - 90) / 45
        l_4_0._machine:set_parameter(redir_res, "angle135", lerp)
        l_4_0._machine:set_parameter(redir_res, "angle90", 1 - lerp)
      elseif abs_angle > 45 then
        local lerp = (abs_angle - 45) / 45
        l_4_0._machine:set_parameter(redir_res, "angle90", lerp)
        l_4_0._machine:set_parameter(redir_res, "angle45", 1 - lerp)
      else
        l_4_0._machine:set_parameter(redir_res, "angle45", 1)
      end
      local vis_state = l_4_0._ext_base:lod_stage() or 4
      if vis_state > 1 then
        l_4_0._machine:set_speed(redir_res, vis_state)
      end
      l_4_0._common_data.unit:set_driving("animation")
      l_4_0._ext_movement:set_root_blend(false)
      l_4_0._ext_base:chk_freeze_anims()
      l_4_0.update = nil
      l_4_0:update(l_4_1)
    else
      cat_print("george", "[CopActionTurn:update] ", redir_name, " redirect failed in", l_4_0._machine:segment_state(Idstring("base")))
      l_4_0._expired = true
    end
     -- Warning: missing end command somewhere! Added here
  end
end

CopActionTurn.type = function(l_5_0)
  return "turn"
end

CopActionTurn.expired = function(l_6_0)
  return l_6_0._expired
end

CopActionTurn.need_upd = function(l_7_0)
  return true
end


