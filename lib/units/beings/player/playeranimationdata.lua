-- Decompiled using luadec 2.0.1 by sztupy (http://winmo.sztupy.hu)
-- Command line was: F:\SteamLibrary\SteamApps\common\PAYDAY 2\lua\lib\units\beings\player\playeranimationdata.luac 

if not PlayerAnimationData then
  PlayerAnimationData = class()
end
PlayerAnimationData.init = function(l_1_0, l_1_1)
  l_1_0._unit = l_1_1
end

PlayerAnimationData.anim_clbk_footstep_l = function(l_2_0, l_2_1)
  l_2_0._footstep = "l"
  l_2_1:base():anim_data_clbk_footstep("left")
end

PlayerAnimationData.anim_clbk_footstep_r = function(l_3_0, l_3_1)
  l_3_0._footstep = "r"
  l_3_1:base():anim_data_clbk_footstep("right")
end

PlayerAnimationData.anim_clbk_startfoot_l = function(l_4_0, l_4_1)
  l_4_0._footstep = "l"
end

PlayerAnimationData.anim_clbk_startfoot_r = function(l_5_0, l_5_1)
  l_5_0._footstep = "r"
end

PlayerAnimationData.foot = function(l_6_0)
  return l_6_0._footstep
end

PlayerAnimationData.anim_clbk_upper_body_empty = function(l_7_0, l_7_1)
  l_7_1:anim_state_machine():stop_segment(Idstring("upper_body"))
end

PlayerAnimationData.anim_clbk_base_empty = function(l_8_0, l_8_1)
  l_8_1:anim_state_machine():stop_segment(Idstring("base"))
end

PlayerAnimationData.anim_clbk_death_exit = function(l_9_0, l_9_1)
  l_9_1:movement():on_death_exit()
  l_9_1:base():on_death_exit()
  if l_9_1:inventory() then
    l_9_1:inventory():on_death_exit()
  end
end


