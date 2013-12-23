-- Decompiled using luadec 2.0.1 by sztupy (http://winmo.sztupy.hu)
-- Command line was: F:\SteamLibrary\SteamApps\common\PAYDAY 2\lua\core\lib\managers\session\menu_state\state\coremenustateprefrontend.luac 

core:module("CoreMenuStatePreFrontEnd")
core:import("CoreMenuStateFrontEnd")
core:import("CoreMenuStateStart")
core:import("CoreFiniteStateMachine")
if not PreFrontEnd then
  PreFrontEnd = class()
end
PreFrontEnd.init = function(l_1_0)
  l_1_0._state = CoreFiniteStateMachine.FiniteStateMachine:new(CoreMenuStateStart.Start, "pre_front_end", l_1_0)
end

PreFrontEnd.destroy = function(l_2_0)
  l_2_0._state:destroy()
end

PreFrontEnd.transition = function(l_3_0)
  l_3_0._state:transition()
  local state = l_3_0.menu_state._game_state
  if not state:is_in_pre_front_end() then
    return CoreMenuStateFrontEnd.FrontEnd
  end
end


