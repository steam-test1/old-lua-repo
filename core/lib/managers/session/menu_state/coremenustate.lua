-- Decompiled using luadec 2.0.1 by sztupy (http://winmo.sztupy.hu)
-- Command line was: F:\SteamLibrary\SteamApps\common\PAYDAY 2\lua\core\lib\managers\session\menu_state\coremenustate.luac 

core:module("CoreMenuState")
core:import("CoreSessionGenericState")
core:import("CoreFiniteStateMachine")
core:import("CoreMenuStateNone")
if not MenuState then
  MenuState = class(CoreSessionGenericState.State)
end
MenuState.init = function(l_1_0, l_1_1, l_1_2, l_1_3)
  l_1_0._game_state = l_1_1
  assert(l_1_0._game_state)
  l_1_0._menu_handler = l_1_2
  l_1_0._player_slots = l_1_3
  l_1_0._state = CoreFiniteStateMachine.FiniteStateMachine:new(CoreMenuStateNone.None, "menu_state", l_1_0)
end

MenuState.set_debug = function(l_2_0, l_2_1)
  l_2_0._state:set_debug(l_2_1)
end

MenuState.default_data = function(l_3_0)
  l_3_0.start_state = "CoreMenuStateNone.None"
end

MenuState.save = function(l_4_0, l_4_1)
  l_4_0._state:save(l_4_1.start_state)
end

MenuState.transition = function(l_5_0)
  l_5_0._state:transition()
end

MenuState.game_state = function(l_6_0)
  return l_6_0._game_state
end


