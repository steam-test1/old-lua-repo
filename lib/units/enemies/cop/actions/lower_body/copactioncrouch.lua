-- Decompiled using luadec 2.0.1 by sztupy (http://winmo.sztupy.hu)
-- Command line was: F:\SteamLibrary\SteamApps\common\PAYDAY 2\lua\lib\units\enemies\cop\actions\lower_body\copactioncrouch.luac 

if not CopActionCrouch then
  CopActionCrouch = class()
end
CopActionCrouch.init = function(l_1_0, l_1_1, l_1_2)
  l_1_0._ext_movement = l_1_2.ext_movement
  local enter_t = nil
  local ext_anim = l_1_2.ext_anim
  l_1_0._ext_anim = ext_anim
  if not l_1_2.ext_movement._actions.walk._walk_anim_lengths.crouch then
    debug_pause_unit(l_1_2.unit, "unit cannot crouch!", l_1_2.unit, inspect(l_1_1), l_1_2.machine:segment_state(Idstring("base")))
    return 
  end
  if l_1_2.active_actions[2] and l_1_2.active_actions[2]._nav_link then
    debug_pause_unit(l_1_2.unit, "interrupted nav_link!", l_1_2.unit, inspect(l_1_1), l_1_2.machine:segment_state(Idstring("base")), inspect(l_1_2.ext_movement._actions[2]))
    return 
  end
  if ext_anim.move then
    local ids_base = Idstring("base")
    local seg_rel_t = (l_1_2.machine:segment_relative_time(ids_base))
    local walk_anim_length = nil
    if ext_anim.run_start_turn then
      local move_side = ext_anim.move_side
      walk_anim_length = l_1_2.ext_movement._actions.walk._walk_anim_lengths.crouch[l_1_2.stance.name].run_start_turn[move_side]
    elseif ext_anim.run_start then
      local move_side = ext_anim.move_side
      walk_anim_length = l_1_2.ext_movement._actions.walk._walk_anim_lengths.crouch[l_1_2.stance.name].run_start[move_side]
    elseif ext_anim.run_stop then
      local move_side = ext_anim.move_side
      walk_anim_length = l_1_2.ext_movement._actions.walk._walk_anim_lengths.crouch[l_1_2.stance.name].run_stop[move_side]
    else
      local pose = "crouch"
      local speed = ext_anim.run and "run" or "walk"
      local side = ext_anim.move_side
      local walk_anim_lengths = l_1_2.ext_movement._actions.walk._walk_anim_lengths
      if walk_anim_lengths then
        local walk_pose_tbl = walk_anim_lengths[pose][l_1_2.stance.name]
      end
      if walk_pose_tbl then
        local walk_speed_tbl = walk_pose_tbl[speed]
      end
      walk_anim_length = walk_speed_tbl and walk_speed_tbl[side] or 29
    end
    enter_t = seg_rel_t * (walk_anim_length)
  end
  local redir_result = l_1_2.ext_movement:play_redirect("crouch", enter_t)
  if redir_result then
    if Network:is_server() then
      l_1_2.ext_network:send("set_pose", 2)
    end
    l_1_0._ext_movement:enable_update()
    return true
  else
    cat_print("george", "[CopActionCrouch:init] failed in", l_1_2.machine:segment_state(Idstring("base")), l_1_2.unit)
  end
end

CopActionCrouch.update = function(l_2_0, l_2_1)
  if l_2_0._ext_anim.base_need_upd then
    l_2_0._ext_movement:upd_m_head_pos()
  else
    l_2_0._expired = true
  end
end

CopActionCrouch.expired = function(l_3_0)
  return l_3_0._expired
end

CopActionCrouch.type = function(l_4_0)
  return "crouch"
end


