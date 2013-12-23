-- Decompiled using luadec 2.0.1 by sztupy (http://winmo.sztupy.hu)
-- Command line was: F:\SteamLibrary\SteamApps\common\PAYDAY 2\lua\lib\units\beings\player\states\playerempty.luac 

if not PlayerEmpty then
  PlayerEmpty = class(PlayerMovementState)
end
PlayerEmpty.init = function(l_1_0, l_1_1)
  PlayerMovementState.init(l_1_0, l_1_1)
end

PlayerEmpty.enter = function(l_2_0, l_2_1, l_2_2)
  PlayerMovementState.enter(l_2_0, l_2_1)
end

PlayerEmpty.exit = function(l_3_0, l_3_1)
  PlayerMovementState.exit(l_3_0, l_3_1)
end

PlayerEmpty.update = function(l_4_0, l_4_1, l_4_2)
  PlayerMovementState.update(l_4_0, l_4_1, l_4_2)
end

PlayerEmpty.destroy = function(l_5_0)
end


