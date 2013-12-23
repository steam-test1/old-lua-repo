-- Decompiled using luadec 2.0.1 by sztupy (http://winmo.sztupy.hu)
-- Command line was: F:\SteamLibrary\SteamApps\common\PAYDAY 2\lua\core\lib\managers\input\coreinputlayer.luac 

core:module("CoreInputLayer")
core:import("CoreInputContextStack")
core:import("CoreInputProvider")
core:import("CoreInputContext")
if not Layer then
  Layer = class()
end
Layer.init = function(l_1_0, l_1_1, l_1_2)
  l_1_0._input_context_stack = CoreInputContextStack.Stack:new()
  l_1_0._layer_description = l_1_2
  l_1_0._input_provider = l_1_1
end

Layer.destroy = function(l_2_0)
  l_2_0._input_context_stack:destroy()
  l_2_0._input_provider:_layer_destroyed(l_2_0)
end

Layer.context = function(l_3_0)
  return l_3_0._input_context_stack:active_context()
end

Layer.layer_description = function(l_4_0)
  return l_4_0._layer_description
end

Layer.create_context = function(l_5_0)
  local context_description = l_5_0._layer_description:context_description()
  return CoreInputContext.Context:new(context_description, l_5_0._input_context_stack)
end


