-- Decompiled using luadec 2.0.1 by sztupy (http://winmo.sztupy.hu)
-- Command line was: F:\SteamLibrary\SteamApps\common\PAYDAY 2\lua\core\lib\managers\session\dialog_state\coredialogstate.luac 

core:module("CoreDialogState")
core:import("CoreFiniteStateMachine")
core:import("CoreDialogStateNone")
core:import("CoreSessionGenericState")
if not DialogState then
  DialogState = class(CoreSessionGenericState.State)
end
DialogState.init = function(l_1_0)
  l_1_0._state = CoreFiniteStateMachine.FiniteStateMachine:new(CoreDialogStateNone.None, "dialog_state", l_1_0)
end

DialogState.set_debug = function(l_2_0, l_2_1)
  l_2_0._state:set_debug(l_2_1)
end

DialogState.default_data = function(l_3_0)
  l_3_0.start_state = "CoreFreezeStateMelted.Melted"
end

DialogState.save = function(l_4_0, l_4_1)
  l_4_0._state:save(l_4_1.start_state)
end

DialogState.transition = function(l_5_0)
  l_5_0._state:transition()
end


