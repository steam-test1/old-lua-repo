-- Decompiled using luadec 2.0.1 by sztupy (http://winmo.sztupy.hu)
-- Command line was: F:\SteamLibrary\SteamApps\common\PAYDAY 2\lua\lib\units\beings\player\states\playermovementstate.luac 

if not PlayerMovementState then
  PlayerMovementState = class()
end
PlayerMovementState.init = function(l_1_0, l_1_1)
  l_1_0._unit = l_1_1
end

PlayerMovementState.enter = function(l_2_0, l_2_1, l_2_2)
end

PlayerMovementState.exit = function(l_3_0, l_3_1)
end

PlayerMovementState.update = function(l_4_0, l_4_1, l_4_2)
end

PlayerMovementState.chk_action_forbidden = function(l_5_0, l_5_1)
  if l_5_0._current_action then
    local unblock_data = l_5_0._current_action.unblock_" .. l_5_1 .. "_t
    if unblock_data and (unblock_data == -1 or managers.player:player_timer():time() < unblock_data) then
      return true
    end
  end
end

PlayerMovementState._reset_delay_action = function(l_6_0)
  l_6_0._delay_action = nil
end

PlayerMovementState._set_delay_action = function(l_7_0, l_7_1)
  if l_7_0._delay_action then
    l_7_0:_reset_delay_action()
  end
  l_7_0._delay_action = l_7_1
end

PlayerMovementState._reset_current_action = function(l_8_0)
  local previous_action = l_8_0._current_action
  if previous_action and l_8_0._end_action_" .. previous_action.typ then
    l_8_0._end_action_" .. previous_action.typ(l_8_0, previous_action)
    if previous_action.root_blending_disabled then
      l_8_0._machine:set_root_blending(true)
    end
  end
  l_8_0._current_action = nil
end

PlayerMovementState._set_current_action = function(l_9_0, l_9_1)
  if l_9_0._current_action then
    l_9_0:_reset_current_action()
  end
  l_9_0._current_action = l_9_1
end

PlayerMovementState.interaction_blocked = function(l_10_0)
  return false
end

PlayerMovementState.save = function(l_11_0, l_11_1)
end

PlayerMovementState.pre_destroy = function(l_12_0)
end

PlayerMovementState.destroy = function(l_13_0)
end


