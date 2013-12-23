-- Decompiled using luadec 2.0.1 by sztupy (http://winmo.sztupy.hu)
-- Command line was: F:\SteamLibrary\SteamApps\common\PAYDAY 2\lua\core\lib\managers\session\menu_state\state\coremenustateingame.luac 

core:module("CoreMenuStateInGame")
core:import("CoreMenuStatePrepareLoadingFrontEnd")
if not InGame then
  InGame = class()
end
InGame.transition = function(l_1_0)
  local game_state = l_1_0.menu_state._game_state
  if game_state:is_preparing_for_loading_front_end() then
    return CoreMenuStatePrepareLoadingFrontEnd.PrepareLoadingFrontEnd
  end
end


