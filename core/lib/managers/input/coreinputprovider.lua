-- Decompiled using luadec 2.0.1 by sztupy (http://winmo.sztupy.hu)
-- Command line was: F:\SteamLibrary\SteamApps\common\PAYDAY 2\lua\core\lib\managers\input\coreinputprovider.luac 

core:module("CoreInputProvider")
core:import("CoreInputLayerDescriptionPrioritizer")
core:import("CoreInputLayer")
if not Provider then
  Provider = class()
end
Provider.init = function(l_1_0, l_1_1)
  l_1_0._layer_description_to_layer = {}
  l_1_0._input_layer_descriptions = l_1_1
  l_1_0._prioritizer = CoreInputLayerDescriptionPrioritizer.Prioritizer:new()
end

Provider.destroy = function(l_2_0)
end

Provider.context = function(l_3_0)
  local layer_description = l_3_0._prioritizer:active_layer_description()
  if not layer_description then
    return 
  end
  local layer = l_3_0._layer_description_to_layer[layer_description]
  return layer:context()
end

Provider.create_layer = function(l_4_0, l_4_1)
  local layer_description = l_4_0._input_layer_descriptions[l_4_1]
  assert(layer_description, "Illegal layer description '" .. l_4_1 .. "'")
  local layer = CoreInputLayer.Layer:new(l_4_0, layer_description)
  l_4_0._layer_description_to_layer[layer_description] = layer
  l_4_0._prioritizer:add_layer_description(layer_description)
  return layer
end

Provider._layer_destroyed = function(l_5_0, l_5_1)
  local layer_description = l_5_1:layer_description()
  l_5_0._prioritizer:remove_layer_description(layer_description)
end


