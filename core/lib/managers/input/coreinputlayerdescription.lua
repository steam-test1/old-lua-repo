-- Decompiled using luadec 2.0.1 by sztupy (http://winmo.sztupy.hu)
-- Command line was: F:\SteamLibrary\SteamApps\common\PAYDAY 2\lua\core\lib\managers\input\coreinputlayerdescription.luac 

core:module("CoreInputLayerDescription")
if not LayerDescription then
  LayerDescription = class()
end
LayerDescription.init = function(l_1_0, l_1_1, l_1_2)
  l_1_0._name = l_1_1
  l_1_0._priority = l_1_2
end

LayerDescription.layer_description_name = function(l_2_0)
  return l_2_0._name
end

LayerDescription.set_context_description = function(l_3_0, l_3_1)
  assert(l_3_0._context_description == nil)
  l_3_0._context_description = l_3_1
end

LayerDescription.context_description = function(l_4_0)
  assert(l_4_0._context_description, "Must specify context for this layer_description")
  return l_4_0._context_description
end

LayerDescription.priority = function(l_5_0)
  return l_5_0._priority
end


