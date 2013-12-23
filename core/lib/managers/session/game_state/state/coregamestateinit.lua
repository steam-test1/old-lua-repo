-- Decompiled using luadec 2.0.1 by sztupy (http://winmo.sztupy.hu)
-- Command line was: F:\SteamLibrary\SteamApps\common\PAYDAY 2\lua\core\lib\managers\session\game_state\state\coregamestateinit.luac 

core:module("CoreGameStateInit")
core:import("CoreGameStateInEditor")
core:import("CoreGameStatePreFrontEnd")
if not Init then
  Init = class()
end
Init.init = function(l_1_0)
  l_1_0.game_state._is_in_init = true
end

Init.destroy = function(l_2_0)
  l_2_0.game_state._is_in_init = false
end

Init.transition = function(l_3_0)
  if Application:editor() then
    return CoreGameStateInEditor.InEditor
  else
    return CoreGameStatePreFrontEnd.PreFrontEnd
  end
end


