-- Decompiled using luadec 2.0.1 by sztupy (http://winmo.sztupy.hu)
-- Command line was: F:\SteamLibrary\SteamApps\common\PAYDAY 2\lua\lib\units\enemies\cop\actions\full_body\copactiondodge.luac 

if not CopActionDodge then
  CopActionDodge = class()
end
CopActionDodge._apply_freefall = CopActionWalk._apply_freefall
local l_0_0 = CopActionDodge
local l_0_1 = {}
 -- DECOMPILER ERROR: No list found. Setlist fails

 -- DECOMPILER ERROR: Overwrote pending register.

 -- DECOMPILER ERROR: Overwrote pending register.

 -- DECOMPILER ERROR: Overwrote pending register.

l_0_1, l_0_0, l_0_0._VARIATIONS = {"side_step", "dive", "roll", "r"}, CopActionDodge, l_0_1
l_0_0._SIDES = l_0_1
l_0_0 = CopActionDodge
l_0_1 = function(l_1_0, l_1_1, l_1_2)
  l_1_0._common_data = l_1_2
  l_1_0._ext_base = l_1_2.ext_base
  l_1_0._ext_movement = l_1_2.ext_movement
  l_1_0._ext_anim = l_1_2.ext_anim
  l_1_0._body_part = l_1_1.body_part
  l_1_0._unit = l_1_2.unit
  l_1_0._timeout = l_1_1.timeout
  l_1_0._machine = l_1_2.machine
  l_1_0._ids_base = Idstring("base")
  local redir_name = l_1_1.variation == "side_step" and "dodge_stand" or "dodge_crouch"
  local redir_res = l_1_0._ext_movement:play_redirect(redir_name)
  if redir_res then
    l_1_0._body_part = l_1_1.body_part
    l_1_0._descriptor = l_1_1
    l_1_0._last_vel_z = 0
    l_1_0:_determine_rotation_transition()
    l_1_0._ext_movement:set_root_blend(false)
    if l_1_1.variation ~= "side_step" then
      l_1_0._machine:set_parameter(redir_res, l_1_1.variation, 1)
    end
    if l_1_1.speed then
      l_1_0._machine:set_speed(redir_res, l_1_1.speed)
    end
    l_1_0._machine:set_parameter(redir_res, l_1_1.side, 1)
    l_1_2.ext_network:send("action_dodge_start", CopActionDodge._get_variation_index(l_1_1.variation), CopActionDodge._get_side_index(l_1_1.side), Rotation(l_1_1.direction, math.UP):yaw(), not Network:is_server() or l_1_1.speed or 1)
    l_1_0._ext_movement:enable_update()
    return true
  else
    debug_pause_unit(l_1_0._unit, "[CopActionDodge:init] redirect", redir_name, "failed in", l_1_0._machine:segment_state(Idstring("base")), l_1_2.unit)
    return 
  end
end

l_0_0.init = l_0_1
l_0_0 = CopActionDodge
l_0_1 = function(l_2_0)
  if Network:is_client() then
    l_2_0._ext_movement:set_m_host_stop_pos(l_2_0._ext_movement:m_pos())
  elseif not l_2_0._expired then
    l_2_0._common_data.ext_network:send("action_dodge_end")
  end
end

l_0_0.on_exit = l_0_1
l_0_0 = CopActionDodge
l_0_1 = function(l_3_0, l_3_1)
  if l_3_0._ext_anim.dodge then
    local dt = TimerManager:game():delta_time()
    l_3_0._last_pos = CopActionHurt._get_pos_clamped_to_graph(l_3_0)
    CopActionWalk._set_new_pos(l_3_0, dt)
    local new_rot = nil
    if l_3_0._rot_transition then
      local anim_rel_t = l_3_0._machine:segment_relative_time(l_3_0._ids_base)
      local rot_prog = anim_rel_t / l_3_0._rot_transition.end_anim_t
      if rot_prog > 1 then
        new_rot = l_3_0._rot_transition.end_rot
        l_3_0._rot_transition = nil
      else
        new_rot = l_3_0._rot_transition.start_rot:slerp(l_3_0._rot_transition.end_rot, rot_prog)
      end
    else
      new_rot = l_3_0._unit:get_animation_delta_rotation()
      new_rot = l_3_0._common_data.rot * new_rot
      mrotation.set_yaw_pitch_roll(new_rot, new_rot:yaw(), 0, 0)
    end
    l_3_0._ext_movement:set_rotation(new_rot)
  else
    l_3_0._expired = true
  end
end

l_0_0.update = l_0_1
l_0_0 = CopActionDodge
l_0_1 = function(l_4_0)
  return "dodge"
end

l_0_0.type = l_0_1
l_0_0 = CopActionDodge
l_0_1 = function(l_5_0)
  return l_5_0._expired
end

l_0_0.expired = l_0_1
l_0_0 = CopActionDodge
l_0_1 = function(l_6_0)
  return true
end

l_0_0.need_upd = l_0_1
l_0_0 = CopActionDodge
l_0_1 = function(l_7_0, l_7_1, l_7_2)
  if l_7_1 == "death" or l_7_1 == "bleedout" or l_7_1 == "fatal" then
    return false
  end
  return true
end

l_0_0.chk_block = l_0_1
l_0_0 = CopActionDodge
l_0_1 = function(l_8_0)
  return l_8_0._timeout
end

l_0_0.timeout = l_0_1
l_0_0 = CopActionDodge
l_0_1 = function(l_9_0)
  for index,test_var_name in ipairs(CopActionDodge._VARIATIONS) do
    if l_9_0 == test_var_name then
      return index
    end
  end
end

l_0_0._get_variation_index = l_0_1
l_0_0 = CopActionDodge
l_0_1 = function(l_10_0)
  return CopActionDodge._VARIATIONS[l_10_0]
end

l_0_0.get_variation_name = l_0_1
l_0_0 = CopActionDodge
l_0_1 = function(l_11_0)
  for index,test_side_name in ipairs(CopActionDodge._SIDES) do
    if l_11_0 == test_side_name then
      return index
    end
  end
end

l_0_0._get_side_index = l_0_1
l_0_0 = CopActionDodge
l_0_1 = function(l_12_0)
  return CopActionDodge._SIDES[l_12_0]
end

l_0_0.get_side_name = l_0_1
l_0_0 = CopActionDodge
l_0_1 = function(l_13_0)
  local wanted_side = l_13_0._descriptor.side
  local end_rot = Rotation(l_13_0._descriptor.direction, math.UP)
  if wanted_side == "bwd" then
    mrotation.set_yaw_pitch_roll(end_rot, mrotation.yaw(end_rot) + 180, 0, 0)
  elseif wanted_side == "l" then
    mrotation.set_yaw_pitch_roll(end_rot, mrotation.yaw(end_rot) - 90, 0, 0)
  elseif wanted_side == "r" then
    mrotation.set_yaw_pitch_roll(end_rot, mrotation.yaw(end_rot) + 90, 0, 0)
  end
  l_13_0._rot_transition = {end_rot = end_rot, start_rot = l_13_0._unit:rotation(), end_anim_t = 0.30000001192093}
end

l_0_0._determine_rotation_transition = l_0_1

