-- Decompiled using luadec 2.0.1 by sztupy (http://winmo.sztupy.hu)
-- Command line was: F:\SteamLibrary\SteamApps\common\PAYDAY 2\lua\lib\units\enemies\cop\actions\upper_body\copactionreload.luac 

if not CopActionReload then
  CopActionReload = class()
end
CopActionReload.init = function(l_1_0, l_1_1, l_1_2)
  l_1_0._ext_movement = l_1_2.ext_movement
  l_1_0._ext_anim = l_1_2.ext_anim
  l_1_0._ext_inventory = l_1_2.ext_inventory
  l_1_0._body_part = l_1_1.body_part
  l_1_0._common_data = l_1_2
  l_1_0._machine = l_1_2.machine
  local reload_t = nil
  for _,other_action in ipairs(l_1_2.active_actions) do
    if other_action and other_action.reload_t then
      reload_t = other_action.reload_t
  else
    end
  end
  if reload_t or l_1_0:_play_reload() then
    local action_data = {}
    if reload_t then
      l_1_0._reload_t = reload_t
    else
      local reload_delay = 3
      l_1_0._reload_t = TimerManager:game():time() + reload_delay
    end
    local weapon_unit = l_1_0._ext_inventory:equipped_unit()
    l_1_0._weapon_unit = weapon_unit
    l_1_0._body_part = l_1_1.body_part
    l_1_0._modifier_name = Idstring("action_upper_body")
    l_1_0._modifier = l_1_0._machine:get_modifier(l_1_0._modifier_name)
    l_1_0._blocks = {light_hurt = -1}
    if l_1_0._attention then
      l_1_0._modifier_on = true
      local target_pos = nil
      if l_1_0._attention.handler then
        target_pos = l_1_0._attention.handler:get_attention_m_pos()
      else
        if l_1_0._attention.unit then
          target_pos = l_1_0._attention.unit:movement():m_head_pos()
        else
          target_pos = l_1_0._attention.pos
        end
      end
      local shoot_from_pos = l_1_2.pos + math.UP * 160
      local target_vec = target_pos - shoot_from_pos
      l_1_0._machine:force_modifier(l_1_0._modifier_name)
      l_1_0._modifier:set_target_y(target_vec)
    else
      l_1_0._modifier_on = nil
    end
    CopActionAct._create_blocks_table(l_1_0, l_1_1.blocks)
    return true
  else
    cat_print("george", "[CopActionReload:init] failed in", l_1_0._machine:segment_state(Idstring("base")))
  end
end

CopActionReload.type = function(l_2_0)
  return "reload"
end

CopActionReload.update = function(l_3_0, l_3_1)
  if l_3_0._modifier_on then
    local target_pos = nil
    if l_3_0._attention.handler then
      target_pos = l_3_0._attention.handler:get_attention_m_pos()
    else
      if l_3_0._attention.unit then
        target_pos = l_3_0._attention.unit:movement():m_head_pos()
      else
        target_pos = l_3_0._attention.pos
      end
    end
    local shoot_from_pos = math.UP * 130
    mvector3.add(shoot_from_pos, l_3_0._common_data.pos)
    local target_vec = target_pos - shoot_from_pos
    l_3_0._modifier:set_target_y(target_vec)
  end
  if l_3_0._reload_t < l_3_1 then
    l_3_0._weapon_unit:base():on_reload()
    l_3_0._expired = true
  end
  if l_3_0._ext_anim.base_need_upd then
    l_3_0._ext_movement:upd_m_head_pos()
  end
end

CopActionReload._play_reload = function(l_4_0)
  local redir_res = l_4_0._ext_movement:play_redirect("reload")
  if not redir_res then
    cat_print("george", "[CopActionReload:_play_reload] redirect failed in", l_4_0._machine:segment_state(Idstring("base")))
    return 
  end
  return redir_res
end

CopActionReload.expired = function(l_5_0)
  return l_5_0._expired
end

CopActionReload.on_attention = function(l_6_0, l_6_1)
  if l_6_1 then
    l_6_0._modifier_on = true
    l_6_0._machine:force_modifier(l_6_0._modifier_name)
  else
    l_6_0._modifier_on = nil
    l_6_0._machine:allow_modifier(l_6_0._modifier_name)
  end
  l_6_0._attention = l_6_1
end

CopActionReload.on_exit = function(l_7_0)
  if l_7_0._modifier_on then
    l_7_0._modifier_on = nil
    l_7_0._machine:allow_modifier(l_7_0._modifier_name)
  end
end

CopActionReload.chk_block = function(l_8_0, l_8_1, l_8_2)
  return CopActionAct.chk_block(l_8_0, l_8_1, l_8_2)
end

CopActionReload.need_upd = function(l_9_0)
  return true
end


