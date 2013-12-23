-- Decompiled using luadec 2.0.1 by sztupy (http://winmo.sztupy.hu)
-- Command line was: F:\SteamLibrary\SteamApps\common\PAYDAY 2\lua\lib\network\extensions\cop\huskcopmovement.luac 

if not HuskCopMovement then
  HuskCopMovement = class(CopMovement)
end
HuskCopMovement.init = function(l_1_0, l_1_1)
  CopMovement.init(l_1_0, l_1_1)
  l_1_0._queued_actions = {}
  l_1_0._m_host_stop_pos = mvector3.copy(l_1_0._m_pos)
end

HuskCopMovement._upd_actions = function(l_2_0, l_2_1)
  CopMovement._upd_actions(l_2_0, l_2_1)
  l_2_0:_chk_start_queued_action()
end

HuskCopMovement.action_request = function(l_3_0, l_3_1)
  l_3_0:enable_update(false)
  local _chk_would_interrupt = function(l_1_0)
    if self._active_actions[1] and self._active_actions[1]:type() == "idle" then
      return 
    end
    return not self._active_actions[l_1_0] and ((l_1_0 == 1 and self._active_actions[2]))
   end
  if l_3_0:chk_action_forbidden(l_3_1) or not l_3_1.client_interrupt and (next(l_3_0._queued_actions) or _chk_would_interrupt(l_3_1.body_part)) then
    l_3_0:_push_back_queued_action(l_3_1)
  else
    local new_action_body_part = l_3_1.body_part
    for body_part,active_action in ipairs(l_3_0._active_actions) do
      if ((body_part == 1 and new_action_body_part ~= 4) or new_action_body_part == 1 or body_part == new_action_body_part) then
        local old_action_desc = active_action:get_husk_interrupt_desc()
        l_3_0:_push_front_queued_action(old_action_desc)
      end
    end
    local new_action = HuskCopMovement.super.action_request(l_3_0, l_3_1)
    l_3_0:_chk_start_queued_action()
    return new_action
  end
end

HuskCopMovement.chk_action_forbidden = function(l_4_0, l_4_1)
  local t = TimerManager:game():time()
  do
    if not l_4_1.block_type then
      local block_type = l_4_1.type
    end
    for i_action,action in ipairs(l_4_0._active_actions) do
      if action and action.chk_block_client and action:chk_block_client(l_4_1, block_type, t) then
        return true
        for (for control),i_action in (for generator) do
          if action.chk_block and action:chk_block(block_type, t) then
            return true
          end
        end
      end
    end
     -- Warning: missing end command somewhere! Added here
  end
end


