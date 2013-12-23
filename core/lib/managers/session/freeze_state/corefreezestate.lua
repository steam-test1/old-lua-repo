-- Decompiled using luadec 2.0.1 by sztupy (http://winmo.sztupy.hu)
-- Command line was: F:\SteamLibrary\SteamApps\common\PAYDAY 2\lua\core\lib\managers\session\freeze_state\corefreezestate.luac 

core:module("CoreFreezeState")
core:import("CoreFiniteStateMachine")
core:import("CoreFreezeStateMelted")
core:import("CoreSessionGenericState")
if not FreezeState then
  FreezeState = class(CoreSessionGenericState.State)
end
FreezeState.init = function(l_1_0)
  l_1_0._state = CoreFiniteStateMachine.FiniteStateMachine:new(CoreFreezeStateMelted.Melted, "freeze_state", l_1_0)
end

FreezeState.set_debug = function(l_2_0, l_2_1)
  l_2_0._state:set_debug(l_2_1)
end

FreezeState.default_data = function(l_3_0)
  l_3_0.start_state = "CoreFreezeStateMelted.Melted"
end

FreezeState.save = function(l_4_0, l_4_1)
  l_4_0._state:save(l_4_1.start_state)
end

FreezeState.transition = function(l_5_0)
  l_5_0._state:transition()
end


