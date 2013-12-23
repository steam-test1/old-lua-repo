-- Decompiled using luadec 2.0.1 by sztupy (http://winmo.sztupy.hu)
-- Command line was: F:\SteamLibrary\SteamApps\common\PAYDAY 2\lua\core\lib\managers\session\menu_state\state\coremenustateprefrontendonce.luac 

core:module("CoreMenuStatePreFrontEndOnce")
core:import("CoreMenuStatePreFrontEnd")
core:import("CoreFiniteStateMachine")
core:import("CoreMenuStateLegal")
if not PreFrontEndOnce then
  PreFrontEndOnce = class()
end
PreFrontEndOnce.init = function(l_1_0)
  l_1_0._state = CoreFiniteStateMachine.FiniteStateMachine:new(CoreMenuStateLegal.Legal, "pre_front_end_once", l_1_0)
end

PreFrontEndOnce.transition = function(l_2_0)
  l_2_0._state:transition()
  local state = l_2_0.menu_state._game_state
  if not state:is_in_pre_front_end() or l_2_0.intro_screens_done then
    return CoreMenuStatePreFrontEnd.PreFrontEnd
  end
end


